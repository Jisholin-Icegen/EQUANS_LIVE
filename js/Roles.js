var arr = ["TextSOURCE", "TextCATEGORY", "TextDESTINATION"], ReqIcon = ["tdReqNew", "tdReqPending", "tdReqAssigned", "tdReqInProc", "tdReqCompleted", "tdReqCancelled", "tdPreBook", "tdReqMap"],
    Source = '', Dest = '', User = '', Cat = '', AStatus = '', CancelReqId = '', EStatus = '', Intervl = 0, EReqId = '', ReqArr = ["tdReqPending", "tdReqAssigned", "tdReqInProc", "tdReqCompleted", "tdReqCancelled", "tdPreBook"],
    CurPendProcess = '', AReqId = '', MReqId = '', IsChecked = false, Port = '', Name = "", RequestType = '', CurrentCancelStatus = '';

var arrRoles = ['2_SUPERVISOR', '3_NURSE']; // '1_APPUSER', 

//function LoaddrRoles() {

//    $('#search_RoleName').html(''); $('#search_RoleName')[0].sumo.add('0', '-- Select --'); $('#search_RoleName')[0].sumo.reload();
//    $.each(arrRoles, function (index, value) {
//        $('#search_RoleName')[0].sumo.add(value.split('_')[0], value.split('_')[1]);
//    });
//}


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
//function InsertRequest() {
//    var Visiblility = $('#ImgMultiPorter').css("visibility"), MultiSrc = $('#ImgMultiPorter').attr('src'), IsMultiPorter = ((MultiSrc == 'images/MultiSelected.png') && (Visiblility == 'visible')) ? "1" : "0",
//        UID = sessionStorage.getItem('ID'), time = (((new Date().getHours().toString()).length <= 1) ? ("0" + new Date().getHours().toString()) : (new Date().getHours()))
//            + ":" + (((new Date().getMinutes().toString()).length <= 1) ? ("0" + new Date().getMinutes()) : new Date().getMinutes()),
//        PBDate = GetPBDate($('#requestdate').val());
//    var PatientName = FPatientName + '_' + TPatientName, MRDNo = $.trim($('#textMRD').val());
//    //var drpRemarks = $("#drpPresetRemarks").val(),
//    //    ReqRemarks = (drpRemarks == "0") ? $('#txtReqRemarks').val() : $("#drpPresetRemarks option:selected").text();
//    var ReqRemarks = $('#txtReqRemarks').val();

//    prebook = (prebook !== 'yes') ? (($('#requestdate').val() == "Pre-Book") ? "" : 'yes') : prebook;

//    $.ajax({
//        async: true,
//        url: hurl + "Service/Service.aspx?Process=INSERT&TIME=" + time + "&REMARK=" + ReqRemarks + "&SOURCE=" + Source + "&HALT1=&HALT2=&DESTINATION=" + Dest + "&CATEGORY=" + Cat + "&PRIORITY=0&ISMULTIPORTER=" + IsMultiPorter + "&USERID=" + UID + "&PREBOOKING=" + (prebook + ',' + PBDate) + "&PATIENTNAME=" + PatientName + "&MRD=" + MRDNo + '_' + MRDPatientName,
//        type: 'POST',
//        data: 'pData',
//        dataType: 'json',
//        success: function (data) {
//            ToUpdate = !ToUpdate; ReloadLinks();
//            if (data[0].RESULT.split("_")[0] === 'TRUE' && prebook !== 'yes') {
//                ShowModalPopUp('ModalDone'); ClearRequest();
//                GetMap();
//            }
//            else if (data[0].RESULT.split("_")[0] === 'WAIT') {
//                var startAt = data[0].RESULT.split("_")[1];
//                $('#LBL2min').text('You can not request porter until ' + startAt);
//                ShowModalPopUp('ModelAfter2min');
//                setTimeout("HideModalPopUp('ModelAfter2min');", 3500);
//            }
//            else if (data[0].RESULT.split("_")[0] === 'FALSE') {
//                ShowModalPopUp('ModalRequestExist');
//                setTimeout("HideModalPopUp('ModalRequestExist');", 3500);
//            }
//            else if (data[0].RESULT.split("_")[0] === 'INVALID') {
//                ShowModalPopUp('ModalTimeLimit');
//                setTimeout("HideModalPopUp('ModalTimeLimit');", 3500);
//            }
//            prebook = '';
//            setTimeout("HideModalPopUp('ModalDone');", 1500);
//            calldatetime();
//        },
//        error: function (xhr, ajaxOptions, thrownError) {
//        }

