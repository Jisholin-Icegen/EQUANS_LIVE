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
        var Name = args.get_item().getDataKeyValue("NAME"); TagID = args.get_item().getDataKeyValue("TAGID");
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
            BPorterID = args.get_item().getDataKeyValue("PORTERID"); BTagID = args.get_item().getDataKeyValue("TAGID");
            IsBreak = args.get_item().getDataKeyValue("ISBREAK");

            if (IsBreak) {
                $.ajax({
                    async: true,
                    url: Turl + "Process=BREAK&PORTERID=" + BPorterID + "&TAGID=" + BTagID + "&MINUTES=&REASON=",
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
                            $('#spErrormessage').text('NO MORE BREAKS FOR THIS PORTER.'); setTimeout(function () { HideModalPopUp('ModalLoading'); }, 200); 
                            ShowModalPopUp('ModalErrorMsg'); setTimeout(function () { HideModalPopUp('ModalErrorMsg');}, 2000);
                        }
                        BPorterID = ''; BTime = ''; BTagID = '';
                    },
                    error: function (data) {

                    }

                });
            }
            else {

                var selValue = $("#drpBreakReason").val(), PorternName = args.get_item().getDataKeyValue("NAME"); BTime = selValue.split("_")[1];
                $('#BreakPorterName').html(PorternName); $('#BreakTime').val(BTime); ShowModalPopUp('ModalBreak'); $('#txtBreakReason').css("display", "none");
                $('#BreakTime').attr('readonly', ((selValue == "0") ? false : true));
                HideModalPopUp('ModalLoading');
            }
        }
    };
    args.get_item().get_cell('BUZZER').onclick = function () {
        var Name = args.get_item().getDataKeyValue("NAME"); TagID = args.get_item().getDataKeyValue("TAGID");
        ShowModalPopUp('ModalDone');
        $.ajax({
            async: true,
            url: Turl + "Process=BUZZER" + "&TAGID=" + TagID + "",
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
            wind = window.open('Popup.aspx?TagId=' + LTagId + "&Name=" + PName, 'TRACKING : #' + PName, 'directories=no,titlebar=yes,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=500');
    };
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
        cellEnd = args.get_item().get_cell('ENDSHIFT'), cellEndTime = args.get_item().get_cell('ENDTIME'),
        cellStatus = args.get_item().get_cell('STATUS');
    var TEndTime = args.get_item().getDataKeyValue("ENDTIME"), TPID = args.get_item().getDataKeyValue("PORTERID"),
        TPName = args.get_item().getDataKeyValue("NAME"), Status = args.get_item().getDataKeyValue("STATUS"),
        imgEdit = $('<img src="Images/Edit.png" style="cursor:pointer;margin-left:10px;vertical-align:middle" >');
    if ((TEndTime !== '-') && (TEndTime !== 'ON-HOLD')) {
        $($(cellEndTime)).append($(imgEdit));
        $(imgEdit).click(function () {
            //alert("TEndTime , TPID , TPName  : " + TEndTime + " ,  " + TPID + " ,  " + TPName);
            var Edt = new Date(), SHour = Edt.getHours(),
                ETime = TEndTime.split(':')[0] + ':' + TEndTime.split(':')[1]; ETPorterID = TPID;
            $('#SpanPorterName').text(TPName); $('#TxtEndTime').val(ETime);
            $('#TxtEndTime').timepicker({
                showAnim: 'blind',
                hours: { starts: SHour, ends: 23 }
            });
            ShowModalPopUp("ModalSaveETime");
        });
    }
    if (Status == 'ACTIVE' || Status == 'SHIFT ENDED') {
        $(cellStatus).css("background-color", "red").css("color", "white").css("font-weight", "bold");
    }
    else if (Status == 'IN BREAK' || Status == 'AWAITING BREAK') {
        $(cellStatus).css("background-color", "yellow").css("color", "black").css("font-weight", "bold");
    }
    else
        $(cellStatus).css("background-color", "green").css("color", "white").css("font-weight", "bold");

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
    var Name = sessionStorage.getItem('NAME').toUpperCase(), SelectedMsg = $("#drpPresetMessage").val(),
        PorterMessage = (SelectedMsg == "0") ? $('#TextMessage').val() : $("#drpPresetMessage option:selected").text();
    if (PorterMessage.length == 0) { $('#TextMessage').focus(); return; }
    var Message = Name + '  : ' + $('#TextMessage').val().replace(/\?/g, '^').replace(/\&/g, '~'),
        MessageTo = $('#MessageTo').text();
    HideModalPopUp('ModalMessage');
    if (MessageTo == 'ALL')
        ShowModalPopUp('ModalLoading');
    else
        ShowModalPopUp('ModalDone');
    $.ajax({
        async: true,
        url: Turl + "Process=" + ((MessageTo == 'ALL') ? 'SENDMESSAGEALL' : 'SENDMESSAGE') + "&TAGID=" + ((MessageTo == 'ALL') ? '' : TagID) + "&MESSAGE= " + Message + "",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT === 'TRUE') {
                if (MessageTo == 'ALL') {
                    ShowModalPopUp('ModalDone');
                    HideModalPopUp('ModalLoading');
                }
                setTimeout("HideModalPopUp('ModalDone');", ((MessageTo == 'ALL') ? 2000 : 1000));
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
    var EndTime = $.trim($('#TxtEndTime').val());

    if (EndTime.length > 0) {
        ShowModalPopUp('ModalDone');
        SetEndTime();
    }
    else
        $('#TxtEndTime').focus();
}
function SetEndTime() {
    $.ajax({
        async: true,
        url: Turl + "Process=SETENDTIME&PID=" + ETPorterID + "&ENDTIME=" + $('#TxtEndTime').val(),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            HideModalPopUp('ModalSaveETime');
            ShowPorter();
            setTimeout("HideModalPopUp('ModalDone')", 1500);
        },
        error: function (data) {

        }

    });
}



function LoadPresetRemarks() {
    $.ajax({
        url: Rurl + "Process=PRESET&ACTION=GET&MSG=&GROUP=&ID=",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var breakReason = $.grep(data, function (element, index) {
                return element.GROUPNAME == "EREASON";
            });


            var dataReason = $.grep(data, function (element, index) {
                return element.GROUPNAME == "MSG";
            });



            $("#drpBreakReason").empty();

            $.each(breakReason, function (key, value) {
                $("#drpBreakReason").append($("<option     />").val(value.ID + "_" + value.PRESET_TIME).text(value.MESSAGE));
            });

            $("#drpBreakReason").append($("<option     />").val('0').text('OTHERS'));


            $("#drpPresetMessage").empty();
            $.each(dataReason, function (key, value) {
                $("#drpPresetMessage").append($("<option     />").val(value.ID).text(value.MESSAGE));
            });
            $("#drpPresetMessage").append($("<option     />").val('0').text('OTHERS'));
        },
        error: function (data) {

        }

    });
}
