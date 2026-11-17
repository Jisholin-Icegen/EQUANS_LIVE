<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RequestGroup.aspx.cs" Inherits="Master_RequestGroup"
    EnableEventValidation="false" MasterPageFile="~/MasterPage/ChangePassword.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" runat="Server">
    <title>:: REQUEST GROUP ::</title>
    <link href="../Styles/Inner.css" rel="stylesheet" type="text/css" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="../Scripts/jquery-1.11.0.min.js" type="text/javascript"></script>
    <script src="../Scripts/bootstrap.min.js" type="text/javascript"></script>
    <script src="../Scripts/UserAction.js" type="text/javascript"></script>
    <script src="../Scripts/Master.js" type="text/javascript"></script>
    <script src="../Scripts/RequestGroup.js" type="text/javascript"></script>
    <link href="../Styles/Grid.css" rel="stylesheet" type="text/css" />
    <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">
        <script type="text/javascript">
            var ParentMenuService =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Service/ParentMenu.aspx?";
            var MAUrl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Master/Service/Service.aspx?";
            var RGBaseURL =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>';
            function ADDGROUP(Btn, EleID, DrpID, ImgID) {
                RGADDD(Btn, EleID, DrpID, ImgID, RGBaseURL);
            }
            function DELETEGROUP(ImgID, DrpID, txtID, Btn) {
                RGDELETE(ImgID, DrpID, txtID, Btn, RGBaseURL);
            }

            function Delete(id) {
                var confi = confirm('Press ok if your are sure.')
                if (confi == true)
                    return true;
                else
                    return false;
            }
            $(document).ready(function () {
                LoadPresetValues(RGBaseURL);
                RFclearDeptValues();
            });
            function GETRGroup(DeptID, Process) {

                GetRG(DeptID, Process, RGBaseURL);

            }

            function ADDRGroup(DeptID, Process) {

                ADDRG(DeptID, Process, RGBaseURL);

            }
            function OnchangeRGroup(InputID, ContainerID, Table) {

                OnchangeRG(InputID, ContainerID, RGBaseURL, Table);
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

                                    <td style="background-image: url('Images/ChildIcon/Zone.PNG'); background-repeat: no-repeat; background-position: center;" class="InnerAdminIcon SelectReqIcon" valign="middle" align="center" id="tdRgroup" onclick="Redirect('RequestGroup.aspx');">
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
                                            DEPARTMENT <br /> MASTER
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
                                        class="InnerAdminIcon"
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

                                                                <tr style="height: 60px;">
                                                                    <td colspan="6" align="center" class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold; margin-top: 0px; text-align: center; vertical-align: middle;">REQUEST GROUPS
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 70px;">
                                                                    <td align="center" colspan="6" style="vertical-align: middle; border-right: 2px solid rgba(32, 72, 131,1)">
                                                                        <asp:DropDownList ID="drpDept" runat="server" ClientIDMode="Static" Style="width: 320px; text-transform: uppercase; font-family: monospace; font-size: 12px; font-weight: bold; height: 40px;"
                                                                            onchange="OnChangeDropdownRG('drpDept','txtDept','btnDept','imgDeleteDept');">
                                                                            <asp:ListItem Value="0" Text="-Select-">  </asp:ListItem>
                                                                        </asp:DropDownList>
                                                                    </td>
                                                                </tr>
                                                                <tr style="">
                                                                    <td colspan="6" align="center">
                                                                        <table style="min-width: 500px;">
                                                                            <tr>
                                                                                <td align="center" style="vertical-align: middle" valign="middle">
                                                                                    <table width="340px">
                                                                                        <tr>
                                                                                            <td>
                                                                                                <asp:TextBox ID="txtDept" runat="server" TextMode="MultiLine" Width="195px"
                                                                                                    Height="30px" ClientIDMode="Static" class="lblStyleBold" Style="padding: 8px; resize: none; text-transform: none; margin-bottom: 10px;"
                                                                                                    placeholder="REQUEST GROUP"></asp:TextBox></td>
                                                                                            <td valign="middle" style="vertical-align: middle">
                                                                                                <input type="checkbox" name="chk24HRs" id="chk24HRs" />

                                                                                                <label for="chk24HRs">ISACTIVE</label>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td style="width: 130px; vertical-align: middle" valign="middle" align="left">
                                                                                    <table width="100%" style="height: 60px;">
                                                                                        <tr>
                                                                                            <td valign="middle" style="vertical-align: middle">
                                                                                                <button id="btnDept" style="color: white; font-size: 14pt; font-weight: bold; font-family: monospace; background-color: #1e4681; padding: 3px 10px; border-radius: 8px; border: none; cursor: pointer; outline: none"
                                                                                                    onclick="ADDGROUP(this,'txtDept','drpDept','imgDeleteDept');return false;">
                                                                                                    ADD
                                                                                                </button>
                                                                                            </td>
                                                                                            <td valign="middle" style="vertical-align: middle">
                                                                                                <img id="imgDeleteDept" src="Images/Delete.png" style="cursor: pointer; outline: none; visibility: hidden;"
                                                                                                    onclick="DELETEGROUP('imgDeleteDept','drpDept','txtDept','btnDept');return false;" />
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 60px">
                                                                    <td colspan="2" align="center" class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold; margin-top: 0px; text-align: center; vertical-align: middle;">LOCATIONS
                                                                    </td>
                                                                    <td colspan="2" align="center" class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold; margin-top: 0px; text-align: center; vertical-align: middle;">USERS
                                                                    </td>
                                                                    <td colspan="2" align="center" class="btn-blue2" style="font-family: 'Lucida Console'; font-size: 15px; font-weight: bold; margin-top: 0px; text-align: center; vertical-align: middle;">CATEGORY
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 70px;">
                                                                    <td align="center" style="vertical-align: middle" valign="middle">
                                                                        <table>
                                                                            <tr>
                                                                                <td>

                                                                                    <input type="text" id="txtLocation" name="txtLocation" autocomplete="off webauthn" autocorrect="off" style="outline: none; resize: none; padding: 8px; font-weight: lighter; font-size: 14px; width: 195px !important; border: 1px solid gray; margin-bottom: 0px  !important; border-radius: 0px !important; height: 28px;"
                                                                                        autocapitalize="off" spellcheck="false" class="lblStyleBold" placeholder="LOCATION"
                                                                                        onkeyup="OnchangeRGroup('txtLocation','DivLocContent','LOCATION');" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <div id="DivLocContent" class="Content" style="margin-top: 10px; min-height: 250px; height: 250px; width: 350px; overflow-y: auto; position: absolute; display: none">
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td style="width: 130px; vertical-align: middle; border-right: 2px solid rgba(32, 72, 131,1)"
                                                                        valign="middle" align="left">
                                                                        <table width="100%" style="height: 60px;">
                                                                            <tr>
                                                                                <td valign="middle" style="vertical-align: middle">
                                                                                    <button id="btnADDLocation" style="color: white; font-size: 14pt; font-weight: bold; font-family: monospace; background-color: #1e4681; padding: 3px 10px; border-radius: 8px; border: none; cursor: pointer; outline: none;"
                                                                                        onclick="ADDRGroup('txtLocation','LOCATION');return false;">
                                                                                        ADD
                                                                                    </button>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="center" style="vertical-align: middle" valign="middle">
                                                                        <table>
                                                                            <tr>
                                                                                <td>

                                                                                    <input type="text" id="txtUser" name="txtUser" autocomplete="off webauthn" autocorrect="off" style="outline: none; resize: none; padding: 8px; font-weight: lighter; font-size: 14px; width: 195px !important; border: 1px solid gray; margin-bottom: 0px  !important; border-radius: 0px !important; height: 28px;"
                                                                                        autocapitalize="off" spellcheck="false" class="lblStyleBold" placeholder="USER"
                                                                                        onkeyup="OnchangeRGroup('txtUser','DivUSERContent','USER');" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <div id="DivUSERContent" class="Content" style="margin-top: 10px; min-height: 250px; height: 250px; width: 350px; overflow-y: auto; position: absolute; display: none">
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td style="width: 130px; vertical-align: middle; border-right: 2px solid rgba(32, 72, 131,1)"
                                                                        valign="middle" align="left">
                                                                        <table width="100%" style="height: 60px;">
                                                                            <tr>
                                                                                <td valign="middle" style="vertical-align: middle">
                                                                                    <button id="btnADDUser" style="color: white; font-size: 14pt; font-weight: bold; font-family: monospace; background-color: #1e4681; padding: 3px 10px; border-radius: 8px; border: none; cursor: pointer; outline: none;"
                                                                                        onclick="ADDRGroup('txtUser','USER');return false;">
                                                                                        ADD
                                                                                    </button>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td align="center" style="vertical-align: middle" valign="middle">

                                                                        <table>
                                                                            <tr>
                                                                                <td>

                                                                                    <input type="text" id="txtPorter" name="txtPorter" autocomplete="off webauthn" autocorrect="off" style="outline: none; resize: none; padding: 8px; font-weight: lighter; font-size: 14px; width: 195px !important; border: 1px solid gray; margin-bottom: 0px  !important; border-radius: 0px !important; height: 28px;"
                                                                                        autocapitalize="off" spellcheck="false" class="lblStyleBold" placeholder="CATEGORY"
                                                                                        onkeyup="OnchangeRGroup('txtPorter','DivPortContent','CATEGORY');" />
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <div id="DivPortContent" class="Content" style="margin-top: 10px; min-height: 250px; height: 250px; width: 350px; overflow-y: auto; position: absolute; display: none">
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td style="width: 130px; vertical-align: middle; border-right: 2px solid rgba(32, 72, 131,1)"
                                                                        valign="middle" align="left">
                                                                        <table width="100%" style="height: 60px;">
                                                                            <tr>
                                                                                <td valign="middle" style="vertical-align: middle">
                                                                                    <button id="btnADDPorter" style="color: white; font-size: 14pt; font-weight: bold; font-family: monospace; background-color: #1e4681; padding: 3px 10px; border-radius: 8px; border: none; cursor: pointer; outline: none;"
                                                                                        onclick="ADDRGroup('txtPorter','CATEGORY');return false;">
                                                                                        ADD
                                                                                    </button>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr style="height: 70px">
                                                                    <td align="center" colspan="2" style="vertical-align: middle; border-right: 2px solid rgba(32, 72, 131,1)">
                                                                        <div id="divLocation" style="border: 1px dashed gray; width: 400px; height: 250px; min-width: 400px; min-height: 250px; overflow-y: auto; margin: 5px;">
                                                                        </div>
                                                                    </td>
                                                                    <td align="center" colspan="2" style="vertical-align: middle; border-right: 2px solid rgba(32, 72, 131,1)">
                                                                        <div id="divUsers" style="border: 1px dashed gray; width: 400px; height: 250px; min-width: 400px; min-height: 250px; overflow-y: auto; margin: 5px;">
                                                                    </td>

                                                                    <td align="center" colspan="2" style="vertical-align: middle; border-right: 2px solid rgba(32, 72, 131,1)">
                                                                        <div id="divPorters" style="border: 1px dashed gray; width: 400px; height: 250px; min-width: 400px; min-height: 250px; overflow-y: auto; margin: 5px;">
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
