CREATE OR REPLACE Package Bl_Pick_Order_Api Is
  -- 备货单头的新增赋予的默认值
  Procedure New__(Rowlist_  Varchar2, --空值
                  User_Id_  Varchar2,
                  A311_Key_ Varchar2);
  --备货单新增，修改
  Procedure Modify__(Rowlist_  Varchar2, --备货单界面更改值拼接字符串
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  Procedure Remove__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  Procedure Picinew__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --pici信息的新增，修改
  Procedure Picimodify__(Rowlist_  Varchar2, --pici界面更改值拼接字符串
                         User_Id_  Varchar2,
                         A311_Key_ Varchar2);
  --备货单下达
  Procedure Release_Stock(Rowid_    Varchar2, --备货单BL_PICKLIST的rowid值
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);
  --站点发货
  Procedure Release_Zdstock(Rowid_    Varchar2, --BL_V_BL_PICKLIST_SUP的objid值
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2);
  --备货单取消下达
  Procedure Releasecancel(Rowid_    Varchar2, --备货单BL_PICKLIST的rowid值
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);
  Procedure Finish_Stock(Rowid_    Varchar2,
                         User_Id_  Varchar2,
                         A311_Key_ Varchar2);
  Procedure Finish_Customer(Rowid_    Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2);
  Procedure Finish_Customer1(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2);
  --进口采购入库                          
  Procedure Finish_Customer2(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2);
  --备货单开发票                           
  Procedure Co_Flowinvoice(Rowid_    Varchar2, --备货单BL_PICKLIST的rowid值
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2,
                           Info_     Out Varchar2);
  --插入备货单发票号的后台表BL_PLINVDTL
  Procedure Update_Bl_Plinvdtl(Picklistno_ In Varchar2, --备货单号
                               User_Id_    In Varchar2,
                               A311_Key_   In Varchar2);
  Procedure Insert_Bl_Plinvdtl(Row_      Bl_Plinvdtl%Rowtype, --后台表BL_PLINVDTL的所有字段
                               User_Id_  In Varchar2,
                               A311_Key_ In Varchar2);
  --更新备货单后台表BL_PLINVDTL的发票号
  Procedure Update_Bl_Plinvdtl_Invoice(Picklistno_ In Varchar2, --备货单号
                                       User_Id_    In Varchar2,
                                       A311_Key_   In Varchar2);
  Procedure Unite__Stock(Rowlist_  Varchar2,
                         User_Id_  Varchar2,
                         A311_Key_ Varchar2);
  Procedure Unite__Cancel(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);
  -- 自动生成备货单
  Procedure Picklist_Auto_(Rowid_    Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2);
  --- 直接登记交货
  Procedure Registered_Delivery_(Picklistno_ In Varchar2,
                                 User_Id_    Varchar2,
                                 A311_Key_   Varchar2,
                                 Info_       Out Varchar2);
  --金额(当为完成的备货单：取发票的金额，补货备货单取报关的金额)
  Function Get_Co_Amount(Picklistno_ Varchar2, Type_ Varchar2) Return Number;
  --费用
  Function Get_Chare_Amount(Picklistno_ In Varchar2, Type_ In Varchar2)
    Return Number;
  Procedure Set_Cancel_Reason(Rowid_    Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);
  --获取编码   
  Procedure Getpicklistno(Contract_    In Varchar2,
                          Customer_No_ In Varchar2,
                          Type_        In Varchar2,
                          Seq_         Out Varchar2);
  --当数据发生变化的时候 修改列信息
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2);
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2;
  ----检查编辑 修改
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2;
  Function Get_Bprdt_Column_(Picklistno_ In Varchar2, Type_ In Varchar2)
    Return Varchar2;
  ---生成客户订单
  Procedure Set_Order__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2);
  --判断备货单是否已经存在modify fjp 2013-01-21
  Function Get_Piurl(Picklistno_ Varchar2, Type_ Varchar2) Return Varchar2;
  --获取备货单的号  作废2013-02-25 
  Function Get_New_Picklistno(Yearno_ In Varchar2, Customerno_ In Varchar2)
    Return Varchar;
