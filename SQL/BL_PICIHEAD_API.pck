CREATE OR REPLACE PACKAGE BL_PICIHEAD_API IS
  /*  ������ʼ�� New__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���requseturl ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ */
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2);

  /*  �������� Modify__
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
  */
  PROCEDURE Modify__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2);
  /*  �з����仯��ʱ��
      Column_Id_   ��ǰ�޸ĵ���
      Mainrowlist_ ���������� ��ϸ��ֵ������Ϊ��
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      Outrowlist_  ���������   
  */
  PROCEDURE Itemchange__(Column_Id_   VARCHAR2,
                         Mainrowlist_ VARCHAR2,
                         Rowlist_     VARCHAR2,
                         User_Id_     VARCHAR2,
                         Outrowlist_  OUT VARCHAR2);
  /*  �з����仯��ʱ��
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ������� �� ɾ���� ��ť 
      KEY_ ����������ֵ
      User_Id_  ��ǰ�û�
  */
  FUNCTION Checkbutton__(Dotype_  IN VARCHAR2,
                         KEY_     IN VARCHAR2,
                         User_Id_ IN VARCHAR2) RETURN VARCHAR2;

  /*  ʵ��ҵ���߼������е� �༭��
      Doaction_   I M ��ϸ�϶�Ϊ M   I ���� M �޸� ҳ�������� ��ǰ�����е� �����Ե��Ժ� ����  
      Column_Id_  ��
      Rowlist_  ��ǰ�û�
  */
  FUNCTION Checkuseable(Doaction_  IN VARCHAR2,
                        Column_Id_ IN VARCHAR,
                        Rowlist_   IN VARCHAR2) RETURN VARCHAR2;

END BL_PICIHEAD_API;
/
CREATE OR REPLACE PACKAGE BODY BL_PICIHEAD_API IS
  TYPE t_Cursor IS REF CURSOR;
  --��COLUMN��  ������ ��ʵ�ʵ��߼� ��ʵ�ʵ�����
  -- ��VALUE��  �е����� �������ʵ���߼� �ö�Ӧ�Ĳ��������
  /*
  ����
  Raise_Application_Error(pkg_a.raise_error,'������ ����������');
  */

  /*  ������ʼ�� New__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���requseturl ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ 
  modify fjp 2013-02-28 �������������ݲɹ�������Ϣ��pici ���������ݿͻ�������Ϣ��pici*/
  
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2) IS
    attr_out VARCHAR2(4000);
    REQUESTURL_ VARCHAR2(4000);
    ROW_ BL_V_BL_PICIHEAD%ROWTYPE;
    row1_ BL_PICIBANK_TAB%rowtype;
   -- rowc_ customer_order_tab%rowtype;
    option_ varchar2(1);
    TYPE_  VARCHAR2(1);
    SQL_ VARCHAR2(4000);
    COMPANY_ VARCHAR2(10);
    cur_  t_Cursor;
    cur1_ t_Cursor;
    cur2_ t_Cursor;
    METHOD_ID_ varchar2(20);--��ϵ������
    VALUE_     varchar2(200);--��ϵ��ֵ
    gk_flag_      varchar2(1);
    bflag_        varchar2(1);--���������ǲ���������
    currency_code_  customer_order_tab.currency_code%type;
    order_no_       customer_order_tab.order_no%type;
    customer_no_    customer_order_tab.customer_no%type;
    BILL_ADDR_NO_   customer_order_tab.BILL_ADDR_NO%type;
    market_code_    customer_order_tab.market_code%type;
    district_code_  customer_order_tab.district_code%type;
    Delivery_Terms_ customer_order_tab.Delivery_Terms%type;
    contract_       customer_order_tab.contract%type;
    cust_ref_       customer_order_tab.cust_ref%type;
    PAY_TERM_ID_    customer_order_tab.PAY_TERM_ID%type;
    Ship_Addr_No_   customer_order_tab.Ship_Addr_No%type;
  BEGIN
    REQUESTURL_            := PKG_A.GET_ITEM_VALUE('REQUESTURL', ROWLIST_);
   -- SELECT  COL01 INTO REQUESTURL_ FROM AF WHERE COL='REQUESTURL_';
    ROW_.INVOICE_NO        := PKG_A.Get_Item_Value_By_Index('&plno=','',REQUESTURL_);
    option_                := PKG_A.Get_Item_Value_By_Index('&option=','&',REQUESTURL_);
    TYPE_                  := PKG_A.Get_Item_Value_By_Index('&TYPE=','&',REQUESTURL_);
/*    ROW_.INVOICE_NO :='13A0155009';
    option_ :='I';
    TYPE_ :='P';*/
    attr_out :='';
    if option_='I'   then 
      pkg_a.Set_Item_Value('INVOICE_NO',ROW_.INVOICE_NO,attr_out);
/*      if TYPE_='P' THEN 
         SQL_ :='SELECT SHIP_TYPE,Site_API.Get_Company(CONTRACT),nvl(CUSTOMER_REF,CUSTOMERNO),LOCATION  FROM BL_PICKLIST WHERE PICKLISTNO='''||ROW_.INVOICE_NO||'''';
      ELSE
         SQL_ :='SELECT SHIP_TYPE,Site_API.Get_Company(CONTRACT),nvl(CUSTOMERNO_REF,CUSTOMERNO),'''' AS LOCATION  FROM BL_PICKUNITEHEAD WHERE PICKUNITENO='''||ROW_.INVOICE_NO||'''';
      END IF ;*/ --���ݺϲ����ſ���ȡ�ñ�����ͷ����Ϣ
       SQL_ :='SELECT SHIP_TYPE,Site_API.Get_Company(CONTRACT),nvl(CUSTOMER_REF,CUSTOMERNO),LOCATION,BFLAG  FROM BL_PICKLIST WHERE PICKUNITENO='''||ROW_.INVOICE_NO||''' and FLAG<>''3''';
       open cur_ for  SQL_;
       fetch  cur_ into ROW_.SHIPBY,COMPANY_,row_.CUSTOMER_REF,row_.WAREHOUSE,bflag_;
       IF CUR_%FOUND   then 
         --���䷽ʽ
         pkg_a.Set_Item_Value('SHIPBY',row_.SHIPBY, attr_out);
         --�ͻ���
         pkg_a.Set_Item_Value('CUSTOMER_REF',row_.CUSTOMER_REF, attr_out);
         --��λ��
         pkg_a.Set_Item_Value('WAREHOUSE',row_.WAREHOUSE,attr_out);
