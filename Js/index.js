// JScript 文件

var  old_tab_num= 99 ;
function show_con(value) {
    //alert(value)
    var old_tab =  document.getElementById("tab" + old_tab_num );
    if (old_tab != null)
    {
        old_tab.style.display = "none";
        document.getElementById("li_tab" + old_tab_num).className = "tabnoon";
        
    }
    var new_tab =  document.getElementById("tab" + value );
    if (new_tab != null)
    {
        new_tab.style.display = "block";
        obj = document.getElementById("li_tab" + value);
     //   alert(obj.className)
        obj.className = "tabon";
       // document.getElementById("li_tab" + value).style.className = "tabon";
        
    }
    old_tab_num = value ;

}
