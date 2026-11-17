function ClosePassword() {
    HideModalPopUp('ModalDone');
    HideModalPopUp('ModalChangePassword');
    window.location = "../Login.aspx";
}
var Base64 = { _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=", encode: function (e) { var t = ""; var n, r, i, s, o, u, a; var f = 0; e = Base64._utf8_encode(e); while (f < e.length) { n = e.charCodeAt(f++); r = e.charCodeAt(f++); i = e.charCodeAt(f++); s = n >> 2; o = (n & 3) << 4 | r >> 4; u = (r & 15) << 2 | i >> 6; a = i & 63; if (isNaN(r)) { u = a = 64 } else if (isNaN(i)) { a = 64 } t = t + this._keyStr.charAt(s) + this._keyStr.charAt(o) + this._keyStr.charAt(u) + this._keyStr.charAt(a) } return t }, decode: function (e) { var t = ""; var n, r, i; var s, o, u, a; var f = 0; e = e.replace(/[^A-Za-z0-9+/=]/g, ""); while (f < e.length) { s = this._keyStr.indexOf(e.charAt(f++)); o = this._keyStr.indexOf(e.charAt(f++)); u = this._keyStr.indexOf(e.charAt(f++)); a = this._keyStr.indexOf(e.charAt(f++)); n = s << 2 | o >> 4; r = (o & 15) << 4 | u >> 2; i = (u & 3) << 6 | a; t = t + String.fromCharCode(n); if (u != 64) { t = t + String.fromCharCode(r) } if (a != 64) { t = t + String.fromCharCode(i) } } t = Base64._utf8_decode(t); return t }, _utf8_encode: function (e) { e = e.replace(/rn/g, "n"); var t = ""; for (var n = 0; n < e.length; n++) { var r = e.charCodeAt(n); if (r < 128) { t += String.fromCharCode(r) } else if (r > 127 && r < 2048) { t += String.fromCharCode(r >> 6 | 192); t += String.fromCharCode(r & 63 | 128) } else { t += String.fromCharCode(r >> 12 | 224); t += String.fromCharCode(r >> 6 & 63 | 128); t += String.fromCharCode(r & 63 | 128) } } return t }, _utf8_decode: function (e) { var t = ""; var n = 0; var r = c1 = c2 = 0; while (n < e.length) { r = e.charCodeAt(n); if (r < 128) { t += String.fromCharCode(r); n++ } else if (r > 191 && r < 224) { c2 = e.charCodeAt(n + 1); t += String.fromCharCode((r & 31) << 6 | c2 & 63); n += 2 } else { c2 = e.charCodeAt(n + 1); c3 = e.charCodeAt(n + 2); t += String.fromCharCode((r & 15) << 12 | (c2 & 63) << 6 | c3 & 63); n += 3 } } return t } };

var ArCtrl = ["TxtCurPassword", "TxtPassword", "TxtConfirmPassword"], UsrPassword = ((sessionStorage.getItem('PASSWORD') == null) ? "" : Base64.decode(sessionStorage.getItem('PASSWORD'))),
    arrError = ["ErCurrent", "ErPassword", "ErCPassword"], PageName = document.location.pathname.match(/[^\/]+$/)[0], gurl = "https://" + "qah.traczo.app:443";
function ChangePassword() {
    ShowModalPopUp('ModalChangepwd');// HideModalPopUp('ModalCancel');
}


function getPageAccess() {

    var Role = sessionStorage.getItem('ROLE'), UserName = sessionStorage.getItem('NAME'), Page = document.location.href.match(/[^\/]+$/)[0];

    var ServiceID = sessionStorage.getItem('ServiceCode');
    $('#spanUserName').html(UserName);

    sessionStorage.setItem('canStartComplete', '0');
    sessionStorage.setItem('CancelTask', '0');
   // alert(urlPageValidation);

    if (Role != null && Role != 'null') {
        $.ajax({
            async: false,
            url: urlPageValidation + "Process=" + encodeURIComponent(Encrypt("GETMENU")) +"&ROLEID=" + encodeURIComponent(Encrypt(Role)) + "",
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {

                var pages = data[0].RESULT.split(','), pageBuilder = '', IsValidPage = false;
                if (pages.length > 0) {

                    $.each(pages, function (key, value) {
                        var pageValAR = value.split('_');
                        var Name = pageValAR[0], ImageURL = pageValAR[1], URL = pageValAR[2], TreeID = pageValAR[3], ControlType = pageValAR[4],
                            LinkID = 'pageLink' + Name;
                        if (ControlType == 'PAGE') {
                            URL = (ServiceID == '2' && Name == 'Planner') ? "../Planner/SheduledBreakfast.aspx" : URL;
                            Name = (ServiceID == '2' && Name == 'Planner') ? "Shed. Breakfast" : Name;

                            if (URL.includes('TrackNew.aspx')) {
                                pageBuilder += '<li> <a href="#"  href="#" onclick="redirectFloorwiseTrac()" > <span> <img src="../images/world-map.png" alt="Map"></span> Map </a> </li> ';
                            }

                            if (URL == '../admin/bulk.aspx')
                                pageBuilder += '<li> <a onclick="javascript:Bulk();" href="#"> <span> <img src="' + ImageURL + '" alt="' + Name + '"></span> ' + Name + ' </a> </li> ';
                            else
                                pageBuilder += '<li id="' + LinkID + '" ' + ((URL.includes(Page)) ? ' class="current-menu-item" ' : "") + '> <a href="' + URL + '" > <span> <img src="' + ImageURL + '" alt="' + Name + '"></span> ' + Name + ' </a> </li> ';

                            if (!IsValidPage)
                                IsValidPage = URL.includes(Page);
                        } else {
                            if (Name == 'StartComplete')
                                sessionStorage.setItem('canStartComplete', '1');
                            else if (Name == 'CancelTask')
                                sessionStorage.setItem('CancelTask', '1');
                        }
                    });
                    if (IsValidPage)
                        $('.left-panel-menu').html('<ul>' + pageBuilder + '</ul>');
                    else
                        window.location = "../Login.aspx";
                }
            },
            error: function (data) {

            }
        });
    } else
        window.location = "../Login.aspx";
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



function getAccess() {
    var Role = sessionStorage.getItem('ROLE');

    if (Role == null || Role == 'null')
        window.location = "../Login.aspx";
}

function InitChangePassword() {
    getPageAccess();
    var myInput = document.getElementById("TxtPassword");
    var letter = document.getElementById("letter");
    var capital = document.getElementById("capital");
    var number = document.getElementById("number");
    var length = document.getElementById("length");
    var splCharv = document.getElementById("splChar");


    // When the user clicks on the password field, show the message box
    //myInput.onfocus = function () {

    //    document.getElementById("message").style.display = "block";

    //}
    //myInput.onclick = function () {

    //    document.getElementById("message").style.display = "block";

    //}

    //// When the user clicks outside of the password field, hide the message box
    //myInput.onblur = function () {
    //    document.getElementById("message").style.display = "none";

    //}

    // When the user starts to type something inside the password field
    myInput.onkeyup = function () {
        $('#TxtPassword').focus();
        // Validate lowercase letters
        var lowerCaseLetters = /[a-z]/g;
        if (myInput.value.match(lowerCaseLetters)) {
            letter.classList.remove("invalid");
            letter.classList.add("valid");
        } else {
            letter.classList.remove("valid");
            letter.classList.add("invalid");
        }

        //spl char


        var splLetters = /[!@#$%^&*()\-+.]/g;
        if (myInput.value.match(splLetters)) {
            splCharv.classList.remove("invalid");
            splCharv.classList.add("valid");
        } else {
            splCharv.classList.remove("valid");
            splCharv.classList.add("invalid");
        }

        // Validate capital letters
        var upperCaseLetters = /[A-Z]/g;
        if (myInput.value.match(upperCaseLetters)) {
            capital.classList.remove("invalid");
            capital.classList.add("valid");
        } else {
            capital.classList.remove("valid");
            capital.classList.add("invalid");
        }

        // Validate numbers
        var numbers = /[0-9]/g;
        if (myInput.value.match(numbers)) {
            number.classList.remove("invalid");
            number.classList.add("valid");
        } else {
            number.classList.remove("valid");
            number.classList.add("invalid");
        }

        // Validate length
        if (myInput.value.length >= 12) {
            length.classList.remove("invalid");
            length.classList.add("valid");
        } else {
            length.classList.remove("valid");
            length.classList.add("invalid");
        }
    }


}

function ClearPassword() {
    $.each(arrError, function (i, val) {
        $('#' + val).css('visibility', 'hidden');
    });
}
function HoverOpenSideBar() {
    document.getElementById('DivPassword').style.display = 'block';
}
function OutOpenSideBar() {
    document.getElementById('DivPassword').style.display = 'none';
}
 
function ValidatePassword() {
    var newPassword = $('#TxtPassword').val().trim();
    var confirmPassword = $('#TxtConfirmPassword').val().trim();
    var userId = sessionStorage.getItem('ID');

    if (!newPassword) {
        alert('Please enter your new password.');
        return;
    }
    if (newPassword.length < 12) {
        alert('New password must be at least 12 characters.');
        return;
    }
    if (newPassword !== confirmPassword) {
        alert('New password and confirm password do not match.');
        return;
    }
    if (!userId) {
        alert('User ID missing, please login again.');
        return;
    }

    var processName = 'ChangePassword';
    var encProcess = Encrypt(processName).toString();
    var encUserId = Encrypt(userId.toString()).toString();
    var encNewPassword = Encrypt(newPassword).toString();

    var url = '/Master/Service/Service.aspx?Process=' + encodeURIComponent(encProcess);

    $.ajax({
        type: 'POST',
        url: url,
        data: JSON.stringify({
            USERID: encUserId,
            PWD: encNewPassword
        }),
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        success: function (response) {
            if (!response.success) {
                var err = response.data && response.data.ERROR;
                alert('Failed to change password. ' + (err ? err : 'Please try again.'));
                return;
            }

            var result = response.data.RESULT;
            var error = response.data.ERROR;

            if (result === "TRUE") {
                $('#ModalChangepwd').modal('hide');
                $('#ModalChangepwd').modal('hide');
                $('#lblEmployeeActionResult').text('Password changed successfully!');
              //  $('#modalEmployeeActionSuccess').modal('show');
                ShowModalPopUp('ModalDone');
               // setTimeout("ClosePassword();", 1000);
                setTimeout(function () {
                    window.location = '../Login.aspx';
                }, 3000);
            } else {
                alert('Failed to change password. ' + (error ? error : 'Please try again.'));
            }
        },
        error: function (xhr, status, error) {
            console.error('Error changing password:', error);
            alert('An error occurred while changing password.');
        }
    });
}
/*
function ValidatePassword() {

    if (sessionStorage.getItem('ROLE') == null) {
        window.location = "../Default.aspx"; return;
    }
    var reVal = true;
    ClearPassword();
    const regexp = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()\-+.]).{12,20}$/;


    if ($('#TxtCurPassword').val().length == 0) {
        $('#TxtCurPassword').focus();
        $('#ErCurrent').css('visibility', 'visible');
        reVal = false;
    } else if (($('#TxtCurPassword').val().toUpperCase() != UsrPassword.toUpperCase())) {
        $('#TxtCurPassword').focus();
        $('#ErCurrent').css('visibility', 'visible');
        reVal = false;
    } else if ($('#TxtPassword').val().length == 0 || !regexp.test($('#TxtPassword').val())) {

        $('#TxtPassword').focus();
        $('#ErPassword').css('visibility', 'visible');
        reVal = false;
    } else if ($('#TxtConfirmPassword').val().length == 0) {
        $('#TxtConfirmPassword').focus();
        $('#ErCPassword').css('visibility', 'visible');
        reVal = false;
    } else if ($('#TxtConfirmPassword').val() != $('#TxtPassword').val()) {
        $('#TxtConfirmPassword').focus();
        $('#ErCPassword').css('visibility', 'visible');
        reVal = false;
    }
    if (reVal) {
        //  alert("https://" + '<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/MasterPage/Service/Service.aspx?Process=CHANGEPASSWORD&PWD=");
        var uid = sessionStorage.getItem('ID');
        $.ajax({
            async: false,
            url: gurl + "/Master/Service/Service.aspx?Process=CHANGEPWD&PWD=" + $('#TxtPassword').val() + "&USERID=" + uid + "",
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {
                if (data[0].RESULT === 'TRUE') {
                    ShowModalPopUp('ModalDone');
                    setTimeout("ClosePassword();", 1000);
                }
            },
            error: function (data) {

            }
        });
        if (PageName == 'Request.aspx')
            RestartTimer();
    }
}
*/