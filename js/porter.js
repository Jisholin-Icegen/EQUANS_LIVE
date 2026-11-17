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


function LoaddrRoles() {
    var arrRoles = [];
    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=GETUSERROLES",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            if (data.length > 0) {
                arrRoles = data[0].RESULT.split(',');
                $('#search_RoleName').html(''); $('#search_RoleName')[0].sumo.add('0', '-- Select --'); $('#search_RoleName')[0].sumo.reload();
                $.each(arrRoles, function (index, value) {
                    $('#search_RoleName')[0].sumo.add(value.split('_')[0], value.split('_')[1]);
                });
            }

        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
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

function LoadGrid() {

    var encProcess = Encrypt("GETUSERS").toString();
    var encSearch = Encrypt($('#TextSearchLocation').val()).toString();
    var encPageIndex = Encrypt(pageIndex.toString()).toString();
    var encPageSize = Encrypt(pageSize.toString()).toString();
    var encServiceId = Encrypt(ServiceCode.toString()).toString();
 
    var FinalUrl = hurl + "Service/Service.aspx?Process=" + encodeURIComponent(encProcess) +
        "&Search=" + encodeURIComponent(encSearch) +
        "&PageIndex=" + encodeURIComponent(encPageIndex) +
        "&PageSize=" + encodeURIComponent(encPageSize) +
        "&SERVICEID=" + encodeURIComponent(encServiceId);    $.ajax({
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

function BuildHeader() {

    var Header = " filter value:- " + $('#TextSearchLocation').val() + " <br/>  <br/>";

    return Encrypt(Header);

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


function GridUser_Command(sender, args) {
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

            var b = '<a onclick="UnBindLocation(' + "'" + value + "'" + ');"> <img src="../images/Delete.png" alt="Delete" height="28px" class="GridIcons" style="cursor:pointer" /></a> ';

            htmlNearByZonesNotes += '<div class="msgContainer"><p class="msgUser">' + valueArray[1].toString() + '<span class="time-right">' + b + '</span></div>'
            ENearByZoneIDs += ((ENearByZoneIDs.length > 0) ? ',' : '') + valueArray[0].toString();

        }
    });
    $('#divNearByZones').html(htmlNearByZonesNotes); $('#divNearByZones').show(800);

}


function setEditUser(UserId, UserName, MId, pwd, device, IsActive, PShort, PAlDay, PisQah) {

    EUserID = UserId; EUserName = UserName;  EIsActive = IsActive; EMId = MId;
    PUserID = UserId;

    $('#txtShort').val(PShort);
    $('#txtUserName').val(UserName); 
    $('#txtMID').val(MId);
    $('#txtPwd').val(pwd);
    $('#txtDevice').val(device);
    $('#chkIsAllDay').attr("src", PAlDay.toUpperCase() == "ALL DAY" ? "../images/CCheck.png" : "../images/CNoCheck.png");
    $('#chkIsActive').attr("src", IsActive == "1" ? "../images/CCheck.png" : "../images/CNoCheck.png");
   // alert(PisQah); alert(PisQah.split(',').indexOf("1"));

     $('#chkQAH').attr("src", (PisQah.split(',').indexOf("1") !== -1) ? "../images/CCheck.png" : "../images/CNoCheck.png");
    $('#chkRAD').attr("src", (PisQah.split(',').indexOf("3") !== -1) ? "../images/CCheck.png" : "../images/CNoCheck.png");
     

    $('#LocationHeader').html('Edit Porter #' + UserName);


     //ktxtPwd = $('#txtPwd').val(),
     //   Pdevice = $('#txtDevice').val(), PShort = $('#txtShort').val(''), PAlDay = ('#chkIsAllDay').attr("src"),
     //   Pisact = $('#chkIsActive').attr("src"), PisQah = $('#chkQAH').attr("src"), PisRad = $('#chkRAD').attr("src");



    
    $('#chkIsActive').attr("src", (IsActive == 'True') ? "../images/CCheck.png" : "../images/CNoCheck.png");
    $('#btnDeleteLocation').css("display", "flex");
  //  $('#btnDeleteLocation').css("display", "none");
    ShowModalAddUser();

}

function addUser() {
    $('#txtUserName').val('');
    $('#txtMID').val('');
    $('#txtPwd').val('');
    $('#txtDevice').val('');
    $('#txtShort').val('');    
    $('#chkIsAllDay').attr("src", "../images/CNoCheck.png");
    $('#chkIsActive').attr("src", "../images/CNoCheck.png");
    $('#chkQAH').attr("src", "../images/CNoCheck.png");
    $('#chkRAD').attr("src", "../images/CNoCheck.png");


    
     
    ShowModalAddUser(); $('#LocationHeader').html('Add Porter');
    setTimeout(function () { $('#txtUserName').focus(); }, 500);
    $('#btnDeleteLocation').css("display", "none");


}

function submitUser() {
    var Action = $('#LocationHeader').html();

    var userName = $('#txtUserName').val(), MID = $('#txtMID').val(), ktxtPwd = $('#txtPwd').val(),
        Pdevice = $('#txtDevice').val(), PShort = $('#txtShort').val(), PAlDay = $('#chkIsAllDay').attr("src"),
        Pisact = $('#chkIsActive').attr("src"), PisQah = $('#chkQAH').attr("src"), PisRad = $('#chkRAD').attr("src");

    var hos = ((PisQah == '../images/CCheck.png') && (PisRad == '../images/CCheck.png') ? "Queen Alexandra Hospital,Receipt and Distribution" : ((PisQah == '../images/CCheck.png') ? "Queen Alexandra Hospital" : ((PisRad == '../images/CCheck.png') ? "Receipt and Distribution" : ""))),


        PisQah = ((PisQah == '../images/CCheck.png') && (PisRad == '../images/CCheck.png') ? "1,3" : ((PisQah == '../images/CCheck.png') ? "1" : ((PisRad == '../images/CCheck.png') ? "3" : "")));
       if (userName.length == 0) {
        $('#txtUserName').focus();
        $('#txtUserName').css('border', '2px solid red'); setTimeout(function () { $('#txtUserName').css('border', '1px solid rgb(248, 247, 247)'); }, 2500);
    }
   /* else if ($('#chkRAD').attr("src")== "../images/CCheck.png" ? true : false == true &&  ktxtPwd.length == 0) {
        $('#txtPwd').focus();
        $('#txtPwd').css('border', '2px solid red'); setTimeout(function () { $('#txtPwd').css('border', '1px solid rgb(248, 247, 247)'); }, 2500);
    }*/
     
    else {
     //   alert(PAlDay);
           AddUpdateuser(((Action == 'Add Porter') ? "new" : PUserID),userName, MID, ktxtPwd, Pdevice, PShort, ((PAlDay == '../images/CCheck.png') ? 'All day' : ''), ((Pisact == '../images/CCheck.png') ? '1' : '0'), PisQah,hos, ((Action == 'Add Porter') ? "INSERT" : "UPDATE"));

    }

}

        function AddUpdateuser(PUserID, UserName, MId, ktxtPwd, Pdevice, PShort, PAlDay, Pisact, PisQah, hos, Action) {
            var chkIsActiveSrc = $('#chkIsActive').attr("src");

            var encProcess = Encrypt("UPDATEPORTER").toString();
            var encUserName = Encrypt(UserName).toString();
            var encMId = Encrypt(MId.toString()).toString();
            var encPUserID = Encrypt(PUserID.toString()).toString();
            var encPassword = Encrypt(ktxtPwd).toString();
            var encPShort = Encrypt(PShort).toString();
            var encPAlDay = Encrypt(PAlDay).toString();
            var encPdevice = Encrypt(Pdevice).toString();
            var encPisact = Encrypt(Pisact).toString();
            var encPisQah = Encrypt(PisQah).toString();
            var encHos = Encrypt(hos).toString();

            $.ajax({
                async: true,
                url: hurl + 'Service/Service.aspx?Process=' + encodeURIComponent(encProcess) +
                    '&PORTERNAME=' + encodeURIComponent(encUserName) +
                    '&GPMId=' + encodeURIComponent(encMId) +
                    '&USERID=' + encodeURIComponent(encPUserID) +
                    '&PASSWORD=' + encodeURIComponent(encPassword) +
                    '&GPShort=' + encodeURIComponent(encPShort) +
                    '&ALLDAY=' + encodeURIComponent(encPAlDay) +
                    '&GPdevice=' + encodeURIComponent(encPdevice) +
                    '&ISACTIVE=' + encodeURIComponent(encPisact) +
                    '&HOSPITALNAME=' + encodeURIComponent(encHos) +
                    '&ServiceID=' + encodeURIComponent(encPisQah),
                type: 'POST',
                data: 'pData',
                dataType: 'json',
                success: function (data) {

                    if (data[0].RESULT.split("_")[0] === 'TRUE') {
                        $('#LBLRequestResult').html('Porter Details ' + ((Action == "UPDATE") ? 'Updated' : 'Added') + ' Successfully.. Porter Name. #' + UserName);

                        HideModalPopUp('addUser');

                        $('#LBLGenericSuccessResult').html('Porter Details ' + ((Action == "UPDATE") ? 'Updated' : 'Added') + ' Successfully!');

                        ShowModalPopUp('modalGenericSuccess');

                        setTimeout(function () {
                            HideModalPopUp('modalGenericSuccess');
                        }, 2500);

                        LoadProcess();
                    }
            else {
                ShowModalPopUp('modalAlert');
                setTimeout("HideModalPopUp('modalAlert');", 3500);
            }
        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}

//function deleteLocation() {

//    var UserName = $('#txtUserName').val();
//    // UEUserID = encodeURIComponent(Encrypt(EUserID)); Action = DELETE encodeURIComponent(Encrypt('DELETE'));

//    UEUserID = ((PUserID)); Action = 'DELETE';
//    $.ajax({
//        async: true,
//        url: hurl + "SERVICE/Service.aspx?Process=UPDATEPORTER&ACTION=DELETE&GPMId=" + UEUserID + "&USERID=DELETE",
//        type: 'POST',
//        data: 'pData',
//        dataType: 'json',
//        success: function (data) {
//            if (data[0].RESULT.split("_")[0] === 'TRUE') {
//                $('#LBLGenericSuccessResult').html('Porter Details Removed Successfully.. #' + UserName);

//                HideModalPopUp('addUser'); ShowModalPopUp('modalSuccess');
//                //$('#LBLGenericSuccessResult').html('Porter Details ' + 'removed' + ' Successfully!');
//                setTimeout("HideModalPopUp('modalSuccess');", 2500); LoadProcess();
//            }
//        },
//        error: function (data) {
//            $('#').html(data[0].RESULT);
//        }
//    });
//}

function deleteLocation() {
    var UserName = $('#txtUserName').val();

    UEUserID = PUserID;  
    Action = 'DELETE';   

    var encProcess = Encrypt("UPDATEPORTER").toString();
    var encAction = Encrypt(Action).toString();
    var encGPMId = Encrypt(UEUserID.toString()).toString();
    var encUserId = Encrypt("DELETE").toString();

    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=" + encodeURIComponent(encProcess) +
            "&ACTION=" + encodeURIComponent(encAction) +
            "&GPMId=" + encodeURIComponent(encGPMId) +
            "&USERID=" + encodeURIComponent(encUserId),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data && data[0] && data[0].RESULT && data[0].RESULT.split("_")[0] === 'TRUE') {
                $('#LBLRequestResult').html('Porter Details Removed Successfully.. #' + UserName);
                HideModalPopUp('addUser');
                ShowModalPopUp('modalSuccess');
                setTimeout(function () { HideModalPopUp('modalSuccess'); }, 2500);
                LoadProcess();
            }
        },
        error: function (xhr) {
            console.error("Delete error:", xhr.responseText);
        }
    });
}


