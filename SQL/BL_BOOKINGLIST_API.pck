CREATE OR REPLACE Package Bl_Bookinglist_Api Is

  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);
  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);

  Procedure Confirm__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --取消下达                  
  Procedure Confirmcancel__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2);
  --确认船期                  
  Procedure Confirm_Sail__(Rowid_    Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2);
  Procedure Deny__(Rowlist_  Varchar2,
                   User_Id_  Varchar2,
                   A311_Key_ Varchar2);
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2);
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2;
  --获取编码
  Procedure Get_Booking_No(Seq_ Out Varchar2);
  Procedure Close__(Rowlist_  Varchar2,
                    User_Id_  Varchar2,
                    A311_Key_ Varchar2);
  --获取备货单号 2013-01-31
  Function Get_Picklistno(Booking_No_ Varchar2) Return Varchar2;

End Bl_Bookinglist_Api;
/
CREATE OR REPLACE Package Body Bl_Bookinglist_Api Is

/*Created By LONG  2012-11-26 14:22:46*/
  Type t_Cursor Is Ref Cursor;
  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键
  modify fjp 2012-01-24 从pi中选择，
  选择一个pi保存的时候自动在明细中新增一条保存记录
  modify fjp 2013-01-31 增加一个报表bl_bookinglist_report获取发票号的函数 
  modify fjp 2013-02-01 增加一个递送日期的控制，关闭的时候更新
  modify fjp 2013-02-04 确定船期更改备货单船期更改发票日期
  modify fjp 2013-02-26 如果确认船期就不能修改实际船期 */
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
    Attr_Out Varchar2(4000);
    Row_     Bl_v_Bookinglist%Rowtype;
  
  Begin
    --获取用户默认的域
  
    Attr_Out := Pkg_a.Get_Attr_By_Bm(Rowlist_);
    Pkg_a.Set_Item_Value('ENTER_USER', User_Id_, Attr_Out);
    Pkg_a.Set_Item_Value('ENTER_DATE',
                         To_Char(Sysdate, 'yyyy-mm-dd'),
                         Attr_Out);
    /*
    ROW_.CONTRACT := PKG_ATTR.GET_DEFAULT_CONTRACT(USER_ID_);
    
    IF (NVL(ROW_.CONTRACT, '0') <> '0') THEN
      PKG_A.SET_ITEM_VALUE('CONTRACT', ROW_.CONTRACT, ATTR_OUT);
      PKG_A.SET_ITEM_VALUE('STATE', '0', ATTR_OUT);
    END IF;
    
    open cur_ for
    select  t.*
    from bl_ciq_contract_tab t
    where t.contract = row_.CONTRACT;
    fetch cur_ into row1_;
    if cur_%found then 
        row_.IFCIQ := row1_.ifciq;
        pkg_a.Set_Item_Value('IFCIQ',row_.IFCIQ,attr_out);
        row_.LOCATION := row1_.outlaction;
        pkg_a.Set_Item_Value('LOCATION',row_.LOCATION,attr_out);
        row_.WAREHOUSE := IFSAPP.INVENTORY_LOCATION_API.Get_Warehouse(row_.CONTRACT, row_.LOCATION);
        pkg_a.Set_Item_Value('WAREHOUSE',row_.WAREHOUSE,attr_out);
    end if ;
    close cur_;
    */
    Pkg_a.Setresult(A311_Key_, Attr_Out);
    Return;
  End;
  --右键取消功能--
  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Info_ Varchar2(4000);
    Row_  Bl_v_Bookinglist%Rowtype;
    Cur_  t_Cursor;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Bookinglist t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
  
    ---判断状态
    If Row_.State >= '1' Then
      Pkg_a.Setmsg(A311_Key_,
                   '',
                   '退货申请' || Row_.Booking_No || '已下达，不可取消');
      Return;
    End If;
  
    Update Bl_v_Bookinglist Set State = '3' Where Rowid = Row_.Objid;
  
    --raise_application_error(-20101, '已经移库不能取消登记到达！');
    --return ;                                             
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BOOKINGLIST', Row_.Objid);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '退货申请' || Row_.Booking_No || '取消成功！');
    Return;
  End;

  --右键关闭功能--
  Procedure Close__(Rowlist_  Varchar2,
                    User_Id_  Varchar2,
                    A311_Key_ Varchar2) Is
    Info_ Varchar2(4000);
    Row_  Bl_v_Bookinglist%Rowtype;
    Row1_ Bl_v_Bookinglist_Bl%Rowtype;
    Cur_  t_Cursor;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Bookinglist t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
  
    ---判断状态
    If Row_.State <> '2' Then
      Pkg_a.Setmsg(A311_Key_,
                   '',
                   '退货申请' || Row_.Booking_No || '未下达或已关闭，不可关闭');
      Return;
    End If;
  
    --更新相同的订舱递送日期 modify fjp 2013-02-01
    Update Bl_Bookinglist
       Set Dsdate = Row_.Dsdate
     Where Booking_No In
           (Select Bk_No
              From Bl_Bookinglist_Bl
             Where Booking_No = Row_.Booking_No);
    --end
    Update Bl_v_Bookinglist Set State = '4' Where Rowid = Row_.Objid;
  
    Update Bl_Transport_Note
       Set State = '4'
     Where Booking_No = Row_.Booking_No;
  
    Update Bl_Transport_Notedtl
       Set State = '4'
     Where Note_No = (Select Note_No
                        From Bl_Transport_Note
                       Where Booking_No = Row_.Booking_No);
  
    Update Bl_v_Transport_Notecontract
       Set State = '4'
     Where Note_No = (Select Note_No
                        From Bl_Transport_Note
                       Where Booking_No = Row_.Booking_No);
  
    --raise_application_error(-20101, '已经移库不能取消登记到达！');
    --return ;                                             
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_BOOKINGLIST', Row_.Objid);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '退货申请' || Row_.Booking_No || '关闭成功！');
    Return;
  End;

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
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
    Row_       Bl_v_Bookinglist%Rowtype;
    Cur_       t_Cursor;
    Ll_Count_  Number;
  Begin
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    If Doaction_ = 'I' Then
      --  获取值
      Get_Booking_No(Row_.Booking_No);
      Row_.Lto          := Pkg_a.Get_Item_Value('LTO', Rowlist_);
      Row_.Pisel        := Pkg_a.Get_Item_Value('PISEL', Rowlist_);
      Row_.Lfrom        := Pkg_a.Get_Item_Value('LFROM', Rowlist_);
      Row_.Informant    := Pkg_a.Get_Item_Value('INFORMANT', Rowlist_);
      Row_.Exitport     := Pkg_a.Get_Item_Value('EXITPORT', Rowlist_);
      Row_.Aimport      := Pkg_a.Get_Item_Value('AIMPORT', Rowlist_);
      Row_.Transport    := Pkg_a.Get_Item_Value('TRANSPORT', Rowlist_);
      Row_.Shipby       := Pkg_a.Get_Item_Value('SHIPBY', Rowlist_);
      Row_.Shipment     := Pkg_a.Get_Item_Value('SHIPMENT', Rowlist_);
      Row_.Attansport   := Pkg_a.Get_Item_Value('ATTANSPORT', Rowlist_);
      Row_.Atyuport     := Pkg_a.Get_Item_Value('ATYUPORT', Rowlist_);
      Row_.Ataivport    := Pkg_a.Get_Item_Value('ATAIVPORT', Rowlist_);
      Row_.Countmilers  := Pkg_a.Get_Item_Value('COUNTMILERS', Rowlist_);
      Row_.Contdays     := Pkg_a.Get_Item_Value('CONTDAYS', Rowlist_);
      Row_.Dsdate       := Pkg_a.Get_Item_Value('DSDATE', Rowlist_);
      Row_.Remark       := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      Row_.State        := '0';
      Row_.Booking_Type := Pkg_a.Get_Item_Value('BOOKING_TYPE', Rowlist_);
      Row_.Pickno_Tran  := Pkg_a.Get_Item_Value('PICKNO_TRAN', Rowlist_);
      Row_.Pickno_Type  := Pkg_a.Get_Item_Value('PICKNO_TYPE', Rowlist_);
      Row_.Credit_No    := Pkg_a.Get_Item_Value('CREDIT_NO', Rowlist_);
      Row_.Vendor_No    := Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_);
      Row_.Contact_No   := Pkg_a.Get_Item_Value('CONTACT_NO', Rowlist_);
      Row_.Contact      := Pkg_a.Get_Item_Value('CONTACT', Rowlist_);
      Row_.Contacttel   := Pkg_a.Get_Item_Value('CONTACTTEL', Rowlist_);
      Row_.Contactfex   := Pkg_a.Get_Item_Value('CONTACTFEX', Rowlist_);
      Row_.Contactphn   := Pkg_a.Get_Item_Value('CONTACTPHN', Rowlist_);
      Row_.Send_Date    := To_Date(Pkg_a.Get_Item_Value('SEND_DATE',
                                                        Rowlist_),
                                   'yyyy-mm-dd');
      Row_.Post_Type    := Pkg_a.Get_Item_Value('POST_TYPE', Rowlist_);
      Row_.Post_Remark  := Pkg_a.Get_Item_Value('POST_REMARK', Rowlist_);
      Row_.Atl_Reamerk  := Pkg_a.Get_Item_Value('ATL_REAMERK', Rowlist_);
      Row_.Shippingmark := Pkg_a.Get_Item_Value('SHIPPINGMARK', Rowlist_);
      Row_.Shipdate     := To_Date(Pkg_a.Get_Item_Value('SHIPDATE',
                                                        Rowlist_),
                                   'yyyy-mm-dd');
      Select Sysdate - Row_.Shipdate Into Ll_Count_ From Dual;
      If Ll_Count_ < 0 Then
        Raise_Application_Error(-20101, '实际船期不能大于当前日期');
      End If;
      Row_.Lfromadd := Pkg_a.Get_Item_Value('LFROMADD', Rowlist_);
      Row_.Lfromtel := Pkg_a.Get_Item_Value('LFROMTEL', Rowlist_);
      Row_.Lfromfax := Pkg_a.Get_Item_Value('LFROMFAX', Rowlist_);
      --收货人
      Row_.Lfromop := Pkg_a.Get_Item_Value('LFROMOP', Rowlist_);
      Row_.Ltoadd  := Pkg_a.Get_Item_Value('LTOADD', Rowlist_);
      Row_.Ltoman  := Pkg_a.Get_Item_Value('LTOMAN', Rowlist_);
      Row_.Ltotel  := Pkg_a.Get_Item_Value('LTOTEL', Rowlist_);
      Row_.Ltofax  := Pkg_a.Get_Item_Value('LTOFAX', Rowlist_);
      Row_.Ltomail := Pkg_a.Get_Item_Value('LTOMAIL', Rowlist_);
      --通知人
      Row_.Infoop   := Pkg_a.Get_Item_Value('INFOOP', Rowlist_);
      Row_.Infoadd  := Pkg_a.Get_Item_Value('INFOADD', Rowlist_);
      Row_.Infoman  := Pkg_a.Get_Item_Value('INFOMAN', Rowlist_);
      Row_.Infotel  := Pkg_a.Get_Item_Value('INFOTEL', Rowlist_);
      Row_.Infofax  := Pkg_a.Get_Item_Value('INFOFAX', Rowlist_);
      Row_.Infomail := Pkg_a.Get_Item_Value('INFOMAIL', Rowlist_);
      --唛头
      Row_.Shippingmark1 := Pkg_a.Get_Item_Value('SHIPPINGMARK1', Rowlist_);
      Row_.Shippingmark2 := Pkg_a.Get_Item_Value('SHIPPINGMARK2', Rowlist_);
      Row_.Shippingmark3 := Pkg_a.Get_Item_Value('SHIPPINGMARK3', Rowlist_);
      Row_.Shippingmark4 := Pkg_a.Get_Item_Value('SHIPPINGMARK4', Rowlist_);
      /*
      ROW_.ENTER_DATE  := PKG_A.GET_ITEM_VALUE('ENTER_DATE', ROWLIST_);
      ROW_.ENTER_USER  := PKG_A.GET_ITEM_VALUE('ENTER_USER', ROWLIST_);
      ROW_.MODI_USER   := PKG_A.GET_ITEM_VALUE('MODI_USER', ROWLIST_);
      ROW_.MODI_DATE   := PKG_A.GET_ITEM_VALUE('MODI_DATE', ROWLIST_);
      */
      --到付预付
      Row_.Carriage := Pkg_a.Get_Item_Value('CARRIAGE', Rowlist_);
      row_.CONTAINER_TYPE := pkg_a.Get_Item_Value('CONTAINER_TYPE',Rowlist_);
      -- 创建给一个默认值
      --row_.CREATEDATE:=to_char(sysdate,'yyyy-mm-dd');--pkg_a.Get_Item_Value('CREATEDATE',ROWLIST_ );
    
      --插入数据
      Insert Into Bl_Bookinglist
        (Booking_No,
         Lto,
         Lfrom,
         Informant,
         Exitport,
         Aimport,
         Transport,
         Shipby,
         Shipment,
         Attansport,
         Atyuport,
         Ataivport,
         Countmilers,
         Contdays,
         Dsdate,
         Remark,
         State,
         Enter_Date,
         Enter_User,
         Modi_User,
         Modi_Date,
         Booking_Type,
         Pickno_Tran,
         Pickno_Type,
         Credit_No,
         Vendor_No,
         Contact_No,
         Contact,
         Contacttel,
         Contactfex,
         Contactphn,
         Send_Date,
         Post_Type,
         Post_Remark,
         Atl_Reamerk,
         Shippingmark,
         Shipdate,
         Picklistno,
         Lfromadd,
         Lfromtel,
         Lfromfax,
         Lfromop,
         Ltoadd,
         Ltoman,
         Ltotel,
         Ltofax,
         Ltomail,
         Infoop,
         Infoadd,
         Infoman,
         Infotel,
         Infofax,
         Infomail,
         Shippingmark1,
         Shippingmark2,
         Shippingmark3,
         Shippingmark4,
         Carriage,
         CONTAINER_TYPE)
      Values
        (Row_.Booking_No,
         Row_.Lto,
         Row_.Lfrom,
         Row_.Informant,
         Row_.Exitport,
         Row_.Aimport,
         Row_.Transport,
         Row_.Shipby,
         Row_.Shipment,
         Row_.Attansport,
         Row_.Atyuport,
         Row_.Ataivport,
         Row_.Countmilers,
         Row_.Contdays,
         Row_.Dsdate,
         Row_.Remark,
         Row_.State,
         Sysdate,
         User_Id_,
         Null,
         Null,
         Row_.Booking_Type,
         Row_.Pickno_Tran,
         Row_.Pickno_Type,
         Row_.Credit_No,
         Row_.Vendor_No,
         Row_.Contact_No,
         Row_.Contact,
         Row_.Contacttel,
         Row_.Contactfex,
         Row_.Contactphn,
         Row_.Send_Date,
         Row_.Post_Type,
         Row_.Post_Remark,
         Row_.Atl_Reamerk,
         Row_.Shippingmark,
         Row_.Shipdate,
         Row_.Pisel,
         Row_.Lfromadd,
         Row_.Lfromtel,
         Row_.Lfromfax,
         Row_.Lfromop,
         Row_.Ltoadd,
         Row_.Ltoman,
         Row_.Ltotel,
         Row_.Ltofax,
         Row_.Ltomail,
         Row_.Infoop,
         Row_.Infoadd,
         Row_.Infoman,
         Row_.Infotel,
         Row_.Infofax,
         Row_.Infomail,
         Row_.Shippingmark1,
         Row_.Shippingmark2,
         Row_.Shippingmark3,
         Row_.Shippingmark4,
         Row_.Carriage,
         row_.CONTAINER_TYPE)
      Returning Rowid Into Objid_;
    
      /*      SELECT T.ROWID
       INTO OBJID_
       FROM BL_BOOKINGLIST T
      WHERE T.BOOKING_NO = ROW_.BOOKING_NO;*/
      ---插入明细的备货单
      Insert Into Bl_Bookinglist_Dtl
        (Booking_No, Picklistno, State)
      Values
        (Row_.Booking_No, Row_.Pisel, '0');
      Pkg_a.Setsuccess(A311_Key_, 'BL_BOOKINGLIST', Objid_);
      Return;
    End If;
    If Doaction_ = 'M' Then
      -- 更改数据
      Open Cur_ For
        Select t.* From Bl_v_Bookinglist t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '错误的rowid');
        Return;
        /*
        ELSE
          IF ROW_.STATE > 0 THEN
            PKG_A.SETMSG(A311_KEY_,
                         '',
                         '订舱委托' || ROW_.BOOKING_NO || '已确认，不可修改');
            CLOSE CUR_;
            RETURN;
          END IF;
          */
      End If;
    
      Close Cur_;
    
      Data_ := Rowlist_;
    
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := ' update BL_BOOKINGLIST set ';
      Ifmychange := '0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' AND Column_Id_ <> 'ROWTYPE'  And
           Column_Id_ <> 'EXITPORTDESC' And Column_Id_ <> 'AIMPORTDESC' And
           Column_Id_ <> 'PISEL' And Column_Id_ <> 'SHIPBYDESC' And
           Column_Id_ <> 'VENDOR_DESC' And Length(Nvl(Column_Id_, '')) > 0 Then
          v_ := Substr(v_, Pos1_ + 1);
          i  := i + 1;
        
          Ifmychange := '1';
          If Column_Id_ = 'ENTER_DATE' Or Column_Id_ = 'SHIPTIME' Or
             Column_Id_ = 'MODI_DATE' Or Column_Id_ = 'SHIPDATE' Or
             Column_Id_ = 'SEND_DATE' Then
            --实际船期不能大于当前日期 modify fjp 2013-02-04
            If Column_Id_ = 'SHIPDATE' Then
              Select Sysdate - To_Date(v_, 'yyyy-mm-dd')
                Into Ll_Count_
                From Dual;
              If Ll_Count_ < 0 Then
                Raise_Application_Error(-20101, '实际船期不能大于当前日期');
              End If;
            End If;
            Mysql_ := Mysql_ || ' ' || Column_Id_ || '=to_date(''' || v_ ||
                      ''',''YYYY-MM-DD HH24:MI:SS''),';
          Else
            --如果明细有订舱单，不能修改递送日期为空 modify fjp 2013-02-01
            If Column_Id_ = 'DSDATE' And Nvl(v_, 'NULL') = 'NULL' Then
              Select Count(*)
                Into Ll_Count_
                From Bl_Bookinglist_Bl
               Where Booking_No = Row_.Booking_No;
              If Ll_Count_ > 0 Then
                Raise_Application_Error(-20101,
                                        '订舱中有单据不能取消递送日期!');
              End If;
            End If;
            if instr(v_,'''') > 0 then
                 v_ := v_||'''';
            end if ;
            Mysql_ := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
          End If;
        End If;
      End Loop;
      If Ifmychange = '1' Then
        -- 更新sql语句 
        Mysql_ := Substr(Mysql_, 1, Length(Mysql_) - 1);
       -- Raise_Application_Error(-20101, Mysql_);
        --MYSQL_ := MYSQL_ || ' where rowidtochar(rowid)=''' || OBJID_ || '''';
        --EXECUTE IMMEDIATE MYSQL_;
      
        Mysql_ := Mysql_ || ',modi_date=sysdate,modi_user=''' || User_Id_ ||
                  ''' where rowidtochar(rowid)=''' || Objid_ || '''';
      
        --RAISE_APPLICATION_ERROR(-20101, '错误的rowid=' || MYSQL_);
        Execute Immediate 'begin ' || Mysql_ || ';end;';
      
      End If;
      Pkg_a.Setsuccess(A311_Key_, 'BL_BOOKINGLIST', Objid_);
      Return;
    End If;
  End;

  Procedure Confirm__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
    Row_   Bl_v_Bookinglist%Rowtype;
    Cur_   t_Cursor;
    Count_ Number;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Bookinglist t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Pkg_a.Setfailed(A311_Key_, 'BL_BOOKINGLIST', Rowlist_);
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
    --如果预计船期为空则不能下达
    If Nvl(Row_.Shipment, 'NULL') = 'NULL' Then
      Raise_Application_Error(-20101, '预计船期不能为空');
    End If;
    --检查订舱委托是不是有明细--
    Select Count(*)
      Into Count_
      From Bl_Bookinglist_Dtl t
     Where t.Booking_No = Row_.Booking_No;
    If Count_ = 0 Then
      Raise_Application_Error(-20101, '没有明细');
    
    End If;
  
    Update Bl_Bookinglist Set State = '1' Where Rowid = Row_.Objid;
    Update Bl_Bookinglist_Dtl
       Set State = '1'
     Where Booking_No = Row_.Booking_No;
    Pkg_a.Setmsg(A311_Key_, '', '订舱委托下达成功');
  
    Return;
  End;
  Procedure Confirmcancel__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2) Is
    Row_ Bl_v_Bookinglist%Rowtype;
    Cur_ t_Cursor;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Bookinglist t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Pkg_a.Setfailed(A311_Key_, 'BL_BOOKINGLIST', Rowlist_);
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
  
    Update Bl_Bookinglist Set State = '0' Where Rowid = Row_.Objid;
    Update Bl_Bookinglist_Dtl
       Set State = '0'
     Where Booking_No = Row_.Booking_No;
    Pkg_a.Setmsg(A311_Key_, '', '订舱委托取消下达成功');
    Return;
  End;
  --确定船期 2013-02-04
  Procedure Confirm_Sail__(Rowid_    Varchar2,
                           User_Id_  Varchar2,
                           A311_Key_ Varchar2) Is
    Row_         Bl_v_Bookinglist%Rowtype;
    Cur_         t_Cursor;
    Cur1_        t_Cursor;
    Company_     Varchar2(10);
    Ship_Period_ Varchar2(10);
    Sys_Period_  Varchar2(10);
    Start_Date_  Date;
    Invoice_No_  Varchar2(50);
    Row1_        Cust_Invoice_Pub_Util_Head%Rowtype;
    Info_        Varchar2(4000);
    Attr_        Varchar2(4000);
    Action_      Varchar2(10);
    Ll_Count_    Number;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Bookinglist t Where t.Objid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Pkg_a.Setfailed(A311_Key_, 'BL_BOOKINGLIST', Rowid_);
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    If Row_.Shipdate Is Null Then
      Raise_Application_Error(-20101, '请输入实际船期');
    End If;
    If Nvl(Row_.Pisel, 'NULL') = 'NULL' Then
      Raise_Application_Error(-20101, '请录入备货单号');
    End If;
    Open Cur_ For
      Select Site_Api.Get_Company(Contract)
        From Bl_Picklist
       Where Pickuniteno = Row_.Pisel;
    Fetch Cur_
      Into Company_;
    Close Cur_;
    If Company_ Is Null Then
      Company_ := '20';
    End If;
    Open Cur_ For
      Select Acc_Year || '-' || Acc_Period,
             Start_Date,
             (Select Acc_Year || '-' || Acc_Period
                From Bl_Accounting_Period_Tab
               Where Company = Company_
                 And Row_.Shipdate >= Start_Date
                 And Row_.Shipdate <= End_Date
                 And Rownum = 1)
        From Bl_Accounting_Period_Tab t
       Where Company = Company_
         And Sysdate >= Start_Date
         And Sysdate <= End_Date;
    Fetch Cur_
      Into Sys_Period_, Start_Date_, Ship_Period_;
    Close Cur_;
    If Nvl(Sys_Period_, 'NULL') = 'NULL' Then
      Raise_Application_Error(-20101, '未取得系统的会计期间');
    End If;
    --比较操作日期跟船期是否是同一个会计期间
    If Sys_Period_ = Ship_Period_ Then
      Start_Date_ := Row_.Shipdate;
    End If;
    --检测备货单的状态是否发货
    Select Count(*)
      Into Ll_Count_
      From Bl_Picklist
     Where Pickuniteno In (Select Picklistno
                             From Bl_Bookinglist_Dtl t
                            Where t.Booking_No = Row_.Booking_No
                              And State = '2')
       And Flag In ('0', '1');
    If Ll_Count_ > 0 Then
      Raise_Application_Error(-20101, '备货单存在未发货的不能确认船期');
      Return;
    End If;
    -- 更新备货单的船期
    Update Bl_Picklist
       Set Shipdate      = To_Char(Row_.Shipdate, 'yyyy-mm-dd'),
           Issure        = '1',
           Date_Sure     = Start_Date_,
           Sure_Shipdate = Sysdate
     Where Pickuniteno In (Select Picklistno
                             From Bl_Bookinglist_Dtl t
                            Where t.Booking_No = Row_.Booking_No
                              And State = '2');
     update Bl_Ciq_Head_Tab
        set Ciq_State = 5,
            Date_Ship = Row_.Shipdate,
            Date_Sure = Start_Date_,
            Sure_Shipdate = Sysdate
     where  PICKLISTNO  In (Select Picklistno
                             From Bl_Bookinglist_Dtl t
                             Where t.Booking_No = Row_.Booking_No
                              And State = '2');
                            
    --更新发票的时间
    Open Cur_ For
      Select Distinct t.Invoice_No, Site_Api.Get_Company(t.Contract)
        From Bl_Plinvdtl t
       Where t.Invoice_No <> 0
         And Exists (Select 1
                From Bl_Bookinglist_Dtl T1
               Inner Join Bl_Picklist T2
                  On T1.Picklistno = T2.Pickuniteno
                 And T1.State = '2'
                 And T1.Booking_No = Row_.Booking_No
               Where (t.Picklistno = T1.Picklistno Or
                     t.Picklistno = T2.Picklistno));
    Fetch Cur_
      Into Invoice_No_, Company_;
    While Cur_%Found Loop
      Open Cur1_ For
        Select t.*
          From Cust_Invoice_Pub_Util_Head t
         Where t.Company = Company_
           And t.Invoice_Id = Invoice_No_;
      Fetch Cur1_
        Into Row1_;
      If Cur1_%Found Then
        Info_ := '';
        Attr_ := '';
        Client_Sys.Add_To_Attr('INVOICE_DATE',
                               To_Char(Start_Date_, 'yyyy-mm-dd'),
                               Attr_);
        Client_Sys.Add_To_Attr('PAY_TERM_ID', Row1_.Pay_Term_Id, Attr_);
        Client_Sys.Add_To_Attr('PAY_TERM_BASE_DATE',
                               To_Char(Start_Date_, 'yyyy-mm-dd'),
                               Attr_);
        Action_ := 'CHECK';
        Customer_Order_Inv_Head_Api.Modify__(Info_,
                                             Row1_.Objid,
                                             Row1_.Objversion,
                                             Attr_,
                                             Action_);
        Info_ := '';
        Attr_ := '';
        Client_Sys.Add_To_Attr('INVOICE_DATE',
                               To_Char(Start_Date_, 'yyyy-mm-dd'),
                               Attr_);
        Client_Sys.Add_To_Attr('PAY_TERM_ID', Row1_.Pay_Term_Id, Attr_);
        Client_Sys.Add_To_Attr('PAY_TERM_BASE_DATE',
                               To_Char(Start_Date_, 'yyyy-mm-dd'),
                               Attr_);
        Action_ := 'DO';
        Customer_Order_Inv_Head_Api.Modify__(Info_,
                                             Row1_.Objid,
                                             Row1_.Objversion,
                                             Attr_,
                                             Action_);
      End If;
      Close Cur1_;
      Fetch Cur_
        Into Invoice_No_, Company_;
    End Loop;
    Close Cur_;
    Pkg_a.Setmsg(A311_Key_, '', '确定船期成功');
    /*modify by wtl */
    /*  CLOSE CUR_;*/
    Return;
  End;
  Procedure Deny__(Rowlist_  Varchar2,
                   User_Id_  Varchar2,
                   A311_Key_ Varchar2) Is
    Cur_ t_Cursor;
    Row_ Bl_v_Bookinglist%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Bookinglist t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Pkg_a.Setfailed(A311_Key_, 'BL_BOOKINGLIST', Rowlist_);
      Raise_Application_Error(-20101, '错误的rowid');
      Return;
    End If;
    Close Cur_;
  
    Pkg_a.Setmsg(A311_Key_, '', '退货申请否定成功');
  
    Return;
  End;

  /*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2) Is
    Attr_Out      Varchar2(4000);
    Row_          Bl_v_Bookinglist%Rowtype;
    Row_Dist_     Sales_District_Tab%Rowtype;
    Row_Pickhead_ Bl_Picihead%Rowtype;
    Row1_         Supplier_Info_Comm_Method_Tab%Rowtype;
    Row0_         Bl_v_Bl_Picihead_V02%Rowtype;
    Cur_          t_Cursor;
    Cur1_         t_Cursor;
    Ll_Count_     Number;
  Begin
    If Column_Id_ = 'PISEL' Then
      Row_.Pisel := Pkg_a.Get_Item_Value('PISEL', Rowlist_);
    
      Open Cur_ For
        Select t.*
        /*           SHIPBY,TOMU, FROMQ, t.COMNAME ||chr(10)|| t.ADDRESS||chr(10)||t.TEL||chr(10)||t.FAX as LFROM,
        t.CUSTNAME2||chr(10)||t.DELIVERADDRESS||chr(10)||t.CUST2CONTACT||chr(10)||t.CUS2TTEL||chr(10)||CUS2TFAX||chr(10)||CUS2TEMAIL as LTO,
        t.MARKS||chr(10)||t.MARKS1||chr(10)||t.MARKS2||chr(10)||t.MARKS3||chr(10)||t.MARKS4 as  SHIPPINGMARK*/
          From Bl_Picihead t
         Where Invoice_No = Row_.Pisel;
      Fetch Cur_
        Into Row_Pickhead_;
      If Cur_%Found Then
        --RAISE_APPLICATION_ERROR(-20101, row_.shipby);
        --起运港
        Pkg_a.Set_Item_Value('EXITPORT', Row_Pickhead_.Fromq, Attr_Out);
        --目的港
        Pkg_a.Set_Item_Value('AIMPORT', Row_Pickhead_.Tomu, Attr_Out);
        --货物描述
        Pkg_a.Set_Item_Value('REFER', Row_Pickhead_.Refer, Attr_Out);
        --运输方式
      
        /*     select  LANGUAGE_DESC   
        into ROW_PICKHEAD_.shipby 
        from BL_DELIVERY_LEADTIME  
        where DTYPE = ROW_PICKHEAD_.shipby ;*/
        Open Cur1_ For
          Select Language_Desc
            From Bl_Delivery_Leadtime
           Where Dtype = Row_Pickhead_.Shipby;
        Fetch Cur1_
          Into Row_Pickhead_.Shipby;
        Close Cur1_;
        Pkg_a.Set_Item_Value('SHIPBY', Row_Pickhead_.Shipby, Attr_Out);
        --发货人
        Pkg_a.Set_Item_Value('LFROM', Row_Pickhead_.Comname, Attr_Out);
        Pkg_a.Set_Item_Value('LFROMADD', Row_Pickhead_.Address, Attr_Out);
        Pkg_a.Set_Item_Value('LFROMTEL', Row_Pickhead_.Tel, Attr_Out);
        Pkg_a.Set_Item_Value('LFROMFAX', Row_Pickhead_.Fax, Attr_Out);
        --收货人
        If Nvl(Row_Pickhead_.Etd, 'NULL') <> 'NULL' Then
          Row_.Lfromop := 'ET' || Row_Pickhead_.Etd || '-' ||
                          Row_Pickhead_.Cust2contact;
        End If;
        Pkg_a.Set_Item_Value('LFROMOP', Row_.Lfromop, Attr_Out);
        Pkg_a.Set_Item_Value('LTO', Row_Pickhead_.Custname2, Attr_Out);
        Pkg_a.Set_Item_Value('LTOADD',
                             Row_Pickhead_.Deliveraddress,
                             Attr_Out);
        Pkg_a.Set_Item_Value('LTOMAN',
                             Row_Pickhead_.Cust2contact,
                             Attr_Out);
        Pkg_a.Set_Item_Value('LTOTEL', Row_Pickhead_.Cus2ttel, Attr_Out);
        Pkg_a.Set_Item_Value('LTOFAX', Row_Pickhead_.Cus2tfax, Attr_Out);
        Pkg_a.Set_Item_Value('LTOMAIL', Row_Pickhead_.Cus2temail, Attr_Out);
        --通知人
        If Nvl(Row_Pickhead_.Etd, 'NULL') <> 'NULL' Then
          Row_.Infoop := 'ET' || Row_Pickhead_.Etd || '-' ||
                         Row_Pickhead_.Cust2contact;
        End If;
        Pkg_a.Set_Item_Value('INFOOP', Row_.Infoop, Attr_Out);
        Pkg_a.Set_Item_Value('INFORMANT',
                             Row_Pickhead_.Custname2,
                             Attr_Out);
        Pkg_a.Set_Item_Value('INFOADD',
                             Row_Pickhead_.Deliveraddress,
                             Attr_Out);
        Pkg_a.Set_Item_Value('INFOMAN',
                             Row_Pickhead_.Cust2contact,
                             Attr_Out);
        Pkg_a.Set_Item_Value('INFOTEL', Row_Pickhead_.Cus2ttel, Attr_Out);
        Pkg_a.Set_Item_Value('INFOFAX', Row_Pickhead_.Cus2tfax, Attr_Out);
        Pkg_a.Set_Item_Value('INFOMAIL',
                             Row_Pickhead_.Cus2temail,
                             Attr_Out);
        --唛头
        Pkg_a.Set_Item_Value('SHIPPINGMARK', Row_Pickhead_.Marks, Attr_Out);
        Pkg_a.Set_Item_Value('SHIPPINGMARK1',
                             Row_Pickhead_.Marks1,
                             Attr_Out);
        Pkg_a.Set_Item_Value('SHIPPINGMARK2',
                             Row_Pickhead_.Marks2,
                             Attr_Out);
        Pkg_a.Set_Item_Value('SHIPPINGMARK3',
                             Row_Pickhead_.Marks3,
                             Attr_Out);
        Pkg_a.Set_Item_Value('SHIPPINGMARK4',
                             Row_Pickhead_.Marks4,
                             Attr_Out);
        --预付到付
        Pkg_a.Set_Item_Value('CARRIAGE', Row_Pickhead_.Carriage, Attr_Out);
      End If;
      Close Cur_;
    End If;
    --通知人
    If Column_Id_ = 'INFOOP' Then
      Row_.Infoop := Pkg_a.Get_Item_Value('INFOOP', Rowlist_);
      Row_.Pisel  := Pkg_a.Get_Item_Value('PISEL', Rowlist_);
      Open Cur_ For
        Select t.*
          From Bl_v_Bl_Picihead_V02 t
         Where t.Invoice_No = Row_.Pisel
           And t.Choose_Data = Row_.Infoop;
      Fetch Cur_
        Into Row0_;
      Close Cur_;
      Pkg_a.Set_Item_Value('INFORMANT', Row0_.Custname2, Attr_Out);
      Pkg_a.Set_Item_Value('INFOADD', Row0_.Deliveraddress, Attr_Out);
      Pkg_a.Set_Item_Value('INFOMAN', Row0_.Cust2contact, Attr_Out);
      Pkg_a.Set_Item_Value('INFOTEL', Row0_.Cus2ttel, Attr_Out);
      Pkg_a.Set_Item_Value('INFOFAX', Row0_.Cus2tfax, Attr_Out);
      Pkg_a.Set_Item_Value('INFOMAIL', Row0_.Cus2temail, Attr_Out);
    End If;
    ---收货人
    If Column_Id_ = 'LFROMOP' Then
      Row_.Lfromop := Pkg_a.Get_Item_Value('LFROMOP', Rowlist_);
      Row_.Pisel   := Pkg_a.Get_Item_Value('PISEL', Rowlist_);
      Open Cur_ For
        Select t.*
          From Bl_v_Bl_Picihead_V02 t
         Where t.Invoice_No = Row_.Pisel
           And t.Choose_Data = Row_.Lfromop;
      Fetch Cur_
        Into Row0_;
      Close Cur_;
      Pkg_a.Set_Item_Value('LTO', Row0_.Custname2, Attr_Out);
      Pkg_a.Set_Item_Value('LTOADD', Row0_.Deliveraddress, Attr_Out);
      Pkg_a.Set_Item_Value('LTOMAN', Row0_.Cust2contact, Attr_Out);
      Pkg_a.Set_Item_Value('LTOTEL', Row0_.Cus2ttel, Attr_Out);
      Pkg_a.Set_Item_Value('LTOFAX', Row0_.Cus2tfax, Attr_Out);
      Pkg_a.Set_Item_Value('LTOMAIL', Row0_.Cus2temail, Attr_Out);
    End If;
    --货代
    If Column_Id_ = 'VENDOR_NO' Then
      Row_.Vendor_No   := Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_);
      Row_.Vendor_Name := Supplier_Info_Api.Get_Name(Row_.Vendor_No);
      Pkg_a.Set_Item_Value('VENDOR_NAME', Row_.Vendor_Name, Attr_Out);
      --默认的联系人
      Open Cur_ For
        Select t.Name
          From Supplier_Info_Comm_Method_Tab t
         Where t.Supplier_Id = Row_.Vendor_No;
      Fetch Cur_
        Into Row_.Contact;
      Close Cur_;
      Pkg_a.Set_Item_Value('CONTACT', Row_.Contact, Attr_Out);
      --默认的电话传真手机 
      Open Cur_ For
        Select t.*
          From Supplier_Info_Comm_Method_Tab t
         Where t.Supplier_Id = Row_.Vendor_No
           And t.Name = Row_.Contact
           And t.Method_Id In ('FAX', 'MOBILE', 'PHONE');
      Fetch Cur_
        Into Row1_;
      While Cur_%Found Loop
        If Row1_.Method_Id = 'PHONE' Then
          Row_.Contacttel := Row1_.Value;
        End If;
        If Row1_.Method_Id = 'MOBILE' Then
          Row_.Contactphn := Row1_.Value;
        End If;
        If Row1_.Method_Id = 'FAX' Then
          Row_.Contactfex := Row1_.Value;
        End If;
        Fetch Cur_
          Into Row1_;
      End Loop;
      Close Cur_;
      Pkg_a.Set_Item_Value('CONTACTTEL', Row_.Contacttel, Attr_Out);
      Pkg_a.Set_Item_Value('CONTACTPHN', Row_.Contactphn, Attr_Out);
      Pkg_a.Set_Item_Value('CONTACTFEX', Row_.Contactfex, Attr_Out);
    End If;
    --联系人
    If Column_Id_ = 'CONTACT' Then
      Row_.Vendor_No := Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_);
      Row_.Contact   := Pkg_a.Get_Item_Value('CONTACT', Rowlist_);
      Open Cur_ For
        Select t.*
          From Supplier_Info_Comm_Method_Tab t
         Where t.Supplier_Id = Row_.Vendor_No
           And t.Name = Row_.Contact
           And t.Method_Id In ('FAX', 'MOBILE', 'PHONE');
      Fetch Cur_
        Into Row1_;
      While Cur_%Found Loop
        If Row1_.Method_Id = 'PHONE' Then
          Row_.Contacttel := Row1_.Value;
        End If;
        If Row1_.Method_Id = 'MOBILE' Then
          Row_.Contactphn := Row1_.Value;
        End If;
        If Row1_.Method_Id = 'FAX' Then
          Row_.Contactfex := Row1_.Value;
        End If;
        Fetch Cur_
          Into Row1_;
      End Loop;
      Close Cur_;
      Pkg_a.Set_Item_Value('CONTACTTEL', Row_.Contacttel, Attr_Out);
      Pkg_a.Set_Item_Value('CONTACTPHN', Row_.Contactphn, Attr_Out);
      Pkg_a.Set_Item_Value('CONTACTFEX', Row_.Contactfex, Attr_Out);
    End If;
    /*    IF COLUMN_ID_='SHIPDATE' THEN 
       ROW_.shipdate :=TO_DATE(PKG_A.Get_Item_Value('SHIPDATE',ROWLIST_),'YYYY-MM-DD');
       SELECT SYSDATE - ROW_.shipdate
        INTO LL_COUNT_ 
        FROM DUAL ;
        IF LL_COUNT_ < 0 THEN
             RAISE_APPLICATION_ERROR(-20101, '实际船期不能大于当前日期');
        END IF ;
    END IF;*/
    --作废不用
    /*    IF COLUMN_ID_ = 'EXITPORT' THEN
      ROW_.EXITPORT := PKG_A.GET_ITEM_VALUE('EXITPORT', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT *
          FROM SALES_DISTRICT_TAB
         WHERE DISTRICT_CODE = ROW_.EXITPORT;
      FETCH CUR_
        INTO ROW_DIST_;
      IF CUR_%FOUND THEN
        PKG_A.SET_ITEM_VALUE('EXITPORTDESC',
                             ROW_DIST_.DESCRIPTION,
                             ATTR_OUT);
      END IF;
      CLOSE CUR_;
    END IF;
    
    IF COLUMN_ID_ = 'AIMPORT' THEN
      ROW_.AIMPORT := PKG_A.GET_ITEM_VALUE('AIMPORT', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT *
          FROM SALES_DISTRICT_TAB
         WHERE DISTRICT_CODE = ROW_.AIMPORT;
      FETCH CUR_
        INTO ROW_DIST_;
      IF CUR_%FOUND THEN
        PKG_A.SET_ITEM_VALUE('AIMPORTDESC',
                             ROW_DIST_.DESCRIPTION,
                             ATTR_OUT);
      END IF;
      CLOSE CUR_;
    END IF;*/
    IF Column_Id_ ='BOOKING_TYPE' THEN 
        ROW_.BOOKING_TYPE := PKG_A.Get_Item_Value('BOOKING_TYPE',ROWLIST_);
        IF ROW_.BOOKING_TYPE='1' THEN 
           PKG_A.Set_Item_Value('CONTAINER_TYPE','',Attr_Out);
        END IF ;
    END IF ;
    Outrowlist_ := Attr_Out;
  End;

  /*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
      返回: 1 可用
      0 不可用
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    Row_ Bl_v_Bookinglist%Rowtype;
    ll_count_ number;
  Begin
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Row_.State := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    row_.pisel := pkg_a.Get_Item_Value('PISEL', Rowlist_);
    If Row_.State = '4' Then
      Return '0';
    End If;
    If Nvl(Row_.Objid, 'NULL') <> 'NULL' And Column_Id_ = 'PISEL' Then
      Return '0';
    End If;
    If Row_.State != 0 Then
      --实际船期  如果确认船期就不能修改实际船期 2013-02-26 modify fjp
      IF Column_Id_ ='SHIPDATE'  THEN
         SELECT  COUNT(*)  
           INTO ll_count_ 
           FROM  bl_picklist
           where PICKUNITENO = row_.pisel
           and   nvl(Issure,'0')='0';
           if ll_count_ > 0 then 
               Return '1';
           else
               Return '0';
           end if ;
      END IF ;
      If Column_Id_ = 'PISEL' Or Column_Id_ = 'LTO' Or Column_Id_ = 'LFROM' Or
         Column_Id_ = 'INFORMANT' Or Column_Id_ = 'EXITPORT' Or
         Column_Id_ = 'AIMPORT' Or Column_Id_ = 'SHIPBY' Or
        ---COLUMN_ID_ = 'ATAIVPORT' OR --COLUMN_ID_ = 'ATTANSPORT'   
        --COLUMN_ID_ = 'TRANSPORT' OR --COLUMN_ID_ = 'COUNTMILERS' OR     
        --COLUMN_ID_ = 'CONTDAYS'  or OLUMN_ID_ = 'SHIPMENT' OR  
         Column_Id_ = 'REMARK' Or Column_Id_ = 'BOOKING_TYPE' Or
         Column_Id_ = 'VENDOR_NO' Or Column_Id_ = 'CONTACT_NO' Or
         Column_Id_ = 'CONTACT' Or Column_Id_ = 'CONTACTTEL' Or
         Column_Id_ = 'CONTACTFEX' Or Column_Id_ = 'CONTACTPHN' Or
         Column_Id_ = 'PICKNO_TRAN' Then
        Return '0';
      Else
        Return '1';
      End If;
    End If;
  End;

  /*获取仓位号码*/
  Procedure Get_Booking_No(Seq_ Out Varchar2) Is
    Row_  Bl_v_Bookinglist%Rowtype;
    Cur   t_Cursor;
    Seqw_ Number; --流水号
    yymmdd_  varchar2(10);
    len_yymmdd_ number;
  Begin
    yymmdd_ := To_Char(Sysdate, 'yymmdd');
    len_yymmdd_ := length(yymmdd_);
    -- 查询最大的本月仓位号
    Open Cur For
      Select Nvl(Max(To_Number(Substr(replace(Booking_No,'-',''), len_yymmdd_+1, 3))), '0')
        From Bl_v_Bookinglist t
       Where Substr(t.Booking_No, 1, len_yymmdd_) = yymmdd_;
    Fetch Cur
      Into Seqw_;
  
/*    Seq_ := To_Char(Sysdate, 'yyyymm') || '-' ||
            Trim(To_Char(Seqw_ + 1, '0000'));*/
       Seq_ := yymmdd_|| Trim(To_Char(Seqw_ + 1, '000'));
  
    Close Cur;
    Return;
  End;
  --bl_bookinglist_report获取发票号的函数 
  Function Get_Picklistno(Booking_No_ Varchar2) Return Varchar2 Is
    Cur_    t_Cursor;
    Row_    Bl_Bookinglist_Dtl%Rowtype;
    Result_ Varchar2(4000);
  Begin
    Open Cur_ For
      Select DISTINCT Picklistno
        From Bl_Bookinglist_Dtl t
       Where t.Booking_No = Booking_No_;
    Fetch Cur_
      Into ROW_.PICKLISTNO;
    While Cur_%Found Loop
      Result_ := Result_ || Row_.Picklistno || ',';
      Fetch Cur_
        Into ROW_.PICKLISTNO;
    End Loop;
    Close Cur_;
    If Length(Result_) > 0 Then
      Result_ := Substr(Result_, 1, Length(Result_) - 1);
    End If;
    Return Result_;
  End;
End Bl_Bookinglist_Api;
/
