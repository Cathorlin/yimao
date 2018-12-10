Create Or Replace Package Pkg_a Is

  -- Author  : 吴天磊
  -- Created : 2012-03-05 9:57:02
  -- Purpose :
  /*
    -- Public type declarations
    type <TypeName> is <Datatype>;
  
    -- Public constant declarations
    <ConstantName> constant <Datatype> := <Value>;
  
    -- Public variable declarations
    <VariableName> <Datatype>;
  
    -- Public function and procedure declarations
    function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  */

  /* 传入参数
  
    a100_key_  可以使表 table_id 也可以是 A100_KEY
  
  */

  --获取建表的sql语句 --
  /*
  if_create  = 0  默认不执行sql
  
  */
  --获取字符串中数据
  Raise_Error Constant Number := -20001;
  Function Get_Item_Value(Name_ In Varchar2, Attr_ In Varchar2)
    Return Varchar2;
  --获取字符串中数据
  Function Get_Item_Value_By_Index(Index1_ In Varchar2,
                                   Index2_ In Varchar2,
                                   Attr_   In Varchar2) Return Varchar2;
  Function Get_Num_Value_By_Index(Index1_ In Varchar2,
                                  Index2_ In Varchar2,
                                  Attr_   In Varchar2) Return Number;
  Procedure Set_Item_Value(Name_  In Varchar2,
                           Value_ In Varchar2,
                           Attr_  In Out Varchar2);
  --设置列是否可编辑
  Procedure Set_Column_Enable(Name_   In Varchar2,
                              Enable_ In Varchar2,
                              Attr_   In Out Varchar2);
  Function Get_Attr_By_Ifs(Attr_ In Varchar2) Return Varchar2;
  Function Get_Attr_By_Bm(Attr_ In Varchar2) Return Varchar2;
  Procedure Setresult(A314_Key_ In Number, Res_ In Varchar2 Default '');

  Procedure Savequerysql(User_Id_    In Varchar2,
                         A00201_Key_ In Varchar2,
                         Sql_        In Varchar2);

  Function Getmenuname(A002_Key_ In Varchar2, User_Id_ In Varchar2)
    Return Varchar2;
  Function Getuserlanguage(User_Id_ In Varchar2) Return Varchar2;
  Procedure Get_Create_Table_Sql(Table_Id_ In Varchar2,
                                 If_Create Number Default 0);

  ----保存修改日志 记录修改以后的数据 从新增开始
  Procedure Save_Data_Log(Table_Id_ In Varchar2,
                          Rowlist_  In Varchar2,
                          User_Id_  In Varchar2);

  /*
  创建一个审批流程
  A331_id_ 流程id
  user_id_ 用户
  key_     表的主键   
  */
  Procedure Add_A331(A331_Id_  In Varchar2,
                     User_Id_  In Varchar2,
                     Key_      In Varchar2,
                     A311_Key_ In Number);

  /*检测一个流程是否审批完
    1 成功
    0 失败        
  */
  Function Check_A331(Table_Id_ In Varchar2,
                      Key_      In Varchar2,
                      A331_Id_  In Varchar2 Default 'ALL') Return Varchar2;

  Function Item_Exist(Name_ In Varchar2, Attr_ In Varchar2) Return Boolean;
  --获取表的字符串
  Procedure Get_Row_Str(Table_Id_ In Varchar2,
                        Wheresql_ In Varchar2,
                        Result_   Out Varchar2);
  --合并2个字符串 后面数据替代前面 new 替代 old
  Procedure Str_Add_Str(Old_Str In Out Varchar2, New_Str In Varchar2);

  Function Get_Next_From_Attr(Attr_  In Varchar2,
                              Ptr_   In Out Number,
                              Name_  In Out Varchar2,
                              Value_ In Out Varchar2) Return Boolean;
  /*
   更新审批记录
  */
  Procedure Change_A33201(Table_Id_ In Varchar2,
                          Key_      In Varchar2,
                          User_Id_  In Varchar2,
                          If_Tg     In Varchar2,
                          Des_      In Varchar2,
                          A311_Key_ In Number,
                          A332_Id_  In Number);

  /*根据系统的表和视图*/
  Procedure Insert_A10001_From_Sys(Table_Id_ In Varchar2);

  --记录一个事务--
  Procedure Setnextdo(A311_Key_  In Number,
                      Doname_    In Varchar2,
                      User_Id_   In Varchar2,
                      Nextsql_   In Varchar2,
                      Nexttimes_ In Number Default 0);
  /*单据状态改变的的存储过程*/
  Procedure Change_Bill_Status(Table_Id_ In Varchar2,
                               Key_      In Varchar2,
                               Rb_Do_    In Varchar,
                               User_Id_  Varchar2,
                               Main_Key_ In Varchar2,
                               Rb_Sql_   In Varchar2 Default '',
                               A311_Key_ In Number Default 0);

  Procedure Insert_A10001(Table_Id_ In Varchar2,
                          A311_Key_ In Number Default 0);

  Function Ifsuccess(A311_Key_ In Number) Return Varchar2;
  ---获取主表的主键数据----
  Function Get_Key_Value(Table_Id_ In Varchar2, Objid_ In Varchar2)
    Return Varchar2;
  /*新建菜单以后把菜单的数据 插入到角色表中 */
  Procedure After_Insert_A002(Menu_Id_ In Varchar2, User_Id_ In Varchar2);
  ---执行动作--
  Procedure Userdo_A33201(A33201_Key_ In Number,
                          If_Tg       In Varchar2,
                          Des_        In Varchar2,
                          User_Id_    In Varchar2,
                          A311_Key__  In Number Default 0);
  --激活下一个流程--
  Procedure Set_Next_Do(A014_Id_ In Varchar2,
                        p_A332_  A332%Rowtype,
                        User_Id_ In Varchar2);

  Procedure Set_Do_Time(Eve_Name_ In Varchar2);
  ---开始流转
  Procedure Set_First(Table_Id_ In Varchar2,
                      Objid_    In Varchar2,
                      User_Id_  In Varchar2);
  --插入一条日志
  Procedure Beginlog(A311_ In Out A311%Rowtype);
  Procedure Save_A016(Rowlist_  In Varchar2,
                      User_Id_  In Varchar2,
                      A311_Key_ In Number);

  Procedure Setsuccess(A311_Key_ In Number,
                       Table_Id_ In Varchar2 Default '',
                       Rowid_    In Varchar2 Default '');
  Procedure Setfailed(A311_Key_ In Number,
                      Table_Id_ In Varchar2 Default '',
                      Rowid_    In Varchar2 Default '');

  Procedure Setmsg(A311_Key_ In Number,
                   Msg_Id_   In Varchar2,
                   Msg__     In Varchar Default '',
                   Rowid_    In Varchar Default '');
  --获取序列的sql--
  Function Get_Create_Seq_Sql(Table_Id_ In Varchar2) Return Varchar2;

  --检测A10001的列 和系统的列的匹配性
  /*  -1 表在A100中不存在
      -2 表未创建
      1  表示是新添加的列
      0  表示是一致
  */
  Procedure Set_Next(Table_Id_ In Varchar2,
                     Main_Key_ In Varchar,
                     Key_      In Varchar2,
                     User_Id_  In Varchar2);
  Function Check_Column(Table_Id_ In Varchar2, Column_Id_ In Varchar2)
    Return Varchar2;
  Procedure Update_A009(Table_Id_ In Varchar2,
                        Key_      In Varchar2,
                        Main_Key_ In Varchar,
                        User_Id_  In Varchar2);
  /*--
   当在A10001 中数据存在 而 系统 表结构 中列不存在 执行 添加列
   并且执行插入列属性的代码 （包含权限 属性）
  */
  Procedure Add_Column(Table_Id_ In Varchar2, Column_Id_ In Varchar2);

  /*保存宽度*/
  Procedure Save_A10001(A00201_Key_ In Varchar2,
                        Width_      In Varchar2,
                        x_          In Varchar2,
                        User_Id_    In Varchar2 Default 'ADMIN');

  /*修改位置*/
  Procedure Changecolumnx(Table_Id_  In Varchar2,
                          Column_Id_ In Varchar2,
                          Type_      In Varchar2);
  Procedure Doa014(A014_Id_  In Varchar2,
                   Table_Id_ In Varchar2,
                   Objid_    In Varchar2,
                   User_Id_  In Varchar2,
                   A311_Key_ In Varchar2);

  Procedure Insert_A10001_(Rowid_    In Varchar2,
                           User_Id_  Varchar,
                           A311_Key_ In Number);
  Function Get_A022_Name(A022_Id_ In Varchar2) Return Varchar2;
  /*
   获取表查询的所有列完整的sql
  */
  Function Get_Selectdatasql(Table_Id_ In Varchar2,
                             If_Db     In Varchar2 Default '0')
    Return Varchar2;
  /*检测用户对菜单的权限 有权限返回 1 无权限返回 0
    a002_key_ 菜单
    a007_key_ 用户
    a30001_key_ 登录信息
  */
  Function Getusermenu(Menu_Id_    In Varchar2,
                       User_Id_    In Varchar2,
                       A30001_Key_ In Number) Return Varchar2;
  /* 获取表的主键*/
  Function Gettablekey(A002_ In Varchar2, Type_ In Varchar2 Default 'SAVE')
    Return Varchar2;
  /*
  
  */
  Function Get_Http_Url Return Varchar2;
  /* 获取表的主键*/
  Function Getkeylineno(A00201_Key_ In Varchar2, Key_Id In Varchar2)
    Return Varchar2;
  /*
  
  */
  Function Get_Uuser(Ucode_ In Varchar2, Uen_ In Varchar2) Return Varchar2;
  Function Get_Email(User_Id_ In Varchar) Return Varchar2;
  Function Get_Url(Table_Id_   In Varchar,
                   Rowid_      In Varchar2,
                   User_Id_    In Varchar2,
                   A33201_Key_ In Number) Return Varchar2;

  Ikey Varchar2(8) := 'oracle9i';
  Function Gen_Raw_Key(Ikey In Varchar2) Return Raw;
  Function Decrypt_3key_Mode(Ivalue In Varchar2,
                             Imode  In Pls_Integer,
                             Ikey_  In Varchar Default Ikey) Return Varchar2;
  Function Encrypt_3key_Mode(Ivalue In Varchar2,
                             Imode  In Pls_Integer,
                             Ikey_  In Varchar Default Ikey) Return Varchar2;
  Function Formatstr(Ivalue In Varchar2) Return Varchar2;
  Function Formatstr2(Ivalue In Varchar2) Return Varchar2;
  Function Formatkey(Ikey_ In Varchar2) Return Varchar2;
  Function Encrypt_Key_Mode(Ivalue In Varchar2,
                            Ikey_  In Varchar Default Ikey) Return Varchar2;
  Function Decrypt_Key_Mode(Ivalue In Varchar2,
                            Ikey_  In Varchar Default Ikey) Return Varchar2;
  --删除临时表
  Procedure Droptemptable(Table_Id_ In Varchar2);
  --建立临时表
  Procedure Createtemptable(Sql_ In Varchar2, Table_Id_ In Varchar2);
  Function Get_Str_List_By_Index(Data_ Varchar2, Index_ Varchar2)
    Return Dbms_Sql.Varchar2_Table;
  Function Get_Str_(Data_ Varchar2, Index_ Varchar2, Num_ In Number)
    Return Varchar2;
  Function Get_Sql_Value__(Sql_ Varchar2) Return Varchar2;
