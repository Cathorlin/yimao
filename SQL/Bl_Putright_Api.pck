Create Or Replace Package Bl_Putright_Api Is
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
  Function Get_Putright_Qty(Picklistno_   In Varchar2,
                            Order_No_     In Varchar2,
                            Line_No_      In Varchar2,
                            Rel_No_       In Varchar2,
                            Line_Item_No_ In Number) Return Number;
  --检测
  Procedure Checkrow(Objid_      In Varchar2,
                     Checkstate_ In Varchar2,
                     Row_        Out Bl_v_Putright%Rowtype);
  --授权 提交
  Procedure Deliver__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --授权 确认
  Procedure Approve__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --取消确认
  Procedure Cancelapprove__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2);
  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);

  Procedure Canceldeliver__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2);
  Function Get_Box_Qty(Putincase_No_ In Varchar2, Detail_Line_ In Varchar2)
    Return Number;
End Bl_Putright_Api;
/
Create Or Replace Package Body Bl_Putright_Api Is
  Type t_Cursor Is Ref Cursor;
  --【COLUMN】  列名称 按实际的逻辑 用实际的列名
  -- 【VALUE】  列的数据 按具体的实际逻辑 用对应的参数来替代
  /*
  报错
  Raise_Application_Error(pkg_a.raise_error,'出错了 ！！！！！');
  */

  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入REQUSETURL 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
    Attr_Out Varchar2(4000);
  Begin
    Attr_Out := '';
  
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
    Doaction_  Varchar2(10);
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar(4000);
    Row_       Bl_Putright_m%Rowtype;
    Mainrow_   Bl_v_Putright%Rowtype;
  Begin
  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    If Doaction_ = 'I' Then
      Bl_Customer_Order_Api.Getseqno('S' || To_Char(Sysdate, 'YYMM'),
                                     User_Id_,
                                     4,
                                     Row_.Putright_No);
      Row_.Picklistno  := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_);
      Row_.Contract    := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Row_.Remark      := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      Row_.Type_Id     := Pkg_a.Get_Item_Value('TYPE_ID', Rowlist_);
      Row_.State       := '0';
      Row_.To_Contract := Pkg_a.Get_Item_Value('TO_CONTRACT', Rowlist_);
      Row_.Enter_Date  := Sysdate;
      Row_.Enter_User  := User_Id_;
    
      If Nvl(Row_.To_Contract, '-') = '-' Then
        Raise_Application_Error(-20101, '授权域必填');
        Return;
      End If;
      --控制一个备货单授权 只能出现一次
      Open Cur_ For
        Select t.*
          From Bl_v_Putright t
         Where t.Picklistno = Row_.Picklistno
           And t.Contract = Row_.Contract
           And t.Type_Id = Row_.Type_Id
           And t.State In ('0', '1');
      Fetch Cur_
        Into Mainrow_;
      If Cur_ %Found Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                Row_.Picklistno || '-' || Row_.Contract ||
                                '存在未处理的授权，请先处理完');
        Return;
      End If;
      Close Cur_;
      Insert Into Bl_Putright_m
        (Putright_No)
      Values
        (Row_.Putright_No)
      Returning Rowid Into Objid_;
      Update Bl_Putright_m t Set Row = Row_ Where Rowid = Objid_;
    
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT', Objid_);
    End If;
    --修改
    If Doaction_ = 'M' Then
      Open Cur_ For
        Select t.* From Bl_v_Putright t Where t.Objid = Objid_;
      Fetch Cur_
        Into Mainrow_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      End If;
      Close Cur_;
    
      Data_  := Rowlist_;
      Pos_   := Instr(Data_, Index_);
      i      := i + 1;
      Mysql_ := 'update BL_PUTRIGHT_M  set  ';
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
          Mysql_ := Mysql_ || '' || Column_Id_ || '=''' || v_ || ''',';
        End If;
      End Loop;
      Mysql_ := Mysql_ || 'modi_date=sysdate,modi_user=''' || User_Id_ ||
                ''' where rowid=''' || Objid_ || '''';
    
      Execute Immediate 'begin ' || Mysql_ || ';end;';
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT', Objid_);
    End If;
    --删除
    If Doaction_ = 'D' Then
      --pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
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
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2) Is
    Attr_Out     Varchar2(4000);
    Row_         Bl_v_Putright%Rowtype;
    Mainrow_     Bl_Putright_m%Rowtype;
    Bl_Picklist_ Bl_Picklist%Rowtype;
    Cur_         t_Cursor;
  Begin
    If Column_Id_ = 'PICKLISTNO' Then
      Row_.Picklistno := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_);
      Open Cur_ For
        Select t.* From Bl_Picklist t Where t.Picklistno = Row_.Picklistno;
      Fetch Cur_
        Into Bl_Picklist_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error, '错误的备货单号');
        Return;
      End If;
      Close Cur_;
      Pkg_a.Set_Item_Value('CUSTOMER_REF',
                           Bl_Picklist_.Customerno,
                           Attr_Out);
      Pkg_a.Set_Item_Value('LOCATION', Bl_Picklist_.Location, Attr_Out);
    End If;
  
    /*      --给列赋值
    Pkg_a.Set_Item_Value('【COLUMN】', '【VALUE】', Attr_Out);
    --设置列不可用
    Pkg_a.Set_Column_Enable('【COLUMN】', '0', Attr_Out);
    --设置列可用
    Pkg_a.Set_Column_Enable('【COLUMN】', '1', Attr_Out);*/
  
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
    Mainrow_ Bl_Putright_m%Rowtype;
    Cur_     t_Cursor;
  Begin
  
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
  
    Row_     Bl_v_Putright%Rowtype;
    Mainrow_ Bl_Putright_m%Rowtype;
    Cur_     t_Cursor;
  Begin
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    If Nvl(Row_.Objid, 'NULL') = 'NULL' Then
      Return '1';
    End If;
  
    If Column_Id_ = 'REMARK' Then
      Return '1';
    Else
      Return '0';
    End If;
  
    If Column_Id_ = '【COLUMN】' Then
      Return '0';
    End If;
    Return '1';
  End;
  --获取可以授权的数量
  Function Get_Putright_Qty(Picklistno_   In Varchar2,
                            Order_No_     In Varchar2,
                            Line_No_      In Varchar2,
                            Rel_No_       In Varchar2,
                            Line_Item_No_ In Number) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    --获取已经授权的数量  
    Select Nvl(Sum(T2.Qty), 0)
      Into Result_
      From Bl_Putright_m_Detail T2
     Where T2.Picklistno = Picklistno_
       And T2.Co_Order_No = Order_No_
       And T2.Co_Line_No = Line_No_
       And T2.Co_Rel_No = Rel_No_
       And T2.Co_Line_Item_No = Line_Item_No_
       And T2.State <> '3';
    Return(Nvl(Result_, 0));
  End;
  Procedure Checkrow(Objid_      In Varchar2,
                     Checkstate_ In Varchar2,
                     Row_        Out Bl_v_Putright%Rowtype) Is
    Cur_ t_Cursor;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putright t Where t.Objid = Objid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的rowid！');
    End If;
    Close Cur_;
    If Row_.State != Checkstate_ Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '单据状态不允许执行当前操作！');
    End If;
  End;

  --授权 提交
  Procedure Deliver__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
    Cur_       t_Cursor;
    Mainrow_   Bl_v_Putright%Rowtype;
    Detailrow_ Bl_v_Putright_Detail%Rowtype;
    Pickqty_   Number; --备货单数量
    Pkgqty_    Number; --已包装数量
  Begin
    Checkrow(Rowlist_, '0', Mainrow_);
    Update Bl_Putright_m t
       Set State = '1', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Rowid = Mainrow_.Objid;
  
    --检测数量
    Open Cur_ For
      Select t.*
        From Bl_v_Putright_Detail t
       Where t.Putright_No = Mainrow_.Putright_No;
    Fetch Cur_
      Into Detailrow_;
    If Cur_%Notfound Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '没有明细行不允许执行当前操作！');
    End If;
    Loop
      Exit When Cur_%Notfound;
      --产品授权
      If Mainrow_.Type_Id = '0' Then
        --检测当前的授权是否超过可以授权的数量
        Pickqty_ := Bl_Putincase_Api.Get_Pk_Qty(Picklistno_   => Detailrow_.Picklistno,
                                                Order_No_     => Detailrow_.Co_Order_No,
                                                Line_No_      => Detailrow_.Co_Line_No,
                                                Rel_No_       => Detailrow_.Co_Rel_No,
                                                Line_Item_No_ => Detailrow_.Co_Line_Item_No,
                                                Putright_No_  => '-',
                                                Contract_     => Mainrow_.Contract);
        Pkgqty_  := Bl_Putincase_Api.Get_Pkg_Qty(Picklistno_   => Detailrow_.Picklistno,
                                                 Order_No_     => Detailrow_.Co_Order_No,
                                                 Line_No_      => Detailrow_.Co_Line_No,
                                                 Rel_No_       => Detailrow_.Co_Rel_No,
                                                 Line_Item_No_ => Detailrow_.Co_Line_Item_No,
                                                 Putright_No_  => '-',
                                                 Contract_     => Mainrow_.Contract);
        Pickqty_ := Pickqty_ - Pkgqty_;
        If Detailrow_.Qty > Pickqty_ Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '授权数量不能超过！' ||
                                  Pickqty_);
        
        End If;
      End If;
    
      --箱子授权
      If Mainrow_.Type_Id = '1' Then
        --获取可以授权的数量
        Pickqty_ := Bl_Putintray_Detail_Api.Get_Tpall_Qty(Detailrow_.Putincase_No,
                                                          Detailrow_.Putincase_Line_No,
                                                          '-');
        --检测当前的授权是否超过可以授权的数量
      
        --已打托盘的数量
        Pkgqty_  := Bl_Putintray_Detail_Api.Get_Tp_Qty(Detailrow_.Putincase_No,
                                                       Detailrow_.Putincase_Line_No,
                                                       '-');
        Pickqty_ := Pickqty_ - Pkgqty_;
        If Detailrow_.Qty > Pickqty_ Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '授权数量不能超过！' ||
                                  Pickqty_);
        
        End If;
      End If;
      Update Bl_Putright_m_Detail t
         Set State = '1', Modi_Date = Sysdate, Modi_User = User_Id_
       Where t.Rowid = Detailrow_.Objid;
      Fetch Cur_
        Into Detailrow_;
    End Loop;
    Close Cur_;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '授权提交成功');
  
    --直接确认
    Approve__(Rowlist_, User_Id_, A311_Key_);
    Return;
  End;

  --授权 确认
  Procedure Approve__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
  
    Cur_           t_Cursor;
    Cur1_          t_Cursor;
    Mainrow_       Bl_v_Putright%Rowtype;
    Detailrow_     Bl_v_Putright_Detail%Rowtype;
    Putincase_Box_ Bl_v_Putincase_Box%Rowtype;
    Pickqty_       Number; --备货单数量
    Pkgqty_        Number; --已包装数量
  Begin
    Checkrow(Rowlist_, '1', Mainrow_);
  
    --检测数量
    Open Cur_ For
      Select t.*
        From Bl_v_Putright_Detail t
       Where t.Putright_No = Mainrow_.Putright_No;
    Fetch Cur_
      Into Detailrow_;
    If Cur_%Notfound Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '没有明细行不允许执行当前操作！');
    End If;
    Loop
      Exit When Cur_%Notfound;
      If Mainrow_.Type_Id = '0' Then
        --检测当前的授权是否超过可以授权的数量
        Pickqty_ := Bl_Putincase_Api.Get_Pk_Qty(Picklistno_   => Detailrow_.Picklistno,
                                                Order_No_     => Detailrow_.Co_Order_No,
                                                Line_No_      => Detailrow_.Co_Line_No,
                                                Rel_No_       => Detailrow_.Co_Rel_No,
                                                Line_Item_No_ => Detailrow_.Co_Line_Item_No,
                                                Putright_No_  => '-',
                                                Contract_     => Mainrow_.Contract);
        Pkgqty_  := Bl_Putincase_Api.Get_Pkg_Qty(Picklistno_   => Detailrow_.Picklistno,
                                                 Order_No_     => Detailrow_.Co_Order_No,
                                                 Line_No_      => Detailrow_.Co_Line_No,
                                                 Rel_No_       => Detailrow_.Co_Rel_No,
                                                 Line_Item_No_ => Detailrow_.Co_Line_Item_No,
                                                 Putright_No_  => '-',
                                                 Contract_     => Mainrow_.Contract);
        Pickqty_ := Pickqty_ - Pkgqty_;
        If Detailrow_.Qty > Pickqty_ Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '授权数量不能超过！' ||
                                  Pickqty_);
        
        End If;
      End If;
    
      --箱子授权
      If Mainrow_.Type_Id = '1' Then
        --获取可以授权的数量
        /* Pickqty_ := Bl_Putintray_Detail_Api.Get_Tpall_Qty(Detailrow_.Putincase_No,
        Detailrow_.Putincase_Line_No,
        '-');*/
        --检测当前的授权是否超过可以授权的数量
        --把授权的箱子打上标记
      
        --未授权给其他域的箱子
        -- Pkgqty_ := 0;
        Open Cur1_ For
          Select t.*
            From Bl_v_Putincase_Box t
           Where t.Putincase_No = Detailrow_.Putincase_No
             And t.Detail_Line = Detailrow_.Putincase_Line_No
             And t.Contract = t.Tp_Contract;
        Fetch Cur1_
          Into Putincase_Box_;
        Loop
          Exit When Cur1_%Notfound Or Detailrow_.Qty <= 0;
          --更新箱子的授权域
          Update Bl_Putincase_Box t
             Set t.To_Contract   = Mainrow_.To_Contract,
                 t.Putright_No   = Detailrow_.Putright_No,
                 t.Putright_Line = Detailrow_.Line_No
           Where t.Rowid = Putincase_Box_.Objid;
          Detailrow_.Qty := Detailrow_.Qty - 1;
          Fetch Cur1_
            Into Putincase_Box_;
        End Loop;
        Close Cur1_;
      
        If Detailrow_.Qty > 0 Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '授权数量过大！');
        End If;
      
        --已打托盘的数量
        /*    Pkgqty_  := Bl_Putintray_Detail_Api.Get_Tp_Qty(Detailrow_.Putincase_No,
        Detailrow_.Putincase_Line_No,
        '-');*/
        /*   Pickqty_ := Pickqty_ - Pkgqty_;
        If Detailrow_.Qty > Pickqty_ Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '授权数量不能超过！' ||
                                  Pickqty_);
        
        End If;*/
      End If;
      Update Bl_Putright_m_Detail t
         Set State = '2', Modi_Date = Sysdate, Modi_User = User_Id_
       Where t.Rowid = Detailrow_.Objid;
      Fetch Cur_
        Into Detailrow_;
    End Loop;
    Close Cur_;
    Update Bl_Putright_m t
       Set State = '2', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Rowid = Mainrow_.Objid;
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '授权确认成功');
    Return;
  End;

  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Mainrow_ Bl_v_Putright%Rowtype;
  Begin
    Checkrow(Rowlist_, '0', Mainrow_);
    Update Bl_Putright_m t
       Set State = '3', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Rowid = Mainrow_.Objid;
  
    Update Bl_Putright_m_Detail t
       Set State = '3', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Putright_No = Mainrow_.Putright_No;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '授权作废成功');
    Return;
  End;
  --取消确认
  Procedure Cancelapprove__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2) Is
    Cur_           t_Cursor;
    Cur1_          t_Cursor;
    Mainrow_       Bl_v_Putright%Rowtype;
    Detailrow_     Bl_v_Putright_Detail%Rowtype;
    Putincase_Box_ Bl_v_Putincase_Box%Rowtype;
    Pickqty_       Number; --备货单数量
    Pkgqty_        Number; --已包装数量
  Begin
    Checkrow(Rowlist_, '2', Mainrow_);
  
    --检测数量
  
    If Mainrow_.Type_Id = '1' Then
      --判断状态是否是装箱状态 并且 没有装托盘
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase_Box t
         Where t.Putright_No = Mainrow_.Putright_No
           And (t.State Not In ('1', '2') Or t.Putintray_No <> '-');
      Fetch Cur_
        Into Putincase_Box_;
      If Cur_%Found Then
        If Putincase_Box_.State <> '2' And Putincase_Box_.State <> '1' Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  '箱号' || Putincase_Box_.Box_Num ||
                                  '不是装箱状态，不能取消授权！');
        End If;
        If Putincase_Box_.Putintray_No <> '-' Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  '箱号' || Putincase_Box_.Box_Num ||
                                  '已经打托盘了，不能取消授权！');
        End If;
      
      End If;
      Close Cur_;
    
      Update Bl_Putincase_Box t
         Set t.To_Contract   = t.Contract,
             t.Putright_No   = '-',
             t.Putright_Line = 0
       Where t.Putright_No = Mainrow_.Putright_No;
    End If;
  
    Update Bl_Putright_m t
       Set State = '1', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Rowid = Mainrow_.Objid;
  
    Update Bl_Putright_m_Detail t
       Set State = '1', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Putright_No = Mainrow_.Putright_No;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '授权取消确认成功');
    --取消提交
    Canceldeliver__(Rowlist_, User_Id_, A311_Key_);
  End;

  Procedure Canceldeliver__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2) Is
    Mainrow_ Bl_v_Putright%Rowtype;
  Begin
    Checkrow(Rowlist_, '1', Mainrow_);
    Update Bl_Putright_m t
       Set State = '0', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Rowid = Mainrow_.Objid;
  
    Update Bl_Putright_m_Detail t
       Set State = '0', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Putright_No = Mainrow_.Putright_No;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '授权退回成功');
    Return;
  End;

  Function Get_Box_Qty(Putincase_No_ In Varchar2, Detail_Line_ In Varchar2)
    Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    Select Count(*)
      Into Result_
      From Bl_Putincase_Box T2
     Where T2.Putincase_No = Putincase_No_
       And T2.Detail_Line = Detail_Line_;
    Return Result_;
  End;
End Bl_Putright_Api;
/
