CREATE OR REPLACE PACKAGE BL_MATERIAL_TUILIAOAPPLY_API IS
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

  procedure get_RMATERIAL_NO(contract_ in varchar2, seq_ out varchar2);
  procedure Requis_Line__(Rowlist_ VARCHAR2,
                          --��ͼ��objid
                          User_Id_ VARCHAR2,
                          --�û�id
                          A311_Key_ VARCHAR2);
  procedure Requis_Line2__(Rowlist_ VARCHAR2,
                           --��ͼ��objid
                           User_Id_ VARCHAR2,
                           --�û�id
                           A311_Key_ VARCHAR2);
END BL_MATERIAL_TUILIAOAPPLY_API;
/
CREATE OR REPLACE PACKAGE BODY BL_MATERIAL_TUILIAOAPPLY_API IS
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
    row_ BL_V_MATERIAL_TUILIAOSHENGQING%rowtype;
  BEGIN
    attr_out := '';
     Row_.Contract := Pkg_Attr.Get_Default_Contract(User_Id_);
    If (Nvl(Row_.Contract, '0') <> '0') Then
      Pkg_a.Set_Item_Value('CONTRACT', Row_.Contract, Attr_Out);
    End If;
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
    pos_       number;
    pos1_      number;
    i          number;
    v_         varchar(1000);
    column_id_ varchar(1000);
    data_      varchar(4000);
    mysql_     varchar2(4000);
    ifmychange varchar2(1);
    row_       BL_V_MATERIAL_TUILIAOSHENGQING%rowtype;
  BEGIN
  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    IF Doaction_ = 'I' THEN
