CREATE OR REPLACE PACKAGE BL_PLAN_LOCATION_CUSTOMER_API IS
  /* Created By LD  2013-03-25 09:34:17*/
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

END BL_PLAN_LOCATION_CUSTOMER_API;
/
CREATE OR REPLACE PACKAGE BODY BL_PLAN_LOCATION_CUSTOMER_API IS
  /* Created By LD  2013-03-25 09:34:17*/
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
    row_       BL_V_PLAN_LOCATION_CUSTOMER%rowtype;
    MAINROW_   BL_PLAN_LOCATION_CUSTOMER%rowtype;
  BEGIN
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    IF Doaction_ = 'I' THEN
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
    
      --��λ��
      MAINROW_.LOCATION_NO := Pkg_a.Get_Item_Value('LOCATION_NO', Rowlist_);
      --��
      MAINROW_.CONTRACT := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      --�ͻ���
      MAINROW_.CUSTOMER_NO := Pkg_a.Get_Item_Value('CUSTOMER_NO', Rowlist_);
      --״̬
      MAINROW_.STATE := '0';
      --����
      MAINROW_.REMARK := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      --ENTER_DATE
      MAINROW_.ENTER_DATE := sysdate;
      --ENTER_USER
      MAINROW_.ENTER_USER := user_id_;
      --�����
      MAINROW_.PART_NO := Pkg_a.Get_Item_Value('PART_NO', Rowlist_);
    
      BL_CUSTOMER_ORDER_API.Getseqno('PL' || To_Char(Sysdate, 'YYMM'),
                                     USER_ID_,
                                     4,
                                     MAINROW_.PLAN_LOCATION);
    
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_PLAN_LOCATION_CUSTOMER T
         WHERE T.LOCATION_NO = MAINROW_.LOCATION_NO
           AND T.CONTRACT = MAINROW_.CONTRACT
           AND T.CUSTOMER_NO = MAINROW_.CUSTOMER_NO
           AND T.PART_NO = MAINROW_.PART_NO;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %FOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '�����ظ�����');
        RETURN;
      END IF;
      CLOSE CUR_;
    
      INSERT INTO BL_PLAN_LOCATION_CUSTOMER
        (LOCATION_NO, CONTRACT, CUSTOMER_NO, PART_NO, PLAN_LOCATION)
      VALUES
        (MAINROW_.LOCATION_NO,
         MAINROW_.CONTRACT,
         MAINROW_.CUSTOMER_NO,
         MAINROW_.PART_NO,
         MAINROW_.PLAN_LOCATION)
      RETURNING ROWID INTO OBJID_;
      UPDATE BL_PLAN_LOCATION_CUSTOMER T
         SET ROW = MAINROW_
       WHERE T.ROWID = OBJID_;
      pkg_a.Setsuccess(A311_Key_, 'BL_V_PLAN_LOCATION_CUSTOMER', Objid_);
    
    END IF;
    --�޸�
    IF Doaction_ = 'M' THEN
    
      Open Cur_ For
        Select t.*
          From BL_V_PLAN_LOCATION_CUSTOMER t
         Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        CLOSE CUR_;
        Raise_Application_Error(Pkg_a.Raise_Error, '�����rowid��');
        RETURN;
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := 'update BL_PLAN_LOCATION_CUSTOMER SET ';
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
          Mysql_     := Mysql_ || Column_Id_ || '=''' || v_ || ''',';
        End If;
      End Loop;
    
      --��������޸�--
      If Ifmychange = '1' Then
        Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User =''' ||
                  User_Id_ || '''';
        Mysql_ := Mysql_ || 'Where Rowid =''' || Objid_ || '''';
        -- raise_application_error(Pkg_a.Raise_Error, mysql_);
        Execute Immediate Mysql_;
      End If;
    
      --���óɹ��ı�־
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PLAN_LOCATION_CUSTOMER', Objid_);
      Return;
    End If;
    --ɾ��
    If Doaction_ = 'D' Then
      /*OPEN CUR_ FOR
              SELECT T.* FROM BL_V_PLAN_LOCATION_CUSTOMER T WHERE T.ROWID = OBJID_;
            FETCH CUR_
              INTO ROW_;
            IF CUR_ %NOTFOUND THEN
              CLOSE CUR_;
              RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'�����rowid');
              return;
            end if;
            close cur_;
      --      DELETE FROM BL_V_PLAN_LOCATION_CUSTOMER T WHERE T.ROWID = OBJID_; */
      --���óɹ��ı�־
      --pkg_a.Setsuccess(A311_Key_,'BL_V_PLAN_LOCATION_CUSTOMER', Objid_);
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
    Attr_Out Varchar2(4000);
    row_     BL_V_PLAN_LOCATION_CUSTOMER%rowtype;
  Begin
    If Column_Id_ = '' Then
      --���и�ֵ
      Pkg_a.Set_Item_Value('��COLUMN��', '��VALUE��', Attr_Out);
      --�����в�����
      Pkg_a.Set_Column_Enable('��COLUMN��', '0', Attr_Out);
      --�����п���
      Pkg_a.Set_Column_Enable('��COLUMN��', '1', Attr_Out);
      --��������а�ť������
      --pkg_a.Set_Addrow_Enable('0',Attr_Out);
      --����ɾ���а�ť������
      --pkg_a.Set_Delrow_Enable('0',Attr_Out);
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
    row_ BL_V_PLAN_LOCATION_CUSTOMER%rowtype;
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
    Rowlist_  ��ǰ�е�����
    ����: 1 ����
    0 ������
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    row_ BL_V_PLAN_LOCATION_CUSTOMER%rowtype;
  Begin
    ROW_.OBJID := PKG_A.Get_Item_Value('OBJID', ROWLIST_);
    IF NVL(ROW_.OBJID, 'NULL') <> 'NULL' THEN
      IF COLUMN_ID_ = 'CONTRACT' OR COLUMN_ID_ = 'CUSTOMER_NO' OR
         COLUMN_ID_ = 'PART_NO' OR COLUMN_ID_ = 'LOCATION_NO' THEN
        RETURN '0';
      END IF;
    END IF;
    If Column_Id_ = '��COLUMN��' Then
      Return '0';
    End If;
    Return '1';
  End;

End BL_PLAN_LOCATION_CUSTOMER_API;
/
