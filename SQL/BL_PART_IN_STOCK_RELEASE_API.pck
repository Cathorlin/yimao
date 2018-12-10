CREATE OR REPLACE PACKAGE BL_PART_IN_STOCK_RELEASE_API IS
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
  PROCEDURE MATERIAL_COMMIT__(ROWLIST_ VARCHAR2,
                              --视图的objid
                              USER_ID_ VARCHAR2,
                              --用户id
                              A311_KEY_ VARCHAR2);
END BL_PART_IN_STOCK_RELEASE_API;
/
CREATE OR REPLACE PACKAGE BODY BL_PART_IN_STOCK_RELEASE_API IS
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
    row_      BL_V_PART_IN_STOCK_RELEASE%rowtype;
  BEGIN
  
    Index_     := f_Get_Data_Index();
    row_.objid := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_  := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ = 'I' THEN
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
      RETURN;
    END IF;
    --修改
    IF Doaction_ = 'M' THEN
      /*      open cur_ for
              select t.*
                from BL_V_PART_IN_STOCK_RELEASE t
               where t.OBJID = row_.OBJID;
            fetch cur_
              into row_;
            if cur_%notfound then
              close cur_;
              raise_application_error(-20101, '错误的rowid');
              return;
            end if;
            close cur_;
          
            row_.QTY_COMMIT := pkg_a.Get_Item_Value('QTY_COMMIT', Rowlist_);
            if to_number(row_.QTY_COMMIT) > to_number(row_.QTY_ASSIGNED) then
              raise_application_error(-20101, '下发数量不能大于待下发数量');
            end if;
            if to_number(row_.QTY_COMMIT) <= 0 then
              raise_application_error(-20101, '请输入正确的下发数量');
            end if;
            row_.QTY_COMMIT := pkg_a.Get_Item_Value('QTY_COMMIT', Rowlist_);
            Material_Requis_Reservat_API.Make_Item_Delivery(row_.ORDER_CLASS,
                                                            row_.ORDER_NO,
                                                            row_.LINE_NO,
                                                            row_.RELEASE_NO,
                                                            row_.LINE_ITEM_NO,
                                                            row_.PART_NO,
                                                            row_.CONTRACT,
                                                            row_.LOCATION_NO,
                                                            row_.LOT_BATCH_NO,
                                                            row_.SERIAL_NO,
                                                            row_.WAIV_DEV_REJ_NO,
                                                            row_.ENG_CHG_LEVEL,
                                                            row_.QTY_COMMIT);
            pkg_a.Setsuccess(A311_Key_, 'BL_V_PART_IN_STOCK_RELEASE', row_.OBJID);
      */
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
  BEGIN
    IF Column_Id_ = '【COLUMN】' THEN
      RETURN '0';
    END IF;
    RETURN '1';
  END;

  PROCEDURE MATERIAL_COMMIT__(ROWLIST_ VARCHAR2,
                              --视图的objid
                              USER_ID_ VARCHAR2,
                              --用户id
                              A311_KEY_ VARCHAR2) is
    mainrow_ BL_V_MATERIAL_REQUIS_RESERVAT%rowtype;
    row_     BL_V_PART_IN_STOCK_NOPAL%rowtype;
    cur_     t_cursor;
    ROWID_   VARCHAR2(1000);
  begin
    ROWID_ := ROWLIST_;
    open cur_ for
      select t.*
        from BL_V_MATERIAL_REQUIS_RESERVAT t
       where t.OBJID = ROWID_;
    fetch cur_
      into mainrow_;
    if cur_%notfound then
      close cur_;
      raise_application_error(-20101, '错误的rowid');
      return;
    end if;
    close cur_;
  
    open cur_ for
      select *
        from BL_V_PART_IN_STOCK_NOPAL t1
       where t1.link_key = mainrow_.link_key
         and t1.Qty_Assigned > 0;
    fetch cur_
      into row_;
    if cur_%notfound then
      close cur_;
      raise_application_error(-20101, '错误的rowid');
    end if;
    while cur_%found loop
      Material_Requis_Reservat_API.Make_Item_Delivery(row_.ORDER_CLASS,
                                                      row_.ORDER_NO,
                                                      row_.LINE_NO,
                                                      row_.RELEASE_NO,
                                                      row_.LINE_ITEM_NO,
                                                      row_.PART_NO,
                                                      row_.CONTRACT,
                                                      row_.LOCATION_NO,
                                                      row_.LOT_BATCH_NO,
                                                      row_.SERIAL_NO,
                                                      row_.WAIV_DEV_REJ_NO,
                                                      row_.ENG_CHG_LEVEL,
                                                      row_.Qty_Assigned);
      fetch cur_
        into row_;
    end loop;
    close cur_;
    pkg_a.Setsuccess(A311_Key_, 'BL_V_PART_IN_STOCK_RELEASE', row_.OBJID);
  end;

END BL_PART_IN_STOCK_RELEASE_API;
/
