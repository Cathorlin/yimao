create or replace package BL_PURCHASE_RETURN_OUT_DTL_API is

  PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE Modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE Remove__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE Finish_Stock(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_  VARCHAR2 ,ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,OUTROWLIST_ OUT VARCHAR2);
  --判断当前列是否可编辑--
  function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 ) return varchar2 ;
 ----检查编辑 修改
  function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2 ;

end BL_PURCHASE_RETURN_OUT_DTL_API;
/
create or replace package body BL_PURCHASE_RETURN_OUT_DTL_API is
 type t_cursor is ref cursor;
 
   /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS
   InspectNO_  varchar2(100);
   row_  BL_V_PURCHASE_RETURN_OUT%rowtype;
 BEGIN
        
   RETURN;
 END;


  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
PROCEDURE Modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 is
 index_ varchar2(1);
 doaction_ varchar2(1);
 transId_ varchar2(20);
 objid_  varchar2(100);
 cur_ t_cursor;
 row_  BL_V_PURCHASE_RETURN_OUT_DTL%rowtype;
 ROW_PURRENTURN_  BL_PURRENTURN_DTL_TAB%ROWTYPE;
 ll_count_  number;
 BEGIN

    index_ := f_get_data_index();
    objid_   := pkg_a.Get_Item_Value('OBJID',index_ || ROWLIST_);
    doaction_ := pkg_a.Get_Item_Value('DOACTION', ROWLIST_);

      if doaction_='M' then

        open cur_  FOR  select t.*  from BL_V_PURCHASE_RETURN_OUT_DTL t where t.objid=objid_;   
        fetch cur_ into row_;   
           IF cur_%NOTFOUND THEN
            CLOSE cur_;
            raise_application_error(-20101, '未取得退货信息');
            RETURN;
           END IF;
         close cur_;
         
         row_.QTY_IN_STORE   := pkg_a.Get_Item_Value('QTY_IN_STORE',ROWLIST_ );
         
                  
         if row_.AVAIL_NUM<row_.QTY_IN_STORE then
           pkg_a.setMsg(A311_KEY_,'','退货出库数量['||row_.QTY_IN_STORE||']超出有效数量['||row_.AVAIL_NUM||']，不可出库');
           return;
        end if;
         
        open cur_  FOR    
             select t.*  from BL_PURRENTURN_DTL_TAB t 
             where t.INSPECT_NO_LINE=row_.INSPECT_NO_LINE AND
             t.INSPECT_NO=row_.INSPECT_NO AND
             t.PART_NO=row_.PART_NO AND
             t.LOCATION_NO=row_.LOCATION_NO AND
             t.LOT_BATCH_NO = row_.LOT_BATCH_NO ;
             
        fetch cur_ into ROW_PURRENTURN_;   
           IF cur_%FOUND THEN
                 UPDATE BL_PURRENTURN_DTL_TAB 
                 SET QTY_IN_STORE =  row_.QTY_IN_STORE
                 where INSPECT_NO_LINE=row_.Inspect_No_Line  AND
                       INSPECT_NO= row_.Inspect_No AND
                       PART_NO=row_.PART_NO AND
                       LOCATION_NO=row_.LOCATION_NO AND
                       LOT_BATCH_NO = row_.LOT_BATCH_NO ;
           ELSE
               INSERT INTO BL_PURRENTURN_DTL_TAB 
                 (PICKLISTNO, TRANSACTION_ID, ORDER_NO, LINE_NO, RELEASE_NO, LOCATION_NO, 
                  LOT_BATCH_NO, SERIAL_NO, ENG_CHG_LEVEL, WAIV_DEV_REJ_NO, 
                  CONFIGURATION_ID, PART_NO, CONTRACT, INSPECT_NO, INSPECT_NO_LINE, 
                  RECEIPT_NO, QTY_IN_STORE)
                 SELECT   row_.PICKLISTNO,'' , row_.ORDER_NO, row_.LINE_NO,row_.RELEASE_NO, row_.LOCATION_NO,row_.LOT_BATCH_NO ,
                   row_.SERIAL_NO, row_.ENG_CHG_LEVEL, row_.WAIV_DEV_REJ_NO ,row_.CONFIGURATION_ID, row_.PART_NO,row_.CONTRACT,row_.INSPECT_NO,
                   row_.INSPECT_NO_LINE,row_.RECEIPT_NO,row_.QTY_IN_STORE
                 FROM dual ;   
           END IF;
         close cur_;
       
       pkg_a.setSuccess(A311_KEY_,'BL_PURCHASE_RETURN_OUT_DTL_API',objid_);
       return ;
   end if ;
 END;
 
    
PROCEDURE Remove__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS
 BEGIN
   RETURN;
 END;

PROCEDURE Finish_Stock(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS
 BEGIN
   RETURN;
 END;
 
   /*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
 PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_  VARCHAR2 , ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,OUTROWLIST_ OUT VARCHAR2)
 IS
 cur_ t_cursor;
 cur1_ t_cursor;
 attr_out varchar2(4000);
 row_  BL_V_PURCHASE_RETURN_OUT_DTL%rowtype;
 InspectNO_  varchar2(40);
 BEGIN
   
  InspectNO_  := pkg_a.Get_Item_Value('Inspect_No_Line',ROWLIST_ );
  
 end  ;
 
   /*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
      返回: 1 可用
      0 不可用
  */
 function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 )
 return varchar2
 is
 row_ BL_V_PICKLIST_DETAIL%rowtype;
 begin
   row_.OBJID := pkg_a.Get_Item_Value('OBJID',ROWLIST_);
   --  保存后不能修改任何数据
   if nvl(row_.OBJID,'NULL') <> 'NULL'  then
      return '0';
   end if ;
   return '1';
 end  ;
   /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
 function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2
   is
   row0_ bl_v_bl_picklist%rowtype;
   cur_ t_cursor;
  begin
    open cur_  for
     select t.*
     from bl_v_bl_picklist t
     where t.picklistno=order_no_;
     fetch cur_ into row0_;
     if cur_%found then
        if row0_.FLAG ='2' or row0_.FLAG='1' then
               return '0';
        end if ;
        close cur_;
     end if ;
     close cur_;
      return '1';
 end;

end BL_PURCHASE_RETURN_OUT_DTL_API;
/
