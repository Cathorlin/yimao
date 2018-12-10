CREATE OR REPLACE PACKAGE BL_INVENTORY_MOVEREQ_DTL_API IS
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
  --获取移库申请明细行
  function getMoverqLineNo(moved_no_ in VARCHAR2) RETURN NUMBER;
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

  procedure changeState__(Rowlist_ VARCHAR2,
                          --视图的objid
                          User_Id_ VARCHAR2,
                          --用户id
                          A311_Key_ VARCHAR2);

  procedure COMMITED__(Rowlist_ VARCHAR2,
                       --视图的objid
                       User_Id_ VARCHAR2,
                       --用户id
                       A311_Key_ VARCHAR2);

END BL_INVENTORY_MOVEREQ_DTL_API;
/
CREATE OR REPLACE PACKAGE BODY BL_INVENTORY_MOVEREQ_DTL_API IS
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
    Attr_ VARCHAR2(4000);
    row_  BL_V_INVENTORYPART_MOVEREQ%rowtype;
    cur_  t_Cursor;
  BEGIN
    row_.moved_no :=pkg_a.Get_Item_Value('MOVED_NO',Rowlist_);
    open  cur_ for  select  t.*
     from BL_V_INVENTORYPART_MOVEREQ t
     where t.moved_no = row_.moved_no;
     fetch  cur_ into row_;
     if cur_%found  then 
        pkg_a.Set_Item_Value('CONTRACT',row_.contract,Attr_);
        if row_.moved_type ='1'  then 
           Pkg_a.Set_Item_Value('CONTRACT_DEST', Row_.contract, Attr_);
           Pkg_a.Set_Item_Value('LOCATION_NO_DEST', row_.LOCATION_NO, Attr_); 
           pkg_a.Set_Item_Value('WAREHOUSE_DEST',row_.WASH,Attr_);
        end if ;
        if row_.moved_type ='2' then
           Pkg_a.Set_Item_Value('CONTRACT_DEST', Row_.contract, Attr_);
           Pkg_a.Set_Item_Value('LOCATION_NO', row_.LOCATION_NO, Attr_); 
           pkg_a.Set_Item_Value('WAREHOUSE',row_.WASH,Attr_);
        end if; 
        if row_.moved_type ='3' or row_.moved_type ='4'  then 
            Pkg_a.Set_Item_Value('CONTRACT_DEST', row_.customer_no, Attr_);
        end if ;
     end if ;
     close cur_;
     Pkg_a.Setresult(A311_Key_, Attr_);
    return;
  END;

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE Modify__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2) IS
    Objid_     VARCHAR2(1000);
    Index_     VARCHAR2(1);
    Cur_       t_Cursor;
    Doaction_  VARCHAR2(10);
    pos_       number;
    pos1_      number;
    i          number;
    v_         varchar(1000);
    column_id_ varchar(1000);
    data_      varchar(4000);
    mysql_     varchar2(4000);
    ifmychange varchar2(1);
    inv_       INVENTORY_PART_IN_STOCK_LOC%ROWTYPE;
    Row_       BL_V_INVENTORYPART_MOVEREQ%ROWTYPE;
    Row0_      BL_INVENTORYPART_MOVEREQ_DTL%ROWTYPE;
    irow_      BL_v_INVENTORYPART_MOVEREQ_DTL%rowtype;
  BEGIN
  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ = 'I' THEN
      Row0_.moved_no := Pkg_a.Get_Item_Value('MOVED_NO', Rowlist_);
    
      Row0_.qty_moved := Pkg_a.Get_Item_Value('QTY_MOVED', Rowlist_);
      if row0_.qty_moved <= 0 then
        Raise_Application_Error(pkg_a.Raise_Error, '请输入正确的移库数量');
        return;
      end if;
      select max(MOVED_NO_LINE)
        into Row0_.moved_no_line
        from BL_INVENTORYPART_MOVEREQ_DTL t
       where t.moved_no = Row0_.moved_no;
      Row0_.moved_no_line := nvl(Row0_.moved_no_line, 0) + 1;
    
     irow_.inobjid := Pkg_a.Get_Item_Value('INOBJID', Rowlist_);
   /*    open cur_ for
        select t.*
          from INVENTORY_PART_IN_STOCK_LOC t
         where t.objid = irow_.inobjid;
      fetch cur_
        into inv_;
      if cur_%notfound then
        Raise_Application_Error(pkg_a.Raise_Error, '原库存已经不存在了');
      end if;
      close cur_;*/
      irow_.qty_used :=pkg_a.Get_Item_Value('QTY_USED',Rowlist_);
      if row0_.qty_moved > irow_.qty_used then
      
        Raise_Application_Error(pkg_a.Raise_Error,
                                '移库数量不能超过可用数量' ||
                                irow_.qty_used);
      end if;