function ShowNearByLoc(NearByZones) {
    var arrRemarks = NearByZones.split(',');
    var htmlNearByZonesNotes = '';
    $.each(arrRemarks, function (index, value) {
        if (value.trim()) {
            var valueArray = value.split('|$|');

            var b = '<a onclick="UnBindLocation(' + "'" + value + "'" + ');"> <img src="../images/Delete.png" alt="Delete" height="28px" class="GridIcons" style="cursor:pointer;display:none;" /></a> ';

            htmlNearByZonesNotes += '<div class="msgContainer"><p class="msgUser">' + valueArray[1].toString() + '<span class="time-right">' + b + '</span></div>'

        }
    });
    $('#divNearByLocations').html(htmlNearByZonesNotes); ShowModalPopUp('modalNearByList'); $('#divNearByLocations').show(800);
}

function GridUser_RowDataBound(sender, args) {

    var CRole = sessionStorage.getItem('ROLE').toUpperCase(), UID = sessionStorage.getItem('ID');
    var UserID = args.get_item().getDataKeyValue("ID"), UserName = args.get_item().getDataKeyValue("USERNAME"), 
          IsActive = args.get_item().getDataKeyValue("ISACTIVE"), MId = args.get_item().getDataKeyValue("MID"),
       
    ktxtPwd = args.get_item().getDataKeyValue("PASSWORD"),
        Pdevice = args.get_item().getDataKeyValue("DEVICE"),
        PShort = args.get_item().getDataKeyValue("SHORT"),
        PAlDay = args.get_item().getDataKeyValue("ALLDAY"),
        PisQah = args.get_item().getDataKeyValue("SERVICEID");
    //alert(MId); //alert(Pdevice); alert(PShort); alert(PAlDay); alert(PisQah);
        
       var cellEdit = args.get_item().get_cell("EDIT") ;
    var editLink = '<div class="add-task-link" onclick="setEditUser(' + "'" + UserID + "','" + UserName + "','" + MId + "','" + ktxtPwd + "','" + Pdevice + "','" + IsActive + "','" + PShort + "','" + PAlDay + "','" + PisQah + "'" + ');"> <a href="javascript:void(0)" class="btn btn-indexblue"><img src="../images/memo.png" alt="Add Task"> </a> </div>' ;
     
    RUID = args.get_item().getDataKeyValue("USERID");
    $(cellEdit).html(editLink);
   
    //$(finishIcon).click(function () {
    //    clearInterval(Reload); AbortAllActiveRuquests();
    //    ShowModalPopUp('ModalFinish');
    //});
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

function changeShiftCheck(ele) {
    var src = $(ele).attr('src');  
    $(ele).attr("src", (src == "../images/CNoCheck.png") ? "../images/CCheck.png" : "../images/CNoCheck.png");
   // $('.clsPwd').css("visibility", ((src == "../images/CNoCheck.png") ? "visible" : "hidden"));
}


function changeCheck(ele) {
    var src = $(ele).attr('src'); //alert(src);
    $(ele).attr("src", (src == "../images/CNoCheck.png") ? "../images/CCheck.png" : "../images/CNoCheck.png");

}




function ShowModalAddUser() {
    $('#addUser').modal({
        backdrop: 'static',
        keyboard: false
    })
    $('#addUser').modal('show');
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