create or replace package BL_CUSTOMER_ORDER_CHARGE_API is

PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
PROCEDURE modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
PROCEDURE remove__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2); 
PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_ varchar2, ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,OUTROWLIST_  OUT VARCHAR2);
function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 ) return varchar2 ;
----检查编辑 修改
 function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2 ;

end BL_CUSTOMER_ORDER_CHARGE_API;
/
create or replace package body BL_CUSTOMER_ORDER_CHARGE_API is
  
     TYPE T_CURSOR  IS REF  CURSOR ;
 PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 attr_  varchar2(4000);
 info_ varchar2(4000);
 objid_ varchar2(4000);
 objversion_  varchar2(4000);
 action_  varchar2(100);
 attr_out varchar2(4000);
 cur_ T_CURSOR;
 row_  BL_V_CUSTOMER_ORDER%rowtype;
 BEGIN 
    action_ := 'PREPARE';
    row_.ORDER_NO := pkg_a.Get_Item_Value('ORDER_NO',ROWLIST_)  ;
   if row_.ORDER_NO is null  then
     return;
   end if ; 
   open cur_
   for select t.*
   from    BL_V_CUSTOMER_ORDER t
   where  t.ORDER_NO =   row_.ORDER_NO;
   fetch cur_     into row_   ;
   if cur_%notfound then       
      close cur_ ; 
      return ;
   end if ;    
   close cur_ ; 
      open cur_ for 
      select PRICE_WITH_TAX 
      from   customer_order_tab t
      where  t.ORDER_NO =   row_.ORDER_NO ;      
      fetch   cur_   into row_.PRICE_WITH_TAX   ;
      close   cur_;  
    client_sys.Add_To_Attr('CONTRACT',pkg_a.Get_Item_Value('CONTRACT',ROWLIST_),attr_ );
    client_sys.Add_To_Attr('ORDER_NO',pkg_a.Get_Item_Value('ORDER_NO',ROWLIST_),attr_ );
    CUSTOMER_ORDER_CHARGE_API.New__(info_,objid_,objversion_ ,attr_,action_);
    attr_out := pkg_a.Get_Attr_By_Ifs(attr_);    
    pkg_a.Set_Item_Value('CONTRACT',row_.CONTRACT,attr_out);
    pkg_a.Set_Item_Value('PRICE_WITH_TAX',row_.PRICE_WITH_TAX,attr_out);  
    pkg_a.setResult(A311_KEY_,attr_out); 
   RETURN;
 END;
 PROCEDURE modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
  row_   BL_V_CUSTOMER_ORDER_CHARGE%rowtype;
  attr_  varchar2(4000);
  info_ varchar2(4000);
  objid_ varchar2(4000);
  objversion_  varchar2(4000);
  action_  varchar2(100);
  index_ varchar2(1);
  cur_  t_cursor;
  pos_ number ;
  pos1_ number ;
  i number ;
  v_  varchar(1000);
  column_id_ varchar(1000);
  data_ varchar(4000);
  doaction_ varchar(10);
 
 BEGIN 
        index_ := f_get_data_index();
        row_.OBJID   := pkg_a.Get_Item_Value('OBJID',index_ || ROWLIST_);
        doaction_ := pkg_a.Get_Item_Value('DOACTION', ROWLIST_);
   if   doaction_ = 'I' then  /*收费新增*/
        attr_ := '';
        client_sys.Add_To_Attr('CHARGE_TYPE',pkg_a.Get_Item_Value('CHARGE_TYPE',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('CHARGE_AMOUNT',pkg_a.Get_Item_Value('CHARGE_AMOUNT',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('CHARGE_AMOUNT_WITH_TAX',pkg_a.Get_Item_Value('CHARGE_AMOUNT_WITH_TAX',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('BASE_CHARGE_AMOUNT','0',attr_ );
        client_sys.Add_To_Attr('CHARGED_QTY',pkg_a.Get_Item_Value('CHARGED_QTY',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('SALES_UNIT_MEAS','pcs',attr_ );
        client_sys.Add_To_Attr('COLLECT_DB','INVOICE',attr_ );
        client_sys.Add_To_Attr('FEE_CODE',pkg_a.Get_Item_Value('FEE_CODE',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('CHARGE_COST',pkg_a.Get_Item_Value('CHARGE_COST',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('INVOICED_QTY',pkg_a.Get_Item_Value('INVOICED_QTY',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('PRINT_CHARGE_TYPE_DB','N',attr_ );
        client_sys.Add_To_Attr('PRINT_COLLECT_CHARGE_DB','NO PRINT',attr_ );
        client_sys.Add_To_Attr('ORDER_NO',pkg_a.Get_Item_Value('ORDER_NO',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('CONTRACT',pkg_a.Get_Item_Value('CONTRACT',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('CONTRACT',pkg_a.Get_Item_Value('CONTRACT',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('LINE_NO',pkg_a.Get_Item_Value('LINE_NO',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('REL_NO',pkg_a.Get_Item_Value('REL_NO',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('LINE_ITEM_NO',pkg_a.Get_Item_Value('LINE_ITEM_NO',ROWLIST_),attr_ );

        action_:='DO'; 
        CUSTOMER_ORDER_CHARGE_API.New__(info_,objid_,objversion_ ,attr_,action_);
        pkg_a.setSuccess(A311_KEY_,'BL_V_CUSTOMER_ORDER_CHARGE',objid_);
      RETURN;      
    end if  ;
   if doaction_ = 'M' then/*收费修改*/
      open cur_
      for select t.*
      from    BL_V_CUSTOMER_ORDER_CHARGE t
      where  t.OBJID =   row_.OBJID;
      fetch cur_     into row_   ;
      if cur_%notfound then       
       
         raise_application_error(-20101, '错误的rowid');
         return ;
      end if ;    
      close cur_ ;  
    /*获取有几列发生了修改*/
 
      data_ := ROWLIST_;
      pos_ := instr(data_,index_);
      i := i + 1 ;
    
   loop 
      exit when nvl(pos_,0) <=0 ;
      exit when i > 300 ;      
      v_ := substr(data_,1,pos_ - 1 ); 
      data_ := substr(data_,pos_ +  1 ) ;
      pos_ := instr(data_,index_);  
      
      pos1_ :=  instr(v_,'|');     
      column_id_ := substr(v_,1 ,pos1_ - 1 );    
      if column_id_ <>'OBJID' and  column_id_ <>  'DOACTION'  and length(nvl(column_id_,'')) > 0   then
         v_ := substr(v_, pos1_ +  1 ) ;
         client_sys.Add_To_Attr(column_id_,v_,attr_ );
         i := i + 1 ;
      end if ;    
   end  loop ;
      action_:='DO'; 
      CUSTOMER_ORDER_CHARGE_API.Modify__(info_,row_.OBJID,row_.OBJVERSION,attr_,action_);
      pkg_a.setSuccess(A311_KEY_,'BL_V_CUSTOMER_ORDER_CHARGE',row_.OBJID);
   end if;
   if doaction_ = 'D' then
     open cur_ for
     select t.* from BL_V_CUSTOMER_ORDER_CHARGE t
     where t.objid= row_.objid ;
     fetch cur_ into row_ ;
     if cur_%notfound then
        raise_application_error(-20101,'错误的rowid');
        return ;
     end if ;
     close cur_ ;
     action_:='DO'; 
     CUSTOMER_ORDER_CHARGE_API.Remove__(info_,row_.OBJID,row_.OBJVERSION,action_);
     pkg_a.setSuccess(A311_KEY_,'BL_V_CUSTOMER_ORDER_CHARGE',row_.OBJID);
   end if;
   RETURN;
 END;
 PROCEDURE remove__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 BEGIN 
   RETURN;
 END;
 PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_ varchar2, ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,OUTROWLIST_ OUT VARCHAR2)
 IS 
 info_ varchar2(4000);
 objid_ varchar2(4000);
 objversion_  varchar2(4000);
 action_  varchar2(100);
 attr_out varchar2(4000);
 RateDummy_ FLOAT ;
 sctrec_  IFSAPP.Sales_Charge_Type_API.Public_Rec;
 main_row_ bl_v_customer_order%rowtype;
 row_ bl_v_customer_order_charge%rowtype;
 BEGIN
      main_row_.CONTRACT := pkg_a.Get_Item_Value('CONTRACT',MAINROWLIST_);
      main_row_.ORDER_NO := pkg_a.Get_Item_Value('ORDER_NO',MAINROWLIST_);
      main_row_.CURRENCY_CODE := pkg_a.Get_Item_Value('CURRENCY_CODE',MAINROWLIST_);
      row_.CHARGE_TYPE := pkg_a.get_item_value('CHARGE_TYPE',ROWLIST_);
      sctrec_          := IFSAPP.Sales_Charge_Type_API.Get(main_row_.CONTRACT,row_.CHARGE_TYPE);
   if column_id_ ='CHARGE_TYPE' then
      row_.CHARGE_TYPE_DESC  :=CUSTOMER_ORDER_CHARGE_API.Get_Charge_Type_Desc(main_row_.CONTRACT,main_row_.ORDER_NO,row_.CHARGE_TYPE);
      row_.CHARGE_GROUP      :=SALES_CHARGE_TYPE_API.Get_Charge_Group(main_row_.CONTRACT,row_.CHARGE_TYPE);
      row_.CHARGE_GROUP_DESC :=CUSTOMER_ORDER_CHARGE_API.Get_Charge_Group_Desc(main_row_.CONTRACT,main_row_.ORDER_NO,row_.CHARGE_TYPE);   
      pkg_a.Set_Item_Value('CHARGE_TYPE_DESC',row_.CHARGE_TYPE_DESC,attr_out);  
      pkg_a.Set_Item_Value('CHARGE_GROUP',row_.CHARGE_GROUP,attr_out); 
      pkg_a.Set_Item_Value('CHARGE_GROUP_DESC',row_.CHARGE_GROUP_DESC,attr_out);   
      pkg_a.Set_Item_Value('CONTRACT',      main_row_.CONTRACT,attr_out);
      row_.SALES_UNIT_MEAS :=  sctrec_.sales_unit_meas;
      row_.FEE_CODE := sctrec_.fee_code; 
      row_.CHARGE_COST := sctrec_.charge_cost;  
      pkg_a.Set_Item_Value('SALES_UNIT_MEAS',row_.SALES_UNIT_MEAS,attr_out);  
      pkg_a.Set_Item_Value('FEE_CODE',row_.FEE_CODE,attr_out); 
      pkg_a.Set_Item_Value('CHARGE_COST',row_.CHARGE_COST,attr_out);
   end if;
      IF COLUMN_ID_ = 'FEE_CODE' THEN
         row_.FEE_CODE :=pkg_a.Get_Item_Value('FEE_CODE',ROWLIST_);
         pkg_a.Set_Item_Value('FEE_CODE',row_.FEE_CODE,attr_out);
         RateDummy_ :=IFSAPP.STATUTORY_FEE_API.Get_Percentage(IFSAPP.Site_API.Get_Company(main_row_.CONTRACT),row_.FEE_CODE); 
         row_.PRICE_WITH_TAX := pkg_a.Get_Item_Value('PRICE_WITH_TAX',ROWLIST_);
         if row_.PRICE_WITH_TAX = 'FALSE' then 
            row_.CHARGE_AMOUNT :=NVL(pkg_a.Get_Item_Value('CHARGE_AMOUNT',ROWLIST_),0);
            pkg_a.Set_Item_Value('CHARGE_AMOUNT',row_.CHARGE_AMOUNT,attr_out);
            ROW_.CHARGE_AMOUNT_WITH_TAX := ROUND(row_.CHARGE_AMOUNT * (1+0.01 * RateDummy_),2);
            pkg_a.Set_Item_Value('CHARGE_AMOUNT_WITH_TAX',row_.CHARGE_AMOUNT_WITH_TAX,attr_out);
           ELSE
            row_.CHARGE_AMOUNT_WITH_TAX :=NVL(pkg_a.Get_Item_Value('CHARGE_AMOUNT_WITH_TAX',ROWLIST_),0);
            pkg_a.Set_Item_Value('CHARGE_AMOUNT_WITH_TAX',row_.CHARGE_AMOUNT_WITH_TAX,attr_out);
            row_.CHARGE_AMOUNT :=ROUND(ROW_.CHARGE_AMOUNT_WITH_TAX / (1+0.01 * RateDummy_),2);
            pkg_a.Set_Item_Value('CHARGE_AMOUNT',row_.CHARGE_AMOUNT,attr_out);
         END IF;
      END IF;
      if column_id_ = 'CHARGE_AMOUNT' then
         row_.FEE_CODE :=pkg_a.Get_Item_Value('FEE_CODE',ROWLIST_);
         pkg_a.Set_Item_Value('FEE_CODE',row_.FEE_CODE,attr_out);
         RateDummy_ :=IFSAPP.STATUTORY_FEE_API.Get_Percentage(IFSAPP.Site_API.Get_Company(main_row_.CONTRACT),row_.FEE_CODE); 
         row_.CHARGE_AMOUNT :=NVL(pkg_a.Get_Item_Value('CHARGE_AMOUNT',ROWLIST_),0);
         pkg_a.Set_Item_Value('CHARGE_AMOUNT',row_.CHARGE_AMOUNT,attr_out);
         ROW_.CHARGE_AMOUNT_WITH_TAX := ROUND(row_.CHARGE_AMOUNT * (1+0.01 * RateDummy_),2);
         pkg_a.Set_Item_Value('CHARGE_AMOUNT_WITH_TAX',row_.CHARGE_AMOUNT_WITH_TAX,attr_out);
      end if;
      if column_id_ ='CHARGE_AMOUNT_WITH_TAX'  THEN
         row_.FEE_CODE :=pkg_a.Get_Item_Value('FEE_CODE',ROWLIST_);
         pkg_a.Set_Item_Value('FEE_CODE',row_.FEE_CODE,attr_out);
         RateDummy_ :=IFSAPP.STATUTORY_FEE_API.Get_Percentage(IFSAPP.Site_API.Get_Company(main_row_.CONTRACT),row_.FEE_CODE); 
         row_.CHARGE_AMOUNT_WITH_TAX :=NVL(pkg_a.Get_Item_Value('CHARGE_AMOUNT_WITH_TAX',ROWLIST_),0);
         pkg_a.Set_Item_Value('CHARGE_AMOUNT_WITH_TAX',row_.CHARGE_AMOUNT_WITH_TAX,attr_out);
         row_.CHARGE_AMOUNT :=ROUND(ROW_.CHARGE_AMOUNT_WITH_TAX / (1+0.01 * RateDummy_),2);
         pkg_a.Set_Item_Value('CHARGE_AMOUNT',row_.CHARGE_AMOUNT,attr_out);
      end IF;
     -- pkg_a.setResult(A311_KEY_,attr_out); 
      OUTROWLIST_ := attr_out; 
 END ;
 function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 )
 return varchar2 
 is
  row_     bl_v_customer_order_charge%rowtype;
 begin
    if doaction_ = 'M' then        
       row_.OBJID := pkg_a.Get_Item_Value('OBJID',ROWLIST_);
       row_.MAINSTATE :=pkg_a.Get_Item_Value('MAINSTATE',ROWLIST_);
       row_.PRICE_WITH_TAX := pkg_a.Get_Item_Value('PRICE_WITH_TAX',ROWLIST_);
       if row_.OBJID = '' or row_.OBJID = 'NULL' then
         if column_id_ ='CHARGE_AMOUNT_WITH_TAX' then
            row_.PRICE_WITH_TAX := pkg_a.Get_Item_Value('PRICE_WITH_TAX',ROWLIST_);
            if row_.PRICE_WITH_TAX = 'TRUE' then 
               return '1' ;
            ELSE
               RETURN '0';
            END IF;
         END IF;
         IF COLUMN_ID_ ='CHARGE_AMOUNT' THEN
            row_.PRICE_WITH_TAX := pkg_a.Get_Item_Value('PRICE_WITH_TAX',ROWLIST_);
            IF row_.PRICE_WITH_TAX = 'FALSE' THEN
               RETURN '1';
            ELSE
               RETURN '0' ;
            END IF;
         END IF;
         return '1';
       end if ;
       if  row_.MAINSTATE  <> 'Invoiced/Closed' and row_.MAINSTATE  <> 'Cancelled'  then
               if column_id_ = 'CHARGE_AMOUNT_WITH_TAX' then
                row_.PRICE_WITH_TAX := pkg_a.Get_Item_Value('PRICE_WITH_TAX',ROWLIST_);
                if row_.PRICE_WITH_TAX = 'TRUE' then 
                   return '1' ;
                ELSE
                   RETURN '0';
                END IF;
               end if;
               if column_id_ = 'CHARGE_AMOUNT' then
                row_.PRICE_WITH_TAX := pkg_a.Get_Item_Value('PRICE_WITH_TAX',ROWLIST_);
                if row_.PRICE_WITH_TAX = 'FALSE' then 
                   return '1' ;
                ELSE
                   RETURN '0';
                END IF;
               end if;
            RETURN '1';
         else
            return '0';
        end if; 
  
    end if ; 
      return '1';
 end  ;
  ----检查添加行 删除行 
 function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2 
   is
     cur_ t_cursor;
     row_ BL_v_CUSTOMER_ORDER%rowtype;
  begin
     open cur_ for select t.* 
     from BL_v_CUSTOMER_ORDER t
     where t.ORDER_NO = order_no_;
     fetch cur_ into row_ ;
     if cur_%notfound then
          close cur_;
        return '0';
     end if ;
     close cur_;
     if row_.STATE <> 'Planned' and row_.STATE <> 'Released'  then
        return  '0';
     end if ;
     return '1';  
 end;

end BL_CUSTOMER_ORDER_CHARGE_API;
/