/*      row_.ORDER_NO := pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
      open cur_ for
        select *
          from BL_V_MATERIAL_TUILIAOSHENGQING t
         where t.ORDER_NO = row_.ORDER_NO
         and   t.STATUS<>'3';
      fetch cur_
        into row_;
      if cur_%found then
        close cur_;
        raise_application_error(-20101, '�ö����Ŵ���δ������˻�����');
        return;
      end if;
      close cur_;*/
      row_.CONTRACT        := pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      get_RMATERIAL_NO(row_.CONTRACT, row_.rmaterial_no);
      
      row_.INT_CUSTOMER_NO := pkg_a.Get_Item_Value('INT_CUSTOMER_NO',
                                                   Rowlist_);
    --  row_.STATUS_CODE     := pkg_a.Get_Item_Value('STATUS_CODE', Rowlist_);
      row_.DUE_DATE        := To_Date(Pkg_a.Get_Item_Value('DUE_DATE',
                                                           Rowlist_),
                                      'yyyy-mm-dd');
      row_.DESTINATION_ID  := pkg_a.Get_Item_Value('DESTINATION_ID',
                                                   Rowlist_);
      row_.DESTINATION     := pkg_a.Get_Item_Value('DESTINATION', Rowlist_);
      row_.ENTER_USER      := User_Id_;
      row_.ENTER_DATE      := sysdate;
      row_.status          := '0';
      insert into BL_MATERIAL_TUILIAO
        (rmaterial_no,
         CONTRACT,
         INT_CUSTOMER_NO,
         DUE_DATE,
         ENTER_DATE,
         DESTINATION_ID,
         DESTINATION,
         ENTER_USER,
         status)
      values
        (row_.rmaterial_no,
         row_.CONTRACT,
         row_.INT_CUSTOMER_NO,
         row_.DUE_DATE,
         sysdate,
         row_.DESTINATION_ID,
         row_.DESTINATION,
         User_Id_,
         row_.status)
      returning rowid into Objid_;
      pkg_a.Setsuccess(A311_Key_, 'BL_V_MATERIAL_TUILIAOSHENGQING', Objid_);
      RETURN;
    END IF;
    --�޸�
    IF Doaction_ = 'M' THEN
      data_      := Rowlist_;
      pos_       := instr(data_, Index_);
      i          := i + 1;
      mysql_     := ' update BL_MATERIAL_TUILIAO set ';
      ifmychange := '0';
      loop
        exit when nvl(pos_, 0) <= 0;
        exit when i > 300;
        v_         := substr(data_, 1, pos_ - 1);
        data_      := substr(data_, pos_ + 1);
        pos_       := instr(data_, Index_);
        pos1_      := instr(v_, '|');
        column_id_ := substr(v_, 1, pos1_ - 1);
        if column_id_ <> 'OBJID' and column_id_ <> 'DOACTION' and
           length(nvl(column_id_, '')) > 0 then
          v_         := substr(v_, pos1_ + 1);
          i          := i + 1;
          ifmychange := '1';
          if column_id_ = 'DUE_DATE' or column_id_ = 'MODI_DATE' then
            mysql_ := mysql_ || ' ' || column_id_ || '=to_date(''' || v_ ||
                      ''',''YYYY-MM-DD''),';
          else
            mysql_ := mysql_ || ' ' || column_id_ || '=''' || v_ || ''',';
          end if;
        end if;
      end loop;
      if ifmychange = '1' then
        -- ����sql��� 
        mysql_ := substr(mysql_, 1, length(mysql_) - 1);
        mysql_ := mysql_ || ',modi_user='''||User_Id_||''',modi_date=sysdate where rowidtochar(rowid)=''' || objid_ || '''';
      
        execute immediate mysql_;
      end if;
      pkg_a.Setsuccess(A311_Key_, 'BL_V_MATERIAL_TUILIAOSHENGQING', Objid_);
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
    cur_     t_Cursor;
    row_     BL_V_MATERIAL_REQUISITION%rowtype;
    mainrow_ BL_V_MATERIAL_TUILIAOSHENGQING%rowtype;
  BEGIN
/*    mainrow_.ORDER_NO := pkg_a.Get_Item_Value('ORDER_NO', Rowlist_);
    IF Column_Id_ = 'ORDER_NO' THEN
      open cur_ for
        select t.*
          from BL_V_MATERIAL_REQUISITION t
         where t.ORDER_NO = mainrow_.ORDER_NO;
      fetch cur_
        into row_;
      if cur_%notfound then
        close cur_;
        raise_application_error(-20101, '�����rowid');
        return;
      end if;
      close cur_;
      Pkg_a.Set_Item_Value('CONTRACT', row_.CONTRACT, Attr_Out);
      Pkg_a.Set_Item_Value('INT_CUSTOMER_NO',
                           row_.INT_CUSTOMER_NO,
                           Attr_Out);
      Pkg_a.Set_Item_Value('STATUS_CODE', row_.STATUS_CODE, Attr_Out);
      Pkg_a.Set_Item_Value('DESTINATION_ID', row_.DESTINATION_ID, Attr_Out);
      Pkg_a.Set_Item_Value('DESTINATION', row_.destination, Attr_Out);
    END IF;*/
    if Column_Id_='DESTINATION_ID' then
      row_.DESTINATION_ID := pkg_a.Get_Item_Value('DESTINATION_ID',rowlist_);
        select  DESCRIPTION
         into  row_.destination
         from  INTERNAL_DESTINATION_LOV t 
         where DESTINATION_ID = row_.DESTINATION_ID
         and rownum =1;
       Pkg_a.Set_Item_Value('DESTINATION', row_.destination, Attr_Out);
    end if;
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
    mainrow_ BL_V_MATERIAL_TUILIAOSHENGQING%rowtype;
  BEGIN
    mainrow_.status := pkg_a.Get_Item_Value('STATUS', Rowlist_);
    if mainrow_.status <> '0' then
      RETURN '0';
    end if;
    /*IF Column_Id_ = '��COLUMN��' THEN
      RETURN '0';
    END IF;*/
  END;

  procedure get_RMATERIAL_NO(contract_ in varchar2, seq_ out varchar2) is
    cur_  t_cursor;
    row_  BL_V_MATERIAL_TUILIAOSHENGQING%rowtype;
    sewq_ number; --��ˮ��
    yyyymm_ varchar2(20);
    len_yyyymm_ number;
  begin
    yyyymm_ := to_char(sysdate,'yymm')||contract_;
    len_yyyymm_ := length(yyyymm_);
    open cur_ for
      select nvl(max(substr(t.rmaterial_no,len_yyyymm_+1,3)),0)
        from BL_V_MATERIAL_TUILIAOSHENGQING t
       where substr(t.rmaterial_no,1,len_yyyymm_) = yyyymm_;
    fetch cur_
      into sewq_;
    close cur_;
    seq_ := yyyymm_ ||Substr(To_Char(Power(10, 3) + To_Number(Trim(sewq_)) + 1),2);
  end;

  procedure Requis_Line__(Rowlist_ VARCHAR2,
                          --��ͼ��objid
                          User_Id_ VARCHAR2,
                          --�û�id
                          A311_Key_ VARCHAR2) is
    mainrow_ BL_V_MATERIAL_TUILIAOSHENGQING%rowtype;
    row_     BL_V_BACK_REQUIS_LINE%rowtype;
    cur_     t_Cursor;
    Rowid_   VARCHAR2(1000);
  begin
    Rowid_ := Rowlist_;
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_MATERIAL_TUILIAOSHENGQING T
       WHERE T.ROWID = Rowid_;
    FETCH CUR_
      INTO mainrow_;
    IF CUR_%NOTFOUND THEN
      close cur_;
      raise_application_error(-20101, '�����rowid');
    END IF;
    CLOSE CUR_;
  
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_BACK_REQUIS_LINE T
       WHERE T.RMATERIAL_NO = mainrow_.rmaterial_no;
    FETCH CUR_
      INTO row_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      raise_application_error(-20101, '��ϸ���ύ����');
    END IF;
    CLOSE CUR_;
    --����������ϸ״̬
    update BL_MATERIAL_TUILIAO t set t.status = '1' where t.ROWID = Rowid_;
    update BL_TRANSACTION_HIST t
       set t.status = '1'
     where t.rmaterial_no = mainrow_.rmaterial_no;
    --�ɹ�����Ϣ
    pkg_a.Setsuccess(A311_Key_, 'BL_V_MATERIAL_TUILIAOSHENGQING', Rowid_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '��������' || '[' || mainrow_.rmaterial_no || ']' || '�ύ�ɹ�');
  end;

  procedure Requis_Line2__(Rowlist_ VARCHAR2,
                           --��ͼ��objid
                           User_Id_ VARCHAR2,
                           --�û�id
                           A311_Key_ VARCHAR2) is
    mainrow_ BL_V_MATERIAL_TUILIAOSHENGQING%rowtype;
    row_     BL_V_BACK_REQUIS_LINE%rowtype;
    cur_     t_Cursor;
    Rowid_   VARCHAR2(1000);
  begin
    Rowid_ := Rowlist_;
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_MATERIAL_TUILIAOSHENGQING T
       WHERE T.ROWID = Rowid_;
    FETCH CUR_
      INTO mainrow_;
    IF CUR_%NOTFOUND THEN
      close cur_;
      raise_application_error(-20101, '�����rowid');
    END IF;
    CLOSE CUR_;
  
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_V_BACK_REQUIS_LINE T
       WHERE T.RMATERIAL_NO = mainrow_.rmaterial_no;
    FETCH CUR_
      INTO row_;
    IF CUR_%NOTFOUND THEN
      CLOSE CUR_;
      raise_application_error(-20101, '��ϸ���ύ����');
    END IF;
    CLOSE CUR_;
    --����������ϸ״̬
    update BL_MATERIAL_TUILIAO t set t.status = '0' where t.ROWID = Rowid_;
    update BL_TRANSACTION_HIST t
       set t.status = '0'
     where t.rmaterial_no = mainrow_.rmaterial_no;
    --�ɹ�����Ϣ
    pkg_a.Setsuccess(A311_Key_, 'BL_V_MATERIAL_TUILIAOSHENGQING', Rowid_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '��������' || '[' || mainrow_.rmaterial_no || ']' || 'ȡ���ύ�ɹ�');
  end;
END BL_MATERIAL_TUILIAOAPPLY_API;
/
