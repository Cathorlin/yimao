CREATE OR REPLACE PACKAGE BL_TRANSPORT_NOTEF_API IS
  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2);

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE Modify__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2);
  --下达
  PROCEDURE RELEASE__(rowid_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2);
  --取消下达 
  PROCEDURE RELEASECANCEL__(rowid_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2);
  --发货
  PROCEDURE Determine__(rowid_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2);
  --取消
  PROCEDURE CANCEL__(rowid_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2); 
  --根据备货单收下层的货物（进口料采购）
  PROCEDURE Lower_Delivery_(PickListNo_  varchar2,
                            Order_No_   varchar2,
                             Line_No_    varchar2,
                             Release_No_ varchar2,
                             Qty_ number,
                             user_id_ varchar2,
                             A311_Key_ varchar2); 
 --(作废不用) 
 PROCEDURE Deliver_Line_Inv_With_Diff__(Order_No_ varchar2,
                                        Line_No_ varchar2,
                                        Rel_No_ varchar2,
                                        Line_Item_No_ varchar2,
                                        close_line_ number);                             
  /*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
  PROCEDURE Itemchange__(Column_Id_   VARCHAR2,
                         Mainrowlist_ VARCHAR2,
                         Rowlist_     VARCHAR2,
                         User_Id_     VARCHAR2,
                         Outrowlist_  OUT VARCHAR2);
  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  FUNCTION Checkbutton__(Dotype_  IN VARCHAR2,
                         KEY_     IN VARCHAR2,
                         User_Id_ IN VARCHAR2) RETURN VARCHAR2;

  /*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
  */
  FUNCTION Checkuseable(Doaction_  IN VARCHAR2,
                        Column_Id_ IN VARCHAR,
                        Rowlist_   IN VARCHAR2) RETURN VARCHAR2;

