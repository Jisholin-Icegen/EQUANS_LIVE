<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserUpLoad.aspx.cs" Inherits="Master_PorterUpload" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../Styles/Grid.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function GetValidSession() {
            if (sessionStorage.getItem('ROLE') == null) {
                window.close(); window.opener.location.reload(true);
                return false;
            }
            else
                return true;
        }

        function CloseWindow() {
            window.close();
        }
    </script>
    <title>:: USER UPLOAD :: </title>
</head>
<body ondragstart="return false;" ondrop="return false;" style="background-color: rgba(32, 72, 131,1);">
    <form id="form1" runat="server">
    <telerik:RadScriptManager ID="RadScriptManager" runat="server">
    </telerik:RadScriptManager>
    <div align="center">
        <table style="background-color: rgba(229, 229, 229, 1); width: 95%; margin: 16px 0px;
            font-size: 16pt; font-family: monospace; color: rgba(32, 72, 131,1);">
            <tr style="height: 50px;">
                <td valign="middle" class="Title" align="center" colspan="2">
                    USER UPLOAD
                </td>
            </tr>
            <tr style="height: 20px;">
                <td align="center">
                    <asp:Panel ID="pnlUserUpload" runat="server" align="center" DefaultButton="UpldBtn"
                        Style="background: none; min-height: 160px; width: 90%;">
                        <div align="center">
                            <table style="width: 100%; height: 20px;">
                                <tr>
                                    <td>
                                        <asp:Label ID="Errorlb" Font-Bold="true" ForeColor="Red" runat="server"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div align="center">
                            <table cellpadding="3" cellspacing="3">
                                <tr>
                                    <td style="width: 250px;" colspan="2">
                                    </td>
                                    <td>
                                        <telerik:RadButton ID="TmplBtn" runat="server" Text="GET TEMPLATE" CssClass="Button"
                                            ClientIDMode="Static" OnClientClicked="GetValidSession" OnClick="TmplBtn_Click">
                                        </telerik:RadButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 250px;" colspan="2">
                                        <asp:Label ID="lblSelect" Text="SELECT EXCEL FILE" Style="font-size: 15px;" runat="server"></asp:Label>
                                    </td>
                                    <td style="height: 30px;">
                                        <asp:FileUpload ID="FileUpload1" runat="server" CssClass="ButtonOut" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                    </td>
                                    <td colspan="2">
                                        <telerik:RadButton ID="UpldBtn" runat="server" Text="UPLOAD" CssClass="Button" ClientIDMode="Static"
                                            OnClientClicked="GetValidSession" OnClick="UpldBtn_Click">
                                        </telerik:RadButton>
                                        <telerik:RadButton ID="CanBtn" runat="server" Text="CANCEL" CssClass="Button" ClientIDMode="Static"
                                            OnClientClicked="CloseWindow">
                                        </telerik:RadButton>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </asp:Panel>
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
