create or replace package BL_Pick_Order_line_api is

  PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE Modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE Remove__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE Finish_Stock(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_  VARCHAR2 ,ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,OUTROWLIST_ OUT VARCHAR2);
  --判断当前列是否可编辑--
  function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 ) return varchar2 ;
 ----检查编辑 修改
  function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2 ;
  --获取原始的单号
  function Get_Original_order_(order_no_ in varchar2) return varchar2;
  function Get_Factory_Contact_(Order_No_     IN VARCHAR2,
                                Line_No_      IN VARCHAR2,
                                Rel_No_       VARCHAR2,
                                LINE_ITEM_NO_     number) return varchar2;
  --根据备货单明细的SUPLIER字段判断用户用户可见的数据
  function Get_Suplier_User(suplier_ varchar2,
                            user_id_ varchar2) return  varchar2;
end BL_Pick_Order_line_api;
/
create or replace package body BL_Pick_Order_line_api is
/* modify fjp 2012-12-06 修改取得备货单明细的供应域SUPLIER
判断采购订单是否有不同的货币 modify 2013-1-9
判断保存的明细是否是同一个源头(采购订单，客户订单)modify fjp 2013-03-07*/
 type t_cursor is ref cursor;
  PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 BEGIN 
   RETURN;
 END;

PROCEDURE Modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 is
 index_ varchar2(1);
 doaction_ varchar2(1);
 objid_  varchar2(100);
 cur_ t_cursor;
 row_  BL_V_PICKLIST_DETAIL%rowtype;
 --row_pdetail_ BL_V_CUST_ORDER_LINE_PDELIVE%rowtype;
 row_detail_ BL_V_BL_PLDTL%rowtype;
 ll_count_  number;
 count_     number;
 BEGIN 
