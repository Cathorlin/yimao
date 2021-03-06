Create Or Replace Package Pkg_Show Is
  /*
    -- Author  : 吴天磊
    -- Created : 2012-03-06 12:00:47
    -- Purpose :
  
    -- Public type declarations
    type <TypeName> is <Datatype>;
  
    -- Public constant declarations
    <ConstantName> constant <Datatype> := <Value>;
  
    -- Public variable declarations
    <VariableName> <Datatype>;
  
    -- Public function and procedure declarations
    function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  */

  /*用户每个菜单的样式的 A01301 sql*/
  Function Getsysconfig(User_Id_ In Varchar2) Return Varchar2;
  Function Getbuttonhtml(A00201_ A00201_V01%Rowtype) Return Varchar2;

  /*用户每个菜单的功能键
  a00201_key 菜单
  key_      数据的主键
  */
  Function Geta00204(A00201_Key_ In Varchar2,
                     Key_        In Varchar2, --- 当前
                     User_Id_    In Varchar2,
                     If_Query    In Varchar2,
                     Option_     In Varchar2, ---执行的动作
                     Status_     In Varchar2 Default '-') Return Varchar2;
  /*根据状态获取菜单是否可用*/
  Function Getrbdouseable(Rb_Do_   Varchar2,
                          Status_  In Varchar2,
                          Menu_Id_ In Varchar2) Return Varchar2;
  /*用户每个菜单的样式的 A01301 sql*/
  Function Geta01301(A00201_Key_ In Varchar2, User_Id_ In Varchar2)
    Return Varchar2;

  /*获取每个A0130101的表的*/
  Function Geta0130101(A00201_Key_ In Varchar2, User_Id_ In Varchar2)
    Return Varchar2;

  /*获取每个查询条件的列的表的*/
  Function Getquerycondtion(A00201_Key_ In Varchar2, User_Id_ In Varchar2)
    Return Varchar2;
  ---获取列的属性
  Function Get_Column_Attr(User_Id_       In Varchar2,
                           Menu_Id_       In Varchar2,
                           Control_Id_    In Varchar2,
                           Table_Id_      In Varchar2,
                           Column_Id_     In Varchar2,
                           Sys_Visible_   In Varchar2 Default '1',
                           Sys_Enable_    In Varchar2 Default '1',
                           Sys_Necessary_ In Varchar2 Default '0')
    Return Varchar2;
  /*获取每个A00201的表的*/
  Function Geta013010101(A00201_Key_ In Varchar2, User_Id_ In Varchar2)
    Return Varchar2;

  /*获取数据的sql语句*/
  Function Getshowdatasql(A00201_Key_ In Varchar2, User_Id_ In Varchar2)
    Return Varchar2;

  /*数据的检测*/
  Procedure Checkdata(Data_ In Long, A0130101_ In Long, A311_Key In Number);

  /*根据数据来检测是否可以编辑*/
  Function Getoption(Menu_Id_ In Varchar2,
                     Status_  In Varchar,
                     Option_  In Varchar2,
                     User_Id_ In Varchar2) Return Varchar2;

  Function Geta014use(A00201_Key_ In Varchar2,
                      A014_Id_    In Varchar2,
                      Objid_      In Varchar2,
                      User_Id_    In Varchar2) Return Varchar2;

  /*获取每个A00201的表的*/
  Procedure Pgeta013010101(A00201_Key_ In Varchar2, User_Id_ In Varchar2);

  /*获取sql中得参数*/
  Function Getparmlistbysql(Sql_ In Varchar2) Return Varchar2;

  Function Format_Sql_c_Line(Table_Id_ In Varchar2, Sql_ In Varchar)
    Return Varchar2;

  /*检测审批*/
  Function User_If_Have_A332(Table_Id_ In Varchar2,
                             Key_      In Varchar2,
                             User_Id_  In Varchar2) Return Varchar2;

  Function Getshowdatacountsql(A00201_Key_ In Varchar2,
                               User_Id_    In Varchar2) Return Varchar2;
  /*获取2个字符串之间的数据*/
  Function Get_Search_Value(Data_   In Varchar2,
                            Index1_ In Varchar2,
                            Index2_ In Varchar2) Return Varchar2;
  /*获取功能键的执行sql*/
  Function Getrb_Execsql(Menu_Id_ Varchar2,
                         Line_No_ Number,
                         Key_     Varchar2,
                         User_Id_ Varchar2) Return Varchar2;

  /*根据列名获取line_NO*/
  Function Get_A10001_Line_No(Table_Id_  In Varchar2,
                              Column_Id_ In Varchar2) Return Varchar2;

  /*检测用户对菜单的权限 */

  Function Get_A00201_Useable(A00201_Key_ In Varchar2,
                              User_Id_    In Varchar2,
                              Type_       In Varchar2,
                              Pkg_Name_   In Varchar2,
                              Key_        In Varchar2) Return Varchar2;
  /*检测用户对功能的权限 */
  Function Get_Rb_Do_Useable(Menu_Id_ In Varchar2,
                             User_Id_ In Varchar2,
                             Rb_      In Varchar2) Return Varchar2;

