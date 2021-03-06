CREATE OR REPLACE PACKAGE BL_CONTAINPICKLIST_API IS
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
  PROCEDURE CONFIRM__(ROWLIST_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2);
  PROCEDURE CONFIRMCANCEL__(ROWLIST_  VARCHAR2,
                            USER_ID_  VARCHAR2,
                            A311_KEY_ VARCHAR2);
  FUNCTION GET_CONTAIN_NO(TYPE_ VARCHAR2) RETURN VARCHAR2;
  PROCEDURE GEN_PURCHASE_ORDER__(ROWLIST_  VARCHAR2,
                                 USER_ID_  VARCHAR2,
                                 A311_KEY_ VARCHAR2);
  PROCEDURE USERMODIFY__(ROW_     IN BL_PURCHASE_ORDER%ROWTYPE,
                         USER_ID_ IN VARCHAR2);
  PROCEDURE USERMODIFYDETAIL__(ROW_     IN BL_V_PURCHASE_ORDER_LINE_PART%ROWTYPE,
                               USER_ID_ IN VARCHAR2);
                                PROCEDURE CLOSE__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) ;
                     PROCEDURE CANCEL__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) ;
END BL_CONTAINPICKLIST_API;
/
CREATE OR REPLACE PACKAGE BODY BL_CONTAINPICKLIST_API IS
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
    ATTR_OUT VARCHAR2(4000);
    Contract_  varchar2(10);
  BEGIN
    ATTR_OUT := '';
      --获取用户默认的域
    Contract_ := Pkg_Attr.Get_Default_Contract(User_Id_);
    If (Nvl(Contract_, '0') <> '0') Then
      Pkg_a.Set_Item_Value('CONTRACT', Contract_, Attr_Out);
    End If;
    -- pkg_a.Set_Item_Value('【COLUMN】','【VALUE】', attr_out);
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
    OBJID_     VARCHAR2(50);
    INDEX_     VARCHAR2(1);
    CUR_       T_CURSOR;
    DOACTION_  VARCHAR2(10);
    POS_       NUMBER;
    POS1_      NUMBER;
    I          NUMBER := 1;
    V_         VARCHAR(1000);
    COLUMN_ID_ VARCHAR(1000);
    DATA_      VARCHAR(4000);
    MYSQL_     VARCHAR(4000);
    IFMYCHANGE VARCHAR(1);
    ROW_       BL_V_CONTAINPICKLIST%ROWTYPE;
  BEGIN
    INDEX_    := F_GET_DATA_INDEX();
    OBJID_    := PKG_A.GET_ITEM_VALUE('OBJID', INDEX_ || ROWLIST_);
    DOACTION_ := PKG_A.GET_ITEM_VALUE('DOACTION', ROWLIST_);
    --新增
    IF DOACTION_ = 'I' THEN
      -- 拼箱流水号
      ROW_.CONTAIN_NO := GET_CONTAIN_NO('E');
    
      --拼箱流水号
      --  row_.CONTAIN_NO  := Pkg_a.Get_Item_Value('CONTAIN_NO', Rowlist_)
      --工厂域
      ROW_.CONTRACT := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
      --域描述
      -- row_.CONTRACT_DESC  := Pkg_a.Get_Item_Value('CONTRACT_DESC', Rowlist_)
      --费用采购单号
      ROW_.ORDER_NO := PKG_A.GET_ITEM_VALUE('ORDER_NO', ROWLIST_);
      --车号
      ROW_.LICENCEPLATE := PKG_A.GET_ITEM_VALUE('LICENCEPLATE', ROWLIST_);
      --车型
      ROW_.VEHICLETYPE := PKG_A.GET_ITEM_VALUE('VEHICLETYPE', ROWLIST_);
      --车辆供应商
      ROW_.VENDOR_NO := PKG_A.GET_ITEM_VALUE('VENDOR_NO', ROWLIST_);
      --供应商描述
      --row_.VENDOR_NO_DESC  := Pkg_a.Get_Item_Value('VENDOR_NO_DESC', Rowlist_)
      --服务采购件号
      ROW_.FEEPARTNO := PKG_A.GET_ITEM_VALUE('FEEPARTNO', ROWLIST_);
      --实际发送时间
      ROW_.SHIPTIME := TO_DATE(PKG_A.GET_ITEM_VALUE('SHIPTIME', ROWLIST_),
                               'yyyy-mm-dd');
      --司机姓名
      ROW_.DRIVER := PKG_A.GET_ITEM_VALUE('DRIVER', ROWLIST_);
      --司机手机
      ROW_.DRIVERTEL := PKG_A.GET_ITEM_VALUE('DRIVERTEL', ROWLIST_);
      --委托的拼箱流水号
      ROW_.UPCONTAIN_NO := PKG_A.GET_ITEM_VALUE('UPCONTAIN_NO', ROWLIST_);
      if nvl(ROW_.VENDOR_NO,'NULL') = 'NULL'  then
         IF nvl(ROW_.UPCONTAIN_NO,'NULL') ='NULL'  then 
            RAISE_APPLICATION_ERROR(-20101, '车辆供应商跟委托拼箱两者选其一');
         end if;
      ELSE
         IF nvl(ROW_.UPCONTAIN_NO,'NULL')<> 'NULL' then 
            RAISE_APPLICATION_ERROR(-20101, '车辆供应商跟委托拼箱两者不能同时存在');
         end if ; 
         IF nvl(ROW_.FEEPARTNO,'NULL') = 'NULL' THEN 
            RAISE_APPLICATION_ERROR(-20101, '服务采购件号必填!');
         END IF ;
      end if ;
      --委托的工厂域
      -- row_.CONTRACT_E  := Pkg_a.Get_Item_Value('CONTRACT_E', Rowlist_)
      --委托的工厂描述
      -- row_.CONTRACT_E_DESC  := Pkg_a.Get_Item_Value('CONTRACT_E_DESC', Rowlist_)
      --备注
      ROW_.REMARK := PKG_A.GET_ITEM_VALUE('REMARK', ROWLIST_);
      ROW_.EXPRESS_NO := PKG_A.GET_ITEM_VALUE('EXPRESS_NO', ROWLIST_);
      --状态;;
      -- row_.STATE  := Pkg_a.Get_Item_Value('STATE', Rowlist_)RETURN;
      INSERT INTO BL_CONTAINPICKLIST
        (CONTAIN_NO,
         CONTRACT,
         ORDER_NO,
         LICENCEPLATE,
         VEHICLETYPE,
         VENDOR_NO,
         FEEPARTNO,
         SHIPTIME,
         DRIVER,
         DRIVERTEL,
         UPCONTAIN_NO,
         REMARK,
         STATE,
         EXPRESS_NO)
       -- SELECT 
             values( ROW_.CONTAIN_NO,
                     ROW_.CONTRACT,
                     ROW_.ORDER_NO,
                     ROW_.LICENCEPLATE,
                     ROW_.VEHICLETYPE,
                     ROW_.VENDOR_NO,
                     ROW_.FEEPARTNO,
                     ROW_.SHIPTIME,
                     ROW_.DRIVER,
                     ROW_.DRIVERTEL,
                     ROW_.UPCONTAIN_NO,
                     ROW_.REMARK,
                     '0',
                     ROW_.EXPRESS_NO)
       returning rowid  into OBJID_;
