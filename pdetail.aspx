<%@ Page Language="C#" AutoEventWireup="true" CodeFile="pdetail.aspx.cs" Inherits="lubang_pdetail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=gbk" />
    <meta http-equiv="X-UA-Compatible" content="IE=8, IE=9, IE=10" />
    <meta name="description" content="·����">
    <meta name="keywords " content="·����">
    <meta name="robots" content="all">
    <link type="text/css" href="<%=http_url %>/CSSLUBANG/pdetail.css" rel="Stylesheet" />
    <link href="ueditor1_4_2-gbk-net/themes/default/css/umeditor.css" type="text/css"  rel="stylesheet">
    <script type="text/javascript" src="js/jquery-1.4.1.js"></script>
    <script type="text/javascript" src="js/jquery.form.js"></script>
    <script type="text/javascript" charset="gbk" src="ueditor1_4_2-gbk-net/ueditor.config.js"></script>
    <script type="text/javascript" charset="gbk" src="ueditor1_4_2-gbk-net/ueditor.all.min.js"> </script>
    <!--�����ֶ��������ԣ�������ie����ʱ��Ϊ��������ʧ�ܵ��±༭������ʧ��-->
    <!--������ص������ļ��Ḳ������������Ŀ����ӵ��������ͣ���������������Ŀ�����õ���Ӣ�ģ�������ص����ģ�������������-->
    <script type="text/javascript" charset="gbk" src="ueditor1_4_2-gbk-net/lang/zh-cn/zh-cn.js"></script>
    
    <style type="text/css">
        #preview
        {
            width: 115px;
            height: 76px;
            border: 1px solid #000;
            overflow: hidden;
        }
        #imghead
        {
            filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=image);
        }
         #loader_container {
        Z-INDEX: 100; POSITION: absolute; TEXT-ALIGN: center; WIDTH: 100%; TOP: 40%; LEFT: 0px
        }
        #loader {
        Z-INDEX: 2; BORDER-BOTTOM: #5a667b 1px solid; TEXT-ALIGN: left; BORDER-LEFT: #5a667b 1px solid; 
        PADDING-BOTTOM: 16px; BACKGROUND-COLOR: #ffffff; MARGIN: 0px auto; PADDING-LEFT: 0px; WIDTH: 200px; PADDING-RIGHT: 0px;
        DISPLAY: block; FONT-FAMILY: Tahoma, Helvetica, sans; COLOR: #000000; FONT-SIZE: 11px; BORDER-TOP: #5a667b 1px solid;
        BORDER-RIGHT: #5a667b 1px solid; PADDING-TOP: 10px
        }
        #loader_bg {
        POSITION: relative; BACKGROUND-COLOR: #e4e7eb; WIDTH: 180px; HEIGHT: 7px; FONT-SIZE: 1px; TOP: 8px; LEFT: 8px
        }
        #progress {
        POSITION: relative; BACKGROUND-COLOR: #77a9e0; WIDTH: 1px; HEIGHT: 5px; FONT-SIZE: 1px; TOP: 1px; LEFT: 0px
        }
    </style>
     <script type="text/javascript">

         document.write('<div id="loader_container"><div id="loader"><div align="center" style="font-size:9pt;">ҳ�����ڼ����С���</div><div align="center"><img src="../images/loading.gif" alt="loading" /></div></div></div>');
         function remove_loading() {
             try {
                 var targelem = document.getElementById('loader_container');
                 targelem.style.display = 'none';
                 targelem.style.visibility = 'hidden';
             }
             catch (e)
        { }
         }
         function show_loading() {

             var targelem = document.getElementById('loader_container');
             if (targelem != null) {
                 targelem.style.display = '';
                 targelem.style.visibility = 'visible';
             }

         }

         // prepare the form when the DOM is ready
         $(document).ready(function () {
             remove_loading();
             var options = {
                 type: 'post',
                 url: "UploadFile.ashx",
                 beforeSubmit: showRequest,  // pre-submit callback 
                 success: showResponse  // post-submit callback                   
                 // other available options: 
                 //url:       url         // override for form's 'action' attribute 
                 //type:      type        // 'get' or 'post', override for form's 'method' attribute 
                 //dataType:  null        // 'xml', 'script', or 'json' (expected server response type) 
                 //clearForm: true        // clear all form fields after successful submit 
                 //resetForm: true        // reset the form after successful submit 

                 // $.ajax options can be used here too, for example: 
                 //timeout:   3000 
             };
            
            
             // bind to the form's submit event 
             $('form.formUpload').submit(function () {

                 // inside event callbacks 'this' is the DOM element so we first 
                 // wrap it in a jQuery object and then invoke ajaxSubmit 
                 $(this).ajaxSubmit(options);

                 // !!! Important !!! 
                 // always return false to prevent standard browser submit and page navigation 
                 return false;
             });

         });
         function showmsg(id, pic) {
             $("#img_" + id).attr("src", "images\\M00203\\" + pic);
         }
         function Send_All() {
             var str_ = encodeURIComponent(UE.getEditor('myEditor').getAllHtml());
             $("#show_html").val(str_);
             alert(str_);
             $("#txtform").submit();
         }
         // pre-submit callback 
         function showRequest(formData, jqForm, options) {
             // formData is an array; here we use $.param to convert it to a string to display it 
             // but the form plugin does this for you automatically when it submits the data 
             var queryString = $.param(formData);
             show_loading();
             // jqForm is a jQuery object encapsulating the form element.  To access the 
             // DOM element for the form do this: 
             // var formElement = jqForm[0]; 
             // alert('About to submit: \n\n' + queryString);

             // here we could return false to prevent the form from being submitted; 
             // returning anything other than false will allow the form submit to continue 
             return true;
         }

         // post-submit callback 
         function showResponse(responseText, statusText) {
             remove_loading();

             var resptxt = responseText.replace("<PRE>", "");
             resptxt = resptxt.replace("</PRE>", "");
             try {
                 if (window.execScript) {
                     window.execScript(resptxt, "JavaScript");
                 } else {
                     window.eval(resptxt);
                 }
             }
             catch (e) {
                 alert(resptxt);
             }

             // for normal html responses, the first argument to the success callback 
             // is the XMLHttpRequest object's responseText property 

             // if the ajaxSubmit method was passed an Options Object with the dataType 
             // property set to 'xml' then the first argument to the success callback 
             // is the XMLHttpRequest object's responseXML property 

             // if the ajaxSubmit method was passed an Options Object with the dataType 
             // property set to 'json' then the first argument to the success callback 
             // is the json data object returned by the server 
         } 
    </script>
