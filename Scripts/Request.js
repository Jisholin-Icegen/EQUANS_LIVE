var arr = ["TextSOURCE", "TextCATEGORY", "TextDESTINATION"], ReqIcon = ["tdReqNew", "tdReqPending", "tdReqAssigned", "tdReqInProc", "tdReqCompleted", "tdReqCancelled", "tdPreBook", "tdReqMap"],
    Source = '', Dest = '', User = '', Cat = '', AStatus = '', CancelReqId = '', EStatus = '', Intervl = 0, EReqId = '', ReqArr = ["tdReqPending", "tdReqAssigned", "tdReqInProc", "tdReqCompleted", "tdReqCancelled", "tdPreBook"],
    CurPendProcess = '', AReqId = '', MReqId = '', IsChecked = false, Port = '', Name = "", RequestType = '', CurrentCancelStatus = '';

function Select(Ele, Process) {
    ShowModalPopUp('ModalLoading');
    var EleID = $(Ele).attr('id');
    $.each(ReqIcon, function (index, value) {
        if (value == EleID) {
            $('#' + value).addClass('SelectReqIcon');
            $('#' + ((value == 'tdReqNew' || value == 'tdReqMap') ? value : 'tdRequest').replace("td", "Tbl")).css("display", "inline-block");
            if (value == 'tdReqNew') {
                ClearRequest();
                HideModalPopUp('ModalLoading');
            }
            else if (value == 'tdReqMap')
                setTimeout("HideModalPopUp('ModalLoading');", 1500);
        }
        else {
            $('#' + value).removeClass('SelectReqIcon');
            $('#' + ((value == 'tdReqNew' || value == 'tdReqMap') ? value
                : (ReqArr.indexOf(EleID) > -1) ? 'Request' : 'tdRequest').replace("td", "Tbl")).css("display", "none");
        }

    });
    if (ReqArr.indexOf(EleID) > -1) {
        var ReqStatus = (EleID == "tdReqPending") ? "2" : (EleID == "tdReqAssigned") ? "3" : (EleID == "tdReqInProc") ? "4" : (EleID == "tdReqCompleted") ? "6" : (EleID == "tdReqCancelled") ? "7" : (EleID == "tdPreBook") ? "100" : "0";
        pageIndex == '0';
        LoadProcess(ReqStatus);
        CProcess = ReqStatus;
        ToUpdate = !ToUpdate;
        ReloadLinks();
    }
    else {
        CProcess = "10";
    }
}

function RefreshCurrent() {
    ShowModalPopUp('ModalLoading');
    AbortAllActiveRuquests();
    LoadProcess(CProcess);
    ToUpdate = !ToUpdate;
    ReloadLinks();
    setTimeout("HideModalPopUp('ModalLoading')", 1500);
}

function GetRecords(target) {
    Target = target;
    switch (Target) {
        case "TextSOURCE":
            NextCtrl = 'TextCATEGORY'; Dialog = 'ModalLocation';
            break;
        case "TextDESTINATION":
            NextCtrl = 'ImgSend'; Dialog = 'ModalDestLocation';
            break;
        case "TextCATEGORY":
            NextCtrl = 'TextDESTINATION'; Dialog = 'ModalCategory';
            break;
    }
    $('#' + Dialog).modal('show');
    setTimeout(function () { var ctrl = (Dialog == 'ModalLocation') ? 'txtSourceLoc' : 'txtDestLoc'; $('#' + ctrl).focus() }, 500);
}
function FromHomeFn() {
    var FromHome = sessionStorage.getItem('FromHome');
    if (FromHome == 'true')
        PreSelect();
    else
        Select($("#tdReqNew"));
    clearInterval(TimerHome);
}

function PreSelect() {
    var ProcessElement = $("#" + sessionStorage.getItem('RequestPageFn'));
    Select(ProcessElement);
    sessionStorage.setItem('FromHome', 'false');
}

function findMRDDetails() {

    var TrimedValue = FormatValue($('#textMRD').val());
    MRDPatientName = '';

    $('#textMRD').val(TrimedValue);
    var Value = TrimedValue;
    if (Value.length > 4)
        setMRDPatientName(Value);
    else
        $('#spanMRDPatient').html('');

}
function FormatValue(rawValue) {
    //var charNotAllowed = ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '-', '+', '=', ':', ';', ' ', '{', '}', '[', '}', '/']
    //var regex = new RegExp("^[a-zA-Z0-9]+$");
    var FinalValue = rawValue.replace(/[^\w\s]/gi, '').replace(/\s/g, '');

    /* $.each(charNotAllowed, function (index, char) {
         if (rawValue.indexOf(char) != -1)
             FinalValue.replace('/' + char + '/g', "")
     }); */
    return FinalValue;
}

function setMRDPatientName(MRDNo) {
    var PUrl = Rurl + "Process=GETPATIENTNAMEMRD&MRDNO=" + MRDNo;
    $.ajax({
        async: true,
        url: PUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            var PatientName = data[0].RESULT;
            $('#spanMRDPatient').html(PatientName);
            if (PatientName.length > 0)
                MRDPatientName = PatientName;
            else
                $('#spanMRDPatient').html('');


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

            var dataRemarks = $.grep(data, function (element, index) {
                return element.GROUPNAME == "REMARKS";
            });

            var dataReason = $.grep(data, function (element, index) {
                return element.GROUPNAME == "EREASON";
            });
            var FReason = $.grep(data, function (element, index) {
                return element.GROUPNAME == "FREASON";
            });
            var CReason = $.grep(data, function (element, index) {
                return element.GROUPNAME == "CREASON";
            });




            //$("#drpPresetRemarks").empty();
            //$.each(dataRemarks, function (key, value) {
            //    $("#drpPresetRemarks").append($("<option     />").val(value.ID).text(value.MESSAGE));
            //});
            //$("#drpPresetRemarks").append($("<option     />").val('0').text('OTHERS'));

            $("#drpPresetReason").empty();
            $.each(dataReason, function (key, value) {
                $("#drpPresetReason").append($("<option     />").val(value.ID).text(value.MESSAGE));
            });


            $("#drpCancelReason").empty();
            $.each(CReason, function (key, value) {
                $("#drpCancelReason").append($("<option     />").val(value.ID).text(value.MESSAGE));
            });
            $("#drpCancelReason").append($("<option     />").val('0').text('OTHERS'));

            $("#drpFinishReason").empty();
            $.each(FReason, function (key, value) {
                $("#drpFinishReason").append($("<option     />").val(value.ID).text(value.MESSAGE));
            });
            $("#drpFinishReason").append($("<option     />").val('0').text('OTHERS'));
            //$("#drpPresetReason").append($("<option     />").val('0').text('OTHERS'));
        },
        error: function (data) {

        }

    });
}
function LoadFloor() {
    $.ajax({
        async: true,
        url: Rurl + "Process=GETFLOOR",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            $('#drpDestFloor').find('option').remove().end();
            $('#drpFloor').find('option').remove().end();
            $.each(data, function (i, item) {
                $("#drpFloor").append($("<option/>").val(data[i].FLOORID).text(data[i].FLOORNAME));
                $("#drpDestFloor").append($("<option/>").val(data[i].FLOORID).text(data[i].FLOORNAME));
            });
            LoadMasterRecords();
        },
        error: function (data) {

        }
    });
}
function GridRequest_Command(sender, args) {
    args.set_cancel(true);
    pageIndex = parseInt(sender.get_masterTableView().get_currentPageIndex());
    pageSize = sender.get_masterTableView().get_pageSize();
    switch (args.get_commandName()) {
        case "Page":
        case "PageSize":
            ShowModalPopUp('ModalLoading');
            LoadProcess(CProcess);
            break;
    }
}
function LoadMasterRecords() {
    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=GETMASTERRECORD",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            var Content = data[0].RESULT.split('$$$')[0], DestContent = Content.replace(/id="Loc/g, 'id="DLoc').replace(/for="Loc/g, 'for="DLoc');
            $('#DivDestLocContent').html(DestContent);
            $('#DivLocContent').html(Content);
            $('#DivCategoryContent').html(data[0].RESULT.split('$$$')[1]);
            $('#DivECategoryContent').html(data[0].RESULT.split('$$$')[2]);

        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}

function ChangeFloor(floor, content) {
    $.ajax({
        async: true,
        url: Rurl + "Process=GETLOCATION&FLOORID=" + $('#' + floor + '').val(),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            $('#' + content + '').html(data[0].RESULT);
        },
        error: function (data) {

        }

    });
}
function changePorter() {
    var src = $('#ImgMultiPorter').attr('src'); //alert(src);
    $('#ImgMultiPorter').attr("src", (src == "images/MultiUnselect.png") ? "images/MultiSelected.png" : "images/MultiUnselect.png");
}

