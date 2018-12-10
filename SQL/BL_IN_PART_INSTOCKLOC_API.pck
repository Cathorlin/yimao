CREATE OR REPLACE PACKAGE BL_IN_PART_INSTOCKLOC_API IS
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
    ---提交                       
  Procedure Submit__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2); 
   ---取消提交                       
  Procedure SubmitCancel__(Rowid_    Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);                      
  ---下达                      
  Procedure Release__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2); 
  ---取消                     
  Procedure Cancel__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2); 
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

END BL_IN_PART_INSTOCKLOC_API;
/
CREATE OR REPLACE PACKAGE BODY BL_IN_PART_INSTOCKLOC_API IS
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
    row_       BL_V_BL_IN_PART_INSTOCKLOC%rowtype;
    row0_      BL_IN_PART_INSTOCKLOC%rowtype;
    BEGIN  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ ='I'THEN
        --域
        row0_.CONTRACT  := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
        --状态
        row0_.STATE  := Pkg_a.Get_Item_Value('STATE', Rowlist_);
        --已有的可用性控制;
        row0_.AVAILABILITY_OLDID  := Pkg_a.Get_Item_Value('AVAILABILITY_OLDID', Rowlist_);
        --可用性控制
        row0_.AVAILABILITY_ID  := Pkg_a.Get_Item_Value('AVAILABILITY_ID', Rowlist_);
        row0_.enter_user := User_Id_;
        row0_.enter_date := sysdate;
        --可用申请号
        select  BL_IN_PART_INSTOCKLOC_SEQ.NEXTVAL 
         into row0_.STOCKLOC_NO 
         from  dual;
        insert into BL_IN_PART_INSTOCKLOC(STOCKLOC_NO)  
             values(row0_.STOCKLOC_NO)
             returning rowid into Objid_;
          update BL_IN_PART_INSTOCKLOC
             set  row = row0_
           where rowid = Objid_;
        pkg_a.Setsuccess(A311_Key_,'BL_V_BL_IN_PART_INSTOCKLOC', Objid_);
        RETURN;
    END IF;
    --修改
    IF Doaction_ ='M'THEN
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
       Open Cur_ For
        Select t.* From BL_V_BL_IN_PART_INSTOCKLOC t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,'错误的rowid！');
        RETURN;
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     :='update BL_IN_PART_INSTOCKLOC set ';
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
          Mysql_     := Mysql_ || Column_Id_ || '='''|| v_ ||''',';
        End If;
      End Loop;

      --用户自定义列
      If Ifmychange ='1' Then 
         Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User ='''|| User_Id_ ||''''; 
         Mysql_ := Mysql_ || ' Where ROWIDTOCHAR(Rowid) ='''|| Row_.Objid ||'''';
         --raise_application_error(Pkg_a.Raise_Error, mysql_);
         Execute Immediate Mysql_;
      End If;

      Pkg_a.Setsuccess(A311_Key_,'BL_V_BL_IN_PART_INSTOCKLOC', Row_.Objid);
      Return;
  End If;
--删除
If Doaction_ ='d'Then
   /*OPEN CUR_ FOR
        SELECT T.* FROM BL_V_BL_IN_PART_INSTOCKLOC T WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
        return;
      end if;
      close cur_;
--      DELETE FROM BL_V_BL_IN_PART_INSTOCKLOC T WHERE T.ROWID = OBJID_; */
--pkg_a.Setsuccess(A311_Key_,'BL_V_BL_IN_PART_INSTOCKLOC', Objid_);
Return;
End If;

End;
  ---提交                       
 Procedure Submit__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2)
  is 
  row_ BL_V_BL_IN_PART_INSTOCKLOC%rowtype;
  cur_ t_Cursor;
  begin
    open cur_ for
    select  t.*
     from BL_V_BL_IN_PART_INSTOCKLOC t
     where t.objid = rowid_;
     fetch cur_ into row_;
     if cur_%notfound then
        close cur_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
        return;
     end if;
     close cur_;
    UPDATE BL_IN_PART_INSTOCKLOC
      SET state = '1'
     WHERE STOCKLOC_NO = row_.STOCKLOC_NO;
    UPDATE BL_IN_PART_INSTOCKLOC_detail
      SET  state = '1'
     WHERE STOCKLOC_NO = row_.STOCKLOC_NO;
     Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_IN_PART_INSTOCKLOC', Rowid_);
     return ;
  end; 
   ---取消提交                       
  Procedure SubmitCancel__(Rowid_    Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2)
  is
  row_ BL_V_BL_IN_PART_INSTOCKLOC%rowtype;
  cur_ t_Cursor;
  begin
    open cur_ for
    select  t.*
     from BL_V_BL_IN_PART_INSTOCKLOC t
     where t.objid = rowid_;
     fetch cur_ into row_;
     if cur_%notfound then
        close cur_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
        return;
     end if;
     close cur_;
    UPDATE BL_IN_PART_INSTOCKLOC
      SET state = '0'
     WHERE STOCKLOC_NO = row_.STOCKLOC_NO;
    UPDATE BL_IN_PART_INSTOCKLOC_detail
      SET  state = '0'
     WHERE STOCKLOC_NO = row_.STOCKLOC_NO;
     Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_IN_PART_INSTOCKLOC', Rowid_);
     return ;
   end ;                      
  ---下达                      
  Procedure Release__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2)
   is
  row_ BL_V_BL_IN_PART_INSTOCKLOC%rowtype;
  row0_ BL_V_BL_IN_PART_INSTOCKLOC_DT%rowtype;
  cur_ t_Cursor;
  begin
    open cur_ for
    select  t.*
     from BL_V_BL_IN_PART_INSTOCKLOC t
     where t.objid = rowid_;
     fetch cur_ into row_;
     if cur_%notfound then
        close cur_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
        return;
     end if;
     close cur_;
    UPDATE BL_IN_PART_INSTOCKLOC
      SET state = '2'
     WHERE STOCKLOC_NO = row_.STOCKLOC_NO;
    UPDATE BL_IN_PART_INSTOCKLOC_detail
      SET  state = '2'
     WHERE STOCKLOC_NO = row_.STOCKLOC_NO;
     open cur_ for 
     select t.* 
     from BL_V_BL_IN_PART_INSTOCKLOC_DT t 
     where t.STOCKLOC_NO = row_.STOCKLOC_NO
      and  t.state='2';
      fetch  cur_ into row0_;
      while cur_%found  loop
         INVENTORY_PART_IN_STOCK_API.Modify_Availability_Control_Id(row0_.CONTRACT,
                                                                    row0_.PART_NO,
                                                                    row0_.CONFIGURATION_ID,
                                                                    row0_.LOCATION_NO,
                                                                    row0_.LOT_BATCH_NO,
                                                                    row0_.SERIAL_NO,
                                                                    row0_.ENG_CHG_LEVEL,
                                                                    row0_.WAIV_DEV_REJ_NO,
                                                                    row_.AVAILABILITY_ID);
         fetch  cur_ into row0_;
      end loop;
      close cur_;
     Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_IN_PART_INSTOCKLOC', Rowid_);
   end ;      
  ---取消                     
  Procedure Cancel__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2)
   is
  row_ BL_V_BL_IN_PART_INSTOCKLOC%rowtype;
  cur_ t_Cursor;
  begin
    open cur_ for
    select  t.*
     from BL_V_BL_IN_PART_INSTOCKLOC t
     where t.objid = rowid_;
     fetch cur_ into row_;
     if cur_%notfound then
        close cur_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
        return;
     end if;
     close cur_;
    UPDATE BL_IN_PART_INSTOCKLOC
      SET state = '3'
     WHERE STOCKLOC_NO = row_.STOCKLOC_NO;
    UPDATE BL_IN_PART_INSTOCKLOC_detail
      SET  state = '3'
     WHERE STOCKLOC_NO = row_.STOCKLOC_NO;
     Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_IN_PART_INSTOCKLOC', Rowid_);
   end ;      
/*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
Procedure Itemchange__(Column_Id_ Varchar2, Mainrowlist_ Varchar2, Rowlist_ Varchar2, User_Id_ Varchar2, Outrowlist_ Out Varchar2) Is
Attr_Out Varchar2(4000);
ROW_ BL_V_BL_IN_PART_INSTOCKLOC%ROWTYPE;
Begin
If Column_Id_ ='AVAILABILITY_ID' Then
   ROW_.AVAILABILITY_ID  :=  PKG_A.Get_Item_Value('AVAILABILITY_ID',Rowlist_);
   row_.AVAILABILITY_des := PART_AVAILABILITY_CONTROL_API.Get_Description(ROW_.AVAILABILITY_ID);
   pkg_a.Set_Item_Value('AVAILABILITY_DES',row_.AVAILABILITY_des,Attr_Out);
End If; 
If Column_Id_ ='AVAILABILITY_OLDID' Then
   ROW_.AVAILABILITY_OLDID  :=  PKG_A.Get_Item_Value('AVAILABILITY_OLDID',Rowlist_);
   row_.AVAILABILITY_OLDDES := PART_AVAILABILITY_CONTROL_API.Get_Description(ROW_.AVAILABILITY_OLDID);
   pkg_a.Set_Item_Value('AVAILABILITY_OLDDES',row_.AVAILABILITY_OLDDES,Attr_Out);
End If; 
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
  row_   BL_V_BL_IN_PART_INSTOCKLOC%ROWTYPE;
Begin
  ROW_.objid := PKG_A.Get_Item_Value('OBJID',Rowlist_);
  row_.STATE := pkg_a.Get_Item_Value('STATE',Rowlist_);
  IF NVL(ROW_.objid,'NULL') = 'NULL'  THEN 
      RETURN '1';
  ELSE
      IF ROW_.STATE = '0' THEN
         IF Column_Id_ ='AVAILABILITY_ID'  THEN 
            RETURN  '1'; 
         END IF ;
      END IF ; 
      Return'0';
  END IF;
End;

End BL_IN_PART_INSTOCKLOC_API; 
/
