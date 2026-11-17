function RaiseInvalid() {
    $("#LblLoginError").css('visibility', 'visible');
    $("#userid").val('');
    $("#password").val('');
    $("#userid").focus();
    setTimeout("SetFalse();", 2000);
}
function SetFalse() {
    $("#LblLoginError").css('visibility', 'hidden');
}
function ValidateLogin() {
    var userid = $("#userid"), Password = $("#password");
    if (userid.val().length === 0)
        userid.focus();
    else if (Password.val().length === 0)
        Password.focus();
    else {
        ShowModalPopUp('ModalLoading');
        var UsID = encodeURIComponent(Encrypt(userid.val())), pwd = encodeURIComponent(Encrypt(Password.val()));
        $.ajax({
            async: true,
            url: ServiceURL + "Service.aspx?Process=CHECKUSER&USERNAME=" + UsID + "&PWD=" + pwd + "",
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {
                if (data[0].RESULT !== 'FALSE') {
                    var LandingURL = data[0].RESULT.split('_')[9];
                    sessionStorage.setItem('ID', data[0].RESULT.split('_')[0]);
                    sessionStorage.setItem('NAME', data[0].RESULT.split('_')[1]);
                    sessionStorage.setItem('PASSWORD', Base64.encode(data[0].RESULT.split('_')[2]));
                    sessionStorage.setItem('ROLE', data[0].RESULT.split('_')[3]);
                    sessionStorage.setItem('EXPIRY', data[0].RESULT.split('_')[4]);
                    sessionStorage.setItem('ROLENAME', data[0].RESULT.split('_')[5]);
                    sessionStorage.setItem('DEFAULTLOCID', data[0].RESULT.split('_')[6]);
                    sessionStorage.setItem('DEFAULTLOC', data[0].RESULT.split('_')[7]);

                    sessionStorage.setItem('SESSIONID', data[0].RESULT.split('_')[8]);

                    sessionStorage.setItem('LURL', LandingURL);

                    window.location = LandingURL;
                }
                else
                    RaiseInvalid();
                HideModalPopUp('ModalLoading');

            },
            error: function (data) {

            }

        });
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


function ShowModalPopUp(ModalId) {
    $('#' + ModalId).modal('show');
}
function HideModalPopUp(ModalId) {
    $('#' + ModalId).modal('hide');
}