create or replace package BL_PO_LINE_COMP_API is

  PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE REMOVE__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE MODIFY__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_  VARCHAR2 ,ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,OUTROWLIST_ OUT VARCHAR2);
   --判断当前列是否可编辑--
 function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 ) return varchar2 ;
 ----检查 按钮 编辑 修改
 function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2 ;
end BL_PO_LINE_COMP_API;
/
create or replace package body BL_PO_LINE_COMP_API is
 type t_cursor is ref cursor; 
 PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
  attr_  varchar2(4000);
 info_ varchar2(4000);
 objid_ varchar2(4000);
 objversion_  varchar2(4000);
 action_  varchar2(100);
 attr_out varchar2(4000);
 ls_PO_VENDOR_NO_ varchar2(400);
 row_  BL_V_PO_LINE_PART_VENDOR%rowtype;
 cur_ t_cursor;
 BEGIN 
    ls_PO_VENDOR_NO_ := pkg_a.Get_Item_Value('PO_VENDOR_NO',ROWLIST_);
    if ls_PO_VENDOR_NO_ is null OR ls_PO_VENDOR_NO_ ='0' then
     return;
    end if ; 
      open cur_ for 
      select t.* 
      from BL_V_PO_LINE_PART_VENDOR t
      where t.PO_VENDOR_NO=ls_PO_VENDOR_NO_;
      fetch cur_ into row_;
      if cur_%notfound then
        close cur_;
        raise_application_error(-20101, '错误的rowid');
        RETURN;
      end if ;
      close cur_;
    action_ := 'PREPARE';
    attr_ := '';
    client_sys.Add_To_Attr('ORDER_NO',row_.ORDER_NO,attr_ );
    client_sys.Add_To_Attr('LINE_NO',row_.LINE_NO,attr_ );
    client_sys.Add_To_Attr('RELEASE_NO',row_.RELEASE_NO,attr_ );
    client_sys.Add_To_Attr('CONTRACT',row_.CONTRACT,attr_ );
    client_sys.Add_To_Attr('QTY_REQUIRED',row_.BUY_QTY_DUE,attr_ );
    client_sys.Add_To_Attr('QTY_ON_ORDER',0,attr_ ); 
    PURCHASE_ORDER_LINE_COMP_API.NEW__(info_,objid_,objversion_ ,attr_,action_);
    client_sys.Add_To_Attr('ORDER_NO',row_.ORDER_NO,attr_ );
    client_sys.Add_To_Attr('LINE_NO',row_.LINE_NO,attr_ );
    client_sys.Add_To_Attr('RELEASE_NO',row_.RELEASE_NO,attr_ );
    client_sys.Add_To_Attr('CONTRACT',row_.CONTRACT,attr_ );
    client_sys.Add_To_Attr('QTY_REQUIRED',row_.BUY_QTY_DUE,attr_ );
    attr_out := pkg_a.Get_Attr_By_Ifs(attr_);
    pkg_a.setResult(A311_KEY_,attr_out);    
    RETURN;
 END;

PROCEDURE REMOVE__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 BEGIN 
   RETURN;
 END;

