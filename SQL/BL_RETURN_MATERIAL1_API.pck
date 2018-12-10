create or replace package BL_RETURN_MATERIAL1_API is

  -- Author  : fjp
  -- Created : 2012-11-2 10:10:11
  -- Purpose : 
 --客户退货申请生成采购退货申请 
 PROCEDURE Return_CustomerRelease_(RMA_NO_ VARCHAR2,--客户退货单号
                                   USER_ID_ VARCHAR2,
                                   A311_KEY_ VARCHAR2);--自动生成采购订单的申请
 --采购退货申请生产客户退货申请
 PROCEDURE Return_PurchaseRelease_(INSPECT_NO_ VARCHAR2,--采购退货单号
                                   USER_ID_ VARCHAR2,
                                   A311_KEY_ VARCHAR2);--自动生成客户订单的申请
 --中间域的客户退货
 PROCEDURE Return_CustomerStock_(rma_no_ number,  --客户退货单号
                                rma_line_no_ number);
  --中间域的采购退货
 PROCEDURE Return_PurchaseStock_(INSPECT_NO_ varchar2,  
                                 INSPECT_NO_LINE_ number);  
  --自动生产客户退货头信息
  PROCEDURE Return_CustomerHeadCommit_(ROW_ return_material%rowtype,
                                       attr1_ out varchar2);    
  --自动生产客户退货明细信息
  PROCEDURE Return_CustomerDetailCommit_(ROW_ return_material_line%rowtype,
                                       attr1_ out varchar2);                                                                                                
