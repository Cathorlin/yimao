CREATE OR REPLACE PACKAGE Bl_Picihead2_Api IS
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

END Bl_Picihead2_Api;
/
CREATE OR REPLACE PACKAGE BODY Bl_Picihead2_Api IS
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
  A311_Key_ A314������ */
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2) IS
    attr_out VARCHAR2(4000);
  BEGIN
    attr_out := '';
  
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
    Objid_     VARCHAR2(50);
    Index_     VARCHAR2(1);
    Cur_       t_Cursor;
    Doaction_  VARCHAR2(10);
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar(4000);
    Ifmychange Varchar(1);
    row_       BL_V_BL_PICIHEAD_V08%rowtype;
  BEGIN
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    IF Doaction_ = 'I' THEN
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      /*
      --��λ
      row_.ETD  := Pkg_a.Get_Item_Value('ETD', Rowlist_)
      --INVOICETYPE
      row_.INVOICETYPE  := Pkg_a.Get_Item_Value('INVOICETYPE', Rowlist_)
      --��Ʊ����
      row_.SHANGDATE  := Pkg_a.Get_Item_Value('SHANGDATE', Rowlist_)
      --��Ʊ���ڣ�990011��
      row_.INVOICE_DATE  := Pkg_a.Get_Item_Value('INVOICE_DATE', Rowlist_)
      --���ӻ�������
      row_.WEIGHTPALLET  := Pkg_a.Get_Item_Value('WEIGHTPALLET', Rowlist_)
      --���ӻ�������
      row_.HOWPALLET  := Pkg_a.Get_Item_Value('HOWPALLET', Rowlist_)
      --��������
      row_.ENGRENDER  := Pkg_a.Get_Item_Value('ENGRENDER', Rowlist_)
      --�ɽ���ʽ
      row_.DELIVERADDRESS  := Pkg_a.Get_Item_Value('DELIVERADDRESS', Rowlist_)
      --�鸶����
      row_.INVOICE_NO  := Pkg_a.Get_Item_Value('INVOICE_NO', Rowlist_)
      --��ַ��
      row_.CI_NO  := Pkg_a.Get_Item_Value('CI_NO', Rowlist_)
      --�鸶�ͻ�����
      row_.CICUSTNAME  := Pkg_a.Get_Item_Value('CICUSTNAME', Rowlist_)
      --�鸶�ͻ���ַ
      row_.CICUSTADDRESS  := Pkg_a.Get_Item_Value('CICUSTADDRESS', Rowlist_)*/
      RETURN;
    END IF;
    --�޸�
    IF Doaction_ = 'M' THEN
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      Open Cur_ For
        Select t.* From BL_V_BL_PICIHEAD_V08 t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error, '�����rowid��');
      
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := 'update BL_V_BL_PICIHEAD_V08 SET ';
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
          Mysql_     := Mysql_ || Column_Id_ || '= ''' || v_ || ''',';
        End If;
      
      End Loop;
    
      --�û��Զ�����
      If Ifmychange = '1' Then
        Mysql_ := Substr(Mysql_, 1, Length(Mysql_) - 1);
        Mysql_ := Mysql_ || 'Where Rowid =''' || Row_.Objid || '''';
        -- raise_application_error(Pkg_a.Raise_Error, mysql_);
        Execute Immediate Mysql_;
      End If;
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_BL_PICIHEAD_V08', Row_.Objid);
      Return;
    End If;
    --ɾ��
    If Doaction_ = 'D' Then
      /*OPEN CUR_ FOR
              SELECT T.* FROM BL_V_BL_PICIHEAD_V08 T WHERE T.ROWID = OBJID_;
            FETCH CUR_
              INTO ROW_;
            IF CUR_ %NOTFOUND THEN
              CLOSE CUR_;
              RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'�����rowid');
              return;
            end if;
            close cur_;
      --      DELETE FROM BL_V_BL_PICIHEAD_V08 T WHERE T.ROWID = OBJID_; */
      --pkg_a.Setsuccess(A311_Key_,'BL_V_BL_PICIHEAD_V08', Objid_);
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
    Attr_Out Varchar2(4000);
  Begin
    If Column_Id_ = '' Then
      --���и�ֵ
      Pkg_a.Set_Item_Value('��COLUMN��', '��value��', Attr_Out);
      --�����в�����
      Pkg_a.Set_Column_Enable('��column��', '0', Attr_Out);
      --�����п���
      Pkg_a.Set_Column_Enable('��column��', '1', Attr_Out);
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
      Rowlist_  ��ǰ�û�
      ����: 1 ����
      0 ������
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
  Begin
    If Column_Id_ = '��column��' Then
      Return '0';
    End If;
    Return '1';
  End;

End Bl_Picihead2_Api;
/
