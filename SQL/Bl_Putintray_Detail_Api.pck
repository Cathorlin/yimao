Create Or Replace Package Bl_Putintray_Detail_Api Is
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
  Function Get_Tpall_Qty(Putincase_No_ In Varchar2,
                         Detail_Line_  In Number,
                         Putright_No_  In Varchar2) Return Number;

  --��ȡ��������
  Function Get_Tp_Qty(Putincase_No_ In Varchar2,
                      Detail_Line_  In Number,
                      Putright_No_  In Varchar2) Return Number;
End Bl_Putintray_Detail_Api;
/
Create Or Replace Package Body Bl_Putintray_Detail_Api Is
  Type t_Cursor Is Ref Cursor;
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
    Attr_Out Varchar2(4000);
  Begin
    Attr_Out := '';
    Pkg_a.Set_Item_Value('STATE', '0', Attr_Out);
  
    -- pkg_a.Set_Item_Value('��COLUMN��', '��VALUE��', attr_out);
    Pkg_a.Setresult(A311_Key_, Attr_Out);
  End;
  --��ȡ�Ѵ����̵�����
  Function Get_Tp_Qty(Putincase_No_ In Varchar2,
                      Detail_Line_  In Number,
                      Putright_No_  In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    Open Cur_ For
      Select Sum(t.Qty)
        From Bl_Putintray_m_Detail t
       Where t.Putincase_No = Putincase_No_
         And t.Detail_Line = Detail_Line_
         And Nvl(t.Putright_No, '-') = Putright_No_;
    Fetch Cur_
      Into Result_;
    Close Cur_;
    Return Nvl(Result_, 0);
  
  End;
  --��ȡҪ�����̵�����
  Function Get_Tpall_Qty(Putincase_No_ In Varchar2,
                         Detail_Line_  In Number,
                         Putright_No_  In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
    Qty_    Number;
  Begin
    If Nvl(Putright_No_, '-') <> '-' Then
      Open Cur_ For
        Select t.Qty
          From Bl_Putright_m_Detail t
         Where t.Putincase_No = Putincase_No_
           And t.Putincase_Line_No = Detail_Line_
           And t.Putright_No = Putright_No_;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      Return Nvl(Result_, 0);
    Else
      If Detail_Line_ > 0 Then
        Open Cur_ For
          Select t.Box_Qty
            From Bl_Putincase_m_Detail t
           Where t.Putincase_No = Putincase_No_
             And t.Line_No = Detail_Line_;
      Else
        Open Cur_ For
          Select t.Box_Qty
            From Bl_Putincase_m_Detail t
           Where t.Putincase_No = Putincase_No_;
      End If;
      Fetch Cur_
        Into Result_;
      Close Cur_;
      --�۳��Ѿ���Ȩ������
      --�۳��Ѿ���Ȩ������      
      Open Cur_ For
        Select Sum(t.Qty)
          From Bl_Putright_m_Detail t
         Where t.Putincase_No = Putincase_No_
           And t.Putincase_Line_No = Detail_Line_
           And t.State = '2';
      Fetch Cur_
        Into Qty_;
      Close Cur_;
      Result_ := Nvl(Result_, 0) - Nvl(Qty_, 0);
      Return Nvl(Result_, 0);
    End If;
    Return 0;
  
  End;

  /*  �������� Modify__
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
  */
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Objid_         Varchar2(50);
    Index_         Varchar2(1);
    Cur_           t_Cursor;
    Doaction_      Varchar2(10);
    Row_           Bl_v_Putintray_m_Detail%Rowtype;
    Irow_          Bl_Putintray_m_Detail%Rowtype;
    Crow_          Bl_Putintray_m_Detail%Rowtype;
    Putincase_Box_ Bl_Putincase_Box%Rowtype;
    Pos_           Number;
    Pos1_          Number;
    i              Number;
    v_             Varchar(1000);
    Column_Id_     Varchar(1000);
    Data_          Varchar(4000);
    Mysql_         Varchar(4000);
    Ifmychange     Varchar(1);
    Mainrow_       Bl_Putintray_m%Rowtype;
    Qty_Pec_       Number;
  Begin
    -- Bl_Putintray_Api
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    If Doaction_ = 'I' Then
    
      Irow_.Putintray_No  := Pkg_a.Get_Item_Value('PUTINTRAY_NO', Rowlist_);
      Irow_.Putincase_Key := Pkg_a.Get_Item_Value('PUTINCASE_KEY', Rowlist_);
      --��Ȩ
      Irow_.Putright_No  := Pkg_a.Get_Item_Value('PUTRIGHT_NO', Rowlist_);
      Irow_.Putincase_No := Pkg_a.Get_Str_(Irow_.Putincase_Key, '-', 1);
      Irow_.Box_Line     := Pkg_a.Get_Str_(Irow_.Putincase_Key, '-', 2);
    
      Open Cur_ For
        Select t.*
          From Bl_Putintray_m_Detail t
         Where t.Putincase_No = Irow_.Putincase_No
           And t.Box_Line = Irow_.Box_Line
           And t.Putright_No = Irow_.Putright_No
           And t.State = '0';
      Fetch Cur_
        Into Crow_;
      If Cur_%Found Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                Irow_.Putincase_Key || '��' ||
                                Crow_.Putintray_No || '���ڣ������ظ�������');
      
      End If;
      Close Cur_;
    
      Irow_.Detail_Line := Pkg_a.Get_Item_Value('DETAIL_LINE', Rowlist_);
      Irow_.State       := '0';
      Irow_.Enter_Date  := Sysdate;
      Irow_.Enter_User  := User_Id_;
      Irow_.Contract    := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Irow_.To_Contract := Pkg_a.Get_Item_Value('TO_CONTRACT', Rowlist_);
      Irow_.Remark      := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      Irow_.Putright_No := Pkg_a.Get_Item_Value('PUTRIGHT_NO', Rowlist_);
      Irow_.Qty         := Pkg_a.Get_Item_Value('QTY', Rowlist_);
      Irow_.Qty_Pec     := Pkg_a.Get_Item_Value('QTY_PEC', Rowlist_);
      Select Max(Line_No)
        Into Irow_.Line_No
        From Bl_Putintray_m_Detail t
       Where t.Putintray_No = Irow_.Putintray_No;
      Irow_.Line_No := Nvl(Irow_.Line_No, 0) + 1;
    
      Insert Into Bl_Putintray_m_Detail
        (Putintray_No,
         Line_No,
         Putincase_No,
         Detail_Line,
         Box_Line,
         Putincase_Key,
         State,
         Enter_Date,
         Enter_User,
         Modi_Date,
         Modi_User,
         Contract,
         To_Contract,
         Remark,
         Qty,
         Putright_No,
         Qty_Pec)
      Values
        (Irow_.Putintray_No,
         Irow_.Line_No,
         Irow_.Putincase_No,
         Irow_.Detail_Line,
         Irow_.Box_Line,
         Irow_.Putincase_Key,
         Irow_.State,
         Irow_.Enter_Date,
         Irow_.Enter_User,
         Irow_.Modi_Date,
         Irow_.Modi_User,
         Irow_.Contract,
         Irow_.To_Contract,
         Irow_.Remark,
         Irow_.Qty,
         Irow_.Putright_No,
         Irow_.Qty_Pec)
      Returning Rowid Into Objid_;
      Row_ .Putintray_No := Irow_.Putintray_No;
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      Pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
    End If;
    --�޸�
    If Doaction_ = 'M' Then
      Open Cur_ For
        Select t.* From Bl_v_Putintray_m_Detail t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error, '�����rowid��');
      
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := 'update Bl_Putintray_m_Detail set  ';
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
          Ifmychange := '1';
          v_         := Substr(v_, Pos1_ + 1);
          Mysql_     := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
        End If;
      
      End Loop;
    
      --�û��Զ�����
      If Ifmychange = '1' Then
        Mysql_ := Mysql_ || 'modi_date=sysdate,modi_user=''' || User_Id_ || '''';
        Mysql_ := '' || Mysql_ || ' WHERE rowid=''' || Row_.Objid || '''';
        -- raise_application_error(-20101, mysql_);
        Execute Immediate Mysql_;
      End If;
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINTRAY_M_DETAIL', Row_.Objid);
    
      --pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
    
    End If;
    --ɾ��
    If Doaction_ = 'D' Then
      Open Cur_ For
        Select t.* From Bl_v_Putintray_m_Detail t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error, '�����rowid��');
      
      End If;
      Close Cur_;
      Delete From Bl_Putintray_m_Detail Where Rowid = Objid_;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PUTINTRAY_M_DETAIL', Row_.Objid);
      --pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
    End If;
  
    Open Cur_ For
      Select t.*
        From Bl_Putintray_m t
       Where t.Putintray_No = Row_.Putintray_No;
    Fetch Cur_
      Into Mainrow_;
    Close Cur_;
  
    Open Cur_ For
      Select Sum(Nvl(Qty_Pec, 0))
        From Bl_Putintray_m_Detail t
       Where t.Putintray_No = Mainrow_.Putintray_No;
    Fetch Cur_
      Into Qty_Pec_;
    Close Cur_;
    /*  Raise_Application_Error(Pkg_a.Raise_Error,
                                Row_.Putintray_No || '�����rowid��' || Qty_Pec_);
    */
    If Nvl(Qty_Pec_, 0) > 0 Then
      Update Bl_Putintray_m_Detail t
         Set Qty_Tp = Round(t.Qty_Pec * Mainrow_.Trayspace / Qty_Pec_, 6)
       Where t.Putintray_No = Mainrow_.Putintray_No;
    End If;
  
    Open Cur_ For
      Select Sum(Nvl(t.Casingweight, 0) * t.Qty_Tp),
             Sum(Nvl(t.Partweight, 0) * t.Qty_Tp)
        From Bl_v_Putintray_m_Detail t
       Where t.Putintray_No = Row_.Putintray_No;
    Fetch Cur_
      Into Mainrow_.Cweight, Mainrow_.Nweight;
    Close Cur_;
  
    Update Bl_Putintray_m t
       Set t.Nweight = Mainrow_.Nweight, t.Cweight = Mainrow_.Cweight
     Where t.Putintray_No = Row_.Putintray_No;
  
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
    Attr_Out       Varchar2(4000);
    Cur_           t_Cursor;
    Putincase_Box_ Bl_v_Putincase_V03%Rowtype;
    Row_           Bl_v_Putintray_m_Detail%Rowtype;
  Begin
    If Column_Id_ = 'QTY' Then
      Row_.Qty := Pkg_a.Get_Item_Value('QTY', Rowlist_);
      Pkg_a.Set_Item_Value('QTY_PEC', Row_.Qty, Attr_Out);
    End If;
    If Column_Id_ = 'PUTINCASE_KEY' Then
      Row_.Putincase_Key := Pkg_a.Get_Item_Value('PUTINCASE_KEY', Rowlist_);
      Row_.Putintray_No  := Pkg_a.Get_Str_(Row_.Putincase_Key, '-', 1);
      Row_.Box_Line      := Pkg_a.Get_Str_(Row_.Putincase_Key, '-', 2);
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase_V03 t
         Where t.Putincase_No = Row_.Putintray_No
           And t.Line_No = Row_.Box_Line;
      Fetch Cur_
        Into Putincase_Box_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                'ѡ��' || Row_.Putincase_Key || '����');
      
      End If;
      Close Cur_;
      Row_.Contract    := Putincase_Box_.Supplier;
      Row_.To_Contract := Putincase_Box_.To_Contract;
    
      Row_.Qty := Putincase_Box_.Box_Qty - Putincase_Box_.Tp_Qty;
      Pkg_a.Set_Item_Value('QTY', Row_.Qty, Attr_Out);
      Pkg_a.Set_Item_Value('QTY_PEC', Row_.Qty, Attr_Out);
    
      Row_.Detail_Line := Putincase_Box_.Line_No;
      Pkg_a.Set_Item_Value('DETAIL_LINE', Row_.Detail_Line, Attr_Out);
      Pkg_a.Set_Item_Value('CONTRACT', Row_.Contract, Attr_Out);
    
      Pkg_a.Set_Item_Value('TO_CONTRACT', Row_.To_Contract, Attr_Out);
      Pkg_a.Set_Item_Value('PUTINTRAY_NO', Row_.Putintray_No, Attr_Out);
    
      Pkg_a.Set_Item_Value('CATALOG_NO',
                           Putincase_Box_.Catalog_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CATALOG_DESC',
                           Putincase_Box_.Catalog_Desc,
                           Attr_Out);
    
      Pkg_a.Set_Item_Value('CUSTOMER_PART_NO',
                           Putincase_Box_.Customer_Part_No,
                           Attr_Out);
    
      Pkg_a.Set_Item_Value('PACK_FLAG', Putincase_Box_.Pack_Flag, Attr_Out);
    
      Pkg_a.Set_Item_Value('PACK_FLAG_NAME',
                           Putincase_Box_.Pack_Flag_Name,
                           Attr_Out);
    
      Pkg_a.Set_Item_Value('PUTRIGHT_NO',
                           Putincase_Box_.Putright_No,
                           Attr_Out);
    
      Pkg_a.Set_Item_Value('BOX_LINE', Row_.Box_Line, Attr_Out);
      Row_.Casingid := Putincase_Box_.Casingid;
      Pkg_a.Set_Item_Value('CASINGID', Row_.Casingid, Attr_Out);
      Row_.Casingdescribe := Putincase_Box_.Casingdescribe;
      Pkg_a.Set_Item_Value('CASINGDESCRIBE', Row_.Casingdescribe, Attr_Out);
      Row_.Casingweight := Putincase_Box_.Casingweight;
      Pkg_a.Set_Item_Value('CASINGWEIGHT', Row_.Casingweight, Attr_Out);
      Row_.Casinglength := Putincase_Box_.Casinglength;
      Pkg_a.Set_Item_Value('CASINGLENGTH', Row_.Casinglength, Attr_Out);
      Row_.Casingwidth := Putincase_Box_.Casingwidth;
      Pkg_a.Set_Item_Value('CASINGWIDTH', Row_.Casingwidth, Attr_Out);
      Row_.Casingheight := Putincase_Box_.Casingheight;
      Pkg_a.Set_Item_Value('CASINGHEIGHT', Row_.Casingheight, Attr_Out);
      Row_.Partweight := Putincase_Box_.Partweight;
      Pkg_a.Set_Item_Value('PARTWEIGHT', Row_.Partweight, Attr_Out);
      Row_.Casingarea := Putincase_Box_.Casingarea;
      Pkg_a.Set_Item_Value('CASINGAREA', Row_.Casingarea, Attr_Out);
    
      /*      --���и�ֵ
      Pkg_a.Set_Item_Value('��COLUMN��', '��VALUE��', Attr_Out);
      --�����в�����
      Pkg_a.Set_Column_Enable('��COLUMN��', '0', Attr_Out);
      --�����п���
      Pkg_a.Set_Column_Enable('��COLUMN��', '1', Attr_Out);*/
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
    Cur_     t_Cursor;
    Mainrow_ Bl_v_Putintray_m%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putintray_m t Where t.Putintray_No = Key_;
    Fetch Cur_
      Into Mainrow_;
    Close Cur_;
    If Mainrow_.State = '0' Then
      Return '1';
    End If;
    Return '0';
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
    Row_ Bl_v_Putintray_m_Detail%Rowtype;
  Begin
    If Column_Id_ = 'REAMRK' Then
      Return '1';
    End If;
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    If Nvl(Row_.Objid, 'NULL') = 'NULL' Then
      Return '1';
    End If;
  
    Row_.State := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    If Column_Id_ = 'QTY' And Row_.State = '0' Then
      Return '1';
    End If;
  
    Return '0';
  
    Return '1';
  End;

End Bl_Putintray_Detail_Api;
/
