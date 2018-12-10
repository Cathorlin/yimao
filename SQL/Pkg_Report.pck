Create Or Replace Package Pkg_Report Is
  Procedure Proc_Report(Location_No_ In Varchar2, Contract_ In Varchar2);
  Procedure Proc_Report_01;
  Procedure Set_Bl_Report_(Report_Row_ In Out Bl_Report%Rowtype,
                           Objid_      Out Varchar2);
  Procedure Set_Bl_Report_Temp(Report_Row_ In Out Bl_Report_Temp%Rowtype,
                               Objid_      Out Varchar2);
  Procedure Modify_Report_Temp(Report_Temp_ In Out Bl_Report_Temp%Rowtype);
  Function Get_Needqty(Contract_    In Varchar,
                       Location_No_ In Varchar2,
                       Catalog_No_  In Varchar2,
                       Date_        In Date) Return Number;

  Function Get_Supplieqty(Contract_    In Varchar,
                          Location_No_ In Varchar2,
                          Catalog_No_  In Varchar2,
                          Date_        In Date) Return Number;
  Procedure Reset_Sequence;
  --记录历史
  Procedure Save_Report_Hist;
  --获取库存件的信息
  Function Get_Type_Designation(Contract_ In Varchar, Part_No_ In Varchar2)
    Return Varchar2;
  --获取客户订单的po标示
  Function Get_Po_Identifier(Order_No_     In Varchar2,
                             Line_No_      In Varchar2,
                             Rel_No_       In Varchar2,
                             Line_Item_No_ In Number) Return Varchar2;
  --金额汇总
  Function Getnumericalvalue2(v_Amount In Number) Return Varchar2;
  --获取快递单号
  Function Get_Express_Id_(Picklist_No_ In Varchar2,
                           Column_Id_   In Varchar2) Return Varchar2;
  --获取客户订单的客户件号
  Function Get_Customer_Part_No_(Order_No_     In Varchar2,
                                 Line_No_      In Varchar2,
                                 Rel_No_       In Varchar2,
                                 Line_Item_No_ In Number) Return Varchar2;
  --获取订单行信息
  Function Get_Order_Info(Order_No_     In Varchar2,
                          Line_No_      In Varchar2,
                          Rel_No_       In Varchar2,
                          Line_Item_No_ In Number,
                          Column_Id_    In Varchar2) Return Varchar2;
  --获取订舱委托信息
  Function Get_Bookinglist_Info(Picklistno_ In Varchar2,
                                Column_Id_  In Varchar2,
                                Col_        In Varchar2) Return Varchar2;

  Function Get_Bookinglist_Info1(Picklistno_ In Varchar2,
                                 Column_Id_  In Varchar2) Return Varchar2;
  --获取订单信息
  Function Get_Customer_Order_Info_(Order_No_  In Varchar2,
                                    Column_Id_ In Varchar2) Return Varchar2;
  --获取包装资料基本数据
  Function Get_Packing_Base(Picklistno_  In Varchar2,
                            Packing_Tag_ In Varchar2) Return Number;
  --获取站点备货装货单明细信息
  Function Get_Pltrans_Info(Picklistno_ In Varchar2,
                            Column_Id_  In Varchar2) Return Varchar2;
  --获取站点备货主档信息
  Function Get_Picklist_Info(Picklistno_ In Varchar2,
                             Column_Id_  In Varchar2) Return Varchar2;
  --执行预计交货计划
  Procedure Proc_Plan(Plan_Id_  In Varchar2,
                      User_Id_  In Varchar2,
                      A311_Key_ In Number);

  Procedure Proc_Plan_(Rowlist_  In Varchar2,
                       User_Id_  In Varchar2,
                       A311_Key_ In Number);

  --产生预测的 job
  Procedure Porc_Materiel_Plan(Rowlist_  In Varchar2,
                               User_Id_  In Varchar2,
                               A311_Key_ In Number);
  --预测 物料的采购计划
  Procedure Porc_Materiel_Plan_(Rowlist_  In Varchar2,
                                User_Id_  In Varchar2,
                                A311_Key_ In Number);
