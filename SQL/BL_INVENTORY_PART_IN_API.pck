CREATE OR REPLACE PACKAGE BL_INVENTORY_PART_IN_API IS
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

END BL_INVENTORY_PART_IN_API;
/
CREATE OR REPLACE PACKAGE BODY BL_INVENTORY_PART_IN_API IS
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
    Attr_       VARCHAR2(4000);
    Info_       VARCHAR2(4000);
    Objid_      VARCHAR2(4000);
    Objversion_ VARCHAR2(4000);
    Action_     VARCHAR2(100);
    Attr_Out    VARCHAR2(4000);
  
    mainrow_    INVENTORY_PART_IN_STOCK%ROWTYPE;
    Row_        BL_V_INVENTORY_PART_IN_DELIV%ROWTYPE;
    Requesturl_ VARCHAR2(4000);
    Option_     VARCHAR2(200);
    datalist_   dbms_sql.Varchar2_Table;
    cur_        t_cursor;
  BEGIN
    Action_       := 'PREPARE';
    row_.LINK_KEY := pkg_a.Get_Item_Value('LINK_KEY', Rowlist_);
    datalist_     := pkg_a.Get_Str_List_By_Index(row_.LINK_KEY, '_');
    open cur_ for
      select t.*
        from INVENTORY_PART_IN_STOCK t
       where t.WAIV_DEV_REJ_NO = datalist_(1)
         and t.PART_NO = datalist_(2)
         and t.CONFIGURATION_ID = datalist_(3)
         and t.LOT_BATCH_NO = datalist_(4)
         and t.SERIAL_NO = datalist_(5)
         and t.ENG_CHG_LEVEL = datalist_(6)
         and t.location_no = datalist_(7)
         and t.contract = datalist_(8);
    fetch cur_
      into mainrow_;
    if cur_%notfound then
      return;
    end if;
    close cur_;
    client_sys.Set_Item_Value('WAIV_DEV_REJ_NO',
                              mainrow_.WAIV_DEV_REJ_NO,
                              Attr_);
    client_sys.Set_Item_Value('PART_NO', mainrow_.PART_NO, Attr_);
    client_sys.Set_Item_Value('CONFIGURATION_ID',
                              mainrow_.CONFIGURATION_ID,
                              Attr_);
    client_sys.Set_Item_Value('LOT_BATCH_NO', mainrow_.LOT_BATCH_NO, Attr_);
    client_sys.Set_Item_Value('SERIAL_NO', mainrow_.SERIAL_NO, Attr_);
    client_sys.Set_Item_Value('ENG_CHG_LEVEL',
                              mainrow_.eng_chg_level,
                              Attr_);
    client_sys.Set_Item_Value('LOCATION_NO', mainrow_.location_no, Attr_);
    client_sys.Set_Item_Value('CONTRACT', mainrow_.contract, Attr_);
  
    INVENTORY_PART_IN_STOCK_API.New__(Info_,
                                      Objid_,
                                      Objversion_,
                                      Attr_,
                                      Action_);
  
    Attr_Out := Pkg_a.Get_Attr_By_Ifs(Attr_);
    pkg_a.Set_Item_Value('CONTRACT', mainrow_.contract, Attr_Out);
    pkg_a.Setresult(A311_Key_, Attr_);
  END;

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE Modify__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2) IS
    Attr_           VARCHAR2(4000);
    Index_          VARCHAR2(1);
    Cur_            t_Cursor;
    Action_         VARCHAR2(100);
    Doaction_       VARCHAR2(10);
    row_            BL_V_INVENTORY_PART_IN_STOCK%ROWTYPE;
    row0_           BL_V_INVENTORY_PART_IN_DELIV%ROWTYPE;
    pallet_id_list_ VARCHAR2(4000);
    datalist_       dbms_sql.Varchar2_Table;
  BEGIN
    Doaction_   := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    ROW0_.OBJID := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    IF Doaction_ = 'I' THEN
      pallet_id_list_ := '';
      row_.LINK_KEY   := Pkg_a.Get_Item_Value('LINK_KEY', Rowlist_);
      datalist_       := pkg_a.Get_Str_List_By_Index(row_.LINK_KEY, '_');
    
      open cur_ for
        select t.*
          from BL_V_INVENTORY_PART_IN_STOCK t
         where t.WAIV_DEV_REJ_NO = datalist_(1)
           and t.PART_NO = datalist_(2)
           and t.CONFIGURATION_ID = datalist_(3)
           and t.LOT_BATCH_NO = datalist_(4)
           and t.SERIAL_NO = datalist_(5)
           and t.ENG_CHG_LEVEL = datalist_(6)
           and t.location_no = datalist_(7)
           and t.contract = datalist_(8);
      fetch cur_
        into row_;
      if cur_%notfound then
        close cur_;
        Raise_Application_Error(pkg_a.raise_error, '库存不存在');
      end if;
      close cur_;
      ROW0_.CONTRACT          := ROW_.contract;
      ROW0_.LOCATION_NO       := PKG_A.GET_ITEM_VALUE('LOCATION_NO',
                                                      ROWLIST_);
      ROW0_.DESTINATION       := PKG_A.GET_ITEM_VALUE('DESTINATION',
                                                      ROWLIST_);
      ROW0_.QTY_MOVED         := PKG_A.GET_ITEM_VALUE('QTY_MOVED', ROWLIST_);
      ROW0_.QUANTITY_RESERVED := row_.QTY_RESERVED;
      /* Raise_Application_Error(pkg_a.raise_error, ROW0_.QTY_MOVED);*/
    
      --调用ifs的新增过程
      Inventory_Part_In_Stock_API.Move_Part(pallet_id_list_,
                                            row_.contract,
                                            row_.part_no,
                                            row_.configuration_id,
                                            row_.location_no,
                                            row_.lot_batch_no,
                                            row_.serial_no,
                                            row_.eng_chg_level,
                                            row_.waiv_dev_rej_no,
                                            row_.expiration_date,
                                            row0_.contract,
                                            row0_.location_no,
                                            row0_.destination,
                                            row0_.QTY_MOVED,
                                            row0_.quantity_reserved,
                                            null);
      --成功以后设置objid的值          
      pkg_a.Setsuccess(A311_Key_,
                       'BL_V_INVENTORY_PART_IN_DELIV',
                       pallet_id_list_);
    
      RETURN;
    END IF;
    --修改
    IF Doaction_ = 'M' THEN
      pallet_id_list_ := '';
      OPEN CUR_ FOR
        SELECT V.*
          FROM BL_V_INVENTORY_PART_IN_DELIV V
         WHERE V.objid = row0_.objid;
      FETCH Cur_
        INTO row0_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        Raise_Application_Error(-20101, '错误的rowid');
        RETURN;
      END IF;
      CLOSE CUR_;
      datalist_ := pkg_a.Get_Str_List_By_Index(row0_.LINK_KEY, '_');
      open cur_ for
        select t.*
          from BL_V_INVENTORY_PART_IN_STOCK t
         where t.WAIV_DEV_REJ_NO = datalist_(1)
           and t.PART_NO = datalist_(2)
           and t.CONFIGURATION_ID = datalist_(3)
           and t.LOT_BATCH_NO = datalist_(4)
           and t.SERIAL_NO = datalist_(5)
           and t.ENG_CHG_LEVEL = datalist_(6)
           and t.location_no = datalist_(7)
           and t.contract = datalist_(8);
      fetch cur_
        into row_;
      if cur_%notfound then
        close cur_;
        Raise_Application_Error(pkg_a.raise_error, '主档rowid不存在');
        return;
      end if;
      close cur_;
      row0_.QTY_MOVED := PKG_A.GET_ITEM_VALUE('QTY_MOVED', ROWLIST_);
      Inventory_Part_In_Stock_API.Move_Part(pallet_id_list_,
                                            row_.contract,
                                            row_.part_no,
                                            row_.configuration_id,
                                            row_.location_no,
                                            row_.lot_batch_no,
                                            row_.serial_no,
                                            row_.eng_chg_level,
                                            row_.waiv_dev_rej_no,
                                            row_.expiration_date,
                                            row0_.contract,
                                            row0_.location_no,
                                            row0_.destination,
                                            row0_.QTY_MOVED,
                                            row0_.quantity_reserved,
                                            null);
      pkg_a.Setsuccess(A311_Key_,
                       'BL_V_INVENTORY_PART_IN_DELIV',
                       pallet_id_list_);
      RETURN;
    END IF;
    --删除
    IF Doaction_ = 'D' THEN
      --pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
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
  PROCEDURE Itemchange__(Column_Id_   VARCHAR2,
                         Mainrowlist_ VARCHAR2,
                         Rowlist_     VARCHAR2,
                         User_Id_     VARCHAR2,
                         Outrowlist_  OUT VARCHAR2) IS
    Attr_Out VARCHAR2(4000);
    row_     BL_V_INVENTORY_PART_IN_DELIV%ROWTYPE;
  BEGIN
    IF Column_Id_ = 'LOCATION_NO' THEN
      row_.contract    := pkg_a.Get_Item_Value('CONTRACT', Mainrowlist_);
      row_.location_no := pkg_a.Get_Item_Value('LOCATION_NO', Rowlist_);
      row_.WAREHOUSE   := INVENTORY_LOCATION_API.Get_Warehouse(row_.contract,
                                                               row_.location_no);
      row_.bay_no      := INVENTORY_LOCATION_API.Get_Bay_No(row_.contract,
                                                            row_.location_no);
      row_.row_no      := INVENTORY_LOCATION_API.Get_Row_No(row_.contract,
                                                            row_.location_no);
      row_.tier_no     := INVENTORY_LOCATION_API.Get_Tier_No(row_.contract,
                                                             row_.location_no);
      row_.bin_no      := INVENTORY_LOCATION_API.Get_Bin_No(row_.contract,
                                                            row_.location_no);
      pkg_a.Set_Item_Value('WAREHOUSE', Row_.WAREHOUSE, Attr_out);
      pkg_a.Set_Item_Value('BAY_NO', Row_.bay_no, Attr_out);
      pkg_a.Set_Item_Value('ROW_NO', Row_.row_no, Attr_out);
      pkg_a.Set_Item_Value('TIER_NO', Row_.tier_no, Attr_out);
      pkg_a.Set_Item_Value('BIN_NO', Row_.bin_no, Attr_out);
      --给列赋值
      --Pkg_a.Set_Item_Value('LOCATION_NAME', row_.LOCATION_NAME, Attr_Out);
      --设置列不可用
      Pkg_a.Set_Column_Enable('【COLUMN】', '0', Attr_Out);
      --设置列可用
      Pkg_a.Set_Column_Enable('【COLUMN】', '1', Attr_Out);
    END IF;
    Outrowlist_ := Attr_Out;
  END;
  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  FUNCTION Checkbutton__(Dotype_  IN VARCHAR2,
                         KEY_     IN VARCHAR2,
                         User_Id_ IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF Dotype_ = 'ADD_ROW' THEN
      RETURN '1';
    END IF;
    IF Dotype_ = 'DEL_ROW' THEN
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
  FUNCTION Checkuseable(Doaction_  IN VARCHAR2,
                        Column_Id_ IN VARCHAR,
                        Rowlist_   IN VARCHAR2) RETURN VARCHAR2 IS
    row_ BL_V_INVENTORY_PART_IN_DELIV%ROWTYPE;
  BEGIN
    row_.objid := pkg_a.Get_Item_Value('OBJID', Rowlist_);
    IF NVL(ROW_.objid, 'NULL') = 'NULL' THEN
      RETURN '1';
    END IF;
    IF Column_Id_ = 'QTY_MOVED' OR Column_Id_ = 'DESTINATION' THEN
      RETURN '1';
    ELSE
      RETURN '0';
    END IF;
    RETURN '1';
  END;

END BL_INVENTORY_PART_IN_API;
/
