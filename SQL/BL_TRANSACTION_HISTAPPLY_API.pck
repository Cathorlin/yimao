CREATE OR REPLACE PACKAGE BL_TRANSACTION_HISTAPPLY_API IS
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
END BL_TRANSACTION_HISTAPPLY_API;
/
CREATE OR REPLACE PACKAGE BODY BL_TRANSACTION_HISTAPPLY_API IS
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
    mysql_     varchar2(4000);
    ifmychange varchar2(1);
    Attr_      varchar2(4000);
    row_       BL_V_BACK_REQUIS_LINE%rowtype;
    row1_      BL_V_MATERIAL_REQUIS_LINE%rowtype;
    mainrow_   BL_MATERIAL_TUILIAO%rowtype;
  BEGIN
  
    Index_     := f_Get_Data_Index();
    row_.OBJID := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_  := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    IF Doaction_ = 'I' THEN
      row_.QTY_UNISSUE := pkg_a.Get_Item_Value('QTY_UNISSUE', Rowlist_);
      if to_number(row_.qty_unissue) <= 0 then
        raise_application_error(-20101, '��������ȷ����������');
        return;
      end if;

      row_.rmaterial_no := pkg_a.Get_Item_Value('RMATERIAL_NO', Rowlist_);
      row_.PART_NO      := pkg_a.Get_Item_Value('PART_NO', Rowlist_);
      row_.CONTRACT     := pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      row_.ORDER_NO     := pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
      row_.RELEASE_NO   := pkg_a.Get_Item_Value('RELEASE_NO', Rowlist_);
      select max(t.LINE_NO)
        into Row_.LINE_NO
        from BL_V_BACK_REQUIS_LINE t
       where t.RMATERIAL_NO = Row_.RMATERIAL_NO;
      Row_.LINE_NO := nvl(Row_.LINE_NO, 0) + 1;
    
      row_.DATE_ENTERED          := To_Date(pkg_a.Get_Item_Value('DATE_ENTERED',
                                                                 Rowlist_),
                                            'yyyy-mm-dd');
      row_.PLANNED_DELIVERY_DATE := To_Date(pkg_a.Get_Item_Value('PLANNED_DELIVERY_DATE',
                                                                 Rowlist_),
                                            'yyyy-mm-dd');
      row_.DUE_DATE              := To_Date(pkg_a.Get_Item_Value('DUE_DATE',
                                                                 Rowlist_),
                                            'yyyy-mm-dd');
      row_.ORDER_CLASS           := pkg_a.Get_Item_Value('ORDER_CLASS',
                                                         Rowlist_);
    
      row_.NOTE_TEXT     := pkg_a.Get_Item_Value('NOTE_TEXT', Rowlist_);
      row_.LINE_ITEM_NO  := pkg_a.Get_Item_Value('LINE_ITEM_NO', Rowlist_);
      row_.ORDER_LINE_NO := pkg_a.Get_Item_Value('ORDER_LINE_NO', Rowlist_);
      select  nvl(QTY_SHIPPED,0),nvl(QTY_RETURNED,0)
       into  row_.QTY_SHIPPED,row_.QTY_RETURNED
       from  MATERIAL_REQUIS_LINE  t1 
       where t1.ORDER_CLASS = row_.order_class
        and  t1.ORDER_NO =    row_.order_no
        and  t1.LINE_NO =     row_.order_line_no
        and  t1.RELEASE_NO =  row_.release_no
        and  t1.LINE_ITEM_NO = row_.line_item_no;
       if to_number(row_.QTY_UNISSUE) > to_number(row_.QTY_SHIPPED - row_.QTY_RETURNED) then
          raise_application_error(-20101, '�����������ܴ������·�����');
          return;
        end if;
      insert into BL_TRANSACTION_HIST
        (RMATERIAL_NO,
         QTY_UNISSUE,
         PART_NO,
         CONTRACT,
         ORDER_NO,
         RELEASE_NO,
         LINE_NO,
         STATUS,
         DATE_ENTERED,
         ORDER_CLASS,
         LINE_ITEM_NO,
         ORDER_LINE_NO,
         ENTER_USER)
      values
        (row_.RMATERIAL_NO,
         row_.QTY_UNISSUE,
         row_.PART_NO,
         row_.CONTRACT,
         row_.ORDER_NO,
         row_.RELEASE_NO,
         row_.LINE_NO,
         '0',
         row_.DATE_ENTERED,
         row_.ORDER_CLASS,
         row_.line_item_no,
         row_.order_line_no,
         User_Id_)
      returning rowid into Objid_;
      pkg_a.Setsuccess(A311_Key_, 'BL_V_BACK_REQUIS_LINE', Objid_);
      RETURN;
    END IF;
    --�޸�
    IF Doaction_ = 'M' THEN
      open cur_ for
        select t.* from BL_V_BACK_REQUIS_LINE t where t.OBJID = row_.OBJID;
      fetch cur_
        into row_;
      if cur_%notfound then
        close cur_;
        raise_application_error(-20101, '�����rowid');
        return;
      end if;
      close cur_;
    
      data_      := Rowlist_;
      pos_       := instr(data_, Index_);
      i          := i + 1;
      mysql_     := ' update BL_TRANSACTION_HIST set ';
      ifmychange := '0';
      loop
        exit when nvl(pos_, 0) <= 0;
        exit when i > 300;
        v_         := substr(data_, 1, pos_ - 1);
        data_      := substr(data_, pos_ + 1);
        pos_       := instr(data_, index_);
        pos1_      := instr(v_, '|');
        column_id_ := substr(v_, 1, pos1_ - 1);
        if column_id_ <> 'OBJID' and column_id_ <> 'DOACTION' and
           length(nvl(column_id_, '')) > 0 then
          v_ := substr(v_, pos1_ + 1);
          i  := i + 1;
          if Column_Id_ = 'QTY_UNISSUE' then
            if to_number(v_) <= 0 then
              raise_application_error(-20101, '��������ȷ����������');
              return;
            end if;
            if to_number(v_) > to_number(row_.QTY_SHIPPED - nvl(row_.QTY_RETURNED,0)) then
              raise_application_error(-20101, '�����������ܴ������·�����');
              return;
            end if;
          end if;
          ifmychange := '1';
          mysql_     := mysql_ || ' ' || column_id_ || '=''' || v_ || ''',';
        end if;
      end loop;
      if ifmychange = '1' then
        -- ����sql��� 
        mysql_ := substr(mysql_, 1, length(mysql_) - 1);
        mysql_ := mysql_ || ',modi_user='''||User_Id_||''',modi_date=sysdate where rowidtochar(rowid)=''' || row_.OBJID || '''';
      
        execute immediate mysql_;
      end if;
      RETURN;
    END IF;
    --ɾ��
    IF Doaction_ = 'D' THEN
      open cur_ for
        select * from BL_V_BACK_REQUIS_LINE t where t.OBJID = row_.OBJID;
      fetch cur_
        into row_;
      if cur_%notfound then
        close cur_;
        raise_application_error(-20101, '�����rowid');
      end if;
      close cur_;
      delete from BL_TRANSACTION_HIST t where t.rowid = row_.OBJID;
      pkg_a.Setsuccess(A311_Key_, 'BL_V_BACK_REQUIS_LINE', row_.OBJID);
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
    row_     BL_V_BACK_REQUIS_LINE%rowtype;
    cur_     t_Cursor;
    row1_    BL_V_MATERIAL_REQUIS_LINE%rowtype;
  BEGIN
    IF Column_Id_ = 'MRL_KEY' THEN
      row_.mrl_key := pkg_a.Get_Item_Value('MRL_KEY', Rowlist_);
      open cur_ for
        select t.*
          from BL_V_MATERIAL_REQUIS_LINE t
         where t.link_key = trim(row_.mrl_key);
      fetch cur_
        into row1_;
      if cur_%notfound then
        close cur_;
        raise_application_error(-20101, '�����rowid');
        return;
      end if;
      close cur_;
      Pkg_a.Set_Item_Value('PART_NO', row1_.PART_NO, Attr_Out);
      Pkg_a.Set_Item_Value('DESCRIPTION', row1_.DESCRIPTION, Attr_Out);
      Pkg_a.Set_Item_Value('CONTRACT', row1_.CONTRACT, Attr_Out);
      Pkg_a.Set_Item_Value('ORDER_NO', row1_.ORDER_NO, Attr_Out);
      Pkg_a.Set_Item_Value('UNIT_MEAS', row1_.UNIT_MEAS, Attr_Out);
      Pkg_a.Set_Item_Value('STATUS_CODE', row1_.STATUS_CODE, Attr_Out);
      Pkg_a.Set_Item_Value('SUPPLY_CODE', row1_.SUPPLY_CODE, Attr_Out);
      Pkg_a.Set_Item_Value('DATE_ENTERED',
                           to_char(row1_.DATE_ENTERED, 'YYYY-MM-DD'),
                           Attr_Out);
      Pkg_a.Set_Item_Value('PLANNED_DELIVERY_DATE',
                           to_char(row1_.PLANNED_DELIVERY_DATE,
                                   'YYYY-MM-DD'),
                           Attr_Out);
      Pkg_a.Set_Item_Value('DUE_DATE',
                           to_char(row1_.DUE_DATE, 'YYYY-MM-DD'),
                           Attr_Out);
      Pkg_a.Set_Item_Value('QTY_ASSIGNED', row1_.QTY_ASSIGNED, Attr_Out);
      Pkg_a.Set_Item_Value('QTY_ON_ORDER', row1_.QTY_ON_ORDER, Attr_Out);
      Pkg_a.Set_Item_Value('QTY_RETURNED', row1_.QTY_RETURNED, Attr_Out);
      Pkg_a.Set_Item_Value('QTY_SHIPPED', row1_.QTY_SHIPPED, Attr_Out);
      Pkg_a.Set_Item_Value('ORDER_LINE_NO', row1_.LINE_NO, Attr_Out);
      Pkg_a.Set_Item_Value('RELEASE_NO', row1_.RELEASE_NO, Attr_Out);
      Pkg_a.Set_Item_Value('LINE_ITEM_NO', row1_.LINE_ITEM_NO, Attr_Out);
      Pkg_a.Set_Item_Value('ORDER_CLASS', row1_.ORDER_CLASS, Attr_Out);
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
    cur_ t_Cursor;
    row_ BL_V_BACK_REQUIS_LINE%rowtype;
  BEGIN
    open cur_ for
      select * from BL_V_BACK_REQUIS_LINE t where t.RMATERIAL_NO = key_;
    fetch cur_
      into row_;
    if cur_%notfound then
      close cur_;
      raise_application_error(-20101, '�����rowid');
    end if;
    close cur_;
    if row_.status <> '0' then
      RETURN '0';
    end if;
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
    row_ BL_V_BACK_REQUIS_LINE%rowtype;
  BEGIN
    row_.status := pkg_a.Get_Item_Value('STATUS', Rowlist_);
    if row_.status <> '0' then
      RETURN '0';
    end if;
  END;

END BL_TRANSACTION_HISTAPPLY_API;
/