/*  insert into af(col,col01,col02,col03)
  select 'Modify__', ROWLIST_,USER_ID_,A311_KEY_  from  dual ;
  commit;*/
    index_ := f_get_data_index();
    objid_   := pkg_a.Get_Item_Value('OBJID',index_ || ROWLIST_);
    doaction_ := pkg_a.Get_Item_Value('DOACTION', ROWLIST_);
    IF doaction_='I' then 
     -- 获取交货计划的表
        row_.delplan_no  := pkg_a.Get_Item_Value('DELPLAN_NO',ROWLIST_ );
        row_.PICKLISTNO  := pkg_a.Get_Item_Value('PICKLISTNO',ROWLIST_ );
        row_.SUPPLIER    := pkg_a.Get_Item_Value('SUPPLIER',ROWLIST_);
        row_.delived_date:= pkg_a.Get_Item_Value('DELIVED_DATE',ROWLIST_);
       --判断同一个备货单有相同的客户订单行
        select count(*) 
        into ll_count_ 
        from  bl_pldtl   
        where (ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO) 
               in(select  ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO
                 from   BL_V_CUST_ORDER_LINE_PDELIVE
                 where delplan_no = row_.delplan_no
                 and   state='2'
                 and   QTY_DELIVED >0)
          and  PICKLISTNO = row_.PICKLISTNO;
        if ll_count_ >0  then
            raise_application_error(-20101,'跟交货计划'||row_.delplan_no||'有相同的订单行');
            return ;
        end if ; 
      -- 插入备货表的数据
        insert into BL_PLDTL(CONTRACT,
                                CUSTOMERNO,
                                PICKLISTNO,
                                SUPPLIER,
                                ORDER_NO,
                                LINE_NO,
                                REL_NO,
                                LINE_ITEM_NO,
                                PICKQTY,
                                WANTED_DELIVERY_DATE,
                                FINISHDATE,
                                REMARK,
                                FLAG,
                                USERID,
                                FINISHQTY,
                                RELQTY,
                                REASON,
                                DRDATE,
                                NOTETEXT,
                                DEREMARK,
                                REL_DELIVER_DATE,
                                PICKUNITENO)
         select   t.CONTRACT,
                  t.CUSTOMER_NO,
                  row_.PICKLISTNO,
                  --row_.supplier,
                  Get_Factory_Contact_(t.F_ORDER_NO,t.F_LINE_NO,t.F_REL_NO,T.F_LINE_ITEM_NO),
                  t.ORDER_NO,
                  t.LINE_NO,
                  t.REL_NO,
                  t.LINE_ITEM_NO,
                  t.QTY_DELIVED,
                  row_.delived_date,
                  null,
                  '',
                  '0',
                  USER_ID_,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  null,
                  row_.PICKLISTNO
            from BL_V_CUST_ORDER_LINE_PDELIVE t
            where t.delplan_no = row_.delplan_no
            and  t.state='2'
            and t.QTY_DELIVED >0;
            --判断采购订单是否有不同的货币 modify 2013-1-9
            select  count(distinct t.currency_code)
            into ll_count_
            from  purchase_order_line_tab  t 
            inner join bl_pldtl t1 ON t.DEMAND_ORDER_NO = t1.ORDER_NO
                                   AND t.DEMAND_RELEASE = t1.LINE_NO
                                   AND t.DEMAND_SEQUENCE_NO = t1.REL_NO
                                   AND t.DEMAND_OPERATION_NO = t1.LINE_ITEM_NO
                                   and t1.PICKLISTNO=row_.PICKLISTNO;
            if ll_count_ >1 then
                raise_application_error(-20101,'跟交货计划'||row_.delplan_no||'有相同的订单行');
            end if ;
            --判断保存的明细是否是同一个源头(采购订单，客户订单)modify fjp 2013-03-07
            select count(*),sum((case when  ORDER_NO =BL_Pick_Order_line_api.Get_Original_order_(ORDER_NO) then 0 else 1 end))
              into ll_count_,count_
             from  bl_pldtl 
             where PICKLISTNO=row_.PICKLISTNO;
             if (ll_count_ <> count_  and count_<>0 ) then 
                 raise_application_error(-20101,'跟交货计划'||row_.delplan_no||'有不同的源头(采购,客户)');
             end if ;
            ---end-------
            -- 更新交货计划表
            update BL_DELIVERY_PLAN
            set picklistno = row_.PICKLISTNO
            where delplan_no = row_.delplan_no;
            update BL_DELIVERY_PLAN_DETIAL
             set picklistno = row_.PICKLISTNO
            where delplan_no = row_.delplan_no;
        pkg_a.setSuccess(A311_KEY_,'BL_V_PICKLIST_DETAIL',objid_);
        return ;
    end if ;
    -- 删除
    if doaction_='D'  then
        row_.delplan_no   :=  pkg_a.Get_Item_Value('DELPLAN_NO',ROWLIST_ );
        row_.delived_date :=  pkg_a.Get_Item_Value('DELIVED_DATE',ROWLIST_);
        row_.PICKLISTNO   :=  pkg_a.Get_Item_Value('PICKLISTNO',ROWLIST_);
        row_.supplier     :=  pkg_a.Get_Item_Value('SUPPLIER',ROWLIST_);
        delete  from bl_pldtl t 
        where t.picklistno =  row_.PICKLISTNO
        and   t.supplier   = row_.supplier
        and   (t.order_no,t.line_no,t.rel_no,t.line_item_no) 
             in (select t2.order_no,t2.line_no,t2.rel_no,t2.line_item_no 
                from BL_DELIVERY_PLAN_DETIAL t2  where t2.delplan_no = row_.delplan_no);
        update BL_DELIVERY_PLAN
        set picklistno = ''
        where delplan_no = row_.delplan_no;
        UPDATE BL_DELIVERY_PLAN_DETIAL
           set picklistno = ''
        where delplan_no = row_.delplan_no;
        pkg_a.setSuccess(A311_KEY_,'BL_V_PICKLIST_DETAIL',objid_); 
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
 PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_  VARCHAR2 , ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,OUTROWLIST_ OUT VARCHAR2)
 IS 
 cur_ t_cursor;
 attr_out varchar2(4000);
 row_  BL_V_PICKLIST_DETAIL%rowtype;
 BEGIN 
   if  column_id_ = 'DELPLAN_NO'  then -- 交货计划号
    row_.DELPLAN_NO := pkg_a.Get_Item_Value('DELPLAN_NO',ROWLIST_);
    -- 获取交货计划
     open  cur_ for  
       select  t.* 
       from BL_V_PICKLIST_DETAIL t
      where t.delplan_no = row_.delplan_no;
       fetch cur_ into  row_;
       if cur_%notfound then
         close cur_; 
         raise_application_error(-20101,'错误的rowid');
         return ;
       end if;
      close cur_;
       -- 赋值
        pkg_a.Set_Item_Value('CONTRACT',             row_.CONTRACT,      attr_out);
        pkg_a.Set_Item_Value('CUSTOMER_NO',          row_.CUSTOMER_NO,   attr_out);  
        pkg_a.Set_Item_Value('PICKLISTNO',           row_.PICKLISTNO,    attr_out);       
        pkg_a.Set_Item_Value('ORDER_NO',             row_.ORDER_NO,      attr_out); 
        pkg_a.Set_Item_Value('COLUMN_NO',            row_.column_no,     attr_out); 
        pkg_a.Set_Item_Value('CUSTOMER_REF',         row_.customer_ref,  attr_out);  
        pkg_a.Set_Item_Value('VERSION',              row_.VERSION,       attr_out); 
        pkg_a.Set_Item_Value('DELIVED_DATE',         row_.DELIVED_DATE,  attr_out); 
        pkg_a.Set_Item_Value('REMARK',               row_.remark,        attr_out); 
        pkg_a.Set_Item_Value('SUPPLIER',             row_.supplier,      attr_out); 
        pkg_a.Set_Item_Value('BLORDER_NO',           row_.BLORDER_NO,    attr_out);
                                                                      
    end if;
    OUTROWLIST_ :=attr_out;
 end  ;
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
    ----检查新增 修改 
 function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2 
   is
   row0_ bl_picklist%rowtype;
   cur_ t_cursor;
  begin
    open cur_  for 
     select t.*  
     from bl_picklist t
     where t.picklistno=order_no_;
     fetch cur_ into row0_;
     if cur_%found then 
        if row0_.FLAG ='2' or row0_.FLAG='1' OR ROW0_.FLAG='3' then
               return '0';
        end if ;
        close cur_;
     end if ;
     close cur_;
      return '1';  
 end;
 function Get_Original_order_(order_no_ in varchar2) return varchar2
   is 
   cur_ t_cursor;
   row0_ customer_order_line_tab%rowtype;
   begin 
      open cur_  for
      select  t.*
      from customer_order_line_tab t
      where t.order_no = order_no_
      and   t.demand_order_ref1 is  not null;
      fetch cur_ into row0_;
      if cur_%found  then 
          close cur_;
          return row0_.demand_order_ref1;
      end if ;
      close cur_;
      return order_no_ ;
   end;
  function Get_Factory_Contact_(Order_No_       IN VARCHAR2,
                                Line_No_        IN VARCHAR2,
                                Rel_No_         VARCHAR2,
                                LINE_ITEM_NO_   number) return varchar2
   is
   -- modify fjp 2012-12-06 取得供应域
   cur_ t_cursor;
   row_ customer_order_line%rowtype;
   ll_count_ number;
   result_ varchar2(100);
   begin
     open  cur_ for
     select  t.* 
     from customer_order_line t
     where  t.order_no = Order_No_
     and    t.line_no  = Line_No_
     and    t.rel_no=Rel_No_
     and    t.line_item_no =LINE_ITEM_NO_;
     fetch cur_ into row_;
     if cur_%found then 
       --供应信息不为空
        if nvl(row_.vendor_no,'NULL') = 'NULL'  then 
           result_ :=row_.contract;
        else
           select  count(*) 
           into  ll_count_ 
           from bl_unlinecompy  
           where contract = row_.vendor_no;
           if ll_count_ > 0 then--未上线工厂域 
              result_ := row_.vendor_no;
           else--外部采购的料
              result_ := row_.contract||' | '||ROW_.vendor_no;
           end if ;
        end if;
     end if ;
      close cur_;
     return   result_;
   end;
   function Get_Suplier_User(suplier_ varchar2,
                            user_id_ varchar2) return  varchar2
   is
   bl_userid_ varchar2(100);
   ll_count_  number;
   cur_ t_cursor;
   --row_ Bl_Usersurplier%rowtype;
   ls_suplier_ varchar2(10);
   begin
     --获取保隆用户号
    -- select t1.Bl_Userid into bl_userid_ from A007 t1 where t1.a007_id = User_Id_;
   --  if length(suplier_) = 2  then 
