Create Or Replace Package Bl_Putincase_Api Is
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
  --获取已包装数量
  Function Get_Pkg_Qty(Picklistno_   In Varchar2,
                       Order_No_     In Varchar2,
                       Line_No_      In Varchar2,
                       Rel_No_       In Varchar2,
                       Line_Item_No_ In Number,
                       Putright_No_  In Varchar2,
                       Contract_     In Varchar2) Return Number;
  --检测备货单是否可以装箱
  Function Check_Pkg_End(Picklistno_ In Varchar2, Contract_ In Varchar2)
    Return Number;

  --获取备货单数量
  Function Get_Pk_Qty(Picklistno_   In Varchar2,
                      Order_No_     In Varchar2,
                      Line_No_      In Varchar2,
                      Rel_No_       In Varchar2,
                      Line_Item_No_ In Number,
                      Putright_No_  In Varchar2,
                      Contract_     In Varchar2) Return Number;
  --获取已授权的数量
  Function Get_Putright_Qty(Picklistno_   In Varchar2,
                            Order_No_     In Varchar2,
                            Line_No_      In Varchar2,
                            Rel_No_       In Varchar2,
                            Line_Item_No_ In Number) Return Number;
  --作废
  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  --获取产品的包装内容
  Procedure Get_Pachage(Catalog_No_   Varchar2,
                        Contract_     In Varchar2,
                        Customer_No_  In Varchar2,
                        Pkg_Contract_ In Varchar2,
                        Pachage_Main_ Out Bl_Pachage_Set_Tab%Rowtype);
  --装箱
  Procedure Set_Pkg(Rowlist_  Varchar2,
                    User_Id_  Varchar2,
                    A311_Key_ Varchar2);
  --批量修改重量
  Procedure Modi_Weight_All__(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);
  --单箱重量修改
  Procedure Modi_Weight__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);
  --材料申请
  Procedure Set_Material_Requisition(Rowlist_  Varchar2,
                                     User_Id_  Varchar2,
                                     A311_Key_ Varchar2);
  --拆单个箱子
  Procedure Modi_Box__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  --拆全部箱子 
  Procedure Modi_Allbox__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);
  --下达
  Procedure Release__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --提交
  Procedure Srelease__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  --取消提交
  Procedure Releasecancel__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2);
  --取消提交 修改状态
  Procedure Cancelappvoe___(Picklistno_ In Varchar2,
                            Contract_   In Varchar2,
                            User_Id_    In Varchar2);
  --生成包装资料 主档
  Procedure Setpick__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --修改箱子总数
  Procedure Set_Box_Qty(Putincase_No_ In Varchar2, Detail_Line_ In Number);
  --获取备货单的包装状态  0 未包装完 1 包装完  4 提交 5 提交有差异
  Function Get_Pkg_State(Picklistno_ In Varchar2, Contract_ In Varchar2)
    Return Varchar2;
  --是否装箱完成
  Function Check_Box_End(Picklistno_ In Varchar2, Contract_ In Varchar2)
    Return Number;
  --提交
  Procedure Appvoe___(Picklistno_ In Varchar2,
                      Contract_   In Varchar2,
                      User_Id_    In Varchar2);
  --生成包装资料 备货单号
  Procedure Set_Pick___(Picklistno_ In Varchar2,
                        Contract_   In Varchar2,
                        User_Id_    In Varchar2);
  --获取包装资料的的报表内容 
  Function Get_Report_Data(Type_Id_ In Varchar2, Parmlist_ In Varchar2)
    Return Varchar;
  Function Get_Onebox_Qty(Putincase_No_ In Varchar2, Box_Line_ In Number)
    Return Number;

  -- 采购订单报表 发票  汇总金额
  Function Sum_Amount(Order_No_ In Varchar2) Return Number;
  -- 订舱委托报表  净重
  Function Get_Sum_Weight(Booking_No_ In Varchar2) Return Number;
  -- 订舱委托报表 毛重
  Function Get_Sum_Weight_a(Booking_No_ In Varchar2) Return Number;

  -- 订舱委托报表 总体积
  Function Get_Sum_Area(Booking_No_ In Varchar2) Return Number;
