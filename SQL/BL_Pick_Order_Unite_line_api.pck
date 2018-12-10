create or replace package BL_Pick_Order_Unite_line_api is

  PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE Modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
     --当数据发生变化的时候 修改列信息
  PROCEDURE ITEMCHANGE__(COLUMN_ID_ VARCHAR2 ,   MAINROWLIST_  VARCHAR2 ,  ROWLIST_  VARCHAR2, USER_ID_ VARCHAR2, OUTROWLIST_  OUT  VARCHAR2 ) ; 
  function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 ) return varchar2 ;
 ----检查编辑 修改
  function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2 ;

end BL_Pick_Order_Unite_line_api;
/
create or replace package body BL_Pick_Order_Unite_line_api is
 type t_cursor is ref cursor;
 --modify fjp 2013-02-26判断合并备货单明细是否是不同的类型(备货单，补货备货单)
 PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 BEGIN 
   RETURN;
 END;
 
 PROCEDURE Modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 index_ varchar2(1);
 doaction_ varchar2(1);
 cur_ t_cursor;
 objid_  varchar2(100);
 row_  BL_PICKUNITE%rowtype;
 ll_count_ number;
 BEGIN 
    index_ := f_get_data_index();
    objid_   := pkg_a.Get_Item_Value('OBJID',index_ || ROWLIST_);
    doaction_ := pkg_a.Get_Item_Value('DOACTION', ROWLIST_);
    IF doaction_='I' then 
      --  获取值
      row_.PICKUNITENO :=pkg_a.Get_Item_Value('PICKUNITENO',ROWLIST_ );
      row_.PICKLISTNO :=pkg_a.Get_Item_Value('PICKLISTNO',ROWLIST_ );
      row_.CREATEDATE :=pkg_a.Get_Item_Value('CREATEDATE',ROWLIST_ );
      row_.INVOICEDATE :=pkg_a.Get_Item_Value('INVOICEDATE',ROWLIST_ );
      row_.FEEORDERNO :=pkg_a.Get_Item_Value('FEEORDERNO',ROWLIST_ );
      row_.CUSTOMERNO :=pkg_a.Get_Item_Value('CUSTOMERNO',ROWLIST_ );
      row_.FLAG :=pkg_a.Get_Item_Value('FLAG',ROWLIST_ );
      row_.CONTRACT :=pkg_a.Get_Item_Value('CONTRACT',ROWLIST_ );
      row_.SHIPDATE :=pkg_a.Get_Item_Value('SHIPDATE',ROWLIST_ );
      row_.FINISHDATE :=pkg_a.Get_Item_Value('FINISHDATE',ROWLIST_ );
      row_.CUSTOMERNO_REF :=pkg_a.Get_Item_Value('CUSTOMERNO_REF',ROWLIST_ );
      row_.userid         :=USER_ID_;
       insert into BL_PICKUNITE(PICKUNITENO,CREATEDATE,PICKLISTNO,CUSTOMERNO,FLAG)
        values(row_.PICKUNITENO,row_.CREATEDATE,row_.PICKLISTNO,row_.CUSTOMERNO,row_.FLAG )
        returning rowid  into objid_;
        --插入数据
/*        select t.rowid
        into objid_ 
        from BL_PICKUNITE t
        where t.PICKUNITENO = row_.PICKUNITENO 
        and t.PICKLISTNO=row_.PICKLISTNO;*/
        update BL_PICKUNITE
        set row=row_
        where rowid =objid_;
        --更新备货单合并单号的字段
         update bl_picklist
           set  PICKUNITENO = row_.PICKUNITENO
          where PICKLISTNO = row_.picklistno;
       --更新备货单明细合并单号的字段
           update bl_pldtl
             set  PICKUNITENO = row_.PICKUNITENO
            where  PICKLISTNO = row_.picklistno;
        --modify fjp 2013-02-26判断合并备货单明细是否是不同的类型(备货单，补货备货单)
