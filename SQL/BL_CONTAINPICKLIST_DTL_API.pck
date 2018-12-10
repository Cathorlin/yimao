CREATE OR REPLACE PACKAGE BL_CONTAINPICKLIST_DTL_API IS
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

END BL_CONTAINPICKLIST_DTL_API;
/
CREATE OR REPLACE PACKAGE BODY BL_CONTAINPICKLIST_DTL_API IS
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
    i          Number:=1;
    v_         Varchar(1000);
    Column_Id_ Varchar(1000);
    Data_      Varchar(4000);
    Mysql_     Varchar(4000);
    Ifmychange Varchar(1);
     row_      BL_V_CONTAINPICKLIST_DTL%rowtype;
    BEGIN  
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    IF Doaction_ ='I'THEN
     
                  --CONTAIN_NO
                  row_.CONTAIN_NO  := Pkg_a.Get_Item_Value('CONTAIN_NO', Rowlist_);
                  --NOTE_NO
                  row_.NOTE_NO  := Pkg_a.Get_Item_Value('NOTE_NO', Rowlist_);
                  --REMARK
                  row_.REMARK  := Pkg_a.Get_Item_Value('REMARK', Rowlist_);
                  --picklistno
                  ROW_.PICKLISTNO:=PKG_A.Get_Item_Value('PICKLISTNO',ROWLIST_);
                  --booking_NO
                  ROW_.BOOKING_NO:=PKG_A.GET_ITEM_VALUE('BOOKING_NO',ROWLIST_);
                  --STATE
                 -- row_.STATE  := Pkg_a.Get_Item_Value('STATE', Rowlist_);
                 
                 INSERT INTO bL_containpicklist_dtl (
                 CONTAIN_NO,
                 NOTE_NO,
                 REMARK,
                 PICKLISTNO,
                 BOOKING_NO,
                 STATE)
                  SELECT 
                  ROW_.CONTAIN_NO,
                  ROW_.NOTE_NO,
                  ROW_.REMARK,
                  ROW_.PICKLISTNO,
                  ROW_.BOOKING_NO,
                  '0' FROM 
                  DUAL;
                  RETURN;
    END IF;
    --�޸�
    IF Doaction_ ='M'THEN
     
       Open Cur_ For
        Select t.* From BL_V_CONTAINPICKLIST_DTL t Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        Raise_Application_Error(Pkg_a.Raise_Error,'�����rowid��');
      
      End If;
      Close Cur_;
      Data_      := Rowlist_;
      Pos_       := Instr(Data_, Index_);
      i          := i + 1;
      Mysql_     :='update bL_containpicklist_dtl set ';
      Ifmychange :='0';
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
       i          := i + 1;
        Pos1_      := Instr(v_,'|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
      
        If Column_Id_ <> UPPER('Objid')  And  Column_Id_ <> UPPER('Doaction') And
           Length(Nvl(Column_Id_,'')) > 0 Then
          Ifmychange :='1';
          v_         := Substr(v_, Pos1_ + 1);
          Mysql_     := Mysql_ || Column_Id_ || '='''|| v_ ||''',';
  End If;

End Loop;

--�û��Զ�����
If Ifmychange ='1' Then 
  Mysql_:=SUBSTR(MYSQL_,1,LENGTH(Mysql_)-1);
   Mysql_ := Mysql_ ||' Where Rowid ='''|| Row_.Objid ||'''';
-- raise_application_error(Pkg_a.Raise_Error, mysql_);
   Execute Immediate Mysql_;
End If;

Pkg_a.Setsuccess(A311_Key_,'BL_V_CONTAINPICKLIST_DTL', Row_.Objid); 
Return;
End If;
--ɾ��
If Doaction_ ='D'Then
   OPEN CUR_ FOR
        SELECT T.* FROM  BL_V_CONTAINPICKLIST_DTL T WHERE T.objid = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error,'�����rowid');
        return;
      end if;
      close cur_;
     DELETE FROM bL_containpicklist_dtl T WHERE T.ROWID = OBJID_; 
     pkg_a.Setsuccess(A311_Key_,'BL_V_CONTAINPICKLIST_DTL', Objid_);
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
ROW_ BL_V_CONTAINPICKLIST_DTL%ROWTYPE;
Begin
If Column_Id_ =UPPER('note_NO') Then
--���и�ֵ
ROW_.NOTE_NO:=PKG_A.Get_Item_Value('NOTE_NO',Rowlist_);
SELECT T.PICKLISTNO INTO ROW_.PICKLISTNO FROM bl_transport_note T
WHERE T.NOTE_NO=ROW_.NOTE_NO;
SELECT T.booking_NO  INTO ROW_.BOOKING_NO FROM bl_transport_note T
WHERE T.NOTE_NO=ROW_.NOTE_NO;

Pkg_a.Set_Item_Value('PICKLISTNO',ROW_.PICKLISTNO, Attr_Out);

Pkg_a.Set_ITEM_VALUE('BOOKING_NO',ROW_.BOOKING_NO, Attr_Out);


End If; 
Outrowlist_ := Attr_Out;
End;
/*  �з����仯��ʱ��
      Dotype_   ADD_ROW  DEL_ROW ��Ҫ���� ��ϸ������� �� ɾ���� ��ť 
      KEY_ ����������ֵ
      User_Id_  ��ǰ�û�
  */
Function Checkbutton__(Dotype_ In Varchar2, Key_ In Varchar2, User_Id_ In Varchar2) Return Varchar2 Is
  cur_ t_cursor;
  ROW_ bL_containpicklist%ROWTYPE;
Begin
OPEN cur_ FOR SELECT T.* FROM bL_containpicklist T WHERE T.CONTAIN_NO=KEY_;
    FETCH CUR_ INTO ROW_;
    IF CUR_%FOUND THEN
    If Dotype_ = UPPER('Add_Row') AND ROW_.STATE='1' Then
      Return '0';
    End If;
    If Dotype_ = UPPER('Del_Row')  AND ROW_.STATE='1' Then
      Return '0';
    End If;
    END IF;
    CLOSE CUR_;
    Return '1';
End;

/*  ʵ��ҵ���߼������е� �༭��
      Doaction_   I M ��ϸ�϶�Ϊ M   I ���� M �޸� ҳ�������� ��ǰ�����е� �����Ե��Ժ� ����  
      Column_Id_  ��
      Rowlist_  ��ǰ�û�
      ����: 1 ����
      0 ������
  */
Function Checkuseable(Doaction_ In Varchar2, Column_Id_ In Varchar, Rowlist_ In Varchar2) Return Varchar2 Is
  ROW_ BL_V_CONTAINPICKLIST%ROWTYPE;
 --STATE_ VARCHAR2(1);
Begin
  /*ROW_.OBJID:=PKG_A.GET_ITEM_VALUE('OBJID',ROWLIST_);
  OPEN CUR_ FOR SELECT T.*��FROM BL_V_CONTAINPICKLIST T WHERE T.OBJID=ROW_.OBJID;
  FETCH CUR_ INTO ROW_;
  IF CUR_%NOTFOUND THEN
    CLOSE CUR_;
    RETURN'1';
    END IF;*/
    /*ROW_.OBJID:=PKG_A.GET_ITEM_VALUE('OBJID',ROWLIST_);
    
    SELECT STATE INTO STATE_ FROM BL_V_CONTAINPICKLIST T WHERE  T.OBJID=ROW_.OBJID;*/
     ROW_.STATE := PKG_A.GET_ITEM_VALUE('STATE', ROWLIST_);
    ROW_.OBJID := PKG_A.GET_ITEM_VALUE('OBJID', ROWLIST_);
    
  IF ROW_.state!='0' THEN
    If Column_Id_ =UPPER('remark') 
      OR Column_Id_=UPPER('picklistno') 
      OR Column_Id_=UPPER('booking_NO')
      OR  Column_Id_ =UPPER('note_NO')
  Then Return '0';
  End If;
END IF;
 Return'1';
End;

End BL_CONTAINPICKLIST_DTL_API; 
/