//    });
//}
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

function LoadGrid() {
    var FinalUrl = hurl + "Service/Service.aspx?Process=GETROLESWEBUSER&SEARCH=" + $('#TextSearchLocation').val() + "&PageIndex=" + pageIndex + "&PageSize=" + pageSize;
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


function GridRoles_Command(sender, args) {
    args.set_cancel(true);
    pageIndex = parseInt(sender.get_masterTableView().get_currentPageIndex());
    pageSize = sender.get_masterTableView().get_pageSize();
    switch (args.get_commandName()) {
        case "Page":
        case "PageSize":
            ShowModalPopUp('ModalLoading');
            LoadProcess();
            break;
    }
}

function OnRowCreated(sender, args) {
    //args.get_item().get_cell('LOCATE').onclick = function () {
    //    var LTagId = args.get_item().getDataKeyValue("TAGID"), PName = args.get_item().getDataKeyValue("ASSIGNTO"),
    //        wind = window.open('../Track/Popup.aspx?TagId=' + LTagId + "&Name=" + PName, 'TRACKING : #' + PName, 'directories=no,titlebar=yes,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=500');
    //};
    //args.get_item().get_cell('BUZZER').onclick = function () {
    //    var CRole = sessionStorage.getItem('ROLE').toUpperCase();
    //    var LTagId = args.get_item().getDataKeyValue("TAGID"), ABTAT = args.get_item().getDataKeyValue("ASGNTAT");
    //    if ((CRole == '1') || (ABTAT > 9)) {
    //        ShowModalPopUp('ModalDone');
    //        $.ajax({
    //            url: Burl + LTagId,
    //            type: 'POST',
    //            data: 'pData',
    //            dataType: 'json',
    //            success: function (data) {
    //                if (data[0].RESULT === 'TRUE')
    //                    setTimeout("HideModalPopUp('ModalDone');", 1500);
    //            },
    //            error: function (data) {

    //            }

    //        });
    //    }
    //};
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


function loadNBsuggesstion(Val) {
    if (ENearByZoneIDs.length == 0) {
        $.ajax({
            async: true,
            url: hurl + "Service/Service.aspx?Process=GETSEARCHEDLOCATION&LOCATION=" + Val + "&CURIDS=" + ENearByZoneIDs,
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            beforeSend: function () {
                $("#txtsearchNearbyZones").css("background", "#FFF url(../images/LoadingN.gif) no-repeat 95%").css("background-size", "35px");

            },
            success: function (data) {
                $("#suggesstionNearBy").show();
                $("#suggesstionNearBy").html(data[0].RESULT);
                $("#txtsearchNearbyZones").css("background", "#FFF");
            }
        });
    }
}



function BindLocation(Id, Value) {

    ENearByZoneArr += ((ENearByZoneArr.length > 0) ? ',' : '') + Id.toString() + '|$|' + Value.toString();
    $("#txtsearchNearbyZones").val(''); $("#suggesstionNearBy").hide();
    setNearByZones();
}


function UnBindLocation(Value) {
    var valwithComma = Value + ",";
    if (ENearByZoneArr.includes(valwithComma))
        ENearByZoneArr = ENearByZoneArr.replace(valwithComma, "");
    else
        ENearByZoneArr = ENearByZoneArr.replace(Value, "");
    setNearByZones();
}


function setNearByZones() {

    var arrRemarks = ENearByZoneArr.split(',');
    var htmlNearByZonesNotes = ''; ENearByZoneIDs = '';
    $.each(arrRemarks, function (index, value) {
        if (value.trim()) {
            var valueArray = value.split('|$|');

            var b = '<a onclick="UnBindLocation(' + "'" + value + "'" + ');"> <img src="../images/Delete.png" alt="Delete" height="22px" class="GridIcons" style="cursor:pointer" /></a> ';

            htmlNearByZonesNotes += '<div class="msgContainer"><p class="msgUser">' + valueArray[1].toString() + '<span class="time-right">' + b + '</span></div>'
            ENearByZoneIDs += ((ENearByZoneIDs.length > 0) ? ',' : '') + valueArray[0].toString();

        }
    });
    $('#divNearByZones').html(htmlNearByZonesNotes); $('#divNearByZones').show(800);

}


function setEditRole(RoleID, RoleName, valHome, valTRACK, valReport, valRoutine, valPorter, valTaskType, valLocations, valUpload, valgroup, valRemarks, valUsers, valRoles, valPerform, valBREAKS, valIsActive, valStartComplete, valCancel) {
    $('#chkHOME').attr("src", valHome); $('#chkTRACK').attr("src", valTRACK); $('#chkREPORT').attr("src", valReport); $('#chkROUTINE').attr("src", valRoutine); $('#chkPORTER').attr("src", valPorter);
    $('#chkTASKTYPE').attr("src", valTaskType); $('#chkLOCATION').attr("src", valLocations); $('#chkUPLOAD').attr("src", valUpload); $('#chkGROUP').attr("src", valgroup); $('#chkREMARKS').attr("src", valRemarks);
    $('#chkUSER').attr("src", valUsers); $('#chkROLE').attr("src", valRoles); $('#chkPERFORM').attr("src", valPerform); $('#chkBREAKS').attr("src", valBREAKS);

    $('#chkStartComplete').attr("src", valStartComplete); $('#chkCancelTask').attr("src", valCancel);

    $('#chkIsActive').attr("src", valIsActive);

    ERoleID = RoleID; Erolename = RoleName;

    $('#txtRoleName').val(RoleName);  //  $('#selectFloor').val(FloorID);
    $('#LocationHeader').html('Edit Role #' + RoleName);

    $('#btnDeleteLocation').css("display", "flex"); ShowModaladdRole();

}

function addRole() {
    var srcEmpty = '../images/CNoCheck.png';
    $('#txtRoleName').val('');  //  $('#selectFloor').val(FloorID);
    ENearByZoneIDs = ''; ENearByZoneArr = ''; setNearByZones(); ETreeID = '';
    $('#chkIsActive').attr("src", "../images/CCheck.png");
    $('#chkHOME').attr("src", srcEmpty); $('#chkTRACK').attr("src", srcEmpty); $('#chkREPORT').attr("src", srcEmpty); $('#chkROUTINE').attr("src", srcEmpty); $('#chkPORTER').attr("src", srcEmpty); $('#chkTASKTYPE').attr("src", srcEmpty); $('#chkLOCATION').attr("src", srcEmpty);
    $('#chkUPLOAD').attr("src", srcEmpty); $('#chkGROUP').attr("src", srcEmpty); $('#chkREMARKS').attr("src", srcEmpty); $('#chkUSER').attr("src", srcEmpty); $('#chkROLE').attr("src", srcEmpty); $('#chkPERFORM').attr("src", srcEmpty);

    ShowModaladdRole(); $('#LocationHeader').html('Add Role');
    setTimeout(function () { $('#txtUserName').focus(); }, 500);
    $('#btnDeleteLocation').css("display", "none");


}

function submitRoles() {
    var Action = $('#LocationHeader').html();

    var RoleName = $('#txtRoleName').val();

    if (RoleName.length == 0) {
        $('#txtRoleName').focus();
        $('#txtRoleName').css('border', '2px solid red'); setTimeout(function () { $('#txtRoleName').css('border', '1px solid rgb(248, 247, 247)'); }, 2500);
    }
    else {
        AddUpdateRole(RoleName, ((Action == 'Add Role') ? "INSERT" : "UPDATE"));

    }

}
function deleteLocation() {
    var UserName = $('#txtRoleName').val();
    ERoleID = encodeURIComponent(Encrypt(ERoleID)); Action = encodeURIComponent(Encrypt('DELETE'));
    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=UPDATEROLE&ACTION=" + Action + "&ID=" + ERoleID,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT.split("_")[0] === 'TRUE') {
                $('#LBLRequestResult').html('Role Details Removed Successfully.. Role Name. #' + UserName);

                HideModalPopUp('addRole'); ShowModalPopUp('modalSuccess');
                setTimeout("HideModalPopUp('modalSuccess');", 2500); LoadProcess();
            } else {
                $('#spanAlertMessage').html('Role in use and can not be deleted.. Role Name. #' + UserName);
                ShowModalPopUp('modalAlert');
                setTimeout("HideModalPopUp('modalAlert');HideModalPopUp('addRole');", 3500);
            }
        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}

function AddUpdateRole(RoleName, Action) {

    var chkIsActiveSrc = $('#chkIsActive').attr("src"),
        chkHOME = $('#chkHOME').attr("src"), chkTRACK = $('#chkTRACK').attr("src"), chkREPORT = $('#chkREPORT').attr("src"), chkROUTINE = $('#chkROUTINE').attr("src"), chkPORTER = $('#chkPORTER').attr("src"), chkTASKTYPE = $('#chkTASKTYPE').attr("src"), chkLOCATION = $('#chkLOCATION').attr("src"),
        chkUPLOAD = $('#chkUPLOAD').attr("src"), chkGROUP = $('#chkGROUP').attr("src"), chkREMARKS = $('#chkREMARKS').attr("src"), chkUSER = $('#chkUSER').attr("src"), chkROLE = $('#chkROLE').attr("src"), chkPERFORM = $('#chkPERFORM').attr("src"), chkBREAKS = $('#chkBREAKS').attr("src"),
        chkStartComplete = $('#chkStartComplete').attr("src"), chkCancelTask = $('#chkCancelTask').attr("src"),

        Userr = RoleName;
    var Isactive = (chkIsActiveSrc == "../images/CNoCheck.png") ? "0" : "1";

    var TreeID = ((chkHOME == "../images/CNoCheck.png") ? "" : "1") + "_" + ((chkTRACK == "../images/CNoCheck.png") ? "" : "2") + "_" + ((chkREPORT == "../images/CNoCheck.png") ? "" : "3") + "_" + ((chkROUTINE == "../images/CNoCheck.png") ? "" : "4") + "_" + ((chkPORTER == "../images/CNoCheck.png") ? "" : "5") + "_" +
        ((chkTASKTYPE == "../images/CNoCheck.png") ? "" : "6") + "_" + ((chkLOCATION == "../images/CNoCheck.png") ? "" : "7") + "_" + ((chkUPLOAD == "../images/CNoCheck.png") ? "" : "8") + "_" + ((chkGROUP == "../images/CNoCheck.png") ? "" : "9") + "_" + ((chkREMARKS == "../images/CNoCheck.png") ? "" : "10") + "_" +
        ((chkUSER == "../images/CNoCheck.png") ? "" : "11") + "_" + ((chkROLE == "../images/CNoCheck.png") ? "" : "12") + "_" + ((chkPERFORM == "../images/CNoCheck.png") ? "" : "13") + "_" + ((chkBREAKS == "../images/CNoCheck.png") ? "" : "14") + "_"
        + ((chkStartComplete == "../images/CNoCheck.png") ? "" : "15") + "_" + ((chkCancelTask == "../images/CNoCheck.png") ? "" : "16");

    var URoleName = encodeURIComponent(Encrypt(RoleName)); UETreeID = encodeURIComponent(Encrypt(TreeID)); UIsactive = encodeURIComponent(Encrypt(Isactive)); UAction = encodeURIComponent(Encrypt(Action)); UERoleID = encodeURIComponent(Encrypt(ERoleID));


    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=UPDATEROLE&ROLENAME=" + URoleName + "&ISACTIVE=" + UIsactive + "&ACTION=" + UAction + "&TREEID=" + UETreeID + "&ID=" + UERoleID,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT.split("_")[0] === 'TRUE') {
                $('#LBLRequestResult').html('Role Details ' + ((Action == "UPDATE") ? 'Updated' : 'Added') + ' Successfully.. Role Name. #' + Userr);

                HideModalPopUp('addRole'); ShowModalPopUp('modalSuccess');
                setTimeout("HideModalPopUp('modalSuccess');", 2500); LoadProcess();
            }
            else {
                $('#spanAlertMessage').html('ROLE DETAILS ALREADY EXISTS... Role Name. #' + Userr);
                ShowModalPopUp('modalAlert');
                setTimeout("HideModalPopUp('modalAlert');HideModalPopUp('addRole');", 3500);
            }
        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}

