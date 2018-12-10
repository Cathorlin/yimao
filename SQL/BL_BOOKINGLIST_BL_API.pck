CREATE OR REPLACE PACKAGE BL_BOOKINGLIST_BL_API IS
/* Created By FJP  2013-02-01 11:38:04*/
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

END BL_BOOKINGLIST_BL_API;
/
CREATE OR REPLACE PACKAGE BODY BL_BOOKINGLIST_BL_API IS
/* Created By FJP  2013-02-01 11:38:04*/
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
    row_      BL_V_BOOKINGLIST_BL%rowtype;
    BEGIN  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ ='I'THEN
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      
      --BOOKING_NO
      row_.BOOKING_NO  := Pkg_a.Get_Item_Value('BOOKING_NO', Rowlist_);
      --LINE_NO
      select nvl(max(line_no),0)+ 1
       into row_.LINE_NO
      from   BL_BOOKINGLIST_BL 
      where BOOKING_NO = row_.BOOKING_NO;
      --BK_NO
      row_.BK_NO  := Pkg_a.Get_Item_Value('BK_NO', Rowlist_);
      --REMARK
      row_.REMARK  := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      --ENTER_DATE
      row_.ENTER_DATE  := SYSDATE;
      --ENTER_USER
      row_.ENTER_USER  := user_id_;
      INSERT INTO BL_BOOKINGLIST_BL(booking_no,
                                    line_no,
                                    bk_no,
                                    remark,
                                    enter_date,
                                    enter_user)
        values(row_.booking_no,
              row_.line_no,
              row_.bk_no,
              row_.remark,
              row_.enter_date,
              row_.enter_user)
        returning rowid into Objid_;
        Pkg_a.Setsuccess(A311_Key_,'BL_V_BOOKINGLIST_BL', Objid_);
        RETURN;
    END IF;
    --修改
    IF Doaction_ ='M'THEN
      
       Open Cur_ For
        Select t.* From BL_V_BOOKINGLIST_BL t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,'错误的rowid！');      
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     :='update BL_V_BOOKINGLIST_BL SET ';
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

      --如果存在修改--
      If Ifmychange ='1' Then 
         Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User ='''|| User_Id_ ||''''; 
         Mysql_ := Mysql_ || ' Where Rowid ='''|| Objid_ ||'''';
      -- raise_application_error(Pkg_a.Raise_Error, mysql_);
         Execute Immediate Mysql_;
      End If;

      --设置成功的标志
      Pkg_a.Setsuccess(A311_Key_,'BL_V_BOOKINGLIST_BL', Objid_); 
Return;
End If;
--删除
If Doaction_ ='D'Then
   OPEN CUR_ FOR
        SELECT T.* FROM BL_V_BOOKINGLIST_BL T WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
        return;
      end if;
      close cur_;
      DELETE FROM BL_V_BOOKINGLIST_BL T WHERE T.ROWID = OBJID_; 
--设置成功的标志
     pkg_a.Setsuccess(A311_Key_,'BL_V_BOOKINGLIST_BL', Objid_);
    Return;
End If;

End;
/*    列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
Procedure Itemchange__(Column_Id_ Varchar2, Mainrowlist_ Varchar2, Rowlist_ Varchar2, User_Id_ Varchar2, Outrowlist_ Out Varchar2) 
 Is
Attr_Out Varchar2(4000); row_      BL_V_BOOKINGLIST_BL%rowtype;
Begin
If Column_Id_ ='' Then
--给列赋值
Pkg_a.Set_Item_Value('【COLUMN】','【VALUE】', Attr_Out);
--设置列不可用
Pkg_a.Set_Column_Enable('【COLUMN】','0', Attr_Out);
--设置列可用
Pkg_a.Set_Column_Enable('【COLUMN】','1', Attr_Out);
--设置添加行按钮不可用
--pkg_a.Set_Addrow_Enable('0',Attr_Out);
--设置删除行按钮不可用
--pkg_a.Set_Delrow_Enable('0',Attr_Out);
End If; 
Outrowlist_ := Attr_Out;
End;
/*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
*/
Function Checkbutton__(Dotype_ In Varchar2, Key_ In Varchar2, User_Id_ In Varchar2) Return Varchar2 
Is
  row_      BL_V_BOOKINGLIST_BL%rowtype;
  mrow_     bl_v_bookinglist%rowtype;
  cur_      t_Cursor;
Begin
   open cur_  for
   select t.* 
    from bl_v_bookinglist t 
   where  t.booking_no =  Key_;
   fetch  cur_ into mrow_;
   close cur_;
   if nvl(mrow_.DSDATE,'NULL') <> 'NULL' then 
      if mrow_.state ='4' or mrow_.state='3' then 
         return '1';
      else
         return '1';
      end if;
   else
       return '0';
   end if ;
/*If Dotype_ ='Add_Row' Then
   Return'1';
End If;
 If Dotype_ ='Del_Row' Then 
    Return'1';
 End If; */
Return'1';
End;

/*  实现业务逻辑控制列的 编辑性
    Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
    Column_Id_  列
    Rowlist_  当前行的数据
    返回: 1 可用
    0 不可用
  */
Function Checkuseable(Doaction_ In Varchar2, Column_Id_ In Varchar, Rowlist_ In Varchar2) Return Varchar2
   Is
 row_      BL_V_BOOKINGLIST_BL%rowtype;
Begin
  row_.objid := pkg_a.Get_Item_Value('OBJID',Rowlist_);
  if nvl(row_.objid,'NULL') <> 'NULL'  then 
     if Column_Id_ = 'BK_NO' then 
         return '0';
     end if ;
  end if;
  return '1';
/*If Column_Id_ ='【COLUMN】'
  Then Return'0';
End If;
 Return'1';*/
End;

End BL_BOOKINGLIST_BL_API; 
/