function changeMPorter() {
    var src = $('#ImgMPorter').attr('src'); //alert(src);
    $('#ImgMPorter').attr("src", (src == "images/MUnselect.png") ? "images/MSelected.png" : "images/MUnselect.png");
    sessionStorage.setItem('DMT', ((src == "images/MUnselect.png") ? "1" : "0"));
}
function GetMap() {
    CheckPendingRequests();
}
function CheckPendingRequests() {
    var PendingRequest = '', UId = sessionStorage.getItem('ID');
    $.ajax({
        async: true,
        url: Rurl + "Process=GETPENDINGREQUESTS&USERID=" + UId,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            $.each(data, function () {
                $.each(this, function (name, value) {
                    PendingRequest += (!$.trim(PendingRequest)) ? value : '-' + value;
                });
            });
            if ($.trim(PendingRequest)) {
                sessionStorage.setItem('REQUESTS', PendingRequest);
                var loc = window.location.href;
                window.location = loc.replace("Request", "Map");
            }
        },
        error: function (data) {

        }

    });
}
function Open() {
    $('#ModalLocation').modal('show');
}
function ShowModalPopUp(ModalId) {
    $('#' + ModalId).modal('show');
}
function HideModalPopUp(ModalId) {
    $('#' + ModalId).modal('hide');
}
function Validate(cont) {
    var returnval = true;
    //$.each(arr, function (i, val) {
    //    var Value = (val == "TextCATEGORY") ? $('#' + val).attr('src') : $('#' + val).text(); Value = $.trim(Value); Value = ((Value == "FROM") || (Value == "TO") || (Value == "images/PorterSelect.png")) ? '' : Value;
    //    if (Value.length == 0) {
    //        GetRecords(val);
    //        returnval = false;
    //    }
    //    return returnval;
    //});
    //if (returnval && cont) {
    //    // if (CheckIsValidTime()) {
    //    var ExtentionNo = $.trim($('#txtReqRemarks').val()), MRDNo = $.trim($('#textMRD').val());

    //    if (ExtentionNo.length == 0) {
    //        $('#txtReqRemarks').focus();
    //        $('#txtReqRemarks').css('background-color', '#ff7171'); setTimeout(function () { $('#txtReqRemarks').css('background-color', 'white'); }, 2500)
    //        return false;
    //    }
    //    else if (IsMRD == 'YES' && (MRDNo.length == 0)) {
    //        $('#textMRD').focus();
    //        $('#textMRD').css('background-color', '#ff7171'); setTimeout(function () { $('#textMRD').css('background-color', 'white'); }, 2500)
    //        return false;
    //    }
    //    else
    //        InsertRequest();
    //    //}
    //    //else {
    //    //    ShowModalPopUp('ModalTimeLimit');
    //    //    setTimeout("HideModalPopUp('ModalTimeLimit')", 5000);
    //    //}

    //}
    ShowModalPopUp('ModalTimeLimit');
}
function CheckIsValidTime() {
    var dt = new Date(), TdateFormatted = (dt.getMonth() + 1) + "/" + dt.getDate() + "/" + dt.getFullYear(),
        startTime = TdateFormatted + " " + "08:00", EndTime = TdateFormatted + " " + "20:00";

    var stt = new Date(startTime); stt = stt.getTime();
    var endt = new Date(EndTime); endt = endt.getTime();
    var time = dt.getTime();

    if (time > stt && time < endt)
        return true;
    else
        return false;
}
function GetPBDate(TPBDate) {
    //var PBDate = ((TPBDate != 'Pre-Book') ? (TPBDate.split('/')[1] + '/' + TPBDate.split('/')[0] + '/' + TPBDate.split('/')[2]) : TPBDate);
    return ((TPBDate != 'Pre-Book') ? (TPBDate.split('/')[1] + '/' + TPBDate.split('/')[0] + '/' + TPBDate.split('/')[2]) : TPBDate);

}
function InsertRequest() {
    var Visiblility = $('#ImgMultiPorter').css("visibility"), MultiSrc = $('#ImgMultiPorter').attr('src'), IsMultiPorter = ((MultiSrc == 'images/MultiSelected.png') && (Visiblility == 'visible')) ? "1" : "0",
        UID = sessionStorage.getItem('ID'), time = (((new Date().getHours().toString()).length <= 1) ? ("0" + new Date().getHours().toString()) : (new Date().getHours()))
            + ":" + (((new Date().getMinutes().toString()).length <= 1) ? ("0" + new Date().getMinutes()) : new Date().getMinutes()),
        PBDate = GetPBDate($('#requestdate').val());
    var PatientName = FPatientName + '_' + TPatientName, MRDNo = $.trim($('#textMRD').val());
    //var drpRemarks = $("#drpPresetRemarks").val(),
    //    ReqRemarks = (drpRemarks == "0") ? $('#txtReqRemarks').val() : $("#drpPresetRemarks option:selected").text();
    var ReqRemarks = $('#txtReqRemarks').val();

    prebook = (prebook !== 'yes') ? (($('#requestdate').val() == "Pre-Book") ? "" : 'yes') : prebook;

    $.ajax({
        async: true,
        url: hurl + "Service/Service.aspx?Process=INSERT&TIME=" + time + "&REMARK=" + ReqRemarks + "&SOURCE=" + Source + "&HALT1=&HALT2=&DESTINATION=" + Dest + "&CATEGORY=" + Cat + "&PRIORITY=0&ISMULTIPORTER=" + IsMultiPorter + "&USERID=" + UID + "&PREBOOKING=" + (prebook + ',' + PBDate) + "&PATIENTNAME=" + PatientName + "&MRD=" + MRDNo + '_' + MRDPatientName,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            ToUpdate = !ToUpdate; ReloadLinks();
            if (data[0].RESULT.split("_")[0] === 'TRUE' && prebook !== 'yes') {
                ShowModalPopUp('ModalDone'); ClearRequest();
                GetMap();
            }
            else if (data[0].RESULT.split("_")[0] === 'WAIT') {
                var startAt = data[0].RESULT.split("_")[1];
                $('#LBL2min').text('You can not request porter until ' + startAt);
                ShowModalPopUp('ModelAfter2min');
                setTimeout("HideModalPopUp('ModelAfter2min');", 3500);
            }
            else if (data[0].RESULT.split("_")[0] === 'FALSE') {
                ShowModalPopUp('ModalRequestExist');
                setTimeout("HideModalPopUp('ModalRequestExist');", 3500);
            }
            else if (data[0].RESULT.split("_")[0] === 'INVALID') {
                ShowModalPopUp('ModalTimeLimit');
                setTimeout("HideModalPopUp('ModalTimeLimit');", 3500);
            }
            prebook = '';
            setTimeout("HideModalPopUp('ModalDone');", 1500);
            calldatetime();
        },
        error: function (xhr, ajaxOptions, thrownError) {
        }

    });
}
function ClearRequest() {
    calldatetime(); $('#txtReqRemarks').val('');// $('#txtReqRemarks').css("display", "none");
    // $("select#drpPresetRemarks")[0].selectedIndex = 0;
    $('#ImgMultiPorter').css("visibility", "hidden");
    $('#ImgMultiPorter').attr("src", "images/MultiUnselect.png");
    $('#TextCATEGORY').attr('src', "images/PorterSelect.png");
    $('#TextSOURCE').html('FROM');
    $('#TextDESTINATION').html('TO');
    FPatientName = ''; TPatientName = '';
    $('#spanFromPatient').html(''); $('#txtReqRemarks').val(''); $('#textMRD').val('');
    $('#spanToPatient').html(''); IsMRD = 'NO'; MRDPatientName = ''; $('#spanMRDPatient').html('');
}
function CloseandBind(Id, Value, BedID) {
    var NextValue = '';
    switch (Target) {
        case "TextSOURCE":
            $('#DivLocContent').find('input[type=radio]:checked').removeAttr('checked');
            $('#DivDestLocContent').find('input[type=radio]:checked').removeAttr('checked');
            sessionStorage.setItem('FROM', Value);
            NextValue = $('#TextCATEGORY').attr('src'); NextValue = (NextValue == "images/PorterSelect.png") ? '' : NextValue;
            Source = Id;
            setPatientName(BedID, 'From');
            break;
        case "TextDESTINATION":
            $('#DivLocContent').find('input[type=radio]:checked').removeAttr('checked');
            $('#DivDestLocContent').find('input[type=radio]:checked').removeAttr('checked');
            sessionStorage.setItem('TO', Value);
            NextValue = $('#ImgSend').attr('src');
            Dest = Id;
            setPatientName(BedID, 'To');
            break;
        case "TextCATEGORY":
            $('#TextCATEGORY').attr('src', hurl + 'images/Category/' + Value); sessionStorage.setItem('CATEGORY', hurl + 'images/MapCategory/' + Value);
            $('#ImgMultiPorter').css("visibility", "visible");
            NextValue = $('#' + NextCtrl).html(); NextValue = (NextValue == "TO") ? '' : NextValue;
            Cat = Id; IsMRD = BedID;
            break;
    }
    $('#' + Target).text(Value);
    $('#' + Dialog).modal('hide');
    if (NextValue.length == 0)
        GetRecords(NextCtrl);
    else if ($.inArray(NextCtrl, arr) != -1)
        Validate(false);

}


