CREATE OR REPLACE Package Bl_Bl_Pldtldiff_Api Is
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  --当数据发生变化的时候 修改列信息(作废，直接下达)
  Procedure Confirm__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --下达的时候更新备货单的数量，同时产生交货计划的变更
  Procedure Release__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  -- 差异发货产生交货计划的变更申请
  Procedure Pdrelease__(Pldtldiff_No_ Varchar2, --传过来差异发货号
                        User_Id_      Varchar2,
                        A311_Key_     Varchar2);
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2);
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2;
  ----检查编辑 修改
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2;
End Bl_Bl_Pldtldiff_Api;
/
CREATE OR REPLACE Package Body Bl_Bl_Pldtldiff_Api Is
  Type t_Cursor Is Ref Cursor;
  /* modify fjp 2012-11-14  增加差异发货的下达
   modify fjp 更新交货计划变更为作废状态 2012-12-05
   modify fjp 2013-01-30 增加差异发货可发货的控制Release__
   modify fjp 20130328如果是提货，取消提货，如果是预送，取消预送*/
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Index_     Varchar2(1);
    Doaction_  Varchar2(1);
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar2(4000);
    Ifmychange Varchar2(1);
    Objid_     Varchar2(100);
    Row_       Bl_Pldtldiff%Rowtype;
    Row1_      Bl_v_Bl_Pldtl_Diversity%Rowtype;
    Cur_       t_Cursor;
    Ll_Count_  Number;
  Begin
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    If Doaction_ = 'I' Then
      Row_.Picklistno    := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_);
      Row_.Order_No      := Pkg_a.Get_Item_Value('CO_ORDER_NO', Rowlist_);
      Row_.Line_No       := Pkg_a.Get_Item_Value('CO_LINE_NO', Rowlist_);
      Row_.Rel_No        := Pkg_a.Get_Item_Value('CO_REL_NO', Rowlist_);
      Row_.Line_Item_No  := Pkg_a.Get_Item_Value('CO_LINE_ITEM_NO',
                                                 Rowlist_);
      Row_.Createdate    := To_Char(Sysdate, 'yyyy-mm-dd');
      Row_.Flag          := '0';
      Row_.Userid        := User_Id_;
      Row_.Modifyqty     := Pkg_a.Get_Item_Value('MODIFYQTY', Rowlist_);
      Row_.Catalog_No    := Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_);
      Row_.Catalog_Desc  := Pkg_a.Get_Item_Value('CATALOG_DESC', Rowlist_);
      Row_.Contract      := Pkg_a.Get_Item_Value('CO_CONTRACT', Rowlist_);
      Row_.Pcontract     := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Row_.Porder_No     := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
      Row_.Pline_No      := Pkg_a.Get_Item_Value('LINE_NO', Rowlist_);
      Row_.Prel_No       := Pkg_a.Get_Item_Value('REL_NO', Rowlist_);
      Row_.Pline_Item_No := Pkg_a.Get_Item_Value('LINE_ITEM_NO', Rowlist_);
      Row_.Finishqty     := Pkg_a.Get_Item_Value('FINISHQTY', Rowlist_);
      ROW_.SUPPLIER      := pkg_a.Get_Item_Value('SUPPLIER',Rowlist_);
      if Row_.Modifyqty > Row_.Finishqty then 
         Raise_Application_Error(-20101, '差异发货的数据只能比备货单的数量小');
         Return;
      end if ;
      Select Count(*)
        Into Ll_Count_
        From Bl_Pldtldiff
       Where Picklistno = Row_.Picklistno
         And Order_No = Row_.Order_No
         And Line_No = Row_.Line_No
         And Rel_No = Row_.Rel_No
         And Line_Item_No = Row_.Line_Item_No;
      If Ll_Count_ > 0 Then
        Raise_Application_Error(-20101, '错误的插入了重复的主键');
        Return;
      End If;
      Insert Into Bl_Pldtldiff
        (Picklistno, Order_No, Line_No, Rel_No, Line_Item_No)
      Values
        (Row_.Picklistno,
         Row_.Order_No,
         Row_.Line_No,
         Row_.Rel_No,
         Row_.Line_Item_No)
      Returning Rowid Into Objid_;
      Update Bl_Pldtldiff Set Row = Row_ Where Rowid = Objid_;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PLDTL_DIVERSITY', Objid_);
      Return;
    End If;
    If Doaction_ = 'M' Then
      -- 更改数据
      Open Cur_ For
        Select t.* From Bl_v_Bl_Pldtl_Diversity t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row1_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      End If;
      Close Cur_;
    
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := ' update BL_PLDTLDIFF set ';
      Ifmychange := '0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' And
           Length(Nvl(Column_Id_, '')) > 0 Then
          v_         := Substr(v_, Pos1_ + 1);
          i          := i + 1;
          Ifmychange := '1';
          Mysql_     := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
        
        End If;
      End Loop;
      If Ifmychange = '1' Then
        -- 更新sql语句 
        Mysql_ := Substr(Mysql_, 1, Length(Mysql_) - 1);
        Mysql_ := Mysql_ || ' where rowidtochar(rowid)=''' || Objid_ || '''';
        Execute Immediate Mysql_;
      End If;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PLDTL_DIVERSITY', Objid_);
      Return;
    End If;
    If Doaction_ = 'D' Then
      --删除
      Delete From Bl_Pldtldiff Where Rowid = Objid_;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PLDTL_DIVERSITY', Objid_);
      Return;
    End If;
  End;
  Procedure Confirm__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
    Cur_ t_Cursor;
    Row_ Bl_v_Bl_Pldtl_Hd%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Bl_Pldtl_Hd t Where t.Objid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    Update Bl_Pldtldiff
       Set Flag = '1'
     Where Picklistno = Row_.Picklistno
      and BL_Pick_Order_line_api.Get_Suplier_User(SUPPLIER,User_Id_)='1';--用户供应域
/*       And Pcontract In (Select t.Contract
                           From Bl_Usecon t, A007 T1
                          Where T1.Bl_Userid = t.Userid
                            And T1.A007_Id = User_Id_);*/
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PLDTL_HD', Rowid_);
    Return;
  End;
  Procedure Release__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
    Cur_          t_Cursor;
    Cur1_         t_Cursor;
    Row_          Bl_v_Bl_Pldtl_Hd%Rowtype;
    Row1_         Bl_Pldtldiff%Rowtype;
    Row2_         Bl_Delivery_Plan_Detial_v%Rowtype;
    Pldtldiff_No_ Bl_Pldtldiff.Pldtldiff_No%Type;
    row3_         Bl_Pltrans%rowtype;
    Msg_          Varchar2(1000);
    ll_count_     number;
    Qty_Delivedf_  NUMBER;
    js_state_      varchar2(1);
    Info_         varchar2(4000);
    State_        varchar2(20);
    Pallet_Id_    Varchar2(100);
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Bl_Pldtl_Hd t Where t.Objid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    Select Bl_Pldtldiff_Seq.Nextval Into Pldtldiff_No_ From Dual;
    -- 更新状态
    Update Bl_Pldtldiff
       Set Flag = '2', Pldtldiff_No = Pldtldiff_No_
     Where Picklistno = Row_.Picklistno
     and BL_Pick_Order_line_api.Get_Suplier_User(SUPPLIER,User_Id_)='1';--用户供应域
/*       And Pcontract In (Select t.Contract
                           From Bl_Usecon t, A007 T1
                          Where T1.Bl_Userid = t.Userid
                            And T1.A007_Id = User_Id_);*/
    -- 更新备货单的信息(如果差异发货数量为0 则作废备货单行)
    Update Bl_Pldtl t
       Set (t.Pickqty, t.Finishqty) =
           (Select T0.Modifyqty, T0.Modifyqty
              From Bl_Pldtldiff T0
             Where T0.Picklistno = t.Picklistno
               And T0.Order_No = t.Order_No
               And T0.Line_No = t.Line_No
               And T0.Rel_No = t.Rel_No
               And T0.Line_Item_No = t.Line_Item_No),
             t.flag = (case when  exists(Select 1
                                    From Bl_Pldtldiff T0
                                   Where T0.Picklistno = t.Picklistno
                                     And T0.Order_No = t.Order_No
                                     And T0.Line_No = t.Line_No
                                     And T0.Rel_No = t.Rel_No
                                     And T0.Line_Item_No = t.Line_Item_No
                                     and T0.Modifyqty=0) 
                       then '3' 
                       else t.flag end)
     Where Exists (Select *
              From Bl_Pldtldiff T1
             Where T1.Picklistno = Row_.Picklistno
             and  BL_Pick_Order_line_api.Get_Suplier_User(T1.SUPPLIER,User_Id_)='1'--用户供应域
/*               And T1.Pcontract In
                   (Select t.Contract
                      From Bl_Usecon t, A007 T1
                     Where T1.Bl_Userid = t.Userid
                       And T1.A007_Id = User_Id_)*/
               And T1.Picklistno = t.Picklistno
               And T1.Order_No = t.Order_No
               And T1.Line_No = t.Line_No
               And T1.Rel_No = t.Rel_No
               And T1.Line_Item_No = t.Line_Item_No);
    --更新交货计划的信息 
    Open Cur1_ For
      Select *
        From Bl_Pldtldiff
       Where Picklistno = Row_.Picklistno
       and BL_Pick_Order_line_api.Get_Suplier_User(SUPPLIER,User_Id_)='1';--用户供应域
/*         And Pcontract In (Select t.Contract
                             From Bl_Usecon t, A007 T1
                            Where T1.Bl_Userid = t.Userid
                              And T1.A007_Id = User_Id_);*/
    Fetch Cur1_
      Into Row1_;
    While Cur1_%Found Loop
      --判断待发货数量是否大于差异发货的数量modify fjp 2013-01-30
         select count(*)
         into  ll_count_
          from customer_order_line_tab t
          where  t.Order_No = row1_.porder_no
           and  t.Line_No = row1_.pline_no
           and  t.Rel_No  = row1_.prel_no
           and  t.Line_Item_No=row1_.pline_item_no
           and (t.BUY_QTY_DUE - nvl(t.QTY_SHIPPED,0)) >= row1_.modifyqty;
          if ll_count_ = 0  then 
             Close Cur1_;
             Raise_Application_Error(-20101, '差异发货的数量大于可发货数量!');
          end if ;
       --end
       --判断上级变更是否是备货单变更，如果是本备货单变更，当变更的数量小于差异发货数量不让发货modify fjp2013-01-30
          select SUM(Qty_Delivedf) 
           INTO Qty_Delivedf_ 
           from BL_BILL_VARY_DETAIL t 
           WHERE  t.PICKLISTNO = ROW1_.PICKLISTNO
            And t.Order_No     = Row1_.Order_No
            And t.Line_No      = Row1_.Line_No
            And t.Rel_No       = Row1_.Rel_No
            And t.Line_Item_No = Row1_.Line_Item_No
            AND t.STATE  IN ('0','1') ;
          IF Qty_Delivedf_ < ROW1_.MODIFYQTY  THEN 
             Close Cur1_;
             Raise_Application_Error(-20101, '差异发货的数量不能大于备货单变更的数量!');
          END IF ;
      --end
      --modify fjp 20130328如果是提货，取消提货，如果是预送，取消预送
        js_state_ :=BL_CO_DELIVER_API.Get_PartDeliver(Row1_.picklistno,
                                                      Row1_.pOrder_No,
                                                      Row1_.pLine_No ,
                                                      Row1_.pRel_No,
                                                      Row1_.pLine_Item_No,
                                                      row1_.finishqty);
        --取消预留
        if js_state_ = '1' or   js_state_='2' then 
          open cur_ for 
           Select t1.*
                  From Bl_Pltrans T1
                 Where t1.PICKLISTNO   = Row1_.picklistno
                  and  T1.Order_No     = Row1_.pOrder_No
                   And T1.Rel_No       = Row1_.pRel_No
                   And T1.Line_No      = Row1_.pLine_No
                   And T1.Line_Item_No = Row1_.pLine_Item_No
                   And Nvl(T1.Flag, '0') = '0'
                   And T1.Transid Is Null
                   and T1.qty_assigned > 0;
            fetch cur_ into row3_;
            while cur_%found  loop 
            row3_.Qty_Assigned := (-1) * row3_.Qty_Assigned;
            Reserve_Customer_Order_Api.Reserve_Manually__(Info_,
                                                          State_,
                                                          row3_.Order_No,
                                                          row3_.Line_No,
                                                          row3_.Rel_No,
                                                          row3_.Line_Item_No,
                                                          row3_.Contract,
                                                          row3_.Catalog_No,
                                                          row3_.Location_No,
                                                          row3_.Lot_Batch_No,
                                                          row3_.Serial_No,
                                                          row3_.Eng_Chg_Leve,
                                                          row3_.Waiv_Dev_Rej_No,
                                                          Pallet_Id_,
                                                          row3_.Qty_Assigned);                                            
            fetch cur_ into row3_;
            end loop;
            close cur_;
        end if ;
        --取消提货
        if js_state_ = '3' or   js_state_='4' then 
            Info_       := '';
            Bl_Co_Deliver_Api.Deliver_Line_With_Diff_Qty__(Info_,
                                                           Row1_.pOrder_No,
                                                           Row1_.pLine_No,
                                                           Row1_.pRel_No,
                                                           Row1_.pLine_Item_No,
                                                           0,
                                                           User_Id_,
                                                           A311_Key_);                                           
        end if ;   
         --更新保隆的记录表 modify FJP 2012-12-06
        if js_state_ = '1' or   js_state_='2' or js_state_ = '3' or   js_state_='4' then 
            delete from   Bl_Pltrans
             Where Picklistno   = Row1_.Picklistno
               And Order_No     = Row1_.pOrder_No
               And Line_No      = Row1_.pLine_No
               And Rel_No       = Row1_.pRel_No
               And Line_Item_No = Row1_.pLine_Item_No
               And Nvl(Flag, '0') = '0'
               And Transid Is Null
               and qty_assigned > 0
               and Flag='0';
          end if;
            --END---                            
      --end
      Select *
        Into Row2_
        From Bl_Delivery_Plan_Detial_v
       Where Picklistno = Row1_.Picklistno
         And Order_No = Row1_.Order_No
         And Line_No = Row1_.Line_No
         And Rel_No = Row1_.Rel_No
         And Line_Item_No = Row1_.Line_Item_No
         And State = '2';
      Update Bl_Delivery_Plan_Detial
         Set Qty_Delived = Row1_.Modifyqty
       Where Rowid = Row2_.Objid;
      --写更改记录
      Msg_ := '由于差异发货,数量由' || To_Char(Row1_.Finishqty) || '改成' ||
              To_Char(Row1_.Modifyqty);
      Bldelivery_Plan_Line_Api.Savehist__(Row2_.Objid,
                                          User_Id_,
                                          A311_Key_,
                                          Msg_);
      Fetch Cur1_
        Into Row1_;
    End Loop;
    Close Cur1_;
    --当产生差异发货的时候更新已经存在的交货计划变更为作废状态 2012-12-05
      update Bl_Bill_Vary_Detail t
       set t.State = '5'
       where  SUBSTR(T.MODIFY_ID,1,1)='2'
        and   t.State In ('0', '1')
        and exists(
        select * 
        from  Bl_Pldtldiff t1 
        where t1.Pldtldiff_No = Pldtldiff_No_
          and  t.order_no = t1.order_no
          and  t.line_no = t1.line_no
          and  t.rel_no = t1.rel_no
          and  t.LINE_ITEM_NO = t1.LINE_ITEM_NO);
    --end------
    --生产交货计划变更  
    Pdrelease__(Pldtldiff_No_, User_Id_, A311_Key_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PLDTL_HD', Rowid_);
    Return;
  End;
  Procedure Pdrelease__(Pldtldiff_No_ Varchar2,
                        User_Id_      Varchar2,
                        A311_Key_     Varchar2) Is
    Cur_        t_Cursor;
    Cur1_       t_Cursor;
    Cur2_       t_Cursor;
    Row_        Bl_Pldtldiff%Rowtype;
    Bdpdrow_    Bl_Delivery_Plan_Detial%Rowtype;
    Irow_       Bl_Bill_Vary%Rowtype;
    Idetailrow_ Bl_Bill_Vary_Detail%Rowtype;
    Order_No_   Bl_Pldtldiff.Order_No%Type;
    Pcontract_  Bl_Pldtldiff.Pcontract%Type;
    Picklistno_ Bl_Pldtldiff.Picklistno%Type;
    i           Int;
    Objid_      Varchar2(100);
    Rowobjid_   Varchar2(100);
  Begin
    Open Cur_ For
      Select Distinct Picklistno, Order_No, Pcontract
        From Bl_Pldtldiff
       Where Pldtldiff_No = Pldtldiff_No_;
    Fetch Cur_
      Into Picklistno_, Order_No_, Pcontract_;
    While Cur_%Found Loop
      Bl_Customer_Order_Api.Getseqno('2' || To_Char(Sysdate, 'YYMMDD'),
                                     User_Id_,
                                     3,
                                     Irow_.Modify_Id);
      Insert Into Bl_Bill_Vary
        (Modify_Id)
      Values
        (Irow_.Modify_Id)
      Returning Rowid Into Objid_;
      Irow_.Source_No  := Order_No_ || '-' || Pcontract_;
      Irow_.Date_Puted := Sysdate;
      Irow_.Smodify_Id := 'F' || Pldtldiff_No_;
      Irow_.Type_Id    := '2';
      Irow_.Enter_Date := Sysdate;
      Irow_.Enter_User := User_Id_;
      Select Customer_Ref
        Into Irow_.Customer_Ref
        From Bl_Picklist
       Where Picklistno = Picklistno_;
      Irow_.State := '0';
      Update Bl_Bill_Vary Set Row = Irow_ Where Rowid = Objid_;
      i := 0;
      Open Cur1_ For
        Select t.*
          From Bl_Pldtldiff t
         Where t.Pldtldiff_No = Pldtldiff_No_
           And Order_No = Order_No_
           And Pcontract = Pcontract_;
      Fetch Cur1_
        Into Row_;
      While Cur1_%Found Loop
        ---获取交货计划
        Open Cur2_ For
          Select t.*
            From Bl_Delivery_Plan_Detial t
           Where t.Picklistno = Row_.Picklistno
             And t.Order_No = Row_.Order_No
             And t.Line_No = Row_.Line_No
             And t.Rel_No = Row_.Rel_No
             And t.Line_Item_No = Row_.Line_Item_No
             And t.State = '2';
        Fetch Cur2_
          Into Bdpdrow_;
        If Cur2_%Notfound Then
          Close Cur2_;
          Raise_Application_Error(-20101, '没有找到交货计划的信息');
          Return;
        End If;
        Close Cur2_;
        i                              := i + 1;
        Idetailrow_.Modify_Id          := Irow_.Modify_Id;
        Idetailrow_.Modify_Lineno      := i;
        Idetailrow_.Base_No            := 'F' || Pldtldiff_No_;
        Idetailrow_.Base_Line          := i;
        Idetailrow_.Order_No           := Row_.Order_No;
        Idetailrow_.Line_No            := Row_.Line_No;
        Idetailrow_.Rel_No             := Row_.Rel_No;
        Idetailrow_.Line_Item_No       := Row_.Line_Item_No;
        Idetailrow_.Column_No          := Bdpdrow_.Column_No;
        Idetailrow_.Picklistno         := Row_.Picklistno;
        Idetailrow_.Qty_Delived        := Row_.Finishqty;
        Idetailrow_.Qty_Delivedf       := Row_.Modifyqty;
        Idetailrow_.Delived_Date       := Bdpdrow_.Delived_Date;
        Idetailrow_.Delived_Datef      := Bdpdrow_.Delived_Date;
        Idetailrow_.Version            := Bdpdrow_.Version;
        Idetailrow_.State              := Irow_.State;
        Idetailrow_.Reason             := '';
        Idetailrow_.Reason_Description := '';
        Idetailrow_.Remark             := '';
        Idetailrow_.Enter_User         := User_Id_;
        Idetailrow_.Enter_Date         := Sysdate;
      
        Idetailrow_.New_Data := '';
        Pkg_a.Set_Item_Value('ORDER_NO',
                             Bdpdrow_.Order_No,
                             Idetailrow_.New_Data);
        Pkg_a.Set_Item_Value('LINE_NO',
                             Bdpdrow_.Line_No,
                             Idetailrow_.New_Data);
        Pkg_a.Set_Item_Value('REL_NO',
                             Bdpdrow_.Rel_No,
                             Idetailrow_.New_Data);
        Pkg_a.Set_Item_Value('LINE_ITEM_NO',
                             Bdpdrow_.Line_Item_No,
                             Idetailrow_.New_Data);
        Pkg_a.Set_Item_Value('LINE_KEY',
                             Bdpdrow_.Order_No || '-' || Bdpdrow_.Line_No || '-' ||
                             Bdpdrow_.Rel_No || '-' ||
                             Bdpdrow_.Line_Item_No,
                             Idetailrow_.New_Data);
      
        Pkg_a.Set_Item_Value('F_ORDER_NO',
                             Bdpdrow_.f_Order_No,
                             Idetailrow_.New_Data);
        Pkg_a.Set_Item_Value('F_LINE_NO',
                             Bdpdrow_.f_Line_No,
                             Idetailrow_.New_Data);
        Pkg_a.Set_Item_Value('F_REL_NO',
                             Bdpdrow_.f_Rel_No,
                             Idetailrow_.New_Data);
        Pkg_a.Set_Item_Value('F_LINE_ITEM_NO',
                             Bdpdrow_.f_Line_Item_No,
                             Idetailrow_.New_Data);
        Pkg_a.Set_Item_Value('F_LINE_KEY',
                             Bdpdrow_.f_Order_No || '-' ||
                             Bdpdrow_.f_Line_No || '-' || Bdpdrow_.f_Rel_No || '-' ||
                             Bdpdrow_.f_Line_Item_No,
                             Idetailrow_.New_Data);
        /*                   Pkg_a.Set_Item_Value('BLORDER_NO',
        Bdpdrow_.Blorder_No,
        Idetailrow_.New_Data);*/
        /*                  Pkg_a.Set_Item_Value('SUPPLIER',
        Bdpdrow_.Supplier,
        Idetailrow_.New_Data);*/
        Idetailrow_.Line_Key    := Bdpdrow_.Delplan_No || '-' ||
                                   To_Char(Bdpdrow_.Delplan_Line);
        Idetailrow_.Modify_Type := 'FM'; --备货单变更    
        Insert Into Bl_Bill_Vary_Detail
          (Modify_Id, Modify_Lineno)
        Values
          (Idetailrow_.Modify_Id, Idetailrow_.Modify_Lineno)
        Returning Rowid Into Rowobjid_;
      
        Update Bl_Bill_Vary_Detail
           Set Row = Idetailrow_
         Where Rowid = Rowobjid_;
        --新增
        i                              := i + 1;
        Idetailrow_.Modify_Id          := Irow_.Modify_Id;
        Idetailrow_.Modify_Lineno      := i;
/*      modify fjp 2013-02-04 当订单已经变更了数量，此新增的数量可能没有那么多， 
        则需要可删除这个交货计划变更的数量  
        Idetailrow_.Base_No            := 'F' || Pldtldiff_No_;
        Idetailrow_.Base_Line          := i;*/
        Idetailrow_.Order_No           := Row_.Order_No;
        Idetailrow_.Line_No            := Row_.Line_No;
        Idetailrow_.Rel_No             := Row_.Rel_No;
        Idetailrow_.Line_Item_No       := Row_.Line_Item_No;
        Idetailrow_.Column_No          := '';
        Idetailrow_.Picklistno         := '';
        Idetailrow_.Qty_Delived        := 0;
        Idetailrow_.Qty_Delivedf       := Row_.Finishqty - Row_.Modifyqty;
        Idetailrow_.Delived_Date       := To_Date('2999-01-01',
                                                  'YYYY-MM-DD');
        Idetailrow_.Delived_Datef      := To_Date('2999-01-01',
                                                  'YYYY-MM-DD');
        Idetailrow_.Version            := '';
        Idetailrow_.State              := Irow_.State;
        Idetailrow_.Reason             := '';
        Idetailrow_.Reason_Description := '';
        Idetailrow_.Remark             := '';
        Idetailrow_.Enter_User         := User_Id_;
        Idetailrow_.Enter_Date         := Sysdate;
      
        Idetailrow_.Line_Key    := '';
        Idetailrow_.Modify_Type := 'DPI'; --备货单变更    
        Insert Into Bl_Bill_Vary_Detail
          (Modify_Id, Modify_Lineno)
        Values
          (Idetailrow_.Modify_Id, Idetailrow_.Modify_Lineno)
        Returning Rowid Into Rowobjid_;
      
        Update Bl_Bill_Vary_Detail
           Set Row = Idetailrow_
         Where Rowid = Rowobjid_;
        Fetch Cur1_
          Into Row_;
      End Loop;
      Close Cur1_;
      Fetch Cur_
        Into Picklistno_, Order_No_, Pcontract_;
    End Loop;
    Close Cur_;
  End;
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2, --main 
                         Rowlist_     Varchar2, --行rowlist 
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2 --输出
                         ) Is
    Attr_Out Varchar2(4000);
    Row0_    Bl_v_Co_Deliver_Detail%Rowtype;
    Row_     Bl_v_Bl_Pldtl_Diversity%Rowtype;
    Cur_     t_Cursor;
  Begin
    If Column_Id_ = 'NEXT_PICKLISTNO' Then
      Row_.Next_Picklistno := Pkg_a.Get_Item_Value('NEXT_PICKLISTNO',
                                                   Rowlist_);
      Row_.Co_Contract     := Pkg_a.Get_Item_Value('CONTRACT', Mainrowlist_);
      Open Cur_ For
        Select t.*
          From Bl_v_Co_Deliver_Detail t
         Where t.Picklistno = Pkg_a.Get_Str_(Row_.Next_Picklistno, '-', 1)
           And t.Co_Order_No = Pkg_a.Get_Str_(Row_.Next_Picklistno, '-', 2)
           And t.Co_Line_No = Pkg_a.Get_Str_(Row_.Next_Picklistno, '-', 3)
           And t.Co_Rel_No = Pkg_a.Get_Str_(Row_.Next_Picklistno, '-', 4)
           And t.Co_Line_Item_No =
               Pkg_a.Get_Str_(Row_.Next_Picklistno, '-', 5)
           And t.Next_Picklistno = Row_.Next_Picklistno;
      Fetch Cur_
        Into Row0_;
      If Cur_%Found Then
        Pkg_a.Set_Item_Value('FLAG', '0', Attr_Out);
        Pkg_a.Set_Item_Value('PICKLISTNO', Row0_.Picklistno, Attr_Out);
        Pkg_a.Set_Item_Value('ORDER_NO', Row0_.Order_No, Attr_Out);
        Pkg_a.Set_Item_Value('LINE_NO', Row0_.Line_No, Attr_Out);
        Pkg_a.Set_Item_Value('REL_NO', Row0_.Rel_No, Attr_Out);
        Pkg_a.Set_Item_Value('LINE_ITEM_NO', Row0_.Line_Item_No, Attr_Out);
        Pkg_a.Set_Item_Value('CONTRACT', Row0_.Contract, Attr_Out);
        Pkg_a.Set_Item_Value('CO_ORDER_NO', Row0_.Co_Order_No, Attr_Out);
        Pkg_a.Set_Item_Value('CO_LINE_NO', Row0_.Co_Line_No, Attr_Out);
        Pkg_a.Set_Item_Value('CO_REL_NO', Row0_.Co_Rel_No, Attr_Out);
        Pkg_a.Set_Item_Value('CO_LINE_ITEM_NO',Row0_.Co_Line_Item_No,Attr_Out);
        Pkg_a.Set_Item_Value('CO_CONTRACT', Row_.Co_Contract, Attr_Out);
        Pkg_a.Set_Item_Value('FINISHQTY', Row0_.Finishqty, Attr_Out);
        Pkg_a.Set_Item_Value('CATALOG_NO', Row0_.Catalog_No, Attr_Out);
        Pkg_a.Set_Item_Value('CATALOG_DESC', Row0_.Catalog_Desc, Attr_Out);
        Pkg_a.Set_Item_Value('SUPPLIER', Row0_.BPSUPPLIER, Attr_Out);
      End If;
      Close Cur_;
    End If;
    Outrowlist_ := Attr_Out;
    Return;
  End;
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    Row_ Bl_v_Bl_Pldtl_Diversity%Rowtype;
  Begin
    Row_.Next_Picklistno := Pkg_a.Get_Item_Value('NEXT_PICKLISTNO',
                                                 Rowlist_);
    Row_.Flag            := Pkg_a.Get_Item_Value('FLAG', Rowlist_);
    If Nvl(Row_.Next_Picklistno, 'NULL') <> 'NULL' And
       Column_Id_ = 'NEXT_PICKLISTNO' Then
      Return '0';
    End If;
    If Row_.Flag <> '0' Then
      Return '0';
    End If;
    Return '1';
  End;
  ----检查新增 修改 
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2 Is
    Cur_ t_Cursor;
    Row_ Bl_v_Bl_Pldtl_Hd%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Bl_Pldtl_Hd t Where t.Picklistno = Order_No_;
    Fetch Cur_
      Into Row_;
    If Cur_%Found Then
      If Row_.Flag <> '0' Then
        Close Cur_;
        Return '0';
      End If;
    End If;
    Close Cur_;
    Return '1';
  End;
End Bl_Bl_Pldtldiff_Api;
/
