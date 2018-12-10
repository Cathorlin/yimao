CREATE OR REPLACE PACKAGE BL_IN_PART_INSTOCKLOC_DT_API IS
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

END BL_IN_PART_INSTOCKLOC_DT_API;
/
CREATE OR REPLACE PACKAGE BODY BL_IN_PART_INSTOCKLOC_DT_API IS
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
    attr_out :='';
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
    Objid_    VARCHAR2(50);
    Index_    VARCHAR2(1);
    Cur_      t_Cursor;
    Doaction_ VARCHAR2(10);
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar(4000);
    Ifmychange Varchar(1); 
    row_      BL_V_BL_IN_PART_INSTOCKLOC_DT%rowtype;
    row0_     BL_IN_PART_INSTOCKLOC_detail%rowtype;
    BEGIN  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    IF Doaction_ ='I'THEN
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      --�����
      row0_.STOCKLOC_NO  := Pkg_a.Get_Item_Value('STOCKLOC_NO', Rowlist_);
      --�к�
      select  nvl(max(LINE_NO),0)+ 1 
       into row0_.LINE_NO 
      from  BL_IN_PART_INSTOCKLOC_detail
      where STOCKLOC_NO=row0_.STOCKLOC_NO ;
      --״̬
      row0_.STATE  := Pkg_a.Get_Item_Value('STATE', Rowlist_);
      --��
      row0_.CONTRACT  := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      --�����
      row0_.PART_NO  := Pkg_a.Get_Item_Value('PART_NO', Rowlist_);

      --���ñ�ʾ��
      row0_.CONFIGURATION_ID  := Pkg_a.Get_Item_Value('CONFIGURATION_ID', Rowlist_);
      --�������
      row0_.LOCATION_NO  := Pkg_a.Get_Item_Value('LOCATION_NO', Rowlist_);
      --����
      row0_.LOT_BATCH_NO  := Pkg_a.Get_Item_Value('LOT_BATCH_NO', Rowlist_);
      --���к�
      row0_.SERIAL_NO  := Pkg_a.Get_Item_Value('SERIAL_NO', Rowlist_);
      --�������
      row0_.ENG_CHG_LEVEL  := Pkg_a.Get_Item_Value('ENG_CHG_LEVEL', Rowlist_);
      --W/D/R��
      row0_.WAIV_DEV_REJ_NO  := Pkg_a.Get_Item_Value('WAIV_DEV_REJ_NO', Rowlist_);
      row0_.enter_user   := User_Id_;
      row0_.enter_date   := sysdate;
       insert into BL_IN_PART_INSTOCKLOC_detail(STOCKLOC_NO,line_no)
             values(row0_.STOCKLOC_NO,row0_.line_no)
             returning rowid into Objid_;
        update BL_IN_PART_INSTOCKLOC_detail
          set  row = row0_
          where rowid= Objid_;
        pkg_a.Setsuccess(A311_Key_,'BL_V_BL_IN_PART_INSTOCKLOC_DT', Objid_);
        RETURN;
    END IF;
    --�޸�
    IF Doaction_ ='M'THEN
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
       Open Cur_ For
        Select t.* From BL_V_BL_IN_PART_INSTOCKLOC_DT t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,'�����rowid��');
      
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     :='update BL_IN_PART_INSTOCKLOC_detail set ';
      Ifmychange :='0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_,'|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
      
        If Column_Id_ <> 'OBJID'  And  Column_Id_ <> 'DOACTION' And
           Length(Nvl(Column_Id_,'')) > 0 Then
          Ifmychange :='1';
          v_         := Substr(v_, Pos1_ + 1);
          Mysql_     := Mysql_ || Column_Id_ || '='''|| v_ ||''',';
        End If;

      End Loop;

      --�û��Զ�����
      If Ifmychange ='1' Then 
         Mysql_ := Mysql_ || 'Modi_Date = Sysdate, Modi_User ='''|| User_Id_ ||''''; 
         Mysql_ := Mysql_ || 'Where Rowid ='''|| Row_.Objid ||'''';
      -- raise_application_error(Pkg_a.Raise_Error, mysql_);
         Execute Immediate Mysql_;
      End If;

    Pkg_a.Setsuccess(A311_Key_,'BL_V_BL_IN_PART_INSTOCKLOC_DT', Row_.Objid); 
    Return;
End If;
--ɾ��
If Doaction_ ='D'Then
   OPEN CUR_ FOR
        SELECT T.* FROM BL_V_BL_IN_PART_INSTOCKLOC_DT T WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'�����rowid');
        return;
      end if;
      close cur_;
      DELETE FROM BL_IN_PART_INSTOCKLOC_detail T WHERE T.ROWID = OBJID_; 
     pkg_a.Setsuccess(A311_Key_,'BL_V_BL_IN_PART_INSTOCKLOC_DT', Objid_);
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
Procedure Itemchange__(Column_Id_ Varchar2, Mainrowlist_ Varchar2, Rowlist_ Varchar2, User_Id_ Varchar2, Outrowlist_ Out Varchar2) Is
Attr_Out Varchar2(4000);
CUR_  t_Cursor;
ROW_  BL_V_BL_IN_PART_INSTOCKLOC_DT%ROWTYPE;
ROW0_ BL_V_INVENT_PART_IN_STOCK_LOC%ROWTYPE;
Begin
If Column_Id_ ='CHOOSE_DATA' Then
  row_.choose_data :=pkg_a.Get_Item_Value('CHOOSE_DATA',Rowlist_);
    OPEN CUR_  FOR
    select  t.*
    from BL_V_INVENT_PART_IN_STOCK_LOC t
    where CHOOSE_DATA= row_.choose_data;
    fetch  cur_ into row0_;
    if cur_%found then
        pkg_a.Set_Item_Value('CONTRACT',row0_.CONTRACT,Attr_Out);
        pkg_a.Set_Item_Value('PART_NO',row0_.PART_NO,Attr_Out);
        pkg_a.Set_Item_Value('PART_DESCRIPTION',row0_.PART_DESCRIPTION,Attr_Out);
        pkg_a.Set_Item_Value('CONFIGURATION_ID',row0_.CONFIGURATION_ID,Attr_Out);
        pkg_a.Set_Item_Value('LOCATION_NO',row0_.LOCATION_NO,Attr_Out);
        pkg_a.Set_Item_Value('LOT_BATCH_NO',row0_.LOT_BATCH_NO,Attr_Out);
        pkg_a.Set_Item_Value('SERIAL_NO',row0_.SERIAL_NO,Attr_Out);
        pkg_a.Set_Item_Value('ENG_CHG_LEVEL',row0_.ENG_CHG_LEVEL,Attr_Out);
        pkg_a.Set_Item_Value('WAIV_DEV_REJ_NO',row0_.WAIV_DEV_REJ_NO,Attr_Out);
        pkg_a.Set_Item_Value('QTY_ONHAND',row0_.QTY_ONHAND,Attr_Out);
        pkg_a.Set_Item_Value('QTY_RESERVED',row0_.QTY_RESERVED,Attr_Out);
        pkg_a.Set_Item_Value('QTY_IN_TRANSIT',row0_.QTY_IN_TRANSIT,Attr_Out);
    end if ;
    close cur_;
End If; 
Outrowlist_ := Attr_Out;
End;
/*  �з����仯��ʱ��
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ������� �� ɾ���� ��ť 
      KEY_ ����������ֵ
      User_Id_  ��ǰ�û�
  */
Function Checkbutton__(Dotype_ In Varchar2, Key_ In Varchar2, User_Id_ In Varchar2) Return Varchar2 Is
  cur_ t_Cursor;
  ROW_ BL_V_BL_IN_PART_INSTOCKLOC%ROWTYPE;
Begin
   open cur_ for 
    select t.*
    from  BL_V_BL_IN_PART_INSTOCKLOC t 
    where t.STOCKLOC_NO =Key_;
    fetch  cur_ into row_;
    if cur_%found then 
        if row_.STATE <> '0' then
          close cur_;
          return '0';
        end if;
    end if;
    close cur_;
   Return'1';
End;

/*  ʵ��ҵ���߼������е� �༭��
      Doaction_   I M ��ϸ�϶�Ϊ M   I ���� M �޸� ҳ�������� ��ǰ�����е� �����Ե��Ժ� ����  
      Column_Id_  ��
      Rowlist_  ��ǰ�û�
      ����: 1 ����
      0 ������
  */
Function Checkuseable(Doaction_ In Varchar2, Column_Id_ In Varchar, Rowlist_ In Varchar2) Return Varchar2 Is
  ROW_ BL_V_BL_IN_PART_INSTOCKLOC_DT%ROWTYPE;
Begin
  ROW_.STATE := PKG_A.Get_Item_Value('STATE',Rowlist_);
  IF ROW_.STATE ='0'  THEN 
      Return'1';
  END IF ;
  RETURN '0';
End;

End BL_IN_PART_INSTOCKLOC_DT_API; 
/
