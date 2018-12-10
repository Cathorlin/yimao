CREATE OR REPLACE PACKAGE BL_CUSTOMER_DELIVERY_LINE IS
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
  procedure get_dp_line(ORDER_NO_     in varchar,
                        DELPLAN_NO_   in varchar,
                        QTY_DELIVED_  NUMBER,
                        DELIVED_DATE_ in varchar,
                        user_id_      in varchar2);
  procedure Get_Dp_Head(ORDER_NO_     in varchar,
                        supplier_     in varchar,
                        delived_date_ date,
                        user_id_      in varchar2,
                        DpROW_        out bl_delivery_plan_v%rowtype);
  FUNCTION Checkuseable(Doaction_  IN VARCHAR2,
                        Column_Id_ IN VARCHAR,
                        Rowlist_   IN VARCHAR2) RETURN VARCHAR2;

END BL_CUSTOMER_DELIVERY_LINE;
/
CREATE OR REPLACE PACKAGE BODY BL_CUSTOMER_DELIVERY_LINE IS
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
    COROW_        BL_V_CUST_ORD_LINE_V01%ROWTYPE;
    Blrowv02      Bl_v_Customer_Order_V02%ROWTYPE;
    COROWV03_     BL_V_CUSTOMER_ORDER_V03%ROWTYPE;
    PHDROW_       BL_V_CUST_ORDER_LINE_PHDELIVE%ROWTYPE;
    ROWLINE_      BL_V_CUST_ORDER_LINE_DETAIL%ROWTYPE;
    DROW_         Bl_Delivery_Plan%ROWTYPE;
    ROW_          BL_DELIVERY_PLAN_DETIAL%ROWTYPE;
    row__         BL_DELIVERY_PLAN_DETIAL_v%ROWTYPE; --���
    PDROW_        Bl_v_Cust_Order_Line_Phdelive%ROWTYPE;
    ccrow_        BL_V_CUST_ORDER_LINE_DETAIL%ROWTYPE;
    headrow_      Bl_v_Customer_Order_Line%ROWTYPE;
    maincorow_    Bl_v_Customer_Order_Line%ROWTYPE;
    DpROW_        Bl_Delivery_Plan_v%ROWTYPE;
    Objid_        VARCHAR2(50);
    Index_        VARCHAR2(1);
    Cur_          t_Cursor;
    Doaction_     VARCHAR2(10);
    Attr_OUT      VARCHAR2(4000);
    Data_         VARCHAR2(4000);
    QTY_DELIVED_  NUMBER;
    DELPLAN_LINE_ NUMBER;
    Pos_          NUMBER;
    Pos1_         NUMBER;
    i             NUMBER;
    Mysql_        VARCHAR2(4000);
    v_            VARCHAR2(4000);
    Column_Id_    VARCHAR2(4000);
    If_Datechange VARCHAR2(10);
    coobjid_      varchar2(100);
    dprowlist_    VARCHAR2(4000);
    AUTO_         varchar2(100);
    Plan_Qty_     NUMBER;
    a311_         a311%rowtype;
  BEGIN
    If_Datechange := '0';
    Index_        := f_Get_Data_Index();
    Objid_        := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_     := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --����
    IF Doaction_ = 'I' THEN
      -- ��VALUE��= Pkg_a.Get_Item_Value('��COLUMN��', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_, '[TABLE_ID]', Objid_);
      Attr_OUT            := '';
      ROW_.ORDER_LINE_NO  := PKG_A.Get_Item_Value('ORDER_LINE_NO', ROWLIST_);
      ROW_.F_ORDER_NO     := PKG_A.Get_Str_(ROW_.ORDER_LINE_NO, '-', 1);
      ROW_.F_LINE_NO      := PKG_A.Get_Str_(ROW_.ORDER_LINE_NO, '-', 2);
      ROW_.F_REL_NO       := PKG_A.Get_Str_(ROW_.ORDER_LINE_NO, '-', 3);
      ROW_.F_LINE_ITEM_NO := PKG_A.Get_Str_(ROW_.ORDER_LINE_NO, '-', 4);
    
      ROW_.ENTER_USER := USER_ID_;
      ROW_.ENTER_DATE := SYSDATE;
    
      OPEN CUR_ FOR
        SELECT T.*
          FROM bl_v_customer_order_line T
         WHERE t.ORDER_NO = ROW_.F_ORDER_NO
           and t.LINE_NO = ROW_.F_LINE_NO
           and t.REL_NO = ROW_.F_REL_NO
           and t.LINE_ITEM_NO = ROW_.F_LINE_ITEM_NO;
      FETCH CUR_
        INTO headrow_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        Raise_Application_Error(-20101, '�����rowid');
        RETURN;
      END IF;
      CLOSE CUR_;
      maincorow_.OBJID := BL_CUSTOMER_ORDER_LINE_API.Get_Par_Order_(ROW_.F_ORDER_NO,
                                                                    ROW_.F_LINE_NO,
                                                                    ROW_.F_REL_NO,
                                                                    ROW_.F_LINE_ITEM_NO,
                                                                    'OBJID');
    
      OPEN CUR_ FOR
        SELECT T.*
          FROM bl_v_customer_order_line T
         WHERE t.OBJID = maincorow_.OBJID;
      FETCH CUR_
        INTO maincorow_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        Raise_Application_Error(-20101, '�����rowid');
        RETURN;
      END IF;
      CLOSE CUR_;
      row_.delived_date := to_date(PKG_A.Get_Item_Value('DELIVED_DATE',
                                                        ROWLIST_),
                                   'YYYY-MM-DD');
      row_.Qty_Delived  := PKG_A.Get_Item_Value('QTY_DELIVED', ROWLIST_);
    
      Get_Dp_Head(maincorow_.order_no,
                  headrow_.CONTRACT,
                  row_.delived_date,
                  user_id_,
                  dprow_);
    
      open cur_ for
        select t.*
          from BL_DELIVERY_PLAN_DETIAL_v t
         where t.delplan_no = dprow_.DELPLAN_NO
           and t.f_order_no = row_.f_order_no
           and t.f_line_no = row_.f_line_no
           and t.f_rel_no = row_.f_rel_no
           and t.f_line_item_no = row_.f_line_item_no;
      fetch cur_
        into row__;
      if cur_%found then
        Raise_Application_Error(-20101, '�����rowid');
        return;
      end if;
      close cur_;
      GET_DP_LINE(ROW_.ORDER_LINE_NO,
                  dprow_.DELPLAN_NO,
                  row_.Qty_Delived,
                  TO_CHAR(row_.delived_date, 'YYYY-MM-DD'),
                  USER_ID_);
    end if;
  
    --�޸�
    IF Doaction_ = 'M' THEN
    
      OPEN Cur_ FOR
        SELECT t.*
          FROM BL_V_CUST_ORDER_LINE_DETAIL t
         WHERE t.Objid = Objid_;
      FETCH Cur_
        INTO RowLINE_;
      IF Cur_%NOTFOUND THEN
        Raise_Application_Error(-20101, '�����rowid');
        RETURN;
      END IF;
      CLOSE Cur_;
      if pkg_a.Item_Exist('QTY_DELIVED', rowlist_) then
        --�仯�������
        ROW_.QTY_DELIVED := pkg_a.Get_Item_Value('QTY_DELIVED', rowlist_);
      else
        ROW_.QTY_DELIVED := ROWLINE_.QTY_DELIVED;
      end if;
    
      if pkg_a.Item_Exist('DELIVED_DATE', rowlist_) then
        --�仯�������
        ROW_.DELIVED_DATE := to_date(pkg_a.Get_Item_Value('DELIVED_DATE',
                                                          rowlist_),
                                     'YYYY-MM-DD');
      else
        ROW_.DELIVED_DATE := ROWLINE_.DELIVED_DATE;
      end if;
    
      if ROW_.DELIVED_DATE = ROWLINE_.DELIVED_DATE then
        --�޸�����
        Plan_Qty_ := bl_customer_order_line_api.Get_Plan_Qty__(RowLINE_.F_ORDER_NO,
                                                               RowLINE_.F_LINE_NO,
                                                               RowLINE_.F_REL_NO,
                                                               RowLINE_.F_LINE_ITEM_NO);
      
        IF Plan_Qty_ - ROWLINE_.QTY_DELIVED + ROW_.QTY_DELIVED >
           ROWLINE_.buy_qty_due THEN
          Raise_Application_Error(-20101, '��������');
          return;
        end if;
        if row_.qty_delived = 0 then
          Raise_Application_Error(-20101, '��������Ϊ0');
          return;
        end if;
        update BL_DELIVERY_PLAN_DETIAL t
           set t.Qty_Delived = ROW_.QTY_DELIVED
         where T.ROWID = OBJID_;
      else
        --ɾ�������ڵ�����  ���������Ϊ �Զ����ɵĽ������� ��������0  ������� delete
        select t.type_id
          INTO AUTO_
          from BL_DELIVERY_PLAN t
         INNER JOIN BL_DELIVERY_PLAN_DETIAL T1
            ON T1.DELPLAN_NO = T.DELPLAN_NO
         WHERE T1.ROWID = OBJID_;
        IF AUTO_ = 'AUTO' THEN
          UPDATE BL_DELIVERY_PLAN_DETIAL T
             SET T.QTY_DELIVED = 0
           WHERE T.ROWID = OBJID_;
        ELSE
          DELETE FROM BL_DELIVERY_PLAN_DETIAL T WHERE T.ROWID = OBJID_;
        END IF;
      
        --���������ڵ�����--
      
        Get_Dp_Head(RowLINE_.order_no,
                    RowLINE_.CONTRACT,
                    row_.delived_date,
                    user_id_,
                    dprow_);
      
        --������ϸ
        --insert_Dp_Head
        get_dp_line(RowLINE_.ORDER_LINE_NO,
                    dprow_.DELPLAN_NO,
                    row_.Qty_Delived,
                    TO_CHAR(row_.delived_date, 'YYYY-MM-DD'),
                    USER_ID_);
      
      end if;
      Pkg_a.Setsuccess(A311_Key_,
                       'BL_V_CUST_ORDER_LINE_PDELIVE',
                       RowLINE_.Objid);
    END IF;
  
    --ɾ��
    IF Doaction_ = 'D' THEN
      OPEN CUR_ FOR
        SELECT T.* FROM BL_DELIVERY_PLAN_DETIAL T WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        close cur_;
        Raise_Application_Error(-20101, '�����rowid');
      end if;
      close cur_;
      delete from BL_DELIVERY_PLAN_DETIAL t where T.ROWID = OBJID_;
    END IF;
  
    --����ۼ������Ƿ񳬹� �ƻ�����
  
    --bl_customer_order_line_api.Get_Plan_Qty__(
  
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
    PDROW_   Bl_Delivery_Plan_Detial%ROWTYPE;
    ROW_     BL_V_DELIVERY_PLAN_DETIAL_V02%ROWTYPE;
    Cur_     t_Cursor;
  BEGIN
    PDROW_.ORDER_LINE_NO := PKG_A.Get_Item_Value('ORDER_LINE_NO', ROWLIST_);
    IF Column_Id_ = 'DELPLAN_NO' THEN
      PDROW_.DELPLAN_NO := PKG_A.Get_Item_Value('DELPLAN_NO', ROWLIST_);
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_DELIVERY_PLAN_DETIAL_V02 T
         WHERE T.DELPLAN_NO = PDROW_.DELPLAN_NO
           AND T.LINE_KEY = PDROW_.ORDER_LINE_NO;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%NOTFOUND THEN
        PKG_A.Set_Item_Value('DELPLAN_NO', '', ATTR_OUT);
      END IF;
      CLOSE CUR_;
      PKG_a.Set_Item_Value('DELIVED_DATE', ROW_.DELIVED_DATE, ATTR_OUT);
    END IF;
    IF COLUMN_ID_ = 'DELIVED_DATE' THEN
      PDROW_.DELIVED_DATE := TO_DATE(PKG_A.Get_Item_Value('DELIVED_DATE',
                                                          ROWLIST_),
                                     'YYYY-MM-DD');
      --  TO_CHAR(PKG_A.Get_Item_Value('DELIVED_DATE',ROWLIST_),'YYYY-MM-DD');
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_DELIVERY_PLAN_DETIAL_V02 T
         WHERE T.DELIVED_DATE = TO_CHAR(PDROW_.DELIVED_DATE, 'YYYY-MM-DD')
           AND T.LINE_KEY = PDROW_.ORDER_LINE_NO;
      FETCH CUR_
        INTO ROW_;
      IF CUR_%FOUND THEN
        PKG_a.Set_Item_Value('DELPLAN_NO', ROW_.DELPLAN_NO, ATTR_OUT);
      ELSE
        PKG_A.Set_Item_Value('DELPLAN_NO', '', ATTR_OUT);
      END IF;
      CLOSE CUR_;
    
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
  procedure get_dp_line(ORDER_NO_     in varchar,
                        DELPLAN_NO_   in varchar,
                        QTY_DELIVED_  NUMBER,
                        DELIVED_DATE_ in varchar,
                        user_id_      in varchar2) is
    dprowlist_ varchar2(4000);
    A311_      A311%rowtype;
    Cur_       t_cursor;
    row_       Bl_v_Cust_Order_Line_Pdelive%rowtype;
  
  begin
    dprowlist_        := '';
    A311_.A311_Id     := 'BL_CUSTOMER_DELIVERY_LINE.Mofify__';
    A311_.Enter_User  := User_Id_;
    A311_.A014_Id     := 'A014_ID=SAVE';
    A311_.Table_Id    := 'BL_V_CUST_DELIVERY_PLAN';
    A311_.Table_Objid := '';
    Pkg_a.Beginlog(A311_);
  
    pkg_a.Set_Item_Value('OBJID', row_.OBJID, dprowlist_);
    pkg_a.Set_Item_Value('DOACTION', 'I', dprowlist_);
    pkg_a.Set_Item_Value('LINE_KEY', ORDER_NO_, dprowlist_);
    pkg_a.Set_Item_Value('QTY_DELIVED', QTY_DELIVED_, dprowlist_);
    pkg_a.Set_Item_Value('DELPLAN_NO', DELPLAN_NO_, dprowlist_);
    pkg_a.Set_Item_Value('VERSION', '1', dprowlist_);
    pkg_a.Set_Item_Value('DELIVED_DATE', DELIVED_DATE_, dprowlist_);
    pkg_a.Set_Item_Value('STATE', '0', dprowlist_);
  
    BLDELIVERY_PLAN_LINE_API.Modify__(dprowlist_, User_Id_, A311_.A311_Key);
  
  end;

  procedure Get_Dp_Head(ORDER_NO_     in varchar,
                        supplier_     in varchar,
                        delived_date_ date,
                        user_id_      in varchar2,
                        DpROW_        out bl_delivery_plan_v%rowtype) is
    dprowlist_ varchar2(4000);
    A311_      A311%rowtype;
    Cur_       t_cursor;
    BLROW_     BL_V_CUSTOMER_ORDER_V03%rowtype;
    DELPLAN_   Bl_Delivery_Plan%ROWTYPE;
  begin
    bldelivery_plan_api.Get_Record_By_Order_Date(ORDER_NO_,
                                                 supplier_,
                                                 delived_date_,
                                                 DpROW_);
    --����ͷ
    if nvl(DpROW_.DELPLAN_NO, '-') = '-' then
      dprowlist_        := '';
      A311_.A311_Id     := 'BL_CUSTOMER_DELIVERY_LINE.Mofify__';
      A311_.Enter_User  := User_Id_;
      A311_.A014_Id     := 'A014_ID=SAVE';
      A311_.Table_Id    := 'BL_V_CUST_DELIVERY_PLAN';
      A311_.Table_Objid := '';
      Pkg_a.Beginlog(A311_);
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_CUSTOMER_ORDER_V03 T
         WHERE T.ORDER_NO = ORDER_NO_
           AND T.supplier = supplier_;
      FETCH CUR_
        INTO BLROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RETURN;
      END IF;
      CLOSE CUR_;
      --������ǰ�ı�ͷ
      OPEN Cur_ FOR
        SELECT t.*
          FROM Bl_Delivery_Plan_v t
         WHERE t.Order_No = ORDER_NO_
           AND t.Supplier = supplier_
           AND t.Delived_Date = delived_date_
           AND T.STATE = '0';
      FETCH Cur_
        INTO DpROW_;
      IF Cur_%FOUND THEN
        close cur_;
        return;
      else
        --���       
        pkg_a.Set_Item_Value('DOACTION', 'I', dprowlist_);
        pkg_a.Set_Item_Value('OBJID', BLROW_.OBJID, dprowlist_);
        pkg_a.Set_Item_Value('CONTRACT', BLROW_.CONTRACT, dprowlist_);
        pkg_a.Set_Item_Value('SUPPLIER', BLROW_.SUPPLIER, dprowlist_);
        pkg_a.Set_Item_Value('ORDER_NO', BLROW_.ORDER_NO, dprowlist_);
        pkg_a.Set_Item_Value('COLUMN_NO', '1', dprowlist_);
        pkg_a.Set_Item_Value('DELIVED_DATE',
                             TO_CHAR(delived_date_, 'YYYY-MM-DD'),
                             dprowlist_);
        pkg_a.Set_Item_Value('CUSTOMER_NO', BLROW_.CUSTOMER_NO, dprowlist_);
        pkg_a.Set_Item_Value('LABEL_NOTE', BLROW_.LABEL_NOTE, dprowlist_);
        bldelivery_plan_api.Modify__(dprowlist_, user_id_, A311_.A311_Key);
      end if;
      close cur_;
      OPEN Cur_ FOR
        SELECT t.* FROM A311 t WHERE t.A311_Key = A311_.A311_Key;
      FETCH Cur_
        INTO A311_;
      IF Cur_%NOTFOUND THEN
        CLOSE Cur_;
        Raise_Application_Error(-20101, 'Modify����ʧ��');
        RETURN;
      END IF;
      CLOSE Cur_;
      OPEN Cur_ FOR
        SELECT t.*
          FROM bl_delivery_plan_v t
         WHERE t.Objid = A311_.Table_Objid;
      FETCH Cur_
        INTO DpROW_;
      IF Cur_%NOTFOUND THEN
        CLOSE Cur_;
        Raise_Application_Error(-20101, 'Modify����ʧ��');
        RETURN;
      END IF;
    end if;
  end;
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
    IF Column_Id_ = '��COLUMN��' THEN
      RETURN '0';
    END IF;
    RETURN '1';
  END;

END BL_CUSTOMER_DELIVERY_LINE;
/