/*-------------- Request Count Updation------------------*/

function RestartTimer() {
    Reload = window.setInterval(function () { AbortAllActiveRuquests(); ReloadLinks(); }, 90000);
}

function ReloadLinks() {
    var CRole = sessionStorage.getItem('ROLE');
    if (sessionStorage.getItem('ROLE') == null)
        window.location = "../Login.aspx";
    if (CRole === "1" || (!ToUpdate)) {
        ReloadLinksButton();
        ToUpdate = (!ToUpdate) ? (!ToUpdate) : ToUpdate;
    }
}

function ReloadLinksButton() {
    var UID = sessionStorage.getItem('ID'), CountROLE = sessionStorage.getItem('ROLE');
    $.ajax({
        async: true,
        url: hurl + "Service/Service.aspx?Process=GETCOUNT&USERID=" + UID + "&ROLE=" + CountROLE,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            var PendingCount = data[0].ACCEPTED, AssignedCount = data[0].ASSIGNED, InprogressCount = data[0].PROGRESS,
                CompletedCount = data[0].COMPLETED, CancelledCount = data[0].CANCELLED, PreBookCount = data[0].PREBOOK;
            $('#PendingCount').text((PendingCount == null) ? '00' : (PendingCount.toString().length == 1) ? '0' + PendingCount.toString() : PendingCount.toString());
            $('#AssignedCount').text((AssignedCount == null) ? '00' : (AssignedCount.toString().length == 1) ? '0' + AssignedCount.toString() : AssignedCount.toString());
            $('#InprogressCount').text((InprogressCount == null) ? '00' : (InprogressCount.toString().length == 1) ? '0' + InprogressCount.toString() : InprogressCount.toString());
            $('#CompletedCount').text((CompletedCount == null) ? '00' : (CompletedCount.toString().length == 1) ? '0' + CompletedCount.toString() : CompletedCount.toString());
            $('#CancelledCount').text((CancelledCount == null) ? '00' : (CancelledCount.toString().length == 1) ? '0' + CancelledCount.toString() : CancelledCount.toString());
            $('#PreBookCount').text((PreBookCount == null) ? '00' : (PreBookCount.toString().length == 1) ? '0' + PreBookCount.toString() : PreBookCount.toString());
            if (data.length == 2) {
                //var docMov = data[1].DOCMOVEMENT, OtherMov = data[1].OTHERMOVEMENT;
                var AvailPorter = data[1].AVAILABLEPORTER, TotalPorter = data[1].TOTALPORTER;
                $('#PorterCountOtherMov').text((AvailPorter == null) ? '00' : (AvailPorter.toString().length == 1) ? '0' + AvailPorter.toString() : AvailPorter.toString());
                $('#PorterCountSampleMov').text((TotalPorter == null) ? '00' : (TotalPorter.toString().length == 1) ? '0' + TotalPorter.toString() : TotalPorter.toString());
            } else {
                $('#PorterCountSampleMov').text("00");
                $('#PorterCountOtherMov').text("00");
            }
        },
        error: function (data) {

        }
    });
}

/*---------------- Grid Related Process ---------------------*/

function LoadGrid(Process) {
    var UID = sessionStorage.getItem('ID'), PRID = sessionStorage.getItem('ROLE');
    var FinalUrl = hurl + "Service/Service.aspx?Process=GET&Status=" + Process + "&Search=" + (((Process == 3) || (Process == 4) || (Process == 5) || (Process == 6)) ? $('#TextSearchPorter').val() : "") + "&USERID=" + UID + "&PageIndex=" + pageIndex + "&PageSize=" + pageSize + "&ROLE=" + PRID;
    $.ajax({
        url: FinalUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (typeof (grid) != 'undefined' && grid != null) {
                grid.clearSelectedItems();
                tableView = grid.get_masterTableView();
                if (data.length > 0)
                    updateVirtualItemCount(data[0].VIC, tableView)
                else
                    updateVirtualItemCount(data.length, tableView)
                if (pageIndex == '0')
                    tableView.set_currentPageIndex(pageIndex);
                tableView.set_dataSource(data);
                tableView.dataBind();
                HideModalPopUp('ModalLoading');
            }
        },
        error: function (data) {

        }

    });
}