/*          FROM DUAL;
      SELECT T.ROWID
        INTO OBJID_
        FROM BL_CONTAINPICKLIST T
       WHERE T.CONTAIN_NO = ROW_.CONTAIN_NO;*/
    
      PKG_A.SETSUCCESS(A311_KEY_, 'bL_containpicklist', OBJID_);
    
    END IF;
    --修改
    IF DOACTION_ = 'M' THEN
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      OPEN CUR_ FOR
        SELECT T.* FROM BL_V_CONTAINPICKLIST T WHERE T.OBJID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(PKG_A.RAISE_ERROR, '错误的rowid！');
      
      END IF;
      CLOSE CUR_;
      DATA_      := ROWLIST_;
      POS_       := INSTR(DATA_, INDEX_);
      I          := I + 1;
      MYSQL_     := 'update bL_containpicklist set ';
      IFMYCHANGE := '0';
      LOOP
        EXIT WHEN NVL(POS_, 0) <= 0;
        EXIT WHEN I > 300;
        V_    := SUBSTR(DATA_, 1, POS_ - 1);
        DATA_ := SUBSTR(DATA_, POS_ + 1);
        POS_  := INSTR(DATA_, INDEX_);
      
        POS1_      := INSTR(V_, '|');
        COLUMN_ID_ := SUBSTR(V_, 1, POS1_ - 1);
        I          := I + 1;
        IF COLUMN_ID_ <> UPPER('Objid') AND COLUMN_ID_ <> UPPER('Doaction') AND
           LENGTH(NVL(COLUMN_ID_, '')) > 0 AND
           COLUMN_ID_ <> UPPER('CONTRACT_DESC') AND
           COLUMN_ID_ <> UPPER('VENDOR_NO_DESC') AND
           COLUMN_ID_ <> UPPER('CONTRACT_E') AND
           COLUMN_ID_ <> UPPER('CONTRACT_E_DESC') THEN
          IFMYCHANGE := '1';
        
          V_ := SUBSTR(V_, POS1_ + 1);
          IF COLUMN_ID_ = UPPER('shiptime') THEN
            -- V_:=TO_DATE(V_,'YYYY-MM-DD');
            MYSQL_ := MYSQL_ || ' ' || COLUMN_ID_ || '=TO_DATE(''' || V_ ||
                      ''',''yyyy-mm-dd'')' || ',';
          
          ELSE
            MYSQL_ := MYSQL_ || ' ' || COLUMN_ID_ || '=''' || V_ || ''',';
          END IF;
        
        END IF;
      
      END LOOP;
    
      --用户自定义列
      IF IFMYCHANGE = '1' THEN
        MYSQL_ := SUBSTR(MYSQL_, 1, LENGTH(MYSQL_) - 1);
        MYSQL_ := MYSQL_ || 'Where Rowid =''' || ROW_.OBJID || '''';
        -- raise_application_error(Pkg_a.Raise_Error, mysql_);
        EXECUTE IMMEDIATE MYSQL_;
      END IF;
    
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_CONTAINPICKLIST', ROW_.OBJID);
      RETURN;
    END IF;
    --删除
    IF DOACTION_ = 'd' THEN
      /*OPEN CUR_ FOR
              SELECT T.* FROM BL_V_CONTAINPICKLIST T WHERE T.ROWID = OBJID_;
            FETCH CUR_
              INTO ROW_;
            IF CUR_ %NOTFOUND THEN
              CLOSE CUR_;
              RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
              return;
            end if;
            close cur_;
      --      DELETE FROM BL_V_CONTAINPICKLIST T WHERE T.ROWID = OBJID_; */
      --pkg_a.Setsuccess(A311_Key_,'BL_V_CONTAINPICKLIST', Objid_);
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
    ATTR_OUT VARCHAR2(4000);
    ROW_A    BL_V_CONTAINPICKLIST%ROWTYPE;
    ROW_B    PO_VENDOR_NO%ROWTYPE;
    ROW_C    SITE_TAB%ROWTYPE;
    CUR_     T_CURSOR;
  BEGIN
  
    IF COLUMN_ID_ = 'UPCONTAIN_NO' THEN
    
      ROW_A.UPCONTAIN_NO := PKG_A.GET_ITEM_VALUE('UPCONTAIN_NO', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_CONTAINPICKLIST T
         WHERE T.CONTAIN_NO = ROW_A.UPCONTAIN_NO;
      FETCH CUR_
        INTO ROW_A;
      IF CUR_ %FOUND THEN
        PKG_A.SET_ITEM_VALUE('CONTRACT_E', ROW_A.CONTRACT, ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('CONTRACT_E_DESC',
                             ROW_A.CONTRACT_DESC,
                             ATTR_OUT);
      --  PKG_A.SET_ITEM_VALUE('FEEPARTNO', ROW_A.FEEPARTNO, ATTR_OUT);
      --  PKG_A.SET_ITEM_VALUE('VENDOR_NO', ROW_A.VENDOR_NO, ATTR_OUT);
       -- PKG_A.SET_ITEM_VALUE('VENDOR_NO_DESC',
       --                      ROW_A.VENDOR_NO_DESC,
        --                     ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('LICENCEPLATE', ROW_A.LICENCEPLATE, ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('VEHICLETYPE', ROW_A.VEHICLETYPE, ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('SHIPTIME', ROW_A.SHIPTIME, ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('DRIVER', ROW_A.DRIVER, ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('DRIVERTEL', ROW_A.DRIVERTEL, ATTR_OUT);
        PKG_A.SET_COLUMN_ENABLE('VENDOR_NO', '0', ATTR_OUT);
        PKG_A.SET_COLUMN_ENABLE('FEEPARTNO', '0', ATTR_OUT);
        PKG_A.SET_COLUMN_ENABLE('LICENCEPLATE', '0', ATTR_OUT);
        PKG_A.SET_COLUMN_ENABLE('VEHICLETYPE', '0', ATTR_OUT);
        PKG_A.SET_COLUMN_ENABLE('SHIPTIME', '0', ATTR_OUT);
        PKG_A.SET_COLUMN_ENABLE('DRIVER', '0', ATTR_OUT);
        PKG_A.SET_COLUMN_ENABLE('DRIVERTEL', '0', ATTR_OUT);
      END IF;
      CLOSE CUR_;
    
    END IF;
  
    IF COLUMN_ID_ = 'CONTRACT' THEN
      ROW_C.CONTRACT := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT T.* FROM SITE_TAB T WHERE T.CONTRACT = ROW_C.CONTRACT;
      FETCH CUR_
        INTO ROW_C;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
        RETURN;
      END IF;
      CLOSE CUR_;
      -- 赋值
      PKG_A.SET_ITEM_VALUE('CONTRACT_DESC', ROW_C.CONTRACT_REF, ATTR_OUT);
    END IF;
  
    IF COLUMN_ID_ = 'VENDOR_NO' THEN
    
      ROW_B.VENDOR_NO := PKG_A.GET_ITEM_VALUE('VENDOR_NO', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT T.* FROM PO_VENDOR_NO T WHERE T.VENDOR_NO = ROW_B.VENDOR_NO;
      FETCH CUR_
        INTO ROW_B;
      IF CUR_ %FOUND THEN
        PKG_A.SET_ITEM_VALUE('VENDOR_NO_DESC', ROW_B.VENDOR_NAME, ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('FEEPARTNO', '', ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('UPCONTAIN_NO', '', ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('CONTRACT_E', '', ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('CONTRACT_E_DESC', '', ATTR_OUT);
        PKG_A.SET_COLUMN_ENABLE('UPCONTAIN_NO', '0', ATTR_OUT);
      END IF;
      CLOSE CUR_;
    
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
  BEGIN
    IF DOTYPE_ = 'Add_Row' THEN
      RETURN '1';
    END IF;
    IF DOTYPE_ = 'Del_Row' THEN
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
    ROW_ BL_V_CONTAINPICKLIST%ROWTYPE;
  BEGIN
  
    ROW_.STATE := PKG_A.GET_ITEM_VALUE('STATE', ROWLIST_);
    ROW_.OBJID := PKG_A.GET_ITEM_VALUE('OBJID', ROWLIST_);
  
    IF ROW_.STATE != '0' THEN
      IF COLUMN_ID_ = UPPER('contract') OR COLUMN_ID_ = UPPER('order_no') OR
         COLUMN_ID_ = UPPER('licenceplate') OR
         COLUMN_ID_ = UPPER('vehicletype') OR
         COLUMN_ID_ = UPPER('vender_no') OR COLUMN_ID_ = UPPER('Feepartno') OR
         COLUMN_ID_ = UPPER('shiptime') OR COLUMN_ID_ = UPPER('driver')
        
         OR COLUMN_ID_ = UPPER('driverTel') OR
         COLUMN_ID_ = UPPER('Upcontain_NO') OR COLUMN_ID_ = UPPER('remark')
      
       THEN
        RETURN '0';
      END IF;
    END IF;
    RETURN '1';
  END;

  --右键功能--
  PROCEDURE CONFIRM__(ROWLIST_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2) IS
    ROW_ BL_V_CONTAINPICKLIST%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    -- RAISE_APPLICATION_ERROR(-20101, '错误的rowid--错误的rowid');
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_CONTAINPICKLIST T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_CONTAINPICKLIST', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
  
    CLOSE CUR_;
  
/*    IF ROW_.FEEPARTNO IS NULL   THEN
      RAISE_APPLICATION_ERROR(-20101,
                              '拼箱装车服务件号不可为空！');
      RETURN;
    END IF;*/
    -- RAISE_APPLICATION_ERROR(-20101, '错误的rowid--错误的rowid');
    UPDATE BL_CONTAINPICKLIST SET STATE = '1' WHERE ROWID = ROW_.OBJID;
    UPDATE BL_CONTAINPICKLIST_DTL
       SET STATE = '1'
     WHERE CONTAIN_NO IN (SELECT T.CONTAIN_NO
                            FROM BL_CONTAINPICKLIST T
                           WHERE ROWID = ROW_.OBJID);
  
    IF ROW_.UPCONTAIN_NO IS NULL THEN
      GEN_PURCHASE_ORDER__(ROWLIST_, USER_ID_, A311_KEY_);
    END IF;
  
    PKG_A.SETMSG(A311_KEY_, '', '拼箱装车确认成功');
  
    RETURN;
  END;
  PROCEDURE CONFIRMCANCEL__(ROWLIST_  VARCHAR2,
                            USER_ID_  VARCHAR2,
                            A311_KEY_ VARCHAR2)
   IS 
    ROW_ BL_V_CONTAINPICKLIST%ROWTYPE;
    CUR_ T_CURSOR;
    Attr_       Varchar2(4000);
    Info_       Varchar2(4000);
    Objid_      Varchar2(4000);
    Objversion_ Varchar2(4000);
    Action_     Varchar2(100);
  BEGIN
    -- RAISE_APPLICATION_ERROR(-20101, '错误的rowid--错误的rowid');
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_CONTAINPICKLIST T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_CONTAINPICKLIST', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
  
    CLOSE CUR_;

    UPDATE BL_CONTAINPICKLIST SET STATE = '0' WHERE ROWID = ROW_.OBJID;
    UPDATE BL_CONTAINPICKLIST_DTL
       SET STATE = '0'
     WHERE CONTAIN_NO IN (SELECT T.CONTAIN_NO
                            FROM BL_CONTAINPICKLIST T
                           WHERE ROWID = ROW_.OBJID);
    --取消下达取消采购订单
    if  nvl(ROW_.ORDER_NO,'NULL') <>'NULL' then
       Action_ := 'DO'; 
       select Objid,Objversion
        into Objid_,Objversion_
        from purchase_order 
        where order_no = ROW_.ORDER_NO;
       PURCHASE_ORDER_API.CANCEL__(Info_,
                                   Objid_, 
                                   Objversion_, 
                                   Attr_, 
                                   Action_);
      --更新拼箱装货的费用采购单号 
       UPDATE BL_CONTAINPICKLIST
         SET ORDER_NO = ''
       WHERE CONTAIN_NO = ROW_.CONTAIN_NO;
    end if ;
/*    IF ROW_.UPCONTAIN_NO IS NULL THEN
      GEN_PURCHASE_ORDER__(ROWLIST_, USER_ID_, A311_KEY_);
    END IF;*/
    --取消客户订单
  
    PKG_A.SETMSG(A311_KEY_, '', '拼箱装车确认成功');
  
    RETURN;
  END;
   --右键功能取消--
  PROCEDURE CANCEL__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
    INFO_           VARCHAR2(4000);
    ROW_            BL_V_CONTAINPICKLIST%ROWTYPE;
    CUR_            T_CURSOR;
    ATTR_           VARCHAR2(4000);
    ACTION_         VARCHAR2(20);
    LOCATION_GROUP_ VARCHAR2(20);
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_CONTAINPICKLIST T WHERE T.OBJID = ROWLIST_;
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
                   '拼箱装车' || ROW_.contain_NO || '已下达，不可取消');
      RETURN;
    END IF;
  
    UPDATE BL_V_CONTAINPICKLIST SET STATE = '3' WHERE ROWID = ROW_.OBJID;
   UPDATE BL_V_CONTAINPICKLIST_DTL SET STATE='3'
     WHERE CONTAIN_NO =
           (SELECT CONTAIN_NO FROM BL_V_CONTAINPICKLIST T WHERE T.OBJID = ROW_.OBJID);
   
    --raise_application_error(-20101, '已经移库不能取消登记到达！');
    --return ;                                             
    PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_CONTAINPICKLIST', ROW_.OBJID);
    PKG_A.SETMSG(A311_KEY_, '', '拼箱装车' || ROW_.contain_NO || '取消成功！');
    RETURN;
  END;
   --右键关闭--
  PROCEDURE CLOSE__(ROWLIST_  VARCHAR2,
                    USER_ID_  VARCHAR2,
                    A311_KEY_ VARCHAR2) IS
    ROW_ BL_V_CONTAINPICKLIST%ROWTYPE;
    CUR_ T_CURSOR;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_CONTAINPICKLIST T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_CONTAINPICKLIST', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
    UPDATE BL_V_CONTAINPICKLIST SET STATE = '4' WHERE ROWID = ROW_.OBJID;
    UPDATE BL_V_CONTAINPICKLIST_DTL SET STATE='4'
     WHERE contain_NO =
           (SELECT contain_NO FROM BL_V_CONTAINPICKLIST T WHERE T.OBJID = ROW_.OBJID);
 
    PKG_A.SETMSG(A311_KEY_, '', '拼箱装车关闭成功');
  
    RETURN;
  END;

  /*获取拼箱流水号*/
  FUNCTION GET_CONTAIN_NO(TYPE_ VARCHAR2) RETURN VARCHAR2 IS
    ROW_  BL_V_CONTAINPICKLIST%ROWTYPE;
    CUR   T_CURSOR;
    SEQW_ NUMBER; --流水号
    SEQ_  VARCHAR2(20);
    yymmdd_  varchar2(10);
    len_yymmdd_ number;
  BEGIN
    yymmdd_ :=  To_Char(Sysdate, 'yymmdd');
    len_yymmdd_ := length(yymmdd_);
    -- 查询最大的本月拼箱流水号
    OPEN CUR FOR
      SELECT NVL(MAX(TO_NUMBER(SUBSTR(REPLACE(CONTAIN_NO,'-',''),len_yymmdd_+1, 3))), '0')
        FROM BL_V_CONTAINPICKLIST T
       WHERE SUBSTR(T.CONTAIN_NO, 1, len_yymmdd_) = yymmdd_;
    FETCH CUR
      INTO SEQW_;
  
  /*  SEQ_ := TO_CHAR(SYSDATE, 'yyyymm') || '-' ||
            TRIM(TO_CHAR(SEQW_ + 1, '0000'));*/
     SEQ_ :=   yymmdd_|| TRIM(TO_CHAR(SEQW_ + 1, '000'));
    CLOSE CUR;
    RETURN SEQ_;
  END;

  PROCEDURE GEN_PURCHASE_ORDER__(ROWLIST_  VARCHAR2,
                                 USER_ID_  VARCHAR2,
                                 A311_KEY_ VARCHAR2) IS
    ROWC_       BL_V_CONTAINPICKLIST%ROWTYPE;
    CUR_        T_CURSOR;
    ACTION_     VARCHAR2(100);
    ROW_        BL_V_PURCHASE_ORDER%ROWTYPE;
    ROW0_       BL_PURCHASE_ORDER%ROWTYPE;
    ROW1_       BL_V_PURCHASE_ORDER_LINE_PART%ROWTYPE;
    ATTR_       VARCHAR2(4000);
    INFO_       VARCHAR2(4000);
    OBJID_      VARCHAR2(4000);
    OBJVERSION_ VARCHAR2(4000);
    PRICE_CONV_FACTOR_      NUMBER;
    PRICE_UNIT_MEAS_        VARCHAR2(20);
    DISCOUNT_               NUMBER;
    ADDITIONAL_COST_AMOUNT_ NUMBER;
    CURR_RATE_              NUMBER;
    CURR_CODE_              VARCHAR2(20);
    PERCENTAGE_             NUMBER;
    BUY_UNIT_PRICE_         NUMBER;
  BEGIN
    -- RAISE_APPLICATION_ERROR(-20101, '错误的rowid--错误的rowid');
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_CONTAINPICKLIST T WHERE T.OBJID = ROWLIST_;
    FETCH CUR_
      INTO ROWC_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      PKG_A.SETFAILED(A311_KEY_, 'BL_V_CONTAINPICKLIST', ROWLIST_);
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      RETURN;
    END IF;
  
    CLOSE CUR_;
  
    /*采购订单主档*/
  
    ATTR_   := '';
    ACTION_ := 'PREPARE';
    PURCHASE_ORDER_API.NEW__(INFO_, OBJID_, OBJVERSION_, ATTR_, ACTION_);
    --订单代码描述
    /*
     ROW_.ORDER_CODE       := PURCHASE_ORDER_TYPE_API.GET_DESCRIPTION(CLIENT_SYS.GET_ITEM_VALUE('ORDER_CODE',
                                                                                                ATTR_));
     ROW_.CURRENCY_CODE    := SUPPLIER_API.GET_CURRENCY_CODE(ROWC_.VENDOR_NO);
     ROW_.BUYER_CODE       := SUPPLIER_API.GET_BUYER_CODE(ROWC_.VENDOR_NO);
     ROW_.LANGUAGE_CODE    := SUPPLIER_API.GET_LANGUAGE_CODE(ROWC_.VENDOR_NO);
     ROW_.PRICE_WITH_TAX   := IDENTITY_INVOICE_INFO_API.PRICE_WITH_TAX(SITE_API.GET_COMPANY(ROWC_.CONTRACT),
                                                                       ROWC_.VENDOR_NO,
                                                                       'SUPPLIER');
     ROW_.AUTHORIZE_CODE   := CLIENT_SYS.GET_ITEM_VALUE('AUTHORIZE_CODE',
                                                        ATTR_);
     ROW_.DELIVERY_ADDRESS := CLIENT_SYS.GET_ITEM_VALUE('DELIVERY_ADDRESS',
                                                        ATTR_);
    
     ROW_.ORDER_DATE := TO_DATE(SUBSTR(CLIENT_SYS.GET_ITEM_VALUE('ORDER_DATE',
                                                                 ATTR_),
                                       1,
                                       10),
                                'YYYY-MM-DD');
    */
  
    --CLIENT_SYS.ADD_TO_ATTR('ORDER_NO', ROWC_.ORDER_NO, ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('VENDOR_NO', ROWC_.VENDOR_NO, ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('CONTRACT', ROWC_.CONTRACT, ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('ORDER_CODE', ROW_.ORDER_CODE, ATTR_); --订单代码 
    CLIENT_SYS.ADD_TO_ATTR('WANTED_RECEIPT_DATE', ROWC_.SHIPTIME, ATTR_); --交货日期
    --CLIENT_SYS.ADD_TO_ATTR('CURRENCY_CODE', ROW_.CURRENCY_CODE, ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('BUYER_CODE', ROW_.BUYER_CODE, ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('DELIVERY_ADDRESS',ROW_.DELIVERY_ADDRESS, ATTR_);
  
    --CLIENT_SYS.ADD_TO_ATTR('AUTHORIZE_CODE', ROW_.AUTHORIZE_CODE, ATTR_); --协调人not null
    --CLIENT_SYS.ADD_TO_ATTR('ORDER_DATE', ROW_.ORDER_DATE, ATTR_); --订单日期
    --CLIENT_SYS.ADD_TO_ATTR('LANGUAGE_CODE', ROW_.LANGUAGE_CODE, ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('DELIVERY_TERMS',ROWC_.DELIVERY_TERMS,ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('DELIVERY_TERMS_DESC',ROWC_.DELIVERY_TERMS_DESC,ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('SHIP_VIA_CODE',ROWC_.SHIP_VIA_CODE,ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('SHIP_VIA_DESC',ROWC_.SHIP_VIA_DESC,ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('PAY_TERM_ID', ROWC_.PAY_TERM_ID, ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('INTERNAL_DESTINATION',ROWC_.INTERNAL_DESTINATION,ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('DESTINATION_ID', ROWC_.DESTINATION_ID, ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('COUNTRY_CODE', ROWC_.COUNTRY_CODE, ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('NOTE_ID', ROWC_.NOTE_ID, ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('PRICE_WITH_TAX', ROW_.PRICE_WITH_TAX, ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('LABEL_NOTE', ROWC_.LABEL_NOTE, ATTR_);
    /*
    LS_CUSTOMER_INNER_ := IDENTITY_INVOICE_INFO_API.GET_IDENTITY_TYPE(SITE_API.GET_COMPANY(PKG_A.GET_ITEM_VALUE('CONTRACT',
                                                                                                                ROWLIST_)),
                                                                      PKG_A.GET_ITEM_VALUE('VENDOR_NO',
                                                                                           ROWLIST_),
                                                                      'Supplier');
    
      
     --内部供应商 外部客户跟库位是必填  modify 2012-12-18 
     Row0_.Bllocation_No := Pkg_a.Get_Item_Value('BLLOCATION_NO', Rowlist_);
     Row_.Label_Note    := Pkg_a.Get_Item_Value('LABEL_NOTE', Rowlist_);
    if  Ls_Customer_Inner_ = 'INTERN'    then 
        if nvl(Row_.Label_Note,'NULL')= 'NULL'   then 
            Raise_Application_Error(-20101, '内部供应商的外部客户号不能为空');
            Return;
        end if ;
        if nvl(Row0_.Bllocation_No,'NULL')= 'NULL'  then 
            Raise_Application_Error(-20101, '内部供应商的库位不能为空');
            Return;
        end if ;
    end if ;     */
    ACTION_ := 'DO';
    PURCHASE_ORDER_API.NEW__(INFO_, OBJID_, OBJVERSION_, ATTR_, ACTION_);
    PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_PURCHASE_ORDER', OBJID_);
  
    ROW_.ORDER_NO  := CLIENT_SYS.GET_ITEM_VALUE('ORDER_NO', ATTR_);
    ROW0_.ORDER_NO := ROW_.ORDER_NO;
    --IF LS_CUSTOMER_INNER_ = 'INTERN' THEN 宝隆订单号需要外部客户号才能生成！
    BL_CUSTOMER_ORDER_API.GETSEQNO(TO_CHAR(SYSDATE, 'YY') ||
                                   ROW_.LABEL_NOTE,
                                   USER_ID_,
                                   4,
                                   ROW0_.BLORDER_NO);
    --END IF;
    ROW0_.BLORDER_NO := PKG_A.GET_ITEM_VALUE('BLORDER_NO', ROWLIST_);
    USERMODIFY__(ROW0_, USER_ID_);
  
    --采购订单明细
    ATTR_ := '';
  
    PURCHASE_PART_SUPPLIER_API.GET_PRICE_INFO__(PRICE_CONV_FACTOR_      => PRICE_CONV_FACTOR_,
                                                PRICE_UNIT_MEAS_        => PRICE_UNIT_MEAS_,
                                                DISCOUNT_               => DISCOUNT_,
                                                ADDITIONAL_COST_AMOUNT_ => ADDITIONAL_COST_AMOUNT_,
                                                CURR_RATE_              => CURR_RATE_,
                                                BUY_UNIT_PRICE_         => ROW1_.BUY_UNIT_PRICE,
                                                FBUY_UNIT_PRICE_        => ROW1_.FBUY_UNIT_PRICE,
                                                CURR_CODE_              => CURR_CODE_,
                                                CONTRACT_               => ROWC_.CONTRACT,
                                                PART_NO_                => ROWC_.FEEPARTNO,
                                                VENDOR_NO_              => ROWC_.VENDOR_NO,
                                                QTY_PURCHASE_           => NULL,
                                                PRICE_DATE_             => NULL,
                                                CURRENCY_TYPE_          => NULL,
                                                SERVICE_TYPE_           => NULL,
                                                CONDITION_CODE_         => NULL,
                                                EXCHANGE_ITEM_          => NULL);
    ROW1_.DESCRIPTION     := PURCHASE_PART_API.GET_DESCRIPTION(ROWC_.CONTRACT,
                                                               ROWC_.FEEPARTNO);
    ROW1_.QC_CODE         := PURCHASE_PART_API.GET_QC_CODE(ROWC_.CONTRACT,
                                                           ROWC_.FEEPARTNO);
    ROW1_.UNIT_MEAS       := PURCHASE_PART_SUPPLIER_API.GET_UNIT_MEAS(ROWC_.CONTRACT,
                                                                      ROWC_.FEEPARTNO);
    ROW1_.DEF_VAT_CODE    := PURCHASE_PART_SUPPLIER_API.GET_DEF_VAT_CODE(ROWC_.CONTRACT,
                                                                         ROWC_.FEEPARTNO,
                                                                         ROWC_.VENDOR_NO);
    ROW1_.RECEIVE_CASE    := PURCHASE_PART_SUPPLIER_API.GET_RECEIVE_CASE(ROWC_.CONTRACT,
                                                                         ROWC_.FEEPARTNO,
                                                                         ROWC_.VENDOR_NO);
    ROW1_.INSPECTION_CODE := PURCHASE_PART_SUPPLIER_API.GET_INSPECTION_CODE(ROWC_.CONTRACT,
                                                                            ROWC_.FEEPARTNO,
                                                                            ROWC_.VENDOR_NO);
    ROW1_.SAMPLE_PERCENT  := PURCHASE_PART_SUPPLIER_API.GET_SAMPLE_PERCENT(ROWC_.CONTRACT,
                                                                           ROWC_.FEEPARTNO,
                                                                           ROWC_.VENDOR_NO);
  
    CLIENT_SYS.ADD_TO_ATTR('ORDER_NO', ROW0_.ORDER_NO, ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('LINE_NO', 1, ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('RELEASE_NO', 1, ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('VENDOR_NO', ROWC_.VENDOR_NO, ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('CURRENCY_CODE', CURR_CODE_, ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('COMPANY',
                           SITE_API.GET_COMPANY(ROWC_.CONTRACT),
                           ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('PART_NO', ROWC_.FEEPARTNO, ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('DESCRIPTION', ROW1_.DESCRIPTION, ATTR_); --取描述*
    CLIENT_SYS.ADD_TO_ATTR('BUY_QTY_DUE', 1, ATTR_); --数量
    --CLIENT_SYS.ADD_TO_ATTR('BUY_UNIT_MEAS', ROWC_.BUY_UNIT_MEAS, ATTR_);
    --CLIENT_SYS.ADD_TO_ATTR('PLANNED_RECEIPT_DATE',ROWC_.PLANNED_RECEIPT_DATE,ATTR_);                     
    ----client_sys.Add_To_Attr('PLANNED_DELIVERY_DATE','2012-08-10-00.00.00',attr_ );
    CLIENT_SYS.ADD_TO_ATTR('WANTED_DELIVERY_DATE', ROWC_.SHIPTIME, ATTR_);
    ---- client_sys.Add_To_Attr('PROMISED_DELIVERY_DATE','2012-08-10-00.00.00',attr_ );
    --判断主档是否含税或者未税
    select Price_With_Tax 
    into   ROW_.PRICE_WITH_TAX
    from   purchase_order 
    where  order_no = row0_.order_no;
    if ROW_.PRICE_WITH_TAX='FALSE' then 
        CLIENT_SYS.ADD_TO_ATTR('FBUY_TAX_UNIT_PRICE',ROW1_.FBUY_UNIT_PRICE,ATTR_); 
        CLIENT_SYS.ADD_TO_ATTR('BUY_UNIT_PRICE', ROW1_.BUY_UNIT_PRICE, ATTR_); --价格
        CLIENT_SYS.ADD_TO_ATTR('FBUY_UNIT_PRICE', ROW1_.FBUY_UNIT_PRICE, ATTR_); --单价
    else
       CLIENT_SYS.ADD_TO_ATTR('FBUY_TAX_UNIT_PRICE',ROW1_.FBUY_UNIT_PRICE,ATTR_); 
        Percentage_          := Statutory_Fee_Api.Get_Percentage(Ifsapp.Site_Api.Get_Company(ROWC_.CONTRACT),
                                                                  ROW1_.DEF_VAT_CODE);
        ROW1_.FBUY_UNIT_PRICE := Round(ROW1_.FBUY_UNIT_PRICE * 100 /
                                      (100 + Percentage_),
                                      2); 
        CLIENT_SYS.ADD_TO_ATTR('BUY_UNIT_PRICE', ROW1_.BUY_UNIT_PRICE, ATTR_); --价格
        CLIENT_SYS.ADD_TO_ATTR('FBUY_UNIT_PRICE', ROW1_.FBUY_UNIT_PRICE, ATTR_); --单价                              
    end if ;                     
    --CLIENT_SYS.ADD_TO_ATTR('PRICE_UNIT_MEAS', ROWC_.PRICE_UNIT_MEAS, ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('PRICE_CONV_FACTOR', PRICE_CONV_FACTOR_, ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('DISCOUNT', DISCOUNT_, ATTR_);
    ----client_sys.Add_To_Attr('ADDITIONAL_COST_AMOUNT','0',attr_ );
    --CLIENT_SYS.ADD_TO_ATTR('TAX_AMOUNT', ROWC_.TAX_AMOUNT, ATTR_);
    ---- client_sys.Add_To_Attr('AUTOMATIC_INVOICE_DB','MANUAL',attr_ );
    ----client_sys.Add_To_Attr('BLANKET_ORDER','',attr_ );
    ---- client_sys.Add_To_Attr('BLANKET_LINE','',attr_ );
    CLIENT_SYS.ADD_TO_ATTR('CURRENCY_RATE', CURR_RATE_, ATTR_); --汇率
    ---- client_sys.Add_To_Attr('PURCHASE_PAYMENT_TYPE','Normal',attr_ );
    ---- client_sys.Add_To_Attr('TAXABLE','FALSE',attr_ );
    ----client_sys.Add_To_Attr('TAX_SHIP_ADDRESS','Not Used',attr_ );
    ---- client_sys.Add_To_Attr('CLOSE_CODE','Automatic',attr_ );
    ----  client_sys.Add_To_Attr('CLOSE_TOLERANCE','0',attr_ );
    CLIENT_SYS.ADD_TO_ATTR('RECEIVE_CASE', ROW1_.RECEIVE_CASE, ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('INSPECTION_CODE', ROW1_.INSPECTION_CODE, ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('SAMPLE_PERCENT', ROW1_.SAMPLE_PERCENT, ATTR_);
    ---- client_sys.Add_To_Attr('SAMPLE_QTY','0',attr_ );
    CLIENT_SYS.ADD_TO_ATTR('QC_CODE', ROW1_.QC_CODE, ATTR_);
    ---- client_sys.Add_To_Attr('ORD_CONF_REMINDER','No Order Reminder',attr_ );
    ---- client_sys.Add_To_Attr('ORD_CONF_REM_NUM','0',attr_ );
    ---- client_sys.Add_To_Attr('DELIVERY_REMINDER','No Delivery Reminder',attr_ );
    ---- client_sys.Add_To_Attr('DELIVERY_REM_NUM','0',attr_ );
    CLIENT_SYS.ADD_TO_ATTR('CONTRACT', ROWC_.CONTRACT, ATTR_);
    ---- client_sys.Add_To_Attr('DEFAULT_ADDR_FLAG_DB','Y',attr_ );
    CLIENT_SYS.ADD_TO_ATTR('ADDRESS_ID', '01', ATTR_); --采购订单也是01，需要注意
    ---- client_sys.Add_To_Attr('ADDR_FLAG_DB','N',attr_ );
    CLIENT_SYS.ADD_TO_ATTR('UNIT_MEAS', ROW1_.UNIT_MEAS, ATTR_);
    ---- client_sys.Add_To_Attr('PROCESS_TYPE','',attr_ );
    ----client_sys.Add_To_Attr('MANUFACTURER_ID','',attr_ );
    ---- client_sys.Add_To_Attr('MANUFACTURER_PART_NO','',attr_ );
    ---- client_sys.Add_To_Attr('IS_EXCHANGE_PART','FALSE',attr_ );
    ---- client_sys.Add_To_Attr('EXCHANGE_ITEM_DB','ITEM NOT EXCHANGED',attr_ );
    ----  client_sys.Add_To_Attr('QTY_SCRAPPED_SUPPLIER','0',attr_ );
    ---- client_sys.Add_To_Attr('WARRANTY_ID','',attr_ );
    ----  client_sys.Add_To_Attr('PURCHASE_SITE','11',attr_ );
    CLIENT_SYS.ADD_TO_ATTR('DEF_VAT_CODE', ROW1_.DEF_VAT_CODE, ATTR_);
    ---- client_sys.Add_To_Attr('DATE_TYPE','PLANNED_RECEIPT_DATE',attr_ );
  
    ACTION_ := 'DO';
    PURCHASE_ORDER_LINE_PART_API.NEW__(INFO_,
                                       OBJID_,
                                       OBJVERSION_,
                                       ATTR_,
                                       ACTION_);
    PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_PURCHASE_ORDER_LINE_PART', OBJID_);
  
    ROW1_.ORDER_NO    := ROW0_.ORDER_NO;
    ROW1_.LINE_NO     := CLIENT_SYS.GET_ITEM_VALUE('LINE_NO', ATTR_);
    ROW1_.RELEASE_NO  := CLIENT_SYS.GET_ITEM_VALUE('RELEASE_NO', ATTR_);
    ROW1_.BLD001_PACK := PKG_A.GET_ITEM_VALUE('BLD001_PACK', ROWLIST_);
  
    USERMODIFYDETAIL__(ROW1_, USER_ID_);
  
    UPDATE BL_CONTAINPICKLIST
       SET ORDER_NO = ROW0_.ORDER_NO
     WHERE CONTAIN_NO = ROWC_.CONTAIN_NO;
  
    PKG_A.SETMSG(A311_KEY_, '', '拼箱装车确认成功');
  
    RETURN;
  END;

  PROCEDURE USERMODIFY__(ROW_     IN BL_PURCHASE_ORDER%ROWTYPE,
                         USER_ID_ IN VARCHAR2) IS
    CUR_  T_CURSOR;
    ROW0_ BL_PURCHASE_ORDER%ROWTYPE;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_PURCHASE_ORDER T WHERE T.ORDER_NO = ROW_.ORDER_NO;
    FETCH CUR_
      INTO ROW0_;
    IF CUR_%NOTFOUND THEN
      INSERT INTO BL_PURCHASE_ORDER
        (ORDER_NO,
         ENTER_DATE,
         ENTER_USER,
         BLD001_ITEM,
         BLORDER_NO,
         BLLOCATION_NO,
         BLORDER_ID)
        SELECT ROW_.ORDER_NO,
               SYSDATE,
               USER_ID_,
               ROW_.BLD001_ITEM,
               ROW_.BLORDER_NO,
               ROW_.BLLOCATION_NO,
               ROW_.BLORDER_ID
          FROM DUAL;
    ELSE
      UPDATE BL_PURCHASE_ORDER
         SET BLORDER_NO    = NVL(ROW_.BLORDER_NO, BLORDER_NO),
             BLD001_ITEM   = NVL(ROW_.BLD001_ITEM, BLD001_ITEM),
             BLLOCATION_NO = NVL(ROW_.BLLOCATION_NO, BLLOCATION_NO),
             BLORDER_ID    = NVL(ROW_.BLORDER_ID, BLORDER_ID),
             MODI_DATE     = SYSDATE,
             MODI_USER     = USER_ID_
       WHERE ORDER_NO = ROW_.ORDER_NO;
    END IF;
    CLOSE CUR_;
  END;
  PROCEDURE USERMODIFYDETAIL__(ROW_     IN BL_V_PURCHASE_ORDER_LINE_PART%ROWTYPE,
                               USER_ID_ IN VARCHAR2) IS
    CUR_  T_CURSOR;
    ROW0_ BL_PURCHASE_ORDER_LINE_PART%ROWTYPE;
  
  BEGIN
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_PURCHASE_ORDER_LINE_PART T
       WHERE T.ORDER_NO = ROW_.ORDER_NO
         AND T.LINE_NO = ROW_.LINE_NO
         AND T.RELEASE_NO = ROW_.RELEASE_NO;
    FETCH CUR_
      INTO ROW0_;
    IF CUR_%NOTFOUND THEN
      INSERT INTO BL_PURCHASE_ORDER_LINE_PART
        (ORDER_NO,
         LINE_NO,
         RELEASE_NO,
         BLD001_PACK,
         ENTER_DATE,
         ENTER_USER)
        SELECT ROW_.ORDER_NO,
               ROW_.LINE_NO,
               ROW_.RELEASE_NO,
               ROW_.BLD001_PACK,
               SYSDATE,
               USER_ID_
          FROM DUAL;
    ELSE
      UPDATE BL_PURCHASE_ORDER_LINE_PART T
         SET BLD001_PACK = NVL(ROW_.BLD001_PACK, BLD001_PACK),
             MODI_DATE   = SYSDATE,
             MODI_USER   = USER_ID_
       WHERE T.ORDER_NO = ROW_.ORDER_NO
         AND T.LINE_NO = ROW_.LINE_NO
         AND T.RELEASE_NO = ROW_.RELEASE_NO;
    END IF;
    CLOSE CUR_;
  
  END;
END BL_CONTAINPICKLIST_API;
/
