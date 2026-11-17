//const { clearInterval } = require("timers");

var arr = ["TextSOURCE", "TextCATEGORY", "TextDESTINATION"], ReqIcon = ["divTotalPercentage", "divPendingPercentage", "divAssignedPercentage", "divInprogressPercentage", "divCompletedPercentage", "divPendingOnHoldPercentage", "divPrebookeddPercentage", "divCancelledPercentage", "divCancelledPercentage", "divTatExceededPercentage", "divBarrierPercentage"],
    Source = '', Dest = '', User = '', Cat = '', AStatus = '', CancelReqId = '', EStatus = '', Intervl = 0, EReqId = '', ReqArr = ["divTotalPercentage", "divPendingPercentage", "divAssignedPercentage", "divInprogressPercentage", "divCompletedPercentage", "divPendingOnHoldPercentage", "divPrebookeddPercentage", "divCancelledPercentage", "divCancelledPercentage", "divTatExceededPercentage", "divBarrierPercentage"],
    CurPendProcess = '', AReqId = '', MReqId = '', IsChecked = false, Port = '', Name = "", RequestType = '', CurrentCancelStatus = '';
var ReqArrChart = ["divTotalPercentage", "divPendingPercentage", "divAssignedPercentage", "divInprogressPercentage", "divCompletedPercentage", "divBarrierPercentage"],
    ReqArrDiv = ["divPendingOnHoldPercentage", "divPrebookeddPercentage", "divCancelledPercentage", "divCancelledPercentage", "divTatExceededPercentage", "divBarrierPercentage"],
    ReqArrUserDiv = ["divOnDuty", "divBusy", "divIdle", "divOnBreak", "divMaxTask", "divMinTask", "divAvgCount"];


function selDiv(Ele) {
    var selDiv = $('#' + Ele).closest((((ReqArrChart.indexOf(Ele) > -1)) ? '.progress' : '.counter-info-item'));
    //$('div.' + (((ReqArrChart.indexOf(Ele) > -1)) ? 'progress' : 'counter-info-item')).removeClass((((ReqArrChart.indexOf(Ele) > -1)) ? 'titleActive' : 'divtitleActive'));
    $('div.progress').removeClass('titleActive');
    $('div.counter-info-item').removeClass('divtitleActive');

    $(selDiv).addClass((((ReqArrChart.indexOf(Ele) > -1)) ? 'titleActive' : 'divtitleActive'));
}
function Select(Ele, Process) {
    //ShowModalPopUp('ModalLoading');
    LoaderOn(); pageIndex = 0;
    var EleID = $('#' + Ele).attr('id'); selDiv(Ele);

    $.each(ReqIcon, function (index, value) {
        if (value == EleID)
            $('#' + value).addClass('SelectIndexIcon');
        else
            $('#' + value).removeClass('SelectIndexIcon');

    });
    if (ReqArr.indexOf(EleID) > -1) {
        var ReqStatus = (EleID == "divTotalPercentage") ? "0" : (EleID == "divPendingPercentage") ? "2" : (EleID == "divAssignedPercentage") ? "3" : (EleID == "divInprogressPercentage") ? "4" : (EleID == "divCompletedPercentage") ? "6" : (EleID == "divCancelledPercentage") ? "7" : (EleID == "divPendingOnHoldPercentage") ? "8" : (EleID == "divTatExceededPercentage") ? "9" : (EleID == "divPrebookeddPercentage") ? "100" : (EleID == "tdPreBook") ? "100" : (EleID == "divBarrierPercentage") ? "9" : "0";

        CProcess = ReqStatus;
        LoadProcess(ReqStatus);
        ToUpdate = !ToUpdate;
        ReloadLinks();
    }
    else {
        CProcess = "10";
    }
    setRequestUsers('Tasks');
    LoaderOff(500);

}


function RestartTimer() {
    Reload = window.setInterval(function () { AbortAllActiveRuquests(); ReloadLinks(); }, 500000);
}
function RefreshTasks() {
    LoaderOn(); clearInterval(Reload);
    AbortAllActiveRuquests();
    $('#search_PatientRemarks')[0].sumo.unSelectAll(); $('#search_PatientRemarks')[0].sumo.reload(); $('#search_PatientRemarks')[0].sumo.selectItem(0);
    $('#search_TaskFields')[0].sumo.unSelectAll(); $('#search_TaskFields')[0].sumo.reload(); $('#search_TaskFields')[0].sumo.selectItem(0);
    $('#txtSearchPatient').val(''); $('#txtSearchTask').val('');
    pageIndex = 0;
    LoadProcess(CProcess); ReloadLinks();
    setRequestUsers('Tasks'); Reload = window.setInterval(function () { ReloadLinks(); }, 60000);
    LoaderOff(500);

}

function AbortAllActiveRuquests() {
    $($.xhrPool).each(function (i, jqXHR) {   //  cycle through list of recorded connection
        jqXHR.abort();  //  aborts connection
        $.xhrPool.splice(i, 1); //  removes from list by index
    });
}

function INQueryBuilder() {
    var PateintQuery = getValues('search_PatientRemarks', 'txtSearchPatient'), TaskQuery = getValues('search_TaskFields', 'txtSearchTask'),

        HaywoodQuery = (IsHaywood) ? ' AND ( L.FLOORID IN (57,58,59,60,61,62)  ) ' : ' AND ( L.FLOORID NOT IN (57,58,59,60,61,62) ) ', //OR D.FLOORID IN (57,58,59,60,61,62)

        ServiceQuery = ' AND ( SERVICEID = ' + ServiceCode + ' ) ';
    var KitchenQueries = (ServiceCode == "2") ? getValuesdrp("search_Kitchen") : (ServiceCode == "3" && (!IsHaywood)) ? getValuesdrp("search_CleaningZone") : "";

    var finalQuery = ((PateintQuery.length > 0) ? ((TaskQuery.length > 0) ? ' AND ( ( ' + PateintQuery + ' ) OR ( ' + TaskQuery + ' ) ) ' : ' AND  ( ' + PateintQuery + ' ) ') : ((TaskQuery.length > 0) ? ' AND  ( ' + TaskQuery + ' ) ' : '')) + ((KitchenQueries.length > 0) ? ' AND  ( ' + KitchenQueries + ' ) ' : '') + HaywoodQuery + ServiceQuery;

    return finalQuery;
}

function getValues(drpSumo, txtbox) {
    var valSel = '', valTxt = $('#' + txtbox).val();
    if (valTxt.length > 0) {
        $('#' + drpSumo + '  option:selected').each(function (i) {
            valSel += ((valSel.length > 0) ? " OR " : "") + setValue($(this).val(), valTxt);
        });

    }
    return valSel;
}

function getValuesdrp(drpSumo) {
    var valSel = '';
    $('#' + drpSumo + '  option:selected').each(function (i) {
        valSel += ((valSel.length > 0) ? " OR " : "") + setValue((($(this).val() == "SUPERVISOR") ? 'DBO.[FN_ROLEREQUIRED_CATEGORY](CM.ID,SERVICEID)' : 'KITCHEN'), $(this).val());
    });

    return valSel;
}
function setValue(columns, colvalue) {

    var columnArr = columns.split('#'), query = '';


    $.each(columnArr, function (index, value) {
        if (value.trim().length > 0)
            query += ((query.length > 0) ? " OR " : "") + ((value == 'R.REQUESTID') ? " ( " + value + " = '" + colvalue + "' ) " : " ( " + value + " like '%" + colvalue + "%' ) ");
        /*query += ((query.length > 0) ? " OR " : "") + " ( " + value + " like '%" + colvalue + "%' ) ";*/
    });
    return query;
}

function OnchangeFilter(drpID, txtID) {
    var drpLength = $('#' + drpID).find('option:selected').length, txtValue = $('#' + txtID).val();
    if (drpLength > 0) {
        if (txtValue.length == 0)
            $('#' + txtID).focus();
        else
            setIndexscreen();
    }
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



function ReloadLinksButton() {
    var UID = sessionStorage.getItem('ID'), CountROLE = sessionStorage.getItem('ROLE');
    $.ajax({
        async: true,
        url: hurl + "Service/Service.aspx?Process=GETCOUNT&USERID=" + encodeURIComponent(Encrypt(UID)) + "&ROLE=" + encodeURIComponent(Encrypt(CountROLE)) + "&ISHAYWOOD=" + encodeURIComponent(Encrypt(((IsHaywood) ? '1' : '0'))) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            if (data.length > 0) {
                var PendingCount = data[0].PENDING, AssignedCount = data[0].ASSIGNED, InprogressCount = data[0].INPROGRESS, CompletedCount = data[0].COMPLETED,
                    CancelledCount = data[0].CANCELLED, OnHoldCount = data[0].PENDING_ONHOLD, PreBookCount = data[0].PREBOOKED, TATExceed = data[0].TATEXCEEDED,
                    BARRIER = data[0].BARRIER, TotalCount = data[0].TOTAL;

                var pendingPercent = ((PendingCount * 100) / TotalCount).toString(),
                    AssignPercent = ((AssignedCount * 100) / TotalCount).toString(),
                    InprogressPercent = ((InprogressCount * 100) / TotalCount).toString(),
                    CompletedPercent = ((CompletedCount * 100) / TotalCount).toString();

                var TotCount = (TotalCount == null) ? 0 : TotalCount;

                $('#countTotalCount').html((TotalCount == null) ? '00' : (TotalCount.toString().length == 1) ? '0' + TotalCount.toString() : TotalCount.toString()); //$('#divTotalPercentage').css("width", ((TotCount != 0) ? "100%" : '0%'));

                $('#countPendingCount').html((PendingCount == null) ? '00' : (PendingCount.toString().length == 1) ? '0' + PendingCount.toString() : PendingCount.toString());// $('#divPendingPercentage').css("width", pendingPercent + "%");

                $('#countAssignedCount').html((AssignedCount == null) ? '00' : (AssignedCount.toString().length == 1) ? '0' + AssignedCount.toString() : AssignedCount.toString());// $('#divAssignedPercentage').css("width", AssignPercent + "%");

                $('#countInprogressCount').html((InprogressCount == null) ? '00' : (InprogressCount.toString().length == 1) ? '0' + InprogressCount.toString() : InprogressCount.toString());// $('#divInprogressPercentage').css("width", InprogressPercent + "%");

                $('#countCompletedCount').html((CompletedCount == null) ? '00' : (CompletedCount.toString().length == 1) ? '0' + CompletedCount.toString() : CompletedCount.toString()); //$('#divCompletedPercentage').css("width", CompletedPercent + "%");

                $('#countCancelledCount').text((CancelledCount == null) ? '00' : (CancelledCount.toString().length == 1) ? '0' + CancelledCount.toString() : CancelledCount.toString());

                $('#countPendingOnHoldCount').text((OnHoldCount == null) ? '00' : (OnHoldCount.toString().length == 1) ? '0' + OnHoldCount.toString() : OnHoldCount.toString());

                $('#countPreBookedCount').text((PreBookCount == null) ? '00' : (PreBookCount.toString().length == 1) ? '0' + PreBookCount.toString() : PreBookCount.toString());

                $('#countTATExceedCount').text((TATExceed == null) ? '00' : (TATExceed.toString().length == 1) ? '0' + TATExceed.toString() : TATExceed.toString());

                $('#countBarrierCount').text((BARRIER == null) ? '00' : (BARRIER.toString().length == 1) ? '0' + BARRIER.toString() : BARRIER.toString());

                if (data.length == 2) {
                    //var docMov = data[1].DOCMOVEMENT, OtherMov = data[1].OTHERMOVEMENT;
                    var OnDuty = data[1].ONDUTY, Busy = data[1].BUSY, OnBreak = data[1].ONBREAK, Max = data[1].MAX, Min = data[1].MIN, Avg = data[1].AVG;

                    var IdleCount = (parseInt(OnDuty) - (parseInt(Busy) + parseInt(OnBreak)));

                    $('#countOnDutyCount').text((OnDuty == null) ? '00' : (OnDuty.toString().length == 1) ? '0' + OnDuty.toString() : OnDuty.toString());

                    $('#countBusyCount').text((Busy == null) ? '00' : (Busy.toString().length == 1) ? '0' + Busy.toString() : Busy.toString());

                    $('#countOnBreakCount').text((OnBreak == null) ? '00' : (OnBreak.toString().length == 1) ? '0' + OnBreak.toString() : OnBreak.toString());

                    $('#countIdleCount').text((IdleCount == null) ? '00' : (IdleCount.toString().length == 1) ? '0' + IdleCount.toString() : IdleCount.toString());

                    $('#MaxTasks').text((Max == null) ? '00' : (Max.toString().length == 1) ? '0' + Max.toString() : Max.toString());

                    $('#MinTasks').text((Min == null) ? '00' : (Min.toString().length == 1) ? '0' + Min.toString() : Min.toString());

                    //$('#AvgTasks').text((Avg == null) ? '00' : (Avg.toString().length == 1) ? '0' + Avg.toString() : Avg.toString());

                } else {
                    $('#countOnDutyCount').text('00');

                    $('#countBusyCount').text('00');

                    $('#countOnBreakCount').text('00');

                    $('#countIdleCount').text('00');

                    $('#MaxTasks').text('00');

                    $('#MinTasks').text('00');

                    //$('#AvgTasks').text('00')
                }
            }
        },
        error: function (data) {

        }
    });
}

function getCurdateTime(date) {
    var d;
    if (typeof (date) !== 'undefined' && date !== null && date.length > 0)
        d = new Date(date);
    else
        d = new Date();
    var month = d.getMonth() + 1;
    var day = d.getDate(), Hour = d.getHours(), Minute = d.getMinutes();
    var time = (Hour < 10 ? '0' : '') + Hour + ':' + (Minute < 10 ? '0' : '') + Minute; // d.getHours() + ":" + d.getMinutes();// + ":" + dt.getSeconds();

    var date = d.getFullYear() + '-' + (month < 10 ? '0' : '') + month + '-' + (day < 10 ? '0' : '') + day;

    return date + '_' + time;
}

function submitRequest() {
    var IsEdit = ((document.getElementById('HFERID').value).length > 0), ReqtrName = $('#txtRequestorName').val().trim(), From = $('#txtFromLoc').val().trim(), To = $('#txtToLoc').val().trim(), AuthName = $('#txtPatientName').val().trim();
    if (RFromID == '0' || From.length == 0) {
        $('#txtFromLoc').focus();
        $('#txtFromLoc').css('border', '2px solid red'); setTimeout(function () { $('#txtFromLoc').css('border', '1px solid rgb(248, 247, 247)'); }, 2500);
    }
    else if (RToID == '0' || To.length == 0) {
        $('#txtToLoc').focus();
        $('#txtToLoc').css('border', '2px solid red'); setTimeout(function () { $('#txtToLoc').css('border', '1px solid rgb(248, 247, 247)'); }, 2500);
    }
    else if (ReqCat == '0') {
        $('#txtSearchCat').focus();
        $('#containerCat').css('border', '2px solid red'); setTimeout(function () { $('#containerCat').css('border', '2px solid white'); }, 2500);
    }
    else if (ServiceCode == 3 && ReqCat == "73" && AuthName.length == 0) {
        $('#txtPatientName').focus(); $('#txtPatientName').css('border', '2px solid red');
        setTimeout(function () { $('#txtFromLoc').css('border', '1px solid rgb(248, 247, 247)'); }, 2500);
    }
    else if (ReqtrName.length == 0) {
        $('#txtRequestorName').focus(); $('#txtRequestorName').css('border', '2px solid red');; setTimeout(function () { $('#txtRequestorName').css('border', '1px solid rgb(248, 247, 247)'); }, 2500);
    }
    else {
        if (IsEdit)
            UpdateRequest();
        else
            InsertRequest();


        //LoadPresetRemarks();
    }



}

