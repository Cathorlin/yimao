var loading = 0;
$(function () {
    //编辑
    if (parseInt($('#ID').val()) > 0) {
        $("#loadingdiv").show();
        loading = 1;
        $.ajax({
            type: "POST",
            url: 'ProductPros.htm?categoryId=' + $('#Category_Id').val() + '&productId=' + $('#ID').val() + '&t=' + Math.random(),
            cache: false,
            error: function () { alert("服务器数据加载失败，请联系管理员") },
            success: function (json) {
                $('#li_props').html('');
                if (json.record.ProductProps.length > 0) {
                    $('#li_props').show();
                    $('#li_props').append(json.record.ProductProps);
                }
                else {
                    $('#li_props').hide();
                }
                $('#li_Color_list').html('');
                if (json.record.ProductSaleProps.length > 0) {
                    $('#li_Color_list').show();
                    $('#li_Color_list').append(json.record.ProductSaleProps);
                }
                else {
                    $('#li_Color_list').hide();
                }
                BindColorSale();
                AddOrRemoveClass();
                CheckProAttr();
                loading = 0;
                if (loading == 0 && loading2 == 0) {
                    $("#loadingdiv").hide();
                }
            }
        });
    }
    productValidate();
    InitPreview();
    ActImage();

    $("#submit").click(function () {
        GetProductProps();
        $('#Area_Name').val($('#areaName').val());
        if ($('#J_ul-color').length > 0) {
            $('#hasSaleProp').val('1');
        }
        else if ($('#li_Property_List').is("li")) {
            $('#hasSaleProp').val('1');
        }
    });

    //邮费模板 -- 编辑
    if ($('#whopsBuyer').prop('checked')) {
        $('#buyerTemp').show();
    }
    else {
        $('#buyerTemp').hide();
    }
    if ($('#usePostTemp').prop('checked')) {
        var id = $('#carriageId').val();
        var o = true;
        displayPostage(o, id);
    }
    //关键属性 品牌-其它
    if ($('#ulBrand').is('ul')) {
        var selBrand = $('#ulBrand>li').find("select");
        if ($(selBrand).val() == '0') {
            $('#ulBrand>li').find('.other').show();
        }
    }
    $('#formMain').live('submit', function () {
        //产品分类
        if ($("#Category_Id").val() == "" || $("#Category_Id").val() == "0") {
            alert("尚未选择商品分类，请在左侧选择商品的类目！");
            return false;
        }
        //产品图片
        if ($.browser.version != "9.0" && $.browser.version != "10.0") {
            var pic = $('#J_PanelLocalList img');
            var i = 0;
            pic.each(function (o) {
                if ($(this).attr('src') != '' && $(this).attr('src').indexOf("/zh_CN/default/images/preview.jpg") == -1) {
                    i++;
                }
            });
            //            if (i == 0) {
            //                alert("图片至少上传一张！");
            //                return false;
            //            }
        }
        if ($('#IsSale').length > 0) {
            if ($('#IsSale').val() == 1 && $('#J_sell-table>table>tbody>tr:visible').length == 0 && $('#J_ulColorTable>table>tbody>tr:visible').length > 0) {
                alert($('#li_Property_List >label').text() + "至少要选择一个！");
                return false;
            }
        }

        if ($("#city").val() == "0") {
            $("#city").focus();
            alert("请选择所在地的城市");
            return false;
        }

        //        var stopTagAllReg = /<[\s]*?(script|apple|object|param|xml|style)[\s\S]*?(\/[\s]*?>|[^>]*?<[\s]*?\/\1>)/gi;
        //        var stopTagRegStart = /<[\s]*?(input|doctype|base|body|frame|frameset|html|iframe|ilayer|layer|link|meta|title|textarea|form|head|select)[\s\S]*?>/gi;
        //        var stopTagRegEnd = /<[\s]*?\/[\s]*?(input|doctype|base|body|frame|frameset|html|iframe|ilayer|layer|link|meta|title|textarea|form|head|select)[\s]*?>/gi;
        //        var content = $("#Site_ProductDTO_Details").val();
        //        content = content.replace(stopTagAllReg, '').replace(stopTagRegStart, '').replace(stopTagRegEnd, '');
        //        $("#Site_ProductDTO_Details").val(content);

        $("#loadingdiv").show();
    });
});
/*************验证 begin *****************/
function productValidate() {
    //初始化验证控件
    $.formValidator.initConfig({
        formID: "formMain"
    });

    //商家编码
    $("#Code").formValidator({
        empty: false,
        onShow: false,
        onFocus: "限定在25个汉字内(50字符)！",
        onCorrect: false
    }).inputValidator({
        min: 0,
        max: 50,
        onError: "商家编码不能超过50个字符！"
    });
    //产品标题
    $("#Product_Name").formValidator({
        empty: false,
        onShow: false,
        onFocus: "限定在100个汉字内(200字符)！",
        onCorrect: false
    }).inputValidator({
        min: 1,
        max: 200,
        empty: { leftEmpty: false, rightEmpty: false, emptyError: "标题两边不能有空符号！" },
        onError: "产品标题不能为空且不超过200个字符！"
    });
    //价格
    $("#Price").formValidator({
        empty: false,
        onShow: false,
        onFocus: "必须为有效数值 如：12345或12345.00！",
        onCorrect: ""
    }).inputValidator({
        min: 0.01,
        onError: "价格不能为空且必须为有效数值 如：12345或12345.00!"
    }).regexValidator({
        regExp: "price",
        dataType: "enum",
        onError: "只能输入数字或跟小数点结合！"
    });
    //市场价格
    $("#Market_Price").formValidator({
        empty: false,
        onShow: false,
        onFocus: "必须为有效数值 如：12345或12345.00！",
        onCorrect: ""
    }).inputValidator({
        min: 0.01,
        onError: "市场价格不能为空且必须为有效数值 如：12345或12345.00！"
    }).regexValidator({
        regExp: "price",
        dataType: "enum",
        onError: "只能输入数字或跟小数点结合！"
    });
    //    //拍卖价格
    //    $("#Auction_Price").formValidator({
    //        empty: false,
    //        onShow: false,
    //        onFocus: "必须为有效数值！",
    //        onCorrect: ""
    //    }).inputValidator({
    //        min: 0.0001,
    //        onError: "拍卖价格不能为空且必须为有效数值"
    //    }).regexValidator({
    //        regExp: "num",
    //        dataType: "enum",
    //        onError: "只能输入数字或跟小数点结合！"
    //    });
    //    //拍卖价区间
    //    $("#Increase_Price").formValidator({
    //        empty: false,
    //        onShow: false,
    //        onFocus: "必须为有效数值！",
    //        onCorrect: ""
    //    }).inputValidator({
    //        min: 0.0001,
    //        onError: "拍卖价格最低价不能为空且必须为有效数值"
    //    }).regexValidator({
    //        regExp: "num",
    //        dataType: "enum",
    //        onError: "只能输入数字或跟小数点结合！"
    //    });
    //    $("#Auction_Increase_Price").formValidator({
    //        empty: false,
    //        onShow: false,
    //        onFocus: "必须为有效数值！",
    //        onCorrect: ""
    //    }).inputValidator({
    //        min: 0.0001,
    //        onError: "拍卖价格最高价不能为空且必须为有效数值"
    //    }).regexValidator({
    //        regExp: "num",
    //        dataType: "enum",
    //        onError: "只能输入数字或跟小数点结合！"
    //    });
    //库存数
    $("#StoreSum").formValidator({
        empty: false,
        onShow: false,
        onFocus: "只能输入正整数！",
        onCorrect: ""
    }).inputValidator({
        min: 1,
        max: 4,
        onError: "库存数量只能小于10000！"
    }).regexValidator({
        regExp: "intege1",
        dataType: "enum",
        onError: "只能输入正整数！"
    });
    //最低购买数
    $("#LimitSum").formValidator({
        empty: false,
        onShow: false,
        onFocus: "只能输入正整数！",
        onCorrect: ""
    }).inputValidator({
        min: 1,
        max: 4,
        onError: "如果不限制最低购买数量请输入0"
    }).regexValidator({
        regExp: "num",
        dataType: "enum",
        onError: "只能输入正整数！"
    });
    //警戒存库
    $("#StoreAlarmSum").formValidator({
        empty: false,
        onShow: false,
        onFocus: "只能输入正整数！",
        onCorrect: ""
    }).inputValidator({
        min: 1,
        max: 4,
        onError: "警戒存库数量只能小于10000！"
    }).regexValidator({
        regExp: "intege1",
        dataType: "enum",
        onError: "只能输入正整数！"
    });
    //所在地
    $("#province").formValidator({
        empty: false,
        onShow: false,
        onFocus: false,
        onCorrect: false
    }).inputValidator({
        min: 1,
        onError: "请选择所在地的省份"
    });

    //    $("#city").formValidator({
    //        empty: false,
    //        onShow: false,
    //        onFocus: false,
    //        onCorrect: false
    //    }).inputValidator({
    //        min: 1,
    //        onError: "请选择所在地的城市"
    //    });

    //    //关键属性验证
    //    if ($('#ProBrand').length > 0) {
    //        $('#ProBrand select').formValidator({
    //            empty: false,
    //            onShow: false,
    //            onFocus: false,
    //            onCorrect: false
    //        }).inputValidator({
    //            min: 1,
    //            onError: "请选择品牌"
    //        });
    //    }
    //    //普通属性
    //    if ($('#Property').length > 0) {
    //        var ems = $('#Property em');
    //        if (ems.length > 0) {
    //            ems.each(function () {
    //                //下拉框 
    //                var sel = $(this).parent().find('select');
    //                if (sel.length > 0) {
    //                    $(sel).formValidator({
    //                        empty: false,
    //                        onShow: false,
    //                        onFocus: false,
    //                        onCorrect: false
    //                    }).inputValidator({
    //                        min: 1,
    //                        onError: "请选择" + $(ems).parent().prev('label').eq(0).text().replace(':', '.')
    //                    });
    //                }
    //            });
    //        }
    //    }

}

