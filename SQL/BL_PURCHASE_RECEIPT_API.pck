create or replace package BL_PURCHASE_RECEIPT_API is

  PROCEDURE CANCEL__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE MODIFY__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE CONFIRM__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE DENY__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE UNTREAD__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2); 

end BL_PURCHASE_RECEIPT_API;
/
create or replace package body BL_PURCHASE_RECEIPT_API is
 type t_cursor is ref cursor;
 PROCEDURE CANCEL__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
   info_ varchar2(4000);
   row_  BL_V_PURCHASE_RECEIPT_NEW%rowtype ;
   cur_  t_cursor;
   attr_  varchar2(4000);
   action_ varchar2(20);
   rep_row_        RECEIPT_INVENTORY_LOCATION%rowtype ;
   location_group_ varchar2(20);
 BEGIN 
    open cur_
    for select t.*
    from    BL_V_PURCHASE_RECEIPT_NEW t
    where  t.OBJID =   ROWLIST_;
    fetch cur_     into row_   ;
    if cur_%notfound then       
       close cur_ ;
       raise_application_error(-20101, '错误的rowid');
       return ;
    end if ;    
    close cur_ ;  
    ---获取当前的库位信息
    
    open cur_
    for select t.*
    from    RECEIPT_INVENTORY_LOCATION t
    where   (ORDER_NO, LINE_NO, RELEASE_NO, RECEIPT_NO, 
            CONTRACT, PART_NO ) in ( select 
            row_.ORDER_NO, row_.LINE_NO, row_.RELEASE_NO, row_.RECEIPT_NO, 
            row_.CONTRACT, row_.PART_NO from dual
            )    ;
    fetch cur_     into rep_row_   ;
    if cur_%notfound then       
       close cur_ ;
       raise_application_error(-20101, '错误的rowid');
       return ;
    end if ;    
    close cur_ ; 
    
    location_group_ :=  Inventory_location_api.get_location_group(contract_ =>rep_row_.contract ,
                                                       location_no_ => rep_row_.location_no);  
     if  location_group_ <>  '15' and     location_group_ <>  '16'  then
         
         raise_application_error(-20101, '已经移库不能取消登记到达！');
         return ;
     end if ;                                          
                                                        
     action_ := 'DO';
     purchase_receipt_api.cancel__(info_ => info_,
                                objid_ => row_.OBJID,
                                objversion_ => row_.objversion,
                                attr_ => attr_,
                                action_ => action_);
     pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_RECEIPT_NEW',row_.OBJID);
     pkg_a.setMsg(A311_KEY_,'','订单'|| row_.INSPECTNO ||'取消登记到达成功！');
   RETURN;
 END;

PROCEDURE MODIFY__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 BEGIN 
   RETURN;
 END;
 
 PROCEDURE CONFIRM__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 BEGIN 
   RETURN;
 END;
 
 PROCEDURE DENY__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 BEGIN 
   RETURN;
 END;
 
 PROCEDURE UNTREAD__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 BEGIN 
   RETURN;
 END;

  
end BL_PURCHASE_RECEIPT_API;
/
