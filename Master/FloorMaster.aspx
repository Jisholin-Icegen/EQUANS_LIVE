<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FloorMaster.aspx.cs" Inherits="Master_FloorMaster"
    MasterPageFile="~/MasterPage/ChangePassword.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" runat="Server">
    <title>:: FLOOR MASTER ::</title>
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
            function validation(id) {
                var value = id.replace("btnUpdate", "");
                var category = document.getElementById(value + 'txtFloorName');
                if (category.value.length <= 0) {
                    category.focus();
                    return false;
                }
                else
                    return true;
            }
            //function ShowCloseDialog() {
            //    $find('mpDone').show();
            //    setTimeout("CloseDone();", 1000);
            //}
            //function CloseDone() {
            //    $find('mpDone').hide();
            //}
            function Delete(id) {
                var confi = confirm('Press ok if your are sure.')
                if (confi == true)
                    return true;
                else
                    return false;
            }
        </script>
        <link href="../Styles/Grid.css" rel="stylesheet" type="text/css" />
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
                                    <td style="background-image: url('Images/ChildIcon/Floor.png'); background-repeat: no-repeat; background-position: center;"
                                        class="InnerAdminIcon  SelectReqIcon" valign="middle"
                                        align="center" id="tdReqPending" onclick="Redirect('FloorMaster.aspx');">
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
                                            MAIL SETTINGS
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
                                    <table style="width: 100%; height: 500px;">
                                        <tr>
                                            <td width="10px" style="vertical-align: middle;">
                                                <img id="ImgLeft" src="../Images/Portzoleft.png" alt='' style="padding: 5px 6px; box-shadow: 0px 2px 10px 2px rgb(30, 70, 129); border-radius: 0px 5px 5px 0px; margin-left: -5px;" />
                                            </td>
                                            <td id="TrackContent" align="center">
                                                <table style='width: 100%; margin-top: 20px;'>
                                                    <tr style="height: 450px;">
                                                        <td align="center" style="padding-top: 10px;">
                                                            <div align="center">
                                                                <div align="center">
                                                                    <telerik:RadGrid ID="RadGrid1" runat="server" AllowSorting="true" AllowPaging="true"
                                                                        OnItemCommand="RadGrid1_ItemCommand" OnItemDataBound="RadGrid1_ItemDataBound"
                                                                        OnInsertCommand="RadGrid1_InsertCommand" OnUpdateCommand="RadGrid1_UpdateCommand"
                                                                        OnDeleteCommand="RadGrid1_DeleteCommand" AllowMultiRowEdit="false" AutoGenerateColumns="false"
                                                                        Style="height: 430px; width: 1000px; background-color: white;" Skin="Metro">
                                                                        <PagerStyle AlwaysVisible="True" Position="Top" />
                                                                        <ItemStyle CssClass="ReportFont" HorizontalAlign="Center" />
                                                                        <AlternatingItemStyle CssClass="ReportFont" HorizontalAlign="Center" />
                                                                        <ClientSettings>
                                                                            <Scrolling UseStaticHeaders="true" AllowScroll="true" SaveScrollPosition="true" ScrollHeight="420px" />
                                                                            <Resizing ResizeGridOnColumnResize="true" />
                                                                        </ClientSettings>
                                                                        <ExportSettings>
                                                                            <Pdf FontType="Subset" PaperSize="Letter" />
                                                                            <Excel Format="Html" />
                                                                            <Csv ColumnDelimiter="Colon" RowDelimiter="NewLine" />
                                                                        </ExportSettings>
                                                                        <MasterTableView Width="100%" HeaderStyle-HorizontalAlign="Left" Name="MasterGrid"
                                                                            CommandItemDisplay="Top" DataKeyNames="FLOORID,FLOORNAME,FLOORORDER,ISACTIVE" TableLayout="Fixed"
                                                                            NoMasterRecordsText="NO REQUEST FOUND." PageSize="15" InsertItemPageIndexAction="ShowItemOnFirstPage">
                                                                            <CommandItemTemplate>
                                                                                <table width="30%" align="right">
                                                                                    <tr>
                                                                                        <td align="center">
                                                                                            <table>
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <%--      <asp:ImageButton ID="ImgAdd" runat="server" ImageUrl="Images/Add.png" CommandName='InitInsert' />--%>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </CommandItemTemplate>
                                                                            <Columns>
                                                                                <telerik:GridEditCommandColumn ButtonType="ImageButton" HeaderText="Edit" EditImageUrl="~/Images/Edit.png">
                                                                                    <HeaderStyle />
                                                                                </telerik:GridEditCommandColumn>
                                                                                <telerik:GridBoundColumn UniqueName="FLOORNAME" HeaderText="FLOOR NAME" DataField="FLOORNAME">
                                                                                    <HeaderStyle />
                                                                                </telerik:GridBoundColumn>
                                                                                <telerik:GridBoundColumn UniqueName="FLOORORDER" HeaderText="FLOOR ORDER" DataField="FLOORORDER">
                                                                                    <HeaderStyle />
                                                                                </telerik:GridBoundColumn>
                                                                                <telerik:GridTemplateColumn UniqueName="ISACTIVE" HeaderText="ACTIVE">
                                                                                    <ItemTemplate>
                                                                                        <asp:CheckBox ID="ChkActive" runat="server" Enabled="false" />
                                                                                    </ItemTemplate>
                                                                                </telerik:GridTemplateColumn>
                                                                            </Columns>
                                                                            <EditFormSettings EditFormType="Template">
                                                                                <EditColumn UniqueName="EditCommandColumn1">
                                                                                </EditColumn>
                                                                                <FormTemplate>
                                                                                    <div align="center">
                                                                                        <table id="Table2" cellspacing="0" cellpadding="0" width="50%" style="border: none; max-width: 500px;"
                                                                                            rules="none" runat="server" class="TbleStyle">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <asp:Panel ID="pnlAssetType" runat="server" align="center" DefaultButton="btnUpdate"
                                                                                                        Style="background: none;">
                                                                                                        <br />
                                                                                                        <table cellspacing="3px" cellpadding="3px" style="width: 390px; height: 130px;">
                                                                                                            <tr>
                                                                                                                <td colspan="2">
                                                                                                                    <asp:Label ID="lblmsg" Visible="false" runat="server" CssClass="Error"></asp:Label>
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td style="vertical-align: middle">
                                                                                                                    <asp:Label ID="lblLocName" runat="server" Text="FLOOR NAME" CssClass="lblStyleBold"></asp:Label>
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <asp:TextBox CssClass="ConfigFont" ID="txtFloorName" TextMode="MultiLine" ReadOnly="false"
                                                                                                                        TabIndex="1" Width="200px" Font-Size="14px" runat="server" Style="height: 40px; resize: none; padding: 5px;"
                                                                                                                        ValidationGroup="Save"></asp:TextBox>
                                                                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtFloorName"
                                                                                                                        ErrorMessage="*" ValidationGroup="Save" Style="color: red; font-family: monospace; visibility: visible; font-size: 23px;"
                                                                                                                        InitialValue="" SetFocusOnError="true">
                                                                                                                    </asp:RequiredFieldValidator>
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td style="vertical-align: middle">
                                                                                                                    <asp:Label ID="LBLFloorNo" runat="server" Text="FLOOR ORDER" CssClass="lblStyleBold"></asp:Label>
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <asp:DropDownList CssClass="ConfigFont" ID="DrpFloorOrder" TabIndex="2" Width="120px"
                                                                                                                        runat="server" Style="font-size: 12px; padding: 5px; height: 25px;">
                                                                                                                    </asp:DropDownList>
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                            <tr>
                                                                                                                <td>
                                                                                                                    <asp:Label ID="LbLIsActive" runat="server" Text="IS ACTIVE" CssClass="lblStyleBold"></asp:Label>
                                                                                                                </td>
                                                                                                                <td>
                                                                                                                    <asp:CheckBox ID="ChkActive" runat="server" />
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                        </table>
                                                                                                        <br />
                                                                                                    </asp:Panel>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td align="center">
                                                                                                    <telerik:RadButton ID="btnUpdate" CssClass="Button" ValidationGroup="Save" Text="UPDATE"
                                                                                                        OnClientClick="javascript:return validation(this.id);" runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>' />
                                                                                                    <telerik:RadButton ID="Btndelete" CssClass="Button" Text="DELETE" OnClientClick="javascript:return Delete(this.id)"
                                                                                                        runat="server" CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformDelete" : "Delete" %>' />
                                                                                                    <telerik:RadButton ID="btnCancel" CssClass="Button" Text="CANCEL" runat="server"
                                                                                                        CausesValidation="False" CommandName="Cancel" />
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                        <br />
                                                                                    </div>
                                                                                </FormTemplate>
                                                                            </EditFormSettings>
                                                                        </MasterTableView>
                                                                    </telerik:RadGrid>
                                                                    <asp:Panel ID="PanelDone" runat="server" align="center" Style="display: none; width: 25%;">
                                                                        <div id="Div1" clientidmode="Static" align="center" runat="server" class="Shadow">
                                                                            <div class="header" align="center" style="height: 15px;">
                                                                                <table width="100%" style="margin-top: -6px;">
                                                                                    <tr>
                                                                                        <td width="20%"></td>
                                                                                        <td align="center">
                                                                                            <asp:Label ID="Label3" runat="server" Font-Size="14px" CssClass="Configheader"> DONE </asp:Label>
                                                                                        </td>
                                                                                        <td width="20%">
                                                                                            <asp:ImageButton ID="ClosePanelDone" runat="server" ImageUrl="~/Images/close.png"
                                                                                                Style="cursor: pointer; float: right; margin-right: 8px; width: 15px; height: 15px;"></asp:ImageButton>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                            </div>
                                                                            <div class="headFoot" style="height: 0px; margin-top: -2px;">
                                                                            </div>
                                                                            <div class="Content">
                                                                                <table cellpadding="7" cellspacing="3" width="100%">
                                                                                    <tr style="height: 50px;">
                                                                                        <td align="center">
                                                                                            <asp:Image ID="ImageWarning" runat="server" Style="width: 35px; outline: none; margin-top: 10px;"
                                                                                                ImageUrl="Images/Category/Tick.png" />
                                                                                        </td>
                                                                                        <td width="80%" style="vertical-align: middle">
                                                                                            <asp:Label ID="LBLResult" ClientIDMode="Static" runat="server" Style="font-size: 11px; color: rgba(32, 72, 131,1);"> </asp:Label>
                                                                                        </td>
                                                                                    </tr>
                                                                                </table>
                                                                                <br />
                                                                            </div>
                                                                        </div>
                                                                        <ajaxToolkit:ModalPopupExtender ID="mpDone" runat="server" BehaviorID="mpDone" PopupControlID="PanelDone"
                                                                            TargetControlID="Label5" CancelControlID="ClosePanelDone" BackgroundCssClass="modalBackground">
                                                                        </ajaxToolkit:ModalPopupExtender>
                                                                        <asp:Label ID="Label5" runat="server"></asp:Label>
                                                                    </asp:Panel>
                                                                </div>
                                                            </div>
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
            <div id="ModalLoading" class="modal" role="dialog" style="display: none; padding-right: 17px; background-color: #000000b3;">
                <div class="modal-dialogLoc" align="center">
                    <table style="margin-top: 100px;">
                        <tr>
                            <td>
                                <img id="LoadingGif" style="width: 80px; border-radius: 5px;"
                                    src="Images/LoadingN.gif" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <!-----//end-main---->
        </center>
    </body>
</asp:Content>