function CheckProAttr() {
    //初始化验证控件
    $.formValidator.initConfig({
        formID: "formMain"
    });

    //关键属性验证
    if ($('#ProBrand').length > 0 && $('#ProBrand select').length > 0) {
        $('#ProBrand select').formValidator({
            empty: false,
            onShow: false,
            onFocus: "必选项",
            onCorrect: false
        }).inputValidator({
            min: 1,
            onError: "请选择品牌"
        });
    }

    //普通属性
    if ($('#Property').length > 0) {
        $('#Property li').each(function () {
            var must = $(this).find("em");
            if (must.is("em")) {
                if ($(this).find("ul.ul-select").is("ul")) {
                    var sel = $(this).find('ul.ul-select select');
                    $(sel).formValidator({
                        empty: false,
                        onShow: false,
                        onFocus: "必选项",
                        onCorrect: false
                    }).inputValidator({
                        min: 1,
                        onError: "请选择" + $(this).find('label').eq(0).text().replace('：', '.')
                    });
                }
                else if ($(this).find("ul.ul-checkbox").is("ul")) {
                    var sel = $(this).find('ul.ul-checkbox input:checkbox');
                    $(sel).formValidator({
                        tipID: $(this).find('ul.ul-checkbox div.errorMsg').attr("id"),
                        empty: false,
                        onShow: false,
                        onFocus: "你至少选择1个",
                        onCorrect: ""   //恭喜你,你选对了
                    }).inputValidator({
                        min: 1,
                        onError: "请选择" + $(this).find('label').eq(0).text().replace('：', '') + "其中之一个"
                    });
                }
                else if ($(this).find("ul.ul-text").is("ul")) {
                    var sel = $(this).find('ul.ul-text input');
                    $(sel).formValidator({
                        empty: false,
                        onShow: false,
                        onFocus: "必填项",
                        onCorrect: false
                    }).inputValidator({
                        min: 1,
                        max: 200,
                        empty: { leftEmpty: false, rightEmpty: false, emptyError: false },
                        onError: "" + $(this).find('label').eq(0).text().replace('：', '') + "不能为空！"
                    });
                }
            }
        });




        //        var ems = $('#Property em');
        //        if (ems.length > 0) {
        //            ems.each(function () {
        //                //下拉框 
        //                var sel = $(this).parent().find('select');
        //                if (sel.length > 0) {
        //                    //alert($(sel).attr("id"));
        //                    $(sel).formValidator({
        //                        empty: false,
        //                        onShow: false,
        //                        onFocus: "必选项",
        //                        onCorrect: false
        //                    }).inputValidator({
        //                        min: 1,
        //                        onError: "请选择" + $(ems).parent().prev('label').eq(0).text().replace(':', '.')
        //                    });
        //                }
        //            });
        //        }
    }
}

