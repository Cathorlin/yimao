CREATE OR REPLACE PACKAGE BL_TRANSPORT_NOTEB_API IS

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
  --取消下达                    
  PROCEDURE CONFIRMCancel__(ROWLIST_  VARCHAR2,
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
  --获取编码
  FUNCTION GET_NOTE_NO(TYPE_ VARCHAR2) RETURN VARCHAR2;
  FUNCTION GET_TRANSFORM_NO(BOOKING_NO_ VARCHAR2) RETURN VARCHAR2;
  PROCEDURE CREATE__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
  PROCEDURE CLOSE__(ROWLIST_  VARCHAR2,
                    USER_ID_  VARCHAR2,
                    A311_KEY_ VARCHAR2);
  FUNCTION CHECK_CONTRACT_(OBJID_ VARCHAR2) RETURN BOOLEAN;

END BL_TRANSPORT_NOTEB_API;
/
CREATE OR REPLACE PACKAGE BODY BL_TRANSPORT_NOTEB_API IS
  TYPE T_CURSOR IS REF CURSOR;
  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键
  modify fjp 2013-01-07 */
  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2) IS
    ATTR_OUT VARCHAR2(4000);
    ROW_     BL_V_TRANSPORT_NOTEB%ROWTYPE;
  
  BEGIN
  
    --RAISE_APPLICATION_ERROR(-20101, '错误的rowid=' || ROWLIST_);
    --PKG_A.SETMSG(A311_KEY_, '', '整柜派车' || '已下达，不可取消');
    RETURN;
    RETURN;
    --获取用户默认的域
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
    ROW_            BL_V_TRANSPORT_NOTEB%ROWTYPE;
    CUR_            T_CURSOR;
    ATTR_           VARCHAR2(4000);
    ACTION_         VARCHAR2(20);
    LOCATION_GROUP_ VARCHAR2(20);
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTEB T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
    ---判断状态
    IF ROW_.STATE <> '0' THEN
      PKG_A.SETMSG(A311_KEY_,
                   '',
                   '送货进仓' || ROW_.NOTE_NO || '已下达，不可取消');
      RETURN;
    END IF;
    --更新订舱单的订舱明细状态
    UPDATE BL_BOOKINGLIST_DTL
       SET STATE = '1'
     WHERE PICKLISTNO = ROW_.PICKLISTNO;
    UPDATE BL_BOOKINGLIST 
       SET STATE = '1'
     WHERE booking_no = row_.booking_no;
    --修改送货进仓的主档--
    UPDATE BL_TRANSPORT_NOTE SET STATE = '3' WHERE ROWID = ROW_.OBJID;
    --修改送货进仓的明细--
    UPDATE BL_TRANSPORT_NOTECONTRACT
       SET STATE = '3'
     WHERE NOTE_NO = row_.NOTE_NO;
         --  (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    --raise_application_error(-20101, '已经移库不能取消登记到达！');
    --return ;                                             
    PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_TRANSPORT_NOTEB', ROW_.OBJID);
    PKG_A.SETMSG(A311_KEY_, '', '送货进仓' || ROW_.NOTE_NO || '取消成功！');
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
    ROW_        BL_V_TRANSPORT_NOTEB%ROWTYPE;
    CUR_        T_CURSOR;
    PICKLISTNO_ VARCHAR(50);
  BEGIN
    INDEX_    := F_GET_DATA_INDEX();
    OBJID_    := PKG_A.GET_ITEM_VALUE('OBJID', INDEX_ || ROWLIST_);
    DOACTION_ := PKG_A.GET_ITEM_VALUE('DOACTION', ROWLIST_);
    IF DOACTION_ = 'I' THEN
      --  获取值
      ROW_.NOTE_NO  := GET_NOTE_NO('B');
      ROW_.NOTETYPE := 'B';
      --ROW_.CONTRACT     := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
      --ROW_.EXPRESSID    := PKG_A.GET_ITEM_VALUE('EXPRESSID', ROWLIST_);
      ROW_.PICKLISTNO := PKG_A.GET_ITEM_VALUE('PICKLISTNO', ROWLIST_);
      --ROW_.EXITPORT     := PKG_A.GET_ITEM_VALUE('EXITPORT', ROWLIST_);
     -- ROW_.SHIPDATE     := PKG_A.GET_ITEM_VALUE('SHIPDATE', ROWLIST_);
      ROW_.SHIPTIME     := TO_DATE(PKG_A.GET_ITEM_VALUE('SHIPTIME',
                                                        ROWLIST_),
                                   'YYYY-MM-DD HH24:MI:SS');
     -- ROW_.SHIPPINGMARK := PKG_A.GET_ITEM_VALUE('SHIPPINGMARK', ROWLIST_);
      ROW_.DOCUADDRS    := PKG_A.GET_ITEM_VALUE('DOCUADDRS', ROWLIST_);
      ROW_.REMARK       := PKG_A.GET_ITEM_VALUE('REMARK', ROWLIST_);
      ROW_.STATE        := '0';
      ROW_.BOOKING_NO   := PKG_A.GET_ITEM_VALUE('BOOKING_NO', ROWLIST_);
      --ROW_.VENDOR_NO    := PKG_A.GET_ITEM_VALUE('VENDOR_NO', ROWLIST_);
    
      -- 创建给一个默认值
      --row_.CREATEDATE:=to_char(sysdate,'yyyy-mm-dd');--pkg_a.Get_Item_Value('CREATEDATE',ROWLIST_ );
    
/*      --更新订舱单的订舱明细状态为3 modify 2013-01-25  更新状态为2
      UPDATE BL_BOOKINGLIST_DTL
         SET STATE = '21'
       WHERE PICKLISTNO = ROW_.PICKLISTNO;*/
    
      --插入数据
      INSERT INTO BL_TRANSPORT_NOTE
        (NOTE_NO,
         NOTETYPE,
        -- CONTRACT,
        -- EXPRESSID,
         PICKLISTNO,
        -- EXITPORT,
        -- SHIPDATE,
         SHIPTIME,
       --  SHIPPINGMARK,
         DOCUADDRS,
         REMARK,
         STATE,
       --  VENDOR_NO,
         BOOKING_NO)
        values(ROW_.NOTE_NO,
               ROW_.NOTETYPE,
             --  ROW_.CONTRACT,
             --  ROW_.EXPRESSID,
               ROW_.PICKLISTNO,
             --  ROW_.EXITPORT,
           --    ROW_.SHIPDATE,
               ROW_.SHIPTIME,
             --  ROW_.SHIPPINGMARK,
               ROW_.DOCUADDRS,
               ROW_.REMARK,
               ROW_.STATE,
             --  ROW_.VENDOR_NO,
               ROW_.BOOKING_NO)
         returning rowid into OBJID_;
/*          FROM DUAL;
    
      SELECT T.ROWID
        INTO OBJID_
        FROM BL_V_TRANSPORT_NOTE T
       WHERE T.NOTE_NO = ROW_.NOTE_NO;*/
       --modify fjp 2013-01-09 增加明细
      insert into BL_TRANSPORT_NOTECONTRACT(note_no   ,
                                            contract    ,
                                            containerno  ,
                                            state)
       SELECT  distinct ROW_.NOTE_NO,supplier,'0',ROW_.STATE
          from bl_putincase_m b
         where b.picklistno = ROW_.PICKLISTNO
          and  b.STATE = '4';
        ---end----
      ---更新订舱委托modify fjp 2013-01-25
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
      -- 更改数据
      OPEN CUR_ FOR
        SELECT T.* FROM BL_V_TRANSPORT_NOTEB T WHERE T.OBJID = OBJID_;
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
                       '送货进仓' || ROW_.NOTE_NO || '已下达，不可修改');
          CLOSE CUR_;
          RETURN;
        END IF;
      END IF;
      CLOSE CUR_;
