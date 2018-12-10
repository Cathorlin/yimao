CREATE OR REPLACE PACKAGE BL_TRANSPORT_NOTECONTRACTE_API IS
  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2);

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE MODIFY__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
  /*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
  PROCEDURE ITEMCHANGE__(COLUMN_ID_   VARCHAR2,
                         MAINROWLIST_ VARCHAR2,
                         ROWLIST_     VARCHAR2,
                         USER_ID_     VARCHAR2,
                         OUTROWLIST_  OUT VARCHAR2);
  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  FUNCTION CHECKBUTTON__(DOTYPE_  IN VARCHAR2,
                         KEY_     IN VARCHAR2,
                         USER_ID_ IN VARCHAR2) RETURN VARCHAR2;

  /*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
  */
  FUNCTION CHECKUSEABLE(DOACTION_  IN VARCHAR2,
                        COLUMN_ID_ IN VARCHAR,
                        ROWLIST_   IN VARCHAR2) RETURN VARCHAR2;
  PROCEDURE CONFIRM__(ROWLIST_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2);

END BL_TRANSPORT_NOTECONTRACTE_API;
/
CREATE OR REPLACE PACKAGE BODY BL_TRANSPORT_NOTECONTRACTE_API IS
  TYPE T_CURSOR IS REF CURSOR;
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
  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2) IS
    ATTR_OUT VARCHAR2(4000);
  BEGIN
    ATTR_OUT := '';
  
    -- pkg_a.Set_Item_Value('【COLUMN】','【VALUE】', attr_out);
    PKG_A.SETRESULT(A311_KEY_, ATTR_OUT);
  END;

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE MODIFY__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
    OBJID_     VARCHAR2(50);
    INDEX_     VARCHAR2(1);
    CUR_       T_CURSOR;
    DOACTION_  VARCHAR2(10);
    POS_       NUMBER;
    POS1_      NUMBER;
    I          NUMBER;
    V_         VARCHAR(1000);
    COLUMN_ID_ VARCHAR(1000);
    DATA_      VARCHAR(4000);
    MYSQL_     VARCHAR(4000);
    IFMYCHANGE VARCHAR(1);
    ROW_       BL_V_TRANSPORT_NOTECONTRACTE%ROWTYPE;
  BEGIN
    INDEX_    := F_GET_DATA_INDEX();
    OBJID_    := PKG_A.GET_ITEM_VALUE('OBJID', INDEX_ || ROWLIST_);
    DOACTION_ := PKG_A.GET_ITEM_VALUE('DOACTION', ROWLIST_);
    --新增
    IF DOACTION_ = 'I' THEN
      --DOACTION|IOBJID|NULLNOTE_NO|CONTRACT|PLCONTRACTDESC|波兰REMARK|AAAAASTATE|B','TH','36482'
    
      --申请单号
      ROW_.NOTE_NO := PKG_A.GET_ITEM_VALUE('NOTE_NO', ROWLIST_);
      --工厂域
      ROW_.CONTRACT := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
      --域描述
      --row_.CONTRACTDESC  := Pkg_a.Get_Item_Value('CONTRACTDESC', Rowlist_)
      --备注
      ROW_.REMARK := PKG_A.GET_ITEM_VALUE('REMARK', ROWLIST_);
      --状态
      -- row_.STATE  := Pkg_a.Get_Item_Value('STATE', Rowlist_);
      INSERT INTO BL_TRANSPORT_NOTECONTRACT
        (NOTE_NO, CONTRACT, CONTAINERNO, REMARK, STATE)
        SELECT ROW_.NOTE_NO, ROW_.CONTRACT, 0, ROW_.REMARK, '0' FROM DUAL;
    
      PKG_A.SETSUCCESS(A311_KEY_, 'bl_transport_notecontract', OBJID_);
      RETURN;
    END IF;
    --修改
    IF DOACTION_ = 'M' THEN
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_TRANSPORT_NOTECONTRACTE T
         WHERE T.OBJID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(PKG_A.RAISE_ERROR, '错误的rowid！');
      
      END IF;
      CLOSE CUR_;
      DATA_      := ROWLIST_;
      POS_       := INSTR(DATA_, INDEX_);
      I          := I + 1;
      MYSQL_     := 'update bl_transport_notecontract set ';
      IFMYCHANGE := '0';
      LOOP
        EXIT WHEN NVL(POS_, 0) <= 0;
        EXIT WHEN I > 300;
        V_    := SUBSTR(DATA_, 1, POS_ - 1);
        DATA_ := SUBSTR(DATA_, POS_ + 1);
        POS_  := INSTR(DATA_, INDEX_);
      
        POS1_      := INSTR(V_, '|');
        COLUMN_ID_ := SUBSTR(V_, 1, POS1_ - 1);
      
        IF COLUMN_ID_ <> UPPER('Objid') AND COLUMN_ID_ <> UPPER('Doaction') AND
           COLUMN_ID_ <> UPPER('CONTRACTDESC') AND
           LENGTH(NVL(COLUMN_ID_, '')) > 0 THEN
          IFMYCHANGE := '1';
          V_         := SUBSTR(V_, POS1_ + 1);
          MYSQL_     := MYSQL_ || ' ' || COLUMN_ID_ || '=''' || V_ || ''',';
        END IF;
      
      END LOOP;
    
      --用户自定义列
      IF IFMYCHANGE = '1' THEN
        MYSQL_ := SUBSTR(MYSQL_, 1, LENGTH(MYSQL_) - 1);
        -- Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User ='''|| User_Id_ ||'''; 
        MYSQL_ := MYSQL_ || ' Where Rowid =''' || ROW_.OBJID || '''';
        -- raise_application_error(Pkg_a.Raise_Error, mysql_);
        EXECUTE IMMEDIATE MYSQL_;
      END IF;
    
      PKG_A.SETSUCCESS(A311_KEY_,
                       'BL_V_TRANSPORT_NOTECONTRACTE',
                       ROW_.OBJID);
      RETURN;
    END IF;
    --删除
    IF DOACTION_ = 'D' THEN
      -- Raise_Application_Error(pkg_a.raise_error,'出错了 ！！！！！');
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_TRANSPORT_NOTECONTRACTE T
         WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(PKG_A.RAISE_ERROR, '错误的rowid');
        RETURN;
      END IF;
      CLOSE CUR_;
      DELETE FROM BL_TRANSPORT_NOTECONTRACT T WHERE T.ROWID = OBJID_;
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_TRANSPORT_NOTECONTRACTE', OBJID_);
      RETURN;
    END IF;
  
  END;
  /*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
  PROCEDURE ITEMCHANGE__(COLUMN_ID_   VARCHAR2,
                         MAINROWLIST_ VARCHAR2,
                         ROWLIST_     VARCHAR2,
                         USER_ID_     VARCHAR2,
                         OUTROWLIST_  OUT VARCHAR2) IS
    ATTR_OUT VARCHAR2(4000);
    ROW_     SITE_TAB%ROWTYPE;
    -- ROWPB_   BL_V_DISTPICKLIST_BOOKING%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    IF COLUMN_ID_ = 'CONTRACT' THEN
      ROW_.CONTRACT := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT T.* FROM SITE_TAB T WHERE T.CONTRACT = ROW_.CONTRACT;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
        RETURN;
      END IF;
      CLOSE CUR_;
      -- 赋值
      PKG_A.SET_ITEM_VALUE('CONTRACTDESC', ROW_.CONTRACT_REF, ATTR_OUT);
    END IF;
    OUTROWLIST_ := ATTR_OUT;
  END;
  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  FUNCTION CHECKBUTTON__(DOTYPE_  IN VARCHAR2,
                         KEY_     IN VARCHAR2,
                         USER_ID_ IN VARCHAR2) RETURN VARCHAR2 IS
    CUR_ T_CURSOR;
    ROW_ BL_TRANSPORT_NOTE%ROWTYPE;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_TRANSPORT_NOTE T WHERE T.NOTE_NO = KEY_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%FOUND THEN
      IF DOTYPE_ = UPPER('Add_Row') AND ROW_.STATE = '1' THEN
        RETURN '0';
      END IF;
      IF DOTYPE_ = UPPER('Del_Row') AND ROW_.STATE = '1' THEN
        RETURN '0';
      END IF;
    END IF;
    CLOSE CUR_;
    RETURN '1';
  END;

  /*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
      返回: 1 可用
      0 不可用
  */
  FUNCTION CHECKUSEABLE(DOACTION_  IN VARCHAR2,
                        COLUMN_ID_ IN VARCHAR,
                        ROWLIST_   IN VARCHAR2) RETURN VARCHAR2 IS
    ROW_ BL_V_TRANSPORT_NOTECONTRACTE%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    ROW_.OBJID := PKG_A.GET_ITEM_VALUE('OBJID', ROWLIST_);
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_TRANSPORT_NOTECONTRACTE T
       WHERE OBJID = ROW_.OBJID;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%FOUND AND ROW_.STATE <> '0' THEN
      IF COLUMN_ID_ = UPPER('contract') OR COLUMN_ID_ = UPPER('remark') THEN
        RETURN '0';
      END IF;
    END IF;
    RETURN '1';
  END;

  PROCEDURE CONFIRM__(ROWLIST_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2) IS
    ROW_ BL_V_TRANSPORT_NOTECONTRACTE%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    -- RAISE_APPLICATION_ERROR(-20101, '错误的rowid--错误的rowid');
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_TRANSPORT_NOTECONTRACTE T
       WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_TRANSPORT_NOTEE', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
  
    CLOSE CUR_;
    -- RAISE_APPLICATION_ERROR(-20101, '错误的rowid--错误的rowid');
    UPDATE BL_TRANSPORT_NOTECONTRACT
       SET STATE = '1'
     WHERE ROWID = ROW_.OBJID;
  
    PKG_A.SETMSG(A311_KEY_, '', '内销订车确认成功');
  
    RETURN;
  END;

END BL_TRANSPORT_NOTECONTRACTE_API;
/
