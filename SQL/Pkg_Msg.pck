Create Or Replace Package Pkg_Msg Is
  /*
    -- Author  : ������
    -- Created : 2012-03-05 17:02:03
    -- Purpose :
  
    -- Public type declarations
    type <TypeName> is <Datatype>;
  
    -- Public constant declarations
    <ConstantName> constant <Datatype> := <Value>;
  
    -- Public variable declarations
    <VariableName> <Datatype>;
  
    -- Public function and procedure declarations
    function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
  */
  Type t_Cursor Is Ref Cursor;
  --������Ϣ
  --������Ϣ �� EMAIL
  Procedure Sendsysmsg(Form_ In Varchar2,
                       --������
                       To_ In Varchar2,
                       --������
                       Msg_ In Varchar2,
                       --��Ϣ����          
                       Url_ In Varchar2,
                       --���͵�email ���ӵ�ַ
                       A014_Id_  In Varchar2,
                       Table_Id_ In Varchar2,
                       Key_Id_   In Varchar2,
                       Ifemail_  In Varchar2 Default '0',
                       --�Ƿ� ����email
                       State_            In Varchar2 Default '0',
                       A014_Id_Next_     In Varchar2 Default Null,
                       Table_Id_Next_    In Varchar2 Default Null,
                       Table_Objid_Next_ In Varchar2 Default Null);
  Function Getmsgbymsgid(Msg_Id_     In Varchar2,
                         Key_        In Varchar2,
                         Exe_Id_     In Varchar Default 'WEB',
                         Language_Id In Varchar2 Default 'CN')
    Return Varchar2;
  --ִ���깦�ܼ��Ժ�����Ϣ
  Procedure Send_A014_Msg(A014_Id_  In Varchar2,
                          Rowid_    In Varchar2,
                          User_Id_  In Varchar2,
                          A311_Key_ In Number);
