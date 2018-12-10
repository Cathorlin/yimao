Create Or Replace Package Blbill_Vary_Api Is
  --变更录入初始化
  Setnext_Time Constant Number := 0.2; --下级变更时间 分钟
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);
  --变更保存
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  --订单行 变更 新增行   
  -- Rowlist_ 要变更新增的 物料名称 和数量
  -- modi_objid_  当前变更的行 的rowid 
  Procedure Conew__(Rowlist_    Varchar2,
                    User_Id_    Varchar2,
                    A311_Key_   Varchar2,
                    Modi_Objid_ Varchar2);
  ---订单行 变更 修改行                   
  Procedure Comodify__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);

  --无效
  Procedure Coremove__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  -- 订单变更提交
  Procedure Corelease__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2);
  -- 订单变更 取消提交
  Procedure Coreleasecancel__(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);
  -- 订单变更 确认
  Procedure Coapprove__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2);
  -- 订单变更 否决                      
  Procedure Coreleaseclose__(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2);
  -- 订单变更作废
  Procedure Cocancel__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  --  交货计划变更行 新增                        
  Procedure Dpnew__(Rowlist_  Varchar2,
                    User_Id_  Varchar2,
                    A311_Key_ Varchar2);
  --  交货计划变更行 修改                     
  Procedure Dpmodify__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  --无效
  Procedure Dpremove__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  ---备货单变更提交                     
  Procedure Pkrelease__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2);
  --- 备货单变更 取消提交
  Procedure Pkreleasecancel__(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);

  --- 备货单变更 否决
  Procedure Pkreleaseclose__(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2);
  --- 备货单变更 确认
  Procedure Pkapprove__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2);
  --- 备货单变更 作废
  Procedure Pkcancel__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  -- 交货计划变更提交
  Procedure Dprelease__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2);

  --- 交货计划变更 取消提交
  Procedure Dpreleasecancel__(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);
  --交货计划变更(工厂交期)取消提交
  Procedure Dpreleasecancel_f(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);
  --- 交货计划变更 否决
  Procedure Dpreleaseclose__(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2);
  --- 交货计划变更 确认
  Procedure Dpapprove__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2);
  -- 交货计划变更作废
  Procedure Dpcancel__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  --交货计划变更 提交（工厂交期）
  Procedure Dpfrelease__(Rowlist_ Varchar2,
                         --视图的objid
                         User_Id_ Varchar2,
                         --用户id
                         A311_Key_ Varchar2);
  --交货计划 交期变更 确认（工厂交期）
  Procedure Dpfapprove__(Rowlist_ Varchar2,
                         --视图的OBJID
                         User_Id_ Varchar2,
                         --用户ID
                         A311_Key_ Varchar2);
  --交货计划取消提交 （工厂交期）
  Procedure Dpfreleasecancel__(Rowlist_ Varchar2,
                               --视图的OBJID
                               User_Id_ Varchar2,
                               --用户ID
                               A311_Key_ Varchar2);
  --交货计划变更 作废（工厂交期）
  Procedure Dpfcancel__(Rowlist_ Varchar2,
                        --视图的OBJID
                        User_Id_ Varchar2,
                        --用户ID
                        A311_Key_ Varchar2);
  --备货单变更提交（整体修改）
  Procedure Pkdprelease__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);
  --备货单变更取消提交（整体修改）
  Procedure Pkdpreleasecancel__(Rowlist_  Varchar2,
                                User_Id_  Varchar2,
                                A311_Key_ Varchar2);
  --备货单变更  确认（整体修改）
  Procedure Pkdpapprove__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);
  --备货单变更  作废（整体修改）
  Procedure Pkdpcancel__(Rowlist_  Varchar2,
                         User_Id_  Varchar2,
                         A311_Key_ Varchar2);

  --采购订单行 变更 新增行                  
  Procedure Ponew__(Rowlist_    Varchar2,
                    User_Id_    Varchar2,
                    A311_Key_   Varchar2,
                    Modi_Objid_ Varchar2);
  --采购订单变更
  Procedure Posetnext(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2,
                      Order_No_ Varchar Default '-');
  ---采购订单行 变更 修改行   
  Procedure Pomodify__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  --无效
  Procedure Poremove__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  -- 采购订单变更提交        
  Procedure Porelease__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2);
  -- 采购订单变更 取消提交  
  Procedure Poreleasecancel__(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);

  -- 采购订单变更 确认  
  Procedure Poapprove__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2);
  -- 采购订单变更 否决         
  Procedure Poreleaseclose__(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2);

  -- 采购订单变更作废
  Procedure Pocancel__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  --变更记录 提交 只修改 变更表中状态
  Procedure Release__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2,
                      Mainrow_  Out Bl_Bill_Vary%Rowtype);

  --变更记录 取消 提交 只修改 变更表中状态                    
  Procedure Releasecancel__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2,
                            Mainrow_  Out Bl_Bill_Vary%Rowtype);

  --变更记录 确认 只修改 变更表中状态
  Procedure Approve__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2,
                      Mainrow_  Out Bl_Bill_Vary%Rowtype);
  --变更记录 否决 只修改 变更表中状态
  Procedure Releaseclose__(Rowlist_  Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2,
                           Objid_    Out Varchar2,
                           Mainrow_  Out Bl_Bill_Vary%Rowtype);

  --作废交货计划  Rowlist_ 表示是 Bl_Bill_Vary 表的rowid
  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2,
                     Mainrow_  Out Bl_Bill_Vary%Rowtype);

  --客户订单 采购订单变更 引起交货计划变更
  Procedure Setnext(Rowlist_   Varchar2,
                    User_Id_   Varchar2,
                    A311_Key_  Varchar2,
                    Source_No_ Varchar2,
                    Order_No_  Varchar Default '-');
  --客户订单产生  新的变更   备货单变更
  Procedure Cosetnext(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2,
                      Order_No_ Varchar Default '-');
  Procedure Check_Order_Changeqty(Modify_Id_ In Varchar2);
  --获取临时表 BL_temp 的数据
  Procedure Gettemprow(Row_ In Out Bl_Temp%Rowtype);
  --检测交期修改
  Procedure Check_Deliver_Date(Modify_Id_  In Varchar2,
                               Delplan_No_ In Varchar2,
                               New_Date_   In Date);

  --备货单变更N  提交
  Procedure Pkndprelease__(Rowlist_  Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2);
  --备货单变更N 作废
  Procedure Pkndpcancel__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);
  --当字段发生变化执行  
  -- 
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2);
  --载入界面的时候 获取列是否可用
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2;
  Function Checkbutton__(Dotype_   In Varchar2,
                         Main_Key_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2;

  --获取备货单数量
  Function Get_Bl_Pltrans_Qty(Picklistno_   In Varchar2,
                              Order_No_     In Varchar2,
                              Line_No_      In Varchar2,
                              Rel_No_       In Varchar2,
                              Line_Item_No_ In Number) Return Number;
  --清空预留数量
  Procedure Remove_Qty_(Order_No_     In Varchar2,
                        Line_No_      In Varchar2,
                        Rel_No_       In Varchar2,
                        Line_Item_No_ In Number,
                        Picklistno_   In Varchar2,
                        --如果为null 或者为空 表示变更订单数量为  Newqty_
                        Newqty_  In Number,
                        User_Id_ In Varchar2,
                        
                        A311_Key_ In Number Default 0);
  --检测备货单号是否可以变更

  Procedure Check_Bl_Picklist(Picklistno_  In Varchar2,
                              Bl_Picklist_ Out Bl_Picklist%Rowtype);
  --订单价格变更
  Procedure Pricerelease__(Rowlist_ Varchar2,
                           --视图的objid
                           User_Id_ Varchar2,
                           --用户id
                           A311_Key_ Varchar2);
  ---订单价格变更 取消提交
  Procedure Pricereleasecancel__(Rowlist_ Varchar2,
                                 --视图的objid
                                 User_Id_ Varchar2,
                                 --用户id
                                 A311_Key_ Varchar2);
  --订单价格变更 作废
  Procedure Pricecancel__(Rowlist_ Varchar2,
                          --视图的objid
                          User_Id_ Varchar2,
                          --用户id
                          A311_Key_ Varchar2);
  -- 订单 价格变更 确认        
  Procedure Priceapprove__(Rowlist_ Varchar2,
                           --视图的objid
                           User_Id_ Varchar2,
                           --用户id
                           A311_Key_ Varchar2);
  --检测备货单是否可以变更
  Function Check_Pick_Vary(Picklistno_ In Varchar2) Return Number;

  --获取变更的状态
  /*
  --当前的变更号
  --变更状态 
  --上级变更号
  */
  Function Get_Vary_State(Modify_Id_  In Varchar2,
                          State_      In Varchar2,
                          Smodify_Id_ In Varchar2) Return Varchar2;

  --获取变更行下级变更的状态
  Function Get_Vart_Line_State(Modify_Id_    In Varchar2,
                               Order_No_     In Varchar2,
                               Line_No_      In Varchar2,
                               Rel_No_       In Varchar2,
                               Line_Item_No_ In Number,
                               State_        In Varchar2,
                               Modify_Line_  In Number Default 0)
    Return Varchar2;
End Blbill_Vary_Api;
/
Create Or Replace Package Body Blbill_Vary_Api Is
  Type t_Cursor Is Ref Cursor;
  --变更录入初始化
  --Rowlist_ no

  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
    --Attr_       VARCHAR2(4000);
    --Info_       VARCHAR2(4000);
    --Objid_      VARCHAR2(4000);
    --Objversion_ VARCHAR2(4000);
    --Action_     VARCHAR2(100);
    Attr_Out    Varchar2(4000);
    Corow_      Bl_v_Customer_Order%Rowtype;
    Porow_      Bl_v_Purchase_Order%Rowtype;
    Prow_       Bl_v_Cust_Order_Line_Phdelive%Rowtype;
    Row_        Bl_Bill_Vary%Rowtype;
    Pkrow_      Bl_Picklist%Rowtype;
    Bflag_      Varchar2(4000);
    Requesturl_ Varchar2(4000);
    --Option_     VARCHAR2(200);
    Cur_ t_Cursor;
  Begin
    Requesturl_    := Pkg_a.Get_Item_Value('REQUESTURL', Rowlist_);
    Row_.Source_No := Pkg_a.Get_Item_Value_By_Index('&SOURCE_NO=',
                                                    '&',
                                                    Requesturl_);
  
    --Bug 201121019-01
    Row_.Type_Id := Pkg_a.Get_Item_Value_By_Index('&TYPE_ID=',
                                                  '&',
                                                  Requesturl_);
    --Bug 201121019-01
  
    --订单变更
    If Row_.Type_Id = '0' Or Row_.Type_Id = '7' Then
      Open Cur_ For
        Select t.*
          From Bl_v_Customer_Order t
         Where t.Order_No = Row_.Source_No;
      Fetch Cur_
        Into Corow_;
      If Cur_%Found Then
        Pkg_a.Set_Item_Value('ORDER_NO', Corow_.Order_No, Attr_Out);
        Pkg_a.Set_Item_Value('CUSTOMER_NO', Corow_.Customer_No, Attr_Out);
        Pkg_a.Set_Item_Value('CUSTOMER_NAME',
                             Corow_.Customer_Name,
                             Attr_Out);
        Pkg_a.Set_Item_Value('BLORDER_NO', Corow_.Blorder_No, Attr_Out);
        Pkg_a.Set_Item_Value('CONTRACT', Corow_.Contract, Attr_Out);
        Pkg_a.Set_Item_Value('CUSTOMER_REF', Corow_.Label_Note, Attr_Out);
      End If;
      Close Cur_;
    End If;
    --采购订单变更
    If Row_.Type_Id = '1' Then
      Open Cur_ For
        Select t.*
          From Bl_v_Purchase_Order t
         Where t.Order_No = Row_.Source_No;
      Fetch Cur_
        Into Porow_;
      If Cur_ %Found Then
        Pkg_a.Set_Item_Value('ORDER_NO', Porow_.Order_No, Attr_Out);
        Pkg_a.Set_Item_Value('VENDOR_NO', Porow_.Vendor_No, Attr_Out);
        Pkg_a.Set_Item_Value('VENDOR_NAME', Porow_.Vendor_Name, Attr_Out);
        Pkg_a.Set_Item_Value('BLORDER_NO', Porow_.Blorder_No, Attr_Out);
        Pkg_a.Set_Item_Value('CONTRACT', Porow_.Contract, Attr_Out);
        Pkg_a.Set_Item_Value('CUSTOMER_REF', Porow_.Label_Note, Attr_Out);
      End If;
      Close Cur_;
    End If;
    --交货计划的变更
    If Row_.Type_Id = '2' Or Row_.Type_Id = '21' Or Row_.Type_Id = '22' Then
      --表头存放交货计划号 判断传入的是工厂的交货计划 还是业务的交货计划确认--  
      --BL_V_CUSTOMER_ORDER_CHGP_APP
      --BL_V_CUSTOMER_ORDER_CHG_APP
      Corow_.Order_No := Pkg_a.Get_Item_Value_By_Index('&',
                                                       '-',
                                                       '&' || Row_.Source_No);
      Open Cur_ For
        Select t.*
          From Bl_v_Customer_Order t
         Where t.Order_No = Corow_.Order_No;
      Fetch Cur_
        Into Corow_;
      If Cur_%Found Then
        Pkg_a.Set_Item_Value('ORDER_NO', Corow_.Order_No, Attr_Out);
        Pkg_a.Set_Item_Value('CUSTOMER_NO', Corow_.Customer_No, Attr_Out);
        Pkg_a.Set_Item_Value('CUSTOMER_NAME',
                             Corow_.Customer_Name,
                             Attr_Out);
        Pkg_a.Set_Item_Value('BLORDER_NO', Corow_.Blorder_No, Attr_Out);
        Pkg_a.Set_Item_Value('CONTRACT', Corow_.Contract, Attr_Out);
        Pkg_a.Set_Item_Value('CUSTOMER_REF', Corow_.Label_Note, Attr_Out);
      
        Pkg_a.Set_Item_Value('SUPPLIER',
                             Pkg_a.Get_Item_Value_By_Index('-',
                                                           '&',
                                                           Row_.Source_No || '&'),
                             Attr_Out);
      
      End If;
      Close Cur_;
    End If;
  
    --备货当变更
    If Row_.Type_Id = '3' Then
      Pkg_a.Set_Item_Value('CUSTOMER_NAME',
                           Cust_Ord_Customer_Api.Get_Name(Row_.Source_No),
                           Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_NO', Row_.Source_No, Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_REF',
                           Pkg_a.Get_Item_Value_By_Index('&CUSTOMER_REF=',
                                                         '&',
                                                         Requesturl_),
                           Attr_Out);
      Pkg_a.Set_Item_Value('PICKLISTNO',
                           Pkg_a.Get_Item_Value_By_Index('&PICKLISTNO=',
                                                         '&',
                                                         Requesturl_),
                           Attr_Out);
    End If;
    --备货当变更
    If Row_.Type_Id = '6' Then
      Pkg_a.Set_Item_Value('CUSTOMER_NAME',
                           Cust_Ord_Customer_Api.Get_Name(Pkg_a.Get_Item_Value_By_Index('&CUSTOMER_NO=',
                                                                                        '&',
                                                                                        Requesturl_)),
                           Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_NO',
                           Pkg_a.Get_Item_Value_By_Index('&CUSTOMER_NO=',
                                                         '&',
                                                         Requesturl_),
                           Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_REF',
                           Pkg_a.Get_Item_Value_By_Index('&CUSTOMER_REF=',
                                                         '&',
                                                         Requesturl_),
                           Attr_Out);
      Pkg_a.Set_Item_Value('PICKLISTNO', Row_.Source_No, Attr_Out);
    End If;
  
    --交货计划变更（工厂交期）
    If Row_.Type_Id = '4' Then
      Open Cur_ For
        Select t.*
          From Bl_v_Cust_Order_Line_Phdelive t
         Where t.Delplan_No = Row_.Source_No;
      Fetch Cur_
        Into Prow_;
      If Cur_%Notfound Then
        Close Cur_;
        Return;
      End If;
      Close Cur_;
      Pkg_a.Set_Item_Value('ORDER_NO', Prow_.Order_No, Attr_Out);
      Pkg_a.Set_Item_Value('LABEL_NOTE', Prow_.Label_Note, Attr_Out);
      Pkg_a.Set_Item_Value('SUPPLIER', Prow_.Supplier, Attr_Out);
      Pkg_a.Set_Item_Value('DELIVED_DATE',
                           To_Char(Prow_.Delived_Date, 'YYYY-MM-DD'),
                           Attr_Out);
      Pkg_a.Set_Item_Value('PICKLISTNO',
                           Pkg_a.Get_Item_Value_By_Index('&PICKLISTNO=',
                                                         '&',
                                                         Requesturl_),
                           Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_NO', Prow_.Customer_No, Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_NAME',
                           Cust_Ord_Customer_Api.Get_Name(Prow_.Customer_No),
                           Attr_Out);
    End If;
    --备货单变更（整体）
    If Row_.Type_Id = '5' Then
      Bflag_ := Pkg_a.Get_Item_Value_By_Index('&BFLAG=', '&', Requesturl_);
      Open Cur_ For
        Select t.* From Bl_Picklist t Where t.Picklistno = Row_.Source_No;
      Fetch Cur_
        Into Pkrow_;
      If Cur_ %Notfound Then
        Close Cur_;
        Return;
      End If;
      Close Cur_;
      Insert Into A1
        (Col, Col01)
        Select Requesturl_, Bflag_ From Dual;
      Commit;
      If Bflag_ = '1' Then
        Pkg_a.Set_Item_Value('CONTRACT', Pkrow_.Customerno, Attr_Out);
        Pkg_a.Set_Item_Value('CUSTOMER_NO', Pkrow_.Customer_Ref, Attr_Out);
      Else
        Pkg_a.Set_Item_Value('CONTRACT', Pkrow_.Contract, Attr_Out);
        Pkg_a.Set_Item_Value('CUSTOMER_NO', Pkrow_.Customerno, Attr_Out);
      End If;
      Pkg_a.Set_Item_Value('CUSTOMER_NAME',
                           Cust_Ord_Customer_Api.Get_Name(Pkrow_.Customerno),
                           Attr_Out);
      Pkg_a.Set_Item_Value('PICKLISTNO', Row_.Source_No, Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_REF', Pkrow_.Customer_Ref, Attr_Out);
      Pkg_a.Set_Item_Value('DELDATE', Pkrow_.Deldate, Attr_Out);
      Pkg_a.Set_Item_Value('QD_DATE',
                           To_Char(To_Date(Pkrow_.Deldate, 'YYYY-MM-DD') + 7,
                                   'YYYY-MM-DD'),
                           Attr_Out);
    End If;
  
    Row_.State := '0';
    Pkg_a.Set_Item_Value('STATE', Row_.State, Attr_Out);
    Pkg_a.Set_Item_Value('SOURCE_NO', Row_.Source_No, Attr_Out);
    Pkg_a.Set_Item_Value('TYPE_ID', Row_.Type_Id, Attr_Out);
    Pkg_a.Setresult(A311_Key_, Attr_Out);
    Return;
  End;
  --变更录入保存 新增 修改 

  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Index_ Varchar2(1);
    --Co_Chg_Row_ Bl_v_Customer_Order_Chg_App%ROWTYPE;
    ----Po_Chg_Row_ Bl_v_Purchase_Order_Chg_App%ROWTYPE;
    Dp_Chg_Row_  Bl_v_Customer_Order_Chgp_App%Rowtype; --交货计划变更
    Cdp_Chg_Row_ Bl_v_Customer_Order_Chgp_App%Rowtype; --交货计划变更
    Dprow_       Bl_Delivery_Plan_Detial_v%Rowtype;
    Dpmainrow_   Bl_Delivery_Plan%Rowtype;
    Row_         Bl_Bill_Vary%Rowtype;
    Detailrow_   Bl_Bill_Vary_Detail%Rowtype;
    Crow_        Bl_Bill_Vary%Rowtype; --检测变更主档
    --Drow_       Bl_Bill_Vary_Detail%ROWTYPE; --检测变更明细
    Objid_         Varchar2(50);
    Cur_           t_Cursor;
    Doaction_      Varchar2(10);
    Table_Id_      Varchar2(100);
    Delived_Date_  Date;
    Delived_Datef_ Date;
    --Co_Line     Customer_Order_Line%ROWTYPE;
    --Rowdata_    VARCHAR2(4000);
    Rowobjid_     Varchar2(150);
    Agreement_Id_ Varchar2(150);
    Pos_          Number;
    Pos1_         Number;
    Mysql_        Varchar2(2000);
    i             Number;
    v_            Varchar(1000);
    Column_Id_    Varchar(1000);
    Data_         Varchar(4000);
    Ifmychange    Varchar2(10);
  Begin
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    If Doaction_ = 'I' Then
      /*新增*/
      --bl_customer_order_api
      -- bl_bill_vary_type_id      
      Row_.Type_Id   := Pkg_a.Get_Item_Value('TYPE_ID', Rowlist_);
      Row_.Source_No := Pkg_a.Get_Item_Value('SOURCE_NO', Rowlist_);
      --交货计划变更存订单行
      /*      IF Row_.Type_Id = '2'
         OR Row_.Type_Id = '21' THEN
        Row_.Source_No := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
      END IF;*/
      If Row_.Type_Id = '6' Then
        --判断有没有 已经生效 但是还未 完成的变更申请
        Open Cur_ For
          Select t.*
            From Bl_Bill_Vary t
           Where (t.Type_Id = Row_.Type_Id Or t.Type_Id = '5') --5 标示备货单整体修改
             And t.Source_No = Row_.Source_No
             And (t.State = '0' Or t.State = '1'); --新增 和 提交状态
        Fetch Cur_
          Into Crow_;
        If Cur_%Found Then
          Close Cur_;
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Row_.Source_No || '只能存在一份有效的变更申请!');
          Return;
        End If;
        Close Cur_;
      End If;
      If Row_.Type_Id = '2' Or Row_.Type_Id = '21' Or Row_.Type_Id = '22' Then
        Dp_Chg_Row_.Order_No := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
        Dp_Chg_Row_.Supplier := Pkg_a.Get_Item_Value('SUPPLIER', Rowlist_);
        Open Cur_ For
          Select t.*
            From Bl_Delivery_Plan t
           Where t.Order_No = Dp_Chg_Row_.Order_No
             And t.Supplier = Dp_Chg_Row_.Supplier
             And t.State = '2';
        Fetch Cur_
          Into Dpmainrow_;
      
        If Cur_%Notfound Then
        
          Close Cur_;
          Raise_Application_Error(-20101,
                                  Row_.Source_No || '没有确认不需要变更!');
          Return;
        
        Else
          Close Cur_;
        End If;
      
      End If;
    
      --备货单变更
      If Row_.Type_Id = '3' Then
        Pkg_a.Set_Item_Value('PICKLISTNO',
                             Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_),
                             Row_.Rowdata)
        
        ;
      End If;
    
      Bl_Customer_Order_Api.Getseqno(Substr(Row_.Type_Id, 1, 1) ||
                                     To_Char(Sysdate, 'YYMMDD'),
                                     User_Id_,
                                     3,
                                     Row_.Modify_Id);
      Row_.Smodify_Id := Pkg_a.Get_Item_Value('SMODIFY_ID', Rowlist_);
      --检测上级变更是否存在
      If Length(Nvl(Row_.Smodify_Id, '-')) > 2 Then
        Open Cur_ For
          Select t.*
            From Bl_v_Customer_Order_Chgp_App t
           Where t.Smodify_Id = Row_.Smodify_Id
             And t.Source_No = Row_.Source_No;
        Fetch Cur_
          Into Cdp_Chg_Row_;
        If Cur_%Found Then
          Close Cur_;
          Pkg_a.Setsuccess(A311_Key_, Table_Id_, Cdp_Chg_Row_.Objid);
          Return;
        End If;
        Close Cur_;
      End If;
      Row_.Enter_Date   := Sysdate;
      Row_.Enter_User   := User_Id_;
      Row_.Customer_Ref := Pkg_a.Get_Item_Value('CUSTOMER_REF', Rowlist_);
      Row_.State        := '0';
      Row_.Remark       := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      --改交货计划的交期
      If Row_.Type_Id = '4' Then
        Delived_Date_  := To_Date(Pkg_a.Get_Item_Value('DELIVED_DATE',
                                                       Rowlist_),
                                  'YYYY-MM-DD');
        Delived_Datef_ := To_Date(Pkg_a.Get_Item_Value('DELIVED_DATEF',
                                                       Rowlist_),
                                  'YYYY-MM-DD');
        If Delived_Date_ = Delived_Datef_ Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  '交期没有变化，不需要变更!');
          Return;
        End If;
        Pkg_a.Set_Item_Value('DELIVED_DATEF',
                             Pkg_a.Get_Item_Value('DELIVED_DATEF', Rowlist_),
                             Row_.Rowdata);
        Detailrow_.Reason             := Pkg_a.Get_Item_Value('REASON',
                                                              Rowlist_);
        Detailrow_.Reason_Description := Pkg_a.Get_Item_Value('REASON_DESCRIPTION',
                                                              Rowlist_);
        Pkg_a.Set_Item_Value('REASON', Detailrow_.Reason, Row_.Rowdata);
        Pkg_a.Set_Item_Value('REASON_DESCRIPTION',
                             Detailrow_.Reason_Description,
                             Row_.Rowdata);
        Check_Deliver_Date(Row_.Modify_Id, Row_.Source_No, Delived_Datef_);
        /*把交货计划明细的数据插入到系统中*/
        Detailrow_.Modify_Lineno := 0;
        Open Cur_ For
          Select t.*
            From Bl_Delivery_Plan_Detial_v t
           Where t.Delplan_No = Row_.Source_No
             And t.State <> '3'
             And t.Qty_Delived > 0;
        Fetch Cur_
          Into Dprow_;
        Loop
          Exit When Cur_%Notfound;
          Detailrow_.Modify_Id     := Row_.Modify_Id;
          Detailrow_.Modify_Lineno := Dprow_.Delplan_Line;
          Detailrow_.Modify_Lineno := Nvl(Detailrow_.Modify_Lineno, 0) + 1;
          Detailrow_.Order_No      := Dprow_.Order_No;
          Detailrow_.Line_No       := Dprow_.Line_No;
          Detailrow_.Rel_No        := Dprow_.Rel_No;
          Detailrow_.Line_Item_No  := Dprow_.Line_Item_No;
          Detailrow_.Column_No     := Dprow_.Column_No;
          Detailrow_.Picklistno    := Dprow_.Picklistno;
          Detailrow_.Qty_Delived   := Dprow_.Qty_Delived;
          Detailrow_.Qty_Delivedf  := Dprow_.Qty_Delived;
          Detailrow_.Delived_Date  := Delived_Date_;
          Detailrow_.Delived_Datef := Delived_Datef_;
          Detailrow_.State         := Row_.State;
          Detailrow_.Version       := Dprow_.Version;
          Detailrow_.Enter_User    := User_Id_;
          Detailrow_.Enter_Date    := Sysdate;
          Detailrow_.Line_Key      := Dprow_.Delplan_No || '-' ||
                                      To_Char(Dprow_.Delplan_Line);
          Detailrow_.Modify_Type   := Row_.Type_Id;
          Detailrow_.New_Data      := '';
          Insert Into Bl_Bill_Vary_Detail
            (Modify_Id, Modify_Lineno)
          Values
            (Detailrow_.Modify_Id, Detailrow_.Modify_Lineno)
          Returning Rowid Into Rowobjid_;
          Update Bl_Bill_Vary_Detail
             Set Row = Detailrow_
           Where Rowid = Rowobjid_;
          Fetch Cur_
            Into Dprow_;
        End Loop;
      
        Close Cur_;
      End If;
      If Row_.Type_Id = '5' Then
        Pkg_a.Set_Item_Value('PICKLISTNO',
                             Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_),
                             Row_.Rowdata);
        Pkg_a.Set_Item_Value('CONTRACT',
                             Pkg_a.Get_Item_Value('CONTRACT', Rowlist_),
                             Row_.Rowdata);
      
        Open Cur_ For
          Select t.*
            From Bl_Bill_Vary t
           Where (t.Type_Id = Row_.Type_Id Or t.Type_Id = '6') --标示备货单变更
             And t.Source_No = Row_.Source_No
             And (t.State = '0' Or t.State = '1'); --新增 和 提交状态
        Fetch Cur_
          Into Crow_;
        If Cur_%Found Then
          Close Cur_;
          Raise_Application_Error(-20101,
                                  Row_.Source_No || '只能存在一份待批准的变更申请!');
          Return;
        End If;
        Close Cur_;
      End If;
      ---订单价格变更
      If Row_.Type_Id = '7' Then
        If Nvl(Pkg_a.Get_Item_Value('IF_AGREEMENT', Rowlist_), '0') = '1' Then
          Select t.Agreement_Id
            Into Agreement_Id_
            From Bl_v_Customer_Order t
           Where t.Order_No = Row_.Source_No;
          If Nvl(Agreement_Id_, '-') = '-' Then
            Raise_Application_Error(-20101, '订单无协议标示号');
            Return;
          End If;
          Pkg_a.Set_Item_Value('IF_AGREEMENT',
                               Pkg_a.Get_Item_Value('IF_AGREEMENT',
                                                    Rowlist_),
                               Row_.Rowdata);
        
        End If;
      End If;
      Insert Into Bl_Bill_Vary
        (Modify_Id)
      Values
        (Row_.Modify_Id)
      Returning Rowid Into Objid_;
    
      Update Bl_Bill_Vary Set Row = Row_ Where Rowid = Objid_;
    
      --获取不用的变更申请对应的视图
      Select t.Table_Id
        Into Table_Id_
        From Bl_Bill_Vary_Type_Id t
       Where t.Id = Row_.Type_Id;
    
      --回写表的OBJID      
      Pkg_a.Setsuccess(A311_Key_, Table_Id_, Objid_);
    End If;
    If Doaction_ = 'M' Then
      /*修改*/
      Open Cur_ For
        Select t.* From Bl_Bill_Vary t Where Rowidtochar(Rowid) = Objid_;
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
      Mysql_     := 'update bl_bill_vary  set  ';
      Ifmychange := '0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_         := Substr(Data_, 1, Pos_ - 1);
        Data_      := Substr(Data_, Pos_ + 1);
        Pos_       := Instr(Data_, Index_);
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        If Column_Id_ = 'REMARK' Then
          Ifmychange := '1';
          v_         := Substr(v_, Pos1_ + 1);
          Mysql_     := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
        End If;
        --修改交期
        If Row_.Type_Id = '4' Then
          If Column_Id_ = 'DELIVED_DATEF' Or Column_Id_ = 'REASON' Or
             Column_Id_ = 'REASON_DESCRIPTION' Then
            Ifmychange := '1';
            v_         := Substr(v_, Pos1_ + 1);
            --Mysql_     := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
            Pkg_a.Set_Item_Value(Column_Id_, v_, Row_.Rowdata);
            If Column_Id_ = 'DELIVED_DATEF' Then
              Check_Deliver_Date(Row_.Modify_Id,
                                 Row_.Source_No,
                                 To_Date(v_, 'YYYY-MM-DD'));
              Update Bl_Bill_Vary_Detail t
                 Set t.Delived_Datef = To_Date(v_, 'YYYY-MM-DD'),
                     Modi_Date       = Sysdate,
                     Modi_User       = User_Id_
               Where t.Modify_Id = Row_.Modify_Id;
            End If;
            If Column_Id_ = 'REASON' Then
              Update Bl_Bill_Vary_Detail t
                 Set t.Reason  = v_,
                     Modi_Date = Sysdate,
                     Modi_User = User_Id_
               Where t.Modify_Id = Row_.Modify_Id;
            End If;
            If Column_Id_ = 'REASON_DESCRIPTION' Then
              Update Bl_Bill_Vary_Detail t
                 Set t.Reason_Description = v_,
                     Modi_Date            = Sysdate,
                     Modi_User            = User_Id_
               Where t.Modify_Id = Row_.Modify_Id;
            End If;
          
          End If;
        
        End If;
        ---修改价格协议    
        If Row_.Type_Id = '7' Then
          --价格变更
          If Column_Id_ = 'IF_AGREEMENT' Then
            Ifmychange := '1';
            v_         := Substr(v_, Pos1_ + 1);
            Pkg_a.Set_Item_Value(Column_Id_, v_, Row_.Rowdata);
            If Nvl(v_, '0') = '1' Then
              Select t.Agreement_Id
                Into Agreement_Id_
                From Bl_v_Customer_Order t
               Where t.Order_No = Row_.Source_No;
              If Nvl(Agreement_Id_, '-') = '-' Then
                Raise_Application_Error(-20101, '订单无协议标示号');
                Return;
              End If;
            End If;
          End If;
        End If;
      End Loop;
      --保存备注  
      If Ifmychange = '1' Then
        Mysql_ := Mysql_ || 'modi_date= sysdate,modi_user=''' || User_Id_ ||
                  ''' where rowid=''' || Objid_ || '''';
        Execute Immediate Mysql_;
        If Row_.Type_Id = '4' Or Row_.Type_Id = '7' Then
          Update Bl_Bill_Vary
             Set Rowdata = Row_.Rowdata
           Where Rowid = Objid_;
        End If;
      
        Select t.Table_Id
          Into Table_Id_
          From Bl_Bill_Vary_Type_Id t
         Where t.Id = Row_.Type_Id;
        Pkg_a.Setsuccess(A311_Key_, Table_Id_, Objid_);
      End If;
    
      Return;
    End If;
    Return;
  End;

  --检测交货计划变更
  Procedure Check_Deliver_Date(Modify_Id_ In Varchar2,
                               --变更号
                               Delplan_No_ In Varchar2,
                               --交货计划号
                               New_Date_ In Date) Is
    --新交期
    Cur_  t_Cursor;
    Row_  Bl_Delivery_Plan_v%Rowtype;
    Nrow_ Bl_Delivery_Plan_v%Rowtype;
    Crow_ Bl_Bill_Vary_Detail%Rowtype;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan_v t
       Where t.Delplan_No = Delplan_No_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              'Check_Deliver_Date错误的交货计划号' || Delplan_No_);
      Return;
    Else
      Close Cur_;
    End If;
    If Row_.State <> '2' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '交货计划' || Delplan_No_ || '不是确认状态，不能改交期！');
      Return;
    End If;
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan_v t
       Where t.Order_No = Row_.Order_No
         And t.Supplier = Row_.Supplier
         And t.Delived_Date = New_Date_
         And t.State = '2';
    Fetch Cur_
      Into Nrow_;
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              To_Char(New_Date_, 'YYYY-MM-DD') || '存在交货计划' ||
                              Nrow_.Delplan_No || '，不能修改交期！');
    Else
      Close Cur_;
    End If;
    --检测有没有变更
    Open Cur_ For
      Select t.*
        From Bl_Bill_Vary_Detail t
       Where t.Line_Key Like Delplan_No_ || '-%'
         And t.Modify_Id <> Modify_Id_
         And t.State In ('0', '1');
    Fetch Cur_
      Into Crow_;
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '交货计划' || Delplan_No_ || '存在未确认的变更' ||
                              Crow_.Modify_Id || '，不能改交期！');
      Return;
    Else
      Close Cur_;
    End If;
  
    --检测 交期有没有有效的变更
    Open Cur_ For
      Select t.*
        From Bl_Bill_Vary_Detail t
       Inner Join Bl_Bill_Vary T1
          On T1.Modify_Id = t.Modify_Id
         And T1.Source_No = Row_.Order_No || '-' || Row_.Supplier
       Where t.Delived_Datef = New_Date_
         And t.State In ('0', '1')
         And t.Modify_Id <> Modify_Id_;
    Fetch Cur_
      Into Crow_;
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              To_Char(New_Date_, 'YYYY-MM-DD') ||
                              '存在未确认的变更' || Crow_.Modify_Id || '，不能改交期！');
      Return;
    Else
      Close Cur_;
    End If;
  
  End;

  --订单变更  新增行
  --Rowlist_ 包含  ORDER_NO CATALOG_NO CATALOG_DESC BUY_QTY_DUE

  Procedure Conew__(Rowlist_    Varchar2,
                    User_Id_    Varchar2,
                    A311_Key_   Varchar2,
                    Modi_Objid_ Varchar2) Is
    Icorowlist_ Varchar2(4000);
    Mainrow_    Bl_v_Customer_Order%Rowtype;
    Irow_       Bl_v_Customer_Order_Line%Rowtype;
    --Childrow_    Bl_v_Customer_Order_V01%ROWTYPE;
    Cur_         t_Cursor;
    A314_        A314%Rowtype;
    Mainrowlist_ Varchar2(4000);
    Corowlist_   Varchar2(4000);
    Corowlist__  Varchar2(4000);
    A311_        A311%Rowtype;
    --Objid_       VARCHAR2(50);
  Begin
  
    Mainrow_.Order_No := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order t
       Where t.Order_No = Mainrow_.Order_No;
    Fetch Cur_
      Into Mainrow_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, 'Conew__错误的订单号');
      Return;
    End If;
    Corowlist_ := '';
    Pkg_a.Set_Item_Value('ORDER_NO', Mainrow_.Order_No, Corowlist_);
    Pkg_a.Set_Item_Value('LINE_ITEM_NO', '0', Corowlist_);
    --调用 初始化函数
    Select s_A314.Nextval Into A314_.A314_Key From Dual;
    Insert Into A314
      (A314_Key, A314_Id, State, Enter_User, Enter_Date)
      Select A314_.A314_Key, A314_.A314_Key, '0', User_Id_, Sysdate
        From Dual;
    --获取初始化的值
    Bl_Customer_Order_Line_Api.New__(Corowlist_, User_Id_, A314_.A314_Key);
    --获取返回的初始值  
    Select t.Res
      Into Corowlist_
      From A314 t
     Where t.A314_Key = A314_.A314_Key
       And Rownum = 1;
  
    --格式化要传入的参数
    Icorowlist_ := '';
    Pkg_a.Set_Item_Value('OBJID', 'NULL', Icorowlist_);
    Pkg_a.Set_Item_Value('DOACTION', 'I', Icorowlist_);
    Pkg_a.Set_Item_Value('ORDER_NO', Mainrow_.Order_No, Icorowlist_);
    Pkg_a.Set_Item_Value('LINE_ITEM_NO', '0', Icorowlist_);
  
    Pkg_a.Str_Add_Str(Icorowlist_, Corowlist_);
  
    --输入物料编码
    Pkg_a.Get_Row_Str('BL_V_CUSTOMER_ORDER',
                      ' AND ORDER_NO=''' || Mainrow_.Order_No || '''',
                      Mainrowlist_);
  
    --
  
    Irow_.Catalog_No   := Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_);
    Irow_.Catalog_Desc := Pkg_a.Get_Item_Value('CATALOG_DESC', Rowlist_);
    Irow_.Buy_Qty_Due  := Pkg_a.Get_Item_Value('BUY_QTY_DUE', Rowlist_);
  
    Pkg_a.Set_Item_Value('CATALOG_NO', Irow_.Catalog_No, Icorowlist_);
    Pkg_a.Set_Item_Value('CATALOG_DESC', Irow_.Catalog_Desc, Icorowlist_);
  
    Bl_Customer_Order_Line_Api.Itemchange__('CATALOG_NO',
                                            Mainrowlist_,
                                            Icorowlist_,
                                            User_Id_,
                                            Corowlist_);
  
    Pkg_a.Str_Add_Str(Icorowlist_, Corowlist_);
  
    Irow_.Supply_Code := Pkg_a.Get_Item_Value('SUPPLY_CODE', Rowlist_);
    Pkg_a.Set_Item_Value('SUPPLY_CODE', Irow_.Supply_Code, Icorowlist_);
    Bl_Customer_Order_Line_Api.Itemchange__('SUPPLY_CODE',
                                            Mainrowlist_,
                                            Icorowlist_,
                                            User_Id_,
                                            Corowlist_);
  
    --把 返回的数据 合并到  Icorowlist_中
    Pkg_a.Str_Add_Str(Icorowlist_, Corowlist_);
  
    --输入数量
    Pkg_a.Set_Item_Value('BUY_QTY_DUE', Irow_.Buy_Qty_Due, Icorowlist_);
    Bl_Customer_Order_Line_Api.Itemchange__('BUY_QTY_DUE',
                                            Mainrowlist_,
                                            Icorowlist_,
                                            User_Id_,
                                            Corowlist_);
  
    Pkg_a.Str_Add_Str(Icorowlist_, Corowlist_);
  
    A311_.A311_Id    := 'Blbill_Vary_Api.Conew__';
    A311_.Enter_User := User_Id_;
    A311_.A014_Id    := 'A014_ID=SAVE';
    A311_.Table_Id   := 'BL_V_CUSTOMER_ORDER_LINE';
    Pkg_a.Beginlog(A311_);
    Bl_Customer_Order_Line_Api.Modify__(Icorowlist_,
                                        User_Id_,
                                        A311_.A311_Key);
    Open Cur_ For
      Select t.* From A311 t Where t.A311_Key = A311_.A311_Key;
    Fetch Cur_
      Into A311_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, 'Conew__处理失败');
      Return;
    End If;
    Close Cur_;
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order_Line t
       Where t.Objid = A311_.Table_Objid;
    Fetch Cur_
      Into Irow_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, 'Conew__处理失败');
      Return;
    End If;
    --判断当前生成的订单行 
    --获取生成订单的下域订单并且下达掉
    Update Bl_Bill_Vary_Detail t
       Set t.Order_No     = Irow_.Order_No,
           t.Line_No      = Irow_.Line_No,
           t.Rel_No       = Irow_.Rel_No,
           t.Line_Item_No = Irow_.Line_Item_No
     Where Rowid = Modi_Objid_;
  
    Return;
  End;
  Procedure Setnext(Rowlist_   Varchar2,
                    User_Id_   Varchar2,
                    A311_Key_  Varchar2,
                    Source_No_ Varchar2,
                    Order_No_  Varchar Default '-') Is
    Cur_ t_Cursor;
    Row_ Bl_Bill_Vary%Rowtype;
    Res_ Number;
  Begin
  
    Open Cur_ For
      Select t.* From Bl_Bill_Vary t Where Rowid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的ROWID');
      Return;
    End If;
    Close Cur_;
  
    If Row_.Type_Id = '0' Then
      Cosetnext(Rowlist_, User_Id_, A311_Key_, Order_No_);
    End If;
    If Row_.Type_Id = '1' Then
      Posetnext(Rowlist_, User_Id_, A311_Key_, Order_No_);
    End If;
  End;
  --客户订单产生  交货计划变更
  /*
  Rowlist_  Bl_Bill_Vary的rowid
   */
  Procedure Cosetnext(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2,
                      Order_No_ Varchar Default '-') Is
    Row_       Bl_Bill_Vary%Rowtype;
    Detailrow_ Bl_v_Customer_Order_Chg_Det%Rowtype; --变更行  
  
    Detailrow_Auto_ Bl_v_Customer_Order_Chg_Det%Rowtype; --变更行  
    Cur_            t_Cursor;
    Cur1_           t_Cursor;
    Cur2_           t_Cursor;
    Cur3_           t_Cursor;
    Temp_Row_       Bl_Temp%Rowtype;
    Temp_Key_       Number;
    Supplier_       Varchar2(100);
    Dpmainrow_      Bl_Delivery_Plan_v%Rowtype; --交货计划
    Dpdetailrow_    Bl_Delivery_Plan_Detial_v%Rowtype; --交货计划
    --coline_         bl_v_customer_order_line%ROWTYPE;
    Newrow_         Bl_Bill_Vary_v%Rowtype;
    Newrowlist_     Varchar2(30000);
    Co_             Bl_v_Customer_Order%Rowtype;
    A311_           A311%Rowtype;
    Newdetaillist_  Varchar2(30000);
    Inewdetaillist_ Varchar2(30000);
    Idetaillist_    Varchar2(30000);
    If_End          Varchar2(1);
  Begin
    Open Cur_ For
      Select t.* From Bl_Bill_Vary t Where Rowid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的ROWID');
      Return;
    End If;
    Close Cur_;
  
    Update Bl_Bill_Vary t --更新主档 状态
       Set t.Data_Lock = '0', t.Lock_User = Null
     Where Modify_Id = Row_.Modify_Id;
  
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order t
       Where t.Order_No = Row_.Source_No;
    Fetch Cur_
      Into Co_;
    Close Cur_;
  
    Select s_Bl_Temp.Nextval Into Temp_Key_ From Dual;
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order_Chg_Det t
       Where t.Modify_Id = Row_.Modify_Id
         And t.Modify_Type In ('I', 'M');
    Fetch Cur_
      Into Detailrow_;
    Loop
      Exit When Cur_%Notfound;
      --修改数量
      Supplier_ := Bl_Customer_Order_Line_Api.Get_Factory_Order_(Detailrow_.Order_No,
                                                                 Detailrow_.Line_No,
                                                                 Detailrow_.Rel_No,
                                                                 Detailrow_.Line_Item_No,
                                                                 '1');
      --获取 订单行的工厂域
      Open Cur1_ For
        Select t.*
          From Bl_Delivery_Plan_v t
         Where t.Order_No = Row_.Source_No
           And t.Supplier = Supplier_
           And (t.State = '2' Or t.State = '1'); --提交状态 和 确认状态 
      Fetch Cur1_
        Into Dpmainrow_;
      If Cur1_%Found Then
        --如果只是下达状态 取消下达 让工厂修改
        If Dpmainrow_.State = '1' Then
          A311_.A311_Id     := 'Blbill_Vary_Api.CoSetNext';
          A311_.Enter_User  := User_Id_;
          A311_.A014_Id     := 'A014_ID=Order_PCancel';
          A311_.Table_Id    := 'BL_V_CUST_DELIVERY_PLAN';
          A311_.Table_Objid := Row_.Source_No || '-' || Supplier_;
          Pkg_a.Beginlog(A311_);
          Pkg_a.Doa014('Order_PCancel',
                       'BL_V_CUST_DELIVERY_PLAN',
                       A311_.Table_Objid,
                       User_Id_,
                       A311_.A311_Key);
        
        End If;
        If Dpmainrow_.State = '2' Then
          --产生交货计划变更变更申请 --
          Open Cur2_ For
            Select t.*
              From Bl_Temp t
             Where t.Tempkey = Temp_Key_
               And t.Rowkey = Co_.Order_No || '-' || Supplier_;
          Fetch Cur2_
            Into Temp_Row_;
          If Cur2_%Found Then
            Newrowlist_ := Temp_Row_.Rowlist;
          Else
            Temp_Row_.Rowkey  := Co_.Order_No || '-' || Supplier_;
            Temp_Row_.Tempkey := Temp_Key_;
          
            Newrowlist_      := '';
            A311_.A311_Id    := 'Blbill_Vary_Api.CoSetNext';
            A311_.Enter_User := User_Id_;
            A311_.A014_Id    := 'A014_ID=SAVE';
            A311_.Table_Id   := 'BL_BILL_VARY_V';
            Pkg_a.Beginlog(A311_);
            Pkg_a.Set_Item_Value('DOACTION', 'I', Newrowlist_);
            Pkg_a.Set_Item_Value('OBJID', '', Newrowlist_);
            Pkg_a.Set_Item_Value('MODIFY_ID', '', Newrowlist_);
            Pkg_a.Set_Item_Value('ORDER_NO', Co_.Order_No, Newrowlist_);
            Pkg_a.Set_Item_Value('SUPPLIER', Supplier_, Newrowlist_);
            Pkg_a.Set_Item_Value('SOURCE_NO',
                                 Temp_Row_.Rowkey,
                                 Newrowlist_);
            Pkg_a.Set_Item_Value('CUSTOMER_NO',
                                 Co_.Customer_No,
                                 Newrowlist_);
            Pkg_a.Set_Item_Value('STATE', '0', Newrowlist_);
            Pkg_a.Set_Item_Value('SMODIFY_ID', Row_.Modify_Id, Newrowlist_);
            Pkg_a.Set_Item_Value('CUSTOMER_REF',
                                 Co_.Label_Note,
                                 Newrowlist_);
            Pkg_a.Set_Item_Value('TYPE_ID', '2', Newrowlist_);
            Blbill_Vary_Api.Modify__(Newrowlist_, User_Id_, A311_.A311_Key);
            Open Cur3_ For
              Select t.* From A311 t Where t.A311_Key = A311_.A311_Key;
            Fetch Cur3_
              Into A311_;
            Close Cur3_;
            Open Cur3_ For
              Select t.*
                From Bl_Bill_Vary_v t
               Where t.Objid = A311_.Table_Objid;
            Fetch Cur3_
              Into Newrow_;
            Close Cur3_;
            Pkg_a.Set_Item_Value('OBJID', Newrow_.Objid, Newrowlist_);
            Pkg_a.Set_Item_Value('MODIFY_ID',
                                 Newrow_.Modify_Id,
                                 Newrowlist_);
            Temp_Row_.Rowlist := Newrowlist_;
            Insert Into Bl_Temp_Tab
              (Tempkey, Rowkey, Rowlist)
            Values
              (Temp_Row_.Tempkey, Temp_Row_.Rowkey, Temp_Row_.Rowlist);
          End If;
        
          Close Cur2_;
          Newdetaillist_  := '';
          Inewdetaillist_ := '';
          Pkg_a.Set_Item_Value('DOACTION', 'I', Inewdetaillist_);
          Pkg_a.Set_Item_Value('OBJID', '', Inewdetaillist_);
          Pkg_a.Set_Item_Value('MODIFY_ID',
                               Pkg_a.Get_Item_Value('MODIFY_ID',
                                                    Newrowlist_),
                               Inewdetaillist_);
        
          --把交货计划数量改为0 
          Detailrow_.Qty_Delived := 0;
        
          Pkg_a.Set_Item_Value('LINE_KEY',
                               Detailrow_.Order_No || '-' ||
                               Detailrow_.Line_No || '-' ||
                               Detailrow_.Rel_No || '-' ||
                               Detailrow_.Line_Item_No,
                               Inewdetaillist_);
          Blbill_Vary_Line_Api.Itemchange__('LINE_KEY',
                                            Newrowlist_,
                                            Inewdetaillist_,
                                            User_Id_,
                                            Newdetaillist_);
          --把 返回的数据 合并到  Icorowlist_中
          Pkg_a.Str_Add_Str(Inewdetaillist_, Newdetaillist_);
          --开始处理数量 
          Pkg_a.Set_Item_Value('BASE_NO',
                               Detailrow_.Modify_Id,
                               Inewdetaillist_);
          Pkg_a.Set_Item_Value('BASE_LINE',
                               Detailrow_.Modify_Lineno,
                               Inewdetaillist_);
        
          Pkg_a.Set_Item_Value('MODIFY_TYPE', 'DPM', Inewdetaillist_);
          Open Cur3_ For
            Select t.*
              From Bl_Delivery_Plan_Detial_v t
             Where t.Order_No = Detailrow_.Order_No
               And t.Line_No = Detailrow_.Line_No
               And t.Rel_No = Detailrow_.Rel_No
               And t.Line_Item_No = Detailrow_.Line_Item_No
               And (t.State = '2' Or t.State = '4' Or t.State = '5')
             Order By t.State Desc, t.Delived_Date Asc;
          Fetch Cur3_
            Into Dpdetailrow_;
          If_End                := '0';
          Detailrow_Auto_.State := '0';
          Detailrow_.State      := '0';
          Loop
            Exit When Cur3_%Notfound;
            --当已算 交货计划 + 当前 计划数量大于 订单数
            Idetaillist_ := Inewdetaillist_;
            If Detailrow_.Qty_Delived + Dpdetailrow_.Qty_Delived >
               Detailrow_.Qty_Delivedf Then
            
              --当前行数量 减少            
              Pkg_a.Set_Item_Value('PLAN_LINE_KEY',
                                   Dpdetailrow_.Delplan_No || '-' ||
                                   Dpdetailrow_.Delplan_Line,
                                   Idetaillist_);
              Blbill_Vary_Line_Api.Itemchange__('PLAN_LINE_KEY',
                                                Newrowlist_,
                                                Idetaillist_,
                                                User_Id_,
                                                Newdetaillist_);
              --把 返回的数据 合并到  Icorowlist_中
              Pkg_a.Str_Add_Str(Idetaillist_, Newdetaillist_);
            
              --余下未发货的数量
              -- detailrow_.QTY_DELIVEDF 
              If If_End = '0' Then
                Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                                     Detailrow_.Qty_Delivedf -
                                     Detailrow_.Qty_Delived,
                                     Idetaillist_);
                If_End := '1';
              Else
                Pkg_a.Set_Item_Value('QTY_DELIVEDF', '0', Idetaillist_);
                If_End := '1';
              End If;
              --插入明细
            
              Blbill_Vary_Line_Api.Modify__(Idetaillist_,
                                            User_Id_,
                                            A311_Key_);
            
            End If;
            Detailrow_.Qty_Delived := Detailrow_.Qty_Delived +
                                      Dpdetailrow_.Qty_Delived;
            If Dpdetailrow_.State = '2' Then
              If Bldelivery_Plan_Api.Get_Type_Id(Dpdetailrow_.Delplan_No) =
                 'AUTO' Then
                --把数量加入到自动生成中
                Detailrow_Auto_.Delived_Datef := Dpdetailrow_.Delived_Date;
                Detailrow_Auto_.Column_No     := Dpdetailrow_.Qty_Delived;
                Detailrow_Auto_.State         := '1';
              End If;
              Detailrow_.Delived_Datef := Dpdetailrow_.Delived_Date;
              Detailrow_.Column_No     := Dpdetailrow_.Qty_Delived;
              Detailrow_.State         := '1';
            End If;
          
            Fetch Cur3_
              Into Dpdetailrow_;
          End Loop;
          Close Cur3_;
          --如果数量还不足 把数量加入到 自动生成的交货计划中
          If Detailrow_.Qty_Delived < Detailrow_.Qty_Delivedf Then
            Idetaillist_ := Inewdetaillist_;
            --自动未发货
            If Detailrow_Auto_.State = '1' Then
              --把数量加入到最后一个 日期里面 加 1 天    
            
              Pkg_a.Set_Item_Value('DELIVED_DATEF',
                                   To_Char(Detailrow_Auto_.Delived_Datef,
                                           'YYYY-MM-DD'),
                                   Idetaillist_);
              Blbill_Vary_Line_Api.Itemchange__('DELIVED_DATEF',
                                                Newrowlist_,
                                                Idetaillist_,
                                                User_Id_,
                                                Newdetaillist_);
              Pkg_a.Str_Add_Str(Idetaillist_, Newdetaillist_);
              --把 返回的数据 合并到  Icorowlist_中
              Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                                   Detailrow_Auto_.Column_No +
                                   Detailrow_.Qty_Delivedf -
                                   Detailrow_.Qty_Delived,
                                   Idetaillist_);
            Else
              If Detailrow_.State = '1' Then
                --把数量加入到最后一个 日期里面 加 1 天    
                Pkg_a.Set_Item_Value('DELIVED_DATEF',
                                     To_Char(Detailrow_.Delived_Datef,
                                             'YYYY-MM-DD'),
                                     Idetaillist_);
                Blbill_Vary_Line_Api.Itemchange__('DELIVED_DATEF',
                                                  Newrowlist_,
                                                  Idetaillist_,
                                                  User_Id_,
                                                  Newdetaillist_);
                --把 返回的数据 合并到  Icorowlist_中
                Pkg_a.Str_Add_Str(Idetaillist_, Newdetaillist_);
                Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                                     Detailrow_.Column_No +
                                     Detailrow_.Qty_Delivedf -
                                     Detailrow_.Qty_Delived,
                                     Idetaillist_);
              Else
                --把数量加入到最后一个 日期里面 加 1 天
                Pkg_a.Set_Item_Value('MODIFY_TYPE', 'DPI', Idetaillist_);
                Pkg_a.Set_Item_Value('DELIVED_DATEF',
                                     '2099-01-01',
                                     Idetaillist_);
                Blbill_Vary_Line_Api.Itemchange__('DELIVED_DATEF',
                                                  Newrowlist_,
                                                  Idetaillist_,
                                                  User_Id_,
                                                  Newdetaillist_);
                --把 返回的数据 合并到  Icorowlist_中
                Pkg_a.Str_Add_Str(Idetaillist_, Newdetaillist_);
                Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                                     Detailrow_.Qty_Delivedf -
                                     Detailrow_.Qty_Delived,
                                     Idetaillist_);
              
              End If;
            End If;
          
            --插入明细
            Blbill_Vary_Line_Api.Modify__(Idetaillist_,
                                          User_Id_,
                                          A311_Key_);
          
          End If;
        
          --   begin BLBILL_VARY_API.Modify__
          --  ('DOACTION|IOBJID|MODIFY_ID|SOURCE_NO|770013CUSTOMER_NO|770013CUSTOMER_NAME|770013STATE|1SMODIFY_ID|CUSTOMER_REF|770013DATE_PUTED|2012-10-22DATE_COMFORM|DATE_CLOSED|REJECT_ID|REJECT_NAME|REJECT_REMARK|PICKLISTNO|12B0013001TYPE_ID|3REMARK|','WTL','20268'); end;
        
        End If;
      End If;
      Close Cur1_;
      Fetch Cur_
        Into Detailrow_;
    End Loop;
    Close Cur_;
  
  End;

  --修改订单数量
  Procedure Comodify__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
    Cur_       t_Cursor;
    Row_       Customer_Order_Line%Rowtype;
    Cchildrow_ Customer_Order_Line%Rowtype;
    Newrow_    Customer_Order_Line%Rowtype;
    Childrow_  Purchase_Order_Line_Tab%Rowtype;
    --Attr_      Varchar2(4000);
    --Info_      Varchar2(4000);
    --Objid_      VARCHAR2(4000);
    --Objversion_ VARCHAR2(4000);
    --Action_    Varchar2(200);
    Corowlist_ Varchar2(4000);
    Porowlist_ Varchar2(4000);
    Bl_Bill_   Bl_Bill_Vary_Detail_v%Rowtype;
  Begin
    Row_.Order_No     := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
    Row_.Line_No      := Pkg_a.Get_Item_Value('LINE_NO', Rowlist_);
    Row_.Rel_No       := Pkg_a.Get_Item_Value('REL_NO', Rowlist_);
    Row_.Line_Item_No := Pkg_a.Get_Item_Value('LINE_ITEM_NO', Rowlist_);
    Open Cur_ For
      Select t.*
        From Customer_Order_Line t
       Where t.Order_No = Row_.Order_No
         And t.Line_No = Row_.Line_No
         And t.Rel_No = Row_.Rel_No
         And t.Line_Item_No = Row_.Line_Item_No;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的订单号');
      Return;
    End If;
    Close Cur_;
    --检测订单行是否存在未处理的变更
    Open Cur_ For
      Select t.*
        From Bl_Bill_Vary_Detail_v t
       Where t.Order_No = Row_.Order_No
         And t.Line_No = Row_.Line_No
         And t.Rel_No = Row_.Rel_No
         And t.Line_Item_No = Row_.Line_Item_No
         And t.State In ('0', '1');
    Fetch Cur_
      Into Bl_Bill_;
    If Cur_%Found Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '订单行' || Row_.Order_No || '-' || Row_.Line_No || '-' ||
                              Row_.Rel_No || '-' || Row_.Line_Item_No || '(' ||
                              Row_.Catalog_No || ')存在未处理的变更' ||
                              Bl_Bill_.Modify_Id || '!');
    
    End If;
    Close Cur_;
  
    --Action_             := 'DO';
    Newrow_.Buy_Qty_Due := Pkg_a.Get_Item_Value('BUY_QTY_DUE', Rowlist_);
    If Row_.Buy_Qty_Due > Newrow_.Buy_Qty_Due Then
      --找工厂的订单行
      --包装件
      If Row_.Line_Item_No = -1 Then
        Open Cur_ For
          Select t.*
            From Customer_Order_Line t
           Where t.Order_No = Row_.Order_No
             And t.Line_No = Row_.Line_No
             And t.Rel_No = Row_.Rel_No
             And t.Line_Item_No > 0;
        Fetch Cur_
          Into Cchildrow_;
        Loop
          Exit When Cur_%Notfound;
          If Cchildrow_.Qty_On_Order > 0 And
             Cchildrow_.Qty_Assigned + Cchildrow_.Qty_On_Order >
             Newrow_.Buy_Qty_Due * Cchildrow_.Buy_Qty_Due /
             Row_.Buy_Qty_Due - Cchildrow_.Qty_Shipped Then
            Bl_Customer_Order_Line_Api.Remover_Qty_Shop_Order(Row_.Order_No,
                                                              Row_.Line_No,
                                                              Row_.Rel_No,
                                                              Row_.Line_Item_No);
          
          End If;
          If Row_.Qty_Assigned >
             Newrow_.Buy_Qty_Due * Cchildrow_.Buy_Qty_Due /
             Row_.Buy_Qty_Due - Cchildrow_.Qty_Shipped Then
            Bl_Customer_Order_Line_Api.Remove_Qty_Assigned(Row_.Objid,
                                                           User_Id_,
                                                           A311_Key_);
          End If;
          Fetch Cur_
            Into Cchildrow_;
        End Loop;
        Close Cur_;
      Else
        If Row_.Qty_On_Order > 0 And Row_.Qty_Assigned + Row_.Qty_On_Order >
           Newrow_.Buy_Qty_Due - Row_.Qty_Shipped Then
          Bl_Customer_Order_Line_Api.Remover_Qty_Shop_Order(Row_.Order_No,
                                                            Row_.Line_No,
                                                            Row_.Rel_No,
                                                            Row_.Line_Item_No);
        
        End If;
        If Row_.Qty_Assigned > Newrow_.Buy_Qty_Due - Row_.Qty_Shipped Then
          Bl_Customer_Order_Line_Api.Remove_Qty_Assigned(Row_.Objid,
                                                         User_Id_,
                                                         A311_Key_);
        End If;
      
      End If;
    
      Open Cur_ For
        Select t.*
          From Customer_Order_Line t
         Where t.Order_No = Row_.Order_No
           And t.Line_No = Row_.Line_No
           And t.Rel_No = Row_.Rel_No
           And t.Line_Item_No = Row_.Line_Item_No;
      Fetch Cur_
        Into Row_;
      Close Cur_;
    
    End If;
  
    Corowlist_ := '';
    Pkg_a.Set_Item_Value('DOACTION', 'M', Corowlist_);
    Pkg_a.Set_Item_Value('OBJID', Row_.Objid, Corowlist_);
    Pkg_a.Set_Item_Value('BUY_QTY_DUE', Newrow_.Buy_Qty_Due, Corowlist_);
  
    Bl_Customer_Order_Line_Api.Modify__(Corowlist_, User_Id_, A311_Key_);
    -- Client_Sys.Add_To_Attr('BUY_QTY_DUE', Newrow_.Buy_Qty_Due, Attr_);
    --BL_Customer_Order_Line_Api.Modify__(Info_,
    --                       Row_.Objid,
    --                      Row_.Objversion,
    --                       Attr_,
    --                        Action_);
  
    ---找订单对应的采购订单
    Open Cur_ For
      Select t.*
        From Purchase_Order_Line_Tab t
       Where t.Demand_Order_No = Row_.Order_No
         And t.Demand_Release = Row_.Line_No
         And t.Demand_Sequence_No = Row_.Rel_No
         And t.Demand_Operation_No = Row_.Line_Item_No;
    Fetch Cur_
      Into Childrow_;
    If Cur_%Found Then
      Close Cur_;
      Porowlist_ := '';
      Pkg_a.Set_Item_Value('ORDER_NO', Childrow_.Order_No, Porowlist_);
      Pkg_a.Set_Item_Value('LINE_NO', Childrow_.Line_No, Porowlist_);
      Pkg_a.Set_Item_Value('RELEASE_NO', Childrow_.Release_No, Porowlist_);
      Pkg_a.Set_Item_Value('BUY_QTY_DUE', Newrow_.Buy_Qty_Due, Porowlist_);
      Pomodify__(Porowlist_, User_Id_, A311_Key_);
      Return;
    End If;
    Close Cur_;
    --'CUSTOMER_PART_BUY_QTYBUY_QTY_DUE600SALES_UNIT_MEASpcsPART_PRICE9.13PRICE_SOURCE基本PRICE_SOURCE_IDSALE_UNIT_PRICE9.13SALE_UNIT_PRICE_WITH_TAX9.13PRICE_UNIT_MEASpcsBASE_SALE_UNIT_PRICE57.53CURRENCY_RATE6.3009PRICE_CONV_FACTOR1REVISED_QTY_DUE600CHANGE_REQUESTFALSE')
  
  End;
  --取消订单行
  Procedure Coremove__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
    Cur_ t_Cursor;
    Row_ Customer_Order_Line%Rowtype;
    --Childrow_   Purchase_Order_Line_Tab%ROWTYPE;
    --Attr_       VARCHAR2(4000);
    --Info_       VARCHAR2(4000);
    --Objid_      VARCHAR2(4000);
    --Objversion_ VARCHAR2(4000);
    ----Action_     VARCHAR2(200);
    --Corowlist_  VARCHAR2(4000);
    --Porowlist_  VARCHAR2(4000);
  Begin
    Row_.Order_No     := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
    Row_.Line_No      := Pkg_a.Get_Item_Value('LINE_NO', Rowlist_);
    Row_.Rel_No       := Pkg_a.Get_Item_Value('REL_NO', Rowlist_);
    Row_.Line_Item_No := Pkg_a.Get_Item_Value('LINE_ITEM_NO', Rowlist_);
    Open Cur_ For
      Select t.*
        From Customer_Order_Line t
       Where t.Order_No = Row_.Order_No
         And t.Line_No = Row_.Line_No
         And t.Rel_No = Row_.Rel_No
         And t.Line_Item_No = Row_.Line_Item_No;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的订单号');
      Return;
    End If;
  
    Return;
  End;
  --作废
  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2,
                     Mainrow_  Out Bl_Bill_Vary%Rowtype) Is
    Cur_   t_Cursor;
    Rowid_ Varchar2(1000);
    --Irow_  Bl_Bill_Vary_Detail%ROWTYPE;
    --Table_ VARCHAR2(1000);
  Begin
    Rowid_ := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_Bill_Vary t Where t.Rowid = Rowid_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    If Mainrow_.State <> '0' Then
      Raise_Application_Error(-20101, '只能保存状态才能作废');
      Return;
    End If;
  
    Update Bl_Bill_Vary --更新主档 状态
       Set State = '5', Date_Puted = Sysdate, Modi_User = User_Id_
     Where Modify_Id = Mainrow_.Modify_Id;
    Update Bl_Bill_Vary_Detail --更新明细行状态
       Set State = '5', Modi_Date = Sysdate, Modi_User = User_Id_
     Where Modify_Id = Mainrow_.Modify_Id;
  
  End;

  --提交
  Procedure Release__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2,
                      Mainrow_  Out Bl_Bill_Vary%Rowtype) Is
    Cur_   t_Cursor;
    Rowid_ Varchar2(1000);
    Irow_  Bl_Bill_Vary_Detail%Rowtype;
    --Table_ VARCHAR2(1000);
  Begin
    Rowid_ := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_Bill_Vary t Where t.Rowid = Rowid_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    If Mainrow_.State <> '0' Then
      Raise_Application_Error(-20101, '只有保存状态才能提交');
      Return;
    End If;
  
    Open Cur_ For
      Select t.*
        From Bl_Bill_Vary_Detail t
       Where t.Modify_Id = Mainrow_.Modify_Id
         And t.State <> '4';
    Fetch Cur_
      Into Irow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '明细无保存状态数据');
      Return;
    End If;
    Close Cur_;
    Update Bl_Bill_Vary --更新主档 状态
       Set State = '1', Date_Puted = Sysdate, Modi_User = User_Id_
     Where Modify_Id = Mainrow_.Modify_Id;
    Update Bl_Bill_Vary_Detail --更新明细行状态
       Set State = '1', Modi_Date = Sysdate, Modi_User = User_Id_
     Where Modify_Id = Mainrow_.Modify_Id;
  
  End;

  --取消提交
  Procedure Releasecancel__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2,
                            Mainrow_  Out Bl_Bill_Vary%Rowtype) Is
    Cur_   t_Cursor;
    Rowid_ Varchar2(1000);
    Irow_  Bl_Bill_Vary_Detail%Rowtype;
    --Table_ VARCHAR2(1000);
  Begin
    Rowid_ := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_Bill_Vary t Where t.Rowid = Rowid_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
  
    If Mainrow_.State <> '1' Then
      Raise_Application_Error(-20101, '只能提交状态才能取消提交！');
      Return;
    End If;
  
    Open Cur_ For
      Select t.*
        From Bl_Bill_Vary_Detail t
       Where t.Modify_Id = Mainrow_.Modify_Id
         And t.State <> '4';
    Fetch Cur_
      Into Irow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '明细行无提交状态数据');
      Return;
    End If;
    Close Cur_;
  
    Update Bl_Bill_Vary --更新主档 状态
       Set State      = '0',
           Modi_Date  = Sysdate,
           Modi_User  = User_Id_,
           Date_Puted = Null
     Where Modify_Id = Mainrow_.Modify_Id;
    Update Bl_Bill_Vary_Detail --更新明细行状态
       Set State = '0', Modi_Date = Sysdate, Modi_User = User_Id_
     Where Modify_Id = Mainrow_.Modify_Id;
  
  End;

  --确认
  Procedure Approve__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2,
                      Mainrow_  Out Bl_Bill_Vary%Rowtype) Is
    Cur_   t_Cursor;
    Rowid_ Varchar2(1000);
    Irow_  Bl_Bill_Vary_Detail%Rowtype;
    --Table_ VARCHAR2(1000);
  Begin
    Rowid_ := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_Bill_Vary t Where t.Rowid = Rowid_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
  
    If Mainrow_.State <> '1' Then
      Raise_Application_Error(-20101, '只能提交状态才能确认！');
      Return;
    End If;
  
    Open Cur_ For
      Select t.*
        From Bl_Bill_Vary_Detail t
       Where t.Modify_Id = Mainrow_.Modify_Id
         And t.State <> '4';
    Fetch Cur_
      Into Irow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '明细行无提交状态数据');
      Return;
    End If;
    Close Cur_;
  
    Update Bl_Bill_Vary t --更新主档 状态
       Set State        = '2',
           Modi_Date    = Sysdate,
           Modi_User    = User_Id_,
           Date_Comform = Sysdate
     Where Modify_Id = Mainrow_.Modify_Id;
    Update Bl_Bill_Vary_Detail --更新明细行状态
       Set State = '2', Modi_Date = Sysdate, Modi_User = User_Id_
     Where Modify_Id = Mainrow_.Modify_Id;
  
  End;
  --否决
  Procedure Releaseclose__(Rowlist_  Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2,
                           Objid_    Out Varchar2,
                           Mainrow_  Out Bl_Bill_Vary%Rowtype) Is
    Cur_ t_Cursor;
    --Rowid_       VARCHAR2(1000);
    Irow_ Bl_Bill_Vary_Detail%Rowtype;
    --Table_       VARCHAR2(1000);
    Reject_Id_   Varchar2(1000);
    Reject_Name_ Varchar2(1000);
  Begin
    Objid_       := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Reject_Id_   := Pkg_a.Get_Item_Value('REJECT_ID', Rowlist_);
    Reject_Name_ := Pkg_a.Get_Item_Value('REJECT_NAME', Rowlist_);
    Open Cur_ For
      Select t.* From Bl_Bill_Vary t Where t.Rowid = Objid_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
  
    If Mainrow_.State <> '1' Then
      Raise_Application_Error(-20101, '只能提交状态才能否决！');
      Return;
    End If;
  
    Open Cur_ For
      Select t.*
        From Bl_Bill_Vary_Detail t
       Where t.Modify_Id = Mainrow_.Modify_Id
         And t.State <> '4';
    Fetch Cur_
      Into Irow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '明细行无提交状态数据');
      Return;
    End If;
    Close Cur_;
  
    Update Bl_Bill_Vary --更新主档 状态
       Set State       = '4',
           Modi_Date   = Sysdate,
           Modi_User   = User_Id_,
           Date_Closed = Sysdate,
           Reject_Id   = Reject_Id_,
           Reject_Name = Reject_Name_
     Where Modify_Id = Mainrow_.Modify_Id;
    Update Bl_Bill_Vary_Detail --更新明细行状态
       Set State = '4', Modi_Date = Sysdate, Modi_User = User_Id_
     Where Modify_Id = Mainrow_.Modify_Id;
  
  End;

  -- 订单变更提交 视图 BL_V_CUSTOMER_ORDER_CHG_APP
  Procedure Corelease__(Rowlist_ Varchar2,
                        --视图的objid
                        User_Id_ Varchar2,
                        --用户id
                        A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Release__(Rowlist_, User_Id_, A311_Key_, Row_);
    Coapprove__(Rowlist_, User_Id_, A311_Key_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '订单变更申请' || '[' || Row_.Modify_Id || ']' || '提交成功');
  End;

  -- 订单变更作废  视图 BL_V_CUSTOMER_ORDER_CHG_APP
  Procedure Cocancel__(Rowlist_ Varchar2,
                       --视图的objid
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Cancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '订单变更申请' || '[' || Row_.Modify_Id || ']' || '作废成功');
  End;

  --订单变更取消提交 Rowlist_ 为视图 BL_V_CUSTOMER_ORDER_CHG_APP 的objid
  Procedure Coreleasecancel__(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Releasecancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
  
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '订单变更申请' || '[' || Row_.Modify_Id || ']' || '取消提交成功');
    Return;
  End;
  --订单变更确认  Rowlist_为视图 BL_V_CUSTOMER_ORDER_CHG_APP 的objid
  Procedure Coapprove__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2) Is
    Row_       Bl_Bill_Vary%Rowtype;
    Detailrow_ Bl_v_Customer_Order_Chg_Det%Rowtype; --变更行
    --Table_Id_  Varchar2(100);
    Corowlist_ Varchar2(4000);
    --Icorowlist_  VARCHAR2(4000);
    --Mainrowlist_ VARCHAR2(4000);
    Cur_ t_Cursor;
    --Corow_ Bl_v_Customer_Order_Line%Rowtype;
    --A314_        A314%ROWTYPE;
    --Mainrow_     Bl_v_Customer_Order%ROWTYPE;
    If_New_ Varchar2(1);
    A311_   A311%Rowtype;
    Res_    Number;
  Begin
    --修改变更表的状态
    Approve__(Rowlist_, User_Id_, A311_Key_, Row_);
    --开始处理对应的变更
    --If_New_ := '0';
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order_Chg_Det t
       Where t.Modify_Id = Row_.Modify_Id
       Order By t.Modify_Type Desc;
    Fetch Cur_
      Into Detailrow_;
    Loop
      Exit When Cur_%Notfound;
      --修改数量
      If Detailrow_.Modify_Type = 'M' Then
        Corowlist_ := '';
        Pkg_a.Set_Item_Value('ORDER_NO', Detailrow_.Order_No, Corowlist_);
        Pkg_a.Set_Item_Value('LINE_NO', Detailrow_.Line_No, Corowlist_);
        Pkg_a.Set_Item_Value('REL_NO', Detailrow_.Rel_No, Corowlist_);
        Pkg_a.Set_Item_Value('LINE_ITEM_NO',
                             Detailrow_.Line_Item_No,
                             Corowlist_);
        Pkg_a.Set_Item_Value('BUY_QTY_DUE',
                             Detailrow_.Qty_Delivedf,
                             Corowlist_);
        Comodify__(Corowlist_, User_Id_, A311_Key_);
      End If;
      --取消客户订单行 
      If Detailrow_.Modify_Type = 'D' Then
        Corowlist_ := '';
        Pkg_a.Set_Item_Value('OBJID', Detailrow_.Coobjid, Corowlist_);
        Pkg_a.Set_Item_Value('ORDER_NO', Detailrow_.Order_No, Corowlist_);
        Pkg_a.Set_Item_Value('LINE_NO', Detailrow_.Line_No, Corowlist_);
        Pkg_a.Set_Item_Value('REL_NO', Detailrow_.Rel_No, Corowlist_);
        Pkg_a.Set_Item_Value('LINE_ITEM_NO',
                             Detailrow_.Line_Item_No,
                             Corowlist_);
        Pkg_a.Set_Item_Value('CANCEL_REASON',
                             Detailrow_.Reason,
                             Corowlist_);
        Bl_Customer_Order_Line_Api.Set_Cancel_Reason(Corowlist_,
                                                     User_Id_,
                                                     A311_Key_);
      End If;
      If Detailrow_.Modify_Type = 'I' Then
        Corowlist_ := '';
        Pkg_a.Set_Item_Value('ORDER_NO', Detailrow_.Order_No, Corowlist_);
        Pkg_a.Set_Item_Value('CATALOG_NO',
                             Detailrow_.Catalog_No,
                             Corowlist_);
        Pkg_a.Set_Item_Value('CATALOG_DESC',
                             Detailrow_.Catalog_Desc,
                             Corowlist_);
        Pkg_a.Set_Item_Value('BUY_QTY_DUE',
                             Detailrow_.Qty_Delivedf,
                             Corowlist_);
        Pkg_a.Set_Item_Value('SUPPLY_CODE',
                             Detailrow_.Supply_Code,
                             Corowlist_);
        Pkg_a.Set_Item_Value('VENDOR_NO', Detailrow_.Vendor_No, Corowlist_);
        If_New_ := '1';
        Conew__(Corowlist_, User_Id_, A311_Key_, Detailrow_.Objid);
      End If;
      Fetch Cur_
        Into Detailrow_;
    End Loop;
    Close Cur_;
    A311_.A311_Id     := 'Blbill_Vary_Api.Coapprove__';
    A311_.Enter_User  := User_Id_;
    A311_.A014_Id     := 'A014_ID=Coapprove__';
    A311_.Table_Id    := 'BL_BILL_VARY_V';
    A311_.Table_Objid := Rowlist_;
    Pkg_a.Beginlog(A311_);
    --后续的变更处理必须等待 有新增的处理完
    --判断明细有没有下级 如果没有下级 就直接下达
    --自动下达 存在内部采购目录 自动下达下域订单
    Open Cur_ For
      Select 1
        From Customer_Order_Line t
       Where t.Order_No = Row_.Source_No
         And t.Line_Item_No <= 0
         And t.Supply_Code In
             (Select Id From Bl_v_Co_Supply_Code T1 Where T1.Autoplan = '0');
  
    Fetch Cur_
      Into Res_;
    If Cur_%Found Then
      Pkg_a.Setnextdo(A311_Key_,
                      '变更引起订单下达-' || Row_.Source_No,
                      User_Id_,
                      'bl_customer_order_flow_api.release_nextorder(''' ||
                      Row_.Source_No || ''',''' || User_Id_ || ''',''' ||
                      To_Char(A311_Key_) || ''',''' || Rowlist_ || ''')',
                      0.5 / 60 / 24);
      --产生新的变更
      Pkg_a.Setnextdo(A311_.A311_Key,
                      '变更修改交货计划-' || Row_.Modify_Id,
                      User_Id_,
                      'Blbill_Vary_Api.CoSetNext(''' || Rowlist_ || ''',''' ||
                      User_Id_ || ''',''' || A311_.A311_Key || ''')',
                      (0.75 + Setnext_Time) / 60 / 24,
                      A311_Key_);
      Update Bl_Bill_Vary t --更新主档 状态
         Set t.Data_Lock = '1', t.Lock_User = User_Id_
       Where Modify_Id = Row_.Modify_Id;
    Else
      --如果没有下级 直接下达 
      Bl_Customer_Order_Flow_Api.Release_Nextorder(Row_.Source_No,
                                                   User_Id_,
                                                   A311_Key_,
                                                   Rowlist_);
      Blbill_Vary_Api.Cosetnext(Rowlist_, User_Id_, A311_.A311_Key);
    End If;
    Close Cur_;
  
    --产生新的变更
    /*    Pkg_a.Setnextdo(A311_Key_,
    '变更修改交货计划-' || Row_.Modify_Id,
    User_Id_,
    'Blbill_Vary_Api.CoSetNext(''' || Rowlist_ || ''',''' ||
    User_Id_ || ''',''' || A311_.A311_Key || ''')',
    6 / 60 / 24);*/
  
    /*    SELECT t.Table_Id
      INTO Table_Id_
      FROM Bl_Bill_Vary_Type_Id t
     WHERE t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '订单变更申请' || '[' || Row_.Modify_Id || ']' || '确认成功');*/
  End;
  --订单变更否决  Rowlist_为视图 BL_V_CUSTOMER_ORDER_CHG_APP 的objid,REJECT_ID,REJECT_NAME
  Procedure Coreleaseclose__(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
    Objid_    Varchar2(100);
  Begin
    Releaseclose__(Rowlist_, User_Id_, A311_Key_, Objid_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Objid_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '订单变更申请' || '[' || Row_.Modify_Id || ']' || '否决成功');
  
    Return;
  End;
  Procedure Dpnew__(Rowlist_  Varchar2,
                    User_Id_  Varchar2,
                    A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  Procedure Dpmodify__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  Procedure Dpremove__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  --备货单变更提交 Rowlist_为视图 BL_V_CUSTOMER_ORDER_CHGP_APP_3 的objid
  Procedure Pkrelease__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2) Is
    Row_  Bl_Bill_Vary%Rowtype;
    Irow_ Bl_Bill_Vary%Rowtype;
    --  detrow_    Bl_v_Customer_Order_Chgp_Det_3%ROWTYPE; --临时record    
    Table_Id_   Varchar2(100);
    Cur_        t_Cursor;
    Cur1_       t_Cursor;
    Source_No_  Varchar2(50);
    Detailrow_  Bl_v_Customer_Order_Chgp_Det_3%Rowtype;
    Objid_      Varchar2(100);
    Temp_Row_   Bl_Temp%Rowtype;
    Idetailrow_ Bl_Bill_Vary_Detail%Rowtype;
    --check_Temp_Row_ Bl_Temp%ROWTYPE;
    Rowobjid_ Varchar2(100);
    Temp_Key_ Number;
  Begin
    -- Release__(Rowlist_, User_Id_, A311_Key_, Row_);
    --把备货当变更转换新的工厂的订单变更
  
    Open Cur_ For
      Select t.* From Bl_Bill_Vary t Where t.Rowid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
  
    Update Bl_Bill_Vary t
       Set State        = '2',
           Date_Puted   = Sysdate,
           Date_Comform = Sysdate,
           Modi_Date    = Sysdate,
           Modi_User    = User_Id_
     Where Rowid = Rowlist_;
  
    --提交的时候 校验数量是否 能够 和订单的数量 一致 
    Select s_Bl_Temp.Nextval Into Temp_Key_ From Dual;
  
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order_Chgp_Det_3 t
       Where t.Modify_Id = Row_.Modify_Id
       Order By t.Order_No, t.Supplier;
    Fetch Cur_
      Into Detailrow_;
    Source_No_ := '-';
    Loop
      Exit When Cur_%Notfound;
      Temp_Row_.Tempkey := Temp_Key_;
      Temp_Row_.Rowkey  := Detailrow_.Order_No || '-' || Detailrow_.Line_No || '-' ||
                           Detailrow_.Rel_No || '-' ||
                           Detailrow_.Line_Item_No;
    
      Open Cur1_ For
        Select t.*
          From Bl_Temp t
         Where t.Tempkey = Temp_Row_.Tempkey
           And t.Rowkey = Temp_Row_.Rowkey;
      Fetch Cur1_
        Into Temp_Row_;
      If Cur1_%Notfound Then
        Temp_Row_.Tempkey      := Temp_Key_;
        Temp_Row_.Rowkey       := Detailrow_.Order_No || '-' ||
                                  Detailrow_.Line_No || '-' ||
                                  Detailrow_.Rel_No || '-' ||
                                  Detailrow_.Line_Item_No;
        Temp_Row_.Order_No     := Detailrow_.Order_No;
        Temp_Row_.Line_No      := Detailrow_.Line_No;
        Temp_Row_.Rel_No       := Detailrow_.Rel_No;
        Temp_Row_.Line_Item_No := Detailrow_.Line_Item_No;
        Pkg_a.Set_Item_Value('F_ORDER_NO',
                             Detailrow_.f_Order_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('CATALOG_NO',
                             Detailrow_.Catalog_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('F_LINE_NO',
                             Detailrow_.f_Line_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('F_REL_NO',
                             Detailrow_.f_Rel_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('F_LINE_ITEM_NO',
                             Detailrow_.f_Line_Item_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('BUY_QTY_DUE',
                             Detailrow_.Buy_Qty_Due,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('QTY_PLAN',
                             Bl_Customer_Order_Line_Api.Get_Plan_Qty__(Detailrow_.f_Order_No,
                                                                       Detailrow_.f_Line_No,
                                                                       Detailrow_.Rel_No,
                                                                       Detailrow_.Line_Item_No),
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('QTY_CHANGE', '0', Temp_Row_.Rowlist);
      
        Insert Into Bl_Temp_Tab
          (Tempkey,
           Rowkey,
           Order_No,
           Line_No,
           Rel_No,
           Line_Item_No,
           Rowlist)
        Values
          (Temp_Row_.Tempkey,
           Temp_Row_.Rowkey,
           Temp_Row_.Order_No,
           Temp_Row_.Line_No,
           Temp_Row_.Rel_No,
           Temp_Row_.Line_Item_No,
           Temp_Row_.Rowlist) Return Rowid Into Temp_Row_.Objid;
      End If;
      Close Cur1_;
    
      Pkg_a.Set_Item_Value('QTY_CHANGE',
                           Pkg_a.Get_Item_Value('QTY_CHANGE',
                                                Temp_Row_.Rowlist) +
                           Detailrow_.Qty_Change,
                           Temp_Row_.Rowlist);
    
      Update Bl_Temp_Tab
         Set Rowlist = Temp_Row_.Rowlist
       Where Rowid = Temp_Row_.Objid;
    
      If Source_No_ <> Detailrow_.Order_No || '-' || Detailrow_.Supplier Then
        --生成新单号
        Irow_ := Row_;
        Bl_Customer_Order_Api.Getseqno('2' || To_Char(Sysdate, 'YYMMDD'),
                                       User_Id_,
                                       3,
                                       Irow_.Modify_Id);
        Insert Into Bl_Bill_Vary
          (Modify_Id)
        Values
          (Irow_.Modify_Id)
        Returning Rowid Into Objid_;
        Irow_.Source_No      := Detailrow_.Order_No || '-' ||
                                Detailrow_.Supplier;
        Irow_.Date_Puted     := Row_.Date_Puted;
        Irow_.Smodify_Id     := Detailrow_.Modify_Id;
        Irow_.Enter_Date     := Sysdate;
        Irow_.Enter_User     := User_Id_;
        Irow_.Customer_Ref   := Row_.Customer_Ref;
        Irow_.State          := '0';
        Irow_.Type_Id        := '2';
        Irow_.Remark         := Detailrow_.Remark;
        Irow_.Base_Modify_Id := Detailrow_.Modify_Id;
        Update Bl_Bill_Vary Set Row = Irow_ Where Rowid = Objid_;
        Source_No_ := Detailrow_.Order_No || '-' || Detailrow_.Supplier;
      End If;
    
      Idetailrow_.Modify_Id          := Irow_.Modify_Id;
      Idetailrow_.Modify_Lineno      := Detailrow_.Modify_Lineno;
      Idetailrow_.Base_No            := Detailrow_.Modify_Id;
      Idetailrow_.Base_Line          := Detailrow_.Modify_Lineno;
      Idetailrow_.Order_No           := Detailrow_.Order_No;
      Idetailrow_.Line_No            := Detailrow_.Line_No;
      Idetailrow_.Rel_No             := Detailrow_.Rel_No;
      Idetailrow_.Line_Item_No       := Detailrow_.Line_Item_No;
      Idetailrow_.Column_No          := Detailrow_.Column_No;
      Idetailrow_.Picklistno         := Detailrow_.Picklistno;
      Idetailrow_.Qty_Delived        := Detailrow_.Qty_Delived;
      Idetailrow_.Qty_Delivedf       := Detailrow_.Qty_Delivedf;
      Idetailrow_.Delived_Date       := Detailrow_.Delived_Date;
      Idetailrow_.Delived_Datef      := Detailrow_.Delived_Datef;
      Idetailrow_.Version            := Detailrow_.Version;
      Idetailrow_.State              := Irow_.State;
      Idetailrow_.Reason             := Detailrow_.Reason;
      Idetailrow_.Reason_Description := Detailrow_.Reason_Description;
      Idetailrow_.Remark             := Detailrow_.Remark;
      Idetailrow_.Enter_User         := User_Id_;
      Idetailrow_.Enter_Date         := Sysdate;
    
      Idetailrow_.New_Data    := Detailrow_.New_Data;
      Idetailrow_.Line_Key    := Detailrow_.Plan_Line_Key;
      Idetailrow_.Modify_Type := 'DPM'; --备货单变更    
      Insert Into Bl_Bill_Vary_Detail
        (Modify_Id, Modify_Lineno)
      Values
        (Idetailrow_.Modify_Id, Idetailrow_.Modify_Lineno)
      Returning Rowid Into Rowobjid_;
    
      Update Bl_Bill_Vary_Detail
         Set Row = Idetailrow_
       Where Rowid = Rowobjid_;
    
      Update Bl_Bill_Vary_Detail t
         Set State = '2'
       Where Rowid = Detailrow_.Objid;
    
      Fetch Cur_
        Into Detailrow_;
    End Loop;
  
    Close Cur_;
    /*    --校验 
    OPEN cur1_ FOR
      SELECT t.* FROM Bl_Temp t WHERE t.Tempkey = Temp_Key_;
    FETCH cur1_
      INTO Temp_Row_;
    LOOP
      EXIT WHEN cur1_%NOTFOUND;
      detailrow_.BUY_QTY_DUE := pkg_a.Get_Item_Value('BUY_QTY_DUE',
                                                     Temp_Row_.ROWLIST);
    
      detailrow_.QTY_DELIVED := pkg_a.Get_Item_Value('QTY_PLAN',
                                                     Temp_Row_.ROWLIST);
      detailrow_.QTY_CHANGE  := pkg_a.Get_Item_Value('QTY_CHANGE',
                                                     Temp_Row_.ROWLIST);
      detailrow_.CATALOG_NO  := pkg_a.Get_Item_Value('CATALOG_NO',
                                                     Temp_Row_.ROWLIST);
    
      detailrow_.QTY_DELIVED := nvl(detailrow_.QTY_DELIVED, 0) +
                                nvl(detailrow_.QTY_CHANGE, 0);
    
      IF detailrow_.QTY_DELIVED <> detailrow_.BUY_QTY_DUE THEN
        Raise_Application_Error(pkg_a.raise_error,
                                '物料' || detailrow_.CATALOG_NO || '销售数量' ||
                                detailrow_.BUY_QTY_DUE || '和交货计划数量' ||
                                to_char(detailrow_.QTY_DELIVED) || '不一致!');
        RETURN;
      END IF;
    
      FETCH cur1_
        INTO Temp_Row_;
    END LOOP;
    CLOSE cur1_;*/
  
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '备货单变更申请' || '[' || Row_.Modify_Id || ']' || '提交成功');
  End;

  --检测变更的数量 和 订单的数量是否一致 
  Procedure Check_Order_Changeqty(Modify_Id_ In Varchar2) Is
    Cur_       t_Cursor;
    Cur1_      t_Cursor;
    Detailrow_ Bl_v_Customer_Order_Chgp_Det%Rowtype;
    --Objid_     Varchar2(100);
    Temp_Row_ Bl_Temp%Rowtype;
    Temp_Key_ Number;
  
  Begin
    --提交的时候 校验数量是否 能够 和订单的数量 一致 
    Select s_Bl_Temp.Nextval Into Temp_Key_ From Dual;
  
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order_Chgp_Det t
       Where t.Modify_Id = Modify_Id_;
    Fetch Cur_
      Into Detailrow_;
    Loop
      Exit When Cur_%Notfound;
      Temp_Row_.Tempkey := Temp_Key_;
      Temp_Row_.Rowkey  := Detailrow_.Order_No || '-' || Detailrow_.Line_No || '-' ||
                           Detailrow_.Rel_No || '-' ||
                           Detailrow_.Line_Item_No;
    
      Open Cur1_ For
        Select t.*
          From Bl_Temp t
         Where t.Tempkey = Temp_Row_.Tempkey
           And t.Rowkey = Temp_Row_.Rowkey;
      Fetch Cur1_
        Into Temp_Row_;
      If Cur1_%Notfound Then
        Temp_Row_.Tempkey      := Temp_Key_;
        Temp_Row_.Rowkey       := Detailrow_.Order_No || '-' ||
                                  Detailrow_.Line_No || '-' ||
                                  Detailrow_.Rel_No || '-' ||
                                  Detailrow_.Line_Item_No;
        Temp_Row_.Order_No     := Detailrow_.Order_No;
        Temp_Row_.Line_No      := Detailrow_.Line_No;
        Temp_Row_.Rel_No       := Detailrow_.Rel_No;
        Temp_Row_.Line_Item_No := Detailrow_.Line_Item_No;
        Pkg_a.Set_Item_Value('F_ORDER_NO',
                             Detailrow_.f_Order_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('CATALOG_NO',
                             Detailrow_.Catalog_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('F_LINE_NO',
                             Detailrow_.f_Line_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('F_REL_NO',
                             Detailrow_.f_Rel_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('F_LINE_ITEM_NO',
                             Detailrow_.f_Line_Item_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('BUY_QTY_DUE',
                             Detailrow_.Buy_Qty_Due,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('QTY_PLAN',
                             Bl_Customer_Order_Line_Api.Get_Plan_Qty__(Detailrow_.f_Order_No,
                                                                       Detailrow_.f_Line_No,
                                                                       Detailrow_.f_Rel_No,
                                                                       Detailrow_.f_Line_Item_No),
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('QTY_CHANGE', '0', Temp_Row_.Rowlist);
      
        Insert Into Bl_Temp_Tab
          (Tempkey,
           Rowkey,
           Order_No,
           Line_No,
           Rel_No,
           Line_Item_No,
           Rowlist)
        Values
          (Temp_Row_.Tempkey,
           Temp_Row_.Rowkey,
           Temp_Row_.Order_No,
           Temp_Row_.Line_No,
           Temp_Row_.Rel_No,
           Temp_Row_.Line_Item_No,
           Temp_Row_.Rowlist) Return Rowid Into Temp_Row_.Objid;
      End If;
      Close Cur1_;
    
      Pkg_a.Set_Item_Value('QTY_CHANGE',
                           Pkg_a.Get_Item_Value('QTY_CHANGE',
                                                Temp_Row_.Rowlist) +
                           Detailrow_.Qty_Change,
                           Temp_Row_.Rowlist);
    
      Update Bl_Temp_Tab
         Set Rowlist = Temp_Row_.Rowlist
       Where Rowid = Temp_Row_.Objid;
      Fetch Cur_
        Into Detailrow_;
    End Loop;
    Close Cur_;
  
    --校验 
    Open Cur1_ For
      Select t.* From Bl_Temp t Where t.Tempkey = Temp_Key_;
    Fetch Cur1_
      Into Temp_Row_;
    Loop
      Exit When Cur1_%Notfound;
      Detailrow_.Buy_Qty_Due := Pkg_a.Get_Item_Value('BUY_QTY_DUE',
                                                     Temp_Row_.Rowlist);
    
      Detailrow_.Qty_Delived := Pkg_a.Get_Item_Value('QTY_PLAN',
                                                     Temp_Row_.Rowlist);
      Detailrow_.Qty_Change  := Pkg_a.Get_Item_Value('QTY_CHANGE',
                                                     Temp_Row_.Rowlist);
      Detailrow_.Catalog_No  := Pkg_a.Get_Item_Value('CATALOG_NO',
                                                     Temp_Row_.Rowlist);
    
      Detailrow_.Qty_Delived := Nvl(Detailrow_.Qty_Delived, 0) +
                                Nvl(Detailrow_.Qty_Change, 0);
    
      If Detailrow_.Qty_Delived <> Detailrow_.Buy_Qty_Due Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '物料' || Detailrow_.Catalog_No || '销售数量' ||
                                Detailrow_.Buy_Qty_Due || '和交货计划数量' ||
                                To_Char(Detailrow_.Qty_Delived) || '不一致!');
        Return;
      End If;
    
      Fetch Cur1_
        Into Temp_Row_;
    End Loop;
    Close Cur1_;
  End;

  --备货单变更  取消提交   Rowlist_为视图 BL_V_CUSTOMER_ORDER_CHGP_APP_3 的objid
  Procedure Pkreleasecancel__(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Crow_     Bl_Bill_Vary_v%Rowtype;
    Ccrow_    Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
    Cur_      t_Cursor;
  Begin
    Raise_Application_Error(Pkg_a.Raise_Error, '不能取消');
    Releasecancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    --判断所有的明细状态都是 提交状态才能取消 
    Open Cur_ For
      Select t.* From Bl_Bill_Vary_v t Where t.Smodify_Id = Row_.Modify_Id;
    Fetch Cur_
      Into Crow_;
    Loop
      Exit When Cur_%Notfound;
      Cancel__(Crow_.Objid, User_Id_, A311_Key_, Ccrow_);
    
      Fetch Cur_
        Into Crow_;
    End Loop;
    Close Cur_;
  
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
  
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '备货单变更申请' || '[' || Row_.Modify_Id || ']' || '取消提交成功');
    Return;
  End;
  --备货单变更否决  Rowlist_为视图 BL_V_CUSTOMER_ORDER_CHGP_APP_3 的objid,REJECT_ID,REJECT_NAME
  Procedure Pkreleaseclose__(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
    Objid_    Varchar2(100);
  Begin
    Releaseclose__(Rowlist_, User_Id_, A311_Key_, Objid_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Objid_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '备货单变更申请' || '[' || Row_.Modify_Id || ']' || '否决成功');
  
    Return;
  End;

  --备货单变更确认  Rowlist_为视图 BL_V_CUSTOMER_ORDER_CHGP_APP_3 的objid
  Procedure Pkapprove__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
    Objid_    Varchar2(100);
  Begin
    Raise_Application_Error(Pkg_a.Raise_Error, '不能确认');
    Approve__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Objid_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '备货单变更申请' || '[' || Row_.Modify_Id || ']' || '确认成功');
  
    Return;
  End;

  -- 备货单变更 作废  Rowlist_为视图 BL_V_CUSTOMER_ORDER_CHGP_APP_3 的objid
  Procedure Pkcancel__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Cancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '备货单变更申请' || '[' || Row_.Modify_Id || ']' || '作废成功');
  End;

  --交货计划变更提交  
  --当  Row_.Type_Id = '2' Rowlist_为视图（交货计划工厂域） BL_V_CUSTOMER_ORDER_CHGP_APP 的 objid  
  --当  Row_.Type_Id = '21' Rowlist_为 视图 (交货计划业务)   BL_V_CUSTOMER_ORDER_CHGP_APP_1  的 objid
  --当  Row_.Type_Id = '22' Rowlist_为  视图 (交货计划交期)   BL_V_CUSTOMER_ORDER_CHGP_APP_2  的 objid
  Procedure Dprelease__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2) Is
    Row_        Bl_Bill_Vary%Rowtype;
    Table_Id_   Varchar2(100);
    Cur_        t_Cursor;
    Res_        Number;
    Picklistno_ Varchar2(100);
  Begin
    Release__(Rowlist_, User_Id_, A311_Key_, Row_);
    --检测 新增的行是否和表头的备货单一致
    If Substr(Row_.Smodify_Id, 1, 1) = '6' Then
      Select t.Source_No
        Into Picklistno_
        From Bl_Bill_Vary t
       Where t.Modify_Id = Row_.Smodify_Id;
    
      Open Cur_ For
        Select 1
          From Bl_Bill_Vary_Detail t
         Where t.Modify_Type = 'DPI'
           And t.Modify_Id = Row_.Modify_Id
           And t.Picklistno = Picklistno_;
      Fetch Cur_
        Into Res_;
      If Cur_%Found Then
        Close Cur_;
        Raise_Application_Error(Pkg_a.Raise_Error, '无效的备货单数量调整!');
      End If;
      Close Cur_;
    End If;
  
    Check_Order_Changeqty(Row_.Modify_Id);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '交货计划变更申请' || '[' || Row_.Modify_Id || ']' || '提交成功');
  End;
  --交货计划变更取消提交
  Procedure Dpreleasecancel__(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Releasecancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
  
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '交货计划变更申请' || '[' || Row_.Modify_Id || ']' || '取消提交成功');
    Return;
  End;
  --交货计划变更(工厂交期)取消提交
  Procedure Dpreleasecancel_f(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Releasecancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
  
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '交货计划变更(工厂交期)' || '[' || Row_.Modify_Id || ']' || '取消提交成功');
    Return;
  End;

  --交货计划变更确认
  -- Rowlist_   BL_BILL_VARY 表的ROWID 
  Procedure Dpapprove__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2) Is
    Row_  Bl_Bill_Vary%Rowtype;
    Crow_ Bl_Bill_Vary%Rowtype;
    --Detailrow_   Bl_v_Customer_Order_Chgp_Det%ROWTYPE; --变更行
    Table_Id_ Varchar2(100);
    --Porowlist_   VARCHAR2(4000);
    --Iporowlist_  VARCHAR2(4000);
    --Mainrowlist_ VARCHAR2(4000);
    Cur_ t_Cursor;
    --Cur1_        t_Cursor;
    Cur2_ t_Cursor;
    --Porow_       Bl_v_Purchase_Order_Line_Part%ROWTYPE;
    --A314_        A314%ROWTYPE;
    --Mainrow_     Bl_v_Customer_Order%ROWTYPE;
    Dpmainrow_  Bl_Delivery_Plan_v%Rowtype; --交货计划头
    Idpmainrow_ Bl_Delivery_Plan%Rowtype; --交货计划头
  
    Dp_Chg_Row_ Bl_v_Customer_Order_Chgp_App%Rowtype; --交货计划变更
  
    --Corow_        Customer_Order_Line%Rowtype;
    Dpdetailrow_  Bl_Delivery_Plan_Detial_v%Rowtype; --交货计划行
    Idpdetailrow_ Bl_Delivery_Plan_Detial%Rowtype; --交货计划 插入 行
    --S_BL_TEMP
    Temp_Row_ Bl_Temp%Rowtype;
    Planrow_  Bl_v_Customer_Order_Chgp_Det_6%Rowtype; --交货计划变更
    --Corow_        Bl_Customer_Order%ROWTYPE; --变更的订单行
    Colinerow_    Bl_v_Cust_Ord_Line_V01%Rowtype;
    Chgrow_       Bl_Bill_Vary_Detail%Rowtype; --变更记录行
    Temp_Key_     Number;
    Rowobjid_     Varchar2(100);
    Blrowv02      Bl_v_Customer_Order_V02%Rowtype;
    Date_Deliver_ Date;
    Bl_Pldtl_     Bl_Pldtl%Rowtype;
    Bl_Picklist_  Bl_Picklist%Rowtype;
  Begin
  
    Approve__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select s_Bl_Temp.Nextval Into Temp_Key_ From Dual;
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order_Chgp_App t
       Where t.Modify_Id = Row_.Modify_Id;
    Fetch Cur_
      Into Dp_Chg_Row_;
    Close Cur_;
    Open Cur_ For
      Select Max(Column_No) As Column_No
        From Bl_Delivery_Plan t
       Where t.Order_No = Dp_Chg_Row_.Order_No
         And t.Supplier = Dp_Chg_Row_.Supplier;
    Fetch Cur_
      Into Idpmainrow_.Column_No;
    Close Cur_;
  
    Idpmainrow_.Column_No := Nvl(Idpmainrow_.Column_No, 0);
    --处理交货计划 
    Open Cur_ For
      Select t.*
        From Bl_Bill_Vary_Detail t
       Where t.Modify_Id = Row_.Modify_Id
      -- and    t.modify_type <> 'FM' --差异发货的数据不处理
       Order By t.Delived_Datef;
    Fetch Cur_
      Into Chgrow_;
    Date_Deliver_ := Nvl(Date_Deliver_, To_Date('20000101', 'YYYYMMDD'));
    Loop
      Exit When Cur_%Notfound;
    
      If Chgrow_.Qty_Delived <> Chgrow_.Qty_Delivedf Then
        --获取交货计划头
        If Date_Deliver_ != Chgrow_.Delived_Datef Then
          If Date_Deliver_ != To_Date('20000101', 'YYYYMMDD') Then
            Update Bl_Delivery_Plan
               Set Delplan_Line = Dpmainrow_.Delplan_Line
             Where Rowid = Dpmainrow_.Objid;
          End If;
          --如果是备货单变更引起的交货计划变更
          If Chgrow_.Modify_Type = 'PK' Then
            --获取交货计划行在  备货单中是否存在
            Open Cur2_ For
              Select t.*
                From Bl_Delivery_Plan_Detial_v t
               Where t.Order_No = Chgrow_.Order_No
                 And t.Line_No = Chgrow_.Line_No
                 And t.Rel_No = Chgrow_.Rel_No
                 And t.Line_Item_No = Chgrow_.Line_Item_No
                 And t.Picklistno = Chgrow_.Picklistno
                 And t.State = '2'
                 And t.Delived_Date = Chgrow_.Delived_Datef;
            Fetch Cur2_
              Into Dpdetailrow_;
            If Cur2_%Notfound Then
              Close Cur2_;
              Open Cur2_ For
                Select t.*
                  From Bl_Delivery_Plan_Detial_v t
                 Where t.Order_No = Chgrow_.Order_No
                   And t.Line_No = Chgrow_.Line_No
                   And t.Rel_No = Chgrow_.Rel_No
                   And t.Line_Item_No = Chgrow_.Line_Item_No
                   And t.State = '2'
                   And t.Picklistno = Chgrow_.Picklistno;
              Fetch Cur2_
                Into Dpdetailrow_;
            
            End If;
            If Cur2_%Found Then
              Close Cur2_;
              Open Cur2_ For
                Select t.*
                  From Bl_Delivery_Plan_v t
                 Where t.Delplan_No = Dpdetailrow_.Delplan_No;
              Fetch Cur2_
                Into Dpmainrow_;
              Close Cur2_;
              If Dpmainrow_.Picklistno != Chgrow_.Picklistno Then
                Raise_Application_Error(Pkg_a.Raise_Error,
                                        '交货计划' || Dpdetailrow_.Delplan_No ||
                                        '明细和主档备货单号不一致!');
              
              End If;
              Chgrow_.Delived_Datef := Dpmainrow_.Delived_Date;
            Else
              Close Cur2_;
              --找备货单行
              Open Cur2_ For
                Select t.*
                  From Bl_Delivery_Plan_v t
                 Where t.Order_No = Dp_Chg_Row_.Order_No
                   And t.Supplier = Dp_Chg_Row_.Supplier
                   And t.Picklistno = Chgrow_.Picklistno;
              Fetch Cur2_
                Into Dpmainrow_;
              -- 没有备货单的数据
              If Cur2_%Notfound Then
                Close Cur2_;
                --获取新交货计划的交期处理
                Loop
                  Open Cur2_ For
                    Select t.Delplan_No
                      From Bl_Delivery_Plan t
                     Where t.Order_No = Dp_Chg_Row_.Order_No
                       And t.Supplier = Dp_Chg_Row_.Supplier
                       And t.Delived_Date = Chgrow_.Delived_Datef;
                  Fetch Cur2_
                    Into Planrow_.Delplan_No;
                  If Cur2_%Notfound Then
                    Close Cur2_;
                    Exit;
                  Else
                    Close Cur2_;
                  End If;
                  Chgrow_.Delived_Datef := Chgrow_.Delived_Datef + 1;
                End Loop;
              Else
                Close Cur2_;
                Chgrow_.Delived_Datef := Dpmainrow_.Delived_Date;
              End If;
            End If;
            Chgrow_.Delived_Date := Chgrow_.Delived_Datef;
          End If;
          Bldelivery_Plan_Api.Get_Record_By_Order_Date(Dp_Chg_Row_.Order_No,
                                                       Dp_Chg_Row_.Supplier,
                                                       Chgrow_.Delived_Datef,
                                                       Dpmainrow_);
        
          If Nvl(Dpmainrow_.Delplan_No, '-') = '-' Then
            --当前日期没有交货计划
            --创建版本为1的交货计划 
          
            Idpmainrow_.Order_No     := Dp_Chg_Row_.Order_No;
            Idpmainrow_.Supplier     := Dp_Chg_Row_.Supplier;
            Idpmainrow_.Customer_No  := Dp_Chg_Row_.Customer_No;
            Idpmainrow_.Customer_Ref := Dp_Chg_Row_.Customer_Ref;
            Idpmainrow_.Contract     := Dp_Chg_Row_.Contract;
            Idpmainrow_.Delived_Date := Chgrow_.Delived_Datef;
            Idpmainrow_.Type_Id      := 'CUSTOMER';
            Idpmainrow_.Delplan_Line := 0;
            Bl_Customer_Order_Api.Getseqno(To_Char(Sysdate, 'YY') ||
                                           Idpmainrow_.Supplier,
                                           User_Id_,
                                           8,
                                           Idpmainrow_.Delplan_No);
          
            Idpmainrow_.Column_No       := Idpmainrow_.Column_No + 1;
            Idpmainrow_.Enter_User      := User_Id_;
            Idpmainrow_.Enter_Date      := Sysdate;
            Idpmainrow_.State           := '2'; --确认
            Idpmainrow_.Modi_User       := Null;
            Idpmainrow_.Modi_Date       := Null;
            Idpmainrow_.Version         := '1';
            Idpmainrow_.Base_Delplan_No := Idpmainrow_.Delplan_No;
            Idpmainrow_.Picklistno      := Null;
            If Chgrow_.Modify_Type = 'PK' Then
              --赋值备货单号
              Idpmainrow_.Picklistno := Chgrow_.Picklistno;
            End If;
            Insert Into Bl_Delivery_Plan
              (Delplan_No)
            Values
              (Idpmainrow_.Delplan_No) Return Rowid Into Dpmainrow_.Objid;
            Update Bl_Delivery_Plan
               Set Row = Idpmainrow_
             Where Rowid = Dpmainrow_.Objid;
          
            Select t.*
              Into Dpmainrow_
              From Bl_Delivery_Plan_v t
             Where t.Objid = Dpmainrow_.Objid;
          
          Else
            --版本 + 1
            Idpmainrow_.Base_Delplan_No := Dpmainrow_.Base_Delplan_No;
            Bldelivery_Plan_Api.Update_Version(Idpmainrow_.Base_Delplan_No,
                                               User_Id_,
                                               Dpmainrow_);
          
          End If;
          Date_Deliver_ := Chgrow_.Delived_Datef;
        
        End If;
        --处理变更  --
        -- 检测当前订单行的 --    
      
        Bldelivery_Plan_Line_Api.Get_Record_d_o_(Dpmainrow_.Delplan_No,
                                                 Chgrow_.Order_No,
                                                 Chgrow_.Line_No,
                                                 Chgrow_.Rel_No,
                                                 Chgrow_.Line_Item_No,
                                                 Dpdetailrow_);
        --判断以前 当前日期下 有没有数据
        If Nvl(Dpdetailrow_.Delplan_No, '-') = '-' Then
          Idpdetailrow_.Delplan_No    := Dpmainrow_.Delplan_No;
          Dpmainrow_.Delplan_Line     := Dpmainrow_.Delplan_Line + 1;
          Idpdetailrow_.Delplan_Line  := Dpmainrow_.Delplan_Line;
          Idpdetailrow_.Modify_Id     := Chgrow_.Modify_Id;
          Idpdetailrow_.Modify_Lineno := Chgrow_.Modify_Lineno;
          Idpdetailrow_.Order_No      := Chgrow_.Order_No;
          Idpdetailrow_.Line_No       := Chgrow_.Line_No;
          Idpdetailrow_.Rel_No        := Chgrow_.Rel_No;
          Idpdetailrow_.Line_Item_No  := Chgrow_.Line_Item_No;
        
          Idpdetailrow_.f_Order_No     := Pkg_a.Get_Item_Value('F_ORDER_NO',
                                                               Chgrow_.New_Data);
          Idpdetailrow_.f_Line_No      := Pkg_a.Get_Item_Value('F_LINE_NO',
                                                               Chgrow_.New_Data);
          Idpdetailrow_.f_Rel_No       := Pkg_a.Get_Item_Value('F_REL_NO',
                                                               Chgrow_.New_Data);
          Idpdetailrow_.f_Line_Item_No := Pkg_a.Get_Item_Value('F_LINE_ITEM_NO',
                                                               Chgrow_.New_Data);
        
          Idpdetailrow_.Column_No    := Dpmainrow_.Column_No;
          Idpdetailrow_.Version      := Dpmainrow_.Version;
          Idpdetailrow_.Picklistno   := Dpmainrow_.Picklistno;
          Idpdetailrow_.Qty_Delived  := Chgrow_.Qty_Delivedf;
          Idpdetailrow_.Delived_Date := Chgrow_.Delived_Datef;
          Idpdetailrow_.State        := Dpmainrow_.State;
          Idpdetailrow_.Enter_User   := Chgrow_.Enter_User;
        
          Idpdetailrow_.Enter_Date := Sysdate;
          Idpdetailrow_.Modi_User  := Null;
          Idpdetailrow_.Modi_Date  := Null;
        
          Idpdetailrow_.Order_Line_No     := Idpdetailrow_.f_Order_No || '-' ||
                                             Idpdetailrow_.f_Line_No || '-' ||
                                             Idpdetailrow_.f_Rel_No || '-' ||
                                             To_Char(Idpdetailrow_.f_Line_Item_No);
          Idpdetailrow_.Base_Delplan_No   := Idpdetailrow_.Delplan_No;
          Idpdetailrow_.Base_Delplan_Line := Idpdetailrow_.Delplan_Line;
        
          Open Cur2_ For
            Select t.*
              From Bl_v_Customer_Order_V02 t
             Where t.Order_No = Idpdetailrow_.f_Order_No
               And t.Line_No = Idpdetailrow_.f_Line_No
               And t.Rel_No = Idpdetailrow_.f_Rel_No
               And t.Line_Item_No = Idpdetailrow_.f_Line_Item_No;
          Fetch Cur2_
            Into Blrowv02;
          If Cur2_%Notfound Then
            Close Cur2_;
            Raise_Application_Error(-20101,
                                    '关键字' || Idpdetailrow_.f_Order_No ||
                                    '找对应关系错误!');
          End If;
          Close Cur2_;
          Idpdetailrow_.Po_Order_No             := Blrowv02.Po_Order_No;
          Idpdetailrow_.Po_Line_No              := Blrowv02.Po_Line_No;
          Idpdetailrow_.Po_Release_No           := Blrowv02.Po_Release_No;
          Idpdetailrow_.Demand_Order_No         := Blrowv02.Demand_Order_No;
          Idpdetailrow_.Demand_Rel_No           := Blrowv02.Demand_Rel_No;
          Idpdetailrow_.Demand_Line_No          := Blrowv02.Demand_Line_No;
          Idpdetailrow_.Demand_Line_Item_No     := Blrowv02.Demand_Line_Item_No;
          Idpdetailrow_.Par_Po_Order_No         := Blrowv02.Par_Po_Order_No;
          Idpdetailrow_.Par_Po_Line_No          := Blrowv02.Par_Po_Line_No;
          Idpdetailrow_.Par_Po_Release_No       := Blrowv02.Par_Po_Release_No;
          Idpdetailrow_.Par_Demand_Order_No     := Blrowv02.Par_Demand_Order_No;
          Idpdetailrow_.Par_Demand_Rel_No       := Blrowv02.Par_Demand_Rel_No;
          Idpdetailrow_.Par_Demand_Line_No      := Blrowv02.Par_Demand_Line_No;
          Idpdetailrow_.Par_Demand_Line_Item_No := Blrowv02.Par_Demand_Line_Item_No;
        
          --插入交货计划数据
          --bldelivery_plan_line_api
          Insert Into Bl_Delivery_Plan_Detial
            (Delplan_No, Delplan_Line)
          Values
            (Idpdetailrow_.Delplan_No, Idpdetailrow_.Delplan_Line)
          Returning Rowid Into Rowobjid_;
        
          Update Bl_Delivery_Plan_Detial
             Set Row = Idpdetailrow_
           Where Rowid = Rowobjid_;
        
          Bldelivery_Plan_Line_Api.Savehist__(Rowobjid_,
                                              User_Id_,
                                              A311_Key_,
                                              '变更录入数据，数量:' ||
                                              To_Char(Idpdetailrow_.Qty_Delived));
        
          Update Bl_Bill_Vary_Detail t
             Set New_Line_Key = Idpdetailrow_.Delplan_No || '-' ||
                                Idpdetailrow_.Delplan_Line
           Where t.Modify_Id = Chgrow_.Modify_Id
             And t.Modify_Lineno = Chgrow_.Modify_Lineno;
        
          --修改备货单
          If Nvl(Idpdetailrow_.Picklistno, '-') <> '-' Then
            --自动加入备货单数据--
            --      Raise_Application_Error(pkg_a.raise_error,
            --                          nvl(Idpdetailrow_.PICKLISTNO, '-'));
            Check_Bl_Picklist(Idpdetailrow_.Picklistno, Bl_Picklist_);
          
            Delete From Bl_Pldtl
             Where Picklistno = Idpdetailrow_.Picklistno
               And Order_No = Idpdetailrow_.Order_No
               And Line_No = Idpdetailrow_.Line_No
               And Rel_No = Idpdetailrow_.Rel_No
               And Line_Item_No = Idpdetailrow_.Line_Item_No
               And Flag = '3';
            Insert Into Bl_Pldtl
              (Contract,
               Customerno,
               Picklistno,
               Supplier,
               Order_No,
               Line_No,
               Rel_No,
               Line_Item_No,
               Pickqty,
               Wanted_Delivery_Date,
               Finishdate,
               Remark,
               Flag,
               Userid,
               Finishqty,
               Relqty,
               Reason,
               Drdate,
               Notetext,
               Deremark,
               Rel_Deliver_Date)
            Values
              (Dpmainrow_.Contract,
               Dpmainrow_.Customer_No,
               Dpmainrow_.Picklistno,
               Dpmainrow_.Supplier,
               Idpdetailrow_.Order_No,
               Idpdetailrow_.Line_No,
               Idpdetailrow_.Rel_No,
               Idpdetailrow_.Line_Item_No,
               Idpdetailrow_.Qty_Delived,
               To_Char(Dpmainrow_.Delived_Date, 'YYYY-MM-DD'),
               Null,
               '',
               Bl_Picklist_.Flag,
               User_Id_,
               Null,
               Null,
               Null,
               Null,
               Null,
               Null,
               Null);
            --清空日期
            Update Bl_Pldtl t
               Set t.Rel_Deliver_Date = Null
             Where Picklistno = Dpmainrow_.Picklistno
               And Supplier = Dpmainrow_.Supplier;
          
          End If;
        
        Else
          Update Bl_Delivery_Plan_Detial t
             Set t.Qty_Delived   = Chgrow_.Qty_Delivedf,
                 t.Modify_Id     = Chgrow_.Modify_Id,
                 t.Modify_Lineno = Chgrow_.Modify_Lineno,
                 t.Modi_User     = Chgrow_.Enter_User,
                 t.Modi_Date     = Sysdate
           Where t.Delplan_No = Dpdetailrow_.Delplan_No
             And t.Delplan_Line = Dpdetailrow_.Delplan_Line;
        
          Update Bl_Bill_Vary_Detail t
             Set New_Line_Key = Dpdetailrow_.Delplan_No || '-' ||
                                Dpdetailrow_.Delplan_Line
           Where t.Modify_Id = Chgrow_.Modify_Id
             And t.Modify_Lineno = Chgrow_.Modify_Lineno;
          --修改备货单  
          If Nvl(Dpdetailrow_.Picklistno, '-') <> '-' Then
            Check_Bl_Picklist(Dpdetailrow_.Picklistno, Bl_Picklist_);
            If Nvl(Chgrow_.Qty_Delivedf, 0) = 0 Then
              Update Bl_Pldtl t
                 Set Flag = '3'
               Where Picklistno = Dpdetailrow_.Picklistno
                 And Order_No = Dpdetailrow_.Order_No
                 And Line_No = Dpdetailrow_.Line_No
                 And Rel_No = Dpdetailrow_.Rel_No
                 And Line_Item_No = Dpdetailrow_.Line_Item_No;
            Else
              --判断备货单 有没有行   
              Open Cur2_ For
                Select t.*
                  From Bl_Pldtl t
                 Where Picklistno = Dpdetailrow_.Picklistno
                   And Order_No = Dpdetailrow_.Order_No
                   And Line_No = Dpdetailrow_.Line_No
                   And Rel_No = Dpdetailrow_.Rel_No
                   And Line_Item_No = Dpdetailrow_.Line_Item_No;
              Fetch Cur2_
                Into Bl_Pldtl_;
              --插入备货单行
              If Cur2_%Notfound Then
                Insert Into Bl_Pldtl
                  (Contract,
                   Customerno,
                   Picklistno,
                   Supplier,
                   Order_No,
                   Line_No,
                   Rel_No,
                   Line_Item_No,
                   Pickqty,
                   Wanted_Delivery_Date,
                   Finishdate,
                   Remark,
                   Flag,
                   Userid,
                   Finishqty,
                   Relqty,
                   Reason,
                   Drdate,
                   Notetext,
                   Deremark,
                   Rel_Deliver_Date)
                Values
                  (Dpmainrow_.Contract,
                   Dpmainrow_.Customer_No,
                   Dpmainrow_.Picklistno,
                   Dpmainrow_.Supplier,
                   Dpdetailrow_.Order_No,
                   Dpdetailrow_.Line_No,
                   Dpdetailrow_.Rel_No,
                   Dpdetailrow_.Line_Item_No,
                   Chgrow_.Qty_Delivedf,
                   To_Char(Dpmainrow_.Delived_Date, 'YYYY-MM-DD'),
                   Null,
                   '',
                   Bl_Picklist_.Flag,
                   User_Id_,
                   Null,
                   Null,
                   Null,
                   Null,
                   Null,
                   Null,
                   Null);
                --清空日期
                Update Bl_Pldtl t
                   Set t.Rel_Deliver_Date = Null
                 Where Picklistno = Dpmainrow_.Picklistno
                   And Supplier = Dpmainrow_.Supplier;
              Else
              
                Update Bl_Pldtl t
                   Set t.Pickqty   = Chgrow_.Qty_Delivedf,
                       t.Relqty    = Case Nvl(Relqty, 0)
                                       When 0 Then
                                        0
                                       Else
                                        Chgrow_.Qty_Delivedf
                                     End,
                       t.Finishqty = Case Nvl(Finishqty, 0)
                                       When 0 Then
                                        0
                                       Else
                                        Chgrow_.Qty_Delivedf
                                     End
                 Where Picklistno = Dpdetailrow_.Picklistno
                   And Order_No = Dpdetailrow_.Order_No
                   And Line_No = Dpdetailrow_.Line_No
                   And Rel_No = Dpdetailrow_.Rel_No
                   And Line_Item_No = Dpdetailrow_.Line_Item_No;
              End If;
              Close Cur2_;
            End If;
            --如果数量减少  预留减少
            If Nvl(Chgrow_.Qty_Delivedf, 0) < Nvl(Chgrow_.Qty_Delived, 0) Then
              Remove_Qty_(Dpdetailrow_.f_Order_No,
                          Dpdetailrow_.f_Line_No,
                          Dpdetailrow_.f_Rel_No,
                          Dpdetailrow_.f_Line_Item_No,
                          Dpdetailrow_.Picklistno,
                          Nvl(Chgrow_.Qty_Delivedf, 0),
                          User_Id_);
            
            End If;
          
            Bldelivery_Plan_Line_Api.Savehist__(Dpdetailrow_.Objid,
                                                User_Id_,
                                                A311_Key_,
                                                '变更数量' ||
                                                To_Char(Dpdetailrow_.Qty_Delived) ||
                                                '-->' ||
                                                To_Char(Chgrow_.Qty_Delivedf) ||
                                                ';备货单' ||
                                                Dpdetailrow_.Picklistno);
          Else
            Bldelivery_Plan_Line_Api.Savehist__(Dpdetailrow_.Objid,
                                                User_Id_,
                                                A311_Key_,
                                                '变更数量' ||
                                                To_Char(Dpdetailrow_.Qty_Delived) ||
                                                '-->' ||
                                                To_Char(Chgrow_.Qty_Delivedf));
          
          End If;
        
        End If;
      End If;
      Temp_Row_.Tempkey  := Temp_Key_;
      Temp_Row_.Rowkey   := Chgrow_.Modify_Id || '-' ||
                            Chgrow_.Modify_Lineno;
      Temp_Row_.Order_No := Pkg_a.Get_Item_Value('F_ORDER_NO',
                                                 Chgrow_.New_Data);
      Temp_Row_.Line_No  := Pkg_a.Get_Item_Value('F_LINE_NO',
                                                 Chgrow_.New_Data);
      Temp_Row_.Rel_No   := Pkg_a.Get_Item_Value('F_REL_NO',
                                                 Chgrow_.New_Data);
    
      Temp_Row_.Line_Item_No := Pkg_a.Get_Item_Value('F_LINE_ITEM_NO',
                                                     Chgrow_.New_Data);
      Insert Into Bl_Temp_Tab
        (Tempkey, Rowkey, Order_No, Line_No, Rel_No, Line_Item_No)
      Values
        (Temp_Row_.Tempkey,
         Temp_Row_.Rowkey,
         Temp_Row_.Order_No,
         Temp_Row_.Line_No,
         Temp_Row_.Rel_No,
         Temp_Row_.Line_Item_No);
    
      Fetch Cur_
        Into Chgrow_;
    End Loop;
    Update Bl_Delivery_Plan
       Set Delplan_Line = Dpmainrow_.Delplan_Line
     Where Rowid = Dpmainrow_.Objid;
  
    Open Cur_ For
      Select t.*
        From Bl_v_Cust_Ord_Line_V01 t
       Where (Order_No, Line_No, Rel_No, Line_Item_No) In
             (Select Order_No, Line_No, Rel_No, Line_Item_No
                From Bl_Temp_Tab
               Where Tempkey = Temp_Key_)
         And t.Buy_Qty_Due <> t.Qty_Planned;
    Fetch Cur_
      Into Colinerow_;
    /* Loop
      Exit When Cur_%Notfound;
      Dbms_Output.Put_Line('物料' || Colinerow_.Catalog_No || '销售数量' ||
                           Colinerow_.Buy_Qty_Due || '和交货计划数量' ||
                           Colinerow_.Qty_Planned || '不一致!');
      Fetch Cur_
        Into Colinerow_;
    End Loop;
    Close Cur_;*/
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(-20101,
                              '物料' || Colinerow_.Catalog_No || '销售数量' ||
                              Colinerow_.Buy_Qty_Due || '和交货计划数量' ||
                              Colinerow_.Qty_Planned || '不一致!');
    End If;
    Close Cur_;
    --判断 上级的交货计划 是否全完成
    If Row_.Type_Id = '3' Then
      Open Cur_ For
        Select t.*
          From Bl_Bill_Vary t
         Where t.Smodify_Id = Row_.Smodify_Id
           And t.State = '1'; --不是提交状态 表示 全处理过了
      Fetch Cur_
        Into Crow_;
      If Cur_%Notfound Then
        Update Bl_Bill_Vary t
           Set t.State = '2'
         Where t.Modify_Id = Row_.Smodify_Id;
      
      End If;
      Close Cur_;
    
    End If;
  
    --检测累计的交货数量
  
    /*    ---处理临时表
    --0,1,2,3,4,5,6 计划,下达,确认,失效,差异发货,关闭,取消
    --把原交货计划置为 无效 
    --当前版本 + 1 
    Dpmainrow_.Version   := Dpmainrow_.Version + 1;
    Dpmainrow_.Column_No := 0;
    OPEN Cur_ FOR
      SELECT DISTINCT t.Rowdate, t.Picklistno
        FROM Bl_Temp_Tab t
       WHERE t.Tempkey = Temp_Key_
       ORDER BY t.Rowdate;
    FETCH Cur_
      INTO Dpmainrow_.Delived_Date, Dpmainrow_.Picklistno;
    LOOP
      EXIT WHEN Cur_%NOTFOUND;
      Dpmainrow_.Delplan_Line := 0;
    
      Bl_Customer_Order_Api.Getseqno(To_Char(SYSDATE, 'YY') ||
                                     Dpmainrow_.Supplier,
                                     User_Id_,
                                     8,
                                     Dpmainrow_.Delplan_No);
      Dpmainrow_.Column_No := Dpmainrow_.Column_No + 1;
    
    
      Dpmainrow_.Enter_User      := User_Id_;
      Dpmainrow_.Enter_Date      := SYSDATE;
      Dpmainrow_.State           := '2'; --确认
      Dpmainrow_.Modi_User       := NULL;
      Dpmainrow_.Modi_Date       := NULL;
      Idpdetailrow_.Delplan_Line := 0;
      OPEN Cur1_ FOR
        SELECT t.*
          FROM Bl_Temp t
         WHERE t.Rowdate = Dpmainrow_.Delived_Date;
      FETCH Cur1_
        INTO Temp_Row_;
      LOOP
        EXIT WHEN Cur1_%NOTFOUND;
        Idpdetailrow_.Delplan_Line   := Idpdetailrow_.Delplan_Line + 1;
        Dpmainrow_.Delplan_Line      := Idpdetailrow_.Delplan_Line;
        Idpdetailrow_.Delplan_No     := Dpmainrow_.Delplan_No;
        Idpdetailrow_.Modify_Id      := Row_.Modify_Id;
        Idpdetailrow_.Modify_Lineno  := Nvl(Pkg_a.Get_Item_Value('MODIFY_LINENO',
                                                                 Temp_Row_.Rowlist),
                                            '0');
        Idpdetailrow_.f_Order_No     := Pkg_a.Get_Item_Value('F_ORDER_NO',
                                                             Temp_Row_.Rowlist);
        Idpdetailrow_.f_Line_No      := Pkg_a.Get_Item_Value('F_LINE_NO',
                                                             Temp_Row_.Rowlist);
        Idpdetailrow_.f_Rel_No       := Pkg_a.Get_Item_Value('F_REL_NO',
                                                             Temp_Row_.Rowlist);
        Idpdetailrow_.f_Line_Item_No := Pkg_a.Get_Item_Value('F_LINE_ITEM_NO',
                                                             Temp_Row_.Rowlist);
        Idpdetailrow_.Base_No        := Pkg_a.Get_Item_Value('DELPLAN_NO',
                                                             Temp_Row_.Rowlist);
        Idpdetailrow_.Base_Line      := Pkg_a.Get_Item_Value('DELPLAN_LINE',
                                                             Temp_Row_.Rowlist);
        Idpdetailrow_.Column_No      := Dpmainrow_.Column_No;
        Idpdetailrow_.Version        := Dpmainrow_.Version;
        Idpdetailrow_.Picklistno     := Temp_Row_.Picklistno;
        Idpdetailrow_.State          := Dpmainrow_.State;
        Idpdetailrow_.Enter_User     := User_Id_;
        Idpdetailrow_.Enter_Date     := SYSDATE;
        Idpdetailrow_.Qty_Delived    := Pkg_a.Get_Item_Value('QTY',
                                                             Temp_Row_.Rowlist);
        -- 备货单     
        Idpdetailrow_.Delived_Date := Dpmainrow_.Delived_Date;
      
        Idpdetailrow_.Order_Line_No := Idpdetailrow_.f_Order_No || '-' ||
                                       Idpdetailrow_.f_Line_No || '-' ||
                                       Idpdetailrow_.f_Rel_No || '-' ||
                                       To_Char(Idpdetailrow_.f_Line_Item_No);
      
        OPEN Cur2_ FOR
          SELECT t.*
            FROM Bl_v_Customer_Order_V02 t
           WHERE t.Order_No = Idpdetailrow_.f_Order_No
             AND t.Line_No = Idpdetailrow_.f_Line_No
             AND t.Rel_No = Idpdetailrow_.f_Rel_No
             AND t.Line_Item_No = Idpdetailrow_.f_Line_Item_No;
        FETCH Cur2_
          INTO Blrowv02;
        IF Cur2_%NOTFOUND THEN
          CLOSE Cur2_;
          Raise_Application_Error(-20101,
                                  '关键字' || Idpdetailrow_.f_Order_No ||
                                  '找对应关系错误!');
        END IF;
        CLOSE Cur2_;
        Idpdetailrow_.Po_Order_No             := Blrowv02.Po_Order_No;
        Idpdetailrow_.Po_Line_No              := Blrowv02.Po_Line_No;
        Idpdetailrow_.Po_Release_No           := Blrowv02.Po_Release_No;
        Idpdetailrow_.Demand_Order_No         := Blrowv02.Demand_Order_No;
        Idpdetailrow_.Demand_Rel_No           := Blrowv02.Demand_Rel_No;
        Idpdetailrow_.Demand_Line_No          := Blrowv02.Demand_Line_No;
        Idpdetailrow_.Demand_Line_Item_No     := Blrowv02.Demand_Line_Item_No;
        Idpdetailrow_.Par_Po_Order_No         := Blrowv02.Par_Po_Order_No;
        Idpdetailrow_.Par_Po_Line_No          := Blrowv02.Par_Po_Line_No;
        Idpdetailrow_.Par_Po_Release_No       := Blrowv02.Par_Po_Release_No;
        Idpdetailrow_.Par_Demand_Order_No     := Blrowv02.Par_Demand_Order_No;
        Idpdetailrow_.Par_Demand_Rel_No       := Blrowv02.Par_Demand_Rel_No;
        Idpdetailrow_.Par_Demand_Line_No      := Blrowv02.Par_Demand_Line_No;
        Idpdetailrow_.Par_Demand_Line_Item_No := Blrowv02.Par_Demand_Line_Item_No;
      
        Idpdetailrow_.Order_No     := Nvl(Idpdetailrow_.Par_Demand_Order_No,
                                          Nvl(Idpdetailrow_.Demand_Order_No,
                                              Idpdetailrow_.f_Order_No));
        Idpdetailrow_.Line_No      := Nvl(Idpdetailrow_.Par_Demand_Line_No,
                                          Nvl(Idpdetailrow_.Demand_Line_No,
                                              Idpdetailrow_.f_Line_No)); --crow_.LINE_NO;
        Idpdetailrow_.Rel_No       := Nvl(Idpdetailrow_.Par_Demand_Rel_No,
                                          Nvl(Idpdetailrow_.Demand_Rel_No,
                                              Idpdetailrow_.f_Rel_No));
        Idpdetailrow_.Line_Item_No := Nvl(Idpdetailrow_.Par_Demand_Line_Item_No,
                                          Nvl(Idpdetailrow_.Demand_Line_Item_No,
                                              Idpdetailrow_.f_Line_Item_No));
      
      
      
        --插入交货计划数据
        --bldelivery_plan_line_api
        INSERT INTO Bl_Delivery_Plan_Detial
          (Delplan_No, Delplan_Line)
        VALUES
          (Idpdetailrow_.Delplan_No, Idpdetailrow_.Delplan_Line)
        RETURNING ROWID INTO Rowobjid_;
      
        UPDATE Bl_Delivery_Plan_Detial
           SET ROW = Idpdetailrow_
         WHERE ROWID = Rowobjid_;
        Bldelivery_Plan_Line_Api.Savehist__(Rowobjid_,
                                            User_Id_,
                                            A311_Key_,
                                            '变更录入数据');
        FETCH Cur1_
          INTO Temp_Row_;
      END LOOP;
    
      CLOSE Cur1_;
    
      INSERT INTO Bl_Delivery_Plan
        (Delplan_No)
      VALUES
        (Dpmainrow_.Delplan_No)
      RETURNING ROWID INTO Rowobjid_;
      UPDATE Bl_Delivery_Plan SET ROW = Dpmainrow_ WHERE ROWID = Rowobjid_;
    
      FETCH Cur_
        INTO Dpmainrow_.Delived_Date, Dpmainrow_.Picklistno;
    END LOOP;
    CLOSE Cur_;*/
  
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '交货计划变更申请' || '[' || Row_.Modify_Id || ']' || '确认成功');
    Return;
  End;
  Procedure Remove_Qty_(Order_No_     In Varchar2,
                        Line_No_      In Varchar2,
                        Rel_No_       In Varchar2,
                        Line_Item_No_ In Number,
                        Picklistno_   In Varchar2,
                        --如果为null 或者为空 表示变更订单数量为  Newqty_
                        Newqty_   In Number,
                        User_Id_  In Varchar2,
                        A311_Key_ In Number Default 0) Is
    Cur2_         t_Cursor;
    Cur_          t_Cursor;
    Corow_        Customer_Order_Line%Rowtype;
    Childrow_     Customer_Order_Line%Rowtype;
    Childqty_     Number;
    Qty_Assigned_ Number;
    If_Remove     Boolean;
    Sql_          Varchar2(30000);
  Begin
    If Line_Item_No_ = -1 Then
      --移除子件
      Open Cur2_ For
        Select t.*
          From Customer_Order_Line t
         Where t.Order_No = Order_No_
           And t.Line_No = Line_No_
           And t.Rel_No = Rel_No_
           And t.Line_Item_No = Line_Item_No_;
      Fetch Cur2_
        Into Corow_;
      Close Cur2_;
      If_Remove := False;
      Open Cur_ For
        Select t.*
          From Customer_Order_Line t
         Where t.Order_No = Order_No_
           And t.Line_No = Line_No_
           And t.Rel_No = Rel_No_
           And t.Line_Item_No > 0;
      Fetch Cur_
        Into Childrow_;
      Loop
        Exit When Cur_%Notfound;
        If Childrow_.Qty_Picked > 0 Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Order_No_ || '-' || Line_No_ || '-' ||
                                  Rel_No_ || '-' || Childrow_.Line_Item_No || '(' ||
                                  Childrow_.Catalog_No || ')存在提货数量' ||
                                  Childrow_.Qty_Picked || ',不能变更');
        End If;
      
        --获取 变更后组建数量
        Childqty_ := Newqty_ * Childrow_.Buy_Qty_Due / Corow_.Buy_Qty_Due;
        --移除备货单的数量
        If Nvl(Picklistno_, '-') <> '-' Then
          Qty_Assigned_ := Get_Bl_Pltrans_Qty(Picklistno_,
                                              Order_No_,
                                              Line_No_,
                                              Rel_No_,
                                              Line_Item_No_);
          --如果预留的数量   小于 要变更后的数量                                    
          If Qty_Assigned_ > Childqty_ Then
            If_Remove := True;
          End If;
        End If;
        --预留数量大于变更数量
        If Childrow_.Qty_Assigned > Childqty_ Then
          If_Remove := True;
        End If;
        If Childrow_.Qty_Picked > 0 Or Childrow_.Qty_Assigned > 0 Then
          Sql_ := Nvl(Sql_, '') ||
                  'Bl_Customer_Order_Line_Api.Remove_Qty_Assigned(''' ||
                  Childrow_.Objid || ''',''' || User_Id_ || ''',' ||
                  A311_Key_ || ');';
          /*          Raise_Application_Error(Pkg_a.Raise_Error,
          Order_No_ || '-' || Line_No_ || '-' ||
          Rel_No_ || '-' || Childrow_.Line_Item_No || '(' ||
          Childrow_.Catalog_No || ')存在提货数量' ||
          Childrow_.Qty_Picked || ',不能变更');*/
          /*                If Childrow_.Qty_Assigned > 0 Then
            Sql_ := Nvl(Sql_, '') ||
                    'Bl_Customer_Order_Line_Api.Remove_Qty_Assigned(''' ||
                    Childrow_.Objid || ''',''' || User_Id_ || ''',' ||
                    A311_Key_ || ');';
          End If;*/
        
        End If;
      
        Fetch Cur_
          Into Childrow_;
      End Loop;
      Close Cur_;
    
      If If_Remove Then
        Sql_ := 'begin ' || Sql_ || ' end ;';
        Execute Immediate Sql_;
      End If;
    
    Else
      --移除备货单的数量
      If Nvl(Picklistno_, '-') <> '-' Then
        Qty_Assigned_ := Get_Bl_Pltrans_Qty(Picklistno_,
                                            Order_No_,
                                            Line_No_,
                                            Rel_No_,
                                            Line_Item_No_);
        --如果预留的数量     小于 要变更后的数量                                    
        If Qty_Assigned_ <= Newqty_ Then
          Return;
        End If;
      
      End If;
      Open Cur2_ For
        Select t.*
          From Customer_Order_Line t
         Where t.Order_No = Order_No_
           And t.Line_No = Line_No_
           And t.Rel_No = Rel_No_
           And t.Line_Item_No = Line_Item_No_;
      Fetch Cur2_
        Into Corow_;
      Close Cur2_;
      If Corow_.Qty_Assigned > Newqty_ Then
        Bl_Customer_Order_Line_Api.Remove_Qty_Assigned(Corow_.Objid,
                                                       User_Id_,
                                                       A311_Key_);
      
      End If;
    End If;
  
  End;

  Procedure Gettemprow(Row_ In Out Bl_Temp%Rowtype) Is
    Cur_ t_Cursor;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Temp t
       Where t.Tempkey = Row_.Tempkey
         And t.Rowkey = Row_.Rowkey;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, 'getTempRow错误的临时处理');
    End If;
    Close Cur_;
  
  End;

  --交货计划变更否决
  Procedure Dpreleaseclose__(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Cur_      t_Cursor;
    Crow_     Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
    Objid_    Varchar2(100);
  Begin
    Releaseclose__(Rowlist_, User_Id_, A311_Key_, Objid_, Row_);
    -- Raise_Application_Error(-20101, row_.type_id);
    If Row_.Type_Id = '3' Then
    
      Open Cur_ For
        Select t.*
          From Bl_Bill_Vary t
         Where t.Smodify_Id = Row_.Smodify_Id
           And t.State = '1'; --不是提交状态 表示 全处理过了
      Fetch Cur_
        Into Crow_;
      If Cur_%Notfound Then
        Update Bl_Bill_Vary t
           Set t.State = '3'
         Where t.Modify_Id = Row_.Smodify_Id;
      End If;
      Close Cur_;
    End If;
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Objid_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '订单变更申请' || '[' || Row_.Modify_Id || ']' || '否决成功');
  
    Return;
  End;

  -- 交货计划变更作废
  Procedure Dpcancel__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Cancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '交货计划变更申请' || '[' || Row_.Modify_Id || ']' || '作废成功');
  End;
  Procedure Ponew__(Rowlist_    Varchar2,
                    User_Id_    Varchar2,
                    A311_Key_   Varchar2,
                    Modi_Objid_ Varchar2) Is
    Iporowlist_ Varchar2(4000);
    Mainrow_    Bl_v_Purchase_Order%Rowtype;
    Irow_       Bl_v_Purchase_Order_Line_Part%Rowtype;
    --Childrow_    Bl_v_Customer_Order_V01%ROWTYPE;
    Cur_         t_Cursor;
    A314_        A314%Rowtype;
    Mainrowlist_ Varchar2(4000);
    Porowlist_   Varchar2(4000);
    A311_        A311%Rowtype;
  Begin
    Mainrow_.Order_No := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
    Open Cur_ For
      Select t.*
        From Bl_v_Purchase_Order t
       Where t.Order_No = Mainrow_.Order_No;
    Fetch Cur_
      Into Mainrow_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, 'Conew__错误的订单号');
      Return;
    End If;
    Porowlist_ := '';
    Pkg_a.Set_Item_Value('ORDER_NO', Mainrow_.Order_No, Porowlist_);
    Pkg_a.Set_Item_Value('LINE_ITEM_NO', '0', Porowlist_);
    --调用 初始化函数
    Select s_A314.Nextval Into A314_.A314_Key From Dual;
    Insert Into A314
      (A314_Key, A314_Id, State, Enter_User, Enter_Date)
      Select A314_.A314_Key, A314_.A314_Key, '0', User_Id_, Sysdate
        From Dual;
    --获取初始化的值
    Bl_Po_Line_Part_Api.New__(Porowlist_, User_Id_, A314_.A314_Key);
    --获取返回的初始值  
    Select t.Res
      Into Porowlist_
      From A314 t
     Where t.A314_Key = A314_.A314_Key
       And Rownum = 1;
    --格式化要传入的参数
    Iporowlist_ := '';
    Pkg_a.Set_Item_Value('OBJID', 'NULL', Iporowlist_);
    Pkg_a.Set_Item_Value('DOACTION', 'I', Iporowlist_);
    Pkg_a.Set_Item_Value('ORDER_NO', Mainrow_.Order_No, Iporowlist_);
    Pkg_a.Set_Item_Value('LINE_ITEM_NO', '0', Iporowlist_);
  
    Pkg_a.Str_Add_Str(Iporowlist_, Porowlist_);
  
    --输入物料编码
    Pkg_a.Get_Row_Str('BL_V_PURCHASE_ORDER',
                      ' AND ORDER_NO=''' || Mainrow_.Order_No || '''',
                      Mainrowlist_);
  
    --
  
    Irow_.Part_No     := Pkg_a.Get_Item_Value('PART_NO', Rowlist_);
    Irow_.Description := Pkg_a.Get_Item_Value('DESCRIPTION', Rowlist_);
    Irow_.Buy_Qty_Due := Pkg_a.Get_Item_Value('BUY_QTY_DUE', Rowlist_);
  
    Pkg_a.Set_Item_Value('PART_NO', Irow_.Part_No, Iporowlist_);
    Pkg_a.Set_Item_Value('DESCRIPTION', Irow_.Description, Iporowlist_);
  
    Bl_Po_Line_Part_Api.Itemchange__('PART_NO',
                                     Mainrowlist_,
                                     Iporowlist_,
                                     User_Id_,
                                     Porowlist_);
    --把 返回的数据 合并到  Icorowlist_中
    Pkg_a.Str_Add_Str(Iporowlist_, Porowlist_);
  
    --输入数量
    Pkg_a.Set_Item_Value('BUY_QTY_DUE', Irow_.Buy_Qty_Due, Iporowlist_);
    Bl_Po_Line_Part_Api.Itemchange__('BUY_QTY_DUE',
                                     Mainrowlist_,
                                     Iporowlist_,
                                     User_Id_,
                                     Porowlist_);
  
    Pkg_a.Str_Add_Str(Iporowlist_, Porowlist_);
  
    A311_.A311_Id    := 'Blbill_Vary_Api.Ponew__';
    A311_.Enter_User := User_Id_;
    A311_.A014_Id    := 'A014_ID=SAVE';
    A311_.Table_Id   := 'BL_V_PURCHASE_ORDER_LINE_PART';
    Pkg_a.Beginlog(A311_);
  
    Bl_Po_Line_Part_Api.Modify__(Iporowlist_, User_Id_, A311_.A311_Key);
    Open Cur_ For
      Select t.* From A311 t Where t.A311_Key = A311_.A311_Key;
    Fetch Cur_
      Into A311_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, 'Ponew__处理失败');
      Return;
    End If;
    Close Cur_;
    Open Cur_ For
      Select t.*
        From Bl_v_Purchase_Order_Line_Part t
       Where t.Objid = A311_.Table_Objid;
    Fetch Cur_
      Into Irow_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, 'Ponew__处理失败');
      Return;
    Else
      Close Cur_;
    End If;
  
    --判断当前生成的订单行 
    --获取生成订单的下域订单并且下达掉
    Update Bl_Bill_Vary_Detail t
       Set t.Order_No = Irow_.Order_No,
           t.Line_No  = Irow_.Line_No,
           t.Rel_No   = Irow_.Release_No
     Where Rowid = Modi_Objid_;
  
    --判断当前生成的订单行 
    --获取生成订单的下域订单并且下达掉  
  
  End;
  --交货计划交期变更 提交（工厂交期）
  Procedure Dpfrelease__(Rowlist_ Varchar2,
                         --视图的OBJID
                         User_Id_ Varchar2,
                         --用户ID
                         A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Release__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '交货计划变更申请' || '[' || Row_.Modify_Id || ']' || '提交成功');
  
    Return;
  End;

  --交货计划 交期变更 确认（工厂交期）
  Procedure Dpfapprove__(Rowlist_ Varchar2,
                         --视图的OBJID
                         User_Id_ Varchar2,
                         --用户ID
                         A311_Key_ Varchar2) Is
    Row_         Bl_Bill_Vary%Rowtype;
    Table_Id_    Varchar2(100);
    Newdate_     Date;
    Cur_         t_Cursor;
    Cur1_        t_Cursor;
    Dprow_       Bl_Delivery_Plan_v%Rowtype;
    Dpdetailrow_ Bl_Delivery_Plan_Detial_v%Rowtype;
    Detailrow_   Bl_Bill_Vary_Detail_v%Rowtype;
  Begin
    Approve__(Rowlist_, User_Id_, A311_Key_, Row_);
  
    Newdate_ := To_Date(Pkg_a.Get_Item_Value('DELIVED_DATEF', Row_.Rowdata),
                        'YYYY-MM-DD');
    Bldelivery_Plan_Api.Change_Date(Row_.Source_No,
                                    User_Id_,
                                    Newdate_,
                                    Dprow_);
    Open Cur_ For
      Select t.*
        From Bl_Bill_Vary_Detail_v t
       Where t.Modify_Id = Row_.Modify_Id;
    Fetch Cur_
      Into Detailrow_;
    Loop
      Exit When Cur_%Notfound;
    
      Open Cur1_ For
        Select t.*
          From Bl_Delivery_Plan_Detial_v t
         Where t.Delplan_No = Dprow_.Delplan_No
           And t.Order_No = Detailrow_.Order_No
           And t.Line_No = Detailrow_.Line_No
           And t.Rel_No = Detailrow_.Rel_No
           And t.Line_Item_No = Detailrow_.Line_Item_No;
      Fetch Cur1_
        Into Dpdetailrow_;
      If Cur1_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '交货计划被其他变更修改了，无法确认了！');
      End If;
      Close Cur1_;
    
      Update Bl_Delivery_Plan_Detial t
         Set t.Modify_Id     = Detailrow_.Modify_Id,
             t.Modify_Lineno = Detailrow_.Modify_Lineno
       Where Rowid = Dpdetailrow_.Objid;
    
      Bldelivery_Plan_Line_Api.Savehist__(Dpdetailrow_.Objid,
                                          User_Id_,
                                          A311_Key_,
                                          '交期变更' ||
                                          To_Char(Detailrow_.Delived_Date,
                                                  'YYYY-MM-DD') || '-->' ||
                                          To_Char(Detailrow_.Delived_Datef,
                                                  'YYYY-MM-DD'));
    
      Update Bl_Bill_Vary_Detail t
         Set t.New_Line_Key = Dpdetailrow_.Delplan_No || '-' ||
                              Dpdetailrow_.Delplan_Line,
             t.Modi_User    = User_Id_,
             t.Modi_Date    = Sysdate
       Where Rowid = Detailrow_.Objid;
    
      Fetch Cur_
        Into Detailrow_;
    End Loop;
  
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '交货计划变更申请' || '[' || Row_.Modify_Id || ']' || '确认成功');
  
    Return;
  End;

  --交货计划变更 取消提交（工厂交期）
  Procedure Dpfreleasecancel__(Rowlist_ Varchar2,
                               --视图的OBJID
                               User_Id_ Varchar2,
                               --用户ID
                               A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Cancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '交货计划变更申请' || '[' || Row_.Modify_Id || ']' || '作废成功');
  End;

  --交货计划作废 （工厂交期）
  Procedure Dpfcancel__(Rowlist_ Varchar2,
                        --视图的OBJID
                        User_Id_ Varchar2,
                        --用户ID
                        A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Cancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '交货计划变更申请' || '[' || Row_.Modify_Id || ']' || '作废成功');
  End;

  --备货单变更提交（整体修改）
  Procedure Pkdprelease__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Release__(Rowlist_, User_Id_, A311_Key_, Row_);
    Pkdpapprove__(Rowlist_, User_Id_, A311_Key_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '备货单变更申请' || '[' || Row_.Modify_Id || ']' || '提交成功');
  End;
  Procedure Pkdpcancel__(Rowlist_  Varchar2,
                         User_Id_  Varchar2,
                         A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  
  Begin
  
    Cancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
  
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '备货单变更申请' || '[' || Row_.Modify_Id || ']' || '作废成功');
    Return;
  
  End;
  --备货单变更取消提交（整体修改）
  Procedure Pkdpreleasecancel__(Rowlist_  Varchar2,
                                User_Id_  Varchar2,
                                A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Releasecancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
  
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '备货单变更申请' || '[' || Row_.Modify_Id || ']' || '取消提交成功');
    Return;
  End;
  --备货单变更确认（整体修改）
  Procedure Pkdpapprove__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
    Mainrow_     Bl_Bill_Vary%Rowtype;
    Detailrow_   Bl_Bill_Vary_Detail_v%Rowtype;
    Dpdetailrow_ Bl_Delivery_Plan_Detial_v%Rowtype;
    Dpmainrow_   Bl_Delivery_Plan_v%Rowtype;
    --Corow_       Customer_Order_Line%Rowtype;
    Table_Id_    Varchar2(100);
    Cur_         t_Cursor;
    Cur1_        t_Cursor;
    Bl_Picklist_ Bl_Picklist%Rowtype;
    --Cur2_        t_Cursor;
    --i            Number;
  Begin
    --把备货单号 从交货计划中删除
    Open Cur_ For
      Select t.* From Bl_Bill_Vary t Where t.Rowid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    Open Cur_ For
      Select t.*
        From Bl_Bill_Vary_Detail_v t
       Where t.Modify_Id = Mainrow_.Modify_Id;
    Fetch Cur_
      Into Detailrow_;
    Loop
      Exit When Cur_%Notfound;
      --检测当前 交货计划的状态
      Open Cur1_ For
        Select t.*
          From Bl_Delivery_Plan_v t
         Where t.Delplan_No = Detailrow_.Line_Key;
      Fetch Cur1_
        Into Dpmainrow_;
      If Cur1_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '错误的交货计划编码' || Detailrow_.Line_Key);
      End If;
      Close Cur1_;
      If Dpmainrow_.State != '2' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '交货计划' || Detailrow_.Line_Key ||
                                '不能确认状态不能变更！');
      
      End If;
      If Detailrow_.Modify_Type = 'D' Then
        If Dpmainrow_.Picklistno != Mainrow_.Source_No Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  '交货计划' || Detailrow_.Line_Key ||
                                  '已经不属于备货单' || Mainrow_.Source_No ||
                                  ',不能变更');
        
        End If;
        Update Bl_Delivery_Plan t
           Set t.Picklistno = Null
         Where Rowid = Dpmainrow_.Objid;
      End If;
      If Detailrow_.Modify_Type = 'I' Then
        If Nvl(Dpmainrow_.Picklistno, '-') != '-' Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  '交货计划' || Detailrow_.Line_Key ||
                                  '已经有备货单号' || Dpmainrow_.Picklistno ||
                                  ',不能变更');
        
        End If;
        Update Bl_Delivery_Plan t
           Set t.Picklistno = Mainrow_.Source_No
         Where Rowid = Dpmainrow_.Objid;
      End If;
    
      Open Cur1_ For
        Select t.*
          From Bl_Delivery_Plan_Detial_v t
         Where t.Delplan_No = Detailrow_.Line_Key
           And t.State <> '3'
           And t.Qty_Delived > 0;
      Fetch Cur1_
        Into Dpdetailrow_;
      If Cur1_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '交货计划' || Detailrow_.Line_Key ||
                                '没有有效行,备货单' || Mainrow_.Source_No || '不能变更');
      End If;
      --获取备货单头
      Check_Bl_Picklist(Mainrow_.Source_No, Bl_Picklist_);
      Loop
        Exit When Cur1_%Notfound;
        --只有确认才能变更
        If Dpdetailrow_.State != '2' Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  '交货计划' || Detailrow_.Line_Key ||
                                  '行状态不是确认,不能变更');
        
        End If;
        If Detailrow_.Modify_Type = 'I' Then
          --把数据插入到备货单中
          Update Bl_Delivery_Plan_Detial t
             Set t.Picklistno = Mainrow_.Source_No
           Where Rowid = Dpdetailrow_.Objid;
        
          Insert Into Bl_Pldtl
            (Contract,
             Customerno,
             Picklistno,
             Supplier,
             Order_No,
             Line_No,
             Rel_No,
             Line_Item_No,
             Pickqty,
             Wanted_Delivery_Date,
             Finishdate,
             Remark,
             Flag,
             Userid,
             Finishqty,
             Relqty,
             Reason,
             Drdate,
             Notetext,
             Deremark,
             Rel_Deliver_Date)
          Values
            (Dpmainrow_.Contract,
             Dpmainrow_.Customer_No,
             Mainrow_.Source_No,
             Dpmainrow_.Supplier,
             Dpdetailrow_.Order_No,
             Dpdetailrow_.Line_No,
             Dpdetailrow_.Rel_No,
             Dpdetailrow_.Line_Item_No,
             Dpdetailrow_.Qty_Delived,
             To_Char(Dpmainrow_.Delived_Date, 'YYYY-MM-DD'),
             Null,
             '',
             Bl_Picklist_.Flag,
             User_Id_,
             Null,
             Null,
             Null,
             Null,
             Null,
             Null,
             Null);
          Bldelivery_Plan_Line_Api.Savehist__(Dpdetailrow_.Objid,
                                              User_Id_,
                                              A311_Key_,
                                              '变更到备货单' ||
                                              Mainrow_.Source_No);
        End If;
        If Detailrow_.Modify_Type = 'D' Then
          --把数据从备货单中删除
          Delete From Bl_Pldtl
           Where Picklistno = Mainrow_.Source_No
             And Order_No = Dpdetailrow_.Order_No
             And Line_No = Dpdetailrow_.Line_No
             And Rel_No = Dpdetailrow_.Rel_No
             And Line_Item_No = Dpdetailrow_.Line_Item_No;
        
          Update Bl_Delivery_Plan_Detial t
             Set t.Picklistno = Null
           Where Rowid = Dpdetailrow_.Objid;
          --移除预留
          Remove_Qty_(Dpdetailrow_.f_Order_No,
                      Dpdetailrow_.f_Line_No,
                      Dpdetailrow_.f_Rel_No,
                      Dpdetailrow_.f_Line_Item_No,
                      Dpdetailrow_.Picklistno,
                      0,
                      User_Id_,
                      A311_Key_);
          Bldelivery_Plan_Line_Api.Savehist__(Dpdetailrow_.Objid,
                                              User_Id_,
                                              A311_Key_,
                                              '变更 移除 备货单' ||
                                              Mainrow_.Source_No);
        
        End If;
      
        Fetch Cur1_
          Into Dpdetailrow_;
      End Loop;
    
      Close Cur1_;
    
      Update Bl_Bill_Vary_Detail
         Set State = '2', Modi_Date = Sysdate, Modi_User = User_Id_
       Where Rowid = Detailrow_.Objid;
      Fetch Cur_
        Into Detailrow_;
    End Loop;
    Close Cur_;
  
    Update Bl_Bill_Vary
       Set State        = '2',
           Modi_Date    = Sysdate,
           Modi_User    = User_Id_,
           Date_Comform = Sysdate
     Where Rowid = Rowlist_;
    /*  Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Mainrow_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '备货单变更申请' || '[' || Mainrow_.Modify_Id || ']' || '确认成功');*/
    Return;
  End;
  /*
  采购订单变更  交货计划变更 
  Rowlist_  Bl_Bill_Vary的rowid
  */
  --返回备货单 订单行的预留数量
  Function Get_Bl_Pltrans_Qty(Picklistno_   In Varchar2,
                              Order_No_     In Varchar2,
                              Line_No_      In Varchar2,
                              Rel_No_       In Varchar2,
                              Line_Item_No_ In Number) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    Open Cur_ For
      Select Sum(t.Qty_Assigned)
        From Bl_Pltrans t
       Where t.Picklistno = Picklistno_
         And t.Order_No = Order_No_
         And t.Line_No = Line_No_
         And t.Rel_No = Rel_No_
         And t.Line_Item_No = Line_Item_No_;
    Fetch Cur_
      Into Result_;
  
    Close Cur_;
    Return Nvl(Result_, 0);
  End;
  Procedure Posetnext(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2,
                      Order_No_ Varchar Default '-') Is
    Row_            Bl_Bill_Vary%Rowtype;
    Detailrow_      Bl_v_Purchase_Order_Chg_Det%Rowtype; --变更行  
    Detailrow_Auto_ Bl_v_Purchase_Order_Chg_Det%Rowtype; --变更行 
    Cur_            t_Cursor;
    Cur1_           t_Cursor;
    Cur2_           t_Cursor;
    Cur3_           t_Cursor;
    Temp_Row_       Bl_Temp%Rowtype;
    Temp_Key_       Number;
    Supplier_       Varchar2(100);
    Dpmainrow_      Bl_Delivery_Plan_v%Rowtype; --交货计划
    Dpdetailrow_    Bl_Delivery_Plan_Detial_v%Rowtype; --交货计划
    Newrow_         Bl_Bill_Vary_v%Rowtype;
    Newrowlist_     Varchar2(30000);
    Co_             Bl_v_Customer_Order%Rowtype;
    A311_           A311%Rowtype;
    Newdetaillist_  Varchar2(30000);
    Inewdetaillist_ Varchar2(30000);
    Idetaillist_    Varchar2(30000);
    If_End          Varchar2(1);
    Coline_         Customer_Order_Line%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_Bill_Vary t Where Rowid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的ROWID');
      Return;
    End If;
    Close Cur_;
    Update Bl_Bill_Vary t --更新主档 状态
       Set t.Data_Lock = '0', t.Lock_User = Null
     Where Modify_Id = Row_.Modify_Id;
    Select s_Bl_Temp.Nextval Into Temp_Key_ From Dual;
    Open Cur_ For
      Select t.*
        From Bl_v_Purchase_Order_Chg_Det t
       Where t.Modify_Id = Row_.Modify_Id
         And t.Modify_Type In ('I', 'M');
    Fetch Cur_
      Into Detailrow_;
    Loop
      Exit When Cur_%Notfound;
      --修改数量
    
      --获取采购订单行的销售订单
      Open Cur1_ For
        Select t.*
          From Customer_Order_Line t
         Where t.Demand_Order_Ref1 = Detailrow_.Order_No
           And t.Demand_Order_Ref2 = Detailrow_.Line_No
           And t.Demand_Order_Ref3 = Detailrow_.Rel_No;
      Fetch Cur1_
        Into Coline_;
      Close Cur1_;
      Supplier_ := Bl_Customer_Order_Line_Api.Get_Factory_Order_(Coline_.Order_No,
                                                                 Coline_.Line_No,
                                                                 Coline_.Rel_No,
                                                                 Coline_.Line_Item_No,
                                                                 '1');
      -- 获取 采购订单的 客户订单
      Open Cur1_ For
        Select t.*
          From Bl_v_Customer_Order t
         Where t.Order_No = Coline_.Order_No;
      Fetch Cur1_
        Into Co_;
      Close Cur1_;
      --获取 订单行的工厂域
      Open Cur1_ For
        Select t.*
          From Bl_Delivery_Plan_v t
         Where t.Order_No = Coline_.Order_No
           And t.Supplier = Supplier_
           And (t.State = '2' Or t.State = '1'); --提交状态 和 确认状态 
      Fetch Cur1_
        Into Dpmainrow_;
      If Cur1_%Found Then
        --如果只是下达状态 取消下达 让工厂修改
        If Dpmainrow_.State = '1' Then
          A311_.A311_Id     := 'Blbill_Vary_Api.PoSetNext';
          A311_.Enter_User  := User_Id_;
          A311_.A014_Id     := 'A014_ID=Order_PCancel';
          A311_.Table_Id    := 'BL_V_CUST_DELIVERY_PLAN';
          A311_.Table_Objid := Coline_.Order_No || '-' || Supplier_;
          Pkg_a.Beginlog(A311_);
          Pkg_a.Doa014('Order_PCancel',
                       'BL_V_CUST_DELIVERY_PLAN',
                       A311_.Table_Objid,
                       User_Id_,
                       A311_.A311_Key);
        
        End If;
        If Dpmainrow_.State = '2' Then
          --产生交货计划变更变更申请 --
          Open Cur2_ For
            Select t.*
              From Bl_Temp t
             Where t.Tempkey = Temp_Key_
               And t.Rowkey = Co_.Order_No || '-' || Supplier_;
          Fetch Cur2_
            Into Temp_Row_;
          If Cur2_%Found Then
            Newrowlist_ := Temp_Row_.Rowlist;
          Else
            Temp_Row_.Rowkey  := Co_.Order_No || '-' || Supplier_;
            Temp_Row_.Tempkey := Temp_Key_;
            Newrowlist_       := '';
            A311_.A311_Id     := 'Blbill_Vary_Api.PoSetNext';
            A311_.Enter_User  := User_Id_;
            A311_.A014_Id     := 'A014_ID=SAVE';
            A311_.Table_Id    := 'BL_BILL_VARY_V';
            Pkg_a.Beginlog(A311_);
            Pkg_a.Set_Item_Value('DOACTION', 'I', Newrowlist_);
            Pkg_a.Set_Item_Value('OBJID', '', Newrowlist_);
            Pkg_a.Set_Item_Value('MODIFY_ID', '', Newrowlist_);
            Pkg_a.Set_Item_Value('ORDER_NO', Co_.Order_No, Newrowlist_);
            Pkg_a.Set_Item_Value('SUPPLIER', Supplier_, Newrowlist_);
            Pkg_a.Set_Item_Value('SOURCE_NO',
                                 Temp_Row_.Rowkey,
                                 Newrowlist_);
            Pkg_a.Set_Item_Value('CUSTOMER_NO',
                                 Co_.Customer_No,
                                 Newrowlist_);
            Pkg_a.Set_Item_Value('STATE', '0', Newrowlist_);
            Pkg_a.Set_Item_Value('SMODIFY_ID', Row_.Modify_Id, Newrowlist_);
            Pkg_a.Set_Item_Value('CUSTOMER_REF',
                                 Co_.Label_Note,
                                 Newrowlist_);
            Pkg_a.Set_Item_Value('TYPE_ID', '2', Newrowlist_);
            Blbill_Vary_Api.Modify__(Newrowlist_, User_Id_, A311_.A311_Key);
            Open Cur3_ For
              Select t.* From A311 t Where t.A311_Key = A311_.A311_Key;
            Fetch Cur3_
              Into A311_;
            Close Cur3_;
            Open Cur3_ For
              Select t.*
                From Bl_Bill_Vary_v t
               Where t.Objid = A311_.Table_Objid;
            Fetch Cur3_
              Into Newrow_;
            Close Cur3_;
            Pkg_a.Set_Item_Value('OBJID', Newrow_.Objid, Newrowlist_);
            Pkg_a.Set_Item_Value('MODIFY_ID',
                                 Newrow_.Modify_Id,
                                 Newrowlist_);
            Temp_Row_.Rowlist := Newrowlist_;
            Insert Into Bl_Temp_Tab
              (Tempkey, Rowkey, Rowlist)
            Values
              (Temp_Row_.Tempkey, Temp_Row_.Rowkey, Temp_Row_.Rowlist);
          End If;
        
          Close Cur2_;
          Newdetaillist_  := '';
          Inewdetaillist_ := '';
          Pkg_a.Set_Item_Value('DOACTION', 'I', Inewdetaillist_);
          Pkg_a.Set_Item_Value('OBJID', '', Inewdetaillist_);
          Pkg_a.Set_Item_Value('MODIFY_ID',
                               Newrow_.Modify_Id,
                               Inewdetaillist_);
        
          --把交货计划数量改为0 
          Detailrow_.Qty_Delived := 0;
        
          Pkg_a.Set_Item_Value('LINE_KEY',
                               Coline_.Order_No || '-' || Coline_.Line_No || '-' ||
                               Coline_.Rel_No || '-' ||
                               Coline_.Line_Item_No,
                               Inewdetaillist_);
          Blbill_Vary_Line_Api.Itemchange__('LINE_KEY',
                                            Newrowlist_,
                                            Inewdetaillist_,
                                            User_Id_,
                                            Newdetaillist_);
          --把 返回的数据 合并到  Icorowlist_中
          Pkg_a.Str_Add_Str(Inewdetaillist_, Newdetaillist_);
          --开始处理数量 
          Pkg_a.Set_Item_Value('BASE_NO',
                               Detailrow_.Modify_Id,
                               Inewdetaillist_);
          Pkg_a.Set_Item_Value('BASE_LINE',
                               Detailrow_.Modify_Lineno,
                               Inewdetaillist_);
          Pkg_a.Set_Item_Value('MODIFY_TYPE', 'DPM', Inewdetaillist_);
          Open Cur3_ For
            Select t.*
              From Bl_Delivery_Plan_Detial_v t
             Where t.Order_No = Coline_.Order_No
               And t.Line_No = Coline_.Line_No
               And t.Rel_No = Coline_.Rel_No
               And t.Line_Item_No = Coline_.Line_Item_No
               And (t.State = '2' Or t.State = '4' Or t.State = '5')
             Order By t.State Desc, t.Delived_Date Asc;
          Fetch Cur3_
            Into Dpdetailrow_;
          If_End                := '0';
          Detailrow_Auto_.State := '0';
          Detailrow_.State      := '0';
          Loop
            Exit When Cur3_%Notfound;
            --当已算 交货计划 + 当前 计划数量大于 订单数
            Idetaillist_ := Inewdetaillist_;
            If Detailrow_.Qty_Delived + Dpdetailrow_.Qty_Delived >
               Detailrow_.Qty_Delivedf Then
              --当前行数量 减少
            
              Pkg_a.Set_Item_Value('PLAN_LINE_KEY',
                                   Dpdetailrow_.Delplan_No || '-' ||
                                   Dpdetailrow_.Delplan_Line,
                                   Idetaillist_);
              Blbill_Vary_Line_Api.Itemchange__('PLAN_LINE_KEY',
                                                Newrowlist_,
                                                Idetaillist_,
                                                User_Id_,
                                                Newdetaillist_);
              --把 返回的数据 合并到  Icorowlist_中
              Pkg_a.Str_Add_Str(Idetaillist_, Newdetaillist_);
            
              --余下未发货的数量
              -- detailrow_.QTY_DELIVEDF 
              If If_End = '0' Then
                Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                                     Detailrow_.Qty_Delivedf -
                                     Detailrow_.Qty_Delived,
                                     Idetaillist_);
                If_End := '1';
              Else
                Pkg_a.Set_Item_Value('QTY_DELIVEDF', '0', Idetaillist_);
                If_End := '1';
              End If;
              --插入明细
            
              Blbill_Vary_Line_Api.Modify__(Idetaillist_,
                                            User_Id_,
                                            A311_Key_);
            
            End If;
            Detailrow_.Qty_Delived   := Detailrow_.Qty_Delived +
                                        Dpdetailrow_.Qty_Delived;
            Detailrow_.Delived_Datef := Dpdetailrow_.Delived_Date;
          
            If Dpdetailrow_.State = '2' Then
              If Bldelivery_Plan_Api.Get_Type_Id(Dpdetailrow_.Delplan_No) =
                 'AUTO' Then
                --把数量加入到自动生成中
                Detailrow_Auto_.Delived_Datef := Dpdetailrow_.Delived_Date;
                Detailrow_Auto_.Column_No     := Dpdetailrow_.Qty_Delived;
                Detailrow_Auto_.State         := '1';
              End If;
              Detailrow_.Delived_Datef := Dpdetailrow_.Delived_Date;
              Detailrow_.Column_No     := Dpdetailrow_.Qty_Delived;
              Detailrow_.State         := '1';
            End If;
          
            Fetch Cur3_
              Into Dpdetailrow_;
          End Loop;
          Close Cur3_;
          If Detailrow_.Qty_Delived < Detailrow_.Qty_Delivedf Then
            Idetaillist_ := Inewdetaillist_;
            --自动未发货
            If Detailrow_Auto_.State = '1' Then
              --把数量加入到最后一个 日期里面 加 1 天            
              Pkg_a.Set_Item_Value('DELIVED_DATEF',
                                   To_Char(Detailrow_Auto_.Delived_Datef,
                                           'YYYY-MM-DD'),
                                   Idetaillist_);
              Blbill_Vary_Line_Api.Itemchange__('DELIVED_DATEF',
                                                Newrowlist_,
                                                Idetaillist_,
                                                User_Id_,
                                                Newdetaillist_);
              --把 返回的数据 合并到  Icorowlist_中
              Pkg_a.Str_Add_Str(Idetaillist_, Newdetaillist_);
              Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                                   Detailrow_Auto_.Column_No +
                                   Detailrow_.Qty_Delivedf -
                                   Detailrow_.Qty_Delived,
                                   Idetaillist_);
            Else
              If Detailrow_.State = '1' Then
                --把数量加入到最后一个 日期里面 加 1 天            
                Pkg_a.Set_Item_Value('DELIVED_DATEF',
                                     To_Char(Detailrow_.Delived_Datef,
                                             'YYYY-MM-DD'),
                                     Idetaillist_);
                Blbill_Vary_Line_Api.Itemchange__('DELIVED_DATEF',
                                                  Newrowlist_,
                                                  Idetaillist_,
                                                  User_Id_,
                                                  Newdetaillist_);
                --把 返回的数据 合并到  Icorowlist_中
                Pkg_a.Str_Add_Str(Idetaillist_, Newdetaillist_);
                Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                                     Detailrow_.Column_No +
                                     Detailrow_.Qty_Delivedf -
                                     Detailrow_.Qty_Delived,
                                     Idetaillist_);
              Else
                --把数量加入到最后一个 日期里面 加 1 天            
                Pkg_a.Set_Item_Value('MODIFY_TYPE', 'DPI', Idetaillist_);
                Pkg_a.Set_Item_Value('DELIVED_DATEF',
                                     '2099-01-01',
                                     Idetaillist_);
                Blbill_Vary_Line_Api.Itemchange__('DELIVED_DATEF',
                                                  Newrowlist_,
                                                  Idetaillist_,
                                                  User_Id_,
                                                  Newdetaillist_);
                --把 返回的数据 合并到  Icorowlist_中
                Pkg_a.Str_Add_Str(Idetaillist_, Newdetaillist_);
                Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                                     Detailrow_.Qty_Delivedf -
                                     Detailrow_.Qty_Delived,
                                     Idetaillist_);
              
              End If;
            End If;
          
            --插入明细
            Blbill_Vary_Line_Api.Modify__(Idetaillist_,
                                          User_Id_,
                                          A311_Key_);
          
          End If;
        
          /*    IF Detailrow_.Qty_Delived < Detailrow_.Qty_Delivedf THEN
                 Idetaillist_ := Inewdetaillist_;
                 --把数量加入到最后一个 日期里面
                 Pkg_a.Set_Item_Value('DELIVED_DATEF',
                                      To_Char(Nvl(Detailrow_.Delived_Datef + 1,
                                                  Co_.Wanted_Delivery_Date),
                                              'YYYY-MM-DD'),
                                      Idetaillist_);
                 Blbill_Vary_Line_Api.Itemchange__('DELIVED_DATEF',
                                                   Newrowlist_,
                                                   Idetaillist_,
                                                   User_Id_,
                                                   Newdetaillist_);
                 --把 返回的数据 合并到  Icorowlist_中
                 Pkg_a.Str_Add_Str(Idetaillist_, Newdetaillist_);
               
                 Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                                      Detailrow_.Qty_Delivedf -
                                      Detailrow_.Qty_Delived,
                                      Idetaillist_);
                 --插入明细
                 Blbill_Vary_Line_Api.Modify__(Idetaillist_,
                                               User_Id_,
                                               A311_Key_);
               
               END IF;
          */
          --   begin BLBILL_VARY_API.Modify__
          --  ('DOACTION|IOBJID|MODIFY_ID|SOURCE_NO|770013CUSTOMER_NO|770013CUSTOMER_NAME|770013STATE|1SMODIFY_ID|CUSTOMER_REF|770013DATE_PUTED|2012-10-22DATE_COMFORM|DATE_CLOSED|REJECT_ID|REJECT_NAME|REJECT_REMARK|PICKLISTNO|12B0013001TYPE_ID|3REMARK|','WTL','20268'); end;
        
        End If;
      End If;
      Close Cur1_;
      Fetch Cur_
        Into Detailrow_;
    End Loop;
    Close Cur_;
  End;

  --修改采购订单行的数量 
  /*
   Rowlist_  包含ORDER_NO  LINE_NO RELEASE_NO BUY_QTY_DUE 
  */
  Procedure Pomodify__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
    Row_    Purchase_Order_Line_Part%Rowtype;
    Newrow_ Purchase_Order_Line_Part%Rowtype;
    Cur_    t_Cursor;
    Attr_   Varchar2(4000);
    --Info_   Varchar2(4000);
    --Objid_      VARCHAR2(4000);
    Porowlist_ Varchar2(4000);
    -- Action_    Varchar2(200);
    Corowlist_ Varchar2(4000);
    Childrow_  Customer_Order_Line_Tab%Rowtype;
  Begin
    Row_.Order_No   := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
    Row_.Line_No    := Pkg_a.Get_Item_Value('LINE_NO', Rowlist_);
    Row_.Release_No := Pkg_a.Get_Item_Value('RELEASE_NO', Rowlist_);
    Open Cur_ For
      Select t.*
        From Purchase_Order_Line_Part t
       Where t.Order_No = Row_.Order_No
         And t.Line_No = Row_.Line_No
         And t.Release_No = Row_.Release_No;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的订单号');
      Return;
    End If;
    Close Cur_;
    --   Action_             := 'DO';
    --Action_             := 'DO';
    Newrow_.Buy_Qty_Due := Pkg_a.Get_Item_Value('BUY_QTY_DUE', Rowlist_);
  
    Client_Sys.Add_To_Attr('BUY_QTY_DUE', Newrow_.Buy_Qty_Due, Attr_);
  
    Porowlist_ := '';
    Pkg_a.Set_Item_Value('DOACTION', 'M', Porowlist_);
    Pkg_a.Set_Item_Value('OBJID', Row_.Objid, Porowlist_);
    Pkg_a.Set_Item_Value('BUY_QTY_DUE', Newrow_.Buy_Qty_Due, Porowlist_);
  
    Bl_Po_Line_Part_Api.Modify__(Porowlist_, User_Id_, A311_Key_);
  
    /* Purchase_Order_Line_Part_Api.Modify__(Info_,
    Row_.Objid,
    Row_.Objversion,
    Attr_,
    Action_);*/
    Open Cur_ For
      Select t.*
        From Customer_Order_Line_Tab t
       Where t.Demand_Order_Ref1 = Row_.Order_No
         And t.Demand_Order_Ref2 = Row_.Line_No
         And t.Demand_Order_Ref3 = Row_.Release_No;
    Fetch Cur_
      Into Childrow_;
    If Cur_%Found Then
      Close Cur_;
      Corowlist_ := '';
      Pkg_a.Set_Item_Value('ORDER_NO', Childrow_.Order_No, Corowlist_);
      Pkg_a.Set_Item_Value('LINE_NO', Childrow_.Line_No, Corowlist_);
      Pkg_a.Set_Item_Value('REL_NO', Childrow_.Rel_No, Corowlist_);
      Pkg_a.Set_Item_Value('LINE_ITEM_NO',
                           Childrow_.Line_Item_No,
                           Corowlist_);
      Pkg_a.Set_Item_Value('BUY_QTY_DUE', Newrow_.Buy_Qty_Due, Corowlist_);
      Comodify__(Corowlist_, User_Id_, A311_Key_);
      Return;
    End If;
  
    Close Cur_;
    Return;
  End;
  Procedure Poremove__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  --
  /*
  采购订单 变更提交
  Rowlist_  Bl_Bill_Vary 的rowid 
  */
  Procedure Porelease__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Release__(Rowlist_, User_Id_, A311_Key_, Row_);
    Poapprove__(Rowlist_, User_Id_, A311_Key_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '采购订单变更申请' || '[' || Row_.Modify_Id || ']' || '提交成功');
    Return;
  End;

  /*
  采购订单变更  取消提交
  Rowlist_  Bl_Bill_Vary 的rowid 
  */
  Procedure Poreleasecancel__(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Releasecancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
  
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '采购订单变更申请' || '[' || Row_.Modify_Id || ']' || '取消提交成功');
    Return;
  End;

  /*
  采购订单变更确认
  Rowlist_  Bl_Bill_Vary 的rowid 
  */
  Procedure Poapprove__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2) Is
    Row_       Bl_Bill_Vary%Rowtype;
    Detailrow_ Bl_v_Purchase_Order_Chg_Det%Rowtype; --变更行
    --Table_Id_  Varchar2(100);
    Porowlist_ Varchar2(4000);
    --Iporowlist_  VARCHAR2(4000);
    --Mainrowlist_ VARCHAR2(4000);
    Cur_ t_Cursor;
    --Porow_       Bl_v_Purchase_Order_Line_Part%ROWTYPE;
    A311_       A311%Rowtype;
    p_A311_Key_ Number;
    --Mainrow_     Bl_v_Customer_Order%ROWTYPE;
    If_New Varchar(1);
  Begin
    Approve__(Rowlist_, User_Id_, A311_Key_, Row_);
    If_New := '0';
    Open Cur_ For
      Select t.*
        From Bl_v_Purchase_Order_Chg_Det t
       Where t.Modify_Id = Row_.Modify_Id
       Order By t.Modify_Type Desc;
    Fetch Cur_
      Into Detailrow_;
    Loop
      Exit When Cur_%Notfound;
      --修改数量
      If Detailrow_.Modify_Type = 'M' Then
        Porowlist_ := '';
        Pkg_a.Set_Item_Value('ORDER_NO', Detailrow_.Order_No, Porowlist_);
        Pkg_a.Set_Item_Value('LINE_NO', Detailrow_.Line_No, Porowlist_);
        Pkg_a.Set_Item_Value('RELEASE_NO', Detailrow_.Rel_No, Porowlist_);
        Pkg_a.Set_Item_Value('BUY_QTY_DUE',
                             Detailrow_.Qty_Delivedf,
                             Porowlist_);
      
        Pomodify__(Porowlist_, User_Id_, A311_Key_);
      End If;
      --取消客户订单行
      If Detailrow_.Modify_Type = 'D' Then
        Porowlist_ := '';
        Pkg_a.Set_Item_Value('OBJID', Detailrow_.Poobjid, Porowlist_);
        Pkg_a.Set_Item_Value('ORDER_NO', Detailrow_.Order_No, Porowlist_);
        Pkg_a.Set_Item_Value('LINE_NO', Detailrow_.Line_No, Porowlist_);
        Pkg_a.Set_Item_Value('RELEASE_NO', Detailrow_.Rel_No, Porowlist_);
        Pkg_a.Set_Item_Value('CANCEL_REASON',
                             Detailrow_.Reason,
                             Porowlist_);
        Bl_Po_Line_Part_Api.Set_Cancel_Reason(Porowlist_,
                                              User_Id_,
                                              A311_Key_);
      
      End If;
      If Detailrow_.Modify_Type = 'I' Then
        Porowlist_ := '';
        Pkg_a.Set_Item_Value('ORDER_NO', Detailrow_.Order_No, Porowlist_);
        Pkg_a.Set_Item_Value('PART_NO', Detailrow_.Part_No, Porowlist_);
        Pkg_a.Set_Item_Value('DESCRIPTION',
                             Detailrow_.Description,
                             Porowlist_);
        Pkg_a.Set_Item_Value('BUY_QTY_DUE',
                             Detailrow_.Qty_Delivedf,
                             Porowlist_);
      
        Ponew__(Porowlist_, User_Id_, A311_Key_, Detailrow_.Objid);
        If_New := '1';
      End If;
      Fetch Cur_
        Into Detailrow_;
    End Loop;
    Close Cur_;
    --下达客户订单
    A311_.A311_Id     := 'Blbill_Vary_Api.Poapprove__';
    A311_.Enter_User  := User_Id_;
    A311_.A014_Id     := 'A014_ID=Poapprove__';
    A311_.Table_Id    := 'BL_BILL_VARY_V';
    A311_.Table_Objid := Rowlist_;
    Pkg_a.Beginlog(A311_);
    If If_New = '1' Then
      --有新增 就发送变更
      Pkg_a.Setnextdo(A311_Key_,
                      '变更采购订单-' || Row_.Source_No,
                      User_Id_,
                      'Purchase_Order_Transfer_Api.Send_Order_Change(''' ||
                      Row_.Source_No || ''',''MHS'')',
                      1 / 60 / 24);
      p_A311_Key_ := A311_Key_;
      --Purchase_Order_Transfer_Api.Send_Order_Change(row_.source_no, 'MHS');
      Pkg_a.Setnextdo(A311_.A311_Key,
                      '变更发送-' || Row_.Source_No,
                      User_Id_,
                      'BL_Purchase_Order_Transfer_API.Send_Purchase_Order_nextorder(''' ||
                      Row_.Source_No || ''',''' || User_Id_ || ''',''' ||
                      A311_Key_ || ''',''' || Rowlist_ || ''')',
                      4 / 60 / 24,
                      p_A311_Key_);
      --产生新的变更
      p_A311_Key_ := A311_.A311_Key;
      Pkg_a.Beginlog(A311_);
      Pkg_a.Setnextdo(A311_.A311_Key,
                      '采购订单变更引起交货计划变更' || Row_.Modify_Id,
                      User_Id_,
                      'Blbill_Vary_Api.PoSetNext(''' || Rowlist_ || ''',''' ||
                      User_Id_ || ''',''' || A311_.A311_Key || ''')',
                      (6 + Setnext_Time) / 60 / 24,
                      p_A311_Key_);
    
    Else
      --产生新的变更
      Pkg_a.Setnextdo(A311_Key_,
                      '变更发送-' || Row_.Source_No,
                      User_Id_,
                      'BL_Purchase_Order_Transfer_API.Send_Purchase_Order_nextorder(''' ||
                      Row_.Source_No || ''',''' || User_Id_ || ''',''' ||
                      A311_Key_ || ''',''' || Rowlist_ || ''')',
                      2 / 60 / 24);
    
      Pkg_a.Setnextdo(A311_.A311_Key,
                      '采购订单变更引起交货计划变更' || Row_.Modify_Id,
                      User_Id_,
                      'Blbill_Vary_Api.PoSetNext(''' || Rowlist_ || ''',''' ||
                      User_Id_ || ''',''' || A311_.A311_Key || ''')',
                      (4 + Setnext_Time) / 60 / 24,
                      A311_Key_);
    End If;
    Update Bl_Bill_Vary t --更新主档 状态
       Set t.Data_Lock = '1', t.Lock_User = User_Id_
     Where Modify_Id = Row_.Modify_Id;
    /*    SELECT t.Table_Id
      INTO Table_Id_
      FROM Bl_Bill_Vary_Type_Id t
     WHERE t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '采购订单变更申请' || '[' || Row_.Modify_Id || ']' || '确认成功');*/
  
  End;
  /*
  采购订单变更否决
  Rowlist_  Bl_Bill_Vary 的rowid 
  */

  Procedure Poreleaseclose__(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
    Objid_    Varchar2(100);
  Begin
    Releaseclose__(Rowlist_, User_Id_, A311_Key_, Objid_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '采购订单变更申请' || '[' || Row_.Modify_Id || ']' || '否决成功');
  
    Return;
  End;

  /*
  采购订单变更作废
  Rowlist_  Bl_Bill_Vary 的rowid 
  */

  Procedure Pocancel__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Cancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '采购订单变更申请' || '[' || Row_.Modify_Id || ']' || '作废成功');
  End;
  --备货单变更N 提交
  Procedure Pkndprelease__(Rowlist_  Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2) Is
    Row_  Bl_Bill_Vary%Rowtype;
    Irow_ Bl_Bill_Vary%Rowtype;
    --  detrow_    Bl_v_Customer_Order_Chgp_Det_3%ROWTYPE; --临时record    
    Table_Id_   Varchar2(100);
    Cur_        t_Cursor;
    Cur1_       t_Cursor;
    Source_No_  Varchar2(50);
    Detailrow_  Bl_v_Customer_Order_Chgp_Det_6%Rowtype;
    Objid_      Varchar2(100);
    Temp_Row_   Bl_Temp%Rowtype;
    Idetailrow_ Bl_Bill_Vary_Detail%Rowtype;
    --check_Temp_Row_ Bl_Temp%ROWTYPE;
    Rowobjid_ Varchar2(100);
    Temp_Key_ Number;
    Bl_Pldtl_ Bl_Pldtl%Rowtype;
  Begin
    --把备货当变更转换新的工厂的订单变更  
    Open Cur_ For
      Select t.* From Bl_Bill_Vary t Where t.Rowid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
  
    Update Bl_Bill_Vary t
       Set State        = '2',
           Date_Puted   = Sysdate,
           Date_Comform = Sysdate,
           Modi_Date    = Sysdate,
           Modi_User    = User_Id_
     Where Rowid = Rowlist_;
    --提交的时候 校验数量是否 能够 和订单的数量 一致 
    Select s_Bl_Temp.Nextval Into Temp_Key_ From Dual;
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order_Chgp_Det_6 t
       Where t.Modify_Id = Row_.Modify_Id
       Order By t.Order_No, t.Supplier;
    Fetch Cur_
      Into Detailrow_;
    Source_No_ := '-';
    Loop
      Exit When Cur_%Notfound;
      Temp_Row_.Tempkey := Temp_Key_;
      Temp_Row_.Rowkey  := Detailrow_.Order_No || '-' || Detailrow_.Line_No || '-' ||
                           Detailrow_.Rel_No || '-' ||
                           Detailrow_.Line_Item_No;
    
      Open Cur1_ For
        Select t.*
          From Bl_Temp t
         Where t.Tempkey = Temp_Row_.Tempkey
           And t.Rowkey = Temp_Row_.Rowkey;
      Fetch Cur1_
        Into Temp_Row_;
      If Cur1_%Notfound Then
        Temp_Row_.Tempkey      := Temp_Key_;
        Temp_Row_.Rowkey       := Detailrow_.Order_No || '-' ||
                                  Detailrow_.Line_No || '-' ||
                                  Detailrow_.Rel_No || '-' ||
                                  Detailrow_.Line_Item_No;
        Temp_Row_.Order_No     := Detailrow_.Order_No;
        Temp_Row_.Line_No      := Detailrow_.Line_No;
        Temp_Row_.Rel_No       := Detailrow_.Rel_No;
        Temp_Row_.Line_Item_No := Detailrow_.Line_Item_No;
        Pkg_a.Set_Item_Value('F_ORDER_NO',
                             Detailrow_.f_Order_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('CATALOG_NO',
                             Detailrow_.Catalog_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('F_LINE_NO',
                             Detailrow_.f_Line_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('F_REL_NO',
                             Detailrow_.f_Rel_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('F_LINE_ITEM_NO',
                             Detailrow_.f_Line_Item_No,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('BUY_QTY_DUE',
                             Detailrow_.Buy_Qty_Due,
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('QTY_PLAN',
                             Bl_Customer_Order_Line_Api.Get_Plan_Qty__(Detailrow_.f_Order_No,
                                                                       Detailrow_.f_Line_No,
                                                                       Detailrow_.Rel_No,
                                                                       Detailrow_.Line_Item_No),
                             Temp_Row_.Rowlist);
        Pkg_a.Set_Item_Value('QTY_CHANGE', '0', Temp_Row_.Rowlist);
      
        Insert Into Bl_Temp_Tab
          (Tempkey,
           Rowkey,
           Order_No,
           Line_No,
           Rel_No,
           Line_Item_No,
           Rowlist)
        Values
          (Temp_Row_.Tempkey,
           Temp_Row_.Rowkey,
           Temp_Row_.Order_No,
           Temp_Row_.Line_No,
           Temp_Row_.Rel_No,
           Temp_Row_.Line_Item_No,
           Temp_Row_.Rowlist) Return Rowid Into Temp_Row_.Objid;
      End If;
      Close Cur1_;
    
      Pkg_a.Set_Item_Value('QTY_CHANGE',
                           Pkg_a.Get_Item_Value('QTY_CHANGE',
                                                Temp_Row_.Rowlist) +
                           Detailrow_.Qty_Change,
                           Temp_Row_.Rowlist);
    
      Update Bl_Temp_Tab
         Set Rowlist = Temp_Row_.Rowlist
       Where Rowid = Temp_Row_.Objid;
    
      If Source_No_ <> Detailrow_.Order_No || '-' || Detailrow_.Supplier Then
        --生成新单号
        Irow_ := Row_;
        Bl_Customer_Order_Api.Getseqno('2' || To_Char(Sysdate, 'YYMMDD'),
                                       User_Id_,
                                       3,
                                       Irow_.Modify_Id);
        Insert Into Bl_Bill_Vary
          (Modify_Id)
        Values
          (Irow_.Modify_Id)
        Returning Rowid Into Objid_;
        Irow_.Type_Id        := '2';
        Irow_.Source_No      := Detailrow_.Order_No || '-' ||
                                Detailrow_.Supplier;
        Irow_.Date_Puted     := Row_.Date_Puted;
        Irow_.Smodify_Id     := Detailrow_.Modify_Id;
        Irow_.Enter_Date     := Sysdate;
        Irow_.Enter_User     := User_Id_;
        Irow_.Customer_Ref   := Row_.Customer_Ref;
        Irow_.State          := '0';
        Irow_.Remark         := Detailrow_.Remark;
        Irow_.Base_Modify_Id := Detailrow_.Modify_Id;
        Update Bl_Bill_Vary Set Row = Irow_ Where Rowid = Objid_;
        Source_No_ := Detailrow_.Order_No || '-' || Detailrow_.Supplier;
      End If;
      --获取备货单 的订单行的状态
      Bl_Pldtl_.Flag := Bl_Customer_Order_Line_Api.Get_Picklist_Data__(Row_.Source_No,
                                                                       Detailrow_.Order_No,
                                                                       Detailrow_.Line_No,
                                                                       Detailrow_.Rel_No,
                                                                       Detailrow_.Line_Item_No,
                                                                       'FLAG');
      Bl_Pldtl_.Flag := Nvl(Bl_Pldtl_.Flag, '0');
      If Bl_Pldtl_.Flag <> '0' And Bl_Pldtl_.Flag <> '1' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '备货单号' || Row_.Source_No || '订单行' ||
                                Detailrow_.Line_Key || '状态不是0或1，不能变更！');
      
      End If;
    
      Idetailrow_.Modify_Id          := Irow_.Modify_Id;
      Idetailrow_.Modify_Lineno      := Detailrow_.Modify_Lineno;
      Idetailrow_.Base_No            := Detailrow_.Modify_Id;
      Idetailrow_.Base_Line          := Detailrow_.Modify_Lineno;
      Idetailrow_.Order_No           := Detailrow_.Order_No;
      Idetailrow_.Line_No            := Detailrow_.Line_No;
      Idetailrow_.Rel_No             := Detailrow_.Rel_No;
      Idetailrow_.Line_Item_No       := Detailrow_.Line_Item_No;
      Idetailrow_.Column_No          := Detailrow_.Column_No;
      Idetailrow_.Picklistno         := Row_.Source_No;
      Idetailrow_.Qty_Delived        := Detailrow_.Qty_Delived;
      Idetailrow_.Qty_Delivedf       := Detailrow_.Qty_Delivedf;
      Idetailrow_.Delived_Date       := Detailrow_.Delived_Date;
      Idetailrow_.Delived_Datef      := Detailrow_.Delived_Datef;
      Idetailrow_.Version            := Detailrow_.Version;
      Idetailrow_.State              := Irow_.State;
      Idetailrow_.Reason             := Detailrow_.Reason;
      Idetailrow_.Reason_Description := Detailrow_.Reason_Description;
      Idetailrow_.Remark             := Detailrow_.Remark;
      Idetailrow_.Enter_User         := User_Id_;
      Idetailrow_.Enter_Date         := Sysdate;
    
      Idetailrow_.New_Data    := Detailrow_.New_Data;
      Idetailrow_.Line_Key    := Detailrow_.Plan_Line_Key;
      Idetailrow_.Modify_Type := 'PK'; --备货单引起的交货计划的变更    
      Insert Into Bl_Bill_Vary_Detail
        (Modify_Id, Modify_Lineno)
      Values
        (Idetailrow_.Modify_Id, Idetailrow_.Modify_Lineno)
      Returning Rowid Into Rowobjid_;
    
      Update Bl_Bill_Vary_Detail
         Set Row = Idetailrow_
       Where Rowid = Rowobjid_;
    
      Update Bl_Bill_Vary_Detail t
         Set State = '2'
       Where Rowid = Detailrow_.Objid;
    
      Fetch Cur_
        Into Detailrow_;
    End Loop;
  
    Close Cur_;
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '备货单变更申请' || '[' || Row_.Modify_Id || ']' || '提交成功');
  
  End;
  --备货单变更N 作废
  Procedure Pkndpcancel__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Cancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '备货单变更申请' || '[' || Row_.Modify_Id || ']' || '作废成功');
  End;

  /*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
      pkg_demo
  */

  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2) Is
    Row_ Bl_v_Customer_Order_Chgp_App_4%Rowtype;
    --Colinerow_ Bl_v_Customer_Order_Line%ROWTYPE;
    --Corow_     Customer_Order_Line%ROWTYPE;
    Attr_Out    Varchar2(30000);
    Row_Reason_ Bl_v_Changereason%Rowtype;
    --Coobjid_   VARCHAR2(200);
    Cur_ t_Cursor;
  Begin
    If Column_Id_ = 'REASON' Then
      Row_.Reason := Pkg_a.Get_Item_Value('REASON', Rowlist_);
      Open Cur_ For
        Select t.*
          From Bl_v_Changereason t
         Where t.Reason_No = Row_.Reason;
      Fetch Cur_
        Into Row_Reason_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, Row_.Reason || '在表中不存在');
        Return;
      End If;
      Close Cur_;
      Pkg_a.Set_Item_Value('REASON_DESCRIPTION',
                           Row_Reason_.Reason_Description,
                           Attr_Out);
    End If;
    Outrowlist_ := Attr_Out;
  End;
  /*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
      返回: 1 可用
      0 不可用
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    Row_   Bl_Bill_Vary_Detail%Rowtype;
    Objid_ Varchar(100);
  Begin
    Row_.State       := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    Objid_           := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Row_.Modify_Type := Pkg_a.Get_Item_Value('MODIFY_TYPE', Rowlist_);
  
    If Column_Id_ = 'REMARK' Then
      Return '1';
    End If;
    If Nvl(Row_.State, '0') = '0' Then
      If Column_Id_ = 'REASON' Or Column_Id_ = 'DELIVED_DATEF' Or
         Column_Id_ = 'IF_AGREEMENT' Then
        Return '1';
      End If;
    End If;
    If Nvl(Objid_, 'NULL') = 'NULL' Then
      Return '1';
    End If;
    Return '0';
  End;
  Function Checkbutton__(Dotype_   In Varchar2,
                         Main_Key_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2 Is
    --Cur_ t_Cursor;
  
  Begin
    Return '1';
  End;
  Procedure Check_Bl_Picklist(Picklistno_  In Varchar2,
                              Bl_Picklist_ Out Bl_Picklist%Rowtype) Is
    Cur_ t_Cursor;
  Begin
    Open Cur_ For
      Select t.* From Bl_Picklist t Where t.Picklistno = Picklistno_;
    Fetch Cur_
      Into Bl_Picklist_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '错误的备货单号' || Picklistno_);
      Return;
    End If;
    Close Cur_;
    If Bl_Picklist_.Flag <> '0' And Bl_Picklist_.Flag <> '1' Then
    
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '备货单号' || Picklistno_ || '状态只能为0或1');
    
    End If;
  
  End;
  --订单价格变更 提交
  Procedure Pricerelease__(Rowlist_ Varchar2,
                           --视图的objid
                           User_Id_ Varchar2,
                           --用户id
                           A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
    Cur_      t_Cursor;
  Begin
    Release__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '订单价格变更申请' || '[' || Row_.Modify_Id || ']' || '提交成功');
  
  End;

  ---订单价格变更 取消提交
  Procedure Pricereleasecancel__(Rowlist_ Varchar2,
                                 --视图的objid
                                 User_Id_ Varchar2,
                                 --用户id
                                 A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Releasecancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
  
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '订单价格变更申请' || '[' || Row_.Modify_Id || ']' || '取消提交成功');
  End;
  --订单价格变更 作废
  Procedure Pricecancel__(Rowlist_ Varchar2,
                          --视图的objid
                          User_Id_ Varchar2,
                          --用户id
                          A311_Key_ Varchar2) Is
    Row_      Bl_Bill_Vary%Rowtype;
    Table_Id_ Varchar2(100);
  Begin
    Cancel__(Rowlist_, User_Id_, A311_Key_, Row_);
    Select t.Table_Id
      Into Table_Id_
      From Bl_Bill_Vary_Type_Id t
     Where t.Id = Row_.Type_Id;
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '订单价格变更申请' || '[' || Row_.Modify_Id || ']' || '作废成功');
  End;
  -- 订单 价格变更 确认        
  Procedure Priceapprove__(Rowlist_ Varchar2,
                           --视图的objid
                           User_Id_ Varchar2,
                           --用户id
                           A311_Key_ Varchar2) Is
    Row_          Bl_Bill_Vary%Rowtype;
    Pricerow_     Bl_v_Customer_Order_Chg_Price%Rowtype;
    Corow_        Bl_v_Customer_Order%Rowtype;
    Corowline_    Bl_v_Customer_Order_Line%Rowtype;
    Linerow_      Bl_v_Customer_Order_Chg_Pd%Rowtype;
    Row_b         Agreement_Sales_Part_Deal%Rowtype;
    Attr_         Varchar2(4000);
    Attr__        Varchar2(4000);
    Table_Id_     Varchar2(100);
    Objid_        Varchar2(4000);
    Objid__       Varchar2(4000);
    Agreement_Id_ Varchar2(4000);
    Action_       Varchar2(10);
    Info_         Varchar2(4000);
    Objversion_   Varchar2(4000);
    Cur_          t_Cursor;
    Cur_b         t_Cursor;
  Begin
  
    Approve__(Rowlist_, User_Id_, A311_Key_, Row_);
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order_Chg_Price t
       Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Pricerow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    --取价格协议号
    Open Cur_ For
      Select T2.Agreement_Id
        From Bl_v_Customer_Agreement T2
       Where T2.Customer_No = Pricerow_.Customer_No
         And T2.Contract = Pricerow_.Contract
         And T2.Currency_Code = Pricerow_.Currency_Code;
    Fetch Cur_
      Into Agreement_Id_;
    Close Cur_;
    --明细数据
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order_Chg_Pd t
       Where t.Modify_Id = Pricerow_.Modify_Id;
    Fetch Cur_
      Into Linerow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '明细无数据');
      Return;
    End If;
    Loop
      Exit When Cur_ %Notfound;
      Attr_ := '';
      If Pricerow_.Price_With_Tax = 'FALSE' Then
        Pkg_a.Set_Item_Value('SALE_UNIT_PRICE',
                             Linerow_.Qty_Delivedf,
                             Attr_);
      Else
        Pkg_a.Set_Item_Value('SALE_UNIT_PRICE_WITH_TAX',
                             Linerow_.Qty_Delivedf,
                             Attr_);
      End If;
      Pkg_a.Set_Item_Value('DOACTION', 'M', Attr_);
      Select t.Objid
        Into Objid_
        From Bl_v_Customer_Order_Line t
       Where t.Order_No = Linerow_.Order_No
         And t.Line_No = Linerow_.Line_No
         And t.Rel_No = Linerow_.Rel_No
         And t.Line_Item_No = Linerow_.Line_Item_No;
      Pkg_a.Set_Item_Value('OBJID', Objid_, Attr_);
      Bl_Customer_Order_Line_Api.Modify__(Attr_, User_Id_, A311_Key_);
    
      ---修改价格协议
      If Pricerow_.If_Agreement = '1' Then
        Open Cur_b For
          Select * 　from Agreement_Sales_Part_Deal t Where t.Contract = Pricerow_.Contract And t.Agreement_Id = Agreement_Id_ And t.Catalog_No = Linerow_.Catalog_No;
        Fetch Cur_b
          Into Row_b;
      
        If Cur_b%Notfound Then
          Attr_ := '';
          --AGREEMENT_ID24CONTRACT20CATALOG_NO110102062701DEAL_PRICE1DISCOUNT_TYPEGM10DISCOUNT5--
          Client_Sys.Add_To_Attr('CONTRACT', Pricerow_.Contract, Attr__);
          Client_Sys.Add_To_Attr('CATALOG_NO', Linerow_.Catalog_No, Attr__);
          Client_Sys.Add_To_Attr('AGREEMENT_ID', Agreement_Id_, Attr__);
          Client_Sys.Add_To_Attr('DEAL_PRICE',
                                 Linerow_.Qty_Delivedf,
                                 Attr__);
          /*        if ROW_A.DISCOUNT IS NOT NULL THEN
            CLIENT_SYS.Add_To_Attr('DISCOUNT', LINEROW_.DISCOUNT, attr_);
          END IF;*/
          /* CLIENT_SYS.Add_To_Attr('DISCOUNT', LINEROW_.DISCOUNT, attr_);*/
          /*        IF ROW_A.DISCOUNT_TYPE IS NOT NULL THEN
            CLIENT_SYS.Add_To_Attr('DISCOUNT_TYPE',
                                   ROW_A.DISCOUNT_TYPE,
                                   attr_);
          END IF;*/
          Action_     := 'DO';
          Info_       := '';
          Objid__     := '';
          Objversion_ := '';
          Agreement_Sales_Part_Deal_Api.New__(Info_,
                                              Objid__,
                                              Objversion_,
                                              Attr__,
                                              Action_);
        Else
        
          --DISCOUNT_TYPEGM16DISCOUNT3--
          Objid_      := Row_b.Objid;
          Action_     := 'DO';
          Objversion_ := Row_b.Objversion; --ltrim(lpad(to_char(sysdate, 'YYYYMMDDHH24MISS'),
          --2000));
          Client_Sys.Add_To_Attr('DEAL_PRICE',
                                 Linerow_.Qty_Delivedf,
                                 Attr__);
          /*        CLIENT_SYS.Add_To_Attr('DISCOUNT_TYPE', ROW_A.DISCOUNT_TYPE, attr_);
          CLIENT_SYS.Add_To_Attr('DISCOUNT', ROW_A.DISCOUNT, attr_);*/
          Agreement_Sales_Part_Deal_Api.Modify__(Info_,
                                                 Objid_,
                                                 Objversion_,
                                                 Attr__,
                                                 Action_);
        End If;
      
        Close Cur_b;
      End If;
      Fetch Cur_
        Into Linerow_;
    End Loop;
    Close Cur_;
  
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '订单价格变更申请' || '[' || Row_.Modify_Id || ']' || '确认成功');
  End;
  --检测备货单是否可以变更
  Function Check_Pick_Vary(Picklistno_ In Varchar2) Return Number Is
    Cur_ t_Cursor;
    Res_ Number;
  Begin
    Open Cur_ For
      Select 1
        From Bl_Pldtl Bl
       Inner Join Customer_Order_Line Co
          On Co.Order_No = Bl.Order_No
         And Co.Line_No = Bl.Line_No
         And Co.Rel_No = Bl.Rel_No
         And Co.Line_Item_No = Bl.Line_Item_No
         And Co.Supply_Code In
             (Select Id From Bl_v_Co_Supply_Code T1 Where T1.Autoplan = '0')
       Where Bl.Picklistno = Picklistno_;
    Fetch Cur_
      Into Res_;
  
    Close Cur_;
  
    Return Nvl(Res_, 0);
  End;
  --获取变更行下级变更的状态
  Function Get_Vart_Line_State(Modify_Id_ In Varchar2,
                               
                               Order_No_     In Varchar2,
                               Line_No_      In Varchar2,
                               Rel_No_       In Varchar2,
                               Line_Item_No_ In Number,
                               State_        In Varchar2,
                               Modify_Line_  In Number Default 0)
    Return Varchar2 Is
    Cur_    t_Cursor;
    Result_ Varchar2(20);
  Begin
    If State_ != '2' Then
      Return State_;
    End If;
    Open Cur_ For
      Select t.State
        From Bl_Bill_Vary_Detail t
       Where t.Base_No = Modify_Id_
         And t.Base_Line = Modify_Line_;
    /*    Open Cur_ For
    Select t.State
      From Bl_Bill_Vary t
     Inner Join Bl_Bill_Vary_Detail T1
        On t.Modify_Id = T1.Modify_Id
       And T1.Order_No = Order_No_
       And T1.Line_No = Line_No_
       And T1.Rel_No = Rel_No_
       And T1.Line_Item_No = Line_Item_No_
     Where t.Smodify_Id = Modify_Id_;*/
    Fetch Cur_
      Into Result_;
    If Cur_%Notfound Then
      Close Cur_;
      Return '7';
    End If;
    Close Cur_;
    If Result_ = '0' Then
      Return '8'; --未处理     
    End If;
    If Result_ = '1' Then
      Return '9';
    
    End If;
  
    If Result_ = '2' Or Result_ = '3' Then
      Return '10'; --完成
    
    End If;
    If Result_ = '4' Or Result_ = '5' Then
      Return '11'; --取消    
    End If;
  
    Return '11'; --处理失败
  
  End;

  --获取变更的状态
  Function Get_Vary_State(Modify_Id_  In Varchar2,
                          State_      In Varchar2,
                          Smodify_Id_ In Varchar2) Return Varchar2 Is
    Cur_       t_Cursor;
    Bill_Vary_ Bl_Bill_Vary%Rowtype;
    Result_    Varchar2(20);
  Begin
    /*
     0 计划
     1 下达
     2 确认
     3 关闭
     4 取消
     5 取消     
    */
    If Length(Nvl(Smodify_Id_, '-')) > 2 Then
      Return State_;
    End If;
    If State_ = '2' Then
      --检测有没有完成的变更    
      Open Cur_ For
        Select t.*
          From Bl_Bill_Vary t
         Where t.Smodify_Id = Modify_Id_
         Order By t.State Asc;
      Fetch Cur_
        Into Bill_Vary_;
      If Cur_%Notfound Then
        Return State_; --没有下级变更
      End If;
      Loop
        Exit When Cur_%Notfound;
        If Instr(Nvl(Result_, '-'), Bill_Vary_.State) <= 0 Then
          Result_ := Nvl(Result_, '') || Bill_Vary_.State;
        End If;
      
        Fetch Cur_
          Into Bill_Vary_;
      End Loop;
      Close Cur_;
      If Length(Result_) = 1 Then
        If Result_ = '0' Then
          Return '8'; --未处理 
        End If;
        If Result_ = '1' Then
          Return '9'; --已提交处理未确认
        End If;
        If Result_ = '2' Or Result_ = '3' Then
          Return '10'; --完成
        End If;
        If Result_ = '4' Or Result_ = '5' Then
          Return '11'; --处理失败 下级变更被取消
        End If;
      End If;
      If Result_ = '23' Then
        Return '10'; --完成
      End If;
      If Instr(Result_, '2') > 0 Or Instr(Result_, '3') > 0 Then
        Return '12'; --部分处理        
      End If;
      If Result_ = '45' Then
        Return '11'; --处理失败 下级变更被取消
      End If;
    
      Return '12'; --部分处理 
      --Select id,name from BL_V_STATE where  type='CHG' and  lang=pkg_attr.userlanguage('[USER_ID]')
      Return Nvl(Result_, State_);
    Else
      Return State_;
    End If;
    --确认状态要计算下级变更的状态
  
    Return State_;
  End;

End Blbill_Vary_Api;
/
