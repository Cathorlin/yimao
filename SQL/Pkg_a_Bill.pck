Create Or Replace Package Pkg_a_Bill Is

  --提交--
  Procedure Deliver__(Table_Id_ In Varchar2,
                      Rowid_    In Varchar2,
                      User_Id_  Varchar,
                      A311_Key_ In Number);
  Procedure Delivercancel__(Table_Id_ In Varchar2,
                            Rowid_    In Varchar2,
                            User_Id_  Varchar,
                            A311_Key_ In Number);

  --下达--
  Procedure Release__(Table_Id_ In Varchar2,
                      Rowid_    In Varchar2,
                      User_Id_  Varchar,
                      A311_Key_ In Number,
                      If_Main_  Varchar2 Default '-');
  Procedure Releasecancel__(Table_Id_ In Varchar2,
                            Rowid_    In Varchar2,
                            User_Id_  Varchar,
                            A311_Key_ In Number);

  --关闭--
  Procedure Close__(Table_Id_ In Varchar2,
                    Rowid_    In Varchar2,
                    User_Id_  Varchar,
                    A311_Key_ In Number);
  Procedure Closecancel__(Table_Id_ In Varchar2,
                          Rowid_    In Varchar2,
                          User_Id_  Varchar,
                          A311_Key_ In Number);

  --作废--

  Procedure Cancel__(Table_Id_ In Varchar2,
                     Rowid_    In Varchar2,
                     User_Id_  Varchar,
                     A311_Key_ In Number);
  Procedure Cancelcancel__(Table_Id_ In Varchar2,
                           Rowid_    In Varchar2,
                           User_Id_  Varchar,
                           A311_Key_ In Number);

  Procedure Change_Relate_Bill(Table_Id_ In Varchar2,
                               Rowid_    In Varchar2,
                               User_Id_  Varchar,
                               A311_Key_ In Number);

  Procedure Get_Do_If_Main(A311_Key_ In Number,
                           Table_Id_ In Varchar2,
                           A00201_   Out A00201_V01%Rowtype);

  Procedure Update_Store__(Table_Id_ In Varchar2,
                           Rowid_    In Varchar2,
                           Type_     In Varchar2,
                           User_Id_  Varchar,
                           A311_Key_ In Number);
  Function Stateuse(Table_Id_ In Varchar2,
                    Rowid_    In Varchar2,
                    User_Id_  Varchar,
                    A014_Id_  In Varchar2) Return Varchar2;
  Function Get_Status_Sql(Table_Id_ In Varchar2, Rowid_ In Varchar2)
    Return Varchar2;
  Function Getstatus(Table_Id_ In Varchar2, Rowid_ In Varchar2)
    Return Varchar2;
  Procedure Update_Status(Table_Id_ In Varchar2,
                          Rowid_    In Varchar2,
                          State_    In Varchar2);
