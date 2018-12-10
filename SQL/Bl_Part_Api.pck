Create Or Replace Package Bl_Part_Api Is
  --获取货运周期
  Function Get_Shippingperiod(Location_No_ In Varchar2,
                              Contract_    In Varchar2) Return Number;

  --获取生产周期
  Function Get_Pruperido(Part_No_ In Varchar2, Contract_ In Varchar2)
    Return Number;

  --获取订舱预留周期
  Function Get_Shipdemsn(Contract_ In Varchar2) Return Number;

  --获取是否写报表历史
  Function Get_Ifsavehist(Contract_ In Varchar2) Return Number;

  --获取物料的安全库存 和上限库存
  Procedure Get_Part_Control_Qty(Part_No_     In Varchar2,
                                 Contract_    In Varchar2,
                                 Location_No_ In Varchar2,
                                 Min_Qty_     Out Number,
                                 Max_Qty_     Out Number);
  --获取库存件的信息
  Function Get_Inventory_Part_Attr_(Part_No_   In Varchar2,
                                    Contract_  In Varchar2,
                                    Column_Id_ In Varchar2) Return Varchar2;
  Function Get_On_Hand_Qty(Transaction_Id_   In Number,
                           Location_No_Key_  In Varchar2,
                           Configuration_Id_ In Varchar2,
                           Contract_         In Varchar2,
                           Part_No_          In Varchar2) Return Number;
  Function On_Hand_Qty(Location_No_Key_  In Varchar2,
                       Configuration_Id_ In Varchar2,
                       Contract_         In Varchar2,
                       Part_No_          In Varchar2) Return Number;
  --获取备货单号
  Function Get_Picklistno(Transaction_Id_ In Number) Return Varchar2;
  Function Get_On_Hand_Qty1(Transaction_Id_   In Number,
                            Location_No_Key_  In Varchar2,
                            Configuration_Id_ In Varchar2,
                            Contract_         In Varchar2,
                            Part_No_          In Varchar2) Return Number;

  --获取物料的采购提前期
  Function Get_Pur_Days(Contract_ In Varchar2, Part_No_ In Varchar2)
    Return Number;
  --mainpartno_ 最外层的产品
  --part_no_   中间件
  -- qty_      需要中间件数量
  Procedure Set_Bom_Temp(Mainpartno_ In Varchar2,
                         Contract_   In Varchar2,
                         Part_No_    In Varchar2,
                         Qty_        In Number);
