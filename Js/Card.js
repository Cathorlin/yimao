// JScript 文件

/*获取卡号*/
function ReadCardNum(objectid)
{
    var   SeraCtr = document.getElementById(objectid);
	  if (SeraCtr == null)
	  {
	      return  "-1";
      }
        try
        {
	            if(SeraCtr.isOnline()!= 0)
	            {
	               alert("请将您的手机通宝读头插入计算机!");
	               return "-1" ;
	            }
        }
        catch(err)
        {
	           alert("您有中国移动手机通宝控件没有成功安装，请允许安装控件！");
	           return "-1";
        }
	     v="";
        try
        {
           v = Trim(SeraCtr.getCardInfo());	
            if (v.length < 5)
            {
                  alert("获取卡的信息失败！")
		          return "-1";
            }
        }
	    catch(err)
	    {
	         alert("获取卡的信息失败！" + err.description )
		     return "-1";
	    }
        return v;
}


