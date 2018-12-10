create or replace package BL_PO_RESERVATION_API is

 PROCEDURE MAKE_PART_RESERVATIONS(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
 PROCEDURE Ship_Vendor_Material(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);

end BL_PO_RESERVATION_API;
/
create or replace package body BL_PO_RESERVATION_API is
 type t_cursor is ref cursor; 
 /*
      功能:订单供应商物料预留保存
      参数：   ROWLIST_:页面传递的数据
               USER_ID_：操作员账号
               A311_KEY_：日志编号
      创建者： long
      创建时间：2012-10-10
 */
 PROCEDURE MAKE_PART_RESERVATIONS(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 row_ BL_V_INVEN_PART_IN_STOCK_RES%rowtype;
 mainrow_ BL_V_PO_LINE_COMP_YL%rowtype;
 objid_ varchar2(4000);
 cur_ t_cursor;
 QTY_ASSIGNED_ number;
 BEGIN 
   --ROWLIST_ := 'DOACTION|MOBJID|AAAMoKAAFAACVDHAAZ-AAANp0AAFAAAGScAAAQTY_ASSIGNED|1'||CHR(31);
   
   objid_ := pkg_a.Get_Item_Value('OBJID',ROWLIST_);
     open cur_ for 
   select t.* 
   from BL_V_INVEN_PART_IN_STOCK_RES t
   where t.objid = objid_;
   fetch  cur_ into row_;
   if  cur_%notfound  then 
     close cur_;
     raise_application_error(-20101, '错误的rowid');
     RETURN;
   end if ;
   close cur_;
   QTY_ASSIGNED_ :=pkg_a.Get_Item_Value('QTY_ASSIGNED',ROWLIST_);
   if nvl(QTY_ASSIGNED_,0) = 0  then
     raise_application_error(-20101, '错误的rowid');
     return  ;
   end if ;
   select t.* into mainrow_ from BL_V_PO_LINE_COMP_YL t  where CONTRACT_PART_NO =  row_.CONTRACT_PART_NO;
   --调用IFS预留函数 预留操作将处理purchase_order_line_comp_tab
   PURCHASE_ORDER_RESERVATION_API.MAKE_PART_RESERVATIONS(
                                                       mainrow_.ORDER_NO,
                                                       mainrow_.line_no,
                                                       mainrow_.RELEASE_NO,
                                                       mainrow_.LINE_ITEM_NO,
                                                       mainrow_.order_code,
                                                       mainrow_.CONTRACT,
                                                       mainrow_.component_part,
                                                       row_.LOCATION_NO,
                                                       row_.LOT_BATCH_NO,
                                                       row_.SERIAL_NO,
                                                       row_.ENG_CHG_LEVEL,
                                                       row_.WAIV_DEV_REJ_NO,
                                                       QTY_ASSIGNED_);
    pkg_a.setSuccess(A311_KEY_,'BL_V_INVEN_PART_IN_STOCK_RES',objid_);
 END;
 
  /*
      功能:订单供应商物料下发保存
      参数：   ROWLIST_:页面传递的数据
               USER_ID_：操作员账号
               A311_KEY_：日志编号
      创建者： long
      创建时间：2012-10-12
 */
 PROCEDURE Ship_Vendor_Material(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 row_ PURCHASE_ORDER_RESERVATION%rowtype;
 QTY_ISSUED_ number;
 cur_ t_cursor;
 objid_ varchar2(4000);
 BEGIN 
   objid_ := pkg_a.Get_Item_Value('OBJID',ROWLIST_);
   open cur_ for 
   select t.* 
   from PURCHASE_ORDER_RESERVATION t
   where t.objid = objid_;
   fetch  cur_ into row_;
   if  cur_%notfound  then 
     close cur_;
     raise_application_error(-20101, '错误的rowid');
     RETURN;
   end if ;
   close cur_;
   QTY_ISSUED_ :=pkg_a.Get_Item_Value('QTY_ISSUED',ROWLIST_) ;
   if nvl(QTY_ISSUED_,0) = 0  then
     raise_application_error(-20101, '错误的rowid');
     return  ;
   end if ;
    --调用IFS下发函数，下发操作将处理purchase_order_reservation_tab表数据
   Purchase_Order_Reservation_API.Ship_Vendor_Material(
                                                      row_.order_no,
                                                      row_.line_no,
                                                      row_.release_no,
                                                      row_.line_item_no,
                                                      row_.order_code,
                                                      row_.contract,
                                                      row_.part_no,
                                                      row_.location_no,
                                                      row_.lot_batch_no,
                                                      row_.serial_no,
                                                      row_.eng_chg_level,
                                                      row_.waiv_dev_rej_no,
                                                      QTY_ISSUED_);
  pkg_a.setSuccess(A311_KEY_,'PURCHASE_ORDER_RESERVATION',objid_);
 END;

  
end BL_PO_RESERVATION_API;
/
