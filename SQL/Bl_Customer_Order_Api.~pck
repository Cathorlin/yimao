Create Or Replace Package Bl_Customer_Order_Api Is

  --新增初始化
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);
  --保存
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  --订单确认
  Procedure Appvoe_Order__(Rowlist_  Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2);

  Procedure Chage_Modify__(Rowlist_  Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2);
  Procedure Chage_New__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2);
  Procedure Chage_Release__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2);
  Procedure Delivery_Plan_Modify__(Rowlist_  Varchar2,
                                   User_Id_  Varchar2,
                                   A311_Key_ Varchar2);
  Procedure Delivery_Plan_New__(Rowlist_  Varchar2,
                                User_Id_  Varchar2,
                                A311_Key_ Varchar2);
  Procedure Delivery_Plan_Release__(Rowlist_  Varchar2,
                                    User_Id_  Varchar2,
                                    A311_Key_ Varchar2);
  --订单取消
  Procedure Set_Cancel_Reason(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);
  Procedure Set_Chage_Cancel(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2);

  Procedure Set_Delivery_Plan_Cancel(Rowlist_  Varchar2,
                                     User_Id_  Varchar2,
                                     A311_Key_ Varchar2);
  --获取 采购订单/采购申请 的连接url
  Function Getpurchase_Orderurl(Objid_ In Varchar2) Return Varchar2;
  --检测下域的 订单是否已经生成
  Procedure Checknextexist(Order_Type_ In Varchar2,
                           Order_No_   In Varchar2,
                           Contract_   In Varchar2,
                           User_Id_    In Varchar2,
                           Order_List_ In Out Varchar2);
  --自定义表的修改
  Procedure Usermodify__(Row_     In Bl_Customer_Order%Rowtype,
                         User_Id_ In Varchar2);
  --自动生成交货计划 
  Procedure Delivery_Plan_Atuo__(Rowlist_  Varchar2,
                                 User_Id_  Varchar2,
                                 A311_Key_ Varchar2);
  --自动生成备货单
  Procedure Delivery_Picklist_Atuo__(Rowlist_  Varchar2,
                                     User_Id_  Varchar2,
                                     A311_Key_ Varchar2);
  --获取编码
  Procedure Getseqno(Type_    In Varchar2,
                     User_Id_ In Varchar2,
                     Seqw_    In Number,
                     Seq_     Out Varchar2);
  --当数据发生变化的时候 修改列信息
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         --主档的rowlist
                         Rowlist_ Varchar2,
                         --当前行rowlist 
                         User_Id_ Varchar2,
                         --操作的用户
                         Outrowlist_ Out Varchar2
                         --输出的rowlist
                         );
  --获取 最外层采购订单号
  Function Get_Par_Po_Order(Order_No_ In Varchar2) Return Varchar2;

  --金额
  Function Get_Customer_Amount(Order_No_ In Varchar2, Type_ In Varchar2)
    Return Number;
  --费用
  Function Get_Chare_Amount(Order_No_ In Varchar2, Type_ In Varchar2)
    Return Number;
  --判断当前列是否可编辑--
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2;
  ----检查编辑 修改
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2;

  --根据列名 和订单号码获取 BL_v_customer_order 的数据
  Function Get_Column_Data(Column_Id_ In Varchar2, Order_No_ In Varchar2)
    Return Varchar2;
  --获取外域订单号
  Function Get_20_Order(Order_No_ In Varchar2) Return Varchar2;

  --自动生成交货计划
  Procedure Delivery_Plan_(Order_No_     Varchar2,
                           User_Id_      Varchar2,
                           A311_Key_     In Number,
                           Modify_Objid_ In Varchar2 Default '0');
  --纯费用订单开发票  
  Procedure Start_Create_Invoice__(Rowid_    Varchar2,
                                   User_Id_  Varchar2,
                                   A311_Key_ In Number);
  --获取录入人
  Function Get_Enter_User(Blorder_No_ In Varchar2) Return Varchar2;
  --修改备注
  Procedure Modify_Note_Text_(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);
