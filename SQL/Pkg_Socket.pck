Create Or Replace Package Pkg_Socket Is

  /*Created By WTL  2013-03-13 11:17:31*/
  --监听 
  Procedure Client_Disconnect(Ip_ In Varchar2, Server_Ip_ In Varchar2);
  Procedure Client_Connect(Ip_ In Varchar2, Server_Ip_ In Varchar2);
  --解包 
  Procedure Do_Xml(Log_Id_ In Number);
  --按照关键字返回数据
  Function Get_Key_Value(Data_ Clob, Key_ In Varchar2)
    Return Dbms_Sql.Varchar2a;
  --获取 请求 的包 的head
  Function Get_Head_Xml(Transactionid_ In Varchar2,
                        Messagename_   In Varchar2) Return Varchar2;
  --组包的结束内容                       
  Function End_Xml Return Varchar2;

  --组包
  Function Get_Xml(Transactionid_ In Varchar2,
                   Messagename_   In Varchar2,
                   Objid_         In Varchar2) Return Clob;
  Procedure Request_Xml(Messagename_ In Varchar2,
                        Key_         In Varchar2,
                        User_Id_     In Varchar2,
                        A311_Key_    In Number);
  Function Get_Resp_Head_Xml(Transactionid_ In Varchar2,
                             Messagename_   In Varchar2,
                             Resultcode_    In Varchar2,
                             Resultmessage_ In Varchar2) Return Varchar2;
  --处理接收的报文
  Procedure Response_Xml(A139_Line_ In Number,
                         User_Id_   In Varchar2,
                         A311_Key_  In Number);
  Procedure Insert_A320(A320_Id_    In Number,
                        Clientip_   In Varchar2,
                        Receivexml_ In Clob);
  --处理报文 ActiveTestReq                     
  Procedure Activetestreq(A320_ A320%Rowtype);
  --插入报文
  Procedure Insert_Into_A32001(A32001_ In Out A32001%Rowtype);
  -- 组应答(Resp)包的 Body 
  Function Get_Resp_Xml(A320_ A320%Rowtype) Return Clob;

  --处理报文  db server 处理报文
  Procedure Req_(A320_ A320%Rowtype);