End Pkg_a;
/
Create Or Replace Package Body Pkg_a Is
  A100_   A100%Rowtype;
  A10001_ A10001%Rowtype;
  Count_  Number;
  Type t_Cursor Is Ref Cursor;
  i_ Number Default 0;
  /*
    -- Private type declarations
    type <TypeName> is <Datatype>;
  
    -- Private constant declarations
    <ConstantName> constant <Datatype> := <Value>;
  
    -- Private variable declarations
    <VariableName> <Datatype>;
  
    -- Function and procedure implementations
    function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
      <LocalVariable> <Datatype>;
    begin
      <Statement>;
      return(<Result>);
    end;
  */
  --begin
  -- Initialization
  -- <Statement>;
  Procedure Get_Create_Table_Sql(Table_Id_ In Varchar2,
                                 If_Create Number Default 0) Is
    Sql_       Varchar2(1000);
    A10001_Cur t_Cursor;
    All_Sql_   Long;
    If_Exist   Varchar2(1) Default '0';
  Begin
    All_Sql_ := '';
    Select Count(*) Into Count_ From A100 t Where t.Table_Id = Table_Id_;
    If Count_ = 0 Then
      Dbms_Output.Put_Line('表' || Table_Id_ || '在A100中不存在！');
      Return;
    End If;
  
    Select t.*
      Into A100_
      From A100 t
     Where t.Table_Id = Table_Id_
       And Rownum = 1;
  
    If_Exist := '0';
    /*获取表的明细*/
    All_Sql_ := 'create table ' || A100_.Table_Id || '(';
    Dbms_Output.Put_Line(All_Sql_);
    Open A10001_Cur For
      Select t.*
        From A10001 t
       Where t.Table_Id = A100_.Table_Id
       Order By Sort_By, Table_Id;
    Fetch A10001_Cur
      Into A10001_;
    i_ := 0;
    Loop
      Exit When A10001_Cur%Notfound;
      If (A10001_.Column_Id = A100_.Table_Id || '_KEY') Then
        If_Exist := '1';
      End If;
      i_   := i_ + 1;
      Sql_ := A10001_.Column_Id;
      /*字符串*/
      If Lower(A10001_.Col_Type) = 'varchar' Or
         Lower(A10001_.Col_Type) = 'char' Then
        Sql_ := Sql_ || ' varchar2(' || A10001_.Col_Len || ')';
      End If;
    
      If Lower(A10001_.Col_Type) = 'text' Or
         Lower(A10001_.Col_Type) = 'text' Then
        Sql_ := Sql_ || ' varchar2(4000)';
      End If;
    
      /*数值*/
      If Lower(A10001_.Col_Type) = 'int' Or
         Lower(A10001_.Col_Type) = 'numeric' Or
         Lower(A10001_.Col_Type) = 'decimal' Or
         Lower(A10001_.Col_Type) = 'number' Then
        Sql_ := Sql_ || ' number';
      End If;
    
      /*日期*/
      If Lower(A10001_.Col_Type) = 'date' Or
         Lower(A10001_.Col_Type) = 'datetime' Then
        Sql_ := Sql_ || ' date';
      End If;
    
      /*图片 存路径 在编辑方式中设置*/
    
      If Lower(A10001_.Col_Type) = 'image' Then
        Sql_ := Sql_ || ' varchar2(400)';
      End If;
      If (A10001_.Column_Id = A100_.Table_Id || '_KEY') Then
        Sql_ := Sql_ || ' not  null ,';
      Else
        Sql_ := Sql_ || '  null ,';
      End If;
      All_Sql_ := All_Sql_ || Sql_;
      Dbms_Output.Put_Line(Sql_);
    
      Fetch A10001_Cur
        Into A10001_;
    End Loop;
  
    Close A10001_Cur;
    All_Sql_ := Substr(All_Sql_, 1, Length(All_Sql_) - 1);
  
    Sql_ := ')tablespace USERS   pctfree 10 ';
    Sql_ := Sql_ || ' initrans 1';
    Sql_ := Sql_ || ' maxtrans 255';
    Sql_ := Sql_ || ' storage';
    Sql_ := Sql_ || '(';
    Sql_ := Sql_ || ' initial 64K';
    Sql_ := Sql_ || ' minextents 1';
    Sql_ := Sql_ || ' maxextents unlimited';
    Sql_ := Sql_ || ')';
    Dbms_Output.Put_Line(Sql_);
    All_Sql_ := All_Sql_ || Sql_;
    If If_Exist = '0' Then
      Update A100
         Set Create_Msg = '表' || A100_.Table_Id || '中没有主键' || A100_.Table_Id ||
                          '_KEY'
       Where Table_Id = A100_.Table_Id;
      Commit;
    End If;
    If If_Create = 1 And A100_.Tbl_Type = 'T' And If_Exist = '1' Then
      Execute Immediate All_Sql_;
      Dbms_Output.Put_Line(Sql_);
      Sql_ := 'alter table ' || A100_.Table_Id || '  add constraint ' ||
              A100_.Table_Id || '_PK primary key (' || A100_.Table_Id ||
              '_KEY) using index ';
      Execute Immediate Sql_;
      Dbms_Output.Put_Line(Sql_);
      /*判断序列是否存在*/
      Select Count(*)
        Into Count_
        From Sys.User_Sequences t
       Where t.Sequence_Name = 'S_' || A100_.Table_Id;
      If Count_ = 0 Then
        Sql_ := Get_Create_Seq_Sql(A100_.Table_Id);
        Execute Immediate Sql_;
        Dbms_Output.Put_Line(Sql_);
      End If;
    End If;
  End;
  /*获取序列的sql*/
  Function Get_Create_Seq_Sql(Table_Id_ In Varchar2) Return Varchar2 Is
    Result_ Varchar2(400);
  Begin
    -- Create sequence
  
    Result_ := 'create sequence S_' || Table_Id_ || Chr(10);
    Result_ := Result_ || 'minvalue 1' || Chr(10);
    Result_ := Result_ || 'maxvalue 999999999999999999999999999' || Chr(10);
    Result_ := Result_ || 'start with 1' || Chr(10);
    Result_ := Result_ || 'increment by 1' || Chr(10);
    Result_ := Result_ || 'cache 20';
    Return Result_;
  
  End;

  --检测A10001的列 和系统的列的匹配性--
  Function Check_Column(Table_Id_ In Varchar2, Column_Id_ In Varchar2)
    Return Varchar2 Is
  Begin
    Select Count(*) Into Count_ From A100 t Where t.Table_Id = Table_Id_;
    If Count_ = 0 Then
      Return '-1'; --表在A100中不存在
    End If;
  
    Select t.*
      Into A100_
      From A100 t
     Where t.Table_Id = Table_Id_
       And Rownum = 1;
  
    --判断系统有没有表--
    If A100_.Tbl_Type = 'T' Then
      Select Count(*)
        Into Count_
        From User_Tables t
       Where t.Table_Name = A100_.Table_Id;
      If Count_ = 0 Then
        Return '-2'; --表或视图还没有创建
      End If;
      --判断列的数据在  数据库表中是否存在--
      Select Count(*)
        Into Count_
        From User_Tab_Cols t
       Where t.Table_Name = A100_.Table_Id
         And t.Column_Name = Column_Id_;
      If Count_ = 0 Then
        Return '1'; --表示是新添加的列--
      End If;
    
      Return '0'; --A10001的数据和系统表一致--
    End If;
  
    --视图--
    If A100_.Tbl_Type = 'V' Then
      Select Count(*)
        Into Count_
        From User_Views t
       Where t.View_Name = A100_.Table_Id;
      If Count_ = 0 Then
        Return '-2'; --表或视图还没有创建
      End If;
      Select Count(*)
        Into Count_
        From User_Tab_Cols t
       Where t.Table_Name = A100_.Table_Id
         And t.Column_Name = Column_Id_;
      If Count_ = 0 Then
        Return '1'; --表示是新添加的列--
      End If;
      Return '0'; --A10001的数据和系统一致--
    End If;
    Return '-100'; ----
  End;

  Procedure Add_Column(Table_Id_ In Varchar2, Column_Id_ In Varchar2) Is
    Sql_ Varchar2(2000);
  Begin
    Select t.*
      Into A100_
      From A100 t
     Where t.Table_Id = Table_Id_
       And Rownum = 1;
  
    Select t.*
      Into A10001_
      From A10001 t
     Where t.Column_Id = Column_Id_
       And t.Table_Id = Table_Id_;
    -- Add/modify columns alter table P101 add spec1 number;
    If A100_.Tbl_Type = 'T' Then
      Sql_ := 'alter  table ' || A100_.Table_Id || ' add ' ||
              A10001_.Column_Id;
      /*字符串*/
      If Lower(A10001_.Col_Type) = 'varchar' Or
         Lower(A10001_.Col_Type) = 'char' Then
        Sql_ := Sql_ || ' varchar2(' || A10001_.Col_Len || ')';
      End If;
    
      If Lower(A10001_.Col_Type) = 'text' Or
         Lower(A10001_.Col_Type) = 'text' Then
        Sql_ := Sql_ || ' long';
      End If;
    
      /*数值*/
      If Lower(A10001_.Col_Type) = 'int' Or
         Lower(A10001_.Col_Type) = 'numeric' Or
         Lower(A10001_.Col_Type) = 'decimal' Or
         Lower(A10001_.Col_Type) = 'number' Then
        Sql_ := Sql_ || ' number';
      End If;
    
      /*日期*/
      If Lower(A10001_.Col_Type) = 'date' Or
         Lower(A10001_.Col_Type) = 'datetime' Then
        Sql_ := Sql_ || ' date';
      End If;
    
      /*图片 存路径 在编辑方式中设置*/
    
      If Lower(A10001_.Col_Type) = 'image' Then
        Sql_ := Sql_ || ' varchar2(400)';
      End If;
    
      Execute Immediate Sql_;
    
    End If;
  
    /*执行把数据插入到库表 权限表 */
  
  End;

  Function Get_Selectdatasql(Table_Id_ In Varchar2,
                             If_Db     In Varchar2 Default '0')
    Return Varchar2 Is
    A10001_Cur t_Cursor;
    Sql_       Long;
  Begin
    Sql_ := 'Select ';
    If If_Db = '0' Then
      Select t.*
        Into A100_
        From A100 t
       Where t.Table_Id = Table_Id_
         And Rownum = 1;
      Open A10001_Cur For
        Select t.*
          From A10001 t
         Where t.Table_Id = A100_.Table_Id
         Order By Sort_By, Table_Id;
      Fetch A10001_Cur
        Into A10001_;
      Loop
        Exit When A10001_Cur%Notfound;
        Sql_ := Sql_ || 't.' || A10001_.Column_Id || ',' || Chr(10);
        Fetch A10001_Cur
          Into A10001_;
      End Loop;
      Close A10001_Cur;
      Sql_ := Substr(Sql_, 1, Length(Sql_) - 2) || Chr(10) || ' From  ' ||
              A100_.Table_Id || ' t where 1=1';
    Else
      Open A10001_Cur For
        Select t.Column_Name
          From User_Tab_Cols t
         Where t.Table_Name = Table_Id_
         Order By Column_Id;
      Fetch A10001_Cur
        Into A10001_.Column_Id;
      Loop
        Exit When A10001_Cur%Notfound;
        Sql_ := Sql_ || 't.' || A10001_.Column_Id || ',' || Chr(10);
        Fetch A10001_Cur
          Into A10001_.Column_Id;
      
      End Loop;
      Close A10001_Cur;
      Sql_ := Substr(Sql_, 1, Length(Sql_) - 2) || Chr(10) || ' From  ' ||
              A100_.Table_Id || ' t where 1=1';
    
    End If;
    -- Dbms_Output.Put_Line(Sql_);
    Return Sql_;
  End;

  /*检测用户对菜单的权限 有权限返回 1 无权限返回 0
    a002_key_ 菜单
    a007_key_ 用户
    a30001_key_ 登录信息
  */
  Function Getusermenu(Menu_Id_    In Varchar2,
                       User_Id_    In Varchar2,
                       A30001_Key_ In Number) Return Varchar2 Is
    Result Number;
  Begin
    Select Count(*)
      Into Result
      From A00701 t
     Inner Join A01301 T1
        On t.A013_Id = T1.A013_Id
       And T1.A002_Id = Menu_Id_
       And T1.Rb_Do = 'Use'
       And T1.Useable = '1'
     Where A007_Id = User_Id_
       And Rownum = 1;
    If Result > 0 Then
      Return '1';
    Else
      Return '0';
    End If;
  End;
  /* 获取表的主键*/
  Function Getkeylineno(A00201_Key_ In Varchar2, Key_Id In Varchar2)
    Return Varchar2 Is
    Sql_      Varchar2(2000);
    Table_Id_ Varchar2(2000);
    Cur_      t_Cursor;
    Num_      Number;
    Main_Key_ Varchar2(100);
  Begin
    Select t.Table_Id, t.Main_Key
      Into Table_Id_, Main_Key_
      From A00201_V01 t
     Where (A00201_Key = A00201_Key_)
       And Rownum = 1;
    Sql_ := 'Select max(line_no)  from ' || Table_Id_ || ' where ' ||
            Main_Key_ || '=''' || Key_Id || '''';
    Open Cur_ For Sql_;
    Fetch Cur_
      Into Num_;
    Close Cur_;
    Return To_Char(Nvl(Num_, 0) + 1);
  End;
  /*
  a002_ 菜单号
  或者表
  或者 a00201_key
  */
  Function Gettablekey(A002_ In Varchar2, Type_ In Varchar2 Default 'SAVE')
    Return Varchar2 Is
    --sql_ varchar2(2000);
    Table_Id_ Varchar2(2000);
    --cur_ t_cursor ;
    Num_      Varchar2(100);
    Tbl_Type_ Varchar2(100);
  Begin
  
    Select t.Table_Id, T1.Tbl_Type
      Into Table_Id_, Tbl_Type_
      From A002 t
     Inner Join A100 T1
        On t.Table_Id = T1.Table_Id
     Where (Menu_Id = A002_)
       And Rownum = 1;
    If Tbl_Type_ = 'V' Then
      Return Null;
    End If;
    Select f_Get_Max_Id(Table_Id_, Sysdate, Type_) Into Num_ From Dual;
    Return Num_;
  Exception
    When Others Then
      Return Null;
  End;

  Procedure Set_Item_Value(Name_  In Varchar2,
                           Value_ In Varchar2,
                           Attr_  In Out Varchar2) Is
    Index1_           Number;
    Index2_           Number;
    Record_Separator_ Varchar2(10);
    Field_Separator_  Varchar2(10);
  Begin
    Field_Separator_  := '|';
    Record_Separator_ := f_Get_Data_Index();
    Index1_           := Instr(Record_Separator_ || Attr_,
                               Record_Separator_ || Name_ ||
                               Field_Separator_);
    If (Index1_ > 0) Then
      Index2_ := Instr(Record_Separator_ || Attr_,
                       Record_Separator_,
                       Index1_ + 1,
                       1);
      If Index1_ = 1 Then
        Attr_ := Name_ || Field_Separator_ || Value_ || Record_Separator_ ||
                 Substr(Attr_, Index2_, Length(Attr_) - Index2_ + 1);
      Else
        Attr_ := Replace(Attr_,
                         Substr(Attr_, Index1_ - 1, Index2_ - Index1_),
                         Record_Separator_ || Name_ || Field_Separator_ ||
                         Value_);
      End If;
    Else
      Attr_ := Attr_ || Name_ || Field_Separator_ || Value_ ||
               Record_Separator_;
    End If;
  End Set_Item_Value;
  --获取2个字符串中间的数据
  Function Get_Item_Value_By_Index(Index1_ In Varchar2,
                                   Index2_ In Varchar2,
                                   Attr_   In Varchar2) Return Varchar2 Is
    Pos_ Number;
    v_   Varchar2(4000);
  Begin
    If (Attr_ Is Null) Then
      Return '';
    End If;
    If (Attr_ Is Null Or Attr_ = '') Then
      Return Null;
    End If;
  
    Pos_ := Instr(Attr_, Index1_);
    If Nvl(Pos_, 0) <= 0 Then
      Return Null;
    End If;
  
    v_ := Substr(Attr_, Pos_ + Length(Index1_));
    If (Nvl(Index2_, '') = '' Or Index2_ = '') Then
      Return v_;
    End If;
    Pos_ := Instr(v_, Index2_);
    If Nvl(Pos_, 0) <= 0 Then
      Return Null;
    End If;
    v_ := Substr(v_, 1, Pos_ - 1);
    Return v_;
  End;

  Function Get_Num_Value_By_Index(Index1_ In Varchar2,
                                  Index2_ In Varchar2,
                                  Attr_   In Varchar2) Return Number Is
    Result_ Number;
  Begin
    Result_ := Get_Item_Value_By_Index(Index1_, Index2_, Attr_);
    Return Result_;
  Exception
    When Others Then
      Return 0;
  End;

  --把ifs字符串转换为bm字符串
  --把ifs字符串转换为bm字符串
  Function Get_Attr_By_Ifs(Attr_ In Varchar2) Return Varchar2 Is
    Attr_Out_         Varchar2(4000);
    Index_            Varchar2(1);
    Index1_           Varchar2(1);
    i                 Number;
    v_                Varchar2(4000);
    Pos_              Number;
    Pos1_             Number;
    Data_             Varchar2(4000);
    Record_Separator_ Varchar2(1);
    Column_Id_        Varchar2(400);
  Begin
    If (Nvl(Attr_, '-') = '-' Or Attr_ = '') Then
      Return Attr_;
    End If;
    Data_             := Attr_;
    Index_            := Chr(30);
    Index1_           := Chr(31);
    Pos_              := Instr(Data_, Index_);
    Record_Separator_ := f_Get_Data_Index();
    Attr_Out_         := '';
    Loop
      Exit When i > 1000;
      Exit When Nvl(Pos_, 0) <= 0;
      v_         := Substr(Data_, 1, Pos_ - 1);
      Pos1_      := Instr(Data_, Index1_);
      Column_Id_ := Substr(v_, 1, Pos1_ - 1);
      v_         := Substr(v_, Pos1_ + 1);
      Attr_Out_  := Attr_Out_ || Column_Id_ || '|' || v_ ||
                    Record_Separator_;
      Data_      := Substr(Data_, Pos_ + 1);
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
    End Loop;
    Return Attr_Out_;
  End;
  --把ifs字符串转换为bm字符串
  Function Get_Attr_By_Bm(Attr_ In Varchar2) Return Varchar2 Is
    Attr_Out_         Varchar2(4000);
    Index_            Varchar2(1);
    Index1_           Varchar2(1);
    i                 Number;
    v_                Varchar2(4000);
    Pos_              Number;
    Pos1_             Number;
    Data_             Varchar2(4000);
    Record_Separator_ Varchar2(1);
    Column_Id_        Varchar2(400);
  
  Begin
    If (Nvl(Attr_, '-') = '-' Or Attr_ = '') Then
      Return Attr_;
    End If;
    Data_     := Attr_;
    Index_    := f_Get_Data_Index();
    Index1_   := '|';
    Pos_      := Instr(Data_, Index_);
    Attr_Out_ := '';
    Loop
      Exit When i > 1000;
      Exit When Nvl(Pos_, 0) <= 0;
      v_         := Substr(Data_, 1, Pos_ - 1);
      Pos1_      := Instr(Data_, Index1_);
      Column_Id_ := Substr(v_, 1, Pos1_ - 1);
      v_         := Substr(v_, Pos1_ + 1);
      Attr_Out_  := Attr_Out_ || Column_Id_ || Chr(31) || v_ || Chr(30);
      Data_      := Substr(Data_, Pos_ + 1);
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
    End Loop;
  
    Return Attr_Out_;
  End;
  Procedure Set_Column_Enable(Name_   In Varchar2,
                              Enable_ In Varchar2,
                              Attr_   In Out Varchar2) Is
    Enable_Attr Varchar2(4000);
  Begin
    --判断enable是否有    
    Enable_Attr := Get_Item_Value('1000' || Enable_, Attr_);
    If Nvl(Enable_Attr, '-') = '-' Then
      Enable_Attr := Name_ || ',';
    Else
      If Instr(',' || Enable_Attr, ',' || Name_ || ',') <= 0 Then
        Enable_Attr := Enable_Attr || Name_ || ',';
      End If;
    End If;
    Set_Item_Value('1000' || Enable_, Enable_Attr, Attr_);
  
  End;

  Function Get_Item_Value(Name_ In Varchar2, Attr_ In Varchar2)
    Return Varchar2 Is
    From_             Number;
    Len_              Number;
    To_               Number;
    Record_Separator_ Varchar2(10);
  Begin
  
    Len_              := Length(Name_);
    Record_Separator_ := f_Get_Data_Index();
    From_             := Instr(Record_Separator_ || Attr_,
                               Record_Separator_ || Name_ || '|');
    If (From_ > 0) Then
      To_ := Instr(Attr_, Record_Separator_, From_ + 1);
      If (To_ > 0) Then
        Return(Substr(Attr_, From_ + Len_ + 1, To_ - From_ - Len_ - 1));
      End If;
    End If;
    Return(Null);
  End;

  Function Item_Exist(Name_ In Varchar2, Attr_ In Varchar2) Return Boolean Is
    From_ Number;
    --  len_  NUMBER;
    --to_   NUMBER;
    Record_Separator_ Varchar2(10);
  Begin
    --len_ := length(name_);
    Record_Separator_ := f_Get_Data_Index();
    From_             := Instr(Record_Separator_ || Attr_,
                               Record_Separator_ || Name_ || '|');
    If (From_ > 0) Then
      Return True;
    Else
      Return False;
    End If;
  End;
  Function Get_Key_Value(Table_Id_ In Varchar2, Objid_ In Varchar2)
    Return Varchar2 Is
    A002_   A002%Rowtype;
    Cur_    t_Cursor;
    t_Type_ Varchar2(200);
    Sql_    Varchar2(2000);
    Result_ Varchar2(500);
  Begin
    Open Cur_ For
      Select t.* From A002 t Where t.Table_Id = Table_Id_;
    Fetch Cur_
      Into A002_;
    If Cur_%Notfound Then
      Close Cur_;
      Return Objid_;
    End If;
    Close Cur_;
    Select Object_Type
      Into t_Type_
      From User_Objects t
     Where t.Object_Name = Table_Id_
       And Rownum = 1;
    If t_Type_ = 'TABLE' Then
      Sql_ := 'Select ' || A002_.Mian_Key || ' from ' || Table_Id_ ||
              ' t where t.rowid =''' || Objid_ || '''';
    Else
      Sql_ := 'Select ' || A002_.Mian_Key || ' from ' || Table_Id_ ||
              ' t where t.objid =''' || Objid_ || '''';
    End If;
    Open Cur_ For Sql_;
    Fetch Cur_
      Into Result_;
    If Cur_%Notfound Then
      Close Cur_;
      Return Objid_;
    End If;
    Close Cur_;
    Return Result_;
  Exception
    When Others Then
      Return Objid_;
  End;
  --合并2个字符串
  Procedure Str_Add_Str(Old_Str In Out Varchar2, New_Str In Varchar2) Is
    Ptr_   Number;
    Name_  Varchar2(50);
    Value_ Varchar2(32767);
    Len_   Number;
  Begin
    Ptr_ := Null;
    While Get_Next_From_Attr(New_Str, Ptr_, Name_, Value_) Loop
      Len_ := Length(Name_) + 3 + Length(Value_);
      If (Len_ > 255) Then
        Set_Item_Value(Name_,
                       Substr(Value_, 1, 250 - Length(Name_)),
                       Old_Str);
      Else
        Set_Item_Value(Name_, Value_, Old_Str);
      End If;
    End Loop;
  End;

  Function Get_Next_From_Attr(Attr_  In Varchar2,
                              Ptr_   In Out Number,
                              Name_  In Out Varchar2,
                              Value_ In Out Varchar2) Return Boolean Is
    From_             Number;
    To_               Number;
    Index_            Number;
    Record_Separator_ Varchar2(10);
  Begin
    From_             := Nvl(Ptr_, 1);
    Record_Separator_ := f_Get_Data_Index();
    To_               := Instr(Attr_, Record_Separator_, From_);
    If (To_ > 0) Then
      Index_ := Instr(Attr_, '|', From_);
      Name_  := Substr(Attr_, From_, Index_ - From_);
      Value_ := Substr(Attr_, Index_ + 1, To_ - Index_ - 1);
      Ptr_   := To_ + 1;
      Return(True);
    Else
      Return(False);
    End If;
  End Get_Next_From_Attr;

  Procedure Get_Row_Str(Table_Id_ In Varchar2,
                        Wheresql_ In Varchar2,
                        Result_   Out Varchar2) Is
    Cur_       t_Cursor;
    A10001_    A10001%Rowtype;
    Data_      Dbms_Sql.Varchar2_Table;
    Column_    Dbms_Sql.Varchar2_Table;
    v_Cursor   Number;
    v_Stat     Number;
    v_Row      Number;
    v_Sql      Varchar2(4000);
    v_i        Number;
    i          Number;
    v_Data_    Varchar2(2000);
    Column_Id_ A10001.Column_Id%Type;
  Begin
    v_Sql := 'Select ';
    v_i   := 0;
    Open Cur_ For
      Select t.*
        From A10001 t
       Where t.Table_Id = Table_Id_
         And t.Bs_List = '1'
       Order By Col_x;
    Fetch Cur_
      Into A10001_;
    Loop
      Exit When Cur_%Notfound;
      v_Sql := v_Sql || A10001_.Column_Id || ',';
      v_i := v_i + 1;
      Column_(v_i) := A10001_.Column_Id;
      Data_(v_i) := '';
      Fetch Cur_
        Into A10001_;
    End Loop;
    Close Cur_;
    v_Sql    := Substr(v_Sql, 1, Length(v_Sql) - 1) || ' From  ' ||
                Table_Id_ || ' t WHERE 1=1 ' || Wheresql_;
    v_Cursor := Dbms_Sql.Open_Cursor; --打开游标；
    Dbms_Sql.Parse(v_Cursor, v_Sql, Dbms_Sql.Native); --解析动态SQL语句；
    i := 1;
    Loop
      Exit When i > v_i;
      Dbms_Sql.Define_Column(v_Cursor, i, v_Data_, 2000); --定义列 
      i := i + 1;
    End Loop;
  
    v_Stat := Dbms_Sql.Execute(v_Cursor); --执行动态SQL语句。 
    Loop
      Exit When Dbms_Sql.Fetch_Rows(v_Cursor) <= 0; --fetch_rows在结果集中移动游标，如果未抵达末尾，返回1。 
    
      i := 1;
      Loop
        Exit When i > v_i;
        Dbms_Sql.Column_Value(v_Cursor, i, v_Data_); --将当前行的查询结果写入上面定义的列中。 
        Pkg_a.Set_Item_Value(Column_(i), v_Data_, Result_);
        i := i + 1;
      End Loop;
    End Loop;
    Dbms_Sql.Close_Cursor(v_Cursor); --关闭游标。 
  
  End;

  ---开始流转
  Procedure Set_First(Table_Id_ In Varchar2,
                      Objid_    In Varchar2,
                      User_Id_  In Varchar2) Is
    A332_    A332%Rowtype;
    A33201_  A33201%Rowtype;
    Obj_Cur  t_Cursor;
    A014_Cur t_Cursor;
    A014_    A014%Rowtype;
  Begin
    --判断是否存在已有的起始流程--
    Open A014_Cur For
      Select t.*
        From A014 t
       Where t.Table_Id = Table_Id_
         And t.If_First = '1';
  
    Select s_A332_Base.Nextval Into A332_.Base_A332_Id From Dual;
    Fetch A014_Cur
      Into A014_;
    Loop
      Exit When A014_Cur%Notfound;
      A332_.A332_Id := Check_A331(Table_Id_, Objid_, A014_.A014_Id);
      If A332_.A332_Id = 0 Then
        Select s_A332.Nextval Into A332_.A332_Id From Dual;
        Insert Into A332
          (A332_Id, A331_Name)
          Select A332_.A332_Id, A332_.A332_Name From Dual;
        A332_.A332_Name      := Get_Key_Value(Table_Id_, Objid_);
        A332_.A331_Id        := A014_.A014_Id;
        A332_.A331_Name      := A014_.A014_Name;
        A332_.A33101_Line    := 0;
        A332_.Current_A33201 := 1;
        A332_.Key_Id         := Objid_;
        A332_.Enter_User     := User_Id_;
        A332_.Enter_Date     := Sysdate;
        A332_.Base_Key       := A332_.A332_Name || '-First';
        A332_.State          := '0'; ----默认流程还未关闭
        A332_.f_State        := '0'; --默认审批通过
        A332_.Table_Id       := A014_.Table_Id;
        A332_.A33101_Line    := 1;
        A332_.User_Count     := A014_.User_Count; --只要一个操作就允许通过--
        A332_.Do_Type        := 'A014';
        ---上一个流程--                
      
        /*获取执行的人员列表*/
        If Length(Nvl(A014_.User_Sql, '0')) < 5 Then
          A014_.User_Sql := 'Select ''' || User_Id_ ||
                            ''' as a007_id from dual';
        Else
          A014_.User_Sql := Replace(A014_.User_Sql, '[ROWID]', Objid_);
          A014_.User_Sql := Replace(A014_.User_Sql,
                                    '[TABLE_ID]',
                                    A014_.Table_Id);
          A014_.User_Sql := Replace(A014_.User_Sql, '[USER_ID]', User_Id_);
          A014_.User_Sql := Replace(A014_.User_Sql,
                                    '[A014_ID]',
                                    A014_.A014_Id);
        End If;
        Open Obj_Cur For A014_.User_Sql;
        Fetch Obj_Cur
          Into A33201_.A007_Id;
        Loop
          Exit When Obj_Cur%Notfound;
          A33201_.A332_Id := A332_.A332_Id;
          A33201_.Line_No := Nvl(A33201_.Line_No, 0) + 1;
          Insert Into A33201
            (A332_Id, Line_No)
            Select A33201_.A332_Id, A33201_.Line_No From Dual;
          Select s_A33201.Nextval Into A33201_.A33201_Key From Dual;
          A33201_.Sort_By     := A33201_.Line_No;
          A33201_.A331_Id     := A332_.A331_Id;
          A33201_.A33101_Line := A332_.A33101_Line;
          A33201_.Enter_User  := User_Id_;
          A33201_.Enter_Date  := Sysdate;
          A33201_.A330_Id     := Null;
          A33201_.A33001_Line := 1;
          A33201_.A007_Name   := A33201_.A007_Id;
          A33201_.User_Count  := 1;
          A33201_.State       := '0';
          A33201_.Email       := Get_Email(A33201_.A007_Id);
          A33201_.Url         := Get_Url(A332_.Table_Id,
                                         Objid_,
                                         A33201_.A007_Id,
                                         A33201_.A33201_Key);
          A33201_.Email_State := '0';
        
          Update A33201
             Set Row = A33201_
           Where A332_Id = A33201_.A332_Id
             And Line_No = A33201_.Line_No;
          Fetch Obj_Cur
            Into A33201_.A007_Id;
        End Loop;
        Close Obj_Cur;
      
      End If;
      Update A332 Set Row = A332_ Where A332_Id = A332_.A332_Id;
    
      Fetch A014_Cur
        Into A014_;
    End Loop;
    Close A014_Cur;
  End;

  ---插入第一个步骤到流程表中--
  Procedure Set_Next(Table_Id_ In Varchar2,
                     Main_Key_ In Varchar,
                     Key_      In Varchar2,
                     User_Id_  In Varchar2) Is
    A014_    A014%Rowtype;
    A014_Cur t_Cursor;
    i        Number;
    Objid_   Varchar2(200);
    Obj_Cur  t_Cursor;
    Rowidsql Varchar2(500);
    A332_    A332%Rowtype;
    A33201_  A33201%Rowtype;
    t_Type_  Varchar2(120);
  Begin
    --判断有没有流程操作--
    i := 0;
    Open A014_Cur For
      Select t.*
        From A014 t
       Where t.Table_Id = Table_Id_
         And t.If_First = '1';
  
    Select s_A332_Base.Nextval Into A332_.Base_A332_Id From Dual;
    Fetch A014_Cur
      Into A014_;
    Loop
      Exit When A014_Cur%Notfound;
      If i = 0 Then
        Select Object_Type
          Into t_Type_
          From User_Objects t
         Where t.Object_Name = A014_.Table_Id
           And Rownum = 1;
        If t_Type_ = 'TABLE' Then
          Rowidsql := 'Select rowidtochar(t.rowid) as objid from  ' ||
                      Table_Id_ || ' t where ' || Main_Key_ || '=''' || Key_ || '''';
        Else
          Rowidsql := 'Select  objid from  ' || Table_Id_ || ' t where ' ||
                      Main_Key_ || '=''' || Key_ || '''';
        
        End If;
        Open Obj_Cur For Rowidsql;
        Fetch Obj_Cur
          Into Objid_;
        Close Obj_Cur;
      End If;
      ----
      A332_.A332_Id := Check_A331(Table_Id_, Objid_, A014_.A014_Id);
      If A332_.A332_Id = 0 Then
        Select s_A332.Nextval Into A332_.A332_Id From Dual;
        Insert Into A332
          (A332_Id, A331_Name)
          Select A332_.A332_Id, A332_.A332_Name From Dual;
        A332_.A332_Name      := Key_;
        A332_.A331_Id        := A014_.A014_Id;
        A332_.A331_Name      := A014_.A014_Name;
        A332_.A33101_Line    := 0;
        A332_.Current_A33201 := 1;
        A332_.Key_Id         := Objid_;
        A332_.Enter_User     := User_Id_;
        A332_.Enter_Date     := Sysdate;
      
        A332_.State       := '0'; ----默认流程还未关闭
        A332_.f_State     := '0'; --默认审批通过
        A332_.Table_Id    := Table_Id_;
        A332_.A33101_Line := 1;
        A332_.User_Count  := A014_.User_Count; --只要一个操作就允许通过--
        A332_.Do_Type     := 'A014';
        A332_.Base_Key    := Objid_ || '-First';
        /*获取执行的人员列表*/
        If Length(Nvl(A014_.User_Sql, '0')) < 5 Then
          A014_.User_Sql := 'Select ''' || User_Id_ ||
                            ''' as a007_id from dual';
        Else
          A014_.User_Sql := Replace(A014_.User_Sql, '[ROWID]', Objid_);
          A014_.User_Sql := Replace(A014_.User_Sql,
                                    '[TABLE_ID]',
                                    A014_.Table_Id);
          A014_.User_Sql := Replace(A014_.User_Sql, '[USER_ID]', User_Id_);
          A014_.User_Sql := Replace(A014_.User_Sql,
                                    '[A014_ID]',
                                    A014_.A014_Id);
        End If;
        Open Obj_Cur For A014_.User_Sql;
        Fetch Obj_Cur
          Into A33201_.A007_Id;
        Loop
          Exit When Obj_Cur%Notfound;
          A33201_.A332_Id := A332_.A332_Id;
          A33201_.Line_No := Nvl(A33201_.Line_No, 0) + 1;
          Insert Into A33201
            (A332_Id, Line_No)
            Select A33201_.A332_Id, A33201_.Line_No From Dual;
          Select s_A33201.Nextval Into A33201_.A33201_Key From Dual;
          A33201_.Sort_By     := A33201_.Line_No;
          A33201_.A331_Id     := A332_.A331_Id;
          A33201_.A33101_Line := A332_.A33101_Line;
          A33201_.Enter_User  := User_Id_;
          A33201_.Enter_Date  := Sysdate;
          A33201_.A330_Id     := Null;
          A33201_.A33001_Line := 1;
          A33201_.A007_Name   := A33201_.A007_Id;
          A33201_.User_Count  := 1;
          A33201_.State       := '0';
          A33201_.Email       := Get_Email(A33201_.A007_Id);
          A33201_.Url         := Get_Url(A332_.Table_Id,
                                         Key_,
                                         A33201_.A007_Id,
                                         A33201_.A33201_Key);
          A33201_.Email_State := '0';
        
          Update A33201
             Set Row = A33201_
           Where A332_Id = A33201_.A332_Id
             And Line_No = A33201_.Line_No;
          Fetch Obj_Cur
            Into A33201_.A007_Id;
        End Loop;
        Close Obj_Cur;
      End If;
      Update A332 Set Row = A332_ Where A332_Id = A332_.A332_Id;
    
      Fetch A014_Cur
        Into A014_;
    End Loop;
    Close A014_Cur;
  End;

  Procedure Update_A009(Table_Id_ In Varchar2,
                        Key_      In Varchar2,
                        Main_Key_ In Varchar,
                        User_Id_  In Varchar2) Is
    A009_   A009%Rowtype;
    Count_  Number;
    l_Left  Varchar2(100);
    Ll_Left Varchar2(100);
    p_Len   Number;
  
  Begin
    Set_Next(Table_Id_, Main_Key_, Key_, User_Id_);
  
    Select Count(*) Into Count_ From A009 t Where t.A009_Id = Table_Id_;
    If Count_ = 0 Then
      Return;
    End If;
  
    Select t.* Into A009_ From A009 t Where t.A009_Id = Table_Id_;
  
    If Length(Key_) <> Length(A009_.Max_Id) Then
      Update A009
         Set Max_Value = 1, Max_Id = Key_, Modi_Date = Sysdate
       Where A009_Id = Table_Id_;
    Else
    
      p_Len := Length(A009_.Max_Id) - A009_.Seq;
      If Nvl(A009_.Suffix, '-') <> '-' Then
        p_Len := p_Len - Length(A009_.Suffix);
      End If;
    
      l_Left := Substr(A009_.Max_Id, 1, p_Len);
    
      Ll_Left := Substr(Key_, 1, p_Len);
      If l_Left = Ll_Left Then
        Update A009
           Set Max_Value = Max_Value + 1,
               Max_Id    = Key_,
               Modi_Date = Sysdate
         Where A009_Id = Table_Id_;
      Else
        Update A009
           Set Max_Value = 1, Max_Id = Key_, Modi_Date = Sysdate
         Where A009_Id = Table_Id_;
      End If;
    End If;
  
  End;

  /*单据状态改变的的存储过程*/
  Procedure Change_Bill_Status(Table_Id_ In Varchar2,
                               Key_      In Varchar2,
                               Rb_Do_    In Varchar,
                               User_Id_  Varchar2,
                               Main_Key_ In Varchar2,
                               Rb_Sql_   In Varchar2 Default '',
                               A311_Key_ In Number Default 0) Is
    Sql_    Varchar2(1000);
    Status_ Varchar2(100);
  Begin
    /*获取当前的单据有没有前序 或者后续单据*/
    -- RAISE_APPLICATION_ERROR(-20001,  '金额超限.'); 
  
    --   view_sequence
    -- return ;
  
    Select t.Status
      Into Status_
      From A014 t
     Where t.A014_Id = Rb_Do_
       And Rownum = 1;
    Sql_ := 'update  ' || Table_Id_ || ' set status = ''' || Status_ ||
            ''' where  ' || Main_Key_ || '=''' || Key_ || '''';
  
    Execute Immediate Sql_;
    Sql_ := 'update  ' || Table_Id_ || '01 set state = ''' || Status_ ||
            ''' where  ' || Main_Key_ || '=''' || Key_ || '''';
  
    Execute Immediate Sql_;
  
    If Length(Nvl(Rb_Sql_, '0')) > 5 Then
      Sql_ := Replace(Rb_Sql_, '"', '''');
      Execute Immediate Sql_;
    End If;
  
    /* update A311
       set state ='1',
         res = '00不能更新'
     where a311_key =  A311_KEY_;
     return;
    */
    Update A311
       Set State     = '1',
           Res       = '01',
           Modi_Date = Sysdate,
           Modi_User = User_Id_
     Where A311_Key = A311_Key_;
    Return;
  End;
  Procedure Insert_A10001(Table_Id_ In Varchar2,
                          A311_Key_ In Number Default 0) Is
  Begin
    Insert_A10001_From_Sys(Table_Id_);
    Update A311
       Set State = '1', Res = '01插入表属性成功'
     Where A311_Key = A311_Key_;
  End;

  Procedure Insert_A10001_(Rowid_    In Varchar2,
                           User_Id_  Varchar,
                           A311_Key_ In Number) Is
    A100_  A100%Rowtype;
    Count_ Number;
  Begin
    Select Count(*)
      Into Count_
      From A100 t
     Where Rowidtochar(t.Rowid) = Rowid_;
    If Count_ > 0 Then
    
      Select t.*
        Into A100_
        From A100 t
       Where Rowidtochar(t.Rowid) = Rowid_;
      Insert_A10001(A100_.Table_Id, A311_Key_);
    Else
      A100_.Table_Id := Get_Item_Value('OBJID', Rowid_);
      Insert_A10001(A100_.Table_Id, A311_Key_);
    End If;
  
  End;
  Procedure Insert_A10001_From_Sys(Table_Id_ In Varchar2) Is
    User_Objects_     User_Objects%Rowtype;
    Count_            Number;
    User_Tab_Columns_ User_Tab_Columns%Rowtype;
    Col_Cursor        t_Cursor;
    Base_Row          A10001%Rowtype;
    Insert_Row        A10001%Rowtype;
  
  Begin
    Select t.*
      Into User_Objects_
      From User_Objects t
     Where Object_Name = Table_Id_;
    /*把数据插入到A100中*/
    Select Count(*) Into Count_ From A100 t Where t.Table_Id = Table_Id_;
    If Count_ = 0 Then
      Insert Into A100
        (Table_Id,
         Table_Name,
         Tbl_Id,
         Tbl_Type,
         Enter_User,
         Enter_Date,
         User_Flag,
         Bs_Cols)
        Select User_Objects_.Object_Name,
               User_Objects_.Object_Name,
               '0',
               Case User_Objects_.Object_Type
                 When 'TABLE' Then
                  'T'
                 Else
                  'V'
               End,
               'System',
               Sysdate,
               '0',
               5
          From Dual;
    Else
      Update A100
         Set Tbl_Type =
             (Case User_Objects_.Object_Type
               When 'TABLE' Then
                'T'
               Else
                'V'
             End)
       Where Table_Id = Table_Id_;
    
    End If;
  
    Select t.*
      Into Base_Row
      From A10001 t
     Where t.Table_Id = 'A100'
       And t.Column_Id = 'TABLE_NAME';
    Base_Row.Bs_Width      := '120';
    Base_Row.Bs_Edit_Width := '110';
    Base_Row.Bs_Cols       := 1;
  
    --删除A10001中多余的列--
    Delete From A10001
     Where Table_Id = Table_Id_
       And Column_Id Not In
           (Select t.Column_Name
              From User_Tab_Columns t
             Where t.Table_Name = Table_Id_);
    Select Max(Line_No)
      Into Base_Row.Line_No
      From A10001 t
     Where t.Table_Id = Table_Id_;
  
    Open Col_Cursor For
      Select t.*
        From User_Tab_Columns t
       Where t.Table_Name = Table_Id_
         And t.Column_Name Not In
             (Select Column_Id From A10001 a Where a.Table_Id = Table_Id_)
       Order By t.Column_Id;
    Fetch Col_Cursor
      Into User_Tab_Columns_;
    Loop
      Exit When Col_Cursor%Notfound;
      /*判断A10001中有没有系统表中的数据*/
      If User_Tab_Columns_.Column_Name <> 'OBJID' And
         User_Tab_Columns_.Column_Name <> 'OBJVERSION' Then
        Insert_Row               := Base_Row;
        Insert_Row.Line_No       := Nvl(Base_Row.Line_No, 0) + 1;
        Insert_Row.Col_Text      := User_Tab_Columns_.Column_Name;
        Insert_Row.Col_x         := Insert_Row.Line_No;
        Insert_Row.Text_Original := User_Tab_Columns_.Column_Name;
        Base_Row.Line_No         := Insert_Row.Line_No;
        Insert_Row.Table_Id      := User_Tab_Columns_.Table_Name;
        Insert_Row.Column_Id     := User_Tab_Columns_.Column_Name;
        Insert_Row.Bs_Html       := '[' || Insert_Row.Column_Id || ']';
        Insert_Row.Enter_Date    := Sysdate;
        Insert_Row.Modi_Date     := Insert_Row.Enter_Date;
        Select Case Upper(User_Tab_Columns_.Data_Type)
                 When 'LONG' Then
                  'varchar'
                 When 'NVARCHAR2' Then
                  'varchar'
                 When 'VARCHAR2' Then
                  'varchar'
                 When 'FLOAT' Then
                  'int'
                 When 'NUMBER' Then
                  'int'
                 When 'CHAR' Then
                  'varchar'
                 When 'CLOB' Then
                  'varchar'
                 When 'DATE' Then
                  'datetime'
                 Else
                  'varchar'
               End
          Into Insert_Row.Col_Type
          From Dual;
        Select Case Upper(User_Tab_Columns_.Data_Type)
                 When 'LONG' Then
                  'u_edit'
                 When 'NVARCHAR2' Then
                  'u_edit'
                 When 'VARCHAR2' Then
                  'u_edit'
                 When 'FLOAT' Then
                  'u_edit'
                 When 'NUMBER' Then
                  'u_number'
                 When 'CHAR' Then
                  'u_edit'
                 When 'CLOB' Then
                  'u_edit'
                 When 'DATE' Then
                  'datelist'
                 Else
                  'u_edit'
               End
          Into Insert_Row.Col_Edit
          From Dual;
      
        Insert Into A10001
          (Table_Id, Column_Id, Line_No)
          Select Insert_Row.Table_Id,
                 Insert_Row.Column_Id,
                 Insert_Row.Line_No
            From Dual;
      
        Insert_Row.Enter_Date := Sysdate;
        Insert_Row.Enter_User := 'System';
        Insert_Row.Col_Type   := Lower(User_Tab_Columns_.Data_Type);
        Insert_Row.Col_Len    := User_Tab_Columns_.Data_Length;
        Update A10001
           Set Row = Insert_Row
         Where Table_Id = Insert_Row.Table_Id
           And Column_Id = Insert_Row.Column_Id;
      
      End If;
      Fetch Col_Cursor
        Into User_Tab_Columns_;
    End Loop;
  
    Close Col_Cursor;
  
  End;

  /*新建菜单以后把菜单的数据 插入到角色表中 */
  Procedure After_Insert_A002(Menu_Id_ In Varchar2, User_Id_ In Varchar2) Is
    A013_Cur    t_Cursor;
    A00201_Cur  t_Cursor;
    A00201_     A00201_V01%Rowtype;
    A002_       A002%Rowtype;
    A013_       A013%Rowtype;
    A01301_     A01301%Rowtype;
    A00204_     A00204_V01%Rowtype;
    A00204_Cur  t_Cursor;
    A10001_Cur  t_Cursor;
    A10001_     A10001%Rowtype;
    A0130101_   A0130101%Rowtype;
    A013010101_ A013010101%Rowtype;
    b_Line_     Number;
    e_Line_     Number;
  Begin
    Select t.* Into A002_ From A002 t Where t.Menu_Id = Menu_Id_;
    Open A013_Cur For
      Select t.* From A013 t;
    Fetch A013_Cur
      Into A013_;
    Loop
      Exit When A013_Cur%Notfound;
    
      Delete From A01301 t
       Where t.A013_Id = A013_.A013_Id
         And t.A002_Id = A002_.Menu_Id
         And t.Rb_Do Not In
             (Select Rb_Do From A00204_V01 t Where t.Menu_Id = Menu_Id_);
    
      --循环功能键--
      Open A00204_Cur For
        Select t.*
          From A00204_V01 t
         Where t.Menu_Id = Menu_Id_
         Order By t.Line_No;
    
      Fetch A00204_Cur
        Into A00204_;
      Loop
        Exit When A00204_Cur%Notfound;
        Select Count(*)
          Into Count_
          From A01301 t
         Where t.A013_Id = A013_.A013_Id
           And t.A002_Id = A002_.Menu_Id
           And t.Rb_Do = A00204_.Rb_Do
           And Rownum = 1;
        A01301_.A013_Id   := A013_.A013_Id;
        A01301_.A002_Id   := A002_.Menu_Id;
        A01301_.A002_Name := A002_.Menu_Name;
        A01301_.Rb_Do     := A00204_.Rb_Do;
        A01301_.Rb_Name   := A00204_.Rb_Name;
        If Count_ = 0 Then
          Select s_A01301.Nextval Into A01301_.Line_No From Dual;
          A01301_.Enter_User := User_Id_;
          A01301_.Enter_Date := Sysdate;
          A01301_.Useable    := '0';
          A01301_.Sort_By    := A01301_.Line_No;
          If A013_.Default_Flag = '1' Then
            A01301_.Useable   := '1';
            A01301_.User_Flag := '1';
          End If;
          Insert Into A01301
            (A013_Id, Line_No, A002_Id, Rb_Do, Enter_User, Enter_Date)
            Select A01301_.A013_Id,
                   A01301_.Line_No,
                   A01301_.A002_Id,
                   A01301_.Rb_Do,
                   User_Id_,
                   Sysdate
              From Dual;
          Update A01301
             Set Row = A01301_
           Where A013_Id = A01301_.A013_Id
             And A002_Id = A01301_.A002_Id
             And Rb_Do = A01301_.Rb_Do;
        Else
          Update A01301
             Set Rb_Name = A00204_.Rb_Name, A002_Name = A002_.Menu_Name
           Where A013_Id = A01301_.A013_Id
             And A002_Id = A01301_.A002_Id
             And Rb_Do = A01301_.Rb_Do;
        End If;
        Fetch A00204_Cur
          Into A00204_;
      End Loop;
      Close A00204_Cur;
      --END 循环功能键--  
      --如果不是标准的功能键 不执行任何处理-- 
      If Instr(Lower(A002_.Bs_Url), Lower('ShowForm/QueryData.aspx')) > 0 Then
        --插入菜单--
        Select t.*
          Into A01301_
          From A01301 t
         Where A013_Id = A01301_.A013_Id
           And A002_Id = A01301_.A002_Id
           And Rb_Do = 'Use'
           And Rownum = 1;
        Delete From A0130101 t
         Where t.A013_Id = A013_.A013_Id
           And t.A002_Id = A01301_.A002_Id
              --   and   t.mon_line = a01301_.line_no
           And t.A00201_Line Not In (Select Line_No
                                       From A00201
                                      Where Menu_Id = Menu_Id_
                                     Union
                                     Select 0
                                       From Dual);
        --循环功能键--
        Open A00201_Cur For
          Select t.*
            From A00201_V01 t
           Where t.Menu_Id = Menu_Id_
           Order By t.Line_No;
      
        Fetch A00201_Cur
          Into A00201_;
        Loop
          Exit When A00201_Cur%Notfound;
          Select Count(*)
            Into Count_
            From A0130101 t
           Where t.A013_Id = A013_.A013_Id
             And t.A002_Id = A002_.Menu_Id
             And t.A00201_Line = A00201_.Line_No
             And Rownum = 1;
          A0130101_.A013_Id      := A01301_.A013_Id;
          A0130101_.Mon_Line     := A01301_.Line_No;
          A0130101_.A002_Id      := A01301_.A002_Id;
          A0130101_.A00201_Line  := A00201_.Line_No;
          A0130101_.Control_Id   := A00201_.Control_Id;
          A0130101_.Control_Name := A00201_.Tab_Original;
          If Count_ = 0 Then
            Select s_A0130101.Nextval Into A0130101_.Line_No From Dual;
          
            A0130101_.Enter_User := User_Id_;
            A0130101_.Enter_Date := Sysdate;
            A0130101_.Useable    := '0';
            A0130101_.Mod_Row    := '0';
            A0130101_.Add_Row    := '0';
            A0130101_.Del_Row    := '0';
            If A013_.Default_Flag = '1' Then
              A0130101_.Useable := '1';
              A0130101_.Mod_Row := '1';
              A0130101_.Add_Row := '1';
              A0130101_.Del_Row := '1';
            End If;
            Insert Into A0130101
              (A013_Id, Mon_Line, Line_No, A00201_Line, A002_Id)
              Select A0130101_.A013_Id,
                     A0130101_.Mon_Line,
                     A0130101_.Line_No,
                     A0130101_.A00201_Line,
                     A0130101_.A002_Id
                From Dual;
          
            Update A0130101 t
               Set Row = A0130101_
             Where t.A013_Id = A013_.A013_Id
               And t.A002_Id = A002_.Menu_Id
               And t.A00201_Line = A00201_.Line_No;
          Else
          
            Update A0130101 t
               Set t.Control_Name = A0130101_.Control_Name,
                   t.Control_Id   = A0130101_.Control_Id
             Where t.A013_Id = A013_.A013_Id
               And t.A002_Id = A002_.Menu_Id
               And t.A00201_Line = A00201_.Line_No;
          
            Select t.*
              Into A0130101_
              From A0130101 t
             Where t.A013_Id = A013_.A013_Id
               And t.A002_Id = A002_.Menu_Id
               And t.A00201_Line = A00201_.Line_No
               And Rownum = 1;
          
          End If;
        
          ---把表的数据插入到表A013010101中
          A013010101_.A013_Id     := A0130101_.A013_Id;
          A013010101_.Mon_Line    := A0130101_.Mon_Line;
          A013010101_.Mon_Line1   := A0130101_.Line_No;
          A013010101_.A002_Id     := A0130101_.A002_Id;
          A013010101_.Control_Id  := A0130101_.Control_Id;
          A013010101_.Col_Width   := A10001_.Col_Width;
          A013010101_.A00201_Line := A0130101_.A00201_Line;
          A013010101_.Table_Id    := A00201_.Table_Id;
        
          Delete From A013010101 t
           Where t.A013_Id = A013010101_.A013_Id
             And t.A002_Id = A013010101_.A002_Id
             And t.Control_Id Not In (Select Control_Id
                                        From A00201 t
                                       Where t.Menu_Id = Menu_Id_
                                      Union
                                      Select 'dw_main'
                                        From Dual);
        
          Delete From A013010101 t
           Where t.A013_Id = A013010101_.A013_Id
             And t.A002_Id = A013010101_.A002_Id
             And t.Control_Id = A013010101_.Control_Id
             And t.Column_Id Not In
                 (Select Column_Id
                    From A10001 T1
                   Where T1.Table_Id = A00201_.Table_Id);
          Open A10001_Cur For
            Select t.* From A10001 t Where t.Table_Id = A00201_.Table_Id;
          Fetch A10001_Cur
            Into A10001_;
          Loop
            --A013_ID, A002_ID, CONTROL_ID, COLUMN_ID
            Exit When A10001_Cur%Notfound;
            Select Count(*)
              Into Count_
              From A013010101 t
             Where t.A013_Id = A013010101_.A013_Id
               And t.A002_Id = A013010101_.A002_Id
               And t.Control_Id = A013010101_.Control_Id
               And t.Column_Id = A10001_.Column_Id;
            A013010101_.Column_Id     := A10001_.Column_Id;
            A013010101_.Col_Text      := A10001_.Col_Text;
            A013010101_.Col_Width     := A10001_.Col_Width;
            A013010101_.Col_Visible   := '1';
            A013010101_.Col_Enable    := '1';
            A013010101_.Col_Necessary := '0';
            A013010101_.Col_x         := A10001_.Col_x;
            If Count_ = 0 Then
              A013010101_.Enter_Date := Sysdate;
              A013010101_.Enter_User := User_Id_;
              Select s_A013010101.Nextval
                Into A013010101_.Line_No
                From Dual;
              If A013010101_.A013_Id = 'R000014' Then
                Insert Into A016
                  (A016_Id,
                   A002_Id,
                   Control_Id,
                   Column_Id,
                   Table_Id,
                   Col_Text,
                   Col_x,
                   Col_Width,
                   Col_Visible,
                   Col_Enable,
                   Col_Necessary,
                   Col_Rela,
                   Col_Value,
                   Enter_User,
                   Enter_Date,
                   Modi_User,
                   Modi_Date,
                   Data_Lock,
                   Lock_User,
                   Sort_By,
                   A00201_Line)
                  Select Distinct a.A016_Id As A016_Id,
                                  A013010101_.A002_Id,
                                  A013010101_.Control_Id,
                                  A013010101_.Column_Id,
                                  A013010101_.Table_Id,
                                  A013010101_.Col_Text,
                                  A013010101_.Col_x,
                                  A013010101_.Col_Width,
                                  A013010101_.Col_Visible,
                                  A013010101_.Col_Enable,
                                  A013010101_.Col_Necessary,
                                  A013010101_.Col_Rela,
                                  A013010101_.Col_Value,
                                  A013010101_.Enter_User,
                                  A013010101_.Enter_Date,
                                  A013010101_.Modi_User,
                                  A013010101_.Modi_Date,
                                  A013010101_.Data_Lock,
                                  A013010101_.Lock_User,
                                  A013010101_.Sort_By,
                                  A013010101_.A00201_Line
                    From (Select Distinct A016_Id
                            From A016 T1
                           Where T1.A002_Id = Menu_Id_
                          Union
                          Select 'ADMIN'
                            From Dual) a;
              
              End If;
              Insert Into A013010101
                (A013_Id,
                 Mon_Line,
                 Mon_Line1,
                 Line_No,
                 A00201_Line,
                 A002_Id,
                 Control_Id,
                 Enter_Date,
                 Enter_User,
                 Column_Id,
                 Col_Text,
                 Col_Visible,
                 Col_Enable,
                 Col_Necessary)
                Select A013010101_.A013_Id,
                       A013010101_.Mon_Line,
                       A013010101_.Mon_Line1,
                       A013010101_.Line_No,
                       A013010101_.A00201_Line,
                       A013010101_.A002_Id,
                       A013010101_.Control_Id,
                       Sysdate,
                       User_Id_,
                       A10001_.Column_Id,
                       A10001_.Col_Text,
                       '1',
                       '1',
                       '0'
                  From Dual;
            Else
              Update A013010101 t
                 Set Col_Text = A10001_.Col_Text
               Where t.A013_Id = A013010101_.A013_Id
                 And t.A002_Id = A013010101_.A002_Id
                 And t.Control_Id = A013010101_.Control_Id
                 And t.Column_Id = A10001_.Column_Id;
            End If;
          
            Fetch A10001_Cur
              Into A10001_;
          End Loop;
          Close A10001_Cur;
        
          Fetch A00201_Cur
            Into A00201_;
        End Loop;
      End If;
      Fetch A013_Cur
        Into A013_;
    End Loop;
    Close A013_Cur;
    --删除多余的列
    Delete From A016 a
     Where a.A002_Id = Menu_Id_
       And Not Exists (Select 1
              From A013010101 t
             Where t.A013_Id = 'R000014'
               And t.A002_Id = a.A002_Id
               And t.Control_Id = a.Control_Id
               And t.Column_Id = a.Column_Id);
    --插入新加的列
  
    --插入是SQL的数据--    
    -- select t2.col_visible, t1.table_id,t1.column_id,t1.col_text,t.*
    --from A00201_v01 t 
    --inner join a10001 t1 on t.table_id = t1.table_id 
    --left outer join a016 t2 on t2.a002_id = t.menu_id and t2.table_id = t.table_id and   t2.column_id = t1.column_id  --and t2.control_id = t.control_id
    --where t.menu_id ='2417'        
    Pkg_Show.Pgeta013010101(Menu_Id_ || '-0', User_Id_);
    Proc_Bs_Job(Menu_Id_);
    Return;
  End;
  Procedure Save_A016(Rowlist_  In Varchar2,
                      User_Id_  In Varchar2,
                      A311_Key_ In Number) Is
    Objid_ Varchar2(100);
    A016_  A016%Rowtype;
    Cur_   t_Cursor;
  Begin
    Objid_ := Get_Item_Value('OBJID', Rowlist_);
    Open Cur_ For
      Select t.* From A016 t Where t.Rowid = Objid_;
    Fetch Cur_
      Into A016_;
    If Cur_%Notfound Then
      Close Cur_;
      Setfailed(A311_Key_, 'A016', Objid_);
      Setmsg(A311_Key_, 'S0013', '', Objid_);
      Return;
    End If;
    Close Cur_;
    If Item_Exist('COL_X', Rowlist_) Then
      A016_.Col_x := Get_Item_Value('COL_X', Rowlist_);
    End If;
    If Item_Exist('COL_VISIBLE', Rowlist_) Then
      A016_.Col_Visible := Get_Item_Value('COL_VISIBLE', Rowlist_);
    End If;
    If Item_Exist('COL_ENABLE', Rowlist_) Then
      A016_.Col_Enable := Get_Item_Value('COL_ENABLE', Rowlist_);
    End If;
    If Item_Exist('COL_NECESSARY', Rowlist_) Then
      A016_.Col_Necessary := Get_Item_Value('COL_NECESSARY', Rowlist_);
    End If;
    If Item_Exist('COL_WIDTH', Rowlist_) Then
      A016_.Col_Width := Get_Item_Value('COL_WIDTH', Rowlist_);
    End If;
  
    Update A016 Set Row = A016_ Where Rowid = Objid_;
  
    Setsuccess(A311_Key_, 'A016', Objid_);
    Setmsg(A311_Key_, 'S0003', '', Objid_);
    Return;
  End;

  Procedure Save_A10001(A00201_Key_ In Varchar2,
                        Width_      In Varchar2,
                        x_          In Varchar2,
                        User_Id_    In Varchar2 Default 'ADMIN') Is
    A00201_    A00201_V01%Rowtype;
    Str_Width_ Varchar2(4000);
    Col_Width_ Varchar2(4000);
    Col_x_     Varchar2(40);
    Column_Id_ Varchar2(140);
    Pos_       Number;
    Pos1_      Number;
    Xpos_      Number;
    Xpos1_     Number;
    Str_x_     Varchar2(4000);
    A10001_    A10001%Rowtype;
    i          Number;
    Str_Xx     Varchar2(4000);
  Begin
    Select t.*
      Into A00201_
      From A00201_V01 t
     Where t.A00201_Key = A00201_Key_
       And Rownum = 1;
    Str_Width_ := Width_;
    Pos_       := Instr(Str_Width_, '=');
    Pos1_      := Instr(Str_Width_, '|');
    i          := 0;
    Str_x_     := '|' || x_;
    Loop
      Exit When(Nvl(Pos_, 0) <= 0 Or Nvl(Pos1_, 0) <= 0 Or Pos_ > Pos1_ Or
                i > 400);
      Col_Width_ := Substr(Str_Width_, Pos_ + 1, Pos1_ - Pos_ - 1);
      Column_Id_ := Substr(Str_Width_, 1, Pos_ - 1);
      ---获取col_x的值
    
      Xpos_  := Instr(Str_x_, '|' || Column_Id_ || '=');
      Col_x_ := '999999';
      If Xpos_ > 0 Then
        Str_Xx := Substr(Str_x_, Xpos_ + Length('|' || Column_Id_ || '='));
        Xpos1_ := Instr(Str_Xx, '|');
        If Xpos_ > 0 Then
          Col_x_ := Substr(Str_Xx, 1, Xpos1_ - 1);
        End If;
      End If;
      Str_Width_ := Substr(Str_Width_, Pos1_ + 1);
      Select t.*
        Into A10001_
        From A10001 t
       Where t.Table_Id = A00201_.Table_Id
         And t.Column_Id = Column_Id_;
    
      A10001_.Bs_Edit_Width := Col_Width_ -
                               (A10001_.Bs_Width - A10001_.Bs_Edit_Width);
      A10001_.Bs_Width      := Col_Width_;
    
      Update A10001
         Set Bs_Edit_Width = A10001_.Bs_Edit_Width,
             Bs_Width      = A10001_.Bs_Width,
             Col_x         = Col_x_
       Where Table_Id = A00201_.Table_Id
         And Column_Id = Column_Id_;
      Pos_  := Nvl(Instr(Str_Width_, '='), 0);
      Pos1_ := Nvl(Instr(Str_Width_, '|'), 0);
      i     := i + 1;
    End Loop;
  
  End;
  /*修改位置*/
  Procedure Changecolumnx(Table_Id_  In Varchar2,
                          Column_Id_ In Varchar2,
                          Type_      In Varchar2) Is
    A10001_    A10001%Rowtype;
    A10001_Cur t_Cursor;
  Begin
    Open A10001_Cur For
      Select t.* From A10001 t Where t.Table_Id = Table_Id_;
    Fetch A10001_Cur
      Into A10001_;
    Loop
      Exit When A10001_Cur%Notfound;
      Fetch A10001_Cur
        Into A10001_;
    End Loop;
  
    Close A10001_Cur;
  
    Return;
  End;

  Procedure Add_A331(A331_Id_  In Varchar2,
                     User_Id_  In Varchar2,
                     Key_      In Varchar2,
                     A311_Key_ In Number) Is
    A331_      A331%Rowtype;
    A330_      A330%Rowtype;
    A33001_    A33001%Rowtype;
    A332_      A332%Rowtype;
    A33101_    A33101%Rowtype;
    A33101_Cur t_Cursor;
    A33001_Cur t_Cursor;
    --count_ number ;
    Check_  Varchar2(100);
    Msg_    Varchar2(200);
    A33201_ A33201%Rowtype;
  Begin
    Select t.*
      Into A331_
      From A331 t
     Where t.A331_Id = A331_Id_
       And Rownum = 1;
    Check_ := Check_A331(A331_.Table_Id, Key_, A331_.A331_Id);
    If Check_ <> '0' Then
      --获取应该报的错误信息-- 
      Select Pkg_Msg.Getmsgbymsgid('S0001', Check_) Into Msg_ From Dual;
      Update A311
         Set State     = '1',
             Res       = Msg_,
             Modi_Date = Sysdate,
             Modi_User = User_Id_
       Where A311_Key = A311_Key_;
      Return;
    End If;
    /*插入记录*/
    Select s_A332.Nextval Into A332_.A332_Id From Dual;
    Insert Into A332
      (A332_Id, A331_Name)
      Select A332_.A332_Id, A332_.A332_Name From Dual;
  
    A332_.A332_Name   := Key_;
    A332_.A331_Id     := A331_.A331_Id;
    A332_.A331_Name   := A331_.A331_Name;
    A332_.A33101_Line := 0;
    A332_.Key_Id      := Key_;
    A332_.Enter_User  := User_Id_;
    A332_.Enter_Date  := Sysdate;
    A332_.State       := '0'; ----默认流程还未关闭
    A332_.f_State     := '0'; --默认审批通过
    A332_.Table_Id    := A331_.Table_Id;
    A332_.Do_Type     := 'A330';
    --把需要审批的人 插入到审批记录表中--
    Open A33101_Cur For
      Select t.*
        From A33101 t
       Where t.A331_Id = A331_.A331_Id
       Order By Line_No;
    Fetch A33101_Cur
      Into A33101_;
    Loop
      Exit When A33101_Cur%Notfound;
      --当前步骤 --  
    
      A332_.A33101_Line := Nvl(A332_.A33101_Line, A33101_.Line_No);
    
      ----步骤----
      Select t.* Into A330_ From A330 t Where t.A330_Id = A33101_.A330_Id;
    
      If A332_.A33101_Line = 0 Then
        A332_.A33101_Line := A33101_.Line_No;
        A332_.User_Count  := A330_.User_Count;
      End If;
      Open A33001_Cur For
        Select t.* From A33001 t Where t.A330_Id = A330_.A330_Id;
      Fetch A33001_Cur
        Into A33001_;
      Loop
        Exit When A33001_Cur%Notfound;
        A33201_.A332_Id := A332_.A332_Id;
        A33201_.Line_No := Nvl(A33201_.Line_No, 0) + 1;
        Insert Into A33201
          (A332_Id, Line_No)
          Select A33201_.A332_Id, A33201_.Line_No From Dual;
      
        A33201_.Sort_By := A33201_.Line_No;
        A33201_.A331_Id := A331_.A331_Id;
        Select s_A33201.Nextval Into A33201_.A33201_Key From Dual;
        A33201_.A33101_Line := A33101_.Line_No;
        A33201_.Enter_User  := User_Id_;
        A33201_.Enter_Date  := Sysdate;
        A33201_.A330_Id     := A330_.A330_Id;
        A33201_.A33001_Line := A33001_.Line_No;
        A33201_.A007_Id     := A33001_.A007_Id;
        A33201_.Email       := Get_Email(A33201_.A007_Id);
        A33201_.Url         := Get_Url(A332_.Table_Id,
                                       A332_.Key_Id,
                                       A33201_.A007_Id,
                                       A33201_.A33201_Key);
        A33201_.Email_State := '0';
        A33201_.A007_Name   := A33001_.A007_Name;
        A33201_.User_Count  := A330_.User_Count;
        A33201_.State       := '0';
      
        Update A33201
           Set Row = A33201_
         Where A332_Id = A33201_.A332_Id
           And Line_No = A33201_.Line_No;
      
        Fetch A33001_Cur
          Into A33001_;
      End Loop;
    
      Close A33001_Cur;
    
      Fetch A33101_Cur
        Into A33101_;
    End Loop;
  
    Update A332 Set Row = A332_ Where A332_Id = A332_.A332_Id;
  End;

  /*
  0 表示没有未通过的审批记录
  其他 表示审批未完成 或 未通过 的 记录主键  
  */
  Function Check_A331(Table_Id_ In Varchar2,
                      Key_      In Varchar2,
                      A331_Id_  In Varchar2 Default 'ALL') Return Varchar2 Is
    -- count_ number ;
    A332_    A332%Rowtype;
    A332_Cur t_Cursor;
    Result_  Varchar2(10);
  Begin
    Result_ := '0';
    Open A332_Cur For
      Select t.*
        From A332 t
       Where (t.A331_Id = A331_Id_ Or A331_Id_ = 'ALL')
         And t.Table_Id = Table_Id_
         And t.Key_Id = Key_
         And t.State = '0'; --审批未关闭
    Fetch A332_Cur
      Into A332_;
    Loop
      Exit When A332_Cur%Notfound;
      Result_ := A332_.A332_Id;
      Exit;
      Fetch A332_Cur
        Into A332_;
    End Loop;
    Close A332_Cur;
    --判断有没有存在未完成的的流程 --         
    Return Result_;
  End;
  ---用户执行 sp 或动作
  Procedure Userdo_A33201(A33201_Key_ In Number,
                          If_Tg       In Varchar2,
                          Des_        In Varchar2,
                          User_Id_    In Varchar2,
                          A311_Key__  In Number Default 0) Is
    A33201_   A33201%Rowtype;
    A332_     A332%Rowtype;
    A311_Key_ Number;
  Begin
    Select t.* Into A33201_ From A33201 t Where A33201_Key = A33201_Key_;
    Select t.* Into A332_ From A332 t Where A332_Id = A33201_.A332_Id;
    If A311_Key__ = 0 Then
      Select s_A311.Nextval Into A311_Key_ From Dual;
      Insert Into A311
        (A311_Key,
         A311_Id,
         A311_Name,
         Res,
         State,
         A014_Id,
         Table_Objid,
         Do_Result,
         Enter_User,
         Enter_Date)
        Select A311_Key_,
               'PROC_0',
               'UserDo_A33201',
               '',
               '0',
               A332_.A331_Id,
               A332_.Key_Id,
               '0',
               User_Id_,
               Sysdate
          From Dual;
    Else
      A311_Key_ := A311_Key__;
    End If;
    Change_A33201(A332_.Table_Id,
                  A332_.Key_Id,
                  User_Id_,
                  If_Tg,
                  Des_,
                  A311_Key_,
                  A332_.A332_Id);
  End;
  -----执行过程A014中定义的过程
  Procedure Doa014(A014_Id_  In Varchar2,
                   Table_Id_ In Varchar2,
                   Objid_    In Varchar2,
                   User_Id_  In Varchar2,
                   A311_Key_ In Varchar2) Is
    A014_       A014%Rowtype;
    A014_Cur_   t_Cursor;
    A332_       A332%Rowtype;
    Cur_        t_Cursor;
    Count_      Number;
    Sqlerrm_    Varchar2(3000);
    Sqlcode_    Number;
    Ifsuccess_  Varchar2(20);
    User_       Varchar2(200);
    Msg_        Varchar2(500);
    Url_        Varchar2(500);
    This_Objid_ Varchar2(500);
  
  Begin
    Update A311 Set Table_Id = Table_Id_ Where A311_Key = A311_Key_;
  
    Open A014_Cur_ For
      Select t.*
        From A014 t
       Where t.A014_Id = A014_Id_
         And Rownum = 1;
    Fetch A014_Cur_
      Into A014_;
    If A014_Cur_%Notfound Then
      Close A014_Cur_;
      Setmsg(A311_Key_, '', A014_Id_ || '未定义！');
      Return;
    End If;
    Close A014_Cur_;
    If A014_.If_First = '1' Or A014_.If_First = '0' Then
      If A014_.If_First = '1' Then
        Open Cur_ For
          Select t.*
            From A332 t
           Where t.A331_Id = A014_Id_
             And t.Table_Id = A014_.Table_Id
             And t.Key_Id = Objid_;
        Fetch Cur_
          Into A332_;
        If Cur_%Notfound Then
          Close Cur_;
          Set_First(A014_.Table_Id, Objid_, User_Id_);
          Open Cur_ For
            Select t.*
              From A332 t
             Where t.A331_Id = A014_Id_
               And t.Table_Id = A014_.Table_Id
               And t.Key_Id = Objid_;
          Fetch Cur_
            Into A332_;
        End If;
      Else
        Open Cur_ For
          Select t.*
            From A332 t
           Where t.A331_Id = A014_Id_
             And t.Table_Id = A014_.Table_Id
             And t.Key_Id = Objid_;
        Fetch Cur_
          Into A332_;
      End If;
    
      If Cur_%Notfound Then
        Close Cur_;
        Setfailed(A311_Key_, A014_.Table_Id, Objid_);
        Setmsg(A311_Key_, 'S0013');
        Return;
      End If;
      Close Cur_;
      A014_.A014_Sql := ' begin ' || A014_.A014_Sql || '(''' || Objid_ ||
                        ''',''' || User_Id_ || ''',' || To_Char(A311_Key_) ||
                        ');end;';
      ---读取A311_KEY的值 如果成功--       
      Select Count(*)
        Into Count_
        From A33201 t
       Where t.A332_Id = A332_.A332_Id;
      If Count_ + 1 >= A332_.User_Count Then
        Execute Immediate A014_.A014_Sql;
        Select Ifsuccess(A311_Key_) Into Ifsuccess_ From Dual;
        If Ifsuccess_ = '0' Then
          Setmsg(A311_Key_, 'S0005');
          Return;
        End If;
        --如果存储过程成功执行以后--
        If Ifsuccess_ = '1' Then
          Update A33201
             Set State = '1', Modi_Date = Sysdate, Modi_User = User_Id_
           Where A332_Id = A332_.A332_Id
             And A33101_Line = A332_.A33101_Line
             And A007_Id = User_Id_;
          --更新同步流程的状态--   
          Update A332
             Set State     = '1',
                 f_State   = '1',
                 Modi_Date = Sysdate,
                 Modi_User = User_Id_
           Where Base_Key = A332_.Base_Key
             And State = '0';
          ----启动下一步的步骤--
          If Length(Nvl(A014_.Next_Do, '')) > 1 Then
            A014_.Next_Do := Replace(A014_.Next_Do, '[ROWID]', A332_.Key_Id);
            Open Cur_ For A014_.Next_Do;
            Fetch Cur_
              Into A014_.A014_Id;
            Loop
              Exit When Cur_%Notfound;
              Set_Next_Do(A014_.A014_Id, A332_, User_Id_);
              Fetch Cur_
                Into A014_.A014_Id;
            End Loop;
            Close Cur_;
          End If;
        End If;
      
      Else
        Setsuccess(A311_Key_, A014_.Table_Id, Objid_);
        Setmsg(A311_Key_, 'S0003');
        Return;
      End If;
      Return;
    End If;
    If A014_.If_First = '2' Or A014_.If_First = '5' Or A014_.If_First = '7' Or
       A014_.If_First = '8' Then
      A014_.A014_Sql := ' begin ' || A014_.A014_Sql || '(''' || Objid_ ||
                        ''',''' || User_Id_ || ''',' || To_Char(A311_Key_) ||
                        ');end;';
    End If;
    If A014_.If_First = '3' Then
      A014_.A014_Sql := ' begin ' || A014_.A014_Sql || '(''' || Table_Id_ ||
                        ''',''' || Objid_ || ''',''' || User_Id_ || ''',' ||
                        To_Char(A311_Key_) || ');end;';
    End If;
    Execute Immediate A014_.A014_Sql;
  
    --产生消息 把数据发送给msg包
    Select Ifsuccess(A311_Key_) Into Ifsuccess_ From Dual;
    If Ifsuccess_ = '1' Then
      If Instr(Objid_, 'OBJID') > 0 Then
        This_Objid_ := Get_Item_Value('OBJID', Objid_);
      Else
        This_Objid_ := Objid_;
      End If;
      --15秒以后发短信
      Pkg_a.Setnextdo(A311_Key_,
                      A014_.A014_Name || '-' || This_Objid_,
                      User_Id_,
                      'Pkg_Msg.Send_A014_Msg(''' || A014_.A014_Id ||
                      ''',''' || This_Objid_ || ''',''' || User_Id_ ||
                      ''',''' || A311_Key_ || ''')',
                      1 / 60 / 60 / 24);
    End If;
    Return;
    If Length(A014_.Send_User) > 5 Then
      Select Ifsuccess(A311_Key_) Into Ifsuccess_ From Dual;
      If Ifsuccess_ = '1' Then
        If Instr(Objid_, 'OBJID') > 0 Then
          This_Objid_ := Get_Item_Value('OBJID', Objid_);
        Else
          This_Objid_ := Objid_;
        End If;
        A014_.Send_User := Replace(A014_.Send_User, '[ROWID]', This_Objid_);
        A014_.Send_User := Replace(A014_.Send_User, '[USER_ID]', User_Id_);
        A014_.Send_User := Replace(A014_.Send_User, '[TABLE_ID]', Table_Id_);
        --必须有3列 1 列 用户  2  html  
      
        Open Cur_ For A014_.Send_User;
        Fetch Cur_
          Into User_, Msg_, Url_;
        Loop
          Exit When Cur_%Notfound;
          If User_Id_ <> User_ Then
          
            Pkg_Msg.Sendsysmsg(User_Id_,
                               User_,
                               Msg_,
                               Url_,
                               A014_Id_,
                               Table_Id_,
                               This_Objid_,
                               '1');
          End If;
          Fetch Cur_
            Into User_, Msg_, Url_;
        End Loop;
        Close Cur_;
        Return;
      End If;
    End If;
  
    Return;
  Exception
    When Others Then
      Sqlerrm_ := Sqlerrm;
      Rollback;
      If Length(Sqlerrm_) > 200 Then
        Sqlerrm_ := Substr(Sqlerrm_, 1, 200);
      End If;
      Sqlerrm_ := Replace(Sqlerrm_, Pkg_a.Raise_Error, '');
      Raise_Application_Error(Raise_Error, Replace(Sqlerrm_, 'ORA-', ''));
  End;

  ----当用户提交功能和审批记录的时候执行--
  Procedure Change_A33201(Table_Id_ In Varchar2,
                          Key_      In Varchar2,
                          User_Id_  In Varchar2,
                          If_Tg     In Varchar2,
                          Des_      In Varchar2,
                          A311_Key_ In Number,
                          A332_Id_  In Number) Is
    A332_Cur     t_Cursor;
    A332_        A332%Rowtype;
    Count_       Number;
    A33101_Line_ Number;
    A014_        A014%Rowtype;
    Ifsuccess_   Varchar2(100);
    Sql_Cur      t_Cursor;
  Begin
    Open A332_Cur For
      Select t.* From A332 t Where t.A332_Id = A332_Id_;
    Fetch A332_Cur
      Into A332_;
    If A332_Cur%Notfound Or A332_.f_State <> '0' Then
      Setfailed(A311_Key_);
      Setmsg(A311_Key_, 'S0004');
      Return;
    End If;
    Close A332_Cur;
    --检测同步有没有被其他用户操作--
    Select Count(*)
      Into Count_
      From A332 t
     Where t.Base_A332_Id = A332_.Base_A332_Id
       And t.f_State = '1'
       And Rownum = 1;
    If Count_ > 0 Then
      Setfailed(A311_Key_);
      Setmsg(A311_Key_, 'S0004');
      Return;
    End If;
  
    If A332_.Do_Type = 'A330' Then
      Update A33201
         Set State       = Case If_Tg
                             When '0' Then
                              '1'
                             Else
                              '-1'
                           End,
             Description = Des_,
             Modi_Date   = Sysdate,
             Modi_User   = User_Id_
       Where A332_Id = A332_.A332_Id
         And A33101_Line = A332_.A33101_Line
         And State = '0'
         And A007_Id = User_Id_;
    
      Select Count(*)
        Into Count_
        From A33201
       Where A332_Id = A332_.A332_Id
         And A33101_Line = A332_.A33101_Line
         And State = '1';
      If Count_ >= A332_.User_Count Then
        /*表示审批通过的人数超过需要审批的人数
          流程进入下一步     
        */
        Select Min(A33101_Line)
          Into A33101_Line_
          From A33201 t
         Where t.A332_Id = A332_.A332_Id
           And t.A33101_Line > A332_.A33101_Line;
        If Nvl(A33101_Line_, 0) = 0 Then
          /*表示流程已经完成*/
          Update A332
             Set f_State   = '1',
                 State     = '1',
                 Modi_Date = Sysdate,
                 Modi_User = User_Id_
           Where A332_Id = A332_.A332_Id;
        Else
          Update A332
             Set (A33101_Line, User_Count) =
                 (Select A33101_Line, User_Count
                    From A33201 t
                   Where t.A332_Id = A332_.A332_Id
                     And t.A33101_Line = A33101_Line_
                     And Rownum = 1)
           Where A332_Id = A332_.A332_Id;
        End If;
      End If;
      Update A311
         Set State = '1', Res = '01操作成功'
       Where A311_Key = A311_Key_;
    Else
      Select Count(*)
        Into Count_
        From A33201
       Where A332_Id = A332_.A332_Id
         And A33101_Line = A332_.A33101_Line
         And State = '1';
      If Count_ + 1 < A332_.User_Count Then
        Pkg_a.Setmsg(A311_Key_, '', '操作成功！');
        Return;
      End If;
    
      ---开始执行sql --
      ---获取A014的sql-----
      Select t.*
        Into A014_
        From A014 t
       Where t.A014_Id = A332_.A331_Id
         And Rownum = 1;
      A014_.A014_Sql := ' begin ' || A014_.A014_Sql || '(''' ||
                        A332_.Key_Id || ''',''' || User_Id_ || ''',' ||
                        To_Char(A311_Key_) || ');end;';
      Execute Immediate A014_.A014_Sql;
      ---读取A311_KEY的值 如果成功
      Select Ifsuccess(A311_Key_) Into Ifsuccess_ From Dual;
      --如果存储过程成功执行以后--
      If Ifsuccess_ = '1' Then
        Update A33201
           Set State       = '1',
               Description = Des_,
               Modi_Date   = Sysdate,
               Modi_User   = User_Id_
         Where A332_Id = A332_.A332_Id
           And A33101_Line = A332_.A33101_Line
           And A007_Id = User_Id_;
        --更新同步流程的状态--   
        Update A332
           Set State     = '1',
               f_State   = '1',
               Modi_Date = Sysdate,
               Modi_User = User_Id_
         Where Base_A332_Id = A332_.Base_A332_Id
           And State = '0';
      
        ----启动下一步的步骤--
        If Length(Nvl(A014_.Next_Do, '')) > 1 Then
          A014_.Next_Do := Replace(A014_.Next_Do, '[ROWID]', A332_.Key_Id);
          Open Sql_Cur For A014_.Next_Do;
          Fetch Sql_Cur
            Into A014_.A014_Id;
          Loop
            Exit When Sql_Cur%Notfound;
            Set_Next_Do(A014_.A014_Id, A332_, User_Id_);
            Fetch Sql_Cur
              Into A014_.A014_Id;
          End Loop;
          Close Sql_Cur;
        End If;
      End If;
    End If;
  
  End;
  Procedure Setsuccess(A311_Key_ In Number,
                       Table_Id_ In Varchar2 Default '',
                       Rowid_    In Varchar2 Default '') Is
  Begin
    Update A311
       Set Do_Result   = Case Do_Result
                           When '0' Then
                            '1'
                           Else
                            Do_Result
                         End,
           Table_Id = Case
                        When Length(Nvl(Table_Id, '0')) < 2 Then
                         Table_Id_
                        Else
                         Table_Id
                      End,
           Table_Objid = Case
                           When Length(Nvl(Rowid_, '0')) > 2 Then
                            Rowid_
                           Else
                            Table_Objid
                         End
     Where A311_Key = A311_Key_;
  End;

  Procedure Setresult(A314_Key_ In Number, Res_ In Varchar2 Default '') Is
  Begin
    Update A314
       Set Res = Res_, Modi_Date = Sysdate, Modi_User = Enter_User
     Where A314_Key = A314_Key_;
  End;

  Function Ifsuccess(A311_Key_ In Number) Return Varchar2 Is
    Do_Result_ Varchar2(100);
  Begin
    Select Do_Result
      Into Do_Result_
      From A311
     Where A311_Key = A311_Key_
       And Rownum = 1;
    Return Do_Result_;
  Exception
    When Others Then
      Return '-1';
  End;
  Procedure Setfailed(A311_Key_ In Number,
                      Table_Id_ In Varchar2 Default '',
                      Rowid_    In Varchar2 Default '') Is
  Begin
    Update A311
       Set Do_Result   = '-1',
           Table_Id    = Nvl(Table_Id, Table_Id_),
           Table_Objid = Rowid_
     Where A311_Key = A311_Key_;
  End;
  Procedure Setnextdo(A311_Key_  In Number,
                      Doname_    In Varchar2,
                      User_Id_   In Varchar2,
                      Nextsql_   In Varchar2,
                      Nexttimes_ In Number Default 0) Is
    A315_ A315%Rowtype;
  Begin
    --把任务放到队列中
    Select s_A315.Nextval Into A315_.A315_Id From Dual;
    A315_.Enter_User := User_Id_;
    A315_.Enter_Date := Sysdate;
    Insert Into A315
      (A315_Id,
       A315_Name,
       A311_Key,
       A315_Sql,
       Enter_User,
       Enter_Date,
       State,
       Do_Time)
    Values
      (A315_.A315_Id,
       Doname_,
       A311_Key_,
       Nextsql_,
       A315_.Enter_User,
       A315_.Enter_Date,
       '0',
       A315_.Enter_Date + Nexttimes_);
  
  End;

  Procedure Setmsg(A311_Key_ In Number,
                   Msg_Id_   In Varchar2,
                   Msg__     In Varchar Default '',
                   Rowid_    In Varchar Default '') Is
    Msg_ Varchar2(1000);
  Begin
    Msg_ := Msg__;
    If Length(Nvl(Msg_, '0')) > 1 Then
      If Substr(Msg_, 1, 2) = '01' Or Substr(Msg_, 1, 2) = '02' Or
         Substr(Msg_, 1, 2) = '03' Then
        Msg_ := Msg__;
      Else
        Msg_ := '01' || Msg__;
      End If;
    
    Else
      Select Pkg_Msg.Getmsgbymsgid(Msg_Id_,
                                   Rowid_,
                                   'web',
                                   Getuserlanguage(Enter_User))
        Into Msg_
        From A311
       Where A311_Key = A311_Key_;
    End If;
  
    Update A311
       Set State     = '1',
           Res       = Msg_,
           Modi_Date = Sysdate,
           Modi_User = Enter_User
     Where A311_Key = A311_Key_;
  End;
  Procedure Beginlog(A311_ In Out A311%Rowtype) Is
  Begin
    Select s_A311.Nextval Into A311_.A311_Key From Dual;
    Insert Into A311
      (A311_Key,
       A311_Id,
       Res,
       State,
       Enter_User,
       Enter_Date,
       Do_Result,
       Table_Id,
       Table_Objid,
       A014_Id)
      Select A311_.A311_Key,
             A311_.A311_Id,
             Null,
             '0',
             A311_.Enter_User,
             Sysdate,
             '0',
             A311_.Table_Id,
             A311_.Table_Objid,
             A311_.A014_Id
        From Dual;
  End;

  --激活下一个流程
  --p_a332_  上一个流程 动作记录
  --
  Procedure Set_Next_Do(A014_Id_ In Varchar2,
                        p_A332_  A332%Rowtype,
                        User_Id_ In Varchar2) Is
    A014_   A014%Rowtype;
    Obj_Cur t_Cursor;
    A332_   A332%Rowtype;
    A33201_ A33201%Rowtype;
  Begin
    Select t.*
      Into A014_
      From A014 t
     Where A014_Id = A014_Id_
       And Rownum = 1;
    If Nvl(A014_.Table_Id, '0') <> Nvl(p_A332_.Table_Id, '0') Then
      Raise_Application_Error(-20001,
                              A014_Id_ || '和' || p_A332_.A331_Id ||
                              '表不一致，无法流转');
      Return;
    End If;
    A332_.A332_Id := Check_A331(A014_.Table_Id,
                                p_A332_.Key_Id,
                                A014_.A014_Id);
    If A332_.A332_Id = 0 Then
      Select s_A332.Nextval Into A332_.A332_Id From Dual;
      Insert Into A332
        (A332_Id, A331_Name)
        Select A332_.A332_Id, A332_.A332_Name From Dual;
      A332_.A332_Name      := p_A332_.A332_Name;
      A332_.A331_Id        := A014_.A014_Id;
      A332_.A331_Name      := A014_.A014_Name;
      A332_.A33101_Line    := 0;
      A332_.Current_A33201 := 1;
      A332_.Key_Id         := p_A332_.Key_Id;
      A332_.Enter_User     := User_Id_;
      A332_.Enter_Date     := Sysdate;
      A332_.State          := '0'; ----默认流程还未关闭
      A332_.f_State        := '0'; --默认审批通过
      A332_.Table_Id       := A014_.Table_Id;
      A332_.A33101_Line    := 1;
      A332_.User_Count     := A014_.User_Count; --只要一个操作就允许通过--
      A332_.Do_Type        := 'A014';
      A332_.Base_A332_Id   := p_A332_.A332_Id;
      A332_.Base_Key       := A332_.A332_Name || '-' || p_A332_.A331_Id;
      /*获取执行的人员列表*/
      If Length(Nvl(A014_.User_Sql, '0')) < 5 Then
        A014_.User_Sql := 'Select ''' || User_Id_ ||
                          ''' as a007_id from dual';
      Else
        A014_.User_Sql := Replace(A014_.User_Sql, '[ROWID]', A332_.Key_Id);
        A014_.User_Sql := Replace(A014_.User_Sql,
                                  '[TABLE_ID]',
                                  A014_.Table_Id);
        A014_.User_Sql := Replace(A014_.User_Sql, '[USER_ID]', User_Id_);
        A014_.User_Sql := Replace(A014_.User_Sql,
                                  '[A014_ID]',
                                  A014_.A014_Id);
      End If;
      Open Obj_Cur For A014_.User_Sql;
      Fetch Obj_Cur
        Into A33201_.A007_Id;
      Loop
        Exit When Obj_Cur%Notfound;
        A33201_.A332_Id := A332_.A332_Id;
        A33201_.Line_No := Nvl(A33201_.Line_No, 0) + 1;
        Insert Into A33201
          (A332_Id, Line_No)
          Select A33201_.A332_Id, A33201_.Line_No From Dual;
        Select s_A33201.Nextval Into A33201_.A33201_Key From Dual;
        A33201_.Sort_By     := A33201_.Line_No;
        A33201_.A331_Id     := A332_.A331_Id;
        A33201_.A33101_Line := A332_.A33101_Line;
        A33201_.Enter_User  := User_Id_;
        A33201_.Enter_Date  := Sysdate;
        A33201_.A330_Id     := Null;
        A33201_.A33001_Line := 1;
        A33201_.A007_Name   := A33201_.A007_Id;
        A33201_.User_Count  := 1;
        A33201_.State       := '0';
        A33201_.Email       := Get_Email(A33201_.A007_Id);
        A33201_.Url         := Get_Url(A332_.Table_Id,
                                       A332_.A332_Name,
                                       A33201_.A007_Id,
                                       A33201_.A33201_Key);
        A33201_.Email_State := '0';
      
        Update A33201
           Set Row = A33201_
         Where A332_Id = A33201_.A332_Id
           And Line_No = A33201_.Line_No;
        Fetch Obj_Cur
          Into A33201_.A007_Id;
      End Loop;
      Close Obj_Cur;
      Update A332 Set Row = A332_ Where A332_Id = A332_.A332_Id;
    End If;
  
    Return;
  
  End;

  Function Get_Email(User_Id_ In Varchar) Return Varchar2 Is
    Email_ Varchar2(200);
  Begin
    Select t.Email Into Email_ From A007_V01 t Where t.A007_Id = User_Id_;
    Return Email_;
  Exception
    When Others Then
      Return Null;
  End;
  Function Get_Url(Table_Id_   In Varchar,
                   Rowid_      In Varchar2,
                   User_Id_    In Varchar2,
                   A33201_Key_ In Number) Return Varchar2 Is
    Url_    Varchar2(200);
    Uen     Varchar2(200);
    Ucode   Varchar2(200);
    A00201_ A00201_V01%Rowtype;
  Begin
    --用a33201_key_ 加盟用户 --
  
    Ucode := Encrypt_Key_Mode(A33201_Key_, 'wtlqlwtl');
    Ucode := Replace(Ucode, '+', '_');
  
    Uen := Encrypt_Key_Mode(User_Id_, Substr(A33201_Key_ || Ucode, 1, 8));
    Uen := Replace(Uen, '+', '_');
    Select t.*
      Into A00201_
      From A00201_V01 t
     Where t.Main_Table = Table_Id_
       And t.Table_Id = Table_Id_
       And Rownum = 1;
    Url_ := Get_Http_Url() || '//ShowForm/MainForm.aspx?option=V&A002KEY=' ||
            A00201_.Menu_Id || '&key=' || Get_Key_Value(Table_Id_, Rowid_);
    Url_ := Url_ || '&' || 'ucode=' || Ucode || '&' || 'uen=' || Uen;
    Return Url_;
  Exception
    When Others Then
      Return Null;
  End;

  Function Get_Uuser(Ucode_ In Varchar2, Uen_ In Varchar2) Return Varchar2 Is
    User_Id_    Varchar2(200);
    A33201_Key_ Varchar2(200);
    Uen         Varchar2(200);
  Begin
    A33201_Key_ := Decrypt_Key_Mode(Replace(Ucode_, '_', '+'), 'wtlqlwtl');
    A33201_Key_ := Substr(A33201_Key_ || Ucode_, 1, 8);
    User_Id_    := Decrypt_Key_Mode(Replace(Uen_, '_', '+'), A33201_Key_);
    Return User_Id_;
  Exception
    When Others Then
      Return Null;
  End;
  Function Get_Http_Url Return Varchar2 Is
    Http_Url_ Varchar2(150);
  Begin
    Select A022_Name Into Http_Url_ From A022 Where A022_Id = 'HTTP_URL';
    Return Http_Url_;
  Exception
    When Others Then
      Return '';
    
  End;
  Function Get_A022_Name(A022_Id_ In Varchar2) Return Varchar2 Is
    A002_Name_ Varchar2(150);
  Begin
    Select A022_Name Into A002_Name_ From A022 Where A022_Id = A022_Id_;
    Return A002_Name_;
  Exception
    When Others Then
      Return Null;
    
  End;

  Function Gen_Raw_Key(Ikey In Varchar2) Return Raw As
    Rawkey Raw(240) := '';
  Begin
    For i In 1 .. Length(Ikey) Loop
      Rawkey := Rawkey || Hextoraw(To_Char(Ascii(Substr(Ikey, i, 1))));
    End Loop;
    Return Rawkey;
  End Gen_Raw_Key;
  /* Creating function DECRYPT_3KEY_MODE 解密*/
  Function Decrypt_3key_Mode(Ivalue In Varchar2,
                             Imode  In Pls_Integer,
                             Ikey_  In Varchar Default Ikey) Return Varchar2 As
    Vdecrypted Varchar2(4000);
    Rawkey     Raw(240) := '';
  
  Begin
    Rawkey     := Gen_Raw_Key(Formatkey(Ikey_)); -- decrypt input string
    Vdecrypted := Dbms_Obfuscation_Toolkit.Des3decrypt(Utl_Raw.Cast_To_Varchar2(Utl_Encode.Base64_Decode(Utl_Raw.Cast_To_Raw(Ivalue))),
                                                       Key_String => Rawkey,
                                                       Which => Imode);
    Return Formatstr2(Vdecrypted);
  Exception
    When Others Then
      Return Null;
    
  End Decrypt_3key_Mode;
  /*Creating function ENCRYPT_3KEY_MODE 加密*/
  Function Encrypt_3key_Mode(Ivalue In Varchar2,
                             Imode  In Pls_Integer,
                             Ikey_  In Varchar Default Ikey) Return Varchar2 As
    Vencrypted    Varchar2(4000);
    Vencryptedraw Raw(2048);
    Rawkey        Raw(240) := '';
    Ivalue_       Varchar2(4000);
    Ikey__        Varchar2(50);
  Begin
    Ivalue_    := Formatstr(Ivalue);
    Ikey__     := Formatkey(Ikey_);
    Rawkey     := Gen_Raw_Key(Formatkey(Ikey__)); -- encrypt input string
    Vencrypted := Dbms_Obfuscation_Toolkit.Des3encrypt(Ivalue_,
                                                       Key_String => Rawkey,
                                                       Which      => Imode);
    -- convert to raw as out
    Vencryptedraw := Utl_Raw.Cast_To_Raw(Vencrypted);
    Return Utl_Raw.Cast_To_Raw(Vencrypted);
    Return Utl_Raw.Cast_To_Varchar2(Utl_Encode.Base64_Encode(Utl_Raw.Cast_To_Raw(Vencrypted)));
    --UTL_RAW.CAST_TO_VARCHAR2(utl_encode.base64_encode( UTL_RAW.CAST_TO_RAW(vEncrypted)));
    /* exception
         when others then
           return  null ;
    */
  End Encrypt_3key_Mode;

  Procedure Savequerysql(User_Id_    In Varchar2,
                         A00201_Key_ In Varchar2,
                         Sql_        In Varchar2) Is
    Cur_          t_Cursor;
    Row_          A00601%Rowtype;
    Sql_Noorderby Varchar2(4000);
    Pos_          Number;
  Begin
    Sql_Noorderby := Sql_;
    Pos_          := Instr(Lower(Sql_Noorderby), 'order by ');
    If Pos_ > 0 Then
      Sql_Noorderby := Substr(Sql_Noorderby, 1, Pos_ - 1);
    
    End If;
    Open Cur_ For
      Select t.*
        From A00601 t
       Where t.User_Id = User_Id_
         And t.A00201_Key = A00201_Key_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Insert Into A00601
        (User_Id,
         A00201_Key,
         Select_Sql,
         Enter_Date,
         Enter_User,
         Select_Sql_Order_By)
        Select User_Id_,
               A00201_Key_,
               Sql_Noorderby,
               Sysdate,
               User_Id_,
               Sql_
          From Dual;
      Return;
    End If;
    Close Cur_;
    Update A00601
       Set Select_Sql          = Sql_Noorderby,
           Select_Sql_Order_By = Sql_,
           Modi_Date           = Sysdate,
           Modi_User           = User_Id_
     Where User_Id = User_Id_
       And A00201_Key = A00201_Key_;
    Return;
  End;

  /*Creating function ENCRYPT_3KEY_MODE 加密*/
  Function Encrypt_Key_Mode(Ivalue In Varchar2,
                            Ikey_  In Varchar Default Ikey) Return Varchar2 As
    Vencrypted    Varchar2(4000);
    Vencryptedraw Raw(2048);
    Rawkey        Raw(240) := '';
    Ivalue_       Varchar2(4000);
    Ikey__        Varchar2(50);
  Begin
    Ivalue_    := Formatstr(Ivalue);
    Ikey__     := Formatkey(Ikey_);
    Vencrypted := Dbms_Obfuscation_Toolkit.Desencrypt(Input_String => Ivalue_,
                                                      Key_String   => Ikey__);
  
    -- return  
    Return Utl_Raw.Cast_To_Varchar2(Utl_Encode.Base64_Encode(Utl_Raw.Cast_To_Raw(Vencrypted)));
  
  End Encrypt_Key_Mode;
  Function Getmenuname(A002_Key_ In Varchar2, User_Id_ In Varchar2)
    Return Varchar2
  
   Is
    Result_ Varchar2(200);
  Begin
    Select Case Getuserlanguage(User_Id_)
             When 'CN' Then
              Menu_Name
             Else
              En_Menu_Name
           End
      Into Result_
      From A002_V01 t
     Where t.A002_Key = A002_Key_
       And Rownum = 1;
    Return Result_;
  End;

  Function Getuserlanguage(User_Id_ In Varchar2) Return Varchar2 Is
    Result_ Varchar2(20);
  Begin
    Select t.Language_Id
      Into Result_
      From A007 t
     Where t.A007_Id = User_Id_
       And Rownum = 1;
  
    Return Nvl(Result_, 'CN');
  End;

  Function Decrypt_Key_Mode(Ivalue In Varchar2,
                            Ikey_  In Varchar Default Ikey) Return Varchar2 Is
    Vdecrypt Varchar2(4000);
    Ivalue_  Varchar2(4000);
    Ikey__   Varchar2(400);
  Begin
    Ikey__   := Formatkey(Ikey_);
    Ivalue_  := Utl_Raw.Cast_To_Varchar2(Utl_Encode.Base64_Decode(Utl_Raw.Cast_To_Raw(Ivalue)));
    Vdecrypt := Dbms_Obfuscation_Toolkit.Desdecrypt(Input_String => Ivalue_,
                                                    Key_String   => Ikey__);
  
    Return Replace(Vdecrypt, Chr(0), '');
  End Decrypt_Key_Mode;

  Function Formatstr(Ivalue In Varchar2) Return Varchar2 As
  Begin
    Declare
      i       Number;
      j       Number;
      m_Value Varchar2(4000);
    Begin
      m_Value := Ivalue;
      i       := (Length(m_Value) Mod 8);
      If i <> 0 Then
        j := 1;
        For j In 1 .. (8 - i) Loop
          m_Value := m_Value || Chr(0);
        End Loop;
      End If;
      Return m_Value;
    End;
  End Formatstr;

  Function Formatkey(Ikey_ In Varchar2) Return Varchar2 Is
    Key_ Varchar2(20);
    Len_ Number;
  Begin
    Len_ := Length(Ikey_);
  
    If Len_ < 8 Then
      Key_ := Ikey_;
      For i In (Len_ + 1) .. 8 Loop
        Key_ := Key_ || '-';
      End Loop;
    Else
      Key_ := Substr(Ikey_, 1, 8);
    End If;
  
    Return Key_;
  
    Return '';
  
  End Formatkey;

  Function Formatstr2(Ivalue In Varchar2) Return Varchar2 As
  Begin
    Declare
      i Number;
      --    j number;
      m_Value Varchar2(4000);
    Begin
      m_Value := Ivalue;
      i       := Instr(Ivalue, '#', 1, 1);
      If i > 0 Then
        m_Value := Substr(m_Value, 1, i - 1);
      End If;
      Return m_Value;
    End;
  End Formatstr2;

  Procedure Set_Do_Time(Eve_Name_ In Varchar2) Is
  Begin
    Insert Into A312
      (A312_Key, A312_Id, A312_Name, Enter_Date, Enter_User)
      Select s_A312.Nextval, '', Eve_Name_, Systimestamp, 'ADMIN'
        From Dual;
  
    Return;
  End;
  ----保存修改日志 记录修改以后的数据 从新增开始
  Procedure Save_Data_Log(Table_Id_ In Varchar2,
                          Rowlist_  In Varchar2,
                          User_Id_  In Varchar2) Is
    A305_      A305%Rowtype;
    Objid_     Varchar2(200);
    A10001_Cur t_Cursor;
    A10001_    A10001%Rowtype;
    i_         Number;
  Begin
    i_ := 0;
    /*获取表中要记录日志的列*/
    Open A10001_Cur For
      Select t.*
        From A10001 t
       Where t.Table_Id = Table_Id_
       Order By Sort_By;
    Fetch A10001_Cur
      Into A10001_;
    Loop
      Exit When A10001_Cur%Notfound;
      i_ := i_ + 1;
    End Loop;
    Close A10001_Cur;
    If i_ = 0 Then
      Return;
    End If;
  
    Select s_A305.Nextval Into A305_.A305_Id From Dual;
    Insert Into A305
      (A305_Id, Enter_Date, Enter_User)
      Select A305_.A305_Id, Sysdate, User_Id_ From Dual;
    Objid_         := Get_Item_Value('OBJID', Rowlist_);
    A305_.Table_Id := Table_Id_;
    A305_.Col_Id   := Objid_;
  End;
  Function Get_Str_(Data_ Varchar2, Index_ Varchar2, Num_ In Number)
    Return Varchar2 Is
    Datalist_ Dbms_Sql.Varchar2_Table;
  Begin
    Datalist_ := Get_Str_List_By_Index(Data_, Index_);
    If (Datalist_(Num_) Is Null And Datalist_(Num_ + 1) Is Not Null) Then
      Return Index_ || Datalist_(Num_ + 1);
    End If;
    Return Datalist_(Num_);
  Exception
    When Others Then
      Return Null;
    
  End;
  Function Get_Str_List_By_Index(Data_ Varchar2, Index_ Varchar2)
    Return Dbms_Sql.Varchar2_Table Is
    Datalist_ Dbms_Sql.Varchar2_Table;
    Pos_      Number;
    i         Number;
    Data__    Varchar2(30000);
  Begin
    Data__ := Data_;
    Pos_   := Instr(Data__, Index_);
    i      := 1;
    Loop
      Exit When Nvl(Pos_, 0) = 0;
      Datalist_(i) := Substr(Data__, 1, Pos_ - 1);
      Data__ := Substr(Data__, Pos_ + Length(Index_));
      Pos_ := Instr(Data__, Index_);
      i := i + 1;
    End Loop;
    Datalist_(i) := Data__;
    Return Datalist_;
  End;

  --建立临时表
  Procedure Createtemptable(Sql_ In Varchar2, Table_Id_ In Varchar2) Is
  
    Create_Sql_ Varchar2(4000);
  Begin
    Droptemptable(Table_Id_);
  
    Create_Sql_ := 'CREATE GLOBAL TEMPORARY  table ' || Table_Id_ || ' ';
    Create_Sql_ := Create_Sql_ || ' as ' || Sql_;
  
    Execute Immediate Create_Sql_;
  End;

  Procedure Droptemptable(Table_Id_ In Varchar2) Is
    Cur_         t_Cursor;
    Object_Name_ Varchar2(200);
  Begin
    Open Cur_ For
      Select Object_Name
        From User_Objects t
       Where t.Object_Name = Table_Id_;
    Fetch Cur_
      Into Object_Name_;
    If Cur_%Found Then
      Execute Immediate 'drop table ' || Table_Id_;
    End If;
    Close Cur_;
  
  End;
  Function Get_Sql_Value__(Sql_ Varchar2) Return Varchar2 Is
    Cur_    t_Cursor;
    Result_ Varchar2(3000);
  Begin
    Open Cur_ For Sql_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  Exception
    When Others Then
      Return Null;
  End;

End Pkg_a;
/
