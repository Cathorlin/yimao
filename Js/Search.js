// JScript 文件
var http_url="" ;
function initQ() {
    document.getElementById("q").value  ="";

}
//改变搜索标签
//
var tabobj ; 
var target_select = "1";
var searchTips = new Array();
searchTips[0] = "";
searchTips[1] = "请输入店名、地址、菜系、折扣等...";
searchTips[2] = "请输入优惠券名、商户名、折扣等...";
function changeSearchTarget(obj, target) {
    //  alert(tabobj)
      if ( tabobj == null)
      {
          tabobj = document.getElementById("J_TSearch_1") ;
          target_select = "1";
      }
   
     //alert(obj.id)
     
     
     
      if (obj.id != tabobj.id)
      {
         obj.className = "tsearch-tabs-active"
          tabobj.className  = "none" ;
          document.getElementById("q").value =   searchTips[target];

         tabobj  = obj;
         target_select = target;
      }

    document.getElementById("q").focus() ;

}
var ib_q = false 
//触发回车
function qonfocus()
{
    ib_q = true  ;
}

//触发回车
function qonblur()
{
   ib_q = false ;
}
function SetSearchSession(tar_,keyname)
{
    var old_tar_ = VPage.getSession("search_type").value;
    var value_= VPage.getSession("search_value").value;
    var type_ =keyname.substr(0,1)
     if ( SearchList.indexOf(type_) < 0 )
     {
            SearchList +=  type_ +","            
     }
 
    var SearchList_ =SearchList.split(",")

    
    if (old_tar_ !=  tar_)
    {
        v = VPage.setSession("search_type",tar_).value; 
        value_ = "" ;
 
         for (var i=0 ;i <SearchList_.length; i++ )
         {
            if (SearchList_[i]  !=  "")
            {
                value_ +=   SearchList_[i] +"=ALL}";
            }
         }
    }
      
    var valuelist = value_.split("}");
var v_="";
    if (keyname.indexOf("S=") <0)
    {
        valuelist[0]="S=";
    }
    else
    {
       
         for (var i=1 ;i <SearchList_.length; i++ )
         {
                valuelist[i]= SearchList_[i]+ "=ALL";
         }
        
    }
     for (var i=0 ;i <SearchList_.length; i++ )
     {
        if (SearchList_[i]  !=  "")
        {
            if  (SearchList_[i] ==  type_ ) 
            {
                 v_ +=  keyname + "}"; 
            }
            else
            {
                 var vvvv = search_get_value(value_,type_,SearchList_[i]) ;
                               
                 if (type_=="M" &&  SearchList_[i] == "3")
                 {
                     vvvv = "ALL" ;     
                 }
                v_ +=  SearchList_[i] + "=" +   vvvv  + "}"; 
            }
        }
     }
    var v = VPage.setSession("search_type",tar_).value;
        v = VPage.setSession("search_value", v_).value;   

}
var SearchList="S,";
function showm004list(A022_ID,keyname)
{
     /*
    s_type  M 商户分类
            3 小类
            2 区域
            1 商圈 
    */
    var tar_ = A022_ID;
    tar_ = tar_.replace('SEARCH_SQL','')
    var number =  Math.random() * 100000; 
    var url =http_url +  "\\search.aspx?code=" +number ;
    
  
    showchildhtml(A022_ID , keyname);
    /**/
    
   // v = VPage.setSession("search_type",tar_).value;
    
   // v = VPage.setSession("search_value", "M=" + keyname).value;

//设置分类
    /*判断原来的分类 和现在的分类是否一直*/
     v = VPage.setSession("search_value_child", keyname ).value;
     SetSearchSession(tar_,"M=" + keyname);
     location.href = url;
}
function showm00401list(A022_ID,keyname)
{
    /*
    s_type  M 商户分类
            3 小类
            2 区域
            1 商圈 
    */
    var tar_ = A022_ID;
    tar_ = tar_.replace('SEARCH_SQL','')
    var number =  Math.random() * 100000; 
    var url =http_url +  "\\search.aspx?code=" +number ;
    
   // v = VPage.setSession("search_type",tar_).value;
    
   // v = VPage.setSession("search_value", "3=" + keyname).value;
    
    SetSearchSession(tar_,"3=" + keyname);
    location.href = url;
}
    function search_get_value(vale,dotype_ , type_)
    {
        //如果是查询
        if (dotype_ =="S" &&  type_ != "S" )
        {
            return "ALL";
        }
        
        var pos_ = vale.indexOf(type_ + '=');
         if (pos_  > 0)
        {
            var s_right = vale.substr(pos_ + 2)
            pos_ =  s_right.indexOf('}');
            if  (pos_ < 0)
            {
                  return "";

            }
            return  s_right.substring(0,pos_);
        }
        
        else
        {
            return "";

        }
    
    }