End Pkg_Socket;
/
Create Or Replace Package Body Pkg_Socket Is

  /*Created By WTL  2013-03-13 11:17:31*/

  Type t_Cursor Is Ref Cursor;
  --客户端断开连接 --
  Procedure Client_Disconnect(Ip_ In Varchar2, Server_Ip_ In Varchar2) Is
    A321_ A321%Rowtype;
    Pos_  Number;
  Begin
    Delete From A321 t
     Where t.Server_Ip = Server_Ip_
       And A321_Name = Ip_;
  End;
  --处理接收包
  Procedure Response_Xml(A139_Line_ In Number,
                         User_Id_   In Varchar2,
                         A311_Key_  In Number) Is
    A31902_     A31902%Rowtype;
    Messagetype Varchar2(1000);
    Pos_        Number;
    Cur_        t_Cursor;
    i_          Number;
    Result_     Dbms_Sql.Varchar2a;
    --  Result_ 
  Begin
    Open Cur_ For
      Select t.* From A31902 t Where t.Line_No = A139_Line_;
    Fetch Cur_
      Into A31902_;
    Close Cur_;
    /*
    <?xml version="1.0" encoding="utf-8"?><MIAP><MIAP-Header><TransactionID>20130423100231596108000</TransactionID><Version>1.0</Version><MessageName>ActiveTestResp</MessageName><TestFlag>1</TestFlag><TestFlag>1</TestFlag><ReturnCode>0</ReturnCode ><ReturnMessage>Successfully handled</ReturnMessage></MIAP-Header><MIAP-Body><ActiveTestResp></ActiveTestResp></MIAP-Body></MIAP>
    
    */
    --解析XML  
    Result_            := Get_Key_Value(A31902_.Receivexml, 'ReturnCode');
    A31902_.Returncode := Result_(1);
  
    --解析XML  
    Result_               := Get_Key_Value(A31902_.Receivexml,
                                           'ReturnMessage');
    A31902_.Returnmessage := Result_(1);
  
    Update A31902 t
       Set t.Returncode    = A31902_.Returncode,
           t.Returnmessage = A31902_.Returnmessage
     Where t.A319_Id = A31902_.A319_Id;
    If A31902_.Returncode != '0' Then
      --如果成功  解析成功的包
      Pkg_a.Setmsg(A311_Key_, '', '03' || A31902_.Returnmessage);
    
    End If;
    Pkg_a.Setmsg(A311_Key_, '', '03' || A31902_.Returnmessage);
    Return;
  End;

  --客户端连接 --
  Procedure Client_Connect(Ip_ In Varchar2, Server_Ip_ In Varchar2) Is
    A321_ A321%Rowtype;
    Pos_  Number;
  Begin
    Delete From A321 Where A321_Name = Ip_;
  
    Pos_       := Instr(Ip_, ':');
    A321_.Ip   := Substr(Ip_, 1, Pos_ - 1);
    A321_.Port := Substr(Ip_, Pos_ + 1);
  
    Select s_A321.Nextval Into A321_.A321_Id From Dual;
    Insert Into A321
      (A321_Id, A321_Name, Ip, Port, Enter_Date, Enter_User, Server_Ip)
    Values
      (A321_.A321_Id,
       Ip_,
       A321_.Ip,
       A321_.Port,
       Systimestamp,
       Ip_,
       Server_Ip_);
  
  End;
  Function Get_Client(Key_ In Varchar2) Return Varchar2 Is
  Begin
    Return '';
  End;

  --解包
  Procedure Do_Xml(Log_Id_ In Number) Is
    A320_        A320%Rowtype;
    Parent_A320_ A320%Rowtype;
    Cur_         t_Cursor;
    Result_      Dbms_Sql.Varchar2a;
    A32001_      A32001%Rowtype;
    Ia32001_     A32001%Rowtype;
    Pos_         Number;
    Res_         Number;
    Messagename_ Varchar2(100);
  Begin
    Open Cur_ For
      Select t.* From A320 t Where t.A320_Id = Log_Id_;
    Fetch Cur_
      Into A320_;
    Close Cur_;
    --解析XML  
    Result_           := Get_Key_Value(A320_.Receivexml, 'MessageName');
    A320_.Messagename := Result_(1);
  
    A320_.Xml_Type := Upper(Substr(A320_.Messagename,
                                   Length(A320_.Messagename) - 3));
    If A320_.Xml_Type = 'RESP' Then
      A320_.Xml_Type := 'Resp';
    Else
      A320_.Xml_Type := 'Req';
    End If;
    Result_             := Get_Key_Value(A320_.Receivexml, 'TransactionID');
    A320_.Transactionid := Result_(1);
  
    Update A320 t
       Set t.Transactionid = A320_.Transactionid,
           t.Messagename   = A320_.Messagename,
           t.Xml_Type      = A320_.Xml_Type
     Where t.A320_Id = A320_.A320_Id;
    --如果接收到的报文为 RESP
    If A320_.Xml_Type = 'Resp' Then
      --在A32001中寻找Transactionid
      Open Cur_ For
        Select t.*
          From A32001 t
         Where t.Next_Ip = A320_.Client_Ip
           And t.Transactionid = A320_.Transactionid;
      Fetch Cur_
        Into A32001_;
      If Cur_%Found Then
        Close Cur_;
        --把应答报文回写给 发送报文主键
        Update A32001 t
           Set t.Next_A320_Id = A320_.A320_Id, t.State = '2'
         Where t.Line_No = A32001_.Line_No;
        --检测报文是否已经处理完
        Open Cur_ For
          Select 1
            From A32001 t
           Where t.A320_Id = A32001_.A320_Id
             And t.State = '0';
        Fetch Cur_
          Into Res_;
        If Cur_%Notfound Then
          Close Cur_;
          --如果不存在未处理的报文
          --应答 A320    把数据插入到A32001 中  
          Open Cur_ For
            Select t.* From A320 t Where t.A320_Id = A32001_.A320_Id;
          Fetch Cur_
            Into Parent_A320_;
          Close Cur_;
        
          --组应答包   
          Ia32001_.Next_Xml := Get_Resp_Xml(Parent_A320_);
          --
          Ia32001_.Next_Ip       := Parent_A320_.Client_Ip; --要转发的下个连接的地址     
          Ia32001_.A320_Id       := A320_.A320_Id;
          Ia32001_.Next_A320_Id  := Parent_A320_.A320_Id;
          Ia32001_.Transactionid := Parent_A320_.Transactionid;
          Ia32001_.Xml_Type      := 'Resp';
          Insert_Into_A32001(Ia32001_);
          Update A320 t
             Set t.State            = '2',
                 t.Modi_Date        = Systimestamp,
                 t.Modi_User        = A320_.Client_Ip,
                 t.Next_A32001_Line = Ia32001_.Line_No
           Where t.A320_Id = A32001_.A320_Id;
        Else
          Close Cur_;
        End If;
      
      Else
        Close Cur_;
      End If;
    
    End If;
    If A320_.Xml_Type = 'Req' Then
      /*  If A320_.Messagename = 'ActiveTestReq' Then
        Activetestreq(A320_);
      End If;*/
      Req_(A320_);
    End If;
    Update A320 t
       Set t.State     = '1',
           t.Modi_Date = Systimestamp,
           t.Modi_User = t.Client_Ip
     Where t.A320_Id = A320_.A320_Id;
    Return;
  End;
  --组应答包的 Body  （要修改）
  Function Get_Resp_Xml(A320_ A320%Rowtype) Return Clob Is
    A32001_      A32001%Rowtype;
    i_           Number;
    Respxml_     Clob;
    Bodyxml_     Clob;
    Allbodyxml_  Clob;
    Result_      Varchar2(10);
    Resultmsg_   Varchar2(100);
    Messagename_ Varchar2(100);
    Cur_         t_Cursor;
  Begin
    If A320_.Xml_Type != 'Req' Then
      Return Null;
    End If;
    Messagename_ := Substr(A320_.Messagename,
                           1,
                           Length(A320_.Messagename) -
                           Length(A320_.Xml_Type));
    i_           := 0;
    Result_      := '0';
    Resultmsg_   := 'Successfully handled';
    Allbodyxml_  := '';
    --读取应答的结果
    Open Cur_ For
      Select t.* From A32001 t Where t.A320_Id = A320_.A320_Id;
    Fetch Cur_
      Into A32001_;
    Loop
      Exit When Cur_%Notfound;
      --如果相同的ip 地址 直接返回数据
      If A32001_.Next_Ip = A320_.Client_Ip Then
        Close Cur_;
        Return A32001_.Next_Xml;
      Else
        i_       := i_ + 1;
        Bodyxml_ := '<' || Messagename_ || 'Resp>';
      
        --按照返回的A32001_的返回包组包
      
        Result_    := '0';
        Resultmsg_ := 'Successfully handled';
      
        --循环 发出的应答 读取结果
      
        Bodyxml_ := Bodyxml_ || '</' || Messagename_ || 'Resp>';
      
        Allbodyxml_ := Allbodyxml_ || Bodyxml_;
      End If;
      Fetch Cur_
        Into A32001_;
    End Loop;
    Close Cur_;
  
    If i_ = 0 Then
      Allbodyxml_ := Allbodyxml_ || '<' || Messagename_ || 'Resp></' ||
                     Messagename_ || 'Resp>';
    End If;
    Respxml_ := Get_Resp_Head_Xml(A320_.Transactionid,
                                  Messagename_,
                                  Result_,
                                  Resultmsg_);
    Respxml_ := Respxml_ || Allbodyxml_ || End_Xml();
    Return Respxml_;
  End;
  --erp组 发送包
  Procedure Request_Xml(Messagename_ In Varchar2,
                        Key_         In Varchar2,
                        User_Id_     In Varchar2,
                        A311_Key_    In Number) Is
    A31902_        A31902%Rowtype;
    A319_          A319%Rowtype;
    Xml_           Clob;
    Transactionid_ Varchar2(100);
    Objid_         Varchar2(50);
    Cur_           t_Cursor;
    Ss_            Number;
  Begin
    Open Cur_ For
      Select t.* From A319 t Where t.A319_Id = Messagename_;
    Fetch Cur_
      Into A319_;
    If Cur_%Notfound Then
      Close Cur_;
      Raise_Application_Error(Pkg_a.Raise_Error,
                              Messagename_ || '生成报文失败！');
    End If;
    Close Cur_;
    If Nvl(A319_.Reqtime, 0) > 0 Then
      Open Cur_ For
        Select Max(t.Enter_Date)
          From A31902 t
         Where t.A319_Id = Messagename_
           And t.Con_Key = Key_;
      Fetch Cur_
        Into A31902_.Enter_Date;
      Close Cur_;
      A31902_.Enter_Date := Nvl(A31902_.Enter_Date, Systimestamp - 1);
      Ss_                := (Sysdate -
                            To_Date(To_Char(A31902_.Enter_Date,
                                             'yyyymmddhh24miss'),
                                     'yyyymmddhh24miss')) * 24 * 60 * 60;
    
      If Ss_ < A319_.Reqtime Then
      
        Raise_Application_Error(Pkg_a.Raise_Error,
                                '取包信息太快，请稍后再发请求！' || To_Char(Ss_));
      
      End If;
    End If;
    --if (Systimestamp - 
  
    Select s_A31902.Nextval Into A31902_.Line_No From Dual;
    Transactionid_ := To_Char(Systimestamp, 'yyyymmddhh24missff');
    Xml_           := Get_Xml(Transactionid_, Messagename_, Key_);
    If Xml_ = Null Then
      Raise_Application_Error(Pkg_a.Raise_Error, '生成报文失败！');
    End If;
    Insert Into A31902
      (A319_Id,
       Line_No,
       Sendxml,
       Transactionid,
       Xml_Type,
       Enter_Date,
       Enter_User,
       Con_Key)
    Values
      (Messagename_,
       A31902_.Line_No,
       Xml_,
       Transactionid_,
       'REQ',
       Systimestamp,
       User_Id_,
       Key_)
    Returning Rowid Into Objid_;
    Pkg_a.Setsuccess(A311_Key_, 'A31902', Objid_);
  
  End;

  --组包
  Function Get_Xml(Transactionid_ In Varchar2,
                   Messagename_   In Varchar2,
                   Objid_         In Varchar2) Return Clob Is
    A319_       A319%Rowtype;
    Cur_        t_Cursor;
    Xml_        Clob;
    A10001_     A10001%Rowtype;
    Data_       Dbms_Sql.Varchar2_Table;
    Column_     Dbms_Sql.Varchar2_Table;
    v_Cursor    Number;
    v_Stat      Number;
    v_Row       Number;
    v_Sql       Varchar2(4000);
    v_i         Number;
    i           Number;
    v_Data_     Varchar2(2000);
    Column_Id_  A10001.Column_Id%Type;
    Temptable_  Varchar2(200);
    Columns_    User_Tab_Columns%Rowtype;
    Rowlist_    Varchar2(20000);
    A31901_     A31901_V01%Rowtype;
    Bodyxml_    Varchar2(20000);
    Rowbodyxml_ Varchar2(20000);
    Cur1_       t_Cursor;
    A318_       A318_V01%Rowtype;
    A31801_     A31801%Rowtype;
  Begin
    Open Cur_ For
      Select t.* From A319 t Where t.A319_Id = Messagename_;
    Fetch Cur_
      Into A319_;
    If Cur_%Notfound Then
      Return Null;
    End If;
    Close Cur_;
    Xml_ := Get_Head_Xml(Transactionid_, Messagename_);
    If Length(A319_.Reqsql) > 2 Then
      Bodyxml_ := '<' || Messagename_ || 'Req>';
      Open Cur_ For
        Select t.*
          From A31901_V01 t
         Where t.A319_Id = A319_.A319_Id
         Order By t.Col_Id;
      Fetch Cur_
        Into A31901_;
      Loop
        Exit When Cur_%Notfound;
        If Nvl(A31901_.A318_Id, '-') != '-' Then
          Open Cur1_ For
            Select t.* From A318_V01 t Where t.A318_Id = A31901_.A318_Id;
          Fetch Cur1_
            Into A318_;
          If Cur1_%Found Then
            Close Cur1_;
            If A318_.If_Parent = '1' Then
              --循环节点明细
              Bodyxml_ := Bodyxml_ || '<' || A31901_.Column_Id || '>';
              Open Cur1_ For
                Select t.* From A31801 t Where t.A318_Id = A318_.A318_Id;
              Fetch Cur1_
                Into A31801_;
              Loop
                Exit When Cur1_%Notfound;
                Bodyxml_ := Bodyxml_ || '<' || A31801_.Column_Id || '>[' ||
                            Upper(A31901_.Column_Id || '_' ||
                                  A31801_.Column_Id) || ']</' ||
                            A31801_.Column_Id || '>';
                Fetch Cur1_
                  Into A31801_;
              End Loop;
              Close Cur1_;
              Bodyxml_ := Bodyxml_ || '</' || A31901_.Column_Id || '>';
            End If;
          
          Else
            Close Cur1_;
            Bodyxml_ := Bodyxml_ || '<' || A31901_.Column_Id || '>[' ||
                        Upper(A31901_.Column_Id) || ']</' ||
                        A31901_.Column_Id || '>';
          End If;
        
        Else
          Bodyxml_ := Bodyxml_ || '<' || Messagename_ || '>' ||
                      A31901_.Column_Id || '</' || Messagename_ || '>';
        End If;
      
        Fetch Cur_
          Into A31901_;
      End Loop;
      Close Cur_;
      Bodyxml_ := Bodyxml_ || '</' || Messagename_ || 'Req>';
    
      A319_.Reqsql := Replace(A319_.Reqsql, '[ROWID]', Objid_);
      A319_.Reqsql := Replace(A319_.Reqsql, '[KEY]', Objid_);
    
      Temptable_ := 'T' || To_Char(Sysdate, 'YYYYMMDDHH24MISS');
      Pkg_a.Createtemptable(A319_.Reqsql, Temptable_);
      v_Sql := A319_.Reqsql;
      i     := 0;
      v_i   := 0;
      Open Cur_ For
        Select t.*
          From User_Tab_Columns t
         Where t.Table_Name = Temptable_
         Order By t.Column_Id;
      Fetch Cur_
        Into Columns_;
      Loop
        Exit When Cur_%Notfound;
        i := i + 1;
        Column_(i) := Upper(Columns_.Column_Name);
      
        Fetch Cur_
          Into Columns_;
      End Loop;
      Close Cur_;
      Pkg_a.Droptemptable(Temptable_);
    
      v_i      := i;
      v_Cursor := Dbms_Sql.Open_Cursor; --打开游标；
      Dbms_Sql.Parse(v_Cursor, v_Sql, Dbms_Sql.Native); --解析动态SQL语句；
      i := 1;
      Loop
        Exit When i > v_i;
        Dbms_Sql.Define_Column(v_Cursor, i, v_Data_, 2000); --定义列       
        i := i + 1;
      End Loop;
      v_Stat := Dbms_Sql.Execute(v_Cursor); --执行动态SQL语句。 
      Loop
        Exit When Dbms_Sql.Fetch_Rows(v_Cursor) <= 0; --fetch_rows在结果集中移动游标，如果未抵达末尾，返回1。 
        Rowbodyxml_ := Bodyxml_;
        i           := 1;
        Rowlist_    := '';
        Loop
          Exit When i > v_i;
          Dbms_Sql.Column_Value(v_Cursor, i, v_Data_); --将当前行的查询结果写入上面定义的列中。 
          --循环列名称 
          --Pkg_a.Set_Item_Value(Column_(i), v_Data_, Rowlist_);
          Rowbodyxml_ := Replace(Rowbodyxml_,
                                 '[' || Column_(i) || ']',
                                 v_Data_);
          i           := i + 1;
        End Loop;
        --开始组包
        Xml_ := Xml_ || Rowbodyxml_;
      End Loop;
      Dbms_Sql.Close_Cursor(v_Cursor); --关闭游标。 
      Pkg_a.Droptemptable(Temptable_);
    End If;
    Xml_ := Xml_ || End_Xml();
  
    Return Xml_;
  End;
  Function Get_Head_Xml(Transactionid_ In Varchar2,
                        Messagename_   In Varchar2) Return Varchar2 Is
    Result_ Varchar2(4000);
  Begin
    Result_ := '<?xml version="1.0" encoding="utf-8"?>';
    Result_ := Result_ || '<MIAP>';
    Result_ := Result_ || '<MIAP-Header>';
    Result_ := Result_ || '<TransactionID>' || Transactionid_ ||
               '</TransactionID>';
    Result_ := Result_ || '<Version>1.0</Version>';
    Result_ := Result_ || '<MessageName>' || Messagename_ ||
               'Req</MessageName>';
    Result_ := Result_ || '<TestFlag>1</TestFlag>';
    Result_ := Result_ || '</MIAP-Header>';
    Result_ := Result_ || '<MIAP-Body>';
    Return Result_;
  End;
  Function Get_Resp_Head_Xml(Transactionid_ In Varchar2,
                             Messagename_   In Varchar2,
                             Resultcode_    In Varchar2,
                             Resultmessage_ In Varchar2) Return Varchar2 Is
    Result_ Varchar2(4000);
  Begin
    Result_ := '<?xml version="1.0" encoding="utf-8"?>';
    Result_ := Result_ || '<MIAP>';
    Result_ := Result_ || '<MIAP-Header>';
    Result_ := Result_ || '<TransactionID>' || Transactionid_ ||
               '</TransactionID>';
    Result_ := Result_ || '<Version>1.0</Version>';
    Result_ := Result_ || '<MessageName>' || Messagename_ ||
               'Resp</MessageName>';
    Result_ := Result_ || '<TestFlag>1</TestFlag>';
    Result_ := Result_ || '<TestFlag>1</TestFlag>';
    Result_ := Result_ || '<ReturnCode>' || Resultcode_ || '</ReturnCode>';
    Result_ := Result_ || '<ReturnMessage>' || Resultmessage_ ||
               '</ReturnMessage>';
    Result_ := Result_ || '</MIAP-Header>';
    Result_ := Result_ || '<MIAP-Body>';
    Return Result_;
  End;

  Function End_Xml Return Varchar2 Is
  Begin
    Return '</MIAP-Body></MIAP>';
  
  End;

  Function Get_Key_Value(Data_ Clob, Key_ In Varchar2)
    Return Dbms_Sql.Varchar2a Is
    Result_    Varchar2(4000);
    Pos1_      Number;
    Pos2_      Number;
    v_Data     Dbms_Sql.Varchar2a;
    Rightdata_ Clob;
    i_         Number;
    Length_    Number;
  Begin
    Rightdata_ := Data_;
    Pos1_      := Dbms_Lob.Instr(Rightdata_, '<' || Key_ || '>');
    Pos2_      := Dbms_Lob.Instr(Rightdata_, '</' || Key_ || '>');
    Pos1_      := Nvl(Pos1_, 0);
    Pos2_      := Nvl(Pos2_, 0);
    i_         := 0;
    Length_    := Dbms_Lob.Getlength(Rightdata_);
    Loop
      Exit When(Pos1_ <= 0 Or Pos2_ <= 0 Or Pos1_ >= Pos2_);
      i_ := i_ + 1;
      v_Data(i_) := Dbms_Lob.Substr(Rightdata_,
                                    Pos2_ - Pos1_ - Length(Key_) - 2,
                                    Pos1_ + Length(Key_) + 2);
    
      Rightdata_ := Dbms_Lob.Substr(Rightdata_,
                                    Length_ - Pos2_ - Length(Key_) - 3,
                                    Pos2_ + Length(Key_) + 3);
      Pos1_      := Dbms_Lob.Instr(Rightdata_, '<' || Key_ || '>');
      Pos2_      := Dbms_Lob.Instr(Rightdata_, '</' || Key_ || '>');
      Pos1_      := Nvl(Pos1_, 0);
      Pos2_      := Nvl(Pos2_, 0);
    End Loop;
  
    Return v_Data;
  
  Exception
    When Others Then
      Return v_Data;
  End;
  Procedure Insert_A320(A320_Id_    In Number,
                        Clientip_   In Varchar2,
                        Receivexml_ In Clob) Is
  Begin
    Insert Into A320
      (A320_Id,
       A320_Name,
       Receivexml,
       Client_Ip,
       Enter_Date,
       Enter_User,
       State)
    Values
      (A320_Id_,
       Clientip_,
       Receivexml_,
       Clientip_,
       Systimestamp,
       Clientip_,
       '0');
    Do_Xml(A320_Id_);
    /*    Update A320 t
      Set t.Receivexml = Receivexml_
    Where t.A320_Id = A320_Id_;*/
  
  End;
  Procedure Insert_Into_A32001(A32001_ In Out A32001%Rowtype) Is
    Pos_ Number;
  Begin
    Select s_A32001.Nextval Into A32001_.Line_No From Dual;
    Pos_              := Instr(A32001_.Next_Ip, ':');
    A32001_.Next_Port := Substr(A32001_.Next_Ip, Pos_ + 1);
    --默认不需要下级
    A32001_.State      := '0';
    A32001_.Enter_Date := Systimestamp;
    A32001_.Enter_User := A32001_.Next_Ip;
    Insert Into A32001
      (A320_Id,
       Line_No,
       Next_Ip,
       Next_Xml,
       Next_Port,
       State,
       Enter_Date,
       Enter_User,
       Transactionid,
       Xml_Type,
       Next_A320_Id)
    Values
      (A32001_.A320_Id,
       A32001_.Line_No,
       A32001_.Next_Ip,
       A32001_.Next_Xml,
       A32001_.Next_Port,
       A32001_.State,
       A32001_.Enter_Date,
       A32001_.Enter_User,
       A32001_.Transactionid,
       A32001_.Xml_Type,
       A32001_.Next_A320_Id);
  
  End;
  --处理报文  db server 处理报文
  Procedure Req_(A320_ A320%Rowtype) Is
  Begin
    If A320_.Messagename = 'ActiveTestReq' Then
      Activetestreq(A320_);
    End If;
  
    Return;
  End;

  --链路激活测试接口消息 
  Procedure Activetestreq(A320_ A320%Rowtype) Is
    A32001_     A32001%Rowtype;
    Messagetype Varchar2(1000);
    Reqorresp   Varchar2(100);
    Pos_        Number;
    Cur_        t_Cursor;
    A321_       A321%Rowtype;
    i_          Number;
    Result_     Dbms_Sql.Varchar2a;
  Begin
    i_ := 0;
    Open Cur_ For
      Select t.* From A321 t Where 1 = 2;
    Fetch Cur_
      Into A321_;
    Loop
      Exit When Cur_%Notfound;
      If A321_.A321_Name <> A320_.Client_Ip Then
        A32001_.Transactionid := To_Char(Systimestamp, 'yyyymmddhh24missff');
        A32001_.Next_Xml      := Get_Head_Xml(A32001_.Transactionid,
                                              'ActiveTest');
        A32001_.Next_Xml      := A32001_.Next_Xml ||
                                 '<ActiveTestReq></ActiveTestReq>';
        A32001_.Next_Xml      := A32001_.Next_Xml || End_Xml();
        A32001_.Next_Ip       := A321_.A321_Name; --要转发的下个连接的地址     
        A32001_.A320_Id       := A320_.A320_Id;
        A32001_.Xml_Type      := 'Req';
        A32001_.State         := '0';
        Insert_Into_A32001(A32001_);
        i_ := i_ + 1;
      End If;
      Fetch Cur_
        Into A321_;
    End Loop;
    Close Cur_;
    If i_ = 0 Then
      --解析XML  
      Result_               := Get_Key_Value(A320_.Receivexml,
                                             'TransactionID');
      A32001_.Transactionid := Result_(1);
    
      A32001_.Next_Xml     := Get_Resp_Head_Xml(A32001_.Transactionid,
                                                'ActiveTest',
                                                '0',
                                                'Success111111111');
      A32001_.Next_Xml     := A32001_.Next_Xml ||
                              '<ActiveTestResp></ActiveTestResp>';
      A32001_.Next_Xml     := A32001_.Next_Xml || End_Xml();
      A32001_.Next_Ip      := A320_.Client_Ip; --要转发的下个连接的地址     
      A32001_.A320_Id      := A320_.A320_Id;
      A32001_.Next_A320_Id := A320_.A320_Id;
      A32001_.Xml_Type     := 'Resp';
      A32001_.State        := '0';
      Insert_Into_A32001(A32001_);
    End If;
  
  End;

End Pkg_Socket;
/
