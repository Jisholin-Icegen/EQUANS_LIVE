var PorterID = '', TagID = '', CurTagID = '';
function Assign(Continue) {
    var Porterdisplay = $("#PorterHolder").css("display"),
        Tagdisplay = $("#TagHolder").css("display");

    if (Porterdisplay == 'none')
        GetRecords(0);
    else if (Tagdisplay == 'none')
        GetRecords(1);
    else if (Continue) {
        if ((!PorterName) || (PorterName && confirm('Press ok if you are sure to change Porter.'))) {
            HideModalPopUp('ModalLoading');
            ShowModalPopUp('ModalDone');
            PorterAssign();
        } else
            HideModalPopUp('ModalLoading');

    }
}
function CloseDone() {
    $('#DrpPorter').focus();
    $('#DrpPorter').val('0');
    $('#DrpMacId').val('0'); $('#ErrorSpan').html('');
    $find('mpDone').hide();
}
function PorterAssign() {
    var shiftID = $("#DrpShift").val();
    $.ajax({
        async: true,
        url: url + "PROCESS=PORTERMAPPING&PORTERID=" + PorterID + "&TAGID=" + TagID + "&SHIFTEND=" + ((PorterName.length > 0) ? "TRUE" : "FALSE") + "&SHIFTID=" + shiftID,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (msg) {
            if (msg[0].RESULT === 'TRUE') {
                $('#ErrorSpan').text('');
                ClearSelection();
                setTimeout("HideModalPopUp('ModalDone');", 1500);

            }
        },
        error: function (msg) {
            alert(msg.length);
        }

    });
}
function CloseandBind(ID, Value, Modal, Photo) {
    HideModalPopUp(Modal);
    switch (Modal) {
        case "ModalPorter":
            var PorterImg = (Photo.length > 0) ? 'url("' + Photo + '")' : "none !important";
            $('#DivPorterHolder').css("background-image", "none !important");
            $('#DivPorterHolder').css("background-color", "none !important");
            $('#PorterHolder').css("display", "inline-block !important");
            $('#PorterName').text(Value); $('#PorterImage').css("background-image", PorterImg);
            PorterID = ID.split("-")[0];
            //if (CurTagID.length > 0)
            //  ShowStatus(CurTagID);
            break;
        case "ModalTag":
            $('#DivTagHolder').css("background-image", "none !important");
            $('#DivTagHolder').css("background-color", "none !important");
            $('#TagHolder').css("display", "inline-block !important");
            $('#TagNo').text(Value);
            TagID = ID.split("-")[0];
            CurTagID = ID;
            ShowStatus(ID);
            break;
    }
    Assign(false);
}

