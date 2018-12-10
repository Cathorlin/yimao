Create Or Replace Package Pkg_Attr Is
  --获取保隆用户

  Function Get_Bl_Userid(User_Id_ In Varchar) Return Varchar2;
  Function Userlanguage(User_Id_ In Varchar) Return Varchar2;

  ---检测用户的客户权限
  Function Checkcustomer(User_Id_ In Varchar2,
                         ---用户-- 
                         Customer_No_ In Varchar2,
                         --数据 
                         Contract_ In Varchar2) Return Number;
  --检测用户的供应商权限
  Function Checksupplier(User_Id_ In Varchar2,
                         ---用户-- 
                         Vonder_No_ In Varchar2,
                         --数据 
                         Contract_ In Varchar2) Return Number;
  --检查用户的域权限                         
  Function Checkcontract(User_Id_ In Varchar2, Contract_ In Varchar2)
    Return Number;

  --获取用户的默认域
  Function Get_Default_Contract(User_Id_ In Varchar2) Return Varchar2;

  Function Checkpartno(User_Id_  In Varchar2,
                       Contract_ In Varchar2,
                       Part_No_  In Varchar2) Return Number;
  --用户库位权限                     
  Function Check_Location(User_Id_     In Varchar2,
                          Contract_    In Varchar2,
                          Location_No_ In Varchar2) Return Number;
  --客户库位权限                     
  Function Checkcust_Location(Customer_No_ In Varchar2,
                              Contract_    In Varchar2,
                              Location_No_ In Varchar2) Return Number;

  --检测域 销售件 和 客户协议的存在性
  Function Check_Agreement_Part(Contract_     In Varchar2,
                                Catalog_No_   In Varchar2,
                                Agreement_Id_ In Varchar2) Return Number;
