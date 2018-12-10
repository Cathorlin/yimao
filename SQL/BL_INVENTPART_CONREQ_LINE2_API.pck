CREATE OR REPLACE PACKAGE BL_INVENTPART_CONREQ_LINE2_API IS
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

END BL_INVENTPART_CONREQ_LINE2_API;
/
CREATE OR REPLACE PACKAGE BODY BL_INVENTPART_CONREQ_LINE2_API IS
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
    row_ BL_V_BL_INVENTPART_CONREQLINE1%rowtype;
    cur_ t_Cursor;
  BEGIN
    attr_out :='';
    row_.link_key :=pkg_a.Get_Item_Value('LINK_KEY',Rowlist_);
    open cur_  for 
    select  t.*
     from BL_V_BL_INVENTPART_CONREQLINE1 T 
    where link_key  =row_.link_key;
    fetch  cur_ into row_;
    if cur_%found  then 
        pkg_a.Set_Item_Value('CONTRACT',ROW_.CONTRACT,attr_out);
        pkg_a.Set_Item_Value('PART_NO',ROW_.PART_NO,attr_out);
        pkg_a.Set_Item_Value('PART_DES',ROW_.description,attr_out);
        Pkg_a.Set_Item_Value('CONTRACT_DEST', row_.CUSTOMER_NO, Attr_Out);
    end if ;
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
    Objid_    VARCHAR2(50);
    Index_    VARCHAR2(1);
    Cur_      t_Cursor;
    cur1_      t_Cursor;
    Doaction_ VARCHAR2(10);
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar(4000);
    Ifmychange Varchar(1); 
    qty_moved_  number;
    ll_qty_     number;
    row_      BL_V_BL_INVENTPART_CONREQLINE2%rowtype;
    Row0_     BL_INVENTORYPART_MOVEREQ_DTL%ROWTYPE;
    mrow_      BL_INVENTORYPART_MOVEREQ%rowtype;
    BEGIN  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ ='I'THEN
      row_.link_key  := pkg_a.Get_Item_Value('LINK_KEY',rowlist_);
      row0_.req_no   := Pkg_a.Get_Str_(row_.link_key , '-', 1);
      row0_.req_line_no := Pkg_a.Get_Str_(row_.link_key , '-', 2);
      row0_.contract := pkg_a.Get_Item_Value('CONTRACT',Rowlist_);
      --判断是否存在移库申请的主档
        OPEN Cur_  FOR 
        SELECT T.* 
        FROM  BL_INVENTORYPART_MOVEREQ T 
        WHERE T.REQ_NO  = row0_.req_no
          and t.state = '0';
         fetch  cur_ into mrow_;
        if cur_%found  then
            Row0_.moved_no := mrow_.MOVED_NO;
        else
            Bl_Inventorypart_Movereq_Api.Getmovedno(row0_.Contract, Row0_.Moved_No);
            insert   into  Bl_Inventorypart_Movereq
                    (Moved_No,
                     Contract,
                     Requisition_Date,
                     Remark,
                     Customer_No,
                     Moved_Type,
                     State,
                     Userid,
                     Enter_Date,
                     Enter_User,
                     REQ_NO)
             select  Row0_.Moved_No,
                     CONTRACT,
                     sysdate,
                     remark,
                     CUSTOMER_NO,
                     '4',
                     '0',
                     User_Id_,
                     sysdate,
                     User_Id_,
                     row0_.req_no
             from  BL_V_BL_INVENTPART_CONREQLINE1 
             where link_key  =row_.link_key;
        end if ;
        close  cur_;
      Row0_.qty_moved := Pkg_a.Get_Item_Value('QTY_MOVED', Rowlist_);
      if row0_.qty_moved <= 0 then
        Raise_Application_Error(pkg_a.Raise_Error, '请输入正确的移库数量');
        return;
      end if;
      --检测移库的数量是否大于最大的移库申请量
      select  nvl(sum(qty_moved),0)
       into   qty_moved_
       from BL_INVENTORYPART_MOVEREQ_DTL
       where REQ_NO = row0_.REQ_NO
        and  req_line_no=row0_.req_line_no;
        select  qty 
        into  ll_qty_
        from  BL_INVENTORYPART_CONREQ_LINE t 
        where t.REQ_NO =  row0_.REQ_NO
        and   t.line_no = row0_.req_line_no;
        qty_moved_ := Row0_.qty_moved + qty_moved_;
        if qty_moved_ > ll_qty_  then 
           Raise_Application_Error(pkg_a.Raise_Error, '移库数量大于申请数量'); 
        end if ;
       --end-------
      select max(MOVED_NO_LINE)
        into Row0_.moved_no_line
        from BL_INVENTORYPART_MOVEREQ_DTL t
       where t.moved_no = Row0_.moved_no;
      Row0_.moved_no_line := nvl(Row0_.moved_no_line, 0) + 1;
    
     row_.inobjid := Pkg_a.Get_Item_Value('INOBJID', Rowlist_);
      row_.qty_used :=pkg_a.Get_Item_Value('QTY_USED',Rowlist_);
      if row0_.qty_moved > row_.qty_used then
      
        Raise_Application_Error(pkg_a.Raise_Error,
                                '移库数量不能超过可用数量' ||
                                row_.qty_used);
      end if;
      
      row0_.part_no          := pkg_a.Get_Item_Value('PART_NO',Rowlist_);
      row0_.location_no      := pkg_a.Get_Item_Value('LOCATION_NO',Rowlist_);
      row0_.LOT_BATCH_NO     := pkg_a.Get_Item_Value('LOT_BATCH_NO',Rowlist_);
      row0_.SERIAL_NO        := pkg_a.Get_Item_Value('SERIAL_NO',Rowlist_);
      row0_.ENG_CHG_LEVEL    := pkg_a.Get_Item_Value('ENG_CHG_LEVEL',Rowlist_);
      row0_.WAIV_DEV_REJ_NO  := pkg_a.Get_Item_Value('WAIV_DEV_REJ_NO',Rowlist_);
      row0_.CONFIGURATION_ID := pkg_a.Get_Item_Value('CONFIGURATION_ID',Rowlist_);
      row0_.NEW_DATA         := '';
      pkg_a.Set_Item_Value('INOBJID', row_.inobjid, row0_.NEW_DATA);
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
      pkg_a.Setsuccess(A311_Key_,'BL_V_BL_INVENTPART_CONREQLINE2', Objid_);
       RETURN;
    END IF;
    --修改
    IF Doaction_ ='M'THEN
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
       Open Cur_ For
        Select t.* From BL_V_BL_INVENTPART_CONREQLINE2 t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,'错误的rowid！');
      
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     :='update BL_INVENTORYPART_MOVEREQ_DTL SET ';
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
          if Column_Id_ ='QTY_MOVED'  then 
             if to_number(v_) <= 0 then
                Raise_Application_Error(pkg_a.Raise_Error,
                                        '请输入正确的移库数量');
                return;
             end if;
            if to_number(v_) > Row_.qty_used then --irow_.qty_onhand - irow_.qty_reserved then
               Raise_Application_Error(pkg_a.Raise_Error,
                                      '移库数量不能超过可用数量' || Row_.qty_used);
            end if;
           --检测移库的数量是否大于最大的移库申请量
            select  nvl(sum(qty_moved),0)
             into   qty_moved_
             from BL_INVENTORYPART_MOVEREQ_DTL
             where REQ_NO = row_.REQ_NO
              and  req_line_no=row_.req_line_no;
              select  qty 
              into  ll_qty_
              from  BL_INVENTORYPART_CONREQ_LINE t 
              where t.REQ_NO =  row_.REQ_NO
              and   t.line_no = row_.req_line_no;
              qty_moved_ := qty_moved_ - Row_.qty_moved + to_number(v_);
              if qty_moved_ > ll_qty_  then 
                 Raise_Application_Error(pkg_a.Raise_Error, '移库数量大于申请数量'); 
              end if ;
             --end-------
          end if ;
          Mysql_     := Mysql_ || Column_Id_ ||'='''|| v_ ||''',';
       End If;
      End Loop;

      --用户自定义列
      If Ifmychange ='1' Then 
         Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User ='''|| User_Id_ ||''''; 
         Mysql_ := Mysql_ || ' Where Rowid ='''|| Row_.Objid ||'''';
      -- raise_application_error(Pkg_a.Raise_Error, mysql_);
         Execute Immediate Mysql_;
      End If;
      Pkg_a.Setsuccess(A311_Key_,'BL_V_BL_INVENTPART_CONREQLINE2', Row_.Objid); 
      Return;
End If;
--删除
If Doaction_ ='D'Then
   OPEN CUR_ FOR
        SELECT T.* FROM BL_V_BL_INVENTPART_CONREQLINE2 T WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
        return;
      end if;
      close cur_;
     DELETE FROM BL_INVENTORYPART_MOVEREQ_DTL T WHERE T.ROWID = OBJID_; 
   pkg_a.Setsuccess(A311_Key_,'BL_V_BL_INVENTPART_CONREQLINE2', Objid_);
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
Procedure Itemchange__(Column_Id_ Varchar2, Mainrowlist_ Varchar2, Rowlist_ Varchar2, User_Id_ Varchar2, Outrowlist_ Out Varchar2) Is

    Row0_    BL_V_BL_INVENTPART_CONREQLINE2%ROWTYPE;
    Row_     INVENTORY_PART_IN_STOCK_LOC%ROWTYPE;
    Attr_Out Varchar2(4000);
cur_  t_Cursor;
Begin
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
      Pkg_a.Set_Item_Value('WAREHOUSE', Row_.warehouse, Attr_Out);
      Pkg_a.Set_Item_Value('QTY_ONHAND', Row_.qty_onhand, Attr_Out);
      row_.qty_reserved := row_.qty_reserved + Bl_Inventorypart_Movereq_Api.GetIMReserve(row_.part_no,
                                                                                         row_.contract,
                                                                                         row_.location_no,
                                                                                         row_.lot_batch_no,
                                                                                         row_.serial_no,
                                                                                         row_.eng_chg_level,
                                                                                         row_.waiv_dev_rej_no,
                                                                                         row_.configuration_id);
      Pkg_a.Set_Item_Value('QTY_RESERVED', Row_.qty_reserved, Attr_Out);
      Pkg_a.Set_Item_Value('QTY_USED',
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
      row0_.availability_control_id_des := PART_AVAILABILITY_CONTROL_API.Get_Description(row_.availability_control_id);
      Pkg_a.Set_Item_Value('AVAILABILITY_CONTROL_ID_DES',
                           row0_.availability_control_id_des,
                           Attr_Out);
    
    end if;
        --选择目的库位
    IF Column_Id_ ='LOCATION_NO_DEST'    THEN 
       row0_.location_no_dest := pkg_a.Get_Item_Value('LOCATION_NO_DEST',Rowlist_);
       Row0_.contract_dest    := pkg_a.Get_Item_Value('CONTRACT_DEST',Rowlist_);
       row0_.warehouse_dest   := INVENTORY_LOCATION_API.Get_Warehouse(Row0_.contract_dest,
                                                                      row0_.location_no_dest);
       pkg_a.Set_Item_Value('WAREHOUSE_DEST',row0_.warehouse_dest,Attr_Out);
    END IF;
Outrowlist_ := Attr_Out;
End;
/*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
Function Checkbutton__(Dotype_ In Varchar2, Key_ In Varchar2, User_Id_ In Varchar2) Return Varchar2 Is
Begin
If Dotype_ ='Add_Row' Then
   Return'1';
End If;
 If Dotype_ ='Del_Row' Then 
    Return'1';
 End If; 
Return'1';
End;

/*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
      返回: 1 可用
      0 不可用
  */
Function Checkuseable(Doaction_ In Varchar2, Column_Id_ In Varchar, Rowlist_ In Varchar2) Return Varchar2 Is
row_ BL_V_BL_INVENTPART_CONREQLINE2%rowtype;
Begin
  row_.objid := pkg_a.Get_Item_Value('OBJID',Rowlist_);
  if nvl(row_.objid,'NULL') <> 'NULL' and Column_Id_ ='INOBJID' then 
      return '0';
  end if;
 Return'1';
End;

End BL_INVENTPART_CONREQ_LINE2_API; 
/