function ShowNearByLoc(NearByZones) {
    var arrRemarks = NearByZones.split(',');
    var htmlNearByZonesNotes = '';
    $.each(arrRemarks, function (index, value) {
        if (value.trim()) {
            var valueArray = value.split('|$|');

            var b = '<a onclick="UnBindLocation(' + "'" + value + "'" + ');"> <img src="../images/Delete.png" alt="Delete" height="22px" class="GridIcons" style="cursor:pointer;display:none;" /></a> ';

            htmlNearByZonesNotes += '<div class="msgContainer"><p class="msgUser">' + valueArray[1].toString() + '<span class="time-right">' + b + '</span></div>'

        }
    });
    $('#divNearByLocations').html(htmlNearByZonesNotes); ShowModalPopUp('modalNearByList'); $('#divNearByLocations').show(800);
}

function GridRoles_RowDataBound(sender, args) {

    var CRole = sessionStorage.getItem('ROLE').toUpperCase(), UID = sessionStorage.getItem('ID');
    var RoleID = args.get_item().getDataKeyValue("ID"), rolename = args.get_item().getDataKeyValue("ROLENAME");


    var HOME = args.get_item().getDataKeyValue("HOME"), TRACK = args.get_item().getDataKeyValue("TRACK"), REPORTS = args.get_item().getDataKeyValue("REPORTS"), ROUTINE = args.get_item().getDataKeyValue("ROUTINE"),
        PORTER = args.get_item().getDataKeyValue("PORTER"), TASKTYPE = args.get_item().getDataKeyValue("TASKTYPE"), LOCATIONS = args.get_item().getDataKeyValue("LOCATIONS"), UPLOAD = args.get_item().getDataKeyValue("UPLOAD"),
        GROUP = args.get_item().getDataKeyValue("GROUP"), REMARKS = args.get_item().getDataKeyValue("REMARKS"), USERS = args.get_item().getDataKeyValue("USERS"), ROLES = args.get_item().getDataKeyValue("ROLES"),
        P3RFORMLOGS = args.get_item().getDataKeyValue("P3RFORMLOGS"), ISACTIVE = args.get_item().getDataKeyValue("ISACTIVE"), CANCELTASK = args.get_item().getDataKeyValue("CANCELTASK"),
        STARTCOMPLETE_TASK = args.get_item().getDataKeyValue("STARTCOMPLETE_TASK"), BREAKS = args.get_item().getDataKeyValue("BREAKS");

    var cellHOME = args.get_item().get_cell("HOME"), cellTRACK = args.get_item().get_cell("TRACK"), cellREPORTS = args.get_item().get_cell("REPORTS"), cellROUTINE = args.get_item().get_cell("ROUTINE"),
        cellPORTER = args.get_item().get_cell("PORTER"), cellTASKTYPE = args.get_item().get_cell("TASKTYPE"), cellLOCATIONS = args.get_item().get_cell("LOCATIONS"), cellUPLOAD = args.get_item().get_cell("UPLOAD"),
        cellGROUP = args.get_item().get_cell("GROUP"), cellREMARKS = args.get_item().get_cell("REMARKS"), cellUSERS = args.get_item().get_cell("USERS"), cellROLES = args.get_item().get_cell("ROLES"),
        cellP3RFORMLOGS = args.get_item().get_cell("P3RFORMLOGS"), cellISACTIVE = args.get_item().get_cell("ISACTIVE"), cellStartComplete = args.get_item().get_cell("STARTCOMPLETE_TASK"), cellCancelTask = args.get_item().get_cell("CANCELTASK"),
        cellBREAKS = args.get_item().get_cell("BREAKS");

    var valHOMESrc = ((HOME == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valTRACKSrc = ((TRACK == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valREPORTSSrc = ((REPORTS == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valROUTINESrc = ((ROUTINE == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valPORTERSrc = ((PORTER == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valTASKTYPESrc = ((TASKTYPE == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valLOCATIONSSrc = ((LOCATIONS == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valUPLOADSrc = ((UPLOAD == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valGROUPSrc = ((GROUP == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valREMARKSSrc = ((REMARKS == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valUSERSSrc = ((USERS == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valROLESSrc = ((ROLES == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valP3RFORMLOGSSrc = ((P3RFORMLOGS == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valBREAKSSrc = ((BREAKS == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valISACTIVESrc = ((ISACTIVE == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valIsStatComplete = ((STARTCOMPLETE_TASK == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png"),
        valIsCancelTask = ((CANCELTASK == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png");


    var valHOME = $('<a></a>').html("<img src='" + ((HOME == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,1" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        valTRACK = $('<a></a>').html("<img src='" + ((TRACK == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,2" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        valREPORTS = $('<a></a>').html("<img src='" + ((REPORTS == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,3" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        valROUTINE = $('<a></a>').html("<img src='" + ((ROUTINE == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,4" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        valPORTER = $('<a></a>').html("<img src='" + ((PORTER == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,5" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        valTASKTYPE = $('<a></a>').html("<img src='" + ((TASKTYPE == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,6" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        valLOCATIONS = $('<a></a>').html("<img src='" + ((LOCATIONS == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,7" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        valUPLOAD = $('<a></a>').html("<img src='" + ((UPLOAD == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,8" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        valGROUP = $('<a></a>').html("<img src='" + ((GROUP == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,9" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        valREMARKS = $('<a></a>').html("<img src='" + ((REMARKS == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,10" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        valUSERS = $('<a></a>').html("<img src='" + ((USERS == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,11" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        valROLES = $('<a></a>').html("<img src='" + ((ROLES == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,12" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        valP3RFORMLOGS = $('<a></a>').html("<img src='" + ((P3RFORMLOGS == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,13" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        valBREAKS = $('<a></a>').html("<img src='" + ((BREAKS == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,14" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),

        valStatComplete = $('<a></a>').html("<img src='" + ((STARTCOMPLETE_TASK == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,15" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        valCancelTask = $('<a></a>').html("<img src='" + ((CANCELTASK == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,16" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),


        valISACTIVE = $('<a></a>').html("<img src='" + ((ISACTIVE == "1") ? "../images/CCheck.png" : "../images/CNoCheck.png") + "'" + ' onclick="setRole(' + "'" + RoleID + "',this,'ISACTIVE'" + ');" ' + " alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer");


    var cellEdit = args.get_item().get_cell("EDIT");
    var editLink = '<div class="add-task-link" onclick="setEditRole(' + "'" + RoleID + "','" + rolename + "','" + valHOMESrc + "','" + valTRACKSrc + "','" + valREPORTSSrc + "','" + valROUTINESrc + "','" +
        valPORTERSrc + "','" + valTASKTYPESrc + "','" + valLOCATIONSSrc + "','" + valUPLOADSrc + "','" + valGROUPSrc + "','" + valREMARKSSrc + "','" + valUSERSSrc + "','" + valROLESSrc + "','" + valP3RFORMLOGSSrc + "','" + valBREAKSSrc + "','" + valISACTIVESrc + "','" + valIsStatComplete + "','" + valIsCancelTask + "'" + ');"> <a href="javascript:void(0)" class="btn btn-indexblue"><img src="../images/memo.png" alt="Add Task"> </a> </div>',
        //    NearByIcon = $('<a onclick="ShowNearByLoc(' + "'" + defalutlocation + "'" + ');" > </a>').html("<img src='../images/Location.png' alt='Assign'  height='25px' class='GridIcons' style='cursor:pointer' />").css("cursor", "pointer").append("<span style='text-decoration: underline;font-weight: bold;'>Zones</span>"),
        //    c = "<img src='Images/MultiTask.PNG'  width='35px' height='35px' alt='MultiTask'  />",
        //    startIcon = $('<a></a>').html("<img src='../RequestNew/images/Start.png' alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer"),
        //    finishIcon = $('<a></a>').html("<img src='../RequestNew/images/Finish.png' alt='Assign'  height='22px' class='GridIcons' />").css("cursor", "pointer");
        //var ResetIcon = '<button type="button" class="btn btn-outline w-80" onclick="ResetPassword(' + "'" + UserID + "'," + "'" + UserName + "'" + ');return false;" style="background-color: #a4a4a4;padding: 5px 15px;">  <table style="width:100%"> <tr> <td align="center">   <img src="../images/refresh.png"></td> </tr>   <tr> <td align="center" style="color: red;transition: 0.5s;border-radius: 10px;font-size: 15px;font;font-weight: bold;font-family: monospace;">RESET PASSWORD</td></tr>  </table> </button >';
        RUID = args.get_item().getDataKeyValue("USERID");

    $(cellEdit).html(editLink);
    $(cellHOME).html(valHOME); $(cellTRACK).html(valTRACK); $(cellREPORTS).html(valREPORTS); $(cellROUTINE).html(valROUTINE); $(cellPORTER).html(valPORTER); $(cellTASKTYPE).html(valTASKTYPE); $(cellLOCATIONS).html(valLOCATIONS); $(cellUPLOAD).html(valUPLOAD);
    $(cellGROUP).html(valGROUP); $(cellREMARKS).html(valREMARKS); $(cellUSERS).html(valUSERS); $(cellROLES).html(valROLES); $(cellP3RFORMLOGS).html(valP3RFORMLOGS); $(cellBREAKS).html(valBREAKS); $(cellISACTIVE).html(valISACTIVE);
    $(cellStartComplete).html(valStatComplete); $(cellCancelTask).html(valCancelTask);
    //$(finishIcon).click(function () {
    //    clearInterval(Reload); AbortAllActiveRuquests();
    //    ShowModalPopUp('ModalFinish');
    //});
}

function setRole(RoleID, ele, TreeID) {

    var src = $(ele).attr('src');
    var value = (src == "../images/CNoCheck.png") ? "1" : "0"; //alert(src);
    $(ele).attr("src", (src == "../images/CNoCheck.png") ? "../images/CCheck.png" : "../images/CNoCheck.png");
    if (TreeID == 'ISACTIVE')
        setRoleValues(RoleID, '0', '0', value);
    else
        setRoleValues(RoleID, TreeID, value, 'NO');
}

function setRoleValues(RoleID, TreeID, Value, IsActive) {
    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=SETROLE&ROLEID=" + RoleID + "&TREEID=" + TreeID + "&VALUE=" + Value + "&ISACTIVE=" + IsActive,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            if (data[0].RESULT.split("_")[0] === 'TRUE') {
                $('#LBLRequestResult').html('The role details updated successfully..');
                ShowModalPopUp('modalSuccess');
                setTimeout("HideModalPopUp('modalSuccess');", 2500); LoadProcess();
            }

        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}

function ResetPassword(UserID, UserName) {

    EUserID = UserID; EUserName = UserName;
    $('#spanUserName').html(UserName);
    ShowModalPopUp("ModalReset");
}

function Reset() {
    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=RESETPASSWORD&USERID=" + EUserID,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            if (data[0].RESULT.split("_")[0] === 'TRUE') {
                $('#LBLRequestResult').html('The user ' + EUserName + "'s " + ' password has been reset successfully..');
                HideModalPopUp('ModalReset'); ShowModalPopUp('modalSuccess');
                setTimeout("HideModalPopUp('modalSuccess');", 2500); LoadProcess();
            }

        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}

function SearchPorterRequest() {
    LoadGrid(CProcess);
}

function Redirect(RedirectTo) {
    window.location = RedirectTo;
}

/* Date Picker Start */




function changeCheck(ele) {
    var src = $(ele).attr('src'); //alert(src);
    $(ele).attr("src", (src == "../images/CNoCheck.png") ? "../images/CCheck.png" : "../images/CNoCheck.png");

}



function ShowModaladdRole() {
    $('#addRole').modal({
        backdrop: 'static',
        keyboard: false
    })
    $('#addRole').modal('show');
}


function Encrypt(Value) {
    var key = CryptoJS.enc.Utf8.parse(CryptoKey);
    var iv = CryptoJS.enc.Utf8.parse(CryptoPwd);

    var encryptedVal = CryptoJS.AES.encrypt(CryptoJS.enc.Utf8.parse(Value), key,
        {
            keySize: 128 / 8,
            iv: iv,
            mode: CryptoJS.mode.CBC,
            padding: CryptoJS.pad.Pkcs7
        });
    return encryptedVal;
}