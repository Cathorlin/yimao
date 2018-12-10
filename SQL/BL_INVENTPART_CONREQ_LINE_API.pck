CREATE OR REPLACE PACKAGE BL_INVENTPART_CONREQ_LINE_API IS
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
--��ȡ�����������ѷ������ݣ����������
  FUNCTION  Get_QtyINPART_MOVEREQ_(req_no_ varchar2,
                                   line_no_ varchar2,
                                   ls_type_ varchar2) return number;
END BL_INVENTPART_CONREQ_LINE_API;
/
CREATE OR REPLACE PACKAGE BODY BL_INVENTPART_CONREQ_LINE_API IS
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
    CUR_ t_Cursor;
    ROW_ BL_V_BL_INVENTORYPART_CONREQ%ROWTYPE;
  BEGIN
    attr_out :='';
    ROW_.REQ_NO :=pkg_a.Get_Item_Value('REQ_NO',Rowlist_);
    OPEN CUR_ FOR 
    SELECT T.*
     FROM BL_V_BL_INVENTORYPART_CONREQ T 
    WHERE T.REQ_NO = ROW_.REQ_NO;
    fetch cur_ into ROW_;
    if cur_%found then 
        pkg_a.Set_Item_Value('CONTRACT',row_.CONTRACT, attr_out);
        pkg_a.Set_Item_Value('VENDOR_NO',row_.VENDOR_NO, attr_out);
    end if;
    close CUR_;
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
    row_      BL_V_BL_INVENTPART_CONREQ_LINE%rowtype;
    ROW0_     BL_INVENTORYPART_CONREQ_LINE%rowtype;
    BEGIN   
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    IF Doaction_ ='I'THEN
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
        --�����
        ROW0_.REQ_NO  := Pkg_a.Get_Item_Value('REQ_NO', Rowlist_);
        --�к�
        select  nvl(max(LINE_NO),0)+ 1 
        into row0_.LINE_NO 
        from  BL_INVENTORYPART_CONREQ_LINE
        where REQ_NO=row0_.REQ_NO ;
        --��
        ROW0_.CONTRACT  := Pkg_a.Get_Item_Value('CONTRACT', Rowlist_);
        --�����
        ROW0_.PART_NO  := Pkg_a.Get_Item_Value('PART_NO', Rowlist_);
        --����
        ROW0_.vendor_no  := Pkg_a.Get_Item_Value('VENDOR_NO', Rowlist_);
        --����
        ROW0_.QTY  := Pkg_a.Get_Item_Value('QTY', Rowlist_);
        --״̬
        ROW0_.STATE  := Pkg_a.Get_Item_Value('STATE', Rowlist_);
        --��ע
        ROW0_.REMARK  := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
        ROW0_.ENTER_USER :=  User_Id_;
        ROW0_.ENTER_DATE := SYSDATE;
        INSERT INTO BL_INVENTORYPART_CONREQ_LINE(REQ_NO,LINE_NO)
        VALUES(ROW0_.REQ_NO,ROW0_.LINE_NO)
        RETURNING ROWID INTO Objid_;
        UPDATE BL_INVENTORYPART_CONREQ_LINE
        SET  ROW = ROW0_ 
        WHERE ROWID =Objid_;
        Pkg_a.Setsuccess(A311_Key_,'BL_V_BL_INVENTPART_CONREQ_LINE',Objid_);
        RETURN;
    END IF;
    --�޸�
    IF Doaction_ ='M'THEN
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
       Open Cur_ For
        Select t.* From BL_V_BL_INVENTPART_CONREQ_LINE t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,'�����rowid��');
      
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     :='update BL_INVENTORYPART_CONREQ_LINE SET ';
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
         Mysql_ := Mysql_ || ' Where Rowid ='''|| Row_.Objid ||'''';
      -- raise_application_error(Pkg_a.Raise_Error, mysql_);
         Execute Immediate Mysql_;
      End If;
     Pkg_a.Setsuccess(A311_Key_,'BL_V_BL_INVENTPART_CONREQ_LINE', Row_.Objid);
Return;
End If;
--ɾ��
If Doaction_ ='D'Then
   OPEN CUR_ FOR
        SELECT T.* FROM BL_V_BL_INVENTPART_CONREQ_LINE T WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'�����rowid');
        return;
      end if;
      close cur_;
      DELETE FROM BL_INVENTORYPART_CONREQ_LINE T WHERE T.ROWID = OBJID_; 
      pkg_a.Setsuccess(A311_Key_,'BL_V_BL_INVENTPART_CONREQ_LINE', Objid_);
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
row_  BL_V_BL_INVENTPART_CONREQ_LINE%rowtype;
Begin
If Column_Id_ ='PART_NO' Then
   row_.PART_NO     := pkg_a.Get_Item_Value('PART_NO',Rowlist_);
   row_.vendor_no   := pkg_a.Get_Item_Value('VENDOR_NO',Mainrowlist_);
   row_.CONTRACT    := pkg_a.Get_Item_Value('CONTRACT',Mainrowlist_);
   row_.description := PURCHASE_PART_API.get_DESCRIPTION(row_.CONTRACT,row_.PART_NO);
   row_.UNIT_MEAS   := PURCHASE_PART_SUPPLIER_API.GET_BUY_UNIT_MEAS(row_.CONTRACT,row_.PART_NO,row_.vendor_no);
   pkg_a.Set_Item_Value('DESCRIPTION',row_.description,Attr_Out);
   pkg_a.Set_Item_Value('UNIT_MEAS',row_.UNIT_MEAS,Attr_Out);
End If; 
Outrowlist_ := Attr_Out;
End;
/*  �з����仯��ʱ��
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ������� �� ɾ���� ��ť 
      KEY_ ����������ֵ
      User_Id_  ��ǰ�û�
  */
Function Checkbutton__(Dotype_ In Varchar2, Key_ In Varchar2, User_Id_ In Varchar2) Return Varchar2 Is
 row_      BL_V_BL_INVENTORYPART_CONREQ%rowtype;
 cur_ t_Cursor;
Begin
 open cur_  for 
 select  t.*
  from BL_V_BL_INVENTORYPART_CONREQ t 
  where t.REQ_NO = key_;
  fetch cur_ into row_;
  if cur_%found  then 
     if row_.STATE <> '0' then 
       close cur_;
       return '0';
     end if ;
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
row_ BL_V_BL_INVENTPART_CONREQ_LINE%rowtype;
Begin
 row_.objid := pkg_a.Get_Item_Value('OBJID',Rowlist_);
 row_.STATE := pkg_a.Get_Item_Value('STATE',Rowlist_);
 if nvl(row_.objid,'NULL') <>'NULL' AND ROW_.STATE <> '0' then 
     RETURN  '0';
 end if;
 Return'1';
End;
FUNCTION  Get_QtyINPART_MOVEREQ_(req_no_ varchar2,
                                 line_no_ varchar2,
                                 ls_type_ varchar2) return number
 is 
  SQL_    VARCHAR2(1000);
  CUR_    T_CURSOR;
  column_id_ varchar2(100);
  RESULT_ VARCHAR2(500);
 begin
     column_id_ := ls_type_;
    if ls_type_='QTY_MOVED' then 
        column_id_ :=  'decode(state,''0'',qty_moved,0)';
    end if ;
    if ls_type_='WQTY_MOVED' then 
        column_id_ :=  'decode(state,''1'',qty_moved,0)';
    end if ;
    SQL_ := 'Select sum(nvl(' || column_id_ ||',0)) 
            from BL_INVENTORYPART_MOVEREQ_DTL t 
            where t.REQ_NO=''' || req_no_ || '''
            and   t.REQ_LINE_NO='||line_no_;
    OPEN CUR_ FOR SQL_;
    FETCH CUR_
      INTO RESULT_;
    CLOSE CUR_;
    RETURN nvl(RESULT_,0);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
 end ;
End BL_INVENTPART_CONREQ_LINE_API; 
/
