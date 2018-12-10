<%@ Page Language="C#" AutoEventWireup="true" CodeFile="main.aspx.cs" Inherits="EXAM_main" %>
<%
    string Q004ID = "100005";
    string sql ="Select t.* from Q004_V01 t where t.Q004_ID='"+Q004ID+"'";
    dt_Q004 = Fun.getDtBySql(sql);
    sql = "Select t.* from Q005 t where t.Q005_ID='" + user_id + "'";
    dt_Q005  = Fun.getDtBySql(sql);
    string type_id_0 = dt_Q004.Rows[0]["TYPE_ID"].ToString(); //试卷分类
    string title = dt_Q004.Rows[0]["Q004_NAME"].ToString();//试题标题
    string tgtitle = dt_Q004.Rows[0]["COL02"].ToString(); //提供人
    string per_count = dt_Q004.Rows[0]["per_count"].ToString(); //参加考试人数
    string test_score = dt_Q004.Rows[0]["SCORE"].ToString(); //"100";//考试分数
    string max_score =  dt_Q004.Rows[0]["max_score"].ToString(); //最高分
    string score_time = dt_Q004.Rows[0]["testtimes"].ToString();//分钟数 

   //试卷信息 dt_Q004 =
    //用户信息   dt_Q005 =
  
    sql = "Select t.* from Q00401_V01 t where t.Q004_ID='" + Q004ID + "' order by t.sort_by,t.line_no";
    dt_Q00401 = Fun.getDtBySql(sql);

    
    
    sql = "Select t.* from Q10301_V01 t where  t.q004_id='" + Q004ID + "' and t.q005_id='" + dt_Q005.Rows[0]["Q005_ID"].ToString() + "' order by t.line_no ";
    dt_Q10301 = Fun.getDtBySql(sql);
    if (dt_Q10301.Rows.Count == 0)
    {
        string exec_sql = "Q103_api.set_q103('" + Q004ID + "','" + user_id + "','" + user_id + "','[A311_KEY]')";
        string ls_exec = Fun.execSql(exec_sql, user_id, "EXAM_Q103");
        sql = "Select t.* from Q10301_V01 t where  t.q004_id='" + Q004ID + "' and t.q005_id='" + dt_Q005.Rows[0]["Q005_ID"].ToString() + "' order by t.line_no ";
        dt_Q10301 = Fun.getDtBySql(sql);
    }
    
     %>
   
