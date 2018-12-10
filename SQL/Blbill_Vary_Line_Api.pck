Create Or Replace Package Blbill_Vary_Line_Api Is

  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  --获取变更的表名称 
  Procedure Get_Log_Table_Id_By_Type_Id(Modify_Id_ In Varchar2,
                                        If_Main    In Varchar2,
                                        Table_Id_  Out Varchar2);
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2);
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2;
  Procedure Set_Order_Item(Planrow_  In Out Bl_v_Customer_Order_Chgp_Det_3%Rowtype,
                           Line_Key_ In Varchar2);
  Procedure Set_f_Order_Item(Planrow_    In Out Bl_v_Customer_Order_Chgp_Det_3%Rowtype,
                             f_Line_Key_ In Varchar2);

  Function Checkordervary(Smodify_Id_   In Varchar2,
                          Modify_Id_    In Varchar2,
                          Order_No_     In Varchar2,
                          Line_No_      In Varchar2,
                          Rel_No_       In Varchar2,
                          Line_Item_No_ In Number) Return Number;

  Procedure Set_Item(Planrow_ In Bl_v_Customer_Order_Chgp_Det_3%Rowtype,
                     Attr_Out In Out Varchar2);
  ----检查添加行 删除行 
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2;
  Procedure Set_Catalog_Item(Planrow_    In Out Bl_v_Customer_Order_Chgp_Det_3%Rowtype,
                             Order_No_   In Varchar2,
                             Catalog_No_ In Varchar2,
                             Supplier_   In Varchar2,
                             Type_Id_    In Varchar2);
  --检测权限
  Function Checkuseable_(Rowlist_ In Varchar2) Return Varchar2;
