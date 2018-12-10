CREATE OR REPLACE Package Bl_Inventorypart_Accept_Api Is
  /*  ������ʼ�� New__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���requseturl ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ */
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2);

  /*  �������� Modify__
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
  */
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2);
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
                         Outrowlist_  Out Varchar2);
  /*  �з����仯��ʱ��
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ������� �� ɾ���� ��ť 
      KEY_ ����������ֵ
      User_Id_  ��ǰ�û�
  */
  Function Checkbutton__(Dotype_  In Varchar2,
                         Key_     In Varchar2,
                         User_Id_ In Varchar2) Return Varchar2;

  /*  ʵ��ҵ���߼������е� �༭��
      Doaction_   I M ��ϸ�϶�Ϊ M   I ���� M �޸� ҳ�������� ��ǰ�����е� �����Ե��Ժ� ����  
      Column_Id_  ��
      Rowlist_  ��ǰ�û�
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2;

  Procedure Changestate__(Rowlist_ Varchar2,
                          --��ͼ��objid
                          User_Id_ Varchar2,
                          --�û�id
                          A311_Key_ Varchar2);

  Procedure Changestatecancel__(Rowlist_ Varchar2,
                                --��ͼ��objid
                                User_Id_ Varchar2,
                                --�û�id
                                A311_Key_ Varchar2);

  Procedure Changestatecompleted__(Rowlist_ Varchar2,
                                   --��ͼ��objid
                                   User_Id_ Varchar2,
                                   --�û�id
                                   A311_Key_ Varchar2);
End Bl_Inventorypart_Accept_Api;
/
CREATE OR REPLACE Package Body Bl_Inventorypart_Accept_Api Is
  Type t_Cursor Is Ref Cursor;
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
  Procedure New__(Rowlist_ Varchar2, User_Id_ Varchar2, A311_Key_ Varchar2) Is
    Attr_Out Varchar2(4000);
  Begin
    Attr_Out := '';
  
    -- pkg_a.Set_Item_Value('��COLUMN��', '��VALUE��', attr_out);
    Pkg_a.Setresult(A311_Key_, Attr_Out);
  End;

  /*  �������� Modify__
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
  */
  Procedure Modify__(Rowlist_  Varchar2,
                     User_Id_  Varchar2,
                     A311_Key_ Varchar2) Is
    Objid_     Varchar2(50);
    Index_     Varchar2(1);
    Cur_       t_Cursor;
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar2(4000);
    Ifmychange Varchar2(1);
    Row_       Bl_v_Inventorypart_Accept_Dtl%Rowtype;
    Doaction_  Varchar2(10);
  Begin
  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    If Doaction_ = 'I' Then
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
      Return;
    End If;
    --�޸�
    If Doaction_ = 'M' Then
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := ' update BL_INVENTORYPART_MOVEREQ_DTL set ';
      Ifmychange := '0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_         := Substr(Data_, 1, Pos_ - 1);
        Data_      := Substr(Data_, Pos_ + 1);
        Pos_       := Instr(Data_, Index_);
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' And
           Length(Nvl(Column_Id_, '')) > 0 Then
          v_         := Substr(v_, Pos1_ + 1);
          i          := i + 1;
          Ifmychange := '1';
          If Column_Id_ = 'EXPIRATION_DATE' Then
            Mysql_ := Mysql_ || ' ' || Column_Id_ || '=to_date(''' || v_ ||
                      ''',''YYYY-MM-DD''),';
          Else
            Mysql_ := Mysql_ || ' ' || Column_Id_ || '=''' || v_ || ''',';
          End If;
        End If;
      End Loop;
      If Ifmychange = '1' Then
        -- ����sql��� 
        Mysql_ := Substr(Mysql_, 1, Length(Mysql_) - 1);
        Mysql_ := Mysql_ || ' where rowidtochar(rowid)=''' || Objid_ || '''';
      
        Execute Immediate Mysql_;
      End If;
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_INVENTORYPART_ACCEPT_DTL', Objid_);
      Return;
    End If;
    --ɾ��
    If Doaction_ = 'D' Then
      --pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
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
    Row_     Inventory_Location%Rowtype;
    Cur_     t_Cursor;
    Row1_    Bl_v_Inventorypart_Accept_Dtl%Rowtype;
  Begin
    Row1_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Open Cur_ For
      Select T1.*
        From Bl_v_Inventorypart_Accept_Dtl T1
       Where T1.Objid = Row1_.Objid;
    Fetch Cur_
      Into Row1_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, 'δ�ҵ�����');
      Return;
    End If;
    Close Cur_;
  
    If Column_Id_ = 'LOCATION_NO_DEST' Then
      Row_.Location_No := Pkg_a.Get_Item_Value('LOCATION_NO_DEST', Rowlist_);
      Row_.Contract    := Pkg_a.Get_Item_Value('CONTRACT_DEST', Rowlist_);
    
      Open Cur_ For
        Select t.*
          From Inventory_Location t
         Where Exists (Select 1
                  From A00707_V01 A1
                 Where A1.A007_Id = User_Id_
                   And A1.Contract = Row_.Contract
                   And A1.Location_No = Row_.Location_No)
           And t.Contract = Row_.Contract;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Close Cur_;
        Raise_Application_Error(-20101, 'δ�ҵ�����');
        Return;
      End If;
      Close Cur_;
      /*      --      Pkg_a.Set_Item_Value('CONTRACT_DEST', row1_.contract_dest, Attr_Out);
      --     Pkg_a.Set_Item_Value('LOCATION_NO_DEST',
       --                         row1_.location_no_dest,
       --                         Attr_Out);
           row1_.warehouse_dest := INVENTORY_LOCATION_API.Get_Warehouse(row1_.contract_dest,
                                                                        row1_.location_no_dest);
      row1_.warehouse_dest := pkg_a.Set_Item_Value('WAREHOUSE_DEST',
                                                   row_.WAREHOUSE_DEST,
                                                   attr_out);*/
      Pkg_a.Set_Item_Value('WAREHOUSE_DEST', Row_.Warehouse, Attr_Out);
    
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
    If Dotype_ = 'ADD_ROW' Then
      Return '1';
    
    End If;
    If Dotype_ = 'DEL_ROW' Then
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
    Row_ Bl_v_Inventorypart_Accept_Dtl%Rowtype;
  Begin
    Row_.State := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    If Row_.State > 2 Then
      Return '0';
    End If;
    Return '1';
  End;

  Procedure Changestate__(Rowlist_ Varchar2,
                          --��ͼ��objid
                          User_Id_ Varchar2,
                          --�û�id
                          A311_Key_ Varchar2) Is
    Cur_   t_Cursor;
    Row_   Bl_Inventorypart_Movereq_Dtl%Rowtype;
    Rowid_ Varchar2(2000);
  Begin
    Rowid_ := Rowlist_;
    Open Cur_ For
      Select t.*
        From Bl_Inventorypart_Movereq_Dtl t
       Where t.Rowid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '�����rowid');
    End If;
    Close Cur_;
    --����״̬
    Update Bl_Inventorypart_Movereq_Dtl t
       Set t.State = '2'
     Where t.Rowid = Rowid_;
    Return;
  End;

  Procedure Changestatecancel__(Rowlist_ Varchar2,
                                --��ͼ��objid
                                User_Id_ Varchar2,
                                --�û�id
                                A311_Key_ Varchar2) Is
    Cur_   t_Cursor;
    Row_   Bl_Inventorypart_Movereq_Dtl%Rowtype;
    Rowid_ Varchar2(1000);
  Begin
    Rowid_ := Rowlist_;
    Open Cur_ For
      Select t.*
        From Bl_Inventorypart_Movereq_Dtl t
       Where t.Rowid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '�����rowid');
    End If;
    Close Cur_;
  
    --��������
    Update Bl_Inventorypart_Movereq_Dtl t
       Set t.State = '1'
     Where t.Rowid = Rowid_;
  End;
  Procedure Changestatecompleted__(Rowlist_ Varchar2,
                                   --��ͼ��objid
                                   User_Id_ Varchar2,
                                   --�û�id
                                   A311_Key_ Varchar2) Is
    Cur_            t_Cursor;
    Rowt_           Bl_Inventorypart_Movereq_Dtl%Rowtype;
    Row_            Bl_v_Inventorypart_Accept_Dtl%Rowtype;
    Bl_Move         Bl_Inventorypart_Movereq_Tran%Rowtype;
    Row1_           Inventory_Location%Rowtype;
    Rowid_          Varchar2(1000);
    Pallet_Id_List_ Varchar2(4000);
  Begin
    Rowid_          := Rowlist_;
    Pallet_Id_List_ := '';
    Row_.Objid      := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    /*    --��״̬
    OPEN CUR_ FOR
      SELECT T.*
        FROM BL_INVENTORYPART_MOVEREQ_DTL T
       WHERE T.ROWID = row_.objid;
    FETCH CUR_
      INTO ROWT_;
    IF CUR_%NOTFOUND THEN
      close cur_;
      raise_application_error(-20101, '�����rowid');
    END IF;
    CLOSE CUR_;*/
  
    --�ƿ��´�
    Open Cur_ For
      Select t.*
        From Bl_v_Inventorypart_Accept_Dtl t
       Where t.Objid = Row_.Objid;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '�����rowid');
    End If;
    Close Cur_;
    Row_.Qty_Comfirmed    := Pkg_a.Get_Item_Value('QTY_COMFIRMED', Rowlist_);
    Row_.Location_No_Dest := Pkg_a.Get_Item_Value('LOCATION_NO_DEST',
                                                  Rowlist_);
    Insert Into A1
      (Col, Col01, Id)
      Select Row_.Qty_Comfirmed, Row_.Qty_Comfirm, s_A0.Nextval From Dual;

    If Row_.Qty_Comfirmed + Row_.Qty_Comfirm > Row_.Qty_Moved Then
      Raise_Application_Error(-20101,
                              '�������������������������ĺͲ��ܴ�����������');
    End If;
    If Row_.Qty_Comfirmed <= 0 Then
      Raise_Application_Error(-20101, '��������ȷ����������');
    End If;
    If Nvl(Row_.Location_No_Dest, 'NULL') = 'NULL' Then
      Raise_Application_Error(-20101, '��������ȷ��Ŀ�Ŀ�λ��');
    End If;
  
    Open Cur_ For
      Select *
        From Inventory_Location i
       Where i.Contract = Row_.Contract_Dest
         And i.Location_No = Row_.Location_No_Dest;
    Fetch Cur_
      Into Row1_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, 'Ŀ�Ŀ�λ����Ŀ�����в�����');
      Return;
    End If;
    Close Cur_;
  
    Inventory_Part_In_Stock_Api.Move_Part(Pallet_Id_List_,
                                          Row_.Contract,
                                          Row_.Part_No,
                                          Row_.Configuration_Id,
                                          Row_.Location_No,
                                          Row_.Lot_Batch_No,
                                          Row_.Serial_No,
                                          Row_.Eng_Chg_Level,
                                          Row_.Waiv_Dev_Rej_No,
                                          Row_.Expiration_Date,
                                          Row_.Contract_Dest,
                                          Row_.Location_No_Dest,
                                          Row_.Destination,
                                          Row_.Qty_Comfirmed,
                                          Row_.Qty_Reserved,
                                          Null);
  
    Select Max(t.Transaction_Id)
      Into Row_.Transaction_Id
      From Inventory_Transaction_Hist2 t
     Where t.Contract = Row_.Contract
       And t.Part_No = Row_.Part_No
       And t.Location_No = Row_.Location_No
       And t.Lot_Batch_No = Row_.Lot_Batch_No
       And t.Serial_No = Row_.Serial_No
       And t.Waiv_Dev_Rej_No = Row_.Waiv_Dev_Rej_No
       And t.Eng_Chg_Level = Row_.Eng_Chg_Level
       And t.Configuration_Id = Row_.Configuration_Id
       And t.Transaction_Code In ('INVM-ISS', 'INVM-OUT', 'COMPM-OUT');
  
    Bl_Move.Moved_No       := Row_.Moved_No;
    Bl_Move.Moved_No_Line  := Row_.Moved_No_Line;
    Bl_Move.Qty_Moved      := Row_.Qty_Comfirm;
    Bl_Move.Transaction_Id := Row_.Transaction_Id;
    Bl_Move.Enter_Date     := Sysdate;
    Bl_Move.Enter_User     := User_Id_;
    Insert Into Bl_Inventorypart_Movereq_Tran
      (Moved_No,
       Moved_No_Line,
       Qty_Moved,
       Transaction_Id,
       Enter_Date,
       Enter_User)
    Values
      (Bl_Move.Moved_No,
       Bl_Move.Moved_No_Line,
       Bl_Move.Qty_Moved,
       Bl_Move.Transaction_Id,
       Bl_Move.Enter_Date,
       Bl_Move.Enter_User);
  
    --�����ƿ�������״̬
    Update Bl_Inventorypart_Movereq_Dtl T1
       Set T1.State       =  (case when (Nvl(T1.Qty_Comfirm, 0) + Row_.Qty_Comfirmed)=T1.QTY_MOVED then 
                              '3'  else '2' end),
           T1.Qty_Comfirm = Nvl(T1.Qty_Comfirm, 0) + Row_.Qty_Comfirmed,
           T1.Modi_Date   = Sysdate,
           T1.Modi_User   = User_Id_
     Where T1.Moved_No = Row_.Moved_No
       and T1.MOVED_NO_LINE=ROW_.moved_no_line;
  
    --�����ƿ�����״̬
    Update Bl_Inventorypart_Movereq t
       Set t.State = (case when not exists(select 1 
                                           from Bl_Inventorypart_Movereq_Dtl t1
                                           where t.MOVED_NO=t1.MOVED_NO
                                           and  T1.state='2')  
                     then '3' else '2' end)
     Where t.Moved_No = Row_.Moved_No;
     --����Ԥ����¼
/*     update BL_IMRESERVE
       set  QTY_ASSIGNED=0,
            QTY_SHIPPED =QTY_ASSIGNED,
            modi_user = User_Id_,
            modi_date = sysdate
      where key_no  = ROW_.MOVED_NO
      and   LINE_NO = ROW_.moved_no_line;*/
    --�ɹ�����Ϣ
    Pkg_a.Setsuccess(A311_Key_,
                     'BL_INVENTORYPART_MOVEREQ_DTL',
                     Pallet_Id_List_);
  End;

End Bl_Inventorypart_Accept_Api;
/