End Pkg_a_Bill;
/
Create Or Replace Package Body Pkg_a_Bill Is

  Type t_Cursor Is Ref Cursor;

  ----单据提交
  Procedure Deliver__(Table_Id_ In Varchar2,
                      Rowid_    In Varchar2,
                      User_Id_  Varchar,
                      A311_Key_ In Number) Is
    Sql_   Varchar2(2000);
    State_ Varchar2(2000);
  Begin
    State_ := Getstatus(Table_Id_, Rowid_);
    If State_ <> '0' Then
      Pkg_a.Setmsg(A311_Key_, '', '只有状态为0才能提交！');
      Pkg_a.Setfailed(A311_Key_, Table_Id_, Rowid_);
      Return;
    End If;
    Update_Status(Table_Id_, Rowid_, '1');
    Pkg_a.Setmsg(A311_Key_, '', '提交操作成功');
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowid_);
  End;

  ----单据取消提交 

  Procedure Delivercancel__(Table_Id_ In Varchar2,
                            Rowid_    In Varchar2,
                            User_Id_  Varchar,
                            A311_Key_ In Number) Is
    Sql_   Varchar2(2000);
    State_ Varchar2(2000);
  
  Begin
    State_ := Getstatus(Table_Id_, Rowid_);
    If State_ <> '1' Then
      Pkg_a.Setmsg(A311_Key_, '', '只有状态为1才能取消提交！');
      Pkg_a.Setfailed(A311_Key_, Table_Id_, Rowid_);
      Return;
    End If;
  
    Update_Status(Table_Id_, Rowid_, '0');
    Pkg_a.Setmsg(A311_Key_, '', '取消提交操作成功');
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowid_);
  End;

  ---下达--
  Procedure Release__(Table_Id_ In Varchar2,
                      Rowid_    In Varchar2,
                      User_Id_  Varchar,
                      A311_Key_ In Number,
                      If_Main_  Varchar2 Default '-') Is
    Sql_       Varchar2(2000);
    State_     Varchar2(2000);
    Cur_       t_Cursor;
    A002_      A002%Rowtype;
    If_Main    Varchar2(1);
    Menu_Id_   Varchar2(1);
    A00201_    A00201_V01%Rowtype;
    Detail_Sql Varchar2(2000);
    A00201__   A00201_V01%Rowtype;
    Drowid_    Varchar2(2000);
    Cur__      t_Cursor;
    Main_Key_v Varchar2(200);
  Begin
    State_ := Getstatus(Table_Id_, Rowid_);
    If State_ <> '1' Then
      Pkg_a.Setmsg(A311_Key_, '', '只有状态为1才能下达！');
      Pkg_a.Setfailed(A311_Key_, Table_Id_, Rowid_);
      Return;
    End If;
    /*判断是否是主档*/
    If If_Main_ = '-' Then
      Get_Do_If_Main(A311_Key_, Table_Id_, A00201_);
      If_Main := A00201_.If_Main;
    Else
      If_Main := If_Main_;
    End If;
    /*end 判断是否是主档*/
    If If_Main = '0' Then
      ---如果是明细--
      ----更新明细的信息------ 
      Change_Relate_Bill(A00201__.Table_Id, Drowid_, User_Id_, A311_Key_);
    
    End If;
    If If_Main = '1' Then
      --循环明细 下达明细--     
      Detail_Sql := 'Select ' || A00201__.Main_Key || ' from ' || Table_Id_ ||
                    ' t where t.rowid=''' || Rowid_ || '''';
      Open Cur_ For Detail_Sql;
      Fetch Cur_
        Into Main_Key_v;
      If Cur_%Notfound Then
        Close Cur_;
        Pkg_a.Setmsg(A311_Key_, '', Rowid_ || '错误');
        Pkg_a.Setfailed(A311_Key_, Table_Id_, Rowid_);
        Return;
      End If;
      Close Cur_;
    
      Open Cur_ For
        Select t.*
          From A00201_V01 t
         Where t.Menu_Id = A00201_.Menu_Id
           And t.If_Main = '0';
      --a00201__
      Fetch Cur_
        Into A00201__;
      Loop
        Exit When Cur_%Notfound;
        Detail_Sql := 'Select t.rowid from  ' || A00201__.Table_Id ||
                      ' t where t.' || A00201_.Main_Key || '=''' ||
                      Main_Key_v || '''';
      
        Drowid_ := '';
        Release__(A00201__.Table_Id, Drowid_, User_Id_, A311_Key_, '0');
        If Pkg_a.Ifsuccess(A311_Key_) <> '1' Then
          Close Cur_;
          Return;
        End If;
        Fetch Cur_
          Into A00201__;
      End Loop;
      Close Cur_;
    End If;
    Update_Status(Table_Id_, Rowid_, '2');
    Pkg_a.Setmsg(A311_Key_, '', '下达操作成功');
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowid_);
  End;

  --procedure change_base_no(table_id in varchar2 ,rowid_ in varchar2)
  Procedure Get_Do_If_Main(A311_Key_ In Number,
                           Table_Id_ In Varchar2,
                           A00201_   Out A00201_V01%Rowtype) Is
    A311_    A311%Rowtype;
    Pos      Number;
    Menu_Id_ Varchar2(50);
    If_Main_ Varchar2(50);
  Begin
    Select t.*
      Into A311_
      From A311 t
     Where t.A311_Key = A311_Key_
       And Rownum = 1;
    Pos := Nvl(Instr(A311_.A311_Id, '-'), 0);
    If Pos = 0 Then
      Pos := Nvl(Instr(A311_.A311_Id, '_'), 0);
    End If;
    If Pos = 0 Then
      A00201_.If_Main := '-';
      Return;
    End If;
    Menu_Id_ := Substr(A311_.A311_Id, 1, Pos - 1);
  
    Select t.*
      Into A00201_
      From A00201_V01 t
     Where t.Menu_Id = Menu_Id_
       And t.Table_Id = Table_Id_
       And Rownum = 1;
  
  End;

  ---取消下达--
  Procedure Releasecancel__(Table_Id_ In Varchar2,
                            Rowid_    In Varchar2,
                            User_Id_  Varchar,
                            A311_Key_ In Number) Is
    Sql_   Varchar2(2000);
    State_ Varchar2(2000);
  Begin
    State_ := Getstatus(Table_Id_, Rowid_);
    If State_ <> '2' Then
      Pkg_a.Setmsg(A311_Key_, '', '只有状态为2才能下达！');
      Pkg_a.Setfailed(A311_Key_, Table_Id_, Rowid_);
      Return;
    End If;
  
    Update_Status(Table_Id_, Rowid_, '1');
    --更新库存
    Update_Store__(Table_Id_, Rowid_, '0', User_Id_, A311_Key_);
    Pkg_a.Setmsg(A311_Key_, '', '取消下达操作成功');
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowid_);
  End;

  ---关闭--
  Procedure Close__(Table_Id_ In Varchar2,
                    Rowid_    In Varchar2,
                    User_Id_  Varchar,
                    A311_Key_ In Number) Is
    Sql_   Varchar2(2000);
    State_ Varchar2(2000);
  Begin
    State_ := Getstatus(Table_Id_, Rowid_);
    If State_ <> '2' Then
      Pkg_a.Setmsg(A311_Key_, '', '只有状态为2才能关闭！');
      Pkg_a.Setfailed(A311_Key_, Table_Id_, Rowid_);
      Return;
    End If;
    Update_Status(Table_Id_, Rowid_, '3');
    Pkg_a.Setmsg(A311_Key_, '', '下达操作成功');
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowid_);
  End;

  ---关闭--
  Procedure Closecancel__(Table_Id_ In Varchar2,
                          Rowid_    In Varchar2,
                          User_Id_  Varchar,
                          A311_Key_ In Number) Is
    Sql_   Varchar2(2000);
    State_ Varchar2(2000);
  Begin
    State_ := Getstatus(Table_Id_, Rowid_);
    If State_ <> '3' Then
      Pkg_a.Setmsg(A311_Key_, '', '只有状态为2才能取消关闭！');
      Pkg_a.Setfailed(A311_Key_, Table_Id_, Rowid_);
      Return;
    End If;
    Update_Status(Table_Id_, Rowid_, '2');
    Pkg_a.Setmsg(A311_Key_, '', '下达操作成功');
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowid_);
  End;

  --Cancel--

  Procedure Cancel__(Table_Id_ In Varchar2,
                     Rowid_    In Varchar2,
                     User_Id_  Varchar,
                     A311_Key_ In Number) Is
    Sql_   Varchar2(2000);
    State_ Varchar2(2000);
  Begin
    State_ := Getstatus(Table_Id_, Rowid_);
    If State_ <> '1' Then
      Pkg_a.Setmsg(A311_Key_, '', '只有状态为1才能作废！');
      Pkg_a.Setfailed(A311_Key_, Table_Id_, Rowid_);
      Return;
    End If;
    Update_Status(Table_Id_, Rowid_, '4');
    Pkg_a.Setmsg(A311_Key_, '', '作废操作成功');
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowid_);
  End;

  ---------------取消作废
  Procedure Cancelcancel__(Table_Id_ In Varchar2,
                           Rowid_    In Varchar2,
                           User_Id_  Varchar,
                           A311_Key_ In Number) Is
    Sql_   Varchar2(2000);
    State_ Varchar2(2000);
  Begin
    State_ := Getstatus(Table_Id_, Rowid_);
    If State_ <> '4' Then
      Pkg_a.Setmsg(A311_Key_, '', '只有状态为4才能作废！');
      Pkg_a.Setfailed(A311_Key_, Table_Id_, Rowid_);
      Return;
    End If;
    Update_Status(Table_Id_, Rowid_, '1');
    Pkg_a.Setmsg(A311_Key_, '', '作废操作成功');
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowid_);
  End;

  ----修改
  Procedure Change_Relate_Bill(Table_Id_ In Varchar2,
                               Rowid_    In Varchar2,
                               User_Id_  Varchar,
                               A311_Key_ In Number) Is
  Begin
  
    Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowid_);
  End;

  --获取用户是否可以操作右键 可以返回用户名称 -- 
  Function Stateuse(Table_Id_ In Varchar2,
                    Rowid_    In Varchar2,
                    User_Id_  Varchar,
                    A014_Id_  In Varchar2) Return Varchar2 Is
    Sql_     Varchar2(2000);
    Cur_     t_Cursor;
    State_   Varchar2(200);
    i        Number;
    Useable_ Varchar2(2000);
  Begin
    State_ := Getstatus(Table_Id_, Rowid_);
    Open Cur_ For
      Select t.Useable
        From A01401 t
       Where t.A014_Id = A014_Id_
         And t.Status = State_
         And t.Table_Id = Table_Id_;
    Fetch Cur_
      Into Useable_;
    If Cur_%Notfound Then
      Close Cur_;
      Open Cur_ For
        Select t.Useable
          From A01401 t
         Where t.A014_Id = A014_Id_
           And t.Status = State_
           And t.Table_Id = 'DEFAULT';
      Fetch Cur_
        Into Useable_;
      If Cur_%Notfound Then
        Return '-1';
      End If;
    End If;
    Close Cur_;
    If Useable_ = '1' Then
      Return User_Id_;
    End If;
    Return '-1';
  Exception
    When Others Then
      Return '0';
  End;
  Function Getstatus(Table_Id_ In Varchar2, Rowid_ In Varchar2)
    Return Varchar2 Is
    Sql_   Varchar2(2000);
    Cur_   t_Cursor;
    State_ Varchar2(200);
  Begin
    Sql_ := Get_Status_Sql(Table_Id_, Rowid_);
    If Length(Nvl(Sql_, '')) < 10 Then
      Return '0';
    End If;
    Open Cur_ For Sql_;
    Fetch Cur_
      Into State_;
    If Cur_%Notfound Then
      Close Cur_;
      Return '-1';
    End If;
    Close Cur_;
    Return State_;
  Exception
    When Others Then
      Return '-1';
  End;

  Function Get_Status_Sql(Table_Id_ In Varchar2, Rowid_ In Varchar2)
    Return Varchar2 Is
    A100_   A100%Rowtype;
    Result_ Varchar2(2000);
    Count_  Number;
  Begin
    Select t.* Into A100_ From A100 t Where t.Table_Id = Table_Id_;
    Select Count(*)
      Into Count_
      From A10001 t
     Where t.Table_Id = Table_Id_
       And t.Column_Id = 'STATUS'
       And Rownum = 1;
    If Count_ > 0 Then
      Result_ := 'Select t.STATUS from ' || Table_Id_ || ' t ';
    Else
      Result_ := 'Select t.STATE  from ' || Table_Id_ || '  t ';
    End If;
  
    If A100_.Tbl_Type = 'T' Then
      Result_ := Result_ || ' WHERE rowidtochar(t.rowid) = ''' || Rowid_ || '''';
    Else
      Result_ := Result_ || ' WHERE rowidtochar(t.objid) = ''' || Rowid_ || '''';
    End If;
    Return Result_;
  Exception
    When Others Then
      Return Null;
    
  End;

  Procedure Update_Status(Table_Id_ In Varchar2,
                          Rowid_    In Varchar2,
                          State_    In Varchar2) Is
    A100_   A100%Rowtype;
    Result_ Varchar2(2000);
    Count_  Number;
  Begin
    Select t.* Into A100_ From A100 t Where t.Table_Id = Table_Id_;
    If A100_.Tbl_Type <> 'T' Then
      Return;
    End If;
  
    Select Count(*)
      Into Count_
      From A10001 t
     Where t.Table_Id = Table_Id_
       And t.Column_Id = 'STATUS'
       And Rownum = 1;
    If Count_ > 0 Then
      Result_ := 'update  ' || Table_Id_ || ' set STATUS =''' || State_ ||
                 ''' where  rowidtochar(rowid)=''' || Rowid_ || '''';
    Else
      Result_ := 'update  ' || Table_Id_ || ' set  STATE =''' || State_ ||
                 ''' where  rowidtochar(rowid)=''' || Rowid_ || '''';
    End If;
    Execute Immediate Result_;
  End;

  Procedure Update_Store__(Table_Id_ In Varchar2,
                           Rowid_    In Varchar2,
                           Type_     In Varchar2,
                           User_Id_  Varchar,
                           A311_Key_ In Number) Is
    Io_       Varchar2(10);
    Ll_Count_ Number;
  Begin
    Select Count(*)
      Into Ll_Count_
      From View_Sequence
     Where Currently = Table_Id_
       And Io Is Not Null
       And Rownum = 1;
    If Ll_Count_ > 0 Then
      Select Io
        Into Io_
        From View_Sequence
       Where Currently = Table_Id_
         And Io Is Not Null
         And Rownum = 1;
    
      --PKG_STORE_.update_store(table_id_,rowid_,type_,io_,user_id_,a311_key_);
    End If;
  End;

End Pkg_a_Bill;
/
