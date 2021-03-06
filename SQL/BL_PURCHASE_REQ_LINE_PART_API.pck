create or replace package BL_PURCHASE_REQ_LINE_PART_API is

  PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE CHANGE_TO_PLANNED__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE Modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE RELEASE__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE REMOVE__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  --PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_ varchar2, ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_ varchar2, ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,OUTROWLIST_ OUT VARCHAR2);
  function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2)  return varchar2 ;
  function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 ) return varchar2 ;
end BL_PURCHASE_REQ_LINE_PART_API;
/
create or replace package body BL_PURCHASE_REQ_LINE_PART_API is
 type t_cursor is ref cursor; 
  PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
   attr_  varchar2(4000);
 info_ varchar2(4000);
 objid_ varchar2(4000);
 objversion_  varchar2(4000);
 action_  varchar2(100);
 attr_out varchar2(4000);
 ls_contract_   varchar2(100);
 ls_requisition_no_ varchar2(20);
 cur_ t_cursor;
 BEGIN 
    --  初始化新增页面
    action_ := 'PREPARE';
    attr_ :=  pkg_a.Get_Attr_By_bm(ROWLIST_);
   -- ls_requisition_no_ :=client_sys.Get_Item_Value('REQUISITION_NO',attr_);    
    PURCHASE_REQ_LINE_PART_API.New__(info_,objid_,objversion_ ,attr_,action_);
    attr_out := pkg_a.Get_Attr_By_Ifs(attr_);
/*    --初始化明细域
     open cur_ for 
     select  CONTRACT  
      from BL_V_PURCHASE_REQUISITION  
      where  REQUISITION_NO= ls_requisition_no_ 
      and rownum =1;
      fetch cur_ into ls_contract_;
      if cur_%found then 
         pkg_a.Set_Item_Value('CONTRACT',  ls_contract_  ,    attr_out);  
         close cur_;
      end if ;
      close cur_;
      
   */
    pkg_a.setResult(A311_KEY_,attr_out);    
    RETURN;
 END;

PROCEDURE CHANGE_TO_PLANNED__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
  cur_ t_cursor;
 attr_ varchar2(4000);
 info_ varchar2(4000);
 objid_ varchar2(4000);
 objversion_ varchar2(4000);
 action_ varchar2(100);
 BEGIN 
   open cur_ for 
   select objid,objversion
   from BL_V_PURCHASE_REQ_LINE_PART t
   where t.objid = rowid_ ;
   fetch cur_ into objid_,objversion_;
   if cur_%notfound then
      close  cur_;
      raise_application_error(-20101,'错误的rowid');
      return ;
   end if ;
   close  cur_;
   action_ :='DO';
   PURCHASE_REQ_LINE_PART_API.Change_To_Planned__( info_, objid_, objversion_, attr_, action_ );
   pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_REQ_LINE_PART',objid_); 
   RETURN;
 END;

