Create Or Replace Package Bl_Inventory_Transaction_Print Is

  --打印库存报表
  Procedure Set_Day_Print_Id(Contract_ In Varchar2,
                             Date_     In Varchar2,
                             Reportid_ In Varchar2,
                             Key_      In Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ In Number);
  Procedure Set_Bl_Inventory_Report_(Report_Row_ In Out Bl_Inventory_Report%Rowtype,
                                     Objid_      Out Varchar2);
End Bl_Inventory_Transaction_Print;
/
Create Or Replace Package Body Bl_Inventory_Transaction_Print Is

  --打印库存报表
  Type t_Cursor Is Ref Cursor;
  Procedure Set_Day_Print_Id(Contract_ In Varchar2,
                             Date_     In Varchar2,
                             Reportid_ In Varchar2,
                             Key_      In Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ In Number) Is
    Cur_        t_Cursor;
    Report_     Bl_Inventory_Report%Rowtype;
    i_          Number;
    Pagerows_   Number;
    Old_Report_ Bl_Inventory_Report%Rowtype;
    Sql_        Varchar2(4000);
    Begin_Date_ Date;
    End_Date_   Date;
    Objid_      Varchar2(400);
    Pagenum_    Number;
  Begin
    Pagerows_     := 10; --每页10条记录
    Begin_Date_   := To_Date(Date_, 'YYYY-MM-DD');
    End_Date_     := To_Date(Date_ || ' 23:59:59', 'YYYY-MM-DD HH24:MI:SS');
    Report_.Col00 := Contract_; --报表类型
    Report_.Col01 := Date_; --日期
    Report_.Col02 := Reportid_;
    Report_.Col03 := Key_;
    Report_.Col04 := ''; --流水号
    /* 采购订单入库  yyyy  mm  12  01  XXXX    
      采购订单出库  yyyy  mm  12  02  XXXX    
      采购供应商物料下发 yyyy  mm  12  04  XXXX    
      备货单出库 yyyy  mm  12  05  XXXX    
      客户退货  yyyy  mm  12  06  XXXX    
      备货单入库 yyyy  mm  12  01  XXXX    
      材料申请下发  yyyy  mm  12  08  XXXX    
      材料申请退回入库  yyyy  mm  12  09  XXXX    
      移库出库  yyyy  mm  12  10  XXXX    
      移库入库  yyyy  mm  12  11  XXXX    
    */
    Report_.Enter_User := User_Id_;
    Report_.Num01      := A311_Key_;
    If Reportid_ = 1 Then
      Open Cur_ For
        Select To_Char(Begin_Date_, 'YYYYMM') || t.Contract || '01', --序号
               t.Transaction_Id, --编号
               T1.Vendor_No, --供应商
               Supplier_Api.Get_Vendor_Name(T1.Vendor_No) As Vendor_Name, --名称
               g.Inventory_Location_Type_Db, --库位组
               T1.Blorder_No, --保隆订单号
               t.Order_No, --采购订单号
               t.Part_No, -- 采购件号
               t.Quantity, -- 数量
               t.Lot_Batch_No, -- 批号
               t.Location_No, -- 库位号
               Inventory_Location_Api.Get_Location_Name(t.Contract,
                                                        t.Location_No) As Location_Name, -- 库位 
               Inventory_Location_Api.Get_Warehouse(t.Contract,
                                                    t.Location_No) As Warehouse -- Warehouse,    
        
          From Inventory_Transaction_Hist2 t
         Inner Join Inventory_Location_Group g
            On g.Location_Group = t.Location_Group
           And g.Inventory_Location_Type_Db = 'PICKING'
         Inner Join Bl_v_Purchase_Order T1
            On T1.Order_No = t.Order_No
         Where t.Transaction_Code = 'INVM-IN'
           And t.Date_Applied >= Begin_Date_
           And t.Date_Applied <= End_Date_
           And Not Exists (Select 1
                  From Bl_Inventory_Report b
                 Where b.Row_Key = t.Transaction_Id)
         Order By t.Contract, T1.Vendor_No, t.Date_Applied;
      Fetch Cur_
        Into Report_.Col50,
             Report_.Row_Key,
             Report_.Col05,
             Report_.Col06,
             Report_.Col07,
             Report_.Col08,
             Report_.Col09,
             Report_.Col10,
             Report_.Col11,
             Report_.Col12,
             Report_.Col13,
             Report_.Col14,
             Report_.Col15;
      i_ := 0;
      Loop
        Exit When Cur_%Notfound;
        i_ := i_ + 1;
        --供应商不同
        If Nvl(Old_Report_.Col05, '-') <> Report_.Col05 Or
           Nvl(Old_Report_.Col50, '-') <> Nvl(Report_.Col50, '-') Or
           Mod(i_, Pagerows_) = 0 Then
          --生成一个新编号        
          --获取流水号码
          If Nvl(Old_Report_.Col50, '-') <> Nvl(Report_.Col50, '-') Then
            --取流水号     
            Select Max(Col04)
              Into Report_.Col04
              From Bl_Inventory_Report t
             Where t.Col50 = Report_.Col50;
            Report_.Col04 := Nvl(Report_.Col04, Report_.Col50 || '0001');
          Else
            Report_.Col04 := Old_Report_.Col04 + 1;
          End If;
        
          Old_Report_ := Report_;
        End If;
      
        Set_Bl_Inventory_Report_(Report_, Objid_);
        Fetch Cur_
          Into Report_.Col50,
               Report_.Row_Key,
               Report_.Col05,
               Report_.Col06,
               Report_.Col07,
               Report_.Col08,
               Report_.Col09,
               Report_.Col10,
               Report_.Col11,
               Report_.Col12,
               Report_.Col13,
               Report_.Col14,
               Report_.Col15;
      End Loop;
      Close Cur_;
    End If;
  
    If Reportid_ = 2 Then
      Open Cur_ For
        Select To_Char(Begin_Date_, 'YYYYMM') || t.Contract || '02', --序号
               t.Transaction_Id, --编号
               T1.Picklistno, --备货单号
               T2.Customer_Ref, --客户
               Cust_Ord_Customer_Api.Get_Name(T2.Customer_Ref) As Customer_Name, --客户名称
               Bl_Customer_Order_Api.Get_Column_Data('BLORDER_NO',
                                                     T1.Order_No) As Blorder_No, --保隆订单号
               t.Order_No, --订单号
               t.Part_No, -- 采购件号
               t.Quantity, -- 数量
               t.Lot_Batch_No, -- 批号
               t.Location_No, -- 库位号
               Inventory_Location_Api.Get_Location_Name(t.Contract,
                                                        t.Location_No) As Location_Name, -- 库位 
               Inventory_Location_Api.Get_Warehouse(t.Contract,
                                                    t.Location_No) As Warehouse -- Warehouse,    
        
          From Inventory_Transaction_Hist2 t
         Inner Join Bl_Plinv_Reg_Dtl_Tab T1
            On T1.Transaction_Id = t.Transaction_Id
         Inner Join Bl_Picklist T2
            On T2.Picklistno = T1.Picklistno
         Where t.Date_Applied >= Begin_Date_
           And t.Date_Applied <= End_Date_
           And Not Exists (Select 1
                  From Bl_Inventory_Report b
                 Where b.Row_Key = t.Transaction_Id)
         Order By t.Contract, T1.Picklistno, t.Date_Applied;
    
      Fetch Cur_
        Into Report_.Col50,
             Report_.Row_Key,
             Report_.Col05,
             Report_.Col06,
             Report_.Col07,
             Report_.Col08,
             Report_.Col09,
             Report_.Col10,
             Report_.Col11,
             Report_.Col12,
             Report_.Col13,
             Report_.Col14,
             Report_.Col15;
      i_ := 0;
      Loop
        Exit When Cur_%Notfound;
        i_ := i_ + 1;
        --备货单号不同
        If Nvl(Old_Report_.Col05, '-') <> Report_.Col05 Or
           Nvl(Old_Report_.Col50, '-') <> Nvl(Report_.Col50, '-') Or
           Mod(i_, Pagerows_) = 0 Then
          --生成一个新编号        
          --获取流水号码
          If Nvl(Old_Report_.Col50, '-') <> Nvl(Report_.Col50, '-') Then
            --取流水号     
            Select Max(Col04)
              Into Report_.Col04
              From Bl_Inventory_Report t
             Where t.Col50 = Report_.Col50;
            Report_.Col04 := Nvl(Report_.Col04, Report_.Col50 || '0001');
          Else
            Report_.Col04 := Old_Report_.Col04 + 1;
          End If;
        
          Old_Report_ := Report_;
        End If;
      
        Set_Bl_Inventory_Report_(Report_, Objid_);
        Fetch Cur_
          Into Report_.Col50,
               Report_.Row_Key,
               Report_.Col05,
               Report_.Col06,
               Report_.Col07,
               Report_.Col08,
               Report_.Col09,
               Report_.Col10,
               Report_.Col11,
               Report_.Col12,
               Report_.Col13,
               Report_.Col14,
               Report_.Col15;
      End Loop;
      Close Cur_;
    
    End If;
    /*
        流水号 供应商号  供应商   入库日期    
    保隆订单号 采购订单号 采购件号  数量  批号  库位号 库位
    
        1  采购订单入库  INVENTORY_TRANSACTION_HIST2  TRANSACTION_CODE ='INVM-IN'  采购  INVENTORY_LOCATION_GROUP_API.Get_Description()(LOCATION_GROUP)='提货'  ORDER_NO ,  RELEASE_NO, SEQUENCE_NO , LINE_ITEM_NO   DATE_APPLIED  以当天一个供应商，十条数据为分页方式
        2  备货单入库  bl_plinv_reg_dtl_tab            一个备货单号，10条数据
        3  客户订单退货入库  INVENTORY_TRANSACTION_HIST2  TRANSACTION_CODE ='OERET-NO，OERETURN'         一个客户退货单，10条数据
        4 材料申请退回入库  INVENTORY_TRANSACTION_HIST3 TRANSACTION_CODE ='INTUNISS'          
        5 备货单发货出库 bl_pltrans            
        6 客户订单发货出库  bl_pltrans            
        7 采购订单退货出库  BL_PURRENTURN_DTL_TAB           
        8 材料申请下发  INVENTORY_TRANSACTION_HIST2 INTSHIP         
        9 采购供应商物料下发 INVENTORY_TRANSACTION_HIST2 PURSHIP         
        10  移库出库  BL_INVENTORYPART_MOVEREQ_TRAN           
        11  移库入库  INVENTORY_TRANSACTION_HIST2 associated_transaction_id         
        */
    --1  采购订单入库
  
    Return;
  End;
  Procedure Set_Bl_Inventory_Report_(Report_Row_ In Out Bl_Inventory_Report%Rowtype,
                                     Objid_      Out Varchar2) Is
  Begin
    Select s_Bl_Inventory_Report.Nextval
      Into Report_Row_.Reportid
      From Dual;
    Insert Into Bl_Inventory_Report
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

End Bl_Inventory_Transaction_Print;
/
