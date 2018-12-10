CREATE OR REPLACE PACKAGE BL_TRANSACTION_HIST_API IS
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

END BL_TRANSACTION_HIST_API;
/
CREATE OR REPLACE PACKAGE BODY BL_TRANSACTION_HIST_API IS
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
  
    -- pkg_a.Set_Item_Value('��COLUMN��', '��VALUE��', attr_out);
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
    Objid_            VARCHAR2(50);
    Index_            VARCHAR2(1);
    Cur_              t_Cursor;
    data_             varchar2(4000);
    pos_              number;
    pos1_             number;
    v_                varchar2(4000);
    i                 number;
    column_id_        varchar2(4000);
    attr_             varchar2(4000);
    mysql_            varchar2(4000);
    ifmychange        varchar2(1);
    Doaction_         VARCHAR2(10);
    row_              bl_v_transaction_histshengqing%rowtype;
    row1_             BL_MATERIALS_RETURN_TAB%rowtype;
    mainrow_          BL_V_BACK_REQUIS_LINE_2%rowtype;
    QTY_UNISSUED_all_ number;
    QTY_UNISSUED_     number;
  BEGIN
  
    Index_     := f_Get_Data_Index();
    row_.OBJID := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_  := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    IF Doaction_ = 'I' THEN
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
      RETURN;
    END IF;
    --�޸�
    IF Doaction_ = 'M' THEN
      open cur_ for
        select *
          from bl_v_transaction_histshengqing t
         where t.OBJID = row_.OBJID;
      fetch cur_
        into row_;
      if cur_%notfound then
        close cur_;
        raise_application_error(-20101, '�����rowid');
      end if;
      close cur_;
      QTY_UNISSUED_ := pkg_a.Get_Item_Value('QTY_UNISSUED', Rowlist_);
      if nvl(QTY_UNISSUED_, 0) < 0 then
        raise_application_error(-20101, '�����������������0����');
        return;
      end if;
      if QTY_UNISSUED_ > row_.QTY_SHIPPED then
        raise_application_error(-20101, '����������ܴ��ڴ������·�����');
        return;
      end if;
    
      if row_.QTY_UNISSUED is not null then
        update BL_MATERIALS_RETURN_TAB t2
           set t2.qty_unissued = QTY_UNISSUED_
         where t2.objid_id = row_.OBJID;
      else
        insert into BL_MATERIALS_RETURN_TAB
          (QTY_UNISSUED,
           RMATERIAL_NO,
           PART_NO,
           ORDER_NO,
           LINE_NO,
           LINE_ITEM_NO,
           RELEASE_NO,
           LOCATION_NO,
           ORDER_CLASS,
           STATUS,
           DATE_ENTERED,
           CONTRACT,
           LINK_KEY,
           OBJID_ID)
        values
          (QTY_UNISSUED_,
           row_.RMATERIAL_NO,
           row_.PART_NO,
           row_.ORDER_NO,
           row_.order_line_no,
           row_.LINE_ITEM_NO,
           row_.RELEASE_NO,
           row_.LOCATION_NO,
           row_.SOURCE,
           row_.status,
           row_.DATED,
           row_.CONTRACT,
           row_.LINK_KEY,
           row_.OBJID);
      end if;
      pkg_a.Setsuccess(A311_Key_, 'BL_MATERIALS_RETURN_TAB', row_.OBJID);
      RETURN;
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
    Attr_Out VARCHAR2(4000);
  BEGIN
    IF Column_Id_ = '' THEN
      --���и�ֵ
      Pkg_a.Set_Item_Value('��COLUMN��', '��VALUE��', Attr_Out);
      --�����в�����
      Pkg_a.Set_Column_Enable('��COLUMN��', '0', Attr_Out);
      --�����п���
      Pkg_a.Set_Column_Enable('��COLUMN��', '1', Attr_Out);
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
      RETURN '0';
    
    END IF;
    IF Dotype_ = 'DEL_ROW' THEN
      RETURN '0';
    
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
    mainrow_ BL_V_BACK_REQUIS_LINE_2%rowtype;
    row_     BL_V_TRANSACTION_HISTSHENGQING%rowtype;
    cur_     t_Cursor;
  BEGIN
    row_.OBJID := pkg_a.Get_Item_Value('OBJID', Rowlist_);
    open cur_ for
      select *
        from BL_V_TRANSACTION_HISTSHENGQING t
       where t.OBJID = row_.OBJID;
    fetch cur_
      into row_;
    if cur_%notfound then
      close cur_;
      raise_application_error(-20101, '�����rowid');
    end if;
    close cur_;
  
    open cur_ for
      select *
        from BL_V_BACK_REQUIS_LINE_2 t1
       where t1.RMATERIAL_NO = row_.RMATERIAL_NO;
    fetch cur_
      into mainrow_;
    if cur_%notfound then
      close cur_;
      raise_application_error(-20101, '�����rowid');
    end if;
    close cur_;
    if to_number(row_.QTY_UNISSUED) > to_number(mainrow_.QTY_UNISSUE) then
      raise_application_error(-20101, '������������ܴ�����������');
    end if;
    IF Column_Id_ = '' THEN
      RETURN '0';
    END IF;
    RETURN '1';
  END;

END BL_TRANSACTION_HIST_API;
/