function InsertRequest() {
    AbortAllActiveRuquests();
    var UID = sessionStorage.getItem('ID');
    var PBDTime = (RPreBook == '1') ? formatDate('txtReqdate', 'txtReqTime') : '';
    var dlRemarkval = $('#search_Remarks').val(), dlRemarkTxt = selectedText('search_Remarks'); //$('#search_Remarks option:selected').text();
    var PatientName = $('#txtPatientName').val(), PatientHN = $('#txtPatientHNO').val(), PatientDOB = $('#txtPatientDOB').val(), ContactNo = $('#txtContactNumber').val(),
        Remarks = dlRemarkTxt + '_' + $('#txtRemarks').val();//, srcMulti = $('#chkMultiPorter').attr('src'), srcReturn = $('#chkReturnCalls').attr('src');
    var ReqtrName = $('#txtRequestorName').val().trim(), kitchen = $('#txtFromLoc').val().trim();


    //var IsMultiPorter = (srcMulti == "../images/NoMCheck.jpg") ? "0" : "1";
    //var IsReturn = (srcReturn == "../images/Return.png") ? "0" : "1";

    var qty = $('#txtQty').val();

    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=INSERTREQUEST&PBDATE=" + encodeURIComponent(Encrypt(PBDTime)) + "&CATEGORY=" + encodeURIComponent(Encrypt(ReqCat)) + "&FROM=" + encodeURIComponent(Encrypt(RFromID)) + "&TO=" + encodeURIComponent(Encrypt(RToID))
            + "&MULTIPORTER=" + encodeURIComponent(Encrypt(IsMTPR)) + "&PATIENTNAME=" + encodeURIComponent(Encrypt(PatientName + "_" + PatientHN + "_" + PatientDOB)) + "&REMARKS=" + encodeURIComponent(Encrypt(Remarks)) + "&USERID=" + encodeURIComponent(Encrypt(UID))
            + "&HALT1=" + encodeURIComponent(Encrypt(RHalt1)) + "&HALT2=" + encodeURIComponent(Encrypt(RHalt2)) + "&PRIORITY=" + encodeURIComponent(Encrypt("0")) + "&EXTRAFIELDS=" + encodeURIComponent(Encrypt(IsRTC + "_" + ContactNo)) + "&Qty=" + encodeURIComponent(Encrypt(qty))
            + "&REQUESTOR=" + encodeURIComponent(Encrypt(ReqtrName)) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)) + "&KITCHEN=" + encodeURIComponent(Encrypt(kitchen)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT.split("_")[0] === 'TRUE' && PBDTime == '') {
                var ReqNB = data[0].RESULT.split("_")[1];

                if ((RHalt1 == '0' && RHalt2 == '0'))
                    $('#LBLRequestResult').html('Request Raised Successfully.. Req No. #' + ReqNB);
                else
                    $('#LBLRequestResult').html('Request(s) Raised Successfully.. Req Nos. ' + ReqNB);

                HideModalPopUp('addTask'); ShowModalPopUp('modalReqAlert');
                setTimeout("HideModalPopUp('modalReqAlert');", 3500);
                HideModalPopUp('modalReqAlert');// ReloadLinks(); ReloadLinksButton();
                if (ReqCat !== '73')
                    Select("divPendingPercentage", "PENDING");
                else
                    Select("divBarrierPercentage", "Barrier")
                setRequestUsers('Tasks');


                //setTimeout(function () { ReloadLinksButton(); }, 500);
            }
            else if (PBDTime.length > 0) {

                $('#LBLRequestResult').html('Request pre-booked Successfully...');

                HideModalPopUp('addTask'); ShowModalPopUp('modalReqAlert');
                setTimeout("HideModalPopUp('modalReqAlert');", 3500);
                HideModalPopUp('modalReqAlert');// ReloadLinks();
                Select("divPrebookeddPercentage", "PREBOOKED"); setRequestUsers('Tasks');//LoadProcess('100');

                //setTimeout(function () { ReloadLinksButton(); }, 500);
            }
            else if (data[0].RESULT.split("_")[0] === 'FALSE') {
                $('#spanErrorMessage').html('A similar/same request has already been raised.');
                ShowModalPopUp('modalAlert'); setTimeout("HideModalPopUp('modalAlert');", 3500);

            }

        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}

function UpdateRequest() {
    var ReqID = document.getElementById('HFERID').value, ReqNB = document.getElementById('HFERNO').value, StatusID = document.getElementById('HFStatusID').value;

    //var srcMitigation = $('#chkMitigation').attr('src')
    var IsMitigation = "0";// (srcMitigation == "../images/NoMCheck.jpg") ? "0" : "1";
    //var CompletedRemarks = $('#txtCompleteRemarks').val(), CancelledRemarks = $('#txtCanceRemarks').val();//, srcReturn = $('#chkReturnCalls').attr('src');


    /* var dlCompleteRemarkVal = $('#search_CompleteRemarks').val(), dlCancelRemarkVal = $('#search_CancelRemarks').val(), dlRemarkval = $('#search_Remarks').val();
    var dlCompleteRemarkTxt = $('#search_CompleteRemarks option:selected').text(), dlCancelRemarkTxt = $('#search_CancelRemarks option:selected').text(), dlRemarkTxt = $('#search_Remarks option:selected').text();


    var CompletedRemarks = (dlCompleteRemarkVal == 'Others') ? $('#txtCompleteRemarks').val() : ((dlCompleteRemarkVal == '0') ? '' : dlCompleteRemarkTxt);
    var CancelledRemarks = (dlCancelRemarkVal == 'Others') ? $('#txtCanceRemarks').val() : ((dlCancelRemarkVal == '0') ? '' : dlCancelRemarkTxt);
    var Remarks = (dlRemarkval == 'Others') ? $('#txtRemarks').val() : ((dlRemarkval == '0') ? '' : dlRemarkTxt); */

    var drpCancelRemark = selectedText('search_CancelRemarks'), drpCompleteRemark = '',// selectedText('search_CompleteRemarks')
        drpRemark = selectedText('search_Remarks'); //$('#searchCR_CancelRemarks option:selected').text();

    //alert(drpCReason);

    var CancelledRemarks = drpCancelRemark + '_' + $('#txtCanceRemarks').val();

    var CompletedRemarks = ''; //drpCompleteRemark + '_' + $('#txtCompleteRemarks').val();

    var Remarks = drpRemark + '_' + $('#txtRemarks').val();

    var ReqtrName = $('#txtRequestorName').val().trim(), kitchen = $('#txtFromLoc').val().trim();

    var UID = sessionStorage.getItem('ID');
    var PBDTime = (RPreBook == '1') ? formatDate('txtReqdate', 'txtReqTime') : '';
    var PatientName = $('#txtPatientName').val(), PatientHN = $('#txtPatientHNO').val(), PatientDOB = $('#txtPatientDOB').val(), ContactNo = $('#txtContactNumber').val();// srcMulti = $('#chkMultiPorter').attr('src') , Remarks = $('#txtRemarks').val();
    //var IsMultiPorter = (srcMulti == "../images/NoMCheck.jpg") ? "0" : "1";
    //var IsReturn = (srcReturn == "../images/Return.png") ? "0" : "1";
    var qty = $('#txtQty').val();

    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=UPDATEREQUEST&PBDATE=" + encodeURIComponent(Encrypt(PBDTime)) + "&CATEGORY=" + encodeURIComponent(Encrypt(ReqCat)) + "&FROM=" + encodeURIComponent(Encrypt(RFromID)) + "&TO=" + encodeURIComponent(Encrypt(RToID)) +
            "&MULTIPORTER=" + encodeURIComponent(Encrypt(IsMTPR + "_" + OIsMTPR)) + "&PATIENTNAME=" + encodeURIComponent(Encrypt(PatientName + "_" + PatientHN + "_" + PatientDOB)) + "&REMARKS=" + encodeURIComponent(Encrypt(Remarks)) + "&USERID=" + encodeURIComponent(Encrypt(UID))
            + "&PRIORITY= " + encodeURIComponent(Encrypt("0")) + "&EXTRAFIELDS=" + encodeURIComponent(Encrypt(IsRTC + "_" + IsMitigation + "_" + ContactNo)) + "&REQUESTID=" + encodeURIComponent(Encrypt(ReqID)) + '&STATUS=' + encodeURIComponent(Encrypt(StatusID))
            + '&COMPLETEREMARKS=' + encodeURIComponent(Encrypt(CompletedRemarks)) + '&CANCELREMARKS=' + encodeURIComponent(Encrypt(CancelledRemarks)) + "&Qty=" + encodeURIComponent(Encrypt(qty)) + "&REQUESTOR=" + encodeURIComponent(Encrypt(ReqtrName))
            + "&KITCHEN=" + encodeURIComponent(Encrypt(kitchen)) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)) + "&MODIFIEDVALUS=" + encodeURIComponent(Encrypt(getModifiedValues())),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT.split("_")[0] === 'TRUE') {

                $('#LBLRequestResult').html('Request Updated Successfully.. Req No. #' + ReqNB);

                HideModalPopUp('addTask'); ShowModalPopUp('modalReqAlert');
                setTimeout("HideModalPopUp('modalReqAlert');", 3500);
                HideModalPopUp('modalReqAlert'); //ReloadLinks();
                LoadProcess(CProcess);
            }
        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}

function formatDate(eleID_Date, eleID_TIme) {

    var date = $('#' + eleID_Date).val(), time = $('#' + eleID_TIme).val(); // 2023-07-06 12:53

    var datetime = date.split('-')[1] + '/' + date.split('-')[2] + '/' + date.split('-')[0] + ' ' + time;

    return datetime;


}



function setMultiPorter() {

    var IsMT = $('#chkMultiPorter').prop('checked');

    IsMTPR = (IsMT) ? "1" : "0";

    //var src = $('#chkMultiPorter').attr('src'); //alert(src);
    //$('#chkMultiPorter').attr("src", (src == "../images/NoMCheck.jpg") ? "../images/MCheck.jpg" : "../images/NoMCheck.jpg");

}
function setReturnCalls() {

    var IsRT = $('#chkReturnCalls').prop('checked');

    IsRTC = (IsRT) ? "1" : "0";

    //var src = $('#chkReturnCalls').attr('src'); //alert(src);
    //$('#chkReturnCalls').attr("src", (src == "../images/Return.png") ? "../images/SReturn.png" : "../images/Return.png");

}

function setCheck(ele) {

    var src = $(ele).attr('src'); //alert(src);
    $(ele).attr("src", (src == "../images/NoMCheck.jpg") ? "../images/MCheck.jpg" : "../images/NoMCheck.jpg");

}

function setCheckbyID(eleId) {

    var src = $('#' + eleId).attr('src'); //alert(src);
    $('#' + eleId).attr("src", (src == "../images/NoMCheck.jpg") ? "../images/MCheck.jpg" : "../images/NoMCheck.jpg");

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

function LoadNewRequest() {
    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=GETREQUESTLOCCATRECORDS",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            var catUL = '';
            var dataLocation = $.grep(data, function (element, index) {
                return element.FILTER == "FLOOR";
            });
            var dataCategory = $.grep(data, function (element, index) {
                return element.FILTER == "CATEGORY";
            });

            $.each(dataCategory, function (key, value) {
                catUL += '<li> <input type="checkbox" id="chkCat' + value.ID + '" onchange="CatSelection(this,' + "'" + value.ID + "'" + ');" ><span> <img src="../images/check.png"></span> <img src="' + value.IMAGEPATH + '" alt="' + value.VALUE + '"> <p>' + value.VALUE + '</p> </li>';
            });

            $("#ReqCategories").html('<ul>' + catUL + '</ul>');

            //$.each(dataLocation, function (key, value) {

            //    $('#search_to')[0].sumo.add(value.ID, value.VALUE);
            //    $('#search_from')[0].sumo.add(value.ID, value.VALUE);
            //    $('#search_Halt1')[0].sumo.add(value.ID, value.VALUE);
            //    $('#search_Halt2')[0].sumo.add(value.ID, value.VALUE);
            //});

            var DateTime = getCurdateTime();
            //alert(curDate);
            document.getElementById("txtReqdate").value = DateTime.split('_')[0];
            document.getElementById("txtReqdate").min = DateTime.split('_')[0];
            //document.getElementById("txtReqdate").max =
            document.getElementById("txtReqTime").value = DateTime.split('_')[1];
            ReqDate = DateTime.split('_')[0]; ReqTime = DateTime.split('_')[1];

            LoadPresetRemarks();


            //$('#search_from')[0].sumo.disableItem(0); $('#search_to')[0].sumo.disableItem(0);
            //$.each(dataCategory, function (key, value) {
            //    $("#drpPresetReason").append($("<option     />").val(value.ID).text(value.MESSAGE));
            //});

        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}


function LoadCategories(val) {
    var selTS = '', selTE = '';

    var IsHaywd = ((FHaywood != 'NO' || ToHaywood != 'NO') ? '1' : '0');
    ServiceCode = (ServiceCode == '0') ? "1" : ServiceCode;
    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=" + ((RPreBook == '1' && ServiceCode == '2') ? 'GETCATEGORIESSCHD' : ((RPreBook == '1' && ServiceCode == '3') ? 'GETCATEGORIESSCHDCL' : 'GETCATEGORIES')) + "&VAL=" + encodeURIComponent(Encrypt((RPreBook == '1' && ServiceCode !== '2' && ServiceCode !== '3') ? 'book' : val)) + "&VAL1=" + encodeURIComponent(Encrypt(((ServiceCode !== '1') ? ReqCat : ReqCat + '_' + IsHaywd))) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            var catUL = '';
            var dataCategory = $.grep(data, function (element, index) {
                return element.FILTER == "CATEGORY";
            });

            $.each(dataCategory, function (key, value) {
                selTS = (((ReqCat == value.ID) && (selTS === '')) ? value.TS : selTS); selTE = (((ReqCat == value.ID) && (selTE === '')) ? value.TE : selTE);

                catUL += '<li> <input type="checkbox" id="chkCat' + value.ID + '" onchange="CatSelection(this,' + "'" + value.ID + "','" + value.ISTWOPORTERTASK + "','" + value.VALUE + "','" + value.QUANTITY + "','" + value.TS + "','" + value.TE + "','" + value.FLOCID + "','" + value.KITCHEN + "'" + ');" ><span> <img src="../images/check.png"></span> <img src="' + value.IMAGEPATH + '" alt="' + value.VALUE + '"> <p>' + value.VALUE + '</p> </li>';
            });

            $("#ReqCategories").html('<ul>' + catUL + '</ul>');


            //setTimeout(function () { setCategories(ReqCat);}, 400);

            $("#chkCat" + ReqCat).prop('checked', true);
            ReqCat = ReqCat;

            if (selTS != '' || selTE != '') {
                $('#lblKPITS').html(((selTS != '-' && selTS != '0') ? (selTS + '<br/> <span style="font-size:13px;"> (min) </span> ') : '-'));
                $('#lblKPITE').html(((selTE != '-' && selTE != '0') ? (selTE + '<br/> <span style="font-size:13px;"> (min) </span> ') : '-'));
            }


        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });

}

function setCategories(Id) {
    var eleID = "#chkCat" + Id;
    clearAllCheckBox('ReqCategories'); $(eleID).prop('checked', true);

    ReqCat = Id;
}

function OnChangeMTPorters(ele) {
    var value = $(ele).val(), selText = $('#search_PorterMT option:selected').text();

    ATPorterID = value;
    ATPorterName = selText.split("(")[0];

    PendingTasks = ''; PorterCurTasks = '';
    GetPorterTasks(value);


}

function LoadMTPorters() {
    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=GETMTPORTERS&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            var catUL = '';
            //$('#search_PorterMT')[0].sumo.reload();
            //$('#search_PorterMT').html('');
            clearSumo('search_PorterMT');
            $.each(data, function (key, value) {

                $('#search_PorterMT')[0].sumo.add(value.PORTERID, value.PORTERNAME + '(' + value.STATUS + ')');
            });


        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}

