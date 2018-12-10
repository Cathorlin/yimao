function ReadCardForQuery(ctrl) {
    // Read_CardInfo
    var CardCtl = document.getElementById("CardCtl");
    var cardinfo = "-1";
    //alert(CardCtl);
    if (CardCtl != null) {

        try {

            CardCtl.Read_CardInfo();
            cardinfo = CardCtl.ReadInfo;

            if (CardCtl.status != 0) {
                alert("读卡失败,请检查卡片是否正确插入！")
                return "-1";
            }
        }
        catch (err) {
            alert("读卡信息失败" + err.description);
            cardinfo = "-1";
            return "-1";
        }

    }
    var info_list = cardinfo.split("|");

    if (info_list.length > 0) {
        document.getElementById(ctrl).value = info_list[0];
    }

}
//function Read_CardInfo() {

//    CardCtl.Read_CardInfo();
//    Status1.value = CardCtl.status;
//    if (CardCtl.status == 0) {
//        readinfo.value = CardCtl.ReadInfo;
//    }
//}