var ETPorterID = '', ETTSec = '';
function ShowPorter() {
    $.ajax({
        async: true,
        url: TrackUrl + "Process=PORTERWITHLOCAITON&NAME=" + $('#PName').val(),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (typeof (grid) != 'undefined' && grid != null) {
                tableView = grid.get_masterTableView();
                tableView.set_dataSource(data);
                tableView.dataBind();
            }
        },
        error: function (data) {

        }

    });
}

function setFocus(Id) {
    $('#' + Id).focus();
}

function OnchangeMessage(ele) {
    var selectedValue = $(ele).val();
    $("#TextMessage").css("display", ((selectedValue == "0") ? "inline-block" : "none"))
}
function MsgAll() {
    $('#TextMessage').val('');
    $('#MessageTo').text('ALL');
    ShowModalPopUp('ModalMessage');
    setTimeout("setFocus('TextMessage');", 500);
}

function OnBreakReason(ele) {
    var selectedValue = $(ele).val();
    BTime = selectedValue.split("_")[1]; $('#BreakTime').val(BTime);
    $("#txtBreakReason").css("display", ((selectedValue == "0") ? "inline-block" : "none"))
    $('#BreakTime').attr('readonly', ((selectedValue == "0") ? false : true));
    setTimeout(function () { $("#BreakTime").focus(); }, 500);
}
function PorterBreak() {
    var selValue = $("#drpBreakReason").val();

    var Reason = (selValue == "0") ? $("#txtBreakReason").val() : $("#drpBreakReason option:selected").text();
    var BTime = $('#BreakTime').val();
    if (BTime.length == 0) {
        $('#BreakTime').css('background-color', '#ff7171'); setTimeout(function () {
            $('#BreakTime').css('background-color', 'white');
            $('#BreakTime').focus();
        }, 2500)
    }
    else if ((selValue == "0") && ($("#txtBreakReason").val().length == 0)) {
        $('#txtBreakReason').css('background-color', '#ff7171'); setTimeout(function () {
            $('#txtBreakReason').css('background-color', 'white');
            $('#txtBreakReason').focus();
        }, 2500)
    }
    else {

        ShowModalPopUp('ModalLoading');
        HideModalPopUp('ModalBreak');
        $.ajax({
            async: true,
            url: Turl + "Process=BREAK&PORTERID=" + BPorterID + "&TAGID=" + BTagID + "&MINUTES=" + BTime + "&REASON=" + Reason,
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {
                if (data[0].RESULT === 'TRUE') {
                    HideModalPopUp('ModalLoading');
                    ShowModalPopUp('ModalDone');
                    setTimeout("HideModalPopUp('ModalDone')", 1500);
                    LoadGrid();
                }
                else {
                    $('#spErrormessage').text('NO MORE BREAKS FOR THIS PORTER.');
                    HideModalPopUp('ModalLoading');
                    ShowModalPopUp('ModalErrorMsg'); setTimeout("HideModalPopUp('ModalErrorMsg');", 2000);
                }

                BPorterID = ''; BTime = ''; BTagID = '';
            },
            error: function (data) {

            }

        });
    }



}
function RowCreated(sender, args) {
    args.get_item().get_cell('MESSAGE').onclick = function () {
        var Name = args.get_item().getDataKeyValue("NAME"); TagID = args.get_item().getDataKeyValue("TAGID"); PtrId = args.get_item().getDataKeyValue("PORTERID");
        $('#TextMessage').val('');
        $('#MessageTo').text(Name);
        ShowModalPopUp('ModalMessage');
        setTimeout("setFocus('TextMessage');", 500);

    };
  args.get_item().get_cell('BREAK').onclick = function () {
        var ECell = args.get_item().get_cell('BREAK'), Value = $(ECell).html();
        if (Value == "-")
            return;
        else {
            ShowModalPopUp('ModalLoading');
            var PorterId = args.get_item().getDataKeyValue("PORTERID");
            $.ajax({
                async: true,
                url: TrackUrl + "Process=BREAK&PORTERID=" + PorterId + "",
                type: 'POST',
                data: 'pData',
                dataType: 'json',
                success: function (data) {
                    if (data[0].RESULT === 'TRUE')
                        LoadGrid();
                    else {
                        $('#spErrormessage').text('NO MORE BREAKS FOR THIS PORTER.');
                        ShowModalPopUp('ModalErrorMsg'); setTimeout("HideModalPopUp('ModalErrorMsg');", 2000);
                    }
                    HideModalPopUp('ModalLoading');
                },
                error: function (data) {

                }

            });
        }
    };
    args.get_item().get_cell('BUZZER').onclick = function () {
        var Name = args.get_item().getDataKeyValue("NAME"); TagID = args.get_item().getDataKeyValue("TAGID");
        ShowModalPopUp('ModalDone');
        $.ajax({
            async: true,
            url: TrackUrl + "Process=BUZZER" + "&TAGID=" + TagID + "",
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {
                if (data[0].RESULT === 'TRUE') {
                    setTimeout("HideModalPopUp('ModalDone');", 1000);
                }
            },
            error: function (data) {

            }

        });
    };
    args.get_item().get_cell('LOCATE').onclick = function () {
        var LTagId = args.get_item().getDataKeyValue("TAGID"), PName = args.get_item().getDataKeyValue("NAME"),
            wind = window.open('Popup.aspx?TagId=' + LTagId + "&Name=" + PName, 'TRACKING : #' + PName, 'directories=no,titlebar=yes,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=770');
    };

    //args.get_item().get_cell('LOCATEGPS').onclick = function () {
    //    var LTagId = args.get_item().getDataKeyValue("TAGID"), PName = args.get_item().getDataKeyValue("NAME"),
    //        wind = window.open('PopupGPS.aspx?TagId=' + LTagId + "&Name=" + PName, 'TRACKING : #' + PName, 'directories=no,titlebar=yes,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=770');
    //};

    args.get_item().get_cell('ENDSHIFT').onclick = function () {
        var ECell = args.get_item().get_cell('ENDSHIFT'), Value = $(ECell).html();
        if (Value == "ON-HOLD")
            return;
        else {
            var ETagId = args.get_item().getDataKeyValue("TAGID");
            if (confirm('Press ok if you are sure to end the shift.')) {
                ShowModalPopUp('ModalLoading');
                $.ajax({
                    async: true,
                    url: Turl + "Process=SHIFTEND" + "&TAGID=" + ETagId + "",
                    type: 'POST',
                    data: 'pData',
                    dataType: 'json',
                    success: function (data) {
                        if (data[0].RESULT === 'TRUE') {
                            ShowModalPopUp('ModalDone'); setTimeout("HideModalPopUp('ModalDone');", 1500);
                        }
                        else {
                            $('#spErrormessage').text('ASSIGNED TASKS NOT YET COMPLETED.');
                            ShowModalPopUp('ModalErrorMsg'); setTimeout("HideModalPopUp('ModalErrorMsg');", 2000);
                        }
                        HideModalPopUp('ModalLoading');
                    },
                    error: function (data) {

                    }

                });
            }
        }
    };
}
function ShowMessage() {

    $find('mpDone').show();
    setTimeout("MsgDone();", 1000);
}
function DataBound(sender, args) {
    var IsBreak = args.get_item().getDataKeyValue("ISBREAK"), cellBreak = args.get_item().get_cell('BREAK'),
        cellBuzzer = args.get_item().get_cell('BUZZER'), cellLocate = args.get_item().get_cell('LOCATE'),
        cellMessage = args.get_item().get_cell('MESSAGE'), EndHold = args.get_item().getDataKeyValue("ENDHOLD"),
        cellEnd = args.get_item().get_cell('ENDSHIFT'), cellEndTime = args.get_item().get_cell('ENDTIME');
        //cellStatus = args.get_item().get_cell('STATUS'), cellLocateGPS = args.get_item().get_cell('LOCATEGPS');
    var TEndTime = args.get_item().getDataKeyValue("ENDTIME"), TPID = args.get_item().getDataKeyValue("PORTERID"),
        TPName = args.get_item().getDataKeyValue("NAME"), Status = args.get_item().getDataKeyValue("STATUS"),
        imgEdit = $('<img src="Images/Edit.png" style="cursor:pointer;margin-left:10px;vertical-align:middle" >');
    if ((TEndTime !== '-') && (TEndTime !== 'ON-HOLD')) {
        $($(cellEndTime)).append($(imgEdit));
        $(imgEdit).click(function () {
            //alert("TEndTime , TPID , TPName  : " + TEndTime + " ,  " + TPID + " ,  " + TPName);
            var Edt = new Date(), SHour = Edt.getHours(),
                ETime = TEndTime.split(':')[0] + ':' + TEndTime.split(':')[1]; ETPorterID = TPID;
            $('#PorName').text(TPName);
            $('#txtReqTime').val(ETime);
  ShowModalPopUp("ModalCancel");
        });
    } /*
    if (Status == 'ACTIVE' || Status == 'SHIFT ENDED') {
        $(cellStatus).css("background-color", "red").css("color", "white").css("font-weight", "bold");
    }
    else if (Status == 'IN BREAK' || Status == 'AWAITING BREAK') {
        $(cellStatus).css("background-color", "yellow").css("color", "black").css("font-weight", "bold");
    }
    else
        $(cellStatus).css("background-color", "green").css("color", "white").css("font-weight", "bold");*/

    if (EndHold == '1') {
        $(cellEnd).html('ON-HOLD');
        $(cellBreak).html('-').css("cursor", "text");
    }
    else {
        $($(cellEnd).find('img')[0]).css("cursor", "pointer");
        if (IsBreak)
            $(cellBreak).html('<img src="Images/Checked.png" width="20" height="20">')
        else
            $(cellBreak).html('<img src="Images/Unchecked.png" width="20" height="20">')
    }
    //$($(cellEndTime)).css("cursor", "pointer");
    $($(cellBreak).find('img')[0]).css("cursor", "pointer");
    $($(cellBuzzer).find('img')[0]).css("cursor", "pointer");
    $($(cellMessage).find('img')[0]).css("cursor", "pointer");
    $($(cellLocate).find('img')[0]).css("cursor", "pointer");

    /*$($(cellLocateGPS).find('img')[0]).css("cursor", "pointer");*/
}
function BuzzerAll() {
    ShowModalPopUp('ModalLoading');
    $.ajax({
        async: true,
        url: Turl + "Process=BUZZERALL",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT === 'TRUE') {
                ShowModalPopUp('ModalDone');
                setTimeout("HideModalPopUp('ModalDone');", 2000);
            }
            HideModalPopUp('ModalLoading');
        },
        error: function (data) {

        }

    });
}
function SendMessage() {
    var Name = sessionStorage.getItem('NAME').toUpperCase(), MessageTo = $('#TextMessage').val();
    alert(MessageTo);
    if (MessageTo == '') { $('#TextMessage').focus(); return; }
    var Message = Name + '  : ' + MessageTo.replace(/\?/g, '^').replace(/\&/g, '~');
        

   
        
    $.ajax({
        async: true,
        url: TrackUrl + "Process=" + 'SENDMESSAGE&MODE=INSERT' + "&DeviceId=" + TagID + "&MESSAGE= " + Message + "&UserId=" + sessionStorage.getItem('ID') + "&PorterId=" + PtrId,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT === 'TRUE') {
                HideModalPopUp('ModalMessage');
            }
        },
        error: function (data) {

        }

    });
}
function MsgDone() {
    $find('MPWait').hide();
    setTimeout("hideMPDone();", 1000);
}