function clearSumo(ele) {

    var len = $('#' + ele + ' option').length;

    for (var i = len; i > 1; i--) {
        $('#' + ele)[0].sumo.remove(i - 1);
    }
}

function setNewTask() {
    var UName = sessionStorage.getItem('NAME'); $('#btnReqSubmit').css("display", "inline-block"); $("#spanRequestDate").html('');/*$("#divReqDate").css("display", 'none');*/
    $("#TaskHeader").html('New Task'); $("#ReqUserLogin").html('Entered By :' + UName); $("#divEditRemarks").css("display", 'none');
    document.getElementById('HFERID').value = ""; document.getElementById('HFERNO').value = ""; document.getElementById('HFStatusID').value = "";
    var DateTime = getCurdateTime(); EServiceCode = ''; LBKitName = ''; CatKitName = ''; LBKitID = '0'; CatKitID = '0';
    //alert(curDate);

    $('#txtFromLoc').attr("disabled", false);
    $('#txtToLoc').attr("disabled", false);
    document.getElementById("txtReqdate").value = DateTime.split('_')[0];
    document.getElementById("txtReqTime").value = DateTime.split('_')[1];

    $('#txtFromLoc').val(''); $('#txtToLoc').val('');

    //$('#search_from')[0].sumo.selectItem('0');
    //$('#search_Halt1')[0].sumo.selectItem('0');
    //$('#search_Halt2')[0].sumo.selectItem('0');
    //$('#search_to')[0].sumo.selectItem('0');
    setService(ServiceCode);
    ReqDate = DateTime.split('_')[0]; ReqTime = DateTime.split('_')[1]; $('#txtQty').val('');
    ReqCat = '0'; RFromID = '0'; RToID = '0'; RPreBook = "0"; RHalt1 = '0'; RHalt2 = '0';
    //$('#containerHalt1').css("display", "inline-block"); $('#containerHalt2').css("display", "inline-block");
    $('#containerDate').css("display", "none"); $('#containerTime').css("display", "none"); $('#DivPrebookSlider').css("display", "inline-block");
    // $('#chkMultiPorter').attr("src", "../images/NoMCheck.jpg"); $('#chkReturnCalls').attr("src", "../images/Return.png");
    $('#chkPreBook').prop('checked', false); $('#chkReturnCalls').prop('checked', false); $('#chkMultiPorter').prop('checked', false); $('#chkPreBook').prop('disabled', false);
    IsMTPR = '0'; IsRTC = '0'; FHaywood = 'NO'; ToHaywood = 'NO';
    $('#txtPatientName').val(''); $('#txtRemarks').val(''); $('#txtRequestorName').val(''); $('#txtSearchCat').val('');
    $('#txtPatientDOB').val(''); $('#txtPatientHNO').val(''); $('#txtContactNumber').val(''); $('#txtPorterRemarks').val('');
    disableRequestFileds(false); $('#divPorterRemarks').css("display", 'none');

    $('#divPorterRemarks').css("display", 'none');
    $('#search_Remarks')[0].sumo.unSelectAll(); $('#search_Remarks')[0].sumo.reload(); $('#search_Remarks')[0].sumo.selectItem(0);
    LoadCategories('');
    clearAllCheckBox('ReqCategories'); setDefaultLocation();

    $('#lblKPITS').html('-'); $('#lblKPITE').html('-');
    ShowModalAddtask();
}

function setService(ServiceCode) {

    if (ServiceCode == null)
        $('.services-btn-icon-modal').first().trigger('click');
    else {
        ServiceCode = (ServiceCode == '0') ? "1" : ServiceCode;
        sessionStorage.setItem('ServiceCode', ServiceCode);
        $('#divRService' + ServiceCode).trigger('click');
    }
}
function setDefaultLocation() {

    var DefaultLocationID = sessionStorage.getItem('DEFAULTLOCID'), DefaultLocation = sessionStorage.getItem('DEFAULTLOC');
    if (DefaultLocationID !== '0') {
        RFromID = DefaultLocationID; $('#txtFromLoc').val(DefaultLocation);
    }
}
function OnChangeRemarks(ele, txtRemark) {

    var val = $(ele).val(), eleID = $(ele).attr('id');

    if (val.length > 1)
        $(ele)[0].sumo.unSelectItem(0);
    else if (val == '')
        $(ele)[0].sumo.selectItem(0);



    //$('#' + txtRemark).css('display', ((val !== 'Others') ? "none" : "inline-block"));
    //if (val == 'Others')
    //    setTimeout(function () { $('#' + txtRemark).focus(); }, 200);
}

function LoadPresetRemarks() {
    $.ajax({
        url: hurl + "Service/Service.aspx?Process=PRESET&ACTION=GET&MSG=&GROUP=&ID=" + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var Remarks = $.grep(data, function (element, index) {
                return element.GROUPNAME == "REMARKS";
            });

            var CReason = $.grep(data, function (element, index) {
                return element.GROUPNAME == "CREASON";
            });

            var FReason = $.grep(data, function (element, index) {
                return element.GROUPNAME == "FREASON";
            });




            //clearSumoselect('drpRemarks');

            $('#search_Remarks').html(''); $('#search_Remarks')[0].sumo.add('0', '-- Select --'); $('#search_Remarks')[0].sumo.reload();

            $('#search_CancelRemarks').html(''); $('#search_CancelRemarks')[0].sumo.add('0', '-- Select --'); $('#search_CancelRemarks')[0].sumo.reload();

            $('#search_CompleteRemarks').html(''); $('#search_CompleteRemarks')[0].sumo.add('0', '-- Select --'); $('#search_CompleteRemarks')[0].sumo.reload();

            $('#searchCR_CancelRemarks').html(''); $('#searchCR_CancelRemarks')[0].sumo.add('0', '-- Select --'); $('#searchCR_CancelRemarks')[0].sumo.reload();


            $.each(Remarks, function (key, value) {
                $('#search_Remarks')[0].sumo.add(value.ID, value.MESSAGE);
            });

            $.each(CReason, function (key, value) {
                $('#search_CancelRemarks')[0].sumo.add(value.ID, value.MESSAGE);
                $('#searchCR_CancelRemarks')[0].sumo.add(value.ID, value.MESSAGE);
            });
            $.each(FReason, function (key, value) {
                $('#search_CompleteRemarks')[0].sumo.add(value.ID, value.MESSAGE);
            });

            // $('#search_Remarks')[0].sumo.add('Others', 'Others'); $('#search_CancelRemarks')[0].sumo.add('Others', 'Others'); $('#search_CompleteRemarks')[0].sumo.add('Others', 'Others');


            $('#search_Remarks')[0].sumo.selectItem(0); $('#search_CancelRemarks')[0].sumo.selectItem(0); $('#searchCR_CancelRemarks')[0].sumo.selectItem(0); $('#search_CompleteRemarks')[0].sumo.selectItem(0);

        },
        error: function (data) {

        }

    });
}

function LoadCancelRemarks(data) {


    $('#search_CancelRemarks').html(''); $('#search_CancelRemarks')[0].sumo.add('0', '-- Select --'); $('#search_CancelRemarks')[0].sumo.reload();

    $('#searchCR_CancelRemarks').html(''); $('#searchCR_CancelRemarks')[0].sumo.add('0', '-- Select --'); $('#searchCR_CancelRemarks')[0].sumo.reload();


    $.each(data, function (key, value) {
        $('#search_CancelRemarks')[0].sumo.add(value.ID, value.MESSAGE);
        $('#searchCR_CancelRemarks')[0].sumo.add(value.ID, value.MESSAGE);
    });

    $('#search_CancelRemarks')[0].sumo.selectItem(0); $('#searchCR_CancelRemarks')[0].sumo.selectItem(0);
}
function getModifiedValues() {


    var PatientName = $('#txtPatientName').val(), ReqtrName = $('#txtRequestorName').val().trim(), UserName = sessionStorage.getItem('NAME'), qty = $('#txtQty').val(), kitchen = $('#txtFromLoc').val().trim();

    var ModifiedValues = ' The Below task details are modified by ' + UserName + '. <br/>';

    ModifiedValues += (((OldFromID != RFromID) ? ('From Location' + ((EServiceCode == '2') ? '(kitchen)' : '') + ' : ' + ((EServiceCode == '2') ? OKitchen : OldFrom) + ' to ' + ((EServiceCode == '2') ? kitchen : NewFrom) + ', <br/> ') : '') +
        ((OldToID != RToID) ? ('To Location : ' + OldTo + ' to ' + NewTo + ', <br/> ') : '') +
        ((OldCatID != ReqCat) ? ('Task Type : ' + OldCategory + ' to ' + NewCategory + ', <br/> ') : '') +
        ((OldPatientName != PatientName) ? ('Patient Name : ' + OldPatientName + ' to ' + PatientName + ', <br/> ') : '') +
        ((OldQuantity != qty) ? ('Quantity : ' + OldQuantity + ' to ' + qty + ', <br/> ') : '') +
        ((OldRequestorName != ReqtrName) ? ('Requestor : ' + OldRequestorName + ' to ' + ReqtrName + ', <br/> ') : '') +
        ((OldIsMultiPorter != IsMTPR) ? ('MultiPorter : ' + ((OldIsMultiPorter == '1') ? 'YES' : 'NO') + ' to ' + ((IsMTPR == '1') ? 'YES' : 'NO') + ', <br/> ') : '')
    );

    return ModifiedValues;
}

function setEditTask(ReqNB, ReqID, FromId, ToId, CategoryID, RequestStatus, StatusID, PatientName, Remarks, CompletedRemarks, CancelledRemarks, MultiPorter, IsReturnRequired, IsReturn, MUIndex, RQuantity, RequestorName, From, To, CategoryName,
    PorterRemarks, ContactNo, IsQuantity, TS, TE, LoginName, RequestType, ReqDateTime, ServiceID, Kitchen, AuthorizerName) {

    $("#containerMP").css("display", ((MUIndex == '0' || MUIndex == '' || MUIndex == 'null') ? "inline-block" : "inline-block"));
    $("#TaskHeader").html('Task #' + ReqNB + '-' + RequestStatus); $("#divEditRemarks").css("display", 'block');
    $("#ReqUserLogin").html('Entered By :' + LoginName); $("#spanRequestDate").html('Request Date :-' + ReqDateTime);
    var DateTime = getCurdateTime(); var CatEle = $('#chkCat' + CategoryID); $('#txtQty').val(RQuantity);
    document.getElementById('HFERID').value = ReqID; document.getElementById('HFERNO').value = ReqNB; document.getElementById('HFStatusID').value = StatusID;
    //alert(curDate);
    NewFrom = ''; NewTo = ''; NewCategory = '';
    OldFromID = FromId; OldFrom = From; OldToID = ToId; OldTo = To; OldCatID = CategoryID; OldCategory = CategoryName; OldPatientName = PatientName; OldQuantity = RQuantity; OldRequestorName = RequestorName;
    OldIsMultiPorter = ((MultiPorter != 'No') ? '1' : '0'); EServiceCode = ServiceID; OKitchen = Kitchen;

    //$('#search_Halt1')[0].sumo.selectItem('0');
    //$('#search_Halt2')[0].sumo.selectItem('0');
    //$('#search_from')[0].sumo.selectItem('0'); $('#search_from')[0].sumo.selectItem(From);
    //$('#search_to')[0].sumo.selectItem('0'); $('#search_to')[0].sumo.selectItem(To);

    $('#txtFromLoc').val(''); $('#txtFromLoc').val(((ServiceID == '2') ? Kitchen : From));
    $('#txtToLoc').val(''); $('#txtToLoc').val(((ServiceID == '3') ? Kitchen : To));

    $('#txtPorterRemarks').val(''); $('#txtPorterRemarks').val(PorterRemarks);
    $('#txtContactNumber').val(''); $('#txtContactNumber').val(ContactNo);

    $("#suggesstionTo").hide();
    $("#suggesstionFrom").hide();

    $('#divQuantity').css("display", ((IsQuantity == '1') ? "inline-block" : "none"));

    //$('#containerHalt1').css("display", "none"); $('#containerHalt2').css("display", "none");
    if (StatusID == '6' || StatusID == '7') {
        $('#txtFromLoc').attr("disabled", true);
        $('#txtToLoc').attr("disabled", true);
    }
    FHaywood = ((IsHaywood) ? 'YES' : 'NO'); ToHaywood = ((IsHaywood) ? 'YES' : 'NO');
    //$('#divEditRemarks').css("display", ((StatusID !== '6' && StatusID !== '7') ? "none" : "inline-block"));

    //$('#divCompleteRemarks').css("display", ((StatusID !== '6') ? "none" : "inline-block"));

    $('#divCancelRemarks').css("display", ((StatusID !== '7') ? "none" : "inline-block"));

    $('#divSelCRemarks').css("display", (((StatusID == '6') || (StatusID == '7')) ? "none" : "flex"));

    ReqCat = CategoryID; RFromID = FromId; RToID = ToId; RHalt1 = '0'; RHalt2 = '0';


    if (RequestType == 'PREBOOK') {
        //DateTime = getCurdateTime(ReqDate);
        DateTime = getCurdateTime(ReqDateTime);
        ReqDate = DateTime.split('_')[0]; ReqTime = DateTime.split('_')[1];
        $('#containerDate').css("display", "inline-block"); $('#containerTime').css("display", "inline-block"); $('#btnReqSubmit').css("display", "none");
        document.getElementById("txtReqdate").value = DateTime.split('_')[0]; document.getElementById("txtReqTime").value = DateTime.split('_')[1];

        //$("#spanRequestDate").html('Booked Date :-' + ReqDate);
        // $('#chkMultiPorter').attr("src", "../images/NoMCheck.jpg"); $('#chkReturnCalls').attr("src", "../images/Return.png");
        $('#chkPreBook').prop('checked', true); RPreBook = '1';
    } else {
        $('#containerDate').css("display", "none"); $('#containerTime').css("display", "none"); $('#DivPrebookSlider').css("display", "none");
        document.getElementById("txtReqdate").value = DateTime.split('_')[0]; document.getElementById("txtReqTime").value = DateTime.split('_')[1];
        $('#chkPreBook').prop('checked', false); RPreBook = "0"; $('#btnReqSubmit').css("display", "inline-block");
    }
    $('#btnReqSubmit').css("display", "inline-block");
    $('#chkPreBook').prop('disabled', true);

    //$('#DivPrebookSlider').css("display", "none");
    //$('#containerDate').css("display", "none"); $('#containerTime').css("display", "none");
    //$('#chkMultiPorter').attr("src", (MultiPorter != 'No') ? "../images/MCheck.jpg" : "../images/NoMCheck.jpg");
    //$('#chkReturnCalls').attr("src", (IsReturnRequired != '1') ? "../images/Return.png" : "../images/SReturn.png");
    //$('#chkPreBook').prop('checked', false);
    $('#chkMitigation').attr("src", "../images/NoMCheck.jpg");
    $('#chkReturnCalls').prop('checked', ((IsReturnRequired != '1') ? false : true)); $('#chkMultiPorter').prop('checked', ((MultiPorter != 'No') ? true : false));
    IsMTPR = ((MultiPorter != 'No') ? '1' : '0'); IsRTC = ((IsReturnRequired != '1') ? '0' : '1'); OIsMTPR = ((MultiPorter != 'No') ? '1' : '0');

    $('#txtPatientName').val(PatientName);
    $('#txtRequestorName').val(RequestorName);


    /* $('#txtRemarks').val(Remarks);

    $('#txtCompleteRemarks').val(CompletedRemarks); $('#txtCanceRemarks').val(CancelledRemarks);

    $('#search_Remarks')[0].sumo.selectItem('Others'); $('#search_CancelRemarks')[0].sumo.selectItem('Others'); $('#search_CompleteRemarks')[0].sumo.selectItem('Others'); */


    $('#txtCompleteRemarks').val('');
    $('#chkMultiPorter').prop('disabled', false);
    if (StatusID !== '2') { // (StatusID == '6' || StatusID == '9' || StatusID == '7')
        //setCompleteNotes(CompletedRemarks);
        $('#chkMultiPorter').prop('disabled', true);

    }

    if (StatusID == '2' || StatusID == '100') {
        $('#divPorterRemarks').css("display", 'none');
        disableRequestFileds(false);
    }
    else {
        $('#divPorterRemarks').css("display", 'inline-block');
        $('#txtPorterRemarks').attr("disabled", true);
        disableRequestFileds(true);
    }

    $('#txtPorterRemarks').attr("disabled", true);

    //$('#divCompleteRemarks').css("display", ((StatusID == '6' || StatusID == '9') ? "inline-block" : "none"));

    //$('#txtCompleteRemarks').css("display", ((StatusID !== '6') ? "none" : "inline-block"));

    $('#txtCanceRemarks').css("display", ((StatusID !== '7') ? "none" : "inline-block"));

    //setRemarks('search_CompleteRemarks', 'txtCompleteRemarks', CompletedRemarks);


    var FirstCharClR = CancelledRemarks.slice(0, 1), FirstCharR = Remarks.slice(0, 1);
    CancelledRemarks = ((FirstCharClR == ',') ? CancelledRemarks.substring(1) : CancelledRemarks); Remarks = ((FirstCharR == ',') ? Remarks.substring(1) : Remarks);
    $('#txtCanceRemarks').val(CancelledRemarks);
    $('#txtRemarks').val(Remarks);
    //setRemarks('search_CancelRemarks', 'txtCanceRemarks', CancelledRemarks);
    //setRemarks('search_Remarks', 'txtRemarks', Remarks);

    clearAllCheckBox('ReqCategories');

    LoadCategories(''); ShowModalAddtask();

    setService(ServiceID);

    if (CategoryID == '316' | CategoryID == '373') {
        $('#lblPatientDetails').html('Authorizer');
        $('#containerPatient').css("display", "inline-block");
        $('#txtFromLoc').attr("disabled", true);
        $('#txtPatientName').val(AuthorizerName);
        $('#divEndDate').css("display", "none");
    } else {
        $('#containerPatient').css("display", "none");
        $('#divEndDate').css("display", "none");
        $('#txtFromLoc').attr("disabled", false);
    }
    //$(CatEle).prop('checked', true);

}

