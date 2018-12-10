CREATE OR REPLACE PACKAGE BL_TRANSPORT_NOTEE_API IS
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
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ�������� �� ɾ���� ��ť 
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
  PROCEDURE CONFIRM__(ROWLIST_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2);
  PROCEDURE CONFIRMCANCEL__(ROWLIST_  VARCHAR2,
                            USER_ID_  VARCHAR2,
                            A311_KEY_ VARCHAR2);
  FUNCTION GET_NOTE_NO(TYPE_ VARCHAR2) RETURN VARCHAR2;
  FUNCTION CHECK_CONTRACT_(OBJID_ VARCHAR2) RETURN BOOLEAN;
    PROCEDURE CLOSE__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) ;
                     PROCEDURE CANCEL__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) ;
END BL_TRANSPORT_NOTEE_API;
/
CREATE OR REPLACE PACKAGE BODY BL_TRANSPORT_NOTEE_API IS
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
    ATTR_OUT VARCHAR2(4000);
    NOTE_NO_ VARCHAR2(50);
    row_ BL_V_TRANSPORT_NOTEE%rowtype;
    REQUESTURL_ VARCHAR2(4000);
  BEGIN
    REQUESTURL_            := PKG_A.GET_ITEM_VALUE('REQUESTURL', ROWLIST_);
 
    row_.picklistno        := PKG_A.GET_ITEM_VALUE_BY_INDEX('&PICKLISTNO=',
                                                            '&',
                                                            REQUESTURL_);
    ATTR_OUT := '';
    if row_.picklistno is not null then 
       PKG_A.SET_ITEM_VALUE('PICKLISTNO', row_.picklistno, ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('SHIPTIME', to_char(sysdate,'yyyy-mm-dd'), ATTR_OUT);
    end if ;
 
    -- NOTE_NO_:=GET_NOTE_NO('E');
    -- pkg_a.Set_Item_Value('NOTE_NO',NOTE_NO_, attr_out);
  
    -- pkg_a.Set_Item_Value('��COLUMN��','��VALUE��', attr_out);
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
    INDEX_      VARCHAR2(1);
    CUR_        T_CURSOR;
    DOACTION_   VARCHAR2(10);
    POS_        NUMBER;
    POS1_       NUMBER;
    I           NUMBER := 1;
    V_          VARCHAR(1000);
    COLUMN_ID_  VARCHAR(1000);
    DATA_       VARCHAR(4000);
    MYSQL_      VARCHAR(4000);
    IFMYCHANGE  VARCHAR(1);
    ROW_        BL_V_TRANSPORT_NOTEE%ROWTYPE;
    PICKLISTNO_ VARCHAR2(50);
  BEGIN
    INDEX_    := F_GET_DATA_INDEX();
    OBJID_    := PKG_A.GET_ITEM_VALUE('OBJID', INDEX_ || ROWLIST_);
    DOACTION_ := PKG_A.GET_ITEM_VALUE('DOACTION', ROWLIST_);
    --����
    IF DOACTION_ = 'I' THEN
    
      --��������
      ROW_.PICKLISTNO := PKG_A.GET_ITEM_VALUE('PICKLISTNO', ROWLIST_);
      --���뵥��
      --  row_.NOTE_NO  := Pkg_a.Get_Item_Value('NOTE_NO', Rowlist_);
      ROW_.NOTE_NO := GET_NOTE_NO('E');
      --����ʱ��
      ROW_.SHIPTIME := TO_DATE(PKG_A.GET_ITEM_VALUE('SHIPTIME', ROWLIST_),
                               'YYYY-MM-DD');
      --��ע
      ROW_.REMARK := PKG_A.GET_ITEM_VALUE('REMARK', ROWLIST_);
      --��Ӧ��
      ROW_.VENDOR_NO := PKG_A.GET_ITEM_VALUE('VENDOR_NO', ROWLIST_);
      --��Ӧ������
      ROW_.VENDER_DESC := PKG_A.GET_ITEM_VALUE('VENDER_DESC', ROWLIST_);
      --״̬
      -- row_.STATE := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    
      --���¶��յ��Ķ�����ϸ״̬
      UPDATE BL_BOOKINGLIST_DTL
         SET STATE = '2'
       WHERE PICKLISTNO = ROW_.PICKLISTNO;
    
      INSERT INTO BL_TRANSPORT_NOTE
        (NOTETYPE, PICKLISTNO, NOTE_NO, SHIPTIME, REMARK, VENDOR_NO, STATE)
       values('E',
               ROW_.PICKLISTNO,
               ROW_.NOTE_NO,
               ROW_.SHIPTIME,
               ROW_.REMARK,
               ROW_.VENDOR_NO,
               '0')
      returning rowid into OBJID_;
         -- FROM DUAL;
      --    pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
    
/*      SELECT T.ROWID
        INTO OBJID_
        FROM BL_TRANSPORT_NOTE T
       WHERE T.NOTE_NO = ROW_.NOTE_NO;*/
     ---modify fjp 2013-01-25 �Զ�������ϸ  
      insert into BL_TRANSPORT_NOTECONTRACT(  note_no   ,
                                              contract    ,
                                              containerno  ,
                                              state )
      SELECT distinct  ROW_.NOTE_NO,SUBSTR(b.SUPPLIER, 1, 2),'0','0'
        from BL_PLDTL b 
       where b.PICKUNITENO = ROW_.PICKLISTNO
         and b.flag IN('1','2');
      ---end--
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_TRANSPORT_NOTE', OBJID_);
      RETURN;
    END IF;
    --�޸�
    IF DOACTION_ = 'M' THEN
    
      OPEN CUR_ FOR
        SELECT T.* FROM BL_V_TRANSPORT_NOTEE T WHERE T.OBJID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(PKG_A.RAISE_ERROR, '�����rowid��');
      END IF;
      CLOSE CUR_;
 --���ϲ���2013-01-25 FJP
/*      PICKLISTNO_ := PKG_A.GET_ITEM_VALUE('PICKLISTNO', ROWLIST_);
    
      IF PICKLISTNO_ <> ROW_.PICKLISTNO THEN
        UPDATE BL_BOOKINGLIST_DTL
           SET STATE = '1'
         WHERE PICKLISTNO = ROW_.PICKLISTNO;
        UPDATE BL_BOOKINGLIST_DTL
           SET STATE = '2'
         WHERE PICKLISTNO = PICKLISTNO_;
      
      END IF;*/
    
      DATA_      := ROWLIST_;
      POS_       := INSTR(DATA_, INDEX_);
      I          := I + 1;
      MYSQL_     := 'update bl_transport_note set ';
      IFMYCHANGE := '0';
      LOOP
        EXIT WHEN NVL(POS_, 0) <= 0;
        EXIT WHEN I > 300;
        V_         := SUBSTR(DATA_, 1, POS_ - 1);
        DATA_      := SUBSTR(DATA_, POS_ + 1);
        POS_       := INSTR(DATA_, INDEX_);
        I          := I + 1;
        POS1_      := INSTR(V_, '|');
        COLUMN_ID_ := SUBSTR(V_, 1, POS1_ - 1);
      
        IF COLUMN_ID_ <> 'OBJID' AND COLUMN_ID_ <> UPPER('Doaction') AND
           LENGTH(NVL(COLUMN_ID_, '')) > 0 AND COLUMN_ID_ <> 'VENDER_DESC' THEN
          IFMYCHANGE := '1';
          V_         := SUBSTR(V_, POS1_ + 1);
          -- Mysql_     := Mysql_ || Column_Id_ || ='''|| v_ ||'',';
          IF COLUMN_ID_ = 'SHIPTIME' THEN
            V_     := 'TO_DATE(''' || V_ || ''',''YYYY-MM-DD'')';
            MYSQL_ := MYSQL_ || ' ' || COLUMN_ID_ || '=' || V_ || ',';
          ELSE
            MYSQL_ := MYSQL_ || ' ' || COLUMN_ID_ || '=''' || V_ || ''',';
          END IF;
        
        END IF;
      
      END LOOP;
    
      --�û��Զ�����
      IF IFMYCHANGE = '1' THEN
        MYSQL_ := SUBSTR(MYSQL_, 1, LENGTH(MYSQL_) - 1);
        MYSQL_ := MYSQL_ || ' Where Rowid =''' || ROW_.OBJID || '''';
        -- raise_application_error(Pkg_a.Raise_Error, mysql_);
        EXECUTE IMMEDIATE MYSQL_;
      END IF;
    
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_TRANSPORT_NOTEE', ROW_.OBJID);
      RETURN;
    END IF;
    --ɾ��
    IF DOACTION_ = 'd' THEN
      /*OPEN CUR_ FOR
              SELECT T.* FROM BL_V_TRANSPORT_NOTEE T WHERE T.ROWID = OBJID_;
            FETCH CUR_
              INTO ROW_;
            IF CUR_ %NOTFOUND THEN
              CLOSE CUR_;
              RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'�����rowid');
              return;
            end if;
            close cur_;
      --      DELETE FROM BL_V_TRANSPORT_NOTEE T WHERE T.ROWID = OBJID_; */
      --pkg_a.Setsuccess(A311_Key_,'BL_V_TRANSPORT_NOTEE', Objid_);
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
    ATTR_OUT VARCHAR2(4000);
    ROW_     BL_V_PURCHASE_ORDER_RETRUN%ROWTYPE;
  BEGIN
    /*If Column_Id_ ='VENDOR_NO' Then
    --���и�ֵ
    Pkg_a.Set_Item_Value('��COLUMN��','��value��', Attr_Out);
    --�����в�����
    Pkg_a.Set_Column_Enable('��column��','0', Attr_Out);
    --�����п���
    Pkg_a.Set_Column_Enable('��column��','1', Attr_Out);
    End If; 
    Outrowlist_ := Attr_Out;*/
    IF COLUMN_ID_ = 'VENDOR_NO' THEN
      -- ��Ӧ��,
      -- ��Ӧ�̴���
    
      ROW_.VENDOR_NO := PKG_A.GET_ITEM_VALUE('VENDOR_NO', ROWLIST_);
    
      ROW_.VENDOR_NAME := SUPPLIER_API.GET_VENDOR_NAME(ROW_.VENDOR_NO);
    
      -- PKG_A.SET_ITEM_VALUE('VENDOR_NAME', ROW_.VENDOR_NAME, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('VENDER_DESC', ROW_.VENDOR_NAME, ATTR_OUT);
      /*ROW_.PRICE_WITH_TAX := IDENTITY_INVOICE_INFO_API.PRICE_WITH_TAX(SITE_API.GET_COMPANY(ROW_.CONTRACT),
                                                                      ROW_.VENDOR_NO,
                                                                      'SUPPLIER');
      PKG_A.SET_ITEM_VALUE('PRICE_WITH_TAX', ROW_.PRICE_WITH_TAX, ATTR_OUT);
      ISOUTERORDER_ := IDENTITY_INVOICE_INFO_API.GET_IDENTITY_TYPE(SITE_API.GET_COMPANY(ROW_.CONTRACT),
                                                                   ROW_.VENDOR_NO,
                                                                   'Supplier');
      PKG_A.SET_ITEM_VALUE('IS_OUTER_ORDER', ISOUTERORDER_, ATTR_OUT);*/
    
      OUTROWLIST_ := ATTR_OUT;
    END IF;
  
  END;
  /*  �з����仯��ʱ��
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ�������� �� ɾ���� ��ť 
      KEY_ ����������ֵ
      User_Id_  ��ǰ�û�
  */
  FUNCTION CHECKBUTTON__(DOTYPE_  IN VARCHAR2,
                         KEY_     IN VARCHAR2,
                         USER_ID_ IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF DOTYPE_ = 'Add_Row' THEN
      RETURN '1';
    END IF;
    IF DOTYPE_ = 'Del_Row' THEN
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
    ROW_ BL_V_TRANSPORT_NOTEE%ROWTYPE;
  BEGIN
    ROW_.STATE := PKG_A.GET_ITEM_VALUE('STATE', ROWLIST_);
    ROW_.OBJID := PKG_A.GET_ITEM_VALUE('OBJID', ROWLIST_);
    --�����󱸻��������޸�modify fjp 2013-01-25
    IF NVL(ROW_.OBJID,'NULL') <> 'NULL' AND COLUMN_ID_ ='PICKLISTNO'  THEN 
       RETURN  '0';
    END IF ;
    --RAISE_APPLICATION_ERROR(-20101, '�����rowid--�����rowid');
    IF ROW_.STATE != 0 THEN
      IF COLUMN_ID_ = UPPER('note_NO') OR COLUMN_ID_ = UPPER('notetype') OR
         COLUMN_ID_ = UPPER('picklistno') OR COLUMN_ID_ = UPPER('shiptime') OR
         COLUMN_ID_ = UPPER('remark') OR COLUMN_ID_ = UPPER('vendor_no') THEN
        RETURN '0';
      END IF;
    END IF;
  
    RETURN '1';
  END;

  PROCEDURE CONFIRM__(ROWLIST_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2) IS
    ROW_ BL_V_TRANSPORT_NOTEE%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    -- RAISE_APPLICATION_ERROR(-20101, '�����rowid--�����rowid');
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTEE T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_TRANSPORT_NOTEE', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    IF CHECK_CONTRACT_(ROWLIST_) = FALSE THEN
      RAISE_APPLICATION_ERROR(-20101, '��ƥ��');
      RETURN;
    END IF;
    -- RAISE_APPLICATION_ERROR(-20101, '�����rowid--�����rowid');
    UPDATE BL_TRANSPORT_NOTE SET STATE = '1' WHERE ROWID = ROW_.OBJID;
    UPDATE BL_TRANSPORT_NOTECONTRACT
       SET STATE = '1'
     WHERE NOTE_NO = ROW_.note_NO;
      --     (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE T WHERE ROWID = ROW_.OBJID);
  
    --bl_transport_note
  
    /*UPDATE bl_transport_notecontract
    
       SET STATE = '1'
     WHERE NOTE_NO =
           (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
    
    UPDATE BL_V_TRANSPORT_NOTECONTRACT
       SET STATE = '1'
     WHERE NOTE_NO =
           (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);*/
  
    PKG_A.SETMSG(A311_KEY_, '', '��������֪ͨȷ�ϳɹ�');
  
    RETURN;
  END;
  PROCEDURE CONFIRMCANCEL__(ROWLIST_  VARCHAR2,
                            USER_ID_  VARCHAR2,
                            A311_KEY_ VARCHAR2)
    is
    ROW_ BL_V_TRANSPORT_NOTEE%ROWTYPE;
    CUR_ T_CURSOR;
    ll_count_ number;
  BEGIN
    -- RAISE_APPLICATION_ERROR(-20101, '�����rowid--�����rowid');
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTEE T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_TRANSPORT_NOTEE', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
    --ƴ�����ڲ�����ȡ���´�
    select count(*) into ll_count_ from BL_CONTAINPICKLIST_DTL  where NOTE_NO =row_.NOTE_NO and  state <>'3';
    if ll_count_ > 0 then 
       RAISE_APPLICATION_ERROR(-20101, '�Ѿ�����ƴ��װ������ȡ���´�');
    end if ;
    -- RAISE_APPLICATION_ERROR(-20101, '�����rowid--�����rowid');
    UPDATE BL_TRANSPORT_NOTE SET STATE = '0' WHERE ROWID = ROW_.OBJID;
    UPDATE BL_TRANSPORT_NOTECONTRACT
       SET STATE = '0'
     WHERE NOTE_NO   = row_.NOTE_NO;
/*     IN
           (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE T WHERE ROWID = ROW_.OBJID);*/
  
    PKG_A.SETMSG(A311_KEY_, '', '��������֪ͨȡ��ȷ�ϳɹ�');
  
    RETURN;
   END;
  --�Ҽ�����ȡ��--
  PROCEDURE CANCEL__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
    INFO_           VARCHAR2(4000);
    ROW_            BL_V_TRANSPORT_NOTEE%ROWTYPE;
    CUR_            T_CURSOR;
    ATTR_           VARCHAR2(4000);
    ACTION_         VARCHAR2(20);
    LOCATION_GROUP_ VARCHAR2(20);
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTEE T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    ---�ж�״̬
    IF ROW_.STATE <> '0' THEN
      PKG_A.SETMSG(A311_KEY_,
                   '',
                   '��������' || ROW_.NOTE_NO || '���´����ȡ��');
      RETURN;
    END IF;
  
    UPDATE BL_TRANSPORT_NOTE SET STATE = '3' WHERE ROWID = ROW_.OBJID;
   UPDATE BL_TRANSPORT_NOTECONTRACT SET STATE='3'
     WHERE NOTE_NO = ROW_.note_NO;
        --   (SELECT NOTE_NO FROM BL_V_TRANSPORT_NOTEE T WHERE T.OBJID = ROW_.OBJID);
   
    --raise_application_error(-20101, '�Ѿ��ƿⲻ��ȡ���Ǽǵ��');
    --return ;                                             
    PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_BOOKINGLIST', ROW_.OBJID);
    PKG_A.SETMSG(A311_KEY_, '', '��������' || ROW_.NOTE_NO || 'ȡ���ɹ���');
    RETURN;
  END;
   --�Ҽ��ر�--
  PROCEDURE CLOSE__(ROWLIST_  VARCHAR2,
                    USER_ID_  VARCHAR2,
                    A311_KEY_ VARCHAR2) IS
    ROW_ BL_V_TRANSPORT_NOTEE%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTEE T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_TRANSPORT_NOTEE', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
    UPDATE BL_V_TRANSPORT_NOTEE SET STATE = '4' WHERE ROWID = ROW_.OBJID;
    UPDATE BL_V_TRANSPORT_NOTECONTRACTE SET STATE='4'
     WHERE NOTE_NO =
           (SELECT NOTE_NO FROM BL_V_TRANSPORT_NOTEE T WHERE T.OBJID = ROW_.OBJID);
 
    PKG_A.SETMSG(A311_KEY_, '', '���������رճɹ�');
  
    RETURN;
  END;
  
  
  /*��ȡ��λ����*/
  FUNCTION GET_NOTE_NO(TYPE_ VARCHAR2) RETURN VARCHAR2 IS
    ROW_  BL_TRANSPORT_NOTE%ROWTYPE;
    CUR   T_CURSOR;
    SEQW_ NUMBER; --��ˮ��
    SEQ_  VARCHAR2(20);
  
  BEGIN
    -- ��ѯ���ı��²�λ��
    OPEN CUR FOR
      SELECT NVL(MAX(TO_NUMBER(SUBSTR(NOTE_NO, 10, 4))), '0')
        FROM BL_TRANSPORT_NOTE T
       WHERE SUBSTR(T.NOTE_NO, 1, 8) =
             TO_CHAR(SYSDATE, 'yyyymm') || '-' || TYPE_;
    FETCH CUR
      INTO SEQW_;
  
    SEQ_ := TO_CHAR(SYSDATE, 'yyyymm') || '-' || TYPE_ || '-' ||
            TRIM(TO_CHAR(SEQW_ + 1, '0000'));
  
    CLOSE CUR;
    RETURN SEQ_;
  END;
  --��鹤�����������--
  FUNCTION CHECK_CONTRACT_(OBJID_ VARCHAR2) RETURN BOOLEAN IS
    ROW_   BL_V_TRANSPORT_NOTEE%ROWTYPE;
    CUR_B  T_CURSOR;
    COUNT1 NUMBER;
    COUNT2 NUMBER;
  BEGIN
    OPEN CUR_B FOR
      SELECT * FROM BL_V_TRANSPORT_NOTEE T WHERE T.OBJID = OBJID_;
    FETCH CUR_B
      INTO ROW_;
    IF CUR_B%NOTFOUND THEN
      CLOSE CUR_B;
      RETURN FALSE;
    END IF;
    CLOSE CUR_B;
    SELECT COUNT(DISTINCT(T.CONTRACT))
      INTO COUNT1
      FROM BL_V_TRANSPORT_NOTECONTRACTE T
     WHERE T.NOTE_NO = ROW_.NOTE_NO;
  
/*    SELECT COUNT(SUPPLIER)
      INTO COUNT2
      FROM BL_V_PICKUTINCASE
     WHERE PICKLISTNO = ROW_.PICKLISTNO;*/
   SELECT COUNT(distinct  SUBSTR(b.SUPPLIER, 1, 2))
    into  COUNT2
    from  BL_PLDTL b 
    where b.PICKUNITENO = ROW_.PICKLISTNO
     and  b.flag IN('1','2');
    /*
      SELECT COUNT(DISTINCT(A.SUPPLIER))
        INTO COUNT2
        FROM BL_PUTINCASE_M A
       WHERE A.STATE = '4'
         AND A.PICKLISTNO = ROW_.PICKLISTNO;
    */
    IF COUNT1 = COUNT2 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  
  END;

END BL_TRANSPORT_NOTEE_API;
/