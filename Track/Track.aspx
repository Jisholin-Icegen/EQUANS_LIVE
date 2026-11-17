<%@ Page Title=":: LIVE TRACKING :: " Language="C#" MasterPageFile="~/MasterPage/MasterPage.master"
    AutoEventWireup="true" CodeFile="Track.aspx.cs" Inherits="Track_Track" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentBody" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <telerik:RadCodeBlock ID="RDCB1" runat="server">
        <script type="text/javascript">,
            var ConProtocol = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>';
            clearInterval(Reload);
            var Reload = window.setInterval(ShowPorter, 1000), TagID = "";
            $(document).ready(function () {
                $('#PName').val('');
                ShowPorter();
            });
            function ShowPorter() {
                $.ajax({
                    url:  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Service/Service.aspx?Process=PORTERWITHLOCAITON&NAME=" + $('#PName').val(),
                    type: 'POST',
                    data: 'pData',
                    dataType: 'json',
                    success: function (data) {
                        $find('<%= GridRequest.ClientID %>').clearSelectedItems();
                        tableView = $find('<%= GridRequest.ClientID %>').get_masterTableView();
                        tableView.set_dataSource(data);
                        tableView.dataBind();
                    },
                    error: function (data) {

                    }

                });
            }

            function RowCreated(sender, args) {
                args.get_item().get_cell('ColMessage').onclick = function () {
                    var Name = args.get_item().getDataKeyValue("NAME"); TagID = args.get_item().getDataKeyValue("TAGID");
                    $('#MessageTo').text(Name);
                    $find('mpMessage').show();
                    $('#TextMessage').focus();
                };
                args.get_item().get_cell('BREAK').onclick = function () {
                    var ECell = args.get_item().get_cell('BREAK'), Value = $(ECell).html();
                    if (Value == "-")
                        return;
                    else {
                        var PorterId = args.get_item().getDataKeyValue("PORTERID");
                        $.ajax({
                            url:  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Service/Service.aspx?Process=BREAK&PORTERID=" + PorterId + "",
                            type: 'POST',
                            data: 'pData',
                            dataType: 'json',
                            success: function (data) {
                                if (data[0].RESULT === 'TRUE')
                                    ShowPorter();
                                else {
                                    $('#LebalDone').html('WARNING');
                                    $('#ImageWarning').attr("src", "../Images/Warning.png");
                                    $('#LBLResult').html('NO MORE BREAKS FOR THIS PORTER.');
                                    ShowMessage();
                                }
                            },
                            error: function (data) {

                            }

                        });
                    }
                };
                args.get_item().get_cell('BUZZER').onclick = function () {
                    $find('MPWait').show();
                    var Name = args.get_item().getDataKeyValue("NAME"); TagID = args.get_item().getDataKeyValue("TAGID");
                    $.ajax({
                        url:  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Service/Service.aspx?Process=BUZZER" + "&TAGID=" + TagID + "",
                        type: 'POST',
                        data: 'pData',
                        dataType: 'json',
                        success: function (data) {
                            if (data[0].RESULT === 'TRUE') {
                                $('#LBLResult').html('BUZZER SENT');
                                $find('mpDone').show();
                                setTimeout("MsgDone();", 1000);
                            }
                        },
                        error: function (data) {

                        }

                    });
                };
                args.get_item().get_cell('LOCATE').onclick = function () {
                    var LTagId = args.get_item().getDataKeyValue("TAGID"), PName = args.get_item().getDataKeyValue("NAME"), wind = window.open('Popup.aspx?TagId=' + LTagId + "&Name=" + PName, 'TRACKING : #' + PName, 'directories=no,titlebar=yes,toolbar=no,location=no,status=no,menubar=no,scrollbars=no,resizable=no,width=1000,height=500');
                };
                args.get_item().get_cell('ENDSHIFT').onclick = function () {
                    var ECell = args.get_item().get_cell('ENDSHIFT'), Value = $(ECell).html();
                    if (Value == "ON-HOLD")
                        return;
                    else {
                        var ETagId = args.get_item().getDataKeyValue("TAGID");
                        if (confirm('Press ok if you are sure to end the shift.')) {
                            $.ajax({
                                url:  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Service/Service.aspx?Process=SHIFTEND" + "&TAGID=" + ETagId + "",
                                type: 'POST',
                                data: 'pData',
                                dataType: 'json',
                                success: function (data) {
                                    if (data[0].RESULT === 'TRUE') {
                                        $('#LebalDone').html('DONE');
                                        $('#ImageWarning').attr("src", "../Images/Done.png");
                                        $('#LBLResult').html('SHIFT ENDED');
                                    }
                                    else {
                                        $('#LebalDone').html('WARNING');
                                        $('#ImageWarning').attr("src", "../Images/Warning.png");
                                        $('#LBLResult').html('ASSIGNED TASKS NOT YET COMPLETED.');
                                    }
                                    ShowMessage();
                                },
                                error: function (data) {

                                }

                            });
                        }
                    }
                };
            }
            function ShowMessage() {

                $find('mpDone').show();
                setTimeout("MsgDone();", 1000);
            }
            function DataBound(sender, args) {
                var IsBreak = args.get_item().getDataKeyValue("ISBREAK"), cell = args.get_item().get_cell('BREAK'), EndHold = args.get_item().getDataKeyValue("ENDHOLD"), cellEnd = args.get_item().get_cell('ENDSHIFT');
                if (EndHold == '1') {
                    $(cellEnd).html('ON-HOLD');
                    $(cell).html('-').css("cursor", "text");
                }
                else {
                    $(cellEnd).css("cursor", "pointer");
                    if (IsBreak)
                        $(cell).html('<img src="../Images/Checked.png" width="20" height="20">')
                    else
                        $(cell).html('<img src="../Images/Unchecked.png" width="20" height="20">')
                }
            }
            function BuzzerAll() {
                $find('MpBroadCast').hide();
                $find('MPWait').show();
                $.ajax({
                    url:  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Service/Service.aspx?Process=BUZZERALL",
                    type: 'POST',
                    data: 'pData',
                    dataType: 'json',
                    success: function (data) {
                        if (data[0].RESULT === 'TRUE') {
                            $('#LBLResult').html('BUZZER SENT');
                            $find('mpDone').show();
                            setTimeout("MsgDone();", 1000);
                        }
                    },
                    error: function (data) {

                    }

                });
            }
            function SendMessage() {
                if ($('#TextMessage').val().length == 0) { $('#TextMessage').focus(); return; }
                var Message = sessionStorage.getItem('NAME').toUpperCase() + '  : ' + $('#TextMessage').val().replace(/\?/g, '^').replace(/\&/g, '~');
                $find('mpMessage').hide(); $find('MpBroadCast').hide();
                $find('MPWait').show();
                $.ajax({
                    url:  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Service/Service.aspx?Process=" + (($('#MessageTo').text() == 'ALL') ? 'SENDMESSAGEALL' : 'SENDMESSAGE') + "&TAGID=" + TagID + "&MESSAGE= " + Message + "",
                    type: 'POST',
                    data: 'pData',
                    dataType: 'json',
                    success: function (data) {
                        if (data[0].RESULT === 'TRUE') {
                            $('#LBLResult').html('MESSAGE SENT');
                            $find('mpDone').show();
                            setTimeout("MsgDone();", 1000);
                        }
                    },
                    error: function (data) {

                    }

                });
            }
            function MsgDone() {
                $find('MPWait').hide();
                setTimeout("hideMPDone();", 1000)
            }
            function hideMPDone() {
                $('#TextMessage').val('');
                $find('mpDone').hide();
            }

        </script>
        <style type="text/css">
            .RadGrid_Default .rgHeaderDiv {
                background: none !important;
                color: none !important;
            }

            .RadGrid_Default {
                background: none !important;
            }
        </style>
    </telerik:RadCodeBlock>
    <div align="center">
        <table width="85%">
            <tr>
                <td style="padding-left: 30px;">
                    <a>
                        <table>
                            <tr>
                                <td>
                                    <img src="../Images/Group.png" onclick="javascript:$find('MpBroadCast').show();return false;"
                                        width="45" height="40" style="cursor: pointer;" class="BroadCastMain" />
                                </td>
                            </tr>
                        </table>
                    </a>
                </td>
                <td style="width: 80%;">
                    <table cellpadding="10" cellspacing="10" class="Configheader" align="right">
                        <tr>
                            <td style="font-size: 14px;">PORTER :
                            </td>
                            <td>
                                <asp:TextBox ID="PName" ClientIDMode="Static" runat="server" Width="160px" Font-Size="8pt"
                                    Height="20px" class="ConfigFont" Style="border: 2px thin #014454; border-radius: 5px; padding: 5px;"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <telerik:RadGrid ID="GridRequest" runat="server" AllowSorting="false" AutoGenerateColumns="false"
                        Width="100%" Style="height: 80vh">
                        <HeaderStyle />
                        <PagerStyle AlwaysVisible="true" />
                        <ItemStyle HorizontalAlign="Center" />
                        <AlternatingItemStyle HorizontalAlign="Center" />
                        <ClientSettings EnableRowHoverStyle="true">
                            <Scrolling AllowScroll="True" SaveScrollPosition="true" ScrollHeight="600px" UseStaticHeaders="true"></Scrolling>
                            <ClientEvents OnRowCreated="RowCreated" OnRowDataBound="DataBound" />
                            <Selecting AllowRowSelect="true" CellSelectionMode="None" />
                        </ClientSettings>
                        <MasterTableView ClientDataKeyNames="PORTERID,NAME,FLOOR,ZONE,BATTERYLEVEL,TAGID,ISBREAK,ENDHOLD"
                            NoMasterRecordsText="NO REQUEST FOUND." TableLayout="Fixed">
                            <NoRecordsTemplate>
                                <div class="LinkFont" style="padding-left: 10%">
                                    NO PORTER FOUND.
                                </div>
                            </NoRecordsTemplate>
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="PORTER" DataField="NAME" UniqueName="NAME">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="FLOOR" DataField="FLOOR" UniqueName="FLOOR">
                                    <HeaderStyle />
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="ZONE" DataField="ZONE" UniqueName="ZONE">
                                    <HeaderStyle />
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="TAG ID" DataField="ID" UniqueName="ID">
                                    <HeaderStyle />
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="BATTERY LEVEL" DataField="BATTERYLEVEL" UniqueName="BATTERYLEVEL">
                                    <HeaderStyle />
                                </telerik:GridBoundColumn>
                                <telerik:GridImageColumn HeaderText="BREAK" UniqueName="BREAK" ImageUrl="../Images/Unchecked.png"
                                    HeaderStyle-Width="80px" ImageWidth="20px" ImageHeight="20px">
                                </telerik:GridImageColumn>
                                <telerik:GridBoundColumn HeaderText="BREAK END-TIME" DataField="ENDTIME" UniqueName="ENDTIME">
                                    <HeaderStyle />
                                </telerik:GridBoundColumn>
                                <telerik:GridImageColumn HeaderText="MESSAGE" UniqueName="ColMessage" ImageUrl="../Images/msgIcon.png"
                                    HeaderStyle-Width="100px" ImageWidth="25px" ImageHeight="20px">
                                </telerik:GridImageColumn>
                                <telerik:GridImageColumn HeaderText="BUZZER" UniqueName="BUZZER" ImageUrl="../Images/Buzzer.png"
                                    HeaderStyle-Width="80px" ImageWidth="28px" ImageHeight="23px">
                                </telerik:GridImageColumn>
                                <telerik:GridImageColumn HeaderText="LOCATE" UniqueName="LOCATE" ImageUrl="../Images/Map.png"
                                    HeaderStyle-Width="80px" ImageWidth="25px" ImageHeight="25px">
                                </telerik:GridImageColumn>
                                <telerik:GridImageColumn HeaderText="END SHIFT" UniqueName="ENDSHIFT" ImageUrl="../Images/close.png"
                                    HeaderStyle-Width="100px" ImageWidth="20px" ImageHeight="20px">
                                </telerik:GridImageColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:RadGrid>
                </td>
            </tr>
        </table>
        <asp:Panel ID="PanelBroadCast" runat="server" align="center" Style="display: none; width: 30%; max-width: 250px;">
            <div id="Div2" clientidmode="Static" align="center" runat="server" class="Shadow">
                <div class="header" align="center" style="height: 15px;">
                    <table width="100%" style="margin-top: -6px;">
                        <tr>
                            <td width="20%"></td>
                            <td align="center">
                                <asp:Label ID="Label2" runat="server" Font-Size="15px" ClientIDMode="Static" CssClass="Configheader"> BROADCAST </asp:Label>
                            </td>
                            <td width="20%">
                                <asp:ImageButton ID="BtnCloseBroadCast" runat="server" ImageUrl="~/Images/close.png"
                                    Style="cursor: pointer; float: right; margin-right: 8px; width: 15px; height: 15px;"></asp:ImageButton>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="headFoot" style="height: 0px; margin-top: -2px;">
                </div>
                <div id="DivBroadCast" runat="server" class="Content" style="font-size: 11px; min-height: 100px; border-radius: 0px 0px 10px 10px; font-family: Arial; font-weight: bold; color: #014454; max-height: 100px; overflow-y: auto; max-width: 250px;">
                    <table width="90%" align="center" class="Configheader" style="margin-top: 20px;">
                        <tr>
                            <td>
                                <img src="../Images/msgIcon.png" width="52" height="50" class="BroadCast" onclick="javascript:$('#TextMessage').val(''); $('#MessageTo').text('ALL'); $find('mpMessage').show();$('#TextMessage').focus();" />
                            </td>
                            <td>
                                <img src="../Images/Buzzer.png" width="50" height="50" class="BroadCast" onclick="BuzzerAll();return false;" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <ajaxToolkit:ModalPopupExtender ID="MpBroadCast" runat="server" BehaviorID="MpBroadCast"
                PopupControlID="PanelBroadCast" TargetControlID="Label8" CancelControlID="BtnCloseBroadCast"
                BackgroundCssClass="modalBackground">
            </ajaxToolkit:ModalPopupExtender>
            <asp:Label ID="Label8" runat="server"></asp:Label>
        </asp:Panel>
        <asp:Panel ID="PnlWait" runat="server" align="center" Style="display: none; width: 30%; max-width: 250px;">
            <div id="Div3" clientidmode="Static" align="center" runat="server" class="Shadow">
                <div class="header" align="center" style="height: 15px;">
                    <table width="100%" style="margin-top: -6px;">
                        <tr>
                            <td align="center">
                                <span id="LBLResultHead" class="Configheader" style="font-size: 14px;">Sending..
                                </span>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="headFoot" style="height: 0px; margin-top: -2px;">
                </div>
                <div id="Wait" align="center" class="Shadow" style="border-radius: 0px 0px 10px 10px; font-family: Arial; font-weight: bold; color: #014454; background: url('MImages/BG.png'); min-height: 70px;">
                    <div style="background: url('MImages/BG.png'); border-radius: 0px 0px 10px 10px; font-family: Arial; font-weight: bold; color: #014454;">
                        <table cellpadding="7" cellspacing="3" width="80%" align="center">
                            <tr>
                                <td>
                                    <br />
                                    <div align="center">
                                        <img id="LoadingGif" style="width: 80px; border-radius: 5px;"
                                            src="../MImages/LoadingN.gif" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <ajaxToolkit:ModalPopupExtender ID="MPWait" runat="server" BehaviorID="MPWait" PopupControlID="PnlWait"
                TargetControlID="Label6" CancelControlID="Label6" BackgroundCssClass="modalBackground">
            </ajaxToolkit:ModalPopupExtender>
            <asp:Label ID="Label6" runat="server"></asp:Label>
        </asp:Panel>
        <asp:Panel ID="PanelMessage" runat="server" align="center" Style="display: none; width: 30%; min-width: 400px;">
            <div id="DivTMessage" clientidmode="Static" align="center" runat="server" class="Shadow">
                <div class="header" align="center" style="height: 15px;">
                    <table width="100%" style="margin-top: -6px;">
                        <tr>
                            <td width="20%"></td>
                            <td align="center">
                                <asp:Label ID="LblDelayHeadaer" runat="server" Font-Size="15px" ClientIDMode="Static"
                                    CssClass="Configheader"> MESSAGE </asp:Label>
                            </td>
                            <td width="20%">
                                <asp:ImageButton ID="BtnCloseMessage" runat="server" ImageUrl="~/Images/close.png"
                                    Style="cursor: pointer; float: right; margin-right: 8px; width: 15px; height: 15px;"></asp:ImageButton>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="headFoot" style="height: 0px; margin-top: -2px;">
                </div>
                <div id="DivTMessageContent" runat="server" class="Content" style="font-size: 11px; min-height: 180px; border-radius: 0px 0px 10px 10px; font-family: Arial; font-weight: bold; color: #014454; max-height: 300px; overflow-y: auto;">
                    <table width="90%" align="center">
                        <tr>
                            <td colspan="2" align="center">
                                <br />
                                <table width="90%">
                                    <tr>
                                        <td align="left" width="10%">
                                            <asp:Label ID="LabelTO" runat="server" ClientIDMode="Static" CssClass="Configheader"
                                                Font-Size="15px" Text="TO"></asp:Label>
                                        </td>
                                        <td valign="middle" width="5%">
                                            <asp:Label ID="Label1" runat="server" ClientIDMode="Static" CssClass="Configheader"
                                                Font-Size="15px" Text=" : "></asp:Label>
                                        </td>
                                        <td align="left">
                                            <asp:Label ID="MessageTo" runat="server" ClientIDMode="Static" CssClass="Configheader"
                                                Font-Size="14px"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <br />
                                <asp:TextBox ID="TextMessage" runat="server" Width="90%" class="Custfont" Style="padding: 10px; border-radius: 5px;"
                                    TextMode="MultiLine" Height="75px" ClientIDMode="Static"></asp:TextBox>
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td width="70%"></td>
                            <td align="left">
                                <asp:Button ID="BtnDelayRequest" runat="server" Text="SEND" Style="margin-top: 5px; background: #E73225; background-image: none; border: 0 none;"
                                    CssClass="ButtonOut"
                                    OnClientClick="SendMessage();return false;" />
                                <br />
                                <br />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <ajaxToolkit:ModalPopupExtender ID="mpMessage" runat="server" BehaviorID="mpMessage"
                PopupControlID="PanelMessage" TargetControlID="TargetMessage" CancelControlID="BtnCloseMessage"
                BackgroundCssClass="modalBackground">
            </ajaxToolkit:ModalPopupExtender>
            <asp:Label ID="TargetMessage" runat="server"></asp:Label>
        </asp:Panel>
        <asp:Panel ID="PanelDone" runat="server" align="center" Style="display: none; width: 25%; max-width: 250px;">
            <div id="Div1" clientidmode="Static" align="center" runat="server" class="Shadow">
                <div class="header" align="center" style="height: 15px;">
                    <table width="100%" style="margin-top: -6px;">
                        <tr>
                            <td width="20%"></td>
                            <td align="center">
                                <asp:Label ID="LebalDone" runat="server" Font-Size="14px" CssClass="Configheader"
                                    ClientIDMode="Static"> DONE </asp:Label>
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
                    <table cellpadding="7" cellspacing="3" width="70%">
                        <tr>
                            <td>
                                <asp:Image ID="ImageWarning" runat="server" Style="height: 35px; width: 35px; outline: none;"
                                    ClientIDMode="Static" ImageUrl="~/Images/Done.png" />
                            </td>
                            <td width="80%">
                                <asp:Label ID="LBLResult" ClientIDMode="Static" runat="server" Font-Size="11px" CssClass="ConfigFont"> </asp:Label>
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
</asp:Content>
