<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TrackNew.aspx.cs" Inherits="Track_TrackNew" %>


<html lang="en">

<head>
    <title>Track  | TRACZO</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- Favicon -->
    <link rel="icon" href="../favicon.png" />
    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="../css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../css/sumoselect.min.css">
    <link rel="stylesheet" type="text/css" href="../css/style.css" />
    <link href="../css/changepwd.css" rel="stylesheet" />

    <script src="../js/jquery-3.6.4.min.js" type="text/javascript"></script>
    <script src="../js/aes.js" type="text/javascript"></script>

    <script src="../js/Track4.js" type="text/javascript"></script>
    <script src="../js/bulk.js" type="text/javascript"></script>
    <script src="../js/ChangePassword.js" type="text/javascript"></script>
    <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">
        <script type="text/javascript">
            var TrackUrl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Track/Service/Service.aspx?",
                Turl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Service/ServiceTrack.aspx?",
                Rurl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Service/ServiceRequest.aspx?",
                urlPageValidation =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/MasterPage/Service/Service.aspx?",
                CryptoKey = '<%=ConfigurationManager.AppSettings["CryptoKey"].ToString() %>',
                CryptoPwd = '<%=ConfigurationManager.AppSettings["CryptoIV"].ToString() %>',
                ConProtocol = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>',
                grid, gridMasterTable, Reload = window.setInterval(LoadGrid, 2000),
                ParentMenuService =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Service/ParentMenu.aspx?",
                BPorterID = '', BTagID = '', BTime = '30', ServiceCode = '1', EServiceCode = '', callFrom = 'Parent';
            function LoadGrid() {
                grid = $find('<%= GridTrack.ClientID %>');
                gridMasterTable = $find('<%= GridTrack.ClientID %>').get_masterTableView();
                ShowPorter();
            }
            $(document).ready(function () {
                ServiceCode = sessionStorage.getItem('ServiceCode');
                //   setTimeout(LoadGrid, 5000);
                LoadPresetValues();
                //LoadPresetRemarks();
                InitChangePassword();


                $('.services-btn-icon').click(function () {
                    // Remove 'active' class from all buttons

                    ServiceCode = $(this).attr('id').replace("divService", ""); callFrom = 'Parent'
                    setRootServices(this);
                    LoadPresetValues();
                    // Add 'active' class to the clicked button

                });

                if (ServiceCode == null)
                    $('.services-btn-icon').first().trigger('click');
                else {
                    ServiceCode = (ServiceCode == '0') ? "1" : ServiceCode;
                    sessionStorage.setItem('ServiceCode', ServiceCode);
                    $('#divService' + ServiceCode).trigger('click');
                }
            });

            function LoadPresetValues() {
                $.ajax({
                    url:  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>'
                        + "/Master/Service/Service.aspx?Process=PRESET&ACTION=" + encodeURIComponent(Encrypt("PRESETMSGS")) + "&MSG=&GROUP=" + encodeURIComponent(Encrypt("MSG")) + "&ID=&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)),
                    type: 'POST',
                    data: 'pData',
                    dataType: 'json',
                    success: function (data) {

                        $('#search_TrackMsg').html(''); $('#search_TrackMsg')[0].sumo.add('0', '-- Select --'); $('#search_TrackMsg')[0].sumo.reload();

                        $.each(data, function (key, value) {
                            $('#search_TrackMsg')[0].sumo.add(value.ID, value.MESSAGE);
                        });
                        $('#search_TrackMsg')[0].sumo.selectItem(0);
                    },
                    error: function (data) {

                    }

                });
            }

            function setRootServices(ele) {

                $('.services-btn-icon').removeClass('active');
                $(ele).addClass('active');
                // Get the rgb color of the clicked button
                var rgbColor = $(ele).data('color'); sessionStorage.setItem('ServiceCode', ServiceCode);
                // Convert rgb to rgba by appending the opacity
                var rgbaColor = rgbColor.replace('rgb', 'rgba').replace(')', ', 0.1)');

                //$('#DivKitchenFilters').css("visibility", (ServiceCode == "2") ? "visible" : "hidden");
                setServiceUpdates(ServiceCode);
                // Set the new rgba color to the CSS variable
                $(':root').css('--active-color', rgbColor);
                $(':root').css('--active-bg-color', rgbaColor);
            }

            function setServiceUpdates(ServiceCode) {
                switch (ServiceCode) {
                    case "2":
                        $("#pageLinkPlanner").html('<a href="../Planner/SheduledBreakfast.aspx"> <span> <img src="../images/spiral-calendar.png" alt="Planner"></span> Shed. Breakfast </a> ');
                        break;
                    default:
                        $("#pageLinkPlanner").html('<a href="../Planner/Planner.aspx"> <span> <img src="../images/spiral-calendar.png" alt="Planner"></span> Planner </a>');


                }
                //if (callFrom == "Parent")
                //    LoadPresetValues();
            }

            //$(document).ready(function () {
            //   LoadGrid();
            //});
        </script>
    </telerik:RadCodeBlock>
    <style>
        .RadGrid_Metro .rgHeader, .RadGrid_Metro th.rgResizeCol, .RadGrid_Metro .rgMultiHeaderRow th.rgHeader, .RadGrid_Metro .rgMultiHeaderRow th.rgResizeCol {
            border: 0 !important;
            border-bottom: 0px solid #e5e5e5 !important;
            border-left: 0px solid #e5e5e5 !important;
        }

        table#GridTrack_ctl00_Header thead tr th:last-child {
            border-radius: 0 10px 10px 0;
            border: none !important;
            font-weight: bold !important;
        }

        .RadGrid_Metro .rgHeader, .RadGrid_Metro .rgHeader a {
            color: #000000 !important;
            background-color: #C5DCF8 !important;
            font-family: monospace !important;
            font-size: 14px !important;
            height: 25px !important;
            vertical-align: middle !important;
            border-right: 1px solid #2784F4 !important;
            padding: 15px 20px !important;
            font-size: 12px;
            font-weight: 500;
        }

        .RadGrid .rgRow, .RadGrid .rgAltRow, .RadGrid .rgHeader, .RadGrid .rgResizeCol, .RadGrid .rgPager, .RadGrid .rgGroupPanel, .RadGrid .rgGroupHeader {
            font-weight: bold !important;
        }

        .RadGrid_Metro .rgRow td, .RadGrid_Metro .rgAltRow td, .RadGrid_Metro .rgEditRow td, .RadGrid_Metro .rgFooter td {
            border-style: none !important;
            border-width: 0 0 0px 0px !important;
        }


        .RadGrid_Metro .rgMasterTable .rgSelectedCell, .RadGrid_Metro .rgSelectedRow {
            color: #fff !important;
            background: #9E9E9E !important;
        }

        .RadGrid_Metro .rgAltRow, .RadGrid_Metro .rgHoveredRow {
            background-color: White !important;
        }

        .RadGrid .rgClipCells .rgHeader, .RadGrid .rgClipCells .rgFilterRow > td, .RadGrid .rgClipCells .rgRow > td, .RadGrid .rgClipCells .rgAltRow > td, .RadGrid .rgClipCells .rgEditRow > td, .RadGrid .rgClipCells .rgFooter > td {
            overflow: hidden !important;
            vertical-align: middle !important;
            text-align: center !important;
        }

        table#ctl00_ContentMaster_GridTrack_ctl00 {
            font-weight: bold;
        }

        .RadGrid_Metro {
            border-color: #ffffff !important;
        }

        table.GridTrack_ctl00_Header thead tr th {
            background: #C5DCF8 !important;
            text-align: center;
            padding: 15px 20px;
            border-right: 1px solid #2784F4 !important;
            font-size: 12px;
            font-weight: 500;
        }

        .bordernone {
            border-right: 1px solid #ffffff !important;
            border: none !important;
        }

        .SumoSelect > .optWrapper > .options li label {
            font-size: 14px !important;
        }

        .SumoSelect .select-all > span, .SumoSelect > .optWrapper.multiple > .options li.opt span {
            position: absolute;
            display: none !important;
            width: 30px;
            top: 0;
            bottom: 0;
            margin-left: -35px;
        }
    </style>
