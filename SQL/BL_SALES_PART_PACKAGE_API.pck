CREATE OR REPLACE PACKAGE BL_SALES_PART_PACKAGE_API IS
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

END BL_SALES_PART_PACKAGE_API;
/
CREATE OR REPLACE PACKAGE BODY BL_SALES_PART_PACKAGE_API IS
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
    action_     VARCHAR2(100);
    ATTR_       VARCHAR2(100);
    MAINROW_    BL_V_SALES_PART%ROWTYPE;
  BEGIN
    attr_out          := '';
    MAINROW_.LINE_KEY := PKG_A.Get_Item_Value('LINE_KEY', ROWLIST_);
    IF NVL(MAINROW_.LINE_KEY, 'NULL') = 'NULL' THEN
      RETURN;
    END IF;
    MAINROW_.CATALOG_NO := Pkg_a.Get_Item_Value_By_Index('-',
                                                         '&',
                                                         MAINROW_.LINE_KEY || '&');
    MAINROW_.CONTRACT   := PKG_A.Get_Item_Value_By_Index('&',
                                                         '-',
                                                         '&' ||
                                                         MAINROW_.LINE_KEY);
  
    action_ := 'PREPARE';
    CLIENT_SYS.ADD_TO_ATTR('CATALOG_NO', '', ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('CONTRACT', MAINROW_.CONTRACT, ATTR_);
    CLIENT_SYS.ADD_TO_ATTR('PARENT_PART', MAINROW_.CATALOG_NO, ATTR_);
    IFSAPP.SALES_PART_PACKAGE_API.NEW__(info_,
                                        objid_,
                                        objversion_,
                                        ATTR_,
                                        action_);
    attr_out := Pkg_a.Get_Attr_By_Ifs(Attr_);
    PKG_A.Set_Item_Value('PARENT_PART', MAINROW_.CATALOG_NO, ATTR_OUT);
    PKG_A.Set_Item_Value('CONTRACT', MAINROW_.CONTRACT, ATTR_OUT);
    PKG_A.Set_Item_Value('CATALOG_NO', '', ATTR_OUT);
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
    info_       VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    action_     VARCHAR2(100);
    ATTR_       VARCHAR2(100);
    row_        BL_V_SALES_PART_PACKAGE%rowtype;
    MAINROW_    BL_V_SALES_PART_PACKAGE%rowtype;
  BEGIN
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    IF Doaction_ = 'I' THEN
      -- CATALOG_NO 110115000046 QTY_PER_ASSEMBLY 1 CONTRACT 40 PARENT_PART 110113122010 ;
      action_               := 'DO';
      ROW_.CATALOG_NO       := PKG_A.Get_Item_Value('CATALOG_NO', ROWLIST_);
      ROW_.CONTRACT         := PKG_A.Get_Item_Value('CONTRACT', ROWLIST_);
      ROW_.PARENT_PART      := PKG_A.Get_Item_Value('PARENT_PART', ROWLIST_);
      ROW_.QTY_PER_ASSEMBLY := PKG_A.Get_Item_Value('QTY_PER_ASSEMBLY',
                                                    ROWLIST_);
    
      CLIENT_SYS.ADD_TO_ATTR('CATALOG_NO', ROW_.CATALOG_NO, ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('QTY_PER_ASSEMBLY',
                             ROW_.QTY_PER_ASSEMBLY,
                             ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('CONTRACT', ROW_.CONTRACT, ATTR_);
      CLIENT_SYS.ADD_TO_ATTR('PARENT_PART', ROW_.PARENT_PART, ATTR_);
      IFSAPP.SALES_PART_PACKAGE_API.NEW__(info_,
                                          objid_,
                                          objversion_,
                                          ATTR_,
                                          action_);
    
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      pkg_a.Setsuccess(A311_Key_, 'BL_V_SALES_PART_PACKAGE', Objid_);
      /*
      --����
      row_.CATALOG_DESC  := Pkg_a.Get_Item_Value('CATALOG_DESC', Rowlist_)
      --������λ
      row_.SALES_UNIT_MEAS  := Pkg_a.Get_Item_Value('SALES_UNIT_MEAS', Rowlist_)
      --װ������
      row_.QTY_PER_ASSEMBLY  := Pkg_a.Get_Item_Value('QTY_PER_ASSEMBLY', Rowlist_)
      --��
      row_.CONTRACT  := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_)
      --PARENT_PART
      row_.PARENT_PART  := Pkg_a.Get_Item_Value('PARENT_PART', Rowlist_)
      --CUST_WARRANTY_ID
      row_.CUST_WARRANTY_ID  := Pkg_a.Get_Item_Value('CUST_WARRANTY_ID', Rowlist_)
      --LINE_KEY
      row_.LINE_KEY  := Pkg_a.Get_Item_Value('LINE_KEY', Rowlist_)
      --���
      row_.CATALOG_NO  := Pkg_a.Get_Item_Value('CATALOG_NO', Rowlist_)*/
    END IF;
    --�޸�
    IF Doaction_ = 'M' THEN
      Open Cur_ For
        Select t.* From BL_V_SALES_PART_PACKAGE t Where t.Objid = Objid_;
      Fetch Cur_
        Into MAINROW_;
      If Cur_%Notfound Then
        close cur_;
        Raise_Application_Error(Pkg_a.Raise_Error, '�����rowid��');
        return;
      End If;
      Close Cur_;
      action_               := 'DO';
      ROW_.CATALOG_NO       := PKG_A.Get_Item_Value('CATALOG_NO', ROWLIST_);
      ROW_.QTY_PER_ASSEMBLY := PKG_A.Get_Item_Value('QTY_PER_ASSEMBLY',
                                                    ROWLIST_);
      CLIENT_SYS.ADD_TO_ATTR('QTY_PER_ASSEMBLY',
                             ROW_.QTY_PER_ASSEMBLY,
                             ATTR_);
      objversion_ := MAINROW_.OBJVERSION;
      /*      INSERT INTO A1
        (COL, COL01, COL02, ID)
        SELECT objid_, ATTR_, objversion_, S_A1.NEXTVAL FROM DUAL;
      COMMIT;*/
      IFSAPP.SALES_PART_PACKAGE_API.MODIFY__(info_,
                                             objid_,
                                             objversion_,
                                             ATTR_,
                                             action_);
      /*--pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
             Open Cur_ For
              Select t.* From BL_V_SALES_PART_PACKAGE t Where t.Objid = Objid_;
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
      End If;*/
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_SALES_PART_PACKAGE', Row_.Objid);
    End If;
    --ɾ��
    If Doaction_ = 'D' Then
      OPEN CUR_ FOR
        SELECT T.* FROM BL_V_SALES_PART_PACKAGE T WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error, '�����rowid');
        return;
      end if;
      close cur_;
    
      objversion_ := ROW_.OBJVERSION;
    
      Action_ := 'DO';
      IFSAPP.SALES_PART_PACKAGE_API.REMOVE__(info_,
                                             objid_,
                                             objversion_,
                                             action_);
      --      DELETE FROM BL_V_SALES_PART_PACKAGE T WHERE T.ROWID = OBJID_; 
      pkg_a.Setsuccess(A311_Key_, 'BL_V_SALES_PART_PACKAGE', Objid_);
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
    ROW_     BL_V_SALES_PART_PACKAGE%ROWTYPE;
    CAROW_   SALES_PART_LOV%ROWTYPE;
    CUR_     t_cursor;
  Begin
    ROW_.CONTRACT := PKG_A.Get_Item_Value('CONTRACT', ROWLIST_);
    If Column_Id_ = 'CATALOG_NO' Then
      ROW_.CATALOG_NO := PKG_A.Get_Item_Value('CATALOG_NO', ROWLIST_);
      OPEN CUR_ FOR
        SELECT T.*
          FROM SALES_PART_LOV T
         WHERE T.catalog_no = ROW_.CATALOG_NO
           AND T.contract = ROW_.CONTRACT;
      FETCH CUR_
        INTO CAROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        Raise_Application_Error(Pkg_a.Raise_Error, '����������');
        return;
      End If;
      Close Cur_;
      Pkg_a.Set_Item_Value('CATALOG_DESC', CAROW_.CATALOG_DESC, Attr_Out);
    
      ROW_.SALES_UNIT_MEAS := IFSAPP.SALES_PART_API.Get_Sales_Unit_Meas(ROW_.CONTRACT,
                                                                        ROW_.CATALOG_NO);
      Pkg_a.Set_Item_Value('SALES_UNIT_MEAS',
                           ROW_.SALES_UNIT_MEAS,
                           Attr_Out);
      --SALES_PART_API.Get_Catalog_Desc
      --SALES_PART_API.Get_Sales_Unit_Meas
      --Sales_Part_API.Get_Cust_Warranty_Id
      --���и�ֵ
      /*      Pkg_a.Set_Item_Value('��COLUMN��', '��value��', Attr_Out);
      --�����в�����
      Pkg_a.Set_Column_Enable('��column��', '0', Attr_Out);
      --�����п���
      Pkg_a.Set_Column_Enable('��column��', '1', Attr_Out);*/
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
    ROW_ BL_V_SALES_PART_PACKAGE%ROWTYPE;
  Begin
  
    ROW_.OBJID := PKG_A.Get_Item_Value('OBJID', ROWLIST_);
    IF Column_Id_ = 'QTY_PER_ASSEMBLY' Then
      RETURN '1';
    END IF;
    IF NVL(ROW_.OBJID, 'NULL') = 'NULL' THEN
      IF Column_Id_ = 'ROW_.CATALOG_NO' Then
        RETURN '1';
      END IF;
    ELSE
      RETURN '0';
    END IF;
  
  End;

End BL_SALES_PART_PACKAGE_API;
/
