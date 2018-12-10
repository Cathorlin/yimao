Create Or Replace Package Bldelivery_Plan_Api Is

  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);
  --保存
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);

  Procedure Remove__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  --交货计划下达       
  Procedure Release__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --交货计划取消下达
  Procedure Releasecancel__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2);

  Procedure Approve__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --交货计划确认 Rowlist_ order_no || '-' || contract
  Procedure Approvesu__(Rowlist_  Varchar2,
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
  --根据明细修改头
  Procedure Modifymain__(Vrow_ In Out Bl_Delivery_Plan_Detial%Rowtype);
  Procedure Delivery_Autopicklist__(Rowlist_  Varchar2,
                                    User_Id_  Varchar2,
                                    A311_Key_ Varchar2);
  --获取交货 订单 工厂 日期 的 交货计划 
  Procedure Get_Record_By_Order_Date(Order_No_     In Varchar2,
                                     Supplier_     In Varchar2,
                                     Date_Deliever In Date,
                                     Record_       Out Bl_Delivery_Plan_v%Rowtype);
  --交货计划版本升级
  Procedure Update_Version(Base_Delplan_No_ In Varchar2,
                           User_Id_         In Varchar2,
                           Outmainrow_      Out Bl_Delivery_Plan_v%Rowtype);

  --修改交货计划 交期
  Procedure Change_Date(Delplan_No_ In Varchar2,
                        User_Id_    In Varchar2,
                        Newdate_    In Date,
                        Outmainrow_ Out Bl_Delivery_Plan_v%Rowtype);
  --修改明细状态更新 主档状态
  Procedure Setmainstate(Delplan_No_   In Varchar2,
                         Delplan_Line_ In Varchar2,
                         State_        In Varchar2);
  --获取交货是否有明细数据
  Function Get_Have_Child(Delplan_No_ In Varchar2) Return Varchar2;
  --获取交货计划的类型
  Function Get_Type_Id(Delplan_No_ In Varchar2) Return Varchar2;

  --获取交货计划状态
  Function Get_State_(Order_No_ In Varchar2, Supplier_ In Varchar2)
    Return Varchar2;
End Bldelivery_Plan_Api;
/
Create Or Replace Package Body Bldelivery_Plan_Api Is
  Type t_Cursor Is Ref Cursor;
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
    Mainrow_    Bl_v_Cust_Order_Line_Phd%Rowtype;
    Row_        Bl_v_Cust_Order_Line_Phdelive%Rowtype;
    Baserow_    Bl_v_Customer_Order_V02%Rowtype;
    Corow_      Bl_v_Customer_Order_V03%Rowtype;
    Cur_        t_Cursor;
    Attr_Out    Varchar2(4000);
    Sum_Qty     Number;
    Requesturl_ Varchar2(4000);
    Type_       Varchar2(10);
  Begin
    Requesturl_ := Pkg_a.Get_Item_Value('REQUESTURL', Rowlist_);
    Type_       := Pkg_a.Get_Item_Value_By_Index('&TYPE=', '&', Requesturl_);
    If Type_ = '1' Then
      Corow_.Blorder_No := Pkg_a.Get_Item_Value_By_Index('&BLORDER_NO=',
                                                         '&',
                                                         Requesturl_);
      Corow_.Contract   := Pkg_a.Get_Item_Value_By_Index('&CONTRACT=',
                                                         '&',
                                                         Requesturl_);
    
      Pkg_a.Set_Item_Value('BLORDER_NO', Corow_.Blorder_No, Attr_Out);
      Pkg_a.Set_Item_Value('SUPPLIER', Corow_.Contract, Attr_Out);
      Open Cur_ For
        Select t.*
          From Bl_v_Customer_Order_V03 t
         Where t.Blorder_No = Corow_.Blorder_No
           And t.Supplier = Corow_.Contract;
      Fetch Cur_
        Into Corow_;
      If Cur_%Notfound Then
        Close Cur_;
        Return;
      End If;
      Close Cur_;
      Pkg_a.Set_Item_Value('ORDER_NO', Corow_.Order_No, Attr_Out);
      Pkg_a.Set_Item_Value('CONTRACT', Corow_.Contract, Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_NO', Corow_.Customer_No, Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_NAME', Corow_.Customer_Name, Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_REF', Corow_.Cust_Ref, Attr_Out);
      Pkg_a.Set_Item_Value('LABEL_NOTE', Corow_.Label_Note, Attr_Out);
      Pkg_a.Set_Item_Value('ORDER_ID', Corow_.Order_Id, Attr_Out);
      Pkg_a.Set_Item_Value('WANTED_DELIVERY_DATE',
                           To_Char(Corow_.Wanted_Delivery_Date,
                                   'YYYY-MM-DD'),
                           Attr_Out);
      Select Max(t.Column_No)
        Into Corow_.Additional_Discount
        From Bl_Delivery_Plan t
       Where t.Order_No = Corow_.Order_No;
      Pkg_a.Set_Item_Value('COLUMN_NO',
                           To_Char(Nvl(Corow_.Additional_Discount, 0) + 1),
                           Attr_Out);
    Else
      Row_.Contract := Pkg_Attr.Get_Default_Contract(User_Id_);
      If (Nvl(Row_.Contract, '0') <> '0') Then
        Pkg_a.Set_Item_Value('SUPPLIER', Row_.Contract, Attr_Out);
      End If;
      Row_.Type_Id := 'CUSTOMER';
      Pkg_a.Set_Item_Value('TYPE_ID', Row_.Type_Id, Attr_Out);
    
      Pkg_a.Setresult(A311_Key_, Attr_Out);
      Return;
      Mainrow_.Order_Line_No := Pkg_a.Get_Item_Value('ORDER_LINE_NO',
                                                     Rowlist_);
      Open Cur_ For
        Select t.*
          Into Mainrow_
          From Bl_v_Cust_Order_Line_Phd t
         Where t.Order_Line_No = Mainrow_.Order_Line_No;
      Fetch Cur_
        Into Mainrow_;
      If Cur_%Notfound Then
        Close Cur_;
        Return;
      End If;
      Close Cur_;
    
      Open Cur_ For
        Select t.*
          From Bl_v_Customer_Order_V02 t
         Where t.Order_No = Mainrow_.Order_No
           And t.Line_No = Mainrow_.Line_No
           And t.Rel_No = Mainrow_.Rel_No
           And t.Line_Item_No = Mainrow_.Line_Item_No;
      Fetch Cur_
        Into Baserow_;
      If Cur_%Notfound Then
        Close Cur_;
        Return;
      End If;
      Close Cur_;
    
      Pkg_a.Set_Item_Value('ORDER_LINE_NO',
                           Mainrow_.Order_Line_No,
                           Attr_Out);
    
      Pkg_a.Set_Item_Value('ORDER_NO',
                           Nvl(Baserow_.Par_Demand_Order_No,
                               Nvl(Baserow_.Demand_Order_No,
                                   Baserow_.Order_No)),
                           Attr_Out);
      Pkg_a.Set_Item_Value('LINE_NO',
                           Nvl(Baserow_.Par_Demand_Line_No,
                               Nvl(Baserow_.Demand_Line_No, Baserow_.Line_No)),
                           Attr_Out);
      Pkg_a.Set_Item_Value('REL_NO',
                           Nvl(Baserow_.Par_Demand_Rel_No,
                               Nvl(Baserow_.Demand_Rel_No, Baserow_.Rel_No)),
                           Attr_Out);
    
      Pkg_a.Set_Item_Value('LINE_ITEM_NO',
                           Nvl(Baserow_.Par_Demand_Line_Item_No,
                               Nvl(Baserow_.Demand_Line_Item_No,
                                   Baserow_.Line_Item_No)),
                           Attr_Out);
    
      Pkg_a.Set_Item_Value('F_ORDER_NO', Baserow_.Order_No, Attr_Out);
      Pkg_a.Set_Item_Value('F_LINE_NO', Baserow_.Line_No, Attr_Out);
      Pkg_a.Set_Item_Value('F_REL_NO', Baserow_.Rel_No, Attr_Out);
      Pkg_a.Set_Item_Value('F_LINE_ITEM_NO',
                           Baserow_.Line_Item_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PO_ORDER_NO', Baserow_.Po_Order_No, Attr_Out);
      Pkg_a.Set_Item_Value('PO_LINE_NO', Baserow_.Po_Line_No, Attr_Out);
      Pkg_a.Set_Item_Value('PO_RELEASE_NO',
                           Baserow_.Po_Release_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('ORDER_LINE_PO',
                           Baserow_.Po_Order_No || '-' ||
                           Baserow_.Po_Line_No || '-' ||
                           Baserow_.Po_Release_No,
                           Attr_Out);
    
      Pkg_a.Set_Item_Value('ORDER_DEMAND',
                           Baserow_.Demand_Order_No || '-' ||
                           Baserow_.Demand_Rel_No || '-' ||
                           Baserow_.Demand_Line_No || '-' ||
                           To_Char(Baserow_.Demand_Line_Item_No),
                           Attr_Out);
      Pkg_a.Set_Item_Value('DEMAND_ORDER_NO',
                           Baserow_.Demand_Order_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('DEMAND_REL_NO',
                           Baserow_.Demand_Rel_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('DEMAND_LINE_NO',
                           Baserow_.Demand_Line_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('DEMAND_LINE_ITEM_NO',
                           Baserow_.Demand_Line_Item_No,
                           Attr_Out);
    
      Pkg_a.Set_Item_Value('ORDER_LINE_PAR_PO',
                           Baserow_.Par_Po_Order_No || '-' ||
                           Baserow_.Par_Po_Line_No || '-' ||
                           Baserow_.Par_Po_Release_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PAR_PO_ORDER_NO',
                           Baserow_.Par_Po_Order_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PAR_PO_LINE_NO',
                           Baserow_.Par_Po_Line_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PAR_PO_RELEASE_NO',
                           Baserow_.Par_Po_Release_No,
                           Attr_Out);
    
      Pkg_a.Set_Item_Value('ORDER_PAR_DEMAND',
                           Baserow_.Par_Demand_Order_No || '-' ||
                           Baserow_.Par_Demand_Rel_No || '-' ||
                           Baserow_.Par_Demand_Line_No || '-' ||
                           To_Char(Baserow_.Par_Demand_Line_Item_No),
                           Attr_Out);
      Pkg_a.Set_Item_Value('PAR_DEMAND_ORDER_NO',
                           Baserow_.Par_Demand_Order_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PAR_DEMAND_REL_NO',
                           Baserow_.Par_Demand_Rel_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PAR_DEMAND_LINE_NO',
                           Baserow_.Par_Demand_Line_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PAR_DEMAND_LINE_ITEM_NO',
                           Baserow_.Par_Demand_Line_Item_No,
                           Attr_Out);
    
      Pkg_a.Set_Item_Value('STATE', '0', Attr_Out);
    
      Pkg_a.Set_Item_Value('COLUMN_NO', '[ROWNUM]', Attr_Out);
    
      Select Sum(t.Qty_Delived)
        Into Sum_Qty
        From Bl_Delivery_Plan_Detial t
       Where t.Order_No = Baserow_.Order_No
         And t.Line_No = Baserow_.Line_No
         And t.Rel_No = Baserow_.Rel_No
         And t.Line_Item_No = Baserow_.Line_Item_No;
      Sum_Qty := Nvl(Sum_Qty, 0);
    
      Pkg_a.Set_Item_Value('QTY_DELIVED',
                           Baserow_.Buy_Qty_Due - Sum_Qty,
                           Attr_Out);
    End If;
    Pkg_a.Setresult(A311_Key_, Attr_Out);
  
    Return;
  End;
  --保存
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
  
    Row_   Bl_v_Cust_Order_Line_Phdelive%Rowtype;
    Irow_  Bl_Delivery_Plan%Rowtype;
    Irow0_ Bl_Delivery_Plan%Rowtype;
    --mainrow_ customer_order_line%rowtype;
    --action_  varchar2(100);
    Index_     Varchar2(1);
    Cur_       t_Cursor;
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar2(1000);
    Column_Id_ Varchar2(1000);
    Data_      Varchar2(4000);
    Doaction_  Varchar2(10);
    Mysql_     Varchar2(2000);
    --sum_qty number;
    If_Datechange Varchar2(1);
  Begin
    -- insert into a0(col)
    -- select ROWLIST_ 
    -- from dual  ;
    Index_     := f_Get_Data_Index();
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_  := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    If Doaction_ = 'I' Then
      /*新增*/
    
      Row_.Contract := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Row_.Supplier := Pkg_a.Get_Item_Value('SUPPLIER', Rowlist_);
    
      Bl_Customer_Order_Api.Getseqno(To_Char(Sysdate, 'YY') ||
                                     Row_.Supplier,
                                     User_Id_,
                                     8,
                                     Irow_.Delplan_No);
      Irow_.Order_No     := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
      Irow_.Column_No    := Pkg_a.Get_Item_Value('COLUMN_NO', Rowlist_);
      Irow_.Delived_Date := To_Date(Pkg_a.Get_Item_Value('DELIVED_DATE',
                                                         Rowlist_),
                                    'YYYY-MM-DD');
      Irow_.Customer_Ref := Pkg_a.Get_Item_Value('LABEL_NOTE', Rowlist_);
      Irow_.Contract     := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Irow_.Customer_No  := Pkg_a.Get_Item_Value('CUSTOMER_NO', Rowlist_);
      --检测 一个工厂 一个订单 一个 交期只能有一个交货计划
    
      Irow_.Version         := '1';
      Irow_.State           := '0';
      Irow_.Type_Id         := 'CUSTOMER';
      Irow_.Enter_User      := User_Id_;
      Irow_.Enter_Date      := Sysdate;
      Irow_.Supplier        := Pkg_a.Get_Item_Value('SUPPLIER', Rowlist_);
      Irow_.Delplan_Line    := 0;
      Irow_.Base_Delplan_No := Irow_.Delplan_No; --原始交货计划号
      Open Cur_ For
        Select t.*
          From Bl_Delivery_Plan t
         Where t.Order_No = Irow_.Order_No
           And t.Supplier = Irow_.Supplier
           And t.Delived_Date = Irow_.Delived_Date;
      Fetch Cur_
        Into Irow0_;
      If Cur_%Found Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                To_Char(Irow_.Delived_Date, 'YYYY-MM-DD') ||
                                '已存在交货计划' || Irow0_.Delplan_No || '!');
        Return;
      End If;
      Close Cur_;
      Open Cur_ For
        Select t.*
          From Bl_Delivery_Plan t
         Where t.Order_No = Irow_.Order_No
           And t.Supplier = Irow_.Supplier
           And t.State <> '0';
      Fetch Cur_
        Into Irow0_;
      If Cur_%Found Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                Irow_.Order_No || '已存在交货计划' ||
                                Irow0_.Delplan_No || '!');
        Return;
      End If;
      Close Cur_;
    
      --  SUPPLIER,CUSTOMER
      Select Max(t.Column_No)
        Into Irow_.Column_No
        From Bl_Delivery_Plan t
       Where t.Order_No = Irow_.Order_No
         And t.Supplier = Irow_.Supplier;
    
      Irow_.Column_No := Nvl(Irow_.Column_No, 0) + 1;
    
      Insert Into Bl_Delivery_Plan
        (Delplan_No, Enter_User, Enter_Date)
      Values
        (Irow_.Delplan_No, Irow_.Enter_User, Irow_.Enter_Date)
      Returning Rowid Into Row_.Objid;
    
      Update Bl_Delivery_Plan Set Row = Irow_ Where Rowid = Row_.Objid;
    
      Pkg_a.Setsuccess(A311_Key_,
                       'BL_V_CUST_ORDER_LINE_PHDELIVE',
                       Row_.Objid);
    
      Return;
    End If;
    If Doaction_ = 'M' Then
      Open Cur_ For
        Select t.*
          From Bl_v_Cust_Order_Line_Phdelive t
         Where t.Objid = Row_.Objid;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      End If;
      Close Cur_;
      Data_         := Rowlist_;
      Pos_          := Instr(Data_, Index_);
      i             := i + 1;
      Mysql_        := 'update BL_DELIVERY_PLAN  set  ';
      If_Datechange := '0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_         := Substr(Data_, 1, Pos_ - 1);
        Data_      := Substr(Data_, Pos_ + 1);
        Pos_       := Instr(Data_, Index_);
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        v_         := Substr(v_, Pos1_ + 1);
        If Column_Id_ = 'DELIVED_DATE' Or Column_Id_ = 'REMARK' Then
          If Column_Id_ = 'DELIVED_DATE' Then
            If_Datechange     := '1';
            Row_.Delived_Date := To_Date(v_, 'YYYY-MM-DD HH24:MI:SS');
            Mysql_            := Mysql_ || ' ' || Column_Id_ ||
                                 '=to_date(''' || v_ ||
                                 ''',''YYYY-MM-DD HH24:MI:SS''),';
          Else
            Mysql_ := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
          End If;
        End If;
      End Loop;
    
      If If_Datechange = '1' Then
        Open Cur_ For
          Select t.*
            From Bl_Delivery_Plan t
           Where t.Order_No = Row_.Order_No
             And t.Supplier = Row_.Supplier
             And t.Delived_Date = Row_.Delived_Date
             And t.Delplan_No <> Row_.Delplan_No;
        Fetch Cur_
          Into Irow0_;
        If Cur_%Found Then
          Close Cur_;
          Raise_Application_Error(-20101,
                                  To_Char(Row_.Delived_Date, 'YYYY-MM-DD') ||
                                  '已存在交货计划' || Row_.Delplan_No || '!');
          Return;
        End If;
        Close Cur_;
        Mysql_ := Mysql_ || 'modi_date=sysdate,modi_user=''' || User_Id_ ||
                  ''' where rowid=''' || Row_.Objid || '''';
        Execute Immediate 'begin ' || Mysql_ || ';end;';
      
        Update Bl_Delivery_Plan_Detial t
           Set t.Delived_Date = Row_.Delived_Date
         Where t.Delplan_No = Row_.Delplan_No;
      Else
        Mysql_ := Mysql_ || 'modi_date=sysdate,modi_user=''' || User_Id_ ||
                  ''' where rowid=''' || Row_.Objid || '''';
        Execute Immediate 'begin ' || Mysql_ || ';end;';
      End If;
    
    End If;
  
    /*  if doaction_ = 'M' then  \*修改*\
        
         open cur_
         for select t.*
         from    BL_V_CUST_ORDER_LINE_PDD t
         where  t.OBJID =   vrow_.OBJID;
         fetch cur_     into vrow_   ;
         if cur_%notfound then           
            raise_application_error(-20101, '错误的rowid');
            return ;
         end if ;    
         close cur_ ;
         if row_.state <> '0' then
            raise_application_error(-20101, '当前的交货计划已经被确认，不能更改！');
            return ;
         end if ;  
         
         select t.*
         into row_
         from   BL_DELIVERY_PLAN_DETIAL t
         where t.rowid = vrow_.OBJID;
         \*获取有几列发生了修改*\
         data_ := ROWLIST_;
         pos_ := instr(data_,index_);
         i := i + 1 ;
         mysql_ := 'update BL_DELIVERY_PLAN_DETIAL  set  '  ;
         
     
       loop 
           exit when nvl(pos_,0) <=0 ;
           exit when i > 300 ;      
           v_ := substr(data_,1,pos_ - 1 ); 
           data_ := substr(data_,pos_ +  1 ) ;
           pos_ := instr(data_,index_);           
           pos1_ :=  instr(v_,'|');     
           column_id_ := substr(v_,1 ,pos1_ - 1 );
               
           v_ := substr(v_, pos1_ +  1 ) ;
           if   column_id_ = 'DELIVED_DATE'  
             or column_id_ = 'REMARK' 
             or column_id_ = 'QTY_DELIVED' 
              then
               if column_id_ = 'DELIVED_DATE' then
                  row_.delived_date := to_date(v_,'YYYY-MM-DD HH24:MI:SS');                 
                  mysql_ := mysql_ || ' ' || column_id_ || '=to_date(''' || v_  || ''',''YYYY-MM-DD HH24:MI:SS''),'; 
               else                 
                  mysql_ := mysql_ || ' ' || column_id_ || '=''' || v_  || ''',';     
               end if ;
            end if ;   
          end  loop ;
           mysql_ := mysql_ || 'modi_date=sysdate,modi_user='''|| user_id_ ||''' where rowid=''' || vrow_.OBJID || '''' ;
           ModifyMain__(row_);     
           --raise_application_error(-20101, mysql_);
           execute immediate 'begin ' || mysql_ || ';end;' ;
           --读取数量是否溢出
           --获取行的总数量                
           select sum(t.qty_delived)
           into   sum_qty
           from  BL_DELIVERY_PLAN_DETIAL t
           where t.ORDER_NO = vrow_.order_no
           and   t.LINE_NO =  vrow_.LINE_NO
           and   t.REL_NO = vrow_.REL_NO
           and   t.LINE_ITEM_NO = vrow_.LINE_ITEM_NO;               
           sum_qty := nvl(sum_qty,0);
                 --获取总数量
            open cur_ for select t.* 
            into mainrow_ 
            from CUSTOMER_ORDER_LINE t
            where t.ORDER_NO = vrow_.order_no
            and   t.LINE_NO =  vrow_.LINE_NO
            and   t.REL_NO = vrow_.REL_NO
            and   t.LINE_ITEM_NO = vrow_.LINE_ITEM_NO;         
            fetch cur_ into mainrow_;
            if cur_%notfound then
               close cur_;
               raise_application_error(-20101,'错误的订单号' || row_.order_no );
            end if;
            close cur_;
            if (sum_qty ) > mainrow_.buy_qty_due then           
                raise_application_error(-20101,'累计计划数量过多'  );
            end if ;
          
         
           pkg_a.setSuccess(A311_KEY_,'BL_V_CUST_ORDER_LINE_PDD',vrow_.OBJID);
    
         
         
         RETURN;
    end if ; 
     */
  
  End;

  --根据明细设置主档的状态
  Procedure Setmainstate(Delplan_No_   In Varchar2,
                         Delplan_Line_ In Varchar2,
                         State_        In Varchar2) Is
    Cur_ t_Cursor;
  Begin
  
    Update Bl_Delivery_Plan_Detial t
       Set State = State_
     Where t.Delplan_No = Delplan_No_
       And t.Delplan_Line = Delplan_Line_;
  
    Delete From Bl_Delivery_Plan_Detial
     Where Delplan_No = Delplan_No_
       And Qty_Delived = 0;
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan_Detial t
       Where t.Delplan_No = Delplan_No_
         And t.State <> State_;
    If Cur_%Notfound Then
      Update Bl_Delivery_Plan
         Set State = State_
       Where Delplan_No = Delplan_No_;
    End If;
    Close Cur_;
  
    Return;
  End;

  Procedure Modifymain__(Vrow_ In Out Bl_Delivery_Plan_Detial%Rowtype) Is
    Cur_ t_Cursor;
    Row_ Bl_Delivery_Plan%Rowtype;
  Begin
    If Nvl(Vrow_.Par_Demand_Order_No, '0') <> '0' Then
      Row_.Delplan_No := Vrow_.Par_Demand_Order_No ||
                         To_Char(Vrow_.Delived_Date, 'YYYYMMDD');
      Open Cur_ For
        Select t.*
          From Bl_Delivery_Plan t
         Where t.Delplan_No = Row_.Delplan_No;
      Fetch Cur_
        Into Row_;
      If Cur_%Found Then
        Close Cur_;
        If Row_.State <> '0' Then
          Raise_Application_Error(-20101,
                                  '订单' || Vrow_.Par_Demand_Order_No ||
                                  '计划交货日期' ||
                                  To_Char(Vrow_.Delived_Date, 'YYYY-MM-DD') ||
                                  '的数据已经确认，不能修改了');
        End If;
        Vrow_.Delplan_No := Row_.Delplan_No;
        Return;
      End If;
      Row_.Type_Id := 'CO';
      Open Cur_ For
        Select t.Order_No, t.Customer_No, t.Cust_Ref, t.Contract
          From Customer_Order_Tab t
         Where t.Order_No = Vrow_.Par_Demand_Order_No;
      Fetch Cur_
        Into Row_.Order_No,
             Row_.Customer_No,
             Row_.Customer_Ref,
             Row_.Contract;
      Close Cur_;
    Else
      Row_.Delplan_No := Vrow_.Par_Po_Order_No ||
                         To_Char(Vrow_.Delived_Date, 'YYYYMMDD');
      Open Cur_ For
        Select t.*
          From Bl_Delivery_Plan t
         Where t.Delplan_No = Row_.Delplan_No;
      Fetch Cur_
        Into Row_;
      If Cur_%Found Then
        Close Cur_;
        If Row_.State <> '0' Then
          Raise_Application_Error(-20101,
                                  '采购订单' || Vrow_.Par_Po_Order_No ||
                                  '计划交货日期' ||
                                  To_Char(Vrow_.Delived_Date, 'YYYY-MM-DD') ||
                                  '的数据已经确认，不能修改了');
        End If;
        Vrow_.Delplan_No := Row_.Delplan_No;
        Return;
      End If;
      Row_.Type_Id := 'PO';
      Open Cur_ For
        Select t.Order_No, '' As Customer_No, '' As Cust_Ref, t.Contract
          From Purchase_Order t
         Where t.Order_No = Vrow_.Par_Po_Order_No;
      Fetch Cur_
        Into Row_.Order_No,
             Row_.Customer_No,
             Row_.Customer_Ref,
             Row_.Contract;
      Close Cur_;
    End If;
    Vrow_.Delplan_No  := Row_.Delplan_No;
    Row_.Enter_User   := Vrow_.Enter_User;
    Row_.Enter_Date   := Sysdate;
    Row_.Delived_Date := Vrow_.Delived_Date;
    Row_.State        := '0';
    Row_.Version      := '0';
  
    Insert Into Bl_Delivery_Plan
      (Delplan_No, Enter_User, Enter_Date)
      Select Row_.Delplan_No, Row_.Enter_User, Row_.Enter_Date From Dual;
  
    Update Bl_Delivery_Plan
       Set Row = Row_
     Where Delplan_No = Row_.Delplan_No;
  
  End;

  Procedure Remove__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Row_  Bl_v_Cust_Order_Line_Phdelive%Rowtype;
    Cur_  t_Cursor;
    Drow_ Bl_Delivery_Plan_Detial%Rowtype;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_v_Cust_Order_Line_Phdelive t
       Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    If Row_.Pstate <> '1' Then
      Raise_Application_Error(-20101, '只有下达状态才能确认！');
      Return;
    End If;
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan_Detial t
       Where t.Delplan_No = Row_.Delplan_No
         And t.State <> '1';
    Fetch Cur_
      Into Drow_;
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(-20101, '存在非下达状态明细行，不能确认！');
      Return;
    End If;
    Close Cur_;
  
    Update Bl_Delivery_Plan t
       Set t.State = '2', t.Modi_User = User_Id_, t.Modi_Date = Sysdate
     Where t.Rowid = Row_.Objid;
  
    Update Bl_Delivery_Plan_Detial t
       Set t.State = '2', t.Modi_User = User_Id_, t.Modi_Date = Sysdate
     Where t.Delplan_No = Row_.Delplan_No;
  
    Pkg_a.Setsuccess(A311_Key_,
                     'BL_V_CUST_ORDER_LINE_PHDELIVE',
                     Row_.Objid);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '交货计划' || Row_.Delplan_No || '确认成功');
    Return;
  End;
  --交货计划下达
  Procedure Release__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
    Row_    Bl_v_Cust_Order_Line_Phdelive%Rowtype;
    Crow_   Bl_v_Cust_Ord_Line_V01%Rowtype;
    Cur_    t_Cursor;
    Cur_d   t_Cursor;
    Irow_   Bl_Delivery_Plan%Rowtype;
    Idrow_  Bl_Delivery_Plan_Detial_v%Rowtype;
    Column_ Number;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_v_Cust_Order_Line_Phdelive t
       Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    --
    Open Cur_d For
      Select t.*
        From Bl_Delivery_Plan_Detial_v t
       Where t.Delplan_No = Row_.Delplan_No;
    Fetch Cur_d
      Into Idrow_;
    --没有明细行 删除 表头
    If Cur_d%Notfound Then
      Close Cur_d;
      Raise_Application_Error(-20101, '当前交货计划没有明细行，不能下达！');
      Return;
    End If;
    Close Cur_d;
  
    --检测数量是否一致
    Open Cur_ For
      Select t.*
        From Bl_v_Cust_Ord_Line_V01 t
       Where t.Blorder_No = Row_.Blorder_No
         And t.Contract = Row_.Supplier
         And t.State <> 'Cancelled'
         And t.Buy_Qty_Due <> t.Qty_Planned;
    Fetch Cur_
      Into Crow_;
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(-20101,
                              Crow_.Line_Key || '的' || Crow_.Catalog_No ||
                              '计划交货数量' || To_Char(Crow_.Qty_Planned) ||
                              '不等于销售数量' || To_Char(Crow_.Buy_Qty_Due) ||
                              ',不能下达！');
      Return;
    End If;
    Close Cur_;
  
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan t
       Where t.Order_No = Row_.Order_No
         And t.Supplier = Row_.Supplier
       Order By t.Delived_Date Asc;
    Fetch Cur_
      Into Irow_;
    Column_ := 0;
    Loop
      Exit When Cur_%Notfound;
      Open Cur_d For
        Select t.*
          From Bl_Delivery_Plan_Detial_v t
         Where t.Delplan_No = Irow_.Delplan_No
           And t.State <> '3';
      Fetch Cur_d
        Into Idrow_;
      --没有明细行 删除 表头
      If Cur_d%Notfound Then
        Delete From Bl_Delivery_Plan t
         Where t.Delplan_No = Irow_.Delplan_No;
      Else
        Column_ := Column_ + 1;
      End If;
      Update Bl_Delivery_Plan t
         Set t.State     = '1',
             t.Modi_User = User_Id_,
             t.Modi_Date = Sysdate,
             t.Column_No = Column_,
             t.Msg_User  = User_Id_
       Where t.Delplan_No = Irow_.Delplan_No;
      Loop
        Exit When Cur_d%Notfound;
        If Idrow_.Qty_Delived < 0 Then
          Raise_Application_Error(-20101,
                                  '计划交货数量(' || To_Char(Idrow_.Qty_Delived) ||
                                  ')是负数,不能下达！');
        
        End If;
        Update Bl_Delivery_Plan_Detial t
           Set t.State     = '1',
               t.Modi_User = User_Id_,
               t.Modi_Date = Sysdate,
               t.Column_No = Column_
         Where t.Rowid = Idrow_.Objid;
      
        Bldelivery_Plan_Line_Api.Savehist__(Idrow_.Objid,
                                            User_Id_,
                                            A311_Key_,
                                            '下达');
        Fetch Cur_d
          Into Idrow_;
      End Loop;
      Close Cur_d;
    
      Fetch Cur_
        Into Irow_;
    End Loop;
    Close Cur_;
  
    Pkg_a.Setsuccess(A311_Key_,
                     'BL_V_CUST_ORDER_LINE_PHDELIVE',
                     Row_.Order_No || '-' || Row_.Supplier);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '交货计划[' || Row_.Order_No || '-' || Row_.Supplier ||
                 ']下达成功');
    Return;
  End;
  --获取交货计划状态
  Function Get_State_(Order_No_ In Varchar2, Supplier_ In Varchar2)
    Return Varchar2
  
   Is
    Res_ Varchar(30);
  
    Cur_    t_Cursor;
    Oldres_ Varchar(30);
  Begin
    Open Cur_ For
      Select t.State
        From Bl_Delivery_Plan t
       Where t.Order_No = Order_No_
         And t.Supplier = Supplier_
         And t.State <> '3'
       Order By t.State;
    Fetch Cur_
      Into Res_;
    Oldres_ := Res_;
    Loop
      Exit When Cur_%Notfound;
      If Instr(Oldres_, Res_) = 0 Then
        Oldres_ := Oldres_ || Res_;
      End If;
      Fetch Cur_
        Into Res_;
    End Loop;
    Close Cur_;
    Return Oldres_;
  
  End;

  --获取交货是否有明细数据
  Function Get_Type_Id(Delplan_No_ In Varchar2) Return Varchar2 Is
    Res_ Varchar(30);
    Cur_ t_Cursor;
  Begin
    Open Cur_ For
      Select t.Type_Id
        From Bl_Delivery_Plan t
       Where t.Delplan_No = Delplan_No_;
    Fetch Cur_
      Into Res_;
  
    Close Cur_;
    Return Res_;
  
  End;

  Function Get_Have_Child(Delplan_No_ In Varchar2) Return Varchar2 Is
    Cur_          t_Cursor;
    Delplan_Line_ Number;
    Res_          Varchar(1);
  Begin
    Open Cur_ For
      Select t.Delplan_Line
        From Bl_Delivery_Plan_Detial t
       Where t.Delplan_No = Delplan_No_
         And t.State <> '3'
         And t.Qty_Delived > 0;
    Fetch Cur_
      Into Delplan_Line_;
    If Cur_%Found Then
      Res_ := '1';
    Else
      Res_ := '0';
    End If;
    Close Cur_;
    Return Res_;
  End;
  Procedure Releasecancel__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2) Is
    Row_   Bl_v_Cust_Delivery_Plan%Rowtype;
    Cur_   t_Cursor;
    Cur_d  t_Cursor;
    Irow_  Bl_Delivery_Plan%Rowtype;
    Idrow_ Bl_Delivery_Plan_Detial_v%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Cust_Delivery_Plan t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    If Row_.State <> '1' Then
      Raise_Application_Error(-20101, '只有下达状态才能取消下达！');
      Return;
    End If;
  
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan t
       Where t.Order_No = Row_.Order_No
         And t.Supplier = Row_.Supplier
       Order By t.Delived_Date Asc;
    Fetch Cur_
      Into Irow_;
    Loop
      Exit When Cur_%Notfound;
    
      Open Cur_d For
        Select t.*
          From Bl_Delivery_Plan_Detial_v t
         Where t.Delplan_No = Irow_.Delplan_No;
      Fetch Cur_d
        Into Idrow_;
      Loop
        Exit When Cur_d%Notfound;
        If Idrow_.State <> '1' Then
          Raise_Application_Error(-20101, '只有下达状态才能取消下达！');
          Return;
        End If;
        Update Bl_Delivery_Plan_Detial t
           Set t.State = '0', t.Modi_User = User_Id_, t.Modi_Date = Sysdate
         Where t.Rowid = Idrow_.Objid
           And t.State <> '3';
        Bldelivery_Plan_Line_Api.Savehist__(Idrow_.Objid,
                                            User_Id_,
                                            A311_Key_,
                                            '取消下达');
        Fetch Cur_d
          Into Idrow_;
      End Loop;
      Close Cur_d;
    
      Update Bl_Delivery_Plan t
         Set t.State = '0', t.Modi_User = User_Id_, t.Modi_Date = Sysdate
       Where t.Delplan_No = Irow_.Delplan_No
         And t.State <> '3';
    
      Fetch Cur_
        Into Irow_;
    End Loop;
    Close Cur_;
  
    Pkg_a.Setsuccess(A311_Key_,
                     'BL_V_CUST_ORDER_LINE_PHDELIVE',
                     Row_.Objid);
    Pkg_a.Setmsg(A311_Key_, '', '交货计划[' || Row_.Objid || ']取消成功');
    Return;
  End;
  Procedure Delivery_Autopicklist__(Rowlist_  Varchar2,
                                    User_Id_  Varchar2,
                                    A311_Key_ Varchar2) Is
  Begin
    Bl_Pick_Order_Api.Picklist_Auto_(Rowlist_, User_Id_, A311_Key_);
  
    Return;
  End;
  --修改交货计划 交期
  Procedure Change_Date(Delplan_No_ In Varchar2,
                        User_Id_    In Varchar2,
                        Newdate_    In Date,
                        Outmainrow_ Out Bl_Delivery_Plan_v%Rowtype) Is
    Oldmainrow_   Bl_Delivery_Plan_v%Rowtype;
    Checkmainrow_ Bl_Delivery_Plan_v%Rowtype;
    Imainrow_     Bl_Delivery_Plan%Rowtype;
    Version_      Bl_Delivery_Plan_v.Version%Type;
    Cur_          t_Cursor;
    Olddetailrow_ Bl_Delivery_Plan_Detial_v%Rowtype;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan_v t
       Where t.Delplan_No = Delplan_No_;
    Fetch Cur_
      Into Oldmainrow_;
    If Cur_%Notfound Then
    
      Raise_Application_Error(-20101,
                              '错误的交货计划号' || Delplan_No_ || '！');
      Return;
    End If;
    Close Cur_;
    If Oldmainrow_.State <> '2' Then
      Raise_Application_Error(-20101,
                              '交货计划号' || Delplan_No_ || '不能修改交期！');
      Return;
    End If;
  
    --检测日期是否存在
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan_v t
       Where t.Order_No = Oldmainrow_.Order_No
         And t.Supplier = Oldmainrow_.Supplier
         And t.Delived_Date = Newdate_
         And t.State = '2'
         And t.Delplan_No <> Delplan_No_;
    Fetch Cur_
      Into Checkmainrow_;
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '修改后的交期' || To_Char(Newdate_, 'yyyy-mm-dd') ||
                              '存在交货计划，不能修改交期！');
      Return;
    Else
      Close Cur_;
    End If;
  
    Open Cur_ For
      Select Max(Version)
        Into Version_
        From Bl_Delivery_Plan_v t
       Where t.Base_Delplan_No = Oldmainrow_.Base_Delplan_No;
    Fetch Cur_
      Into Version_;
    Close Cur_;
    If Nvl(Version_, 0) = 0 Then
      Raise_Application_Error(-20101,
                              '错误的交货计划号' || Oldmainrow_.Base_Delplan_No);
    
    End If;
    Imainrow_.Version  := Version_ + 1;
    Imainrow_.Contract := Oldmainrow_.Contract;
    Imainrow_.Supplier := Oldmainrow_.Supplier;
    Bl_Customer_Order_Api.Getseqno(To_Char(Sysdate, 'YY') ||
                                   Imainrow_.Supplier,
                                   User_Id_,
                                   8,
                                   Imainrow_.Delplan_No);
    --插入表头 版本升级                               
    Insert Into Bl_Delivery_Plan
      (Delplan_No,
       Order_No,
       Column_No,
       Customer_No,
       Customer_Ref,
       Contract,
       Version,
       State,
       Delived_Date,
       Type_Id,
       Enter_User,
       Enter_Date,
       Modi_User,
       Modi_Date,
       Remark,
       Supplier,
       Picklistno,
       Msg_User,
       Delplan_Line,
       Base_Delplan_No)
      Select Imainrow_.Delplan_No,
             Order_No,
             Column_No,
             Customer_No,
             Customer_Ref,
             Contract,
             Imainrow_.Version,
             State,
             Newdate_,
             Type_Id,
             User_Id_,
             Sysdate,
             User_Id_,
             Sysdate,
             Remark,
             Supplier,
             Picklistno,
             Msg_User,
             Delplan_Line,
             Base_Delplan_No
        From Bl_Delivery_Plan t
       Where t.Rowid = Oldmainrow_.Objid;
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan_v t
       Where t.Delplan_No = Imainrow_.Delplan_No;
    Fetch Cur_
      Into Outmainrow_;
    Close Cur_;
  
    Insert Into Bl_Delivery_Plan_Detial
      (Delplan_No,
       Delplan_Line,
       Modify_Id,
       Modify_Lineno,
       Order_No,
       Line_No,
       Rel_No,
       Line_Item_No,
       Column_No,
       Version,
       Picklistno,
       Qty_Delived,
       State,
       Enter_User,
       Enter_Date,
       Modi_User,
       Modi_Date,
       Delived_Date,
       Po_Order_No,
       Po_Line_No,
       Po_Release_No,
       Demand_Order_No,
       Demand_Rel_No,
       Demand_Line_No,
       Demand_Line_Item_No,
       Par_Po_Order_No,
       Par_Po_Line_No,
       Par_Po_Release_No,
       Par_Demand_Order_No,
       Par_Demand_Rel_No,
       Par_Demand_Line_No,
       Par_Demand_Line_Item_No,
       Remark,
       Order_Line_No,
       f_Order_No,
       f_Line_No,
       f_Rel_No,
       f_Line_Item_No,
       Base_No,
       Base_Line,
       Base_Delplan_No,
       Base_Delplan_Line)
      Select Imainrow_.Delplan_No,
             Delplan_Line,
             Modify_Id,
             Modify_Lineno,
             Order_No,
             Line_No,
             Rel_No,
             Line_Item_No,
             Column_No,
             Imainrow_.Version,
             Picklistno,
             Qty_Delived,
             State,
             Enter_User,
             Enter_Date,
             User_Id_,
             Sysdate,
             Newdate_,
             --改日期
             Po_Order_No,
             Po_Line_No,
             Po_Release_No,
             Demand_Order_No,
             Demand_Rel_No,
             Demand_Line_No,
             Demand_Line_Item_No,
             Par_Po_Order_No,
             Par_Po_Line_No,
             Par_Po_Release_No,
             Par_Demand_Order_No,
             Par_Demand_Rel_No,
             Par_Demand_Line_No,
             Par_Demand_Line_Item_No,
             Remark,
             Order_Line_No,
             f_Order_No,
             f_Line_No,
             f_Rel_No,
             f_Line_Item_No,
             Base_No,
             Base_Line,
             Base_Delplan_No,
             Base_Delplan_Line
        From Bl_Delivery_Plan_Detial t
       Where t.Delplan_No = Oldmainrow_.Delplan_No
         And t.State <> '3'
         And t.Qty_Delived > 0;
  
    --更新原版本 的 交货计划数据
    Update Bl_Delivery_Plan t
       Set t.State = '3', t.Modi_User = User_Id_, t.Modi_Date = Sysdate
     Where t.Delplan_No = Oldmainrow_.Delplan_No;
  
    --更新原版本 的 交货计划数据
    Update Bl_Delivery_Plan_Detial t
       Set t.State = '3', t.Modi_User = User_Id_, t.Modi_Date = Sysdate
     Where t.Delplan_No = Oldmainrow_.Delplan_No;
  
  End;
  --交货计划版本升级
  Procedure Update_Version(Base_Delplan_No_ In Varchar2,
                           User_Id_         In Varchar2,
                           Outmainrow_      Out Bl_Delivery_Plan_v%Rowtype) Is
    Oldmainrow_   Bl_Delivery_Plan_v%Rowtype;
    Imainrow_     Bl_Delivery_Plan%Rowtype;
    Version_      Bl_Delivery_Plan_v.Version%Type;
    Cur_          t_Cursor;
    Olddetailrow_ Bl_Delivery_Plan_Detial_v%Rowtype;
  
  Begin
    Open Cur_ For
      Select Max(Version)
        Into Version_
        From Bl_Delivery_Plan_v t
       Where t.Base_Delplan_No = Base_Delplan_No_;
    Fetch Cur_
      Into Version_;
    Close Cur_;
    If Nvl(Version_, 0) = 0 Then
      Raise_Application_Error(-20101,
                              '错误的交货计划号' || Base_Delplan_No_);
    
    End If;
  
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan_v t
       Where t.Base_Delplan_No = Base_Delplan_No_
         And t.Version = Version_;
    Fetch Cur_
      Into Oldmainrow_;
    Close Cur_;
    If Oldmainrow_.State = '3' Then
      Return;
    End If;
    Imainrow_.Version  := Version_ + 1;
    Imainrow_.Contract := Oldmainrow_.Contract;
    Imainrow_.Supplier := Oldmainrow_.Supplier;
    Bl_Customer_Order_Api.Getseqno(To_Char(Sysdate, 'YY') ||
                                   Imainrow_.Supplier,
                                   User_Id_,
                                   8,
                                   Imainrow_.Delplan_No);
    --插入表头 版本升级                               
    Insert Into Bl_Delivery_Plan
      (Delplan_No,
       Order_No,
       Column_No,
       Customer_No,
       Customer_Ref,
       Contract,
       Version,
       State,
       Delived_Date,
       Type_Id,
       Enter_User,
       Enter_Date,
       Modi_User,
       Modi_Date,
       Remark,
       Supplier,
       Picklistno,
       Msg_User,
       Delplan_Line,
       Base_Delplan_No)
      Select Imainrow_.Delplan_No,
             Order_No,
             Column_No,
             Customer_No,
             Customer_Ref,
             Contract,
             Imainrow_.Version,
             State,
             Delived_Date,
             Type_Id,
             User_Id_,
             Sysdate,
             User_Id_,
             Sysdate,
             Remark,
             Supplier,
             Picklistno,
             Msg_User,
             Delplan_Line,
             Base_Delplan_No
        From Bl_Delivery_Plan t
       Where t.Rowid = Oldmainrow_.Objid;
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan_v t
       Where t.Delplan_No = Imainrow_.Delplan_No;
    Fetch Cur_
      Into Outmainrow_;
    Close Cur_;
    Insert Into Bl_Delivery_Plan_Detial
      (Delplan_No,
       Delplan_Line,
       Modify_Id,
       Modify_Lineno,
       Order_No,
       Line_No,
       Rel_No,
       Line_Item_No,
       Column_No,
       Version,
       Picklistno,
       Qty_Delived,
       State,
       Enter_User,
       Enter_Date,
       Modi_User,
       Modi_Date,
       Delived_Date,
       Po_Order_No,
       Po_Line_No,
       Po_Release_No,
       Demand_Order_No,
       Demand_Rel_No,
       Demand_Line_No,
       Demand_Line_Item_No,
       Par_Po_Order_No,
       Par_Po_Line_No,
       Par_Po_Release_No,
       Par_Demand_Order_No,
       Par_Demand_Rel_No,
       Par_Demand_Line_No,
       Par_Demand_Line_Item_No,
       Remark,
       Order_Line_No,
       f_Order_No,
       f_Line_No,
       f_Rel_No,
       f_Line_Item_No,
       Base_No,
       Base_Line,
       Base_Delplan_No,
       Base_Delplan_Line,
       Rowdata)
      Select Imainrow_.Delplan_No,
             Delplan_Line,
             Modify_Id,
             Modify_Lineno,
             Order_No,
             Line_No,
             Rel_No,
             Line_Item_No,
             Column_No,
             Imainrow_.Version,
             Picklistno,
             Qty_Delived,
             State,
             Enter_User,
             Enter_Date,
             Modi_User,
             Modi_Date,
             Delived_Date,
             Po_Order_No,
             Po_Line_No,
             Po_Release_No,
             Demand_Order_No,
             Demand_Rel_No,
             Demand_Line_No,
             Demand_Line_Item_No,
             Par_Po_Order_No,
             Par_Po_Line_No,
             Par_Po_Release_No,
             Par_Demand_Order_No,
             Par_Demand_Rel_No,
             Par_Demand_Line_No,
             Par_Demand_Line_Item_No,
             Remark,
             Order_Line_No,
             f_Order_No,
             f_Line_No,
             f_Rel_No,
             f_Line_Item_No,
             Base_No,
             Base_Line,
             Base_Delplan_No,
             Base_Delplan_Line,
             Rowdata
        From Bl_Delivery_Plan_Detial t
       Where t.Delplan_No = Oldmainrow_.Delplan_No
         And t.State <> '3'
         And (t.Qty_Delived > 0 Or Oldmainrow_.Type_Id = 'AUTO');
  
    --更新原版本 的 交货计划数据
    Update Bl_Delivery_Plan t
       Set t.State = '3', t.Modi_User = User_Id_, t.Modi_Date = Sysdate
     Where t.Delplan_No = Oldmainrow_.Delplan_No;
  
    --更新原版本 的 交货计划数据
    Update Bl_Delivery_Plan_Detial t
       Set t.State = '3', t.Modi_User = User_Id_, t.Modi_Date = Sysdate
     Where t.Delplan_No = Oldmainrow_.Delplan_No;
  
  End;

  Procedure Approve__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  Procedure Approvesu__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2) Is
    Row_  Bl_v_Cust_Delivery_Plan%Rowtype;
    Row__ Bl_v_Delivery_Plan_Line%Rowtype;
    Cur_  t_Cursor;
    --cur_d  t_cursor;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Cust_Delivery_Plan t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    Open Cur_ For
      Select t.*
        From Bl_v_Delivery_Plan_Line t
       Where t.Order_s_No = Row_.Order_s_No;
    Fetch Cur_
      Into Row__;
    If Cur_ %Notfound Then
      Raise_Application_Error(-20101, '明细行无数据！');
      Return;
    End If;
    Loop
      If Cur_ %Notfound Then
        Exit;
      End If;
      If Row__.State <> '1' Then
        Raise_Application_Error(-20101, '只有下达状态才能确认！');
        Return;
      End If;
      Update Bl_Delivery_Plan_Detial t
         Set t.State = '2', t.Modi_User = User_Id_, t.Modi_Date = Sysdate
       Where t.Rowid = Row__.Objid
         And t.State <> '3';
      Bldelivery_Plan_Line_Api.Savehist__(Row__.Objid,
                                          User_Id_,
                                          A311_Key_,
                                          '确认');
      Fetch Cur_
        Into Row__;
    End Loop;
    Close Cur_;
    Update Bl_Delivery_Plan t
       Set t.State = '2', t.Modi_User = User_Id_, t.Modi_Date = Sysdate
     Where t.Order_No = Row__.Order_No
       And t.Supplier = Row__.Supplier
       And t.State <> '3';
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUST_DELIVERY_PLAN', Rowlist_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '外部订单交货计划' || Rowlist_ || '确认成功');
    Return;
  End;
  --当字段 数据变换的
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2) Is
    Mainrow_ Bl_v_Customer_Order_V03%Rowtype;
    Cur_     t_Cursor;
    Attr_Out Varchar2(4000);
    Row_     Bl_v_Cust_Order_Line_Phdelive%Rowtype;
  Begin
    If Column_Id_ = 'CUSTOMER_NO' Then
      Row_.Customer_No   := Pkg_a.Get_Item_Value('CUSTOMER_NO', Rowlist_);
      Row_.Customer_Name := Cust_Ord_Customer_Api.Get_Name(Row_.Customer_No);
      If Length(Nvl(Row_.Customer_Name, '-')) < 5 Then
        Raise_Application_Error(-20101, '错误的客户编码');
        Return;
      End If;
      Pkg_a.Set_Item_Value('CUSTOMER_NAME', Row_.Customer_Name, Attr_Out);
      If Length(Row_.Customer_No) > 2 Then
        Row_.Label_Note := Row_.Customer_No;
        Pkg_a.Set_Item_Value('LABEL_NOTE', Row_.Label_Note, Attr_Out);
      End If;
    End If;
  
    If Column_Id_ = 'BLORDER_NO' Then
      Mainrow_.Blorder_No := Pkg_a.Get_Item_Value('BLORDER_NO', Rowlist_);
      --  raise_application_error(-20101,   mainrow_.BLORDER_NO);
      Open Cur_ For
        Select t.*
          From Bl_v_Customer_Order_V03 t
         Where t.Blorder_No = Mainrow_.Blorder_No;
      Fetch Cur_
        Into Mainrow_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的订单号');
        Return;
      End If;
      Close Cur_;
      -- pkg_a.Set_Item_Value('CUSTOMER_NO',mainrow_.CUSTOMER_NO,attr_out);
      -- pkg_a.Set_Item_Value('CUSTOMER_NAME',mainrow_.CUSTOMER_NAME,attr_out);
    
      Pkg_a.Set_Item_Value('ORDER_NO', Mainrow_.Order_No, Attr_Out);
      Pkg_a.Set_Item_Value('WANTED_DELIVERY_DATE',
                           To_Char(Mainrow_.Wanted_Delivery_Date,
                                   'YYYY-MM-DD'),
                           Attr_Out);
      Pkg_a.Set_Item_Value('ORDER_ID', Mainrow_.Blorder_Id, Attr_Out);
      Pkg_a.Set_Item_Value('AUTHORIZE_CODE',
                           Mainrow_.Authorize_Code,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_REF', Mainrow_.Cust_Ref, Attr_Out);
      Pkg_a.Set_Item_Value('CONTRACT', Mainrow_.Contract, Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_REF', Mainrow_.Cust_Ref, Attr_Out);
    
      Pkg_a.Set_Item_Value('CUSTOMER_NO', Mainrow_.Customer_No, Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_NAME',
                           Mainrow_.Customer_Name,
                           Attr_Out);
      Pkg_a.Set_Item_Value('LABEL_NOTE', Mainrow_.Label_Note, Attr_Out);
      Select Max(t.Column_No)
        Into Mainrow_.Additional_Discount
        From Bl_Delivery_Plan t
       Where t.Order_No = Mainrow_.Order_No;
      Pkg_a.Set_Item_Value('COLUMN_NO',
                           To_Char(Nvl(Mainrow_.Additional_Discount, 0) + 1),
                           Attr_Out);
    End If;
  
    Outrowlist_ := Attr_Out;
    Return;
  End;
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2 Is
    Mainrow_ Bl_v_Cust_Order_Line_Phd%Rowtype;
    --row_   BL_V_CUST_ORDER_LINE_PDD%rowtype;
    Cur_    t_Cursor;
    Sum_Qty Number;
  Begin
    Return '1';
    --获取总数量
    Open Cur_ For
      Select t.*
        Into Mainrow_
        From Bl_v_Cust_Order_Line_Phd t
       Where t.Order_Line_No = Order_No_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_%Notfound Then
      Close Cur_;
      Return '0';
    End If;
    Close Cur_;
    Select Sum(t.Qty_Delived)
      Into Sum_Qty
      From Bl_Delivery_Plan_Detial t
     Where t.Order_No = Mainrow_.Order_No
       And t.Line_No = Mainrow_.Line_No
       And t.Rel_No = Mainrow_.Rel_No
       And t.Line_Item_No = Mainrow_.Line_Item_No;
    Sum_Qty := Nvl(Sum_Qty, 0);
    If Mainrow_.Buy_Qty_Due > Sum_Qty Then
      Return '1';
    Else
      Return '0';
    End If;
  
    Return '1';
  End;
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    Row_ Bl_v_Cust_Order_Line_Phdelive%Rowtype;
  Begin
    If Doaction_ = 'I' Then
      Return '1';
    End If;
    If Column_Id_ = 'REMARK' Then
      Return '1';
    End If;
  
    If Column_Id_ = 'DELIVED_DATE' Then
      Row_.Pstate := Pkg_a.Get_Item_Value('PSTATE', Rowlist_);
    
      If Row_.Pstate = '0' Then
        Return '1';
      Else
        Return '0';
      End If;
    
    Else
      Return '0';
    End If;
  
    Return '1';
  End;

  Procedure Get_Record_By_Order_Date(Order_No_     In Varchar2,
                                     Supplier_     In Varchar2,
                                     Date_Deliever In Date,
                                     Record_       Out Bl_Delivery_Plan_v%Rowtype) Is
    Cur_ t_Cursor;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Delivery_Plan_v t
       Where t.Order_No = Order_No_
         And t.Supplier = Supplier_
         And t.Delived_Date = Date_Deliever
         And t.State In ('1', '2');
    Fetch Cur_
      Into Record_;
    Close Cur_;
  End;
End Bldelivery_Plan_Api;
/
