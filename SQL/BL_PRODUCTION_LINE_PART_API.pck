CREATE OR REPLACE PACKAGE BL_PRODUCTION_LINE_PART_API IS
  /* Created By LD  2013-03-19 16:37:15*/
  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2);

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE Modify__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2);
  /*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
  PROCEDURE Itemchange__(Column_Id_   VARCHAR2,
                         Mainrowlist_ VARCHAR2,
                         Rowlist_     VARCHAR2,
                         User_Id_     VARCHAR2,
                         Outrowlist_  OUT VARCHAR2);
  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  FUNCTION Checkbutton__(Dotype_  IN VARCHAR2,
                         KEY_     IN VARCHAR2,
                         User_Id_ IN VARCHAR2) RETURN VARCHAR2;

  /*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
  */
  FUNCTION Checkuseable(Doaction_  IN VARCHAR2,
                        Column_Id_ IN VARCHAR,
                        Rowlist_   IN VARCHAR2) RETURN VARCHAR2;

END BL_PRODUCTION_LINE_PART_API;
/
CREATE OR REPLACE PACKAGE BODY BL_PRODUCTION_LINE_PART_API IS
  /* Created By LD  2013-03-19 16:37:15*/
  TYPE t_Cursor IS REF CURSOR;
  --【COLUMN】  列名称 按实际的逻辑 用实际的列名
  -- 【VALUE】  列的数据 按具体的实际逻辑 用对应的参数来替代
  /*
  报错
  Raise_Application_Error(pkg_a.raise_error,'出错了 ！！！！！');
  */

  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2) IS
    attr_out    VARCHAR2(4000);
    info_       VARCHAR2(4000);
    objid_      VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    attr_       VARCHAR2(4000);
    action_     VARCHAR2(4000);
    CUR_        T_CURSOR;
    MAINROW_    BL_V_PRODUCTION_LINE%ROWTYPE;
  BEGIN
    attr_out          := '';
    MAINROW_.LINE_KEY := PKG_A.Get_Item_Value('LINE_KEY', ROWLIST_);
    Action_           := 'PREPARE';
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_PRODUCTION_LINE T
       WHERE T.LINE_KEY = MAINROW_.LINE_KEY;
    FETCH CUR_
      INTO MAINROW_;
    CLOSE CUR_;
  
    IFSAPP.PRODUCTION_LINE_PART_API.NEW__(info_,
                                          objid_,
                                          objversion_,
                                          attr_,
                                          action_);
    attr_out := PKG_A.Get_Attr_By_Ifs(attr_);
    PKG_A.Set_Item_Value('CONTRACT', MAINROW_.CONTRACT, attr_out);
    PKG_A.Set_Item_Value('PRODUCTION_LINE',
                         MAINROW_.PRODUCTION_LINE,
                         attr_out);
    -- pkg_a.Set_Item_Value('【COLUMN】','【VALUE】', attr_out);
    pkg_a.Setresult(A311_Key_, attr_out);
  END;

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE Modify__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2) IS
    Objid_      VARCHAR2(50);
    Index_      VARCHAR2(1);
    Cur_        t_Cursor;
    Doaction_   VARCHAR2(10);
    Pos_        Number;
    Pos1_       Number;
    i           Number;
    v_          Varchar(1000);
    Column_Id_  Varchar(1000);
    Data_       Varchar(4000);
    Mysql_      Varchar(4000);
    Ifmychange  Varchar(1);
    info_       VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    attr_       VARCHAR2(4000);
    action_     VARCHAR2(4000);
    row_        BL_V_PRODUCTION_LINE_PART%rowtype;
  BEGIN
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ = 'I' THEN
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      -- pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
      /*
      --描述
      row_.PART_DESCRIPTION  := Pkg_a.Get_Item_Value('PART_DESCRIPTION', Rowlist_)
      --域
      row_.CONTRACT  := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_)
      --零件号
      row_.PART_NO  := Pkg_a.Get_Item_Value('PART_NO', Rowlist_)
      --PRODUCTION_LINE
      row_.PRODUCTION_LINE  := Pkg_a.Get_Item_Value('PRODUCTION_LINE', Rowlist_)
      --最后活动日期
      row_.LAST_ACTIVITY_DATE  := Pkg_a.Get_Item_Value('LAST_ACTIVITY_DATE', Rowlist_)
      --计划百分比
      row_.SCHEDULE_PERCENTAGE  := Pkg_a.Get_Item_Value('SCHEDULE_PERCENTAGE', Rowlist_)
      --范围标示号
      row_.HORIZON_ID  := Pkg_a.Get_Item_Value('HORIZON_ID', Rowlist_)
      --计划百分比
      row_.SCHEDULE_FRACTION  := Pkg_a.Get_Item_Value('SCHEDULE_FRACTION', Rowlist_)
      --计划的分数
      row_.SCHEDULE_FRACTION_DB  := Pkg_a.Get_Item_Value('SCHEDULE_FRACTION_DB', Rowlist_)
      --DEFER_BACKFLUSH
      row_.DEFER_BACKFLUSH  := Pkg_a.Get_Item_Value('DEFER_BACKFLUSH', Rowlist_)
      --计划的延迟反冲
      row_.DEFER_BACKFLUSH_DB  := Pkg_a.Get_Item_Value('DEFER_BACKFLUSH_DB', Rowlist_)
      --LINE_KEY
      row_.LINE_KEY  := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_)*/
      --'PRODUCTION_LINE35003PART_NO91000303CONTRACT35SCHEDULE_PERCENTAGE100SCHEDULE_FRACTION
      --不允许的部分DEFER_BACKFLUSH推迟倒冲LAST_ACTIVITY_DATE2013-03-20-00.00.00'
      client_sys.Add_To_Attr('PRODUCTION_LINE',
                             PKG_A.Get_Item_Value('PRODUCTION_LINE',
                                                  ROWLIST_),
                             ATTR_);
      client_sys.Add_To_Attr('PART_NO',
                             PKG_A.Get_Item_Value('PART_NO', ROWLIST_),
                             ATTR_);
      client_sys.Add_To_Attr('CONTRACT',
                             PKG_A.Get_Item_Value('CONTRACT', ROWLIST_),
                             ATTR_);
      client_sys.Add_To_Attr('SCHEDULE_PERCENTAGE',
                             PKG_A.Get_Item_Value('SCHEDULE_PERCENTAGE',
                                                  ROWLIST_),
                             ATTR_);
      client_sys.Add_To_Attr('SCHEDULE_FRACTION',
                             PKG_A.Get_Item_Value('SCHEDULE_FRACTION',
                                                  ROWLIST_),
                             ATTR_);
      client_sys.Add_To_Attr('DEFER_BACKFLUSH',
                             PKG_A.Get_Item_Value('DEFER_BACKFLUSH',
                                                  ROWLIST_),
                             ATTR_);
      client_sys.Add_To_Attr('LAST_ACTIVITY_DATE',
                             PKG_A.Get_Item_Value('LAST_ACTIVITY_DATE',
                                                  ROWLIST_),
                             ATTR_);
      Action_ := 'DO';
    
      IFSAPP.PRODUCTION_LINE_PART_API.NEW__(info_,
                                            objid_,
                                            objversion_,
                                            attr_,
                                            action_);
      pkg_a.Setsuccess(A311_Key_, 'BL_V_PRODUCTION_LINE_PART', Objid_);
    END IF;
    --修改
    IF Doaction_ = 'M' THEN
    
      Open Cur_ For
        Select t.* From BL_V_PRODUCTION_LINE_PART t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        CLOSE CUR_;
        Raise_Application_Error(Pkg_a.Raise_Error, '错误的rowid！');
        RETURN;
      End If;
      Close Cur_;
      Data_ := Rowlist_;
      Pos_  := Instr(Data_, Index_);
      i     := i + 1;
      --     Mysql_     :='update BL_V_PRODUCTION_LINE_PART SET ';
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
          Ifmychange := '1';
          v_         := Substr(v_, Pos1_ + 1);
          --         Mysql_     := Mysql_ || Column_Id_ || '='''|| v_ ||''',';
          CLIENT_SYS.Add_To_Attr(Column_Id_, V_, ATTR_);
        End If;
      End Loop;
    
      /*      --如果存在修改--
      If Ifmychange ='1' Then 
         Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User ='''|| User_Id_ ||''''; 
         Mysql_ := Mysql_ || 'Where Rowid ='''|| Objid_ ||'''';
      -- raise_application_error(Pkg_a.Raise_Error, mysql_);
         Execute Immediate Mysql_;
      End If;*/
      ACTION_ := 'DO';
      PRODUCTION_LINE_PART_API.MODIFY__(info_,
                                        ROW_.OBJID,
                                        ROW_.OBJVERSION,
                                        attr_,
                                        action_);
      --设置成功的标志
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PRODUCTION_LINE_PART', Objid_);
      Return;
    End If;
    --删除
    If Doaction_ = 'D' Then
      OPEN CUR_ FOR
        SELECT T.* FROM BL_V_PRODUCTION_LINE_PART T WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error, '错误的rowid');
        return;
      end if;
      close cur_;
      Action_ := 'CHECK';
      IFSAPP.PRODUCTION_LINE_PART_API.REMOVE__(info_,
                                               ROW_.OBJID,
                                               ROW_.OBJVERSION,
                                               action_);
      Action_ := 'DO';
      IFSAPP.PRODUCTION_LINE_PART_API.REMOVE__(info_,
                                               ROW_.OBJID,
                                               ROW_.OBJVERSION,
                                               action_);
      --      DELETE FROM BL_V_PRODUCTION_LINE_PART T WHERE T.ROWID = OBJID_; 
      --设置成功的标志
      --pkg_a.Setsuccess(A311_Key_,'BL_V_PRODUCTION_LINE_PART', Objid_);
      Return;
    End If;
  
  End;
  /*    列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2) Is
    Attr_Out Varchar2(4000);
    MAINROW_ BL_V_PRODUCTION_LINE%rowtype;
    row_     BL_V_PRODUCTION_LINE_PART%rowtype;
    prow_    INVENTORY_PART_PROD_LINE_LOV%rowtype;
    cur_     t_cursor;
  Begin
    MAINROW_.CONTRACT := PKG_A.Get_Item_Value('CONTRACT', MAINROWLIST_);
    ROW_.PART_NO      := PKG_A.Get_Item_Value('PART_NO', ROWLIST_);
    open cur_ for
      select t.*
        from INVENTORY_PART_PROD_LINE_LOV t
       WHERE T.contract = MAINROW_.CONTRACT
         AND T.part_no = ROW_.PART_NO;
    FETCH CUR_
      INTO prow_;
    IF CUR_ %NOTFOUND THEN
      CLOSE CUR_;
      RAISE_APPLICATION_ERROR(-20101, '错误的零件号');
      RETURN;
    END IF;
    CLOSE CUR_;
    PKG_A.Set_Item_Value('PART_DESCRIPTION', PROW_.description, ATTR_OUT);
    If Column_Id_ = '' Then
      --给列赋值
      Pkg_a.Set_Item_Value('【COLUMN】', '【VALUE】', Attr_Out);
      --设置列不可用
      Pkg_a.Set_Column_Enable('【COLUMN】', '0', Attr_Out);
      --设置列可用
      Pkg_a.Set_Column_Enable('【COLUMN】', '1', Attr_Out);
      --设置添加行按钮不可用
      --pkg_a.Set_Addrow_Enable('0',Attr_Out);
      --设置删除行按钮不可用
      --pkg_a.Set_Delrow_Enable('0',Attr_Out);
    End If;
    Outrowlist_ := Attr_Out;
  End;
  /*  列发生变化的时候
        Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
        KEY_ 主档的主键值
        User_Id_  当前用户
  */
  Function Checkbutton__(Dotype_  In Varchar2,
                         Key_     In Varchar2,
                         User_Id_ In Varchar2) Return Varchar2 Is
    row_ BL_V_PRODUCTION_LINE_PART%rowtype;
  Begin
    If Dotype_ = 'Add_Row' Then
      Return '1';
    End If;
    If Dotype_ = 'Del_Row' Then
      Return '1';
    End If;
    Return '1';
  End;

  /*  实现业务逻辑控制列的 编辑性
    Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
    Column_Id_  列
    Rowlist_  当前行的数据
    返回: 1 可用
    0 不可用
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    row_ BL_V_PRODUCTION_LINE_PART%rowtype;
  Begin
    ROW_.OBJID := PKG_A.Get_Item_Value('OBJID', ROWLIST_);
    if nvl(ROW_.OBJID, 'NULL') <> 'NULL' THEN
      IF COLUMN_ID_ = 'LAST_ACTIVITY_DATE' THEN
        RETURN '1';
      ELSE
        RETURN '0';
      END IF;
    END IF;
    If Column_Id_ = '【COLUMN】' Then
      Return '0';
    End If;
    Return '1';
  End;

End BL_PRODUCTION_LINE_PART_API;
/
