CREATE OR REPLACE PACKAGE Bl_Customer_Order_Line_Api IS
  --新增初始化
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2);
  --保存数据
  PROCEDURE Modify__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2);

  PROCEDURE Remove__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2);
  --取消订单行
  PROCEDURE Set_Cancel_Reason(Rowlist_  VARCHAR2,
                              User_Id_  VARCHAR2,
                              A311_Key_ VARCHAR2);
  --自定义的表
  PROCEDURE Usermodify__(Row_     IN Bl_Customer_Order_Line%ROWTYPE,
                         User_Id_ IN VARCHAR2);

  --列发生修改 执行
  PROCEDURE Itemchange__(Column_Id_   VARCHAR2,
                         Mainrowlist_ VARCHAR2,
                         Rowlist_     VARCHAR2,
                         User_Id_     VARCHAR2,
                         Outrowlist_  OUT VARCHAR2);
  --PROCEDURE ITEMCHANGE__(COLUMN_ID_ VARCHAR2 , ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  --获取 是否可以新增 修改
  FUNCTION Checkbutton__(Dotype_   IN VARCHAR2,
                         Order_No_ IN VARCHAR2,
                         User_Id_  IN VARCHAR2) RETURN VARCHAR2;

  --修改列的可编辑性
  FUNCTION Checkuseable(Doaction_  IN VARCHAR2,
                        Column_Id_ IN VARCHAR,
                        Rowlist_   IN VARCHAR2) RETURN VARCHAR2;

  --ORDER_NO  VARCHAR2(12)  N     
  --LINE_NO VARCHAR2(4) N     
  --REL_NO  VARCHAR2(4) N     
  --LINE_ITEM_NO  NUMBER  N     

  FUNCTION Get_Plan_Qty__(Order_No_     IN VARCHAR2,
                          Line_No_      IN VARCHAR2,
                          Rel_No_       VARCHAR2,
                          Line_Item_No_ NUMBER) RETURN NUMBER;
  FUNCTION Get_Factory_Order_(Order_No_     IN VARCHAR2,
                              Line_No_      IN VARCHAR2,
                              Rel_No_       VARCHAR2,
                              Line_Item_No_ NUMBER,
                              If_Contract   IN VARCHAR2 DEFAULT '0')
    RETURN VARCHAR2;
  PROCEDURE Get_Factory_Orderrow_(Order_No_     IN VARCHAR2,
                                  Line_No_      IN VARCHAR2,
                                  Rel_No_       VARCHAR2,
                                  Line_Item_No_ NUMBER,
                                  Outrow_       OUT Bl_v_Customer_Order_V01%ROWTYPE);
  FUNCTION Get_Par_Order_(Order_No_     IN VARCHAR2,
                          Line_No_      IN VARCHAR2,
                          Rel_No_       VARCHAR2,
                          Line_Item_No_ NUMBER,
                          If_Contract   IN VARCHAR2 DEFAULT '0')
    RETURN VARCHAR2;
  --根据line_key 获取 OBJID
  FUNCTION Get_Objid_By_Line_Key(Line_Key_ IN VARCHAR2) RETURN VARCHAR2;
  --根据line_key 获取 订单行
  PROCEDURE Get_Record_By_Line_Key(Line_Key_ IN VARCHAR2,
                                   Record_   OUT Bl_v_Customer_Order_Line%ROWTYPE);
END Bl_Customer_Order_Line_Api;
/
CREATE OR REPLACE PACKAGE BODY Bl_Customer_Order_Line_Api IS
  TYPE t_Cursor IS REF CURSOR;
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2) IS
    Attr_       VARCHAR2(4000);
    Info_       VARCHAR2(4000);
    Objid_      VARCHAR2(4000);
    Objversion_ VARCHAR2(4000);
    Action_     VARCHAR2(100);
    Attr_Out    VARCHAR2(4000);
    Row_        Customer_Order_Line_Tab%ROWTYPE;
    Mainrow_    Bl_v_Customer_Order%ROWTYPE;
    Row1_       Bl_v_Cust_Order_Line_Pack%ROWTYPE;
    Cur_        t_Cursor;
  BEGIN
    Action_             := 'PREPARE';
    Row1_.Order_Line_No := Pkg_a.Get_Item_Value('ORDER_LINE_NO', Rowlist_);
    IF Nvl(Row1_.Order_Line_No, '-') <> '-' THEN
      --包装
      OPEN Cur_ FOR
        SELECT t.*
          FROM Customer_Order_Line_Tab t
         WHERE Order_No || '-' || Line_No || '-' || Rel_No =
               Row1_.Order_Line_No
           AND t.Line_Item_No < 0;
      FETCH Cur_
        INTO Row_;
      IF Cur_%NOTFOUND THEN
        CLOSE Cur_;
        Pkg_a.Setfailed(A311_Key_,
                        'BL_V_CUSTOMER_ORDER_LINE',
                        Row1_.Order_Line_No);
        Raise_Application_Error(-20101, '错误的rowid');
        RETURN;
      END IF;
      CLOSE Cur_;
    
      Client_Sys.Add_To_Attr('LINE_ITEM_NO', Row_.Line_Item_No, Attr_);
      Client_Sys.Add_To_Attr('CONTRACT', Row_.Contract, Attr_);
      Client_Sys.Add_To_Attr('QTY_ASSIGNED', Row_.Qty_Assigned, Attr_);
      Client_Sys.Add_To_Attr('BUY_QTY_DUE', Row_.Buy_Qty_Due, Attr_);
      Client_Sys.Add_To_Attr('SALE_UNIT_PRICE',
                             Row_.Sale_Unit_Price,
                             Attr_);
      Client_Sys.Add_To_Attr('ORDER_NO', Row_.Order_No, Attr_);
      Client_Sys.Add_To_Attr('LINE_NO', Row_.Line_No, Attr_);
      Client_Sys.Add_To_Attr('REL_NO', Row_.Rel_No, Attr_);
      Client_Sys.Add_To_Attr('CONV_FACTOR', Row_.Conv_Factor, Attr_);
      Client_Sys.Add_To_Attr('COST', Row_.Cost, Attr_);
      Client_Sys.Add_To_Attr('QTY_SHIPPED', Row_.Qty_Shipped, Attr_);
      Client_Sys.Add_To_Attr('REVISED_QTY_DUE',
                             Row_.Revised_Qty_Due,
                             Attr_);
      Client_Sys.Add_To_Attr('PLANNED_DELIVERY_DATE',
                             Row_.Planned_Delivery_Date,
                             Attr_);
      Client_Sys.Add_To_Attr('PLANNED_DUE_DATE',
                             Row_.Planned_Due_Date,
                             Attr_);
      Client_Sys.Add_To_Attr('PROMISED_DELIVERY_DATE',
                             Row_.Promised_Delivery_Date,
                             Attr_);
      Client_Sys.Add_To_Attr('QTY_INVOICED', Row_.Qty_Invoiced, Attr_);
      Client_Sys.Add_To_Attr('BASE_SALE_UNIT_PRICE',
                             Row_.Base_Sale_Unit_Price,
                             Attr_);
      Client_Sys.Add_To_Attr('WANTED_DELIVERY_DATE',
                             Row_.Wanted_Delivery_Date,
                             Attr_);
      Client_Sys.Add_To_Attr('CURRENCY_RATE', Row_.Currency_Rate, Attr_);
      Customer_Order_Line_Api.New__(Info_,
                                    Objid_,
                                    Objversion_,
                                    Attr_,
                                    Action_);
      Attr_Out := Pkg_a.Get_Attr_By_Ifs(Attr_);
      Pkg_a.Set_Item_Value('ORDER_NO', Row_.Order_No, Attr_Out);
      Pkg_a.Set_Item_Value('LINE_NO', Row_.Line_No, Attr_Out);
      Pkg_a.Set_Item_Value('REL_NO', Row_.Rel_No, Attr_Out);
      Pkg_a.Set_Item_Value('LINE_ITEM_NO', '[ROWNUM]', Attr_Out);
    
      /* row_.sale_unit_price
      row_.order_no
      row_.line_no
      row_.rel_no
      row_.conv_factor
      row_.cost
      row_.qty_shipped
      row_.revised_qty_due
      row_.planned_delivery_date
      row_.planned_due_date
      row_.promised_delivery_date
      row_.qty_invoiced
      row_.base_sale_unit_price
      row_.wanted_delivery_date
      row_.currency_rate*/
      OPEN Cur_ FOR
        SELECT Price_With_Tax
          FROM Customer_Order_Tab t
         WHERE t.Order_No = Mainrow_.Order_No;
      FETCH Cur_
        INTO Mainrow_.Price_With_Tax;
      CLOSE Cur_;
      Pkg_a.Set_Item_Value('PRICE_WITH_TAX',
                           Mainrow_.Price_With_Tax,
                           Attr_Out);
    ELSE
      Attr_             := Pkg_a.Get_Attr_By_Bm(Rowlist_);
      Mainrow_.Order_No := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
      OPEN Cur_ FOR
        SELECT Price_With_Tax
          FROM Customer_Order_Tab t
         WHERE t.Order_No = Mainrow_.Order_No;
      FETCH Cur_
        INTO Mainrow_.Price_With_Tax;
      CLOSE Cur_;
      Customer_Order_Line_Api.New__(Info_,
                                    Objid_,
                                    Objversion_,
                                    Attr_,
                                    Action_);
      Attr_Out := Pkg_a.Get_Attr_By_Ifs(Attr_);
      Pkg_a.Set_Item_Value('PRICE_WITH_TAX',
                           Mainrow_.Price_With_Tax,
                           Attr_Out);
    END IF;
  
    Pkg_a.Setresult(A311_Key_, Attr_Out);
    RETURN;
  END;
  PROCEDURE Modify__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2) IS
    Row_        Bl_v_Customer_Order_Line%ROWTYPE;
    Attr_       VARCHAR2(4000);
    Info_       VARCHAR2(4000);
    Objid_      VARCHAR2(4000);
    Objversion_ VARCHAR2(4000);
    Action_     VARCHAR2(100);
    Index_      VARCHAR2(1);
    Cur_        t_Cursor;
    Pos_        NUMBER;
    Pos1_       NUMBER;
    i           NUMBER;
    v_          VARCHAR(1000);
    Column_Id_  VARCHAR(1000);
    Data_       VARCHAR(4000);
    Doaction_   VARCHAR(10);
    Mainrow_    Customer_Order_Tab%ROWTYPE;
    Row0_       Bl_Customer_Order_Line%ROWTYPE;
    Mysql_      VARCHAR(4000);
    Ifmychange  VARCHAR(10);
  BEGIN
  
    Index_     := f_Get_Data_Index();
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Doaction_  := Nvl(Pkg_a.Get_Item_Value('DOACTION', Rowlist_), 'M');
  
    IF Doaction_ = 'I' THEN
      /*新增*/
      Attr_         := '';
      Row_.Order_No := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
      SELECT t.*
        INTO Mainrow_
        FROM Customer_Order_Tab t
       WHERE t.Order_No = Row_.Order_No
         AND Rownum = 1;
      Client_Sys.Add_To_Attr('CUSTOMER_PART_NO',
                             Pkg_a.Get_Item_Value('CUSTOMER_PART_NO',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('CUSTOMER_PART_BUY_QTY', '', Attr_);
      Client_Sys.Add_To_Attr('CUSTOMER_PART_UNIT_MEAS', '', Attr_);
      Client_Sys.Add_To_Attr('CATALOG_NO',
                             Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('CATALOG_DESC',
                             Pkg_a.Get_Item_Value('CATALOG_DESC', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('BUY_QTY_DUE',
                             Pkg_a.Get_Item_Value('BUY_QTY_DUE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('DESIRED_QTY',
                             Pkg_a.Get_Item_Value('DESIRED_QTY', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('SALES_UNIT_MEAS',
                             Pkg_a.Get_Item_Value('SALES_UNIT_MEAS',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('WANTED_DELIVERY_DATE',
                             Pkg_a.Get_Item_Value('WANTED_DELIVERY_DATE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('PLANNED_DELIVERY_DATE',
                             Pkg_a.Get_Item_Value('PLANNED_DELIVERY_DATE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('PART_PRICE',
                             Pkg_a.Get_Item_Value('SALE_UNIT_PRICE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('PRICE_SOURCE',
                             Pkg_a.Get_Item_Value('PRICE_SOURCE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('PRICE_SOURCE_ID',
                             Pkg_a.Get_Item_Value('PRICE_SOURCE_ID',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('SALE_UNIT_PRICE',
                             Pkg_a.Get_Item_Value('SALE_UNIT_PRICE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('SALE_UNIT_PRICE_WITH_TAX',
                             Pkg_a.Get_Item_Value('SALE_UNIT_PRICE_WITH_TAX',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('PRICE_FREEZE_DB', 'FREE', Attr_);
      Client_Sys.Add_To_Attr('PRICE_UNIT_MEAS', 'pcs', Attr_);
      Client_Sys.Add_To_Attr('BASE_SALE_UNIT_PRICE',
                             Pkg_a.Get_Item_Value('SALE_UNIT_PRICE',
                                                  Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('COST',
                             Pkg_a.Get_Item_Value('COST', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('DISCOUNT',
                             Pkg_a.Get_Item_Value('DISCOUNT', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('ORDER_DISCOUNT', '0', Attr_);
      Client_Sys.Add_To_Attr('CLOSE_TOLERANCE', '0', Attr_);
      Client_Sys.Add_To_Attr('VAT_DB',
                             Pkg_a.Get_Item_Value('VAT_DB', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('FEE_CODE',
                             Pkg_a.Get_Item_Value('FEE_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('STAGED_BILLING_DB',
                             'NOT STAGED BILLING',
                             Attr_);
      Client_Sys.Add_To_Attr('WARRANTY', '', Attr_);
      Client_Sys.Add_To_Attr('DELIVERY_TYPE',
                             Mainrow_.Delivery_Type,
                             Attr_);
      --  client_sys.Add_To_Attr('DELIVERY_TERMS',mainrow_.delivery_terms,attr_);
      --  client_sys.Add_To_Attr('DELIVERY_TERMS_DESC',mainrow_.delivery_terms_desc,attr_);
    
      --raise_application_error(-20101,mainrow_.delivery_terms);
    
      Client_Sys.Add_To_Attr('DEFAULT_ADDR_FLAG_DB', 'Y', Attr_);
      Client_Sys.Add_To_Attr('ADDR_FLAG_DB', 'N', Attr_);
      Client_Sys.Add_To_Attr('SHIP_ADDR_NO', Mainrow_.Ship_Addr_No, Attr_);
      Client_Sys.Add_To_Attr('CONFIGURATION_ID', '*', Attr_);
      Client_Sys.Add_To_Attr('CONDITION_CODE', '', Attr_);
      Client_Sys.Add_To_Attr('CONSIGNMENT_STOCK_DB',
                             'NO CONSIGNMENT STOCK',
                             Attr_);
      Client_Sys.Add_To_Attr('PART_OWNERSHIP', 'Company Owned', Attr_);
      Client_Sys.Add_To_Attr('QTY_ASSIGNED', '0', Attr_);
      Client_Sys.Add_To_Attr('SUPPLY_CODE',
                             Pkg_a.Get_Item_Value('SUPPLY_CODE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('VENDOR_NO',
                             Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('SUPPLY_SITE_RESERVE_TYPE',
                             'Not Allowed',
                             Attr_);
      Client_Sys.Add_To_Attr('CHARGED_ITEM_DB', 'CHARGED ITEM', Attr_);
      Client_Sys.Add_To_Attr('DOP_CONNECTION', '', Attr_);
      Client_Sys.Add_To_Attr('CREATE_SM_OBJECT_OPTION_DB',
                             'DONOTCREATESMOBJECT',
                             Attr_);
      Client_Sys.Add_To_Attr('SM_CONNECTION_DB', 'NOT CONNECTED', Attr_);
      Client_Sys.Add_To_Attr('EARLIEST_START_DATE', SYSDATE, Attr_);
      Client_Sys.Add_To_Attr('CTP_PLANNED_DB', 'N', Attr_);
      Client_Sys.Add_To_Attr('EXCHANGE_ITEM_DB',
                             'ITEM NOT EXCHANGED',
                             Attr_);
      Client_Sys.Add_To_Attr('CUSTOMER_PART_CONV_FACTOR', '', Attr_);
      Client_Sys.Add_To_Attr('ORDER_NO', Row_.Order_No, Attr_);
      -- client_sys.Add_To_Attr('LINE_ITEM_NO',pkg_a.Get_Item_Value('LINE_ITEM_NO',ROWLIST_),attr_ );
      Client_Sys.Add_To_Attr('CATALOG_TYPE',
                             Pkg_a.Get_Item_Value('CATALOG_TYPE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('CONTRACT',
                             Pkg_a.Get_Item_Value('CONTRACT', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('PART_NO',
                             Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('CURRENCY_RATE',
                             Pkg_a.Get_Item_Value('CURRENCY_RATE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('PRICE_CONV_FACTOR', '1', Attr_);
      Client_Sys.Add_To_Attr('CONV_FACTOR', '1', Attr_);
      Client_Sys.Add_To_Attr('QTY_SHIPPED', '0', Attr_);
      Client_Sys.Add_To_Attr('REVISED_QTY_DUE',
                             Pkg_a.Get_Item_Value('BUY_QTY_DUE', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('PURCHASE_PART_NO',
                             Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('RELEASE_PLANNING_DB', 'NOTRELEASED', Attr_);
    
      Client_Sys.Add_To_Attr('LINE_NO',
                             Pkg_a.Get_Item_Value('LINE_NO', Rowlist_),
                             Attr_);
      Client_Sys.Add_To_Attr('REL_NO',
                             Pkg_a.Get_Item_Value('REL_NO', Rowlist_),
                             Attr_);
    
      Row_.Line_Item_No := Pkg_a.Get_Item_Value('LINE_ITEM_NO', Rowlist_);
      --包装结构
    
      IF To_Number(Nvl(Row_.Line_Item_No, '0')) > 0 THEN
      
        Row_.Line_No := Pkg_a.Get_Item_Value('LINE_NO', Rowlist_);
        Row_.Rel_No  := Pkg_a.Get_Item_Value('REL_NO', Rowlist_);
        SELECT MAX(Line_Item_No)
          INTO Row_.Line_Item_No
          FROM Customer_Order_Line_Tab t
         WHERE t.Order_No = Row_.Order_No
           AND t.Line_No = Row_.Line_No
           AND t.Rel_No = Row_.Rel_No;
        Row_.Line_Item_No := To_Number(Nvl(Row_.Line_Item_No, '0')) + 1;
        --   raise_application_error(-20101, row_.LINE_ITEM_NO );
        Client_Sys.Add_To_Attr('LINE_ITEM_NO', Row_.Line_Item_No, Attr_);
      ELSE
        Client_Sys.Add_To_Attr('LINE_ITEM_NO', '0', Attr_);
      END IF;
      Action_ := 'DO';
      Customer_Order_Line_Api.New__(Info_,
                                    Objid_,
                                    Objversion_,
                                    Attr_,
                                    Action_);
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_ORDER_LINE', Objid_);
    
      Row0_.Order_No      := Row_.Order_No;
      Row0_.Line_No       := Client_Sys.Get_Item_Value('LINE_NO', Attr_);
      Row0_.Rel_No        := Client_Sys.Get_Item_Value('REL_NO', Attr_);
      Row0_.Line_Item_No  := Client_Sys.Get_Item_Value('LINE_ITEM_NO',
                                                       Attr_);
      Row0_.Bld001_Pack   := Pkg_a.Get_Item_Value('BLD001_PACK', Rowlist_);
      Row0_.Po_Identifier := Pkg_a.Get_Item_Value('PO_IDENTIFIER', Rowlist_);
    
      Usermodify__(Row0_, User_Id_);
      RETURN;
    END IF;
    IF Doaction_ = 'M' THEN
      /*修改*/
      OPEN Cur_ FOR
        SELECT t.*
          FROM Bl_v_Customer_Order_Line t
         WHERE t.Objid = Row_.Objid;
      FETCH Cur_
        INTO Row_;
      IF Cur_%NOTFOUND THEN
      
        Raise_Application_Error(-20101, '错误的rowid');
        RETURN;
      END IF;
      CLOSE Cur_;
      /*获取有几列发生了修改*/
    
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := 'update bl_customer_order_line  set  ';
      Ifmychange := '0';
      LOOP
        EXIT WHEN Nvl(Pos_, 0) <= 0;
        EXIT WHEN i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        IF Column_Id_ = 'BLD001_PACK'
           OR Column_Id_ = 'PO_IDENTIFIER' THEN
          Ifmychange := '1';
          v_         := Substr(v_, Pos1_ + 1);
          Mysql_     := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
        
        ELSE
          IF Column_Id_ <> 'OBJID'
             AND Column_Id_ <> 'DOACTION'
             AND Column_Id_ <> 'QTY_CON'
             AND Length(Nvl(Column_Id_, '')) > 0 THEN
            v_ := Substr(v_, Pos1_ + 1);
            Client_Sys.Add_To_Attr(Column_Id_, v_, Attr_);
            i := i + 1;
          END IF;
        END IF;
      END LOOP;
    
      Action_ := 'DO';
      Customer_Order_Line_Api.Modify__(Info_,
                                       Row_.Objid,
                                       Row_.Objversion,
                                       Attr_,
                                       Action_);
      --用户自定义列
      IF Ifmychange = '1' THEN
      
        Row0_.Order_No      := Row_.Order_No;
        Row0_.Line_No       := Row_.Line_No;
        Row0_.Rel_No        := Row_.Rel_No;
        Row0_.Line_Item_No  := Row_.Line_Item_No;
        Row0_.Bld001_Pack   := Pkg_a.Get_Item_Value('BLD001_PACK', Rowlist_);
        Row0_.Po_Identifier := Pkg_a.Get_Item_Value('PO_IDENTIFIER',
                                                    Rowlist_);
      
        Usermodify__(Row0_, User_Id_);
      
      END IF;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_ORDER_LINE', Row_.Objid);
    
      RETURN;
    END IF;
    IF Doaction_ = 'D' THEN
      /*删除*/
      OPEN Cur_ FOR
        SELECT t.*
          FROM Bl_v_Customer_Order_Line t
         WHERE t.Objid = Row_.Objid;
      FETCH Cur_
        INTO Row_;
      IF Cur_%NOTFOUND THEN
        Raise_Application_Error(-20101, '错误的rowid');
        RETURN;
      END IF;
      CLOSE Cur_;
      Action_ := 'DO';
      Customer_Order_Line_Api.Remove__(Info_,
                                       Row_.Objid,
                                       Row_.Objversion,
                                       Action_);
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_ORDER_LINE', Row_.Objid);
    
      DELETE FROM Bl_Customer_Order_Line t
       WHERE t.Order_No = Row_.Order_No
         AND t.Line_No = Row_.Line_No
         AND t.Rel_No = Row_.Rel_No
         AND t.Line_Item_No = Row_.Line_Item_No;
      RETURN;
    END IF;
  END;

  PROCEDURE Remove__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2) IS
  BEGIN
    RETURN;
  END;
  PROCEDURE Set_Cancel_Reason(Rowlist_  VARCHAR2,
                              User_Id_  VARCHAR2,
                              A311_Key_ VARCHAR2) IS
    Row_        Bl_v_Customer_Order_Line%ROWTYPE;
    Cur_        t_Cursor;
    Co_Row_     Customer_Order_Pur_Order_Tab%ROWTYPE;
    A311_       A311%ROWTYPE;
    Po_Rowlist  VARCHAR2(4000);
    Head_State_ VARCHAR2(4000);
    Line_State_ VARCHAR2(4000);
    Info_       VARCHAR2(4000);
    Co_Row_Tab  Customer_Order_Line%ROWTYPE;
  BEGIN
    Row_.Objid        := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Row_.Order_No     := Pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
    Row_.Line_No      := Pkg_a.Get_Item_Value('LINE_NO', Rowlist_);
    Row_.Rel_No       := Pkg_a.Get_Item_Value('REL_NO', Rowlist_);
    Row_.Line_Item_No := Pkg_a.Get_Item_Value('LINE_ITEM_NO', Rowlist_);
    OPEN Cur_ FOR
      SELECT t.*
        FROM Bl_v_Customer_Order_Line t
       WHERE t.Objid = Row_.Objid;
    FETCH Cur_
      INTO Row_;
    IF Cur_%NOTFOUND THEN
      CLOSE Cur_;
      Pkg_a.Setfailed(A311_Key_, 'BL_V_CUSTOMER_ORDER_LINE', Row_.Objid);
      Raise_Application_Error(-20101, '错误的rowid');
      RETURN;
    END IF;
    CLOSE Cur_;
    Row_.Cancel_Reason := Pkg_a.Get_Item_Value('CANCEL_REASON', Rowlist_);
    Customer_Order_Line_Api.Set_Cancel_Reason(Row_.Order_No,
                                              Row_.Line_No,
                                              Row_.Rel_No,
                                              Row_.Line_Item_No,
                                              Row_.Cancel_Reason);
  
  
    --取消交货计划的订单行
  
    UPDATE bl_delivery_plan_detial t
       SET state       = '3',
           t.remark    = t.remark || ' -- 订单行被' || user_id_ || '取消',
           t.modi_user = user_id_,
           t.modi_date = SYSDATE
     WHERE t.order_no = Row_.Order_No
       AND t.line_no = Row_.Line_No
       AND t.rel_no = Row_.Rel_No
       AND t.line_item_no = Row_.Line_Item_No;
  
    ---取消 备货单 行 --
    UPDATE BL_PLDTL t
       SET flag = '3'
     WHERE t.order_no = Row_.Order_No
       AND t.line_no = Row_.Line_No
       AND t.rel_no = Row_.Rel_No
       AND t.line_item_no = Row_.Line_Item_No;
  
  
  
  
  
  
  
    -- Customer_Order_Line_API.Set_Cancelled(ROW_.ORDER_NO,ROW_.LINE_NO,ROW_.REL_NO,ROW_.LINE_ITEM_NO);
    Cancel_Customer_Order_Api.Cancel_Order_Line__(Head_State_,
                                                  Line_State_,
                                                  Info_,
                                                  Row_.Order_No,
                                                  Row_.Line_No,
                                                  Row_.Rel_No,
                                                  Row_.Line_Item_No,
                                                  'FALSE',
                                                  'FALSE');
  
    --判断是否全部取消完
    OPEN Cur_ FOR
      SELECT t.*
        FROM Customer_Order_Line t
       WHERE t.Order_No = Row_.Order_No
         AND t.Objstate != 'Cancelled';
    FETCH Cur_
      INTO Co_Row_Tab;
    IF Cur_%NOTFOUND THEN
      CLOSE Cur_;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_ORDER_LINE', Row_.Objid);
      Pkg_a.Setmsg(A311_Key_,
                   '',
                   '订单' || Row_.Order_No || '明细行第' || Row_.Line_No ||
                   '行取消成功');
    
      A311_.A311_Id    := 'BL_Customer_Order_Line_Api.set_cancel_reason';
      A311_.Enter_User := User_Id_;
      A311_.A014_Id    := 'A014_ID=PO_Cancle';
      A311_.Table_Id   := 'BL_V_CUSTOMER_ORDER';
      Pkg_a.Beginlog(A311_);
      Po_Rowlist := '';
      SELECT t.Objid
        INTO A311_.Table_Objid
        FROM Customer_Order t
       WHERE t.Order_No = Row_.Order_No
         AND Rownum = 1;
    
      Pkg_a.Set_Item_Value('OBJID', A311_.Table_Objid, Po_Rowlist);
      Pkg_a.Set_Item_Value('CANCEL_REASON', Row_.Cancel_Reason, Po_Rowlist);
      Bl_Customer_Order_Api.Set_Cancel_Reason(Po_Rowlist,
                                              User_Id_,
                                              A311_Key_);
      RETURN;
    END IF;
    CLOSE Cur_;
  
    /*取消当前行对应的所有的采购订单 和 销售订单 */
    OPEN Cur_ FOR
      SELECT T2.*
        FROM Customer_Order_Pur_Order_Tab T2
       WHERE T2.Oe_Order_No = Row_.Order_No
         AND T2.Oe_Line_No = Row_.Line_No
         AND T2.Oe_Rel_No = Row_.Rel_No
         AND T2.Oe_Line_Item_No = Row_.Line_Item_No
         AND T2.Purchase_Type = 'O';
  
    FETCH Cur_
      INTO Co_Row_;
    IF (Cur_%FOUND) THEN
      CLOSE Cur_;
      --取消对应的采购订单
      A311_.A311_Id    := 'BL_Customer_Order_Line_Api.set_cancel_reason';
      A311_.Enter_User := User_Id_;
      A311_.A014_Id    := 'A014_ID=POLine_Cancle';
      A311_.Table_Id   := 'BL_V_PURCHASE_ORDER_LINE_PART';
      OPEN Cur_ FOR
        SELECT t.Rowid
          FROM Purchase_Order_Line_Tab t
         WHERE t.Order_No = Co_Row_.Po_Order_No
           AND t.Line_No = Co_Row_.Po_Line_No
           AND t.Release_No = Co_Row_.Po_Rel_No;
      FETCH Cur_
        INTO A311_.Table_Objid;
      IF Cur_%FOUND THEN
        CLOSE Cur_;
        Pkg_a.Beginlog(A311_);
        Po_Rowlist := '';
        Pkg_a.Set_Item_Value('OBJID', A311_.Table_Objid, Po_Rowlist);
        Pkg_a.Set_Item_Value('CANCEL_REASON',
                             Row_.Cancel_Reason,
                             Po_Rowlist);
        Bl_Po_Line_Part_Api.Set_Cancel_Reason(Po_Rowlist,
                                              User_Id_,
                                              A311_.A311_Key);
      ELSE
        CLOSE Cur_;
      END IF;
    ELSE
      CLOSE Cur_;
    END IF;
  
    /*
        return  '[HTTP_URL]/showform/MainForm.aspx?option=M&A002KEY=4002&key=' || row_.po_order_no  ;
      
     end if;
      return  '[HTTP_URL]/showform/MainForm.aspx?option=M&A002KEY=4001&key=' || row_.po_order_no  ;
      
     end ; 
    */
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_ORDER_LINE', Row_.Objid);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '订单' || Row_.Order_No || '明细行第' || Row_.Line_No || '行取消成功');
    RETURN;
  END;
  PROCEDURE Itemchange__(Column_Id_   VARCHAR2,
                         Mainrowlist_ VARCHAR2,
                         Rowlist_     VARCHAR2,
                         User_Id_     VARCHAR2,
                         Outrowlist_  OUT VARCHAR2) IS
    Attr_       VARCHAR2(4000);
    Info_       VARCHAR2(4000);
    Objid_      VARCHAR2(4000);
    Objversion_ VARCHAR2(4000);
    Action_     VARCHAR2(100);
    Attr_Out    VARCHAR2(4000);
    Row_        Bl_v_Customer_Order_Line%ROWTYPE;
    Main_Row_   Bl_v_Customer_Order%ROWTYPE;
    Sprec_      Ifsapp.Sales_Part_Api.Public_Rec;
    Agreement_  Agreement_Sales_Part_Deal%ROWTYPE;
    Percent_    NUMBER;
    Cur_        t_Cursor;
    Pmainrow_   Bl_v_Cust_Order_Line_Pack%ROWTYPE;
  BEGIN
  
    IF Column_Id_ = 'CATALOG_NO'
       OR Column_Id_ = 'CUSTOMER_PART_NO' THEN
      Main_Row_.Contract := Pkg_a.Get_Item_Value('CONTRACT', Mainrowlist_);
      Main_Row_.Order_No := Pkg_a.Get_Item_Value('ORDER_NO', Mainrowlist_);
      IF Column_Id_ = 'CUSTOMER_PART_NO' THEN
        Row_.Customer_Part_No := Pkg_a.Get_Item_Value('CUSTOMER_PART_NO',
                                                      Rowlist_);
        Customer_Order_Line_Api.Get_Cust_Part_No_Defaults__(Info_,
                                                            Attr_,
                                                            Main_Row_.Order_No,
                                                            Row_.Customer_Part_No);
        Attr_Out        := Pkg_a.Get_Attr_By_Ifs(Attr_);
        Row_.Catalog_No := Pkg_a.Get_Item_Value('CATALOG_NO', Attr_Out);
      ELSE
        Row_.Catalog_No := Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_);
        Customer_Order_Line_Api.Get_Line_Defaults__(Info_,
                                                    Attr_,
                                                    Row_.Catalog_No,
                                                    Main_Row_.Order_No);
        Attr_Out := Pkg_a.Get_Attr_By_Ifs(Attr_);
      END IF;
    
      Row_.Buy_Qty_Due := Pkg_a.Get_Item_Value('BUY_QTY_DUE', Rowlist_);
      Customer_Order_Pricing_Api.Get_Order_Line_Price_Info(Sale_Unit_Price_      => Row_.Sale_Unit_Price,
                                                           Base_Sale_Unit_Price_ => Row_.Sale_Unit_Price_With_Tax,
                                                           Currency_Rate_        => Row_.Currency_Rate,
                                                           Discount_             => Row_.Discount,
                                                           Order_No_             => Main_Row_.Order_No,
                                                           Catalog_No_           => Row_.Catalog_No,
                                                           Buy_Qty_Due_          => Row_.Buy_Qty_Due,
                                                           Price_List_No_        => NULL,
                                                           Condition_Code_       => NULL);
      Pkg_a.Set_Item_Value('SALE_UNIT_PRICE',
                           Row_.Sale_Unit_Price,
                           Attr_Out);
      Pkg_a.Set_Item_Value('SALE_UNIT_PRICE_WITH_TAX',
                           Row_.Sale_Unit_Price_With_Tax,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CURRENCY_RATE', Row_.Currency_Rate, Attr_Out);
      Pkg_a.Set_Item_Value('DISCOUNT', Row_.Discount, Attr_Out);
    
      Pkg_a.Set_Item_Value('BUY_QTY_DUE', Row_.Buy_Qty_Due, Attr_Out);
    
      Sprec_ := Ifsapp.Sales_Part_Api.Get(Main_Row_.Contract,
                                          Row_.Catalog_No);
    
      -- 
      -- IFSAPP.STATUTORY_FEE_API.Get_Percentage(
      -- IFSAPP.Site_API.Get_Company(:i_hWndFrame.tbwCustomerOrderCharge.colsContract),
      --  :i_hWndFrame.tbwCustomerOrderCharge.colsFeeCode);
      Row_.Fee_Code := Ifsapp.Sales_Part_Api.Get_Fee_Code(Main_Row_.Contract,
                                                          Row_.Catalog_No); --sprec_.FEE_CODE;
      Pkg_a.Set_Item_Value('FEE_CODE', Row_.Fee_Code, Attr_Out);
      IF Nvl(Row_.Fee_Code, 'N') <> 'N' THEN
        Row_.Vat_Db := 'Y';
      ELSE
        Row_.Vat_Db := 'N';
      END IF;
      Row_.Vat_Db := 'Y';
      Pkg_a.Set_Item_Value('VAT_DB', Row_.Vat_Db, Attr_Out);
    
      --row_.PRICE_SOURCE_ID 
      --row_.PRICE_SOURCE
      --pkg_a.Set_Item_Value()
      --协议价格
      Main_Row_.Agreement_Id := Pkg_a.Get_Item_Value('AGREEMENT_ID',
                                                     Mainrowlist_);
      OPEN Cur_ FOR
        SELECT *
          FROM Agreement_Sales_Part_Deal t
         WHERE t.Contract = Main_Row_.Contract
           AND t.Catalog_No = Row_.Catalog_No
           AND t.Agreement_Id = Main_Row_.Agreement_Id;
      FETCH Cur_
        INTO Agreement_;
      IF Cur_%FOUND THEN
        Row_.Price_Source_Id := Main_Row_.Agreement_Id;
        Row_.Price_Source    := 'Agreement';
      ELSE
        Row_.Price_Source_Id := '';
        Row_.Price_Source    := 'Base';
      END IF;
    
      CLOSE Cur_;
      -- row_.PRICE_SOURCE_ID  := main_row_.AGREEMENT_ID;  
      Pkg_a.Set_Item_Value('PRICE_SOURCE_ID',
                           Row_.Price_Source_Id,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PRICE_SOURCE', Row_.Price_Source, Attr_Out);
      --
      --税率
      --statutory_fee_api.get_fee_percent(percent_,IFSAPP.SITE_API.Get_Company( main_row_.CONTRACT),   row_.FEE_CODE,sysdate);
    
      -- row_.SALE_UNIT_PRICE :=  row_.SALE_UNIT_PRICE_WITH_TAX  / ( 1 +  percent_ /100) ;
    
      --  pkg_a.Set_Item_Value('SALE_UNIT_PRICE',row_.SALE_UNIT_PRICE,attr_out); 
    
      ---读取 表头的协议号 如果存在
    
      --jia
    
      /*
      Customer_Order_Line_API.Get_Line_Defaults__(:i_hWndFrame.tbwCustomerOrderLine.lsInfo,
                                                       :i_hWndFrame.tbwCustomerOrderLine.lsAttr,
                                                       :i_hWndFrame.tbwCustomerOrderLine.colsCatalogNo,
                                                       :i_hWndFrame.tbwCustomerOrderLine.colsOrderNo);
      
      */
    
      /* row_.SALES_UNIT_MEAS := sprec_.price_unit_meas;
      
       pkg_a.Set_Item_Value('SALES_UNIT_MEAS',row_.SALES_UNIT_MEAS,attr_out);
       
       row_.CATALOG_DESC := sprec_.catalog_desc;
       pkg_a.Set_Item_Value('CATALOG_DESC',row_.CATALOG_DESC,attr_out);
      
       pkg_a.Set_Item_Value('SALE_UNIT_PRICE',row_.SALE_UNIT_PRICE,attr_out);
       row_.VAT_DB := sprec_.FEE_CODE;
       pkg_a.Set_Item_Value('VAT_DB',row_.VAT_DB,attr_out);
       
      */
    
      /*
        row_.SALE_UNIT_PRICE := 
      
      :i_hWndFrame.tbwCustomerOrderLine.nSuggestedExists         := IFSAPP.Suggested_Sales_Part_API.Suggested_Sales_Part_Exists(:i_hWndParent.frmCustomerOrder.dfsContract,
                                                                                                                                :i_hWndFrame.tbwCustomerOrderLine.colsCatalogNo);
      :i_hWndFrame.tbwCustomerOrderLine.colsSalesPriceGroupId    := sprec_.sales_price_group_id;
      :i_hWndFrame.tbwCustomerOrderLine.colsSerialTrackingCodeDb := IFSAPP.Part_Catalog_API.Get_Serial_Tracking_Code_Db(sprec_.part_no);
      :i_hWndFrame.tbwCustomerOrderLine.lsTaxRegimeDb            := IFSAPP.Tax_Regime_API.Encode(IFSAPP.customer_info_vat_api.get_tax_regime(:i_hWndParent.frmCustomerOrder.dfsCustomerNo,
      
          */
    
    END IF;
    IF Column_Id_ = 'QTY_CON' THEN
      Pmainrow_.Buy_Qty_Due := Pkg_a.Get_Item_Value('BUY_QTY_DUE',
                                                    Mainrowlist_);
      Pkg_a.Set_Item_Value('BUY_QTY_DUE',
                           To_Number(Pkg_a.Get_Item_Value('QTY_CON',
                                                          Rowlist_)) *
                           Pmainrow_.Buy_Qty_Due,
                           Attr_Out);
      Pkg_a.Set_Item_Value('DESIRED_QTY',
                           To_Number(Pkg_a.Get_Item_Value('QTY_CON',
                                                          Rowlist_)) *
                           Pmainrow_.Buy_Qty_Due,
                           Attr_Out);
    END IF;
  
    IF Column_Id_ = 'BUY_QTY_DUE' THEN
      Row_.Desired_Qty := Pkg_a.Get_Item_Value('DESIRED_QTY', Rowlist_);
    
      IF Nvl(Row_.Desired_Qty, '0') = '0' THEN
        Row_.Desired_Qty := Pkg_a.Get_Item_Value('BUY_QTY_DUE', Rowlist_);
        Pkg_a.Set_Item_Value('DESIRED_QTY', Row_.Desired_Qty, Attr_Out);
      
      END IF;
      Pmainrow_.Buy_Qty_Due := Pkg_a.Get_Item_Value('BUY_QTY_DUE',
                                                    Mainrowlist_);
      Row_.Buy_Qty_Due      := Pkg_a.Get_Item_Value('BUY_QTY_DUE', Rowlist_);
      IF To_Number(Nvl(Pmainrow_.Buy_Qty_Due, '0')) > 0 THEN
        Pkg_a.Set_Item_Value('QTY_CON',
                             Round(Row_.Buy_Qty_Due / Pmainrow_.Buy_Qty_Due,
                                   4),
                             Attr_Out);
      
      END IF;
    
      --DESIRED_QTY         
    END IF;
    IF Column_Id_ = 'FEE_CODE' THEN
      Row_.Fee_Code      := Pkg_a.Get_Item_Value('FEE_CODE', Rowlist_);
      Main_Row_.Contract := Pkg_a.Get_Item_Value('CONTRACT', Mainrowlist_);
      Statutory_Fee_Api.Get_Fee_Percent(Percent_,
                                        Ifsapp.Site_Api.Get_Company(Main_Row_.Contract),
                                        Row_.Fee_Code,
                                        SYSDATE);
      Attr_Out                      := NULL;
      Row_.Sale_Unit_Price          := Pkg_a.Get_Item_Value('SALE_UNIT_PRICE',
                                                            Rowlist_);
      Row_.Sale_Unit_Price_With_Tax := (100 + Percent_) *
                                       Row_.Sale_Unit_Price / 100;
      Pkg_a.Set_Item_Value('SALE_UNIT_PRICE_WITH_TAX',
                           Row_.Sale_Unit_Price_With_Tax,
                           Attr_Out);
      Pkg_a.Set_Item_Value('VAT_DB', 'Y', Attr_Out);
    END IF;
  
    IF Column_Id_ = 'SUPPLY_CODE' THEN
      Row_.Supply_Code := Pkg_a.Get_Item_Value('SUPPLY_CODE', Rowlist_);
    
      IF Nvl(Row_.Supply_Code, '0') = 'Invent Order'
         OR Nvl(Row_.Supply_Code, '0') = 'Pkg' THEN
        Pkg_a.Set_Item_Value('SUPPLY_SITE', '', Attr_Out);
        Pkg_a.Set_Item_Value('VENDOR_NO', '', Attr_Out);
      ELSE
        Row_.Catalog_No := Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_);
        Row_.Contract   := Pkg_a.Get_Item_Value('CONTRACT', Mainrowlist_);
        --IO,IPD,PKG,PT,IPT,NO,PD,SO
        OPEN Cur_ FOR
          SELECT t.Shortid
            FROM Bl_v_Co_Supply_Code t
           WHERE t.Id = Row_.Supply_Code;
        FETCH Cur_
          INTO Row_.Supply_Code;
        CLOSE Cur_;
      
        Customer_Order_Line_Api.Retrieve_Default_Vendor__(Vendor_No_   => Row_.Vendor_No,
                                                          Contract_    => Row_.Contract,
                                                          Part_No_     => Row_.Catalog_No,
                                                          Supply_Code_ => Row_.Supply_Code);
        Pkg_a.Set_Item_Value('VENDOR_NO', Row_.Vendor_No, Attr_Out);
        Row_.Supply_Site := Supplier_Api.Get_Acquisition_Site(Vendor_No_ => Row_.Vendor_No);
        Pkg_a.Set_Item_Value('SUPPLY_SITE', Row_.Supply_Site, Attr_Out);
      
      END IF;
    
    END IF;
    IF Column_Id_ = 'VENDOR_NO' THEN
      Row_.Vendor_No   := Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_);
      Row_.Supply_Site := Supplier_Api.Get_Acquisition_Site(Vendor_No_ => Row_.Vendor_No);
      Pkg_a.Set_Item_Value('SUPPLY_SITE', Row_.Supply_Site, Attr_Out);
    
    END IF;
  
    Outrowlist_ := Attr_Out;
  
    --  pkg_a.setResult(A311_KEY_,attr_out);   
  END;
  /*
  PROCEDURE ITEMCHANGE__(COLUMN_ID_ VARCHAR2 , ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
  IS
  attr_out varchar2(4000);
  BEGIN 
     ITEMCHANGE__( COLUMN_ID_,'',ROWLIST_,USER_ID_,attr_out);
     pkg_a.setResult(A311_KEY_,attr_out);    
     RETURN;
  END;
  */
  --BL_CUSTOMER_ORDER_LINE
  PROCEDURE Usermodify__(Row_     IN Bl_Customer_Order_Line%ROWTYPE,
                         User_Id_ IN VARCHAR2) IS
    Cur_  t_Cursor;
    Row0_ Bl_Customer_Order_Line%ROWTYPE;
  
  BEGIN
    OPEN Cur_ FOR
      SELECT t.*
        FROM Bl_Customer_Order_Line t
       WHERE t.Order_No = Row_.Order_No
         AND t.Line_No = Row_.Line_No
         AND t.Rel_No = Row_.Rel_No
         AND t.Line_Item_No = Row_.Line_Item_No;
    FETCH Cur_
      INTO Row0_;
    IF Cur_%NOTFOUND THEN
      INSERT INTO Bl_Customer_Order_Line
        (Order_No,
         Line_No,
         Rel_No,
         Line_Item_No,
         Enter_Date,
         Enter_User,
         Bld001_Pack,
         Po_Identifier,
         Line_Key)
        SELECT Row_.Order_No,
               Row_.Line_No,
               Row_.Rel_No,
               Row_.Line_Item_No,
               SYSDATE,
               User_Id_,
               Row_.Bld001_Pack,
               Row_.Po_Identifier,
               Row_.Order_No || '-' || Row_.Line_No || '-' || Row_.Rel_No || '-' ||
               Row_.Line_Item_No
          FROM Dual;
    ELSE
      UPDATE Bl_Customer_Order_Line t
         SET Bld001_Pack   = Nvl(Row_.Bld001_Pack, Bld001_Pack),
             Po_Identifier = Nvl(Row_.Po_Identifier, Po_Identifier),
             Modi_Date     = SYSDATE,
             Modi_User     = User_Id_
       WHERE t.Order_No = Row_.Order_No
         AND t.Line_No = Row_.Line_No
         AND t.Rel_No = Row_.Rel_No
         AND t.Line_Item_No = Row_.Line_Item_No;
    END IF;
    CLOSE Cur_;
  
  END;

  FUNCTION Checkuseable(Doaction_  IN VARCHAR2,
                        Column_Id_ IN VARCHAR,
                        Rowlist_   IN VARCHAR2) RETURN VARCHAR2 IS
    Row_ Bl_v_Customer_Order_Line%ROWTYPE;
  BEGIN
    IF Doaction_ = 'M' THEN
      Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
      Row_.State := Pkg_a.Get_Item_Value('STATE', Rowlist_); --  Delivered
      IF Row_.Objid = ''
         OR Row_.Objid = 'NULL' THEN
        IF Column_Id_ = 'SALE_UNIT_PRICE' THEN
          Row_.Price_With_Tax := Pkg_a.Get_Item_Value('PRICE_WITH_TAX',
                                                      Rowlist_);
          IF Row_.Price_With_Tax = 'FALSE' THEN
            RETURN '1';
          ELSE
            RETURN '0';
          END IF;
        END IF;
        IF Column_Id_ = 'SALE_UNIT_PRICE_WITH_TAX' THEN
          Row_.Price_With_Tax := Pkg_a.Get_Item_Value('PRICE_WITH_TAX',
                                                      Rowlist_);
          IF Row_.Price_With_Tax = 'TRUE' THEN
            RETURN '1';
          ELSE
            RETURN '0';
          END IF;
        END IF;
        RETURN '1';
      END IF;
      IF Row_.State <> 'Invoiced/Closed'
         AND Row_.State <> 'Cancelled' THEN
        -- 'Delivered' or row_.STATE ='Planned')   then
        IF Column_Id_ = 'CATALOG_NO'
           OR Column_Id_ = 'CUSTOMER_PART_NO'
           OR Column_Id_ = 'CONTRACT'
           OR Column_Id_ = 'ORDER_ID'
           OR Column_Id_ = 'DATE_ENTERED'
           OR Column_Id_ = 'PRICE_WITH_TAX'
           OR Column_Id_ = 'PRICE_SOURCE_ID'
           OR Column_Id_ = 'PRICE_SOURCE' THEN
          RETURN '0';
        END IF;
      
        IF Row_.State = 'Released' THEN
        
          Row_.Line_Item_No := Pkg_a.Get_Item_Value('LINE_ITEM_NO',
                                                    Rowlist_);
          Row_.Mainstate    := Pkg_a.Get_Item_Value('MAINSTATE', Rowlist_);
          IF (Column_Id_ = 'WANTED_DELIVERY_DATE' OR
             Column_Id_ = 'BUY_QTY_DUE' OR Column_Id_ = 'DESIRED_QTY' OR
             Column_Id_ = 'LINE_NO' OR Column_Id_ = 'REL_NO' OR
             Column_Id_ = 'SUPPLY_SITE' OR Column_Id_ = 'SUPPLY_CODE' OR
             Column_Id_ = 'VENDOR_NO' OR Column_Id_ = 'PO_IDENTIFIER' OR
             Column_Id_ = 'BLD001_PACK') THEN
            IF Row_.Line_Item_No <= 0 THEN
              IF (Column_Id_ = 'BUY_QTY_DUE' OR Column_Id_ = 'SUPPLY_SITE' OR
                 Column_Id_ = 'SUPPLY_CODE' OR Column_Id_ = 'VENDOR_NO' OR
                 Column_Id_ = 'PO_IDENTIFIER' OR
                 Column_Id_ = 'BLD001_PACK')
                 AND Row_.Mainstate = 'Planned' THEN
                RETURN '1';
              END IF;
            END IF;
            IF Row_.Line_Item_No > 0 THEN
            
              RETURN '1';
            END IF;
            RETURN '0';
          END IF;
          --if  row_.LINE_ITEM_NO  > 0 and ()
        
          -- return '0' ;
        
          --  end if ;  
        END IF;
      
        IF Column_Id_ = 'SALE_UNIT_PRICE' THEN
          Row_.Price_With_Tax := Pkg_a.Get_Item_Value('PRICE_WITH_TAX',
                                                      Rowlist_);
          IF Row_.Price_With_Tax = 'FALSE' THEN
            RETURN '1';
          ELSE
            RETURN '0';
          END IF;
        END IF;
        IF Column_Id_ = 'SALE_UNIT_PRICE_WITH_TAX' THEN
          Row_.Price_With_Tax := Pkg_a.Get_Item_Value('PRICE_WITH_TAX',
                                                      Rowlist_);
          IF Row_.Price_With_Tax = 'TRUE' THEN
            RETURN '1';
          ELSE
            RETURN '0';
          END IF;
        END IF;
        RETURN '1';
      ELSE
        RETURN '0';
      END IF;
    
    END IF;
  
    RETURN '1';
  END;
  ----检查添加行 删除行 
  FUNCTION Checkbutton__(Dotype_   IN VARCHAR2,
                         Order_No_ IN VARCHAR2,
                         User_Id_  IN VARCHAR2) RETURN VARCHAR2 IS
    Cur_ t_Cursor;
    Row_ Bl_v_Customer_Order%ROWTYPE;
  BEGIN
    IF Instr(Order_No_, '-') > 0 THEN
      -- BL_V_CUST_ORDER_LINE_PACK
    
      RETURN '1';
    END IF;
    OPEN Cur_ FOR
      SELECT t.* FROM Bl_v_Customer_Order t WHERE t.Order_No = Order_No_;
    FETCH Cur_
      INTO Row_;
    IF Cur_%NOTFOUND THEN
      CLOSE Cur_;
      RETURN '0';
    END IF;
    CLOSE Cur_;
    IF Row_.Objstate <> 'Planned' THEN
      RETURN '0';
    END IF;
  
    /*  if dotype_ = 'ADD_ROW'  then
        return  '0';
     end if ;   
    if dotype_ = 'DEL_ROW'  then
        return  '0';
     end if ;  */
    RETURN '1';
  END;
  --获取交货计划数量
  FUNCTION Get_Plan_Qty__(Order_No_     IN VARCHAR2,
                          Line_No_      IN VARCHAR2,
                          Rel_No_       VARCHAR2,
                          Line_Item_No_ NUMBER) RETURN NUMBER IS
    Cur_    t_Cursor;
    Sum_Qty NUMBER;
  BEGIN
    --计划,下达,确认,失效,差异发货,关闭,取消
    -- 0    1    2    3    4        5    6 
    OPEN Cur_ FOR
      SELECT SUM(t.Qty_Delived)
        FROM Bl_Delivery_Plan_Detial t
       WHERE t.f_Order_No = Order_No_
         AND t.f_Line_No = Line_No_
         AND t.f_Rel_No = Rel_No_
         AND t.f_Line_Item_No = Line_Item_No_
         AND t.State <> '3';
    FETCH Cur_
      INTO Sum_Qty;
    CLOSE Cur_;
    RETURN Nvl(Sum_Qty, 0);
  END;
  PROCEDURE Get_Record_By_Line_Key(Line_Key_ IN VARCHAR2,
                                   Record_   OUT Bl_v_Customer_Order_Line%ROWTYPE) IS
    Datalist_ Dbms_Sql.Varchar2_Table;
    Cur_      t_Cursor;
  BEGIN
    Datalist_ := Pkg_a.Get_Str_List_By_Index(Line_Key_, '-');
    IF Nvl(Datalist_(4), '-') = '-' THEN
      Datalist_(4) := Nvl(Datalist_(4), '-') || Datalist_(5);
    END IF;
    OPEN Cur_ FOR
      SELECT t.*
        FROM Bl_v_Customer_Order_Line t
       WHERE t.Order_No = Datalist_(1)
         AND t.Line_No = Datalist_(2)
         AND t.Rel_No = Datalist_(3)
         AND t.Line_Item_No = Datalist_(4);
    FETCH Cur_
      INTO Record_;
    CLOSE Cur_;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN;
    
  END;


  FUNCTION Get_Objid_By_Line_Key(Line_Key_ IN VARCHAR2) RETURN VARCHAR2 IS
    Objid_    VARCHAR2(1000);
    Datalist_ Dbms_Sql.Varchar2_Table;
    Cur_      t_Cursor;
  BEGIN
    Datalist_ := Pkg_a.Get_Str_List_By_Index(Line_Key_, '-');
    IF Nvl(Datalist_(4), '-') = '-' THEN
      Datalist_(4) := Nvl(Datalist_(4), '-') || Datalist_(5);
    END IF;
    OPEN Cur_ FOR
      SELECT Objid
        FROM Customer_Order_Line t
       WHERE t.Order_No = Datalist_(1)
         AND t.Line_No = Datalist_(2)
         AND t.Rel_No = Datalist_(3)
         AND t.Line_Item_No = Datalist_(4);
    FETCH Cur_
      INTO Objid_;
    CLOSE Cur_;
    RETURN Objid_;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN NULL;
    
  END;




  FUNCTION Get_Par_Order_(Order_No_     IN VARCHAR2,
                          Line_No_      IN VARCHAR2,
                          Rel_No_       VARCHAR2,
                          Line_Item_No_ NUMBER,
                          If_Contract   IN VARCHAR2 DEFAULT '0')
    RETURN VARCHAR2 IS
    Cur_    t_Cursor;
    Row_    Bl_v_Customer_Order_V01%ROWTYPE;
    Result_ VARCHAR2(100);
  BEGIN
    OPEN Cur_ FOR
      SELECT t.*
        FROM Bl_v_Customer_Order_V01 t
       WHERE t.Order_No = Order_No_
         AND t.Line_No = Line_No_
         AND t.Rel_No = Rel_No_
         AND t.Line_Item_No = Line_Item_No_;
    FETCH Cur_
      INTO Row_;
    IF Cur_%FOUND THEN
      CLOSE Cur_;
      IF Nvl(Row_.Demand_Order_No, '-') = '-' THEN
        IF If_Contract = '1' THEN
          RETURN Row_.Co_Contract;
        END IF;
        IF If_Contract = 'OBJID' THEN
          RETURN Row_.Co_Objid;
        END IF;
      
        RETURN Row_.Order_No || '-' || Row_.Line_No || '-' || Row_.Rel_No || '-' || To_Char(Row_.Line_Item_No);
      
      END IF;
      Result_ := Get_Par_Order_(Row_.Demand_Order_No,
                                Row_.Demand_Line_No,
                                Row_.Demand_Rel_No,
                                Row_.Demand_Line_Item_No,
                                If_Contract);
      RETURN Nvl(Result_,
                 Row_.Demand_Order_No || '-' || Row_.Demand_Line_No || '-' ||
                 Row_.Demand_Rel_No || '-' ||
                 To_Char(Row_.Demand_Line_Item_No));
    END IF;
    CLOSE Cur_;
    RETURN Nvl(Result_,
               Order_No_ || '-' || Line_No_ || '-' || Rel_No_ || '-' ||
               To_Char(Line_Item_No_));
  
  END;





  --
  --获取工厂域的订单信息
  FUNCTION Get_Factory_Order_(Order_No_     IN VARCHAR2,
                              Line_No_      IN VARCHAR2,
                              Rel_No_       VARCHAR2,
                              Line_Item_No_ NUMBER,
                              If_Contract   IN VARCHAR2 DEFAULT '0')
    RETURN VARCHAR2 IS
    Cur_    t_Cursor;
    Row_    Bl_v_Customer_Order_V01%ROWTYPE;
    Result_ VARCHAR2(100);
  BEGIN
    OPEN Cur_ FOR
      SELECT t.*
        FROM Bl_v_Customer_Order_V01 t
       WHERE t.Demand_Order_No = Order_No_
         AND t.Demand_Line_No = Line_No_
         AND t.Demand_Rel_No = Rel_No_
         AND t.Demand_Line_Item_No = Line_Item_No_;
    FETCH Cur_
      INTO Row_;
    IF Cur_%FOUND THEN
      CLOSE Cur_;
      Result_ := Get_Factory_Order_(Row_.Order_No,
                                    Row_.Line_No,
                                    Row_.Rel_No,
                                    Row_.Line_Item_No,
                                    If_Contract);
      IF If_Contract = '1' THEN
        RETURN Nvl(Result_, Row_.Co_Contract);
      END IF;
      IF If_Contract = 'OBJID' THEN
        RETURN Nvl(Result_, Row_.Co_Objid);
      END IF;
      RETURN Nvl(Result_,
                 Row_.Order_No || '-' || Row_.Line_No || '-' || Row_.Rel_No || '-' ||
                 To_Char(Row_.Line_Item_No));
    END IF;
    CLOSE Cur_;
    IF If_Contract = '1' THEN
      OPEN Cur_ FOR
        SELECT t.Contract
          FROM Customer_Order_Line t
         WHERE t.Order_No = Order_No_
           AND t.Line_No = Line_No_
           AND t.Rel_No = Rel_No_
           AND t.Line_Item_No = Line_Item_No_
           AND Rownum = 1;
      FETCH Cur_
        INTO Row_.Co_Contract;
      CLOSE Cur_;
      RETURN Row_.Co_Contract;
    END IF;
    IF If_Contract = 'OBJID' THEN
      OPEN Cur_ FOR
        SELECT t.Objid
          FROM Customer_Order_Line t
         WHERE t.Order_No = Order_No_
           AND t.Line_No = Line_No_
           AND t.Rel_No = Rel_No_
           AND t.Line_Item_No = Line_Item_No_
           AND Rownum = 1;
      FETCH Cur_
        INTO Row_.Co_Objid;
      CLOSE Cur_;
      RETURN Row_.Co_Objid;
    END IF;
  
  
  
    RETURN Nvl(Result_,
               Order_No_ || '-' || Line_No_ || '-' || Rel_No_ || '-' ||
               To_Char(Line_Item_No_));
  
  END;
  --获取工厂域的订单信息
  PROCEDURE Get_Factory_Orderrow_(Order_No_     IN VARCHAR2,
                                  Line_No_      IN VARCHAR2,
                                  Rel_No_       VARCHAR2,
                                  Line_Item_No_ NUMBER,
                                  Outrow_       OUT Bl_v_Customer_Order_V01%ROWTYPE) IS
    Cur_       t_Cursor;
    Row_       Bl_v_Customer_Order_V01%ROWTYPE;
    Resultrow_ Bl_v_Customer_Order_V01%ROWTYPE;
  BEGIN
    OPEN Cur_ FOR
      SELECT t.*
        FROM Bl_v_Customer_Order_V01 t
       WHERE t.Demand_Order_No = Order_No_
         AND t.Demand_Line_No = Line_No_
         AND t.Demand_Rel_No = Rel_No_
         AND t.Demand_Line_Item_No = Line_Item_No_;
    FETCH Cur_
      INTO Row_;
    IF Cur_%FOUND THEN
      CLOSE Cur_;
      Get_Factory_Orderrow_(Row_.Order_No,
                            Row_.Line_No,
                            Row_.Rel_No,
                            Row_.Line_Item_No,
                            Resultrow_);
      IF Nvl(Resultrow_.Order_No, '-') = '-' THEN
        Outrow_ := Row_;
      END IF;
    ELSE
      CLOSE Cur_;
    END IF;
  
    RETURN;
  END;

END Bl_Customer_Order_Line_Api;
/
