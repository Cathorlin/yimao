CREATE OR REPLACE PACKAGE BL_SALES_PART_API IS
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

END BL_SALES_PART_API;
/
CREATE OR REPLACE PACKAGE BODY BL_SALES_PART_API IS
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
    action_     VARCHAR2(100);
    ATTR_       VARCHAR2(4000);
    row_        BL_V_SALES_PART%rowtype;
  BEGIN
    attr_out := '';
    Action_  := 'PREPARE';
    --'CATALOG_TYPE_DBPKGLIST_PRICE0')
    CLIENT_SYS.ADD_TO_ATTR('CATALOG_TYPE_DB', 'PKG', ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('LIST_PRICE', 0, ATTR_);
  
    IFSAPP.SALES_PART_API.NEW__(info_, objid_, objversion_, ATTR_, action_);
    attr_out                    := Pkg_a.Get_Attr_By_Ifs(Attr_);
    ROW_.CONTRACT               := PKG_A.Get_Item_Value('CONTRACT',
                                                        Attr_Out);
    ROW_.COMPANY                := IFSAPP.SITE_API.GET_COMPANY(ROW_.CONTRACT);
    ROW_.CURRENCY_CODE          := IFSAPP.COMPANY_FINANCE_API.GET_CURRENCY_CODE(ROW_.COMPANY);
    ROW_.CURRENCY_CODE_T        := IFSAPP.COMPANY_FINANCE_API.GET_CURRENCY_CODE(ROW_.COMPANY);
    ROW_.CURRENCY_CODE_EXPECTED := IFSAPP.COMPANY_FINANCE_API.GET_CURRENCY_CODE(ROW_.COMPANY);
    pkg_a.Set_Item_Value('CURRENCY_CODE', ROW_.CURRENCY_CODE, attr_out);
    pkg_a.Set_Item_Value('CURRENCY_CODE_T', ROW_.CURRENCY_CODE_T, attr_out);
    pkg_a.Set_Item_Value('CURRENCY_CODE_EXPECTED',
                         ROW_.CURRENCY_CODE_EXPECTED,
                         attr_out);
    pkg_a.Set_Item_Value('CATALOG_TYPE', 'Package part', attr_out);
    pkg_a.Set_Item_Value('CATALOG_TYPE_DB', 'PKG', attr_out);
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
    Objid_      VARCHAR2(50);
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
    action_     VARCHAR2(100);
    info_       VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    ATTR_       VARCHAR2(4000);
    row_        BL_V_SALES_PART%rowtype;
  BEGIN
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ = 'I' THEN
      action_ := 'DO';
    
      CLIENT_SYS.ADD_TO_ATTR('CATALOG_NO',
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
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('EXPECTED_AVERAGE_PRICE',
                             Pkg_a.Get_Item_Value('EXPECTED_AVERAGE_PRICE',
                                                  Rowlist_),
                             ATTR_);
      IFSAPP.SALES_PART_API.NEW__(info_,
                                  objid_,
                                  objversion_,
                                  ATTR_,
                                  action_);
    
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      pkg_a.Setsuccess(A311_Key_, 'BL_V_SALES_PART', Objid_);
    
    END IF;
    --修改
    IF Doaction_ = 'M' THEN
      Open Cur_ For
        Select t.* From BL_V_SALES_PART t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        close cur_;
        Raise_Application_Error(Pkg_a.Raise_Error, '错误的rowid！');
        RETURN;
      End If;
      Close Cur_;
      Action_ := 'DO';
      /*      CLIENT_SYS.ADD_TO_ATTR('CATALOG_DESC',
                             Pkg_a.Get_Item_Value('CATALOG_DESC', Rowlist_),
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
      CLIENT_SYS.ADD_TO_ATTR('LIST_PRICE',
                             Pkg_a.Get_Item_Value('LIST_PRICE', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('MINIMUM_QTY',
                             Pkg_a.Get_Item_Value('MINIMUM_QTY', Rowlist_),
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
      CLIENT_SYS.ADD_TO_ATTR('ACTIVEIND_DB',
                             Pkg_a.Get_Item_Value('ACTIVEIND_DB', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('TAXABLE_DB',
                             Pkg_a.Get_Item_Value('TAXABLE_DB', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('EAN_NO',
                             Pkg_a.Get_Item_Value('EAN_NO', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('BONUS_BASIS_FLAG_DB',
                             Pkg_a.Get_Item_Value('BONUS_BASIS_FLAG_DB',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('BONUS_VALUE_FLAG_DB',
                             Pkg_a.Get_Item_Value('BONUS_VALUE_FLAG_DB',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('REPLACEMENT_PART_NO',
                             Pkg_a.Get_Item_Value('REPLACEMENT_PART_NO',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('PRINT_CONTROL_CODE',
                             Pkg_a.Get_Item_Value('PRINT_CONTROL_CODE',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('ENG_ATTRIBUTE',
                             Pkg_a.Get_Item_Value('ENG_ATTRIBUTE', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('PACKAGE_TYPE',
                             Pkg_a.Get_Item_Value('PACKAGE_TYPE', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('PACKAGE_WEIGHT',
                             Pkg_a.Get_Item_Value('PACKAGE_WEIGHT',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('PROPOSED_PARCEL_QTY',
                             Pkg_a.Get_Item_Value('PROPOSED_PARCEL_QTY',
                                                  Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('WEIGHT_NET',
                             Pkg_a.Get_Item_Value('WEIGHT_NET', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('WEIGHT_GROSS',
                             Pkg_a.Get_Item_Value('WEIGHT_GROSS', Rowlist_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('VOLUME',
                             Pkg_a.Get_Item_Value('VOLUME', Rowlist_),
                             ATTR_);*/
      objversion_ := Row_.OBJVERSION;
    
      Data_ := Rowlist_;
      Pos_  := Instr(Data_, Index_);
      i     := i + 1;
      --           Mysql_     :='update BL_V_SALES_PART set ';
      --           Ifmychange :='0';
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
    
      IFSAPP.SALES_PART_API.MODIFY__(info_,
                                     objid_,
                                     objversion_,
                                     ATTR_,
                                     action_);
      --用户自定义列
      /*   If Ifmychange = '1' Then
        Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User =''' ||
                  User_Id_ || '''; 
         Mysql_ := Mysql_ || ' Where
                  Rowid = '''|| Row_.Objid ||''';
        -- raise_application_error(Pkg_a.Raise_Error, mysql_);
        Execute Immediate Mysql_;
      End If;*/
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_SALES_PART', Row_.Objid);
    End If;
    --删除
    If Doaction_ = 'D' Then
      /*OPEN CUR_ FOR
              SELECT T.* FROM BL_V_SALES_PART T WHERE T.ROWID = OBJID_;
            FETCH CUR_
              INTO ROW_;
            IF CUR_ %NOTFOUND THEN
              CLOSE CUR_;
              RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
              return;
            end if;
            close cur_;
      --      DELETE FROM BL_V_SALES_PART T WHERE T.ROWID = OBJID_; */
      --pkg_a.Setsuccess(A311_Key_,'BL_V_SALES_PART', Objid_);
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
    Attr_Out      Varchar2(4000);
    ROW_          BL_V_SALES_PART%ROWTYPE; --主档
    CONTRACT_     USER_ALLOWED_SITE_LOV%ROWTYPE; --域
    PRICE_GROUP_  SALES_PRICE_GROUP%ROWTYPE; --销售价格分组
    SALES_GROUP_  SALES_GROUP%ROWTYPE; --销售分组 
    DIS_GROUP_    SALES_DISCOUNT_GROUP%ROWTYPE; --折扣分组
    FEE_CODE_     STATUTORY_FEE_DEDUCT_MULTIPLE%ROWTYPE; --增值税
    PACKAGE_TYPE_ PACKAGE_TYPE%ROWTYPE;
    CUR_          T_CURSOR;
  
  Begin
  
    If Column_Id_ = 'CONTRACT' Then
      ROW_.CONTRACT               := PKG_A.Get_Item_Value('CONTRACT',
                                                          ROWLIST_);
      ROW_.COMPANY                := IFSAPP.SITE_API.GET_COMPANY(ROW_.CONTRACT);
      ROW_.CURRENCY_CODE          := IFSAPP.COMPANY_FINANCE_API.GET_CURRENCY_CODE(ROW_.COMPANY);
      ROW_.CURRENCY_CODE_T        := IFSAPP.COMPANY_FINANCE_API.GET_CURRENCY_CODE(ROW_.COMPANY);
      ROW_.CURRENCY_CODE_EXPECTED := IFSAPP.COMPANY_FINANCE_API.GET_CURRENCY_CODE(ROW_.COMPANY);
    
      Pkg_a.Set_Item_Value('COMPANY', ROW_.COMPANY, Attr_Out);
      Pkg_a.Set_Item_Value('CURRENCY_CODE', ROW_.CURRENCY_CODE, Attr_Out);
      Pkg_a.Set_Item_Value('CURRENCY_CODE_T',
                           ROW_.CURRENCY_CODE_T,
                           Attr_Out);
      /*      Pkg_a.Set_Item_Value('CURRENCY_CODE_EXPECTED',
      ROW_.CURRENCY_CODE_EXPECTED,
      Attr_Out);*/
      --   USER_ALLOWED_SITE_LOV
      --给列赋值
      Pkg_a.Set_Item_Value('【COLUMN】', '【value】', Attr_Out);
      --设置列不可用
      Pkg_a.Set_Column_Enable('【column】', '0', Attr_Out);
      --设置列可用
      Pkg_a.Set_Column_Enable('【column】', '1', Attr_Out);
    End If;
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
      pkg_a.Set_Item_Value('PRICE_GROUP_DESC',
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
    if COLUMN_ID_ = 'PACKAGE_TYPE' THEN
      ROW_.PACKAGE_TYPE := PKG_A.Get_Item_Value('PACKAGE_TYPE', ROWLIST_);
      open CUR_ FOR
        SELECT T.*
          FROM PACKAGE_TYPE T
         WHERE T.PACKAGE_TYPE = ROW_.PACKAGE_TYPE;
      FETCH CUR_
        INTO PACKAGE_TYPE_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '错误的包装类型代码');
        RETURN;
      END IF;
      CLOSE CUR_;
      PKG_A.Set_Item_Value('PACKAGE_TYPE_DESC',
                           PACKAGE_TYPE_.description,
                           Attr_Out);
    END IF;
    IF COLUMN_ID_ = 'SALES_UNIT_MEAS' THEN
      ROW_.SALES_UNIT_MEAS := PKG_A.Get_Item_Value('SALES_UNIT_MEAS',
                                                   ROWLIST_);
      ROW_.PRICE_UNIT_MEAS := PKG_A.Get_Item_Value('PRICE_UNIT_MEAS',
                                                   ROWLIST_);
      IF NVL(ROW_.PRICE_UNIT_MEAS, 'NULL') = 'NULL' THEN
        PKG_A.Set_Item_Value('PRICE_UNIT_MEAS',
                             ROW_.SALES_UNIT_MEAS,
                             Attr_Out);
      END IF;
    
    END IF;
  
    --ISO_UNIT
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
    ROW_ BL_V_SALES_PART%ROWTYPE;
  Begin
    ROW_.OBJID := PKG_A.Get_Item_Value('OBJID', ROWLIST_);
    IF NVL(ROW_.OBJID, 'NULL') = 'NULL' THEN
      return '1';
    ELSE
      If Column_Id_ = 'CONTRACT' OR Column_Id_ = 'CATALOG_NO' Then
        Return '0';
      ELSE
        RETURN '1';
      End If;
    END IF;
  End;

End BL_SALES_PART_API;
/
