CREATE OR REPLACE PACKAGE BL_STOCK_RETRUN_DTL_API IS

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
  --获取原始的单号
  FUNCTION GETINSPECTLINENO(INSPECT_NO_ IN VARCHAR2) RETURN NUMBER;
  FUNCTION CHECKORDERPARTNO(CONTRACT_     IN VARCHAR2,
                            PART_NO_      IN VARCHAR2,
                            LOT_BATCH_NO_ IN VARCHAR2,
                            LOCATION_NO_  IN VARCHAR2,
                            RETURN_QTY_   IN NUMBER) RETURN NUMBER;

  FUNCTION CHECKRECEIPTQTY(CONTRACT_     IN VARCHAR2,
                           ORDER_NO_     IN VARCHAR2,
                           LINE_NO_      IN VARCHAR2,
                           RELEASE_NO_   IN VARCHAR2,
                           PART_NO_      IN VARCHAR2,
                           LOT_BATCH_NO_ IN VARCHAR2,
                           LOCATION_NO_  IN VARCHAR2,
                           RECEIPT_NO_   IN VARCHAR2,
                           RETURN_QTY_   IN NUMBER) RETURN NUMBER;

END BL_STOCK_RETRUN_DTL_API;
/
CREATE OR REPLACE PACKAGE BODY BL_STOCK_RETRUN_DTL_API IS
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
    ROW_       BL_V_STOCK_RETRUN_DTL%ROWTYPE;
    ROWM_      BL_V_STOCK_RETRUN%ROWTYPE;
    LL_COUNT_  NUMBER;
    POS_       NUMBER;
    POS1_      NUMBER;
    I          NUMBER;
    V_         VARCHAR(1000);
    COLUMN_ID_ VARCHAR(1000);
    DATA_      VARCHAR(4000);
    MYSQL_     VARCHAR2(4000);
    IFMYCHANGE VARCHAR2(1);
    FLAG_      NUMBER DEFAULT - 1;
  BEGIN
  
    INDEX_    := F_GET_DATA_INDEX();
    OBJID_    := PKG_A.GET_ITEM_VALUE('OBJID', INDEX_ || ROWLIST_);
    DOACTION_ := PKG_A.GET_ITEM_VALUE('DOACTION', ROWLIST_);
  
    IF DOACTION_ = 'I' THEN
    
      --判断主档状态是否可以添加明细
      ROW_.INSPECT_NO := PKG_A.GET_ITEM_VALUE('INSPECT_NO', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_STOCK_RETRUN T
         WHERE T.INSPECT_NO = ROW_.INSPECT_NO;
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
                                '退货申请单' || ROW_.INSPECT_NO ||
                                '非保存状态，不可添加明细');
        RETURN;
      END IF;
    
      -- 从页面获取数据
      ROW_.INSPECT_NO_LINE     := GETINSPECTLINENO(ROW_.INSPECT_NO);
      ROW_.CONTRACT            := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
      ROW_.QTY_TO_INSPECT      := PKG_A.GET_ITEM_VALUE('QTY_TO_INSPECT',
                                                       ROWLIST_);
      ROW_.AVAIL_NUM           := PKG_A.GET_ITEM_VALUE('AVAIL_NUM',
                                                       ROWLIST_);
      ROW_.PART_NO             := PKG_A.GET_ITEM_VALUE('PART_NO', ROWLIST_);
      --检测件号是否在域中
      if rowm_.IS_OUTER_ORDER = 'INTERN'  then 
           --销售件的检测 
           if SALES_PART_API.Exist_Inventory_Part(rowm_.VENDOR_NO,row_.PART_NO)=0 then 
               RAISE_APPLICATION_ERROR(-20101,
                                '退货申请单' || ROW_.INSPECT_NO ||
                                '物料号为'||row_.PART_NO||'在域'||rowm_.VENDOR_NO||'中不存在销售件');
               return ;
            end if ; 
            --采购件供应商的检测
            if nvl(rowm_.pcontract,'NULL')<>'NULL' then 
               if    PURCHASE_PART_SUPPLIER_API.Exist_N(rowm_.VENDOR_NO,
                                                             row_.PART_NO,
                                                             rowm_.pcontract) =0 then
                   RAISE_APPLICATION_ERROR(-20101,
                                '退货申请单' || ROW_.INSPECT_NO ||
                                '物料号为'||row_.PART_NO||'在域'||rowm_.VENDOR_NO||'中不存在采购件供应商');
                   return ;                                            
               end if;
               --销售件
               if SALES_PART_API.Exist_Inventory_Part(rowm_.pcontract,row_.PART_NO)=0 then 
                  RAISE_APPLICATION_ERROR(-20101,
                                '退货申请单' || ROW_.INSPECT_NO ||
                                '物料号为'||row_.PART_NO||'在域'||rowm_.pcontract||'中不存在销售件');
                   return ;
               end if ; 
            end if ;
      end if ;
      ROW_.LOT_BATCH_NO        := PKG_A.GET_ITEM_VALUE('LOT_BATCH_NO',
                                                       ROWLIST_);
      ROW_.LOCATION_NO         := PKG_A.GET_ITEM_VALUE('LOCATION_NO',
                                                       ROWLIST_);
      ROW_.FBUY_UNIT_PRICE     := PKG_A.GET_ITEM_VALUE('FBUY_UNIT_PRICE',
                                                       ROWLIST_);
      ROW_.FBUY_TAX_UNIT_PRICE := PKG_A.GET_ITEM_VALUE('FBUY_TAX_UNIT_PRICE',
                                                       ROWLIST_);
      ROW_.STATE               := '0';
      ROW_.REASON              := PKG_A.GET_ITEM_VALUE('REASON', ROWLIST_);
      ROW_.REASON_DESCT        := PKG_A.GET_ITEM_VALUE('REASON_DESCT',
                                                       ROWLIST_);
      ROW_.REMARK              := PKG_A.GET_ITEM_VALUE('REMARK', ROWLIST_);
      ROW_.RMA_NO              := PKG_A.GET_ITEM_VALUE('RMA_NO', ROWLIST_);
      ROW_.RMA_LINE_NO         := PKG_A.GET_ITEM_VALUE('RMA_LINE_NO',
                                                       ROWLIST_);
      ROW_.DEF_VAT_CODE        := PKG_A.GET_ITEM_VALUE('DEF_VAT_CODE',
                                                       ROWLIST_);
      ROW_.RECEIPT_RETURN_TYPE := PKG_A.GET_ITEM_VALUE('RECEIPT_RETURN_TYPE',
                                                       ROWLIST_);
      ROW_.CO_OBJID            := PKG_A.GET_ITEM_VALUE('CO_OBJID', ROWLIST_);
      ROW_.CO_CONTRACT         := PKG_A.GET_ITEM_VALUE('CO_CONTRACT',
                                                       ROWLIST_);
    
      /*
              FLAG_ := checkStockQty(row_.CONTRACT,row_.PART_NO,row_.LOT_BATCH_NO,row_.LOCATION_NO,row_.QTY_TO_INSPECT);
                                       
              IF FLAG_ != -1 THEN
                Raise_Application_Error(-20101, '退货申请单'||row_.inspect_no||'-'||row_.inspect_no_line||'超出库存数量['||FLAG_||']，请检查');
                return;
              END IF;
      
      */
    
      -- 插入退货申请明细表的数据
      INSERT INTO BL_PURCHASE_ORDER_RETRUN_DTL
        (INSPECT_NO,
         INSPECT_NO_LINE,
         CONTRACT,
         QTY_TO_INSPECT,
         PART_NO,
         LOT_BATCH_NO,
         LOCATION_NO,
         FBUY_UNIT_PRICE,
         FBUY_TAX_UNIT_PRICE,
         STATE,
         REASON,
         REASON_DESCT,
         REMARK,
         RMA_NO,
         RMA_LINE_NO,
         DEF_VAT_CODE,
         RECEIPT_RETURN_TYPE,
         CO_OBJID,
         CO_CONTRACT)
        SELECT ROW_.INSPECT_NO,
               ROW_.INSPECT_NO_LINE,
               ROW_.CONTRACT,
               ROW_.QTY_TO_INSPECT,
               ROW_.PART_NO,
               ROW_.LOT_BATCH_NO,
               ROW_.LOCATION_NO,
               ROW_.FBUY_UNIT_PRICE,
               ROW_.FBUY_TAX_UNIT_PRICE,
               ROW_.STATE,
               ROW_.REASON,
               ROW_.REASON_DESCT,
               ROW_.REMARK,
               ROW_.RMA_NO,
               ROW_.RMA_LINE_NO,
               ROW_.DEF_VAT_CODE,
               ROW_.RECEIPT_RETURN_TYPE,
               ROW_.CO_OBJID,
               ROW_.CO_CONTRACT
          FROM DUAL;
    
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_PICKLIST_DETAIL', OBJID_);
    
      RETURN;
    END IF;
    -- 删除
    IF DOACTION_ = 'D' THEN
    
      --判断明细档状态是否可以删除明细
    
      OPEN CUR_ FOR
        SELECT T.* FROM BL_V_STOCK_RETRUN_DTL T WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '未取得明细信息');
        RETURN;
      END IF;
      CLOSE CUR_;
    
      IF ROW_.STATE <> 0 THEN
        RAISE_APPLICATION_ERROR(-20101,
                                '退货申请单' || ROW_.INSPECT_NO || '已经提交，不可删除明细');
        RETURN;
      END IF;
    
      DELETE FROM BL_PURCHASE_ORDER_RETRUN_DTL T WHERE T.ROWID = OBJID_;
    
      RETURN;
    END IF;
  
    IF DOACTION_ = 'M' THEN
    
      OPEN CUR_ FOR
        SELECT T.* FROM BL_V_STOCK_RETRUN_DTL T WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '未取得明细信息');
        RETURN;
      END IF;
      CLOSE CUR_;
    
      -- 更改数据
      ROW_.INSPECT_NO     := NVL(PKG_A.GET_ITEM_VALUE('INSPECT_NO',
                                                      ROWLIST_),
                                 ROW_.INSPECT_NO);
      ROW_.CONTRACT       := NVL(PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_),
                                 ROW_.CONTRACT);
      ROW_.QTY_TO_INSPECT := NVL(PKG_A.GET_ITEM_VALUE('QTY_TO_INSPECT',
                                                      ROWLIST_),
                                 ROW_.QTY_TO_INSPECT);
      ROW_.PART_NO        := NVL(PKG_A.GET_ITEM_VALUE('PART_NO', ROWLIST_),
                                 ROW_.PART_NO);
      ROW_.LOT_BATCH_NO   := NVL(PKG_A.GET_ITEM_VALUE('LOT_BATCH_NO',
                                                      ROWLIST_),
                                 ROW_.LOT_BATCH_NO);
      ROW_.LOCATION_NO    := NVL(PKG_A.GET_ITEM_VALUE('LOCATION_NO',
                                                      ROWLIST_),
                                 ROW_.LOCATION_NO);
      ROW_.STATE          := NVL(PKG_A.GET_ITEM_VALUE('STATE', ROWLIST_),
                                 ROW_.STATE);
    
      IF ROW_.STATE <> 0 THEN
        RAISE_APPLICATION_ERROR(-20101,
                                '退货申请单' || ROW_.INSPECT_NO || '已提交，不可修改明细');
        RETURN;
      END IF;
    
      /*
              FLAG_ := checkStockQty(row_.CONTRACT,row_.PART_NO,row_.LOT_BATCH_NO,row_.LOCATION_NO,row_.QTY_TO_INSPECT);
                                       
              IF FLAG_ != -1 THEN
                Raise_Application_Error(-20101, '退货申请单'||row_.inspect_no||'-'||row_.inspect_no_line||'超出库存数量['||FLAG_||']，请检查');
                return;
              END IF;
      
      */
    
      DATA_  := ROWLIST_;
      POS_   := INSTR(DATA_, INDEX_);
      I      := I + 1;
      MYSQL_ := ' update BL_PURCHASE_ORDER_RETRUN_DTL set ';
      LOOP
        EXIT WHEN NVL(POS_, 0) <= 0;
        EXIT WHEN I > 300;
        V_    := SUBSTR(DATA_, 1, POS_ - 1);
        DATA_ := SUBSTR(DATA_, POS_ + 1);
        POS_  := INSTR(DATA_, INDEX_);
      
        POS1_      := INSTR(V_, '|');
        COLUMN_ID_ := SUBSTR(V_, 1, POS1_ - 1);
        IF COLUMN_ID_ <> 'OBJID' AND COLUMN_ID_ <> 'PART_SEL' AND
           COLUMN_ID_ <> 'AVAIL_NUM' AND COLUMN_ID_ <> 'DOACTION' AND
           LENGTH(NVL(COLUMN_ID_, '')) > 0 THEN
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
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_PURCHASE_ORDER_RETRUN_DTL', OBJID_);
      RETURN;
    END IF;
  END;

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
    CUR_                    T_CURSOR;
    ATTR_OUT                VARCHAR2(4000);
    ROW_                    BL_V_STOCK_RETRUN_DTL%ROWTYPE;
    MAIN_ROW_               BL_V_STOCK_RETRUN%ROWTYPE;
    ROWNOPAL_               INVENTORY_PART_IN_STOCK_NOPAL%ROWTYPE;
    ROWPICK_                BL_V_PURCHASE_REG_DTL%ROWTYPE;
    ROW1_                   CUSTOMER_ORDER_LINE_TAB%ROWTYPE;
    ROW2_                   BL_V_CUSTOMER_ORDER_LINE%ROWTYPE;
    REASON_                 RETURN_CAUSE%ROWTYPE;
    DISCOUNT_               NUMBER;
    ADDITIONAL_COST_AMOUNT_ NUMBER;
    CURR_RATE_              NUMBER;
    CURR_CODE_              VARCHAR2(20);
    PERCENTAGE_             NUMBER;
  
  BEGIN
  
    IF COLUMN_ID_ = 'PART_SEL' THEN
      MAIN_ROW_.CONTRACT       := PKG_A.GET_ITEM_VALUE('CONTRACT',
                                                       MAINROWLIST_);
      MAIN_ROW_.VENDOR_NO      := PKG_A.GET_ITEM_VALUE('VENDOR_NO',
                                                       MAINROWLIST_);
      MAIN_ROW_.IS_OUTER_ORDER := PKG_A.GET_ITEM_VALUE('IS_OUTER_ORDER',
                                                       MAINROWLIST_);
      CURR_CODE_               := PKG_A.GET_ITEM_VALUE('PART_SEL', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT T.*
          FROM INVENTORY_PART_IN_STOCK_NOPAL T
         WHERE T.OBJID = CURR_CODE_;
      FETCH CUR_
        INTO ROWNOPAL_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
        RETURN;
      END IF;
      CLOSE CUR_;
      -- 赋值
      ROW_.CO_CONTRACT  := PKG_A.GET_ITEM_VALUE('CO_CONTRACT', ROWLIST_);
      ROW_.DEF_VAT_CODE := PURCHASE_PART_SUPPLIER_API.GET_DEF_VAT_CODE(MAIN_ROW_.CONTRACT,
                                                                       ROWNOPAL_.PART_NO,
                                                                       MAIN_ROW_.VENDOR_NO);
      --Row_.Unit_Meas       := Purchase_Part_Supplier_Api.Get_Unit_Meas(Main_Row_.Contract, Row_.Part_No);
      PKG_A.SET_ITEM_VALUE('PART_NO', ROWNOPAL_.PART_NO, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('LOCATION_NO', ROWNOPAL_.LOCATION_NO, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('LOT_BATCH_NO',
                           ROWNOPAL_.LOT_BATCH_NO,
                           ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('AVAIL_NUM',
                           ROWNOPAL_.QTY_ONHAND - ROWNOPAL_.QTY_RESERVED,
                           ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('QTY_TO_INSPECT',
                           ROWNOPAL_.QTY_ONHAND - ROWNOPAL_.QTY_RESERVED,
                           ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('ORDER_NO', ROWNOPAL_.LOT_BATCH_NO, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('CONTRACT', MAIN_ROW_.CONTRACT, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('DEF_VAT_CODE', ROW_.DEF_VAT_CODE, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('CO_CONTRACT', MAIN_ROW_.VENDOR_NO, ATTR_OUT);
      MAIN_ROW_.price_with_tax := pkg_a.Get_Item_Value('PRICE_WITH_TAX',MAINROWLIST_);
      row_.fbuy_tax_unit_price := PURCHASE_PART_SUPPLIER_API.Get_List_Price(MAIN_ROW_.CONTRACT,
                                                                           ROWNOPAL_.PART_NO,
                                                                           MAIN_ROW_.VENDOR_NO);
      if MAIN_ROW_.price_with_tax='TRUE' then 
         PERCENTAGE_      := STATUTORY_FEE_API.GET_PERCENTAGE(IFSAPP.SITE_API.GET_COMPANY(MAIN_ROW_.CONTRACT),
                                                               ROW_.DEF_VAT_CODE);
         row_.FBUY_UNIT_PRICE := round(row_.fbuy_tax_unit_price*100/(100 + PERCENTAGE_),6);
      else 
         row_.FBUY_UNIT_PRICE := row_.fbuy_tax_unit_price;
      end if ; 
       
      PKG_A.SET_ITEM_VALUE('FBUY_UNIT_PRICE', row_.FBUY_UNIT_PRICE, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('FBUY_TAX_UNIT_PRICE', row_.fbuy_tax_unit_price, ATTR_OUT);       
    END IF;
  
    IF COLUMN_ID_ = 'FBUY_UNIT_PRICE' OR COLUMN_ID_ = 'DEF_VAT_CODE' THEN
      -- 未税
      ROW_.FBUY_UNIT_PRICE := PKG_A.GET_ITEM_VALUE('FBUY_UNIT_PRICE',
                                                   ROWLIST_);
      ROW_.DEF_VAT_CODE    := PKG_A.GET_ITEM_VALUE('DEF_VAT_CODE', ROWLIST_);
      ROW_.CONTRACT        := PKG_A.GET_ITEM_VALUE('CONTRACT', MAINROWLIST_);
      PERCENTAGE_          := STATUTORY_FEE_API.GET_PERCENTAGE(IFSAPP.SITE_API.GET_COMPANY(ROW_.CONTRACT),
                                                               ROW_.DEF_VAT_CODE);
    
      ROW_.FBUY_TAX_UNIT_PRICE := ROW_.FBUY_UNIT_PRICE *
                                  (100 + PERCENTAGE_) / 100;
      PKG_A.SET_ITEM_VALUE('FBUY_UNIT_PRICE',
                           ROW_.FBUY_UNIT_PRICE,
                           ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('FBUY_TAX_UNIT_PRICE',
                           ROW_.FBUY_TAX_UNIT_PRICE,
                           ATTR_OUT);
    END IF;
  
    IF COLUMN_ID_ = 'FBUY_TAX_UNIT_PRICE' THEN
      -- 含税 
      ROW_.FBUY_TAX_UNIT_PRICE := PKG_A.GET_ITEM_VALUE('FBUY_TAX_UNIT_PRICE',
                                                       ROWLIST_);
      ROW_.DEF_VAT_CODE        := PKG_A.GET_ITEM_VALUE('DEF_VAT_CODE',
                                                       ROWLIST_);
      ROW_.CONTRACT            := PKG_A.GET_ITEM_VALUE('CONTRACT',
                                                       MAINROWLIST_);
      PERCENTAGE_              := STATUTORY_FEE_API.GET_PERCENTAGE(IFSAPP.SITE_API.GET_COMPANY(ROW_.CONTRACT),
                                                                   ROW_.DEF_VAT_CODE);
    
      ROW_.FBUY_UNIT_PRICE := ROUND(ROW_.FBUY_TAX_UNIT_PRICE * 100 /
                                    (100 + PERCENTAGE_),
                                    2);
      PKG_A.SET_ITEM_VALUE('FBUY_UNIT_PRICE',
                           ROW_.FBUY_UNIT_PRICE,
                           ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('FBUY_TAX_UNIT_PRICE',
                           ROW_.FBUY_TAX_UNIT_PRICE,
                           ATTR_OUT);
    
    END IF;
  
    IF COLUMN_ID_ = 'PICK_SEL' THEN
      ROWPICK_.LINE_KEY := PKG_A.GET_ITEM_VALUE('PICK_SEL', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_PURCHASE_REG_DTL T
         WHERE T.LINE_KEY = ROWPICK_.LINE_KEY;
      FETCH CUR_
        INTO ROWPICK_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
        RETURN;
      END IF;
      CLOSE CUR_;
      -- 赋值
      PKG_A.SET_ITEM_VALUE('PICKLISTNO', ROWPICK_.PICKLISTNO, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('ORDER_NO', ROWPICK_.ORDER_NO, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('RELEASE_NO', ROWPICK_.RELEASE_NO, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('LINE_NO', ROWPICK_.LINE_NO, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('PART_NO', ROWPICK_.PART_NO, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('CONTRACT', ROWPICK_.CONTRACT, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('RECEIPT_NO', ROWPICK_.RECEIPT_NO, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('FBUY_UNIT_PRICE',
                           ROWPICK_.FBUY_UNIT_PRICE,
                           ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('FBUY_TAX_UNIT_PRICE',
                           ROWPICK_.FBUY_TAX_UNIT_PRICE,
                           ATTR_OUT);
    END IF;
    IF COLUMN_ID_ = 'REASON' THEN
      REASON_.RETURN_REASON := PKG_A.GET_ITEM_VALUE('REASON', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT T.*
          FROM RETURN_CAUSE T
         WHERE T.RETURN_REASON = REASON_.RETURN_REASON;
      FETCH CUR_
        INTO REASON_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
        RETURN;
      END IF;
      CLOSE CUR_;
      -- 赋值
      PKG_A.SET_ITEM_VALUE('REASON_DESCT', REASON_.DESCRIPTION, ATTR_OUT);
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
    ROW_            BL_V_STOCK_RETRUN_DTL%ROWTYPE;
    VENDOR_NO_TYPE_ VARCHAR2(10);
    mrow_    BL_V_STOCK_RETRUN%rowtype;
  BEGIN
    ROW_.OBJID := PKG_A.GET_ITEM_VALUE('OBJID', ROWLIST_);
    ROW_.STATE := PKG_A.GET_ITEM_VALUE('STATE', ROWLIST_);
    row_.INSPECT_NO := pkg_a.Get_Item_Value('INSPECT_NO',ROWLIST_);
     select   t.*
     into mrow_ 
     from BL_V_STOCK_RETRUN t
    where INSPECT_NO = row_.INSPECT_NO;
    IF  mrow_.PRICE_WITH_TAX='TRUE'  THEN 
       IF COLUMN_ID_='FBUY_UNIT_PRICE'  THEN 
             return '0';
       END IF ;
    ELSE
       IF COLUMN_ID_='FBUY_TAX_UNIT_PRICE' THEN 
          RETURN '0';
       END IF ;
    END IF ;
    if nvl(row_.OBJID,'NULL') <> 'NULL'  and COLUMN_ID_ ='PART_SEL' then 
          return '0';
    end if ;
    IF (ROW_.STATE != 0) THEN
      RETURN '0';
    ELSE
      RETURN '1';
    END IF;
  
  END;

  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  FUNCTION CHECKBUTTON__(DOTYPE_   IN VARCHAR2,
                         ORDER_NO_ IN VARCHAR2,
                         USER_ID_  IN VARCHAR2) RETURN VARCHAR2 IS
    ROW0_ BL_V_STOCK_RETRUN%ROWTYPE;
    CUR_  T_CURSOR;
  BEGIN
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_STOCK_RETRUN T WHERE T.INSPECT_NO = ORDER_NO_;
    FETCH CUR_
      INTO ROW0_;
    IF CUR_%FOUND THEN
      IF ROW0_.state <>'0' THEN
        RETURN '0';
      END IF;
      CLOSE CUR_;
    END IF;
    CLOSE CUR_;
    RETURN '1';
  END;
  /*  获取退货单号
      row_   退货明细行 
      seqw_  临时流水号
      seq_  流水号
  */
  FUNCTION GETINSPECTLINENO(INSPECT_NO_ IN VARCHAR2) RETURN NUMBER IS
    ROW_  BL_V_STOCK_RETRUN_DTL%ROWTYPE;
    CUR   T_CURSOR;
    SEQW_ NUMBER; --流水号
    SEQ_  NUMBER;
  
  BEGIN
    -- 查询最大的退货申请号
    OPEN CUR FOR
      SELECT MAX(INSPECT_NO_LINE)
        FROM BL_V_STOCK_RETRUN_DTL T
       WHERE T.INSPECT_NO = INSPECT_NO_;
    FETCH CUR
      INTO SEQW_;
  
    SEQ_ := NVL(SEQW_, 0) + 1;
  
    CLOSE CUR;
    RETURN SEQ_;
  END;

  FUNCTION CHECKORDERPARTNO(CONTRACT_     IN VARCHAR2,
                            PART_NO_      IN VARCHAR2,
                            LOT_BATCH_NO_ IN VARCHAR2,
                            LOCATION_NO_  IN VARCHAR2,
                            RETURN_QTY_   IN NUMBER) RETURN NUMBER IS
    CUR_       T_CURSOR;
    STOCK_NUM_ NUMBER;
  BEGIN
    --无订单检测库存数量
    IF LOT_BATCH_NO_ IS NULL AND LOCATION_NO_ IS NULL THEN
    
      OPEN CUR_ FOR
        SELECT SUM(QTY_ONHAND)
          FROM INVENTORY_PART_IN_STOCK_TAB
         WHERE CONTRACT = CONTRACT_
           AND PART_NO = PART_NO_ --AND location_no = location_no_ AND lot_batch_no = lot_batch_no_
         GROUP BY CONTRACT, PART_NO; --,location_no,lot_batch_no;  
      FETCH CUR_
        INTO STOCK_NUM_;
      IF CUR_%NOTFOUND THEN
        STOCK_NUM_ := 0;
      END IF;
      CLOSE CUR_;
    
    ELSE
      OPEN CUR_ FOR
        SELECT SUM(QTY_ONHAND)
          FROM INVENTORY_PART_IN_STOCK_TAB
         WHERE CONTRACT = CONTRACT_
           AND PART_NO = PART_NO_
           AND LOCATION_NO = LOCATION_NO_
           AND LOT_BATCH_NO = LOT_BATCH_NO_
         GROUP BY CONTRACT, PART_NO, LOCATION_NO, LOT_BATCH_NO;
      FETCH CUR_
        INTO STOCK_NUM_;
      IF CUR_%NOTFOUND THEN
        STOCK_NUM_ := 0;
      END IF;
      CLOSE CUR_;
    
    END IF;
    --如果库存不足，则返回库存数量
    IF STOCK_NUM_ < RETURN_QTY_ THEN
      RETURN STOCK_NUM_;
    END IF;
    --如果库存够了，则返回-1，表示可以正常出库
    RETURN - 1;
  
  END;

  FUNCTION CHECKRECEIPTQTY(CONTRACT_     IN VARCHAR2,
                           ORDER_NO_     IN VARCHAR2,
                           LINE_NO_      IN VARCHAR2,
                           RELEASE_NO_   IN VARCHAR2,
                           PART_NO_      IN VARCHAR2,
                           LOT_BATCH_NO_ IN VARCHAR2,
                           LOCATION_NO_  IN VARCHAR2,
                           RECEIPT_NO_   IN VARCHAR2,
                           RETURN_QTY_   IN NUMBER) RETURN NUMBER IS
    CUR_         T_CURSOR;
    RECEIPT_NUM_ NUMBER;
  BEGIN
  
    OPEN CUR_ FOR
      SELECT SUM(QTY_IN_STORE)
        FROM RECEIPT_INVENTORY_LOCATION T
       WHERE T.ORDER_NO = ORDER_NO_
         AND T.LINE_NO = LINE_NO_
         AND T.RELEASE_NO = RELEASE_NO_
         AND T.RECEIPT_NO = RECEIPT_NO_
         AND CONTRACT = CONTRACT_
         AND PART_NO = PART_NO_
         AND LOCATION_NO = LOCATION_NO_
         AND LOT_BATCH_NO = LOT_BATCH_NO
       GROUP BY ORDER_NO,
                LINE_NO,
                RELEASE_NO,
                RECEIPT_NO,
                CONTRACT,
                PART_NO,
                LOCATION_NO,
                LOT_BATCH_NO;
  
    FETCH CUR_
      INTO RECEIPT_NUM_;
    IF CUR_%FOUND THEN
      IF RECEIPT_NUM_ < RETURN_QTY_ THEN
        CLOSE CUR_;
        RETURN RECEIPT_NUM_;
      END IF;
    END IF;
    CLOSE CUR_;
  
    RETURN - 1;
  
  END;

END BL_STOCK_RETRUN_DTL_API;
/