/*************验证 end *****************/
/*************获取商品属性的信息 begin *****************/
function GetProductProps() {
    var prop1 = "";
    var name1 = "";
    var prop2 = "";
    var name2 = "";
    var prop3 = "";
    var name3 = "";
    var prop4 = "";
    var name4 = "";
    var alias1 = "";
    var alias2 = "";
    var inputid1 = "";
    var inputid2 = "";
    var inputstr1 = "";
    var inputstr2 = "";
    //关键属性
    var liKey = $("#ulBrand > li");
    liKey.each(function () {
        var prop = "";
        var name = "";
        var lb = $(this).find('label.label-title').text();
        var propname = lb.substring(0, lb.length - 1);
        var cul = $(this).find("span").children("ul");
        if (cul.attr("class") == "ul-select") {
            var sel = $(this).find("select option:selected");
            if (sel.val() != "0") {
                prop = sel.val();
                name = sel.text();
            }
            else {
                var otherOption = $(sel).is("option[pid]");
                if (otherOption) {
                    prop = sel.attr("pid") + ":" + "0";
                    name = $("#cpi_" + sel.attr("pid")).val();
                    inputid1 += sel.attr("pid") + ";";
                    inputstr1 += name + ";";
                }
            }
        }
        else {
            var input = $(this).find(":input");
            if (input.val() != "") {
                prop = input.attr("data-attrid") + ":" + "0";
                name = input.val();
                inputid1 += input.attr("data-attrid");
                inputstr1 += input.val();
            }
        }
        if (prop != "") {
            prop1 += prop + ";";
            name1 += prop + ":" + propname + ":" + name + ";";
        }
    });
    //普通属性
    var liProperty = $("#Property > li");
    liProperty.each(function () {
        var prop = "";
        var name = "";
        var lb = $(this).children('label.label-title').text();
        var propname = lb.substring(0, lb.length - 1);
        var cul = $(this).find("span").children("ul");
        if (cul.attr("class") == "ul-select") {
            var select = $(this).find("select option:selected");
            if (select.val() != "0") {
                prop = select.val();
                name = select.text();
            }
            else {
                var otherOption = $(select).is("option[pid]");
                if (otherOption) {
                    prop = select.attr("pid") + ":" + "0";
                    name = $("#cpi_" + select.attr("pid")).val();
                    inputid2 += select.attr("pid") + ";";
                    inputstr2 += name + ";";
                }
            }
        }
        else if (cul.attr("class") == "ul-checkbox") {
            var chkprop = "";
            var chkname = "";
            var checkbox = $(this).find(":checkbox:checked");
            checkbox.each(function () {
                prop = $(this).val();
                name = $(this).next("label").text();
                chkprop += prop + ";";
                chkname += prop + ":" + propname + ":" + name + ";";
            });
            if (prop != "") {
                prop2 += chkprop;
                name2 += chkname;
            }
        }
        else if (cul.attr("class") == "ul-text") {
            var input = $(this).find(":input");
            if (input.val() != "") {
                prop = input.attr("data-attrid") + ":" + "0";
                name = input.val();
                inputid2 += input.attr("data-attrid");
                inputstr2 += input.val();
            }
        }
        if (cul.attr("class") != "ul-checkbox") {
            if (prop != "") {
                prop2 += prop + ";";
                name2 += prop + ":" + propname + ":" + name + ";";
            }
        }
    });
    //颜色属性
    if ($("#IsSale").val() == 0) {
        var trList = $("#J_ulColorTable>table>tbody>tr:visible");
        if (trList.length > 0) {
            var prop = "";
            var name = "";
            var alias = "";
            var lbText = $("#li_Color_list>label").text();
            var propName = lbText.substring(0, lbText.length - 1);
            trList.each(function () {
                var input = $(this).children("td:first-child").find(":input");
                prop = input.attr("pidvid");
                name = input.attr("oldv");
                alias = input.val() == name ? "" : prop + ":" + input.val();
                prop3 += prop + ";";
                name3 += prop + ":" + propName + ":" + name + ";";
                alias1 += alias == "" ? "" : alias + ";";
            });
        }
    }
    //销售属性
    if ($("#IsSale").val() == 1) {
        var liSale = $("#li_Property_List").find("ul>li");
        if (liSale.length > 0) {
            var cprop = "";
            var cname = "";
            var sprop = "";
            var sname = "";
            var trColor = $("#J_ulColorTable>table>tbody>tr:visible");
            var cpropname = $("#li_Color_list>label").text().substring(0, $("#li_Color_list>label").text().length - 1);
            var spropname = $("#li_Property_List>label").text().substring(0, $("#li_Property_List>label").text().length - 1);
            trColor.each(function () {
                var input = $(this).find(":input");
                cprop = input.attr("pidvid");
                cname = input.attr("oldv");
                alias = input.val() == cname ? "" : cprop + ":" + input.val();
                prop4 += cprop + ";";
                name4 += cprop + ":" + cpropname + ":" + cname + ";";
                alias2 += alias == "" ? "" : alias + ";";
            });
            liSale.each(function () {
                var ckbox = $(this).find(":checkbox");
                if (ckbox.prop('checked')) {
                    sprop = ckbox.val();
                    sname = $(this).find("#hid_" + $(ckbox).attr('datav')).attr('oldv');
                    alias = $(this).find("#hid_" + $(ckbox).attr('datav')).val() == sname ? "" : sprop + ":" + $(this).find("#hid_" + $(ckbox).attr('datav')).val();
                    prop4 += sprop + ";";
                    name4 += sprop + ":" + spropname + ":" + sname + ";";
                    alias2 += alias == "" ? "" : alias + ";";
                }

            });
        }
    }

    var propsName = name1 + name2 + name3 + name4;
    var props = prop1 + prop2 + prop3 + prop4;
    var inputPids = inputid1 + inputid2;
    var inputStr = inputstr1 + inputstr2;
    var propertyAlias = alias1 + alias2;
    $("#propsName").val(propsName);
    $("#props").val(props);
    $("#propertyAlias").val(propertyAlias);
    $("#inputPids").val(inputPids);
    $("#inputStr").val(inputStr);
}

