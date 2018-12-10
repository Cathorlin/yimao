create or replace package BL_Inventory_Part_In_Stock_API is
  --退货入库初始值
  PROCEDURE NEW__(ROWLIST_  VARCHAR2, --空值
                  USER_ID_  VARCHAR2,
                  A311_KEY_ VARCHAR2);
  --退库入库                 
  PROCEDURE Modify__(ROWLIST_  VARCHAR2,--视图BL_V_INVE_PART_IN_STOCK_DELIV的值
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
  PROCEDURE Issue_Part_With_Posting(ROWLIST_ VARCHAR2,
                                    USER_ID_ VARCHAR2,
                                    A311_KEY_ VARCHAR2);
  PROCEDURE ITEMCHANGE__(COLUMN_ID_   VARCHAR2,
                         MAINROWLIST_ VARCHAR2,
                         ROWLIST_     VARCHAR2,
                         USER_ID_     VARCHAR2,
                         OUTROWLIST_  OUT VARCHAR2);
  function checkUseable(doaction_  in varchar2,
                        column_id_ in varchar,
                        ROWLIST_   in varchar2) return varchar2;
  function CheckButton__(dotype_   in varchar2,
                         order_no_ in varchar2,
                         user_id_  in varchar2) return varchar2;
end BL_Inventory_Part_In_Stock_API;
/
create or replace package body BL_Inventory_Part_In_Stock_API is
  /*create fjp 2012-11-01-01*/
  type t_cursor is ref cursor;
  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2) IS
    attr_       varchar2(4000);
    attr_out    varchar2(4000);
    row_        BL_V_INVE_PART_IN_STOCK_DELIV%rowtype;
    main_row_   BL_V_RETURN_MATERIAL_LINE_IN%rowtype;
    cur_        t_cursor;
  BEGIN
    main_row_.contract_part_no :=pkg_a.Get_Item_Value('CONTRACT_PART_NO',ROWLIST_);
    open cur_ for
      select t.*
        from BL_V_RETURN_MATERIAL_LINE_IN t
       where t.contract_part_no =  main_row_.contract_part_no;
    fetch cur_
      into main_row_;
    if cur_%found then
      client_sys.Add_To_Attr('CONTRACT', main_row_.contract, attr_);
      client_sys.Add_To_Attr('PART_NO',main_row_.CATALOG_NO, attr_);
      client_sys.Add_To_Attr('RMA_NO',main_row_.RMA_NO, attr_);
      client_sys.Add_To_Attr('RMA_LINE_NO',main_row_.rma_line_no, attr_);
      row_.LOCATION_NO :=Inventory_Part_Def_Loc_API.Get_Location_No(main_row_.contract,
                                                                    main_row_.CATALOG_NO); 
      client_sys.Add_To_Attr('LOCATION_NO',row_.LOCATION_NO, attr_);
      row_.ENG_CHG_LEVEL :=Inventory_Part_Revision_API.Get_Eng_Chg_Level(main_row_.contract,
                                                                         main_row_.CATALOG_NO, 
                                                                         sysdate);
      client_sys.Add_To_Attr('ENG_CHG_LEVEL',row_.ENG_CHG_LEVEL, attr_);
      row_.CONFIGURATION_ID :='*';
      row_.QTY_ONHAND :=0;
      row_.LOT_BATCH_NO:='*';
      row_.SERIAL_NO:='*';
      row_.WAIV_DEV_REJ_NO:='*';
      client_sys.Add_To_Attr('CONFIGURATION_ID',row_.CONFIGURATION_ID, attr_);
      client_sys.Add_To_Attr('QTY_ONHAND',row_.QTY_ONHAND, attr_);
      client_sys.Add_To_Attr('LOT_BATCH_NO',row_.LOT_BATCH_NO, attr_);
      client_sys.Add_To_Attr('SERIAL_NO',row_.SERIAL_NO, attr_);
      client_sys.Add_To_Attr('WAIV_DEV_REJ_NO',row_.WAIV_DEV_REJ_NO, attr_);
      attr_out := Pkg_a.Get_Attr_By_Ifs(attr_);
    end if;
    close cur_;
    pkg_a.setResult(A311_KEY_, attr_out);
    RETURN;
  END;
  PROCEDURE Modify__(ROWLIST_  VARCHAR2,
                               USER_ID_  VARCHAR2,
                               A311_KEY_ VARCHAR2) IS
  row_  BL_V_INVE_PART_IN_STOCK_DELIV%rowtype;
  doaction_  VARCHAR2(1);
  qty_in_store_ number;
  cur_ t_cursor;
  date_received_ date;
  action_     varchar2(100);
  info_       varchar2(4000);
  BEGIN
    row_.objid := pkg_a.Get_Item_Value('OBJID', ROWLIST_);
    doaction_  := pkg_a.Get_Item_Value('DOACTION', ROWLIST_);
    if doaction_ = 'I'   then  --新增库存状态
       row_.RMA_NO          := pkg_a.Get_Item_Value('RMA_NO',ROWLIST_);
       row_.rma_line_no     := pkg_a.Get_Item_Value('RMA_LINE_NO',ROWLIST_);
       row_.contract        := pkg_a.Get_Item_Value('CONTRACT',ROWLIST_);
       row_.part_no         := pkg_a.Get_Item_Value('PART_NO',ROWLIST_);
       row_.CONFIGURATION_ID:= pkg_a.Get_Item_Value('CONFIGURATION_ID',ROWLIST_);
       row_.LOCATION_NO     := pkg_a.Get_Item_Value('LOCATION_NO',ROWLIST_);
       row_.LOT_BATCH_NO    := pkg_a.Get_Item_Value('LOT_BATCH_NO',ROWLIST_);
       row_.SERIAL_NO       := pkg_a.Get_Item_Value('SERIAL_NO',ROWLIST_);
       row_.ENG_CHG_LEVEL   := pkg_a.Get_Item_Value('ENG_CHG_LEVEL',ROWLIST_);
       row_.WAIV_DEV_REJ_NO := pkg_a.Get_Item_Value('WAIV_DEV_REJ_NO',ROWLIST_);
       qty_in_store_        := PKG_A.Get_Item_Value('QTY_IN_STORE',ROWLIST_);
       IF NVL(qty_in_store_,0) = 0  then 
          Raise_Application_Error(-20101, '事物数量不能为0');
          RETURN;
       end if ;
       row_.source          := pkg_a.Get_Item_Value('SOURCE',ROWLIST_);
       row_.EXPIRATION_DATE := pkg_a.Get_Item_Value('EXPIRATION_DATE',ROWLIST_);
       Return_Material_Line_API.Inventory_Return__(row_.RMA_NO,
                                                   row_.rma_line_no,
                                                   row_.contract,
                                                   row_.part_no,
                                                   row_.CONFIGURATION_ID,
                                                   row_.LOCATION_NO,
                                                   row_.LOT_BATCH_NO,
                                                   row_.SERIAL_NO,
                                                   row_.ENG_CHG_LEVEL,
                                                   row_.WAIV_DEV_REJ_NO,
                                                   qty_in_store_,
                                                   row_.source,
                                                   date_received_,
                                                   row_.EXPIRATION_DATE);
       select objid  
       into row_.objid 
       from BL_V_INVE_PART_IN_STOCK_DELIV
       where RMA_NO=row_.RMA_NO
       and   rma_line_no=row_.rma_line_no
       and  contract=row_.contract
       and   part_no =row_.part_no
       and   LOCATION_NO = row_.LOCATION_NO
       and   LOT_BATCH_NO =row_.LOT_BATCH_NO
       and   SERIAL_NO = row_.SERIAL_NO
       and   ENG_CHG_LEVEL =row_.ENG_CHG_LEVEL
       and   WAIV_DEV_REJ_NO =row_.WAIV_DEV_REJ_NO
       and CONFIGURATION_ID = row_.CONFIGURATION_ID
       and rownum=1;
       Pkg_a.Setsuccess(A311_Key_, 'BL_V_INVE_PART_IN_STOCK_DELIV', row_.objid);     
    end if ;
    if doaction_ = 'M' then
     qty_in_store_ :=PKG_A.Get_Item_Value('QTY_IN_STORE',ROWLIST_);
     row_.EXPIRATION_DATE := PKG_A.Get_Item_Value('EXPIRATION_DATE',ROWLIST_);
     row_.source          := PKG_A.Get_Item_Value('SOURCE',ROWLIST_);
     if nvl(qty_in_store_,0) = 0 then 
       Pkg_a.Setsuccess(A311_Key_, 'BL_V_INVE_PART_IN_STOCK_DELIV', row_.objid);  
       return;
     end if ;
     open cur_ for
     select  t.* 
     from BL_V_INVE_PART_IN_STOCK_DELIV t
     where t.objid = row_.objid;
     fetch cur_ into  row_;
     if cur_%notfound then
        close cur_ ;
        Raise_Application_Error(-20101, '错误的rowid');
        RETURN;
     end if;
     close cur_;
     --ifs写入到库存中
     Return_Material_Line_API.Inventory_Return__(row_.RMA_NO,
                                                 row_.rma_line_no,
                                                 row_.contract,
                                                 row_.part_no,
                                                 row_.CONFIGURATION_ID,
                                                 row_.LOCATION_NO,
                                                 row_.LOT_BATCH_NO,
                                                 row_.SERIAL_NO,
                                                 row_.ENG_CHG_LEVEL,
                                                 row_.WAIV_DEV_REJ_NO,
                                                 qty_in_store_,
                                                 row_.source,
                                                 date_received_,
                                                 row_.EXPIRATION_DATE);

     Pkg_a.Setsuccess(A311_Key_, 'BL_V_INVE_PART_IN_STOCK_DELIV', row_.objid);  
    END IF;
    if  doaction_ = 'D' THEN 
         open cur_ for
         select  t.* 
         from BL_V_INVE_PART_IN_STOCK_DELIV t
         where t.objid = row_.objid;
         fetch cur_ into  row_;
         if cur_%found then
            close cur_ ;
            Raise_Application_Error(-20101, '错误的rowid');
            RETURN;
         end if;
         close cur_;
         if row_.QTY_ONHAND > 0 then 
            Raise_Application_Error(-20101, '库存中存有数量不能删除');
            RETURN;
         end if ;
         action_ :='CHECK';
        INVENTORY_PART_IN_STOCK_API.REMOVE__(info_,row_.OBJID,row_.objversion,action_);
         action_ :='DO';
        INVENTORY_PART_IN_STOCK_API.REMOVE__(info_,row_.OBJID,row_.objversion,action_);
       Pkg_a.Setsuccess(A311_Key_, 'BL_V_INVE_PART_IN_STOCK_DELIV', row_.objid);  
    END IF ;
    RETURN;
  END;