function disableRequestFileds(Enable) {
    $('#search_Remarks').attr("disabled", Enable); $('#divSelRemarks').css("display", ((Enable) ? "none" : "flex"));
    $('#txtRemarks').attr("disabled", Enable);
    $('#txtPatientName').attr("disabled", Enable);
    $('#txtRequestorName').attr("disabled", Enable);
    $('#txtSearchCat').attr("disabled", Enable);
    $('#txtQty').attr("disabled", Enable);
    $('#txtRemarks').attr("disabled", Enable);
    $('#txtRequestorName').attr("disabled", Enable);
    $('#txtContactNumber').attr("disabled", Enable);
    $('#txtPatientDOB').attr("disabled", Enable);
    $('#txtPatientHNO').attr("disabled", Enable);

}
//function showPrevNotes() {
//    var display = $('#divPrevNotes').css("display");
//    if (display == 'none') {
//        $('#divPrevNotes').css("display", "inline-block");
//        $('#lblPreNotes').html('hide');
//    }
//    else {

//        $('#divPrevNotes').css("display", "none");
//        $('#lblPreNotes').html('show');
//    }

//}

function setCompleteNotes(Remarks) {

    var arrRemarks = Remarks.split(',');
    var htmlCompleteNotes = '';
    $.each(arrRemarks, function (index, value) {
        if (value.trim()) {
            var valueArray = value.split('|$|'), IsMitigation = valueArray[3].toString();
            htmlCompleteNotes += '<div class="msgContainer"><p class="msgUser">' + valueArray[0].toString() + ((IsMitigation == "YES") ? ('<span class="mitigation-right"> </span>') : '') + '</p> <p>' + valueArray[1].toString() + '<span class="time-right">' + valueArray[2].toString() + '</span></div>'

        }
    });
    $('#divPrevNotes').html(htmlCompleteNotes); $('#divPrevNotes').css("display", "none"); $('#lblPreNotes').html('show');

}



function openCompleteNotes(ComRemarks, ReqID, RStatus) {
    //var arrRemarks = ComRemarks.split('|#|');
    getCompleteLogs(ReqID, RStatus);

    //arrRemarks = arrRemarks.split('|#|');
    //document.getElementById('HFERID').value = ReqID; EStatusID = RStatus;

    //var htmlCompleteNotes = '';
    //$('#chkMitigationCom').attr("src", "../images/MCheck.jpg");
    //$.each(arrRemarks, function (index, value) {
    //    if (value.trim()) {
    //        var valueArray = value.split('|$|'), IsMitigation = valueArray[3].toString();
    //        htmlCompleteNotes += '<div class="msgContainer"><p class="msgUser">' + valueArray[0].toString() + ((IsMitigation == "YES") ? ('<span class="mitigation-right"> </span>') : '') + '</p> <p>' + valueArray[1].toString().replace('_', ' ') + '<span class="time-right">' + valueArray[2].toString() + '</span></div>'

    //    }
    //});
    //$('#divComNotes').html(htmlCompleteNotes); $('#txtComRemarks').val(''); ShowModalPopUp('ModalCompleteNotes');
    //$('#search_CompleteRemarks')[0].sumo.unSelectAll(); $('#search_CompleteRemarks')[0].sumo.reload(); $('#search_CompleteRemarks')[0].sumo.selectItem(0);
    //setTimeout(function () { $('#txtComRemarks').focus(); $('#divComNotes').show(500); }, 1000);
}
//function getLogs(ReqID) {

//    $.ajax({
//        url: hurl + "Service/ServiceAddTask.aspx?Process=GETLOGS&REQUESTID=" + encodeURIComponent(Encrypt(ReqID)),
//        type: 'POST',
//        data: 'pData',
//        dataType: 'json',
//        success: function (data) {
//            if (data[0].RESULT.split("_")[0] === 'TRUE') {
//                var divIndex = (EStatusID == "0") ? "divTotalPercentage" : (EStatusID == "2") ? "divPendingPercentage" : (EStatusID == "3") ? "divAssignedPercentage" : (EStatusID == "4") ? "divInprogressPercentage" : (EStatusID == "6") ? "divCompletedPercentage" : (EStatusID == "7") ? "divCancelledPercentage" : (EStatusID == "8") ? "divPendingOnHoldPercentage" : (EStatusID == "9") ? "divTatExceededPercentage" : (EStatusID == "100") ? "divPrebookeddPercentage" : "divTotalPercentage";

//                setTimeout(function () { Select(divIndex, "COMPLETED"); HideModalPopUp('ModalDoneAddRemarks'); }, 1000);
//            }
//        },
//        error: function (data) {
//            $('#').html(data[0].RESULT);
//        }
//    });

//}


function getCompleteLogs(ReqID, RStatus) {

    $.ajax({
        url: hurl + "Service/ServiceAddTask.aspx?Process=GETCOMPLETELOGS&REQUESTID=" + encodeURIComponent(Encrypt(ReqID)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            CRemarks = data[0].RESULT;
            LoadCompleteRemarks(CRemarks, ReqID, RStatus)

        },
        error: function (data) {
            CRemarks = data[0].RESULT;
        }
    });


}

function LoadCompleteRemarks(ComRemarks, ReqID, RStatus) {
    var arrRemarks = ComRemarks.split('|#|');
    document.getElementById('HFERID').value = ReqID; EStatusID = RStatus;

    var htmlCompleteNotes = '';
    $('#chkMitigationCom').attr("src", "../images/MCheck.jpg");
    $.each(arrRemarks, function (index, value) {
        if (value.trim()) {
            var valueArray = value.split('|$|'), IsMitigation = valueArray[3].toString();
            htmlCompleteNotes += '<div class="msgContainer"><p class="msgUser">' + valueArray[0].toString() + ((IsMitigation == "YES") ? ('<span class="mitigation-right"> </span>') : '') + '</p> <p>' + valueArray[1].toString().replace('_', ' ') + '<span class="time-right">' + valueArray[2].toString() + '</span></div>'

        }
    });
    $('#divComNotes').html(htmlCompleteNotes); $('#txtComRemarks').val(''); ShowModalPopUp('ModalCompleteNotes');
    $('#search_CompleteRemarks')[0].sumo.unSelectAll(); $('#search_CompleteRemarks')[0].sumo.reload(); $('#search_CompleteRemarks')[0].sumo.selectItem(0);
    setTimeout(function () { $('#txtComRemarks').focus(); $('#divComNotes').show(500); }, 1000);
}


