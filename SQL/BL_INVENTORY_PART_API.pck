CREATE OR REPLACE PACKAGE BL_INVENTORY_PART_API IS
  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2);

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE Modify__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2);
  /*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
  PROCEDURE Itemchange__(Column_Id_   VARCHAR2,
                         Mainrowlist_ VARCHAR2,
                         Rowlist_     VARCHAR2,
                         User_Id_     VARCHAR2,
                         Outrowlist_  OUT VARCHAR2);
  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  FUNCTION Checkbutton__(Dotype_  IN VARCHAR2,
                         KEY_     IN VARCHAR2,
                         User_Id_ IN VARCHAR2) RETURN VARCHAR2;

  /*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
  */
  FUNCTION Checkuseable(Doaction_  IN VARCHAR2,
                        Column_Id_ IN VARCHAR,
                        Rowlist_   IN VARCHAR2) RETURN VARCHAR2;

END BL_INVENTORY_PART_API;
/
CREATE OR REPLACE PACKAGE BODY BL_INVENTORY_PART_API IS
  TYPE t_Cursor IS REF CURSOR;
  -----------------------库存件 ---------------------
  ----------create by ld  2013.01.29-----------------

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
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2) IS
    attr_out    VARCHAR2(4000);
    info_       VARCHAR2(4000);
    objid_      VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    attr_       VARCHAR2(4000);
    action_     VARCHAR2(4000);
  BEGIN
    attr_out := '';
    Action_  := 'PREPARE';
    IFSAPP.INVENTORY_PART_API.NEW__(info_,
                                    objid_,
                                    objversion_,
                                    attr_,
                                    action_);
  
    attr_out := PKG_A.Get_Attr_By_Ifs(attr_);
    -- pkg_a.Set_Item_Value('【COLUMN】','【VALUE】', attr_out);
  
    pkg_a.Setresult(A311_Key_, attr_out);
  
  END;

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE Modify__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2) IS
    info_       VARCHAR2(4000);
    objid_      VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    attr_       VARCHAR2(4000);
    action_     VARCHAR2(4000);
    attr_out    VARCHAR2(4000);
    info_text_  VARCHAR2(4000);
    Index_      VARCHAR2(1);
    Cur_        t_Cursor;
    Doaction_   VARCHAR2(10);
    Pos_        Number;
    Pos1_       Number;
    i           Number;
    v_          Varchar(1000);
    Column_Id_  Varchar(1000);
    Data_       Varchar(4000);
    Mysql_      Varchar(4000);
    Ifmychange  Varchar(1);
    row_        BL_V_INVENTORY_PART%rowtype;
  BEGIN
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ = 'I' THEN
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      /*
      --物资编码
      row_.PART_NO  := Pkg_a.Get_Item_Value('PART_NO', Rowlist_)
      --物资名称
      row_.DESCRIPTION  := Pkg_a.Get_Item_Value('DESCRIPTION', Rowlist_)
      --域
      row_.CONTRACT  := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_)
      --零件类型
      row_.TYPE_CODE  := Pkg_a.Get_Item_Value('TYPE_CODE', Rowlist_)
      --计划者
      row_.PLANNER_BUYER  := Pkg_a.Get_Item_Value('PLANNER_BUYER', Rowlist_)
      --计量单位
      row_.UNIT_MEAS  := Pkg_a.Get_Item_Value('UNIT_MEAS', Rowlist_)
      --计量单位描述
      row_.UNIT_MEAS_DESC  := Pkg_a.Get_Item_Value('UNIT_MEAS_DESC', Rowlist_)
      --商品组1
      row_.PRIME_COMMODITY  := Pkg_a.Get_Item_Value('PRIME_COMMODITY', Rowlist_)
      --商品组1描述
      row_.PRIME_COMMODITY_DESC  := Pkg_a.Get_Item_Value('PRIME_COMMODITY_DESC', Rowlist_)
      --商品组2
      row_.SECOND_COMMODITY  := Pkg_a.Get_Item_Value('SECOND_COMMODITY', Rowlist_)
      --商品组2描述
      row_.SECOND_COMMODITY_DESC  := Pkg_a.Get_Item_Value('SECOND_COMMODITY_DESC', Rowlist_)
      --物资类别
      row_.ASSET_CLASS  := Pkg_a.Get_Item_Value('ASSET_CLASS', Rowlist_)
      --物资类别描述
      row_.ASSET_CLASS_DESC  := Pkg_a.Get_Item_Value('ASSET_CLASS_DESC', Rowlist_)
      --物资状态
      row_.PART_STATUS  := Pkg_a.Get_Item_Value('PART_STATUS', Rowlist_)
      --物资状态描述
      row_.PART_STATUS_DESC  := Pkg_a.Get_Item_Value('PART_STATUS_DESC', Rowlist_)
      --ABC代码
      row_.ABC_CLASS  := Pkg_a.Get_Item_Value('ABC_CLASS', Rowlist_)
      --ABC代码描述
      row_.ABC_CLASS_DESC  := Pkg_a.Get_Item_Value('ABC_CLASS_DESC', Rowlist_)
      --安全代码
      row_.HAZARD_CODE  := Pkg_a.Get_Item_Value('HAZARD_CODE', Rowlist_)
      --安全代码描述
      row_.HAZARD_CODE_DESC  := Pkg_a.Get_Item_Value('HAZARD_CODE_DESC', Rowlist_)
      --会计组
      row_.ACCOUNTING_GROUP  := Pkg_a.Get_Item_Value('ACCOUNTING_GROUP', Rowlist_)
      --会计组描述
      row_.ACCOUNTING_GROUP_DESC  := Pkg_a.Get_Item_Value('ACCOUNTING_GROUP_DESC', Rowlist_)
      --物资大类
      row_.PART_PRODUCT_CODE  := Pkg_a.Get_Item_Value('PART_PRODUCT_CODE', Rowlist_)
      --物资大类描述
      row_.PART_PRODUCT_CODE_DESC  := Pkg_a.Get_Item_Value('PART_PRODUCT_CODE_DESC', Rowlist_)
      --物资中类
      row_.PART_PRODUCT_FAMILY  := Pkg_a.Get_Item_Value('PART_PRODUCT_FAMILY', Rowlist_)
      --物资中类描述
      row_.PART_PRODUCT_FAMILY_DESC  := Pkg_a.Get_Item_Value('PART_PRODUCT_FAMILY_DESC', Rowlist_)
      --型号规格
      row_.TYPE_DESIGNATION  := Pkg_a.Get_Item_Value('TYPE_DESIGNATION', Rowlist_)
      --材质
      row_.DIM_QUALITY  := Pkg_a.Get_Item_Value('DIM_QUALITY', Rowlist_)
      --净重
      row_.WEIGHT_NET  := Pkg_a.Get_Item_Value('WEIGHT_NET', Rowlist_)
      --现有数量
      row_.INVENTORY_QTY_ONHAND  := Pkg_a.Get_Item_Value('INVENTORY_QTY_ONHAND', Rowlist_)
      --已创建
      row_.CREATE_DATE  := Pkg_a.Get_Item_Value('CREATE_DATE', Rowlist_)
      --上次更改
      row_.LAST_ACTIVITY_DATE  := Pkg_a.Get_Item_Value('LAST_ACTIVITY_DATE', Rowlist_)
      --NOTE_TEXT
      row_.NOTE_TEXT  := Pkg_a.Get_Item_Value('NOTE_TEXT', Rowlist_)
      --NOTE_ID
      row_.NOTE_ID  := Pkg_a.Get_Item_Value('NOTE_ID', Rowlist_)
      --提前期代码
      row_.LEAD_TIME_CODE  := Pkg_a.Get_Item_Value('LEAD_TIME_CODE', Rowlist_)
      --PURCH_LEADTIME
      row_.PURCH_LEADTIME  := Pkg_a.Get_Item_Value('PURCH_LEADTIME', Rowlist_)
      --MANUF_LEADTIME
      row_.MANUF_LEADTIME  := Pkg_a.Get_Item_Value('MANUF_LEADTIME', Rowlist_)
      --EXPECTED_LEADTIME
      row_.EXPECTED_LEADTIME  := Pkg_a.Get_Item_Value('EXPECTED_LEADTIME', Rowlist_)
      --DURABILITY_DAY
      row_.DURABILITY_DAY  := Pkg_a.Get_Item_Value('DURABILITY_DAY', Rowlist_)
      --被替代件
      row_.SUPERSEDES  := Pkg_a.Get_Item_Value('SUPERSEDES', Rowlist_)
      --替代件
      row_.SUPERSEDED_BY  := Pkg_a.Get_Item_Value('SUPERSEDED_BY', Rowlist_)
      --标准名称标示号
      row_.STD_NAME_ID  := Pkg_a.Get_Item_Value('STD_NAME_ID', Rowlist_)
      --STD_NAME_NAME
      row_.STD_NAME_NAME  := Pkg_a.Get_Item_Value('STD_NAME_NAME', Rowlist_)
      --EAN编号
      row_.EAN_NO  := Pkg_a.Get_Item_Value('EAN_NO', Rowlist_)
      --供应链零件组
      row_.SUPPLY_CHAIN_PART_GROUP  := Pkg_a.Get_Item_Value('SUPPLY_CHAIN_PART_GROUP', Rowlist_)
      --供应链零件组描述
      row_.SUPPLY_CHAIN_PART_GROUP_DESC  := Pkg_a.Get_Item_Value('SUPPLY_CHAIN_PART_GROUP_DESC', Rowlist_)
      --SUPPLY_CODE
      row_.SUPPLY_CODE  := Pkg_a.Get_Item_Value('SUPPLY_CODE', Rowlist_)
      --DOP_CONNECTION
      row_.DOP_CONNECTION  := Pkg_a.Get_Item_Value('DOP_CONNECTION', Rowlist_)
      --COUNTRY_OF_ORIGIN
      row_.COUNTRY_OF_ORIGIN  := Pkg_a.Get_Item_Value('COUNTRY_OF_ORIGIN', Rowlist_)
      --COUNTRY_OF_ORIGIN_DESC
      row_.COUNTRY_OF_ORIGIN_DESC  := Pkg_a.Get_Item_Value('COUNTRY_OF_ORIGIN_DESC', Rowlist_)
      --原始的区域
      row_.REGION_OF_ORIGIN  := Pkg_a.Get_Item_Value('REGION_OF_ORIGIN', Rowlist_)
      --原始的区域描述
      row_.REGION_OF_ORIGIN_DESC  := Pkg_a.Get_Item_Value('REGION_OF_ORIGIN_DESC', Rowlist_)
      --CUSTOMS_STAT_NO
      row_.CUSTOMS_STAT_NO  := Pkg_a.Get_Item_Value('CUSTOMS_STAT_NO', Rowlist_)
      --CUSTOMS_STAT_NO_DESC
      row_.CUSTOMS_STAT_NO_DESC  := Pkg_a.Get_Item_Value('CUSTOMS_STAT_NO_DESC', Rowlist_)
      --州内转换因子
      row_.INTRASTAT_CONV_FACTOR  := Pkg_a.Get_Item_Value('INTRASTAT_CONV_FACTOR', Rowlist_)
      --CUSTOMS_STAT_NO_DESC1
      row_.CUSTOMS_STAT_NO_DESC1  := Pkg_a.Get_Item_Value('CUSTOMS_STAT_NO_DESC1', Rowlist_)
      --TECHNICAL_COORDINATOR_ID
      row_.TECHNICAL_COORDINATOR_ID  := Pkg_a.Get_Item_Value('TECHNICAL_COORDINATOR_ID', Rowlist_)
      --INVENTORY_VALUATION_METHOD
      row_.INVENTORY_VALUATION_METHOD  := Pkg_a.Get_Item_Value('INVENTORY_VALUATION_METHOD', Rowlist_)
      --INVENTORY_PART_COST_LEVEL
      row_.INVENTORY_PART_COST_LEVEL  := Pkg_a.Get_Item_Value('INVENTORY_PART_COST_LEVEL', Rowlist_)
      --ZERO_COST_FLAG
      row_.ZERO_COST_FLAG  := Pkg_a.Get_Item_Value('ZERO_COST_FLAG', Rowlist_)
      --实际成本计算
      row_.ACTUAL_COST_DB  := Pkg_a.Get_Item_Value('ACTUAL_COST_DB', Rowlist_)
      --最大实际成本更新
      row_.MAX_ACTUAL_COST_UPDATE  := Pkg_a.Get_Item_Value('MAX_ACTUAL_COST_UPDATE', Rowlist_)
      --零件成本组
      row_.PART_COST_GROUP_ID  := Pkg_a.Get_Item_Value('PART_COST_GROUP_ID', Rowlist_)
      --PART_COST_GROUP_ID_DESC
      row_.PART_COST_GROUP_ID_DESC  := Pkg_a.Get_Item_Value('PART_COST_GROUP_ID_DESC', Rowlist_)
      --EXT_SERVICE_COST_METHOD
      row_.EXT_SERVICE_COST_METHOD  := Pkg_a.Get_Item_Value('EXT_SERVICE_COST_METHOD', Rowlist_)
      --CYCLE_PERIOD
      row_.CYCLE_PERIOD  := Pkg_a.Get_Item_Value('CYCLE_PERIOD', Rowlist_)
      --COUNT_VARIANCE
      row_.COUNT_VARIANCE  := Pkg_a.Get_Item_Value('COUNT_VARIANCE', Rowlist_)
      --CYCLE_CODE_DB
      row_.CYCLE_CODE_DB  := Pkg_a.Get_Item_Value('CYCLE_CODE_DB', Rowlist_)
      --OE_ALLOC_ASSIGN_FLAG
      row_.OE_ALLOC_ASSIGN_FLAG  := Pkg_a.Get_Item_Value('OE_ALLOC_ASSIGN_FLAG', Rowlist_)
      --NEGATIVE_ON_HAND_DB
      row_.NEGATIVE_ON_HAND_DB  := Pkg_a.Get_Item_Value('NEGATIVE_ON_HAND_DB', Rowlist_)
      --SHORTAGE_FLAG_DB
      row_.SHORTAGE_FLAG_DB  := Pkg_a.Get_Item_Value('SHORTAGE_FLAG_DB', Rowlist_)
      --STOCK_MANAGEMENT_DB
      row_.STOCK_MANAGEMENT_DB  := Pkg_a.Get_Item_Value('STOCK_MANAGEMENT_DB', Rowlist_)
      --FORECAST_CONSUMPTION_FLAG_DB
      row_.FORECAST_CONSUMPTION_FLAG_DB  := Pkg_a.Get_Item_Value('FORECAST_CONSUMPTION_FLAG_DB', Rowlist_)
      --ONHAND_ANALYSIS_FLAG_DB
      row_.ONHAND_ANALYSIS_FLAG_DB  := Pkg_a.Get_Item_Value('ONHAND_ANALYSIS_FLAG_DB', Rowlist_)
      --CUST_WARRANTY_ID
      row_.CUST_WARRANTY_ID  := Pkg_a.Get_Item_Value('CUST_WARRANTY_ID', Rowlist_)
      --SUP_WARRANTY_ID
      row_.SUP_WARRANTY_ID  := Pkg_a.Get_Item_Value('SUP_WARRANTY_ID', Rowlist_)
      --NOTE_DESC
      row_.NOTE_DESC  := Pkg_a.Get_Item_Value('NOTE_DESC', Rowlist_)
      --ORDER_REQUISITION_DB
      row_.ORDER_REQUISITION_DB  := Pkg_a.Get_Item_Value('ORDER_REQUISITION_DB', Rowlist_)
      --提前期代码
      row_.LEAD_TIME_CODE_DB  := Pkg_a.Get_Item_Value('LEAD_TIME_CODE_DB', Rowlist_)
      --DOP连接
      row_.DOP_CONNECTION_DB  := Pkg_a.Get_Item_Value('DOP_CONNECTION_DB', Rowlist_)
      --库存估价方法
      row_.INVENTORY_VALUATION_METHOD_DB  := Pkg_a.Get_Item_Value('INVENTORY_VALUATION_METHOD_DB', Rowlist_)
      --TYPE_CODE_DB
      row_.TYPE_CODE_DB  := Pkg_a.Get_Item_Value('TYPE_CODE_DB', Rowlist_)
      --LINE_KEY
      row_.LINE_KEY  := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_)*/
      -- PART_NO 6516166165 DESCRIPTION SFSDFSDFAF CONTRACT 20 TYPE_CODE 采购 PLANNER_BUYER * UNIT_MEAS pcs 
      --PRIME_COMMODITY A317 SECOND_COMMODITY D100 ASSET_CLASS R PART_STATUS N ABC_CLASS A HAZARD_CODE 10 
      --ACCOUNTING_GROUP 007 PART_PRODUCT_CODE B1055 PART_PRODUCT_FAMILY 11260 TYPE_DESIGNATION wfwef 
      --DIM_QUALITY wef WEIGHT_NET 100 LEAD_TIME_CODE 采购 PURCH_LEADTIME 0 MANUF_LEADTIME 0 
      --EXPECTED_LEADTIME 0 SUPPLY_CODE 库存订单 DOP_CONNECTION 手动 DOP 
      --INVENTORY_PART_COST_LEVEL 每一零件成本 ZERO_COST_FLAG 禁止零成本 CYCLE_PERIOD 0 
      --CYCLE_CODE_DB N STOCK_MANAGEMENT_DB SYSTEM MANAGED INVENTORY;
      CLIENT_SYS.Add_To_Attr('PART_NO',
                             PKG_A.Get_Item_Value('PART_NO', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('DESCRIPTION',
                             PKG_A.Get_Item_Value('DESCRIPTION', ROWLIST_),
                             attr_);
      /*      CLIENT_SYS.Add_To_Attr('SFSDFSDFAF',
      PKG_A.Get_Item_Value('SFSDFSDFAF', ROWLIST_),
      attr_);*/
      CLIENT_SYS.Add_To_Attr('CONTRACT',
                             PKG_A.Get_Item_Value('CONTRACT', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('TYPE_CODE',
                             PKG_A.Get_Item_Value('TYPE_CODE', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('PLANNER_BUYER',
                             PKG_A.Get_Item_Value('PLANNER_BUYER', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('UNIT_MEAS',
                             PKG_A.Get_Item_Value('UNIT_MEAS', ROWLIST_),
                             attr_);
    
      CLIENT_SYS.Add_To_Attr('PRIME_COMMODITY',
                             PKG_A.Get_Item_Value('PRIME_COMMODITY',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('SECOND_COMMODITY',
                             PKG_A.Get_Item_Value('SECOND_COMMODITY',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('ASSET_CLASS',
                             PKG_A.Get_Item_Value('ASSET_CLASS', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('PART_STATUS',
                             PKG_A.Get_Item_Value('PART_STATUS', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('ABC_CLASS',
                             PKG_A.Get_Item_Value('ABC_CLASS', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('HAZARD_CODE',
                             PKG_A.Get_Item_Value('HAZARD_CODE', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('ACCOUNTING_GROUP',
                             PKG_A.Get_Item_Value('ACCOUNTING_GROUP',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('PART_PRODUCT_CODE',
                             PKG_A.Get_Item_Value('PART_PRODUCT_CODE',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('PART_PRODUCT_FAMILY',
                             PKG_A.Get_Item_Value('PART_PRODUCT_FAMILY',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('TYPE_DESIGNATION',
                             PKG_A.Get_Item_Value('TYPE_DESIGNATION',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('DIM_QUALITY',
                             PKG_A.Get_Item_Value('DIM_QUALITY', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('WEIGHT_NET',
                             PKG_A.Get_Item_Value('WEIGHT_NET', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('LEAD_TIME_CODE',
                             PKG_A.Get_Item_Value('LEAD_TIME_CODE',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('PURCH_LEADTIME',
                             PKG_A.Get_Item_Value('PURCH_LEADTIME',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('MANUF_LEADTIME',
                             PKG_A.Get_Item_Value('MANUF_LEADTIME',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('EXPECTED_LEADTIME',
                             PKG_A.Get_Item_Value('EXPECTED_LEADTIME',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('SUPPLY_CODE',
                             PKG_A.Get_Item_Value('SUPPLY_CODE', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('DOP_CONNECTION',
                             PKG_A.Get_Item_Value('DOP_CONNECTION',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('ZERO_COST_FLAG',
                             PKG_A.Get_Item_Value('ZERO_COST_FLAG',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('INVENTORY_PART_COST_LEVEL',
                             PKG_A.Get_Item_Value('INVENTORY_PART_COST_LEVEL',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('CYCLE_PERIOD',
                             PKG_A.Get_Item_Value('CYCLE_PERIOD', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('CYCLE_CODE_DB',
                             PKG_A.Get_Item_Value('CYCLE_CODE_DB', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('STOCK_MANAGEMENT_DB',
                             PKG_A.Get_Item_Value('STOCK_MANAGEMENT_DB',
                                                  ROWLIST_),
                             attr_);
      /*      CLIENT_SYS.Add_To_Attr('MANAGED',
      PKG_A.Get_Item_Value('MANAGED', ROWLIST_),
      attr_);*/
      IFSAPP.Part_Catalog_API.Create_Part(PKG_A.Get_Item_Value('PART_NO',
                                                               ROWLIST_),
                                          PKG_A.Get_Item_Value('DESCRIPTION',
                                                               ROWLIST_),
                                          PKG_A.Get_Item_Value('UNIT_MEAS',
                                                               ROWLIST_),
                                          Pkg_a.Get_Item_Value('STD_NAME_ID',
                                                               Rowlist_),
                                          info_text_);
      insert into a1
        (col, id)
        select attr_, s_a1.nextval from dual;
      commit;
      Action_ := 'DO';
      IFSAPP.INVENTORY_PART_API.NEW__(info_,
                                      objid_,
                                      objversion_,
                                      attr_,
                                      action_);
      /*      attr_out := PKG_A.Get_Attr_By_Ifs(attr_);
      -- pkg_a.Set_Item_Value('【COLUMN】','【VALUE】', attr_out);
      
      pkg_a.Setresult(A311_Key_, attr_out);*/
      pkg_a.Setsuccess(A311_Key_, 'BL_V_INVENTORY_PART', Objid_);
    END IF;
    --修改    CYCLE_CODE_DB N STOCK_MANAGEMENT_DB SYSTEM MANAGED INVENTORY
    IF Doaction_ = 'M' THEN
      /*--pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
             Open Cur_ For
              Select t.* From BL_V_INVENTORY_PART t Where t.Objid = Objid_;
            Fetch Cur_
              Into Row_;
            If Cur_%Notfound Then
              Raise_Application_Error(Pkg_a.Raise_Error,'错误的rowid！');
            
            End If;
            Close Cur_;
            Data_      := Rowlist_;
            Pos_       := Instr(Data_, Index_);
            i          := i + 1;
            Mysql_     :='update BL_V_INVENTORY_PART SET ';
            Ifmychange :='0';
            Loop
              Exit When Nvl(Pos_, 0) <= 0;
              Exit When i > 300;
              v_    := Substr(Data_, 1, Pos_ - 1);
              Data_ := Substr(Data_, Pos_ + 1);
              Pos_  := Instr(Data_, Index_);
            
              Pos1_      := Instr(v_,'|');
              Column_Id_ := Substr(v_, 1, Pos1_ - 1);
            
              If Column_Id_ <> 'OBJID'  And  Column_Id_ <> 'DOACTION' And
                 Length(Nvl(Column_Id_,'')) > 0 Then
                Ifmychange :='1';
                v_         := Substr(v_, Pos1_ + 1);
                Mysql_     := Mysql_ || Column_Id_ || ='''|| v_ ||'',';
        End If;
      
      End Loop;
      
      --用户自定义列
      If Ifmychange ='1' Then 
         Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User ='''|| User_Id_ ||'''; 
         Mysql_ := Mysql_ || 'Where Rowid ='''|| Row_.Objid ||''';
      -- raise_application_error(Pkg_a.Raise_Error, mysql_);
         Execute Immediate Mysql_;
      End If;
      
      Pkg_a.Setsuccess(A311_Key_,'BL_V_INVENTORY_PART', Row_.Objid); */
      Return;
    End If;
    --删除
    If Doaction_ = 'D' Then
      /*OPEN CUR_ FOR
              SELECT T.* FROM BL_V_INVENTORY_PART T WHERE T.ROWID = OBJID_;
            FETCH CUR_
              INTO ROW_;
            IF CUR_ %NOTFOUND THEN
              CLOSE CUR_;
              RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
              return;
            end if;
            close cur_;
      --      DELETE FROM BL_V_INVENTORY_PART T WHERE T.ROWID = OBJID_; */
      --pkg_a.Setsuccess(A311_Key_,'BL_V_INVENTORY_PART', Objid_);
      Return;
    End If;
  
  End;
  /*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2) Is
    Attr_Out Varchar2(4000);
  Begin
    If Column_Id_ = '' Then
      --给列赋值
      Pkg_a.Set_Item_Value('【COLUMN】', '【value】', Attr_Out);
      --设置列不可用
      Pkg_a.Set_Column_Enable('【column】', '0', Attr_Out);
      --设置列可用
      Pkg_a.Set_Column_Enable('【column】', '1', Attr_Out);
    End If;
    Outrowlist_ := Attr_Out;
  End;
  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  Function Checkbutton__(Dotype_  In Varchar2,
                         Key_     In Varchar2,
                         User_Id_ In Varchar2) Return Varchar2 Is
  Begin
    If Dotype_ = 'Add_Row' Then
      Return '1';
    End If;
    If Dotype_ = 'Del_Row' Then
      Return '1';
    End If;
    Return '1';
  End;

  /*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
      返回: 1 可用
      0 不可用
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
  Begin
    If Column_Id_ = '【column】' Then
      Return '0';
    End If;
    Return '1';
  End;

End BL_INVENTORY_PART_API;
/