function ClearSelection() {
    var DivPorterHolder = $('#DivPorterHolder'), PorterHolder = $('#PorterHolder'),
        DivTagHolder = $('#DivTagHolder'), TagHolder = $('#TagHolder');
    $(DivPorterHolder).css("background-image", "url(Images/Porter.PNG)");
    $(DivPorterHolder).css("background-color", "rgb(30, 70, 129)");
    $(PorterHolder).css("display", "none");

    $(DivTagHolder).css("background-image", "url('Images/WIfiTag.PNG')");
    $(DivTagHolder).css("background-color", "rgb(30, 70, 129)");
    $(TagHolder).css("display", "none");

    $('#PorterName').text('');
    $('#TagNo').text('');
    CurTagID = '';
}
function GetRecords(status) {
    Tagdisplay = $("#TagHolder").css("display");
    $.ajax({
        async: false,
        url: url + "PROCESS=GETMAPRECORDS&STATUS=" + status + "&PORTERNAME=" + status,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (msg) {
            var Table = "<table width='95%' cellpadding='5' cellspacing='5' style='border-collapse: separate;'><tr>", i = 1;

            $.each(msg, function (key, value) {

                switch (status) {
                    case 0:
                        var Photo = (value.PHOTO.length > 0) ? value.PHOTO : 'Images/DefaultPorter.PNG';
                        Table += "<td align='center'>" + "<table onclick='CloseandBind(" + '"' + value.ID + '"' + ',"' + value.VAL + '"' + ',"ModalPorter"' + ',"' + Photo + '"' + ");' class='PorterList'> <tr style='height: 20px; background-color: rgb(30, 70, 129);'><td align='center'><span style='color:white;font-family: monospace; font-size: 12px;'>" + value.VAL + "</span></td></tr><tr><td style='background-repeat: no-repeat;background-size: 98% 98%; background-position: center;background-image: url(" + Photo + ");'></td></tr></table>" + "</td>"
                        Table += (i == 3) ? "</tr><tr>" : ""; i = (i == 3) ? 1 : i + 1;
                        break;
                    case 1:
                        var val = value.ID, Onloadtagid = ((val == '0') ? '' : val.split("-")[0]), Onloadtoday = (new Date().getMonth() + 1) + '/' + new Date().getDate() + '/' + new Date().getFullYear(),
                            OnloadPorterName = ((val == '0') ? '' : val.split("-")[1]), OnloadStartTime = Onloadtoday + " " + ((val == '0') ? '' : val.split("-")[2].split("_")[0]),
                            OnloadEndTime = Onloadtoday + " " + ((val == '0') ? '' : val.split("-")[2].split("_")[1]);
                        var IsAssignedTag = ((OnloadPorterName) && (new Date(OnloadStartTime) <= new Date() && new Date(OnloadEndTime) >= new Date()))
                        Table += "<td align='center'>" + "<table onclick='CloseandBind(" + '"' + value.ID + '"' + ',"' + value.VAL + '"' + ',"ModalTag"' + ");' class='" + ((IsAssignedTag) ? "TagListAssigned" : "TagList") + "'> <tr ><td align='center' style='vertical-align:middle;'><span class='TagNo'>" + value.VAL + "</span></td></tr></table></td>"
                        Table += (i == 3) ? "</tr><tr>" : ""; i = (i == 3) ? 1 : i + 1;
                        break;
                }
            });
            Table += "</tr></table>";
            $('#' + ((status == '0') ? 'DivPorterContent' : 'DivTagContent')).html(Table);
            if (Tagdisplay == 'none') {
                $('#ErrorSpan').html(''); CurTagID = '';
            }
            HideModalPopUp('ModalLoading');
            ShowModalPopUp((status == '0') ? "ModalPorter" : "ModalTag");
            if (status == '0') {
                $('#txtPorterName').val(''); setTimeout("$('#txtPorterName').focus()", 500);
            }
        },
        error: function (msg) {
            alert(msg.length);
        }

    });
}
function ShowShift() {
    var PortVal = $("#DrpPorter").val(), ShiftId = PortVal.split("-")[3],
                today = (new Date().getMonth() + 1) + '/' + new Date().getDate() + '/' + new Date().getFullYear(),
                STime = today + " " + ((PortVal == '0') ? '' : PortVal.split("-")[2].split("_")[0]),
                ETime = today + " " + ((PortVal == '0') ? '' : PortVal.split("-")[2].split("_")[1]);
    if (new Date(STime) <= new Date() && new Date(ETime) >= new Date()) {
        $('#PorterSpan').css("color", "Green");
        $('#PorterSpan').html(ShiftId);
    }
    else {
        $('#PorterSpan').css("color", "red");
        if (PortVal != '0')
            $('#PorterSpan').html(ShiftId);
        else
            $('#PorterSpan').html('');
    }
}
function ShowStatus(val) {
    tagid = ((val == '0') ? '' : val.split("-")[0]), today = (new Date().getMonth() + 1) + '/' + new Date().getDate() + '/' + new Date().getFullYear(),
                PorterName = ((val == '0') ? '' : val.split("-")[1]), StartTime = today + " " + ((val == '0') ? '' : val.split("-")[2].split("_")[0]),
                EndTime = today + " " + ((val == '0') ? '' : val.split("-")[2].split("_")[1]);
    if (!PorterName) {
        if (val !== '0')
            $('#ErrorSpan').html('TAG STATUS : AVAILABLE');
        else
            $('#ErrorSpan').html('');
    } else {
        if (new Date(StartTime) <= new Date() && new Date(EndTime) >= new Date())
            $('#ErrorSpan').html('TAG STATUS : ASSIGNED TO ' + PorterName);

        else
            $('#ErrorSpan').html('TAG STATUS : AVAILABLE , PREVIOUS PORTER : ' + PorterName);

    }

    // alert($('#ErrorSpan').html());
}

function OnchangePorter(InputID, ContainerID) {
    var SearchVal = $('#' + InputID).val();
    $.ajax({
        async: true,
        url: url + "PROCESS=GETPORTER&PORTERNAME=" + SearchVal,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (msg) {
            var Table = "<table width='95%' cellpadding='5' cellspacing='5' style='border-collapse: separate;'><tr>", i = 1;

            $.each(msg, function (key, value) {
                var Photo = (value.PHOTO.length > 0) ? value.PHOTO : 'Images/DefaultPorter.PNG';
                Table += "<td align='center'>" + "<table onclick='CloseandBind(" + '"' + value.ID + '"' + ',"' + value.VAL + '"' + ',"ModalPorter"' + ',"' + Photo + '"' + ");' class='PorterList'> <tr style='height: 20px; background-color: rgb(30, 70, 129);'><td align='center'><span style='color:white;font-family: monospace; font-size: 12px;'>" + value.VAL + "</span></td></tr><tr><td style='background-repeat: no-repeat;background-size: 98% 98%; background-position: center;background-image: url(" + Photo + ");'></td></tr></table>" + "</td>"
                Table += (i == 3) ? "</tr><tr>" : ""; i = (i == 3) ? 1 : i + 1;

            });
            Table += "</tr></table>";
            $('#' + ContainerID + '').html(Table);

        },
        error: function (msg) {
            alert(msg.length);
        }

    });
}

function LoadShift() {
    $.ajax({
        async: true,
        url: url + "PROCESS=GETSHIFT",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            $('#DrpShift').find('option').remove().end();
            $.each(data, function (i, item) {
                $("#DrpShift").append($("<option/>").val(data[i].ID).text(data[i].SHIFTNAME));
            });
        },
        error: function (data) {

        }
    });
}
function ShowModalPopUp(ModalId) {
    $('#' + ModalId).modal('show');
}
function HideModalPopUp(ModalId) {
    $('#' + ModalId).modal('hide');
}

function Redirect(RedirectTo) {
    window.location = RedirectTo;
}