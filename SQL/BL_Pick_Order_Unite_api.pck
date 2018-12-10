create or replace package BL_Pick_Order_Unite_api is

PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE Modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  -- 取消
  PROCEDURE Cancel__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  --下达
  PROCEDURE Release_(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  -- 完成
  PROCEDURE Finish__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  --取消下达
  PROCEDURE ReleaseCancel(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
    --金额
  function  get_unitamount(pickuniteno_ varchar2,type_ varchar2) return number;
     --当数据发生变化的时候 修改列信息
  PROCEDURE ITEMCHANGE__(COLUMN_ID_ VARCHAR2 ,   MAINROWLIST_  VARCHAR2 ,  ROWLIST_  VARCHAR2, USER_ID_ VARCHAR2, OUTROWLIST_  OUT  VARCHAR2 ) ; 
  function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 ) return varchar2 ;
 ----检查编辑 修改
  function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2 ;
end BL_Pick_Order_Unite_api;
/
create or replace package body BL_Pick_Order_Unite_api is
 type t_cursor is ref cursor;
 /*modify fjp 2013-01-14合并备货单如果有发票则开发票*/
 PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 BEGIN 
   RETURN;
 END;
 
 PROCEDURE Modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 index_ varchar2(1);
 doaction_ varchar2(1);
 pos_ number ;
 pos1_ number ;
 i number ;
 v_  varchar(1000);
 column_id_ varchar(1000);
 data_ varchar(4000);
 mysql_  varchar2(4000);
 ifmychange varchar2(1);
 fee_change varchar2(1);
 objid_  varchar2(100);
 row_ BL_V_BL_PICKUNITE_HEAD%rowtype;
 cur_ t_cursor;
 row0_ bl_v_bl_picihead_v01%rowtype;
 row1_ bl_picihead%rowtype;
 BEGIN 
    index_ := f_get_data_index();
    objid_   := pkg_a.Get_Item_Value('OBJID',index_ || ROWLIST_);
    doaction_ := pkg_a.Get_Item_Value('DOACTION', ROWLIST_);
    IF doaction_='I' then 
      --  获取值
        row_.CONTRACT:=pkg_a.Get_Item_Value('CONTRACT',ROWLIST_ );
        row_.CUSTOMERNO:=pkg_a.Get_Item_Value('CUSTOMERNO',ROWLIST_ );
        row_.FLAG:=pkg_a.Get_Item_Value('FLAG',ROWLIST_ );
        --row_.CUSTOMERNO_REF :=pkg_a.Get_Item_Value('CUSTOMERNO_REF',ROWLIST_ );
      --  if length(row_.CUSTOMERNO) > 2 then
            row_.CUSTOMERNO_REF :=  row_.CUSTOMERNO ;--pkg_a.Get_Item_Value('LABEL_NOTE',ROWLIST_);
/*        else
            row_.CUSTOMERNO_REF :=  pkg_a.Get_Item_Value('CUSTOMERNO_REF',ROWLIST_); 
        end if;*/
        row_.FEEORDERNO     :=pkg_a.Get_Item_Value('FEEORDERNO',ROWLIST_ );
      --  row_.DELDATE        :=to_date(pkg_a.Get_Item_Value('DELDATE',ROWLIST_ ),'yyyy-mm-dd');
        BL_Pick_Order_api.getPickListNo(row_.CONTRACT,row_.CUSTOMERNO,'U',row_.PICKUNITENO);
        row_.SHIP_TYPE  := pkg_a.Get_Item_Value('SHIP_TYPE',ROWLIST_);
        row_.DELDATE    := to_date(pkg_a.Get_Item_Value('DELDATE',ROWLIST_),'YYYY-MM-DD');
        ROW_.BFLAG      := pkg_a.Get_Item_Value('BFLAG',ROWLIST_);
        ROW_.IFCIQ      := PKG_A.Get_Item_Value('IFCIQ',ROWLIST_);
        --插入数据
        insert into BL_PICKUNITEHEAD(CONTRACT,
                                CUSTOMERNO,
                                PICKUNITENO,
                                FLAG,
                                CUSTOMERNO_REF,
                                enter_date,
                                enter_user,
                                modi_date,
                                modi_user,
                                FEEORDERNO,
                                SHIP_TYPE,
                                DELDATE,
                                BFLAG,
                                IFCIQ)
         values(   row_.CONTRACT,
                  row_.CUSTOMERNO,
                  row_.PICKUNITENO,
                  row_.FLAG,
                  row_.CUSTOMERNO_REF,
                  sysdate,
                  USER_ID_,
                  sysdate,
                  USER_ID_,
                  row_.FEEORDERNO,
                  row_.SHIP_TYPE,
                  ROW_.DELDATE,
                  ROW_.BFLAG,
                  ROW_.IFCIQ)
         returning rowid into objid_;
/*                select  t.rowid  
                into  objid_ 
                from  BL_PICKUNITEHEAD t 
                where t.PICKUNITENO =  row_.PICKUNITENO;*/
          -- 插入pi信息
/*           insert into BL_PICIHEAD(INVOICE_NO,INVOICETYPE)
            select  row_.PICKUNITENO,'PI' from  dual;
          open cur_ for 
          select  t.* 
          from bl_v_bl_picihead_v01 t
         where t.INVOICE_NO = row_.PICKUNITENO 
         AND t.ALTERDATE IS NOT NULL
         order by t.ALTERDATE  desc;
          fetch cur_ into row0_;
         if  cur_%found then 
            row1_.invoice_no :=row_.PICKUNITENO;
            row1_.INVOICETYPE :='PI';
            row1_.comname := row0_.comname;
            row1_.address := row0_.address;
            row1_.tel     := row0_.tel;
            row1_.fax     := row0_.fax;
            row1_.shangdate := row0_.shangdate;
            row1_.tomu      :=row0_.tomu;
            row1_.marks     :=row0_.marks;
            row1_.etd       :=row0_.etd;
            row1_.eta       :=row0_.eta;
            row1_.refer     :=row0_.refer;
            row1_.remark    :=row0_.remark;
            row1_.shipby    :=row0_.shipby;
            row1_.payment   :=row0_.payment;
            row1_.fromq     :=row0_.fromq;
            row1_.hb        :=row0_.hb;
            row1_.delivery_desc :=row0_.delivery_desc;
            row1_.custname      :=row0_.custname;
            row1_.custaddress   :=row0_.custaddress;
            row1_.marks1        :=row0_.marks1;
            row1_.marks2        :=row0_.marks2;
            row1_.marks3        :=row0_.marks3;
            row1_.marks4        :=row0_.marks4;
            row1_.bank          :=row0_.bank;
            row1_.wood          :=row0_.wood;
            row1_.trade         :=row0_.trade;
            row1_.strcong       :=row0_.strcong;
            row1_.vatno         :=row0_.vatno;
            row1_.weightpallet  :=row0_.weightpallet;
            row1_.howpallet     :=row0_.howpallet;
            row1_.engrender     :=row0_.engrender;
            row1_.deliveraddress :=row0_.deliveraddress;
            row1_.purchase_no    :=row0_.purchase_no;
            row1_.warehouse      := row0_.warehouse;
            row1_.createdate     :=row0_.createdate;
            row1_.custname2      :=row0_.custname2;
            row1_.invoice_date   :=row0_.invoice_date;
            row1_.showwarehouse  :=row0_.showwarehouse;
            row1_.inviceno2      :=row0_.inviceno2;
            row1_.alterdate      :=sysdate;
            row1_.tracking_no    :=row0_.tracking_no;
            row1_.bank_no        :=row0_.bank_no;
            row1_.bank_info      :=row0_.bank_info;
            row1_.ifpart_no      :=row0_.ifpart_no;
            row1_.origin         :=row0_.origin;
            row1_.origin_desc    :=row0_.origin_desc;
            row1_.shop_add       :=row0_.shop_add;
            row1_.shop_add_desc  :=row0_.shop_add_desc;
            row1_.pay_term_id    :=row0_.pay_term_id;
            update BL_PICIHEAD
               set row =row1_
             where INVOICE_NO = row_.PICKUNITENO;
         end if ;
         close cur_;*/
        pkg_a.setSuccess(A311_KEY_,'BL_V_BL_PICKUNITE_HEAD',objid_);
        return ;
    end if ;
    if doaction_='M' then 
    -- 更改数据
        open cur_
        for select t.*
        from    BL_V_BL_PICKUNITE_HEAD t
        where  t.OBJID =   objid_;
        fetch cur_     into row_   ;
        if cur_%notfound then       
           close cur_ ;
           raise_application_error(-20101, '错误的rowid');
           return ;
        end if ;    
        close cur_ ;  
        data_ := ROWLIST_;
        pos_ := instr(data_,index_);
        i := i + 1 ;
        mysql_     :=' update BL_PICKUNITEHEAD set ';
        --费用更新
        fee_change := '0';
        --表更新
        ifmychange :='0';
       loop 
          exit when nvl(pos_,0) <=0 ;
          exit when i > 300 ;      
          v_ := substr(data_,1,pos_ - 1 ); 
          data_ := substr(data_,pos_ +  1 ) ;
          pos_ := instr(data_,index_);  
          
          pos1_ :=  instr(v_,'|');     
          column_id_ := substr(v_,1 ,pos1_ - 1 );              
          if column_id_ <>  'OBJID' and  column_id_ <> 'DOACTION' and length(nvl(column_id_,'')) > 0  then
              v_ := substr(v_, pos1_ +  1 ) ;
              i := i + 1 ;
              ifmychange := '1';  
            If Column_Id_ = 'DELDATE' Then
            Mysql_ := Mysql_ || ' ' || Column_Id_ || '=to_date(''' || v_ ||
                      ''',''YYYY-MM-DD HH24:MI:SS''),';
            ELSE
              mysql_ := mysql_ || ' ' || column_id_ || '=''' || v_  || ''',';
            END IF;
              if column_id_='FEEORDERNO' then
                 fee_change := '1';
                 row_.FEEORDERNO :=v_;
              end if ;
         end if ;  
        end  loop ;
       if   ifmychange='1' then-- 更新sql语句 
            mysql_ := mysql_ || 'modi_date=sysdate,modi_user='''|| user_id_ ||''' where  PICKUNITENO=''' || row_.PICKUNITENO || '''' ;
            execute immediate mysql_;
            if fee_change='1' then 
                update bl_pickunite
                 set   FEEORDERNO=row_.FEEORDERNO
                 where PICKUNITENO = row_.PICKUNITENO;
            end if ;
       end if ;
       pkg_a.setSuccess(A311_KEY_,'BL_V_BL_PICKUNITE_HEAD',objid_);
       return ;
   end if ;
 END;
  PROCEDURE Cancel__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 ls_pickunitno_ varchar2(20);
 BEGIN 
   -- 取消主档
        UPDATE BL_PICKUNITEHEAD SET
        FLAG = '3',
        feeorderno='',
        modi_date= sysdate,
        modi_user=USER_ID_
        WHERE ROWID = rowid_;
      select  PICKUNITENO into ls_pickunitno_ from  BL_PICKUNITEHEAD   where rowidtochar(ROWID) = rowid_;
    -- 取消明细 
     update BL_PICKUNITE
       set FLAG = '3',
       feeorderno=''
        where PICKUNITENO = ls_pickunitno_;
       --取消有合并号的备货单号
        update  bl_picklist
          set  PICKUNITENO=''
          where PICKUNITENO = ls_pickunitno_;
        update bl_pldtl
          set  PICKUNITENO=''
          where PICKUNITENO = ls_pickunitno_;
        pkg_a.setSuccess(A311_KEY_,'BL_V_BL_PICKUNITE_HEAD',rowid_);
        
        RETURN;
 END;
  PROCEDURE Release_(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 ls_pickunitno_ varchar2(20);
 CUR_ t_cursor;
 BEGIN 
        UPDATE BL_PICKUNITEHEAD SET
        FLAG = '1',
        modi_date= sysdate,
        modi_user=USER_ID_
        WHERE ROWID = rowid_;
       select  PICKUNITENO into ls_pickunitno_ from  BL_PICKUNITEHEAD   where rowidtochar(ROWID) = rowid_;
      update BL_PICKUNITE
       set FLAG = '1'
        where PICKUNITENO = ls_pickunitno_;
        pkg_a.setSuccess(A311_KEY_,'BL_V_BL_PICKUNITE_HEAD',rowid_);
        
        RETURN;
        
 END;
 PROCEDURE Finish__(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 ls_pickunitno_ varchar2(20);
 CUR_ t_cursor;
 row_ BL_V_BL_PICKUNITE_HEAD%rowtype;
 Row2_    Bl_Plinvdtl%ROWTYPE;
 BEGIN 
   open cur_ for 
   select t.*
   from BL_V_BL_PICKUNITE_HEAD t 
  where t.objid=rowid_;
  fetch  cur_ into row_;
  if cur_%notfound  then 
     close cur_ ;
     raise_application_error(-20101, '错误的rowid');
     return ;
  end if;
  close cur_;
        UPDATE BL_PICKUNITEHEAD SET
        FLAG = '2',
        modi_date= sysdate,
        modi_user=USER_ID_
        WHERE ROWID = row_.OBJID;
     --  select  PICKUNITENO into ls_pickunitno_ from  BL_PICKUNITEHEAD   where rowidtochar(ROWID) = rowid_;
      update BL_PICKUNITE
       set FLAG = '2'
        where PICKUNITENO = row_.PICKUNITENO;
        --modify fjp 2013-01-14合并备货单如果有发票则开发票
        if nvl(row_.FEEORDERNO,'NULL') <> 'NULL'   then 
           Bl_Customer_Order_Flow_Api.Start_Create_Invoice__(row_.FEEORDERNO,
                                                             User_Id_,
                                                             A311_Key_);
           --合并备货单写发票记录
            Row2_.Picklistno   := row_.PICKUNITENO;
            Row2_.Order_No     := row_.FEEORDERNO;
            Row2_.Line_No      := '0';
            Row2_.Rel_No       := '0';
            Row2_.Line_Item_No := 0;
            select CONTRACT
              into Row2_.Contract
              from customer_order_tab
             where order_no = row_.FEEORDERNO;
          bl_pick_order_api.Insert_Bl_Plinvdtl(Row2_, User_Id_, A311_Key_);                                                  
        end if;
        pkg_a.setSuccess(A311_KEY_,'BL_V_BL_PICKUNITE_HEAD',rowid_);
        
        RETURN;
        
 END;
 PROCEDURE ReleaseCancel(rowid_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 is
  ls_pickunitno_ varchar2(20);
 begin
    UPDATE BL_PICKUNITEHEAD 
     set   FLAG = '0',
      modi_date= sysdate,
      modi_user=USER_ID_
     WHERE ROWID = rowid_;
     select  PICKUNITENO into ls_pickunitno_ from  BL_PICKUNITEHEAD   where rowidtochar(ROWID) = rowid_;
      update BL_PICKUNITE
       set FLAG = '0'
        where PICKUNITENO = ls_pickunitno_;
      pkg_a.setSuccess(A311_KEY_,'BL_V_BL_PICKUNITE_HEAD',rowid_);
   return ;
 end ;
 function  get_unitamount(pickuniteno_ varchar2,type_ varchar2)
  return number
  is 
  cur_ t_cursor; 
  amountsql_ varchar2(2000); 
  feesql_   varchar2(100);
  amount_ number ;
   begin 
     --获取类型
     amountsql_ :='round(sum('||type_||'),2)';
     amountsql_ := 'SELECT ' || amountsql_ || ' AS ' || type_  || 
                      ' from   BL_PICKUNITEHEAD T
                        inner  join BL_PICKUNITE t1 on t.PICKUNITENO = t1.PICKUNITENO
                        inner join  bl_v_bl_picklist t2 on t1.PICKLISTNO = t2.PICKLISTNO
                        where  T.PICKUNITENO = ''' || pickuniteno_ || ''''; 
      
      if  type_='BL_TAX_AMOUNT'  or type_='BL_AMOUNT' or type_= 'BL_FEE_AMOUNT' or type_= 'BL_UAMOUNT' then -- 折扣，数量  
           if type_ = 'BL_UAMOUNT' or  type_= 'BL_FEE_AMOUNT'  then
               feesql_ := 'ROUND(SUM(charge_amount_with_tax * charged_qty), 2)'; 
           end if;
           if type_ = 'BL_AMOUNT' then
               feesql_ := 'ROUND(SUM(charge_amount * charged_qty), 2)'; 
           end if;
           if type_ = 'BL_TAX_AMOUNT' then
               feesql_ := 'ROUND(SUM((charge_amount_with_tax - charge_amount) * charged_qty), 2)'; 
           end if;
        amountsql_ := amountsql_|| ' union SELECT ' || feesql_ || ' AS ' || type_  || 
         ' from   CUSTOMER_ORDER_CHARGE_TAB T
          where  nvl(INVOICED_QTY,0) =0 
          and  t.order_no  in (select FEEORDERNO from BL_PICKUNITEHEAD where PICKUNITENO='''||pickuniteno_||''')';
      end if ;
  open cur_  for amountsql_ ;  
  fetch cur_ into amount_;
  
  if cur_%notfound then
     amount_ := 0 ;
  end if ;
  close cur_;
  return nvl(amount_,0);
   exception
     when others
     then
     return 0;  
  end;
 PROCEDURE ITEMCHANGE__(COLUMN_ID_ VARCHAR2 ,MAINROWLIST_  VARCHAR2 ,ROWLIST_  VARCHAR2,USER_ID_ VARCHAR2, OUTROWLIST_  OUT  VARCHAR2)
 IS 
 begin
    RETURN;
 end ;
 function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 )
 return varchar2 
 is
 begin
  if doaction_ ='M'  then 
    IF column_id_='FEEORDERNO' or column_id_='DELDATE'  THEN 
      return '1';
    END IF ;
     return '0';
  end if ;
   return '1';
 end  ;
     ----检查新增 修改 
 function CheckButton__(dotype_ in varchar2 ,order_no_ in varchar2,user_id_ in varchar2 )  return varchar2 
   is
   row0_ BL_V_BL_PICKUNITE_HEAD%rowtype;
   cur_ t_cursor;
  begin
    open cur_  for 
     select t.*  
     from BL_V_BL_PICKUNITE_HEAD t
     where t.PICKUNITENO=order_no_;
     fetch cur_ into row0_;
     if cur_%found then 
        if row0_.FLAG ='2' or row0_.FLAG='1' then
           close cur_;
            return '0';
        end if ; 
     end if ;
     close cur_;
      return '1';  
 end;
end BL_Pick_Order_Unite_api;
/
