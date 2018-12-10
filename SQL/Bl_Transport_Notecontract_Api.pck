CREATE OR REPLACE Package Bl_Transport_Notecontract_Api Is

  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  Procedure Remove__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2);
  --�жϵ�ǰ���Ƿ�ɱ༭--
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2;
  ----���༭ �޸�
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2;

End Bl_Transport_Notecontract_Api;
/
CREATE OR REPLACE Package Body Bl_Transport_Notecontract_Api Is
  Type t_Cursor Is Ref Cursor;

  /*  ������ʼ�� New__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���requseturl ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ */
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
  Begin
  
    Return;
  End;

  /*  �������� Modify__
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
  */
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Index_     Varchar2(1);
    Doaction_  Varchar2(1);
    Objid_     Varchar2(100);
    Cur_       t_Cursor;
    Row_       Bl_v_Transport_Notecontract%Rowtype;
    Rowm_      Bl_v_Transport_Note%Rowtype;
    Ll_Count_  Number;
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar2(4000);
    Ifmychange Varchar2(1);
  
  Begin
  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
  
    If Doaction_ = 'I' Then
    
      --�ж�����״̬�Ƿ���������ϸ
      Row_.Note_No := Pkg_a.Get_Item_Value('NOTE_NO', Rowlist_);
    
      Open Cur_ For
        Select t.*
          From Bl_v_Transport_Note t
         Where t.Note_No = Row_.Note_No;
      Fetch Cur_
        Into Rowm_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, 'δȡ��������Ϣ');
        Return;
      End If;
      Close Cur_;
    
      If Rowm_.State <> 0 Then
        Raise_Application_Error(-20101,
                                '�˻����뵥' || Row_.Note_No || '�Ǳ���״̬�����������ϸ');
        Return;
      End If;
    
      -- ��ҳ���ȡ����
      Row_.Contract    := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Row_.Containerno := Pkg_a.Get_Item_Value('CONTAINERNO', Rowlist_);
      Row_.Shoptime    := To_Date(Pkg_a.Get_Item_Value('SHOPTIME', Rowlist_),
                                  'YYYY-MM-DDHH24:MI:SS');
      Row_.Contact     := Pkg_a.Get_Item_Value('CONTACT', Rowlist_);
      Row_.Conacttel   := Pkg_a.Get_Item_Value('CONACTTEL', Rowlist_);
      Row_.State       := Pkg_a.Get_Item_Value('STATE', Rowlist_);
      Row_.Remark      := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
    
      -- ������ϸ�������
      Insert Into Bl_Transport_Notecontract
        (Note_No,
         Contract,
         Containerno,
         Shoptime,
         Contact,
         Conacttel,
         State,
         Remark)
        Select Row_.Note_No,
               Row_.Contract,
               Row_.Containerno,
               Row_.Shoptime,
               Row_.Contact,
               Row_.Conacttel,
               Row_.State,
               Row_.Remark
          From Dual;
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_TRANSPORT_NOTECONTRACT', Objid_);
    
      Return;
    End If;
    -- ɾ��
    If Doaction_ = 'D' Then
    
      --�ж���ϸ��״̬�Ƿ����ɾ����ϸ
    
      Open Cur_ For
        Select t.*
          From Bl_v_Transport_Notecontract t
         Where t.Rowid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, 'δȡ����ϸ��Ϣ');
        Return;
      End If;
      Close Cur_;
    
      Delete From Bl_v_Transport_Notecontract t Where t.Rowid = Objid_;
    
      Return;
    End If;
  
    If Doaction_ = 'M' Then
    
      Open Cur_ For
        Select t.*
          From Bl_v_Transport_Notecontract t
         Where t.Rowid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, 'δȡ����ϸ��Ϣ');
        Return;
      End If;
      Close Cur_;
    
      Data_  := Rowlist_;
      Pos_   := Instr(Data_, Index_);
      i      := i + 1;
      Mysql_ := ' update BL_V_TRANSPORT_NOTECONTRACT set ';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'ORDER_SEL' And
           Column_Id_ <> 'PICK_SEL' And Column_Id_ <> 'DOACTION' And
           Length(Nvl(Column_Id_, '')) > 0 Then
          v_         := Substr(v_, Pos1_ + 1);
          i          := i + 1;
          Ifmychange := '1';
          --   if column_id_ = 'DATE_SURE' or column_id_='SURE_SHIPDATE' or column_id_='RECALCU_DATE' then
          --     mysql_ := mysql_ || ' ' || column_id_ || '=to_date(''' || v_  || ''',''YYYY-MM-DD HH24:MI:SS''),';
          --  else
          Mysql_ := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
          --  end if ;
        End If;
      End Loop;
      If Ifmychange = '1' Then
        -- ����sql���
        Mysql_ := Substr(Mysql_, 1, Length(Mysql_) - 1);
        Mysql_ := Mysql_ || ' where rowidtochar(rowid)=''' || Objid_ || '''';
        Execute Immediate Mysql_;
      End If;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_TRANSPORT_NOTECONTRACT', Objid_);
      Return;
    End If;
  End;
  /*  �˻�������ϸɾ�� REMOVE__
      Rowlist_  ɾ���ĵ�ǰ�˻����뵥��ϸ��
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
  */
  Procedure Remove__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
  Begin
    Return;
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
    Cur_     t_Cursor;
    Attr_Out Varchar2(4000);
    Row_     Site_Tab%Rowtype;
  Begin
    /*
    IF COLUMN_ID_ = 'CONTRACT' THEN
      ROW_.CONTRACT := PKG_A.GET_ITEM_VALUE('CONTRACT', ROWLIST_);
    
      OPEN CUR_ FOR
        SELECT T.* FROM SITE_TAB T WHERE T.CONTRACT = ROW_.CONTRACT;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(-20101, '�����rowid');
        RETURN;
      END IF;
      CLOSE CUR_;
      -- ��ֵ
      PKG_A.SET_ITEM_VALUE('CONTRACTDESC', ROW_.CONTRACT_REF, ATTR_OUT);
    END IF;
     */
  
    Pkg_a.Set_Item_Value(Column_Id_,
                         Pkg_a.Get_Item_Value(Column_Id_, Rowlist_),
                         Attr_Out);
    Outrowlist_ := Attr_Out;
  
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
    Row_ Bl_v_Transport_Note%Rowtype;
  Begin
  
    Row_.State := Pkg_a.Get_Item_Value('STATE', Rowlist_);
  
    If Row_.State != '0' Then
      If Column_Id_ = 'PICKLISTNO' Or Column_Id_ = Upper('containerno') Or
         Column_Id_ = Upper('contract') Or Column_Id_ = Upper('shoptime') Or
         Column_Id_ = Upper('contact') Or Column_Id_ = Upper('conactTeL') Or
         Column_Id_ = Upper('remark') Then
        Return '0';
      End If;
    End If;
    Return '1';
  End;

  /*  �з����仯��ʱ��
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ������� �� ɾ���� ��ť 
      KEY_ ����������ֵ
      User_Id_  ��ǰ�û�
  */
  Function Checkbutton__(Dotype_   In Varchar2,
                         Order_No_ In Varchar2,
                         User_Id_  In Varchar2) Return Varchar2 Is
    Row0_ Bl_v_Transport_Note%Rowtype;
    Cur_  t_Cursor;
  Begin
    Open Cur_ For
    --SELECT T.* FROM BL_V_BL_PICKLIST T WHERE T.PICKLISTNO = ORDER_NO_;
      Select t.* From Bl_v_Transport_Note t Where t.Note_No = Order_No_;
    Fetch Cur_
      Into Row0_;
    If Cur_%Found Then
      If Row0_.State = '2' Or Row0_.State = '1' Then
        Return '0';
      End If;
      Close Cur_;
    End If;
    Close Cur_;
    Return '1';
  End;

End Bl_Transport_Notecontract_Api;
/
