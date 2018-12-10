Create Or Replace Package Pkg_a_Job Is
  ---执行job的包
  Procedure Jobbya315;
  --刷行全部菜单
  Procedure Rea013;
  Procedure Recustomer_Order_Line;
End Pkg_a_Job;
/
Create Or Replace Package Body Pkg_a_Job Is
  --执行a315中的过程
  Type t_Cursor Is Ref Cursor;
  Procedure Jobbya315 Is
    Cur_     t_Cursor;
    Cur1_    t_Cursor;
    A315_    A315%Rowtype;
    A315_Id_ A315.A315_Id%Type;
    Res_     Number;
    If_Do_   Varchar2(1);
  Begin
  
    --自动执行A315的JOB表中未执行的JOB
    Open Cur_ For
      Select t.*
        From A315 t
       Where t.State = '0'
         And t.Do_Time < Sysdate
       Order By t.A315_Id Asc;
    Fetch Cur_
      Into A315_;
    Loop
      Exit When Cur_%Notfound;
      If_Do_ := '1'; --默认执行
      If A315_.p_Key <> 0 And A315_.p_Key <> A315_.A311_Key Then
        Open Cur1_ For
          Select 1
            From A315 t
           Where t.A311_Key = A315_.p_Key
             And t.State = '0';
        Fetch Cur1_
          Into Res_;
        If Cur1_%Found Then
          If_Do_ := '0';
        End If;
        Close Cur1_;
      
      End If;
      If If_Do_ = '1' Then
        A315_.A315_Sql := 'begin ' || A315_.A315_Sql || ';end;';
        A315_Id_       := A315_.A315_Id;
        Execute Immediate A315_.A315_Sql;
        If A315_.A311_Key < 10000 Then
          --报表
          Update A315 t
             Set Modi_Date = Sysdate, Modi_User = 'IFSAPP'
           Where t.A315_Id = A315_.A315_Id;
        Else
          If Instr(Upper(A315_.A315_Sql), '_PKG_MSG.') > 1 Then
            Delete From A315 Where A315_Id = A315_.A315_Id;
          Else
            Update A315
               Set State = '1', Modi_Date = Sysdate, Modi_User = 'IFSAPP'
             Where A315_Id = A315_.A315_Id;
          End If;
        
        End If;
      
        Commit;
      End If;
      Fetch Cur_
        Into A315_;
    End Loop;
    Close Cur_;
    /*DELETE FROM A315
     WHERE State = '1'
       AND Do_Time < SYSDATE;
    COMMIT;*/
    Return;
  Exception
    When Others Then
      Rollback;
      A315_.Res := Sqlcode || '---' || Sqlerrm;
      Update A315
         Set State = '-1',
             Res   = A315_.Res,
             --SQLCODE || '---' ||  ,
             Modi_Date = Sysdate,
             Modi_User = 'IFSAPP'
       Where A315_Id = A315_Id_;
      Commit;
  End;

  --刷新菜单角色
  Procedure Rea013 Is
    Cur_  t_Cursor;
    A002_ A002%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From A002 t;
    Fetch Cur_
      Into A002_;
    Loop
      Exit When Cur_%Notfound;
      Pkg_a.After_Insert_A002(A002_.Menu_Id, 'SYSTEM');
      Commit;
      Fetch Cur_
        Into A002_;
    End Loop;
    Close Cur_;
  
  End;
  Procedure Recustomer_Order_Line Is
    Cur_       t_Cursor;
    Cur1_      t_Cursor;
    Coline_    Customer_Order_Line_Tab%Rowtype;
    Parcoline_ Customer_Order_Line_Tab%Rowtype;
    Irow_      Bl_Customer_Order_Line%Rowtype;
    Coirow_    Bl_Customer_Order%Rowtype;
    Co_        Customer_Order_Tab%Rowtype;
    Parco_     Customer_Order_Tab%Rowtype; --最外层的订单
    Po_        Bl_v_Purchase_Order%Rowtype;
    Poirow_    Bl_Purchase_Order_Line_Part%Rowtype;
    Porow_     Bl_Purchase_Order%Rowtype;
    Poprow_    Purchase_Order_Tab%Rowtype; --采购订单
    Order_No_  Varchar2(50);
    Exec_Key_  Number;
    A315_      A315%Rowtype;
    Bl_Pldtl_  Bl_Pldtl_v%Rowtype;
    Co_Charge_ Customer_Order_Charge_Tab%Rowtype;
    Date_      Date;
  Begin
    Exec_Key_ := 1;
    Open Cur_ For
      Select t.*
        From A315 t
       Where t.A311_Key = Exec_Key_
         And t.State = '0';
    Fetch Cur_
      Into A315_;
    If Cur_%Notfound Then
      Pkg_a.Setnextdo(Exec_Key_,
                      '刷新订单数据，采购订单,备货单数据',
                      'System',
                      'Pkg_a_Job.Recustomer_Order_Line',
                      15 / 60 / 60 / 24);
    
    Else
      Update A315 t
         Set t.Do_Time = Sysdate + 15 / 60 / 60 / 24
       Where t.A315_Id = A315_.A315_Id;
    End If;
    Close Cur_;
    Commit;
    --定时执行库存件过期函数2012-12-31 FJP
    Exec_Key_ := 3;
    Open Cur_ For
      Select t.*
        From A315 t
       Where t.A311_Key = Exec_Key_
         And t.State = '0';
    Fetch Cur_
      Into A315_;
    If Cur_%Notfound Then
      Pkg_a.Setnextdo(Exec_Key_,
                      '定时执行库存件过期函数',
                      'System',
                      'BL_INVENT_PART_INSTOCKLOC_API.JobExpirationDate',
                      1);
    
    Else
      Update A315 t
         Set t.Do_Time = Sysdate + 1
       Where t.A315_Id = A315_.A315_Id;
    End If;
    Close Cur_;
    Commit;
    ---END------
    Date_ := Sysdate - 30 / 60 / 24;
    Open Cur_ For
      Select t.Order_No,
             t.Line_No,
             t.Rel_No,
             t.Line_Item_No,
             t.Demand_Order_Ref1,
             t.Demand_Order_Ref2,
             t.Demand_Order_Ref3,
             t.Demand_Order_Ref4,
             Supply_Code
        From Customer_Order_Line_Tab t
       Where (t.Order_No, t.Line_No, t.Rel_No, t.Line_Item_No) Not In
             (Select a.Order_No, a.Line_No, a.Rel_No, a.Line_Item_No
                From Bl_Customer_Order_Line a)
         And t.Date_Entered > Date_;
  
    /*Where Not Exists (Select 1
     From Bl_Customer_Order_Line T1
    Where T1.Order_No = t.Order_No
      And T1.Line_No = t.Line_No
      And T1.Rel_No = t.Rel_No
      And T1.Line_Item_No = t.Line_Item_No)*/
    --And t.Rowstate Not In ('Cancelled', 'Invoiced', 'Delivered')
  
    Fetch Cur_
      Into Coline_.Order_No,
           Coline_.Line_No,
           Coline_.Rel_No,
           Coline_.Line_Item_No,
           Coline_.Demand_Order_Ref1,
           Coline_.Demand_Order_Ref2,
           Coline_.Demand_Order_Ref3,
           Coline_.Demand_Order_Ref4,
           Coline_.Supply_Code;
    Loop
      Exit When Cur_%Notfound;
      Select t.*
        Into Parcoline_
        From Customer_Order_Line_Tab t
       Where t.Rowid =
             Bl_Customer_Order_Line_Api.Get_Par_Order_(Coline_.Order_No,
                                                       Coline_.Line_No,
                                                       Coline_.Rel_No,
                                                       Coline_.Line_Item_No,
                                                       'OBJID');
    
      Irow_.Order_No           := Coline_.Order_No;
      Irow_.Line_No            := Coline_.Line_No;
      Irow_.Rel_No             := Coline_.Rel_No;
      Irow_.Line_Item_No       := Coline_.Line_Item_No;
      Irow_.Order_Line_Key     := Coline_.Order_No || '-' ||
                                  Coline_.Line_No || '-' || Coline_.Rel_No || '-' ||
                                  Coline_.Line_Item_No;
      Irow_.Par_Order_No       := Parcoline_.Order_No;
      Irow_.Par_Line_No        := Parcoline_.Line_No;
      Irow_.Par_Rel_No         := Parcoline_.Rel_No;
      Irow_.Par_Order_Line_Key := Parcoline_.Order_No || '-' ||
                                  Parcoline_.Line_No || '-' ||
                                  Parcoline_.Rel_No || '-' ||
                                  Parcoline_.Line_Item_No;
      Irow_.Par_Line_Item_No   := Parcoline_.Line_Item_No;
      Irow_.Par_Demand_Ref1    := Parcoline_.Demand_Order_Ref1;
      Irow_.Par_Demand_Ref2    := Parcoline_.Demand_Order_Ref2;
      Irow_.Par_Demand_Ref3    := Parcoline_.Demand_Order_Ref3;
      Irow_.Par_Demand_Ref4    := Parcoline_.Demand_Order_Ref4;
      If Coline_.Supply_Code <> 'IPD' Then
        Irow_.If_End := '1';
      Else
        Irow_.If_End := '0';
      End If;
      Irow_.Enter_User := 'System';
      If Nvl(Coline_.Demand_Order_Ref1, '-') <> '-' Then
        --判断有没有采购订单
        Open Cur1_ For
          Select t.*
            From Bl_Purchase_Order_Line_Part t
           Where t.Order_No = Coline_.Demand_Order_Ref1
             And t.Line_No = Coline_.Demand_Order_Ref2
             And t.Release_No = Coline_.Demand_Order_Ref3;
        Fetch Cur1_
          Into Poirow_;
        If Cur1_%Notfound Then
          Poirow_.Order_No    := Coline_.Demand_Order_Ref1;
          Poirow_.Line_No     := Coline_.Demand_Order_Ref2;
          Poirow_.Release_No  := Coline_.Demand_Order_Ref3;
          Poirow_.Bld001_Pack := Null;
          Insert Into Bl_Purchase_Order_Line_Part
            (Order_No,
             Line_No,
             Release_No,
             Bld001_Pack,
             Enter_Date,
             Enter_User)
          Values
            (Poirow_.Order_No,
             Poirow_.Line_No,
             Poirow_.Release_No,
             Poirow_.Bld001_Pack,
             Sysdate,
             'System');
          Irow_.Enter_User := 'System';
        Else
          Irow_.Enter_User := Poirow_.Enter_User;
        End If;
        Close Cur1_;
      End If;
    
      Insert Into Bl_Customer_Order_Line
        (Order_No,
         Line_No,
         Rel_No,
         Line_Item_No,
         Par_Order_No,
         Par_Line_No,
         Par_Rel_No,
         Par_Line_Item_No,
         Par_Demand_Ref1,
         Par_Demand_Ref2,
         Par_Demand_Ref3,
         Par_Demand_Ref4,
         Enter_Date,
         Enter_User,
         Order_Line_Key,
         Par_Order_Line_Key,
         If_End)
      Values
        (Irow_.Order_No,
         Irow_.Line_No,
         Irow_.Rel_No,
         Irow_.Line_Item_No,
         Irow_.Par_Order_No,
         Irow_.Par_Line_No,
         Irow_.Par_Rel_No,
         Irow_.Par_Line_Item_No,
         Irow_.Par_Demand_Ref1,
         Irow_.Par_Demand_Ref2,
         Irow_.Par_Demand_Ref3,
         Irow_.Par_Demand_Ref4,
         Sysdate,
         Irow_.Enter_User,
         Irow_.Order_Line_Key,
         Irow_.Par_Order_Line_Key,
         Irow_.If_End);
      Commit;
      -- dbms_output.put_line( irow_.order_no || '----' || irow_.par_order_no);
      Fetch Cur_
        Into Coline_.Order_No,
             Coline_.Line_No,
             Coline_.Rel_No,
             Coline_.Line_Item_No,
             Coline_.Demand_Order_Ref1,
             Coline_.Demand_Order_Ref2,
             Coline_.Demand_Order_Ref3,
             Coline_.Demand_Order_Ref4,
             Coline_.Supply_Code;
    End Loop;
    Close Cur_;
    Open Cur_ For
      Select t.*
        From Bl_Customer_Order_Line t
       Where t.Par_Order_No Is Null
         And t.Enter_Date > Date_;
  
    Fetch Cur_
      Into Irow_;
    Loop
      --  Bl_Customer_Order_api
      Exit When Cur_%Notfound;
      Select t.*
        Into Coline_
        From Customer_Order_Line_Tab t
       Where t.Order_No = Irow_.Order_No
         And t.Line_No = Irow_.Line_No
         And t.Rel_No = Irow_.Rel_No
         And t.Line_Item_No = Irow_.Line_Item_No;
    
      Select t.*
        Into Parcoline_
        From Customer_Order_Line_Tab t
       Where t.Rowid =
             Bl_Customer_Order_Line_Api.Get_Par_Order_(Irow_.Order_No,
                                                       Irow_.Line_No,
                                                       Irow_.Rel_No,
                                                       Irow_.Line_Item_No,
                                                       'OBJID');
      If Coline_.Supply_Code <> 'IPD' Then
        Irow_.If_End := '1';
      Else
        Irow_.If_End := '0';
      End If;
      Irow_.Order_Line_Key     := Coline_.Order_No || '-' ||
                                  Coline_.Line_No || '-' || Coline_.Rel_No || '-' ||
                                  Coline_.Line_Item_No;
      Irow_.Par_Order_No       := Parcoline_.Order_No;
      Irow_.Par_Line_No        := Parcoline_.Line_No;
      Irow_.Par_Rel_No         := Parcoline_.Rel_No;
      Irow_.Par_Order_Line_Key := Parcoline_.Order_No || '-' ||
                                  Parcoline_.Line_No || '-' ||
                                  Parcoline_.Rel_No || '-' ||
                                  Parcoline_.Line_Item_No;
      Irow_.Par_Line_Item_No   := Parcoline_.Line_Item_No;
      Irow_.Par_Demand_Ref1    := Parcoline_.Demand_Order_Ref1;
      Irow_.Par_Demand_Ref2    := Parcoline_.Demand_Order_Ref2;
      Irow_.Par_Demand_Ref3    := Parcoline_.Demand_Order_Ref3;
      Irow_.Par_Demand_Ref4    := Parcoline_.Demand_Order_Ref4;
    
      Update Bl_Customer_Order_Line
         Set Row = Irow_
       Where Order_No = Irow_.Order_No
         And Line_No = Irow_.Line_No
         And Rel_No = Irow_.Rel_No
         And Line_Item_No = Irow_.Line_Item_No;
      Commit;
      Fetch Cur_
        Into Irow_;
    End Loop;
  
    Close Cur_;
  
    Open Cur_ For
      Select t.*
        From Customer_Order_Tab t
       Where Not Exists (Select 1
                From Bl_Customer_Order T1
               Where T1.Order_No = t.Order_No)
         And t.Date_Entered > Date_;
  
    Fetch Cur_
      Into Co_;
    Loop
      Exit When Cur_%Notfound;
      Open Cur1_ For
        Select t.*
          From Bl_Customer_Order_Line t
         Where t.Order_No = Co_.Order_No;
      Fetch Cur1_
        Into Irow_;
      --如果是最后一层
      If Cur1_%Found Then
        Close Cur1_;
        --找最上级
        Select t.*
          Into Parcoline_
          From Customer_Order_Line_Tab t
         Where t.Rowid =
               Bl_Customer_Order_Line_Api.Get_Par_Order_(Irow_.Order_No,
                                                         Irow_.Line_No,
                                                         Irow_.Rel_No,
                                                         Irow_.Line_Item_No,
                                                         'OBJID');
        --判断最上级有没有数据                                               
        Open Cur1_ For
          Select t.*
            From Bl_Customer_Order t
           Where t.Order_No = Parcoline_.Order_No;
        Fetch Cur1_
          Into Coirow_;
        If Cur1_%Notfound Then
          Close Cur1_;
          --再判断最上级是不是采购订单
          Open Cur1_ For
            Select t.*
              From Customer_Order_Tab t
             Where t.Order_No = Parcoline_.Order_No;
          Fetch Cur1_
            Into Parco_;
          If Cur1_%Notfound Then
            Raise_Application_Error(Pkg_a.Raise_Error,
                                    '订单号' || Parcoline_.Order_No || '不存在！');
          End If;
          Close Cur1_;
          Bl_Customer_Order_Api.Getseqno(To_Char(Parco_.Date_Entered, 'YY') ||
                                         Parco_.Customer_No,
                                         'System',
                                         4,
                                         Coirow_.Blorder_No);
          --   Select s_Bl_Blorder_No.Nextval Into Coirow_.Blorder_No From Dual;
          --最上级没有 生成订单号
          Coirow_.Order_No    := Parcoline_.Order_No;
          Coirow_.q_Flag      := '0';
          Coirow_.Enter_Date  := Sysdate;
          Coirow_.Enter_User  := 'System';
          Coirow_.Bld001_Item := '';
        
          Coirow_.Bllocation_No := '';
          Coirow_.If_First      := '1';
          Coirow_.Blorder_Id    := '1';
          If Nvl(Parcoline_.Demand_Order_Ref1, '-') != '-' Then
            --
            Open Cur1_ For
              Select t.*
                From Bl_Purchase_Order t
               Where t.Order_No = Parcoline_.Demand_Order_Ref1;
            Fetch Cur1_
              Into Porow_;
            If Cur1_%Notfound Then
              --插入采购订单的头
              Insert Into Bl_Purchase_Order
                (Order_No,
                 Enter_Date,
                 Enter_User,
                 Bld001_Item,
                 Blorder_No,
                 Bllocation_No,
                 Blorder_Id)
              Values
                (Parcoline_.Demand_Order_Ref1,
                 Coirow_.Enter_Date,
                 Coirow_.Enter_User,
                 Coirow_.Bld001_Item,
                 Coirow_.Blorder_No,
                 Coirow_.Bllocation_No,
                 Coirow_.Blorder_Id);
            Else
              Coirow_.Blorder_No    := Porow_.Blorder_No;
              Coirow_.Bllocation_No := Porow_.Bllocation_No;
            End If;
            Close Cur1_;
          Else
            Coirow_.Enter_User := Porow_.Enter_User;
          End If;
          Insert Into Bl_Customer_Order
            (Order_No,
             q_Flag,
             Enter_Date,
             Enter_User,
             Bld001_Item,
             Blorder_No,
             Bllocation_No,
             Blorder_Id,
             If_First)
          Values
            (Coirow_.Order_No,
             Coirow_.q_Flag,
             Coirow_.Enter_Date,
             Coirow_.Enter_User,
             Coirow_.Bld001_Item,
             Coirow_.Blorder_No,
             Coirow_.Bllocation_No,
             Coirow_.Blorder_Id,
             Coirow_.If_First);
          Commit;
        Else
          Close Cur1_;
        End If;
        --当前不是最上级      
        If Coirow_.Order_No != Co_.Order_No Then
          Coirow_.Order_No := Co_.Order_No;
          Coirow_.If_First := '0';
          Bl_Customer_Order_Api.Usermodify__(Coirow_, 'System');
          Commit;
        End If;
      Else
        Close Cur1_;
      End If;
    
      Open Cur1_ For
        Select t.*
          From Customer_Order_Charge_Tab t
         Where t.Order_No = Co_.Order_No
           And t.Date_Entered > Date_;
      Fetch Cur1_
        Into Co_Charge_;
      If Cur1_%Found Then
        Close Cur1_;
        Open Cur1_ For
          Select t.*
            From Bl_Customer_Order t
           Where t.Order_No = Co_.Order_No;
        Fetch Cur1_
          Into Coirow_;
        If Cur1_%Notfound Then
          Close Cur1_;
          --再判断最上级是不是采购订单
          Open Cur1_ For
            Select t.*
              From Customer_Order_Tab t
             Where t.Order_No = Co_.Order_No;
          Fetch Cur1_
            Into Parco_;
          If Cur1_%Notfound Then
            Raise_Application_Error(Pkg_a.Raise_Error,
                                    '订单号' || Parco_.Order_No || '不存在！');
          End If;
          Close Cur1_;
          Bl_Customer_Order_Api.Getseqno(To_Char(Parco_.Date_Entered, 'YY') ||
                                         Parco_.Customer_No,
                                         'System',
                                         4,
                                         Coirow_.Blorder_No);
          --最上级没有 生成订单号
          Coirow_.Order_No    := Co_.Order_No;
          Coirow_.q_Flag      := '0';
          Coirow_.Enter_Date  := Sysdate;
          Coirow_.Enter_User  := 'System';
          Coirow_.Bld001_Item := '';
        
          Coirow_.Bllocation_No := '';
          Coirow_.If_First      := '1';
          Coirow_.Blorder_Id    := '5'; --费用订单
          Insert Into Bl_Customer_Order
            (Order_No,
             q_Flag,
             Enter_Date,
             Enter_User,
             Bld001_Item,
             Blorder_No,
             Bllocation_No,
             Blorder_Id,
             If_First)
          Values
            (Coirow_.Order_No,
             Coirow_.q_Flag,
             Coirow_.Enter_Date,
             Coirow_.Enter_User,
             Coirow_.Bld001_Item,
             Coirow_.Blorder_No,
             Coirow_.Bllocation_No,
             Coirow_.Blorder_Id,
             Coirow_.If_First);
          Commit;
        Else
          Close Cur1_;
        End If;
      Else
        Close Cur1_;
      End If;
    
      Fetch Cur_
        Into Co_;
    End Loop;
    Close Cur_;
    /*    Update Bl_Customer_Order t
       Set t.If_First = '0'
     Where t.Enter_Date > Date_;
    Commit;*/
  
    Update Bl_Customer_Order t
       Set t.If_First = '1'
     Where t.Order_No In
           (Select a.Order_No
              From Bl_Customer_Order a
             Where a.If_First = '0'
               And a.Order_No In
                   (Select Par_Order_No From Bl_Customer_Order_Line a))
       And t.Enter_Date > Date_;
    Commit;
    Return;
    --刷新备货单数据 执行一次就可以
    Open Cur_ For
      Select t.* From Bl_Pldtl_v t Where t.Pickuniteno Is Null;
    Fetch Cur_
      Into Bl_Pldtl_;
    Loop
      Exit When Cur_%Notfound;
      Open Cur1_ For
        Select t.Pickuniteno
          From Bl_Pickunite t
         Inner Join Bl_Pickunitehead T1
            On T1.Pickuniteno = t.Pickuniteno
           And T1.Flag In ('1', '2')
         Where t.Picklistno = Bl_Pldtl_.Picklistno;
      Fetch Cur1_
        Into Bl_Pldtl_.Pickuniteno;
      Close Cur1_;
      Bl_Pldtl_.Pickuniteno := Nvl(Bl_Pldtl_.Pickuniteno,
                                   Bl_Pldtl_.Picklistno);
      Update Bl_Pldtl t
         Set t.Pickuniteno = Bl_Pldtl_.Pickuniteno
       Where t.Rowid = Bl_Pldtl_.Objid;
      Commit;
      Fetch Cur_
        Into Bl_Pldtl_;
    End Loop;
    Close Cur_;
  
    --刷新采购订单   --执行一次就可以了
    Open Cur_ For
      Select t.*
        From Purchase_Order_Tab t
       Where Not Exists (Select 1
                From Bl_Purchase_Order a
               Where a.Order_No = t.Order_No);
    Fetch Cur_
      Into Poprow_;
    Loop
      Exit When Cur_%Notfound;
      Bl_Customer_Order_Api.Getseqno(To_Char(Poprow_.Date_Entered, 'YY') ||
                                     Poprow_.Vendor_No,
                                     'System',
                                     4,
                                     Coirow_.Blorder_No);
      --最上级没有 生成订单号
      Coirow_.Order_No    := Poprow_.Order_No;
      Coirow_.q_Flag      := '0';
      Coirow_.Enter_Date  := Sysdate;
      Coirow_.Enter_User  := 'System';
      Coirow_.Bld001_Item := '';
    
      Coirow_.Bllocation_No := '';
      Coirow_.If_First      := '1';
      Coirow_.Blorder_Id    := '1'; --费用订单
    
      Insert Into Bl_Purchase_Order
        (Order_No,
         Enter_Date,
         Enter_User,
         Bld001_Item,
         Blorder_No,
         Bllocation_No,
         Blorder_Id)
      Values
        (Coirow_.Order_No,
         Coirow_.Enter_Date,
         Coirow_.Enter_User,
         Coirow_.Bld001_Item,
         Coirow_.Blorder_No,
         Coirow_.Bllocation_No,
         Coirow_.Blorder_Id);
      Commit;
      Fetch Cur_
        Into Poprow_;
    End Loop;
  
    Close Cur_;
  
  Exception
    When Others Then
      Pkg_Msg.Sendsysmsg('WTL',
                         'ZHH',
                         '刷新订单数据错误',
                         'http://exp.bb.com/ShowForm/QueryData.aspx?code=0&JUMP_A002_KEY=3101-0&IF_JUMP=1&JUMP_KEY=-1&rcode=1389&menu_id=3101-0',
                         '3101',
                         'A311',
                         '3101',
                         '');
      Commit;
      Return;
    
  End;
End Pkg_a_Job;
/
