// JScript 文件

                   var scrollslow = function(xx) {
                        var space = xx['space']||null;
	                    var speed = xx['speed']||null;
	                    var tab = xx['tab']||null;
	                    var tab1 = xx['tab1']||null;
	                    var tab1child = xx['tab1child']||null;
	                    var stoptime = xx['stoptime']||null;
	                    var scrollTime;
	                    var _this = this;

	                    /*
	                    onmove:每次滚动启动的时候
	                    onstop:每段滚动中间暂停的时候
	                    onrestart:每段滚动中间暂停后再次启动的时候
	                    */
                    	
	                    this.scrollToTop = function(){
		                    if(_this.onmoveToTop) _this.onmoveToTop();
		                    if(tab1child){
			                    var ToCorrent=tab1child.offsetHeight-tab.scrollTop%tab1child.offsetHeight; //  ToCorrent为修正用，防止space和节点宽或高度不合适导致的无法暂停，必要时，以ToCorrent代替space防止暂停条件不被触发
			                    if(ToCorrent<space) tab.scrollTop+=ToCorrent; 
			                    else tab.scrollTop+=space;
		                    }else tab.scrollTop+=space;
		                    if(tab1child&&stoptime) {
			                    if(tab.scrollTop%tab1child.offsetHeight==0) 
				                    {scrollTime=setTimeout(function(){_this.scrollToTop()},stoptime);if(_this.onstopToTop) _this.onstopToTop();if(_this.onendToTop) _this.onendToTop();return}
		                    }
		                    scrollTime = setTimeout(function(){_this.scrollToTop();},speed);
		                    if(_this.onendToTop) _this.onendToTop();
	                    }
                    	
	                    this.scrollToBottom = function(){
		                    if(_this.onmoveToBottom) _this.onmoveToBottom();
		                    if(tab1child){
			                    var ToCorrent=tab.scrollTop%tab1child.offsetHeight; //  ToCorrent为修正用，防止space和节点宽或高度不合适导致的无法暂停，必要时，以ToCorrent代替space防止暂停条件不被触发
			                    if(ToCorrent<space&&ToCorrent!=0) tab.scrollTop-=ToCorrent; 
			                    else tab.scrollTop-=space;
		                    }else tab.scrollTop-=space;
		                    if(tab1child&&stoptime) {
			                    if(tab.scrollTop%tab1child.offsetHeight==0) 
				                    {scrollTime=setTimeout(function(){_this.scrollToBottom()},stoptime);if(_this.onstopToBottom) _this.onstopToBottom();if(_this.onendToBottom) _this.onendToBottom();return}
		                    }
		                    scrollTime = setTimeout(function(){_this.scrollToBottom();},speed);
		                    if(_this.onendToBottom) _this.onendToBottom();
	                    }
                    	
	                    this.cleartime = function(){
		                    clearTimeout(scrollTime);
	                    }
                    }
                    var scnav = document.getElementById("homePushName").getElementsByTagName("li");
                    var scct = document.getElementById("homePushShow");
                    var flow =0;
                    var sc = new scrollslow({'speed':10,'space':4,'tab':scct.parentNode,'tab1':scct,'tab1child':scct.getElementsByTagName("li")[0],'stoptime':2000});
                    sc.cleartime();
                    var sc2 = new scrollslow({'speed':10,'space':10,'tab':scct.parentNode,'tab1':scct,'tab1child':scct.getElementsByTagName("li")[0],'stoptime':10});
                    sc2.cleartime();
                    var se;
                    clearTimeout(se);
                    sc.onstopToTop = function(){
	                    flow++;
                    	
	                    if(flow>=5) {sc2.cleartime();sc3.cleartime();clearTimeout(se);
		                    sc.cleartime();sc2.scrollToBottom();return false;}
	                    for(var i=0;i<scnav.length;i++){
		                    scnav[i].className=" ";
	                    }
	                    scnav[flow].className="current";
	                    return true;
                    }
                    sc2.onstopToBottom=function(){
	                    flow--;
                    }
                    sc2.onendToBottom = function(){
	                    if(scct.parentNode.scrollTop==0) {
		                    flow--;
		                    if(flow<=0) flow=0;
		                    for(var i=0;i<scnav.length;i++){
			                    scnav[i].className=" ";
		                    }
		                    scnav[flow].className="current";
		                    sc2.cleartime();
		                    se=setTimeout(function(){sc.scrollToTop()},2000);
		                    return false;}
	                    return true;
                    }

                    var sc3 = new scrollslow({'speed':10,'space':10,'tab':scct.parentNode,'tab1':scct,'tab1child':scct.getElementsByTagName("li")[0]});
                    sc3.cleartime();

                    var boxchange = function (k){
	                    sc.cleartime();sc2.cleartime();sc3.cleartime();clearTimeout(se);
	                    if(k>flow) {
		                    sc3.onendToTop = function(){
			                    if(scct.parentNode.scrollTop==k*scct.getElementsByTagName("li")[0].offsetHeight) 
			                    {sc3.cleartime();se=setTimeout(function(){sc.scrollToTop()},2000);sc3.onendToTop="";return false;}
			                    return true;
		                    }
		                    sc3.scrollToTop();
	                    }
	                    else if(k<flow) {
		                    sc3.onendToBottom = function(){
			                    if(scct.parentNode.scrollTop==k*scct.getElementsByTagName("li")[0].offsetHeight) 
			                    {sc3.cleartime();se=setTimeout(function(){sc.scrollToTop()},2000);sc3.onendToBottom="";return false;}
			                    return true;
		                    }
		                    sc3.scrollToBottom();
	                    }
	                    flow=k;
	                    for(var i=0;i<scnav.length;i++){
		                    scnav[i].className=" ";
	                    }
	                    scnav[flow].className="current";
                    }
                    function imchange(j) {
	                    return function(){
		                    boxchange(j);
	                    }
                    }
                    for(var j=0;j<scnav.length;j++){
	                    scnav[j].onclick = imchange(j);
                    }
                    sc.scrollToTop();