PROCEDURE MODIFY__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 row_  BL_V_PURCHASE_ORDER_LINE_COMP%rowtype;
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
 doaction_ varchar2(10);
 BEGIN 
          insert into af(col01,col02,col03)
        select ROWLIST_, USER_ID_,A311_KEY_ from dual ;
        commit;
         index_ := f_get_data_index();
   row_.objid :=pkg_a.Get_Item_Value('OBJID', ROWLIST_);
   doaction_ := pkg_a.Get_Item_Value('DOACTION', ROWLIST_);
 if doaction_ = 'I' then  /*新增*/
     attr_ :='';
    client_sys.Add_To_Attr('ORDER_NO',pkg_a.Get_Item_Value('ORDER_NO',ROWLIST_),attr_ );
    client_sys.Add_To_Attr('LINE_NO',pkg_a.Get_Item_Value('LINE_NO',ROWLIST_),attr_ );
    client_sys.Add_To_Attr('RELEASE_NO',pkg_a.Get_Item_Value('RELEASE_NO',ROWLIST_),attr_ );
    client_sys.Add_To_Attr('LINE_ITEM_NO',pkg_a.Get_Item_Value('LINE_ITEM_NO',ROWLIST_),attr_ );
    client_sys.Add_To_Attr('CONTRACT',pkg_a.Get_Item_Value('CONTRACT',ROWLIST_),attr_ );
    client_sys.Add_To_Attr('COMPONENT_PART',pkg_a.Get_Item_Value('COMPONENT_PART',ROWLIST_),attr_ );
    client_sys.Add_To_Attr('QTY_PER_ASSEMBLY',pkg_a.Get_Item_Value('QTY_PER_ASSEMBLY',ROWLIST_),attr_ );
    client_sys.Add_To_Attr('COMPONENT_SCRAP',pkg_a.Get_Item_Value('COMPONENT_SCRAP',ROWLIST_),attr_ );
    client_sys.Add_To_Attr('SHRINKAGE_FAC',pkg_a.Get_Item_Value('SHRINKAGE_FAC',ROWLIST_),attr_ );
    client_sys.Add_To_Attr('DATE_REQUIRED',pkg_a.Get_Item_Value('DATE_REQUIRED',ROWLIST_),attr_ );
    client_sys.Add_To_Attr('QTY_ON_ORDER',pkg_a.Get_Item_Value('QTY_ON_ORDER',ROWLIST_),attr_ );
    client_sys.Add_To_Attr('QTY_REQUIRED',pkg_a.Get_Item_Value('QTY_REQUIRED',ROWLIST_),attr_ );
    client_sys.Add_To_Attr('QTY_ASSIGNED',pkg_a.Get_Item_Value('QTY_ASSIGNED',ROWLIST_),attr_ );
    client_sys.Add_To_Attr('QTY_ISSUED',pkg_a.Get_Item_Value('QTY_ISSUED',ROWLIST_),attr_ );
    action_:='DO'; 
    PURCHASE_ORDER_LINE_COMP_API.NEW__(info_,objid_,objversion_ ,attr_,action_);
    pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_ORDER_LINE_COMP',objid_);
    RETURN;  
 end if ;
 if  doaction_ = 'M' then --修改
    open cur_
    for select t.* 
    from BL_V_PURCHASE_ORDER_LINE_COMP t
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
        if column_id_ <>  'OBJID' and length(nvl(column_id_,'')) > 0 and column_id_ <> 'DOACTION' then
           v_ := substr(v_, pos1_ +  1 ) ;
           client_sys.Add_To_Attr(column_id_,v_,attr_ );
           i := i + 1 ;
        end if ;    
      end  loop ;
      action_:='DO'; 
      PURCHASE_ORDER_LINE_COMP_API.MODIFY__(info_,row_.OBJID,row_.OBJVERSION,attr_,action_);
      pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_ORDER_LINE_COMP',objid_); 
      RETURN ;
  end if ;
   if doaction_='D' then-- 删除 
    open cur_
    for select t.*
    from    BL_V_PURCHASE_ORDER_LINE_COMP t
    where  t.OBJID =   row_.OBJID;
    fetch cur_     into row_   ;
    if cur_%notfound then       
       close cur_ ;   
       raise_application_error(-20101, '错误的rowid');
       return ;
    end if ;    
    close cur_ ;  
     action_:='CHECK'; 
    PURCHASE_ORDER_LINE_COMP_API.REMOVE__(info_,row_.OBJID,row_.OBJVERSION,action_);
    action_:='DO'; 
    PURCHASE_ORDER_LINE_COMP_API.REMOVE__(info_,row_.OBJID,row_.OBJVERSION,action_);
    pkg_a.setSuccess(A311_KEY_,'BL_V_PURCHASE_ORDER_LINE_COMP',row_.OBJID);
    RETURN;
   end if ;
 END;
PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_  VARCHAR2 , ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,OUTROWLIST_ OUT VARCHAR2)
 IS 
 attr_  varchar2(4000);
 info_ varchar2(4000);
 objid_ varchar2(4000);
 objversion_  varchar2(4000);
 action_  varchar2(100);
 attr_out varchar2(4000);
 row_  BL_V_PURCHASE_ORDER_LINE_COMP%rowtype;
 mainrow_ BL_V_PO_LINE_PART_VENDOR%rowtype;
 BEGIN 
           insert into af(col01,col02,col03)
        select column_id_, MAINROWLIST_,ROWLIST_ from dual ;
        commit;
   if column_id_='COMPONENT_PART' then 
      mainrow_.CONTRACT    := pkg_a.Get_Item_Value('CONTRACT',MAINROWLIST_);
      row_.COMPONENT_PART  :=pkg_a.Get_Item_Value('COMPONENT_PART',ROWLIST_);
      row_.DESCRIPTION := INVENTORY_PART_API.Get_Description(mainrow_.CONTRACT,row_.COMPONENT_PART); 
      row_.UNIT_MEAS   := Inventory_Part_API.Get_Unit_Meas(mainrow_.CONTRACT,row_.COMPONENT_PART); 
      pkg_a.Set_Item_Value('DESCRIPTION',row_.DESCRIPTION,attr_out);
      pkg_a.Set_Item_Value('UNIT_MEAS',row_.UNIT_MEAS,attr_out);
   end if ;

   if column_id_ ='QTY_PER_ASSEMBLY' then 
      row_.QTY_PER_ASSEMBLY    := pkg_a.Get_Item_Value('QTY_PER_ASSEMBLY',ROWLIST_);
      mainrow_.BUY_QTY_DUE     := pkg_a.Get_Item_Value('BUY_QTY_DUE',MAINROWLIST_);
      row_.QTY_REQUIRED        := row_.QTY_PER_ASSEMBLY *mainrow_.BUY_QTY_DUE;
      pkg_a.Set_Item_Value('QTY_PER_ASSEMBLY',row_.QTY_PER_ASSEMBLY,attr_out);
      pkg_a.Set_Item_Value('QTY_REQUIRED',row_.QTY_REQUIRED,attr_out);
   end if ;
    OUTROWLIST_ :=attr_out;
 end  ;
 function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 )
 return varchar2 
 is
 begin
   return '1';
 end  ;
  ----检查新增 修改 
 function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2 
   is
  begin
          
      return '1';  
 end;
  
end BL_PO_LINE_COMP_API;
/
