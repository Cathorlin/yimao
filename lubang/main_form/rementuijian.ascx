<%@ Control Language="C#" AutoEventWireup="true" CodeFile="rementuijian.ascx.cs" Inherits="lubang_main_form_rementuijian" %>
<div class="product_list4">
        <div class="zxyh">
            <div class="title01">
                <ul>
                    <li class="current_t" id="t_list1" onmouseover="show_list(1)">最新优惠</li>
                    <li class="out_t" id="t_list2" onmouseover="show_list(2)">热门优惠</li>
                    <li class="out_t" id="t_list3" onmouseover="show_list(3)">精品推荐</li>
                </ul>
            </div>
        </div>
    </div>
    <div class="clear">
    </div>
    <div class="product_list5">
        <%for (int i = 0; i < m00202_m036_A0360101_v01_6.Rows.Count; i++)
          {
              string product_title = m00202_m036_A0360101_v01_6.Rows[i]["product_title"].ToString();
              string product_picture =  m00202_m036_A0360101_v01_6.Rows[i]["product_picture"].ToString();
              string m00203_key = m00202_m036_A0360101_v01_6.Rows[i]["m00203_key"].ToString();
              string link_url = http_url + "lubang/CarDes.aspx?keyid=" + m00203_key;
        %>
        <div class="listmain" id="list1">
            <div class="list_div">
                <div class="list01">
                    <a href="<%=link_url %>" target="_blank">
                        <img alt="" src="<%=product_picture%>" /></a></div>
                <div class="listdes">
                    <a href="<%=link_url %>" target="_blank">
                        <%=product_title %></a></div>
            </div>
        </div>
        <%} %>
        <%for (int i = 0; i < m00202_m036_A0360101_v01_6.Rows.Count; i++)
          {
              string product_title = m00202_m036_A0360101_v01_6.Rows[i]["product_title"].ToString();
              string product_picture =  m00202_m036_A0360101_v01_6.Rows[i]["product_picture"].ToString();
              string m00203_key = m00202_m036_A0360101_v01_6.Rows[i]["m00203_key"].ToString();
              string link_url = http_url + "lubang/CarDes.aspx?keyid=" + m00203_key;
        %>
        <div class="listmain" id="list2" style="display: none;">
            <div class="list_div">
                <div class="list01">
                    <a href="<%=link_url %>" target="_blank">
                        <img alt="" src="<%=product_picture%>" /></a></div>
                <div class="listdes">
                    <a href="<%=link_url %>" target="_blank">
                        <%=product_title %></a></div>
            </div>
        </div>
        <%} %>
        <%for (int i = 0; i < m00202_m036_A0360101_v01_6.Rows.Count; i++)
          {
              string product_title = m00202_m036_A0360101_v01_6.Rows[i]["product_title"].ToString();
              string product_picture =  m00202_m036_A0360101_v01_6.Rows[i]["product_picture"].ToString();
              string m00203_key = m00202_m036_A0360101_v01_6.Rows[i]["m00203_key"].ToString();
              string link_url = http_url + "lubang/CarDes.aspx?keyid=" + m00203_key;
        %>
        <div class="listmain" id="list3" style="display: none;">
            <div class="list_div">
                <div class="list01">
                    <a href="<%=link_url %>" target="_blank">
                        <img alt="" src="<%=product_picture%>" /></a></div>
                <div class="listdes">
                    <a href="<%=link_url %>" target="_blank">
                        <%=product_title %></a></div>
            </div>
        </div>
        <%} %>
    </div>