/*    
      PICKLISTNO_ := PKG_A.GET_ITEM_VALUE('PICKLISTNO', ROWLIST_);
    
      IF PICKLISTNO_ <> ROW_.PICKLISTNO THEN
        UPDATE BL_BOOKINGLIST_DTL
           SET STATE = '1'
         WHERE PICKLISTNO = ROW_.PICKLISTNO;
        UPDATE BL_BOOKINGLIST_DTL
           SET STATE = '21'
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
        IF COLUMN_ID_ <> 'OBJID' AND COLUMN_ID_ <> 'DOACTION' AND
           COLUMN_ID_ <> 'EXITPORTDESC' AND COLUMN_ID_ <> 'AIMPORTDESC' AND
           COLUMN_ID_ <> 'PISEL' AND COLUMN_ID_ <> 'SHIPBYDESC' AND
           LENGTH(NVL(COLUMN_ID_, '')) > 0 THEN
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
        -- 更新sql语句 
        MYSQL_ := SUBSTR(MYSQL_, 1, LENGTH(MYSQL_) - 1);
      
        MYSQL_ := MYSQL_ || ' where rowidtochar(rowid)=''' || OBJID_ || '''';
        --RAISE_APPLICATION_ERROR(-20101, '错误的rowid=' || MYSQL_);
        EXECUTE IMMEDIATE MYSQL_;
        /*
          MYSQL_ := MYSQL_ || ',modi_date=sysdate,modi_user=''' || USER_ID_ ||
                    ''' where rowidtochar(rowid)=''' || OBJID_ || '''';
        
          --RAISE_APPLICATION_ERROR(-20101, '错误的rowid=' || MYSQL_);
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
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
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
                   '送货进仓' || ROW_.BOOKING_NO || '没有明细无法转整柜派车，请检查');
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
    ROW_ BL_V_TRANSPORT_NOTEB%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTEB T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_TRANSPORT_NOTEB', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
    --判断域是否完整--
    IF CHECK_CONTRACT_(ROWLIST_) = FALSE THEN
      RAISE_APPLICATION_ERROR(-20101, '域不匹配');
      RETURN;
    END IF;
  
    --判断文件是否上传--
    IF NVL(ROW_.DOCUADDRS, '0') = '0' THEN
      RAISE_APPLICATION_ERROR(-20101, '缺少文件');
    END IF;
  
    UPDATE BL_TRANSPORT_NOTE SET STATE = '1' WHERE ROWID = ROW_.OBJID;
  
    UPDATE BL_TRANSPORT_NOTECONTRACT
       SET STATE = '1'
     WHERE NOTE_NO = row_.NOTE_NO;
         --  (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    PKG_A.SETMSG(A311_KEY_, '', '送货进仓下达成功');
  
    RETURN;
  END;
  PROCEDURE CONFIRMCancel__(ROWLIST_  VARCHAR2,
                            USER_ID_  VARCHAR2,
                            A311_KEY_ VARCHAR2)
     is 
     ROW_ BL_V_TRANSPORT_NOTEB%ROWTYPE;
     CUR_ T_CURSOR;
     ll_count_ number;
     begin 
           OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTEB T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_TRANSPORT_NOTEB', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
    --拼车存在不可以取消下达
    select count(*) into ll_count_ from BL_CONTAINPICKLIST_DTL  where NOTE_NO =row_.NOTE_NO and  state <>'3';
    if ll_count_ > 0 then 
       RAISE_APPLICATION_ERROR(-20101, '已经生成拼箱装车不能取消下达');
    end if ;
    UPDATE BL_TRANSPORT_NOTE SET STATE = '0' WHERE ROWID = ROW_.OBJID;
  
    UPDATE BL_TRANSPORT_NOTECONTRACT
       SET STATE = '0'
     WHERE NOTE_NO =row_.NOTE_NO;
         --  (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
/*     UPDATE BL_V_TRANSPORT_NOTECONTRACT
      SET STATE = '0'
    WHERE NOTE_NO = row_.NOTE_NO;*/
       --   (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    PKG_A.SETMSG(A311_KEY_, '', '送货进仓取消下达成功');
  
    RETURN;
     end;
  --右键生成拼车--
  PROCEDURE CREATE__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
    ROW_ BL_V_TRANSPORT_NOTEB%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTEB T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_TRANSPORT_NOTEB', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
    UPDATE BL_TRANSPORT_NOTE SET STATE = '2' WHERE ROWID = ROW_.OBJID;
  
    UPDATE BL_TRANSPORT_NOTEDTL
       SET STATE = '2'
     WHERE NOTE_NO =
           (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    UPDATE BL_V_TRANSPORT_NOTECONTRACT
       SET STATE = '2'
     WHERE NOTE_NO =
           (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
  
    PKG_A.SETMSG(A311_KEY_, '', '送货进仓拼车成功');
  
    RETURN;
  END;
  --右键关闭--
  PROCEDURE CLOSE__(ROWLIST_  VARCHAR2,
                    USER_ID_  VARCHAR2,
                    A311_KEY_ VARCHAR2) IS
    ROW_ BL_V_TRANSPORT_NOTEB%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_TRANSPORT_NOTEB T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_TRANSPORT_NOTEB', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
    UPDATE BL_TRANSPORT_NOTE SET STATE = '4' WHERE ROWID = ROW_.OBJID;
  
    /*UPDATE BL_TRANSPORT_NOTEDTL
       SET STATE = '4'
     WHERE NOTE_NO =
           (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);
    
    UPDATE BL_V_TRANSPORT_NOTECONTRACT
       SET STATE = '4'
     WHERE NOTE_NO =
           (SELECT NOTE_NO FROM BL_TRANSPORT_NOTE WHERE ROWID = ROW_.OBJID);*/
  
    PKG_A.SETMSG(A311_KEY_, '', '送货进仓关闭成功');
  
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
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
  
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
    ATTR_OUT VARCHAR2(4000);
    ROW_     BL_V_BOOKINGLIST_DTL%ROWTYPE;
    ROW2_    BL_V_BOOKINGLIST %ROWTYPE;
    CUR_     T_CURSOR;
  BEGIN
    IF COLUMN_ID_ = 'PICKLISTNO' THEN
      ROW_.PICKLISTNO := PKG_A.GET_ITEM_VALUE('PICKLISTNO', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT *
          FROM BL_V_BOOKINGLIST_DTL
         WHERE PICKLISTNO = ROW_.PICKLISTNO;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%FOUND THEN
        PKG_A.SET_ITEM_VALUE('BOOKING_NO', ROW_.BOOKING_NO, ATTR_OUT);
      
      END IF;
      CLOSE CUR_;
      --查找船期--
      OPEN CUR_ FOR
        SELECT *
          FROM BL_V_BOOKINGLIST T
         WHERE T.BOOKING_NO = ROW_.BOOKING_NO;
      FETCH CUR_
        INTO ROW2_;
    
      IF CUR_%FOUND THEN
       -- PKG_A.SET_ITEM_VALUE('SHIPDATE', ROW2_.SHIPMENT, ATTR_OUT);
        PKG_A.Set_Item_Value('SHIPMENT', ROW2_.SHIPMENT, ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('SHIPPINGMARK', ROW2_.SHIPPINGMARK, ATTR_OUT);
      END IF;
      CLOSE CUR_;
    END IF;
  
    OUTROWLIST_ := ATTR_OUT;
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
    ROW_ BL_V_BOOKINGLIST%ROWTYPE;
  BEGIN
    ROW_.OBJID := PKG_A.GET_ITEM_VALUE('OBJID', ROWLIST_);
    ROW_.STATE := PKG_A.GET_ITEM_VALUE('STATE', ROWLIST_);
    --新增后备货单不能修改modify fjp 2013-01-25
    IF NVL(ROW_.OBJID,'NULL') <> 'NULL' AND COLUMN_ID_ ='PICKLISTNO'  THEN 
       RETURN  '0';
    END IF ;
    IF ROW_.STATE != 0 THEN
      IF COLUMN_ID_ = 'PICKLISTNO' OR COLUMN_ID_ = 'SHIPDATE' OR
         COLUMN_ID_ = 'SHIPTIME' OR COLUMN_ID_ = 'SHIPPINGMARK' OR
         COLUMN_ID_ = 'REMARK' OR COLUMN_ID_ = 'VENDOR_NO' OR
         COLUMN_ID_ = 'VENDOR_DESC' THEN
        RETURN '0';
      ELSE
        RETURN '1';
      END IF;
    END IF;
  END;

  /*获取仓位号码*/
  FUNCTION GET_NOTE_NO(TYPE_ VARCHAR2) RETURN VARCHAR2 IS
    ROW_  BL_V_TRANSPORT_NOTEB%ROWTYPE;
    CUR   T_CURSOR;
    SEQW_ NUMBER; --流水号
    SEQ_  VARCHAR2(20);
  
  BEGIN
    -- 查询最大的本月仓位号
    OPEN CUR FOR
      SELECT NVL(MAX(TO_NUMBER(SUBSTR(NOTE_NO, 10, 4))), '0')
        FROM BL_V_TRANSPORT_NOTEB T
       WHERE SUBSTR(T.NOTE_NO, 1, 8) =
             TO_CHAR(SYSDATE, 'yyyymm') || '-' || TYPE_;
    FETCH CUR
      INTO SEQW_;
  
    SEQ_ := TO_CHAR(SYSDATE, 'yyyymm') || '-' || TYPE_ || '-' ||
            TRIM(TO_CHAR(SEQW_ + 1, '0000'));
  
    CLOSE CUR;
    RETURN SEQ_;
  END;

  /*获取号码*/
  FUNCTION GET_TRANSFORM_NO(BOOKING_NO_ VARCHAR2) RETURN VARCHAR2 IS
    ROW_    BL_TRANSPORT_NOTE%ROWTYPE;
    ROWD_   BL_V_TRANSPORT_NOTEDTL%ROWTYPE;
    CUR     T_CURSOR;
    NOTENO_ VARCHAR2(20);
  
  BEGIN
    -- 查询最大的本月仓位号
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

  --检查工厂域的完整性--
  FUNCTION CHECK_CONTRACT_(OBJID_ VARCHAR2) RETURN BOOLEAN IS
    ROW_B  BL_V_TRANSPORT_NOTEB%ROWTYPE;
    CUR_B  T_CURSOR;
    COUNT1 NUMBER;
    COUNT2 NUMBER;
  BEGIN
    OPEN CUR_B FOR
      SELECT * FROM BL_V_TRANSPORT_NOTEB T WHERE T.OBJID = OBJID_;
    FETCH CUR_B
      INTO ROW_B;
    IF CUR_B%NOTFOUND THEN
      CLOSE CUR_B;
      RETURN FALSE;
    END IF;
    CLOSE CUR_B;
    SELECT COUNT(DISTINCT(T.CONTRACT))
      INTO COUNT1
      FROM BL_V_TRANSPORT_NOTECONTRACTB T
     WHERE T.NOTE_NO = ROW_B.NOTE_NO;
  
    SELECT COUNT(DISTINCT(A.SUPPLIER))
      INTO COUNT2
      FROM BL_PUTINCASE_M A
     WHERE A.STATE = '4'
       AND A.PICKLISTNO = ROW_B.PICKLISTNO;
  
    IF COUNT1 = COUNT2 THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END;
END BL_TRANSPORT_NOTEB_API;
/