/*         if TYPE_ ='U' then
            --select picklistno into picklistno_ from BL_PICKUNITE  where  PICKUNITENO = ROW_.INVOICE_NO AND ROWNUM=1;
            SQL_ :=' select t.*  from customer_order_tab t  inner join  bl_pldtl t1 on t.order_no = t1.order_no and t1.flag <> ''3''
                   INNER JOIN BL_PICKUNITE T0 ON T0.PICKLISTNO=T1.PICKLISTNO where t0.PICKUNITENO = '''||ROW_.INVOICE_NO||''' order by t.date_entered desc';
         else
          --  picklistno_ :=ROW_.INVOICE_NO;
            SQL_ :=' select t.*  from customer_order_tab t  inner join  bl_pldtl t1 on t.order_no = t1.order_no and t1.flag <> ''3''
                     where t1.picklistno = '''||ROW_.INVOICE_NO||''' order by t.date_entered desc';
         end if ;*/
         if bflag_ ='0' then --�ͻ�����  modify fjp 2013-02-28
               SQL_ :=' select t.currency_code,t.order_no,t.customer_no,t.BILL_ADDR_NO,t.market_code,t.district_code,t.Delivery_Terms,t.contract,t.cust_ref,t.PAY_TERM_ID,t.Ship_Addr_No  
                       from customer_order_tab t  inner join  bl_pldtl t1 on t.order_no = t1.order_no and t1.flag <> ''3''
                       where t1.PICKUNITENO = '''||ROW_.INVOICE_NO||''' order by t.date_entered desc';
         else--�ɹ�����
            SQL_ :=' select t0.currency_code,t0.order_no,t0.contract,t0.DELIVERY_ADDRESS,t0.EXITPORT,t0.AIMPORT,t0.Delivery_Terms,t0.contract,'' '',t0.PAY_TERM_ID,t0.DELIVERY_ADDRESS
                    from bl_v_purchase_order t0 inner join customer_order_line_tab t  on t0.order_no = t.demand_order_ref1 inner join  bl_pldtl t1 
                     on t.order_no = t1.order_no and t1.flag <> ''3'' and  t.line_no = t1.line_no and  t.rel_no = t1.rel_no and t.line_item_no = t1.line_item_no 
                     where t1.PICKUNITENO = '''||ROW_.INVOICE_NO||''' order by t.date_entered desc';
         end if;
         --��ȡ�ͻ�����
           open cur1_ for 
      /*     select t.*
           from customer_order_tab t
           inner join  bl_pldtl t1 on t.order_no = t1.order_no and t1.flag <> '3'
           where t1.picklistno = picklistno_
           order by t.date_entered desc*/
           SQL_;
          -- fetch cur1_ into rowc_;
          fetch cur1_ into currency_code_,order_no_,customer_no_,BILL_ADDR_NO_,market_code_,district_code_,Delivery_Terms_,contract_,cust_ref_,PAY_TERM_ID_,Ship_Addr_No_;
           if cur1_%found then
             --�ͻ������õ��ǿͻ���
             -- rowc_.customer_no := row_.CUSTOMER_REF;
             --���� 
               row_.HB := currency_code_;--rowc_.currency_code;
               pkg_a.Set_Item_Value('HB',row_.HB, attr_out);
             --�ͻ�����  
               row_.PURCHASE_NO :=  order_no_;
               pkg_a.Set_Item_Value('PURCHASE_NO',row_.PURCHASE_NO, attr_out);
               --�˷�
                 open cur2_ for 
                 select PAY_TERM_ID,CI_COMPANY   
                   from BL_CUSTOMEGROUP  
                  where CUSTOMERNO= row_.CUSTOMER_REF;
                  fetch cur2_ into row_.CARRIAGE,row_.COMADDR_NO;
                  close cur2_;
                pkg_a.Set_Item_Value('CARRIAGE',row_.CARRIAGE, attr_out);
               --��ַ��
               row_.CUSAD_NO    :=  BILL_ADDR_NO_;
               pkg_a.Set_Item_Value('CUSAD_NO',row_.CUSAD_NO, attr_out);
               --�鸶��ַ��
               row_.CI_NO       := row_.CUSAD_NO;
               pkg_a.Set_Item_Value('CI_NO',row_.CI_NO, attr_out);
               --����������
               row_.CUSTNAME    := Nvl(Ifsapp.Cust_Ord_Customer_Address_Api.Get_Company_Name2( Customer_No_,
                                                                   Bill_Addr_No_),
                                       Ifsapp.Cust_Ord_Customer_Api.Get_Name( Customer_No_));
               pkg_a.Set_Item_Value('CUSTNAME',row_.CUSTNAME, attr_out);                        
               --�鸶�ͻ�����
               row_.CICUSTNAME   := row_.CUSTNAME;
               pkg_a.Set_Item_Value('CICUSTNAME',row_.CICUSTNAME, attr_out);
               --�����̵�ַ
               open  cur2_ for
                  select t.address1||' '||t.address2||' '||t.zip_code||' '||t.city||' '||t.state 
                   from CUSTOMER_INFO_ADDRESS_TAB t 
                   where  t.CUSTOMER_ID =  customer_no_
                     and  t.ADDRESS_ID  = BILL_ADDR_NO_;
                  fetch  cur2_ into row_.CUSTADDRESS;
                  close cur2_;
               pkg_a.Set_Item_Value('CUSTADDRESS',row_.CUSTADDRESS, attr_out);   
                --�鸶��ַ
                row_.CICUSTADDRESS :=row_.CUSTADDRESS;
                pkg_a.Set_Item_Value('CICUSTADDRESS',row_.CICUSTADDRESS, attr_out);
                --��ϵ��  
                open cur2_ for 
                select t.NAME
                from   customer_info_comm_method_tab t 
               where  t.CUSTOMER_ID  =  customer_no_
               and    t.ADDRESS_ID  = BILL_ADDR_NO_
                and   t.METHOD_ID in('E_MAIL','FAX','PHONE');
                fetch cur2_ into  row_.CUST1CONTACT ;
                close  cur2_;
                pkg_a.Set_Item_Value('CUST1CONTACT',row_.CUST1CONTACT, attr_out);
                --�鸶��ϵ��
                row_.TRACKING_NO :=row_.CUST1CONTACT;
                pkg_a.Set_Item_Value('TRACKING_NO',row_.TRACKING_NO, attr_out);
                --�绰�����ʼ�
                open cur2_ for 
                select t.METHOD_ID,t.VALUE
                from   customer_info_comm_method_tab t 
               where  t.CUSTOMER_ID  =  customer_no_
               and    t.ADDRESS_ID  = BILL_ADDR_NO_
                and   t.METHOD_ID in('E_MAIL','FAX','PHONE')
                and   t.name = row_.CUST1CONTACT;
                fetch cur2_ into METHOD_ID_,VALUE_ ;
                while cur2_%found  loop
                  if METHOD_ID_='E_MAIL' then 
                    --����email
                     row_.CUSTEMAIL := VALUE_;
                     --�鸶���ʼ�
                     row_.CIEMAIL :=row_.CUSTEMAIL;
                     pkg_a.Set_Item_Value('CUSTEMAIL',row_.CUSTEMAIL, attr_out);
                     pkg_a.Set_Item_Value('CIEMAIL',row_.CIEMAIL, attr_out);
                  end if;
                  if METHOD_ID_='FAX' then 
                     row_.CUSTFAX := VALUE_;
                     --�鸶������
                     row_.CITFAX := row_.CUSTFAX ;
                     pkg_a.Set_Item_Value('CUSTFAX',row_.CUSTFAX, attr_out);
                     pkg_a.Set_Item_Value('CITFAX',row_.CITFAX, attr_out);
                  end if ;
                  if METHOD_ID_='PHONE' then 
                      row_.CUSTTEL := VALUE_;
                      --�鸶���绰
                      row_.CITTEL :=  row_.CUSTTEL;
                     pkg_a.Set_Item_Value('CUSTTEL',row_.CUSTTEL, attr_out);
                     pkg_a.Set_Item_Value('CITTEL',row_.CITTEL, attr_out);
                  end if ;
                  fetch cur2_ into  METHOD_ID_,VALUE_ ;
                end loop;
                close  cur2_;
                --���˸�
                row_.FROMQ := IFSAPP.SALES_MARKET_API.Get_Description( market_code_);
                pkg_a.Set_Item_Value('FROMQ',row_.FROMQ, attr_out);
                --Ŀ�ĸ�
                row_.TOMU  := IFSAPP.SALES_DISTRICT_API.Get_Description(district_code_);
                pkg_a.Set_Item_Value('TOMU',row_.TOMU, attr_out);
                --�ɽ���ʽ
                row_.DELIVERY_DESC  :=Delivery_Terms_;
                open cur2_ for 
                select  flag 
                 from bl_trade 
                where STATE='1' 
                and trade_code=delivery_terms_
                and contract= contract_;
                fetch cur2_ into gk_flag_ ;
                close cur2_;
                if gk_flag_ = '0' then 
                   row_.DELIVERY_DESC := row_.DELIVERY_DESC||' '||row_.FROMQ;
                end if ;
                if gk_flag_ = '1'  then 
                   row_.DELIVERY_DESC := row_.DELIVERY_DESC||' '||row_.TOMU;
                end if;
                pkg_a.Set_Item_Value('DELIVERY_DESC',row_.DELIVERY_DESC, attr_out);
                --��������
                row_.REFER          := cust_ref_; 
                pkg_a.Set_Item_Value('REFER',row_.REFER, attr_out); 
                --֧������
                row_.PAY_TERM_ID :=  PAY_TERM_ID_ ;
                pkg_a.Set_Item_Value('PAY_TERM_ID',row_.PAY_TERM_ID, attr_out); 
                --֧����������
                row_.PAYMENT := Ifsapp.Payment_Term_Api.Get_Description(Ifsapp.Site_Api.Get_Company(Contract_),
                                                Pay_Term_Id_); 
                pkg_a.Set_Item_Value('PAYMENT',row_.PAYMENT, attr_out); 
               --�������
                if COMPANY_='20' then 
                   row_.BANK_NO :='1';
                end if;
                if COMPANY_='10' then 
                   row_.BANK_NO :='3';
                end if;
                pkg_a.Set_Item_Value('BANK_NO',row_.BANK_NO, attr_out);
               open cur2_ for
               select t.* from BL_PICIBANK_TAB t
               where t.BANK_NO = row_.BANK_NO
               and   t.CURRENCY= row_.HB;
               fetch cur2_ into row1_;
               if cur2_%found then 
                 --���л�����Ϣ
                  row_.BANK_INFO :=row1_.bank_info||CHR(10)||ROW1_.BANK_COST;
                  pkg_a.Set_Item_Value('BANK_INFO',row_.BANK_INFO, attr_out);
               end if;
               close cur2_;
               --�����̺�
               if row_.COMADDR_NO is null then 
                  row_.COMADDR_NO := COMPANY_;
               end if ;
               pkg_a.Set_Item_Value('COMADDR_NO',row_.COMADDR_NO, attr_out);
               --����������,��ַ
                open cur2_ for 
                select t.EAN_LOCATION,
                t.address1||' '||t.address2||' '||t.zip_code||' '||t.city||' '||t.state 
                from company_address_tab t
                where t.ADDRESS_ID='EN'
                and   t.COMPANY   = row_.COMADDR_NO;
                fetch cur2_ into row_.COMNAME,row_.ADDRESS;
                close cur2_;
                pkg_a.Set_Item_Value('COMNAME',row_.COMNAME, attr_out);
                pkg_a.Set_Item_Value('ADDRESS',row_.ADDRESS, attr_out);
                --�����̴��� �绰
                open cur2_ for 
                select t.METHOD_ID,t.VALUE
                from COMPANY_COMM_METHOD_TAB t 
                where t.COMPANY= row_.COMADDR_NO
                  and METHOD_ID in('FAX','PHONE');
                 fetch cur2_  into METHOD_ID_,VALUE_ ;
                while cur2_%found loop
                  if METHOD_ID_='FAX' then
                     row_.TEL := VALUE_;
                     pkg_a.Set_Item_Value('TEL',row_.TEL, attr_out);
                  end if;
                  if METHOD_ID_='PHONE' then
                     row_.FAX := VALUE_; 
                     pkg_a.Set_Item_Value('FAX',row_.FAX, attr_out);
                  end if;
                  fetch cur2_  into METHOD_ID_,VALUE_ ;
                end loop;
                close cur2_;
               --�ջ���ַ
                 row_.ETD := Ship_Addr_No_;
                 pkg_a.Set_Item_Value('ETD',row_.ETD, attr_out);
               --�ջ��˵�ַ����  
                 row_.CUSTNAME2 :=  Nvl(Ifsapp.Cust_Ord_Customer_Address_Api.Get_Company_Name2(Customer_No_,
                                                                  Ship_Addr_No_),
                                     Ifsapp.Cust_Ord_Customer_Api.Get_Name(Customer_No_));
                 pkg_a.Set_Item_Value('CUSTNAME2',row_.CUSTNAME2, attr_out);
               --�ջ��˵�ַ
                open  cur2_ for
                  select t.address1||' '||t.address2||' '||t.zip_code||' '||t.city||' '||t.state 
                   from CUSTOMER_ORDER_ADDRESS t 
                   where  t.order_no = order_no_
                     and  t.customer_no =customer_no_
                     and  t.Ship_Addr_No  = Ship_Addr_No_;
                  fetch  cur2_ into row_.DELIVERADDRESS;
                  close cur2_;
                  pkg_a.Set_Item_Value('DELIVERADDRESS',row_.DELIVERADDRESS, attr_out);
                  if row_.ETA = row_.CUSAD_NO  then 
                    --�ջ����ʼ�
                       row_.CUS2TEMAIL := row_.CUSTEMAIL;
                    ----�ջ��˵绰   
                       row_.CUS2TTEL   := row_.CUSTTEL;
                    ----�ջ��˴���   
                       row_.CUS2TFAX   := row_.CUSTFAX;
                     --�ջ�����ϵ��  
                       row_.CUST2CONTACT :=row_.CUST1CONTACT;    
                  else
                       open cur2_ for 
                        select t.NAME
                        from   customer_info_comm_method_tab t 
                       where  t.CUSTOMER_ID  = customer_no_
                       and    t.ADDRESS_ID  =Ship_Addr_No_
                        and   t.METHOD_ID in('E_MAIL','FAX','PHONE');
                        fetch cur2_ into  row_.CUST2CONTACT ;
                        close  cur2_;
                        --�ջ��˵绰�����ʼ�
                        open cur2_ for 
                        select t.METHOD_ID,t.VALUE
                        from   customer_info_comm_method_tab t 
                       where  t.CUSTOMER_ID  = customer_no_
                       and    t.ADDRESS_ID  =Ship_Addr_No_
                        and   t.METHOD_ID in('E_MAIL','FAX','PHONE')
                        and   t.name = row_.CUST2CONTACT;
                        fetch cur2_ into METHOD_ID_,VALUE_ ;
                        while cur2_%found  loop
                          if METHOD_ID_='E_MAIL' then 
                            --�ջ���email
                             row_.CUS2TEMAIL := VALUE_;
                          end if;
                          if METHOD_ID_='FAX' then 
                            --�ջ��˴���
                             row_.CUS2TFAX := VALUE_;
                          end if ;
                          if METHOD_ID_='PHONE' then 
                             --�ջ��˵绰
                             row_.CUS2TTEL  := VALUE_;
                          end if ;
                          fetch cur2_ into  METHOD_ID_,VALUE_;
                        end loop;
                        close  cur2_; 
                  end if; 
                 pkg_a.Set_Item_Value('CUS2TEMAIL',row_.CUS2TEMAIL, attr_out);
                 pkg_a.Set_Item_Value('CUS2TTEL',row_.CUS2TTEL, attr_out);
                 pkg_a.Set_Item_Value('CUS2TFAX',row_.CUS2TFAX, attr_out);
                 pkg_a.Set_Item_Value('CUST2CONTACT',row_.CUST2CONTACT, attr_out); 
           
          end if ;
          close cur1_;
       end if ;
       close cur_;
    end if;

    -- pkg_a.Set_Item_Value('��COLUMN��','��VALUE��', attr_out);
    pkg_a.Setresult(A311_Key_, attr_out);
  END;

  /*  �������� Modify__
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
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
     row_      BL_V_BL_PICIHEAD%rowtype;
     row0_     bl_picihead%rowtype;
    BEGIN  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    INSERT INTO AF(COL,COL01)
    SELECT  'FJP', Rowlist_ FROM DUAL;
    COMMIT;
   -- raise_application_error(Pkg_a.Raise_Error, Objid_);
    --����
    IF Doaction_ ='I'THEN
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      
      --�޸�����
      row0_.ALTERDATE  := sysdate;
      --ci/pi��־
      row0_.INVOICETYPE  := 'CI';
      row0_.customer_ref := Pkg_a.Get_Item_Value('CUSTOMER_REF', Rowlist_);
      --�鸶��ϵ��
      row0_.TRACKING_NO  := Pkg_a.Get_Item_Value('TRACKING_NO', Rowlist_);
      --�������
      row0_.BANK_NO  := Pkg_a.Get_Item_Value('BANK_NO', Rowlist_);
      --���л�����Ϣ
      row0_.BANK_INFO  := Pkg_a.Get_Item_Value('BANK_INFO', Rowlist_);
      --���ۼ���
      row0_.IFPART_NO  := Pkg_a.Get_Item_Value('IFPART_NO', Rowlist_);
      --ԭ����
      row0_.ORIGIN  := Pkg_a.Get_Item_Value('ORIGIN', Rowlist_);
      --ԭ��������
      row0_.ORIGIN_DESC  := Pkg_a.Get_Item_Value('ORIGIN_DESC', Rowlist_);
      --������ַ
      row0_.SHOP_ADD  := Pkg_a.Get_Item_Value('SHOP_ADD', Rowlist_);
      --������ַ
      row0_.SHOP_ADD_DESC  := Pkg_a.Get_Item_Value('SHOP_ADD_DESC', Rowlist_);
      --��������
      row0_.INVOICE_NO  := Pkg_a.Get_Item_Value('INVOICE_NO', Rowlist_);
      --����������
      row0_.COMNAME  := Pkg_a.Get_Item_Value('COMNAME', Rowlist_);
      --�����̵�ַ
      row0_.ADDRESS  := Pkg_a.Get_Item_Value('ADDRESS', Rowlist_);
      --�����̵绰
      row0_.TEL  := Pkg_a.Get_Item_Value('TEL', Rowlist_);
      --�����̴���
      row0_.FAX  := Pkg_a.Get_Item_Value('FAX', Rowlist_);
      --��Ʊ����
      row0_.SHANGDATE  := Pkg_a.Get_Item_Value('SHANGDATE', Rowlist_);
      --Ŀ�ĸ�
      row0_.TOMU  := Pkg_a.Get_Item_Value('TOMU', Rowlist_);
      --��ͷ
      row0_.MARKS  := Pkg_a.Get_Item_Value('MARKS', Rowlist_);
      --��λ(�帶)
      row0_.ETD  := Pkg_a.Get_Item_Value('ETD', Rowlist_);
      --�ջ��˵�ַ��
      row0_.ETA  := Pkg_a.Get_Item_Value('ETA', Rowlist_);
      --��������
      row0_.REFER  := Pkg_a.Get_Item_Value('REFER', Rowlist_);
      --��ע
      row0_.REMARK  := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      --���䷽ʽ
      row0_.SHIPBY  := Pkg_a.Get_Item_Value('SHIPBY', Rowlist_);
      --֧����������
      row0_.PAYMENT  := Pkg_a.Get_Item_Value('PAYMENT', Rowlist_);
      --���˸�
      row0_.FROMQ  := Pkg_a.Get_Item_Value('FROMQ', Rowlist_);
      --����
      row0_.HB  := Pkg_a.Get_Item_Value('HB', Rowlist_);
      --�ɽ���ʽ
      row0_.DELIVERY_DESC  := Pkg_a.Get_Item_Value('DELIVERY_DESC', Rowlist_);
      --����������
      row0_.CUSTNAME  := Pkg_a.Get_Item_Value('CUSTNAME', Rowlist_);
      --�����̵�ַ
      row0_.CUSTADDRESS  := Pkg_a.Get_Item_Value('CUSTADDRESS', Rowlist_);
      --��ͷ
      row0_.MARKS1  := Pkg_a.Get_Item_Value('MARKS1', Rowlist_);
      --��ͷ
      row0_.MARKS2  := Pkg_a.Get_Item_Value('MARKS2', Rowlist_);
      --��ͷ
      row0_.MARKS3  := Pkg_a.Get_Item_Value('MARKS3', Rowlist_);
      --��ͷ
      row0_.MARKS4  := Pkg_a.Get_Item_Value('MARKS4', Rowlist_);
      --���б�־
      row0_.BANK  := Pkg_a.Get_Item_Value('BANK', Rowlist_);
      --ľ�ʰ�װ
      row0_.WOOD  := Pkg_a.Get_Item_Value('WOOD', Rowlist_);
      --ó�׷�ʽ
      row0_.TRADE  := Pkg_a.Get_Item_Value('TRADE', Rowlist_);
      --�������ͻ�����
      row0_.STRCONG  := Pkg_a.Get_Item_Value('STRCONG', Rowlist_);
      --������˰��
      row0_.VATNO  := Pkg_a.Get_Item_Value('VATNO', Rowlist_);
      --���̻�������,Ӣ��
      row0_.WEIGHTPALLET  := Pkg_a.Get_Item_Value('WEIGHTPALLET', Rowlist_);
      --���ӻ�������,Ӣ��
      row0_.HOWPALLET  := Pkg_a.Get_Item_Value('HOWPALLET', Rowlist_);
      --Ӣ�ķ��루���������
      row0_.ENGRENDER  := Pkg_a.Get_Item_Value('ENGRENDER', Rowlist_);
      --�ջ��˵�ַ
      row0_.DELIVERADDRESS  := Pkg_a.Get_Item_Value('DELIVERADDRESS', Rowlist_);
      --�ͻ�����
      row0_.PURCHASE_NO  := Pkg_a.Get_Item_Value('PURCHASE_NO', Rowlist_);
      --�����ֿ�
      row0_.WAREHOUSE  := Pkg_a.Get_Item_Value('WAREHOUSE', Rowlist_);
      --��������
      row0_.CREATEDATE  := SYSDATE;
      --�ջ�������
      row0_.CUSTNAME2  := Pkg_a.Get_Item_Value('CUSTNAME2', Rowlist_);
      --��Ʊ����(990011)
      row0_.INVOICE_DATE  := Pkg_a.Get_Item_Value('INVOICE_DATE', Rowlist_);
      --�ֿ�
      row0_.SHOWWAREHOUSE  := Pkg_a.Get_Item_Value('SHOWWAREHOUSE', Rowlist_);
      --֧������
      row0_.PAY_TERM_ID  := Pkg_a.Get_Item_Value('PAY_TERM_ID', Rowlist_);
      --��������ϵ��
      row0_.CUST1CONTACT  := Pkg_a.Get_Item_Value('CUST1CONTACT', Rowlist_);
      --�ջ�����ϵ��
      row0_.CUST2CONTACT  := Pkg_a.Get_Item_Value('CUST2CONTACT', Rowlist_);
      --�����̴���
      row0_.CUSTFAX  := Pkg_a.Get_Item_Value('CUSTFAX', Rowlist_);
      --�����̺�
      row0_.COMADDR_NO  := Pkg_a.Get_Item_Value('COMADDR_NO', Rowlist_);
      --�����̵绰
      row0_.CUSTTEL  := Pkg_a.Get_Item_Value('CUSTTEL', Rowlist_);
      --�������ʼ�
      row0_.CUSTEMAIL  := Pkg_a.Get_Item_Value('CUSTEMAIL', Rowlist_);
      --��ַ��
      row0_.CUSAD_NO  := Pkg_a.Get_Item_Value('CUSAD_NO', Rowlist_);
      --�鸶���绰
      row0_.CITTEL  := Pkg_a.Get_Item_Value('CITTEL', Rowlist_);
      --�鸶������
      row0_.CITFAX  := Pkg_a.Get_Item_Value('CITFAX', Rowlist_);
      --�鸶���ʼ�
      row0_.CIEMAIL  := Pkg_a.Get_Item_Value('CIEMAIL', Rowlist_);
      --�鸶��ַ��
      row0_.CI_NO       := Pkg_a.Get_Item_Value('CI_NO', Rowlist_);
      --�鸶�ͻ�����
      row0_.CICUSTNAME  := Pkg_a.Get_Item_Value('CICUSTNAME', Rowlist_);
      --�鸶��ַ
      row0_.CICUSTADDRESS  := Pkg_a.Get_Item_Value('CICUSTADDRESS', Rowlist_);
      --�ջ��˵绰
      row0_.CUS2TTEL  := Pkg_a.Get_Item_Value('CUS2TTEL', Rowlist_);
      --�ջ��˴���
      row0_.CUS2TFAX  := Pkg_a.Get_Item_Value('CUS2TFAX', Rowlist_);
      --�ջ����ʼ�
      row0_.CUS2TEMAIL  := Pkg_a.Get_Item_Value('CUS2TEMAIL', Rowlist_);
      --Ԥ������
      ROW0_.CARRIAGE    := PKG_A.Get_Item_Value('CARRIAGE',Rowlist_);
      INSERT INTO Bl_Picihead
        (Invoice_No, Invoicetype)
        VALUES(ROW0_.INVOICE_NO,ROW0_.INVOICETYPE)
       RETURNING ROWID INTO Objid_;
       UPDATE Bl_Picihead
        SET  ROW = row0_
       WHERE ROWID = Objid_;
       pkg_a.Setsuccess(A311_Key_,'BL_V_BL_PICIHEAD', Objid_);
      RETURN;
    END IF;
    --�޸�
    IF Doaction_ ='M'THEN
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
       Open Cur_ For
        Select t.* From BL_V_BL_PICIHEAD t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,'�����rowid��');
      
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     :='update BL_V_BL_PICIHEAD SET ';
      Ifmychange :='0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_,'|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
      
        If Column_Id_ <> 'OBJID'  And  Column_Id_ <> 'DOACTION' And
           Length(Nvl(Column_Id_,'')) > 0 Then
          Ifmychange :='1';
          v_         := Substr(v_, Pos1_ + 1);
          Mysql_     := Mysql_ || Column_Id_ || '='''|| v_ ||''',';
        End If;

   End Loop;

  --�û��Զ�����
  If Ifmychange ='1' Then 
     Mysql_ := Mysql_ || ' ALTERDATE = Sysdate '; 
     Mysql_ := Mysql_ || ' Where Rowid ='''|| Row_.Objid ||'''';
  -- raise_application_error(Pkg_a.Raise_Error, mysql_);
     Execute Immediate Mysql_;
  End If;

  Pkg_a.Setsuccess(A311_Key_,'BL_V_BL_PICIHEAD', Row_.Objid); 
  Return;
End If;
--ɾ��
If Doaction_ ='D'Then
   /*OPEN CUR_ FOR
        SELECT T.* FROM BL_V_BL_PICIHEAD T WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'�����rowid');
        return;
      end if;
      close cur_;
--      DELETE FROM BL_V_BL_PICIHEAD T WHERE T.ROWID = OBJID_; */
--pkg_a.Setsuccess(A311_Key_,'BL_V_BL_PICIHEAD', Objid_);
Return;
End If;