PROCEDURE Issue_Part_With_Posting(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 BEGIN 
   RETURN;
 END;
  PROCEDURE ITEMCHANGE__(COLUMN_ID_   VARCHAR2,
                         MAINROWLIST_ VARCHAR2, --main 
                         ROWLIST_     VARCHAR2, --行rowlist 
                         USER_ID_     VARCHAR2,
                         OUTROWLIST_  OUT VARCHAR2 --输出
                         ) IS
    attr_out         varchar2(4000);
    row_ BL_V_INVE_PART_IN_STOCK_DELIV%rowtype; 
    row1_ INVENTORY_LOCATION5%rowtype;
    cur_ t_cursor;
  begin
    if COLUMN_ID_='LOCATION_NO'  then 
      row_.LOCATION_NO :=pkg_a.Get_Item_Value('LOCATION_NO',ROWLIST_);
      row_.contract    :=pkg_a.Get_Item_Value('CONTRACT',ROWLIST_);
      open  cur_ for
      select t.*
      from INVENTORY_LOCATION5 t
      where t.LOCATION_NO = row_.LOCATION_NO
      and   t.contract    =  row_.contract ;
      fetch  cur_ into row1_;
      if cur_%found  then 
          pkg_a.Set_Item_Value('WAREHOUSE',row1_.warehouse,attr_out);
          pkg_a.Set_Item_Value('BAY_NO',row1_.bay_no,attr_out);
          pkg_a.Set_Item_Value('ROW_NO',row1_.row_no,attr_out);
          pkg_a.Set_Item_Value('TIER_NO',row1_.tier_no,attr_out);
          pkg_a.Set_Item_Value('BIN_NO',row1_.bin_no,attr_out);
      end if ;
      close cur_;
    end if ;
    OUTROWLIST_ := attr_out;
    RETURN;
  end;
  function checkUseable(doaction_  in varchar2,
                        column_id_ in varchar,
                        ROWLIST_   in varchar2) return varchar2 is
   row_  BL_V_INVE_PART_IN_STOCK_DELIV%rowtype; 
   row0_ BL_V_RETURN_MATERIAL_LINE_IN%rowtype;
   cur_ t_cursor;                     
  begin
    row_.OBJID := pkg_a.Get_Item_Value('OBJID',ROWLIST_);
    row_.contract_part_no := pkg_a.Get_Item_Value('CONTRACT_PART_NO',ROWLIST_);
    IF NVL(row_.OBJID,'NULL') <> 'NULL' THEN 
       if   column_id_='EXPIRATION_DATE' 
         or column_id_='QTY_IN_STORE'  then 
          return '1';
        end if ;
    else
      if column_id_='QTY_ONHAND'  then 
         open cur_ for
         select t.*
         from BL_V_RETURN_MATERIAL_LINE_IN t
         where  t.contract_part_no = row_.contract_part_no;
         fetch cur_ into row0_;
         if cur_%found then 
            if row0_.QTY_PENDING > 0 then 
                return '1';
            end if ;
         end if ;
         close cur_;
      else
        return '1';
      end if;
    END IF ;
    return '0';
  end;
  ----检查新增 修改 
  function CheckButton__(dotype_   in varchar2,
                         order_no_ in varchar2,
                         user_id_  in varchar2) return varchar2 is
   row0_ BL_V_RETURN_MATERIAL_LINE_IN%rowtype;
   cur_ t_cursor;
  begin
    open cur_  for 
     select t.*  
     from BL_V_RETURN_MATERIAL_LINE_IN t
     where t.CONTRACT_PART_NO=order_no_;
     fetch cur_ into row0_;
     if cur_%found then 
        if row0_.QTY_PENDING = 0 then
               return '0';
        end if ;
        close cur_;
     end if ;
     close cur_;
      return '1';  
  end;
end BL_Inventory_Part_In_Stock_API;
/
