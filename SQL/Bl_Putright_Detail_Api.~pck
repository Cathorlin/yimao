Create Or Replace Package Bl_Putright_Detail_Api Is
  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
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
                         Outrowlist_  Out Varchar2);
  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  Function Checkbutton__(Dotype_  In Varchar2,
                         Key_     In Varchar2,
                         User_Id_ In Varchar2) Return Varchar2;

  /*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2;

End Bl_Putright_Detail_Api;
/
Create Or Replace Package Body Bl_Putright_Detail_Api Is
  Type t_Cursor Is Ref Cursor;
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
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
    Attr_Out Varchar2(4000);
  Begin
    Attr_Out := '';
    Pkg_a.Set_Item_Value('STATE', '0', Attr_Out);
    -- pkg_a.Set_Item_Value('【COLUMN】', '【VALUE】', attr_out);
    Pkg_a.Setresult(A311_Key_, Attr_Out);
  End;

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Objid_        Varchar2(50);
    Index_        Varchar2(1);
    Cur_          t_Cursor;
    Doaction_     Varchar2(10);
    Pos_          Number;
    Pos1_         Number;
    i             Number;
    v_            Varchar(1000);
    Column_Id_    Varchar(1000);
    Data_         Varchar(4000);
    Mysql_        Varchar(4000);
    Mainrow_      Bl_v_Putright%Rowtype;
    Rowline_      Bl_v_Putright_Detail%Rowtype;
    Row_          Bl_Putright_m_Detail%Rowtype;
    Rowlinet_     Bl_v_Putright_Detail_t%Rowtype;
    If_Itemchange Varchar2(1);
  Begin
  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    If Doaction_ = 'I' Then
      Mainrow_.Putright_No    := Pkg_a.Get_Item_Value('PUTRIGHT_NO',
                                                      Rowlist_);
      Rowline_.Order_Line_Key := Pkg_a.Get_Item_Value('ORDER_LINE_KEY',
                                                      Rowlist_);
      Row_.Putright_No        := Pkg_a.Get_Item_Value('PUTRIGHT_NO',
                                                      Rowlist_);
      Row_.Picklistno         := Pkg_a.Get_Item_Value('PICKLISTNO',
                                                      Rowlist_);
      Row_.Pickuniteno        := Pkg_a.Get_Item_Value('PICKUNITENO',
                                                      Rowlist_);
      Row_.Oldorderno         := Pkg_a.Get_Item_Value('OLDORDERNO',
                                                      Rowlist_);
      Row_.Co_Order_No        := Pkg_a.Get_Item_Value('CO_ORDER_NO',
                                                      Rowlist_);
      Row_.Co_Line_No         := Pkg_a.Get_Item_Value('CO_LINE_NO',
                                                      Rowlist_);
      Row_.Co_Rel_No          := Pkg_a.Get_Item_Value('CO_REL_NO', Rowlist_);
      Row_.Co_Line_Item_No    := Pkg_a.Get_Item_Value('CO_LINE_ITEM_NO',
                                                      Rowlist_);
      Row_.Casesid            := Pkg_a.Get_Item_Value('CASESID', Rowlist_);
      Row_.State              := '0';
      Row_.Reamrk             := Pkg_a.Get_Item_Value('REAMRK', Rowlist_);
      Row_.Qty                := Pkg_a.Get_Item_Value('QTY', Rowlist_);
      Row_.Line_Key           := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
      Row_.Putincase_No       := Pkg_a.Get_Item_Value('PUTINCASE_NO',
                                                      Rowlist_);
      Row_.Putincase_Line_No  := Pkg_a.Get_Item_Value('PUTINCASE_LINE_NO',
                                                      Rowlist_);
      Row_.Enter_Date         := Sysdate;
      Row_.Enter_User         := User_Id_;
      Open Cur_ For
        Select t.*
          From Bl_v_Putright t
         Where t.Putright_No = Mainrow_.Putright_No;
      Fetch Cur_
        Into Mainrow_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的授权号');
        Return;
      End If;
      Close Cur_;
      If Mainrow_.Type_Id = '0' Then
        If Nvl(Row_.Qty, 0) <= 0 Then
          Raise_Application_Error(-20101, '请输入正确的数量');
          Return;
        End If;
        If Nvl(Rowline_.Order_Line_Key, '-') = '-' Then
          Raise_Application_Error(-20101, '订单行必填');
          Return;
        End If;
        Open Cur_ For
          Select 1
            From Bl_Putright_m_Detail t
           Where t.Line_Key = Row_.Line_Key
             And t.State In ('0', '1');
        Fetch Cur_
          Into i;
        If Cur_ %Found Then
          Close Cur_;
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Row_.Line_Key || '不能重复授权');
          Return;
        End If;
        Close Cur_;
      End If;
      If Mainrow_.Type_Id = '1' Then
        If Nvl(Row_.Qty, 0) <= 0 Then
          Raise_Application_Error(Pkg_a.Raise_Error, '请输入正确的数量');
          Return;
        End If;
        If Nvl(Row_.Line_Key, '-') = '-' Then
          Raise_Application_Error(Pkg_a.Raise_Error, '请选择关键字');
          Return;
        End If;
        Open Cur_ For
          Select 1
            From Bl_Putright_m_Detail t
           Where t.Line_Key = Row_.Line_Key
             And t.State In ('0', '1');
        Fetch Cur_
          Into i;
        If Cur_ %Found Then
          Close Cur_;
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Row_.Line_Key || '不能重复授权');
          Return;
        End If;
        Close Cur_;
      End If;
      --取行号
      Select Max(Line_No)
        Into Row_.Line_No
        From Bl_Putright_m_Detail t
       Where t.Putright_No = Row_.Putright_No;
      Row_.Line_No := Nvl(Row_.Line_No, 0) + 1;
    
      Insert Into Bl_Putright_m_Detail
        (Putright_No, Line_No)
      Values
        (Row_.Putright_No, Row_.Line_No)
      Returning Rowid Into Objid_;
    
      Update Bl_Putright_m_Detail t Set Row = Row_ Where t.Rowid = Objid_;
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT_DETAIL', Objid_);
    End If;
    --修改
    If Doaction_ = 'M' Then
      Open Cur_ For
        Select t.* From Bl_Putright_m_Detail t Where t.Rowid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      End If;
      Close Cur_;
      If_Itemchange := '0';
      Data_         := Rowlist_;
      Pos_          := Instr(Data_, Index_);
      i             := i + 1;
      Mysql_        := 'update Bl_Putright_m_Detail  set  ';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        v_         := Substr(v_, Pos1_ + 1);
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' Then
          If_Itemchange := '1';
          Mysql_        := Mysql_ || '' || Column_Id_ || '=''' || v_ ||
                           ''',';
        End If;
      End Loop;
      If If_Itemchange = '1' Then
        Mysql_ := Mysql_ || 'modi_date=sysdate,modi_user=''' || User_Id_ ||
                  ''' where rowid=''' || Objid_ || '''';
      
        Execute Immediate 'begin ' || Mysql_ || ';end;';
      End If;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT_DETAIL', Objid_);
    End If;
    --删除
    If Doaction_ = 'D' Then
      Open Cur_ For
        Select t.* From Bl_Putright_m_Detail t Where t.Rowid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      End If;
      Close Cur_;
      Delete From Bl_Putright_m_Detail t Where t.Rowid = Objid_;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT_DETAIL', Objid_);
    End If;
  
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
    Attr_Out Varchar2(4000);
    Pickrow_ Bl_v_Putincase_V01%Rowtype;
    Linerow_ Bl_v_Putright_Detail%Rowtype;
    Mainrow_ Bl_v_Putright%Rowtype;
    Row_     Bl_Putright_m_Detail%Rowtype;
    Carow_   Bl_v_Putincase_V03%Rowtype;
    Cur_     t_Cursor;
  
  Begin
  
    If Column_Id_ = 'ORDER_LINE_KEY' Then
      Mainrow_.Picklistno     := Pkg_a.Get_Item_Value('PICKLISTNO',
                                                      Mainrowlist_);
      Mainrow_.Contract       := Pkg_a.Get_Item_Value('CONTRACT',
                                                      Mainrowlist_);
      Linerow_.Order_Line_Key := Pkg_a.Get_Item_Value('ORDER_LINE_KEY',
                                                      Rowlist_);
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase_V01 t
         Where t.Pickuniteno = Mainrow_.Picklistno
           And t.Supplier = Mainrow_.Contract
           And t.To_Contract = Mainrow_.Contract
           And t.Line_Key = Linerow_.Order_Line_Key;
      Fetch Cur_
        Into Pickrow_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(Pkg_a.Raise_Error, '错误的备货单行');
        Return;
      End If;
      Close Cur_;
      /*  
      Select t.Picklistno
        Into Row_.Picklistno
        From Bl_Pldtl_V01 t
       Where t.Pickuniteno = Mainrow_.Picklistno
         And t.Order_No = Pickrow_.Order_No
         And t.Line_No = Pickrow_.Line_No
         And t.Rel_No = Pickrow_.Rel_No
         And t.Line_Item_No = Pickrow_.Line_Item_No;*/
    
      Linerow_.Blorder_No := Bl_Customer_Order_Api.Get_Column_Data('BLORDER_NO',
                                                                   Pickrow_.Order_No);
      Pkg_a.Set_Item_Value('BLORDER_NO', Linerow_.Blorder_No, Attr_Out);
    
      Pkg_a.Set_Item_Value('PICKLISTNO', Pickrow_.Picklistno, Attr_Out);
      Pkg_a.Set_Item_Value('PICKUNITENO', Mainrow_.Picklistno, Attr_Out);
    
      Pkg_a.Set_Item_Value('CO_ORDER_NO', Pickrow_.Order_No, Attr_Out);
      Pkg_a.Set_Item_Value('CO_LINE_NO', Pickrow_.Line_No, Attr_Out);
      Pkg_a.Set_Item_Value('CO_REL_NO', Pickrow_.Rel_No, Attr_Out);
      Pkg_a.Set_Item_Value('CO_LINE_ITEM_NO',
                           Pickrow_.Line_Item_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_PART_NO',
                           Pickrow_.Customer_Part_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('LINE_KEY', Linerow_.Order_Line_Key, Attr_Out);
      Pkg_a.Set_Item_Value('CATALOG_NO', Pickrow_.Catalog_No, Attr_Out);
      Pkg_a.Set_Item_Value('CATALOG_DESC', Pickrow_.Catalog_Desc, Attr_Out);
      Pkg_a.Set_Item_Value('QTY',
                           Pickrow_.Pickqty - Pickrow_.Qty,
                           Attr_Out);
      /*      --给列赋值
      Pkg_a.Set_Item_Value('【COLUMN】', '【VALUE】', Attr_Out);
      --设置列不可用
      Pkg_a.Set_Column_Enable('【COLUMN】', '0', Attr_Out);
      --设置列可用
      Pkg_a.Set_Column_Enable('【COLUMN】', '1', Attr_Out);*/
    End If;
    If Column_Id_ = 'LINE_KEY' Then
      Mainrow_.Picklistno := Pkg_a.Get_Item_Value('PICKLISTNO',
                                                  Mainrowlist_);
      Mainrow_.Contract   := Pkg_a.Get_Item_Value('CONTRACT', Mainrowlist_);
      Linerow_.Line_Key   := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase_V03 t
         Where t.Picklistno = Mainrow_.Picklistno
           And t.Supplier = Mainrow_.Contract
           And t.To_Contract = Mainrow_.Contract
           And t.Line_Key = Linerow_.Line_Key;
      Fetch Cur_
        Into Carow_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的箱子号');
        Return;
      End If;
      Close Cur_;
      Pkg_a.Set_Item_Value('PICKLISTNO', Carow_.Picklistno, Attr_Out);
      Pkg_a.Set_Item_Value('PUTINCASE_NO', Carow_.Putincase_No, Attr_Out);
      Pkg_a.Set_Item_Value('PUTINCASE_LINE_NO', Carow_.Line_No, Attr_Out);
      Pkg_a.Set_Item_Value('QTY', Carow_.Box_Qty - Carow_.Tp_Qty, Attr_Out);
      Pkg_a.Set_Item_Value('CATALOG_NO', Carow_.Catalog_No, Attr_Out);
      Pkg_a.Set_Item_Value('CATALOG_DESC', Carow_.Catalog_Desc, Attr_Out);
    
      Pkg_a.Set_Item_Value('CASESID', Linerow_.Line_Key, Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_PART_NO',
                           Carow_.Customer_Part_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PACK_FLAG', Carow_.Pack_Flag, Attr_Out);
      Pkg_a.Set_Item_Value('PACK_FLAG_NAME',
                           Carow_.Pack_Flag_Name,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CASINGID', Carow_.Casingid, Attr_Out);
      Pkg_a.Set_Item_Value('CASINGDESCRIBE',
                           Carow_.Casingdescribe,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CASINGWEIGHT', Carow_.Casingweight, Attr_Out);
      Pkg_a.Set_Item_Value('CASINGLENGTH', Carow_.Casinglength, Attr_Out);
      Pkg_a.Set_Item_Value('CASINGWIDTH', Carow_.Casingwidth, Attr_Out);
      Pkg_a.Set_Item_Value('CASINGHEIGHT', Carow_.Casingheight, Attr_Out);
      Pkg_a.Set_Item_Value('PARTWEIGHT', Carow_.Partweight, Attr_Out);
      Pkg_a.Set_Item_Value('CASINGAREA', Carow_.Casingarea, Attr_Out);
      Pkg_a.Set_Item_Value('QTY_PKG', Carow_.Qty_Pkg, Attr_Out);
    End If;
    Outrowlist_ := Attr_Out;
  End;
  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  Function Checkbutton__(Dotype_  In Varchar2,
                         Key_     In Varchar2,
                         User_Id_ In Varchar2) Return Varchar2 Is
    Cur_     t_Cursor;
    Mainrow_ Bl_Putright_m %Rowtype;
  Begin
  
    --获取状态字  
    Open Cur_ For
      Select t.* From Bl_Putright_m t Where t.Putright_No = Key_;
    Fetch Cur_
      Into Mainrow_;
    If Mainrow_.State <> '0' Then
    
      Return '0';
    End If;
    If Dotype_ = 'ADD_ROW' Then
      Return '1';
    
    End If;
    If Dotype_ = 'DEL_ROW' Then
      Return '1';
    
    End If;
    Return '1';
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
    Mainrow_ Bl_v_Putright%Rowtype;
    Linerow_ Bl_v_Putright_Detail%Rowtype;
    Cur_     t_Cursor;
  Begin
    Linerow_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    --Mainrow_.Putright_No := Pkg_a.Get_Item_Value('PUTRIGHT_NO', Rowlist_);
    If Nvl(Linerow_.Objid, 'NULL') = 'NULL' Then
      Return '1';
    End If;
    Linerow_.State := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    If Column_Id_ = 'REAMRK' Then
      If Linerow_.State = '1' Or Linerow_.State = '0' Then
        Return '1';
      End If;
    End If;
    If Column_Id_ = 'QTY' Then
      If Linerow_.State = '0' Then
        Return '1';
      End If;
    End If;
    If Linerow_.State <> '0' Then
      Return '0';
    End If;
    Return '0';
  End;

End Bl_Putright_Detail_Api;
/