END BL_TRANSPORT_NOTEF_API;
/
CREATE OR REPLACE PACKAGE BODY BL_TRANSPORT_NOTEF_API IS
  TYPE t_Cursor IS REF CURSOR;
  --【COLUMN】  列名称 按实际的逻辑 用实际的列名
  -- 【VALUE】  列的数据 按具体的实际逻辑 用对应的参数来替代
  /*
  报错
  Raise_Application_Error(pkg_a.raise_error,'出错了 ！！！！！');
  */

  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 
  备货单(订单)预留表 modify 2013-01-17 
  --modify 2013-03-11 增加采购订单的状态判断*/
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2) IS
    attr_out VARCHAR2(4000);
  BEGIN
    attr_out :='';
  
    -- pkg_a.Set_Item_Value('【COLUMN】','【VALUE】', attr_out);
    pkg_a.Setresult(A311_Key_, attr_out);
  END;

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE Modify__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2) IS
    Objid_    VARCHAR2(50);
    Index_    VARCHAR2(1);
    Cur_      t_Cursor;
    Doaction_ VARCHAR2(10);
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar(4000);
    Ifmychange Varchar(1); 
    row_       BL_V_TRANSPORT_NOTEF%rowtype;
    ROW0_      BL_TRANSPORT_NOTE%ROWTYPE;
    BEGIN  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ ='I'THEN
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      
      --申请单号
    --  row_.NOTE_NO  := Pkg_a.Get_Item_Value('NOTE_NO', Rowlist_)
      ROW0_.NOTE_NO := BL_TRANSPORT_NOTEE_API.GET_NOTE_NO('F');
      --类型
      ROW0_.NOTETYPE  := 'F';
      --备货单号
      ROW0_.PICKLISTNO  := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_);
      --到港号
      ROW0_.EXPRESSID  := Pkg_a.Get_Item_Value('EXPRESSID', Rowlist_);
      --发货时间
      ROW0_.SHIPTIME  := TO_DATE(Pkg_a.Get_Item_Value('SHIPTIME', Rowlist_),'YYYY-MM-DD');
      --备注
      ROW0_.REMARK  := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      --供应商
      ROW0_.VENDOR_NO  := Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_);
      --状态
      ROW0_.STATE  := Pkg_a.Get_Item_Value('STATE', Rowlist_);
      
      INSERT INTO BL_TRANSPORT_NOTE(NOTE_NO)
            VALUES(ROW0_.note_NO)
        RETURNING ROWID INTO Objid_;
      UPDATE BL_TRANSPORT_NOTE
         SET  ROW = ROW0_
        WHERE  ROWID = Objid_;
       --modify fjp 2013-01-07 增加明细
      insert into BL_TRANSPORT_NOTECONTRACT(  note_no   ,
                                              contract    ,
                                              containerno  ,
                                              state )
       SELECT DISTINCT ROW0_.NOTE_NO,SUBSTR(b.SUPPLIER, 1, 2),'0',ROW0_.STATE
          from BL_PLDTL b
         where b.PICKUNITENO = ROW0_.picklistno
           AND b.flag IN ('1', '2');
        ---end----
      PKG_A.SETSUCCESS(A311_KEY_, 'BL_V_TRANSPORT_NOTEF', OBJID_);
      RETURN;
    END IF;
    --修改
    IF Doaction_ ='M'THEN
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
       Open Cur_ For
        Select t.* From BL_V_TRANSPORT_NOTEF t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,'错误的rowid！');
      
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     :='update bl_transport_note SET ';
      Ifmychange :='0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_,'|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
      
        IF COLUMN_ID_ <> 'OBJID' AND COLUMN_ID_ <> UPPER('Doaction') AND
           LENGTH(NVL(COLUMN_ID_, '')) > 0  THEN
          IFMYCHANGE := '1';
          V_         := SUBSTR(V_, POS1_ + 1);
          -- Mysql_     := Mysql_ || Column_Id_ || ='''|| v_ ||'',';
          IF COLUMN_ID_ = 'SHIPTIME' THEN
            V_     := 'TO_DATE(''' || V_ || ''',''YYYY-MM-DD'')';
            MYSQL_ := MYSQL_ || ' ' || COLUMN_ID_ || '=' || V_ || ',';
          ELSE
            MYSQL_ := MYSQL_ || ' ' || COLUMN_ID_ || '=''' || V_ || ''',';
          END IF;
        
        END IF;

        End Loop;

        --用户自定义列
        If Ifmychange ='1' Then 
            MYSQL_ := SUBSTR(MYSQL_, 1, LENGTH(MYSQL_) - 1);
            MYSQL_ := MYSQL_ || ' Where Rowid =''' || ROW_.OBJID || '''';
        -- raise_application_error(Pkg_a.Raise_Error, mysql_);
           Execute Immediate Mysql_;
        End If;

        Pkg_a.Setsuccess(A311_Key_,'BL_V_TRANSPORT_NOTEF', Row_.Objid); 
Return;
End If;
--删除
If Doaction_ ='D'Then
   /*OPEN CUR_ FOR
        SELECT T.* FROM BL_V_TRANSPORT_NOTEF T WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'错误的rowid');
        return;
      end if;
      close cur_;
--      DELETE FROM BL_V_TRANSPORT_NOTEF T WHERE T.ROWID = OBJID_; */
--pkg_a.Setsuccess(A311_Key_,'BL_V_TRANSPORT_NOTEF', Objid_);
Return;
End If;

End;
  --下达
  PROCEDURE RELEASE__(rowid_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2)
   IS 
   row_  BL_V_TRANSPORT_NOTEF%rowtype;
   cur_ t_Cursor;
   BEGIN 
     open cur_ for
     select  t.* 
     from BL_V_TRANSPORT_NOTEF t 
     where t.objid = rowid_;
     fetch cur_ into row_;
     if cur_%notfound then 
       close cur_;
       Raise_Application_Error(Pkg_a.Raise_Error,'错误的rowid！');
     end if;
     close cur_;
     update BL_TRANSPORT_NOTE set  state='1'  where NOTE_NO= row_.note_NO;
     update BL_TRANSPORT_NOTECONTRACT set  state='1' where NOTE_NO= row_.note_NO;
     pkg_a.Setsuccess(A311_Key_,'BL_V_TRANSPORT_NOTEF', row_.OBJID);
     RETURN;
   END;
  --取消下达 
  PROCEDURE RELEASECANCEL__(rowid_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2)
   is                  
    row_  BL_V_TRANSPORT_NOTEF%rowtype;
   cur_ t_Cursor;
   ll_count_ number;
   BEGIN 
     open cur_ for
     select  t.* 
     from BL_V_TRANSPORT_NOTEF t 
     where t.objid = rowid_;
     fetch cur_ into row_;
     if cur_%notfound then 
       close cur_;
       Raise_Application_Error(Pkg_a.Raise_Error,'错误的rowid！');
     end if;
     close cur_;
    --拼车存在不可以取消下达
    select count(*) into ll_count_ from BL_CONTAINPICKLIST_DTL  where NOTE_NO =row_.NOTE_NO and  state <>'3';
    if ll_count_ > 0 then 
       RAISE_APPLICATION_ERROR(-20101, '已经生成拼箱装车不能取消下达');
    end if ;
     update BL_TRANSPORT_NOTE set  state='0'  where NOTE_NO= row_.note_NO;
     update BL_TRANSPORT_NOTECONTRACT set  state='0' where NOTE_NO= row_.note_NO;
     pkg_a.Setsuccess(A311_Key_,'BL_V_TRANSPORT_NOTEF', row_.OBJID);
     RETURN;
   END;
  --关闭
  PROCEDURE Determine__(rowid_  VARCHAR2,
                        User_Id_  VARCHAR2,
                        A311_Key_ VARCHAR2)
  IS 
   row_  BL_V_TRANSPORT_NOTEF%rowtype;
   cur_  t_Cursor;
   row1_ bl_v_bl_pldtl%rowtype;
   BEGIN 
     open cur_ for
     select  t.* 
     from BL_V_TRANSPORT_NOTEF t 
     where t.objid = rowid_;
     fetch cur_ into row_;
     if cur_%notfound then 
       close cur_;
       Raise_Application_Error(Pkg_a.Raise_Error,'错误的rowid！');
     end if;
     close cur_;
     update BL_TRANSPORT_NOTE set  state='5'  where NOTE_NO= row_.note_NO;
     update BL_TRANSPORT_NOTECONTRACT set  state='5' where NOTE_NO= row_.note_NO;
     open cur_ for
     select t.*
     from bl_v_bl_pldtl t 
     where t.picklistno = row_.picklistno;
     fetch cur_ into row1_;
     while cur_%found loop
       Lower_Delivery_(row1_.PICKLISTNO,row1_.org_orderno,row1_.org_lineno,row1_.org_relno,row1_.FINISHQTY,User_Id_,A311_Key_);
       fetch cur_ into row1_;
     end loop;
     close cur_;
     update bl_picklist set flag='2'  where picklistno=row1_.PICKLISTNO; 
     pkg_a.Setsuccess(A311_Key_,'BL_V_TRANSPORT_NOTEF', row_.OBJID);
     RETURN;
   END;
  --取消
  PROCEDURE CANCEL__(rowid_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2)
   IS 
    row_  BL_V_TRANSPORT_NOTEF%rowtype;
   cur_ t_Cursor;
   BEGIN 
     open cur_ for
     select  t.* 
     from BL_V_TRANSPORT_NOTEF t 
     where t.objid = rowid_;
     fetch cur_ into row_;
     if cur_%notfound then 
       close cur_;
       Raise_Application_Error(Pkg_a.Raise_Error,'错误的rowid！');
     end if;
     close cur_;
     update BL_TRANSPORT_NOTE set  state='3'  where NOTE_NO= row_.note_NO;
     update BL_TRANSPORT_NOTECONTRACT set  state='3' where NOTE_NO= row_.note_NO;
     pkg_a.Setsuccess(A311_Key_,'BL_V_TRANSPORT_NOTEF', row_.OBJID);
     RETURN;
   END;
   PROCEDURE Lower_Delivery_(PickListNo_  varchar2,
                             Order_No_   varchar2,
                             Line_No_    varchar2,
                             Release_No_ varchar2,
                             Qty_ number,
                             user_id_ varchar2,
                             A311_Key_ varchar2)
   is 
   cur_ t_Cursor;
   cur1_ t_Cursor;
   cur2_ t_Cursor;
   row1_ customer_order_line_tab%rowtype;
   row2_ Purchase_Order_Line_Part%rowtype;
   row3_ bl_location_special%rowtype;
   Attr_          VARCHAR2(4000);
   Transit_Attr_  VARCHAR2(100);
   ls_if_end_     varchar2(100);
   Info_          Varchar2(1000);
   State_         Varchar2(20);
   Pallet_Id_     Varchar2(100);
   Lot_Batch_No_  varchar2(100);
   Close_Line_    Number;
   row4_          Bl_Pltrans%Rowtype;
   main_state_    varchar2(100);
   begin 
     open cur_ for
     select t.*
     from customer_order_line_tab t
     where t.demand_order_ref1 = Order_No_
     and   t.demand_order_ref2 = Line_No_
     and   t.demand_order_ref3  = Release_No_;
      fetch cur_ into row1_;
     if cur_%found  then
          open cur1_ for
          select t.*
          from Purchase_Order_Line_Part t  
          where t.DEMAND_ORDER_NO    =   row1_.ORDER_NO
            AND t.DEMAND_RELEASE     =   row1_.LINE_NO
            AND t.DEMAND_SEQUENCE_NO =   row1_.REL_NO
            AND t.DEMAND_OPERATION_NO =   row1_.LINE_ITEM_NO;
           fetch cur1_ into row2_;
           if cur1_%notfound then
               close cur1_;
               close cur_;
               Raise_Application_Error(Pkg_a.Raise_Error,'此客户订单没有底层的采购订单');
           else
             --modify 2013-03-11 增加采购订单的状态判断
              select substrb(PURCHASE_ORDER_API.Finite_State_Decode__(rowstate),1,253)
              into  main_state_
               from PURCHASE_ORDER_tab
               where order_no = row2_.order_no;
              if main_state_='Cancelled' or main_state_='Arrived' 
                 or  main_state_='Closed' or main_state_='Planned' or  main_state_='Stopped' then 
                close cur1_;
                close cur_; 
                Raise_Application_Error(Pkg_a.Raise_Error,'此客户订单没有底层的采购订单为'||main_state_); 
              end if;
              SELECT IF_END
              INTO ls_if_end_  
              FROM BL_CUSTOMER_ORDER_LINE T
              WHERE T.ORDER_NO = ROW1_.ORDER_NO
               AND  T.LINE_NO  = ROW1_.LINE_NO
               AND  T.REL_NO   = ROW1_.REL_NO
               AND  T.LINE_ITEM_NO=ROW1_.LINE_ITEM_NO;
               --ls_if_end_ ='1'为最底层的客户订单
              IF ls_if_end_ ='1'  THEN
                --底层采购的收货
                --获取库位号
                open cur2_ for 
                select  t.*
                  from bl_location_special t 
                  where t.contract = row2_.CONTRACT
                   and  t.flag='2' ;
                  fetch  cur2_ into row3_;
                  if cur2_%notfound then 
                     row3_.location_no :='18010101';
                  end if ; 
                  close cur2_; 
                  -- 调用ifs的登记达到的函数 
                  Attr_ := '';
                  Pkg_a.Set_Item_Value('OBJID', Row2_.Objid, Attr_);
                  Pkg_a.Set_Item_Value('DUE_AT_DOCK', Qty_, Attr_);
                  Lot_Batch_No_ :=to_char(sysdate,'yyyymmdd');
                  Pkg_a.Set_Item_Value('LOT_BATCH_NO', Lot_Batch_No_, Attr_);
                  Pkg_a.Set_Item_Value('LOCATION_NO',  row3_.location_no, Attr_);
                  IF Site_Api.Get_Company(Row2_.Contract) =
                     Site_Api.Get_Company(Row2_.Vendor_No) THEN
                    Bl_Receive_Purchase_Order_Api.Create_New_Receipt(Attr_,
                                                                     User_Id_,
                                                                     A311_Key_);
                  ELSE
                    Bl_Receive_Purchase_Order_Api.Packed_Arrival__(Attr_,
                                                                   User_Id_,
                                                                   A311_Key_);
                  END IF;
                  --调用客户订单发货 
                        --调用IFS的预留函数
        /*          Reserve_Customer_Order_Api.Reserve_Manually__(Info_,
                                                                State_,
                                                                row1_.order_no,
                                                                row1_.line_no,
                                                                row1_.rel_no,
                                                                row1_.line_item_no,
                                                                row1_.contract,
                                                                row1_.part_no,
                                                                row3_.location_no,
                                                                Lot_Batch_No_,
                                                                '*',
                                                                '1',
                                                                '*',
                                                                Pallet_Id_,
                                                                Qty_);*/ 
                  --写记录表 备货单(订单)预留表 modify 2013-01-17 
                  Row4_.Picklistno       := PickListNo_;
                  Row4_.Order_No         := row1_.order_no;
                  Row4_.Line_No          := row1_.line_no;
                  Row4_.Rel_No           := row1_.rel_no;
                  Row4_.Line_Item_No     := row1_.line_item_no;
                  Row4_.Qty_Assigned     := Qty_;
                  Row4_.Contract         := row1_.contract;
                  Row4_.Location_No      := row3_.location_no;
                  Row4_.Lot_Batch_No     := Lot_Batch_No_;
                  Row4_.Serial_No        := '*';
                  Row4_.Eng_Chg_Leve     := '1';
                  Row4_.Waiv_Dev_Rej_No  := '*';
                  Row4_.Configuration_Id := '*';
                  Row4_.Catalog_No       := row1_.catalog_no;
                  Row4_.Flag             := '0';
                  --插入备货单(订单)预留表
                  Bl_Co_Deliver_Api.Insert_Bl_Pltrans(Row4_, User_Id_, A311_Key_); 
                  ---end----                                          
                  --IFS提货
                  bl_co_deliver_api.Billlading__(row1_.order_no,user_id_,A311_Key_);
                  --IFS发货
/*                  Info_:='';
                  Attr_ :='';
                  Deliver_Customer_Order_Api.Deliver_Line_Inv_With_Diff__(Info_,
                                                                          row1_.Order_No,
                                                                          row1_.Line_No,
                                                                          row1_.Rel_No,
                                                                          row1_.Line_Item_No,
                                                                          1,
                                                                          Attr_);  */  
                  Info_:='';
                  Attr_ :='';
                  if  row1_.qty_on_order = Qty_  then 
                     Close_Line_ :=1;
                  else
                     Close_Line_ :=0;
                  end if;
                    Pkg_a.Setnextdo(A311_Key_,
                      '进口采购'||row1_.contract||'域销售发货'||row1_.order_no,
                      User_Id_,
                      'BL_CO_DELIVER_API.Deliver_Line_With_Diff__(''' ||
                      PickListNo_ || ''',''' || row1_.Order_No ||
                      ''',''' || row1_.Line_No || ''',''' || row1_.Rel_No ||
                      ''',''' || row1_.Line_Item_No || ''',''' ||
                      Close_Line_ || ''',''' || User_Id_ || ''',''' ||
                      A311_Key_ || ''')',
                      2 / 60 / 24);    
                       
              ELSE
                  Attr_         := '';
                  Transit_Attr_ := '';
                  Client_Sys.Add_To_Attr('DELIVERED_QTY',
                                         Qty_,
                                         Attr_);
                  Client_Sys.Add_To_Attr('CLOSE_CODE', 'Automatic', Attr_);
                  Client_Sys.Add_To_Attr('RECEIPT_DATE',
                                         To_Char(SYSDATE, 'yyyy-mm-dd') ||
                                         '-00.00.00',
                                         Attr_);
                  Client_Sys.Add_To_Attr('ORDER_NO', Row2_.Order_No, Attr_);
                  Client_Sys.Add_To_Attr('LINE_NO', Row2_.Line_No, Attr_);
                  Client_Sys.Add_To_Attr('RELEASE_NO',
                                         Row2_.Release_No,
                                         Attr_);
                  Client_Sys.Add_To_Attr('CONTRACT', Row2_.Contract, Attr_);
                  Client_Sys.Add_To_Attr('SUPLIER_NO',
                                         Row1_.Contract,
                                         Attr_);
                  Client_Sys.Add_To_Attr('PART_NO', Row1_.Catalog_No, Attr_);
                  Client_Sys.Add_To_Attr('UNIT_MEAS',
                                         Row1_.Sales_Unit_Meas,
                                         Attr_);
                  Client_Sys.Add_To_Attr('CUSTOMER_ORDER',
                                         Row1_.Order_No,
                                         Attr_);
                  Client_Sys.Add_To_Attr('CUST_LINE_NO',
                                         Row1_.Line_No,
                                         Attr_);
                  Client_Sys.Add_To_Attr('CUST_REL_NO',
                                         Row1_.Rel_No,
                                         Attr_);
                  Client_Sys.Add_To_Attr('QTY_ON_ORDER',
                                         Row2_.Qty_On_Order,
                                         Attr_);
                  Ifsapp.Purchase_Order_Line_Part_Api.Unpack_Direct_Delivery(Attr_,
                                                                             Transit_Attr_);
             END IF;
             --调用下域的客户订单
              Lower_Delivery_(PickListNo_,row2_.order_no,row2_.line_no,row2_.release_no,Qty_,user_id_,A311_Key_);
           end if ;
           close cur1_;
        --调用下域的客户订单
     end if;
     close cur_;
     return ;
   end; 
  PROCEDURE Deliver_Line_Inv_With_Diff__(Order_No_ varchar2,
                                        Line_No_ varchar2,
                                        Rel_No_ varchar2,
                                        Line_Item_No_ varchar2,
                                        close_line_ number)--(作废不用)
    is 
    Info_              Varchar2(1000);
    Attr_         VARCHAR2(4000);
    begin
     Deliver_Customer_Order_Api.Deliver_Line_Inv_With_Diff__(Info_,
                                                              Order_No_,
                                                              Line_No_,
                                                              Rel_No_,
                                                              Line_Item_No_,
                                                              close_line_,
                                                              Attr_); 
     return; 
    end;  
/*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
Procedure Itemchange__(Column_Id_ Varchar2, Mainrowlist_ Varchar2, Rowlist_ Varchar2, User_Id_ Varchar2, Outrowlist_ Out Varchar2) Is
Attr_Out Varchar2(4000);
ROW_ BL_V_TRANSPORT_NOTEF%ROWTYPE;
Begin
/*If Column_Id_ ='' Then
--给列赋值
Pkg_a.Set_Item_Value('【COLUMN】','【value】', Attr_Out);
--设置列不可用
Pkg_a.Set_Column_Enable('【column】','0', Attr_Out);
--设置列可用
Pkg_a.Set_Column_Enable('【column】','1', Attr_Out);
End If; */
IF COLUMN_ID_ = 'VENDOR_NO' THEN
  ROW_.VENDOR_NO := PKG_A.GET_ITEM_VALUE('VENDOR_NO', ROWLIST_);
  ROW_.VENDER_DESC := SUPPLIER_API.GET_VENDOR_NAME(ROW_.VENDOR_NO);
  PKG_A.SET_ITEM_VALUE('VENDER_DESC', ROW_.VENDER_DESC, ATTR_OUT);
END IF;
Outrowlist_ := Attr_Out;
End;
/*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
Function Checkbutton__(Dotype_ In Varchar2, Key_ In Varchar2, User_Id_ In Varchar2) Return Varchar2 Is
Begin
If Dotype_ ='Add_Row' Then
   Return'1';
End If;
 If Dotype_ ='Del_Row' Then 
    Return'1';
 End If; 
Return'1';
End;

/*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
      返回: 1 可用
      0 不可用
  */
Function Checkuseable(Doaction_ In Varchar2, Column_Id_ In Varchar, Rowlist_ In Varchar2) Return Varchar2 Is
row_ BL_V_TRANSPORT_NOTEF%rowtype;
Begin
/*If Column_Id_ ='【column】'
  Then Return'0';
End If;*/
row_.OBJID := pkg_a.Get_Item_Value('OBJID',rowlist_);
row_.state := pkg_a.Get_Item_Value('STATE',rowlist_);
if nvl(row_.OBJID,'NULL') <> 'NULL' and Column_Id_ ='PICKLISTNO' then
  return '0';
end if ;  
if row_.state  <> '0'  then 
    return '0';
end if ;
 Return'1';
End;

End BL_TRANSPORT_NOTEF_API; 
/