//
function OtherInput(obj) {
    var other = $(obj).parent().parent("ul").find(".other");
    if ($(obj).val() == "0") {
        other.show();
    }
    else {
        other.hide();
    }
}
//删除属性图片
var oldProductIds = "";
var oldPhotos = "";
function DelPropImage(obj) {

    var oldProductID = $(obj).parent().find("input[oldId]").val() + ";";
    var photo = $(obj).parent().find("input[oldSrc]").val() + ";";
    if (oldProductIds.indexOf(oldProductID) == -1) {
        oldProductIds = oldProductIds + oldProductID;
        oldPhotos = oldPhotos + photo;
    }
    $("#OldProductIDs").val(oldProductIds.substring(0, oldProductIds.length - 1));
    $("#OldPhotos").val(oldPhotos.substring(0, oldPhotos.length - 1));
    $(obj).parent().find("img").remove();
    $(obj).hide();
}

/*************获取商品属性的信息 end *****************/
/*************图片预览 begin ***************/
/**** 预览 ****/
function InitPreview() {
    $('#J_PanelLocalList :file').each(function () {
        var img = $('#PreviewImage' + $(this).attr('index'));
        var file = this;
        var ip = new ImagePreview(this, img[0], {
            maxWidth: 88,
            maxHeight: 90,
            action: 'ImagePreview.ashx',
            onErr: function () {
                alert('上传失败,请检查图片是否小于2000K！');
                ResetFile(file);
            },
            onCheck: CheckPreview,
            onShow: ShowPreview
        });

        this.onchange = function () {
            img.show();
            img.parent().parent().find('.act').css('display', 'block');
            ip.preview();
            if (img.parent().parent().find("input[oldId]").length > 0) {

                var oldProductID = img.parent().parent().find("input[oldId]").val() + ";";
                var photo = img.parent().parent().find("input[oldSrc]").val() + ";";
                if (oldProductIds.indexOf(oldProductID) == -1) {
                    oldProductIds = oldProductIds + oldProductID;
                    oldPhotos = oldPhotos + photo;
                }
                $("#OldProductIDs").val(oldProductIds.substring(0, oldProductIds.length - 1));
                $("#OldPhotos").val(oldPhotos.substring(0, oldPhotos.length - 1));
            }
        };
    });
}


