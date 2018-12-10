Create Or Replace Package Bldelivery_Plan_Line_Api Is
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2);
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2;
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2;
  Procedure Savehist__(Objid_    In Varchar2,
                       User_Id_  In Varchar2,
                       A311_Key_ In Number,
                       Msg_      In Varchar2);
  --获取交货计划的明细行
  Procedure Get_Record_By_Line_Key(Line_Key_ In Varchar2,
                                   Record_   Out Bl_Delivery_Plan_Detial_v%Rowtype);
  --根据交期 获取交货计划的行
  Procedure Get_Record_By_Order_Date(Order_No_     In Varchar2,
                                     Line_No_      In Varchar2,
                                     Rel_No_       In Varchar2,
                                     Line_Item_No_ In Number,
                                     Date_Delived  Date,
                                     Record_       Out Bl_Delivery_Plan_Detial_v%Rowtype);
  --判断交货有没有当前订单行的数据
  Procedure Get_Record_d_o_(Delplan_No_   In Varchar2,
                            Order_No_     In Varchar2,
                            Line_No_      In Varchar2,
                            Rel_No_       In Varchar2,
                            Line_Item_No_ In Number,
                            Record_       Out Bl_Delivery_Plan_Detial_v%Rowtype);

End Bldelivery_Plan_Line_Api;
/
Create Or Replace Package Body Bldelivery_Plan_Line_Api Is
  Type t_Cursor Is Ref Cursor;
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
    Mainrow_ Bl_v_Cust_Order_Line_Phdelive%Rowtype;
    Row_     Bl_v_Cust_Order_Line_Pdelive%Rowtype;
    Cur_     t_Cursor;
    Attr_Out Varchar2(4000);
  Begin
    Mainrow_.Delplan_No := Pkg_a.Get_Item_Value('DELPLAN_NO', Rowlist_);
    Open Cur_ For
      Select t.*
        From Bl_v_Cust_Order_Line_Phdelive t
       Where t.Delplan_No = Mainrow_.Delplan_No;
    Fetch Cur_
      Into Mainrow_;
    If Cur_%Notfound Then
      Close Cur_;
      Return;
    End If;
    Close Cur_;
    Row_.Delplan_No := Mainrow_.Delplan_No;
    Pkg_a.Set_Item_Value('DELPLAN_NO', Row_.Delplan_No, Attr_Out);
    Row_.Column_No := Mainrow_.Column_No;
    Pkg_a.Set_Item_Value('COLUMN_NO', Row_.Column_No, Attr_Out);
  
    Row_.Version := Mainrow_.Version;
    Pkg_a.Set_Item_Value('VERSION', Row_.Version, Attr_Out);
  
    Row_.Delived_Date := Mainrow_.Delived_Date;
    Pkg_a.Set_Item_Value('DELIVED_DATE',
                         To_Char(Row_.Delived_Date, 'YYYY-MM-DD'),
                         Attr_Out);
  
    Row_.State := Mainrow_.Pstate;
    Pkg_a.Set_Item_Value('STATE', Row_.State, Attr_Out);
  
    Pkg_a.Setresult(A311_Key_, Attr_Out);
    Return;
  End;
  Procedure Savehist__(Objid_    In Varchar2,
                       User_Id_  In Varchar2,
                       A311_Key_ In Number,
                       Msg_      In Varchar2) Is
    Row_  Bl_Delivery_Plan_Detial%Rowtype;
    Cur_  t_Cursor;
    Irow_ Bl_Delivery_Plan_Hist%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_Delivery_Plan_Detial t Where t.Rowid = Objid_;
    Fetch Cur_
      Into Row_;
    Close Cur_;
    Select s_Bl_Delivery_Plan_Hist.Nextval Into Irow_.History_No From Dual;
    Insert Into Bl_Delivery_Plan_Hist
      (History_No)
      Select Irow_.History_No From Dual;
    Irow_.Enter_User   := User_Id_;
    Irow_.A311_Key     := A311_Key_;
    Irow_.Date_Entered := Sysdate;
    Irow_.Message_Text := Msg_;
    Irow_.State        := Row_.State;
    Irow_.Delplan_Key  := Row_.Delplan_No || '-' ||
                          To_Char(Row_.Delplan_Line);
    Irow_.Delplan_No   := Row_.Delplan_No;
    Irow_.Delplan_Line := Row_.Delplan_Line;
    Irow_.Column_No    := Row_.Column_No;
    Irow_.Order_No     := Row_.Order_No;
    Irow_.Line_No      := Row_.Line_No;
    Irow_.Rel_No       := Row_.Rel_No;
    Irow_.Line_Item_No := Row_.Line_Item_No;
    Irow_.Picklistno   := Row_.Picklistno;
    Irow_.Enter_Date   := Sysdate;
    Irow_.Qty          := Row_.Qty_Delived;
    Update Bl_Delivery_Plan_Hist
       Set Row = Irow_
     Where History_No = Irow_.History_No;
  
  End;

  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Row_        Bl_v_Cust_Order_Line_Pdelive%Rowtype;
    Irow_       Bl_Delivery_Plan_Detial%Rowtype;
    Crow_       Bl_v_Cust_Ord_Line_V01%Rowtype;
    Ccrow_      Bl_Delivery_Plan_Detial%Rowtype;
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
    Mainrow_    Customer_Order_Tab%Rowtype;
    Row0_       Bl_Customer_Order_Line%Rowtype;
    Mysql_      Varchar(4000);
    Ifmychange  Varchar(10);
    Blrow_      Bl_v_Customer_Order_V01%Rowtype;
    Blrowv02    Bl_v_Customer_Order_V02%Rowtype;
    Msg_        Varchar(4000);
  Begin
  
    Index_      := f_Get_Data_Index();
    Row_.Objid  := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Objversion_ := Pkg_a.Get_Item_Value('OBJVERSION', Rowlist_);
    Doaction_   := Nvl(Pkg_a.Get_Item_Value('DOACTION', Rowlist_), 'M');
  
    If Doaction_ = 'I' Then
      /*新增*/
      Attr_         := '';
      Row_.Line_Key := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
      Open Cur_ For
        Select t.*
          From Bl_v_Cust_Ord_Line_V01 t
         Where t.Line_Key = Row_.Line_Key;
      Fetch Cur_
        Into Crow_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的关键字');
      End If;
      Close Cur_;
      --检测现有的数量 是否超过已有数量
      Row_.Qty_Delived := Pkg_a.Get_Item_Value('QTY_DELIVED', Rowlist_);
      If Crow_.Qty_Planned + Row_.Qty_Delived > Crow_.Buy_Qty_Due Then
        Raise_Application_Error(-20101,
                                '关键字' || Row_.Line_Key || '数量过多!');
      End If;
      If Nvl(Row_.Qty_Delived, 0) = 0 Then
        Raise_Application_Error(-20101,
                                '关键字' || Row_.Line_Key || '交货数量为0!');
      End If;
      Irow_.Delplan_No := Pkg_a.Get_Item_Value('DELPLAN_NO', Rowlist_);
      Open Cur_ For
        Select t.*
          From Bl_Delivery_Plan_Detial t
         Where t.Delplan_No = Irow_.Delplan_No
           And t.Order_Line_No = Row_.Line_Key;
      Fetch Cur_
        Into Ccrow_;
      If Cur_%Found Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                '关键字' || Row_.Line_Key || '不能重复!');
      End If;
      Close Cur_;
      Irow_.Version      := Pkg_a.Get_Item_Value('VERSION', Rowlist_);
      Irow_.Qty_Delived  := Pkg_a.Get_Item_Value('QTY_DELIVED', Rowlist_);
      Irow_.Delived_Date := To_Date(Pkg_a.Get_Item_Value('DELIVED_DATE',
                                                         Rowlist_),
                                    'YYYY-MM-DD');
      Irow_.State        := Pkg_a.Get_Item_Value('STATE', Rowlist_);
      Irow_.Remark       := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      Select t.Delplan_Line, t.Delived_Date
        Into Irow_.Delplan_Line, Irow_.Delived_Date
        From Bl_Delivery_Plan t
       Where t.Delplan_No = Irow_.Delplan_No;
      Irow_.Delplan_Line := Nvl(Irow_.Delplan_Line, 0) + 1;
    
      Update Bl_Delivery_Plan
         Set Delplan_Line = Irow_.Delplan_Line
       Where Delplan_No = Irow_.Delplan_No;
      Irow_.Column_No := Pkg_a.Get_Item_Value('COLUMN_NO', Rowlist_);
      -- row_.VERSION
      --row_.COLUMN_NO
    
      Irow_.Enter_User := User_Id_;
      Irow_.Enter_Date := Sysdate;
      --获取关联数据信息
      --   bl_customer_order_line_api.get_factory_orderrow_(irow_.order_no,
      --            irow_.line_no,irow_.rel_no ,irow_.line_item_no,blrow_ ) ;   
      Open Cur_ For
        Select t.*
          From Bl_v_Customer_Order_V02 t
         Where t.Order_No = Crow_.Order_No
           And t.Line_No = Crow_.Line_No
           And t.Rel_No = Crow_.Rel_No
           And t.Line_Item_No = Crow_.Line_Item_No;
      Fetch Cur_
        Into Blrowv02;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                '关键字' || Row_.Line_Key || '找对应关系错误!');
      End If;
      Close Cur_;
      Irow_.Order_Line_No           := Row_.Line_Key;
      Irow_.f_Order_No              := Crow_.Order_No;
      Irow_.f_Line_No               := Crow_.Line_No;
      Irow_.f_Rel_No                := Crow_.Rel_No;
      Irow_.f_Line_Item_No          := Crow_.Line_Item_No;
      Irow_.Po_Order_No             := Blrowv02.Po_Order_No;
      Irow_.Po_Line_No              := Blrowv02.Po_Line_No;
      Irow_.Po_Release_No           := Blrowv02.Po_Release_No;
      Irow_.Demand_Order_No         := Blrowv02.Demand_Order_No;
      Irow_.Demand_Rel_No           := Blrowv02.Demand_Rel_No;
      Irow_.Demand_Line_No          := Blrowv02.Demand_Line_No;
      Irow_.Demand_Line_Item_No     := Blrowv02.Demand_Line_Item_No;
      Irow_.Par_Po_Order_No         := Blrowv02.Par_Po_Order_No;
      Irow_.Par_Po_Line_No          := Blrowv02.Par_Po_Line_No;
      Irow_.Par_Po_Release_No       := Blrowv02.Par_Po_Release_No;
      Irow_.Par_Demand_Order_No     := Blrowv02.Par_Demand_Order_No;
      Irow_.Par_Demand_Rel_No       := Blrowv02.Par_Demand_Rel_No;
      Irow_.Par_Demand_Line_No      := Blrowv02.Par_Demand_Line_No;
      Irow_.Par_Demand_Line_Item_No := Blrowv02.Par_Demand_Line_Item_No;
    
      Irow_.Order_No     := Nvl(Irow_.Par_Demand_Order_No,
                                Nvl(Irow_.Demand_Order_No, Irow_.f_Order_No));
      Irow_.Line_No      := Nvl(Irow_.Par_Demand_Line_No,
                                Nvl(Irow_.Demand_Line_No, Irow_.f_Line_No)); --crow_.LINE_NO;
      Irow_.Rel_No       := Nvl(Irow_.Par_Demand_Rel_No,
                                Nvl(Irow_.Demand_Rel_No, Irow_.f_Rel_No));
      Irow_.Line_Item_No := Nvl(Irow_.Par_Demand_Line_Item_No,
                                Nvl(Irow_.Demand_Line_Item_No,
                                    Irow_.f_Line_Item_No));
    
      Irow_.Base_Delplan_No   := Irow_.Delplan_No;
      Irow_.Base_Delplan_Line := Irow_.Base_Delplan_Line;
      --插入数据
      Insert Into Bl_Delivery_Plan_Detial
        (Delplan_No, Delplan_Line)
      Values
        (Irow_.Delplan_No, Irow_.Delplan_Line)
      Returning Rowid Into Objid_;
    
      Update Bl_Delivery_Plan_Detial Set Row = Irow_ Where Rowid = Objid_;
      Savehist__(Objid_, User_Id_, A311_Key_, '录入数据');
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUST_ORDER_LINE_PDELIVE', Objid_);
    
    End If;
    If Doaction_ = 'M' Then
      /*删除*/
    
      Open Cur_ For
        Select t.*
          From Bl_v_Cust_Order_Line_Pdelive t
         Where t.Objid = Row_.Objid;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      End If;
      Close Cur_;
      If Row_.Objversion != Objversion_ Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '数据发生变化，请刷新以后再修改！');
        Return;
      End If;
    
      /*获取有几列发生了修改*/
      Data_  := Rowlist_;
      Pos_   := Instr(Data_, Index_);
      i      := i + 1;
      Mysql_ := 'update BL_DELIVERY_PLAN_DETIAL  set  ';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        v_         := Substr(v_, Pos1_ + 1);
        If Column_Id_ = 'REMARK' Or Column_Id_ = 'QTY_DELIVED' Then
          Mysql_ := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
          If Column_Id_ = 'QTY_DELIVED' Then
            Savehist__(Row_.Objid,
                       User_Id_,
                       A311_Key_,
                       '计划交货数量' || Row_.Qty_Delived || '=>' || v_);
          
          End If;
        End If;
      
      End Loop;
      Mysql_ := Mysql_ || 'modi_date=sysdate,modi_user=''' || User_Id_ ||
                ''' where rowid=''' || Row_.Objid || '''';
    
      Execute Immediate 'begin ' || Mysql_ || ';end;';
      Pkg_a.Setsuccess(A311_Key_,
                       'BL_V_CUST_ORDER_LINE_PDELIVE',
                       Row_.Objid);
    End If;
  
    If Doaction_ = 'D' Then
      /*删除*/
      Open Cur_ For
        Select t.*
          From Bl_v_Cust_Order_Line_Pdelive t
         Where t.Objid = Row_.Objid;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      End If;
      Close Cur_;
      If Row_.Objversion != Objversion_ Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '数据发生变化，请刷新以后再修改！');
        Return;
      End If;
      Savehist__(Row_.Objid,
                 User_Id_,
                 A311_Key_,
                 Row_.Catalog_No || Row_.Catalog_Desc || '被删除');
    
      Delete From Bl_Delivery_Plan_Detial t Where Rowid = Row_.Objid;
      Pkg_a.Setsuccess(A311_Key_,
                       'BL_V_CUST_ORDER_LINE_PDELIVE',
                       Row_.Objid);
    End If;
  
    Return;
  End;
  Procedure Get_Record_By_Line_Key(Line_Key_ In Varchar2,
                                   Record_   Out Bl_Delivery_Plan_Detial_v%Rowtype) Is
    Datalist_ Dbms_Sql.Varchar2_Table;
    Cur_      t_Cursor;
  Begin
    Datalist_ := Pkg_a.Get_Str_List_By_Index(Line_Key_, '-');
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan_Detial_v t
       Where t.Delplan_No = Datalist_(1)
         And t.Delplan_Line = Datalist_(2);
    Fetch Cur_
      Into Record_;
    Close Cur_;
  Exception
    When Others Then
      Return;
    
  End;
  Procedure Get_Record_By_Order_Date(Order_No_     In Varchar2,
                                     Line_No_      In Varchar2,
                                     Rel_No_       In Varchar2,
                                     Line_Item_No_ In Number,
                                     Date_Delived  Date,
                                     Record_       Out Bl_Delivery_Plan_Detial_v%Rowtype) Is
    Cur_ t_Cursor;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan_Detial_v t
       Where t.Order_No = Order_No_
         And t.Line_No = Line_No_
         And t.Rel_No = Rel_No_
         And t.Line_Item_No = Line_Item_No_
         And t.Delived_Date = Date_Delived
         And t.State In ('1', '2'); --确认和提交的交货计划
    Fetch Cur_
      Into Record_;
    Close Cur_;
  Exception
    When Others Then
      Return;
    
  End;
  Procedure Get_Record_d_o_(Delplan_No_   In Varchar2,
                            Order_No_     In Varchar2,
                            Line_No_      In Varchar2,
                            Rel_No_       In Varchar2,
                            Line_Item_No_ In Number,
                            Record_       Out Bl_Delivery_Plan_Detial_v%Rowtype) Is
    Cur_ t_Cursor;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan_Detial_v t
       Where t.Delplan_No = Delplan_No_
         And t.Order_No = Order_No_
         And t.Line_No = Line_No_
         And t.Rel_No = Rel_No_
         And t.Line_Item_No = Line_Item_No_; --确认和提交的交货计划
    Fetch Cur_
      Into Record_;
    Close Cur_;
  Exception
    When Others Then
      Return;
    
  End;

  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2) Is
    Row_     Bl_v_Cust_Order_Line_Pdelive%Rowtype;
    Mainrow_ Bl_v_Cust_Order_Line_Phdelive%Rowtype;
    Frow_    Bl_v_Customer_Order_V02%Rowtype;
    Crow_    Bl_v_Cust_Ord_Line_V01%Rowtype;
    Cur_     t_Cursor;
    Attr_Out Varchar2(4000);
  Begin
    --  BL
    If Column_Id_ = 'CATALOG_NO' Then
      Row_.Delplan_No := Pkg_a.Get_Item_Value('DELPLAN_NO', Rowlist_);
      Open Cur_ For
        Select t.*
          From Bl_v_Cust_Order_Line_Phdelive t
         Where t.Delplan_No = Row_.Delplan_No;
      Fetch Cur_
        Into Mainrow_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的产品编码');
      End If;
      Close Cur_;
    
      Row_.Catalog_No := Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_);
      Open Cur_ For
        Select t.*
          From Bl_v_Cust_Ord_Line_V01 t
         Where t.Catalog_No = Row_.Catalog_No
           And t.Blorder_No = Mainrow_.Blorder_No
           And t.Contract = Mainrow_.Supplier
           And t.Buy_Qty_Due > Qty_Planned;
      Fetch Cur_
        Into Crow_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的产品编码');
      End If;
      Close Cur_;
    
      Pkg_a.Set_Item_Value('ORDER_NO', Crow_.Order_No, Attr_Out);
      Pkg_a.Set_Item_Value('LINE_NO', Crow_.Line_No, Attr_Out);
      Pkg_a.Set_Item_Value('REL_NO', Crow_.Rel_No, Attr_Out);
      Pkg_a.Set_Item_Value('LINE_ITEM_NO', Crow_.Line_Item_No, Attr_Out);
      Pkg_a.Set_Item_Value('CATALOG_DESC', Crow_.Catalog_Desc, Attr_Out);
      Pkg_a.Set_Item_Value('BUY_QTY_DUE', Crow_.Buy_Qty_Due, Attr_Out);
      Pkg_a.Set_Item_Value('LINE_KEY', Crow_.Line_Key, Attr_Out);
      Row_.Qty_Delived := Pkg_a.Get_Item_Value('QTY_DELIVED', Rowlist_);
      If Nvl(Row_.Qty_Delived, 0) = 0 Then
        Pkg_a.Set_Item_Value('QTY_DELIVED',
                             Crow_.Buy_Qty_Due - Crow_.Qty_Planned,
                             Attr_Out);
      End If;
    
    End If;
  
    If Column_Id_ = 'LINE_KEY' Then
      Row_.Line_Key := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
      Open Cur_ For
        Select t.*
          From Bl_v_Cust_Ord_Line_V01 t
         Where t.Line_Key = Row_.Line_Key;
      Fetch Cur_
        Into Crow_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的关键字');
      End If;
      Close Cur_;
    
      Pkg_a.Set_Item_Value('ORDER_NO', Crow_.Order_No, Attr_Out);
      Pkg_a.Set_Item_Value('LINE_NO', Crow_.Line_No, Attr_Out);
      Pkg_a.Set_Item_Value('REL_NO', Crow_.Rel_No, Attr_Out);
      Pkg_a.Set_Item_Value('LINE_ITEM_NO', Crow_.Line_Item_No, Attr_Out);
      Pkg_a.Set_Item_Value('CATALOG_NO', Crow_.Catalog_No, Attr_Out);
      Pkg_a.Set_Item_Value('CATALOG_DESC', Crow_.Catalog_Desc, Attr_Out);
      Pkg_a.Set_Item_Value('BUY_QTY_DUE', Crow_.Buy_Qty_Due, Attr_Out);
      Row_.Qty_Delived := Pkg_a.Get_Item_Value('QTY_DELIVED', Rowlist_);
      If Nvl(Row_.Qty_Delived, 0) = 0 Then
        Pkg_a.Set_Item_Value('QTY_DELIVED',
                             Crow_.Buy_Qty_Due - Crow_.Qty_Planned,
                             Attr_Out);
      End If;
    
    End If;
    Outrowlist_ := Attr_Out;
    Return;
  End;
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2 Is
    Cur_ t_Cursor;
    Row_ Bl_v_Cust_Order_Line_Phdelive%Rowtype;
  Begin
  
    Open Cur_ For
      Select t.*
        From Bl_v_Cust_Order_Line_Phdelive t
       Where t.Delplan_No = Order_No_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Return '0';
    End If;
    Close Cur_;
    If Row_.Type_Id = 'AUTO' Then
      Return '0';
    End If;
    If (Row_.Pstate = '0') Then
      Return '1';
    End If;
    Return '0';
  End;
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    Row_ Bl_v_Cust_Order_Line_Pdelive%Rowtype;
  Begin
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Row_.State := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    If Nvl(Row_.Objid, 'NULL') != 'NULL' Then
      If Column_Id_ = 'REMARK' Or Column_Id_ = 'QTY_DELIVED' Then
        If Row_.State != '0' And Column_Id_ = 'QTY_DELIVED' Then
          Return '0';
        End If;
        Return '1';
      End If;
      Return '0';
    End If;
    Return '1';
  End;

End Bldelivery_Plan_Line_Api;
/