End Bl_Part_Api;
/
Create Or Replace Package Body Bl_Part_Api Is

  Type t_Cursor Is Ref Cursor;
  Onhand_Dev_Cache_Contract_ Varchar2(5);

  Onhand_Dev_Cache_Part_No_   Varchar2(25);
  Onhand_Dev_Cache_Config_Id_ Varchar2(50);
  Onhand_Dev_Location_        Varchar2(50);
  Onhand_Dev_Cache_Filled_    Boolean := False;
  Onhand_Dev_Cache_Time_      Number := 0;
  Type Number_Array Is Table Of Number Index By Binary_Integer;
  Onhand_Dev_Qty_Onhand_   Number_Array;
  Onhand_Dev_Transactions_ Number_Array;
  Onhand_Dev_Acc_Quantity_ Number_Array;
  --获取货运周期
  Function Get_Shippingperiod(Location_No_ In Varchar2,
                              Contract_    In Varchar2) Return Number Is
    Result_ Number;
    Cur_    t_Cursor;
  Begin
    Open Cur_ For
      Select t.Qtydays
        From Bl_Shippingperiod t
       Where t.Location_No = Location_No_
         And t.Contract = Contract_
         And t.Begin_Date <= Sysdate
       Order By t.End_Date Desc;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Nvl(Result_, 0);
  End;

  --获取生产周期
  Function Get_Pruperido(Part_No_ In Varchar2, Contract_ In Varchar2)
    Return Number Is
    Result_ Number;
    Cur_    t_Cursor;
  Begin
    Open Cur_ For
      Select t.Qtydays
        From Bl_Pruperido t
       Where t.Part_No = Part_No_
         And t.Contract = Contract_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Nvl(Result_, 0);
  End;
  Function Get_Inventory_Part_Attr_(Part_No_   In Varchar2,
                                    Contract_  In Varchar2,
                                    Column_Id_ In Varchar2) Return Varchar2 Is
    Result_ Varchar2(200);
    Cur_    t_Cursor;
    Sql_    Varchar2(10000);
  Begin
    Sql_ := 'Select t.' || Column_Id_ ||
            ' from  INVENTORY_PART t where t.part_no=''' || Part_No_ ||
            ''' AND
      t.contract =''' || Contract_ || '''';
    Open Cur_ For Sql_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Nvl(Result_, Null);
  
  End;
  --mainpartno_ 最外层的产品
  --part_no_   中间件
  -- qty_      需要中间件数量
  Procedure Set_Bom_Temp(Mainpartno_ In Varchar2,
                         Contract_   In Varchar2,
                         Part_No_    In Varchar2,
                         Qty_        In Number) Is
    Cur_       t_Cursor;
    Structure_ Bl_Prod_Structure%Rowtype;
    Temp_      Bl_Prod_Structure_Temp%Rowtype;
    Res_       Number;
    Objid_     Varchar2(100);
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Prod_Structure t
       Where t.Part_No = Part_No_
         And t.Contract = Contract_;
    Fetch Cur_
      Into Structure_;
    If Cur_%Notfound Then
      Close Cur_;
      --找不到就插入数据
      Open Cur_ For
        Select t.Rowid
          From Bl_Prod_Structure_Temp t
         Where t.Part_No = Mainpartno_
           And t.Component_Part = Part_No_
           And t.Contract = Contract_;
      Fetch Cur_
        Into Objid_;
      If Cur_%Notfound Then
        Insert Into Bl_Prod_Structure_Temp
          (Part_No, Component_Part, Qty_Per_Assembly, Contract)
        Values
          (Mainpartno_, Part_No_, Qty_, Contract_);
      Else
        Update Bl_Prod_Structure_Temp t
           Set t.Qty_Per_Assembly = t.Qty_Per_Assembly + Qty_
         Where t.Rowid = Objid_;
      End If;
      Close Cur_;
      Return;
    End If;
    Loop
      Exit When Cur_%Notfound;
      Set_Bom_Temp(Mainpartno_,
                   Contract_,
                   Structure_.Component_Part,
                   Structure_.Qty_Per_Assembly * Qty_);
      Fetch Cur_
        Into Structure_;
    End Loop;
    Close Cur_;
  End;
  --获取物料的采购提前期
  Function Get_Pur_Days(Contract_ In Varchar2, Part_No_ In Varchar2)
    Return Number Is
    Temp_ Purchase_Part_Supplier_Tab.Vendor_Manuf_Leadtime%Type;
    Cursor Get_Attr Is
      Select Vendor_Manuf_Leadtime
        From Purchase_Part_Supplier_Tab
       Where Contract = Contract_
         And Part_No = Part_No_
         And Primary_Vendor = 'Y';
  Begin
    Open Get_Attr;
    Fetch Get_Attr
      Into Temp_;
    Close Get_Attr;
    Return Temp_;
  
  End;
  --获取是否写报表历史
  Function Get_Ifsavehist(Contract_ In Varchar2) Return Number Is
    Result_ Number;
    Cur_    t_Cursor;
  Begin
    Open Cur_ For
      Select t.If_Hist From Bl_Shipdemsn t Where t.Contract = Contract_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Nvl(Result_, '0');
  End;
  --获取订舱预留周期
  Function Get_Shipdemsn(Contract_ In Varchar2) Return Number Is
    Result_ Number;
    Cur_    t_Cursor;
  Begin
    Open Cur_ For
      Select t.Qtydays From Bl_Shipdemsn t Where t.Contract = Contract_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Nvl(Result_, 0);
  End;

  Procedure Get_Part_Control_Qty(Part_No_     In Varchar2,
                                 Contract_    In Varchar2,
                                 Location_No_ In Varchar2,
                                 Min_Qty_     Out Number,
                                 Max_Qty_     Out Number) Is
    Cur_ t_Cursor;
  Begin
    --BL_LOCATION_NO
    Open Cur_ For
      Select t.Min_Qty, t.Max_Qty
        From Bl_Location_No t
       Where t.Location_No = Location_No_
         And t.Contract = Contract_
         And t.Part_No = Part_No_;
    Fetch Cur_
      Into Min_Qty_, Max_Qty_;
    If Cur_%Notfound Then
      Min_Qty_ := 0;
      Max_Qty_ := 1000000000;
    End If;
    Close Cur_;
    Return;
  
  End;
  /*
    FUNCTION Calculate_Qty_Onhand_Date (
     transaction_id_      IN  NUMBER,
     contract_            IN  VARCHAR2,
     part_no_             IN  VARCHAR2,
     configuration_id_    IN  VARCHAR2) RETURN NUMBER
  IS
     time_       NUMBER;
     expired_    BOOLEAN;
  
     CURSOR get_transactions IS
        SELECT nvl(to_number(direction||to_char(quantity)),0), transaction_id
        FROM INVENTORY_TRANSACTION_HIST_TAB
        WHERE part_no = part_no_
        AND contract = contract_
        AND configuration_id = configuration_id_
        AND direction IN ('-', '+')
        ORDER BY transaction_id;
  
  BEGIN
     time_ := to_number(to_char(SYSDATE, 'JSSSSS')); -- Returns Julian timestamp in seconds
     expired_ := (time_ - onhand_dev_cache_time_) > 300;
  
     IF expired_ OR onhand_dev_cache_contract_ != contract_
        OR onhand_dev_cache_part_no_ != part_no_
        OR onhand_dev_cache_config_id_ != configuration_id_
        OR NOT onhand_dev_cache_filled_ THEN
  
        OPEN get_transactions;
        FETCH get_transactions BULK COLLECT INTO onhand_dev_qty_onhand_, onhand_dev_transactions_;
        CLOSE get_transactions;
        -- Set global variables
        onhand_dev_cache_contract_ := contract_;
        onhand_dev_cache_part_no_ := part_no_;
        onhand_dev_cache_config_id_ := configuration_id_;
        onhand_dev_cache_filled_ := TRUE;
        onhand_dev_cache_time_ := time_;
  
        FOR i IN onhand_dev_qty_onhand_.first..onhand_dev_qty_onhand_.last LOOP
           IF i = 1 THEN
              onhand_dev_acc_quantity_(onhand_dev_transactions_(i)) := onhand_dev_qty_onhand_(i);
           ELSE
              onhand_dev_acc_quantity_(onhand_dev_transactions_(i)) := onhand_dev_acc_quantity_(onhand_dev_transactions_(i-1)) + onhand_dev_qty_onhand_(i);
           END IF;
        END LOOP;
     END IF;
  
     IF onhand_dev_acc_quantity_.count > 0 THEN
        IF onhand_dev_acc_quantity_.EXISTS(transaction_id_) THEN
           RETURN onhand_dev_acc_quantity_(transaction_id_);
        ELSE
           RETURN 0;
        END IF;
     ELSE
        RETURN 0;
     END IF;
    */
  --获取当前trans_id 的库存量
  -- Bug 44704, start
  Function On_Hand_Qty(Location_No_Key_  In Varchar2,
                       Configuration_Id_ In Varchar2,
                       Contract_         In Varchar2,
                       Part_No_          In Varchar2) Return Number Is
    Result_ Number;
    Cursor Cur_Onhand Is
      Select Sum(t.Qty_Onhand)
        From Inventory_Part_In_Stock_Tab t
       Inner Join Inventory_Location_Tab T1
          On t.Location_No = T1.Location_No
         And T1.Contract = t.Contract
         And T1.Note_Text = Location_No_Key_
       Where t.Configuration_Id = Configuration_Id_
         And t.Part_No = Part_No_
         And t.Contract = Contract_;
  Begin
    Open Cur_Onhand;
    Fetch Cur_Onhand
      Into Result_;
    Close Cur_Onhand;
    Return Nvl(Result_, 0);
  End;
  Function Get_On_Hand_Qty1(Transaction_Id_   In Number,
                            Location_No_Key_  In Varchar2,
                            Configuration_Id_ In Varchar2,
                            Contract_         In Varchar2,
                            Part_No_          In Varchar2) Return Number Is
  
    Time_    Number;
    Expired_ Boolean;
    Cursor Cur_Onhand Is
      Select Nvl(To_Number(Direction || To_Char(Quantity)), 0),
             Transaction_Id
        From Ifsapp.Inventory_Transaction_Hist_Tab t
       Inner Join Inventory_Location_Tab T1
          On t.Location_No = T1.Location_No
         And T1.Contract = t.Contract
         And T1.Note_Text = Location_No_Key_
       Where t.Configuration_Id = Configuration_Id_
         And t.Part_No = Part_No_
         And t.Contract = Contract_
         And t.Direction In ('-', '+')
       Order By t.Date_Applied, t.Transaction_Id;
  Begin
    Time_    := To_Number(To_Char(Sysdate, 'JSSSSS')); -- Returns Julian timestamp in seconds
    Expired_ := (Time_ - Onhand_Dev_Cache_Time_) > 300;
    If Expired_ Or Onhand_Dev_Cache_Contract_ != Contract_ Or
       Onhand_Dev_Cache_Part_No_ != Part_No_ Or
       Onhand_Dev_Cache_Config_Id_ != Configuration_Id_ Or
       Onhand_Dev_Location_ != Location_No_Key_ Or
       Not Onhand_Dev_Cache_Filled_ Then
      Open Cur_Onhand;
      Fetch Cur_Onhand Bulk Collect
        Into Onhand_Dev_Qty_Onhand_, Onhand_Dev_Transactions_;
      Close Cur_Onhand;
      -- Set global variables
      Onhand_Dev_Cache_Contract_  := Contract_;
      Onhand_Dev_Cache_Part_No_   := Part_No_;
      Onhand_Dev_Cache_Config_Id_ := Configuration_Id_;
      Onhand_Dev_Cache_Filled_    := True;
      Onhand_Dev_Cache_Time_      := Time_;
      Onhand_Dev_Location_        := Location_No_Key_;
      For i In Onhand_Dev_Qty_Onhand_.First .. Onhand_Dev_Qty_Onhand_.Last Loop
        If i = 1 Then
          Onhand_Dev_Acc_Quantity_(Onhand_Dev_Transactions_(i)) := Onhand_Dev_Qty_Onhand_(i);
        Else
          Onhand_Dev_Acc_Quantity_(Onhand_Dev_Transactions_(i)) := Onhand_Dev_Acc_Quantity_(Onhand_Dev_Transactions_(i - 1)) +
                                                                   Onhand_Dev_Qty_Onhand_(i);
        End If;
      End Loop;
    End If;
    If Onhand_Dev_Acc_Quantity_.Count > 0 Then
      If Onhand_Dev_Acc_Quantity_.Exists(Transaction_Id_) Then
        Return Onhand_Dev_Acc_Quantity_(Transaction_Id_);
      Else
        Return 0;
      End If;
    Else
      Return 0;
    End If;
  End; --BL_INVENTORY_TRANSACTION_HIST 

  Function Get_On_Hand_Qty(Transaction_Id_   In Number,
                           Location_No_Key_  In Varchar2,
                           Configuration_Id_ In Varchar2,
                           Contract_         In Varchar2,
                           Part_No_          In Varchar2) Return Number Is
  
    Time_    Number;
    Expired_ Boolean;
    Cursor Cur_Onhand Is
      Select Nvl(To_Number(Direction || To_Char(Quantity)), 0),
             Transaction_Id
        From Ifsapp.Inventory_Transaction_Hist_Tab t
       Inner Join Inventory_Location_Tab T1
          On t.Location_No = T1.Location_No
         And T1.Contract = t.Contract
         And T1.Note_Text = Location_No_Key_
       Where t.Configuration_Id = Configuration_Id_
         And t.Part_No = Part_No_
         And t.Contract = Contract_
         And t.Direction In ('-', '+')
       Order By t.Transaction_Id;
  Begin
    Time_    := To_Number(To_Char(Sysdate, 'JSSSSS')); -- Returns Julian timestamp in seconds
    Expired_ := (Time_ - Onhand_Dev_Cache_Time_) > 300;
    If Expired_ Or Onhand_Dev_Cache_Contract_ != Contract_ Or
       Onhand_Dev_Cache_Part_No_ != Part_No_ Or
       Onhand_Dev_Cache_Config_Id_ != Configuration_Id_ Or
       Onhand_Dev_Location_ != Location_No_Key_ Or
       Not Onhand_Dev_Cache_Filled_ Then
      Open Cur_Onhand;
      Fetch Cur_Onhand Bulk Collect
        Into Onhand_Dev_Qty_Onhand_, Onhand_Dev_Transactions_;
      Close Cur_Onhand;
      -- Set global variables
      Onhand_Dev_Cache_Contract_  := Contract_;
      Onhand_Dev_Cache_Part_No_   := Part_No_;
      Onhand_Dev_Cache_Config_Id_ := Configuration_Id_;
      Onhand_Dev_Cache_Filled_    := True;
      Onhand_Dev_Cache_Time_      := Time_;
      Onhand_Dev_Location_        := Location_No_Key_;
      For i In Onhand_Dev_Qty_Onhand_.First .. Onhand_Dev_Qty_Onhand_.Last Loop
        If i = 1 Then
          Onhand_Dev_Acc_Quantity_(Onhand_Dev_Transactions_(i)) := Onhand_Dev_Qty_Onhand_(i);
        Else
          Onhand_Dev_Acc_Quantity_(Onhand_Dev_Transactions_(i)) := Onhand_Dev_Acc_Quantity_(Onhand_Dev_Transactions_(i - 1)) +
                                                                   Onhand_Dev_Qty_Onhand_(i);
        End If;
      End Loop;
    End If;
    If Onhand_Dev_Acc_Quantity_.Count > 0 Then
      If Onhand_Dev_Acc_Quantity_.Exists(Transaction_Id_) Then
        Return Onhand_Dev_Acc_Quantity_(Transaction_Id_);
      Else
        Return 0;
      End If;
    Else
      Return 0;
    End If;
  End; --BL_INVENTORY_TRANSACTION_HIST 
  --获取备货单号
  Function Get_Picklistno(Transaction_Id_ In Number) Return Varchar2 Is
    Result_ Varchar2(100);
    Cursor t_Cur Is
      Select t.Picklistno
        From Bl_Plinv_Reg_Dtl_Tab t
       Where t.Transaction_Id = Transaction_Id_;
    Cursor t_Cur1 Is
      Select t.Picklistno
        From Bl_Pltrans t
       Where t.Transid = Transaction_Id_;
    Cursor t_Cur2 Is
      Select t.Inspect_No
        From Bl_Purrenturn_Dtl_Tab t
       Where t.Transaction_Id = Transaction_Id_;
  Begin
    Open t_Cur;
    Fetch t_Cur
      Into Result_;
    If t_Cur%Notfound Then
      Open t_Cur1;
      Fetch t_Cur1
        Into Result_;
      If t_Cur1%Notfound Then
        Open t_Cur2;
        Fetch t_Cur2
          Into Result_;
        Close t_Cur2;
      End If;
      Close t_Cur1;
    End If;
  
    Close t_Cur;
  
    Return Result_;
  
  End;
End Bl_Part_Api;
/
