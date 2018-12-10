$(document).ready(function () {

    //Set Default State of each portfolio piece
    $(".paging").show();
    $(".paging a:first").addClass("active");

    //Get size of images, how many there are, then determin the size of the image reel.
    var imageWidth = $(".window").width();
    var imageSum = $(".image_reel img").size();
    var imageReelWidth = imageWidth * imageSum;

    //Adjust the image reel to its new size
    $(".image_reel").css({ 'width': imageReelWidth });

    //Paging + Slider Function
    rotate = function () {
        var triggerID = $active.attr("rel") - 1; //Get number of times to slide
        var image_reelPosition = triggerID * imageWidth; //Determines the distance the image reel needs to slide

        $(".paging a").removeClass('active'); //Remove all active class
        $active.addClass('active'); //Add active class (the $active is declared in the rotateSwitch function)

        //Slider Animation
        $(".image_reel").animate({
            left: -image_reelPosition
        }, 500);

    };

    //Rotation + Timing Event
    rotateSwitch = function () {
        play = setInterval(function () { //Set timer - this will repeat itself every 3 seconds
            $active = $('.paging a.active').next();
            if ($active.length === 0) { //If paging reaches the end...
                $active = $('.paging a:first'); //go back to first
            }
            rotate(); //Trigger the paging and slider function
        }, 3000); //Timer speed in milliseconds (3 seconds)
    };

    rotateSwitch(); //Run function on launch

    //On Hover
    $(".image_reel a").hover(function () {
        clearInterval(play); //Stop the rotation
    }, function () {
        rotateSwitch(); //Resume rotation
    });

    //On Click
    $(".paging a").click(function () {
        $active = $(this); //Activate the clicked paging
        //Reset Timer
        clearInterval(play); //Stop the rotation
        rotate(); //Trigger rotation immediately
        rotateSwitch(); // Resume rotation
        return false; //Prevent browser jump to link anchor
    });

});


function runImg() { }
runImg.prototype = {
    bigbox: null, //最外层容器
    boxul: null, //子容器ul
    imglist: null, //子容器img
    numlist: null, //子容器countNum
    index: 0, //当前显示项
    timer: null, //控制图片转变效果
    play: null, //控制自动播放
    imgurl: [], //存放图片
    count: 0, //存放的个数
    $: function (obj) {
        if (typeof (obj) == "string") {
            if (obj.indexOf("#") >= 0) {
                obj = obj.replace("#", "");
                if (document.getElementById(obj)) {
                    return document.getElementById(obj);
                }
                else {
                    alert("没有容器" + obj);
                    return null;
                }
            }
            else {
                return document.createElement(obj);
            }
        }
        else {
            return obj;
        }
    },
    //初始化
    info: function (id) {
        this.count = this.count <= 6 ? this.count : 6;
        this.bigbox = this.$(id);
        for (var i = 0; i < 2; i++) {
            var ul = this.$("ul");
            for (var j = 1; j <= this.count; j++) {
                var li = this.$("li");
                li.innerHTML = i == 0 ? this.imgurl[j - 1] : j;
                ul.appendChild(li);
            }
            this.bigbox.appendChild(ul);
        }
        this.boxul = this.bigbox.getElementsByTagName("ul");
        this.boxul[0].className = "imgList";
        this.boxul[1].className = "countNum";
        this.imglist = this.boxul[0].getElementsByTagName("li");
        this.numlist = this.boxul[1].getElementsByTagName("li");
        this.numlist[0].className = "current";
    },
    //封装程序入口
    action: function (id) {
        this.autoplay();
        this.mouseoverout(this.bigbox, this.numlist);
    },
    //图片切换效果
    imgshow: function (num, numlist, imglist) {
        this.index = num;
        var alpha = 0;
        for (var i = 0; i < numlist.length; i++) {
            numlist[i].className = "";
        }
        numlist[this.index].className = "current";
        clearInterval(this.timer);
        for (var j = 0; j < imglist.length; j++) {
            imglist[j].style.opacity = 0;
            imglist[j].style.filter = "alpha(opacity=0)";
        }
        var $this = this;
        //利用透明度来实现切换图片
        this.timer = setInterval(function () {
            alpha += 2;
            if (alpha > 100) { alpha = 100 }; //不能大于100
            //为兼容性赋样式
            imglist[$this.index].style.opacity = alpha / 100;
            imglist[$this.index].style.filter = "alpha(opacity=" + alpha + ")";
            if (alpha == 100) { clearInterval($this.timer) }; //当等于100的时候就切换完成了
        }, 20)//经测试20是我认为最合适的值
    },
    //自动播放
    autoplay: function () {
        var $this = this;
        this.play = setInterval(function () {
            $this.index++;
            if ($this.index > $this.imglist.length - 1) { $this.index = 0 };
            $this.imgshow($this.index, $this.numlist, $this.imglist);
        }, 3000)
    },
    //处理鼠标事件
    mouseoverout: function (box, numlist) {
        var $this = this;
        box.onmouseover = function () {
            clearInterval($this.play);
        }
        box.onmouseout = function () {
            $this.autoplay($this.index);
        }
        for (var i = 0; i < numlist.length; i++) {
            numlist[i].index = i;
            numlist[i].onmouseover = function () {
                $this.imgshow(this.index, $this.numlist, $this.imglist);
            }
        }
    }
}
window.onload = function () {
    var runimg = new runImg();
    runimg.count = 6;
    runimg.imgurl = [
"<img src=\"lubang/images/flash/01.jpg\" />",
"<img src=\"lubang/images/flash/02.jpg\" />",
"<img src=\"lubang/images/flash/03.jpg\" />",
"<img src=\"lubang/images/flash/04.jpg\" />",
"<img src=\"lubang/images/flash/05.jpg\" />",
"<img src=\"lubang/images/flash/06.jpg\" />"];
    runimg.info("#box");
    runimg.action("#box");
}