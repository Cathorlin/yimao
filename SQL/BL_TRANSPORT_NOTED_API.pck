CREATE OR REPLACE PACKAGE BL_TRANSPORT_NOTED_API IS

  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2);
  PROCEDURE CANCEL__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
  PROCEDURE MODIFY__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
  PROCEDURE TRANSFROM__(ROWLIST_  VARCHAR2,
                        USER_ID_  VARCHAR2,
                        A311_KEY_ VARCHAR2);
  PROCEDURE CONFIRM__(ROWLIST_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2);
  --ȡ���´�                    
  PROCEDURE CONFIRMCANCEL__(ROWLIST_  VARCHAR2,
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
  --��ȡ����
  FUNCTION GET_NOTE_NO(TYPE_ VARCHAR2) RETURN VARCHAR2;
  FUNCTION CHECK_DUPLICATE(CONTRACT_ IN VARCHAR2, PICKLISTNO_ IN VARCHAR2)
    RETURN BOOLEAN;
END BL_TRANSPORT_NOTED_API;
/
CREATE OR REPLACE PACKAGE BODY BL_TRANSPORT_NOTED_API IS
  TYPE T_CURSOR IS REF CURSOR;
  /*  ������ʼ�� New__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���requseturl ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ 
  modify fjp 2013-01-06 �����Զ�������ϸ*/
  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2) IS
    ATTR_OUT VARCHAR2(4000);
    ROW_     BL_V_TRANSPORT_NOTED%ROWTYPE;
  
  BEGIN
  
    --RAISE_APPLICATION_ERROR(-20101, '�����rowid=' || ROWLIST_);
    --PKG_A.SETMSG(A311_KEY_, '', '�����ɳ�' || '���´����ȡ��');
    RETURN;
    RETURN;
    --��ȡ�û�Ĭ�ϵ���
    /*
    ATTR_OUT := PKG_A.GET_ATTR_BY_BM(ROWLIST_);
    PKG_A.SET_ITEM_VALUE('ENTER_USER', USER_ID_, ATTR_OUT);
    PKG_A.SET_ITEM_VALUE('ENTER_DATE',
                         TO_CHAR(SYSDATE, 'yyyy-mm-dd'),
                         ATTR_OUT);
    
    ROW_.CONTRACT := PKG_ATTR.GET_DEFAULT_CONTRACT(USER_ID_);
    
    IF (NVL(ROW_.CONTRACT, '0') <> '0') THEN
      PKG_A.SET_ITEM_VALUE('CONTRACT', ROW_.CONTRACT, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('STATE', '0', ATTR_OUT);
    END IF;
    
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

  PROCEDURE CANCEL__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
    INFO_           VARCHAR2(4000);
    ROW_            BL_V_TRANSPORT_NOTED%ROWTYPE;
    CUR_            T_CURSOR;
    ATTR_           VARCHAR2(4000);
    ACTION_         VARCHAR2(20);
    LOCATION_GROUP_ VARCHAR2(20);
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTED T WHERE T.OBJID = ROWLIST_;
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
                   '�ͻ�����' || ROW_.NOTE_NO || '���´����ȡ��');
      RETURN;
    END IF;
  
    --���¶��յ��Ķ�����ϸ״̬--
    UPDATE BL_BOOKINGLIST_DTL
       SET STATE = '1'
     WHERE PICKLISTNO = ROW_.PICKLISTNO;
      UPDATE BL_BOOKINGLIST 
       SET STATE = '1'
     WHERE booking_no = row_.booking_no;
    UPDATE BL_TRANSPORT_NOTE SET STATE = '3' WHERE ROWID = ROW_.OBJID;
     UPDATE BL_TRANSPORT_NOTECONTRACT
       SET STATE = '3'
     WHERE NOTE_NO = row_.NOTE_NO;
  
    --raise_application_error(-20101, '�Ѿ��ƿⲻ��ȡ���Ǽǵ��');
    --return ;                                             
    PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_TRANSPORT_NOTED', ROW_.OBJID);
    PKG_A.SETMSG(A311_KEY_, '', '�ͻ�����' || ROW_.NOTE_NO || 'ȡ���ɹ���');
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
    ROW_        BL_V_TRANSPORT_NOTED%ROWTYPE;
    CUR_        T_CURSOR;
    PICKLISTNO_ VARCHAR(50);
    CONTRACT_   VARCHAR(50);
  
  BEGIN
    INDEX_    := F_GET_DATA_INDEX();
    OBJID_    := PKG_A.GET_ITEM_VALUE('OBJID', INDEX_ || ROWLIST_);
    DOACTION_ := PKG_A.GET_ITEM_VALUE('DOACTION', ROWLIST_);
    IF DOACTION_ = 'I' THEN
      --  ��ȡֵ
      ROW_.NOTE_NO      := GET_NOTE_NO('D');
      ROW_.NOTETYPE     := 'D';
     --- ROW_.CONTRACT     := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
      ROW_.BOOKING_NO   := PKG_A.GET_ITEM_VALUE('BOOKING_NO', ROWLIST_);
    --  ROW_.EXPRESSID    := PKG_A.GET_ITEM_VALUE('EXPRESSID', ROWLIST_);
      ROW_.PICKLISTNO   := PKG_A.GET_ITEM_VALUE('PICKLISTNO', ROWLIST_);
    --  ROW_.EXITPORT     := PKG_A.GET_ITEM_VALUE('EXITPORT', ROWLIST_);
    --  ROW_.SHIPDATE     := PKG_A.GET_ITEM_VALUE('SHIPDATE', ROWLIST_);
      ROW_.SHIPTIME     := TO_DATE(PKG_A.GET_ITEM_VALUE('SHIPTIME',
                                                        ROWLIST_),
                                   'YYYY-MM-DD HH24:MI:SS');
    --  ROW_.SHIPPINGMARK := PKG_A.GET_ITEM_VALUE('SHIPPINGMARK', ROWLIST_);
      ROW_.DOCUADDRS    := PKG_A.GET_ITEM_VALUE('DOCUADDRS', ROWLIST_);
      ROW_.REMARK       := PKG_A.GET_ITEM_VALUE('REMARK', ROWLIST_);
      ROW_.STATE        := '0';
    --  ROW_.VENDOR_NO    := PKG_A.GET_ITEM_VALUE('VENDOR_NO', ROWLIST_);
    
      -- ������һ��Ĭ��ֵ
      --row_.CREATEDATE:=to_char(sysdate,'yyyy-mm-dd');--pkg_a.Get_Item_Value('CREATEDATE',ROWLIST_ );
    
      IF CHECK_DUPLICATE(ROW_.CONTRACT, ROW_.PICKLISTNO) = FALSE THEN
        RAISE_APPLICATION_ERROR(-20101, '�˱������Ѵ��ڣ�');
        RETURN;
      END IF;
    
/*      --���¶��յ��Ķ�����ϸ״̬:22
      UPDATE BL_BOOKINGLIST_DTL
         SET STATE = '22'
       WHERE PICKLISTNO = ROW_.PICKLISTNO;*/
    
      --��������
      INSERT INTO BL_TRANSPORT_NOTE
        (NOTE_NO,
         NOTETYPE,
         CONTRACT,
         BOOKING_NO,
        -- EXPRESSID,
         PICKLISTNO,
        -- EXITPORT,
        -- SHIPDATE,
         SHIPTIME,
       --  SHIPPINGMARK,
         DOCUADDRS,
         REMARK,
         STATE--,
         --VENDOR_NO
         )
        SELECT ROW_.NOTE_NO,
               ROW_.NOTETYPE,
               ROW_.CONTRACT,
               ROW_.BOOKING_NO,
            --   ROW_.EXPRESSID,
               ROW_.PICKLISTNO,
            --   ROW_.EXITPORT,
              -- ROW_.SHIPDATE,
               ROW_.SHIPTIME,
           --    ROW_.SHIPPINGMARK,
               ROW_.DOCUADDRS,
               ROW_.REMARK,
               ROW_.STATE--,
               --ROW_.VENDOR_NO
          FROM DUAL;
    
      SELECT T.ROWID
        INTO OBJID_
        FROM BL_V_TRANSPORT_NOTED T
       WHERE T.NOTE_NO = ROW_.NOTE_NO;
     --modify fjp 2013-01-06 ������ϸ
      insert into BL_TRANSPORT_NOTECONTRACT(  note_no   ,
                                              contract    ,
                                              containerno  ,
                                              state )
       SELECT DISTINCT ROW_.NOTE_NO,supplier,'0',ROW_.STATE
          from bl_putincase_m b
         where b.picklistno = ROW_.PICKLISTNO
         and   NOT EXISTS (SELECT '1'
          FROM BL_V_TRANSPORT_NOTEC C
         where C.picklistno = ROW_.PICKLISTNO
           AND C.STATE <> '3'
           and C.CONTRACT = b.supplier);
        ---end----
      ---���¶���ί��modify fjp 2013-01-25
      UPDATE BL_BOOKINGLIST_DTL
         SET STATE = '2'
       WHERE PICKLISTNO = ROW_.PICKLISTNO;
      UPDATE BL_BOOKINGLIST t
         SET t.STATE = '2'
       WHERE t.BOOKING_NO = ROW_.BOOKING_NO
         and not exists(select 1 
                          from BL_BOOKINGLIST_DTL t1 
                         where t1.BOOKING_NO=t.BOOKING_NO
                           and t1.state in ('0','1'));
      ---end-----
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_TRANSPORT_NOTE', OBJID_);
      RETURN;
    END IF;
    IF DOACTION_ = 'M' THEN
      -- ��������
      OPEN CUR_ FOR
        SELECT T.* FROM BL_V_TRANSPORT_NOTED T WHERE T.OBJID = OBJID_;
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
                       '�ͻ�����' || ROW_.NOTE_NO || '���´�����޸�');
          CLOSE CUR_;
          RETURN;
        END IF;
      END IF;
      CLOSE CUR_;
    --���������޸ı�����MODIFY 2013-01-25
