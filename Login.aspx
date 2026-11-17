<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<html lang="en">

<head>
    <title>Login | TRACZO</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="icon" href="favicon.png" />
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="css/style.css" />
    <link href="css/Login.css" rel="stylesheet" />

    <script src="js/jquery-3.6.4.min.js"></script>

    <script language="javascript" type="text/javascript">
        var ServiceURL =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Login/Service/",
            CryptoKey = '<%=ConfigurationManager.AppSettings["CryptoKey"].ToString() %>',
            ConProtocol = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>',
            CryptoPwd = '<%=ConfigurationManager.AppSettings["CryptoIV"].ToString() %>';
        var Base64 = { _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=", encode: function (e) { var t = ""; var n, r, i, s, o, u, a; var f = 0; e = Base64._utf8_encode(e); while (f < e.length) { n = e.charCodeAt(f++); r = e.charCodeAt(f++); i = e.charCodeAt(f++); s = n >> 2; o = (n & 3) << 4 | r >> 4; u = (r & 15) << 2 | i >> 6; a = i & 63; if (isNaN(r)) { u = a = 64 } else if (isNaN(i)) { a = 64 } t = t + this._keyStr.charAt(s) + this._keyStr.charAt(o) + this._keyStr.charAt(u) + this._keyStr.charAt(a) } return t }, decode: function (e) { var t = ""; var n, r, i; var s, o, u, a; var f = 0; e = e.replace(/[^A-Za-z0-9+/=]/g, ""); while (f < e.length) { s = this._keyStr.indexOf(e.charAt(f++)); o = this._keyStr.indexOf(e.charAt(f++)); u = this._keyStr.indexOf(e.charAt(f++)); a = this._keyStr.indexOf(e.charAt(f++)); n = s << 2 | o >> 4; r = (o & 15) << 4 | u >> 2; i = (u & 3) << 6 | a; t = t + String.fromCharCode(n); if (u != 64) { t = t + String.fromCharCode(r) } if (a != 64) { t = t + String.fromCharCode(i) } } t = Base64._utf8_decode(t); return t }, _utf8_encode: function (e) { e = e.replace(/rn/g, "n"); var t = ""; for (var n = 0; n < e.length; n++) { var r = e.charCodeAt(n); if (r < 128) { t += String.fromCharCode(r) } else if (r > 127 && r < 2048) { t += String.fromCharCode(r >> 6 | 192); t += String.fromCharCode(r & 63 | 128) } else { t += String.fromCharCode(r >> 12 | 224); t += String.fromCharCode(r >> 6 & 63 | 128); t += String.fromCharCode(r & 63 | 128) } } return t }, _utf8_decode: function (e) { var t = ""; var n = 0; var r = c1 = c2 = 0; while (n < e.length) { r = e.charCodeAt(n); if (r < 128) { t += String.fromCharCode(r); n++ } else if (r > 191 && r < 224) { c2 = e.charCodeAt(n + 1); t += String.fromCharCode((r & 31) << 6 | c2 & 63); n += 2 } else { c2 = e.charCodeAt(n + 1); c3 = e.charCodeAt(n + 2); t += String.fromCharCode((r & 15) << 12 | (c2 & 63) << 6 | c3 & 63); n += 3 } } return t } };
        $(document).ready(function () {
           // debugger;
            let params = new URLSearchParams(window.location.search);

            // Check if parameter exists
            if (params.has('lp')) {
                //alert( ( params.get('lp')));
                //alert(Decrypt( params.get('lp')));

                //var UsID = Decrypt( params.get('lu')), pwd =Decrypt( params.get('lp'));

                var UsID = Base64.decode(params.get('lu')), pwd = Base64.decode(params.get('lp'));
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

            var protocol = location.protocol.replace(":", "");
            clearSession();
            function disableBack() { window.history.forward() }
            window.onload = disableBack();
            window.onpageshow = function (evt) { if (evt.persisted) disableBack() }

            if ((typeof ConProtocol === "undefined") || (ConProtocol !== protocol)) {
                var Host = window.location.host;

                //ShowModalPopUp("");
                window.location = ((typeof ConProtocol === "undefined") ? "https" : ConProtocol) + "://" + Host + "/Login.aspx";
            }
            $('#userid').focus();
        });

        function clearSession() {
            sessionStorage.setItem('ID', null);
            sessionStorage.setItem('NAME', null);
            sessionStorage.setItem('PASSWORD', null);
            sessionStorage.setItem('ROLE', null);
            sessionStorage.setItem('EXPIRY', null);
            sessionStorage.setItem('ROLENAME', null);
            sessionStorage.setItem('DEFAULTLOCID', null);
            sessionStorage.setItem('DEFAULTLOC', null);
            sessionStorage.setItem('SESSIONID', null);
        }

    </script>
</head>

<body class="login-screen" ondragstart="return false;" ondrop="return false;"
    ondragstart="return false;" ondrop="return false;">
    <div id="loader" class="loader-wrapper">
        <img src="images/Traczo.svg" alt="Traczo">
    </div>
    <div class="wrapper">
        <div class="login-screen-wrap">
            <div class="container">
                <div class="login-screen-inner">
                    <div class="row no-gutters">
                        <div class="col-md-6">
                            <div class="login-screen-left">
                                <div style="background: url(images/Traczo-bg.svg) no-repeat center;">
                                    <img src="images/login-img.png" alt="Traczo" />
                                </div>
                                <h1>TRACZO</h1>
                                <p>Copyright © ICEGEN 2020-2023</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="login-screen-right">
                                <h6>Login</h6>
                                <div class="login-form-wrap">
                                    <span class="corner"></span>
                                    <form id="formLogin">
                                        <div class="mb-4" style="text-align: center">
                                            <label id="LblLoginError" class="lblLGError">
                                                Invalid Credential.
                                            </label>
                                        </div>
                                        <div class="mb-4">
                                            <label for="Username">
                                                Username
                                            </label>
                                            <input id="userid" type="text" placeholder="Username" class="form-control" required>
                                        </div>
                                        <div class="mb-4">
                                            <label for="Username">
                                                Password
                                            </label>
                                            <input id="password" type="password" placeholder="**********" class="form-control" required>
                                        </div>
                                        <div class="mb-4">
                                            <input type="submit" value="Submit" class="btn btn-secondary w-100" onclick="ValidateLogin();return false;">
                                        </div>
                                        <div class="text-center" style="display: none">
                                            <a href="#">Forgot Password?</a>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="ModalLoading" class="modal" role="dialog" style="display: none; padding-right: 17px; background-color: #000000b3;">
        <div class="modal-dialogLoc" align="center">
            <table style="margin-top: 100px;">
                <tr>
                    <td>
                        <img id="LoadingGif" style="width: 80px; border-radius: 5px;"
                            src="Login/Images/LoadingN.gif" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>

<script src="js/style.js"></script>
<script src="Scripts/bootstrap.min.js" type="text/javascript"></script>

<script src="js/Login.js" type="text/javascript"></script>
<script src="js/aes.js" type="text/javascript"></script>


</html>
