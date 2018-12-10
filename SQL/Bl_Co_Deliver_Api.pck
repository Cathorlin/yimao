CREATE OR REPLACE Package Bl_Co_Deliver_Api Is
  /* 客户订单（备货单）的预留 
   参数：
    ROWLIST_：当LS_TYPE='CO'为视图BL_V_CO_DELIVER_DETAIL_YL_CO中字段及值以及字符串doaction字段和值
              当LS_TYPE='BP'为视图BL_V_CO_DELIVER_DETAIL_YL中字段及值以及字符串doaction字段和值
    LS_TYPE:值(CO)为客户订单预留，值(BP)为备货单预留
  */
  Procedure Save__(Rowlist_  Varchar2,
                   User_Id_  Varchar2,
                   A311_Key_ Varchar2,
                   Ls_Type_  Varchar2 Default 'CO');
  Procedure Save1__(Rowlist_  Varchar2,
                    User_Id_  Varchar2,
                    A311_Key_ Varchar2);
  --客户订单的送货（作废拆分开成提货跟发货）
  Procedure Deliver__(Rowid_    Varchar2, -- 视图BL_V_CO_DELIVER_DETAIL_CO的objid
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --提货函数
  Procedure Billlading__(Order_No_ Varchar2, -- 视图BL_V_CO_DELIVER_DETAIL的objid
                         User_Id_  Varchar2,
                         A311_Key_ Varchar2);
  --客户订单提货
  Procedure Billlad_Order(Rowid_    Varchar2, -- 视图BL_V_CO_DELIVER_DETAIL_CO的objid
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);
  --备货单提货                        
  Procedure Billlad_Pick(Rowid_    Varchar2, -- 视图BL_V_CO_DELIVER_DETAIL_CO的objid
                         User_Id_  Varchar2,
                         A311_Key_ Varchar2);
  --客户订单送货  
  Procedure Deliver_Order(Rowid_    Varchar2, -- 视图BL_V_CO_DELIVER_DETAIL的objid
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);
  --备货单送货  
  Procedure Deliver_Pick(Rowid_    Varchar2, -- 视图BL_V_CO_DELIVER_DETAIL的objid
                         User_Id_  Varchar2,
                         A311_Key_ Varchar2);
  --订单自动预留
  Procedure Obligate_Order(Rowid_    Varchar2, -- 视图BL_V_CO_DELIVER_CO的objid
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2);
  --备货单自动预留
  Procedure Obligate_Pick(Rowid_    Varchar2, -- 视图BL_V_CO_DELIVER的objid
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);                      
  --备货单的送货（作废拆分开成提货跟发货）
  Procedure Deliver1__(Rowid_    Varchar2, -- 视图BL_V_CO_DELIVER_CO的objid
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  --备货单取消提货
  Procedure Billladcancel_Pick(Rowid_    Varchar2,
                               User_Id_  Varchar2,
                               A311_Key_ Varchar2);
  --客户订单取消提货
  Procedure Billladcancel_Order(Rowid_    Varchar2,
                                User_Id_  Varchar2,
                                A311_Key_ Varchar2);
  --插入交货计划的明细的日志
  Procedure Delivery_Plan_Hist(Delplan_No_ Varchar2, --交货计划bl_delivery_plan主键
                               User_Id_    Varchar2,
                               A311_Key_   Varchar2,
                               Msg_        In Varchar2); --- 消息号
  --插入备货单（客户订单）预留后台表
  Procedure Insert_Bl_Pltrans(Row_      Bl_Pltrans%Rowtype,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);
  --调用ifs发货函数
  Procedure Deliver_Line_With_Diff__(Picklistno_   Varchar2, -- 备货单号
                                     Order_No_     Varchar2, --订单号
                                     Line_No_      Varchar2, --订单行
                                     Rel_No_       Varchar2, --订单交货号
                                     Line_Item_No_ Number, --订单序号
                                     Close_Line_   Number, --是否全部发货标示:全部(1)部分(0)
                                     User_Id_      Varchar2,
                                     A311_Key_     Varchar2);
  --调用带传递参数的ifs发货函数
  Procedure Deliver_Line_With_Diff_Qty__(Info_         Out Varchar2,
                                         Order_No_     Varchar2, --订单号
                                         Line_No_      Varchar2, --订单行
                                         Rel_No_       Varchar2, --订单交货号
                                         Line_Item_No_ Number, --订单序号
                                         Close_Line_   Number, --是否全部发货标示:全部(1)部分(0)
                                         User_Id_      Varchar2,
                                         A311_Key_     Varchar2);
  --快捷预留 modify fjp 2013-01-17 
  Procedure Fast_Reservation_(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);
  --获取工厂订单号的信息                                  
  Function Get_Factory_Order_(Order_No_     In Varchar2,
                              Line_No_      In Varchar2,
                              Rel_No_       Varchar2,
                              Line_Item_No_ Number,
                              Type_         Varchar2) Return Varchar2;
  --根据订单号获取预留                           
  Function Get_Qty_Assigned_(Order_No_         In Varchar2,
                             Line_No_          In Varchar2,
                             Rel_No_           In Varchar2,
                             Line_Item_No_     Number,
                             Contract_         In Varchar2,
                             Part_No_          In Varchar2,
                             Configuration_Id_ In Varchar2,
                             Location_No_      In Varchar2,
                             Lot_Batch_No_     In Varchar2,
                             Serial_No_        In Varchar2,
                             Waiv_Dev_Rej_No_  In Varchar2,
                             Eng_Chg_Level_    In Varchar2) Return Number;
  --根据备货单号获取预留                          
  Function Get_Picklist_Assigned_(Picklistno_       In Varchar2,
                                  Order_No_         In Varchar2,
                                  Line_No_          In Varchar2,
                                  Rel_No_           In Varchar2,
                                  Line_Item_No_     Number,
                                  Contract_         In Varchar2,
                                  Configuration_Id_ In Varchar2,
                                  Location_No_      In Varchar2,
                                  Lot_Batch_No_     In Varchar2,
                                  Serial_No_        In Varchar2,
                                  Waiv_Dev_Rej_No_  In Varchar2,
                                  Eng_Chg_Level_    In Varchar2)
    Return Number;
  --获取备货单号的总的预留
  Function Get_Picklist_Allassigned_(Picklistno_   In Varchar2,
                                     Order_No_     In Varchar2,
                                     Line_No_      In Varchar2,
                                     Rel_No_       In Varchar2,
                                     Line_Item_No_ Number) Return Number;
  --获取包装件的系数                                  
  Function Get_Customer_Pkgcoefficient_(Order_No_     Varchar2,
                                        Line_No_      Varchar2,
                                        Rel_No_       Varchar2,
                                        Line_Item_No_ Number,
                                        Qty_          Number) Return Number;
  --获取主档的状态
  Function Get_Customer_State_(Order_No_ Varchar2) Return Varchar2;
  --获取 备货单预留/订单预留 的连接url
  Function Getdeliver_Orderurl(Order_Line_ In Varchar2) Return Varchar2;
  --获取交货的状态
  function Get_PartDeliver(picklistno_   varchar2,
                           Order_No_     Varchar2,
                           Line_No_      Varchar2,
                           Rel_No_       Varchar2,
                           Line_Item_No_ Number,
                           finishqty_          Number) return varchar2;
End Bl_Co_Deliver_Api;
/
CREATE OR REPLACE Package Body Bl_Co_Deliver_Api Is
  /*  create fjp 2012-10-15 
  modify  fjp 2012-11-08 增加了备货单取消功能
  modify  fjp 2012-11-12 增加了客户订单取消功能
  modify fjp  2012-11-15  增加了存在交货计划变更不能发货
  modify fjp 2012-12-05  修改交货的时候检测变更：当存在交货计划的变更变多时，可以发货，
                                                 当存在交货计划的变更变少时，不可以发货
  modify fjp 2012-12-07  增加在发货完成的时候更新备货单的确定并生产发票
  modify fjp 2013-01-17  增肌快捷预留功能
  modify fjp 2013-01-18  增加检验ifs预留表中存在但是在bl表中不存在的订单的其他项预留为0
  modify fjp 2013-01-29  增加订单的自动预留跟备货单的自动预留
  modify fjp 2013-01-31  检测包装是否提交*/
  Type t_Cursor Is Ref Cursor;
  Procedure Save__(Rowlist_  Varchar2,
                   User_Id_  Varchar2,
                   A311_Key_ Varchar2,
                   Ls_Type_  Varchar2 Default 'CO') Is
    Index_             Varchar2(1);
    Doaction_          Varchar2(1);
    Objid_             Varchar2(200);
    Cur_               t_Cursor;
    Cur1_              t_Cursor;
    Row1_              Bl_Pltrans%Rowtype;
    Qty_Assigned_      Number; --分配数量
    Info_              Varchar2(1000);
    State_             Varchar2(20);
    Pallet_Id_         Varchar2(100);
    Next_Picklistno_   Varchar2(100);
    Ls_Sql_            Varchar2(1000);
    Part_No_           Bl_v_Co_Deliver_Detail_Yl_Co.Part_No%Type;
    Location_No_       Bl_v_Co_Deliver_Detail_Yl_Co.Location_No%Type;
    Lot_Batch_No_      Bl_v_Co_Deliver_Detail_Yl_Co.Lot_Batch_No%Type;
    Serial_No_         Bl_v_Co_Deliver_Detail_Yl_Co.Serial_No%Type;
    Eng_Chg_Level_     Bl_v_Co_Deliver_Detail_Yl_Co.Eng_Chg_Level%Type;
    Waiv_Dev_Rej_No_   Bl_v_Co_Deliver_Detail_Yl_Co.Waiv_Dev_Rej_No%Type;
    Configuration_Id_  Bl_v_Co_Deliver_Detail_Yl_Co.Configuration_Id%Type;
    Qty_Reserved_      Bl_v_Co_Deliver_Detail_Yl_Co.Qty_Reserved%Type Default 0; --预留数量
    Order_No_          Bl_v_Co_Deliver_Detail_Co.Order_No%Type;
    Line_No_           Bl_v_Co_Deliver_Detail_Co.Line_No%Type;
    Rel_No_            Bl_v_Co_Deliver_Detail_Co.Rel_No%Type;
    Line_Item_No_      Bl_v_Co_Deliver_Detail_Co.Line_Item_No%Type;
    Contract_          Bl_v_Co_Deliver_Detail_Co.Contract%Type;
    Picklistno_        Bl_v_Co_Deliver_Detail.Picklistno%Type;
    Main_Qty_Reserved_ Bl_v_Co_Deliver_Detail_Yl_Co.Main_Qty_Reserved%Type;
    Main_Qty_Assigned_ Bl_v_Co_Deliver_Detail_Co.Qty_Assigned%Type Default 0;
    Row2_              Customer_Order_Reservation_Tab%Rowtype;
    Ll_Count_          Number;
    qty_picked_        number;--提货数量
    Lf_Assigned_ Varchar2(1) Default '0'; --判断合计预留
  
  Begin
    Index_        := f_Get_Data_Index();
    Objid_        := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_     := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    Qty_Assigned_ := Pkg_a.Get_Item_Value('QTY_ASSIGNED', Rowlist_);
    If (Pkg_a.Item_Exist('QTY_ASSIGNED', Rowlist_)) = False Then
      --If Qty_Assigned_ Is Null Then
      -- Raise_Application_Error(-20101, '分配的数量不能为空');
      Return;
    End If;
  
    --判断是否更改分配数量
    If Doaction_ = 'M' Then
      -- 获取库位信息
      If Ls_Type_ = 'CO' Then
        Ls_Sql_ := 'select t.next_picklistno,t.part_no,t.location_no,
        t.lot_batch_no,t.serial_no,t.ENG_CHG_LEVEL,
        t.WAIV_DEV_REJ_NO,t.CONFIGURATION_ID,
        t.main_qty_reserved from BL_V_CO_DELIVER_DETAIL_YL_CO t where ipobjid = ''' ||
                   Pkg_a.Get_Str_(Objid_, '-', 1) || ''' and  coobjid= ''' ||
                   Pkg_a.Get_Str_(Objid_, '-', 2) || ''' AND objid =''' ||
                   Objid_ || '''';
      Else
        /*   ipisr.objid || '-' || bp.objid objid,
        bp.objid as bpobjid,
        ipisr.objid as ipobjid,*/
        Ls_Sql_ := 'select t.next_picklistno,t.part_no,t.location_no,
        t.lot_batch_no,t.serial_no,t.ENG_CHG_LEVEL,t.WAIV_DEV_REJ_NO,
        t.CONFIGURATION_ID,t.main_qty_reserved from BL_V_CO_DELIVER_DETAIL_YL t
         where ipobjid=''' ||
                   Pkg_a.Get_Str_(Objid_, '-', 1) || '''
          AND bpobjid=''' ||
                   Pkg_a.Get_Str_(Objid_, '-', 2) || '''
          AND objid =''' || Objid_ || '''';
      End If;
      Open Cur_ For Ls_Sql_;
      Fetch Cur_
        Into Next_Picklistno_,
             Part_No_,
             Location_No_,
             Lot_Batch_No_,
             Serial_No_,
             Eng_Chg_Level_,
             Waiv_Dev_Rej_No_,
             Configuration_Id_,
             Main_Qty_Reserved_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
      End If;
      Close Cur_;
      /*      if qty_assigned_ > main_qty_reserved_  then 
         raise_application_error(-20101,'分配的数量不能大于可预留的数量');
         return ; 
      end if ;*/
      -- 获取客户订单行信息
      If Ls_Type_ = 'CO' Then
        --contract||'-'||CATALOG_NO||'-'||ORDER_NO||'-'||line_no||'-'||rel_no||'-'||to_char(line_item_no) as next_picklistno
        /*       SELECT t.Order_No,
              t.Order_No,
              t.Line_No,
              t.Rel_No,
              t.Line_Item_No,
              t.Contract --,nvl(t.QTY_ASSIGNED,0)
         INTO Picklistno_,
              Order_No_,
              Line_No_,
              Rel_No_,
              Line_Item_No_,
              Contract_ --,main_QTY_ASSIGNED_
         FROM Bl_v_Co_Deliver_Detail_Co t
        WHERE t.Contract = Pkg_a.Get_Str_(Next_Picklistno_, '-', 1)
          AND t.Catalog_No = Pkg_a.Get_Str_(Next_Picklistno_, '-', 2)
          AND t.Order_No = Pkg_a.Get_Str_(Next_Picklistno_, '-', 3)
          AND t.Line_No = Pkg_a.Get_Str_(Next_Picklistno_, '-', 4)
          AND t.Rel_No = Pkg_a.Get_Str_(Next_Picklistno_, '-', 5)
          AND t.Line_Item_No = Pkg_a.Get_Str_(Next_Picklistno_, '-', 6)
          AND Next_Picklistno = Next_Picklistno_;*/
      
        Picklistno_   := Pkg_a.Get_Str_(Next_Picklistno_, '-', 3);
        Order_No_     := Pkg_a.Get_Str_(Next_Picklistno_, '-', 3);
        Line_No_      := Pkg_a.Get_Str_(Next_Picklistno_, '-', 4);
        Rel_No_       := Pkg_a.Get_Str_(Next_Picklistno_, '-', 5);
        Line_Item_No_ := Pkg_a.Get_Str_(Next_Picklistno_, '-', 6);
        Contract_     := Pkg_a.Get_Str_(Next_Picklistno_, '-', 1);
      Else
        -- bp.picklistno||'-'||bp.order_no||'-'||bp.line_no||'-'||bp.rel_no||'-'||to_char(colt.line_item_no)  as next_picklistno,
        --bp.order_no as  co_order_no,bp.line_no as co_line_no,bp.rel_no as co_rel_no,bp.line_item_no as co_line_item_no
        Select t.Picklistno,
               t.Order_No,
               t.Line_No,
               t.Rel_No,
               t.Line_Item_No,
               t.Contract --,nvl(t.QTY_ASSIGNED,0)
          Into Picklistno_,
               Order_No_,
               Line_No_,
               Rel_No_,
               Line_Item_No_,
               Contract_ --,main_QTY_ASSIGNED_
          From Bl_v_Co_Deliver_Detail t
         Where t.Picklistno = Pkg_a.Get_Str_(Next_Picklistno_, '-', 1)
           And t.Co_Order_No = Pkg_a.Get_Str_(Next_Picklistno_, '-', 2)
           And t.Co_Line_No = Pkg_a.Get_Str_(Next_Picklistno_, '-', 3)
           And t.Co_Rel_No = Pkg_a.Get_Str_(Next_Picklistno_, '-', 4)
           And t.Co_Line_Item_No = Pkg_a.Get_Str_(Next_Picklistno_, '-', 5)
           And Next_Picklistno = Next_Picklistno_;
      
      End If;
      --判断是否有别的订单已经做过预留
      Select Count(*)
        Into Ll_Count_
        From Bl_Pltrans
       Where Picklistno <> Picklistno_
         And Order_No = Order_No_
         And Line_No = Line_No_
         And Rel_No = Rel_No_
         And Line_Item_No = Line_Item_No_
         And Flag = '0';
      If Ll_Count_ > 0 Then
        Raise_Application_Error(-20101,
                                '此订单行的备货单预留已经做过，等前一个备货单完成发货才能预留');
        Return;
      End If;
      --判断前期是否预留，如果有预留则传入分配参数-已预留数量，保证预留的数量是录入的分配数量
      Open Cur1_ For
        Select t.*
          From Customer_Order_Reservation_Tab t
         Where t.Order_No = Order_No_
           And t.Line_No = Line_No_
           And t.Rel_No = Rel_No_
           And t.Line_Item_No = Line_Item_No_
           And t.Qty_Assigned > 0;
      --  and    t.CONTRACT  = contract_
      -- and    t.PART_NO   = part_no_
      --  and    t.CONFIGURATION_ID=CONFIGURATION_ID_
      -- and    t.LOCATION_NO =location_no_
      --  and    t.LOT_BATCH_NO=lot_batch_no_
      --  and    t.SERIAL_NO =serial_no_
      --  and    t.WAIV_DEV_REJ_NO=WAIV_DEV_REJ_NO_
      --  and    t.ENG_CHG_LEVEL=ENG_CHG_LEVEL_
      -- and    t.PICK_LIST_NO='*'
      --  and    t.PALLET_ID  ='*';
      Fetch Cur1_
        Into Row2_;
      /*       if cur1_%notfound  then
          qty_reserved_  :=row2_.qty_assigned;
      else
          qty_reserved_ :=0;
      end if ;*/
      While Cur1_%Found Loop
        If Row2_.Contract = Contract_ And Row2_.Part_No = Part_No_ And
           Row2_.Configuration_Id = Configuration_Id_ And
           Row2_.Location_No = Location_No_ And
           Row2_.Lot_Batch_No = Lot_Batch_No_ And
           Row2_.Serial_No = Serial_No_ And
           Row2_.Waiv_Dev_Rej_No = Waiv_Dev_Rej_No_ And
           Row2_.Eng_Chg_Level = Eng_Chg_Level_ And
           Row2_.Pallet_Id = '*' Then
           if Row2_.Qty_picked > Row2_.Qty_Assigned then
              Qty_Reserved_ := Qty_Reserved_ + Row2_.Qty_picked;
           else
              Qty_Reserved_ := Qty_Reserved_ + Row2_.Qty_Assigned;
           end if;
           if  Row2_.Qty_picked >0  then 
             qty_picked_ :=qty_picked_ + Row2_.Qty_picked;
           end if ;
        Else
          Main_Qty_Assigned_ := Main_Qty_Assigned_ + Row2_.Qty_Assigned;
        End If;
        Fetch Cur1_
          Into Row2_;
      End Loop;
      Close Cur1_;
    
      -- if main_QTY_ASSIGNED_ =0 then 
      --     main_QTY_ASSIGNED_ := qty_assigned_;
      --  else
      Main_Qty_Assigned_ := Main_Qty_Assigned_ + Qty_Assigned_;
      -- end if ;
      If Main_Qty_Assigned_ > Main_Qty_Reserved_ Then
        Raise_Application_Error(-20101, '分配的数量不能大于可预留的数量');
        Return;
      End If;
      if Qty_Assigned_ < qty_picked_ then 
        Raise_Application_Error(-20101, '分配的数量不能小于提货的数量');
        Return;
      end if ;
      If Qty_Reserved_ > 0 Then
        Qty_Assigned_ := Qty_Assigned_ - Qty_Reserved_;
      End If;
      --调用IFS的预留函数
      Reserve_Customer_Order_Api.Reserve_Manually__(Info_,
                                                    State_,
                                                    Order_No_,
                                                    Line_No_,
                                                    Rel_No_,
                                                    Line_Item_No_,
                                                    Contract_,
                                                    Part_No_,
                                                    Location_No_,
                                                    Lot_Batch_No_,
                                                    Serial_No_,
                                                    Eng_Chg_Level_,
                                                    Waiv_Dev_Rej_No_,
                                                    Pallet_Id_,
                                                    Qty_Assigned_);
      --获取备货单(订单)预留表
      Row1_.Picklistno       := Picklistno_;
      Row1_.Order_No         := Order_No_;
      Row1_.Line_No          := Line_No_;
      Row1_.Rel_No           := Rel_No_;
      Row1_.Line_Item_No     := Line_Item_No_;
      Row1_.Qty_Assigned     := Qty_Assigned_;
      Row1_.Contract         := Contract_;
      Row1_.Location_No      := Location_No_;
      Row1_.Lot_Batch_No     := Lot_Batch_No_;
      Row1_.Serial_No        := Serial_No_;
      Row1_.Eng_Chg_Leve     := Eng_Chg_Level_;
      Row1_.Waiv_Dev_Rej_No  := Waiv_Dev_Rej_No_;
      Row1_.Configuration_Id := Configuration_Id_;
      Row1_.Catalog_No       := Part_No_;
      Row1_.Flag             := '0';
      --插入备货单(订单)预留表
      Insert_Bl_Pltrans(Row1_, User_Id_, A311_Key_);
      If Ls_Type_ = 'CO' Then
        Pkg_a.Setsuccess(A311_Key_, 'BL_V_CO_DELIVER_DETAIL_YL_CO', Objid_);
      Else
        Pkg_a.Setsuccess(A311_Key_, 'BL_V_CO_DELIVER_DETAIL_YL', Objid_);
      End If;
      Return;
    End If;
  End;
  Procedure Save1__(Rowlist_  Varchar2,
                    User_Id_  Varchar2,
                    A311_Key_ Varchar2) Is
  Begin
    Save__(Rowlist_, User_Id_, A311_Key_, 'BP');
  End;
  Procedure Deliver__(Rowid_    Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
    Row0_       Bl_v_Co_Deliver_Detail_Co%Rowtype;
    Row_        Bl_v_Co_Deliver_Co%Rowtype;
    Cur_        t_Cursor;
    Attr_       Varchar2(1000);
    Close_Line_ Number;
    Ll_Count_   Number;
  Begin
    Select t.* Into Row_ From Bl_v_Co_Deliver_Co t Where t.Objid = Rowid_;
    Select Count(*)
      Into Ll_Count_
      From Bl_v_Customer_Order
     Where Order_No = Row_.Order_No
       And State In
           ('Partially', 'Delivered', 'Picked', 'Released', 'Reserved');
    If Ll_Count_ = 0 Then
      Raise_Application_Error(-20101,
                              '订单' || Row_.Order_No || '不是可发货状态');
      Return;
    End If;
    --拼提货单单号的字符串
    Attr_ := '';
    Client_Sys.Add_To_Attr('START_EVENT', '70', Attr_);
    Client_Sys.Add_To_Attr('ORDER_NO', Row_.Order_No, Attr_);
    Client_Sys.Add_To_Attr('END', '', Attr_);
    --调用ifs的提货单交货 
    Customer_Order_Flow_Api.Start_Create_Pick_List__(Attr_);
    Open Cur_ For
      Select t.*
        From Bl_v_Co_Deliver_Detail_Co t
       Where t.Order_No = Row_.Order_No
         And t.Qty_Assigned > 0;
    Fetch Cur_
      Into Row0_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    While Cur_%Found Loop
      If Row0_.Qty_Assigned = Row0_.Qty_Reserved Then
        Close_Line_ := 1;
      Else
        Close_Line_ := 0;
      End If;
      Pkg_a.Setnextdo(A311_Key_,
                      'BL_CO_DELIVER_API.Deliver_Line_With_Diff__',
                      User_Id_,
                      'BL_CO_DELIVER_API.Deliver_Line_With_Diff__(''' ||
                      Row0_.Order_No || ''',''' || Row0_.Order_No ||
                      ''',''' || Row0_.Line_No || ''',''' || Row0_.Rel_No ||
                      ''',''' || Row0_.Line_Item_No || ''',''' ||
                      Close_Line_ || ''',''' || User_Id_ || ''',''' ||
                      A311_Key_ || ''')',
                      2 / 60 / 24);
      Fetch Cur_
        Into Row0_;
    End Loop;
    Close Cur_;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CO_DELIVER_DETAIL_CO', Rowid_);
    Return;
  End;
  Procedure Billlading__(Order_No_ Varchar2, -- 视图BL_V_CO_DELIVER_DETAIL的objid
                         User_Id_  Varchar2,
                         A311_Key_ Varchar2) Is
    Ll_Count_ Number;
    Attr_     Varchar2(1000);
    Cur_      t_Cursor;
    Row_      Customer_Order_Tab%Rowtype;
  Begin
    Open Cur_ For
      Select t.*
        From Customer_Order_Tab t
       Where Order_No = Order_No_
         And Rowstate In ('Reserved', 'Picked', 'PartiallyDelivered')
         And Contract In
             (Select Contract
                From Ifsapp.Site_Public
               Where Contract =
                     Ifsapp.User_Allowed_Site_Api.Authorized(Contract))
         And Ifsapp.Reserve_Customer_Order_Api.Reserved_With_No_Pick_List__(Order_No) = 1;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Raise_Application_Error(-20101,
                              '订单号' || Order_No_ || '不能做提货操作');
      Return;
    End If;
    Close Cur_;
    --拼提货单单号的字符串
    Attr_ := '';
    Client_Sys.Add_To_Attr('START_EVENT', '70', Attr_);
    Client_Sys.Add_To_Attr('ORDER_NO', Order_No_, Attr_);
    Client_Sys.Add_To_Attr('END', '', Attr_);
    --调用ifs的提货单交货 
    Customer_Order_Flow_Api.Start_Create_Pick_List__(Attr_);
    Return;
  End;
  Procedure Billlad_Order(Rowid_    Varchar2, -- 视图BL_V_CO_DELIVER_DETAIL_CO的objid
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
    Row_ Bl_v_Co_Deliver_Co%Rowtype;
  Begin
    Select t.* Into Row_ From Bl_v_Co_Deliver_Co t Where t.Objid = Rowid_;
    Billlading__(Row_.Order_No, User_Id_, A311_Key_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CO_DELIVER_CO', Rowid_);
    Return;
  End;
  Procedure Billlad_Pick(Rowid_    Varchar2, -- 视图BL_V_CO_DELIVER_DETAIL_CO的objid
                         User_Id_  Varchar2,
                         A311_Key_ Varchar2) Is
    Row_          Bl_v_Co_Deliver%Rowtype;
    Row0_         Bl_v_Co_Deliver_Detail%Rowtype;
    Row1_         Customer_Order_Reservation_Tab%Rowtype;
    Cur_          t_Cursor;
    Cur1_         t_Cursor;
    Info_         Varchar2(1000);
    State_        Varchar2(20);
    Pallet_Id_    Varchar2(100);
    Qty_Assigned_ Number;
    Order_No_     Varchar2(20);
    Order_No_Dis_ Dbms_Sql.Varchar2_Table;
    i_            Number Default 0;
    v_            Number Default 0;
    If_Exist_     Varchar2(1) Default '0';
  Begin
     --modify fjp 2013-01-18  增加检验ifs预留表中存在但是在bl表中不存在的订单的其他项预留为0
      Open Cur1_ For
        Select t.*
          From Customer_Order_Reservation_Tab t
         Where t.Qty_Assigned > 0
           And t.Qty_Picked = 0
           AND T.PICK_LIST_NO ='*'
         --  And t.Order_No = Row0_.Order_No
           And Not Exists
         (Select 1
                  From Bl_Pltrans T1
                 Where T1.Order_No = t.Order_No
                   And T1.Rel_No = t.Rel_No
                   And T1.Line_No = t.Line_No
                   And T1.Line_Item_No = t.Line_Item_No
                   And T1.Contract = t.Contract
                   And T1.Location_No = t.Location_No
                   And T1.Lot_Batch_No = t.Lot_Batch_No
                   And T1.Serial_No = t.Serial_No
                   And T1.Eng_Chg_Leve = t.Eng_Chg_Level
                   And T1.Waiv_Dev_Rej_No = t.Waiv_Dev_Rej_No
                   And T1.Configuration_Id = t.Configuration_Id
                   And Nvl(T1.Flag, '0') = '0'
                   And T1.Transid Is Null);
      Fetch Cur1_
        Into Row1_;
      While Cur1_%Found Loop
        --调用IFS的预留函数清0
        Row1_.Qty_Assigned := (-1) * Row1_.Qty_Assigned;
        Reserve_Customer_Order_Api.Reserve_Manually__(Info_,
                                                      State_,
                                                      Row1_.Order_No,
                                                      Row1_.Line_No,
                                                      Row1_.Rel_No,
                                                      Row1_.Line_Item_No,
                                                      Row1_.Contract,
                                                      Row1_.Part_No,
                                                      Row1_.Location_No,
                                                      Row1_.Lot_Batch_No,
                                                      Row1_.Serial_No,
                                                      Row1_.Eng_Chg_Level,
                                                      Row1_.Waiv_Dev_Rej_No,
                                                      Pallet_Id_,
                                                      Row1_.Qty_Assigned);
                      
        Fetch Cur1_
          Into Row1_;
      End Loop;
      Close Cur1_;
      --end----
    Select t.* Into Row_ From Bl_v_Co_Deliver t Where t.Objid = Rowid_;
    Open Cur_ For
      Select t.*
        From Bl_v_Co_Deliver_Detail t
       Where t.Picklistno = Row_.Picklistno
         And t.Flag Not In (2, 3)
         And t.Supplier = t.Contract --供应域跟订单的域是一样的（存在未上线的工厂域）
         And Bl_Pick_Order_Line_Api.Get_Suplier_User(Bpsupplier, User_Id_) = '1';
    /*         And Supplier In (Select t.Contract
     From Bl_Usecon t, A007 T1
    Where T1.Bl_Userid = t.Userid
      And T1.A007_Id = User_Id_); --用户的供应域*/
    Fetch Cur_
      Into Row0_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '此用户没有可提货的明细');
      Return;
    End If;
    While Cur_%Found Loop
      If Row0_.Finishqty <> Row0_.Qty_Assigned Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                '错误分配数量跟发货数量不相等不能发货');
        Return;
      End If;
      v_        := 1;
      If_Exist_ := '0';
      Loop
        Exit When v_ > i_;
        If Order_No_Dis_(v_) = Row0_.Order_No Then
          If_Exist_ := '1';
          Exit;
        End If;
        v_ := v_ + 1;
      End Loop;
      If If_Exist_ = '0' Then
        i_ := i_ + 1;
        Order_No_Dis_(i_) := Row0_.Order_No;
        Billlading__(Row0_.Order_No, User_Id_, A311_Key_);
      End If;
      Fetch Cur_
        Into Row0_;
    End Loop;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CO_DELIVER', Rowid_);
    Return;
  End;
  Procedure Deliver_Order(Rowid_    Varchar2, -- 视图BL_V_CO_DELIVER_DETAIL的objid
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
    Row_        Bl_v_Co_Deliver_Co%Rowtype;
    Row0_       Bl_v_Co_Deliver_Detail_Co%Rowtype;
    Close_Line_ Number;
    Cur_        t_Cursor;
  Begin
    Select t.* Into Row_ From Bl_v_Co_Deliver_Co t Where t.Objid = Rowid_;
    Open Cur_ For
      Select t.*
        From Bl_v_Co_Deliver_Detail_Co t
       Where t.Order_No = Row_.Order_No
         And t.Qty_Assigned > 0;
    Fetch Cur_
      Into Row0_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    While Cur_%Found Loop
      If Row0_.Qty_Assigned = Row0_.Qty_Reserved Then
        Close_Line_ := 1;
      Else
        Close_Line_ := 0;
      End If;
      Deliver_Line_With_Diff__(Row0_.Order_No,
                               Row0_.Order_No,
                               Row0_.Line_No,
                               Row0_.Rel_No,
                               Row0_.Line_Item_No,
                               Close_Line_,
                               User_Id_,
                               A311_Key_);
      Fetch Cur_
        Into Row0_;
    End Loop;
    Close Cur_;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CO_DELIVER_CO', Rowid_);
    Return;
  End;
  Procedure Deliver_Pick(Rowid_    Varchar2, -- 视图BL_V_CO_DELIVER_DETAIL的objid
                         User_Id_  Varchar2,
                         A311_Key_ Varchar2) Is
    Row0_       Bl_v_Co_Deliver_Detail%Rowtype;
    Cur_        t_Cursor;
    Cur1_       t_Cursor;
    Cur2_       t_Cursor;
    Cur3_       t_Cursor;
    Row1_       Bl_Delivery_Plan%Rowtype;
    Row_        Bl_v_Co_Deliver%Rowtype;
    Row2_       Bl_Bill_Vary_Detail%Rowtype;
    Row3_       Bl_Bill_Vary%Rowtype;
    Row4_       Bl_Bill_Vary_Detail%Rowtype;
    Close_Line_ Number;
    Msg_        Varchar2(4000);
    Ll_Count_   Number;
  Begin
    Select t.* Into Row_ From Bl_v_Co_Deliver t Where t.Objid = Rowid_;
    Open Cur_ For
      Select t.*
        From Bl_v_Co_Deliver_Detail t
       Where t.Picklistno = Row_.Picklistno
         And t.Flag Not In (2, 3)
         And t.Supplier = t.Contract
         And Bl_Pick_Order_Line_Api.Get_Suplier_User(Bpsupplier, User_Id_) = '1'; --用户供应域
    /*         And Supplier In (Select t.Contract
     From Bl_Usecon t, A007 T1
    Where T1.Bl_Userid = t.Userid
      And T1.A007_Id = User_Id_); --用户的供应域*/
    Fetch Cur_
      Into Row0_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '此用户没有可发货的明细');
      Return;
    End If;
    While Cur_%Found Loop
      If Row0_.Finishqty <> Row0_.Qty_Assigned Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                '错误分配数量跟发货数量不相等不能发货');
        Return;
      End If;
        -- 检测包装是否提交modify fjp 2013-01-31  是否需要包装检查备货单的域
        select  count(*)
         into Ll_Count_
         from BL_CIQ_CONTRACT_TAB t 
        where t.CONTRACT= row_.CONTRACT --Row0_.SUPPLIER
         and  t.ifpag='1';
         if Ll_Count_ > 0 then 
           -- 是否包装好，检测工厂域
           --如果有差异发货，比较包装数量
            select  count(*)
            into  Ll_Count_
            from  BL_PLDTLDIFF t
            WHERE T.PICKLISTNO = ROW0_.picklistno
             AND  T.FLAG='2';
            IF Ll_Count_ > 0 THEN 
              SELECT COUNT(*)
              INTO Ll_Count_ 
              FROM BL_PLDTLDIFF T1
              WHERE T1.PICKLISTNO = ROW0_.picklistno
              AND   T1.ORDER_NO =ROW0_.co_order_no
              AND   T1.LINE_NO =ROW0_.co_line_no
              AND   T1.REL_NO  =ROW0_.co_rel_no
              AND   T1.LINE_ITEM_NO=ROW0_.co_line_item_no;
              IF Ll_Count_ =0 THEN 
                SELECT (NVL(SUM(QTY),0)- ROW0_.finishqty)
                 INTO Ll_Count_
                 FROM BL_PUTINCASE_BOX_DETAIL T
                 WHERE T.PICKLISTNO=ROW0_.picklistno
                 AND   T.CO_ORDER_NO =ROW0_.co_order_no
                 AND   T.CO_LINE_NO = ROW0_.co_line_no
                 AND   T.CO_REL_NO  =ROW0_.co_rel_no
                 AND   T.CO_LINE_ITEM_NO=ROW0_.co_line_item_no; 
                 IF Ll_Count_ <> 0 THEN 
                    Close Cur_;
                    Raise_Application_Error(-20101,'包装资料数量不够或未做包装!');
                 END IF ;
               END IF ;
            ELSE
                  select count(*)  
                  into   Ll_Count_
                  from  bl_picklist_pack 
                 where  SUPPLIER   = row0_.SUPPLIER
                  and   PICKLISTNO = row0_.picklistno
                  and  state='4';
                if Ll_Count_ = 0 then
                   Close Cur_;
                   Raise_Application_Error(-20101,'包装资料没有提交或者不存在!');
                end if ;
            END IF;
         end if ;
      --end
      --发货时候检测是否有变更 fjp 2012-11-15-----
      ----modify fjp 2012-12-05（一个订单行只能存在一张交货计划变更）-------------------
      Open Cur2_ For
        Select t.*
          From Bl_Bill_Vary_Detail t
         Where t.Order_No = Row0_.Co_Order_No
           And t.Line_No = Row0_.Co_Line_No
           And t.Rel_No = Row0_.Co_Rel_No
           And t.Line_Item_No = Row0_.Co_Line_Item_No
           And Substr(t.Modify_Id, 1, 1) = '2'
              /*          And Not Exists (Select 1
               From Bl_Bill_Vary T1
              Where T1.Modify_Id = t.Modify_Id
                And T1.Smodify_Id Like 'F%')*/
           And t.State In ('0', '1');
      Fetch Cur2_
        Into Row2_;
      If Cur2_%Found Then
        Select t.*
          Into Row3_
          From Bl_Bill_Vary t
         Where t.Modify_Id = Row2_.Modify_Id;
        -- 订单，采购订单的备货单变更
        If Substr(Row3_.Smodify_Id, 1, 1) = '0' Or
           Substr(Row3_.Smodify_Id, 1, 1) = '1' Or
           Substr(Row3_.Smodify_Id, 1, 1) = '6' Then
          Open Cur3_ For
            Select t.*
              From Bl_Bill_Vary_Detail t
             Where t.Modify_Id = Row3_.Smodify_Id
               And t.Order_No = Row2_.Order_No
               And t.Line_No = Row2_.Line_No
               And t.Rel_No = Row2_.Rel_No
               And t.Line_Item_No = Row2_.Line_Item_No;
          Fetch Cur3_
            Into Row4_;
          If Cur3_%Found Then
            If Row4_.Qty_Delived > Row4_.Qty_Delivedf And
               (Substr(Row3_.Smodify_Id, 1, 1) = '0' Or
               Substr(Row3_.Smodify_Id, 1, 1) = '1') Then
              Close Cur3_;
              Close Cur2_;
              Close Cur_;
              Raise_Application_Error(-20101,
                                      Row0_.Order_No || '在' ||
                                      Row4_.Modify_Id || '有数量变少的变更，不能发货');
              Return;
            End If;
            If Substr(Row3_.Smodify_Id, 1, 1) = '6' And
               Row4_.Picklistno = Row0_.Picklistno Then
              Close Cur3_;
              Close Cur2_;
              Close Cur_;
              Raise_Application_Error(-20101,
                                      Row0_.Order_No || '在' ||
                                      Row4_.Modify_Id || '有变更的备货单，不能发货');
              Return;
            End If;
          End If;
          Close Cur3_;
        End If;
      End If;
      Close Cur2_;
      ---end--------   
      If Row0_.Qty_Assigned = Row0_.Qty_Reserved Then
        Close_Line_ := 1;
      Else
        Close_Line_ := 0;
      End If;
      Deliver_Line_With_Diff__(Row0_.Picklistno,
                               Row0_.Order_No,
                               Row0_.Line_No,
                               Row0_.Rel_No,
                               Row0_.Line_Item_No,
                               Close_Line_,
                               User_Id_,
                               A311_Key_);
    
      Fetch Cur_
        Into Row0_;
    End Loop;
    Close Cur_;
  
    --更新交货计划的状态为关闭5
    Open Cur1_ For
      Select t.*
        From Bl_Delivery_Plan t
       Where t.Picklistno = Row_.Picklistno
         And t.State = '2'
         And Pkg_Attr.Checkcontract(User_Id_, t.Supplier) = '1';
    --modify fjp 2012-12-12
    /*         and t.SUPPLIER in (Select t.Contract
     From Bl_Usecon t, A007 T1
    Where T1.Bl_Userid = t.Userid
      And T1.A007_Id = User_Id_)*/
    Fetch Cur1_
      Into Row1_;
    While Cur1_%Found Loop
      Update Bl_Delivery_Plan
         Set State = '5'
       Where Delplan_No = Row1_.Delplan_No;
      Update Bl_Delivery_Plan_Detial
         Set State = '5'
       Where Delplan_No = Row1_.Delplan_No
         And State = '2';
      --记录交货计划的日志
      Msg_ := '由备货单' || Row_.Picklistno || '发货' || '关闭交货计划';
      Bl_Co_Deliver_Api.Delivery_Plan_Hist(Row1_.Delplan_No,
                                           User_Id_,
                                           A311_Key_,
                                           Msg_);
    
      Fetch Cur1_
        Into Row1_;
    End Loop;
    Close Cur1_;
    --当备货单发货完成的时候调用备货单确定的功能 modify fjp 2012-12-07
    Select Count(*)
      Into Ll_Count_
      From Bl_Pldtl
     Where Picklistno = Row_.Picklistno
       And Flag Not In ('2', '3');
    If Ll_Count_ = 0 Then
      Bl_Pick_Order_Api.Finish_Stock(Rowid_, User_Id_, A311_Key_);
    End If;
    --end
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CO_DELIVER', Rowid_);
    Return;
  End;
  --modify fjp 2013-01-29 订单的自动预留
  Procedure Obligate_Order(Rowid_    Varchar2, -- 视图BL_V_CO_DELIVER_CO的objid
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2) Is
    Cur_              t_Cursor;
    Cur1_             t_Cursor;
    Row_              Bl_v_Co_Deliver_Co%Rowtype;
    Rowdetail_        Bl_v_Co_Deliver_Detail_Co%Rowtype;
    Row1_             Bl_Pltrans%Rowtype;
    Rowstock_         Inventory_Part_In_Stock_Res%Rowtype;
    Qty_Assigned_     Number;
    Qty_Assigned_Ky_  Number;
    Qty_Assigned_All_ Number;
    Ll_Count_         Number;
    Info_             Varchar2(1000);
    State_            Varchar2(20);
    Pallet_Id_        Varchar2(100);
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Co_Deliver_Co t Where t.Objid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
    End If;
    Close Cur_;
    --获取明细数据
    Open Cur_ For
      Select t.*
        From Bl_v_Co_Deliver_Detail_Co t
       Where t.Order_No = Row_.Order_No;
    Fetch Cur_
      Into Rowdetail_;
    While Cur_%Found Loop
      If Rowdetail_.Qty_Assigned > 0 Then
        Close Cur_;
        Raise_Application_Error(-20101, '已经存在预留数量，不能自动预留');
      End If;
      --需要预留的数量
      Qty_Assigned_All_ := Rowdetail_.Qty_Reserved;
      --判断是否有别的订单已经做过预留
      Select Count(*)
        Into Ll_Count_
        From Bl_Pltrans
       Where Picklistno <> Row_.Order_No
         And Order_No = Row_.Order_No
         And Line_No = Rowdetail_.Line_No
         And Rel_No = Rowdetail_.Rel_No
         And Line_Item_No = Rowdetail_.Line_Item_No
         And Flag = '0';
      If Ll_Count_ > 0 Then
        Raise_Application_Error(-20101,
                                '此订单行的备货单预留已经做过，等前一个备货单完成发货才能预留');
        Return;
      End If;
      Open Cur1_ For
        Select t.*
          From Inventory_Part_In_Stock_Res t
         Where t.Part_No = Rowdetail_.Catalog_No
           And t.Contract = Rowdetail_.Contract
           And t.Location_No = Row_.Bllocation_No
           And t.Qty_Onhand > t.Qty_Reserved;
      Fetch Cur1_
        Into Rowstock_;
      While Cur1_%Found Loop
        Qty_Assigned_Ky_ := Rowstock_.Qty_Onhand - Rowstock_.Qty_Reserved;
        If Qty_Assigned_Ky_ > Qty_Assigned_All_ Then
          Qty_Assigned_     := Qty_Assigned_All_;
          Qty_Assigned_All_ := 0;
        Else
          Qty_Assigned_     := Qty_Assigned_Ky_;
          Qty_Assigned_All_ := Qty_Assigned_All_ - Qty_Assigned_Ky_;
        End If;
        --调用IFS的预留函数
        Reserve_Customer_Order_Api.Reserve_Manually__(Info_,
                                                      State_,
                                                      Row_.Order_No,
                                                      Rowdetail_.Line_No,
                                                      Rowdetail_.Rel_No,
                                                      Rowdetail_.Line_Item_No,
                                                      Rowdetail_.Contract,
                                                      Rowdetail_.Catalog_No,
                                                      Rowstock_.Location_No,
                                                      Rowstock_.Lot_Batch_No,
                                                      Rowstock_.Serial_No,
                                                      Rowstock_.Eng_Chg_Level,
                                                      Rowstock_.Waiv_Dev_Rej_No,
                                                      Pallet_Id_,
                                                      Qty_Assigned_);
        --获取备货单(订单)预留表
        Row1_.Picklistno       := Row_.Order_No;
        Row1_.Order_No         := Row_.Order_No;
        Row1_.Line_No          := Rowdetail_.Line_No;
        Row1_.Rel_No           := Rowdetail_.Rel_No;
        Row1_.Line_Item_No     := Rowdetail_.Line_Item_No;
        Row1_.Qty_Assigned     := Qty_Assigned_;
        Row1_.Contract         := Rowdetail_.Contract;
        Row1_.Location_No      := Rowstock_.Location_No;
        Row1_.Lot_Batch_No     := Rowstock_.Lot_Batch_No;
        Row1_.Serial_No        := Rowstock_.Serial_No;
        Row1_.Eng_Chg_Leve     := Rowstock_.Eng_Chg_Level;
        Row1_.Waiv_Dev_Rej_No  := Rowstock_.Waiv_Dev_Rej_No;
        Row1_.Configuration_Id := Rowstock_.Configuration_Id;
        Row1_.Catalog_No       := Rowdetail_.Catalog_No;
        Row1_.Flag             := '0';
        --插入备货单(订单)预留表
        Insert_Bl_Pltrans(Row1_, User_Id_, A311_Key_);
        If Qty_Assigned_All_ = 0 Then
          Exit;
        End If;
        Fetch Cur1_
          Into Rowstock_;
      End Loop;
      Close Cur1_;
      If Qty_Assigned_All_ > 0 Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                '此库位' || Row_.Bllocation_No || '库位预留数量不足');
      End If;
      Fetch Cur_
        Into Rowdetail_;
    End Loop;
    Close Cur_;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CO_DELIVER_CO', Rowid_);
    Return;
  End;
  --modify fjp 2013-01-29 备货单的自动预留 
  Procedure Obligate_Pick(Rowid_    Varchar2, -- 视图BL_V_CO_DELIVER的objid
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
    Cur_              t_Cursor;
    Cur1_             t_Cursor;
    Cur2_             t_Cursor;
    Row_              Bl_v_Co_Deliver%Rowtype;
    Rowdetail_        Bl_v_Co_Deliver_Detail%Rowtype;
    Row1_             Bl_Pltrans%Rowtype;
    Rowstock_         Inventory_Part_In_Stock_Res%Rowtype;
    rowbcc_           BL_CIQ_CONTRACT_TAB%rowtype;
    Qty_Assigned_     Number;
    Qty_Assigned_Ky_  Number;
    Qty_Assigned_All_ Number;
    Ll_Count_         Number;
    Info_             Varchar2(1000);
    State_            Varchar2(20);
    Pallet_Id_        Varchar2(100);
    Location_         varchar2(20);--库位或者库位组
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Co_Deliver t Where t.Objid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
    End If;
    Close Cur_;
    --获取明细数据
    Open Cur_ For
      Select t.*
        From Bl_v_Co_Deliver_Detail t
       Where t.Picklistno = Row_.Picklistno
         And Bl_Pick_Order_Line_Api.Get_Suplier_User(Bpsupplier, User_Id_) = '1';
    Fetch Cur_
      Into Rowdetail_;
    While Cur_%Found Loop
      If Rowdetail_.Qty_Assigned > 0 Then
        Close Cur_;
        Raise_Application_Error(-20101, '已经存在预留数量，不能自动预留');
      End If;
      --需要预留的数量
      Qty_Assigned_All_ := Rowdetail_.Finishqty;
      --判断是否有别的订单已经做过预留
      Select Count(*)
        Into Ll_Count_
        From Bl_Pltrans
       Where Picklistno <> Row_.Picklistno
         And Order_No = Rowdetail_.Order_No
         And Line_No = Rowdetail_.Line_No
         And Rel_No = Rowdetail_.Rel_No
         And Line_Item_No = Rowdetail_.Line_Item_No
         And Flag = '0';
      If Ll_Count_ > 0 Then
        Raise_Application_Error(-20101,
                                '此订单行的备货单预留已经做过，等前一个备货单完成发货才能预留');
        Return;
      End If;
      --补货备货单的库位是对应的域的默认库位modify 2013-02-01 
      if row_.BFLAG ='1' then 
          Location_ :='';
          open Cur2_ for 
          select t.*
          from BL_CIQ_CONTRACT_TAB t 
          where t.CONTRACT = Rowdetail_.SUPPLIER;
          fetch cur2_ into rowbcc_;
          if cur_%found  then 
              Location_ := rowbcc_.OUTLACTION;
          end if;
          close cur2_;
      else
         Location_ :=row_.LOCATION;
      end if;
      Open Cur1_ For
        Select t.*
          From Inventory_Part_In_Stock_Res t
         Where t.Part_No = Rowdetail_.Catalog_No
           And t.Contract = Rowdetail_.Contract
           And (t.Location_No = Row_.Location
              or INVENTORY_LOCATION_API.Get_Location_Group(t.Contract,t.Location_No)=Row_.Location)
           And t.Qty_Onhand > t.Qty_Reserved
           order by receipt_date  asc;
      Fetch Cur1_
        Into Rowstock_;
      While Cur1_%Found Loop
        Qty_Assigned_Ky_ := Rowstock_.Qty_Onhand - Rowstock_.Qty_Reserved;
        If Qty_Assigned_Ky_ > Qty_Assigned_All_ Then
          Qty_Assigned_     := Qty_Assigned_All_;
          Qty_Assigned_All_ := 0;
        Else
          Qty_Assigned_     := Qty_Assigned_Ky_;
          Qty_Assigned_All_ := Qty_Assigned_All_ - Qty_Assigned_Ky_;
        End If;
        --调用IFS的预留函数
        Reserve_Customer_Order_Api.Reserve_Manually__(Info_,
                                                      State_,
                                                      Rowdetail_.Order_No,
                                                      Rowdetail_.Line_No,
                                                      Rowdetail_.Rel_No,
                                                      Rowdetail_.Line_Item_No,
                                                      Rowdetail_.Contract,
                                                      Rowdetail_.Catalog_No,
                                                      Rowstock_.Location_No,
                                                      Rowstock_.Lot_Batch_No,
                                                      Rowstock_.Serial_No,
                                                      Rowstock_.Eng_Chg_Level,
                                                      Rowstock_.Waiv_Dev_Rej_No,
                                                      Pallet_Id_,
                                                      Qty_Assigned_);
        --获取备货单(订单)预留表
        Row1_.Picklistno       := Row_.Picklistno;
        Row1_.Order_No         := Rowdetail_.Order_No;
        Row1_.Line_No          := Rowdetail_.Line_No;
        Row1_.Rel_No           := Rowdetail_.Rel_No;
        Row1_.Line_Item_No     := Rowdetail_.Line_Item_No;
        Row1_.Qty_Assigned     := Qty_Assigned_;
        Row1_.Contract         := Rowdetail_.Contract;
        Row1_.Location_No      := Rowstock_.Location_No;
        Row1_.Lot_Batch_No     := Rowstock_.Lot_Batch_No;
        Row1_.Serial_No        := Rowstock_.Serial_No;
        Row1_.Eng_Chg_Leve     := Rowstock_.Eng_Chg_Level;
        Row1_.Waiv_Dev_Rej_No  := Rowstock_.Waiv_Dev_Rej_No;
        Row1_.Configuration_Id := Rowstock_.Configuration_Id;
        Row1_.Catalog_No       := Rowdetail_.Catalog_No;
        Row1_.Flag             := '0';
        --插入备货单(订单)预留表
        Insert_Bl_Pltrans(Row1_, User_Id_, A311_Key_);
        If Qty_Assigned_All_ = 0 Then
          Exit;
        End If;
        Fetch Cur1_
          Into Rowstock_;
      End Loop;
      Close Cur1_;
      If Qty_Assigned_All_ > 0 Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                '此库位' || Row_.Location || '库位预留数量不足');
      End If;
      Fetch Cur_
        Into Rowdetail_;
    End Loop;
    Close Cur_;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CO_DELIVER_CO', Rowid_);
    Return;
  End;
  Procedure Deliver1__(Rowid_    Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
    Row0_       Bl_v_Co_Deliver_Detail%Rowtype;
    Cur_        t_Cursor;
    Row_        Bl_v_Co_Deliver%Rowtype;
    Attr_       Varchar2(1000);
    Close_Line_ Number;
    Ll_Count_   Number;
  Begin
    Select t.* Into Row_ From Bl_v_Co_Deliver t Where t.Objid = Rowid_;
    Open Cur_ For
      Select t.*
        From Bl_v_Co_Deliver_Detail t
       Where t.Picklistno = Row_.Picklistno
         And t.Flag Not In (2, 3)
         And t.Supplier = t.Contract
         And Bl_Pick_Order_Line_Api.Get_Suplier_User(Bpsupplier, User_Id_) = '1'; --用户供应域
    /*         And Supplier In (Select t.Contract
     From Bl_Usecon t, A007 T1
    Where T1.Bl_Userid = t.Userid
      And T1.A007_Id = User_Id_); --用户的供应域*/
    Fetch Cur_
      Into Row0_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '此用户没有可发货的明细');
      Return;
    End If;
    -- close cur_;
    While Cur_%Found Loop
      If Row0_.Finishqty <> Row0_.Qty_Assigned Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                '错误分配数量跟发货数量不相等不能发货');
        Return;
      End If;
      Select Count(*)
        Into Ll_Count_
        From Bl_v_Customer_Order
       Where Order_No = Row0_.Order_No
         And State In ('Partially Delivered',
                       'Delivered',
                       'Picked',
                       'Released',
                       'Reserved');
      If Ll_Count_ = 0 Then
        Raise_Application_Error(-20101,
                                '订单' || Row0_.Order_No || '不是可发货状态');
        Return;
      End If;
      --拼提货单单号的字符串
      Attr_ := '';
      Client_Sys.Add_To_Attr('START_EVENT', '70', Attr_);
      Client_Sys.Add_To_Attr('ORDER_NO', Row0_.Order_No, Attr_);
      Client_Sys.Add_To_Attr('END', '', Attr_);
      --调用ifs的提货单交货 
      Customer_Order_Flow_Api.Start_Create_Pick_List__(Attr_);
      If Row0_.Qty_Assigned = Row0_.Qty_Reserved Then
        Close_Line_ := 1;
      Else
        Close_Line_ := 0;
      End If;
      Pkg_a.Setnextdo(A311_Key_,
                      'BL_CO_DELIVER_API.Deliver_Line_With_Diff__',
                      User_Id_,
                      'BL_CO_DELIVER_API.Deliver_Line_With_Diff__(''' ||
                      Row0_.Picklistno || ''',''' || Row0_.Order_No ||
                      ''',''' || Row0_.Line_No || ''',''' || Row0_.Rel_No ||
                      ''',''' || Row0_.Line_Item_No || ''',''' ||
                      Close_Line_ || ''',''' || User_Id_ || ''',''' ||
                      A311_Key_ || ''')',
                      2 / 60 / 24);
      Fetch Cur_
        Into Row0_;
    End Loop;
    Close Cur_;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CO_DELIVER_DETAIL', Rowid_);
  End;
  Procedure Billladcancel_Pick(Rowid_    Varchar2,
                               User_Id_  Varchar2,
                               A311_Key_ Varchar2) Is
    Row0_       Bl_v_Co_Deliver_Detail%Rowtype;
    Cur_        t_Cursor;
    Row_        Bl_v_Co_Deliver%Rowtype;
    Close_Line_ Number;
    Info_       Varchar2(4000);
  Begin
    Select t.* Into Row_ From Bl_v_Co_Deliver t Where t.Objid = Rowid_;
    Open Cur_ For
      Select t.*
        From Bl_v_Co_Deliver_Detail t
       Where t.Picklistno = Row_.Picklistno
         And t.Flag Not In (2, 3)
         And t.Supplier = t.Contract
         And Bl_Pick_Order_Line_Api.Get_Suplier_User(Bpsupplier, User_Id_) = '1'; --用户供应域
    /*         And Supplier In (Select t.Contract
     From Bl_Usecon t, A007 T1
    Where T1.Bl_Userid = t.Userid
      And T1.A007_Id = User_Id_); --用户的供应域*/
    Fetch Cur_
      Into Row0_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '此用户没有可发货的明细');
      Return;
    End If;
    While Cur_%Found Loop
      Close_Line_ := 0;
      Info_       := '';
      Deliver_Line_With_Diff_Qty__(Info_,
                                   Row0_.Order_No,
                                   Row0_.Line_No,
                                   Row0_.Rel_No,
                                   Row0_.Line_Item_No,
                                   Close_Line_,
                                   User_Id_,
                                   A311_Key_);
      If Info_ = '-1' Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                '此' || Row0_.Order_No || '没有做提货，不能取消提货');
        Return;
      End If;
      --更新保隆的记录表 modify FJP 2012-12-06
/*      Update Bl_Pltrans
         Set Flag = '1'
       Where Picklistno = Row_.Picklistno
         And Order_No = Row0_.Order_No
         And Line_No = Row0_.Line_No
         And Rel_No = Row0_.Rel_No
         And Line_Item_No = Row0_.Line_Item_No;*/
        delete  from Bl_Pltrans  
         Where Picklistno = Row_.Picklistno
         And Order_No = Row0_.Order_No
         And Line_No = Row0_.Line_No
         And Rel_No = Row0_.Rel_No
         And Line_Item_No = Row0_.Line_Item_No
         and Flag='0';
      --END---
      Fetch Cur_
        Into Row0_;
    End Loop;
    Close Cur_;
    /*    --更新保隆的表
    Update Bl_Pltrans
       Set Flag = '1'
     Where Picklistno = Row_.Picklistno
     and BL_Pick_Order_line_api.Get_Suplier_User(SUPPLIER,User_Id_)='1';--用户供应域*/
    /*       And Contract In (Select t.Contract
     From Bl_Usecon t, A007 T1
    Where T1.Bl_Userid = t.Userid
      And T1.A007_Id = User_Id_);*/
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CO_DELIVER', Rowid_);
    Return;
  End;
  Procedure Billladcancel_Order(Rowid_    Varchar2,
                                User_Id_  Varchar2,
                                A311_Key_ Varchar2) Is
    Row0_       Bl_v_Co_Deliver_Detail_Co%Rowtype;
    Cur_        t_Cursor;
    Row_        Bl_v_Co_Deliver_Co%Rowtype;
    Close_Line_ Number;
    Info_       Varchar2(4000);
  Begin
    Select t.* Into Row_ From Bl_v_Co_Deliver_Co t Where t.Objid = Rowid_;
    Open Cur_ For
      Select t.*
        From Bl_v_Co_Deliver_Detail_Co t
       Where t.Order_No = Row_.Order_No
         And t.Qty_Assigned > 0;
    Fetch Cur_
      Into Row0_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '此用户没有可发货的明细');
      Return;
    End If;
    While Cur_%Found Loop
      Close_Line_ := 0;
      Info_       := '';
      Deliver_Line_With_Diff_Qty__(Info_,
                                   Row0_.Order_No,
                                   Row0_.Line_No,
                                   Row0_.Rel_No,
                                   Row0_.Line_Item_No,
                                   Close_Line_,
                                   User_Id_,
                                   A311_Key_);
      If Info_ = '-1' Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                '此' || Row0_.Order_No || '没有做提货，不能取消提货');
        Return;
      End If;
       delete from Bl_Pltrans
       Where Picklistno = Row_.Order_No
         And Order_No = Row0_.Order_No
         And Line_No = Row0_.Line_No
         And Rel_No = Row0_.Rel_No
         And Line_Item_No = Row0_.Line_Item_No
         And Flag = '0';
      Fetch Cur_
        Into Row0_;
    End Loop;
    Close Cur_;
    --更新保隆的表
/*    Update Bl_Pltrans
       Set Flag = '1'
     Where Picklistno = Row_.Order_No
       And Flag = '0';*/
/*       delete from Bl_Pltrans
       Where Picklistno = Row_.Order_No
       And Flag = '0';*/
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CO_DELIVER', Rowid_);
    Return;
  End;
  Procedure Delivery_Plan_Hist(Delplan_No_ Varchar2, --交货计划主档rowid
                               User_Id_    Varchar2,
                               A311_Key_   Varchar2,
                               Msg_        In Varchar2) Is
    Cur_   t_Cursor;
    Objid_ Varchar2(100);
  Begin
    Open Cur_ For
      Select Rowidtochar(t.Rowid)
        From Bl_Delivery_Plan_Detial t
       Where t.Delplan_No = Delplan_No_
         And t.State = '2';
    Fetch Cur_
      Into Objid_;
    While Cur_%Found Loop
      Bldelivery_Plan_Line_Api.Savehist__(Objid_,
                                          User_Id_,
                                          A311_Key_,
                                          Msg_);
      Fetch Cur_
        Into Objid_;
    End Loop;
    Return;
  End;
  Procedure Insert_Bl_Pltrans(Row_      Bl_Pltrans%Rowtype,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2) Is
    -- pltrans_rowid_ varchar2(200);
    Row1_  Bl_v_Bl_Pltrans%Rowtype;
    Cur_   t_Cursor;
    Objid_ Varchar2(200);
    Row2_  Bl_Pltrans%Rowtype;
  Begin
    Row2_ := Row_;
    --  IF row_.flag = '0'  or row_.flag='1' THEN
    Open Cur_ For
      Select t.*
        From Bl_v_Bl_Pltrans t
       Where t.Picklistno = Row_.Picklistno
         And t.Order_No = Row_.Order_No
         And t.Rel_No = Row_.Rel_No
         And t.Line_No = Row_.Line_No
         And t.Line_Item_No = Row_.Line_Item_No
         And t.Contract = Row_.Contract
         And t.Location_No = Row_.Location_No
         And t.Lot_Batch_No = Row_.Lot_Batch_No
         And t.Serial_No = Row_.Serial_No
         And t.Eng_Chg_Leve = Row_.Eng_Chg_Leve
         And t.Waiv_Dev_Rej_No = Row_.Waiv_Dev_Rej_No
         And t.Configuration_Id = Row_.Configuration_Id
         And t.Flag = '0';
    Fetch Cur_
      Into Row1_;
    If Cur_%Found Then
      If Row_.Flag = '0' Then
        Row2_.Qty_Assigned := Row1_.Qty_Assigned + Row_.Qty_Assigned;
        Objid_             := Row1_.Objid;
      End If;
      If Row_.Flag = '1' Then
        Objid_ := Row1_.Objid;
      End If;
    Else
      If Row_.Flag = '1' Then
        Raise_Application_Error(-20101, '发货不能更新bl_pltrans表');
        Return;
      Else
        If Row2_.Qty_Assigned = 0 Then
          Close Cur_;
          Return;
        Else
          Insert Into Bl_Pltrans
            (Picklistno)
          Values
            (Row_.Picklistno)
          Returning Rowid Into Objid_;
        End If;
      End If;
    End If;
    Close Cur_;
    -- END IF;
    /*    IF row_.flag = '1' THEN
      INSERT INTO bl_pltrans
        (PICKLISTNO)
      VALUES
        (row_.picklistno)
      RETURNING ROWID INTO objid_;
      UPDATE bl_pltrans
         SET flag = '1'
       WHERE TRANSID IS NULL
         AND order_no = row_.order_no
         AND REL_NO = row_.rel_no
         AND line_no = row_.line_no
         AND line_item_no = row_.line_item_no;
    END IF;*/
    Update Bl_Pltrans Set Row = Row2_ Where Rowid = Objid_;
    Return;
  End;
  Procedure Deliver_Line_With_Diff__(Picklistno_   Varchar2,
                                     Order_No_     Varchar2,
                                     Line_No_      Varchar2,
                                     Rel_No_       Varchar2,
                                     Line_Item_No_ Number,
                                     Close_Line_   Number,
                                     User_Id_      Varchar2,
                                     A311_Key_     Varchar2) Is
    Row_              Deliver_Customer_Order%Rowtype;
    Row1_             Bl_Pltrans%Rowtype;
    Attr_             Varchar2(1000);
    Info_             Varchar2(1000);
    Cur_              t_Cursor;
    Datalist_         Dbms_Sql.Varchar2_Table;
    Link_Key_         Varchar2(1000);
    Pkg_Line_Item_No_ Number;
    ll_count_ number;
  Begin
    Open Cur_ For
      Select t.*
        From Deliver_Customer_Order t
       Where t.Order_No = Order_No_
         And t.Line_No = Line_No_
         And t.Rel_No = Rel_No_
         And t.Line_Item_No = Line_Item_No_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    --  close cur_;
    Attr_ := '';
    -- 调用IFS的发货函数
    Deliver_Customer_Order_Api.Deliver_Line_Inv_With_Diff__(Info_,
                                                            Order_No_,
                                                            Line_No_,
                                                            Rel_No_,
                                                            Line_Item_No_,
                                                            Close_Line_,
                                                            Attr_);
    --循环库位表取得库位号                                                      
    While Cur_%Found Loop
      Row1_.Picklistno := Picklistno_;
      Select Max(Transaction_Id)
        Into Row1_.Transid
        From Inventory_Transaction_Hist2
       Where Order_No = Order_No_
         And Release_No = Line_No_
         And Sequence_No = Rel_No_
         And Line_Item_No = Line_Item_No_
         And Location_No = Row_.Location_No
         And Lot_Batch_No = Row_.Lot_Batch_No
         And Serial_No = Row_.Serial_No
         And Waiv_Dev_Rej_No = Row_.Waiv_Dev_Rej_No
         And Eng_Chg_Level = Row_.Eng_Chg_Level
         And Configuration_Id = Row_.Configuration_Id;
      Row1_.Order_No         := Order_No_;
      Row1_.Line_No          := Line_No_;
      Row1_.Rel_No           := Rel_No_;
      Row1_.Line_Item_No     := Line_Item_No_;
      Row1_.Qty_Assigned     := Row_.Qty_Assigned;
      Row1_.Contract         := Row_.Contract;
      Row1_.Location_No      := Row_.Location_No;
      Row1_.Lot_Batch_No     := Row_.Lot_Batch_No;
      Row1_.Serial_No        := Row_.Serial_No;
      Row1_.Eng_Chg_Leve     := Row_.Eng_Chg_Level;
      Row1_.Waiv_Dev_Rej_No  := Row_.Waiv_Dev_Rej_No;
      Row1_.Configuration_Id := Row_.Configuration_Id;
      Row1_.Catalog_No       := Row_.Part_No;
      Row1_.Flag             := '1';
      --插入备货单(订单)预留表的记录
      Insert_Bl_Pltrans(Row1_, User_Id_, A311_Key_);
      Fetch Cur_
        Into Row_;
    End Loop;
    Close Cur_;
    If Picklistno_ <> Order_No_ Then
      --如果发货完成，更新备货单中明细的状态为2
      --如果为包装件，则PKG_Line_Item_No_ 
    
      --modify by wtl 20121120  
      Pkg_Line_Item_No_ := Line_Item_No_;
      -- end modify by wtl 20121120  
       ll_count_ :=0;--MODIFY FJP 20130328 增加包装资料最后一个入库就更新明细的状态
      If Line_Item_No_ > 0 Then
        Pkg_Line_Item_No_ := -1;
        select count(*)
         into ll_count_
         from  Bl_Pltrans t
         where t.picklistno = Picklistno_
          and  t.order_no = Order_No_
          and  t.line_no  = Line_No_
          and t.rel_no   = Rel_No_
          AND  T.TRANSID IS NULL;
      End If;
      IF ll_count_ = 0 THEN 
        Link_Key_ := Bl_Customer_Order_Line_Api.Get_Par_Order_(Order_No_,
                                                               Line_No_,
                                                               Rel_No_,
                                                               Pkg_Line_Item_No_);
        --modify by wtl 20121120  
        Update Bl_Pldtl
           Set Flag = '2', Finishdate = To_Char(Sysdate, 'yyyy-mm-dd')
         Where Picklistno = Picklistno_
           And Order_No = Pkg_a.Get_Str_(Link_Key_, '-', 1)
           And Line_No = Pkg_a.Get_Str_(Link_Key_, '-', 2)
           And Rel_No = Pkg_a.Get_Str_(Link_Key_, '-', 3)
           And Line_Item_No = Pkg_a.Get_Str_(Link_Key_, '-', 4);
       END IF ;
      -- end modify by wtl 20121120  
      /*     Datalist_ := Pkg_a.Get_Str_List_By_Index(Link_Key_, '-');
      Update Bl_Pldtl
          Set Flag = '2', Finishdate = To_Char(Sysdate, 'yyyy-mm-dd')
        Where Picklistno = Picklistno_
          And Order_No = Datalist_(1) pkg_a.Get_Str_(Link_Key_,'-',1)
          And Line_No = Datalist_(2)
          And Rel_No = Datalist_(3)
          And Line_Item_No = Datalist_(4);*/
    End If;
    Return;
  End;
  Procedure Deliver_Line_With_Diff_Qty__(Info_         Out Varchar2,
                                         Order_No_     Varchar2, --订单号
                                         Line_No_      Varchar2, --订单行
                                         Rel_No_       Varchar2, --订单交货号
                                         Line_Item_No_ Number, --订单序号
                                         Close_Line_   Number, --是否全部发货标示:全部(1)部分(0)
                                         User_Id_      Varchar2,
                                         A311_Key_     Varchar2) Is
    Row1_     Customer_Order_Reservation_Tab%Rowtype;
    Ll_Count_ Number;
    Cur1_     t_Cursor;
    Attr_     Varchar2(4000);
  Begin
    -- 调用IFS的发货函数
    -- 获取总的行数
    Select Count(*)
      Into Ll_Count_
      From Customer_Order_Reservation_Tab t
     Where t.Order_No = Order_No_
       And t.Line_No = Line_No_
       And t.Rel_No = Rel_No_
       And t.Line_Item_No = Line_Item_No_
       And t.Qty_Picked > 0;
    If Ll_Count_ = 0 Then
      Info_ := '-1';
      Return;
    End If;
    --取每个行数   
    Open Cur1_ For
      Select t.*
        From Customer_Order_Reservation_Tab t
       Where t.Order_No = Order_No_
         And t.Line_No = Line_No_
         And t.Rel_No = Rel_No_
         And t.Line_Item_No = Line_Item_No_
         And t.Qty_Picked > 0;
    Fetch Cur1_
      Into Row1_;
    While Cur1_%Found Loop
      Client_Sys.Add_To_Attr('LOCATION_NO', Row1_.Location_No, Attr_);
      Client_Sys.Add_To_Attr('LOT_BATCH_NO', Row1_.Lot_Batch_No, Attr_);
      Client_Sys.Add_To_Attr('SERIAL_NO', Row1_.Serial_No, Attr_);
      Client_Sys.Add_To_Attr('ENG_CHG_LEVEL', Row1_.Eng_Chg_Level, Attr_);
      Client_Sys.Add_To_Attr('WAIV_DEV_REJ_NO',
                             Row1_.Waiv_Dev_Rej_No,
                             Attr_);
      Client_Sys.Add_To_Attr('PALLET_ID', Row1_.Pallet_Id, Attr_);
      Client_Sys.Add_To_Attr('QTY_TO_DELIVER', 0, Attr_);
      Client_Sys.Add_To_Attr('END_OF_LINE', 'END', Attr_);
      If Ll_Count_ = Cur1_%Rowcount Then
        Client_Sys.Add_To_Attr('ROW_COMPLETE', 'Y', Attr_);
      Else
        Client_Sys.Add_To_Attr('ROW_COMPLETE', 'N', Attr_);
      End If;
      Fetch Cur1_
        Into Row1_;
    End Loop;
    Close Cur1_;
    --调用IFS的出0数量的库 
    Deliver_Customer_Order_Api.Deliver_Line_Inv_With_Diff__(Info_,
                                                            Order_No_,
                                                            Line_No_,
                                                            Rel_No_,
                                                            Line_Item_No_,
                                                            Close_Line_,
                                                            Attr_);
    Return;
  End;
  --快速预留 modify fjp 2013-01-17 
  Procedure Fast_Reservation_(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2) Is
    Row_          Bl_Pltrans_V01%Rowtype;
    Cur_          t_Cursor;
    Info_         Varchar2(1000);
    State_        Varchar2(20);
    Pallet_Id_    Varchar2(100);
    Qty_Assigned_ Number;
    Row0_         Bl_Pltrans%Rowtype;
  Begin
    Row_.Objid    := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Qty_Assigned_ := Pkg_a.Get_Item_Value('QTY_ASSIGNED', Rowlist_);
    If Qty_Assigned_ Is Null Then
      Raise_Application_Error(-20101, '请录入预留的数量');
    End If;
    Open Cur_ For
      Select t.* From Bl_Pltrans_V01 t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
    End If;
    Close Cur_;
    If Qty_Assigned_ > Row_.Qty_Assigned Then
      Raise_Application_Error(-20101, '预留的数量不能大于历史预留数量');
    End If;
    Qty_Assigned_ := Qty_Assigned_ - Row_.Qty_Assigned;
    --调用IFS的预留函数
    Reserve_Customer_Order_Api.Reserve_Manually__(Info_,
                                                  State_,
                                                  Row_.Order_No,
                                                  Row_.Line_No,
                                                  Row_.Rel_No,
                                                  Row_.Line_Item_No,
                                                  Row_.Contract,
                                                  Row_.Catalog_No,
                                                  Row_.Location_No,
                                                  Row_.Lot_Batch_No,
                                                  Row_.Serial_No,
                                                  Row_.Eng_Chg_Leve,
                                                  Row_.Waiv_Dev_Rej_No,
                                                  Pallet_Id_,
                                                  Qty_Assigned_);
    --获取备货单(订单)预留表
    Row0_.Picklistno       := Row_.Picklistno;
    Row0_.Order_No         := Row_.Order_No;
    Row0_.Line_No          := Row_.Line_No;
    Row0_.Rel_No           := Row_.Rel_No;
    Row0_.Line_Item_No     := Row_.Line_Item_No;
    Row0_.Qty_Assigned     := Qty_Assigned_;
    Row0_.Contract         := Row_.Contract;
    Row0_.Location_No      := Row_.Location_No;
    Row0_.Lot_Batch_No     := Row_.Lot_Batch_No;
    Row0_.Serial_No        := Row_.Serial_No;
    Row0_.Eng_Chg_Leve     := Row_.Eng_Chg_Leve;
    Row0_.Waiv_Dev_Rej_No  := Row_.Waiv_Dev_Rej_No;
    Row0_.Configuration_Id := Row_.Configuration_Id;
    Row0_.Catalog_No       := Row_.Catalog_No;
    Row0_.Flag             := '0';
    --插入备货单(订单)预留表
    Insert_Bl_Pltrans(Row0_, User_Id_, A311_Key_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_PLTRANS_V01', Row_.Objid);
    Return;
  End;
  Function Get_Factory_Order_(Order_No_     In Varchar2,
                              Line_No_      In Varchar2,
                              Rel_No_       Varchar2,
                              Line_Item_No_ Number,
                              Type_         Varchar2) Return Varchar2 Is
    Cur_    t_Cursor;
    Row_    Bl_v_Customer_Order_V01%Rowtype;
    Result_ Varchar2(100);
    Ls_Col_ Varchar2(100);
    Ls_Sql_ Varchar2(1000);
  Begin
    Ls_Col_ := Type_;
    If Type_ = 'QTY_RESERVED' Then
      Ls_Col_ := 'BUY_QTY_DUE - nvl(QTY_SHIPPED,0)';
    End If;
    If Type_ = 'CONTRACT' Then
      Ls_Col_ := 'CO_CONTRACT';
    End If;
    Ls_Sql_ := 'SELECT ' || Ls_Col_ || ',Order_No,Line_No,Rel_No,Line_Item_No
        FROM Bl_v_Customer_Order_V01 t
       WHERE t.Demand_Order_No = ''' || Order_No_ || '''
         AND t.Demand_Line_No = ''' || Line_No_ || '''
         AND t.Demand_Rel_No = ''' || Rel_No_ || '''
         AND t.Demand_Line_Item_No = ' || Line_Item_No_;
    Open Cur_ For Ls_Sql_;
    Fetch Cur_
      Into Result_,
           Row_.Order_No,
           Row_.Line_No,
           Row_.Rel_No,
           Row_.Line_Item_No;
    If Cur_%Found Then
      Close Cur_;
      Result_ := Get_Factory_Order_(Row_.Order_No,
                                    Row_.Line_No,
                                    Row_.Rel_No,
                                    Row_.Line_Item_No,
                                    Type_);
      Return Result_;
    Else
      If Type_ = 'CONTRACT' Then
        Ls_Col_ := 'CONTRACT';
      End If;
      Ls_Sql_ := 'select ' || Ls_Col_ || '  
                  from customer_order_line_tab  
                  where order_no=''' || Order_No_ || ''' 
                    and line_no =''' || Line_No_ || '''
                    and rel_no  =''' || Rel_No_ || '''
                    and line_item_no=' || Line_Item_No_;
      Execute Immediate Ls_Sql_
        Into Result_;
    End If;
    Close Cur_;
    Return Result_;
  End;
  Function Get_Qty_Assigned_(Order_No_         In Varchar2,
                             Line_No_          In Varchar2,
                             Rel_No_           In Varchar2,
                             Line_Item_No_     Number,
                             Contract_         In Varchar2,
                             Part_No_          In Varchar2,
                             Configuration_Id_ In Varchar2,
                             Location_No_      In Varchar2,
                             Lot_Batch_No_     In Varchar2,
                             Serial_No_        In Varchar2,
                             Waiv_Dev_Rej_No_  In Varchar2,
                             Eng_Chg_Level_    In Varchar2) Return Number Is
    Row_    Customer_Order_Reservation_Tab%Rowtype;
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    Result_ := 0;
    Open Cur_ For
      Select t.*
        From Customer_Order_Reservation_Tab t
       Where t.Order_No = Order_No_
         And t.Line_No = Line_No_
         And t.Rel_No = Rel_No_
         And t.Line_Item_No = Line_Item_No_
         And t.Contract = Contract_
         And t.Part_No = Part_No_
         And t.Configuration_Id = Configuration_Id_
         And t.Location_No = Location_No_
         And t.Lot_Batch_No = Lot_Batch_No_
         And t.Serial_No = Serial_No_
         And t.Waiv_Dev_Rej_No = Waiv_Dev_Rej_No_
         And t.Eng_Chg_Level = Eng_Chg_Level_
         And t.Pick_List_No = '*'
         And t.Pallet_Id = '*';
    Fetch Cur_
      Into Row_;
    If Cur_%Found Then
      Result_ := Row_.Qty_Assigned;
    End If;
    Close Cur_;
    Return Result_;
  End;
  Function Get_Picklist_Assigned_(Picklistno_       In Varchar2,
                                  Order_No_         In Varchar2,
                                  Line_No_          In Varchar2,
                                  Rel_No_           In Varchar2,
                                  Line_Item_No_     Number,
                                  Contract_         In Varchar2,
                                  Configuration_Id_ In Varchar2,
                                  Location_No_      In Varchar2,
                                  Lot_Batch_No_     In Varchar2,
                                  Serial_No_        In Varchar2,
                                  Waiv_Dev_Rej_No_  In Varchar2,
                                  Eng_Chg_Level_    In Varchar2)
    Return Number Is
    Cur_    t_Cursor;
    Row_    Bl_Pltrans%Rowtype;
    Result_ Number;
  Begin
    Result_ := 0;
    Open Cur_ For
      Select t.*
        From Bl_Pltrans t
       Where t.Picklistno = Picklistno_
         And t.Transid Is Null
         And t.Order_No = Order_No_
         And t.Line_No = Line_No_
         And t.Rel_No = Rel_No_
         And t.Line_Item_No = Line_Item_No_
         And t.Contract = Contract_
         And t.Location_No = Location_No_
         And t.Lot_Batch_No = Lot_Batch_No_
         And t.Serial_No = Serial_No_
         And t.Eng_Chg_Leve = Eng_Chg_Level_
         And t.Waiv_Dev_Rej_No = Waiv_Dev_Rej_No_
         And t.Configuration_Id = Configuration_Id_
         And t.Flag = '0';
    Fetch Cur_
      Into Row_;
    If Cur_%Found Then
      Result_ := Row_.Qty_Assigned;
    End If;
    Close Cur_;
    Return Result_;
  End;
  Function Get_Picklist_Allassigned_(Picklistno_   In Varchar2,
                                     Order_No_     In Varchar2,
                                     Line_No_      In Varchar2,
                                     Rel_No_       In Varchar2,
                                     Line_Item_No_ Number) Return Number Is
    Cur_      t_Cursor;
    Result_   Number;
    Datalist_ Dbms_Sql.Varchar2_Table;
  Begin
    --取得工厂订单号
    Datalist_ := Pkg_a.Get_Str_List_By_Index(Bl_Customer_Order_Line_Api.Get_Factory_Order_(Order_No_,
                                                                                           Line_No_,
                                                                                           Rel_No_,
                                                                                           Line_Item_No_),
                                             '-');
    Result_   := 0;
    Open Cur_ For
      Select Sum(t.Qty_Assigned)
        From Bl_Pltrans t
       Where t.Picklistno = Picklistno_
         And t.Transid Is Null
         And t.Order_No = Datalist_(1)
         And t.Line_No = Datalist_(2)
         And t.Rel_No = Datalist_(3)
         And t.Line_Item_No = Datalist_(4)
         And t.Flag = '0';
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  End;
  Function Get_Customer_Pkgcoefficient_(Order_No_     Varchar2,
                                        Line_No_      Varchar2,
                                        Rel_No_       Varchar2,
                                        Line_Item_No_ Number,
                                        Qty_          Number) Return Number Is
    Cur_ t_Cursor;
    Row_ Customer_Order_Line%Rowtype;
  Begin
    --包装件为-1line_item_no大于0的为包装件的主键
    If Line_Item_No_ > 0 Then
      Open Cur_ For
        Select t.*
          From Customer_Order_Line t
         Where t.Order_No = Order_No_
           And t.Line_No = Line_No_
           And t.Rel_No = Rel_No_
           And t.Line_Item_No = -1;
      Fetch Cur_
        Into Row_;
      If Cur_%Found Then
        Return Qty_ / Row_.Buy_Qty_Due;
      Else
        Return 1;
      End If;
      Close Cur_;
    Else
      Return 1;
    End If;
  End;
  Function Get_Customer_State_(Order_No_ Varchar2) Return Varchar2 Is
    Result_ Varchar2(100);
    Cur_    t_Cursor;
  Begin
    Open Cur_ For
      Select Substrb(Customer_Order_Api.Finite_State_Decode__(Rowstate),
                     1,
                     253)
        From Customer_Order_Tab
       Where Order_No = Order_No_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  End;
  --  objid_ 预留订单行的objid
  Function Getdeliver_Orderurl(Order_Line_ In Varchar2) Return Varchar2 Is
    Row_               Bl_Pltrans%Rowtype;
    Co_Cur             t_Cursor;
    Par_Order_Line_    Varchar2(1000);
    Return_Order_Line_ Varchar2(1000);
  Begin
    Open Co_Cur For
      Select *
        From Bl_Pltrans t
       Where t.Order_No = Pkg_a.Get_Str_(Order_Line_, '-', 1)
         And t.Line_No = Pkg_a.Get_Str_(Order_Line_, '-', 2)
         And t.Rel_No = Pkg_a.Get_Str_(Order_Line_, '-', 3)
         And t.Line_Item_No = Pkg_a.Get_Str_(Order_Line_, '-', 4)
         And t.Flag = '0';
    Fetch Co_Cur
      Into Row_;
    If (Co_Cur%Notfound) Then
      Close Co_Cur;
      Return '';
    End If;
    Close Co_Cur;
    If Row_.Picklistno = Row_.Order_No Then
      Return '[HTTP_URL]/showform/MainForm.aspx?option=M&A002KEY=900504&key=' || Row_.Contract || '-' || Row_.Catalog_No || '-' || Order_Line_;
    End If;
    Par_Order_Line_    := Bl_Customer_Order_Line_Api.Get_Par_Order_(Row_.Order_No,
                                                                    Row_.Line_No,
                                                                    Row_.Rel_No,
                                                                    Row_.Line_Item_No);
    Return_Order_Line_ := Pkg_a.Get_Str_(Par_Order_Line_, '-', 1) || '-' ||
                          Pkg_a.Get_Str_(Par_Order_Line_, '-', 2) || '-' ||
                          Pkg_a.Get_Str_(Par_Order_Line_, '-', 3) || '-' ||
                          Pkg_a.Get_Str_(Order_Line_, '-', 4);
    Return '[HTTP_URL]/showform/MainForm.aspx?option=M&A002KEY=900503&key=' || Row_.Picklistno || '-' || Return_Order_Line_;
  End;
    --获取交货的状态（预留跟提货）
  function Get_PartDeliver(picklistno_   varchar2,
                           Order_No_     Varchar2,
                           Line_No_      Varchar2,
                           Rel_No_       Varchar2,
                           Line_Item_No_ Number,
                           finishqty_          Number) return varchar2
   is 
   qty_assigned_ number;
   qty_shipped_  number;
   begin 
    select   nvl(sum(t1.qty_assigned),0),nvl(sum( t1.qty_picked),0) 
      into   qty_assigned_,qty_shipped_
      from bl_pltrans t
      inner join CUSTOMER_ORDER_RESERVATION_TAB t1
      on t.Order_No = t1.Order_No                                    
     And t.Rel_No = t1.Rel_No
     And t.Line_No = t1.Line_No
     And t.Line_Item_No = t1.Line_Item_No
     And t.Contract = t1.Contract
     And t.Location_No = t1.Location_No
     And t.Lot_Batch_No = t1.Lot_Batch_No
     And t.Serial_No = t1.Serial_No
     And t.Eng_Chg_Leve = t1.Eng_Chg_Level
     And t.Waiv_Dev_Rej_No = t1.Waiv_Dev_Rej_No
     And t.Configuration_Id = t1.Configuration_Id
     --and t1.Qty_Assigned > 0
    -- and t1.qty_picked =0
     where t.transid is null
    -- and t.order_no is not null
     and nvl(t.flag, '0') = '0'
     and t.picklistno=picklistno_
     and t.Order_No =  Order_No_                                    
     And t.Rel_No =    Rel_No_
     And t.Line_No =    Line_No_
     And t.Line_Item_No = Line_Item_No_;
     if qty_assigned_= 0 then 
        return '0';--未预留
     else
        if qty_assigned_ < finishqty_ then 
           if qty_shipped_ > 0 then 
              return '3';--部分提货
           else
              return '1';--部分预留
           end if ;
        else
          if qty_shipped_ > 0 then 
             if qty_shipped_ < finishqty_ then 
                return '3';--部分提货
             else
                return '4'; --已提货
             end if;
          else
            return '2';--已预留
          end if ;
        end if ;
     end if ;
   end;
End Bl_Co_Deliver_Api;
/
