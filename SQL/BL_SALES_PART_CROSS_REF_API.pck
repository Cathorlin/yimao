CREATE OR REPLACE PACKAGE BL_SALES_PART_CROSS_REF_API IS
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

END BL_SALES_PART_CROSS_REF_API;
/
CREATE OR REPLACE PACKAGE BODY BL_SALES_PART_CROSS_REF_API IS
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
    attr_out_   VARCHAR2(4000);
    Attr_       Varchar2(4000);
    Info_       Varchar2(4000);
    Objid_      Varchar2(4000);
    Objversion_ Varchar2(4000);
    Action_     Varchar2(100);
    ROW_        BL_V_SALES_PART_CROSS_REF%ROWTYPE;
  BEGIN
    attr_out := '';
    Action_  := 'PREPARE';
    Attr_    := Pkg_a.Get_Attr_By_Bm(Rowlist_);
    SALES_PART_CROSS_REFERENCE_API.NEW__(Info_,
                                         Objid_,
                                         Objversion_,
                                         Attr_,
                                         Action_);
    Attr_Out      := Pkg_a.Get_Attr_By_Ifs(Attr_);
    ROW_.CONTRACT := PKG_A.Get_Item_Value('CONTRACT', Attr_Out);
    pkg_a.Set_Item_Value('CONTRACT', ROW_.CONTRACT, attr_out_);
    pkg_a.Setresult(A311_Key_, attr_out_);
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
    Action_     VARCHAR2(10);
    Attr_       Varchar2(4000);
    Attr__      Varchar2(4000);
    Info_       Varchar2(4000);
    Objversion_ Varchar2(4000);
    OBJID__     Varchar2(4000);
    ROW_        BL_SALES_PART_CROSS_REF%ROWTYPE;
    MAINROW_    BL_V_SALES_PART_CROSS_REF%ROWTYPE;
  BEGIN
  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    Action_   := '';
    --����
    IF Doaction_ = 'I' THEN
    
      Action_               := 'CHECK';
      ROW_.CUSTOMER_NO      := PKG_A.Get_Item_Value('CUSTOMER_NO', ROWLIST_);
      ROW_.CONTRACT         := PKG_A.Get_Item_Value('CONTRACT', ROWLIST_);
      ROW_.CATALOG_NO       := PKG_A.Get_Item_Value('CATALOG_NO', ROWLIST_);
      ROW_.CUSTOMER_PART_NO := PKG_A.Get_Item_Value('CUSTOMER_PART_NO',
                                                    ROWLIST_);
      ROW_.PO_IDENTIFIER    := PKG_A.Get_Item_Value('PO_IDENTIFIER',
                                                    ROWLIST_);
    
      Client_Sys.Add_To_Attr('CUSTOMER_NO',
                             PKG_A.Get_Item_Value('CUSTOMER_NO', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('CONTRACT',
                             PKG_A.Get_Item_Value('CONTRACT', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('CATALOG_NO',
                             PKG_A.Get_Item_Value('CATALOG_NO', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('CONV_FACTOR',
                             PKG_A.Get_Item_Value('CONV_FACTOR', ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('CUSTOMER_PART_NO',
                             PKG_A.Get_Item_Value('CUSTOMER_PART_NO',
                                                  ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('CUSTOMER_UNIT_MEAS',
                             PKG_A.Get_Item_Value('CUSTOMER_UNIT_MEAS',
                                                  ROWLIST_),
                             Attr_);
      Client_Sys.Add_To_Attr('CATALOG_DESC',
                             PKG_A.Get_Item_Value('CATALOG_DESC', ROWLIST_),
                             Attr_);
      Attr__ := Attr_;
    
      IFSAPP.SALES_PART_CROSS_REFERENCE_API.NEW__(Info_,
                                                  Objid_,
                                                  Objversion_,
                                                  Attr_,
                                                  Action_);
    
      Objid_      := '';
      Action_     := 'DO';
      Objversion_ := '';
      Info_       := '';
      IFSAPP.SALES_PART_CROSS_REFERENCE_API.NEW__(Info_,
                                                  Objid_,
                                                  Objversion_,
                                                  Attr__,
                                                  Action_);
      /*      ROW_.ENTER_USER := USER_ID_;
      ROW_.ENTER_DATE := SYSDATE;
      INSERT INTO BL_SALES_PART_CROSS_REF
        (CONTRACT, CUSTOMER_NO, CATALOG_NO, CUSTOMER_PART_NO)
      VALUES
        (ROW_.CONTRACT,
         ROW_.CUSTOMER_NO,
         ROW_.CATALOG_NO,
         ROW_.CUSTOMER_PART_NO)
      RETURNING ROWID INTO OBJID__;
      UPDATE BL_SALES_PART_CROSS_REF SET ROW = ROW_ WHERE ROWID = OBJID__;*/
    
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      pkg_a.Setsuccess(A311_Key_, 'BL_V_SALES_PART_CROSS_REF', Objid_);
    END IF;
    --�޸�
    IF Doaction_ = 'M' THEN
      Attr_              := '';
      ROW_.PO_IDENTIFIER := PKG_A.Get_Item_Value('PO_IDENTIFIER', ROWLIST_);
      open cur_ for
        SELECT T.* FROM BL_V_SALES_PART_CROSS_REF T WHERE T.OBJID = OBJID_;
      FETCH CUR_
        INTO MAINROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '�����rowid');
        return;
      end if;
      close cur_;
    
      Action_ := 'CHECK';
      Client_Sys.Add_To_Attr('CATALOG_DESC',
                             PKG_A.Get_Item_Value('CATALOG_DESC', ROWLIST_),
                             Attr_);
      objversion_ := MAINROW_.OBJVERSION;
      Attr__      := Attr_;
      IFSAPP.SALES_PART_CROSS_REFERENCE_API.MODIFY__(Info_,
                                                     Objid_,
                                                     Objversion_,
                                                     Attr_,
                                                     Action_);
    
      Action_ := 'DO';
      Info_   := '';
      IFSAPP.SALES_PART_CROSS_REFERENCE_API.MODIFY__(Info_,
                                                     Objid_,
                                                     Objversion_,
                                                     Attr__,
                                                     Action_);
      /*      UPDATE BL_SALES_PART_CROSS_REF T
        SET PO_IDENTIFIER = ROW_.PO_IDENTIFIER
      WHERE T.CONTRACT = MAINROW_.CONTRACT
        AND T.CUSTOMER_NO = MAINROW_.CUSTOMER_NO
        AND T.CATALOG_NO = MAINROW_.CATALOG_NO
        AND T.CUSTOMER_PART_NO = MAINROW_.CUSTOMER_PART_NO;*/
    
      pkg_a.Setsuccess(A311_Key_, 'BL_V_SALES_PART_CROSS_REF', Objid_);
    END IF;
    --ɾ��
    IF Doaction_ = 'D' THEN
      --pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
      RETURN;
    END IF;
  
  END;
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
                         Outrowlist_  OUT VARCHAR2) IS
    ROW_     BL_SALES_PART_CROSS_REF%ROWTYPE;
    MAINROW_ BL_V_SALES_PART_CROSS_REF%ROWTYPE;
    CATAROW_ SALES_PART%ROWTYPE;
    Attr_Out VARCHAR2(4000);
    CUR_     T_CURSOR;
  BEGIN
    IF Column_Id_ = 'CUSTOMER_NO' THEN
      MAINROW_.CUSTOMER_NO   := PKG_A.Get_Item_Value('CUSTOMER_NO',
                                                     ROWLIST_);
      MAINROW_.CUSTOMER_NAME := CUST_ORD_CUSTOMER_API.Get_Name(MAINROW_.CUSTOMER_NO);
      PKG_A.Set_Item_Value('CUSTOMER_NAME',
                           MAINROW_.CUSTOMER_NAME,
                           Attr_Out);
      /*    
      --���и�ֵ
      Pkg_a.Set_Item_Value('��COLUMN��', '��VALUE��', Attr_Out);
      --�����в�����
      Pkg_a.Set_Column_Enable('��COLUMN��', '0', Attr_Out);
      --�����п���
      Pkg_a.Set_Column_Enable('��COLUMN��', '1', Attr_Out);*/
    END IF;
    IF COLUMN_ID_ = 'CATALOG_NO' THEN
      ROW_.CATALOG_NO := PKG_A.Get_Item_Value('CATALOG_NO', ROWLIST_);
      ROW_.CONTRACT   := PKG_A.Get_Item_Value('CONTRACT', ROWLIST_);
      OPEN CUR_ FOR
        SELECT T.*
          FROM SALES_PART T
         WHERE T.catalog_no = ROW_.CATALOG_NO
           AND T.contract = ROW_.CONTRACT;
      FETCH CUR_
        INTO CATAROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '�޴����ۼ���');
        return;
      end if;
      close cur_;
      PKG_A.Set_Item_Value('GET_CATALOG_DESC',
                           CATAROW_.catalog_desc,
                           Attr_Out);
      PKG_A.Set_Item_Value('UNITMEAS',
                           SALES_PART_API.Get_Sales_Unit_Meas(ROW_.CONTRACT,
                                                              ROW_.CATALOG_NO),
                           Attr_Out);
      PKG_A.Set_Item_Value('CONV_FACTOR', CATAROW_.CONV_FACTOR, Attr_Out);
      PKG_A.Set_Item_Value('CUSTOMER_UNIT_MEAS',
                           SALES_PART_API.Get_Sales_Unit_Meas(ROW_.CONTRACT,
                                                              ROW_.CATALOG_NO),
                           Attr_Out);
    END IF;
  
    Outrowlist_ := Attr_Out;
  END;
  /*  �з����仯��ʱ��
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ������� �� ɾ���� ��ť 
      KEY_ ����������ֵ
      User_Id_  ��ǰ�û�
  */
  FUNCTION Checkbutton__(Dotype_  IN VARCHAR2,
                         KEY_     IN VARCHAR2,
                         User_Id_ IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF Dotype_ = 'ADD_ROW' THEN
      RETURN '1';
    
    END IF;
    IF Dotype_ = 'DEL_ROW' THEN
      RETURN '1';
    
    END IF;
    RETURN '1';
  END;

  /*  ʵ��ҵ���߼������е� �༭��
      Doaction_   I M ��ϸ�϶�Ϊ M   I ���� M �޸� ҳ�������� ��ǰ�����е� �����Ե��Ժ� ����  
      Column_Id_  ��
      Rowlist_  ��ǰ�û�
      ����: 1 ����
      0 ������
  */
  FUNCTION Checkuseable(Doaction_  IN VARCHAR2,
                        Column_Id_ IN VARCHAR,
                        Rowlist_   IN VARCHAR2) RETURN VARCHAR2 IS
    MAINROW_ BL_V_SALES_PART_CROSS_REF%ROWTYPE;
  BEGIN
    MAINROW_.OBJID := PKG_A.Get_Item_Value('OBJID', ROWLIST_);
    If Nvl(MAINROW_.Objid, 'NULL') = 'NULL' Then
      Return '1';
    ELSE
      IF Column_Id_ = 'CATALOG_DESC' OR Column_Id_ = 'PO_IDENTIFIER' THEN
        RETURN '1';
      ELSE
        RETURN '0';
      END IF;
    
    END IF;
  END;

END BL_SALES_PART_CROSS_REF_API;
/
