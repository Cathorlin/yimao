CREATE OR REPLACE PACKAGE BL_TRANSPORT_NOTECONTRACTB_API IS

  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2);
  PROCEDURE MODIFY__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
  PROCEDURE REMOVE__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
  PROCEDURE ITEMCHANGE__(COLUMN_ID_   VARCHAR2,
                         MAINROWLIST_ VARCHAR2,
                         ROWLIST_     VARCHAR2,
                         USER_ID_     VARCHAR2,
                         OUTROWLIST_  OUT VARCHAR2);
  --判断当前列是否可编辑--
  FUNCTION CHECKUSEABLE(DOACTION_  IN VARCHAR2,
                        COLUMN_ID_ IN VARCHAR,
                        ROWLIST_   IN VARCHAR2) RETURN VARCHAR2;
  ----检查编辑 修改
  FUNCTION CHECKBUTTON__(DOTYPE_   IN VARCHAR2,
                         ORDER_NO_ IN VARCHAR2,
                         USER_ID_  IN VARCHAR2) RETURN VARCHAR2;

END BL_TRANSPORT_NOTECONTRACTB_API;
/
CREATE OR REPLACE PACKAGE BODY BL_TRANSPORT_NOTECONTRACTB_API IS
  TYPE T_CURSOR IS REF CURSOR;

  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2) IS
  BEGIN
  
    RETURN;
  END;

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE MODIFY__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
    INDEX_     VARCHAR2(1);
    DOACTION_  VARCHAR2(1);
    OBJID_     VARCHAR2(100);
    CUR_       T_CURSOR;
    ROW_       BL_V_TRANSPORT_NOTECONTRACT%ROWTYPE;
    ROWM_      BL_V_TRANSPORT_NOTE%ROWTYPE;
    LL_COUNT_  NUMBER;
    POS_       NUMBER;
    POS1_      NUMBER;
    I          NUMBER;
    V_         VARCHAR(1000);
    COLUMN_ID_ VARCHAR(1000);
    DATA_      VARCHAR(4000);
    MYSQL_     VARCHAR2(4000);
    IFMYCHANGE VARCHAR2(1);
  
  BEGIN
  
    INDEX_    := F_GET_DATA_INDEX();
    OBJID_    := PKG_A.GET_ITEM_VALUE('OBJID', INDEX_ || ROWLIST_);
    DOACTION_ := PKG_A.GET_ITEM_VALUE('DOACTION', ROWLIST_);
  
    IF DOACTION_ = 'I' THEN
    
      --判断主档状态是否可以添加明细
      ROW_.NOTE_NO := PKG_A.GET_ITEM_VALUE('NOTE_NO', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_TRANSPORT_NOTE T
         WHERE T.NOTE_NO = ROW_.NOTE_NO;
      FETCH CUR_
        INTO ROWM_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '未取得主档信息');
        RETURN;
      END IF;
      CLOSE CUR_;
    
      IF ROWM_.STATE <> 0 THEN
        RAISE_APPLICATION_ERROR(-20101,
                                '退货申请单' || ROW_.NOTE_NO || '非保存状态，不可添加明细');
        RETURN;
      END IF;
    
      -- 从页面获取数据
      ROW_.CONTRACT    := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
      ROW_.CONTAINERNO := '0';
      -- ROW_.SHOPTIME    := TO_DATE(PKG_A.GET_ITEM_VALUE('SHOPTIME', ROWLIST_),
      --'YYYY-MM-DD HH24:MI:SS');
      --ROW_.CONTACT     := PKG_A.GET_ITEM_VALUE('CONTACT', ROWLIST_);
      --ROW_.CONACTTEL   := PKG_A.GET_ITEM_VALUE('CONACTTEL', ROWLIST_);
      ROW_.STATE  := PKG_A.GET_ITEM_VALUE('STATE', ROWLIST_);
      ROW_.REMARK := PKG_A.GET_ITEM_VALUE('REMARK', ROWLIST_);
    
      -- 插入明细表的数据
      INSERT INTO BL_TRANSPORT_NOTECONTRACT
        (NOTE_NO,
         CONTRACT,
         CONTAINERNO,
         SHOPTIME,
         CONTACT,
         CONACTTEL,
         STATE,
         REMARK)
        SELECT ROW_.NOTE_NO,
               ROW_.CONTRACT,
               ROW_.CONTAINERNO,
               ROW_.SHOPTIME,
               ROW_.CONTACT,
               ROW_.CONACTTEL,
               ROW_.STATE,
               ROW_.REMARK
          FROM DUAL;
    
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_TRANSPORT_NOTECONTRACT', OBJID_);
    
      RETURN;
    END IF;
    -- 删除
    IF DOACTION_ = 'D' THEN
    
      --判断明细档状态是否可以删除明细
    
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_TRANSPORT_NOTECONTRACT T
         WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '未取得明细信息');
        RETURN;
      END IF;
      CLOSE CUR_;
    
      DELETE FROM BL_V_TRANSPORT_NOTECONTRACT T WHERE T.ROWID = OBJID_;
    
      RETURN;
    END IF;
  
    IF DOACTION_ = 'M' THEN
    
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_TRANSPORT_NOTECONTRACT T
         WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '未取得明细信息');
        RETURN;
      END IF;
      CLOSE CUR_;
    
      DATA_  := ROWLIST_;
      POS_   := INSTR(DATA_, INDEX_);
      I      := I + 1;
      MYSQL_ := ' update BL_V_TRANSPORT_NOTECONTRACT set ';
      LOOP
        EXIT WHEN NVL(POS_, 0) <= 0;
        EXIT WHEN I > 300;
        V_    := SUBSTR(DATA_, 1, POS_ - 1);
        DATA_ := SUBSTR(DATA_, POS_ + 1);
        POS_  := INSTR(DATA_, INDEX_);
      
        POS1_      := INSTR(V_, '|');
        COLUMN_ID_ := SUBSTR(V_, 1, POS1_ - 1);
        IF COLUMN_ID_ <> 'OBJID' AND COLUMN_ID_ <> 'CONTRACT_DESC' AND
           COLUMN_ID_ <> 'DOACTION' AND LENGTH(NVL(COLUMN_ID_, '')) > 0 THEN
          V_         := SUBSTR(V_, POS1_ + 1);
          I          := I + 1;
          IFMYCHANGE := '1';
          --   if column_id_ = 'DATE_SURE' or column_id_='SURE_SHIPDATE' or column_id_='RECALCU_DATE' then
          --     mysql_ := mysql_ || ' ' || column_id_ || '=to_date(''' || v_  || ''',''YYYY-MM-DD HH24:MI:SS''),';
          --  else
          MYSQL_ := MYSQL_ || ' ' || COLUMN_ID_ || '=''' || V_ || ''',';
          --  end if ;
        END IF;
      END LOOP;
      IF IFMYCHANGE = '1' THEN
        -- 更新sql语句
        MYSQL_ := SUBSTR(MYSQL_, 1, LENGTH(MYSQL_) - 1);
        MYSQL_ := MYSQL_ || ' where rowidtochar(rowid)=''' || OBJID_ || '''';
        EXECUTE IMMEDIATE MYSQL_;
      END IF;
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_TRANSPORT_NOTECONTRACT', OBJID_);
      RETURN;
    END IF;
  END;
  /*  退货申请明细删除 REMOVE__
      Rowlist_  删除的当前退货申请单明细行
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE REMOVE__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
  BEGIN
    RETURN;
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
    CUR_     T_CURSOR;
    ATTR_OUT VARCHAR2(4000);
    ROW_     SITE_TAB%ROWTYPE;
  
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
      PKG_A.SET_ITEM_VALUE('CONTRACT_DESC', ROW_.CONTRACT_REF, ATTR_OUT);
    END IF;
  
    OUTROWLIST_ := ATTR_OUT;
    -- pkg_a.setResult(A311_KEY_,attr_out);   
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
    ROW_ BL_V_TRANSPORT_NOTECONTRACTB%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    ROW_.OBJID := PKG_A.GET_ITEM_VALUE('OBJID', ROWLIST_);
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_TRANSPORT_NOTECONTRACTB T
       WHERE T.ROWID = ROW_.OBJID;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%FOUND THEN
      IF ROW_.STATE <> '0' THEN
        IF COLUMN_ID_ = 'CONTRACT' OR COLUMN_ID_ = 'CONTRACT_DESC' OR
           COLUMN_ID_ = 'REMARK' THEN
          RETURN '0';
        ELSE
          RETURN '1';
        END IF;
      END IF;
    END IF;
    CLOSE CUR_;
  END;

  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  FUNCTION CHECKBUTTON__(DOTYPE_   IN VARCHAR2,
                         ORDER_NO_ IN VARCHAR2,
                         USER_ID_  IN VARCHAR2) RETURN VARCHAR2 IS
    ROW_ BL_V_TRANSPORT_NOTEB%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTEB T WHERE T.NOTE_NO = ORDER_NO_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%FOUND THEN
      IF ROW_.STATE = '2' OR ROW_.STATE = '1' THEN
        RETURN '0';
      END IF;
      CLOSE CUR_;
    END IF;
    CLOSE CUR_;
    RETURN '1';
  END;

END BL_TRANSPORT_NOTECONTRACTB_API;
/
