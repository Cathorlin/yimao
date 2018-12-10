CREATE OR REPLACE PACKAGE BL_TRANSPORT_NOTE_API IS

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
  FUNCTION CHECK_PICKLISTNO_(OBJID_ VARCHAR2) RETURN BOOLEAN;
  FUNCTION CHECK_CONTRACT_(OBJID_ VARCHAR2) RETURN BOOLEAN;
  --��ȡ����
  FUNCTION GET_NOTE_NO(TYPE_ VARCHAR2) RETURN VARCHAR2;
  FUNCTION GET_TRANSFORM_NO(BOOKING_NO_ VARCHAR2) RETURN VARCHAR2;
  PROCEDURE CLOSE__(ROWLIST_  VARCHAR2,
                    USER_ID_  VARCHAR2,
                    A311_KEY_ VARCHAR2);
  -- ����ȡ��֪ͨ                 
  PROCEDURE ALLCANCEL__(rowid_  VARCHAR2,
                        USER_ID_  VARCHAR2,
                        A311_KEY_ VARCHAR2);
END BL_TRANSPORT_NOTE_API;
/
CREATE OR REPLACE PACKAGE BODY BL_TRANSPORT_NOTE_API IS
  TYPE T_CURSOR IS REF CURSOR;
  /*  ������ʼ�� New__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���requseturl ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ 
  modify fjp 2013-01-15 ���������ɳ��ֶ�
  modify fjp 2013-03-12����ȡ��*/
  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2) IS
    ATTR_OUT    VARCHAR2(4000);
    ROW_        BL_V_TRANSPORT_NOTE%ROWTYPE;
    ROWBOOKING_ BL_V_BOOKINGLIST%ROWTYPE;
    REQUESTURL_ VARCHAR2(4000);
    CUR_        T_CURSOR;
  
  BEGIN
  
    REQUESTURL_            := PKG_A.GET_ITEM_VALUE('REQUESTURL', ROWLIST_);
    ROWBOOKING_.BOOKING_NO := PKG_A.GET_ITEM_VALUE_BY_INDEX('&BOOKING_NO=',
                                                            '&',
                                                            REQUESTURL_);
  
    IF ROWBOOKING_.BOOKING_NO IS NOT NULL THEN
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_BOOKINGLIST T
         WHERE T.BOOKING_NO = ROWBOOKING_.BOOKING_NO;
      FETCH CUR_
        INTO ROWBOOKING_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        PKG_A.SETFAILED(A311_KEY_, 'BL_BOOKINGLIST', ROW_.OBJID);
        RAISE_APPLICATION_ERROR(-20101, '�����rowid');
        RETURN;
      END IF;
      CLOSE CUR_;
      --TRANSFROM__(ROWBOOKING_.BOOKING_NO, USER_ID_, A311_KEY_);
      PKG_A.SET_ITEM_VALUE('BOOKING_NO', ROWBOOKING_.BOOKING_NO, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('NOTETYPE', 'A', ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('EXITPORT', ROWBOOKING_.EXITPORT, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('EXITPORTDESC',
                           IFSAPP.SALES_DISTRICT_API.GET_DESCRIPTION(ROWBOOKING_.EXITPORT),
                           ATTR_OUT);
    
      PKG_A.SET_ITEM_VALUE('SHIPDATE',
                           TO_CHAR(TO_DATE(ROWBOOKING_.SHIPMENT,
                                           'YYYY-MM-DD'),
                                   'YYYY-MM-DD'),
                           ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('STATE', '0', ATTR_OUT);
    END IF;
  
    --RAISE_APPLICATION_ERROR(-20101, '��ʾ��Ϣ=' || ROWBOOKING_.BOOKING_NO);
    PKG_A.SETRESULT(A311_KEY_, ATTR_OUT);
    RETURN;
  END;

  PROCEDURE CANCEL__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
    INFO_           VARCHAR2(4000);
    ROW_            BL_V_TRANSPORT_NOTE%ROWTYPE;
    CUR_            T_CURSOR;
    ATTR_           VARCHAR2(4000);
    ACTION_         VARCHAR2(20);
    LOCATION_GROUP_ VARCHAR2(20);
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTE T WHERE T.OBJID = ROWLIST_;
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
                   '�����ɳ�' || ROW_.NOTE_NO || '���´����ȡ��');
      RETURN;
    END IF;
  
    --���¶��յ��Ķ�����ϸ״̬--
  
    UPDATE BL_BOOKINGLIST
       SET STATE = '1'
     WHERE BOOKING_NO = ROW_.BOOKING_NO;
    UPDATE BL_BOOKINGLIST_DTL
       SET STATE = '1'
     WHERE BOOKING_NO = ROW_.BOOKING_NO;
  
    UPDATE BL_TRANSPORT_NOTE SET STATE = '3' WHERE ROWID = ROW_.OBJID;
  
    UPDATE BL_TRANSPORT_NOTEDTL
       SET STATE = '3'
     WHERE NOTE_NO =
           (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    UPDATE BL_V_TRANSPORT_NOTECONTRACT
       SET STATE = '3'
     WHERE NOTE_NO =
           (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    --raise_application_error(-20101, '�Ѿ��ƿⲻ��ȡ���Ǽǵ��');
    --return ;                                             
    PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_BOOKINGLIST', ROW_.OBJID);
    PKG_A.SETMSG(A311_KEY_, '', '�����ɳ�' || ROW_.NOTE_NO || 'ȡ���ɹ���');
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
    POS_       NUMBER;
    POS1_      NUMBER;
    I          NUMBER;
    V_         VARCHAR(1000);
    COLUMN_ID_ VARCHAR(1000);
    DATA_      VARCHAR(4000);
    MYSQL_     VARCHAR2(4000);
    IFMYCHANGE VARCHAR2(1);
    OBJID_     VARCHAR2(100);
    ROW_       BL_V_TRANSPORT_NOTE%ROWTYPE;
    ROWDETAIL_ BL_V_BOOKINGLIST_DTL%ROWTYPE;
    CUR_       T_CURSOR;
  
  BEGIN
    INDEX_    := F_GET_DATA_INDEX();
    OBJID_    := PKG_A.GET_ITEM_VALUE('OBJID', INDEX_ || ROWLIST_);
    DOACTION_ := PKG_A.GET_ITEM_VALUE('DOACTION', ROWLIST_);
    IF DOACTION_ = 'I' THEN
      --  ��ȡֵ
      ROW_.NOTE_NO      := GET_NOTE_NO('A');
      ROW_.NOTETYPE     := PKG_A.GET_ITEM_VALUE('NOTETYPE', ROWLIST_);
      ROW_.CONTRACT     := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
      ROW_.EXPRESSID    := PKG_A.GET_ITEM_VALUE('EXPRESSID', ROWLIST_);
      ROW_.PICKLISTNO   := PKG_A.GET_ITEM_VALUE('PICKLISTNO', ROWLIST_);
    --  modify fjp 2013-01-15 ȡ�Զ���
     -- ROW_.EXITPORT     := PKG_A.GET_ITEM_VALUE('EXITPORT', ROWLIST_);
     -- ROW_.SHIPDATE     := PKG_A.GET_ITEM_VALUE('SHIPDATE', ROWLIST_);
      ROW_.SHIPTIME     := TO_DATE(PKG_A.GET_ITEM_VALUE('SHIPTIME',
                                                       ROWLIST_),
                                  'YYYY-MM-DD HH24:MI:SS');
     -- ROW_.SHIPPINGMARK := PKG_A.GET_ITEM_VALUE('SHIPPINGMARK', ROWLIST_);
     ------end-----
      ROW_.DOCUADDRS    := PKG_A.GET_ITEM_VALUE('DOCUADDRS', ROWLIST_);
      ROW_.REMARK       := PKG_A.GET_ITEM_VALUE('REMARK', ROWLIST_);
      ROW_.STATE        := PKG_A.GET_ITEM_VALUE('STATE', ROWLIST_);
      --modify fjp 2013-01-15������Ҫ
    --  ROW_.VENDOR_NO    := PKG_A.GET_ITEM_VALUE('VENDOR_NO', ROWLIST_);
      ROW_.BOOKING_NO   := PKG_A.GET_ITEM_VALUE('BOOKING_NO', ROWLIST_);
      -- ������һ��Ĭ��ֵ
      --row_.CREATEDATE:=to_char(sysdate,'yyyy-mm-dd');--pkg_a.Get_Item_Value('CREATEDATE',ROWLIST_ );
    
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
                     '����ί��' || ROW_.BOOKING_NO || 'û����ϸ�޷�ת�����ɳ�������');
        RETURN;
      END IF;
    
      --��������
      INSERT INTO BL_TRANSPORT_NOTE
        (NOTE_NO,
         NOTETYPE,
         CONTRACT,
         EXPRESSID,
         PICKLISTNO,
       --  EXITPORT, modify fjp 2013-01-15 ȡ�Զ���
       --  SHIPDATE, modify fjp 2013-01-15 ȡ�Զ���
         SHIPTIME, 
       --  SHIPPINGMARK, modify fjp 2013-01-15 ȡ�Զ���
         DOCUADDRS,
         REMARK,
         STATE,
      --   VENDOR_NO,
         BOOKING_NO)
        SELECT ROW_.NOTE_NO,
               ROW_.NOTETYPE,
               ROW_.CONTRACT,
               ROW_.EXPRESSID,
               ROW_.PICKLISTNO,
             --  ROW_.EXITPORT,
             --  ROW_.SHIPDATE,
               ROW_.SHIPTIME,
             --  ROW_.SHIPPINGMARK,
               ROW_.DOCUADDRS,
               ROW_.REMARK,
               ROW_.STATE,
             --  ROW_.VENDOR_NO,
               ROW_.BOOKING_NO
          FROM DUAL;
    
      SELECT T.ROWID
        INTO OBJID_
        FROM BL_V_TRANSPORT_NOTE T
       WHERE T.NOTE_NO = ROW_.NOTE_NO;
    
      --���뵽�ɳ��ĵ�����ϸ--
      INSERT INTO BL_TRANSPORT_NOTEDTL
        (NOTE_NO, PICKLISTNO, STATE, CONTAINERNO)
        SELECT ROW_.NOTE_NO, PICKLISTNO, 0, '0'
          FROM BL_V_BOOKINGLIST_DTL
         WHERE BOOKING_NO = ROW_.BOOKING_NO
           AND STATE = '1';
    
      /*
             AND NOT EXISTS
           (SELECT 1
                    FROM BL_TRANSPORT_NOTEDTL
                   WHERE BL_V_BOOKINGLIST_DTL.PICKLISTNO =
                         BL_TRANSPORT_NOTEDTL.PICKLISTNO);
      */
      UPDATE BL_BOOKINGLIST
         SET STATE = '2'
       WHERE BOOKING_NO = ROW_.BOOKING_NO;
      UPDATE BL_BOOKINGLIST_DTL
         SET STATE = '2'
       WHERE BOOKING_NO = ROW_.BOOKING_NO;
    
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_TRANSPORT_NOTE', OBJID_);
      RETURN;
    END IF;
    IF DOACTION_ = 'M' THEN
      -- ��������
      OPEN CUR_ FOR
        SELECT T.* FROM BL_V_TRANSPORT_NOTE T WHERE T.OBJID = OBJID_;
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
                       '����ί��' || ROW_.NOTE_NO || '��ȷ�ϣ������޸�');
          CLOSE CUR_;
          RETURN;
        END IF;
      END IF;
      CLOSE CUR_;
    
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
        IF COLUMN_ID_ <> 'OBJID' AND COLUMN_ID_ <> 'DOACTION' AND
           COLUMN_ID_ <> 'EXITPORTDESC' AND COLUMN_ID_ <> 'AIMPORTDESC' AND
           COLUMN_ID_ <> 'PISEL' AND COLUMN_ID_ <> 'SHIPBYDESC' AND
           COLUMN_ID_ <> 'VENDOR_DESC' AND LENGTH(NVL(COLUMN_ID_, '')) > 0 THEN
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
    
      INSERT INTO BL_TRANSPORT_NOTEDTL
        (NOTE_NO, PICKLISTNO, STATE, CONTAINERNO)
        SELECT ROW_.NOTE_NO, PICKLISTNO, 0, '0'
          FROM BL_V_BOOKINGLIST_DTL
         WHERE BOOKING_NO = ROW_.BOOKING_NO
           AND STATE = '1';
      UPDATE BL_BOOKINGLIST
         SET STATE = '2'
       WHERE BOOKING_NO = ROW_.BOOKING_NO;
      UPDATE BL_BOOKINGLIST_DTL
         SET STATE = '2'
       WHERE BOOKING_NO = ROW_.BOOKING_NO;
    
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_TRANSPORT_NOTE', OBJID_);
      RETURN;
    END IF;
  END;
  /*  ת������ί��Ϊ�����ɳ� TRANSFROM__
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
  */
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
      SELECT T.* FROM BL_V_BOOKINGLIST T WHERE T.BOOKING_NO = ROWLIST_;
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
                   '����ί��' || ROW_.BOOKING_NO || 'û����ϸ�޷�ת�����ɳ�������');
      RETURN;
    END IF;
  
    UPDATE BL_BOOKINGLIST SET STATE = '2' WHERE ROWID = ROW_.OBJID;
    UPDATE BL_BOOKINGLIST_DTL
       SET STATE = '2'
     WHERE BOOKING_NO = ROW_.BOOKING_NO;
    ROWNOTE_.NOTE_NO := GET_NOTE_NO('A');
    --�����ɳ�����--
    INSERT INTO BL_TRANSPORT_NOTE
      (NOTE_NO,
       BOOKING_NO,
       NOTETYPE,
       CONTRACT,
       EXPRESSID,
       PICKLISTNO,
     --  EXITPORT, modify fjp 2013-01-15 ȡ�Զ���
     --  SHIPDATE, modify fjp 2013-01-15 ȡ�Զ���
       SHIPTIME,
      -- SHIPPINGMARK, modify fjp 2013-01-15 ȡ�Զ���
       DOCUADDRS,
       REMARK,
       STATE--,
       --VENDOR_NO modify fjp 2013-01-15 ȡ�Զ���
       )
      SELECT ROWNOTE_.NOTE_NO,
             ROW_.BOOKING_NO,
             'A',
             NULL,
             NULL,
             NULL,
            -- ROW_.EXITPORT,
            -- TO_CHAR(TO_DATE(ROW_.SHIPMENT, 'YYYY-MM-DD'), 'YYYY-MM-DD'),
             NULL,
            -- NULL,
             NULL,
             NULL,
             0--,
            -- NULL
        FROM DUAL;
    --���뵽�ɳ��ĵ�����ϸ--
    INSERT INTO BL_TRANSPORT_NOTEDTL
      (NOTE_NO, PICKLISTNO, STATE, CONTAINERNO)
      SELECT ROWNOTE_.NOTE_NO, PICKLISTNO, 0, '0'
        FROM BL_V_BOOKINGLIST_DTL
       WHERE BOOKING_NO = ROW_.BOOKING_NO;
    --���뵽�ɳ��Ĺ�����ϸ--
    /*
    PKG_A.SETMSG(A311_KEY_,
                 '',
                 '02MainForm.aspx?option=M&A002KEY=800102&key=' ||
                 ROWNOTE_.NOTE_NO || '&CODE=0');
    */
  
  END;

  PROCEDURE CONFIRM__(ROWLIST_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2) IS
    ROW_ BL_V_TRANSPORT_NOTE%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTE T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_TRANSPORT_NOTE', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
    --�жϱ��������Ƿ�����--
    IF CHECK_PICKLISTNO_(ROWLIST_) = FALSE THEN
      RAISE_APPLICATION_ERROR(-20101, '�������Ų�ƥ��');
    END IF;
    --�жϹ�����������--
    IF CHECK_CONTRACT_(ROWLIST_) = FALSE THEN
      RAISE_APPLICATION_ERROR(-20101, '������ƥ��');
    END IF;
    --�ж��ļ��Ƿ��ϴ�--
    IF NVL(ROW_.DOCUADDRS, '0') = '0' THEN
      RAISE_APPLICATION_ERROR(-20101, 'ȱ���ļ�');
    END IF;
  
    UPDATE BL_TRANSPORT_NOTE SET STATE = '1' WHERE ROWID = ROW_.OBJID;
  
    UPDATE BL_TRANSPORT_NOTEDTL
       SET STATE = '1'
     WHERE NOTE_NO =
           (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    UPDATE BL_V_TRANSPORT_NOTECONTRACT
       SET STATE = '1'
     WHERE NOTE_NO =
           (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    PKG_A.SETMSG(A311_KEY_, '', '�����ɳ�ȷ�ϳɹ�');
  
    RETURN;
  END;
  PROCEDURE CONFIRMCANCEL__(ROWLIST_  VARCHAR2,
                            USER_ID_  VARCHAR2,
                            A311_KEY_ VARCHAR2)
  is
   ROW_ BL_V_TRANSPORT_NOTE%ROWTYPE;
   CUR_ T_CURSOR;
  begin
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTE T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_TRANSPORT_NOTE', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;

    UPDATE BL_TRANSPORT_NOTE SET STATE = '0' WHERE ROWID = ROW_.OBJID;
  
    UPDATE BL_TRANSPORT_NOTEDTL
       SET STATE = '0'
     WHERE NOTE_NO = row_.NOTE_NO;
         --  (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    UPDATE BL_V_TRANSPORT_NOTECONTRACT
       SET STATE = '0'
     WHERE NOTE_NO =row_.NOTE_NO;
           --(SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    PKG_A.SETMSG(A311_KEY_, '', '�����ɳ�ȷ�ϳɹ�');
  
    RETURN;
  end;
  --�Ҽ��رչ���--
  PROCEDURE CLOSE__(ROWLIST_  VARCHAR2,
                    USER_ID_  VARCHAR2,
                    A311_KEY_ VARCHAR2) IS
    ROW_ BL_V_TRANSPORT_NOTE%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTE T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_TRANSPORT_NOTE', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    UPDATE BL_TRANSPORT_NOTE SET STATE = '4' WHERE ROWID = ROW_.OBJID;
  
    UPDATE BL_TRANSPORT_NOTEDTL
       SET STATE = '4'
     WHERE NOTE_NO =
           (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    UPDATE BL_V_TRANSPORT_NOTECONTRACT
       SET STATE = '4'
     WHERE NOTE_NO =
           (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    PKG_A.SETMSG(A311_KEY_, '', '�����ɳ��رճɹ�');
  
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
    ATTR_OUT      VARCHAR2(4000);
    ROW_          BL_V_BOOKINGLIST%ROWTYPE;
    ROW_DIST_     SALES_DISTRICT_TAB%ROWTYPE;
    ROW_PICKHEAD_ BL_V_PICKHEAD_BOOKING%ROWTYPE;
    ROW_VENDOR_   PO_VENDOR_NO%ROWTYPE;
    CUR_          T_CURSOR;
  BEGIN
    IF COLUMN_ID_ = 'PISEL' THEN
      ROW_PICKHEAD_.INVOICE_NO := PKG_A.GET_ITEM_VALUE('PISEL', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT *
          FROM BL_V_PICKHEAD_BOOKING
         WHERE INVOICE_NO = ROW_PICKHEAD_.INVOICE_NO;
      FETCH CUR_
        INTO ROW_PICKHEAD_;
      IF CUR_%FOUND THEN
        PKG_A.SET_ITEM_VALUE('LTO', ROW_PICKHEAD_.TOMU, ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('SHIPBY', ROW_PICKHEAD_.SHIPBY, ATTR_OUT);
      END IF;
      CLOSE CUR_;
    END IF;
  
    IF COLUMN_ID_ = 'EXITPORT' THEN
      ROW_.EXITPORT := PKG_A.GET_ITEM_VALUE('EXITPORT', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT *
          FROM SALES_DISTRICT_TAB
         WHERE DISTRICT_CODE = ROW_.EXITPORT;
      FETCH CUR_
        INTO ROW_DIST_;
      IF CUR_%FOUND THEN
        PKG_A.SET_ITEM_VALUE('EXITPORTDESC',
                             ROW_DIST_.DESCRIPTION,
                             ATTR_OUT);
      END IF;
      CLOSE CUR_;
    END IF;
  
    IF COLUMN_ID_ = 'AIMPORT' THEN
      ROW_.AIMPORT := PKG_A.GET_ITEM_VALUE('AIMPORT', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT *
          FROM SALES_DISTRICT_TAB
         WHERE DISTRICT_CODE = ROW_.AIMPORT;
      FETCH CUR_
        INTO ROW_DIST_;
      IF CUR_%FOUND THEN
        PKG_A.SET_ITEM_VALUE('AIMPORTDESC',
                             ROW_DIST_.DESCRIPTION,
                             ATTR_OUT);
      END IF;
      CLOSE CUR_;
    END IF;
    IF COLUMN_ID_ = 'VENDOR_NO' THEN
      -- ��Ӧ��
      ROW_VENDOR_.VENDOR_NO := PKG_A.GET_ITEM_VALUE('VENDOR_NO', ROWLIST_);
    
      ROW_VENDOR_.VENDOR_NAME := SUPPLIER_API.GET_VENDOR_NAME(ROW_VENDOR_.VENDOR_NO);
      PKG_A.SET_ITEM_VALUE('VENDOR_DESC',
                           ROW_VENDOR_.VENDOR_NAME,
                           ATTR_OUT);
    
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
  
    IF ROW_.STATE != 0 THEN
      IF COLUMN_ID_ = 'EXITPORT' OR COLUMN_ID_ = 'EXITPORTDESC' OR
         COLUMN_ID_ = 'SHIPDATE' OR COLUMN_ID_ = 'SHIPTIME' OR
         COLUMN_ID_ = 'SHIPPINGMARK' OR COLUMN_ID_ = 'REMARK' OR
         COLUMN_ID_ = 'VENDOR_NO' OR COLUMN_ID_ = 'VENDOR_DESC' THEN
        RETURN '0';
      ELSE
        RETURN '1';
      END IF;
    END IF;
  END;

  /*��ȡ��λ����*/
  FUNCTION GET_NOTE_NO(TYPE_ VARCHAR2) RETURN VARCHAR2 IS
    ROW_  BL_V_TRANSPORT_NOTE%ROWTYPE;
    CUR   T_CURSOR;
    SEQW_ NUMBER; --��ˮ��
    SEQ_  VARCHAR2(20);
  
  BEGIN
    -- ��ѯ���ı��²�λ��
    OPEN CUR FOR
      SELECT NVL(MAX(TO_NUMBER(SUBSTR(NOTE_NO, 10, 4))), '0')
        FROM BL_V_TRANSPORT_NOTE T
       WHERE SUBSTR(T.NOTE_NO, 1, 8) =
             TO_CHAR(SYSDATE, 'yyyymm') || '-' || TYPE_;
    FETCH CUR
      INTO SEQW_;
  
    SEQ_ := TO_CHAR(SYSDATE, 'yyyymm') || '-' || TYPE_ || '-' ||
            TRIM(TO_CHAR(SEQW_ + 1, '0000'));
  
    CLOSE CUR;
    RETURN SEQ_;
  END;

  /*��ȡ����*/
  FUNCTION GET_TRANSFORM_NO(BOOKING_NO_ VARCHAR2) RETURN VARCHAR2 IS
    ROW_    BL_TRANSPORT_NOTE%ROWTYPE;
    ROWD_   BL_V_TRANSPORT_NOTEDTL%ROWTYPE;
    CUR     T_CURSOR;
    NOTENO_ VARCHAR2(20);
  
  BEGIN
    -- ��ѯ���ı��²�λ��
    OPEN CUR FOR
      SELECT * FROM BL_TRANSPORT_NOTE T WHERE T.BOOKING_NO = BOOKING_NO_;
    FETCH CUR
      INTO ROW_;
  
    IF CUR%FOUND THEN
      CLOSE CUR;
      RETURN ROW_.NOTE_NO;
    END IF;
    RETURN '';
    CLOSE CUR;
  
  END;
  --���������--
  FUNCTION CHECK_PICKLISTNO_(OBJID_ VARCHAR2) RETURN BOOLEAN IS
    ROW_A  BL_V_TRANSPORT_NOTE%ROWTYPE;
    CUR_A  T_CURSOR;
    ROW_B  BL_V_TRANSPORT_NOTEDTL%ROWTYPE;
    CUR_B  T_CURSOR;
    ROW_C  BL_V_BOOKINGLIST_DTL%ROWTYPE;
    CUR_C  T_CURSOR;
    COUNT1 NUMBER;
    COUNT2 NUMBER;
    ERROR  VARCHAR2(4000) := '';
  BEGIN
    OPEN CUR_A FOR
      SELECT * FROM BL_V_TRANSPORT_NOTE T WHERE T.OBJID = OBJID_;
    FETCH CUR_A
      INTO ROW_A;
    IF CUR_A%NOTFOUND THEN
      CLOSE CUR_A;
      RETURN FALSE;
    END IF;
    CLOSE CUR_A;
  
    OPEN CUR_B FOR
      SELECT *
        FROM BL_V_TRANSPORT_NOTEDTL T
       WHERE T.NOTE_NO = ROW_A.NOTE_NO;
    FETCH CUR_B
      INTO ROW_B;
    LOOP
      EXIT WHEN CUR_B%NOTFOUND;
      OPEN CUR_C FOR
        SELECT *
          FROM BL_V_BOOKINGLIST_DTL T
         WHERE T.BOOKING_NO = ROW_A.BOOKING_NO
           AND T.PICKLISTNO = ROW_B.PICKLISTNO;
      FETCH CUR_C
        INTO ROW_C;
      IF CUR_C%NOTFOUND THEN
        ERROR := ERROR || ROW_B.PICKLISTNO;
      END IF;
      CLOSE CUR_C;
    
      FETCH CUR_B
        INTO ROW_B;
    END LOOP;
    CLOSE CUR_B;
    SELECT COUNT(DISTINCT(T.PICKLISTNO))
      INTO COUNT1
      FROM BL_V_TRANSPORT_NOTEDTL T
     WHERE T.NOTE_NO = ROW_A.NOTE_NO;
    SELECT COUNT(DISTINCT(T.PICKLISTNO))
      INTO COUNT2
      FROM BL_V_BOOKINGLIST_DTL T
     WHERE T.BOOKING_NO = ROW_A.BOOKING_NO;
    IF COUNT1 = COUNT2 AND ERROR IS NULL THEN
      RETURN TRUE;
    END IF;
  
    RETURN FALSE;
  END;
  --��鹤�����������--
  FUNCTION CHECK_CONTRACT_(OBJID_ VARCHAR2) RETURN BOOLEAN IS
    ROW_A  BL_V_TRANSPORT_NOTE%ROWTYPE;
    CUR_A  T_CURSOR;
    COUNT1 NUMBER;
    COUNT2 NUMBER;
  BEGIN
    OPEN CUR_A FOR
      SELECT * FROM BL_V_TRANSPORT_NOTE T WHERE T.OBJID = OBJID_;
    FETCH CUR_A
      INTO ROW_A;
    IF CUR_A%NOTFOUND THEN
      CLOSE CUR_A;
      RETURN FALSE;
    END IF;
    CLOSE CUR_A;
    SELECT COUNT(DISTINCT(T.CONTRACT))
      INTO COUNT1
      FROM BL_V_TRANSPORT_NOTECONTRACT T
     WHERE T.NOTE_NO = ROW_A.NOTE_NO;
  
    SELECT COUNT(DISTINCT(A.SUPPLIER))
      INTO COUNT2
      FROM BL_PUTINCASE_M A
     WHERE A.STATE = '4'
       AND A.PICKLISTNO IN
           (SELECT B.PICKLISTNO
              FROM BL_V_TRANSPORT_NOTEDTL B
             WHERE B.NOTE_NO = ROW_A.NOTE_NO);
    IF COUNT1 = COUNT2 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  
  END;
  --modify fjp 2013-03-12����ȡ��
  PROCEDURE ALLCANCEL__(rowid_  VARCHAR2,
                        USER_ID_  VARCHAR2,
                        A311_KEY_ VARCHAR2)
  is
  cur_ T_CURSOR;
  row_ BL_V_BL_TRANSPORT_NOTE%rowtype;
  begin
     open cur_ for 
     select t.* 
     from BL_V_BL_TRANSPORT_NOTE t 
     where t.objid = rowid_;
     fetch  cur_ into row_;
     if cur_%notfound then
        close cur_;
        PKG_A.SETFAILED(A311_KEY_, 'BL_V_BL_TRANSPORT_NOTE', rowid_);
        RAISE_APPLICATION_ERROR(-20101, '�����rowid');
     end if;
     close cur_;
      update BL_TRANSPORT_NOTECONTRACT
       set  STATE ='0'
       where NOTE_NO = row_.note_no
        and  CONTRACT =row_.contract
        and  state='1';
      update BL_TRANSPORT_NOTE
       set state='0'
       where NOTE_NO = row_.note_no
        and  not exists(select  1 
                       from BL_TRANSPORT_NOTECONTRACT  
                        where   note_no = row_.note_no
                        and    state in('1','4'));
    PKG_A.SETMSG(A311_KEY_, '', '����ȡ���ɹ�');
    return;
  end;
END BL_TRANSPORT_NOTE_API;
/
