CREATE OR REPLACE PACKAGE BL_MATERIALS_BACK_API IS
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

  procedure TUILIAO_COMMIT__(Rowlist_ VARCHAR2,
                             --��ͼ��objid
                             User_Id_ VARCHAR2,
                             --�û�id
                             A311_Key_ VARCHAR2);
END BL_MATERIALS_BACK_API;
/
CREATE OR REPLACE PACKAGE BODY BL_MATERIALS_BACK_API IS
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
    Objid_    VARCHAR2(50);
    Index_    VARCHAR2(1);
    Cur_      t_Cursor;
    Doaction_ VARCHAR2(10);
    row_      BL_V_TRANSACTION_HISTSHENGQING%rowtype;
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
  BEGIN
    IF Column_Id_ = 'NOTE_TEXT' THEN
      RETURN '1';
    END IF;
    RETURN '0';
  END;

  procedure TUILIAO_COMMIT__(Rowlist_ VARCHAR2,
                             --��ͼ��objid
                             User_Id_ VARCHAR2,
                             --�û�id
                             A311_Key_ VARCHAR2) IS
    cur_              t_Cursor;
    mainrow_          BL_V_BACK_REQUIS_LINE_2%rowtype;
    row_              BL_V_TRANSACTION_HISTSHENGQING%rowtype;
    BL_ROW_           BL_RETURN_TRANSACTION%rowtype;
    Rowid_            VARCHAR2(1000);
    QTY_UNISSUED_all_ number;
    QTY_UNISSUED_     number;
  BEGIN
    Rowid_ := Rowlist_;
    open cur_ for
      select * from BL_V_BACK_REQUIS_LINE_2 where OBJID = Rowid_;
    fetch cur_
      into mainrow_;
    if cur_%notfound then
      close cur_;
      raise_application_error(-20101, '�����rowid');
      return;
    end if;
    close cur_;
  
    open cur_ for
      select t.*
        from BL_V_TRANSACTION_HISTSHENGQING t
       where t.LINK_KEY = mainrow_.LINK_KEY
         and t.QTY_UNISSUED > 0;
    fetch cur_
      into row_;
    if cur_%notfound then
      close cur_;
      raise_application_error(-20101, '���������0���������');
      return;
    end if;
    select nvl(sum(t2.QTY_UNISSUED), 0)
      into QTY_UNISSUED_all_
      from bl_v_transaction_histshengqing t2
     where t2.link_key = row_.LINK_KEY;
    /*QTY_UNISSUED_all_ := QTY_UNISSUED_all_ - row_.QTY_UNISSUED;
    QTY_UNISSUED_all_ := QTY_UNISSUED_all_ + QTY_UNISSUED_;*/
    if QTY_UNISSUED_all_ <> row_.QTY_UNISSUE then
      raise_application_error(-20101, '������������������������');
      return;
    end if;
  
    while cur_%found loop
      Material_Requis_Line_API.Unissue(row_.qty_reversed,
                                       row_.ACCOUNTING_ID,
                                       row_.CONTRACT,
                                       row_.PART_NO,
                                       row_.QTY_UNISSUED,
                                       row_.LOCATION_NO,
                                       row_.LOT_BATCH_NO,
                                       row_.SERIAL_NO,
                                       row_.eng_chg_level,
                                       row_.WAIV_DEV_REJ_NO,
                                       row_.TRANSACTION_ID,
                                       row_.SOURCE,
                                       row_.ORDER_NO,
                                       row_.RELEASE_NO,
                                       row_.SEQUENCE_NO,
                                       row_.LINE_ITEM_NO,
                                       row_.COST,
                                       row_.quantity);
    
      --��¼�����
      select max(t4.transaction_id)
        into row_.Transaction_Id
        from Inventory_Transaction_Hist2 t4
       where t4.part_no = row_.PART_NO
         and t4.contract = row_.CONTRACT
         and t4.location_no = row_.LOCATION_NO
         and t4.serial_no = row_.SERIAL_NO
         and t4.lot_batch_no = row_.LOT_BATCH_NO
         and t4.waiv_dev_rej_no = row_.WAIV_DEV_REJ_NO
         and t4.eng_chg_level = row_.eng_chg_level
         and t4.order_no = row_.ORDER_NO
         and t4.transaction_code in ('INTSHIP', 'INTUNISS');
    
      BL_ROW_.Part_No        := row_.PART_NO;
      BL_ROW_.CONTRACT       := row_.CONTRACT;
      BL_ROW_.ORDER_NO       := row_.ORDER_NO;
      BL_ROW_.LOCATION_NO    := row_.LOCATION_NO;
      BL_ROW_.Lot_Batch_No   := row_.LOT_BATCH_NO;
      BL_ROW_.RELEASE_NO     := row_.RELEASE_NO;
      BL_ROW_.QTY_UNISSUED   := row_.QTY_UNISSUED;
      BL_ROW_.ORDER_CLASS    := row_.SOURCE;
      BL_ROW_.STATUS         := row_.status;
      BL_ROW_.LINE_NO        := row_.order_line_no;
      BL_ROW_.DATE_ENTERED   := sysdate;
      BL_ROW_.RMATERIAL_NO   := row_.RMATERIAL_NO;
      BL_ROW_.LINE_ITEM_NO   := row_.LINE_ITEM_NO;
      BL_ROW_.Transaction_Id := row_.TRANSACTION_ID;
      BL_ROW_.Enter_User     := User_Id_;
    
      insert into BL_RETURN_TRANSACTION
        (PART_NO,
         CONTRACT,
         ORDER_NO,
         LOCATION_NO,
         LOT_BATCH_NO,
         RELEASE_NO,
         QTY_UNISSUED,
         ORDER_CLASS,
         STATUS,
         LINE_NO,
         DATE_ENTERED,
         RMATERIAL_NO,
         LINE_ITEM_NO,
         Enter_User,
         TRANSACTION_ID)
      values
        (BL_ROW_.Part_No,
         BL_ROW_.CONTRACT,
         BL_ROW_.ORDER_NO,
         BL_ROW_.Location_No,
         BL_ROW_.Lot_Batch_No,
         BL_ROW_.RELEASE_NO,
         BL_ROW_.QTY_UNISSUED,
         BL_ROW_.ORDER_CLASS,
         BL_ROW_.STATUS,
         BL_ROW_.LINE_NO,
         BL_ROW_.DATE_ENTERED,
         BL_ROW_.RMATERIAL_NO,
         BL_ROW_.LINE_ITEM_NO,
         BL_ROW_.Enter_User,
         BL_ROW_.Transaction_Id);
    
      --�·��������д���������
      update BL_MATERIALS_RETURN_TAB t5
         set t5.qty_unissued = ''
       where t5.objid_id = row_.OBJID;
    
      --����״̬
      update BL_TRANSACTION_HIST t
         set t.status      = '2',
             t.qty_unissue = row_.qty_unissue - QTY_UNISSUED_all_
       where t.rmaterial_no = row_.RMATERIAL_NO
         and t.line_no = row_.order_line_no;
      update BL_MATERIAL_TUILIAO t1
         set t1.status = '2'
       where t1.rmaterial_no = mainrow_.RMATERIAL_NO;
    
      --����������������ˣ�״̬��Ϊ�ر�
      if mainrow_.QTY_UNISSUE = 0 then
        update BL_TRANSACTION_HIST t2
           set t2.status = '3'
         where t2.rmaterial_no = mainrow_.RMATERIAL_NO;
        update BL_MATERIAL_TUILIAO t3
           set t3.status = '3'
         where t3.rmaterial_no = mainrow_.RMATERIAL_NO;
      end if;
    
      fetch cur_
        into row_;
    end loop;
    close cur_;
  
    pkg_a.Setsuccess(A311_Key_,
                     'BL_V_TRANSACTION_HISTSHENGQING',
                     row_.OBJID);
  END;
END BL_MATERIALS_BACK_API;
/
