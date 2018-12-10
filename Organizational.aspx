
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Organizational.aspx.cs" Inherits="Organizational" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">





<html>

<head>
  <meta http-equiv="X-UA-Compatible" content="IE=8">
  <meta http-equiv=Content-Type content="text/html;charset=utf-8">


  <meta http-equiv="X-UA-Compatible" content="IE=9">

<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=IE9">

<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />

<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
  <meta http-equiv="X-UA-Compatible" content="IE=8;IE=7;IE=9;IE=Edge">

  <title>组织架构图</title>

    <link rel="stylesheet" href="css/style.css" media="screen" type="text/css" />

    <script src="js/modernizr.js"></script>

</head>

<body style="width:100%; height:100%; border:1px solid #cccccc;">

  <div class="content" style="margin-left:50px;">


   <figure class="org-chart cf" >
      <div class="board ">
         <ul style="margin-left:-65px; height:80px; margin-top:18px;  border-radius:15px; background-color:#ee7942; width:160px; ">
            <li>
              
               <strong style="margin-left:28px; height:78px; line-height:78px; vertical-align:middle;">TMK Director</strong>
          
          
            </li>
            <li style="margin-top:16px; height:22px;">
            <a style="border-left:2px solid #9f79ee;   margin-left:75px;"></a>
            <a style="border-top:2px solid #9f79ee; width:534px; margin-left:-199px; display:block; height:100px;"></a>
            <a style="border-left:2px solid #9f79ee; margin-top:-100px;  margin-left:-201px; display:block; height:20px;"></a>
             <a style="border-right:2px solid #9f79ee; margin-top:-20px;  margin-right:-175px; display:block; height:20px;"></a>
            </li>
         </ul>
         <ul class="columnTwo" style="margin-bottom:25px;">
            <li style="margin-top:-67px;">
               <span style="height:60px; border:0px; margin-left:-275px; width:150px; background-color:#ee7942;    line-height:50px; border-radius:15px;">
               <strong>Supporting</strong>
            <strong>(<%=count_Supporting %>)</strong>
               
               </span>
               
            </li>
            <li style="margin-top:-67px;">
               <span style="height:60px; width:150px; border:0px; margin-left:95px; background-color:#ee7942;  line-height:50px; border-radius:15px;">
               <strong>Operation</strong>
            <strong>(<%=count_Operation %>)</strong>
               </span> 
            </li>
         </ul>
      </div>
      <ul class="departments ">
         <li class="department" >
            <span class="lvl-b" style="background-color:#ffdead;">
            <strong>HR</strong>
            <strong>(<%=count_HR %>)</strong>
            </span> 
          
                <ul class="sections">
               <%for (int i = 0; i < dt_table_hr.Rows.Count; i++)
                 {
                     string h006_name = dt_table_hr.Rows[i]["H006_NAME"].ToString();
                     %>
               <li class="section"> <span>
                  <strong><%=h006_name%></strong>
                  </span> 
               </li>
               <%} %>
            </ul> 
         </li>

          <li class="department">
            <span class="lvl-b" style="background-color:#ffdead;">
            <strong>OA</strong>
            <strong>(<%=count_OA%>)</strong>
              
               
            </span> 
            <ul class="sections">
               <%for (int i = 0; i < dt_table_oa.Rows.Count; i++)
                 {
                     string h006_name = dt_table_oa.Rows[i]["H006_NAME"].ToString();
                     %>
               <li class="section"> <span>
                  <strong><%=h006_name%></strong>
                  </span> 
               </li>
               <%} %>
            </ul> 
         </li>

          <li class="department">
            <span class="lvl-b" style="background-color:#ffdead;">
            <strong>QA</strong>
            <strong>(<%=count_QA %>)</strong>
            </span> 
            <ul class="sections">
               <%for (int i = 0; i < dt_table_qa.Rows.Count; i++)
                 {
                     string h006_name = dt_table_qa.Rows[i]["H006_NAME"].ToString();
                     %>
               <li class="section"> <span>
                  <strong><%=h006_name%></strong>
                  </span> 
               </li>
               <%} %>
            </ul> 
         </li>
       
        <li class="department">
            <span class="lvl-b" style="background-color:#ffdead;" >
 
             <strong>Training</strong>
            <strong>(<%=count_Training %>)</strong>
            </span> 
            <ul class="sections">
               <%for (int i = 0; i < dt_table_tr.Rows.Count; i++)
                 {
                     string h006_name = dt_table_tr.Rows[i]["H006_NAME"].ToString();
                     %>
               <li class="section"> <span>
                  <strong><%=h006_name%></strong>
                  </span> 
               </li>
               <%} %>
            </ul> 
         </li>
         <!--<li class="department central"  style="float:left;"> -->
           <li class="department">
            <span class="lvl-b" style="background-color:#ffdead;" >
 
            <strong>IB</strong>
            <strong>(<%=count_IB %>)</strong>
            </span> 
             <ul class="sections">
               <%for (int i = 0; i < dt_table_ib.Rows.Count; i++)
                 {
                     string h006_name = dt_table_ib.Rows[i]["H006_NAME"].ToString();
                     %>
               <li class="section"> <span>
                  <strong><%=h006_name%></strong>
                  </span> 
               </li>
               <%} %>
            </ul> 
         </li>
        
         <ul class="part">
           <li class="department">
            <span class="lvl-b" style="background-color:#ffdead;"   >
 
             <strong>BJ</strong>
            <strong>(<%=count_BJ %>)</strong>
            </span> 
            <ul class="sections">
               <%for (int i = 0; i < dt_table_bj.Rows.Count; i++)
                 {
                     string h006_name = dt_table_bj.Rows[i]["H006_NAME"].ToString();
                     %>
               <li class="section"> <span>
                  <strong><%=h006_name%></strong>
                  </span> 
               </li>
               <%} %>
            </ul> 
               </li>
            
         

          <li class="department">
            <span class="lvl-b" style="background-color:#ffdead;">
            <strong>SH</strong>
            <strong>(<%=count_SH %>)</strong>
            </span> 
             <ul class="sections">

           
               <%for (int i = 0; i < dt_table_sh.Rows.Count; i++)
                 {
                     string h006_name = dt_table_sh.Rows[i]["H006_NAME"].ToString();
                     %>
               <li class="section"> <span>
                  <strong><%=h006_name%></strong>
                  </span> 
               </li>
               <%} %>
            </ul> 
         </li>

      <li class="department" style="margin-left:794px;  margin-top:-620px;">
            <span class="lvl-b" style="background-color:#ffdead;">
            <strong>GZ</strong>
            <strong>(<%=count_GZ %>)</strong>
              
               
            </span> 
            <ul class="sections">
               <%for (int i = 0; i < dt_table_gz.Rows.Count; i++)
                 {
                     string h006_name = dt_table_gz.Rows[i]["H006_NAME"].ToString();
                     %>
               <li class="section"> <span>
                  <strong><%=h006_name%></strong>
                  </span> 
               </li>
               <%} %>
            </ul> 
         
         </li>
       <li class="department"  style= "float:left; margin-left:907px; margin-top:-620px;">
            <span class="lvl-b" style="background-color:#ffdead;">
            <strong>SZ</strong>
            <strong>(<%=count_SZ %>)</strong>
              
               
            </span> 
            <ul class="sections">
               <li class="section">
                <span style="left:51px; background:#cccccc;">
                  <strong  >CD</strong>
                   <strong>(<%=count_CD %>)</strong>
                  </span> 
               </li>
               <li class="section"> <span style="left:51px; background:#cccccc;">
                  <strong>XA</strong>
                   <strong>(<%=count_XA %>)</strong>
                  </span> 
               </li>
               <li class="section"> <span style="left:51px; background:#cccccc;">
                  <strong>DG</strong>
                   <strong>(<%=count_DG %>)</strong>
                  </span> 
               </li>
               <li class="section"> <span style="left:51px; background:#cccccc;">
                  <strong>CQ</strong>
                  <strong>(<%=count_CQ %>)</strong>
                  </span> 
               </li>
               <li class="section">
                <span style="left:51px; background:#cccccc;">
                  <strong >WH</strong>
                   <strong>(<%=count_WH %>)</strong>
                  </span> 
               </li>
            </ul>
         </li>
     
         <li class="department"  style="margin-left:1020px; margin-top:-620px;">
            <span class="lvl-b" style="background-color:#ffdead;">
            <strong>MiNi</strong>
            <strong>(<%=count_Mini %>)</strong>
              
               
            </span> 
            <ul class="sections">
               <li class="section"> <span style="left:70px; background:#cccccc;">
                  <strong>HZ</strong>
                   <strong>(<%=count_HZ %>)</strong>
                  </span> 
               </li>
               <li class="section"> <span style="left:70px; background:#cccccc;">
                  <strong>NJ</strong>
                   <strong>(<%=count_NJ %>)</strong>
                  </span> 
               </li>
               <li class="section"> <span style="left:70px; background:#cccccc;">
                  <strong>WX</strong>
                   <strong>(<%=count_WX %>)</strong>
                  </span> 
               </li>
               <li class="section"> <span style="left:70px; background:#cccccc;">
                  <strong>NB</strong>
                   <strong>(<%=count_NB %>)</strong>
                  </span> 
               </li>
               <li class="section"> <span style="left:70px; background:#cccccc;">
                  <strong>FS</strong>
                   <strong>(<%=count_FS %>)</strong>
                  </span> 
               </li>
            </ul>
         </li>
              </ul>
        </ul>
   </figure>
 
 
</div>

  <script src="js/jquery.min.js"></script>

</body>

</html>