function openReqLogs(ReqID) {

    $.ajax({
        url: hurl + "Service/ServiceAddTask.aspx?Process=GETLOGS&REQUESTID=" + encodeURIComponent(Encrypt(ReqID)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var reqLog = data[0].RESULT;
            LoadReqLogs(reqLog, ReqID);
        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });

}

function LoadReqLogs(ReqLogs, ReqID) {

    var arrRemarks = ReqLogs.split('|#|'); $('#spanLogReq').html('Request #' + ReqID);
    //document.getElementById('spanLogReq').value = ReqID;

    var htmlCompleteNotes = '';
    $.each(arrRemarks, function (index, value) {
        if (value.trim()) {
            var valueArray = value.split('|$|'), IsMitigation = valueArray[3].toString();
            htmlCompleteNotes += '<div class="msgContainer"><p class="msgUser">' + valueArray[0].toString() + ((IsMitigation == "YES") ? ('<span class="mitigation-right"> </span>') : '') + '</p> <p>' + valueArray[1].toString().replace('_', ' ') + '<span class="time-right">' + valueArray[2].toString() + '</span></div>'

        }
    });
    $('#divReqLogs').html(htmlCompleteNotes); ShowModalPopUp('ModalReqLogs');
    setTimeout(function () { $('#divReqLogs').show(500); }, 1000);
}
//function openReqLogs(ReqLogs, ReqID) {
//    alert(ReqID);
//    ReqLogs = getLogs(ReqID);
//    var arrRemarks = ReqLogs.split('|#|'); $('#spanLogReq').html('Request #' + ReqID);
//    //document.getElementById('spanLogReq').value = ReqID;

//    var htmlCompleteNotes = '';
//    $.each(arrRemarks, function (index, value) {
//        if (value.trim()) {
//            var valueArray = value.split('|$|'), IsMitigation = valueArray[3].toString();
//            htmlCompleteNotes += '<div class="msgContainer"><p class="msgUser">' + valueArray[0].toString() + ((IsMitigation == "YES") ? ('<span class="mitigation-right"> </span>') : '') + '</p> <p>' + valueArray[1].toString().replace('_', ' ') + '<span class="time-right">' + valueArray[2].toString() + '</span></div>'

//        }
//    });
//    $('#divReqLogs').html(htmlCompleteNotes); ShowModalPopUp('ModalReqLogs');
//    setTimeout(function () { $('#divReqLogs').show(500); }, 1000);;
//}

function submitNotes() {
    var drpCompleteRemark = selectedText('search_CompleteRemarks');

    var UID = sessionStorage.getItem('ID'), Remark = drpCompleteRemark + '_' + $('#txtComRemarks').val().trim();
    var ReqID = document.getElementById('HFERID').value;
    var srcMitigation = $('#chkMitigationCom').attr('src');
    var IsMitigation = (srcMitigation == "../images/NoMCheck.jpg") ? "0" : "1";
    if (Remark.length == 0) {
        $('#txtComRemarks').focus();
    } else {
        HideModalPopUp('ModalCompleteNotes'); ShowModalPopUp('ModalDoneAddRemarks');
        $.ajax({
            url: hurl + "Service/Service.aspx?Process=ADDCOMPLETEREMARKS&REQUESTID=" + ReqID + "&USERID=" + UID + "&REMARKS=" + Remark + "&ISMITIGATION=" + IsMitigation,
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {
                if (data[0].RESULT.split("_")[0] === 'TRUE') {
                    var divIndex = (EStatusID == "0") ? "divTotalPercentage" : (EStatusID == "2") ? "divPendingPercentage" : (EStatusID == "3") ? "divAssignedPercentage" : (EStatusID == "4") ? "divInprogressPercentage" : (EStatusID == "6") ? "divCompletedPercentage" : (EStatusID == "7") ? "divCancelledPercentage" : (EStatusID == "8") ? "divPendingOnHoldPercentage" : (EStatusID == "9") ? "divTatExceededPercentage" : (EStatusID == "100") ? "divPrebookeddPercentage" : "divTotalPercentage";

                    setTimeout(function () { Select(divIndex, "COMPLETED"); HideModalPopUp('ModalDoneAddRemarks'); }, 1000);
                }
            },
            error: function (data) {
                $('#').html(data[0].RESULT);
            }
        });

    }
}

function showPrevNotes() {
    var lblVal = $('#lblPreNotes').html();
    if (lblVal == 'show') {
        $('#divPrevNotes').show(500);
        $('#lblPreNotes').html('hide');
    }
    else {
        $('#divPrevNotes').hide(500)
        $('#lblPreNotes').html('show');
    }

}
function setRemarks(sumosel, textbox, Remarks) {

    var remarkArr = Remarks.split(','), Options = getOptions(sumosel), textVal = '', OppArray = Options.split(',');

    $('#' + sumosel)[0].sumo.unSelectAll();

    if (Remarks.trim().length > 0) {

        $.each(remarkArr, function (index, value) {
            if (value.trim().length > 0) {
                var valueIndex = OppArray.indexOf(value);
                if (Options.includes(value))
                    $('#' + sumosel)[0].sumo.selectItem(valueIndex);
                else {
                    if (valueIndex != '-1')
                        $('#' + sumosel)[0].sumo.unSelectItem(valueIndex);
                    textVal += value + ',';
                }
            } else {
                $('#' + sumosel)[0].sumo.unSelectAll(); $('#' + sumosel)[0].sumo.reload(); $('#' + sumosel)[0].sumo.selectItem(0);
            }
        });
    } else {

        $('#' + sumosel)[0].sumo.unSelectAll(); $('#' + sumosel)[0].sumo.reload(); $('#' + sumosel)[0].sumo.selectItem(0);
    }

    textVal = textVal.slice(0, -1);

    $('#' + textbox).val(textVal);

}

function getOptions(drpSumo) {
    var valSel = '';
    $('#' + drpSumo + ' option').each(function (i) {
        valSel += $(this).text() + ',';
    });

    return valSel;
}

function searchCategory(ele) {
    var val = $(ele).val();
    //if (val.trim().length > 0)
    LoadCategories(val);


}

function CatSelection(ele, ID, IsTwoPorter, CatName, IsQuantity, TS, TE, FLOCID, KITCHEN) {

    var EStatusID = document.getElementById('HFStatusID').value;
    var NCName = '', NCID = '0';

    if (EStatusID == '' || EStatusID == '100') { // EStatusID == '2' ||
        var count = getCatCount();
        if (count > 1) {
            $(ele).prop('checked', false);
        } else {
            if (count == 0) {
                CatKitName = ''; CatKitID = '0'; NCName = (LBKitID != '0') ? LBKitName : ''; NCID = (LBKitID != '0') ? LBKitID : '0';

                ReqCat = '0';
                NewCategory = '';
            } else {

                CatKitName = KITCHEN; CatKitID = FLOCID; NCName = (LBKitName.includes('Haywood')) ? LBKitName : (((CatKitName.includes("Main") && LBKitName.includes("Main")) || ID == '411') ? LBKitName : ((CatKitName.includes("Main")) ? CatKitName : LBKitName));
                NCID = (LBKitName.includes('Haywood')) ? LBKitID : (((CatKitName.includes("Main") && LBKitName.includes("Main")) || ID == '411') ? LBKitID : ((CatKitName.includes("Main")) ? CatKitID : LBKitID));

                ReqCat = ID;
                NewCategory = CatName;
            }


            if (ServiceCode == '2') {
                $("#txtFromLoc").val(NCName);
                RFromID = NCID;
            }
        }
        $('#divQuantity').css("display", ((IsQuantity == '1') ? "inline-block" : "none"));

        if (count == '1') {
            $('#lblKPITS').html(((TS !== '-' && TS !== '0') ? (TS + '<br/> <span style="font-size:13px;"> (min) </span> ') : '-'));
            $('#lblKPITE').html(((TE !== '-' && TE !== '0') ? (TE + '<br/> <span style="font-size:13px;"> (min) </span> ') : '-'));

            if (ReqCat == '116') {
                $('#chkMultiPorter').prop('checked', ((IsTwoPorter == '1' && count == 1) ? true : false));

                IsMTPR = ((IsTwoPorter == '1' && count == 1) ? "1" : "0");
            }

        } else if (count == '0') {
            $('#lblKPITS').html('-');
            $('#lblKPITE').html('-');
            $('#chkMultiPorter').prop('checked', false); IsMTPR = "0";

        }

        if (ServiceCode == "3") {
            if (count == '1') {
                var EndDate = GetBarearEndDate();
                $('#containerPatient').css("display", ((ReqCat == "73") && (count == '1')) ? "inline-block" : "none");
                $('#divEndDate').css("display", ((ReqCat == "73") && (count == '1')) ? "inline-block" : "none");
                $('#lblEndDate').html(((ReqCat == "73") && (count == '1')) ? EndDate : "-");
                //if ((ReqCat == "73") && (count == '1')) {
                //    $('#chkPreBook').prop('checked', false);
                //    $('#switchOccurrence').prop('disabled', true);
                //}
            } else if (count == '0') {
                $('#containerPatient').css("display", "none");
                $('#divEndDate').css("display", "none");
                $('#lblEndDate').html("-");
            }
        }



    } else {

        ReqCat = OldCatID;
        setCategories(OldCatID);
    }



    //$('#chkMultiPorter').prop('checked', ((IsTwoPorter == '1' && count == 1) ? true : false));

    //IsMTPR = ((IsTwoPorter == '1' && count == 1) ? "1" : "0");

}

function getCatCount() {

    var selCount = 0;
    $('#ReqCategories input:checked').each(function () {
        selCount += 1;
    });

    return selCount;
}

function clearAllCheckBox(eleID) {

    $('#' + eleID + ' input:checkbox').prop('checked', false);
}

function BindLocation(Id, Value, type, Haywood, CGname, CFromID) {
    var PFHaywood = FHaywood, PTHaywood = ToHaywood;
    if (type == "SF") {
        RFromID = Id;
        NewFrom = Value;
        $("#txtFromLoc").val(Value);
        $("#suggesstionFrom").hide();
        FHaywood = Haywood;
        if (ServiceCode == '3') {
            RToID = Id;
            NewTo = Value;
            $("#txtToLoc").val(CGname);
        }
    }
    else if (type == "ST") {
        RToID = Id;
        NewTo = Value;
        $("#txtToLoc").val(Value);
        $("#suggesstionTo").hide();
        ToHaywood = Haywood;

        if (ServiceCode == '2') {
            LBKitName = CGname; LBKitID = CFromID;
            var NCName = (CatKitName.includes("Main") && LBKitName.includes("Main")) ? LBKitName : ((CatKitName.includes("Main") || LBKitID == '0') ? CatKitName : LBKitName),
                NCID = (CatKitName.includes("Main") && LBKitName.includes("Main")) ? LBKitID : ((CatKitName.includes("Main") || LBKitID == '0') ? CatKitID : LBKitID);

            $("#txtFromLoc").val(NCName);
            RFromID = NCID;
            $("#suggesstionFrom").hide();
        }
    }
    if (PFHaywood != FHaywood || PTHaywood != ToHaywood) {
        ReqCat = '0'
        LoadCategories('');
    }
}

function setLocation(ele, Type) {

    var value = $(ele).val();

    $(ele).closest('.sumo-container').removeClass('active');

    // Add active class to the specific container if an option is selected
    if ($(ele).find('option:selected').length > 0 && value !== '0') {
        $(ele).closest('.sumo-container').addClass('active');
    }


    if (Type == 'From')
        RFromID = value;
    else if (Type == 'To')
        RToID = value;
    else if (Type == 'Halt1')
        RHalt1 = value;
    else if (Type == 'Halt2')
        RHalt2 = value;


}

function loadsuggesstion(searchType, Val) {

    ServiceCode = (ServiceCode == '0') ? "1" : ServiceCode;
    var sType = ((searchType == 'from') ? "SF" : "ST")
    $.ajax({
        async: true,
        url: hurl + "Service/Service.aspx?Process=GETSEARCHEDLOCATION&LOCATION=" + encodeURIComponent(Encrypt(Val)) + "&STYPE=" + encodeURIComponent(Encrypt(sType)) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        beforeSend: function () {
            $("#" + ((searchType == 'from') ? "txtFromLoc" : "txtToLoc")).css("background", "#FFF url(../images/LoadingN.gif) no-repeat 95%").css("background-size", "35px");
        },
        success: function (data) {
            $("#" + ((searchType == 'from') ? "suggesstionFrom" : "suggesstionTo")).show();
            $("#" + ((searchType == 'from') ? "suggesstionFrom" : "suggesstionTo")).html(data[0].RESULT);
            $("#" + ((searchType == 'from') ? "txtFromLoc" : "txtToLoc")).css("background", "#FFF");
        }
    });
}

function setPorterMT(ele) {
    var value = $(ele).val(), selText = $('#search_PorterMT option:selected').text();

    ATPorterID = value;
    ATPorterName = selText.split("(")[0];
}


function getPorterStatus(Status, EleID) {
    var UID = sessionStorage.getItem('ID'), PRID = sessionStorage.getItem('ROLE'); setRequestUsers('Users');

    $.each(ReqArrUserDiv, function (index, value) {
        if (value == EleID)
            $('#' + value).addClass('SelectIndexIcon');
        else
            $('#' + value).removeClass('SelectIndexIcon');

    });
    LoaderOn();
    var FinalUrl = hurl + "Service/Service.aspx?Process=GETPORTERSTATUS&Status=" + Status + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode));
    $.ajax({
        url: FinalUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            var tblUsers = '<table class="table scroll table-bordered"> <thead> <tr><th scope="col">Porter Name</th><th scope="col">Login Time</th><th scope="col">Status</th> <th scope="col">No. of Calls</th><th scope="col">Total Hours (HH:MM)</th><th scope="col">Work Hours (HH:MM)</th><th scope="col">Break Hours (HH:MM)</th><th scope="col">Idle Hours (HH:MM)</th></tr></thead><tbody>',

                tblContent = '';


            if (data.length > 0) {

                $.each(data, function (key, value) {

                    tblContent += ' <tr><td>' + value.PORTERNAME + '</td><td>' + value.LOGINTIME + '</td> <td>' + value.STATUS + '</td><td>' + value.NoOfCalls + '</td><td>' + value.TotalHours + '</td><td>' + value.WorkHours + '</td><td>' + value.BreakHours + '</td><td>' + value.IdleHours + '</td></tr> ';


                });
            }


            tblUsers += tblContent + '</tbody > </table > '; $('#tblUsers').html(tblUsers);
        },
        error: function (data) {

        },


    });
    LoaderOff(400);
}

function setRequestUsers(Process) {

    switch (Process) {
        case "Tasks":

            $('#users').removeClass('active').removeClass('show'); $('#tasks').addClass('active').addClass('show');
            $('#users-tab').removeClass('active'); $('#tasks-tab').addClass('active');
            $('#divUserHeaders').css("display", "none"); $('#divRequestHeaders').css("display", "inline-flex");

            $('#divBarrierPercentage').css("display", ((ServiceCode == '3') ? "inline-flex" : "none"));
            $('#chkUserRequest').prop('checked', false);
            break;
        case "Users":
            $('#tasks').removeClass('active').removeClass('show'); $('#users').addClass('active').addClass('show');
            $('#tasks-tab').removeClass('active'); $('#users-tab').addClass('active');
            $('#divRequestHeaders').css("display", "none"); $('#divUserHeaders').css("display", "inline-flex");
            $('#chkUserRequest').prop('checked', true);
            break;
    }
}

function AddTask(PRName, FPId, status) {
    //GTagID = cTagID;
    PorterCurTasks = ''; PendingTasks = ''; ATPorterID = ''; ATPorterName = ''; ATReqNB = ''; ATStatus = ''; FPId = ''; MTCount = 60; clearInterval(MTInterval);
    //$('#LBLPorterNam').text(PRName);


    GetPorterTasks(FPId); ATPorterName = PRName; ATStatus = status; startMTCount();
    LoadMTPorters();
    $('#search_PorterMT')[0].sumo.selectItem('0');
    //setTimeout(function () { $('#search_PorterMT')[0].sumo.selectItem(FPId) }, 1000);
    ShowModalPopUp('ModalAddTask');

}


function startMTCount() {
    MTInterval = window.setInterval(function () { processMT(); }, 1000);
}

function processMT() {

    if (MTCount == 0)
        clearMT();
    else {
        $('#MTCount').text(MTCount);
        MTCount -= 1;
    }
}

function clearMT() {
    MACount = 60;
    clearInterval(MTInterval); HideModalPopUp("ModalAddTask"); HideModalPopUp("ModalMTDone");
    PorterCurTasks = ''; PendingTasks = ''; ATPorterID = ''; ATPorterName = ''; ATReqNB = '';
    ToUpdate = !ToUpdate; ReloadLinks(); LoadProcess(CProcess); ATStatus = ''; $('#search_PorterMT')[0].sumo.selectItem('0');
    $('#MTCount').text(60);
    if (Type = 'DB')
        clearMADB();
}


function clearMADB() {
    $.ajax({
        async: true,
        url: hurl + "Service/ServiceRequest.aspx?Process=CLEARMANUALASSIGN",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

        },
        error: function (data) {

        }

    });
}

function getHHMMSSOld(value) {
    hours = Math.floor(value / 3600);
    value %= 3600;
    minutes = Math.floor(value / 60);
    seconds = value % 60;

    return hours + ":" + minutes + ":" + seconds;
}

function getHHMMSS(value) {

    var abvalue = Math.abs(value);

    var hhmmss = new Date(abvalue * 1000).toISOString().substring(11, 19) // .substring(11, 19)

    var arhhmmss = hhmmss.split(':');
    var finalhhmmss = ((arhhmmss[0] == '00') ? '' : (arhhmmss[0] + ':')) + arhhmmss[1] + ':' + arhhmmss[2];
    return ((value < 0) ? '-' : '') + finalhhmmss;
}

function InitPagination(vic, pageIndex) {

    var remainder = (vic % pageSize), div = Math.floor(vic / pageSize);
    var Pages = div + ((remainder > 0) ? 1 : 0);

    valuePage.curPage = pageIndex;
    valuePage.totalPages = Pages;

    setCurrentPager(pageIndex);

    $('.page-container').css('display', 'flex');

}

function setCurrentPager(pageNumber) {

    valuePage.curPage = pageNumber;
    pageIndex = ((pageNumber == 0) ? 1 : pageNumber) - 1;
    //curPage.value = pageNumber;
    //pagination(valuePage);

    //LoadProcess(CProcess);
    handleButtonLeft();
    handleButtonRight();
}

function changeGridSize(ele) {
    var val = parseInt($(ele).val())
    pageSize = ((val != 'NaN') ? val : 5); pageIndex = 0;
    LoadProcess(CProcess);

}

function setPageSize() {
    var val = parseInt($('#pageSize').val())
    pageSize = ((val != 'NaN') ? val : 5);
}


