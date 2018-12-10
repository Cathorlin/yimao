CREATE OR REPLACE Package Bl_Inventorypart_Movereq_Api Is
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

  Procedure Getmovedno(Contract_ In Varchar2, Seq_ Out Varchar2);
  function  GetIMReserve(Part_no_ varchar2,
                         contract_ varchar2,
                         location_no_ varchar2,
                         lot_batch_no_  varchar2,
                         serial_no_ varchar2,
                         eng_chg_level_ varchar2,
                         waiv_dev_rej_no_  varchar2,
                         configuration_id_ varchar2) return number;

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

  Procedure Vary_Commit__(Rowlist_ Varchar2,
                          --��ͼ��objid
                          User_Id_ Varchar2,
                          --�û�id
                          A311_Key_ Varchar2);
  Procedure Varycancel__(Rowlist_ Varchar2,
                         --��ͼ��objid
                         User_Id_ Varchar2,
                         --�û�id
                         A311_Key_ Varchar2);

End Bl_Inventorypart_Movereq_Api;
/
CREATE OR REPLACE Package Body Bl_Inventorypart_Movereq_Api Is
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
    Row_     Bl_v_Inventorypart_Movereq%Rowtype;
  Begin
    Row_.Contract := Pkg_Attr.Get_Default_Contract(User_Id_);
    Pkg_a.Set_Item_Value('CONTRACT', Row_.Contract, Attr_Out);
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
    Doaction_  Varchar2(10);
    Pos_       Number;
    Pos1_      Number;
    i          Number;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar2(4000);
    Ifmychange Varchar2(1);
    Row_       Bl_v_Inventorypart_Movereq%Rowtype;
  Begin
  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    If Doaction_ = 'I' Then
      Row_.Destination_Id       := Pkg_a.Get_Item_Value('DESTINATION_ID',
                                                        Rowlist_);
      Row_.Internal_Destination := Pkg_a.Get_Item_Value('INTERNAL_DESTINATION',
                                                        Rowlist_);
      Row_.Contract             := Pkg_a.Get_Item_Value('CONTRACT',
                                                        Rowlist_);
      --�ж����Ƿ�û��
      If Nvl(Row_.Contract, 'NULL') = 'NULL' Then
        Raise_Application_Error(-20101, '����Ϊ��');
      End If;
      Row_.Requisition_Date := To_Date(Pkg_a.Get_Item_Value('REQUISITION_DATE',
                                                            Rowlist_),
                                       'yyyy-mm-dd');
      Getmovedno(Row_.Contract, Row_.Moved_No);
      Row_.Remark        := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
      Row_.Customer_No   := Pkg_a.Get_Item_Value('CUSTOMER_NO', Rowlist_);
      Row_.Customer_Name := Pkg_a.Get_Item_Value('CUSTOMER_NAME', Rowlist_);
      Row_.Moved_Type    := Pkg_a.Get_Item_Value('MOVED_TYPE', Rowlist_);
      Row_.State         := '0';
      Row_.Location_No   := Pkg_a.Get_Item_Value('LOCATION_NO', Rowlist_);
      Row_.Userid        := User_Id_;
      --���ƿ�������1��ʱ���жϿͻ��źͿ�λ���Ƿ�û��
      If Row_.Moved_Type = '1' or Row_.Moved_Type = '2' Then
        If Nvl(Row_.Location_No, 'NULL') = 'NULL' Then
          Raise_Application_Error(-20101, '��λ�Ų���Ϊ��');
        End If;
      End If;
      Insert Into Bl_Inventorypart_Movereq
        (Moved_No,
         Destination_Id,
         Internal_Destination,
         Contract,
         Requisition_Date,
         Remark,
         Customer_No,
         Moved_Type,
         State,
         Location_No,
         Userid,
         Enter_Date,
         Enter_User)
      Values
        (Row_.Moved_No,
         Row_.Destination_Id,
         Row_.Internal_Destination,
         Row_.Contract,
         Row_.Requisition_Date,
         Row_.Remark,
         Row_.Customer_No,
         Row_.Moved_Type,
         Row_.State,
         Row_.Location_No,
         Row_.Userid,
         Sysdate,
         User_Id_)
      Returning Rowid Into Objid_;
      /*      select t.rowid
       into Objid_
       from BL_INVENTORYPART_MOVEREQ t
      where t.moved_no = Row_.moved_no;*/
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_INVENTORYPART_MOVEREQ', Objid_);
      Return;
    End If;
    --�޸�
    If Doaction_ = 'M' Then
      /*open cur_ for
        select t.*
          from BL_V_INVENTORYPART_MOVEREQ t
         where t.objid = Objid_;
      fetch Cur_
        into Row_;
      if cur_%notfound then
        close cur_;
        raise_application_error(-20101, '�����rowid');
      end if;
      close cur_;*/
      --ȡ�޸ĵ��ֶ�
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     := ' update BL_INVENTORYPART_MOVEREQ set ';
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
          If Column_Id_ = 'REQUISITION_DATE' Then
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
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_INVENTORYPART_MOVEREQ', Objid_);
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
    Row_     Bl_v_Inventorypart_Movereq%Rowtype;
  Begin
    If Column_Id_ = 'CUSTOMER_NO' Then
      Row_.Customer_No   := Pkg_a.Get_Item_Value('CUSTOMER_NO', Rowlist_);
      Row_.Customer_Name := Cust_Ord_Customer_Api.Get_Name(Row_.Customer_No);
      Pkg_a.Set_Item_Value('CUSTOMER_NAME', Row_.Customer_Name, Attr_Out);
    End If;
    If Column_Id_ = 'DESTINATION_ID' Then
      Row_.Destination_Id       := Pkg_a.Get_Item_Value('DESTINATION_ID',
                                                        Rowlist_);
      Row_.Contract             := Pkg_a.Get_Item_Value('CONTRACT',
                                                        Rowlist_);
      Row_.Internal_Destination := Internal_Destination_Api.Get_Description(Row_.Contract,
                                                                            Row_.Destination_Id);
      Pkg_a.Set_Item_Value('INTERNAL_DESTINATION',
                           Row_.Internal_Destination,
                           Attr_Out);
    End If;
    If Column_Id_ = 'LOCATION_NO' Then
      Row_.Contract    := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
      Row_.Location_No := Pkg_a.Get_Item_Value('LOCATION_NO', Rowlist_);
      Row_.Wash        := Inventory_Location_Api.Get_Warehouse(Row_.Contract,
                                                               Row_.Location_No);
      Pkg_a.Set_Item_Value('WASH', Row_.Wash, Attr_Out);
    End If;
    If Column_Id_ = 'MOVED_TYPE' Then
      Row_.Moved_Type := Pkg_a.Get_Item_Value('MOVED_TYPE', Rowlist_);
      If Row_.Moved_Type = '3' or Row_.Moved_Type = '4' Then
      --  Pkg_a.Set_Column_Enable('CUSTOMER_NO', '0', Attr_Out);
        Pkg_a.Set_Column_Enable('LOCATION_NO', '0', Attr_Out);
      Else
       -- Pkg_a.Set_Column_Enable('CUSTOMER_NO', '1', Attr_Out);
        Pkg_a.Set_Column_Enable('LOCATION_NO', '1', Attr_Out);
      End If;
      --�ж��Ƿ����ڲ��ͻ������ⲿ�ͻ�
      row_.customer_no :=pkg_a.Get_Item_Value('CUSTOMER_NO',Rowlist_);
      if length( row_.customer_no) = 2  then
         if  Row_.Moved_Type = '1' or Row_.Moved_Type = '2'  then
             Pkg_a.Set_Item_Value('CUSTOMER_NO', '', Attr_Out);
             Pkg_a.Set_Item_Value('CUSTOMER_NAME', '', Attr_Out);
         end if ;
      else
         if  Row_.Moved_Type = '3' or Row_.Moved_Type = '4'  then
             Pkg_a.Set_Item_Value('CUSTOMER_NO', '', Attr_Out);
             Pkg_a.Set_Item_Value('CUSTOMER_NAME', '', Attr_Out);
         end if ;
      end if ;
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
    Row_ Bl_v_Inventorypart_Movereq%Rowtype;
  Begin
    If Column_Id_ = 'REMARK' Then
      Return '1';
    End If;
    Row_.Objid := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Row_.Objid := Nvl(Row_.Objid, 'NULL');
    If Row_.Objid <> 'NULL' Then
      Return '0';
    End If;
  
    Row_.State := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    If Row_.State <> 0 Then
      Return '0';
    End If;
    /*    IF Column_Id_ = '��COLUMN��' THEN
          RETURN '0';
        END IF;  
    */
  End;

  Procedure Getmovedno(Contract_ In Varchar2, Seq_ Out Varchar2) Is
    Row_  Bl_v_Inventorypart_Movereq%Rowtype;
    Cur_  t_Cursor;
    Seqw_ Number; --��ˮ��
  Begin
    Open Cur_ For
      Select Nvl(Max(To_Number(Substr(Moved_No, 7, 3))), '0')
        From Bl_v_Inventorypart_Movereq t
       Where t.Contract = Contract_;
    Fetch Cur_
      Into Seqw_;
  
    Seq_ := To_Char(Sysdate, 'YYYY') || Contract_ ||
            Trim(To_Char(Seqw_ + 1, '000'));
  End;
  function  GetIMReserve(Part_no_ varchar2,
                         contract_ varchar2,
                         location_no_ varchar2,
                         lot_batch_no_  varchar2,
                         serial_no_ varchar2,
                         eng_chg_level_ varchar2,
                         waiv_dev_rej_no_  varchar2,
                         configuration_id_ varchar2) return number
  is 
  row_ Bl_Inventorypart_Movereq_Dtl%rowtype;
  cur_ t_Cursor;
  result_ number;
  begin
     open cur_  for 
     select sum(nvl(t.QTY_MOVED,0) - nvl(t.QTY_COMFIRM,0))
     from Bl_Inventorypart_Movereq_Dtl t
     where   STATE ='0' or state='1';
     fetch  cur_ into result_;
     close cur_;  
     return nvl(result_,0); 
  end;
  Procedure Changestate__(Rowlist_ Varchar2,
                          --��ͼ��objid
                          User_Id_ Varchar2,
                          --�û�id
                          A311_Key_ Varchar2) Is
    Cur_   t_Cursor;
    Row_   Bl_Inventorypart_Movereq%Rowtype;
    Row0_  Bl_Inventorypart_Movereq_Dtl%Rowtype;
    Rowid_ Varchar2(1000);
  Begin
    Rowid_ := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_Inventorypart_Movereq t Where t.Rowid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '�����rowid');
    End If;
    Close Cur_;
  
    Open Cur_ For
      Select t.*
        From Bl_Inventorypart_Movereq_Dtl t
       Where t.Moved_No = Row_.Moved_No;
    Fetch Cur_
      Into Row0_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '��ϸ���ύ����');
    End If;
    Close Cur_;
    --��������
    Update Bl_Inventorypart_Movereq t
       Set t.State = '1'
     Where t.Rowid = Rowid_;
    --������ϸ��
    Update Bl_Inventorypart_Movereq_Dtl T1
       Set T1.State = '1'
     Where T1.Moved_No = Row_.Moved_No;
  
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_INVENTORYPART_MOVEREQ', Rowid_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '�ƿ�����' || '[' || Row_.Moved_No || ']' || '�ύ�ɹ�');
  End;

  Procedure Changestatecancel__(Rowlist_ Varchar2,
                                --��ͼ��objid
                                User_Id_ Varchar2,
                                --�û�id
                                A311_Key_ Varchar2) Is
    Cur_   t_Cursor;
    Row_   Bl_Inventorypart_Movereq%Rowtype;
    Rowid_ Varchar2(1000);
  Begin
    Rowid_ := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_Inventorypart_Movereq t Where t.Rowid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '�����rowid');
    End If;
    Close Cur_;
  
    --��������
    Update Bl_Inventorypart_Movereq t
       Set t.State = '0'
     Where t.Rowid = Rowid_;
    --������ϸ��
    Update Bl_Inventorypart_Movereq_Dtl T1
       Set T1.State = '0'
     Where T1.Moved_No = Row_.Moved_No;
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_INVENTORYPART_MOVEREQ', Rowid_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '�ƿ�����' || '[' || Row_.Moved_No || ']' || 'ȡ���ύ�ɹ�');
  End;

  Procedure Vary_Commit__(Rowlist_ Varchar2,
                          --��ͼ��objid
                          User_Id_ Varchar2,
                          --�û�id
                          A311_Key_ Varchar2) Is
    Cur_   t_Cursor;
    Row_   Bl_Inventorypart_Movereq%Rowtype;
    Row0_  Bl_Inventorypart_Movereq_Dtl%Rowtype;
    Rowid_ Varchar2(1000);
  Begin
    Rowid_ := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_Inventorypart_Movereq t Where t.Rowid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '�����rowid');
    End If;
    Close Cur_;
  
    Open Cur_ For
      Select t.*
        From Bl_Inventorypart_Movereq_Dtl t
       Where t.Moved_No = Row_.Moved_No;
    Fetch Cur_
      Into Row0_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '��ϸ������');
    End If;
    Close Cur_;
    --��������
    Update Bl_Inventorypart_Movereq t
       Set t.State = '1'
     Where t.Moved_No =  Row_.Moved_No;
    --������ϸ��
    Update Bl_Inventorypart_Movereq_Dtl T1
       Set T1.State = '1'
     Where T1.Moved_No = Row_.Moved_No;
