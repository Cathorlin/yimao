CREATE OR REPLACE Package Bl_Purchase_Order_Api Is

  Procedure Approve__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  Procedure Approve1__(Rowid_    Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  Procedure Revoke_Approve__(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2);
  Procedure Revoke_Approve1__(Rowid_    Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);
  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  Procedure Close__(Rowid_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);
  Procedure Confirm__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  Procedure Freeze__(Rowid_    Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);
  Procedure Release__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  Procedure User_Requisition_Line_To_Order(Rowlist_  Varchar2,
                                           User_Id_  Varchar2,
                                           A311_Key_ Varchar2);
  --modify fjp 2013-03-06明细一起生成采购订单                                         
  Procedure User_Req_Line_To_Order(Rowlist_  Varchar2,
                                   User_Id_  Varchar2,
                                   A311_Key_ Varchar2);
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2);
  Procedure Usermodify__(Row_     In Bl_Purchase_Order%Rowtype,
                         User_Id_ In Varchar2);

  --判断当前列是否可编辑--
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2;
  ----检查 按钮 编辑 修改
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2;
  Function Getfeeamount(Order_No_ In Varchar2, Ls_Type_ In Varchar2)
    Return Number;
  Function Getvendorno_User(Contract_  In Varchar2,
                            Vendor_No_ In Varchar2,
                            Uesr_Id_   In Varchar2) Return Varchar2;
  --获取date的 采购数量
  Function Get_Part_Qty_Receipts_Date(Contract_ In Varchar2,
                                      Part_No_  In Varchar2,
                                      Date_     In Date) Return Number;
  --获取新增表的数据
  Function Get_Column_Data_Bl(Column_Id_ In Varchar2,
                              Order_No_  In Varchar2) Return Varchar2;