var exts = "jpg|gif|bmp|png|jpeg", paths = "|";
function CheckPreview() {
    var value = this.file.value, check = true;
    if (!value) {
        check = false;
        alert("请先选择文件！");
    }
    else
        if (!RegExp("\.(?:" + exts + ")$$", "i").test(value)) {
            check = false;
            alert("只能上传以下类型：" + exts);
        }
        else
            if (paths.indexOf("|" + value + "|") >= 0) {
                check = false;
                alert("已经有相同文件！");
            }

    check || ResetFile(this.file);
    return check;
}

//显示预览
function ShowPreview() {
}

function ResetFile(file) {
    $(file).parents('li:first').find('.preview').removeAttr('style');
    file.value = ""; //ff chrome safari
    if (file.value != "") {
        if ($$B.ie) {//ie
            with (file.parentNode.insertBefore(document.createElement('form'), file)) {
                appendChild(file);
                reset();
                removeNode(false);
            }
        }
        else {//opera
            file.type = "text";
            file.type = "file";
        }
    }
}
/**** 图片移动 ****/
function ActImage() {
    $('.act > .left').click(function () {//左边
        var li = $(this).parent().parent();
        if (li.is('.f')) {
            return;
        }

        if (li.prev().is('.f')) {
            li.addClass('f').prev().removeClass('f');
        }

        if (li.is('.l')) {
            li.removeClass('l').prev().addClass('l');
        }

        var temp1 = "#p" + li.prev().attr('id'); //前面
        var temp2 = "#p" + li.attr('id');        //当前

        var m = li.prev().attr('id').replace(/\D/g, ""); //前面
        var n = li.attr('id').replace(/\D/g, ""); //当前

        var OrderIndex1 = "#orderIndex" + m; //前面
        var OrderIndex2 = "#orderIndex" + n; //当前

        li.prev().before(li);
        var temp1Value = $(temp1).attr("name");
        var temp2Value = $(temp2).attr("name");
        //$(temp1).attr("name", temp2Value);
        //$(temp2).attr("name", temp1Value);

        var OrderIndex1Value = $(OrderIndex1).attr("name");
        var OrderIndex2Value = $(OrderIndex2).attr("name");
        //$(OrderIndex1).attr("name", OrderIndex2Value).val(1 * $(OrderIndex1).val() + 1);
        //$(OrderIndex2).attr("name", OrderIndex1Value).val(1 * $(OrderIndex2).val() - 1);

        $(OrderIndex1).val(1 * $(OrderIndex1).val() + 1);
        $(OrderIndex2).val(1 * $(OrderIndex2).val() - 1);

    });

    $('.act > .right').click(function () {//右边
        var li = $(this).parent().parent();
        if (li.is('.l')) {
            return;
        }

        if (li.next().is('.l')) {
            li.addClass('l').next().removeClass('l');
        }

        if (li.is('.f')) {
            li.removeClass('f').next().addClass('f');
        }

        var temp2 = "#p" + li.next().attr('id'); //后面
        var temp1 = "#p" + li.attr('id');        //当前

        var m = li.next().attr('id').replace(/\D/g, ""); //后面
        var n = li.attr('id').replace(/\D/g, ""); //当前

        var OrderIndex1 = "#orderIndex" + m; //后面
        var OrderIndex2 = "#orderIndex" + n; //当前

        li.next().after(li);
        var temp1Value = $(temp1).attr("name");
        var temp2Value = $(temp2).attr("name");
        //$(temp1).attr("name", temp2Value);
        //$(temp2).attr("name", temp1Value);

        var OrderIndex1Value = $(OrderIndex1).attr("name");
        var OrderIndex2Value = $(OrderIndex2).attr("name");
        //$(OrderIndex1).attr("name", OrderIndex2Value).val(1 * $(OrderIndex1).val() - 1);
        //$(OrderIndex2).attr("name", OrderIndex1Value).val(1 * $(OrderIndex2).val() + 1);

        $(OrderIndex1).val(1 * $(OrderIndex1).val() - 1);
        $(OrderIndex2).val(1 * $(OrderIndex2).val() + 1);

    });

    $('.act > .del').click(function () {
        var imgLength = 0;
        $("#J_PanelLocalList>li").each(function () {
            //alert($(this).html());
            var src = $(this).find("div.preview>img").attr("src");
            if (src == undefined || src == "" || src.indexOf("/zh_CN/default/images/preview.jpg") > -1) {
                imgLength = imgLength + 1;
            }
        });
        if (imgLength == 4) {
            alert("图片至少一张！");
            return;
        }
        var li = $(this).parent().parent();
        ResetFile(li.find(':file')[0]);
        li.find('img').removeAttr('src').removeAttr('style').hide();
        $(this).parent().css('display', 'none');
        if (li.find("input[oldId]").length > 0) {
            var oldProductID = li.find("input[oldId]").val() + ";";
            var photo = li.find("input[oldSrc]").val() + ";";
            if (oldProductIds.indexOf(oldProductID) == -1) {
                oldProductIds = oldProductIds + oldProductID;
                oldPhotos = oldPhotos + photo;
            }
            li.find("input[oldSrc]").val("");
        }
        $("#OldProductIDs").val(oldProductIds.substring(0, oldProductIds.length - 1));
        $("#OldPhotos").val(oldPhotos.substring(0, oldPhotos.length - 1));
    });
}
/**** 图片移动 ****/
/*************图片预览 end ***************/
/*************商品颜色与销售属性 begin ***************/
function BindColorSale() {
    //颜色
    if ($("#li_Color_list").is("li")) {
        $("#J_ul-color>li.J_more>a").click(function () {
            $("#J_ul-color>li:hidden").show();
            $("#J_ul-color>li.J_more").hide();
        });

        var allInput = "#J_ul-color>li:not(.J_all)>input";
        var lastInput = "#J_ul-color>li.J_all>input";
        $(allInput).bind("change", function () {

            //如果出现俩种销售属性，但没有颜色
            if ($("#J_ulColorTable").is("div")) {
                if ($("#J_ul-color input[datav]:checked").length > 0) {
                    $("#J_ulColorTable>table").show();
                }
                else {
                    $("#J_ulColorTable>table").hide();
                }
                if ($(this).prop("checked")) {
                    $("#sp_J_ul-color_" + $(this).attr("dataV")).show();
                    if ($('#IsSale').val() == '0') {
                        $("#sp_J_ul-color_" + $(this).attr("dataV")).children('td').eq(1).find(':input').eq(0).val('1');
                    }
                }
                else {
                    $("#sp_J_ul-color_" + $(this).attr("dataV")).hide();
                    if ($('#IsSale').val() == '0') {
                        $("#sp_J_ul-color_" + $(this).attr("dataV")).children('td').eq(1).find(':input').eq(0).val('0');
                    }
                }
            }

            if ($("#li_Property_List").is("li")) {
                var taocan = $("ul.ul-checkbox>li>input:checked");
                var tr_show;
                var sale_body = $("#J_sell-table>table>tbody");
                for (var i = 0; i < taocan.length; i++) {
                    tr_show = $(this).attr("dataV") + ";" + $(taocan[i]).attr("dataV");
                    if ($(this).prop("checked")) {
                        sale_body.find("tr[data-value='" + tr_show + "']").show();
                        sale_body.find("tr[data-value='" + tr_show + "']").children('td').eq(2).find(':input').eq(0).val('1');
                    }
                    else {
                        sale_body.find("tr[data-value='" + tr_show + "']").hide();
                        sale_body.find("tr[data-value='" + tr_show + "']").children('td').eq(2).find(':input').eq(0).val('0');
                    }
                }
            }
            AddOrRemoveClass();
        });


        if ($("#J_ulColorTable").is("div")) {
            //全部选中或选中取消
            $(lastInput).change(function () {
                $(allInput).prop("checked", $(this).prop("checked"));
                if ($(this).prop("checked")) {
                    $("#J_ulColorTable>table").show();
                    $("#J_ulColorTable>table tr").show();
                }
                else {
                    $("#J_ulColorTable>table").hide();
                    $("#J_ulColorTable>table tr").hide();
                }
                if ($("#li_Property_List").is("li")) {
                    var taocan = $("#li_Property_List ul.ul-checkbox>li>input:checked");
                    var tr_show;
                    var sale_body = $("#J_sell-table>table>tbody");
                    for (var i = 0; i < taocan.length; i++) {
                        var color = $("#J_ul-color>li>input");
                        for (var iii = 0; iii < color.length; iii++) {
                            tr_show = $(color[iii]).attr("dataV") + ";" + $(taocan[i]).attr("dataV");
                            if ($(this).prop("checked")) {
                                sale_body.find("tr[data-value='" + tr_show + "']").show();
                                sale_body.find("tr[data-value='" + tr_show + "']").children('td').eq(2).find(':input').eq(0).val('1');
                            }
                            else {
                                sale_body.find("tr[data-value='" + tr_show + "']").hide();
                                sale_body.find("tr[data-value='" + tr_show + "']").children('td').eq(2).find(':input').eq(0).val('0');
                            }
                        }
                    }
                }
                AddOrRemoveClass();
            });
        }
    }

    //销售属性
    if ($("#li_Property_List").is("li")) {

        $("#li_Property_List ul.ul-checkbox>li>input:checkbox").bind("change", function () {
            if ($(this).attr("isdefine") == "1" && $(this).prop("checked")) {
                var thisInput = $(this);
                var thisVlau = $(this).next().val();
                $(this).next().removeAttr("disabled");
                //绑定失去焦点的时候修改对应ID的值
                $(this).next().blur(function () {
                    var reg = /^[\w\u4e00-\u9fa5\(\)\/]+$/;
                    if (!reg.test($(this).val())) {
                        alert("此处只允许中文字母数字下划线且不能为空！");
                        $(this).val(thisVlau);
                    }
                    $("#J_sell-table>table tr>td[data-sku='" + thisInput.attr("dataV") + "']").text($(this).val());
                });
            }
            else if ($(this).attr("isdefine") == "1") {
                $(this).next().prop("disabled", "disabled"); //----prop
            }

            var sale_body = $("#J_sell-table>table>tbody");
            if ($("#J_ul-color").is("ul")) {
                var color = $("#J_ul-color>li[class!='J_all c-all']>input:checked");
                var tr_show;
                for (var i = 0; i < color.length; i++) {
                    tr_show = $(color[i]).attr("dataV") + ";" + $(this).attr("dataV");
                    if ($(this).prop("checked")) {
                        sale_body.find("tr[data-value='" + tr_show + "']").show();
                        sale_body.find("tr[data-value='" + tr_show + "']").children('td').eq(2).find(':input').eq(0).val('1');
                    }
                    else {
                        sale_body.find("tr[data-value='" + tr_show + "']").hide();
                        sale_body.find("tr[data-value='" + tr_show + "']").children('td').eq(2).find(':input').eq(0).val('0');
                    }
                }
            }
            else {
                tr_show = $(this).attr("dataV");
                if ($(this).prop("checked")) {
                    sale_body.find("tr[data-value='" + tr_show + "']").show();
                    sale_body.find("tr[data-value='" + tr_show + "']").children('td').eq(1).find(':input').eq(0).val('1');
                }
                else {
                    sale_body.find("tr[data-value='" + tr_show + "']").hide();
                    sale_body.find("tr[data-value='" + tr_show + "']").children('td').eq(1).find(':input').eq(0).val('0');
                }
            }
            AddOrRemoveClass();
        });
    }

    $("#li_Property_List ul.ul-checkbox>li>input:checkbox:checked").each(function () {
        var thisInput = $(this);
        var thisVlau = $(this).next().val();
        //绑定失去焦点的时候修改对应ID的值
        $(this).next().blur(function () {
            var reg = /^[\w\u4e00-\u9fa5\(\)\/]+$/;
            if (!reg.test($(this).val())) {
                alert("此处只允许中文字母数字下划线且不能为空！");
                $(this).val(thisVlau);
                //return false;
            }
            $("#J_sell-table>table tr>td[data-sku='" + thisInput.attr("dataV") + "']").text($(this).val());
        });
    });
}


