create or replace package bl_RETURN_MATERIAL_API is

  PROCEDURE BACKCARRAY__(ROWLIST_  VARCHAR2,
                         USER_ID_  VARCHAR2,
                         A311_KEY_ VARCHAR2);
  PROCEDURE BACKNOCARRAY__(ROWLIST_  VARCHAR2,
                           USER_ID_  VARCHAR2,
                           A311_KEY_ VARCHAR2);
  PROCEDURE COMPLETE__(rowid_  VARCHAR2,
                       USER_ID_  VARCHAR2,
                       A311_KEY_ VARCHAR2);
  --客户退货主档否定                     
  PROCEDURE DENY__(rowid_  VARCHAR2,--bl_v_return_material的objid
                   USER_ID_  VARCHAR2,
                   A311_KEY_ VARCHAR2);
  PROCEDURE INDEMNITY__(ROWLIST_  VARCHAR2,
                        USER_ID_  VARCHAR2,
                        A311_KEY_ VARCHAR2);
  --客户退货主档保存                     
  PROCEDURE MODIFY__(ROWLIST_  VARCHAR2, --bl_v_return_material视图更改字段与值的字符串
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
  -- 更新bl_return_material表                   
  procedure Usermodify__(Row_     IN bl_return_material%ROWTYPE,
                         User_Id_ IN VARCHAR2);
  --获取编码
  PROCEDURE Getseqno(Type_ IN VARCHAR2, User_Id_ IN VARCHAR2,
                     Seqw_ IN NUMBER, Seq_ OUT VARCHAR2);
  --客户退货主档初始值                   
  PROCEDURE NEW__(ROWLIST_ VARCHAR2, --空值
                  USER_ID_ VARCHAR2, 
                  A311_KEY_ VARCHAR2);
   --客户退货主档下达               
  PROCEDURE RELEASE__(rowid_    VARCHAR2,--bl_v_return_material的objid
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2);
  --提交
  PROCEDURE Submit__(rowid_    VARCHAR2,--bl_v_return_material的objid
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2); 
  --工厂确定退回                                   
  PROCEDURE UNTREAD__(rowid_  VARCHAR2,--bl_v_return_material_line的objid
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2);
  --工厂确定                    
  PROCEDURE Determine__(ROWID_ VARCHAR2,--bl_v_return_material_v01的objid
                        USER_ID_ VARCHAR2,
                        A311_KEY_ VARCHAR2);
  PROCEDURE REMOVE__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
  --检测最底层的客户订单是否发货完成
  function Check_Finish_Deliver(rma_no_ varchar2,
                                rma_line_no_ varchar2) return varchar2;                                      
  PROCEDURE ITEMCHANGE__(COLUMN_ID_   VARCHAR2,
                         MAINROWLIST_ VARCHAR2,
                         ROWLIST_     VARCHAR2,
                         USER_ID_     VARCHAR2,
                         OUTROWLIST_  OUT VARCHAR2);
  --获明细值                       
  function Get_Return_Material_Amount(RMA_NO_ varchar2,
                                      type_ varchar2)
                                      return number;
  function checkUseable(doaction_  in varchar2,
                        column_id_ in varchar,
                        ROWLIST_   in varchar2) return varchar2;
  function CheckButton__(dotype_   in varchar2,
                         order_no_ in varchar2,
                         user_id_  in varchar2) return varchar2;
end bl_RETURN_MATERIAL_API;
/
create or replace package body BL_RETURN_MATERIAL_API is
  ---------------------------------------------------------
  /*create fjp 2012-10-25
   modify fjp 2012-11-12 增加外部客户号
   modify fjp 2012-11-16 增加检测工厂订单收货完成
   modify fjp 2012-12-06 添加提交的时候检测批次的信息*/
  ---------------------------------------------------------
  type t_cursor is ref cursor;
  PROCEDURE BACKCARRAY__(ROWLIST_  VARCHAR2,
                         USER_ID_  VARCHAR2,
                         A311_KEY_ VARCHAR2) IS
  BEGIN
    RETURN;
  END;

  PROCEDURE BACKNOCARRAY__(ROWLIST_  VARCHAR2,
                           USER_ID_  VARCHAR2,
                           A311_KEY_ VARCHAR2) IS
  BEGIN
    RETURN;
  END;

  PROCEDURE COMPLETE__(rowid_  VARCHAR2,
                       USER_ID_  VARCHAR2,
                       A311_KEY_ VARCHAR2) IS
    cur_    t_cursor;
    cur1_ t_cursor;
    row_    BL_V_RETURN_MATERIAL%ROWTYPE;
    row1_  bl_v_return_material_line%rowtype; 
    ll_count_ number;                  
  BEGIN
    open cur_ for
    select t.* from BL_V_RETURN_MATERIAL t where t.objid = rowid_;
    fetch cur_
      into row_;
    if cur_%notfound then
      close cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      RETURN;
    end if;
    close cur_;
    -----modify 2012-11-16 检测工厂域收货完成  未测试先隐掉------
    if  row_.RETURN_TYPE <> '1' then --只赔款/扣款 不检测工厂的数据
     open  cur1_ for
     select t.*
     from bl_v_return_material_line t
     where t.RMA_NO = row_.RMA_NO
     and  t.state='Released';
     fetch cur1_ into row1_;
     while cur1_%found loop
        if Check_Finish_Deliver(row1_.RMA_NO,row1_.RMA_line_NO)='1'  then 
           close cur1_;
           Raise_Application_Error(-20101, '底层订单存在未收货');
           RETURN;
        end if ;
       fetch cur1_ into row1_;
     end loop;
     close cur1_;
     end if;
    -----end--------------------------------------
     open  cur1_ for
     select t.*
     from bl_v_return_material_line t
     where t.RMA_NO = row_.RMA_NO
     and  t.state='Released';
     fetch cur1_ into row1_;
     while cur1_%found loop
       BL_RETURN_MATERIAL1_API.Return_CustomerStock_(row1_.RMA_NO,row1_.RMA_line_NO);
       fetch cur1_ into row1_;
     end loop;
     close cur1_;
      --更新客户退货的状态（最底层订单通过手工入库）
      IF  ROW_.STATE='Return Completed' THEN 
        update  bl_return_material_line
          set   flag ='5'
          where  RMA_NO     =  row_.RMA_NO
           AND  FLAG='3'; 
       END IF ;
      update bl_return_material t
       set t.flag ='5'
      where t.BLORDER_NO =row_.blorder_no
      and not exists(select  1  
                     from bl_return_material_line t1 
                      where t1.rma_no = t.rma_no 
                      and t1.flag not in('5','4') );
      update BL_PURCHASE_ORDER_RETRUN t
       set t.state ='5'
      where t.BLORDER_NO =row_.blorder_no
       and  not exists(select  1  
                     from BL_PURCHASE_ORDER_RETRUN_DTL t1 
                      where t1.INSPECT_NO = t.INSPECT_NO 
                      and t1.state not in('5','4') );
      --- IFS批准退款                
       Return_Material_API.Approve_For_Credit__(row_.RMA_NO);  
       --建立红字发票
       IFSAPP.Invoice_Customer_Order_API.Create_Invoice_From_Return__(row_.RMA_NO); 
       IFSAPP.Return_Material_API.Refresh_State(row_.RMA_NO);            
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_RETURN_MATERIAL', rowid_);
    RETURN;
  END;

  PROCEDURE DENY__(rowid_  VARCHAR2,
                   USER_ID_  VARCHAR2,
                   A311_KEY_ VARCHAR2) IS
    attr_   varchar2(4000);
    info_   varchar2(4000);
    action_ varchar2(100);
    cur_    t_cursor;
    row_    BL_V_RETURN_MATERIAL%ROWTYPE;
  BEGIN
    open cur_ for
    select t.* from BL_V_RETURN_MATERIAL t where t.objid = rowid_;
    fetch cur_
      into row_;
    if cur_%notfound then
      close cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      RETURN;
    end if;
    close cur_;
    action_ := 'DO';
    RETURN_MATERIAL_API.DENY__(info_,
                                  rowid_,
                                  row_.Objversion,
                                  attr_,
                                  action_);
      update bl_return_material
       set flag ='4'
      where RMA_NO =row_.RMA_NO;
      update bl_return_material_line
       set flag ='4'
      where RMA_NO =row_.RMA_NO;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_RETURN_MATERIAL', rowid_);
    RETURN;
  END;

  PROCEDURE INDEMNITY__(ROWLIST_  VARCHAR2,
                        USER_ID_  VARCHAR2,
                        A311_KEY_ VARCHAR2) IS
  BEGIN
    RETURN;
  END;

  PROCEDURE MODIFY__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
    row_           BL_V_RETURN_MATERIAL%rowtype;
    attr_          varchar2(4000);
    Attr_CUSTOMER_ VARCHAR2(4000);
    attr_out_      varchar2(4000);
    info_          varchar2(4000);
    objid_         varchar2(4000);
    objversion_    varchar2(4000);
    action_        varchar2(100);
    index_         varchar2(1);
    doaction_      varchar2(1);
    Cur_           t_Cursor;
    Pos_           NUMBER;
    Pos1_          NUMBER;
    i              NUMBER;
    v_             VARCHAR(1000);
    Column_Id_     VARCHAR(1000);
    Data_          VARCHAR(4000);
    row0_         bl_return_material%rowtype;
    Ifmychange  VARCHAR(10);
  BEGIN
    index_     := f_get_data_index();
    row_.objid := pkg_a.Get_Item_Value('OBJID', ROWLIST_);
    doaction_  := pkg_a.Get_Item_Value('DOACTION', ROWLIST_);
    if doaction_ = 'I' then
      /*新增*/
      attr_ := '';
      client_sys.Add_To_Attr('RETURN_APPROVER_ID',
                             pkg_a.Get_Item_Value('RETURN_APPROVER_ID',
                                                  ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('DATE_REQUESTED',
                             pkg_a.Get_Item_Value('DATE_REQUESTED',
                                                  ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('CONTRACT',
                             pkg_a.Get_Item_Value('CONTRACT', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('CURRENCY_CODE',
                             pkg_a.Get_Item_Value('CURRENCY_CODE', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('CUSTOMER_NO',
                             pkg_a.Get_Item_Value('CUSTOMER_NO', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('CUST_REF',
                             pkg_a.Get_Item_Value('CUST_REF', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('PRICE_WITH_TAX',
                             pkg_a.Get_Item_Value('PRICE_WITH_TAX',
                                                  ROWLIST_),
                             attr_);
      Row_.Customer_No := Pkg_a.Get_Item_Value('CUSTOMER_NO', Rowlist_);
      Row_.Contract    := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Client_Sys.Add_To_Attr('CONTRACT', Row_.Contract, Attr_CUSTOMER_);
      Client_Sys.Add_To_Attr('CUSTOMER_NO',
                             Row_.Customer_No,
                             Attr_CUSTOMER_);
      Customer_Order_API.Get_Customer_Defaults__(Attr_CUSTOMER_);
      client_sys.Add_To_Attr('SHIP_ADDR_NO',
                             Client_Sys.Get_Item_Value('SHIP_ADDR_NO',
                                                       Attr_CUSTOMER_),
                             attr_);
      client_sys.Add_To_Attr('LANGUAGE_CODE',
                             Client_Sys.Get_Item_Value('LANGUAGE_CODE',
                                                       Attr_CUSTOMER_),
                             attr_);
      client_sys.Add_To_Attr('CUSTOMER_NO_ADDR_NO',
                             Client_Sys.Get_Item_Value('BILL_ADDR_NO',
                                                       Attr_CUSTOMER_),
                             attr_);
      attr_out_ := attr_;
      action_   := 'CHECK';
      RETURN_MATERIAL_API.New__(info_, objid_, objversion_, attr_, action_);
      attr_   := attr_out_;
      action_ := 'DO';
      RETURN_MATERIAL_API.New__(info_, objid_, objversion_, attr_, action_);
      pkg_a.setSuccess(A311_KEY_, 'BL_V_RETURN_MATERIAL', objid_);
      row0_.rma_no := Client_Sys.Get_Item_Value('RMA_NO', Attr_);
      Row0_.flag   := '0';
      Row0_.flowid   := 0;
      row0_.return_type  := pkg_a.Get_Item_Value('RETURN_TYPE',ROWLIST_);
      row0_.lot_batch_no := pkg_a.Get_Item_Value('LOT_BATCH_NO',ROWLIST_);
      row0_.label_note   := pkg_a.Get_Item_Value('LABEL_NOTE',ROWLIST_);
      row0_.IF_FIRST     := '1';
/*      select bl_return_material_seq.NEXTVAL 
       into row0_.blorder_no  
       from dual; */
       --获取保隆订单号
          BL_RETURN_MATERIAL_API.Getseqno(To_Char(SYSDATE, 'YY') ||
                                     Row_.Customer_No,
                                     User_Id_,
                                     4,
                                     row0_.blorder_no);
      Usermodify__(Row0_, User_Id_);
    end if;
    IF Doaction_ = 'M' THEN
      /*修改*/
      OPEN Cur_ FOR
        SELECT t.* FROM BL_V_RETURN_MATERIAL t WHERE t.Objid = Row_.Objid;
      FETCH Cur_
        INTO Row_;
      IF Cur_%NOTFOUND THEN
        CLOSE Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        RETURN;
      END IF;
      CLOSE Cur_;
    
      /*获取有几列发生了修改*/
      Data_ := Rowlist_;
      Pos_  := Instr(Data_, Index_);
      i     := i + 1;
      Ifmychange := '0';
      LOOP
        EXIT WHEN Nvl(Pos_, 0) <= 0;
        EXIT WHEN i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        if Column_Id_ ='LOT_BATCH_NO' or Column_Id_='LABEL_NOTE'  then 
           Ifmychange := '1';
        else
          --组要传入给IFS 的修改包       
          IF Column_Id_ <> 'OBJID' AND Column_Id_ <> 'DOACTION' AND
             Length(Nvl(Column_Id_, '')) > 0 THEN
            v_ := Substr(v_, Pos1_ + 1);
            Client_Sys.Add_To_Attr(Column_Id_, v_, Attr_);
            i := i + 1;
          END IF;
       end if;
      END LOOP;
      Action_ := 'DO';
      --调用 IFS 修改包  
      RETURN_MATERIAL_API.MODIFY__(Info_,
                                   Row_.Objid,
                                   Row_.Objversion,
                                   Attr_,
                                   Action_);
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_RETURN_MATERIAL', Row_.Objid);
      if Ifmychange='1' then 
          row0_.rma_no := row_.RMA_NO;
          row0_.lot_batch_no := pkg_a.Get_Item_Value('LOT_BATCH_NO',ROWLIST_);
          row0_.label_note  := pkg_a.Get_Item_Value('LABEL_NOTE',ROWLIST_);
         -- Raise_Application_Error(-20101, '错误的rowid'||row0_.label_note);
          Usermodify__(Row0_, User_Id_);
          -- 更新明细的批次号 
          update bl_return_material_line
           set lot_batch_no =  row0_.lot_batch_no
           where rma_no = row0_.rma_no
           and  lot_batch_no is null;
      end if;
    END IF;
    RETURN;
  END;
  --记录保存 BL 的表
  PROCEDURE Usermodify__(Row_     IN bl_return_material%ROWTYPE,
                         User_Id_ IN VARCHAR2) IS
    Cur_  t_Cursor;
    Row0_ bl_return_material%ROWTYPE;
  
  BEGIN
    OPEN Cur_ FOR
      SELECT t.* FROM bl_return_material t WHERE t.rma_no = Row_.rma_no;
    FETCH Cur_
      INTO Row0_;
    IF Cur_%NOTFOUND THEN
      INSERT INTO bl_return_material
        (rma_no,
         flag,
         flowid,
         blorder_no,
         RETURN_TYPE,
         LOT_BATCH_NO,
         LABEL_NOTE,
         IF_FIRST,
         Enter_Date,
         Enter_User)
        SELECT Row_.rma_no,
               row_.flag,
               row_.flowid,
               row_.blorder_no,
               row_.return_type,
               row_.lot_batch_no,
               row_.label_note,
               row_.if_first,
               sysdate,
               User_Id_
          FROM Dual;
    ELSE
      UPDATE bl_return_material
         SET blorder_no    = Nvl(Row_.blorder_no, blorder_no),
             flag          = Nvl(Row_.flag, flag),
             flowid        = Nvl(Row_.flowid, flowid),
             return_type   = nvl(row_.return_type,return_type),
             LOT_BATCH_NO  = nvl(row_.LOT_BATCH_NO,LOT_BATCH_NO),
             LABEL_NOTE    = nvl(row_.LABEL_NOTE,LABEL_NOTE),
             Modi_Date     = SYSDATE,
             Modi_User     = User_Id_
       WHERE rma_no = Row_.rma_no;
    END IF;
    CLOSE Cur_;
  
    RETURN;
  END;
    /*获取号码 根据不同的类型号码的流水号*/
  PROCEDURE Getseqno(Type_ IN VARCHAR2, User_Id_ IN VARCHAR2,
                     Seqw_ IN NUMBER, Seq_ OUT VARCHAR2) IS
    Row_  bl_return_material_seq%ROWTYPE;
    Cur  t_Cursor;
  BEGIN
    OPEN Cur FOR
      SELECT t.* FROM  bl_return_material_seq t WHERE t.Seqtype = Type_;
    FETCH Cur
      INTO Row_;
    IF Cur%NOTFOUND THEN
      INSERT INTO  bl_return_material_seq
        (Seqtype, Seq, Enter_Date, Enter_User)
        SELECT Type_, 0, SYSDATE, User_Id_ FROM Dual;
      Row_.Seq := 0;
    END IF;
    CLOSE Cur;
    Seq_ := Type_ || Substr(To_Char(Power(10, Seqw_) + Row_.Seq + 1), 2);
    UPDATE  bl_return_material_seq
       SET Modi_Date = SYSDATE, Modi_User = User_Id_, Seq = Seq + 1
     WHERE Seqtype = Type_;
    RETURN;
  END;
  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2) IS
    attr_       varchar2(4000);
    info_       varchar2(4000);
    objid_      varchar2(4000);
    objversion_ varchar2(4000);
    action_     varchar2(100);
    attr_out    varchar2(4000);
    Contract_   varchar2(10);
  BEGIN
    action_ := 'PREPARE';
    RETURN_MATERIAL_API.NEW__(info_, objid_, objversion_, attr_, action_);
    attr_out := pkg_a.Get_Attr_By_Ifs(attr_);
        --获取用户默认的域
    Contract_ := Pkg_Attr.Get_Default_Contract(User_Id_);
    If (Nvl(Contract_, '0') <> '0') Then
      Pkg_a.Set_Item_Value('CONTRACT', Contract_, Attr_Out);
    End If;
    pkg_a.setResult(A311_KEY_, attr_out);
    RETURN;
  END;

  PROCEDURE RELEASE__(rowid_    VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2) IS
    attr_   varchar2(4000);
    info_   varchar2(4000);
    action_ varchar2(100);
    cur_    t_cursor;
    row_    BL_V_RETURN_MATERIAL%ROWTYPE;
    ll_count_ number;
  BEGIN
    open cur_ for
      select t.* from BL_V_RETURN_MATERIAL t where t.objid = rowid_;
    fetch cur_
      into row_;
    if cur_%notfound then
      close cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      RETURN;
    end if;
    close cur_;
    --如果是内部客户，判断明细是否都确定了
    if row_.RETURN_TYPE ='3'  then 
       select  count(*)
        into ll_count_
       from bl_v_return_material_line
       where rma_no = row_.RMA_NO
       and flag <>'4'  
       and ((flag ='1' and porder_no <> order_no)--有内部订单的等工厂确定才可以下达
     --  or (flag='1'  and nvl(porder_no,order_no)=order_no)--没有内部订单的直接下达
       or   lot_batch_no is null
        or flag='0');
       if ll_count_ >  0 then 
           Raise_Application_Error(-20101, '明细行有未确认的退货申请或没有录入批次');
           RETURN;
       end if ;
    end if ;
    action_ := 'DO';
    RETURN_MATERIAL_API.RELEASE__(info_,
                                  rowid_,
                                  row_.Objversion,
                                  attr_,
                                  action_);
    --调用自动生成采购申请函数
    if row_.RETURN_TYPE ='3' then 
      BL_RETURN_MATERIAL1_API.Return_CustomerRelease_(row_.RMA_NO,
                                                       USER_ID_,
                                                       A311_KEY_);  
    end if;
    --更新新增的表
     UPDATE BL_RETURN_MATERIAL
       SET  FLAG ='3' 
      WHERE  RMA_NO = ROW_.RMA_NO;
     UPDATE BL_RETURN_MATERIAL_LINE
      SET   FLAG ='3'
      WHERE  RMA_NO = ROW_.RMA_NO
      AND   flag <>'4';                  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_RETURN_MATERIAL', rowid_);
    RETURN;
  END;
 PROCEDURE Submit__(rowid_    VARCHAR2,--bl_v_return_material的objid
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2)
 is 
   cur_    t_cursor;
   row_    BL_V_RETURN_MATERIAL%ROWTYPE;
   ll_count_  number;
 begin
     open cur_ for
      select t.* from BL_V_RETURN_MATERIAL t where t.objid = rowid_;
    fetch cur_
      into row_;
    if cur_%notfound then
      close cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      RETURN;
    end if;
    close cur_;
    --2012-12-06 fjp 增加检测批次的信息---
    if row_.RETURN_TYPE ='3'  then 
       select  count(*)
        into ll_count_
       from bl_v_return_material_line
       where rma_no = row_.RMA_NO
       and flag <>'4'  
       and lot_batch_no is null;
       if ll_count_ >  0 then 
           Raise_Application_Error(-20101, '明细行没有录入批次');
           RETURN;
       end if ;
    end if ;
    -- end------
    update BL_RETURN_MATERIAL
     set  flag = '1'
    where RMA_NO = row_.RMA_NO;
    update Bl_Return_Material_Line
      set flag ='1'
    where RMA_NO = row_.RMA_NO
      and  flag ='0';  
   Pkg_a.Setsuccess(A311_Key_, 'BL_V_RETURN_MATERIAL', rowid_);
   return ;
 end;
  PROCEDURE UNTREAD__(rowid_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2) IS
   cur_ t_cursor;
   RMA_NO_  varchar2(100);
   row_ BL_V_RETURN_MATERIAL_LINE_V01%rowtype;
  BEGIN
      open cur_ FOR
      select t.*
      from BL_V_RETURN_MATERIAL_LINE_V01 t
      where ROWIDTOCHAR(t.objid) = rowid_;
       fetch cur_ into  row_;
       if cur_%notfound then 
          close cur_;
          Raise_Application_Error(-20101, '错误的rowid');
          RETURN;
       end if;
       close cur_; 
       RMA_NO_ :=substr(row_.RMA_NO,2,length(row_.RMA_NO)-1);
       if substr(row_.RMA_NO,1,1) = 'C' then --客户
         update bl_return_material_line
          set  flag ='0'
          where  RMA_NO = RMA_NO_
          and    RMA_LINE_NO = row_.rma_line_no;
           UPDATE bl_return_material t
               SET  t.flag = '0'
              WHERE t.RMA_NO =  RMA_NO_;
       else -- 供应商
           UPDATE BL_PURCHASE_ORDER_RETRUN_DTL
             SET STATE = '0'
             WHERE INSPECT_NO = RMA_NO_
             and  INSPECT_NO_LINE = row_.RMA_line_NO;
            UPDATE BL_V_PURCHASE_ORDER_RETRUN t
               SET  t.STATE = '0'
              WHERE t.INSPECT_NO =  RMA_NO_;
       end if ;
       Pkg_a.Setsuccess(A311_Key_, 'BL_V_RETURN_MATERIAL_LINE_V01', rowid_);
    RETURN;
  END;
  PROCEDURE Determine__(ROWID_ VARCHAR2,
                        USER_ID_ VARCHAR2,
                        A311_KEY_ VARCHAR2)
   IS
   cur_  t_cursor;
   RMA_NO_ varchar2(100);
    row_ BL_V_RETURN_MATERIAL_V01%rowtype;
   BEGIN
      open cur_ FOR
      select t.*
      from BL_V_RETURN_MATERIAL_V01 t
      where ROWIDTOCHAR(t.objid) = rowid_;
       fetch cur_ into  row_;
       if cur_%notfound then 
          close cur_;
          Raise_Application_Error(-20101, '错误的rowid');
          RETURN;
       end if;
       close cur_;
       RMA_NO_ :=substr(row_.RMA_NO,2,length(row_.RMA_NO)-1);
       IF ROW_.PC_TYPE = 'C' then  -- 客户
           update bl_return_material_line
             set  flag ='2'
           where RMA_NO = RMA_NO_
             and Pkg_Attr.Checkcontract(USER_ID_, PCONTRACT)='1'
/*             and PCONTRACT  IN(select DISTINCT contract  
                                  from bl_usecon t2 inner join  a007 t1 
                                  on t1.bl_userid= t2.userid and  
                                  t1.a007_id=USER_ID_ )*/
             and  flag ='1';
             UPDATE bl_return_material t
               SET  t.flag = '2'
              WHERE t.RMA_NO =  RMA_NO_
               and  not exists(select * from
                               bl_return_material_line t1
                                where t.RMA_NO = t1.RMA_NO
                                and  t1.flag  in ('0','1')); 
        ELSE  -- 采购
          UPDATE BL_V_PURCHASE_ORDER_RETRUN_DTL
           SET  STATE = '2'
           WHERE INSPECT_NO = RMA_NO_
           and Pkg_Attr.Checkcontract(USER_ID_, CO_CONTRACT)='1';
/*           AND CO_CONTRACT IN (SELECT DISTINCT CONTRACT
                                 FROM BL_USECON T2
                                INNER JOIN A007 T1
                                   ON T1.BL_USERID = T2.USERID
                                  AND T1.A007_ID = USER_ID_);*/
            UPDATE BL_V_PURCHASE_ORDER_RETRUN t
               SET  t.STATE = '2'
              WHERE t.INSPECT_NO =  RMA_NO_
               and  not exists(select * from
                               BL_V_PURCHASE_ORDER_RETRUN_DTL t1
                                where t.INSPECT_NO = t1.INSPECT_NO
                                and  t1.state in ('0','1')); 
                      
        END IF;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_RETURN_MATERIAL_V01', rowid_);
      RETURN ;
   END;
  PROCEDURE REMOVE__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
  BEGIN
    RETURN;
  END;
  function Check_Finish_Deliver(rma_no_ varchar2,
                                rma_line_no_ varchar2) return varchar2
  is
  cur_ t_cursor;
  cur1_ t_cursor;
  row_ BL_PURCHASE_ORDER_RETRUN_DTL%rowtype;
  row1_ bl_return_material_line%rowtype;
  ll_count_ number;
  result_ varchar2(1);
  begin 
     open  cur_ for
     select t.* 
     from  BL_PURCHASE_ORDER_RETRUN_DTL t
     where t.RMA_NO  = rma_no_
      and  t.RMA_LINE_NO = rma_line_no_;
      fetch cur_ into row_;
      if cur_%notfound  then 
         select  count(*)
          into ll_count_
          from return_material_line  
          where rma_no= rma_no_
           and  RMA_LINE_NO =  rma_line_no_
           and  state not in('Return Completed','Denied');
          if  ll_count_ > 0 then
              close cur_;
              return '1'; 
          else
              close cur_;
              return '0'; 
          end if ;
      else
          open cur1_ for 
          select t.*
           from  bl_return_material_line t
           where t.INSPECT_NO = row_.inspect_no
            and  t.INSPECT_NO_LINE =row_.inspect_no_line;
            fetch cur1_ into row1_;
            while cur1_%found  loop
                result_ := Check_Finish_Deliver(row1_.RMA_NO,row1_.rma_line_no);
                if result_ ='1'  then 
                   close cur1_;
                   close cur_;
                   return result_;
                end if;
               fetch cur1_ into row1_;
             end loop; 
             close cur1_;
             close cur_;
             return  '0';
      end if;
  end;
  PROCEDURE ITEMCHANGE__(COLUMN_ID_   VARCHAR2,
                         MAINROWLIST_ VARCHAR2, --main 
                         ROWLIST_     VARCHAR2, --行rowlist 
                         USER_ID_     VARCHAR2,
                         OUTROWLIST_  OUT VARCHAR2 --输出
                         ) IS
    attr_out varchar2(4000);
    Attr_   varchar2(4000);
    Row_     BL_V_RETURN_MATERIAL%rowtype;
  begin
    IF Column_Id_ = 'CUSTOMER_NO' then
      Row_.Customer_No   := Pkg_a.Get_Item_Value('CUSTOMER_NO', Rowlist_);
      row_.CONTRACT      := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      row_.CUSTOMER_NAME := Cust_Ord_Customer_Api.Get_Name(Row_.Customer_No);
      Pkg_a.Set_Item_Value('CUSTOMER_NO', Row_.CUSTOMER_NO, Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_NAME', Row_.CUSTOMER_NAME, Attr_Out);
      IF Length(Row_.Contract) > 0
         AND Length(Row_.Customer_No) > 0 THEN
          Client_Sys.Add_To_Attr('CONTRACT', Row_.Contract, Attr_);
          Client_Sys.Add_To_Attr('CUSTOMER_NO', Row_.Customer_No, Attr_);
          Customer_Order_Api.Get_Customer_Defaults__(Attr_);
          Attr_Out := Pkg_a.Get_Attr_By_Ifs(Attr_);
     end if;
     pkg_a.Set_Item_Value('LABEL_NOTE', Row_.CUSTOMER_NO, Attr_Out);
    end if;
    OUTROWLIST_ := attr_out;
    RETURN;
  end;
 function Get_Return_Material_Amount(RMA_NO_ varchar2,
                                      type_ varchar2)
                                      return number
  is
   retrec_          RETURN_MATERIAL_TAB%ROWTYPE;
   rounding_        NUMBER;
   total_sale_line_ NUMBER;

   CURSOR get_total_lines(rounding_ IN NUMBER) IS
     SELECT SUM(ROUND(price_conv_factor * qty_to_return * sale_unit_price, rounding_))
     FROM   RETURN_MATERIAL_LINE_TAB
     WHERE  rma_no = rma_no_
     AND    rowstate != 'Denied';
   CURSOR get_total_lines_with_tax(rounding_ IN NUMBER) IS
     SELECT ROUND(SUM(price_conv_factor * qty_to_return * sale_unit_price_with_tax), rounding_)
     FROM   RETURN_MATERIAL_LINE_TAB
     WHERE  rma_no = rma_no_
     AND    rowstate != 'Denied';
BEGIN
   rounding_ :=2;
   IF (type_ = 'TAX') THEN
      OPEN get_total_lines_with_tax(rounding_);
      FETCH get_total_lines_with_tax INTO total_sale_line_;
      IF (get_total_lines_with_tax%NOTFOUND) THEN
         total_sale_line_ := 0;
      END IF;
      CLOSE get_total_lines_with_tax;
   ELSE
      OPEN get_total_lines(rounding_);
      FETCH get_total_lines INTO total_sale_line_;
      IF (get_total_lines%NOTFOUND) THEN
         total_sale_line_ := 0;
      END IF;
      CLOSE get_total_lines;
   END IF;
   RETURN nvl(total_sale_line_, 0);
  end;
  function checkUseable(doaction_  in varchar2,
                        column_id_ in varchar,
                        ROWLIST_   in varchar2) return varchar2 is
   row_ bl_v_return_material%rowtype;
  begin
    row_.STATE := pkg_a.Get_Item_Value('STATE',ROWLIST_);
    if doaction_ = 'M' then
      if row_.STATE <>'Planned'  then 
         return '0';
      end if ;
      if column_id_ = 'CURRENCY_CODE' or column_id_ = 'CONTRACT' or
         column_id_ = 'CUSTOMER_NO' OR column_id_ = 'PRICE_WITH_TAX' OR 
         column_id_='RETURN_TYPE' then
        return '0';
      end if;      
    end if;
    return '1';
  end;
  ----检查新增 修改 
  function CheckButton__(dotype_   in varchar2,
                         order_no_ in varchar2,
                         user_id_  in varchar2) return varchar2 is
  begin
    return '1';
  end;
end bl_RETURN_MATERIAL_API;
/