function showchildhtml(a022_id)
{
    if (document.getElementById("type_child") == null)
    {
        return  ;
    }
    var  search_value =  VPage.getSession("search_value").value;
    /*获取M=值*/

    var m004_key =  search_get_value(search_value,"3","M")
    if (m004_key =="0" ||  m004_key =="" || m004_key == null || m004_key =="ALL"  )
    {
        document.getElementById("type_child").style.display= "none" ;    
        return   ;
    } 

    document.getElementById("type_child").style.display= "" ;
   var dt= VPage.getM00401(m004_key).value;
   var html_  =  "";
       html_ += "<div class=\"search_style\">";
        html_ += "<ul>";
       html_ += "<li>";
       html_ += "<a onclick=\"showm00401list('"+ a022_id +"','ALL')\">";
       if ( search_value.indexOf( "3=ALL") >=0 || search_value.indexOf("3=") < 0 )
       {
           html_ += "<span style=\"color: #ff6600;\">全部</span>";
       }
       else
       {
           html_ += "全部"; 
        }
       html_ += "</a>";
       html_ += "</li>";
    
       search_value = VPage.getSession("search_value").value;
     
       for(var i = 0 ;i< dt.Rows.length; i++)
       {
             html_ += "<li>";
             html_ += "<a onclick=\"showm00401list('" + a022_id + "','"+ dt.Rows[i]["M00401_NAME"] +"')\">";
             if ( search_value.indexOf( "3=" + dt.Rows[i]["M00401_NAME"]) >=0)
             {
                 html_ += "<span style=\"color:#ff6600;\">" + dt.Rows[i]["M00401_NAME"] +"</span>";
             }
             else
             {
                 html_ +=dt.Rows[i]["M00401_NAME"] ;
             }
             html_ += "</a>";
             html_ += "</li>";
         }
      html_ += "</ul>";
      html_ +="</div>" 
     document.getElementById("td_show_child").innerHTML= html_ ;
    // alert(html_)
              
}
function  showm00401(A022_ID,m004_key, keyname)
{
    var tar_ = A022_ID;
    tar_ = tar_.replace('SEARCH_SQL','')
    var number =  Math.random() * 100000; 
    var url =http_url +  "\\search.aspx?code=" +number ;
    var v= VPage.setSession("search_value", "S=}M="+ m004_key+"}3="+keyname+"}").value;
        v = VPage.setSession("search_type",tar_).value;
    location.href = url;


}

function showm002list(A022_ID,keyname,s_type)
{
/*
s_type  M 商户分类
        3 小类
        2 区域
        1 商圈 
*/


    var tar_ = A022_ID;
    tar_ = tar_.replace('SEARCH_SQL','')
    var number =  Math.random() * 100000; 
    var url =http_url +  "\\search.aspx?code=" +number ;
   // v = VPage.setSession("search_type",tar_).value;
    
   //v = VPage.setSession("search_value", s_type + "=" + keyname).value;

    v = VPage.setSession("search_value_child", "0" ).value;
    SetSearchSession(tar_,s_type + "=" + keyname);
    location.href = url;
}
//触发回车
function submitSearch()
{
    var vvv = document.getElementById("q").value;
    if ( vvv == "" || vvv == searchTips[target_select]  )
    {
        // alert("请输入查询条件")        
        return false ;
    }
    var number =  Math.random() * 100000; 
    var url =http_url +  "\\search.aspx?code=" +number ;
//    v = VPage.setSession("search_type",target_select).value;
    
  //  v = VPage.setSession("search_value","S="+vvv).value;
    SetSearchSession(target_select,"S="+vvv);
    location.href = url;

}
function getkeyenter()
{   
    if(event.keyCode==13){
       submitSearch() ;
        
        
    }

}