/*      PICKLISTNO_ := PKG_A.GET_ITEM_VALUE('PICKLISTNO', ROWLIST_);
      CONTRACT_   := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
      IF CHECK_DUPLICATE(CONTRACT_, PICKLISTNO_) = FALSE THEN
        RAISE_APPLICATION_ERROR(-20101, '�˱������Ѵ��ڣ�');
        RETURN;
      END IF;
      IF PICKLISTNO_ <> ROW_.PICKLISTNO THEN
        UPDATE BL_BOOKINGLIST_DTL
           SET STATE = '1'
         WHERE PICKLISTNO = ROW_.PICKLISTNO;
        UPDATE BL_BOOKINGLIST_DTL
           SET STATE = '22'
         WHERE PICKLISTNO = PICKLISTNO_;
      
      END IF;*/
    
      DATA_ := ROWLIST_;
    
      POS_       := INSTR(DATA_, INDEX_);
      I          := I + 1;
      MYSQL_     := ' update BL_TRANSPORT_NOTE set ';
      IFMYCHANGE := '0';
      LOOP
        EXIT WHEN NVL(POS_, 0) <= 0;
        EXIT WHEN I > 300;
        V_    := SUBSTR(DATA_, 1, POS_ - 1);
        DATA_ := SUBSTR(DATA_, POS_ + 1);
        POS_  := INSTR(DATA_, INDEX_);
      
        POS1_      := INSTR(V_, '|');
        COLUMN_ID_ := SUBSTR(V_, 1, POS1_ - 1);
        IF COLUMN_ID_ <> 'OBJID' AND COLUMN_ID_ <> 'CONTRACTDESC' AND
           COLUMN_ID_ <> 'DOACTION' AND LENGTH(NVL(COLUMN_ID_, '')) > 0 THEN
          V_ := SUBSTR(V_, POS1_ + 1);
          I  := I + 1;
        
          IFMYCHANGE := '1';
          IF COLUMN_ID_ = 'ENTER_DATE' OR COLUMN_ID_ = 'MODI_DATE' OR
             COLUMN_ID_ = 'SHIPTIME' THEN
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
        /*
          MYSQL_ := MYSQL_ || ',modi_date=sysdate,modi_user=''' || USER_ID_ ||
                    ''' where rowidtochar(rowid)=''' || OBJID_ || '''';
        
          --RAISE_APPLICATION_ERROR(-20101, '�����rowid=' || MYSQL_);
          EXECUTE IMMEDIATE 'begin ' || MYSQL_ || ';end;';
        */
      END IF;
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_TRANSPORT_NOTE', OBJID_);
      RETURN;
    END IF;
  END;

  PROCEDURE TRANSFROM__(ROWLIST_  VARCHAR2,
                        USER_ID_  VARCHAR2,
                        A311_KEY_ VARCHAR2) IS
    ROW_       BL_V_BOOKINGLIST%ROWTYPE;
    ROWDETAIL_ BL_V_BOOKINGLIST_DTL%ROWTYPE;
    ROWNOTE_   BL_TRANSPORT_NOTE%ROWTYPE;
    CUR_       T_CURSOR;
    ATTR_      VARCHAR2(4000);
    MYSQL_     VARCHAR2(4000);
  BEGIN
  
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_BOOKINGLIST T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_BOOKINGLIST', ROW_.OBJID);
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    OPEN CUR_ FOR
      SELECT *
        FROM BL_V_BOOKINGLIST_DTL
       WHERE BOOKING_NO = ROW_.BOOKING_NO;
    FETCH CUR_
      INTO ROWDETAIL_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETMSG(A311_KEY_,
                   '',
                   '�ͻ�����' || ROW_.BOOKING_NO || 'û����ϸ�޷�ת�����ɳ�������');
      RETURN;
    END IF;
  
    UPDATE BL_BOOKINGLIST SET STATE = '2' WHERE ROWID = ROW_.OBJID;
  
    ROWNOTE_.NOTE_NO := GET_NOTE_NO('A');
    INSERT INTO BL_TRANSPORT_NOTE
      (NOTE_NO,
       BOOKING_NO,
       NOTETYPE,
       CONTRACT,
       EXPRESSID,
       PICKLISTNO,
       EXITPORT,
       SHIPDATE,
       SHIPTIME,
       SHIPPINGMARK,
       DOCUADDRS,
       REMARK,
       STATE,
       VENDOR_NO)
      SELECT ROWNOTE_.NOTE_NO,
             ROW_.BOOKING_NO,
             'A',
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             NULL,
             0,
             NULL
        FROM DUAL;
  
    INSERT INTO BL_TRANSPORT_NOTEDTL
      (NOTE_NO, PICKLISTNO, STATE)
      SELECT ROWNOTE_.NOTE_NO, PICKLISTNO, 0
        FROM BL_V_BOOKINGLIST_DTL
       WHERE BOOKING_NO = ROW_.BOOKING_NO;
  
    PKG_A.SETMSG(A311_KEY_,
                 '',
                 '02MainForm.aspx?option=M&A002KEY=800102&key=' ||
                 ROWNOTE_.NOTE_NO || '&CODE=0');
  
  END;

  PROCEDURE CONFIRM__(ROWLIST_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2) IS
    ROW_ BL_V_TRANSPORT_NOTED%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTED T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_TRANSPORT_NOTED', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
    UPDATE BL_TRANSPORT_NOTE SET STATE = '1' WHERE ROWID = ROW_.OBJID;