End Bl_Pick_Order_Api;
/
CREATE OR REPLACE Package Body Bl_Pick_Order_Api Is
  /*  modify fjp 2012-12-07 站点下达当明细的发货单都发货完成了，更新上层的订单并开发票
  modify fjp 2012-12-11  修改备货单取得的金额，当备货单为完成状态，备货单取发票的金额，补货备货单取报关金额
  modify fjp 2012-12-12  费用订单开发票
  modify  fjp 2012-12-18 12域内部供应商入库
  modify fjp 2013-01-14发货确定关闭内销发货通知跟拼箱装车
  进口采购modify fjp 2013-01-16
  modify fjp pici 头新增的写出数据 2013-01-20
  下达之前检查是否已经做pici信息modify2013-01-31 
  modify fjp 2013-02-01 修改Finish_Customer1,Finish_Customer2传进来的参数为rowid
  modify fjp 2013-02-04 更改事物日期为入库日期
  modify wtl 2013-02-21  执行下达前要进行check 不能发货 转换接收日期
  modify fjp 2013-02-25 补货备货单跟备货单开发票是同样的处理方式
  modify fjp 2013-02-25  更改备货单的单号取数 
  */
  Type t_Cursor Is Ref Cursor;
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
    Attr_Out Varchar2(4000);
    Row_     Bl_v_Bl_Picklist%Rowtype;
    Cur_     t_Cursor;
    Row1_    Bl_Ciq_Contract_Tab%Rowtype;
  Begin
    --获取用户默认的域
    Row_.Contract := Pkg_Attr.Get_Default_Contract(User_Id_);
    Row_.Bflag    := Rowlist_;
    If (Nvl(Row_.Contract, '0') <> '0') Then
      If Row_.Bflag = '0' Then
        Pkg_a.Set_Item_Value('CONTRACT', Row_.Contract, Attr_Out);
      Else
        Pkg_a.Set_Item_Value('PCONTRACT', Row_.Contract, Attr_Out);
        Pkg_a.Set_Item_Value('CUSTOMERNO', Row_.Contract, Attr_Out);
      End If;
    End If;
    Open Cur_ For
      Select t.*
        From Bl_Ciq_Contract_Tab t
       Where t.Contract = Row_.Contract;
    Fetch Cur_
      Into Row1_;
    If Cur_%Found Then
      Row_.Ifciq     := Row1_.Ifciq;
      Row_.Ship_Type := Row1_.Shipetype;
      Pkg_a.Set_Item_Value('IFCIQ', Row_.Ifciq, Attr_Out);
      Pkg_a.Set_Item_Value('SHIP_TYPE', Row_.Ship_Type, Attr_Out);
      If Row_.Bflag = '0' Then
        Row_.Location := Row1_.Outlaction;
      Else
        Row_.Location := Row1_.Inlaction;
      End If;
      Pkg_a.Set_Item_Value('LOCATION', Row_.Location, Attr_Out);
      Row_.Warehouse := Ifsapp.Inventory_Location_Api.Get_Warehouse(Row_.Contract,
                                                                    Row_.Location);
      Pkg_a.Set_Item_Value('WAREHOUSE', Row_.Warehouse, Attr_Out);
    End If;
    Close Cur_;
    Pkg_a.Setresult(A311_Key_, Attr_Out);
    Return;
  End;

  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Index_     Varchar2(1);
    Doaction_  Varchar2(1);
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar2(4000);
    Ifmychange Varchar2(1);
    Objid_     Varchar2(100);
    Row_       Bl_v_Bl_Picklist%Rowtype;
    Cur_       t_Cursor;
    Row0_      Bl_v_Bl_Picihead_V01%Rowtype;
    Row1_      Bl_Picihead%Rowtype;
  Begin
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    If Doaction_ = 'I' Then
      --  获取值
      Row_.Contract   := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Row_.Customerno := Pkg_a.Get_Item_Value('CUSTOMERNO', Rowlist_);
      -- 获取备货单号
      Getpicklistno(Row_.Contract, Row_.Customerno, 'P', Row_.Picklistno);
      --Row_.Picklistno := Get_New_Picklistno(To_Char(Sysdate, 'yy'), Row_.Customerno);
      Row_.Bflag := Pkg_a.Get_Item_Value('BFLAG', Rowlist_);
      --row_.PICKLISTNO:=pkg_a.Get_Item_Value('PICKLISTNO',ROWLIST_ );
      Row_.Deldate    := Pkg_a.Get_Item_Value('DELDATE', Rowlist_);
      Row_.Finishdate := Pkg_a.Get_Item_Value('FINISHDATE', Rowlist_);
      Row_.Flag       := Pkg_a.Get_Item_Value('FLAG', Rowlist_);
      Row_.Remark     := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      Row_.Userid     := User_Id_;
      Row_.Info       := Pkg_a.Get_Item_Value('INFO', Rowlist_);
      Row_.Isprint    := Pkg_a.Get_Item_Value('ISPRINT', Rowlist_);
      -- 创建给一个默认值
      Row_.Createdate  := To_Char(Sysdate, 'yyyy-mm-dd'); --pkg_a.Get_Item_Value('CREATEDATE',ROWLIST_ );
      Row_.Releasedate := Pkg_a.Get_Item_Value('RELEASEDATE', Rowlist_);
      Row_.Shipdate    := Pkg_a.Get_Item_Value('SHIPDATE', Rowlist_);
      Row_.Feeorderno  := Pkg_a.Get_Item_Value('FEEORDERNO', Rowlist_);
      Row_.Ship_Type   := Pkg_a.Get_Item_Value('SHIP_TYPE', Rowlist_);
      If Length(Row_.Customerno) > 2 Then
        Row_.Customer_Ref := Row_.Customerno; --pkg_a.Get_Item_Value('LABEL_NOTE',ROWLIST_);
      Else
        Row_.Customer_Ref := Pkg_a.Get_Item_Value('CUSTOMER_REF', Rowlist_);
      End If;
      -- row_.CUSTOMER_REF:=pkg_a.Get_Item_Value('CUSTOMER_REF',ROWLIST_ );
      Row_.Location      := Pkg_a.Get_Item_Value('LOCATION', Rowlist_);
      Row_.Issure        := Pkg_a.Get_Item_Value('ISSURE', Rowlist_);
      Row_.Ifciq         := Pkg_a.Get_Item_Value('IFCIQ', Rowlist_);
      Row_.Ifnew         := Pkg_a.Get_Item_Value('IFNEW', Rowlist_);
      Row_.Date_Sure     := To_Date(Pkg_a.Get_Item_Value('DATE_SURE',
                                                         Rowlist_),
                                    'yyyy-mm-dd');
      Row_.Sure_Shipdate := To_Date(Pkg_a.Get_Item_Value('SURE_SHIPDATE',
                                                         Rowlist_),
                                    'yyyy-mm-dd');
      Row_.Recalcu_State := Pkg_a.Get_Item_Value('RECALCU_STATE', Rowlist_);
      Row_.Recalcu_Date  := To_Date(Pkg_a.Get_Item_Value('RECALCU_DATE',
                                                         Rowlist_),
                                    'yyyy-mm-dd');
      Row_.Posting_State := Pkg_a.Get_Item_Value('POSTING_STATE', Rowlist_);
      Row_.Pickno        := Pkg_a.Get_Item_Value('PICKNO', Rowlist_);
      Row_.Recived_Date  := Pkg_a.Get_Item_Value('RECIVED_DATE', Rowlist_);
      Row_.Lot_Batch_No  := Pkg_a.Get_Item_Value('LOT_BATCH_NO', Rowlist_);
      --插入数据
      Insert Into Bl_Picklist
        (Contract,
         Customerno,
         Picklistno,
         Deldate,
         Finishdate,
         Flag,
         Remark,
         Userid,
         Info,
         Isprint,
         Createdate,
         Releasedate,
         Shipdate,
         Feeorderno,
         Customer_Ref,
         Location,
         Issure,
         Ifciq,
         Ifnew,
         Date_Sure,
         Sure_Shipdate,
         Recalcu_State,
         Recalcu_Date,
         Posting_State,
         Bflag,
         Ship_Type,
         Pickno,
         Recived_Date,
         Lot_Batch_No,
         Pickuniteno)
      Values
        (Row_.Contract,
         Row_.Customerno,
         Row_.Picklistno,
         Row_.Deldate,
         Row_.Finishdate,
         Row_.Flag,
         Row_.Remark,
         Row_.Userid,
         Row_.Info,
         Row_.Isprint,
         Row_.Createdate,
         Row_.Releasedate,
         Row_.Shipdate,
         Row_.Feeorderno,
         Row_.Customer_Ref,
         Row_.Location,
         Row_.Issure,
         Row_.Ifciq,
         Row_.Ifnew,
         Row_.Date_Sure,
         Row_.Sure_Shipdate,
         Row_.Recalcu_State,
         Row_.Recalcu_Date,
         Row_.Posting_State,
         Row_.Bflag,
         Row_.Ship_Type,
         Row_.Pickno,
         Row_.Recived_Date,
         Row_.Lot_Batch_No,
         Row_.Picklistno)
      Returning Rowid Into Objid_;
      /*          FROM Dual;
      SELECT t.Rowid
        INTO Objid_
        FROM Bl_Picklist t
       WHERE t.Picklistno = Row_.Picklistno;*/
      -- 插入pi信息
      /*     INSERT INTO Bl_Picihead
      (Invoice_No, Invoicetype,,WOOD,IFPART_NO,ORIGIN,ORIGIN_DESC)
      SELECT Row_.Picklistno, ,'CI','0','1','0','COUNTRY OF ORIGIN: CHINA' FROM Dual;*/
      --modify  fjp 2013-01-20
      /*  OPEN Cur_ FOR
        SELECT t.*
          FROM Bl_v_Bl_Picihead_V01 t
         WHERE t.Invoice_No = Row_.Picklistno
           AND t.Alterdate IS NOT NULL
         ORDER BY t.Alterdate DESC;
      FETCH Cur_
        INTO Row0_;
      IF Cur_%FOUND THEN
        Row1_.Invoice_No     := Row_.Picklistno;
        Row1_.Invoicetype    := 'PI';
        Row1_.Comname        := Row0_.Comname;
        Row1_.Address        := Row0_.Address;
        Row1_.Tel            := Row0_.Tel;
        Row1_.Fax            := Row0_.Fax;
        Row1_.Shangdate      := Row0_.Shangdate;
        Row1_.Tomu           := Row0_.Tomu;
        Row1_.Marks          := Row0_.Marks;
        Row1_.Etd            := Row0_.Etd;
        Row1_.Eta            := Row0_.Eta;
        Row1_.Refer          := Row0_.Refer;
        Row1_.Remark         := Row0_.Remark;
        Row1_.Shipby         := Row0_.Shipby;
        Row1_.Payment        := Row0_.Payment;
        Row1_.Fromq          := Row0_.Fromq;
        Row1_.Hb             := Row0_.Hb;
        Row1_.Delivery_Desc  := Row0_.Delivery_Desc;
        Row1_.Custname       := Row0_.Custname;
        Row1_.Custaddress    := Row0_.Custaddress;
        Row1_.Marks1         := Row0_.Marks1;
        Row1_.Marks2         := Row0_.Marks2;
        Row1_.Marks3         := Row0_.Marks3;
        Row1_.Marks4         := Row0_.Marks4;
        Row1_.Bank           := Row0_.Bank;
        Row1_.Wood           := Row0_.Wood;
        Row1_.Trade          := Row0_.Trade;
        Row1_.Strcong        := Row0_.Strcong;
        Row1_.Vatno          := Row0_.Vatno;
        Row1_.Weightpallet   := Row0_.Weightpallet;
        Row1_.Howpallet      := Row0_.Howpallet;
        Row1_.Engrender      := Row0_.Engrender;
        Row1_.Deliveraddress := Row0_.Deliveraddress;
        Row1_.Purchase_No    := Row0_.Purchase_No;
        Row1_.Warehouse      := Row0_.Warehouse;
        Row1_.Createdate     := Row0_.Createdate;
        Row1_.Custname2      := Row0_.Custname2;
        Row1_.Invoice_Date   := Row0_.Invoice_Date;
        Row1_.Showwarehouse  := Row0_.Showwarehouse;
        Row1_.Inviceno2      := Row0_.Inviceno2;
        Row1_.Alterdate      := SYSDATE;
        Row1_.Tracking_No    := Row0_.Tracking_No;
        Row1_.Bank_No        := Row0_.Bank_No;
        Row1_.Bank_Info      := Row0_.Bank_Info;
        Row1_.Ifpart_No      := Row0_.Ifpart_No;
        Row1_.Origin         := Row0_.Origin;
        Row1_.Origin_Desc    := Row0_.Origin_Desc;
        Row1_.Shop_Add       := Row0_.Shop_Add;
        Row1_.Shop_Add_Desc  := Row0_.Shop_Add_Desc;
        Row1_.Pay_Term_Id    := Row0_.Pay_Term_Id;
        UPDATE Bl_Picihead
           SET ROW = Row1_
         WHERE Invoice_No = Row_.Picklistno;
      END IF;
      CLOSE Cur_;*/
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PICKLIST', Objid_);
      Return;
    End If;
    If Doaction_ = 'M' Then
      -- 更改数据
      /*        open cur_
      for select t.*
      from    BL_V_BL_PICKLIST t
      where  t.OBJID =   objid_;
      fetch cur_     into row_   ;
      if cur_%notfound then       
         close cur_ ;
         raise_application_error(-20101, '错误的rowid');
         return ;
      end if ;    
      close cur_ ;  */
    
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := ' update bl_picklist set ';
      Ifmychange := '0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' And
           Length(Nvl(Column_Id_, '')) > 0 And Column_Id_ <> 'QD_DATE' Then
          v_ := Substr(v_, Pos1_ + 1);
          i  := i + 1;
          -- 工厂的交期 由站点备货来更改
          /*              if column_id_='REL_DELIVER_DATE'  then
          update  bl_pldtl
           set REL_DELIVER_DATE = v_,
                finishqty = PICKQTY
           where PICKLISTNO = row_.PICKLISTNO
            and  SUPPLIER  in (select t.contract
                                     from  bl_usecon t ,  a007 t1 
                                     where  t1.bl_userid = t.userid 
                                     and    t1.a007_id = user_id_ );*/
          --  else
          Ifmychange := '1';
          If Column_Id_ = 'DATE_SURE' Or Column_Id_ = 'SURE_SHIPDATE' Or
             Column_Id_ = 'RECALCU_DATE' Then
            Mysql_ := Mysql_ || ' ' || Column_Id_ || '=to_date(''' || v_ ||
                      ''',''YYYY-MM-DD HH24:MI:SS''),';
          Else
            Mysql_ := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
          End If;
          -- end if ;
        End If;
      End Loop;
      If Ifmychange = '1' Then
        -- 更新sql语句 
        Mysql_ := Substr(Mysql_, 1, Length(Mysql_) - 1);
        Mysql_ := Mysql_ || ' where rowidtochar(rowid)=''' || Objid_ || '''';
        Execute Immediate Mysql_;
      End If;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PICKLIST', Objid_);
      Return;
    End If;
  End;

  Procedure Remove__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  /*获取备货单号码*/
  Procedure Getpicklistno(Contract_    In Varchar2,
                          Customer_No_ In Varchar2,
                          Type_        In Varchar2,
                          Seq_         Out Varchar2) Is
    Row_        Bl_Plblser%Rowtype;
    Cur         t_Cursor;
    Ls_In_Cust_ Varchar2(10);
    Seqw_       Number; --流水号
    Seqn_       Varchar2(10);
    s_New_Picklistno varchar2(10);
  Begin
    -- 判断是否是内部客户
    Ls_In_Cust_ := Identity_Invoice_Info_Api.Get_Identity_Type(Site_Api.Get_Company(Contract_),
                                                               Customer_No_,
                                                               'Customer');
    If Ls_In_Cust_ = 'INTERN' Then
      If Type_ = 'U' Then
        Seqn_ := 'UI' || Substr(Customer_No_, Length(Customer_No_) - 1);
      Else
        Seqn_ := 'IN' || Substr(Customer_No_, Length(Customer_No_) - 1);
      End If;
      Seqw_ := 4;
    Else
      If Type_ = 'U' Then
        Seqn_ := 'U';
      Else
        Select Case Substr(Customer_No_, 1, 2)
                 When '99' Then
                  'A'
                 When '77' Then
                  'B'
                 When '10' Then
                  'C'
                 When '11' Then
                  'D'
                 When '12' Then
                  'F'
                 When '13' Then
                  'G'
                 Else
                  ''
               End
          Into Seqn_
          From Dual;
      End If;
      Seqn_ := Seqn_ || Substr(Customer_No_, Length(Customer_No_) - 3);
      Seqw_ := 3;
    End If;
    -- 查询最大的备货单号
    Open Cur For
      Select Nvl(Max(Picklistno), '0')
        From Bl_Plblser t
       Where t.Customerno = Customer_No_
         And t.Yearno = To_Char(Sysdate, 'yy');
    Fetch Cur
      Into Row_.Picklistno;
    --- if cur%notfound then
    --获取流水号 3位如果超过3位就按照AZ来取
    if Seqw_ ='3' then 
        s_New_Picklistno := substr(Row_.Picklistno,length(Row_.Picklistno)-2,3);
        If Row_.Picklistno ='0' Then
           s_New_Picklistno :='001' ;
        Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) = 57 And
              Ascii(Substr(s_New_Picklistno, 2, 1)) = 57 And
              Ascii(Substr(s_New_Picklistno, 1, 1)) = 57 Then
          --999
         s_New_Picklistno :='99A';
        Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) > 57 And
              Ascii(Substr(s_New_Picklistno, 3, 1)) < 90 And
              Ascii(Substr(s_New_Picklistno, 2, 1)) = 57 And
              Ascii(Substr(s_New_Picklistno, 1, 1)) = 57 Then
          --99A
          s_New_Picklistno := '99' || Chr(Ascii(Substr(s_New_Picklistno, 3, 1)) + 1);
        Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) = 90 And
              Ascii(Substr(s_New_Picklistno, 2, 1)) = 57 And
              Ascii(Substr(s_New_Picklistno, 1, 1)) = 57 Then
          --99Z
          s_New_Picklistno := '9AA';
        Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) > 57 And
              Ascii(Substr(s_New_Picklistno, 3, 1)) < 90 And
              Ascii(Substr(s_New_Picklistno, 2, 1)) > 57 And
              Ascii(Substr(s_New_Picklistno, 1, 1)) = 57 Then
          --9AA
         s_New_Picklistno := Substr(s_New_Picklistno, 1, 2) || Chr(Ascii(Substr(s_New_Picklistno,
                                                                    3,
                                                                    1)) + 1);
        Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) = 90 And
              Ascii(Substr(s_New_Picklistno, 2, 1)) > 57 And
              Ascii(Substr(s_New_Picklistno, 2, 1)) < 90 And
              Ascii(Substr(s_New_Picklistno, 1, 1)) = 57 Then
          --9AZ
          s_New_Picklistno := '9' || Chr(Ascii(Substr(s_New_Picklistno, 2, 1)) + 1) || 'A';
        Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) = 90 And
              Ascii(Substr(s_New_Picklistno, 2, 1)) = 90 And
              Ascii(Substr(s_New_Picklistno, 1, 1)) = 57 Then
          --9ZZ
          s_New_Picklistno := 'AAA';
        Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) > 57 And
              Ascii(Substr(s_New_Picklistno, 3, 1)) < 90 And
              Ascii(Substr(s_New_Picklistno, 2, 1)) > 57 And
              Ascii(Substr(s_New_Picklistno, 1, 1)) > 57 Then
          --AAA
          s_New_Picklistno := Substr(s_New_Picklistno, 1, 2) || Chr(Ascii(Substr(s_New_Picklistno,
                                                                    3,
                                                                    1)) + 1);
        Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) = 90 And
              Ascii(Substr(s_New_Picklistno, 2, 1)) > 57 And
              Ascii(Substr(s_New_Picklistno, 2, 1)) < 90 And
              Ascii(Substr(s_New_Picklistno, 1, 1)) > 57 Then
          --AAZ
          s_New_Picklistno := Substr(s_New_Picklistno, 1, 1) || Chr(Ascii(Substr(s_New_Picklistno,
                                                                    2,
                                                                    1)) + 1) || 'A';
        Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) = 90 And
              Ascii(Substr(s_New_Picklistno, 2, 1)) = 90 And
              Ascii(Substr(s_New_Picklistno, 1, 1)) > 57 Then
          --AZZ
          s_New_Picklistno := Chr(Ascii(Substr(s_New_Picklistno, 1, 1)) + 1) || 'AA';
        Else
          s_New_Picklistno := Substr(To_Char(Power(10, 3)+To_Number(Trim(s_New_Picklistno)) + 1),2);
        End If;
    else--4位
        s_New_Picklistno := Substr(To_Char(Power(10, Seqw_) + To_Number(Trim(Row_.Picklistno)) + 1),2);
    end if;
    Insert Into Bl_Plblser
      (Customerno, Yearno, Picklistno)
      Select Customer_No_,
             To_Char(Sysdate, 'yy'),
             s_New_Picklistno
        From Dual;
    -- seq_ := to_char(sysdate,'yy')||seqn_||substr( to_char(power(10,seqw_) + 1), 2); 
  
    --     update BL_PLBLSER
    --    set PICKLISTNO = substr( to_char(power(10,seqw_) + to_number(trim(picklistno)) + 1), 2)
    --    where CUSTOMERNO = row_.customerno
    --     and  yearno     = row_.yearno;
    Seq_ := To_Char(Sysdate, 'yy') || Seqn_ ||s_New_Picklistno;
  
    Close Cur;
    Return;
  End;

  Procedure Picinew__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
  Begin
    Return;
  End;

  Procedure Picimodify__(Rowlist_  Varchar2,
                         User_Id_  Varchar2,
                         A311_Key_ Varchar2) Is
    Row_       Bl_v_Bl_Picihead%Rowtype;
    Index_     Varchar2(1);
    Objid_     Varchar2(100);
    Doaction_  Varchar2(1);
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar2(4000);
    Ifmychange Varchar2(1);
  Begin
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    If Doaction_ = 'M' Then
      -- 更改数据
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := ' update bl_picihead set ';
      Ifmychange := '0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' And
           Length(Nvl(Column_Id_, '')) > 0 Then
          v_         := Substr(v_, Pos1_ + 1);
          i          := i + 1;
          Ifmychange := '1';
          If Column_Id_ = 'CREATEDATE' Or Column_Id_ = 'ALTERDATE' Then
            Mysql_ := Mysql_ || ' ' || Column_Id_ || '=to_date(''' || v_ ||
                      ''',''YYYY-MM-DD HH24:MI:SS''),';
          Else
            Mysql_ := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
          End If;
        End If;
      End Loop;
      If Ifmychange = '1' Then
        -- 更新sql语句 
        Mysql_ := Substr(Mysql_, 1, Length(Mysql_) - 1);
        Mysql_ := Mysql_ || ' where rowidtochar(rowid)=''' || Objid_ || '''';
        Execute Immediate Mysql_;
      End If;
    End If;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PICIHEAD', Objid_);
    Return;
  End;

  Procedure Release_Stock(Rowid_    Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
    Row_      Bl_Picklist%Rowtype;
    Cur_      t_Cursor;
    Ll_Count_ Number;
  Begin
    /*执行下达前要进行check*/
    Open Cur_ For
      Select t.* From Bl_Picklist t Where t.Rowid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Raise_Application_Error(Pkg_a.Raise_Error, '备货单不存在，不能下达');
      Return;
    End If;
    Close Cur_;
    If Row_.Flag != '0' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '备货单只有计划状态才能下达，不能下达');
      Return;
    End If;
  
    Select Count(*)
      Into Ll_Count_
      From Bl_Pldtl t
     Where Picklistno = Row_.Picklistno
       And t.Flag = '0'
       And Rownum = 1;
    If Ll_Count_ = 0 Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '备货单没有明细，不能下达');
      Return;
    End If;
    --下达之前检查是否已经做pici信息modify2013-01-31
    Select Count(*)
      Into Ll_Count_
      From Bl_Picihead
     Where Invoice_No = Row_.Picklistno
       And Rownum = 1;
    If Ll_Count_ = 0 Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '备货单没有做PICI信息，不能下达');
      Return;
    End If;
  
    Update Bl_Picklist
       Set Flag = '1', Releasedate = To_Char(Sysdate, 'yyyy-mm-dd')
     Where Rowid = Rowid_;
  
    --end--
    --只有计划状态才能更新 为下达 其他状态不能更新
    Update Bl_Pldtl
       Set Flag = '1'
     Where Picklistno = Row_.Picklistno
       And Flag = '0';
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PICKLIST', Rowid_);
    Return;
  End;
  Procedure Release_Zdstock(Rowid_    Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2) Is
    Row_      Bl_v_Bl_Picklist_Sup%Rowtype;
    Ll_Count_ Number;
  Begin
    Select t.*
      Into Row_
      From Bl_v_Bl_Picklist_Sup t
     Where t.Objid = Rowid_;
    --更新明细的状态为2
    Update Bl_Pldtl
       Set Flag = '2', Finishdate = To_Char(Sysdate, 'YYYY-MM-DD')
     Where Picklistno = Row_.Picklistno
       And Flag = '1'
       And Bl_Pick_Order_Line_Api.Get_Suplier_User(Supplier, User_Id_) = '1'; --用户供应域
    /*       AND Substr(Supplier, 1, 2) = (Select t.Contract
     From Bl_Usecon t, A007 T1
    Where T1.Bl_Userid = t.Userid
      And T1.A007_Id = User_Id_);*/
    --  AND Contract <> Row_.Supplier;
    --当备货单发货完成的时候调用备货单确定的功能 modify fjp 2012-12-07
    Select Count(*)
      Into Ll_Count_
      From Bl_Pldtl
     Where Picklistno = Row_.Picklistno
       And Flag Not In ('2', '3');
    If Ll_Count_ = 0 Then
      Bl_Pick_Order_Api.Finish_Stock(Rowid_, User_Id_, A311_Key_);
    End If;
    --end
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PICKLIST_SUP', Rowid_);
    Return;
  End;
  Procedure Releasecancel(Rowid_    Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
    Row_ Bl_Picklist%Rowtype;
  Begin
    Update Bl_Picklist
       Set Flag = '0', Releasedate = ''
     Where Rowid = Rowid_
    Returning Picklistno Into Row_.Picklistno;
    Update Bl_Pldtl Set Flag = '0' Where Picklistno = Row_.Picklistno;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PICKLIST', Rowid_);
    Return;
  End;
  Procedure Finish_Stock(Rowid_    Varchar2,
                         User_Id_  Varchar2,
                         A311_Key_ Varchar2) Is
    Picklistno_ Varchar2(20);
    Ll_Count_   Number;
    Bflag_      Varchar2(1);
    Info_       Varchar2(4000);
  Begin
    Update Bl_Picklist
       Set Flag = '2', Finishdate = To_Char(Sysdate, 'yyyy-mm-dd')
     Where Rowid = Rowid_
    Returning Picklistno, Bflag Into Picklistno_, Bflag_;
    Select Count(*)
      Into Ll_Count_
      From Bl_Pldtl
     Where Flag Not In ('2', '3')
       And Picklistno = Picklistno_;
    If Ll_Count_ > 0 Then
      Raise_Application_Error(-20101, '错误明细存在未完成的发货');
      Return;
    End If;
    /*     -- 更新被货单明细
    update  BL_PLDTL
     set   FLAG = '2'
     where picklistno = picklistno_;*/
    ---更新上层客户订单和备货单
    Info_ := '';
    Registered_Delivery_(Picklistno_, User_Id_, A311_Key_, Info_);
    If Info_ = '-1' Then
      Raise_Application_Error(-20101, '错误,不能更新上层的出入库');
      Return;
    End If;
    If Info_ = '-2' Then
      Raise_Application_Error(-20101, '错误,未找到上层的订单');
      Return;
    End If;
    -- 开发票
   /* If Bflag_ = '0' Then*/  --modify fjp 2013-02-25 补货备货单跟备货单开发票是同样的处理方式 
      Info_ := '';
      Co_Flowinvoice(Rowid_, User_Id_, A311_Key_, Info_);
      If Info_ = '-1' Then
        Raise_Application_Error(-20101, '有未发票号的后台表BL_PLINVDTL');
        Return;
      End If;
      If Info_ = '-2' Then
        Raise_Application_Error(-20101, '备货单明细不存在可开发票行');
        Return;
      End If;
/*    Else
      Update_Bl_Plinvdtl(Picklistno_, User_Id_, A311_Key_);
    End If;*/
    -- Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PICKLIST', Rowid_);
    Return;
  End;
  Procedure Finish_Customer(Rowid_    Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2) Is
    Picklistno_ Varchar2(20);
  Begin
    Update Bl_Picklist
       Set Recived      = To_Char(Sysdate, 'YYYY-MM-DD'),
           Recived_Date = To_Char(Sysdate, 'YYYY-MM-DD')
     Where Rowid = Rowid_;
    --modify fjp 2013-01-14发货确定关闭内销发货通知跟拼箱装车
    Select Picklistno
      Into Picklistno_
      From Bl_Picklist
     Where Rowid = Rowid_;
    Update Bl_Transport_Note
       Set State = '4'
     Where Picklistno = Picklistno_ --(SELECT PICKLISTNO FROM Bl_Picklist WHERE ROWID = Rowid_)
       And Notetype In ('E', 'F');
    Update Bl_Transport_Notecontract
       Set State = '4'
     Where Note_No In (Select t.Note_No
                         From Bl_Picklist T1
                        Inner Join Bl_Transport_Note t
                           On t.Picklistno = T1.Picklistno
                          And t.Notetype In ('E', 'F')
                          And T1.Picklistno = Picklistno_);
    -- 更新拼箱装车
    Update Bl_Containpicklist_Dtl
       Set State = '4'
     Where Picklistno = Picklistno_; --(SELECT PICKLISTNO FROM Bl_Picklist WHERE ROWID = Rowid_) ; 
    Update Bl_Containpicklist t
       Set State = '4'
     Where Not Exists (Select 1
              From Bl_Containpicklist_Dtl T1, Bl_Picklist T2
             Where t.Contain_No = T1.Contain_No
               And T1.Picklistno = T2.Picklistno
               And T2.Picklistno = Picklistno_
               And T1.State Not In ('4', '3'));
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PICKLIST', Rowid_);
    Return;
  End;
  Procedure Finish_Customer1(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2) Is
    Row_        Bl_v_Bl_Picklist_Po%Rowtype;
    Row1_       Bl_v_Bl_Pldtl%Rowtype;
    Row2_       Purchase_Order_Line_Part%Rowtype;
    Row3_       Bl_Ciq_Contract_Tab%Rowtype;
    Cur_        t_Cursor;
    Cur1_       t_Cursor;
    Cur2_       t_Cursor;
    Cur3_       t_Cursor;
    Atrr_       Varchar2(4000);
    Flag_       Varchar2(1); --预备fjp 2013-01-21
    Maxtransid_ Number;
    Rowst_      Inventory_Transaction_Hist2%Rowtype;
  Begin
    --   Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_); modify 2013-02-01
    Row_.Objid := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_v_Bl_Picklist_Po t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '未取得备货单的信息');
      Return;
    End If;
    Close Cur_;
    -- Row_.Pickno := Pkg_a.Get_Item_Value('PICKNO', Rowlist_);modify 2013-02-01
    --  row_.LOCATION     := pkg_a.Get_Item_Value('LOCATION', rowlist_);
    -- Row_.Lot_Batch_No := Pkg_a.Get_Item_Value('LOT_BATCH_NO', Rowlist_);modify 2013-02-01
    -- Row_.Recived      := Pkg_a.Get_Item_Value('RECIVED', Rowlist_);modify 2013-02-01
    Row_.Recived := Row_.Recived_Date;
    --modify fjp 2012-12-18  当为12域的时候，需要先入检验库再入12库在移库到客户库。
    Open Cur_ For
      Select t.*
        From Bl_Ciq_Contract_Tab t
       Where t.Contract = Row_.Pcontract
         And t.Arred Is Not Null;
    Fetch Cur_
      Into Row3_;
    If Cur_%Found Then
      Row_.Location := Row3_.Arred;
    End If;
    Close Cur_;
    ----- end  fjp---
    If Nvl(Row_.Lot_Batch_No, 'NULL') = 'NULL' Then
      Raise_Application_Error(-20101, '批次号不能为空');
      Return;
    End If;
    If Nvl(Row_.Location, 'NULL') = 'NULL' Then
      Raise_Application_Error(-20101, '库位不能为空');
      Return;
    End If;
    If Nvl(Row_.Recived, 'NULL') = 'NULL' Then
      Raise_Application_Error(-20101, '入库日期不能为空');
      Return;
    End If;
    Open Cur1_ For
      Select t.*
        From Bl_v_Bl_Pldtl t
       Where t.Picklistno = Row_.Picklistno
         And t.Flag = '2';
    Fetch Cur1_
      Into Row1_;
    While Cur1_%Found Loop
      Open Cur2_ For
        Select t.*
          From Purchase_Order_Line_Part t
         Where t.Order_No = Row1_.Org_Orderno
           And t.Line_No = Row1_.Org_Lineno
           And t.Release_No = Row1_.Org_Relno;
      Fetch Cur2_
        Into Row2_;
      If Cur2_%Found Then
        --获取事物号
        --  IF NVL(row3_.arred,'NULL') = 'NULL'  THEN 
        Select Nvl(Max(Transaction_Id), 0)
          Into Maxtransid_
          From Inventory_Transaction_Hist2
         Where Order_No = Row2_.Order_No
           And Release_No = Row2_.Line_No
           And Sequence_No = Row2_.Release_No;
        --  end if;
        -- 调用ifs的登记达到的函数 
        Atrr_ := '';
        Pkg_a.Set_Item_Value('OBJID', Row2_.Objid, Atrr_);
        Pkg_a.Set_Item_Value('DUE_AT_DOCK', Row1_.Finishqty, Atrr_);
        Pkg_a.Set_Item_Value('LOT_BATCH_NO', Row_.Lot_Batch_No, Atrr_);
        Pkg_a.Set_Item_Value('LOCATION_NO', Row_.Location, Atrr_);
        If Site_Api.Get_Company(Row2_.Contract) =
           Site_Api.Get_Company(Row2_.Vendor_No) Then
          Bl_Receive_Purchase_Order_Api.Create_New_Receipt(Atrr_,
                                                           User_Id_,
                                                           A311_Key_);
        Else
          Bl_Receive_Purchase_Order_Api.Packed_Arrival__(Atrr_,
                                                         User_Id_,
                                                         A311_Key_);
        End If;
        --如果入检验库位不写入入库记录到BL表中
        If Nvl(Row3_.Arred, 'NULL') <> 'NULL' Then
          Flag_ := '0'; --预备入库标示 modify fjp 2013-01-21
        Else
          Flag_ := '1';
        End If;
        Insert Into Bl_Plinv_Reg_Dtl_Tab
          (Picklistno,
           Transaction_Id,
           Pickno,
           Order_No,
           Line_No,
           Release_No,
           Location,
           Lot_Batch_No,
           Receipt_No,
           Flag)
          Select Row_.Picklistno,
                 Transaction_Id,
                 Row_.Pickno,
                 Row2_.Order_No,
                 Row2_.Line_No,
                 Row2_.Release_No,
                 Row_.Location,
                 Row_.Lot_Batch_No,
                 Line_Item_No,
                 Flag_
            From Inventory_Transaction_Hist2
           Where Order_No = Row2_.Order_No
             And Release_No = Row2_.Line_No
             And Sequence_No = Row2_.Release_No
             And Transaction_Id > Maxtransid_;
        --  END IF ;
        --补货备货单更新库存中的日期 modify  fjp 2013-02-04
        If Flag_ = '1' Then
        
          Open Cur3_ For
            Select t.*
              From Inventory_Transaction_Hist2 t
             Where Order_No = Row2_.Order_No
               And Release_No = Row2_.Line_No
               And Sequence_No = Row2_.Release_No
               And Transaction_Id > Maxtransid_;
          Fetch Cur3_
            Into Rowst_;
          While Cur3_%Found Loop
            /*
            modify by wtl  2013-02-21
             Inventory_Transaction_Hist_Api.Modify_Date_Applied(Rowst_.Transaction_Id,
                                                                 Row_.RECIVED);
            转换接收日期 */
          
            Inventory_Transaction_Hist_Api.Modify_Date_Applied(Rowst_.Transaction_Id,
                                                               To_Date(Row_.Recived,
                                                                       'YYYY-MM-DD'));
            Fetch Cur3_
              Into Rowst_;
          End Loop;
          Close Cur3_;
        End If;
      Else
        Close Cur2_;
        Close Cur1_;
        Raise_Application_Error(-20101, '采购订单未获取登记信息');
        Return;
      End If;
      Close Cur2_;
      Fetch Cur1_
        Into Row1_;
    End Loop;
    Close Cur1_;
    Update Bl_Picklist
       Set --Location = Row_.Location,
           Recived = Row_.Recived
     Where Rowid = Row_.Objid;
    --modify fjp 2013-01-14发货确定关闭内销发货通知跟拼箱装车
    Update Bl_Transport_Note
       Set State = '4'
     Where Picklistno = Row_.Picklistno --(SELECT PICKLISTNO FROM Bl_Picklist WHERE ROWID = Row_.Objid)
       And Notetype In ('E', 'F');
    Update Bl_Transport_Notecontract
       Set State = '4'
     Where Note_No In (Select t.Note_No
                         From Bl_Picklist T1
                        Inner Join Bl_Transport_Note t
                           On t.Picklistno = T1.Picklistno
                          And t.Notetype In ('E', 'F')
                          And T1.Picklistno = Row_.Picklistno);
    -- 更新拼箱装车
    Update Bl_Containpicklist_Dtl
       Set State = '4'
     Where Picklistno = Row_.Picklistno; --(SELECT PICKLISTNO FROM Bl_Picklist WHERE ROWID = Row_.Objid) ; 
    Update Bl_Containpicklist t
       Set State = '4'
     Where Not Exists (Select 1
              From Bl_Containpicklist_Dtl T1, Bl_Picklist T2
             Where t.Contain_No = T1.Contain_No
               And T1.Picklistno = T2.Picklistno
               And T2.Picklistno = Row_.Picklistno
               And T1.State Not In ('4', '3'));
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PICKLIST', Row_.Objid);
    Return;
  End;
  --进口采购modify fjp 2013-01-16
  Procedure Finish_Customer2(Rowlist_  Varchar2,
                             User_Id_  Varchar2,
                             A311_Key_ Varchar2) Is
    Row_        Bl_v_Bl_Picklist_Po1%Rowtype;
    Row1_       Bl_v_Bl_Pldtl%Rowtype;
    Row2_       Purchase_Order_Line_Part%Rowtype;
    Row3_       Bl_Ciq_Contract_Tab%Rowtype;
    Cur_        t_Cursor;
    Cur1_       t_Cursor;
    Cur2_       t_Cursor;
    Atrr_       Varchar2(4000);
    Flag_       Varchar2(1); --预备fjp 2013-01-21
    Maxtransid_ Number;
    Cur3_       t_Cursor;
    Rowst_      Inventory_Transaction_Hist2%Rowtype;
  Begin
    /*    insert into af(col,col01)
    values('Finish_Customer2',Rowlist_);
    commit;
    return;*/
    --   select col01 into Rowlist1_ from af  where col ='Finish_Customer2';
    /*  Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);*/
    Row_.Objid := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_v_Bl_Picklist_Po1 t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '未取得备货单的信息');
      Return;
    End If;
    Close Cur_;
    /*  Row_.Pickno := Pkg_a.Get_Item_Value('PICKNO', Rowlist_);*/
    --  row_.LOCATION     := pkg_a.Get_Item_Value('LOCATION', rowlist_);
    /*    Row_.Lot_Batch_No := Pkg_a.Get_Item_Value('LOT_BATCH_NO', Rowlist_);
    Row_.Recived      := Pkg_a.Get_Item_Value('RECIVED', Rowlist_);*/
    Row_.Recived := Row_.Recived_Date;
    --modify fjp 2012-12-18  当为12域的时候，需要先入检验库再入12库在移库到客户库。
    Open Cur_ For
      Select t.*
        From Bl_Ciq_Contract_Tab t
       Where t.Contract = Row_.Pcontract
         And t.Arred Is Not Null;
    Fetch Cur_
      Into Row3_;
    If Cur_%Found Then
      Row_.Location := Row3_.Arred;
    End If;
    Close Cur_;
    ----- end  fjp---
    If Nvl(Row_.Lot_Batch_No, 'NULL') = 'NULL' Then
      Raise_Application_Error(-20101, '批次号不能为空');
      Return;
    End If;
    If Nvl(Row_.Location, 'NULL') = 'NULL' Then
      Raise_Application_Error(-20101, '库位不能为空');
      Return;
    End If;
    If Nvl(Row_.Recived, 'NULL') = 'NULL' Then
      Raise_Application_Error(-20101, '入库日期不能为空');
      Return;
    End If;
    Open Cur1_ For
      Select t.*
        From Bl_v_Bl_Pldtl t
       Where t.Picklistno = Row_.Picklistno
         And t.Flag = '2';
    Fetch Cur1_
      Into Row1_;
    While Cur1_%Found Loop
      Open Cur2_ For
        Select t.*
          From Purchase_Order_Line_Part t
         Where t.Order_No = Row1_.Org_Orderno
           And t.Line_No = Row1_.Org_Lineno
           And t.Release_No = Row1_.Org_Relno;
      Fetch Cur2_
        Into Row2_;
      If Cur2_%Found Then
        -- IF NVL(row3_.arred,'NULL') = 'NULL'  THEN 
        --获取事物号
        Select Nvl(Max(Transaction_Id), 0)
          Into Maxtransid_
          From Inventory_Transaction_Hist2
         Where Order_No = Row2_.Order_No
           And Release_No = Row2_.Line_No
           And Sequence_No = Row2_.Release_No;
        -- end if;
        -- 调用ifs的登记达到的函数 
        Atrr_ := '';
        Pkg_a.Set_Item_Value('OBJID', Row2_.Objid, Atrr_);
        Pkg_a.Set_Item_Value('DUE_AT_DOCK', Row1_.Finishqty, Atrr_);
        Pkg_a.Set_Item_Value('LOT_BATCH_NO', Row_.Lot_Batch_No, Atrr_);
        Pkg_a.Set_Item_Value('LOCATION_NO', Row_.Location, Atrr_);
        If Site_Api.Get_Company(Row2_.Contract) =
           Site_Api.Get_Company(Row2_.Vendor_No) Then
          Bl_Receive_Purchase_Order_Api.Create_New_Receipt(Atrr_,
                                                           User_Id_,
                                                           A311_Key_);
        Else
          Bl_Receive_Purchase_Order_Api.Packed_Arrival__(Atrr_,
                                                         User_Id_,
                                                         A311_Key_);
        End If;
        --如果入检验库位不写入入库记录到BL表中
        If Nvl(Row3_.Arred, 'NULL') <> 'NULL' Then
          Flag_ := '0'; --预备入库标示 modify fjp 2013-01-21
        Else
          Flag_ := '1';
        End If;
        Insert Into Bl_Plinv_Reg_Dtl_Tab
          (Picklistno,
           Transaction_Id,
           Pickno,
           Order_No,
           Line_No,
           Release_No,
           Location,
           Lot_Batch_No,
           Receipt_No,
           Flag)
          Select Row_.Picklistno,
                 Transaction_Id,
                 Row_.Pickno,
                 Row2_.Order_No,
                 Row2_.Line_No,
                 Row2_.Release_No,
                 Row_.Location,
                 Row_.Lot_Batch_No,
                 Line_Item_No,
                 Flag_
            From Inventory_Transaction_Hist2
           Where Order_No = Row2_.Order_No
             And Release_No = Row2_.Line_No
             And Sequence_No = Row2_.Release_No
             And Transaction_Id > Maxtransid_;
        -- END IF ;
        --补货备货单更新库存中的日期 modify  fjp 2013-02-04
        If Flag_ = '1' Then
          Open Cur3_ For
            Select t.*
              From Inventory_Transaction_Hist2 t
             Where Order_No = Row2_.Order_No
               And Release_No = Row2_.Line_No
               And Sequence_No = Row2_.Release_No
               And Transaction_Id > Maxtransid_;
          Fetch Cur3_
            Into Rowst_;
          While Cur3_%Found Loop
            Inventory_Transaction_Hist_Api.Modify_Date_Applied(Rowst_.Transaction_Id,
                                                               Row_.Recived);
            Fetch Cur3_
              Into Rowst_;
          End Loop;
          Close Cur3_;
        End If;
      Else
        Close Cur2_;
        Close Cur1_;
        Raise_Application_Error(-20101, '采购订单未获取登记信息');
        Return;
      End If;
      Close Cur2_;
      Fetch Cur1_
        Into Row1_;
    End Loop;
    Close Cur1_;
    Update Bl_Picklist
       Set --Location = Row_.Location,
           Recived = Row_.Recived
     Where Rowid = Row_.Objid;
    --modify fjp 2013-01-14发货确定关闭内销发货通知跟拼箱装车
    Update Bl_Transport_Note
       Set State = '4'
     Where Picklistno = Row_.Picklistno --(SELECT PICKLISTNO FROM Bl_Picklist WHERE ROWID = Row_.Objid)
       And Notetype In ('E', 'F');
    Update Bl_Transport_Notecontract
       Set State = '4'
     Where Note_No In (Select t.Note_No
                         From Bl_Picklist T1
                        Inner Join Bl_Transport_Note t
                           On t.Picklistno = T1.Picklistno
                          And t.Notetype In ('E', 'F')
                          And T1.Picklistno = Row_.Picklistno); --WHERE T1.ROWID = Row_.Objid);
    -- 更新拼箱装车
    Update Bl_Containpicklist_Dtl
       Set State = '4'
     Where Picklistno = Row_.Picklistno; --(SELECT PICKLISTNO FROM Bl_Picklist WHERE ROWID = Row_.Objid) ;   
    Update Bl_Containpicklist t
       Set State = '4'
     Where Not Exists (Select 1
              From Bl_Containpicklist_Dtl T1, Bl_Picklist T2
             Where t.Contain_No = T1.Contain_No
               And T1.Picklistno = T2.Picklistno
               And T2.Picklistno = Row_.Picklistno
               And T1.State Not In ('4', '3'));
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PICKLIST', Row_.Objid);
    Return;
  End;
  ---end进口采购modify fjp 2013-01-16--
  Procedure Co_Flowinvoice(Rowid_    Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2,
                           Info_     Out Varchar2) Is
    Cur_        t_Cursor;
    Order_No_   Bl_Pldtl.Order_No%Type;
    Picklistno_ Bl_Pldtl.Picklistno%Type;
    Feeorderno_ Bl_Picklist.Feeorderno%Type;
    Ll_Count_   Number;
  Begin
    Select Count(*)
      Into Ll_Count_
      From Bl_Plinvdtl
     Where Invoice_No Is Null;
    If Ll_Count_ > 0 Then
      Info_ := '-1';
      Return;
    End If;
    Open Cur_ For
      Select Distinct T1.Order_No, T1.Picklistno, t.Feeorderno
        From Bl_Pldtl T1,  Bl_Picklist t
       Where t.Picklistno = T1.Picklistno
        -- And t.Objid = Rowid_
         And t.Flag = '2'
         And T1.Flag = '2'
         AND T.PICKLISTNO IN (SELECT PICKLISTNO FROM BL_PICKLIST  WHERE ROWID=Rowid_);
    Fetch Cur_
      Into Order_No_, Picklistno_, Feeorderno_;
    If Cur_%Notfound Then
      Close Cur_;
      Info_ := '-2';
      Return;
    End If;
    While Cur_%Found Loop
      Bl_Customer_Order_Flow_Api.Start_Create_Invoice__(Order_No_,
                                                        User_Id_,
                                                        A311_Key_);
      Fetch Cur_
        Into Order_No_, Picklistno_, Feeorderno_;
    End Loop;
    Close Cur_;
    -- 如果主档有费用订单号，则开发票  modify fjp 2012-12-12 
    If Nvl(Feeorderno_, 'NULL') <> 'NULL' Then
      Bl_Customer_Order_Flow_Api.Start_Create_Invoice__(Feeorderno_,
                                                        User_Id_,
                                                        A311_Key_);
    End If;
    --写入后台发票情况表BL_PLINVDTL
    Update_Bl_Plinvdtl(Picklistno_, User_Id_, A311_Key_);
    --更新BL_PLINVDTL的Invoice_no号
    /*   pkg_a.setNextDo(a311_key_, 'BL_Pick_Order_api.Update_BL_PLINVDTL_Invoice',user_id_,
    'BL_Pick_Order_api.Update_BL_PLINVDTL_Invoice(''' ||picklistno_|| ''',''' || USER_ID_ || ''',''' || A311_KEY_ || ''')',
    2/60/24);*/
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PICKLIST', Rowid_);
    Return;
  End;
  Procedure Update_Bl_Plinvdtl(Picklistno_ In Varchar2, --备货单号
                               User_Id_    In Varchar2,
                               A311_Key_   In Varchar2) Is
    Cur_        t_Cursor;
    Cur1_       t_Cursor;
    Row_        Bl_v_Bl_Pldtl%Rowtype;
    Row1_       Bl_v_Customer_Order_V02%Rowtype;
    Row2_       Bl_Plinvdtl%Rowtype;
    Feeorderno_ Bl_Picklist.Feeorderno%Type;
    Bflag_      Varchar2(1);
  Begin
    Select Bflag, Feeorderno
      Into Bflag_, Feeorderno_
      From Bl_Picklist
     Where Picklistno = Picklistno_;
    -- 费用订单号关键字都都写为0 modify fjp 2012-12-12 
    If Nvl(Feeorderno_, 'NULL') <> 'NULL' Then
      If Bflag_ = '1' Then
        --补货被货单发票为NULL
        Row2_.Invoice_No := '';
      Else
        Row2_.Invoice_No := '';
      End If;
      -- Row2_.Picklistno   := Row_.Picklistno;
      /*modify by  wtl  2013-02-21 */
      Row2_.Picklistno   := Picklistno_;
      Row2_.Order_No     := Feeorderno_;
      Row2_.Line_No      := '0';
      Row2_.Rel_No       := '0';
      Row2_.Line_Item_No := 0;
      Select Contract
        Into Row2_.Contract
        From Customer_Order_Tab
       Where Order_No = Feeorderno_;
      Insert_Bl_Plinvdtl(Row2_, User_Id_, A311_Key_);
    End If;
    Open Cur_ For
      Select t.*
        From Bl_v_Bl_Pldtl t
       Where t.Picklistno = Picklistno_
         And t.Flag = '2';
    Fetch Cur_
      Into Row_;
    While Cur_%Found Loop
      If Bflag_ = '1' Then
        --补货被货单发票为NULL
        Row2_.Invoice_No := '';
      Else
        Row2_.Invoice_No := '';
      End If;
      Row2_.Picklistno   := Row_.Picklistno;
      Row2_.Order_No     := Row_.Order_No;
      Row2_.Line_No      := Row_.Line_No;
      Row2_.Rel_No       := Row_.Rel_No;
      Row2_.Line_Item_No := Row_.Line_Item_No;
      Row2_.Contract     := Row_.Contract;
      Insert_Bl_Plinvdtl(Row2_, User_Id_, A311_Key_);
      If Row_.Contract <> Substr(Row_.Supplier, 1, 2) Then
        Open Cur1_ For
          Select t.*
            From Bl_v_Customer_Order_V02 t
           Where t.Order_No = Row_.Porder_No
             And t.Line_No = Row_.Pline_No
             And t.Rel_No = Row_.Prel_No
             And t.Line_Item_No = Row_.Pline_Item_No;
        Fetch Cur1_
          Into Row1_;
        If Cur1_%Found Then
          If Row_.Porder_No <> Row_.Order_No Then
            Row2_.Invoice_No   := '0';
            Row2_.Order_No     := Row1_.Order_No;
            Row2_.Line_No      := Row1_.Line_No;
            Row2_.Rel_No       := Row1_.Rel_No;
            Row2_.Line_Item_No := Row1_.Line_Item_No;
            Row2_.Contract     := Row1_.Co_Contract;
            Insert_Bl_Plinvdtl(Row2_, User_Id_, A311_Key_);
          End If;
          If Nvl(Row1_.Demand_Order_No, 'NULL') <> Row_.Order_No Then
            Row2_.Invoice_No   := '0';
            Row2_.Order_No     := Row1_.Demand_Order_No;
            Row2_.Line_No      := Row1_.Demand_Line_No;
            Row2_.Rel_No       := Row1_.Demand_Rel_No;
            Row2_.Line_Item_No := Row1_.Demand_Line_Item_No;
            Row2_.Contract     := Row1_.Po_Contract;
            Insert_Bl_Plinvdtl(Row2_, User_Id_, A311_Key_);
          End If;
        End If;
        /*        ELSE
          CLOSE Cur1_;
          CLOSE Cur_;
          Raise_Application_Error(-20101, '未找到上层的订单');
          RETURN;
        END IF;*/
      End If;
      Fetch Cur_
        Into Row_;
    End Loop;
    Close Cur_;
    Return;
  End;
  Procedure Insert_Bl_Plinvdtl(Row_      Bl_Plinvdtl%Rowtype, --后台表BL_PLINVDTL的所有字段
                               User_Id_  In Varchar2,
                               A311_Key_ In Varchar2) Is
  Begin
    Insert Into Bl_Plinvdtl
      (Picklistno,
       Order_No,
       Line_No,
       Rel_No,
       Line_Item_No,
       Systemdate,
       Invoice_No,
       Ciqno,
       Lineid,
       Contract)
      Select Row_.Picklistno,
             Row_.Order_No,
             Row_.Line_No,
             Row_.Rel_No,
             Row_.Line_Item_No,
             Sysdate,
             Row_.Invoice_No,
             '0',
             '1',
             Row_.Contract
        From Dual;
    Return;
  End;
  Procedure Update_Bl_Plinvdtl_Invoice(Picklistno_ In Varchar2, --备货单号
                                       User_Id_    In Varchar2,
                                       A311_Key_   In Varchar2) Is
    Cur_  t_Cursor;
    Cur1_ t_Cursor;
    Row_  Bl_v_Bl_Pldtl%Rowtype;
    Row1_ Bl_v_Customer_Order_V02%Rowtype;
    Row2_ Bl_Plinvdtl%Rowtype;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_v_Bl_Pldtl t
       Where t.Picklistno = Picklistno_
         And t.Flag = '2';
    Fetch Cur_
      Into Row_;
    While Cur_%Found Loop
      -- 获取发票号
      Select Max(Invoice_No)
        Into Row2_.Invoice_No
        From Customer_Order_Inv_Item t
       Where t.Order_No = Row_.Order_No
         And t.Line_No = Row_.Line_No
         And t.Release_No = Row_.Rel_No
         And t.Line_Item_No = Row_.Line_Item_No
         And t.Invoiced_Qty = Row_.Finishqty;
      If Nvl(Row2_.Invoice_No, 'NULL') = 'NULL' Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                '未找到备货单' || Picklistno_ || '的发票号');
        Return;
      End If;
      Update Bl_Plinvdtl
         Set Invoice_No = Row2_.Invoice_No
       Where Picklistno = Row_.Picklistno
         And Order_No = Row_.Order_No
         And Line_No = Row_.Line_No
         And Rel_No = Row_.Rel_No
         And Line_Item_No = Row_.Line_Item_No
         And Ciqno = '0'
         And Lineid = '1';
      If Row_.Contract <> Substr(Row_.Supplier, 1, 2) Then
        Open Cur1_ For
          Select t.*
            From Bl_v_Customer_Order_V02 t
           Where t.Order_No = Row_.Porder_No
             And t.Line_No = Row_.Pline_No
             And t.Rel_No = Row_.Prel_No
             And t.Line_Item_No = Row_.Pline_Item_No;
        Fetch Cur1_
          Into Row1_;
        If Cur1_%Found Then
          If Row_.Porder_No <> Row_.Order_No Then
            Update Bl_Plinvdtl
               Set Invoice_No = Row2_.Invoice_No
             Where Picklistno = Row_.Picklistno
               And Order_No = Row1_.Order_No
               And Line_No = Row1_.Line_No
               And Rel_No = Row1_.Rel_No
               And Line_Item_No = Row1_.Line_Item_No
               And Ciqno = '0'
               And Lineid = '1';
          End If;
          If Nvl(Row1_.Demand_Order_No, 'NULL') <> Row_.Order_No Then
            Update Bl_Plinvdtl
               Set Invoice_No = Row2_.Invoice_No
             Where Picklistno = Row_.Picklistno
               And Order_No = Row1_.Demand_Order_No
               And Line_No = Row1_.Demand_Line_No
               And Rel_No = Row1_.Demand_Rel_No
               And Line_Item_No = Row1_.Demand_Line_Item_No
               And Ciqno = '0'
               And Lineid = '1';
          End If;
        Else
          Close Cur1_;
          Close Cur_;
          Raise_Application_Error(-20101, '未找到上层的订单');
          Return;
        End If;
      End If;
      Fetch Cur_
        Into Row_;
    End Loop;
    Close Cur_;
    Return;
  End;
  Procedure Unite__Stock(Rowlist_  Varchar2,
                         User_Id_  Varchar2,
                         A311_Key_ Varchar2) Is
  Begin
    Return;
  End;

  Procedure Unite__Cancel(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
  Begin
    Return;
  End;
  Procedure Picklist_Auto_(Rowid_    Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2) Is
    Row_  Bl_Picklist%Rowtype;
    Row2_ Bl_Delivery_Plan%Rowtype;
    Row0_ Bl_v_Bl_Picihead_V01%Rowtype;
    Row1_ Bl_Picihead%Rowtype;
    Cur_  t_Cursor;
  Begin
    Open Cur_ For
      Select t.* From Bl_Delivery_Plan t Where t.Rowid = Rowid_;
    Fetch Cur_
      Into Row2_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    If Nvl(Row2_.State, '-') <> '2' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '交货计划必须是确认状态才能生成备货单！');
      Return;
    
    End If;
    If Nvl(Row2_.Picklistno, '-') <> '-' Then
    
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '交货计划已经生成备货单' || Row2_.Picklistno ||
                              '，不能再生成了！');
      Return;
    End If;
  
    ---  自动生成备货单
    --  获取值
    Row_.Contract   := Row2_.Contract;
    Row_.Customerno := Row2_.Customer_No;
    -- 获取备货单号
    Getpicklistno(Row_.Contract, Row_.Customerno, 'P', Row_.Picklistno);
   -- Row_.Picklistno := Get_New_Picklistno(To_Char(Sysdate, 'yy'), Row_.Customerno);
    If Bl_Pick_Order_Line_Api.Get_Original_Order_(Row2_.Order_No) =
       Row2_.Order_No Then
      Row_.Bflag := '0';
    Else
      Row_.Bflag := '1';
    End If;
    Row_.Deldate    := To_Char(Row2_.Delived_Date, 'yyyy-mm-dd');
    Row_.Flag       := '0';
    Row_.Userid     := User_Id_;
    Row_.Createdate := To_Char(Sysdate, 'yyyy-mm-dd');
    If Length(Row_.Customerno) > 2 Then
      Row_.Customer_Ref := Row2_.Customer_No; --pkg_a.Get_Item_Value('LABEL_NOTE',ROWLIST_);
    Else
      Row_.Customer_Ref := Row2_.Customer_Ref;
    End If;
    --插入主档数据
    Insert Into Bl_Picklist
      (Contract,
       Customerno,
       Picklistno,
       Deldate,
       Flag,
       Userid,
       Createdate,
       Customer_Ref,
       Bflag,
       Ifnew)
      Select Row_.Contract,
             Row_.Customerno,
             Row_.Picklistno,
             Row_.Deldate,
             Row_.Flag,
             Row_.Userid,
             Row_.Createdate,
             Row_.Customer_Ref,
             Row_.Bflag,
             'NEW'
        From Dual;
    -- 插入主档pi信息
    Insert Into Bl_Picihead
      (Invoice_No, Invoicetype)
      Select Row_.Picklistno, 'PI' From Dual;
    Open Cur_ For
      Select t.*
        From Bl_v_Bl_Picihead_V01 t
       Where t.Invoice_No = Row_.Picklistno
         And t.Alterdate Is Not Null
       Order By t.Alterdate Desc;
    Fetch Cur_
      Into Row0_;
    If Cur_%Found Then
      Row1_.Invoice_No     := Row_.Picklistno;
      Row1_.Invoicetype    := 'PI';
      Row1_.Comname        := Row0_.Comname;
      Row1_.Address        := Row0_.Address;
      Row1_.Tel            := Row0_.Tel;
      Row1_.Fax            := Row0_.Fax;
      Row1_.Shangdate      := Row0_.Shangdate;
      Row1_.Tomu           := Row0_.Tomu;
      Row1_.Marks          := Row0_.Marks;
      Row1_.Etd            := Row0_.Etd;
      Row1_.Eta            := Row0_.Eta;
      Row1_.Refer          := Row0_.Refer;
      Row1_.Remark         := Row0_.Remark;
      Row1_.Shipby         := Row0_.Shipby;
      Row1_.Payment        := Row0_.Payment;
      Row1_.Fromq          := Row0_.Fromq;
      Row1_.Hb             := Row0_.Hb;
      Row1_.Delivery_Desc  := Row0_.Delivery_Desc;
      Row1_.Custname       := Row0_.Custname;
      Row1_.Custaddress    := Row0_.Custaddress;
      Row1_.Marks1         := Row0_.Marks1;
      Row1_.Marks2         := Row0_.Marks2;
      Row1_.Marks3         := Row0_.Marks3;
      Row1_.Marks4         := Row0_.Marks4;
      Row1_.Bank           := Row0_.Bank;
      Row1_.Wood           := Row0_.Wood;
      Row1_.Trade          := Row0_.Trade;
      Row1_.Strcong        := Row0_.Strcong;
      Row1_.Vatno          := Row0_.Vatno;
      Row1_.Weightpallet   := Row0_.Weightpallet;
      Row1_.Howpallet      := Row0_.Howpallet;
      Row1_.Engrender      := Row0_.Engrender;
      Row1_.Deliveraddress := Row0_.Deliveraddress;
      Row1_.Purchase_No    := Row0_.Purchase_No;
      Row1_.Warehouse      := Row0_.Warehouse;
      Row1_.Createdate     := Row0_.Createdate;
      Row1_.Custname2      := Row0_.Custname2;
      Row1_.Invoice_Date   := Row0_.Invoice_Date;
      Row1_.Showwarehouse  := Row0_.Showwarehouse;
      Row1_.Inviceno2      := Row0_.Inviceno2;
      Row1_.Alterdate      := Sysdate;
      Row1_.Tracking_No    := Row0_.Tracking_No;
      Row1_.Bank_No        := Row0_.Bank_No;
      Row1_.Bank_Info      := Row0_.Bank_Info;
      Row1_.Ifpart_No      := Row0_.Ifpart_No;
      Row1_.Origin         := Row0_.Origin;
      Row1_.Origin_Desc    := Row0_.Origin_Desc;
      Row1_.Shop_Add       := Row0_.Shop_Add;
      Row1_.Shop_Add_Desc  := Row0_.Shop_Add_Desc;
      Row1_.Pay_Term_Id    := Row0_.Pay_Term_Id;
      Update Bl_Picihead
         Set Row = Row1_
       Where Invoice_No = Row_.Picklistno;
    End If;
    Close Cur_;
    ---  更新交货计划
    Update Bl_Delivery_Plan
       Set Picklistno = Row_.Picklistno
     Where Delplan_No = Row2_.Delplan_No;
    -- 插入备货表的数据
    Insert Into Bl_Pldtl
      (Contract,
       Customerno,
       Picklistno,
       Supplier,
       Order_No,
       Line_No,
       Rel_No,
       Line_Item_No,
       Pickqty,
       Wanted_Delivery_Date,
       Finishdate,
       Remark,
       Flag,
       Userid,
       Finishqty,
       Relqty,
       Reason,
       Drdate,
       Notetext,
       Deremark,
       Rel_Deliver_Date)
      Select t.Contract,
             t.Customer_No,
             Row_.Picklistno,
             Row2_.Supplier,
             t.Order_No,
             t.Line_No,
             t.Rel_No,
             t.Line_Item_No,
             t.Qty_Delived,
             To_Char(Row2_.Delived_Date, 'yyyy-mm-dd'),
             Null,
             '',
             '0',
             User_Id_,
             Null,
             Null,
             Null,
             Null,
             Null,
             Null,
             Null
        From Bl_v_Cust_Order_Line_Pdelive t
       Where t.Delplan_No = Row2_.Delplan_No
         And t.State = '2';
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUST_ORDER_LINE_PHDELIVE', Rowid_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '自动生成备货单' || Row_.Picklistno || '成功');
    Return;
  End;
  Procedure Registered_Delivery_(Picklistno_ In Varchar2,
                                 User_Id_    Varchar2,
                                 A311_Key_   Varchar2,
                                 Info_       Out Varchar2) Is
    Row_          Bl_v_Bl_Pldtl%Rowtype;
    Row1_         Bl_v_Customer_Order_V02%Rowtype;
    Row2_         Purchase_Order_Line_Part%Rowtype;
    Cur_          t_Cursor;
    Cur1_         t_Cursor;
    Cur2_         t_Cursor;
    Cur3_         t_Cursor;
    Attr_         Varchar2(4000);
    Transit_Attr_ Varchar2(100);
  Begin
    Open Cur_ For
      Select t.*
        From Bl_v_Bl_Pldtl t
       Where t.Picklistno = Picklistno_
         And t.Flag = '2';
    Fetch Cur_
      Into Row_;
    While Cur_%Found Loop
      If Row_.Contract <> Substr(Row_.Supplier, 1, 2) Then
        Open Cur1_ For
          Select t.*
            From Bl_v_Customer_Order_V02 t
           Where t.Order_No = Row_.Porder_No
             And t.Line_No = Row_.Pline_No
             And t.Rel_No = Row_.Prel_No
             And t.Line_Item_No = Row_.Pline_Item_No;
        Fetch Cur1_
          Into Row1_;
        If Cur1_%Found Then
          If Nvl(Row1_.Demand_Order_No, 'NULL') <> 'NULL' Then
            Open Cur2_ For
              Select t.*
                From Purchase_Order_Line_Part t
               Where t.Order_No = Row1_.Po_Order_No
                 And t.Line_No = Row1_.Po_Line_No
                 And t.Release_No = Row1_.Po_Release_No;
            Fetch Cur2_
              Into Row2_;
            If Cur2_%Found Then
              Attr_         := '';
              Transit_Attr_ := '';
              Client_Sys.Add_To_Attr('DELIVERED_QTY',
                                     Row_.Finishqty,
                                     Attr_);
              Client_Sys.Add_To_Attr('CLOSE_CODE', 'Automatic', Attr_);
              Client_Sys.Add_To_Attr('RECEIPT_DATE',
                                     To_Char(Sysdate, 'yyyy-mm-dd') ||
                                     '-00.00.00',
                                     Attr_);
              Client_Sys.Add_To_Attr('ORDER_NO', Row1_.Po_Order_No, Attr_);
              Client_Sys.Add_To_Attr('LINE_NO', Row1_.Po_Line_No, Attr_);
              Client_Sys.Add_To_Attr('RELEASE_NO',
                                     Row1_.Po_Release_No,
                                     Attr_);
              Client_Sys.Add_To_Attr('CONTRACT', Row1_.Po_Contract, Attr_);
              Client_Sys.Add_To_Attr('SUPLIER_NO',
                                     Row1_.Co_Contract,
                                     Attr_);
              Client_Sys.Add_To_Attr('PART_NO', Row_.Catalog_No, Attr_);
              Client_Sys.Add_To_Attr('UNIT_MEAS',
                                     Row_.Sales_Unit_Meas,
                                     Attr_);
              Client_Sys.Add_To_Attr('CUSTOMER_ORDER',
                                     Row1_.Demand_Order_No,
                                     Attr_);
              Client_Sys.Add_To_Attr('CUST_LINE_NO',
                                     Row1_.Demand_Line_No,
                                     Attr_);
              Client_Sys.Add_To_Attr('CUST_REL_NO',
                                     Row1_.Demand_Rel_No,
                                     Attr_);
              Client_Sys.Add_To_Attr('QTY_ON_ORDER',
                                     Row2_.Qty_On_Order,
                                     Attr_);
              Ifsapp.Purchase_Order_Line_Part_Api.Unpack_Direct_Delivery(Attr_,
                                                                         Transit_Attr_);
            Else
              Close Cur2_;
              Close Cur1_;
              Close Cur_;
              Info_ := '-1';
              Return;
            End If;
            Close Cur2_;
          End If;
          If Nvl(Row1_.Par_Demand_Order_No, 'NULL') <> 'NULL' Then
            Open Cur3_ For
              Select t.*
                From Purchase_Order_Line_Part t
               Where t.Order_No = Row1_.Par_Po_Order_No
                 And t.Line_No = Row1_.Par_Po_Line_No
                 And t.Release_No = Row1_.Par_Po_Release_No;
            Fetch Cur3_
              Into Row2_;
            If Cur3_%Found Then
              Attr_         := '';
              Transit_Attr_ := '';
              Client_Sys.Add_To_Attr('DELIVERED_QTY',
                                     Row_.Finishqty,
                                     Attr_);
              Client_Sys.Add_To_Attr('CLOSE_CODE', 'Automatic', Attr_);
              Client_Sys.Add_To_Attr('RECEIPT_DATE',
                                     To_Char(Sysdate, 'yyyy-mm-dd') ||
                                     '-00.00.00',
                                     Attr_);
              Client_Sys.Add_To_Attr('ORDER_NO',
                                     Row1_.Par_Po_Order_No,
                                     Attr_);
              Client_Sys.Add_To_Attr('LINE_NO',
                                     Row1_.Par_Po_Line_No,
                                     Attr_);
              Client_Sys.Add_To_Attr('RELEASE_NO',
                                     Row1_.Par_Po_Release_No,
                                     Attr_);
              Client_Sys.Add_To_Attr('CONTRACT',
                                     Row1_.Par_Po_Contract,
                                     Attr_);
              Client_Sys.Add_To_Attr('SUPLIER_NO',
                                     Row1_.Po_Contract,
                                     Attr_);
              Client_Sys.Add_To_Attr('PART_NO', Row_.Catalog_No, Attr_);
              Client_Sys.Add_To_Attr('UNIT_MEAS',
                                     Row_.Sales_Unit_Meas,
                                     Attr_);
              Client_Sys.Add_To_Attr('CUSTOMER_ORDER',
                                     Row1_.Par_Demand_Order_No,
                                     Attr_);
              Client_Sys.Add_To_Attr('CUST_LINE_NO',
                                     Row1_.Par_Demand_Line_No,
                                     Attr_);
              Client_Sys.Add_To_Attr('CUST_REL_NO',
                                     Row1_.Par_Demand_Rel_No,
                                     Attr_);
              Client_Sys.Add_To_Attr('QTY_ON_ORDER',
                                     Row2_.Qty_On_Order,
                                     Attr_);
              Ifsapp.Purchase_Order_Line_Part_Api.Unpack_Direct_Delivery(Attr_,
                                                                         Transit_Attr_);
            Else
              Close Cur3_;
              Close Cur1_;
              Close Cur_;
              Info_ := '-1';
              Return;
            End If;
            Close Cur3_;
          End If;
        Else
          Close Cur1_;
          Close Cur_;
          Info_ := '-2';
          Return;
        End If;
        Close Cur1_;
      End If;
      Fetch Cur_
        Into Row_;
    End Loop;
    Close Cur_;
    Return;
  End;
  Function Get_Co_Amount(Picklistno_ Varchar2, Type_ Varchar2) Return Number Is
    Cur_       t_Cursor;
    Amountsql_ Varchar2(1000);
    Amount_    Number;
    Row_       Bl_Picklist%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_Picklist t Where t.Picklistno = Picklistno_;
    Fetch Cur_
      Into Row_;
    Close Cur_;
    --折扣金额
    If Type_ = 'BL_DISCOUNT_AMOUNT' Then
      If Row_.Bflag = '0' Then
        If Row_.Flag = '2' Then
          Amountsql_ := 'round(sum(t.GROSS_CURR_AMOUNT*  (1 - (1 - T.ADDITIONAL_DISCOUNT/100)*( 1 - T.DISCOUNT/100))),2)';
        Else
          Amountsql_ := 'round(sum(T.SALE_UNIT_PRICE_WITH_TAX * T1.pickqty *  (1 - (1 - T.ADDITIONAL_DISCOUNT/100)*( 1 - T.DISCOUNT/100))),2)  ';
        End If;
      Else
        Amountsql_ := 'round(sum(T.FBUY_TAX_UNIT_PRICE * T1.pickqty *  (1 - ( 1 - T.DISCOUNT/100))),2)  ';
      End If;
    End If;
    --税款金额
    If Type_ = 'BL_TAX_AMOUNT' Then
      If Row_.Bflag = '0' Then
        If Row_.Flag = '2' Then
          Amountsql_ := 'round(sum(t.VAT_CURR_AMOUNT),2)';
        Else
          Amountsql_ := 'round(sum((T.SALE_UNIT_PRICE_WITH_TAX  -  T.SALE_UNIT_PRICE ) * T1.pickqty*(1 - T.ADDITIONAL_DISCOUNT/100)*( 1 - T.DISCOUNT/100)),2)';
        End If;
      Else
        Amountsql_ := 'round(sum((T.FBUY_TAX_UNIT_PRICE  -  T.FBUY_UNIT_PRICE ) * T1.pickqty*( 1 - T.DISCOUNT/100)),2)';
      End If;
    End If;
    --金额
    If Type_ = 'BL_AMOUNT' Then
      If Row_.Bflag = '0' Then
        If Row_.Flag = '2' Then
          Amountsql_ := 'round(sum(t.NET_CURR_AMOUNT),2)';
        Else
          Amountsql_ := 'round(sum(T.SALE_UNIT_PRICE * T1.pickqty * (1 - T.ADDITIONAL_DISCOUNT/100)*(1 - T.DISCOUNT/100)),2)';
        End If;
      Else
        Amountsql_ := 'round(sum(T.FBUY_UNIT_PRICE * T1.pickqty *(1 - T.DISCOUNT/100)),2)';
      End If;
    End If;
    --税后金额
    If Type_ = 'BL_UAMOUNT' Then
      If Row_.Bflag = '0' Then
        If Row_.Flag = '2' Then
          Amountsql_ := 'round(sum(t.GROSS_CURR_AMOUNT),2)';
        Else
          Amountsql_ := 'round(sum(T.SALE_UNIT_PRICE_WITH_TAX * T1.pickqty * (1 - T.ADDITIONAL_DISCOUNT /100)*(1 - T.DISCOUNT/100)),2)';
        End If;
      Else
        Amountsql_ := 'round(sum(T.FBUY_TAX_UNIT_PRICE * T1.pickqty * (1 - T.DISCOUNT/100)),2)';
      End If;
    End If;
    --合计预计发货
    If Type_ = 'PICKQTY' Then
      Amountsql_ := 'SUM(PICKQTY)';
    End If;
    --合计发货
    If Type_ = 'FINISHQTY' Then
      Amountsql_ := 'SUM(FINISHQTY)';
    End If;
    If Row_.Bflag = '0' Then
      If Row_.Flag = '2' Then
        -- 取发票的金额
        Amountsql_ := 'SELECT ' || Amountsql_ || ' AS ' || Type_ ||
                      ' from   CUSTOMER_ORDER_INV_ITEM T
            inner join  Bl_Plinvdtl t1 on   t.INVOICE_NO = t1.invoice_no  
                                       and  t.order_no = t1.order_no
                                       and  t.line_no = t1.line_no
                                       and  t.release_no   = t1.REL_NO
                                       and  t.line_item_no = t1.LINE_ITEM_NO
            where  t1.PICKLISTNO = ''' || Picklistno_ || '''
             and   DECODE(nvl(T.charge_seq_no, T.rma_charge_no), null, ''FALSE'', ''TRUE'')=''FALSE''';
      Else
        Amountsql_ := 'SELECT ' || Amountsql_ || ' AS ' || Type_ ||
                      ' from   customer_order_line_tab T
           inner  join bl_pldtl t1 on t.order_no = t1.order_no 
                                   and t.line_no=t1.line_no 
                                   and t.rel_no=t1.rel_no 
                                   and t.LINE_ITEM_NO= t1.LINE_ITEM_NO
            where  t1.PICKLISTNO = ''' || Picklistno_ ||
                      ''' and t1.flag<>''3''';
      End If;
    Else
      Amountsql_ := 'SELECT ' || Amountsql_ || ' AS ' || Type_ ||
                    ' from   purchase_order_line_tab T
           inner join  customer_order_line_tab  t2 on t2.demand_order_ref1 = t.order_no
                                                  and t2.demand_order_ref2 = t.line_no
                                                  and t2.demand_order_ref3 = t.RELEASE_NO
           inner  join bl_pldtl t1 on t2.order_no = t1.order_no 
                                   and t2.line_no=t1.line_no 
                                   and t2.rel_no=t1.rel_no 
                                   and t2.LINE_ITEM_NO= t1.LINE_ITEM_NO
            where  t1.PICKLISTNO = ''' || Picklistno_ ||
                    ''' and t1.flag<>''3''';
    End If;
    Open Cur_ For Amountsql_;
    Fetch Cur_
      Into Amount_;
  
    If Cur_%Notfound Then
      Amount_ := 0;
    End If;
    Close Cur_;
    Return Nvl(Amount_, 0);
  Exception
    When Others Then
      Return 0;
  End;
  Function Get_Chare_Amount(Picklistno_ In Varchar2, Type_ In Varchar2)
    Return Number Is
    Cur_       t_Cursor;
    Amountsql_ Varchar2(1000);
    Amount_    Number;
    Row_       Bl_Picklist%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_Picklist t Where t.Picklistno = Picklistno_;
    Fetch Cur_
      Into Row_;
    Close Cur_;
    If Type_ = 'BL_FEE_AMOUNT_WITH_TAX' Then
      If Row_.Bflag = '0' And Row_.Flag = '2' Then
        Amountsql_ := 'round(sum(t.GROSS_CURR_AMOUNT),2)';
      Else
        Amountsql_ := 'ROUND(SUM(charge_amount_with_tax * charged_qty), 2)';
      End If;
    End If;
    If Type_ = 'BL_FEE_AMOUNT' Then
      If Row_.Bflag = '0' And Row_.Flag = '2' Then
        Amountsql_ := 'round(sum(t.NET_CURR_AMOUNT),2)';
      Else
        Amountsql_ := 'ROUND(SUM(charge_amount * charged_qty), 2)';
      End If;
    End If;
    If Type_ = 'BL_FEE_TAX_AMOUNT' Then
      If Row_.Bflag = '0' And Row_.Flag = '2' Then
        Amountsql_ := 'round(sum(t.VAT_CURR_AMOUNT),2)';
      Else
        Amountsql_ := 'ROUND(SUM((charge_amount_with_tax - charge_amount) * charged_qty), 2)';
      End If;
    End If;
    If Row_.Bflag = '0' And Row_.Flag = '2' Then
      -- 取发票的金额
      Amountsql_ := 'SELECT ' || Amountsql_ || ' AS ' || Type_ ||
                    ' from   CUSTOMER_ORDER_INV_ITEM T
            where  (t.INVOICE_NO,t.order_no) in
            (select distinct  t1.invoice_no ,t1.order_no
               from Bl_Plinvdtl t1
              where  t1.PICKLISTNO = ''' || Picklistno_ || ''')
            and  DECODE(nvl(T.charge_seq_no, T.rma_charge_no), null, ''FALSE'', ''TRUE'')=''TRUE''';
    Else
      Amountsql_ := 'SELECT ' || Amountsql_ || ' AS ' || Type_ ||
                    ' from   CUSTOMER_ORDER_CHARGE_TAB T
              where  nvl(INVOICED_QTY,0) =0 
              and  t.order_no  in (select distinct order_no from bl_pldtl where picklistno=''' ||
                    Picklistno_ ||
                    ''' and flag <>''3'' 
                                    union select FEEORDERNO from bl_picklist where picklistno=''' ||
                    Picklistno_ || ''')';
    End If;
    Open Cur_ For Amountsql_;
    Fetch Cur_
      Into Amount_;
    If Cur_%Notfound Then
      Amount_ := 0;
    End If;
    Close Cur_;
    Return Nvl(Amount_, 0);
  Exception
    When Others Then
      Return 0;
  End;
  Procedure Set_Cancel_Reason(Rowid_    Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2) Is
    Cur_        t_Cursor;
    Picklistno_ Varchar2(20);
    Row1_       Bl_v_Picklist_Detail%Rowtype;
  Begin
    -- 删除整个单子
    Update Bl_Picklist
       Set Flag = '3', Feeorderno = ''
     Where Rowidtochar(Rowid) = Rowid_;
    -- 获取备货单号
    Select Picklistno
      Into Picklistno_
      From Bl_Picklist
     Where Rowidtochar(Rowid) = Rowid_;
    -- 更新被货单明细
    Update Bl_Pldtl Set Flag = '3' Where Picklistno = Picklistno_;
    -- 更新交货计划主档的的备货单
    Update Bl_Delivery_Plan
       Set Picklistno = ''
     Where Picklistno = Picklistno_;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PICKLIST', Rowid_);
    Return;
  End;
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2, --main 
                         Rowlist_     Varchar2, --行rowlist 
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2 --输出
                         ) Is
    Attr_Out Varchar2(4000);
    Row_     Bl_v_Bl_Picklist%Rowtype;
    Cur_     t_Cursor;
    Row1_    Bl_Ciq_Contract_Tab%Rowtype;
  Begin
    If Column_Id_ = 'DELDATE' Then
      --获取范围日期 退后7天
      Row_.Deldate := Pkg_a.Get_Item_Value('DELDATE', Rowlist_);
      Row_.Qd_Date := To_Char(To_Date(Pkg_a.Get_Item_Value('DELDATE',
                                                           Rowlist_),
                                      'yyyy-mm-dd') + 7,
                              'yyyy-mm-dd');
      Pkg_a.Set_Item_Value('DELDATE', Row_.Deldate, Attr_Out);
      Pkg_a.Set_Item_Value('QD_DATE', Row_.Qd_Date, Attr_Out);
    End If;
    If Column_Id_ = 'CONTRACT' Or Column_Id_ = 'PCONTRACT' Then
      If Column_Id_ = 'CONTRACT' Then
        Row_.Contract := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_); -- 获取默认的报关跟库位
      Else
        Row_.Contract := Pkg_a.Get_Item_Value('PCONTRACT', Rowlist_);
      End If;
      Open Cur_ For
        Select t.*
          From Bl_Ciq_Contract_Tab t
         Where t.Contract = Row_.Contract;
      Fetch Cur_
        Into Row1_;
      If Cur_%Found Then
        Row_.Ifciq     := Row1_.Ifciq;
        Row_.Ship_Type := Row1_.Shipetype;
        Pkg_a.Set_Item_Value('IFCIQ', Row_.Ifciq, Attr_Out);
        Pkg_a.Set_Item_Value('SHIP_TYPE', Row_.Ship_Type, Attr_Out);
        Row_.Location := Row1_.Outlaction;
        Pkg_a.Set_Item_Value('LOCATION', Row_.Location, Attr_Out);
        Row_.Warehouse := Ifsapp.Inventory_Location_Api.Get_Warehouse(Row_.Contract,
                                                                      Row_.Location);
        Pkg_a.Set_Item_Value('WAREHOUSE', Row_.Warehouse, Attr_Out);
      End If;
      Close Cur_;
    End If;
    If Column_Id_ = 'CUSTOMERNO' Then
      Row_.Customerno    := Pkg_a.Get_Item_Value('CUSTOMERNO', Rowlist_);
      Row_.Customer_Name := Cust_Ord_Customer_Api.Get_Name(Row_.Customerno);
      Row_.Bflag         := Pkg_a.Get_Item_Value('BFLAG', Rowlist_);
      If Row_.Bflag = '0' Then
        Pkg_a.Set_Item_Value('CUSTOMER_REF', Row_.Customerno, Attr_Out);
      End If;
      Pkg_a.Set_Item_Value('CUSTOMER_NAME', Row_.Customer_Name, Attr_Out);
    
    End If;
    If Column_Id_ = 'LOCATION' Then
      Row_.Location  := Pkg_a.Get_Item_Value('LOCATION', Rowlist_);
      Row_.Contract  := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Row_.Warehouse := Ifsapp.Inventory_Location_Api.Get_Warehouse(Row_.Contract,
                                                                    Row_.Location);
      Pkg_a.Set_Item_Value('WAREHOUSE', Row_.Warehouse, Attr_Out);
    End If;
    If Column_Id_ = 'BFLAG' Then
      Row_.Bflag := Pkg_a.Get_Item_Value('BFLAG', Rowlist_);
      If Row_.Bflag = '0' Then
        --客户订单
        Pkg_a.Set_Column_Enable('PCONTRACT', '0', Attr_Out); --不可编辑
        Pkg_a.Set_Column_Enable('PCUSTOMERNO', '0', Attr_Out);
        Pkg_a.Set_Column_Enable('CONTRACT', '1', Attr_Out); --可编辑
        Pkg_a.Set_Column_Enable('CUSTOMERNO', '1', Attr_Out);
        Pkg_a.Set_Item_Value('PCONTRACT', '', Attr_Out); --清空
        Pkg_a.Set_Item_Value('PCUSTOMERNO', '', Attr_Out); --清空
      Else
        Pkg_a.Set_Column_Enable('CONTRACT', '0', Attr_Out);
        Pkg_a.Set_Column_Enable('CUSTOMERNO', '0', Attr_Out);
        Pkg_a.Set_Column_Enable('PCONTRACT', '1', Attr_Out);
        Pkg_a.Set_Column_Enable('PCUSTOMERNO', '1', Attr_Out);
        Pkg_a.Set_Item_Value('CONTRACT', '', Attr_Out);
        Pkg_a.Set_Item_Value('CUSTOMERNO', '', Attr_Out);
      End If;
    End If;
    If Column_Id_ = 'PCONTRACT' Then
      Row_.Pcontract     := Pkg_a.Get_Item_Value('PCONTRACT', Rowlist_);
      Row_.Customerno    := Row_.Pcontract;
      Row_.Customer_Name := Cust_Ord_Customer_Api.Get_Name(Row_.Customerno);
      Pkg_a.Set_Item_Value('PCONTRACT', Row_.Pcontract, Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMERNO', Row_.Customerno, Attr_Out);
      Pkg_a.Set_Item_Value('CUSTOMER_NAME', Row_.Customer_Name, Attr_Out);
    End If;
    If Column_Id_ = 'PCUSTOMERNO' Then
      Row_.Pcustomerno := Pkg_a.Get_Item_Value('PCUSTOMERNO', Rowlist_);
      Row_.Contract    := Row_.Pcustomerno;
      Pkg_a.Set_Item_Value('PCUSTOMERNO', Row_.Pcustomerno, Attr_Out);
      Pkg_a.Set_Item_Value('CONTRACT', Row_.Contract, Attr_Out);
/*      Open Cur_ For -- 获取默认的报关跟库位 modify fjp 2013-02-26 （不能清除掉默认的库位号）
        Select t.*
          From Bl_Ciq_Contract_Tab t
         Where t.Contract = Row_.Contract;
      Fetch Cur_
        Into Row1_;
      If Cur_%Found Then
        Row_.Ifciq := Row1_.Ifciq;
        Pkg_a.Set_Item_Value('IFCIQ', Row_.Ifciq, Attr_Out);
        Row_.Location := Row1_.Inlaction;
        Pkg_a.Set_Item_Value('LOCATION', Row_.Location, Attr_Out);
        Row_.Warehouse := Ifsapp.Inventory_Location_Api.Get_Warehouse(Row_.Contract,
                                                                      Row_.Location);
        Pkg_a.Set_Item_Value('WAREHOUSE', Row_.Warehouse, Attr_Out);
      End If;
      Close Cur_;*/
    End If;
    Outrowlist_ := Attr_Out;
    Return;
  End;
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    Row_ Bl_v_Bl_Picklist%Rowtype;
  Begin
    If Column_Id_ = 'QD_DATE' Then
      Return '1';
    End If;
    If Doaction_ = 'I' Then
      If Column_Id_ = 'CONTRACT' Or Column_Id_ = 'CUSTOMERNO' Or
         Column_Id_ = 'DELDATE' Or Column_Id_ = 'CUSTOMER_REF' Or
         Column_Id_ = 'LOCATION' Or Column_Id_ = 'IFCIQ' Or
         Column_Id_ = 'REMARK' Or Column_Id_ = 'BFLAG' Or
         Column_Id_ = 'PCONTRACT' Or Column_Id_ = 'PCUSTOMERNO' Or
         Column_Id_ = 'FEEORDERNO' Or Column_Id_ = 'SHIP_TYPE' Then
        /* IF  row_.BFLAG='0' AND (column_id_='PCONTRACT' OR column_id_='PCUSTOMERNO') THEN 
              return '0';
        end if;
        IF row_.BFLAG='0' and (column_id_='CONTRACT' OR column_id_='CUSTOMERNO') THEN 
              return '0';
        END IF ;*/
        Return '1';
      End If;
    End If;
    If Doaction_ = 'M' Then
      Row_.Objid   := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
      Row_.Flag    := Pkg_a.Get_Item_Value('FLAG', Rowlist_); --  Delivered
      Row_.Recived := Pkg_a.Get_Item_Value('RECIVED', Rowlist_);
      If Row_.Flag = '0' Then
        -- 'Delivered' or row_.STATE ='Planned')   then
        If Column_Id_ = 'FEEORDERNO'
          --   or  column_id_ = 'CUSTOMER_REF'  
           Or Column_Id_ = 'LOCATION' Or Column_Id_ = 'IFCIQ' Or
           Column_Id_ = 'REMARK' Or Column_Id_ = 'SHIP_TYPE' or Column_Id_ = 'DELDATE'   Then
          Return '1';
        End If;
      End If;
      If Row_.Flag = '1' Then
        If   column_id_ = 'FEEORDERNO'   or
         Column_Id_ = 'LOCATION' Or Column_Id_ = 'REMARK' Or
         Column_Id_ = 'REL_DELIVER_DATE' Then
          Return '1';
        End If;
      End If;
      If Row_.Flag = '2' And Nvl(Row_.Recived, '0') = '0' Then
        If Column_Id_ = 'LOCATION' Or Column_Id_ = 'PICKNO' Or
           Column_Id_ = 'RECIVED_DATE' Or Column_Id_ = 'LOT_BATCH_NO' Then
          Return '1';
        End If;
      End If;
    End If;
  
    Return '0';
  
  End;
  ----检查新增 修改 
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2 Is
  Begin
    Return '1';
  End;
  Function Get_Bprdt_Column_(Picklistno_ In Varchar2, Type_ In Varchar2)
    Return Varchar2 Is
    Row_    Bl_Plinv_Reg_Dtl_Tab%Rowtype;
    Cur_    t_Cursor;
    Result_ Varchar2(100);
  Begin
    Result_ := '';
    Open Cur_ For
      Select t.*
        From Bl_Plinv_Reg_Dtl_Tab t
       Where t.Picklistno = Picklistno_;
    Fetch Cur_
      Into Row_;
    If Cur_%Found Then
      If Type_ = 'PICKNO' Then
        Result_ := Row_.Pickno;
      End If;
      If Type_ = 'LOT_BATCH_NO' Then
        Result_ := Row_.Lot_Batch_No;
      End If;
    End If;
    Close Cur_;
    Return Result_;
  End;
  --生成客户订单
  Procedure Set_Order__(Rowlist_  Varchar2,
                        User_Id_  Varchar2,
                        A311_Key_ Varchar2) Is
    Row_         Bl_v_Bl_Picklist_Po%Rowtype;
    Orow_        Bl_Customer_Order%Rowtype;
    Plrow_       Bl_v_Bl_Pldtl%Rowtype;
    Irow_        Bl_v_Customer_Order%Rowtype;
    Linerow_     Bl_v_Customer_Order_Line%Rowtype;
    Orderlist_   Varchar2(4000);
    Mainrowlist_ Varchar2(4000);
    Lnlist_      Varchar2(4000); --初始化rowlist_
    Lmlist_      Varchar2(4000); --modify  rowlist_
    Lilist_      Varchar2(4000);
    Outrowlist_  Varchar2(4000);
    Outrowlist__ Varchar2(4000);
    Outlist_     Varchar2(4000);
    Outlist__    Varchar2(4000);
    Sq_Config_   Varchar2(4000);
    Colist_      Varchar2(4000);
    Index_       Varchar(1000);
    Pos_         Number;
    Pos1_        Number;
    i            Number;
    Count_       Number;
    v_           Varchar(1000);
    Column_Id_   Varchar(1000);
    Data_        Varchar(4000);
    A311_        A311%Rowtype;
    A314_        A314%Rowtype;
    Cur_         t_Cursor;
  Begin
    Row_.Objid := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_v_Bl_Picklist_Po t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
  
    Open Cur_ For
      Select t.*
        From Bl_Customer_Order t
       Where t.Picklistno = Row_.Picklistno;
    Fetch Cur_
      Into Orow_;
    If Cur_ %Found Then
      Close Cur_;
      Raise_Application_Error(-20101, '已经存在客户订单');
      Return;
    End If;
    Close Cur_;
    --生成客户订单主档
    Select s_A314.Nextval Into A314_.A314_Key From Dual;
    Insert Into A314
      (A314_Key, A314_Id, State, Enter_User, Enter_Date)
      Select A314_.A314_Key, A314_.A314_Key, '0', User_Id_, Sysdate
        From Dual;
    Bl_Customer_Order_Api.New__('', User_Id_, A314_.A314_Key);
  
    Select t.Res
      Into Sq_Config_
      From A314 t
     Where t.A314_Key = A314_.A314_Key
       And Rownum = 1;
    Pkg_a.Str_Add_Str(Orderlist_, Sq_Config_);
    Pkg_a.Set_Item_Value('CONTRACT', Row_.Pcontract, Orderlist_);
    Pkg_a.Set_Item_Value('CUSTOMER_NO', Row_.Customer_Ref, Orderlist_);
    Pkg_a.Set_Item_Value('BLLOCATION_NO', Row_.Location, Orderlist_);
    Bl_Customer_Order_Api.Itemchange__('CUSTOMER_NO',
                                       '',
                                       Orderlist_,
                                       User_Id_,
                                       Outrowlist_);
    A311_.A311_Id    := 'bl_pick_order_api.SET_ORDER__';
    A311_.Enter_User := User_Id_;
    A311_.A014_Id    := 'A014_ID=SAVE';
    A311_.Table_Id   := 'BL_V_BL_PICKLIST_PO';
    Pkg_a.Beginlog(A311_);
    Pkg_a.Str_Add_Str(Outrowlist_, Orderlist_);
    Pkg_a.Set_Item_Value('DOACTION', 'I', Outrowlist_);
    Pkg_a.Set_Item_Value('OBJID', '', Outrowlist_);
    Pkg_a.Set_Item_Value('PICKLISTNO', Row_.Picklistno, Outrowlist_);
    Bl_Customer_Order_Api.Modify__(Outrowlist_, User_Id_, A311_.A311_Key);
    Open Cur_ For
      Select t.* From A311 t Where t.A311_Key = A311_.A311_Key;
    Fetch Cur_
      Into A311_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, 'SET_ORDER__处理失败');
      Return;
    End If;
    Close Cur_;
  
    Open Cur_ For
      Select t.*
        From Bl_v_Customer_Order t
       Where t.Objid = A311_.Table_Objid;
    Fetch Cur_
      Into Irow_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, 'SET_ORDER__处理失败');
      Return;
    End If;
    Close Cur_;
  
    --生成客户订单明细
    Pkg_a.Set_Item_Value('ORDER_NO', Irow_.Order_No, Lnlist_);
    Pkg_a.Set_Item_Value('LINE_ITEM_NO', '0', Lnlist_);
    Pkg_a.Get_Row_Str('BL_V_CUSTOMER_ORDER',
                      ' AND ORDER_NO=''' || Irow_.Order_No || '''',
                      Mainrowlist_);
  
    Select s_A314.Nextval Into A314_.A314_Key From Dual;
    Insert Into A314
      (A314_Key, A314_Id, State, Enter_User, Enter_Date)
      Select A314_.A314_Key, A314_.A314_Key, '0', User_Id_, Sysdate
        From Dual;
  
    Bl_Customer_Order_Line_Api.New__(Lnlist_, User_Id_, A314_.A314_Key);
    Sq_Config_ := '';
    Select t.Res
      Into Sq_Config_
      From A314 t
     Where t.A314_Key = A314_.A314_Key
       And Rownum = 1;
    Index_ := f_Get_Data_Index();
    Data_  := Sq_Config_;
    Pos_   := Instr(Data_, Index_);
    i      := i + 1;
    Loop
      Exit When Nvl(Pos_, 0) <= 0;
      Exit When i > 300;
      v_         := Substr(Data_, 1, Pos_ - 1);
      Data_      := Substr(Data_, Pos_ + 1);
      Pos_       := Instr(Data_, Index_);
      Pos1_      := Instr(v_, '|');
      Column_Id_ := Substr(v_, 1, Pos1_ - 1);
      v_         := Substr(v_, Pos1_ + 1);
      Select Count(*)
        Into Count_
        From A10001 t
       Where t.Table_Id = 'BL_V_CUSTOMER_ORDER_LINE'
         And t.Column_Id = Column_Id_;
      If Count_ = 1 Then
        Pkg_a.Set_Item_Value(Column_Id_, v_, Lilist_);
      End If;
    End Loop;
  
    Pkg_a.Str_Add_Str(Lilist_, Lnlist_);
  
    Open Cur_ For
      Select t.* From Bl_v_Bl_Pldtl t Where t.Picklistno = Row_.Picklistno;
    Fetch Cur_
      Into Plrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的补货备货单明细行');
      Return;
    End If;
    Loop
      Exit When Cur_ %Notfound;
      Lmlist_ := '';
      Pkg_a.Set_Item_Value('DOACTION', 'I', Lmlist_);
      Pkg_a.Set_Item_Value('OBJID', Null, Lmlist_);
      Pkg_a.Str_Add_Str(Lmlist_, Lilist_);
      Pkg_a.Set_Item_Value('CATALOG_NO', Plrow_.Catalog_No, Lmlist_);
      Pkg_a.Set_Item_Value('BUY_QTY_DUE', Plrow_.Finishqty, Lmlist_);
      Bl_Customer_Order_Line_Api.Itemchange__('CATALOG_NO',
                                              Mainrowlist_,
                                              Lmlist_,
                                              User_Id_,
                                              Outrowlist__);
    
      Pkg_a.Str_Add_Str(Lmlist_, Outrowlist__);
      Outrowlist__ := '';
      Bl_Customer_Order_Line_Api.Itemchange__('BUY_QTY_DUE',
                                              Mainrowlist_,
                                              Lmlist_,
                                              User_Id_,
                                              Outrowlist__);
      Pkg_a.Str_Add_Str(Lmlist_, Outrowlist__);
    
      Pkg_a.Set_Item_Value('SUPPLY_CODE', 'Invent Order', Lmlist_);
    
      Bl_Customer_Order_Line_Api.Modify__(Lmlist_,
                                          User_Id_,
                                          A311_.A311_Key);
      Fetch Cur_
        Into Plrow_;
    End Loop;
    Close Cur_;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PICKLIST_PO', Row_.Objid);
    Pkg_a.Setmsg(A311_Key_, '', '生成客户单' || Irow_.Order_No || '成功');
  
    -- Bl_Customer_Order_Api.New__()
  End;
  Function Get_Piurl(Picklistno_ Varchar2, Type_ Varchar2) Return Varchar2 Is
    Cur_    t_Cursor;
    Row_    Bl_Picihead%Rowtype;
    Result_ Varchar2(100);
  Begin
    Open Cur_ For
      Select t.* From Bl_Picihead t Where Invoice_No = Picklistno_;
    Fetch Cur_
      Into Row_;
    If Cur_%Found Then
      Result_ := 'MainForm.aspx?TYPE=' || Type_ || '&A002KEY=900301&key=' ||
                 Picklistno_ || '&option=M&plno=' || Picklistno_;
    Else
      Result_ := 'MainForm.aspx?Isave=1&TYPE=' || Type_ ||
                 '&A002KEY=900301&key=&option=I&plno=' || Picklistno_;
    End If;
    Close Cur_;
    Return Result_;
  End;
  --获取新备货单号  2011-12-14  zhangyuanbao   作废2013-02-25
  Function Get_New_Picklistno(Yearno_ In Varchar2, Customerno_ In Varchar2)
    Return Varchar As
    s_New_Picklistno Varchar2(10);
  
    Cursor Get_v_New_Picklistno Is
      Select Max(t.Picklistno) Picklistno
        From Bl_Plblser t
       Where t.Customerno = Customerno_
         And t.Yearno = Yearno_;
  Begin
    Open Get_v_New_Picklistno;
    Fetch Get_v_New_Picklistno
      Into s_New_Picklistno;
    Close Get_v_New_Picklistno;
  
    If s_New_Picklistno Is Null Then
      Return '1';
    Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) = 57 And
          Ascii(Substr(s_New_Picklistno, 2, 1)) = 57 And
          Ascii(Substr(s_New_Picklistno, 1, 1)) = 57 Then
      --999
      Return '99A';
    Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) > 57 And
          Ascii(Substr(s_New_Picklistno, 3, 1)) < 90 And
          Ascii(Substr(s_New_Picklistno, 2, 1)) = 57 And
          Ascii(Substr(s_New_Picklistno, 1, 1)) = 57 Then
      --99A
      Return '99' || Chr(Ascii(Substr(s_New_Picklistno, 3, 1)) + 1);
    Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) = 90 And
          Ascii(Substr(s_New_Picklistno, 2, 1)) = 57 And
          Ascii(Substr(s_New_Picklistno, 1, 1)) = 57 Then
      --99Z
      Return '9AA';
    Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) > 57 And
          Ascii(Substr(s_New_Picklistno, 3, 1)) < 90 And
          Ascii(Substr(s_New_Picklistno, 2, 1)) > 57 And
          Ascii(Substr(s_New_Picklistno, 1, 1)) = 57 Then
      --9AA
      Return Substr(s_New_Picklistno, 1, 2) || Chr(Ascii(Substr(s_New_Picklistno,
                                                                3,
                                                                1)) + 1);
    Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) = 90 And
          Ascii(Substr(s_New_Picklistno, 2, 1)) > 57 And
          Ascii(Substr(s_New_Picklistno, 2, 1)) < 90 And
          Ascii(Substr(s_New_Picklistno, 1, 1)) = 57 Then
      --9AZ
      Return '9' || Chr(Ascii(Substr(s_New_Picklistno, 2, 1)) + 1) || 'A';
    Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) = 90 And
          Ascii(Substr(s_New_Picklistno, 2, 1)) = 90 And
          Ascii(Substr(s_New_Picklistno, 1, 1)) = 57 Then
      --9ZZ
      Return 'AAA';
    Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) > 57 And
          Ascii(Substr(s_New_Picklistno, 3, 1)) < 90 And
          Ascii(Substr(s_New_Picklistno, 2, 1)) > 57 And
          Ascii(Substr(s_New_Picklistno, 1, 1)) > 57 Then
      --AAA
      Return Substr(s_New_Picklistno, 1, 2) || Chr(Ascii(Substr(s_New_Picklistno,
                                                                3,
                                                                1)) + 1);
    Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) = 90 And
          Ascii(Substr(s_New_Picklistno, 2, 1)) > 57 And
          Ascii(Substr(s_New_Picklistno, 2, 1)) < 90 And
          Ascii(Substr(s_New_Picklistno, 1, 1)) > 57 Then
      --AAZ
      Return Substr(s_New_Picklistno, 1, 1) || Chr(Ascii(Substr(s_New_Picklistno,
                                                                2,
                                                                1)) + 1) || 'A';
    Elsif Ascii(Substr(s_New_Picklistno, 3, 1)) = 90 And
          Ascii(Substr(s_New_Picklistno, 2, 1)) = 90 And
          Ascii(Substr(s_New_Picklistno, 1, 1)) > 57 Then
      --AZZ
      Return Chr(Ascii(Substr(s_New_Picklistno, 1, 1)) + 1) || 'AA';
    Else
      Return To_Char(To_Number(s_New_Picklistno) + 1);
    End If;
  End Get_New_Picklistno;
End Bl_Pick_Order_Api;
/