function OpenPhoto(ReqID, Header, Path, HeadPhoto, AckOn) {
    $('#imgAckHead').attr("src", HeadPhoto); $('#ACK_ON').html(AckOn);
    $('#ImgACK').attr("src", Path); $('#spanAckHead').html(Header);
    ShowModalPopUp('ModalImage'); $('#spanReqID').html('#' + ReqID);
}
function LoadTableRequest(Process, tblRequset) {
    var UID = sessionStorage.getItem('ID'), PRID = sessionStorage.getItem('ROLE'), CanCancel = sessionStorage.getItem('CancelTask'), CanStartEnd = sessionStorage.getItem('canStartComplete');


    var duplicateOption = (((PRID == "2") || (PRID == "5") || (PRID == "6")) && (CProcess !== "9"));
    var FilterQuery = INQueryBuilder(); setPageSize();
    var FinalUrl = hurl + "Service/Service.aspx?Process=GET&Status=" + encodeURIComponent(Encrypt(Process)) + "&Search=" + encodeURIComponent(Encrypt(FilterQuery)) + "&USERID=" + encodeURIComponent(Encrypt(UID))
        + "&PageIndex=" + encodeURIComponent(Encrypt(pageIndex)) + "&PageSize=" + encodeURIComponent(Encrypt(pageSize)) + "&ROLE=" + encodeURIComponent(Encrypt(PRID)) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode));
    $.ajax({
        url: FinalUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            //(EleID == "divPendingOnHoldPercentage") ? "8" : (EleID == "divTatExceededPercentage") ? "9" :


            var tblRequest = (CProcess !== '100') ? (' <table class="table scroll table-bordered"> <thead> <tr> <th scope="col" >Req. #</th><th scope="col" style="width:70px;"> Notes </th>' + ((CProcess !== '9') ? '<th scope="col" style="width: 80;">Booked<br /> On</th>' : '<th scope="col" style="width: 80;">Start<br /> Date</th><th scope="col" style="width: 80;">Current<br /> Day</th><th scope="col" style="width: 80;">End<br /> Date</th>') + ((CProcess !== "9") ? '<th scope="col">Req.<br /> Time</th> ' : '') + // + ((CProcess == "6" || CProcess == "7" || CProcess == "9") ? '<th scope="col" style="width:70px;"> Notes </th>' : '')
                ((CProcess == "2" || CProcess == "8") ? "" : ((CProcess == "3") ? '<th scope="col">Porter(s)</th> <th scope="col">Assigned <br />  Time</th>' : (CProcess == "4") ? '<th scope="col">Porter(s)</th> <th scope="col">Assigned <br />  Time</th><th scope="col">Started<br /> At</th>' :
                    (CProcess == "6" || CProcess == "9") ? ((CProcess !== "9") ? '<th scope="col">Porter(s)</th> <th scope="col">Assigned <br />  Time</th>' : '') + '<th scope="col">Started<br /> At</th><th scope="col">Completed<br /> At</th>' + ((CProcess == "9") ? '<th scope="col">Next <br/> Routine </th>' : '') + '<th scope="col">TAT<br /> (Start to End)</th><th scope="col">TAT<br /> (Request to End)</th>' : (CProcess == "7") ? '<th scope="col">Porter(s)</th>' : ''))
                + '<th scope="col">' + ((ServiceCode == '2') ? 'From <br/> (Kitchen)' : (ServiceCode == '3') ? 'Request Location' : 'From') + '</th>' + ((ServiceCode == '3') ? '<th scope="col">Zone Name</th>' : '<th scope="col">To</th>') + '<th scope="col">Category</th>' + ((ServiceCode == '2') ? '<th scope="col">Quantity</th>' : '') + ((CProcess !== '9') ? ('<th scope="col"> ' + ((ServiceCode == '2' || ServiceCode == '3') ? "Roles" : "Skills") + '<br/> required</th>') : '') + ((ServiceCode !== '2') ? ((ServiceCode == '3') ? ((CProcess == "9") ? '<th scope="col"  style="width:80px;">Authorizer <br /> Name</th>' : '') : ('<th scope="col"  style="width:80px;">Patient <br /> Name</th> <th scope="col">Two <br/> Porters</th>')) : '') + ((CProcess == "0" || CProcess == "9") ? '<th scope="col">Status</th>' : '') + '<th scope="col">Requested By</th><th scope="col">Entered By</th><th scope="col">' + ((CProcess == "8") ? "On-Hold <br/>" : "") + 'Remarks </th>' +
                ((CProcess == "2" || CProcess == "3" || CProcess == "4") ? ('<th scope="col">Reassign</th>') : '') +
                ((CProcess == "3" || CProcess == "4" || CProcess == "5") ? ('<th scope="col">Locate</th>') : '') + ((CProcess == "2") ? '<th scope="col">Priority</th>' : '') +

                ((CProcess !== "7" && CProcess !== "6") ? ((CProcess !== "9") ? '<th scope="col" style="width: 100;">' + ((CProcess == "8") ? "Release" : "OnHold") + '</th>' : '') + (((CProcess == "3" || CProcess == "4" || CProcess == "9") && (CanStartEnd == '1')) ? ('<th scope="col"  style="width: 100;">' + ((CProcess == "3") ? 'Start <br /> Task' : 'Complete <br /> Task') + '</th>') : '') + ((CanCancel == "1") ? '<th scope="col">Cancel</th>' : '') : '') +
                ((CProcess == "7") ? ('<th scope="col" >Cancel <br /> Remarks </th><th scope="col">Cancelled <br /> At </th>') : "") + ((CProcess == "6") ? '<th scope="col">KPI <br/> met</th>' : ((CProcess == "3" || CProcess == "4" || CProcess == "2") ? ((CProcess == "2" || CProcess == "3") ? '<th scope="col">KPI <br/> (Response) </th><th scope="col">KPI <br/> (Completion) </th>' : '<th scope="col">KPI <br/> (Completion) </th>') : '')) + ((CProcess !== "7" && CProcess !== "2" && CProcess !== "3" && CProcess !== "8" && CProcess !== "9") ? ' <th scope="col">Porter <br/> Remarks</th>' : '')
                + ((duplicateOption) ? '<th scope="col">Duplicate</th>' : '') + '<th scope="col" style="width: 50;">Log</th> </tr ></thead > <tbody>') // <th scope="col">Has <br/> Return  Call</th><th scope="col">Reassign</th> <th scope="col">Buzzer</th><<th scope="col">Start</th><th scope="col">Finish</th>
                : (' <table class="table scroll table-bordered"> <thead> <tr> <th scope="col" >Req. #</th><th scope="col" style="width: 80;">Booked<br /> On</th><th scope="col">Req. Time</th><th scope="col">From' + ((ServiceCode == '2') ? '<br/> (Kitchen)' : '') + '</th>' + ((ServiceCode !== '3') ? '<th scope="col">To</th>' : '') + '<th scope="col">Category</th>' + ((ServiceCode == '2') ? '<th scope="col">Quantity</th>' : '') + '<th scope="col">' + ((ServiceCode == '2') ? "Roles" : "Skills") + '<br/> required</th>' + ((ServiceCode !== '2' & ServiceCode !== '3' ) ? '<th scope="col">Patient Name</th><th scope="col">Two <br/> Porters</th>' : '') + '<th scope="col">Requested By</th><th scope="col">Entered By</th><th scope="col">Remarks</th>' + ((CanCancel == "1") ? '<th scope="col">Cancel</th>' : '') + '</tr ></thead > <tbody>');

            tblContent = '';

            //setEditTask(ReqID, From, To, CategoryID, RequestStatus, StatusID, PatientName, Remarks, CompletedRemarks, CancelledRemarks)

            if (data.length > 0) {

                var vic = data[0].VIC; InitPagination(vic, (pageIndex + 1));
                $.each(data, function (key, value) {

                    var PName = ((!value.PORTERNAME) ? "" : value.PORTERNAME.replace("<br/>", ",").toString()), PorterID = ((!value.PORTERID) ? "" : value.PORTERID.toString()), RequestID = ((!value.REQUESTID) ? "" : value.REQUESTID.toString()),
                        PorterID1 = ((!value.SUBPORTERID) ? "" : value.SUBPORTERID.toString()), Priority = ((!value.PRIORITY) ? "" : value.PRIORITY.toString()), CatID = ((!value.CATEGORYID) ? "" : value.CATEGORYID.toString()),
                        FromID = ((!value.REQUESTLOCATIONID) ? "" : value.REQUESTLOCATIONID.toString()), ToID = ((!value.DESTINATIONLOCATIONID) ? "" : value.DESTINATIONLOCATIONID.toString()), ContactNo = ((!value.CONTACTNO) ? "" : value.CONTACTNO.toString()),
                        ComRemarks = ((!value.COMPLETEDREMARKS) ? "" : value.COMPLETEDREMARKS.toString()), CanRemarks = ((!value.REMARKS) ? "" : value.REMARKS.toString()), PorterRemarks = ((!value.PORTERREMARKS) ? "" : value.PORTERREMARKS.toString()),
                        RStatus = ((!value.REQUESTSTATUSID) ? "" : value.REQUESTSTATUSID.toString()), RequestID = ((!value.REQUESTID) ? "" : value.REQUESTID.toString()), ReqNB = ((!value.REQUESTNO) ? "" : value.REQUESTNO.toString()),
                        MultiPorter = ((!value.ISMULTIPORTER) ? "" : value.ISMULTIPORTER.toString()), IsReturnRequired = ((!value.ISRETURNREQUIRED) ? "" : value.ISRETURNREQUIRED.toString()), IsReturn = ((!value.RETURNREQUESTOF) ? "" : value.RETURNREQUESTOF.toString()),
                        TatExceeded = ((!value.TATEXCEEDED) ? "" : value.TATEXCEEDED.toString()), DeviceID = ((!value.DEVICEID) ? "" : value.DEVICEID.toString()),
                        PatientName = ((!value.PATIENTNAME) ? "" : value.PATIENTNAME.replace("<br/>", ",").toString()),
                        MUIndex = ((!value.MULTITASKINDEX) ? "" : value.MULTITASKINDEX.toString()),
                        RQuantity = ((!value.quantity) ? "" : value.quantity.toString()),
                        IsQuantity = ((!value.ISQUANTITY) ? "" : value.ISQUANTITY.toString()),
                        logRemarks = ((!value.LOG) ? "" : value.LOG.toString()),
                        TE = ((!value.TE) ? "" : value.TE.toString()),
                        TS = ((!value.TS) ? "" : value.TS.toString()),

                        OhHoldRemarks = ((!value.ONHOLDREMARKS) ? "" : value.ONHOLDREMARKS.replace("<br/>", ",").toString()),

                        bookedAt = ((!value.BOOKEDAT) ? "" : value.BOOKEDAT.replace("<br/>", ",").toString()),

                        LoginName = ((!value.REQUESTORNAME) ? "" : value.REQUESTORNAME.replace("<br/>", ",").toString()),
                        Kitchen = ((!value.KITCHEN) ? "" : value.KITCHEN.replace("<br/>", ",").toString()),

                        RequestorName = ((!value.REQUESTOR) ? "" : value.REQUESTOR.replace("<br/>", ",").toString()),

                        RoleName = ((!value.ROLE) ? "" : value.ROLE.replace("<br/>", ",").toString()),

                        RReqDate = ((!value.REQUESTDATE) ? "" : value.REQUESTDATE.replace("<br/>", ",").toString()),
                        RReqTime = ((!value.REQUESTTIME) ? "" : value.REQUESTTIME.replace("<br/>", ",").toString()),

                        StartDate = ((!value.STARTDATE) ? "" : value.STARTDATE.replace("<br/>", ",").toString()),

                        CurDay = ((!value.CURRENTDAY) ? "" : value.CURRENTDAY.toString().replace("<br/>", ",").toString()),

                        EndDate = ((!value.ENDDATE) ? "" : value.ENDDATE.replace("<br/>", ",").toString()),

                        AuthorizerName = ((!value.AUTHORISER) ? "" : value.AUTHORISER.replace("<br/>", ",").toString()),

                        NextRoutine = ((!value.NEXTROUTINE) ? "" : value.NEXTROUTINE.replace("<br/>", ",").toString()),

                        From = ((!value.FROM) ? "" : value.FROM.replace("<br/>", ",").toString()),
                        ServiceID = ((!value.SERVICEID) ? "1" : value.SERVICEID.toString()),
                        To = ((!value.TO) ? "" : value.TO.replace("<br/>", ",").toString()),
                        ResponseKPI = ((!value.RESPONSEKPI) ? "" : value.RESPONSEKPI.toString()).split('_'),
                        CompletionKPI = ((!value.COMPLETIONKPI) ? "" : value.COMPLETIONKPI.toString()).split('_'),
                        CategoryName = ((!value.CATEGORYNAME) ? "" : value.CATEGORYNAME.replace("<br/>", ",").toString());

                    /*if (ServiceID == '2')*/
                    From = (ServiceID == '2') ? Kitchen : From;

                    var IsResponseKPIMet = ResponseKPI[0].toString(), KPISecondsLeft = ResponseKPI[1].toString(),
                        IsCompletionKPIMet = CompletionKPI[0].toString(), CompletionKPISecondsLeft = CompletionKPI[1].toString();

                    var ReqDateTime = RReqDate + ' ' + RReqTime;

                    var ReqIndex = (MUIndex % 5), ResponseHHMMSS = getHHMMSS(KPISecondsLeft), CompletionHHMMSS = getHHMMSS(CompletionKPISecondsLeft);
                    var bgColor = 'white';// (MUIndex !== 0 && MUIndex !== "") ? ((ReqIndex == 1) ? '#45c3ff61' : (ReqIndex == 2) ? '#ffff004f' : (ReqIndex == 3) ? '#119d0047' : (ReqIndex == 4) ? '#9d005e47' : '#001b9d40') : 'white';

                    var OnholdProcess = ((CProcess == "8" || RStatus == "8") ? "RELEASE" : "SET"), OnHoldModal = ((CProcess == "8" || RStatus == "8") ? "ModalOnHoldRelease" : "ModalOnHold");

                    var SCProcess = ((CProcess == "3" || RStatus == "3") ? "START" : "COMPLETE"), OnSCModal = ((CProcess == "3" || RStatus == "3") ? "ModalStart" : "ModalComplete");

                    var KPImet = ((RStatus == '6' || RStatus == '9') ? TatExceeded : '-');
                    var responseFlag = ((IsResponseKPIMet == 'YES') && KPISecondsLeft == '0') ? '-' : ('<span class="CounterItems" style="background-color:' + ((IsResponseKPIMet == 'NO') ? 'red' : ((IsResponseKPIMet == 'CLOSE') ? 'orange' : 'green')) + '"> ' + ResponseHHMMSS + ' </span>'); // '<img src="../images/' + ((IsResponseKPIMet == 'NO') ? 'Red_flag' : ((IsResponseKPIMet == 'CLOSE') ? 'Orange_flag' : 'Green_flag')) + '.png" style="width:25px;"  />' +
                    var CompletionFlag = ((IsCompletionKPIMet == 'YES') && CompletionKPISecondsLeft == '0') ? '-' : ('<span class="CounterItems" style="background-color:' + ((IsCompletionKPIMet == 'NO') ? 'red' : ((IsCompletionKPIMet == 'CLOSE') ? 'orange' : 'green')) + '"> ' + CompletionHHMMSS + ' </span>');

                    tblContent +=
                        (CProcess !== '100') ? (' <tr style=' + '"background-color:' + ((KPImet == 'YES') ? '#fce4ec' : bgColor) + ';"' + '  ><td>  <div class="add-task-link" onclick="setEditTask(' + "'" + RequestID + "','" + RequestID + "','" + FromID + "','" + ToID + "','" + CatID + "','" + value.REQUESTSTATUS + "','" + RStatus + "','" + ((CProcess !== "9") ? PatientName : AuthorizerName) + "','" + value.REQUESTDESKREMARKS + "','" + ComRemarks + "','" + CanRemarks + "','" + MultiPorter + "','" + IsReturnRequired + "','" + IsReturn + "','" + MUIndex + "','" + RQuantity + "','" + RequestorName + "','" + From + "','" + To + "','" + CategoryName + "','" + PorterRemarks + "','" + ContactNo + "','" + IsQuantity + "','" + TS + "','" + TE + "','" + LoginName + "','NORMAL','" + ReqDateTime + "','" + ServiceID + "','" + Kitchen + "','" + AuthorizerName + "'" + ');"> <a href="javascript:void(0)" class="btn btn-indexblue">'
                            + RequestID + ' </a> </div> </td><td style="text-decoration: underline;font-weight: bold;font-size: 15px;color:' + ((ComRemarks.length > 0) ? "red" : "#2e70f5") + ';cursor:pointer;" onclick="getCompleteLogs(' + "'" + RequestID + "','" + CProcess + "'" + ');"> <img src="../images/memo.png" alt="Notes" /> Notes</td>' + ((CProcess !== '9') ? ('<td>' + bookedAt + '</td><td>' + value.REQUESTTIME + '</td>') : ('<td>' + StartDate + '</td><td>' + CurDay + '</td><td>' + EndDate + '</td>')) + //'<td>' + value.REQUESTTIME + '</td>' + // ((CProcess == "6" || CProcess == "7" || CProcess == "9") ? '<td style="text-decoration: underline;font-weight: bold;font-size: 15px;color:' + ((ComRemarks.length > 0) ? "red" : "#2e70f5") + ';cursor:pointer;" onclick="openCompleteNotes(' + "'" + ComRemarks + "','" + RequestID + "'" + ');"> <img src="../images/memo.png" alt="Notes" /> Notes</td>' : '')
                            ((CProcess == "2" || CProcess == "8") ? "" : ((CProcess == "3") ? '<td>' + value.PORTERNAME + '</td><td>' + value.ASSIGNEDTIME + '</td>' : (CProcess == "4") ? '<td>' + value.PORTERNAME + '</td><td>' + value.ASSIGNEDTIME + '</td><td>' + value.STARTTIME + '</td>' : (CProcess == "6" || CProcess == "9") ? ((CProcess !== "9") ? '<td>' + value.PORTERNAME + '</td><td>' + value.ASSIGNEDTIME + '</td>' : '') + '<td>' + value.STARTTIME + '</td><td>' + value.ENDTIME + '</td>' + ((CProcess == "9") ? '<td>' + NextRoutine + '</td>' : '') + '<td>' + value.TAT + '</td><td>' + value.TTAT + '</td>' : (CProcess == "7") ? '<td>' + value.PORTERNAME + '</td>' : ''))
                            + '<td>' + From + '</td>' + ((ServiceCode == '3') ? '<td>' + value.KITCHEN + ' </td>' : ('<td>' + value.TO + ' </td>')) + '<td>' + value.CATEGORYNAME + ' </td>' + ((ServiceCode == '2') ? '<td>' + RQuantity + ' </td>' : '') + ((CProcess !== '9') ? ('<td>' + RoleName + '</td>') : '') + ((ServiceCode !== '2') ? ((ServiceCode == '3') ? ((CProcess == "9") ? ('<td>' + AuthorizerName + '</td>') : '') : ('<td>' + PatientName + '</td> <td>' + MultiPorter + '</td>')) : '') + (((CProcess == "0" || CProcess == "9")) ? '<td>' + value.REQUESTSTATUS + '</td>' : '') + '<td>' + RequestorName + '</td><td>' + LoginName + '</td><td>' + ((CProcess == "8") ? OhHoldRemarks : value.REQUESTDESKREMARKS) + '</td>' +
                            ((CProcess == "2" || CProcess == "3" || CProcess == "4") ? '<td> <img src="../images/Add.png" onclick="AddTask(' + "'" + PName + "','" + PorterID + "','" + RStatus + "'" + ');" class="imgIcons" /> </td>' : '') +

                            ((CProcess !== "7" && CProcess !== "6") ? ((((CProcess == "3" || CProcess == "4" || CProcess == "5") && PorterID !== "") ? '<td> <img src="../images/Locate.png" onclick="LocatePorter(' + "'" + PorterID + "','" + PorterID1 + "','" + PName + "','" + DeviceID + "'" + ');" class="imgIcons" /> </td>' : '')

                                //((CProcess !== "2") ? '<td> ' + ((PorterID !== "") ?  : '-') + '</td>' : '')

                                + ((CProcess == "2") ? ('<td> <img src="../images/' + ((Priority == "Yes") ? "Emg" : "NoEmg") + '.png"  onclick = "setPriority(' + "'" + ((Priority == "Yes") ? "RELEASE" : "SET") + "', '" + CatID + "','" + RequestID + "'" + ');" class="imgIcons" /></td>') : "") +
                                ((CProcess !== "9") ? ("<td>" + (((RStatus != "6" && RStatus != "7")) ? ((PRID !== "7") ? ('<img src="../images/' + ((CProcess == "8" || RStatus == "8") ? "Play.png" : "onhold.png") + '" class="imgIcons" onclick = "InitOnHold(' + "'" + RequestID + "','" + RequestID + "','" + PorterID + '_' + PorterID1 + "','" + OnHoldModal + "','" + OnholdProcess + "','" + MUIndex + "');" + '" />') : "-") : "") + '</td>') : "") +
                                (((CProcess == "3" || CProcess == "4" || CProcess == "9") && (CanStartEnd == '1')) ? '<td> ' + ((CProcess !== "9" || RStatus == "12") ? '<img src="../images/' + ((CProcess == "3") ? "StartTask" : "CompleteTask") + '.png" onclick = "InitStartComplete(' + "'" + RequestID + "','" + RequestID + "','" + OnSCModal + "','" + SCProcess + "','" + MUIndex + "','" + CatID + "');" + '" class="imgIcons" /> </td>' : '') : '') +

                                ((CanCancel == "1") ? ("<td>" + (((RStatus != "6" && RStatus != "7" && CProcess !== '9') || (RStatus == "12" && CProcess == '9')) ? ('<img src="../images/close.png" class="imgIcons" onclick = "InitCancel(' + "'" + RequestID + "','" + RequestID + "', 'ModalCancel','" + MUIndex + "','" + CatID + "','" + RStatus + "');" + '" />') : "") + '</td>') : "")) : ((CProcess == "7") ? '<td style="word-wrap: break-word !important;max-width: 250px;max-height: 60px !important;overflow: hidden !important;text-overflow: ellipsis;display:inline-block;border:none;">' + value.REMARKS + '</td><td>' + value.CANCELLEDAT + '</td> ' : ""))
                            + ((CProcess == "6") ? '<td>' + KPImet + '</td>' : ((CProcess == "3" || CProcess == "4" || CProcess == "2") ? ((CProcess == "2" || CProcess == "3") ? '<td>' + responseFlag + '</td><td>' + CompletionFlag + '</td>' : '<td>' + CompletionFlag + '</td>') : ''))
                            + ((CProcess !== "7" && CProcess !== "2" && CProcess !== "3" && CProcess !== "8" && CProcess !== "9") ? ('<td>' + value.PORTERREMARKS + '</td>') : '') + ((duplicateOption) ? '<td> <img src="../images/Duplicate.png" class="imgIcons" onclick = "RaiseDuplicate(' + "'" + RequestID + "');" + '" /> </td>' : '') +
                            ('<td style="text-decoration: underline;font-weight: bold;font-size: 15px;color:' + ((logRemarks.length > 0) ? "red" : "#2e70f5") + ';cursor:pointer;" onclick="openReqLogs(' + "'" + RequestID + "'" + ');"> <img src="../images/Log.png" style="max-width: 50px !important;" class="imgIconsb" alt="Notes" /> </td>') + '</tr> ')// <td>' + ((IsReturnRequired == "1") ? "YES" : ((IsReturn.length > 0) ? '<img src="../images/SReturn.png" class="ReturnCalls" />' : "No")) + '</td><td>-</td><td>-</td><td>-</td><td>-</td>
                            : (' <tr><td>  <div class="add-task-link" onclick="setEditTask(' + "'" + RequestID + "','" + RequestID + "','" + FromID + "','" + ToID + "','" + CatID + "','" + value.REQUESTSTATUS + "','100','" + PatientName + "','" + value.REQUESTDESKREMARKS + "','" + ComRemarks + "','" + CanRemarks + "','" + MultiPorter + "','" + IsReturnRequired + "','" + IsReturn + "','" + MUIndex + "','" + RQuantity + "','" + RequestorName + "','" + From + "','" + To + "','" + CategoryName + "','" + PorterRemarks + "','" + ContactNo + "','" + IsQuantity + "','" + TS + "','" + TE + "','" + LoginName + "','PREBOOK','" + value.REQUESTDATE + "','" + ServiceID + "','" + Kitchen + "'" + ');"> <a href="javascript:void(0)" class="btn btn-indexblue">'
                                + value.REQUESTNO + ' </a> </div> </td><td>' + bookedAt + '</td><td>' + value.REQUESTDATE + '</td><td>' + From + '</td>' + ((ServiceCode == '3') ? '' : ('<td>' + value.TO + ' </td>')) + '<td>' + value.CATEGORYNAME + ' </td>' + ((ServiceCode == '2') ? '<td>' + RQuantity + ' </td>' : '') + '<td>' + RoleName + ' </td>' + ((ServiceCode !== '2') ? (((ServiceCode == '3') ? ((CProcess == "9") ? ('<td>' + AuthorizerName + '</td>') : '') : ('<td>' + PatientName + '</td>' + ('<td>' + MultiPorter + '</td>') )) ) : '') + '<td>' + RequestorName + '</td><td>' + LoginName + '</td><td>' + value.REQUESTDESKREMARKS + '</td>' +
                                ((CanCancel == "1") ? ('<td>' + ((RStatus != "2" && RStatus != "3") ? ('<img src="../images/close.png" class="imgIcons" onclick = "InitCancel(' + "'" + RequestID + "','" + RequestID + "', 'ModalCancel','" + MUIndex + "','" + RStatus + "');" + '" />') : "") + '</td>') : "") + '</tr> ');



                });

            }
            else
                setPagerEmpty();



            pagination();
            tblRequest += tblContent + '</tbody > </table > '; $(tblRequset).html(tblRequest);
        },
        error: function (data) {
            //alert(data);
        }

    });
}



