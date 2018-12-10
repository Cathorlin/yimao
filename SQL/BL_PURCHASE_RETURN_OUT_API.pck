create or replace package BL_PURCHASE_RETURN_OUT_API is

  PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE CANCEL__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE MODIFY__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE APPROVE__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE DENY__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
  PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_  VARCHAR2 ,ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,OUTROWLIST_ OUT VARCHAR2);
   
end BL_PURCHASE_RETURN_OUT_API;
/
create or replace package body BL_PURCHASE_RETURN_OUT_API is
 TYPE t_cursor IS REF CURSOR;
   /*  ������ʼ�� New__
  Rowlist_ ��ʼ���Ĳ��� ���Դ���requseturl ��ǰ�����url��ַ
  User_Id_  ��ǰ�û�
  A311_Key_ A314������ */
 PROCEDURE NEW__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
  
 BEGIN 
    
    RETURN;
 END;
 
 PROCEDURE CANCEL__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
  
 BEGIN 
    
   RETURN;
 END;
  /*  �������� Modify__
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
  */
PROCEDURE Modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 
 BEGIN 
    return ;
 END;
   /*  ȷ�ϳ��� APPROVE__
      Rowlist_  ������������ 
      User_Id_  ��ǰ�û�
      A311_Key_ A314������     
  */
 PROCEDURE APPROVE__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
        
        cur_  t_cursor;
        row_ BL_V_PURCHASE_RETURN_OUT%rowtype; --�˻���������ʵ�ʾ����˻�������ϸ
        rowDetail_ BL_V_PURCHASE_RETURN_OUT_DTL%ROWTYPE; 
        inspectNum_ NUMBER;
        transId_ NUMBER;
           
     begin
          row_.OBJID := ROWLIST_;
          inspectNum_:=0;
          
          open cur_
          for select t.* FROM BL_V_PURCHASE_RETURN_OUT t  where  t.OBJID =   row_.OBJID;      
          fetch cur_   into row_   ;        
          if cur_%notfound then
             close cur_ ;
             pkg_a.setFailed(A311_KEY_,'BL_V_PURCHASE_RETURN_OUT',row_.OBJID);
             raise_application_error(-20101, '�����rowid');
             return ;
          end if ;
          close cur_ ;
          
          if row_.STATE >3 then
             raise_application_error(-20101,'�˻�����'|| row_.INSPECT_NO ||'�ѳ��⣬�����ظ�����');
             return;
          end if;
          
          open cur_
          for   select *  from BL_V_PURCHASE_RETURN_OUT_DTL  t WHERE T.Inspect_No = ROW_.Inspect_No ; 
             
          fetch cur_ into rowDetail_  ;     
            if cur_%found then
                LOOP
                  EXIT WHEN  cur_%notfound; 
                  inspectNum_:=inspectNum_+ rowDetail_.QTY_IN_STORE; 
                  Fetch cur_ INTO rowDetail_  ;
                END LOOP;
            end if ;
          close cur_ ;
          
          IF inspectNum_ = row_.QTY_TO_INSPECT THEN
            
              open cur_
              for   select *  from BL_V_PURCHASE_RETURN_OUT_DTL  t WHERE T.Inspect_No = ROW_.Inspect_No; 
                 
              fetch cur_ into rowDetail_  ;     
                if cur_%found then
                    LOOP
                      EXIT WHEN  cur_%notfound; 
                      --����IFS�۳����
                      Inventory_Part_In_Stock_API.Issue_Part_With_Posting( 
                                    rowDetail_.CONTRACT,
                                    rowDetail_.PART_NO,
                                    rowDetail_.configuration_id ,
                                    rowDetail_.location_no   ,
                                    rowDetail_.lot_batch_no,
                                    rowDetail_.serial_no,
                                    rowDetail_.eng_chg_level   ,
                                    rowDetail_.waiv_dev_rej_no,
                                    'NISS'  ,
                                    rowDetail_.QTY_IN_STORE   ,
                                    rowDetail_.QTY_RESERVED,
                                    '','','','','','','','','','',''
                           ); 
                           
                         
                          SELECT MAX(TRANSACTION_ID)
                                 INTO transId_
                          FROM INVENTORY_TRANSACTION_HIST2
                           WHERE order_no = rowDetail_.order_no
                             AND RELEASE_NO = rowDetail_.RELEASE_NO
                             --AND SEQUENCE_NO = rowDetail_.SERIAL_NO
                             --AND line_item_no = rowDetail_.LINE_NO
                             AND location_no = rowDetail_.LOCATION_NO
                             AND lot_batch_no = rowDetail_.LOT_BATCH_NO
                             AND serial_no = rowDetail_.SERIAL_NO
                             AND waiv_dev_rej_no =rowDetail_.WAIV_DEV_REJ_NO
                             AND eng_chg_level =rowDetail_.ENG_CHG_LEVEL
                             AND configuration_id = rowDetail_.CONFIGURATION_ID;
                          
                          UPDATE BL_PURRENTURN_DTL_TAB SET TRANSACTION_ID =transId_  WHERE ROWID = rowDetail_.PURRENTURN_DTL_ID;
                         
                           
                      Fetch cur_ INTO rowDetail_  ;
                    END LOOP;
                end if ;
              close cur_ ;
                       
          ELSE
             raise_application_error(-20101,'�˻�����['||inspectNum_||']���˻���������['||row_.QTY_TO_INSPECT||']��ƥ��');
             return;        
          END IF;
          
          --�����˻�������ϸ��״̬���ر�
          Update BL_PURCHASE_ORDER_RETRUN_DTL set state='5'  where  Rowid= row_.OBJID;
          
          
          BL_RETURN_MATERIAL1_API.Return_PurchaseStock_(row_.Inspect_No,row_.Inspect_No_Line);
         
          --�����˻�����������״̬���رգ���Ҫ�ж���ϸ�Ƿ��Ѿ��ر�
          open cur_
          for select t.* FROM BL_V_PURCHASE_RETURN_OUT t  where inspect_no=row_.INSPECT_NO AND STATE <'5';        
          fetch cur_   into row_   ;     
          if cur_%notfound then
             Update BL_PURCHASE_ORDER_RETRUN set state='5'  WHERE inspect_no=row_.INSPECT_NO;
          end if ;
          close cur_ ;
          
          pkg_a.setMsg(A311_KEY_,'','�˻�����'|| row_.INSPECT_NO ||'ȷ�ϳɹ�');
          pkg_a.setSuccess(A311_KEY_,'BL_PURCHASE_RETURN_OUT_API.APPROVE_',row_.OBJID);
          RETURN;
    END;
    
 PROCEDURE DENY__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
 IS 
 BEGIN 
   RETURN;
 END;
  /*  �з����仯��ʱ��
      Column_Id_   ��ǰ�޸ĵ���
      Mainrowlist_ ���������� ��ϸ��ֵ������Ϊ��
      Rowlist_  ���浱ǰ�е����� 
      User_Id_  ��ǰ�û�
      Outrowlist_  ���������   
  */
PROCEDURE ITEMCHANGE__(column_id_ varchar2 ,MAINROWLIST_  VARCHAR2 , ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,OUTROWLIST_ OUT VARCHAR2)
 IS 

 BEGIN 
  RETURN;
 end  ;
  
end BL_PURCHASE_RETURN_OUT_API;
/
