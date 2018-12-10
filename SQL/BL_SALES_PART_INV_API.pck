CREATE OR REPLACE PACKAGE BL_SALES_PART_INV_API IS
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

  --右键保存
  PROCEDURE sales_save__(Rowlist_  VARCHAR2,
                         User_Id_  VARCHAR2,
                         A311_Key_ VARCHAR2);
END BL_SALES_PART_INV_API;
/
CREATE OR REPLACE PACKAGE BODY BL_SALES_PART_INV_API IS
  TYPE t_Cursor IS REF CURSOR;
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
    ROW_        BL_V_SALES_PART_INV%ROWTYPE;
  BEGIN
    attr_out := '';
    -- COST0CATALOG_TYPE_DBINVPART_DESCRIPTIONCREATE_PURCHASE_PARTFALSE
    -- pkg_a.Set_Item_Value('【COLUMN】','【VALUE】', attr_out);
  
    action_ := 'PREPARE';
    Client_Sys.Add_To_Attr('COST', 0, Attr_);
    Client_Sys.Add_To_Attr('CATALOG_TYPE_DB', 'INV', Attr_);
    Client_Sys.Add_To_Attr('PART_DESCRIPTION', '', Attr_);
    Client_Sys.Add_To_Attr('CREATE_PURCHASE_PART', 'FALSE', Attr_);
  
    IFSAPP.SALES_PART_API.NEW__(info_, objid_, objversion_, attr_, action_);
  
    Attr_Out                  := Pkg_a.Get_Attr_By_Ifs(Attr_);
    ROW_.CONTRACT             := PKG_A.Get_Item_Value('CONTRACT', Attr_Out);
    ROW_.COMPANY              := IFSAPP.SITE_API.GET_COMPANY(ROW_.CONTRACT);
    ROW_.Currency_Code_DESC   := IFSAPP.COMPANY_FINANCE_API.GET_CURRENCY_CODE(ROW_.COMPANY);
    ROW_.Currency_Code_DESC_1 := IFSAPP.COMPANY_FINANCE_API.GET_CURRENCY_CODE(ROW_.COMPANY);
    pkg_a.Set_Item_Value('CURRENCY_CODE_DESC',
                         ROW_.Currency_Code_DESC,
                         attr_out);
    pkg_a.Set_Item_Value('CURRENCY_CODE_DESC_1',
                         ROW_.Currency_Code_DESC_1,
                         attr_out);
    pkg_a.Set_Item_Value('CATALOG_TYPE_DB', 'INV', attr_out);
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
    row_        BL_V_SALES_PART_INV%rowtype;
  BEGIN
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ = 'I' THEN
    
      Action_ := 'DO';
      Client_Sys.Add_To_Attr('CATALOG_NO',
                             PKG_A.Get_Item_Value('CATALOG_NO', ROWLIST_),
                             Attr_);
      CLIENT_SYS.ADD_TO_ATTR('CATALOG_DESC',
                             Pkg_a.Get_Item_Value('CATALOG_DESC', Rowlist_),
                             ATTR_);
      Client_Sys.Add_To_Attr('CONTRACT',
                             PKG_A.Get_Item_Value('CONTRACT', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('COMPANY',
                             PKG_A.Get_Item_Value('COMPANY', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('PART_NO',
                             PKG_A.Get_Item_Value('PART_NO', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('SOURCING_OPTION',
                             PKG_A.Get_Item_Value('SOURCING_OPTION',
                                                  ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('RULE_ID',
                             PKG_A.Get_Item_Value('RULE_ID', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('UNIT_MEAS',
                             PKG_A.Get_Item_Value('UNIT_MEAS', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('CONV_FACTOR',
                             PKG_A.Get_Item_Value('CONV_FACTOR', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('PRICE_UNIT_MEAS',
                             PKG_A.Get_Item_Value('PRICE_UNIT_MEAS',
                                                  ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('PRICE_CONV_FACTOR',
                             PKG_A.Get_Item_Value('PRICE_CONV_FACTOR',
                                                  ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('SALES_UNIT_MEAS',
                             PKG_A.Get_Item_Value('SALES_UNIT_MEAS',
                                                  ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('SALES_PRICE_GROUP_ID',
                             PKG_A.Get_Item_Value('SALES_PRICE_GROUP_ID',
                                                  ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('CATALOG_GROUP',
                             PKG_A.Get_Item_Value('CATALOG_GROUP', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('DATE_ENTERED',
                             PKG_A.Get_Item_Value('DATE_ENTERED', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('LIST_PRICE',
                             PKG_A.Get_Item_Value('LIST_PRICE', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('FEE_CODE',
                             PKG_A.Get_Item_Value('FEE_CODE', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('ACTIVEIND_DB',
                             PKG_A.Get_Item_Value('ACTIVEIND_DB', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('TAXABLE_DB',
                             PKG_A.Get_Item_Value('TAXABLE_DB', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('CLOSE_TOLERANCE',
                             PKG_A.Get_Item_Value('CLOSE_TOLERANCE',
                                                  ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('EAN_NO',
                             PKG_A.Get_Item_Value('EAN_NO', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('BONUS_BASIS_FLAG_DB',
                             PKG_A.Get_Item_Value('BONUS_BASIS_FLAG_DB',
                                                  ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('BONUS_VALUE_FLAG_DB',
                             PKG_A.Get_Item_Value('BONUS_VALUE_FLAG_DB',
                                                  ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('CREATE_SM_OBJECT_OPTION_DB',
                             PKG_A.Get_Item_Value('CREATE_SM_OBJECT_OPTION_DB',
                                                  ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('WEIGHT_NET',
                             PKG_A.Get_Item_Value('WEIGHT_NET', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('WEIGHT_GROSS',
                             PKG_A.Get_Item_Value('WEIGHT_GROSS', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('COST',
                             PKG_A.Get_Item_Value('COST', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('CATALOG_TYPE_DB',
                             PKG_A.Get_Item_Value('CATALOG_TYPE_DB',
                                                  ROWLIST_),
                             Attr_);
      /*      Client_Sys.Add_To_Attr('PART_DESCRIPTION',
      PKG_A.Get_Item_Value('PART_DESCRIPTION',
                           ROWLIST_),
      Attr_);*/
      Client_Sys.Add_To_Attr('CREATE_PURCHASE_PART',
                             PKG_A.Get_Item_Value('CREATE_PURCHASE_PART',
                                                  ROWLIST_),
                             Attr_);
      /*      CLIENT_SYS.ADD_TO_ATTR('CATALOG_NO',
                             Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('CATALOG_DESC',
                             Pkg_a.Get_Item_Value('CATALOG_DESC', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('CONTRACT',
                             Pkg_a.Get_Item_Value('CONTRACT', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('COMPANY',
                             Pkg_a.Get_Item_Value('COMPANY', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('CATALOG_TYPE_DB',
                             Pkg_a.Get_Item_Value('CATALOG_TYPE_DB',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('CATALOG_TYPE',
                             Pkg_a.Get_Item_Value('CATALOG_TYPE', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('SALES_UNIT_MEAS',
                             Pkg_a.Get_Item_Value('SALES_UNIT_MEAS',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('PRICE_CONV_FACTOR',
                             Pkg_a.Get_Item_Value('PRICE_CONV_FACTOR',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('CONV_FACTOR',
                             Pkg_a.Get_Item_Value('CONV_FACTOR', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('PRICE_UNIT_MEAS',
                             Pkg_a.Get_Item_Value('PRICE_UNIT_MEAS',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('SALES_PRICE_GROUP_ID',
                             Pkg_a.Get_Item_Value('SALES_PRICE_GROUP_ID',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('CATALOG_GROUP',
                             Pkg_a.Get_Item_Value('CATALOG_GROUP', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('DISCOUNT_GROUP',
                             Pkg_a.Get_Item_Value('DISCOUNT_GROUP',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('FEE_CODE',
                             Pkg_a.Get_Item_Value('FEE_CODE', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('DATE_ENTERED',
                             Pkg_a.Get_Item_Value('DATE_ENTERED', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('ACTIVEIND_DB',
                             Pkg_a.Get_Item_Value('ACTIVEIND_DB', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('TAXABLE_DB',
                             Pkg_a.Get_Item_Value('TAXABLE_DB', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('CLOSE_TOLERANCE',
                             Pkg_a.Get_Item_Value('CLOSE_TOLERANCE',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('BONUS_BASIS_FLAG_DB',
                             Pkg_a.Get_Item_Value('BONUS_BASIS_FLAG_DB',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('BONUS_VALUE_FLAG_DB',
                             Pkg_a.Get_Item_Value('BONUS_VALUE_FLAG_DB',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('LIST_PRICE',
                             Pkg_a.Get_Item_Value('LIST_PRICE', Rowlist_),
                             ATTR_);*/
      IFSAPP.SALES_PART_API.NEW__(info_,
                                  objid_,
                                  objversion_,
                                  attr_,
                                  action_);
    
      pkg_a.Setsuccess(A311_Key_, 'BL_V_SALES_PART_INV', Objid_);
    END IF;
    --修改
    IF Doaction_ = 'M' THEN
      Open Cur_ For
        Select t.* From BL_V_SALES_PART_INV t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        CLOSE CUR_;
        Raise_Application_Error(Pkg_a.Raise_Error, '错误的rowid！');
        RETURN;
      End If;
      Close Cur_;
      Data_ := Rowlist_;
      Pos_  := Instr(Data_, Index_);
      i     := i + 1;
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
      
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' And
           Length(Nvl(Column_Id_, '')) > 0 Then
          v_ := Substr(v_, Pos1_ + 1);
          Client_Sys.Add_To_Attr(Column_Id_, v_, Attr_);
        End If;
      End Loop;
      action_     := 'DO';
      objversion_ := ROW_.OBJVERSION;
      IFSAPP.SALES_PART_API.MODIFY__(info_,
                                     objid_,
                                     objversion_,
                                     attr_,
                                     action_);
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_SALES_PART_INV', Row_.Objid);
    
    End If;
    --删除
    If Doaction_ = 'D' Then
      /*OPEN CUR_ FOR
              SELECT T.* FROM BL_V_SALES_PART_INV T WHERE T.ROWID = OBJID_;
            FETCH CUR_
              INTO ROW_;
            IF CUR_ %NOTFOUND THEN
              CLOSE CUR_;
              RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
              return;
            end if;
            close cur_;
      --      DELETE FROM BL_V_SALES_PART_INV T WHERE T.ROWID = OBJID_; */
      --pkg_a.Setsuccess(A311_Key_,'BL_V_SALES_PART_INV', Objid_);
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
    Attr_Out     Varchar2(4000);
    ROW_         BL_V_SALES_PART_INV%ROWTYPE;
    PRICE_GROUP_ SALES_PRICE_GROUP%ROWTYPE; --销售价格分组
    SALES_GROUP_ SALES_GROUP%ROWTYPE; --销售分组 
    DIS_GROUP_   SALES_DISCOUNT_GROUP%ROWTYPE; --折扣分组
    FEE_CODE_    STATUTORY_FEE_DEDUCT_MULTIPLE%ROWTYPE; --增值税
    RULE_ID_     SOURCING_RULE%ROWTYPE;
    CUR_         T_CURSOR;
  Begin
    If Column_Id_ = 'CONTRACT' Then
      ROW_.CONTRACT             := PKG_A.Get_Item_Value('CONTRACT',
                                                        ROWLIST_);
      ROW_.COMPANY              := IFSAPP.SITE_API.GET_COMPANY(ROW_.CONTRACT);
      ROW_.Currency_Code_DESC   := IFSAPP.COMPANY_FINANCE_API.GET_CURRENCY_CODE(ROW_.COMPANY);
      ROW_.Currency_Code_DESC_1 := IFSAPP.COMPANY_FINANCE_API.GET_CURRENCY_CODE(ROW_.COMPANY);
    
      Pkg_a.Set_Item_Value('COMPANY', ROW_.COMPANY, Attr_Out);
      Pkg_a.Set_Item_Value('CURRENCY_CODE_DESC',
                           ROW_.CURRENCY_CODE_DESC,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CURRENCY_CODE_DESC_1',
                           ROW_.Currency_Code_DESC_1,
                           Attr_Out);
    END IF;
    IF COLUMN_ID_ = 'SALES_PRICE_GROUP_ID' THEN
      --销售价格分组
    
      ROW_.SALES_UNIT_MEAS := PKG_A.Get_Item_Value('SALES_PRICE_GROUP_ID',
                                                   ROWLIST_);
      open cur_ for
        select t.*
          from SALES_PRICE_GROUP t
         where t.sales_price_group_id = ROW_.SALES_UNIT_MEAS;
      fetch cur_
        into PRICE_GROUP_;
      close cur_;
      pkg_a.Set_Item_Value('SALES_PRICE_GROUP_DESC',
                           PRICE_GROUP_.description,
                           Attr_Out);
    END IF;
    IF COLUMN_ID_ = 'CATALOG_GROUP' THEN
      ROW_.CATALOG_GROUP := PKG_A.Get_Item_Value('CATALOG_GROUP', ROWLIST_);
      OPEN CUR_ FOR
        SELECT T.*
          FROM SALES_GROUP T
         WHERE T.catalog_group = ROW_.CATALOG_GROUP;
      FETCH CUR_
        INTO SALES_GROUP_;
      CLOSE CUR_;
      PKG_A.Set_Item_Value('CATALOG_GROUP_DESC',
                           SALES_GROUP_.description,
                           Attr_Out);
    END IF;
    IF COLUMN_ID_ = 'DISCOUNT_GROUP' THEN
      ROW_.DISCOUNT_GROUP := PKG_A.Get_Item_Value('DISCOUNT_GROUP',
                                                  ROWLIST_);
      OPEN CUR_ FOR
        SELECT T.*
          FROM SALES_DISCOUNT_GROUP T
         WHERE T.discount_group = ROW_.DISCOUNT_GROUP;
      FETCH CUR_
        INTO DIS_GROUP_;
      CLOSE CUR_;
      PKG_A.Set_Item_Value('DISCOUNT_GROUP_DESC',
                           DIS_GROUP_.description,
                           Attr_Out);
    END IF;
    IF COLUMN_ID_ = 'FEE_CODE' THEN
      ROW_.FEE_CODE := PKG_A.Get_Item_Value('FEE_CODE', ROWLIST_);
      ROW_.CONTRACT := PKG_A.Get_Item_Value('CONTRACT', ROWLIST_);
      ROW_.COMPANY  := IFSAPP.SITE_API.GET_COMPANY(ROW_.CONTRACT);
      OPEN CUR_ FOR
        SELECT T.*
          FROM STATUTORY_FEE_DEDUCT_MULTIPLE T
         WHERE T.fee_code = ROW_.FEE_CODE
           AND T.company = ROW_.COMPANY;
      FETCH CUR_
        INTO FEE_CODE_;
      CLOSE CUR_;
      PKG_A.Set_Item_Value('FEE_CODE_DESC',
                           FEE_CODE_.description,
                           Attr_Out);
    END IF;
    IF COLUMN_ID_ = 'RULE_ID' THEN
      ROW_.RULE_ID := PKG_A.Get_Item_Value('RULE_ID', ROWLIST_);
      OPEN CUR_ FOR
        SELECT T.* FROM SOURCING_RULE T WHERE T.rule_id = ROW_.RULE_ID;
      FETCH CUR_
        INTO RULE_ID_;
      CLOSE CUR_;
      PKG_A.Set_Item_Value('RULE_DESCRIPTION',
                           RULE_ID_.DESCRIPTION,
                           Attr_Out);
    END IF;
    IF COLUMN_ID_ = 'CATALOG_NO' THEN
      ROW_.CATALOG_NO := PKG_A.Get_Item_Value('CATALOG_NO', ROWLIST_);
      PKG_A.Set_Item_Value('PART_NO', ROW_.CATALOG_NO, Attr_Out);
    END IF;
    IF COLUMN_ID_ = 'CATALOG_DESC' THEN
      ROW_.CATALOG_DESC := PKG_A.Get_Item_Value('CATALOG_DESC', ROWLIST_);
      PKG_A.Set_Item_Value('DESCRIPTION', ROW_.CATALOG_DESC, Attr_Out);
    END IF;
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
    ROW_ BL_V_SALES_PART_INV%rowtype;
  
  Begin
    ROW_.OBJID := PKG_A.Get_Item_Value('OBJID', ROWLIST_);
    IF NVL(ROW_.OBJID, 'NULL') <> 'NULL' THEN
      If Column_Id_ = 'CATALOG_NO' OR Column_Id_ = 'CONTRACT' OR
         Column_Id_ = 'PART_NO' OR Column_Id_ = 'CATALOG_DESC' Then
        Return '0';
      End If;
    ELSE
      RETURN '1';
    END IF;
  End;
  --销售件右键保存
  PROCEDURE sales_save__(Rowlist_  VARCHAR2,
                         User_Id_  VARCHAR2,
                         A311_Key_ VARCHAR2) IS
    ROW_        BL_V_SALES_PART_INV%rowtype;
    SROW_       SALES_PART%rowtype;
    cur_        t_cursor;
    Index_      VARCHAR2(1);
    info_       VARCHAR2(4000);
    objid_      VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    attr_       VARCHAR2(4000);
    action_     VARCHAR2(4000);
    Pos_        Number;
    Pos1_       Number;
    i           Number;
    v_          Varchar(1000);
    Column_Id_  Varchar(1000);
    Data_       Varchar(4000);
  BEGIN
    SROW_.OBJID := PKG_A.Get_Item_Value('OBJID', ROWLIST_);
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_SALES_PART_INV T WHERE T.OBJID = SROW_.OBJID;
    FETCH CUR_
      INTO ROW_;
    IF CUR_ %NOTFOUND THEN
      CLOSE CUR_;
      RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
      return;
    end if;
    close cur_;
    Index_ := f_Get_Data_Index();
    Data_  := Rowlist_;
    Pos_   := Instr(Data_, Index_);
    i      := i + 1;
    Loop
      Exit When Nvl(Pos_, 0) <= 0;
      Exit When i > 300;
      v_    := Substr(Data_, 1, Pos_ - 1);
      Data_ := Substr(Data_, Pos_ + 1);
      Pos_  := Instr(Data_, Index_);
    
      Pos1_      := Instr(v_, '|');
      Column_Id_ := Substr(v_, 1, Pos1_ - 1);
    
      If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' And
         Length(Nvl(Column_Id_, '')) > 0 Then
        v_ := Substr(v_, Pos1_ + 1);
        Client_Sys.Add_To_Attr(Column_Id_, v_, Attr_);
      End If;
    End Loop;
    action_     := 'DO';
    objversion_ := ROW_.OBJVERSION;
    IFSAPP.SALES_PART_API.MODIFY__(info_,
                                   SROW_.OBJID,
                                   objversion_,
                                   attr_,
                                   action_);
  END;

End BL_SALES_PART_INV_API;
/