end BL_RETURN_MATERIAL1_API;
/
create or replace package body BL_RETURN_MATERIAL1_API is
  TYPE t_cursor IS REF CURSOR;
  /* create fjp 2012-11-02
   modify  fjp 2012-11-08 增加没有关联关系的内部供应商的生成客户退货，或者截止采购为外部的采购
   modify fjp  （包装件为-1，则取大于0）--fjp 2012-11-16
   modify fjp  2012-12-06 取没有订单号的税*/
 PROCEDURE Return_CustomerRelease_(RMA_NO_ VARCHAR2,
                                   USER_ID_ VARCHAR2,
                                   A311_KEY_ VARCHAR2)
  is
    cur_ t_cursor;
    cur1_ t_cursor;
    cur2_ t_cursor;
    row_ BL_V_RETURN_MATERIAL_LINE%rowtype;
    Attr_ varchar2(4000);
    Record_Separator_ VARCHAR2(10);
    Field_Separator_  VARCHAR2(10);
    Index_           NUMBER;
    Name_            VARCHAR2(100);
    Value_           VARCHAR2(100);
    INSPECT_NO_LINE_ number;
    row1_ purchase_order_line_part%rowtype;
    row2_ bl_return_material%rowtype;
    v_ number default 0;
    i_  number default 0;
    pur_order_no_ dbms_sql.Varchar2_Table;
    Ls_Customer_Inner_  varchar2(100);
  begin
     Attr_ :='';
     Field_Separator_  := '|';
     Record_Separator_ := f_Get_Data_Index();
    open cur_ for
    select  t.*
    from BL_V_RETURN_MATERIAL_LINE t 
    where t.rma_no = RMA_NO_
    and t.state='Released';
    fetch cur_ into row_;
    while cur_%found loop
      --获取保隆订单号
       open cur2_ for
       select  t.*     
        from bl_return_material t 
        where rma_no = row_.RMA_NO;
        fetch  cur2_ into row2_;
        close cur2_;
      --- 获取下级采购订单号
       open cur1_ for
        SELECT  t.*
        FROM IFSAPP.customer_order_line_tab t1
       INNER JOIN IFSAPP.purchase_order_line_part t
          ON t.DEMAND_ORDER_NO = t1.ORDER_NO
         AND t.DEMAND_RELEASE = t1.LINE_NO
         AND t.DEMAND_SEQUENCE_NO = t1.REL_NO
         AND t.DEMAND_OPERATION_NO = t1.LINE_ITEM_NO
         AND t1.order_no = row_.order_no
         and t1.line_no  =row_.line_no
         and t1.rel_no    = row_.rel_no
         and t1.line_item_no = row_.line_item_no;
         fetch cur1_ into row1_;
         while cur1_%found  loop
             --客户退货不生产采购退货：当采购退货为外部客户
            Ls_Customer_Inner_ :=Identity_Invoice_Info_Api.Get_Identity_Type(row1_.company,
                                                       row1_.vendor_no,
                                                       'Supplier');                                   
            IF Ls_Customer_Inner_ = 'INTERN' THEN  -- 只有是内部的采购才生成采购退货
               Name_ :=  row1_.contract||'-'||row1_.vendor_no;
                Index_    := Instr(Record_Separator_ || Attr_,
                                           Record_Separator_ || Name_ ||
                                           Field_Separator_);
                --有重复的就更新明细，没有重复的就新增主明细
                if Index_ > 0 then 
                  --获取采购退货申请号
                   Value_ := pkg_a.Get_Item_Value(Name_,Attr_);
                else
                   Value_ :='';
                    BL_PURCHASE_ORDER_RETRUN_API.getInspectNo(row1_.CONTRACT,
                                                                row1_.vendor_no,
                                                                Value_);
                    insert into BL_PURCHASE_ORDER_RETRUN(
                                    INSPECT_NO ,                                                                      
                                    CONTRACT,
                                    VENDOR_NO,
                                    STATE,
                                    price_with_tax,
                                    blorder_no,
                                    RETURN_TYPE,
                                    LABEL_NOTE)
                     select   Value_,
                              row1_.CONTRACT,
                              row1_.VENDOR_NO,
                              '3',
                              decode(row_.VAT_DB,'Y','TRUE','FALSE'),
                              row2_.blorder_no,
                              '1',
                              row2_.label_note
                     from dual;
                     PKG_A.Set_Item_Value(Name_,Value_,Attr_);
                     v_ := v_ + 1;
                     pur_order_no_(v_) :=Value_;
                end if ;
                INSPECT_NO_LINE_ := BL_PORDER_RETRUN_DTL_API.getInspectLineNo(Value_);
                insert into BL_PURCHASE_ORDER_RETRUN_DTL(
                            INSPECT_NO,
                            INSPECT_NO_LINE,
                            CONTRACT,
                            ORDER_NO,
                            LINE_NO,
                            RELEASE_NO,
                            RECEIPT_NO,
                            QTY_TO_INSPECT,
                            PART_NO,
                            PICKLISTNO,
                            FBUY_UNIT_PRICE,
                            fbuy_tax_unit_price,
                            STATE,
                            REASON,
                            REASON_DESCT,
                            RMA_NO,
                            rma_line_no,
                            DEF_VAT_CODE,
                            RECEIPT_RETURN_TYPE,
                            LOT_BATCH_NO)
            SELECT   Value_,
                     INSPECT_NO_LINE_,
                     row1_.CONTRACT, 
                     row1_.ORDER_NO, 
                     row1_.LINE_NO,
                     row1_.RELEASE_NO, 
                     1,
                     ROW_.QTY_TO_RETURN,
                     row_.CATALOG_NO, 
                     row_.PICKLISTNO,
                     row1_.FBUY_UNIT_PRICE,
                     row1_.fbuy_tax_unit_price, 
                     '3' ,
                     row_.RETURN_REASON_CODE,
                     row_.RETURN_REASON_DESCRIPTION,
                     row_.RMA_NO,
                     row_.rma_line_no,
                     row_.FEE_CODE,
                     'CREDIT',
                     row_.LOT_BATCH_NO
                FROM dual ;
              end if ;
          fetch  cur1_ into row1_;
         end loop ;
         close cur1_;
      fetch cur_ into row_;
    end loop;
    close cur_;
    i_ :=1;
    loop 
      exit when i_ > v_;
       Return_PurchaseRelease_(pur_order_no_(i_),user_id_,a311_key_);
       i_ := i_+1;
    end loop;
    return ;
  end;
  PROCEDURE Return_PurchaseRelease_(INSPECT_NO_ VARCHAR2,
                                   USER_ID_ VARCHAR2,
                                   A311_KEY_ VARCHAR2)--自动生成客户订单的申请
   is
    cur_ t_cursor;
    cur1_ t_cursor;
    cur2_ t_cursor;
    cur3_ t_cursor;
    Attr_ varchar2(4000);
    attr1_ varchar2(4000);
    attr2_ varchar2(4000);
    Record_Separator_ VARCHAR2(10);
    Field_Separator_  VARCHAR2(10);
    Index_           NUMBER;
    Name_            VARCHAR2(100);
    Value_           VARCHAR2(100);
    row_  BL_V_PURCHASE_ORDER_RETRUN_DTL%rowtype;
    row1_ customer_order_line_tab%rowtype;
    row2_ customer_order_tab%rowtype;
    row3_ BL_V_RETURN_MATERIAL%rowtype;
    row4_ BL_PURCHASE_ORDER_RETRUN%rowtype;
    row5_ bl_return_material%rowtype;
    row6_ bl_return_material_line%rowtype;
    rowh_  return_material%rowtype;
    rowd_  return_material_line%rowtype;
   -- rowlist_ varchar2(4000);
  --  Attr_CUSTOMER_ VARCHAR2(4000);
    info_          varchar2(4000);
 --   objid_         varchar2(4000);
  --  objversion_    varchar2(4000);
     action_        varchar2(100);
    v_ number default 0;
    i_  number default 0;
    cus_order_no_ dbms_sql.Varchar2_Table;
    Ls_Customer_Inner_  varchar2(100);
    currency_type_ VARCHAR2(100);
    condition_code_  VARCHAR2(100);
    discount_       VARCHAR2(100);
    Percent_  number;
   begin 
     Attr_ :='';
     Field_Separator_  := '|';
     Record_Separator_ := f_Get_Data_Index();
     open cur_ for
     select t.* 
     from  BL_V_PURCHASE_ORDER_RETRUN_DTL t
     where t.INSPECT_NO = INSPECT_NO_
       and t.state='3';
      fetch cur_ into row_;
      while cur_%found loop
        -- 取得保隆订单号
          open  cur3_ for
          select t.*
          from BL_PURCHASE_ORDER_RETRUN t 
          where t.INSPECT_NO = row_.INSPECT_NO;
          fetch  cur3_ into row4_;
          close cur3_; 
        --取得下级的客户订单号（包装件为-1，则取大于0）--fjp 2012-11-16
          open cur1_ for
          select  t3.* 
          from customer_order_line_tab t3 
           inner join  (select t1.order_no,t1.line_no,t1.rel_no 
                         from  customer_order_line_tab t1
                        inner  join  purchase_order_line_tab t
                        on t.order_no = t1.demand_order_ref1
                        and  t.line_no = t1.demand_order_ref2
                        and  t.release_no = t1.demand_order_ref3
                        and t.order_no= row_.ORDER_NO
                        and t.line_no = row_.LINE_NO
                        and t.release_no = row_.release_no) cust_no on  t3.order_no = cust_no.order_no
                                                                    and t3.line_no  = cust_no.line_no
                                                                    and t3.rel_no   = cust_no.rel_no
                                                                    and t3.line_item_no>=0;
                                                                --end（包装件为-1，则取大于0）--fjp 2012-11-16---
          fetch cur1_ into row1_;
          if cur1_%notfound  then 
             Ls_Customer_Inner_ :=Identity_Invoice_Info_Api.Get_Identity_Type(Site_Api.Get_Company(row4_.contract),
                                                       row4_.vendor_no,
                                                       'Supplier');                                   
             --只要是内部供应域均生成退货单号
             IF Ls_Customer_Inner_ = 'INTERN' THEN
                Name_ :=  row4_.vendor_no||'-'||row4_.contract;
                Index_    := Instr(Record_Separator_ || Attr_,
                                       Record_Separator_ || Name_ ||
                                       Field_Separator_);
                if Index_ > 0 then 
                   Value_ := pkg_a.Get_Item_Value(Name_,Attr_);
                else
                 -- 新增客户退货的头
                 attr1_ :='';  
                 rowh_.return_approver_id :='*';
                 rowh_.DATE_REQUESTED := sysdate;
                 rowh_.CONTRACT       := row4_.vendor_no;
                 rowh_.CURRENCY_CODE  := 'CNY';
                 rowh_.CUSTOMER_NO    := row4_.contract;
                 rowh_.CUST_REF       :=  '';
                 rowh_.PRICE_WITH_TAX := row4_.price_with_tax;                     
                 Return_CustomerHeadCommit_(rowh_,attr1_);
                 Value_ := client_sys.Get_Item_Value('RMA_NO',attr1_);
                 pkg_a.Set_Item_Value(Name_,Value_,Attr_);
                 v_ := v_ + 1;
                 cus_order_no_(v_) :=Value_;
                 --更新自建表
                  row5_.rma_no :=Value_;
                  row5_.flag :='3';
                  row5_.flowid := 0;
                  row5_.blorder_no :=row4_.blorder_no;
                  row5_.return_type :='3';
                  bl_return_material_api.Usermodify__(row5_,USER_ID_);
               end if;
               -- 保存明细
                attr1_ :=''; 
                rowd_.RMA_NO :=value_;
                rowd_.CATALOG_NO := ROW_.PART_NO;
                rowd_.PART_NO := ROW_.PART_NO;
                rowd_.CONFIGURATION_ID := '*';
                rowd_.QTY_TO_RETURN :=  row_.QTY_TO_INSPECT;
                rowd_.RETURN_REASON_CODE := row_.REASON;
                
                rowd_.CONTRACT := row4_.vendor_no;
                rowd_.COMPANY := Site_API.Get_Company(row4_.vendor_no);
                Currency_Rate_API.Get_Currency_Rate_Defaults(currency_type_,
                                                   rowd_.conv_factor,
                                                   rowd_.currency_rate,
                                                   rowd_.COMPANY,
                                                   'CNY',
                                                   sysdate);
              ifsapp.Return_Material_Line_API.Get_Price_Info(rowd_.SALE_UNIT_PRICE,
                                                             rowd_.BASE_SALE_UNIT_PRICE,
                                                             discount_,
                                                             rowd_.PRICE_CONV_FACTOR,
                                                             rowd_.FEE_CODE,
                                                             condition_code_,
                                                             row4_.vendor_no,
                                                             'CNY',
                                                             ROW_.PART_NO,
                                                             NULL,
                                                             NULL,
                                                             NULL,
                                                             NULL,
                                                             NULL,
                                                             NULL);
                -- modify fjp  2012-12-06 取没有订单号的税
                rowd_.FEE_CODE := ROW_.DEF_VAT_CODE;
                ---end
                Percent_ := STATUTORY_FEE_API.Get_Percentage(rowd_.COMPANY,
                                                                         rowd_.FEE_CODE);
                rowd_.SALE_UNIT_PRICE_WITH_TAX := (100 + Percent_) *
                                               rowd_.SALE_UNIT_PRICE / 100;
                IF Nvl(rowd_.Fee_Code, 'N') <> 'N' THEN
                    rowd_.Vat_Db := 'Y';
                ELSE
                    rowd_.Vat_Db := 'N';
                END IF;
                Return_CustomerDetailCommit_(rowd_,attr1_); 
                  --插入自建表数据                             
                  row6_.rma_no :=Value_;
                  row6_.rma_line_no := Client_Sys.Get_Item_Value('RMA_LINE_NO', attr1_);
                  row6_.picklistno := row_.PICKLISTNO;
                  row6_.inspect_no :=row_.INSPECT_NO;
                  row6_.inspect_no_line :=row_.INSPECT_NO_LINE;
                  ROW6_.FLAG :='3';
                  row6_.lot_batch_no :=row_.LOT_BATCH_NO;
                  bl_return_material_line_api.Usermodify__(row6_,USER_ID_);  
             end if ;
          else 
              while cur1_%found  loop 
                   Name_ :=  row1_.contract||'-'||row1_.customer_no;
                   Index_    := Instr(Record_Separator_ || Attr_,
                                           Record_Separator_ || Name_ ||
                                           Field_Separator_);
                   if Index_ > 0 then 
                      Value_ := pkg_a.Get_Item_Value(Name_,Attr_);
                   else
                     -- 新增客户退货的头
                     select t.* into row2_ from customer_order_tab t where order_no = row1_.order_no;
                     attr1_ :='';  
                     rowh_.return_approver_id :='*';
                     rowh_.DATE_REQUESTED := sysdate;
                     rowh_.CONTRACT  := row1_.contract;
                     rowh_.CURRENCY_CODE :=row2_.currency_code;
                     rowh_.CUSTOMER_NO := row1_.customer_no;
                     rowh_.CUST_REF := row2_.label_note;
                     rowh_.PRICE_WITH_TAX := row2_.price_with_tax;                       
                     Return_CustomerHeadCommit_(rowh_,attr1_);
                     Value_ := client_sys.Get_Item_Value('RMA_NO',attr1_);
                     pkg_a.Set_Item_Value(Name_,Value_,Attr_);
                     v_ := v_ + 1;
                     cus_order_no_(v_) :=Value_;
                     --更新自建表
                      row5_.rma_no :=Value_;
                      row5_.flag :='3';
                      row5_.flowid := 0;
                      row5_.blorder_no :=row4_.blorder_no;
                      row5_.label_note :=row4_.label_note;
                      row5_.return_type :='3';
                      row5_.if_first :='0';
                      bl_return_material_api.Usermodify__(row5_,USER_ID_);
                   end if;
                   -- 保存明细
                    attr1_ :=''; 
                    rowd_.RMA_NO :=value_;
                    rowd_.CATALOG_NO := row1_.catalog_no;
                    if nvl(row1_.part_no,'NULL')='NULL'  then 
                       row1_.part_no :=row1_.catalog_no;
                    end if ;
                    rowd_.PART_NO := row1_.part_no;
                    rowd_.CONFIGURATION_ID := row1_.configuration_id;
                    row_.QTY_TO_INSPECT := row_.QTY_TO_INSPECT *(BL_CO_DELIVER_API.Get_Customer_PKGCoefficient_(row1_.order_no,
                                                                                                                row1_.line_no,
                                                                                                                row1_.rel_no,
                                                                                                                row1_.line_item_no,
                                                                                                                row1_.BUY_QTY_DUE));
                    rowd_.QTY_TO_RETURN :=row_.QTY_TO_INSPECT;
                    rowd_.RETURN_REASON_CODE := row_.REASON;
                    rowd_.BASE_SALE_UNIT_PRICE := row1_.base_sale_unit_price;
                    rowd_.SALE_UNIT_PRICE := row1_.sale_unit_price;
                    rowd_.SALE_UNIT_PRICE_WITH_TAX :=row1_.sale_unit_price_with_tax;
                    rowd_.PRICE_CONV_FACTOR :=row1_.price_conv_factor;
                    rowd_.VAT_DB := row1_.vat;
                    rowd_.CONTRACT := row1_.contract;
                    rowd_.FEE_CODE :=row1_.fee_code;
                    rowd_.CURRENCY_RATE := row1_.currency_rate;
                    rowd_.CONV_FACTOR := row1_.conv_factor;
                    rowd_.COMPANY := Site_API.Get_Company(row1_.contract);
                    rowd_.ORDER_NO := row1_.order_no;
                    rowd_.LINE_NO := row1_.line_no;
                    rowd_.REL_NO := row1_.rel_no;
                    rowd_.LINE_ITEM_NO := row1_.line_item_no;
                    Return_CustomerDetailCommit_(rowd_,attr1_); 
                      --插入自建表数据                             
                      row6_.rma_no :=Value_;
                      row6_.rma_line_no := Client_Sys.Get_Item_Value('RMA_LINE_NO', attr1_);
                      row6_.picklistno := row_.PICKLISTNO;
                      row6_.inspect_no :=row_.INSPECT_NO;
                      row6_.inspect_no_line :=row_.INSPECT_NO_LINE;
                      ROW6_.FLAG :='3';
                      row6_.lot_batch_no :=row_.LOT_BATCH_NO;
                      bl_return_material_line_api.Usermodify__(row6_,USER_ID_);
                     fetch cur1_ into row1_; 
                 end loop;  
             end if;                           
          close cur1_; 
        fetch  cur_ into row_;
      end loop;
      close cur_;
    i_ :=1;
    loop 
      exit when i_ > v_;
      --下达客户退货单
      open cur2_ for
      select t.* from BL_V_RETURN_MATERIAL t where t.RMA_NO = cus_order_no_(i_);
      fetch cur2_
       into row3_;
      if cur2_%notfound then
        close cur2_;
        Raise_Application_Error(-20101, '错误的rowid');
        RETURN;
      end if;
      close cur2_;
      action_ := 'DO';
      RETURN_MATERIAL_API.RELEASE__(info_,
                                    row3_.objid,
                                    row3_.Objversion,
                                    attr2_,
                                    action_);
       Return_CustomerRelease_(cus_order_no_(i_),user_id_,a311_key_);
       i_ := i_+1;
    end loop;
    return ;
      return;
   end;
 PROCEDURE Return_CustomerStock_(rma_no_ number,
                                rma_line_no_ number)
 is 
 cur_ t_cursor;
 cur1_ t_cursor;
 cur2_ t_cursor;
 cur3_ t_cursor;
 row_ bl_v_RETURN_MATERIAL_LINE%rowtype;
 attr_       varchar2(4000);
 info_       varchar2(4000);
 action_     varchar2(100);
 LOCATION_NO_  varchar2(200);
 row1_ bl_location_special%rowtype;
 row2_ BL_PURCHASE_ORDER_RETRUN_DTL%rowtype;
 row3_ bl_return_material_line%rowtype;
 TRANSACTION_ID_ number;
 begin
    open  cur_ for
    select t.*
    from bl_v_RETURN_MATERIAL_LINE t
    where t.rma_no =rma_no_
    and   t.rma_line_no = rma_line_no_;
    fetch cur_ into row_;
    if cur_%notfound  then 
        close cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        RETURN;
    end if ;
    close cur_;
        
     --更新客户退货的状态
     update  bl_return_material_line
     set  flag ='5'
    where   RMA_NO     =  row_.RMA_NO
    and    rma_line_no = row_.rma_line_no ; 
    --获取采购退货的数据 
    open cur1_ for
     select  t.*
     from BL_PURCHASE_ORDER_RETRUN_DTL t 
     where t.RMA_NO = rma_no_
      and  t.RMA_LINE_NO = rma_line_no_;
      fetch   cur1_ into row2_;
      if cur1_%found then 
         Action_ := 'DO';
         Client_Sys.Add_To_Attr('QTY_RECEIVED', row_.QTY_TO_RETURN, Attr_);
        --调用 IFS 接收数量包
        RETURN_MATERIAL_LINE_API.MODIFY__(Info_,
                                          Row_.Objid,
                                          Row_.Objversion,
                                          Attr_,
                                          Action_);
        --获取默认的库位
         open  cur2_ for
         select  t.*
          from bl_location_special t 
          where t.contract = row_.CONTRACT
           and  t.flag='1' ;
          fetch  cur2_ into row1_;
          if cur2_%notfound then 
              LOCATION_NO_ :='11010101';
          else
              LOCATION_NO_  := row1_.location_no;
          end if ; 
          close cur2_;  
          --ifs入库包                            
        Return_Material_Line_API.Inventory_Return__(row_.RMA_NO,
                                                    row_.rma_line_no,
                                                    row_.contract,
                                                    row_.catalog_no,
                                                    '*',
                                                    LOCATION_NO_,
                                                    row_.LOT_BATCH_NO,--批次
                                                    '*',
                                                    '1',
                                                    '*',
                                                    row_.QTY_TO_RETURN,
                                                    '',
                                                    null,
                                                    null); 
    ---ifs出库包
             Inventory_Part_In_Stock_API.Issue_Part_With_Posting( 
                                      row2_.CONTRACT,
                                      row2_.PART_NO,
                                      '*' ,
                                      LOCATION_NO_ ,
                                      row_.LOT_BATCH_NO,
                                      '*',
                                      '1',
                                      '*',
                                      'NISS'  ,
                                      row2_.qty_to_inspect,
                                      0,
                                      '','','','','','','','','','',''
                                        );
                 --获取事物号（根据无采购订单的出库获取）
                 select  nvl(MAX(TRANSACTION_ID),0) 
                  into TRANSACTION_ID_
                 FROM INVENTORY_TRANSACTION_HIST2
                   WHERE /*order_no    = row2_.order_no
                     and RELEASE_NO  = row2_.LINE_NO
                    AND  sequence_no = row2_.RELEASE_NO*/
                        TRANSACTION_CODE='NISS'
                    AND PART_NO  = row2_.PART_NO
                    AND CONTRACT = row2_.CONTRACT
                    AND location_no   = LOCATION_NO_
                    AND lot_batch_no = row_.LOT_BATCH_NO
                    AND serial_no = '*'
                    AND waiv_dev_rej_no ='*'
                    AND eng_chg_level ='1'
                    AND configuration_id ='*';  
                 -- 写保隆表的记录                       
                 INSERT INTO BL_PURRENTURN_DTL_TAB 
                 (PICKLISTNO, TRANSACTION_ID, ORDER_NO, LINE_NO, RELEASE_NO, LOCATION_NO, 
                  LOT_BATCH_NO, SERIAL_NO, ENG_CHG_LEVEL, WAIV_DEV_REJ_NO, 
                  CONFIGURATION_ID, PART_NO, CONTRACT, INSPECT_NO, INSPECT_NO_LINE, 
                  RECEIPT_NO, QTY_IN_STORE)
                 SELECT   row2_.PICKLISTNO,TRANSACTION_ID_ , row2_.ORDER_NO, row2_.LINE_NO,row2_.RELEASE_NO, LOCATION_NO_,row_.LOT_BATCH_NO ,
                   '*', '1', '*' ,'*', row2_.PART_NO,row2_.CONTRACT,row2_.INSPECT_NO,
                   row2_.INSPECT_NO_LINE,row2_.RECEIPT_NO,row2_.qty_to_inspect from dual;

               --- 更新采购退货状态
                  update  BL_PURCHASE_ORDER_RETRUN_DTL
                   set    STATE='5'
                  where   INSPECT_NO =  row2_.INSPECT_NO
                   and   INSPECT_NO_LINE = row2_.INSPECT_NO_LINE;                     
         ---下级菜单
         open cur3_ for
         select t.* 
         from bl_return_material_line t
         where t.INSPECT_NO = row2_.inspect_no
         and   t.INSPECT_NO_LINE = row2_.inspect_no_line;
         fetch cur3_ into row3_;
         if cur3_%found  then
              Return_CustomerStock_(row3_.rma_no,row3_.rma_line_no);
         end if ;
         close cur3_;
        fetch   cur1_ into row2_;
      end if ;
      close cur1_;                                                                             
    return;
 end ; 
 PROCEDURE Return_PurchaseStock_(INSPECT_NO_ varchar2,  
                                 INSPECT_NO_LINE_ number)
 is
 cur_ t_cursor;
 row_ bl_return_material_line%rowtype;
 begin
   open cur_ for
     select t.* 
     from bl_return_material_line t
     where t.INSPECT_NO = INSPECT_NO_
     and   t.INSPECT_NO_LINE = INSPECT_NO_LINE_;
     fetch cur_ into row_;
     if cur_%found  then
          Return_CustomerStock_(row_.rma_no,row_.rma_line_no);
     end if ;
     close cur_;
   return;
 end; 
 PROCEDURE Return_CustomerHeadCommit_(ROW_ return_material%rowtype,attr1_ out varchar2)
  is
   Attr_CUSTOMER_  varchar2(4000);
    info_          varchar2(4000);
    objid_         varchar2(4000);
    objversion_    varchar2(4000);
    action_        varchar2(100);
  begin
     client_sys.Add_To_Attr('RETURN_APPROVER_ID',row_.return_approver_id,attr1_);
     client_sys.Add_To_Attr('DATE_REQUESTED',row_.date_requested,attr1_);
     client_sys.Add_To_Attr('CONTRACT',row_.contract,attr1_);
     client_sys.Add_To_Attr('CURRENCY_CODE',row_.currency_code,attr1_);
     client_sys.Add_To_Attr('CUSTOMER_NO',row_.customer_no, attr1_);
     client_sys.Add_To_Attr('CUST_REF',row_.cust_ref, attr1_);
     client_sys.Add_To_Attr('PRICE_WITH_TAX',row_.price_with_tax,attr1_);
     Client_Sys.Add_To_Attr('CONTRACT', row_.contract, Attr_CUSTOMER_);
     Client_Sys.Add_To_Attr('CUSTOMER_NO',row_.customer_no,Attr_CUSTOMER_);
     Customer_Order_API.Get_Customer_Defaults__(Attr_CUSTOMER_);
      client_sys.Add_To_Attr('SHIP_ADDR_NO',
                             Client_Sys.Get_Item_Value('SHIP_ADDR_NO',
                                                       Attr_CUSTOMER_),
                             attr1_);
      client_sys.Add_To_Attr('LANGUAGE_CODE',
                             Client_Sys.Get_Item_Value('LANGUAGE_CODE',
                                                       Attr_CUSTOMER_),
                                 attr1_);
        client_sys.Add_To_Attr('CUSTOMER_NO_ADDR_NO',
                               Client_Sys.Get_Item_Value('BILL_ADDR_NO',
                                                         Attr_CUSTOMER_),
                                       attr1_);                             
      action_ := 'DO';
     RETURN_MATERIAL_API.New__(info_, objid_, objversion_, attr1_, action_);
     return;
  end;
  PROCEDURE Return_CustomerDetailCommit_(ROW_ return_material_line%rowtype,
                                       attr1_ out varchar2) 
   is
    info_          varchar2(4000);
    objid_         varchar2(4000);
    objversion_    varchar2(4000);
    action_        varchar2(100);
   begin
      client_sys.Add_To_Attr('RMA_NO',row_.rma_no,attr1_);
      client_sys.Add_To_Attr('CATALOG_NO',row_.catalog_no,attr1_);
      client_sys.Add_To_Attr('PART_NO',row_.part_no,attr1_);
      client_sys.Add_To_Attr('CONFIGURATION_ID',row_.configuration_id,attr1_);
      client_sys.Add_To_Attr('QTY_TO_RETURN',row_.qty_to_return, attr1_);
      client_sys.Add_To_Attr('RETURN_REASON_CODE',row_.return_reason_code,attr1_);
      client_sys.Add_To_Attr('BASE_SALE_UNIT_PRICE',row_.base_sale_unit_price,attr1_);
      client_sys.Add_To_Attr('SALE_UNIT_PRICE',row_.sale_unit_price,attr1_);
      client_sys.Add_To_Attr('SALE_UNIT_PRICE_WITH_TAX',row_.sale_unit_price_with_tax,attr1_);
      client_sys.Add_To_Attr('PRICE_CONV_FACTOR',row_.price_conv_factor,attr1_);
      client_sys.Add_To_Attr('VAT_DB',row_.vat_db,attr1_);
      client_sys.Add_To_Attr('CONTRACT',row_.contract,attr1_);
      client_sys.Add_To_Attr('FEE_CODE',row_.fee_code,attr1_);
      client_sys.Add_To_Attr('CURRENCY_RATE',row_.currency_rate,attr1_);
      client_sys.Add_To_Attr('CONV_FACTOR',row_.conv_factor,attr1_);
      client_sys.Add_To_Attr('COMPANY',Site_API.Get_Company(row_.contract), attr1_);
      client_sys.Add_To_Attr('ORDER_NO',row_.order_no,attr1_);
      client_sys.Add_To_Attr('LINE_NO',row_.line_no,attr1_);
      client_sys.Add_To_Attr('REL_NO',row_.rel_no, attr1_);
      client_sys.Add_To_Attr('LINE_ITEM_NO',row_.line_item_no, attr1_);
      action_ := 'DO';
      RETURN_MATERIAL_LINE_API.New__(info_,
                                     objid_,
                                     objversion_,
                                     attr1_,
                                     action_);
    return ;
   end;     
end BL_RETURN_MATERIAL1_API;
/