End Pkg_Report;
/
Create Or Replace Package Body Pkg_Report Is
  Type t_Cursor Is Ref Cursor;
  Procedure Proc_Report(Location_No_ In Varchar2, Contract_ In Varchar2) Is
    Cur_            t_Cursor;
    Cur1_           t_Cursor;
    Po_             Bl_Purchase_Order_V01%Rowtype;
    Report_Row_     Bl_Report%Rowtype;
    Report_Row_Null Bl_Report%Rowtype;
    Objid_          Varchar2(100);
    i_              Number;
    Co20_           Customer_Order_Line_Tab%Rowtype;
    Co20_Null       Customer_Order_Line_Tab%Rowtype;
    Co30_           Bl_v_Customer_Order_Line%Rowtype;
    Co30_Null       Bl_v_Customer_Order_Line%Rowtype;
    Dprow_          Bl_Delivery_Plan_Detial_v%Rowtype;
    Dprow_Null      Bl_Delivery_Plan_Detial_v%Rowtype;
    Ith_            Inventory_Transaction_Hist2%Rowtype;
    Bl_Pldtl_       Bl_Pldtl%Rowtype;
    Bl_Picklist_    Bl_Picklist%Rowtype;
    Bl_Bookinglist_ Bl_Bookinglist%Rowtype;
    Pruperido_      Number; --生产周期
    Shipdemsn_      Number; --订舱预留周期  
    Shippingperiod_ Number; --预计货运周期
    Report_Temp_    Bl_Report_Temp%Rowtype; --记录现有的物料 
  Begin
  
    Open Cur_ For
      Select t.*
        From Bl_Purchase_Order_V01 t
       Where Bllocation_No = Location_No_
         And t.Contract = Contract_;
    --t.Bllocation_No = Location_No_
    --  And t.Contract = Contract_;
    Shippingperiod_ := Bl_Part_Api.Get_Shippingperiod(Location_No_,
                                                      Contract_);
    If Shippingperiod_ = 0 Then
      Report_Row_Null.Col16 := Nvl(Report_Row_Null.Col16, '') || '预计货运周期,';
    End If;
    Shipdemsn_ := Bl_Part_Api.Get_Shipdemsn(Contract_);
    If Shipdemsn_ = 0 Then
      Report_Row_Null.Col16 := Nvl(Report_Row_Null.Col16, '') || '订舱预留周期,';
    End If;
  
    Report_Row_Null.Col30 := Bl_Part_Api.Get_Ifsavehist(Contract_);
    Fetch Cur_
      Into Po_;
    Loop
    
      Exit When Cur_%Notfound;
    
      Report_Temp_.Col00   := Po_.Contract;
      Report_Temp_.Col01   := Po_.Bllocation_No;
      Report_Temp_.Col02   := Po_.Part_No;
      Report_Temp_.Row_Key := Report_Temp_.Col00 || '-' ||
                              Report_Temp_.Col01 || '-' ||
                              Report_Temp_.Col02;
      --记录是否写日志
      Report_Temp_.Col30 := Report_Row_Null.Col30;
      Modify_Report_Temp(Report_Temp_);
      --库位
      Report_Row_         := Report_Row_Null;
      Co20_               := Co20_Null;
      Co30_               := Co30_Null;
      Dprow_              := Dprow_Null;
      Report_Row_.Row_Key := 'PO';
      Report_Row_.Col00   := Po_.Bllocation_No;
      Report_Row_.Col20   := Report_Row_.Col00;
      --外部客户
      Report_Row_.Col01 := Po_.Label_Note;
      --域
      Report_Row_.Col02 := Po_.Contract;
    
      -- 采购订单信息
      Report_Row_.Col03 := Po_.Order_No;
      Report_Row_.Col04 := Po_.Line_No;
      Report_Row_.Col05 := Po_.Release_No;
    
      --产品编码
      Report_Row_.Col15 := Po_.Part_No;
    
      --第一个 日期 采购订单 录入日期 和 数量
      Report_Row_.Date01 := Trunc(Po_.Date_Entered, 'dd');
      Report_Row_.Num01  := Po_.Buy_Qty_Due;
    
      Report_Row_.Num10 := Report_Row_.Num01;
      --寻找下域的客户订单    
      Open Cur1_ For
        Select t.*
          From Customer_Order_Line_Tab t
         Where t.Demand_Order_Ref1 = Po_.Order_No
           And t.Demand_Order_Ref2 = Po_.Line_No
           And t.Demand_Order_Ref3 = Po_.Release_No;
      Fetch Cur1_
        Into Co20_;
      If Cur1_%Found Then
        Close Cur1_;
        -- 获取订单的工厂域订单
        Bl_Customer_Order_Line_Api.Get_Factory_Orderrow_(Co20_.Order_No,
                                                         Co20_.Line_No,
                                                         Co20_.Rel_No,
                                                         Co20_.Line_Item_No,
                                                         Co30_);
        If Co30_.Supply_Code = 'Int Purch Dir' Then
          Goto Nextrow;
        End If;
        --下域客户订单           
        Report_Row_.Col06 := Co20_.Order_No;
        Report_Row_.Col07 := Co20_.Line_No;
        Report_Row_.Col08 := Co20_.Rel_No;
        Report_Row_.Col09 := Co20_.Line_Item_No;
      
        --采购订单的发送日期 下域的订单录入时间
        Report_Row_.Date01 := Trunc(Co20_.Date_Entered, 'dd');
        Report_Row_.Num01  := Co20_.Buy_Qty_Due;
      
        Report_Row_.Col10 := Co30_.Order_No;
        Report_Row_.Col11 := Co30_.Line_No;
        Report_Row_.Col12 := Co30_.Rel_No;
        Report_Row_.Col13 := Co30_.Line_Item_No;
        Report_Row_.Col14 := Co30_.Contract;
        --获取生产的交期 
        Pruperido_ := Bl_Part_Api.Get_Pruperido(Co30_.Catalog_No,
                                                Co30_.Contract);
      
        If Pruperido_ = 0 Then
          Report_Row_.Col16 := Nvl(Report_Row_.Col16, '') || '生产交期,';
        
        End If;
        -- 获取交货计划          
        Open Cur1_ For
          Select t.*
            From Bl_Delivery_Plan_Detial_v t
           Where t.f_Order_No = Co30_.Order_No
             And t.f_Line_No = Co30_.Line_No
             And t.f_Rel_No = Co30_.Rel_No
             And t.f_Line_Item_No = Co30_.Line_Item_No
             And t.State Not In ('0', '1', '3'); --过滤 新增 和 未确认的交货计划
        Fetch Cur1_
          Into Dprow_;
        If Cur1_%Found Then
          Loop
            Exit When Cur1_%Notfound;
            --交货计划的日期和数量
            Report_Row_.Col22  := Dprow_.Delplan_No;
            Report_Row_.Num02  := Dprow_.Qty_Delived;
            Report_Row_.Date02 := Dprow_.Delived_Date;
            --入库数量
            Report_Row_.Num10 := Report_Row_.Num02;
            -- bl_customer_order_line_api
            --备货单日期
            If Nvl(Dprow_.Picklistno, '-') <> '-' Then
              Report_Row_.Col23  := Dprow_.Picklistno;
              Report_Row_.Date03 := Dprow_.Delived_Date;
            
              Bl_Customer_Order_Line_Api.Get_Pick_Date_(Dprow_.Picklistno,
                                                        Dprow_.Order_No,
                                                        Dprow_.Line_No,
                                                        Dprow_.Rel_No,
                                                        Dprow_.Line_Item_No,
                                                        Bl_Pldtl_,
                                                        Bl_Picklist_);
              Report_Row_.Num03 := Nvl(Bl_Pldtl_.Pickqty, 0);
              If Nvl(Bl_Pldtl_.Finishqty, 0) > 0 Then
                Report_Row_.Num03 := Bl_Pldtl_.Finishqty;
              End If;
              Report_Row_.Date03 := To_Date(Bl_Picklist_.Releasedate,
                                            'YYYY-MM-DD');
              Report_Row_.Col20  := Bl_Picklist_.Location;
            
              --备货单库位                                          
              Report_Row_.Col20 := Nvl(Report_Row_.Col20, Report_Row_.Col00);
              Report_Row_.Num03 := Nvl(Report_Row_.Num03, 0);
              If Report_Row_.Num03 > 0 Then
                Report_Row_.Num10 := Report_Row_.Num03;
              End If;
              --select T.ISSURE,T.SHIPDATE,* from bl_picklist t  
            
              --判断有没有订舱 订舱单
              Bl_Customer_Order_Line_Api.Get_Bookinglist_(Dprow_.Picklistno,
                                                          Dprow_.Order_No,
                                                          Dprow_.Line_No,
                                                          Dprow_.Rel_No,
                                                          Dprow_.Line_Item_No,
                                                          Bl_Bookinglist_);
              --判断船期是否确认                                            
              If Nvl(Bl_Picklist_.Issure, '0') <> '1' Then
              
                --判断是否订舱
                If Nvl(Bl_Bookinglist_.Booking_No, '-') <> '-' Then
                  Report_Row_.Col24  := Bl_Bookinglist_.Booking_No;
                  Report_Row_.Num04  := Report_Row_.Num03;
                  Report_Row_.Date04 := To_Date(Bl_Bookinglist_.Shipment,
                                                'YYYY-MM-DD');
                Else
                
                  Report_Row_.Col24  := '';
                  Report_Row_.Num04  := 0;
                  Report_Row_.Date04 := Dprow_.Delived_Date + Shipdemsn_;
                
                End If;
              Else
                Report_Row_.Col24 := Bl_Bookinglist_.Booking_No;
                Report_Row_.Num04 := Report_Row_.Num03;
                --如果船期 报关确认以后  取确认船期
                Report_Row_.Date04 := To_Date(Bl_Picklist_.Shipdate,
                                              'YYYY-MM-DD');
              End If;
            
              If Report_Row_.Num04 > 0 Then
                Report_Row_.Num10 := Report_Row_.Num03;
              End If;
              --判断有没有实际到货
              Bl_Customer_Order_Line_Api.Get_Ith_(Dprow_.Picklistno,
                                                  Po_.Order_No,
                                                  Po_.Line_No,
                                                  Po_.Release_No,
                                                  Ith_);
              --没有到货                                    
              If Nvl(Ith_.Transaction_Id, 0) = 0 Then
                Report_Row_.Col25 := '';
                Report_Row_.Col26 := '';
                Report_Row_.Num05 := 0;
                --获取预计货运周期
                Report_Row_.Date05 := Report_Row_.Date04 + Shippingperiod_;
              Else
                Report_Row_.Col25 := Ith_.Transaction_Id;
                Report_Row_.Col26 := Ith_.Location_No;
                --实际库位
                Report_Row_.Col20  := Ith_.Location_No;
                Report_Row_.Num05  := Ith_.Quantity;
                Report_Row_.Date05 := Ith_.Date_Applied;
              
              End If;
              If Report_Row_.Num05 > 0 Then
                Report_Row_.Num10 := Report_Row_.Num05;
              End If;
            Else
              Report_Row_.Col23  := Dprow_.Picklistno;
              Report_Row_.Num03  := Dprow_.Qty_Delived;
              Report_Row_.Date03 := Dprow_.Delived_Date;
              --判断有没有订舱 订舱单
              Report_Row_.Col24  := '';
              Report_Row_.Num04  := 0;
              Report_Row_.Date04 := Report_Row_.Date03 + Shipdemsn_;
            
              --判断有没有实际到货
              Report_Row_.Col25  := '';
              Report_Row_.Col26  := '';
              Report_Row_.Num05  := 0;
              Report_Row_.Date05 := Report_Row_.Date04 + Shippingperiod_;
              If Report_Row_.Date05 <= Trunc(Sysdate, 'dd') Then
                Report_Row_.Date05 := Trunc(Sysdate, 'dd') + 1;
              
              End If;
            End If;
            Report_Row_.Date20     := Report_Row_.Date05;
            Report_Row_.Enter_Date := Sysdate;
            Report_Row_.Enter_User := 'System';
            Pkg_Report.Set_Bl_Report_(Report_Row_, Objid_);
            Fetch Cur1_
              Into Dprow_;
          End Loop;
          Close Cur1_;
        Else
          Close Cur1_;
          --如果没有交货计划
          Report_Row_.Col22 := '';
          Report_Row_.Num02 := 0;
        
          Report_Row_.Date02 := Report_Row_.Date01 + Pruperido_;
        
          --获取备货单日期
        
          Report_Row_.Col23  := '';
          Report_Row_.Num03  := 0;
          Report_Row_.Date03 := Report_Row_.Date02;
        
          --订舱
          Report_Row_.Col24  := '';
          Report_Row_.Num04  := 0;
          Report_Row_.Date04 := Report_Row_.Date03;
        
          --到货日期
        
          Report_Row_.Col25  := '';
          Report_Row_.Num05  := 0;
          Report_Row_.Date05 := Report_Row_.Date04 + 35;
        
          Report_Row_.Date20 := Report_Row_.Date05;
          If Report_Row_.Date20 <= Trunc(Sysdate, 'dd') Then
            Report_Row_.Date20 := Trunc(Sysdate, 'dd') + 1;
          End If;
          Report_Row_.Enter_Date := Sysdate;
          Report_Row_.Enter_User := 'System';
          Pkg_Report.Set_Bl_Report_(Report_Row_, Objid_);
        End If;
      
        --Dbms_Output.Put_Line(Co20_.Order_No || ';;;' || Co30_.Order_No);
      Else
        Close Cur1_;
      End If;
      i_ := i_ + 1;
      <<nextrow>>
    
      Fetch Cur_
        Into Po_;
    End Loop;
    Close Cur_;
  
  End;

  Procedure Modify_Report_Temp(Report_Temp_ In Out Bl_Report_Temp%Rowtype) Is
    Cur_          t_Cursor;
    Report_Temp__ Bl_Report_Temp%Rowtype;
    Objid_        Varchar2(100);
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Report_Temp t
       Where t.Row_Key = Report_Temp_.Row_Key;
    Fetch Cur_
      Into Report_Temp_;
    If Cur_%Notfound Then
      --插入数据
      Set_Bl_Report_Temp(Report_Temp_, Objid_);
    Else
      Report_Temp_ := Report_Temp__;
    End If;
    Close Cur_;
  End;
  --补货交货计划  -- check 提货计划 是否
  Procedure Proc_Plan_(Rowlist_  In Varchar2,
                       User_Id_  In Varchar2,
                       A311_Key_ In Number) Is
    Row_              Bl_v_Location_Plan%Rowtype;
    Cur_              t_Cursor;
    Bl_Cust_Forecast_ Bl_Cust_Forecast%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Location_Plan t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的ROWID');
    Else
      Close Cur_;
    
    End If;
    --检测是否有未处理的提货计划
    Open Cur_ For
      Select t.*
        From Bl_Cust_Forecast t
       Where t.Contract = Row_.Contract
         And t.Location_No = Row_.Location_No
         And t.Plan_Id = Row_.Plan_Id
         And t.State = '0';
    Fetch Cur_
      Into Bl_Cust_Forecast_;
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Bl_Cust_Forecast_.Customer_No || '的提货计划(' ||
                              Bl_Cust_Forecast_.Forecast_No || ')未提交');
    
    End If;
    Close Cur_;
    --生成一个JOB 凌晨3点执行
    Row_.Do_Date := Trunc(Sysdate, 'dd') + 1 + 3 / 24;
    --更新状态执行补货计划过程中
    Update Bl_Location_Plan t
       Set t.State     = '01',
           t.Modi_Date = Sysdate,
           t.Modi_User = User_Id_,
           t.Do_Date   = Row_.Do_Date
     Where t.Plan_Id = Row_.Plan_Id;
    Pkg_a.Setnextdo(A311_Key_,
                    '补货计划-' || Row_.Plan_Id || '(' || Row_.Contract || '-' ||
                    Row_.Location_No || ')',
                    User_Id_,
                    'Pkg_Report.Proc_Plan(''' || Row_.Plan_Id || ''',''' ||
                    User_Id_ || ''',' || To_Char(A311_Key_) || ')',
                    Row_.Do_Date - Sysdate);
  
  End;
  Procedure Porc_Materiel_Plan(Rowlist_  In Varchar2,
                               User_Id_  In Varchar2,
                               A311_Key_ In Number) Is
    Row_              Bl_v_Location_Plan%Rowtype;
    Prow_             Bl_v_Location_Plan%Rowtype;
    Cur_              t_Cursor;
    Bl_Cust_Forecast_ Bl_Cust_Forecast%Rowtype;
    Ss_               Number;
    A311_             A311%Rowtype;
    Old_A311_Key      Number;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Location_Plan t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的ROWID');
    Else
      Close Cur_;
    
    End If;
    If Row_.Plan_State = '01' Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '预测请求已发送，请等待执行完再发送预测请求！');
    End If;
    --生成一个JOB 凌晨3点执行
    Row_.Do_Date := Trunc(Sysdate, 'dd') + 1 + 3 / 24;
  
    --检测上一个期间的预测是否执行完
    Open Cur_ For
      Select t.*
        From Bl_v_Location_Plan t
       Where t.End_Date < Row_.Begin_Date
         And t.Plan_Date < t.End_Date
         And t.Location_No = Row_.Location_No
         And t.Contract = Row_.Contract
       Order By t.End_Date;
    Fetch Cur_
      Into Prow_;
    Ss_          := Row_.Do_Date - Sysdate;
    Old_A311_Key := A311_Key_;
    Loop
      Exit When Cur_%Notfound;
      --生成一个JOB
      --正在执行
      Update Bl_Location_Plan t
         Set t.Plan_State = '01'
       Where t.Rowid = Prow_.Objid;
      A311_.A311_Id     := 'Blbill_Vary_Api.Coapprove__';
      A311_.Enter_User  := User_Id_;
      A311_.A014_Id     := 'A014_ID=Coapprove__';
      A311_.Table_Id    := 'BL_BILL_VARY_V';
      A311_.Table_Objid := Rowlist_;
      Pkg_a.Beginlog(A311_);
    
      Pkg_a.Setnextdo(A311_Key_,
                      '预测计划-' || Prow_.Plan_Id || '(' || Prow_.Contract || '-' ||
                      Prow_.Location_No || ')',
                      User_Id_,
                      'Pkg_Report.Porc_Materiel_Plan_(''' || Prow_.Objid ||
                      ''',''' || User_Id_ || ''',' ||
                      To_Char(A311_.A311_Key) || ')',
                      Ss_,
                      Old_A311_Key);
      Old_A311_Key := A311_.A311_Key;
      Ss_          := Ss_ + 30 / 60 / 60 / 24;
      Fetch Cur_
        Into Prow_;
    End Loop;
    Close Cur_;
  
    --正在执行
    Update Bl_Location_Plan t
       Set t.Plan_State = '01'
     Where t.Rowid = Rowlist_;
  
    --生成一个JOB
    Pkg_a.Setnextdo(A311_Key_,
                    '预测计划-' || Row_.Plan_Id || '(' || Row_.Contract || '-' ||
                    Row_.Location_No || ')',
                    User_Id_,
                    'Pkg_Report.Porc_Materiel_Plan_(''' || Rowlist_ ||
                    ''',''' || User_Id_ || ''',' || To_Char(A311_Key_) || ')',
                    Ss_,
                    Old_A311_Key);
  End;

  --执行物料的采购计划
  Procedure Porc_Materiel_Plan_(Rowlist_  In Varchar2,
                                User_Id_  In Varchar2,
                                A311_Key_ In Number) Is
    Row_              Bl_Location_Plan%Rowtype;
    p_Row_            Bl_Location_Plan%Rowtype; --上一个周期
    Cur_              t_Cursor;
    Cur1_             t_Cursor;
    Res_              Number;
    Bl_Cust_Forecast_ Bl_Cust_Forecast%Rowtype;
    Coline_           Customer_Order_Line%Rowtype;
    Bl_Coline_        Bl_Customer_Order_Line%Rowtype;
    Bl_Vary_Detail_   Bl_Bill_Vary_Detail%Rowtype;
    Bl_Vary_          Bl_Bill_Vary%Rowtype;
    Fac_Contract_     Varchar2(100); --工厂域
    Fac_Part_No_      Varchar2(100); --物料   
    i_                Number;
    Iline_            Bl_Location_Plan_Line%Rowtype;
    Thisdate_         Date;
  Begin
    Open Cur_ For
      Select t.* From Bl_Location_Plan t Where t.Rowid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的ROWID');
    Else
      Close Cur_;
    End If;
    --执行 OUT 的数据
    If 1 = 1 Then
      --执行订单的数据
      Open Cur_ For
        Select t.*
          From Customer_Order_Line t
         Where t.Date_Entered >= Row_.Begin_Date
           And t.Date_Entered < Row_.End_Date + 1
           And Exists (Select 1
                  From Prod_Structure_Head a
                 Where a.Part_No = t.Catalog_No
                   And a.Contract = t.Contract
                   And a.Bom_Type_Db = 'M')
           And Not Exists
         (Select 1
                  From Bl_Customer_Order_Line_Child b
                 Where b.Order_No = t.Order_No
                   And b.Line_No = t.Line_No
                   And b.Rel_No = t.Rel_No
                   And b.Line_Item_No = t.Line_Item_No
                   And b.Line_Key = b.Order_Line_Key);
      Fetch Cur_
        Into Coline_;
      Loop
        Exit When Cur_%Notfound;
      
        /*        Delete From Bl_Customer_Order_Line_Child t
        Where t.Order_No = Coline_.Order_No
          And t.Line_No = Coline_.Line_No
          And t.Rel_No = Coline_.Rel_No
          And t.Line_Item_No = Coline_.Line_Item_No;*/
        Open Cur1_ For
          Select 1
            From Bl_Prod_Structure_Temp t
           Where t.Contract = Coline_.Contract
             And t.Part_No = Coline_.Catalog_No;
        Fetch Cur1_
          Into Res_;
        If Cur1_%Notfound Then
          Bl_Part_Api.Set_Bom_Temp(Coline_.Catalog_No,
                                   Coline_.Contract,
                                   Coline_.Catalog_No,
                                   1);
        End If;
        Close Cur1_;
      
        Open Cur1_ For
          Select t.*
            From Bl_Customer_Order_Line t
           Where t.Order_No = Coline_.Order_No
             And t.Line_No = Coline_.Line_No
             And t.Rel_No = Coline_.Rel_No
             And t.Line_Item_No = Coline_.Line_Item_No;
        Fetch Cur1_
          Into Bl_Coline_;
        Close Cur1_;
        If Nvl(Bl_Coline_.Par_Demand_Ref1, '-') = '-' Then
          --获取最外层的域
          Open Cur1_ For
            Select T1.Contract
              From Customer_Order_Line t
             Inner Join Customer_Order T1
                On T1.Order_No = t.Order_No
             Where t.Order_No = Bl_Coline_.Par_Order_No
               And t.Line_No = Bl_Coline_.Par_Line_No
               And t.Rel_No = Bl_Coline_.Par_Rel_No
               And t.Line_Item_No = Bl_Coline_.Par_Line_Item_No;
          Fetch Cur1_
            Into Fac_Contract_;
          Close Cur1_;
        Else
          Open Cur1_ For
            Select T1.Customer_No
              From Customer_Order_Line t
             Inner Join Customer_Order T1
                On T1.Order_No = t.Order_No
             Where t.Order_No = Bl_Coline_.Par_Order_No
               And t.Line_No = Bl_Coline_.Par_Line_No
               And t.Rel_No = Bl_Coline_.Par_Rel_No
               And t.Line_Item_No = Bl_Coline_.Par_Line_Item_No;
          Fetch Cur1_
            Into Fac_Contract_;
          Close Cur1_;
        End If;
        Insert Into Bl_Customer_Order_Line_Child
          (Order_No,
           Line_No,
           Rel_No,
           Line_Item_No,
           Contract,
           Component_Part,
           Qty_Per,
           Qty,
           Enter_Date,
           Enter_User,
           Part_No,
           Date_Enterd,
           Pruperido,
           Pur_Days,
           Last_Date,
           Line_Key,
           Par_Order_No,
           Par_Line_No,
           Par_Rel_No,
           Par_Line_Item_No,
           Par_Demand_Ref1,
           Par_Demand_Ref2,
           Par_Demand_Ref3,
           Par_Demand_Ref4,
           Order_Line_Key,
           Par_Contract)
          Select Coline_.Order_No,
                 Coline_.Line_No,
                 Coline_.Rel_No,
                 Coline_.Line_Item_No,
                 Coline_.Contract,
                 t.Component_Part,
                 t.Qty_Per_Assembly,
                 t.Qty_Per_Assembly * Coline_.Buy_Qty_Due,
                 Sysdate,
                 User_Id_,
                 t.Part_No,
                 Coline_.Date_Entered,
                 t.Pruperido,
                 t.Pur_Days,
                 Coline_.Date_Entered,
                 Bl_Coline_.Order_Line_Key,
                 Bl_Coline_.Par_Order_No,
                 Bl_Coline_.Par_Line_No,
                 Bl_Coline_.Par_Rel_No,
                 Bl_Coline_.Par_Line_Item_No,
                 Bl_Coline_.Par_Demand_Ref1,
                 Bl_Coline_.Par_Demand_Ref2,
                 Bl_Coline_.Par_Demand_Ref3,
                 Bl_Coline_.Par_Demand_Ref4,
                 Bl_Coline_.Order_Line_Key,
                 Fac_Contract_
            From Bl_Prod_Structure_Temp t
           Where t.Contract = Coline_.Contract
             And t.Part_No = Coline_.Catalog_No;
        Fetch Cur_
          Into Coline_;
      End Loop;
      Close Cur_;
      --执行变更的数据 
      Open Cur_ For
        Select t.*
          From Bl_Bill_Vary_Detail t
         Inner Join Bl_Bill_Vary T1
            On T1.Modify_Id = t.Modify_Id
           And T1.State = '2'
           And T1.Date_Comform >= Row_.Begin_Date
           And T1.Date_Comform < Row_.End_Date + 1
           And T1.Type_Id In ('0', '1')
           And Not Exists
         (Select 1
                  From Bl_Customer_Order_Line_Child b
                 Where b.Order_No = t.Order_No
                   And b.Line_No = t.Line_No
                   And b.Rel_No = t.Rel_No
                   And b.Line_Item_No = t.Line_Item_No
                   And b.Line_Key =
                       t.Modify_Id || '-' || To_Char(t.Modify_Lineno)); --按日期排序
      Fetch Cur_
        Into Bl_Vary_Detail_;
      Loop
        Exit When Cur_%Notfound;
        Select t.*
          Into Bl_Vary_
          From Bl_Bill_Vary t
         Where t.Modify_Id = Bl_Vary_Detail_.Modify_Id;
      
        Delete From Bl_Customer_Order_Line_Child t
         Where t.Par_Order_No = Bl_Vary_Detail_.Order_No --20域的客户订单
           And t.Par_Line_No = Bl_Vary_Detail_.Line_No
           And t.Par_Rel_No = Bl_Vary_Detail_.Rel_No
           And t.Par_Line_Item_No = Bl_Vary_Detail_.Line_Item_No
           And t.Line_Key = Bl_Vary_Detail_.Modify_Id || '-' ||
               To_Char(Bl_Vary_Detail_.Modify_Lineno);
        If Bl_Vary_.Type_Id = '0' Then
        
          --把数据插入到 Bl_Customer_Order_Line_Child
          Insert Into Bl_Customer_Order_Line_Child
            (Order_No,
             Line_No,
             Rel_No,
             Line_Item_No,
             Contract,
             Component_Part,
             Qty_Per,
             Qty,
             Enter_Date,
             Enter_User,
             Part_No,
             Date_Enterd,
             Pruperido,
             Pur_Days,
             Last_Date,
             Line_Key,
             Par_Order_No,
             Par_Line_No,
             Par_Rel_No,
             Par_Line_Item_No,
             Par_Demand_Ref1,
             Par_Demand_Ref2,
             Par_Demand_Ref3,
             Par_Demand_Ref4,
             Order_Line_Key,
             Par_Contract)
            Select Order_No,
                   Line_No,
                   Rel_No,
                   Line_Item_No,
                   Contract,
                   Component_Part,
                   Qty_Per,
                   (Bl_Vary_Detail_.Qty_Delivedf -
                   Nvl(Bl_Vary_Detail_.Qty_Delived, 0)) * Qty_Per, --变化的数量 作为出库
                   Enter_Date,
                   Enter_User,
                   Part_No,
                   Bl_Vary_.Date_Comform,
                   Pruperido,
                   Pur_Days,
                   Last_Date,
                   Bl_Vary_Detail_.Modify_Id || '-' ||
                   To_Char(Bl_Vary_Detail_.Modify_Lineno),
                   Par_Order_No,
                   Par_Line_No,
                   Par_Rel_No,
                   Par_Line_Item_No,
                   Par_Demand_Ref1,
                   Par_Demand_Ref2,
                   Par_Demand_Ref3,
                   Par_Demand_Ref4,
                   Order_Line_Key,
                   Par_Contract
              From Bl_Customer_Order_Line_Child t
             Where t.Par_Order_No = Bl_Vary_Detail_.Order_No
               And t.Par_Line_No = Bl_Vary_Detail_.Line_No
               And t.Par_Rel_No = Bl_Vary_Detail_.Rel_No
               And t.Par_Line_Item_No = Bl_Vary_Detail_.Line_Item_No
               And t.Line_Key = t.Order_Line_Key;
        Else
          /*    Delete From Bl_Customer_Order_Line_Child t
          Where t.Par_Demand_Ref1 = Bl_Vary_Detail_.Order_No --10域的销售订单 补货单
            And t.Par_Demand_Ref2 = Bl_Vary_Detail_.Line_No
            And t.Par_Demand_Ref3 = Bl_Vary_Detail_.Rel_No
            And t.Line_Key = Bl_Vary_Detail_.Modify_Id || '-' ||
                To_Char(Bl_Vary_Detail_.Modify_Lineno);*/
          --把数据插入到 Bl_Customer_Order_Line_Child
          Insert Into Bl_Customer_Order_Line_Child
            (Order_No,
             Line_No,
             Rel_No,
             Line_Item_No,
             Contract,
             Component_Part,
             Qty_Per,
             Qty,
             Enter_Date,
             Enter_User,
             Part_No,
             Date_Enterd,
             Pruperido,
             Pur_Days,
             Last_Date,
             Line_Key,
             Par_Order_No,
             Par_Line_No,
             Par_Rel_No,
             Par_Line_Item_No,
             Par_Demand_Ref1,
             Par_Demand_Ref2,
             Par_Demand_Ref3,
             Par_Demand_Ref4,
             Order_Line_Key,
             Par_Contract)
            Select Order_No,
                   Line_No,
                   Rel_No,
                   Line_Item_No,
                   Contract,
                   Component_Part,
                   Qty_Per,
                   (Bl_Vary_Detail_.Qty_Delivedf -
                   Nvl(Bl_Vary_Detail_.Qty_Delived, 0)) * Qty_Per, --变化的数量 作为出库
                   Enter_Date,
                   Enter_User,
                   Part_No,
                   Bl_Vary_.Date_Comform,
                   Pruperido,
                   Pur_Days,
                   Bl_Vary_.Date_Comform,
                   Bl_Vary_Detail_.Modify_Id || '-' ||
                   To_Char(Bl_Vary_Detail_.Modify_Lineno),
                   Par_Order_No,
                   Par_Line_No,
                   Par_Rel_No,
                   Par_Line_Item_No,
                   Par_Demand_Ref1,
                   Par_Demand_Ref2,
                   Par_Demand_Ref3,
                   Par_Demand_Ref4,
                   Order_Line_Key,
                   Par_Contract
              From Bl_Customer_Order_Line_Child t
             Where t.Par_Demand_Ref1 = Coline_.Order_No
               And t.Par_Demand_Ref2 = Coline_.Line_No
               And t.Par_Demand_Ref3 = Coline_.Rel_No
               And t.Line_Key = t.Order_Line_Key;
        End If;
        Fetch Cur_
          Into Bl_Vary_Detail_;
      End Loop;
      Close Cur_;
    End If;
    -- 计算本期的时候 判断当前的期间是否 存在新的数据
    -- 结算所有比当前期间小的数据
    /* Open Cur_ For
      Select t.*
        From Bl_Location_Plan t
       Where t.End_Date < Row_.Begin_Date
         And t.Location_No = Row_.Location_No
         And t.Contract = Row_.Contract
         And t.Type_Id = '1'
         And t.End_Date >= Trunc(Sysdate, 'dd')
       Order By t.End_Date; --预测期间
    Fetch Cur_
      Into p_Row_;
    Loop
      Exit When Cur_%Notfound;
      Porc_Materiel_Plan_(p_Row_, User_Id_, A311_Key_);
      Fetch Cur_
        Into p_Row_;
    End Loop;
    Close Cur_;*/
    --执行本期以前的预测
    --获取上一个周期的数据
    Open Cur_ For
      Select t.*
        From Bl_Location_Plan t
       Where t.End_Date = Row_.Begin_Date - 1
         And t.Location_No = Row_.Location_No
         And t.Contract = Row_.Contract; --预测期间
    Fetch Cur_
      Into p_Row_;
    Close Cur_;
    /*    --开始循环物料
    Open Cur1_ For
      Select 1 From Bl_Location_Plan_Line t Where t.Plan_Id = Row_.Plan_Id;
    Fetch Cur1_
      Into Res_;
    If Cur1_%Found Then
      --删除以前的数据
      Delete From Bl_Location_Plan_Line t
       Where t.Plan_Id = Row_.Plan_Id
         And t.m_Date >= Trunc(Sysdate, 'dd');
      Commit;
    End If;
    Close Cur1_;*/
  
    Delete From /*nologging*/ Bl_Location_Plan_Line t
     Where t.Plan_Id = Row_.Plan_Id;
    /*    Commit;*/
  
    Res_ := 0;
    Open Cur_ For
      Select Distinct t.Contract, t.Component_Part
        From Bl_Customer_Order_Line_Child t
       Where t.Par_Contract = Row_.Contract
      --  And t.Component_Part = '11014078'
      Union
      Select Distinct a.Contract, a.Component_Part
        From Bl_Cust_Forecast_Child a
       Where a.Par_Contract = Row_.Contract
      --  And a.Component_Part = '11014078'
      ;
    Fetch Cur_
      Into Fac_Contract_, Fac_Part_No_;
    /*        
    Select Max(t.Line_No)
      Into i_
      From Bl_Location_Plan_Line t
     Where t.Plan_Id = Row_.Plan_Id;*/
    i_ := 0;
    i_ := Nvl(i_, 0);
    Loop
      Exit When Cur_%Notfound;
      --开始循环天数
      -- 把数据写入表BL_LOCATION_PLAN_LINE(结算表) 中
      Iline_.Plan_Id := Row_.Plan_Id;
      --预测天数
      Iline_.Contract       := Fac_Contract_;
      Iline_.Component_Part := Fac_Part_No_;
      Iline_.Enter_Date     := Sysdate;
      Iline_.Enter_User     := User_Id_;
      Iline_.Qty_Begin      := 0;
      Row_.Plan_Days        := Nvl(Row_.Plan_Days, 0);
      Thisdate_             := Row_.Begin_Date;
      --如果执行过 预测  过程只执行 当前日期的数据 以及以后的数据
      If Res_ = 1 Then
        Thisdate_ := Trunc(Sysdate, 'dd');
      End If;
      Loop
        Exit When Thisdate_ > Row_.End_Date + Row_.Plan_Days;
        i_             := i_ + 1;
        Iline_.m_Date  := Thisdate_;
        Iline_.Line_No := i_;
        Iline_.Sort_By := i_;
        Iline_.m_Date  := Thisdate_;
        --计算期初
        If Thisdate_ = Row_.Begin_Date Then
          -- 把上一个期间的预测最后一天的期末作为本期的期初
          If Nvl(p_Row_.Plan_Id, '-') <> '-' Then
            Open Cur1_ For
              Select t.Qty_End
                From Bl_Location_Plan_Line t
               Where t.Plan_Id = p_Row_.Plan_Id
                 And t.Contract = Iline_.Contract
                 And t.Component_Part = Iline_.Component_Part
                 And t.m_Date = Thisdate_ - 1;
            Fetch Cur1_
              Into Iline_.Qty_Begin;
            Close Cur1_;
            Iline_.Qty_Begin := Nvl(Iline_.Qty_Begin, 0);
          End If;
        End If;
      
        --计算本期入库
        Open Cur1_ For
          Select Sum(T1.Qty_Per * Nvl(T2.Qty_Prod, 0))
            From Bl_Cust_Forecast t
           Inner Join Bl_Cust_Forecast_Detail T2
              On T2.Forecast_No = t.Forecast_No
           Inner Join Bl_Cust_Forecast_Child T1
              On t.Forecast_No = T1.Forecast_No
             And T1.Component_Part = Iline_.Component_Part
             And T1.Contract = Iline_.Contract
           Where t.Plan_Id = Row_.Plan_Id
             And T2.Need_Date - (T1.Pruperido + T1.Pur_Days +
                 T1.Shippingperiod + T1.Shipdemsn) >= Thisdate_
             And T2.Need_Date - (T1.Pruperido + T1.Pur_Days +
                 T1.Shippingperiod + T1.Shipdemsn) < Thisdate_ + 1;
        Fetch Cur1_
          Into Iline_.Qty_In;
        Close Cur1_;
      
        Iline_.Qty_In := Nvl(Iline_.Qty_In, 0);
      
        Open Cur1_ For
          Select Sum(t.Qty)
            From Bl_Customer_Order_Line_Child t
           Where t.Contract = Iline_.Contract
             And t.Par_Contract = Row_.Contract
             And t.Component_Part = Iline_.Component_Part
             And t.Last_Date >= Thisdate_
             And t.Last_Date < Thisdate_ + 1
             And t.Line_Key = t.Order_Line_Key;
        Fetch Cur1_
          Into Iline_.Qty_Out;
        Close Cur1_;
        Iline_.Qty_Out := Nvl(Iline_.Qty_Out, 0);
        Open Cur1_ For
          Select Sum(t.Qty)
            From Bl_Customer_Order_Line_Child t
           Where t.Contract = Iline_.Contract
             And t.Par_Contract = Row_.Contract
             And t.Component_Part = Iline_.Component_Part
             And t.Last_Date >= Thisdate_
             And t.Last_Date < Thisdate_ + 1
             And t.Line_Key <> t.Order_Line_Key;
        Fetch Cur1_
          Into Iline_.Qty_Change;
        Close Cur1_;
      
        Iline_.Qty_Change := Nvl(Iline_.Qty_Change, 0);
        Update Bl_Customer_Order_Line_Child t
           Set t.Plan_Id   = Row_.Plan_Id,
               t.Modi_Date = Sysdate,
               t.Modi_User = User_Id_
         Where t.Contract = Iline_.Contract
           And t.Par_Contract = Row_.Contract
           And t.Component_Part = Iline_.Component_Part
           And t.Last_Date >= Thisdate_
           And t.Last_Date < Thisdate_ + 1;
        --如果开始时间比当前日期大 表示是预测 
        /*
            把预测提货的数量作为 需要的出库数量 
            入库必须为0
        */
        If Thisdate_ > Trunc(Sysdate, 'dd') Then
          Iline_.Qty_Out := Iline_.Qty_In;
          Iline_.Qty_In  := 0;
        End If;
        Iline_.Qty_End := Iline_.Qty_Begin + Iline_.Qty_In -
                          (Iline_.Qty_Change + Iline_.Qty_Out);
        If Iline_.Qty_In > 0 Or Iline_.Qty_Change > 0 Or Iline_.Qty_Out > 0 Then
          --写入结算的数据
          Insert Into Bl_Location_Plan_Line
            (Plan_Id,
             Line_No,
             Sort_By,
             Contract,
             Component_Part,
             Qty_Begin,
             Qty_In,
             Qty_Change,
             Qty_Out,
             Qty_End,
             Enter_Date,
             Enter_User,
             Modi_Date,
             Modi_User,
             m_Date)
          Values
            (Iline_.Plan_Id,
             Iline_.Line_No,
             Iline_.Sort_By,
             Iline_.Contract,
             Iline_.Component_Part,
             Iline_.Qty_Begin,
             Iline_.Qty_In,
             Iline_.Qty_Change,
             Iline_.Qty_Out,
             Iline_. Qty_End,
             Iline_.Enter_Date,
             Iline_.Enter_User,
             Iline_.Modi_Date,
             Iline_.Modi_User,
             Iline_.m_Date);
          Commit;
        End If;
        Iline_.Qty_Begin := Iline_.Qty_End;
        Thisdate_        := Thisdate_ + 1;
      End Loop;
    
      Fetch Cur_
        Into Fac_Contract_, Fac_Part_No_;
    End Loop;
    Close Cur_;
    Update Bl_Location_Plan t
       Set t.Plan_Date = Sysdate, t.Plan_State = '1' --预测执行完成
     Where t.Plan_Id = Row_.Plan_Id;
  End;
  --补货交货计划
  Procedure Proc_Plan(Plan_Id_  In Varchar2,
                      User_Id_  In Varchar2,
                      A311_Key_ In Number) Is
    Cur_          t_Cursor;
    Report_Temp_  Bl_Report_Temp%Rowtype;
    Report_Row_   Bl_Report%Rowtype;
    i_            Number;
    Objid_        Varchar2(50);
    Location_No__ Varchar2(50);
    Contract__    Varchar2(50);
    Row_          Bl_v_Location_Plan%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Location_Plan t Where t.Plan_Id = Plan_Id_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的ROWID');
    Else
      Close Cur_;
    
    End If;
  
    --先运行补货单的数据
    Delete From Bl_Report t Where t.Row_Key = 'PO';
    Commit;
    Delete From Bl_Report t
     Where t.Row_Key = 'MRP'
       And t.Col00 = Row_.Contract
       And t.Col01 = Row_.Location_No
       And t.Col32 = Row_.Plan_Id;
    Commit;
    Open Cur_ For
      Select Distinct t.Location_No, t.Contract From Bl_Shippingperiod t;
    Fetch Cur_
      Into Location_No__, Contract__;
    Loop
      Exit When Cur_%Notfound;
      Proc_Report(Location_No__, Contract__);
      Fetch Cur_
        Into Location_No__, Contract__;
    End Loop;
    Close Cur_;
  
    --再运行出库的数据 
    Open Cur_ For
      Select t.Contract, t.Location_No, t.Catalog_No
        From Bl_Cust_Forecast t
       Where t.Contract = Row_.Contract
         And t.Location_No = Row_.Location_No
         And t.Plan_Id = Row_.Plan_Id;
    Fetch Cur_
      Into Report_Temp_.Col00, Report_Temp_.Col01, Report_Temp_.Col02;
    Loop
      Exit When Cur_%Notfound;
      Report_Temp_.Row_Key := Report_Temp_.Col00 || '-' ||
                              Report_Temp_.Col01 || '-' ||
                              Report_Temp_.Col02;
      Report_Temp_.Col30   := Bl_Part_Api.Get_Ifsavehist(Report_Temp_.Col00);
    
      Modify_Report_Temp(Report_Temp_);
      Fetch Cur_
        Into Report_Temp_.Col00, Report_Temp_.Col01, Report_Temp_.Col02;
    End Loop;
    Close Cur_;
  
    --安全库存表的物料
    Open Cur_ For
      Select t.Contract, t.Location_No, t.Part_No
        From Bl_Location_No t
       Where t.Contract = Row_.Contract
         And t.Location_No = Row_.Location_No;
    Fetch Cur_
      Into Report_Temp_.Col00, Report_Temp_.Col01, Report_Temp_.Col02;
    Loop
      Exit When Cur_%Notfound;
      Report_Temp_.Row_Key := Report_Temp_.Col00 || '-' ||
                              Report_Temp_.Col01 || '-' ||
                              Report_Temp_.Col02;
      Report_Temp_.Col30   := Bl_Part_Api.Get_Ifsavehist(Report_Temp_.Col00);
      Modify_Report_Temp(Report_Temp_);
      Fetch Cur_
        Into Report_Temp_.Col00, Report_Temp_.Col01, Report_Temp_.Col02;
    End Loop;
    Close Cur_;
  
    Report_Row_.Date01 := Trunc(Sysdate, 'dd');
  
    --获取最大的预计提货日期
    Select Max(t.Need_Date)
      Into Report_Row_.Date03
      From Bl_Cust_Forecast_Detail t
     Inner Join Bl_Cust_Forecast T1
        On t.Forecast_No = T1.Forecast_No
       And T1.Contract = Row_.Contract
       And T1.Location_No = Row_.Location_No
       And T1.Plan_Id = Row_.Plan_Id;
    Report_Row_.Date03  := Nvl(Report_Row_.Date03, Report_Row_.Date01);
    Report_Row_.Row_Key := 'MRP';
    Open Cur_ For
      Select t.* From Bl_Report_Temp t;
    Fetch Cur_
      Into Report_Temp_;
    Loop
      Exit When Cur_%Notfound;
      Report_Row_.Col30 := Report_Temp_.Col30;
      --开始循环日期
      Report_Row_.Date02 := Report_Row_.Date01;
      Report_Row_.Col00  := Report_Temp_.Col00;
      Report_Row_.Col01  := Report_Temp_.Col01;
      Report_Row_.Col02  := Report_Temp_.Col02;
      Report_Row_.Col07  := '0'; --记录是否少于安全库存标示
      Report_Row_.Col08  := '0'; --记录是否大于上限库存标示
    
      Bl_Part_Api.Get_Part_Control_Qty(Report_Temp_.Col02,
                                       Report_Temp_.Col00,
                                       Report_Temp_.Col01,
                                       Report_Row_.Col05,
                                       Report_Row_.Col06);
      i_ := 0;
      Loop
        Exit When Report_Row_.Date02 > Report_Row_.Date03;
        If i_ = 0 Then
          Report_Row_.Num01 := Inventory_Part_In_Stock_Api.Get_Qty_Onhand_By_Location(Report_Temp_.Col02,
                                                                                      Report_Temp_.Col00,
                                                                                      Report_Temp_.Col01);
          --期初
        Else
          Report_Row_.Num01 := Report_Row_.Num04; --
        End If;
        --需求数量
        Report_Row_.Num02 := Get_Needqty(Report_Temp_.Col00,
                                         Report_Temp_.Col01,
                                         Report_Temp_.Col02,
                                         Report_Row_.Date02);
        --预计入库数量                                
        Report_Row_.Num03 := Get_Supplieqty(Report_Temp_.Col00,
                                            Report_Temp_.Col01,
                                            Report_Temp_.Col02,
                                            Report_Row_.Date02);
        --结余库存
        Report_Row_.Num04 := Nvl(Report_Row_.Num01, 0) -
                             Nvl(Report_Row_.Num02, 0) +
                             Nvl(Report_Row_.Num03, 0);
      
        Report_Row_.Num05 := Report_Row_.Num04 - Report_Row_.Col05;
        If Report_Row_.Num05 < 0 Then
          Report_Row_.Col07 := Report_Row_.Col07 + 1;
        End If;
      
        Report_Row_.Num06 := Report_Row_.Col06 - Report_Row_.Num04;
        If Report_Row_.Num06 < 0 Then
          Report_Row_.Col08 := Report_Row_.Col08 + 1;
        End If;
        Report_Row_.Enter_Date := Sysdate;
        Report_Row_.Enter_User := User_Id_;
        Report_Row_.Col31      := A311_Key_;
        Report_Row_.Col32      := Row_.Plan_Id;
        If Report_Row_.Num02 > 0 Or Report_Row_.Num03 > 0 Or
           Report_Row_.Col07 = 1 Or Report_Row_.Col08 = 1 Then
          Set_Bl_Report_(Report_Row_, Objid_);
        End If;
        --执行一条 提交 防止锁表
        Report_Row_.Date02 := Report_Row_.Date02 + 1;
        i_                 := i_ + 1;
      
      End Loop;
      Fetch Cur_
        Into Report_Temp_;
    End Loop;
    Close Cur_;
    --更新状态
    Update Bl_Cust_Forecast t
       Set t.State = '2'
     Where t.Plan_Id = Row_.Plan_Id;
  
    Update Bl_Cust_Forecast_Detail t
       Set t.State = '2'
     Where t.Forecast_No In
           (Select a.Forecast_No
              From Bl_Cust_Forecast a
             Where a.Plan_Id = Row_.Plan_Id);
  
    Update Bl_Location_Plan t
       Set t.State = '1', t.Modi_Date = Sysdate, t.Modi_User = User_Id_
     Where t.Plan_Id = Row_.Plan_Id;
  
  End;
  Procedure Proc_Report_01 Is
    Cur_         t_Cursor;
    Location_No_ Bl_Shippingperiod.Location_No%Type;
    Contract_    Bl_Shippingperiod.Contract%Type;
    Report_Temp_ Bl_Report_Temp%Rowtype;
    Report_Row_  Bl_Report%Rowtype;
    i_           Number;
    Objid_       Varchar2(50);
    Po_Hours_    Varchar2(10);
    A315_        A315%Rowtype;
    Exec_Key_    Number;
  Begin
    Return;
    Exec_Key_ := 2;
  
    Po_Hours_ := Nvl(Pkg_a.Get_A022_Name('PO_HOURS'), '2');
    Open Cur_ For
      Select t.*
        From A315 t
       Where t.A311_Key = Exec_Key_
         And t.State = '0';
    Fetch Cur_
      Into A315_;
    If Cur_%Notfound Then
      Pkg_a.Setnextdo(Exec_Key_,
                      '补货计划',
                      'System',
                      'Pkg_Report.Proc_Report_01',
                      To_Number(Po_Hours_) / 24);
    
    Else
      Update A315 t
         Set t.Do_Time    = Sysdate + To_Number(Po_Hours_) / 24,
             t.Enter_Date = Sysdate
       Where t.A315_Id = A315_.A315_Id;
    End If;
    Close Cur_;
    Commit;
    Reset_Sequence;
    Execute Immediate 'truncate table Bl_Report';
    --先运行补货单的数据
    Open Cur_ For
      Select Distinct t.Location_No, t.Contract From Bl_Shippingperiod t;
    Fetch Cur_
      Into Location_No_, Contract_;
    Loop
      Exit When Cur_%Notfound;
      Proc_Report(Location_No_, Contract_);
      Fetch Cur_
        Into Location_No_, Contract_;
    End Loop;
    Close Cur_;
  
    ---预计提货单的物料
    Open Cur_ For
      Select T1.Contract, T1.Location_No, T1.Catalog_No
        From Bl_Cust_Forecast_V01 T1;
    Fetch Cur_
      Into Report_Temp_.Col00, Report_Temp_.Col01, Report_Temp_.Col02;
    Loop
      Exit When Cur_%Notfound;
      Report_Temp_.Row_Key := Report_Temp_.Col00 || '-' ||
                              Report_Temp_.Col01 || '-' ||
                              Report_Temp_.Col02;
      Report_Temp_.Col30   := Bl_Part_Api.Get_Ifsavehist(Report_Temp_.Col00);
      Modify_Report_Temp(Report_Temp_);
      Fetch Cur_
        Into Report_Temp_.Col00, Report_Temp_.Col01, Report_Temp_.Col02;
    End Loop;
    Close Cur_;
    --安全库存表的物料
    Open Cur_ For
      Select t.Contract, t.Location_No, t.Part_No From Bl_Location_No t;
    Fetch Cur_
      Into Report_Temp_.Col00, Report_Temp_.Col01, Report_Temp_.Col02;
    Loop
      Exit When Cur_%Notfound;
      Report_Temp_.Row_Key := Report_Temp_.Col00 || '-' ||
                              Report_Temp_.Col01 || '-' ||
                              Report_Temp_.Col02;
      Report_Temp_.Col30   := Bl_Part_Api.Get_Ifsavehist(Report_Temp_.Col00);
      Modify_Report_Temp(Report_Temp_);
      Fetch Cur_
        Into Report_Temp_.Col00, Report_Temp_.Col01, Report_Temp_.Col02;
    End Loop;
  
    Close Cur_;
  
    --运算物料
  
    Report_Row_.Date01 := Trunc(Sysdate, 'dd');
    --获取最大的预计提货日期
    Select Max(t.Need_Date)
      Into Report_Row_.Date03
      From Bl_Cust_Forecast_Detail t
     Where t.State = '1';
    Report_Row_.Date03  := Nvl(Report_Row_.Date03, Report_Row_.Date01);
    Report_Row_.Row_Key := 'MRP';
    Open Cur_ For
      Select t.* From Bl_Report_Temp t;
    Fetch Cur_
      Into Report_Temp_;
    Loop
      Exit When Cur_%Notfound;
      Report_Row_.Col30 := Report_Temp_.Col30;
    
      --开始循环日期
      Report_Row_.Date02 := Report_Row_.Date01;
      Report_Row_.Col00  := Report_Temp_.Col00;
      Report_Row_.Col01  := Report_Temp_.Col01;
      Report_Row_.Col02  := Report_Temp_.Col02;
      Report_Row_.Col07  := '0'; --记录是否少于安全库存标示
      Report_Row_.Col08  := '0'; --记录是否大于上限库存标示
      Bl_Part_Api.Get_Part_Control_Qty(Report_Temp_.Col02,
                                       Report_Temp_.Col00,
                                       Report_Temp_.Col01,
                                       Report_Row_.Col05,
                                       Report_Row_.Col06);
      i_ := 0;
      Loop
        Exit When Report_Row_.Date02 > Report_Row_.Date03;
        If i_ = 0 Then
          Report_Row_.Num01 := Inventory_Part_In_Stock_Api.Get_Qty_Onhand_By_Location(Report_Temp_.Col02,
                                                                                      Report_Temp_.Col00,
                                                                                      Report_Temp_.Col01);
          --期初
        Else
          Report_Row_.Num01 := Report_Row_.Num04; --
        End If;
        --需求数量
        Report_Row_.Num02 := Get_Needqty(Report_Temp_.Col00,
                                         Report_Temp_.Col01,
                                         Report_Temp_.Col02,
                                         Report_Row_.Date02);
        --预计入库数量                                
        Report_Row_.Num03 := Get_Supplieqty(Report_Temp_.Col00,
                                            Report_Temp_.Col01,
                                            Report_Temp_.Col02,
                                            Report_Row_.Date02);
        --结余库存
        Report_Row_.Num04 := Nvl(Report_Row_.Num01, 0) -
                             Nvl(Report_Row_.Num02, 0) +
                             Nvl(Report_Row_.Num03, 0);
      
        Report_Row_.Num05 := Report_Row_.Num04 - Report_Row_.Col05;
        If Report_Row_.Num05 < 0 Then
          Report_Row_.Col07 := Report_Row_.Col07 + 1;
        End If;
      
        Report_Row_.Num06 := Report_Row_.Col06 - Report_Row_.Num04;
        If Report_Row_.Num06 < 0 Then
          Report_Row_.Col08 := Report_Row_.Col08 + 1;
        End If;
        Report_Row_.Enter_Date := Sysdate;
        Report_Row_.Enter_User := 'System';
        Set_Bl_Report_(Report_Row_, Objid_);
        Report_Row_.Date02 := Report_Row_.Date02 + 1;
        i_                 := i_ + 1;
      End Loop;
      Fetch Cur_
        Into Report_Temp_;
    End Loop;
    Close Cur_;
    Commit;
    Update Bl_Cust_Forecast t Set t.State = '2' Where t.State = '1';
  
    Update Bl_Cust_Forecast_Detail t Set t.State = '2' Where t.State = '1';
  
    --运行物料数据
    Commit;
    Save_Report_Hist;
  End;
  --获取库存件的信息
  Function Get_Type_Designation(Contract_ In Varchar, Part_No_ In Varchar2)
    Return Varchar2 Is
    Result_ Varchar2(1000);
    Cur_    t_Cursor;
  Begin
    Open Cur_ For
      Select t.Type_Designation
        From Inventory_Part t
       Where t.Contract = Contract_
         And t.Part_No = Part_No_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  End;
  Function Get_Po_Identifier(Order_No_     In Varchar2,
                             Line_No_      In Varchar2,
                             Rel_No_       In Varchar2,
                             Line_Item_No_ In Number) Return Varchar2 Is
  
    Result_ Varchar2(1000);
    Cur_    t_Cursor;
  Begin
    Open Cur_ For
      Select t.Po_Identifier
        From Bl_Customer_Order_Line t
       Where t.Order_No = Order_No_
         And t.Line_No = Line_No_
         And t.Rel_No = Rel_No_
         And t.Line_Item_No = Line_Item_No_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  End;

  Function Get_Express_Id_(Picklist_No_ In Varchar2,
                           Column_Id_   In Varchar2) Return Varchar2 Is
    Result_ Number;
    Cur_    t_Cursor;
    Sql_    Varchar2(4000);
  Begin
    Sql_ := 'Select t.' || Column_Id_ || '
        From BL_V_TRANSPORT_NOTEC  t
       Where t.picklistno = ''' || Picklist_No_ || '''';
    Open Cur_ For Sql_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  Exception
    When Others Then
      Return Null;
    
  End;
  Function Get_Customer_Order_Info_(Order_No_  In Varchar2,
                                    Column_Id_ In Varchar2) Return Varchar2 Is
    Result_ Varchar2(1000);
    Cur_    t_Cursor;
    Sql_    Varchar2(4000);
  Begin
    Sql_ := 'Select t.' || Column_Id_ || '
        From BL_V_CUSTOMER_ORDER  t
       Where t.Order_No = ''' || Order_No_ || '''';
    Open Cur_ For Sql_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  Exception
    When Others Then
      Return Null;
  End;
  Function Get_Order_Info(Order_No_     In Varchar2,
                          Line_No_      In Varchar2,
                          Rel_No_       In Varchar2,
                          Line_Item_No_ In Number,
                          Column_Id_    In Varchar2) Return Varchar2 Is
    Result_ Varchar2(1000);
    Cur_    t_Cursor;
    Sql_    Varchar2(4000);
  Begin
    Sql_ := 'Select t.' || Column_Id_ || '
        From bl_v_Customer_Order_Line  t
       Where t.Order_No = ''' || Order_No_ || '''
         And t.Line_No = ''' || Line_No_ || '''
         And t.Rel_No = ''' || Rel_No_ || '''
         And t.Line_Item_No = ' || To_Char(Line_Item_No_);
    Open Cur_ For Sql_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  Exception
    When Others Then
      Return Null;
    
  End;
  Function Get_Bookinglist_Info(Picklistno_ In Varchar2,
                                Column_Id_  In Varchar2,
                                Col_        In Varchar2) Return Varchar2 Is
    Result_ Varchar2(1000);
    Cur_    t_Cursor;
    Sql_    Varchar2(4000);
  Begin
    Sql_ := 'Select t.' || Column_Id_ || '
        From BL_V_BOOKINGLIST_LIST  t
       Where t.picklistno = ''' || Picklistno_ || '''
       and   t.state in  (''1'',''2'',''4'')';
    Open Cur_ For Sql_;
    Fetch Cur_
      Into Result_;
    If Cur_%Notfound Then
      Close Cur_;
      Return Col_;
    End If;
    Close Cur_;
    Return Result_;
  Exception
    When Others Then
      Return Null;
    
  End;

  Function Get_Bookinglist_Info1(Picklistno_ In Varchar2,
                                 Column_Id_  In Varchar2) Return Varchar2 Is
    Result_ Varchar2(1000);
    Cur_    t_Cursor;
    Sql_    Varchar2(4000);
  Begin
    Sql_ := 'Select t.' || Column_Id_ || '
        From BL_V_BOOKINGLIST_LIST  t
       Where t.picklistno = ''' || Picklistno_ || '''
       and   t.state in  (''1'',''2'',''4'')';
    Open Cur_ For Sql_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  Exception
    When Others Then
      Return Null;
    
  End;

  Function Get_Pltrans_Info(Picklistno_ In Varchar2,
                            Column_Id_  In Varchar2) Return Varchar2 Is
    Result_ Varchar2(1000);
    Cur_    t_Cursor;
    Sql_    Varchar2(4000);
  Begin
    Sql_ := 'Select t.' || Column_Id_ || '
        From BL_PLTRANS  t
       Where t.picklistno = ''' || Picklistno_ || '''';
    Open Cur_ For Sql_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  Exception
    When Others Then
      Return Null;
    
  End;

  Function Get_Picklist_Info(Picklistno_ In Varchar2,
                             Column_Id_  In Varchar2) Return Varchar2 Is
    Result_ Varchar2(1000);
    Cur_    t_Cursor;
    Sql_    Varchar2(4000);
  Begin
    Sql_ := 'Select t.' || Column_Id_ || '
        From BL_V_BL_PICKLIST_SUP  t
       Where t.picklistno = ''' || Picklistno_ || '''
       and   t.state in  (''1'')';
    Open Cur_ For Sql_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  Exception
    When Others Then
      Return Null;
    
  End;

  Function Get_Customer_Part_No_(Order_No_     In Varchar2,
                                 Line_No_      In Varchar2,
                                 Rel_No_       In Varchar2,
                                 Line_Item_No_ In Number) Return Varchar2 Is
    Result_ Varchar2(1000);
    Cur_    t_Cursor;
  Begin
    Open Cur_ For
      Select t.Customer_Part_No
        From Customer_Order_Line_Tab t
       Where t.Order_No = Order_No_
         And t.Line_No = Line_No_
         And t.Rel_No = Rel_No_
         And t.Line_Item_No = Line_Item_No_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  End;
  --获取包装资料基本数据  2012-03-26
  Function Get_Packing_Base(Picklistno_  In Varchar2,
                            Packing_Tag_ In Varchar2) Return Number As
    n_Number Number;
  
  Begin
  
    If Packing_Tag_ = 'GWEIGHT' Then
      Select Sum(Nvl(a.n_Weight, 0)) + Sum(Nvl(b.t_Weight, 0))
        Into n_Number
        From (Select Picklistno
                From Bl_Putincase
               Where Picklistno = Picklistno_
               Group By Picklistno) t,
             (Select T3.Picklistno,
                     Count(T3.Picklistno) * T3.n_Weight n_Weight
                From (Select T1.Picklistno,
                             T1.Casesid,
                             T2.Everycasesid,
                             (T1.Signcaseweight + T1.Signweight) n_Weight
                        From Bl_Putincase T1, Bl_Onecase T2
                       Where T1.Picklistno = T2.Picklistno
                         And T1.Casesid = T2.Casesid
                         And T2.Trayid Is Null
                         And T1.Picklistno = Picklistno_
                       Group By T1.Picklistno,
                                T1.Casesid,
                                T2.Everycasesid,
                                T1.Signcaseweight,
                                T1.Signweight) T3
               Group By T3.Picklistno, T3.n_Weight) a,
             (Select B3.Picklistno, Sum(B3.t_Weight) t_Weight
                From (Select B2.Picklistno,
                             B2.Nweight + B2.Cweight + B2.Signtrayweight t_Weight
                        From Bl_Onecase B1, Bl_Putintray B2
                       Where B1.Picklistno = B2.Picklistno
                         And B1.Trayid = B2.Trayid
                         And B1.Picklistno = Picklistno_
                       Group By B2.Picklistno,
                                B2.Trayid,
                                B2.Nweight,
                                B2.Cweight,
                                B2.Signtrayweight) B3
               Group By B3.Picklistno) b
       Where t.Picklistno = a.Picklistno(+)
         And t.Picklistno = b.Picklistno(+)
       Group By t.Picklistno;
    Elsif Packing_Tag_ = 'NWEIGHT' Then
      Select Sum(Signweight * Allcases)
        Into n_Number
        From Bl_Putincase
       Where Picklistno = Picklistno_
       Group By Picklistno;
    Elsif Packing_Tag_ = 'CWEIGHT' Then
      Select Sum(Signcaseweight * Allcases)
        Into n_Number
        From Bl_Putincase
       Where Picklistno = Picklistno_
       Group By Picklistno;
    Elsif Packing_Tag_ = 'VOLUME' Then
      n_Number := 0;
    Elsif Packing_Tag_ = 'BOXNUM' Then
      Select Count(Picklistno)
        Into n_Number
        From (Select t.Picklistno, t.Casesid, t.Everycasesid
                From Bl_Onecase t
               Where t.Picklistno = Picklistno_
               Group By t.Picklistno, t.Casesid, t.Everycasesid)
       Group By Picklistno;
    Else
      n_Number := 0;
    End If;
    Return(n_Number);
  End Get_Packing_Base;

  Function Get_Supplieqty(Contract_    In Varchar,
                          Location_No_ In Varchar2,
                          Catalog_No_  In Varchar2,
                          Date_        In Date) Return Number Is
    Result_ Number;
    Cur_    t_Cursor;
  Begin
    Open Cur_ For
      Select Sum(t.Qty)
        From Bl_Report_V01 t
       Where t.Contract = Contract_ --域 
         And t.Location_No = Location_No_ --入库库位
         And t.Part_No = Catalog_No_ --产品编码
         And t.Date_Arrive = Date_; --日期
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Nvl(Result_, 0);
  End;
  --获取需求数量
  Function Get_Needqty(Contract_    In Varchar,
                       Location_No_ In Varchar2,
                       Catalog_No_  In Varchar2,
                       Date_        In Date) Return Number Is
    Result_ Number;
    Cur_    t_Cursor;
  Begin
    Open Cur_ For
      Select Sum(t.Qty)
        From Bl_Cust_Forecast_Detail t
       Inner Join Bl_Cust_Forecast_V01 T1
          On T1.Forecast_No = t.Forecast_No
         And T1.Location_No = Location_No_
         And T1.Contract = Contract_
         And T1.Catalog_No = Catalog_No_
       Where t.Need_Date = Date_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Nvl(Result_, 0);
  End;
  Procedure Set_Bl_Report_(Report_Row_ In Out Bl_Report%Rowtype,
                           Objid_      Out Varchar2) Is
  Begin
    Select s_Bl_Report.Nextval Into Report_Row_.Reportid From Dual;
    Insert Into Bl_Report
      (Reportid,
       Row_Key,
       Col00,
       Col01,
       Col02,
       Col03,
       Col04,
       Col05,
       Col06,
       Col07,
       Col08,
       Col09,
       Col10,
       Col11,
       Col12,
       Col13,
       Col14,
       Col15,
       Col16,
       Col17,
       Col18,
       Col19,
       Col20,
       Col21,
       Col22,
       Col23,
       Col24,
       Col25,
       Col26,
       Col27,
       Col28,
       Col29,
       Col30,
       Col31,
       Col32,
       Col33,
       Col34,
       Col35,
       Col36,
       Col37,
       Col38,
       Col39,
       Col40,
       Col41,
       Col42,
       Col43,
       Col44,
       Col45,
       Col46,
       Col47,
       Col48,
       Col49,
       Col50,
       Col51,
       Col52,
       Col53,
       Col54,
       Col55,
       Col56,
       Col57,
       Col58,
       Col59,
       Col60,
       Col61,
       Col62,
       Col63,
       Col64,
       Col65,
       Col66,
       Col67,
       Col68,
       Col69,
       Col70,
       Col71,
       Col72,
       Col73,
       Col74,
       Col75,
       Col76,
       Col77,
       Col78,
       Col79,
       Col80,
       Col81,
       Col82,
       Col83,
       Col84,
       Col85,
       Col86,
       Col87,
       Col88,
       Col89,
       Col90,
       Col91,
       Col92,
       Col93,
       Col94,
       Col95,
       Col96,
       Col97,
       Col98,
       Col99,
       Num01,
       Num02,
       Num03,
       Num04,
       Num05,
       Num06,
       Num07,
       Num08,
       Num09,
       Num10,
       Date01,
       Date02,
       Date03,
       Date04,
       Date05,
       Date06,
       Date07,
       Date08,
       Date09,
       Date10,
       Date11,
       Date12,
       Date13,
       Date14,
       Date15,
       Date16,
       Date17,
       Date18,
       Date19,
       Date20,
       Enter_Date,
       Enter_User,
       Modi_Date,
       Modi_User) /*nologging*/
    Values
      (Report_Row_.Reportid,
       Report_Row_.Row_Key,
       Report_Row_.Col00,
       Report_Row_.Col01,
       Report_Row_.Col02,
       Report_Row_.Col03,
       Report_Row_.Col04,
       Report_Row_.Col05,
       Report_Row_.Col06,
       Report_Row_.Col07,
       Report_Row_.Col08,
       Report_Row_.Col09,
       Report_Row_.Col10,
       Report_Row_.Col11,
       Report_Row_.Col12,
       Report_Row_.Col13,
       Report_Row_.Col14,
       Report_Row_.Col15,
       Report_Row_.Col16,
       Report_Row_.Col17,
       Report_Row_.Col18,
       Report_Row_.Col19,
       Report_Row_.Col20,
       Report_Row_.Col21,
       Report_Row_.Col22,
       Report_Row_.Col23,
       Report_Row_.Col24,
       Report_Row_.Col25,
       Report_Row_.Col26,
       Report_Row_.Col27,
       Report_Row_.Col28,
       Report_Row_.Col29,
       Report_Row_.Col30,
       Report_Row_.Col31,
       Report_Row_.Col32,
       Report_Row_.Col33,
       Report_Row_.Col34,
       Report_Row_.Col35,
       Report_Row_.Col36,
       Report_Row_.Col37,
       Report_Row_.Col38,
       Report_Row_.Col39,
       Report_Row_.Col40,
       Report_Row_.Col41,
       Report_Row_.Col42,
       Report_Row_.Col43,
       Report_Row_.Col44,
       Report_Row_.Col45,
       Report_Row_.Col46,
       Report_Row_.Col47,
       Report_Row_.Col48,
       Report_Row_.Col49,
       Report_Row_.Col50,
       Report_Row_.Col51,
       Report_Row_.Col52,
       Report_Row_.Col53,
       Report_Row_.Col54,
       Report_Row_.Col55,
       Report_Row_.Col56,
       Report_Row_.Col57,
       Report_Row_.Col58,
       Report_Row_.Col59,
       Report_Row_.Col60,
       Report_Row_.Col61,
       Report_Row_.Col62,
       Report_Row_.Col63,
       Report_Row_.Col64,
       Report_Row_.Col65,
       Report_Row_.Col66,
       Report_Row_.Col67,
       Report_Row_.Col68,
       Report_Row_.Col69,
       Report_Row_.Col70,
       Report_Row_.Col71,
       Report_Row_.Col72,
       Report_Row_.Col73,
       Report_Row_.Col74,
       Report_Row_.Col75,
       Report_Row_.Col76,
       Report_Row_.Col77,
       Report_Row_.Col78,
       Report_Row_.Col79,
       Report_Row_.Col80,
       Report_Row_.Col81,
       Report_Row_.Col82,
       Report_Row_.Col83,
       Report_Row_.Col84,
       Report_Row_.Col85,
       Report_Row_.Col86,
       Report_Row_.Col87,
       Report_Row_.Col88,
       Report_Row_.Col89,
       Report_Row_.Col90,
       Report_Row_.Col91,
       Report_Row_.Col92,
       Report_Row_.Col93,
       Report_Row_.Col94,
       Report_Row_.Col95,
       Report_Row_.Col96,
       Report_Row_.Col97,
       Report_Row_.Col98,
       Report_Row_.Col99,
       Report_Row_.Num01,
       Report_Row_.Num02,
       Report_Row_.Num03,
       Report_Row_.Num04,
       Report_Row_.Num05,
       Report_Row_.Num06,
       Report_Row_.Num07,
       Report_Row_.Num08,
       Report_Row_.Num09,
       Report_Row_.Num10,
       Report_Row_.Date01,
       Report_Row_.Date02,
       Report_Row_.Date03,
       Report_Row_.Date04,
       Report_Row_.Date05,
       Report_Row_.Date06,
       Report_Row_.Date07,
       Report_Row_.Date08,
       Report_Row_.Date09,
       Report_Row_.Date10,
       Report_Row_.Date11,
       Report_Row_.Date12,
       Report_Row_.Date13,
       Report_Row_.Date14,
       Report_Row_.Date15,
       Report_Row_.Date16,
       Report_Row_.Date17,
       Report_Row_.Date18,
       Report_Row_.Date19,
       Report_Row_.Date20,
       Report_Row_.Enter_Date,
       Report_Row_.Enter_User,
       Report_Row_.Modi_Date,
       Report_Row_.Modi_User)
    Returning Rowid Into Objid_;
  End;

  Procedure Set_Bl_Report_Temp(Report_Row_ In Out Bl_Report_Temp%Rowtype,
                               Objid_      Out Varchar2) Is
  Begin
    Select s_Bl_Report.Nextval Into Report_Row_.Reportid From Dual;
    Insert Into Bl_Report_Temp
      (Reportid,
       Row_Key,
       Col00,
       Col01,
       Col02,
       Col03,
       Col04,
       Col05,
       Col06,
       Col07,
       Col08,
       Col09,
       Col10,
       Col11,
       Col12,
       Col13,
       Col14,
       Col15,
       Col16,
       Col17,
       Col18,
       Col19,
       Col20,
       Col21,
       Col22,
       Col23,
       Col24,
       Col25,
       Col26,
       Col27,
       Col28,
       Col29,
       Col30,
       Col31,
       Col32,
       Col33,
       Col34,
       Col35,
       Col36,
       Col37,
       Col38,
       Col39,
       Col40,
       Col41,
       Col42,
       Col43,
       Col44,
       Col45,
       Col46,
       Col47,
       Col48,
       Col49,
       Col50,
       Col51,
       Col52,
       Col53,
       Col54,
       Col55,
       Col56,
       Col57,
       Col58,
       Col59,
       Col60,
       Col61,
       Col62,
       Col63,
       Col64,
       Col65,
       Col66,
       Col67,
       Col68,
       Col69,
       Col70,
       Col71,
       Col72,
       Col73,
       Col74,
       Col75,
       Col76,
       Col77,
       Col78,
       Col79,
       Col80,
       Col81,
       Col82,
       Col83,
       Col84,
       Col85,
       Col86,
       Col87,
       Col88,
       Col89,
       Col90,
       Col91,
       Col92,
       Col93,
       Col94,
       Col95,
       Col96,
       Col97,
       Col98,
       Col99,
       Num01,
       Num02,
       Num03,
       Num04,
       Num05,
       Num06,
       Num07,
       Num08,
       Num09,
       Num10,
       Date01,
       Date02,
       Date03,
       Date04,
       Date05,
       Date06,
       Date07,
       Date08,
       Date09,
       Date10,
       Date11,
       Date12,
       Date13,
       Date14,
       Date15,
       Date16,
       Date17,
       Date18,
       Date19,
       Date20,
       Enter_Date,
       Enter_User,
       Modi_Date,
       Modi_User) /*nologging*/
    Values
      (Report_Row_.Reportid,
       Report_Row_.Row_Key,
       Report_Row_.Col00,
       Report_Row_.Col01,
       Report_Row_.Col02,
       Report_Row_.Col03,
       Report_Row_.Col04,
       Report_Row_.Col05,
       Report_Row_.Col06,
       Report_Row_.Col07,
       Report_Row_.Col08,
       Report_Row_.Col09,
       Report_Row_.Col10,
       Report_Row_.Col11,
       Report_Row_.Col12,
       Report_Row_.Col13,
       Report_Row_.Col14,
       Report_Row_.Col15,
       Report_Row_.Col16,
       Report_Row_.Col17,
       Report_Row_.Col18,
       Report_Row_.Col19,
       Report_Row_.Col20,
       Report_Row_.Col21,
       Report_Row_.Col22,
       Report_Row_.Col23,
       Report_Row_.Col24,
       Report_Row_.Col25,
       Report_Row_.Col26,
       Report_Row_.Col27,
       Report_Row_.Col28,
       Report_Row_.Col29,
       Report_Row_.Col30,
       Report_Row_.Col31,
       Report_Row_.Col32,
       Report_Row_.Col33,
       Report_Row_.Col34,
       Report_Row_.Col35,
       Report_Row_.Col36,
       Report_Row_.Col37,
       Report_Row_.Col38,
       Report_Row_.Col39,
       Report_Row_.Col40,
       Report_Row_.Col41,
       Report_Row_.Col42,
       Report_Row_.Col43,
       Report_Row_.Col44,
       Report_Row_.Col45,
       Report_Row_.Col46,
       Report_Row_.Col47,
       Report_Row_.Col48,
       Report_Row_.Col49,
       Report_Row_.Col50,
       Report_Row_.Col51,
       Report_Row_.Col52,
       Report_Row_.Col53,
       Report_Row_.Col54,
       Report_Row_.Col55,
       Report_Row_.Col56,
       Report_Row_.Col57,
       Report_Row_.Col58,
       Report_Row_.Col59,
       Report_Row_.Col60,
       Report_Row_.Col61,
       Report_Row_.Col62,
       Report_Row_.Col63,
       Report_Row_.Col64,
       Report_Row_.Col65,
       Report_Row_.Col66,
       Report_Row_.Col67,
       Report_Row_.Col68,
       Report_Row_.Col69,
       Report_Row_.Col70,
       Report_Row_.Col71,
       Report_Row_.Col72,
       Report_Row_.Col73,
       Report_Row_.Col74,
       Report_Row_.Col75,
       Report_Row_.Col76,
       Report_Row_.Col77,
       Report_Row_.Col78,
       Report_Row_.Col79,
       Report_Row_.Col80,
       Report_Row_.Col81,
       Report_Row_.Col82,
       Report_Row_.Col83,
       Report_Row_.Col84,
       Report_Row_.Col85,
       Report_Row_.Col86,
       Report_Row_.Col87,
       Report_Row_.Col88,
       Report_Row_.Col89,
       Report_Row_.Col90,
       Report_Row_.Col91,
       Report_Row_.Col92,
       Report_Row_.Col93,
       Report_Row_.Col94,
       Report_Row_.Col95,
       Report_Row_.Col96,
       Report_Row_.Col97,
       Report_Row_.Col98,
       Report_Row_.Col99,
       Report_Row_.Num01,
       Report_Row_.Num02,
       Report_Row_.Num03,
       Report_Row_.Num04,
       Report_Row_.Num05,
       Report_Row_.Num06,
       Report_Row_.Num07,
       Report_Row_.Num08,
       Report_Row_.Num09,
       Report_Row_.Num10,
       Report_Row_.Date01,
       Report_Row_.Date02,
       Report_Row_.Date03,
       Report_Row_.Date04,
       Report_Row_.Date05,
       Report_Row_.Date06,
       Report_Row_.Date07,
       Report_Row_.Date08,
       Report_Row_.Date09,
       Report_Row_.Date10,
       Report_Row_.Date11,
       Report_Row_.Date12,
       Report_Row_.Date13,
       Report_Row_.Date14,
       Report_Row_.Date15,
       Report_Row_.Date16,
       Report_Row_.Date17,
       Report_Row_.Date18,
       Report_Row_.Date19,
       Report_Row_.Date20,
       Report_Row_.Enter_Date,
       Report_Row_.Enter_User,
       Report_Row_.Modi_Date,
       Report_Row_.Modi_User)
    Returning Rowid Into Objid_;
  End;
  Procedure Save_Report_Hist Is
    Enter_Date_  Date;
    Enter_Date__ Date;
    Cur_         t_Cursor;
    Week_        Varchar2(10);
  Begin
    Enter_Date_ := Trunc(Sysdate, 'dd');
    Week_       := To_Char(Sysdate, 'd');
    If Week_ <> '5' Then
      Return;
    End If;
  
    --判断是否是星期二 
    Open Cur_ For
      Select t.Enter_Date
        From Bl_Report_Hist t
       Where t.Modi_Date = Enter_Date_;
    Fetch Cur_
      Into Enter_Date__;
    If Cur_%Found Then
      Close Cur_;
      Return;
    End If;
    Close Cur_;
  
    Insert Into Bl_Report_Hist /*nologging*/
      (Reportid,
       Row_Key,
       Col00,
       Col01,
       Col02,
       Col03,
       Col04,
       Col05,
       Col06,
       Col07,
       Col08,
       Col09,
       Col10,
       Col11,
       Col12,
       Col13,
       Col14,
       Col15,
       Col16,
       Col17,
       Col18,
       Col19,
       Col20,
       Col21,
       Col22,
       Col23,
       Col24,
       Col25,
       Col26,
       Col27,
       Col28,
       Col29,
       Col30,
       Col31,
       Col32,
       Col33,
       Col34,
       Col35,
       Col36,
       Col37,
       Col38,
       Col39,
       Col40,
       Col41,
       Col42,
       Col43,
       Col44,
       Col45,
       Col46,
       Col47,
       Col48,
       Col49,
       Col50,
       Col51,
       Col52,
       Col53,
       Col54,
       Col55,
       Col56,
       Col57,
       Col58,
       Col59,
       Col60,
       Col61,
       Col62,
       Col63,
       Col64,
       Col65,
       Col66,
       Col67,
       Col68,
       Col69,
       Col70,
       Col71,
       Col72,
       Col73,
       Col74,
       Col75,
       Col76,
       Col77,
       Col78,
       Col79,
       Col80,
       Col81,
       Col82,
       Col83,
       Col84,
       Col85,
       Col86,
       Col87,
       Col88,
       Col89,
       Col90,
       Col91,
       Col92,
       Col93,
       Col94,
       Col95,
       Col96,
       Col97,
       Col98,
       Col99,
       Num01,
       Num02,
       Num03,
       Num04,
       Num05,
       Num06,
       Num07,
       Num08,
       Num09,
       Num10,
       Date01,
       Date02,
       Date03,
       Date04,
       Date05,
       Date06,
       Date07,
       Date08,
       Date09,
       Date10,
       Date11,
       Date12,
       Date13,
       Date14,
       Date15,
       Date16,
       Date17,
       Date18,
       Date19,
       Date20,
       Enter_Date,
       Enter_User,
       Modi_Date,
       Modi_User)
      Select Reportid,
             Row_Key,
             Col00,
             Col01,
             Col02,
             Col03,
             Col04,
             Col05,
             Col06,
             Col07,
             Col08,
             Col09,
             Col10,
             Col11,
             Col12,
             Col13,
             Col14,
             Col15,
             Col16,
             Col17,
             Col18,
             Col19,
             Col20,
             Col21,
             Col22,
             Col23,
             Col24,
             Col25,
             Col26,
             Col27,
             Col28,
             Col29,
             Col30,
             Col31,
             Col32,
             Col33,
             Col34,
             Col35,
             Col36,
             Col37,
             Col38,
             Col39,
             Col40,
             Col41,
             Col42,
             Col43,
             Col44,
             Col45,
             Col46,
             Col47,
             Col48,
             Col49,
             Col50,
             Col51,
             Col52,
             Col53,
             Col54,
             Col55,
             Col56,
             Col57,
             Col58,
             Col59,
             Col60,
             Col61,
             Col62,
             Col63,
             Col64,
             Col65,
             Col66,
             Col67,
             Col68,
             Col69,
             Col70,
             Col71,
             Col72,
             Col73,
             Col74,
             Col75,
             Col76,
             Col77,
             Col78,
             Col79,
             Col80,
             Col81,
             Col82,
             Col83,
             Col84,
             Col85,
             Col86,
             Col87,
             Col88,
             Col89,
             Col90,
             Col91,
             Col92,
             Col93,
             Col94,
             Col95,
             Col96,
             Col97,
             Col98,
             Col99,
             Num01,
             Num02,
             Num03,
             Num04,
             Num05,
             Num06,
             Num07,
             Num08,
             Num09,
             Num10,
             Date01,
             Date02,
             Date03,
             Date04,
             Date05,
             Date06,
             Date07,
             Date08,
             Date09,
             Date10,
             Date11,
             Date12,
             Date13,
             Date14,
             Date15,
             Date16,
             Date17,
             Date18,
             Date19,
             Date20,
             Enter_Date,
             Enter_User,
             Enter_Date_,
             To_Char(Enter_Date_, 'YYYYMMDD')
        From Bl_Report t
       Where t.Row_Key = 'MRP'
         And t.Col30 = '1';
  End;
  Procedure Reset_Sequence Is
    Num_ Number;
  Begin
    Select s_Bl_Report.Nextval Into Num_ From Dual;
    Num_ := Num_ - 1;
    If Num_ > 10000000000 Then
      Num_ := Num_ - 1000000000;
      Execute Immediate 'alter sequence S_BL_REPORT increment by -' ||
                        To_Char(Num_) || ' nocache';
      Select s_Bl_Report.Nextval Into Num_ From Dual;
      Execute Immediate 'alter sequence S_BL_REPORT increment by 1 cache 20';
    End If;
  End;
  Function Getnumericalvalue2(v_Amount In Number) Return Varchar2 As
    v_Enamount Nvarchar2(200);
    v_Million  Int;
    v_Thousand Int;
    v_Hundred  Int;
    v_Point    Int;
    Hundreds   Int;
    Tenth      Int;
    One        Int;
    v_i        Int;
    v_l        Int;
    v_j        Int;
    v_m        Int;
  
    Innresult Nvarchar2(100);
    v_s       Nvarchar2(13);
    Numbers   Nvarchar2(300);
  Begin
    v_l     := Length(v_Amount);
    v_Point := 0;
    If v_l < 13 Then
      Numbers := 'ONE       TWO       THREE     FOUR      FIVE      ' ||
                 'SIX       SEVEN     EIGHT     NINE      TEN       ' ||
                 'ELEVEN    TWELVE    THIRTEEN  FOURTEEN  FIFTEEN   ' ||
                 'SIXTEEN   SEVENTEEN EIGHTEEN  NINETEEN  ' ||
                 'TWENTY    THIRTY    FORTY     FIFTY     ' ||
                 'SIXTY     SEVENTY   EIGHTY    NINETY    ';
      -- to_char(123.9, '000000000.00')  转换         
      v_s := To_Char(v_Amount);
      If Instr(v_s, '.') = 0 Then
        -- begin
        v_s := Substr('000000000000' || v_s || '.00', -12, 12);
        -- end; 
      Else
        v_s := Substr('000000000000' || v_s, -12, 12);
      End If;
      If Instr(v_s, '.') = 11 Then
        v_s := Substr(v_s || '0', -12, 12);
      End If;
      v_Point := To_Number(Substr(v_s, 11, 2));
      --取分
      v_Enamount := '';
      --------------------------begin------------------------------------
      ----小数部分
      If v_Point > 0 Then
        --小数部分-------and 标示
      
        Tenth := To_Number(Substr(v_s, 11, 1));
        One   := To_Number(Substr(v_s, 12, 1)); --个位
        If Tenth = 1 Then
          v_j := 10;
          v_m := 0;
        Else
          v_j := 0;
          v_m := Tenth;
        End If;
        Tenth := v_m; ----、2-9小数点位
        One   := v_j + One; --个位0-19小数点位
        If Tenth = 0 Then
          Innresult := Rtrim(Substr(Numbers, One * 10 - 9, 10));
        Elsif Tenth > 0 And One > 0 Then
          Innresult := Rtrim(Substr(Numbers, Tenth * 10 + 171, 10)) || ' ' ||
                       Rtrim(Substr(Numbers, One * 10 - 9, 10));
        Else
          Innresult := Rtrim(Substr(Numbers, Tenth * 10 + 171, 10));
        End If;
        v_Enamount := ' CENTS ' || Innresult || ' ONLY';
      Else
        v_Enamount := ' ONLY';
      End If;
      ----------------------------------------------------end小数部分--------
    
      ---------------将9位整数分成4段：亿、百万、、百十个---------------------
      v_Million  := To_Number(Substr(v_s, 1, 3)); --million百万
      v_Thousand := To_Number(Substr(v_s, 4, 3)); --thousand千 
      v_Hundred  := To_Number(Substr(v_s, 7, 3)); ---百十个
      v_i        := 3;
    
      Loop
        Exit When v_i = 0;
      
        If (v_i = 3 And v_Hundred > 0) Or (v_i = 2 And v_Thousand > 0) Or
           (v_i = 1 And v_Million > 0) Then
          Begin
          
            Hundreds := To_Number(Substr(v_s, (v_i - 1) * 3 + 1, 1)); --百位0-9
            Tenth    := To_Number(Substr(v_s, (v_i - 1) * 3 + 2, 1)); --十位
            One      := To_Number(Substr(v_s, (v_i - 1) * 3 + 3, 1)); --个位0-19
            If Tenth = 1 Then
              v_j := 10;
              v_m := 0;
            Else
              v_j := 0;
              v_m := Tenth;
            End If;
            One       := v_j + One; --个位0-19
            Tenth     := v_m; ----、2-9十位
            Innresult := '';
            If Tenth = 0 And One > 0 Then
              Innresult := Rtrim(Substr(Numbers, One * 10 - 9, 10));
            Elsif Tenth > 0 And One > 0 Then
              Innresult := Rtrim(Substr(Numbers, Tenth * 10 + 171, 10)) || ' ' ||
                           Rtrim(Substr(Numbers, One * 10 - 9, 10));
            Elsif Tenth > 0 And One = 0 Then
              Innresult := Rtrim(Substr(Numbers, Tenth * 10 + 171, 10));
            Else
              Innresult := '';
            End If;
          
            --个位部分-------and 标示
          
            Innresult := Innresult;
          
            If Hundreds > 0 And One = 0 And Tenth = 0 And v_Point > 0 And
               v_i = 3 Then
              Innresult := Rtrim(Substr(Numbers, Hundreds * 10 - 9, 10)) ||
                           ' HUNDRED AND ' || Innresult;
            Else
              If Hundreds > 0 And One = 0 And Tenth = 0 Then
                Innresult := Rtrim(Substr(Numbers, Hundreds * 10 - 9, 10)) ||
                             ' HUNDRED ' || Innresult;
              Else
                If Hundreds > 0 And (Tenth > 0 Or One > 0) Then
                  Innresult := Rtrim(Substr(Numbers, Hundreds * 10 - 9, 10)) ||
                               ' HUNDRED AND ' || Innresult;
                Else
                  If Hundreds > 0 Then
                    Innresult := Rtrim(Substr(Numbers,
                                              Hundreds * 10 - 9,
                                              10)) || ' HUNDRED ' ||
                                 Innresult;
                  End If;
                End If;
              End If;
            End If;
          
            --百位部分-------and 标示
            Innresult := Innresult;
          
            Case v_i
              When 3 Then
                v_Enamount := Innresult || v_Enamount;
              When 2 Then
                v_Enamount := Innresult || ' THOUSAND ' || v_Enamount;
              When 1 Then
                v_Enamount := Innresult || ' MILLION ' || v_Enamount;
              Else
                v_Enamount := 'Error';
            End Case;
          End;
        End If;
        v_i := v_i - 1;
      End Loop;
    
      -- if flag = true then
      Return(v_Enamount);
      --else
      -- return('amount is zero');
      -- end if;
    Else
      Return('amount is more then one billion or zero');
    End If;
  
  Exception
    When Others Then
      Return 'ERROR:' || To_Char(v_Amount);
    
  End Getnumericalvalue2;

End Pkg_Report;
/