End Bl_Putincase_Api;
/
Create Or Replace Package Body Bl_Putincase_Api Is
  Type t_Cursor Is Ref Cursor;
  /*Create by wtl 2013-01-30
    modify  by wtl  2013-01-30 修改取消预生成 把预生成迁到生成包装资料 ，不生成材料申请   \
    modify  by wtl   2013-01-30 16:00 修改BUG 拆除托盘不能把 授权的托盘域清空    
  */
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
    Attr__      Varchar2(4000);
    Outrowlist_ Varchar2(4000);
    Row_        Bl_v_Putincase%Rowtype;
    Prow_       Bl_v_Pldtl_Putincase%Rowtype;
    Requesurl_  Varchar2(1000);
  Begin
    Attr_Out   := '';
    Requesurl_ := Pkg_a.Get_Item_Value('REQUESTURL', Rowlist_);
  
    Row_.Picklistno := Pkg_a.Get_Item_Value_By_Index('&PICKLISTNO=',
                                                     '&',
                                                     Requesurl_);
    If Nvl(Row_.Picklistno, 'NULL') <> 'NULL' Then
      Row_.Supplier := Pkg_a.Get_Item_Value_By_Index('&SUPPLIER=',
                                                     '&',
                                                     Requesurl_);
      Pkg_a.Set_Item_Value('SUPPLIER', Row_.Supplier, Attr__);
      Pkg_a.Set_Item_Value('PICKLISTNO', Row_.Picklistno, Attr__);
    
      Itemchange__('PICKLISTNO', '', Attr__, User_Id_, Outrowlist_);
    
      Pkg_a.Set_Item_Value('CUSTOMER_REF',
                           Pkg_a.Get_Item_Value('CUSTOMER_REF', Outrowlist_),
                           Attr_Out);
      Pkg_a.Set_Item_Value('LOCATION',
                           Pkg_a.Get_Item_Value('LOCATION', Outrowlist_),
                           Attr_Out);
      Pkg_a.Set_Item_Value('SUPPLIER', Row_.Supplier, Attr_Out);
      Pkg_a.Set_Item_Value('PICKLISTNO', Row_.Picklistno, Attr_Out);
    Else
    
      --默认域
      Row_.Supplier := Pkg_Attr.Get_Default_Contract(User_Id_);
      If (Nvl(Row_.Supplier, '0') <> '0') Then
        Pkg_a.Set_Item_Value('SUPPLIER', Row_.Supplier, Attr_Out);
      End If;
    End If;
    -- pkg_a.Set_Item_Value('【COLUMN】', '【VALUE】', attr_out);
    Pkg_a.Setresult(A311_Key_, Attr_Out);
  End;
  --获取需要包装的数量
  Function Get_Pk_Qty(Picklistno_   In Varchar2,
                      Order_No_     In Varchar2,
                      Line_No_      In Varchar2,
                      Rel_No_       In Varchar2,
                      Line_Item_No_ In Number,
                      Putright_No_  In Varchar2,
                      Contract_     In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
    Qty_    Number;
  Begin
    --如果没有授权 编码
    If Nvl(Putright_No_, '-') = '-' Then
      Open Cur_ For
        Select t.Pickqty
          From Bl_Pldtl t
         Where t.Picklistno = Picklistno_
           And t.Order_No = Order_No_
           And t.Line_No = Line_No_
           And t.Rel_No = Rel_No_
           And t.Line_Item_No = Line_Item_No_;
    
      Fetch Cur_
        Into Result_;
      Close Cur_;
      --扣除已经授权的数量      
      Open Cur_ For
        Select Sum(t.Qty)
          From Bl_Putright_m_Detail t
         Where t.Picklistno = Picklistno_
           And t.Co_Order_No = Order_No_
           And t.Co_Line_No = Line_No_
           And t.Co_Rel_No = Rel_No_
           And t.Co_Line_Item_No = Line_Item_No_
           And t.State = '2';
      Fetch Cur_
        Into Qty_;
      Close Cur_;
      Result_ := Nvl(Result_, 0) - Nvl(Qty_, 0);
    Else
      --获取授权--
      Open Cur_ For
        Select t.Qty
          From Bl_Putright_m_Detail_V01 t
         Where t.Putright_No = Putright_No_
           And t.Picklistno = Picklistno_
           And t.Co_Order_No = Order_No_
           And t.Co_Line_No = Line_No_
           And t.Co_Rel_No = Rel_No_
           And t.Co_Line_Item_No = Line_Item_No_
           And t.To_Contract = Contract_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
    End If;
    Return Nvl(Result_, 0);
  End;
  --是否装箱完成
  Function Check_Box_End(Picklistno_ In Varchar2, Contract_ In Varchar2)
    Return Number Is
    Result_ Number;
    Cur_    t_Cursor;
  Begin
  
    Open Cur_ For
      Select 1
        From Bl_v_Putincase_V03 t
       Where t.Picklistno = Picklistno_
         And t.To_Contract = Contract_
         And t.Box_Qty > t.Tp_Qty;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Nvl(Result_, 0);
  End;
  -- 获取包装状态
  Function Get_Pkg_State(Picklistno_ In Varchar2, Contract_ In Varchar2)
    Return Varchar2 Is
    Result_      Number;
    Cur_         t_Cursor;
    Putincase_m_ Bl_Putincase_m%Rowtype;
    Bl_Pldtl_    Bl_Pldtl%Rowtype;
  
  Begin
    --判断有没有未包装完的物料
    Open Cur_ For
      Select t.*
        From Bl_Putincase_m t
       Where t.Picklistno = Picklistno_
         And t.Supplier = Contract_
         And t.State <> '3'
       Order By t.State Desc;
    Fetch Cur_
      Into Putincase_m_;
    If Cur_%Found Then
      --已提交
      Close Cur_;
      If Putincase_m_.State = '4' Then
        --判断装箱有没有差异 
        Open Cur_ For
          Select 1
            From Bl_v_Putincase_V01 t
           Where t.Pickuniteno = Picklistno_
             And t.To_Contract = Contract_
             And t.Pickqty <> t.Qty;
        Fetch Cur_
          Into Result_;
        If Cur_%Found Then
          Close Cur_;
          Return '5'; --包装资料有差异 
        Else
          Close Cur_;
          Return '4'; --提交
        End If;
      
      Else
        Open Cur_ For
          Select 1
            From Bl_Putintray_m t
           Where t.Picklistno = Picklistno_
             And t.Contract = Contract_
             And t.State = '1';
        Fetch Cur_
          Into Result_;
        If Cur_%Found Then
          Close Cur_;
          Return '2'; --正在打托
        Else
          Close Cur_;
        End If;
        --检测有没有装箱完
        Open Cur_ For
          Select 1
            From Bl_v_Putincase_V01_c t
           Where t.Pickuniteno = Picklistno_
             And t.To_Contract = Contract_;
        Fetch Cur_
          Into Result_;
        If Cur_%Found Then
          Close Cur_;
          Return '6'; --未包装完  
        Else
        
          Return '1'; --包装完 
          Close Cur_;
        End If;
      
      End If;
    
    Else
    
      Close Cur_;
    End If;
  
    Return Nvl(Result_, '0');
  End;

  --是否包装完成
  Function Check_Pkg_End(Picklistno_ In Varchar2, Contract_ In Varchar2)
    Return Number Is
    Result_        Number;
    Cur_           t_Cursor;
    Bl_Putright_m_ Bl_Putright_m%Rowtype;
    Bl_Pldtl_      Bl_Pldtl%Rowtype;
  Begin
  
    --判断有没有未包装完的物料
    Open Cur_ For
      Select 1
        From Bl_v_Putincase_V01_c t
       Where t.Pickuniteno = Picklistno_
         And t.To_Contract = Contract_;
    /* Select 1
     From Bl_v_Putincase_V01 t
    Where t.Pickuniteno = Picklistno_
      And t.To_Contract = Contract_
      And t.Pickqty > t.Qty;*/
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Nvl(Result_, 0);
  End;
  --获取已授权的数量
  Function Get_Putright_Qty(Picklistno_   In Varchar2,
                            Order_No_     In Varchar2,
                            Line_No_      In Varchar2,
                            Rel_No_       In Varchar2,
                            Line_Item_No_ In Number) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    Open Cur_ For
      Select Sum(Nvl(t.Qty, 0))
        From Bl_Putright_m_Detail_V01 t
       Where t.Picklistno = Picklistno_
         And t.Co_Order_No = Order_No_
         And t.Co_Line_No = Line_No_
         And t.Co_Rel_No = Rel_No_
         And t.Co_Line_Item_No = Line_Item_No_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Nvl(Result_, 0);
  End;

  --获取备货单行已包装的数量
  Function Get_Pkg_Qty(Picklistno_   In Varchar2,
                       Order_No_     In Varchar2,
                       Line_No_      In Varchar2,
                       Rel_No_       In Varchar2,
                       Line_Item_No_ In Number,
                       Putright_No_  In Varchar2,
                       Contract_     In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    If Nvl(Putright_No_, '-') = '-' Then
      Open Cur_ For
        Select Sum(Nvl(t.Qty, 0))
          From Bl_Putincase_m_Detail t
         Where t.Picklistno = Picklistno_
           And t.Co_Order_No = Order_No_
           And t.Co_Line_No = Line_No_
           And t.Co_Rel_No = Rel_No_
           And t.Co_Line_Item_No = Line_Item_No_
           And t.State <> '3';
      Fetch Cur_
        Into Result_;
      Close Cur_;
    Else
      Open Cur_ For
        Select Sum(Nvl(t.Qty, 0))
          From Bl_Putincase_m_Detail t
         Where t.Picklistno = Picklistno_
           And t.Co_Order_No = Order_No_
           And t.Co_Line_No = Line_No_
           And t.Co_Rel_No = Rel_No_
           And t.Co_Line_Item_No = Line_Item_No_
           And t.Putright_No = Putright_No_
           And t.State <> '3';
      Fetch Cur_
        Into Result_;
      Close Cur_;
    End If;
    Return Nvl(Result_, 0);
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
    Row_       Bl_Putincase_m%Rowtype;
    Mainrow_   Bl_v_Putincase%Rowtype;
  Begin
  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    If Doaction_ = 'I' Then
      Row_.Picklistno := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_);
      Row_.Supplier   := Pkg_a.Get_Item_Value('SUPPLIER', Rowlist_);
      Row_.Pack_Flag  := Pkg_a.Get_Item_Value('PACK_FLAG', Rowlist_);
      Row_.Remark     := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      Row_.Pachage_No := Pkg_a.Get_Item_Value('PACHAGE_NO', Rowlist_);
      Row_.Box_Qty    := Pkg_a.Get_Item_Value('BOX_QTY', Rowlist_);
      Row_.Pachage_No := Pkg_a.Get_Item_Value('CASINGID', Rowlist_); --箱子ID
      Row_.State      := '0';
      Row_.Enter_Date := Sysdate;
      Row_.Enter_User := User_Id_;
      If Row_.Pack_Flag = '1' Then
        If Row_.Pachage_No = '' Or Row_.Pachage_No Is Null Then
          Raise_Application_Error(-20101, '混合包装箱子ID必填');
          Return;
        End If;
        If Nvl(Row_.Box_Qty, 0) <= 0 Then
          Raise_Application_Error(-20101, '混合包装每箱数量必须填写');
          Return;
        End If;
      Else
        Row_.Pachage_No := '';
        Row_.Box_Qty    := Null;
      End If;
      Bl_Customer_Order_Api.Getseqno('P' || To_Char(Sysdate, 'YYMM'),
                                     User_Id_,
                                     6,
                                     Row_.Putincase_No);
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase t
         Where t.Supplier = Row_.Supplier
           And t.Picklistno = Row_.Picklistno
           And t.State = '0';
      Fetch Cur_
        Into Mainrow_;
      If Cur_ %Found Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                '同一个域同一张备货单只能存在一份记录');
        Return;
      End If;
      Close Cur_;
    
      Insert Into Bl_Putincase_m
        (Putincase_No)
      Values
        (Row_.Putincase_No)
      Returning Rowid Into Objid_;
      Update Bl_Putincase_m Set Row = Row_ Where Rowid = Objid_;
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Objid_);
      -- Pkg_a.Setmsg(A311_Key_, '', '报报仇', Objid_);
    End If;
    --修改
    If Doaction_ = 'M' Then
      Open Cur_ For
        Select t.* From Bl_v_Putincase t Where t.Objid = Objid_;
      Fetch Cur_
        Into Mainrow_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      End If;
      Close Cur_;
    
      Data_  := Rowlist_;
      Pos_   := Instr(Data_, Index_);
      i      := i + 1;
      Mysql_ := 'update  BL_PUTINCASE_M SET';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_         := Substr(Data_, 1, Pos_ - 1);
        Data_      := Substr(Data_, Pos_ + 1);
        Pos_       := Instr(Data_, Index_);
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        v_         := Substr(v_, Pos1_ + 1);
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' Then
          Mysql_ := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
        End If;
      End Loop;
      Mysql_ := Mysql_ || 'modi_date=sysdate,modi_user=''' || User_Id_ ||
                ''' where rowid=''' || Objid_ || '''';
    
      Execute Immediate 'begin ' || Mysql_ || ';end;';
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Objid_);
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
    Cur_         t_Cursor;
    Row_         Bl_v_Putincase%Rowtype;
    Casrow_      Bl_Casingstuff%Rowtype;
    Bl_Picklist_ Bl_Picklist%Rowtype;
  Begin
    Row_.Supplier := Pkg_a.Get_Item_Value('SUPPLIER', Rowlist_);
    If Column_Id_ = 'PACK_FLAG' Then
      Row_.Pack_Flag := Pkg_a.Get_Item_Value('PACK_FLAG', Rowlist_);
      Pkg_a.Set_Column_Enable('CASINGID', '0', Attr_Out);
      If Row_.Pack_Flag <> '1' Then
        Pkg_a.Set_Column_Enable('CASINGID', '0', Attr_Out);
      
        Pkg_a.Set_Item_Value('CASINGID', '', Attr_Out);
        Pkg_a.Set_Item_Value('CASINGDESCRIBE', '', Attr_Out);
        Pkg_a.Set_Item_Value('CASINGWEIGHT', '', Attr_Out);
        Pkg_a.Set_Item_Value('CASINGLENGTH', '', Attr_Out);
        Pkg_a.Set_Item_Value('CASINGWIDTH', '', Attr_Out);
        Pkg_a.Set_Item_Value('CASINGHEIGHT', '', Attr_Out);
      End If;
      If Row_.Pack_Flag = '1' Then
        Pkg_a.Set_Column_Enable('CASINGID', '1', Attr_Out);
      End If;
      /*      --给列赋值
      Pkg_a.Set_Item_Value('【COLUMN】', '【VALUE】', Attr_Out);
      --设置列不可用
      Pkg_a.Set_Column_Enable('【COLUMN】', '0', Attr_Out);
      --设置列可用
      Pkg_a.Set_Column_Enable('【COLUMN】', '1', Attr_Out);*/
    End If;
    If Column_Id_ = 'CASINGID' Then
      Row_.Casingid := Pkg_a.Get_Item_Value('CASINGID', Rowlist_);
      Open Cur_ For
        Select t.*
          From Bl_Casingstuff t
         Where t.Casingid = Row_.Casingid
           And t.Contract = Row_.Supplier;
      Fetch Cur_
        Into Casrow_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的箱子ID');
        Return;
      End If;
      Close Cur_;
      Pkg_a.Set_Item_Value('CASINGDESCRIBE',
                           Casrow_.Casingdescribe,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CASINGWEIGHT', Casrow_.Casingweight, Attr_Out);
      Pkg_a.Set_Item_Value('CASINGLENGTH', Casrow_.Casinglength, Attr_Out);
      Pkg_a.Set_Item_Value('CASINGWIDTH', Casrow_.Casingwidth, Attr_Out);
      Pkg_a.Set_Item_Value('CASINGHEIGHT', Casrow_.Casingheight, Attr_Out);
    End If;
    If Column_Id_ = 'PICKLISTNO' Then
      Row_.Picklistno := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_);
      Open Cur_ For
        Select t.Customer_Ref, t.Location
          From Bl_v_Pldtl_Putincase t
         Where t.Picklistno = Row_.Picklistno;
      Fetch Cur_
        Into Bl_Picklist_.Customer_Ref, Bl_Picklist_.Location;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(Pkg_a.Raise_Error, '错误的备货单号');
        Return;
      End If;
      Close Cur_;
      Pkg_a.Set_Item_Value('CUSTOMER_REF',
                           Bl_Picklist_.Customer_Ref,
                           Attr_Out);
      Pkg_a.Set_Item_Value('LOCATION', Bl_Picklist_.Location, Attr_Out);
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
    Mainrow_   Bl_v_Putincase%Rowtype;
    Detailrow_ Bl_v_Putincase_m_Detail%Rowtype;
    Cur_       t_Cursor;
  Begin
    Mainrow_.State        := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    Mainrow_.Pack_Flag    := Pkg_a.Get_Item_Value('PACK_FLAG', Rowlist_);
    Mainrow_.Putincase_No := Pkg_a.Get_Item_Value('PUTINCASE_NO', Rowlist_);
  
    If Column_Id_ = 'REMARK' Then
      Return '1';
    End If;
    If Doaction_ = 'M' Then
      If Mainrow_.State = '0' And Mainrow_.Pack_Flag = '1' Then
        If Column_Id_ = 'BOX_QTY' Then
          --判断有没有明细
          Open Cur_ For
            Select t.*
              From Bl_v_Putincase_m_Detail t
             Where t.Putincase_No = Mainrow_.Putincase_No;
          Fetch Cur_
            Into Detailrow_;
          If Cur_%Notfound Then
            Close Cur_;
            Return '1';
          Else
            Close Cur_;
            Return '0';
          End If;
        End If;
      End If;
      Return '0';
    End If;
    If Column_Id_ = '【COLUMN】' Then
      Return '0';
    End If;
    Return '1';
  End;
  --生成材料申请
  Procedure Set_Material_Requisition(Rowlist_  Varchar2,
                                     User_Id_  Varchar2,
                                     A311_Key_ Varchar2) Is
    Cur_                t_Cursor;
    Mainrow_            Bl_v_Putincase%Rowtype;
    Sqrowlist_          Varchar2(4000);
    Sqlinerowlist_      Varchar2(4000);
    Outinerowlist_      Varchar2(4000);
    Sq_Config_          Varchar2(4000);
    A311_               A311%Rowtype;
    Irow_               Bl_v_Material_Requisition%Rowtype;
    Sqqty_              Number;
    Casingid_           Varchar2(40);
    A314_               A314%Rowtype;
    Mainrowlist_        Varchar2(4000);
    Bl_v_Putincase_V01_ Bl_v_Putincase_V01%Rowtype;
  Begin
    Return;
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的ROWID');
      Return;
    End If;
    Close Cur_;
    If Mainrow_.State != '2' Then
    
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '只有下达了才能生成材料申请');
      Return;
    End If;
    --判断明细是否装箱完成
    If Mainrow_.Sq_Order_No <> '' Or Mainrow_.Sq_Order_No Is Not Null Then
      Return;
      Raise_Application_Error(Pkg_a.Raise_Error, '已经生成材料申请');
      Return;
    End If;
  
    --检测备货单是否已经装箱完
    Open Cur_ For
      Select t.*
        From Bl_v_Putincase_V01 t
       Where t.Picklistno = Mainrow_.Picklistno
         And t.To_Contract = Mainrow_.Supplier
         And t.Pickqty <> t.Qty;
    Fetch Cur_
      Into Bl_v_Putincase_V01_;
  
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Bl_v_Putincase_V01_.Catalog_No || '(' ||
                              Bl_v_Putincase_V01_.Catalog_Desc || ')的数量' ||
                              To_Char(Bl_v_Putincase_V01_.Pickqty) || '装箱了' ||
                              To_Char(Bl_v_Putincase_V01_.Qty));
      Return;
    End If;
    Close Cur_;
  
    Pkg_a.Set_Item_Value('DOACTION', 'I', Sqrowlist_);
    Pkg_a.Set_Item_Value('OBJID', 'NULL', Sqrowlist_);
    Pkg_a.Set_Item_Value('CONTRACT', Mainrow_.Supplier, Sqrowlist_);
    Pkg_a.Set_Item_Value('INT_CUSTOMER_NO', 'BLGM', Sqrowlist_);
    Pkg_a.Set_Item_Value('DUE_DATE',
                         To_Char(Sysdate, 'YYYY-MM-DD'),
                         Sqrowlist_);
    Pkg_a.Set_Item_Value('NOTE_TEXT', Mainrow_.Picklistno, Sqrowlist_);
  
    A311_.A311_Id    := 'Bl_Putincase_Api.Set_Material_Requisition';
    A311_.Enter_User := User_Id_;
    A311_.A014_Id    := 'A014_ID=SAVE';
    A311_.Table_Id   := 'BL_V_MATERIAL_REQUISITION';
    Pkg_a.Beginlog(A311_);
    Bl_Material_Requisition_Api.Modify__(Sqrowlist_,
                                         User_Id_,
                                         A311_.A311_Key);
    Open Cur_ For
      Select t.* From A311 t Where t.A311_Key = A311_.A311_Key;
    Fetch Cur_
      Into A311_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, 'Set_Material_Requisition处理失败');
      Return;
    End If;
    Close Cur_;
    Open Cur_ For
      Select t.*
        From Bl_v_Material_Requisition t
       Where t.Objid = A311_.Table_Objid;
    Fetch Cur_
      Into Irow_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              'Set_Material_Requisition处理失败');
      Return;
    End If;
    Close Cur_;
    Update Bl_Putincase_m t
       Set t.Sq_Order_No = Irow_.Order_No
     Where t.Picklistno = Mainrow_.Picklistno
       And t.Supplier = Mainrow_.Supplier;
  
    --输入物料编码
    Pkg_a.Get_Row_Str('BL_V_MATERIAL_REQUISITION',
                      ' AND ORDER_NO=''' || Irow_.Order_No || '''',
                      Mainrowlist_);
  
    --生成材料申请明细
    --调用 初始化函数
  
    Pkg_a.Set_Item_Value('ORDER_NO', Irow_.Order_No, Sqlinerowlist_);
    Pkg_a.Set_Item_Value('LINE_ITEM_NO', '0', Sqlinerowlist_);
  
    Select s_A314.Nextval Into A314_.A314_Key From Dual;
    Insert Into A314
      (A314_Key, A314_Id, State, Enter_User, Enter_Date)
      Select A314_.A314_Key, A314_.A314_Key, '0', User_Id_, Sysdate
        From Dual;
    --获取初始化的值
    Bl_Material_Requis_Line_Api.New__(Sqlinerowlist_,
                                      User_Id_,
                                      A314_.A314_Key);
    --获取返回的初始值  
    Select t.Res
      Into Sq_Config_
      From A314 t
     Where t.A314_Key = A314_.A314_Key
       And Rownum = 1;
  
    Pkg_a.Str_Add_Str(Sq_Config_, Sqlinerowlist_);
  
    Open Cur_ For
      Select Part_No, Sum(Qty) As Qty
        From (Select Bl_Casingstuff_Api.Get_Part_No(T1.Materiel_Id,
                                                    T1.Contract) As Part_No,
                     Sum(T1.Qty_Assembly) As Qty
                From Bl_Putincase_m m
               Inner Join Bl_Putincase_Box t
                  On t.Putincase_No = m.Putincase_No
               Inner Join Bl_Pachage_Det_Tab T1
                  On T1.Pachage_No = t.Pachage_No
                 And T1.Catalog_Key = '1'
               Where m.Picklistno = Mainrow_.Picklistno
                 And m.Supplier = Mainrow_.Supplier
                 And m.State = '2'
                 And m.Pack_Flag = '0'
               Group By Bl_Casingstuff_Api.Get_Part_No(T1.Materiel_Id,
                                                       T1.Contract)
              Union All
              Select T1.Materiel_Id, Sum(T1.Qty_Assembly)
                From Bl_Putincase_m m
               Inner Join Bl_Putincase_Box t
                  On t.Putincase_No = m.Putincase_No
               Inner Join Bl_Pachage_Det_Tab T1
                  On T1.Pachage_No = t.Pachage_No
                 And T1.Catalog_Key = '0'
               Where m.Picklistno = Mainrow_.Picklistno
                 And m.Supplier = Mainrow_.Supplier
                 And m.State = '2'
                 And m.Pack_Flag = '0'
               Group By T1.Materiel_Id
              Union All
              Select Bl_Casingstuff_Api.Get_Part_No(m.Pachage_No, m.Supplier) As Part_No,
                     Count(*)
                From Bl_Putincase_m m
               Inner Join Bl_Putincase_Box t
                  On t.Putincase_No = m.Putincase_No
               Where m.Picklistno = Mainrow_.Picklistno
                 And m.Supplier = Mainrow_.Supplier
                 And m.State = '2'
                 And m.Pack_Flag = '1'
               Group By Bl_Casingstuff_Api.Get_Part_No(m.Pachage_No,
                                                       m.Supplier)) a
       Group By Part_No;
    Fetch Cur_
      Into Casingid_, Sqqty_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '材料申请生成失败，包装配置错误');
      Return;
    End If;
    Loop
      Exit When Cur_%Notfound;
    
      Sqlinerowlist_ := '';
      Pkg_a.Set_Item_Value('DOACTION', 'I', Sqlinerowlist_);
      Pkg_a.Set_Item_Value('OBJID', 'NULL', Sqlinerowlist_);
    
      Pkg_a.Str_Add_Str(Sqlinerowlist_, Sq_Config_);
    
      Pkg_a.Set_Item_Value('PART_NO', Casingid_, Sqlinerowlist_);
    
      Bl_Material_Requis_Line_Api.Itemchange__('PART_NO',
                                               Mainrowlist_,
                                               Sqlinerowlist_,
                                               User_Id_,
                                               Outinerowlist_);
    
      Pkg_a.Str_Add_Str(Sqlinerowlist_, Outinerowlist_);
      Pkg_a.Set_Item_Value('QTY_DUE', Sqqty_, Sqlinerowlist_);
    
      Bl_Material_Requis_Line_Api.Modify__(Sqlinerowlist_,
                                           User_Id_,
                                           A311_.A311_Key);
    
      Fetch Cur_
        Into Casingid_, Sqqty_;
    End Loop;
    Close Cur_;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Mainrow_.Objid);
  
  End;

  --装箱 
  Procedure Set_Pkg(Rowlist_  Varchar2,
                    User_Id_  Varchar2,
                    A311_Key_ Varchar2) Is
    Cur_                  t_Cursor;
    Cur1_                 t_Cursor;
    Cur2_                 t_Cursor;
    Mainrow_              Bl_v_Putincase%Rowtype;
    Detailrow_            Bl_v_Putincase_m_Detail%Rowtype;
    Pachage_Main_         Bl_Pachage_Set_Tab%Rowtype;
    Pachage_Detail_       Bl_Pachage_Det_Tab%Rowtype;
    Putincase_Box_        Bl_Putincase_Box%Rowtype;
    Putincase_Box_Detail_ Bl_Putincase_Box_Detail%Rowtype;
    Objid_                Varchar2(100);
    Temp_Row_             Bl_Temp%Rowtype;
    Itemp_Row_            Bl_Temp_Tab%Rowtype;
    Bl_Casingstuff_       Bl_Casingstuff%Rowtype; --箱子
    Bl_Picklist_          Bl_Picklist%Rowtype;
    Sq_Qty_               Number; --材料申请数量
    --     Bl_Pachage_Set_Tab%rowtype;
    i_      Number;
    Box_Qty Number;
  Begin
  
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的ROWID');
      Return;
    End If;
    Close Cur_;
    Mainrow_.State := '1';
    --更新状态
    Update Bl_Putincase_m t
       Set State     = Mainrow_.State,
           Modi_Date = Sysdate,
           Modi_User = User_Id_
     Where t.Rowid = Mainrow_.Objid;
    --根据不同的包装类型循环明细
    --Putincase_box_.
  
    --默认包装
    Open Cur_ For
      Select t.*
        From Bl_Picklist t
       Where t.Picklistno = Mainrow_.Picklistno;
    Fetch Cur_
      Into Bl_Picklist_;
    Close Cur_;
    If Mainrow_.Pack_Flag = '0' Then
      Putincase_Box_.Putincase_No  := Mainrow_.Putincase_No;
      Putincase_Box_.Line_No       := Nvl(Putincase_Box_.Line_No, 0);
      Putincase_Box_.Box_Newline   := Putincase_Box_.Line_No;
      Putincase_Box_.State         := Mainrow_.State;
      Putincase_Box_.To_Contract   := Mainrow_.Supplier;
      Putincase_Box_.Putright_No   := '-';
      Putincase_Box_.Putright_Line := 0;
      Putincase_Box_.Picklistno    := Mainrow_.Picklistno;
      Putincase_Box_.Contract      := Putincase_Box_.To_Contract;
      Select s_Bl_Temp.Nextval Into Temp_Row_.Tempkey From Dual;
    
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase_m_Detail t
         Where t.Putincase_No = Mainrow_.Putincase_No;
      Fetch Cur_
        Into Detailrow_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error, '没有明细行不能装箱');
      End If;
      Loop
        Exit When Cur_%Notfound;
        /* Get_Pachage(Detailrow_.Catalog_No,
        Bl_Picklist_.Contract,
        Bl_Picklist_.Customer_Ref,
        Mainrow_.Supplier, --工厂域
        Pachage_Main_);*/
        i_ := 0;
        --装箱
        Detailrow_.Box_List        := '#' ||
                                      To_Char(Nvl(Putincase_Box_.Line_No, 0) + 1);
        Putincase_Box_.Detail_Line := Detailrow_.Line_No;
        Putincase_Box_.Pachage_No  := Detailrow_.Pachage_No;
        Putincase_Box_.Qty         := Detailrow_.Qty_Pkg;
        --把箱子的属性赋值给箱子                           
        Putincase_Box_.Casingid       := Detailrow_.Casingid;
        Putincase_Box_.Casingdescribe := Detailrow_.Casingdescribe;
        Putincase_Box_.Casingweight   := Detailrow_.Casingweight;
        Putincase_Box_.Casinglength   := Detailrow_.Casinglength;
        Putincase_Box_.Casingwidth    := Detailrow_.Casingwidth;
        Putincase_Box_.Casingheight   := Detailrow_.Casingheight;
        Putincase_Box_.Casingarea     := Detailrow_.Casingarea;
        Putincase_Box_.Partweight     := Detailrow_.Partweight;
      
        --找箱子对应的ifs物料编码
        Putincase_Box_.Part_No := Detailrow_.Part_No;
      
        If Nvl(Putincase_Box_.Part_No, '-') = '-' Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '配置的箱子' ||
                                  Bl_Casingstuff_.Casingid ||
                                  '对应的PART_NO不存在 ');
          Return;
        
        End If;
        Loop
          Exit When Detailrow_.Qty < Detailrow_.Qty_Pkg;
          --插入一个箱子          
          Putincase_Box_.Line_No           := Nvl(Putincase_Box_.Line_No, 0) + 1;
          Putincase_Box_.Box_Num           := '#' ||
                                              To_Char(Putincase_Box_.Line_No);
          Putincase_Box_.Enter_Date        := Sysdate;
          Putincase_Box_.Enter_User        := User_Id_;
          Putincase_Box_.Putintray_No      := '-';
          Putincase_Box_.Putintray_Line_No := 0;
          Putincase_Box_.Putintray_Id      := '';
          Putincase_Box_.Putintray_Line    := 0;
        
          Insert Into Bl_Putincase_Box
            (Putincase_No, Line_No, Enter_Date, Enter_User)
          Values
            (Putincase_Box_.Putincase_No,
             Putincase_Box_.Line_No,
             Sysdate,
             User_Id_)
          Returning Rowid Into Objid_;
          Update Bl_Putincase_Box
             Set Row = Putincase_Box_
           Where Rowid = Objid_;
          --赋值箱子的信息
          --Putincase_Box_.
        
          Putincase_Box_Detail_.Putincase_No    := Putincase_Box_.Putincase_No;
          Putincase_Box_Detail_.Line_No         := Nvl(Putincase_Box_Detail_.Line_No,
                                                       0) + 1;
          Putincase_Box_Detail_.Detail_Line     := Putincase_Box_.Detail_Line;
          Putincase_Box_Detail_.Box_Line        := Putincase_Box_.Line_No;
          Putincase_Box_Detail_.State           := Putincase_Box_.State;
          Putincase_Box_Detail_.Picklistno      := Detailrow_.Picklistno;
          Putincase_Box_Detail_.Co_Order_No     := Detailrow_.Co_Order_No;
          Putincase_Box_Detail_.Co_Line_No      := Detailrow_.Co_Line_No;
          Putincase_Box_Detail_.Co_Rel_No       := Detailrow_.Co_Rel_No;
          Putincase_Box_Detail_.Co_Line_Item_No := Detailrow_.Co_Line_Item_No;
          Putincase_Box_Detail_.Qty             := Detailrow_.Qty_Pkg;
          Putincase_Box_Detail_.Weight_Net      := Detailrow_.Partweight /
                                                   Putincase_Box_Detail_.Qty;
          --备货单域
          Putincase_Box_Detail_.Contract   := Bl_Picklist_.Contract;
          Putincase_Box_Detail_.Catalog_No := Detailrow_.Catalog_No;
          --产品重量                                                                               
        
          --插入箱子明细
          Insert Into Bl_Putincase_Box_Detail
            (Putincase_No,
             Line_No,
             Detail_Line,
             Box_Line,
             State,
             Picklistno,
             Co_Order_No,
             Co_Line_No,
             Co_Rel_No,
             Co_Line_Item_No,
             Weight_Net,
             Qty,
             Enter_Date,
             Enter_User,
             Contract,
             Catalog_No)
          Values
            (Putincase_Box_Detail_.Putincase_No,
             Putincase_Box_Detail_.Line_No,
             Putincase_Box_Detail_.Detail_Line,
             Putincase_Box_Detail_.Box_Line,
             Putincase_Box_Detail_.State,
             Putincase_Box_Detail_.Picklistno,
             Putincase_Box_Detail_.Co_Order_No,
             Putincase_Box_Detail_.Co_Line_No,
             Putincase_Box_Detail_.Co_Rel_No,
             Putincase_Box_Detail_.Co_Line_Item_No,
             Putincase_Box_Detail_.Weight_Net,
             Putincase_Box_Detail_.Qty,
             Sysdate,
             User_Id_,
             Putincase_Box_Detail_.Contract,
             Putincase_Box_Detail_.Catalog_No);
          Detailrow_.Qty := Detailrow_.Qty - Detailrow_.Qty_Pkg;
          i_             := i_ + 1;
        End Loop;
        If i_ = 0 Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '数量太少不够装箱');
          Return;
        End If;
        Detailrow_.Box_List := Detailrow_.Box_List || '-' || '#' ||
                               To_Char(Nvl(Putincase_Box_.Line_No, 0));
        Update Bl_Putincase_m_Detail t
           Set Box_List     = Detailrow_.Box_List,
               Qty          = Qty - Detailrow_.Qty,
               t.State      = Mainrow_.State,
               t.Box_Qty    = i_,
               t.Onebox_Qty = Detailrow_.Qty_Pkg
         Where t.Rowid = Detailrow_.Objid;
      
        Set_Box_Qty(Detailrow_.Putincase_No, Detailrow_.Line_No);
        Fetch Cur_
          Into Detailrow_;
      End Loop;
      Close Cur_;
    End If;
    --混合包装
    If Mainrow_.Pack_Flag = '1' Then
      --箱数
      --找箱子对应的ifs物料编码
      Putincase_Box_.Putincase_No  := Mainrow_.Putincase_No;
      Putincase_Box_.Line_No       := Nvl(Putincase_Box_.Line_No, 0);
      Putincase_Box_.State         := Mainrow_.State;
      Putincase_Box_.Detail_Line   := 0;
      Putincase_Box_.To_Contract   := Mainrow_.Supplier;
      Putincase_Box_.Putright_No   := '-';
      Putincase_Box_.Putright_Line := 0;
      Putincase_Box_.Qty           := Mainrow_.Box_Qty;
      Putincase_Box_.Part_No       := Bl_Casingstuff_Api.Get_Part_No(Mainrow_.Casingid,
                                                                     Mainrow_.Supplier);
      If Nvl(Putincase_Box_.Part_No, '-') = '-' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                Detailrow_.Catalog_No || '配置的装箱的在箱子' ||
                                Bl_Casingstuff_.Casingid ||
                                '对应的PART_NO不存在 ');
        Return;
      
      End If;
      Select s_Bl_Temp.Nextval Into Temp_Row_.Tempkey From Dual;
      Putincase_Box_.Casingid       := Mainrow_.Casingid;
      Putincase_Box_.Casingdescribe := Mainrow_.Casingdescribe;
      Putincase_Box_.Casingweight   := Mainrow_.Casingweight;
      Putincase_Box_.Casinglength   := Mainrow_.Casinglength;
      Putincase_Box_.Casingwidth    := Mainrow_.Casingwidth;
      Putincase_Box_.Casingheight   := Mainrow_.Casingheight;
      Putincase_Box_.Contract       := Mainrow_.Supplier;
      i_                            := 10000000;
      Putincase_Box_.Casingarea     := Mainrow_.Casingweight *
                                       Mainrow_.Casinglength *
                                       Mainrow_.Casingwidth;
      Putincase_Box_.Picklistno     := Mainrow_.Picklistno;
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase_m_Detail t
         Where t.Putincase_No = Mainrow_.Putincase_No;
      Fetch Cur_
        Into Detailrow_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error, '没有明细行不能装箱');
      End If;
      Loop
        Exit When Cur_%Notfound;
        If Detailrow_.Qty < Detailrow_.Qty_Pkg Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '数量太少不够装箱');
          Return;
        End If;
        If Round(Detailrow_.Qty_Pkg, 0) <> Detailrow_.Qty_Pkg Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '配比错误');
          Return;
        End If;
        Box_Qty := Floor(Detailrow_.Qty / Detailrow_.Qty_Pkg);
        If Box_Qty < i_ Then
          i_ := Box_Qty;
        End If;
        Fetch Cur_
          Into Detailrow_;
      End Loop;
      Close Cur_;
      If i_ = 0 Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                Detailrow_.Catalog_No || '数量太少不够装箱');
        Return;
      
      End If;
      --开始装箱
      Box_Qty := i_;
      i_      := 0;
      Loop
        --插入一个箱子 
        Exit When i_ >= Box_Qty;
        Putincase_Box_.Line_No           := Nvl(Putincase_Box_.Line_No, 0) + 1;
        Putincase_Box_.Box_Newline       := Putincase_Box_.Line_No;
        Putincase_Box_.Box_Num           := '#' ||
                                            To_Char(Putincase_Box_.Line_No);
        Putincase_Box_.Partweight        := 0;
        Putincase_Box_.Enter_Date        := Sysdate;
        Putincase_Box_.Enter_User        := User_Id_;
        Putincase_Box_.Putintray_No      := '-';
        Putincase_Box_.Putintray_Line_No := 0;
        Putincase_Box_.Putintray_Id      := '';
        Putincase_Box_.Putintray_Line    := 0;
        --插入箱子明细        
        Insert Into Bl_Putincase_Box
          (Putincase_No, Line_No, Enter_Date, Enter_User)
        Values
          (Putincase_Box_.Putincase_No,
           Putincase_Box_.Line_No,
           Sysdate,
           User_Id_)
        Returning Rowid Into Objid_;
      
        Open Cur_ For
          Select t.*
            From Bl_v_Putincase_m_Detail t
           Where t.Putincase_No = Mainrow_.Putincase_No;
        Fetch Cur_
          Into Detailrow_;
        Loop
          Exit When Cur_%Notfound;
          Putincase_Box_Detail_.Putincase_No    := Putincase_Box_.Putincase_No;
          Putincase_Box_Detail_.Line_No         := Nvl(Putincase_Box_Detail_.Line_No,
                                                       0) + 1;
          Putincase_Box_Detail_.Detail_Line     := Putincase_Box_.Detail_Line;
          Putincase_Box_Detail_.Box_Line        := Putincase_Box_.Line_No;
          Putincase_Box_Detail_.State           := Putincase_Box_.State;
          Putincase_Box_Detail_.Picklistno      := Detailrow_.Picklistno;
          Putincase_Box_Detail_.Co_Order_No     := Detailrow_.Co_Order_No;
          Putincase_Box_Detail_.Co_Line_No      := Detailrow_.Co_Line_No;
          Putincase_Box_Detail_.Co_Rel_No       := Detailrow_.Co_Rel_No;
          Putincase_Box_Detail_.Co_Line_Item_No := Detailrow_.Co_Line_Item_No;
          Putincase_Box_Detail_.Qty             := Detailrow_.Qty_Pkg;
          Putincase_Box_Detail_.Weight_Net      := Detailrow_.Partweight /
                                                   Putincase_Box_Detail_.Qty;
          --备货单域
          Putincase_Box_Detail_.Contract   := Bl_Picklist_.Contract;
          Putincase_Box_Detail_.Catalog_No := Detailrow_.Catalog_No;
          Putincase_Box_.Partweight        := Nvl(Putincase_Box_.Partweight,
                                                  0) +
                                              Nvl(Detailrow_.Partweight, 0);
          --插入箱子明细
          Insert Into Bl_Putincase_Box_Detail
            (Putincase_No,
             Line_No,
             Detail_Line,
             Box_Line,
             State,
             Picklistno,
             Co_Order_No,
             Co_Line_No,
             Co_Rel_No,
             Co_Line_Item_No,
             Qty,
             Weight_Net,
             Enter_Date,
             Enter_User,
             Contract,
             Catalog_No)
          Values
            (Putincase_Box_Detail_.Putincase_No,
             Putincase_Box_Detail_.Line_No,
             Putincase_Box_Detail_.Detail_Line,
             Putincase_Box_Detail_.Box_Line,
             Putincase_Box_Detail_.State,
             Putincase_Box_Detail_.Picklistno,
             Putincase_Box_Detail_.Co_Order_No,
             Putincase_Box_Detail_.Co_Line_No,
             Putincase_Box_Detail_.Co_Rel_No,
             Putincase_Box_Detail_.Co_Line_Item_No,
             Putincase_Box_Detail_.Qty,
             Putincase_Box_Detail_.Weight_Net,
             Sysdate,
             User_Id_,
             Putincase_Box_Detail_.Contract,
             Putincase_Box_Detail_.Catalog_No);
        
          Fetch Cur_
            Into Detailrow_;
        End Loop;
        Close Cur_;
        Update Bl_Putincase_Box t
           Set Row = Putincase_Box_
         Where t.Rowid = Objid_;
        i_ := i_ + 1;
      End Loop;
      Update Bl_Putincase_m_Detail t
         Set t.Qty        = t.Qty_Pkg * i_,
             t.State      = Mainrow_.State,
             t.Onebox_Qty = Mainrow_.Box_Qty
       Where t.Putincase_No = Mainrow_.Putincase_No;
    
      Set_Box_Qty(Mainrow_.Putincase_No, 0);
      Itemp_Row_.Tempkey := Temp_Row_.Tempkey;
      Itemp_Row_.Rowkey  := Putincase_Box_.Part_No;
      Pkg_a.Set_Item_Value('QTY', Box_Qty, Itemp_Row_.Rowlist);
      Insert Into Bl_Temp_Tab
        (Tempkey, Rowkey, Rowlist)
      Values
        (Itemp_Row_.Tempkey, Itemp_Row_.Rowkey, Itemp_Row_.Rowlist) Return Rowid Into Temp_Row_.Objid;
    End If;
    --材料申请
    Open Cur_ For
      Select t.* From Bl_Temp_Tab t Where t.Tempkey = Temp_Row_.Tempkey;
    Fetch Cur_
      Into Itemp_Row_;
    Loop
      Exit When Cur_%Notfound;
      Fetch Cur_
        Into Itemp_Row_;
    End Loop;
  
    Close Cur_;
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '装箱成功');
  
    Return;
  End;
  --装箱下达
  Procedure Release__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
    Cur_                t_Cursor;
    Mainrow_            Bl_v_Putincase%Rowtype;
    Checkrow_           Bl_v_Putincase%Rowtype;
    Sqrowlist_          Varchar2(4000);
    Sqlinerowlist_      Varchar2(4000);
    Outinerowlist_      Varchar2(4000);
    Sq_Config_          Varchar2(4000);
    A311_               A311%Rowtype;
    Irow_               Bl_v_Material_Requisition%Rowtype;
    Detrow_             Bl_Putincase_Box%Rowtype;
    Sqqty_              Number;
    Casingid_           Varchar2(40);
    A314_               A314%Rowtype;
    Mainrowlist_        Varchar2(4000);
    Bl_v_Putincase_V01_ Bl_v_Putincase_V01%Rowtype;
    Bl_Putincase_m_     Bl_Putincase_m%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的ROWID');
      Return;
    End If;
    Close Cur_;
    /* If Mainrow_.State != '1' Then
      Raise_Application_Error(Pkg_a.Raise_Error, '只有装箱了才能下达');
      Return;
    End If;*/
    --判断当前行是否有明细
    Open Cur_ For
      Select t.*
        From Bl_Putincase_Box t
       Where t.Putincase_No = Mainrow_.Putincase_No;
    Fetch Cur_
      Into Detrow_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Mainrow_.Putincase_No || '未装箱');
      Return;
    
    End If;
    Close Cur_;
    --作废空头
    Update Bl_Putincase_m t
       Set t.State = '3'
     Where t.Picklistno = Mainrow_.Picklistno
       And t.Supplier = Mainrow_.Supplier
       And Not Exists (Select 1
              From Bl_Putincase_m_Detail T1
             Where T1.Putincase_No = t.Putincase_No);
  
    --判断其他当前工厂其他的装箱信息是否已经装箱
    Open Cur_ For
      Select t.*
        From Bl_v_Putincase t
       Where t.Picklistno = Mainrow_.Picklistno
         And t.Supplier = Mainrow_.Supplier
         And t.State = '0';
    Fetch Cur_
      Into Checkrow_;
    If Cur_ %Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Checkrow_.Putincase_No || '未装箱');
      Return;
    End If;
    Close Cur_;
    Open Cur_ For
      Select t.*
        From Bl_Putincase_m t
       Where t.Picklistno = Mainrow_.Picklistno
         And t.Supplier = Mainrow_.Supplier
         And t.State In ('1');
    Fetch Cur_
      Into Bl_Putincase_m_;
    Loop
      Exit When Cur_%Notfound;
      Update Bl_Putincase_m t
         Set t.State = '2'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No;
    
      Update Bl_Putincase_m_Detail t
         Set t.State = '2'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No;
    
      Update Bl_Putincase_Box t
         Set t.State = '2'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No
         And t.To_Contract = Mainrow_.Supplier;
    
      Update Bl_Putincase_Box_Detail t
         Set t.State = '2'
       Where (t.Putincase_No, t.Box_Line) In
             (Select T1.Putincase_No, T1.Line_No
                From Bl_Putincase_Box T1
               Where T1.Putincase_No = Bl_Putincase_m_.Putincase_No
                 And T1.To_Contract = Mainrow_.Supplier);
    
      Fetch Cur_
        Into Bl_Putincase_m_;
    End Loop;
    Close Cur_;
  
    --如果全部已经装箱 生成材料申请
    Set_Material_Requisition(Rowlist_, User_Id_, A311_Key_);
    --生成包装资料
    -- Setpick__(Rowlist_, User_Id_, A311_Key_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Mainrow_.Objid);
    Pkg_a.Setmsg(A311_Key_, '', '预生成成功');
  End;

  Procedure Appvoe___(Picklistno_ In Varchar2,
                      Contract_   In Varchar2,
                      User_Id_    In Varchar2) Is
    Checkrow_           Bl_v_Putincase%Rowtype;
    Cur_                t_Cursor;
    Bl_Putincase_m_     Bl_Putincase_m%Rowtype;
    Bl_v_Putincase_V01_ Bl_v_Putincase_V01%Rowtype;
    Cur1_               t_Cursor;
    Cur2_               t_Cursor;
    Bl_Putin_           Bl_Putin%Rowtype;
    Cbl_Putin_          Bl_Putin%Rowtype;
  Begin
    --作废空头
    Update Bl_Putincase_m t
       Set t.State = '3'
     Where t.Picklistno = Picklistno_
       And t.Supplier = Contract_
       And Not Exists (Select 1
              From Bl_Putincase_m_Detail T1
             Where T1.Putincase_No = t.Putincase_No);
  
    --检测备货单是否已经装箱完
    Open Cur_ For
      Select t.*
        From Bl_v_Putincase_V01 t
       Where t.Pickuniteno = Picklistno_
         And t.Supplier = Contract_
         And t.Pickqty <> t.Qty;
    Fetch Cur_
      Into Bl_v_Putincase_V01_;
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '装箱未完成，' || Bl_v_Putincase_V01_.Catalog_No || '(' ||
                              Bl_v_Putincase_V01_.Catalog_Desc || ')的数量' ||
                              To_Char(Bl_v_Putincase_V01_.Pickqty) ||
                              '只装箱了' || To_Char(Bl_v_Putincase_V01_.Qty));
      Return;
    End If;
    Close Cur_;
  
    --判断其他当前工厂其他的装箱信息是否已经装箱
    Open Cur_ For
      Select t.*
        From Bl_v_Putincase t
       Where t.Picklistno = Picklistno_
         And t.Supplier = Contract_
         And t.State = '0';
    Fetch Cur_
      Into Checkrow_;
    If Cur_ %Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Checkrow_.Putincase_No || '未装箱');
      Return;
    End If;
    Close Cur_;
    Open Cur_ For
      Select t.*
        From Bl_Putincase_m t
       Where t.Picklistno = Picklistno_
         And t.Supplier = Contract_
         And t.State In ('1', '2');
    Fetch Cur_
      Into Bl_Putincase_m_;
    Loop
      Exit When Cur_%Notfound;
      Update Bl_Putincase_m t
         Set t.State = '4'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No;
    
      Update Bl_Putincase_m_Detail t
         Set t.State = '4'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No;
    
      Update Bl_Putincase_Box t
         Set t.State = '4'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No
         And t.To_Contract = Contract_;
    
      Update Bl_Putincase_Box_Detail t
         Set t.State = '4'
       Where (t.Putincase_No, t.Box_Line) In
             (Select T1.Putincase_No, T1.Line_No
                From Bl_Putincase_Box T1
               Where T1.Putincase_No = Bl_Putincase_m_.Putincase_No
                 And T1.To_Contract = Contract_);
    
      Open Cur1_ For
        Select t.Putincase_No, t.Detail_Line, Count(*)
          From Bl_Putincase_Box t
         Where t.Putincase_No = Bl_Putincase_m_.Putincase_No
           And t.To_Contract = Contract_
         Group By t.Putincase_No, t.Detail_Line;
    
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
                                    Bl_Putin_.Putin_No || '提交的箱子数量(' ||
                                    Bl_Putin_.Qty || ')必须和第一次提交的箱子数量' ||
                                    Cbl_Putin_.Qty || '一致！');
          
          End If;
        
        End If;
        Close Cur2_;
      
        Fetch Cur1_
          Into Bl_Putin_.Putin_No, Bl_Putin_.Line_No, Bl_Putin_.Qty;
      End Loop;
      Close Cur1_;
    
      Fetch Cur_
        Into Bl_Putincase_m_;
    End Loop;
    Close Cur_;
    --把数据写入 BL_PUTIN 合计表中
  
  End;

  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Row_ Bl_v_Putincase%Rowtype;
    Cur_ t_Cursor;
  Begin
    Row_.Objid := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    --主档状态改为2
    Update Bl_Putincase_m t
       Set t.State = '3', t.Modi_Date = Sysdate, t.Modi_User = User_Id_
     Where t.Rowid = Row_.Objid;
    --明细状态改为2
    Update Bl_Putincase_m_Detail t
       Set t.State = '3', t.Modi_Date = Sysdate, t.Modi_User = User_Id_
     Where t.Putincase_No = Row_.Putincase_No;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Row_.Objid);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '包装资料' || '[' || Row_.Putincase_No || ']' || '作废成功');
  End;
  --获取产品的包装内容 
  Procedure Get_Pachage(Catalog_No_   Varchar2,
                        Contract_     In Varchar2,
                        Customer_No_  In Varchar2,
                        Pkg_Contract_ In Varchar2,
                        Pachage_Main_ Out Bl_Pachage_Set_Tab%Rowtype) Is
    Cur_ t_Cursor;
  Begin
    --找默认包装
    Open Cur_ For
      Select t.*
        From Bl_Pachage_Set_Tab t
       Where t.Catalog_No = Catalog_No_
         And t.Customer_No = Customer_No_
         And t.Supplier = Contract_
         And t.State = '1';
    Fetch Cur_
      Into Pachage_Main_;
    If Cur_%Notfound Then
      Close Cur_;
    
      Open Cur_ For
        Select t.*
          From Bl_Pachage_Set_Tab t
         Where t.Catalog_No = Catalog_No_
           And t.Supplier = Pkg_Contract_
           And t.Default_Flag = '1'
           And t.State = '1';
      Fetch Cur_
        Into Pachage_Main_;
      If Cur_%Notfound Then
        Close Cur_;
        /*Raise_Application_Error(Pkg_a.Raise_Error,
        Catalog_No_ || '没有配置包装');*/
        Return;
      Else
        Close Cur_;
      End If;
    Else
      Close Cur_;
    End If;
  
  End;
  --批量修改重量
  Procedure Modi_Weight_All__(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2) Is
    Row_     Bl_v_Putincase_Box%Rowtype;
    Rowline_ Bl_Putincase_Box%Rowtype;
    Cur_     t_Cursor;
  Begin
    Row_.Objid          := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Rowline_.Partweight := Pkg_a.Get_Item_Value('PARTWEIGHT', Rowlist_);
    Open Cur_ For
      Select t.* From Bl_v_Putincase_Box t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    Update Bl_Putincase_Box t
       Set t.Partweight = Rowline_.Partweight
     Where t.Putincase_No = Row_.Putincase_No
       And t.Detail_Line = Row_.Detail_Line;
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE_BOX', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '全部重量修改成功');
  
  End;
  --单箱修改
  Procedure Modi_Weight__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
    Row_     Bl_v_Putincase_Box%Rowtype;
    Rowline_ Bl_Putincase_Box%Rowtype;
    Cur_     t_Cursor;
  Begin
    Row_.Objid          := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Rowline_.Partweight := Pkg_a.Get_Item_Value('PARTWEIGHT', Rowlist_);
    Open Cur_ For
      Select t.* From Bl_v_Putincase_Box t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    Update Bl_Putincase_Box t
       Set t.Partweight = Rowline_.Partweight
     Where t.Rowid = Row_.Objid;
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE_BOX', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '单箱重量修改成功');
  End;
  --拆单个箱子
  Procedure Modi_Box__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
    Row_       Bl_v_Putincase_Box%Rowtype;
    Rowline_   Bl_Putincase_Box%Rowtype;
    Mainrow_   Bl_v_Putincase%Rowtype;
    Boxdetail_ Bl_Putincase_Box_Detail%Rowtype;
    Line_      Bl_v_Putincase_m_Detail%Rowtype;
    Boxrow_    Bl_v_Putincase_Box%Rowtype;
    Cur_       t_Cursor;
    Qty_       Number;
  Begin
    Row_.Objid := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_v_Putincase_Box t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    If Nvl(Row_.Putright_No, '-') <> '-' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '当前箱子已经授权给' || Row_.Tp_Contract);
      Return;
    End If;
  
    If Row_.Putintray_No <> '-' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '当前箱子已经打了托盘，不能拆箱子，请先拆托盘');
      Return;
    End If;
  
    Select t.Pack_Flag
      Into Mainrow_.Pack_Flag
      From Bl_Putincase_m t
     Where t.Putincase_No = Row_.Putincase_No;
  
    Open Cur_ For
      Select t.*
        From Bl_Putincase_Box_Detail t
       Where t.Putincase_No = Row_.Putincase_No
         And t.Box_Line = Row_.Line_No;
    Fetch Cur_
      Into Boxdetail_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的箱子号');
      Return;
    End If;
    Close Cur_;
    If Row_.State <> '1' And Row_.State <> '2' Then
      Raise_Application_Error(Pkg_a.Raise_Error, '当前状态不能拆箱');
      Return;
    End If;
  
    --是否打了托盘
    If Row_.Putintray_No <> '-' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '存在打托盘的箱子，不能拆箱，必须先拆托盘' || Row_.Putintray_No);
    End If;
    If Row_.Putright_No <> '-' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '存在授权给其他域的的箱子，不能拆箱，必须先取消授权' ||
                              Row_.Putright_No);
    
    End If;
  
    --删除装箱明细
    Delete From Bl_Putincase_Box_Detail t
     Where t.Putincase_No = Row_.Putincase_No
       And t.Box_Line = Row_.Line_No;
    --删除 装箱箱子列表
    Delete From Bl_Putincase_Box t Where t.Rowid = Row_.Objid;
    If Mainrow_.Pack_Flag = '0' Then
      --包装类型  0为默认包装  
      --扣掉备货单包装明细数量
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase_m_Detail t
         Where t.Putincase_No = Row_.Putincase_No
           And t.Line_No = Row_.Detail_Line;
      Fetch Cur_
        Into Line_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的箱子号');
        Return;
      End If;
      Close Cur_;
      Update Bl_Putincase_m_Detail t
         Set t.Qty = Nvl(Line_.Qty, 0) - Nvl(Line_.Qty_Pkg, 0)
       Where t.Putincase_No = Row_.Putincase_No
         And t.Line_No = Row_.Detail_Line;
    End If;
    If Mainrow_.Pack_Flag = '1' Then
      --1为混合包装
      Update Bl_Putincase_m_Detail t
         Set t.Qty = Nvl(Line_.Qty, 0) - Nvl(Line_.Qty_Pkg, 0)
       Where t.Putincase_No = Row_.Putincase_No;
    End If;
  
    Set_Box_Qty(Row_.Putincase_No, Row_.Detail_Line);
  
    --把数量修改掉   
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_PUTINCASE_M_DETAIL', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '单个箱子拆除成功');
  End;

  --拆全部箱子 
  Procedure Modi_Allbox__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
    Row_       Bl_v_Putincase_Box%Rowtype;
    Rowline_   Bl_Putincase_Box%Rowtype;
    Mainrow_   Bl_v_Putincase%Rowtype;
    Boxdetail_ Bl_Putincase_Box_Detail%Rowtype;
    Line_      Bl_v_Putincase_m_Detail%Rowtype;
    Boxrow_    Bl_v_Putincase_Box%Rowtype;
    Cur_       t_Cursor;
  Begin
    Row_.Objid := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_v_Putincase_Box t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    If Row_.State <> '1' And Row_.State <> '2' Then
      Raise_Application_Error(-20101, '当前状态不能拆箱');
      Return;
    End If;
    --判断授权数量  如果有授权就不允许整体拆箱
  
    --判断有没有托盘号 
    --是否打了托盘
    Open Cur_ For
      Select t.*
        From Bl_v_Putincase_Box t
       Where t.Putincase_No = Row_.Putincase_No
         And t.Detail_Line = Row_.Detail_Line
         And (t.Putintray_No <> '-' Or t.Putright_No <> '-');
    Fetch Cur_
      Into Row_;
    If Cur_%Found Then
      Close Cur_;
      If Row_.Putintray_No <> '-' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '存在打托盘的箱子，不能拆箱，必须先拆托盘' || Row_.Putintray_No);
      End If;
      If Row_.Putright_No <> '-' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '存在授权给其他域的的箱子，不能拆箱，必须先取消授权' ||
                                Row_.Putright_No);
      
      End If;
      Return;
    End If;
    Close Cur_;
  
    --删除装箱明细
    Delete From Bl_Putincase_Box_Detail t
     Where t.Putincase_No = Row_.Putincase_No
       And t.Detail_Line = Row_.Detail_Line;
    --删除装箱箱子列表
    Delete From Bl_Putincase_Box t
     Where t.Putincase_No = Row_.Putincase_No
       And t.Detail_Line = Row_.Detail_Line;
    If Row_.Detail_Line > 0 Then
      --清空备货单明细数量
      Update Bl_Putincase_m_Detail t
         Set t.Qty = 0
       Where t.Putincase_No = Row_.Putincase_No
         And t.Line_No = Row_.Detail_Line;
    Else
      --混合包装 把状态设置为
      Update Bl_Putincase_m_Detail t
         Set t.Qty = 0
       Where t.Putincase_No = Row_.Putincase_No;
    End If;
    Set_Box_Qty(Row_.Putincase_No, Row_.Detail_Line);
    Pkg_a.Setsuccess(A311_Key_, 'BL_PUTINCASE_M_DETAIL', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '全部箱子拆除成功');
  End;
  Procedure Set_Pick_All(Picklistno_ In Varchar2) Is
    Cur_           t_Cursor;
    Putincase_Box_ Bl_Putincase_Box%Rowtype;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Putincase_Box t
       Inner Join Bl_Putincase_m T1
          On T1.Putincase_No = t.Putincase_No
         And T1.Picklistno = Picklistno_
       Where t.Putintray_No <> '-';
    Fetch Cur_
      Into Putincase_Box_;
    --打托盘的产品先排序
    Loop
      Exit When Cur_%Notfound;
      --
    
      Fetch Cur_
        Into Putincase_Box_;
    End Loop;
    Close Cur_;
  
    -- BL_V_PUTINCASE_ONECASE
    Return;
  End;

  --提交
  Procedure Srelease__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
  
    Cur_      t_Cursor;
    Mainrow_  Bl_v_Putincase%Rowtype;
    Checkrow_ Bl_v_Putincase%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的ROWID');
      Return;
    End If;
    Close Cur_;
    If Mainrow_.State <> '2' And Mainrow_.State <> '1' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '当前状态不能提交包装资料');
      Return;
    End If;
    --生成包装资料
    Bl_Putintray_Api.Set_Pick___(Mainrow_.Picklistno,
                                 Mainrow_.Supplier,
                                 User_Id_);
  
    Bl_Putincase_Api.Set_Pick___(Mainrow_.Picklistno,
                                 Mainrow_.Supplier,
                                 User_Id_);
  
    --提交
    Bl_Putincase_Api.Appvoe___(Mainrow_.Picklistno,
                               Mainrow_.Supplier,
                               User_Id_);
    Bl_Putintray_Api.Appvoe___(Mainrow_.Picklistno,
                               Mainrow_.Supplier,
                               User_Id_);
  
    --生成包装资料
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '提交包装资料成功');
    Return;
  End;
  Procedure Cancelappvoe___(Picklistno_ In Varchar2,
                            Contract_   In Varchar2,
                            User_Id_    In Varchar2) Is
    Checkrow_       Bl_v_Putincase%Rowtype;
    Cur_            t_Cursor;
    Bl_Putincase_m_ Bl_Putincase_m%Rowtype;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Putincase_m t
       Where t.Picklistno = Picklistno_
         And t.Supplier = Contract_
         And t.State = '4';
    Fetch Cur_
      Into Bl_Putincase_m_;
    Loop
      Exit When Cur_%Notfound;
      Update Bl_Putincase_m t
         Set t.State = '2'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No;
    
      Update Bl_Putincase_m_Detail t
         Set t.State = '2'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No;
    
      Update Bl_Putincase_Box t
         Set t.State = '2'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No
         And t.To_Contract = Contract_;
    
      Update Bl_Putincase_Box_Detail t
         Set t.State = '2'
       Where (t.Putincase_No, t.Box_Line) In
             (Select T1.Putincase_No, T1.Line_No
                From Bl_Putincase_Box T1
               Where T1.Putincase_No = Bl_Putincase_m_.Putincase_No
                 And T1.To_Contract = Contract_);
    
      Fetch Cur_
        Into Bl_Putincase_m_;
    End Loop;
    Close Cur_;
  
  End;
  --取消提交
  Procedure Releasecancel__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2) Is
    Cur_      t_Cursor;
    Mainrow_  Bl_v_Putincase%Rowtype;
    Checkrow_ Bl_v_Putincase%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的ROWID');
      Return;
    End If;
    Close Cur_;
    If Mainrow_.State != '4' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '当前状态不能取消提交包装资料');
      Return;
    End If;
  
    Bl_Putincase_Api.Cancelappvoe___(Mainrow_.Picklistno,
                                     Mainrow_.Supplier,
                                     User_Id_);
    Bl_Putintray_Api.Cancelappvoe___(Mainrow_.Picklistno,
                                     Mainrow_.Supplier,
                                     User_Id_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '退回包装资料成功');
    Return;
  End;
  --生成包装资料
  Procedure Setpick__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
  
    Cur_     t_Cursor;
    Mainrow_ Bl_v_Putincase%Rowtype;
  
  Begin
    --修改状态 --
    Release__(Rowlist_, User_Id_, A311_Key_);
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的ROWID');
      Return;
    End If;
    Close Cur_;
    If Mainrow_.State != '2' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '只有下达了才能生成包装资料');
      Return;
    End If;
    Bl_Putincase_Api.Set_Pick___(Mainrow_.Picklistno,
                                 Mainrow_.Supplier,
                                 User_Id_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Mainrow_.Objid);
    Pkg_a.Setmsg(A311_Key_, '', '生成包装资料成功');
    Return;
  End;

  --生成包装资料
  Procedure Set_Pick___(Picklistno_ In Varchar2,
                        Contract_   In Varchar2,
                        User_Id_    In Varchar2) Is
    Cur_                t_Cursor;
    Cur1_               t_Cursor;
    Putincase_Box_      Bl_Putincase_Box%Rowtype;
    i_                  Number;
    Bl_v_Putincase_V01_ Bl_v_Putincase_V01%Rowtype;
  Begin
    /* --检测备货单是否已经装箱完
    Open Cur_ For
      Select t.*
        From Bl_v_Putincase_V01 t
       Where t.Pickuniteno = Picklistno_
         And t.To_Contract = Contract_
         And t.Pickqty <> t.Qty;
    Fetch Cur_
      Into Bl_v_Putincase_V01_;
    
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '装箱未完成，' || Bl_v_Putincase_V01_.Catalog_No || '(' ||
                              Bl_v_Putincase_V01_.Catalog_Desc || ')的数量' ||
                              To_Char(Bl_v_Putincase_V01_.Pickqty) ||
                              '只装箱了' || To_Char(Bl_v_Putincase_V01_.Qty));
      Return;
    End If;
    Close Cur_;*/
  
    i_ := 0;
    Open Cur_ For
      Select t.*
        From Bl_Putincase_Box t
       Inner Join Bl_Putincase_m T1
          On T1.Putincase_No = t.Putincase_No
         And T1.Picklistno = Picklistno_
      -- And (T1.State = '2' Or T1.State = '1' Or T1.State = '1' )
      -- Where t.To_Contract = Contract_
       Order By t.Putincase_No      Asc,
                t.Detail_Line       Asc,
                t.Putintray_No      Asc,
                t.Putintray_Newline Asc,
                t.Partweight;
    Fetch Cur_
      Into Putincase_Box_;
    Loop
      Exit When Cur_%Notfound;
      i_ := i_ + 1;
      Update Bl_Putincase_Box t
         Set t.Box_Newline = i_,
             t.Box_Num     = '#' || To_Char(i_),
             t.Modi_Date   = Sysdate,
             t.Modi_User   = User_Id_
       Where t.Putincase_No = Putincase_Box_.Putincase_No
         And t.Line_No = Putincase_Box_.Line_No;
      Fetch Cur_
        Into Putincase_Box_;
    End Loop;
    Close Cur_;
  
    Update Bl_Putincase_m t
       Set t.State = '3' --作废 没有箱子
     Where t.Picklistno = Picklistno_
       And t.Supplier = Contract_
       And Not Exists (Select 1
              From Bl_Putincase_Box T1
             Where T1.Putincase_No = t.Putincase_No);
  
    Update Bl_Putincase_m_Detail t
       Set t.State = '3' --作废 没有箱子
     Where t.Putincase_No In (Select Putincase_No
                                From Bl_Putincase_m T1
                               Where T1.Picklistno = Picklistno_
                                 And T1.Supplier = Contract_
                                 And State = '3');
  
  End;
  --修改箱子总数
  Procedure Set_Box_Qty(Putincase_No_ In Varchar2, Detail_Line_ In Number) Is
    Cur_           t_Cursor;
    Box_Qty_       Number;
    Putincase_Box_ Bl_Putincase_Box%Rowtype;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Putincase_Box t
       Where t.Putincase_No = Putincase_No_
         And t.Detail_Line = Detail_Line_;
    Fetch Cur_
      Into Putincase_Box_;
    Close Cur_;
  
    Open Cur_ For
      Select Count(*)
        From Bl_Putincase_Box t
       Where t.Putincase_No = Putincase_No_
         And t.Detail_Line = Detail_Line_;
    --重量
    Fetch Cur_
      Into Box_Qty_;
    Close Cur_;
    Update Bl_Putincase_Box t
       Set t.Box_Qty = Box_Qty_
     Where t.Putincase_No = Putincase_No_
       And t.Line_No = Detail_Line_;
  
    --修改主档的状态 如果是装箱状态 修改为 保存  
    Delete From Bl_Putincase_m_Detail
     Where Putincase_No = Putincase_No_
       And Nvl(Qty, 0) = 0;
    Open Cur_ For
      Select 1
        From Bl_Putincase_m_Detail t
       Where t.Putincase_No = Putincase_No_;
    Fetch Cur_
      Into Box_Qty_;
    If Cur_%Notfound Then
      Update Bl_Putincase_m
         Set State = '0'
       Where Putincase_No = Putincase_No_
         And State In ('1', '2');
    End If;
    Close Cur_;
  End;
  Function Get_Report_Data(Type_Id_ In Varchar2, Parmlist_ In Varchar2)
    Return Varchar Is
    Cur_     t_Cursor;
    Sql_     Varchar2(4000);
    Result_  Varchar2(100);
    Result1_ Varchar2(100);
  Begin
    If Nvl(Parmlist_, '-') = '-' Then
      Return Null;
    End If;
    --获取备货单的总体积 =  Sum(箱子体积) 
    If Type_Id_ = 'SUM_AREA' Then
      Open Cur_ For
        Select Sum(t.Casinglength * t.Casingwidth * t.Casingheight) As Sum_Area
          From Bl_Putincase_Box t
         Inner Join Bl_Putincase_m T1
            On T1.Putincase_No = t.Putincase_No
           And T1.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    --获取备货单的总重量 =  Sum() 
    If Type_Id_ = 'SUM_WEIGHT' Then
      Open Cur_ For
        Select Sum(Nvl(t.Partweight, 0)) As Sum_Area
          From Bl_Putincase_Box t
         Inner Join Bl_Putincase_m T1
            On T1.Putincase_No = t.Putincase_No
           And T1.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
    --获取备货单的托盘上的箱子总重量 =  Sum() 
    If Type_Id_ = 'SUM_WEIGHT_0' Then
      Open Cur_ For
        Select Sum(Nvl(t.Partweight, 0) + t.Casingweight) As Sum_Area
          From Bl_Putincase_Box t
         Inner Join Bl_Putincase_m T1
            On T1.Putincase_No = t.Putincase_No
           And T1.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    --获取备货单的总重量(只托盘) =  Sum() 
    If Type_Id_ = 'SUM_WEIGHT_1' Then
      Open Cur_ For
        Select Sum(t.Nweight + t.Cweight) As Sum_Area
          From Bl_Putintray_Tray t;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    --获取每个托盘上的箱子重量(只托盘)
    If Type_Id_ = 'SINGLE_TRAY_BOX_WEIGHT' Then
      Open Cur_ For
        Select (t.Nweight + t.Cweight) As Sum_Tray_Box_Weight
          From Bl_Putintray_Tray t
         Inner Join Bl_Putintray_m T1
            On T1.Putintray_No = t.Putintray_No
         Where t.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    --获取备货单的总重量（仅箱子） =  Sum() 
    If Type_Id_ = 'SUM_BOX_WEIGHT' Then
      Open Cur_ For
        Select Sum(Nvl(t.Partweight, 0) + t.Casingweight) As Sum_Area
          From Bl_Putincase_Box t
         Inner Join Bl_Putincase_m T1
            On T1.Putincase_No = t.Putincase_No
           And T1.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
    --获取备货单的预计交货日期
    If Type_Id_ = 'DELDATE' Then
      Open Cur_ For
        Select t.Deldate
          From Bl_Picklist t
         Where t.Picklistno = Parmlist_
            Or t.Pickuniteno = Parmlist_;
    
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    --获取备货单的托盘体积
    If Type_Id_ = 'VOLUME' Then
    
      Open Cur_ For
        Select t.Volume
          From Bl_Putintray_m t
         Where t.Putintray_No = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    --获取单个箱子的分摊的托盘重量
    If Type_Id_ = 'TRAYWEIGHT' Then
      Open Cur_ For
        Select t.Signtrayweight / t.Trayspace
          From Bl_Putintray_m t
         Where t.Putintray_No = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Nvl(Result_, 0);
    End If;
  
    --获取备货单的托盘总体积
    If Type_Id_ = 'SUM_VOLUME' Then
      --获取托盘数量        
      Open Cur_ For
        Select Sum(Round(t.Volume *
                         (Select Count(Distinct T1.Putintray_Newline)
                            From Bl_Putincase_Box T1
                           Where T1.Putintray_No = t.Putintray_No),
                         4))
          From Bl_Putintray_m t
         Where t.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Open Cur_ For
        Select Sum(t.Casingarea)
          From Bl_Putincase_Box t
         Where t.Putintray_No = '-'
           And t.Putincase_No In
               (Select a.Putincase_No
                  From Bl_Putincase_m a
                 Where a.Picklistno = Parmlist_);
      Fetch Cur_
        Into Result1_;
      Close Cur_;
    
      Return Nvl(To_Number(Result_), 0) + Nvl(To_Number(Result1_), 0);
    End If;
  
    --获取备货单的托盘总体积(只托盘)
    If Type_Id_ = 'SUM_VOLUME_0' Then
      --获取托盘数量        
      Open Cur_ For
        Select Sum(Round(t.Volume *
                         (Select Count(Distinct T1.Putintray_Newline)
                            From Bl_Putincase_Box T1
                           Where T1.Putintray_No = t.Putintray_No),
                         4))
          From Bl_Putintray_m t
         Where t.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Open Cur_ For
        Select Sum(t.Casingarea)
          From Bl_Putincase_Box t
         Where t.Putintray_No = '-'
           And t.Putincase_No In
               (Select a.Putincase_No
                  From Bl_Putincase_m a
                 Where a.Picklistno = Parmlist_);
      Fetch Cur_
        Into Result1_;
      Close Cur_;
    
      Return Nvl(To_Number(Result_), 0);
    End If;
    -- 获取单个托盘的净重
    If Type_Id_ = 'N_WEIGHT_TRAY' Then
      Open Cur_ For
        Select t.Nweight + t.Cweight
          From Bl_Putintray_Tray t
         Where t.Putintray_No = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    -- 获取单个托盘的总重量
    If Type_Id_ = 'SUM_WEIGHT_TRAY' Then
      Open Cur_ For
        Select t.Nweight + t.Cweight + t.Signtrayweight
          From Bl_Putintray_Tray t
         Where t.Putintray_No = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
    -- 获取单个托盘的实高
    If Type_Id_ = 'FACTHEIGHT' Then
      Open Cur_ For
        Select t.Factheight
          From Bl_Putintray_Tray t
         Where t.Putintray_No = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    -- 获取订单的托盘的重量
    If Type_Id_ = 'SUM_WEIGHT_TRAY0' Then
      Open Cur_ For
        Select Sum((t.Nweight + t.Cweight + t.Signtrayweight) *
                   (Select Count(Distinct T1.Putintray_Newline)
                      From Bl_Putincase_Box T1
                     Where T1.Putintray_No = t.Putintray_No))
          From Bl_Putintray_m t
         Where t.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    -- 托盘重量
    If Type_Id_ = 'Single_WEIGHT_TRAY' Then
      Open Cur_ For
        Select Sum((t.Signtrayweight) *
                   (Select Count(Distinct T1.Putintray_Newline)
                      From Bl_Putincase_Box T1
                     Where T1.Putintray_No = t.Putintray_No))
          From Bl_Putintray_m t
         Where t.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    -- 托盘总数量
  
    If Type_Id_ = 'TRAY_NUM' Then
      Open Cur_ For
        Select Count(Distinct T1.Putintray_Newline)
          From Bl_Putincase_Box T1
         Where T1.Putintray_No = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    -- 订舱委托报表 包装数量
    If Type_Id_ = 'Catalog_qty' Then
      Open Cur_ For
        Select Count(Distinct t.Box_Newline)
          From Bl_Putincase_Box t
         Where t.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    -- 订舱委托报表 净重
    /*   If Type_Id_ = 'N_C_WEIGHT' Then
      Open Cur_ For
        Select (t.qty_pkg) *
               (nvl(t.partweight, 0) + nvl(t.casingweight, 0))
          From BL_V_PUTINCASE_M_DETAIL t
         Where t.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;*/
  
    -- 订舱委托报表数据  价格及成交条款
    If Type_Id_ = 'Price_type' Then
      Open Cur_ For
        Select t.Delivery_Desc
          From Bl_Picihead t
         Where t.Invoice_No = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  End;

  Function Get_Onebox_Qty(Putincase_No_ In Varchar2, Box_Line_ In Number)
    Return Number Is
    Result_ Number;
    Cur_    t_Cursor;
  Begin
    Open Cur_ For
      Select Sum(t.Qty)
        From Bl_Putincase_Box_Detail t
       Where t.Putincase_No = Putincase_No_
         And t.Box_Line = Box_Line_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  End;

  -- 采购订单报表 发票  汇总金额
  Function Sum_Amount(Order_No_ In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    Open Cur_ For
      Select Sum(t.Amount) As Sum_Area
        From Bl_v_Purchase_Order_Line_Part t
       Where t.Order_No = Order_No_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  End;

  -- 订舱委托报表  净重
  Function Get_Sum_Weight(Booking_No_ In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    Open Cur_ For
      Select Sum(Nvl(t.Partweight, 0)) As Sum_Area
        From Bl_Putincase_Box t
       Inner Join Bl_Putincase_m T1
          On T1.Putincase_No = t.Putincase_No
         And T1.Picklistno In
             (Select T2.Picklistno
                From Bl_v_Bookinglist_Dtl T2
               Where T2.Booking_No = Booking_No_);
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  End;

  -- 订舱委托报表 毛重
  Function Get_Sum_Weight_a(Booking_No_ In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    Open Cur_ For
      Select Sum((t.Signtrayweight) *
                 (Select Count(Distinct T1.Putintray_Newline)
                    From Bl_Putincase_Box T1
                   Where T1.Putintray_No = t.Putintray_No))
        From Bl_Putintray_m t
       Where t.Picklistno In
             (Select T2.Picklistno
                From Bl_v_Bookinglist_Dtl T2
               Where T2.Booking_No = Booking_No_);
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  End;

  -- 订舱委托报表 总体积
  Function Get_Sum_Area(Booking_No_ In Varchar2) Return Number Is
    Cur_     t_Cursor;
    Result_  Number;
    Result1_ Number;
  Begin
    Open Cur_ For
      Select Sum(Round(t.Volume *
                       (Select Count(Distinct T1.Putintray_Newline)
                          From Bl_Putincase_Box T1
                         Where T1.Putintray_No = t.Putintray_No),
                       4))
        From Bl_Putintray_m t
       Where t.Picklistno In
             (Select T2.Picklistno
                From Bl_v_Bookinglist_Dtl T2
               Where T2.Booking_No = Booking_No_);
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Open Cur_ For
      Select Sum(t.Casingarea)
        From Bl_Putincase_Box t
       Where t.Putintray_No = '-'
         And t.Putincase_No In
             (Select a.Putincase_No
                From Bl_Putincase_m a
               Where a.Picklistno In
                     (Select T2.Picklistno
                        From Bl_v_Bookinglist_Dtl T2
                       Where T2.Booking_No = Booking_No_));
    Fetch Cur_
      Into Result1_;
    Close Cur_;
  
    Return Nvl(To_Number(Result_), 0) + Nvl(To_Number(Result1_), 0);
  End;
End Bl_Putincase_Api;
/
