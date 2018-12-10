<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ColumnStacked.aspx.cs" Inherits="ShowForm_ColumnStacked" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>Highcharts Example</title>		
		<!-- 1. Add these JavaScript inclusions in the head of your page -->
		<script type="text/javascript" src="../js/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="../js/highcharts.js"></script>
         <script type="text/javascript" src="../js/DivWindow.js"></script>
    <link   href ="../Css/DivWindow.css"  rel="stylesheet"  type="text/css" />
		<!--[if IE]>
			<script type="text/javascript" src="../js/excanvas.compiled.js"></script>
		<![endif]-->				
		<!-- 2. Add the JavaScript to initialize the chart on document ready -->
		<script type="text/javascript">


        <%
        string x_sql =dt_a061.Rows[0]["X_SQL"].ToString().Replace("[KEY]",KEY) ;
        string y_sql =dt_a061.Rows[0]["Y_SQL"].ToString().Replace("[KEY]",KEY) ;
        string d_sql =dt_a061.Rows[0]["D_SQL"].ToString().Replace("[KEY]",KEY) ;
        string title_sql= dt_a061.Rows[0]["title_sql"].ToString().Replace("[KEY]",KEY) ;
        dt_x = Fun.getDtBySql(x_sql);
        //获取要统计的列
        dt_y = Fun.getDtBySql(y_sql);
       
        dt_data = Fun.getDtBySql(d_sql);       
        
        dt_title =   Fun.getDtBySql(title_sql);   
        String    str_space="		  ";
        string y_title = dt_title.Rows[0]["y_title"].ToString();
        string x_title =dt_title.Rows[0]["x_title"].ToString() ;
        string title =  dt_title.Rows[0]["title"].ToString();
        %>
         
    	 var chart;
         var str_x = new Array();
         var array_d = new  Array();
         var str_y_avg = new Array();
 	    $(document).ready(function () {
            var str_d ="";
            var str_data ="";           
            <%
             for (int i = 0; i <  dt_x.Rows.Count ; i++) {            
		       Response.Write (str_space+ "str_x["+ i.ToString() +"] = \""+ dt_x.Rows[i][0].ToString()+"\";");
               Response.Write(Environment.NewLine);
             }
            
            %>
            
            <%
              Response.Write(Environment.NewLine); 
              if (dt_y.Columns.Count > 2)
              {
                 for (int j = 0; j <  dt_y.Rows.Count ; j++) 
                 {
                        Response.Write(Environment.NewLine);  
                        Response.Write (str_space+ " str_y_avg["+j.ToString()+"] = new Array();");
                        Response.Write(Environment.NewLine);  
                        Response.Write (str_space+ " str_y_avg["+j.ToString()+"][0] = '"+dt_y.Rows[j][0].ToString() +"';");
                        Response.Write(Environment.NewLine);  
                        Response.Write (str_space+ " str_y_avg["+j.ToString()+"][1] = '"+dt_y.Rows[j][2].ToString() +"';"); 
                        Response.Write(Environment.NewLine);   
                        Response.Write (str_space+ " str_y_avg["+j.ToString()+"][2] = '"+dt_y.Rows[j][3].ToString() +"';");   
                }                
             }
             for (int i = 0; i <  dt_y.Rows.Count ; i++) { 
                string y =  dt_y.Rows[i][0].ToString();
                Response.Write(Environment.NewLine);
                Response.Write (str_space+ "var str_data"+i.ToString()+" = new Array();");
                Response.Write(Environment.NewLine); 
                for (int j = 0; j <  dt_x.Rows.Count ; j++) { 
                   string d = "0";
                   string x =  dt_x.Rows[j][0].ToString();
                   for(int k=0 ; k < dt_data.Rows.Count;k++ )
                   {
                         string str_x = dt_data.Rows[k]["x"].ToString();
                         string str_y = dt_data.Rows[k]["y"].ToString();
                         if  (str_x ==  x &&  str_y ==  y) 
                         {
                            d = dt_data.Rows[k]["d"].ToString();
                            break;
                         }
                   }
                   Response.Write (str_space+ "str_data"+i.ToString()+"["+j.ToString()+"] ="+d+";");       
                   Response.Write(Environment.NewLine);
                }
                //string type = ""
              %> 	
                  array_d[<%=i.ToString() %>] ={
                           type: '<%=dt_y.Rows[i][1].ToString() %>',
                           name: "<%=dt_y.Rows[i][0].ToString() %>",
                           data: str_data<%=i.ToString() %>,                           
                     dataLabels:{
						        enabled: true,
						        rotation: -90,
						        color: '#FFFFFF',
						        align: 'right',
						        x: -3,
						        y: 10,
						        formatter: function() {
							        return this.y;
						        },
						        style: {
							        font: 'normal 13px Verdana, sans-serif'
						        }
                                 }
                               }  ;    
             <%   
                Response.Write(Environment.NewLine);
             }
            %>
		            chart = new Highcharts.Chart({
		                chart: {
		                    renderTo: 'container',
		                    defaultSeriesType: 'column'
		                },
		                title: {
		                    text: '<%=title %>'
		                },
		                xAxis: {
		                    categories: str_x,
                             title: {
		                        text: '<%=x_title %>',
                                align:'high'   
                                }
		                },
		                yAxis: {
		                 
		                    title: {
		                        text: '<%=y_title %>',
                                align:'high'                               
		                    }

		                },
		                legend: {
		                    style: {
		                        left: 'auto',
		                        bottom: 'auto',
		                        right: '70px',
		                        top: '35px'
		                    },

		                    backgroundColor: '#FFFFFF',
		                    borderColor: '#CCC',
		                    borderWidth: 1,
		                    shadow: true

		                },
		                tooltip: {
		                    formatter: function () {
		                        return '<b>' + this.x + '</b><br/>' +
							 this.series.name + ': ' + this.y + '<br/>';

		                    }
		                },
                        credits: {
					    enabled: false
				        },
		                plotOptions: {		                   
		                    bar: {
                                dataLabels: {
							    enabled: true,
							    color: 'auto'
						     }
					       },
                         column: {
                              events: {
                              click: function(e) {
                                   // alert(e.point.category);
                                   showchild(e.point);
                              }
                              }}

		                },
		                series:array_d
		            });
   		        });
                function showchild(obj_)
                {
                <% if ( dt_y.Columns.Count  <= 3)
                {
                 %>
                    return ;
                <%}
                 %>
                    var vdiv =   new DivWindow('popup','popup_drag','popup_exit','exitButton','700','500',999999);
                    requestData(obj_);    
                               
                }
                function requestData(obj_) { 
                   var child_array_d = new Array();
                   var name_ = obj_.series.name;
                   for(var i=0; i < array_d.length;i++)
                   {
                       if (array_d[i].name== name_)
                       {
                            child_array_d[child_array_d.length] = array_d[i];
                       }
                    
                   }
                   for(var i=0 ;i < str_y_avg.length; i++)
                   {
                       if (str_y_avg[i][0]== name_)
                       {
                            var str_ = new Array();
                            for(var j=0;j< str_x.length;j++)
                            {
                              str_[j] = parseFloat( str_y_avg[i][1]);

                            }
                             child_array_d[child_array_d.length] ={
                                type: str_y_avg[i][2],
                                name: "标准",
                                data: str_,                           
                                dataLabels:{
						            enabled: true,
						            rotation: -90,
						            color: '#FFFFFF',
						            align: 'right',
						            x: -3,
						            y: 10,
						            formatter: function() {
							            return this.y;
						            },
						            style: {
							            font: 'normal 13px Verdana, sans-serif'
						            }
                                 }
                               }  ; 
                            break;
                       }
                   
                   }
                  var  childchart = new Highcharts.Chart({
		                chart: {
		                    renderTo: 'conchild',
		                    defaultSeriesType: 'column'
		                },
		                title: {
		                    text: obj_.series.name
		                },
		                xAxis: {
		                    categories: str_x,
                             title: {
		                        text: '22222',
                                align:'high'   
                                }
		                },
		                yAxis: {
		                    min: 0,
		                    title: {
		                        text: '33333',
                                align:'high'                               
		                    }

		                },
		                legend: {
		                    style: {
		                        left: 'auto',
		                        bottom: 'auto',
		                        right: '70px',
		                        top: '35px'
		                    },

		                    backgroundColor: '#FFFFFF',
		                    borderColor: '#CCC',
		                    borderWidth: 1,
		                    shadow: true

		                },
		                tooltip: {
		                    formatter: function () {
		                        return '<b>' + this.x + '</b><br/>' +
							 this.series.name + ': ' + this.y + '<br/>';

		                    }
		                },
                        credits: {
					    enabled: false
				        },
		                plotOptions: {		                   
		                    bar: {
                                dataLabels: {
							    enabled: true,
							    color: 'auto'
						     }
					       }

		                },
		                series:child_array_d 
		            });
                    return;
                } 
		</script>