<div class="h63">
</div>
 <div class="width960">
    <div class="h15">
    </div>
    <div class="testing_position">
        你当前位置：<a href="<%=http_url%>/EXAM/index.aspx" target="_blank">首页</a>
        >><a href="javascript:void(0);"><%=type_id_0%></a>      
   
    </div>
    <div class="h15">
    </div>
    <div class="Ksbody" id="Header" style="display: none; width: 0px;">
    </div>
            <!--timefixed结束-->
    <div class="testing_content">
     <div class="title">
      <h4>
               <span id="lblpapername"><%=title%></span></h4>
      </div>
     <div class="h15">
     </div>
      <div class="content" style="border: 0px;">
       <div class="content_title">
             试题提供：<%=tgtitle%>&nbsp;&nbsp;&nbsp;&nbsp;已经有&nbsp;<span class="orange">
             <span id="LbCanKaoRenShu"><%=per_count%></span>人</span>&nbsp;做过此试卷&nbsp;&nbsp;&nbsp;&nbsp;
        </div>
        <div class="h15">
                    </div>
                    <div class="papers_illustrate">
                        <div class="illustrate_t">
                            试卷说明：
                        </div>
                        <div class="illustrate_c">
                            <ul>
                                <li>卷面总分：<span class="orange bold"><%=test_score%></span>分</li>
                                <li>最高分数：<span class="orange bold"><span id="LbMaxScore"><%=max_score%></span></span>分</li>
                                <li>答题时间：<span class="orange bold"><%=score_time%></span>分钟</li> 
                                
                            </ul>
                        </div>
                    </div>
                    <div class="h25">
                    </div>                   
                    <input type="hidden" name="hdTimeBegin" id="hdTimeBegin" value="2013/6/6 9:11:01" />
                    <input type="hidden" name="hdreadertag" id="hdreadertag" value="0" />
                    <input type="hidden" name="hdorderid" id="hdorderid" value="1060609110142210662" />
                    <input type="hidden" name="hftestrecid" id="v_Q103ID" value="<%=dt_Q10301.Rows[0]["Q103_ID"].ToString() %>" />
                    
                    
                    <div class="subject_btn">
                        <%
 
                            for (int i = 0; i < dt_Q00401.Rows.Count; i++)
                            {
                                string name = dt_Q00401.Rows[i]["Q001_NAME"].ToString();
                                string id = dt_Q00401.Rows[i]["Q001_ID"].ToString();
                                if (i == 0)
                                {
                                   // Response.Write("<input type=\"button\" id=\"dt_input_" + id + "\" onclick=\"dtControl('" + id + "',1);\"  class=\"input11\" value=\"" + name + "\"></input>");
                                }
                                else
                                {
                                  //  Response.Write("<input type=\"button\" id=\"dt_input_" + id + "\" onclick=\"dtControl('" + id + "',1);\"  class=\"input22\" value=\"" + name + "\"></input>");
                 
                                }
                            }
                     
                             %>

                           
                    </div>
                    <!--categoribtn结束-->
                    <div class="h10">
                    </div>
                     <%
                         int ucount = 0;
                         for (int i = 0; i < dt_Q00401.Rows.Count; i++)
                         {
                            string name = dt_Q00401.Rows[i]["Q001_NAME"].ToString();
                            string id = dt_Q00401.Rows[i]["Q001_ID"].ToString();
                            string remark = dt_Q00401.Rows[i]["remark"].ToString();
                      %>
                       <div id="con_one_<%= id%>">
                        <div class="h10">
                        </div>
                        <div id="dt_xt_title_<%= id%>" class="part2 part2_1"   onclick="dtControl('<%=id %>',0);"><%=name%></div>
                        <div id="dt_xt_content_<%=id %>" style="display: ;">
                         <div class="style_dt_desc">
                           <%=remark%>  
                         </div>
                          <div class="container">
                                <div id="item_<%= id%>">
                                <%
                                   
                                    for (int ll = 0; ll < dt_Q10301.Rows.Count; ll++)
                                    {
                                        string q001id = dt_Q10301.Rows[ll]["Q001_ID"].ToString();
                                        string line_no = dt_Q10301.Rows[ll]["line_no"].ToString();
                                        string state = dt_Q10301.Rows[ll]["state"].ToString();
                       
                                        if (q001id != id)
                                        {
                                            continue;
                                        }
                                        if (state == "1")
                                        {
                                            ucount = ucount + 1;
                                        }
                                        string qhtml = dt_Q10301.Rows[ll]["q_content"].ToString();
                                        string qresult = dt_Q10301.Rows[ll]["qresult"].ToString();
                                        if (qresult == null || qresult == "" || qresult == "0" )
                                        {
                                            qresult = "0";
                                        }
                                       
                                        qhtml = qhtml.Replace("\r", "<BR>");
                                        qhtml = qhtml.Replace("\n", "<BR>");
                                        qhtml = qhtml.Replace(" ", "&nbsp;");
                                 %>       
                                     
                      <div class="paper_content1 border_t_g_r" id="xt_<%=line_no %>" style="padding-left:10px; padding-right:10px;">
                      <div class="toper" style="padding:0px; text-align:left; line-height:24px; color:#333; font-size:14px;">
                      <font class="bold blue">第<font class="orange"><%=line_no%></font>题</font> 
                      <%=qhtml%> 
                      </div>
                      <div class="h10"></div>
                      <div class="h10"></div>
                      <%if (q001id == "100002")
                        { 
                           %>
                      <div class="resolve">
                      <h5>[选择]</h5>
                      <div class="key2 fl">
                      <ul class="zimu2">
                      <%for (int c = 65; c < 69; c++)
                        {
                            string d = ((char)c).ToString();
                            string color = " name=\"lia_" + line_no + "\" style=\"color:Black;\"";
                            if (qresult == d)
                            {
                                color = "  name=\"lia_" + line_no + "\" style=\"color:Red;\"";
                            }
                       %>
                          <li id="li_<%=line_no %>_<%=d%>"    onclick="return selectitemv(this);"  style="cursor:default;">
                          <a href="javascript:void(0);" id="lia_<%=line_no %>_<%=d %>"  <%=color %> ><%=d %></a></li>
                       <% 
                        }
                            
                         %>
                      
                       </ul></div>
                      </div> 
                      <%} %>
          </div>

               <%  }
                              %>

                        
                          </div>
                          </div>
                        <div id="dt_xt_more_<%= id%>_0" style="display: none;">
                            <div class="chak">
                                <a onclick="dtControl('<%= id%>',1);">点击展开本大题全部题目</a></div>
                        </div>
                    </div>
                      <% }
                         
                      %>
                    <input type="hidden" name="tcount" id="tcount" value="<%=dt_Q10301.Rows.Count %>" />
                    <input type="hidden" name="ucount" id="ucount" value="<%=ucount %>" />
                        
                    <div class="h10">
                    </div>
                    <div class="situation_num" id="totalItemsView1">
                        已做 <span class="green"><%=ucount%></span> 题 / 共 <span class="green"><%=dt_Q10301.Rows.Count %></span> 题    &nbsp;&nbsp;剩余 <span class="green"><%=(dt_Q10301.Rows.Count - ucount).ToString() %></span> 题未作答
                    </div>
                    <div class="h20">
                    </div>
                    <div class="subject_btn">
                    <%
                       
                            for (int i = 0; i < dt_Q00401.Rows.Count; i++)
                            {
                                string name = dt_Q00401.Rows[i]["Q001_NAME"].ToString();
                                string id = dt_Q00401.Rows[i]["Q001_ID"].ToString();
                                if (i == 0)
                                {
                                   // Response.Write("<input type=\"button\" id=\"dt_input_" + id + "_0\" onclick=\"dtControl('" + id + "',1);\"  class=\"input11\" value=\"" + name + "\"></input>");
                                }
                                else
                                {
                                   // Response.Write("<input type=\"button\" id=\"dt_input_" + id + "_0\" onclick=\"dtControl('" + id + "',1);\"  class=\"input22\" value=\"" + name + "\"></input>");
                 
                                }
                            }

                             %>
                            
                    </div>
                    <div class="h25">
                    </div>
                    <div class="cut_question">
                        <div class="line">
                        </div>
                    </div>
                    <div class="h25">
                    </div>
                    <div class="hand_paper">
                        <input name="hdStopTimes" type="hidden" id="hdStopTimes" value="0" />
                        <input type="image" name="ImageButton1" id="ImageButton1" class="curPointer" src="images/hand_paper.png" onclick="sumbit();" style="height:50px;width:182px;border-width:0px;" />
                        <span id="lbljsTime"><script language="javascript" type="text/javascript">                                                 ExamM = 120; countTime = 120;</script></span>
                    </div>
                    <div class="h25">
                    </div>
                    <div class="testing_banner">
                        <div id="view_760_90_iframe" style="width: 914px; height: 96px; overflow: hidden;"></div>
                    </div>
                    <div class="h25">
                    </div>
                    <!--complete结束-->
                </div>
            </div>
            <!--content结束-->
        </div>
        <!--width960结束-->



  <div id="bottomNav" class="rightBottomNav fast_menu_lx" style="top: 63px; border: #c5c5c5 1px solid;">
        <div id="adleft_display_id0" class="bottomNav_all" style="border: 0px; width: 205px;">
            <div class="bottomNav_top11" onclick="set_adleft_display();">
            </div>
            <div id="bottomNav_con" style="text-align: center; padding: 0; margin: 0; background-color: #f8f8f8;
                overflow-y: auto;">
                <table border="0" cellpadding="0" cellspacing="0" align="center" class="tbItemsNav">
                    <tbody>
                             
                            <%
                                
                                for (int i = 0; i < dt_Q00401.Rows.Count; i++)
                                {
                                    string name = dt_Q00401.Rows[i]["Q001_NAME"].ToString();
                                    string id = dt_Q00401.Rows[i]["Q001_ID"].ToString();
                                    %> 
                                <tr>
                                    <td align="left">
                                        <table width="100%" class="xtNavA_con_tab" cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td id="xtNavA_dt_0" class="xtNavA_bg_dt" style="cursor: pointer;" onclick="dtControl('<%=id %>',2);">
                                                    <div style="padding-left: 8px;" class="">
                                                        <a title="<%=name %>" class="leftTabCurr"
                                                            id="leftTab_0" style="text-decoration: none;">
                                                            <h6 style="color: #2f3743; font-size: 14px; font-weight: normal; text-decoration: none;">
                                                                <%=name %></h6>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr id="dt_xt_nav_1_0" style="display: ;">
                                                <td align="center" style="padding-left: 8px; padding-right: 8px;">
                                                    <div class="xtNavA" style="background: #fff;">
                                                        <ul style="padding-left: 2px;">  
                                                        <%
                                                            for (int ll = 0; ll < dt_Q10301.Rows.Count; ll++)
                                                            {
                                                                string q001id = dt_Q10301.Rows[ll]["Q001_ID"].ToString();
                                                                string line_no = dt_Q10301.Rows[ll]["line_no"].ToString();
                                                                if (q001id != id)
                                                                {
                                                                    continue;
                                                                }
                                                                string state = dt_Q10301.Rows[ll]["state"].ToString();
                                                                string classid = "mark_ans_do_0";
                                                                if (state != "0")
                                                                {
                                                                    classid = "mark_ans_do_1";
                                                                }
                                                                %>
                                                                 <li class="<%=classid %>" style="border: #c6c6c6 1px solid;" id="li_xt_<%=line_no %>">
                                                                    
                                                                        <a onclick="ctrolScroll_new('xt_<%=q001id %>_<%=line_no %>');">
                                                                          <%=line_no.ToString()%></a></li>     

                                                              <%  
                                                            }                
                                        
                                                         %>                                                          
                                                                                                           
       
                                                        </ul>
                                                        <div class="clear">
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr style="height: 1px; overflow: hidden;">
                                                <td align="center" style="padding-left: 8px; padding-right: 8px;">
                                                    <div class="xtNavA" style="height: 1px; overflow: hidden; background: #fff;">
                                                        <ul>
                                                            <li class="mark_ans_do_0">&nbsp;</li>
                                                            <li class="mark_ans_do_0">&nbsp;</li>
                                                            <li class="mark_ans_do_0">&nbsp;</li>
                                                            <li class="mark_ans_do_0">&nbsp;</li>
                                                            <li class="mark_ans_do_0">&nbsp;</li>
                                                            <li class="mark_ans_do_0">&nbsp;</li>
                                                            <li class="mark_ans_do_0">&nbsp;</li>
                                                            <li class="mark_ans_do_0">&nbsp;</li>
                                                            <li class="mark_ans_do_0">&nbsp;</li>
                                                        </ul>
                                                        <div class="clear">
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            
                             <%} %>
                            
                    </tbody>
                </table>
            </div>
            <div class="explain" style="background: #e8e8e8;" id="ExamSubmit1">
                <div class="explain1 fl">
                    <dl>
                        <dt>
                            <img src="images/text1.png" width="23" height="23" /></dt>
                        <dd>
                            未作答</dd>
                    </dl>
                    <dl>
                        <dt>
                            <img src="images/text2.png" width="23" height="23" /></dt>
                        <dd>
                            <span class="black">已作答</span></dd>
                    </dl>
 
                </div>
                <div class="h10">
                </div>
                <div class="explain1_btn">
                    <img src="images/fast1.png" width="93" height="34" onclick="ExamSubmit();" style="cursor: pointer" /><img
                        src="images/fast2.png" width="91" height="34" onclick="TimeStop()" style="cursor: pointer" />
                </div>
            </div>
        </div>
        <div id="adleft_display_id1" style="display: none; cursor: pointer;" onclick="set_adleft_display();">
            <img src="/noupdate/images/btn_bottom_nav_min1.gif" />
        </div>
    </div>