function updateVirtualItemCount(result, tableView) {
    tableView.set_virtualItemCount(result);
}
function MultiTasking() {
    var IsValid = true;
    if (MANPorterID.length == 0) {
        IsValid = (!IsValid);
        showMAPORTERs('MAPORTER');
    }
    if (IsValid) {
        ShowModalPopUp('ModalDone');
        $.ajax({
            async: false,
            url: Rurl + "Process=MULTITASK&REQUESTID=" + MANReqID + "&PORTERID=" + MANPorterID + "&DEPT=COMMON",
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {
                if (data[0].RESULT === 'TRUE') {
                    clearMANAssign();
                    LoadProcess("2"); ReloadLinksButton();
                }
                setTimeout("HideModalPopUp('ModalDone');", 1500);
            },
            error: function (data) {

            }

        });
    }
}
function SetGridRole(grid, ReqStatusID) {
    var CRole = sessionStorage.getItem('ROLE').toUpperCase(), HeadChk = grid.getColumnByUniqueName("SELECT").get_element();
    $(HeadChk).html('SELECT');
    grid.hideColumn(grid.getColumnByUniqueName("UPDATEDBY").get_element().cellIndex);
    grid.showColumn(grid.getColumnByUniqueName("MULTITASK").get_element().cellIndex);
    grid.hideColumn(grid.getColumnByUniqueName("CURRENTLOCATION").get_element().cellIndex);
    grid.hideColumn(grid.getColumnByUniqueName("LOCATE").get_element().cellIndex);
    grid.hideColumn(grid.getColumnByUniqueName("BUZZER").get_element().cellIndex);
    //grid.hideColumn(grid.getColumnByUniqueName("REMARKS").get_element().cellIndex);
    grid.hideColumn(grid.getColumnByUniqueName("FINISH").get_element().cellIndex);
    grid.getColumnByUniqueName("DELAYREASON").get_element().innerHTML = "DELAY REASON";
    grid.getColumnByUniqueName("REMARKS").get_element().innerHTML = "REMARKS";
    grid.hideColumn(grid.getColumnByUniqueName("REMARKS").get_element().cellIndex);
    grid.hideColumn(grid.getColumnByUniqueName("DELAYREASON").get_element().cellIndex);
    grid.hideColumn(grid.getColumnByUniqueName("MULTITASK").get_element().cellIndex);
    grid.hideColumn(grid.getColumnByUniqueName("CANCELLEDAT").get_element().cellIndex);
    grid.getColumnByUniqueName("ASSIGNEDTIME").get_element().innerHTML = "ASSIGN TIME";
    grid.getColumnByUniqueName("FINISH").get_element().innerHTML = "FINISH";
    grid.getColumnByUniqueName("TIME").get_element().innerHTML = "REQ TIME";
    grid.hideColumn(0); clearMANAssign('DB');
    $('#TableAssignSearch').css('visibility', 'hidden');
    $('#TableAssignSearch').css('display', 'none');
    $('#myonoffswitch').prop('checked', true);
    $('#tdMAPORTERInfo').css('display', 'none');
    $('#tblMultiTasking').css('display', (((CRole === "1" || CRole === "6" || CRole === "12" || CRole === "2") && (ReqStatusID == '2')) ? "table" : "none"));
    switch (ReqStatusID) {
        case "1":
        case "2":
            //grid.showColumn(0);

            if (CRole === "1" || CRole == "11" || CRole == "12") {
                grid.showColumn(grid.getColumnByUniqueName("NEXT").get_element().cellIndex);
                grid.getColumnByUniqueName("DELAYREASON").get_element().innerHTML = "CANCEL";
                grid.showColumn(grid.getColumnByUniqueName("DELAYREASON").get_element().cellIndex);
            }
            else {
                grid.hideColumn(grid.getColumnByUniqueName("NEXT").get_element().cellIndex);
                //grid.hideColumn(grid.getColumnByUniqueName("DELAYREASON").get_element().cellIndex);
            }
            grid.getColumnByUniqueName("NEXT").get_element().innerHTML = "EMERGENCY";
            grid.hideColumn(grid.getColumnByUniqueName("ASSIGNEDTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("STARTTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ENDTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("TAT").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("TTAT").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("ASSIGNTO").get_element().cellIndex);
            break;
        case "3":
        case "4":
        case "5":
            if (CRole === "1") {
                $('#TableAssignSearch').css('visibility', 'visible');
                $('#TableAssignSearch').css('display', 'table');
                grid.showColumn(grid.getColumnByUniqueName("FINISH").get_element().cellIndex);
            }
            grid.hideColumn(grid.getColumnByUniqueName("NEXT").get_element().cellIndex);
            if (ReqStatusID == 4) {
                grid.showColumn(grid.getColumnByUniqueName("STARTTIME").get_element().cellIndex);
                if (CRole == "1")
                    grid.showColumn(grid.getColumnByUniqueName("NEXT").get_element().cellIndex);
            }
            else {
                //                switch (CRole) {
                //                    case "1":
                //                        grid.showColumn(grid.getColumnByUniqueName("NEXT").get_element().cellIndex);
                //                        break;
                //                }
                grid.showColumn(grid.getColumnByUniqueName("NEXT").get_element().cellIndex);
                if (ReqStatusID == 3)
                    grid.hideColumn(grid.getColumnByUniqueName("STARTTIME").get_element().cellIndex);
                else
                    grid.showColumn(grid.getColumnByUniqueName("STARTTIME").get_element().cellIndex);
            }
            if (ReqStatusID == 3 || ReqStatusID == 4) {
                grid.showColumn(grid.getColumnByUniqueName("CURRENTLOCATION").get_element().cellIndex);
                grid.showColumn(grid.getColumnByUniqueName("LOCATE").get_element().cellIndex);
                grid.showColumn(grid.getColumnByUniqueName("BUZZER").get_element().cellIndex);
            }
            grid.getColumnByUniqueName("FINISH").get_element().innerHTML = (ReqStatusID == "3") ? "START" : "FINISH";
            grid.getColumnByUniqueName("NEXT").get_element().innerHTML = "CANCEL";
            grid.showColumn(grid.getColumnByUniqueName("ASSIGNEDTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ENDTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("TAT").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("TTAT").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("ASSIGNTO").get_element().cellIndex);
            if (ReqStatusID == 5) {
                grid.hideColumn(grid.getColumnByUniqueName("UPDATEDBY").get_element().cellIndex);
                grid.showColumn(grid.getColumnByUniqueName("ENDTIME").get_element().cellIndex);
                grid.showColumn(grid.getColumnByUniqueName("TAT").get_element().cellIndex);
                grid.showColumn(grid.getColumnByUniqueName("TTAT").get_element().cellIndex);
            }
            break;
        case "6":
            grid.hideColumn(grid.getColumnByUniqueName("NEXT").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("ASSIGNEDTIME").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("STARTTIME").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("ENDTIME").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("TAT").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("TTAT").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("ASSIGNTO").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("UPDATEDBY").get_element().cellIndex);
            break;
        case "7":
            grid.hideColumn(grid.getColumnByUniqueName("NEXT").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("REMARKS").get_element().cellIndex);
            grid.getColumnByUniqueName("REMARKS").get_element().innerHTML = "CANCEL REASON";
            grid.hideColumn(grid.getColumnByUniqueName("ASSIGNEDTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("STARTTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("TAT").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("TTAT").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ENDTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ASSIGNTO").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("UPDATEDBY").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("CANCELLEDAT").get_element().cellIndex);
            break;
        case "100":
            grid.showColumn(grid.getColumnByUniqueName("NEXT").get_element().cellIndex);
            grid.getColumnByUniqueName("NEXT").get_element().innerHTML = "CANCEL";
            grid.showColumn(grid.getColumnByUniqueName("ASSIGNEDTIME").get_element().cellIndex);
            grid.getColumnByUniqueName("ASSIGNEDTIME").get_element().innerHTML = "BOOKING DATE";
            grid.getColumnByUniqueName("TIME").get_element().innerHTML = "REQUEST DATE";
            grid.showColumn(grid.getColumnByUniqueName("REMARKS").get_element().cellIndex)
            grid.getColumnByUniqueName("REMARKS").get_element().innerHTML = "CANCEL REASON";
            grid.hideColumn(grid.getColumnByUniqueName("STARTTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("TAT").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("TTAT").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ENDTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("STARTTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ASSIGNTO").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("UPDATEDBY").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("CANCELLEDAT").get_element().cellIndex);
            break;
    }
}

function AbortAllActiveRuquests() {
    $($.xhrPool).each(function (i, jqXHR) {   //  cycle through list of recorded connection
        jqXHR.abort();  //  aborts connection
        $.xhrPool.splice(i, 1); //  removes from list by index
    });
}
function GridRequest_RowDataBound(sender, args) {
    var CRole = sessionStorage.getItem('ROLE').toUpperCase(), UID = sessionStorage.getItem('ID');
    var status = args.get_item().getDataKeyValue("STATUS"), RequestId = args.get_item().getDataKeyValue("REQUESTID"), AsgnTAT = args.get_item().getDataKeyValue("ASGNTAT"), cell = args.get_item().get_cell("NEXT"), cellPCnl = args.get_item().get_cell("DELAYREASON"),
        cellMultiTask = args.get_item().get_cell("MULTITASK"), cellBuzzer = args.get_item().get_cell("BUZZER"), MultiTask = args.get_item().getDataKeyValue("MULTITASK"), Priority = args.get_item().getDataKeyValue("PRIORITY"), //#004d00
        FPId = args.get_item().getDataKeyValue("PORTERID"), FSPId = args.get_item().getDataKeyValue("SUPPORTER"), DLocation = args.get_item().getDataKeyValue("SDESTINATION"),
        MIndex = args.get_item().getDataKeyValue("MULTITASKINDEX"), PatientName = args.get_item().getDataKeyValue("PATIENTNAME"), RGroup = args.get_item().getDataKeyValue("REQUESTGROUP"), Return = args.get_item().getDataKeyValue("ISRETURN"),
        //img = $('<img>').attr('src', '../Images/Done.png').css("height", "25px").css("width", "25px"),
        CCatID = args.get_item().getDataKeyValue("CATEGORYID"), P1TagID = args.get_item().getDataKeyValue("TAGID"), P2TagID = args.get_item().getDataKeyValue("STAGID"), cellFinish = args.get_item().get_cell("FINISH"),
        a = $('<a></a>').html((status == 2) ? "<img src='" + Iurl + "Assign.png' alt='Assign' class='GridIcons'  height='28px' />" : "").addClass("").css("cursor", ((status <= 5) ? "pointer" : "text")),
        b = $('<a></a>').html("<img src='Images/close.png' alt='Assign'  height='28px' class='GridIcons' style='cursor:pointer' />").css("cursor", "pointer"),
        c = "<img src='Images/MultiTask.PNG'  width='35px' height='35px' alt='MultiTask'  />",
        py = $('<a></a>').html("<img src='Images/" + ((Priority == 'LOW') ? 'Priority' : 'SPriority') + ".png' alt='Priority'  height='20px' class='EmergencyIcon' style='cursor:pointer' />").css("cursor", "pointer"),
        IsDelay = args.get_item().getDataKeyValue("ISDELAY"), Tat = args.get_item().getDataKeyValue("ATAT"),
        startIcon = $('<a></a>').html("<img src='../RequestNew/images/Start.png' alt='Assign'  height='28px' class='GridIcons' />").css("cursor", "pointer"),
        finishIcon = $('<a></a>').html("<img src='../RequestNew/images/Finish.png' alt='Assign'  height='28px' class='GridIcons' />").css("cursor", "pointer");
    RUID = args.get_item().getDataKeyValue("USERID");


    var ReqIndex = (MultiTask == "YES") ? (MIndex % 5) : '';
    var bgColor = (MultiTask == "YES") ? ((ReqIndex == 1) ? 'MIgroup1' : (ReqIndex == 2) ? 'MIgroup2' : (ReqIndex == 3) ? 'MIgroup3' : (ReqIndex == 4) ? 'MIgroup4' : 'MIgroup5') : '';

    $(cellMultiTask).html((MultiTask == "YES") ? c : '');
    if ((CRole != '1') && (AsgnTAT < 10))
        $(cellBuzzer).html('-');
    if (CRole === "1" && status == 2) {



        var SelectCell = args.get_item().get_cell('SELECT'), CheckBox = $(SelectCell).find('input')[0];
        // $(CheckBox).css("visibility", ((CCatID != '6' || MIndex != '0') ? "hidden" : "visible")); $(a).html('');
        $(CheckBox).css("visibility", ((!(RGroup.includes("MT")) || MIndex != '0') ? "hidden" : "visible")); $(a).html('');
        //$(args.get_item().get_cell('SELECT')).html(''); alert(CheckBox);

    }
    if (status == 3 || status == 4 || status == 100 || status == 102) {
        $(cell).html((((UID == RUID) || (CRole == 1)) && (status != 102)) ? b : '-');
        if (((UID == RUID) || (CRole == 1)) && (status != 102)) {
            $(cell).html(b);
            $(b).click(function () {
                //                alert(P1TagID + '_' + P2TagID);
                GTagID = P1TagID + (((P2TagID != null) && (P2TagID.length > 0)) ? ('_' + P2TagID) : ''); GMIndex = MIndex;
                GReqID = RequestId; GPorterID = FPId + (((FSPId != null) && (String(FSPId).length > 0)) ? ('_' + String(FSPId)) : '');
                CurrentCancelStatus = (status == 4) ? "INPROGRESS" : "ASSIGNED";
                CancelReqId = RequestId; RequestType = (status == 100) ? "PreBook" : "Normal"; $('#TxtCancelReason').val('');
                clearInterval(Reload); AbortAllActiveRuquests();
                ShowModalPopUp('ModalCancel');
                GCancelReason = '';
            });
        }
        if (status == 4) {
            $(cellFinish).html(finishIcon);
            $(finishIcon).click(function () {
                //GTagID = cTagID;
                GTagID = P1TagID + (((P2TagID != null) && (P2TagID.length > 0)) ? ('_' + P2TagID) : ''); GMIndex = MIndex; IsReturn = Return;
                GReqID = RequestId; GPorterID = FPId + (((String(FSPId) != null) && (String(FSPId).length > 0)) ? ('_' + String(FSPId)) : '');
                clearInterval(Reload); AbortAllActiveRuquests();
                ShowModalPopUp('ModalFinish');
            });
        }
        else if (status == 3) {
            $(cellFinish).html(startIcon);
            $(startIcon).click(function () {
                GTagID = P1TagID + (((P2TagID != null) && (P2TagID.length > 0)) ? ('_' + P2TagID) : ''); GMIndex = MIndex;
                clearInterval(Reload); AbortAllActiveRuquests();
                StartRequest(GTagID, RequestId, DLocation);
            });
        }

    }
    else if (status == 2) {
        $(cellPCnl).html(b);
        $(b).click(function () {
            GTagID = '_'; GReqID = RequestId; GPorterID = '_'; GMIndex = MIndex;
            CurrentCancelStatus = 'PENDING';
            CancelReqId = RequestId; RequestType = (status == 100) ? "PreBook" : "Normal"; $('#TxtCancelReason').val('');
            clearInterval(Reload); AbortAllActiveRuquests();
            ShowModalPopUp('ModalCancel');
            GCancelReason = '';
        });

        $(cell).html(py);
        $(py).click(function () {
            ShowModalPopUp('ModalLoading');
            SetPriority(RequestId, ((Priority == 'LOW') ? 'SET' : 'RELEASE'));
        });
    }
    if (status < 6) {
        $(a).click(function () {
            ProcessStatus(status, RequestId);
        });
    }
    args.get_item().removeCssClass("IsDelayed"); args.get_item().removeCssClass("MIgroup1"); args.get_item().removeCssClass("MIgroup2"); args.get_item().removeCssClass("MIgroup3");
    args.get_item().removeCssClass("TimeExeed"); args.get_item().removeCssClass("MIgroup4"); args.get_item().removeCssClass("MIgroup5");
    args.get_item().addCssClass("rgAltRow");
    if (IsDelay == 1) {
        args.get_item().removeCssClass("rgAltRow");
        args.get_item().addCssClass("IsDelayed");
    }
    else if (parseInt(Tat) > 20) {
        args.get_item().removeCssClass("rgAltRow");
        args.get_item().addCssClass("TimeExeed");
    }
    else if (UID == RUID && (status == '2' || status == 100)) { // UID
        args.get_item().removeCssClass("rgAltRow");
        args.get_item().addCssClass("OwnRequest");
    } else {
        args.get_item().addCssClass("rgAltRow");
        args.get_item().removeCssClass("OwnRequest");
    }
    if (bgColor.length > 0)
        args.get_item().addCssClass(bgColor);
}


function CompleteRequest(Reason) {
    var UID = sessionStorage.getItem('ID');
    HideModalPopUp('ModalFinish');
    $.ajax({
        url: Rurl + "Process=COMPLETETASK&TAGID=" + GTagID + "&REASON=" + Reason + "&USERID=" + UID + "&REQUESTID=" + GReqID + "&PORTERIDS=" + GPorterID + "&MIINDEX=" + GMIndex + "&ISRETURN=" + IsReturn,
        type: 'POST',
        data: 'pData',
        async: true,
        dataType: 'json',
        success: function (data) {
            HideModalPopUp('ModalDone');
            LoadProcess("4");
        },
        error: function (data) {

        }

    });
    setTimeout(function () { ReloadLinksButton(); RestartTimer(); }, 500);
}
function StartRequest(TagId, RequestID, Location) {

    $.ajax({
        url: Rurl + "Process=STARTTASK&TAGID=" + TagId + "&REQUESTID=" + RequestID + "&LOCATION=" + Location + "&MIINDEX=" + GMIndex,
        type: 'POST',
        data: 'pData',
        async: true,
        dataType: 'json',
        success: function (data) {
            HideModalPopUp('ModalDone');
            LoadProcess("3");
        },
        error: function (data) {

        }

    });
    setTimeout(function () { ReloadLinksButton(); RestartTimer(); }, 500);
}

function ReloadGrid() {
    if (typeof (CProcess) != 'undefined' && (CProcess != '1' && CProcess != '2' && CProcess != '6' && CProcess != 'NEW' && CProcess != 'MAP'))
        LoadProcess(CProcess);
    else if (typeof (CProcess) != 'undefined' && (CProcess == '2' && CRole !== "1"))
        LoadProcess(CProcess);
}

function ProcessStatus(status, ReqId) {
    var UID = sessionStorage.getItem('ID');
    if (status != 2) {
        $.ajax({
            url: Rurl + "Process=STATUSUPDATE" + "&Status=" + status + "&REQUEST=" + ReqId + (((status == 6) || (status == 100)) ? "&REMARKS=" + $('#TxtCancelReason').val() + "" : "") + "&USERID=" + UID + "",
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {
                if (data[0].RESULT === 'TRUE') {
                    if (status == 6) {
                        if (CurrentCancelStatus == 'PENDING')
                            LoadProcess("2");
                        if (CurrentCancelStatus == 'INPROGRESS')
                            LoadProcess("4");
                        else
                            LoadProcess("3");
                    }
                    else if (status == 100)
                        LoadProcess("100");
                    HideModalPopUp('ModalDone');
                }
                else
                    alert('Failed');
            },
            error: function (data) {

            }

        });
        ReloadLinksButton();
        RestartTimer();
    } else {
        AReqId = ReqId; AStatus = status;
        GetPorter(AReqId);
        if (Port !== '0' && Port !== '1001') {
            ShowModalPopUp('ModalDone');
            AssignPorter();
        }
        else {
            ShowModalPopUp('ModalNoPorter');
            setTimeout("HideModalPopUp('ModalNoPorter');", 1500);
        }
    }
}
function SearchPorterRequest() {
    LoadGrid(CProcess);
}
function AssignPorter() {
    var UID = sessionStorage.getItem('ID');
    $.ajax({
        async: false,
        url: Rurl + "Process=" + ((String(AReqId).indexOf('-_') != -1) ? "MULTIASSIGN" : "ASSIGN") + "&ATIME=" + $('#AReqStartTime').val() + "&PORTID=" + Port + "&STATUS=" + AStatus + "&Request=" + AReqId + "&USERID=" + UID + "",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT === 'TRUE')
                LoadProcess("2");
            else
                alert('Failed');
            HideModalPopUp('ModalCancel');
            setTimeout("HideModalPopUp('ModalDone');", 1500);
        },
        error: function (data) {

        }

    });
}
function GetPorter(RId) {
    $.ajax({
        async: false,
        url: Rurl + "Process=GETPORTERID&RID=" + RId,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT != '0' && data[0].RESULT != '1001')
                Port = data[0].RESULT;
            else {
                Port = data[0].RESULT; //$('#LBLResult').text((data[0].RESULT != '1001') ? 'NO PORTERS AVAILABLE.' : 'REQUESTED NUMBER OF PORTERS NOT AVAILABLE.');
            }
        },
        error: function (data) {

        }

    });
}
function SetPorter(PorterDet, ele) {
    var PortId = PorterDet.split("_")[0], MultiTask = PorterDet.split("_")[2], PortChecked = ele.checked;
    if (PortChecked)
        Port = (Port.length > 0) ? Port + "_" + PortId : PortId;
    else
        Port = (Port.indexOf(PortId + '_') >= 0) ? Port.replace(PortId + '_', '') : (Port.indexOf('_' + PortId) >= 0) ? Port.replace('_' + PortId, '') : Port.replace(PortId, '');
    $("#BtnAssignPorter").css("display", ((Port.split('_').length > 0) ? ((MultiTask == 'YES') && (Port.split('_').length == 2)) ? "inline-block" : ((MultiTask == 'NO') && (Port.split('_').length == 1) && (Port.length > 0)) ? "inline-block" : "none" : "none"));
}
function CloseDone() {
    HideModalPopUp('ModalDone');
}
function CheckMultiTask(sender, e) {
    var len = tableView.get_selectedItems().length, TempReq = '';
    for (var i = 0; i < len; i++)
        TempReq = (TempReq.length > 0) ? TempReq + '-_' + tableView.get_selectedItems()[i].getDataKeyValue("REQUESTID") + '_' : '_' + tableView.get_selectedItems()[i].getDataKeyValue("REQUESTID") + '_';
    if (len >= 1) {
        MANReqID = TempReq, AStatus = tableView.get_selectedItems()[0].getDataKeyValue("STATUS");
        if (len == 1) {
            $('#tdMAPORTERInfo').css("display", "none");
            $('#BtnEdit').css("display", "none");
            $('#tdMultiTask').css("display", "table-cell");
            clearMAPORTERSelection();
        } else {
            $('#tdMultiTask').css("display", "none");
            $('#tdMAPORTERInfo').css("display", ((AStatus > 5) ? "none" : (sessionStorage.getItem('ROLE').toUpperCase() === 'NURSE') ? (AStatus === 5) ? "inline-block" : "none" : (AStatus <= 2) ? "table-cell" : "none"));
            $('#BtnEdit').css("display", "none");
        }
    } else {
        $('#tdMultiTask').css("display", "table-cell");
        $('#tdMAPORTERInfo').css("display", "none");
        $('#BtnEdit').css("display", "none");
        clearMAPORTERSelection();
    }
}
function rowSelecting(sender, args) {
    var RowCurrent = tableView.get_dataItems()[args.get_itemIndexHierarchical()], CheckBox = $get(args.get_id()).getElementsByTagName("input")[0];
    //alert('typeof (CheckBox) : ' + typeof (CheckBox));
    if (tableView.get_selectedItems().length == 0) { ConSelect = true; }
    if ((RowCurrent.getDataKeyValue("MULTIPORTER") == 'YES' && tableView.get_selectedItems().length > 0) || (!ConSelect) || (typeof (CheckBox) == 'undefined')) {
        RowCurrent.set_selected(false);
        if (typeof (CheckBox) != 'undefined')
            CheckBox.checked = false;
        args.set_cancel(true);
    }
    if (RowCurrent.getDataKeyValue("MULTIPORTER") == 'YES' && tableView.get_selectedItems().length == 0) { ConSelect = false; }
}


function rowOnClick(sender, args) {
    var category = args.getDataKeyValue("CATEGORY"), catID = args.getDataKeyValue("CATEGORYID"), MIndex = args.getDataKeyValue("MULTITASKINDEX"), from = args.getDataKeyValue("SOURCE"), DId = args.getDataKeyValue("DESTINATIONLOCATIONID"), dstatus = args.getDataKeyValue("STATUS"),
        Destination = args.getDataKeyValue("UDEST"), ReqNB = args.getDataKeyValue("REQNO"), ReqID = args.getDataKeyValue("REQUESTID"), priority = args.getDataKeyValue("PRIORITY"), MultiPorter = args.getDataKeyValue("MULTIPORTER"),
        eleCategory = $('#RequsetCategory'), DCat = args.getDataKeyValue("UCAT"), txtDest = args.getDataKeyValue("SDESTINATION"), PatientName = args.getDataKeyValue("PATIENTNAME"), userName = args.getDataKeyValue("USER"), extn_No = args.getDataKeyValue("EXTN_NO");;

    var CRole = sessionStorage.getItem('ROLE').toUpperCase();
    //alert(MIndex);
    if (dstatus == '2' || dstatus == '3' || (dstatus == '4' && (CRole === "1" || CRole === "12"))) {
        $("#RequsetCategory").css("cursor", ((MIndex == '0') ? "pointer" : "not-allowed")); $('#ImgMPorter').attr("src", (MultiPorter == 'YES') ? "images/MSelected.png" : "images/MUnselect.png");
        $("#ImgMPorter").css("visibility", (((parseInt(dstatus) == 2) && (MIndex == '0')) ? "visible" : "hidden")).css("cursor", "pointer");


        if (MIndex == '0') {
            $(eleCategory).click(function () {
                if (MIndex == '0') {
                    ShowModalPopUp('ModalECategory'); ECategory = category;
                    IsEdit = 'YES';
                } else
                    return false;
            });
        }
        var LTagId = args.getDataKeyValue("TAGID"), STagId = args.getDataKeyValue("STAGID");
        LTagId = ((LTagId == null) ? '' : LTagId); STagId = ((STagId == null) ? '' : STagId)
        CurrentDStatus = ((dstatus == '2') && (priority != 'LOW')) ? '12' : dstatus;
        var TagId = ((LTagId.length > 0) ? LTagId : '') + ((STagId.length > 0) ? "_" + STagId : ''); GPatientName = PatientName; GFrom = from; GStatus = dstatus; GOMI = ((MultiPorter == 'YES') ? "1" : "0"); GUser = userName;
        $('#RReqNB').text(ReqNB); $('#RequestDept').text(from); $(eleCategory).val(category); $('#txtDestLOcation').val(txtDest); sessionStorage.setItem('DMT', ((MultiPorter == 'YES') ? "1" : "0")); sessionStorage.setItem('ECID', '');
        sessionStorage.setItem('DTOID', DId); sessionStorage.setItem('DTO', Destination); sessionStorage.setItem('DREQID', ReqID); sessionStorage.setItem('DTAGID', TagId); sessionStorage.setItem('CCAT', DCat);
        sessionStorage.setItem('OLDCAT', category); sessionStorage.setItem('OLDDEST', Destination); sessionStorage.setItem('OLDDID', DId); sessionStorage.setItem('OLDCID', catID); GExtn = extn_No; $('#txtExtnNo').val(extn_No);
        ShowModalPopUp('ModalUpdate');

    }
}

function UpdateDloc() {
    var UID = sessionStorage.getItem('ID'), ReqId = sessionStorage.getItem('DREQID'), DestID = sessionStorage.getItem('DTOID'), DTagID = sessionStorage.getItem('DTAGID'),
        Dest = sessionStorage.getItem('DTO'), CID = sessionStorage.getItem('ECID'), Category = sessionStorage.getItem('ECNAME'), CCat = sessionStorage.getItem('CCAT'),
        IsMultiTask = sessionStorage.getItem('DMT'), Modify_By = sessionStorage.getItem('NAME'), OldCat = sessionStorage.getItem('OLDCAT'), OldDest = sessionStorage.getItem('OLDDEST'),
        NewPatient = sessionStorage.getItem('NewPatient'), OldDID = sessionStorage.getItem('OLDDID'), OldCId = sessionStorage.getItem('OLDCID'),
        Lgroup = sessionStorage.getItem('LGROUP'), FloorNo = sessionStorage.getItem('FLOORNO'), ExtnVal = $('#txtExtnNo').val();


    //var modified_from = ((OldCId !== CID) ? ((OldDID !== DestID) ? (OldCat + ", " + OldDest + ", " + GPatientName) : OldCat) : ((OldDID !== DestID) ? (OldDest + ", " + GPatientName) : "")) + ((ExtnVal !== GExtn) ? GExtn : ""),
    //    modified_with = (OldCId !== CID) ? ((OldDID !== DestID) ? (Category + ", " + Dest + ", " + NewPatient) : Category) : ((OldDID !== DestID) ? (Dest + ", " + NewPatient) : "") + ((ExtnVal !== GExtn) ? ExtnVal : "");

    var modified_from = (((CID.length > 0) && (OldCId !== CID)) ? (((DestID.length > 0) && (OldDID !== DestID)) ? (OldCat + ", " + OldDest + ", " + GPatientName) : OldCat) : (((DestID.length > 0) && (OldDID !== DestID)) ? (OldDest + ", " + GPatientName) : "")) + ((ExtnVal !== GExtn) ? ", " + GExtn : ""),
        modified_with = (((CID.length > 0) && (OldCId !== CID)) ? (((DestID.length > 0) && (OldDID !== DestID)) ? (Category + ", " + Dest + ", " + NewPatient) : Category) : (((DestID.length > 0) && (OldDID !== DestID)) ? (Dest + ", " + NewPatient) : "")) + ((ExtnVal !== GExtn) ? ", " + ExtnVal : "");

    var status = CurrentDStatus;

    ShowModalPopUp('ModalDone');
    $.ajax({
        url: Rurl + "Process=UPDATELOCATION&REQUEST=" + ReqId + "&DID=" + DestID + "&TAGID=" + DTagID + "&DLOC=" + Dest + "&CID=" + CID + "&CNAME=" + Category + "&CCAT=" + CCat + "&USERID=" + UID + "&MT=" + IsMultiTask + "&FROM=" + GFrom + "&PATIENTNAME=" + NewPatient + "&STATUS=" + GStatus + "&OMI=" + GOMI + "&GUSER=" + GUser + "&MODIFY_BY=" + Modify_By + "&MODIFY_FROM=" + modified_from + "&MODIFY_WITH=" + modified_with + "&LGROUP=" + Lgroup + "&FLOORNO=" + FloorNo + "&EXTN_NO=" + ExtnVal,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT === 'TRUE') {
                HideModalPopUp('ModalUpdate'); clearUpdateLoc();
                LoadProcess(status);
                setTimeout(function () { HideModalPopUp('ModalDone') }, 1500);
            }
            else
                alert('Failed');
        },
        error: function (data) {

        }

    });
    setTimeout(function () { ReloadLinksButton(); RestartTimer(); }, 500);
}
function clearUpdateLoc() {
    sessionStorage.setItem('LGROUP', '');
    sessionStorage.setItem('FLOORNO', '');
    sessionStorage.setItem('OLDDID', '');
    sessionStorage.setItem('OLDCID', '');
    sessionStorage.setItem('NewPatient', '');
    sessionStorage.setItem('OLDCAT', '');
    sessionStorage.setItem('OLDDEST', '');
    sessionStorage.setItem('DREQID', '');
    sessionStorage.setItem('DTOID', '');
    sessionStorage.setItem('DTAGID', '');
    sessionStorage.setItem('DTO', '');
    sessionStorage.setItem('ECID', '');
    sessionStorage.setItem('ECNAME', '');
    sessionStorage.setItem('CCAT', '');
}
function CloseandEBind(Id, Category, SCategory) {
    HideModalPopUp('ModalECategory'); $('#RequsetCategory').val(Category); sessionStorage.setItem('ECID', Id); sessionStorage.setItem('ECNAME', Category);
    $('#ImgMPorter').attr("src", (Id == "27") ? "images/MSelected.png" : "images/MUnselect.png");
    sessionStorage.setItem('DMT', ((Id == "27") ? "1" : "0"));
}
function OnRowCreated(sender, args) {
    args.get_item().get_cell('LOCATE').onclick = function () {
        var LTagId = args.get_item().getDataKeyValue("TAGID"), PName = args.get_item().getDataKeyValue("ASSIGNTO"),
            wind = window.open('../Track/Popup.aspx?TagId=' + LTagId + "&Name=" + PName, 'TRACKING : #' + PName, 'directories=no,titlebar=yes,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=500');
    };
    args.get_item().get_cell('BUZZER').onclick = function () {
        var CRole = sessionStorage.getItem('ROLE').toUpperCase();
        var LTagId = args.get_item().getDataKeyValue("TAGID"), ABTAT = args.get_item().getDataKeyValue("ASGNTAT");
        if ((CRole == '1') || (ABTAT > 9)) {
            ShowModalPopUp('ModalDone');
            $.ajax({
                url: Burl + LTagId,
                type: 'POST',
                data: 'pData',
                dataType: 'json',
                success: function (data) {
                    if (data[0].RESULT === 'TRUE')
                        setTimeout("HideModalPopUp('ModalDone');", 1500);
                },
                error: function (data) {

                }

            });
        }
    };
}
function MultiTask() {
    //alert(AReqId);
    ProcessStatus(AStatus, AReqId);
}
function ShowEdit() {
    if (EStatus > 4)
        $('#BtnCancelRequest').css("visibility", "hidden");
    else
        $('#BtnCancelRequest').css("visibility", "visible");
    $find('mpReqEdit').show();
}
function CancelRequest() {
    var drpVal = $("#drpCancelReason").val();
    var CReason = (drpVal == "0") ? $('#txtCancelReason').val() : $("#drpCancelReason option:selected").text();
    if (CReason.length > 0) {
        HideModalPopUp('ModalCancel');
        ShowModalPopUp('ModalDone');
        GCancelReason = CReason;
        if ((RequestType == "PreBook"))
            ProcessStatus(((RequestType == "PreBook") ? 100 : 6), CancelReqId);
        else
            CancelCurrentRequest(GCancelReason);
    }
    else
        $('#TxtCancelReason').focus();
}
function CancelCurrentRequest(Reason) {
    var UID = sessionStorage.getItem('ID');
    HideModalPopUp('ModalFinish');
    $.ajax({
        url: Rurl + "Process=CANCELTASK&TAGID=" + GTagID + "&REASON=" + Reason + "&USERID=" + UID + "&REQUESTID=" + GReqID + "&PORTERIDS=" + GPorterID + "&MIINDEX=" + GMIndex,
        type: 'POST',
        data: 'pData',
        async: true,
        dataType: 'json',
        success: function (data) {
            HideModalPopUp('ModalDone');
            if (CurrentCancelStatus == 'PENDING')
                LoadProcess("2");
            else if (CurrentCancelStatus == 'EMRGENCY')
                LoadProcess("12");
            else if (CurrentCancelStatus == 'INPROGRESS')
                LoadProcess("4");
            else
                LoadProcess("3");

        },
        error: function (data) {

        }

    });
    setTimeout(function () { ReloadLinksButton(); RestartTimer(); }, 500);

}

function Redirect(RedirectTo) {
    window.location = RedirectTo;
}

/* Date Picker Start */


function calldatetime() {
    $('#requestdate').val('Pre-Book');

    var d = new Date(), smonth = (d.getMonth() + 1), sdate = d.getDate(), sminut = d.getMinutes();
    sminut = (parseInt(sminut) < 15) ? '15' : (parseInt(sminut) < 30) ? '30' : (parseInt(sminut) < 45) ? '45' : '00';
    smonth = (smonth.toString().length == 1) ? ('0' + smonth.toString()) : smonth.toString();
    sdate = (sdate.toString().length == 1) ? ('0' + sdate.toString()) : sdate.toString();
    var sDateTime = [smonth, sdate,
        d.getFullYear()].join('/') + ' ' +
        [d.getHours(),
            sminut].join(':');
    var newdate = new Date(); newdate.setDate(newdate.getDate() + 7);
    $('*[name=requestdate]').appendDtpicker({
        "onShow": function (handler) {
            //  window.alert('Picker is shown!');
        },
        "onHide": function (handler) {
            //  window.alert('Picker is hidden!');
        },
        "current": sDateTime,
        "dateFormat": "DD/MM/YYYY hh:mm",
        "todayButton": false,
        "minTime": "08:00",
        "maxTime": "20:01",
        "minuteInterval": 15,
        "futureOnly": true,
        "destroy": true,
        "changeMonth": false,
        "minDate": new Date(),
        "maxDate": new Date(newdate)

    });

    olddatetime = $('#requestdate').val();
    if (prebook == '')
        $('#requestdate').val('Pre-Book');
}


/* Date Picker End */



function OnchangeRemarks(ele) {
    var selectedValue = $(ele).val();
    $("#txtReqRemarks").css("display", ((selectedValue == "0") ? "inline-block" : "none"))
}

function OnchangeMessage(ele) {
    var selectedValue = $(ele).val();
    $("#txtPriorityReason").css("display", ((selectedValue == "0") ? "inline-block" : "none"))
}

function OnFinishReason(ele) {
    var selectedValue = $(ele).val();
    $("#txtFinishReason").css("display", ((selectedValue == "0") ? "inline-block" : "none"))
}
function OnCancelReason(ele) {
    var selectedValue = $(ele).val();
    $("#txtCancelReason").css("display", ((selectedValue == "0") ? "inline-block" : "none"))
}
function OnchangeLocation(InputID, ContainerID) {
    var SearchVal = $('#' + InputID).val();
    $.ajax({
        async: true,
        url: Rurl + "Process=GETSEARCHEDLOCATION&LOCATION=" + SearchVal,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            $('#' + ContainerID + '').html(data[0].RESULT);
        },
        error: function (data) {

        }

    });
}
function OnchangeDLocation(InputID, ContainerID) {
    var SearchVal = $('#' + InputID).val();

    $.ajax({
        async: true,
        url: Rurl + "Process=GETSEARCHEDLOCATIOND&LOCATION=" + SearchVal,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            if (data.length > 0)
                $('#' + ContainerID + '').html(data[0].RESULT);

            $('#' + ContainerID).css('display', ((data.length > 0) ? 'block' : 'none'));


        },
        error: function (data) {

        }

    });
}