End Pkg_Show;
/
Create Or Replace Package Body Pkg_Show Is
  Type t_Cursor Is Ref Cursor;
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
  
  begin
    -- Initialization
    <Statement>;
    */
  Function Geta01301(A00201_Key_ In Varchar2, User_Id_ In Varchar2)
    Return Varchar2 Is
  Begin
    Return 'Select t.* from A00201_V01 t where  a00201_key =' || A00201_Key_;
  End;

  Function Geta0130101(A00201_Key_ In Varchar2, User_Id_ In Varchar2)
    Return Varchar2 Is
  Begin
    Return 'Select t.* from a00201_v01 t where  a00201_key =' || A00201_Key_;
  End;
  Procedure Pgeta013010101(A00201_Key_ In Varchar2, User_Id_ In Varchar2) Is
  
    A00201_    A00201_V01%Rowtype;
    Sql_       Varchar2(1000);
    Create_Sql Varchar2(5000);
    Count_     Number;
  Begin
    Select t.*
      Into A00201_
      From A00201_V01 t
     Where t.A00201_Key = A00201_Key_;
    If Upper(A00201_.Table_Id) = 'SQL' Then
      Select Count(*)
        Into Count_
        From User_Objects t
       Where t.Object_Name =
             'SQL_' || Replace(A00201_.A00201_Key, '-', '_')
         And Rownum = 1;
      If Count_ > 0 Then
        Execute Immediate 'drop table SQL_' ||
                          Replace(A00201_.A00201_Key, '-', '_');
      End If;
      Create_Sql := 'CREATE GLOBAL TEMPORARY  table SQL_' ||
                    Replace(A00201_.A00201_Key, '-', '_') || ' ';
      Create_Sql := Create_Sql || ' as ' || A00201_.Condition || ' AND 1=2';
      Execute Immediate Create_Sql;
      --   delete from A100 t where t.table_id= 'SQL_' || replace(a00201_.a00201_key,'-','_');
      --   delete from A10001 t where t.table_id= 'SQL_' || replace(a00201_.a00201_key,'-','_') and t.enter_date = t.modi_date;
      --     commit ;
      Execute Immediate 'begin pkg_a.insert_a10001_from_sys(''SQL_' ||
                        Replace(A00201_.A00201_Key, '-', '_') ||
                        ''') ; end ; ';
    
      Execute Immediate 'drop table SQL_' ||
                        Replace(A00201_.A00201_Key, '-', '_');
    
      Return;
    End If;
  End;

  Function Geta013010101(A00201_Key_ In Varchar2, User_Id_ In Varchar2)
    Return Varchar2 Is
    A00201_    A00201_V01%Rowtype;
    Sql_       Varchar2(1000);
    Create_Sql Varchar2(5000);
  Begin
    Select t.*
      Into A00201_
      From A00201_V01 t
     Where t.A00201_Key = A00201_Key_;
    If Upper(A00201_.Table_Id) = 'SQL' Then
      Sql_ := 'Select t.*,';
      Sql_ := Sql_ || '''110'' as ev,
           ''0'' as col_visible,
           ''0'' as col_enable,
           ''0'' as col_necessary,
           t.line_no as A10001_KEY,
            0 AS A008_COUNT,
            0 AS pbf_frmt,
            0 AS c_user_flag
           from A10001 t  
           where t.table_id= ''SQL_' ||
              Replace(A00201_.A00201_Key, '-', '_') || ''' 
           order by col_x  ';
    
      Return Sql_;
    End If;
    Sql_ := 'Select t.*,';
    Sql_ := Sql_ || 'pkg_show.get_column_attr(''' || User_Id_ || ''',''' ||
            A00201_.Menu_Id || ''',''' || A00201_.Control_Id || ''',''' ||
            A00201_.Table_Id || ''',t.column_id,t.sys_visible,t.sys_enable,t.sys_necessary) as ev,
           ''0'' as col_visible,
           ''0'' as col_enable,
           ''0'' as col_necessary,
           t.line_no as A10001_KEY,
          	GET_A008_COUNT(t.table_id || ''.''||t.COLUMN_ID) AS A008_COUNT,
            GET_COLUMN_FORMAT(t.COL_EDIT) AS pbf_frmt,
            GET_TABLE_user_flag(t.SELECT_FLAG , t.std_flag  ,t.table_select  ,t.column_id ) AS c_user_flag
           from A10001 t  
           where t.table_id= ''' || A00201_.Table_Id || '''
           order by col_x  ';
    Return Sql_;
  End;

  /*获取查询条件的列*/
  Function Getquerycondtion(A00201_Key_ In Varchar2, User_Id_ In Varchar2)
    Return Varchar2 Is
    A00201_ A00201_V01%Rowtype;
    Sql_    Varchar2(1000);
  Begin
    --updateable表示列在页面是否有更新属性
    --select_sql
    Select t.*
      Into A00201_
      From A00201_V01 t
     Where t.A00201_Key = A00201_Key_;
    If Upper(A00201_.Table_Id) = 'SQL' Then
      Sql_ := 'Select t.*,';
      Sql_ := Sql_ || '''110'' as ev,
           ''0'' as col_visible,
           ''0'' as col_enable,
           ''0'' as col_necessary,
           t.line_no as A10001_key,
            0 AS A008_COUNT,
            0 AS pbf_frmt,
            0 AS c_user_flag
           from A10001 t  
           where t.table_id= ''SQL_' ||
              Replace(A00201_.A00201_Key, '-', '_') || ''' 
           order by col_x  ';
    
      Return Sql_;
    End If;
    Sql_ := 'Select t.*,';
    Sql_ := Sql_ || 'pkg_show.get_column_attr(''' || User_Id_ || ''',''' ||
            A00201_.Menu_Id || ''',''' || A00201_.Control_Id || ''',''' ||
            A00201_.Table_Id || ''',t.column_id,t.sys_visible,t.sys_enable,t.sys_necessary) as ev,
           ''0'' as col_visible,
           ''0'' as col_enable,
           ''0'' as col_necessary,
            t.line_no as A10001_KEY
            from A10001 t  
            where t.table_id= ''' || A00201_.Table_Id || '''
            and   t.bs_query = ''1''
            order by col_x  ';
    Return Sql_;
  End;
  Function Get_Column_Attr(User_Id_       In Varchar2,
                           Menu_Id_       In Varchar2,
                           Control_Id_    In Varchar2,
                           Table_Id_      In Varchar2,
                           Column_Id_     In Varchar2,
                           Sys_Visible_   In Varchar2 Default '1',
                           Sys_Enable_    In Varchar2 Default '1',
                           Sys_Necessary_ In Varchar2 Default '0')
    Return Varchar2 As
    Visible_        Varchar2(20);
    Enable_         Varchar2(20);
    Necessary_      Varchar2(20);
    Ev_             Varchar2(20);
    Role_Visible_   Number;
    Cur_            t_Cursor;
    Role_Enable_    Number;
    Role_Necessary_ Number;
  Begin
    If Sys_Visible_ = '0' Then
      Return '000';
    End If;
    Enable_ := '1';
    ---判断角色权限-- 
    Select Sum(To_Number(Nvl(T1.Col_Enable, 0))),
           Sum(To_Number(Nvl(T1.Col_Visible, 0))),
           Sum(To_Number(Nvl(T1.Col_Necessary, 0)))
      Into Role_Enable_, Role_Visible_, Role_Necessary_
      From A013010101 T1
     Inner Join A00701 T2
        On T2.A013_Id = T1.A013_Id
       And T2.A007_Id = User_Id_
     Where T1.A002_Id = Menu_Id_
       And T1.Control_Id = Control_Id_
       And T1.Column_Id = Column_Id_;
    If Role_Visible_ = 0 Then
      Return '000';
    End If;
  
    If Sys_Enable_ = '0' Then
      Enable_ := '0';
    Else
      If Nvl(Role_Enable_, '1') > 0 Then
        Role_Enable_ := '1';
      End If;
      Enable_ := Nvl(Role_Enable_, '1');
    End If;
    If Role_Necessary_ > 0 Then
      Necessary_ := 1;
    Else
      Necessary_ := 0;
    End If;
    If Sys_Necessary_ = '1' Then
      Necessary_ := '1';
    End If;
    Ev_ := Enable_ || '1' || To_Char(Necessary_);
    -- return ev_;
    Open Cur_ For
      Select T1.Col_Enable, T1.Col_Visible, T1.Col_Necessary
        From A016 T1
       Where T1.A016_Id = User_Id_
         And T1.A002_Id = Menu_Id_
         And T1.Control_Id = Control_Id_
         And T1.Column_Id = Column_Id_;
    Fetch Cur_
      Into Role_Enable_, Role_Visible_, Role_Necessary_;
    If Cur_%Notfound Then
      Close Cur_;
      Return Ev_;
    End If;
    Close Cur_;
    If Role_Visible_ = 0 Then
      Return '000';
    End If;
    If Enable_ = '0' Then
      Enable_ := '0';
    Else
      If Nvl(Role_Enable_, '1') > 0 Then
        Role_Enable_ := '1';
      End If;
      Enable_ := Nvl(Role_Enable_, '1');
    End If;
    If Enable_ = 0 Then
      Return '010';
    End If;
  
    If Role_Necessary_ > 0 Then
      Role_Necessary_ := 1;
    Else
      Role_Necessary_ := 0;
    End If;
    If Sys_Necessary_ = '1' Or Role_Necessary_ = '1' Or Necessary_ = '1' Then
      Necessary_ := '1';
    End If;
    Ev_ := '11' || To_Char(Necessary_);
    Return Ev_;
  End;

  /*新增按钮的html*/
  Function Getbuttonhtml(A00201_ A00201_V01%Rowtype) Return Varchar2 Is
    Html_   Varchar2(1000);
    Button_ Varchar2(1000);
    Url_    Varchar2(500);
  Begin
  
    Url_    := '[HTTP_URL]/ShowForm/MainForm.aspx?ISAVE=0&A002KEY=' ||
               A00201_.Menu_Id || '&key=&option=I';
    Button_ := '<input class="btn" type="button" value="新增" onclick="showtaburl(''' || Url_ ||
               ''',''' || A00201_.Tab_Name || '-新增'')"  />';
    Html_   := Button_;
    Return Html_;
  End;
  Function Getrbdouseable(Rb_Do_   Varchar2,
                          Status_  In Varchar2,
                          Menu_Id_ In Varchar2) Return Varchar2 Is
    Result Varchar2(20);
    Count_ Number;
  Begin
    If Status_ = '-' Then
    
      Return '1';
    End If;
    Select Count(*)
      Into Count_
      From A01401 t
     Where t.A014_Id = Rb_Do_
       And t.Status = Status_
       And t.Menu_Id = Menu_Id_;
    If Count_ > 0 Then
      Select t.Useable
        Into Result
        From A01401 t
       Where t.A014_Id = Rb_Do_
         And t.Status = Status_
         And t.Menu_Id = Menu_Id_;
    Else
      Select t.Useable
        Into Result
        From A01401 t
       Where t.A014_Id = Rb_Do_
         And t.Status = Status_
         And t.Menu_Id = 'DEFAULT';
    End If;
  
    Return Result;
  Exception
    When Others Then
      Return '1';
  End;
  Function Getrb_Execsql(Menu_Id_ Varchar2,
                         Line_No_ Number,
                         Key_     Varchar2,
                         User_Id_ Varchar2) Return Varchar2 Is
    e_Sql     Varchar2(10000);
    A00204_   A00204%Rowtype;
    Table_Id_ Varchar2(200);
    Mian_Key_ Varchar2(200);
    Pos1      Number;
    Col_      Varchar2(1000);
    Key__     Varchar2(1000);
    Key___    Varchar2(1000);
  Begin
    If Key_ = '[LIST]' Then
      Return '';
    End If;
    Select t.*
      Into A00204_
      From A00204 t
     Where t.Menu_Id = Menu_Id_
       And t.Line_No = Line_No_;
    --格式化key_      
  
    If Instr(Key_, ',') > 0 Then
      A00204_.Rb_Sql := Replace(A00204_.Rb_Sql, '[', '<');
      A00204_.Rb_Sql := Replace(A00204_.Rb_Sql, ']', '>');
      Key___         := Key_;
      Pos1           := Instr(Key___, ',');
      Loop
        Exit When Nvl(Pos1, 0) <= 0;
        Key__          := Substr(Key___, 1, Pos1 - 1);
        Key___         := Substr(Key___, Pos1 + 1);
        Col_           := Get_Search_Value(A00204_.Rb_Sql, '<', '>');
        A00204_.Rb_Sql := Replace(A00204_.Rb_Sql, '<' || Col_ || '>', Key__);
        Pos1           := Instr(Key___, ',');
      End Loop;
      A00204_.Rb_Sql := Replace(A00204_.Rb_Sql, '<', '[');
      A00204_.Rb_Sql := Replace(A00204_.Rb_Sql, '>', ']');
    
      Return A00204_.Rb_Sql;
    End If;
  
    --状态操作--
    If Substr(A00204_.Rb_Type, 1, 1) = 'A' Then
      Select t.Table_Id, t.Mian_Key
        Into Table_Id_, Mian_Key_
        From A002 t
       Where t.Menu_Id = Menu_Id_
         And Rownum = 1;
      A00204_.Rb_Sql := Replace(A00204_.Rb_Sql,
                                '[' || Mian_Key_ || ']',
                                Key_);
    
      --  procedure change_bill_status(table_id_ in varchar2,key_ in varchar2, rb_do_ in varchar , user_id_ varchar2 )
      e_Sql := 'pkg_a.change_bill_status( ''' || Table_Id_ || ''',''' || Key_ ||
               ''',''' || A00204_.Rb_Do || ''',''' || User_Id_ || ''',''' ||
               Mian_Key_ || ''',''' || Replace(A00204_.Rb_Sql, '''', '"') ||
               ''',[A311_KEY])';
    Else
      Select t.Table_Id, t.Mian_Key
        Into Table_Id_, Mian_Key_
        From A002 t
       Where t.Menu_Id = Menu_Id_
         And Rownum = 1;
      A00204_.Rb_Sql := Replace(A00204_.Rb_Sql,
                                '[' || Mian_Key_ || ']',
                                Key_);
      e_Sql          := Replace(e_Sql, 'begin ', '');
      e_Sql          := Replace(e_Sql, ' end;', '');
      e_Sql          := Replace(e_Sql, ' end', '');
      e_Sql          := A00204_.Rb_Sql;
    
    End If;
  
    Return e_Sql;
  End;

  /*获取菜单的功能键列表 html*/
  Function Geta00204(A00201_Key_ In Varchar2,
                     Key_        In Varchar2, --- 
                     User_Id_    In Varchar2, ---用户
                     If_Query    In Varchar2, ---是否是查询的界面
                     Option_     In Varchar2, ---执行的动作
                     Status_     In Varchar2 Default '-') Return Varchar2 Is
    Html_    Varchar2(4000);
    Button_  Varchar2(1000);
    A00201_  A00201_V01%Rowtype;
    Url_     Varchar2(4000);
    Cur_     t_Cursor;
    A00204_  A00204%Rowtype;
    Useable_ Varchar2(2000);
    Use_     Varchar2(20);
    Parm_    Varchar2(1000);
    Count_   Number;
  Begin
    Select t.*
      Into A00201_
      From A00201_V01 t
     Where t.A00201_Key = A00201_Key_;
    Html_ := '';
    --  http://localhost:8001//ShowForm/MainForm.aspx?A002KEY=1010&key=0&option=I
  
    If User_Id_ = 'ADMIN' Then
      Url_  := '[HTTP_URL]/Config/ModifyForm.aspx?A00201KEY=' ||
               A00201_.A00201_Key;
      Html_ := Html_ ||
               '<input class="btn" type="button" value="修改列宽" onclick="showurl(''' || Url_ ||
               ''',''_blank'')"  />';
    End If;
    /*明细只有添加行 和删除行*/
    If A00201_.If_Main = '0' Then
      If Option_ = 'I' Or Option_ = 'M' Then
      
        /*判断页面是否是主明细界面*/
        If Nvl(A00201_.Main_Table, '0') <> '0' Then
          If Option_ = 'M' Then
            --只有修改的界面才能添加明细
            Use_ := Get_A00201_Useable(A00201_Key_,
                                       User_Id_,
                                       'ADD_ROW',
                                       A00201_.Pkg_Name,
                                       Key_);
            If Use_ = '1' Then
              Html_ := Html_ || '<input class="btn" id="btn_addrow_' ||
                       A00201_.A00201_Key ||
                       '" type="button" value="添加行"   onclick ="AddRow(''' ||
                       A00201_.A00201_Key || ''')"/>';
            End If;
            Use_ := Get_A00201_Useable(A00201_Key_,
                                       User_Id_,
                                       'DEL_ROW',
                                       A00201_.Pkg_Name,
                                       Key_);
            If Use_ = '1' Then
              Html_ := Html_ || '<input class="btn" id="btn_delrow_' ||
                       A00201_.A00201_Key ||
                       '" type="button" value="删除行"   onclick ="DelRow(''' ||
                       A00201_.A00201_Key || ''')"/>';
            End If;
          End If;
        
        Else
        
          Html_ := Html_ ||
                   '<input class="btn"  id="btn_save" type="button" value="保存"  onclick ="update()"/>';
        
        End If;
      
      End If;
      If Key_ = '[LIST]' Then
        If Nvl(A00201_.Main_Table, '0') = '0' Then
          ---10tab
          Use_ := Get_A00201_Useable(A00201_Key_,
                                     User_Id_,
                                     'ADD_ROW',
                                     A00201_.Pkg_Name,
                                     Key_);
          If A00201_.Read_Only = '0' And Use_ = '1' And
             A00201_.Main_Table <> 'SQL' Then
            Html_ := Html_ || Getbuttonhtml(A00201_);
            Url_  := '[HTTP_URL]/ShowForm/MainForm.aspx?ISAVE=0&A002KEY=' ||
                     A00201_.Menu_Id || '&key=&option=I&A00201KEY=' ||
                     A00201_.A00201_Key;
            Html_ := '<input class="btn" type="button" value="新增" onclick="showtaburl(''' || Url_ ||
                     ''',''' || A00201_.Tab_Name || '-新增'')"  />';
          End If;
          Html_ := Html_ ||
                   '<input class="btn" type="button" value="导出" onclick="showxls(''' ||
                   A00201_Key_ || ''')"  />';
          If A00201_.Main_Table = 'SQL' Then
            Html_ := Html_ ||
                     '<input class="btn" type="button" value="设置列名" onclick="showa100(''' ||
                     A00201_Key_ || ''')"  />';
          Else
            If User_Id_ = 'ADMIN' Then
              Html_ := Html_ ||
                       '<input class="btn" type="button" value="设置权限" onclick="showa013(''' ||
                       A00201_Key_ || ''')"  />';
              Html_ := Html_ ||
                       '<input class="btn" type="button" value="修改列属性" onclick="showa100(''' ||
                       A00201_Key_ || ''')"  />';
            End If;
          End If;
        
        End If;
      End If;
    
    End If;
  
    If A00201_.If_Main = '1' Then
      If Key_ = '[LIST]' Then
        /*添加新增按钮
          根据菜单属性
        */
        Use_ := Get_A00201_Useable(A00201_.A00201_Key,
                                   User_Id_,
                                   'ADD_ROW',
                                   A00201_.Pkg_Name,
                                   Key_);
        If A00201_.Read_Only = '0' And Use_ = '1' And
           A00201_.Main_Table <> 'SQL' Then
          Html_ := Html_ || Getbuttonhtml(A00201_);
        End If;
        Html_ := Html_ ||
                 '<input class="btn" type="button" value="导出数据" onclick="showxls(''' ||
                 A00201_Key_ || ''')"  />';
        Open Cur_ For
          Select 1
            From A00701 t
           Inner Join A013 T1
              On T1.A013_Id = t.A013_Id
             And T1.Default_Flag = '1'
           Where t.A007_Id = User_Id_;
        Fetch Cur_
          Into Count_;
        If Cur_%Found Then
          If A00201_.Main_Table = 'SQL' Then
            Html_ := Html_ ||
                     '<input class="btn"  type="button" value="设置列名" onclick="showa100(''' ||
                     A00201_Key_ || ''')"  />';
          
          Else
            Html_ := Html_ ||
                     '<input class="btn" type="button" value="设置权限" onclick="showa013(''' ||
                     A00201_Key_ || ''')"  />';
            Html_ := Html_ ||
                     '<input class="btn" type="button" value="修改列属性" onclick="showa100(''' ||
                     A00201_Key_ || ''')"  />';
          
          End If;
        End If;
        Close Cur_;
        -- html_ := html_ || '<input type="button" value="设置权限" onclick="showa013(''' || a00201_key_ || ''')"  />' ;
      Else
        ----维护界面--
        If Option_ = 'I' Or Option_ = 'M' Then
          If Option_ = 'I' Then
            --新增主档
            Use_ := Get_A00201_Useable(A00201_.A00201_Key,
                                       User_Id_,
                                       'MOD_ROW',
                                       A00201_.Pkg_Name,
                                       Key_);
            If Use_ = '1' And A00201_.Main_Table <> 'SQL' Then
              Html_ := Html_ ||
                       '<input class="btn" id="btn_save" type="button" value="保存"  onclick ="update()"/>';
            End If;
          End If;
          If Option_ = 'M' Then
            --修改主明细
            Use_ := Get_A00201_Useable(A00201_.A00201_Key,
                                       User_Id_,
                                       'ADD_ROW',
                                       A00201_.Pkg_Name,
                                       Key_);
            If A00201_.Read_Only = '0' And Use_ = '1' And
               A00201_.Main_Table <> 'SQL' Then
              Html_ := Html_ || Getbuttonhtml(A00201_);
            End If;
            Use_ := Get_A00201_Useable(A00201_.A00201_Key,
                                       User_Id_,
                                       'MOD_ROW',
                                       A00201_.Pkg_Name,
                                       Key_);
            If Use_ = '1' Then
              Html_ := Html_ ||
                       '<input class="btn" id="btn_save" type="button" value="保存"  onclick ="update()"/>';
            End If;
          End If;
          Select Count(*)
            Into Count_
            From A00205 t
           Where t.Menu_Id = A00201_.Menu_Id;
          If Count_ > 0 Then
            Html_ := Html_ ||
                     '&nbsp;<input class="btn" id="btn_print" type="button" value="打印"  onclick ="creatrbdiv(''' ||
                     A00201_.A00201_Key || ''','''',''' ||
                     A00201_.A00201_Key || '_0'',''P'')"/>';
          End If;
          /*判断用户有没有当前单据的审批任务*/
        
        End If;
        If Option_ = 'I' Then
          ----如果是新增只有 保存
          Return Html_;
        
        End If;
        If Option_ = 'V' Or Option_ = 'M' Then
          Html_ := Html_ ||
                   Nvl(User_If_Have_A332(A00201_.Main_Table, Key_, User_Id_),
                       '');
        End If;
      
      End If;
      --<input id="Button2" type="button" value="保存"  onclick ="update()"/>
    
      Open Cur_ For
        Select t.*
          From A00204 t
         Where t.Menu_Id = A00201_.Menu_Id
           And 1 = 2
           And Rownum < 20;
      Fetch Cur_
        Into A00204_;
      Loop
        Exit When Cur_%Notfound;
      
        /*根据状态获取按钮是否能使用*/
        If Key_ = '[LIST]' Then
          /*判断是不是list的按钮*/
          --            useable_ := getrbdouseable(A00204_.Rb_Do,status_ ,A00204_.Menu_Id);             
          /*if (substr(A00204_.Rb_Type,1,1)='M')  then
             useable_  :=  get_rb_do_useable(a00204_.menu_id,user_id_,A00204_.Rb_Do) ;              
              if  useable_ ='1'  then
                  html_ := html_  || '<input class="btn" id="btn_' || A00204_.Rb_Do  ||'" type="button" value="'|| A00204_.Rb_Name ||'"  onclick ="do_proc('''|| key_  ||''','''|| A00204_.Menu_Id  ||''' ,'''|| A00204_.Line_No  ||''',this)"/>' ;
                  parm_ := nvl(parm_,'') || A00204_.Line_No || ',' ||  getparmlistbysql(A00204_.Rb_Sql)   || ';';
              end if ;    
          end if ;  
          */
          Useable_ := '0';
        Else
          If (Substr(A00204_.Rb_Type, 1, 1) <> 'M') Then
            If A00201_.Bill_Flag = '1' Then
              Useable_ := Getrbdouseable(A00204_.Rb_Do,
                                         Status_,
                                         A00204_.Menu_Id);
            Else
              Useable_ := '1';
            End If;
            If Useable_ = '1' Then
              Useable_ := Get_Rb_Do_Useable(A00204_.Menu_Id,
                                            User_Id_,
                                            A00204_.Rb_Do);
            End If;
            If Useable_ = '1' Then
              Html_ := Html_ || '<input class="btn" id="btn_' ||
                       A00204_.Rb_Do || '" type="button" value="' ||
                       A00204_.Rb_Name || '"  onclick ="do_proc(''' || Key_ ||
                       ''',''' || A00204_.Menu_Id || ''' ,''' ||
                       A00204_.Line_No || ''',this)"/>';
            Else
              Html_ := Html_ || '<input  class="btn" disabled id="btn_' ||
                       A00204_.Rb_Do || '" type="button" value="' ||
                       A00204_.Rb_Name || '"  onclick ="do_proc(''' || Key_ ||
                       ''',''' || A00204_.Menu_Id || ''' ,''' ||
                       A00204_.Line_No || ''',this)"/>';
            End If;
          End If;
        End If;
        Fetch Cur_
          Into A00204_;
      End Loop;
      Close Cur_;
    
    End If;
    --html_ := html_ || '<PARM>' ||  parm_  ||'</PARM>' ;
    Return Html_;
  End;

  Function Getshowdatacountsql(A00201_Key_ In Varchar2,
                               User_Id_    In Varchar2) Return Varchar2 Is
    A00201_   A00201_V01%Rowtype;
    Outsql_   Varchar2(4000);
    A10001_   A10001%Rowtype;
    Cur_      t_Cursor;
    Wheresql_ Varchar2(2000);
  Begin
  
    Select t.*
      Into A00201_
      From A00201_V01 t
     Where t.A00201_Key = A00201_Key_;
    If A00201_.Table_Id = 'SQL' Then
      A00201_.Condition := Replace(A00201_.Condition, '[USER_ID]', User_Id_);
      A00201_.Condition := Replace(A00201_.Condition,
                                   '[GETDATE()]',
                                   'sysdate');
      Return 'Select count(*) as c from (' || A00201_.Condition || ') tt where 1=1';
    
    End If;
    --如果有where
    A00201_.Condition := Nvl(A00201_.Condition, '');
    If Instr(Upper(Trim(A00201_.Condition)), 'WHERE') = 1 Then
      Wheresql_ := Nvl(A00201_.Condition, '');
    Else
      If Instr(Upper(Trim(A00201_.Condition)), 'AND') = 1 Then
        Wheresql_ := 'WHERE 1 = 1 ' || Nvl(A00201_.Condition, '');
      Else
        If Length(Nvl(A00201_.Condition, '')) > 5 Then
          Wheresql_ := 'WHERE ' || Nvl(A00201_.Condition, '');
        Else
          Wheresql_ := 'WHERE 1=1 ';
        End If;
      End If;
    End If;
    Wheresql_ := Replace(Wheresql_, '[USER_ID]', User_Id_);
    Wheresql_ := Replace(Wheresql_, '[GETDATE()]', 'sysdate');
  
    Outsql_ := 'Select ';
    /*根据a00201的表获取sql语句*/
  
    Outsql_ := Outsql_ || 'count(*) as c   From ' || A00201_.Table_Id ||
               ' t ' || Wheresql_;
  
    Return Outsql_;
  
  End;

  /*获取数据的sql语句*/
  Function Getshowdatasql(A00201_Key_ In Varchar2, User_Id_ In Varchar2)
    Return Varchar2 Is
    A00201_   A00201_V01%Rowtype;
    Outsql_   Varchar2(4000);
    A10001_   A10001%Rowtype;
    Cur_      t_Cursor;
    Wheresql_ Varchar2(2000);
  
  Begin
    Select t.*
      Into A00201_
      From A00201_V01 t
     Where t.A00201_Key = A00201_Key_;
    If A00201_.Table_Id = 'SQL' Then
      A00201_.Condition := Replace(A00201_.Condition, '[USER_ID]', User_Id_);
      A00201_.Condition := Replace(A00201_.Condition,
                                   '[GETDATE()]',
                                   'sysdate');
      Return A00201_.Condition;
    End If;
    --如果有where
    A00201_.Condition := Nvl(A00201_.Condition, '');
    If Instr(Upper(Trim(A00201_.Condition)), 'WHERE') = 1 Then
      Wheresql_ := Nvl(A00201_.Condition, '');
    Else
      If Instr(Upper(Trim(A00201_.Condition)), 'AND') = 1 Then
        Wheresql_ := 'WHERE 1 = 1 ' || Nvl(A00201_.Condition, '');
      Else
        If Length(Nvl(A00201_.Condition, '')) > 5 Then
          Wheresql_ := 'WHERE ' || Nvl(A00201_.Condition, '');
        Else
          Wheresql_ := 'WHERE 1=1 ';
        End If;
      End If;
    End If;
    Wheresql_ := Replace(Wheresql_, '[USER_ID]', User_Id_);
    Wheresql_ := Replace(Wheresql_, '[GETDATE()]', 'sysdate');
  
    Outsql_ := 'Select ';
    /*根据a00201的表获取sql语句*/
  
    -- 'rownum  as row_num,
    If A00201_.Tbl_Type = 'T' Then
      Outsql_ := Outsql_ || ' t.*,rowidtochar(t.rowid) as objid  From ' ||
                 A00201_.Table_Id || ' t ' || Wheresql_;
    Else
      Outsql_ := Outsql_ || ' t.*  From ' || A00201_.Table_Id || ' t ' ||
                 Wheresql_;
    End If;
  
    Return Outsql_;
  
  End;
  Function Getsysconfig(User_Id_ In Varchar2) Return Varchar2 Is
    Sql_   Varchar2(1000);
    Count_ Number;
  Begin
    /*    Select Count(*) Into Count_ From A001 t Where t.User_Id = User_Id_;
    If Count_ > 0 Then
      Sql_ := 'Select t.* from A001_V01 t where t.a007_id=''' || User_Id_ || '''';
    Else
      Sql_ := 'Select t.* from A001_V01 t where t.a007_id=''ADMIN''';
    
    End If;*/
    Sql_ := 'Select t.* from A001_V01 t where t.a007_id=''' || User_Id_ || '''';
  
    Return Sql_;
  
  End;
  /*数据的检测*/
  Procedure Checkdata(Data_ In Long, A0130101_ In Long, A311_Key In Number) Is
  Begin
  
    Return;
  End;
  Function Geta014use(A00201_Key_ In Varchar2,
                      A014_Id_    In Varchar2,
                      Objid_      In Varchar2,
                      User_Id_    In Varchar2) Return Varchar2 Is
    Cur_    t_Cursor;
    Result_ Varchar2(40);
    A014_   A014%Rowtype;
    A00201_ A00201_V01%Rowtype;
    A332_   A332%Rowtype;
    A33201_ A33201%Rowtype;
  Begin
    Select t.*
      Into A014_
      From A014 t
     Where t.A014_Id = A014_Id_
       And Rownum = 1;
    If A014_.If_First = '0' Or A014_.If_First = '1' Then
      If A014_.If_First = '1' Then
        --判断已经使用过--
        Open Cur_ For
          Select t.*
            From A332 t
           Where t.A331_Id = A014_Id_
             And t.Table_Id = A014_.Table_Id
             And t.Key_Id = Objid_;
        Fetch Cur_
          Into A332_;
        If Cur_%Found Then
          Close Cur_;
          If A332_.f_State <> '0' Then
            Return '0';
          End If;
          If A332_.State <> '0' Then
            Return '0';
          End If;
        
          Open Cur_ For
            Select t.*
              From A33201 t
             Where t.A332_Id = A332_.A332_Id
               And t.A007_Id = User_Id_;
          Fetch Cur_
            Into A33201_;
          If Cur_%Found Then
            Close Cur_;
            If A33201_.State <> '0' Then
              Return '0';
            Else
              Return '1';
            End If;
          Else
            Close Cur_;
          End If;
        
        Else
          Close Cur_;
        End If;
        If User_Id_ = 'ADMIN' Then
          Return '1';
        End If;
        --继续权限
        Open Cur_ For
          Select t.*
            From A01402 t
           Where t.A014_Id = A014_.A014_Id
             And t.A007_Id = User_Id_
             And Rownum = 1;
        If Cur_%Notfound Then
          Close Cur_;
          Return '0';
        End If;
        Close Cur_;
      
        --解析用户--
        A014_.User_Sql := Replace(A014_.User_Sql, '[ROWID]', Objid_);
        A014_.User_Sql := Replace(A014_.User_Sql,
                                  '[TABLE_ID]',
                                  A014_.Table_Id);
        A014_.User_Sql := Replace(A014_.User_Sql, '[USER_ID]', User_Id_);
        A014_.User_Sql := Replace(A014_.User_Sql,
                                  '[A014_ID]',
                                  A014_.A014_Id);
        A014_.User_Sql := 'Select a007_id from (' || A014_.User_Sql ||
                          ') t where a007_id=''' || User_Id_ || '''';
        Open Cur_ For A014_.User_Sql;
        Fetch Cur_
          Into Result_;
        If Cur_%Found Then
          Close Cur_;
          Return '1';
        End If;
        Close Cur_;
        Return '0';
      End If;
    
      Open Cur_ For
        Select t.A332_Id
          From A33201 t
         Inner Join A332 T1
            On T1.A332_Id = t.A332_Id
           And T1.A331_Id = A014_Id_
           And T1.Key_Id = Objid_
           And T1.f_State = '0'
           And t.State = '0'
         Where t.State = '0'
           And t.A007_Id = User_Id_;
      Fetch Cur_
        Into Result_;
      If Cur_%Found Then
        Close Cur_;
        Return Result_;
      End If;
      Close Cur_;
      Return '0';
    End If;
  
    ----单据状态操作--
    If A014_.If_First = '3' Then
      Select t.*
        Into A00201_
        From A00201_V01 t
       Where t.A00201_Key = A00201_Key_;
      If Length(Nvl(A014_.User_Sql, '')) < 10 Then
        A014_.User_Sql := 'Select ''' || User_Id_ ||
                          ''' as a007_id from dual ';
      End If;
      A014_.User_Sql := Replace(A014_.User_Sql, '[ROWID]', Objid_);
      A014_.User_Sql := Replace(A014_.User_Sql,
                                '[TABLE_ID]',
                                A00201_.Table_Id);
      A014_.User_Sql := Replace(A014_.User_Sql, '[USER_ID]', User_Id_);
      A014_.User_Sql := Replace(A014_.User_Sql, '[A014_ID]', A014_.A014_Id);
      A014_.User_Sql := 'Select a007_id from (' || A014_.User_Sql ||
                        ') t where a007_id=''' || User_Id_ || '''';
      Open Cur_ For A014_.User_Sql;
      Fetch Cur_
        Into Result_;
      If Cur_%Found Then
        Close Cur_;
        Return '1';
      End If;
      Close Cur_;
      Return '0';
    End If;
    ----纯处理--
  
    If Length(Nvl(A014_.User_Sql, '')) < 10 Then
      A014_.User_Sql := 'Select ''' || User_Id_ ||
                        ''' as a007_id from dual ';
    End If;
    A014_.User_Sql := Replace(A014_.User_Sql, '[ROWID]', Objid_);
    A014_.User_Sql := Replace(A014_.User_Sql, '[TABLE_ID]', A014_.Table_Id);
    A014_.User_Sql := Replace(A014_.User_Sql, '[USER_ID]', User_Id_);
    A014_.User_Sql := Replace(A014_.User_Sql, '[A014_ID]', A014_.A014_Id);
    A014_.User_Sql := 'Select a007_id from (' || A014_.User_Sql ||
                      ') t where a007_id=''' || User_Id_ || '''';
    Open Cur_ For A014_.User_Sql;
    Fetch Cur_
      Into Result_;
    If Cur_%Notfound Then
      Close Cur_;
      Return '0';
    End If;
    Close Cur_;
    Open Cur_ For
      Select t.A007_Id
        From A01402 t
       Where t.A014_Id = A014_.A014_Id
         And t.A007_Id = User_Id_;
    Fetch Cur_
      Into Result_;
    If Cur_%Notfound Then
      Close Cur_;
      Return '0';
    End If;
    Close Cur_;
  
    Return '1';
  
  Exception
    When Others Then
      Return '0';
  End;
  /*根据数据来检测是否可以编辑*/
  Function Getoption(Menu_Id_ In Varchar2,
                     Status_  In Varchar,
                     Option_  In Varchar2,
                     User_Id_ In Varchar2) Return Varchar2 Is
    Readonly_ Varchar2(200);
    Count_    Varchar2(200);
    Use_      Varchar2(20);
    A002_     A002%Rowtype;
  Begin
    Select t.*
      Into A002_
      From A002 t
     Where t.Menu_Id = Menu_Id_
       And Rownum = 1;
    If A002_.Bill_Flag <> '1' Then
    
      Return Option_;
    End If;
  
    If Status_ = '-' Then
      Return Option_;
    End If;
    If Option_ = 'I' Then
      Return 'I';
    End If;
    Readonly_ := '0';
    If Option_ = 'M' Then
      Select Count(*)
        Into Count_
        From A024 t
       Where t.A024_Id = Menu_Id_ || '_' || Status_;
      If Count_ = 0 Then
        Select t.Readonly
          Into Readonly_
          From A024 t
         Where t.A024_Id = 'DEFAULT_' || Status_
           And Rownum = 1;
      Else
        Select t.Readonly
          Into Readonly_
          From A024 t
         Where t.A024_Id = Menu_Id_ || '_' || Status_
           And Rownum = 1;
      End If;
      If Readonly_ = '1' Then
        Return 'V';
      End If;
      /**/
      --    Select t.*          from 
      Use_ := Get_A00201_Useable(Menu_Id_ || '-0',
                                 User_Id_,
                                 'MOD_ROW',
                                 '',
                                 '');
      If Use_ = '0' Then
        Return 'V';
      
      End If;
    
      Return 'M';
    
    End If;
    /*判断用户有没有修改当前菜单的权限*/
  
  End;
  -- Initialization
  Function Get_Search_Value(Data_   In Varchar2,
                            Index1_ In Varchar2,
                            Index2_ In Varchar2) Return Varchar2 Is
    Pos1_  Number;
    Pos2_  Number;
    Right_ Varchar2(4000);
  Begin
    If Index1_ Is Null Or Index1_ = '' Then
      Pos2_ := Instr(Data_, Index2_);
      If Nvl(Pos2_, 0) <= 0 Then
        Return '';
      End If;
      Return Trim(Substr(Data_, 1, Pos2_ - 1));
    End If;
    If Index2_ Is Null Or Index2_ = '' Then
      Pos1_ := Instr(Data_, Index1_);
      If Nvl(Pos1_, 0) <= 0 Then
        Return '';
      End If;
      Right_ := Substr(Data_, Pos1_ + Length(Index1_));
      Return Right_;
    End If;
  
    Pos1_ := Instr(Data_, Index1_);
    If Nvl(Pos1_, 0) <= 0 Then
      Return '';
    End If;
    Right_ := Substr(Data_, Pos1_ + Length(Index1_));
    Pos2_  := Instr(Right_, Index2_);
    If Nvl(Pos2_, 0) <= 0 Then
      Return '';
    End If;
  
    Return Trim(Substr(Right_, 1, Pos2_ - 1));
  End Get_Search_Value;
  Function Get_A10001_Line_No(Table_Id_  In Varchar2,
                              Column_Id_ In Varchar2) Return Varchar2 Is
    Result       Varchar2(50);
    Main_Table_  Varchar2(150);
    Main_Column_ Varchar2(150);
  Begin
    If Instr(Column_Id_, 'MAIN_') = 1 Then
      ----
      Main_Column_ := Substr(Column_Id_, 6);
      Select t.Main_Table
        Into Main_Table_
        From A00201_V01 t
       Where t.Table_Id = Table_Id_
         And t.Main_Table <> Table_Id_
         And t.Main_Table Is Not Null
         And Rownum = 1;
    
      Select t.Line_No
        Into Result
        From A10001 t
       Where t.Table_Id = Main_Table_
         And t.Column_Id = Main_Column_
         And Rownum = 1;
    
      Return 'MAIN_' || Result;
    End If;
    Select t.Line_No
      Into Result
      From A10001 t
     Where t.Table_Id = Table_Id_
       And t.Column_Id = Column_Id_
       And Rownum = 1;
    Return Result;
  
  Exception
    When Others Then
      Return '0';
  End;
  Function Get_A00201_Useable(A00201_Key_ In Varchar2,
                              User_Id_    In Varchar2,
                              Type_       In Varchar2,
                              Pkg_Name_   In Varchar2,
                              Key_        In Varchar2) Return Varchar2 Is
    Result  Varchar2(20);
    Sql_    Varchar2(2000);
    Cur_    t_Cursor;
    Count_  Number;
    A00201_ A00201_V01%Rowtype;
  Begin
    Result := '0';
    Select t.*
      Into A00201_
      From A00201_V01 t
     Where t.A00201_Key = A00201_Key_;
    If Type_ = 'ADD_ROW' Then
      Select Count(*)
        Into Count_
        From A0130101 t
       Where t.A002_Id = A00201_.Menu_Id
         And t.A00201_Line = A00201_.Line_No
         And t.A013_Id In
             (Select T1.A013_Id From A00701 T1 Where T1.A007_Id = User_Id_)
         And t.Add_Row = '1'
         And t.Useable = '1';
    End If;
    If Type_ = 'DEL_ROW' Then
      Select Count(*)
        Into Count_
        From A0130101 t
       Where t.A002_Id = A00201_.Menu_Id
         And t.A00201_Line = A00201_.Line_No
         And t.A013_Id In
             (Select T1.A013_Id From A00701 T1 Where T1.A007_Id = User_Id_)
         And t.Del_Row = '1'
         And t.Useable = '1';
    End If;
    If Type_ = 'MOD_ROW' Then
      Select Count(*)
        Into Count_
        From A0130101 t
       Where t.A002_Id = A00201_.Menu_Id
         And t.Control_Id = A00201_.Control_Id
         And t.A013_Id In
             (Select T1.A013_Id From A00701 T1 Where T1.A007_Id = User_Id_)
         And t.Mod_Row = '1'
         And t.Useable = '1';
    End If;
  
    If Count_ > 0 Then
      Result := '1';
    Else
      Result := '0';
    End If;
    If Result = '1' And Length(Pkg_Name_) > 0 Then
      Sql_ := 'Select ' || Pkg_Name_ || '.CheckButton__(''' || Type_ ||
              ''',''' || Key_ || ''',''' || User_Id_ ||
              ''') as c from dual';
      Open Cur_ For Sql_;
      Fetch Cur_
        Into Result;
      Close Cur_;
    End If;
    Return Nvl(Result, '0');
  Exception
    When Others Then
      Return Result;
  End;
  /*检测用户对功能的权限 */
  Function Get_Rb_Do_Useable(Menu_Id_ In Varchar2,
                             User_Id_ In Varchar2,
                             Rb_      In Varchar2) Return Varchar2 Is
    Result Varchar2(20);
    Count_ Number;
  Begin
    Select Count(*)
      Into Count_
      From A01301 t
     Where t.A002_Id = Menu_Id_
       And t.A013_Id In
           (Select T1.A013_Id From A00701 T1 Where T1.A007_Id = User_Id_)
       And t.Rb_Do = Rb_
       And t.Useable = '1';
    If Count_ > 0 Then
      Result := '1';
    Else
      Result := '0';
    End If;
    Return Result;
  
  Exception
    When Others Then
      Return '0';
  End;
  /*获取sql中得参数*/
  Function Getparmlistbysql(Sql_ In Varchar2) Return Varchar2 Is
    Result Varchar2(500);
    Sql__  Varchar2(500);
    Col_   Varchar2(50);
  Begin
    Result := '';
    Sql__  := Sql_;
    Col_   := Get_Search_Value(Sql_, '[', ']');
  
    Loop
      Exit When Col_ Is Null Or Length(Col_) = '';
      Result := Result || '[' || Col_ || '],';
      Sql__  := Replace(Sql__, '[' || Col_ || ']', '');
      Col_   := Get_Search_Value(Sql__, '[', ']');
    End Loop;
  
    Return Result;
  End;
  ---把列转换为line_no
  Function Format_Sql_c_Line(Table_Id_ In Varchar2, Sql_ In Varchar)
    Return Varchar2 Is
    Sql__     Varchar2(2000);
    This_Col_ Varchar2(200);
  Begin
    Sql__ := Sql_;
    Sql__ := Replace(Sql__, '[USER_ID]', '{USER_ID}');
    Sql__ := Replace(Sql__, '[menu_id]', '{MENU_ID}');
    Sql__ := Replace(Sql__, '[MENU_ID]', '{MENU_ID}');
    Sql__ := Replace(Sql__, '[user_id]', '{USER_ID}');
  
    This_Col_ := Pkg_Show.Get_Search_Value(Sql__, '[', ']');
  
    Loop
      Exit When This_Col_ Is Null Or Length(This_Col_) = '';
      Sql__     := Replace(Sql__,
                           '[' || This_Col_ || ']',
                           '{' ||
                           Get_A10001_Line_No(Table_Id_, Upper(This_Col_)) || '}');
      This_Col_ := Pkg_Show.Get_Search_Value(Sql__, '[', ']');
    End Loop;
    Sql__ := Replace(Replace(Sql__, '{', '['), '}', ']');
  
    Return Sql__;
  End;
  /*检测审批*/
  Function User_If_Have_A332(Table_Id_ In Varchar2,
                             Key_      In Varchar2,
                             User_Id_  In Varchar2) Return Varchar2 Is
    A332_    A332%Rowtype;
    A332_Cur t_Cursor;
    Result_  Varchar2(10);
    Html_    Varchar2(2000);
  Begin
    Return '';
    Open A332_Cur For
      Select t.*
        From A332 t
       Inner Join A33201 T1
          On t.A332_Id = T1.A332_Id
         And t.A33101_Line = T1.A33101_Line
         And T1.State = '0'
         And T1.A007_Id = User_Id_
       Where t.Table_Id = Table_Id_
         And (t.Key_Id = Key_ Or t.A332_Name = Key_)
         And t.State = '0'; --审批未关闭
    Fetch A332_Cur
      Into A332_;
    Html_ := '';
    Loop
      Exit When A332_Cur%Notfound;
      If A332_.Do_Type = 'A330' Then
        Html_ := Html_ ||
                 '<input class="btn" id="btn_sp0" type="button" value="审批通过"  onclick ="bill_sp(this,''' ||
                 Table_Id_ || ''',' || A332_.A332_Id || ',0)"/>';
        Html_ := Html_ ||
                 '<input class="btn" id="btn_sp1" type="button" value="审批不通过"  onclick ="bill_sp(this,''' ||
                 Table_Id_ || ''',' || A332_.A332_Id || ',1)"/>';
      Else
        Html_ := Html_ ||
                 '<input class="btn" id="btn_sp0" type="button" value="' ||
                 A332_.A331_Name || '"  onclick ="bill_do(this,''' ||
                 Table_Id_ || ''',' || A332_.A332_Id || ')"/>';
      End If;
      Fetch A332_Cur
        Into A332_;
    End Loop;
    Close A332_Cur;
  
    Return To_Char(Html_);
  Exception
    When Others Then
      Return '';
    
  End;

End Pkg_Show;
/
