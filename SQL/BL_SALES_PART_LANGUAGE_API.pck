CREATE OR REPLACE PACKAGE BL_SALES_PART_LANGUAGE_API IS
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
  PROCEDURE langue_save__(Rowlist_  VARCHAR2,
                          User_Id_  VARCHAR2,
                          A311_Key_ VARCHAR2);
END BL_SALES_PART_LANGUAGE_API;
/
CREATE OR REPLACE PACKAGE BODY BL_SALES_PART_LANGUAGE_API IS
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
    ROW_        BL_V_SALES_PART%ROWTYPE;
    MAINROW_    SALES_PART%ROWTYPE;
    CUR_        T_CURSOR;
    attr_       VARCHAR2(4000);
    info_       VARCHAR2(4000);
    objid_      VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    action_     VARCHAR2(4000);
  BEGIN
    attr_out        := '';
    ROW_.LINE_KEY   := PKG_A.Get_Item_Value('LINE_KEY', ROWLIST_);
    ROW_.CONTRACT   := PKG_A.Get_Item_Value_By_Index('&',
                                                     '-',
                                                     '&' || ROW_.LINE_KEY);
    ROW_.CATALOG_NO := PKG_A.Get_Item_Value_By_Index('-',
                                                     '&',
                                                     ROW_.LINE_KEY || '&');
    OPEN CUR_ FOR
      SELECT T.*
        FROM SALES_PART T
       WHERE T.CONTRACT = ROW_.CONTRACT
         AND T.catalog_no = ROW_.CATALOG_NO;
    FETCH CUR_
      INTO MAINROW_;
    IF CUR_ %notfound then
      CLOSE CUR_;
      RETURN;
    END IF;
  
    action_ := 'PREPARE';
    CLIENT_SYS.ADD_TO_ATTR('CATALOG_NO', MAINROW_.CATALOG_NO, ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('CONTRACT', MAINROW_.CONTRACT, ATTR_);
    pkg_a.Set_Item_Value('CATALOG_NO', MAINROW_.CATALOG_NO, attr_out);
    pkg_a.Set_Item_Value('CONTRACT', MAINROW_.CONTRACT, attr_out);
    SALES_PART_LANGUAGE_DESC_API.NEW__(info_,
                                       objid_,
                                       objversion_,
                                       attr_,
                                       action_);
  
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
    objversion_ Varchar(4000);
    info_       Varchar(4000);
    ATTR_       Varchar(4000);
    Action_     Varchar(4000);
    row_        BL_V_SALES_PART_LANGUAGE_DESC%rowtype;
  BEGIN
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    IF Doaction_ = 'I' THEN
      Action_ := 'DO';
      CLIENT_SYS.ADD_TO_ATTR('CONTRACT',
                             PKG_A.Get_Item_Value('CONTRACT', ROWLIST_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('CATALOG_NO',
                             PKG_A.Get_Item_Value('CATALOG_NO', ROWLIST_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('LANGUAGE_CODE',
                             PKG_A.Get_Item_Value('LANGUAGE_CODE', ROWLIST_),
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('CATALOG_DESC',
                             PKG_A.Get_Item_Value('CATALOG_DESC', ROWLIST_),
                             ATTR_);
      IFSAPP.SALES_PART_LANGUAGE_DESC_API.NEW__(info_,
                                                objid_,
                                                objversion_,
                                                attr_,
                                                action_);
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      pkg_a.Setsuccess(A311_Key_, 'BL_V_SALES_PART_LANGUAGE_DESC', Objid_);
      /*
      --��
      row_.CONTRACT  := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_)
      --���ۼ���
      row_.CATALOG_NO  := Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_)
      --����
      row_.LANGUAGE_CODE  := Pkg_a.Get_Item_Value('LANGUAGE_CODE', Rowlist_)
      --�ĵ��ı�
      row_.NOTE_ID  := Pkg_a.Get_Item_Value('NOTE_ID', Rowlist_)
      --����
      row_.CATALOG_DESC  := Pkg_a.Get_Item_Value('CATALOG_DESC', Rowlist_)
      --LINE_KEY
      row_.LINE_KEY  := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_)*/
    END IF;
    --�޸�
    IF Doaction_ = 'M' THEN
    
      Open Cur_ For
        Select t.*
          From BL_V_SALES_PART_LANGUAGE_DESC t
         Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        CLOSE CUR_;
        Raise_Application_Error(Pkg_a.Raise_Error, '�����rowid��');
        RETURN;
      End If;
      Close Cur_;
      Data_ := Rowlist_;
      Pos_  := Instr(Data_, Index_);
      i     := i + 1;
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
          v_ := Substr(v_, Pos1_ + 1);
          Client_Sys.Add_To_Attr(Column_Id_, v_, Attr_);
        End If;
      
      End Loop;
      Action_     := 'DO';
      objversion_ := ROW_.OBJVERSION;
      SALES_PART_LANGUAGE_DESC_API.MODIFY__(info_,
                                            objid_,
                                            objversion_,
                                            attr_,
                                            action_);
      /*--pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
             Open Cur_ For
              Select t.* From BL_V_SALES_PART_LANGUAGE_DESC t Where t.Objid = Objid_;
            Fetch Cur_
              Into Row_;
            If Cur_%Notfound Then
              Raise_Application_Error(Pkg_a.Raise_Error,'�����rowid��');
            
            End If;
            Close Cur_;
            Data_      := Rowlist_;
            Pos_       := Instr(Data_, Index_);
            i          := i + 1;
            Mysql_     :='update Bl_Putintray_m_Detail set ';
            Ifmychange :='0';
            Loop
              Exit When Nvl(Pos_, 0) <= 0;
              Exit When i > 300;
              v_    := Substr(Data_, 1, Pos_ - 1);
              Data_ := Substr(Data_, Pos_ + 1);
              Pos_  := Instr(Data_, Index_);
            
              Pos1_      := Instr(v_,'|');
              Column_Id_ := Substr(v_, 1, Pos1_ - 1);
            
              If Column_Id_ <> 'Objid'  And  Column_Id_ <> 'Doaction' And
                 Length(Nvl(Column_Id_,'')) > 0 Then
                Ifmychange :='1';
                v_         := Substr(v_, Pos1_ + 1);
                Mysql_     := Mysql_ || Column_Id_ || ='''|| v_ ||'',';
        End If;
      
      End Loop;
      
      --�û��Զ�����
      If Ifmychange ='1' Then 
         Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User ='''|| User_Id_ ||'''; 
         Mysql_ := Mysql_ || 'Where Rowid ='''|| Row_.Objid ||''';
      -- raise_application_error(Pkg_a.Raise_Error, mysql_);
         Execute Immediate Mysql_;
      End If; */
      Pkg_a.Setsuccess(A311_Key_,
                       'BL_V_SALES_PART_LANGUAGE_DESC',
                       Row_.Objid);
    End If;
    --ɾ��
    If Doaction_ = 'D' Then
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_SALES_PART_LANGUAGE_DESC T
         WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error, '�����rowid');
        return;
      end if;
      close cur_;
      Action_     := 'DO';
      objversion_ := ROW_.OBJVERSION;
      IFSAPP.SALES_PART_LANGUAGE_DESC_API.REMOVE__(info_,
                                                   objid_,
                                                   objversion_,
                                                   action_);
      --      DELETE FROM BL_V_SALES_PART_LANGUAGE_DESC T WHERE T.ROWID = OBJID_; 
      pkg_a.Setsuccess(A311_Key_, 'BL_V_SALES_PART_LANGUAGE_DESC', Objid_);
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
    ROW_ BL_V_SALES_PART_LANGUAGE_DESC%ROWTYPE;
  Begin
    ROW_.OBJID := PKG_A.Get_Item_Value('OBJID', ROWLIST_);
    IF NVL(ROW_.OBJID, 'NULL') = 'NULL' THEN
      RETURN '1';
    ELSE
      If Column_Id_ = 'LANGUAGE_CODE' Then
        Return '0';
      ELSE
        RETURN '1';
      End If;
    END IF;
  End;
  --������������
  PROCEDURE langue_save__(Rowlist_  VARCHAR2,
                          User_Id_  VARCHAR2,
                          A311_Key_ VARCHAR2) IS
    row_        BL_V_SALES_PART_LANGUAGE%rowtype;
    SROW_       SALES_PART_LANGUAGE_DESC%rowtype;
    cur_        t_cursor;
    objversion_ Varchar(4000);
    info_       Varchar(4000);
    ATTR_       Varchar(4000);
    Action_     Varchar(4000);
  
  begin
    SROW_.OBJID        := PKG_A.Get_Item_Value('OBJID', ROWLIST_);
    SROW_.CATALOG_DESC := PKG_A.Get_Item_Value('CATALOG_DESC', ROWLIST_);
    open cur_ for
      select t.*
        from BL_V_SALES_PART_LANGUAGE t
       where T.OBJID = SROW_.OBJID;
    FETCH CUR_
      INTO ROW_;
    if cur_ %NOTFOUND THEN
      CLOSE CUR_;
      RAISE_APPLICATION_ERROR(-20101, '�����rowid');
      RETURN;
    END IF;
    CLOSE CUR_;
    IF SROW_.CATALOG_DESC <> ROW_.CATALOG_DESC THEN
      CLIENT_SYS.Add_To_Attr('CATALOG_DESC', SROW_.CATALOG_DESC, attr_);
      Action_     := 'DO';
      objversion_ := ROW_.OBJVERSION;
      SALES_PART_LANGUAGE_DESC_API.MODIFY__(info_,
                                            SROW_.OBJID,
                                            objversion_,
                                            attr_,
                                            action_);
    END IF;
    pkg_a.Setsuccess(A311_Key_, 'BL_V_SALES_PART_LANGUAGE', SROW_.OBJID);
  end;

End BL_SALES_PART_LANGUAGE_API;
/
