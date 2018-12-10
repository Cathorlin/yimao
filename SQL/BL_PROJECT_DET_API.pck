CREATE OR REPLACE PACKAGE BL_PROJECT_DET_API IS
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

END BL_PROJECT_DET_API;
/
CREATE OR REPLACE PACKAGE BODY BL_PROJECT_DET_API IS
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
    LINEROW_   BL_V_PROJECT_DET%rowtype;
    ROW_       BL_PROJECT_DET%rowtype;
  BEGIN
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    IF Doaction_ = 'I' THEN
      --��Ŀ���
      ROW_.PROJECT_ID := Pkg_a.Get_Item_Value('PROJECT_ID', Rowlist_);
      --��Ŀ��
      ROW_.ITEM := Pkg_a.Get_Item_Value('ITEM', Rowlist_);
      --�ͻ�
      ROW_.CUSTOMER_NO := Pkg_a.Get_Item_Value('CUSTOMER_NO', Rowlist_);
      --����
      ROW_.DESCRIPTION := Pkg_a.Get_Item_Value('DESCRIPTION', Rowlist_);
      --��ע
      ROW_.REMARK := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      --ENTER_USER
      ROW_.ENTER_USER := USER_ID_;
      --ENTER_DATE
      ROW_.ENTER_DATE := SYSDATE;
    
      open cur_ for
        select t.*
          from BL_V_PROJECT_DET t
         where t.ITEM = ROW_.ITEM
           AND T.PROJECT_ID = ROW_.PROJECT_ID;
      fetch cur_
        into LINEROW_;
      if cur_%found then
        close cur_;
        raise_application_error(-20101, '�����ظ�����Ŀ');
      end if;
      close cur_;
    
      SELECT MAX(T.LINE_NO)
        INTO ROW_.LINE_NO
        FROM BL_PROJECT_DET T
       WHERE T.PROJECT_ID = ROW_.PROJECT_ID;
    
      ROW_.LINE_NO := NVL(ROW_.LINE_NO, 0) + 1;
      INSERT INTO BL_PROJECT_DET
        (PROJECT_ID, LINE_NO)
      VALUES
        (ROW_.PROJECT_ID, ROW_.LINE_NO)
      RETURNING ROWID INTO OBJID_;
      UPDATE BL_PROJECT_DET SET ROW = ROW_ WHERE ROWID = OBJID_;
      pkg_a.Setsuccess(A311_Key_, 'BL_V_PROJECT_DET', Objid_);
    END IF;
    --�޸�
    IF Doaction_ = 'M' THEN
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      Open Cur_ For
        Select t.* From BL_V_PROJECT_DET t Where t.Objid = Objid_;
      Fetch Cur_
        Into LINEROW_;
      If Cur_%Notfound Then
        CLOSE CUR_;
        Raise_Application_Error(Pkg_a.Raise_Error, '�����rowid��');
        RETURN;
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := 'update BL_PROJECT_DET SET ';
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
      IF Ifmychange = '1' THEN
        open cur_ for
          select t.*
            from BL_V_PROJECT_DET t
           where t.ITEM = ROW_.ITEM
             AND T.PROJECT_ID = ROW_.PROJECT_ID;
        fetch cur_
          into LINEROW_;
        if cur_%found then
          close cur_;
          raise_application_error(-20101, '�����ظ�����Ŀ');
        end if;
        close cur_;
      END IF;
      --�û��Զ�����
      If Ifmychange = '1' Then
        Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User =''' ||
                  User_Id_ || '''Where Rowid =''' || Objid_ || '''';
        --  raise_application_error(Pkg_a.Raise_Error, mysql_);
        Execute Immediate Mysql_;
      End If;
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PROJECT_DET', Objid_);
      Return;
    End If;
    --ɾ��
    If Doaction_ = 'D' Then
      OPEN CUR_ FOR
        SELECT T.* FROM BL_V_PROJECT_DET T WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO LINEROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error, '�����rowid');
        return;
      end if;
      close cur_;
    
      DELETE FROM BL_PROJECT_DET T WHERE T.ROWID = OBJID_;
      pkg_a.Setsuccess(A311_Key_, 'BL_V_PROJECT_DET', Objid_);
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
    LINEROW_ BL_V_PROJECT_DET%rowtype;
    ROW_     BL_PROJECT_DET%rowtype;
  Begin
    LINEROW_.OBJID := PKG_A.Get_Item_Value('OBJID', ROWLIST_);
    IF NVL(LINEROW_.OBJID, 'NULL') <> 'NULL' THEN
      If Column_Id_ = 'ITEM' Then
        Return '0';
      ELSE
        RETURN '1';
      END IF;
    End If;
  End;

End BL_PROJECT_DET_API;
/