PROCEDURE Modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 row_  BL_V_PURCHASE_REQ_LINE_PART%rowtype;
 attr_ varchar2(4000);
 info_ varchar2(4000);
 objid_ varchar2(4000);
 objversion_ varchar2(4000);
 action_ varchar2(100);
 index_ varchar2(1);
 cur_ t_cursor;
 pos_ number;
 pos1_ number;
 i number;
 v_ varchar2(1000);
 column_id_ varchar2(4000);
 data_ varchar2(4000);
   doaction_ varchar(10);
 BEGIN 
  index_ :=f_get_data_index();
  row_.objid :=pkg_a.Get_Item_Value('OBJID',index_ || ROWLIST_);
   doaction_ := pkg_a.Get_Item_Value('DOACTION', ROWLIST_);
   if doaction_ = 'I' then    /*新增*/
        attr_ := '';
        client_sys.Add_To_Attr('REQUISITION_NO',pkg_a.Get_Item_Value('REQUISITION_NO',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('LINE_NO',pkg_a.Get_Item_Value('LINE_NO',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('RELEASE_NO',pkg_a.Get_Item_Value('RELEASE_NO',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('CONTRACT',pkg_a.Get_Item_Value('CONTRACT',ROWLIST_),attr_  );
        client_sys.Add_To_Attr('PART_NO',pkg_a.Get_Item_Value('PART_NO',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('DESCRIPTION',pkg_a.Get_Item_Value('DESCRIPTION',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('PRICE_WITH_TAX',pkg_a.Get_Item_Value('PRICE_WITH_TAX',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('ORIGINAL_QTY',pkg_a.Get_Item_Value('ORIGINAL_QTY',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('UNIT_MEAS',pkg_a.Get_Item_Value('UNIT_MEAS',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('WANTED_RECEIPT_DATE',pkg_a.Get_Item_Value('WANTED_RECEIPT_DATE',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('LATEST_ORDER_DATE',pkg_a.Get_Item_Value('LATEST_ORDER_DATE',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('VENDOR_NO',pkg_a.Get_Item_Value('VENDOR_NO',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('CONVERSION_FAC',pkg_a.Get_Item_Value('CONVERSION_FAC',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('BUY_UNIT_MEAS',pkg_a.Get_Item_Value('BUY_UNIT_MEAS',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('REQUEST_TYPE','Request for Purchase',attr_ );
        client_sys.Add_To_Attr('FBUY_UNIT_PRICE',pkg_a.Get_Item_Value('FBUY_UNIT_PRICE',ROWLIST_),attr_ );
       -- client_sys.Add_To_Attr('FBUY_TAX_UNIT_PRICE','9.59',attr_ );
        client_sys.Add_To_Attr('CURRENCY_CODE',pkg_a.Get_Item_Value('CURRENCY_CODE',ROWLIST_),attr_);
        client_sys.Add_To_Attr('BUY_UNIT_PRICE',pkg_a.Get_Item_Value('BUY_UNIT_PRICE',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('FBUY_TAX_UNIT_PRICE',pkg_a.Get_Item_Value('FBUY_TAX_UNIT_PRICE',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('DISCOUNT',pkg_a.Get_Item_Value('DISCOUNT',ROWLIST_),attr_ );
       -- client_sys.Add_To_Attr('ADDITIONAL_COST_AMOUNT','0',attr_ );
        client_sys.Add_To_Attr('CONTACT',pkg_a.Get_Item_Value('CONTACT',ROWLIST_),attr_);
        client_sys.Add_To_Attr('ASSORTMENT',pkg_a.Get_Item_Value('ASSORTMENT',ROWLIST_),attr_);
        client_sys.Add_To_Attr('BUYER_CODE',pkg_a.Get_Item_Value('BUYER_CODE',ROWLIST_),attr_ );
       -- client_sys.Add_To_Attr('PROCESS_TYPE','',attr_ );
        client_sys.Add_To_Attr('SUPPLIER_SPLIT_DB','NO_SPLIT',attr_ );
        --client_sys.Add_To_Attr('MANUFACTURER_ID','',attr_ );
        --client_sys.Add_To_Attr('MANUFACTURER_PART_NO','',attr_ );
        client_sys.Add_To_Attr('DEMAND_CODE',pkg_a.Get_Item_Value('DEMAND_CODE',ROWLIST_),attr_ );
       -- client_sys.Add_To_Attr('WANTED_DELIVERY_DATE','',attr_ );
        client_sys.Add_To_Attr('CURRENCY_RATE',pkg_a.Get_Item_Value('CURRENCY_RATE',ROWLIST_),attr_ );
       -- client_sys.Add_To_Attr('DEMAND_CODE_DB','IO',attr_ );
        action_:='DO'; 
        PURCHASE_REQ_LINE_PART_API.New__(info_,objid_,objversion_ ,attr_,action_);
        pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_REQ_LINE_PART',objid_);
        RETURN;      
    end if  ;
 if doaction_ = 'M' then  /*修改*/
  open cur_
  for select t.* 
  from BL_V_PURCHASE_REQ_LINE_PART t
  where t.objid = row_.objid ;
  fetch cur_ into row_;
  if cur_%notfound then
     close  cur_;
     raise_application_error(-20101,'错误的rowid');
     return ;
  end if ;
  close cur_;
   data_ :=rowlist_ ;
   pos_ :=instr(data_,index_);
   i  :=i+1 ;
   loop
     exit when nvl(pos_,0) <= 0;
     exit when i >300 ;
     v_ :=substr(data_,1,pos_ - 1 );
     data_ :=substr(data_,pos_ + 1);
     pos_ :=instr(data_,index_) ;
           pos1_ :=  instr(v_,'|');     
      column_id_ := substr(v_,1 ,pos1_ - 1 );    
      if column_id_ <>  'OBJID'  and  column_id_ <> 'DOACTION' and length(nvl(column_id_,'')) > 0  then
         v_ := substr(v_, pos1_ +  1 ) ;
         client_sys.Add_To_Attr(column_id_,v_,attr_ );
         i := i + 1 ;
      end if ;    
    end  loop ;
    
    action_:='DO'; 
    PURCHASE_REQ_LINE_PART_API.Modify__(info_,row_.OBJID,row_.OBJVERSION,attr_,action_);
    pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_REQ_LINE_PART',objid_); 
    RETURN ;
 end if;
 if doaction_ = 'D'  then--明细删除 
     open cur_
    for select t.*
    from    BL_V_PURCHASE_REQ_LINE_PART t
    where  t.OBJID =   row_.OBJID;
    fetch cur_     into row_   ;
    if cur_%notfound then       
           
       raise_application_error(-20101, '错误的rowid');
       return ;
    end if ;    
    close cur_ ;  
     action_:='CHECK'; 
    PURCHASE_REQ_LINE_PART_API.REMOVE__(info_,row_.OBJID,row_.OBJVERSION,action_);
    action_:='DO'; 
    PURCHASE_REQ_LINE_PART_API.REMOVE__(info_,row_.OBJID,row_.OBJVERSION,action_);
    pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_REQ_LINE_PART',row_.OBJID);
    RETURN;
 end if ;
 END;

PROCEDURE RELEASE__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 cur_ t_cursor;
 attr_ varchar2(4000);
 info_ varchar2(4000);
 objid_ varchar2(4000);
 objversion_ varchar2(4000);
 action_ varchar2(100);
 BEGIN 
   open cur_ for 
   select objid,objversion
   from BL_V_PURCHASE_REQ_LINE_PART t
   where t.objid = rowid_ ;
   fetch cur_ into objid_,objversion_;
   if cur_%notfound then
      close  cur_;
      raise_application_error(-20101,'错误的rowid');
      return ;
   end if ;
   close  cur_;
   action_ :='DO';
   PURCHASE_REQ_LINE_PART_API.RELEASE__( info_, objid_, objversion_, attr_, action_ );
   pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_REQ_LINE_PART',objid_); 
   RETURN;
 END;

PROCEDURE REMOVE__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 info_ varchar2(4000);
 objid_ varchar2(4000);
 objversion_  varchar2(4000);
 action_  varchar2(100);
 cur_ t_cursor;
 BEGIN 
   objid_  :=rowid_;
   open cur_  for 
   select objversion 
   from BL_V_PURCHASE_REQUISITION
   where objid = objid_;
   fetch cur_ into objversion_;
   if cur_%notfound  then
     close cur_;
     pkg_a.setFailed(A311_KEY_,'BL_V_PURCHASE_REQ_LINE_PART',objid_); 
     raise_application_error(-20101, '错误的rowid');
     RETURN;
   end if ;
   close  cur_;
   -- 检测
   action_ :='CHECK';
   PURCHASE_REQ_LINE_PART_API.REMOVE__( info_, objid_, objversion_, action_);
   --保存
   action_ :='DO';
   PURCHASE_REQ_LINE_PART_API.REMOVE__( info_, objid_, objversion_, action_);
   pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_REQ_LINE_PART',objid_); 
   RETURN;
 END;
PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_ varchar2, ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,OUTROWLIST_  out VARCHAR2)
 IS 
 attr_  varchar2(4000);
 info_ varchar2(4000);
 objid_ varchar2(4000);
 objversion_  varchar2(4000);
 action_  varchar2(100);
 attr_out varchar2(4000);
 row_ BL_V_PURCHASE_REQ_LINE_PART%rowtype;
 main_row_ BL_V_PURCHASE_REQUISITION%rowtype;
 price_conv_factor_          NUMBER;
 price_unit_meas_            VARCHAR2(20);
 discount_                   NUMBER;
 additional_cost_amount_     NUMBER;
 curr_rate_                  NUMBER;
 curr_code_                  varchar2(20);
 BEGIN 
   if  column_id_ = 'PART_NO' then
        main_row_.CONTRACT := pkg_a.Get_Item_Value('CONTRACT',MAINROWLIST_);
        main_row_.REQUISITION_NO := pkg_a.Get_Item_Value('REQUISITION_NO',MAINROWLIST_);
        row_.PART_NO := pkg_a.Get_Item_Value('PART_NO',ROWLIST_); 
        --零件描述  
        row_.DESCRIPTION    :=Purchase_Part_API.Get_Description(main_row_.CONTRACT,row_.PART_NO);
        --库存单位
        row_.UNIT_MEAS      := Inventory_Part_API.Get_Unit_Meas(main_row_.CONTRACT,row_.PART_NO);
        --供应商号
        row_.VENDOR_NO      := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(main_row_.CONTRACT,row_.PART_NO);
        --供应商明
        row_.VENDOR_NAME    :=Supplier_API.Get_Vendor_Name(row_.VENDOR_NO);
        --转换系数
        row_.CONVERSION_FAC :=Purchase_Part_Supplier_API.Get_Conv_Factor(main_row_.CONTRACT,row_.PART_NO,row_.VENDOR_NO);
        -- 采购单位
        row_.BUY_UNIT_MEAS  :=Purchase_Part_Supplier_API.Get_Buy_Unit_Meas(main_row_.CONTRACT,row_.PART_NO,row_.VENDOR_NO);
        -- 含税
        row_.PRICE_WITH_TAX :=IDENTITY_INVOICE_INFO_API.Price_With_Tax( Site_API.Get_Company(main_row_.CONTRACT),row_.VENDOR_NO,'SUPPLIER');
        -- 货币代码
        row_.CURRENCY_CODE  := RTRIM(Supplier_API.Get_Currency_Code(row_.VENDOR_NO));
        --参考
        row_.CONTACT        :=Supplier_Address_API.Get_Contact(row_.VENDOR_NO,Supplier_Address_Api.Get_Address_No(row_.VENDOR_NO,IFSAPP.Address_Type_Code_API.Get_Client_Value(1)));
        -- 供应商分类
        row_.ASSORTMENT     :=Purchase_Part_Supplier_API.Get_Assortment(main_row_.CONTRACT,row_.PART_NO,row_.VENDOR_NO);
        --采购员（未找到采购员的值）
        row_.BUYER_CODE     :='*' ;
        pkg_a.Set_Item_Value('CONTRACT',    main_row_.CONTRACT,   attr_out);
        pkg_a.Set_Item_Value('DESCRIPTION',   row_.DESCRIPTION,   attr_out);         
        pkg_a.Set_Item_Value('UNIT_MEAS',     row_.UNIT_MEAS,     attr_out); 
        pkg_a.Set_Item_Value('VENDOR_NO',     row_.VENDOR_NO,     attr_out); 
        pkg_a.Set_Item_Value('VENDOR_NAME',   row_.VENDOR_NAME,   attr_out); 
        pkg_a.Set_Item_Value('CONVERSION_FAC',row_.CONVERSION_FAC,attr_out);
        pkg_a.Set_Item_Value('BUY_UNIT_MEAS', row_.BUY_UNIT_MEAS, attr_out); 
        pkg_a.Set_Item_Value('PRICE_WITH_TAX',row_.PRICE_WITH_TAX,attr_out);   
        pkg_a.Set_Item_Value('CURRENCY_CODE', row_.CURRENCY_CODE, attr_out); 
        pkg_a.Set_Item_Value('CONTACT',       row_.CONTACT,       attr_out); 
        pkg_a.Set_Item_Value('ASSORTMENT',    row_.ASSORTMENT,    attr_out);   
        pkg_a.Set_Item_Value('BUYER_CODE',    row_.BUYER_CODE,    attr_out);                                                                   
    end if;
    if  column_id_ = 'ORIGINAL_QTY' then 
         row_.CONTRACT  := pkg_a.Get_Item_Value('CONTRACT',MAINROWLIST_);
         row_.PART_NO   := pkg_a.Get_Item_Value('PART_NO',ROWLIST_); 
         row_.VENDOR_NO := pkg_a.Get_Item_Value('VENDOR_NO',ROWLIST_); 
         row_.ORIGINAL_QTY := pkg_a.Get_Item_Value('ORIGINAL_QTY',ROWLIST_); 
         purchase_part_supplier_api.get_price_info__(price_conv_factor_ =>price_conv_factor_,
                                              price_unit_meas_ => price_unit_meas_,
                                              discount_ => discount_,
                                              additional_cost_amount_ => additional_cost_amount_,
                                              curr_rate_ => curr_rate_,
                                              buy_unit_price_ => row_.buy_unit_price,
                                              fbuy_unit_price_ => row_.FBUY_UNIT_PRICE,
                                              curr_code_ => curr_code_,
                                              contract_ => row_.CONTRACT,
                                              part_no_ => row_.PART_NO,
                                              vendor_no_ => row_.VENDOR_NO,
                                              qty_purchase_ => null,
                                              price_date_ =>null,
                                              currency_type_ => null,
                                              service_type_ => null,
                                              condition_code_ => null,
                                              exchange_item_ => null);
                                              
        pkg_a.Set_Item_Value('CURRENCY_RATE',      curr_rate_,       attr_out);
        pkg_a.Set_Item_Value('ORIGINAL_QTY',       row_.ORIGINAL_QTY,       attr_out);   
        pkg_a.Set_Item_Value('BUY_UNIT_PRICE',     row_.buy_unit_price,    attr_out);   --价格取值不对  
        PKG_A.Set_Item_Value('FBUY_UNIT_PRICE',    ROW_.FBUY_UNIT_PRICE,attr_out);
        PKG_A.Set_Item_Value('FBUY_TAX_UNIT_PRICE',ROW_.FBUY_UNIT_PRICE,attr_out);
    end if ;
    if column_id_ = 'VENDOR_NO' then 
         main_row_.CONTRACT := pkg_a.Get_Item_Value('CONTRACT',MAINROWLIST_);
         row_.PART_NO := pkg_a.Get_Item_Value('PART_NO',ROWLIST_); 
         row_.VENDOR_NO     :=pkg_a.Get_Item_Value('VENDOR_NO',ROWLIST_);
         row_.VENDOR_NAME    :=Supplier_API.Get_Vendor_Name(row_.VENDOR_NO);
         row_.CONVERSION_FAC :=Purchase_Part_Supplier_API.Get_Conv_Factor(main_row_.CONTRACT,row_.PART_NO,row_.VENDOR_NO);
         row_.BUY_UNIT_MEAS  :=Purchase_Part_Supplier_API.Get_Buy_Unit_Meas(main_row_.CONTRACT,row_.PART_NO,row_.VENDOR_NO);
         row_.PRICE_WITH_TAX :=IDENTITY_INVOICE_INFO_API.Price_With_Tax( Site_API.Get_Company(main_row_.CONTRACT),row_.VENDOR_NO,'SUPPLIER');
         row_.CURRENCY_CODE  := RTRIM(Supplier_API.Get_Currency_Code(row_.VENDOR_NO));
         row_.CONTACT        :=Supplier_Address_API.Get_Contact(row_.VENDOR_NO,Supplier_Address_Api.Get_Address_No(row_.VENDOR_NO,IFSAPP.Address_Type_Code_API.Get_Client_Value(1)));
         row_.ASSORTMENT     :=Purchase_Part_Supplier_API.Get_Assortment(main_row_.CONTRACT,row_.PART_NO,row_.VENDOR_NO);
        pkg_a.Set_Item_Value('VENDOR_NAME',   row_.VENDOR_NAME,   attr_out); 
        pkg_a.Set_Item_Value('CONVERSION_FAC',row_.CONVERSION_FAC,attr_out);
        pkg_a.Set_Item_Value('BUY_UNIT_MEAS', row_.BUY_UNIT_MEAS, attr_out); 
        pkg_a.Set_Item_Value('PRICE_WITH_TAX',row_.PRICE_WITH_TAX,attr_out);   
        pkg_a.Set_Item_Value('CURRENCY_CODE', row_.CURRENCY_CODE, attr_out); 
        pkg_a.Set_Item_Value('CONTACT',       row_.CONTACT,       attr_out); 
        pkg_a.Set_Item_Value('ASSORTMENT',    row_.ASSORTMENT,    attr_out);   
    end if ;
     OUTROWLIST_ := attr_out;
    -- pkg_a.setResult(A311_KEY_,attr_out);   
 end  ;
 function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 )
 return varchar2 
 is
  row_   BL_V_PURCHASE_REQ_LINE_PART%rowtype;
 begin
      row_.OBJID := pkg_a.Get_Item_Value('OBJID',rowlist_);
      row_.ORDER_NO := pkg_a.Get_Item_Value('ORDER_NO',rowlist_);
      row_.STATE    := pkg_a.Get_Item_Value('STATE',rowlist_);
      if row_.OBJID = '' or row_.OBJID = 'NULL' then  
          return '1';
      else
        if column_id_='PART_NO'  or column_id_='PRICE_WITH_TAX'  or column_id_='LINE_NO' or column_id_='RELEASE_NO' then 
           return '0';
        end if ;
        if row_.STATE = 'Released' and (column_id_='ORIGINAL_QTY'  or column_id_='DESCRIPTION') then 
           return '0';
        end if ;
        if nvl(row_.ORDER_NO,'NULL') <>'NULL'  then 
           return '0';
        end if ;
      end if ;
     return '1';
 end  ;
 ----检查添加行 删除行 
 function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2 
   is
   row_ BL_V_PURCHASE_REQUISITION%rowtype;
   cur_ t_cursor;
  begin
    open cur_ for 
    select t.* 
    from BL_V_PURCHASE_REQUISITION t 
    where t.REQUISITION_NO = order_no_;
     fetch  cur_ into row_;
     close cur_;
     if row_.STATE='Closed' or row_.STATE='Authorized'  then 
        return '0';
     end if;
      return '1';  
 end;
end BL_PURCHASE_REQ_LINE_PART_API;
/