End Bl_Customer_Order_Api;
/
Create Or Replace Package Body Bl_Customer_Order_Api Is

  Type t_Cursor Is Ref Cursor;
  --检测列的可编辑性
  /* modify fjp 2013-01-31 增加纯费用订单开发票
     modify wtl 2013-02-19 修改确认的时候更新 if_first的值
  
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    Row_      Bl_v_Customer_Order%Rowtype;
    Company_  Varchar2(4000);
    Customer_ Varchar2(4000);
  Begin
    If Doaction_ = 'I' Then
      Return '1';
    End If;
    If Doaction_ = 'M' Then
    
      Row_.Objid       := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
      Row_.State       := Pkg_a.Get_Item_Value('STATE', Rowlist_);
      Row_.Contract    := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Company_         := Ifsapp.Site_Api.Get_Company(Row_.Contract);
      Row_.Customer_No := Pkg_a.Get_Item_Value('CUSTOMER_NO', Rowlist_);
      Customer_        := Identity_Invoice_Info_Api.Get_Identity_Type(Company_,
                                                                      Row_.Customer_No,
                                                                      'Customer');
      If Customer_ = 'INTERN' Then
        Return '0';
      End If;
      If Row_.State <> 'Invoiced/Closed' And Row_.State <> 'Cancelled' Then
        If Column_Id_ = 'CUSTOMER_NO' Or Column_Id_ = 'ORDER_NO' Or
           Column_Id_ = 'CONTRACT' Or Column_Id_ = 'ORDER_ID' Or
           Column_Id_ = 'DATE_ENTERED' Or Column_Id_ = 'PRICE_WITH_TAX' Or
           Column_Id_ = 'BLORDER_ID' Or Column_Id_ = 'CURRENCY_CODE' Or
           Column_Id_ = 'BLD001_ITEM' Then
          Return '0';
        End If;
        /*                 Column_Id_ = 'CUSTOMER_NO' Or  Length(Row_.Customer_No) > 2 And
        COMPANY_  := IFSAPP.SITE_API.GET_COMPANY(ROW_.CONTRACT);
        CUSTOMER_ := identity_invoice_info_api.get_identity_type(COMPANY_,
                                                                 ROW_.CONTRACT,
                                                                 'Customer');*/
      
        If Length(Row_.Customer_No) > 2 And Column_Id_ = 'LABEL_NOTE' Then
          Return '0';
        
        End If;
        /*        IF Column_Id_ = 'CUSTOMER_NO' THEN
          COMPANY_  := IFSAPP.SITE_API.GET_COMPANY(ROW_.CONTRACT);
          CUSTOMER_ := identity_invoice_info_api.get_identity_type(COMPANY_,
                                                                   Row_.Customer_No,
                                                                   'Customer');
          IF CUSTOMER_ = 'INTERN' THEN
            RETURN '0';
          END IF;
        END IF;*/
        If Row_.State = 'Released' Then
          If Column_Id_ = 'WANTED_DELIVERY_DATE' Or
             Column_Id_ = 'LABEL_NOTE' Then
            Return '0';
          End If;
        End If;
      
        Return '1';
      Else
        Return '0';
      End If;
    
    End If;
  
    Return '1';
  End;

  --客户订单新增初始化 
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
    Attr_       Varchar2(4000);
    Info_       Varchar2(4000);
    Objid_      Varchar2(4000);
    Objversion_ Varchar2(4000);
    Action_     Varchar2(100);
    Attr_Out    Varchar2(4000);
    Row_        Bl_v_Customer_Order%Rowtype;
    Requesturl_ Varchar2(4000);
    Option_     Varchar2(200);
  Begin
  
    Action_ := 'PREPARE';
    Attr_   := Pkg_a.Get_Attr_By_Bm(Rowlist_);
    Customer_Order_Api.New__(Info_, Objid_, Objversion_, Attr_, Action_);
    Attr_Out := Pkg_a.Get_Attr_By_Ifs(Attr_);
    --获取用户默认的域
    Row_.Contract := Pkg_Attr.Get_Default_Contract(User_Id_);
    If (Nvl(Row_.Contract, '0') <> '0') Then
      Pkg_a.Set_Item_Value('CONTRACT', Row_.Contract, Attr_Out);
    End If;
    If Nvl(Row_.Picklistno, 'NULL') <> 'NULL' Then
      Pkg_a.Set_Item_Value('PICKLISTNO', Row_.Picklistno, Attr_Out);
    End If;
    ---设置默认订单类型为 正常
    Pkg_a.Set_Item_Value('BLORDER_ID', '1', Attr_Out);
  
    Pkg_a.Set_Item_Value('STATE', 'Planned', Attr_Out);
    Pkg_a.Setresult(A311_Key_, Attr_Out);
    Return;
  End;

  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         --main 
                         Rowlist_ Varchar2,
                         --行rowlist 
                         User_Id_    Varchar2,
                         Outrowlist_ Out Varchar2
                         --输出
                         ) Is
    Attr_       Varchar2(4000);
    Info_       Varchar2(4000);
    Objid_      Varchar2(4000);
    Objversion_ Varchar2(4000);
    Action_     Varchar2(100);
    Attr_Out    Varchar2(4000);
    Row_        Bl_v_Customer_Order%Rowtype;
    Arow_       Customer_Agreement_Lov%Rowtype;
    Lrow_       Bl_v_Customerlocation%Rowtype;
    If_Default  Varchar2(1);
    Cur_        t_Cursor;
  Begin
    If_Default := '0';
    If Column_Id_ = 'CUSTOMER_NO' Or Column_Id_ = 'CONTRACT' Then
      -- 域 或 客户编码发生变化的 时候 调用ifs的初始化包  获取ifs的数据 把对应的数据赋值到界面中
      Row_.Customer_No := Pkg_a.Get_Item_Value('CUSTOMER_NO', Rowlist_);
      Row_.Contract    := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      If Length(Row_.Contract) > 0 And Length(Row_.Customer_No) > 0 Then
        Client_Sys.Add_To_Attr('CONTRACT', Row_.Contract, Attr_);
        Client_Sys.Add_To_Attr('CUSTOMER_NO', Row_.Customer_No, Attr_);
        --检测用户 和 客户权限        
        If f_Check(User_Id_, 'CUSTOMER_NO', Row_.Customer_No) = 1 Then
          Customer_Order_Api.Get_Customer_Defaults__(Attr_);
          Attr_Out := Pkg_a.Get_Attr_By_Ifs(Attr_);
          --客户名称
        
          Select Ifsapp.Cust_Ord_Customer_Api.Get_Name(Row_.Customer_No)
            Into Row_.Customer_Name
            From Dual;
          Pkg_a.Set_Item_Value('CUSTOMER_NAME',
                               Row_.Customer_Name,
                               Attr_Out);
          --客户支付条款名称          
          Row_.Pay_Term_Id    := Client_Sys.Get_Item_Value('PAY_TERM_ID',
                                                           Attr_);
          Row_.Ship_Via_Code  := Client_Sys.Get_Item_Value('SHIP_VIA_CODE',
                                                           Attr_);
          Row_.Delivery_Terms := Client_Sys.Get_Item_Value('DELIVERY_TERMS',
                                                           Attr_);
          Row_.Salesman_Code  := Client_Sys.Get_Item_Value('SALESMAN_CODE',
                                                           Attr_);
          Row_.Language_Code  := Client_Sys.Get_Item_Value('LANGUAGE_CODE',
                                                           Attr_);
          --当客户编码长度大于 2 直接把客户编码赋值给外部客户 否则用户填写
          If Length(Row_.Customer_No) > 2 Then
            Row_.Label_Note := Row_.Customer_No;
            Pkg_a.Set_Item_Value('LABEL_NOTE', Row_.Label_Note, Attr_Out);
          End If;
        Else
          Return;
        End If;
        If_Default := '1';
      End If;
      If Column_Id_ = 'CUSTOMER_NO' Then
        Open Cur_ For
          Select t.*
            From Bl_v_Customerlocation t
           Where t.Customer_No = Row_.Customer_No
             And t.Contract = Row_.Contract;
        Fetch Cur_
          Into Lrow_;
        Close Cur_;
        Pkg_a.Set_Item_Value('BLLOCATION_NO', Lrow_.Location_No, Attr_Out);
        --   PKG_A.Set_Item_Value('WAREHOUSE', LROW_., Attr_Out);
      
      End If;
    End If;
    --支付方式的名称 
    If Column_Id_ = 'PAY_TERM_ID' Or If_Default = '1' Then
      If If_Default = '0' Then
        Row_.Contract    := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
        Row_.Pay_Term_Id := Pkg_a.Get_Item_Value('PAY_TERM_ID', Rowlist_);
      End If;
      Select Ifsapp.Payment_Term_Api.Get_Description(Row_.Contract,
                                                     Row_.Pay_Term_Id)
        Into Row_.Pay_Term_Name
        From Dual;
      Pkg_a.Set_Item_Value('PAY_TERM_NAME', Row_.Pay_Term_Name, Attr_Out);
    
    End If;
    If Column_Id_ = 'BLLOCATION_NO' Or If_Default = '1' Then
      Row_.Bllocation_No := Pkg_a.Get_Item_Value('BLLOCATION_NO', Rowlist_);
      If Nvl(Row_.Bllocation_No, '-') <> '-' Then
        Open Cur_ For
          Select t.Warehouse
          
            From Bl_v_Inventory_Location t
           Where t.Location_No = Row_.Bllocation_No;
        Fetch Cur_
          Into Row_.Warehouse;
        Close Cur_;
        Pkg_a.Set_Item_Value('WAREHOUSE', Row_.Warehouse, Attr_Out);
      End If;
    End If;
  
    If Column_Id_ = 'SHIP_VIA_CODE' Or If_Default = '1' Then
      If If_Default = '0' Then
        Row_.Language_Code := Pkg_a.Get_Item_Value('LANGUAGE_CODE',
                                                   Rowlist_);
        Row_.Ship_Via_Code := Pkg_a.Get_Item_Value('SHIP_VIA_CODE',
                                                   Rowlist_);
      End If;
      Select Ifsapp.Mpccom_Ship_Via_Desc_Api.Get_Description(Row_.Language_Code,
                                                             Row_.Ship_Via_Code)
        Into Row_.Ship_Via_Desc
        From Dual;
      Pkg_a.Set_Item_Value('SHIP_VIA_DESC', Row_.Ship_Via_Desc, Attr_Out);
    
    End If;
    If Column_Id_ = 'DELIVERY_TERMS' Or If_Default = '1' Then
      If If_Default = '0' Then
        Row_.Language_Code  := Pkg_a.Get_Item_Value('LANGUAGE_CODE',
                                                    Rowlist_);
        Row_.Delivery_Terms := Pkg_a.Get_Item_Value('DELIVERY_TERMS',
                                                    Rowlist_);
      End If;
      Select Ifsapp.Order_Delivery_Term_Desc_Api.Get_Description(Row_.Language_Code,
                                                                 Row_.Delivery_Terms)
        Into Row_.Delivery_Terms_Desc
        From Dual;
      Pkg_a.Set_Item_Value('DELIVERY_TERMS_DESC',
                           Row_.Delivery_Terms_Desc,
                           Attr_Out);
    
    End If;
    If Column_Id_ = 'SALESMAN_CODE' Or If_Default = '1' Then
      If If_Default = '0' Then
        Row_.Salesman_Code := Pkg_a.Get_Item_Value('SALESMAN_CODE',
                                                   Rowlist_);
      End If;
      Select Ifsapp.Sales_Part_Salesman_Api.Get_Name(Row_.Salesman_Code)
        Into Row_.Salesman_Name
        From Dual;
      Pkg_a.Set_Item_Value('SALESMAN_NAME', Row_.Salesman_Name, Attr_Out);
    End If;
    ---货币带出协议标示号
    If Column_Id_ = 'CURRENCY_CODE' Then
      Row_.Currency_Code := Pkg_a.Get_Item_Value('CURRENCY_CODE', Rowlist_);
      Pkg_a.Set_Item_Value('AGREEMENT_ID', '', Attr_Out);
      Row_.Customer_No := Pkg_a.Get_Item_Value('CUSTOMER_NO', Rowlist_);
      Row_.Contract    := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Open Cur_ For
        Select t.*
          From Customer_Agreement_Lov t
         Where t.Customer_No = Row_.Customer_No
           And t.Contract = Row_.Contract
           And t.Currency_Code = Row_.Currency_Code;
      Fetch Cur_
        Into Arow_;
      Close Cur_;
      Pkg_a.Set_Item_Value('AGREEMENT_ID', Arow_.Agreement_Id, Attr_Out);
    
    End If;
    --pkg_a.Set_Column_Enable('CUSTOMER_NO','0',attr_out);
    Outrowlist_ := Attr_Out;
    Return;
  End;

  /* 
  PROCEDURE ITEMCHANGE__(COLUMN_ID_ VARCHAR2 , ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
  IS 
  attr_out varchar2(4000);
  BEGIN 
     ITEMCHANGE__( COLUMN_ID_,'',ROWLIST_,USER_ID_,attr_out);
     pkg_a.setResult(A311_KEY_,attr_out);    
     RETURN;
  END;
  */
  --记录保存 BL 的表
  Procedure Usermodify__(Row_     In Bl_Customer_Order%Rowtype,
                         User_Id_ In Varchar2) Is
    Cur_  t_Cursor;
    Row0_ Bl_Customer_Order%Rowtype;
  
  Begin
    Open Cur_ For
      Select t.* From Bl_Customer_Order t Where t.Order_No = Row_.Order_No;
    Fetch Cur_
      Into Row0_;
    If Cur_%Notfound Then
      Insert Into Bl_Customer_Order
        (Order_No,
         q_Flag,
         Enter_Date,
         Enter_User,
         Bld001_Item,
         Blorder_No,
         Bllocation_No,
         Blorder_Id,
         If_First,
         Picklistno,
         Modi_Key)
        Select Row_.Order_No,
               Row_.q_Flag,
               Sysdate,
               User_Id_,
               Row_.Bld001_Item,
               Row_.Blorder_No,
               Row_.Bllocation_No,
               Row_.Blorder_Id,
               Row_.If_First,
               Row_.Picklistno,
               Row_.Modi_Key
          From Dual;
    Else
      Update Bl_Customer_Order
         Set Blorder_No    = Nvl(Row_.Blorder_No, Blorder_No),
             Bld001_Item   = Nvl(Row_.Bld001_Item, Bld001_Item),
             Bllocation_No = Nvl(Row_.Bllocation_No, Bllocation_No),
             Blorder_Id    = Nvl(Row_.Blorder_Id, Blorder_Id),
             Modi_Date     = Sysdate,
             Modi_User     = User_Id_,
             Modi_Key      = Nvl(Row_.Blorder_Id, 0)
       Where Order_No = Row_.Order_No;
    End If;
    Close Cur_;
  
    Return;
  End;
  --获取 订单 对应的 采购订单/采购申请 的连接url
  --  objid_ 订单行的objid
  Function Getpurchase_Orderurl(Objid_ In Varchar2) Return Varchar2 Is
    Row_   Customer_Order_Pur_Order_Tab%Rowtype;
    Co_Cur t_Cursor;
  Begin
    Open Co_Cur For
      Select T2.*
        From Customer_Order_Line_Tab T1
       Inner Join Customer_Order_Pur_Order_Tab T2
          On T2.Oe_Order_No = T1.Order_No
         And T2.Oe_Line_No = T1.Line_No
         And T2.Oe_Rel_No = T1.Rel_No
         And T2.Oe_Line_Item_No = T1.Line_Item_No
       Where T1.Rowid = Objid_;
  
    Fetch Co_Cur
      Into Row_;
    If (Co_Cur%Notfound) Then
      Close Co_Cur;
      Return '';
    End If;
    Close Co_Cur;
    If Row_.Purchase_Type = 'O' Then
      Return '[HTTP_URL]/showform/MainForm.aspx?option=M&A002KEY=4002&key=' || Row_.Po_Order_No;
    
    End If;
    Return '[HTTP_URL]/showform/MainForm.aspx?option=M&A002KEY=4001&key=' || Row_.Po_Order_No;
  
  End;
  /*获取号码 根据不同的类型号码的流水号*/
  Procedure Getseqno(Type_    In Varchar2,
                     User_Id_ In Varchar2,
                     Seqw_    In Number,
                     Seq_     Out Varchar2) Is
    Row_ Bl_Customer_Order_Seq%Rowtype;
    Cur  t_Cursor;
  Begin
    Open Cur For
      Select t.* From Bl_Customer_Order_Seq t Where t.Seqtype = Type_;
    Fetch Cur
      Into Row_;
    If Cur%Notfound Then
      Insert Into Bl_Customer_Order_Seq
        (Seqtype, Seq, Enter_Date, Enter_User)
        Select Type_, 0, Sysdate, User_Id_ From Dual;
      Row_.Seq := 0;
    End If;
    Close Cur;
    Seq_ := Type_ || Substr(To_Char(Power(10, Seqw_) + Row_.Seq + 1), 2);
    Update Bl_Customer_Order_Seq
       Set Modi_Date = Sysdate, Modi_User = User_Id_, Seq = Seq + 1
     Where Seqtype = Type_;
    Return;
  End;

  --保存
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Row_        Bl_v_Customer_Order%Rowtype;
    Attr_       Varchar2(4000);
    Info_       Varchar2(4000);
    Objid_      Varchar2(4000);
    Objversion_ Varchar2(4000);
    Action_     Varchar2(100);
    Index_      Varchar2(1);
    Cur_        t_Cursor;
    Pos_        Number;
    Pos1_       Number;
    i           Number;
    v_          Varchar(1000);
    Column_Id_  Varchar(1000);
    Data_       Varchar(4000);
    Doaction_   Varchar(10);
    Row0_       Bl_Customer_Order%Rowtype;
    Mysql_      Varchar2(4000);
    Ifmychange  Varchar2(1);
  Begin
    -- insert into a0(col)
    -- select ROWLIST_ 
    -- from dual  ;
    Index_     := f_Get_Data_Index();
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_  := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    If Doaction_ = 'I' Then
      /*新增*/
      Attr_ := '';
    
      Row_.Contract := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Client_Sys.Add_To_Attr('ORDER_NO',
                             Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_),
                             Attr_);
      Row_.Customer_No := Pkg_a.Get_Item_Value('CUSTOMER_NO', Rowlist_);
      If Length(Row_.Customer_No) > 2 Then
        Row_.Label_Note := Row_.Customer_No; --pkg_a.Get_Item_Value('LABEL_NOTE',ROWLIST_);
      Else
        Row_.Label_Note := Pkg_a.Get_Item_Value('LABEL_NOTE', Rowlist_);
      End If;
      --组ifs调用的包 
      Client_Sys.Add_To_Attr('CUSTOMER_NO', Row_.Customer_No, Attr_);
      Client_Sys.Add_To_Attr('WANTED_DELIVERY_DATE',
                             Pkg_a.Get_Item_Value('WANTED_DELIVERY_DATE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('ORDER_ID',
                             Pkg_a.Get_Item_Value('ORDER_ID', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('AUTHORIZE_CODE',
                             Pkg_a.Get_Item_Value('AUTHORIZE_CODE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('CONTRACT',
                             Pkg_a.Get_Item_Value('CONTRACT', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('CURRENCY_CODE',
                             Pkg_a.Get_Item_Value('CURRENCY_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('ADDITIONAL_DISCOUNT',
                             Pkg_a.Get_Item_Value('ADDITIONAL_DISCOUNT',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('SHIP_ADDR_NO',
                             Pkg_a.Get_Item_Value('SHIP_ADDR_NO', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('BILL_ADDR_NO',
                             Pkg_a.Get_Item_Value('BILL_ADDR_NO', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('ROUTE_ID', '', Attr_);
      Client_Sys.Add_To_Attr('FORWARD_AGENT_ID', '', Attr_);
      Client_Sys.Add_To_Attr('DELIVERY_LEADTIME', '0', Attr_);
      Client_Sys.Add_To_Attr('DELIVERY_TERMS',
                             Pkg_a.Get_Item_Value('DELIVERY_TERMS',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('DELIVERY_TERMS_DESC',
                             Pkg_a.Get_Item_Value('DELIVERY_TERMS_DESC',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('ORDER_CONSIGNMENT_CREATION',
                             'No Consignment',
                             Attr_);
      Client_Sys.Add_To_Attr('VAT_DB',
                             Pkg_a.Get_Item_Value('VAT_DB', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('INTRASTAT_EXEMPT_DB', 'INCLUDE', Attr_);
      Client_Sys.Add_To_Attr('CUSTOMER_NO_PAY_ADDR_NO', '', Attr_);
      Client_Sys.Add_To_Attr('PAY_TERM_ID',
                             Pkg_a.Get_Item_Value('PAY_TERM_ID', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('SALESMAN_CODE',
                             Pkg_a.Get_Item_Value('SALESMAN_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('AGREEMENT_ID',
                             Pkg_a.Get_Item_Value('AGREEMENT_ID', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('SM_CONNECTION_DB', 'NOT CONNECTED', Attr_);
      Client_Sys.Add_To_Attr('REGION_CODE',
                             Pkg_a.Get_Item_Value('REGION_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('DISTRICT_CODE',
                             Pkg_a.Get_Item_Value('DISTRICT_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('ALLOW_BACKORDERS_DB', 'Y', Attr_);
      Client_Sys.Add_To_Attr('LANGUAGE_CODE',
                             Pkg_a.Get_Item_Value('LANGUAGE_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('SCHEDULING_CONNECTION_DB',
                             'NOT SCHEDULE',
                             Attr_);
      Client_Sys.Add_To_Attr('ORDER_CONF_FLAG_DB', 'Y', Attr_);
      Client_Sys.Add_To_Attr('PACK_LIST_FLAG_DB', 'Y', Attr_);
      Client_Sys.Add_To_Attr('PICK_LIST_FLAG_DB', 'Y', Attr_);
      Client_Sys.Add_To_Attr('SHIP_VIA_CODE',
                             Pkg_a.Get_Item_Value('SHIP_VIA_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('SHIP_VIA_DESC',
                             Pkg_a.Get_Item_Value('SHIP_VIA_DESC', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('DELIVERY_TERMS',
                             Pkg_a.Get_Item_Value('DELIVERY_TERMS',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('DELIVERY_TERMS_DESC',
                             Pkg_a.Get_Item_Value('DELIVERY_TERMS_DESC',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('ORDER_CONF_DB', 'N', Attr_);
      Client_Sys.Add_To_Attr('SUMMARIZED_SOURCE_LINES_DB', 'Y', Attr_);
      Client_Sys.Add_To_Attr('JS_INVOICE_TYPE', '', Attr_);
    
      Client_Sys.Add_To_Attr('CUSTOMER_PO_NO',
                             Pkg_a.Get_Item_Value('CUSTOMER_PO_NO',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('MARKET_CODE',
                             Pkg_a.Get_Item_Value('MARKET_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('DISTRICT_CODE',
                             Pkg_a.Get_Item_Value('DISTRICT_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('REGION_CODE',
                             Pkg_a.Get_Item_Value('REGION_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('CUST_REF',
                             Pkg_a.Get_Item_Value('CUST_REF', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('LABEL_NOTE', Row_.Label_Note, Attr_);
      Client_Sys.Add_To_Attr('NOTE_TEXT',
                             Pkg_a.Get_Item_Value('NOTE_TEXT', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('PRICE_WITH_TAX',
                             Pkg_a.Get_Item_Value('PRICE_WITH_TAX',
                                                  Rowlist_),
                             Attr_);
      Action_ := 'DO';
      --调用ifs的新增过程
    
      Customer_Order_Api.New__(Info_, Objid_, Objversion_, Attr_, Action_);
      --成功以后设置objid的值
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_ORDER', Objid_);
    
      --把用户填写 的 新订单号 类型等信息 写入要 BL 自定义的表中
      Row_.Order_No := Client_Sys.Get_Item_Value('ORDER_NO', Attr_);
    
      Row0_.Order_No := Row_.Order_No;
      Row0_.q_Flag   := '0'; --确认标示为0 
      Row0_.If_First := '1'; -- 表示是起始客户订单
      --2位年号+6位客户号+4位流水号? 例如129901550001  BL 订单号
    
      Bl_Customer_Order_Api.Getseqno(To_Char(Sysdate, 'YY') ||
                                     Row_.Customer_No,
                                     User_Id_,
                                     4,
                                     Row0_.Blorder_No);
    
      Row0_.Blorder_Id := Nvl(Pkg_a.Get_Item_Value('BLORDER_ID', Rowlist_),
                              '1');
    
      --2位年号+1位类型号+2位月份+1位流水号  项目 
      Bl_Customer_Order_Api.Getseqno(To_Char(Sysdate, 'YY') ||
                                     Row0_.Blorder_Id ||
                                     To_Char(Sysdate, 'MM'),
                                     User_Id_,
                                     2,
                                     Row0_.Bld001_Item);
      Row0_.Bllocation_No := Pkg_a.Get_Item_Value('BLLOCATION_NO', Rowlist_);
      Row0_.Picklistno    := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_);
      Usermodify__(Row0_, User_Id_);
      Return;
    End If;
    If Doaction_ = 'M' Then
      /*新增*/
      Open Cur_ For
        Select t.* From Bl_v_Customer_Order t Where t.Objid = Row_.Objid;
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
      Row0_.q_Flag   := '0';
      Usermodify__(Row0_, User_Id_);
    
      /*获取有几列发生了修改*/
    
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := 'update bl_customer_order set  ';
      Ifmychange := '0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        --BL 自定义的修改 组动态SQL
        If Column_Id_ = 'BLORDER_NO' Or Column_Id_ = 'BLD001_ITEM' Or
           Column_Id_ = 'BLLOCATION_NO' Or Column_Id_ = 'BLORDER_ID' Then
          Ifmychange := '1';
          v_         := Substr(v_, Pos1_ + 1);
          Mysql_     := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
        Else
          --组要传入给IFS 的修改包       
          If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' And
             Length(Nvl(Column_Id_, '')) > 0 Then
            v_ := Substr(v_, Pos1_ + 1);
            Client_Sys.Add_To_Attr(Column_Id_, v_, Attr_);
            i := i + 1;
          End If;
        End If;
      End Loop;
    
      Action_ := 'DO';
      --调用 IFS 修改包  
      Customer_Order_Api.Modify__(Info_,
                                  Row_.Objid,
                                  Row_.Objversion,
                                  Attr_,
                                  Action_);
      --用户自定义列
      If Ifmychange = '1' Then
        Mysql_ := Mysql_ || 'modi_date=sysdate,modi_user=''' || User_Id_ || '''';
        Mysql_ := '' || Mysql_ || ' WHERE BLORDER_NO=''' || Row_.Blorder_No || '''';
        -- raise_application_error(-20101, mysql_);
        Execute Immediate Mysql_;
      End If;
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_ORDER', Row_.Objid);
    End If;
    Return;
  End;
  /*订单确认 只有最外域的订单才能做确认
  ROWLIST_ 客户订单的OBJID 
  */
  --修改备注
  Procedure Modify_Note_Text_(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2) Is
    Row_   Bl_v_Customer_Order%Rowtype;
    Attr_  Varchar2(4000);
    Index_ Varchar2(1);
  Begin
    Index_         := f_Get_Data_Index();
    Row_.Objid     := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Row_.Note_Text := Pkg_a.Get_Item_Value('NOTE_TEXT', Index_ || Rowlist_);
    Pkg_a.Set_Item_Value('OBJID', Row_.Objid, Attr_);
    Pkg_a.Set_Item_Value('DOACTION', 'M', Attr_);
    Pkg_a.Set_Item_Value('NOTE_TEXT', Row_.Note_Text, Attr_);
  
    Modify__(Attr_, User_Id_, A311_Key_);
  End;
  Procedure Appvoe_Order__(Rowlist_  Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2) Is
    Row_        Bl_v_Customer_Order%Rowtype;
    Cur_        t_Cursor;
    Attr_       Varchar2(4000);
    Row0_       Bl_Customer_Order%Rowtype;
    Order_No_10 Customer_Order_Tab.Order_No%Type;
    Order_No_30 Customer_Order_Tab.Order_No%Type;
    Count_      Number;
    Order_List_ Varchar2(2000);
    Sql_        Varchar2(3000);
  Begin
    Row_.Objid := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_v_Customer_Order t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Pkg_a.Setfailed(A311_Key_, 'BL_V_CUSTOMER_ORDER', Row_.Objid);
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
    If Row_.If_First <> '1' Then
      Pkg_a.Setfailed(A311_Key_, 'BL_V_CUSTOMER_ORDER', Row_.Objid);
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
  
    --获取下域的订单列表  确认下域所有的订单 
    Checknextexist('CO',
                   Row_.Order_No,
                   Row_.Contract,
                   User_Id_,
                   Order_List_);
    --modify wtl 2013-02-19      
    /*
      Update Bl_Customer_Order 
      Set q_Flag = '1', if_first ='1', Modi_Date = Sysdate, Modi_User = User_Id_
      Where Order_No = Row_.Order_No;
        
      Sql_ := 'update bl_customer_order set if_first =''0'',  q_flag = ''1'',modi_Date= sysdate,modi_user = ''' ||
     User_Id_ || ''' where  order_no in (' || Order_List_ ||
     '''0'')';
    */
    Update Bl_Customer_Order
       Set q_Flag = '1', Modi_Date = Sysdate, Modi_User = User_Id_
     Where Order_No = Row_.Order_No;
  
    Sql_ := 'update bl_customer_order set  q_flag = ''1'',modi_Date= sysdate,modi_user = ''' ||
            User_Id_ || ''' where  order_no in (' || Order_List_ ||
            '''0'')';
    Execute Immediate Sql_;
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_ORDER', Row_.Objid);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 Pkg_Msg.Getmsgbymsgid('ESCO003',
                                       Row_.Order_No,
                                       '',
                                       Pkg_Attr.Userlanguage(User_Id_),
                                       '1'));
  
    Return;
  End;
  ---检测下域的订单是否生成
  -- 如果生成 返回生成的下域 订单的列表
  Procedure Checknextexist(Order_Type_ In Varchar2,
                           Order_No_   In Varchar2,
                           Contract_   In Varchar2,
                           User_Id_    In Varchar2,
                           Order_List_ In Out Varchar2) Is
    Row_          Bl_v_Customer_Order_V01%Rowtype;
    Userrow_      Bl_Customer_Order_Line%Rowtype;
    Cur_          t_Cursor;
    Cur_Line_     t_Cursor;
    Count_        Number;
    Order_No_Old_ Varchar2(30);
    Pos_          Number;
    Iffactory_    Varchar2(30); --是否是最后一层
  Begin
    --非工厂域
    If Order_Type_ = 'CO' Then
      Iffactory_ := Bl_Customer_Order_Flow_Api.Iffactory(Order_No_);
      If Iffactory_ = '1' Then
        Pos_ := Instr(Nvl(Order_List_, '-'), '''' || Order_No_ || ''',');
        If Nvl(Pos_, 0) <= 0 Then
          Order_List_ := Nvl(Order_List_, '') || '''' || Order_No_ || ''',';
        End If;
        Return;
      End If;
      Order_No_Old_ := '-';
      Open Cur_ For
        Select t.*
          From Bl_v_Customer_Order_V01 t
         Where t.Demand_Order_No = Order_No_
         Order By t.Order_No;
      Fetch Cur_
        Into Row_;
      --如果没有生成下域订单
      Count_ := 0;
      If Cur_%Notfound And Iffactory_ = '0' Then
        Close Cur_;
        Raise_Application_Error(Pkg_a.Raise_Error,
                                Pkg_Msg.Getmsgbymsgid('ESCO005',
                                                      Order_No_,
                                                      '',
                                                      Pkg_Attr.Userlanguage(User_Id_),
                                                      '1'));
      End If;
    
      Loop
        Exit When Cur_%Notfound;
        Pos_ := Instr(Nvl(Order_List_, '-'), '''' || Row_.Order_No || ''',');
        If Nvl(Pos_, 0) <= 0 Then
          Order_List_ := Nvl(Order_List_, '') || '''' || Row_.Order_No ||
                         ''',';
        End If;
        Open Cur_Line_ For
          Select t.*
            From Bl_Customer_Order_Line t
           Where t.Order_No = Row_.Demand_Order_No
             And t.Line_No = Row_.Demand_Line_No
             And t.Rel_No = Row_.Rel_No
             And t.Line_Item_No = Row_.Line_Item_No;
        Fetch Cur_Line_
          Into Userrow_;
        If Cur_Line_%Found Then
          Userrow_.Order_No     := Row_.Order_No;
          Userrow_.Line_No      := Row_.Line_No;
          Userrow_.Rel_No       := Row_.Rel_No;
          Userrow_.Line_Item_No := Row_.Line_Item_No;
          Bl_Customer_Order_Line_Api.Usermodify__(Userrow_, User_Id_);
        End If;
        Close Cur_Line_;
      
        If Row_.Order_No <> Order_No_Old_ Then
          Checknextexist('CO',
                         Row_.Order_No,
                         Row_.Co_Contract,
                         User_Id_,
                         Order_List_);
        End If;
      
        Fetch Cur_
          Into Row_;
      End Loop;
      Close Cur_;
    End If;
    If Order_Type_ = 'PO' Then
    
      Open Cur_ For
        Select Distinct t.Order_No, t.Co_Contract
          From Bl_v_Customer_Order_V01 t
         Where t.Po_Order_No = Order_No_;
      Fetch Cur_
        Into Row_.Order_No, Row_.Co_Contract;
      --如果没有生成下域订单
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(Pkg_a.Raise_Error,
                                Pkg_Msg.Getmsgbymsgid('ESCO005',
                                                      Order_No_,
                                                      '',
                                                      Pkg_Attr.Userlanguage(User_Id_),
                                                      '1'));
      End If;
      Loop
        Exit When Cur_%Notfound;
        Order_List_ := Nvl(Order_List_, '') || '''' || Row_.Order_No ||
                       ''',';
        Checknextexist('CO',
                       Row_.Order_No,
                       Row_.Co_Contract,
                       User_Id_,
                       Order_List_);
        Fetch Cur_
          Into Row_.Order_No, Row_.Co_Contract;
      End Loop;
      Close Cur_;
    
    End If;
  
  End;
  --获取订单费用 的金额
  Function Get_Chare_Amount(Order_No_ In Varchar2, Type_ In Varchar2)
    Return Number Is
    Cur_       t_Cursor;
    Amountsql_ Varchar2(1000);
    Amount_    Number;
  Begin
    --含税金额
    If Type_ = 'BL_FEE_AMOUNT_WITH_TAX' Then
      Amountsql_ := 'ROUND(SUM(charge_amount_with_tax * charged_qty), 9)';
    End If;
    --不含税金额
    If Type_ = 'BL_FEE_AMOUNT' Then
      Amountsql_ := 'ROUND(SUM(charge_amount * charged_qty), 9)';
    End If;
    --税额
    If Type_ = 'BL_FEE_TAX_AMOUNT' Then
      Amountsql_ := 'ROUND(SUM((charge_amount_with_tax - charge_amount) * charged_qty), 9)';
    End If;
    Amountsql_ := 'SELECT ' || Amountsql_ || ' AS ' || Type_ ||
                  ' from   BL_V_CUSTOMER_ORDER_CHARGE T
  where  t.order_no = ''' || Order_No_ || '''';
    Open Cur_ For Amountsql_;
    Fetch Cur_
      Into Amount_;
    If Cur_%Notfound Then
      Amount_ := 0;
    End If;
    Close Cur_;
    Return Nvl(Amount_, 0);
  Exception
    When Others Then
      Return 0;
  End;

  Function Get_Customer_Amount(Order_No_ In Varchar2, Type_ In Varchar2)
    Return Number Is
    Cur_       t_Cursor;
    Amountsql_ Varchar2(1000);
    Amount_    Number;
  Begin
    --折扣金额
    If Type_ = 'BL_DISCOUNT_AMOUNT' Then
      Amountsql_ := 'round(sum(T.SALE_UNIT_PRICE_WITH_TAX * T.BUY_QTY_DUE *  (1 - (1 - T.ADDITIONAL_DISCOUNT/100)*( 1 - T.DISCOUNT/100))),9)  ';
    End If;
    --税款金额
    If Type_ = 'BL_TAX_AMOUNT' Then
      Amountsql_ := 'round(sum((T.SALE_UNIT_PRICE_WITH_TAX  -  T.SALE_UNIT_PRICE ) * T.BUY_QTY_DUE*(1-(1 - T.ADDITIONAL_DISCOUNT/100)*( 1 - T.DISCOUNT/100))),9)';
    End If;
    --金额
    If Type_ = 'BL_AMOUNT' Then
      Amountsql_ := 'round(sum(T.SALE_UNIT_PRICE * T.BUY_QTY_DUE * (1 - T.ADDITIONAL_DISCOUNT/100)*(1 - T.DISCOUNT/100)),9)';
    End If;
    --税后金额
    If Type_ = 'BL_UAMOUNT' Then
      Amountsql_ := 'round(sum(T.SALE_UNIT_PRICE_WITH_TAX * T.BUY_QTY_DUE * (1 - T.ADDITIONAL_DISCOUNT /100)*(1 - T.DISCOUNT/100)),9)';
    End If;
    Amountsql_ := 'SELECT ' || Amountsql_ || ' AS ' || Type_ ||
                  ' from   customer_order_line_tab T
  where  t.order_no = ''' || Order_No_ || '''
  and  t.line_item_no <=0
  and  t.rowstate  != ''Cancelled'''; --Cancelled
    Open Cur_ For Amountsql_;
    Fetch Cur_
      Into Amount_;
  
    If Cur_%Notfound Then
      Amount_ := 0;
    End If;
    Close Cur_;
    -- left outer join  BL_V_CUSTOMER_ORDER_AMT amt on amt.order_no = t.order_no
    -- left outer join  bl_v_customer_order_fee fee on fee.order_no = t.order_no 
  
    Return Nvl(Amount_, 0);
  Exception
    When Others Then
      Return 0;
  End;

  Procedure Chage_Modify__(Rowlist_  Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  Procedure Chage_New__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  Procedure Chage_Release__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  --交货计划表
  Procedure Delivery_Plan_Modify__(Rowlist_  Varchar2,
                                   User_Id_  Varchar2,
                                   A311_Key_ Varchar2) Is
    Row_        Bl_Delivery_Plan_Tab%Rowtype;
    Attr_       Varchar2(4000);
    Info_       Varchar2(4000);
    Objid_      Varchar2(4000);
    Objversion_ Varchar2(4000);
    Action_     Varchar2(100);
    Index_      Varchar2(1);
    Cur_        t_Cursor;
    Sql_        Varchar2(4000);
    Doaction_   Varchar(10);
  Begin
    Index_ := f_Get_Data_Index();
    -- row_.OBJID   := pkg_a.Get_Item_Value('OBJID',index_ || ROWLIST_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --插入交货计划    
    If Doaction_ = 'I' Then
      /*新增*/
      Row_.Order_No     := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
      Row_.Line_No      := Pkg_a.Get_Item_Value('LINE_NO', Rowlist_);
      Row_.Rel_No       := Pkg_a.Get_Item_Value('REL_NO', Rowlist_);
      Row_.Line_Item_No := Pkg_a.Get_Item_Value('LINE_ITEM_NO', Rowlist_);
      --获取column_no
      Select Max(Column_No)
        Into Row_.Column_No
        From Bl_Delivery_Plan_Tab t
       Where t.Order_No = Row_.Order_No
         And t.Line_No = Row_.Line_No
         And t.Rel_No = Row_.Rel_No
         And t.Line_Item_No = Row_.Line_Item_No;
      Row_.Column_No    := Nvl(Row_.Column_No, 0) + 1;
      Row_.Delived_Date := To_Date(Pkg_a.Get_Item_Value('DELIVED_DATE',
                                                        Rowlist_),
                                   'YYYY-MM-DD');
      Row_.Qty_Delived  := Pkg_a.Get_Item_Value('QTY_DELIVED', Rowlist_);
      Row_.Description  := Pkg_a.Get_Item_Value('DESCRIPTION', Rowlist_);
      Row_.Enter_User   := User_Id_;
      Row_.Enter_Date   := Sysdate;
      Row_.State        := '0';
      Insert Into Bl_Delivery_Plan_Tab
        (Order_No,
         Line_No,
         Rel_No,
         Line_Item_No,
         Column_No,
         Delived_Date,
         Qty_Delived,
         State,
         Description,
         Enter_User,
         Enter_Date,
         Modi_User,
         Modi_Date)
      Values
        (Row_.Order_No,
         Row_.Line_No,
         Row_.Rel_No,
         Row_.Line_Item_No,
         Row_.Column_No,
         Row_.Delived_Date,
         Row_.Qty_Delived,
         Row_.State,
         Row_.Description,
         Row_.Enter_User,
         Row_.Enter_Date,
         Row_.Modi_User,
         Row_.Modi_Date);
      Select t.Rowid
        Into Objid_
        From Bl_Delivery_Plan_Tab t
       Where t.Order_No = Row_.Order_No
         And t.Line_No = Row_.Line_No
         And t.Rel_No = Row_.Rel_No
         And t.Line_Item_No = Row_.Line_Item_No
         And t.Column_No = Row_.Column_No;
      Pkg_a.Setsuccess(A311_Key_, 'BL_DELIVERY_PLAN_TAB', Objid_);
    
    End If;
    If Doaction_ = 'M' Then
      /*修改*/
      Objid_ := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
      Sql_   := 'Update BL_DELIVERY_PLAN_TAB set ';
      If Pkg_a.Item_Exist('DELIVED_DATE', Rowlist_) Then
        Sql_ := Sql_ || ' delived_date=to_date(''' ||
                Pkg_a.Get_Item_Value('DELIVED_DATE', Rowlist_) ||
                ''',''YYYY-MM-DD''),';
      End If;
      If Pkg_a.Item_Exist('QTY_DELIVED', Rowlist_) Then
        Sql_ := Sql_ || 'qty_delived=' ||
                Pkg_a.Get_Item_Value('QTY_DELIVED', Rowlist_) || ',';
      End If;
      If Pkg_a.Item_Exist('DESCRIPTION', Rowlist_) Then
        Sql_ := Sql_ || 'DESCRIPTION=''' ||
                Replace(Pkg_a.Get_Item_Value('DESCRIPTION', Rowlist_),
                        '''',
                        '''''') || ''',';
      End If;
      Sql_ := Sql_ || 'modi_date = sysdate,modi_user=''' || User_Id_ ||
              ''' where rowid=''' || Objid_ || '''';
      Execute Immediate Sql_;
      Pkg_a.Setsuccess(A311_Key_, 'BL_DELIVERY_PLAN_TAB', Objid_);
    End If;
    If Doaction_ = 'D' Then
      /*删除*/
      Objid_ := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
      Delete From Bl_Delivery_Plan_Tab Where Rowid = Objid_;
      Pkg_a.Setsuccess(A311_Key_, 'BL_DELIVERY_PLAN_TAB', Objid_);
    End If;
    Return;
  End;
  Procedure Delivery_Plan_(Order_No_     Varchar2,
                           User_Id_      Varchar2,
                           A311_Key_     In Number,
                           Modify_Objid_ In Varchar2 Default '0') Is
    Row_         Bl_v_Customer_Order%Rowtype;
    Parentrow_   Bl_v_Customer_Order%Rowtype;
    Cur_         t_Cursor;
    Cur1_        t_Cursor;
    Cur2_        t_Cursor;
    Irow_        Bl_Delivery_Plan%Rowtype;
    Idrow_       Bl_Delivery_Plan_Detial%Rowtype;
    Vdrow_       Bl_Delivery_Plan_Detial_v%Rowtype;
    Checkrow_    Customer_Order_Line%Rowtype;
    Coline_      Customer_Order_Line%Rowtype;
    Blrowv02     Bl_v_Customer_Order_V02%Rowtype;
    Num_         Number;
    Order_No_20  Varchar2(100);
    Rowobjid_    Varchar2(100);
    A311_        A311%Rowtype;
    If_New_      Varchar2(100);
    Po_Order_No_ Varchar2(100);
    Supplier_    Varchar2(100);
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Customer_Order t Where t.Order_No = Order_No_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ESCO006',
                                                    Order_No_,
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
    Supplier_ := Row_.Contract;
    If_New_   := '0';
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order t
       Where t.Blorder_No = Row_.Blorder_No
         And t.If_First = '1';
    Fetch Cur_
      Into Parentrow_;
    If Cur_%Notfound Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ESCO007',
                                                    Row_.Blorder_No,
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_)));
      Return;
    End If;
    Close Cur_;
  
    --没有底层的订单行不产生交货计划
    Open Cur_ For
      Select t.*
        From Customer_Order_Line t
       Where t.Order_No = Order_No_
         And t.Line_Item_No <= 0
         And t.Supply_Code In
             (Select Id From Bl_v_Co_Supply_Code T1 Where T1.Autoplan = '1');
    Fetch Cur_
      Into Coline_;
    If Cur_%Notfound Then
      Close Cur_;
      Return;
    End If;
    Close Cur_;
  
    --读取交货计划是否存在
    /*判断交货计划是否已经生成*/
  
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan t
       Where t.Order_No = Parentrow_.Order_No
         And t.Supplier = Row_.Contract
         And t.Type_Id = 'AUTO'
         And t.State <> '3';
    Fetch Cur_
      Into Irow_;
    If Cur_%Notfound Then
      Close Cur_;
      --写表头
      Bl_Customer_Order_Api.Getseqno(To_Char(Sysdate, 'YY') ||
                                     Row_.Contract,
                                     User_Id_,
                                     8,
                                     Irow_.Delplan_No);
      Irow_.Order_No        := Parentrow_.Order_No;
      Irow_.Column_No       := 1;
      Irow_.Delived_Date    := Row_.Wanted_Delivery_Date;
      Irow_.Customer_Ref    := Row_.Label_Note;
      Irow_.Contract        := Parentrow_.Contract; --Row_.Contract;
      Irow_.Customer_No     := Parentrow_.Customer_No;
      Irow_.Version         := '1';
      Irow_.State           := '0'; --计划状态
      Irow_.Type_Id         := 'AUTO';
      Irow_.Enter_User      := User_Id_;
      Irow_.Enter_Date      := Sysdate;
      Irow_.Supplier        := Row_.Contract;
      Irow_.Base_Delplan_No := Irow_.Delplan_No;
      Irow_.Delplan_Line    := 0;
      --Bldelivery_Plan_Api
      Insert Into Bl_Delivery_Plan
        (Delplan_No, Enter_User, Enter_Date)
        Select Irow_.Delplan_No, Irow_.Enter_User, Irow_.Enter_Date
          From Dual;
    
      Update Bl_Delivery_Plan
         Set Row = Irow_
       Where Delplan_No = Irow_.Delplan_No;
      If_New_ := '1';
    Else
      Close Cur_;
    End If;
    If Irow_.State = '1' Then
      A311_.A311_Id     := 'Blbill_Vary_Api.CoSetNext';
      A311_.Enter_User  := User_Id_;
      A311_.A014_Id     := 'A014_ID=Order_PCancel';
      A311_.Table_Id    := 'BL_V_CUST_DELIVERY_PLAN';
      A311_.Table_Objid := Irow_.Order_No || '-' || Irow_.Supplier;
      Pkg_a.Beginlog(A311_);
      Pkg_a.Doa014('Order_PCancel',
                   'BL_V_CUST_DELIVERY_PLAN',
                   A311_.Table_Objid,
                   User_Id_,
                   A311_.A311_Key);
      Open Cur_ For
        Select t.*
          From Bl_Delivery_Plan t
         Where t.Order_No = Parentrow_.Order_No
           And t.Supplier = Row_.Contract
           And t.Type_Id = 'AUTO'
           And t.State <> '3';
      Fetch Cur_
        Into Irow_;
      Close Cur_;
    End If;
    --直接修改 交货计划数据
  
    Open Cur_ For
      Select t.*
        From Customer_Order_Line t
       Where t.Order_No = Order_No_
         And t.Line_Item_No <= 0
         And t.Supply_Code In
             (Select Id From Bl_v_Co_Supply_Code T1 Where T1.Autoplan = '1');
  
    Fetch Cur_
      Into Coline_;
    Loop
      Exit When Cur_%Notfound;
      Open Cur1_ For
        Select t.*
          From Bl_Delivery_Plan_Detial_v t
         Where t.Delplan_No = Irow_.Delplan_No
           And t.f_Order_No = Coline_.Order_No
           And t.f_Line_No = Coline_.Line_No
           And t.f_Rel_No = Coline_.Rel_No
           And t.f_Line_Item_No = Coline_.Line_Item_No;
      Fetch Cur1_
        Into Vdrow_;
      If Cur1_%Notfound Then
        Close Cur1_;
        Idrow_.Delplan_No := Irow_.Delplan_No;
        Select Max(Delplan_Line)
          Into Idrow_.Delplan_Line
          From Bl_Delivery_Plan_Detial_v t
         Where t.Delplan_No = Irow_.Delplan_No;
        Idrow_.Delplan_Line   := Nvl(Idrow_.Delplan_Line, 0) + 1;
        Idrow_.Column_No      := Irow_.Column_No;
        Idrow_.f_Order_No     := Coline_.Order_No;
        Idrow_.f_Line_No      := Coline_.Line_No;
        Idrow_.f_Rel_No       := Coline_.Rel_No;
        Idrow_.f_Line_Item_No := Coline_.Line_Item_No;
        Idrow_.Order_Line_No  := Coline_.Order_No || '-' || Coline_.Line_No || '-' ||
                                 Coline_.Rel_No || '-' ||
                                 To_Char(Coline_.Line_Item_No);
      
        Open Cur2_ For
          Select t.*
            From Bl_v_Customer_Order_V02 t
           Where t.Order_No = Coline_.Order_No
             And t.Line_No = Coline_.Line_No
             And t.Rel_No = Coline_.Rel_No
             And t.Line_Item_No = Coline_.Line_Item_No;
        Fetch Cur2_
          Into Blrowv02;
        If Cur2_%Notfound Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Pkg_Msg.Getmsgbymsgid('ESCO011',
                                                        Coline_.Order_No,
                                                        '',
                                                        Pkg_Attr.Userlanguage(User_Id_),
                                                        '1'));
        
        End If;
        Close Cur2_;
      
        Idrow_.Po_Order_No             := Blrowv02.Po_Order_No;
        Idrow_.Po_Line_No              := Blrowv02.Po_Line_No;
        Idrow_.Po_Release_No           := Blrowv02.Po_Release_No;
        Idrow_.Demand_Order_No         := Blrowv02.Demand_Order_No;
        Idrow_.Demand_Rel_No           := Blrowv02.Demand_Rel_No;
        Idrow_.Demand_Line_No          := Blrowv02.Demand_Line_No;
        Idrow_.Demand_Line_Item_No     := Blrowv02.Demand_Line_Item_No;
        Idrow_.Par_Po_Order_No         := Blrowv02.Par_Po_Order_No;
        Idrow_.Par_Po_Line_No          := Blrowv02.Par_Po_Line_No;
        Idrow_.Par_Po_Release_No       := Blrowv02.Par_Po_Release_No;
        Idrow_.Par_Demand_Order_No     := Blrowv02.Par_Demand_Order_No;
        Idrow_.Par_Demand_Rel_No       := Blrowv02.Par_Demand_Rel_No;
        Idrow_.Par_Demand_Line_No      := Blrowv02.Par_Demand_Line_No;
        Idrow_.Par_Demand_Line_Item_No := Blrowv02.Par_Demand_Line_Item_No;
      
        Idrow_.Order_No     := Nvl(Idrow_.Par_Demand_Order_No,
                                   Nvl(Idrow_.Demand_Order_No,
                                       Idrow_.f_Order_No));
        Idrow_.Line_No      := Nvl(Idrow_.Par_Demand_Line_No,
                                   Nvl(Idrow_.Demand_Line_No,
                                       Idrow_.f_Line_No)); --crow_.LINE_NO;
        Idrow_.Rel_No       := Nvl(Idrow_.Par_Demand_Rel_No,
                                   Nvl(Idrow_.Demand_Rel_No, Idrow_.f_Rel_No));
        Idrow_.Line_Item_No := Nvl(Idrow_.Par_Demand_Line_Item_No,
                                   Nvl(Idrow_.Demand_Line_Item_No,
                                       Idrow_.f_Line_Item_No));
      
        Idrow_.Base_Delplan_No   := Idrow_.Delplan_No;
        Idrow_.Base_Delplan_Line := Idrow_.Base_Delplan_Line;
      
        If Irow_.State = '0' Then
          If If_New_ = '1' Then
            Idrow_.Qty_Delived := Coline_.Buy_Qty_Due;
          Else
            Idrow_.Qty_Delived := 0;
          End If;
        End If;
        If Irow_.State = '2' Then
          Idrow_.Qty_Delived := 0;
        End If;
        Idrow_.Qty_Delived  := Nvl(Idrow_.Qty_Delived, 0);
        Idrow_.Picklistno   := Irow_.Picklistno;
        Idrow_.Version      := Irow_.Version;
        Idrow_.State        := Irow_.State;
        Idrow_.Delived_Date := Irow_.Delived_Date;
        Idrow_.Enter_Date   := Sysdate;
        Idrow_.Enter_User   := User_Id_;
        Idrow_.Rowdata      := '';
        Pkg_a.Set_Item_Value('BUY_QTY_DUE',
                             Coline_.Buy_Qty_Due,
                             Idrow_.Rowdata);
        Pkg_a.Set_Item_Value('QLIST', Coline_.Buy_Qty_Due, Idrow_.Rowdata);
        Insert Into Bl_Delivery_Plan_Detial
          (Delplan_No, Delplan_Line)
        Values
          (Idrow_.Delplan_No, Idrow_.Delplan_Line)
        Returning Rowid Into Rowobjid_;
        Update Bl_Delivery_Plan_Detial
           Set Row = Idrow_
         Where Rowid = Rowobjid_;
        Bldelivery_Plan_Line_Api.Savehist__(Rowobjid_,
                                            User_Id_,
                                            A311_Key_,
                                            '自动录入数据' || Idrow_.Qty_Delived);
      
      Else
        --有交货计划 
      
        Checkrow_.Buy_Qty_Due := Pkg_a.Get_Item_Value('BUY_QTY_DUE',
                                                      Vdrow_.Rowdata);
        If Checkrow_.Buy_Qty_Due <> Coline_.Buy_Qty_Due Then
          --修改交货计划数量
        
          Pkg_a.Set_Item_Value('BUY_QTY_DUE',
                               Coline_.Buy_Qty_Due,
                               Vdrow_.Rowdata);
        
          Pkg_a.Set_Item_Value('QLIST',
                               Pkg_a.Get_Item_Value('QLIST', Vdrow_.Rowdata) || '=>' ||
                               Coline_.Buy_Qty_Due,
                               Vdrow_.Rowdata);
        
          /*        IF Irow_.State = '0' THEN
            Vdrow_.Qty_Delived := Vdrow_.Qty_Delived +
                                  (Coline_.Buy_Qty_Due -
                                  Checkrow_.Buy_Qty_Due);
          END IF;*/
        
          Update Bl_Delivery_Plan_Detial t
             Set --Qty_Delived = Vdrow_.Qty_Delived, 
                 Rowdata = Vdrow_.Rowdata
           Where t.Rowid = Vdrow_.Objid;
          Bldelivery_Plan_Line_Api.Savehist__(Vdrow_.Objid,
                                              User_Id_,
                                              A311_Key_,
                                              '订单数量变化' ||
                                              Checkrow_.Buy_Qty_Due || '=>' ||
                                              Coline_.Buy_Qty_Due);
        End If;
        Close Cur1_;
      End If;
    
      Fetch Cur_
        Into Coline_;
    End Loop;
    Close Cur_;
    /*    If Length(Nvl(Modify_Objid_, '-')) > 2 Then
      Open Cur_ For
        Select t.*
          From Bl_Delivery_Plan t
         Where t.Order_No = Parentrow_.Order_No
           And t.Supplier = Supplier_
           And t.Type_Id = 'AUTO'
           And t.State = '2';
      Fetch Cur_
        Into Irow_;
      If Cur_%Found Then
        Blbill_Vary_Api.Setnext(Modify_Objid_,
                                User_Id_,
                                A311_Key_,
                                Parentrow_.Order_No || '-' || Row_.Contract,
                                Row_.Order_No);
      
      End If;
      Close Cur_;
    End If;*/
  
  End;

  --自动生成交货计划
  Procedure Delivery_Plan_Atuo__(Rowlist_  Varchar2,
                                 User_Id_  Varchar2,
                                 A311_Key_ Varchar2) Is
    Row_   Bl_v_Customer_Order%Rowtype;
    Drow_  Bl_v_Customer_Order_Line%Rowtype;
    Cur_   t_Cursor;
    Irow_  Bl_Delivery_Plan%Rowtype;
    Idrow_ Bl_Delivery_Plan_Detial%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Customer_Order t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Pkg_a.Setfailed(A311_Key_, 'BL_V_CUSTOMER_ORDER', Rowlist_);
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
  
    /*判断交货计划是否已经生成*/
    Open Cur_ For
      Select t.* From Bl_Delivery_Plan t Where t.Order_No = Row_.Order_No;
    Fetch Cur_
      Into Irow_;
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0009',
                                                    Irow_.Delplan_No,
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
  
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order_Line t
       Where t.Order_No = Row_.Order_No
         And t.Line_Item_No <= 0
         And t.Supply_Code In
             (Select Id From Bl_v_Co_Supply_Code T1 Where T1.Autoplan = '1');
    Fetch Cur_
      Into Drow_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ESCO008',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    --写表头
    Bl_Customer_Order_Api.Getseqno(To_Char(Sysdate, 'YY') || Row_.Contract,
                                   User_Id_,
                                   8,
                                   Irow_.Delplan_No);
    Irow_.Order_No     := Row_.Order_No;
    Irow_.Column_No    := 1;
    Irow_.Delived_Date := Row_.Wanted_Delivery_Date;
    Irow_.Customer_Ref := Row_.Label_Note;
    Irow_.Contract     := Row_.Contract;
    Irow_.Customer_No  := Row_.Customer_No;
    Irow_.Version      := '1';
    Irow_.State        := '2'; --自动确认
    Irow_.Type_Id      := 'CUSTOMER';
    Irow_.Enter_User   := User_Id_;
    Irow_.Enter_Date   := Sysdate;
    Irow_.Supplier     := Row_.Contract;
    --Bldelivery_Plan_Api
    Insert Into Bl_Delivery_Plan
      (Delplan_No, Enter_User, Enter_Date)
      Select Irow_.Delplan_No, Irow_.Enter_User, Irow_.Enter_Date
        From Dual;
  
    Update Bl_Delivery_Plan
       Set Row = Irow_
     Where Delplan_No = Irow_.Delplan_No;
    Loop
      Exit When Cur_%Notfound;
      Idrow_.Delplan_No     := Irow_.Delplan_No;
      Idrow_.Delplan_Line   := Nvl(Idrow_.Delplan_Line, 0) + 1;
      Idrow_.Column_No      := Irow_.Column_No;
      Idrow_.Order_No       := Drow_.Order_No;
      Idrow_.Line_No        := Drow_.Line_No;
      Idrow_.Rel_No         := Drow_.Rel_No;
      Idrow_.Line_Item_No   := Drow_.Line_Item_No;
      Idrow_.Order_Line_No  := Drow_.Order_No || '-' || Drow_.Line_No || '-' ||
                               Drow_.Rel_No || '-' ||
                               To_Char(Drow_.Line_Item_No);
      Idrow_.f_Order_No     := Drow_.Order_No;
      Idrow_.f_Line_No      := Drow_.Line_No;
      Idrow_.f_Rel_No       := Drow_.Rel_No;
      Idrow_.f_Line_Item_No := Drow_.Line_Item_No;
      Idrow_.Qty_Delived    := Drow_.Buy_Qty_Due;
      Idrow_.Version        := Irow_.Version;
      Idrow_.State          := Irow_.State;
      Idrow_.Delived_Date   := Irow_.Delived_Date;
      Idrow_.Enter_Date     := Sysdate;
      Idrow_.Enter_User     := User_Id_;
      Insert Into Bl_Delivery_Plan_Detial
        (Delplan_No, Delplan_Line)
        Select Idrow_.Delplan_No, Idrow_.Delplan_Line From Dual;
      Update Bl_Delivery_Plan_Detial
         Set Row = Idrow_
       Where Delplan_No = Idrow_.Delplan_No
         And Delplan_Line = Idrow_.Delplan_Line;
      Fetch Cur_
        Into Drow_;
    End Loop;
    Close Cur_;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_ORDER', Row_.Objid);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 Pkg_Msg.Getmsgbymsgid('ESCO012',
                                       Row_.Order_No || '自动生成交货计划' ||
                                       Irow_.Delplan_No,
                                       '',
                                       Pkg_Attr.Userlanguage(User_Id_),
                                       '1'));
  
  End;
  --自动生成备货单
  Procedure Delivery_Picklist_Atuo__(Rowlist_  Varchar2,
                                     User_Id_  Varchar2,
                                     A311_Key_ Varchar2) Is
    Row_  Bl_v_Customer_Order%Rowtype;
    Cur_  t_Cursor;
    Irow_ Bl_Delivery_Plan_v%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Customer_Order t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Pkg_a.Setfailed(A311_Key_, 'BL_V_CUSTOMER_ORDER', Rowlist_);
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
  
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan_v t
       Where t.Order_No = Row_.Order_No
         And t.Contract = t.Supplier;
    Fetch Cur_
      Into Irow_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0010',
                                                    Irow_.Delplan_No,
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
    Bl_Pick_Order_Api.Picklist_Auto_(Irow_.Objid, User_Id_, A311_Key_);
    Return;
  End;
  --交货计划
  Procedure Delivery_Plan_New__(Rowlist_  Varchar2,
                                User_Id_  Varchar2,
                                A311_Key_ Varchar2) Is
  Begin
    --  
  
    Return;
  End;
  Procedure Delivery_Plan_Release__(Rowlist_  Varchar2,
                                    User_Id_  Varchar2,
                                    A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  --取消订单
  Procedure Set_Cancel_Reason(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2) Is
    Row_       Bl_v_Customer_Order%Rowtype;
    Cur_       t_Cursor;
    State_     Varchar2(4000);
    Info_      Varchar2(4000);
    Po_Row_    Purchase_Order%Rowtype;
    A311_      A311%Rowtype;
    Po_Rowlist Varchar2(4000);
    -- attr_ varchar2(4000);
  Begin
    Row_.Objid    := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Row_.Order_No := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
    Open Cur_ For
      Select t.* From Bl_v_Customer_Order t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Pkg_a.Setfailed(A311_Key_, 'BL_V_CUSTOMER_ORDER', Row_.Objid);
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Pkg_Msg.Getmsgbymsgid('ES0002',
                                                    '',
                                                    '',
                                                    Pkg_Attr.Userlanguage(User_Id_),
                                                    '1'));
      Return;
    End If;
    Close Cur_;
    Row_.Cancel_Reason      := Pkg_a.Get_Item_Value('CANCEL_REASON',
                                                    Rowlist_);
    Row_.Reason_Description := Pkg_a.Get_Item_Value('REASON_DESCRIPTION',
                                                    Rowlist_);
    Customer_Order_Api.Set_Cancel_Reason(Row_.Order_No, Row_.Cancel_Reason);
    Cancel_Customer_Order_Api.Cancel_Order__(State_,
                                             Info_,
                                             Row_.Order_No,
                                             'FALSE',
                                             'FALSE');
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_ORDER', Row_.Objid);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 Pkg_Msg.Getmsgbymsgid('ESCO004',
                                       Row_.Order_No,
                                       '',
                                       Pkg_Attr.Userlanguage(User_Id_),
                                       '1'));
    /*取消当前行对应的所有的采购订单 和 销售订单 */
  
    Open Cur_ For
      Select Distinct t.*
        From Customer_Order_Line T2
       Inner Join Purchase_Order_Line T1
          On T1.Demand_Order_No = T2.Order_No
         And T1.Demand_Release = T2.Line_No
         And T1.Demand_Sequence_No = T2.Rel_No
         And T1.Demand_Operation_No = T2.Line_Item_No
       Inner Join Purchase_Order t
          On t.Order_No = T1.Order_No
         And t.Objstate != 'Cancelled'
       Where T2.Order_No = Row_.Order_No;
    Fetch Cur_
      Into Po_Row_;
    Loop
      Exit When Cur_%Notfound;
      --取消对应的采购订单
      A311_.A311_Id     := 'BL_Customer_Order_Api.set_cancel_reason';
      A311_.Enter_User  := User_Id_;
      A311_.A014_Id     := 'A014_ID=PO_Cancle';
      A311_.Table_Id    := 'BL_V_PURCHASE_ORDER';
      A311_.Table_Objid := Po_Row_.Objid;
      Pkg_a.Beginlog(A311_);
      Po_Rowlist := '';
      --设置取消参数
      Pkg_a.Set_Item_Value('OBJID', A311_.Table_Objid, Po_Rowlist);
      Pkg_a.Set_Item_Value('CANCEL_REASON', Row_.Cancel_Reason, Po_Rowlist);
      Bl_Purchase_Order_Api.Cancel__(Po_Rowlist, User_Id_, A311_.A311_Key);
      Fetch Cur_
        Into Po_Row_;
    End Loop;
    Close Cur_;
    Return;
  End;
  Procedure Set_Chage_Cancel(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  Procedure Set_Delivery_Plan_Cancel(Rowlist_  Varchar2,
                                     User_Id_  Varchar2,
                                     A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  ----检查新增 修改 
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2 Is
  
  Begin
    --dotype_ ADD_ROW
    --dotype_ MOD_ROW
    --dotype_ DEL_ROW
  
    Return '1';
  End;
  Function Get_Enter_User(Blorder_No_ In Varchar2) Return Varchar2 Is
    Cur_    t_Cursor;
    Result_ Varchar2(2000);
  Begin
    Open Cur_ For
      Select Case
               When t.Enter_User = 'System' Then
                Nvl(t.Modi_User, t.Enter_User)
               Else
                t.Enter_User
             End
        From Bl_Customer_Order t
       Where t.Blorder_No = Blorder_No_
         And t.If_First = '1';
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  Exception
    When Others Then
      Return Null;
    
  End;

  Function Get_Column_Data(Column_Id_ In Varchar2, Order_No_ In Varchar2)
    Return Varchar2 Is
    Cur_    t_Cursor;
    Result_ Varchar2(2000);
  Begin
  
    Open Cur_ For 'Select ' || Column_Id_ || ' From Bl_v_customer_order t where t.order_no=''' || Order_No_ || '''';
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  Exception
    When Others Then
      Return Null;
  End;
  --获取最上级的的 客户订单
  Function Get_20_Order(Order_No_ In Varchar2) Return Varchar2 Is
    Cur_         t_Cursor;
    Coline_      Customer_Order_Line%Rowtype;
    Par_Line_Key Varchar2(100);
  Begin
    Open Cur_ For
      Select t.* From Customer_Order_Line t Where t.Order_No = Order_No_;
    Fetch Cur_
      Into Coline_;
    If Cur_%Found Then
      Par_Line_Key := Bl_Customer_Order_Line_Api.Get_Par_Order_(Coline_.Order_No,
                                                                Coline_.Line_No,
                                                                Coline_.Rel_No,
                                                                Coline_.Line_Item_No);
      Return Pkg_a.Get_Str_(Par_Line_Key, '-', 1);
    Else
      Return Order_No_;
    End If;
    Close Cur_;
  
    Return Par_Line_Key;
  
  End;

  --获取客户订单的 采购订单
  Function Get_Par_Po_Order(Order_No_ In Varchar2) Return Varchar2 Is
    Cur_    t_Cursor;
    Coline_ Customer_Order_Line%Rowtype;
  Begin
    Open Cur_ For
      Select t.*
        From Customer_Order_Line t
       Where t.Order_No = Order_No_
         And t.State <> 'Cancelled';
    Fetch Cur_
      Into Coline_;
    Return Coline_.Demand_Order_Ref1;
    Close Cur_;
  
  End;
  --纯费用订单开发票
  Procedure Start_Create_Invoice__(Rowid_    Varchar2,
                                   User_Id_  Varchar2,
                                   A311_Key_ In Number) Is
    Cur_ t_Cursor;
    Row_ Bl_v_Customer_Order%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Customer_Order t Where t.Objid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
    End If;
    Close Cur_;
    Bl_Customer_Order_Flow_Api.Start_Create_Invoice__(Row_.Order_No,
                                                      User_Id_,
                                                      A311_Key_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_ORDER', Rowid_);
    Return;
  End;
End Bl_Customer_Order_Api;
/