/*         select count(distinct nvl(t.bflag,'0'))
          into ll_count_
          from  bl_picklist t
          where exists(select 1 
                      from BL_PICKUNITE t1 
                      where t1.PICKUNITENO=row_.pickuniteno
                      and   t.picklistno = t1.picklistno);
          if ll_count_ > 1 then 
              raise_application_error(-20101,'选择的备货单'||row_.PICKLISTNO||'与合并的备货单是不同的类型');
              return ;
          end if ;*/
        --判断是否有相同的订单行
        open  cur_ for 
        SELECT COUNT(*) 
         FROM   bl_v_BL_PICKUNITE_v01  
         where  PICKUNITENO = row_.PICKUNITENO
         GROUP BY  order_no,line_no,rel_no,line_item_no
         having  COUNT(*) >1;
         fetch  cur_ into ll_count_;
         if cur_%found then 
            close  cur_;
            raise_application_error(-20101,'跟备货单'||row_.PICKLISTNO||'有相同的订单行');
            return ;
         end if ;
         close cur_;
        pkg_a.setSuccess(A311_KEY_,'BL_V_BL_PICKUNITE',objid_);
        return ;
    end if ;
    if doaction_='D' then
      --清空合并备货单号
        update bl_picklist
          set  PICKUNITENO=''
         where PICKLISTNO = (select t1.PICKLISTNO 
                             from BL_PICKUNITE t1 
                             where rowidtochar(t1.rowid) = objid_);
         update bl_pldtl
          set  PICKUNITENO=''
         where PICKLISTNO = (select t1.PICKLISTNO 
                             from BL_PICKUNITE t1 
                             where rowidtochar(t1.rowid) = objid_);                    
    -- 删除数据
       delete from BL_PICKUNITE where rowidtochar(rowid) = objid_;
       pkg_a.setSuccess(A311_KEY_,'BL_V_BL_PICKUNITE',objid_);
       return ;
   end if ;
 END;
  PROCEDURE ITEMCHANGE__(COLUMN_ID_ VARCHAR2 ,MAINROWLIST_  VARCHAR2 ,ROWLIST_  VARCHAR2,USER_ID_ VARCHAR2, OUTROWLIST_  OUT  VARCHAR2)
 IS 
 ROW_ BL_V_BL_PICKUNITE%ROWTYPE;
  attr_out varchar2(4000);
 begin
    if COLUMN_ID_ ='PICKLISTNO'  then 
      ROW_.PICKLISTNO :=pkg_a.Get_Item_Value('PICKLISTNO',ROWLIST_);
      row_.FEEORDERNO :=pkg_a.Get_Item_Value('FEEORDERNO',MAINROWLIST_);
      -- 获取备货单的信息
      SELECT  nvl(T.CREATEDATE,to_char(sysdate,'yyyy-mm-dd')),T.CUSTOMERNO,T.CONTRACT,T.SHIPDATE,T.CUSTOMER_REF
       INTO   ROW_.CREATEDATE,ROW_.CUSTOMERNO,ROW_.CONTRACT,ROW_.SHIPDATE,ROW_.CUSTOMERNO_REF
       FROM  BL_PICKLIST T
       WHERE T.PICKLISTNO = ROW_.PICKLISTNO;
        pkg_a.Set_Item_Value('CREATEDATE',row_.CREATEDATE,attr_out);
        pkg_a.Set_Item_Value('FEEORDERNO',row_.FEEORDERNO,attr_out);
        pkg_a.Set_Item_Value('CUSTOMERNO',row_.CUSTOMERNO,attr_out);
        pkg_a.Set_Item_Value('CONTRACT',row_.CONTRACT,attr_out);
        pkg_a.Set_Item_Value('SHIPDATE',row_.SHIPDATE,attr_out);
        pkg_a.Set_Item_Value('CUSTOMERNO_REF',row_.CUSTOMERNO_REF,attr_out);
        pkg_a.Set_Item_Value('FLAG','0',attr_out);
    end if ;
    OUTROWLIST_ := attr_out; 
    RETURN;
 end ;
 function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 )
 return varchar2 
 is
 ROW_ BL_V_BL_PICKUNITE%ROWTYPE;
 begin
  ROW_.OBJID := pkg_a.Get_Item_Value('OBJID',rowlist_);
  IF NVL(ROW_.OBJID,'NULL') <>'NULL' THEN
     return '0';
  END IF ;
   return '1';
 end  ;
     ----检查新增 修改 
 function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2 
   is
   row0_  BL_V_BL_PICKUNITE_HEAD%rowtype;
   cur_ t_cursor;
  begin    
     open cur_  for 
     select t.*  
     from BL_V_BL_PICKUNITE_HEAD t
     where t.PICKUNITENO=order_no_;
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
end BL_Pick_Order_Unite_line_api;
/
