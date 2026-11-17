/*-------------- Request Count Updation------------------*/

function RestartTimer() {
    IntervalCount = window.setInterval(IntervalCountfn, 60000);
}

function IntervalCountfn(FromReady) {
    var UID = sessionStorage.getItem('ID'), ROLE = sessionStorage.getItem('ROLE');
    $.ajax({
        async: true,
        url: Homeurl + "Service.aspx?Process=GETCOUNT&USERID=" + UID + "&ROLE=" + ROLE,
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
                //var docMov = data[1].DOCMOVEMENT, OtherMov = data[1].OTHERMOVEMENT, TotalPorter = data[1].TOTALPORTER;
                var AvailPorter = data[1].AVAILABLEPORTER, TotalPorter = data[1].TOTALPORTER;
                $('#PorterCountTotal').text((TotalPorter == null) ? '00' : (TotalPorter.toString().length == 1) ? '0' + TotalPorter.toString() : TotalPorter.toString());
                $('#PorterCountSampleMov').text((AvailPorter == null) ? '00' : (AvailPorter.toString().length == 1) ? '0' + AvailPorter.toString() : AvailPorter.toString());
                // $('#PorterCountOtherMov').text((OtherMov == null) ? '00' : (OtherMov.toString().length == 1) ? '0' + OtherMov.toString() : OtherMov.toString());
            } else {
                $('#PorterCountSampleMov').text("00");
                $('#PorterCountOtherMov').text("00");
                // $('#PorterCountTotal').text("00");
            }
            if (FromReady)
                HideModalPopUp('ModalLoading');
        },
        error: function (data) {

        }
    });
}

function Open(RedirectUrl, TreeID, ImageUrl, Name) {
    var RUrl = RedirectUrl.split('_')[0], ChildName = RedirectUrl.split('_')[1];
    sessionStorage.setItem('CURRENTSUBMENU', ChildName);
    sessionStorage.setItem('PMENUID', TreeID);
    sessionStorage.setItem('PNAME', Name);
    sessionStorage.setItem('PIMAGESRC', ImageUrl);
    window.radopen(RUrl, "BaseBageWindow");
    return false;
}

function ShowTime() {
    var d = new Date();
    var weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    var weekday = weekdays[d.getDay()];
    var Monthname = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    var month = Monthname[d.getMonth()];
    var year = d.getFullYear();
    var hour = d.getHours();
    var ampm = hour >= 12 ? "PM" : "AM";
    hour = hour % 12;
    hour = hour ? hour : 12;
    hour = hour > 9 ? hour : "0" + hour;

    var minute = d.getMinutes();
    minute = minute > 9 ? minute : "0" + minute;
    var seconds = d.getSeconds();
    seconds = seconds > 9 ? seconds : "0" + seconds;
    var format = weekday + ", " + month + " " + d.getDate() + ", " + year + ", " + hour + ":" + minute + ":" + seconds + " " + ampm;

    document.getElementById("spanTime").innerHTML = format;   //  dt.toLocaleTimeString();
    window.setTimeout("ShowTime()", 1000); // Here 1000(milliseconds) means one 1 Sec  
}

function SelectRequest(eleId) {
    sessionStorage.setItem('RequestPageFn', eleId);
    sessionStorage.setItem('FromHome', 'true');
    window.location = '../RequestNew/Request.aspx';
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