function AssignTasks() {
    var UID = sessionStorage.getItem('ID');
    PorterCurTasks = (PorterCurTasks.substr(PorterCurTasks.length - 1) == "_") ? PorterCurTasks.substring(0, (PorterCurTasks.length - 1)) : PorterCurTasks;
    ATReqNB = (ATReqNB.substr(ATReqNB.length - 1) == ",") ? ATReqNB.substring(0, (ATReqNB.length - 1)) : ATReqNB;
    var ATTasks = ATReqNB.replace(/,/g, ", #"), IsMult = (ATReqNB.includes(',') ? ' have ' : ' has ');
    ATTasks = ATTasks.replace(/,([^,]*)$/, ' and ' + '$1');
    $('#' + ((ATPorterID.length > 0) ? 'spanMTTasks' : 'spanMTNTasks')).text("#" + ATTasks + IsMult);
    if (ATPorterID.length > 0) {
        $('#spanMTPorter').text(ATPorterName + ' ');
        $('#spanMTPorterNTasks').text(ATPorterName + ' ');
    }


    $.ajax({
        async: true,
        url: hurl + "Service/ServiceAddTask.aspx?Process=ASSIGNTASKS&PORTERID=" + encodeURIComponent(Encrypt(ATPorterID)) + "&REQUESTIDS=" + encodeURIComponent(Encrypt(PorterCurTasks)) + "&USERID=" + encodeURIComponent(Encrypt(UID)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            if (data[0].RESULT.split("_")[0] === 'TRUE') {

                var ModalDone = ((ATPorterID.length > 0) ? ((PorterCurTasks.length > 0) ? "ModalMTDone" : "successMTNoTask") : "successMTNoporter");

                var divProcess = ((ATPorterID.length > 0) ? ((PorterCurTasks.length > 0) ? "divAssignedPercentage" : "divPendingPercentage") : "divPendingPercentage");




                PorterCurTasks = ''; PendingTasks = ''; ATPorterID = ''; ATPorterName = ''; ATReqNB = '';
                ToUpdate = !ToUpdate; // ReloadLinks();
                Select(divProcess, "PENDING"); //CProcess = '3'; LoadGrid(CProcess);
                ShowModalPopUp(ModalDone);
                setTimeout(function () { HideModalPopUp('ModalAddTask'); }, 400);
                setTimeout(function () { HideModalPopUp(ModalDone); }, 3000);
                ATStatus = ''; clearMT();
                //GetMap();
            }
        },
        error: function (data) {

        }

    });

}


function RaiseDuplicate(ReqID) {
    AbortAllActiveRuquests();
    var UID = sessionStorage.getItem('ID');
    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=DUPLICATEREQUEST&REQUESTID=" + encodeURIComponent(Encrypt(ReqID)) + "&USERID=" + encodeURIComponent(Encrypt(UID)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT.split("_")[0] === 'TRUE') {
                var ReqNB = data[0].RESULT.split("_")[1];

                if ((RHalt1 == '0' && RHalt2 == '0'))
                    $('#LBLRequestResult').html('Request Raised Successfully.. Req No. #' + ReqNB);
                else
                    $('#LBLRequestResult').html('Request(s) Raised Successfully.. Req Nos. ' + ReqNB);

                HideModalPopUp('addTask'); ShowModalPopUp('modalReqAlert');
                setTimeout("HideModalPopUp('modalReqAlert');", 3500);
                HideModalPopUp('modalReqAlert');
                //ReloadLinks(); ReloadLinksButton();
                Select("divPendingPercentage", "PENDING"); setRequestUsers('Tasks');
            }
            else if (data[0].RESULT.split("_")[0] === 'FALSE') {
                $('#spanErrorMessage').html('A similar/same request has already been raised.');
                ShowModalPopUp('modalAlert'); setTimeout("HideModalPopUp('modalAlert');", 3500);

            }

        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}


function GetPorterTasks(PorterID) {
    var ContainerID1 = "gridPenTask"; PorterCurTasks = "", ATPorterID = PorterID;


    $.ajax({
        async: true,
        url: hurl + "Service/ServiceAddTask.aspx?Process=PENDINGTASKS&PORTERID=" + encodeURIComponent(Encrypt(PorterID)) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {


            var TablePending = "<table width='95%' class='table scroll table-bordered'' cellpadding='5' cellspacing='5' style='border-collapse: collapse;border: 1px solid gray;margin-top: 10px;'> <tr style='border: 1px solid gray;height:30px;'> " +
                "<td align='center'style='width:55px;vertical-align: middle;border: 1px solid gray;font-family: monospace;font-size: 16px;'> REQ NO.  </td> " +
                " <td align='left' style='max-width: 100px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;'> FROM " + ((ServiceCode == "2") ? "(Kitchen) " : "") + "</td>" +
                ((ServiceCode == "2") ? " <td align='left' style='max-width: 100px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;'> TO </td>" : "") +
                " <td align='left' style='max-width: 110px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;'> CATEGORY </td> " +
                ((ServiceCode !== "2") ? " <td align='left' style='max-width: 70px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;'> PATIENT NAME </td> " : "") +
                " <td align='left' style='max-width: 50px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;'> STATUS </td> " +
                " <td align='left' style='max-width: 50px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;'> CURRENT <br/> PORTER </td> " +
                " <td align='left' style='width:50px;border: 1px solid white;border-bottom: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;' > </td> </tr > ";



            $.each(data, function (key, value) {

                var ReqNB = value.REQNB, from = value.FROM, category = value.CATEGORY, statusID = value.STATUSID, ReqstID = value.REQUESTID, IPorterID = value.PORTERID, RPorterName = value.PORTERNAME, RPatientName = value.PATIENTNAME,
                    To = value.TO,
                    RStatus = (statusID == '2') ? 'Pending' : ((statusID == '3') ? 'Assigned' : 'In-Progress');



                switch (statusID) {
                    case 3:
                    case 4:
                        var OnClick = (statusID == 6) ? "onclick='return false;' " : " onclick='setCurTasks(" + '"' + ReqstID + '"' + ',"' + ReqstID + '"' + ");' "
                        if (IPorterID == PorterID) {
                            PorterCurTasks += ReqstID + "_";
                            ATReqNB += ReqstID + ",";
                        }
                        //PendingTasks += ReqstID + "_";
                        var checkedIcon = "<img id='CurTask" + ReqstID + "' src='../images/" + ((IPorterID == PorterID) ? "Check.png" : "UnCheck.png") + "' alt='Add'  height='20px' class='IconAddTask' " + OnClick + " style='cursor:pointer' />";

                        //var checkedIcon = "<img id='CurTask" + ReqstID + "' src='../images/UnCheck.png' alt='Add'  height='20px' class='IconAddTask' onclick='setCurTasks(" + '"' + ReqstID + '"' + ',"' + ReqstID + '"' + ");' style='cursor:pointer' />";
                        TablePending += "<tr style='border: 1px solid gray;height:25px;' > <td align='center'style='width:50px;vertical-align: middle;border: 1px solid gray;font-family: monospace;font-size: 14px;'> #" + ReqstID +
                            " </td>   <td align='left' style='max-width: 110px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;' > " + from +
                            ((ServiceCode == "2") ? ("</td>   <td align='left' style='max-width: 110px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;' > " + To) : "") +
                            " </td>   <td align='left' style='max-width: 100px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;' > " + category + "</td>" +
                            ((ServiceCode !== "2") ? " </td>   <td align='left' style='max-width: 70px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;' > " + RPatientName + "</td>" : "") +
                            " </td>   <td align='left' style='max-width: 50px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;' > " + RStatus + "</td>" +
                            " </td>   <td align='left' style='max-width: 50px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;' > " + RPorterName + "</td>" +
                            " <td align='left' style='width:50px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;' >" + checkedIcon + " </td> </tr > ";

                        break;
                    case 2:
                        PendingTasks += ReqstID + "_";
                        var UncheckedIcon = "<img id='CurTask" + ReqstID + "' src='../images/UnCheck.png' alt='Add'  height='20px' class='IconAddTask' onclick='setCurTasks(" + '"' + ReqstID + '"' + ',"' + ReqstID + '"' + ");' style='cursor:pointer' />";
                        TablePending += "<tr style='border: 1px solid gray;height:25px;' > <td align='center'style='width:50px;vertical-align: middle;border: 1px solid gray;font-family: monospace;font-size: 14px;'> #" + ReqstID +
                            " </td>   <td align='left' style='max-width: 110px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;' > " + from +
                            ((ServiceCode == "2") ? ("</td>   <td align='left' style='max-width: 110px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;' > " + To) : "") +
                            " </td>   <td align='left' style='max-width: 100px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;' > " + category + "</td>" +
                            ((ServiceCode !== "2") ? " </td>   <td align='left' style='max-width: 70px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;' > " + RPatientName + "</td>" : "") +
                            " </td>   <td align='left' style='max-width: 50px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;' > " + RStatus + "</td>" +
                            " </td>   <td align='left' style='max-width: 50px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;word-wrap: break-word;' > " + RPorterName + "</td>" +
                            " <td align='left' style='width:50px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;' >" + UncheckedIcon + " </td> </tr > ";
                        break;
                }

            });
            TablePending += "</table>";
            $('#' + ContainerID1 + '').html(TablePending);

            //$('#' + ContainerID).css('display', ((data.length > 0) ? 'block' : 'none'));


        },
        error: function (data) {

        }

    });

}
function InitCancel(RequestID, ReqNB, ModalPopup, MUIndex, CatID, RStatus) {
    document.getElementById('HFCancelReqID').value = RequestID; $('#canReqID').html(ReqNB);
    document.getElementById('HFCancelReqNB').value = ReqNB;
    document.getElementById('HFCancelMUIndex').value = MUIndex;
    document.getElementById('HFCancelCatID').value = CatID;
    $('#searchCR_CancelRemarks')[0].sumo.unSelectAll(); $('#searchCR_CancelRemarks')[0].sumo.reload(); $('#searchCR_CancelRemarks')[0].sumo.selectItem(0);
    $('#chkCancelOccurrence').prop('checked', false); //$('#switchOccurrence').prop('disabled', false);

    $('#divOccurrence').css("display", ((RStatus == "12") ? "inline-block" : "none"));
    ShowModalPopUp(ModalPopup);
    setTimeout(function () { $('#txtCancelReason').val(''); $('#txtCancelReason').focus(); }, 500);

}