function getPatientName(BedID) {

    var PUrl = Rurl + "Process=GETPATIENTNAME&BEDID=" + BedID;
    $.ajax({
        async: true,
        url: PUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            var PatientName = data[0].RESULT;
            if (PatientName.length > 0)
                sessionStorage.setItem('NewPatient', PatientName);
            else
                sessionStorage.setItem('NewPatient', '');
        },
        error: function (data) {

        }

    });
}

function BindDLocation(Id, Value, BedID, LGroup, FloorNo) {
    sessionStorage.setItem('LGROUP', LGroup); sessionStorage.setItem('FLOORNO', FloorNo);
    sessionStorage.setItem('DTOID', Id); sessionStorage.setItem('DTO', Value);
    $('#txtDestLOcation').val(Value);
    $('#DivDestContent').css('display', 'none');

    if (BedID == '-')
        sessionStorage.setItem('NewPatient', '');
    else
        getPatientName(BedID);
}

function FinishRequest() {
    var FReason = $("#drpFinishReason").val(),
        FReason = (FReason == "0") ? $('#txtFinishReason').val() : $("#drpFinishReason option:selected").text();
    if (FReason.length > 0) {
        HideModalPopUp('ModalCancel');
        ShowModalPopUp('ModalDone');
        CompleteRequest(FReason);
    }
    else
        $('#txtFinishReason').focus();
}
function SetPriority(RequestId, Process) {
    $.ajax({
        async: true,
        url: Rurl + "Process=PRIORITY&REQUESTID=" + RequestId + "&Priority=" + Process,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            LoadProcess('2');
            HideModalPopUp('ModalLoading');
        },
        error: function (data) {

        }

    });
}