</head>
<body>
    <center>
        <form id="form1" runat="server">
            <telerik:RadScriptManager ID="RadScriptManager" runat="server">
            </telerik:RadScriptManager>


            <%-- <div class="lang-menu">
                <a class="select-language" href="track-thai.html">Thai</a>
            </div>--%>
            <div id="loader" class="loader-wrapper">
                <img src="../images/Traczo.svg" alt="Traczo">
            </div>
            <div class="main-wrapper">
                <div class="main-screen-wrap">
                    <div class="main-screen-inner">

                        <!-- Left Panel -->
                        <div class="screen-left-panel">
                            <div class="screen-left-sticky">
                                <div>
                                    <div class="traczo-logo">
                                        <a href="index.html">
                                            <img src="../images/Traczo.svg" alt="Traczo">
                                        </a>
                                    </div>
                                    <div class="hospital-img">
                                        <img src="../images/hospital.jpg" alt="Hospital">
                                    </div>
                                    <div class="hospital-title">
                                        <h5>Welcome</h5>
                                        <h6>QAH University Hospital,</h6>
                                        <p>Newcastle Rd, Stoke-on-Trent ST4 6QG, United Kingdom</p>
                                    </div>
                                    <div class="left-panel-menu">
                                        <ul>
                                            <ul>

                                                <li>
                                                    <a href="../Index/Index.aspx">
                                                        <span>
                                                            <img src="../images/home.png" alt="Home"></span> Home
                                                    </a>
                                                </li>
                                                <li style="display: none">
                                                    <a href="dashboard.html">
                                                        <span>
                                                            <img src="../images/dashboard.png" alt="Dashboard"></span> Dashboard
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="#" onclick="redirectFloorwiseTrac()">
                                                        <span>
                                                            <img src="../images/world-map.png" alt="Map"></span> Map
                                                    </a>
                                                </li>
                                                <li class="current-menu-item">
                                                    <a href="../Track/TrackNew.aspx">
                                                        <span>
                                                            <img src="../images/doc.png" alt="Track"></span> Track
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="../Reports/Report.aspx">
                                                        <span>
                                                            <img src="../images/clipboard.png" alt="Reports"></span> Reports
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="../Planner/Planner.aspx">
                                                        <span>
                                                            <img src="../images/spiral-calendar.png" alt="Planner"></span> Planner
                                                    </a>
                                                </li>

                                                <li>
                                                    <a href="../Master/Category.aspx">
                                                        <span>
                                                            <img src="../images/category-master.png" alt="Task Types"></span> Task Types
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="../Master/Porter.aspx">
                                                        <span>
                                                            <img src="../images/porter-master.png" alt="Porter Master"></span> Porter Master
                                                    </a>
                                                </li>


                                                <li>
                                                    <a href="../Master/Users.aspx">
                                                        <span>
                                                            <img src="../images/porter-master.png" alt="Location Master"></span> User Master
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="../Master/Locations.aspx">
                                                        <span>
                                                            <img src="../images/location.png" alt="Location Master"></span> Location Master
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="../Master/PerformLogs.aspx">
                                                        <span>
                                                            <img src="../images/priority.png" alt="Location Master"></span> P3rform Logs
                                                    </a>
                                                </li>

                                                <li>
                                                    <a onclick="javascript:Bulk();" href="#">
                                                        <span>
                                                            <img src="../images/upload-task.png" alt="Upload Tasks"></span> Upload Tasks
                                                    </a>
                                                </li>

                                                <li>
                                                    <a href="../Master/Roles.aspx">
                                                        <span>
                                                            <img src="../images/UserRole.png" alt="Role Master"></span> Role Master
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="../Master/Group.aspx">
                                                        <span>
                                                            <img src="../images/group-master.png" alt="Group Master"></span> Group Master
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="../Master/Remarks.aspx">
                                                        <span>
                                                            <img src="../images/memo.png" alt="Group Master"></span> Remarks Master
                                                    </a>
                                                </li>
                                            </ul>
                                    </div>
                                </div>
                                <br />
                                <br />
                                <br />
                                <div>
                                    <div class="profile-link" onmouseover="HoverOpenSideBar()" onmouseout="OutOpenSideBar()">
                                        <div class="profile-img">
                                            <%--<img src="../images/User.png" class="ImgUser" alt="Profile">--%>
                                        </div>
                                        <div class="profile-designation">
                                            <h6><span id="spanUserName"></span>
                                                <br />
                                                <br />
                                                <span style="text-decoration: underline; font-size: 12px;">Log out</span></h6>
                                        </div>
                                        <a href="../login.aspx" class="stretched-link"></a>
                                        <img src="../images/User.png" class="ImgUser" onmouseover="HoverOpenSideBar()" alt="Profile" />


                                        <div class="DivPassword" id="DivPassword" style="display: none" align="left">
                                            <ul class='Pmenu'>
                                                <li><a onclick="ChangePassword();">Change Password </a></li>

                                            </ul>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <!-- /Left Panel -->
                        <div class="screen-right-panel">
                            <div class="navigation-tabs-wrapper">
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

                                <div class="action-btn-wrapper"></div>
                            </div>
                            <!-- Section heading -->
                            <div class="section-head">
                                <div class="section-head-left">
                                    <h5>Track</h5>
                                </div>

                                <div class="section-head-right d-flex align-items-center">
                                    <div class="search-wrap shadow w-100">
                                        <div class="search-box" style="display: none">
                                            <form>
                                                <input type="search" maxlength="30" autocomplete="off webauthn" id="PName" class="form-control">
                                                <input type="submit" value="" class="search-submit">
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /Section heading

                    <div class="track mb-4">
                        <div class="d-flex">
                            <a href="#" class="btn btn-primary me-3"><img src="../images/message-icon.png"> Message</a>
                            <a href="#" class="btn btn-yellow"><img src="../images/buzzer.png"> Buzzer</a>
                        </div>
                    </div> -->

                            <!-- Track Table -->
                            <div class="table-wrap">
                                <div class="table-responsive">


                                    <telerik:RadGrid ID="GridTrack" runat="server" AllowSorting="false" AutoGenerateColumns="false"
                                        Width="100%" Style="height: 820px; background-color: white;" Skin="Metro">
                                        <HeaderStyle />
                                        <PagerStyle AlwaysVisible="true" />
                                        <ItemStyle HorizontalAlign="Center" />
                                        <AlternatingItemStyle HorizontalAlign="Center" />
                                        <ClientSettings EnableRowHoverStyle="true">
                                            <Scrolling AllowScroll="True" SaveScrollPosition="true" ScrollHeight="800px" UseStaticHeaders="true"></Scrolling>
                                            <ClientEvents OnRowCreated="RowCreated" OnRowDataBound="DataBound" />
                                            <Selecting AllowRowSelect="false" CellSelectionMode="None" />
                                        </ClientSettings>
                                        <MasterTableView ClientDataKeyNames="REQUESTID,ISUNAVAILABLE,SAMEZONE,PORTERID,NAME,FLOOR,ZONE,BATTERYLEVEL,TAGID,ISBREAK,ENDHOLD,ENDTIME,STATUS,MACID,KITCHEN"
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

                                                <telerik:GridBoundColumn HeaderText="KITCHEN" DataField="KITCHEN" UniqueName="KITCHEN">
                                                    <HeaderStyle />
                                                </telerik:GridBoundColumn>

                                                <telerik:GridBoundColumn HeaderText="STATUS" DataField="STATUS" UniqueName="STATUS">
                                                    <HeaderStyle Width="150px" />
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="BATTERY LEVEL" DataField="BATTERYLEVEL" UniqueName="BATTERYLEVEL">
                                                    <HeaderStyle Width="120px" />
                                                </telerik:GridBoundColumn>
                                                <telerik:GridImageColumn HeaderText="BREAK" UniqueName="BREAK" ImageUrl="images/Unchecked.png"
                                                    HeaderStyle-Width="80px">
                                                </telerik:GridImageColumn>
                                                <telerik:GridImageColumn HeaderText="NOT AVAILABLE" UniqueName="ISUNAVAILABLE" ImageUrl="images/Unchecked.png"
                                                    HeaderStyle-Width="100px">
                                                </telerik:GridImageColumn>
                                                <telerik:GridBoundColumn HeaderText="BREAK END-TIME" DataField="ENDTIME" UniqueName="ENDTIME">
                                                    <HeaderStyle />
                                                </telerik:GridBoundColumn>
                                                <telerik:GridImageColumn HeaderText="MESSAGE" Display="true" UniqueName="MESSAGE" ImageUrl="../images/message-icon.png"
                                                    HeaderStyle-Width="100px">
                                                </telerik:GridImageColumn>
                                                <telerik:GridImageColumn HeaderText="BUZZER" Display="true" UniqueName="BUZZER" ImageUrl="../images/buzzer.png"
                                                    HeaderStyle-Width="80px">
                                                </telerik:GridImageColumn>
                                                <telerik:GridImageColumn HeaderText="LOCATE" UniqueName="LOCATE" ImageUrl="../images/location.png"
                                                    HeaderStyle-Width="80px">
                                                </telerik:GridImageColumn>
                                                <telerik:GridImageColumn HeaderText="RELEASE" UniqueName="RELEASE" ImageUrl="../images/release.png"
                                                    HeaderStyle-Width="80px">
                                                </telerik:GridImageColumn>
                                                <telerik:GridImageColumn HeaderText="END SHIFT" UniqueName="ENDSHIFT" ImageUrl="images/close.png"
                                                    HeaderStyle-Width="100px">
                                                </telerik:GridImageColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:RadGrid>


                                </div>
                            </div>
                            <!-- /Track Table -->

                        </div>
                        <!-- /Right Panel -->
                    </div>
                </div>
            </div>

            <!-- porter app -->
            <div id="ModalBreak" class="modal fade" role="dialog">
                <div class="modal-dialogLoc">
                    <div class="modal-content">
                        <div class="header" align="center">
                            <table width="95%" style="margin-top: -6px;">
                                <tr>
                                    <td colspan="2" align="center" valign="middle">
                                        <span style="color: white; font-family: monospace; font-size: 18px; position: relative; top: -4px; padding-right: 5px;">BREAK</span>
                                    </td>
                                    <td width="10%">
                                        <input type="image" name="BtnRequestCatClose" id="ImgReqBreakClose" src="images/Close.png"
                                            style="border-width: 0px; cursor: pointer; float: right; margin-right: 8px; width: 20px; height: 20px;"
                                            data-dismiss="modal" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="headFoot" style="height: 0px; margin-top: -2px;">
                        </div>
                        <div id="Div2" align="center" style="overflow-y: auto;">
                            <div id="BreakReasonContent" class="Content" style="margin-bottom: 10px;">
                                <table width="95%">
                                    <tr>
                                        <td align="center">
                                            <table style="width: 90%;">

                                                <tr style="height: 45px;">
                                                    <td colspan='2' align="center" style="text-align: center; vertical-align: middle;">
                                                        <span style="font-weight: bold; font-family: arial; color: rgb(30, 70, 129); font-size: 13px; margin-top: 10px;">Name : <span id='BreakPorterName'></span></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle" align="center" style="vertical-align: middle">
                                                        <table width="90%">
                                                            <tr style="color: WHITE; font-family: monospace; font-size: 14px; font-weight: bold; height: 30px; background: #254782;">
                                                                <td style="padding-left: 10px; padding-top: 5px;">REASON </td>
                                                                <td style="padding-left: 10px; padding-top: 5px;">MINUTES </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <select id="drpBreakReason" style="width: 190px; text-transform: uppercase; font-family: monospace; font-size: 12px; font-weight: bold; height: 40px;"
                                                                        onchange="OnBreakReason(this);" tabindex="3">
                                                                    </select>
                                                                </td>
                                                                <td>
                                                                    <input type="number" id="BreakTime" name="quantity" min="0" max="200" style="height: 33px; width: 80px;" />

                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <textarea name="txtBreakReason" id="txtBreakReason" cols="25" rows="5" maxlength="120"
                                                                        class="txtRemarksInfo" style="height: 50px; width: 190px; font-size: 14px; padding: 5px; border-radius: 5px; color: rgb(20, 45, 82); margin-top: 20px; word-break: break-word !important; font-weight: bold !important; text-align: left !important; resize: none !important; display: inline-block;"
                                                                        tabindex="4"></textarea>
                                                                </td>
                                                                <td width="25%" style="vertical-align: middle;">
                                                                    <img src="Images/Break.png" id="ImgDeleteReq" style="cursor: pointer; margin: 10px;" onclick="PorterBreak();return false;" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Reports -->
            <!-- Modal -->
            <div class="modal fade" id="reportsModal" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="reportsModalLabel">Generate New Report</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="modal-body">
                            <form>
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="mb-3">
                                            <label for="select-format">Choose Format</label>
                                            <select name="select-format" id="select-format" class="form-control selectFormat sumoSelect">
                                                <option value="PDF">PDF</option>
                                                <option value="Excel">Excel</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="since-date">Since</label>
                                            <input type="date" id="since-date" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="to-date">To</label>
                                            <input type="date" id="to-date" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <div class="d-flex justify-content-end">
                                            <button type="button" class="btn btn-outline me-3" data-bs-dismiss="modal">
                                                <img src="../images/multiply.svg">
                                                Cancel</button>
                                            <input type="submit" value="Generate" class="btn btn-secondary">
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /Reports -->

            <!-- Add Task -->
            <!-- Modal -->
            <div class="modal fade" id="ModalCancel" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-fullscreen-md-down">
                    <div class="modal-content">
                        <div class="header" align="center">
                            <table width="95%" style="margin-top: -6px;">
                                <tr>
                                    <td style="color: white; font-weight: bold; font-family: monospace; font-size: 18px; position: relative; top: -4px; padding-right: 5px;">#<span id="canReqID"></span> </td>
                                    <td colspan="2" align="center" valign="middle">
                                        <span id="PorName" style="color: white; font-family: monospace; font-size: 18px; position: relative; top: -4px; padding-right: 5px;">BREAK</span>
                                    </td>
                                    <td width="10%">
                                        <input type="image" name="BtnRequestCatClose" id="ImgReqCancelClose" src="../images/close.png"
                                            style="border-width: 0px; cursor: pointer; float: right; margin-right: 8px;"
                                            data-bs-dismiss="modal" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="headFoot" style="height: 0px; margin-top: -2px;">
                        </div>
                        <div id="Div2" align="center" style="overflow-y: auto;">
                            <div id="CancelReasonContent" class="Content" style="margin-bottom: 10px;">
                                <table width="95%">
                                    <tr>
                                        <td align="center">
                                            <table style="width: 190px;">
                                                <tr>
                                                    <td valign="middle" align="center" style="vertical-align: middle">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <div class="mb-3">
                                                                        <label for="txtReqTime">Time</label>
                                                                        <input type="time" id="txtReqTime" class="form-control">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="25%" style="vertical-align: middle;">


                                            <input type="image" name="BtnRequestCatClose" id="ImgReqCancelCloseaa" src="../images/envelope.png" class="btn btn-tertiary bg-orange" onclick="SaveEndTime()"
                                                style="border-width: 0px; cursor: pointer; float: right; margin-right: 8px;"
                                                data-bs-dismiss="modal" />

                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="modalReqAlert" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-md">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="NRSuccess">Success</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="modal-body">
                            <form>
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="mb-3 text-center">
                                            <img src="../images/icon-success.gif" alt="Icon Success">
                                        </div>
                                        <div class="mb-3 text-center">
                                            <span id="LBLRequestResult"></span>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="ModalMessage" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-fullscreen-md-down">
                    <div class="modal-content">

                        <div class="modal-header">
                            <h6 class="modal-title">MESSAGE TO  &nbsp;<span id="MessageTo"></span></h6>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="width: 20px; height: 20px;">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="headFoot" style="height: 0px; margin-top: -2px;">
                        </div>
                        <div id="Div3" align="center" style="overflow-y: auto;">
                            <div id="CancelReasonContentM" class="Content" style="min-height: 320px; padding: 30px;">
                                <table width="95%">
                                    <tr>
                                        <td align="center">
                                            <table style="width: 190px;">
                                                <tr>
                                                    <td valign="middle" align="center" style="vertical-align: middle">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <select name="selectFloor" id="search_TrackMsg" tabindex="10" class="form-control search_test" onchange="OnChangeRemarks(this,'TextMessage');return false;" style="margin-bottom: 10px; width: 350px; background-color: white !important;"></select>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <textarea name="TextMessage" id="TextMessage" cols="25" rows="10" maxlength="120" class="txtRemarksInfo"
                                                                        style="height: 100px; width: 300px; word-break: break-word !important; font-size: 14px; font-weight: bold !important; text-align: left !important; resize: none !important; padding: 5px; border-radius: 5px; color: #142d52; margin-top: 20px;" tabindex="4"></textarea>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="25%" style="vertical-align: middle;">
                                            <img src="../images/Send.png" id="ImgDeleteReqM" style="cursor: pointer; margin-left: 20px;" onclick="SendMessage();return false;" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="ModalChangepwd" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-fullscreen-md-down">
                    <div class="modal-content">

                        <div class="modal-header">
                            <h6 class="modal-title"><span id="canReqIDpwd"></span>
                                &nbsp;&nbsp;CHANGE PASSWORD</h6>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="width: 20px; height: 20px;">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="headFoot" style="height: 0px; margin-top: -2px;">
                        </div>
                        <div id="Div2pwd" align="center" style="overflow-y: auto;">
                            <div id="CancelReasonContentpwd" class="Content" style="min-height: 320px">
                                <div id="DivCPContent" class="ContentCP" align="center" style="margin-top: 25px;">

                                    <table class="Custfont" style="min-width: 350px; min-height: 160px; font-size: 14px; font-weight: 500;"
                                        cellpadding="5" cellspacing="5">
                                        <tr>
                                            <td>Current Password
                                            </td>
                                            <td align="center">
                                                <asp:TextBox ID="TxtCurPassword" runat="server" Width="180px" class="txtpwd" ClientIDMode="Static"
                                                    Style="border: 1px solid #ded6d6 !important; margin-bottom: 0px !important; padding-left: 5px"
                                                    TextMode="Password"></asp:TextBox>
                                                <asp:Label ID="ErCurrent" runat="server" Text="*" ForeColor="Red" Font-Size="Medium"
                                                    ClientIDMode="Static" CssClass="Custfont" Style="visibility: hidden"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>New Password
                                            </td>
                                            <td align="center">
                                                <asp:TextBox ID="TxtPassword" runat="server" Width="180px" class="txtpwd" ClientIDMode="Static"
                                                    Style="border: 1px solid #ded6d6 !important; margin-bottom: 0px !important; padding-left: 5px"
                                                    TextMode="Password"></asp:TextBox>
                                                <asp:Label ID="ErPassword" runat="server" Text="*" ForeColor="Red" Font-Size="Medium"
                                                    ClientIDMode="Static" CssClass="Custfont" Style="visibility: hidden"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Confirm Password
                                            </td>
                                            <td align="center">
                                                <asp:TextBox ID="TxtConfirmPassword" runat="server" Width="180px" class="txtpwd" ClientIDMode="Static"
                                                    Style="border: 1px solid #ded6d6 !important; margin-bottom: 0px !important; padding-left: 5px"
                                                    TextMode="Password"></asp:TextBox>
                                                <asp:Label ID="ErCPassword" runat="server" Text="*" ForeColor="Red" Font-Size="Medium"
                                                    ClientIDMode="Static" CssClass="Custfont" Style="visibility: hidden"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <table width="90%" align="center">
                                                    <tr>
                                                        <td valign="middle" align="center"></td>
                                                        <td align="right">
                                                            <div class="section-head-right d-flex align-items-center">
                                                                <!-- <div class="date">
                                        <img src="../images/spiral-calendar.png" alt="Date"> 03-Mar-2023
                                    </div> -->

                                                            </div>
                                                            <div class="export-link" onclick="ValidatePassword()">
                                                                <a href="#" class="btn btn-secondary">
                                                                    <img src="../images/memo.png" alt="Change">
                                                                    Change
                                                                </a>
                                                            </div>
                                                            <%--<asp:Button ID="BtnSave" runat="server" Text="CHANGE" Style="background-color: rgba(32, 72, 132, 1);
                                                    border: none; padding: 5px 10px; color: white; font-weight: lighter !important;
                                                    font-size: 14px; border-radius: 0px !important; font-family: monospace;" OnClientClick="ValidatePassword();return false;" />--%>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>

                                </div>
                                <div style="text-align: justify;">
                                    <span style="color: red; /* font-size: 15px; */">*</span><%-- The password must contain at least one digit and one lowercase English character and one uppercase English character and one special character from the specified set [!@#$%^&amp;*()\-+.]--%>

                                    <div id="message">
                                        <h6>Password must contain the following:</h6>
                                        <p id="letter" class="invalid">A lowercase letter</p>
                                        <p id="capital" class="invalid">A capital (uppercase) letter</p>
                                        <p id="splChar" class="invalid">A special character [!@#$%^&*()\-+.] letter</p>

                                        <p id="number" class="invalid">A number</p>
                                        <p id="length" class="invalid">Minimum 12 characters</p>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <!-- /Add Task -->

            <!-- JS CSS -->
            <script src="../js/jquery-3.6.4.min.js"></script>
            <script src="../js/bootstrap.bundle.min.js"></script>
            <script src="../js/jquery.sumoselect.min.js"></script>
            <script src="../js/style.js"></script>

            <!-----//end-main---->
        </form>
    </center>

</body>
</html>