function InitOnHold(RequestID, ReqNB, PorterID, ModalPopup, OnholdProcess, MUIndex) {


    document.getElementById('HFOnHoldReqID').value = RequestID;
    document.getElementById('HFOnHoldReqNB').value = ReqNB;
    document.getElementById('HFOnHoldMUIndex').value = MUIndex;
    switch (OnholdProcess) {
        case "SET":
            $('#OnHoldReqID').html(ReqNB);
            document.getElementById('HFOnHoldPorterID').value = PorterID;
            ShowModalPopUp(ModalPopup);
            setTimeout(function () { $('#txtOnHoldReason').val(''); $('#txtOnHoldReason').focus(); }, 500);
            break;
        case "RELEASE":
            $('#OnHoldReleaseReqID').html(ReqNB);
            ShowModalPopUp(ModalPopup);
            break;
    }

}


function OnHoldRequest() {
    var CReason = $('#txtOnHoldReason').val(), ReqID = $('#HFOnHoldReqID').val(), PoreterID = $('#HFOnHoldPorterID').val();
    var ReqNB = $('#HFOnHoldReqNB').val(), MUIndex = $('#HFOnHoldMUIndex').val(); $('#spanTaskOnHold').html(ReqNB);
    if (CReason.length > 0) {
        HideModalPopUp('ModalOnHold');
        ShowModalPopUp('ModalSuccessOnHold');
        OnHoldCurrentRequest(CReason, ReqID, PoreterID, MUIndex);
    }
    else
        $('#TxtCancelReason').focus();
}


function InitStartComplete(RequestID, ReqNB, ModalPopup, Process, MUIndex, CatID) {

    document.getElementById('HFSCReqID').value = RequestID;
    document.getElementById('HFSCReqNB').value = ReqNB;
    document.getElementById('HFSCMUIndex').value = MUIndex;
    document.getElementById('HFCatID').value = CatID;
    switch (Process) {
        case "START":
            $('#StartReqID').html(ReqNB);
            ShowModalPopUp(ModalPopup);
            setTimeout(function () { $('#txtStartReason').val(''); $('#txtStartReason').focus(); }, 500);
            break;
        case "COMPLETE":
            $('#CompleteReqID').html(ReqNB);
            ShowModalPopUp(ModalPopup);
            setTimeout(function () { $('#txtCompleteReason').val(''); $('#txtCompleteReason').focus(); }, 500);
            ShowModalPopUp(ModalPopup);
            break;
    }

}

function StartRequest() {

    var CReason = $('#txtStartReason').val(), ReqID = $('#HFSCReqID').val();
    var ReqNB = $('#HFSCReqNB').val(), MUIndex = $('#HFSCMUIndex').val(); $('#spanTaskStart').html(ReqNB);
    //if (CReason.length > 0) {
    HideModalPopUp('ModalStart');
    ShowModalPopUp('ModalSuccessStart');
    StartCurrentRequest(CReason, ReqID, MUIndex);
    //}
    //else
    //    $('#txtStartReason').focus();
}


function StartCurrentRequest(CReason, ReqID, MUIndex) {
    AbortAllActiveRuquests();
    var UID = sessionStorage.getItem('ID');
    $.ajax({
        url: hurl + "Service/ServiceRequest.aspx?Process=STARTTASK&REQUESTID=" + encodeURIComponent(Encrypt(ReqID)) + "&REASON=" + encodeURIComponent(Encrypt(CReason)) + "&MIINDEX=" + encodeURIComponent(Encrypt(MUIndex)) + "&USERID=" + encodeURIComponent(Encrypt(UID)),
        type: 'POST',
        data: 'pData',
        async: true,
        dataType: 'json',
        success: function (data) {

            setTimeout(function () { HideModalPopUp('ModalSuccessStart'); }, 700);

            Select("divInprogressPercentage", "INPROGRESS");
        },
        error: function (data) {

        }

    });
    //setTimeout(function () { ReloadLinksButton(); }, 500);
}


function CompleteRequest() {

    var CReason = $('#txtCompleteReason').val(), ReqID = $('#HFSCReqID').val(), CatID = $('#HFCatID').val();
    var ReqNB = $('#HFSCReqNB').val(), MUIndex = $('#HFSCMUIndex').val(); $('#spanTaskComplete').html(ReqNB);
    //if (CReason.length > 0) {
    HideModalPopUp('ModalComplete');
    ShowModalPopUp('ModalSuccessComplete');
    CompleteCurrentRequest(CReason, ReqID, MUIndex, CatID);
    //}
    //else
    //    $('#txtCompleteReason').focus();
}



function CompleteCurrentRequest(CReason, ReqID, MUIndex, CatID) {
    AbortAllActiveRuquests();
    var UID = sessionStorage.getItem('ID');
    $.ajax({
        url: hurl + "Service/ServiceRequest.aspx?Process=COMPLETETASK&REQUESTID=" + encodeURIComponent(Encrypt(ReqID)) + "&REASON=" + encodeURIComponent(Encrypt(CReason)) + "&MIINDEX=" + encodeURIComponent(Encrypt(MUIndex)) + "&USERID=" + encodeURIComponent(Encrypt(UID)),
        type: 'POST',
        data: 'pData',
        async: true,
        dataType: 'json',
        success: function (data) {

            setTimeout(function () { HideModalPopUp('ModalSuccessComplete'); }, 700);
            if (CatID !== '73')
                Select("divCompletedPercentage", "COMPLETED");
            else
                Select("divBarrierPercentage", "Barrier")
        },
        error: function (data) {

        }

    });
    //setTimeout(function () { ReloadLinksButton(); }, 500);
}

function ReleaseOnHoldRequest() {
    AbortAllActiveRuquests();
    var ReqID = $('#HFOnHoldReqID').val();
    var ReqNB = $('#HFOnHoldReqNB').val(); $('#spanReleaseTaskOnHold').html(ReqNB);

    HideModalPopUp('ModalOnHoldRelease');
    ShowModalPopUp('ModalReleaseSuccessOnHold');

    var UID = sessionStorage.getItem('ID'), GMIndex = 0;
    $.ajax({
        url: hurl + "Service/Service.aspx?Process=RESUMEONHOLDTASK&USERID=" + UID + "&REQUESTID=" + ReqID,
        type: 'POST',
        data: 'pData',
        async: true,
        dataType: 'json',
        success: function (data) {

            setTimeout(function () { HideModalPopUp('ModalReleaseSuccessOnHold'); }, 1000);

            Select("divPendingPercentage", "PENDING");
            //LoadProcess(((CProcess == "10") ? "0" : CProcess));

        },
        error: function (data) {

        }

    });
    //setTimeout(function () { ReloadLinksButton(); }, 500)
}

function OnHoldCurrentRequest(Reason, ReqID, PoreterID, MUIndex) {
    AbortAllActiveRuquests();
    var UID = sessionStorage.getItem('ID'), GMIndex = MUIndex;
    $.ajax({
        url: hurl + "Service/Service.aspx?Process=ONHOLDTASK&REASON=" + Reason + "&USERID=" + UID + "&REQUESTID=" + ReqID + "&PORTERIDS=" + PoreterID + "&MIINDEX=" + GMIndex,
        type: 'POST',
        data: 'pData',
        async: true,
        dataType: 'json',
        success: function (data) {

            setTimeout(function () { HideModalPopUp('ModalSuccessOnHold'); }, 700);

            Select("divPendingOnHoldPercentage", "ONHOLD");
            //LoadProcess(((CProcess == "10") ? "0" : CProcess));

        },
        error: function (data) {

        }

    });
    //setTimeout(function () { ReloadLinksButton(); }, 500);

}

function setCurTasks(RequestID, ReqNB) {

    var Img = $('#CurTask' + RequestID); var CurSrc = $(Img).attr('src'); var NewSrc = ((CurSrc == "../images/Check.png") ? "../images/UnCheck.png" : "../images/Check.png");

    if (CurSrc == "../images/Check.png") {
        PorterCurTasks = PorterCurTasks.replace(((PorterCurTasks.includes(RequestID + "_")) ? (RequestID + "_") : RequestID), "");
        ATReqNB = ATReqNB.replace(((ATReqNB.includes(ReqNB + ",")) ? (ReqNB + ",") : ReqNB), "");
    }
    else {
        PorterCurTasks += RequestID + "_";
        ATReqNB += ReqNB + ",";
    }

    $(Img).attr("src", NewSrc);
}
function setPriority(Priority, CategoryID, RequestID) {

    $.ajax({
        async: true,
        url: hurl + "Service/Service.aspx?Process=PRIORITY&REQUESTID=" + RequestID + "&Priority=" + Priority + "&CategoryID=" + CategoryID,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            LoadProcess(((CProcess == "10") ? "0" : CProcess));
        },
        error: function (data) {

        }

    });

}


function CancelRequest() {
    var drpCReason = selectedText('searchCR_CancelRemarks') //$('#searchCR_CancelRemarks option:selected').text();

    //alert(drpCReason);

    var CReason = drpCReason + '_' + $('#txtCancelReason').val(), ReqID = $('#HFCancelReqID').val(), CatID = $('#HFCancelCatID').val(), IsPreBook = ((CProcess == '100') ? 'YES' : 'NO');
    var ReqNB = $('#HFCancelReqNB').val(), MUIndex = $('#HFCancelMUIndex').val(); $('#spanTaskCnl').html(ReqNB);
    if (CReason.length > 0 && CReason !== '_') {
        HideModalPopUp('ModalCancel');
        ShowModalPopUp('ModalSuccessCancel');
        CancelCurrentRequest(CReason, ReqID, IsPreBook, MUIndex, CatID);
        //LoadPresetRemarks();
    }
    else
        $('#TxtCancelReason').focus();
}

function selectedText(drpSumo) {
    var valSel = '';
    $('#' + drpSumo + ' option:selected').each(function (i) {
        valSel += $(this).text() + ',';
    });


    return valSel.replace('-- Select --,', '').replace(/.$/, "");
}


function CancelCurrentRequest(Reason, ReqID, PreBook, MUIndex, CatID) {
    AbortAllActiveRuquests();
    var IsOccurrence = $('#chkCancelOccurrence').prop('checked');
    IsOccurrence = (IsOccurrence) ? "YES" : "NO";

    var UID = sessionStorage.getItem('ID'), GMIndex = MUIndex;
    HideModalPopUp('ModalFinish');
    $.ajax({
        url: hurl + "Service/Service.aspx?Process=CANCELTASK&REASON=" + Reason + "&USERID=" + UID + "&REQUESTID=" + ReqID + "&PREBOOK=" + PreBook + "&MIINDEX=" + GMIndex + "&OCCURRENCE=" + GMIndex,
        type: 'POST',
        data: 'pData',
        async: true,
        dataType: 'json',
        success: function (data) {

            setTimeout(function () { /*LoadCancelRemarks(data);*/ HideModalPopUp('ModalSuccessCancel'); }, 700);

            if (CatID !== '73') {
                if (CProcess == "100")
                    Select("divPrebookeddPercentage", "PREBOOKED");
                else
                    Select("divCancelledPercentage", "CANCELLED");
            }
            else
                Select("divBarrierPercentage", "Barrier")

            //LoadProcess(((CProcess == "10") ? "0" : CProcess));

        },
        error: function (data) {

        }

    });
    //setTimeout(function () { ReloadLinksButton(); }, 500);

}
function LocatePorter(PorterID, PorterID1, PName, DeviceID) {

    //window.open('../Track/PopupRequest.aspx?TagId=Porter=' + PorterID + ((PorterID1.length > 0) ? ',' + PorterID1 : '') + "&Name=" + PName, 'TRACKING : #' + PName, 'directories=no,titlebar=yes,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=1100,height=700');

    var PorterName = PName.toUpperCase().replace("&", " and ");
    window.open('../Track/Popup.aspx?TagId=' + DeviceID + "&Name=" + PorterName, 'TRACKING : #' + PorterName, 'directories=no,titlebar=yes,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=1050,height=760');

    //$('#MapPorterNmae').html(PName);
    //clearInterval(Reload);
    //ReloadMap = window.setInterval(function () { GetMapDetails(DeviceID); }, 1000);
    //ShowModalPopUp('floor-map-popup');
}


function GetMapDetails(PorterID) {

    $.ajax({
        async: true,
        url: hurl + "Service/LocationInfo.aspx?Process=GETPORTERLOCINFO&PORTERID=" + PorterID,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data.length > 0) {
                $('#PorterMap').attr("src", data[0].MAP);
                $('#MapCurLocation').html(data[0].LOCATION);

            }

        },
        error: function (data) {

        }

    });

}

function GetImage() {
    SetPorterDetails();
    $.ajax({
        async: true,
        url: hurl + "Locate.aspx?TagId=" + TTID + "&CurrentTime=" + daten,
        type: 'POST',
        data: 'pData',
        dataType: 'xml',
        success: function (data) {
            var Img = $(data).find("IMAGE").text();
            if (Img.length > 0)
                $('#tdPorter').css("background-image", "URL('" + Img + "')");
        },
        error: function (data) {
        }

    });
}

function LoadGrid(Process, grid) {
    var UID = sessionStorage.getItem('ID'), PRID = sessionStorage.getItem('ROLE');
    var FinalUrl = hurl + "Service/Service.aspx?Process=GET&Status=" + Process + "&Search=" + (((Process == 3) || (Process == 4) || (Process == 5) || (Process == 6)) ? $('#txtSearch').val() : "") + "&USERID=" + UID + "&PageIndex=" + pageIndex + "&PageSize=" + pageSize + "&ROLE=" + PRID;
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
            }
        },
        error: function (data) {

        }

    });
}



function updateVirtualItemCount(result, tableView) {
    tableView.set_virtualItemCount(result);
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

function LoaderOn() {
    $('.loaderElement').css("display", "inline-block");
}


function LoaderOff(Interval) {
    setTimeout(function () {
        $('.loaderElement').css("display", "none");
    }, Interval);
}

function ShowModalAddtask() {
    $('#addTask').modal({
        backdrop: 'static',
        keyboard: false
    })
    $('#addTask').modal('show');
}

function ShowModalPopUp(ModalId) {
    $('#' + ModalId).modal('show');
}
function HideModalPopUp(ModalId) {
    $('#' + ModalId).modal('hide');
}


function GetBarearEndDate() {

    var date = new Date(); date.setDate(date.getDate() + 28);

    var y = date.getFullYear(), m = (date.getMonth() + 1).toString(), d = date.getDate().toString();

    m = (m.length == 1) ? ('0' + m.toString()) : m.toString(); d = (d.length == 1) ? ('0' + d.toString()) : d.toString();

    //alert(d + '/' + m + '/' + y);
    return d + '/' + m + '/' + y;
}