<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Locations.aspx.cs" Inherits="Master_Locations" EnableEventValidation="false" %>

<html lang="en">

<head>
    <title>Locations | TRACZO</title>
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
    <script src="../js/Location.js" type="text/javascript"></script>
    <script src="../js/aes.js" type="text/javascript"></script>
    <script src="../js/bulk.js" type="text/javascript"></script>
    <script src="../js/ChangePassword.js" type="text/javascript"></script>
    <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">

        <script type="text/javascript">
            var dataSet = [], hurl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Master/",
                CryptoKey = '<%=ConfigurationManager.AppSettings["CryptoKey"].ToString() %>',
                CryptoPwd = '<%=ConfigurationManager.AppSettings["CryptoIV"].ToString() %>',
                ConProtocol = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>',
                urlPageValidation =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/MasterPage/Service/Service.aspx?",
                olddatetime = '', prebook = '', TimerHome, ToUpdate = false, ServiceCode = '1',
                FPatientName = '', TPatientName = '', MRDPatientName = '', GCancelReason, GFinishReason, GTagID, CurrentDStatus, GReqID, GPorterID, IsEdit, GMIndex = '0', GExtn = '', ReqDate = '', ReqTime = '', ReqCat = '0', RFromID = '0', RToID = '0', RPreBook = '0',
                Efrom, ETo, ECategory, EDate, EPatient, Remarks, AReqID, APorter1, APorter2, ADept, Isclear = false, PorterID1 = ''; PorterName1 = ''; PorterID = ''; PorterName = '', PORTERGROUP = '', ISMULTIPORTER = 'NO', IsReturn = 'NO',
                    MAReqID = '', MADept = '', MACount = 60, MANReqID = '', MANCount = 60, MANPorterID = '', MANPorterName = '', GPatientName = '', GFrom = '', GStatus = '2', GOMI = '0', GUser = '', ATReqNB = '',
                    IsMRD = 'NO';

            var PorterCurTasks = '', PendingTasks = '', ATPorterID = '', ATPorterName = '', ATStatus = '', ATReqNB = '';

            var EZoneID = '', EZoneName = '', EZone = '', EApName = '', EDepartment = '', EIsTwoPorterTask = '', EAddressEAddress = '', EIsActive = '', EFloorName = '', ENearByZoneArr = '', ENearByZoneIDs = '', ETag = '',
                EIsPorteringLocation = '', EIscateringLocation = '', EIsCleaningLocation = '', EIsSecurityLocation = '', EIsFeedbackLocation = '', ECleaningGroupID = '', ECleaningGroupName = '', EShortName = '';

            var grid, gridMasterTable, pageSize = 15, pageIndex = 0;


            $(document).ready(function () {

                ServiceCode = sessionStorage.getItem('ServiceCode');
                InitChangePassword();
                LoaddrFloorandKitchen();
                LoadProcess();
                $("#txtsearchNearbyZones").keyup(function () {

                    loadNBsuggesstion($(this).val());
                });


                $('textarea').keypress(function (event) {

                    var regex = new RegExp("^[a-zA-Z0-9]+$");
                    var arrValid = ["*", ",", "."];
                    var key = String.fromCharCode(!event.charCode ? event.which : event.charCode);

                    //alert(event.which);
                    if (!regex.test(key) && (event.which !== 32) && (event.which !== 13) && (!(arrValid.indexOf(key) > -1))) {
                        event.preventDefault();
                        return false;
                    }

                });



                $('input[type=search]').keypress(function (event) {

                    var regex = new RegExp("^[a-zA-Z0-9]+$");
                    var arrValid = ["*", ",", "."];
                    var key = String.fromCharCode(!event.charCode ? event.which : event.charCode);

                    //alert(key);
                    if (!regex.test(key) && (event.which !== 32) && (event.which !== 13) && (!(arrValid.indexOf(key) > -1))) {
                        event.preventDefault();
                        return false;
                    }

                });


                $('.services-btn-icon').click(function () {
                    // Remove 'active' class from all buttons
                    $('.services-btn-icon').removeClass('active');

                    // Add 'active' class to the clicked button
                    $(this).addClass('active');
                    ServiceCode = $(this).attr('id').replace("divService", "");
                    setServiceUpdates(ServiceCode);

                    // Get the rgb color of the clicked button
                    var rgbColor = $(this).data('color'); sessionStorage.setItem('ServiceCode', ServiceCode);

                    // Convert rgb to rgba by appending the opacity
                    var rgbaColor = rgbColor.replace('rgb', 'rgba').replace(')', ', 0.1)');
                    // Set the new rgba color to the CSS variable
                    $(':root').css('--active-color', rgbColor);
                    $(':root').css('--active-bg-color', rgbaColor);
                });

                $('#divService' + ServiceCode).trigger('click');


            });


            function setServiceUpdates(ServiceCode) {
                switch (ServiceCode) {
                    case "2":
                        $("#pageLinkPlanner").html('<a href="../Planner/SheduledBreakfast.aspx"> <span> <img src="../images/spiral-calendar.png" alt="Planner"></span> Shed. Breakfast </a> ');
                        break;
                    default:
                        $("#pageLinkPlanner").html('<a href="../Planner/Planner.aspx"> <span> <img src="../images/spiral-calendar.png" alt="Planner"></span> Planner </a>');


                }
                LoadProcess();
            }

            function LoadProcess() {
                //sessionStorage.getItem('ROLE', 'CONTROL ROOM');
                grid = $find('<%= GridLocation.ClientID %>');
                gridMasterTable = $find('<%= GridLocation.ClientID %>').get_masterTableView();
                LoadGrid();
            }

            function DatValidate() {
                var serviceId = $('#HFDWServiceId').val();
                document.getElementById("<%= HFDWExportHeader.ClientID %>").value = BuildHeader();
                document.getElementById("<%= HFDWSearchQuery.ClientID %>").value = Encrypt($('#TextSearchLocation').val());
                ShowModalPopUp("modalAlertExport");
                setTimeout('HideModalPopUp("modalAlertExport");', 3000);
                return true;
            }

            $(document).ready(function () {
                var storedServiceCode = sessionStorage.getItem('ServiceCode');
                if (storedServiceCode !== null) {
                    $('.services-btn-icon').removeClass('active');
                    $('#divService' + storedServiceCode).addClass('active');
                    $('#HFDWServiceId').val(storedServiceCode);
                } else {
                    $('#divService0').addClass('active');
                    $('#HFDWServiceId').val('0');
                    sessionStorage.setItem('ServiceCode', '0');
                }

                $('.services-btn-icon').click(function () {
                    $('.services-btn-icon').removeClass('active');
                    $(this).addClass('active');
                    var ServiceCode = $(this).attr('id').replace("divService", "");
                    sessionStorage.setItem('ServiceCode', ServiceCode);
                    $('#HFDWServiceId').val(ServiceCode);
                });

                $('#<%= LinkButton1.ClientID %>').click(function () {
                    var sc = sessionStorage.getItem('ServiceCode');
                    if (sc !== null) {
                        $('#HFDWServiceId').val(sc);
                    }
                });
            });

        </script>
    </telerik:RadCodeBlock>
    <style type="text/css">
        legend {
            font-size: 1rem !important;
            color: red;
            padding: 0px 15px;
            font-weight: bold;
            margin-top: -10px;
            margin-left: 20px;
            background: white;
            text-align: left;
            max-width: 100px;
        }

        fieldset {
            border: 1px solid gray;
            padding-left: 15px;
            padding-bottom: 15px;
            width: 100%;
        }

        .category-master .category-master-item .card.card-top .btn.btn-tertiary {
            background-color: #2196f3 !important;
            color: #303537;
        }

        .MultiPorter {
            display: block;
            margin-top: 15px;
            margin-left: 15px;
            cursor: pointer;
        }

        .RadGrid_Metro .rgHeader, .RadGrid_Metro th.rgResizeCol, .RadGrid_Metro .rgMultiHeaderRow th.rgHeader, .RadGrid_Metro .rgMultiHeaderRow th.rgResizeCol {
            border: 0 !important;
            border-bottom: 0px solid #e5e5e5 !important;
            border-left: 0px solid #e5e5e5 !important;
        }

        table#ctl00_ContentMaster_GridLocation_ctl00_Header thead tr th:last-child {
            border-radius: 0 10px 10px 0;
            border: none !important;
        }

        .RadGrid_Metro .rgHeader, .RadGrid_Metro .rgHeader a {
            color: #000000 !important;
            background-color: #C5DCF8 !important;
            font-family: monospace !important;
            font-size: 14px !important;
            height: 25px !important;
            vertical-align: middle !important;
            border-right: 1px solid #C5DCF8 !important;
            padding: 15px 20px !important;
            font-size: 12px;
            font-weight: bold;
        }

        .RadGrid_Metro .rgRow td, .RadGrid_Metro .rgAltRow td, .RadGrid_Metro .rgEditRow td, .RadGrid_Metro .rgFooter td {
            border-style: none !important;
            border-width: 0 0 0px 0px !important;
        }

        .RadGrid_Metro .rgHeader {
            font-weight: bold !important;
            color: #000000 !important;
            font-size: 16px !important;
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
            /*text-align: center !important;*/
            font-size: 14px !important;
            padding: 10px !important;
            font-family: monospace !important;
        }

        table#ctl00_ContentMaster_GridLocation_ctl00 {
            font-weight: bold;
        }

        .RadGrid_Metro {
            border-color: #ffffff !important;
            border-color: #ffffff !important;
            padding: 15px;
            border-radius: 10px;
        }

        table.ctl00_ContentMaster_GridLocation_ctl00_Header thead tr th {
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

        .RadGrid_Metro td.rgPagerCell {
            border: 1px solid !important;
            border-color: #E1F5FE !important;
            padding: 8px !important;
        }

        .msgContainer {
            border-bottom: 2px dotted gray;
            background-color: #f1f1f1;
            border-radius: 5px 0px;
            padding: 15px;
            margin: 15px 0;
            font-family: monospace;
        }

            .msgContainer::after {
                content: "";
                clear: both;
                display: table;
            }


        .time-right {
            float: right;
            color: gray;
            font-weight: 12px;
            margin-right: 10px;
        }

        .msgUser {
            font-size: 14px;
            font-weight: bold;
        }


        .LocationList {
            z-index: 100;
            max-height: 300px;
            float: left;
            list-style: none;
            margin-top: -3px;
            padding: 0;
            position: absolute;
            overflow-y: scroll;
            min-width: 400px;
        }

            .LocationList li {
                padding: 10px;
                background: white;
                border-bottom: #bbb9b9 1px solid;
            }

                .LocationList li:hover {
                    background: #ece3d2;
                    cursor: pointer;
                }
                .input-error {
                    border: 1px solid red !important;
                }

                .error-message {
                    color: red;
                    font-size: 12px;
                    margin-top: 5px;
                    display: block;
                }

    </style>
</head>
<body>
    <form id="formCategory" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager" runat="server">
        </telerik:RadScriptManager>
        <asp:HiddenField ID="HFCancelReqID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFDWServiceId" runat="server" ClientIDMode="Static" />

        <asp:HiddenField ID="HFERID" runat="server" ClientIDMode="Static" />

        <asp:HiddenField ID="HFERNO" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFStatusID" runat="server" ClientIDMode="Static" />

        <asp:HiddenField ID="HFDWExportHeader" runat="server" ClientIDMode="Static" />

        <asp:HiddenField ID="HFDWSearchQuery" runat="server" ClientIDMode="Static" />
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
                                    <a href="../Index/Index.aspx">
                                        <img src="../images/Traczo.svg" alt="Traczo">
                                    </a>
                                </div>
                                <div class="hospital-img">
                                    <img src="../images/hospitaleq.jpg" alt="Hospital">
                                </div>
                                <div class="hospital-title">
                                    <h5>Welcome</h5>
                                    <h6>Queen Alexandra Hospital,</h6>
                                    <p>Cosham, Portsmouth, PO6 3LY</p>
                                </div>
                                <div class="left-panel-menu">
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
                                        <li>
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
                                        <li class="current-menu-item">
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

                    <!-- Right Panel -->
                    <div class="screen-right-panel">
                        <div class="navigation-tabs-wrapper">
                            <div>
                                <h5>Locations</h5>
                            </div>
                            <div class="services-tabs-wrapper">

                                <div class="services-btn-icon" data-color="rgb(255, 116, 0)" id="divService0">
                                    <img src="../images/All-icon.png" />
                                    <span>Division</span>
                                </div>
                                <div class="services-btn-icon" data-color="rgb(255, 116, 0)" id="divService1">
                                    <img src="../images/porter-icon.svg" />
                                    <span>Portering</span>
                                </div>
                                <div class="services-btn-icon" data-color="rgb(12, 188, 139)" id="divService2">
                                    <img src="../images/cater-icon.png" />
                                    <span>Receipt and Distribution</span>
                                </div>
                                <div class="services-btn-icon" data-color="rgb(110, 48, 243)" id="divService3" style ="display:none">
                                    <img src="../images/clean-icon.svg" />
                                    <span>Clean</span>
                                </div>
                                <div class="services-btn-icon" data-color="rgb(255, 87, 51)" id="divService4" style ="display:none">
                                    <img src="../images/pest-icon.svg" />
                                    <span>Feedback</span>
                                </div>
                                <div class="services-btn-icon" data-color="rgb(255, 87, 51)" id="divService5" style ="display:none">
                                    <img src="../images/security-icon.svg" />
                                    <span>Security</span>
                                </div>
                            </div>
                            <div class="action-btn-wrapper">

                                <div class="col-md-12" style="margin-top: 5px;">
                                    <button type="button" class="btn btn-primary w-100" id="BtnRemarks" onclick="AddLocation();">
                                        <img
                                            src="../images/memo.png">
                                        <span id="txtBtnRemarks">Add</span></button>
                                </div>
                                <div class="section-head-right d-flex align-items-center">
                                    <div id="tdExport">

                                        <asp:LinkButton ID="LinkButton1" runat="server" class="GridHeader" OnClientClick="return DatValidate();"
                                            OnClick="Export_Location"> <img src="../images/Exports.PNG" style="max-width:40px;margin-right: 20px;">
                                        </asp:LinkButton>

                                    </div>

                                    <div class="search-wrap w-100" style="margin: 0px; margin-left: 10px;">
                                        <div class="search-box">
                                            <form>
                                                <input type="search" maxlength="30" autocomplete="off webauthn" style="width: 300px;" id="TextSearchLocation" class="form-control" placeholder="Search">

                                                <input type="submit" value="" class="search-submit" onclick="LoadProcess(); return false;">
                                            </form>
                                        </div>
                                    </div>

                                </div>
                            </div>


                        </div>
                        <%--<div class="section-head">
                            <div class="section-head-left">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h5>Locations</h5>
                                    </div>
                                    <div class="col-md-6">
                                        <button type="button" class="btn btn-primary w-100" id="BtnRemarks" onclick="AddLocation();">
                                            <img
                                                src="../images/memo.png">
                                            <span id="txtBtnRemarks">Add</span></button>
                                    </div>
                                </div>
                            </div>
          

                            <div class="section-head-right d-flex align-items-center">
                                <div id="tdExport">

                                    <asp:LinkButton ID="ExportLocations" runat="server" class="GridHeader" OnClientClick="return DatValidate();"
                                        OnClick="Export_Location"> <img src="../images/Exports.PNG" style="max-width:40px;margin-right: 20px;">
                                    </asp:LinkButton>

                                </div>
                                <div class="search-wrap shadow w-100">
                                    <div class="search-box">
                                        <form>
                                            <input type="search" maxlength="30" autocomplete="off webauthn" id="TextSearchLocation" class="form-control">
                                            <input type="submit" value="" class="search-submit" onclick="LoadProcess(); return false;">
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>--%>
                        <div class="row">
                            <div class="col-md-12" align="center">
                                <telerik:RadGrid ID="GridLocation" runat="server" AllowSorting="false" AllowPaging="true"
                                    AutoGenerateColumns="false" Width="99%" AllowMultiRowSelection="true" Style="min-height: 800px; background-color: rgba(254, 254, 254, 1);"
                                    Skin="Metro">
                                    <PagerStyle AlwaysVisible="true" Position="Top"></PagerStyle>
                                    <ClientSettings EnableRowHoverStyle="true">
                                        <%--<Selecting AllowRowSelect="false" EnableDragToSelectRows="false" UseClientSelectColumnOnly="false" />--%>
                                        <ClientEvents OnRowDataBound="GridLocation_RowDataBound" OnRowCreated="OnRowCreated"
                                            OnCommand="GridLocation_Command" OnRowClick="rowOnClick" />
                                        <Scrolling AllowScroll="True" UseStaticHeaders="true" ScrollHeight="700px"></Scrolling>
                                    </ClientSettings>
                                    <MasterTableView ClientDataKeyNames="ID,ZONENAME , SHORTNAME , ZONE , DEPARTMENT, DIVISION,ISTWOPORTERTASK , FLOORID, ISACTIVE,FLOORNAME, TAG,
                                                                         ISPORTERINGLOCATION,ISCATERINGLOCATION,ISCLEANINGLOCATION,ISSECURITYLOCATION,ISFEEDBACKLOCATION,CATERINGGROUPID,
                                                                         CLEANINGGROUPID,CLEANINGGROUPNAME"
                                        NoMasterRecordsText="NO REQUEST FOUND." TableLayout="Fixed" PageSize="15">
                                        <NoRecordsTemplate>
                                            <div class="LinkFont" style="padding-left: 10%">
                                                NO REQUEST FOUND.
                                            </div>
                                        </NoRecordsTemplate>
                                        <Columns>
                                            <%--<telerik:GridClientSelectColumn UniqueName="SELECT">
                                                                        <HeaderStyle Width="70px" HorizontalAlign="Center"></HeaderStyle>
                                                                    </telerik:GridClientSelectColumn>--%>

                                        <telerik:GridTemplateColumn UniqueName="EDIT" HeaderText="EDIT">
                                            <HeaderStyle Width="100px" />
                                            <ItemTemplate>
                                                <asp:Button ID="btnEdit" runat="server" Text="Edit" CommandName="Edit" OnClientClick="editRow(this);" />
                                            </ItemTemplate>
                                        </telerik:GridTemplateColumn>

                                        <telerik:GridBoundColumn HeaderText="ZONE NAME" DataField="ZONENAME" UniqueName="ZONENAME">
                                            <HeaderStyle Width="250px" />
                                        </telerik:GridBoundColumn>

                                        <telerik:GridBoundColumn HeaderText="SHORT NAME" DataField="SHORTNAME" UniqueName="SHORTNAME">
                                            <HeaderStyle Width="200px" />
                                        </telerik:GridBoundColumn>

                                        <telerik:GridBoundColumn HeaderText="DIVISION" DataField="DIVISION" UniqueName="DIVISION">
                                            <HeaderStyle Width="250px" />
                                        </telerik:GridBoundColumn>

                                        <telerik:GridBoundColumn HeaderText="ZONE" DataField="ZONE" UniqueName="ZONE">
                                            <HeaderStyle Width="200px" />
                                        </telerik:GridBoundColumn>

                                        <telerik:GridBoundColumn HeaderText="DEPARTMENT" DataField="DEPARTMENT" UniqueName="DEPARTMENT">
                                            <HeaderStyle Width="250px" />
                                        </telerik:GridBoundColumn>

                                        <telerik:GridBoundColumn HeaderText="ISACTIVE" DataField="ISACTIVE" UniqueName="ISACTIVE">
                                            <HeaderStyle Width="150px" />
                                        </telerik:GridBoundColumn>

                                        </Columns>
                                    </MasterTableView>
                                </telerik:RadGrid>
                            </div>
                        </div>


                        <div class="loaderElement" style="display: none">
                            <div class="loader-spinner"></div>
                        </div>
                    </div>
                    <!-- /Right Panel -->



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
                                    <p id="splChar" class="invalid">A special harecter [!@#$%^&*()\-+.] letter</p>

                                    <p id="number" class="invalid">A number</p>
                                    <p id="length" class="invalid">Minimum 12 characters</p>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade addTask" id="addLocation" tabindex="-1" aria-labelledby="addLocationLabel" aria-hidden="true" style="margin-top: 50px;">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="d-flex justify-content-between">
                            <div class="form-wrap me-4">
                                <div class="d-flex align-items-center justify-content-between mb-4">
                                    <h5 id="LocationHeader" style="font-family: monospace;"></h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                        <img src="../images/close-white.svg">
                                    </button>
                                </div>
                                <form id="formRequest">


                                    <div class="row">
                                        <div class="col-md-7">
                                            <div class="row">

                                                <div class="col-md-12" id="containerFrom">
                                                    <div class="mb-3">
                                                        <label>ZONE NAME <span style="color: red;">*</span></label>
                                                        <span id="errorZoneName" class="error-message"></span>
                                                        <textarea maxlength="50" name="txtZoneName" rows="1" class="form-control" placeholder="Zone Name" id="txtZoneName" style="padding: 15px;"></textarea>
                                                    </div>
                                                </div>

                                               <div class="mb-3">
                                                <label>SHORT NAME <span style="color: red;">*</span></label>
                                                <span id="errorZone" class="error-message"></span>
                                                  <input type="text" maxlength="20" name="txtShortName" class="form-control" placeholder="Short Name" id="txtShortName" style="padding: 10px;">
                                                </div>
<%--                                              <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label>ZONE</label>
                                                        <select name="selectFloor" id="search_floorName" tabindex="1" class="form-control search_test">
                                                            <option value="0">--Select--</option>
                                                        </select>
                                                    </div>
                                                </div>


                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label id="lblZoneType">DEPARTMENT</label>
                                                        <select name="selectFloor" id="search_KitchenZone" tabindex="1" class="form-control search_test">
                                                            <option value="0">--Select--</option>
                                                        </select>
                                                    </div>
                                                </div>--%>

                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label>ZONE</label>
                                                        <select name="selectZones" id="search_ZonesName" tabindex="1" class="form-control search_test">
                                                            <option value="0">--Select--</option>
                                                        </select>
                                                    </div>
                                                </div>


                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label id="lblZoneType">DEPARTMENT</label>
                                                        <select name="selectDepartments" id="search_DepartmentZone" tabindex="1" class="form-control search_test">
                                                            <option value="0">--Select--</option>
                                                        </select>
                                                    </div>
                                                </div>

                                                
                                                <div class="col-md-12" id="containerAddress" style="display:none">
                                                    <div class="mb-3">
                                                        <label>ADDRESS</label>
                                                        <textarea maxlength="250" name="txtAddress" rows="1" class="form-control" placeholder="Address" id="txtAddress" style="padding: 15px;"></textarea>
                                                    </div>
                                                </div>

<%--                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label>CLEANING ZONE</label>
                                                        <select name="selectFloor" id="search_CleaningZone" tabindex="1" class="form-control search_test">
                                                            <option value="0">--Select--</option>
                                                        </select>
                                                    </div>
                                                </div>--%>

                                                <div class="col-md-12" id="containerMac" style="display: none">
                                                    <div class="mb-3">
                                                        <label>MAC ID</label>
                                                        <textarea maxlength="50" name="txtMacId" rows="1" class="form-control" placeholder="Mac ID" id="txtMacId" style="padding: 15px;"></textarea>
                                                    </div>
                                                </div>

                                                <div class="col-md-12" id="containerAP" style="display: none">
                                                    <div class="mb-3">
                                                        <label>AP NAME</label>
                                                        <textarea maxlength="50" name="txtAPName" rows="1" class="form-control" placeholder="AP Name" id="txtAPName" style="padding: 15px;"></textarea>
                                                    </div>
                                                </div>

<%--                                                <div class="col-md-12" id="containerMP" style="padding-top: 20px; margin-bottom: 30px;" align="center">
                                                    <table style="width: 100%;">
                                                        <tr>
                                                            <td style="padding-left: 10px; padding-top: 15px;">
                                                                <label>DIRECTORATE</label>
                                                            </td>
                                                            <td style="padding-left: 10px; padding-right: 10px;">
                                                                <img 
                                                                    src="../images/CNoCheck.png" 
                                                                    id="chkDirectorate" 
                                                                    onclick="changeCheck(this);" 
                                                                    data-value="DIRECTORATE"
                                                                    style="width: 23px" 
                                                                    class="MultiPorter" />
                                                            </td>

                                                            <td style="padding-left: 10px; padding-top: 15px;">
                                                                <label>LICENSED</label>
                                                            </td>
                                                            <td style="padding-left: 10px; padding-right: 10px;">
                                                                <img 
                                                                    src="../images/CNoCheck.png" 
                                                                    id="chkLicensed" 
                                                                    onclick="changeCheck(this);" 
                                                                    data-value="LICENSED"
                                                                    style="width: 23px" 
                                                                    class="MultiPorter" />
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td style="padding-left: 10px; padding-top: 15px;">
                                                                <label>LOG IDENTIFIERS</label>
                                                            </td>
                                                            <td style="padding-left: 10px; padding-right: 10px;">
                                                                <img 
                                                                    src="../images/CNoCheck.png" 
                                                                    id="chkLogIdentifiers" 
                                                                    onclick="changeCheck(this);" 
                                                                    data-value="LOG_IDENTIFIERS"
                                                                    style="width: 23px" 
                                                                    class="MultiPorter" />
                                                            </td>

                                                            <td style="padding-left: 10px; padding-top: 15px;">
                                                                <label>IS ACTIVE</label>
                                                            </td>
                                                            <td style="padding-left: 10px; padding-right: 10px;">
                                                                <img 
                                                                    src="../images/CNoCheck.png" 
                                                                    id="chkIsActive" 
                                                                    onclick="changeCheck(this);" 
                                                                    data-value="ISACTIVE"
                                                                    style="width: 23px" 
                                                                    class="MultiPorter" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>--%>
                                                <div class="col-md-12" id="containerMP" style="padding-top: 20px; margin-bottom: 30px;" align="center">
                                                    <table style="width: 100%;">
                                                        <tr style="display: none;">
                                                            <td style="padding-left: 10px; padding-top: 15px;">
                                                                <label>DIRECTORATE</label>
                                                            </td>
                                                            <td style="padding-left: 10px; padding-right: 10px;">
                                                                <img 
                                                                    src="../images/CNoCheck.png" 
                                                                    id="chkDirectorate" 
                                                                    onclick="changeCheck(this);" 
                                                                    data-value="DIRECTORATE"
                                                                    style="width: 23px" 
                                                                    class="MultiPorter" />
                                                            </td>
                                                            <td style="padding-left: 10px; padding-top: 15px;">
                                                                <label>LICENSED</label>
                                                            </td>
                                                            <td style="padding-left: 10px; padding-right: 10px;">
                                                                <img 
                                                                    src="../images/CNoCheck.png" 
                                                                    id="chkLicensed" 
                                                                    onclick="changeCheck(this);" 
                                                                    data-value="LICENSED"
                                                                    style="width: 23px" 
                                                                    class="MultiPorter" />
                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td style="display: none;">
                                                                <label>LOG IDENTIFIERS</label>
                                                            </td>
                                                            <td style="display: none;">
                                                                <img 
                                                                    src="../images/CNoCheck.png" 
                                                                    id="chkLogIdentifiers" 
                                                                    onclick="changeCheck(this);" 
                                                                    data-value="LOG_IDENTIFIERS"
                                                                    style="width: 23px" 
                                                                    class="MultiPorter" />
                                                            </td>

                                                            <td style="padding-left: 100px; padding-top: 15px;">
                                                                <label>IS ACTIVE</label>
                                                            </td>
                                                            <td style="padding-left: 10px; padding-right: 360px;">
                                                                <img 
                                                                    src="../images/CNoCheck.png" 
                                                                    id="chkIsActive" 
                                                                    onclick="changeCheck(this);" 
                                                                    data-value="ISACTIVE"
                                                                    style="width: 23px" 
                                                                    class="MultiPorter" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-5">
                                            <div class="row">
<%--                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label>TAG</label>
                                                        <textarea maxlength="50" name="txtTAG" rows="1" class="form-control" placeholder="#Tag" id="txtTAG" style="padding: 15px;"></textarea>
                                                    </div>
                                                </div>--%>
                                                <div class="col-md-12" id="containerTurnaroundTime" style="display:none">
                                                  <div class="mb-3">
                                                    <label>TURNAROUND TIME</label>
                                                    <input type="time" name="turnaroundTime" id="turnaroundTime" class="form-control" required />
                                                  </div>
                                                </div>

                                                <div class="col-md-12" id="containerSkillsSome" style="display:none">
                                                  <div class="mb-3">
                                                    <label>Skills Required by Some Employees</label>
                                                    <textarea maxlength="40" name="skillsRequiredBySome" rows="1" class="form-control" placeholder="Enter skills" id="skillsRequiredBySome" style="padding: 15px;"></textarea>
                                                  </div>
                                                </div>

                                                <div class="col-md-12" id="containerSkillsAll" style="display:none">
                                                  <div class="mb-3">
                                                    <label>Skills Required by All Employees</label>
                                                    <textarea maxlength="40" name="skillsRequiredByAll" rows="1" class="form-control" placeholder="Enter skills" id="skillsRequiredByAll" style="padding: 15px;"></textarea>
                                                  </div>
                                                </div>
                                                 <div class="col-md-12">
                                                  <div class="mb-3">
                                                    <label style="font-weight: 600;">DIVISION <span style="color: red;">*</span></label> 
                                                    <div id="containerDivision" style="padding-top: 10px;">
                                                      <table>
                                                        <tr>
                                                          <td style="padding-left: 10px; padding-top: 10px;">
                                                            <div style="display: inline-flex; align-items: center; cursor: pointer;">
                                                              <img 
                                                                src="../images/CNoCheck.png" 
                                                                id="chkQAH" 
                                                                onclick="changeCheck(this);" 
                                                                data-value="Queen Alexandra Hospital" 
                                                                class="MultiPorter MultiPorterDivision" 
                                                                style="width: 18px; height: 18px; margin-right: 8px;" />
                                                              <span>Queen Alexandra Hospital</span>
                                                            </div>
                                                          </td>
                                                        </tr>
                                                        <tr>
                                                          <td style="padding-left: 10px; padding-top: 10px;">
                                                            <div style="display: inline-flex; align-items: center; cursor: pointer;">
                                                              <img 
                                                                src="../images/CNoCheck.png" 
                                                                id="chkRAD" 
                                                                onclick="changeCheck(this);" 
                                                                data-value="Receipt and Distribution" 
                                                                class="MultiPorter MultiPorterDivision" 
                                                                style="width: 18px; height: 18px; margin-right: 8px;" />
                                                              <span>Receipt and Distribution</span>
                                                            </div>
                                                          </td>
                                                        </tr>
                                                      </table>
                                                    </div>
                                                  </div>
                                                </div>

<%--                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label>Nearby Zones</label>

                                                        <textarea maxlength="50" name="txtsearchNearbyZones" rows="1" class="form-control" placeholder="Enter here.." id="txtsearchNearbyZones" style="padding: 15px;"></textarea>
                                                        <div id="suggesstionNearBy" class="col-md-6"></div>

                                                    </div>
                                                </div>--%>

                                                <div id="divNearByZones" class="completeRemarks" style="max-height: 310px; overflow-y: auto; padding: 5px;"></div>
                                                <div class="col-md-12">
                                                    <div class="RequestIcons" style="padding: 10px">
                                                        <div class="mb-3 row">
                                                            <div class="col-sm-4">
                                                                <button type="button" class="btn btn-outline w-100"
                                                                    data-bs-dismiss="modal">
                                                                    <img src="../images/multiply.svg">
                                                                    Close</button>
                                                            </div>

                                                            <div class="col-sm-4">
                                                                <button type="button" class="btn btn-secondary w-100" onclick="submitLocation();">
                                                                    <img
                                                                        src="../images/envelope.png">
                                                                    Submit</button>
                                                            </div>
                                                            <div class="col-sm-4">
                                                                <button type="button" class="btn btn-outline w-100" onclick="deleteLocation();return false;" id="btnDeleteLocation" style="background-color: #a4a4a4;">
                                                                    <table>
                                                                        <tr>
                                                                            <td align="center">
                                                                                <img src="../images/delete.png"></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td align="center" style="color: white; transition: 0.5s; border-radius: 10px; font-size: 14px; font-weight: 500;">Delete</td>
                                                                        </tr>
                                                                    </table>

                                                                </button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

<%--                                                <div class="col-md-12" id="containerServices" style="padding-top: 20px; padding-left: 20px; margin-bottom: 30px;" align="center">
                                                    <fieldset>
                                                        <legend>SERVICES</legend>
                                                        <div class="row">
                                                            <div class="col-md-5">
                                                                <table style="width: 100%">
                                                                    <tr>
                                                                        <td style="padding-left: 10px; padding-top: 15px;">
                                                                            <label style="font-size: 15px;">Portering</label>
                                                                        </td>
                                                                        <td style="padding-left: 10px; padding-right: 10px;">
                                                                            <img src="../images/CNoCheck.png" id="chkIsPortering" onclick="changeCheck(this);" style="width: 23px" class="MultiPorter">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                            <div class="col-md-5">
                                                                <table style="width: 100%">
                                                                    <tr>
                                                                        <td style="padding-left: 10px; padding-top: 15px;">
                                                                            <label style="font-size: 15px;">Receipt and Distribution</label>
                                                                        </td>
                                                                        <td style="padding-left: 10px; padding-right: 10px;">
                                                                            <img src="../images/CNoCheck.png" id="chkIsCatering" onclick="changeCheck(this);" style="width: 23px" class="MultiPorter">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </fieldset>
                                                </div>--%>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col"></div>
                                </form>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="modalAlert" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-md">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="NRSuccess">Alert</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                            <img src="../images/close-white.svg">
                        </button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="mb-3 text-center">
                                        <img src="../images/priority.png" alt="Icon Success">
                                    </div>
                                    <div class="mb-3 text-center">
                                        <span>LOCATION DETAILS ALREADY EXISTS.</span>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="modalSuccess" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-md">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Success</h5>
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
                                        <div class="mb-3 text-center">
                                            <span id="LBLRequestResult"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="modalNearByList" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-md">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="headNearbyLocations">Nearby Zones</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                            <img src="../images/close-white.svg">
                        </button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="row">
                                <div class="col-md-12 completeRemarks" id="divNearByLocations" style="max-height: 310px; overflow-y: auto; padding: 5px;">
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="modalAlertExport" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-md">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Alert</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                            <img src="../images/close-white.svg">
                        </button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="mb-3 text-center">
                                        <img src="../images/priority.png" alt="Icon Success">
                                    </div>
                                    <div class="mb-3 text-center">
                                        <span>Downloading Location Details... This may take few seconds, please wait..</span>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <!-- JS CSS -->
        <script src="../js/bootstrap.bundle.min.js"></script>
        <script src="../js/jquery.sumoselect.min.js"></script>
        <script src="../js/style.js"></script>

    </form>
</body>
</html>
<script>

    function loadZoneDepartmentDropdowns() {
        var FinalUrl = hurl + "Service/Service.aspx?" +
            "Process=" + encodeURIComponent(Encrypt("GETZONEDEPARTMENT"));

        $.ajax({
            type: "POST",
            url: FinalUrl,
            data: {},
            dataType: "json",
            success: function (data) {

                var $zoneSelect = $('#search_ZonesName');
                $zoneSelect.empty().append($('<option>', {
                    value: '0',
                    text: '--Select--'
                }));

                if (data && data.zones && Array.isArray(data.zones)) {
                    data.zones.forEach(function (zone) {
                        $zoneSelect.append($('<option>', {
                            value: zone.id || '',
                            text: zone.name || 'Unknown'
                        }));
                    });
                }

                if ($zoneSelect[0] && $zoneSelect[0].sumo) {
                    $zoneSelect[0].sumo.reload();
                }

                var $deptSelect = $('#search_DepartmentZone');
                $deptSelect.empty().append($('<option>', {
                    value: '0',
                    text: '--Select--'
                }));

                if (data && data.departments && Array.isArray(data.departments)) {
                    data.departments.forEach(function (dept) {
                        $deptSelect.append($('<option>', {
                            value: dept.id || '',
                            text: dept.name || 'Unknown'
                        }));
                    });
                }

                if ($deptSelect[0] && $deptSelect[0].sumo) {
                    $deptSelect[0].sumo.reload();
                }
            },
            error: function (xhr, status, error) {
                console.error("Error loading dropdown data:", status, xhr.status, xhr.responseText.substring(0, 200));
            }
        });
    }
    function changeCheck(imgElem) {
        if (imgElem.src.includes("CNoCheck.png")) {
            imgElem.src = "../images/CCheck.png";
        } else {
            imgElem.src = "../images/CNoCheck.png";
        }
    }

    function getSelectedMultiCheckValue(className) {
        let values = [];
        $(className).each(function () {
            if ($(this).attr('src').includes("CCheck.png")) {
                values.push($(this).data('value'));
            }
        });
        return values.join(', ');
    }


    $(document).ready(function () {
        $('#search_ZonesName').SumoSelect();
        $('#search_DepartmentZone').SumoSelect();

        loadZoneDepartmentDropdowns();
    });

    function isChecked(selector) {
        return $(selector).attr('src') && $(selector).attr('src').includes("CCheck.png");
    }

    function getCheckedValues(className) {
        var values = [];
        $('.' + className).each(function () {
            if ($(this).attr('src') && $(this).attr('src').includes("CCheck.png")) {
                values.push($(this).data('value'));
            }
        });
        return values.join(',');
    }

    function editRow(button) {
        var row = button.closest('tr');

        var grid = $find("<%= GridLocation.ClientID %>");
        var dataItem = grid.get_masterTableView().get_dataItems()[row.rowIndex];

        var ZoneID = dataItem.get_dataKeyValue("ID");

        $.ajax({
            type: "POST",
            url: "Service/Service.aspx/GetLocationDetails",
            data: JSON.stringify({ ZoneID: ZoneID }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                var location = response.d;

                setEditLocation(location.ZoneID, location.ZoneName, location.ShortName, location.Zone, location.Department, location.IsActive);
            },
            error: function (xhr, status, error) {
                console.error("Error fetching location data: " + error);
            }
        });
    }

    function selectSumoByValue(sumoId, value) {
        var options = $('#' + sumoId + ' option');
        var indexToSelect = -1;
        options.each(function (index) {
            var optionValue = $(this).val().trim();
            var optionText = $(this).text().trim();

            if (optionValue === value || optionText === value) {
                indexToSelect = index;
                return false;
            }
        });

        if (indexToSelect !== -1) {
            $('#' + sumoId)[0].sumo.selectItem(indexToSelect);
        } else {
            console.warn("Value not found in dropdown:", value);
        }
    }
    function clearLocationForm() {
        $('#txtZoneName').val('');
        $('#txtShortName').val('');
        $('#search_ZonesName').val('0');
        $('#search_ZonesName')[0].sumo.reload();

        $('#search_DepartmentZone').val('0');
        $('#search_DepartmentZone')[0].sumo.reload();

        $('#chkIsActive').attr("src", "../images/CNoCheck.png");

        $('#chkQAH').attr('src', "../images/CNoCheck.png");
        $('#chkRAD').attr('src', "../images/CNoCheck.png");

        $('#LocationHeader').html('Add New Location');
    }

    function AddLocation() {
        clearLocationForm();
        $('#addLocation').modal('show');
    }

    function setEditLocation(ZoneID, ZoneName, ShortName, Division, Zone, Department, IsActive) {
        console.log({
            ZoneID,
            ZoneName,
            ShortName,
            Division,
            Zone,
            Department,
            IsActive
        });
        $('#txtZoneName').val(ZoneName);
        $('#txtShortName').val(ShortName);
        $('#search_ZonesName').val(Zone);
        $('#search_DepartmentZone').val(Department);

        const active = (IsActive && (IsActive.toString().toLowerCase() === 'yes' || IsActive === '1'));
        $('#chkIsActive').attr("src", active ? "../images/CCheck.png" : "../images/CNoCheck.png");

        if (Division) {
            var divs = Division.split(',');
            divs.forEach(function (div) {
                div = div.trim();
                if (div === 'Queen Alexandra Hospital') {
                    $('#chkQAH').attr('src', "../images/CCheck.png");
                }
                else {
                    $('#chkRAD').attr('src', "../images/CCheck.png");
                }
            });
        }

        selectSumoByValue('search_ZonesName', Zone);
        selectSumoByValue('search_DepartmentZone', Department);


        $('#editModal').modal('show');
        $('#LocationHeader').html('Edit Location #' + ZoneName);
    }

    $('#chkIsActive').on('change', function () {
    });

    function encryptAES(text) {
        const key = CryptoJS.enc.Utf8.parse('9090909090909090');
        const iv = CryptoJS.enc.Utf8.parse('9090909090909090');

        const encrypted = CryptoJS.AES.encrypt(text, key, {
            iv: iv,
            mode: CryptoJS.mode.CBC,
            padding: CryptoJS.pad.Pkcs7
        });

        return encodeURIComponent(encrypted.toString());
    }

    function submitLocation() {
        $('#txtZoneName, #search_ZonesName, #search_DepartmentZone').removeClass('input-error');
        $('#errorZoneName, #errorZone, #errorDepartment').text('');

        let isValid = true;

        var ZoneName = $('#txtZoneName').val().trim();
        var ShortName = $('#txtShortName').val().trim();
        var Zone = $('#search_ZonesName').val();
        var Department = $('#search_DepartmentZone').val();
        var Address = $('#txtAddress').val().trim();
        var TurnaroundTime = $('#turnaroundTime').val() || "00:00:00";
        if (TurnaroundTime.length === 5) TurnaroundTime += ":00";

        var SkillRequiredSome = $('#skillsRequiredBySome').val();
        var SkillRequiredAll = $('#skillsRequiredByAll').val();

        var Division = getCheckedValues('MultiPorterDivision');
        var Directorate = isChecked('#chkDirectorate') ? "1" : "0";
        var Licensed = isChecked('#chkLicensed') ? "1" : "0";
        var IsActive = isChecked('#chkIsActive') ? "1" : "0";
        var LogIdentifiers = isChecked('#chkLogIdentifiers') ? "1" : "0";

        if (!ZoneName) {
            $('#txtZoneName').addClass('input-error');
            $('#errorZoneName').text('Zone Name is required.');
            isValid = false;
        }

        if (!Zone || Zone === '0') {
            $('#search_ZonesName').addClass('input-error');
            $('#errorZone').text('Short name is required.');
            isValid = false;
        }

        if (!isValid) return;

        console.log('ZoneName:', ZoneName);
        console.log('ShortName:', ShortName);
        console.log('Zone:', Zone);
        console.log('Department:', Department);
        console.log('Address:', Address);
        console.log('Division:', Division);
        console.log('Directorate:', Directorate);
        console.log('Licensed:', Licensed);
        console.log('IsActive:', IsActive);
        console.log('TurnaroundTime:', TurnaroundTime);
        console.log('SkillRequiredSome:', SkillRequiredSome);
        console.log('SkillRequiredAll:', SkillRequiredAll);
        console.log('LogIdentifiers:', LogIdentifiers);

        var FinalUrl = hurl + "Service/Service.aspx?" +
            "Process=" + encodeURIComponent(Encrypt("UPDATLOCATIONS")) +
            "&ZoneName=" + encodeURIComponent(Encrypt(ZoneName)) +
            "&ShortName=" + encodeURIComponent(Encrypt(ShortName)) +
            "&Zone=" + encodeURIComponent(Encrypt(Zone)) +
            "&Department=" + encodeURIComponent(Encrypt(Department)) +
            "&Address=" + encodeURIComponent(Encrypt(Address)) +
            "&Division=" + encodeURIComponent(Encrypt(Division)) +
            "&Directorate=" + encodeURIComponent(Encrypt(Directorate)) +
            "&Licensed=" + encodeURIComponent(Encrypt(Licensed)) +
            "&IsActive=" + encodeURIComponent(Encrypt(IsActive)) +
            "&TurnaroundTime=" + encodeURIComponent(Encrypt(TurnaroundTime)) +
            "&SkillRequiredSome=" + encodeURIComponent(Encrypt(SkillRequiredSome)) +
            "&SkillRequiredAll=" + encodeURIComponent(Encrypt(SkillRequiredAll)) +
            "&LogIdentifiers=" + encodeURIComponent(Encrypt(LogIdentifiers));

        $.ajax({
            type: "POST",
            url: FinalUrl,  
            data: {},       
            dataType: "json",
            success: function (data) {
                console.log('Update response:', data);

                if (data && data.result === "TRUE") {
                    $('#LBLRequestResult').text(`Location "${ZoneName}" updated successfully!`);
                    var successModal = new bootstrap.Modal(document.getElementById('modalSuccess'), { keyboard: false });
                    successModal.show();

                    setTimeout(function () {
                        successModal.hide();
                        location.reload();
                    }, 2000);

                } else {
                    $('#modalAlert span').text(`Failed to update location: ${data ? data.result || 'Unknown error' : 'No response'}`);
                    var alertModal = new bootstrap.Modal(document.getElementById('modalAlert'), { keyboard: false });
                    alertModal.show();

                    setTimeout(function () {
                        alertModal.hide();
                    }, 2000);
                }
            },

            error: function (xhr, status, error) {
                alert("Failed to save. Error: " + error);
            }
        });
    }

    function deleteLocation() {
        var ZoneName = $('#txtZoneName').val().trim();

        if (!ZoneName) {
            alert('Zone Name is required for deletion.');
            return;
        }

        console.log('Deleting ZoneName:', ZoneName);

        var FinalUrl = hurl + "Service/Service.aspx?" +
            "Process=" + encodeURIComponent(Encrypt("DELETELOCATION")) +
            "&ZoneName=" + encodeURIComponent(Encrypt(ZoneName));

        console.log('Delete URL:', FinalUrl);

        $.ajax({
            type: "POST",
            url: FinalUrl,
            data: {},
            dataType: "json",
            success: function (data) {
                console.log('Delete response:', data);

                if (data && data.result === 'TRUE') {
                    $('#LBLRequestResult').html('Location Details Removed Successfully.. Zone Name: ' + ZoneName);
                    HideModalPopUp('addLocation');
                    ShowModalPopUp('modalSuccess');
                    setTimeout(function () {
                        HideModalPopUp('modalSuccess');
                        LoadProcess();
                    }, 2500);
                } else {
                    alert('Failed to delete location: ' + (data ? data.result || 'Unknown error' : 'No response'));
                }
            },
            error: function (xhr, status, error) {
                console.error("Delete error:", status, error);
                alert('Error deleting location: ' + error);
            }
        });
    }


</script>