End Blbill_Vary_Line_Api;
/
Create Or Replace Package Body Blbill_Vary_Line_Api Is
  Type t_Cursor Is Ref Cursor;
  -- 121108 by ld   改变 字段的可见
  ---------------------------------
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  --新建,修改,删除  变更
  Procedure Modify__(Rowlist_ Varchar2,
                     --变更视图 包含 modify_id ,modify_type  ...
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Cur_      t_Cursor;
    Cur1_     t_Cursor;
    Co_Line   Customer_Order_Line%Rowtype;
    Co_Line__ Customer_Order_Line%Rowtype;
    Irow_     Bl_v_Customer_Order_Chg_Det%Rowtype; --客户订单变更明细表
    Rowline_  Bl_Bill_Vary_Detail%Rowtype; --变更明细表
    Checkrow_ Bl_Bill_Vary_Detail%Rowtype; --变更明细表 检测用
    Row_      Bl_Bill_Vary%Rowtype; --变更表主档
    Prow_     Bl_v_Purchase_Order_Chg_Det%Rowtype; --采购订单变更明细表
    Cdprow_   Bl_Delivery_Plan_Detial%Rowtype; --交货计划明细表
    Planrow_  Bl_v_Customer_Order_Chgp_Det_3%Rowtype; --交货计划变更明细表
    Blrowv02  Bl_v_Customer_Order_V02%Rowtype;
    --修改交期变量
    Detail22_      Bl_v_Customer_Order_Chgp_Dep%Rowtype; --变更交期
    Deliveryrow_   Bl_Delivery_Plan_Detial_v%Rowtype; --交货计划明细行
    Dpdetailrow_   Bl_Delivery_Plan_Detial_v%Rowtype;
    Dpmainrow_     Bl_Delivery_Plan_v%Rowtype; --新交期是否存在交货计划头  
    Rowobjid_      Varchar2(50);
    Crowobjid_     Varchar2(50);
    Doaction_      Varchar2(10);
    Index_         Varchar2(1);
    Table_Id_      Varchar2(100);
    Pos_           Number;
    Pos1_          Number;
    Mysql_         Varchar2(2000);
    i              Number;
    v_             Varchar(1000);
    Column_Id_     Varchar(1000);
    Data_          Varchar(4000);
    Ifmychange     Varchar2(10);
    Plan_Line_Key_ Varchar2(1000);
    Datechgrow_    Bl_v_Customer_Order_Chgp_Dep%Rowtype; --修改交期 
  Begin
    Index_    := f_Get_Data_Index();
    Rowobjid_ := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    If Doaction_ = 'I' Then
      /*新增*/
      --取变更号 
      Irow_.Modify_Id := Pkg_a.Get_Item_Value('MODIFY_ID', Rowlist_);
      --取变更类型
      Select t.*
        Into Row_
        From Bl_Bill_Vary t
       Where t.Modify_Id = Irow_.Modify_Id;
      If Row_.Type_Id = '0' Or Row_.Type_Id = '7' Then
        --客户订单变更
      
        Rowline_.Modify_Type := Pkg_a.Get_Item_Value('MODIFY_TYPE',
                                                     Rowlist_); --默认修改行
        If Rowline_.Modify_Type = 'M' Or Rowline_.Modify_Type = 'D' Then
          Irow_.Line_Key := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
          If Nvl(Irow_.Line_Key, '-') = '-' Then
            Raise_Application_Error(-20101, '关键字必须填写');
            Return;
          End If;
          Open Cur_ For
            Select t.*
              From Bl_Bill_Vary_Detail t
             Where t.Line_Key = Irow_.Line_Key
               And (t.State = '0' Or t.State = '1');
          Fetch Cur_
            Into Rowline_;
          If Cur_%Found Then
            Close Cur_;
            Raise_Application_Error(-20101,
                                    Irow_.Line_Key || '已经存在变更记录，不能再变更了');
            Return;
          End If;
          Close Cur_;
          Rowline_.Qty_Delived  := Pkg_a.Get_Item_Value('QTY_DELIVED',
                                                        Rowlist_);
          Rowline_.Qty_Delivedf := Pkg_a.Get_Item_Value('QTY_DELIVEDF',
                                                        Rowlist_);
          If Row_.Type_Id = '0' Then
            If Rowline_.Qty_Delived = Rowline_.Qty_Delivedf Then
              Raise_Application_Error(-20101, '变更后数量不能与变更前相同');
              Return;
            End If;
          End If;
          If Row_.Type_Id = '7' Then
            If Rowline_.Qty_Delived = Rowline_.Qty_Delivedf Then
              Raise_Application_Error(-20101, '变更后价格不能与变更前相同');
              Return;
            End If;
          
          End If;
        Else
          Irow_.Line_Key := '';
        End If;
      
        Rowline_.Modify_Id := Irow_.Modify_Id;
      
        Rowline_.Enter_User := User_Id_;
        Rowline_.Enter_Date := Sysdate;
      
        Rowline_.Order_No     := Row_.Source_No;
        Rowline_.Line_No      := Pkg_a.Get_Item_Value('LINE_NO', Rowlist_);
        Rowline_.Rel_No       := Pkg_a.Get_Item_Value('REL_NO', Rowlist_);
        Rowline_.Line_Item_No := Pkg_a.Get_Item_Value('LINE_ITEM_NO',
                                                      Rowlist_);
        Rowline_.Qty_Delived  := Pkg_a.Get_Item_Value('QTY_DELIVED',
                                                      Rowlist_);
        Rowline_.Qty_Delivedf := Pkg_a.Get_Item_Value('QTY_DELIVEDF',
                                                      Rowlist_);
        Rowline_.Qty_Delived  := Nvl(Rowline_.Qty_Delived, 0);
        Rowline_.Qty_Delivedf := Nvl(Rowline_.Qty_Delivedf, 0);
        Rowline_.Base_No      := Pkg_a.Get_Item_Value('BASE_NO', Rowlist_);
        Rowline_.Base_Line    := Pkg_a.Get_Item_Value('BASE_LINE', Rowlist_);
        If Row_.Type_Id = '0' Then
          If Rowline_.Qty_Delived = Rowline_.Qty_Delivedf Then
          
            Raise_Application_Error(-20101,
                                    '数量' || To_Char(Rowline_.Qty_Delived) ||
                                    '没有变化');
            Return;
          End If;
        End If;
        If Row_.Type_Id = '7' Then
          If Rowline_.Qty_Delived = Rowline_.Qty_Delivedf Then
          
            Raise_Application_Error(-20101,
                                    '价格' || To_Char(Rowline_.Qty_Delived) ||
                                    '没有变化');
            Return;
          End If;
        End If;
        Select Max(Modify_Lineno)
          Into Rowline_.Modify_Lineno
          From Bl_Bill_Vary_Detail t
         Where t.Modify_Id = Rowline_.Modify_Id;
      
        Rowline_.Modify_Lineno := Nvl(Rowline_.Modify_Lineno, 0) + 1;
      
        Insert Into Bl_Bill_Vary_Detail
          (Modify_Id, Modify_Lineno)
        Values
          (Rowline_.Modify_Id, Rowline_.Modify_Lineno)
        Returning Rowid Into Rowobjid_;
        Rowline_.Line_Key           := Pkg_a.Get_Item_Value('LINE_KEY',
                                                            Rowlist_);
        Rowline_.Flag               := '1';
        Rowline_.State              := '0';
        Rowline_.Picklistno         := Pkg_a.Get_Item_Value('PICKLISTNO',
                                                            Rowlist_);
        Rowline_.Reason             := Pkg_a.Get_Item_Value('REASON',
                                                            Rowlist_);
        Rowline_.Reason_Description := Pkg_a.Get_Item_Value('REASON_DESCRIPTION',
                                                            Rowlist_);
        -- Pkg_a.Set_Item_Value('DELPLAN_NO',Rowline_.DELPLAN_NO,Rowline_.New_Data);
        Rowline_.New_Data := '';
      
        Pkg_a.Set_Item_Value('ORDER_NO',
                             Rowline_.Order_No,
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('LINE_NO',
                             Rowline_.Line_No,
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('REL_NO', Rowline_.Rel_No, Rowline_.New_Data);
        --新增 把line_no 清 0 
        If Rowline_.Modify_Type = 'I' Then
          Rowline_.Line_Item_No := 0;
          Rowline_.Rel_No       := 0;
          Rowline_.Line_No      := 0;
          Rowline_.Old_Data     := '';
          Pkg_a.Set_Item_Value('SUPPLY_CODE',
                               Pkg_a.Get_Item_Value('SUPPLY_CODE', Rowlist_),
                               Rowline_.New_Data);
          Pkg_a.Set_Item_Value('VENDOR_NO',
                               Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_),
                               Rowline_.New_Data);
        Else
          Pkg_a.Set_Item_Value('LINE_ITEM_NO',
                               Rowline_.Line_Item_No,
                               Rowline_.New_Data);
          Pkg_a.Set_Item_Value('CATALOG_NO',
                               Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_),
                               Rowline_.New_Data);
          Pkg_a.Set_Item_Value('CATALOG_DESC',
                               Pkg_a.Get_Item_Value('CATALOG_DESC',
                                                    Rowlist_),
                               Rowline_.New_Data);
          Rowline_.Old_Data := Rowline_.New_Data;
          --赋值 新旧 值 
          Pkg_a.Set_Item_Value('QTY_DELIVED',
                               Pkg_a.Get_Item_Value('QTY_DELIVED', Rowlist_),
                               Rowline_.Old_Data);
          Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                               Pkg_a.Get_Item_Value('QTY_DELIVEDF',
                                                    Rowlist_),
                               Rowline_.New_Data);
        
        End If;
        Pkg_a.Set_Item_Value('LINE_ITEM_NO',
                             Rowline_.Line_Item_No,
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('CATALOG_NO',
                             Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_),
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('CATALOG_DESC',
                             Pkg_a.Get_Item_Value('CATALOG_DESC', Rowlist_),
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                             Pkg_a.Get_Item_Value('QTY_DELIVEDF', Rowlist_),
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('REASON',
                             Pkg_a.Get_Item_Value('REASON', Rowlist_),
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('REASON_DESCRIPTION',
                             Pkg_a.Get_Item_Value('REASON_DESCRIPTION',
                                                  Rowlist_),
                             Rowline_.New_Data);
      
        -- 插入数据     PART_NO               
        Update Bl_Bill_Vary_Detail
           Set Row = Rowline_
         Where Rowid = Rowobjid_;
        Get_Log_Table_Id_By_Type_Id(Rowline_.Modify_Id, '0', Table_Id_);
        Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowobjid_);
      End If;
      If Row_.Type_Id = '1' Then
        --采购订单变更
        Row_.Modify_Id       := Pkg_a.Get_Item_Value('MODIFY_ID', Rowlist_);
        Rowline_.Modify_Type := Pkg_a.Get_Item_Value('MODIFY_TYPE',
                                                     Rowlist_); --默认修改行
        If Rowline_.Modify_Type = 'M' Or Rowline_.Modify_Type = 'D' Then
          Prow_.Line_Key := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
          If Nvl(Prow_.Line_Key, '-') = '-' Then
            Raise_Application_Error(-20101, '关键字必须填写');
            Return;
          End If;
          Open Cur_ For
            Select t.*
              From Bl_Bill_Vary_Detail t
             Where t.Line_Key = Prow_.Line_Key
               And (t.State = '0' Or t.State = '1');
          Fetch Cur_
            Into Rowline_;
          If Cur_%Found Then
            Raise_Application_Error(-20101,
                                    Prow_.Line_Key || '已经存在变更申请');
            Return;
          End If;
          Close Cur_;
        Else
          Prow_.Line_Key := '';
        End If;
        Rowline_.Modify_Id := Row_.Modify_Id;
      
        Rowline_.Enter_User   := User_Id_;
        Rowline_.Enter_Date   := Sysdate;
        Rowline_.Order_No     := Row_.Source_No;
        Rowline_.Line_No      := Pkg_a.Get_Item_Value('LINE_NO', Rowlist_);
        Rowline_.Rel_No       := Pkg_a.Get_Item_Value('REL_NO', Rowlist_);
        Rowline_.Qty_Delived  := Pkg_a.Get_Item_Value('QTY_DELIVED',
                                                      Rowlist_);
        Rowline_.Qty_Delivedf := Pkg_a.Get_Item_Value('QTY_DELIVEDF',
                                                      Rowlist_);
        Rowline_.Qty_Delived  := Nvl(Rowline_.Qty_Delived, 0);
        Rowline_.Qty_Delivedf := Nvl(Rowline_.Qty_Delivedf, 0);
        If Rowline_.Qty_Delived = Rowline_.Qty_Delivedf Then
        
          Raise_Application_Error(-20101,
                                  '数量' || To_Char(Rowline_.Qty_Delived) ||
                                  '没有变化');
          Return;
        End If;
        If Bl_Purchase_Check_Api.Checkqty__(Rowline_.Order_No,
                                            Rowline_.Line_No,
                                            Rowline_.Rel_No,
                                            Rowline_.Qty_Delivedf) <> '1' Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  '变更后的数量不能小于下域的客户订单的发货数量');
        End If;
        Select Max(Modify_Lineno)
          Into Rowline_.Modify_Lineno
          From Bl_Bill_Vary_Detail t
         Where t.Modify_Id = Rowline_.Modify_Id;
        Rowline_.Modify_Lineno := Nvl(Rowline_.Modify_Lineno, 0) + 1;
        Insert Into Bl_Bill_Vary_Detail
          (Modify_Id, Modify_Lineno)
        Values
          (Rowline_.Modify_Id, Rowline_.Modify_Lineno)
        Returning Rowid Into Rowobjid_;
        Rowline_.Line_Key    := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
        Rowline_.Flag        := '1';
        Rowline_.State       := '0';
        Rowline_.Modify_Type := Pkg_a.Get_Item_Value('MODIFY_TYPE',
                                                     Rowlist_); --默认修改行
        Rowline_.New_Data    := '';
        Pkg_a.Set_Item_Value('ORDER_NO',
                             Rowline_.Order_No,
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('LINE_NO',
                             Rowline_.Line_No,
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('REL_NO', Rowline_.Rel_No, Rowline_.New_Data);
        Rowline_.Reason             := Pkg_a.Get_Item_Value('REASON',
                                                            Rowlist_);
        Rowline_.Reason_Description := Pkg_a.Get_Item_Value('REASON_DESCRIPTION',
                                                            Rowlist_);
        If Rowline_.Modify_Type = 'I' Then
          Rowline_.Rel_No   := 0;
          Rowline_.Line_No  := 0;
          Rowline_.Old_Data := '';
        Else
          Pkg_a.Set_Item_Value('PART_NO',
                               Pkg_a.Get_Item_Value('PART_NO', Rowlist_),
                               Rowline_.New_Data);
          Pkg_a.Set_Item_Value('DESCRIPTION',
                               Pkg_a.Get_Item_Value('DESCRIPTION', Rowlist_),
                               Rowline_.New_Data);
          Rowline_.Old_Data := Rowline_.New_Data;
          --赋值 新旧 值 
          Pkg_a.Set_Item_Value('QTY_DELIVED',
                               Pkg_a.Get_Item_Value('QTY_DELIVED', Rowlist_),
                               Rowline_.Old_Data);
          Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                               Pkg_a.Get_Item_Value('QTY_DELIVEDF',
                                                    Rowlist_),
                               Rowline_.New_Data);
        
        End If;
        Pkg_a.Set_Item_Value('PART_NO',
                             Pkg_a.Get_Item_Value('PART_NO', Rowlist_),
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('DESCRIPTION',
                             Pkg_a.Get_Item_Value('DESCRIPTION', Rowlist_),
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                             Pkg_a.Get_Item_Value('QTY_DELIVEDF', Rowlist_),
                             Rowline_.New_Data);
      
        -- 插入数据     PART_NO               
        Update Bl_Bill_Vary_Detail
           Set Row = Rowline_
         Where Rowid = Rowobjid_;
        Get_Log_Table_Id_By_Type_Id(Rowline_.Modify_Id, '0', Table_Id_);
        Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowobjid_);
      End If;
      If Row_.Type_Id = '2' Or Row_.Type_Id = '21' Or Row_.Type_Id = '3' Or
         Row_.Type_Id = '6' Then
      
        Planrow_.Order_No       := Pkg_a.Get_Item_Value('ORDER_NO',
                                                        Rowlist_);
        Planrow_.Line_No        := Pkg_a.Get_Item_Value('LINE_NO', Rowlist_);
        Planrow_.Rel_No         := Pkg_a.Get_Item_Value('REL_NO', Rowlist_);
        Planrow_.Line_Item_No   := Pkg_a.Get_Item_Value('LINE_ITEM_NO',
                                                        Rowlist_);
        Planrow_.f_Order_No     := Pkg_a.Get_Item_Value('F_ORDER_NO',
                                                        Rowlist_);
        Planrow_.f_Line_No      := Pkg_a.Get_Item_Value('F_LINE_NO',
                                                        Rowlist_);
        Planrow_.f_Rel_No       := Pkg_a.Get_Item_Value('F_REL_NO',
                                                        Rowlist_);
        Planrow_.f_Line_Item_No := Pkg_a.Get_Item_Value('F_LINE_ITEM_NO',
                                                        Rowlist_);
      
        Planrow_.Line_Key   := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
        Planrow_.f_Line_Key := Pkg_a.Get_Item_Value('F_LINE_KEY', Rowlist_);
      
        Planrow_.Delplan_No   := Pkg_a.Get_Item_Value('DELPLAN_NO',
                                                      Rowlist_);
        Planrow_.Delplan_Line := Pkg_a.Get_Item_Value('DELPLAN_LINE',
                                                      Rowlist_);
        Planrow_.Buy_Qty_Due  := Pkg_a.Get_Item_Value('BUY_QTY_DUE',
                                                      Rowlist_);
        --检测 订单行的变更在其他交货计划中是否存在
        --交货计划变更 工厂操作交货计划变更      
        Rowline_.Modify_Id := Row_.Modify_Id;
      
        Rowline_.Base_No   := Pkg_a.Get_Item_Value('BASE_NO', Rowlist_);
        Rowline_.Base_Line := Pkg_a.Get_Item_Value('BASE_LINE', Rowlist_);
        --上级变更
        If Length(Nvl(Row_.Smodify_Id, '-')) > 2 And
           Rowline_.Base_No = Nvl(Row_.Smodify_Id, '-') Then
          Open Cur_ For
            Select t.Rowid
              From Bl_Bill_Vary_Detail t
             Where t.Order_No = Planrow_.Order_No
               And t.Line_No = Planrow_.Line_No
               And t.Rel_No = Planrow_.Rel_No
               And t.Line_Item_No = Planrow_.Line_Item_No
               And t.State In ('0', '1')
               And t.Base_No = Rowline_.Base_No
               And t.Base_Line = Rowline_.Base_Line;
          Fetch Cur_
            Into Crowobjid_;
          If Cur_%Found Then
            Close Cur_;
            Pkg_a.Setsuccess(A311_Key_, Table_Id_, Crowobjid_);
            Return;
          End If;
        
        End If;
        Open Cur_ For
          Select t.*
            From Bl_Bill_Vary_Detail t
           Where t.Order_No = Planrow_.Order_No
             And t.Line_No = Planrow_.Line_No
             And t.Rel_No = Planrow_.Rel_No
             And t.Line_Item_No = Planrow_.Line_Item_No
             And t.State In ('0', '1')
             And t.Modify_Id <> Rowline_.Modify_Id;
        Fetch Cur_
          Into Checkrow_;
        If Cur_%Found Then
          Close Cur_;
        
          If Row_.Type_Id = '2' Then
            Raise_Application_Error(-20101,
                                    Planrow_.f_Line_Key || '在' ||
                                    Checkrow_.Modify_Id || '有变更未确认，不能再变更了！');
          End If;
          If Row_.Type_Id = '21' Or Row_.Type_Id = '3' Or
             Row_.Type_Id = '6' Then
            Raise_Application_Error(-20101,
                                    Planrow_.Line_Key || '在' ||
                                    Checkrow_.Modify_Id || '有变更未确认，不能再变更了！');
          End If;
        End If;
        Close Cur_;
        --变更后的数量      
        Planrow_.Qty_Delivedf := Nvl(Pkg_a.Get_Item_Value('QTY_DELIVEDF',
                                                          Rowlist_),
                                     0);
        Planrow_.Qty_Delived  := Nvl(Pkg_a.Get_Item_Value('QTY_DELIVED',
                                                          Rowlist_),
                                     0);
        If Row_.Type_Id != 'AUTO' Then
          If Planrow_.Qty_Delivedf < 0 Then
            Raise_Application_Error(Pkg_a.Raise_Error, '请输入正确的数量');
          End If;
          If Planrow_.Qty_Delived = 0 Then
            If Planrow_.Qty_Delivedf <= 0 Then
              Raise_Application_Error(Pkg_a.Raise_Error,
                                      '请输入正确的数量');
            End If;
          
          End If;
          If Planrow_.Qty_Delivedf > Planrow_.Buy_Qty_Due Then
            Raise_Application_Error(Pkg_a.Raise_Error,
                                    '输入数量不能大于订单数量');
          End If;
        End If;
      
        --只记录一个日期 
        Planrow_.Delived_Datef := To_Date(Pkg_a.Get_Item_Value('DELIVED_DATEF',
                                                               Rowlist_),
                                          'YYYY-MM-DD');
        If Planrow_.Delived_Datef > Sysdate + (365 * 2) Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  '交期' || To_Char(Planrow_.Delived_Datef,
                                                  'YYYY-MM-DD') || '过大');
        
        End If;
        If Row_.Type_Id != '6' Then
          --同一个订单行的交期不能一样                                 
          Open Cur_ For
            Select t.*
              From Bl_Bill_Vary_Detail t
             Where t.Modify_Id = Irow_.Modify_Id
               And t.Order_No = Planrow_.Order_No
               And t.Line_No = Planrow_.Line_No
               And t.Rel_No = Planrow_.Rel_No
               And t.Line_Item_No = Planrow_.Line_Item_No
               And t.Delived_Datef = Planrow_.Delived_Datef
               And t.State In ('0', '1');
          Fetch Cur_
            Into Checkrow_;
          If Cur_%Found Then
            Close Cur_;
            --工厂
            If Row_.Type_Id = '2' Then
              Raise_Application_Error(-20101,
                                      Planrow_.f_Line_Key ||
                                      To_Char(Planrow_.Delived_Datef,
                                              'YYYY-MM-DD') || '交期重复');
            End If;
            --业务
            If Row_.Type_Id = '21' Or Row_.Type_Id = '3' Then
              Raise_Application_Error(-20101,
                                      Planrow_.Line_Key ||
                                      To_Char(Planrow_.Delived_Datef,
                                              'YYYY-MM-DD') || '交期重复');
            End If;
          End If;
          Close Cur_;
        Else
          --检测订单行是否重复
          Open Cur_ For
            Select t.*
              From Bl_Bill_Vary_Detail t
             Where t.Modify_Id = Irow_.Modify_Id
               And t.Order_No = Planrow_.Order_No
               And t.Line_No = Planrow_.Line_No
               And t.Rel_No = Planrow_.Rel_No
               And t.Line_Item_No = Planrow_.Line_Item_No;
          Fetch Cur_
            Into Checkrow_;
          If Cur_%Found Then
            Raise_Application_Error(-20101, Planrow_.Line_Key || '重复');
          End If;
          Close Cur_;
        End If;
        --检测当前行有没有做过变更
      
        --检测交货计划数据是否存在
        Rowline_.Order_No     := Planrow_.Order_No;
        Rowline_.Line_No      := Planrow_.Line_No;
        Rowline_.Rel_No       := Planrow_.Rel_No;
        Rowline_.Line_Item_No := Planrow_.Line_Item_No;
        Planrow_.Picklistno   := Pkg_a.Get_Item_Value('PICKLISTNO',
                                                      Rowlist_);
      
        Rowline_.Modify_Id  := Row_.Modify_Id;
        Rowline_.Base_No    := Pkg_a.Get_Item_Value('BASE_NO', Rowlist_);
        Rowline_.Base_Line  := Pkg_a.Get_Item_Value('BASE_LINE', Rowlist_);
        Rowline_.Enter_User := User_Id_;
        Rowline_.Enter_Date := Sysdate;
      
        Rowline_.Picklistno := Planrow_.Picklistno;
      
        Rowline_.Delived_Datef := Planrow_.Delived_Datef;
        Rowline_.Delived_Date  := Planrow_.Delived_Datef;
      
        Rowline_.Qty_Delived  := Planrow_.Qty_Delived;
        Rowline_.Qty_Delivedf := Planrow_.Qty_Delivedf;
      
        Rowline_.Line_Key := Planrow_.Delplan_No || '-' ||
                             Planrow_.Delplan_Line;
        Rowline_.Flag     := '0';
        Rowline_.State    := '0';
      
        Rowline_.f_Order_No     := Planrow_.f_Order_No;
        Rowline_.f_Line_No      := Planrow_.f_Line_No;
        Rowline_.f_Rel_No       := Planrow_.f_Rel_No;
        Rowline_.f_Line_Item_No := Planrow_.f_Line_Item_No;
      
        Rowline_.New_Data := '';
        If Row_.Type_Id = '6' Then
          Rowline_.Modify_Type := 'PL'; --备货当变更 不能修改
        Else
          Rowline_.Modify_Type := Pkg_a.Get_Item_Value('MODIFY_TYPE',
                                                       Rowlist_); --交货计划变更 deliver 
        End If;
        Pkg_a.Set_Item_Value('ORDER_NO',
                             Planrow_.Order_No,
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('LINE_NO',
                             Planrow_.Line_No,
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('REL_NO', Planrow_.Rel_No, Rowline_.New_Data);
        Pkg_a.Set_Item_Value('LINE_ITEM_NO',
                             Planrow_.Line_Item_No,
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('LINE_KEY',
                             Planrow_.Order_No || '-' || Planrow_.Line_No || '-' ||
                             Planrow_.Rel_No || '-' ||
                             Planrow_.Line_Item_No,
                             Rowline_.New_Data);
      
        Pkg_a.Set_Item_Value('F_ORDER_NO',
                             Planrow_.f_Order_No,
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('F_LINE_NO',
                             Planrow_.f_Line_No,
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('F_REL_NO',
                             Planrow_.f_Rel_No,
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('F_LINE_ITEM_NO',
                             Planrow_.f_Line_Item_No,
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('F_LINE_KEY',
                             Planrow_.f_Order_No || '-' ||
                             Planrow_.f_Line_No || '-' || Planrow_.f_Rel_No || '-' ||
                             Planrow_.f_Line_Item_No,
                             Rowline_.New_Data);
        If Row_.Type_Id = '3' Or Row_.Type_Id = '6' Then
          Planrow_.Blorder_No := Pkg_a.Get_Item_Value('BLORDER_NO',
                                                      Rowlist_);
          Planrow_.Supplier   := Pkg_a.Get_Item_Value('SUPPLIER', Rowlist_);
        
          Pkg_a.Set_Item_Value('BLORDER_NO',
                               Planrow_.Blorder_No,
                               Rowline_.New_Data);
          Pkg_a.Set_Item_Value('SUPPLIER',
                               Planrow_.Supplier,
                               Rowline_.New_Data);
          Rowline_.Base_Modify_Id := Row_.Modify_Id;
        Else
          Planrow_.Supplier := Pkg_a.Get_Item_Value_By_Index('-',
                                                             '&',
                                                             Row_.Source_No || '&');
          Pkg_a.Set_Item_Value('SUPPLIER',
                               Planrow_.Supplier,
                               Rowline_.New_Data);
        End If;
        /*    Pkg_a.Set_Item_Value('CATALOG_NO',
                             Planrow_.Catalog_No,
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('CATALOG_DESC',
                             Planrow_.Catalog_Desc,
                             Rowline_.New_Data);*/
      
        Select Max(Modify_Lineno)
          Into Rowline_.Modify_Lineno
          From Bl_Bill_Vary_Detail t
         Where t.Modify_Id = Row_.Modify_Id;
      
        Rowline_.Modify_Lineno := Nvl(Rowline_.Modify_Lineno, 0) + 1;
      
        Insert Into Bl_Bill_Vary_Detail
          (Modify_Id, Modify_Lineno)
        Values
          (Rowline_.Modify_Id, Rowline_.Modify_Lineno)
        Returning Rowid Into Rowobjid_;
        --默认修改行
        --记录日志
        -- 插入数据     PART_NO               
        Update Bl_Bill_Vary_Detail
           Set Row = Rowline_
         Where Rowid = Rowobjid_;
        Get_Log_Table_Id_By_Type_Id(Rowline_.Modify_Id, '0', Table_Id_);
        Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowobjid_);
      End If;
    
      --修改交货计划的交期--
      If Row_.Type_Id = '22' Then
        Detail22_.Modify_Id          := Irow_.Modify_Id;
        Detail22_.Delplan_No         := Pkg_a.Get_Item_Value('DELPLAN_NO',
                                                             Rowlist_);
        Detail22_.Reason             := Pkg_a.Get_Item_Value('REASON',
                                                             Rowlist_);
        Detail22_.Reason_Description := Pkg_a.Get_Item_Value('REASON_DESCRIPTION',
                                                             Rowlist_);
        Detail22_.Remark             := Pkg_a.Get_Item_Value('REMARK',
                                                             Rowlist_);
        Detail22_.Delived_Datef      := To_Date(Pkg_a.Get_Item_Value('DELIVED_DATEF',
                                                                     Rowlist_),
                                                'YYYY-MM-DD');
      
        Dpmainrow_.Order_No := Pkg_a.Get_Item_Value_By_Index('&',
                                                             '-',
                                                             '&' ||
                                                             Row_.Source_No);
        Dpmainrow_.Supplier := Pkg_a.Get_Item_Value_By_Index('-',
                                                             '&',
                                                             Row_.Source_No || '&');
      
        --同一个交货计划 不能改到2个交期
        Open Cur_ For
          Select t.*
            From Bl_Bill_Vary_Detail t
           Where t.Modify_Id = Row_.Modify_Id
             And t.From_Key = Detail22_.Delplan_No;
        Fetch Cur_
          Into Checkrow_;
        If Cur_%Found Then
          Close Cur_;
          Raise_Application_Error(-20101,
                                  '交货计划' || Detail22_.Delplan_No ||
                                  '不能修改到多个交期中');
        End If;
        Close Cur_;
      
        Select Max(Modify_Lineno)
          Into Rowline_.Modify_Lineno
          From Bl_Bill_Vary_Detail t
         Where t.Modify_Id = Row_.Modify_Id;
      
        Open Cur_ For
          Select t.*
            From Bl_Delivery_Plan_Detial_v t
           Where t.Delplan_No = Detail22_.Delplan_No
             And t.State = '2'; --取消的行不需要
        Fetch Cur_
          Into Deliveryrow_;
        Loop
          Exit When Cur_%Notfound;
          Open Cur1_ For
            Select t.*
              From Bl_Bill_Vary_Detail t
             Where t.Order_No = Deliveryrow_.Order_No
               And t.Line_No = Deliveryrow_.Line_No
               And t.Rel_No = Deliveryrow_.Rel_No
               And t.Line_Item_No = Deliveryrow_.Line_Item_No
               And t.State In ('0', '1')
               And t.Modify_Id <> Rowline_.Modify_Id;
          Fetch Cur1_
            Into Checkrow_;
          If Cur1_%Found Then
            Close Cur1_;
            Raise_Application_Error(-20101,
                                    Detail22_.Delplan_No ||
                                    '中有变更未确认，不能再变更了！');
          End If;
          Close Cur1_;
          --把变更的数据写入到 变更表中
          Rowline_.From_Key      := Deliveryrow_.Delplan_No;
          Rowline_.From_Key_Line := Deliveryrow_.Delplan_Line;
          Rowline_.From_Date     := Deliveryrow_.Delived_Date;
          Rowline_.Order_No      := Deliveryrow_.Order_No;
          Rowline_.To_Date       := Detail22_.Delived_Datef;
          Rowline_.Line_No       := Deliveryrow_.Line_No;
          Rowline_.Rel_No        := Deliveryrow_.Rel_No;
          Rowline_.Line_Item_No  := Deliveryrow_.Line_Item_No;
          Rowline_.Picklistno    := Deliveryrow_.Picklistno;
          Rowline_.Modify_Id     := Row_.Modify_Id;
          Rowline_.Enter_User    := User_Id_;
          Rowline_.Enter_Date    := Sysdate;
          Rowline_.Delived_Datef := Deliveryrow_.Delived_Date;
          Rowline_.Delived_Date  := Deliveryrow_.Delived_Date;
        
          Rowline_.Qty_Delived  := Deliveryrow_.Qty_Delived;
          Rowline_.Qty_Delivedf := 0;
          Rowline_.Line_Key     := Deliveryrow_.Delplan_No || '-' ||
                                   Deliveryrow_.Delplan_Line;
          Rowline_.Flag         := '0';
          Rowline_.State        := '0';
          Rowline_.Modify_Type  := 'CD'; -- 交货计划 修改交期  change date 
          Rowline_.New_Data     := '';
          Pkg_a.Set_Item_Value('ORDER_NO',
                               Rowline_.Order_No,
                               Rowline_.New_Data);
          Pkg_a.Set_Item_Value('LINE_NO',
                               Rowline_.Line_No,
                               Rowline_.New_Data);
          Pkg_a.Set_Item_Value('REL_NO',
                               Rowline_.Rel_No,
                               Rowline_.New_Data);
          Pkg_a.Set_Item_Value('LINE_ITEM_NO',
                               Rowline_.Line_Item_No,
                               Rowline_.New_Data);
          Pkg_a.Set_Item_Value('LINE_KEY',
                               Rowline_.Order_No || '-' || Rowline_.Line_No || '-' ||
                               Rowline_.Rel_No || '-' ||
                               Rowline_.Line_Item_No,
                               Rowline_.New_Data);
        
          Pkg_a.Set_Item_Value('F_ORDER_NO',
                               Deliveryrow_.f_Order_No,
                               Rowline_.New_Data);
          Pkg_a.Set_Item_Value('F_LINE_NO',
                               Deliveryrow_.f_Line_No,
                               Rowline_.New_Data);
          Pkg_a.Set_Item_Value('F_REL_NO',
                               Deliveryrow_.f_Rel_No,
                               Rowline_.New_Data);
          Pkg_a.Set_Item_Value('F_LINE_ITEM_NO',
                               Deliveryrow_.f_Line_Item_No,
                               Rowline_.New_Data);
          Pkg_a.Set_Item_Value('F_LINE_KEY',
                               Deliveryrow_.f_Order_No || '-' ||
                               Deliveryrow_.f_Line_No || '-' ||
                               Deliveryrow_.f_Rel_No || '-' ||
                               Deliveryrow_.f_Line_Item_No,
                               Rowline_.New_Data);
          Rowline_.Modify_Lineno := Nvl(Rowline_.Modify_Lineno, 0) + 1;
        
          Insert Into Bl_Bill_Vary_Detail
            (Modify_Id, Modify_Lineno)
          Values
            (Rowline_.Modify_Id, Rowline_.Modify_Lineno)
          Returning Rowid Into Rowobjid_;
          Update Bl_Bill_Vary_Detail
             Set Row = Rowline_
           Where Rowid = Rowobjid_;
        
          Rowline_.Modify_Lineno := Nvl(Rowline_.Modify_Lineno, 0) + 1;
        
          Insert Into Bl_Bill_Vary_Detail
            (Modify_Id, Modify_Lineno)
          Values
            (Rowline_.Modify_Id, Rowline_.Modify_Lineno)
          Returning Rowid Into Rowobjid_;
        
          Rowline_.Delived_Date  := Detail22_.Delived_Datef;
          Rowline_.Delived_Datef := Detail22_.Delived_Datef;
        
          Dpmainrow_.Order_No := Pkg_a.Get_Item_Value_By_Index('&',
                                                               '-',
                                                               '&' ||
                                                               Row_.Source_No);
          Dpmainrow_.Supplier := Pkg_a.Get_Item_Value_By_Index('-',
                                                               '&',
                                                               Row_.Source_No || '&');
          Bldelivery_Plan_Api.Get_Record_By_Order_Date(Dpmainrow_.Order_No,
                                                       Dpmainrow_.Supplier,
                                                       Rowline_.Delived_Datef,
                                                       Dpmainrow_);
        
          Bldelivery_Plan_Line_Api.Get_Record_d_o_(Dpmainrow_.Delplan_No,
                                                   Rowline_.Order_No,
                                                   Rowline_.Line_No,
                                                   Rowline_.Rel_No,
                                                   Rowline_.Line_Item_No,
                                                   Dpdetailrow_);
          Rowline_.Qty_Delived := Nvl(Dpdetailrow_.Qty_Delived, 0);
          --数量添加
          Rowline_.Qty_Delivedf := Nvl(Deliveryrow_.Qty_Delived, 0) +
                                   Nvl(Dpdetailrow_.Qty_Delived, 0);
          Rowline_.Line_Key     := Dpmainrow_.Delplan_No || '-' ||
                                   To_Char(Nvl(Dpdetailrow_.Delplan_Line, 0));
          If Rowline_.Line_Key = '-0' Or Rowline_.Line_Key = '-' Then
            Rowline_.Line_Key := '';
          End If;
          Rowline_.Picklistno := Dpmainrow_.Picklistno;
          Rowline_.Column_No  := Dpmainrow_.Column_No;
        
          Update Bl_Bill_Vary_Detail
             Set Row = Rowline_
           Where Rowid = Rowobjid_;
        
          Fetch Cur_
            Into Deliveryrow_;
        End Loop;
      
        Close Cur_;
      
        Pkg_a.Setsuccess(A311_Key_,
                         'BL_V_CUSTOMER_ORDER_CHGP_DEP',
                         Row_.Modify_Id || '-' || Dpmainrow_.Delplan_No);
      
      End If;
      --备货单变更（整体 修改）
      If Row_.Type_Id = '5' Then
        Rowline_.Modify_Id          := Irow_.Modify_Id;
        Rowline_.Modify_Type        := Pkg_a.Get_Item_Value('MODIFY_TYPE',
                                                            Rowlist_);
        Rowline_.Order_No           := Pkg_a.Get_Item_Value('ORDER_NO',
                                                            Rowlist_);
        Rowline_.Line_Key           := Pkg_a.Get_Item_Value('LINE_KEY',
                                                            Rowlist_);
        Rowline_.Flag               := '1';
        Rowline_.State              := '0';
        Rowline_.Enter_User         := User_Id_;
        Rowline_.Enter_Date         := Sysdate;
        Rowline_.Picklistno         := Pkg_a.Get_Item_Value('PICKLISTNO',
                                                            Rowlist_);
        Rowline_.Reason             := Pkg_a.Get_Item_Value('REASON',
                                                            Rowlist_);
        Rowline_.Reason_Description := Pkg_a.Get_Item_Value('REASON_DESCRIPTION',
                                                            Rowlist_);
        Rowline_.Delived_Date       := To_Date(Pkg_a.Get_Item_Value('DELIVED_DATE',
                                                                    Rowlist_),
                                               'YYYY-MM-DD');
        Pkg_a.Set_Item_Value('BLORDER_NO',
                             Pkg_a.Get_Item_Value('BLORDER_NO', Rowlist_),
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('CONTRACT',
                             Pkg_a.Get_Item_Value('CONTRACT', Rowlist_),
                             Rowline_.New_Data);
        Pkg_a.Set_Item_Value('SUPPLIER',
                             Pkg_a.Get_Item_Value('SUPPLIER', Rowlist_),
                             Rowline_.New_Data);
        Select Max(Modify_Lineno)
          Into Rowline_.Modify_Lineno
          From Bl_Bill_Vary_Detail t
         Where t.Modify_Id = Rowline_.Modify_Id;
        Rowline_.Modify_Lineno := Nvl(Rowline_.Modify_Lineno, 0) + 1;
      
        Insert Into Bl_Bill_Vary_Detail
          (Modify_Id, Modify_Lineno)
        Values
          (Rowline_.Modify_Id, Rowline_.Modify_Lineno)
        Returning Rowid Into Rowobjid_;
      
        Update Bl_Bill_Vary_Detail
           Set Row = Rowline_
         Where Rowid = Rowobjid_;
        Get_Log_Table_Id_By_Type_Id(Rowline_.Modify_Id, '0', Table_Id_);
        Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowobjid_);
      End If;
      Return;
    End If;
    If Doaction_ = 'D' Then
      /*删除*/
      --变更交期变更
      If Instr(Rowobjid_, '-') > 0 Then
        Open Cur_ For
          Select t.*
            From Bl_v_Customer_Order_Chgp_Dep t
           Where t.Objid = Rowobjid_;
        Fetch Cur_
          Into Datechgrow_;
        If Cur_%Notfound Then
          Close Cur_;
          Raise_Application_Error(-20101, '错误的rowid');
          Return;
        End If;
        Close Cur_;
        Delete From Bl_Bill_Vary_Detail t
         Where t.Modify_Id = Datechgrow_.Modify_Id
           And t.From_Key = Datechgrow_.Delplan_No;
        Pkg_a.Setsuccess(A311_Key_,
                         'BL_V_CUSTOMER_ORDER_CHGP_DEP',
                         Rowobjid_);
        Return;
      End If;
    
      Open Cur_ For
        Select t.*
          Into Rowline_
          From Bl_Bill_Vary_Detail t
         Where Rowidtochar(Rowid) = Rowobjid_;
      Fetch Cur_
        Into Rowline_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      End If;
      Close Cur_;
    
      If Rowline_.State <> '0' Then
        Raise_Application_Error(-20101, '只有保存状态的变更才能删除');
        Return;
      End If;
      --备货单变更 引起的交货计划变更
      If Rowline_.Modify_Type = 'PK' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '备货单变更行不能删除！');
        Return;
      End If;
      --差异发货引起的交货计划变更 
      If Rowline_.Modify_Type = 'FM' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '备货单变更行不能删除！');
        Return;
      End If;
      If Nvl(Rowline_.Base_No, '-') <> '-' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '订单引起的变更行不能删除！');
      End If;
    
      Get_Log_Table_Id_By_Type_Id(Rowline_.Modify_Id, '0', Table_Id_);
      Delete From Bl_Bill_Vary_Detail Where Rowid = Rowobjid_;
      Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowobjid_);
      Return;
    End If;
  
    If Doaction_ = 'M' Then
      /*修改*/
      If Instr(Rowobjid_, '-') > 0 Then
        Open Cur_ For
          Select t.*
            From Bl_v_Customer_Order_Chgp_Dep t
           Where t.Objid = Rowobjid_;
        Fetch Cur_
          Into Datechgrow_;
        If Cur_%Notfound Then
          Close Cur_;
          Raise_Application_Error(-20101, '错误的rowid');
          Return;
        End If;
        Close Cur_;
        Data_      := Rowlist_;
        Pos_       := Instr(Data_, Index_);
        i          := i + 1;
        Mysql_     := 'update bl_bill_vary_detail  set  ';
        Ifmychange := '0';
        Loop
          Exit When Nvl(Pos_, 0) <= 0;
          Exit When i > 300;
          v_         := Substr(Data_, 1, Pos_ - 1);
          Data_      := Substr(Data_, Pos_ + 1);
          Pos_       := Instr(Data_, Index_);
          Pos1_      := Instr(v_, '|');
          Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        
          If Column_Id_ = 'REMARK' Or Column_Id_ = 'REASON' Or
             Column_Id_ = 'REASON_DESCRIPTION' Then
            Ifmychange := '1';
            v_         := Substr(v_, Pos1_ + 1);
            Mysql_     := Mysql_ || ' ' || Column_Id_ || '=''' || v_ ||
                          ''',';
          End If;
        
        End Loop;
        --保存备注  
      
        If Ifmychange = '1' Then
          Mysql_ := Mysql_ || 'modi_date= sysdate,modi_user=''' || User_Id_ ||
                    ''' where MODIFY_ID =''' || Datechgrow_.Modify_Id ||
                    ''' AND  from_key=''' || Datechgrow_.Delplan_No || '''';
        
          Execute Immediate Mysql_;
        
        End If;
        Pkg_a.Setsuccess(A311_Key_,
                         'BL_V_CUSTOMER_ORDER_CHGP_DEP',
                         Rowobjid_);
        Return;
      End If;
    
      Open Cur_ For
        Select t.*
          From Bl_Bill_Vary_Detail t
         Where Rowidtochar(Rowid) = Rowobjid_;
      Fetch Cur_
        Into Rowline_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      Else
        Close Cur_;
      End If;
    
      Open Cur_ For
        Select t.*
          From Bl_Bill_Vary t
         Where t.Modify_Id = Rowline_.Modify_Id;
      Fetch Cur_
        Into Row_;
      Close Cur_;
    
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := 'update bl_bill_vary_detail  set  ';
      Ifmychange := '0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_         := Substr(Data_, 1, Pos_ - 1);
        Data_      := Substr(Data_, Pos_ + 1);
        Pos_       := Instr(Data_, Index_);
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
      
        If Column_Id_ = 'REMARK' Or Column_Id_ = 'REASON' Or
           Column_Id_ = 'REASON_DESCRIPTION' Or Column_Id_ = 'QTY_DELIVEDF' Or
           Column_Id_ = 'QTY_DELIVED' Or Column_Id_ = 'PICKLISTNO' Then
          Ifmychange := '1';
          v_         := Substr(v_, Pos1_ + 1);
          Mysql_     := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
          If Column_Id_ = 'QTY_DELIVEDF' Then
            Planrow_.Qty_Delivedf := v_;
            If Planrow_.Qty_Delivedf < 0 Then
              Raise_Application_Error(Pkg_a.Raise_Error,
                                      '请输入正确的数量');
            End If;
            If Rowline_.Qty_Delived = 0 Then
              If Planrow_.Qty_Delivedf <= 0 Then
                Raise_Application_Error(Pkg_a.Raise_Error,
                                        '请输入正确的数量');
              End If;
            End If;
            If Bl_Purchase_Check_Api.Checkqty__(Rowline_.Order_No,
                                                Rowline_.Line_No,
                                                Rowline_.Rel_No,
                                                Planrow_.Qty_Delivedf) <> '1' Then
              Raise_Application_Error(Pkg_a.Raise_Error,
                                      '变更后的数量不能小于下域的客户订单的发货数量');
            End If;
          End If;
        End If;
      
        If Column_Id_ = 'DELIVED_DATEF' Then
          Ifmychange             := '1';
          v_                     := Substr(v_, Pos1_ + 1);
          Planrow_.Delived_Datef := To_Date(v_, 'YYYY-MM-DD');
          Planrow_.f_Line_Key    := Pkg_a.Get_Item_Value('F_LINE_KEY',
                                                         Rowline_.New_Data);
          Planrow_.Line_Key      := Pkg_a.Get_Item_Value('LINE_KEY',
                                                         Rowline_.New_Data);
        
          Open Cur_ For
            Select t.*
              From Bl_Bill_Vary_Detail t
             Where t.Modify_Id = Rowline_.Modify_Id
               And t.Order_No = Rowline_.Order_No
               And t.Line_No = Rowline_.Line_No
               And t.Rel_No = Rowline_.Rel_No
               And t.Line_Item_No = Rowline_.Line_Item_No
               And t.Delived_Datef = Planrow_.Delived_Datef
               And Rowidtochar(Rowid) <> Rowobjid_;
          Fetch Cur_
            Into Checkrow_;
          If Cur_%Found Then
            Close Cur_;
            --工厂
            If Row_.Type_Id = '2' Then
              Raise_Application_Error(-20101,
                                      Planrow_.f_Line_Key || '的交期' ||
                                      To_Char(Planrow_.Delived_Datef,
                                              'YYYY-MM-DD') || '重复');
            End If;
            --业务
            If Row_.Type_Id = '21' Or Row_.Type_Id = '3' Then
              Raise_Application_Error(-20101,
                                      Planrow_.Line_Key || '的交期' ||
                                      To_Char(Planrow_.Delived_Datef,
                                              'YYYY-MM-DD') || '重复');
            End If;
          Else
            Close Cur_;
          End If;
        
          Mysql_ := Mysql_ || ' ' || Column_Id_ || '=to_date(''' || v_ ||
                    ''',''YYYY-MM-DD''),';
          Mysql_ := Mysql_ || 'DELIVED_DATE =to_date(''' || v_ ||
                    ''',''YYYY-MM-DD''),';
        End If;
      
        If Column_Id_ = 'PLAN_LINE_KEY' Then
          Ifmychange := '1';
          v_         := Substr(v_, Pos1_ + 1);
          Mysql_     := Mysql_ || 'Line_Key =''' || v_ || ''',';
        End If;
      End Loop;
      --保存备注  
      If Ifmychange = '1' Then
        Mysql_ := Mysql_ || 'modi_date= sysdate,modi_user=''' || User_Id_ ||
                  ''' where rowid=''' || Rowobjid_ || '''';
        -- Raise_Application_Error(-20101, Mysql_);
        Execute Immediate Mysql_;
        Get_Log_Table_Id_By_Type_Id(Rowline_.Modify_Id, '0', Table_Id_);
        Pkg_a.Setsuccess(A311_Key_, Table_Id_, Rowobjid_);
      End If;
    
      Return;
    End If;
  
  End;

  --获取变更表 
  Procedure Get_Log_Table_Id_By_Type_Id(Modify_Id_ In Varchar2,
                                        --变更号
                                        If_Main   In Varchar2,
                                        Table_Id_ Out Varchar2) Is
    --表名称
    Cur_ t_Cursor;
    Row_ Bl_Bill_Vary_Type_Id%Rowtype;
    Id_  Bl_Bill_Vary_Type_Id.Id%Type;
  Begin
    --取变更类型
    Open Cur_ For
      Select t.Type_Id From Bl_Bill_Vary t Where t.Modify_Id = Modify_Id_;
    Fetch Cur_
      Into Id_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的变更编码' || Modify_Id_);
      Return;
    End If;
    Close Cur_;
  
    --取变更的视图
    Open Cur_ For
      Select t.* From Bl_Bill_Vary_Type_Id t Where t.Id = Id_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的变更类型' || Id_);
      Return;
    End If;
    Close Cur_;
    If If_Main = '1' Then
      Table_Id_ := Row_.Table_Id;
    Else
      Table_Id_ := Row_.Detail_Table_Id;
    End If;
  End;
  --所有变更界面表选带出相关值  
  Procedure Itemchange__(Column_Id_ Varchar2,
                         --发生变化的列名
                         Mainrowlist_ Varchar2,
                         --主档视图中的列名
                         Rowlist_ Varchar2,
                         --明细视图中的列名
                         User_Id_    Varchar2,
                         Outrowlist_ Out Varchar2) Is
    Attr_          Varchar2(4000);
    Info_          Varchar2(4000);
    Attr_Out       Varchar2(4000);
    Podescription_ Varchar2(4000); --零件描述
    Row_           Bl_v_Customer_Order_Chg_Det%Rowtype; --客户订单变更明细
    Mainrow_       Bl_Bill_Vary%Rowtype; --变更主表
    Linerow_       Bl_Bill_Vary_Detail%Rowtype; --变更明细主表
    Mainrow__      Bl_v_Customer_Order_Chg_App%Rowtype; --客户订单变更主档
    Porow_         Bl_v_Po_Line_Part%Rowtype;
    Row_Line_      Bl_v_Cust_Order_Line%Rowtype; --客户订单行
    Row_Reason_    Bl_v_Changereason%Rowtype; --变更选择表
    Prow_          Purchase_Order_Line_Part%Rowtype; --零件选择表  
    Porowline_     Bl_v_Purchase_Order_Chg_Det%Rowtype;
    Pomainrow_     Bl_v_Purchase_Order_Chg_App%Rowtype;
    Planrow22_     Bl_v_Order_Chgp_Delplan%Rowtype;
    Dpchgmrow_     Bl_v_Customer_Order_Chgp_App%Rowtype; --交货计划变更头
    Dprow_         Bl_Delivery_Plan_Detial_v%Rowtype;
    Dpmainrow_     Bl_Delivery_Plan_v%Rowtype;
    Pkrow__        Bl_v_Delivery_Plan_Pk%Rowtype;
    Delplan_No_    Varchar2(1000);
    Cur_           t_Cursor;
    Ccrow_         Bl_v_Delivery_Plan_Detial%Rowtype; --表选头
    Planrow_       Bl_v_Customer_Order_Chgp_Det_3%Rowtype; --交货计划变更明细表
    Coline_Row_    Bl_v_Customer_Order_Line%Rowtype;
    Plandrow_      Bl_Delivery_Plan%Rowtype;
    Price_         Bl_v_Cust_Order_Line_Price%Rowtype;
    Pkrow_         Bl_Pldtl%Rowtype;
  Begin
    Mainrow_.Type_Id := Pkg_a.Get_Item_Value('TYPE_ID', Mainrowlist_);
    If Mainrow_.Type_Id = '0' Or Mainrow_.Type_Id = '7' Then
      --客户订单变更              订单价格变更
      If Mainrow_.Type_Id = '7' Then
        If Column_Id_ = 'LINE_KEY' Then
          Row_.Line_Key := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
          Row_.Order_No := Pkg_a.Get_Item_Value('ORDER_NO', Mainrowlist_);
          Open Cur_ For
            Select t.*
              From Bl_v_Cust_Order_Line_Price t
             Where t.Order_No = Row_.Order_No
               And t.Line_Key = Row_.Line_Key;
          Fetch Cur_
            Into Price_;
          Close Cur_;
          Pkg_a.Set_Item_Value('ORDER_NO', Price_.Order_No, Attr_Out);
          Pkg_a.Set_Item_Value('LINE_NO', Price_.Line_No, Attr_Out);
          Pkg_a.Set_Item_Value('REL_NO', Price_.Rel_No, Attr_Out);
          Pkg_a.Set_Item_Value('LINE_ITEM_NO',
                               Price_.Line_Item_No,
                               Attr_Out);
          Pkg_a.Set_Item_Value('QTY_DELIVED', Price_.Price, Attr_Out);
          Pkg_a.Set_Item_Value('CATALOG_NO', Price_.Catalog_No, Attr_Out);
          Pkg_a.Set_Item_Value('CATALOG_DESC',
                               Price_.Catalog_Desc,
                               Attr_Out);
        End If;
      End If;
      If Column_Id_ = 'MODIFY_TYPE' Then
        --变更类型
        Row_.Modify_Type := Pkg_a.Get_Item_Value('MODIFY_TYPE', Rowlist_);
        --清空数据
        Pkg_a.Set_Item_Value('LINE_NO', '', Attr_Out);
        Pkg_a.Set_Item_Value('REL_NO', '', Attr_Out);
        Pkg_a.Set_Item_Value('LINE_ITEM_NO', '', Attr_Out);
        Pkg_a.Set_Item_Value('CATALOG_NO', '', Attr_Out);
        Pkg_a.Set_Item_Value('QTY_DELIVED', '', Attr_Out);
        Pkg_a.Set_Item_Value('QTY_DELIVEDF', '', Attr_Out);
        Pkg_a.Set_Item_Value('LINE_KEY', '', Attr_Out);
        Pkg_a.Set_Item_Value('CATALOG_DESC', '', Attr_Out);
        Pkg_a.Set_Item_Value('SUPPLY_CODE', '', Attr_Out);
        Pkg_a.Set_Item_Value('VENDOR_NO', '', Attr_Out);
        Pkg_a.Set_Column_Enable('SUPPLY_CODE', '0', Attr_Out);
        Pkg_a.Set_Column_Enable('VENDOR_NO', '0', Attr_Out);
        -- 121108
        Pkg_a.Set_Column_Enable('PICKLISTNO', '0', Attr_Out);
        ----------------------------------------------
        --当新增的时候 不能选择订单 可以选择销售件号
        If Row_.Modify_Type = 'I' Then
          Pkg_a.Set_Column_Enable('LINE_KEY', '0', Attr_Out);
          Pkg_a.Set_Column_Enable('CATALOG_NO', '1', Attr_Out);
          Pkg_a.Set_Item_Value('CATALOG_DESC', '', Attr_Out);
          Pkg_a.Set_Item_Value('LINE_NO', '', Attr_Out);
          Pkg_a.Set_Item_Value('REL_NO', '', Attr_Out);
          Pkg_a.Set_Item_Value('LINE_ITEM_NO', '', Attr_Out);
          Pkg_a.Set_Item_Value('LINE_KEY', '', Attr_Out);
          Pkg_a.Set_Item_Value('QTY_DELIVEDF', '', Attr_Out);
          Pkg_a.Set_Column_Enable('QTY_DELIVEDF', '1', Attr_Out);
          Pkg_a.Set_Column_Enable('SUPPLY_CODE', '1', Attr_Out);
          Pkg_a.Set_Column_Enable('VENDOR_NO', '1', Attr_Out);
        
          --  121108
          Pkg_a.Set_Column_Enable('PICKLISTNO', '1', Attr_Out);
          ---------------------------------------------
        End If;
        --当修改时可以选择订单  不能选择销售件号
        If Row_.Modify_Type = 'M' Then
          Pkg_a.Set_Column_Enable('LINE_KEY', '1', Attr_Out);
          Pkg_a.Set_Column_Enable('CATALOG_NO', '1', Attr_Out);
          Pkg_a.Set_Column_Enable('QTY_DELIVEDF', '1', Attr_Out);
          Pkg_a.Set_Column_Enable('SUPPLY_CODE', '0', Attr_Out);
          Pkg_a.Set_Column_Enable('VENDOR_NO', '0', Attr_Out);
          -- 121108
          Pkg_a.Set_Column_Enable('PICKLISTNO', '0', Attr_Out);
          -------------------------------------------
        End If;
        --当删除时可以选择订单  不能选择销售件号  
        If Row_.Modify_Type = 'D' Then
          Pkg_a.Set_Column_Enable('QTY_DELIVEDF', '0', Attr_Out);
          Pkg_a.Set_Column_Enable('LINE_KEY', '1', Attr_Out);
          Pkg_a.Set_Column_Enable('CATALOG_NO', '1', Attr_Out);
          Pkg_a.Set_Column_Enable('SUPPLY_CODE', '0', Attr_Out);
          Pkg_a.Set_Column_Enable('VENDOR_NO', '0', Attr_Out);
          ---121108
          Pkg_a.Set_Column_Enable('PICKLISTNO', '0', Attr_Out);
          --------------------------------------------
        End If;
      
      End If;
      ---当列名为销售件号
      If Column_Id_ = 'CATALOG_NO' Then
        Mainrow__.Contract := Pkg_a.Get_Item_Value('CONTRACT', Mainrowlist_);
        Row_.Catalog_No    := Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_);
        Row_.Catalog_Desc  := Sales_Part_Api.Get_Catalog_Desc(Mainrow__.Contract,
                                                              Row_.Catalog_No);
        Row_.Order_No      := Pkg_a.Get_Item_Value('ORDER_NO', Mainrowlist_);
        Row_.Modify_Type   := Pkg_a.Get_Item_Value('MODIFY_TYPE', Rowlist_);
        If Row_.Modify_Type <> 'I' Then
          Open Cur_ For
            Select t.*
              From Bl_v_Cust_Order_Line t
             Where t.Order_No = Row_.Order_No
               And t.Catalog_No = Row_.Catalog_No
               And t.State <> 'Cancelled';
          Fetch Cur_
            Into Row_Line_;
          If Cur_%Notfound Then
            Close Cur_;
            Return;
          End If;
          Close Cur_;
          Pkg_a.Set_Item_Value('LINE_KEY', Row_Line_.Line_Key, Attr_Out);
          Pkg_a.Set_Item_Value('LINE_NO', Row_Line_.Line_No, Attr_Out);
          Pkg_a.Set_Item_Value('REL_NO', Row_Line_.Rel_No, Attr_Out);
          Pkg_a.Set_Item_Value('LINE_ITEM_NO',
                               Row_Line_.Line_Item_No,
                               Attr_Out);
          Pkg_a.Set_Item_Value('QTY_DELIVED',
                               Row_Line_.Buy_Qty_Due,
                               Attr_Out);
        End If;
      
        Customer_Order_Line_Api.Get_Line_Defaults__(Info_,
                                                    Attr_,
                                                    Row_.Catalog_No,
                                                    Row_.Order_No);
        Attr_Out := Pkg_a.Get_Attr_By_Ifs(Attr_);
        Pkg_a.Set_Item_Value('CATALOG_NO', Row_.Catalog_No, Attr_Out);
        Pkg_a.Set_Item_Value('CATALOG_DESC', Row_.Catalog_Desc, Attr_Out);
      End If;
      --列名为  供应
      If Column_Id_ = 'SUPPLY_CODE' Then
        Row_.Supply_Code := Pkg_a.Get_Item_Value('SUPPLY_CODE', Rowlist_);
      
        If Nvl(Row_.Supply_Code, '0') = 'Invent Order' Or
           Nvl(Row_.Supply_Code, '0') = 'Pkg' Then
          Pkg_a.Set_Item_Value('VENDOR_NO', '', Attr_Out);
        Else
          Row_.Catalog_No    := Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_);
          Mainrow__.Contract := Pkg_a.Get_Item_Value('CONTRACT',
                                                     Mainrowlist_);
          --IO,IPD,PKG,PT,IPT,NO,PD,SO
          Open Cur_ For
            Select t.Shortid
              From Bl_v_Co_Supply_Code t
             Where t.Id = Row_.Supply_Code;
          Fetch Cur_
            Into Row_.Supply_Code;
          Close Cur_;
        
          Customer_Order_Line_Api.Retrieve_Default_Vendor__(Vendor_No_   => Row_.Vendor_No,
                                                            Contract_    => Mainrow__.Contract,
                                                            Part_No_     => Row_.Catalog_No,
                                                            Supply_Code_ => Row_.Supply_Code);
          Pkg_a.Set_Item_Value('VENDOR_NO', Row_.Vendor_No, Attr_Out);
        
        End If;
      End If;
      --- 当列名为选择行
    
      If Mainrow_.Type_Id = '0' Then
        If Column_Id_ = 'LINE_KEY' Then
          Row_.Line_Key := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
          Row_.Order_No := Pkg_a.Get_Item_Value('ORDER_NO', Mainrowlist_);
          Open Cur_ For
            Select t.*
              From Bl_v_Cust_Order_Line t
             Where t.Order_No = Row_.Order_No
               And t.Line_Key = Row_.Line_Key;
          Fetch Cur_
            Into Row_Line_;
          Close Cur_;
        
          Pkg_a.Set_Item_Value('ORDER_NO', Row_Line_.Order_No, Attr_Out);
          Pkg_a.Set_Item_Value('LINE_NO', Row_Line_.Line_No, Attr_Out);
          Pkg_a.Set_Item_Value('REL_NO', Row_Line_.Rel_No, Attr_Out);
          Pkg_a.Set_Item_Value('LINE_ITEM_NO',
                               Row_Line_.Line_Item_No,
                               Attr_Out);
          Pkg_a.Set_Item_Value('QTY_DELIVED',
                               Row_Line_.Buy_Qty_Due,
                               Attr_Out);
          Pkg_a.Set_Item_Value('CATALOG_NO',
                               Row_Line_.Catalog_No,
                               Attr_Out);
          Pkg_a.Set_Item_Value('CATALOG_DESC',
                               Row_Line_.Catalog_Desc,
                               Attr_Out);
          Row_.Modify_Type := Pkg_a.Get_Item_Value('MODIFY_TYPE', Rowlist_);
          If Nvl(Row_.Modify_Type, 'NULL') = 'NULL' Then
            Pkg_a.Set_Item_Value('MODIFY_TYPE', 'M', Attr_Out);
            Pkg_a.Set_Column_Enable('SUPPLY_CODE', '0', Attr_Out);
          End If;
        End If;
      End If;
    End If;
    If Mainrow_.Type_Id = '1' Then
      --采购订单变更
      Row_.Modify_Type := Pkg_a.Get_Item_Value('MODIFY_TYPE', Rowlist_);
      If Column_Id_ = 'MODIFY_TYPE' Then
        --变更类型
        --当变更类型发生变化 清空行数据
        Pkg_a.Set_Item_Value('LINE_KEY', '', Attr_Out);
        Pkg_a.Set_Item_Value('LINE_NO', '', Attr_Out);
        Pkg_a.Set_Item_Value('REL_NO', '', Attr_Out);
        Pkg_a.Set_Item_Value('PART_NO', '', Attr_Out);
        Pkg_a.Set_Item_Value('DESCRIPTION', '', Attr_Out);
        Pkg_a.Set_Item_Value('QTY_DELIVED', '', Attr_Out);
        Pkg_a.Set_Item_Value('QTY_DELIVEDF', '', Attr_Out);
        --  121108
        Pkg_a.Set_Column_Enable('PICKLISTNO', '0', Attr_Out);
        -------------------------------------------
        --新增时不能选择采购单
        If Row_.Modify_Type = 'I' Then
          Pkg_a.Set_Column_Enable('LINE_KEY', '0', Attr_Out);
          Pkg_a.Set_Column_Enable('PART_NO', '1', Attr_Out);
          Pkg_a.Set_Item_Value('ORDER_NO', '', Attr_Out);
          Pkg_a.Set_Item_Value('LINE_NO', '', Attr_Out);
          Pkg_a.Set_Item_Value('REL_NO', '', Attr_Out);
          Pkg_a.Set_Item_Value('LINE_KEY', '', Attr_Out);
          Pkg_a.Set_Item_Value('DESCRIPTION', '', Attr_Out);
          Pkg_a.Set_Item_Value('QTY_DELIVED', '', Attr_Out);
          Pkg_a.Set_Item_Value('QTY_DELIVEDF', '', Attr_Out);
          Pkg_a.Set_Column_Enable('QTY_DELIVEDF', '1', Attr_Out);
          --  121108
          Pkg_a.Set_Column_Enable('PICKLISTNO', '1', Attr_Out);
          -------------------------------------------
        End If;
        --当修改时可以选择订单  不能选择销售件号
        If Row_.Modify_Type = 'M' Then
          Pkg_a.Set_Column_Enable('LINE_KEY', '1', Attr_Out);
          Pkg_a.Set_Column_Enable('PART_NO', '1', Attr_Out);
          Pkg_a.Set_Column_Enable('QTY_DELIVEDF', '1', Attr_Out);
          --  121108
          Pkg_a.Set_Column_Enable('PICKLISTNO', '0', Attr_Out);
          -------------------------------------------
        End If;
        --当删除时可以选择订单  不能选择销售件号  
        If Row_.Modify_Type = 'D' Then
          Pkg_a.Set_Column_Enable('LINE_KEY', '1', Attr_Out);
          Pkg_a.Set_Column_Enable('PART_NO', '1', Attr_Out);
          Pkg_a.Set_Column_Enable('QTY_DELIVEDF', '0', Attr_Out);
          --  121108
          Pkg_a.Set_Column_Enable('PICKLISTNO', '0', Attr_Out);
          -------------------------------------------
        End If;
      End If;
      If Column_Id_ = 'LINE_KEY' Then
        --当列名为选择行时候
        Row_.Line_Key := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
        Row_.Order_No := Pkg_a.Get_Item_Value('ORDER_NO', Mainrowlist_);
        Open Cur_ For
          Select t.*
            From Bl_v_Po_Line_Part t
           Where t.Order_No = Row_.Order_No
             And t.Line_Key = Row_.Line_Key;
        Fetch Cur_
          Into Porow_;
        Close Cur_;
        Pkg_a.Set_Item_Value('ORDER_NO', Porow_.Order_No, Attr_Out);
        Pkg_a.Set_Item_Value('LINE_NO', Porow_.Line_No, Attr_Out);
        Pkg_a.Set_Item_Value('REL_NO', Porow_.Release_No, Attr_Out);
        Pkg_a.Set_Item_Value('QTY_DELIVED', Porow_.Buy_Qty_Due, Attr_Out);
        Pkg_a.Set_Item_Value('PART_NO', Porow_.Part_No, Attr_Out);
        Pkg_a.Set_Item_Value('DESCRIPTION', Porow_.Description, Attr_Out);
      End If;
      If Column_Id_ = 'PART_NO' Then
        --当列名为零件号
        Porowline_.Part_No   := Pkg_a.Get_Item_Value('PART_NO', Rowlist_);
        Porowline_.Order_No  := Pkg_a.Get_Item_Value('ORDER_NO',
                                                     Mainrowlist_);
        Pomainrow_.Contract  := Pkg_a.Get_Item_Value('CONTRACT',
                                                     Mainrowlist_);
        Pomainrow_.Vendor_No := Pkg_a.Get_Item_Value('VENDOR_NO',
                                                     Mainrowlist_);
        If Row_.Modify_Type <> 'I' Then
          --当变更类型不是新增时候
          Open Cur_ For
            Select t.*
              From Purchase_Order_Line_Part t
             Where t.Order_No = Porowline_.Order_No
               And t.Part_No = Porowline_.Part_No
               And t.State <> 'Cancelled';
          Fetch Cur_
            Into Prow_;
          Close Cur_;
          Pkg_a.Set_Item_Value('PART_NO', Porowline_.Part_No, Attr_Out);
          Pkg_a.Set_Item_Value('QTY_DELIVED', Prow_.Buy_Qty_Due, Attr_Out);
          Pkg_a.Set_Item_Value('LINE_NO', Prow_.Line_No, Attr_Out);
          Pkg_a.Set_Item_Value('REL_NO', Prow_.Release_No, Attr_Out);
          Pkg_a.Set_Item_Value('ORDER_NO', Prow_.Order_No, Attr_Out);
          Pkg_a.Set_Item_Value('LINE_KEY',
                               Prow_.Order_No || '-' ||
                               To_Char(Prow_.Line_No) || '-' ||
                               To_Char(Prow_.Release_No),
                               Attr_Out);
          Pkg_a.Set_Item_Value('DESCRIPTION', Prow_.Description, Attr_Out);
        End If;
        If Row_.Modify_Type = 'I' Then
          Select Description
            Into Podescription_
            From Purchase_Part_Lov3 t
           Where t.Part_No = Porowline_.Part_No
             And t.Vendor_No = Pomainrow_.Vendor_No
             And t.Contract = Pomainrow_.Contract;
          Porowline_.Order_No := Pkg_a.Get_Item_Value('ORDER_NO',
                                                      Mainrowlist_);
          Pkg_a.Set_Item_Value('PART_NO', Porowline_.Part_No, Attr_Out);
          Pkg_a.Set_Item_Value('DESCRIPTION', Podescription_, Attr_Out);
        End If;
      End If;
    End If;
    If Mainrow_.Type_Id = '2' --交货计划变更 （工厂）
       Or Mainrow_.Type_Id = '21' --交货计划变更 （业务）
       Or Mainrow_.Type_Id = '3' -- 备货单
       Or Mainrow_.Type_Id = '6' -- 备货单N
     Then
      /*      Pkg_a.Set_Column_Enable('PLAN_LINE_KEY', '0', Attr_Out);
      Pkg_a.Set_Column_Enable('DELIVED_DATEF', '0', Attr_Out);*/
      If Column_Id_ = 'LINE_KEY' Or Column_Id_ = 'F_LINE_KEY' Or
         Column_Id_ = 'CATALOG_NO' Then
        Dpchgmrow_.Supplier := Pkg_a.Get_Item_Value('SUPPLIER',
                                                    Mainrowlist_);
        If Column_Id_ = 'LINE_KEY' Then
          Planrow_.Line_Key := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
          Set_Order_Item(Planrow_, Planrow_.Line_Key);
        End If;
        If Column_Id_ = 'F_LINE_KEY' Then
          Planrow_.f_Line_Key := Pkg_a.Get_Item_Value('F_LINE_KEY',
                                                      Rowlist_);
          Set_f_Order_Item(Planrow_, Planrow_.f_Line_Key);
          If Mainrow_.Type_Id = '2' Then
            Pkg_a.Set_Item_Value('MODIFY_TYPE', '', Attr_Out);
            Pkg_a.Set_Item_Value('PICKLISTNO', '', Attr_Out);
          End If;
        End If;
      
        If Column_Id_ = 'CATALOG_NO' Then
          Planrow_.Catalog_No := Pkg_a.Get_Item_Value('CATALOG_NO',
                                                      Rowlist_);
          Planrow_.Order_No   := Pkg_a.Get_Item_Value('ORDER_NO',
                                                      Mainrowlist_);
          Set_Catalog_Item(Planrow_,
                           Planrow_.Order_No,
                           Planrow_.Catalog_No,
                           Dpchgmrow_.Supplier,
                           Mainrow_.Type_Id);
        End If;
        --赋值
        Set_Item(Planrow_, Attr_Out);
        If Mainrow_.Type_Id = '3' Then
          Planrow_.Blorder_No := Bl_Customer_Order_Api.Get_Column_Data('BLORDER_NO',
                                                                       Planrow_.Order_No);
          Pkg_a.Set_Item_Value('BLORDER_NO', Planrow_.Blorder_No, Attr_Out);
          Pkg_a.Set_Item_Value('SUPPLIER', Planrow_.Supplier, Attr_Out);
        End If;
        --        Pkg_a.Set_Item_Value('MAIN_CUSTOMER_NO', '2222', Attr_Out);
        If Mainrow_.Type_Id = '6' Then
          Planrow_.Picklistno := Pkg_a.Get_Item_Value('PICKLISTNO',
                                                      Mainrowlist_);
          Planrow_.Blorder_No := Bl_Customer_Order_Api.Get_Column_Data('BLORDER_NO',
                                                                       Planrow_.Order_No);
          Pkg_a.Set_Item_Value('BLORDER_NO', Planrow_.Blorder_No, Attr_Out);
          Planrow_.Qty_Delived := Bl_Customer_Order_Line_Api.Get_Picklist_Qty__(Planrow_.Picklistno,
                                                                                Planrow_.Order_No,
                                                                                Planrow_.Line_No,
                                                                                Planrow_.Rel_No,
                                                                                Planrow_.Line_Item_No);
          Open Cur_ For
            Select t.*
              From Bl_Delivery_Plan_Detial_v t
             Where t.Picklistno = Planrow_.Picklistno
               And t.Order_No = Planrow_.Order_No
               And t.Line_No = Planrow_.Line_No
               And t.Rel_No = Planrow_.Rel_No
               And t.Line_Item_No = Planrow_.Line_Item_No
               And t.State = '2'; --确认状态
          Fetch Cur_
            Into Dprow_;
          If Planrow_.Qty_Delived > 0 Then
            If Cur_%Notfound Then
              Raise_Application_Error(Pkg_a.Raise_Error,
                                      '存在备货单找不到对应的交货计划');
            End If;
            Close Cur_;
          Else
            Close Cur_;
            Open Cur_ For
              Select To_Date(t.Deldate, 'YYYY-MM-DD')
                From Bl_Picklist t
               Where t.Picklistno = Planrow_.Picklistno;
            Fetch Cur_
              Into Dprow_.Delived_Date;
            If Cur_%Notfound Then
              Raise_Application_Error(Pkg_a.Raise_Error, '备货单不存在了');
            End If;
            Close Cur_;
            Loop
              Open Cur_ For
                Select t.Delplan_No
                  From Bl_Delivery_Plan t
                 Where t.Order_No = Planrow_.Order_No
                   And t.Supplier = Planrow_.Supplier
                   And t.Delived_Date = Dprow_.Delived_Date;
              Fetch Cur_
                Into Planrow_.Delplan_No;
              If Cur_%Notfound Then
                Close Cur_;
                Exit;
              Else
                Close Cur_;
              End If;
              Dprow_.Delived_Date := Dprow_.Delived_Date + 1;
            End Loop;
          End If;
        
          Planrow_.Plan_Line_Key := Dprow_.Delplan_No || '-' ||
                                    Dprow_.Delplan_Line;
          Pkg_a.Set_Item_Value('PLAN_LINE_KEY',
                               Planrow_.Plan_Line_Key,
                               Attr_Out);
          Pkg_a.Set_Item_Value('DELPLAN_NO', Dprow_.Delplan_No, Attr_Out);
          Pkg_a.Set_Item_Value('DELPLAN_LINE',
                               Nvl(Dprow_.Delplan_Line, 0),
                               Attr_Out);
        
          Pkg_a.Set_Item_Value('PICKLISTNO', Planrow_.Picklistno, Attr_Out);
          Pkg_a.Set_Item_Value('DELIVED_DATEF',
                               To_Char(Dprow_.Delived_Date, 'YYYY-MM-DD'),
                               Attr_Out);
          Pkg_a.Set_Item_Value('DELIVED_DATE',
                               To_Char(Dprow_.Delived_Date, 'YYYY-MM-DD'),
                               Attr_Out);
        
          Planrow_.Qty_Delived := Nvl(Dprow_.Qty_Delived, 0);
          Pkg_a.Set_Item_Value('QTY_DELIVED',
                               Planrow_.Qty_Delived,
                               Attr_Out);
        
          Planrow_.Qty_Delivedf := Pkg_a.Get_Item_Value('QTY_DELIVEDF',
                                                        Rowlist_);
          Planrow_.Qty_Delivedf := Nvl(Planrow_.Qty_Delivedf, 0);
        
          Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                               Planrow_.Qty_Delivedf,
                               Attr_Out);
          Planrow_.Qty_Change := Planrow_.Qty_Delivedf -
                                 Planrow_.Qty_Delived;
        
          Pkg_a.Set_Item_Value('QTY_CHANGE', Planrow_.Qty_Change, Attr_Out);
        End If;
      End If;
      --明细变更类型
    
      If Mainrow_.Type_Id = '2' And Column_Id_ = 'MODIFY_TYPE' Then
        Pkg_a.Set_Column_Enable('PLAN_LINE_KEY', '0', Attr_Out);
        Pkg_a.Set_Column_Enable('DELIVED_DATEF', '0', Attr_Out);
        Row_.Modify_Type := Pkg_a.Get_Item_Value('MODIFY_TYPE', Rowlist_);
        If Row_.Modify_Type = 'DPM' Then
          Pkg_a.Set_Column_Enable('PLAN_LINE_KEY', '1', Attr_Out);
          Pkg_a.Set_Column_Enable('DELIVED_DATEF', '0', Attr_Out);
        End If;
        If Row_.Modify_Type = 'DPI' Then
          Pkg_a.Set_Column_Enable('PLAN_LINE_KEY', '0', Attr_Out);
          Pkg_a.Set_Column_Enable('DELIVED_DATEF', '1', Attr_Out);
        End If;
        Pkg_a.Set_Item_Value('PICKLISTNO', '', Attr_Out);
        Pkg_a.Set_Item_Value('PLAN_LINE_KEY', '', Attr_Out);
        Pkg_a.Set_Item_Value('DELIVED_DATEF', '', Attr_Out);
        Pkg_a.Set_Item_Value('QTY_DELIVEDF', 0, Attr_Out);
        Pkg_a.Set_Item_Value('DELPLAN_NO', '', Attr_Out);
        Pkg_a.Set_Item_Value('QTY_DELIVED', 0, Attr_Out);
        Pkg_a.Set_Item_Value('QTY_CHANGE', 0, Attr_Out);
      End If;
      --交货计划号
      If Column_Id_ = 'PLAN_LINE_KEY' Or Column_Id_ = 'PLAN_ORDER_KEY' Then
        If Column_Id_ = 'PLAN_LINE_KEY' Then
          Planrow_.Plan_Line_Key := Pkg_a.Get_Item_Value('PLAN_LINE_KEY',
                                                         Rowlist_);
        
          Bldelivery_Plan_Line_Api.Get_Record_By_Line_Key(Planrow_.Plan_Line_Key,
                                                          Dprow_);
          If Mainrow_.Type_Id = '2' Then
            Pkg_a.Set_Item_Value('MODIFY_TYPE', 'DPM', Attr_Out);
          End If;
        End If;
      
        If Column_Id_ = 'PLAN_ORDER_KEY' Then
          Planrow_.Plan_Order_Key := Pkg_a.Get_Item_Value('PLAN_ORDER_KEY',
                                                          Rowlist_);
          Planrow_.Order_No       := Pkg_a.Get_Str_(Planrow_.Plan_Order_Key,
                                                    '-',
                                                    1);
          Planrow_.Line_No        := Pkg_a.Get_Str_(Planrow_.Plan_Order_Key,
                                                    '-',
                                                    2);
          Planrow_.Rel_No         := Pkg_a.Get_Str_(Planrow_.Plan_Order_Key,
                                                    '-',
                                                    3);
          Planrow_.Line_Item_No   := Pkg_a.Get_Str_(Planrow_.Plan_Order_Key,
                                                    '-',
                                                    4);
          Planrow_.Delplan_No     := Pkg_a.Get_Str_(Planrow_.Plan_Order_Key,
                                                    '-',
                                                    5);
          --包装件
          If Planrow_.Line_Item_No = -1 Then
            Planrow_.Delplan_No := Pkg_a.Get_Str_(Planrow_.Plan_Order_Key,
                                                  '-',
                                                  6);
          End If;
          Planrow_.Line_Key := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
          If Nvl(Planrow_.Line_Key, '-') !=
             Planrow_.Order_No || '-' || Planrow_.Line_No || '-' ||
             Planrow_.Rel_No || '-' || Planrow_.Line_Item_No Then
            --获取订单行内容
            Planrow_.Line_Key := Planrow_.Order_No || '-' ||
                                 Planrow_.Line_No || '-' || Planrow_.Rel_No || '-' ||
                                 Planrow_.Line_Item_No;
            Set_Order_Item(Planrow_, Planrow_.Line_Key);
          
            --Raise_Application_Error(Pkg_a.Raise_Error, Planrow_.Order_No);
            Set_Item(Planrow_, Attr_Out);
            If Mainrow_.Type_Id = '3' Then
              Planrow_.Blorder_No := Bl_Customer_Order_Api.Get_Column_Data('BLORDER_NO',
                                                                           Planrow_.Order_No);
              Pkg_a.Set_Item_Value('BLORDER_NO',
                                   Planrow_.Blorder_No,
                                   Attr_Out);
              Pkg_a.Set_Item_Value('SUPPLIER', Planrow_.Supplier, Attr_Out);
            End If;
          End If;
          Open Cur_ For
            Select t.*
              From Bl_Delivery_Plan_Detial_v t
             Where t.Delplan_No = Planrow_.Delplan_No
               And t.Order_No = Planrow_.Order_No
               And t.Line_No = Planrow_.Line_No
               And t.Rel_No = Planrow_.Rel_No
               And t.Line_Item_No = Planrow_.Line_Item_No;
          Fetch Cur_
            Into Dprow_;
          --有交货计划
          If Cur_%Notfound Then
            Close Cur_;
          
            Open Cur_ For
              Select t.*
                From Bl_Delivery_Plan_v t
               Where t.Delplan_No = Planrow_.Delplan_No
                 And t.State = '2';
            Fetch Cur_
              Into Dpmainrow_;
            If Cur_%Notfound Then
              Raise_Application_Error(Pkg_a.Raise_Error,
                                      '错误的交货计划号' || Planrow_.Delplan_No);
            End If;
            Close Cur_;
            Dprow_.Delplan_No   := Dpmainrow_.Delplan_No;
            Dprow_.Delplan_Line := 0;
            Dprow_.Picklistno   := Dpmainrow_.Picklistno;
            Dprow_.Delived_Date := Dpmainrow_.Delived_Date;
            Dprow_.Qty_Delived  := 0;
          Else
          
            Close Cur_;
          
          End If;
          --赋值        
        End If;
        If Pkg_a.Get_Item_Value_By_Index('-',
                                         '&',
                                         Planrow_.Plan_Line_Key || '&') = '0' Then
          Plandrow_.Delplan_No := Pkg_a.Get_Item_Value_By_Index('&',
                                                                '-',
                                                                '&' ||
                                                                Planrow_.Plan_Line_Key);
          Pkg_a.Set_Item_Value('PLAN_LINE_KEY',
                               Planrow_.Plan_Line_Key,
                               Attr_Out);
          Pkg_a.Set_Item_Value('DELPLAN_NO',
                               Plandrow_.Delplan_No,
                               Attr_Out);
          Pkg_a.Set_Item_Value('DELPLAN_LINE', '0', Attr_Out);
          Open Cur_ For
            Select t.*
              From Bl_Delivery_Plan t
             Where t.Delplan_No = Plandrow_.Delplan_No;
          Fetch Cur_
            Into Plandrow_;
          If Cur_%Notfound Then
            Close Cur_;
            Return;
          End If;
          Close Cur_;
          Pkg_a.Set_Item_Value('PICKLISTNO',
                               Plandrow_.Picklistno,
                               Attr_Out);
          Pkg_a.Set_Item_Value('DELIVED_DATEF',
                               To_Char(Plandrow_.Delived_Date, 'YYYY-MM-DD'),
                               Attr_Out);
          Pkg_a.Set_Item_Value('DELIVED_DATE',
                               To_Char(Plandrow_.Delived_Date, 'YYYY-MM-DD'),
                               Attr_Out);
          Pkg_a.Set_Item_Value('QTY_DELIVED', 0, Attr_Out);
          --         Pkg_a.Set_Item_Value('BUY_QTY_DUE', 0, Attr_Out);
          Planrow_.Qty_Delivedf := Pkg_a.Get_Item_Value('QTY_DELIVEDF',
                                                        Rowlist_);
        
        Else
          Pkg_a.Set_Item_Value('PLAN_LINE_KEY',
                               Dprow_.Delplan_No || '-' ||
                               Dprow_.Delplan_Line,
                               Attr_Out);
        
          Pkg_a.Set_Item_Value('DELPLAN_NO', Dprow_.Delplan_No, Attr_Out);
          Pkg_a.Set_Item_Value('DELPLAN_LINE',
                               Dprow_.Delplan_Line,
                               Attr_Out);
          Pkg_a.Set_Item_Value('PICKLISTNO', Dprow_.Picklistno, Attr_Out);
          Pkg_a.Set_Item_Value('DELIVED_DATEF',
                               To_Char(Dprow_.Delived_Date, 'YYYY-MM-DD'),
                               Attr_Out);
          Pkg_a.Set_Item_Value('DELIVED_DATE',
                               To_Char(Dprow_.Delived_Date, 'YYYY-MM-DD'),
                               Attr_Out);
          Pkg_a.Set_Item_Value('QTY_DELIVED', Dprow_.Qty_Delived, Attr_Out);
        
          Planrow_.Qty_Delived  := Dprow_.Qty_Delived;
          Planrow_.Qty_Delivedf := Pkg_a.Get_Item_Value('QTY_DELIVEDF',
                                                        Rowlist_);
          Planrow_.Qty_Delivedf := Nvl(Planrow_.Qty_Delivedf, 0);
          Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                               Planrow_.Qty_Delivedf,
                               Attr_Out);
          Planrow_.Qty_Change := Planrow_.Qty_Delivedf -
                                 Planrow_.Qty_Delived;
        
          Pkg_a.Set_Item_Value('QTY_CHANGE', Planrow_.Qty_Change, Attr_Out);
        End If;
      
      End If;
    
      If Column_Id_ = 'PICKNOLIST' Then
        Planrow_.Picklistno   := Pkg_a.Get_Item_Value('PICKLISTNO',
                                                      Rowlist_);
        Planrow_.Order_No     := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
        Planrow_.Line_No      := Pkg_a.Get_Item_Value('LINE_NO', Rowlist_);
        Planrow_.Rel_No       := Pkg_a.Get_Item_Value('REL_NO', Rowlist_);
        Planrow_.Line_Item_No := Pkg_a.Get_Item_Value('LINE_ITEM_NO',
                                                      Rowlist_);
        --检测订单行在当前备货单中是否存在 --
        Open Cur_ For
          Select t.*
            From Bl_Pldtl t
           Where t.Picklistno = Planrow_.Picklistno
             And t.Order_No = Planrow_.Order_No
             And t.Line_No = Planrow_.Line_No
             And t.Rel_No = Planrow_.Rel_No
             And t.Line_Item_No = Planrow_.Line_Item_No;
        Fetch Cur_
          Into Pkrow_;
        If Cur_%Found Then
          Close Cur_;
          --读取交货计划的值 --如果没有交货计划数据 变更生成交货计划的数据
        End If;
        Close Cur_;
      
        --pkrow_
      
      End If;
    
      If Column_Id_ = 'DELIVED_DATEF' Then
        Planrow_.Delived_Datef := To_Date(Pkg_a.Get_Item_Value('DELIVED_DATEF',
                                                               Rowlist_),
                                          'YYYY-MM-DD');
        Planrow_.Order_No      := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
        --        Raise_Application_Error(-20101,Planrow_.Order_No || '在表中不存在');
        Planrow_.Line_No      := Pkg_a.Get_Item_Value('LINE_NO', Rowlist_);
        Planrow_.Rel_No       := Pkg_a.Get_Item_Value('REL_NO', Rowlist_);
        Planrow_.Line_Item_No := Pkg_a.Get_Item_Value('LINE_ITEM_NO',
                                                      Rowlist_);
        --检测系统是否存在当前交期的数据
        Bldelivery_Plan_Line_Api.Get_Record_By_Order_Date(Planrow_.Order_No,
                                                          Planrow_.Line_No,
                                                          Planrow_.Rel_No,
                                                          Planrow_.Line_Item_No,
                                                          Planrow_.Delived_Datef,
                                                          Dprow_);
      
        Planrow_.Plan_Line_Key := Dprow_.Delplan_No || '-' ||
                                  Dprow_.Delplan_Line;
        If Planrow_.Plan_Line_Key = '-' Then
          Planrow_.Plan_Line_Key := '';
          --判断 当前日期有没有交货计划
          --
          Dpchgmrow_.Order_No := Pkg_a.Get_Item_Value('ORDER_NO',
                                                      Mainrowlist_);
          Dpchgmrow_.Supplier := Pkg_a.Get_Item_Value('SUPPLIER',
                                                      Mainrowlist_);
          -- bldelivery_plan_api.
        
          Bldelivery_Plan_Api.Get_Record_By_Order_Date(Dpchgmrow_.Order_No,
                                                       Dpchgmrow_.Supplier,
                                                       Planrow_.Delived_Datef,
                                                       Dpmainrow_);
          Dprow_.Delplan_No := Dpmainrow_.Delplan_No;
          If Nvl(Dprow_.Delplan_No, '-') <> '-' Then
            Dprow_.Delplan_Line := 0;
            Dprow_.Delived_Date := Planrow_.Delived_Datef;
            Dprow_.Picklistno   := Dpmainrow_.Picklistno;
          End If;
        
        End If;
        Planrow_.Plan_Line_Key := Dprow_.Delplan_No || '-' ||
                                  Dprow_.Delplan_Line;
        If Planrow_.Plan_Line_Key = '-' Then
          Planrow_.Plan_Line_Key := '';
          Planrow_.Modify_Type   := 'DPI';
        Else
          Planrow_.Plan_Line_Key := Planrow_.Plan_Line_Key;
          Planrow_.Modify_Type   := 'DPM';
        End If;
        Pkg_a.Set_Item_Value('PLAN_LINE_KEY',
                             Planrow_.Plan_Line_Key,
                             Attr_Out);
        Pkg_a.Set_Item_Value('DELPLAN_NO', Dprow_.Delplan_No, Attr_Out);
        Pkg_a.Set_Item_Value('DELPLAN_LINE', Dprow_.Delplan_Line, Attr_Out);
        Pkg_a.Set_Item_Value('PICKLISTNO', Dprow_.Picklistno, Attr_Out);
        Pkg_a.Set_Item_Value('DELIVED_DATE',
                             To_Char(Dprow_.Delived_Date, 'YYYY-MM-DD'),
                             Attr_Out);
        Pkg_a.Set_Item_Value('QTY_DELIVED',
                             Nvl(Dprow_.Qty_Delived, 0),
                             Attr_Out);
      
        Planrow_.Qty_Delived  := Dprow_.Qty_Delived;
        Planrow_.Qty_Delivedf := Pkg_a.Get_Item_Value('QTY_DELIVEDF',
                                                      Rowlist_);
        Planrow_.Qty_Delivedf := Nvl(Planrow_.Qty_Delivedf, 0);
        Pkg_a.Set_Item_Value('QTY_DELIVEDF',
                             Planrow_.Qty_Delivedf,
                             Attr_Out);
        Planrow_.Qty_Change := Planrow_.Qty_Delivedf - Planrow_.Qty_Delived;
      
        Pkg_a.Set_Item_Value('QTY_CHANGE', Planrow_.Qty_Change, Attr_Out);
        Pkg_a.Set_Item_Value('MODIFY_TYPE', Planrow_.Modify_Type, Attr_Out);
      End If;
    
      If Column_Id_ = 'QTY_DELIVEDF' Then
        Row_.Qty_Delivedf := Nvl(Pkg_a.Get_Item_Value('QTY_DELIVEDF',
                                                      Rowlist_),
                                 '0');
        Row_.Qty_Delived  := Nvl(Pkg_a.Get_Item_Value('QTY_DELIVED',
                                                      Rowlist_),
                                 '0');
        Pkg_a.Set_Item_Value('QTY_CHANGE',
                             Nvl(Row_.Qty_Delivedf, 0) -
                             Nvl(Row_.Qty_Delived, 0),
                             Attr_Out);
      End If;
    End If;
    If Mainrow_.Type_Id = '22' Then
      If Column_Id_ = 'LINE_KEY' Then
        Row_.Line_Key := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
        Open Cur_ For
          Select t.*
            From Bl_v_Order_Chgp_Delplan t
           Where t.Delplan_No = Row_.Line_Key;
        Fetch Cur_
          Into Planrow22_;
        If Cur_ %Notfound Then
          Close Cur_;
          Return;
        End If;
        Close Cur_;
        Linerow_.Delived_Datef := To_Date(Pkg_a.Get_Item_Value('DELIVED_DATEF',
                                                               Rowlist_),
                                          'YYYY-MM-DD');
        Pkg_a.Set_Item_Value('ORDER_NO', Planrow22_.Order_No, Attr_Out);
        Pkg_a.Set_Item_Value('CUSTOMER_REF',
                             Planrow22_.Customer_Ref,
                             Attr_Out);
        Pkg_a.Set_Item_Value('DELIVED_DATE',
                             To_Char(Planrow22_.Delived_Date, 'YYYY-MM-DD'),
                             Attr_Out);
        Pkg_a.Set_Item_Value('DELIVED_DATEF',
                             Linerow_.Delived_Datef,
                             Attr_Out);
      
      End If;
    End If;
    If Column_Id_ = 'REASON' Then
      ---当列名为变更原因
      Row_.Reason := Pkg_a.Get_Item_Value('REASON', Rowlist_);
      /*    If Mainrow_.Type_Id = '0' Or Mainrow_.Type_Id = '1' Then*/
      Open Cur_ For
        Select t.*
          From Bl_v_Changereason t
         Where t.Reason_No = Row_.Reason;
      Fetch Cur_
        Into Row_Reason_;
      /*    Else
      Open Cur_ For
        Select t.* From Bl_v_Reason_c t Where t.Reason_No = Row_.Reason;
      Fetch Cur_
        Into Row_Reason_;*/
      /*      End If;*/
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, Row_.Reason || '在表中不存在');
        Return;
      End If;
      Close Cur_;
      Pkg_a.Set_Item_Value('REASON_DESCRIPTION',
                           Row_Reason_.Reason_Description,
                           Attr_Out);
    End If;
    If Mainrow_.Type_Id = '5' Then
      Row_.Modify_Type := Pkg_a.Get_Item_Value('MODIFY_TYPE', Rowlist_);
      If Column_Id_ = 'MODIFY_TYPE' Then
        Pkg_a.Set_Item_Value('LINE_KEY', '', Attr_Out);
        Pkg_a.Set_Item_Value('ORDER_NO', '', Attr_Out);
        Pkg_a.Set_Item_Value('BLORDER_NO', '', Attr_Out);
        Pkg_a.Set_Item_Value('PICKLISTNO', '', Attr_Out);
        Pkg_a.Set_Item_Value('CUSTOMER_REF', '', Attr_Out);
        Pkg_a.Set_Item_Value('CONTRACT', '', Attr_Out);
        Pkg_a.Set_Item_Value('SUPPLIER', '', Attr_Out);
        Pkg_a.Set_Item_Value('DELIVED_DATE', '', Attr_Out);
      End If;
      If Column_Id_ = 'LINE_KEY' Then
        Delplan_No_ := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_);
        Open Cur_ For
          Select t.*
            From Bl_v_Delivery_Plan_Pk t
           Where t.Delplan_No = Delplan_No_;
        Fetch Cur_
          Into Pkrow__;
        If Cur_%Notfound Then
          Close Cur_;
          Return;
        End If;
        Close Cur_;
        Pkg_a.Set_Item_Value('PICKLISTNO', Pkrow__.Picklistno, Attr_Out);
        Pkg_a.Set_Item_Value('ORDER_NO', Pkrow__.Order_No, Attr_Out);
        Pkg_a.Set_Item_Value('BLORDER_NO', Pkrow__.Blorder_No, Attr_Out);
        Pkg_a.Set_Item_Value('CUSTOMER_REF',
                             Pkrow__.Customer_Ref,
                             Attr_Out);
        Pkg_a.Set_Item_Value('CONTRACT', Pkrow__.Contract, Attr_Out);
        Pkg_a.Set_Item_Value('SUPPLIER', Pkrow__.Supplier, Attr_Out);
        Pkg_a.Set_Item_Value('DELIVED_DATE',
                             Pkrow__.Delived_Date,
                             Attr_Out);
        Pkg_a.Set_Item_Value('ORG_ORDERNO', Pkrow__.Org_Orderno, Attr_Out);
      End If;
    End If;
    Outrowlist_ := Attr_Out;
    Return;
  End;

  -- 变更界面列名显示是否可编辑
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    Row_      Bl_Bill_Vary_Detail%Rowtype;
    Rowc_     Bl_v_Customer_Order_Chgp_Det0%Rowtype;
    Mainrow_  Bl_Bill_Vary%Rowtype;
    Objid_    Varchar(100);
    User_Id_  Varchar2(100);
    Supplier_ Varchar(100);
    Cur_      t_Cursor;
  Begin
    Row_.State := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    Objid_     := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    If Nvl(Objid_, 'NULL') = 'NULL' Then
      Return '1';
    End If;
    -- 判断 用户的域权限 如果当前用户  没有域的权限不能修改域的数据
  
    Row_.Modify_Type := Pkg_a.Get_Item_Value('MODIFY_TYPE', Rowlist_);
    If Substr(Pkg_a.Get_Item_Value('MODIFY_ID', Rowlist_), 1, 1) = '0' Then
      If Row_.Modify_Type = 'D' Then
        If Column_Id_ = 'QTY_DELIVEDF' Then
          Return '0';
        End If;
      End If;
    End If;
    --获取如果 交货计划 是由  差异发货 或者 备货单过来的 不能编辑
    If Row_.Modify_Type = 'PK' Then
      If Column_Id_ = 'QTY_DELIVEDF' And Nvl(Row_.State, '0') = '0' Then
        Return Checkuseable_(Rowlist_);
      End If;
      Return '0';
    End If;
    --差异发货
    If Row_.Modify_Type = 'FM' Then
      Return '0';
    End If;
  
    If Nvl(Row_.State, '0') = '0' And
       (Column_Id_ = 'QTY_DELIVEDF' /*Or Column_Id_ = 'DELIVED_DATEF'*/
        Or Column_Id_ = 'PLAN_LINE_KEY') Then
      Return Checkuseable_(Rowlist_);
    End If;
  
    If Nvl(Row_.State, '0') = '0' Then
      If Column_Id_ = 'REMARK' Or Column_Id_ = 'REASON' Then
      
        Return Checkuseable_(Rowlist_);
      Else
        Return '0';
      End If;
    End If;
  
    Return '0';
  End;
  Function Checkuseable_(Rowlist_ In Varchar2) Return Varchar2 Is
    Row_      Bl_Bill_Vary_Detail%Rowtype;
    Mainrow_  Bl_Bill_Vary%Rowtype;
    User_Id_  Varchar2(100);
    Supplier_ Varchar(100);
    Cur_      t_Cursor;
  Begin
    Row_.Modify_Id := Pkg_a.Get_Item_Value('MODIFY_ID', Rowlist_);
    If Substr(Row_.Modify_Id, 1, 1) = '2' Then
      Open Cur_ For
        Select t.* From Bl_Bill_Vary t Where t.Modify_Id = Row_.Modify_Id;
      Fetch Cur_
        Into Mainrow_;
      Close Cur_;
      --交货计划变更
    
      --  BL_V_CUSTOMER_ORDER_CHGP_APP
      --工厂域
      User_Id_  := Pkg_a.Get_Item_Value('USER_ID', Rowlist_);
      Supplier_ := Pkg_a.Get_Item_Value_By_Index('-',
                                                 '&',
                                                 Mainrow_.Source_No || '&');
      --判断当前用户有没有工厂域的权限
      If Pkg_Attr.Checkcontract(User_Id_, Supplier_) = 1 Then
        Return '1';
      Else
        Return '0';
      End If;
    
    End If;
    Return '1';
  End;
  Procedure Set_Item(Planrow_ In Bl_v_Customer_Order_Chgp_Det_3%Rowtype,
                     Attr_Out In Out Varchar2) Is
  Begin
  
    Pkg_a.Set_Item_Value('LINE_KEY', Planrow_.Line_Key, Attr_Out);
    Pkg_a.Set_Item_Value('ORDER_NO', Planrow_.Order_No, Attr_Out);
    Pkg_a.Set_Item_Value('LINE_NO', Planrow_.Line_No, Attr_Out);
    Pkg_a.Set_Item_Value('REL_NO', Planrow_.Rel_No, Attr_Out);
    Pkg_a.Set_Item_Value('LINE_ITEM_NO', Planrow_.Line_Item_No, Attr_Out);
  
    Pkg_a.Set_Item_Value('F_LINE_KEY', Planrow_.f_Line_Key, Attr_Out);
    Pkg_a.Set_Item_Value('F_ORDER_NO', Planrow_.f_Order_No, Attr_Out);
    Pkg_a.Set_Item_Value('F_LINE_NO', Planrow_.f_Line_No, Attr_Out);
    Pkg_a.Set_Item_Value('F_REL_NO', Planrow_.f_Rel_No, Attr_Out);
    Pkg_a.Set_Item_Value('F_LINE_ITEM_NO',
                         Planrow_.f_Line_Item_No,
                         Attr_Out);
  
    Pkg_a.Set_Item_Value('CATALOG_NO', Planrow_.Catalog_No, Attr_Out);
    Pkg_a.Set_Item_Value('CATALOG_DESC', Planrow_.Catalog_Desc, Attr_Out);
  
    Pkg_a.Set_Item_Value('BUY_QTY_DUE', Planrow_.Buy_Qty_Due, Attr_Out);
    Pkg_a.Set_Item_Value('DELPLAN_NO', Planrow_.Delplan_No, Attr_Out);
    Pkg_a.Set_Item_Value('DELPLAN_LINE', Planrow_.Delplan_Line, Attr_Out);
    Pkg_a.Set_Item_Value('DELIVED_DATEF', '', Attr_Out);
    Pkg_a.Set_Item_Value('DELIVED_DATE', '', Attr_Out);
    Pkg_a.Set_Item_Value('QTY_DELIVED', '0', Attr_Out);
    Pkg_a.Set_Item_Value('PLAN_LINE_KEY', '', Attr_Out);
    Pkg_a.Set_Item_Value('SUPPLIER', Planrow_.Supplier, Attr_Out);
  
  End;
  Procedure Set_Catalog_Item(Planrow_    In Out Bl_v_Customer_Order_Chgp_Det_3%Rowtype,
                             Order_No_   In Varchar2,
                             Catalog_No_ In Varchar2,
                             Supplier_   In Varchar2,
                             Type_Id_    In Varchar2) Is
    Coline_Row_ Bl_v_Customer_Order_Line%Rowtype;
    Cur_        t_Cursor;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order_Line t
       Where t.Order_No = Order_No_
         And t.Catalog_No = Catalog_No_
         And t.State <> 'Cancelled';
    Fetch Cur_
      Into Coline_Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101,
                              '物料编码' || Catalog_No_ || '不存在');
      Return;
    End If;
  
    Planrow_.Order_No     := Coline_Row_.Order_No;
    Planrow_.Line_No      := Coline_Row_.Line_No;
    Planrow_.Rel_No       := Coline_Row_.Rel_No;
    Planrow_.Line_Item_No := Coline_Row_.Line_Item_No;
    Planrow_.Catalog_No   := Coline_Row_.Catalog_No;
    Planrow_.Catalog_Desc := Coline_Row_.Catalog_Desc;
  
    Planrow_.Buy_Qty_Due := Coline_Row_.Buy_Qty_Due;
    Planrow_.f_Line_Key  := Bl_Customer_Order_Line_Api.Get_Factory_Order_(Planrow_.Order_No,
                                                                          Planrow_.Line_No,
                                                                          Planrow_.Rel_No,
                                                                          Planrow_.Line_Item_No);
  
    Bl_Customer_Order_Line_Api.Get_Record_By_Line_Key(Planrow_.f_Line_Key,
                                                      Coline_Row_);
    If Type_Id_ = '2' --交货计划变更 （工厂）
       Or Type_Id_ = '21' Then
      If Coline_Row_.Contract != Supplier_ Then
        Raise_Application_Error(-20101,
                                '物料编码' || Planrow_.Catalog_No || '不存在');
        Return;
      
      End If;
    End If;
    Planrow_.Supplier       := Coline_Row_.Contract;
    Planrow_.f_Order_No     := Coline_Row_.Order_No;
    Planrow_.f_Line_No      := Coline_Row_.Line_No;
    Planrow_.f_Rel_No       := Coline_Row_.Rel_No;
    Planrow_.f_Line_Item_No := Coline_Row_.Line_Item_No;
    Planrow_.Line_Key       := Planrow_.Order_No || '-' || Planrow_.Line_No || '-' ||
                               Planrow_.Rel_No || '-' ||
                               Planrow_.Line_Item_No;
    Planrow_.f_Line_Key     := Planrow_.f_Order_No || '-' ||
                               Planrow_.f_Line_No || '-' ||
                               Planrow_.f_Rel_No || '-' ||
                               Planrow_.f_Line_Item_No;
  
  End;
  Procedure Set_Order_Item(Planrow_  In Out Bl_v_Customer_Order_Chgp_Det_3%Rowtype,
                           Line_Key_ In Varchar2) Is
    Coline_Row_ Bl_v_Customer_Order_Line%Rowtype;
  Begin
    Planrow_.Line_Key := Line_Key_;
    Bl_Customer_Order_Line_Api.Get_Record_By_Line_Key(Planrow_.Line_Key,
                                                      Coline_Row_);
    Planrow_.Order_No     := Coline_Row_.Order_No;
    Planrow_.Line_No      := Coline_Row_.Line_No;
    Planrow_.Rel_No       := Coline_Row_.Rel_No;
    Planrow_.Line_Item_No := Coline_Row_.Line_Item_No;
    Planrow_.Catalog_No   := Coline_Row_.Catalog_No;
    Planrow_.Catalog_Desc := Coline_Row_.Catalog_Desc;
  
    Planrow_.Buy_Qty_Due := Coline_Row_.Buy_Qty_Due;
    Planrow_.f_Line_Key  := Bl_Customer_Order_Line_Api.Get_Factory_Order_(Planrow_.Order_No,
                                                                          Planrow_.Line_No,
                                                                          Planrow_.Rel_No,
                                                                          Planrow_.Line_Item_No);
  
    Bl_Customer_Order_Line_Api.Get_Record_By_Line_Key(Planrow_.f_Line_Key,
                                                      Coline_Row_);
    Planrow_.Supplier       := Coline_Row_.Contract;
    Planrow_.f_Order_No     := Coline_Row_.Order_No;
    Planrow_.f_Line_No      := Coline_Row_.Line_No;
    Planrow_.f_Rel_No       := Coline_Row_.Rel_No;
    Planrow_.f_Line_Item_No := Coline_Row_.Line_Item_No;
    Planrow_.Line_Key       := Planrow_.Order_No || '-' || Planrow_.Line_No || '-' ||
                               Planrow_.Rel_No || '-' ||
                               Planrow_.Line_Item_No;
    Planrow_.f_Line_Key     := Planrow_.f_Order_No || '-' ||
                               Planrow_.f_Line_No || '-' ||
                               Planrow_.f_Rel_No || '-' ||
                               Planrow_.f_Line_Item_No;
  End;

  Procedure Set_f_Order_Item(Planrow_    In Out Bl_v_Customer_Order_Chgp_Det_3%Rowtype,
                             f_Line_Key_ In Varchar2) Is
    Coline_Row_ Bl_v_Customer_Order_Line%Rowtype;
  Begin
    Planrow_.f_Line_Key := f_Line_Key_;
    Bl_Customer_Order_Line_Api.Get_Record_By_Line_Key(Planrow_.f_Line_Key,
                                                      Coline_Row_);
  
    Planrow_.Supplier       := Coline_Row_.Contract;
    Planrow_.f_Order_No     := Coline_Row_.Order_No;
    Planrow_.f_Line_No      := Coline_Row_.Line_No;
    Planrow_.f_Rel_No       := Coline_Row_.Rel_No;
    Planrow_.f_Line_Item_No := Coline_Row_.Line_Item_No;
    Planrow_.Catalog_No     := Coline_Row_.Catalog_No;
    Planrow_.Catalog_Desc   := Coline_Row_.Catalog_Desc;
    Planrow_.Buy_Qty_Due    := Coline_Row_.Buy_Qty_Due;
    Planrow_.f_Line_Key     := Bl_Customer_Order_Line_Api.Get_Par_Order_(Planrow_.f_Order_No,
                                                                         Planrow_.f_Line_No,
                                                                         Planrow_.f_Rel_No,
                                                                         Planrow_.f_Line_Item_No);
  
    Bl_Customer_Order_Line_Api.Get_Record_By_Line_Key(Planrow_.f_Line_Key,
                                                      Coline_Row_);
  
    Planrow_.Order_No     := Coline_Row_.Order_No;
    Planrow_.Line_No      := Coline_Row_.Line_No;
    Planrow_.Rel_No       := Coline_Row_.Rel_No;
    Planrow_.Line_Item_No := Coline_Row_.Line_Item_No;
    Planrow_.Line_Key     := Planrow_.Order_No || '-' || Planrow_.Line_No || '-' ||
                             Planrow_.Rel_No || '-' ||
                             Planrow_.Line_Item_No;
    Planrow_.f_Line_Key   := Planrow_.f_Order_No || '-' ||
                             Planrow_.f_Line_No || '-' || Planrow_.f_Rel_No || '-' ||
                             Planrow_.f_Line_Item_No;
  End;

  ----检查添加行 删除行 
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2 Is
    Cur_      t_Cursor;
    Mainrow_  Bl_Bill_Vary%Rowtype;
    Supplier_ Varchar2(100);
  Begin
    Open Cur_ For
      Select t.* From Bl_Bill_Vary t Where t.Modify_Id = Order_No_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_%Notfound Then
      Close Cur_;
      Return '0';
    End If;
    Close Cur_;
    If Mainrow_.Type_Id = '22' Then
      Return '0';
    End If;
  
    If Mainrow_.State <> '0' Then
      Return '0';
    Else
      If Mainrow_.Type_Id = '2' Then
        Supplier_ := Pkg_a.Get_Item_Value_By_Index('-',
                                                   '&',
                                                   Mainrow_.Source_No || '&');
      
        If Pkg_Attr.Checkcontract(User_Id_, Supplier_) = 1 Then
          Return '1';
        Else
          Return '0';
        End If;
      End If;
    End If;
  
    Return '1';
  End;

  Function Checkordervary(Smodify_Id_   In Varchar2,
                          Modify_Id_    In Varchar2,
                          Order_No_     In Varchar2,
                          Line_No_      In Varchar2,
                          Rel_No_       In Varchar2,
                          Line_Item_No_ In Number) Return Number Is
    Modify_Type_ Varchar2(2);
    Cur_         t_Cursor;
    Row_         Bl_v_Customer_Order_Chgp_Det%Rowtype;
    Key_List_    Varchar2(200);
  Begin
    If Nvl(Smodify_Id_, '-') = '-' Then
      Return 1;
    End If;
    Modify_Type_ := Substr(Smodify_Id_, 1, 1);
    --备货单变更  和差异发货 变更
    -- If Modify_Type_ = '6' Or Modify_Type_ = 'F' Then
  
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order_Chgp_Det t
       Where t.Modify_Id = Modify_Id_
         And t.f_Order_No = Order_No_
         And t.f_Line_No = Line_No_
         And t.f_Rel_No = Rel_No_
         And t.f_Line_Item_No = Line_Item_No_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Return 0;
    Else
      Close Cur_;
      Return 1;
    End If;
    -- End If;
    Return 1;
  
  End;
End Blbill_Vary_Line_Api;
/
