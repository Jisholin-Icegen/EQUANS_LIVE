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
        $.ajax({
            async: true,
            url: ServiceURL + "Service.aspx?Process=CHECKUSER&USERNAME=" + userid.val() + "&PWD=" + Password.val() + "",
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {
                if (data[0].RESULT !== 'FALSE') {
                    sessionStorage.setItem('ID', data[0].RESULT.split('_')[0]);
                    sessionStorage.setItem('NAME', data[0].RESULT.split('_')[1]);
                    sessionStorage.setItem('PASSWORD', Base64.encode(data[0].RESULT.split('_')[2]));
                    sessionStorage.setItem('ROLE', data[0].RESULT.split('_')[3]);
                    sessionStorage.setItem('EXPIRY', data[0].RESULT.split('_')[4]);
                    sessionStorage.setItem('ROLENAME', data[0].RESULT.split('_')[5]);
                    window.location = "Home/Home.aspx"; 
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


function ShowModalPopUp(ModalId) {
    $('#' + ModalId).modal('show');
}
function HideModalPopUp(ModalId) {
    $('#' + ModalId).modal('hide');
}