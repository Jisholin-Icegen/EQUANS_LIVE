<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Bulk.aspx.cs" Inherits="Admin_Bulk" %>

<%--<%@ Register TagPrefix="telerik" Namespace="Telerik.QuickStart" %>--%>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Charting" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bulk</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css" />
    <script src="../js/jquery-3.6.4.min.js" type="text/javascript"></script>
    <script src="../js/ChangePassword.js" type="text/javascript"></script>
    <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">

        <script type="text/javascript">
            var ServiceCode = '1', EServiceCode = '', callFrom = 'Parent',
                ConProtocol = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>';
            $(document).ready(function () {
                ServiceCode = sessionStorage.getItem('ServiceCode');
                document.getElementById('HFUserID').value = sessionStorage.getItem('ID');
                document.getElementById('HFServiceCode').value = ServiceCode;

                $('.services-btn-icon').click(function () {
                    // Remove 'active' class from all buttons

                    ServiceCode = $(this).attr('id').replace("divService", ""); callFrom = 'Parent'

                    document.getElementById('HFServiceCode').value = ServiceCode;
                    setRootServices(this);
                    // Add 'active' class to the clicked button

                });

                if (ServiceCode == null)
                    $('.services-btn-icon').first().trigger('click');
                else {
                    ServiceCode = (ServiceCode == '0') ? "1" : ServiceCode;
                    sessionStorage.setItem('ServiceCode', ServiceCode);
                    document.getElementById('HFServiceCode').value = ServiceCode;
                    $('#divService' + ServiceCode).trigger('click');
                }

                getAccess();
            });


            function setRootServices(ele) {

                $('.services-btn-icon').removeClass('active');
                $(ele).addClass('active');
                // Get the rgb color of the clicked button
                var rgbColor = $(ele).data('color'); sessionStorage.setItem('ServiceCode', ServiceCode);
                // Convert rgb to rgba by appending the opacity
                var rgbaColor = rgbColor.replace('rgb', 'rgba').replace(')', ', 0.1)');

                // Set the new rgba color to the CSS variable
                $(':root').css('--active-color', rgbColor);
                $(':root').css('--active-bg-color', rgbaColor);
            }
        </script>
    </telerik:RadCodeBlock>
    <style type="text/css">
        div.RadUpload .ruBrowse {
            background-image: none;
            background-color: #000000;
            color: #FFFFFF;
            border-color: #fffffb; /* border-radius: 4px; */
            font-weight: bold;
        }

        .btnBkClrCls {
            background-color: #fffffb;
            color: #0a435a;
            border-color: #fffffb;
            border-radius: 4px;
            font-weight: bold;
        }

        .style2 {
            width: 60px;
            margin-left: 40px;
        }

        .style3 {
            height: 10px;
            width: 70px;
        }

        .style4 {
            width: 39px;
        }

        .style5 {
            width: 70px;
            margin-left: 10px;
            height: 71px;
            text-align: left;
        }

        .style6 {
            width: 39px;
            height: 71px;
        }

        .style7 {
            width: 72px;
            height: 71px;
        }

        .style8 {
            height: 43px;
        }

        .style9 {
            width: 70px;
            margin-left: 40px;
        }

        .style10 {
            width: 70px;
        }

        .RadUpload .ruFakeInput {
            height: 45px !important;
        }

        .RadUpload .ruFileWrap {
            height: 45px !important;
        }

        div.RadUpload .ruBrowse {
            background-color: #FF7400;
            border-color: #FF7400;
            color: white;
            padding: 10px 20px;
            transition: 0.5s;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            color: white;
            height: 45px;
        }
    </style>