/*      row0_.contract         := inv_.contract;
      row0_.part_no          := inv_.part_no;
      row0_.location_no      := inv_.location_no;
      row0_.LOT_BATCH_NO     := inv_.lot_batch_no;
      row0_.SERIAL_NO        := inv_.SERIAL_NO;
      row0_.ENG_CHG_LEVEL    := inv_.ENG_CHG_LEVEL;
      row0_.WAIV_DEV_REJ_NO  := inv_.WAIV_DEV_REJ_NO;
      row0_.CONFIGURATION_ID := inv_.CONFIGURATION_ID;*/
      
      row0_.contract         := pkg_a.Get_Item_Value('CONTRACT',Rowlist_);
      row0_.part_no          := pkg_a.Get_Item_Value('PART_NO',Rowlist_);
      row0_.location_no      := pkg_a.Get_Item_Value('LOCATION_NO',Rowlist_);
      row0_.LOT_BATCH_NO     := pkg_a.Get_Item_Value('LOT_BATCH_NO',Rowlist_);
      row0_.SERIAL_NO        := pkg_a.Get_Item_Value('SERIAL_NO',Rowlist_);
      row0_.ENG_CHG_LEVEL    := pkg_a.Get_Item_Value('ENG_CHG_LEVEL',Rowlist_);
      row0_.WAIV_DEV_REJ_NO  := pkg_a.Get_Item_Value('WAIV_DEV_REJ_NO',Rowlist_);
      row0_.CONFIGURATION_ID := pkg_a.Get_Item_Value('CONFIGURATION_ID',Rowlist_);
      row0_.NEW_DATA         := '';
      pkg_a.Set_Item_Value('INOBJID', irow_.inobjid, row0_.NEW_DATA);
    
      Row0_.contract_dest    := Pkg_a.Get_Item_Value('CONTRACT_DEST',
                                                     Rowlist_);
      Row0_.location_no_dest := Pkg_a.Get_Item_Value('LOCATION_NO_DEST',
                                                     Rowlist_);
    
      Row0_.remark      := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      Row0_.state       := '0';
      row0_.qty_comfirm := 0;
      insert into BL_INVENTORYPART_MOVEREQ_DTL
        (moved_no, moved_no_line, enter_date, enter_user)
      values
        (row0_.moved_no, row0_.moved_no_line, sysdate, user_id_)
      returning rowid into Objid_;
    
      update BL_INVENTORYPART_MOVEREQ_DTL
         set row = row0_
       where rowid = Objid_;
    
      pkg_a.Setsuccess(A311_Key_, 'BL_V_INVENTORYPART_MOVEREQ_DTL', Objid_);
      RETURN;
    END IF;
    --修改
    IF Doaction_ = 'M' THEN
      /*修改*/
      OPEN Cur_ FOR
        SELECT t.*
          FROM BL_v_INVENTORYPART_MOVEREQ_DTL t
         WHERE t.Objid = Objid_;
      FETCH Cur_
        INTO irow_;
      IF Cur_%NOTFOUND THEN
        Raise_Application_Error(-20101, '错误的rowid');
        RETURN;
      END IF;
      CLOSE Cur_;
    
      --取修改的字段
      data_      := Rowlist_;
      pos_       := instr(data_, Index_);
      i          := i + 1;
      mysql_     := ' update BL_INVENTORYPART_MOVEREQ_DTL set ';
      ifmychange := '0';
      loop
        exit when nvl(pos_, 0) <= 0;
        exit when i > 300;
        v_         := substr(data_, 1, pos_ - 1);
        data_      := substr(data_, pos_ + 1);
        pos_       := instr(data_, index_);
        pos1_      := instr(v_, '|');
        column_id_ := substr(v_, 1, pos1_ - 1);
        if column_id_ <> 'OBJID' and column_id_ <> 'DOACTION' and
           column_id_ <> 'DEST_LINE_KEY' and
           length(nvl(column_id_, '')) > 0 then
          v_ := substr(v_, pos1_ + 1);
          i  := i + 1;
          if column_id_ = 'QTY_MOVED' then
            if to_number(v_) <= 0 then
              Raise_Application_Error(pkg_a.Raise_Error,
                                      '请输入正确的移库数量');
              return;
            end if;
            if to_number(v_) > irow_.qty_used then --irow_.qty_onhand - irow_.qty_reserved then
            
              Raise_Application_Error(pkg_a.Raise_Error,
                                      '移库数量不能超过可用数量' || irow_.qty_used);
            end if;
          end if;
        
          ifmychange := '1';
          mysql_     := mysql_ || ' ' || column_id_ || '=''' || v_ || ''',';
        end if;
      end loop;
      if ifmychange = '1' then
        -- 更新sql语句 
        mysql_ := substr(mysql_, 1, length(mysql_) - 1);
        mysql_ := mysql_ || ' where rowidtochar(rowid)=''' || objid_ || '''';
      
        execute immediate mysql_;
      end if;
      pkg_a.Setsuccess(A311_Key_, 'BL_V_INVENTORYPART_MOVEREQ_DTL', Objid_);
      RETURN;
    END IF;
    --删除
    IF Doaction_ = 'D' THEN
      open cur_ for
        select t.*
          from BL_V_INVENTORYPART_MOVEREQ_DTL t
         where t.objid = Objid_;
      fetch cur_
        into irow_;
      if cur_%notfound then
        close cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        return;
      end if;
      close cur_;
      if ROW_.STATE <> 0 then
        raise_application_error(-20101,
                                '移库申请单' || row0_.moved_no || '已经提交，不可删除明细');
        return;
      end if;
      delete from BL_INVENTORYPART_MOVEREQ_DTL t
       where t.moved_no = irow_.moved_no
         and t.MOVED_NO_LINE= irow_.MOVED_NO_LINE ;
      pkg_a.Setsuccess(A311_Key_, 'BL_V_INVENTORYPART_MOVEREQ_DTL', Objid_);
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
    Row0_    BL_V_INVENTORYPART_MOVEREQ_DTL%ROWTYPE;
    Row_     INVENTORY_PART_IN_STOCK_LOC%ROWTYPE;
    Row1_    BL_V_INVENTORYPART_MOVEREQ%ROWTYPE;
   -- Row2_    bl_inventorypart_moveright%rowtype;
   ROW2_       A00708%ROWTYPE;
    cur_     t_Cursor;
    move_    BL_V_MOVERRIGHT2%rowtype;
    --BL_CUSTLOCATION_ BL_CUSTLOCATION%rowtype;
    -- moveright_       bl_inventorypart_moveright%rowtype;
  BEGIN
    Row1_.moved_type := Pkg_a.Get_Item_Value('MOVED_TYPE', Mainrowlist_);
    Row0_.contract   := Pkg_a.Get_Item_Value('CONTRACT', Mainrowlist_);
  
    if Column_Id_ = 'INOBJID' then
      Row0_.inobjid := Pkg_a.Get_Item_Value('INOBJID', Rowlist_);
      open cur_ for
        select t.*
          from INVENTORY_PART_IN_STOCK_LOC t
         where t.objid = Row0_.inobjid;
      fetch cur_
        into Row_;
      if cur_%notfound then
        close cur_;
        raise_application_error(-20101, '错误的rowid');
        return;
      end if;
      close cur_;
    
      Row0_.part_des := INVENTORY_PART_API.Get_Description(Row_.contract,
                                                           Row_.part_no);
      Pkg_a.Set_Item_Value('PART_DES', Row0_.part_des, Attr_Out);
      Pkg_a.Set_Item_Value('WAREHOUSE', Row_.warehouse, Attr_Out);
      Pkg_a.Set_Item_Value('PART_NO', Row_.part_no, Attr_Out);
    
      Pkg_a.Set_Item_Value('QTY_ONHAND', Row_.qty_onhand, Attr_Out);
      Pkg_a.Set_Item_Value('QTY_RESERVED', Row_.qty_reserved, Attr_Out);
      Pkg_a.Set_Item_Value('QTY_USED',
                           Row_.qty_onhand - Row_.qty_reserved,
                           Attr_Out);
      Pkg_a.Set_Item_Value('QTY_MOVED',
                           Row_.qty_onhand - Row_.qty_reserved,
                           Attr_Out);
      Pkg_a.Set_Item_Value('LOCATION_NO', Row_.location_no, Attr_Out);
      Pkg_a.Set_Item_Value('WAREHOUSE', Row_.warehouse, Attr_Out);
      Pkg_a.Set_Item_Value('CONFIGURATION_ID',
                           Row_.configuration_id,
                           Attr_Out);
      Pkg_a.Set_Item_Value('LOCATION_NO', Row_.location_no, Attr_Out);
      Pkg_a.Set_Item_Value('LOT_BATCH_NO', Row_.lot_batch_no, Attr_Out);
      Pkg_a.Set_Item_Value('SERIAL_NO', Row_.serial_no, Attr_Out);
      Pkg_a.Set_Item_Value('ENG_CHG_LEVEL', Row_.eng_chg_level, Attr_Out);
      Pkg_a.Set_Item_Value('WAIV_DEV_REJ_NO',
                           Row_.waiv_dev_rej_no,
                           Attr_Out);
      Pkg_a.Set_Item_Value('AVAILABILITY_CONTROL_ID',
                           Row_.availability_control_id,
                           Attr_Out);
      Pkg_a.Set_Item_Value('EXPIRATION_DATE',
                           Row_.expiration_date,
                           Attr_Out);
  --    Pkg_a.Set_Item_Value('CONTRACT', Row_.contract, Attr_Out);
/*      if Row1_.moved_type = '1' or Row1_.moved_type = '2' then
        Pkg_a.Set_Item_Value('CONTRACT_DEST', Row_.contract, Attr_Out);
        if Row1_.moved_type = '1'   then
          row1_.LOCATION_NO := pkg_a.Get_Item_Value('LOCATION_NO',mainrowlist_);
          row1_.WASH        := pkg_a.Get_Item_Value('WASH',mainrowlist_);
          Pkg_a.Set_Item_Value('LOCATION_NO_DEST', row1_.LOCATION_NO, Attr_Out); 
          pkg_a.Set_Item_Value('WAREHOUSE_DEST',row1_.WASH,Attr_Out);
        end if ;
      else
        row1_.customer_no  := pkg_a.Get_Item_Value('CUSTOMER_NO',mainrowlist_);
        Pkg_a.Set_Item_Value('CONTRACT_DEST', row1_.customer_no, Attr_Out);
      end if;*/
    
      row0_.availability_control_id_des := PART_AVAILABILITY_CONTROL_API.Get_Description(row_.availability_control_id);
      Pkg_a.Set_Item_Value('AVAILABILITY_CONTROL_ID_DES',
                           row0_.availability_control_id_des,
                           Attr_Out);
    
    end if;
  
/*    IF Column_Id_ = 'DEST_LINE_KEY' THEN
      move_.line_key         := Pkg_a.Get_Item_Value('DEST_LINE_KEY',
                                                     rowlist_);
      move_.CONTRACT_DEST    := pkg_a.Get_Str_(move_.line_key, '-', 1);
      move_.location_no_dest := pkg_a.Get_Str_(move_.line_key, '-', 2);
      \*if Row1_.moved_type = '1' then
        Row1_.customer_no := Pkg_a.Get_Item_Value('CUSTOMER_NO',
                                                  Mainrowlist_);
        Row1_.contract    := Pkg_a.Get_Item_Value('CONTRACT', Mainrowlist_);
        open cur_ for
          select t.location_no, t.contract
            from BL_INVENTORY_PART_IN_STOCK_LOC t
           where t.contract = Row1_.contract
             and t.user_cust = Row1_.customer_no
             and t.location_no = move_.location_no_dest;
        fetch cur_
          into row0_.location_no_dest, row0_.contract_dest;
      
      else*\
      open cur_ for
        select t.location_no_dest, t.contract_dest
          from BL_V_MOVERRIGHT2 t
         where t.contract_dest = move_.CONTRACT_DEST
           and t.location_no_dest = move_.location_no_dest
           and t.USERID = Pkg_Attr.get_bl_userid(User_Id_);
      fetch cur_
        into row0_.location_no_dest, row0_.contract_dest;
      \*end if;*\
      if cur_%notfound then
        close cur_;
        raise_application_error(-20101, '错误的目的库位');
        return;
      else
        close cur_;
      end if;
    
      Pkg_a.Set_Item_Value('CONTRACT_DEST', row0_.contract_dest, Attr_Out);
      Pkg_a.Set_Item_Value('LOCATION_NO_DEST',
                           row0_.location_no_dest,
                           Attr_Out);
      row0_.warehouse_dest := INVENTORY_LOCATION_API.Get_Warehouse(row0_.contract_dest,
                                                                   row0_.location_no_dest);
      Pkg_a.Set_Item_Value('WAREHOUSE_DEST',
                           row0_.warehouse_dest,
                           Attr_Out);
    
    end if;*/
/*    IF Column_Id_ = 'LOCATION_NO' THEN
      open cur_ for
        select t.*
          from INVENTORY_PART_IN_STOCK_LOC t
         where t.contract = Row0_.contract
           and t.location_no = Row0_.location_no
           and (t.qty_onhand - t.qty_reserved) > 0;
      fetch cur_
        into Row_;
      if cur_%notfound then
        close cur_;
        raise_application_error(-20101, '错误的rowid');
        return;
      end if;
      close cur_;
      Row0_.qty_onhand   := INVENTORY_PART_IN_STOCK_API.Get_Qty_Onhand(Row_.contract,
                                                                       Row_.part_no,
                                                                       Row_.configuration_id,
                                                                       Row_.location_no,
                                                                       Row_.lot_batch_no,
                                                                       Row_.serial_no,
                                                                       Row_.eng_chg_level,
                                                                       Row_.waiv_dev_rej_no);
      Row0_.qty_reserved := INVENTORY_PART_IN_STOCK_API.Get_Qty_Reserved(Row_.contract,
                                                                         Row_.part_no,
                                                                         Row_.configuration_id,
                                                                         Row_.location_no,
                                                                         Row_.lot_batch_no,
                                                                         Row_.serial_no,
                                                                         Row_.eng_chg_level,
                                                                         Row_.waiv_dev_rej_no);
      Row0_.qty_used     := Row0_.qty_onhand - Row0_.qty_reserved;
      Row0_.warehouse    := INVENTORY_LOCATION_API.Get_Warehouse(Row0_.contract,
                                                                 Row0_.location_no);
      Row0_.part_des     := INVENTORY_PART_API.Get_Description(Row0_.contract,
                                                               Row_.part_no);
      Pkg_a.Set_Item_Value('PART_DES', Row0_.part_des, Attr_Out);
      Pkg_a.Set_Item_Value('WAREHOUSE', Row0_.warehouse, Attr_Out);
      Pkg_a.Set_Item_Value('PART_NO', Row_.part_no, Attr_Out);
      Pkg_a.Set_Item_Value('PART_DES', Row0_.part_des, Attr_Out);
      Pkg_a.Set_Item_Value('QTY_ONHAND', Row0_.qty_onhand, Attr_Out);
      Pkg_a.Set_Item_Value('QTY_RESERVED', Row0_.qty_reserved, Attr_Out);
      Pkg_a.Set_Item_Value('QTY_USED', Row0_.qty_used, Attr_Out);
      Pkg_a.Set_Item_Value('LOCATION_NO', Row_.location_no, Attr_Out);
      Pkg_a.Set_Item_Value('WAREHOUSE', Row_.warehouse, Attr_Out);
      Pkg_a.Set_Item_Value('CONFIGURATION_ID',
                           Row_.configuration_id,
                           Attr_Out);
      Pkg_a.Set_Item_Value('LOCATION_NO', Row_.location_no, Attr_Out);
      Pkg_a.Set_Item_Value('LOT_BATCH_NO', Row_.lot_batch_no, Attr_Out);
      Pkg_a.Set_Item_Value('SERIAL_NO', Row_.serial_no, Attr_Out);
      Pkg_a.Set_Item_Value('ENG_CHG_LEVEL', Row_.eng_chg_level, Attr_Out);
      Pkg_a.Set_Item_Value('WAIV_DEV_REJ_NO',
                           Row_.waiv_dev_rej_no,
                           Attr_Out);
      Pkg_a.Set_Item_Value('AVAILABILITY_CONTROL_ID',
                           Row0_.availability_control_id,
                           Attr_Out);
      Pkg_a.Set_Item_Value('EXPIRATION_DATE',
                           Row0_.expiration_date,
                           Attr_Out);
      Pkg_a.Set_Item_Value('AVAILABILITY_CONTROL_ID_DES',
                           Row0_.availability_control_id_des,
                           Attr_Out);
    END IF;
    if Row1_.moved_type = '1' then
      IF Column_Id_ = 'LOCATION_NO_DEST' THEN
        open cur_ for
          select t.*
            from INVENTORY_PART_IN_STOCK_LOC t
           where t.contract = Row0_.contract
             and t.location_no = Row0_.location_no
             and (t.qty_onhand - t.qty_reserved) > 0;
        fetch cur_
          into Row_;
        if cur_%notfound then
          close cur_;
          raise_application_error(-20101, '错误的rowid');
          return;
        end if;
        Row0_.contract_dest    := ROW_.contract;
        Row0_.location_no_dest := Pkg_a.Get_Item_Value('LOCATION_NO_DEST',
                                                       Rowlist_);
        Row0_.warehouse_dest   := INVENTORY_LOCATION_API.Get_Warehouse(Row0_.contract_dest,
                                                                       Row0_.location_no_dest);
        Pkg_a.Set_Item_Value('WAREHOUSE_DEST',
                             Row0_.warehouse_dest,
                             Attr_Out);
      end if;
    end if;
    IF Row1_.moved_type = '2' THEN
      IF Column_Id_ = 'CONTRACT_DEST' THEN
        Row0_.contract_dest := Pkg_a.Get_Item_Value('CONTRACT_DEST',
                                                    Rowlist_);
        open cur_ for
          select t.*
          --  from bl_inventorypart_moveright t
          from  A00708 t
           where t.contract_dest = row0_.contract_dest;
        fetch cur_
          into Row2_;
        if cur_%notfound then
          close cur_;
          raise_application_error(-20101, '错误的rowid');
        end if;
        close cur_;
        Row0_.warehouse_dest := INVENTORY_LOCATION_API.Get_Warehouse(Row0_.contract_dest,
                                                                     Row2_.location_no_dest);
        Pkg_a.Set_Item_Value('LOCATION_NO_DEST',
                             Row2_.location_no_dest,
                             Attr_Out);
        Pkg_a.Set_Item_Value('WAREHOUSE_DEST',
                             Row0_.warehouse_dest,
                             Attr_Out);
      END IF;
    END IF;*/
    --选择目的库位
    IF Column_Id_ ='LOCATION_NO_DEST'    THEN 
       row0_.location_no_dest := pkg_a.Get_Item_Value('LOCATION_NO_DEST',Rowlist_);
       Row0_.contract_dest    := pkg_a.Get_Item_Value('CONTRACT_DEST',Rowlist_);
       row0_.warehouse_dest   := INVENTORY_LOCATION_API.Get_Warehouse(Row0_.contract_dest,
                                                                      row0_.location_no_dest);
       pkg_a.Set_Item_Value('WAREHOUSE_DEST',row0_.warehouse_dest,Attr_Out);
    END IF;
    Outrowlist_ := Attr_Out;
  END;
  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  function getMoverqLineNo(moved_no_ in VARCHAR2) RETURN NUMBER is
    row_  BL_INVENTORYPART_MOVEREQ_DTL%rowtype;
    cur   t_cursor;
    seqw_ number; --流水号
    seq_  NUMBER;
  
  begin
    -- 查询最大的退货申请号
    open cur for
      select MAX(MOVED_NO_LINE)
        from BL_INVENTORYPART_MOVEREQ_DTL t
       where t.MOVED_NO = moved_no_;
    fetch cur
      into seqw_;
  
    seq_ := NVL(seqw_, 0) + 1;
  
    close cur;
    return seq_;
  end;
  FUNCTION Checkbutton__(Dotype_  IN VARCHAR2,
                         KEY_     IN VARCHAR2,
                         User_Id_ IN VARCHAR2) RETURN VARCHAR2 IS
    ROW0_ BL_V_INVENTORYPART_MOVEREQ_DTL%ROWTYPE;
    row_  BL_V_INVENTORYPART_MOVEREQ%rowtype;
    cur_  t_Cursor;
  BEGIN
    open cur_ for
      select t.* from BL_V_INVENTORYPART_MOVEREQ t where t.moved_no = KEY_;
    fetch cur_
      into ROW_;
    IF cur_%notfound then
      close cur_;
      raise_application_error(-20101, '错误的rowid');
    end if;
    close cur_;
    IF ROW_.state <> 0 THEN
      RETURN '0';
    END IF;
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
    ROW0_ BL_V_INVENTORYPART_MOVEREQ_DTL%ROWTYPE;
    row_  BL_V_INVENTORYPART_MOVEREQ%rowtype;
    cur_  t_Cursor;
  BEGIN
    ROW0_.state    := pkg_a.Get_Item_Value('STATE', Rowlist_);
    ROW0_.moved_no := PKG_A.Get_Item_Value('MOVED_NO', Rowlist_);
    row0_.objid    := PKG_A.Get_Item_Value('OBJID', Rowlist_);
  
    open cur_ for
      select t.*
        from BL_V_INVENTORYPART_MOVEREQ t
       where t.moved_no = ROW0_.moved_no;
    fetch cur_
      into ROW_;
    IF cur_%notfound then
      close cur_;
      raise_application_error(-20101, '错误的rowid');
    end if;
    close cur_;
    if row_.moved_type = '1' and Column_Id_ = 'LOCATION_NO_DEST' then
          return '0';
    end if;
    if nvl(row0_.objid, 'NULL') = 'NULL' then
      return '1';
    end if;
    if nvl(row0_.objid, 'NULL') <> 'NULL' and Column_Id_='INOBJID' then
      return '0';
    end if;
  
    IF ROW_.state <> 0 THEN
      RETURN '0';
    END IF;
    if Column_Id_ = 'QTY_MOVED' or Column_Id_ = 'REMARK' then
      return '1';
    end if;
  
    /*    IF Column_Id_ = 'QTY_MOVE' THEN
      RETURN '0';
    END IF;*/
    RETURN '1';
  END;

  procedure COMMITED__(Rowlist_ VARCHAR2,
                       --视图的objid
                       User_Id_ VARCHAR2,
                       --用户id
                       A311_Key_ VARCHAR2) is
    CUR_            T_CURSOR;
    ROW_            BL_INVENTORYPART_MOVEREQ%ROWTYPE;
    ROW0_           BL_V_INVENTORYPART_MOVEREQ_DTL%ROWTYPE;
    transt_         number;
    Rowid_          VARCHAR2(1000);
    pallet_id_list_ VARCHAR2(4000);
    BL_MOVE         BL_INVENTORYPART_MOVEREQ_TRAN%ROWTYPE;
  begin
    Rowid_          := Rowlist_;
    pallet_id_list_ := '';
    OPEN CUR_ FOR
      SELECT T.* FROM BL_INVENTORYPART_MOVEREQ T WHERE T.ROWID = Rowid_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      close cur_;
      raise_application_error(-20101, '错误的rowid');
    END IF;
    CLOSE CUR_;
  
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_INVENTORYPART_MOVEREQ_DTL T
       WHERE t.moved_no = row_.moved_no;
    FETCH CUR_
      INTO ROW0_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      raise_application_error(-20101, '明细无提交数据');
    END IF;
    while cur_%found loop
    Inventory_Part_In_Stock_API.Move_Part(pallet_id_list_,
                                          ROW0_.contract,
                                          ROW0_.PART_NO,
                                          ROW0_.configuration_id,
                                          ROW0_.location_no,
                                          ROW0_.lot_batch_no,
                                          ROW0_.serial_no,
                                          ROW0_.eng_chg_level,
                                          ROW0_.waiv_dev_rej_no,
                                          ROW0_.EXPIRATION_DATE,
                                          ROW0_.CONTRACT,
                                          ROW0_.LOCATION_NO_DEST,
                                          ROW0_.destination,
                                          ROW0_.QTY_MOVED,
                                          ROW0_.QTY_RESERVED,
                                          null);
    SELECT MAX(T.Transaction_Id)
      INTO ROW0_.transaction_id
      FROM Inventory_Transaction_Hist2 T
     WHERE contract = ROW0_.contract
       AND PART_NO = ROW0_.PART_NO
       AND location_no = ROW0_.location_no
       AND Lot_Batch_No = ROW0_.Lot_Batch_No
       AND Serial_No = ROW0_.Serial_No
       AND Waiv_Dev_Rej_No = ROW0_.Waiv_Dev_Rej_No
       AND Eng_Chg_Level = ROW0_.Eng_Chg_Level
       AND Configuration_Id = Row0_.Configuration_Id
       AND T.transaction_code = 'INVM-ISS';
    BL_MOVE.MOVED_NO       := ROW0_.moved_no;
    BL_MOVE.MOVED_NO_LINE  := ROW0_.moved_no_line;
    BL_MOVE.QTY_MOVED      := ROW0_.QTY_MOVED;
    BL_MOVE.TRANSACTION_ID := ROW0_.transaction_id;
    BL_MOVE.ENTER_DATE     := SYSDATE;
    BL_MOVE.ENTER_USER     := USER_ID_;
    INSERT INTO BL_INVENTORYPART_MOVEREQ_TRAN
      (MOVED_NO,
       MOVED_NO_LINE,
       QTY_MOVED,
       TRANSACTION_ID,
       ENTER_DATE,
       ENTER_USER)
    VALUES
      (BL_MOVE.MOVED_NO,
       BL_MOVE.MOVED_NO_LINE,
       BL_MOVE.QTY_MOVED,
       BL_MOVE.TRANSACTION_ID,
       BL_MOVE.ENTER_DATE,
       BL_MOVE.ENTER_USER);
     FETCH CUR_
      INTO ROW0_;
    end loop;
     CLOSE CUR_;
    --更新主档
    UPDATE BL_INVENTORYPART_MOVEREQ T
       SET T.STATE = '3', t.modi_date = sysdate, t.modi_user = user_id_
     WHERE T.ROWID = Rowid_;
    --更新明细档
    update BL_INVENTORYPART_MOVEREQ_DTL t1
       set t1.state       = '3',
           T1.QTY_COMFIRM = QTY_MOVED,
           t1.modi_date   = sysdate,
           t1.modi_user   = user_id_
     where t1.moved_no = ROW_.MOVED_NO;
/*    --更新预留记录
    update BL_IMRESERVE
      set  QTY_ASSIGNED=0,
            QTY_SHIPPED =QTY_ASSIGNED,
            modi_user = User_Id_,
            modi_date = sysdate
      where key_no = ROW_.MOVED_NO;*/
    pkg_a.Setsuccess(A311_Key_,
                     'BL_INVENTORYPART_MOVEREQ_DTL',
                     pallet_id_list_);
  
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '移库申请' || '[' || Row_.Moved_No || ']' || '移库成功');
  
  end;
  procedure CHANGESTATE__(Rowlist_ VARCHAR2,
                          --视图的objid
                          User_Id_ VARCHAR2,
                          --用户id
                          A311_Key_ VARCHAR2) is
    CUR_    T_CURSOR;
    ROW_    BL_INVENTORYPART_MOVEREQ%ROWTYPE;
    ROW0_   BL_INVENTORYPART_MOVEREQ_DTL%ROWTYPE;
    transt_ number;
    Rowid_  VARCHAR2(1000);
  begin
    Rowid_ := Rowlist_;
    OPEN CUR_ FOR
      SELECT T.* FROM BL_INVENTORYPART_MOVEREQ T WHERE T.ROWID = Rowid_;
    FETCH CUR_
      INTO ROW_;
    IF CUR_%NOTFOUND THEN
      close cur_;
      raise_application_error(-20101, '错误的rowid');
    END IF;
    CLOSE CUR_;
  
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_INVENTORYPART_MOVEREQ_DTL T
       WHERE T.MOVED_NO = ROW_.MOVED_NO;
    FETCH CUR_
      INTO ROW0_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      raise_application_error(-20101, '明细无提交数据');
    END IF;
    CLOSE CUR_;
    --更新主档
    UPDATE BL_INVENTORYPART_MOVEREQ T
       SET T.STATE = '1', t.modi_date = sysdate, t.modi_user = user_id_
     WHERE T.ROWID = Rowid_;
    --更新明细档
    update BL_INVENTORYPART_MOVEREQ_DTL t1
       set t1.state = '1', t1.modi_date = sysdate, t1.modi_user = user_id_
     where t1.moved_no = ROW_.MOVED_NO;
  
    pkg_a.Setsuccess(A311_Key_, 'BL_V_INVENTORYPART_MOVEREQ_DTL', Rowid_);
  
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '移库申请' || '[' || Row_.Moved_No || ']' || '提交成功');
  
  end;
END BL_INVENTORY_MOVEREQ_DTL_API;
/