/*  
    UPDATE BL_TRANSPORT_NOTEDTL
       SET STATE = '1'
     WHERE NOTE_NO =
           (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);*/
  
    UPDATE BL_TRANSPORT_NOTECONTRACT
       SET STATE = '1'
     WHERE NOTE_NO = ROW_.note_NO;
     --      (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    PKG_A.SETMSG(A311_KEY_, '', '�ͻ������´�ɹ�');
  
    RETURN;
  END;
  PROCEDURE CONFIRMCANCEL__(ROWLIST_  VARCHAR2,
                            USER_ID_  VARCHAR2,
                            A311_KEY_ VARCHAR2)
  is 
    ROW_ BL_V_TRANSPORT_NOTED%ROWTYPE;
    CUR_ T_CURSOR;
  begin
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTED T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_TRANSPORT_NOTED', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
    UPDATE BL_TRANSPORT_NOTE SET STATE = '0' WHERE ROWID = ROW_.OBJID;
  
    UPDATE BL_TRANSPORT_NOTEDTL
       SET STATE = '0'
     WHERE NOTE_NO = row_.NOTE_NO;
          -- (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    UPDATE BL_TRANSPORT_NOTECONTRACT
       SET STATE = '0'
     WHERE NOTE_NO = row_.NOTE_NO;
         --  (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    PKG_A.SETMSG(A311_KEY_, '', '�ͻ�����ȡ���´�ɹ�');
  
    RETURN;
  end;
  --�Ҽ��رչ���--
  PROCEDURE CLOSE__(ROWLIST_  VARCHAR2,
                    USER_ID_  VARCHAR2,
                    A311_KEY_ VARCHAR2) IS
    ROW_ BL_V_TRANSPORT_NOTED%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTED T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_TRANSPORT_NOTED', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    UPDATE BL_V_TRANSPORT_NOTED SET STATE = '4' WHERE ROWID = ROW_.OBJID;
  
    PKG_A.SETMSG(A311_KEY_, '', '�ͻ�����رճɹ�');
  
    RETURN;
  END;

  PROCEDURE DENY__(ROWLIST_  VARCHAR2,
                   USER_ID_  VARCHAR2,
                   A311_KEY_ VARCHAR2) IS
    CUR_ T_CURSOR;
    ROW_ BL_V_BOOKINGLIST%ROWTYPE;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_BOOKINGLIST T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_BOOKINGLIST', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
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
    ATTR_OUT VARCHAR2(4000);
    ROW_     SITE_TAB%ROWTYPE;
    ROWPB_   BL_V_DISTPICKLIST_BOOKING%ROWTYPE;
    ROW2_    BL_V_BOOKINGLIST%ROWTYPE;
    CUR_     T_CURSOR;
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
      PKG_A.SET_ITEM_VALUE('CONTRACTDESC', ROW_.CONTRACT_REF, ATTR_OUT);
    END IF;
  
    IF COLUMN_ID_ = 'PICKLISTNO' THEN
      ROWPB_.PICKLISTNO := PKG_A.GET_ITEM_VALUE('PICKLISTNO', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_DISTPICKLIST_BOOKING T
         WHERE T.PICKLISTNO = ROWPB_.PICKLISTNO;
      FETCH CUR_
        INTO ROWPB_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '�����rowid');
        RETURN;
      END IF;
      CLOSE CUR_;
      -- ��ֵ
      PKG_A.SET_ITEM_VALUE('BOOKING_NO', ROWPB_.BOOKING_NO, ATTR_OUT);
            --���Ҵ���--
      OPEN CUR_ FOR
        SELECT *
          FROM BL_V_BOOKINGLIST T
         WHERE T.BOOKING_NO = ROWPB_.BOOKING_NO;
      FETCH CUR_
        INTO ROW2_;
    
      IF CUR_%FOUND THEN
       -- PKG_A.SET_ITEM_VALUE('SHIPDATE', ROW2_.SHIPMENT, ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('SHIPMENT', ROW2_.SHIPMENT, ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('SHIPPINGMARK', ROW2_.SHIPPINGMARK, ATTR_OUT);
      END IF;
      CLOSE CUR_;
    END IF;
  
    OUTROWLIST_ := ATTR_OUT;
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
    ROW_ BL_V_BOOKINGLIST%ROWTYPE;
  BEGIN
    ROW_.OBJID := PKG_A.GET_ITEM_VALUE('OBJID', ROWLIST_);
    ROW_.STATE := PKG_A.GET_ITEM_VALUE('STATE', ROWLIST_);
    --�����󱸻��������޸�modify fjp 2013-01-25
    IF NVL(ROW_.OBJID,'NULL') <> 'NULL' AND COLUMN_ID_ ='PICKLISTNO'  THEN 
       RETURN  '0';
    END IF ;
    IF ROW_.STATE != 0 THEN
      IF COLUMN_ID_ = 'CONTRACT' OR COLUMN_ID_ = 'PICKLISTNO' OR
         COLUMN_ID_ = 'BOOKING_NO' OR COLUMN_ID_ = 'SHIPTIME' OR
         COLUMN_ID_ = 'SHIPPINGMARK' OR COLUMN_ID_ = 'REMARK' OR
         COLUMN_ID_ = 'DOCUADDRS' THEN
        RETURN '0';
      ELSE
        RETURN '1';
      END IF;
    END IF;
  END;

  /*��ȡ��λ����*/
  FUNCTION GET_NOTE_NO(TYPE_ VARCHAR2) RETURN VARCHAR2 IS
    ROW_  BL_V_TRANSPORT_NOTED%ROWTYPE;
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
  FUNCTION CHECK_DUPLICATE(CONTRACT_ IN VARCHAR2, PICKLISTNO_ IN VARCHAR2)
    RETURN BOOLEAN IS
    CUR  T_CURSOR;
    ROW_ BL_V_TRANSPORT_NOTEC%ROWTYPE;
  BEGIN
    OPEN CUR FOR
      SELECT *
        FROM BL_V_TRANSPORT_NOTEC T
       WHERE T.CONTRACT = CONTRACT_
         AND T.PICKLISTNO = PICKLISTNO_
         AND NOTETYPE = 'C';
    FETCH CUR
      INTO ROW_;
  
    IF CUR %NOTFOUND THEN
      CLOSE CUR;
      RETURN TRUE;
    ELSE
      CLOSE CUR;
      RETURN FALSE;
    END IF;
  END;
END BL_TRANSPORT_NOTED_API;
/