function setPatientName(BedID, Location) {
    if (Location == 'From')
        FPatientName = '';
    else if (Location == 'To')
        TPatientName = '';


    $('#' + ((Location == 'From') ? 'spanFromPatient' : 'spanToPatient') + '').html('');

    if (BedID == '-') {
        if (Location == 'From')
            $('#spanFromPatient').html('');
        else if (Location == 'To')
            $('#spanToPatient').html('');
    } else {
        var PUrl = Rurl + "Process=GETPATIENTNAME&BEDID=" + BedID;
        $.ajax({
            async: true,
            url: PUrl,
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {
                var PatientName = data[0].RESULT;
                $('#' + ((Location == 'From') ? 'spanFromPatient' : 'spanToPatient') + '').html(PatientName);
                if (PatientName.length > 0) {
                    if (Location == 'From')
                        FPatientName = PatientName;
                    else if (Location == 'To')
                        TPatientName = PatientName;
                }

            },
            error: function (data) {

            }

        });
    }

}
function calldatetime1(currentDate) {
    $('#RequestEDate').val(currentDate);

    var d = new Date(), smonth = (d.getMonth() + 1), sdate = d.getDate(), sminut = d.getMinutes();
    sminut = (parseInt(sminut) < 15) ? '15' : (parseInt(sminut) < 30) ? '30' : (parseInt(sminut) < 45) ? '45' : '00';
    smonth = (smonth.toString().length == 1) ? ('0' + smonth.toString()) : smonth.toString();
    sdate = (sdate.toString().length == 1) ? ('0' + sdate.toString()) : sdate.toString();
    var sDateTime = [smonth, sdate,
        d.getFullYear()].join('/') + ' ' +
        [d.getHours(),
            sminut].join(':');
    var newdate = new Date(); newdate.setDate(newdate.getDate() + 1); newdate.setHours(23); newdate.setMinutes(59);
    $('*[name=RequestEDate]').appendDtpicker({
        "onShow": function (handler) {
            //  window.alert('Picker is shown!');
        },
        "onHide": function (handler) {
            //  window.alert('Picker is hidden!');
        },
        "current": sDateTime,
        "dateFormat": "DD/MM/YYYY hh:mm",
        "todayButton": false,
        "minTime": "08:00",
        "maxTime": "20:00",
        "minuteInterval": 5,
        "futureOnly": false,
        "destroy": true,
        "changeMonth": false,
        "minDate": new Date(),
        "maxDate": new Date(newdate),
        "closeOnSelected": true

    });

}

