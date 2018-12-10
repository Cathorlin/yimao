CREATE OR REPLACE PACKAGE BL_CUSTOMER_INFO_ADDRESS__API IS
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

END BL_CUSTOMER_INFO_ADDRESS__API;
/
CREATE OR REPLACE PACKAGE BODY BL_CUSTOMER_INFO_ADDRESS__API IS
  TYPE t_Cursor IS REF CURSOR;

  ---------------�ͻ�  ---------------
  ---------------create by ld-------------
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
    OBJID_      VARCHAR2(4000);
    info_       VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    attr_       VARCHAR2(4000);
    action_     VARCHAR2(4000);
    attr__      VARCHAR2(4000);
    ROW_        BL_V_CUSTOMER_INFO_ADDRESS%rowtype;
  BEGIN
    attr_out         := '';
    Action_          := 'PREPARE';
    ROW_.CUSTOMER_ID := PKG_A.Get_Item_Value('CUSTOMER_ID', ROWLIST_);
    CLIENT_SYS.Add_To_Attr('CUSTOMER_ID', ROW_.CUSTOMER_ID, attr_);
    IFSAPP.CUSTOMER_INFO_ADDRESS_API.NEW__(info_,
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
    Objid_      VARCHAR2(4000);
    info_       VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    attr_       VARCHAR2(4000);
    attr__      VARCHAR2(4000);
    action_     VARCHAR2(4000);
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
    row_        BL_V_CUSTOMER_INFO_ADDRESS%rowtype;
  BEGIN
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    IF Doaction_ = 'I' THEN
    
      CLIENT_SYS.Add_To_Attr('ADDRESS_ID',
                             PKG_A.Get_Item_Value('ADDRESS_ID', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('COUNTRY',
                             PKG_A.Get_Item_Value('COUNTRY', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('IN_CITY',
                             PKG_A.Get_Item_Value('IN_CITY', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('ADDRESS1',
                             PKG_A.Get_Item_Value('ADDRESS1', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('ADDRESS2',
                             PKG_A.Get_Item_Value('ADDRESS2', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('ZIP_CODE',
                             PKG_A.Get_Item_Value('ZIP_CODE', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('COUNTY',
                             PKG_A.Get_Item_Value('COUNTY', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('STATE',
                             PKG_A.Get_Item_Value('STATE', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('CUSTOMER_ID',
                             PKG_A.Get_Item_Value('CUSTOMER_ID', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('CITY',
                             PKG_A.Get_Item_Value('CITY', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('DEFAULT_DOMAIN',
                             PKG_A.Get_Item_Value('DEFAULT_DOMAIN',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('PARTY_TYPE',
                             PKG_A.Get_Item_Value('PARTY_TYPE', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('ADDRESS',
                             PKG_A.Get_Item_Value('ADDRESS', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('EAN_LOCATION',
                             PKG_A.Get_Item_Value('EAN_LOCATION', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('VALID_FROM',
                             PKG_A.Get_Item_Value('VALID_FROM', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('VALID_TO',
                             PKG_A.Get_Item_Value('VALID_TO', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('SECONDARY_CONTACT',
                             PKG_A.Get_Item_Value('SECONDARY_CONTACT',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('PRIMARY_CONTACT',
                             PKG_A.Get_Item_Value('PRIMARY_CONTACT',
                                                  ROWLIST_),
                             attr_);
      Action_ := 'CHECK';
      attr__  := attr_;
      IFSAPP.CUSTOMER_INFO_ADDRESS_API.NEW__(info_,
                                             objid_,
                                             objversion_,
                                             attr_,
                                             action_);
      Action_ := 'DO';
      IFSAPP.CUSTOMER_INFO_ADDRESS_API.NEW__(info_,
                                             objid_,
                                             objversion_,
                                             attr__,
                                             action_);
      pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_INFO_ADDRESS', Objid_);
      --  ADDRESS_ID 01 COUNTRY �й� IN_CITY FALSE ADDRESS1 12344 ADDRESS2 12344 ZIP_CODE 11111 
      --  COUNTY 11 STATE 111111 CUSTOMER_ID 161619619 CITY 111 DEFAULT_DOMAIN TRUE PARTY_TYPE �ͻ�
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      /*
      --��ʶ��
      row_.CUSTOMER_ID  := Pkg_a.Get_Item_Value('CUSTOMER_ID', Rowlist_)
      --��ַ��ʶ��
      row_.ADDRESS_ID  := Pkg_a.Get_Item_Value('ADDRESS_ID', Rowlist_)
      --��ַ
      row_.ADDRESS  := Pkg_a.Get_Item_Value('ADDRESS', Rowlist_)
      --EANλ��
      row_.EAN_LOCATION  := Pkg_a.Get_Item_Value('EAN_LOCATION', Rowlist_)
      --��Ч��
      row_.VALID_FROM  := Pkg_a.Get_Item_Value('VALID_FROM', Rowlist_)
      --��Ч��
      row_.VALID_TO  := Pkg_a.Get_Item_Value('VALID_TO', Rowlist_)
      --PARTY
      row_.PARTY  := Pkg_a.Get_Item_Value('PARTY', Rowlist_)
      --DEFAULT_DOMAIN
      row_.DEFAULT_DOMAIN  := Pkg_a.Get_Item_Value('DEFAULT_DOMAIN', Rowlist_)
      --����
      row_.COUNTRY  := Pkg_a.Get_Item_Value('COUNTRY', Rowlist_)
      --���ұ��
      row_.COUNTRY_DB  := Pkg_a.Get_Item_Value('COUNTRY_DB', Rowlist_)
      --PARTY_TYPE
      row_.PARTY_TYPE  := Pkg_a.Get_Item_Value('PARTY_TYPE', Rowlist_)
      --PARTY_TYPE_DB
      row_.PARTY_TYPE_DB  := Pkg_a.Get_Item_Value('PARTY_TYPE_DB', Rowlist_)
      --�ڶ���ϵ
      row_.SECONDARY_CONTACT  := Pkg_a.Get_Item_Value('SECONDARY_CONTACT', Rowlist_)
      --������ϵ��ʽ
      row_.PRIMARY_CONTACT  := Pkg_a.Get_Item_Value('PRIMARY_CONTACT', Rowlist_)
      --��ַ1
      row_.ADDRESS1  := Pkg_a.Get_Item_Value('ADDRESS1', Rowlist_)
      --��ַ2
      row_.ADDRESS2  := Pkg_a.Get_Item_Value('ADDRESS2', Rowlist_)
      --��������
      row_.ZIP_CODE  := Pkg_a.Get_Item_Value('ZIP_CODE', Rowlist_)
      --����
      row_.CITY  := Pkg_a.Get_Item_Value('CITY', Rowlist_)
      --����
      row_.COUNTY  := Pkg_a.Get_Item_Value('COUNTY', Rowlist_)
      --ʡ
      row_.STATE  := Pkg_a.Get_Item_Value('STATE', Rowlist_)
      --��������
      row_.IN_CITY  := Pkg_a.Get_Item_Value('IN_CITY', Rowlist_)
      --Ȩ�޴���
      row_.JURISDICTION_CODE  := Pkg_a.Get_Item_Value('JURISDICTION_CODE', Rowlist_)*/
    
    END IF;
    --�޸�
    IF Doaction_ = 'M' THEN
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      Open Cur_ For
        Select t.*
          From BL_V_CUSTOMER_INFO_ADDRESS t
         Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        CLOSE CUR_;
        Raise_Application_Error(Pkg_a.Raise_Error,
                                PKG_MSG.Getmsgbymsgid('ES0002',
                                                      '',
                                                      '',
                                                      PKG_ATTR.Userlanguage(USER_ID_)));
        RETURN;
      End If;
      Close Cur_;
      Data_ := Rowlist_;
      Pos_  := Instr(Data_, Index_);
      i     := i + 1;
      /*            Mysql_     :='update BL_V_CUSTOMER_INFO_ADDRESS SET ';
      Ifmychange :='0';*/
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
          /* Mysql_     := Mysql_ || Column_Id_ || ='''|| v_ ||'',';*/
          CLIENT_SYS.Add_To_Attr(Column_Id_, V_, attr_);
        End If;
      
      End Loop;
      attr__  := attr_;
      Action_ := 'CHECK';
      IFSAPP.CUSTOMER_INFO_ADDRESS_API.MODIFY__(info_,
                                                ROW_.OBJID,
                                                ROW_.OBJVERSION,
                                                attr_,
                                                action_);
      Action_ := 'DO';
      IFSAPP.CUSTOMER_INFO_ADDRESS_API.MODIFY__(info_,
                                                ROW_.OBJID,
                                                ROW_.OBJVERSION,
                                                attr__,
                                                action_);
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_INFO_ADDRESS', Row_.Objid);
    
    End If;
    --ɾ��
    If Doaction_ = 'D' Then
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_CUSTOMER_INFO_ADDRESS T
         WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error, '�����rowid');
        return;
      end if;
      close cur_;
      --      DELETE FROM BL_V_CUSTOMER_INFO_ADDRESS T WHERE T.ROWID = OBJID_; 
      --pkg_a.Setsuccess(A311_Key_,'BL_V_CUSTOMER_INFO_ADDRESS', Objid_);
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
    row_ BL_V_CUSTOMER_INFO_ADDRESS%rowtype;
    cur_ t_cursor;
  Begin
    row_.OBJID := pkg_a.Get_Item_Value('OBJID', rowlist_);
    if nvl(row_.OBJID, 'NULL') <> 'NULL' THEN
      If Column_Id_ = 'ADDRESS_ID' Then
        Return '0';
      End If;
    ELSE
      Return '1';
    END IF;
  End;

End BL_CUSTOMER_INFO_ADDRESS__API;
/
