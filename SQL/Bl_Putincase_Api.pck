Create Or Replace Package Bl_Putincase_Api Is
  /*  ������ʼ�� New__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���requseturl ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ */
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);

  /*  �������� Modify__
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
  */
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  /*  �з����仯��ʱ��
      Column_Id_   ��ǰ�޸ĵ���
      Mainrowlist_ ���������� ��ϸ��ֵ������Ϊ��
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      Outrowlist_  ���������   
  */
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2);
  /*  �з����仯��ʱ��
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ������� �� ɾ���� ��ť 
      KEY_ ����������ֵ
      User_Id_  ��ǰ�û�
  */
  Function Checkbutton__(Dotype_  In Varchar2,
                         Key_     In Varchar2,
                         User_Id_ In Varchar2) Return Varchar2;

  /*  ʵ��ҵ���߼������е� �༭��
      Doaction_   I M ��ϸ�϶�Ϊ M   I ���� M �޸� ҳ�������� ��ǰ�����е� �����Ե��Ժ� ����  
      Column_Id_  ��
      Rowlist_  ��ǰ�û�
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2;
  --��ȡ�Ѱ�װ����
  Function Get_Pkg_Qty(Picklistno_   In Varchar2,
                       Order_No_     In Varchar2,
                       Line_No_      In Varchar2,
                       Rel_No_       In Varchar2,
                       Line_Item_No_ In Number,
                       Putright_No_  In Varchar2,
                       Contract_     In Varchar2) Return Number;
  --��ⱸ�����Ƿ����װ��
  Function Check_Pkg_End(Picklistno_ In Varchar2, Contract_ In Varchar2)
    Return Number;

  --��ȡ����������
  Function Get_Pk_Qty(Picklistno_   In Varchar2,
                      Order_No_     In Varchar2,
                      Line_No_      In Varchar2,
                      Rel_No_       In Varchar2,
                      Line_Item_No_ In Number,
                      Putright_No_  In Varchar2,
                      Contract_     In Varchar2) Return Number;
  --��ȡ����Ȩ������
  Function Get_Putright_Qty(Picklistno_   In Varchar2,
                            Order_No_     In Varchar2,
                            Line_No_      In Varchar2,
                            Rel_No_       In Varchar2,
                            Line_Item_No_ In Number) Return Number;
  --����
  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  --��ȡ��Ʒ�İ�װ����
  Procedure Get_Pachage(Catalog_No_   Varchar2,
                        Contract_     In Varchar2,
                        Customer_No_  In Varchar2,
                        Pkg_Contract_ In Varchar2,
                        Pachage_Main_ Out Bl_Pachage_Set_Tab%Rowtype);
  --װ��
  Procedure Set_Pkg(Rowlist_  Varchar2,
                    User_Id_  Varchar2,
                    A311_Key_ Varchar2);
  --�����޸�����
  Procedure Modi_Weight_All__(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2);
  --���������޸�
  Procedure Modi_Weight__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);
  --��������
  Procedure Set_Material_Requisition(Rowlist_  Varchar2,
                                     User_Id_  Varchar2,
                                     A311_Key_ Varchar2);
  --�𵥸�����
  Procedure Modi_Box__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  --��ȫ������ 
  Procedure Modi_Allbox__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2);
  --�´�
  Procedure Release__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --�ύ
  Procedure Srelease__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2);
  --ȡ���ύ
  Procedure Releasecancel__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2);
  --ȡ���ύ �޸�״̬
  Procedure Cancelappvoe___(Picklistno_ In Varchar2,
                            Contract_   In Varchar2,
                            User_Id_    In Varchar2);
  --���ɰ�װ���� ����
  Procedure Setpick__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --�޸���������
  Procedure Set_Box_Qty(Putincase_No_ In Varchar2, Detail_Line_ In Number);
  --��ȡ�������İ�װ״̬  0 δ��װ�� 1 ��װ��  4 �ύ 5 �ύ�в���
  Function Get_Pkg_State(Picklistno_ In Varchar2, Contract_ In Varchar2)
    Return Varchar2;
  --�Ƿ�װ�����
  Function Check_Box_End(Picklistno_ In Varchar2, Contract_ In Varchar2)
    Return Number;
  --�ύ
  Procedure Appvoe___(Picklistno_ In Varchar2,
                      Contract_   In Varchar2,
                      User_Id_    In Varchar2);
  --���ɰ�װ���� ��������
  Procedure Set_Pick___(Picklistno_ In Varchar2,
                        Contract_   In Varchar2,
                        User_Id_    In Varchar2);
  --��ȡ��װ���ϵĵı������� 
  Function Get_Report_Data(Type_Id_ In Varchar2, Parmlist_ In Varchar2)
    Return Varchar;
  Function Get_Onebox_Qty(Putincase_No_ In Varchar2, Box_Line_ In Number)
    Return Number;

  -- �ɹ��������� ��Ʊ  ���ܽ��
  Function Sum_Amount(Order_No_ In Varchar2) Return Number;
  -- ����ί�б���  ����
  Function Get_Sum_Weight(Booking_No_ In Varchar2) Return Number;
  -- ����ί�б��� ë��
  Function Get_Sum_Weight_a(Booking_No_ In Varchar2) Return Number;

  -- ����ί�б��� �����
  Function Get_Sum_Area(Booking_No_ In Varchar2) Return Number;
End Bl_Putincase_Api;
/
Create Or Replace Package Body Bl_Putincase_Api Is
  Type t_Cursor Is Ref Cursor;
  /*Create by wtl 2013-01-30
    modify  by wtl  2013-01-30 �޸�ȡ��Ԥ���� ��Ԥ����Ǩ�����ɰ�װ���� �������ɲ�������   \
    modify  by wtl   2013-01-30 16:00 �޸�BUG ������̲��ܰ� ��Ȩ�����������    
  */
  --��COLUMN��  ������ ��ʵ�ʵ��߼� ��ʵ�ʵ�����
  -- ��VALUE��  �е����� �������ʵ���߼� �ö�Ӧ�Ĳ��������
  /*
  ����
  Raise_Application_Error(pkg_a.raise_error,'������ ����������');
  */

  /*  ������ʼ�� New__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���requseturl ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ */
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
    Attr_Out    Varchar2(4000);
    Attr__      Varchar2(4000);
    Outrowlist_ Varchar2(4000);
    Row_        Bl_v_Putincase%Rowtype;
    Prow_       Bl_v_Pldtl_Putincase%Rowtype;
    Requesurl_  Varchar2(1000);
  Begin
    Attr_Out   := '';
    Requesurl_ := Pkg_a.Get_Item_Value('REQUESTURL', Rowlist_);
  
    Row_.Picklistno := Pkg_a.Get_Item_Value_By_Index('&PICKLISTNO=',
                                                     '&',
                                                     Requesurl_);
    If Nvl(Row_.Picklistno, 'NULL') <> 'NULL' Then
      Row_.Supplier := Pkg_a.Get_Item_Value_By_Index('&SUPPLIER=',
                                                     '&',
                                                     Requesurl_);
      Pkg_a.Set_Item_Value('SUPPLIER', Row_.Supplier, Attr__);
      Pkg_a.Set_Item_Value('PICKLISTNO', Row_.Picklistno, Attr__);
    
      Itemchange__('PICKLISTNO', '', Attr__, User_Id_, Outrowlist_);
    
      Pkg_a.Set_Item_Value('CUSTOMER_REF',
                           Pkg_a.Get_Item_Value('CUSTOMER_REF', Outrowlist_),
                           Attr_Out);
      Pkg_a.Set_Item_Value('LOCATION',
                           Pkg_a.Get_Item_Value('LOCATION', Outrowlist_),
                           Attr_Out);
      Pkg_a.Set_Item_Value('SUPPLIER', Row_.Supplier, Attr_Out);
      Pkg_a.Set_Item_Value('PICKLISTNO', Row_.Picklistno, Attr_Out);
    Else
    
      --Ĭ����
      Row_.Supplier := Pkg_Attr.Get_Default_Contract(User_Id_);
      If (Nvl(Row_.Supplier, '0') <> '0') Then
        Pkg_a.Set_Item_Value('SUPPLIER', Row_.Supplier, Attr_Out);
      End If;
    End If;
    -- pkg_a.Set_Item_Value('��COLUMN��', '��VALUE��', attr_out);
    Pkg_a.Setresult(A311_Key_, Attr_Out);
  End;
  --��ȡ��Ҫ��װ������
  Function Get_Pk_Qty(Picklistno_   In Varchar2,
                      Order_No_     In Varchar2,
                      Line_No_      In Varchar2,
                      Rel_No_       In Varchar2,
                      Line_Item_No_ In Number,
                      Putright_No_  In Varchar2,
                      Contract_     In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
    Qty_    Number;
  Begin
    --���û����Ȩ ����
    If Nvl(Putright_No_, '-') = '-' Then
      Open Cur_ For
        Select t.Pickqty
          From Bl_Pldtl t
         Where t.Picklistno = Picklistno_
           And t.Order_No = Order_No_
           And t.Line_No = Line_No_
           And t.Rel_No = Rel_No_
           And t.Line_Item_No = Line_Item_No_;
    
      Fetch Cur_
        Into Result_;
      Close Cur_;
      --�۳��Ѿ���Ȩ������      
      Open Cur_ For
        Select Sum(t.Qty)
          From Bl_Putright_m_Detail t
         Where t.Picklistno = Picklistno_
           And t.Co_Order_No = Order_No_
           And t.Co_Line_No = Line_No_
           And t.Co_Rel_No = Rel_No_
           And t.Co_Line_Item_No = Line_Item_No_
           And t.State = '2';
      Fetch Cur_
        Into Qty_;
      Close Cur_;
      Result_ := Nvl(Result_, 0) - Nvl(Qty_, 0);
    Else
      --��ȡ��Ȩ--
      Open Cur_ For
        Select t.Qty
          From Bl_Putright_m_Detail_V01 t
         Where t.Putright_No = Putright_No_
           And t.Picklistno = Picklistno_
           And t.Co_Order_No = Order_No_
           And t.Co_Line_No = Line_No_
           And t.Co_Rel_No = Rel_No_
           And t.Co_Line_Item_No = Line_Item_No_
           And t.To_Contract = Contract_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
    End If;
    Return Nvl(Result_, 0);
  End;
  --�Ƿ�װ�����
  Function Check_Box_End(Picklistno_ In Varchar2, Contract_ In Varchar2)
    Return Number Is
    Result_ Number;
    Cur_    t_Cursor;
  Begin
  
    Open Cur_ For
      Select 1
        From Bl_v_Putincase_V03 t
       Where t.Picklistno = Picklistno_
         And t.To_Contract = Contract_
         And t.Box_Qty > t.Tp_Qty;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Nvl(Result_, 0);
  End;
  -- ��ȡ��װ״̬
  Function Get_Pkg_State(Picklistno_ In Varchar2, Contract_ In Varchar2)
    Return Varchar2 Is
    Result_      Number;
    Cur_         t_Cursor;
    Putincase_m_ Bl_Putincase_m%Rowtype;
    Bl_Pldtl_    Bl_Pldtl%Rowtype;
  
  Begin
    --�ж���û��δ��װ�������
    Open Cur_ For
      Select t.*
        From Bl_Putincase_m t
       Where t.Picklistno = Picklistno_
         And t.Supplier = Contract_
         And t.State <> '3'
       Order By t.State Desc;
    Fetch Cur_
      Into Putincase_m_;
    If Cur_%Found Then
      --���ύ
      Close Cur_;
      If Putincase_m_.State = '4' Then
        --�ж�װ����û�в��� 
        Open Cur_ For
          Select 1
            From Bl_v_Putincase_V01 t
           Where t.Pickuniteno = Picklistno_
             And t.To_Contract = Contract_
             And t.Pickqty <> t.Qty;
        Fetch Cur_
          Into Result_;
        If Cur_%Found Then
          Close Cur_;
          Return '5'; --��װ�����в��� 
        Else
          Close Cur_;
          Return '4'; --�ύ
        End If;
      
      Else
        Open Cur_ For
          Select 1
            From Bl_Putintray_m t
           Where t.Picklistno = Picklistno_
             And t.Contract = Contract_
             And t.State = '1';
        Fetch Cur_
          Into Result_;
        If Cur_%Found Then
          Close Cur_;
          Return '2'; --���ڴ���
        Else
          Close Cur_;
        End If;
        --�����û��װ����
        Open Cur_ For
          Select 1
            From Bl_v_Putincase_V01_c t
           Where t.Pickuniteno = Picklistno_
             And t.To_Contract = Contract_;
        Fetch Cur_
          Into Result_;
        If Cur_%Found Then
          Close Cur_;
          Return '6'; --δ��װ��  
        Else
        
          Return '1'; --��װ�� 
          Close Cur_;
        End If;
      
      End If;
    
    Else
    
      Close Cur_;
    End If;
  
    Return Nvl(Result_, '0');
  End;

  --�Ƿ��װ���
  Function Check_Pkg_End(Picklistno_ In Varchar2, Contract_ In Varchar2)
    Return Number Is
    Result_        Number;
    Cur_           t_Cursor;
    Bl_Putright_m_ Bl_Putright_m%Rowtype;
    Bl_Pldtl_      Bl_Pldtl%Rowtype;
  Begin
  
    --�ж���û��δ��װ�������
    Open Cur_ For
      Select 1
        From Bl_v_Putincase_V01_c t
       Where t.Pickuniteno = Picklistno_
         And t.To_Contract = Contract_;
    /* Select 1
     From Bl_v_Putincase_V01 t
    Where t.Pickuniteno = Picklistno_
      And t.To_Contract = Contract_
      And t.Pickqty > t.Qty;*/
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Nvl(Result_, 0);
  End;
  --��ȡ����Ȩ������
  Function Get_Putright_Qty(Picklistno_   In Varchar2,
                            Order_No_     In Varchar2,
                            Line_No_      In Varchar2,
                            Rel_No_       In Varchar2,
                            Line_Item_No_ In Number) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    Open Cur_ For
      Select Sum(Nvl(t.Qty, 0))
        From Bl_Putright_m_Detail_V01 t
       Where t.Picklistno = Picklistno_
         And t.Co_Order_No = Order_No_
         And t.Co_Line_No = Line_No_
         And t.Co_Rel_No = Rel_No_
         And t.Co_Line_Item_No = Line_Item_No_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Nvl(Result_, 0);
  End;

  --��ȡ���������Ѱ�װ������
  Function Get_Pkg_Qty(Picklistno_   In Varchar2,
                       Order_No_     In Varchar2,
                       Line_No_      In Varchar2,
                       Rel_No_       In Varchar2,
                       Line_Item_No_ In Number,
                       Putright_No_  In Varchar2,
                       Contract_     In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    If Nvl(Putright_No_, '-') = '-' Then
      Open Cur_ For
        Select Sum(Nvl(t.Qty, 0))
          From Bl_Putincase_m_Detail t
         Where t.Picklistno = Picklistno_
           And t.Co_Order_No = Order_No_
           And t.Co_Line_No = Line_No_
           And t.Co_Rel_No = Rel_No_
           And t.Co_Line_Item_No = Line_Item_No_
           And t.State <> '3';
      Fetch Cur_
        Into Result_;
      Close Cur_;
    Else
      Open Cur_ For
        Select Sum(Nvl(t.Qty, 0))
          From Bl_Putincase_m_Detail t
         Where t.Picklistno = Picklistno_
           And t.Co_Order_No = Order_No_
           And t.Co_Line_No = Line_No_
           And t.Co_Rel_No = Rel_No_
           And t.Co_Line_Item_No = Line_Item_No_
           And t.Putright_No = Putright_No_
           And t.State <> '3';
      Fetch Cur_
        Into Result_;
      Close Cur_;
    End If;
    Return Nvl(Result_, 0);
  End;

  /*  �������� Modify__
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
  */
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Objid_     Varchar2(50);
    Index_     Varchar2(1);
    Cur_       t_Cursor;
    Doaction_  Varchar2(10);
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar(4000);
    Row_       Bl_Putincase_m%Rowtype;
    Mainrow_   Bl_v_Putincase%Rowtype;
  Begin
  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    If Doaction_ = 'I' Then
      Row_.Picklistno := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_);
      Row_.Supplier   := Pkg_a.Get_Item_Value('SUPPLIER', Rowlist_);
      Row_.Pack_Flag  := Pkg_a.Get_Item_Value('PACK_FLAG', Rowlist_);
      Row_.Remark     := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      Row_.Pachage_No := Pkg_a.Get_Item_Value('PACHAGE_NO', Rowlist_);
      Row_.Box_Qty    := Pkg_a.Get_Item_Value('BOX_QTY', Rowlist_);
      Row_.Pachage_No := Pkg_a.Get_Item_Value('CASINGID', Rowlist_); --����ID
      Row_.State      := '0';
      Row_.Enter_Date := Sysdate;
      Row_.Enter_User := User_Id_;
      If Row_.Pack_Flag = '1' Then
        If Row_.Pachage_No = '' Or Row_.Pachage_No Is Null Then
          Raise_Application_Error(-20101, '��ϰ�װ����ID����');
          Return;
        End If;
        If Nvl(Row_.Box_Qty, 0) <= 0 Then
          Raise_Application_Error(-20101, '��ϰ�װÿ������������д');
          Return;
        End If;
      Else
        Row_.Pachage_No := '';
        Row_.Box_Qty    := Null;
      End If;
      Bl_Customer_Order_Api.Getseqno('P' || To_Char(Sysdate, 'YYMM'),
                                     User_Id_,
                                     6,
                                     Row_.Putincase_No);
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase t
         Where t.Supplier = Row_.Supplier
           And t.Picklistno = Row_.Picklistno
           And t.State = '0';
      Fetch Cur_
        Into Mainrow_;
      If Cur_ %Found Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                'ͬһ����ͬһ�ű�����ֻ�ܴ���һ�ݼ�¼');
        Return;
      End If;
      Close Cur_;
    
      Insert Into Bl_Putincase_m
        (Putincase_No)
      Values
        (Row_.Putincase_No)
      Returning Rowid Into Objid_;
      Update Bl_Putincase_m Set Row = Row_ Where Rowid = Objid_;
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Objid_);
      -- Pkg_a.Setmsg(A311_Key_, '', '������', Objid_);
    End If;
    --�޸�
    If Doaction_ = 'M' Then
      Open Cur_ For
        Select t.* From Bl_v_Putincase t Where t.Objid = Objid_;
      Fetch Cur_
        Into Mainrow_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '�����rowid');
        Return;
      End If;
      Close Cur_;
    
      Data_  := Rowlist_;
      Pos_   := Instr(Data_, Index_);
      i      := i + 1;
      Mysql_ := 'update  BL_PUTINCASE_M SET';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_         := Substr(Data_, 1, Pos_ - 1);
        Data_      := Substr(Data_, Pos_ + 1);
        Pos_       := Instr(Data_, Index_);
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        v_         := Substr(v_, Pos1_ + 1);
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' Then
          Mysql_ := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
        End If;
      End Loop;
      Mysql_ := Mysql_ || 'modi_date=sysdate,modi_user=''' || User_Id_ ||
                ''' where rowid=''' || Objid_ || '''';
    
      Execute Immediate 'begin ' || Mysql_ || ';end;';
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Objid_);
    End If;
    --ɾ��
    If Doaction_ = 'D' Then
      --pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
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
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2) Is
    Attr_Out     Varchar2(4000);
    Cur_         t_Cursor;
    Row_         Bl_v_Putincase%Rowtype;
    Casrow_      Bl_Casingstuff%Rowtype;
    Bl_Picklist_ Bl_Picklist%Rowtype;
  Begin
    Row_.Supplier := Pkg_a.Get_Item_Value('SUPPLIER', Rowlist_);
    If Column_Id_ = 'PACK_FLAG' Then
      Row_.Pack_Flag := Pkg_a.Get_Item_Value('PACK_FLAG', Rowlist_);
      Pkg_a.Set_Column_Enable('CASINGID', '0', Attr_Out);
      If Row_.Pack_Flag <> '1' Then
        Pkg_a.Set_Column_Enable('CASINGID', '0', Attr_Out);
      
        Pkg_a.Set_Item_Value('CASINGID', '', Attr_Out);
        Pkg_a.Set_Item_Value('CASINGDESCRIBE', '', Attr_Out);
        Pkg_a.Set_Item_Value('CASINGWEIGHT', '', Attr_Out);
        Pkg_a.Set_Item_Value('CASINGLENGTH', '', Attr_Out);
        Pkg_a.Set_Item_Value('CASINGWIDTH', '', Attr_Out);
        Pkg_a.Set_Item_Value('CASINGHEIGHT', '', Attr_Out);
      End If;
      If Row_.Pack_Flag = '1' Then
        Pkg_a.Set_Column_Enable('CASINGID', '1', Attr_Out);
      End If;
      /*      --���и�ֵ
      Pkg_a.Set_Item_Value('��COLUMN��', '��VALUE��', Attr_Out);
      --�����в�����
      Pkg_a.Set_Column_Enable('��COLUMN��', '0', Attr_Out);
      --�����п���
      Pkg_a.Set_Column_Enable('��COLUMN��', '1', Attr_Out);*/
    End If;
    If Column_Id_ = 'CASINGID' Then
      Row_.Casingid := Pkg_a.Get_Item_Value('CASINGID', Rowlist_);
      Open Cur_ For
        Select t.*
          From Bl_Casingstuff t
         Where t.Casingid = Row_.Casingid
           And t.Contract = Row_.Supplier;
      Fetch Cur_
        Into Casrow_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '���������ID');
        Return;
      End If;
      Close Cur_;
      Pkg_a.Set_Item_Value('CASINGDESCRIBE',
                           Casrow_.Casingdescribe,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CASINGWEIGHT', Casrow_.Casingweight, Attr_Out);
      Pkg_a.Set_Item_Value('CASINGLENGTH', Casrow_.Casinglength, Attr_Out);
      Pkg_a.Set_Item_Value('CASINGWIDTH', Casrow_.Casingwidth, Attr_Out);
      Pkg_a.Set_Item_Value('CASINGHEIGHT', Casrow_.Casingheight, Attr_Out);
    End If;
    If Column_Id_ = 'PICKLISTNO' Then
      Row_.Picklistno := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_);
      Open Cur_ For
        Select t.Customer_Ref, t.Location
          From Bl_v_Pldtl_Putincase t
         Where t.Picklistno = Row_.Picklistno;
      Fetch Cur_
        Into Bl_Picklist_.Customer_Ref, Bl_Picklist_.Location;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(Pkg_a.Raise_Error, '����ı�������');
        Return;
      End If;
      Close Cur_;
      Pkg_a.Set_Item_Value('CUSTOMER_REF',
                           Bl_Picklist_.Customer_Ref,
                           Attr_Out);
      Pkg_a.Set_Item_Value('LOCATION', Bl_Picklist_.Location, Attr_Out);
    End If;
    Outrowlist_ := Attr_Out;
  End;
  /*  �з����仯��ʱ��
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ������� �� ɾ���� ��ť 
      KEY_ ����������ֵ
      User_Id_  ��ǰ�û�
  */
  Function Checkbutton__(Dotype_  In Varchar2,
                         Key_     In Varchar2,
                         User_Id_ In Varchar2) Return Varchar2 Is
  Begin
    If Dotype_ = 'ADD_ROW' Then
      Return '1';
    
    End If;
    If Dotype_ = 'DEL_ROW' Then
      Return '1';
    
    End If;
    Return '1';
  End;

  /*  ʵ��ҵ���߼������е� �༭��
      Doaction_   I M ��ϸ�϶�Ϊ M   I ���� M �޸� ҳ�������� ��ǰ�����е� �����Ե��Ժ� ����  
      Column_Id_  ��
      Rowlist_  ��ǰ�û�
      ����: 1 ����
      0 ������
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    Mainrow_   Bl_v_Putincase%Rowtype;
    Detailrow_ Bl_v_Putincase_m_Detail%Rowtype;
    Cur_       t_Cursor;
  Begin
    Mainrow_.State        := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    Mainrow_.Pack_Flag    := Pkg_a.Get_Item_Value('PACK_FLAG', Rowlist_);
    Mainrow_.Putincase_No := Pkg_a.Get_Item_Value('PUTINCASE_NO', Rowlist_);
  
    If Column_Id_ = 'REMARK' Then
      Return '1';
    End If;
    If Doaction_ = 'M' Then
      If Mainrow_.State = '0' And Mainrow_.Pack_Flag = '1' Then
        If Column_Id_ = 'BOX_QTY' Then
          --�ж���û����ϸ
          Open Cur_ For
            Select t.*
              From Bl_v_Putincase_m_Detail t
             Where t.Putincase_No = Mainrow_.Putincase_No;
          Fetch Cur_
            Into Detailrow_;
          If Cur_%Notfound Then
            Close Cur_;
            Return '1';
          Else
            Close Cur_;
            Return '0';
          End If;
        End If;
      End If;
      Return '0';
    End If;
    If Column_Id_ = '��COLUMN��' Then
      Return '0';
    End If;
    Return '1';
  End;
  --���ɲ�������
  Procedure Set_Material_Requisition(Rowlist_  Varchar2,
                                     User_Id_  Varchar2,
                                     A311_Key_ Varchar2) Is
    Cur_                t_Cursor;
    Mainrow_            Bl_v_Putincase%Rowtype;
    Sqrowlist_          Varchar2(4000);
    Sqlinerowlist_      Varchar2(4000);
    Outinerowlist_      Varchar2(4000);
    Sq_Config_          Varchar2(4000);
    A311_               A311%Rowtype;
    Irow_               Bl_v_Material_Requisition%Rowtype;
    Sqqty_              Number;
    Casingid_           Varchar2(40);
    A314_               A314%Rowtype;
    Mainrowlist_        Varchar2(4000);
    Bl_v_Putincase_V01_ Bl_v_Putincase_V01%Rowtype;
  Begin
    Return;
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '�����ROWID');
      Return;
    End If;
    Close Cur_;
    If Mainrow_.State != '2' Then
    
      Raise_Application_Error(Pkg_a.Raise_Error,
                              'ֻ���´��˲������ɲ�������');
      Return;
    End If;
    --�ж���ϸ�Ƿ�װ�����
    If Mainrow_.Sq_Order_No <> '' Or Mainrow_.Sq_Order_No Is Not Null Then
      Return;
      Raise_Application_Error(Pkg_a.Raise_Error, '�Ѿ����ɲ�������');
      Return;
    End If;
  
    --��ⱸ�����Ƿ��Ѿ�װ����
    Open Cur_ For
      Select t.*
        From Bl_v_Putincase_V01 t
       Where t.Picklistno = Mainrow_.Picklistno
         And t.To_Contract = Mainrow_.Supplier
         And t.Pickqty <> t.Qty;
    Fetch Cur_
      Into Bl_v_Putincase_V01_;
  
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Bl_v_Putincase_V01_.Catalog_No || '(' ||
                              Bl_v_Putincase_V01_.Catalog_Desc || ')������' ||
                              To_Char(Bl_v_Putincase_V01_.Pickqty) || 'װ����' ||
                              To_Char(Bl_v_Putincase_V01_.Qty));
      Return;
    End If;
    Close Cur_;
  
    Pkg_a.Set_Item_Value('DOACTION', 'I', Sqrowlist_);
    Pkg_a.Set_Item_Value('OBJID', 'NULL', Sqrowlist_);
    Pkg_a.Set_Item_Value('CONTRACT', Mainrow_.Supplier, Sqrowlist_);
    Pkg_a.Set_Item_Value('INT_CUSTOMER_NO', 'BLGM', Sqrowlist_);
    Pkg_a.Set_Item_Value('DUE_DATE',
                         To_Char(Sysdate, 'YYYY-MM-DD'),
                         Sqrowlist_);
    Pkg_a.Set_Item_Value('NOTE_TEXT', Mainrow_.Picklistno, Sqrowlist_);
  
    A311_.A311_Id    := 'Bl_Putincase_Api.Set_Material_Requisition';
    A311_.Enter_User := User_Id_;
    A311_.A014_Id    := 'A014_ID=SAVE';
    A311_.Table_Id   := 'BL_V_MATERIAL_REQUISITION';
    Pkg_a.Beginlog(A311_);
    Bl_Material_Requisition_Api.Modify__(Sqrowlist_,
                                         User_Id_,
                                         A311_.A311_Key);
    Open Cur_ For
      Select t.* From A311 t Where t.A311_Key = A311_.A311_Key;
    Fetch Cur_
      Into A311_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, 'Set_Material_Requisition����ʧ��');
      Return;
    End If;
    Close Cur_;
    Open Cur_ For
      Select t.*
        From Bl_v_Material_Requisition t
       Where t.Objid = A311_.Table_Objid;
    Fetch Cur_
      Into Irow_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              'Set_Material_Requisition����ʧ��');
      Return;
    End If;
    Close Cur_;
    Update Bl_Putincase_m t
       Set t.Sq_Order_No = Irow_.Order_No
     Where t.Picklistno = Mainrow_.Picklistno
       And t.Supplier = Mainrow_.Supplier;
  
    --�������ϱ���
    Pkg_a.Get_Row_Str('BL_V_MATERIAL_REQUISITION',
                      ' AND ORDER_NO=''' || Irow_.Order_No || '''',
                      Mainrowlist_);
  
    --���ɲ���������ϸ
    --���� ��ʼ������
  
    Pkg_a.Set_Item_Value('ORDER_NO', Irow_.Order_No, Sqlinerowlist_);
    Pkg_a.Set_Item_Value('LINE_ITEM_NO', '0', Sqlinerowlist_);
  
    Select s_A314.Nextval Into A314_.A314_Key From Dual;
    Insert Into A314
      (A314_Key, A314_Id, State, Enter_User, Enter_Date)
      Select A314_.A314_Key, A314_.A314_Key, '0', User_Id_, Sysdate
        From Dual;
    --��ȡ��ʼ����ֵ
    Bl_Material_Requis_Line_Api.New__(Sqlinerowlist_,
                                      User_Id_,
                                      A314_.A314_Key);
    --��ȡ���صĳ�ʼֵ  
    Select t.Res
      Into Sq_Config_
      From A314 t
     Where t.A314_Key = A314_.A314_Key
       And Rownum = 1;
  
    Pkg_a.Str_Add_Str(Sq_Config_, Sqlinerowlist_);
  
    Open Cur_ For
      Select Part_No, Sum(Qty) As Qty
        From (Select Bl_Casingstuff_Api.Get_Part_No(T1.Materiel_Id,
                                                    T1.Contract) As Part_No,
                     Sum(T1.Qty_Assembly) As Qty
                From Bl_Putincase_m m
               Inner Join Bl_Putincase_Box t
                  On t.Putincase_No = m.Putincase_No
               Inner Join Bl_Pachage_Det_Tab T1
                  On T1.Pachage_No = t.Pachage_No
                 And T1.Catalog_Key = '1'
               Where m.Picklistno = Mainrow_.Picklistno
                 And m.Supplier = Mainrow_.Supplier
                 And m.State = '2'
                 And m.Pack_Flag = '0'
               Group By Bl_Casingstuff_Api.Get_Part_No(T1.Materiel_Id,
                                                       T1.Contract)
              Union All
              Select T1.Materiel_Id, Sum(T1.Qty_Assembly)
                From Bl_Putincase_m m
               Inner Join Bl_Putincase_Box t
                  On t.Putincase_No = m.Putincase_No
               Inner Join Bl_Pachage_Det_Tab T1
                  On T1.Pachage_No = t.Pachage_No
                 And T1.Catalog_Key = '0'
               Where m.Picklistno = Mainrow_.Picklistno
                 And m.Supplier = Mainrow_.Supplier
                 And m.State = '2'
                 And m.Pack_Flag = '0'
               Group By T1.Materiel_Id
              Union All
              Select Bl_Casingstuff_Api.Get_Part_No(m.Pachage_No, m.Supplier) As Part_No,
                     Count(*)
                From Bl_Putincase_m m
               Inner Join Bl_Putincase_Box t
                  On t.Putincase_No = m.Putincase_No
               Where m.Picklistno = Mainrow_.Picklistno
                 And m.Supplier = Mainrow_.Supplier
                 And m.State = '2'
                 And m.Pack_Flag = '1'
               Group By Bl_Casingstuff_Api.Get_Part_No(m.Pachage_No,
                                                       m.Supplier)) a
       Group By Part_No;
    Fetch Cur_
      Into Casingid_, Sqqty_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '������������ʧ�ܣ���װ���ô���');
      Return;
    End If;
    Loop
      Exit When Cur_%Notfound;
    
      Sqlinerowlist_ := '';
      Pkg_a.Set_Item_Value('DOACTION', 'I', Sqlinerowlist_);
      Pkg_a.Set_Item_Value('OBJID', 'NULL', Sqlinerowlist_);
    
      Pkg_a.Str_Add_Str(Sqlinerowlist_, Sq_Config_);
    
      Pkg_a.Set_Item_Value('PART_NO', Casingid_, Sqlinerowlist_);
    
      Bl_Material_Requis_Line_Api.Itemchange__('PART_NO',
                                               Mainrowlist_,
                                               Sqlinerowlist_,
                                               User_Id_,
                                               Outinerowlist_);
    
      Pkg_a.Str_Add_Str(Sqlinerowlist_, Outinerowlist_);
      Pkg_a.Set_Item_Value('QTY_DUE', Sqqty_, Sqlinerowlist_);
    
      Bl_Material_Requis_Line_Api.Modify__(Sqlinerowlist_,
                                           User_Id_,
                                           A311_.A311_Key);
    
      Fetch Cur_
        Into Casingid_, Sqqty_;
    End Loop;
    Close Cur_;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Mainrow_.Objid);
  
  End;

  --װ�� 
  Procedure Set_Pkg(Rowlist_  Varchar2,
                    User_Id_  Varchar2,
                    A311_Key_ Varchar2) Is
    Cur_                  t_Cursor;
    Cur1_                 t_Cursor;
    Cur2_                 t_Cursor;
    Mainrow_              Bl_v_Putincase%Rowtype;
    Detailrow_            Bl_v_Putincase_m_Detail%Rowtype;
    Pachage_Main_         Bl_Pachage_Set_Tab%Rowtype;
    Pachage_Detail_       Bl_Pachage_Det_Tab%Rowtype;
    Putincase_Box_        Bl_Putincase_Box%Rowtype;
    Putincase_Box_Detail_ Bl_Putincase_Box_Detail%Rowtype;
    Objid_                Varchar2(100);
    Temp_Row_             Bl_Temp%Rowtype;
    Itemp_Row_            Bl_Temp_Tab%Rowtype;
    Bl_Casingstuff_       Bl_Casingstuff%Rowtype; --����
    Bl_Picklist_          Bl_Picklist%Rowtype;
    Sq_Qty_               Number; --������������
    --     Bl_Pachage_Set_Tab%rowtype;
    i_      Number;
    Box_Qty Number;
  Begin
  
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '�����ROWID');
      Return;
    End If;
    Close Cur_;
    Mainrow_.State := '1';
    --����״̬
    Update Bl_Putincase_m t
       Set State     = Mainrow_.State,
           Modi_Date = Sysdate,
           Modi_User = User_Id_
     Where t.Rowid = Mainrow_.Objid;
    --���ݲ�ͬ�İ�װ����ѭ����ϸ
    --Putincase_box_.
  
    --Ĭ�ϰ�װ
    Open Cur_ For
      Select t.*
        From Bl_Picklist t
       Where t.Picklistno = Mainrow_.Picklistno;
    Fetch Cur_
      Into Bl_Picklist_;
    Close Cur_;
    If Mainrow_.Pack_Flag = '0' Then
      Putincase_Box_.Putincase_No  := Mainrow_.Putincase_No;
      Putincase_Box_.Line_No       := Nvl(Putincase_Box_.Line_No, 0);
      Putincase_Box_.Box_Newline   := Putincase_Box_.Line_No;
      Putincase_Box_.State         := Mainrow_.State;
      Putincase_Box_.To_Contract   := Mainrow_.Supplier;
      Putincase_Box_.Putright_No   := '-';
      Putincase_Box_.Putright_Line := 0;
      Putincase_Box_.Picklistno    := Mainrow_.Picklistno;
      Putincase_Box_.Contract      := Putincase_Box_.To_Contract;
      Select s_Bl_Temp.Nextval Into Temp_Row_.Tempkey From Dual;
    
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase_m_Detail t
         Where t.Putincase_No = Mainrow_.Putincase_No;
      Fetch Cur_
        Into Detailrow_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error, 'û����ϸ�в���װ��');
      End If;
      Loop
        Exit When Cur_%Notfound;
        /* Get_Pachage(Detailrow_.Catalog_No,
        Bl_Picklist_.Contract,
        Bl_Picklist_.Customer_Ref,
        Mainrow_.Supplier, --������
        Pachage_Main_);*/
        i_ := 0;
        --װ��
        Detailrow_.Box_List        := '#' ||
                                      To_Char(Nvl(Putincase_Box_.Line_No, 0) + 1);
        Putincase_Box_.Detail_Line := Detailrow_.Line_No;
        Putincase_Box_.Pachage_No  := Detailrow_.Pachage_No;
        Putincase_Box_.Qty         := Detailrow_.Qty_Pkg;
        --�����ӵ����Ը�ֵ������                           
        Putincase_Box_.Casingid       := Detailrow_.Casingid;
        Putincase_Box_.Casingdescribe := Detailrow_.Casingdescribe;
        Putincase_Box_.Casingweight   := Detailrow_.Casingweight;
        Putincase_Box_.Casinglength   := Detailrow_.Casinglength;
        Putincase_Box_.Casingwidth    := Detailrow_.Casingwidth;
        Putincase_Box_.Casingheight   := Detailrow_.Casingheight;
        Putincase_Box_.Casingarea     := Detailrow_.Casingarea;
        Putincase_Box_.Partweight     := Detailrow_.Partweight;
      
        --�����Ӷ�Ӧ��ifs���ϱ���
        Putincase_Box_.Part_No := Detailrow_.Part_No;
      
        If Nvl(Putincase_Box_.Part_No, '-') = '-' Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '���õ�����' ||
                                  Bl_Casingstuff_.Casingid ||
                                  '��Ӧ��PART_NO������ ');
          Return;
        
        End If;
        Loop
          Exit When Detailrow_.Qty < Detailrow_.Qty_Pkg;
          --����һ������          
          Putincase_Box_.Line_No           := Nvl(Putincase_Box_.Line_No, 0) + 1;
          Putincase_Box_.Box_Num           := '#' ||
                                              To_Char(Putincase_Box_.Line_No);
          Putincase_Box_.Enter_Date        := Sysdate;
          Putincase_Box_.Enter_User        := User_Id_;
          Putincase_Box_.Putintray_No      := '-';
          Putincase_Box_.Putintray_Line_No := 0;
          Putincase_Box_.Putintray_Id      := '';
          Putincase_Box_.Putintray_Line    := 0;
        
          Insert Into Bl_Putincase_Box
            (Putincase_No, Line_No, Enter_Date, Enter_User)
          Values
            (Putincase_Box_.Putincase_No,
             Putincase_Box_.Line_No,
             Sysdate,
             User_Id_)
          Returning Rowid Into Objid_;
          Update Bl_Putincase_Box
             Set Row = Putincase_Box_
           Where Rowid = Objid_;
          --��ֵ���ӵ���Ϣ
          --Putincase_Box_.
        
          Putincase_Box_Detail_.Putincase_No    := Putincase_Box_.Putincase_No;
          Putincase_Box_Detail_.Line_No         := Nvl(Putincase_Box_Detail_.Line_No,
                                                       0) + 1;
          Putincase_Box_Detail_.Detail_Line     := Putincase_Box_.Detail_Line;
          Putincase_Box_Detail_.Box_Line        := Putincase_Box_.Line_No;
          Putincase_Box_Detail_.State           := Putincase_Box_.State;
          Putincase_Box_Detail_.Picklistno      := Detailrow_.Picklistno;
          Putincase_Box_Detail_.Co_Order_No     := Detailrow_.Co_Order_No;
          Putincase_Box_Detail_.Co_Line_No      := Detailrow_.Co_Line_No;
          Putincase_Box_Detail_.Co_Rel_No       := Detailrow_.Co_Rel_No;
          Putincase_Box_Detail_.Co_Line_Item_No := Detailrow_.Co_Line_Item_No;
          Putincase_Box_Detail_.Qty             := Detailrow_.Qty_Pkg;
          Putincase_Box_Detail_.Weight_Net      := Detailrow_.Partweight /
                                                   Putincase_Box_Detail_.Qty;
          --��������
          Putincase_Box_Detail_.Contract   := Bl_Picklist_.Contract;
          Putincase_Box_Detail_.Catalog_No := Detailrow_.Catalog_No;
          --��Ʒ����                                                                               
        
          --����������ϸ
          Insert Into Bl_Putincase_Box_Detail
            (Putincase_No,
             Line_No,
             Detail_Line,
             Box_Line,
             State,
             Picklistno,
             Co_Order_No,
             Co_Line_No,
             Co_Rel_No,
             Co_Line_Item_No,
             Weight_Net,
             Qty,
             Enter_Date,
             Enter_User,
             Contract,
             Catalog_No)
          Values
            (Putincase_Box_Detail_.Putincase_No,
             Putincase_Box_Detail_.Line_No,
             Putincase_Box_Detail_.Detail_Line,
             Putincase_Box_Detail_.Box_Line,
             Putincase_Box_Detail_.State,
             Putincase_Box_Detail_.Picklistno,
             Putincase_Box_Detail_.Co_Order_No,
             Putincase_Box_Detail_.Co_Line_No,
             Putincase_Box_Detail_.Co_Rel_No,
             Putincase_Box_Detail_.Co_Line_Item_No,
             Putincase_Box_Detail_.Weight_Net,
             Putincase_Box_Detail_.Qty,
             Sysdate,
             User_Id_,
             Putincase_Box_Detail_.Contract,
             Putincase_Box_Detail_.Catalog_No);
          Detailrow_.Qty := Detailrow_.Qty - Detailrow_.Qty_Pkg;
          i_             := i_ + 1;
        End Loop;
        If i_ = 0 Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '����̫�ٲ���װ��');
          Return;
        End If;
        Detailrow_.Box_List := Detailrow_.Box_List || '-' || '#' ||
                               To_Char(Nvl(Putincase_Box_.Line_No, 0));
        Update Bl_Putincase_m_Detail t
           Set Box_List     = Detailrow_.Box_List,
               Qty          = Qty - Detailrow_.Qty,
               t.State      = Mainrow_.State,
               t.Box_Qty    = i_,
               t.Onebox_Qty = Detailrow_.Qty_Pkg
         Where t.Rowid = Detailrow_.Objid;
      
        Set_Box_Qty(Detailrow_.Putincase_No, Detailrow_.Line_No);
        Fetch Cur_
          Into Detailrow_;
      End Loop;
      Close Cur_;
    End If;
    --��ϰ�װ
    If Mainrow_.Pack_Flag = '1' Then
      --����
      --�����Ӷ�Ӧ��ifs���ϱ���
      Putincase_Box_.Putincase_No  := Mainrow_.Putincase_No;
      Putincase_Box_.Line_No       := Nvl(Putincase_Box_.Line_No, 0);
      Putincase_Box_.State         := Mainrow_.State;
      Putincase_Box_.Detail_Line   := 0;
      Putincase_Box_.To_Contract   := Mainrow_.Supplier;
      Putincase_Box_.Putright_No   := '-';
      Putincase_Box_.Putright_Line := 0;
      Putincase_Box_.Qty           := Mainrow_.Box_Qty;
      Putincase_Box_.Part_No       := Bl_Casingstuff_Api.Get_Part_No(Mainrow_.Casingid,
                                                                     Mainrow_.Supplier);
      If Nvl(Putincase_Box_.Part_No, '-') = '-' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                Detailrow_.Catalog_No || '���õ�װ���������' ||
                                Bl_Casingstuff_.Casingid ||
                                '��Ӧ��PART_NO������ ');
        Return;
      
      End If;
      Select s_Bl_Temp.Nextval Into Temp_Row_.Tempkey From Dual;
      Putincase_Box_.Casingid       := Mainrow_.Casingid;
      Putincase_Box_.Casingdescribe := Mainrow_.Casingdescribe;
      Putincase_Box_.Casingweight   := Mainrow_.Casingweight;
      Putincase_Box_.Casinglength   := Mainrow_.Casinglength;
      Putincase_Box_.Casingwidth    := Mainrow_.Casingwidth;
      Putincase_Box_.Casingheight   := Mainrow_.Casingheight;
      Putincase_Box_.Contract       := Mainrow_.Supplier;
      i_                            := 10000000;
      Putincase_Box_.Casingarea     := Mainrow_.Casingweight *
                                       Mainrow_.Casinglength *
                                       Mainrow_.Casingwidth;
      Putincase_Box_.Picklistno     := Mainrow_.Picklistno;
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase_m_Detail t
         Where t.Putincase_No = Mainrow_.Putincase_No;
      Fetch Cur_
        Into Detailrow_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error, 'û����ϸ�в���װ��');
      End If;
      Loop
        Exit When Cur_%Notfound;
        If Detailrow_.Qty < Detailrow_.Qty_Pkg Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '����̫�ٲ���װ��');
          Return;
        End If;
        If Round(Detailrow_.Qty_Pkg, 0) <> Detailrow_.Qty_Pkg Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '��ȴ���');
          Return;
        End If;
        Box_Qty := Floor(Detailrow_.Qty / Detailrow_.Qty_Pkg);
        If Box_Qty < i_ Then
          i_ := Box_Qty;
        End If;
        Fetch Cur_
          Into Detailrow_;
      End Loop;
      Close Cur_;
      If i_ = 0 Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                Detailrow_.Catalog_No || '����̫�ٲ���װ��');
        Return;
      
      End If;
      --��ʼװ��
      Box_Qty := i_;
      i_      := 0;
      Loop
        --����һ������ 
        Exit When i_ >= Box_Qty;
        Putincase_Box_.Line_No           := Nvl(Putincase_Box_.Line_No, 0) + 1;
        Putincase_Box_.Box_Newline       := Putincase_Box_.Line_No;
        Putincase_Box_.Box_Num           := '#' ||
                                            To_Char(Putincase_Box_.Line_No);
        Putincase_Box_.Partweight        := 0;
        Putincase_Box_.Enter_Date        := Sysdate;
        Putincase_Box_.Enter_User        := User_Id_;
        Putincase_Box_.Putintray_No      := '-';
        Putincase_Box_.Putintray_Line_No := 0;
        Putincase_Box_.Putintray_Id      := '';
        Putincase_Box_.Putintray_Line    := 0;
        --����������ϸ        
        Insert Into Bl_Putincase_Box
          (Putincase_No, Line_No, Enter_Date, Enter_User)
        Values
          (Putincase_Box_.Putincase_No,
           Putincase_Box_.Line_No,
           Sysdate,
           User_Id_)
        Returning Rowid Into Objid_;
      
        Open Cur_ For
          Select t.*
            From Bl_v_Putincase_m_Detail t
           Where t.Putincase_No = Mainrow_.Putincase_No;
        Fetch Cur_
          Into Detailrow_;
        Loop
          Exit When Cur_%Notfound;
          Putincase_Box_Detail_.Putincase_No    := Putincase_Box_.Putincase_No;
          Putincase_Box_Detail_.Line_No         := Nvl(Putincase_Box_Detail_.Line_No,
                                                       0) + 1;
          Putincase_Box_Detail_.Detail_Line     := Putincase_Box_.Detail_Line;
          Putincase_Box_Detail_.Box_Line        := Putincase_Box_.Line_No;
          Putincase_Box_Detail_.State           := Putincase_Box_.State;
          Putincase_Box_Detail_.Picklistno      := Detailrow_.Picklistno;
          Putincase_Box_Detail_.Co_Order_No     := Detailrow_.Co_Order_No;
          Putincase_Box_Detail_.Co_Line_No      := Detailrow_.Co_Line_No;
          Putincase_Box_Detail_.Co_Rel_No       := Detailrow_.Co_Rel_No;
          Putincase_Box_Detail_.Co_Line_Item_No := Detailrow_.Co_Line_Item_No;
          Putincase_Box_Detail_.Qty             := Detailrow_.Qty_Pkg;
          Putincase_Box_Detail_.Weight_Net      := Detailrow_.Partweight /
                                                   Putincase_Box_Detail_.Qty;
          --��������
          Putincase_Box_Detail_.Contract   := Bl_Picklist_.Contract;
          Putincase_Box_Detail_.Catalog_No := Detailrow_.Catalog_No;
          Putincase_Box_.Partweight        := Nvl(Putincase_Box_.Partweight,
                                                  0) +
                                              Nvl(Detailrow_.Partweight, 0);
          --����������ϸ
          Insert Into Bl_Putincase_Box_Detail
            (Putincase_No,
             Line_No,
             Detail_Line,
             Box_Line,
             State,
             Picklistno,
             Co_Order_No,
             Co_Line_No,
             Co_Rel_No,
             Co_Line_Item_No,
             Qty,
             Weight_Net,
             Enter_Date,
             Enter_User,
             Contract,
             Catalog_No)
          Values
            (Putincase_Box_Detail_.Putincase_No,
             Putincase_Box_Detail_.Line_No,
             Putincase_Box_Detail_.Detail_Line,
             Putincase_Box_Detail_.Box_Line,
             Putincase_Box_Detail_.State,
             Putincase_Box_Detail_.Picklistno,
             Putincase_Box_Detail_.Co_Order_No,
             Putincase_Box_Detail_.Co_Line_No,
             Putincase_Box_Detail_.Co_Rel_No,
             Putincase_Box_Detail_.Co_Line_Item_No,
             Putincase_Box_Detail_.Qty,
             Putincase_Box_Detail_.Weight_Net,
             Sysdate,
             User_Id_,
             Putincase_Box_Detail_.Contract,
             Putincase_Box_Detail_.Catalog_No);
        
          Fetch Cur_
            Into Detailrow_;
        End Loop;
        Close Cur_;
        Update Bl_Putincase_Box t
           Set Row = Putincase_Box_
         Where t.Rowid = Objid_;
        i_ := i_ + 1;
      End Loop;
      Update Bl_Putincase_m_Detail t
         Set t.Qty        = t.Qty_Pkg * i_,
             t.State      = Mainrow_.State,
             t.Onebox_Qty = Mainrow_.Box_Qty
       Where t.Putincase_No = Mainrow_.Putincase_No;
    
      Set_Box_Qty(Mainrow_.Putincase_No, 0);
      Itemp_Row_.Tempkey := Temp_Row_.Tempkey;
      Itemp_Row_.Rowkey  := Putincase_Box_.Part_No;
      Pkg_a.Set_Item_Value('QTY', Box_Qty, Itemp_Row_.Rowlist);
      Insert Into Bl_Temp_Tab
        (Tempkey, Rowkey, Rowlist)
      Values
        (Itemp_Row_.Tempkey, Itemp_Row_.Rowkey, Itemp_Row_.Rowlist) Return Rowid Into Temp_Row_.Objid;
    End If;
    --��������
    Open Cur_ For
      Select t.* From Bl_Temp_Tab t Where t.Tempkey = Temp_Row_.Tempkey;
    Fetch Cur_
      Into Itemp_Row_;
    Loop
      Exit When Cur_%Notfound;
      Fetch Cur_
        Into Itemp_Row_;
    End Loop;
  
    Close Cur_;
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', 'װ��ɹ�');
  
    Return;
  End;
  --װ���´�
  Procedure Release__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
    Cur_                t_Cursor;
    Mainrow_            Bl_v_Putincase%Rowtype;
    Checkrow_           Bl_v_Putincase%Rowtype;
    Sqrowlist_          Varchar2(4000);
    Sqlinerowlist_      Varchar2(4000);
    Outinerowlist_      Varchar2(4000);
    Sq_Config_          Varchar2(4000);
    A311_               A311%Rowtype;
    Irow_               Bl_v_Material_Requisition%Rowtype;
    Detrow_             Bl_Putincase_Box%Rowtype;
    Sqqty_              Number;
    Casingid_           Varchar2(40);
    A314_               A314%Rowtype;
    Mainrowlist_        Varchar2(4000);
    Bl_v_Putincase_V01_ Bl_v_Putincase_V01%Rowtype;
    Bl_Putincase_m_     Bl_Putincase_m%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '�����ROWID');
      Return;
    End If;
    Close Cur_;
    /* If Mainrow_.State != '1' Then
      Raise_Application_Error(Pkg_a.Raise_Error, 'ֻ��װ���˲����´�');
      Return;
    End If;*/
    --�жϵ�ǰ���Ƿ�����ϸ
    Open Cur_ For
      Select t.*
        From Bl_Putincase_Box t
       Where t.Putincase_No = Mainrow_.Putincase_No;
    Fetch Cur_
      Into Detrow_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Mainrow_.Putincase_No || 'δװ��');
      Return;
    
    End If;
    Close Cur_;
    --���Ͽ�ͷ
    Update Bl_Putincase_m t
       Set t.State = '3'
     Where t.Picklistno = Mainrow_.Picklistno
       And t.Supplier = Mainrow_.Supplier
       And Not Exists (Select 1
              From Bl_Putincase_m_Detail T1
             Where T1.Putincase_No = t.Putincase_No);
  
    --�ж�������ǰ����������װ����Ϣ�Ƿ��Ѿ�װ��
    Open Cur_ For
      Select t.*
        From Bl_v_Putincase t
       Where t.Picklistno = Mainrow_.Picklistno
         And t.Supplier = Mainrow_.Supplier
         And t.State = '0';
    Fetch Cur_
      Into Checkrow_;
    If Cur_ %Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Checkrow_.Putincase_No || 'δװ��');
      Return;
    End If;
    Close Cur_;
    Open Cur_ For
      Select t.*
        From Bl_Putincase_m t
       Where t.Picklistno = Mainrow_.Picklistno
         And t.Supplier = Mainrow_.Supplier
         And t.State In ('1');
    Fetch Cur_
      Into Bl_Putincase_m_;
    Loop
      Exit When Cur_%Notfound;
      Update Bl_Putincase_m t
         Set t.State = '2'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No;
    
      Update Bl_Putincase_m_Detail t
         Set t.State = '2'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No;
    
      Update Bl_Putincase_Box t
         Set t.State = '2'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No
         And t.To_Contract = Mainrow_.Supplier;
    
      Update Bl_Putincase_Box_Detail t
         Set t.State = '2'
       Where (t.Putincase_No, t.Box_Line) In
             (Select T1.Putincase_No, T1.Line_No
                From Bl_Putincase_Box T1
               Where T1.Putincase_No = Bl_Putincase_m_.Putincase_No
                 And T1.To_Contract = Mainrow_.Supplier);
    
      Fetch Cur_
        Into Bl_Putincase_m_;
    End Loop;
    Close Cur_;
  
    --���ȫ���Ѿ�װ�� ���ɲ�������
    Set_Material_Requisition(Rowlist_, User_Id_, A311_Key_);
    --���ɰ�װ����
    -- Setpick__(Rowlist_, User_Id_, A311_Key_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Mainrow_.Objid);
    Pkg_a.Setmsg(A311_Key_, '', 'Ԥ���ɳɹ�');
  End;

  Procedure Appvoe___(Picklistno_ In Varchar2,
                      Contract_   In Varchar2,
                      User_Id_    In Varchar2) Is
    Checkrow_           Bl_v_Putincase%Rowtype;
    Cur_                t_Cursor;
    Bl_Putincase_m_     Bl_Putincase_m%Rowtype;
    Bl_v_Putincase_V01_ Bl_v_Putincase_V01%Rowtype;
    Cur1_               t_Cursor;
    Cur2_               t_Cursor;
    Bl_Putin_           Bl_Putin%Rowtype;
    Cbl_Putin_          Bl_Putin%Rowtype;
  Begin
    --���Ͽ�ͷ
    Update Bl_Putincase_m t
       Set t.State = '3'
     Where t.Picklistno = Picklistno_
       And t.Supplier = Contract_
       And Not Exists (Select 1
              From Bl_Putincase_m_Detail T1
             Where T1.Putincase_No = t.Putincase_No);
  
    --��ⱸ�����Ƿ��Ѿ�װ����
    Open Cur_ For
      Select t.*
        From Bl_v_Putincase_V01 t
       Where t.Pickuniteno = Picklistno_
         And t.Supplier = Contract_
         And t.Pickqty <> t.Qty;
    Fetch Cur_
      Into Bl_v_Putincase_V01_;
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              'װ��δ��ɣ�' || Bl_v_Putincase_V01_.Catalog_No || '(' ||
                              Bl_v_Putincase_V01_.Catalog_Desc || ')������' ||
                              To_Char(Bl_v_Putincase_V01_.Pickqty) ||
                              'ֻװ����' || To_Char(Bl_v_Putincase_V01_.Qty));
      Return;
    End If;
    Close Cur_;
  
    --�ж�������ǰ����������װ����Ϣ�Ƿ��Ѿ�װ��
    Open Cur_ For
      Select t.*
        From Bl_v_Putincase t
       Where t.Picklistno = Picklistno_
         And t.Supplier = Contract_
         And t.State = '0';
    Fetch Cur_
      Into Checkrow_;
    If Cur_ %Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Checkrow_.Putincase_No || 'δװ��');
      Return;
    End If;
    Close Cur_;
    Open Cur_ For
      Select t.*
        From Bl_Putincase_m t
       Where t.Picklistno = Picklistno_
         And t.Supplier = Contract_
         And t.State In ('1', '2');
    Fetch Cur_
      Into Bl_Putincase_m_;
    Loop
      Exit When Cur_%Notfound;
      Update Bl_Putincase_m t
         Set t.State = '4'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No;
    
      Update Bl_Putincase_m_Detail t
         Set t.State = '4'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No;
    
      Update Bl_Putincase_Box t
         Set t.State = '4'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No
         And t.To_Contract = Contract_;
    
      Update Bl_Putincase_Box_Detail t
         Set t.State = '4'
       Where (t.Putincase_No, t.Box_Line) In
             (Select T1.Putincase_No, T1.Line_No
                From Bl_Putincase_Box T1
               Where T1.Putincase_No = Bl_Putincase_m_.Putincase_No
                 And T1.To_Contract = Contract_);
    
      Open Cur1_ For
        Select t.Putincase_No, t.Detail_Line, Count(*)
          From Bl_Putincase_Box t
         Where t.Putincase_No = Bl_Putincase_m_.Putincase_No
           And t.To_Contract = Contract_
         Group By t.Putincase_No, t.Detail_Line;
    
      Fetch Cur1_
        Into Bl_Putin_.Putin_No, Bl_Putin_.Line_No, Bl_Putin_.Qty;
      Loop
        Exit When Cur1_%Notfound;
        Open Cur2_ For
          Select t.*
            From Bl_Putin t
           Where t.Putin_No = Bl_Putin_.Putin_No
             And t.Line_No = Bl_Putin_.Line_No;
        Fetch Cur2_
          Into Cbl_Putin_;
        If Cur2_%Notfound Then
          Insert Into Bl_Putin
            (Putin_No, Line_No, Qty, Enter_Date, Enter_User)
          Values
            (Bl_Putin_.Putin_No,
             Bl_Putin_.Line_No,
             Bl_Putin_.Qty,
             Sysdate,
             User_Id_);
        Else
          If Cbl_Putin_.Qty <> Bl_Putin_.Qty Then
            Close Cur2_;
            Close Cur1_;
            Close Cur_;
            Raise_Application_Error(Pkg_a.Raise_Error,
                                    Bl_Putin_.Putin_No || '�ύ����������(' ||
                                    Bl_Putin_.Qty || ')����͵�һ���ύ����������' ||
                                    Cbl_Putin_.Qty || 'һ�£�');
          
          End If;
        
        End If;
        Close Cur2_;
      
        Fetch Cur1_
          Into Bl_Putin_.Putin_No, Bl_Putin_.Line_No, Bl_Putin_.Qty;
      End Loop;
      Close Cur1_;
    
      Fetch Cur_
        Into Bl_Putincase_m_;
    End Loop;
    Close Cur_;
    --������д�� BL_PUTIN �ϼƱ���
  
  End;

  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Row_ Bl_v_Putincase%Rowtype;
    Cur_ t_Cursor;
  Begin
    Row_.Objid := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '�����rowid');
      Return;
    End If;
    Close Cur_;
    --����״̬��Ϊ2
    Update Bl_Putincase_m t
       Set t.State = '3', t.Modi_Date = Sysdate, t.Modi_User = User_Id_
     Where t.Rowid = Row_.Objid;
    --��ϸ״̬��Ϊ2
    Update Bl_Putincase_m_Detail t
       Set t.State = '3', t.Modi_Date = Sysdate, t.Modi_User = User_Id_
     Where t.Putincase_No = Row_.Putincase_No;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Row_.Objid);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '��װ����' || '[' || Row_.Putincase_No || ']' || '���ϳɹ�');
  End;
  --��ȡ��Ʒ�İ�װ���� 
  Procedure Get_Pachage(Catalog_No_   Varchar2,
                        Contract_     In Varchar2,
                        Customer_No_  In Varchar2,
                        Pkg_Contract_ In Varchar2,
                        Pachage_Main_ Out Bl_Pachage_Set_Tab%Rowtype) Is
    Cur_ t_Cursor;
  Begin
    --��Ĭ�ϰ�װ
    Open Cur_ For
      Select t.*
        From Bl_Pachage_Set_Tab t
       Where t.Catalog_No = Catalog_No_
         And t.Customer_No = Customer_No_
         And t.Supplier = Contract_
         And t.State = '1';
    Fetch Cur_
      Into Pachage_Main_;
    If Cur_%Notfound Then
      Close Cur_;
    
      Open Cur_ For
        Select t.*
          From Bl_Pachage_Set_Tab t
         Where t.Catalog_No = Catalog_No_
           And t.Supplier = Pkg_Contract_
           And t.Default_Flag = '1'
           And t.State = '1';
      Fetch Cur_
        Into Pachage_Main_;
      If Cur_%Notfound Then
        Close Cur_;
        /*Raise_Application_Error(Pkg_a.Raise_Error,
        Catalog_No_ || 'û�����ð�װ');*/
        Return;
      Else
        Close Cur_;
      End If;
    Else
      Close Cur_;
    End If;
  
  End;
  --�����޸�����
  Procedure Modi_Weight_All__(Rowlist_  Varchar2,
                              User_Id_  Varchar2,
                              A311_Key_ Varchar2) Is
    Row_     Bl_v_Putincase_Box%Rowtype;
    Rowline_ Bl_Putincase_Box%Rowtype;
    Cur_     t_Cursor;
  Begin
    Row_.Objid          := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Rowline_.Partweight := Pkg_a.Get_Item_Value('PARTWEIGHT', Rowlist_);
    Open Cur_ For
      Select t.* From Bl_v_Putincase_Box t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '�����rowid');
      Return;
    End If;
    Close Cur_;
    Update Bl_Putincase_Box t
       Set t.Partweight = Rowline_.Partweight
     Where t.Putincase_No = Row_.Putincase_No
       And t.Detail_Line = Row_.Detail_Line;
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE_BOX', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', 'ȫ�������޸ĳɹ�');
  
  End;
  --�����޸�
  Procedure Modi_Weight__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
    Row_     Bl_v_Putincase_Box%Rowtype;
    Rowline_ Bl_Putincase_Box%Rowtype;
    Cur_     t_Cursor;
  Begin
    Row_.Objid          := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Rowline_.Partweight := Pkg_a.Get_Item_Value('PARTWEIGHT', Rowlist_);
    Open Cur_ For
      Select t.* From Bl_v_Putincase_Box t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '�����rowid');
      Return;
    End If;
    Close Cur_;
    Update Bl_Putincase_Box t
       Set t.Partweight = Rowline_.Partweight
     Where t.Rowid = Row_.Objid;
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE_BOX', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '���������޸ĳɹ�');
  End;
  --�𵥸�����
  Procedure Modi_Box__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
    Row_       Bl_v_Putincase_Box%Rowtype;
    Rowline_   Bl_Putincase_Box%Rowtype;
    Mainrow_   Bl_v_Putincase%Rowtype;
    Boxdetail_ Bl_Putincase_Box_Detail%Rowtype;
    Line_      Bl_v_Putincase_m_Detail%Rowtype;
    Boxrow_    Bl_v_Putincase_Box%Rowtype;
    Cur_       t_Cursor;
    Qty_       Number;
  Begin
    Row_.Objid := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_v_Putincase_Box t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '�����rowid');
      Return;
    End If;
    Close Cur_;
    If Nvl(Row_.Putright_No, '-') <> '-' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '��ǰ�����Ѿ���Ȩ��' || Row_.Tp_Contract);
      Return;
    End If;
  
    If Row_.Putintray_No <> '-' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '��ǰ�����Ѿ��������̣����ܲ����ӣ����Ȳ�����');
      Return;
    End If;
  
    Select t.Pack_Flag
      Into Mainrow_.Pack_Flag
      From Bl_Putincase_m t
     Where t.Putincase_No = Row_.Putincase_No;
  
    Open Cur_ For
      Select t.*
        From Bl_Putincase_Box_Detail t
       Where t.Putincase_No = Row_.Putincase_No
         And t.Box_Line = Row_.Line_No;
    Fetch Cur_
      Into Boxdetail_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '��������Ӻ�');
      Return;
    End If;
    Close Cur_;
    If Row_.State <> '1' And Row_.State <> '2' Then
      Raise_Application_Error(Pkg_a.Raise_Error, '��ǰ״̬���ܲ���');
      Return;
    End If;
  
    --�Ƿ��������
    If Row_.Putintray_No <> '-' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '���ڴ����̵����ӣ����ܲ��䣬�����Ȳ�����' || Row_.Putintray_No);
    End If;
    If Row_.Putright_No <> '-' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '������Ȩ��������ĵ����ӣ����ܲ��䣬������ȡ����Ȩ' ||
                              Row_.Putright_No);
    
    End If;
  
    --ɾ��װ����ϸ
    Delete From Bl_Putincase_Box_Detail t
     Where t.Putincase_No = Row_.Putincase_No
       And t.Box_Line = Row_.Line_No;
    --ɾ�� װ�������б�
    Delete From Bl_Putincase_Box t Where t.Rowid = Row_.Objid;
    If Mainrow_.Pack_Flag = '0' Then
      --��װ����  0ΪĬ�ϰ�װ  
      --�۵���������װ��ϸ����
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase_m_Detail t
         Where t.Putincase_No = Row_.Putincase_No
           And t.Line_No = Row_.Detail_Line;
      Fetch Cur_
        Into Line_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '��������Ӻ�');
        Return;
      End If;
      Close Cur_;
      Update Bl_Putincase_m_Detail t
         Set t.Qty = Nvl(Line_.Qty, 0) - Nvl(Line_.Qty_Pkg, 0)
       Where t.Putincase_No = Row_.Putincase_No
         And t.Line_No = Row_.Detail_Line;
    End If;
    If Mainrow_.Pack_Flag = '1' Then
      --1Ϊ��ϰ�װ
      Update Bl_Putincase_m_Detail t
         Set t.Qty = Nvl(Line_.Qty, 0) - Nvl(Line_.Qty_Pkg, 0)
       Where t.Putincase_No = Row_.Putincase_No;
    End If;
  
    Set_Box_Qty(Row_.Putincase_No, Row_.Detail_Line);
  
    --�������޸ĵ�   
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_PUTINCASE_M_DETAIL', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '�������Ӳ���ɹ�');
  End;

  --��ȫ������ 
  Procedure Modi_Allbox__(Rowlist_  Varchar2,
                          User_Id_  Varchar2,
                          A311_Key_ Varchar2) Is
    Row_       Bl_v_Putincase_Box%Rowtype;
    Rowline_   Bl_Putincase_Box%Rowtype;
    Mainrow_   Bl_v_Putincase%Rowtype;
    Boxdetail_ Bl_Putincase_Box_Detail%Rowtype;
    Line_      Bl_v_Putincase_m_Detail%Rowtype;
    Boxrow_    Bl_v_Putincase_Box%Rowtype;
    Cur_       t_Cursor;
  Begin
    Row_.Objid := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_v_Putincase_Box t Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '�����rowid');
      Return;
    End If;
    Close Cur_;
    If Row_.State <> '1' And Row_.State <> '2' Then
      Raise_Application_Error(-20101, '��ǰ״̬���ܲ���');
      Return;
    End If;
    --�ж���Ȩ����  �������Ȩ�Ͳ������������
  
    --�ж���û�����̺� 
    --�Ƿ��������
    Open Cur_ For
      Select t.*
        From Bl_v_Putincase_Box t
       Where t.Putincase_No = Row_.Putincase_No
         And t.Detail_Line = Row_.Detail_Line
         And (t.Putintray_No <> '-' Or t.Putright_No <> '-');
    Fetch Cur_
      Into Row_;
    If Cur_%Found Then
      Close Cur_;
      If Row_.Putintray_No <> '-' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '���ڴ����̵����ӣ����ܲ��䣬�����Ȳ�����' || Row_.Putintray_No);
      End If;
      If Row_.Putright_No <> '-' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '������Ȩ��������ĵ����ӣ����ܲ��䣬������ȡ����Ȩ' ||
                                Row_.Putright_No);
      
      End If;
      Return;
    End If;
    Close Cur_;
  
    --ɾ��װ����ϸ
    Delete From Bl_Putincase_Box_Detail t
     Where t.Putincase_No = Row_.Putincase_No
       And t.Detail_Line = Row_.Detail_Line;
    --ɾ��װ�������б�
    Delete From Bl_Putincase_Box t
     Where t.Putincase_No = Row_.Putincase_No
       And t.Detail_Line = Row_.Detail_Line;
    If Row_.Detail_Line > 0 Then
      --��ձ�������ϸ����
      Update Bl_Putincase_m_Detail t
         Set t.Qty = 0
       Where t.Putincase_No = Row_.Putincase_No
         And t.Line_No = Row_.Detail_Line;
    Else
      --��ϰ�װ ��״̬����Ϊ
      Update Bl_Putincase_m_Detail t
         Set t.Qty = 0
       Where t.Putincase_No = Row_.Putincase_No;
    End If;
    Set_Box_Qty(Row_.Putincase_No, Row_.Detail_Line);
    Pkg_a.Setsuccess(A311_Key_, 'BL_PUTINCASE_M_DETAIL', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', 'ȫ�����Ӳ���ɹ�');
  End;
  Procedure Set_Pick_All(Picklistno_ In Varchar2) Is
    Cur_           t_Cursor;
    Putincase_Box_ Bl_Putincase_Box%Rowtype;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Putincase_Box t
       Inner Join Bl_Putincase_m T1
          On T1.Putincase_No = t.Putincase_No
         And T1.Picklistno = Picklistno_
       Where t.Putintray_No <> '-';
    Fetch Cur_
      Into Putincase_Box_;
    --�����̵Ĳ�Ʒ������
    Loop
      Exit When Cur_%Notfound;
      --
    
      Fetch Cur_
        Into Putincase_Box_;
    End Loop;
    Close Cur_;
  
    -- BL_V_PUTINCASE_ONECASE
    Return;
  End;

  --�ύ
  Procedure Srelease__(Rowlist_  Varchar2,
                       User_Id_  Varchar2,
                       A311_Key_ Varchar2) Is
  
    Cur_      t_Cursor;
    Mainrow_  Bl_v_Putincase%Rowtype;
    Checkrow_ Bl_v_Putincase%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '�����ROWID');
      Return;
    End If;
    Close Cur_;
    If Mainrow_.State <> '2' And Mainrow_.State <> '1' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '��ǰ״̬�����ύ��װ����');
      Return;
    End If;
    --���ɰ�װ����
    Bl_Putintray_Api.Set_Pick___(Mainrow_.Picklistno,
                                 Mainrow_.Supplier,
                                 User_Id_);
  
    Bl_Putincase_Api.Set_Pick___(Mainrow_.Picklistno,
                                 Mainrow_.Supplier,
                                 User_Id_);
  
    --�ύ
    Bl_Putincase_Api.Appvoe___(Mainrow_.Picklistno,
                               Mainrow_.Supplier,
                               User_Id_);
    Bl_Putintray_Api.Appvoe___(Mainrow_.Picklistno,
                               Mainrow_.Supplier,
                               User_Id_);
  
    --���ɰ�װ����
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '�ύ��װ���ϳɹ�');
    Return;
  End;
  Procedure Cancelappvoe___(Picklistno_ In Varchar2,
                            Contract_   In Varchar2,
                            User_Id_    In Varchar2) Is
    Checkrow_       Bl_v_Putincase%Rowtype;
    Cur_            t_Cursor;
    Bl_Putincase_m_ Bl_Putincase_m%Rowtype;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Putincase_m t
       Where t.Picklistno = Picklistno_
         And t.Supplier = Contract_
         And t.State = '4';
    Fetch Cur_
      Into Bl_Putincase_m_;
    Loop
      Exit When Cur_%Notfound;
      Update Bl_Putincase_m t
         Set t.State = '2'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No;
    
      Update Bl_Putincase_m_Detail t
         Set t.State = '2'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No;
    
      Update Bl_Putincase_Box t
         Set t.State = '2'
       Where t.Putincase_No = Bl_Putincase_m_.Putincase_No
         And t.To_Contract = Contract_;
    
      Update Bl_Putincase_Box_Detail t
         Set t.State = '2'
       Where (t.Putincase_No, t.Box_Line) In
             (Select T1.Putincase_No, T1.Line_No
                From Bl_Putincase_Box T1
               Where T1.Putincase_No = Bl_Putincase_m_.Putincase_No
                 And T1.To_Contract = Contract_);
    
      Fetch Cur_
        Into Bl_Putincase_m_;
    End Loop;
    Close Cur_;
  
  End;
  --ȡ���ύ
  Procedure Releasecancel__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2) Is
    Cur_      t_Cursor;
    Mainrow_  Bl_v_Putincase%Rowtype;
    Checkrow_ Bl_v_Putincase%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '�����ROWID');
      Return;
    End If;
    Close Cur_;
    If Mainrow_.State != '4' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '��ǰ״̬����ȡ���ύ��װ����');
      Return;
    End If;
  
    Bl_Putincase_Api.Cancelappvoe___(Mainrow_.Picklistno,
                                     Mainrow_.Supplier,
                                     User_Id_);
    Bl_Putintray_Api.Cancelappvoe___(Mainrow_.Picklistno,
                                     Mainrow_.Supplier,
                                     User_Id_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '�˻ذ�װ���ϳɹ�');
    Return;
  End;
  --���ɰ�װ����
  Procedure Setpick__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
  
    Cur_     t_Cursor;
    Mainrow_ Bl_v_Putincase%Rowtype;
  
  Begin
    --�޸�״̬ --
    Release__(Rowlist_, User_Id_, A311_Key_);
    Open Cur_ For
      Select t.* From Bl_v_Putincase t Where t.Objid = Rowlist_;
    Fetch Cur_
      Into Mainrow_;
    If Cur_ %Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error, '�����ROWID');
      Return;
    End If;
    Close Cur_;
    If Mainrow_.State != '2' Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              'ֻ���´��˲������ɰ�װ����');
      Return;
    End If;
    Bl_Putincase_Api.Set_Pick___(Mainrow_.Picklistno,
                                 Mainrow_.Supplier,
                                 User_Id_);
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINCASE', Mainrow_.Objid);
    Pkg_a.Setmsg(A311_Key_, '', '���ɰ�װ���ϳɹ�');
    Return;
  End;

  --���ɰ�װ����
  Procedure Set_Pick___(Picklistno_ In Varchar2,
                        Contract_   In Varchar2,
                        User_Id_    In Varchar2) Is
    Cur_                t_Cursor;
    Cur1_               t_Cursor;
    Putincase_Box_      Bl_Putincase_Box%Rowtype;
    i_                  Number;
    Bl_v_Putincase_V01_ Bl_v_Putincase_V01%Rowtype;
  Begin
    /* --��ⱸ�����Ƿ��Ѿ�װ����
    Open Cur_ For
      Select t.*
        From Bl_v_Putincase_V01 t
       Where t.Pickuniteno = Picklistno_
         And t.To_Contract = Contract_
         And t.Pickqty <> t.Qty;
    Fetch Cur_
      Into Bl_v_Putincase_V01_;
    
    If Cur_%Found Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              'װ��δ��ɣ�' || Bl_v_Putincase_V01_.Catalog_No || '(' ||
                              Bl_v_Putincase_V01_.Catalog_Desc || ')������' ||
                              To_Char(Bl_v_Putincase_V01_.Pickqty) ||
                              'ֻװ����' || To_Char(Bl_v_Putincase_V01_.Qty));
      Return;
    End If;
    Close Cur_;*/
  
    i_ := 0;
    Open Cur_ For
      Select t.*
        From Bl_Putincase_Box t
       Inner Join Bl_Putincase_m T1
          On T1.Putincase_No = t.Putincase_No
         And T1.Picklistno = Picklistno_
      -- And (T1.State = '2' Or T1.State = '1' Or T1.State = '1' )
      -- Where t.To_Contract = Contract_
       Order By t.Putincase_No      Asc,
                t.Detail_Line       Asc,
                t.Putintray_No      Asc,
                t.Putintray_Newline Asc,
                t.Partweight;
    Fetch Cur_
      Into Putincase_Box_;
    Loop
      Exit When Cur_%Notfound;
      i_ := i_ + 1;
      Update Bl_Putincase_Box t
         Set t.Box_Newline = i_,
             t.Box_Num     = '#' || To_Char(i_),
             t.Modi_Date   = Sysdate,
             t.Modi_User   = User_Id_
       Where t.Putincase_No = Putincase_Box_.Putincase_No
         And t.Line_No = Putincase_Box_.Line_No;
      Fetch Cur_
        Into Putincase_Box_;
    End Loop;
    Close Cur_;
  
    Update Bl_Putincase_m t
       Set t.State = '3' --���� û������
     Where t.Picklistno = Picklistno_
       And t.Supplier = Contract_
       And Not Exists (Select 1
              From Bl_Putincase_Box T1
             Where T1.Putincase_No = t.Putincase_No);
  
    Update Bl_Putincase_m_Detail t
       Set t.State = '3' --���� û������
     Where t.Putincase_No In (Select Putincase_No
                                From Bl_Putincase_m T1
                               Where T1.Picklistno = Picklistno_
                                 And T1.Supplier = Contract_
                                 And State = '3');
  
  End;
  --�޸���������
  Procedure Set_Box_Qty(Putincase_No_ In Varchar2, Detail_Line_ In Number) Is
    Cur_           t_Cursor;
    Box_Qty_       Number;
    Putincase_Box_ Bl_Putincase_Box%Rowtype;
  Begin
    Open Cur_ For
      Select t.*
        From Bl_Putincase_Box t
       Where t.Putincase_No = Putincase_No_
         And t.Detail_Line = Detail_Line_;
    Fetch Cur_
      Into Putincase_Box_;
    Close Cur_;
  
    Open Cur_ For
      Select Count(*)
        From Bl_Putincase_Box t
       Where t.Putincase_No = Putincase_No_
         And t.Detail_Line = Detail_Line_;
    --����
    Fetch Cur_
      Into Box_Qty_;
    Close Cur_;
    Update Bl_Putincase_Box t
       Set t.Box_Qty = Box_Qty_
     Where t.Putincase_No = Putincase_No_
       And t.Line_No = Detail_Line_;
  
    --�޸�������״̬ �����װ��״̬ �޸�Ϊ ����  
    Delete From Bl_Putincase_m_Detail
     Where Putincase_No = Putincase_No_
       And Nvl(Qty, 0) = 0;
    Open Cur_ For
      Select 1
        From Bl_Putincase_m_Detail t
       Where t.Putincase_No = Putincase_No_;
    Fetch Cur_
      Into Box_Qty_;
    If Cur_%Notfound Then
      Update Bl_Putincase_m
         Set State = '0'
       Where Putincase_No = Putincase_No_
         And State In ('1', '2');
    End If;
    Close Cur_;
  End;
  Function Get_Report_Data(Type_Id_ In Varchar2, Parmlist_ In Varchar2)
    Return Varchar Is
    Cur_     t_Cursor;
    Sql_     Varchar2(4000);
    Result_  Varchar2(100);
    Result1_ Varchar2(100);
  Begin
    If Nvl(Parmlist_, '-') = '-' Then
      Return Null;
    End If;
    --��ȡ������������� =  Sum(�������) 
    If Type_Id_ = 'SUM_AREA' Then
      Open Cur_ For
        Select Sum(t.Casinglength * t.Casingwidth * t.Casingheight) As Sum_Area
          From Bl_Putincase_Box t
         Inner Join Bl_Putincase_m T1
            On T1.Putincase_No = t.Putincase_No
           And T1.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    --��ȡ�������������� =  Sum() 
    If Type_Id_ = 'SUM_WEIGHT' Then
      Open Cur_ For
        Select Sum(Nvl(t.Partweight, 0)) As Sum_Area
          From Bl_Putincase_Box t
         Inner Join Bl_Putincase_m T1
            On T1.Putincase_No = t.Putincase_No
           And T1.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
    --��ȡ�������������ϵ����������� =  Sum() 
    If Type_Id_ = 'SUM_WEIGHT_0' Then
      Open Cur_ For
        Select Sum(Nvl(t.Partweight, 0) + t.Casingweight) As Sum_Area
          From Bl_Putincase_Box t
         Inner Join Bl_Putincase_m T1
            On T1.Putincase_No = t.Putincase_No
           And T1.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    --��ȡ��������������(ֻ����) =  Sum() 
    If Type_Id_ = 'SUM_WEIGHT_1' Then
      Open Cur_ For
        Select Sum(t.Nweight + t.Cweight) As Sum_Area
          From Bl_Putintray_Tray t;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    --��ȡÿ�������ϵ���������(ֻ����)
    If Type_Id_ = 'SINGLE_TRAY_BOX_WEIGHT' Then
      Open Cur_ For
        Select (t.Nweight + t.Cweight) As Sum_Tray_Box_Weight
          From Bl_Putintray_Tray t
         Inner Join Bl_Putintray_m T1
            On T1.Putintray_No = t.Putintray_No
         Where t.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    --��ȡ���������������������ӣ� =  Sum() 
    If Type_Id_ = 'SUM_BOX_WEIGHT' Then
      Open Cur_ For
        Select Sum(Nvl(t.Partweight, 0) + t.Casingweight) As Sum_Area
          From Bl_Putincase_Box t
         Inner Join Bl_Putincase_m T1
            On T1.Putincase_No = t.Putincase_No
           And T1.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
    --��ȡ��������Ԥ�ƽ�������
    If Type_Id_ = 'DELDATE' Then
      Open Cur_ For
        Select t.Deldate
          From Bl_Picklist t
         Where t.Picklistno = Parmlist_
            Or t.Pickuniteno = Parmlist_;
    
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    --��ȡ���������������
    If Type_Id_ = 'VOLUME' Then
    
      Open Cur_ For
        Select t.Volume
          From Bl_Putintray_m t
         Where t.Putintray_No = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    --��ȡ�������ӵķ�̯����������
    If Type_Id_ = 'TRAYWEIGHT' Then
      Open Cur_ For
        Select t.Signtrayweight / t.Trayspace
          From Bl_Putintray_m t
         Where t.Putintray_No = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Nvl(Result_, 0);
    End If;
  
    --��ȡ�����������������
    If Type_Id_ = 'SUM_VOLUME' Then
      --��ȡ��������        
      Open Cur_ For
        Select Sum(Round(t.Volume *
                         (Select Count(Distinct T1.Putintray_Newline)
                            From Bl_Putincase_Box T1
                           Where T1.Putintray_No = t.Putintray_No),
                         4))
          From Bl_Putintray_m t
         Where t.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Open Cur_ For
        Select Sum(t.Casingarea)
          From Bl_Putincase_Box t
         Where t.Putintray_No = '-'
           And t.Putincase_No In
               (Select a.Putincase_No
                  From Bl_Putincase_m a
                 Where a.Picklistno = Parmlist_);
      Fetch Cur_
        Into Result1_;
      Close Cur_;
    
      Return Nvl(To_Number(Result_), 0) + Nvl(To_Number(Result1_), 0);
    End If;
  
    --��ȡ�����������������(ֻ����)
    If Type_Id_ = 'SUM_VOLUME_0' Then
      --��ȡ��������        
      Open Cur_ For
        Select Sum(Round(t.Volume *
                         (Select Count(Distinct T1.Putintray_Newline)
                            From Bl_Putincase_Box T1
                           Where T1.Putintray_No = t.Putintray_No),
                         4))
          From Bl_Putintray_m t
         Where t.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Open Cur_ For
        Select Sum(t.Casingarea)
          From Bl_Putincase_Box t
         Where t.Putintray_No = '-'
           And t.Putincase_No In
               (Select a.Putincase_No
                  From Bl_Putincase_m a
                 Where a.Picklistno = Parmlist_);
      Fetch Cur_
        Into Result1_;
      Close Cur_;
    
      Return Nvl(To_Number(Result_), 0);
    End If;
    -- ��ȡ�������̵ľ���
    If Type_Id_ = 'N_WEIGHT_TRAY' Then
      Open Cur_ For
        Select t.Nweight + t.Cweight
          From Bl_Putintray_Tray t
         Where t.Putintray_No = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    -- ��ȡ�������̵�������
    If Type_Id_ = 'SUM_WEIGHT_TRAY' Then
      Open Cur_ For
        Select t.Nweight + t.Cweight + t.Signtrayweight
          From Bl_Putintray_Tray t
         Where t.Putintray_No = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
    -- ��ȡ�������̵�ʵ��
    If Type_Id_ = 'FACTHEIGHT' Then
      Open Cur_ For
        Select t.Factheight
          From Bl_Putintray_Tray t
         Where t.Putintray_No = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    -- ��ȡ���������̵�����
    If Type_Id_ = 'SUM_WEIGHT_TRAY0' Then
      Open Cur_ For
        Select Sum((t.Nweight + t.Cweight + t.Signtrayweight) *
                   (Select Count(Distinct T1.Putintray_Newline)
                      From Bl_Putincase_Box T1
                     Where T1.Putintray_No = t.Putintray_No))
          From Bl_Putintray_m t
         Where t.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    -- ��������
    If Type_Id_ = 'Single_WEIGHT_TRAY' Then
      Open Cur_ For
        Select Sum((t.Signtrayweight) *
                   (Select Count(Distinct T1.Putintray_Newline)
                      From Bl_Putincase_Box T1
                     Where T1.Putintray_No = t.Putintray_No))
          From Bl_Putintray_m t
         Where t.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    -- ����������
  
    If Type_Id_ = 'TRAY_NUM' Then
      Open Cur_ For
        Select Count(Distinct T1.Putintray_Newline)
          From Bl_Putincase_Box T1
         Where T1.Putintray_No = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    -- ����ί�б��� ��װ����
    If Type_Id_ = 'Catalog_qty' Then
      Open Cur_ For
        Select Count(Distinct t.Box_Newline)
          From Bl_Putincase_Box t
         Where t.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  
    -- ����ί�б��� ����
    /*   If Type_Id_ = 'N_C_WEIGHT' Then
      Open Cur_ For
        Select (t.qty_pkg) *
               (nvl(t.partweight, 0) + nvl(t.casingweight, 0))
          From BL_V_PUTINCASE_M_DETAIL t
         Where t.Picklistno = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;*/
  
    -- ����ί�б�������  �۸񼰳ɽ�����
    If Type_Id_ = 'Price_type' Then
      Open Cur_ For
        Select t.Delivery_Desc
          From Bl_Picihead t
         Where t.Invoice_No = Parmlist_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Result_;
    End If;
  End;

  Function Get_Onebox_Qty(Putincase_No_ In Varchar2, Box_Line_ In Number)
    Return Number Is
    Result_ Number;
    Cur_    t_Cursor;
  Begin
    Open Cur_ For
      Select Sum(t.Qty)
        From Bl_Putincase_Box_Detail t
       Where t.Putincase_No = Putincase_No_
         And t.Box_Line = Box_Line_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  End;

  -- �ɹ��������� ��Ʊ  ���ܽ��
  Function Sum_Amount(Order_No_ In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    Open Cur_ For
      Select Sum(t.Amount) As Sum_Area
        From Bl_v_Purchase_Order_Line_Part t
       Where t.Order_No = Order_No_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  End;

  -- ����ί�б���  ����
  Function Get_Sum_Weight(Booking_No_ In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    Open Cur_ For
      Select Sum(Nvl(t.Partweight, 0)) As Sum_Area
        From Bl_Putincase_Box t
       Inner Join Bl_Putincase_m T1
          On T1.Putincase_No = t.Putincase_No
         And T1.Picklistno In
             (Select T2.Picklistno
                From Bl_v_Bookinglist_Dtl T2
               Where T2.Booking_No = Booking_No_);
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  End;

  -- ����ί�б��� ë��
  Function Get_Sum_Weight_a(Booking_No_ In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    Open Cur_ For
      Select Sum((t.Signtrayweight) *
                 (Select Count(Distinct T1.Putintray_Newline)
                    From Bl_Putincase_Box T1
                   Where T1.Putintray_No = t.Putintray_No))
        From Bl_Putintray_m t
       Where t.Picklistno In
             (Select T2.Picklistno
                From Bl_v_Bookinglist_Dtl T2
               Where T2.Booking_No = Booking_No_);
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Result_;
  End;

  -- ����ί�б��� �����
  Function Get_Sum_Area(Booking_No_ In Varchar2) Return Number Is
    Cur_     t_Cursor;
    Result_  Number;
    Result1_ Number;
  Begin
    Open Cur_ For
      Select Sum(Round(t.Volume *
                       (Select Count(Distinct T1.Putintray_Newline)
                          From Bl_Putincase_Box T1
                         Where T1.Putintray_No = t.Putintray_No),
                       4))
        From Bl_Putintray_m t
       Where t.Picklistno In
             (Select T2.Picklistno
                From Bl_v_Bookinglist_Dtl T2
               Where T2.Booking_No = Booking_No_);
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Open Cur_ For
      Select Sum(t.Casingarea)
        From Bl_Putincase_Box t
       Where t.Putintray_No = '-'
         And t.Putincase_No In
             (Select a.Putincase_No
                From Bl_Putincase_m a
               Where a.Picklistno In
                     (Select T2.Picklistno
                        From Bl_v_Bookinglist_Dtl T2
                       Where T2.Booking_No = Booking_No_));
    Fetch Cur_
      Into Result1_;
    Close Cur_;
  
    Return Nvl(To_Number(Result_), 0) + Nvl(To_Number(Result1_), 0);
  End;
End Bl_Putincase_Api;
/
