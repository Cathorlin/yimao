CREATE OR REPLACE PACKAGE Blbill_Vary_Line0_Api IS


  PROCEDURE Itemchange__(Column_Id_   VARCHAR2,
                         Mainrowlist_ VARCHAR2,
                         Rowlist_     VARCHAR2,
                         User_Id_     VARCHAR2,
                         Outrowlist_  OUT VARCHAR2);
  FUNCTION Checkuseable(Doaction_  IN VARCHAR2,
                        Column_Id_ IN VARCHAR,
                        Rowlist_   IN VARCHAR2) RETURN VARCHAR2;
  ----检查添加行 删除行 
  FUNCTION Checkbutton__(Dotype_   IN VARCHAR2,
                         Order_No_ IN VARCHAR2,
                         User_Id_  IN VARCHAR2) RETURN VARCHAR2;
END Blbill_Vary_Line0_Api;
/
CREATE OR REPLACE PACKAGE BODY BLBILL_VARY_LINE0_API IS
  TYPE t_Cursor IS REF CURSOR;
  PROCEDURE Itemchange__(Column_Id_   VARCHAR2,
                         Mainrowlist_ VARCHAR2,
                         Rowlist_     VARCHAR2,
                         User_Id_     VARCHAR2,
                         Outrowlist_  OUT VARCHAR2) IS
    ATTR_OUT   VARCHAR2(4000);
    CUR_       T_CURSOR;
    ROWLINE_   BL_V_CUSTOMER_ORDER_CHGP_DEP%ROWTYPE;
    DROW_      BL_V_ORDER_CHGP_DELPLAN%ROWTYPE;
    ROW__      BL_BILL_VARY_DETAIL%ROWTYPE;
    ROWREASON_ BL_V_REASON%ROWTYPE;
  BEGIN
    IF column_id_ = 'DELPLAN_NO' THEN
      ROWLINE_.Delplan_No := PKG_A.Get_Item_Value('DELPLAN_NO', ROWLIST_);
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_ORDER_CHGP_DELPLAN T
         WHERE T.DELPLAN_NO = ROWLINE_.Delplan_No;
      FETCH CUR_
        INTO DROW_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RETURN;
      END IF;
      CLOSE CUR_;
      PKG_A.Set_Item_Value('DELIVED_DATE', DROW_.DELIVED_DATE, ATTR_OUT);
    END IF;
    IF COLUMN_ID_ = 'REASON' THEN
      ROWLINE_.REASON := PKG_A.Get_Item_Value('REASON', ROWLIST_);
      OPEN CUR_ FOR
        SELECT T.* FROM BL_V_REASON T WHERE T.REASON_NO = ROWLINE_.REASON;
      FETCH CUR_
        INTO ROWREASON_;
      IF CUR_%NOTFOUND THEN
        CLOSE CUR_;
        RETURN;
      END IF;
      CLOSE CUR_;
      PKG_A.Set_Item_Value('REASON_DESCRIPTION',
                           ROWREASON_.REASON_DES,
                           ATTR_OUT);
    END IF;
    Outrowlist_ := ATTR_OUT;
    RETURN;
  END;
  FUNCTION Checkuseable(Doaction_  IN VARCHAR2,
                        Column_Id_ IN VARCHAR,
                        Rowlist_   IN VARCHAR2) RETURN VARCHAR2 IS
    Row_   Bl_Bill_Vary_Detail%ROWTYPE;
    Rowc_  Bl_v_Customer_Order_Chgp_Det0%ROWTYPE;
    Objid_ VARCHAR(100);
  BEGIN
    Row_.State       := Pkg_a.Get_Item_Value('STATE', Rowlist_);
    Objid_           := Pkg_a.Get_Item_Value('OBJID', Rowlist_);
    Row_.Modify_Type := Pkg_a.Get_Item_Value('MODIFY_TYPE', Rowlist_);
    Rowc_.Type_Id    := Pkg_a.Get_Item_Value('TYPE_ID', Rowlist_);
  
    IF Nvl(Objid_, 'NULL') = 'NULL' THEN
      RETURN '1';
    END IF;
  
    IF Column_Id_ = 'REMARK'
       OR Column_Id_ = 'REASON' THEN
      RETURN '1';
    ELSE
      RETURN '0';
    END IF;
    RETURN '0';
  END;
  ----检查添加行 删除行 
  FUNCTION Checkbutton__(Dotype_   IN VARCHAR2,
                         Order_No_ IN VARCHAR2,
                         User_Id_  IN VARCHAR2) RETURN VARCHAR2 IS
    Cur_     t_Cursor;
    Mainrow_ Bl_Bill_Vary%ROWTYPE;
  BEGIN
  
  
    RETURN '1';
  END;
END BLBILL_VARY_LINE0_API;
/