/*        select count(*)
         into ll_count_
         from Bl_Usecon t
         where t.Userid = bl_userid_
         and  t.Contract = suplier_;*/
        --modify fjp 2012-12-12  
        --检测用户的域权限
         select count(*)
          into ll_count_
          from a00704 t
          where t.a007_id = user_id_
          and   t.contract  = substr(suplier_,1,2)
          AND ROWNUM =1;
         if ll_count_ > 0 then --存在域的权限
             if length(suplier_) > 5  then --当有外部供应商的时候
                ls_suplier_ :=substr(suplier_,6,length(suplier_)-5);
                -- 检测用户在供应商权限中是否存在
                 select count(*)
                  into ll_count_
                  from A00706
                  where a007_id = user_id_
                  and   CONTRACT = substr(suplier_,1,2)
                  AND ROWNUM =1;
                 if ll_count_ > 0 then 
                   -- 如果存在检测这个用户是否有此供应商的权限
                       select count(*)
                         into ll_count_
                        from A00706 
                        where a007_id = user_id_
                        and   CONTRACT = substr(suplier_,1,2)
                        and   VENDOR_NO= ls_suplier_
                        AND ROWNUM =1;
                       if  ll_count_ > 0 then 
                          return '1';
                       else
                          return '0';
                       end if;
                 else
                    return '1';
                 end if ;
             else --没有外部供应商
                return  '1';
             end if ;
       else
            return '0';
       end if;
     return '0';
   end;
end BL_Pick_Order_line_api;
/
