CREATE OR REPLACE PACKAGE BL_INVENTORY_PART_VALIDITY_API IS
  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2);
   /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A311的主键     
  */
  PROCEDURE Modify__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2);
  --获取库存件是否过期
  FUNCTION  Get_Inventory_Part_Validity(part_no_ varchar2,
                                         contract_ varchar2,
                                         lot_batch_no_ varchar2) return number;
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

END BL_INVENTORY_PART_VALIDITY_API;
/
CREATE OR REPLACE PACKAGE BODY BL_INVENTORY_PART_VALIDITY_API IS
  TYPE t_Cursor IS REF CURSOR;
  --【COLUMN】  列名称 按实际的逻辑 用实际的列名
  -- 【VALUE】  列的数据 按具体的实际逻辑 用对应的参数来替代
  /*create fjp 2012-12-20
  报错
  Raise_Application_Error(pkg_a.raise_error,'出错了 ！！！！！');
  */

  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2) IS
    attr_out VARCHAR2(4000);
    Row_  BL_INVENTORY_PART_VALIDITY%ROWTYPE;
  BEGIN
    attr_out :='';
    Row_.Contract := Pkg_Attr.Get_Default_Contract(User_Id_);
    Pkg_a.Set_Item_Value('CONTRACT', Row_.Contract, Attr_Out);
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
    row_  BL_V_BL_INVENT_PART_VALIDITY%rowtype;
    row0_ BL_INVENTORY_PART_VALIDITY%rowtype;
    BEGIN  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ ='I'THEN
       row0_.PART_NO     := pkg_a.Get_Item_Value('PART_NO',Rowlist_);
       row0_.description := pkg_a.Get_Item_Value('DESCRIPTION',Rowlist_);
       row0_.contract    := pkg_a.Get_Item_Value('CONTRACT',Rowlist_);
       row0_.validity    := pkg_a.Get_Item_Value('VALIDITY',Rowlist_);
       row0_.dtype       := pkg_a.Get_Item_Value('DTYPE',Rowlist_);
       row0_.enter_user  := User_Id_;
       row0_.enter_date  := sysdate;
       insert into BL_INVENTORY_PART_VALIDITY(PART_NO,contract)
             values(row0_.PART_NO,row0_.contract)
            returning rowid into Objid_;
         update BL_INVENTORY_PART_VALIDITY
         set row = row0_
         where rowid = Objid_;
       pkg_a.Setsuccess(A311_Key_,'BL_V_BL_INVENT_PART_VALIDITY', Objid_);  
       RETURN;
    END IF;
    --修改
    IF Doaction_ ='M'THEN
      --pkg_a.Setsuccess(A311_Key_,''[TABLE_ID]'', Objid_);
       Open Cur_ For
        Select t.* 
        From BL_V_BL_INVENT_PART_VALIDITY t 
        Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,'错误的rowid！');
      
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := 'update BL_INVENTORY_PART_VALIDITY set ';
      Ifmychange := '0';
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
         Mysql_ := Mysql_ || ' Where Rowid ='''|| Row_.Objid ||'''';
      -- raise_application_error(Pkg_a.Raise_Error, mysql_);
         Execute Immediate Mysql_;
      End If;
     Pkg_a.Setsuccess(A311_Key_,'BL_V_BL_INVENT_PART_VALIDITY', Row_.Objid); 
Return;
End If;

End;

 FUNCTION  Get_Inventory_Part_Validity(part_no_ varchar2,
                                         contract_ varchar2,
                                         lot_batch_no_ varchar2) return number
 is 
  Day_Differ_  number;
  count_ number;
  cur_ t_Cursor;
  row_ BL_INVENTORY_PART_VALIDITY%rowtype;
  ls_Prime_Commodity_ VARCHAR2(5);
 begin
   --最早入库日期 与当天日期相减等到相差天数
    select  to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd') - 
             to_date(nvl(to_char(min(b.date_applied),'yyyy-mm-dd'),'1900-01-01'),'yyyy-mm-dd') 
    into Day_Differ_
        from IFSAPP.inventory_transaction_hist_tab b
        where b.part_no = part_no_
        and b.lot_batch_no = lot_batch_no_
        and b.contract = contract_;
    ls_Prime_Commodity_ :=INVENTORY_PART_API.Get_Prime_Commodity(contract_,part_no_); 
   open  cur_ for 
   select  t.*
    from  BL_INVENTORY_PART_VALIDITY t 
   where  ((t.part_no   =  part_no_    and t.DTYPE='0') 
           or (t.part_no= ls_Prime_Commodity_  and t.DTYPE='1'))
    and   t.CONTRACT=contract_;
    fetch cur_ into row_;
    if cur_%found  then
       if row_.validity < Day_Differ_  then  --过期
          close cur_;
          return 1;
       end if ;
    end if ;
    close cur_;
    return 0; 
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
ROW_  BL_INVENTORY_PART_VALIDITY%ROWTYPE;
CUR_ t_Cursor;
ROW1_ BL_V_INVENTORY_PART_NO%ROWTYPE;
Begin
If Column_Id_ ='PART_NO' Then
  ROW_.PART_NO := pkg_a.Get_Item_Value('PART_NO',Rowlist_);
  open cur_ for
  select  t.*
   from BL_V_INVENTORY_PART_NO t
  where t.part_no = row_.part_no;
  fetch  cur_ into ROW1_;
  if cur_%found  then
      pkg_a.Set_Item_Value('PART_NO', ROW1_.PART_NO,Attr_Out);
      pkg_a.Set_Item_Value('DESCRIPTION', ROW1_.DESCRIPTION,Attr_Out);
      pkg_a.Set_Item_Value('DTYPE', ROW1_.DTYPE,Attr_Out);
  end if;
  close cur_;
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
Begin
If Column_Id_ ='【column】'
  Then Return'0';
End If;
 Return'1';
End;

End BL_INVENTORY_PART_VALIDITY_API; 
/
