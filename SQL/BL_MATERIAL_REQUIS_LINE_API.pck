CREATE OR REPLACE PACKAGE BL_MATERIAL_REQUIS_LINE_API IS
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

  PROCEDURE HAND_RELEASED__(ROWLIST_ VARCHAR2,
                            --视图的objid
                            USER_ID_ VARCHAR2,
                            --用户id
                            A311_KEY_ VARCHAR2);

END BL_MATERIAL_REQUIS_LINE_API;
/
CREATE OR REPLACE PACKAGE BODY BL_MATERIAL_REQUIS_LINE_API IS
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
    ATTR_OUT    VARCHAR2(4000);
    MAINROW_    MATERIAL_REQUISITION%ROWTYPE;
    ROW_        BL_V_MATERIAL_REQUIS_LINE%ROWTYPE;
    CUR_        T_CURSOR;
    ATTR_       VARCHAR2(4000);
    INFO_       VARCHAR2(4000);
    OBJID_      VARCHAR2(4000);
    OBJVERSION_ VARCHAR2(4000);
    ACTION_     VARCHAR2(100);
  BEGIN
    ACTION_       := 'PREPARE';
    ROW_.ORDER_NO := PKG_A.GET_ITEM_VALUE('ORDER_NO', ROWLIST_);
    OPEN CUR_ FOR
      SELECT T.*
        FROM MATERIAL_REQUISITION T
       WHERE T.ORDER_NO = ROW_.ORDER_NO;
    FETCH CUR_
      INTO MAINROW_;
    IF CUR_%NOTFOUND THEN
      RETURN;
    END IF;
    CLOSE CUR_;
    CLIENT_SYS.SET_ITEM_VALUE('ORDER_NO', MAINROW_.ORDER_NO, ATTR_);
    CLIENT_SYS.SET_ITEM_VALUE('CONTRACT', MAINROW_.CONTRACT, ATTR_);
    INVENTORY_PART_IN_STOCK_API.NEW__(INFO_,
                                      OBJID_,
                                      OBJVERSION_,
                                      ATTR_,
                                      ACTION_);
    ATTR_OUT := PKG_A.GET_ATTR_BY_IFS(ATTR_);
    PKG_A.SET_ITEM_VALUE('CONTRACT', MAINROW_.CONTRACT, ATTR_OUT);
    PKG_A.SET_ITEM_VALUE('ORDER_CLASS_DB', 'INT', ATTR_OUT);
    PKG_A.SET_ITEM_VALUE('ORDER_CLASS', 'INT', ATTR_OUT);
    PKG_A.SET_ITEM_VALUE('DUE_DATE',
                         TO_CHAR(SYSDATE, 'YYYY-MM-DD'),
                         ATTR_OUT);
  
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
    OBJID_      VARCHAR2(50);
    INFO_       VARCHAR2(4000);
    OBJVERSION_ VARCHAR2(4000);
    INDEX_      VARCHAR2(1);
    CUR_        T_CURSOR;
    DOACTION_   VARCHAR2(10);
    ACTION_     VARCHAR2(100);
    POS_        NUMBER;
    POS1_       NUMBER;
    I           NUMBER;
    V_          VARCHAR(1000);
    COLUMN_ID_  VARCHAR(1000);
    DATA_       VARCHAR(4000);
    ATTR_       VARCHAR2(4000);
    ROW_        BL_V_MATERIAL_REQUIS_LINE%ROWTYPE;
  BEGIN
  
    INDEX_     := F_GET_DATA_INDEX();
    ROW_.OBJID := PKG_A.GET_ITEM_VALUE('OBJID', INDEX_ || ROWLIST_);
    DOACTION_  := PKG_A.GET_ITEM_VALUE('DOACTION', ROWLIST_);
    --新增
    IF DOACTION_ = 'I' THEN
      ATTR_ := '';
      CLIENT_SYS.ADD_TO_ATTR('ORDER_CLASS',
                             PKG_A.GET_ITEM_VALUE('ORDER_CLASS', ROWLIST_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('ORDER_NO',
                             PKG_A.GET_ITEM_VALUE('ORDER_NO', ROWLIST_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('PART_NO',
                             PKG_A.GET_ITEM_VALUE('PART_NO', ROWLIST_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('CONTRACT',
                             PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('QTY_DUE',
                             PKG_A.GET_ITEM_VALUE('QTY_DUE', ROWLIST_),
                             ATTR_);
      ROW_.QTY_DUE := PKG_A.GET_ITEM_VALUE('QTY_DUE', ROWLIST_);
      IF NVL(TO_CHAR(ROW_.QTY_DUE), 'NULL') = 'NULL' THEN
        RAISE_APPLICATION_ERROR(-20101, '应付数量必须有一个值');
      END IF;
      IF ROW_.QTY_DUE <= 0 THEN
        RAISE_APPLICATION_ERROR(-20101, '请填入正确的应付数量');
      END IF;
      CLIENT_SYS.ADD_TO_ATTR('UNIT_MEAS',
                             PKG_A.GET_ITEM_VALUE('UNIT_MEAS', ROWLIST_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('SUPPLY_CODE',
                             PKG_A.GET_ITEM_VALUE('SUPPLY_CODE', ROWLIST_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('NOTE_TEXT',
                             PKG_A.GET_ITEM_VALUE('NOTE_TEXT', ROWLIST_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('PLANNED_DELIVERY_DATE',
                             PKG_A.GET_ITEM_VALUE('PLANNED_DELIVERY_DATE',
                                                  ROWLIST_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('DUE_DATE',
                             PKG_A.GET_ITEM_VALUE('DUE_DATE', ROWLIST_),
                             ATTR_);
    
      CLIENT_SYS.ADD_TO_ATTR('CONDITION_CODE',
                             PKG_A.GET_ITEM_VALUE('CONDITION_CODE',
                                                  ROWLIST_),
                             ATTR_);
      ACTION_ := 'DO';
      MATERIAL_REQUIS_LINE_API.NEW__(INFO_,
                                     OBJID_,
                                     OBJVERSION_,
                                     ATTR_,
                                     ACTION_);
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_MATERIAL_REQUIS_LINE', OBJID_);
      RETURN;
    END IF;
    --修改
    IF DOACTION_ = 'M' THEN
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_MATERIAL_REQUIS_LINE T
         WHERE T.OBJID = ROW_.OBJID;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '未找到数据');
      END IF;
      CLOSE CUR_;
      ROW_.QTY_DUE := PKG_A.GET_ITEM_VALUE('QTY_DUE', ROWLIST_);
      IF TO_NUMBER(ROW_.QTY_DUE) <= 0 THEN
        RAISE_APPLICATION_ERROR(-20101, '请输入正确的应付数量');
        RETURN;
      END IF;
    
      DATA_ := ROWLIST_;
      POS_  := INSTR(DATA_, INDEX_);
      I     := I + 1;
      LOOP
        EXIT WHEN NVL(POS_, 0) <= 0;
        EXIT WHEN I > 300;
        V_         := SUBSTR(DATA_, 1, POS_ - 1);
        DATA_      := SUBSTR(DATA_, POS_ + 1);
        POS_       := INSTR(DATA_, INDEX_);
        POS1_      := INSTR(V_, '|');
        COLUMN_ID_ := SUBSTR(V_, 1, POS1_ - 1);
        IF COLUMN_ID_ <> 'OBJID' AND COLUMN_ID_ <> 'DOACTION' AND
           LENGTH(NVL(COLUMN_ID_, '')) > 0 THEN
          V_ := SUBSTR(V_, POS1_ + 1);
          CLIENT_SYS.ADD_TO_ATTR(COLUMN_ID_, V_, ATTR_);
          I := I + 1;
        END IF;
      END LOOP;
      ACTION_ := 'DO';
      MATERIAL_REQUIS_LINE_API.MODIFY__(INFO_,
                                        ROW_.OBJID,
                                        ROW_.OBJVERSION,
                                        ATTR_,
                                        ACTION_);
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_MATERIAL_REQUIS_LINE', ROW_.OBJID);
      RETURN;
    END IF;
    --删除
    IF DOACTION_ = 'D' THEN
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_MATERIAL_REQUIS_LINE T
         WHERE T.OBJID = ROW_.OBJID;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '未找到数据');
      END IF;
      CLOSE CUR_;
      ACTION_ := 'DO';
      MATERIAL_REQUIS_LINE_API.REMOVE__(INFO_,
                                        ROW_.OBJID,
                                        ROW_.OBJVERSION,
                                        ACTION_);
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_MATERIAL_REQUIS_LINE', ROW_.OBJID);
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
    ATTR_OUT   VARCHAR2(4000);
    ROW_       BL_V_MATERIAL_REQUIS_LINE%ROWTYPE;
    CUR_       T_CURSOR;
    ROW0_      ISO_UNIT%ROWTYPE;
    CHECK_ROW_ INVENTORY_PART%ROWTYPE;
  BEGIN
    IF COLUMN_ID_ = 'PART_NO' THEN
      ROW_.CONTRACT := PKG_A.GET_ITEM_VALUE('CONTRACT', MAINROWLIST_);
      ROW_.PART_NO  := PKG_A.GET_ITEM_VALUE('PART_NO', ROWLIST_);
      OPEN CUR_ FOR
        SELECT T.PART_STATUS
          FROM INVENTORY_PART T
         WHERE T.PART_NO = ROW_.PART_NO
           AND T.CONTRACT = ROW_.CONTRACT;
      FETCH CUR_
        INTO CHECK_ROW_.PART_STATUS;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '未找到数据');
        RETURN;
      END IF;
      CLOSE CUR_;
      IF CHECK_ROW_.PART_STATUS = 'N' THEN
        RAISE_APPLICATION_ERROR(-20101, '该库存件已经废除');
        RETURN;
      END IF;
      MATERIAL_REQUIS_LINE_API.CHECK_PART_NO__(ROW_.DESCRIPTION,
                                               ROW_.SUPPLY_CODE,
                                               ROW_.UNIT_MEAS,
                                               ROW_.PART_NO,
                                               ROW_.CONTRACT);
      PKG_A.SET_ITEM_VALUE('DESCRIPTION', ROW_.DESCRIPTION, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('SUPPLY_CODE', ROW_.SUPPLY_CODE, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('UNIT_MEAS', ROW_.UNIT_MEAS, ATTR_OUT);
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
    MAINROW_ BL_V_MATERIAL_REQUISITION%ROWTYPE;
    CUR_     T_CURSOR;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_MATERIAL_REQUISITION T WHERE T.ORDER_NO = KEY_;
    FETCH CUR_
      INTO MAINROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      RAISE_APPLICATION_ERROR(-20101, '未找到key');
    END IF;
    CLOSE CUR_;
    IF MAINROW_.STATUS_CODE <> 'Planned' THEN
      RETURN '0';
    END IF;
    IF DOTYPE_ = 'ADD_ROW' THEN
      RETURN '1';
    
    END IF;
    IF DOTYPE_ = 'DEL_ROW' THEN
      RETURN '1';
    
    END IF;
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
    ROW_ BL_V_MATERIAL_REQUIS_LINE%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    ROW_.OBJID := PKG_A.GET_ITEM_VALUE('OBJID', ROWLIST_);
    OPEN CUR_ FOR
      SELECT * FROM BL_V_MATERIAL_REQUIS_LINE T WHERE T.OBJID = ROW_.OBJID;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
    END IF;
    CLOSE CUR_;
    IF NVL(ROW_.OBJID, 'NULL') = 'NULL' THEN
      RETURN '1';
    END IF;
    if row_.STATUS_CODE <> 'Planned' then
      RETURN '0';
    end if;
    /*    IF ROW_.STATUS_CODE <> 'Closed' THEN
      IF COLUMN_ID_ = 'QTY_DUE' OR COLUMN_ID_ = 'DUE_DATE' THEN
        RETURN '1';
      ELSE
        RETURN '0';
      END IF;
    END IF;*/
  END;

  PROCEDURE HAND_RELEASED__(ROWLIST_ VARCHAR2,
                            --视图的objid
                            USER_ID_ VARCHAR2,
                            --用户id
                            A311_KEY_ VARCHAR2) IS
  BEGIN
    RETURN;
  END;

END BL_MATERIAL_REQUIS_LINE_API;
/
