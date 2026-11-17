<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MailSettings.aspx.cs" Inherits="Master_MailSettings"
    MasterPageFile="~/MasterPage/ChangePassword.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" runat="Server">
    <title>:: SETTINGS ::</title>
    <link href="../Styles/Inner.css" rel="stylesheet" type="text/css" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="../Scripts/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="../Scripts/bootstrap.min.js" type="text/javascript"></script>
    <script src="../Scripts/UserAction.js" type="text/javascript"></script>
    <script src="../Scripts/Master.js" type="text/javascript"></script>
    <link href="../Styles/Grid.css" rel="stylesheet" type="text/css" />
    <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">
        <script type="text/javascript">
            var ParentMenuService =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Service/ParentMenu.aspx?";
            function Validate() {
                var To = document.getElementById("TextTo"), CC = document.getElementById("TextCC"), TATTo = document.getElementById("TATTextTo"), TATCC = document.getElementById("TATTextCC"), DailyTo = document.getElementById("TextDailyMailTo"), DailyMailCC = document.getElementById("TextDailyMailCC"), Server = document.getElementById("TextServer"), Port = document.getElementById("TextPort");

                if ((To.value.length <= 0) || (!validateEmail(To.value))) {
                    To.focus();
                    return false;
                }
                else if ((CC.value.length <= 0) || !(ValidateCC(CC.value))) {
                    CC.focus();
                    return false;
                }
                else if ((DailyTo.value.length <= 0) || (!validateEmail(DailyTo.value))) {
                    DailyTo.focus();
                    return false;
                }
                else if ((DailyMailCC.value.length <= 0) || !(ValidateCC(DailyMailCC.value))) {
                    DailyMailCC.focus();
                    return false;
                }
                else if ((TATTo.value.length <= 0) || (!validateEmail(TATTo.value))) {
                    TATTo.focus();
                    return false;
                }
                else if ((TATCC.value.length <= 0) || !(ValidateCC(TATCC.value))) {
                    TATCC.focus();
                    return false;
                }
                else if (Server.value.length <= 0) {
                    Server.focus();
                    return false;
                }
                else if (Port.value.length <= 0) {
                    Port.focus();
                    return false;
                }
                else {
                    $.ajax({
                        url:  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Master/Service/Service.aspx?Process=UPDATEMAILSETTING&FROM=&TO=" + To.value + "&CC=" + CC.value + "&TATTO=" + TATTo.value + "&TATCC=" + TATCC.value + "&DAILYTO=" + DailyTo.value + "&DAILYCC=" + DailyMailCC.value + "&SERVER=" + Server.value + "&PORT=" + Port.value,
                        type: 'POST',
                        data: 'pData',
                        dataType: 'json',
                        success: function (data) {
                            if (data[0].RESULT === 'TRUE') {
                                ShowModalPopUp('ModalDone');
                                setTimeout("HideModalPopUp('ModalDone');", 1000);
                            }
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

            function validateEmail(email) {
                var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                return re.test(email);
            }
            function ValidateCC(Value) {
                var CC = Value.split(";"); result = true;
                for (var i = 0; i < CC.length; i++) {
                    if (result) {
                        if (CC[i].length > 0)
                            result = validateEmail($.trim(CC[i]));
                    }
                }
                return result;
            }
            function Delete(id) {
                var confi = confirm('Press ok if your are sure.')
                if (confi == true)
                    return true;
                else
                    return false;
            }
        </script>
    </telerik:RadCodeBlock>
    <style>
        .rbDecorated
        {
            border-radius: 0px !important;
            transition: none !important;
            -webkit-appearance: none !important;
            -webkit-transition: none !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentMaster" runat="Server">
    <body ondragstart="return false;" ondrop="return false;" style="min-width: 1300px">
        <center>
            <telerik:RadScriptManager ID="RadScriptManager" runat="server">
            </telerik:RadScriptManager>
            <div id="DivFloorMaster" align="center">
                <table class="TblMain">
                    <tr style="height: 60px;">
                        <td style="width: 45vw">
                        </td>
                        <td align="center">
                            <div width="100%" align="center" class='ParentIcon'>
                                <img id="ParentIcon" src="../Images/Menu.PNG" alt='' style="padding: 8px 12px;" />
                            </div>
                            <div align="center" class='ParentIcons'>
                                <table cellspacing='5' style="width: 380px; margin-top: 55px; border-collapse: separate;">
                                    <tr>
                                        <td colspan="2">
                                            <img src="../Home/Images/Home.png" id="ImgInnerHome" onclick="Redirect('../Home/Home.aspx');" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table id="TblOtherParent" cellspacing='5' style="border-collapse: separate; width: 100%">
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                        <td style="width: 45vw" align="right">
                            <div class="divPortzoInner" align="center">
                                <img id="PortzoIconInner" src="../Images/Portzo.png" alt='' />
                            </div>
                            <table style="width: 20%">
                                <tr>
                                    <td>
                                        <div id="DivPassword">
                                            <ul id="Ul1" class="nospace inline" runat="server">
                                                <li><strong>WELCOME &nbsp; <span id="LBLUser" runat="server" clientidmode="Static"
                                                    style="color: #ee5616;">ANAND </span></strong></li>
                                            </ul>
                                            <ul style="list-style-type: none;">
                                                <li>
                                                    <img src="../Images/user.png" class="ImgUser" />
                                                    <div class="DivPassword" align="left">
                                                        <ul class='Pmenu' style="height: 25px;">
                                                            <li><a onclick="ChangePassword();">CHANGE PASSWORD </a></li>
                                                            <li><a onclick="Logout();">LOGOUT </a></li>
                                                        </ul>
                                                    </div>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="border-bottom: 3px solid rgb(30, 70, 129); height: 80px;">
                        <td colspan='3' align="center">
                            <table style="position: absolute; margin-top: 5px;">
                                <tr>
                                    <td align="center" valign="middle" style="background-image: url('Images/ChildIcon/Category.png');
                                        background-repeat: no-repeat; background-position: center;" class="InnerAdminIcon"
                                        id="tdReqNew" onclick="Redirect('CategoryMaster.aspx');">
                                        <p class="InnerAdminText">
                                            Task Types</p>
                                    </td>
                                    
                                    <td style="background-image: url('Images/ChildIcon/Zone.PNG'); background-repeat: no-repeat; background-position: center;"
                                        class="InnerAdminIcon" valign="middle" align="center"
                                        id="tdDept" onclick="Redirect('DeptMaster.aspx');">
                                        <p class="InnerAdminText">
                                          24 HRS 
                                            <br />
                                            Applicability
                                        </p>
                                    </td>

                                    
                                    <td style="background-image: url('Images/ChildIcon/Zone.PNG'); background-repeat: no-repeat; background-position: center;" class="InnerAdminIcon" valign="middle" align="center" id="tdRgroup" onclick="Redirect('RequestGroup.aspx');">
                                        <p class="InnerAdminText">REQUEST
                                            <br />
                                            GROUP </p>
                                    </td>
                                    
                                    <td style="background-image: url('Images/ChildIcon/Floor.png'); background-repeat: no-repeat;
                                        background-position: center;" class="InnerAdminIcon" valign="middle" align="center"
                                        id="tdReqPending" onclick="Redirect('FloorMaster.aspx');">
                                        <p class="InnerAdminText">
                                            FLOOR MASTER</p>
                                    </td>
                                    <td style="background-image: url('Images/ChildIcon/Zone.png'); background-repeat: no-repeat;
                                        background-position: center;" class="InnerAdminIcon" valign="middle" align="center"
                                        id="tdReqAssigned" onclick="Redirect('LocationMaster.aspx');">
                                        <p class="InnerAdminText">
                                            DEPARTMENT <br /> MASTER</p>
                                    </td>
                                    <td style="background-image: url('Images/ChildIcon/Porter.PNG'); background-repeat: no-repeat;
                                        background-position: center;" class="InnerAdminIcon" valign="middle" align="center"
                                        id="tdReqInProc" onclick="Redirect('PorterMaster.aspx');">
                                        <p class="InnerAdminText">
                                            PORTER MASTER</p>
                                    </td>
                                    
                                    <td style="border-radius: 0px 0px 0px 5px; background-image: url('Images/ChildIcon/Shift.PNG');
                                        background-repeat: no-repeat; background-position: center;" class="InnerAdminIcon"
                                        id="tdPreset" valign="middle" align="center" onclick="Redirect('Preset Master.aspx');">
                                        <p class="InnerAdminText">
                                            PRE-SET MASTER</p>
                                    </td>
                                    <td style="border-radius: 0px 0px 0px 5px; background-image: url('Images/ChildIcon/Shift.PNG');
                                        background-repeat: no-repeat; background-position: center;" class="InnerAdminIcon"
                                        id="tdReqCompleted" valign="middle" align="center" onclick="Redirect('ShiftMaster.aspx');">
                                        <p class="InnerAdminText">
                                            SHIFT MASTER</p>
                                    </td>
                                    <td style="background-image: url('Images/ChildIcon/Tag.png'); background-repeat: no-repeat;
                                        background-position: center;" class="InnerAdminIcon" valign="middle" align="center"
                                        id="tdReqCancelled" onclick="Redirect('TagMaster.aspx');">
                                        <p class="InnerAdminText">
                                            TAG MASTER</p>
                                    </td>
                                    <td style="background-image: url('Images/ChildIcon/User.png'); background-repeat: no-repeat;
                                        background-position: center;" class="InnerAdminIcon" valign="middle" align="center"
                                        id="td3" onclick="Redirect('UserMaster.aspx');">
                                        <p class="InnerAdminText">
                                            USER MASTER</p>
                                    </td>
                                    <td style="border-radius: 0px 0px 0px 5px; background-image: url('Images/ChildIcon/Role.PNG');
                                        background-repeat: no-repeat; background-position: center;" class="InnerAdminIcon"
                                        id="td1" valign="middle" align="center" onclick="Redirect('RoleMaster.aspx');">
                                        <p class="InnerAdminText">
                                            ROLE MASTER</p>
                                    </td>
                                    <td style="background-image: url('Images/ChildIcon/Settings.png'); background-repeat: no-repeat;
                                        background-position: center;" class="InnerAdminIcon  SelectReqIcon" valign="middle"
                                        align="center" id="td2" onclick="Redirect('MailSettings.aspx');">
                                        <p class="InnerAdminText">
                                            MAIL SETTINGS</p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="background-image: url('../Images/Portzo.png'); background-position: center;
                        background-repeat: no-repeat;">
                        <td colspan="3" align="center" style="vertical-align: middle;">
                            <asp:UpdatePanel ID="UptPnlRadGrid1" runat="server">
                                <ContentTemplate>
                                    <table style="width: 100%;">
                                        <tr>
                                            <td width="10px" style="vertical-align: middle;">
                                                <img id="ImgLeft" src="../Images/Portzoleft.png" alt='' style="padding: 5px 6px;
                                                    box-shadow: 0px 2px 10px 2px rgb(30, 70, 129); border-radius: 0px 5px 5px 0px;
                                                    margin-left: -5px;" />
                                            </td>
                                            <td id="TrackContent" align="center">
                                                <table>
                                                    <tr>
                                                        <td align="center" valign="middle">
                                                            <table width="80%" style="border-collapse: collapse; border: 10px solid rgba(32, 72, 131,1);
                                                                border-top: 1px solid rgba(32, 72, 131,1); min-width: 830px; background-color: #ffffff;
                                                                height: 450px;" cellpadding="10" cellspacing="10">
                                                                <tr style="height: 60px">
                                                                    <td colspan="2" align="center" class="btn-blue2" style="font-family: 'Lucida Console';
                                                                        font-size: 15px; font-weight: bold; margin-top: 0px; text-align: center; vertical-align: middle;">
                                                                        DAILY/MONTHLY REPORTS
                                                                    </td>
                                                                    <td colspan="2" align="center" class="btn-blue2" style="font-family: 'Lucida Console';
                                                                        font-size: 15px; font-weight: bold; margin-top: 0px; text-align: center; vertical-align: middle;">
                                                                        CANCELLED REQUESTS
                                                                        <telerik:RadButton ID="BtnSave" runat="server" Style="position: absolute; height: 25px !important;
                                                                            padding: 8px; width: 55px !important; margin-left: 50px; margin-top: -10px;"
                                                                            Text="SAVE" CssClass="Button" OnClientClicked="Validate" />
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 70px">
                                                                    <td class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold;
                                                                        margin-top: 0px; text-align: center; max-width: 200px; vertical-align: middle;
                                                                        min-width: 60px;">
                                                                        TO
                                                                    </td>
                                                                    <td align="center" style="border-bottom: 2px solid rgba(32, 72, 131,1)">
                                                                        <asp:TextBox ID="TextDailyMailTo" runat="server" TextMode="MultiLine" Width="340px"
                                                                            Height="60px" ClientIDMode="Static" class="lblStyleBold" Style="text-transform: none;
                                                                            resize: none; padding: 8px;" placeholder="Email-ID"></asp:TextBox>
                                                                    </td>
                                                                    <td class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold;
                                                                        margin-top: 0px; text-align: center; max-width: 200px; min-width: 60px; vertical-align: middle;">
                                                                        TO
                                                                    </td>
                                                                    <td align="center" style="border-bottom: 2px solid rgba(32, 72, 131,1)">
                                                                        <asp:TextBox ID="TextTo" runat="server" TextMode="MultiLine" Width="340px" Height="60px"
                                                                            ClientIDMode="Static" class="lblStyleBold" Style="padding: 8px; text-transform: none;
                                                                            resize: none;" placeholder="Email-ID"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 70px;">
                                                                    <td class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold;
                                                                        margin-top: 0px; text-align: center; max-width: 200px; vertical-align: middle;">
                                                                        CC
                                                                    </td>
                                                                    <td align="center">
                                                                        <asp:TextBox ID="TextDailyMailCC" runat="server" TextMode="MultiLine" Width="340px"
                                                                            Height="60px" ClientIDMode="Static" class="lblStyleBold" Style="padding: 8px;
                                                                            resize: none;" placeholder="Email-IDs should be separated with (;)"></asp:TextBox>
                                                                    </td>
                                                                    <td class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold;
                                                                        margin-top: 0px; text-align: center; max-width: 200px; vertical-align: middle;">
                                                                        CC
                                                                    </td>
                                                                    <td align="center">
                                                                        <asp:TextBox ID="TextCC" runat="server" TextMode="MultiLine" Width="340px" Height="60px"
                                                                            ClientIDMode="Static" class="lblStyleBold" Style="padding: 8px; resize: none;
                                                                            text-transform: none;" placeholder="Email-IDs should be separated with (;)"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 60px">
                                                                    <td colspan="2" align="center" class="btn-blue2" style="font-family: 'Lucida Console';
                                                                        font-size: 15px; font-weight: bold; margin-top: 0px; text-align: center; vertical-align: middle;">
                                                                        TAT EXEEDED REQUESTS
                                                                    </td>
                                                                    <td colspan="2" align="center" class="btn-blue2" style="font-family: 'Lucida Console';
                                                                        font-size: 15px; font-weight: bold; margin-top: 0px; text-align: center; vertical-align: middle;">
                                                                        SMTP DETAILS
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 70px">
                                                                    <td class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold;
                                                                        margin-top: 0px; text-align: center; max-width: 200px; vertical-align: middle;">
                                                                        TO
                                                                    </td>
                                                                    <td align="center" style="border-bottom: 2px solid rgba(32, 72, 131,1)">
                                                                        <asp:TextBox ID="TATTextTo" runat="server" TextMode="MultiLine" Width="340px" Height="60px"
                                                                            ClientIDMode="Static" class="lblStyleBold" Style="padding: 8px; text-transform: none;
                                                                            resize: none;" placeholder="Email-ID"></asp:TextBox>
                                                                    </td>
                                                                    <td class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold;
                                                                        margin-top: 0px; text-align: center; max-width: 200px; vertical-align: middle;">
                                                                        SERVER
                                                                    </td>
                                                                    <td align="center" style="border-bottom: 2px solid rgba(32, 72, 131,1)">
                                                                        <asp:TextBox ID="TextServer" runat="server" TextMode="MultiLine" Width="340px" Height="60px"
                                                                            ClientIDMode="Static" class="lblStyleBold" Style="padding: 8px; text-transform: none;
                                                                            resize: none;" placeholder="Host"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 70px;">
                                                                    <td class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold;
                                                                        margin-top: 0px; text-align: center; max-width: 200px; vertical-align: middle;">
                                                                        CC
                                                                    </td>
                                                                    <td align="center">
                                                                        <asp:TextBox ID="TATTextCC" runat="server" TextMode="MultiLine" Width="340px" Height="60px"
                                                                            ClientIDMode="Static" class="lblStyleBold" Style="padding: 8px; resize: none;
                                                                            text-transform: none;" placeholder="Email-IDs should be separated with (;)"></asp:TextBox>
                                                                    </td>
                                                                    <td class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold;
                                                                        margin-top: 0px; text-align: center; max-width: 200px; vertical-align: middle;">
                                                                        PORT
                                                                    </td>
                                                                    <td align="center">
                                                                        <asp:TextBox ID="TextPort" runat="server" TextMode="MultiLine" Width="340px" Height="60px"
                                                                            ClientIDMode="Static" class="lblStyleBold" Style="padding: 8px; text-transform: none;
                                                                            resize: none;" placeholder="Port"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10px" style="vertical-align: middle;">
                                                <img id="Img1" src="../Images/PortzoRight.png" alt='' style="padding: 5px 6px; box-shadow: 0px 2px 10px 2px rgb(30, 70, 129);
                                                    border-radius: 5px 0px 0px  5px; margin-right: -5px;" />
                                            </td>
                                        </tr>
                                    </table>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="ModalDone" class="modal fade" role="dialog">
                <div class="modal-dialogLoc" align="center">
                    <table style="margin-top: 100px;">
                        <tr>
                            <td>
                                <img id="ImgDone" src="images/TickN.PNG" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <!-----//end-main---->
        </center>
    </body>
</asp:Content>
