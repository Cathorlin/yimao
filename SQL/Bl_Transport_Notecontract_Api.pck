CREATE OR REPLACE Package Bl_Transport_Notecontract_Api Is

  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  Procedure Remove__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2);
  --判断当前列是否可编辑--
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2;
  ----检查编辑 修改
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2;

End Bl_Transport_Notecontract_Api;
/
CREATE OR REPLACE Package Body Bl_Transport_Notecontract_Api Is
  Type t_Cursor Is Ref Cursor;

  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
  Begin
  
    Return;
  End;

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Index_     Varchar2(1);
    Doaction_  Varchar2(1);
    Objid_     Varchar2(100);
    Cur_       t_Cursor;
    Row_       Bl_v_Transport_Notecontract%Rowtype;
    Rowm_      Bl_v_Transport_Note%Rowtype;
    Ll_Count_  Number;
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar2(4000);
    Ifmychange Varchar2(1);
  
  Begin
  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
  
    If Doaction_ = 'I' Then
    
      --判断主档状态是否可以添加明细
      Row_.Note_No := Pkg_a.Get_Item_Value('NOTE_NO', Rowlist_);
    
      Open Cur_ For
        Select t.*
          From Bl_v_Transport_Note t
         Where t.Note_No = Row_.Note_No;
      Fetch Cur_
        Into Rowm_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '未取得主档信息');
        Return;
      End If;
      Close Cur_;
    
      If Rowm_.State <> 0 Then
        Raise_Application_Error(-20101,
                                '退货申请单' || Row_.Note_No || '非保存状态，不可添加明细');
        Return;
      End If;
    
      -- 从页面获取数据
      Row_.Contract    := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Row_.Containerno := Pkg_a.Get_Item_Value('CONTAINERNO', Rowlist_);
      Row_.Shoptime    := To_Date(Pkg_a.Get_Item_Value('SHOPTIME', Rowlist_),
                                  'YYYY-MM-DDHH24:MI:SS');
      Row_.Contact     := Pkg_a.Get_Item_Value('CONTACT', Rowlist_);
      Row_.Conacttel   := Pkg_a.Get_Item_Value('CONACTTEL', Rowlist_);
      Row_.State       := Pkg_a.Get_Item_Value('STATE', Rowlist_);
      Row_.Remark      := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
    
      -- 插入明细表的数据
      Insert Into Bl_Transport_Notecontract
        (Note_No,
         Contract,
         Containerno,
         Shoptime,
         Contact,
         Conacttel,
         State,
         Remark)
        Select Row_.Note_No,
               Row_.Contract,
               Row_.Containerno,
               Row_.Shoptime,
               Row_.Contact,
               Row_.Conacttel,
               Row_.State,
               Row_.Remark
          From Dual;
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_TRANSPORT_NOTECONTRACT', Objid_);
    
      Return;
    End If;
    -- 删除
    If Doaction_ = 'D' Then
    
      --判断明细档状态是否可以删除明细
    
      Open Cur_ For
        Select t.*
          From Bl_v_Transport_Notecontract t
         Where t.Rowid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '未取得明细信息');
        Return;
      End If;
      Close Cur_;
    
      Delete From Bl_v_Transport_Notecontract t Where t.Rowid = Objid_;
    
      Return;
    End If;
  
    If Doaction_ = 'M' Then
    
      Open Cur_ For
        Select t.*
          From Bl_v_Transport_Notecontract t
         Where t.Rowid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '未取得明细信息');
        Return;
      End If;
      Close Cur_;
    
      Data_  := Rowlist_;
      Pos_   := Instr(Data_, Index_);
      i      := i + 1;
      Mysql_ := ' update BL_V_TRANSPORT_NOTECONTRACT set ';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'ORDER_SEL' And
           Column_Id_ <> 'PICK_SEL' And Column_Id_ <> 'DOACTION' And
           Length(Nvl(Column_Id_, '')) > 0 Then
          v_         := Substr(v_, Pos1_ + 1);
          i          := i + 1;
          Ifmychange := '1';
          --   if column_id_ = 'DATE_SURE' or column_id_='SURE_SHIPDATE' or column_id_='RECALCU_DATE' then
          --     mysql_ := mysql_ || ' ' || column_id_ || '=to_date(''' || v_  || ''',''YYYY-MM-DD HH24:MI:SS''),';
          --  else
          Mysql_ := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
          --  end if ;
        End If;
      End Loop;
      If Ifmychange = '1' Then
        -- 更新sql语句
        Mysql_ := Substr(Mysql_, 1, Length(Mysql_) - 1);
        Mysql_ := Mysql_ || ' where rowidtochar(rowid)=''' || Objid_ || '''';
        Execute Immediate Mysql_;
      End If;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_TRANSPORT_NOTECONTRACT', Objid_);
      Return;
    End If;
  End;
  /*  退货申请明细删除 REMOVE__
      Rowlist_  删除的当前退货申请单明细行
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  Procedure Remove__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
  Begin
    Return;
  End;

  /*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2) Is
    Cur_     t_Cursor;
    Attr_Out Varchar2(4000);
    Row_     Site_Tab%Rowtype;
  Begin
    /*
    IF COLUMN_ID_ = 'CONTRACT' THEN
      ROW_.CONTRACT := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT T.* FROM SITE_TAB T WHERE T.CONTRACT = ROW_.CONTRACT;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '错误的rowid');
        RETURN;
      END IF;
      CLOSE CUR_;
      -- 赋值
      PKG_A.SET_ITEM_VALUE('CONTRACTDESC', ROW_.CONTRACT_REF, ATTR_OUT);
    END IF;
     */
  
    Pkg_a.Set_Item_Value(Column_Id_,
                         Pkg_a.Get_Item_Value(Column_Id_, Rowlist_),
                         Attr_Out);
    Outrowlist_ := Attr_Out;
  
  End;

  /*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
      返回: 1 可用
      0 不可用
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    Row_ Bl_v_Transport_Note%Rowtype;
  Begin
  
    Row_.State := Pkg_a.Get_Item_Value('STATE', Rowlist_);
  
    If Row_.State != '0' Then
      If Column_Id_ = 'PICKLISTNO' Or Column_Id_ = Upper('containerno') Or
         Column_Id_ = Upper('contract') Or Column_Id_ = Upper('shoptime') Or
         Column_Id_ = Upper('contact') Or Column_Id_ = Upper('conactTeL') Or
         Column_Id_ = Upper('remark') Then
        Return '0';
      End If;
    End If;
    Return '1';
  End;

  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2 Is
    Row0_ Bl_v_Transport_Note%Rowtype;
    Cur_  t_Cursor;
  Begin
    Open Cur_ For
    --SELECT T.* FROM BL_V_BL_PICKLIST T WHERE T.PICKLISTNO = ORDER_NO_;
      Select t.* From Bl_v_Transport_Note t Where t.Note_No = Order_No_;
    Fetch Cur_
      Into Row0_;
    If Cur_%Found Then
      If Row0_.State = '2' Or Row0_.State = '1' Then
        Return '0';
      End If;
      Close Cur_;
    End If;
    Close Cur_;
    Return '1';
  End;

End Bl_Transport_Notecontract_Api;
/
