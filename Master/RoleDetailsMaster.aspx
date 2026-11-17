<%@ Page Language="C#" AutoEventWireup="true" CodeFile="~/Master/RoleDetailsMaster.aspx.cs"
    Inherits="Master_RoleDetailsMaster" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="HeadRoleMaster" runat="server">
    <meta charset="utf-8">
    <title>:: ROLE MASTER ::</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="../Scripts/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="../Scripts/bootstrap.min.js" type="text/javascript"></script>
    <script src="../Scripts/Master.js" type="text/javascript"></script>
    <link href="../Styles/Grid.css" rel="stylesheet" type="text/css" />
    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
        <script type="text/javascript">
            var AdminServiceUrl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Master/Service/Service.aspx?",
                TreeID = '';
            $(document).ready(function () {
                OnLoadUpdation();
            });
            function validation(id) {
                var value = id.replace("btnUpdate", "");
                var category = document.getElementById(value + 'txtRoleName');
                if (category.value.length <= 0) {
                    category.focus();
                    return false;
                }
                else
                    return true;
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
    <style type="text/css">
        .tdParentMenu
        {
            height: 80px;
            width: 180px;
            background-color: rgb(30, 70, 129);
            text-align: center;
            vertical-align: middle;
            cursor: pointer;
            background-position: center;
            background-repeat: no-repeat;
            background-image: none;
            background-size: 80%;
        }
        .tdParentMenu:hover .ParentIconText
        {
            visibility: hidden;
        }
        .tdParentMenu:hover
        {
            height: 76px;
            width: 176px;
            background-color: #e5e5e5;
            border: 2px solid rgb(30, 70, 129);
        }
        
        .tdParentMenu:hover + .ParentIconText
        {
            visibility: hidden;
        }
        .ParentIconText
        {
            color: #ffffff !important;
            font-size: 15px !important;
        }
        .SelectTick
        {
            position: absolute;
            margin-left: 1px;
            margin-top: -30px;
            padding: 1px 2px;
            background-color: #e5e5e5;
            visibility: hidden;
        }
    </style>
</head>
<body ondragstart="return false;" ondrop="return false;" style="background-color: rgb(30, 70, 129);">
    <center>
        <form id="formRole" runat="server" autocomplete="off webauthn">
        <telerik:RadScriptManager ID="RadScriptManager" runat="server">
        </telerik:RadScriptManager>
        <table style="background-color: #e5e5e5; width: 95%; height: 95vh; margin: 16px 0px;
            font-size: 16pt; font-family: monospace; color: rgb(30, 70, 129);">
            <tr style="height: 50px;">
                <td valign="middle" class="Title" align="center" colspan="2">
                    ROLE DETAILS
                </td>
            </tr>
            <tr style="height: 20px;">
                <td valign="middle" class="Error" align="center" colspan="2">
                    <asp:Label ID="info" Visible="false" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr style="height: 50px;">
                <td align="left" colspan="2">
                    <table>
                        <tr>
                            <td style="width: 120px;">
                            </td>
                            <td style="width: 120px;">
                                <span style="font-size: 12pt;">ROLE NAME </span>
                            </td>
                            <td>
                                <asp:TextBox CssClass="toUpperCase" ID="TxtRoleName" runat="server" ClientIDMode="Static" >
                                </asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TxtRoleName"
                                    ErrorMessage="*">
                                </asp:RequiredFieldValidator>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <table border="0" width="100%">
                        <tr>
                            <td align="center">
                                <div>
                                    <table cellspacing='5' style="width: 380px; margin-top: 55px; border-collapse: separate;">
                                        <tr>
                                            <td class='tdParentMenu' style="background-image: url('../Images/ParentIcon/Request.PNG');"
                                                onclick="SelectPrivilage('RequestParentIconSelect','1');" id="RequestParentIcon">
                                                <div align="left">
                                                    <img src="Images/Tick.PNG" class="SelectTick" id="RequestParentIconSelect" /></div>
                                                <span class="ParentIconText">REQUEST</span>
                                            </td>
                                            <td class='tdParentMenu' style="background-image: url('../Images/ParentIcon/Admin.PNG');"
                                                onclick="SelectPrivilage('AdminIconSelect','5');" id="AdminIcon">
                                                <div align="left">
                                                    <img src="Images/Tick.PNG" class="SelectTick" id="AdminIconSelect" /></div>
                                                <span class="ParentIconText">ADMIN</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" align="center">
                                                <table>
                                                    <tr>
                                                        <td class='tdParentMenu' style="background-image: url('../Images/ParentIcon/Reports.PNG');"
                                                            onclick="SelectPrivilage('ReportIconSelect','4');" id="ReportIcon">
                                                            <div align="left">
                                                                <img src="Images/Tick.PNG" class="SelectTick" id="ReportIconSelect" /></div>
                                                            <span class="ParentIconText">REPORT</span>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class='tdParentMenu' style="background-image: url('../Images/ParentIcon/AssignTag.PNG');"
                                                onclick="SelectPrivilage('AssignTagIconSelect','2');" id="AssignTagIcon">
                                                <div align="left">
                                                    <img src="Images/Tick.PNG" class="SelectTick" id="AssignTagIconSelect" /></div>
                                                <span class="ParentIconText">ASSIGN TAG</span>
                                            </td>
                                            <td class='tdParentMenu' style="background-image: url('../Images/ParentIcon/Track.PNG');"
                                                onclick="SelectPrivilage('TrackIconSelect','3');" id="TrackIcon">
                                                <div align="left">
                                                    <img src="Images/Tick.PNG" class="SelectTick" id="TrackIconSelect" /></div>
                                                <span class="ParentIconText">TRACK</span>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 20px;">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="height: 100px;">
                <td>
                    &nbsp;
                </td>
                <td style="text-align: center;">
                    <telerik:RadButton ID="SaveBtn" runat="server" Text="SAVE" CssClass="Button" ClientIDMode="Static"
                        OnClientClicked="SaveRole">
                    </telerik:RadButton>
                    <telerik:RadButton ID="Delete" runat="server" Text="DELETE" CssClass="Button" Style="display: none"
                        ClientIDMode="Static" OnClientClicked="DeleteRole">
                    </telerik:RadButton>
                    <telerik:RadButton ID="CancelBtn" runat="server" Text="CANCEL" CssClass="Button"
                        ClientIDMode="Static" CausesValidation="false" OnClientClicked="cancelWindow">
                    </telerik:RadButton>
                </td>
            </tr>
        </table>
        <div id="ModalDone" class="modal fade" role="dialog">
            <div class="modal-dialogLoc" align="center">
                <table style="margin-top: 100px;">
                    <tr>
                        <td>
                            <img id="ImgDone" src="images/Tick.png" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div id="ModalErrorMsg" class="modal fade" role="dialog">
            <div class="modal-dialogLoc" align="center" style="max-width: 90%;">
                <table style="margin-top: 100px;">
                    <tr>
                        <td>
                            <span id="spErrormessage" class="NoPorter">ROLE MAY BE IN USE.</span>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        </form>
    </center>
</body>
</html>
