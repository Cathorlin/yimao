CREATE OR REPLACE PACKAGE BL_PART_CATALOG_API IS
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

END BL_PART_CATALOG_API;
/
CREATE OR REPLACE PACKAGE BODY BL_PART_CATALOG_API IS
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
  BEGIN
    attr_out := '';
    Action_  := 'PREPARE';
    IFSAPP.PART_CATALOG_API.NEW__(info_,
                                  objid_,
                                  objversion_,
                                  attr_,
                                  action_);
    attr_out := PKG_A.Get_Attr_By_Ifs(attr_);
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
    info_       VARCHAR2(4000);
    objid_      VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    attr_       VARCHAR2(4000);
    attr__      VARCHAR2(4000);
    action_     VARCHAR2(4000);
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
    row_        BL_V_PART_CATALOG%rowtype;
  BEGIN
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ = 'I' THEN
      Action_ := 'CHECK';
      CLIENT_SYS.Add_To_Attr('PART_NO',
                             PKG_A.Get_Item_Value('PART_NO', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('DESCRIPTION',
                             PKG_A.Get_Item_Value('DESCRIPTION', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('SERIAL_TRACKING_CODE_DB',
                             PKG_A.Get_Item_Value('SERIAL_TRACKING_CODE_DB',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('SERIAL_RULE',
                             PKG_A.Get_Item_Value('SERIAL_RULE', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('ENG_SERIAL_TRACKING_CODE_DB',
                             PKG_A.Get_Item_Value('ENG_SERIAL_TRACKING_CODE_DB',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('LOT_TRACKING_CODE',
                             PKG_A.Get_Item_Value('LOT_TRACKING_CODE',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('CONFIGURABLE_DB',
                             PKG_A.Get_Item_Value('CONFIGURABLE_DB',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('CONDITION_CODE_USAGE_DB',
                             PKG_A.Get_Item_Value('CONDITION_CODE_USAGE_DB',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('POSITION_PART_DB',
                             PKG_A.Get_Item_Value('POSITION_PART_DB',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('UNIT_CODE',
                             PKG_A.Get_Item_Value('UNIT_CODE', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('STD_NAME_ID',
                             PKG_A.Get_Item_Value('STD_NAME_ID', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('LOT_QUANTITY_RULE',
                             PKG_A.Get_Item_Value('LOT_QUANTITY_RULE',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('SUB_LOT_RULE',
                             PKG_A.Get_Item_Value('SUB_LOT_RULE', ROWLIST_),
                             attr_);
      attr__ := attr_;
      IFSAPP.PART_CATALOG_API.NEW__(info_,
                                    objid_,
                                    objversion_,
                                    attr_,
                                    action_);
    
      Action_ := 'DO';
      IFSAPP.PART_CATALOG_API.NEW__(info_,
                                    objid_,
                                    objversion_,
                                    attr__,
                                    action_);
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      /*
      PART_NO45654846531DESCRIPTION56161596415SERIAL_TRACKING_CODE_DBNOT SERIAL TRACKINGSERIAL_RULE
      人工ENG_SERIAL_TRACKING_CODE_DBNOT SERIAL TRACKINGLOT_TRACKING_CODE无批跟踪CONFIGURABLE_DB
      NOT CONFIGUREDCONDITION_CODE_USAGE_DBNOT_ALLOW_COND_CODEPOSITION_PART_DBNOT POSITION PARTUNIT_CODEpcs
      STD_NAME_ID0LOT_QUANTITY_RULE每个订单一个批量SUB_LOT_RULE不允许子项批次
      --零件号
      row_.PART_NO  := Pkg_a.Get_Item_Value('PART_NO', Rowlist_)
      --描述
      row_.DESCRIPTION  := Pkg_a.Get_Item_Value('DESCRIPTION', Rowlist_)
      --信息文本
      row_.INFO_TEXT  := Pkg_a.Get_Item_Value('INFO_TEXT', Rowlist_)
      --标准名称标示
      row_.STD_NAME_ID  := Pkg_a.Get_Item_Value('STD_NAME_ID', Rowlist_)
      --单位代码
      row_.UNIT_CODE  := Pkg_a.Get_Item_Value('UNIT_CODE', Rowlist_)
      --LU_NAME
      row_.LU_NAME  := Pkg_a.Get_Item_Value('LU_NAME', Rowlist_)
      --KEY_REF
      row_.KEY_REF  := Pkg_a.Get_Item_Value('KEY_REF', Rowlist_)
      --LOT_TRACKING_CODE
      row_.LOT_TRACKING_CODE  := Pkg_a.Get_Item_Value('LOT_TRACKING_CODE', Rowlist_)
      --批跟踪
      row_.LOT_TRACKING_CODE_DB  := Pkg_a.Get_Item_Value('LOT_TRACKING_CODE_DB', Rowlist_)
      --SERIAL_RULE
      row_.SERIAL_RULE  := Pkg_a.Get_Item_Value('SERIAL_RULE', Rowlist_)
      --序列准则
      row_.SERIAL_RULE_DB  := Pkg_a.Get_Item_Value('SERIAL_RULE_DB', Rowlist_)
      --SERIAL_TRACKING_CODE
      row_.SERIAL_TRACKING_CODE  := Pkg_a.Get_Item_Value('SERIAL_TRACKING_CODE', Rowlist_)
      --库存序列跟踪
      row_.SERIAL_TRACKING_CODE_DB  := Pkg_a.Get_Item_Value('SERIAL_TRACKING_CODE_DB', Rowlist_)
      --ENG_SERIAL_TRACKING_CODE
      row_.ENG_SERIAL_TRACKING_CODE  := Pkg_a.Get_Item_Value('ENG_SERIAL_TRACKING_CODE', Rowlist_)
      --交货后序列跟踪
      row_.ENG_SERIAL_TRACKING_CODE_DB  := Pkg_a.Get_Item_Value('ENG_SERIAL_TRACKING_CODE_DB', Rowlist_)
      --零件主要组
      row_.PART_MAIN_GROUP  := Pkg_a.Get_Item_Value('PART_MAIN_GROUP', Rowlist_)
      --CONFIGURABLE
      row_.CONFIGURABLE  := Pkg_a.Get_Item_Value('CONFIGURABLE', Rowlist_)
      --配置
      row_.CONFIGURABLE_DB  := Pkg_a.Get_Item_Value('CONFIGURABLE_DB', Rowlist_)
      --CUST_WARRANTY_ID
      row_.CUST_WARRANTY_ID  := Pkg_a.Get_Item_Value('CUST_WARRANTY_ID', Rowlist_)
      --SUP_WARRANTY_ID
      row_.SUP_WARRANTY_ID  := Pkg_a.Get_Item_Value('SUP_WARRANTY_ID', Rowlist_)
      --CONDITION_CODE_USAGE
      row_.CONDITION_CODE_USAGE  := Pkg_a.Get_Item_Value('CONDITION_CODE_USAGE', Rowlist_)
      --条件代码
      row_.CONDITION_CODE_USAGE_DB  := Pkg_a.Get_Item_Value('CONDITION_CODE_USAGE_DB', Rowlist_)
      --SUB_LOT_RULE
      row_.SUB_LOT_RULE  := Pkg_a.Get_Item_Value('SUB_LOT_RULE', Rowlist_)
      --子批次规则
      row_.SUB_LOT_RULE_DB  := Pkg_a.Get_Item_Value('SUB_LOT_RULE_DB', Rowlist_)
      --LOT_QUANTITY_RULE
      row_.LOT_QUANTITY_RULE  := Pkg_a.Get_Item_Value('LOT_QUANTITY_RULE', Rowlist_)
      --批量数量规则
      row_.LOT_QUANTITY_RULE_DB  := Pkg_a.Get_Item_Value('LOT_QUANTITY_RULE_DB', Rowlist_)
      --POSITION_PART
      row_.POSITION_PART  := Pkg_a.Get_Item_Value('POSITION_PART', Rowlist_)
      --位置件
      row_.POSITION_PART_DB  := Pkg_a.Get_Item_Value('POSITION_PART_DB', Rowlist_)*/
    END IF;
    --修改
    IF Doaction_ = 'M' THEN
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      Open Cur_ For
        Select t.* From BL_V_PART_CATALOG t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        close cur_;
        Raise_Application_Error(Pkg_a.Raise_Error, '错误的rowid！');
        return;
      End If;
      Close Cur_;
      Data_ := Rowlist_;
      Pos_  := Instr(Data_, Index_);
      i     := i + 1;
    
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
          v_ := Substr(v_, Pos1_ + 1);
          CLIENT_SYS.Add_To_Attr(Column_Id_, v_, attr_);
        End If;
      
      End Loop;
      attr__      := attr_;
      Action_     := 'CHECK';
      objversion_ := row_.OBJVERSION;
      IFSAPP.PART_CATALOG_API.MODIFY__(info_,
                                       objid_,
                                       objversion_,
                                       attr_,
                                       action_);
    
      Action_     := 'DO';
      objversion_ := row_.OBJVERSION;
      IFSAPP.PART_CATALOG_API.MODIFY__(info_,
                                       objid_,
                                       objversion_,
                                       attr__,
                                       action_);
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PART_CATALOG', Row_.Objid);
      Return;
    End If;
    --删除
    If Doaction_ = 'D' Then
      /*OPEN CUR_ FOR
              SELECT T.* FROM BL_V_PART_CATALOG T WHERE T.ROWID = OBJID_;
            FETCH CUR_
              INTO ROW_;
            IF CUR_ %NOTFOUND THEN
              CLOSE CUR_;
              RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
              return;
            end if;
            close cur_;
      --      DELETE FROM BL_V_PART_CATALOG T WHERE T.ROWID = OBJID_; */
      --pkg_a.Setsuccess(A311_Key_,'BL_V_PART_CATALOG', Objid_);
      Return;
    End If;
  
  End;
  /*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2) Is
    Attr_Out     Varchar2(4000);
    ROW_         BL_V_PART_CATALOG%ROWTYPE;
    STD_NAME_ID_ STANDARD_NAMES_LOV%ROWTYPE;
    UNIT_CODE_   ISO_UNIT%ROWTYPE;
    CUR_         T_CURSOR;
  Begin
    IF COLUMN_ID_ = 'STD_NAME_ID' THEN
      ROW_.STD_NAME_ID := PKG_A.Get_Item_Value('STD_NAME_ID', ROWLIST_);
      OPEN CUR_ FOR
        SELECT T.*
          FROM STANDARD_NAMES_LOV T
         WHERE T.std_name_id = ROW_.STD_NAME_ID;
      FETCH CUR_
        INTO STD_NAME_ID_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '错误的标准名称标示');
        RETURN;
      END IF;
      CLOSE CUR_;
      PKG_A.Set_Item_Value('STD_NAME_DESC',
                           STD_NAME_ID_.std_name,
                           Attr_Out);
    END IF;
    IF COLUMN_id_ = 'UNIT_CODE' THEN
      ROW_.UNIT_CODE := PKG_A.Get_Item_Value('UNIT_CODE', ROWLIST_);
      OPEN CUR_ FOR
        SELECT T.* FROM ISO_UNIT T WHERE T.unit_code = ROW_.UNIT_CODE;
      FETCH CUR_
        INTO UNIT_CODE_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '错误的单位代码');
        return;
      END IF;
      PKG_A.Set_Item_Value('UNIT_CODE_DESC',
                           UNIT_CODE_.description,
                           ATTR_OUT);
    END IF;
    If Column_Id_ = '' Then
      --给列赋值
      Pkg_a.Set_Item_Value('【COLUMN】', '【value】', Attr_Out);
      --设置列不可用
      Pkg_a.Set_Column_Enable('【column】', '0', Attr_Out);
      --设置列可用
      Pkg_a.Set_Column_Enable('【column】', '1', Attr_Out);
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
      Rowlist_  当前用户
      返回: 1 可用
      0 不可用
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
  Begin
    If Column_Id_ = '【column】' Then
      Return '0';
    End If;
    Return '1';
  End;

End BL_PART_CATALOG_API;
/
