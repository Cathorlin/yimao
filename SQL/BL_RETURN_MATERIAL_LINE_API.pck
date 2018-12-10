create or replace package BL_RETURN_MATERIAL_LINE_API is

  PROCEDURE COMPLETE__(ROWLIST_  VARCHAR2,
                       USER_ID_  VARCHAR2,
                       A311_KEY_ VARCHAR2);
  --明细否定                     
  PROCEDURE DENY__(rowid_  VARCHAR2,--明细表BL_V_RETURN_MATERIAL_LINE的objid
                   USER_ID_  VARCHAR2,
                   A311_KEY_ VARCHAR2);

  --退货明细保存
  PROCEDURE MODIFY__(ROWLIST_  VARCHAR2, --视图BL_V_RETURN_MATERIAL_LINE的值
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
  -- 更新bl_return_material_line表                   
  procedure Usermodify__(Row_     IN bl_return_material_line%ROWTYPE,
                         User_Id_ IN VARCHAR2);
  --入库更新接收到的数量                   
  PROCEDURE RMMODIFY__(ROWLIST_ VARCHAR2,--视图BL_V_RETURN_MATERIAL_LINE_IN的值
                       USER_ID_ VARCHAR2,
                       A311_KEY_ VARCHAR2
                       );                   
  --退货名称初始值
  PROCEDURE NEW__(ROWLIST_  VARCHAR2, --空值
                  USER_ID_  VARCHAR2,
                  A311_KEY_ VARCHAR2);
  --明细提交                
  PROCEDURE RELEASE__(rowid_    VARCHAR2, --明细表BL_V_RETURN_MATERIAL_LINE的objid
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2);
  PROCEDURE REMOVE__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2);
  PROCEDURE UNTREAD__(rowid_  VARCHAR2,
                      USER_ID_  VARCHAR2,
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
end BL_RETURN_MATERIAL_LINE_API;
/
create or replace package body BL_RETURN_MATERIAL_LINE_API is
  /*create fjp 2012-10-25-01*/
  type t_cursor is ref cursor;
  PROCEDURE COMPLETE__(ROWLIST_  VARCHAR2,
                       USER_ID_  VARCHAR2,
                       A311_KEY_ VARCHAR2) IS
  BEGIN
    RETURN;
  END;

  PROCEDURE DENY__(rowid_  VARCHAR2,
                   USER_ID_  VARCHAR2,
                   A311_KEY_ VARCHAR2) IS
    attr_   varchar2(4000);
    info_   varchar2(4000);
    action_ varchar2(100);
    cur_    t_cursor;
    row_    BL_V_RETURN_MATERIAL_LINE%ROWTYPE;
  BEGIN
    open cur_ for
      select t.* from BL_V_RETURN_MATERIAL_LINE t where t.objid = rowid_;
    fetch cur_
      into row_;
    if cur_%notfound then
      close cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      RETURN;
    end if;
    close cur_;
    action_ := 'DO';
    RETURN_MATERIAL_LINE_API.DENY__(info_,
                                       rowid_,
                                       row_.Objversion,
                                       attr_,
                                       action_);
     update bl_return_material_line
      set   flag ='4'
      where RMA_NO = row_.RMA_NO
       and  RMA_LINE_NO = row_.RMA_line_NO;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_RETURN_MATERIAL_LINE', rowid_);
    RETURN;
  END;
  PROCEDURE MODIFY__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
    row_        BL_V_RETURN_MATERIAL_LINE%rowtype;
    attr_       varchar2(4000);
    attr_out_   varchar2(4000);
    info_       varchar2(4000);
    objid_      varchar2(4000);
    objversion_ varchar2(4000);
    action_     varchar2(100);
    index_      varchar2(1);
    doaction_   varchar2(1);
    Cur_        t_Cursor;
    Pos_        NUMBER;
    Pos1_       NUMBER;
    i           NUMBER;
    v_          VARCHAR(1000);
    Column_Id_  VARCHAR(1000);
    Data_       VARCHAR(4000);
    row0_      BL_RETURN_MATERIAL_LINE%rowtype;
     Ifmychange  VARCHAR(10);
  BEGIN
    index_     := f_get_data_index();
    row_.objid := pkg_a.Get_Item_Value('OBJID', ROWLIST_);
    doaction_  := pkg_a.Get_Item_Value('DOACTION', ROWLIST_);
    if doaction_ = 'I' then
      /*新增*/
      client_sys.Add_To_Attr('RMA_NO',
                             pkg_a.Get_Item_Value('RMA_NO', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('CATALOG_NO',
                             pkg_a.Get_Item_Value('CATALOG_NO', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('CONFIGURATION_ID',
                             pkg_a.Get_Item_Value('CONFIGURATION_ID',
                                                  ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('QTY_TO_RETURN',
                             pkg_a.Get_Item_Value('QTY_TO_RETURN', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('RETURN_REASON_CODE',
                             pkg_a.Get_Item_Value('RETURN_REASON_CODE',
                                                  ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('INSPECTION_INFO',
                             pkg_a.Get_Item_Value('INSPECTION_INFO',
                                                  ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('BASE_SALE_UNIT_PRICE',
                             pkg_a.Get_Item_Value('BASE_SALE_UNIT_PRICE',
                                                  ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('SALE_UNIT_PRICE',
                             pkg_a.Get_Item_Value('SALE_UNIT_PRICE',
                                                  ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('SALE_UNIT_PRICE_WITH_TAX',
                             pkg_a.Get_Item_Value('SALE_UNIT_PRICE_WITH_TAX',
                                                  ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('PRICE_CONV_FACTOR',
                             pkg_a.Get_Item_Value('PRICE_CONV_FACTOR',
                                                  ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('VAT_DB',
                             pkg_a.Get_Item_Value('VAT_DB', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('CONTRACT',
                             pkg_a.Get_Item_Value('CONTRACT', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('FEE_CODE',
                             pkg_a.Get_Item_Value('FEE_CODE', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('CURRENCY_RATE',
                             pkg_a.Get_Item_Value('CURRENCY_RATE', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('CONV_FACTOR',
                             pkg_a.Get_Item_Value('CONV_FACTOR', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('COMPANY',
                             pkg_a.Get_Item_Value('COMPANY', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('ORDER_NO',
                             pkg_a.Get_Item_Value('ORDER_NO', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('LINE_NO',
                             pkg_a.Get_Item_Value('LINE_NO', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('REL_NO',
                             pkg_a.Get_Item_Value('REL_NO', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('LINE_ITEM_NO',
                             pkg_a.Get_Item_Value('LINE_ITEM_NO', ROWLIST_),
                             attr_);
      client_sys.Add_To_Attr('PART_NO',
                             pkg_a.Get_Item_Value('PART_NO', ROWLIST_),
                             attr_);  
      attr_out_ := attr_;
      action_   := 'CHECK';
      RETURN_MATERIAL_LINE_API.New__(info_,
                                     objid_,
                                     objversion_,
                                     attr_,
                                     action_);
      attr_   := attr_out_;
      action_ := 'DO';
      RETURN_MATERIAL_LINE_API.New__(info_,
                                     objid_,
                                     objversion_,
                                     attr_,
                                     action_);
      pkg_a.setSuccess(A311_KEY_, 'BL_V_RETURN_MATERIAL_LINE', objid_);
      row0_.RMA_NO := pkg_a.Get_Item_Value('RMA_NO', ROWLIST_);
      row0_.RMA_line_NO :=Client_Sys.Get_Item_Value('RMA_LINE_NO', Attr_);
      row0_.PICKLISTNO :=pkg_a.Get_Item_Value('PICKLISTNO',ROWLIST_);
      row0_.flag :='0';
      row0_.lot_batch_no :=pkg_a.Get_Item_Value('LOT_BATCH_NO',ROWLIST_);
      row0_.porder_no  := pkg_a.Get_Item_Value('PORDER_NO',ROWLIST_);
      row0_.pline_no   := pkg_a.Get_Item_Value('PLINE_NO',ROWLIST_);
      row0_.prel_no    :=pkg_a.Get_Item_Value('PREL_NO',ROWLIST_);
      row0_.pline_item_no := pkg_a.Get_Item_Value('PLINE_ITEM_NO',ROWLIST_);
      row0_.pcontract     := pkg_a.Get_Item_Value('PCONTRACT',ROWLIST_);
      Usermodify__(row0_,USER_ID_);
    end if;
    IF Doaction_ = 'M' THEN
      /*修改*/
      OPEN Cur_ FOR
        SELECT t.*
          FROM Bl_v_Return_Material_Line t
         WHERE t.Objid = Row_.Objid;
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
        if Column_Id_ ='PICKLISTNO' or Column_Id_='LOT_BATCH_NO' then 
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
      RETURN_MATERIAL_LINE_API.MODIFY__(Info_,
                                        Row_.Objid,
                                        Row_.Objversion,
                                        Attr_,
                                        Action_);
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_RETURN_MATERIAL_LINE', Row_.Objid);
      if  Ifmychange= '1' then
          row0_.RMA_NO := row_.RMA_NO;
          row0_.rma_line_no :=row_.RMA_line_NO;
          row0_.PICKLISTNO :=pkg_a.Get_Item_Value('PICKLISTNO',ROWLIST_);
          row0_.LOT_BATCH_NO :=pkg_a.Get_Item_Value('LOT_BATCH_NO',ROWLIST_);
          Usermodify__(row0_,USER_ID_); 
      end if;
    END IF;
    if Doaction_ = 'D' THEN
      --明细删除 
      OPEN Cur_ FOR
        SELECT t.*
          FROM Bl_v_Return_Material_Line t
         WHERE t.Objid = Row_.Objid;
      FETCH Cur_
        INTO Row_;
      IF Cur_%NOTFOUND THEN
        CLOSE Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        RETURN;
      END IF;
      CLOSE Cur_;
      Action_ := 'CHECK';
      RETURN_MATERIAL_LINE_API.Remove__(Info_,
                                        Row_.Objid,
                                        Row_.Objversion,
                                        Action_);
      Action_ := 'DO';
      RETURN_MATERIAL_LINE_API.Remove__(Info_,
                                        Row_.Objid,
                                        Row_.Objversion,
                                        Action_);
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_RETURN_MATERIAL_LINE', Row_.Objid);
      delete from BL_RETURN_MATERIAL_LINE 
      where  RMA_NO = row_.RMA_NO
        and  RMA_LINE_NO = row_.RMA_line_NO;
    END IF;
    RETURN;
  END;
  procedure Usermodify__(Row_     IN bl_return_material_line%ROWTYPE,
                         User_Id_ IN VARCHAR2)
   is
    Cur_  t_Cursor;
    Row0_ bl_return_material_line%ROWTYPE;
  BEGIN
    OPEN Cur_ FOR
      SELECT t.* FROM bl_return_material_line t WHERE t.rma_no = Row_.rma_no and t.RMA_LINE_NO=row_.rma_line_no;
    FETCH Cur_
      INTO Row0_;
    IF Cur_%NOTFOUND THEN
      INSERT INTO bl_return_material_line
        (rma_no  ,
         rma_line_no  ,
         picklistno   ,
         inspect_no  ,
         inspect_no_line ,
         FLAG,
         LOT_BATCH_NO,
         porder_no,
         pline_no,
         prel_no,
         pline_item_no,
         pcontract,
         Enter_Date,
         Enter_User)
        SELECT Row_.rma_no,
               row_.rma_line_no,
               row_.picklistno,
               row_.inspect_no,
               row_.inspect_no_line,
               row_.flag,
               row_.lot_batch_no,
               row_.porder_no,
               row_.pline_no,
               row_.prel_no,
               row_.pline_item_no,
               row_.pcontract,
               sysdate,
               User_Id_
          FROM Dual;
    ELSE
      UPDATE bl_return_material_line
         SET picklistno       = Nvl(Row_.picklistno, picklistno),
             inspect_no       = Nvl(Row_.inspect_no, inspect_no),
             inspect_no_line  = Nvl(Row_.inspect_no_line, inspect_no_line),
             flag             = nvl(row_.flag,flag),
             LOT_BATCH_NO     = nvl(row_.lot_batch_no,lot_batch_no),
             Modi_Date     = SYSDATE,
             Modi_User     = User_Id_
       WHERE rma_no = Row_.rma_no
        and  RMA_LINE_NO =row_.rma_line_no;
    END IF;
    CLOSE Cur_;
    return ;
   end ;
  PROCEDURE RMMODIFY__(ROWLIST_ VARCHAR2,--视图BL_V_RETURN_MATERIAL_LINE_IN的值
                       USER_ID_ VARCHAR2,
                       A311_KEY_ VARCHAR2
                       )
   is
   cur_ t_cursor;
   row_ BL_V_RETURN_MATERIAL_LINE_IN%rowtype;
   doaction_  varchar2(1);
   qty_enter_ number;
    attr_       varchar2(4000);
    info_       varchar2(4000);
    action_     varchar2(100);
   begin
    row_.objid := pkg_a.Get_Item_Value('OBJID', ROWLIST_);
    doaction_  := pkg_a.Get_Item_Value('DOACTION', ROWLIST_);
    qty_enter_ := pkg_a.Get_Item_Value('QTY_ENTRY', ROWLIST_);
     if doaction_='M' and nvl(qty_enter_,0) <>'0' then 
         open cur_ for
         select t.* from BL_V_RETURN_MATERIAL_LINE_IN t
         where  t.objid = row_.objid;
         fetch cur_ into row_;
         if cur_%notfound then
            close cur_;
            Raise_Application_Error(-20101, '错误的rowid');
            RETURN;
         end if ;
         close cur_;
       Action_ := 'DO';
       row_.QTY_RECEIVED := nvl(row_.QTY_RECEIVED,0) + qty_enter_;
       Client_Sys.Add_To_Attr('QTY_RECEIVED', row_.QTY_RECEIVED, Attr_);
      --调用 IFS 修改包  
      RETURN_MATERIAL_LINE_API.MODIFY__(Info_,
                                        Row_.Objid,
                                        Row_.Objversion,
                                        Attr_,
                                        Action_);
    --  Pkg_a.Setsuccess(A311_Key_, 'BL_V_RETURN_MATERIAL_LINE_IN', Row_.Objid);                                  
     end if;
     return;
   end;
  PROCEDURE NEW__(ROWLIST_ VARCHAR2, USER_ID_ VARCHAR2, A311_KEY_ VARCHAR2) IS
    attr_       varchar2(4000);
    info_       varchar2(4000);
    objid_      varchar2(4000);
    objversion_ varchar2(4000);
    action_     varchar2(100);
    attr_out    varchar2(4000);
    main_row_   bl_v_return_material%rowtype;
    cur_        t_cursor;
  BEGIN
    --RMA_NO1184VAT_DBNCONTRACT20COMPANY20
    main_row_.RMA_NO := pkg_a.Get_Item_Value('RMA_NO', ROWLIST_);
    open cur_ for
      select t.*
        from bl_v_return_material t
       where t.rma_no = main_row_.RMA_NO;
    fetch cur_
      into main_row_;
    if cur_%found then
      action_ := 'PREPARE';
      client_sys.Add_To_Attr('RMA_NO', main_row_.RMA_NO, attr_);
      client_sys.Add_To_Attr('VAT_DB', main_row_.VAT_DB, attr_);
      RETURN_MATERIAL_LINE_API.NEW__(info_,
                                     objid_,
                                     objversion_,
                                     attr_,
                                     action_);
      attr_out := Pkg_a.Get_Attr_By_Ifs(Attr_);
      pkg_a.Set_Item_Value('RMA_NO', main_row_.RMA_NO, attr_out);
      pkg_a.Set_Item_Value('VAT_DB', main_row_.VAT_DB, attr_out);
      pkg_a.Set_Item_Value('CONTRACT', main_row_.CONTRACT, attr_out);
      pkg_a.Set_Item_Value('COMPANY',
                           Site_API.Get_Company(main_row_.CONTRACT),
                           attr_out);
      PKG_A.Set_Item_Value('PRICE_WITH_TAX',main_row_.PRICE_WITH_TAX,attr_out);
      if nvl(main_row_.LOT_BATCH_NO,'NULL') <> 'NULL' then 
         pkg_a.Set_Item_Value('LOT_BATCH_NO', main_row_.LOT_BATCH_NO, attr_out);
      end if ;
    end if;
    close cur_;
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
    row_    BL_V_RETURN_MATERIAL_LINE%ROWTYPE;
  BEGIN
    open cur_ for
      select t.* from BL_V_RETURN_MATERIAL_LINE t where t.objid = rowid_;
    fetch cur_
      into row_;
    if cur_%notfound then
      close cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      RETURN;
    end if;
    close cur_;
     update bl_return_material_line
      set   flag ='1'
      where RMA_NO = row_.RMA_NO
       and  RMA_LINE_NO = row_.RMA_line_NO;
     Pkg_a.Setsuccess(A311_Key_, 'BL_V_RETURN_MATERIAL_LINE', rowid_);
/*    action_ := 'DO';
    RETURN_MATERIAL_LINE_API.RELEASE__(info_,
                                       rowid_,
                                       row_.Objversion,
                                       attr_,
                                       action_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_RETURN_MATERIAL_LINE', rowid_);*/
    RETURN;
  END;

  PROCEDURE REMOVE__(ROWLIST_  VARCHAR2,
                     USER_ID_  VARCHAR2,
                     A311_KEY_ VARCHAR2) IS
  BEGIN
    RETURN;
  END;
   PROCEDURE UNTREAD__(rowid_  VARCHAR2,
                      USER_ID_  VARCHAR2,
                      A311_KEY_ VARCHAR2)
    is
    begin
      return ;
    end;
  PROCEDURE ITEMCHANGE__(COLUMN_ID_   VARCHAR2,
                         MAINROWLIST_ VARCHAR2, --main 
                         ROWLIST_     VARCHAR2, --行rowlist 
                         USER_ID_     VARCHAR2,
                         OUTROWLIST_  OUT VARCHAR2 --输出
                         ) IS
    attr_out         varchar2(4000);
    Attr_            varchar2(4000);
    row_             BL_V_RETURN_MATERIAL_LINE%rowtype;
    row1_            BL_V_CO_LINE_RMA_LOV%rowtype;
    mainrow_         BL_V_RETURN_MATERIAL%rowtype;
    row2_            BL_V_RETURN_MATERIAL_LINE_IN%rowtype;
    discount_        number;
    condition_code_  varchar2(200);
    invoice_no_      varchar2(100);
    invoice_item_id_ number;
    Percent_         number;
    sum_qty_on_hand_ number;
    currency_type_   varchar2(100);
    cur_             t_cursor;
    poorder_line_    varchar2(100);
    datalist_        Dbms_Sql.Varchar2_Table;
  begin
    if COLUMN_ID_ = 'CATALOG_NO' then
      --物料 
      row_.CATALOG_NO            := pkg_a.Get_Item_Value('CATALOG_NO',
                                                         ROWLIST_);
      mainrow_.CONTRACT          := pkg_a.Get_Item_Value('CONTRACT',
                                                         MAINROWLIST_);
      mainrow_.language_code     := pkg_a.Get_Item_Value('LANGUAGE_CODE',
                                                         MAINROWLIST_);
      mainrow_.CURRENCY_CODE     := pkg_a.Get_Item_Value('CURRENCY_CODE',
                                                         MAINROWLIST_);
      mainrow_.RMA_NO            := pkg_a.Get_Item_Value('RMA_NO',
                                                         MAINROWLIST_);
      row_.FEE_CODE              := pkg_a.Get_Item_Value('FEE_CODE',
                                                         ROWLIST_);
      row_.company               := pkg_a.Get_Item_Value('COMPANY',
                                                         ROWLIST_);
      row_.CATALOG_DESC_FOR_LANG := Sales_Part_API.Get_Catalog_Desc_For_Lang(mainrow_.CONTRACT,
                                                                             row_.CATALOG_NO,
                                                                             mainrow_.language_code);
      row_.SALES_UNIT_MEAS       := Inventory_Part_API.Get_Unit_Meas(mainrow_.CONTRACT,
                                                                     row_.CATALOG_NO);
      Currency_Rate_API.Get_Currency_Rate_Defaults(currency_type_,
                                                   row_.conv_factor,
                                                   row_.currency_rate,
                                                   row_.company,
                                                   mainrow_.CURRENCY_CODE,
                                                   sysdate);
      ifsapp.Return_Material_Line_API.Get_Price_Info(row_.SALE_UNIT_PRICE,
                                                     row_.BASE_SALE_UNIT_PRICE,
                                                     discount_,
                                                     row_.price_conv_factor,
                                                     row_.FEE_CODE,
                                                     condition_code_,
                                                     mainrow_.CONTRACT,
                                                     mainrow_.CURRENCY_CODE,
                                                     row_.CATALOG_NO,
                                                     row_.ORDER_NO,
                                                     row_.line_no,
                                                     row_.REL_NO,
                                                     row_.LINE_ITEM_NO,
                                                     invoice_no_,
                                                     invoice_item_id_);
      if nvl(row_.FEE_CODE, 'NULL') = 'NULL' then
        row_.FEE_CODE := SALES_PART_API.Get_Fee_Code(IFSAPP.Site_API.Get_Company(mainrow_.CONTRACT),
                                                     row_.CATALOG_NO);
      end if;
      pkg_a.Set_Item_Value('FEE_CODE', row_.FEE_CODE, attr_out);
      Percent_                      := STATUTORY_FEE_API.Get_Percentage(IFSAPP.Site_API.Get_Company(mainrow_.CONTRACT),
                                                                        row_.FEE_CODE);
      row_.SALE_UNIT_PRICE_WITH_TAX := (100 + Percent_) *
                                       row_.SALE_UNIT_PRICE / 100;
      row_.QTY_TO_RETURN            := pkg_a.Get_Item_Value('QTY_TO_RETURN',
                                                            ROWLIST_);
      if nvl(row_.QTY_TO_RETURN, 0) <> 0 then
        row_.TOTAL_PRICE     := row_.QTY_TO_RETURN * row_.price_conv_factor *
                                row_.SALE_UNIT_PRICE;
        row_.TOTAL_PRICE_TAX := row_.QTY_TO_RETURN * row_.price_conv_factor *
                                row_.SALE_UNIT_PRICE_WITH_TAX;
        pkg_a.Set_Item_Value('TOTAL_PRICE', row_.TOTAL_PRICE, attr_out);
        pkg_a.Set_Item_Value('TOTAL_PRICE_TAX',
                             row_.TOTAL_PRICE_TAX,
                             attr_out);
      end if;
      pkg_a.Set_Item_Value('SALE_UNIT_PRICE',
                           row_.SALE_UNIT_PRICE,
                           attr_out);
      pkg_a.Set_Item_Value('SALE_UNIT_PRICE_WITH_TAX',
                           row_.SALE_UNIT_PRICE_WITH_TAX,
                           attr_out);
      pkg_a.Set_Item_Value('CATALOG_DESC_FOR_LANG',
                           row_.CATALOG_DESC_FOR_LANG,
                           attr_out);
      pkg_a.Set_Item_Value('PRICE_CONV_FACTOR',
                           row_.price_conv_factor,
                           attr_out);
      pkg_a.Set_Item_Value('SALES_UNIT_MEAS',
                           row_.SALES_UNIT_MEAS,
                           attr_out);
      pkg_a.Set_Item_Value('CONV_FACTOR', row_.conv_factor, attr_out);
      pkg_a.Set_Item_Value('CURRENCY_RATE', row_.currency_rate, attr_out);
      pkg_a.Set_Item_Value('BASE_SALE_UNIT_PRICE',
                           row_.BASE_SALE_UNIT_PRICE,
                           attr_out);
       pkg_a.Set_Item_Value('PART_NO', ROW_.CATALOG_NO, attr_out);                    
    end if;
    if COLUMN_ID_ = 'RETURN_REASON_CODE' then
      --返回原因
      row_.RETURN_REASON_CODE        := pkg_a.Get_item_value('RETURN_REASON_CODE',
                                                             ROWLIST_);
      row_.RETURN_REASON_DESCRIPTION := RETURN_MATERIAL_REASON_API.Get_Return_Reason_Description(row_.RETURN_REASON_CODE);
      row_.INSPECTION_INFO           := Return_Material_Reason_API.Get_Inspection_Info(row_.RETURN_REASON_CODE);
      pkg_a.Set_Item_Value('RETURN_REASON_DESCRIPTION',
                           row_.RETURN_REASON_DESCRIPTION,
                           attr_out);
      pkg_a.Set_Item_Value('INSPECTION_INFO',
                           row_.INSPECTION_INFO,
                           attr_out);
    end if;
    if COLUMN_ID_ = 'FEE_CODE' then
      --费代码
      row_.FEE_CODE                 := pkg_a.Get_Item_Value('FEE_CODE',
                                                            ROWLIST_);
      mainrow_.CONTRACT             := pkg_a.Get_Item_Value('CONTRACT',
                                                            MAINROWLIST_);
      row_.SALE_UNIT_PRICE          := pkg_a.Get_Item_Value('SALE_UNIT_PRICE',
                                                            ROWLIST_);
      Percent_                      := STATUTORY_FEE_API.Get_Percentage(IFSAPP.Site_API.Get_Company(mainrow_.CONTRACT),
                                                                        row_.FEE_CODE);
      row_.SALE_UNIT_PRICE_WITH_TAX := (100 + Percent_) *
                                       row_.SALE_UNIT_PRICE / 100;
      row_.QTY_TO_RETURN            := pkg_a.Get_Item_Value('QTY_TO_RETURN',
                                                            ROWLIST_);
      row_.price_conv_factor        := pkg_a.Get_Item_Value('PRICE_CONV_FACTOR',
                                                            ROWLIST_);
      IF Nvl(Row_.Fee_Code, 'N') <> 'N' THEN
        Row_.Vat_Db := 'Y';
      ELSE
        Row_.Vat_Db := 'N';
      END IF;
      if nvl(row_.QTY_TO_RETURN, 0) <> 0 then
        row_.TOTAL_PRICE     := row_.QTY_TO_RETURN * row_.price_conv_factor *
                                row_.SALE_UNIT_PRICE;
        row_.TOTAL_PRICE_TAX := row_.QTY_TO_RETURN * row_.price_conv_factor *
                                row_.SALE_UNIT_PRICE_WITH_TAX;
        pkg_a.Set_Item_Value('TOTAL_PRICE_TAX',
                             row_.TOTAL_PRICE_TAX,
                             attr_out);
      end if;
      pkg_a.Set_Item_Value('SALE_UNIT_PRICE_WITH_TAX',
                           row_.SALE_UNIT_PRICE_WITH_TAX,
                           attr_out);
      pkg_a.Set_Item_Value('VAT_DB', row_.VAT_DB, attr_out);
    end if;
    if COLUMN_ID_ = 'QTY_TO_RETURN' then
      -- 数量
      row_.QTY_TO_RETURN            := pkg_a.Get_Item_Value('QTY_TO_RETURN',
                                                            ROWLIST_);
      row_.price_conv_factor        := pkg_a.Get_Item_Value('PRICE_CONV_FACTOR',
                                                            ROWLIST_);
      row_.SALE_UNIT_PRICE          := pkg_a.Get_Item_Value('SALE_UNIT_PRICE',
                                                            ROWLIST_);
      row_.SALE_UNIT_PRICE_WITH_TAX := pkg_a.Get_Item_Value('SALE_UNIT_PRICE_WITH_TAX',
                                                            ROWLIST_);
      row_.TOTAL_PRICE              := row_.QTY_TO_RETURN *
                                       row_.price_conv_factor *
                                       row_.SALE_UNIT_PRICE;
      row_.TOTAL_PRICE_TAX          := row_.QTY_TO_RETURN *
                                       row_.price_conv_factor *
                                       row_.SALE_UNIT_PRICE_WITH_TAX;
      pkg_a.Set_Item_Value('TOTAL_PRICE', row_.TOTAL_PRICE, attr_out);
      pkg_a.Set_Item_Value('TOTAL_PRICE_TAX',
                           row_.TOTAL_PRICE_TAX,
                           attr_out);
    end if;
    if COLUMN_ID_ = 'SALE_UNIT_PRICE' then
      row_.SALE_UNIT_PRICE          := pkg_a.Get_Item_Value('SALE_UNIT_PRICE',
                                                            ROWLIST_);
      mainrow_.CONTRACT             := pkg_a.Get_Item_Value('CONTRACT',
                                                            MAINROWLIST_);
      row_.FEE_CODE                 := pkg_a.Get_Item_Value('FEE_CODE',
                                                            ROWLIST_);
      Percent_                      := STATUTORY_FEE_API.Get_Percentage(IFSAPP.Site_API.Get_Company(mainrow_.CONTRACT),
                                                                        row_.FEE_CODE);
      row_.SALE_UNIT_PRICE_WITH_TAX := (100 + Percent_) *
                                       row_.SALE_UNIT_PRICE / 100;
      row_.QTY_TO_RETURN            := pkg_a.Get_Item_Value('QTY_TO_RETURN',
                                                            ROWLIST_);
      row_.price_conv_factor        := pkg_a.Get_Item_Value('PRICE_CONV_FACTOR',
                                                            ROWLIST_);
      if nvl(row_.QTY_TO_RETURN, 0) <> 0 then
        row_.TOTAL_PRICE     := row_.QTY_TO_RETURN * row_.price_conv_factor *
                                row_.SALE_UNIT_PRICE;
        row_.TOTAL_PRICE_TAX := row_.QTY_TO_RETURN * row_.price_conv_factor *
                                row_.SALE_UNIT_PRICE_WITH_TAX;
        pkg_a.Set_Item_Value('TOTAL_PRICE_TAX',
                             row_.TOTAL_PRICE_TAX,
                             attr_out);
      end if;
    end if;
    IF COLUMN_ID_ = 'ORDER_LINE' then
      row_.order_line := pkg_a.Get_Item_Value('ORDER_LINE', ROWLIST_);
      open cur_ for
        select t.*
          from BL_V_CO_LINE_RMA_LOV t
         where  t.order_no = Pkg_a.Get_Str_(row_.order_line, '-', 1) 
         and    t.LINE_NO  = Pkg_a.Get_Str_(row_.order_line, '-', 2) 
         and    t.REL_NO   = Pkg_a.Get_Str_(row_.order_line, '-', 3) 
         and    t.LINE_ITEM_NO = Pkg_a.Get_Str_(row_.order_line, '-', 4) 
         and    t.order_line = row_.order_line;
      fetch cur_
        into row1_;
      if cur_%found then
        Attr_ := '';
        Return_Material_Line_API.Get_Co_Line_Data(Attr_,
                                                  row1_.ORDER_NO,
                                                  row1_.LINE_NO,
                                                  row1_.REL_NO,
                                                  row1_.LINE_ITEM_NO);
        attr_out                   := pkg_a.Get_Attr_By_Ifs(Attr_);
        row_.CATALOG_NO            := pkg_a.Get_Item_Value('CATALOG_NO',
                                                           attr_out);
        Pkg_a.Set_Column_Enable('CATALOG_NO', '0', Attr_Out);--设置选择了订单行不能修改物料
        mainrow_.CONTRACT          := pkg_a.Get_Item_Value('CONTRACT',
                                                           MAINROWLIST_);
        mainrow_.language_code     := pkg_a.Get_Item_Value('LANGUAGE_CODE',
                                                           MAINROWLIST_);
        mainrow_.CURRENCY_CODE     := pkg_a.Get_Item_Value('CURRENCY_CODE',
                                                           MAINROWLIST_);
        row_.company               := pkg_a.Get_Item_Value('COMPANY',
                                                           ROWLIST_);
        row_.CATALOG_DESC_FOR_LANG := Sales_Part_API.Get_Catalog_Desc_For_Lang(mainrow_.CONTRACT,
                                                                               row_.CATALOG_NO,
                                                                               mainrow_.language_code);
        row_.QTY_TO_RETURN         := pkg_a.Get_Item_Value('QTY_TO_RETURN',
                                                           ROWLIST_);
        if nvl(row_.QTY_TO_RETURN, 0) = 0 then
          row_.QTY_TO_RETURN := PKG_A.Get_Item_Value('POSS_QTY_TO_RETURN',
                                                     attr_out);
           select nvl(sum(QTY_TO_RETURN - nvl(QTY_RETURNED_INV,0)),0)
           into sum_qty_on_hand_
            from return_material_line t 
            where t.order_no = Pkg_a.Get_Str_(row_.order_line, '-', 1) 
             and  t.LINE_NO  = Pkg_a.Get_Str_(row_.order_line, '-', 2) 
             and  t.REL_NO   = Pkg_a.Get_Str_(row_.order_line, '-', 3) 
             and  t.LINE_ITEM_NO = Pkg_a.Get_Str_(row_.order_line, '-', 4); 
          row_.QTY_TO_RETURN := row_.QTY_TO_RETURN - sum_qty_on_hand_;                  
          pkg_a.Set_Item_Value('QTY_TO_RETURN',
                               row_.QTY_TO_RETURN,
                               attr_out);
        END IF;
        row_.SALES_UNIT_MEAS := Inventory_Part_API.Get_Unit_Meas(mainrow_.CONTRACT,
                                                                 row_.CATALOG_NO);
        Currency_Rate_API.Get_Currency_Rate_Defaults(currency_type_,
                                                     row_.conv_factor,
                                                     row_.currency_rate,
                                                     row_.company,
                                                     mainrow_.CURRENCY_CODE,
                                                     sysdate);
        ROW_.order_no     := PKG_A.Get_Item_Value('ORDER_NO', attr_out);
        ROW_.line_no      := PKG_A.Get_Item_Value('LINE_NO', attr_out);
        ROW_.rel_no       := PKG_A.Get_Item_Value('REL_NO', attr_out);
        ROW_.LINE_ITEM_NO := PKG_A.Get_Item_Value('LINE_ITEM_NO', attr_out);
        ifsapp.Return_Material_Line_API.Get_Price_Info(row_.SALE_UNIT_PRICE,
                                                       row_.BASE_SALE_UNIT_PRICE,
                                                       discount_,
                                                       row_.price_conv_factor,
                                                       row_.FEE_CODE,
                                                       condition_code_,
                                                       mainrow_.CONTRACT,
                                                       mainrow_.CURRENCY_CODE,
                                                       row_.CATALOG_NO,
                                                       row_.ORDER_NO,
                                                       row_.line_no,
                                                       row_.REL_NO,
                                                       row_.LINE_ITEM_NO,
                                                       invoice_no_,
                                                       invoice_item_id_);
        if nvl(row_.FEE_CODE, 'NULL') = 'NULL' then
          row_.FEE_CODE := SALES_PART_API.Get_Fee_Code(IFSAPP.Site_API.Get_Company(mainrow_.CONTRACT),
                                                       row_.CATALOG_NO);
        end if;
        Percent_                      := STATUTORY_FEE_API.Get_Percentage(IFSAPP.Site_API.Get_Company(mainrow_.CONTRACT),
                                                                          row_.FEE_CODE);
        row_.SALE_UNIT_PRICE_WITH_TAX := (100 + Percent_) *
                                         row_.SALE_UNIT_PRICE / 100;
        row_.TOTAL_PRICE              := row_.QTY_TO_RETURN *
                                         row_.price_conv_factor *
                                         row_.SALE_UNIT_PRICE;
        row_.TOTAL_PRICE_TAX          := row_.QTY_TO_RETURN *
                                         row_.price_conv_factor *
                                         row_.SALE_UNIT_PRICE_WITH_TAX;
        pkg_a.Set_Item_Value('TOTAL_PRICE', row_.TOTAL_PRICE, attr_out);
        pkg_a.Set_Item_Value('TOTAL_PRICE_TAX',
                             row_.TOTAL_PRICE_TAX,
                             attr_out);
        pkg_a.Set_Item_Value('SALE_UNIT_PRICE',
                             row_.SALE_UNIT_PRICE,
                             attr_out);
        pkg_a.Set_Item_Value('SALE_UNIT_PRICE_WITH_TAX',
                             row_.SALE_UNIT_PRICE_WITH_TAX,
                             attr_out);
        pkg_a.Set_Item_Value('CATALOG_DESC_FOR_LANG',
                             row_.CATALOG_DESC_FOR_LANG,
                             attr_out);
        pkg_a.Set_Item_Value('PRICE_CONV_FACTOR',
                             row_.price_conv_factor,
                             attr_out);
        pkg_a.Set_Item_Value('SALES_UNIT_MEAS',
                             row_.SALES_UNIT_MEAS,
                             attr_out);
        pkg_a.Set_Item_Value('CONV_FACTOR', row_.conv_factor, attr_out);
        pkg_a.Set_Item_Value('CURRENCY_RATE', row_.currency_rate, attr_out);
        pkg_a.Set_Item_Value('BASE_SALE_UNIT_PRICE',
                             row_.BASE_SALE_UNIT_PRICE,
                             attr_out);
        pkg_a.Set_Item_Value('FEE_CODE', row_.FEE_CODE, attr_out);
        mainrow_.return_type := pkg_a.Get_Item_Value('RETURN_TYPE',MAINROWLIST_);
        --获取最底层的工厂订单(域)
        if mainrow_.return_type='3' then --退货退运
           poorder_line_ :=Bl_Customer_Order_Line_Api.Get_Factory_Order_(row_.order_no,
                                                                         row_.line_no,
                                                                         row_.rel_no,
                                                                         row_.line_item_no);
                                                                         
           datalist_ := pkg_a.Get_Str_List_By_Index(poorder_line_, '-');
            row_.porder_no := datalist_(1);
            row_.pline_no  := datalist_(2);
            row_.pREL_NO   := datalist_(3);
            --如果为负数，获取最后一个line_item_no
          ---  row_.pline_item_no :=  --datalist_(4);
            select substr(poorder_line_,instr(poorder_line_,'-',1,3)+1,length(poorder_line_)-instr(poorder_line_,'-',1,3)) 
            into row_.pline_item_no
            from dual;
            row_.PCONTRACT :=Bl_Customer_Order_Line_Api.Get_Factory_Order_(row_.order_no,
                                                                         row_.line_no,
                                                                         row_.rel_no,
                                                                         row_.line_item_no,'1'); 
        else
           row_.PORDER_NO := row_.order_no;
           row_.pline_no  := row_.line_no;
           row_.pREL_NO := row_.rel_no;
           row_.pline_item_no :=row_.line_item_no;
           row_.PCONTRACT := row_.CONTRACT;
        end if ; 
          pkg_a.Set_Item_Value('PORDER_NO', row_.PORDER_NO, attr_out);
          pkg_a.Set_Item_Value('PLINE_NO', row_.PLINE_NO, attr_out);
          pkg_a.Set_Item_Value('PREL_NO', row_.PREL_NO, attr_out);
          pkg_a.Set_Item_Value('PLINE_ITEM_NO', row_.PLINE_ITEM_NO, attr_out);
          pkg_a.Set_Item_Value('PCONTRACT', row_.PCONTRACT, attr_out);                                                         
      end if;
      close cur_;
    end if;
    IF COLUMN_ID_ ='QTY_ENTRY' THEN 
       row2_.QTY_ENTRY     := NVL(PKG_A.Get_Item_Value('QTY_ENTRY',ROWLIST_),0);
       ROW2_.QTY_TO_RETURN := PKG_A.Get_Item_Value('QTY_TO_RETURN',ROWLIST_);
       ROW2_.QTY_RECEIVED  :=NVL(PKG_A.Get_Item_Value('QTY_RECEIVED',ROWLIST_),0);
       IF (ROW2_.QTY_TO_RETURN - ROW2_.QTY_RECEIVED) <  row2_.QTY_ENTRY THEN 
           Raise_Application_Error(-20101, '接收的数量超过允许的归还量');
           RETURN;
       END IF ;
    END IF ;
    IF COLUMN_ID_ = 'PICKLISTNO'  THEN 
       ROW2_.PICKLISTNO  := PKG_A.Get_Item_Value('PICKLISTNO',ROWLIST_);
       row_.order_no     := PKG_A.Get_Item_Value('PORDER_NO',ROWLIST_);
       row_.line_no      := PKG_A.Get_Item_Value('PLINE_NO',ROWLIST_);
       row_.rel_no       := PKG_A.Get_Item_Value('PREL_NO',ROWLIST_);
       row_.line_item_no := PKG_A.Get_Item_Value('PLINE_ITEM_NO',ROWLIST_);
        OPEN  CUR_ FOR 
        SELECT LOT_BATCH_NO
        FROM  BL_PLTRANS  T
        WHERE  T.PICKLISTNO = ROW2_.PICKLISTNO
          AND  T.ORDER_NO = row_.ORDER_NO
          AND  T.LINE_NO  = row_.LINE_NO
          AND  T.REL_NO   = row_.REL_NO
          AND  T.LINE_ITEM_NO =  row_.LINE_ITEM_NO
          AND  T.TRANSID  IS NOT NULL;
          FETCH CUR_ INTO ROW_.LOT_BATCH_NO;
          if cur_%found then 
            pkg_a.Set_Item_Value('LOT_BATCH_NO', row_.LOT_BATCH_NO, attr_out);  
          end if ;
          CLOSE CUR_;
    END IF ;
    OUTROWLIST_ := attr_out;
    RETURN;
  end;
  function checkUseable(doaction_  in varchar2,
                        column_id_ in varchar,
                        ROWLIST_   in varchar2) return varchar2 is
    row_ bl_v_return_material_line%rowtype;
   
  begin
    ROW_.objid := PKG_A.Get_Item_Value('OBJID', ROWLIST_);
    ROW_.state := PKG_A.Get_Item_Value('STATE', ROWLIST_);
    row_.FLAG  := PKG_A.Get_Item_Value('FLAG', ROWLIST_);
    ROW_.RMA_NO := PKG_A.Get_Item_Value('RMA_NO',ROWLIST_);
    ROW_.price_with_tax := PKG_A.Get_Item_Value('PRICE_WITH_TAX',ROWLIST_);
    IF NVL(ROW_.objid, 'NULL') <> 'NULL' THEN
      IF column_id_ = 'QTY_TO_RETURN' or column_id_ = 'SALE_UNIT_PRICE' or
         column_id_ = 'RETURN_REASON_CODE' or column_id_ = 'FEE_CODE' or
         column_id_ = 'INSPECTION_INFO' or column_id_='QTY_ENTRY'
          or column_id_='LOT_BATCH_NO' OR COLUMN_ID_='SALE_UNIT_PRICE_WITH_TAX' THEN
         IF  ROW_.state <> 'Planned' THEN 
            RETURN '0';
         ELSE
            IF  ROW_.PRICE_WITH_TAX='TRUE'    THEN 
              IF COLUMN_ID_='SALE_UNIT_PRICE'  THEN 
                 return '0';
              END IF ;
            ELSE
              IF COLUMN_ID_='SALE_UNIT_PRICE_WITH_TAX' THEN 
                RETURN '0';
              END IF ;
            END IF ;
             if row_.FLAG <> '0' then 
                RETURN '0';
             else
              return '1';
             end if;
         END IF;
      else
        return '0';
      end if;
    ELSE
      IF  ROW_.PRICE_WITH_TAX='TRUE'    THEN 
        IF COLUMN_ID_='SALE_UNIT_PRICE'  THEN 
           return '0';
        END IF ;
      ELSE
        IF COLUMN_ID_='SALE_UNIT_PRICE_WITH_TAX' THEN 
          RETURN '0';
        END IF ;
      END IF ;
    END IF;
    return '1';
  
  end;
  ----检查新增 修改 
  function CheckButton__(dotype_   in varchar2,
                         order_no_ in varchar2,
                         user_id_  in varchar2) return varchar2 is
   cur_ t_cursor;
   row_ bl_v_return_material%rowtype;
  begin
    open cur_ for
    select t.*
     from bl_v_return_material t
     where t.rma_no = order_no_;
     fetch cur_ into row_;
     if cur_%found then
        if row_.STATE <>'Planned' then
           close cur_; 
            return '0';
         end if; 
         if row_.flag <>'0'  then 
            close cur_; 
            return '0';
         end if ;
     end if;
     close cur_;
    return '1';
  end;

end BL_RETURN_MATERIAL_LINE_API;
/