End Bl_Purchase_Order_Api;
/
CREATE OR REPLACE Package Body Bl_Purchase_Order_Api Is
  /*create fjp 2012-09-12
  modify fjp 2012-11-12 下达同步发送订单
  modify fjp 2012-12-18 增加库位的默认
  modify fjp 2012-12-26 下达如果没保隆订单号自动生成，如果没有外部客户号则不能下达
  modify 2013-01-15 增加内部供应商的bl订单号
  modify 2013-01-31 判断是否有协议
  modify 2013-02-25 增加起运港和目的港 
  modify 2013-02-27 外部供应商的确认不调用其他的功能
  modify 2013-03-06 明细一起生成采购订单 */
  Type t_Cursor Is Ref Cursor;
  Procedure Approve__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
    Row_ Bl_v_Purchase_Order_Approval%Rowtype;
    Cur_ t_Cursor;
  Begin
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Open Cur_ For
      Select * From Bl_v_Purchase_Order_Approval Where Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Pkg_a.Setfailed(A311_Key_,
                      'BL_V_PURCHASE_ORDER_APPROVAL',
                      Row_.Objid);
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
    Purchase_Order_Approval_Api.Authorize(Row_.Order_No,
                                          Row_.Sequence_No,
                                          Row_.Authorize_Id,
                                          Row_.Authorize_Group_Id);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER_APPROVAL', Row_.Objid);
    Return;
  End;
  Procedure Approve1__(Rowid_    Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
    Cur_          t_Cursor;
    Row_          Bl_v_Purchase_Order%Rowtype;
    Row_Approval_ Bl_v_Purchase_Order_Approval%Rowtype;
    Rowlist_      Varchar2(400);
    Cur_Approval_ t_Cursor;
  Begin
    ---获取订单号
    Open Cur_ For
      Select t.* From Bl_v_Purchase_Order t Where Objid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
    --获取审核表
    Open Cur_Approval_ For
      Select t.*
        From Bl_v_Purchase_Order_Approval t
       Where t.Order_No = Row_.Order_No
         And t.Sequence_No = 1
         And Rownum = 1;
    Fetch Cur_Approval_
      Into Row_Approval_;
    If Cur_Approval_%Notfound Then
      Close Cur_Approval_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_Approval_;
    --调用审核的代码
    Pkg_a.Set_Item_Value('OBJID', Row_Approval_.Objid, Rowlist_);
    Approve__(Rowlist_, User_Id_, A311_Key_);
    Return;
  End;
  Procedure Revoke_Approve__(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2) Is
    Row_ Bl_v_Purchase_Order_Approval%Rowtype;
    Cur_ t_Cursor;
  Begin
    -- 取消审批
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Open Cur_ For
      Select * From Bl_v_Purchase_Order_Approval Where Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Pkg_a.Setfailed(A311_Key_,
                      'BL_V_PURCHASE_ORDER_APPROVAL',
                      Row_.Objid);
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
    Purchase_Order_Approval_Api.Revoke_Authorization(Row_.Order_No,
                                                     Row_.Sequence_No,
                                                     Row_.Approver_Sign);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER_APPROVAL', Row_.Objid);
    Return;
  End;
  Procedure Revoke_Approve1__(Rowid_    Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2) Is
    Cur_          t_Cursor;
    Row_          Bl_v_Purchase_Order%Rowtype;
    Row_Approval_ Bl_v_Purchase_Order_Approval%Rowtype;
    Rowlist_      Varchar2(400);
    Cur_Approval_ t_Cursor;
  Begin
    ---获取订单号
    Open Cur_ For
      Select t.* From Bl_v_Purchase_Order t Where Objid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
    --获取审核表
    Open Cur_Approval_ For
      Select t.*
        From Bl_v_Purchase_Order_Approval t
       Where t.Order_No = Row_.Order_No
         And t.Sequence_No = 1
         And Rownum = 1;
    Fetch Cur_Approval_
      Into Row_Approval_;
    If Cur_Approval_%Notfound Then
      Close Cur_Approval_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_Approval_;
    --调用取消审核的代码
    Pkg_a.Set_Item_Value('OBJID', Row_Approval_.Objid, Rowlist_);
    Revoke_Approve__(Rowlist_, User_Id_, A311_Key_);
    Return;
  End;
  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Row_        Bl_v_Purchase_Order%Rowtype;
    Co_Row      Customer_Order%Rowtype;
    Attr_       Varchar2(4000);
    Info_       Varchar2(4000);
    Objid_      Varchar2(4000);
    Objversion_ Varchar2(4000);
    Action_     Varchar2(100);
    Cur_        t_Cursor;
    A311_       A311%Rowtype;
    Po_Rowlist  Varchar2(4000);
    Ll_Count_   Number;
  Begin
    Objid_ := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Open Cur_ For
      Select t.* From Bl_v_Purchase_Order t Where t.Objid = Objid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
    Row_.Cancel_Reason := Pkg_a.Get_Item_Value('CANCEL_REASON', Rowlist_);
    -- objversion_ := row_.objversion;
    Purchase_Order_Api.Set_Cancel_Reason(Row_.Order_No, Row_.Cancel_Reason);
    Ll_Count_ := 0;
    Select Count(*)
      Into Ll_Count_
      From Purchase_Order_Line_Part
     Where Order_No = Row_.Order_No
       And Requisition_No Is Not Null
       And State <> 'Cancelled';
    If Ll_Count_ > 0 Then
      Purchase_Order_Api.Reopen_Requisition_Lines(Row_.Order_No);
    Else
      Action_ := 'DO';
      Select Objversion
        Into Objversion_
        From Bl_v_Purchase_Order
       Where Objid = Objid_;
      Purchase_Order_Api.Cancel__(Info_,
                                  Objid_,
                                  Objversion_,
                                  Attr_,
                                  Action_);
    End If;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER', Objid_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 Pkg_Msg.Getmsgbymsgid('ESPO0001',
                                       Row_.Order_No,
                                       '',
                                       Pkg_Attr.Userlanguage(User_Id_),
                                       '1'));
  
    --找对应的下域的客户订单--
    Open Cur_ For
      Select Distinct t.*
        From Purchase_Order_Line T2
       Inner Join Customer_Order_Line_Tab T1
          On T1.Demand_Order_Ref1 = T2.Order_No
         And T1.Demand_Order_Ref2 = T2.Line_No
         And T1.Demand_Order_Ref3 = T2.Release_No
       Inner Join Customer_Order t
          On t.Order_No = T1.Order_No
       Where T2.Order_No = Row_.Order_No;
    Fetch Cur_
      Into Co_Row;
    --取消下域的客户订单
    Loop
      Exit When Cur_%Notfound;
      A311_.A311_Id     := 'BL_PURCHASE_ORDER_API.CANCEL__';
      A311_.Enter_User  := User_Id_;
      A311_.A014_Id     := 'A014_ID=Order_Cancel';
      A311_.Table_Id    := 'BL_V_CUSTOMER_ORDER';
      A311_.Table_Objid := Co_Row.Objid;
      Pkg_a.Beginlog(A311_);
      Po_Rowlist := '';
      Pkg_a.Set_Item_Value('OBJID', A311_.Table_Objid, Po_Rowlist);
      Pkg_a.Set_Item_Value('CANCEL_REASON', Row_.Cancel_Reason, Po_Rowlist);
      Bl_Customer_Order_Api.Set_Cancel_Reason(Po_Rowlist,
                                              User_Id_,
                                              A311_.A311_Key);
      Fetch Cur_
        Into Co_Row;
    End Loop;
    Close Cur_;
  
  End;

  Procedure Close__(Rowid_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
    Row_        Bl_v_Purchase_Order%Rowtype;
    Attr_       Varchar2(4000);
    Info_       Varchar2(4000);
    Objid_      Varchar2(4000);
    Objversion_ Varchar2(4000);
    Action_     Varchar2(100);
    Cur_        t_Cursor;
  Begin
    Objid_ := Rowid_;
    Open Cur_ For
      Select t.* From Bl_v_Purchase_Order t Where t.Objid = Objid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
    Action_ := 'DO';
    Purchase_Order_Api.Close__(Info_,
                               Objid_,
                               Row_.Objversion,
                               Attr_,
                               Action_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER', Objid_);
  End;

  Procedure Confirm__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
    Row_        Bl_v_Purchase_Order%Rowtype;
    Attr_       Varchar2(4000);
    Info_       Varchar2(4000);
    Objid_      Varchar2(4000);
    Objversion_ Varchar2(4000);
    Action_     Varchar2(100);
    Cur_        t_Cursor;
    Cur_Co_     t_Cursor;
    /* co_row customer_order%rowtype;
    a311_ a311%rowtype;*/
    Order_List_        Varchar2(500);
    Sql_               Varchar2(4000);
    Ls_Customer_Inner_ Varchar2(20);
  Begin
    Objid_ := Rowid_;
    Open Cur_ For
      Select t.* From Bl_v_Purchase_Order t Where t.Objid = Objid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
    Action_     := 'DO';
    Objversion_ := Row_.Objversion;
    Purchase_Order_Api.Confirm__(Info_,
                                 Objid_,
                                 Objversion_,
                                 Attr_,
                                 Action_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER', Objid_);
    -- 确定下域的客户订单号
    --找对应的下域的客户订单--
    /*  open cur_co_
    for   SELECT distinct  t.*
       FROM  purchase_order_line   t2
       inner join  CUSTOMER_ORDER_line_TAB  t1 
       on t1.demand_order_ref1 = t2.order_no
       and t1.demand_order_ref2 = t2.line_no
       and  t1.demand_order_ref3 = t2.release_no
       inner join customer_order t on t.order_no = t1.order_no
       where  t2.order_no = row_.ORDER_NO;
      fetch  cur_co_ into  co_row ;     
      loop 
           exit when cur_co_%notfound;
           a311_.a311_id := 'BL_PURCHASE_ORDER_API.CONFIRM__';
           a311_.enter_user := user_id_;
           a311_.a014_id := 'A014_ID=Order_Appvoe';
           a311_.table_id := 'BL_V_CUSTOMER_ORDER' ;
           a311_.table_objid := co_row.objid;
           pkg_a.BeginLog(a311_);       
           BL_Customer_Order_Api.appvoe_order__( co_row.objid ,USER_ID_,a311_.a311_key );
           fetch  cur_co_ into  co_row ;   
     end loop ;
      close cur_co_ ;*/
    --modify 2013-02-27 外部供应商的确认不调用其他的功能
    Ls_Customer_Inner_ := Identity_Invoice_Info_Api.Get_Identity_Type(Row_.Company,
                                                                      Row_.Vendor_No,
                                                                      'Supplier');
    If Ls_Customer_Inner_ = 'INTERN' Then
      Bl_Customer_Order_Api.Checknextexist('PO',
                                           Row_.Order_No,
                                           Row_.Contract,
                                           User_Id_,
                                           Order_List_);
    
      Sql_ := 'update bl_customer_order set   q_flag = ''1'',modi_Date= sysdate,modi_user = ''' ||
              User_Id_ || ''' where  order_no in (' || Order_List_ ||
              '''0'')';
      Execute Immediate Sql_;
    
      /* Update Bl_Customer_Order
        Set q_Flag = '1', Modi_Date = Sysdate, Modi_User = User_Id_
      Where Blorder_No = Row_.Blorder_No;*/
    
      Pkg_a.Setmsg(A311_Key_,
                   '',
                   Pkg_Msg.Getmsgbymsgid('ESPO0002',
                                         Row_.Order_No,
                                         '',
                                         Pkg_Attr.Userlanguage(User_Id_),
                                         '1'));
    End If;
    Return;
  End;
  Procedure Usermodify__(Row_     In Bl_Purchase_Order%Rowtype,
                         User_Id_ In Varchar2) Is
    Cur_  t_Cursor;
    Row0_ Bl_Purchase_Order%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_Purchase_Order t Where t.Order_No = Row_.Order_No;
    Fetch Cur_
      Into Row0_;
    If Cur_%Notfound Then
      Insert Into Bl_Purchase_Order
        (Order_No,
         Enter_Date,
         Enter_User,
         Bld001_Item,
         Blorder_No,
         Bllocation_No,
         Blorder_Id,
         Agreement_Id,
         Exitport,
         Aimport)
        Select Row_.Order_No,
               Sysdate,
               User_Id_,
               Row_.Bld001_Item,
               Row_.Blorder_No,
               Row_.Bllocation_No,
               Row_.Blorder_Id,
               Row_.Agreement_Id,
               Row_.Exitport,
               Row_.Aimport
          From Dual;
    Else
      Update Bl_Purchase_Order
         Set Blorder_No    = Nvl(Row_.Blorder_No, Blorder_No),
             Bld001_Item   = Nvl(Row_.Bld001_Item, Bld001_Item),
             Bllocation_No = Nvl(Row_.Bllocation_No, Bllocation_No),
             Blorder_Id    = Nvl(Row_.Blorder_Id, Blorder_Id),
             Agreement_Id  = Nvl(Row_.Agreement_Id, Blorder_Id),
             Aimport       = Nvl(Row_.Aimport, Aimport),
             Exitport      = Nvl(Row_.Exitport, Exitport),
             Modi_Date     = Sysdate,
             Modi_User     = User_Id_
       Where Order_No = Row_.Order_No;
    End If;
    Close Cur_;
  End;
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Row_                Bl_v_Purchase_Order%Rowtype;
    Attr_               Varchar2(4000);
    Info_               Varchar2(4000);
    Objid_              Varchar2(4000);
    Objversion_         Varchar2(4000);
    Action_             Varchar2(100);
    Index_              Varchar2(1);
    Cur_                t_Cursor;
    Pos_                Number;
    Pos1_               Number;
    i                   Number;
    v_                  Varchar2(1000);
    Column_Id_          Varchar2(4000);
    Data_               Varchar2(4000);
    Doaction_           Varchar2(10);
    Last_Currency_Code_ Varchar2(10);
    Row0_               Bl_Purchase_Order%Rowtype;
    Mysql_              Varchar2(4000);
    Ifmychange          Varchar2(1);
    Ls_Customer_Inner_  Varchar2(10); --是否是内部客户
    Ll_Count_           Number;
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
      Client_Sys.Add_To_Attr('VENDOR_NO',
                             Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('CONTRACT',
                             Pkg_a.Get_Item_Value('CONTRACT', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('ORDER_CODE',
                             Pkg_a.Get_Item_Value('ORDER_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('WANTED_RECEIPT_DATE',
                             Pkg_a.Get_Item_Value('WANTED_RECEIPT_DATE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('CURRENCY_CODE',
                             Pkg_a.Get_Item_Value('CURRENCY_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('BUYER_CODE',
                             Pkg_a.Get_Item_Value('BUYER_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('DELIVERY_ADDRESS',
                             Pkg_a.Get_Item_Value('DELIVERY_ADDRESS',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('AUTHORIZE_CODE',
                             Pkg_a.Get_Item_Value('AUTHORIZE_CODE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('ORDER_DATE',
                             Pkg_a.Get_Item_Value('ORDER_DATE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('LANGUAGE_CODE',
                             Pkg_a.Get_Item_Value('LANGUAGE_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('CONTACT',
                             Pkg_a.Get_Item_Value('CONTACT', Rowlist_),
                             Attr_);
      If Nvl(Pkg_a.Get_Item_Value('DELIVERY_TERMS', Rowlist_), 'NULL') <>
         'NULL' Then
        Client_Sys.Add_To_Attr('DELIVERY_TERMS',
                               Pkg_a.Get_Item_Value('DELIVERY_TERMS',
                                                    Rowlist_),
                               Attr_);
      End If;
      If Nvl(Pkg_a.Get_Item_Value('DELIVERY_TERMS_DESC', Rowlist_), 'NULL') <>
         'NULL' Then
        Client_Sys.Add_To_Attr('DELIVERY_TERMS_DESC',
                               Pkg_a.Get_Item_Value('DELIVERY_TERMS_DESC',
                                                    Rowlist_),
                               Attr_);
      End If;
      If Nvl(Pkg_a.Get_Item_Value('SHIP_VIA_CODE', Rowlist_), 'NULL') <>
         'NULL' Then
        Client_Sys.Add_To_Attr('SHIP_VIA_CODE',
                               Pkg_a.Get_Item_Value('SHIP_VIA_CODE',
                                                    Rowlist_),
                               Attr_);
      End If;
      If Nvl(Pkg_a.Get_Item_Value('SHIP_VIA_DESC', Rowlist_), 'NULL') <>
         'NULL' Then
        Client_Sys.Add_To_Attr('SHIP_VIA_DESC',
                               Pkg_a.Get_Item_Value('SHIP_VIA_DESC',
                                                    Rowlist_),
                               Attr_);
      End If;
      Client_Sys.Add_To_Attr('PAY_TERM_ID',
                             Pkg_a.Get_Item_Value('PAY_TERM_ID', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('INTERNAL_DESTINATION',
                             Pkg_a.Get_Item_Value('INTERNAL_DESTINATION',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('DESTINATION_ID',
                             Pkg_a.Get_Item_Value('DESTINATION_ID',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('COUNTRY_CODE',
                             Pkg_a.Get_Item_Value('COUNTRY_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('NOTE_ID',
                             Pkg_a.Get_Item_Value('NOTE_ID', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('PRICE_WITH_TAX',
                             Pkg_a.Get_Item_Value('PRICE_WITH_TAX',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('LABEL_NOTE',
                             Pkg_a.Get_Item_Value('LABEL_NOTE', Rowlist_),
                             Attr_);
      -- 2013-02-25 供应商地址号ADDR_NO                       
      Client_Sys.Add_To_Attr('ADDR_NO',
                             Pkg_a.Get_Item_Value('ADDR_NO', Rowlist_),
                             Attr_);
      Ls_Customer_Inner_ := Identity_Invoice_Info_Api.Get_Identity_Type(Site_Api.Get_Company(Pkg_a.Get_Item_Value('CONTRACT',
                                                                                                                  Rowlist_)),
                                                                        Pkg_a.Get_Item_Value('VENDOR_NO',
                                                                                             Rowlist_),
                                                                        'Supplier');
      --内部供应商 外部客户跟库位是必填  modify 2012-12-18 
      Row0_.Bllocation_No := Pkg_a.Get_Item_Value('BLLOCATION_NO', Rowlist_);
      Row_.Label_Note     := Pkg_a.Get_Item_Value('LABEL_NOTE', Rowlist_);
      If Ls_Customer_Inner_ = 'INTERN' Then
        If Nvl(Row_.Label_Note, 'NULL') = 'NULL' Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Pkg_Msg.Getmsgbymsgid('ESPO0003',
                                                        '',
                                                        '',
                                                        Pkg_Attr.Userlanguage(User_Id_),
                                                        '1'));
          Return;
        End If;
        If Nvl(Row0_.Bllocation_No, 'NULL') = 'NULL' Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Pkg_Msg.Getmsgbymsgid('ESPO0004',
                                                        '',
                                                        '',
                                                        Pkg_Attr.Userlanguage(User_Id_),
                                                        '1'));
          Return;
        End If;
      End If;
      Action_ := 'DO';
      Purchase_Order_Api.New__(Info_, Objid_, Objversion_, Attr_, Action_);
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER', Objid_);
    
      Row_.Order_No  := Client_Sys.Get_Item_Value('ORDER_NO', Attr_);
      Row0_.Order_No := Row_.Order_No;
      --判断是否有协议 modify 2013-01-31 
      Row_.Contract := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Select Count(*)
        Into Ll_Count_
        From Bl_Ciq_Contract_Tab
       Where Contract = Row_.Contract
         And Ifagreement = '0';
      If Ll_Count_ > 0 Then
        Row0_.Agreement_Id := '';
      Else
        Row0_.Agreement_Id := Pkg_a.Get_Item_Value('AGREEMENT_ID', Rowlist_);
      End If;
      --end 
      If Ls_Customer_Inner_ = 'INTERN' Then
        Bl_Customer_Order_Api.Getseqno(To_Char(Sysdate, 'YY') ||
                                       Row_.Label_Note,
                                       User_Id_,
                                       4,
                                       Row0_.Blorder_No);
      Else
        --modify 2013-01-15 增加内部供应商的bl订单号
        Bl_Customer_Order_Api.Getseqno(To_Char(Sysdate, 'YY') ||
                                       Pkg_a.Get_Item_Value('VENDOR_NO',
                                                            Rowlist_), -- Row_.Label_Note,
                                       User_Id_,
                                       4,
                                       Row0_.Blorder_No);
      End If;
      --  row0_.BLORDER_NO := pkg_a.Get_Item_Value('BLORDER_NO',ROWLIST_);
      --modify 2013-02-25 增加起运港和目的港
      Row0_.Exitport := Pkg_a.Get_Item_Value('EXITPORT', Rowlist_);
      Row0_.Aimport  := Pkg_a.Get_Item_Value('AIMPORT', Rowlist_);
      Usermodify__(Row0_, User_Id_);
    
      Return;
    End If;
    If Doaction_ = 'M' Then
      Open Cur_ For
        Select t.* From Bl_v_Purchase_Order t Where t.Objid = Row_.Objid;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(Pkg_a.Raise_Error,
                                Pkg_Msg.Getmsgbymsgid('ES0002',
                                                      '',
                                                      '',
                                                      Pkg_Attr.Userlanguage(User_Id_),
                                                      '1'));
        Return;
      End If;
      Close Cur_;
    
      Row0_.Order_No := Row_.Order_No;
      Usermodify__(Row0_, User_Id_);
    
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := 'update bl_purchase_order set  ';
      Ifmychange := '0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_         := Substr(Data_, 1, Pos_ - 1);
        Data_      := Substr(Data_, Pos_ + 1);
        Pos_       := Instr(Data_, Index_);
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        If Column_Id_ = 'BLORDER_NO' Or Column_Id_ = 'BLLOCATION_NO' Or
           Column_Id_ = 'AGREEMENT_ID' Or Column_Id_ = 'EXITPORT' Or
           Column_Id_ = 'AIMPORT' Then
          --如果是域不允许有协议则没有协议 2013-01-31
          If Column_Id_ = 'AGREEMENT_ID' Then
            Select Count(*)
              Into Ll_Count_
              From Bl_Ciq_Contract_Tab
             Where Contract = Row_.Contract
               And Ifagreement = '0';
            If Ll_Count_ = 0 Then
              Ifmychange := '1';
              v_         := Substr(v_, Pos1_ + 1);
              Mysql_     := Mysql_ || ' ' || Column_Id_ || '=''' || v_ ||
                            ''',';
            End If;
          Else
            Ifmychange := '1';
            v_         := Substr(v_, Pos1_ + 1);
            Mysql_     := Mysql_ || ' ' || Column_Id_ || '=''' || v_ ||
                          ''',';
          End If;
        Else
          If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' And
             Length(Nvl(Column_Id_, '')) > 0 Then
            v_ := Substr(v_, Pos1_ + 1);
            Client_Sys.Add_To_Attr(Column_Id_, v_, Attr_);
            i := i + 1;
          End If;
        End If;
      End Loop;
      Action_ := 'DO';
      Purchase_Order_Api.Modify__(Info_,
                                  Row_.Objid,
                                  Row_.Objversion,
                                  Attr_,
                                  Action_);
      If Instr(Rowlist_, 'CURRENCY_CODE') > 0 Then
        --币种更改更改相关的金额和明细币种 
        Last_Currency_Code_ := Pkg_a.Get_Item_Value('CURRENCY_CODE',
                                                    Rowlist_); --修改后的币种
        Purchase_Order_Api.Change_Line_Currency__(Row_.Order_No,
                                                  Last_Currency_Code_,
                                                  1);
        Purchase_Order_Charge_Api.Change_Currency__(Row_.Order_No,
                                                    Row_.Currency_Code,
                                                    Last_Currency_Code_,
                                                    1);
      End If;
      --用户自定义列
      If Ifmychange = '1' Then
        Mysql_ := Mysql_ || 'modi_date=sysdate,modi_user=''' || User_Id_ || '''';
        Mysql_ := '' || Mysql_ || ' WHERE order_no=''' || Row_.Order_No || '''';
        Execute Immediate Mysql_;
      End If;
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER', Objid_);
      Return;
    End If;
  End;

  Procedure Freeze__(Rowid_    Varchar2,
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
      Select Objversion From Bl_v_Purchase_Order Where Objid = Objid_;
    Fetch Cur_
      Into Objversion_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
    Action_ := 'DO';
    Purchase_Order_Api.Freeze__(Info_, Objid_, Objversion_, Attr_, Action_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER', Objid_);
  End;

  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
    Attr_           Varchar2(4000);
    Info_           Varchar2(4000);
    Objid_          Varchar2(4000);
    Objversion_     Varchar2(4000);
    Action_         Varchar2(100);
    Attr_Out        Varchar2(4000);
    Ls_Description_ Varchar2(4000);
    Ls_Company_     Varchar(4000);
    Contract_       Varchar2(20);
  Begin
    Action_ := 'PREPARE';
    Attr_   := Pkg_a.Get_Attr_By_Bm(Rowlist_);
    Purchase_Order_Api.New__(Info_, Objid_, Objversion_, Attr_, Action_);
    --订单代码描述
    Ls_Description_ := Purchase_Order_Type_Api.Get_Description(Client_Sys.Get_Item_Value('ORDER_CODE',
                                                                                         Attr_));
    Client_Sys.Add_To_Attr('DESCRIPTION', Ls_Description_, Attr_);
    --公司
    Ls_Company_ := Site_Api.Get_Company(Client_Sys.Get_Item_Value('CONTRACT',
                                                                  Attr_));
    Client_Sys.Add_To_Attr('COMPANY', Ls_Company_, Attr_);
    Attr_Out  := Pkg_a.Get_Attr_By_Ifs(Attr_);
    Contract_ := Pkg_Attr.Get_Default_Contract(User_Id_);
    If (Nvl(Contract_, '0') <> '0') Then
      Pkg_a.Set_Item_Value('CONTRACT', Contract_, Attr_Out);
    End If;
    Pkg_a.Setresult(A311_Key_, Attr_Out);
    Return;
  End;

  Procedure Release__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
    Attr_              Varchar2(4000);
    Info_              Varchar2(4000);
    Objid_             Varchar2(4000);
    Objversion_        Varchar2(4000);
    Action_            Varchar2(100);
    Cur_               t_Cursor;
    Row_               Bl_v_Purchase_Order%Rowtype;
    Ls_Customer_Inner_ Varchar2(20);
  Begin
    Objid_ := Rowid_;
    Open Cur_ For
      Select t.* From Bl_v_Purchase_Order t Where t.Objid = Objid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
    --如果没有保隆订单号自动生成一个，如果没有外部客户号不让下达
    Ls_Customer_Inner_ := Identity_Invoice_Info_Api.Get_Identity_Type(Row_.Company,
                                                                      Row_.Vendor_No,
                                                                      'Supplier');
    If Ls_Customer_Inner_ = 'INTERN' Then
      If Nvl(Row_.Label_Note, 'NULL') = 'NULL' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                Pkg_Msg.Getmsgbymsgid('ESPO0003',
                                                      '',
                                                      '',
                                                      Pkg_Attr.Userlanguage(User_Id_),
                                                      '1'));
        Return;
      End If;
      If Nvl(Row_.Bllocation_No, 'NULL') = 'NULL' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                Pkg_Msg.Getmsgbymsgid('ESPO0004',
                                                      '',
                                                      '',
                                                      Pkg_Attr.Userlanguage(User_Id_),
                                                      '1'));
        Return;
      End If;
      If Nvl(Row_.Blorder_No, 'NULL') = 'NULL' Then
        Bl_Customer_Order_Api.Getseqno(To_Char(Sysdate, 'YY') ||
                                       Row_.Label_Note,
                                       User_Id_,
                                       4,
                                       Row_.Blorder_No);
        Update Bl_Purchase_Order
           Set Blorder_No = Row_.Blorder_No,
               Modi_Date  = Sysdate,
               Modi_User  = User_Id_
         Where Order_No = Row_.Order_No;
      End If;
    End If;
    --end-------
    Action_ := 'DO';
    Purchase_Order_Api.Release__(Info_,
                                 Row_.Objid,
                                 Row_.Objversion,
                                 Attr_,
                                 Action_);
    If Info_ =
       'INFOThe Purchase Order Should be Authorized to be RELEASED or CONFIRMED' Then
      --Raise_Application_Error(-20101, 'INFO采购订单须经核准才能下达或确认.');
      Pkg_a.Setmsg(A311_Key_,
                   '',
                   Pkg_Msg.Getmsgbymsgid('ESPO0005',
                                         '',
                                         '',
                                         Pkg_Attr.Userlanguage(User_Id_),
                                         '1'));
      -- Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER', Row_.Objid);
    Else
      ---内部订单下达同步发送订单  FJP 2012-11-12------
      If Ls_Customer_Inner_ = 'INTERN' Then
        Bl_Purchase_Order_Transfer_Api.Send_Purchase_Order(Row_.Objid,
                                                           User_Id_,
                                                           A311_Key_);
      End If;
      ---end-------                            
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_ORDER', Row_.Objid);
    End If;
  End;

  Procedure User_Requisition_Line_To_Order(Rowlist_  Varchar2,
                                           User_Id_  Varchar2,
                                           A311_Key_ Varchar2) Is
    Row_                Purchase_Req_Line_Part%Rowtype;
    Authorize_Code_     Varchar2(100); --不知道取自何处
    Req_Order_No_       Varchar2(100);
    Assg_Line_No_       Varchar2(100);
    Assg_Release_No_    Varchar2(100);
    Req_Info_           Varchar2(4000);
    New_Order_          Varchar2(100);
    Use_Default_Buyer_  Varchar2(100);
    Purchase_Site_      Varchar2(100);
    Central_Order_Flag_ Varchar2(100);
    Cur_                t_Cursor;
    Price_Date_         Date;
    Blanket_Order_      Varchar2(100);
    Rowlist_New_        Varchar2(4000);
    Ll_Count            Number;
    Row1_               Bl_Purchase_Order%Rowtype;
    Row2_               Bl_Purchase_Order_Line_Part%Rowtype;
  Begin
    /*    Insert Into Af
      (Col, Col01, Col02, Col03)
      Select 'USER_', Rowlist_, User_Id_, '1' From Dual;
    Commit;*/
    --   select COL01 INTO ROWLIST_NEW_ from af t  WHERE COL06='1';
    Row_.Objid         := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
   -- Use_Default_Buyer_ := Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_);
  --  Raise_Application_Error(Pkg_a.Raise_Error, Use_Default_Buyer_);
    Open Cur_ For
      Select t.* From Purchase_Req_Line_Part t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
    Price_Date_   := Sysdate;
    Req_Order_No_ := Trim(Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_));
    If Req_Order_No_ = '自动选择' Or Req_Order_No_ = '新建' Then
      If Req_Order_No_ = '新建' Then
        New_Order_ := 'createnew';
        authorize_code_    := Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_);
        Row_.Buyer_Code    := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
        if nvl(authorize_code_,'NULL') ='NULL' then 
            authorize_code_ :='*';
        end if;
      End If;
      Req_Order_No_ := '';
    End If;
    Central_Order_Flag_ := 'NOT CENTRAL ORDER';
  --  Authorize_Code_     := User_Default_Api.Get_Authorize_Code; --取自生产系统给予的固定值
    /*                INSERT INTO AF(COL,COL01,COL02,COL03,COL04,COL05)
    SELECT 'USF',
    'req_order_no_='||req_order_no_||'assg_line_no_='||assg_line_no_||'assg_release_no_='||assg_release_no_,
     'req_info_='||req_info_||'requisition_no='||row_.requisition_no,
     'line_no='||row_.line_no||'release_no='||row_.release_no,
     'authorize_code_='||authorize_code_||'buyer_code='|| row_.buyer_code,
     'new_order_='||new_order_||
      'use_default_buyer_='||use_default_buyer_||'purchase_site_='||purchase_site_||'central_order_flag_='||central_order_flag_ FROM DUAL ;
      COMMIT;*/
    Purchase_Order_Api.Get_Price_Details(Row_.Part_No,
                                         Row_.Contract,
                                         Row_.Vendor_No,
                                         Row_.Original_Qty,
                                         To_Date(To_Char(Sysdate,
                                                         'YYYYMMDD'),
                                                 'YYYYMMDD'),
                                         Row_.Currency_Code,
                                         Blanket_Order_, --不知道生产系统中的这个值怎么取
                                         Row_.Project_Id,
                                         Row_.Requisition_No,
                                         Row_.Line_No,
                                         Row_.Release_No);
    Purchase_Order_Api.User_Requisition_Line_To_Order(Req_Order_No_,
                                                      Assg_Line_No_,
                                                      Assg_Release_No_,
                                                      Req_Info_,
                                                      Row_.Requisition_No,
                                                      Row_.Line_No,
                                                      Row_.Release_No,
                                                      Authorize_Code_,
                                                      Row_.Buyer_Code,
                                                     --'AH-BUYER02',
                                                      New_Order_,
                                                      Use_Default_Buyer_,
                                                      Purchase_Site_,
                                                      Central_Order_Flag_);
    --自动生产bl记录表 modify fjp 2013-01-15
    Select Count(*)
      Into Ll_Count
      From Bl_Purchase_Order
     Where Order_No = Req_Order_No_;
    If Ll_Count = 0 Then
      Row1_.Order_No   := Req_Order_No_;
      Row1_.Enter_User := User_Id_;
      Row1_.Enter_Date := Sysdate;
      If Nvl(Row_.Demand_Order_No, 'NULL') <> 'NULL' Then
        Open Cur_ For
          Select t.Bld001_Item, t.Blorder_No, Bllocation_No, Blorder_Id
            From Bl_Customer_Order t
           Where t.Order_No = Row_.Demand_Order_No;
        Fetch Cur_
          Into Row1_.Bld001_Item,
               Row1_.Blorder_No,
               Row1_.Bllocation_No,
               Row1_.Blorder_Id;
        Close Cur_;
      Else
        Bl_Customer_Order_Api.Getseqno(To_Char(Sysdate, 'YY') ||
                                       Row_.Vendor_No, -- Row_.Label_Note,
                                       User_Id_,
                                       4,
                                       Row1_.Blorder_No);
      End If;
      Usermodify__(Row1_, User_Id_);
    End If;
    Row2_.Order_No   := Req_Order_No_;
    Row2_.Line_No    := Assg_Line_No_;
    Row2_.Release_No := Assg_Release_No_;
    Row2_.Enter_Date := Sysdate;
    Row2_.Enter_User := User_Id_;
    Bl_Po_Line_Part_Api.Usermodify__(Row2_, User_Id_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_REQ_LINE_PART', Row_.Objid);
  
    Return;
  End;
  --modify fjp 2013-03-06明细一起生成采购订单                                         
  Procedure User_Req_Line_To_Order(Rowlist_  Varchar2,
                                   User_Id_  Varchar2,
                                   A311_Key_ Varchar2) Is
    Row_       Purchase_Req_Line_Part%Rowtype;
    Cur_       t_Cursor;
    Col01_     Varchar2(150);
    Col02_     Varchar2(150);
    Attr_      Varchar2(4000);
    Info_      Varchar2(4000);
    Action_    Varchar2(100);
    Vendor_No_ Varchar2(10);
    Buyer_Code_ varchar2(100);
    authorize_code_ varchar2(100);
  Begin
    Select Col01, Col02
      Into Col01_, Col02_
      From A311
     Where A311_Key = A311_Key_;
    /*    INSERT INTO AF(COL,COL01) 
    SELECT '1234',Rowlist_ FROM DUAL;
    COMMIT;*/
    /*    SELECT COL01 INTO Rowlist_1 FROM AF  WHERE COL='1234';*/
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Vendor_No_ := Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_);
    authorize_code_ := pkg_a.Get_Item_Value('AUTHORIZE_CODE',Rowlist_);
    Buyer_Code_     := pkg_a.Get_Item_Value('BUYER_CODE',Rowlist_); 
    If Nvl(Vendor_No_, 'NULL') = 'NULL' Then
      Raise_Application_Error(Pkg_a.Raise_Error, '请录入供应商信息');
      Return;
    End If;
    If Nvl(Col02_, 'NULL') <> 'NULL' And Col02_ <> Vendor_No_ Then
      Raise_Application_Error(Pkg_a.Raise_Error, '选取的供应商不统一');
      Return;
    End If;
    Open Cur_ For
      Select t.* From Purchase_Req_Line_Part t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Raise_Application_Error(Pkg_a.Raise_Error, 'objid不存在');
      Return;
    End If;
    Close Cur_;
    If Row_.Vendor_No <> Vendor_No_ Then
      --更新采购申请的供应商
      Action_ := 'DO';
      Client_Sys.Add_To_Attr('VENDOR_NO', Vendor_No_, Attr_);
      Purchase_Req_Line_Part_Api.Modify__(Info_,
                                          Row_.Objid,
                                          Row_.Objversion,
                                          Attr_,
                                          Action_);
    End If;
    Attr_ := '';
    Pkg_a.Set_Item_Value('OBJID', Row_.Objid, Attr_);
    If Nvl(Col01_, 'NULL') = 'NULL' Then
      Pkg_a.Set_Item_Value('ORDER_NO', '新建', Attr_);
      Pkg_a.Set_Item_Value('VENDOR_NO',authorize_code_ ,Attr_);
      Pkg_a.Set_Item_Value('CONTRACT',Buyer_Code_, Attr_);
    Else
      Pkg_a.Set_Item_Value('ORDER_NO', Col01_, Attr_);
    End If;
    User_Requisition_Line_To_Order(Attr_, User_Id_, A311_Key_);
    If Nvl(Col01_, 'NULL') = 'NULL' Then
      Select Order_No
        Into Row_.Order_No
        From Purchase_Req_Line_Tab
       Where Requisition_No = Row_.Requisition_No
         And Line_No = Row_.Line_No
         And Release_No = Row_.Release_No;
      Update A311
         Set Col01 = Row_.Order_No, Col02 = Vendor_No_
       Where A311_Key = A311_Key_;
    End If;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PURCHASE_REQ_QUERY', Row_.Objid);
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
    Row_                    Bl_v_Purchase_Order%Rowtype;
    Arow_                   Customer_Agreement_Lov%Rowtype;
    Price_Conv_Factor_      Number;
    Price_Unit_Meas_        Varchar2(20);
    Discount_               Number;
    Additional_Cost_Amount_ Number;
    Curr_Rate_              Number;
    Curr_Code_              Varchar2(20);
    Row1_                   Bl_Ciq_Contract_Tab%Rowtype;
    Cur_                    t_Cursor;
  Begin
    If Column_Id_ = 'VENDOR_NO' Or Column_Id_ = 'CONTRACT' Then
      -- 供应商,域信息
      -- 供应商代码
      Row_.Vendor_No     := Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_);
      Row_.Contract      := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Row_.Ship_Via_Code := Pkg_a.Get_Item_Value('SHIP_VIA_CODE', Rowlist_);
      -- RAISE_APPLICATION_ERROR(-20101, '错误的rowid' || ROW_.SHIP_VIA_CODE);
      Row_.Vendor_Name         := Supplier_Api.Get_Vendor_Name(Row_.Vendor_No);
      Row_.Contact             := Supplier_Address_Api.Get_Contact(Row_.Vendor_No,
                                                                   Supplier_Address_Api.Get_Address_No(Row_.Vendor_No,
                                                                                                       Address_Type_Code_Api.Get_Client_Value(1)));
      Row_.Buyer_Code          := Supplier_Api.Get_Buyer_Code(Row_.Vendor_No);
      Row_.Currency_Code       := Supplier_Api.Get_Currency_Code(Row_.Vendor_No);
      Row_.Language_Code       := Supplier_Api.Get_Language_Code(Row_.Vendor_No);
      Row_.Wanted_Receipt_Date := Pur_Order_Leadtime_Util_Api.Get_Receipt_Date(Row_.Contract,
                                                                               Row_.Vendor_No,
                                                                               '',
                                                                               Row_.Ship_Via_Code);
      Row_.Price_With_Tax      := Identity_Invoice_Info_Api.Price_With_Tax(Site_Api.Get_Company(Row_.Contract),
                                                                           Row_.Vendor_No,
                                                                           'SUPPLIER');
      --内部订单自动获取默认的库位   modify 2012-12-18
      If Identity_Invoice_Info_Api.Get_Identity_Type(Site_Api.Get_Company(Row_.Contract),
                                                     Row_.Vendor_No,
                                                     'Supplier') = 'INTERN' Then
        Open Cur_ For
          Select t.*
            From Bl_Ciq_Contract_Tab t
           Where t.Contract = Row_.Contract;
        Fetch Cur_
          Into Row1_;
        If Cur_%Found Then
          Pkg_a.Set_Item_Value('BLLOCATION_NO', Row1_.Inlaction, Attr_Out);
        End If;
        Close Cur_;
      End If;
      --END----                                                               
      Pkg_a.Set_Item_Value('VENDOR_NAME', Row_.Vendor_Name, Attr_Out);
      Pkg_a.Set_Item_Value('CONTACT', Row_.Contact, Attr_Out);
      Pkg_a.Set_Item_Value('BUYER_CODE', Row_.Buyer_Code, Attr_Out);
      Pkg_a.Set_Item_Value('PRICE_WITH_TAX', Row_.Price_With_Tax, Attr_Out);
      Pkg_a.Set_Item_Value('CURRENCY_CODE', Row_.Currency_Code, Attr_Out);
      Pkg_a.Set_Item_Value('LANGUAGE_CODE', Row_.Language_Code, Attr_Out);
      Pkg_a.Set_Item_Value('WANTED_RECEIPT_DATE',
                           To_Char(Row_.Wanted_Receipt_Date, 'yyyy-mm-dd'),
                           Attr_Out);
    
    End If;
    If Column_Id_ = 'ORDER_CODE' Then
      --订单代码
      Row_.Order_Code  := Pkg_a.Get_Item_Value('ORDER_CODE', Rowlist_);
      Row_.Description := Purchase_Order_Type_Api.Get_Description(Row_.Order_Code);
      Pkg_a.Set_Item_Value('DESCRIPTION', Row_.Description, Attr_Out);
    End If;
    If Column_Id_ = 'DELIVERY_TERMS' Then
      -- 发货条件
      Row_.Delivery_Terms      := Pkg_a.Get_Item_Value('DELIVERY_TERMS',
                                                       Rowlist_);
      Row_.Language_Code       := Pkg_a.Get_Item_Value('LANGUAGE_CODE',
                                                       Rowlist_);
      Row_.Delivery_Terms_Desc := Order_Delivery_Term_Desc_Api.Get_Description(Row_.Language_Code,
                                                                               Row_.Delivery_Terms);
      Pkg_a.Set_Item_Value('DELIVERY_TERMS_DESC',
                           Row_.Delivery_Terms_Desc,
                           Attr_Out);
    End If;
    If Column_Id_ = 'SHIP_VIA_CODE' Then
      -- 货运方式
      Row_.Ship_Via_Code := Pkg_a.Get_Item_Value('SHIP_VIA_CODE', Rowlist_);
      Row_.Language_Code := Pkg_a.Get_Item_Value('LANGUAGE_CODE', Rowlist_);
      Row_.Ship_Via_Desc := Mpccom_Ship_Via_Desc_Api.Get_Description(Row_.Language_Code,
                                                                     Row_.Ship_Via_Code);
      Pkg_a.Set_Item_Value('SHIP_VIA_DESC', Row_.Ship_Via_Desc, Attr_Out);
    End If;
    If Column_Id_ = 'PAY_TERM_ID' Then
      -- 付款方式
      Row_.Pay_Term_Id         := Pkg_a.Get_Item_Value('PAY_TERM_ID',
                                                       Rowlist_);
      Row_.Company             := Pkg_a.Get_Item_Value('COMPANY', Rowlist_);
      Row_.Payment_Description := Payment_Term_Api.Get_Description(Row_.Company,
                                                                   Row_.Pay_Term_Id);
      Pkg_a.Set_Item_Value('PAYMENT_DESCRIPTION',
                           Row_.Payment_Description,
                           Attr_Out);
    End If;
    --外部客户自动带出客户协议modify fjp 2013-01-30
    If Column_Id_ = 'LABEL_NOTE' Then
      Row_.Label_Note    := Pkg_a.Get_Item_Value('LABEL_NOTE', Rowlist_);
      Row_.Currency_Code := Pkg_a.Get_Item_Value('CURRENCY_CODE', Rowlist_);
      Row_.Contract      := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Open Cur_ For
        Select t.Agreement_Id
          From Customer_Agreement_Lov t
         Where t.Customer_No = Row_.Label_Note
           And t.Contract = Row_.Contract
           And t.Currency_Code = Row_.Currency_Code;
      Fetch Cur_
        Into Row_.Agreement_Id;
      Close Cur_;
      Pkg_a.Set_Item_Value('AGREEMENT_ID', Row_.Agreement_Id, Attr_Out);
    End If;
    If Column_Id_ = 'DESTINATION_ID' Then
      -- 内部标示号
      Row_.Destination_Id       := Pkg_a.Get_Item_Value('DESTINATION_ID',
                                                        Rowlist_);
      Row_.Contract             := Pkg_a.Get_Item_Value('CONTRACT',
                                                        Rowlist_);
      Row_.Internal_Destination := Internal_Destination_Api.Get_Description(Row_.Contract,
                                                                            Row_.Destination_Id);
      Pkg_a.Set_Item_Value('INTERNAL_DESTINATION',
                           Row_.Internal_Destination,
                           Attr_Out);
    End If;
    ---选货币 带出协议标示号
    If Column_Id_ = 'CURRENCY_CODE' Then
      Row_.Currency_Code := Pkg_a.Get_Item_Value('CURRENCY_CODE', Rowlist_);
      Row_.Contract      := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Row_.Label_Note    := Pkg_a.Get_Item_Value('LABEL_NOTE', Rowlist_);
      Pkg_a.Set_Item_Value('AGREEMENT_ID', '', Attr_Out);
      Open Cur_ For
        Select t.*
          From Customer_Agreement_Lov t
         Where t.Customer_No = Row_.Label_Note
           And t.Contract = Row_.Contract
           And t.Currency_Code = Row_.Currency_Code;
      Fetch Cur_
        Into Arow_;
      Close Cur_;
      Pkg_a.Set_Item_Value('AGREEMENT_ID', Arow_.Agreement_Id, Attr_Out);
    End If;
    Outrowlist_ := Attr_Out;
    --  pkg_a.setResult(A311_KEY_,attr_out);   
  End;
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    Row_ Bl_v_Purchase_Order%Rowtype;
  Begin
    Row_.State := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    If Doaction_ = 'I' Then
      Return '1';
    End If;
    If Row_.State = 'Cancelled' Or Row_.State = 'Closed' Then
      Return 0;
    End If;
    If Doaction_ = 'M' Then
      If (Column_Id_ = 'CONTRACT' Or Column_Id_ = 'ORDER_CODE' Or
         Column_Id_ = 'VENDOR_NO' Or Column_Id_ = 'PRICE_WITH_TAX') Then
        Return '0';
      End If;
      Return '1';
    End If;
  End;
  ----检查新增 修改 
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2 Is
  Begin
  
    Return '1';
  End;
  Function Getfeeamount(Order_No_ In Varchar2, Ls_Type_ In Varchar2)
    Return Number Is
    Total_Order_Curr_ Number;
    Cur_              t_Cursor;
    Row_              Bl_v_Purchase_Order_Charge%Rowtype;
  Begin
    Total_Order_Curr_ := 0.0;
    -- 获取费用金额
    Open Cur_ For
      Select t.*
        From Bl_v_Purchase_Order_Charge t
       Where Order_No = Order_No_;
    Fetch Cur_
      Into Row_;
    While Cur_%Found Loop
      If Ls_Type_ = 'TAX_AMOUNT' Then
        Total_Order_Curr_ := Total_Order_Curr_ +
                             (Nvl(Row_.Fcharge_Tax_Amount, 0) -
                             Nvl(Row_.Fcharge_Amount, 0)); --nvl(row_.TAX_AMOUNT,0);
      End If;
      If Ls_Type_ = 'UAMOUNT' Then
        Total_Order_Curr_ := Total_Order_Curr_ +
                             Nvl(Row_.Fcharge_Amount, 0);
      End If;
      Fetch Cur_
        Into Row_;
    End Loop;
    Close Cur_;
    Return Total_Order_Curr_;
  End;
  Function Get_Column_Data_Bl(Column_Id_ In Varchar2,
                              Order_No_  In Varchar2) Return Varchar2 Is
    Sql_    Varchar2(1000);
    Cur_    t_Cursor;
    Result_ Varchar2(500);
  Begin
  
    Sql_ := 'Select ' || Column_Id_ ||
            ' from bl_purchase_order t where t.order_no=''' || Order_No_ || '''';
    Open Cur_ For Sql_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  Exception
    When Others Then
      Return Null;
    
  End;

  Function Getvendorno_User(Contract_  In Varchar2,
                            Vendor_No_ In Varchar2,
                            Uesr_Id_   In Varchar2) Return Varchar2 Is
    Cur_         t_Cursor;
    Row_         A00706%Rowtype;
    Returnexist_ Varchar2(1);
    Ll_Count_    Number;
    Userdate_Id_ Varchar2(100);
  Begin
    --获取数据人员
    Returnexist_ := '0';
    -- Select Bl_Userid Into Userdate_Id_ From A007 Where A007_Id = Uesr_Id_;
    -- 检测数据人员供应商权限  modify 2012-12-12
    Open Cur_ For
      Select * From A00706 Where A007_Id = Uesr_Id_;
    Fetch Cur_
      Into Row_;
    If Cur_%Found Then
      While Cur_%Found Loop
        If Row_.Vendor_No = Vendor_No_ Then
          Returnexist_ := '1';
          Exit;
        End If;
        Fetch Cur_
          Into Row_;
      End Loop;
    Else
      --数据人员域权限
      /*      Select Count(*)
       Into Ll_Count_
       From Bl_Usecon
      Where Userid = Userdate_Id_
        And Contract = Contract_;*/
      --modify fjp 2012-12-12
      Select Count(*)
        Into Ll_Count_
        From A00704
       Where A007_Id = Uesr_Id_
         And Contract = Contract_;
      If Ll_Count_ > 0 Then
        Returnexist_ := '1';
      End If;
    End If;
    Close Cur_;
    Return Returnexist_;
  End;

  --获取采购订单的数量 到 交期为止的数量
  Function Get_Part_Qty_Receipts_Date(Contract_ In Varchar2,
                                      Part_No_  In Varchar2,
                                      Date_     In Date) Return Number Is
    Due_In_Stores_ Number;
    Cursor Get_Receipt_Po Is
      Select Sum(Purchase_Order_Line_Util_Api.Get_Due_In_Inventory(Order_No,
                                                                   Line_No,
                                                                   Release_No))
        From Purchase_Order_Line_Part t
       Where Part_No = Part_No_
         And Contract = Contract_
         And Planned_Receipt_Date = Date_
         And Objstate Not In ('Closed', 'Cancelled');
  Begin
    Open Get_Receipt_Po;
    Fetch Get_Receipt_Po
      Into Due_In_Stores_;
    Close Get_Receipt_Po;
    Return Nvl(Due_In_Stores_, 0);
  End Get_Part_Qty_Receipts_Date;

End Bl_Purchase_Order_Api;
/