//特性
function AddOrRemoveClass() {
    if ($("#J_ul-color input[datav]:checked").length > 0 && $("#li_Property_List input:checkbox:checked").length > 0) {
        $("#J_sell-table").show();
    }
    else if ($("#J_ul-color input[datav]").length == 0 && $("#li_Property_List input:checkbox:checked").length > 0) {
        $("#J_sell-table").show();
    }
    else {
        $("#J_sell-table").hide();
    }
    //    alert($("#J_sell-table>table>tbody>tr:visible").length);返回不正常
    //    if ($("#J_sell-table>table>tbody>tr:visible").length == 0) {
    //        $("#J_sell-table").hide();
    //    }
    //    else {
    //        $("#J_sell-table").show();
    //    }
}

function calQprice(obj) {
    if (obj.value == "") {
        return;
    }
    var reg = /^[0-9\.]+$/;
    if (!reg.test(obj.value)) {
        alert("价格必须为数字！");
        obj.value = "";
        return false;
    }
}

function calQ(obj) {
    var reg = /^[0-9\.]+$/;
    if (!reg.test(obj.value)) {
        obj.value = 1;
    }
    var ProNum = 0;
    $("#J_sell-table>table>tbody>tr:visible").each(function () {
        var num = $(this).find("input:[id^='sale_q_']").val();
        if (num == "")
            num = 0;

        ProNum = parseInt(ProNum) + parseInt(num);
    });
    $("#StoreSum").val(ProNum);
    return true;
}

