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
  --�жϵ�ǰ���Ƿ�ɱ༭--
  FUNCTION CHECKUSEABLE(DOACTION_  IN VARCHAR2,
                        COLUMN_ID_ IN VARCHAR,
                        ROWLIST_   IN VARCHAR2) RETURN VARCHAR2;
  ----���༭ �޸�
  FUNCTION CHECKBUTTON__(DOTYPE_   IN VARCHAR2,
                         ORDER_NO_ IN VARCHAR2,
                         USER_ID_  IN VARCHAR2) RETURN VARCHAR2;

END BL_TRANSPORT_NOTECONTRACTB_API;
/
CREATE OR REPLACE PACKAGE BODY BL_TRANSPORT_NOTECONTRACTB_API IS
  TYPE T_CURSOR IS REF CURSOR;

  /*  ������ʼ�� New__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���requseturl ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ */
  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2) IS
  BEGIN
  
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
    
      --�ж�����״̬�Ƿ���������ϸ
      ROW_.NOTE_NO := PKG_A.GET_ITEM_VALUE('NOTE_NO', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_TRANSPORT_NOTE T
         WHERE T.NOTE_NO = ROW_.NOTE_NO;
      FETCH CUR_
        INTO ROWM_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, 'δȡ��������Ϣ');
        RETURN;
      END IF;
      CLOSE CUR_;
    
      IF ROWM_.STATE <> 0 THEN
        RAISE_APPLICATION_ERROR(-20101,
                                '�˻����뵥' || ROW_.NOTE_NO || '�Ǳ���״̬�����������ϸ');
        RETURN;
      END IF;
    
      -- ��ҳ���ȡ����
      ROW_.CONTRACT    := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
      ROW_.CONTAINERNO := '0';
      -- ROW_.SHOPTIME    := TO_DATE(PKG_A.GET_ITEM_VALUE('SHOPTIME', ROWLIST_),
      --'YYYY-MM-DD HH24:MI:SS');
      --ROW_.CONTACT     := PKG_A.GET_ITEM_VALUE('CONTACT', ROWLIST_);
      --ROW_.CONACTTEL   := PKG_A.GET_ITEM_VALUE('CONACTTEL', ROWLIST_);
      ROW_.STATE  := PKG_A.GET_ITEM_VALUE('STATE', ROWLIST_);
      ROW_.REMARK := PKG_A.GET_ITEM_VALUE('REMARK', ROWLIST_);
    
      -- ������ϸ�������
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
    -- ɾ��
    IF DOACTION_ = 'D' THEN
    
      --�ж���ϸ��״̬�Ƿ����ɾ����ϸ
    
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_TRANSPORT_NOTECONTRACT T
         WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, 'δȡ����ϸ��Ϣ');
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
        RAISE_APPLICATION_ERROR(-20101, 'δȡ����ϸ��Ϣ');
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
        -- ����sql���
        MYSQL_ := SUBSTR(MYSQL_, 1, LENGTH(MYSQL_) - 1);
        MYSQL_ := MYSQL_ || ' where rowidtochar(rowid)=''' || OBJID_ || '''';
        EXECUTE IMMEDIATE MYSQL_;
      END IF;
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_TRANSPORT_NOTECONTRACT', OBJID_);
      RETURN;
    END IF;
  END;
  /*  �˻�������ϸɾ�� REMOVE__
      Rowlist_  ɾ���ĵ�ǰ�˻����뵥��ϸ��
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
  */
  PROCEDURE REMOVE__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
  BEGIN
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
        RAISE_APPLICATION_ERROR(-20101, '�����rowid');
        RETURN;
      END IF;
      CLOSE CUR_;
      -- ��ֵ
      PKG_A.SET_ITEM_VALUE('CONTRACT_DESC', ROW_.CONTRACT_REF, ATTR_OUT);
    END IF;
  
    OUTROWLIST_ := ATTR_OUT;
    -- pkg_a.setResult(A311_KEY_,attr_out);   
  END;

  /*  ʵ��ҵ���߼������е� �༭��
      Doaction_   I M ��ϸ�϶�Ϊ M   I ���� M �޸� ҳ�������� ��ǰ�����е� �����Ե��Ժ� ����  
      Column_Id_  ��
      Rowlist_  ��ǰ�û�
      ����: 1 ����
      0 ������
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

  /*  �з����仯��ʱ��
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ������� �� ɾ���� ��ť 
      KEY_ ����������ֵ
      User_Id_  ��ǰ�û�
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