/*  -- ����Ԥ����¼modify 2013-01-01
          insert into BL_IMRESERVE( key_no      ,
                                  line_no        ,
                                  part_no        ,
                                  qty_assigned    ,
                                  qty_shipped     ,
                                  contract       ,
                                  location_no     ,
                                  lot_batch_no     ,
                                  serial_no        ,
                                  eng_chg_leve     ,
                                  waiv_dev_rej_no  ,
                                  configuration_id ,
                                  enter_user       ,
                                  enter_date  )
                         select     MOVED_NO      ,
                                    MOVED_NO_LINE        ,
                                    part_no        ,
                                    QTY_MOVED    ,
                                    0     ,
                                    contract       ,
                                    location_no     ,
                                    lot_batch_no     ,
                                    serial_no        ,
                                    eng_chg_level     ,
                                    waiv_dev_rej_no  ,
                                    configuration_id ,
                                    user_id_       ,
                                    sysdate
                           from  BL_INVENTORYPART_MOVEREQ_DTL
                           where Moved_No = Row_.Moved_No
                             and  state ='1';*/
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_INVENTORYPART_MOVEREQ', Rowid_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '�ƿ�����' || '[' || Row_.Moved_No || ']' || '�´�ɹ�');
  End;
  Procedure Varycancel__(Rowlist_ Varchar2,
                         --��ͼ��objid
                         User_Id_ Varchar2,
                         --�û�id
                         A311_Key_ Varchar2) Is
    Cur_   t_Cursor;
    Row_   Bl_Inventorypart_Movereq%Rowtype;
    Row0_  Bl_Inventorypart_Movereq_Dtl%Rowtype;
    Rowid_ Varchar2(1000);
  Begin
    Rowid_ := Rowlist_;
    Open Cur_ For
      Select t.* From Bl_Inventorypart_Movereq t Where t.Rowid = Rowid_;
    Fetch Cur_
      Into Row_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(-20101, '�����rowid');
    End If;
    Close Cur_;
  
    --��������
    Update Bl_Inventorypart_Movereq t
       Set t.State = '0'
     Where t.Moved_No = Row_.Moved_No;
    --������ϸ��
    Update Bl_Inventorypart_Movereq_Dtl T1
       Set T1.State = '0'
     Where T1.Moved_No = Row_.Moved_No;
     --ȡ����ɾ����¼
   /*  delete  from BL_IMRESERVE  where key_no = Row_.Moved_No;*/
    Pkg_a.Setsuccess(A311_Key_, 'BL_V_INVENTORYPART_MOVEREQ', Rowid_);
    Pkg_a.Setmsg(A311_Key_,
                 '',
                 '�ƿ�����' || '[' || Row_.Moved_No || ']' || 'ȡ���´�ɹ�');
  End;
End Bl_Inventorypart_Movereq_Api;
/
