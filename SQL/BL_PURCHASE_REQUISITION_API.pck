create or replace package BL_PURCHASE_REQUISITION_API is

  PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE APPROVE__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE APPROVE1__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE Revoke_APPROVE__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE Revoke_APPROVE1__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE CHANGE_TO_PLANNED__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE MODIFY__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE RELEASE__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE REMOVE__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
 --判断当前列是否可编辑--
 function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 ) return varchar2 ;
 ----检查 按钮 编辑 修改
 function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2 ;
 PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_ varchar2, ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,OUTROWLIST_ OUT VARCHAR2);
end BL_PURCHASE_REQUISITION_API;
/
create or replace package body BL_PURCHASE_REQUISITION_API is

type t_cursor is ref cursor; 

PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
  attr_  varchar2(4000);
 info_ varchar2(4000);
 objid_ varchar2(4000);
 objversion_  varchar2(4000);
 action_  varchar2(100);
 attr_out varchar2(4000);
 ls_description_   varchar2(100);
 Contract_       varchar2(20);
 BEGIN 
  --  初始化新增页面
    action_ := 'PREPARE';
    attr_ :=  pkg_a.Get_Attr_By_bm(ROWLIST_);
    PURCHASE_REQUISITION_API.New__(info_,objid_,objversion_ ,attr_,action_);
    --获取代码写入代码的描述
    ls_description_ := IFSAPP.Purchase_Order_Type_API.Get_Description(client_sys.Get_Item_Value('ORDER_CODE',attr_));
    client_sys.Add_To_Attr('DESCRIPTION',ls_description_,attr_ );
    attr_out := pkg_a.Get_Attr_By_Ifs(attr_);
    Contract_ := Pkg_Attr.Get_Default_Contract(User_Id_);
    If (Nvl(Contract_, '0') <> '0') Then
      Pkg_a.Set_Item_Value('CONTRACT', Contract_, Attr_Out);
    End If;
    pkg_a.setResult(A311_KEY_,attr_out);    
    RETURN;
 END;

PROCEDURE APPROVE__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 attr1_  varchar2(100);
 attr2_  varchar2(100);
 row_     BL_V_PURCH_REQ_APPROVAL%rowtype;
 cur_ t_cursor;
 BEGIN 
 -- 审批
    attr1_ :='';
    attr2_ :='';
      row_.objid :=pkg_a.Get_Item_Value('OBJID',ROWLIST_);
     open cur_  for 
     select *
     from BL_V_PURCH_REQ_APPROVAL
     where objid = row_.objid;
     fetch cur_ into row_;
     if cur_%notfound  then
       close cur_;
       pkg_a.setFailed(A311_KEY_,'BL_V_PURCH_REQ_APPROVAL',row_.objid); 
       raise_application_error(-20101, '错误的rowid');
       RETURN;
     end if ;
     close  cur_;
     PURCHASE_REQ_UTIL_API.Find_Po_Created_Lines(attr1_,attr2_,row_.requisition_no);
     Purch_Req_Approval_API.Authorize(row_.requisition_no,row_.sequence_no,row_.authorize_id,row_.authorize_group_id);
     PURCHASE_REQ_UTIL_API.Find_Po_Created_Lines(attr1_,attr2_,row_.requisition_no);
     pkg_a.setSuccess(A311_KEY_,'BL_V_PURCH_REQ_APPROVAL',row_.objid); 
   RETURN;
 END;
 PROCEDURE APPROVE1__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 row_ bl_v_purchase_requisition%rowtype;
 row_APPROVAL_ BL_V_PURCH_REQ_APPROVAL%rowtype;
 cur_ t_cursor;
 cur_approval_ t_cursor;
 ROWLIST_ varchar2(400);
 begin
 --获取采购申请号
   open cur_ for
   select t.* 
   from bl_v_purchase_requisition t
   where t.objid = rowid_;
   fetch cur_ into row_;
   if cur_%notfound then 
       close cur_;
       raise_application_error(-20101, '错误的rowid');
       RETURN;
   end if ;
   close cur_;
   --审批号
   open cur_approval_ for
   select t.*
   from BL_V_PURCH_REQ_APPROVAL t
   where t.requisition_no = row_.REQUISITION_NO
   and  t.sequence_no = 1
   and rownum=1;
   fetch  cur_approval_ into row_APPROVAL_;
   if cur_approval_%notfound then 
       close cur_approval_;
       raise_application_error(-20101, '错误的rowid');
       RETURN;
   end if ;
   close cur_approval_;
   pkg_a.Set_Item_Value('OBJID',row_APPROVAL_.objid,ROWLIST_);
   APPROVE__(ROWLIST_,USER_ID_,A311_KEY_);
  return ;
 end;
