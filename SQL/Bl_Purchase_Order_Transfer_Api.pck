Create Or Replace Package Bl_Purchase_Order_Transfer_Api Is

  Procedure Send_Purchase_Order(Rowid_    Varchar2,
                                User_Id_  Varchar2,
                                A311_Key_ Varchar2);
  Procedure Send_Purchase_Order_Nextorder(Order_No_  Varchar2,
                                          User_Id_   Varchar2,
                                          A311_Key_  Varchar2,
                                          If_Change_ In Varchar2 Default '0');
End Bl_Purchase_Order_Transfer_Api;
/
Create Or Replace Package Body Bl_Purchase_Order_Transfer_Api Is
  Type t_Cursor Is Ref Cursor;
  /*
  modify by wtl  2013-02-20 只有一层的生成 交货计划
  */
  Procedure Send_Purchase_Order(Rowid_    Varchar2,
                                User_Id_  Varchar2,
                                A311_Key_ Varchar2) Is
    Row_             Bl_v_Purchase_Order%Rowtype;
    Ls_Mediacode_    Varchar2(4000);
    Ls_Message_Type_ Varchar2(4000);
    Cur_             t_Cursor;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Purchase_Order t Where t.Objid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    Ls_Message_Type_ := 'ORDERS'; -- 不知道怎么取数
    Ls_Mediacode_    := Supplier_Info_Msg_Setup_Api.Get_Default_Media_Code(Row_.Vendor_No,
                                                                           Ls_Message_Type_);
    Purchase_Order_Transfer_Api.Send_Purchase_Order(Row_.Order_No,
                                                    Ls_Mediacode_);
    Pkg_a.Setnextdo(A311_Key_,
                    '补货单下达-' || Row_.Order_No,
                    User_Id_,
                    'BL_Purchase_Order_Transfer_API.Send_Purchase_Order_nextorder(''' ||
                    Row_.Order_No || ''',''' || User_Id_ || ''',''' ||
                    A311_Key_ || ''')',
                    2 / 60 / 24);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER', Rowid_);
  End;
  Procedure Send_Purchase_Order_Nextorder(Order_No_  Varchar2,
                                          User_Id_   Varchar2,
                                          A311_Key_  Varchar2,
                                          If_Change_ In Varchar2 Default '0') Is
    Row0_   Bl_Customer_Order%Rowtype;
    Row_Co_ Customer_Order%Rowtype;
    -- row_co_line_ bl_v_customer_order_line%rowtype;
    Row_            Bl_v_Purchase_Order%Rowtype;
    Poline_         Purchase_Order_Line%Rowtype;
    Cur_            t_Cursor;
    Cur2_           t_Cursor;
    Cur_Line_       t_Cursor;
    Cur1_           t_Cursor;
    Coline_         Customer_Order_Line%Rowtype;
    Ls_Bld001_Pack  Bl_v_Purchase_Order_Line_Part.Bld001_Pack%Type;
    Ls_Order_No     Customer_Order_Line_Tab.Order_No%Type;
    Ls_Line_No      Customer_Order_Line_Tab.Line_No%Type;
    Ls_Rel_No       Customer_Order_Line_Tab.Rel_No%Type;
    Ll_Line_Item_No Customer_Order_Line_Tab.Line_Item_No%Type;
    Userrow_        Bl_Customer_Order_Line%Rowtype;
    Res_            Number;
  Begin
    --检测
    Open Cur_ For
      Select t.* From Purchase_Order_Line t Where t.Order_No = Order_No_;
    Fetch Cur_
      Into Poline_;
    Loop
      Exit When Cur_%Notfound;
      Open Cur1_ For
        Select 1
          From Customer_Order_Line_Tab t
         Where t.Demand_Order_Ref1 = Poline_.Order_No
           And t.Demand_Order_Ref2 = Poline_.Line_No
           And t.Demand_Order_Ref3 = Poline_.Release_No;
      Fetch Cur1_
        Into Res_;
      If Cur1_%Notfound Then
        --产生新的变更
        Pkg_a.Setnextdo(A311_Key_,
                        '再次操作订单-' || Order_No_,
                        User_Id_,
                        'BL_Purchase_Order_Transfer_API.Send_Purchase_Order_nextorder(''' ||
                        Order_No_ || ''',''' || User_Id_ || ''',''' ||
                        A311_Key_ || ''',''' || If_Change_ || ''')',
                        15 / 60 / 60 / 24);
        Close Cur1_;
        Close Cur_;
        Return;
      End If;
      Fetch Cur_
        Into Poline_;
    End Loop;
    Close Cur_;
    --找对应的下域的客户订单--
    Select t.*
      Into Row_
      From Bl_v_Purchase_Order t
     Where Order_No = Order_No_;
    Open Cur_ For
      Select Distinct t.*
        From Purchase_Order_Line T2
       Inner Join Customer_Order_Line_Tab T1
          On T1.Demand_Order_Ref1 = T2.Order_No
         And T1.Demand_Order_Ref2 = T2.Line_No
         And T1.Demand_Order_Ref3 = T2.Release_No
       Inner Join Customer_Order t
          On t.Order_No = T1.Order_No
       Where T2.Order_No = Order_No_;
    Fetch Cur_
      Into Row_Co_;
    While Cur_%Found Loop
      --把数据写到对应的新增表中
      Row0_.Order_No      := Row_Co_.Order_No;
      Row0_.q_Flag        := '0';
      Row0_.Blorder_Id    := '1';
      Row0_.If_First      := '1';
      Row0_.Blorder_No    := Row_.Blorder_No;
      Row0_.Bllocation_No := Row_.Bllocation_No;
      Row0_.Modi_Key      := A311_Key_;
      Bl_Customer_Order_Api.Usermodify__(Row0_, User_Id_);
      --如果存在 采购目录 就下达客户订单
      Open Cur1_ For
        Select t.*
          From Customer_Order_Line t
         Where t.Order_No = Row_Co_.Order_No
           And t.Line_Item_No <= 0
           And t.Supply_Code In (Select Id
                                   From Bl_v_Co_Supply_Code T1
                                  Where T1.Autoplan = '0');
    
      Fetch Cur1_
        Into Coline_;
      If Cur1_%Found Then
        Close Cur1_;
        --自动下达客户订单
        Bl_Customer_Order_Flow_Api.Release_Order(Rowidtochar(Row_Co_.Objid),
                                                 User_Id_,
                                                 A311_Key_,
                                                 '1',
                                                 If_Change_);
      Else
        Close Cur1_;
        --判断有没有要生成交货计划的行 如果存在 生成交货计划
        Open Cur1_ For
          Select t.*
            From Customer_Order_Line t
           Where t.Order_No = Row_Co_.Order_No
             And t.Line_Item_No <= 0
             And t.Supply_Code In
                 (Select Id
                    From Bl_v_Co_Supply_Code T1
                   Where T1.Autoplan = '1');
      
        Fetch Cur1_
          Into Coline_;
        If Cur1_%Found Then
          Bl_Customer_Order_Api.Delivery_Plan_(Row_Co_.Order_No,
                                               User_Id_,
                                               A311_Key_,
                                               If_Change_);
        End If;
        Close Cur1_;
      
      End If;
    
      /*    --如果是订单自动生成交货计划  -- 
      Bl_Customer_Order_Api.Delivery_Plan_(Row_Co_.Order_No,
                                           User_Id_,
                                           A311_Key_);*/
    
      Fetch Cur_
        Into Row_Co_;
    End Loop;
    Close Cur_;
    -- 更新明细中的包装结构
  
    Open Cur_Line_ For
      Select T2.Bld001_Pack,
             T1.Order_No,
             T1.Line_No,
             T1.Rel_No,
             T1.Line_Item_No
        From Bl_v_Purchase_Order_Line_Part T2
       Inner Join Customer_Order_Line_Tab T1
          On T1.Demand_Order_Ref1 = T2.Order_No
         And T1.Demand_Order_Ref2 = T2.Line_No
         And T1.Demand_Order_Ref3 = T2.Release_No
       Where T2.Order_No = Order_No_
         And T2.Bld001_Pack Is Not Null;
    Fetch Cur_Line_
      Into Ls_Bld001_Pack,
           Ls_Order_No,
           Ls_Line_No,
           Ls_Rel_No,
           Ll_Line_Item_No;
    While Cur_Line_%Found Loop
      Userrow_.Order_No     := Ls_Order_No;
      Userrow_.Line_No      := Ls_Line_No;
      Userrow_.Rel_No       := Ls_Rel_No;
      Userrow_.Line_Item_No := Ll_Line_Item_No;
      Userrow_.Bld001_Pack  := Ls_Bld001_Pack;
      Bl_Customer_Order_Line_Api.Usermodify__(Userrow_, User_Id_);
      Fetch Cur_Line_
        Into Ls_Bld001_Pack,
             Ls_Order_No,
             Ls_Line_No,
             Ls_Rel_No,
             Ll_Line_Item_No;
    End Loop;
    Close Cur_Line_;
  End;

End Bl_Purchase_Order_Transfer_Api;
/
