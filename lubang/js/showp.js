function show_p(B) {
    for (var i = 1; i < 4; i++) {
        if (i == B) {
            document.getElementById("tit" + B).className = "currentcolor";
            document.getElementById("pro" + B).style.display = "block";
        }
        else {
            document.getElementById("tit" + i).className = "outcolor";
            document.getElementById("pro" + i).style.display = "none";
        }
    }
}
//$(document).ready(function () {
//    $(".meirongtit li").mouseover(function () {
//        $(".meirongtit li").toggle();
//    });
//});
function show_tit(C) {
    for (var i = 1; i < 7; i++) {
        if (i == C) {
            document.getElementById("dcar" + C).className = "current_c";
            document.getElementById("car" + C).style.display = "block";
        }
        else {
            document.getElementById("dcar" + i).className = "out_c";
            document.getElementById("car" + i).style.display = "none";
        }
    }

}
function show_list(D) {
    for (var i = 1; i < 4; i++) {
        if (i == D) {
            document.getElementById("t_list" + D).className = "current_t";
            document.getElementById("list" + D).style.display = "block";
        }
        else {
            document.getElementById("t_list" + i).className = "out_t";
            document.getElementById("list" + i).style.display = "none";
        }
    }
}

function shoucang(sTitle, sURL) {
    try {
        window.external.addFavorite(sURL, sTitle);
    }
    catch (e) {
        try {
            window.sidebar.addPanel(sTitle, sURL, "");
        }
        catch (e) {
            alert("加入收藏失败，请使用Ctrl+D进行添加");
        }
    }
}

function addCookie(id) {
    $.cookie.raw = true;
    if (typeof ($.cookie('ids')) == 'undefined') {
        $.cookie('ids', id, { expires: 7 });
    } else {
        var ids = [];
        if ($.cookie('ids').indexOf(id) == -1) {
            $.cookie('ids', $.cookie('ids') + "," + id, { expires: 7 });
        }
        ids = $.cookie('ids').split(',');
        if (ids.length > 5) {
            ids.shift();
        }
        $.cookie('ids', ids.join(','), { expires: 7 });
    }
    $("#r").html("result=" + $.cookie('ids'));
}

function removeCookie() {
    $.removeCookie('ids');
}

