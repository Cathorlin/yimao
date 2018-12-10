CREATE OR REPLACE PACKAGE BL_PRODUCTION_LINE_API IS
  /* Created By LD  2013-03-19 10:20:23*/
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

END BL_PRODUCTION_LINE_API;
/
CREATE OR REPLACE PACKAGE BODY BL_PRODUCTION_LINE_API IS
  /* Created By LD  2013-03-19 10:20:23*/
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
    attr_out    VARCHAR2(4000);
    info_       VARCHAR2(4000);
    objid_      VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    attr_       VARCHAR2(4000);
    action_     VARCHAR2(4000);
  BEGIN
    attr_out := '';
    Action_  := 'PREPARE';
    IFSAPP.PRODUCTION_LINE_API.NEW__(info_,
                                     objid_,
                                     objversion_,
                                     attr_,
                                     action_);
    attr_out := PKG_A.Get_Attr_By_Ifs(attr_);
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
    Objid_      VARCHAR2(50);
    Index_      VARCHAR2(1);
    Cur_        t_Cursor;
    Doaction_   VARCHAR2(10);
    Pos_        Number;
    Pos1_       Number;
    i           Number;
    v_          Varchar(1000);
    Column_Id_  Varchar(1000);
    Data_       Varchar(4000);
    Mysql_      Varchar(4000);
    Ifmychange  Varchar(1);
    row_        BL_V_PRODUCTION_LINE%rowtype;
    MAINROW_    BL_PRODUCTION_LINE%rowtype;
    info_       VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    attr_       VARCHAR2(4000);
    action_     VARCHAR2(4000);
    OBJID__     VARCHAR2(4000);
  BEGIN
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    IF Doaction_ = 'I' THEN
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
    
      --�����ⲿԤ��/����
      ROW_.RESERVE_FLAG_DB := Pkg_a.Get_Item_Value('RESERVE_FLAG_DB',
                                                   Rowlist_);
      --������ʶ��
      ROW_.CALENDAR_ID := Pkg_a.Get_Item_Value('CALENDAR_ID', Rowlist_);
      --������
      ROW_.CONTRACT_DESCRIPTION := Pkg_a.Get_Item_Value('CONTRACT_DESCRIPTION',
                                                        Rowlist_);
      --��
      MAINROW_.CONTRACT := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      --������
      MAINROW_.PRODUCTION_LINE  := Pkg_a.Get_Item_Value('PRODUCTION_LINE',
                                                        Rowlist_);
      MAINROW_.IPADDRESS        := PKG_A.Get_Item_Value('IPADDRESS',
                                                        ROWLIST_);
      MAINROW_.PRODUCTION_GROUP := PKG_A.Get_Item_Value('PRODUCTION_GROUP',
                                                        ROWLIST_);
      MAINROW_.REMARK           := PKG_A.Get_Item_Value('REMARK', ROWLIST_);
      MAINROW_.ENTER_USER       := USER_ID_;
      MAINROW_.ENTER_DATE       := SYSDATE;
      --����
      ROW_.DESCRIPTION := Pkg_a.Get_Item_Value('DESCRIPTION', Rowlist_);
      --��������
      ROW_.CREATE_DATE := TO_DATE(Pkg_a.Get_Item_Value('CREATE_DATE',
                                                       Rowlist_),
                                  'YYYY-MM-DD');
      --�������
      ROW_.LAST_ACTIVITY_DATE := TO_DATE(Pkg_a.Get_Item_Value('LAST_ACTIVITY_DATE',
                                                              Rowlist_),
                                         'YYYY-MM-DD');
      --RESERVE_FLAG
      ROW_.RESERVE_FLAG := Pkg_a.Get_Item_Value('RESERVE_FLAG', Rowlist_);
    
      --PRODUCTION_LINE35002DESCRIPTION131CONTRACT35CALENDAR_ID*CREATE_DATE2013-03-19-00.00.00
      --LAST_ACTIVITY_DATE2013-03-19-00.00.00RESERVE_FLAG������� 
      --�޸�ifs������
      CLIENT_SYS.Add_To_Attr('PRODUCTION_LINE',
                             MAINROW_.PRODUCTION_LINE,
                             ATTR_);
      CLIENT_SYS.Add_To_Attr('DESCRIPTION', ROW_.DESCRIPTION, ATTR_);
      CLIENT_SYS.Add_To_Attr('CONTRACT', MAINROW_.CONTRACT, ATTR_);
      CLIENT_SYS.Add_To_Attr('CALENDAR_ID', ROW_.CALENDAR_ID, ATTR_);
      CLIENT_SYS.Add_To_Attr('CREATE_DATE', ROW_.CREATE_DATE, ATTR_);
      CLIENT_SYS.Add_To_Attr('LAST_ACTIVITY_DATE',
                             ROW_.LAST_ACTIVITY_DATE,
                             ATTR_);
      CLIENT_SYS.Add_To_Attr('RESERVE_FLAG', ROW_.RESERVE_FLAG, ATTR_);
    
      Action_ := 'DO';
      IFSAPP.PRODUCTION_LINE_API.NEW__(info_,
                                       objid_,
                                       objversion_,
                                       attr_,
                                       action_);
      --�����Լ��ı�
      insert into BL_PRODUCTION_LINE
        (PRODUCTION_LINE, CONTRACT)
      VALUES
        (MAINROW_.PRODUCTION_LINE, MAINROW_.CONTRACT)
      RETURNING ROWID INTO OBJID__;
    
      UPDATE BL_PRODUCTION_LINE T SET ROW = MAINROW_ WHERE ROWID = OBJID__;
    
      pkg_a.Setsuccess(A311_Key_, 'BL_V_PRODUCTION_LINE', Objid_);
    
    END IF;
    --�޸�
    IF Doaction_ = 'M' THEN
    
      Open Cur_ For
        Select t.* From BL_V_PRODUCTION_LINE t Where t.Objid = Objid_;
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
      Mysql_     := 'update BL_PRODUCTION_LINE SET ';
      Ifmychange := '0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
        -----
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
      
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' And
           Length(Nvl(Column_Id_, '')) > 0 Then
          IF COLUMN_ID_ = 'IPADDRESS' OR COLUMN_ID_ = 'PRODUCTION_GROUP' OR
             COLUMN_ID_ = 'REMARK' THEN
            Ifmychange := '1';
            v_         := Substr(v_, Pos1_ + 1);
            Mysql_     := Mysql_ || Column_Id_ || '=''' || v_ || ''',';
          ELSE
            v_         := Substr(v_, Pos1_ + 1);
            Mysql_     := Mysql_ || Column_Id_ || '=''' || v_ || ''',';
            Ifmychange := '2';
            CLIENT_SYS.Add_To_Attr(Column_Id_, v_, ATTR_);
          END IF;
        End If;
      End Loop;
    
      --��������޸�--
      If Ifmychange = '1' Then
        Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User =''' ||
                  User_Id_ || '''';
        Mysql_ := Mysql_ || 'Where Rowid =''' || Row_.LINEOBJID || '''';
        -- raise_application_error(Pkg_a.Raise_Error, mysql_);
        Execute Immediate Mysql_;
      End If;
      If Ifmychange = '2' Then
        Action_ := 'DO';
        IFSAPP.PRODUCTION_LINE_API.MODIFY__(info_,
                                            objid_,
                                            Row_.objversion,
                                            attr_,
                                            action_);
      END IF;
      --���óɹ��ı�־
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_PRODUCTION_LINE', Objid_);
    
    End If;
    --ɾ��
    If Doaction_ = 'D' Then
      /*OPEN CUR_ FOR
              SELECT T.* FROM BL_V_PRODUCTION_LINE T WHERE T.ROWID = OBJID_;
            FETCH CUR_
              INTO ROW_;
            IF CUR_ %NOTFOUND THEN
              CLOSE CUR_;
              RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'�����rowid');
              return;
            end if;
            close cur_;
      --      DELETE FROM BL_V_PRODUCTION_LINE T WHERE T.ROWID = OBJID_; */
      --���óɹ��ı�־
      --pkg_a.Setsuccess(A311_Key_,'BL_V_PRODUCTION_LINE', Objid_);
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
    row_     BL_V_PRODUCTION_LINE%rowtype;
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
    row_ BL_V_PRODUCTION_LINE%rowtype;
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
    row_ BL_V_PRODUCTION_LINE%rowtype;
    CUR_ T_CURSOR;
  Begin
    ROW_.LINE_KEY := PKG_A.Get_Item_Value('LINE_KEY', ROWLIST_);
    ROW_.OBJID    := PKG_A.Get_Item_Value('OBJID', ROWLIST_);
    OPEN CUR_ FOR
      SELECT T.* FROM BL_V_PRODUCTION_LINE T WHERE T.OBJID = ROW_.OBJID;
    FETCH CUR_
      INTO row_;
    CLOSE CUR_;
    IF NVL(ROW_.OBJID, 'NULL') <> 'NULL' THEN
      IF Column_Id_ = 'CONTRACT' OR Column_Id_ = 'PRODUCTION_LINE' THEN
        RETURN '0';
      END IF;
    END IF;
  
    If Column_Id_ = '��COLUMN��' Then
      Return '0';
    End If;
    Return '1';
  End;

End BL_PRODUCTION_LINE_API;
/