End Pkg_Msg;
/
Create Or Replace Package Body Pkg_Msg Is
  Count_ Number;

  /*
    ��ȡ��Ϣ����
  */
  Function Getmsgbymsgid(Msg_Id_     In Varchar2,
                         Key_        In Varchar2,
                         Exe_Id_     In Varchar Default 'WEB',
                         Language_Id In Varchar2 Default 'CN')
    Return Varchar2 Is
    A056_   A056%Rowtype;
    Err_Cur t_Cursor;
  Begin
    Select Count(*) Into Count_ From A056 Where Message_Id = Msg_Id_;
    If Count_ = 0 Then
      Return '01��Ϣ����' || Msg_Id_ || 'δ���壡';
    End If;
    If Language_Id = 'EN' Then
      Select t.*
        Into A056_
        From A056 t
       Where t.Message_Id = 'EN' || Msg_Id_
         And Rownum = 1;
    Else
      Select t.*
        Into A056_
        From A056 t
       Where t.Message_Id = Msg_Id_
         And Rownum = 1;
    End If;
  
    If Length(A056_.Error_Sql) > 10 Then
      /*��ʽ����Ϣ*/
      A056_.Error_Sql := Replace(A056_.Error_Sql, '[KEY]', Key_);
      --��ȡ��Ϣ�滻--
      Open Err_Cur For A056_.Error_Sql;
      Fetch Err_Cur
        Into A056_.Message_Content;
      Close Err_Cur;
    End If;
    /*��ʾ����Ϣ*/
    If A056_.Message_Type = 'M' Then
      --ҳ����Ϣ
      A056_.Message_Content := '00' || A056_.Message_Content;
    End If;
    /*��ʾ�Ǵ���*/
    If A056_.Message_Type = 'E' Then
      --ҳ�治���κδ���
      A056_.Message_Content := '00' || A056_.Message_Content;
    End If;
  
    /*��ʾ�Ǵ���*/
    If A056_.Message_Type = 'R' Then
      --����Ϣ�Ժ� ˢ�µ�ǰҳ�� ��������
      A056_.Message_Content := '01' || A056_.Message_Content;
    End If;
  
    /*��ʾ����Ϣ*/
    If A056_.Message_Type = 'N' Then
      --������Ϣ ֱ����ת����ҳ��
      A056_.Message_Content := '02' || A056_.Message_Content;
    End If;
  
    Return A056_.Message_Content;
  Exception
    When Others Then
      Return '00��Ϣ' || Msg_Id_ || 'δ����';
  End;
  Procedure Send_A014_Msg(A014_Id_  In Varchar2,
                          Rowid_    In Varchar2,
                          User_Id_  In Varchar2,
                          A311_Key_ In Number) Is
    A01403_      A01403%Rowtype;
    Cur_         t_Cursor;
    Cur_Msg_     t_Cursor;
    Cur_A014_    t_Cursor;
    Cur_Next_Do_ t_Cursor; --��һ�����α� 
    Next_A014_   A014%Rowtype;
    A311_        A311%Rowtype;
    Cur_User_    t_Cursor; --�û��α�
    Tcur_        t_Cursor;
    Next_Objid_  Varchar2(200); --��һ�����ݵ�����
    A00201_      A00201_V01%Rowtype;
    To_          Varchar2(100); --Ŀ�Ŀͻ�
    Msg_         Varchar2(2000); --��Ϣ����
    Url_         Varchar2(2000); -- �Ҽ��νӵ�url
    A01402_      A01402%Rowtype;
    A014_        A014%Rowtype;
    A00201_Key_  Varchar2(100);
    i            Number;
    Base_Sql_    Varchar2(2000); -- �Ҽ��νӵ�url
    Sql_         Varchar2(2000); -- �Ҽ��νӵ�url
    c            Number;
  Begin
    Open Cur_ For
      Select t.* From A01403 t Where t.A014_Id = A014_Id_;
    Fetch Cur_
      Into A01403_;
    If Cur_%Found Then
      Open Tcur_ For
        Select t.* From A311 t Where t.A311_Key = A311_Key_;
      Fetch Tcur_
        Into A311_;
      Close Tcur_;
    
      Open Tcur_ For
        Select t.* From A014 t Where t.A014_Id = A014_Id_;
      Fetch Tcur_
        Into A014_;
      Close Tcur_;
    
      Open Tcur_ For
        Select t.* From A00201_V01 t Where t.A00201_Key = A311_.A311_Id;
      Fetch Tcur_
        Into A00201_;
      Close Tcur_;
    End If;
  
    Loop
      Exit When Cur_%Notfound;
      --��ȡֻ������Ϣ����Ϣ�б�
      A01403_.Next_Sql := Replace(A01403_.Next_Sql, '[ROWID]', Rowid_);
      A01403_.Next_Sql := Replace(A01403_.Next_Sql, '[USER_ID]', User_Id_);
      A01403_.Next_Sql := Replace(A01403_.Next_Sql,
                                  '[TABLE_ID]',
                                  A00201_.Table_Id);
      A01403_.Next_Sql := Replace(A01403_.Next_Sql,
                                  '[MENU_ID]',
                                  A00201_.Menu_Id);
      If Length(Nvl(A01403_.Next_A014_Id, '-')) < 3 Then
        --��֪ͨ  �� 3�� ��һ���û�   ��2 �� Ϊ ��Ϣ����  ��3�� Ϊ ���ӵ� url ��ַ
        Open Cur_Msg_ For A01403_.Next_Sql;
        Fetch Cur_Msg_
          Into To_, Msg_, Url_;
        Loop
          Exit When Cur_Msg_%Notfound;
          --��Ϣ�����͸��Լ�
          If User_Id_ <> To_ Then
            Pkg_Msg.Sendsysmsg(User_Id_,
                               To_,
                               Msg_,
                               Url_,
                               A014_Id_,
                               A00201_.Table_Id,
                               Rowid_,
                               '1');
          End If;
          Fetch Cur_Msg_
            Into To_, Msg_, Url_;
        End Loop;
        Close Cur_Msg_;
      Else
        Open Cur_A014_ For
          Select t.* From A014 t Where t.A014_Id = A01403_.Next_A014_Id;
        Fetch Cur_A014_
          Into Next_A014_;
        If Cur_A014_%Found Then
          --�������һ�� ��ʼ������һ��   ��ȡ��һ�� ������
          --������һ���˵��� ��������
          Open Cur_Next_Do_ For A01403_.Next_Sql;
          Fetch Cur_Next_Do_
            Into Next_Objid_, Msg_, Url_;
          Loop
            Exit When Cur_Next_Do_%Notfound;
            --��ȡ�����б�
            i           := 1;
            A00201_Key_ := Pkg_a.Get_Str_(Next_A014_.Use_Menu, ',', i);
            Loop
              Exit When Length(Nvl(A00201_Key_, '-')) < 3;
              --  �ж� ��һ�����ܼ����û��б� 
              --  ���ж� �û� �� ��Ӧ�Ĳ˵��Ƿ���Ȩ��
              Open Tcur_ For
                Select A00201_Key
                  From A00201_V01 t
                 Where t.Menu_Id = A00201_Key_
                   And t.Table_Id = Next_A014_.Table_Id;
              Fetch Tcur_
                Into A00201_Key_;
              Close Tcur_;
              If Length(A00201_Key_) > 5 Then
                Base_Sql_ := Pkg_Show.Getshowdatasql(A00201_Key_,
                                                     '[USER_ID]');
                Base_Sql_ := 'Select 1 as c  from  (' || Base_Sql_ ||
                             ' ) a where objid=''' || Next_Objid_ || '''';
                c         := 0; --��Ҫ���
                If Instr(Base_Sql_, '[USER_ID]') = 0 Then
                  Open Tcur_ For Base_Sql_;
                  Fetch Tcur_
                    Into c;
                  If Tcur_%Found Then
                    c := 1; --Ҫ����Ϣ
                  Else
                    c := 2; --���÷���Ϣ
                  End If;
                  Close Tcur_;
                End If;
                If c <> 2 Then
                  Open Cur_User_ For
                    Select t.*
                      From A01402 t
                     Where t.A014_Id = Next_A014_.A014_Id
                       And t.A007_Id <> 'ADMIN'
                       And t.A007_Id <> User_Id_;
                  Fetch Cur_User_
                    Into A01402_;
                  Loop
                    Exit When Cur_User_%Notfound;
                    If c = 1 Then
                      --������Ϣ
                      Pkg_Msg.Sendsysmsg(User_Id_,
                                         A01402_.A007_Id,
                                         Msg_,
                                         Url_,
                                         A014_Id_,
                                         A014_.Table_Id,
                                         Rowid_,
                                         '1',
                                         '0',
                                         Next_A014_.A014_Id,
                                         Next_A014_.Table_Id,
                                         Next_Objid_);
                    Else
                      --������û� ��ⷢ�û���Ȩ��
                      Sql_ := Replace(Base_Sql_,
                                      '[USER_ID]',
                                      A01402_.A007_Id);
                      Open Tcur_ For Sql_;
                      Fetch Tcur_
                        Into c;
                      If Tcur_%Found Then
                        --������Ϣ
                        Pkg_Msg.Sendsysmsg(User_Id_,
                                           A01402_.A007_Id,
                                           Msg_,
                                           Url_,
                                           A014_Id_,
                                           A014_.Table_Id,
                                           Rowid_,
                                           '1',
                                           '0',
                                           Next_A014_.A014_Id,
                                           Next_A014_.Table_Id,
                                           Next_Objid_);
                      
                      End If;
                      Close Tcur_;
                    End If;
                  
                    Fetch Cur_User_
                      Into A01402_;
                  End Loop;
                  Close Cur_User_;
                End If;
              
              End If;
              i := i + 1;
            
              A00201_Key_ := Pkg_a.Get_Str_(Next_A014_.Use_Menu, ',', i);
            End Loop;
            Fetch Cur_Next_Do_
              Into Next_Objid_, Msg_, Url_;
          End Loop;
          Close Cur_Next_Do_;
        End If;
        Close Cur_A014_;
      
      End If;
    
      Fetch Cur_
        Into A01403_;
    End Loop;
    Close Cur_;
    Return;
  End;

  --������Ϣ �� EMAIL
  Procedure Sendsysmsg(Form_ In Varchar2,
                       --������
                       To_ In Varchar2,
                       --������
                       Msg_ In Varchar2,
                       --��Ϣ����          
                       Url_ In Varchar2,
                       --���͵�email ���ӵ�ַ
                       A014_Id_  In Varchar2,
                       Table_Id_ In Varchar2,
                       Key_Id_   In Varchar2,
                       Ifemail_  In Varchar2 Default '0',
                       --�Ƿ� ����email
                       State_            In Varchar2 Default '0',
                       A014_Id_Next_     In Varchar2 Default Null,
                       Table_Id_Next_    In Varchar2 Default Null,
                       Table_Objid_Next_ In Varchar2 Default Null) Is
    A007_From A007_V01%Rowtype;
    A007_To   A007_V01%Rowtype;
    Cur_      t_Cursor;
    A306_     A306%Rowtype;
  Begin
  
    Open Cur_ For
      Select t.* From A007_V01 t Where t.A007_Id = Form_;
    Fetch Cur_
      Into A007_From;
    If Cur_%Notfound Then
      Close Cur_;
      Return;
    End If;
    Close Cur_;
  
    Open Cur_ For
      Select t.* From A007_V01 t Where t.A007_Id = To_;
    Fetch Cur_
      Into A007_To;
    If Cur_%Notfound Then
      Close Cur_;
      Return;
    End If;
    Close Cur_;
  
    Select s_A306.Nextval Into A306_.A306_Id From Dual;
    --��������
    A306_.A306_Name      := A014_Id_;
    A306_.Send_A007_Id   := A007_From.A007_Id;
    A306_.Send_A007_Name := A007_From.A007_Name;
    A306_.Send_Date      := Sysdate;
    A306_.Create_Date    := Sysdate;
    A306_.Relate_No      := Key_Id_;
    A306_.Relate_Table   := Table_Id_;
    A306_.Status         := State_;
    A306_.Once_State     := '1';
    A306_.Rec_A007       := A007_To.A007_Id;
    A306_.Email_State    := '0';
  
    If Ifemail_ = '1' And Length(Url_) > 1 Then
      A306_.Email := A007_To.Email;
      --��ʽ��url
      A306_.Url := Url_;
    Else
      A306_.Url := Url_;
    End If;
  
    A306_.Description := Msg_;
    A306_.Enter_User  := A007_From.A007_Id;
    A306_.Enter_Date  := Sysdate;
    A306_.A014_Id     := Nvl(A014_Id_Next_, A014_Id_);
    A306_.Table_Id    := Nvl(Table_Id_Next_, Table_Id_);
    A306_.Table_Objid := Nvl(Table_Objid_Next_, A306_.Relate_No);
    Insert Into A306
      (A306_Id,
       A306_Name,
       Send_A007_Id,
       Send_A007_Name,
       Send_Date,
       Create_Date,
       Relate_No,
       Relate_Table,
       Status,
       Once_State,
       Rec_A007,
       Email,
       Url,
       Description,
       Enter_User,
       Enter_Date,
       A014_Id,
       Table_Id,
       Table_Objid) /*nologging*/
    Values
      (A306_.A306_Id,
       A306_.A306_Name,
       A306_.Send_A007_Id,
       A306_.Send_A007_Name,
       A306_.Send_Date,
       A306_.Create_Date,
       A306_.Relate_No,
       A306_.Relate_Table,
       A306_.Status,
       A306_.Once_State,
       A306_.Rec_A007,
       A306_.Email,
       A306_.Url,
       A306_.Description,
       A306_.Enter_User,
       A306_.Enter_Date,
       A306_.A014_Id,
       A306_.Table_Id,
       A306_.Table_Objid
       
       );
  
    -- UPDATE A306 SET ROW = A306_ WHERE A306_Id = A306_.A306_Id;
    Return;
  End;
End Pkg_Msg;
/
