Create Or Replace Package Bl_v_Putintray_Detail_Api Is
  /* Created By WTL  2013-03-25 13:56:09*/
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

End Bl_v_Putintray_Detail_Api;
/
Create Or Replace Package Body Bl_v_Putintray_Detail_Api Is
  /* Created By WTL  2013-03-25 13:56:09*/
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
  
    -- pkg_a.Set_Item_Value('��COLUMN��','��VALUE��', attr_out);
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
    Objid_         Varchar2(50);
    Index_         Varchar2(1);
    Cur_           t_Cursor;
    Doaction_      Varchar2(10);
    Pos_           Number;
    Pos1_          Number;
    i              Number;
    v_             Varchar(1000);
    Column_Id_     Varchar(1000);
    Data_          Varchar(4000);
    Mysql_         Varchar(4000);
    Ifmychange     Varchar(1);
    Row_           Bl_v_Putintray_Detail%Rowtype;
    Mainrow_       Bl_v_Putintray%Rowtype;
    Putincase_Box_ Bl_v_Putincase_Box%Rowtype;
  Begin
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    If Doaction_ = 'I' Then
      --TRAYID
      Row_.Trayid := Pkg_a.Get_Item_Value('TRAYID', Rowlist_);
      Open Cur_ For
        Select t.* From Bl_v_Putintray t Where t.Trayid = Row_.Trayid;
      Fetch Cur_
        Into Mainrow_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(Pkg_a.Raise_Error, '�����Ѿ��������');
      End If;
      Close Cur_;
      If Mainrow_.State = '4' Then
      
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '��װ�����Ѿ��ύ�������޸����̣�');
      End If;
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
    
      --װ�����
      Row_.Putincase_No := Pkg_a.Get_Item_Value('PUTINCASE_NO', Rowlist_);
      --LINE_NO
      Row_.Line_No := Pkg_a.Get_Item_Value('LINE_NO', Rowlist_);
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase_Box t
         Where t.Putincase_No = Row_.Putincase_No
           And t.Line_No = Row_.Line_No;
      Fetch Cur_
        Into Putincase_Box_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '��������ӱ���' || Row_.Putincase_No || '-' ||
                                To_Char(Row_.Putincase_No));
      End If;
      Close Cur_;
      If Putincase_Box_.Putintray_No != '-' Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '����' || Row_.Putincase_No || '-' ||
                                To_Char(Row_.Putincase_No) || '�Ѿ��������(' ||
                                Putincase_Box_.Putintray_No || ')��');
      
      End If;
      Select Max(Putintray_Line_No)
        Into Putincase_Box_.Putintray_Line_No
        From Bl_Putincase_Box t
       Where t.Putintray_No = Mainrow_.Putintray_No
         And t.Putintray_Line = Mainrow_.Line_No;
      Putincase_Box_.Putintray_Line_No := Nvl(Putincase_Box_.Putintray_Line_No,
                                              0) + 1;
      Update Bl_Putincase_Box t
         Set t.Putintray_No      = Mainrow_.Putintray_No,
             t.Putintray_Line_No = Putincase_Box_.Putintray_Line_No,
             t.Putintray_Line    = Mainrow_.Line_No,
             t.Putintray_Newline = Mainrow_.Putintray_Sort,
             t.Putintray_Id      = Substr(To_Char(1000 +
                                                  Mainrow_.Putintray_Sort),
                                          2,
                                          3)
       Where t.Rowid = Putincase_Box_.Objid;
    
      Update Bl_Putintray t
         Set t.Detail_Change = Nvl(Detail_Change, 0) + 1
       Where t.Rowid = Mainrow_.Objid;
    
      Update Bl_Putintray t
         Set t.Detail_Change = Nvl(Detail_Change, 0) - 1000
       Where t.Putintray_No = Mainrow_.Putintray_No
         And t.Putintray_Detail = Mainrow_.Putintray_Detail
         And t.Putintray_Newline < Mainrow_.Putintray_Newline;
    
      Update Bl_Putintray t
         Set t.Detail_Change = Nvl(Detail_Change, 0) + 1000
       Where t.Putintray_No = Mainrow_.Putintray_No
         And t.Putintray_Detail = Mainrow_.Putintray_Detail
         And t.Putintray_Newline > Mainrow_.Putintray_Newline;
    
      Pkg_a.Setsuccess(A311_Key_,
                       'BL_V_PUTINTRAY_DETAIL',
                       Putincase_Box_.Objid);
      /*--װ����
      row_.DETAIL_LINE  := Pkg_a.Get_Item_Value('DETAIL_LINE', Rowlist_)
      --���
      row_.BOX_NUM  := Pkg_a.Get_Item_Value('BOX_NUM', Rowlist_)
      --״̬
      row_.STATE  := Pkg_a.Get_Item_Value('STATE', Rowlist_)
      --ENTER_DATE
      row_.ENTER_DATE  := Pkg_a.Get_Item_Value('ENTER_DATE', Rowlist_)
      --ENTER_USER
      row_.ENTER_USER  := Pkg_a.Get_Item_Value('ENTER_USER', Rowlist_)
      --MODI_DATE
      row_.MODI_DATE  := Pkg_a.Get_Item_Value('MODI_DATE', Rowlist_)
      --MODI_USER
      row_.MODI_USER  := Pkg_a.Get_Item_Value('MODI_USER', Rowlist_)
      --��ע
      row_.REMARK  := Pkg_a.Get_Item_Value('REMARK', Rowlist_)
      --���ӱ���
      row_.CASINGID  := Pkg_a.Get_Item_Value('CASINGID', Rowlist_)
      --���
      row_.CASINGDESCRIBE  := Pkg_a.Get_Item_Value('CASINGDESCRIBE', Rowlist_)
      --��������
      row_.CASINGWEIGHT  := Pkg_a.Get_Item_Value('CASINGWEIGHT', Rowlist_)
      --��
      row_.CASINGLENGTH  := Pkg_a.Get_Item_Value('CASINGLENGTH', Rowlist_)
      --��
      row_.CASINGWIDTH  := Pkg_a.Get_Item_Value('CASINGWIDTH', Rowlist_)
      --��
      row_.CASINGHEIGHT  := Pkg_a.Get_Item_Value('CASINGHEIGHT', Rowlist_)
      --װ����
      row_.CONTRACT  := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_)
      --ifs����
      row_.PART_NO  := Pkg_a.Get_Item_Value('PART_NO', Rowlist_)
      --��װ����
      row_.PACHAGE_NO  := Pkg_a.Get_Item_Value('PACHAGE_NO', Rowlist_)
      --��Ʒ����
      row_.PARTWEIGHT  := Pkg_a.Get_Item_Value('PARTWEIGHT', Rowlist_)
      --���
      row_.CASINGAREA  := Pkg_a.Get_Item_Value('CASINGAREA', Rowlist_)
      --BOX_NEWLINE
      row_.BOX_NEWLINE  := Pkg_a.Get_Item_Value('BOX_NEWLINE', Rowlist_)
      --BOX_QTY
      row_.BOX_QTY  := Pkg_a.Get_Item_Value('BOX_QTY', Rowlist_)
      --���̱���
      row_.PUTINTRAY_NO  := Pkg_a.Get_Item_Value('PUTINTRAY_NO', Rowlist_)
      --������
      row_.PUTINTRAY_LINE_NO  := Pkg_a.Get_Item_Value('PUTINTRAY_LINE_NO', Rowlist_)
      --�������
      row_.PUTINTRAY_LINE  := Pkg_a.Get_Item_Value('PUTINTRAY_LINE', Rowlist_)
      --���̺�
      row_.PUTINTRAY_ID  := Pkg_a.Get_Item_Value('PUTINTRAY_ID', Rowlist_)
      --��Ȩ��
      row_.TO_CONTRACT  := Pkg_a.Get_Item_Value('TO_CONTRACT', Rowlist_)
      --��Ȩ����
      row_.PUTRIGHT_NO  := Pkg_a.Get_Item_Value('PUTRIGHT_NO', Rowlist_)
      --��Ȩ��
      row_.PUTRIGHT_LINE  := Pkg_a.Get_Item_Value('PUTRIGHT_LINE', Rowlist_)
      --QTY
      row_.QTY  := Pkg_a.Get_Item_Value('QTY', Rowlist_)
      --PUTINTRAY_NEWLINE
      row_.PUTINTRAY_NEWLINE  := Pkg_a.Get_Item_Value('PUTINTRAY_NEWLINE', Rowlist_)
      --PUTINTRAY_DETAIL
      row_.PUTINTRAY_DETAIL  := Pkg_a.Get_Item_Value('PUTINTRAY_DETAIL', Rowlist_)
      --���ر���
      row_.CIQ_NO  := Pkg_a.Get_Item_Value('CIQ_NO', Rowlist_)
      --�����ӱ���
      row_.LINEID  := Pkg_a.Get_Item_Value('LINEID', Rowlist_)
      --�Ƿ��̯����
      row_.WENT_TAG  := Pkg_a.Get_Item_Value('WENT_TAG', Rowlist_)
      --TRAYWEIGHT
      row_.TRAYWEIGHT  := Pkg_a.Get_Item_Value('TRAYWEIGHT', Rowlist_)
      --PICKLISTNO
      row_.PICKLISTNO  := Pkg_a.Get_Item_Value('PICKLISTNO', Rowlist_)*/
      Return;
    End If;
    --�޸�
    If Doaction_ = 'M' Then
      /*
             Open Cur_ For
              Select t.* From BL_V_PUTINTRAY_DETAIL t Where t.Objid = Objid_;
            Fetch Cur_
              Into Row_;
            If Cur_%Notfound Then
              Raise_Application_Error(Pkg_a.Raise_Error,'�����rowid��');      
            End If;
            Close Cur_;
            Data_      := Rowlist_;
            Pos_       := Instr(Data_, Index_);
            i          := i + 1;
            Mysql_     :='update BL_V_PUTINTRAY_DETAIL SET ';
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
      
      --��������޸�--
      If Ifmychange ='1' Then 
         Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User ='''|| User_Id_ ||''''; 
         Mysql_ := Mysql_ || 'Where Rowid ='''|| Objid_ ||'''';
      -- raise_application_error(Pkg_a.Raise_Error, mysql_);
         Execute Immediate Mysql_;
      End If;
      
      --���óɹ��ı�־
      Pkg_a.Setsuccess(A311_Key_,'BL_V_PUTINTRAY_DETAIL', Objid_); */
      Return;
    End If;
    --ɾ��
    If Doaction_ = 'D' Then
      Open Cur_ For
        Select t.* From Bl_v_Putintray_Detail t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_ %Notfound Then
        Close Cur_;
        Raise_Application_Error(Pkg_a.Raise_Error, '�����rowid');
        Return;
      End If;
      Close Cur_;
    
      --TRAYID
      Open Cur_ For
        Select t.* From Bl_v_Putintray t Where t.Trayid = Row_.Trayid;
      Fetch Cur_
        Into Mainrow_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(Pkg_a.Raise_Error, '�����Ѿ��������');
      End If;
      Close Cur_;
      If Mainrow_.State = '4' Then
      
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '��װ�����Ѿ��ύ�������޸����̣�');
      End If;
      If Row_.Putintray_No <> Mainrow_.Putintray_No Or
         Row_.Putintray_Line <> Mainrow_.Line_No Then
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '����' || Row_.Putincase_No || '-' ||
                                To_Char(Row_.Putincase_No) || '�Ѿ���������(' ||
                                Putincase_Box_.Putintray_No || ')�ϣ�');
      
      End If;
    
      Update Bl_Putincase_Box t
         Set t.Putintray_No      = '-',
             t.Putintray_Line_No = 0,
             t.Putintray_Line    = 0,
             t.Putintray_Newline = 0,
             t.Putintray_Id      = Null
       Where t.Rowid = Row_.Objid;
      Update Bl_Putintray t
         Set t.Detail_Change = Nvl(Detail_Change, 0) + 1
       Where t.Rowid = Mainrow_.Objid;
      Update Bl_Putintray t
         Set t.Detail_Change = Nvl(Detail_Change, 0) - 1000
       Where t.Putintray_No = Mainrow_.Putintray_No
         And t.Putintray_Detail = Mainrow_.Putintray_Detail
         And t.Putintray_Newline < Mainrow_.Putintray_Newline;
    
      Update Bl_Putintray t
         Set t.Detail_Change = Nvl(Detail_Change, 0) + 1000
       Where t.Putintray_No = Mainrow_.Putintray_No
         And t.Putintray_Detail = Mainrow_.Putintray_Detail
         And t.Putintray_Newline > Mainrow_.Putintray_Newline;
    
      Pkg_a.Setsuccess(A311_Key_,
                       'BL_V_PUTINTRAY_DETAIL',
                       Putincase_Box_.Objid);
      --      DELETE FROM BL_V_PUTINTRAY_DETAIL T WHERE T.ROWID = OBJID_; */
      --���óɹ��ı�־
      --pkg_a.Setsuccess(A311_Key_,'BL_V_PUTINTRAY_DETAIL', Objid_);
      Return;
    End If;
  
  End;
  /*    �з����仯��ʱ��
      Column_Id_   ��ǰ�޸ĵ���
      Mainrowlist_ ���������� ��ϸ��ֵ������Ϊ��
      Rowlist_  ��ǰ�е����� 
      User_Id_  ��ǰ�û�
      Outrowlist_  ���������   
  */
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2) Is
    Attr_Out         Varchar2(4000);
    Row_             Bl_v_Putintray_Detail%Rowtype;
    Putincase_Box_s_ Bl_v_Putincase_Box%Rowtype;
    Cur_             t_Cursor;
  Begin
    --
    If Column_Id_ = 'BOX_KEY' Then
      Putincase_Box_s_.Box_Key      := Pkg_a.Get_Item_Value('BOX_KEY',
                                                            Rowlist_);
      Putincase_Box_s_.Putincase_No := Pkg_a.Get_Str_(Putincase_Box_s_.Box_Key,
                                                      '-',
                                                      1);
      Putincase_Box_s_.Line_No      := Pkg_a.Get_Str_(Putincase_Box_s_.Box_Key,
                                                      '-',
                                                      2);
    
      Open Cur_ For
        Select t.*
          From Bl_v_Putincase_Box t
         Where t.Putincase_No = Putincase_Box_s_.Putincase_No
           And t.Line_No = Putincase_Box_s_.Line_No
           And t.Putintray_No = '-';
      Fetch Cur_
        Into Putincase_Box_s_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error, '���������');
      
      End If;
      Close Cur_;
      Pkg_a.Set_Item_Value('PUTINCASE_NO',
                           Putincase_Box_s_.Putincase_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('LINE_NO', Putincase_Box_s_.Line_No, Attr_Out);
      Pkg_a.Set_Item_Value('DETAIL_LINE',
                           Putincase_Box_s_.Detail_Line,
                           Attr_Out);
      Pkg_a.Set_Item_Value('BOX_NUM', Putincase_Box_s_.Box_Num, Attr_Out);
      Pkg_a.Set_Item_Value('STATE', Putincase_Box_s_.State, Attr_Out);
      Pkg_a.Set_Item_Value('REMARK', Putincase_Box_s_.Remark, Attr_Out);
      Pkg_a.Set_Item_Value('CASINGID', Putincase_Box_s_.Casingid, Attr_Out);
      Pkg_a.Set_Item_Value('CASINGDESCRIBE',
                           Putincase_Box_s_.Casingdescribe,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CASINGWEIGHT',
                           Putincase_Box_s_.Casingweight,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CASINGLENGTH',
                           Putincase_Box_s_.Casinglength,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CASINGWIDTH',
                           Putincase_Box_s_.Casingwidth,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CASINGHEIGHT',
                           Putincase_Box_s_.Casingheight,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CONTRACT', Putincase_Box_s_.Contract, Attr_Out);
      Pkg_a.Set_Item_Value('PART_NO', Putincase_Box_s_.Part_No, Attr_Out);
      Pkg_a.Set_Item_Value('PACHAGE_NO',
                           Putincase_Box_s_.Pachage_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PARTWEIGHT',
                           Putincase_Box_s_.Partweight,
                           Attr_Out);
      Pkg_a.Set_Item_Value('CASINGAREA',
                           Putincase_Box_s_.Casingarea,
                           Attr_Out);
      Pkg_a.Set_Item_Value('BOX_NEWLINE',
                           Putincase_Box_s_.Box_Newline,
                           Attr_Out);
      Pkg_a.Set_Item_Value('BOX_QTY', Putincase_Box_s_.Box_Qty, Attr_Out);
      Pkg_a.Set_Item_Value('PUTINTRAY_NO',
                           Putincase_Box_s_.Putintray_No,
                           Attr_Out);
    
      Pkg_a.Set_Item_Value('PUTINTRAY_LINE_NO',
                           Putincase_Box_s_.Putintray_Line_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PUTINTRAY_LINE',
                           Putincase_Box_s_.Putintray_Line,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PUTINTRAY_ID',
                           Putincase_Box_s_.Putintray_Id,
                           Attr_Out);
      Pkg_a.Set_Item_Value('TO_CONTRACT',
                           Putincase_Box_s_.To_Contract,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PUTRIGHT_NO',
                           Putincase_Box_s_.Putright_No,
                           Attr_Out);
      Pkg_a.Set_Item_Value('PUTRIGHT_LINE',
                           Putincase_Box_s_.Putright_Line,
                           Attr_Out);
      Pkg_a.Set_Item_Value('WENT_TAG', Putincase_Box_s_.Went_Tag, Attr_Out);
      Pkg_a.Set_Item_Value('CIQ_NO', Putincase_Box_s_.Ciq_No, Attr_Out);
      Pkg_a.Set_Item_Value('LINEID', Putincase_Box_s_.Lineid, Attr_Out);
    
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
    Row_ Bl_v_Putintray%Rowtype;
    Cur_ t_Cursor;
  Begin
    Open Cur_ For
      Select t.* From Bl_v_Putintray t Where t.Trayid = Key_;
    Fetch Cur_
      Into Row_;
    Close Cur_;
  
    If Row_.State = '4' Then
      Return '0';
    End If;
    If Dotype_ = 'Add_Row' Then
      Return '1';
    End If;
    If Dotype_ = 'Del_Row' Then
      Return '1';
    End If;
    Return '1';
  End;

  /*  ʵ��ҵ���߼������е� �༭��
    Doaction_   I M ��ϸ�϶�Ϊ M   I ���� M �޸� ҳ�������� ��ǰ�����е� �����Ե��Ժ� ����  
    Column_Id_  ��
    Rowlist_  ��ǰ�е�����
    ����: 1 ����
    0 ������
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    Row_ Bl_v_Putintray_Detail%Rowtype;
  Begin
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    If Nvl(Row_.Objid, 'NULL') <> 'NULL' Then
    
      Return '0';
    End If;
  
    Return '1';
  End;

End Bl_v_Putintray_Detail_Api;
/