</head>
<body style="background: #E5F1FF;">
    <form id="form1" runat="server">
        <div>
            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
            <asp:HiddenField ID="HFUserID" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="HFServiceCode" runat="server" ClientIDMode="Static" />

            <asp:Panel ID="panel1" runat="server" BackColor="#E5F1FF">

                <table style="width: 100%">
                    <tr>
                        <td>
                            <div class="navigation-tabs-wrapper" style="margin-top: 0px;">
                                <div class="services-button">
                                    <label>Services</label>
                                </div>
                                <div class="services-tabs-wrapper">
                                    <div class="services-btn-icon" data-color="rgb(255, 116, 0)" id="divService1">
                                        <img src="../images/porter-icon.svg" />
                                        <span>Porter</span>
                                    </div>
                                    <div class="services-btn-icon" data-color="rgb(12, 188, 139)" id="divService2">
                                        <img src="../images/cater-icon.svg" />
                                        <span>Cater</span>
                                    </div>
                                    <div class="services-btn-icon" data-color="rgb(110, 48, 243)" id="divService3">
                                        <img src="../images/clean-icon.svg" />
                                        <span>Clean</span>
                                    </div>
                                    <div class="services-btn-icon" data-color="rgb(255, 87, 51)" id="divService4">
                                        <img src="../images/pest-icon.svg" />
                                        <span>Feedback</span>
                                    </div>
                                    <div class="services-btn-icon" data-color="rgb(255, 87, 51)" id="divService5">
                                        <img src="../images/security-icon.svg" />
                                        <span>Security</span>
                                    </div>
                                </div>

                            </div>
                        </td>

                    </tr>
                    <tr>
                        <td>

                            <table style="width: 100%; height: 100%">
                                <tr style="height: 50px">
                                    <td colspan="4" style="text-align: center; font-weight: bold">Task </td>
                                </tr>
                                <tr>
                                    <td style="text-align: center"><b style="margin-left: 10px">Select File</b></td>
                                    <td></td>
                                    <td>
                                        <telerik:RadUpload ID="RadUploadTask" runat="server" InitialFileInputsCount="1" MaxFileInputsCount="1"
                                            ControlObjectsVisibility="None" MaxFileSize="20000000" Style="margin-left: 1px; margin-right: 0px;"
                                            Width="144px" Height="45px" />
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td>
                                        <asp:Button ID="btnHrTmp" runat="server" Text="Get Template" OnClick="btnTaskTmp_Click"
                                            CssClass="btn btn-secondary w-100" Style="margin-top: 12px" /></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td>
                                        <div class="col-sm-6">
                                            <asp:Button ID="btnHrSubmit" runat="server" Text="Submit" OnClick="btnTaskSubmit_Click" OnClientClick="javascript:document.getElementById(this.id).style.visibility = 'hidden';"
                                                CssClass="btn btn-secondary w-100" Style="margin-left: 5px" />
                                        </div>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <asp:Label ID="Errorlb" ForeColor="Red" Font-Bold="true" runat="server"></asp:Label></td>
                                </tr>

                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                    </tr>
                    <tr>
                        <td>
                            <table style="width: 100%; height: 100%">
                                <tr style="height: 50px">
                                    <td colspan="4" style="text-align: center; font-weight: bold">Break</td>
                                </tr>
                                <tr>
                                    <td style="text-align: center"><b style="margin-left: 10px">Select File</b></td>
                                    <td></td>
                                    <td>
                                        <telerik:RadUpload ID="RadUploadBreak" runat="server" InitialFileInputsCount="1" MaxFileInputsCount="1"
                                            ControlObjectsVisibility="None" MaxFileSize="20000000" Style="margin-left: 1px; margin-right: 0px;"
                                            Width="144px" Height="45px" />
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td>
                                        <asp:Button ID="btnBreakTmp" runat="server" Text="Get Template" OnClick="btnBreakTmp_Click"
                                            CssClass="btn btn-secondary w-100" Style="margin-top: 12px" /></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td>
                                        <div class="col-sm-6">
                                            <asp:Button ID="btnBreakSubmit" runat="server" Text="Submit" OnClick="btnBreakSubmit_Click" OnClientClick="javascript:document.getElementById(this.id).style.visibility = 'hidden';"
                                                CssClass="btn btn-secondary w-100" Style="margin-left: 5px" />
                                        </div>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <asp:Label ID="ErrorlbBreak" ForeColor="Red" Font-Bold="true" runat="server"></asp:Label></td>
                                </tr>

                            </table>
                        </td>
                    </tr>

                </table>




            </asp:Panel>
        </div>
    </form>
</body>
</html>
