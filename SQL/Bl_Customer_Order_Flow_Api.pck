Create Or Replace Package Bl_Customer_Order_Flow_Api Is
  Function Iffactory(Contract_ In Varchar2) Return Varchar2;
  Function Ifparentrelease(Order_No_ In Varchar2, Res_ In Varchar2)
    Return Varchar2;
  --获取域的公司
  Function Getcompany(Contract_ In Varchar2) Return Varchar2;
  Procedure Release_Order(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2,
                          If_Auto_  Varchar2 Default '0');
  Procedure Start_Create_Invoice__(Order_No_ Varchar2,
                                   User_Id_  Varchar2,
                                   A311_Key_ Varchar2);

  --自动生成  下达下域的订单
  Procedure Release_Nextorder(Order_No_  In Varchar2,
                              User_Id_   In Varchar2,
                              A311_Key_  Varchar2,
                              If_Change_ In Varchar2 Default '0');
End Bl_Customer_Order_Flow_Api;
/
Create Or Replace Package Body Bl_Customer_Order_Flow_Api Is
  Type t_Cursor Is Ref Cursor;
  Function Getcompany(Contract_ In Varchar2) Return Varchar2 Is
    Result_ Varchar2(10);
    Row_    Bl_Ciq_Contract_Tab%Rowtype;
    Cur_    t_Cursor;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Ciq_Contract_Tab t
       Where t.Contract = Contract_
         And Rownum = 1;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Result_ := '0';
      Return Result_;
    End If;
    Close Cur_;
    Return Row_.Company;
  End;
  --判断当前域是否是工厂域
  -- Contract_ 订单号码 判断工厂域无效 判断明细是否 是内部采购目录的
  Function Iffactory(Contract_ In Varchar2) Return Varchar2 Is
    Result_ Varchar2(10);
    Row_    Customer_Order_Line%Rowtype;
    Cur_    t_Cursor;
  Begin
    -- 判断有没有内部采购目录
    Open Cur_ For
      Select t.*
        From Customer_Order_Line t
       Where t.Order_No = Contract_
         And t.Line_Item_No <= 0
         And t.Supply_Code In
             (Select Id From Bl_v_Co_Supply_Code T1 Where T1.Autoplan = '0');
    Fetch Cur_
      Into Row_;
    --有内部采购目录 就不是最底层
    If Cur_%Found Then
      Close Cur_;
      Result_ := '0';
      Return Result_;
    End If;
    Close Cur_;
    Return '1';
  
  End;
  --判断上级菜单是否已经确认
  Function Ifparentrelease(Order_No_ In Varchar2, Res_ In Varchar2)
    Return Varchar2 Is
    Bl_Co_  Bl_Customer_Order%Rowtype;
    Cur_    t_Cursor;
    Result_ Varchar2(10);
  Begin
    Open Cur_ For
      Select t.* From Bl_Customer_Order t Where t.Order_No = Order_No_;
    Fetch Cur_
      Into Bl_Co_;
    If Cur_%Notfound Then
      Close Cur_;
      Return '0';
    End If;
    Close Cur_;
    If Bl_Co_.q_Flag <> '1' Then
      Return '0';
    End If;
    Return '1';
  
  End;

  --销售订单下达
  Procedure Release_Order(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2,
                          If_Auto_  Varchar2 Default '0') Is
    Row_      Bl_v_Customer_Order%Rowtype;
    Coline_   Customer_Order_Line%Rowtype;
    Cur_      t_Cursor;
    Attr_     Varchar2(4000);
    A311_     A311%Rowtype;
    If_End_   Varchar2(10);
    If_End_c  Varchar2(10);
    Rowlist__ Varchar2(3000);
  Begin
    --  bl_customer_order_api BL_CIQ_CONTRACT_TAB
    -- IFSAPP.Customer_Order_Flow_API.Start_Release_Order__
    --START_EVENT20ORDER_NOB24546END
    Row_.Objid := Rowlist_;
  
    Open Cur_ For
      Select t.* From Bl_v_Customer_Order t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Pkg_a.Setfailed(A311_Key_, 'BL_V_CUSTOMER_ORDER', Row_.Objid);
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    If Length(Row_.Customer_No) > 2 Then
      If Row_.Customer_No != Nvl(Row_.Label_Note, '-') Then
        Pkg_a.Set_Item_Value('DOACTION', 'M', Rowlist__);
        Pkg_a.Set_Item_Value('OBJID', Row_.Objid, Rowlist__);
        Pkg_a.Set_Item_Value('LABEL_NOTE', Row_.Customer_No, Rowlist__);
        Bl_Customer_Order_Api.Modify__(Rowlist__, User_Id_, A311_Key_);
      
      End If;
    
    End If;
  
    --外部订单
    If Row_.If_First <> '1' Then
      --检查客户订单是否已经确认
      If If_Auto_ = '0' Then
        If Ifparentrelease(Row_.Order_No, '1') = '0' Then
          Pkg_a.Setfailed(A311_Key_, 'BL_V_CUSTOMER_ORDER', Row_.Objid);
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Row_.Order_No || '下达失败:订单的上级订单未确认，不能下达!');
          Return;
        End If;
      End If;
    End If;
  
    --自动下达 存在内部采购目录 自动下达下域订单
    Open Cur_ For
      Select t.*
        From Customer_Order_Line t
       Where t.Order_No = Row_.Order_No
         And t.Line_Item_No <= 0
         And t.Supply_Code In
             (Select Id From Bl_v_Co_Supply_Code T1 Where T1.Autoplan = '0');
  
    Fetch Cur_
      Into Coline_;
    If Cur_%Found Then
      Pkg_a.Setnextdo(A311_Key_,
                      '订单下达-' || Row_.Order_No,
                      User_Id_,
                      'bl_customer_order_flow_api.release_nextorder(''' ||
                      Row_.Order_No || ''',''' || User_Id_ || ''',''' ||
                      A311_Key_ || ''')',
                      2 / 60 / 24);
    
    End If;
    Close Cur_;
  
    If Row_.Objstate = 'Planned' Then
      Client_Sys.Add_To_Attr('START_EVENT', '20', Attr_);
      Client_Sys.Add_To_Attr('ORDER_NO', Row_.Order_No, Attr_);
      Client_Sys.Add_To_Attr('END', '', Attr_);
      Customer_Order_Flow_Api.Start_Release_Order__(Attr_);
    End If;
  
    If If_Auto_ = '0' Then
      --如果有库存订单  自动生成交货计划  --   
      Open Cur_ For
        Select t.*
          From Customer_Order_Line t
         Where t.Order_No = Row_.Order_No
           And t.Line_Item_No <= 0
           And t.Supply_Code In (Select Id
                                   From Bl_v_Co_Supply_Code T1
                                  Where T1.Autoplan = '1');
    
      Fetch Cur_
        Into Coline_;
      If Cur_%Found Then
        Bl_Customer_Order_Api.Delivery_Plan_(Row_.Order_No,
                                             User_Id_,
                                             A311_Key_);
      
      End If;
      Close Cur_;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_ORDER', Row_.Objid);
      Pkg_a.Setmsg(A311_Key_, '', '订单' || Row_.Order_No || '下达成功');
    End If;
  
    Return;
  End;
  /* 
  procedure po_release_nextorder(order_no_ in varchar2,USER_ID_ in varchar2 , A311_KEY_ VARCHAR2)
  is
   co_row_  IFSAPP.EXTERNAL_CUSTOMER_ORDER%rowtype ;
   co_cur t_cursor;   
   co_cur_child   t_cursor; 
   co_child_ ifsapp.customer_order%rowtype;
   row0_  Bl_Purchase_ORDER%rowtype;
   row1_  BL_CUSTOMER_ORDER %rowtype;
   cur_ t_cursor; 
   a311_  a311%rowtype;
   begin
      open  cur_ for 
      select t.*
      from    BL_PURCHASE_ORDER t 
      where  t.order_no = order_no_ ;
      fetch  cur_ into row0_;
      close  cur_;     
         row1_.blorder_no := row0_.blorder_no;
         row1_.bllocation_no := row0_.bllocation_no;
         row1_.bld001_item := row0_.bld001_item;
         row1_.blorder_id := row0_.blorder_id ;
        open co_cur for 
         Select t1.*
         from IFSAPP.EXTERNAL_CUSTOMER_ORDER  t
         inner join  IFSAPP.customer_order_line_tab  t1 on t1.order_no = t.order_no
        -- inner join  IFSAPP.CUSTOMER_ORDER_PUR_ORDER_TAB t2 on t2.oe_order_no = t1.order_no
         --      and t2.oe_line_no = t1.line_no
         --      and t2.oe_rel_no = t1.rel_no
         --      and t2.oe_line_item_no = t1.line_item_no
         where t.internal_po_no =order_no_;
         
       fetch  co_cur into  co_row_;
       loop 
         exit when co_cur%notfound ;
          open co_cur_child for 
          select t.*
          from ifsapp.customer_order t 
          where t.order_no = co_row_.order_no ;
          fetch  co_cur_child into co_child_ ;
          loop 
                  exit when co_cur_child%notfound ;
                   row0_.order_no := co_child_.order_no;
                   row0_.q_flag := '0' ;
                   row0_.if_first := '0';
                   --把数据写到对应的域中
                   bl_customer_order_api.UserModify__(row0_,user_id_ );   
                   row1_.order_no := co_row_.INTERNAL_PO_NO;
                   bl_purchase_order_api.UserModify__( row1_,user_id_ );
                  if co_child_.objstate = 'Planned' then    
                     --工厂的数据
                     ---把库表的值更新到 新订单中                                                          
                     IF IfFactory(co_child_.CONTRACT) = '0' THEN  
                         a311_.a311_id := 'BL_Customer_Order_Flow_Api.release_nextorder';
                         a311_.enter_user := user_id_;
                         a311_.a014_id := 'A014_ID=Order_Release';
                         a311_.table_id := 'BL_V_CUSTOMER_ORDER' ;
                         a311_.table_objid := rowidtochar(co_child_.objid);
                         pkg_a.BeginLog(a311_);                                   
                         release_order(rowidtochar(co_child_.objid),USER_ID_,A311_KEY_,'1' );   
                     END IF;        
                  end if ;
                  fetch  co_cur_child into co_child_ ;
          end loop ;
          close co_cur_child;
         fetch  co_cur into  co_row_;
       end loop ;
       close co_cur ;
    
    end ;
    
   --IFSAPP.PURCHASE_ORDER_LINE_PART_API   
  
  
  */

  ---自动下达域的销售订单 
  Procedure Release_Nextorder(Order_No_  In Varchar2,
                              User_Id_   In Varchar2,
                              A311_Key_  Varchar2,
                              If_Change_ In Varchar2 Default '0') Is
    Co_Row_      Ifsapp.External_Customer_Order%Rowtype;
    Co_Cur       t_Cursor;
    Co_Cur_Child t_Cursor;
    Co_Child_    Ifsapp.Customer_Order%Rowtype;
    Row0_        Bl_Customer_Order%Rowtype;
    Row1_        Bl_Purchase_Order%Rowtype;
    Cur_         t_Cursor;
    A311_        A311%Rowtype;
    Cur1_        t_Cursor;
    Coline_      Customer_Order_Line%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_Customer_Order t Where t.Order_No = Order_No_;
    Fetch Cur_
      Into Row0_;
    Close Cur_;
    --变更生成交货计划
    If If_Change_ = '1' Then
      Bl_Customer_Order_Api.Delivery_Plan_(Order_No_, User_Id_, A311_Key_);
    
    End If;
    Row1_.Blorder_No    := Row0_.Blorder_No;
    Row1_.Bllocation_No := Row0_.Bllocation_No;
    Row1_.Bld001_Item   := Row0_.Bld001_Item;
    Row1_.Blorder_Id    := Row0_.Blorder_Id;
  
    Open Co_Cur For
      Select Distinct T2.* --, t1.*,t.*
        From Ifsapp.Customer_Order_Line_Tab T1
       Inner Join Ifsapp.Purchase_Order_Line_Tab t
          On t.Demand_Order_No = T1.Order_No
         And t.Demand_Release = T1.Line_No
         And t.Demand_Sequence_No = T1.Rel_No
         And t.Demand_Operation_No = T1.Line_Item_No
       Inner Join Ifsapp.External_Customer_Order T2
          On T2.Internal_Po_No = t.Order_No
       Where T1.Order_No = Order_No_;
    Fetch Co_Cur
      Into Co_Row_;
    Loop
      Exit When Co_Cur%Notfound;
      Open Co_Cur_Child For
        Select t.*
          From Ifsapp.Customer_Order t
         Where t.Order_No = Co_Row_.Order_No;
      Fetch Co_Cur_Child
        Into Co_Child_;
      Loop
        Exit When Co_Cur_Child%Notfound;
        Row0_.Order_No := Co_Child_.Order_No;
        Row0_.q_Flag   := Row0_.q_Flag;
        Row0_.If_First := '0';
        Row0_.Modi_Key := A311_Key_;
        --把数据写到对应的域中
        Bl_Customer_Order_Api.Usermodify__(Row0_, User_Id_);
        Row1_.Order_No := Co_Row_.Internal_Po_No;
        Bl_Purchase_Order_Api.Usermodify__(Row1_, User_Id_);
      
        --如果是订单自动生成交货计划  -- 
        Bl_Customer_Order_Api.Delivery_Plan_(Co_Child_.Order_No,
                                             User_Id_,
                                             A311_Key_);
        --如果存在 采购目录 就下达客户订单
        Open Cur1_ For
          Select t.*
            From Customer_Order_Line t
           Where t.Order_No = Co_Child_.Order_No
             And t.Line_Item_No <= 0
             And t.Supply_Code In
                 (Select Id
                    From Bl_v_Co_Supply_Code T1
                   Where T1.Autoplan = '0');
      
        Fetch Cur1_
          Into Coline_;
        If Cur1_%Found Then
          A311_.A311_Id     := 'BL_Customer_Order_Flow_Api.release_nextorder';
          A311_.Enter_User  := User_Id_;
          A311_.A014_Id     := 'A014_ID=Order_Release';
          A311_.Table_Id    := 'BL_V_CUSTOMER_ORDER';
          A311_.Table_Objid := Rowidtochar(Co_Child_.Objid);
          Pkg_a.Beginlog(A311_);
          --自动下达客户订单
          Release_Order(Rowidtochar(Co_Child_.Objid),
                        User_Id_,
                        A311_Key_,
                        '1');
        
        End If;
        Close Cur1_;
      
        Fetch Co_Cur_Child
          Into Co_Child_;
      End Loop;
      Close Co_Cur_Child;
      Fetch Co_Cur
        Into Co_Row_;
    End Loop;
    Close Co_Cur;
  
  End;

  --IFSAPP.PURCHASE_ORDER_LINE_PART_API   

  Procedure Start_Create_Invoice__(Order_No_ Varchar2,
                                   User_Id_  Varchar2,
                                   A311_Key_ Varchar2) Is
    Attr_ Varchar2(4000);
  Begin
    --拼发票的字符串
    Attr_ := '';
    Client_Sys.Add_To_Attr('START_EVENT', '500', Attr_);
    Client_Sys.Add_To_Attr('ORDER_NO', Order_No_, Attr_);
    Client_Sys.Add_To_Attr('END', '', Attr_);
    --调用ifs的发票函数
    Customer_Order_Flow_Api.Start_Create_Invoice__(Attr_);
    Return;
  End;
End Bl_Customer_Order_Flow_Api;
/
