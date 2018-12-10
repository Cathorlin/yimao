var ColorHex = new Array('00', '33', '66', '99', 'CC', 'FF')
var SpColorHex = new Array('FF0000', '00FF00', '0000FF', 'FFFF00', '00FFFF', 'FF00FF')
var current = null;
var if_showcolor = false;
var docolor_obj; //控件
var docolor_id;
document.write( "<div id=\"colorpane\" style=\"position:absolute;z-index:999;display:none;\"></div>" );
function initcolor() {
    var colorTable = ''
    for (i = 0; i < 2; i++) {
        for (j = 0; j < 6; j++) {
            colorTable = colorTable + '<tr height=15>'
            colorTable = colorTable + '<td width=15 style="background-color:#000000">'
            if (i == 0) {
                colorTable = colorTable + '<td width=15 style="cursor:pointer;background-color:#' + ColorHex[j] + ColorHex[j] + ColorHex[j] + '" onclick="docolorclick(this.style.backgroundColor)">'
            }
            else {
                colorTable = colorTable + '<td width=15 style="cursor:pointer;background-color:#' + SpColorHex[j] + '" onclick="docolorclick(this.style.backgroundColor)">'
            }
            colorTable = colorTable + '<td width=15 style="background-color:#000000">'
            for (k = 0; k < 3; k++) {
                for (l = 0; l < 6; l++) {
                    colorTable = colorTable + '<td width=15 style="cursor:pointer;background-color:#' + ColorHex[k + i * 3] + ColorHex[l] + ColorHex[j] + '" onclick="docolorclick(this.style.backgroundColor)">'
                }
            }
        }
    }
    colorTable = '<table border="0" cellspacing="0" cellpadding="0" style="border:1px #000000 solid;border-bottom:none;border-collapse: collapse;width:337px;" bordercolor="000000">'
+ '<tr height=20><td colspan=21 bgcolor=#ffffff style="font:12px tahoma;padding-left:2px;">'
+ '<span style="float:left;color:#999999;">请选择颜色</span>'
+ '<span style="float:right;padding-right:3px;cursor:pointer;" onclick="colorclose()">×关闭</span>'
+ '</td></table>'
+ '<table border="1" cellspacing="0" cellpadding="0" style="border-collapse: collapse" bordercolor="000000" style="cursor:pointer;">'
+ colorTable + '</table>';
    document.getElementById("colorpane").innerHTML = colorTable;
    var current_x = docolor_obj.offsetLeft;
    var current_y = docolor_obj.offsetTop;
    //alert(current_x + "-" + current_y) 
    document.getElementById("colorpane").style.left = current_x + "px";
    document.getElementById("colorpane").style.top = current_y + "px";
}
function docolorclick(obj) {
   
    try
    {
        if (docolor_obj != null) {
            docolor_obj.value = String(obj);
            docolor_obj.style.backgroundColor = obj;
            input_change(docolor_obj, docolor_id);
        }
        
    }
    catch(e)
    {
    }
    colorclose();
}
function select_color(obj,id_) {
    docolor_obj = obj;
    docolor_id = id_;
    if (if_showcolor == false) {
        initcolor();
        if_showcolor = true;
    }
    coloropen();
}
function colorclose() {
    document.getElementById("colorpane").style.display = "none";
}
function coloropen() {
    document.getElementById("colorpane").style.display = "";
}
