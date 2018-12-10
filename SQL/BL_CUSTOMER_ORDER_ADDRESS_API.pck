create or replace package BL_CUSTOMER_ORDER_ADDRESS_API is

PROCEDURE Modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2);
PROCEDURE ITEMCHANGE__(COLUMN_ID_ VARCHAR2 , MAINROWLIST_  VARCHAR2 , --main 
    ROWLIST_  VARCHAR2, --行rowlist 
    USER_ID_ VARCHAR2, 
    OUTROWLIST_  OUT  VARCHAR2 --输出
    ) ; 
--判断当前列是否可编辑--
 function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 ) return varchar2 ;

end BL_CUSTOMER_ORDER_ADDRESS_API;
/
create or replace package body BL_CUSTOMER_ORDER_ADDRESS_API is
  TYPE T_CURSOR IS REF  CURSOR ;
PROCEDURE Modify__(ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
IS
   info_        VARCHAR2(4000);
   objid_       VARCHAR2(4000);
   objversion_  VARCHAR2(4000);
   attr_        VARCHAR2(4000);
   action_      VARCHAR2(4000);
   index_       varchar2(1);
   index__      varchar2(1);
   attr__       VARCHAR2(4000);
   cur_         t_cursor;
   pos_         number ;
   pos1_        number ;
   i            number ;
   len_column   number ;
   pos2_        number ;
   pos2__       number ;
   v__          varchar(1000);
   v_           varchar(1000);
   v1_          varchar(1000);
   data_        varchar(4000);
   doaction_    varchar(10);
   column_id_   varchar(4000);
   ADDR_FLAG_   VARCHAR(10);
   row_  BL_V_CUSTOMER_ORDER_ADDRESS%rowtype;
BEGIN 

      action_ :='DO';
      index_ := f_get_data_index();
      row_.OBJID   := pkg_a.Get_Item_Value('OBJID', index_|| ROWLIST_);
      ROW_.ORDER_NO := pkg_a.Get_Item_Value('ORDER_NO',ROWLIST_);
      doaction_    := pkg_a.Get_Item_Value('DOACTION',ROWLIST_);
      ROW_.OBJID_OLD := pkg_a.Get_Item_Value('OBJID_OLD',ROWLIST_);
      select chr(30) into index__ from dual; 
       IF  doaction_='M' then   
           open cur_  for select t.*
           from    BL_V_CUSTOMER_ORDER_ADDRESS t
           where  t.ORDER_NO =   row_.OBJID;         
           fetch cur_     into row_   ;
           if cur_%notfound then 
              close cur_ ;          
              raise_application_error(-20101, '错误的rowid');
              return ;
           end if ; 
           ADDR_FLAG_ := pkg_a.Get_Item_Value('ADDR_FLAG',ROWLIST_);          
           IF ADDR_FLAG_ = '' OR ADDR_FLAG_ IS NULL THEN
              ADDR_FLAG_ :=ROW_.ADDR_FLAG;
           END IF ;
           attr_ :='';
           IF ADDR_FLAG_ ='Yes' then                              
              
              data_ := ROWLIST_;
              pos_ := instr(data_,index_);
              i := i + 1 ;
      
            loop 
              exit when nvl(pos_,0) <=0 ;
              exit when i > 300 ;      
              v_ := substr(data_,1,pos_ - 1 ); --修改的值
              data_ := substr(data_,pos_ +  1 ) ;
              pos_ := instr(data_,index_);  
              
              pos1_ :=  instr(v_,'|');     
              column_id_ := substr(v_,1 ,pos1_ - 1 );    
              if column_id_ <>'OBJID' and  column_id_ <>  'DOACTION' AND column_id_ <> 'ADDR_FLAG' and length(nvl(column_id_,'')) > 0   then
                 v_ := substr(v_, pos1_ +  1 ) ;

                 Client_Sys.Add_To_Attr(Column_Id_, v_, Attr_);
                 i := i + 1;
              end if ;    
             end  loop ; 
 --             client_sys.Add_To_Attr('ADDRESS1',ROW_.ADDRESS1,attr_ );
 --             client_sys.Add_To_Attr('ADDRESS2',ROW_.ADDRESS2,attr_ );
 --             client_sys.Add_To_Attr('ZIP_CODE',ROW_.ZIP_CODE,attr_ );
 --             client_sys.Add_To_Attr('CITY',ROW_.CITY,attr_ );
 --             client_sys.Add_To_Attr('COUNTY',ROW_.COUNTY,attr_ );
 --             client_sys.Add_To_Attr('STATE',ROW_.STATE,attr_ );
 --             client_sys.Add_To_Attr('COUNTRY_CODE',ROW_.COUNTRY_CODE,attr_ );
              client_sys.Add_To_Attr('IN_CITY',ROW_.IN_CITY,attr_ );
              client_sys.Add_To_Attr('ADDR_1',ROW_.ADDR_1,attr_ );
              client_sys.Add_To_Attr('ORDER_NO',ROW_.ORDER_NO,attr_ );
              client_sys.Add_To_Attr('ADDR_FLAG_DB','Y',attr_ ); 
              client_sys.Add_To_Attr('SHIP_ADDR_NO',ROW_.SHIP_ADDR_NO,attr_ );
              client_sys.Add_To_Attr('BILL_ADDR_NO',ROW_.BILL_ADDR_NO,attr_ ); 
            else
             client_sys.Add_To_Attr('ADDR_FLAG_DB','N',attr_ );
             client_sys.Add_To_Attr('ORDER_NO',ROW_.ORDER_NO,attr_ );
             client_sys.Add_To_Attr('SHIP_ADDR_NO',ROW_.SHIP_ADDR_NO,attr_ );            
             client_sys.Add_To_Attr('BILL_ADDR_NO',ROW_.BILL_ADDR_NO,attr_ );
          end if; 
        close cur_ ;       
           CUSTOMER_ORDER_ADDRESS_API.MODIFY__(info_,ROW_.OBJID_OLD,row_.OBJVERSION,attr_,action_);
           pkg_a.setSuccess(A311_KEY_,'BL_V_CUSTOMER_ORDER_ADDRESS',ROW_.OBJID_OLD);
        end if;  
        
  RETURN ;
END ;
PROCEDURE ITEMCHANGE__(COLUMN_ID_ VARCHAR2 , 
    MAINROWLIST_  VARCHAR2 , --main 
    ROWLIST_  VARCHAR2, --行rowlist 
    USER_ID_ VARCHAR2, 
    OUTROWLIST_  OUT  VARCHAR2 --输出
    )
is
   row_  BL_V_CUSTOMER_ORDER_ADDRESS%rowtype;
  attr_out varchar2(4000); 
begin
  if COLUMN_ID_ = 'ADDR_FLAG' then 
    row_.addr_flag := pkg_a.Get_Item_Value('ADDR_FLAG',ROWLIST_);
    if row_.addr_flag = 'Yes' then
       pkg_a.Set_Column_Enable('ADDRESS1','1',attr_out);
       pkg_a.Set_Column_Enable('ADDRESS2','1',attr_out);
       pkg_a.Set_Column_Enable('ZIP_CODE','1',attr_out);
       pkg_a.Set_Column_Enable('CITY','1',attr_out);
       pkg_a.Set_Column_Enable('STATE','1',attr_out);
       pkg_a.Set_Column_Enable('COUNTY','1',attr_out);
       pkg_a.Set_Column_Enable('ADDRESS1','1',attr_out);         
    else
       pkg_a.Set_Column_Enable('ADDRESS1','0',attr_out);
       pkg_a.Set_Column_Enable('ADDRESS2','0',attr_out);
       pkg_a.Set_Column_Enable('ZIP_CODE','0',attr_out);
       pkg_a.Set_Column_Enable('CITY','0',attr_out);
       pkg_a.Set_Column_Enable('STATE','0',attr_out);
       pkg_a.Set_Column_Enable('COUNTY','0',attr_out);
       pkg_a.Set_Column_Enable('ADDRESS1','0',attr_out);   
    end if ;    
  end if ;
    OUTROWLIST_ := attr_out;
 return;
end ; 
--判断当前列是否可编辑--
 function checkUseable(doaction_ in varchar2 , column_id_ in varchar ,ROWLIST_ in varchar2 ) return varchar2 
  is
      row_  BL_V_CUSTOMER_ORDER_ADDRESS%rowtype;
  begin

    if doaction_ = 'M' then
         row_.ADDR_FLAG := pkg_a.Get_Item_Value('ADDR_FLAG',rowlist_);
         if row_.addr_flag <>  'Yes' then
            if       column_id_ = 'ADDRESS1' 
               or    column_id_ = 'ADDRESS2' 
               or    column_id_ = 'ZIP_CODE'
               or     column_id_ = 'CITY'
              or     column_id_ = 'STATE'
              or     column_id_ = 'COUNTY'
              then                
                return '0';
            end if ;
            
         end if ;
     
   end  if;
   return '1';
end ;
end BL_CUSTOMER_ORDER_ADDRESS_API;
/
