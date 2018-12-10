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
  --��ȡ����
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
  /*  ������ʼ�� New__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���requseturl ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ */
  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2) IS
    ATTR_OUT VARCHAR2(4000);
    ROW_     BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
  
  BEGIN
    --��ȡ�û�Ĭ�ϵ���
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
  /*  �˻����� ȡ��__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���requseturl ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ */
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
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    ---�ж�״̬
    IF ROW_.STATE >= '2' THEN
      PKG_A.SETMSG(A311_KEY_,
                   '',
                   '�˻�����' || ROW_.INSPECT_NO || '���´����ȡ��');
      RETURN;
    END IF;
  
    UPDATE BL_V_PURCHASE_ORDER_RETRUN
       SET STATE = '4'
     WHERE ROWID = ROW_.OBJID;
  
    UPDATE BL_V_PURCHASE_ORDER_RETRUN_DTL
       SET STATE = '4'
     WHERE INSPECT_NO = ROW_.INSPECT_NO;
  
    --raise_application_error(-20101, '�Ѿ��ƿⲻ��ȡ���Ǽǵ��');
    --return ;                                             
    PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_PURCHASE_ORDER_RETRUN', ROW_.OBJID);
    PKG_A.SETMSG(A311_KEY_,
                 '',
                 '�˻�����' || ROW_.INSPECT_NO || 'ȡ���ɹ���');
    RETURN;
  END;
  /*  �������� Modify__
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
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
      --  ��ȡֵ
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
      -- ������һ��Ĭ��ֵ
      --row_.CREATEDATE:=to_char(sysdate,'yyyy-mm-dd');--pkg_a.Get_Item_Value('CREATEDATE',ROWLIST_ );
    
      IF ROW_.IS_OUTER_ORDER = 'INTERN' THEN
        --EXTERN
        IF ROW_.LABEL_NOTE IS NULL OR ROW_.LABEL_NOTE = '' THEN
          RAISE_APPLICATION_ERROR(-20101, '�ڲ��������ⲿ�ͻ��Ų���Ϊ�գ�');
          RETURN;
        END IF;
      END IF;
    
      --��������
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
      -- ��������
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_PURCHASE_ORDER_RETRUN T
         WHERE T.OBJID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '�����rowid');
        RETURN;
      ELSE
        IF ROW_.STATE > 0 THEN
          PKG_A.SETMSG(A311_KEY_,
                       '',
                       '�˻�����' || ROW_.INSPECT_NO || '���ύ�������޸�');
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
      --�޸������Ӧ�̣�����������
      IF ROW_.VENDOR_NO != VENDOR_NO_ OR ROW_.CONTRACT != CONTRACT_ THEN
        GETINSPECTNO(CONTRACT_, VENDOR_NO_, ROW_.INSPECT_NO);
        PKG_A.SET_ITEM_VALUE('INSPECT_NO', ROW_.INSPECT_NO, DATA_);
      END IF;
    
      IF ROW_.IS_OUTER_ORDER = 'INTERN' THEN
        --EXTERN
        IF ROW_.LABEL_NOTE IS NULL OR ROW_.LABEL_NOTE = '' THEN
          RAISE_APPLICATION_ERROR(-20101, '�ڲ��������ⲿ�ͻ��Ų���Ϊ�գ�');
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
        -- ����sql��� 
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

  /*  �˻������´� RELEASE__
      Rowlist_  �´ﵱǰ�˻����뵥 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
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
    ISORDERFLAG_      NUMBER DEFAULT 0; --0:�޶�����1���ж���
  
  BEGIN
    ROW_.OBJID := ROWLIST_;
  
    --����У��
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_PURCHASE_ORDER_RETRUN T
       WHERE T.OBJID = ROW_.OBJID;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_PURCHASE_ORDER_RETRUN', ROW_.OBJID);
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    IF ROW_.STATE > 3 THEN
      RAISE_APPLICATION_ERROR(-20101,
                              '�˻�����' || ROW_.INSPECT_NO || '���´�����ظ��´�');
      RETURN;
    END IF;
  
    --�ж��Ƿ��ж����˻�
    OPEN CUR_ FOR
      SELECT *
        FROM BL_V_PURCHASE_ORDER_RETRUN_DTL
       WHERE INSPECT_NO = ROW_.INSPECT_NO;
    FETCH CUR_
      INTO ROWDETAIL_;
    IF CUR_%FOUND THEN
      --���޶���
      IF ROWDETAIL_.ORDER_NO IS NOT NULL AND
         ROWDETAIL_.LOT_BATCH_NO IS NOT NULL THEN
        ISORDERFLAG_ := 1;
      END IF;
      --�Ƿ�ûδȷ�ϵ���
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
  
    --�ж����ⲿ���������ڲ�����
    /*
      ISVENDERINTERN_ := IDENTITY_INVOICE_INFO_API.GET_IDENTITY_TYPE(SITE_API.GET_COMPANY(ROW_.CONTRACT),
                                                                     ROW_.VENDOR_NO,
                                                                     'Supplier');
    */
    --�ڲ������ж��Ƿ������˻�������ϸ��ȷ��
    IF ROW_.IS_OUTER_ORDER = 'INTERN' AND ISORDERFLAG_ = 1 THEN
      IF STATE_ = '1' THEN
        RAISE_APPLICATION_ERROR(-20101,
                                '�˻�������ϸ' || ROW_.INSPECT_NO ||
                                '��δȫ��ȷ�ϣ����飡');
        RETURN;
      END IF;
    END IF;
  
    --�޸��´�״̬
    UPDATE BL_V_PURCHASE_ORDER_RETRUN
       SET STATE = '3'
     WHERE ROWID = ROW_.OBJID;
    UPDATE BL_V_PURCHASE_ORDER_RETRUN_DTL
       SET STATE = '3'
     WHERE INSPECT_NO = ROW_.INSPECT_NO;
  
    --�����ж������˻����봦���޶������޷������ѭ��
  
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
        --��������رգ����ش�
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
      
        --�޸ļ�������
      
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
  
    --�ڲ�������Ҫ�����Ӽ��˻�����,�ⲿ��������Ҫ
    IF ROW_.IS_OUTER_ORDER = 'INTERN' THEN
      BL_RETURN_MATERIAL1_API.RETURN_PURCHASERELEASE_(ROW_.INSPECT_NO,
                                                      USER_ID_,
                                                      A311_KEY_);
    END IF;
  
    PKG_A.SETMSG(A311_KEY_,
                 '',
                 '�˻�����' || ROW_.INSPECT_NO || '�´�ɹ�');
  
    RETURN;
  END;
  /*  �˻������ύ SUBMIT__
      Rowlist_  �ύ��ǰ�˻����뵥 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
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
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
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
                   '�˻�����' || ROW_.INSPECT_NO || 'û���˻���ϸ������');
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
                 '�˻�����' || ROW_.INSPECT_NO || '�ύ�ɹ�');
  
    RETURN;
  END;
  /*  �˻�����ȷ�� CONFIRM__
      Rowlist_  ȷ�ϵ�ǰ�˻����뵥 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
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
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    --ֻ�������ܿ����������ϸ����**          
  
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
  
    PKG_A.SETMSG(A311_KEY_, '', '�˻�����ȷ�ϳɹ�');
  
    RETURN;
  END;
  /*  �˻�����ܾ� DENY__
      Rowlist_  �ܾ���ǰ�˻����뵥�����ڹ����ܾ��˻�����
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
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
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    --ֻ�������ܿ����������ϸ����**     
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
  
    PKG_A.SETMSG(A311_KEY_, '', '�˻�����񶨳ɹ�');
  
    RETURN;
  END;

  /*  �з����仯��ʱ��
      Column_Id_   ��ǰ�޸ĵ���
      Mainrowlist_ ���������� ��ϸ��ֵ������Ϊ��
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      Outrowlist_  ���������   
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
      -- ��Ӧ��,����Ϣ
      -- ��Ӧ�̴���
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

  /*  �����ֶεĶ�дȨ�� CHECKUSEABLE
      DOACTION_  ��������
      COLUMN_ID_ �ֶ�����
      ROWLIST_ �����ַ���     
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
  /*  ���ư�ť��ʹ��Ȩ�� CHECKBUTTON__
      DOTYPE_  ��������
      ORDER_NO_ ����
      USER_ID_ ��ǰ�û�     
  */
  FUNCTION CHECKBUTTON__(DOTYPE_   IN VARCHAR2,
                         ORDER_NO_ IN VARCHAR2,
                         USER_ID_  IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN '1';
  END;

  /*  ��ȡ�˻�������� GETINSPECTNO
      CONTRACT_  ��
      VENDOR_NO_ ��Ӧ��
      SEQ_ ����     
  */
  PROCEDURE GETINSPECTNO(CONTRACT_  IN VARCHAR2,
                         VENDOR_NO_ IN VARCHAR2,
                         SEQ_       OUT VARCHAR2) IS
    ROW_  BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
    CUR   T_CURSOR;
    SEQW_ NUMBER; --��ˮ��
  
  BEGIN
    -- ��ѯ�����˻������
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
  /*  ��ȡ��¡�˻����뵥�� GETBLORDERNO
      CONTRACT_  ��
      VENDOR_NO_ ��Ӧ��
      SEQ_ ����     
  */
  PROCEDURE GETBLORDERNO(CONTRACT_  IN VARCHAR2,
                         VENDOR_NO_ IN VARCHAR2,
                         SEQ_       OUT VARCHAR2) IS
    ROW_  BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
    CUR   T_CURSOR;
    SEQW_ NUMBER; --��ˮ��
  
  BEGIN
    -- ��ѯ�����˻������
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
