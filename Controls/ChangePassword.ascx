<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ChangePassword.ascx.cs"
    Inherits="Controls_Menu" %>
<head>
    <style>
        #ImgCPDone
        {
            border-radius: 75px;
            border: 3px solid rgb(30, 70, 129) !important;
            background: white;
            -webkit-animation: CPDoneAnimate 5s infinite;
            animation: CPDoneAnimate .5s infinite;
        }


        @keyframes CPDoneAnimate {
           100% {
            background-color: rgba(30, 70, 129,.25);
            }
        }    
    </style>
    <script type="text/javascript">
        var Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=Base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9+/=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=Base64._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/rn/g,"n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}};
        var Mserviceurl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/MasterPage/Service/",
	        Uberurl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["UberPort"].ToString() %>',
	        ArCtrl = ["TxtCurPassword", "TxtPassword", "TxtConfirmPassword"],
            arrError = ["ErCurrent", "ErPassword", "ErCPassword"], UsrPassword = ((sessionStorage.getItem('PASSWORD') == null) ? "" : Base64.decode(sessionStorage.getItem('PASSWORD'))), Content = '',
            UID = (sessionStorage.getItem('ID') == null) ? '' : sessionStorage.getItem('ID'), Role = (sessionStorage.getItem('ROLE') == null) ? '' : sessionStorage.getItem('ROLE'), PageName = document.location.pathname.match(/[^\/]+$/)[0];

        $(document).ready(function () {

            $("#LBLUser").html(sessionStorage.getItem('NAME'));
            if (sessionStorage.getItem('EXPIRY') == null)
                window.location = "../Login.aspx";
            else if (sessionStorage.getItem('EXPIRY').toUpperCase() == "TRUE")
                setTimeout("ChangePassword();", 300);
            function disableBack() { window.history.forward() }
            window.onload = disableBack();
            window.onpageshow = function (evt) { if (evt.persisted) disableBack() }
        });

        function CheckPendingRequests() {
            var PendingRequest = '', badBrowser = false,
                UName = sessionStorage.getItem('NAME').toUpperCase(),
                UID = (sessionStorage.getItem('ID') == null) ? '' : sessionStorage.getItem('ID');
            if (navigator.appName.indexOf("Internet Explorer") != -1)    //yeah, he's using IE
                badBrowser = (navigator.appVersion.indexOf("MSIE 1") == -1); //v10, 11, 12, etc. is fine too   
            $.ajax({
                async: true,
                url: Mserviceurl + "Service.aspx?Process=GETPENDINGREQUESTS&USERID=" + UID + "",
                type: 'POST',
                data: 'pData',
                dataType: 'json',
                success: function (data) {
                    $.each(data, function () {
                        $.each(this, function (name, value) {
                            PendingRequest += (!$.trim(PendingRequest)) ? value : '-' + value;
                        });
                    });
                    if ($.trim(PendingRequest) && (!badBrowser))
                        window.open(Uberurl + '/Map.aspx?ReqId=' + Base64.encode(PendingRequest) + '&USERID=' + Base64.encode(UID) + '&UNAME=' + Base64.encode(UName), 'REQUEST NO : #', 'directories=no,titlebar=yes,toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=no,width=1000,height=700');
                },
                error: function (data) {

                }

            });
        }
        function GetPendingReq() {
            UID = (sessionStorage.getItem('ID') == null) ? '' : sessionStorage.getItem('ID');
            var PenReq = '';
            $.ajax({
                async: false,
                url: Mserviceurl + "Service.aspx?Process=GETPENDINGREQUESTS&USERID=" + UID + "",
                type: 'POST',
                data: 'pData',
                dataType: 'json',
                success: function (data) {
                    $.each(data, function () {
                        $.each(this, function (name, value) {
                            PenReq += (!$.trim(PenReq)) ? value : '-' + value;
                        });
                    });
                },
                error: function (data) {

                }

            });
            return (($.trim(PenReq)) ? true : false);
        }
        function ValidatePassword() {

            if (sessionStorage.getItem('ROLE') == null) {
                window.location = "../Default.aspx"; return;
            }
            var reVal = true;
            ClearPassword();
            if ($('#TxtCurPassword').val().length == 0) {
                $('#TxtCurPassword').focus();
                $('#ErCurrent').css('visibility', 'visible');
                reVal = false;
            } else if (($('#TxtCurPassword').val() != UsrPassword.toUpperCase()) && ($('#TxtCurPassword').val() != UsrPassword.toLowerCase())) {
                $('#TxtCurPassword').focus();
                $('#ErCurrent').css('visibility', 'visible');
                reVal = false;
            } else if ($('#TxtPassword').val().length == 0) {
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
                $.ajax({
                    async: false,
                    url:  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/MasterPage/Service/Service.aspx?Process=CHANGEPASSWORD&PWD=" + $('#TxtPassword').val() + "&USERID=" + UID + "",
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

        function Logout() {
            Role = (sessionStorage.getItem('ROLE') == null) ? '' : sessionStorage.getItem('ROLE');
            UID = (sessionStorage.getItem('ID') == null) ? '' : sessionStorage.getItem('ID');
            $.ajax({
                async: false,
                url:  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/MasterPage/Service/Service.aspx?Process=LOGOUT",
                type: 'POST',
                data: 'pData',
                dataType: 'json',
                success: function (data) {
                    if (Role != '' && UID != '' && Role.toUpperCase() != "ADMIN" && GetPendingReq()) {
                        var popupWindow = window.open(Uberurl + '/Map.aspx?ReqId=&USERID=&UNAME=', 'REQUEST NO : #', 'directories=no,titlebar=yes,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=700');
                        window.onbeforeunload = function () {
                            popupWindow.close();
                        };
                    }
                    sessionStorage.setItem('ID', null);
                    sessionStorage.setItem('NAME', null);
                    sessionStorage.setItem('PASSWORD', null);
                    sessionStorage.setItem('ROLE', null);
                    window.location = "../Login.aspx";
                },
                error: function (data) {

                }
            });
        }
        function RestartTimer() {
            Reload = window.setInterval(ReloadLinks, 60000);
        }
        function ClosePassword() {
            HideModalPopUp('ModalDone');
            HideModalPopUp('ModalChangePassword');
            window.location = "../Login.aspx";
        }
        function ClearPassword() {
            $.each(arrError, function (i, val) {
                $('#' + val).css('visibility', 'hidden');
            });
        }
        function ChangePassword() {
            $.each(ArCtrl, function (i, val) {
                $('#' + val).val('');
            });
            ClearPassword();
            if (PageName == 'Request.aspx' && Reload) {
                clearInterval(Reload);
                Reload = false;
            }
            ShowModalPopUp('ModalChangePassword');
            $('#' + ArCtrl[0]).focus();
        }
    </script>
</head>
<div id="ModalChangePassword" class="modal fade" role="dialog">
    <div class="modal-dialogCP">
        <div class="modal-contentCP">
            <div class="headerCP" align="center">
                <table width="100%" style="margin-top: -6px;">
                    <tr>
                        <td colspan="2" align="center" valign="middle">
                            <span style="color: white; font-family: monospace; font-weight: lighter; position: relative;
                                margin-right: 5px; top: -4px; padding-right: 5px;">Change Password</span><img src="../Images/Master/Edit.png" />
                        </td>
                        <td width="10%">
                            <input type="image" name="BtnCPClose" id="BtnCPClose" src="../Images/Master/Close.png"
                                style="border-width: 0px; cursor: pointer; float: right; margin-right: 8px; width: 20px;
                                height: 20px;" data-dismiss="modal" />
                        </td>
                    </tr>
                </table>
            </div>
            <div class="headFootCP" style="height: 0px; margin-top: -2px;">
            </div>
            <div id="mpCP" align="center" style="overflow-y: auto;">
                <div id="DivCPContent" class="ContentCP" align="center" style="margin-top: 25px;">
                    <asp:Panel ID="PnlPassword" runat="server" DefaultButton="BtnSave">
                        <table class="Custfont" style="min-width: 350px; min-height: 160px; font-size: 11px;
                            font-family: arial; font-weight: lighter;" cellpadding="5" cellspacing="5">
                            <tr>
                                <td>
                                    CURRENT PASSWORD
                                </td>
                                <td align="center">
                                    <asp:TextBox ID="TxtCurPassword" runat="server" Width="180px" class="Custfont" ClientIDMode="Static"
                                        Style="font-family: arial !important; font-weight: lighter !important; font-size: 15px !important;
                                        border: 1px solid #ded6d6 !important; border-radius: 0px !important; margin-bottom: 0px !important;
                                        padding-left: 5px" TextMode="Password"></asp:TextBox>
                                    <asp:Label ID="ErCurrent" runat="server" Text="*" ForeColor="Red" Font-Size="Medium"
                                        ClientIDMode="Static" CssClass="Custfont" Style="visibility: hidden"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    NEW PASSWORD
                                </td>
                                <td align="center">
                                    <asp:TextBox ID="TxtPassword" runat="server" Width="180px" class="Custfont" ClientIDMode="Static"
                                        Style="font-family: arial !important; font-weight: lighter !important; font-size: 15px !important;
                                        border: 1px solid #ded6d6 !important; border-radius: 0px !important; margin-bottom: 0px !important;
                                        padding-left: 5px" TextMode="Password"></asp:TextBox>
                                    <asp:Label ID="ErPassword" runat="server" Text="*" ForeColor="Red" Font-Size="Medium"
                                        ClientIDMode="Static" CssClass="Custfont" Style="visibility: hidden"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    CONFIRM PASSWORD
                                </td>
                                <td align="center">
                                    <asp:TextBox ID="TxtConfirmPassword" runat="server" Width="180px" class="Custfont"
                                        Style="font-family: arial !important; font-weight: lighter !important; font-size: 15px !important;
                                        border: 1px solid #ded6d6 !important; border-radius: 0px !important; margin-bottom: 0px !important;
                                        padding-left: 5px" ClientIDMode="Static" TextMode="Password"></asp:TextBox>
                                    <asp:Label ID="ErCPassword" runat="server" Text="*" ForeColor="Red" Font-Size="Medium"
                                        ClientIDMode="Static" CssClass="Custfont" Style="visibility: hidden"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table width="90%" align="center">
                                        <tr>
                                            <td valign="middle" align="center">
                                            </td>
                                            <td align="right">
                                                <asp:Button ID="BtnSave" runat="server" Text="CHANGE" Style="background-color: rgba(32, 72, 132, 1);
                                                    border: none; padding: 5px 10px; color: white; font-weight: lighter !important;
                                                    font-size: 14px; border-radius: 0px !important; font-family: monospace;" OnClientClick="ValidatePassword();return false;" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>
</div>
<div id="ModalDone" class="modal fade" role="dialog">
    <div class="modal-dialogLoc" align="center">
        <table style="margin-top: 100px;">
            <tr>
                <td>
                    <img src="../Images/CPDone.PNG" id="ImgCPDone" />
                </td>
            </tr>
        </table>
    </div>
</div>