PROCEDURE Revoke_APPROVE__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 row_     BL_V_PURCH_REQ_APPROVAL%rowtype;
 cur_ t_cursor;
 BEGIN 
 -- 取消审批
      row_.objid :=pkg_a.Get_Item_Value('OBJID',ROWLIST_);
     open cur_  for 
     select *
     from BL_V_PURCH_REQ_APPROVAL
     where objid = row_.objid;
     fetch cur_ into row_;
     if cur_%notfound  then
       close cur_;
       pkg_a.setFailed(A311_KEY_,'BL_V_PURCH_REQ_APPROVAL',row_.objid); 
       raise_application_error(-20101, '错误的rowid');
       RETURN;
     end if ;
     close  cur_;
     Purch_Req_Approval_API.Revoke_Authorization(row_.requisition_no,row_.sequence_no,row_.authorize_id,row_.authorize_group_id);
     pkg_a.setSuccess(A311_KEY_,'BL_V_PURCH_REQ_APPROVAL',row_.objid); 
   RETURN;
 END; 
 PROCEDURE Revoke_APPROVE1__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 is
  row_ bl_v_purchase_requisition%rowtype;
 row_APPROVAL_ BL_V_PURCH_REQ_APPROVAL%rowtype;
 cur_ t_cursor;
 cur_approval_ t_cursor;
 ROWLIST_ varchar2(400);
 begin
  --获取采购申请号
   open cur_ for
   select t.* 
   from bl_v_purchase_requisition t
   where t.objid = rowid_;
   fetch cur_ into row_;
   if cur_%notfound then 
       close cur_;
       raise_application_error(-20101, '错误的rowid');
       RETURN;
   end if ;
   close cur_;
   --审批号
   open cur_approval_ for
   select t.*
   from BL_V_PURCH_REQ_APPROVAL t
   where t.requisition_no = row_.REQUISITION_NO
   and  t.sequence_no = 1
   and rownum=1;
   fetch  cur_approval_ into row_APPROVAL_;
   if cur_approval_%notfound then 
       close cur_approval_;
       raise_application_error(-20101, '错误的rowid');
       RETURN;
   end if ;
   close cur_approval_;
   pkg_a.Set_Item_Value('OBJID',row_APPROVAL_.objid,ROWLIST_);
   Revoke_APPROVE__(ROWLIST_,USER_ID_,A311_KEY_);
 end;
PROCEDURE CHANGE_TO_PLANNED__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS
  attr_ varchar2(4000);
 info_ varchar2(4000);
 objid_ varchar2(4000);
 objversion_ varchar2(4000);
 action_ varchar2(100);
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
     pkg_a.setFailed(A311_KEY_,'BL_V_PURCHASE_REQUISITION',objid_); 
     raise_application_error(-20101, '错误的rowid');
     RETURN;
   end if ;
   close  cur_;
   action_ :='DO';
   PURCHASE_REQUISITION_API.CHANGE_TO_PLANNED__( info_, objid_, objversion_, attr_,action_);
   pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_REQUISITION',objid_); 
   RETURN;
 END;