<script type="text/javascript" src="../js/highslide-full.min.js"></script>
<script type="text/javascript" src="../js/highslide.config.js" charset="utf-8"></script>
<link rel="stylesheet" type="text/css" href="../Css/highslide.css" />
</head>
<body scroll=yes>

	<form id="form1" runat="server">
    <div>
    <%
    string width = dt_a061.Rows[0]["width"].ToString();
    if (width == null || width == "0")
    {

        Response.Write("<div id=\"container\" style=\"width:100%; height: 100%; margin: 0 auto\"></div>");
    }
    else
    {
        if (int.Parse(width) > ((dt_y.Rows.Count * 20 + (dt_y.Rows.Count - 1) * 5) * dt_x.Rows.Count))
        {
            width = ((dt_y.Rows.Count * 20 + (dt_y.Rows.Count - 1) * 5) * dt_x.Rows.Count).ToString();
        }
        else
        {
            width = ((dt_y.Rows.Count * 20 + (dt_y.Rows.Count - 1) * 5) * dt_x.Rows.Count).ToString();
        }
        Response.Write("<div id=\"container\" style=\"width:" + width + "px; height: 100%; margin: 0 auto\"></div>");

    }
     %>
<div style="visibility: hidden; display: none;">
 <input type="button"  id="show"   value='点击弹出窗口'   />
 <input type="button"  id="exitButton"   value="aaaa" />
</div>
     <!-- 遮罩层 -->
    <div id="mask"  class="mask"></div>
    <!-- 弹出基本资料详细DIV层 -->
<div class="sample_popup"     id="popup" style="visibility: hidden; display: none;">
<div class="menu_form_header" id="popup_drag">
 <input type="button"  id="popup_exit" value="退出" />
</div>
<div class="menu_form_body" >
 <div id="conchild" style="width:700px;height:400px;"> 
 </div>
</div>
</div>
    </div>
    </form>
				
	</body>
</html>