using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
///User 的摘要说明
/// </summary>
public class User
{

    private string loginID;
    public string LoginID
    {
        get { return loginID; }
        set { loginID = value; }
    }

    private string pwd;
    public string Pwd
    {
        get { return pwd; }
        set { pwd = value; }
    }
	public User()
	{
		//
		//TODO: 在此处添加构造函数逻辑//


       
	}
}