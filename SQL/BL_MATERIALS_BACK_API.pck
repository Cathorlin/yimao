CREATE OR REPLACE PACKAGE BL_MATERIALS_BACK_API IS
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

  procedure TUILIAO_COMMIT__(Rowlist_ VARCHAR2,
                             --视图的objid
                             User_Id_ VARCHAR2,
                             --用户id
                             A311_Key_ VARCHAR2);
END BL_MATERIALS_BACK_API;
/
CREATE OR REPLACE PACKAGE BODY BL_MATERIALS_BACK_API IS
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
    row_      BL_V_TRANSACTION_HISTSHENGQING%rowtype;
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
    IF Column_Id_ = 'NOTE_TEXT' THEN
      RETURN '1';
    END IF;
    RETURN '0';
  END;

  procedure TUILIAO_COMMIT__(Rowlist_ VARCHAR2,
                             --视图的objid
                             User_Id_ VARCHAR2,
                             --用户id
                             A311_Key_ VARCHAR2) IS
    cur_              t_Cursor;
    mainrow_          BL_V_BACK_REQUIS_LINE_2%rowtype;
    row_              BL_V_TRANSACTION_HISTSHENGQING%rowtype;
    BL_ROW_           BL_RETURN_TRANSACTION%rowtype;
    Rowid_            VARCHAR2(1000);
    QTY_UNISSUED_all_ number;
    QTY_UNISSUED_     number;
  BEGIN
    Rowid_ := Rowlist_;
    open cur_ for
      select * from BL_V_BACK_REQUIS_LINE_2 where OBJID = Rowid_;
    fetch cur_
      into mainrow_;
    if cur_%notfound then
      close cur_;
      raise_application_error(-20101, '错误的rowid');
      return;
    end if;
    close cur_;
  
    open cur_ for
      select t.*
        from BL_V_TRANSACTION_HISTSHENGQING t
       where t.LINK_KEY = mainrow_.LINK_KEY
         and t.QTY_UNISSUED > 0;
    fetch cur_
      into row_;
    if cur_%notfound then
      close cur_;
      raise_application_error(-20101, '请输入大于0的入库数量');
      return;
    end if;
    select nvl(sum(t2.QTY_UNISSUED), 0)
      into QTY_UNISSUED_all_
      from bl_v_transaction_histshengqing t2
     where t2.link_key = row_.LINK_KEY;
    /*QTY_UNISSUED_all_ := QTY_UNISSUED_all_ - row_.QTY_UNISSUED;
    QTY_UNISSUED_all_ := QTY_UNISSUED_all_ + QTY_UNISSUED_;*/
    if QTY_UNISSUED_all_ <> row_.QTY_UNISSUE then
      raise_application_error(-20101, '入库总数量必须等于申请数量');
      return;
    end if;
  
    while cur_%found loop
      Material_Requis_Line_API.Unissue(row_.qty_reversed,
                                       row_.ACCOUNTING_ID,
                                       row_.CONTRACT,
                                       row_.PART_NO,
                                       row_.QTY_UNISSUED,
                                       row_.LOCATION_NO,
                                       row_.LOT_BATCH_NO,
                                       row_.SERIAL_NO,
                                       row_.eng_chg_level,
                                       row_.WAIV_DEV_REJ_NO,
                                       row_.TRANSACTION_ID,
                                       row_.SOURCE,
                                       row_.ORDER_NO,
                                       row_.RELEASE_NO,
                                       row_.SEQUENCE_NO,
                                       row_.LINE_ITEM_NO,
                                       row_.COST,
                                       row_.quantity);
    
      --记录事物号
      select max(t4.transaction_id)
        into row_.Transaction_Id
        from Inventory_Transaction_Hist2 t4
       where t4.part_no = row_.PART_NO
         and t4.contract = row_.CONTRACT
         and t4.location_no = row_.LOCATION_NO
         and t4.serial_no = row_.SERIAL_NO
         and t4.lot_batch_no = row_.LOT_BATCH_NO
         and t4.waiv_dev_rej_no = row_.WAIV_DEV_REJ_NO
         and t4.eng_chg_level = row_.eng_chg_level
         and t4.order_no = row_.ORDER_NO
         and t4.transaction_code in ('INTSHIP', 'INTUNISS');
    
      BL_ROW_.Part_No        := row_.PART_NO;
      BL_ROW_.CONTRACT       := row_.CONTRACT;
      BL_ROW_.ORDER_NO       := row_.ORDER_NO;
      BL_ROW_.LOCATION_NO    := row_.LOCATION_NO;
      BL_ROW_.Lot_Batch_No   := row_.LOT_BATCH_NO;
      BL_ROW_.RELEASE_NO     := row_.RELEASE_NO;
      BL_ROW_.QTY_UNISSUED   := row_.QTY_UNISSUED;
      BL_ROW_.ORDER_CLASS    := row_.SOURCE;
      BL_ROW_.STATUS         := row_.status;
      BL_ROW_.LINE_NO        := row_.order_line_no;
      BL_ROW_.DATE_ENTERED   := sysdate;
      BL_ROW_.RMATERIAL_NO   := row_.RMATERIAL_NO;
      BL_ROW_.LINE_ITEM_NO   := row_.LINE_ITEM_NO;
      BL_ROW_.Transaction_Id := row_.TRANSACTION_ID;
      BL_ROW_.Enter_User     := User_Id_;
    
      insert into BL_RETURN_TRANSACTION
        (PART_NO,
         CONTRACT,
         ORDER_NO,
         LOCATION_NO,
         LOT_BATCH_NO,
         RELEASE_NO,
         QTY_UNISSUED,
         ORDER_CLASS,
         STATUS,
         LINE_NO,
         DATE_ENTERED,
         RMATERIAL_NO,
         LINE_ITEM_NO,
         Enter_User,
         TRANSACTION_ID)
      values
        (BL_ROW_.Part_No,
         BL_ROW_.CONTRACT,
         BL_ROW_.ORDER_NO,
         BL_ROW_.Location_No,
         BL_ROW_.Lot_Batch_No,
         BL_ROW_.RELEASE_NO,
         BL_ROW_.QTY_UNISSUED,
         BL_ROW_.ORDER_CLASS,
         BL_ROW_.STATUS,
         BL_ROW_.LINE_NO,
         BL_ROW_.DATE_ENTERED,
         BL_ROW_.RMATERIAL_NO,
         BL_ROW_.LINE_ITEM_NO,
         BL_ROW_.Enter_User,
         BL_ROW_.Transaction_Id);
    
      --下发后清掉填写的入库数量
      update BL_MATERIALS_RETURN_TAB t5
         set t5.qty_unissued = ''
       where t5.objid_id = row_.OBJID;
    
      --更新状态
      update BL_TRANSACTION_HIST t
         set t.status      = '2',
             t.qty_unissue = row_.qty_unissue - QTY_UNISSUED_all_
       where t.rmaterial_no = row_.RMATERIAL_NO
         and t.line_no = row_.order_line_no;
      update BL_MATERIAL_TUILIAO t1
         set t1.status = '2'
       where t1.rmaterial_no = mainrow_.RMATERIAL_NO;
    
      --如果申请数量扣完了，状态改为关闭
      if mainrow_.QTY_UNISSUE = 0 then
        update BL_TRANSACTION_HIST t2
           set t2.status = '3'
         where t2.rmaterial_no = mainrow_.RMATERIAL_NO;
        update BL_MATERIAL_TUILIAO t3
           set t3.status = '3'
         where t3.rmaterial_no = mainrow_.RMATERIAL_NO;
      end if;
    
      fetch cur_
        into row_;
    end loop;
    close cur_;
  
    pkg_a.Setsuccess(A311_Key_,
                     'BL_V_TRANSACTION_HISTSHENGQING',
                     row_.OBJID);
  END;
END BL_MATERIALS_BACK_API;
/