</head>

<body>
   
    <div class="w_600">
        <div class="w_main">
            <ul>
                <li>
                    <div class="w_right">
                        <p style="color: Red;">
                            * ͼƬ�����ϴ�һ�ţ�����ͼƬ��С���ܳ���200K</p>
                        <div class="img_size">
                            <ul>
                                 <% for (int i = 1; i <= 5; i++)
                                {
                                    string id_ = "PICTURE";
                                    if (i > 1)
                                    {
                                        id_ = "PIC" + i.ToString();
                                    }
                                    string picname = "";
                                   
                                    if (picname == null || picname == "")
                                    {
                                        picname = "../Images/nopic.gif";
                                    }
                                    else
                                    {
                                        picname = "Images/m00203/" + picname;
                                    }
                             %>   
                <li>
                    <span style="color: Red;">ͼƬ�ߴ�310*232</span>
                    <br/>
                        <form  id="f_<%=id_ %>" name="f_<%=id_ %>" method="post"   enctype="multipart/form-data"  class="formUpload">                                     
                         <table>
                         <tr>
                         <td>
                            <img id="img_<%=id_ %>" alt="" src="<%=picname %>" width="102px" height="76px" /> 
                         </td>
                         </tr>
                         <tr>
                         <td>     
                         <input type="hidden"   name ="key" value="<%=id_ %>" />
                         <input type="hidden"   name ="mainkey" value="<%=mainkey %>" />
                         <input  type="hidden"  name="type" value="file"/>
                         <input type="file" style="width:100px;" name="file"  title="����ͼƬ�ͳ����ĵ���ʽ���ļ���󲻿��Գ���2M,ͼƬ����500kb����Ϊ��"/>
                      
                      </td> 
                     </tr>
                      <tr>
                      <td>
                       <input id="btn_<%=id_ %>" type="submit" value="�ϴ�ͼƬ" class="input_on" />
                      </td>
                      </tr>
                    </table>
                          </form>                                     
                </li> <%}
                      %>                </ul>
                        </div>
                      
                    </div>
                </li>
                <li>&nbsp;</li>
                <li>
                    <div class="w_right2">          
                         <script id="myEditor" type="text/plain" style="width:600px;height:200px;"></script>
                    </div>
                </li>
            </ul>
            <div class="w_button">
               
                 <form id="txtform" name="txtform" method="post"  enctype="multipart/form-data" class="formUpload">
                    <input  type="hidden"  name="key" value="<%=mainkey %>"/>
                    <input type="hidden"   name ="mainkey" value="<%=mainkey %>" />
                    <input  type="hidden"  name="type" value="TXT"/>
                    <input  type="hidden" id="show_html" name="show_html" value=""/>                   
                 </form>
                  <input type="button" id="sendtxt" onclick="Send_All()" value="ȷ��"/>
            </div>
        </div>
    </div>
    <div id ="output"></div>
    <script type="text/javascript">
        //ʵ�����༭��
      
       
        //��ť�Ĳ���
    </script>
</body>
</html>
