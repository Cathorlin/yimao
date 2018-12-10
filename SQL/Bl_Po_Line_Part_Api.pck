Create Or Replace Package Bl_Po_Line_Part_Api Is

  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);
  Procedure Usermodify__(Row_     In Bl_Purchase_Order_Line_Part%Rowtype,
                         User_Id_ In Varchar2);
  Procedure Confirm__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  Procedure Remove__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  Procedure Reopen__(Rowid_    Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  Procedure Set_Cancel_Reason(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);
  Procedure Unpack_Direct_Delivery(Rowlist_  Varchar2,
                                   User_Id_  Varchar2,
                                   A311_Key_ Varchar2);
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2);
  --判断当前列是否可编辑--
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2;
  ----检查 按钮 编辑 修改
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2;
End Bl_Po_Line_Part_Api;
/
Create Or Replace Package Body Bl_Po_Line_Part_Api Is
  Type t_Cursor Is Ref Cursor;
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
    Attr_       Varchar2(4000);
    Info_       Varchar2(4000);
    Objid_      Varchar2(4000);
    Objversion_ Varchar2(4000);
    Action_     Varchar2(100);
    Attr_Out    Varchar2(4000);
    Main_Row_   Bl_v_Purchase_Order%Rowtype;
    Cur_        t_Cursor;
  Begin
    --  初始化新增页面
    Action_ := 'PREPARE';
    Attr_   := Pkg_a.Get_Attr_By_Bm(Rowlist_);
    -- 默认新增的时候把抬头的含税写到明细中
    Main_Row_.Order_No := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
    Open Cur_ For
      Select t.Price_With_Tax
        From Purchase_Order t
       Where t.Order_No = Main_Row_.Order_No;
    Fetch Cur_
      Into Main_Row_.Price_With_Tax;
    Close Cur_;
    Purchase_Order_Line_Part_Api.New__(Info_,
                                       Objid_,
                                       Objversion_,
                                       Attr_,
                                       Action_);
    Attr_Out := Pkg_a.Get_Attr_By_Ifs(Attr_);
    Pkg_a.Set_Item_Value('PRICE_WITH_TAX',
                         Main_Row_.Price_With_Tax,
                         Attr_Out);
    Pkg_a.Setresult(A311_Key_, Attr_Out);
    Return;
  End;
  -- 写入新表
  Procedure Usermodify__(Row_     In Bl_Purchase_Order_Line_Part%Rowtype,
                         User_Id_ In Varchar2) Is
    Cur_  t_Cursor;
    Row0_ Bl_Purchase_Order_Line_Part%Rowtype;
  
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Purchase_Order_Line_Part t
       Where t.Order_No = Row_.Order_No
         And t.Line_No = Row_.Line_No
         And t.Release_No = Row_.Release_No;
    Fetch Cur_
      Into Row0_;
    If Cur_%Notfound Then
      Insert Into Bl_Purchase_Order_Line_Part
        (Order_No,
         Line_No,
         Release_No,
         Bld001_Pack,
         Customer_Part_No,
         Po_Identifier,
         Enter_Date,
         Enter_User,
         Reportid)
        Select Row_.Order_No,
               Row_.Line_No,
               Row_.Release_No,
               Row_.Bld001_Pack,
               Row_.Customer_Part_No,
               Row_.Po_Identifier,
               Sysdate,
               User_Id_,
               Row_.Reportid
          From Dual;
    Else
      Update Bl_Purchase_Order_Line_Part t
         Set Bld001_Pack      = Nvl(Row_.Bld001_Pack, Bld001_Pack),
             Customer_Part_No = Nvl(Row_.Customer_Part_No, Customer_Part_No),
             Po_Identifier    = Nvl(Row_.Po_Identifier, Po_Identifier),
             Modi_Date        = Sysdate,
             Modi_User        = User_Id_
       Where t.Order_No = Row_.Order_No
         And t.Line_No = Row_.Line_No
         And t.Release_No = Row_.Release_No;
    End If;
    Close Cur_;
  
  End;
  Procedure Confirm__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
    Attr_       Varchar2(4000);
    Info_       Varchar2(4000);
    Objid_      Varchar2(4000);
    Objversion_ Varchar2(4000);
    Action_     Varchar2(100);
    Cur_        t_Cursor;
  Begin
    Objid_ := Rowid_;
    Open Cur_ For
      Select Objversion
        From Bl_v_Purchase_Order_Line_Part
       Where Objid = Objid_;
    Fetch Cur_
      Into Objversion_;
    If Cur_%Notfound Then
      Close Cur_;
      Pkg_a.Setfailed(A311_Key_, 'BL_V_PURCHASE_ORDER_LINE_PART', Objid_);
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    Action_ := 'DO';
    Purchase_Order_Line_Part_Api.Confirm__(Info_,
                                           Objid_,
                                           Objversion_,
                                           Attr_,
                                           Action_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER_LINE_PART', Objid_);
  End;

  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Row_        Bl_v_Purchase_Order_Line_Part%Rowtype;
    Attr_       Varchar2(4000);
    Attr1_      Varchar2(4000);
    Info_       Varchar2(4000);
    Objid_      Varchar2(4000);
    Objversion_ Varchar2(4000);
    Action_     Varchar2(100);
    Doaction_   Varchar2(10);
    Index_      Varchar2(1);
    Cur_        t_Cursor;
    Pos_        Number;
    Pos1_       Number;
    i           Number;
    v_          Varchar2(1000);
    Column_Id_  Varchar2(4000);
    Data_       Varchar2(4000);
    Row0_       Bl_Purchase_Order_Line_Part%Rowtype;
    Mysql_      Varchar2(4000);
    Ifmychange  Varchar2(1);
  Begin
    Index_     := f_Get_Data_Index();
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Doaction_  := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    If Doaction_ = 'I' Then
      /*新增*/
      Attr_ := '';
      Client_Sys.Add_To_Attr('ORDER_NO',
                             Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('LINE_NO',
                             Pkg_a.Get_Item_Value('LINE_NO', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('RELEASE_NO',
                             Pkg_a.Get_Item_Value('RELEASE_NO', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('VENDOR_NO',
                             Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('CURRENCY_CODE',
                             Pkg_a.Get_Item_Value('CURRENCY_CODE', Rowlist_),
                             Attr_); --币种
      Client_Sys.Add_To_Attr('COMPANY',
                             Pkg_a.Get_Item_Value('COMPANY', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('PART_NO',
                             Pkg_a.Get_Item_Value('PART_NO', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('DESCRIPTION',
                             Pkg_a.Get_Item_Value('DESCRIPTION', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('BUY_QTY_DUE',
                             Pkg_a.Get_Item_Value('BUY_QTY_DUE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('BUY_UNIT_MEAS',
                             Pkg_a.Get_Item_Value('BUY_UNIT_MEAS', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('PLANNED_RECEIPT_DATE',
                             Pkg_a.Get_Item_Value('PLANNED_RECEIPT_DATE',
                                                  Rowlist_),
                             Attr_);
      --  client_sys.Add_To_Attr('PLANNED_DELIVERY_DATE','2012-08-10-00.00.00',attr_ );
      Client_Sys.Add_To_Attr('WANTED_DELIVERY_DATE',
                             Pkg_a.Get_Item_Value('WANTED_DELIVERY_DATE',
                                                  Rowlist_),
                             Attr_);
      -- client_sys.Add_To_Attr('PROMISED_DELIVERY_DATE','2012-08-10-00.00.00',attr_ );
      Client_Sys.Add_To_Attr('BUY_UNIT_PRICE',
                             Pkg_a.Get_Item_Value('BUY_UNIT_PRICE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('FBUY_UNIT_PRICE',
                             Pkg_a.Get_Item_Value('FBUY_UNIT_PRICE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('FBUY_TAX_UNIT_PRICE',
                             Pkg_a.Get_Item_Value('FBUY_TAX_UNIT_PRICE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('PRICE_UNIT_MEAS',
                             Pkg_a.Get_Item_Value('PRICE_UNIT_MEAS',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('BUY_UNIT_PRICE',
                             Pkg_a.Get_Item_Value('BUY_UNIT_PRICE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('PRICE_CONV_FACTOR',
                             Pkg_a.Get_Item_Value('PRICE_CONV_FACTOR',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('DISCOUNT',
                             Pkg_a.Get_Item_Value('DISCOUNT', Rowlist_),
                             Attr_);
      --client_sys.Add_To_Attr('ADDITIONAL_COST_AMOUNT','0',attr_ );
      Client_Sys.Add_To_Attr('TAX_AMOUNT',
                             Pkg_a.Get_Item_Value('TAX_AMOUNT', Rowlist_),
                             Attr_);
      -- client_sys.Add_To_Attr('AUTOMATIC_INVOICE_DB','MANUAL',attr_ );
      --client_sys.Add_To_Attr('BLANKET_ORDER','',attr_ );
      -- client_sys.Add_To_Attr('BLANKET_LINE','',attr_ );
      Client_Sys.Add_To_Attr('CURRENCY_RATE',
                             Pkg_a.Get_Item_Value('CURRENCY_RATE', Rowlist_),
                             Attr_); --汇率
      -- client_sys.Add_To_Attr('PURCHASE_PAYMENT_TYPE','Normal',attr_ );
      -- client_sys.Add_To_Attr('TAXABLE','FALSE',attr_ );
      --client_sys.Add_To_Attr('TAX_SHIP_ADDRESS','Not Used',attr_ );
      -- client_sys.Add_To_Attr('CLOSE_CODE','Automatic',attr_ );
      --  client_sys.Add_To_Attr('CLOSE_TOLERANCE','0',attr_ );
      Client_Sys.Add_To_Attr('RECEIVE_CASE',
                             Pkg_a.Get_Item_Value('RECEIVE_CASE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('INSPECTION_CODE',
                             Pkg_a.Get_Item_Value('INSPECTION_CODE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('SAMPLE_PERCENT',
                             Pkg_a.Get_Item_Value('SAMPLE_PERCENT',
                                                  Rowlist_),
                             Attr_);
      -- client_sys.Add_To_Attr('SAMPLE_QTY','0',attr_ );
      Client_Sys.Add_To_Attr('QC_CODE',
                             Pkg_a.Get_Item_Value('QC_CODE', Rowlist_),
                             Attr_);
      -- client_sys.Add_To_Attr('ORD_CONF_REMINDER','No Order Reminder',attr_ );
      -- client_sys.Add_To_Attr('ORD_CONF_REM_NUM','0',attr_ );
      -- client_sys.Add_To_Attr('DELIVERY_REMINDER','No Delivery Reminder',attr_ );
      -- client_sys.Add_To_Attr('DELIVERY_REM_NUM','0',attr_ );
      Client_Sys.Add_To_Attr('CONTRACT',
                             Pkg_a.Get_Item_Value('CONTRACT', Rowlist_),
                             Attr_);
      -- client_sys.Add_To_Attr('DEFAULT_ADDR_FLAG_DB','Y',attr_ );
      Client_Sys.Add_To_Attr('ADDRESS_ID', '01', Attr_);
      -- client_sys.Add_To_Attr('ADDR_FLAG_DB','N',attr_ );
      Client_Sys.Add_To_Attr('UNIT_MEAS',
                             Pkg_a.Get_Item_Value('UNIT_MEAS', Rowlist_),
                             Attr_);
      -- client_sys.Add_To_Attr('PROCESS_TYPE','',attr_ );
      --client_sys.Add_To_Attr('MANUFACTURER_ID','',attr_ );
      -- client_sys.Add_To_Attr('MANUFACTURER_PART_NO','',attr_ );
      -- client_sys.Add_To_Attr('IS_EXCHANGE_PART','FALSE',attr_ );
      -- client_sys.Add_To_Attr('EXCHANGE_ITEM_DB','ITEM NOT EXCHANGED',attr_ );
      --  client_sys.Add_To_Attr('QTY_SCRAPPED_SUPPLIER','0',attr_ );
      -- client_sys.Add_To_Attr('WARRANTY_ID','',attr_ );
      --  client_sys.Add_To_Attr('PURCHASE_SITE','11',attr_ );
      Client_Sys.Add_To_Attr('DEF_VAT_CODE',
                             Pkg_a.Get_Item_Value('DEF_VAT_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('FBUY_UNIT_PRICE',
                             Pkg_a.Get_Item_Value('FBUY_UNIT_PRICE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('BUY_UNIT_PRICE',
                             Pkg_a.Get_Item_Value('BUY_UNIT_PRICE',
                                                  Rowlist_),
                             Attr_);
      /*      if Pkg_a.Get_Item_Value('PART_NO', Rowlist_)='10000022' then 
           Raise_Application_Error(-20101, '错误的rowid');
      end if ;     */
      -- client_sys.Add_To_Attr('DATE_TYPE','PLANNED_RECEIPT_DATE',attr_ );
      Attr1_  := Attr_;
      Action_ := 'CHECK';
      Purchase_Order_Line_Part_Api.New__(Info_,
                                         Objid_,
                                         Objversion_,
                                         Attr1_,
                                         Action_);
      Action_     := 'DO';
      Info_       := '';
      Objid_      := '';
      Objversion_ := '';
      Purchase_Order_Line_Part_Api.New__(Info_,
                                         Objid_,
                                         Objversion_,
                                         Attr_,
                                         Action_);
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER_LINE_PART', Objid_);
      Row0_.Order_No         := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
      Row0_.Line_No          := Client_Sys.Get_Item_Value('LINE_NO', Attr_);
      Row0_.Release_No       := Client_Sys.Get_Item_Value('RELEASE_NO',
                                                          Attr_);
      Row0_.Bld001_Pack      := Pkg_a.Get_Item_Value('BLD001_PACK',
                                                     Rowlist_);
      Row0_.Customer_Part_No := Pkg_a.Get_Item_Value('CUSTOMER_PART_NO',
                                                     Rowlist_);
      Row0_.Po_Identifier    := Pkg_a.Get_Item_Value('PO_IDENTIFIER',
                                                     Rowlist_);
      Row0_.Reportid         := Pkg_a.Get_Item_Value('REPORTID', Rowlist_);
      Usermodify__(Row0_, User_Id_);
      Return;
    End If;
    If Doaction_ = 'M' Then
      /*修改*/
      Open Cur_ For
        Select t.*
          From Bl_v_Purchase_Order_Line_Part t
         Where t.Objid = Row_.Objid;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := 'update BL_PURCHASE_ORDER_LINE_PART  set  ';
      Ifmychange := '0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_         := Substr(Data_, 1, Pos_ - 1);
        Data_      := Substr(Data_, Pos_ + 1);
        Pos_       := Instr(Data_, Index_);
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        If Column_Id_ = 'BLD001_PACK' Or Column_Id_ = 'PO_IDENTIFIER' Or
           Column_Id_ = 'CUSTOMER_PART_NO' Or Column_Id_ = 'REPORTID' Then
          Ifmychange := '1';
          v_         := Substr(v_, Pos1_ + 1);
          Mysql_     := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
        Else
          If Column_Id_ <> 'OBJID' And Length(Nvl(Column_Id_, '')) > 0 And
             Column_Id_ <> 'DOACTION' Then
            v_ := Substr(v_, Pos1_ + 1);
            Client_Sys.Add_To_Attr(Column_Id_, v_, Attr_);
            i := i + 1;
          End If;
        End If;
      End Loop;
    
      Action_ := 'DO';
      Purchase_Order_Line_Part_Api.Modify__(Info_,
                                            Row_.Objid,
                                            Row_.Objversion,
                                            Attr_,
                                            Action_);
      --用户自定义列
      If Ifmychange = '1' Then
        Row0_.Order_No         := Row_.Order_No;
        Row0_.Line_No          := Row_.Line_No;
        Row0_.Release_No       := Row_.Release_No;
        Row0_.Bld001_Pack      := Pkg_a.Get_Item_Value('BLD001_PACK',
                                                       Rowlist_);
        Row0_.Customer_Part_No := Pkg_a.Get_Item_Value('CUSTOMER_PART_NO',
                                                       Rowlist_);
        Row0_.Po_Identifier    := Pkg_a.Get_Item_Value('PO_IDENTIFIER',
                                                       Rowlist_);
        Usermodify__(Row0_, User_Id_);
      End If;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER_LINE_PART', Objid_);
      Return;
    End If;
    If Doaction_ = 'D' Then
      --明细删除 
      Open Cur_ For
        Select t.*
          From Bl_v_Purchase_Order_Line_Part t
         Where t.Objid = Row_.Objid;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      End If;
      Close Cur_;
      Action_ := 'CHECK';
      Purchase_Order_Line_Part_Api.Remove__(Info_,
                                            Row_.Objid,
                                            Row_.Objversion,
                                            Action_);
      Action_ := 'DO';
      Purchase_Order_Line_Part_Api.Remove__(Info_,
                                            Row_.Objid,
                                            Row_.Objversion,
                                            Action_);
      Pkg_a.Setsuccess(A311_Key_,
                       'BL_V_PURCHASE_ORDER_LINE_PART',
                       Row_.Objid);
      Return;
    End If;
  End;

  Procedure Remove__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
  Begin
    Return;
  End;

  Procedure Reopen__(Rowid_    Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Attr_       Varchar2(4000);
    Info_       Varchar2(4000);
    Objid_      Varchar2(4000);
    Objversion_ Varchar2(4000);
    Action_     Varchar2(100);
    --cur_ t_cursor;
  Begin
    Objid_ := Rowid_;
    Select Objversion
      Into Objversion_
      From Bl_v_Purchase_Order_Line_Part
     Where Objid = Objid_;
    Action_ := 'DO';
    Purchase_Order_Line_Part_Api.Reopen__(Info_,
                                          Objid_,
                                          Objversion_,
                                          Attr_,
                                          Action_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER_LINE_PART', Objid_);
  End;

  Procedure Set_Cancel_Reason(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2) Is
    Row_        Bl_v_Purchase_Order_Line_Part%Rowtype;
    Cur_        t_Cursor;
    Exists_Cur_ t_Cursor;
    Row_Cur_    Purchase_Req_Line_Part%Rowtype;
    Info_       Varchar2(4000);
    Co_Row      Customer_Order_Line%Rowtype;
    A311_       A311%Rowtype;
    Po_Rowlist  Varchar2(4000);
  Begin
  
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Open Cur_ For
      Select t.*
        From Bl_v_Purchase_Order_Line_Part t
       Where Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    --取消采购订单行
    Row_.Cancel_Reason := Pkg_a.Get_Item_Value('CANCEL_REASON', Rowlist_);
    Purchase_Order_Line_Part_Api.Set_Cancel_Reason(Row_.Order_No,
                                                   Row_.Line_No,
                                                   Row_.Release_No,
                                                   Row_.Cancel_Reason);
    Open Exists_Cur_ For
      Select t.*
        From Purchase_Req_Line_Part t
       Where t.Order_No = Row_.Order_No
         And t.Assg_Line_No = Row_.Line_No
         And t.Assg_Release_No = Row_.Release_No
         And Rownum = 1;
    Fetch Exists_Cur_
      Into Row_Cur_;
    If Exists_Cur_%Notfound Then
      Purchase_Order_Line_Part_Api.Cancel_Line(Row_.Order_No,
                                               Row_.Line_No,
                                               Row_.Release_No,
                                               Info_);
    Else
      Purchase_Order_Line_Util_Api.Reopen_Requisition(Row_.Order_No,
                                                      Row_.Line_No,
                                                      Row_.Release_No);
    End If;
    Close Exists_Cur_;
    --设置成功标示
    Pkg_a.Setsuccess(A311_Key_,
                     'BL_V_PURCHASE_ORDER_LINE_PART',
                     Row_.Objid);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '订单' || Row_.Order_No || '明细行第' || Row_.Line_No || '行取消成功');
    --找对应的下域的客户订单--
    Open Cur_ For
      Select t.*
        From Customer_Order_Line t
       Where t.Demand_Order_Ref1 = Row_.Order_No
         And t.Demand_Order_Ref2 = Row_.Line_No
         And t.Demand_Order_Ref3 = Row_.Release_No;
    Fetch Cur_
      Into Co_Row;
    --取消下域的客户订单
    If Cur_%Found Then
      Close Cur_;
      A311_.A311_Id     := 'BL_PO_LINE_PART_API.Set_Cancel_Reason';
      A311_.Enter_User  := User_Id_;
      A311_.A014_Id     := 'A014_ID=OrderLine_Cancel';
      A311_.Table_Id    := 'BL_V_CUSTOMER_ORDER_LINE';
      A311_.Table_Objid := Co_Row.Objid;
      Pkg_a.Beginlog(A311_);
      Po_Rowlist := '';
      Pkg_a.Set_Item_Value('OBJID', A311_.Table_Objid, Po_Rowlist);
      Pkg_a.Set_Item_Value('CANCEL_REASON', Row_.Cancel_Reason, Po_Rowlist);
      Bl_Customer_Order_Line_Api.Set_Cancel_Reason(Po_Rowlist,
                                                   User_Id_,
                                                   A311_.A311_Key);
    Else
      Close Cur_;
    End If;
  
  End;

  Procedure Unpack_Direct_Delivery(Rowlist_  Varchar2,
                                   User_Id_  Varchar2,
                                   A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2) Is
    Attr_                   Varchar2(4000);
    Info_                   Varchar2(4000);
    Objid_                  Varchar2(4000);
    Objversion_             Varchar2(4000);
    Action_                 Varchar2(100);
    Attr_Out                Varchar2(4000);
    Row_                    Bl_v_Purchase_Order_Line_Part%Rowtype;
    Main_Row_               Bl_v_Purchase_Order%Rowtype;
    Price_Conv_Factor_      Number;
    Price_Unit_Meas_        Varchar2(20);
    Discount_               Number;
    Additional_Cost_Amount_ Number;
    Curr_Rate_              Number;
    Curr_Code_              Varchar2(20);
    Percentage_             Number;
    Cur_                    t_Cursor;
    Row1_                   Bl_Report_V02%Rowtype;
    Agreement_              Agreement_Sales_Part_Deal%Rowtype;
    Bld001_                 Bl_v_Pachage_Set_Tab%Rowtype; ----   包装标志号
    Po_                     Bl_v_Sales_Part_Cross_Ref_Line%Rowtype; ---   客户PO标识
    Customer_Par_           Sales_Part_Cross_Reference%Rowtype; --客户件号
    Partcount_              Number;
    Pocount_                Number;
    Bld001count_            Number;
  Begin
    If Column_Id_ = 'PART_NO' Or Column_Id_ = 'REPORTID' Then
      Main_Row_.Contract   := Pkg_a.Get_Item_Value('CONTRACT', Mainrowlist_);
      Main_Row_.Vendor_No  := Pkg_a.Get_Item_Value('VENDOR_NO',
                                                   Mainrowlist_);
      Row_.Reportid        := Pkg_a.Get_Item_Value('REPORTID', Rowlist_);
      Main_Row_.Label_Note := Pkg_a.Get_Item_Value('LABEL_NOTE',
                                                   Mainrowlist_);
      If Column_Id_ = 'REPORTID' Then
        Open Cur_ For
          Select t.* From Bl_Report_V02 t Where t.Reportid = Row_.Reportid;
        Fetch Cur_
          Into Row1_;
        If Cur_%Found Then
          Row_.Part_No := Row1_.Part_No;
        End If;
        Close Cur_;
      Else
        Row_.Part_No := Pkg_a.Get_Item_Value('PART_NO', Rowlist_);
      End If;
      Row_.Description     := Purchase_Part_Api.Get_Description(Main_Row_.Contract,
                                                                Row_.Part_No);
      Row_.Qc_Code         := Purchase_Part_Api.Get_Qc_Code(Main_Row_.Contract,
                                                            Row_.Part_No);
      Row_.Unit_Meas       := Purchase_Part_Supplier_Api.Get_Unit_Meas(Main_Row_.Contract,
                                                                       Row_.Part_No);
      Row_.Def_Vat_Code    := Purchase_Part_Supplier_Api.Get_Def_Vat_Code(Main_Row_.Contract,
                                                                          Row_.Part_No,
                                                                          Main_Row_.Vendor_No);
      Row_.Receive_Case    := Purchase_Part_Supplier_Api.Get_Receive_Case(Main_Row_.Contract,
                                                                          Row_.Part_No,
                                                                          Main_Row_.Vendor_No);
      Row_.Inspection_Code := Purchase_Part_Supplier_Api.Get_Inspection_Code(Main_Row_.Contract,
                                                                             Row_.Part_No,
                                                                             Main_Row_.Vendor_No);
      Row_.Sample_Percent  := Purchase_Part_Supplier_Api.Get_Sample_Percent(Main_Row_.Contract,
                                                                            Row_.Part_No,
                                                                            Main_Row_.Vendor_No);
      Pkg_a.Set_Item_Value('PART_NO', Row_.Part_No, Attr_Out);
      Pkg_a.Set_Item_Value('CONTRACT', Main_Row_.Contract, Attr_Out);
      Pkg_a.Set_Item_Value('VENDOR_NO', Main_Row_.Vendor_No, Attr_Out);
      Pkg_a.Set_Item_Value('DESCRIPTION', Row_.Description, Attr_Out);
      Pkg_a.Set_Item_Value('QC_CODE', Row_.Qc_Code, Attr_Out);
      Pkg_a.Set_Item_Value('UNIT_MEAS', Row_.Unit_Meas, Attr_Out);
      Pkg_a.Set_Item_Value('DEF_VAT_CODE', Row_.Def_Vat_Code, Attr_Out);
      Pkg_a.Set_Item_Value('RECEIVE_CASE', Row_.Receive_Case, Attr_Out);
      Pkg_a.Set_Item_Value('INSPECTION_CODE',
                           Row_.Inspection_Code,
                           Attr_Out);
      Pkg_a.Set_Item_Value('SAMPLE_PERCENT', Row_.Sample_Percent, Attr_Out);
    
      Row_.Part_No := Pkg_a.Get_Item_Value('PART_NO', Rowlist_);
    
      --客户件号
    
      Open Cur_ For
        Select t.*
          From Sales_Part_Cross_Reference t
         Where t.Customer_No = Main_Row_.Label_Note
           And t.Contract = Main_Row_.Contract
           And t.Catalog_No = Row_.Part_No;
      Fetch Cur_
        Into Customer_Par_;
      Close Cur_;
      Pkg_a.Set_Item_Value('CUSTOMER_PART_NO',
                           Customer_Par_.Customer_Part_No,
                           Attr_Out);
      -- 客户PO标识
      Open Cur_ For
        Select t.*
          From Bl_v_Sales_Part_Cross_Ref_Line t
         Where t.Contract = Main_Row_.Contract
           And t.Customer_No = Main_Row_.Label_Note
           And t.Catalog_No = Row_.Part_No
           And t.Customer_Part_No = Customer_Par_.Customer_Part_No;
      Fetch Cur_
        Into Po_;
      Close Cur_;
      ---只有一条数据 才带出
      Select Count(*)
        Into Pocount_
        From Bl_v_Sales_Part_Cross_Ref_Line t
       Where t.Contract = Main_Row_.Contract
         And t.Customer_No = Main_Row_.Label_Note
         And t.Catalog_No = Row_.Part_No;
      If Pocount_ <> 1 Then
        Pkg_a.Set_Item_Value('PO_IDENTIFIER', '', Attr_Out);
      Else
        Pkg_a.Set_Item_Value('PO_IDENTIFIER', Po_.Po_Identifier, Attr_Out);
      End If;
      -- 客户包装号
      Open Cur_ For
        Select t.*
          From Bl_v_Pachage_Set_Tab t
         Where t.Customer_No = Main_Row_.Label_Note
           And t.Catalog_No = Row_.Part_No
           And t.Contract = Main_Row_.Contract;
      Fetch Cur_
        Into Bld001_;
      Close Cur_;
      --
      Select Count(*)
        Into Bld001count_
        From Bl_v_Pachage_Set_Tab t
       Where t.Customer_No = Main_Row_.Label_Note
         And t.Catalog_No = Row_.Part_No
         And t.Contract = Main_Row_.Contract;
      If Bld001count_ <> 1 Then
        Pkg_a.Set_Item_Value('BLD001_PACK', '', Attr_Out);
      Else
        Pkg_a.Set_Item_Value('BLD001_PACK', Bld001_.Pachage_No, Attr_Out);
      End If;
    End If;
    If Column_Id_ = 'BUY_QTY_DUE' Or Column_Id_ = 'REPORTID' Then
      Row_.Contract  := Pkg_a.Get_Item_Value('CONTRACT', Mainrowlist_);
      Row_.Vendor_No := Pkg_a.Get_Item_Value('VENDOR_NO', Mainrowlist_);
      Row_.Reportid  := Pkg_a.Get_Item_Value('REPORTID', Rowlist_);
      If Column_Id_ = 'REPORTID' Then
        Open Cur_ For
          Select t.* From Bl_Report_V02 t Where t.Reportid = Row_.Reportid;
        Fetch Cur_
          Into Row1_;
        If Cur_%Found Then
          Row_.Part_No     := Row1_.Part_No;
          Row_.Buy_Qty_Due := Row1_.Check_Min_Qty * (-1);
        End If;
        Close Cur_;
      Else
        Row_.Part_No     := Pkg_a.Get_Item_Value('PART_NO', Rowlist_);
        Row_.Buy_Qty_Due := Pkg_a.Get_Item_Value('BUY_QTY_DUE', Rowlist_);
      End If;
      If Nvl(Row_.Part_No, 'NULL') = 'NULL' Then
        Raise_Application_Error(-20101, '请先录入零件号');
      End If;
      Row_.Price_With_Tax := Pkg_a.Get_Item_Value('PRICE_WITH_TAX',
                                                  Mainrowlist_);
      Purchase_Part_Supplier_Api.Get_Price_Info__(Price_Conv_Factor_      => Price_Conv_Factor_,
                                                  Price_Unit_Meas_        => Price_Unit_Meas_,
                                                  Discount_               => Discount_,
                                                  Additional_Cost_Amount_ => Additional_Cost_Amount_,
                                                  Curr_Rate_              => Curr_Rate_,
                                                  Buy_Unit_Price_         => Row_.Buy_Unit_Price,
                                                  Fbuy_Unit_Price_        => Row_.Fbuy_Unit_Price,
                                                  Curr_Code_              => Curr_Code_,
                                                  Contract_               => Row_.Contract,
                                                  Part_No_                => Row_.Part_No,
                                                  Vendor_No_              => Row_.Vendor_No,
                                                  Qty_Purchase_           => Null,
                                                  Price_Date_             => Null,
                                                  Currency_Type_          => Null,
                                                  Service_Type_           => Null,
                                                  Condition_Code_         => Null,
                                                  Exchange_Item_          => Null);
      Pkg_a.Set_Item_Value('BUY_QTY_DUE', Row_.Buy_Qty_Due, Attr_Out);
      Main_Row_.Agreement_Id := Pkg_a.Get_Item_Value('AGREEMENT_ID',
                                                     Mainrowlist_);
      If Nvl(Main_Row_.Agreement_Id, 'NULL') <> 'NULL' Then
        Open Cur_ For
          Select *
            From Agreement_Sales_Part_Deal t
           Where t.Contract = Row_.Contract
             And t.Catalog_No = Row_.Part_No
             And t.Agreement_Id = Main_Row_.Agreement_Id;
        Fetch Cur_
          Into Agreement_;
        If Cur_%Found Then
          Row_.Fbuy_Unit_Price := Agreement_.Deal_Price;
        End If;
        Close Cur_;
      End If;
      If Row_.Price_With_Tax = 'FALSE' Then
        Pkg_a.Set_Item_Value('FBUY_UNIT_PRICE',
                             Row_.Fbuy_Unit_Price,
                             Attr_Out); --价格取值不对
        Pkg_a.Set_Item_Value('BUY_UNIT_PRICE',
                             Row_.Fbuy_Unit_Price,
                             Attr_Out);
        Pkg_a.Set_Item_Value('FBUY_TAX_UNIT_PRICE',
                             Row_.Fbuy_Unit_Price,
                             Attr_Out);
      Else
        Pkg_a.Set_Item_Value('FBUY_TAX_UNIT_PRICE',
                             Row_.Fbuy_Unit_Price,
                             Attr_Out);
        Row_.Def_Vat_Code    := Pkg_a.Get_Item_Value('DEF_VAT_CODE',
                                                     Rowlist_);
        Percentage_          := Statutory_Fee_Api.Get_Percentage(Ifsapp.Site_Api.Get_Company(Row_.Contract),
                                                                 Row_.Def_Vat_Code);
        Row_.Fbuy_Unit_Price := Round(Row_.Fbuy_Unit_Price * 100 /
                                      (100 + Percentage_),
                                      2);
        Pkg_a.Set_Item_Value('FBUY_UNIT_PRICE',
                             Row_.Fbuy_Unit_Price,
                             Attr_Out); --价格取值不对
        Pkg_a.Set_Item_Value('BUY_UNIT_PRICE',
                             Row_.Fbuy_Unit_Price,
                             Attr_Out);
      End If;
      Pkg_a.Set_Item_Value('CURRENCY_CODE', Curr_Code_, Attr_Out);
      Pkg_a.Set_Item_Value('PRICE_CONV_FACTOR',
                           Price_Conv_Factor_,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CURRENCY_RATE', Curr_Rate_, Attr_Out);
    
    End If;
    If Column_Id_ = 'FBUY_UNIT_PRICE' Or Column_Id_ = 'DEF_VAT_CODE' Then
      -- 未税
      Row_.Fbuy_Unit_Price := Pkg_a.Get_Item_Value('FBUY_UNIT_PRICE',
                                                   Rowlist_);
      Row_.Def_Vat_Code    := Pkg_a.Get_Item_Value('DEF_VAT_CODE', Rowlist_);
      Row_.Contract        := Pkg_a.Get_Item_Value('CONTRACT', Mainrowlist_);
    
      Percentage_              := Statutory_Fee_Api.Get_Percentage(Ifsapp.Site_Api.Get_Company(Row_.Contract),
                                                                   Row_.Def_Vat_Code);
      Row_.Fbuy_Tax_Unit_Price := Row_.Fbuy_Unit_Price *
                                  (100 + Percentage_) / 100;
      Pkg_a.Set_Item_Value('BUY_UNIT_PRICE',
                           Row_.Fbuy_Unit_Price,
                           Attr_Out);
      Pkg_a.Set_Item_Value('FBUY_UNIT_PRICE',
                           Row_.Fbuy_Unit_Price,
                           Attr_Out);
      Pkg_a.Set_Item_Value('FBUY_TAX_UNIT_PRICE',
                           Row_.Fbuy_Tax_Unit_Price,
                           Attr_Out);
    End If;
    If Column_Id_ = 'FBUY_TAX_UNIT_PRICE' Then
      -- 未税
      Row_.Fbuy_Tax_Unit_Price := Pkg_a.Get_Item_Value('FBUY_TAX_UNIT_PRICE',
                                                       Rowlist_);
      Row_.Def_Vat_Code        := Pkg_a.Get_Item_Value('DEF_VAT_CODE',
                                                       Rowlist_);
      Row_.Contract            := Pkg_a.Get_Item_Value('CONTRACT',
                                                       Mainrowlist_);
    
      Percentage_          := Statutory_Fee_Api.Get_Percentage(Ifsapp.Site_Api.Get_Company(Row_.Contract),
                                                               Row_.Def_Vat_Code);
      Row_.Fbuy_Unit_Price := Round(Row_.Fbuy_Tax_Unit_Price * 100 /
                                    (100 + Percentage_),
                                    2);
      Pkg_a.Set_Item_Value('BUY_UNIT_PRICE',
                           Row_.Fbuy_Unit_Price,
                           Attr_Out);
      Pkg_a.Set_Item_Value('FBUY_UNIT_PRICE',
                           Row_.Fbuy_Unit_Price,
                           Attr_Out);
      Pkg_a.Set_Item_Value('FBUY_TAX_UNIT_PRICE',
                           Row_.Fbuy_Tax_Unit_Price,
                           Attr_Out);
    End If;
    Outrowlist_ := Attr_Out;
    -- pkg_a.setResult(A311_KEY_,attr_out);   
  End;
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    Cur_            t_Cursor;
    Row_            Bl_v_Purchase_Order_Line_Part%Rowtype;
    Mrow_           Purchase_Order%Rowtype;
    Vendor_No_Type_ Varchar2(10);
  Begin
    Row_.Objid          := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Row_.State          := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    Row_.Price_With_Tax := Pkg_a.Get_Item_Value('PRICE_WITH_TAX', Rowlist_);
    Row_.Contract       := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
    Row_.Vendor_No      := Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_);
    Vendor_No_Type_     := Identity_Invoice_Info_Api.Get_Identity_Type(Site_Api.Get_Company(Row_.Contract),
                                                                       Row_.Vendor_No,
                                                                       'Supplier');
    Row_.Order_No       := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
    Open Cur_ For
      Select t.* From Purchase_Order t Where t.Order_No = Row_.Order_No;
    Fetch Cur_
      Into Mrow_;
    Close Cur_;
    If Row_.Objid = '' Or Row_.Objid = 'NULL' Then
      If Column_Id_ = 'FBUY_UNIT_PRICE' Then
        --未税
        If Row_.Price_With_Tax = 'FALSE' Then
          Return '1';
        Else
          Return '0';
        End If;
      End If;
      If Column_Id_ = 'FBUY_TAX_UNIT_PRICE' Then
        -- 含税
        If Row_.Price_With_Tax = 'FALSE' Then
          Return '0';
        Else
          Return '1';
        End If;
      End If;
      Return '1';
    Else
      If Row_.State = 'Cancelled' Or Row_.State = 'Closed' Then
        Return '0';
      End If;
      If Column_Id_ = 'DESCRIPTION' Then
        If Row_.State = 'Released' Or Row_.State = 'Confirmed' Then
          Return '1';
        Else
          Return '0';
        End If;
      End If;
      If Column_Id_ = 'FBUY_UNIT_PRICE' Then
        --未税
        If Row_.Price_With_Tax = 'FALSE' Then
          Return '1';
        Else
          Return '0';
        End If;
      End If;
      If Column_Id_ = 'FBUY_TAX_UNIT_PRICE' Then
        -- 含税
        If Row_.Price_With_Tax = 'FALSE' Then
          Return '0';
        Else
          Return '1';
        End If;
      End If;
      If (Column_Id_ = 'LINE_NO' Or Column_Id_ = 'RELEASE_NO' Or
         Column_Id_ = 'PART_NO') Then
        Return '0';
      End If;
    
      --内部供应商只要不是计划状态就不能修改数量，外部供应商只有是审核状态才不可以更改数量
      If Vendor_No_Type_ = 'INTERN' Then
        --  IF Row_.State <> 'Planned'  then --modify 2013-01-30 明细没有计划状态
        If Mrow_.State <> 'Planned' Then
          Return '0';
        End If;
        /*        IF Row_.State <> 'Planned' AND Column_Id_ <> 'FBUY_UNIT_PRICE' and column_id_='FBUY_TAX_UNIT_PRICE' THEN
          RETURN '0';
        END IF;*/
      Else
        If (Row_.State = 'Authorized' Or Row_.State = 'Received' Or
           Row_.State = 'Closed' Or Row_.State = 'Arrived' Or
           Row_.State = 'Cancelled') And Column_Id_ = 'BUY_QTY_DUE' Then
          Return '0';
        End If;
      End If;
      Return '1';
    End If;
  
  End;
  ----检查新增 修改 
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2 Is
    Cur_ t_Cursor;
    Row_ Bl_v_Purchase_Order%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Purchase_Order t Where t.Order_No = Order_No_;
    Fetch Cur_
      Into Row_;
    If Cur_%Found Then
      If Row_.State <> 'Planned' And
         Identity_Invoice_Info_Api.Get_Identity_Type(Row_.Company,
                                                     Row_.Vendor_No,
                                                     'Supplier') = 'INTERN' Then
        Close Cur_;
        Return '0';
      End If;
      If Row_.State = 'Closed' Then
        Close Cur_;
        Return '0';
      End If;
    End If;
    Close Cur_;
    Return '1';
  End;
End Bl_Po_Line_Part_Api;
/
