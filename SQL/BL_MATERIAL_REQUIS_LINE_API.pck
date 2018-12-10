CREATE OR REPLACE PACKAGE BL_MATERIAL_REQUIS_LINE_API IS
  /*  ������ʼ�� New__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���requseturl ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ */
  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2);

  /*  �������� Modify__
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
  */
  PROCEDURE MODIFY__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
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
                         OUTROWLIST_  OUT VARCHAR2);
  /*  �з����仯��ʱ��
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ������� �� ɾ���� ��ť 
      KEY_ ����������ֵ
      User_Id_  ��ǰ�û�
  */
  FUNCTION CHECKBUTTON__(DOTYPE_  IN VARCHAR2,
                         KEY_     IN VARCHAR2,
                         USER_ID_ IN VARCHAR2) RETURN VARCHAR2;

  /*  ʵ��ҵ���߼������е� �༭��
      Doaction_   I M ��ϸ�϶�Ϊ M   I ���� M �޸� ҳ�������� ��ǰ�����е� �����Ե��Ժ� ����  
      Column_Id_  ��
      Rowlist_  ��ǰ�û�
  */
  FUNCTION CHECKUSEABLE(DOACTION_  IN VARCHAR2,
                        COLUMN_ID_ IN VARCHAR,
                        ROWLIST_   IN VARCHAR2) RETURN VARCHAR2;

  PROCEDURE HAND_RELEASED__(ROWLIST_ VARCHAR2,
                            --��ͼ��objid
                            USER_ID_ VARCHAR2,
                            --�û�id
                            A311_KEY_ VARCHAR2);

END BL_MATERIAL_REQUIS_LINE_API;
/
CREATE OR REPLACE PACKAGE BODY BL_MATERIAL_REQUIS_LINE_API IS
  TYPE T_CURSOR IS REF CURSOR;
  --��COLUMN��  ������ ��ʵ�ʵ��߼� ��ʵ�ʵ�����
  -- ��VALUE��  �е����� �������ʵ���߼� �ö�Ӧ�Ĳ��������
  /*
  ����
  Raise_Application_Error(pkg_a.raise_error,'������ ����������');
  */

  /*  ������ʼ�� New__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���requseturl ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ */
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

  /*  �������� Modify__
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
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
    --����
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
        RAISE_APPLICATION_ERROR(-20101, 'Ӧ������������һ��ֵ');
      END IF;
      IF ROW_.QTY_DUE <= 0 THEN
        RAISE_APPLICATION_ERROR(-20101, '��������ȷ��Ӧ������');
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
    --�޸�
    IF DOACTION_ = 'M' THEN
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_MATERIAL_REQUIS_LINE T
         WHERE T.OBJID = ROW_.OBJID;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, 'δ�ҵ�����');
      END IF;
      CLOSE CUR_;
      ROW_.QTY_DUE := PKG_A.GET_ITEM_VALUE('QTY_DUE', ROWLIST_);
      IF TO_NUMBER(ROW_.QTY_DUE) <= 0 THEN
        RAISE_APPLICATION_ERROR(-20101, '��������ȷ��Ӧ������');
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
    --ɾ��
    IF DOACTION_ = 'D' THEN
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_MATERIAL_REQUIS_LINE T
         WHERE T.OBJID = ROW_.OBJID;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, 'δ�ҵ�����');
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
        RAISE_APPLICATION_ERROR(-20101, 'δ�ҵ�����');
        RETURN;
      END IF;
      CLOSE CUR_;
      IF CHECK_ROW_.PART_STATUS = 'N' THEN
        RAISE_APPLICATION_ERROR(-20101, '�ÿ����Ѿ��ϳ�');
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
  /*  �з����仯��ʱ��
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ������� �� ɾ���� ��ť 
      KEY_ ����������ֵ
      User_Id_  ��ǰ�û�
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
      RAISE_APPLICATION_ERROR(-20101, 'δ�ҵ�key');
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
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
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
                            --��ͼ��objid
                            USER_ID_ VARCHAR2,
                            --�û�id
                            A311_KEY_ VARCHAR2) IS
  BEGIN
    RETURN;
  END;

END BL_MATERIAL_REQUIS_LINE_API;
/
