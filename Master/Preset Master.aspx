<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Preset Master.aspx.cs" Inherits="Master_presetMaster"
    EnableEventValidation="false" MasterPageFile="~/MasterPage/ChangePassword.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" runat="Server">
    <title>:: PRE-SET MASTER ::</title>
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

            function ADD(Btn, EleID, Group, DrpID, ImgID) {
                var Ele = document.getElementById(EleID), ID = $('#' + DrpID).val(), Action = ($.trim($(Btn).text()) == 'ADD') ? 'INSERT' : 'UPDATE';
                if (Ele.value.length <= 0) {
                    Ele.focus();
                    return false;
                }
                else {
                    $.ajax({
                        url:  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>'
                            + "/Master/Service/Service.aspx?Process=PRESET&ACTION=" + Action + "&MSG=" + Ele.value + "&GROUP=" + Group + "&ID=" + ID,
                        type: 'POST',
                        data: 'pData',
                        dataType: 'json',
                        success: function (data) {
                            $("#" + DrpID).empty(); $("#" + DrpID).append($("<option     />").val('0').text('-SELECT-'));
                            $.each(data, function (key, value) {
                                $("#" + DrpID).append($("<option     />").val(value.ID).text(value.MESSAGE));
                            });
                            $(Ele).val(''); $(Btn).text('ADD'); $('#' + ImgID).css('visibility', 'hidden');
                        },
                        error: function (data) {

                        }

                    });

                }
            }
            function DELETE(ImgID, Group, DrpID, txtID) {
                var ID = $('#' + DrpID).val(), Action = 'DELETE';
                var textbox = document.getElementById(txtID);

                if (ID.length <= 0) {
                    $('#' + DrpID).focus();
                    return false;
                }
                else {
                    $.ajax({
                        url:  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>'
                            + "/Master/Service/Service.aspx?Process=PRESET&ACTION=" + Action + "&MSG=&GROUP=" + Group + "&ID=" + ID,
                        type: 'POST',
                        data: 'pData',
                        dataType: 'json',
                        success: function (data) {
                            $("#" + DrpID).empty(); $("#" + DrpID).append($("<option     />").val('0').text('-SELECT-'));
                            $.each(data, function (key, value) {
                                $("#" + DrpID).append($("<option     />").val(value.ID).text(value.MESSAGE));
                            });
                            $('#' + ImgID).css('visibility', 'hidden'); $(textbox).val('');
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


            function Delete(id) {
                var confi = confirm('Press ok if your are sure.')
                if (confi == true)
                    return true;
                else
                    return false;
            }
            $(document).ready(function () {
                LoadPresetValues();
            });

            function LoadPresetValues() {
                $.ajax({
                    url:  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>'
                        + "/Master/Service/Service.aspx?Process=PRESET&ACTION=GET&MSG=&GROUP=&ID=",
                    type: 'POST',
                    data: 'pData',
                    dataType: 'json',
                    success: function (data) {

                        var Msg = $.grep(data, function (element, index) {
                            return element.GROUPNAME == "MSG";
                        });
                        var Remarks = $.grep(data, function (element, index) {
                            return element.GROUPNAME == "REMARKS";
                        });

                        var Reason = $.grep(data, function (element, index) {
                            return element.GROUPNAME == "EREASON";
                        });

                        var CReason = $.grep(data, function (element, index) {
                            return element.GROUPNAME == "CREASON";
                        });

                        var FReason = $.grep(data, function (element, index) {
                            return element.GROUPNAME == "FREASON";
                        });

                        $("#drpTrackMsgs").empty(); $("#drpTrackMsgs").append($("<option     />").val('0').text('-SELECT-'));
                        $("#drpRemarks").empty(); $("#drpRemarks").append($("<option     />").val('0').text('-SELECT-'));
                        $("#drpEmgReason").empty(); $("#drpEmgReason").append($("<option     />").val('0').text('-SELECT-'));
                        $("#drpReasonCancel").empty(); $("#drpReasonCancel").append($("<option     />").val('0').text('-SELECT-'));
                        $("#drpFinishReason").empty(); $("#drpFinishReason").append($("<option     />").val('0').text('-SELECT-'));
                        $.each(Msg, function (key, value) {
                            $("#drpTrackMsgs").append($("<option     />").val(value.ID).text(value.MESSAGE));
                        });
                        $.each(Remarks, function (key, value) {
                            $("#drpRemarks").append($("<option     />").val(value.ID).text(value.MESSAGE));
                        });
                        $.each(Reason, function (key, value) {
                            $("#drpEmgReason").append($("<option     />").val(value.ID).text(value.MESSAGE));
                        });

                        $.each(CReason, function (key, value) {
                            $("#drpReasonCancel").append($("<option     />").val(value.ID).text(value.MESSAGE));
                        });
                        $.each(FReason, function (key, value) {
                            $("#drpFinishReason").append($("<option     />").val(value.ID).text(value.MESSAGE));
                        });
                    },
                    error: function (data) {

                    }

                });
            }

            function OnChangeDropdown(EleId, txtID, BtnId, DeleteID) {
                var drpValue = $('#' + EleId).val(), drpText = $("#" + EleId + " option:selected").text();
                $('#' + txtID).val((drpValue != '0') ? drpText : '');
                $('#' + BtnId).text((drpValue != '0') ? "UPDATE" : 'ADD');
                $('#' + DeleteID).css("visibility", (drpValue != '0') ? "visible" : 'hidden');

            }
        </script>
    </telerik:RadCodeBlock>
    <style>
        .rbDecorated {
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
                        <td style="width: 45vw"></td>
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
                                    <td align="center" valign="middle" style="background-image: url('Images/ChildIcon/Category.png'); background-repeat: no-repeat; background-position: center;"
                                        class="InnerAdminIcon"
                                        id="tdReqNew" onclick="Redirect('CategoryMaster.aspx');">
                                        <p class="InnerAdminText">
                                            Task Types
                                        </p>
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
                                    <td style="background-image: url('Images/ChildIcon/Zone.PNG'); background-repeat: no-repeat; background-position: center;" class="InnerAdminIcon" valign="middle" align="center" id="tdRgroup" onclick="Redirect('DeptMaster.aspx');">
                                        <p class="InnerAdminText">
                                            REQUEST
                                            <br />
                                            GROUP
                                        </p>
                                    </td>
                                    <td style="background-image: url('Images/ChildIcon/Floor.png'); background-repeat: no-repeat; background-position: center;"
                                        class="InnerAdminIcon" valign="middle" align="center"
                                        id="tdReqPending" onclick="Redirect('FloorMaster.aspx');">
                                        <p class="InnerAdminText">
                                            FLOOR MASTER
                                        </p>
                                    </td>
                                    <td style="background-image: url('Images/ChildIcon/Zone.png'); background-repeat: no-repeat; background-position: center;"
                                        class="InnerAdminIcon" valign="middle" align="center"
                                        id="tdReqAssigned" onclick="Redirect('LocationMaster.aspx');">
                                        <p class="InnerAdminText">
                                            DEPARTMENT
                                            <br />
                                            MASTER
                                        </p>
                                    </td>
                                    <td style="background-image: url('Images/ChildIcon/Porter.PNG'); background-repeat: no-repeat; background-position: center;"
                                        class="InnerAdminIcon" valign="middle" align="center"
                                        id="tdReqInProc" onclick="Redirect('PorterMaster.aspx');">
                                        <p class="InnerAdminText">
                                            PORTER MASTER
                                        </p>
                                    </td>
                                    <td style="border-radius: 0px 0px 0px 5px; background-image: url('Images/ChildIcon/Shift.PNG'); background-repeat: no-repeat; background-position: center;"
                                        class="InnerAdminIcon  SelectReqIcon"
                                        id="tdPreset" valign="middle" align="center" onclick="Redirect('Preset Master.aspx');">
                                        <p class="InnerAdminText">
                                            PRE-SET MASTER
                                        </p>
                                    </td>
                                    <td style="border-radius: 0px 0px 0px 5px; background-image: url('Images/ChildIcon/Shift.PNG'); background-repeat: no-repeat; background-position: center;"
                                        class="InnerAdminIcon"
                                        id="tdReqCompleted" valign="middle" align="center" onclick="Redirect('ShiftMaster.aspx');">
                                        <p class="InnerAdminText">
                                            SHIFT MASTER
                                        </p>
                                    </td>
                                    <td style="background-image: url('Images/ChildIcon/Tag.png'); background-repeat: no-repeat; background-position: center;"
                                        class="InnerAdminIcon" valign="middle" align="center"
                                        id="tdReqCancelled" onclick="Redirect('TagMaster.aspx');">
                                        <p class="InnerAdminText">
                                            TAG MASTER
                                        </p>
                                    </td>
                                    <td style="background-image: url('Images/ChildIcon/User.png'); background-repeat: no-repeat; background-position: center;"
                                        class="InnerAdminIcon" valign="middle" align="center"
                                        id="td3" onclick="Redirect('UserMaster.aspx');">
                                        <p class="InnerAdminText">
                                            USER MASTER
                                        </p>
                                    </td>
                                    <td style="border-radius: 0px 0px 0px 5px; background-image: url('Images/ChildIcon/Role.PNG'); background-repeat: no-repeat; background-position: center;"
                                        class="InnerAdminIcon"
                                        id="td1" valign="middle" align="center" onclick="Redirect('RoleMaster.aspx');">
                                        <p class="InnerAdminText">
                                            ROLE MASTER
                                        </p>
                                    </td>
                                    <td style="background-image: url('Images/ChildIcon/Settings.png'); background-repeat: no-repeat; background-position: center;"
                                        class="InnerAdminIcon" valign="middle" align="center"
                                        id="td2" onclick="Redirect('MailSettings.aspx');">
                                        <p class="InnerAdminText">
                                            SETTINGS
                                        </p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="background-image: url('../Images/Portzo.png'); background-position: center; background-repeat: no-repeat;">
                        <td colspan="3" align="center" style="vertical-align: middle;">
                            <asp:UpdatePanel ID="UptPnlRadGrid1" runat="server">
                                <ContentTemplate>
                                    <table style="width: 100%;">
                                        <tr>
                                            <td width="10px" style="vertical-align: middle;">
                                                <img id="ImgLeft" src="../Images/Portzoleft.png" alt='' style="padding: 5px 6px; box-shadow: 0px 2px 10px 2px rgb(30, 70, 129); border-radius: 0px 5px 5px 0px; margin-left: -5px;" />
                                            </td>
                                            <td id="TrackContent" align="center">
                                                <table>
                                                    <tr>
                                                        <td align="center" valign="middle">
                                                            <table width="80%" style="border-collapse: collapse; border: 10px solid rgba(32, 72, 131,1); border-top: 1px solid rgba(32, 72, 131,1); min-width: 830px; background-color: #ffffff; height: 300px;"
                                                                cellpadding="10" cellspacing="10">
                                                                <tr style="height: 60px">
                                                                    <td colspan="2" align="center" class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold; margin-top: 0px; text-align: center; vertical-align: middle;">MESSAGES - TRACK
                                                                    </td>
                                                                    <td colspan="2" align="center" class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold; margin-top: 0px; text-align: center; vertical-align: middle;">REMARKS - REQUEST
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 70px">
                                                                    <td align="center" colspan="2" style="vertical-align: middle; border-right: 2px solid rgba(32, 72, 131,1)">
                                                                        <asp:DropDownList ID="drpTrackMsgs" runat="server" ClientIDMode="Static" Style="width: 320px; text-transform: uppercase; font-family: monospace; font-size: 12px; font-weight: bold; height: 40px;"
                                                                            onchange="OnChangeDropdown('drpTrackMsgs','txtTrackMessages','BtnMsg','imgDeleteTrackMsgs');">
                                                                            <asp:ListItem Value="0" Text="-Select-">  </asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                    <td align="center" colspan="2" style="vertical-align: middle;">
                                                                        <asp:DropDownList ID="drpRemarks" runat="server" ClientIDMode="Static" Style="width: 320px; text-transform: uppercase; font-family: monospace; font-size: 12px; font-weight: bold; height: 40px;"
                                                                            onchange="OnChangeDropdown('drpRemarks','txtRequestRemarks','BtnRemarks','imgDeleteRemarks');">
                                                                            <asp:ListItem Value="0" Text="-Select-">  </asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 70px;">
                                                                    <td align="center" style="vertical-align: middle" valign="middle">
                                                                        <asp:TextBox ID="txtTrackMessages" runat="server" TextMode="MultiLine" Width="195px"
                                                                            Height="60px" ClientIDMode="Static" class="lblStyleBold" Style="padding: 8px; resize: none; margin-bottom: 10px;"
                                                                            placeholder="Message"></asp:TextBox>
                                                                    </td>
                                                                    <td style="width: 130px; vertical-align: middle; border-right: 2px solid rgba(32, 72, 131,1)"
                                                                        valign="middle" align="left">
                                                                        <table width="100%" style="height: 60px;">
                                                                            <tr>
                                                                                <td valign="middle" style="vertical-align: middle">
                                                                                    <button id="BtnMsg" style="color: white; font-size: 14pt; font-weight: bold; font-family: monospace; background-color: #1e4681; padding: 3px 10px; border-radius: 8px; border: none; cursor: pointer; outline: none;"
                                                                                        onclick="ADD(this,'txtTrackMessages','MSG','drpTrackMsgs','imgDeleteTrackMsgs');return false;">
                                                                                        ADD
                                                                                    </button>
                                                                                </td>
                                                                                <td valign="middle" style="vertical-align: middle">
                                                                                    <img id="imgDeleteTrackMsgs" src="Images/Delete.png" style="cursor: pointer; outline: none; visibility: hidden;"
                                                                                        onclick="DELETE('imgDeleteTrackMsgs','MSG','drpTrackMsgs','txtTrackMessages');return false;" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="center" style="vertical-align: middle" valign="middle">
                                                                        <asp:TextBox ID="txtRequestRemarks" runat="server" TextMode="MultiLine" Width="195px"
                                                                            Height="60px" ClientIDMode="Static" class="lblStyleBold" Style="padding: 8px; resize: none; text-transform: none;"
                                                                            placeholder="Remarks"></asp:TextBox>
                                                                    </td>
                                                                    <td style="width: 130px; vertical-align: middle" valign="middle" align="left">
                                                                        <table width="100%" style="height: 60px;">
                                                                            <tr>
                                                                                <td valign="middle" style="vertical-align: middle">
                                                                                    <button id="BtnRemarks" style="color: white; font-size: 14pt; font-weight: bold; font-family: monospace; background-color: #1e4681; padding: 3px 10px; border-radius: 8px; border: none; cursor: pointer; outline: none"
                                                                                        onclick="ADD(this,'txtRequestRemarks','REMARKS','drpRemarks','imgDeleteRemarks');return false;">
                                                                                        ADD
                                                                                    </button>
                                                                                </td>
                                                                                <td valign="middle" style="vertical-align: middle">
                                                                                    <img id="imgDeleteRemarks" src="Images/Delete.png" style="cursor: pointer; outline: none; visibility: hidden;"
                                                                                        onclick="DELETE('imgDeleteRemarks','REMARKS','drpRemarks','txtRequestRemarks');return false;" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 60px;">
                                                                    <td colspan="4" align="center" class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold; margin-top: 0px; text-align: center; vertical-align: middle;">REASON - BREAK
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 70px;">
                                                                    <td align="center" colspan="4" style="vertical-align: middle; border-right: 2px solid rgba(32, 72, 131,1)">
                                                                        <asp:DropDownList ID="drpEmgReason" runat="server" ClientIDMode="Static" Style="width: 320px; text-transform: uppercase; font-family: monospace; font-size: 12px; font-weight: bold; height: 40px;"
                                                                            onchange="OnChangeDropdown('drpEmgReason','txtReasonEmg','btnReasonEmg','imgDeleteReasonEmg');">
                                                                            <asp:ListItem Value="0" Text="-Select-">  </asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                </tr>
                                                                <tr >
                                                                    <td colspan="4" align="center">
                                                                        <table style="min-width: 50%;">
                                                                            <tr>
                                                                                <td align="center" style="vertical-align: middle" valign="middle">
                                                                                    <asp:TextBox ID="txtReasonEmg" runat="server" TextMode="MultiLine" Width="195px"
                                                                                        Height="60px" ClientIDMode="Static" class="lblStyleBold" Style="padding: 8px; resize: none; text-transform: none; margin-bottom: 10px;"
                                                                                        placeholder="Reason"></asp:TextBox>
                                                                                </td>
                                                                                <td style="width: 130px; vertical-align: middle" valign="middle" align="left">
                                                                                    <table width="100%" style="height: 60px;">
                                                                                        <tr>
                                                                                            <td valign="middle" style="vertical-align: middle">
                                                                                                <button id="btnReasonEmg" style="color: white; font-size: 14pt; font-weight: bold; font-family: monospace; background-color: #1e4681; padding: 3px 10px; border-radius: 8px; border: none; cursor: pointer; outline: none"
                                                                                                    onclick="ADD(this,'txtReasonEmg','EREASON','drpEmgReason','imgDeleteReasonEmg');return false;">
                                                                                                    ADD
                                                                                                </button>
                                                                                            </td>
                                                                                            <td valign="middle" style="vertical-align: middle">
                                                                                                <img id="imgDeleteReasonEmg" src="Images/Delete.png" style="cursor: pointer; outline: none; visibility: hidden;"
                                                                                                    onclick="DELETE('imgDeleteReasonEmg','EREASON','drpEmgReason','txtReasonEmg');return false;" />
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 60px">
                                                                    <td colspan="2" align="center" class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold; margin-top: 0px; text-align: center; vertical-align: middle;">REASON - CANCEL
                                                                    </td>
                                                                    <td colspan="2" align="center" class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold; margin-top: 0px; text-align: center; vertical-align: middle;">REASON - FINISH
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 70px">
                                                                    <td align="center" colspan="2" style="vertical-align: middle; border-right: 2px solid rgba(32, 72, 131,1)">
                                                                        <asp:DropDownList ID="drpReasonCancel" runat="server" ClientIDMode="Static" Style="width: 320px; text-transform: uppercase; font-family: monospace; font-size: 12px; font-weight: bold; height: 40px;"
                                                                            onchange="OnChangeDropdown('drpReasonCancel','txtReasonCancel','BtnMsgRCancel','imgDeleteRCancel');">
                                                                            <asp:ListItem Value="0" Text="-Select-">  </asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                    <td align="center" colspan="2" style="vertical-align: middle;">
                                                                        <asp:DropDownList ID="drpFinishReason" runat="server" ClientIDMode="Static" Style="width: 320px; text-transform: uppercase; font-family: monospace; font-size: 12px; font-weight: bold; height: 40px;"
                                                                            onchange="OnChangeDropdown('drpFinishReason','txtFinishReason','btnFinishReason','imgDeleteRFinish');">
                                                                            <asp:ListItem Value="0" Text="-Select-">  </asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 70px;">
                                                                    <td align="center" style="vertical-align: middle" valign="middle">
                                                                        <asp:TextBox ID="txtReasonCancel" runat="server" TextMode="MultiLine" Width="195px"
                                                                            Height="60px" ClientIDMode="Static" class="lblStyleBold" Style="padding: 8px; resize: none; margin-bottom: 10px;"
                                                                            placeholder="Message"></asp:TextBox>
                                                                    </td>
                                                                    <td style="width: 130px; vertical-align: middle; border-right: 2px solid rgba(32, 72, 131,1)"
                                                                        valign="middle" align="left">
                                                                        <table width="100%" style="height: 60px;">
                                                                            <tr>
                                                                                <td valign="middle" style="vertical-align: middle">
                                                                                    <button id="BtnMsgRCancel" style="color: white; font-size: 14pt; font-weight: bold; font-family: monospace; background-color: #1e4681; padding: 3px 10px; border-radius: 8px; border: none; cursor: pointer; outline: none;"
                                                                                        onclick="ADD(this,'txtReasonCancel','CREASON','drpReasonCancel','imgDeleteRCancel');return false;">
                                                                                        ADD
                                                                                    </button>
                                                                                </td>
                                                                                <td valign="middle" style="vertical-align: middle">
                                                                                    <img id="imgDeleteRCancel" src="Images/Delete.png" style="cursor: pointer; outline: none; visibility: hidden;"
                                                                                        onclick="DELETE('imgDeleteRCancel','CREASON','drpReasonCancel','txtReasonCancel');return false;" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="center" style="vertical-align: middle" valign="middle">
                                                                        <asp:TextBox ID="txtFinishReason" runat="server" TextMode="MultiLine" Width="195px"
                                                                            Height="60px" ClientIDMode="Static" class="lblStyleBold" Style="padding: 8px; resize: none; text-transform: none;"
                                                                            placeholder="Remarks"></asp:TextBox>
                                                                    </td>
                                                                    <td style="width: 130px; vertical-align: middle" valign="middle" align="left">
                                                                        <table width="100%" style="height: 60px;">
                                                                            <tr>
                                                                                <td valign="middle" style="vertical-align: middle">
                                                                                    <button id="btnFinishReason" style="color: white; font-size: 14pt; font-weight: bold; font-family: monospace; background-color: #1e4681; padding: 3px 10px; border-radius: 8px; border: none; cursor: pointer; outline: none"
                                                                                        onclick="ADD(this,'txtFinishReason','FREASON','drpFinishReason','imgDeleteRFinish');return false;">
                                                                                        ADD
                                                                                    </button>
                                                                                </td>
                                                                                <td valign="middle" style="vertical-align: middle">
                                                                                    <img id="imgDeleteRFinish" src="Images/Delete.png" style="cursor: pointer; outline: none; visibility: hidden;"
                                                                                        onclick="DELETE('imgDeleteRFinish','FREASON','drpFinishReason','txtFinishReason');return false;" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10px" style="vertical-align: middle;">
                                                <img id="Img1" src="../Images/PortzoRight.png" alt='' style="padding: 5px 6px; box-shadow: 0px 2px 10px 2px rgb(30, 70, 129); border-radius: 5px 0px 0px  5px; margin-right: -5px;" />
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