End Pkg_Attr;
/
Create Or Replace Package Body Pkg_Attr Is
  Type t_Cursor Is Ref Cursor;
  /* modify fjp 2012-12-12 检测域权限(用A00704表)
  modify  fjp 2012-12-13 检测业务员(用A00709表)*/
  --获取语言
  Function Get_Bl_Userid(User_Id_ In Varchar) Return Varchar2 Is
    Cur_    t_Cursor;
    Result_ Varchar2(50);
  Begin
    Open Cur_ For
      Select t.Bl_Userid
        From A007 t
       Where t.A007_Id = User_Id_
         And Rownum = 1;
    Fetch Cur_
      Into Result_;
    If Cur_%Found Then
      Close Cur_;
      Return Result_;
    End If;
    Close Cur_;
  
    Return Nvl(Result_, User_Id_);
  
  End;

  Function Userlanguage(User_Id_ In Varchar) Return Varchar2 Is
    Cur_    t_Cursor;
    Result_ Varchar2(20);
  Begin
    Open Cur_ For
      Select t.Language_Id
        From A007 t
       Where t.A007_Id = User_Id_
         And Rownum = 1;
    Fetch Cur_
      Into Result_;
    If Cur_%Found Then
      Close Cur_;
      Return Result_;
    End If;
    Close Cur_;
  
    Return Nvl(Result_, 'CN');
  End;
  --用户库位(库位组)权限
  Function Check_Location(User_Id_     In Varchar2,
                          Contract_    In Varchar2,
                          Location_No_ In Varchar2) Return Number Is
    Cur_ t_Cursor;
    --  Result_         Varchar2(20);
    Count_          Number;
    Location_Group_ Varchar2(200);
  Begin
    /* 
    
    exists (select 1 from A00707_V01 A1 where a1.a007_id='[USER_ID]' and a1.contract =t.contract and a1.location_no = T.location_no)
    
         */
  
    Open Cur_ For
      Select 1
        From A00707_V01 t
       Where t.Contract = Contract_
         And t.Location_No = Location_No_
         And t.A007_Id = User_Id_;
    Fetch Cur_
      Into Count_;
    If Cur_%Found Then
      Return 1;
    End If;
    Close Cur_;
  
    Return 0;
    /*
    Open Cur_ For
      Select 1
        From A00707 t
       Where t.Contract = Contract_
         And t.Location_No = Location_No_
         And t.A007_Id = User_Id_;
    Fetch Cur_
      Into Count_;
    If Cur_%Found Then
      Return 1;
    End If;
    Close Cur_;
    
    Location_Group_ := Inventory_Location_Api.Get_Location_Group(Contract_,
                                                                 Location_No_);
    Location_Group_ := Nvl(Location_Group_, Location_No_);
    Open Cur_ For
      Select 1
        From A00707 t
       Where t.Contract = Contract_
         And t.Location_No = Location_Group_
         And t.A007_Id = User_Id_
         And t.Loation_Group = '1';
    Fetch Cur_
      Into Count_;
    If Cur_%Found Then
      Return 1;
    End If;
    Close Cur_;
    Return 0;
    
    /*  --判断是否库位组
        Select Count(*)
          Into Count_
          From Inventory_Location_Group_Tab
         Where Location_Group = Location_No_
           And Rownum = 1;
        --如果是组
        If Count_ > 0 Then
          Select Count(*)
            Into Count_
            From A00707 t
           Where t.Contract = Contract_
             And t.Location_No = Location_No_
             And t.A007_Id = User_Id_
             And t.Loation_Group = '1'
             And Rownum = 1;
          If Count_ > 0 Then
            Return 1;
          Else        
            return  0;
          End If;
        Else
          Select Count(*)
            Into Count_
            From A00707 t
           Where t.Contract = Contract_
             And t.Location_No = Location_No_
             And t.A007_Id = User_Id_
             And t.Loation_Group = '0';
          If Count_ > 0 Then
            Return 1;
          Else
            Select Count(*)
              Into Count_
              From A00707 t
             Where t.Contract = Contract_
               And t.Location_No =
                   Inventory_Location_Api.Get_Location_Group(Contract_,
                                                             Location_No_)
               And t.A007_Id = User_Id_
               And t.Loation_Group = '1';
            If Count_ > 0 Then
              Return 1;
            Else
              Return 0;
            End If;
          End If;
        End If;
        \*    Open Cur_ For
            SELECT 1 
            FROM A00707 T
            WHERE T.CONTRACT = Contract_
            AND   T.LOCATION_NO= Location_No_
            AND   T.A007_ID = User_Id_
            union
            select 1
            from  A00707 t
            WHERE T.CONTRACT    =   Contract_
            AND   T.LOCATION_NO  = Location_No_
            AND   T.A007_ID     =    User_Id_;
        Fetch Cur_
          Into Result_;
        If Cur_%Found Then
          Result_ := 1;
        Else
          Result_ := 0;
        End If;
        
        Return Result_;*\
    */
  End;
  --客户库位权限
  Function Checkcust_Location(Customer_No_ In Varchar2,
                              Contract_    In Varchar2,
                              Location_No_ In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Varchar2(20);
  Begin
  
    Open Cur_ For
      Select 1
        From Bl_Customerlocation t
       Where t.Contract = Contract_
         And t.Location_No = Location_No_
         And t.Customer_No = Customer_No_;
    Fetch Cur_
      Into Result_;
    If Cur_%Found Then
      Result_ := 1;
    Else
      Result_ := 0;
    End If;
  
    Return Result_;
  End;

  Function Checkpartno(User_Id_  In Varchar2,
                       Contract_ In Varchar2,
                       Part_No_  In Varchar2) Return Number Is
    Cur_       t_Cursor;
    Bl_Userid_ A007.Bl_Userid%Type;
    Planner_   Varchar2(100);
  Begin
    --modify fjp 2012-12-12
    /*    Open Cur_ For
      Select t.Bl_Userid
        From A007 t
       Where t.A007_Id = User_Id_
         And Rownum = 1;
    Fetch Cur_
      Into Bl_Userid_;
    If Cur_%Notfound Then
      Close Cur_;
      Return 0;
    Else
      Close Cur_;
    End If;*/
  
    Open Cur_ For
    --modify fjp 2012-12-12
    -- Select t.Userid From Bl_Planner_Group t Where t.Userid = Bl_Userid_;
      Select t.A007_Id From A00709 t Where t.A007_Id = User_Id_;
    Fetch Cur_
      Into Bl_Userid_;
    If Cur_%Notfound Then
      Close Cur_;
      Return 1;
    Else
      Close Cur_;
    End If;
  
    Open Cur_ For
      Select t.Planner_Buyer
        From Inventory_Part_Tab t
       Inner Join A00709 T1 --Bl_Planner_Group T1  modify fjp 2012-12-12
          On T1.Contract = t.Contract
         And T1.Planner_Buyer = t.Planner_Buyer
         And T1.A007_Id = User_Id_
       Where t.Contract = Contract_
         And t.Part_No = Part_No_;
    Fetch Cur_
      Into Planner_;
    If Cur_%Found Then
      Close Cur_;
      Return '1';
    Else
      Close Cur_;
    End If;
  
    Return '0';
  Exception
    When Others Then
      Return 0;
    
  End;

  Function Checkcustomer(User_Id_ In Varchar2,
                         ---用户-- 
                         Customer_No_ In Varchar2,
                         --数据 
                         Contract_ In Varchar2) Return Number Is
    Cur_  t_Cursor;
    User_ Varchar2(100);
  Begin
    /*
       sql 语句写法    
    And Exists (Select 1 From A00705 a Where a.A007_Id = '[USER_ID]'  And a.Contract = {视图的列} AND a.Customerno ={视图的列})  
         )          
      */
    If User_Id_ = 'ADMIN' Then
      Return 1;
    End If;
  
    --检查用户的域权限
    --  if checkCONTRACT(user_id_,CONTRACT_) = 0 then      
    --  return  0;
    --end if ;
  
    Open Cur_ For
    /*    Select a.Userid
                                                                                                                                                                                                From A007 b, Bl_Usercust a
                                                                                                                                                                                               Where a.Userid = b.Bl_Userid
                                                                                                                                                                                                 And a.Customerno = Customer_No_
                                                                                                                                                                                                 And a.Contract = Contract_
                                                                                                                                                                                                 And b.A007_Id = User_Id_
                                                                                                                                                                                                 And Rownum = 1;--modify fjp 2012-12-13*/
      Select t.A007_Id
        From A00705 t
       Where t.A007_Id = User_Id_
         And t.Customerno = Customer_No_
         And t.Contract = Contract_
         And Rownum = 1;
    Fetch Cur_
      Into User_;
    If Cur_%Found Then
      Close Cur_;
      Return 1;
    End If;
    Close Cur_;
  
    Return 0;
  End;
  --检测用户供应商权限
  Function Checksupplier(User_Id_ In Varchar2,
                         ---用户-- 
                         Vonder_No_ In Varchar2,
                         --数据 
                         Contract_ In Varchar2) Return Number Is
    Ll_Count_ Number;
  Begin
    /*
        sql 语句写法    
    And Exists (Select 1 From A00704 a Where a.A007_Id = '[USER_ID]'  And a.Contract = {视图的列} )  
    And ( (not exists (Select 1 From A00706 A1 Where A1.A007_Id = '[USER_ID]' AND A1.CONTRACT ={视图的列}))
          Or (Exists ( Select 1 From A00706 A2 Where A2.A007_Id = '[USER_ID]'  And A2.CONTRACT = {视图的列} And A2.Vendor_No = {视图的列})) 
        )          
       */
  
    Select Count(*)
      Into Ll_Count_
      From A00704 t
     Where t.A007_Id = User_Id_
       And t.Contract = Contract_
       And Rownum = 1;
    If Ll_Count_ > 0 Then
      --存在域的权限
      -- 检测用户在供应商权限中是否存在
      Select Count(*)
        Into Ll_Count_
        From A00706
       Where A007_Id = User_Id_
         And Contract = Contract_
         And Rownum = 1;
      If Ll_Count_ > 0 Then
        -- 如果存在检测这个用户是否有此供应商的权限
        Select Count(*)
          Into Ll_Count_
          From A00706
         Where A007_Id = User_Id_
           And Contract = Contract_
           And Vendor_No = Vonder_No_
           And Rownum = 1;
        If Ll_Count_ > 0 Then
          Return 1;
        Else
          Return 0;
        End If;
      Else
        Return 1;
      End If;
    Else
      Return 0;
    End If;
    Return '0';
  End;
  --检查用户的域权限   
  --modify fjp 2012-12-12 修改表A00704                      
  Function Checkcontract(User_Id_ In Varchar2, Contract_ In Varchar2)
    Return Number Is
    Cur_  t_Cursor;
    User_ Varchar2(100);
  Begin
    /*
     sql 语句写法    
     AND  t.CONTRACT in (select a.Contract from  a00704 a where a.a007_id='[USER_ID]')   
    */
  
    Open Cur_ For
    /*      Select t.Userid
                                                                                                                                                                                                From Bl_Usecon t, A007 T1
                                                                                                                                                                                               Where T1.Bl_Userid = t.Userid
                                                                                                                                                                                                 And T1.A007_Id = User_Id_
                                                                                                                                                                                                 And t.Contract = Contract_;*/
    --2012-12-12 fjp    
      Select t.A007_Id
        From A00704 t
       Where A007_Id = User_Id_
         And Contract = Contract_;
    Fetch Cur_
      Into User_;
    If Cur_%Found Then
      Close Cur_;
      Return 1;
    End If;
    Close Cur_;
    Return 0;
  End;
  --检测域 销售件 和 客户协议的存在性
  Function Check_Agreement_Part(Contract_     In Varchar2,
                                Catalog_No_   In Varchar2,
                                Agreement_Id_ In Varchar2) Return Number Is
    Cur_    t_Cursor;
    Result_ Number;
  Begin
    /*
    
    exists( select 0 from dual where nvl('[MAIN_AGREEMENT_ID]','-') = '-' union  Select 1 From Agreement_Sales_Part_Deal_Tab a   Where a.Agreement_Id = '[MAIN_AGREEMENT_ID]'  And a.Catalog_No = t.Catalog_No And a.Contract = t.Contract )
    
    */
    If Nvl(Agreement_Id_, '-') = '-' Then
      Return '1';
    End If;
    Open Cur_ For
      Select 1
        From Agreement_Sales_Part_Deal_Tab t
       Where t.Agreement_Id = Agreement_Id_
         And t.Catalog_No = Catalog_No_
         And t.Contract = Contract_;
    Fetch Cur_
      Into Result_;
    If Cur_%Found Then
      Close Cur_;
      Return 1;
    Else
      Close Cur_;
    End If;
    Return 0;
  
  End;

  --获取用户的默认域
  Function Get_Default_Contract(User_Id_ In Varchar2) Return Varchar2 Is
    Cur_  t_Cursor;
    User_ Varchar2(100);
  Begin
    Open Cur_ For
      Select Contract
        From A00704 t
       Where A007_Id = User_Id_
         And t.Flag = '1';
    Fetch Cur_
      Into User_;
    If Cur_%Found Then
      Close Cur_;
      Return User_;
    End If;
    Close Cur_;
    Return Null;
  
  End;

End Pkg_Attr;
/
