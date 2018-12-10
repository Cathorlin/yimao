CREATE OR REPLACE PACKAGE BL_CUSTOMER_INFO_ADDRESS__API IS
  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2);

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE Modify__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2);
  /*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
  PROCEDURE Itemchange__(Column_Id_   VARCHAR2,
                         Mainrowlist_ VARCHAR2,
                         Rowlist_     VARCHAR2,
                         User_Id_     VARCHAR2,
                         Outrowlist_  OUT VARCHAR2);
  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  FUNCTION Checkbutton__(Dotype_  IN VARCHAR2,
                         KEY_     IN VARCHAR2,
                         User_Id_ IN VARCHAR2) RETURN VARCHAR2;

  /*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
  */
  FUNCTION Checkuseable(Doaction_  IN VARCHAR2,
                        Column_Id_ IN VARCHAR,
                        Rowlist_   IN VARCHAR2) RETURN VARCHAR2;

END BL_CUSTOMER_INFO_ADDRESS__API;
/
CREATE OR REPLACE PACKAGE BODY BL_CUSTOMER_INFO_ADDRESS__API IS
  TYPE t_Cursor IS REF CURSOR;

  ---------------客户  ---------------
  ---------------create by ld-------------
  --【COLUMN】  列名称 按实际的逻辑 用实际的列名
  -- 【VALUE】  列的数据 按具体的实际逻辑 用对应的参数来替代
  /*
  报错
  Raise_Application_Error(pkg_a.raise_error,'出错了 ！！！！！');
  */

  /*  新增初始化 New__
  Rowlist_ 初始化的参数 可以传入requseturl 当前请求的url地址
  User_Id_  当前用户
  A311_Key_ A314的主键 */
  PROCEDURE New__(Rowlist_ VARCHAR2, User_Id_ VARCHAR2, A311_Key_ VARCHAR2) IS
    attr_out    VARCHAR2(4000);
    OBJID_      VARCHAR2(4000);
    info_       VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    attr_       VARCHAR2(4000);
    action_     VARCHAR2(4000);
    attr__      VARCHAR2(4000);
    ROW_        BL_V_CUSTOMER_INFO_ADDRESS%rowtype;
  BEGIN
    attr_out         := '';
    Action_          := 'PREPARE';
    ROW_.CUSTOMER_ID := PKG_A.Get_Item_Value('CUSTOMER_ID', ROWLIST_);
    CLIENT_SYS.Add_To_Attr('CUSTOMER_ID', ROW_.CUSTOMER_ID, attr_);
    IFSAPP.CUSTOMER_INFO_ADDRESS_API.NEW__(info_,
                                           objid_,
                                           objversion_,
                                           attr_,
                                           action_);
    attr_out := PKG_A.Get_Attr_By_Ifs(attr_);
    -- pkg_a.Set_Item_Value('【COLUMN】','【VALUE】', attr_out);
    pkg_a.Setresult(A311_Key_, attr_out);
  END;

  /*  保存数据 Modify__
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      A311_Key_ A314的主键     
  */
  PROCEDURE Modify__(Rowlist_  VARCHAR2,
                     User_Id_  VARCHAR2,
                     A311_Key_ VARCHAR2) IS
    Objid_      VARCHAR2(4000);
    info_       VARCHAR2(4000);
    objversion_ VARCHAR2(4000);
    attr_       VARCHAR2(4000);
    attr__      VARCHAR2(4000);
    action_     VARCHAR2(4000);
    Index_      VARCHAR2(1);
    Cur_        t_Cursor;
    Doaction_   VARCHAR2(10);
    Pos_        Number;
    Pos1_       Number;
    i           Number;
    v_          Varchar(1000);
    Column_Id_  Varchar(1000);
    Data_       Varchar(4000);
    Mysql_      Varchar(4000);
    Ifmychange  Varchar(1);
    row_        BL_V_CUSTOMER_INFO_ADDRESS%rowtype;
  BEGIN
    Index_    := f_Get_Data_Index();
    Objid_    := Pkg_a.Get_Item_Value('OBJID', Index_ || Rowlist_);
    Doaction_ := Pkg_a.Get_Item_Value('DOACTION', Rowlist_);
    --新增
    IF Doaction_ = 'I' THEN
    
      CLIENT_SYS.Add_To_Attr('ADDRESS_ID',
                             PKG_A.Get_Item_Value('ADDRESS_ID', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('COUNTRY',
                             PKG_A.Get_Item_Value('COUNTRY', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('IN_CITY',
                             PKG_A.Get_Item_Value('IN_CITY', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('ADDRESS1',
                             PKG_A.Get_Item_Value('ADDRESS1', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('ADDRESS2',
                             PKG_A.Get_Item_Value('ADDRESS2', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('ZIP_CODE',
                             PKG_A.Get_Item_Value('ZIP_CODE', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('COUNTY',
                             PKG_A.Get_Item_Value('COUNTY', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('STATE',
                             PKG_A.Get_Item_Value('STATE', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('CUSTOMER_ID',
                             PKG_A.Get_Item_Value('CUSTOMER_ID', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('CITY',
                             PKG_A.Get_Item_Value('CITY', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('DEFAULT_DOMAIN',
                             PKG_A.Get_Item_Value('DEFAULT_DOMAIN',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('PARTY_TYPE',
                             PKG_A.Get_Item_Value('PARTY_TYPE', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('ADDRESS',
                             PKG_A.Get_Item_Value('ADDRESS', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('EAN_LOCATION',
                             PKG_A.Get_Item_Value('EAN_LOCATION', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('VALID_FROM',
                             PKG_A.Get_Item_Value('VALID_FROM', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('VALID_TO',
                             PKG_A.Get_Item_Value('VALID_TO', ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('SECONDARY_CONTACT',
                             PKG_A.Get_Item_Value('SECONDARY_CONTACT',
                                                  ROWLIST_),
                             attr_);
      CLIENT_SYS.Add_To_Attr('PRIMARY_CONTACT',
                             PKG_A.Get_Item_Value('PRIMARY_CONTACT',
                                                  ROWLIST_),
                             attr_);
      Action_ := 'CHECK';
      attr__  := attr_;
      IFSAPP.CUSTOMER_INFO_ADDRESS_API.NEW__(info_,
                                             objid_,
                                             objversion_,
                                             attr_,
                                             action_);
      Action_ := 'DO';
      IFSAPP.CUSTOMER_INFO_ADDRESS_API.NEW__(info_,
                                             objid_,
                                             objversion_,
                                             attr__,
                                             action_);
      pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_INFO_ADDRESS', Objid_);
      --  ADDRESS_ID 01 COUNTRY 中国 IN_CITY FALSE ADDRESS1 12344 ADDRESS2 12344 ZIP_CODE 11111 
      --  COUNTY 11 STATE 111111 CUSTOMER_ID 161619619 CITY 111 DEFAULT_DOMAIN TRUE PARTY_TYPE 客户
      -- 【VALUE】= Pkg_a.Get_Item_Value('【COLUMN】', Rowlist_);
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      /*
      --标识号
      row_.CUSTOMER_ID  := Pkg_a.Get_Item_Value('CUSTOMER_ID', Rowlist_)
      --地址标识号
      row_.ADDRESS_ID  := Pkg_a.Get_Item_Value('ADDRESS_ID', Rowlist_)
      --地址
      row_.ADDRESS  := Pkg_a.Get_Item_Value('ADDRESS', Rowlist_)
      --EAN位置
      row_.EAN_LOCATION  := Pkg_a.Get_Item_Value('EAN_LOCATION', Rowlist_)
      --有效自
      row_.VALID_FROM  := Pkg_a.Get_Item_Value('VALID_FROM', Rowlist_)
      --有效至
      row_.VALID_TO  := Pkg_a.Get_Item_Value('VALID_TO', Rowlist_)
      --PARTY
      row_.PARTY  := Pkg_a.Get_Item_Value('PARTY', Rowlist_)
      --DEFAULT_DOMAIN
      row_.DEFAULT_DOMAIN  := Pkg_a.Get_Item_Value('DEFAULT_DOMAIN', Rowlist_)
      --国家
      row_.COUNTRY  := Pkg_a.Get_Item_Value('COUNTRY', Rowlist_)
      --国家编号
      row_.COUNTRY_DB  := Pkg_a.Get_Item_Value('COUNTRY_DB', Rowlist_)
      --PARTY_TYPE
      row_.PARTY_TYPE  := Pkg_a.Get_Item_Value('PARTY_TYPE', Rowlist_)
      --PARTY_TYPE_DB
      row_.PARTY_TYPE_DB  := Pkg_a.Get_Item_Value('PARTY_TYPE_DB', Rowlist_)
      --第二联系
      row_.SECONDARY_CONTACT  := Pkg_a.Get_Item_Value('SECONDARY_CONTACT', Rowlist_)
      --基本联系方式
      row_.PRIMARY_CONTACT  := Pkg_a.Get_Item_Value('PRIMARY_CONTACT', Rowlist_)
      --地址1
      row_.ADDRESS1  := Pkg_a.Get_Item_Value('ADDRESS1', Rowlist_)
      --地址2
      row_.ADDRESS2  := Pkg_a.Get_Item_Value('ADDRESS2', Rowlist_)
      --邮政编码
      row_.ZIP_CODE  := Pkg_a.Get_Item_Value('ZIP_CODE', Rowlist_)
      --城市
      row_.CITY  := Pkg_a.Get_Item_Value('CITY', Rowlist_)
      --地区
      row_.COUNTY  := Pkg_a.Get_Item_Value('COUNTY', Rowlist_)
      --省
      row_.STATE  := Pkg_a.Get_Item_Value('STATE', Rowlist_)
      --在市区内
      row_.IN_CITY  := Pkg_a.Get_Item_Value('IN_CITY', Rowlist_)
      --权限代码
      row_.JURISDICTION_CODE  := Pkg_a.Get_Item_Value('JURISDICTION_CODE', Rowlist_)*/
    
    END IF;
    --修改
    IF Doaction_ = 'M' THEN
      --pkg_a.Setsuccess(A311_Key_,'[TABLE_ID]', Objid_);
      Open Cur_ For
        Select t.*
          From BL_V_CUSTOMER_INFO_ADDRESS t
         Where t.Objid = Objid_;
      Fetch Cur_
        Into Row_;
      If Cur_%Notfound Then
        CLOSE CUR_;
        Raise_Application_Error(Pkg_a.Raise_Error,
                                PKG_MSG.Getmsgbymsgid('ES0002',
                                                      '',
                                                      '',
                                                      PKG_ATTR.Userlanguage(USER_ID_)));
        RETURN;
      End If;
      Close Cur_;
      Data_ := Rowlist_;
      Pos_  := Instr(Data_, Index_);
      i     := i + 1;
      /*            Mysql_     :='update BL_V_CUSTOMER_INFO_ADDRESS SET ';
      Ifmychange :='0';*/
      Loop
        Exit When Nvl(Pos_, 0) <= 0;
        Exit When i > 300;
        v_    := Substr(Data_, 1, Pos_ - 1);
        Data_ := Substr(Data_, Pos_ + 1);
        Pos_  := Instr(Data_, Index_);
      
        Pos1_      := Instr(v_, '|');
        Column_Id_ := Substr(v_, 1, Pos1_ - 1);
      
        If Column_Id_ <> 'OBJID' And Column_Id_ <> 'DOACTION' And
           Length(Nvl(Column_Id_, '')) > 0 Then
          Ifmychange := '1';
          v_         := Substr(v_, Pos1_ + 1);
          /* Mysql_     := Mysql_ || Column_Id_ || ='''|| v_ ||'',';*/
          CLIENT_SYS.Add_To_Attr(Column_Id_, V_, attr_);
        End If;
      
      End Loop;
      attr__  := attr_;
      Action_ := 'CHECK';
      IFSAPP.CUSTOMER_INFO_ADDRESS_API.MODIFY__(info_,
                                                ROW_.OBJID,
                                                ROW_.OBJVERSION,
                                                attr_,
                                                action_);
      Action_ := 'DO';
      IFSAPP.CUSTOMER_INFO_ADDRESS_API.MODIFY__(info_,
                                                ROW_.OBJID,
                                                ROW_.OBJVERSION,
                                                attr__,
                                                action_);
    
      Pkg_a.Setsuccess(A311_Key_, 'BL_V_CUSTOMER_INFO_ADDRESS', Row_.Objid);
    
    End If;
    --删除
    If Doaction_ = 'D' Then
      OPEN CUR_ FOR
        SELECT T.*
          FROM BL_V_CUSTOMER_INFO_ADDRESS T
         WHERE T.ROWID = OBJID_;
      FETCH CUR_
        INTO ROW_;
      IF CUR_ %NOTFOUND THEN
        CLOSE CUR_;
        RAISE_APPLICATION_ERROR(Pkg_a.Raise_Error, '错误的rowid');
        return;
      end if;
      close cur_;
      --      DELETE FROM BL_V_CUSTOMER_INFO_ADDRESS T WHERE T.ROWID = OBJID_; 
      --pkg_a.Setsuccess(A311_Key_,'BL_V_CUSTOMER_INFO_ADDRESS', Objid_);
      Return;
    End If;
  
  End;
  /*  列发生变化的时候
      Column_Id_   当前修改的列
      Mainrowlist_ 主档的数据 明细有值，主档为空
      Rowlist_  保存当前行的数据 
      User_Id_  当前用户
      Outrowlist_  输出的数据   
  */
  Procedure Itemchange__(Column_Id_   Varchar2,
                         Mainrowlist_ Varchar2,
                         Rowlist_     Varchar2,
                         User_Id_     Varchar2,
                         Outrowlist_  Out Varchar2) Is
    Attr_Out Varchar2(4000);
  Begin
    If Column_Id_ = '' Then
      --给列赋值
      Pkg_a.Set_Item_Value('【COLUMN】', '【value】', Attr_Out);
      --设置列不可用
      Pkg_a.Set_Column_Enable('【column】', '0', Attr_Out);
      --设置列可用
      Pkg_a.Set_Column_Enable('【column】', '1', Attr_Out);
    End If;
    Outrowlist_ := Attr_Out;
  End;
  /*  列发生变化的时候
      Dotype_   ADD_ROW  DEL_ROW 主要控制 明细的添加行 和 删除行 按钮 
      KEY_ 主档的主键值
      User_Id_  当前用户
  */
  Function Checkbutton__(Dotype_  In Varchar2,
                         Key_     In Varchar2,
                         User_Id_ In Varchar2) Return Varchar2 Is
  Begin
    If Dotype_ = 'Add_Row' Then
      Return '1';
    End If;
    If Dotype_ = 'Del_Row' Then
      Return '1';
    End If;
    Return '1';
  End;

  /*  实现业务逻辑控制列的 编辑性
      Doaction_   I M 明细肯定为 M   I 新增 M 修改 页面载入在 当前用有列的 可用性的以后 调用  
      Column_Id_  列
      Rowlist_  当前用户
      返回: 1 可用
      0 不可用
  */
  Function Checkuseable(Doaction_  In Varchar2,
                        Column_Id_ In Varchar,
                        Rowlist_   In Varchar2) Return Varchar2 Is
    row_ BL_V_CUSTOMER_INFO_ADDRESS%rowtype;
    cur_ t_cursor;
  Begin
    row_.OBJID := pkg_a.Get_Item_Value('OBJID', rowlist_);
    if nvl(row_.OBJID, 'NULL') <> 'NULL' THEN
      If Column_Id_ = 'ADDRESS_ID' Then
        Return '0';
      End If;
    ELSE
      Return '1';
    END IF;
  End;

End BL_CUSTOMER_INFO_ADDRESS__API;
/
