Create Or Replace Package Bl_v_Putintray_Api Is
  /* Created By WTL  2013-03-25 13:55:38*/
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

End Bl_v_Putintray_Api;
/
Create Or Replace Package Body Bl_v_Putintray_Api Is
  /* Created By WTL  2013-03-25 13:55:38*/
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
  
    -- pkg_a.Set_Item_Value('【COLUMN】','【VALUE】', attr_out);
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
    Ifmychange Varchar(1);
    Row_       Bl_v_Putintray%Rowtype;
  Begin
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    If Doaction_ = 'I' Then
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      /*
      --托盘号
      row_.TRAYID  := Pkg_a.Get_Item_Value('TRAYID', Rowlist_)
      --CASESID
      row_.CASESID  := Pkg_a.Get_Item_Value('CASESID', Rowlist_)
      --备货单
      row_.PICKLISTNO  := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_)
      --CASENUMBER
      row_.CASENUMBER  := Pkg_a.Get_Item_Value('CASENUMBER', Rowlist_)
      --TRAYRANGE
      row_.TRAYRANGE  := Pkg_a.Get_Item_Value('TRAYRANGE', Rowlist_)
      --托盘类型
      row_.TRAYTYPE  := Pkg_a.Get_Item_Value('TRAYTYPE', Rowlist_)
      --ALLWEIGHT
      row_.ALLWEIGHT  := Pkg_a.Get_Item_Value('ALLWEIGHT', Rowlist_)
      --ALLBULK
      row_.ALLBULK  := Pkg_a.Get_Item_Value('ALLBULK', Rowlist_)
      --托盘重量
      row_.SIGNTRAYWEIGHT  := Pkg_a.Get_Item_Value('SIGNTRAYWEIGHT', Rowlist_)
      --USERNAME
      row_.USERNAME  := Pkg_a.Get_Item_Value('USERNAME', Rowlist_)
      --ISPUTIN
      row_.ISPUTIN  := Pkg_a.Get_Item_Value('ISPUTIN', Rowlist_)
      --REALHEIGHT
      row_.REALHEIGHT  := Pkg_a.Get_Item_Value('REALHEIGHT', Rowlist_)
      --提交日期
      row_.PUTINDATE  := Pkg_a.Get_Item_Value('PUTINDATE', Rowlist_)
      --TRAYNO
      row_.TRAYNO  := Pkg_a.Get_Item_Value('TRAYNO', Rowlist_)
      --托盘规格
      row_.TRAYTYPENAME  := Pkg_a.Get_Item_Value('TRAYTYPENAME', Rowlist_)
      --单托箱数
      row_.TRAYSPACE  := Pkg_a.Get_Item_Value('TRAYSPACE', Rowlist_)
      --单托净重
      row_.NWEIGHT  := Pkg_a.Get_Item_Value('NWEIGHT', Rowlist_)
      --单托箱重
      row_.CWEIGHT  := Pkg_a.Get_Item_Value('CWEIGHT', Rowlist_)
      --单托体积
      row_.VOLUME  := Pkg_a.Get_Item_Value('VOLUME', Rowlist_)
      --ALTERUSER
      row_.ALTERUSER  := Pkg_a.Get_Item_Value('ALTERUSER', Rowlist_)
      --ALTERDATE
      row_.ALTERDATE  := Pkg_a.Get_Item_Value('ALTERDATE', Rowlist_)
      --实高
      row_.FACTHEIGHT  := Pkg_a.Get_Item_Value('FACTHEIGHT', Rowlist_)
      --CREATEDATE
      row_.CREATEDATE  := Pkg_a.Get_Item_Value('CREATEDATE', Rowlist_)
      --托盘编码
      row_.PUTINTRAY_NO  := Pkg_a.Get_Item_Value('PUTINTRAY_NO', Rowlist_)
      --PUTINTRAY_DETAIL
      row_.PUTINTRAY_DETAIL  := Pkg_a.Get_Item_Value('PUTINTRAY_DETAIL', Rowlist_)
      --PUTINTRAY_LINE_NO
      row_.PUTINTRAY_LINE_NO  := Pkg_a.Get_Item_Value('PUTINTRAY_LINE_NO', Rowlist_)
      --PUTINTRAY_NEWLINE
      row_.PUTINTRAY_NEWLINE  := Pkg_a.Get_Item_Value('PUTINTRAY_NEWLINE', Rowlist_)
      --LINE_NO
      row_.LINE_NO  := Pkg_a.Get_Item_Value('LINE_NO', Rowlist_)
      --状态
      row_.STATE  := Pkg_a.Get_Item_Value('STATE', Rowlist_)
      --ENTER_USER
      row_.ENTER_USER  := Pkg_a.Get_Item_Value('ENTER_USER', Rowlist_)
      --ENTER_DATE
      row_.ENTER_DATE  := Pkg_a.Get_Item_Value('ENTER_DATE', Rowlist_)
      --MODI_USER
      row_.MODI_USER  := Pkg_a.Get_Item_Value('MODI_USER', Rowlist_)
      --MODI_DATE
      row_.MODI_DATE  := Pkg_a.Get_Item_Value('MODI_DATE', Rowlist_)
      --域
      row_.CONTRACT  := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_)*/
      Return;
    End If;
    --修改
    If Doaction_ = 'M' Then
    
      Open Cur_ For
        Select t.* From Bl_v_Putintray t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error, '错误的rowid！');
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := 'update BL_PUTINTRAY SET ';
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
           Length(Nvl(Column_Id_, '')) > 0 Then
          Ifmychange := '1';
          v_         := Substr(v_, Pos1_ + 1);
          Mysql_     := Mysql_ || Column_Id_ || '=''' || v_ || ''',';
        End If;
      End Loop;
    
      --如果存在修改--
      If Ifmychange = '1' Then
        Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User =''' ||
                  User_Id_ || '''';
        Mysql_ := Mysql_ || 'Where Rowid =''' || Objid_ || '''';
        -- raise_application_error(Pkg_a.Raise_Error, mysql_);
        Execute Immediate Mysql_;
      End If;
    
      --设置成功的标志
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINTRAY', Objid_);
      Return;
    End If;
    --删除
    If Doaction_ = 'D' Then
      /*OPEN CUR_ FOR
              SELECT T.* FROM BL_V_PUTINTRAY T WHERE T.ROWID = OBJID_;
            FETCH CUR_
              INTO ROW_;
            IF CUR_ %NOTFOUND THEN
              CLOSE CUR_;
              RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
              return;
            end if;
            close cur_;
      --      DELETE FROM BL_V_PUTINTRAY T WHERE T.ROWID = OBJID_; */
      --设置成功的标志
      --pkg_a.Setsuccess(A311_Key_,'BL_V_PUTINTRAY', Objid_);
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
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2) Is
    Attr_Out       Varchar2(4000);
    Row_           Bl_v_Putintray%Rowtype;
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
    Row_ Bl_v_Putintray%Rowtype;
  Begin
  
    If Dotype_ = 'ADD_ROW' Then
      Return '0';
    End If;
    If Dotype_ = 'DEL_ROW' Then
      Return '0';
    End If;
    Return '1';
  End;

  /*  实现业务逻辑控制列的 编辑性
    Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
    Column_Id_  列
    Rowlist_  当前行的数据
    返回: 1 可用
    0 不可用
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    Row_ Bl_v_Putintray%Rowtype;
  Begin
    Row_.State := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    If Row_.State = '4' Then
      Return '0';
    End If;
    If Column_Id_ = '【COLUMN】' Then
      Return '0';
    End If;
    Return '1';
  End;

End Bl_v_Putintray_Api;
/
