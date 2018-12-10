CREATE OR REPLACE PACKAGE BL_PART_IN_STOCK_NOPAL_API IS
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

END BL_PART_IN_STOCK_NOPAL_API;
/
CREATE OR REPLACE PACKAGE BODY BL_PART_IN_STOCK_NOPAL_API IS
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
    attr_out VARCHAR2(4000);
  BEGIN
    attr_out := '';
  
    -- pkg_a.Set_Item_Value('【COLUMN】', '【VALUE】', attr_out);
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
    Objid_    VARCHAR2(50);
    Index_    VARCHAR2(1);
    Cur_      t_Cursor;
    Doaction_ VARCHAR2(10);
    main_row_ BL_V_MATERIAL_REQUIS_RESERVAT%rowtype;
    row_      BL_V_PART_IN_STOCK_NOPAL%rowtype;
  BEGIN
  
    Index_     := f_Get_Data_Index();
    row_.OBJID := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_  := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ = 'I' THEN
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
      RETURN;
    END IF;
    --修改
    IF Doaction_ = 'M' THEN
      open cur_ for
        select t.*
          from BL_V_PART_IN_STOCK_NOPAL t
         where t.OBJID = row_.OBJID;
      fetch cur_
        into row_;
      if cur_%notfound then
        close cur_;
        raise_application_error(-20101, '错误的rowid');
        return;
      end if;
      close cur_;
    
      open cur_ for
        select t.*
          from BL_V_MATERIAL_REQUIS_RESERVAT t
         where t.ORDER_NO = row_.ORDER_NO
           and t.LINE_NO = row_.LINE_NO
           and t.PART_NO = row_.PART_NO
           and t.LINE_ITEM_NO = row_.LINE_ITEM_NO
           and t.RELEASE_NO = row_.RELEASE_NO
           and t.ORDER_CLASS = row_.ORDER_CLASS;
      fetch cur_
        into main_row_;
      if cur_%notfound then
        close cur_;
        raise_application_error(-20101, '未找到数据');
        return;
      end if;
      close cur_;
      row_.QTY_MOVED := pkg_a.Get_Item_Value('QTY_MOVED', Rowlist_);
      if row_.QTY_MOVED > main_row_.QTY_UNASSIGNED then
        raise_application_error(-20101, '分配数量不能大于剩余未分配数量');
        return;
      end if;
      if row_.QTY_MOVED < 0 or nvl(row_.QTY_MOVED, 0) = 0 then
        raise_application_error(-20101, '请输入正确的分配数量');
        return;
      end if;
      Material_Requis_Reservat_API.Make_Part_Reservations(row_.ORDER_CLASS,
                                                          row_.ORDER_NO,
                                                          row_.LINE_NO,
                                                          row_.RELEASE_NO,
                                                          row_.LINE_ITEM_NO,
                                                          row_.PART_NO,
                                                          row_.Contract,
                                                          row_.LOCATION_NO,
                                                          row_.LOT_BATCH_NO,
                                                          row_.SERIAL_NO,
                                                          row_.WAIV_DEV_REJ_NO,
                                                          row_.ENG_CHG_LEVEL,
                                                          row_.QTY_MOVED);
      pkg_a.Setsuccess(A311_Key_, 'BL_V_PART_IN_STOCK_NOPAL', row_.OBJID);
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
  BEGIN
    IF Column_Id_ = '' THEN
      --给列赋值
      Pkg_a.Set_Item_Value('【COLUMN】', '【VALUE】', Attr_Out);
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
      RETURN '0';
    
    END IF;
    IF Dotype_ = 'DEL_ROW' THEN
      RETURN '0';
    
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
  BEGIN
    IF Column_Id_ = '【COLUMN】' THEN
      RETURN '0';
    END IF;
    RETURN '1';
  END;

END BL_PART_IN_STOCK_NOPAL_API;
/
