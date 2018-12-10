<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<style type="text/css">
body, html,#allmap {width: 100%;height: 100%;overflow: hidden;margin:0;}
</style>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=KlRKaUE6BNnlGNnbnYPefdsj"></script>
<title>点击地图获取当前经纬度</title>
</head>
<body>
 <a style="color:red;">当前城市:</a><a id="localcity" style="color:blue;"></a>
<div id="allmap"></div>
<input type="hidden" id="a">
<input type="hidden" id="b">
</body>
</html>
<script type="text/javascript">

    // 百度地图API功能
    var map = new BMap.Map("allmap");
    map.centerAndZoom(new BMap.Point(116.404, 39.915), 11);  //初始化默认北京

    var myCity = new BMap.LocalCity();
    myCity.get(myFun);                   // 初始化地图,设置城市和地图级别。


    map.enableScrollWheelZoom();    //启用滚轮放大缩小，默认禁用
    map.enableContinuousZoom();    //启用地图惯性拖拽，默认禁用

    function myFun(result) {
        var cityName = result.name;
        map.setCenter(cityName);
        document.getElementById("localcity").innerHTML = cityName;  //设置当前城市
    }

    function showInfo(e) {
        //document.getElementById("b").value = e.point.lng;
        //document.getElementById("a").value = e.point.lat;
        //alert(e.point.lng + ", " + e.point.lat);  //抛出显示当前经纬度
        //window.opener.document.getElementById('TXT_' + a002_key + '-0_0_29').value = e.point.lng;
        //window.opener.document.getElementById('TXT_' + a002_key + '-0_0_43').value = e.point.lat;
        //window.close();
        var v = new Object();
        v.DataId = e.point.lng + "," + e.point.lat;
        v.Para = window.dialogArguments;
        window.returnValue = v;
        window.close();   
        window.opener.show(true);
    }

    map.addEventListener("click", showInfo);  //鼠标点击事件

</script>