function startMANCount() {
    MANInterval = window.setInterval(function () { processMAN(); }, 1000);
}


function processMAN() {
    if (MANCount == 0)
        clearMANAssign('DB');
    else {
        $('#MANCount').text(MANCount);
        MANCount -= 1;
    }
}

function clearMAPORTERSelection() {
    var DivPorterHolder1 = $('#DivMAPORTERHolder'), PorterHolder1 = $('#MAPORTERHolder');
    Isclear = true;
    $(DivPorterHolder1).css("background-image", "url(Images/Porter.PNG)");
    $(DivPorterHolder1).css("background-color", "rgb(30, 70, 129)");
    $(PorterHolder1).css("display", "none"); $('#PorterName1').text('');
    MANPorterID = ''; MANPorterName = '';
    setTimeout(function () { Isclear = false; }, 500);
    $('#tbltbnMultiTask').css("display", "none");
}

function showMAPORTERs() {
    if (!Isclear) {
        ShowModalPopUp('ModalLoading'); // getMAPorters("NO");
        setTimeout(function () { ShowModalPopUp('ModalMANPorter'); HideModalPopUp('ModalLoading'); }, 500);
    }
}
function OnchangeMANPorter(InputID, ContainerID) {
    var SearchVal = $('#' + InputID).val();
    $.ajax({
        async: true,
        url: Rurl + "Process=GETDEPTIDLEPORTERS&DEPT=ALL&PORTERNAME=" + SearchVal + "&PORTERID1=" + PorterID + "&PORTERID2=" + PorterID1,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (msg) {
            var Table = "<table width='95%' cellpadding='5' cellspacing='5' style='border-collapse: separate;'><tr>", i = 1;

            $.each(msg, function (key, value) {
                var Photo = (value.PHOTO.length > 0) ? value.PHOTO : 'Images/DefaultPorter.PNG',
                    vstatus = value.STATUS;
                var statusbgColor = (vstatus == 'IDLE') ? 'green' : ((vstatus == 'ASSIGNED') ? 'yellow' : 'red'),
                    statusColor = (vstatus == 'IDLE') ? 'white' : ((vstatus == 'ASSIGNED') ? 'black' : 'white');
                Table += "<td align='center'>" + "<table onclick='CloseandBindMAPorter(" + '"' + value.ID + '"' + ',"' + value.VAL + '"' + ',"ModalMANPorter"' + ',"' + Photo + '"' + ");' class='PorterList'> <tr style='height: 20px; background-color: rgb(30, 70, 129);'><td align='center'><span style='color:white;font-family: Monospace; font-size: 12px;'>" + value.VAL + "</span></td></tr><tr style='height: 85px;'><td style='background-repeat: no-repeat;background-size: 98% 98%; background-position: center;background-image: url(" + Photo + ");'></td></tr> <tr style='background:" + statusbgColor + "; height: 20px;'><td align='center' style='vertical-align: middle;padding-top: 2px;'><span style='font-size: 11px;font-weight: bold;color:" + statusColor + "'>" + vstatus + "</span></td></tr></table> </td>"
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
function getMAPorters(Initiate) {
    $.ajax({
        url: Rurl + "Process=GETDEPTIDLEPORTERS&DEPT=ALL&ISINITIATE=" + Initiate + "&PORTERID1=" + MANPorterID + "&PORTERID2=",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (msg) {
            var ContainerID = "DivMANPorterContent";
            var Table = "<table width='95%' cellpadding='5' cellspacing='5' style='border-collapse: separate;'><tr>", i = 1;

            $.each(msg, function (key, value) {
                var Photo = (value.PHOTO.length > 0) ? value.PHOTO : 'Images/DefaultPorter.PNG',
                    vstatus = value.STATUS;
                var statusbgColor = (vstatus == 'IDLE') ? 'green' : ((vstatus == 'ASSIGNED') ? 'yellow' : 'red'),
                    statusColor = (vstatus == 'IDLE') ? 'white' : ((vstatus == 'ASSIGNED') ? 'black' : 'white');
                Table += "<td align='center'>" + "<table onclick='CloseandBindMAPorter(" + '"' + value.ID + '"' + ',"' + value.VAL + '"' + ',"ModalMANPorter"' + ',"' + Photo + '"' + ");' class='PorterList'> <tr style='height: 20px; background-color: rgb(30, 70, 129);'><td align='center'><span style='color:white;font-family: Monospace; font-size: 12px;'>" + value.VAL + "</span></td></tr><tr style='height: 85px;'><td style='background-repeat: no-repeat;background-size: 98% 98%; background-position: center;background-image: url(" + Photo + ");'></td></tr> <tr style='background:" + statusbgColor + "; height: 20px;'><td align='center' style='vertical-align: middle;padding-top: 2px;'><span style='font-size: 11px;font-weight: bold;color:" + statusColor + "'>" + vstatus + "</span></td></tr></table> </td>"
                Table += (i == 3) ? "</tr><tr>" : ""; i = (i == 3) ? 1 : i + 1;



            });
            Table += "</tr></table>";
            $('#' + ContainerID + '').html(Table);

            if (Initiate == 'YES') {
                startMANCount();
                $('#trMANCount').css('display', 'table-row');
            }
        },
        error: function (data) {

        }

    });
}


function CloseandBindMAPorter(ID, Value, Modal, Photo, Dept) {
    HideModalPopUp(Modal);
    var PorterImg = (Photo.length > 0) ? 'url("' + Photo + '")' : "none !important";
    $('#DivMAPORTERHolder').css("background-image", "none !important");
    $('#DivMAPORTERHolder').css("background-color", "none !important");
    $('#MAPORTERHolder').css("display", "table");
    $('#MAPORTERName').text(Value); $('#MAPORTERImage').css("background-image", PorterImg);
    MANPorterID = ID.split("-")[0]; MANPorterName = Value;
    $('#tbltbnMultiTask').css("display", "table");
}

function clearMANDB() {
    $.ajax({
        async: true,
        url: Rurl + "Process=CLEARMANUALASSIGN&DEPT=ALL",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

        },
        error: function (data) {

        }

    });
}