End;
/*  �з����仯��ʱ��
      Column_Id_   ��ǰ�޸ĵ���
      Mainrowlist_ ���������� ��ϸ��ֵ������Ϊ��
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      Outrowlist_  ���������   
  */
Procedure Itemchange__(Column_Id_ Varchar2, Mainrowlist_ Varchar2, Rowlist_ Varchar2, User_Id_ Varchar2, Outrowlist_ Out Varchar2) Is
Attr_Out Varchar2(4000);
 cur_ t_Cursor;
 row_ bl_v_bl_picihead%rowtype;
 row1_ BL_PICIBANK_TAB%rowtype;
 row0_ BL_V_customer_info_address_tab%rowtype;
 ADDRESS_ID_ VARCHAR2(50);
 link_name_ varchar2(100);
 METHOD_ID_ varchar2(20);--��ϵ������
 VALUE_     varchar2(200);--��ϵ��ֵ
 bflag_     varchar2(1);
 contract_  varchar2(20);
 gk_flag_   varchar2(1);
Begin
  --��ַ��
If Column_Id_ ='CUSAD_NO'  OR Column_Id_='CI_NO' OR Column_Id_='ETD'  Then
    row_.CUSTOMER_REF := pkg_a.Get_Item_Value('CUSTOMER_REF',Rowlist_);
    if Column_Id_ ='CUSAD_NO' then 
      ADDRESS_ID_  := pkg_a.Get_Item_Value('CUSAD_NO',Rowlist_);
      PKG_A.SET_ITEM_VALUE('CUSAD_NO', ADDRESS_ID_, ATTR_OUT);
    end if;
    if  Column_Id_='CI_NO' then 
       ADDRESS_ID_  := pkg_a.Get_Item_Value('CI_NO',Rowlist_);
       PKG_A.SET_ITEM_VALUE('CI_NO', ADDRESS_ID_, ATTR_OUT);
    end if;
    if   Column_Id_='ETD' then 
       ADDRESS_ID_  := pkg_a.Get_Item_Value('ETD',Rowlist_);
       PKG_A.SET_ITEM_VALUE('ETD', ADDRESS_ID_, ATTR_OUT);
    end if;
    open cur_  for 
    select t.*
    from BL_V_customer_info_address_tab t 
    where t.customer_id = row_.CUSTOMER_REF
     and  t.address_id   = ADDRESS_ID_;
     fetch cur_ into row0_;
     if cur_%notfound then 
         close cur_;
         RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'�����rowid');
     end if;
     close cur_;
     if Column_Id_ ='CUSAD_NO' then 
        row_.CUSTNAME    := row0_.address_NAME;
        row_.CUSTADDRESS :=row0_.address_ADD;
        PKG_A.SET_ITEM_VALUE('CUSTNAME', row_.CUSTNAME, ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('CUSTADDRESS', row_.CUSTADDRESS, ATTR_OUT);
     end if ;
     if  Column_Id_='CI_NO' then 
        row_.CICUSTNAME := row0_.address_NAME;
        row_.CICUSTADDRESS :=row0_.address_ADD;
        PKG_A.SET_ITEM_VALUE('CICUSTNAME',  row_.CICUSTNAME, ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('CICUSTADDRESS', row_.CICUSTADDRESS, ATTR_OUT);
     end if ;
     if   Column_Id_='ETD' then 
        row_.CUSTNAME2 := row0_.address_NAME;
        row_.DELIVERADDRESS :=row0_.address_ADD;
        PKG_A.SET_ITEM_VALUE('CUSTNAME2',  row_.CUSTNAME2, ATTR_OUT);
        PKG_A.SET_ITEM_VALUE('DELIVERADDRESS', row_.DELIVERADDRESS, ATTR_OUT);
     end if;
     --��ϵ��  
      open cur_ for 
      select t.NAME
      from   customer_info_comm_method_tab t 
     where  t.CUSTOMER_ID  =  row_.CUSTOMER_REF
     and    t.ADDRESS_ID  =   ADDRESS_ID_
      and   t.METHOD_ID in('E_MAIL','FAX','PHONE');
      fetch cur_ into  link_name_ ;
      close  cur_;
      if  Column_Id_ ='CUSAD_NO' then 
        row_.CUST1CONTACT :=link_name_;
        pkg_a.Set_Item_Value('CUST1CONTACT',row_.CUST1CONTACT, attr_out);
      end if ;
      if Column_Id_='CI_NO'  then 
        row_.TRACKING_NO :=link_name_;
        pkg_a.Set_Item_Value('TRACKING_NO',row_.TRACKING_NO, attr_out);
      end if ;
      if   Column_Id_='ETD' then 
        row_.CUST2CONTACT :=link_name_;
        pkg_a.Set_Item_Value('CUST2CONTACT',row_.CUST2CONTACT, attr_out);
      end if;
      --�绰�����ʼ�
      open cur_ for 
      select t.METHOD_ID,t.VALUE
      from   customer_info_comm_method_tab t 
     where  t.CUSTOMER_ID  = row_.CUSTOMER_REF
     and    t.ADDRESS_ID  = ADDRESS_ID_
      and   t.METHOD_ID in('E_MAIL','FAX','PHONE')
      and   t.name = link_name_;
      fetch cur_ into METHOD_ID_,VALUE_ ;
      while cur_%found  loop
        if METHOD_ID_='E_MAIL' then 
            if  Column_Id_ ='CUSAD_NO' then 
              row_.CUSTEMAIL :=VALUE_;
            end if ;
            if Column_Id_='CI_NO'  then 
              row_.CIEMAIL :=VALUE_;
            end if ;
            if   Column_Id_='ETD' then 
              row_.CUS2TEMAIL :=VALUE_;
            end if;
        end if;
        if METHOD_ID_='FAX' then 
            if  Column_Id_ ='CUSAD_NO' then 
              row_.CUSTFAX :=VALUE_;
            end if ;
            if Column_Id_='CI_NO'  then 
              row_.CITFAX :=VALUE_;
            end if ;
            if   Column_Id_='ETD' then 
              row_.CUS2TFAX :=VALUE_;
            end if;
        end if ;
        if METHOD_ID_='PHONE' then 
            if  Column_Id_ ='CUSAD_NO' then 
              row_.CUSTTEL :=VALUE_;
            end if ;
            if Column_Id_='CI_NO'  then 
              row_.CITTEL :=VALUE_;
            end if ;
            if   Column_Id_='ETD' then 
              row_.CUS2TTEL :=VALUE_;
            end if;
        end if ;
        fetch cur_ into  METHOD_ID_,VALUE_ ;
      end loop;
      close  cur_;
      if  Column_Id_ ='CUSAD_NO' then 
        pkg_a.Set_Item_Value('CUSTEMAIL',row_.CUSTEMAIL, attr_out);
        pkg_a.Set_Item_Value('CUSTFAX',row_.CUSTFAX, attr_out);
        pkg_a.Set_Item_Value('CUSTTEL',row_.CUSTTEL, attr_out);
        
      end if ;
      if Column_Id_='CI_NO'  then 
        pkg_a.Set_Item_Value('CIEMAIL',row_.CIEMAIL, attr_out);
        pkg_a.Set_Item_Value('CITFAX',row_.CITFAX, attr_out);
        pkg_a.Set_Item_Value('CITTEL',row_.CITTEL, attr_out);
      end if ;
      if   Column_Id_='ETD' then 
        pkg_a.Set_Item_Value('CUS2TEMAIL',row_.CUS2TEMAIL, attr_out);
        pkg_a.Set_Item_Value('CUS2TFAX',row_.CUS2TFAX, attr_out);
        pkg_a.Set_Item_Value('CUS2TTEL',row_.CUS2TTEL, attr_out);
      end if;
End If;
--��ϵ��
if Column_Id_ ='CUST1CONTACT'  OR Column_Id_='CUST2CONTACT' OR Column_Id_='TRACKING_NO' then 
  row_.CUSTOMER_REF := pkg_a.Get_Item_Value('CUSTOMER_REF',Rowlist_);
   if Column_Id_ ='CUST1CONTACT'  then --��������ϵ��
     ADDRESS_ID_ := pkg_a.Get_Item_Value('CUSAD_NO',Rowlist_);
     link_name_ := pkg_a.Get_Item_Value('CUST1CONTACT',Rowlist_);
   end if ;
   if Column_Id_='CUST2CONTACT' then  --�ջ�����ϵ��
     ADDRESS_ID_ := pkg_a.Get_Item_Value('ETD',Rowlist_);
     link_name_ := pkg_a.Get_Item_Value('CUST2CONTACT',Rowlist_);
   end if ;
   if Column_Id_='TRACKING_NO' then  --�鸶��ϵ��
     ADDRESS_ID_ := pkg_a.Get_Item_Value('CI_NO',Rowlist_);
     link_name_ := pkg_a.Get_Item_Value('TRACKING_NO',Rowlist_);
   end if ;
         --�绰�����ʼ�
      open cur_ for 
      select t.METHOD_ID,t.VALUE
      from   customer_info_comm_method_tab t 
     where  t.CUSTOMER_ID  = row_.CUSTOMER_REF
     and    t.ADDRESS_ID  = ADDRESS_ID_
      and   t.METHOD_ID in('E_MAIL','FAX','PHONE')
      and   t.name = link_name_;
      fetch cur_ into METHOD_ID_,VALUE_ ;
      while cur_%found  loop
        if METHOD_ID_='E_MAIL' then 
            if  Column_Id_ ='CUST1CONTACT' then 
              row_.CUSTEMAIL :=VALUE_;
            end if ;
            if Column_Id_='TRACKING_NO'  then 
              row_.CIEMAIL :=VALUE_;
            end if ;
            if   Column_Id_='CUST2CONTACT' then 
              row_.CUS2TEMAIL :=VALUE_;
            end if;
        end if;
        if METHOD_ID_='FAX' then 
            if  Column_Id_ ='CUST1CONTACT' then 
              row_.CUSTFAX :=VALUE_; 
            end if ;
            if Column_Id_='TRACKING_NO'  then 
              row_.CITFAX :=VALUE_;
            end if ;
            if   Column_Id_='CUST2CONTACT' then 
              row_.CUS2TFAX :=VALUE_;
            end if;
        end if ;
        if METHOD_ID_='PHONE' then 
            if  Column_Id_ ='CUST1CONTACT' then 
              row_.CUSTTEL :=VALUE_;
            end if ;
            if Column_Id_='TRACKING_NO'  then 
              row_.CITTEL :=VALUE_;
            end if ;
            if   Column_Id_='CUST2CONTACT' then 
              row_.CUS2TTEL :=VALUE_;
            end if;
        end if ;
        fetch cur_ into  METHOD_ID_,VALUE_ ;
      end loop;
      close  cur_;
     if Column_Id_ ='CUST1CONTACT'  then --��������ϵ��
        pkg_a.Set_Item_Value('CUSTEMAIL',row_.CUSTEMAIL, attr_out);
        pkg_a.Set_Item_Value('CUSTFAX',row_.CUSTFAX, attr_out);
        pkg_a.Set_Item_Value('CUSTTEL',row_.CUSTTEL, attr_out);
     end if ;
     if Column_Id_='CUST2CONTACT' then  --�ջ�����ϵ��
       pkg_a.Set_Item_Value('CUS2TEMAIL',row_.CUS2TEMAIL, attr_out);
       pkg_a.Set_Item_Value('CUS2TFAX',row_.CUS2TFAX, attr_out);
       pkg_a.Set_Item_Value('CUS2TTEL',row_.CUS2TTEL, attr_out);
     end if ;
     if Column_Id_='TRACKING_NO' then  --�鸶��ϵ��
       pkg_a.Set_Item_Value('CIEMAIL',row_.CIEMAIL, attr_out);
       pkg_a.Set_Item_Value('CITFAX',row_.CITFAX, attr_out);
       pkg_a.Set_Item_Value('CITTEL',row_.CITTEL, attr_out);
     end if ;
end if ;
if Column_Id_ ='BANK_NO' then 
    row_.BANK_NO := pkg_a.Get_Item_Value('BANK_NO',rowlist_);
    row_.hb      := pkg_a.Get_Item_Value('HB',rowlist_);
    open cur_ for 
    select t.*
    from BL_PICIBANK_TAB t 
    where t.bank_no = row_.BANK_NO
     and  t.currency=row_.hb;
    fetch cur_ into row1_;
    close cur_;
    pkg_a.Set_Item_Value('BANK_INFO',row1_.bank_info||CHR(10)||ROW1_.BANK_COST, attr_out);
end if ;
--���˸�  Ŀ�ĸ�
if Column_Id_ = 'FROMQ' or Column_Id_ = 'TOMU'    then
  row_.DELIVERY_DESC := pkg_a.Get_Item_Value('DELIVERY_DESC',Rowlist_); 
  row_.INVOICE_NO    := pkg_a.Get_Item_Value('INVOICE_NO',Rowlist_); 
  row_.PURCHASE_NO   := pkg_a.Get_Item_Value('PURCHASE_NO',Rowlist_);
  row_.FROMQ         := pkg_a.Get_Item_Value('FROMQ',Rowlist_);
  row_.TOMU         := pkg_a.Get_Item_Value('TOMU',Rowlist_);
  select nvl(bflag,'0') into bflag_    from bl_picklist  where picklistno = row_.INVOICE_NO;
  if bflag_ = '1' then
     select delivery_terms,contract into row_.DELIVERY_DESC,contract_ from  purchase_order  where order_no = row_.PURCHASE_NO;  
  else
    select delivery_terms,contract into row_.DELIVERY_DESC,contract_ from  customer_order  where order_no = row_.PURCHASE_NO;  
  end if ;
    open cur_ for 
  select  flag 
   from bl_trade 
  where STATE='1' 
  and trade_code = row_.DELIVERY_DESC
  and contract= contract_;
  fetch cur_ into gk_flag_ ;
  close cur_;
  if gk_flag_ = '0' and Column_Id_ = 'FROMQ' then 
     row_.DELIVERY_DESC := row_.DELIVERY_DESC||' '||row_.FROMQ;
     pkg_a.Set_Item_Value('DELIVERY_DESC',row_.DELIVERY_DESC, attr_out);
  end if ;
  if gk_flag_ = '1' and Column_Id_ = 'TOMU' then 
     row_.DELIVERY_DESC := row_.DELIVERY_DESC||' '||row_.TOMU;
     pkg_a.Set_Item_Value('DELIVERY_DESC',row_.DELIVERY_DESC, attr_out);
  end if;
end if ;
 

Outrowlist_ := Attr_Out;
End;
/*  �з����仯��ʱ��
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ������� �� ɾ���� ��ť 
      KEY_ ����������ֵ
      User_Id_  ��ǰ�û�
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

/*  ʵ��ҵ���߼������е� �༭��
      Doaction_   I M ��ϸ�϶�Ϊ M   I ���� M �޸� ҳ�������� ��ǰ�����е� �����Ե��Ժ� ����  
      Column_Id_  ��
      Rowlist_  ��ǰ�û�
      ����: 1 ����
      0 ������
  */
Function Checkuseable(Doaction_ In Varchar2, Column_Id_ In Varchar, Rowlist_ In Varchar2) Return Varchar2 Is
Begin
If Column_Id_ ='��column��'
  Then Return'0';
End If;
 Return'1';
End;

End BL_PICIHEAD_API; 
/
