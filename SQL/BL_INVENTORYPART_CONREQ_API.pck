CREATE OR REPLACE PACKAGE BL_INVENTORYPART_CONREQ_API IS
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
  /*获取申请单号*/
  procedure getREQ_No(contract_ in varchar2, seq_ out varchar2);
    ---下达                      
  Procedure Release__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2); 
    ---取消下达                      
  Procedure ReleaseCancel__(Rowid_    Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2);                     
  ---确定                      
  Procedure Determine__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  ---确定                      
  Procedure Distribution__(Rowid_    Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2);                     
  --取消确定
  Procedure DetermineCancel__(Rowid_    Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);  
  ---取消                      
  Procedure Cancel__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);  
/*  --保存移库申请预留表
  PROCEDURE Commit_BL_IMRESERVE(row_ BL_IMRESERVE%rowtype,
                                user_id_ varchar2);   */                  
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

END BL_INVENTORYPART_CONREQ_API;
/
CREATE OR REPLACE PACKAGE BODY BL_INVENTORYPART_CONREQ_API IS
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
    attr_out :='';
  
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
    Doaction_ VARCHAR2(10);
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar(4000);
    Ifmychange Varchar(1);
     row_      BL_V_BL_INVENTORYPART_CONREQ%rowtype;
     ROW0_     BL_INVENTORYPART_CONREQ%rowtype;
    BEGIN  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ ='I'THEN
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
        --申请号
        --ROW0_.REQ_NO  := Pkg_a.Get_Item_Value('REQ_NO', Rowlist_);
       
        --域
        ROW0_.CONTRACT  := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
        getREQ_No( ROW0_.CONTRACT,ROW0_.REQ_NO);
        --申请时间
        ROW0_.REQUISITION_DATE  := TO_DATE(Pkg_a.Get_Item_Value('REQUISITION_DATE', Rowlist_),'YYYY-MM-DD');
        --供应商
        ROW0_.VENDOR_NO  := Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_);
        --状态
        ROW0_.STATE  := Pkg_a.Get_Item_Value('STATE', Rowlist_);
        --备注
        ROW0_.REMARK  := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
        --录入人
        ROW0_.ENTER_USER  := User_Id_;
        --录入日期
        ROW0_.ENTER_DATE  := SYSDATE;
        INSERT INTO BL_INVENTORYPART_CONREQ(REQ_NO)
        VALUES(ROW0_.REQ_NO)
        RETURNING ROWID INTO Objid_;
        UPDATE BL_INVENTORYPART_CONREQ
         SET ROW = ROW0_
         WHERE ROWID = Objid_;
         pkg_a.Setsuccess(A311_Key_,'BL_V_BL_INVENTORYPART_CONREQ', Objid_);
        RETURN;
    END IF;
    --修改
    IF Doaction_ ='M'THEN
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
       Open Cur_ For
        Select t.* From BL_V_BL_INVENTORYPART_CONREQ t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,'错误的rowid！');
      
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     :='update BL_INVENTORYPART_CONREQ SET ';
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
          IF Column_Id_ = 'REQUISITION_DATE'  THEN
            Mysql_ := Mysql_ || ' ' || Column_Id_ || '=to_date(''' || v_ ||
                      ''',''YYYY-MM-DD''),';
          ELSE
            Mysql_     := Mysql_ || Column_Id_ || '='''|| v_ ||''',';
          END IF;
        End If;

       End Loop;

      --用户自定义列
      If Ifmychange ='1' Then 
         Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User ='''|| User_Id_ ||''''; 
         Mysql_ := Mysql_ || ' Where Rowid ='''|| Row_.Objid ||'''';
      -- raise_application_error(Pkg_a.Raise_Error, mysql_);
         Execute Immediate Mysql_;
      End If;

      Pkg_a.Setsuccess(A311_Key_,'BL_V_BL_INVENTORYPART_CONREQ', Row_.Objid); 
   Return;
End If;
--删除
If Doaction_ ='D'Then
   /*OPEN CUR_ FOR
        SELECT T.* FROM BL_V_BL_INVENTORYPART_CONREQ T WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
        return;
      end if;
      close cur_;
--      DELETE FROM BL_V_BL_INVENTORYPART_CONREQ T WHERE T.ROWID = OBJID_; */
--pkg_a.Setsuccess(A311_Key_,'BL_V_BL_INVENTORYPART_CONREQ', Objid_);
Return;
End If;

End;
procedure getREQ_No(contract_ in varchar2, seq_ out varchar2) is
    Cur_  t_Cursor;
    seqw_ number; --流水号
  begin
    open cur_ for
      select NVL(MAX(TO_NUMBER(substr(REQ_No, 9, 3))), '0')
        from BL_INVENTORYPART_CONREQ t
       where t.contract = contract_;
    fetch cur_
      into seqw_;
     close cur_;
    seq_ := contract_||to_char(sysdate, 'YYYYMM') ||trim(to_CHAR(seqw_ + 1, '000'));
  end;
   ---下达                      
 Procedure Release__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2)
 is 
  row_ BL_V_BL_INVENTORYPART_CONREQ%rowtype;
  cur_ t_Cursor;
  begin
    open cur_ for
    select  t.*
     from BL_V_BL_INVENTORYPART_CONREQ t
     where t.objid = rowid_;
     fetch cur_ into row_;
     if cur_%notfound then
        close cur_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
        return;
     end if;
     close cur_;
    UPDATE BL_INVENTORYPART_CONREQ
      SET state = '1',
          modi_user = User_Id_,
          modi_date = sysdate
     WHERE REQ_NO = row_.REQ_NO;
    UPDATE BL_INVENTORYPART_CONREQ_LINE
      SET  state = '1',
           modi_user = User_Id_,
           modi_date = sysdate
     WHERE REQ_NO = row_.REQ_NO;
     Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_IN_PART_INSTOCKLOC', Rowid_);
     return;  
 end;
     ---取消下达                      
  Procedure ReleaseCancel__(Rowid_    Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2)
    is 
  row_ BL_V_BL_INVENTORYPART_CONREQ%rowtype;
  cur_ t_Cursor;
  begin
    open cur_ for
    select  t.*
     from BL_V_BL_INVENTORYPART_CONREQ t
     where t.objid = rowid_;
     fetch cur_ into row_;
     if cur_%notfound then
        close cur_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
        return;
     end if;
     close cur_;
    UPDATE BL_INVENTORYPART_CONREQ
      SET state = '0',
          modi_user = User_Id_,
          modi_date = sysdate
     WHERE REQ_NO = row_.REQ_NO;
    UPDATE BL_INVENTORYPART_CONREQ_LINE
      SET  state = '0',
          modi_user = User_Id_,
          modi_date = sysdate
     WHERE REQ_NO = row_.REQ_NO;
     Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_IN_PART_INSTOCKLOC', Rowid_);
     return;  
 end;                         
   ---确定                      
  Procedure Determine__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2)
   is 
  row_ BL_V_BL_INVENTORYPART_CONREQ%rowtype;
  cur_ t_Cursor;
  begin
    open cur_ for
    select  t.*
     from BL_V_BL_INVENTORYPART_CONREQ t
     where t.objid = rowid_;
     fetch cur_ into row_;
     if cur_%notfound then
        close cur_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
        return;
     end if;
     close cur_;
    UPDATE BL_INVENTORYPART_CONREQ
      SET state = '2',
          modi_user = User_Id_,
          modi_date = sysdate
     WHERE REQ_NO = row_.REQ_NO;
    UPDATE BL_INVENTORYPART_CONREQ_LINE
      SET  state = '2',
          modi_user = User_Id_,
          modi_date = sysdate
     WHERE REQ_NO = row_.REQ_NO;
     Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_IN_PART_INSTOCKLOC', Rowid_);
     return;  
 end;
 --分配提交
 Procedure Distribution__(Rowid_    Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2)
 is
  row_ BL_V_BL_INVENTORYPART_CONREQ01%rowtype;
  cur_ t_Cursor;
 begin
     open cur_ for
     select t.*
     from BL_V_BL_INVENTORYPART_CONREQ01 t 
     where t.objid = Rowid_;
     fetch cur_ into row_;
     if cur_%notfound then 
        close cur_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
     end if ;
     close cur_;
     update BL_INVENTORYPART_MOVEREQ
       set state ='1',
           modi_date = sysdate,
           modi_user =user_id_
      where REQ_NO = row_.REQ_NO
       and  state='0';
   --更新明细档
    Update Bl_Inventorypart_Movereq_Dtl T1
       Set T1.State = '1'
     Where T1.REQ_NO = Row_.REQ_NO
     AND   T1.STATE    = '0';
---- 插入预留记录
/*      insert into BL_IMRESERVE(   key_no      ,
                                  line_no        ,
                                  part_no        ,
                                  qty_assigned    ,
                                  qty_shipped     ,
                                  contract       ,
                                  location_no     ,
                                  lot_batch_no     ,
                                  serial_no        ,
                                  eng_chg_leve     ,
                                  waiv_dev_rej_no  ,
                                  configuration_id ,
                                  enter_user       ,
                                  enter_date  )
                         select     MOVED_NO      ,
                                    MOVED_NO_LINE        ,
                                    part_no        ,
                                    QTY_MOVED    ,
                                    0     ,
                                    contract       ,
                                    location_no     ,
                                    lot_batch_no     ,
                                    serial_no        ,
                                    eng_chg_level     ,
                                    waiv_dev_rej_no  ,
                                    configuration_id ,
                                    user_id_       ,
                                    sysdate
                           from  BL_INVENTORYPART_MOVEREQ_DTL
                           where REQ_NO = row_.REQ_NO
                             and  state ='0';
      update BL_INVENTORYPART_MOVEREQ_DTL
       set state='1',
           modi_date = sysdate,
           modi_user =user_id_
      where REQ_NO = row_.REQ_NO
      and   state ='0';*/
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_INVENTORYPART_CONREQ01', Rowid_);
    return; 
 end;  
   --取消确定
  Procedure DetermineCancel__(Rowid_    Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2)
      is 
  row_ BL_V_BL_INVENTORYPART_CONREQ%rowtype;
  cur_ t_Cursor;
  begin
    open cur_ for
    select  t.*
     from BL_V_BL_INVENTORYPART_CONREQ t
     where t.objid = rowid_;
     fetch cur_ into row_;
     if cur_%notfound then
        close cur_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
        return;
     end if;
     close cur_;
    UPDATE BL_INVENTORYPART_CONREQ
      SET state = '1',
          modi_user = User_Id_,
          modi_date = sysdate
     WHERE REQ_NO = row_.REQ_NO;
    UPDATE BL_INVENTORYPART_CONREQ_LINE
      SET  state = '1',
          modi_user = User_Id_,
          modi_date = sysdate
     WHERE REQ_NO = row_.REQ_NO;
     Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_IN_PART_INSTOCKLOC', Rowid_);
     return;  
 end;                           
   ---取消                      
  Procedure Cancel__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2)
  is 
  row_ BL_V_BL_INVENTORYPART_CONREQ%rowtype;
  cur_ t_Cursor;
  begin
    open cur_ for
    select  t.*
     from BL_V_BL_INVENTORYPART_CONREQ t
     where t.objid = rowid_;
     fetch cur_ into row_;
     if cur_%notfound then
        close cur_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
        return;
     end if;
     close cur_;
    UPDATE BL_INVENTORYPART_CONREQ
      SET state = '3',
          modi_user = User_Id_,
          modi_date = sysdate
     WHERE REQ_NO = row_.REQ_NO;
    UPDATE BL_INVENTORYPART_CONREQ_LINE
      SET  state = '3',
          modi_user = User_Id_,
          modi_date = sysdate
     WHERE REQ_NO = row_.REQ_NO;
     Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_IN_PART_INSTOCKLOC', Rowid_);
     return;  
 end;  
  /*PROCEDURE Commit_BL_IMRESERVE(row_ BL_IMRESERVE%rowtype,
                               user_id_ varchar2) 
  is 
  cur_ t_Cursor;
  rowid_ varchar2(100);
  begin
    open cur_ for 
    select t.rowid 
     from  BL_IMRESERVE t 
     where t.key_no         = row_.key_no
      and  line_no          = row_.line_no
      and  part_no          = row_.part_no
      and  contract         = row_.contract
      and  location_no      = row_.location_no
      and  lot_batch_no     = row_.lot_batch_no
      and  serial_no        = row_.serial_no
      and  eng_chg_leve     = row_.eng_chg_leve
      and  waiv_dev_rej_no  = row_.waiv_dev_rej_no
      and  configuration_id = row_.configuration_id;
    fetch cur_ into rowid_;
    if cur_%found  then
       if row_.qty_assigned=0 and row_.qty_shipped=0 then 
          delete from BL_IMRESERVE where rowid = rowid_;
       else
         update BL_IMRESERVE
          set   QTY_ASSIGNED = row_.qty_assigned,
                QTY_SHIPPED  = row_.qty_shipped,
                modi_user =user_id_,
                modi_date  = sysdate
          where rowid = rowid_;
       end if ;
    else 
        insert into BL_IMRESERVE(   key_no      ,
                                    line_no        ,
                                    part_no        ,
                                    qty_assigned    ,
                                    qty_shipped     ,
                                    contract       ,
                                    location_no     ,
                                    lot_batch_no     ,
                                    serial_no        ,
                                    eng_chg_leve     ,
                                    waiv_dev_rej_no  ,
                                    configuration_id ,
                                    enter_user       ,
                                    enter_date  )
                           values(  row_.key_no      ,
                                    row_.line_no        ,
                                    row_.part_no        ,
                                    row_.qty_assigned    ,
                                    row_.qty_shipped     ,
                                    row_.contract       ,
                                    row_.location_no     ,
                                    row_.lot_batch_no     ,
                                    row_.serial_no        ,
                                    row_.eng_chg_leve     ,
                                    row_.waiv_dev_rej_no  ,
                                    row_.configuration_id ,
                                    user_id_       ,
                                    sysdate);
    end if;
    close cur_;
    return;
  end;*/
/*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
Procedure Itemchange__(Column_Id_ Varchar2, Mainrowlist_ Varchar2, Rowlist_ Varchar2, User_Id_ Varchar2, Outrowlist_ Out Varchar2) Is
Attr_Out Varchar2(4000);
row_ BL_V_BL_INVENTORYPART_CONREQ%rowtype;
Begin
if Column_Id_='VENDOR_NO' then 
   row_.vendor_no := pkg_a.Get_Item_Value('VENDOR_NO',Rowlist_);
   row_.vendor_name :=  SUPPLIER_API.GET_VENDOR_NAME(row_.vendor_no );
   pkg_a.Set_Item_Value('VENDOR_NAME',row_.VENDOR_NAME,Attr_Out);
end if;
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
Begin
if Doaction_='M'    then 
  if Column_Id_ <> 'REMARK'  then
       return '0';
  end if ;
end if ;
 Return'1';
End;

End BL_INVENTORYPART_CONREQ_API; 
/
