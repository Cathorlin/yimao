CREATE OR REPLACE PACKAGE BL_INVENT_PART_INSTOCKLOC_API IS
 PROCEDURE Change_ExpirationDate(ROWLIST_ varchar2,user_id_ varchar2,a311_key_ varchar2);

END BL_INVENT_PART_INSTOCKLOC_API;
/
CREATE OR REPLACE PACKAGE BODY BL_INVENT_PART_INSTOCKLOC_API IS
  TYPE t_Cursor IS REF CURSOR;
  /* create fjp 2012-12-17 更改交货到期日*/
PROCEDURE Change_ExpirationDate(ROWLIST_ varchar2,user_id_ varchar2,a311_key_ varchar2)
  is
  cur_  t_Cursor;
  row_ BL_V_INVENT_PART_IN_STOCK_LOC%rowtype;
 begin 
      row_.OBJID := pkg_a.Get_Item_Value('OBJID',ROWLIST_);
   open  cur_ for 
   Select t.*
   from  BL_V_INVENT_PART_IN_STOCK_LOC t 
   where t.OBJID =   row_.OBJID;
   fetch  cur_ into row_ ;
   if cur_%notfound then
      close cur_ ;
      raise_application_error(-20101, '错误的rowid');
      return ;
   end if ;   
   close cur_ ;
   row_.EXPIRATION_DATE :=  to_date(pkg_a.Get_Item_Value('EXPIRATION_DATE',ROWLIST_),'yyyy-mm-dd');
   if row_.EXPIRATION_DATE is null then 
      raise_application_error(-20101, '请输入到期日');
      return ;
   end if;

   INVENTORY_PART_IN_STOCK_API.Modify_Expiration_Date(
                                                    ROW_.contract,
                                                    ROW_.PART_NO,
                                                    ROW_.CONFIGURATION_ID,
                                                    ROW_.LOCATION_NO,
                                                    ROW_.LOT_BATCH_NO,
                                                    ROW_.SERIAL_NO,
                                                    ROW_.ENG_CHG_LEVEL,
                                                    ROW_.WAIV_DEV_REJ_NO,
                                                    ROW_.EXPIRATION_DATE
                                                     );
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_INVENT_PART_IN_STOCK_LOC', row_.OBJID);
    RETURN;
 end;
End BL_INVENT_PART_INSTOCKLOC_API; 
/
