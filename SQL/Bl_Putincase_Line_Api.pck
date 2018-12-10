Create Or Replace Package Bl_Putincase_Line_Api Is
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
  Procedure Inbox__(Rowlist_  Varchar2,
                    User_Id_  Varchar2,
                    A311_Key_ Varchar2);
End Bl_Putincase_Line_Api;
/
Create Or Replace Package Body Bl_Putincase_Line_Api Is
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
    Cur_     t_Cursor;
    Row_     Bl_v_Putincase_m_Detail%Rowtype;
    Mainrow_ Bl_v_Putincase%Rowtype;
  Begin
    Attr_Out          := '';
    Row_.Putincase_No := Pkg_a.Get_Item_Value('PUTINCASE_NO', Rowlist_);
    If Row_.Putincase_No = '' Or Row_.Putincase_No Is Null Then
      Return;
    End If;
    Open Cur_ For
      Select t.*
        From Bl_v_Putincase t
       Where t.Putincase_No = Row_.Putincase_No;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
  
    If Mainrow_.Pack_Flag = '0' Then
      Pkg_a.Set_Item_Value('QTY_PEC', 1, Attr_Out);
    End If;
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
    Objid_     Varchar2(50);
    Index_     Varchar2(1);
    Cur_       t_Cursor;
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar(4000);
    Doaction_  Varchar2(10);
    Linerow_   Bl_v_Putincase_m_Detail%Rowtype;
    Linerow0_  Bl_v_Putincase_m_Detail%Rowtype;
    Row_       Bl_Putincase_m_Detail%Rowtype;
    Row__      Bl_Putincase_m_Detail%Rowtype;
    Blrowv02_  Bl_v_Customer_Order_V02%Rowtype;
    Mainrow_   Bl_v_Putincase%Rowtype;
    Blsetrow_  Bl_v_Pachage_Set_Tab%Rowtype;
    Qty_Total_ Number;
  
  Begin
  
    Index_            := f_Get_Data_Index();
    Objid_            := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_         := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    Row_.Putincase_No := Pkg_a.Get_Item_Value('PUTINCASE_NO', Rowlist_);
    If Row_.Putincase_No = '' Or Row_.Putincase_No Is Null Then
      Open Cur_ For
        Select t.* From Bl_v_Putincase_m_Detail t Where t.Objid = Objid_;
      Fetch Cur_
        Into Linerow0_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的ROWID');
        Return;
      End If;
      Close Cur_;
      Row_.Putincase_No := Linerow0_.Putincase_No;
    End If;
    --默认包装数量
    Open Cur_ For
      Select t.*
        From Bl_v_Putincase t
       Where t.Putincase_No = Row_.Putincase_No;
    Fetch Cur_
      Into Mainrow_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的包装编码');
      Return;
    End If;
    Close Cur_;
    --新增
    If Doaction_ = 'I' Then
    
      Row_.Enter_Date      := Sysdate;
      Row_.Enter_User      := User_Id_;
      Row_.State           := '0';
      Linerow_.Catalog_No  := Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_);
      Row_.Remark          := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      Row_.Picklistno      := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_);
      Row_.Co_Order_No     := Pkg_a.Get_Item_Value('CO_ORDER_NO', Rowlist_);
      Row_.Co_Line_No      := Pkg_a.Get_Item_Value('CO_LINE_NO', Rowlist_);
      Row_.Co_Rel_No       := Pkg_a.Get_Item_Value('CO_REL_NO', Rowlist_);
      Row_.Co_Line_Item_No := Pkg_a.Get_Item_Value('CO_LINE_ITEM_NO',
                                                   Rowlist_);
      Row_.Qty_Pec         := Pkg_a.Get_Item_Value('QTY_PEC', Rowlist_);
      Row_.Qty             := Pkg_a.Get_Item_Value('QTY', Rowlist_);
      Row_.f_Order_No      := Pkg_a.Get_Item_Value('F_ORDER_NO', Rowlist_);
      Row_.f_Line_No       := Pkg_a.Get_Item_Value('F_LINE_NO', Rowlist_);
      Row_.f_Rel_No        := Pkg_a.Get_Item_Value('F_REL_NO', Rowlist_);
      Row_.f_Line_Item_No  := Pkg_a.Get_Item_Value('F_LINE_ITEM_NO',
                                                   Rowlist_);
      Row_.Pkg_Contract    := Pkg_a.Get_Item_Value('PKG_CONTRACT', Rowlist_);
      Row_.Putright_No     := Pkg_a.Get_Item_Value('PUTRIGHT_NO', Rowlist_);
    
      Row_.Pickuniteno := Pkg_a.Get_Item_Value('PICKUNITENO', Rowlist_);
    
      Open Cur_ For
        Select t.*
          From Bl_v_Customer_Order_V02 t
         Where t.Order_No = Row_.f_Order_No
           And t.Line_No = Row_.f_Line_No
           And t.Rel_No = Row_.f_Rel_No
           And t.Line_Item_No = Row_.f_Line_Item_No;
      Fetch Cur_
        Into Blrowv02_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的对应关系');
        Return;
      End If;
      Close Cur_;
      Row_.Po_Order_No             := Blrowv02_.Po_Order_No;
      Row_.Po_Line_No              := Blrowv02_.Po_Line_No;
      Row_.Po_Release_No           := Blrowv02_.Po_Release_No;
      Row_.Demand_Order_No         := Blrowv02_.Demand_Order_No;
      Row_.Demand_Rel_No           := Blrowv02_.Demand_Rel_No;
      Row_.Demand_Line_No          := Blrowv02_.Demand_Line_No;
      Row_.Demand_Line_Item_No     := Blrowv02_.Demand_Line_Item_No;
      Row_.Par_Po_Order_No         := Blrowv02_.Par_Po_Order_No;
      Row_.Par_Po_Line_No          := Blrowv02_.Par_Po_Line_No;
      Row_.Par_Po_Release_No       := Blrowv02_.Par_Po_Release_No;
      Row_.Par_Demand_Order_No     := Blrowv02_.Par_Demand_Order_No;
      Row_.Par_Demand_Rel_No       := Blrowv02_.Par_Demand_Rel_No;
      Row_.Par_Demand_Line_No      := Blrowv02_.Par_Demand_Line_No;
      Row_.Par_Demand_Line_Item_No := Blrowv02_.Par_Demand_Line_Item_No;
    
      If Mainrow_.Pack_Flag = '0' Then
        --默认包装
      
        Open Cur_ For
          Select t.*
            From Bl_v_Pachage_Set_Tab t
           Where t.Catalog_No = Linerow_.Catalog_No;
        Fetch Cur_
          Into Blsetrow_;
        If Cur_ %Notfound Then
          Close Cur_;
          Raise_Application_Error(-20101, '产品包装物料表无此料号');
          Return;
        End If;
        Close Cur_;
        --包装编码
        Row_.Pachage_No := Blsetrow_.Pachage_No;
        Row_.Qty_Pkg    := Blsetrow_.Qty; --每箱数量
      Else
        -- 混合包装
        Row_.Pachage_No := '';
        Row_.Qty_Pkg    := 0;
      End If;
    
      Select Max(Line_No)
        Into Row_.Line_No
        From Bl_Putincase_m_Detail t
       Where t.Putincase_No = Row_.Putincase_No;
    
      Row_.Line_No := Nvl(Row_.Line_No, 0) + 1;
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase_m_Detail t
         Where t.Putincase_No = Row_.Putincase_No
           And t.Co_Order_No = Row_.Co_Order_No
           And t.Co_Line_No = Row_.Co_Line_No
           And t.Co_Rel_No = Row_.Co_Rel_No
           And t.Co_Line_Item_No = Row_.Co_Line_Item_No;
      Fetch Cur_
        Into Linerow0_;
      If Cur_ %Found Then
        Close Cur_;
        Raise_Application_Error(-20101, '重复的工厂订单');
        Return;
      End If;
      Close Cur_;
      Insert Into Bl_Putincase_m_Detail
        (Putincase_No, Line_No)
      Values
        (Row_.Putincase_No, Row_.Line_No)
      Returning Rowid Into Objid_;
    
      Update Bl_Putincase_m_Detail Set Row = Row_ Where Rowid = Objid_;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE_M_DETAIL', Objid_);
    End If;
    --修改
    If Doaction_ = 'M' Then
      Open Cur_ For
        Select t.* From Bl_v_Putincase_m_Detail t Where t.Objid = Objid_;
      Fetch Cur_
        Into Linerow_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      End If;
      Close Cur_;
      Data_  := Rowlist_;
      Pos_   := Instr(Data_, Index_);
      i      := i + 1;
      Mysql_ := 'update BL_PUTINCASE_M_DETAIL  set  ';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 3000;
        v_         := Substr(Data_, 1, Pos_ - 1); --列名
        Data_      := Substr(Data_, Pos_ + 1); --剩下的字符串
        Pos_       := Instr(Data_, Index_); --取 char(30)
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        v_         := Substr(v_, Pos1_ + 1);
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' And
           Column_Id_ <> 'CATALOG_DESC' And Column_Id_ <> 'CATALOG_NO' And
           Column_Id_ <> 'QTY_UNPKG' And Column_Id_ <> 'PICKQTY' And
           Column_Id_ <> 'CUSTOMER_PART_NO' And
           Column_Id_ <> 'F_ORDER_LINE_KEY' And
           Column_Id_ <> 'ORDER_LINE_KEY' Then
          Mysql_ := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
        End If;
      End Loop;
    
      Mysql_ := Mysql_ || 'modi_date=sysdate,modi_user=''' || User_Id_ ||
                ''' where rowid=''' || Objid_ || '''';
    
      Execute Immediate 'begin ' || Mysql_ || ';end;';
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE_M_DETAIL', Objid_);
    End If;
    --删除
    If Doaction_ = 'D' Then
      Open Cur_ For
        Select t.* From Bl_v_Putincase_m_Detail t Where t.Objid = Objid_;
      Fetch Cur_
        Into Linerow_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      End If;
      Close Cur_;
      Delete From Bl_Putincase_m_Detail t Where t.Rowid = Objid_;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE_M_DETAIL', Objid_);
    End If;
  
    If Mainrow_.Pack_Flag = '1' Then
      Select Sum(Qty_Pec)
        Into Qty_Total_
        From Bl_Putincase_m_Detail t
       Where t.Putincase_No = Row_.Putincase_No;
    
      If Qty_Total_ > 0 Then
        Update Bl_Putincase_m_Detail t
           Set t.Qty_Pkg = Round(Mainrow_.Box_Qty * t.Qty_Pec / Qty_Total_,
                                 4)
         Where t.Putincase_No = Row_.Putincase_No;
      End If;
    
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
    Attr_Out      Varchar2(4000);
    Cur_          t_Cursor;
    Row_          Bl_v_Putincase_m_Detail%Rowtype;
    Rowv01_       Bl_v_Putincase_V01%Rowtype;
    Mainrow_      Bl_v_Putincase%Rowtype;
    Coline_Row_   Bl_v_Customer_Order_Line%Rowtype;
    Qty_          Number; --已经包装数量
    Bl_Picklist_  Bl_v_Pldtl_Putincase%Rowtype;
    Pachage_Main_ Bl_Pachage_Set_Tab%Rowtype;
  
  Begin
    Mainrow_.Box_Qty    := Pkg_a.Get_Item_Value('BOX_QTY', Mainrowlist_);
    Mainrow_.Pack_Flag  := Pkg_a.Get_Item_Value('PACK_FLAG', Mainrowlist_);
    Mainrow_.Picklistno := Pkg_a.Get_Item_Value('PICKLISTNO', Mainrowlist_);
    Mainrow_.Supplier   := Pkg_a.Get_Item_Value('SUPPLIER', Mainrowlist_);
    If Column_Id_ = 'ORDER_LINE_KEY' Then
      Row_.Order_Line_Key := Pkg_a.Get_Item_Value('ORDER_LINE_KEY',
                                                  Rowlist_);
    
      Bl_Customer_Order_Line_Api.Get_Record_By_Line_Key(Row_.Order_Line_Key,
                                                        Coline_Row_);
      Row_.Pickuniteno := Mainrow_.Picklistno;
      Select t.Picklistno
        Into Row_.Picklistno
        From Bl_Pldtl_V01 t
       Where t.Pickuniteno = Mainrow_.Picklistno
         And t.Order_No = Coline_Row_.Order_No
         And t.Line_No = Coline_Row_.Line_No
         And t.Rel_No = Coline_Row_.Rel_No
         And t.Line_Item_No = Coline_Row_.Line_Item_No;
    
      Row_.Co_Order_No      := Coline_Row_.Order_No;
      Row_.Co_Line_No       := Coline_Row_.Line_No;
      Row_.Co_Rel_No        := Coline_Row_.Rel_No;
      Row_.Co_Line_Item_No  := Coline_Row_.Line_Item_No;
      Row_.Catalog_No       := Coline_Row_.Catalog_No;
      Row_.Catalog_Desc     := Coline_Row_.Catalog_Desc;
      Row_.Customer_Part_No := Coline_Row_.Customer_Part_No;
      Row_.f_Order_Line_Key := Bl_Customer_Order_Line_Api.Get_Factory_Order_(Row_.Co_Order_No,
                                                                             Row_.Co_Line_No,
                                                                             Row_.Co_Rel_No,
                                                                             Row_.Co_Line_Item_No);
    
      Bl_Customer_Order_Line_Api.Get_Record_By_Line_Key(Row_.f_Order_Line_Key,
                                                        Coline_Row_);
    
      Row_.Pkg_Contract   := Coline_Row_.Contract;
      Row_.f_Order_No     := Coline_Row_.Order_No;
      Row_.f_Line_No      := Coline_Row_.Line_No;
      Row_.f_Rel_No       := Coline_Row_.Rel_No;
      Row_.f_Line_Item_No := Coline_Row_.Line_Item_No;
    
      If Mainrow_.Pack_Flag = '0' Then
        --获取产品的包装编码
        Open Cur_ For
          Select t.*
            From Bl_v_Pldtl_Putincase t
           Where t.Picklistno = Mainrow_.Picklistno;
        Fetch Cur_
          Into Bl_Picklist_;
        Close Cur_;
      
        Bl_Putincase_Api.Get_Pachage(Row_.Catalog_No,
                                     Bl_Picklist_.Contract,
                                     Bl_Picklist_.Customer_Ref,
                                     Row_.Pkg_Contract,
                                     Pachage_Main_);
      
        Row_.Pachage_No := Pachage_Main_.Pachage_No;
        Row_.Qty_Pkg    := Pachage_Main_.Qty;
        Pkg_a.Set_Item_Value('PACHAGE_NO', Row_.Pachage_No, Attr_Out);
        Pkg_a.Set_Item_Value('QTY_PKG', Row_.Qty_Pkg, Attr_Out);
      Else
        Row_.Pachage_No := '';
        Row_.Qty_Pkg    := 0;
      End If;
      --获取装箱域 和 
      If Row_.Pkg_Contract = Mainrow_.Supplier Then
        Row_.Putright_No := Null;
      Else
        Open Cur_ For
          Select t.Putright_No
            From Bl_Putright_m_Detail_V01 t
           Where t.Picklistno = Row_.Picklistno
             And t.Co_Order_No = Row_.Co_Order_No
             And t.Co_Line_No = Row_.Co_Line_No
             And t.Co_Rel_No = Row_.Co_Rel_No
             And t.Co_Line_Item_No = Row_.Co_Line_Item_No
             And t.To_Contract = Mainrow_.Supplier
             And t.Contract = Row_.Pkg_Contract;
        Fetch Cur_
          Into Row_.Putright_No;
        If Cur_%Notfound Then
          Raise_Application_Error(-20101, '错误的订单行');
          Return;
        End If;
        Close Cur_;
      End If;
    
      Row_.Pickqty := Bl_Putincase_Api.Get_Pk_Qty(Row_.Picklistno,
                                                  Row_.Co_Order_No,
                                                  Row_.Co_Line_No,
                                                  Row_.Co_Rel_No,
                                                  Row_.Co_Line_Item_No,
                                                  Row_.Putright_No,
                                                  Mainrow_.Supplier);
      --已经包装数量
      Qty_ := Bl_Putincase_Api.Get_Pkg_Qty(Row_.Picklistno,
                                           Row_.Co_Order_No,
                                           Row_.Co_Line_No,
                                           Row_.Co_Rel_No,
                                           Row_.Co_Line_Item_No,
                                           Row_.Putright_No,
                                           Mainrow_.Supplier);
    
      Pkg_a.Set_Item_Value('PICKQTY', Row_.Pickqty, Attr_Out);
      Pkg_a.Set_Item_Value('CATALOG_NO', Row_.Catalog_No, Attr_Out);
      Pkg_a.Set_Item_Value('PICKLISTNO', Row_.Picklistno, Attr_Out);
      Pkg_a.Set_Item_Value('PICKUNITENO', Row_.Pickuniteno, Attr_Out);
      Pkg_a.Set_Item_Value('CATALOG_DESC', Row_.Catalog_Desc, Attr_Out);
      Pkg_a.Set_Item_Value('PUTRIGHT_NO', Row_.Putright_No, Attr_Out);
      Pkg_a.Set_Item_Value('QTY_UNPKG', Row_.Pickqty - Qty_, Attr_Out);
      Pkg_a.Set_Item_Value('QTY', Row_.Pickqty - Qty_, Attr_Out);
      Pkg_a.Set_Item_Value('QTY_PEC', Row_.Pickqty - Qty_, Attr_Out);
      Pkg_a.Set_Item_Value('CO_ORDER_NO', Row_.Co_Order_No, Attr_Out);
      Pkg_a.Set_Item_Value('CO_LINE_NO', Row_.Co_Line_No, Attr_Out);
      Pkg_a.Set_Item_Value('CO_REL_NO', Row_.Co_Rel_No, Attr_Out);
      Pkg_a.Set_Item_Value('CO_LINE_ITEM_NO',
                           Row_.Co_Line_Item_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('F_ORDER_NO', Row_.f_Order_No, Attr_Out);
      Pkg_a.Set_Item_Value('F_LINE_NO', Row_.f_Line_No, Attr_Out);
      Pkg_a.Set_Item_Value('F_REL_NO', Row_.f_Rel_No, Attr_Out);
      Pkg_a.Set_Item_Value('F_LINE_ITEM_NO', Row_.f_Line_Item_No, Attr_Out);
    
      Pkg_a.Set_Item_Value('F_ORDER_LINE_KEY',
                           Row_.f_Order_Line_Key,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PKG_CONTRACT', Row_.Pkg_Contract, Attr_Out);
      Pkg_a.Set_Item_Value('ORDER_LINE_NO', Row_.Order_Line_Key, Attr_Out);
    
    End If;
    If Column_Id_ = 'QTY' Then
      Row_.Qty := Pkg_a.Get_Item_Value('QTY', Rowlist_);
      Pkg_a.Set_Item_Value('QTY_PEC', Row_.Qty, Attr_Out);
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
    Mainrow_ Bl_v_Putincase%Rowtype;
    Cur_     t_Cursor;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Putincase_No = Key_;
    Fetch Cur_
      Into Mainrow_;
    Close Cur_;
    --只有新增状态才能添加行
    If Mainrow_.State != '0' Then
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
    Cur_     t_Cursor;
    Row_     Bl_v_Putincase_m_Detail%Rowtype;
    Mainrow_ Bl_v_Putincase%Rowtype;
  Begin
    Row_.Objid        := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Row_.Putincase_No := Pkg_a.Get_Item_Value('PUTINCASE_NO', Rowlist_);
    /*    If Nvl(Row_.Objid, 'NULL') = 'NULL' Then
      Return '1';
    End If;*/
    Row_.State := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    If Nvl(Row_.State, '0') <> '0' Then
    
      Return '0';
    End If;
  
    If Column_Id_ = 'ORDER_LINE_KEY' Then
      /*      IF Column_Id_ = 'QTY_PEC' THEN
        OPEN CUR_ FOR
          SELECT T.*
            FROM Bl_v_Putincase T
           WHERE T.PUTINCASE_NO = ROW_.PUTINCASE_NO;
        FETCH CUR_
          INTO MAINROW_;
        If Cur_ %Notfound Then
          Close Cur_;
          Raise_Application_Error(-20101, '错误的包装编号');
          Return '0';
        End If;
        CLOSE CUR_;
        if MAINROW_.pack_flag = '0' THEN
          RETURN '0';
        ELSE
          RETURN '1';
        END IF;
      END IF;*/
      If Nvl(Row_.Objid, 'NULL') = 'NULL' Then
        Return '1';
      Else
        Return '0';
      End If;
    End If;
  End;

  Procedure Inbox__(Rowlist_  Varchar2,
                    User_Id_  Varchar2,
                    A311_Key_ Varchar2) Is
    Mainrow_ Bl_v_Putincase%Rowtype;
    Cur_     t_Cursor;
  Begin
    Mainrow_.Objid := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Mainrow_.Objid;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
  
  End;
End Bl_Putincase_Line_Api;
/
