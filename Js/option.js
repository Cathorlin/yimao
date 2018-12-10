// JScript 文件
/*
Javascript - Select操作大集合      最近在看一本书，Wrox.Professional JavaScript™ for Web Developers，是老赵在他的Ajax深入浅出系列讲座中提到过的一本书。其实这本书一直都在我的电脑里，只是没认真看过。一直没怎么很正式的学习过javascript，偶尔用到的时候就到网上找些代码，改吧改吧就用了，这次从头开始学起，细细看下来，还真是有不少收获，甚至有点喜欢上javascript了。

      现在步入正题，看到书中讲Form元素的操作，像Textbox、Button、Label等，都还是比较简单的，只是看到Select时，稍微有些复杂，于是就想仔细研究研究，于是就有了这篇文章。Select的操作包括动态添加、删除、移动、获取选中项的值、排序等等，现在一一讲述。

1、向Select里添加Option//IE only,FF不支持Add方法
*/
function fnAddItem(selTarget,text,value)
{
    selTarget.Add(new Option(text,value));
}
//IE FF both OK
function fnAdd(oListbox, sValue,sName) 
{
    var oOption = document.createElement("option");
    oOption.appendChild(document.createTextNode(sName));

    if (arguments.length == 3) 
    {
        oOption.setAttribute("value", sValue);
    }

    oListbox.appendChild(oOption);
}

//2、删除Select里的Option
function fnRemoveItem(selTarget)
{
   // var selTarget = document.getElementById("selID");
   var len = selTarget.options.length;
   // alert(len);
    if(len > 0) 
    {//说明选中
        for(var i=len - 1 ; i >= 0 ; i--)
        {

                selTarget.remove(i);
        }
    }
} 
        //3、移动Select里的Option到另一个Select中     
        function fnMove(from,to)
        {
                    
            for(var i=0;i<from.options.length;i++)
            {
                if(from.options[i].selected)
                {
                    to.appendChild(from.options[i]);
                    i = i - 1;
                }
            }
        }   
        /* if 里的代码也可用下面几句代码代替
  var op = from.options[i];
  to.options.add(new Option(op.text, op.value));
  from.remove(i);4、Select里Option的上下移动     */
    function fnUp(sel)
        {   
          //  var sel = document.getElementById("selID");
            for(var i=1; i < sel.length; i++)
            {//最上面的一个不需要移动，所以直接从i=1开始
                if(sel.options[i].selected)
                {
                    if(!sel.options.item(i-1).selected)
                    {//上面的一项没选中，上下交换
                          var selText = sel.options[i].text;
                          var selValue = sel.options[i].value;
                          
                          sel.options[i].text = sel.options[i-1].text;
                          sel.options[i].value = sel.options[i-1].value;
                          sel.options[i].selected = false;
                          
                          sel.options[i-1].text = selText;
                          sel.options[i-1].value = selValue;
                          sel.options[i-1].selected=true;
                    }
                }
            }
        }//在进行上下两项互换时，也可以使用以下代码，但是效率很低，因为每一次的Dom操作都将导致整个页面的重新布局，所以不如直接修改元素的属性值。
           //             var oOption = sel.options[i]
             //           var oPrevOption = sel.options[i-1]
               //         sel.insertBefore(oOption,oPrevOption);向下移动同理
function fnDown(sel)
        {
           // var sel = fnGetTarget("selLeftOrRight");
            for(var i=sel.length -2; i >= 0; i--)
            {//向下移动，最后一个不需要处理，所以直接从倒数第二个开始
                if(sel.options.item(i).selected)
                {
                    if(!sel.options.item(i+1).selected)
                    {//下面的Option没选中，上下互换
                          var selText = sel.options.item(i).text;
                          var selValue = sel.options.item(i).value;
                          
                          sel.options.item(i).text = sel.options.item(i+1).text;
                          sel.options.item(i).value = sel.options.item(i+1).value;
                          sel.options.item(i).selected = false;
                          
                          sel.options.item(i+1).text = selText;
                          sel.options.item(i+1).value = selValue;
                          sel.options.item(i+1).selected=true;
                    }
                }
            }
        }
        /*5、Select里Option的排序这里借助Array对象的sort方法进行操作，sort方法接受一个function参数，可以在这个function里定义排序时使用的算法逻辑。
array.sort([compareFunction]) 里compareFunction接受两个参数(p1,p2)，sort操作进行时，array对象会每次传两个值进去，进行比较；compareFunciton必须返回一个整数值：当返回值>0时，p1会排在p2后面；返回值<0时，p1会排在p2前面；返回值=0时，不进行操作。
例如： function fnCompare(a,b)
        {
            if (a < b)
                return -1;
            if (a > b)
                return 1;
            return 0;
        }
var arr = new Array();
//add some value into arr
arr.sort(fnCompare);
//这里sort的操作结果就是arr里的项按由小到大的升序排序
//如果把fnCompare里改为
//if (a < b)
//  return 1;
//if (a > b)
//  return -1;
//return 0;//
//则sort的结果是降序排列
//好，下面就是对Select里Option的排序

//因为排序可以按Option的Value排序，也可以按Text排序，这里只演示按Value排序
*/
function sortItem()
{
    var sel = document.getElementById("selID");
    var selLength = sel.options.length;
    var arr = new Array();
    var arrLength;

    //将所有Option放入array
    for(var i=0;i<selLength;i++)
    {
        arr[i] = sel.options[i];
    }
    arrLength = arr.length;

    arr.sort(fnSortByValue);//排序
    //先将原先的Option删除
    while(selLength--)
    {
        sel.options[selLength] = null;
    }
    //将经过排序的Option放回Select中
    for(i=0;i<arrLength;i++)
    {
        fnAdd(sel,arr[i].text,arr[i].value);
        //sel.add(new Option(arr[i].text,arr[i].value));
    }
}
function fnSortByValue(a,b)
{
    var aComp = a.value.toString();
    var bComp = b.value.toString();

    if (aComp < bComp)
        return -1;
    if (aComp > bComp)
        return 1;
    return 0;
}
/*排序时还可以有更多选项，比如将value值看做Integer或是String进行排序，得到的结果是不一样的。篇幅限制，不在多做介绍。
我将这些所有的操作都写在了一个文件里，运行的效果如图（点击看大图）

有兴趣的朋友可以下载来看看，里面还设计div+css排版等。
Download
============================================================

终于写完了，洗洗睡
========================
改了一下，现在FF下工作正常
*/