function ShowModalPopUp(ModalId) {
    $('#' + ModalId).modal('show');
    if (ModalId == 'ModalLoading') {
        clearInterval(Reload);

        //alert('Show :-' + ModalId);
    }

}
function HideModalPopUp(ModalId) {
    $('#' + ModalId).modal('hide');
    if (ModalId == 'ModalLoading') {

        //alert('Hide :-' + ModalId);
        clearInterval(Reload);
        Reload = window.setInterval(LoadGrid, 2000);
    }
}

function Redirect(RedirectTo) {
    window.location = RedirectTo;
}

function SaveEndTime() {
    var EndTime = $.trim($('#txtReqTime').val());

    if (EndTime.length > 0) {
     //   ShowModalPopUp('ModalDone');
        SetEndTime();
    }
    else
        $('#txtReqTime').focus();
}
function SetEndTime() {
    $.ajax({
        async: true,
        url: TrackUrl + "Process=SETENDTIME&PID=" + ETPorterID + "&ENDTIME=" + $('#txtReqTime').val(),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            HideModalPopUp('ModalCancel');
            ShowPorter();
          //  setTimeout("HideModalPopUp('ModalDone')", 1500);
        },
        error: function (data) {

        }

    });
}



function LoadPresetRemarks() {
    $.ajax({
        url: TrackUrl + "Process=PRESET&ACTION=GET&MSG=&GROUP=&ID=",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var breakReason = $.grep(data, function (element, index) {
                return element.GROUPNAME == "CREASON";
            });


            var dataReason = $.grep(data, function (element, index) {
                return element.GROUPNAME == "MSG";
            });

           // alert(dataReason);

            $("#drpBreakReason").empty();

            $.each(breakReason, function (key, value) {
                $("#drpBreakReason").append($("<option/>").val(value.ID + "_" + value.PRESET_TIME).text(value.MESSAGE));
            });

            $("#drpBreakReason").append($("<option />").val('0').text('OTHERS'));
            
            /*
            $("#drpPresetMessage").empty();
            $.each(dataReason, function (key, value) {
                $("#drpPresetMessage").append($("<option     />").val(value.ID).text(value.MESSAGE));
            });
            $("#drpPresetMessage").append($("<option     />").val('0').text('OTHERS')); */
        },
        error: function (data) {

        }

    });
}
