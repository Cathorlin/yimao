// JScript 文件
function getM00203Html(dt_m00203)
{
    var html_ = "<div id=\"m00203\">";
    html_ += "<div class=\"listm00203\">";
    html_ += "<ul>";
    for (var i = 0; i < dt_m00203.Rows.Count; i++)
    {
       //连接的url
      var li_url = http_url + "/" + dt_m00203.Rows[i]["LI_URL"];
      //图片路径
      var pic = http_url + "/images/" + dt_m00203.Rows[i]["PIC"];
      //
      var dp_url = http_url + "/" + dt_m00203.Rows[i]["DP_URL"];

      var dp_count =  dt_m00203.Rows[i]["dp_count"];

      var des = dt_m00203.Rows[i]["des"];
      var m002_name = dt_m00203.Rows[i]["m002_name"];
      var  name = dt_m00203.Rows[i]["name"];
      html_ +="<li id=\"li_m00203_"+ i+"\">";
      html_ +="<div class=\"showrow\">";
      html_ +="<div class=\"pic\">";
      html_ += "<a href=\""+ li_url+ "\" target=_blank>";
      html_ += "<img src=\""+ pic +"\"/></a>";
      html_ +="</div>";
      html_ +="<div class=\"txt\">"
      html_ +="<div class=\"nm1\">"; 
      html_ += name +"<a> 所有者："+ m002_name +"</a>"; 
      html_ +="</div>";  
      html_ +="<div class= \"dp\">"; 
      html_ +="<a href=\""+ dp_url+"\" target=_blank> 点评</a>"
      html_ +="<span><%=dp_count %>条</span>"
      html_ +="</div> "
      html_ +="<div class=\"nm3\">"
      html_ +=des;
      html_ +="</div>"
      html_ +="</div>"
      html_ +="</div>"
      html_ +="</li>"
      
      
    }
     html_ +="</ul>"
     html_ +="</div>"
     html_ +="</div>"
     alert(html_)
}


/*


 
 
 
<%}
%>
</ul>
</div>
<div id="li_m00203__Page">
</div>   
<script language=javascript> dpPage('li_m00203_',1,'<%=dt_a022.Rows[0]["PAGEROWS"].ToString()%>','<%=dt_m00203.Rows.Count %>'); </script>


</div>
<%} %>
*/