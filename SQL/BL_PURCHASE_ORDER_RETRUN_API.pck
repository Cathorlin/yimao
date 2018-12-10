CREATE OR REPLACE PACKAGE BL_PURCHASE_ORDER_RETRUN_API IS

  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2);
  PROCEDURE CANCEL__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
  PROCEDURE MODIFY__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
  PROCEDURE RELEASE__(ROWLIST_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2);
  PROCEDURE SUBMIT__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
  PROCEDURE CONFIRM__(ROWLIST_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2);
  PROCEDURE DENY__(ROWLIST_  VARCHAR2,
                   USER_ID_  VARCHAR2,
                   A311_KEY_ VARCHAR2);
  PROCEDURE ITEMCHANGE__(COLUMN_ID_   VARCHAR2,
                         MAINROWLIST_ VARCHAR2,
                         ROWLIST_     VARCHAR2,
                         USER_ID_     VARCHAR2,
                         OUTROWLIST_  OUT VARCHAR2);
  FUNCTION CHECKUSEABLE(DOACTION_  IN VARCHAR2,
                        COLUMN_ID_ IN VARCHAR,
                        ROWLIST_   IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION CHECKBUTTON__(DOTYPE_   IN VARCHAR2,
                         ORDER_NO_ IN VARCHAR2,
                         USER_ID_  IN VARCHAR2) RETURN VARCHAR2;
  --获取编码
  PROCEDURE GETINSPECTNO(CONTRACT_  IN VARCHAR2,
                         VENDOR_NO_ IN VARCHAR2,
                         SEQ_       OUT VARCHAR2);
  PROCEDURE GETBLORDERNO(CONTRACT_  IN VARCHAR2,
                         VENDOR_NO_ IN VARCHAR2,
                         SEQ_       OUT VARCHAR2);
END BL_PURCHASE_ORDER_RETRUN_API;
/
CREATE OR REPLACE PACKAGE BODY BL_PURCHASE_ORDER_RETRUN_API IS
  TYPE T_CURSOR IS REF CURSOR;
  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2) IS
    ATTR_OUT VARCHAR2(4000);
    ROW_     BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
  
  BEGIN
    --获取用户默认的域
    ATTR_OUT      := PKG_A.GET_ATTR_BY_BM(ROWLIST_);
    ROW_.CONTRACT := PKG_ATTR.GET_DEFAULT_CONTRACT(USER_ID_);
  
    IF (NVL(ROW_.CONTRACT, '0') <> '0') THEN
      PKG_A.SET_ITEM_VALUE('CONTRACT', ROW_.CONTRACT, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('STATE', '0', ATTR_OUT);
    END IF;
    /* 
    open cur_ for
    select  t.*
    from bl_ciq_contract_tab t
    where t.contract = row_.CONTRACT;
    fetch cur_ into row1_;
    if cur_%found then 
        row_.IFCIQ := row1_.ifciq;
        pkg_a.Set_Item_Value('IFCIQ',row_.IFCIQ,attr_out);
        row_.LOCATION := row1_.outlaction;
        pkg_a.Set_Item_Value('LOCATION',row_.LOCATION,attr_out);
        row_.WAREHOUSE := IFSAPP.INVENTORY_LOCATION_API.Get_Warehouse(row_.CONTRACT, row_.LOCATION);
        pkg_a.Set_Item_Value('WAREHOUSE',row_.WAREHOUSE,attr_out);
    end if ;
    close cur_;
    */
    PKG_A.SETRESULT(A311_KEY_, ATTR_OUT);
    RETURN;
  END;
  /*  退货申请 取消__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  PROCEDURE CANCEL__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
    INFO_           VARCHAR2(4000);
    ROW_            BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
    CUR_            T_CURSOR;
    ATTR_           VARCHAR2(4000);
    ACTION_         VARCHAR2(20);
    LOCATION_GROUP_ VARCHAR2(20);
  BEGIN
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_PURCHASE_ORDER_RETRUN T
       WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    ---判断状态
    IF ROW_.STATE >= '2' THEN
      PKG_A.SETMSG(A311_KEY_,
                   '',
                   '退货申请' || ROW_.INSPECT_NO || '已下达，不可取消');
      RETURN;
    END IF;
  
    UPDATE BL_V_PURCHASE_ORDER_RETRUN
       SET STATE = '4'
     WHERE ROWID = ROW_.OBJID;
  
    UPDATE BL_V_PURCHASE_ORDER_RETRUN_DTL
       SET STATE = '4'
     WHERE INSPECT_NO = ROW_.INSPECT_NO;
  
    --raise_application_error(-20101, '已经移库不能取消登记到达！');
    --return ;                                             
    PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_PURCHASE_ORDER_RETRUN', ROW_.OBJID);
    PKG_A.SETMSG(A311_KEY_,
                 '',
                 '退货申请' || ROW_.INSPECT_NO || '取消成功！');
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
    INDEX_      VARCHAR2(1);
    DOACTION_   VARCHAR2(1);
    POS_        NUMBER;
    POS1_       NUMBER;
    I           NUMBER;
    V_          VARCHAR(1000);
    COLUMN_ID_  VARCHAR(1000);
    DATA_       VARCHAR(4000);
    MYSQL_      VARCHAR2(4000);
    IFMYCHANGE  VARCHAR2(1);
    OBJID_      VARCHAR2(100);
    ROW_        BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
    CUR_        T_CURSOR;
    ROW0_       BL_V_BL_PICIHEAD_V01%ROWTYPE;
    ROW1_       BL_PICIHEAD%ROWTYPE;
    VENDOR_NO_  VARCHAR2(20);
    CONTRACT_   VARCHAR2(20);
    INSPECT_NO_ VARCHAR2(20);
  
  BEGIN
    INDEX_    := F_GET_DATA_INDEX();
    OBJID_    := PKG_A.GET_ITEM_VALUE('OBJID', INDEX_ || ROWLIST_);
    DOACTION_ := PKG_A.GET_ITEM_VALUE('DOACTION', ROWLIST_);
    IF DOACTION_ = 'I' THEN
      --  获取值
      ROW_.CONTRACT  := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
      ROW_.VENDOR_NO := PKG_A.GET_ITEM_VALUE('VENDOR_NO', ROWLIST_);
      GETINSPECTNO(ROW_.CONTRACT, ROW_.VENDOR_NO, ROW_.INSPECT_NO);
      GETBLORDERNO(ROW_.CONTRACT, ROW_.VENDOR_NO, ROW_.BLORDER_NO);
      ROW_.STATE          := PKG_A.GET_ITEM_VALUE('STATE', ROWLIST_);
      ROW_.PRICE_WITH_TAX := PKG_A.GET_ITEM_VALUE('PRICE_WITH_TAX',
                                                  ROWLIST_);
      ROW_.IS_OUTER_ORDER := PKG_A.GET_ITEM_VALUE('IS_OUTER_ORDER',
                                                  ROWLIST_);
      ROW_.LABEL_NOTE     := PKG_A.GET_ITEM_VALUE('LABEL_NOTE', ROWLIST_);
      ROW_.RETURN_DATE    := TO_DATE(PKG_A.GET_ITEM_VALUE('RETURN_DATE',
                                                          ROWLIST_),
                                     'YYYY-MM-DD HH24:MI:SS');
      -- 创建给一个默认值
      --row_.CREATEDATE:=to_char(sysdate,'yyyy-mm-dd');--pkg_a.Get_Item_Value('CREATEDATE',ROWLIST_ );
    
      IF ROW_.IS_OUTER_ORDER = 'INTERN' THEN
        --EXTERN
        IF ROW_.LABEL_NOTE IS NULL OR ROW_.LABEL_NOTE = '' THEN
          RAISE_APPLICATION_ERROR(-20101, '内部订单，外部客户号不能为空！');
          RETURN;
        END IF;
      END IF;
    
      --插入数据
      INSERT INTO BL_PURCHASE_ORDER_RETRUN
        (INSPECT_NO,
         CONTRACT,
         VENDOR_NO,
         STATE,
         PRICE_WITH_TAX,
         BLORDER_NO,
         IS_OUTER_ORDER,
         RETURN_TYPE,
         RETURN_DATE,
         LABEL_NOTE)
        SELECT ROW_.INSPECT_NO,
               ROW_.CONTRACT,
               ROW_.VENDOR_NO,
               ROW_.STATE,
               ROW_.PRICE_WITH_TAX,
               ROW_.BLORDER_NO,
               ROW_.IS_OUTER_ORDER,
               '1',
               ROW_.RETURN_DATE,
               ROW_.LABEL_NOTE
          FROM DUAL;
    
      SELECT T.ROWID
        INTO OBJID_
        FROM BL_PURCHASE_ORDER_RETRUN T
       WHERE T.INSPECT_NO = ROW_.INSPECT_NO;
    
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_PURCHASE_ORDER_RETRUN', OBJID_);
      RETURN;
    END IF;
    IF DOACTION_ = 'M' THEN
      -- 更改数据
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_PURCHASE_ORDER_RETRUN T
         WHERE T.OBJID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
        RETURN;
      ELSE
        IF ROW_.STATE > 0 THEN
          PKG_A.SETMSG(A311_KEY_,
                       '',
                       '退货申请' || ROW_.INSPECT_NO || '已提交，不可修改');
          CLOSE CUR_;
          RETURN;
        END IF;
      END IF;
      CLOSE CUR_;
    
      DATA_ := ROWLIST_;
    
      INSPECT_NO_         := NVL(PKG_A.GET_ITEM_VALUE('INSPECT_NO',
                                                      ROWLIST_),
                                 ROW_.INSPECT_NO);
      VENDOR_NO_          := NVL(PKG_A.GET_ITEM_VALUE('VENDOR_NO', ROWLIST_),
                                 ROW_.VENDOR_NO);
      CONTRACT_           := NVL(PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_),
                                 ROW_.CONTRACT);
      ROW_.IS_OUTER_ORDER := NVL(PKG_A.GET_ITEM_VALUE('IS_OUTER_ORDER',
                                                      ROWLIST_),
                                 ROW_.CONTRACT);
      ROW_.LABEL_NOTE     := NVL(PKG_A.GET_ITEM_VALUE('LABEL_NOTE',
                                                      ROWLIST_),
                                 ROW_.LABEL_NOTE);
      --修改了域或供应商，则重生单号
      IF ROW_.VENDOR_NO != VENDOR_NO_ OR ROW_.CONTRACT != CONTRACT_ THEN
        GETINSPECTNO(CONTRACT_, VENDOR_NO_, ROW_.INSPECT_NO);
        PKG_A.SET_ITEM_VALUE('INSPECT_NO', ROW_.INSPECT_NO, DATA_);
      END IF;
    
      IF ROW_.IS_OUTER_ORDER = 'INTERN' THEN
        --EXTERN
        IF ROW_.LABEL_NOTE IS NULL OR ROW_.LABEL_NOTE = '' THEN
          RAISE_APPLICATION_ERROR(-20101, '内部订单，外部客户号不能为空！');
          RETURN;
        END IF;
      END IF;
    
      POS_       := INSTR(DATA_, INDEX_);
      I          := I + 1;
      MYSQL_     := ' update BL_V_PURCHASE_ORDER_RETRUN set ';
      IFMYCHANGE := '0';
      LOOP
        EXIT WHEN NVL(POS_, 0) <= 0;
        EXIT WHEN I > 300;
        V_    := SUBSTR(DATA_, 1, POS_ - 1);
        DATA_ := SUBSTR(DATA_, POS_ + 1);
        POS_  := INSTR(DATA_, INDEX_);
      
        POS1_      := INSTR(V_, '|');
        COLUMN_ID_ := SUBSTR(V_, 1, POS1_ - 1);
        IF COLUMN_ID_ <> 'OBJID' AND COLUMN_ID_ <> 'DOACTION' AND
           LENGTH(NVL(COLUMN_ID_, '')) > 0 THEN
          V_ := SUBSTR(V_, POS1_ + 1);
          I  := I + 1;
        
          IFMYCHANGE := '1';
          IF COLUMN_ID_ = 'RETURN_DATE' THEN
            MYSQL_ := MYSQL_ || ' ' || COLUMN_ID_ || '=to_date(''' || V_ ||
                      ''',''YYYY-MM-DD HH24:MI:SS''),';
          ELSE
            MYSQL_ := MYSQL_ || ' ' || COLUMN_ID_ || '=''' || V_ || ''',';
          END IF;
        END IF;
      END LOOP;
      IF IFMYCHANGE = '1' THEN
        -- 更新sql语句 
        MYSQL_ := SUBSTR(MYSQL_, 1, LENGTH(MYSQL_) - 1);
        MYSQL_ := MYSQL_ || ' where rowidtochar(rowid)=''' || OBJID_ || '''';
      
        EXECUTE IMMEDIATE MYSQL_;
      
        IF ROW_.VENDOR_NO != VENDOR_NO_ OR ROW_.CONTRACT != CONTRACT_ THEN
          UPDATE BL_V_PURCHASE_ORDER_RETRUN_DTL
             SET INSPECT_NO = ROW_.INSPECT_NO
           WHERE INSPECT_NO = INSPECT_NO_;
        END IF;
      
      END IF;
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_PURCHASE_ORDER_RETRUN', OBJID_);
      RETURN;
    END IF;
  END;

  /*  退货申请下达 RELEASE__
      Rowlist_  下达当前退货申请单 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE RELEASE__(ROWLIST_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2) IS
    ROW_              BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
    CUR_              T_CURSOR;
    CURDETAIL_        T_CURSOR;
    ROWDETAIL_        BL_V_PURCHASE_ORDER_RETRUN_DTL%ROWTYPE;
    ROWRECEPT_        PURCHASE_RECEIPT_NEW%ROWTYPE;
    DETAIL_OBJID_     VARCHAR2(20);
    ATTR_             VARCHAR2(4000);
    STATE_            VARCHAR2(20);
    INFO_             VARCHAR2(4000);
    OBJVERSION_       VARCHAR2(4000);
    ACTION_           VARCHAR2(100);
    ORDER_LINE_OBJID_ VARCHAR(20);
    ISVENDERINTERN_   VARCHAR2(20);
    ISORDERFLAG_      NUMBER DEFAULT 0; --0:无订单，1：有订单
  
  BEGIN
    ROW_.OBJID := ROWLIST_;
  
    --数据校验
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_PURCHASE_ORDER_RETRUN T
       WHERE T.OBJID = ROW_.OBJID;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_PURCHASE_ORDER_RETRUN', ROW_.OBJID);
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    IF ROW_.STATE > 3 THEN
      RAISE_APPLICATION_ERROR(-20101,
                              '退货申请' || ROW_.INSPECT_NO || '已下达，不可重复下达');
      RETURN;
    END IF;
  
    --判断是否有订单退货
    OPEN CUR_ FOR
      SELECT *
        FROM BL_V_PURCHASE_ORDER_RETRUN_DTL
       WHERE INSPECT_NO = ROW_.INSPECT_NO;
    FETCH CUR_
      INTO ROWDETAIL_;
    IF CUR_%FOUND THEN
      --有无订单
      IF ROWDETAIL_.ORDER_NO IS NOT NULL AND
         ROWDETAIL_.LOT_BATCH_NO IS NOT NULL THEN
        ISORDERFLAG_ := 1;
      END IF;
      --是否还没未确认的行
      STATE_ := 0;
      LOOP
        EXIT WHEN CUR_%NOTFOUND;
        IF ROWDETAIL_.STATE != '2' THEN
          STATE_ := 1;
        END IF;
        FETCH CUR_
          INTO ROWDETAIL_;
      END LOOP;
    END IF;
    CLOSE CUR_;
  
    --判断是外部订单还是内部订单
    /*
      ISVENDERINTERN_ := IDENTITY_INVOICE_INFO_API.GET_IDENTITY_TYPE(SITE_API.GET_COMPANY(ROW_.CONTRACT),
                                                                     ROW_.VENDOR_NO,
                                                                     'Supplier');
    */
    --内部订单判断是否所有退货申请明细已确认
    IF ROW_.IS_OUTER_ORDER = 'INTERN' AND ISORDERFLAG_ = 1 THEN
      IF STATE_ = '1' THEN
        RAISE_APPLICATION_ERROR(-20101,
                                '退货申请明细' || ROW_.INSPECT_NO ||
                                '还未全部确认，请检查！');
        RETURN;
      END IF;
    END IF;
  
    --修改下达状态
    UPDATE BL_V_PURCHASE_ORDER_RETRUN
       SET STATE = '3'
     WHERE ROWID = ROW_.OBJID;
    UPDATE BL_V_PURCHASE_ORDER_RETRUN_DTL
       SET STATE = '3'
     WHERE INSPECT_NO = ROW_.INSPECT_NO;
  
    --本级有订单的退货申请处理，无订单的无法进入此循环
  
    OPEN CURDETAIL_ FOR
      SELECT T.OBJID, T1.STATE, T1.OBJID
        FROM BL_V_PURCHASE_ORDER_RETRUN_DTL T
       INNER JOIN BL_V_PURCHASE_ORDER_LINE_PART T1
          ON T.ORDER_NO = T1.ORDER_NO
         AND T.RELEASE_NO = T1.RELEASE_NO
         AND T.LINE_NO = T1.LINE_NO
       WHERE T.INSPECT_NO = ROW_.INSPECT_NO;
    FETCH CURDETAIL_
      INTO DETAIL_OBJID_, STATE_, ORDER_LINE_OBJID_;
    IF CURDETAIL_%FOUND THEN
      LOOP
        EXIT WHEN CURDETAIL_%NOTFOUND;
        --如果订单关闭，则重打开
        IF STATE_ = 'Closed' THEN
        
          SELECT OBJVERSION
            INTO OBJVERSION_
            FROM BL_V_PURCHASE_ORDER_LINE_PART
           WHERE OBJID = ORDER_LINE_OBJID_;
          ACTION_ := 'DO';
          PURCHASE_ORDER_LINE_PART_API.REOPEN__(INFO_,
                                                ORDER_LINE_OBJID_,
                                                OBJVERSION_,
                                                ATTR_,
                                                ACTION_);
          PKG_A.SETSUCCESS(A311_KEY_,
                           'BL_V_PURCHASE_ORDER_LINE_PART',
                           ORDER_LINE_OBJID_);
        
        END IF;
      
        --修改检验数量
      
        OPEN CUR_ FOR
          SELECT *
            FROM BL_V_PURCHASE_ORDER_RETRUN_DTL
           WHERE ROWID = DETAIL_OBJID_;
        FETCH CUR_
          INTO ROWDETAIL_;
      
        IF CUR_%FOUND THEN
          /*
          PURCHASE_RECEIPT_API.MODIFY_QTY_INSPECTED(ROWDETAIL_.ORDER_NO,
                                                    ROWDETAIL_.LINE_NO,
                                                    ROWDETAIL_.RELEASE_NO,
                                                    ROWDETAIL_.RECEIPT_NO,
                                                    ROWDETAIL_.QTY_TO_INSPECT);*/
          ATTR_ := '';
          CLIENT_SYS.ADD_TO_ATTR('QTY_TO_INSPECT',
                                 ROWDETAIL_.QTY_TO_INSPECT,
                                 ATTR_);
        
          PURCHASE_RECEIPT_API.MODIFY(ATTR_,
                                      ROWDETAIL_.ORDER_NO,
                                      ROWDETAIL_.LINE_NO,
                                      ROWDETAIL_.RELEASE_NO,
                                      ROWDETAIL_.RECEIPT_NO);
        END IF;
        CLOSE CUR_;
      
        FETCH CURDETAIL_
          INTO DETAIL_OBJID_, STATE_, ORDER_LINE_OBJID_;
      END LOOP;
    
    END IF;
    CLOSE CURDETAIL_;
  
    --内部订单需要生成子级退货申请,外部订单不需要
    IF ROW_.IS_OUTER_ORDER = 'INTERN' THEN
      BL_RETURN_MATERIAL1_API.RETURN_PURCHASERELEASE_(ROW_.INSPECT_NO,
                                                      USER_ID_,
                                                      A311_KEY_);
    END IF;
  
    PKG_A.SETMSG(A311_KEY_,
                 '',
                 '退货申请' || ROW_.INSPECT_NO || '下达成功');
  
    RETURN;
  END;
  /*  退货申请提交 SUBMIT__
      Rowlist_  提交当前退货申请单 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE SUBMIT__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
    ROW_       BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
    ROWDETAIL_ BL_V_PURCHASE_ORDER_RETRUN_DTL%ROWTYPE;
    CUR_       T_CURSOR;
    ATTR_      VARCHAR2(4000);
  BEGIN
    ROW_.OBJID := ROWLIST_;
  
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_PURCHASE_ORDER_RETRUN T
       WHERE T.OBJID = ROW_.OBJID;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_PURCHASE_ORDER_RETRUN', ROW_.OBJID);
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    OPEN CUR_ FOR
      SELECT *
        FROM BL_V_PURCHASE_ORDER_RETRUN_DTL
       WHERE INSPECT_NO = ROW_.INSPECT_NO;
    FETCH CUR_
      INTO ROWDETAIL_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETMSG(A311_KEY_,
                   '',
                   '退货申请' || ROW_.INSPECT_NO || '没有退货明细，请检查');
      RETURN;
    END IF;
  
    UPDATE BL_V_PURCHASE_ORDER_RETRUN
       SET STATE = '1'
     WHERE ROWID = ROW_.OBJID
       AND STATE < 1;
  
    UPDATE BL_V_PURCHASE_ORDER_RETRUN_DTL
       SET STATE = '1'
     WHERE INSPECT_NO = ROW_.INSPECT_NO
       AND STATE < 1;
  
    PKG_A.SETMSG(A311_KEY_,
                 '',
                 '退货申请' || ROW_.INSPECT_NO || '提交成功');
  
    RETURN;
  END;
  /*  退货申请确认 CONFIRM__
      Rowlist_  确认当前退货申请单 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE CONFIRM__(ROWLIST_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2) IS
    ROW_  BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
    ROWD_ BL_V_PURCHASE_ORDER_RETRUN_DTL%ROWTYPE;
    CUR_  T_CURSOR;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_PURCHASE_ORDER_RETRUN T
       WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'Bl_v_Purchase_Order_Retrun', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    --只更新他能看到的域的明细数据**          
  
    UPDATE BL_V_PURCHASE_ORDER_RETRUN_DTL
       SET STATE = '2'
     WHERE INSPECT_NO = ROW_.INSPECT_NO
       AND PKG_ATTR.CHECKCONTRACT(USER_ID_, CO_CONTRACT) = '1';
    --modify fjp 2012-12-12
    /*       AND CO_CONTRACT IN (SELECT DISTINCT CONTRACT
     FROM BL_USECON T2
    INNER JOIN A007 T1
       ON T1.BL_USERID = T2.USERID
      AND T1.A007_ID = USER_ID_);*/
  
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_PURCHASE_ORDER_RETRUN_DTL T
       WHERE T.INSPECT_NO = ROW_.INSPECT_NO
         AND STATE = '1';
    FETCH CUR_
      INTO ROWD_;
    IF CUR_%NOTFOUND THEN
      UPDATE BL_V_PURCHASE_ORDER_RETRUN
         SET STATE = '2'
       WHERE INSPECT_NO = ROW_.INSPECT_NO;
      RETURN;
    END IF;
    CLOSE CUR_;
  
    PKG_A.SETMSG(A311_KEY_, '', '退货申请确认成功');
  
    RETURN;
  END;
  /*  退货申请拒绝 DENY__
      Rowlist_  拒绝当前退货申请单，用于工厂拒绝退货操作
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE DENY__(ROWLIST_  VARCHAR2,
                   USER_ID_  VARCHAR2,
                   A311_KEY_ VARCHAR2) IS
    CUR_ T_CURSOR;
    ROW_ BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_PURCHASE_ORDER_RETRUN T
       WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'Bl_v_Purchase_Order_Retrun', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    --只更新他能看到的域的明细数据**     
    UPDATE BL_V_PURCHASE_ORDER_RETRUN_DTL
       SET STATE = '0'
     WHERE INSPECT_NO = ROW_.INSPECT_NO
       AND PKG_ATTR.CHECKCONTRACT(USER_ID_, CO_CONTRACT) = '1';
    --modify fjp 2012-12-12
    /*       AND CO_CONTRACT IN (SELECT DISTINCT CONTRACT
     FROM BL_USECON T2
    INNER JOIN A007 T1
       ON T1.BL_USERID = T2.USERID
      AND T1.A007_ID = USER_ID_);*/
  
    PKG_A.SETMSG(A311_KEY_, '', '退货申请否定成功');
  
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
    ATTR_OUT      VARCHAR2(4000);
    ROW_          BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
    ISOUTERORDER_ VARCHAR2(20);
  
  BEGIN
    IF COLUMN_ID_ = 'VENDOR_NO' OR COLUMN_ID_ = 'CONTRACT' THEN
      -- 供应商,域信息
      -- 供应商代码
      ROW_.VENDOR_NO   := PKG_A.GET_ITEM_VALUE('VENDOR_NO', ROWLIST_);
      ROW_.CONTRACT    := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
      ROW_.VENDOR_NAME := SUPPLIER_API.GET_VENDOR_NAME(ROW_.VENDOR_NO);
      --row_.CONTACT             := Supplier_Address_API.Get_Contact(row_.VENDOR_NO,Supplier_Address_API.Get_Address_No(row_.VENDOR_NO,Address_Type_Code_API.Get_Client_Value(1)));
      PKG_A.SET_ITEM_VALUE('VENDOR_NAME', ROW_.VENDOR_NAME, ATTR_OUT);
      ROW_.PRICE_WITH_TAX := IDENTITY_INVOICE_INFO_API.PRICE_WITH_TAX(SITE_API.GET_COMPANY(ROW_.CONTRACT),
                                                                      ROW_.VENDOR_NO,
                                                                      'SUPPLIER');
      PKG_A.SET_ITEM_VALUE('PRICE_WITH_TAX', ROW_.PRICE_WITH_TAX, ATTR_OUT);
      ISOUTERORDER_ := IDENTITY_INVOICE_INFO_API.GET_IDENTITY_TYPE(SITE_API.GET_COMPANY(ROW_.CONTRACT),
                                                                   ROW_.VENDOR_NO,
                                                                   'Supplier');
      PKG_A.SET_ITEM_VALUE('IS_OUTER_ORDER', ISOUTERORDER_, ATTR_OUT);
    
      OUTROWLIST_ := ATTR_OUT;
    END IF;
  END;

  /*  控制字段的读写权限 CHECKUSEABLE
      DOACTION_  操作类型
      COLUMN_ID_ 字段名称
      ROWLIST_ 数据字符串     
  */
  FUNCTION CHECKUSEABLE(DOACTION_  IN VARCHAR2,
                        COLUMN_ID_ IN VARCHAR,
                        ROWLIST_   IN VARCHAR2) RETURN VARCHAR2 IS
    ROW_ BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
  BEGIN
    ROW_.STATE := PKG_A.GET_ITEM_VALUE('STATE', ROWLIST_);
    IF DOACTION_ = 'M' THEN
      IF ROW_.STATE <> '0' THEN
        RETURN '0';
      END IF;
      IF COLUMN_ID_ = 'VENDOR_NO' OR COLUMN_ID_ = 'CONTRACT' OR
         COLUMN_ID_ = 'LABEL_NOTE' THEN
        RETURN '0';
      END IF;
    END IF;
    RETURN '1';
  END;
  /*  控制按钮的使用权限 CHECKBUTTON__
      DOTYPE_  操作类型
      ORDER_NO_ 单号
      USER_ID_ 当前用户     
  */
  FUNCTION CHECKBUTTON__(DOTYPE_   IN VARCHAR2,
                         ORDER_NO_ IN VARCHAR2,
                         USER_ID_  IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN '1';
  END;

  /*  获取退货申请号码 GETINSPECTNO
      CONTRACT_  域
      VENDOR_NO_ 供应商
      SEQ_ 单号     
  */
  PROCEDURE GETINSPECTNO(CONTRACT_  IN VARCHAR2,
                         VENDOR_NO_ IN VARCHAR2,
                         SEQ_       OUT VARCHAR2) IS
    ROW_  BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
    CUR   T_CURSOR;
    SEQW_ NUMBER; --流水号
  
  BEGIN
    -- 查询最大的退货申请号
    OPEN CUR FOR
      SELECT NVL(MAX(TO_NUMBER(SUBSTR(INSPECT_NO, 10, 4))), '0')
        FROM BL_V_PURCHASE_ORDER_RETRUN T
       WHERE T.VENDOR_NO = VENDOR_NO_
         AND T.CONTRACT = CONTRACT_; --o_char(sysdate,'yy');
    FETCH CUR
      INTO SEQW_;
  
    SEQ_ := TO_CHAR(SYSDATE, 'yy') || CONTRACT_ ||
            TRIM(TO_CHAR(VENDOR_NO_, '0000')) ||
            TRIM(TO_CHAR(SEQW_ + 1, '0000'));
  
    CLOSE CUR;
    RETURN;
  END;
  /*  获取宝隆退货申请单号 GETBLORDERNO
      CONTRACT_  域
      VENDOR_NO_ 供应商
      SEQ_ 单号     
  */
  PROCEDURE GETBLORDERNO(CONTRACT_  IN VARCHAR2,
                         VENDOR_NO_ IN VARCHAR2,
                         SEQ_       OUT VARCHAR2) IS
    ROW_  BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
    CUR   T_CURSOR;
    SEQW_ NUMBER; --流水号
  
  BEGIN
    -- 查询最大的退货申请号
    OPEN CUR FOR
      SELECT NVL(MAX(TO_NUMBER(SUBSTR(INSPECT_NO, 10, 4))), '0')
        FROM BL_V_PURCHASE_ORDER_RETRUN T
       WHERE T.VENDOR_NO = VENDOR_NO_;
    --and  t.CONTRACT  = contract_;--o_char(sysdate,'yy');
    FETCH CUR
      INTO SEQW_;
  
    SEQ_ := TO_CHAR(SYSDATE, 'yy') || TRIM(TO_CHAR(VENDOR_NO_, '000000')) ||
            TRIM(TO_CHAR(SEQW_ + 1, '0000'));
  
    CLOSE CUR;
    RETURN;
  END;
END BL_PURCHASE_ORDER_RETRUN_API;
/
