Create Or Replace Package Bl_Putright_Api Is
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
  Function Get_Putright_Qty(Picklistno_   In Varchar2,
                            Order_No_     In Varchar2,
                            Line_No_      In Varchar2,
                            Rel_No_       In Varchar2,
                            Line_Item_No_ In Number) Return Number;
  --���
  Procedure Checkrow(Objid_      In Varchar2,
                     Checkstate_ In Varchar2,
                     Row_        Out Bl_v_Putright%Rowtype);
  --��Ȩ �ύ
  Procedure Deliver__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --��Ȩ ȷ��
  Procedure Approve__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2);
  --ȡ��ȷ��
  Procedure Cancelapprove__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2);
  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);

  Procedure Canceldeliver__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2);
  Function Get_Box_Qty(Putincase_No_ In Varchar2, Detail_Line_ In Varchar2)
    Return Number;
End Bl_Putright_Api;
/
Create Or Replace Package Body Bl_Putright_Api Is
  Type t_Cursor Is Ref Cursor;
  --��COLUMN��  ������ ��ʵ�ʵ��߼� ��ʵ�ʵ�����
  -- ��VALUE��  �е����� �������ʵ���߼� �ö�Ӧ�Ĳ��������
  /*
  ����
  Raise_Application_Error(pkg_a.raise_error,'������ ����������');
  */

  /*  ������ʼ�� New__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���REQUSETURL ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ */
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
    Attr_Out Varchar2(4000);
  Begin
    Attr_Out := '';
  
    -- pkg_a.Set_Item_Value('��COLUMN��', '��VALUE��', attr_out);
    Pkg_a.Setresult(A311_Key_, Attr_Out);
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
    Row_       Bl_Putright_m%Rowtype;
    Mainrow_   Bl_v_Putright%Rowtype;
  Begin
  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    If Doaction_ = 'I' Then
      Bl_Customer_Order_Api.Getseqno('S' || To_Char(Sysdate, 'YYMM'),
                                     User_Id_,
                                     4,
                                     Row_.Putright_No);
      Row_.Picklistno  := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_);
      Row_.Contract    := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Row_.Remark      := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      Row_.Type_Id     := Pkg_a.Get_Item_Value('TYPE_ID', Rowlist_);
      Row_.State       := '0';
      Row_.To_Contract := Pkg_a.Get_Item_Value('TO_CONTRACT', Rowlist_);
      Row_.Enter_Date  := Sysdate;
      Row_.Enter_User  := User_Id_;
    
      If Nvl(Row_.To_Contract, '-') = '-' Then
        Raise_Application_Error(-20101, '��Ȩ�����');
        Return;
      End If;
      --����һ����������Ȩ ֻ�ܳ���һ��
      Open Cur_ For
        Select t.*
          From Bl_v_Putright t
         Where t.Picklistno = Row_.Picklistno
           And t.Contract = Row_.Contract
           And t.Type_Id = Row_.Type_Id
           And t.State In ('0', '1');
      Fetch Cur_
        Into Mainrow_;
      If Cur_ %Found Then
        Close Cur_;
        Raise_Application_Error(-20101,
                                Row_.Picklistno || '-' || Row_.Contract ||
                                '����δ�������Ȩ�����ȴ�����');
        Return;
      End If;
      Close Cur_;
      Insert Into Bl_Putright_m
        (Putright_No)
      Values
        (Row_.Putright_No)
      Returning Rowid Into Objid_;
      Update Bl_Putright_m t Set Row = Row_ Where Rowid = Objid_;
    
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT', Objid_);
    End If;
    --�޸�
    If Doaction_ = 'M' Then
      Open Cur_ For
        Select t.* From Bl_v_Putright t Where t.Objid = Objid_;
      Fetch Cur_
        Into Mainrow_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, '�����rowid');
        Return;
      End If;
      Close Cur_;
    
      Data_  := Rowlist_;
      Pos_   := Instr(Data_, Index_);
      i      := i + 1;
      Mysql_ := 'update BL_PUTRIGHT_M  set  ';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        v_         := Substr(v_, Pos1_ + 1);
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' Then
          Mysql_ := Mysql_ || '' || Column_Id_ || '=''' || v_ || ''',';
        End If;
      End Loop;
      Mysql_ := Mysql_ || 'modi_date=sysdate,modi_user=''' || User_Id_ ||
                ''' where rowid=''' || Objid_ || '''';
    
      Execute Immediate 'begin ' || Mysql_ || ';end;';
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT', Objid_);
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
    Row_         Bl_v_Putright%Rowtype;
    Mainrow_     Bl_Putright_m%Rowtype;
    Bl_Picklist_ Bl_Picklist%Rowtype;
    Cur_         t_Cursor;
  Begin
    If Column_Id_ = 'PICKLISTNO' Then
      Row_.Picklistno := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_);
      Open Cur_ For
        Select t.* From Bl_Picklist t Where t.Picklistno = Row_.Picklistno;
      Fetch Cur_
        Into Bl_Picklist_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error, '����ı�������');
        Return;
      End If;
      Close Cur_;
      Pkg_a.Set_Item_Value('CUSTOMER_REF',
                           Bl_Picklist_.Customerno,
                           Attr_Out);
      Pkg_a.Set_Item_Value('LOCATION', Bl_Picklist_.Location, Attr_Out);
    End If;
  
    /*      --���и�ֵ
    Pkg_a.Set_Item_Value('��COLUMN��', '��VALUE��', Attr_Out);
    --�����в�����
    Pkg_a.Set_Column_Enable('��COLUMN��', '0', Attr_Out);
    --�����п���
    Pkg_a.Set_Column_Enable('��COLUMN��', '1', Attr_Out);*/
  
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
    Mainrow_ Bl_Putright_m%Rowtype;
    Cur_     t_Cursor;
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
  
    Row_     Bl_v_Putright%Rowtype;
    Mainrow_ Bl_Putright_m%Rowtype;
    Cur_     t_Cursor;
  Begin
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    If Nvl(Row_.Objid, 'NULL') = 'NULL' Then
      Return '1';
    End If;
  
    If Column_Id_ = 'REMARK' Then
      Return '1';
    Else
      Return '0';
    End If;
  
    If Column_Id_ = '��COLUMN��' Then
      Return '0';
    End If;
    Return '1';
  End;
  --��ȡ������Ȩ������
  Function Get_Putright_Qty(Picklistno_   In Varchar2,
                            Order_No_     In Varchar2,
                            Line_No_      In Varchar2,
                            Rel_No_       In Varchar2,
                            Line_Item_No_ In Number) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    --��ȡ�Ѿ���Ȩ������  
    Select Nvl(Sum(T2.Qty), 0)
      Into Result_
      From Bl_Putright_m_Detail T2
     Where T2.Picklistno = Picklistno_
       And T2.Co_Order_No = Order_No_
       And T2.Co_Line_No = Line_No_
       And T2.Co_Rel_No = Rel_No_
       And T2.Co_Line_Item_No = Line_Item_No_
       And T2.State <> '3';
    Return(Nvl(Result_, 0));
  End;
  Procedure Checkrow(Objid_      In Varchar2,
                     Checkstate_ In Varchar2,
                     Row_        Out Bl_v_Putright%Rowtype) Is
    Cur_ t_Cursor;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putright t Where t.Objid = Objid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Raise_Application_Error(Pkg_a.Raise_Error, '�����rowid��');
    End If;
    Close Cur_;
    If Row_.State != Checkstate_ Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              '����״̬������ִ�е�ǰ������');
    End If;
  End;

  --��Ȩ �ύ
  Procedure Deliver__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
    Cur_       t_Cursor;
    Mainrow_   Bl_v_Putright%Rowtype;
    Detailrow_ Bl_v_Putright_Detail%Rowtype;
    Pickqty_   Number; --����������
    Pkgqty_    Number; --�Ѱ�װ����
  Begin
    Checkrow(Rowlist_, '0', Mainrow_);
    Update Bl_Putright_m t
       Set State = '1', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Rowid = Mainrow_.Objid;
  
    --�������
    Open Cur_ For
      Select t.*
        From Bl_v_Putright_Detail t
       Where t.Putright_No = Mainrow_.Putright_No;
    Fetch Cur_
      Into Detailrow_;
    If Cur_%Notfound Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              'û����ϸ�в�����ִ�е�ǰ������');
    End If;
    Loop
      Exit When Cur_%Notfound;
      --��Ʒ��Ȩ
      If Mainrow_.Type_Id = '0' Then
        --��⵱ǰ����Ȩ�Ƿ񳬹�������Ȩ������
        Pickqty_ := Bl_Putincase_Api.Get_Pk_Qty(Picklistno_   => Detailrow_.Picklistno,
                                                Order_No_     => Detailrow_.Co_Order_No,
                                                Line_No_      => Detailrow_.Co_Line_No,
                                                Rel_No_       => Detailrow_.Co_Rel_No,
                                                Line_Item_No_ => Detailrow_.Co_Line_Item_No,
                                                Putright_No_  => '-',
                                                Contract_     => Mainrow_.Contract);
        Pkgqty_  := Bl_Putincase_Api.Get_Pkg_Qty(Picklistno_   => Detailrow_.Picklistno,
                                                 Order_No_     => Detailrow_.Co_Order_No,
                                                 Line_No_      => Detailrow_.Co_Line_No,
                                                 Rel_No_       => Detailrow_.Co_Rel_No,
                                                 Line_Item_No_ => Detailrow_.Co_Line_Item_No,
                                                 Putright_No_  => '-',
                                                 Contract_     => Mainrow_.Contract);
        Pickqty_ := Pickqty_ - Pkgqty_;
        If Detailrow_.Qty > Pickqty_ Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '��Ȩ�������ܳ�����' ||
                                  Pickqty_);
        
        End If;
      End If;
    
      --������Ȩ
      If Mainrow_.Type_Id = '1' Then
        --��ȡ������Ȩ������
        Pickqty_ := Bl_Putintray_Detail_Api.Get_Tpall_Qty(Detailrow_.Putincase_No,
                                                          Detailrow_.Putincase_Line_No,
                                                          '-');
        --��⵱ǰ����Ȩ�Ƿ񳬹�������Ȩ������
      
        --�Ѵ����̵�����
        Pkgqty_  := Bl_Putintray_Detail_Api.Get_Tp_Qty(Detailrow_.Putincase_No,
                                                       Detailrow_.Putincase_Line_No,
                                                       '-');
        Pickqty_ := Pickqty_ - Pkgqty_;
        If Detailrow_.Qty > Pickqty_ Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '��Ȩ�������ܳ�����' ||
                                  Pickqty_);
        
        End If;
      End If;
      Update Bl_Putright_m_Detail t
         Set State = '1', Modi_Date = Sysdate, Modi_User = User_Id_
       Where t.Rowid = Detailrow_.Objid;
      Fetch Cur_
        Into Detailrow_;
    End Loop;
    Close Cur_;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '��Ȩ�ύ�ɹ�');
  
    --ֱ��ȷ��
    Approve__(Rowlist_, User_Id_, A311_Key_);
    Return;
  End;

  --��Ȩ ȷ��
  Procedure Approve__(Rowlist_  Varchar2,
                      User_Id_  Varchar2,
                      A311_Key_ Varchar2) Is
  
    Cur_           t_Cursor;
    Cur1_          t_Cursor;
    Mainrow_       Bl_v_Putright%Rowtype;
    Detailrow_     Bl_v_Putright_Detail%Rowtype;
    Putincase_Box_ Bl_v_Putincase_Box%Rowtype;
    Pickqty_       Number; --����������
    Pkgqty_        Number; --�Ѱ�װ����
  Begin
    Checkrow(Rowlist_, '1', Mainrow_);
  
    --�������
    Open Cur_ For
      Select t.*
        From Bl_v_Putright_Detail t
       Where t.Putright_No = Mainrow_.Putright_No;
    Fetch Cur_
      Into Detailrow_;
    If Cur_%Notfound Then
      Raise_Application_Error(Pkg_a.Raise_Error,
                              'û����ϸ�в�����ִ�е�ǰ������');
    End If;
    Loop
      Exit When Cur_%Notfound;
      If Mainrow_.Type_Id = '0' Then
        --��⵱ǰ����Ȩ�Ƿ񳬹�������Ȩ������
        Pickqty_ := Bl_Putincase_Api.Get_Pk_Qty(Picklistno_   => Detailrow_.Picklistno,
                                                Order_No_     => Detailrow_.Co_Order_No,
                                                Line_No_      => Detailrow_.Co_Line_No,
                                                Rel_No_       => Detailrow_.Co_Rel_No,
                                                Line_Item_No_ => Detailrow_.Co_Line_Item_No,
                                                Putright_No_  => '-',
                                                Contract_     => Mainrow_.Contract);
        Pkgqty_  := Bl_Putincase_Api.Get_Pkg_Qty(Picklistno_   => Detailrow_.Picklistno,
                                                 Order_No_     => Detailrow_.Co_Order_No,
                                                 Line_No_      => Detailrow_.Co_Line_No,
                                                 Rel_No_       => Detailrow_.Co_Rel_No,
                                                 Line_Item_No_ => Detailrow_.Co_Line_Item_No,
                                                 Putright_No_  => '-',
                                                 Contract_     => Mainrow_.Contract);
        Pickqty_ := Pickqty_ - Pkgqty_;
        If Detailrow_.Qty > Pickqty_ Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '��Ȩ�������ܳ�����' ||
                                  Pickqty_);
        
        End If;
      End If;
    
      --������Ȩ
      If Mainrow_.Type_Id = '1' Then
        --��ȡ������Ȩ������
        /* Pickqty_ := Bl_Putintray_Detail_Api.Get_Tpall_Qty(Detailrow_.Putincase_No,
        Detailrow_.Putincase_Line_No,
        '-');*/
        --��⵱ǰ����Ȩ�Ƿ񳬹�������Ȩ������
        --����Ȩ�����Ӵ��ϱ��
      
        --δ��Ȩ�������������
        -- Pkgqty_ := 0;
        Open Cur1_ For
          Select t.*
            From Bl_v_Putincase_Box t
           Where t.Putincase_No = Detailrow_.Putincase_No
             And t.Detail_Line = Detailrow_.Putincase_Line_No
             And t.Contract = t.Tp_Contract;
        Fetch Cur1_
          Into Putincase_Box_;
        Loop
          Exit When Cur1_%Notfound Or Detailrow_.Qty <= 0;
          --�������ӵ���Ȩ��
          Update Bl_Putincase_Box t
             Set t.To_Contract   = Mainrow_.To_Contract,
                 t.Putright_No   = Detailrow_.Putright_No,
                 t.Putright_Line = Detailrow_.Line_No
           Where t.Rowid = Putincase_Box_.Objid;
          Detailrow_.Qty := Detailrow_.Qty - 1;
          Fetch Cur1_
            Into Putincase_Box_;
        End Loop;
        Close Cur1_;
      
        If Detailrow_.Qty > 0 Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '��Ȩ��������');
        End If;
      
        --�Ѵ����̵�����
        /*    Pkgqty_  := Bl_Putintray_Detail_Api.Get_Tp_Qty(Detailrow_.Putincase_No,
        Detailrow_.Putincase_Line_No,
        '-');*/
        /*   Pickqty_ := Pickqty_ - Pkgqty_;
        If Detailrow_.Qty > Pickqty_ Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  Detailrow_.Catalog_No || '��Ȩ�������ܳ�����' ||
                                  Pickqty_);
        
        End If;*/
      End If;
      Update Bl_Putright_m_Detail t
         Set State = '2', Modi_Date = Sysdate, Modi_User = User_Id_
       Where t.Rowid = Detailrow_.Objid;
      Fetch Cur_
        Into Detailrow_;
    End Loop;
    Close Cur_;
    Update Bl_Putright_m t
       Set State = '2', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Rowid = Mainrow_.Objid;
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '��Ȩȷ�ϳɹ�');
    Return;
  End;

  Procedure Cancel__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Mainrow_ Bl_v_Putright%Rowtype;
  Begin
    Checkrow(Rowlist_, '0', Mainrow_);
    Update Bl_Putright_m t
       Set State = '3', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Rowid = Mainrow_.Objid;
  
    Update Bl_Putright_m_Detail t
       Set State = '3', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Putright_No = Mainrow_.Putright_No;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '��Ȩ���ϳɹ�');
    Return;
  End;
  --ȡ��ȷ��
  Procedure Cancelapprove__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2) Is
    Cur_           t_Cursor;
    Cur1_          t_Cursor;
    Mainrow_       Bl_v_Putright%Rowtype;
    Detailrow_     Bl_v_Putright_Detail%Rowtype;
    Putincase_Box_ Bl_v_Putincase_Box%Rowtype;
    Pickqty_       Number; --����������
    Pkgqty_        Number; --�Ѱ�װ����
  Begin
    Checkrow(Rowlist_, '2', Mainrow_);
  
    --�������
  
    If Mainrow_.Type_Id = '1' Then
      --�ж�״̬�Ƿ���װ��״̬ ���� û��װ����
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase_Box t
         Where t.Putright_No = Mainrow_.Putright_No
           And (t.State Not In ('1', '2') Or t.Putintray_No <> '-');
      Fetch Cur_
        Into Putincase_Box_;
      If Cur_%Found Then
        If Putincase_Box_.State <> '2' And Putincase_Box_.State <> '1' Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  '���' || Putincase_Box_.Box_Num ||
                                  '����װ��״̬������ȡ����Ȩ��');
        End If;
        If Putincase_Box_.Putintray_No <> '-' Then
          Raise_Application_Error(Pkg_a.Raise_Error,
                                  '���' || Putincase_Box_.Box_Num ||
                                  '�Ѿ��������ˣ�����ȡ����Ȩ��');
        End If;
      
      End If;
      Close Cur_;
    
      Update Bl_Putincase_Box t
         Set t.To_Contract   = t.Contract,
             t.Putright_No   = '-',
             t.Putright_Line = 0
       Where t.Putright_No = Mainrow_.Putright_No;
    End If;
  
    Update Bl_Putright_m t
       Set State = '1', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Rowid = Mainrow_.Objid;
  
    Update Bl_Putright_m_Detail t
       Set State = '1', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Putright_No = Mainrow_.Putright_No;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '��Ȩȡ��ȷ�ϳɹ�');
    --ȡ���ύ
    Canceldeliver__(Rowlist_, User_Id_, A311_Key_);
  End;

  Procedure Canceldeliver__(Rowlist_  Varchar2,
                            User_Id_  Varchar2,
                            A311_Key_ Varchar2) Is
    Mainrow_ Bl_v_Putright%Rowtype;
  Begin
    Checkrow(Rowlist_, '1', Mainrow_);
    Update Bl_Putright_m t
       Set State = '0', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Rowid = Mainrow_.Objid;
  
    Update Bl_Putright_m_Detail t
       Set State = '0', Modi_Date = Sysdate, Modi_User = User_Id_
     Where t.Putright_No = Mainrow_.Putright_No;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTRIGHT', Rowlist_);
    Pkg_a.Setmsg(A311_Key_, '', '��Ȩ�˻سɹ�');
    Return;
  End;

  Function Get_Box_Qty(Putincase_No_ In Varchar2, Detail_Line_ In Varchar2)
    Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    Select Count(*)
      Into Result_
      From Bl_Putincase_Box T2
     Where T2.Putincase_No = Putincase_No_
       And T2.Detail_Line = Detail_Line_;
    Return Result_;
  End;
End Bl_Putright_Api;
/