//颜色数量改变的时候触发
function calQColorNum(obj) {
    var reg = /^[0-9\.]+$/;
    if (!reg.test(obj.value)) {
        obj.value = 1;
        return false;
    }
    var ProNum = 0;
    $("#J_ulColorTable>table>tbody>tr:visible").each(function () {
        var num = $(this).find("input:[name$='Quantity']").val();
        if (num == "")
            num = 0;

        ProNum = parseInt(ProNum) + parseInt(num);

    });
    $("#StoreSum").val(ProNum);
    return true;
}

function changeColorName(val, obj) {
    var reg = /^[\w\u4e00-\u9fa5\/]+$/;
    if (!reg.test(obj.value)) {
        alert("颜色名称不能为空且只允许中文字母数字下划线！");
        obj.value = val;
        return false;
    }
}
function fillSkuPrice(obj, Str) {
    if ($("#li_Color_list").is("li") && $("#li_Property_List").is("li")) {
        var price = $("#J_sell-table>table>tbody>tr");
        price.each(function () {
            var P = $(this).find("td:eq(2)>input:text")
            if (P.val() == "" || P.val() == 0) {
                P.val(obj.value)
            }
        });
    }
    else if ($("#li_Color_list").is("li") && !$("#li_Property_List").is("li")) {
        var price = $("#J_ulColorTable>table>tbody>tr");
        price.each(function () {
            var P = $(this).find("td:eq(1)>input:text")
            if (P.val() == "" || P.val() == 0) {
                P.val(obj.value)
            }
        });
    }
    else if (!$("#li_Color_list").is("li") && $("#li_Property_List").is("li")) {
        var price = $("#J_sell-table>table>tbody>tr");
        price.each(function () {
            var P = $(this).find("td:eq(1)>input:text")
            if (P.val() == "" || P.val() == 0) {
                P.val(obj.value)
            }
        });
    }

    return true;
}
/*************商品颜色与销售属性 end *****************/