PROCEDURE MODIFY__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
row_  BL_V_PURCHASE_REQUISITION%rowtype;
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
 begin
  index_ :=f_get_data_index();
  row_.objid :=pkg_a.Get_Item_Value('OBJID',index_ || ROWLIST_);
    doaction_ := pkg_a.Get_Item_Value('DOACTION', ROWLIST_);
  if doaction_ = 'I' then    /*新增*/
   
        attr_ := '';
        client_sys.Add_To_Attr('CONTRACT',pkg_a.Get_Item_Value('CONTRACT',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('REQUISITION_DATE',pkg_a.Get_Item_Value('REQUISITION_DATE',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('REQUISITIONER_CODE',pkg_a.Get_Item_Value('REQUISITIONER_CODE',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('ORDER_CODE',pkg_a.Get_Item_Value('ORDER_CODE',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('DESTINATION_ID',pkg_a.Get_Item_Value('DESTINATION_ID',ROWLIST_),attr_ );
        client_sys.Add_To_Attr('INTERNAL_DESTINATION',pkg_a.Get_Item_Value('INTERNAL_DESTINATION',ROWLIST_),attr_ );
        action_:='DO'; 
        PURCHASE_REQUISITION_API.New__(info_,objid_,objversion_ ,attr_,action_);
        pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_REQUISITION',objid_);
        RETURN;      
  end if  ;
 if doaction_ = 'M' then  /*修改*/
  open cur_
  for select t.* 
  from BL_V_PURCHASE_REQUISITION t
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
      if column_id_ <>  'OBJID' and  column_id_ <> 'DOACTION' and column_id_<>'DESCRIPTION' and length(nvl(column_id_,'')) > 0  then
         v_ := substr(v_, pos1_ +  1 ) ;
         client_sys.Add_To_Attr(column_id_,v_,attr_ );
         i := i + 1 ;
      end if ;    
    end  loop ;
    
    action_:='DO'; 
    PURCHASE_REQUISITION_API.Modify__(info_,row_.OBJID,row_.OBJVERSION,attr_,action_);
    pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_REQUISITION',objid_); 
    RETURN ;
  end if ;
 END;

PROCEDURE RELEASE__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 attr_ varchar2(4000);
 info_ varchar2(4000);
 objid_ varchar2(4000);
 objversion_ varchar2(4000);
 action_ varchar2(100);
  cur_ t_cursor;
 BEGIN 
  objid_ :=rowid_;
   open cur_  for 
   select objversion 
   from BL_V_PURCHASE_REQUISITION
   where objid = objid_;
   fetch cur_ into objversion_;
   if cur_%notfound  then
     close cur_;
     pkg_a.setFailed(A311_KEY_,'BL_V_PURCHASE_REQUISITION',objid_); 
     raise_application_error(-20101, '错误的rowid');
     RETURN;
   end if ;
   close  cur_;
   action_ :='DO';
   PURCHASE_REQUISITION_API.RELEASE__( info_, rowid_, objversion_, attr_, action_);
   pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_REQUISITION',objid_); 
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
     pkg_a.setFailed(A311_KEY_,'BL_V_PURCHASE_REQUISITION',objid_); 
     raise_application_error(-20101, '错误的rowid');
     RETURN;
   end if ;
   close  cur_;
   -- 检测
   action_ :='CHECK';
   PURCHASE_REQUISITION_API.REMOVE__( info_, objid_, objversion_, action_);
   --保存
   action_ :='DO';
   PURCHASE_REQUISITION_API.REMOVE__( info_, objid_, objversion_, action_);
   pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_REQUISITION',objid_); 
   RETURN;
 END;
 function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 )
 return varchar2 
 is
 begin
   if doaction_ = 'I' then
      return  '1' ;      
   end if ;
   if doaction_ = 'M' then
      if ( column_id_ = 'CONTRACT'  or  column_id_ = 'REQUISITIONER_CODE' ) then
          return '0' ;
      end if ;
      return '1';
   end if ;  
 end  ;
  ----检查新增 修改 
 function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2 
   is
  begin
          
      return '1';  
 end;
 PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_ varchar2, ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,OUTROWLIST_ OUT VARCHAR2)
 is 
  row_ BL_V_PURCHASE_REQUISITION%rowtype;
  attr_out varchar2(4000);
 begin 
    if column_id_ = 'REQUISITIONER_CODE' then 
      row_.REQUISITIONER_CODE := pkg_a.Get_Item_Value('REQUISITIONER_CODE',ROWLIST_);
       row_.REQUISITIONER     :=Purchase_Requisitioner_API.Get_Requisitioner(row_.REQUISITIONER_CODE);
       pkg_a.Set_Item_Value('REQUISITIONER',    row_.REQUISITIONER,    attr_out);   
    end if ;
    if column_id_='ORDER_CODE' then 
       row_.ORDER_CODE :=  pkg_a.Get_Item_Value('ORDER_CODE',ROWLIST_);
       row_.DESCRIPTION:= Purchase_Order_Type_API.Get_Description(row_.ORDER_CODE);
       pkg_a.Set_Item_Value('DESCRIPTION',    row_.DESCRIPTION,    attr_out);   
    end if ;
    if column_id_='DESTINATION_ID' then
       row_.DESTINATION_ID       := pkg_a.Get_Item_Value('DESTINATION_ID',ROWLIST_);
       row_.CONTRACT             :=pkg_a.Get_Item_Value('CONTRACT',ROWLIST_);
       row_.INTERNAL_DESTINATION :=INTERNAL_DESTINATION_API.Get_Description(row_.CONTRACT,row_.DESTINATION_ID);
       pkg_a.Set_Item_Value('INTERNAL_DESTINATION',    row_.INTERNAL_DESTINATION,    attr_out);  
    end if ;
    OUTROWLIST_ := attr_out;
 end;
end BL_PURCHASE_REQUISITION_API;
/
