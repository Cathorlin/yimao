Create Or Replace Package Bl_Putintray_Api Is

  /*Created By ZHH  2012-12-11 11:25:52*/
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

  --控制表头的备货单的选择
  Function Check_Picklist_Exists(Picklistno_ In Varchar2,
                                 Contract_   In Varchar2) Return Number;
  --打托盘
  Procedure Release__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --生成包装资料
  Procedure Create_Pick__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);
  --生成包装资料
  Procedure Set_Pick___(Picklistno_ In Varchar2,
                        Contract_   In Varchar2,
                        User_Id_    In Varchar2);
  --提交
  Procedure Appvoe__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  --提交 
  Procedure Appvoe___(Picklistno_ In Varchar2,
                      Contract_   In Varchar2,
                      User_Id_    In Varchar2);
  --单个托盘拆除
  Procedure Modi_Box__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  Procedure Modi_Allbox__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);
  --取消提交
  Procedure Cancelappvoe__(Rowlist_  Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2);
  --取消提交
  Procedure Cancelappvoe___(Picklistno_ In Varchar2,
                            Contract_   In Varchar2,
                            User_Id_    In Varchar2);
  Function Get_Putintray_Des(Putintray_No_ In Varchar2) Return Varchar2;

  ---取消托盘
  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
End Bl_Putintray_Api;
/
Create Or Replace Package Body Bl_Putintray_Api Is

  /*Created By ZHH  2012-12-11 11:25:52*/

  /*Created By ZHH  2012-12-11 11:25:52*/

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
    Attr_Out    Varchar2(4000);
    Row_        Bl_v_Putintray_m%Rowtype;
    Requesturl_ Varchar2(4000);
  Begin
    Attr_Out := '';
  
    Requesturl_ := Pkg_a.Get_Item_Value('REQUESTURL', Rowlist_);
  
    If Nvl(Requesturl_, 'NULL') <> 'NULL' Then
      Row_.Contract   := Pkg_a.Get_Item_Value_By_Index('&SUPPLIER=',
                                                       '&',
                                                       Requesturl_);
      Row_.Picklistno := Pkg_a.Get_Item_Value_By_Index('&PICKLISTNO=',
                                                       '&',
                                                       Requesturl_);
      Pkg_a.Set_Item_Value('PICKLISTNO', Row_.Picklistno, Attr_Out);
      If Nvl(Row_.Contract, '-') = '-' Then
        Row_.Contract := Pkg_Attr.Get_Default_Contract(User_Id_);
      End If;
    Else
      Row_.Contract := Pkg_Attr.Get_Default_Contract(User_Id_);
    
    End If;
  
    Row_.State := '0';
    Pkg_a.Set_Item_Value('STATE', Row_.State, Attr_Out);
    Pkg_a.Set_Item_Value('CONTRACT', Row_.Contract, Attr_Out);
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
    Row_       Bl_v_Putintray_m%Rowtype;
    Irow_      Bl_Putintray_m%Rowtype;
    Crow_      Bl_Putintray_m%Rowtype;
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar(4000);
    Ifmychange Varchar(1);
  Begin
  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    If Doaction_ = 'I' Then
      -- 生成托盘编码
    
      Irow_.Picklistno := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_);
      Irow_.Contract   := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      --检测当前备货单相同域是否存在 未处理的表头
      Open Cur_ For
        Select t.*
          From Bl_Putintray_m t
         Where t.Picklistno = Irow_.Picklistno
           And t.Contract = Irow_.Contract
           And t.State = '0';
      Fetch Cur_
        Into Crow_;
      If Cur_%Found Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '备货单' || Row_.Picklistno || '存在一份未处理的托盘信息' ||
                                Crow_.Putintray_No || '，不能处理！');
      
      End If;
      Close Cur_;
    
      --2位年号+6位客户号+4位流水号? 例如129901550001  BL 订单号
    
      Bl_Customer_Order_Api.Getseqno('T' || To_Char(Sysdate, 'YYMM'),
                                     User_Id_,
                                     4,
                                     Irow_.Putintray_No);
      Irow_.Traytype     := Pkg_a.Get_Item_Value('TRAYTYPE', Rowlist_);
      Irow_.Traytypename := Pkg_a.Get_Item_Value('TRAYTYPENAME', Rowlist_);
      Irow_.Trayspace    := Pkg_a.Get_Item_Value('TRAYSPACE', Rowlist_);
      Select Max(Traynum)
        Into Irow_.Traynum
        From Bl_Putintray_m t
       Where t.Picklistno = Irow_.Picklistno;
    
      Irow_.Traynum := Nvl(Irow_.Traynum, 0) + 1;
    
      Irow_.Trayid  := 'TX' || Substr(To_Char(1000 + Irow_.Traynum), 2, 3);
      Irow_.Nweight := Pkg_a.Get_Item_Value('NWEIGHT', Rowlist_);
      Irow_.Cweight := Pkg_a.Get_Item_Value('CWEIGHT', Rowlist_);
      Irow_.Volume  := Pkg_a.Get_Item_Value('VOLUME', Rowlist_);
    
      Irow_.Signtrayweight := Pkg_a.Get_Item_Value('SIGNTRAYWEIGHT',
                                                   Rowlist_);
      Irow_.Factheight     := Pkg_a.Get_Item_Value('FACTHEIGHT', Rowlist_);
      Irow_.State          := '0';
      Irow_.Enter_Date     := Sysdate;
      Irow_.Enter_User     := User_Id_;
      Irow_.Tray_Flag      := Pkg_a.Get_Item_Value('TRAY_FLAG', Rowlist_);
    
      --检测混托不能输入单托箱数
      If Irow_.Tray_Flag = '0' Then
        If Irow_.Trayspace > 0 Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  '只有混托才能输入单箱数量！');
        End If;
      
      End If;
    
      --open cur_ for 
      Select Max(t.Sort_By)
        Into Irow_.Sort_By
        From Bl_Putintray_m t
       Where t.Picklistno = Irow_.Picklistno;
      /* fetch cur_ into row_.Sort_By;
      if cur_%found then 
        
      end if ;
      close cur_;
      */
      -- Into Irow_.Sort_By
    
      Irow_.Sort_By := Nvl(Irow_.Sort_By, 0) + 1;
      If Irow_.Tray_Flag = '1' Then
        If Nvl(Irow_.Trayspace, 0) <= 0 Then
        
          Raise_Application_Error(Pkg_a.Raise_Error, '必须填写单托箱数');
        End If;
      
      End If;
      Insert Into Bl_Putintray_m
        (Putintray_No,
         Trayid,
         Picklistno,
         Traytype,
         Traytypename,
         Nweight,
         Cweight,
         Volume,
         Signtrayweight,
         State,
         Factheight,
         Putindate,
         Enter_Date,
         Enter_User,
         Modi_Date,
         Modi_User,
         Contract,
         Traynum,
         Trayspace,
         Tray_Flag,
         Sort_By)
      Values
        (Irow_.Putintray_No,
         Irow_.Trayid,
         Irow_.Picklistno,
         Irow_.Traytype,
         Irow_.Traytypename,
         Irow_.Nweight,
         Irow_.Cweight,
         Irow_.Volume,
         Irow_.Signtrayweight,
         Irow_.State,
         Irow_.Factheight,
         Irow_.Putindate,
         Irow_.Enter_Date,
         Irow_.Enter_User,
         Irow_.Modi_Date,
         Irow_.Modi_User,
         Irow_.Contract,
         Irow_.Traynum,
         Irow_.Trayspace,
         Irow_.Tray_Flag,
         Irow_.Sort_By)
      Returning Rowid Into Objid_;
    
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINTRAY_M', Objid_);
      Pkg_a.Setmsg(A311_Key_,
                   '',
                   '保存数据(' || Irow_.Putintray_No || ')成功',
                   Objid_);
      Return;
    End If;
    --修改
    If Doaction_ = 'M' Then
      Open Cur_ For
        Select t.* From Bl_v_Putintray_m t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error, '错误的rowid！');
      
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := 'update Bl_Putintray_m set  ';
      Ifmychange := '0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
      
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' And
           Column_Id_ <> 'ROWTYPE' And Column_Id_ <> 'ROWTYPE' And
           Column_Id_ <> 'TRAYWEIGHT' And Column_Id_ <> 'TRAYLENGTH' And
           Column_Id_ <> 'TRAYWIDTH' And Column_Id_ <> 'TRAYHEIGHT' And
           Column_Id_ <> 'TRAYDESCRIBE' And Length(Nvl(Column_Id_, '')) > 0 Then
          Ifmychange := '1';
          v_         := Substr(v_, Pos1_ + 1);
          Mysql_     := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
          If Column_Id_ = 'TRAY_FLAG' Then
            Row_.Tray_Flag := v_;
          
          End If;
          If Column_Id_ = 'TRAYSPACE' Then
          
            Row_.Trayspace := v_;
          End If;
        End If;
      
      End Loop;
      If Row_.Tray_Flag = '1' Then
        If Nvl(Row_.Trayspace, 0) <= 0 Then
        
          Raise_Application_Error(Pkg_a.Raise_Error, '必须填写单托箱数');
        End If;
      
      End If;
      --用户自定义列
      If Ifmychange = '1' Then
        Mysql_ := Mysql_ || 'modi_date=sysdate,modi_user=''' || User_Id_ || '''';
        Mysql_ := '' || Mysql_ || ' WHERE rowid=''' || Row_.Objid || '''';
        Execute Immediate Mysql_;
      End If;
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_ORDER', Row_.Objid);
    
      --pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
      Return;
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
    Attr_Out       Varchar2(4000);
    Row_           Bl_v_Putintray_m%Rowtype;
    Cur_           t_Cursor;
    Row_Traystuff_ Bl_v_Traystuff%Rowtype;
  Begin
  
    If Column_Id_ = 'TRAYTYPE' Then
      Row_.Traytype   := Pkg_a.Get_Item_Value('TRAYTYPE', Rowlist_);
      Row_.Contract   := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Row_.Factheight := Pkg_a.Get_Item_Value('FACTHEIGHT', Rowlist_);
      Open Cur_ For
        Select t.*
          From Bl_v_Traystuff t
         Where t.Trayid = Row_.Traytype
           And t.Contract = Row_.Contract;
      Fetch Cur_
        Into Row_Traystuff_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '错误的托盘编码' || Row_.Traytype);
      End If;
      Close Cur_;
      Row_.Volume := (Row_Traystuff_.Trayheight + Row_.Factheight) *
                     Row_Traystuff_.Traylength * Row_Traystuff_.Traywidth;
    
      --Raise_Application_Error(Pkg_a.Raise_Error, '出错了 ！！！！！');
      Pkg_a.Set_Item_Value('TRAYTYPENAME',
                           Row_Traystuff_.Traydescribe,
                           Attr_Out);
      Pkg_a.Set_Item_Value('SIGNTRAYWEIGHT',
                           Row_Traystuff_.Trayweight,
                           Attr_Out);
      Pkg_a.Set_Item_Value('VOLUME', Row_.Volume, Attr_Out);
      Pkg_a.Set_Item_Value('TRAYHEIGHT',
                           Row_Traystuff_.Trayheight,
                           Attr_Out);
      Pkg_a.Set_Item_Value('TRAYLENGTH',
                           Row_Traystuff_.Traylength,
                           Attr_Out);
      Pkg_a.Set_Item_Value('TRAYWIDTH', Row_Traystuff_.Traywidth, Attr_Out);
    
      /*     --给列赋值
      Pkg_a.Set_Item_Value('【COLUMN】', '【VALUE】', Attr_Out);
      --设置列不可用
      Pkg_a.Set_Column_Enable('【COLUMN】', '0', Attr_Out);
      --设置列可用
      Pkg_a.Set_Column_Enable('【COLUMN】', '1', Attr_Out);*/
    End If;
    If Column_Id_ = 'FACTHEIGHT' Then
      Row_.Trayheight := Pkg_a.Get_Item_Value('TRAYHEIGHT', Rowlist_);
      Row_.Factheight := Pkg_a.Get_Item_Value('FACTHEIGHT', Rowlist_);
      Row_.Traylength := Pkg_a.Get_Item_Value('TRAYLENGTH', Rowlist_);
      Row_.Traywidth  := Pkg_a.Get_Item_Value('TRAYWIDTH', Rowlist_);
      Row_.Volume     := (Row_.Trayheight + Row_.Factheight) *
                         Row_.Traylength * Row_.Traywidth;
      Pkg_a.Set_Item_Value('VOLUME', Row_.Volume, Attr_Out);
    End If;
    If Column_Id_ = 'TRAYSPACE' Then
      Row_.Trayspace := Pkg_a.Get_Item_Value('TRAYSPACE', Rowlist_);
      If Row_.Trayspace > 0 Then
        Pkg_a.Set_Item_Value('TRAY_FLAG', '1', Attr_Out);
      Else
        Pkg_a.Set_Item_Value('TRAY_FLAG', '0', Attr_Out);
      End If;
    End If;
  
    Outrowlist_ := Attr_Out;
  End;

  --判断当前备货单时候已经打完托盘
  Function Check_Picklist_Exists(Picklistno_ In Varchar2,
                                 Contract_   In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    Open Cur_ For
      Select 1
        From Bl_v_Putincase_V03 t
       Where t.Picklistno = Picklistno_
         And t.To_Contract = Contract_
         And t.Box_Qty > t.Tp_Qty;
    Fetch Cur_
      Into Result_;
    If Cur_%Found Then
      Close Cur_;
      Result_ := 1;
    Else
      Close Cur_;
      Result_ := 0;
    End If;
  
    Return Result_;
  
  End;

  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  Function Checkbutton__(Dotype_  In Varchar2,
                         Key_     In Varchar2,
                         User_Id_ In Varchar2) Return Varchar2 Is
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
    Datailrow_ Bl_v_Putintray_m_Detail%Rowtype;
    Row_       Bl_v_Putintray_m%Rowtype;
    Cur_       t_Cursor;
  Begin
    If Column_Id_ = 'REMARK' Or Column_Id_ = 'VOLUME' Or
       Column_Id_ = 'FACTHEIGHT' Then
      Return '1';
    End If;
    If Doaction_ = 'M' Then
      Row_.State        := Pkg_a.Get_Item_Value('STATE', Rowlist_);
      Row_.Putintray_No := Pkg_a.Get_Item_Value('PUTINTRAY_NO', Rowlist_);
    
      If Row_.State = '0' And Column_Id_ = 'TRAYTYPE' Then
        Row_.Traytype := Pkg_a.Get_Item_Value('TRAYTYPE', Rowlist_);
        If Nvl(Row_.Traytype, '-') = '-' Then
          Return '1';
        End If;
      End If;
      If (Row_.State = '0' Or Row_.State = '1') And Column_Id_ = 'SORT_BY' Then
        Return '1';
      
      End If;
    
      If Row_.State = '0' And
         (Column_Id_ = 'TRAYSPACE' Or Column_Id_ = 'TRAY_FLAG' Or
         Column_Id_ = 'TRAYTYPE') Then
      
        Open Cur_ For
          Select t.*
            From Bl_v_Putintray_m_Detail t
           Where t.Putintray_No = Row_.Putintray_No;
        Fetch Cur_
          Into Datailrow_;
        If Cur_%Found Then
          Close Cur_;
          Return '0';
        End If;
        Close Cur_;
        Return '1';
      End If;
      Return '0';
    End If;
    If Column_Id_ = '【COLUMN】' Then
      Return '0';
    End If;
    Return '1';
  End;

  --生成包装资料 重新生成托盘号
  Procedure Create_Pick__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
    Cur_      t_Cursor;
    Cur1_     t_Cursor;
    Mainrow_  Bl_v_Putintray_m%Rowtype;
    Cmainrow_ Bl_v_Putintray_m%Rowtype;
    i_        Number;
    Line_     Number;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putintray_m t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_%Notfound Then
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的rowid！');
    End If;
    Close Cur_;
    If Mainrow_.State != '1' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '只有已打托盘才能生成包装资料');
    End If;
  
    Bl_Putintray_Api.Set_Pick___(Mainrow_.Picklistno,
                                 Mainrow_.Contract,
                                 User_Id_);
    Bl_Putincase_Api.Set_Pick___(Mainrow_.Picklistno,
                                 Mainrow_.Contract,
                                 User_Id_);
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINTRAY_M', Mainrow_.Objid);
    Pkg_a.Setmsg(A311_Key_, '', '生成包装资料成功！');
    Return;
  End;
  --生成包装资料
  Procedure Set_Pick___(Picklistno_ In Varchar2,
                        Contract_   In Varchar2,
                        User_Id_    In Varchar2) Is
    Cur_            t_Cursor;
    Line_           Number;
    Cmainrow_       Bl_Putintray%Rowtype;
    i_              Number;
    Cur1_           t_Cursor;
    Putincase_No_   Varchar2(100);
    Putincase_Line_ Number;
    To_Contract_    Varchar2(100);
    Box_Num_        Number; --散箱箱数
    Frist_Box_      Varchar2(1); --是否第一组散箱
  Begin
    --删除作废的空头
    Delete From Bl_Putin t
     Where t.Putin_No In (Select a.Putintray_No
                            From Bl_Putintray_m a
                           Where a.State = '3'
                             And a.Picklistno = Picklistno_);
    Delete From Bl_Putintray_m T1
     Where T1.State = '3'
       And T1.Picklistno = Picklistno_;
    --找托盘信息一样的内容放在一起
    Open Cur_ For
      Select t.*
        From Bl_Putintray t
       Inner Join Bl_Putintray_m T1
          On T1.Putintray_No = t.Putintray_No
         And T1.Picklistno = Picklistno_
       Where t.Picklistno = Picklistno_
       Order By T1.Sort_By, t.Putintray_No, t.Putintray_Newline;
    Fetch Cur_
      Into Cmainrow_;
    i_ := 0;
    Loop
      Exit When Cur_%Notfound;
      i_ := i_ + 1;
      If Cmainrow_.State = '0' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                Cmainrow_.Putintray_No || '未打托盘不能装箱');
      End If;
      Update Bl_Putincase_Box t
         Set t.Putintray_Id      = 'TX' || Substr(To_Char(1000 + i_), 2, 3),
             t.To_Contract       = Cmainrow_.Contract, --托盘域
             t.Putintray_Newline = i_
       Where t.Putintray_No = Cmainrow_.Putintray_No
         And t.Putintray_Line = Cmainrow_.Line_No;
    
      --更新箱数 重量
      Select Sum(t.Partweight), Sum(t.Casingweight), Count(*)
        Into Cmainrow_.Nweight, Cmainrow_.Cweight, Cmainrow_.Trayspace
        From Bl_Putincase_Box t
       Where t.Putintray_No = Cmainrow_.Putintray_No
         And t.Putintray_Line = Cmainrow_.Line_No;
    
      --更新托盘号码
      Update Bl_Putintray t
         Set t.Trayno         = 'TX' || Substr(To_Char(1000 + i_), 2, 3),
             t.Putintray_Sort = i_,
             t.Cweight        = Cmainrow_.Cweight,
             t.Nweight        = Cmainrow_.Nweight,
             t.Trayspace      = Cmainrow_.Trayspace
       Where t.Putintray_No = Cmainrow_.Putintray_No
         And t.Line_No = Cmainrow_.Line_No;
    
      Fetch Cur_
        Into Cmainrow_;
    End Loop;
    Close Cur_;
    --把没有打托盘的数据编号
    Open Cur_ For
      Select t.Putincase_No,
             t.Detail_Line,
             t.To_Contract,
             Count(t.Picklistno) Box_Num
        From Bl_Putincase_Box t
       Where Putincase_No In
             (Select a.Putincase_No
                From Bl_Putincase_m a
               Where a.Picklistno = Picklistno_)
         And t.Putintray_No = '-'
       Group By t.Putincase_No, t.Detail_Line, t.To_Contract
       Order By t.Putincase_No, t.Detail_Line, t.To_Contract;
    Fetch Cur_
      Into Putincase_No_, Putincase_Line_, To_Contract_, Box_Num_;
    Frist_Box_ := '1';
    Loop
      Exit When Cur_%Notfound;
      If Frist_Box_ = '1' Then
        i_         := i_ + 1;
        Frist_Box_ := '0';
      End If;
      Update Bl_Putincase_Box t
         Set t.Putintray_Newline = i_
       Where t.Putincase_No = Putincase_No_
         And t.Detail_Line = Putincase_Line_
         And t.To_Contract = To_Contract_
         And t.Putintray_No = '-';
      If Frist_Box_ = '0' Then
        i_ := i_ + Box_Num_;
      End If;
      Fetch Cur_
        Into Putincase_No_, Putincase_Line_, To_Contract_, Box_Num_;
    End Loop;
    Close Cur_;
  End;
  Procedure Appvoe___(Picklistno_ In Varchar2,
                      Contract_   In Varchar2,
                      User_Id_    In Varchar2) Is
    Cur_            t_Cursor;
    Bl_Putintray_m_ Bl_Putintray_m%Rowtype;
    Cur1_           t_Cursor;
    Cur2_           t_Cursor;
    Bl_Putin_       Bl_Putin%Rowtype;
    Cbl_Putin_      Bl_Putin%Rowtype;
    Res_            Number;
  Begin
    --托盘   
    Delete From Bl_Putintray_m t
     Where t.Picklistno = Picklistno_
       And Not Exists (Select 1
              From Bl_Putintray_m_Detail a
             Where a.Putintray_No = t.Putintray_No);
    Open Cur_ For
      Select t.*
        From Bl_Putintray_m t
       Where t.Picklistno = Picklistno_
         And t.Contract = Contract_
         And t.State In ('1', '2');
    Fetch Cur_
      Into Bl_Putintray_m_;
    Loop
      Exit When Cur_%Notfound;
      Update Bl_Putintray_m t
         Set t.State = '4', t.Putindate = Sysdate
       Where t.Putintray_No = Bl_Putintray_m_.Putintray_No;
    
      Update Bl_Putintray_m_Detail t
         Set t.State = '4'
       Where t.Putintray_No = Bl_Putintray_m_.Putintray_No;
    
      Update Bl_Putintray t
         Set t.State = '4'
       Where t.Putintray_No = Bl_Putintray_m_.Putintray_No;
    
      --把托盘数据数据插入到系统中
      --  Insert Into Bl_Putin
      --   (Putin_No, Line_No, Qty, Enter_Date, Enter_User)
      Open Cur1_ For
        Select t.Putintray_No, t.Putintray_Detail, Count(*) As Qty
          From Bl_Putintray t
         Where t.Putintray_No = Bl_Putintray_m_.Putintray_No
         Group By t.Putintray_No, t.Putintray_Detail;
      Fetch Cur1_
        Into Bl_Putin_.Putin_No, Bl_Putin_.Line_No, Bl_Putin_.Qty;
      Loop
        Exit When Cur1_%Notfound;
        Open Cur2_ For
          Select t.*
            From Bl_Putin t
           Where t.Putin_No = Bl_Putin_.Putin_No
             And t.Line_No = Bl_Putin_.Line_No;
        Fetch Cur2_
          Into Cbl_Putin_;
        If Cur2_%Notfound Then
          Insert Into Bl_Putin
            (Putin_No, Line_No, Qty, Enter_Date, Enter_User)
          Values
            (Bl_Putin_.Putin_No,
             Bl_Putin_.Line_No,
             Bl_Putin_.Qty,
             Sysdate,
             User_Id_);
        Else
          If Cbl_Putin_.Qty <> Bl_Putin_.Qty Then
            Close Cur2_;
            Close Cur1_;
            Close Cur_;
            Raise_Application_Error(Pkg_a.Raise_Error,
                                    Bl_Putin_.Putin_No || '提交的托盘数量(' ||
                                    Bl_Putin_.Qty || ')必须和第一次提交的数量' ||
                                    Cbl_Putin_.Qty || '一致！');
          
          End If;
        
        End If;
        Close Cur2_;
      
        Fetch Cur1_
          Into Bl_Putin_.Putin_No, Bl_Putin_.Line_No, Bl_Putin_.Qty;
      End Loop;
      Close Cur1_;
    
      Fetch Cur_
        Into Bl_Putintray_m_;
    End Loop;
    Close Cur_;
  
    Return;
  
    Return;
  End;
  Procedure Cancelappvoe___(Picklistno_ In Varchar2,
                            Contract_   In Varchar2,
                            User_Id_    In Varchar2) Is
    Cur_            t_Cursor;
    Bl_Putintray_m_ Bl_Putintray_m%Rowtype;
  Begin
    --托盘    
    Open Cur_ For
      Select t.*
        From Bl_Putintray_m t
       Where t.Picklistno = Picklistno_
         And t.Contract = Contract_
         And t.State = '4';
    Fetch Cur_
      Into Bl_Putintray_m_;
    Loop
      Exit When Cur_%Notfound;
      Update Bl_Putintray_m t
         Set t.State = '1', t.Putindate = Null
       Where t.Putintray_No = Bl_Putintray_m_.Putintray_No;
    
      Update Bl_Putintray_m_Detail t
         Set t.State = '1'
       Where t.Putintray_No = Bl_Putintray_m_.Putintray_No;
    
      Update Bl_Putintray t
         Set t.State = '1'
       Where t.Putintray_No = Bl_Putintray_m_.Putintray_No;
      Fetch Cur_
        Into Bl_Putintray_m_;
    End Loop;
    Close Cur_;
    Return;
  End;
  Procedure Cancelappvoe__(Rowlist_  Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2) Is
    Cur_     t_Cursor;
    Mainrow_ Bl_v_Putintray_m%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putintray_m t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_%Notfound Then
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的rowid！');
    End If;
    Close Cur_;
    If Mainrow_.State <> '4' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '只有提交状态才能取消提交！');
    
    End If;
  
    Bl_Putincase_Api.Cancelappvoe___(Mainrow_.Picklistno,
                                     Mainrow_.Contract,
                                     User_Id_);
    Bl_Putintray_Api.Cancelappvoe___(Mainrow_.Picklistno,
                                     Mainrow_.Contract,
                                     User_Id_);
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINTRAY_M', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '取消提交成功');
    Return;
  End;

  --提交 包装资料
  Procedure Appvoe__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Cur_     t_Cursor;
    Mainrow_ Bl_v_Putintray_m%Rowtype;
    Res_     Number;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putintray_m t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_%Notfound Then
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的rowid！');
    End If;
    Close Cur_;
    Open Cur_ For
      Select 1
        From Bl_v_Putintray_m_Detail t
       Where t.Putintray_No = Mainrow_.Putintray_No;
    Fetch Cur_
      Into Res_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '没有明细，不能提交！');
    
    End If;
    Close Cur_;
  
    --生成包装资料
    Bl_Putincase_Api.Set_Pick___(Mainrow_.Picklistno,
                                 Mainrow_.Contract,
                                 User_Id_);
    Bl_Putintray_Api.Set_Pick___(Mainrow_.Picklistno,
                                 Mainrow_.Contract,
                                 User_Id_);
    --提交
    Bl_Putincase_Api.Appvoe___(Mainrow_.Picklistno,
                               Mainrow_.Contract,
                               User_Id_);
    Bl_Putintray_Api.Appvoe___(Mainrow_.Picklistno,
                               Mainrow_.Contract,
                               User_Id_);
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINTRAY_M', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '提交包装资料成功');
    Return;
  End;

  --生成托盘
  Procedure Release__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
  
    Detailrow_ Bl_Putintray_m_Detail%Rowtype;
    --     Detailrow_     Bl_v_Putintray_m_Detail%Rowtype;
  
    Row_           Bl_v_Putintray_m%Rowtype;
    Cur_           t_Cursor;
    Cur1_          t_Cursor;
    Putincase_Box_ Bl_Putincase_Box%Rowtype;
    Bl_Putintray_  Bl_Putintray%Rowtype;
    Box_Qty_       Number;
    i_             Number;
    Line_          Number;
    Checkqty       Number;
    Max_i_         Number;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putintray_m t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的rowid！');
    End If;
    Close Cur_;
    If Row_.State != '0' Then
      Raise_Application_Error(Pkg_a.Raise_Error, '只有保存状态才能打托盘');
    End If;
    Open Cur_ For
      Select 1
        From Bl_Putintray_m_Detail t
       Where t.Putintray_No = Row_.Putintray_No;
    Fetch Cur_
      Into i_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '没有明细，不能打托盘');
      Return;
    End If;
    Close Cur_;
  
    Row_.State := '1';
  
    Update Bl_Putintray_m t
       Set State       = Row_.State,
           t.Putindate = Sysdate,
           t.Modi_Date = Sysdate,
           t.Modi_User = User_Id_
     Where Rowid = Row_.Objid;
    --混托
    i_ := 1;
    --循环托盘数
    Line_ := 0;
    Select Max(t.Putintray_Newline)
      Into Max_i_
      From Bl_Putintray t
     Where t.Picklistno = Row_.Picklistno;
    Max_i_       := Nvl(Max_i_, 0);
    Row_.Cweight := 0;
    Row_.Nweight := 0;
    --混托
    If Row_.Tray_Flag = '1' Then
      Box_Qty_ := 10000000;
      Open Cur_ For
        Select t.*
          From Bl_Putintray_m_Detail t
         Where t.Putintray_No = Row_.Putintray_No;
      Fetch Cur_
        Into Detailrow_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error, '没有明细，不能打托盘');
      End If;
      Loop
        Exit When Cur_%Notfound;
        If Round(Detailrow_.Qty_Tp, 0) <> Detailrow_.Qty_Tp Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Putincase_Key || '在托盘箱数必须是整数');
          Return;
        End If;
        --计算托盘数
        i_ := Floor(Detailrow_.Qty / Detailrow_.Qty_Tp);
        If i_ < Box_Qty_ Then
          Box_Qty_ := i_;
        End If;
      
        Update Bl_Putintray_m_Detail t
           Set State = Row_.State, Qty = 0
         Where t.Putintray_No = Detailrow_.Putintray_No
           And t.Line_No = Detailrow_.Line_No;
        Fetch Cur_
          Into Detailrow_;
      End Loop;
    
      --数量太小
      If Box_Qty_ = 0 Then
        Raise_Application_Error(Pkg_a.Raise_Error, '数量不足无法打托盘');
        Return;
      End If;
      --混托
      i_ := 1;
      --循环托盘数
      Line_ := 0;
      Loop
        Exit When i_ > Box_Qty_;
      
        -- 插入托盘的数据到 bl_putintray_
        If 1 = 1 Then
          Select Bl_Bl_Putintray.Nextval
            Into Bl_Putintray_.Trayid
            From Dual;
          Bl_Putintray_.Picklistno        := Row_.Picklistno;
          Bl_Putintray_.Casesid           := '';
          Bl_Putintray_.Casenumber        := 0;
          Bl_Putintray_.Trayrange         := '';
          Bl_Putintray_.State             := Row_.State;
          Bl_Putintray_.Traytype          := Row_.Traytype;
          Bl_Putintray_.Allweight         := Row_.Nweight + Row_.Cweight +
                                             Row_.Trayweight;
          Bl_Putintray_.Putintray_No      := Row_.Putintray_No;
          Bl_Putintray_.Line_No           := i_; --托盘序号
          Bl_Putintray_.Putintray_Detail  := 0;
          Bl_Putintray_.Putintray_Newline := i_ + Max_i_;
          Bl_Putintray_.Putintray_Line_No := i_ + Max_i_;
          Bl_Putintray_.Contract          := Row_.Contract;
          Bl_Putintray_.Signtrayweight    := Row_.Signtrayweight;
          Bl_Putintray_.Username          := User_Id_;
          Bl_Putintray_.Isputin           := Row_.State;
          Bl_Putintray_.Realheight        := Row_.Factheight;
          Bl_Putintray_.Factheight        := Row_.Factheight;
          Bl_Putintray_.Putindate         := Null;
          Bl_Putintray_.Createdate        := Sysdate;
          Bl_Putintray_.Trayno            := 'TX' || Substr(To_Char(1000 + i_ +
                                                                    Max_i_),
                                                            2,
                                                            3);
          Bl_Putintray_.Traytypename      := Row_.Traytypename;
          Bl_Putintray_.Trayspace         := Row_.Trayspace;
          Bl_Putintray_.Nweight           := 0;
          Bl_Putintray_.Cweight           := 0;
          Bl_Putintray_.Volume            := Row_.Volume;
          Bl_Putintray_.Enter_Date        := Sysdate;
          Bl_Putintray_.Enter_User        := User_Id_;
          Bl_Putintray_.Trayspace         := Row_.Trayspace;
          Bl_Putintray_.State             := Row_.State;
          Bl_Putintray_.Detail_Change     := 0;
        End If;
        --循环托盘行
        Open Cur_ For
          Select t.*
            From Bl_Putintray_m_Detail t
           Where t.Putintray_No = Row_.Putintray_No;
        Fetch Cur_
          Into Detailrow_;
        Loop
          Exit When Cur_%Notfound;
        
          Checkqty := Detailrow_.Qty_Tp;
          --循环箱子
          Open Cur1_ For
            Select t.*
              From Bl_Putincase_Box t
             Where t.Putincase_No = Detailrow_.Putincase_No
               And t.Detail_Line = Detailrow_.Detail_Line
               And t.Putintray_No = '-'
               And t.To_Contract = Row_.Contract
             Order By t.Line_No, t.Box_Newline;
          Fetch Cur1_
            Into Putincase_Box_;
          Loop
            Exit When Cur1_%Notfound Or Checkqty <= 0;
            Line_ := Line_ + 1;
            --更新箱子数据
            Update Bl_Putincase_Box t
               Set t.Putintray_No      = Detailrow_.Putintray_No,
                   t.Putintray_Line_No = Line_,
                   t.Putintray_Detail  = Bl_Putintray_.Putintray_Detail,
                   t.Putintray_Line    = Bl_Putintray_.Line_No, --托盘系统序号
                   t.Putintray_Id      = Bl_Putintray_.Trayno,
                   t.To_Contract       = Row_.Contract,
                   t.Putintray_Newline = Bl_Putintray_.Putintray_Newline,
                   t.Trayweight        = Row_.Signtrayweight /
                                         Row_.Trayspace
             Where t.Putincase_No = Putincase_Box_.Putincase_No
               And t.Line_No = Putincase_Box_.Line_No;
            Checkqty              := Checkqty - 1;
            Bl_Putintray_.Nweight := Bl_Putintray_.Nweight +
                                     Putincase_Box_.Partweight;
            Bl_Putintray_.Cweight := Bl_Putintray_.Cweight +
                                     Putincase_Box_.Casingweight;
            --合计数量
            Select Bl_Putintray_.Casenumber + Nvl(Sum(t.Qty), 0)
              Into Bl_Putintray_.Casenumber
              From Bl_Putincase_Box_Detail t
             Where t.Putincase_No = Putincase_Box_.Putincase_No
               And t.Box_Line = Putincase_Box_.Line_No;
          
            Fetch Cur1_
              Into Putincase_Box_;
          End Loop;
          Close Cur1_;
        
          If Checkqty > 0 Then
            Raise_Application_Error(Pkg_a.Raise_Error,
                                    Detailrow_.Putincase_Key || '数量不足无法打托盘' ||
                                    '---' || Checkqty);
          
          End If;
          Update Bl_Putintray_m_Detail t
             Set Qty = Qty + Detailrow_.Qty_Tp
           Where t.Putintray_No = Detailrow_.Putintray_No
             And t.Line_No = Detailrow_.Line_No;
          Fetch Cur_
            Into Detailrow_;
        End Loop;
      
        Close Cur_;
        Insert Into Bl_Putintray
          (Trayid,
           Casesid,
           Picklistno,
           Casenumber,
           Trayrange,
           Traytype,
           Allweight,
           Allbulk,
           Signtrayweight,
           Username,
           Isputin,
           Realheight,
           Putindate,
           Trayno,
           Traytypename,
           Trayspace,
           Nweight,
           Cweight,
           Volume,
           Alteruser,
           Alterdate,
           Factheight,
           Createdate,
           Putintray_No,
           Putintray_Detail,
           Putintray_Line_No,
           Putintray_Newline,
           Line_No,
           Enter_Date,
           Enter_User,
           Contract,
           State,
           Detail_Change,
           Putintray_Sort)
        Values
          (Bl_Putintray_.Trayid,
           Bl_Putintray_.Casesid,
           Bl_Putintray_.Picklistno,
           Bl_Putintray_.Casenumber,
           Bl_Putintray_.Trayrange,
           Bl_Putintray_.Traytype,
           Bl_Putintray_.Allweight,
           Bl_Putintray_.Allbulk,
           Bl_Putintray_.Signtrayweight,
           Bl_Putintray_.Username,
           Bl_Putintray_.Isputin,
           Bl_Putintray_.Realheight,
           Bl_Putintray_.Putindate,
           Bl_Putintray_.Trayno,
           Bl_Putintray_.Traytypename,
           Bl_Putintray_.Trayspace,
           Bl_Putintray_.Nweight,
           Bl_Putintray_.Cweight,
           Bl_Putintray_.Volume,
           Bl_Putintray_.Alteruser,
           Bl_Putintray_.Alterdate,
           Bl_Putintray_.Factheight,
           Bl_Putintray_.Createdate,
           Bl_Putintray_.Putintray_No,
           Bl_Putintray_.Putintray_Detail,
           Bl_Putintray_.Putintray_Line_No,
           Bl_Putintray_.Putintray_Newline,
           Bl_Putintray_.Line_No,
           Bl_Putintray_.Enter_Date,
           Bl_Putintray_.Enter_User,
           Bl_Putintray_.Contract,
           Bl_Putintray_.State,
           Bl_Putintray_.Detail_Change,
           Bl_Putintray_.Putintray_Sort);
        i_ := i_ + 1;
      End Loop;
    Else
      i_ := 1;
      --循环托盘数
      Line_ := 0;
      --全打托盘  
      Open Cur_ For
        Select t.*
          From Bl_Putintray_m_Detail t
         Where t.Putintray_No = Row_.Putintray_No;
      Fetch Cur_
        Into Detailrow_;
      Loop
        Exit When Cur_%Notfound;
        If Round(Detailrow_.Qty_Tp, 0) <> Detailrow_.Qty_Tp Or
           Detailrow_.Qty_Tp <= 0 Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  '请输入正确的整数数量！');
        End If;
        --循环箱子
        Box_Qty_       := Floor(Detailrow_.Qty / Detailrow_.Qty_Tp);
        Checkqty       := Detailrow_.Qty_Tp;
        Detailrow_.Qty := Box_Qty_ * Detailrow_.Qty_Tp;
        --数量太小
        If Box_Qty_ <= 0 Then
          Raise_Application_Error(Pkg_a.Raise_Error, '数量不足无法打托盘');
          Return;
        End If;
        If 1 = 1 Then
          Select Bl_Bl_Putintray.Nextval
            Into Bl_Putintray_.Trayid
            From Dual;
          Bl_Putintray_.Enter_Date        := Sysdate;
          Bl_Putintray_.Enter_User        := User_Id_;
          Bl_Putintray_.Picklistno        := Row_.Picklistno;
          Bl_Putintray_.Casesid           := '';
          Bl_Putintray_.Trayrange         := '';
          Bl_Putintray_.Casenumber        := 0;
          Bl_Putintray_.Line_No           := i_; --托盘序号
          Bl_Putintray_.Trayno            := 'TX' || Substr(To_Char(1000 + i_ +
                                                                    Max_i_),
                                                            2,
                                                            3);
          Bl_Putintray_.Putintray_Newline := i_ + Max_i_;
          Bl_Putintray_.Putintray_Line_No := i_ + Max_i_;
          Bl_Putintray_.Contract          := Row_.Contract;
          Bl_Putintray_.State             := Row_.State;
          Bl_Putintray_.Putintray_Detail  := Detailrow_.Line_No;
          Bl_Putintray_.Traytype          := Row_.Traytype;
          Bl_Putintray_.Allweight         := Row_.Nweight + Row_.Cweight +
                                             Row_.Trayweight;
          Bl_Putintray_.Putintray_No      := Row_.Putintray_No;
          Bl_Putintray_.Signtrayweight    := Row_.Signtrayweight;
          Bl_Putintray_.Username          := User_Id_;
          Bl_Putintray_.Isputin           := Row_.State;
          Bl_Putintray_.State             := Row_.State;
          Bl_Putintray_.Realheight        := Row_.Factheight;
          Bl_Putintray_.Factheight        := Row_.Factheight;
          Bl_Putintray_.Putindate         := Null;
          Bl_Putintray_.Createdate        := Sysdate;
        
          Bl_Putintray_.Traytypename := Row_.Traytypename;
          Bl_Putintray_.Trayspace    := Row_.Trayspace;
          Bl_Putintray_.Nweight      := 0;
          Bl_Putintray_.Cweight      := 0;
          Bl_Putintray_.Volume       := Row_.Volume;
          Bl_Putintray_.Trayspace    := Detailrow_.Qty_Tp;
        End If;
      
        Open Cur1_ For
          Select t.*
            From Bl_Putincase_Box t
           Where t.Putincase_No = Detailrow_.Putincase_No
             And t.Detail_Line = Detailrow_.Detail_Line
             And t.Putintray_No = '-'
             And t.To_Contract = Row_.Contract
             And Rownum <= Detailrow_.Qty
           Order By t.Line_No, t.Enter_Date, t.Box_Newline;
        Fetch Cur1_
          Into Putincase_Box_;
        Loop
          Exit When Cur1_%Notfound;
          Line_ := Line_ + 1;
          Update Bl_Putincase_Box t
             Set t.Putintray_No      = Detailrow_.Putintray_No,
                 t.Putintray_Line_No = Line_,
                 t.Putintray_Detail  = Bl_Putintray_.Putintray_Detail,
                 t.Putintray_Line    = Bl_Putintray_.Line_No,
                 t.Putintray_Id      = Bl_Putintray_.Trayno,
                 t.To_Contract       = Row_.Contract,
                 t.Putintray_Newline = Bl_Putintray_.Putintray_Newline,
                 t.Trayweight        = Row_.Signtrayweight / Row_.Trayspace
           Where t.Putincase_No = Putincase_Box_.Putincase_No
             And t.Line_No = Putincase_Box_.Line_No;
          --合计数量
          Bl_Putintray_.Nweight := Bl_Putintray_.Nweight +
                                   Putincase_Box_.Partweight;
          Bl_Putintray_.Cweight := Bl_Putintray_.Cweight +
                                   Putincase_Box_.Casingweight;
        
          Select Bl_Putintray_.Casenumber + Nvl(Sum(t.Qty), 0)
            Into Bl_Putintray_.Casenumber
            From Bl_Putincase_Box_Detail t
           Where t.Putincase_No = Putincase_Box_.Putincase_No
             And t.Box_Line = Putincase_Box_.Line_No;
          Checkqty := Checkqty - 1;
          If Checkqty = 0 Then
            Insert Into Bl_Putintray
              (Trayid,
               Casesid,
               Picklistno,
               Casenumber,
               Trayrange,
               Traytype,
               Allweight,
               Allbulk,
               Signtrayweight,
               Username,
               Isputin,
               Realheight,
               Putindate,
               Trayno,
               Traytypename,
               Trayspace,
               Nweight,
               Cweight,
               Volume,
               Alteruser,
               Alterdate,
               Factheight,
               Createdate,
               Putintray_No,
               Putintray_Detail,
               Putintray_Line_No,
               Putintray_Newline,
               Line_No,
               Enter_Date,
               Enter_User,
               Contract,
               State,
               Detail_Change,
               Putintray_Sort)
            Values
              (Bl_Putintray_.Trayid,
               Bl_Putintray_.Casesid,
               Bl_Putintray_.Picklistno,
               Bl_Putintray_.Casenumber,
               Bl_Putintray_.Trayrange,
               Bl_Putintray_.Traytype,
               Bl_Putintray_.Allweight,
               Bl_Putintray_.Allbulk,
               Bl_Putintray_.Signtrayweight,
               Bl_Putintray_.Username,
               Bl_Putintray_.Isputin,
               Bl_Putintray_.Realheight,
               Bl_Putintray_.Putindate,
               Bl_Putintray_.Trayno,
               Bl_Putintray_.Traytypename,
               Bl_Putintray_.Trayspace,
               Bl_Putintray_.Nweight,
               Bl_Putintray_.Cweight,
               Bl_Putintray_.Volume,
               Bl_Putintray_.Alteruser,
               Bl_Putintray_.Alterdate,
               Bl_Putintray_.Factheight,
               Bl_Putintray_.Createdate,
               Bl_Putintray_.Putintray_No,
               Bl_Putintray_.Putintray_Detail,
               Bl_Putintray_.Putintray_Line_No,
               Bl_Putintray_.Putintray_Newline,
               Bl_Putintray_.Line_No,
               Bl_Putintray_.Enter_Date,
               Bl_Putintray_.Enter_User,
               Bl_Putintray_.Contract,
               Bl_Putintray_.State,
               Bl_Putintray_.Detail_Change,
               Bl_Putintray_.Putintray_Sort);
          
            Checkqty := Detailrow_.Qty_Tp;
            i_       := i_ + 1;
            Select Bl_Bl_Putintray.Nextval
              Into Bl_Putintray_.Trayid
              From Dual;
            Bl_Putintray_.Casenumber        := 0;
            Bl_Putintray_.Line_No           := i_; --托盘序号
            Bl_Putintray_.Trayno            := 'TX' || Substr(To_Char(1000 + i_ +
                                                                      Max_i_),
                                                              2,
                                                              3);
            Bl_Putintray_.Putintray_Newline := i_ + Max_i_;
            Bl_Putintray_.Putintray_Line_No := i_ + Max_i_;
            Bl_Putintray_.Nweight           := 0;
            Bl_Putintray_.Cweight           := 0;
          End If;
        
          Fetch Cur1_
            Into Putincase_Box_;
        End Loop;
        Close Cur1_;
        If Checkqty > 0 And Checkqty < Detailrow_.Qty_Tp Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Putincase_Key || '数量不足无法打托盘' ||
                                  '---' || Checkqty);
        
        End If;
        Update Bl_Putintray_m_Detail t
           Set t.Qty = Detailrow_.Qty, State = Row_.State
         Where t.Putintray_No = Detailrow_.Putintray_No
           And t.Line_No = Detailrow_.Line_No;
        Fetch Cur_
          Into Detailrow_;
      End Loop;
      Close Cur_;
    End If;
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINTRAY_M', Row_.Objid);
    Pkg_a.Setmsg(A311_Key_, '', '打托盘成功！');
    Return;
  End;
  --单个托盘拆除
  Procedure Modi_Box__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
    Boxrow_ Bl_Putintray_Tray%Rowtype;
    Row_    Bl_v_Putintray_m%Rowtype;
    Cur_    t_Cursor;
    Qty_    Number;
  Begin
    Boxrow_.Objid := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_Putintray_Tray t Where t.Objid = Boxrow_.Objid;
    Fetch Cur_
      Into Boxrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
  
    Open Cur_ For
      Select t.*
        From Bl_v_Putintray_m t
       Where t.Putintray_No = Boxrow_.Putintray_No;
    Fetch Cur_
      Into Row_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    --拆除托盘 
    If Row_.State != '1' Then
      Raise_Application_Error(Pkg_a.Raise_Error, '当前托盘状态不能拆除');
      Return;
    End If;
  
    Delete From Bl_Putintray t
     Where t.Putintray_No = Boxrow_.Putintray_No
       And t.Line_No = Boxrow_.Line_No;
  
    --修改数据
    Update Bl_Putincase_Box t
       Set t.Putintray_No      = '-',
           t.Putintray_Line_No = 0,
           t.Putintray_Line    = 0,
           t.Putintray_Id      = Null,
           t.Putintray_Detail  = Null,
           t.Putintray_Newline = Null
     Where t.Putintray_No = Boxrow_.Putintray_No
       And t.Putintray_Line = Boxrow_.Line_No;
  
    If Row_.Tray_Flag = '1' Then
      --箱数减少
      Update Bl_Putintray_m_Detail t
         Set t.Qty = t.Qty - t.Qty_Tp
       Where t.Putintray_No = Boxrow_.Putintray_No;
    Else
      --不是混托
      Update Bl_Putintray_m_Detail t
         Set t.Qty = t.Qty - t.Qty_Tp
       Where t.Putintray_No = Boxrow_.Putintray_No
         And t.Line_No = Boxrow_.Putintray_Detail;
    End If;
    -- 删除托盘
    Delete From Bl_Putintray_m_Detail t
     Where t.Putintray_No = Boxrow_.Putintray_No
       And Qty = 0;
  
    --没有明细
    Open Cur_ For
      Select 1
        From Bl_Putintray_m_Detail t
       Where t.Putintray_No = Boxrow_.Putintray_No;
    Fetch Cur_
      Into Qty_;
    If Cur_%Notfound Then
      Update Bl_Putintray_m
         Set State = '0'
       Where Putintray_No = Boxrow_.Putintray_No;
    End If;
    Close Cur_;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINTRAY_BOX', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '托盘拆除成功');
  End;

  --全部托盘拆除
  Procedure Modi_Allbox__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
    Boxrow_ Bl_Putintray_Tray%Rowtype;
    Row_    Bl_v_Putintray_m%Rowtype;
    Cur_    t_Cursor;
  Begin
    Boxrow_.Objid := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_Putintray_Tray t Where t.Objid = Boxrow_.Objid;
    Fetch Cur_
      Into Boxrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    Open Cur_ For
      Select t.*
        From Bl_v_Putintray_m t
       Where t.Putintray_No = Boxrow_.Putintray_No;
    Fetch Cur_
      Into Row_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    --拆除托盘 
    If Row_.State != '1' Then
      Raise_Application_Error(Pkg_a.Raise_Error, '当前托盘状态不能拆除');
      Return;
    End If;
    Delete From Bl_Putintray t Where t.Putintray_No = Boxrow_.Putintray_No;
  
    Update Bl_Putincase_Box t
       Set t.Putintray_No      = '-',
           t.Putintray_Line_No = 0,
           t.Putintray_Line    = 0,
           t.Putintray_Id      = Null,
           t.Putintray_Newline = Null,
           t.Putintray_Detail  = Null
     Where t.Putintray_No = Boxrow_.Putintray_No;
  
    -- 删除托盘
    Delete From Bl_Putintray_m_Detail t
     Where t.Putintray_No = Boxrow_.Putintray_No;
  
    Update Bl_Putintray_m
       Set State = '0'
     Where Putintray_No = Boxrow_.Putintray_No;
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINTRAY_BOX', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '托盘拆除成功');
  End;
  Function Get_Putintray_Des(Putintray_No_ In Varchar2) Return Varchar2 Is
    Result_ Varchar2(4000);
    Row_    Bl_v_Putintray_m%Rowtype;
    Cur_    t_Cursor;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_v_Putintray_m t
       Where t.Putintray_No = Putintray_No_;
    Fetch Cur_
      Into Row_;
    If Cur_ %Notfound Then
      Close Cur_;
      Result_ := '';
      Return Result_;
    End If;
    Close Cur_;
    Result_ := Row_.Traytypename;
    Return Result_;
  End;
  ---取消托盘
  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Cur_     t_Cursor;
    Mainrow_ Bl_v_Putintray_m%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putintray_m t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '托盘不存在了！');
      Return;
    
    End If;
    Close Cur_;
    If Mainrow_.State != '0' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '只有保存状态才能作废托盘！');
    
    End If;
    Delete From Bl_Putintray_m_Detail t
     Where t.Putintray_No = Mainrow_.Putintray_No;
  
    Update Bl_Putintray_m t
       Set t.State = '3'
     Where t.Putintray_No = Mainrow_.Putintray_No;
  
    Update Bl_Putintray t
       Set t.Putintray_No = Null
     Where t.Putintray_No = Mainrow_.Putintray_No;
  
    Update Bl_Putincase_Box t
       Set t.Putintray_No = '-'
     Where t.Putintray_No = Mainrow_.Putintray_No;
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINTRAY_M', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '作废托盘成功');
  
    Return;
  End;
End Bl_Putintray_Api;
/
