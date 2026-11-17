<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="Index_Index" ValidateRequest="false" %>

<html lang="en">

<head>
    <title>Home | TRACZO</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <link rel="icon" href="../favicon.png" />

    <link rel="stylesheet" href="../css/bootstrap.min.css" />
    <link rel="stylesheet" href="../css/sumoselect.min.css">
    <link rel="stylesheet" href="../css/style.css" />
    <link rel="stylesheet" href="../css/Index.css" />
    <link rel="stylesheet" href="../css/pager.css" />
    <link rel="stylesheet" href="../css/changepwd.css" />
    <link rel="stylesheet" href="../css/ajax.min.css" />
    <link href="../css/Equans/1.10.5.bootstrap-iconss.css" rel="stylesheet">
    <link href="../css/Equans/5.3.3.bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/Equans/bootstrap-icons.css" />

    <link rel="stylesheet" href="../css/Equans/6.4.0.all.min.css" />
    <link rel="stylesheet" href="../css/Equans/boot-fonts.css" />

    <script src="../js/bootstrap.bundle.min.js?v=5.3.3"></script>
    <script src="../js/jquery-3.7.1.min.js"></script>
    <script src="../js/Equans/bootstrap.bundle.min.js"></script>


    <script src="../js/aes.js"></script>
    <script src="../js/Index7.js"></script>
    <script src="../js/bulk.js"></script>
    <script src="../js/ChangePassword1.js"></script>
    <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">
        <script type="text/javascript">
            var isRefreshing = false;
            var dataSet = [], hurl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Index/",
                divServiceArray = ['divPorteringService', 'divCateringService', 'divCleaningService', 'divFeedbackService', 'divSecurityService'],
                urlPageValidation =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/MasterPage/Service/Service.aspx?",
                CryptoKey = '<%=ConfigurationManager.AppSettings["CryptoKey"].ToString() %>',
                CryptoPwd = '<%=ConfigurationManager.AppSettings["CryptoIV"].ToString() %>',
                ConProtocol = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>',
                CProcess = 10, grid, gridMasterTable, pageSize = 20, pageIndex = 0, olddatetime = '', prebook = '', TimerHome, ToUpdate = false,
                FPatientName = '', TPatientName = '', MRDPatientName = '', GCancelReason, GFinishReason, GTagID, CurrentDStatus, GReqID, GPorterID, IsEdit, GMIndex = '0', GExtn = '', ReqDate = '', ReqTime = '', ReqCat = '0', RFromID = '0', RToID = '0', RHalt1 = '0', RHalt2 = '0', RPreBook = '0',
                Efrom, ETo, ECategory, EDate, EPatient, Remarks, AReqID, APorter1, APorter2, ADept, Isclear = false, PorterID1 = '', PorterName1 = '', PorterID = '', PorterName = '', PORTERGROUP = '', ISMULTIPORTER = 'NO', IsReturn = 'NO',
                MAReqID = '', MADept = '', MACount = 60, MANReqID = '', MANCount = 60, MANPorterID = '', MANPorterName = '', GPatientName = '', GFrom = '', GStatus = '2', GOMI = '0', GUser = '', ATReqNB = '',
                IsMRD = 'NO', IsMTPR = '0', IsRTC = '0', OIsMTPR = '0', ServiceCode = '1', EServiceCode = '', callFrom = 'Parent';
            var OldFromID = '', OldFrom = '', OldToID = '', OldTo = '', OldCatID = '', OldCategory = '', OldPatientName = '', OldQuantity = '', OldRequestorName = '', OldIsMultiPorter = '0', OKitchen = '',
                LBKitName = '', CatKitName = '', LBKitID = '0', CatKitID = '0',
                NewFrom = '', NewTo = '', NewCategory = '', IsHaywood = false, FHaywood = 'NO', ToHaywood = 'NO';
            const valuePage = {
                truncate: true,
                curPage: 0,
                numLinksTwoSide: 1,
                totalPages: 0
            };
            var PorterCurTasks = '', PendingTasks = '', ATPorterID = '', ATPorterName = '', ATStatus = '', ATReqNB = '';
            var Base64 = { _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=", encode: function (e) { var t = ""; var n, r, i, s, o, u, a; var f = 0; e = Base64._utf8_encode(e); while (f < e.length) { n = e.charCodeAt(f++); r = e.charCodeAt(f++); i = e.charCodeAt(f++); s = n >> 2; o = (n & 3) << 4 | r >> 4; u = (r & 15) << 2 | i >> 6; a = i & 63; if (isNaN(r)) { u = a = 64 } else if (isNaN(i)) { a = 64 } t = t + this._keyStr.charAt(s) + this._keyStr.charAt(o) + this._keyStr.charAt(u) + this._keyStr.charAt(a) } return t }, decode: function (e) { var t = ""; var n, r, i; var s, o, u, a; var f = 0; e = e.replace(/[^A-Za-z0-9+/=]/g, ""); while (f < e.length) { s = this._keyStr.indexOf(e.charAt(f++)); o = this._keyStr.indexOf(e.charAt(f++)); u = this._keyStr.indexOf(e.charAt(f++)); a = this._keyStr.indexOf(e.charAt(f++)); n = s << 2 | o >> 4; r = (o & 15) << 4 | u >> 2; i = (u & 3) << 6 | a; t = t + String.fromCharCode(n); if (u != 64) { t = t + String.fromCharCode(r) } if (a != 64) { t = t + String.fromCharCode(i) } } t = Base64._utf8_decode(t); return t }, _utf8_encode: function (e) { e = e.replace(/rn/g, "n"); var t = ""; for (var n = 0; n < e.length; n++) { var r = e.charCodeAt(n); if (r < 128) { t += String.fromCharCode(r) } else if (r > 127 && r < 2048) { t += String.fromCharCode(r >> 6 | 192); t += String.fromCharCode(r & 63 | 128) } else { t += String.fromCharCode(r >> 12 | 224); t += String.fromCharCode(r >> 6 & 63 | 128); t += String.fromCharCode(r & 63 | 128) } } return t }, _utf8_decode: function (e) { var t = ""; var n = 0; var r = c1 = c2 = 0; while (n < e.length) { r = e.charCodeAt(n); if (r < 128) { t += String.fromCharCode(r); n++ } else if (r > 191 && r < 224) { c2 = e.charCodeAt(n + 1); t += String.fromCharCode((r & 31) << 6 | c2 & 63); n += 2 } else { c2 = e.charCodeAt(n + 1); c3 = e.charCodeAt(n + 2); t += String.fromCharCode((r & 15) << 12 | (c2 & 63) << 6 | c3 & 63); n += 3 } } return t } };
            var ArCtrl = ["TxtCurPassword", "TxtPassword", "TxtConfirmPassword"], UsrPassword = ((sessionStorage.getItem('PASSWORD') == null) ? "" : Base64.decode(sessionStorage.getItem('PASSWORD'))),
                arrError = ["ErCurrent", "ErPassword", "ErCPassword"], PageName = document.location.pathname.match(/[^\/]+$/)[0];
        </script>
    </telerik:RadCodeBlock>

    </head>

    <body class="">
    <form runat="server">

        <asp:HiddenField ID="HFCancelReqID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFCancelReqNB" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFCancelMUIndex" runat="server" ClientIDMode="Static" />


        <asp:HiddenField ID="HFOnHoldReqID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFOnHoldReqNB" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFOnHoldPorterID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFOnHoldMUIndex" runat="server" ClientIDMode="Static" />


        <asp:HiddenField ID="HFSCReqID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFSCReqNB" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFSCMUIndex" runat="server" ClientIDMode="Static" />


        <asp:HiddenField ID="HFERID" runat="server" ClientIDMode="Static" />


        <asp:HiddenField ID="HFERNO" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFStatusID" runat="server" ClientIDMode="Static" />


        <asp:HiddenField ID="HFCryptoKey" runat="server" ClientIDMode="Static" />

        <asp:HiddenField ID="HFCryptoIv" runat="server" ClientIDMode="Static" />
        <telerik:RadScriptManager ID="RadScriptManager" runat="server" EnablePageMethods="true">
        </telerik:RadScriptManager>
        <div class="lang-menu" style="visibility: hidden">
            <a class="select-language" href="index-thai.html">Thai</a>
        </div>
        <div id="loader" class="loader-wrapper loaderElement">
            <div class="loader-spinner"></div>

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
                                    <img src="../images/hospital.jpg" alt="Hospital">
                                </div>
                                <div class="hospital-title">
                                    <h5>Welcome</h5>
                                    <h6>Queen Alexandra Hospital,</h6>
                                    <p>Cosham, Portsmouth, PO6 3LY</p>
                                </div>
                                <br />

                                <br />
                                <div class="left-panel-menu">
                                    <ul>
                                        <li class="current-menu-item">
                                            <a href="../Index/Index.aspx">
                                                <span>
                                                    <img src="../images/home.png" alt="Home"></span> Home
                                            </a>
                                        </li>
                                        <li>
                                            <a href="../Reports/Report.aspx">
                                                <span>
                                                    <img src="../images/clipboard.png" alt="Reports"></span> Reports
                                            </a>
                                        </li>
                                         <li>
                                            <a href="#" onclick="MoveToTraczo()">
                                                <span>
                                                    <img src="../favicon.png" alt="Reports"></span> Traczo
                                            </a>
                                        </li>
                                    </ul>
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

                                        <div class="DivPassword" id="DivPassword" style="display: none">
                                            <ul class='Pmenu'>

                                                <li><a onclick="ChangePassword();">Change Password </a></li>

                                            </ul>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="left-icons-container">
                        <div class="icon-bar" style="background-color: whitesmoke;">
                            <div class="icon" id="hamburger" title="Menu">
                                <i class="bi bi-list"></i>
                            </div>

                            <%--<div class="icon" title="Home" onclick="openLeftPanel()">
                          <i class="bi bi-house-door"></i>
                        </div>
                        <div class="icon" title="Break" onclick="openLeftPanel()">
                          <i class="bi bi-clock"></i>
                        </div>
                        <div class="icon" title="Reports" onclick="openLeftPanel()">
                          <i class="bi bi-journal-text"></i>
                        </div>
                        <div class="icon" title="User Master" onclick="openLeftPanel()">
                          <i class="bi bi-person"></i>
                        </div>
                        <div class="icon" title="Location Master" onclick="openLeftPanel()">
                          <i class="bi bi-geo-alt"></i>
                        </div>--%>
                        </div>
                    </div>

                    <!-- left panel (flyover) -->
                    <div class="screen-left-panel hidden">
                        <h3 style="padding: 20px;">Left Panel Content</h3>
                    </div>
                    <!-- /Left Panel -->

                    <!-- Right Panel -->
                    <div class="screen-right-panel w-100">
                        <div class="row" style="display: none">
                            <div class="col-12">

                                <!-- Section heading -->
                                <div class="section-head d-flex justify-content-between align-items-center mb-3">
                                    <div class="section-head-left">
                                        <h5>Task</h5>
                                    </div>
                                    <div class="section-head-right d-flex align-items-center">
                                        <div class="export-link" style="visibility: hidden">
                                            <a href="#" class="btn btn-secondary">
                                                <img src="../images/printer.png" alt="Export">
                                                Export
                                            </a>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <div class="col-md-3" s>
                                <!-- Users Task -->
                                <div class="users-task-count">
                                    <!-- Section heading -->
                                    <div class="section-head">
                                        <div class="section-head-left">
                                            <h5>Users</h5>
                                        </div>
                                        <div class="section-head-right">
                                            <span data-bs-toggle="tooltip" data-bs-placement="left" title="Tooltip on left">
                                                <img src="../images/info.svg" alt="Info">
                                            </span>
                                        </div>
                                    </div>
                                    <!-- /Section heading -->
                                    <hr>
                                    <%--  <div class="users-task-count-item">
                                        <ul>
                                            <li class="ChartLinks" onclick="getPorterStatus('0');">
                                                <span class="users-task-label">On-Duty</span>
                                                <span class="users-task-count-number" id="countOnDutyCount">00</span>
                                            </li>
                                            <li class="ChartLinks" onclick="getPorterStatus('1');">
                                                <span class="users-task-label">Busy</span>
                                                <span class="users-task-count-number" id="countBusyCount">00</span>
                                            </li>
                                            <li class="ChartLinks" onclick="getPorterStatus('2');">
                                                <span class="users-task-label">Idle</span>
                                                <span class="users-task-count-number" id="countIdleCount">00</span>
                                            </li>
                                            <li class="ChartLinks" onclick="getPorterStatus('3');">
                                                <span class="users-task-label">On Break</span>
                                                <span class="users-task-count-number" id="countOnBreakCount">00</span>
                                            </li>
                                        </ul>
                                    </div>--%>
                                    <%-- <div class="row user-task-total text-center" align="center">
                                        <div class="col-lg-12 col-xl-4 ChartLinks" onclick="getPorterStatus('4');">
                                            <div class="alert alert-success" role="alert">
                                                <div class="mb-2">
                                                    <img src="../images/up-arrow.png">
                                                </div>
                                                <p>
                                                    Max Tasks
                                                <br>
                                                    <span class="users-task-count-number" id="MaxTasks">00</span>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="col-lg-12 col-xl-4 ChartLinks" onclick="getPorterStatus('5');">
                                            <div class="alert alert-danger" role="alert">
                                                <div class="mb-2">
                                                    <img src="../images/down-arrow.png">
                                                </div>
                                                <p>
                                                    Min Tasks
                                                <br>
                                                    <span class="users-task-count-number" id="MinTasks">00</span>

                                                </p>
                                            </div>
                                        </div>
                                        <div class="col-lg-12 col-xl-4" style="display: none">
                                            <div class="alert alert-primary" role="alert">
                                                <div class="mb-2">
                                                    <img src="../images/compass.png">
                                                </div>
                                                <p>
                                                    Average
                                                <br>
                                                    <span class="users-task-count-number" id="AvgTasks">00</span>
                                                </p>
                                            </div>
                                        </div>
                                    </div>--%>
                                </div>
                                <!-- /Users Task -->
                            </div>
                        </div>

                        <%--<div class="screen-right-panel">--%>
                        <div class="navigation-tabs-wrapper">
                            <div class="services-button">
                                <label>Division</label>
                            </div>
                            <div class="services-tabs-wrapper">
                                <div class="services-btn-icon" data-color="rgb(255, 116, 0)" id="divService1">
                                    <img src="../images/porter-icon.svg" />
                                    <span>Portering</span>
                                </div>
                                <div class="services-btn-icon" data-color="rgb(12, 188, 139)" id="divService2">
                                    <img src="../images/cater-icon.png" />
                                    <span>Receipt and Distribution</span>
                                </div>
                                <div class="services-btn-icon" data-color="rgb(110, 48, 243)" id="divService3" style="display: none">
                                    <img src="../images/clean-icon.svg" />
                                    <span>Clean</span>
                                </div>
                                <div class="services-btn-icon" data-color="rgb(255, 87, 51)" id="divService4" style="display: none">
                                    <img src="../images/pest-icon.svg" />
                                    <span>Feedback</span>
                                </div>
                                <div class="services-btn-icon" data-color="rgb(255, 87, 51)" id="divService5" style="display: none">
                                    <img src="../images/security-icon.svg" />
                                    <span>Security</span>
                                </div>

                            </div>

                            <div class="action-btn-wrapper">
                                <div class="user-info-wrapper">
                                    <nav class="navbar compact-navbar">
                                        <div class="user-info compact-user-panel">
                                            <div class="user-avatar">
                                                <img class="avatar-img" src="../images/user-icon.jpg" alt="User Avatar" />
                                            </div>
                                            <span class="welcome-animation">Hi Welcome!</span>
                                            <span class="user-name" id="userName"></span>
                                        </div>
                                    </nav>
                                </div>

                                <div style="height: 15px;"></div>

                                <div class="auto-refresh-container">
                                    <div class="switch-bubble auto-refresh-wrapper">
                                        <label class="switch-label">Auto Refresh</label>
                                        <label class="switch-auto">
                                            <input type="checkbox" id="chkAutoRefresh">
                                            <span class="slider-auto round"></span>
                                        </label>

                                        <span id="refreshCountdown" class="refresh-countdown">
                                            <span id="countdownSeconds">30</span>s
                                        </span>
                                    </div>
                                </div>

                                <div class="switch-button" style="display: none">
                                    <label>
                                        Haywood
                                    </label>
                                    <label class="switch">
                                        <input type="checkbox" id="chkHaywoodRequests">
                                        <span class="slider1 round"></span>
                                    </label>
                                </div>
                                <div class="switch-button" style="display: none">
                                    <label id="lblUserRequest">
                                        PORTERS
                                    </label>
                                    <label class="switch">
                                        <input type="checkbox" id="chkUserRequest">
                                        <span class="slider1 round"></span>
                                    </label>
                                </div>
                            </div>


                        </div>

                        <div class="search-tabs-wrap w-100">
                            <div class="search-tab-container" style="display: none">
                                <div class="tabs-wrapper">

                                    <%-- <div class="row">
                                <div class="col-md-12" align="right">

                                    <table style="border: 2px solid #E3F2FD; background-color: #2870ff; color: white !important; font-weight: bold; border-radius: 8px; margin-right: -142px; margin-top: -42px;">
                                        <tr>
                                            <td style="padding-left: 10px; padding-top: 10px;">
                                                <label id="lblUserRequest" style="color: white !important; font-weight: bold; font-size: 16px">
                                                    PORTERS</label></td>
                                            <td style="padding-left: 20px; padding-right: 10px;">
                                                <label class="switch">
                                                    <input type="checkbox" id="chkUserRequest">
                                                    <span class="slider1 round"></span>
                                                </label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>

                            </div>--%>
                                    <div class="row" id="divRequestHeaders" style="margin-left: 0px !important; display: none">

                                        <%--     <div class="InnerIndexIcon col-md-1" id="divTotalPercentage" onclick='Select("divTotalPercentage","TOTAL");' style ="display:none">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countTotalCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                TOTAL
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divPendingPercentage" onclick='Select("divPendingPercentage","PENDING");' style ="display:none">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countPendingCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                PENDING
                                            </p>
                                        </div>

                                        <div class="InnerIndexIcon col-md-1" id="divAssignedPercentage" onclick='Select("divAssignedPercentage","ASSIGNED");' style ="display:none">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countAssignedCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                ASSIGNED
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divInprogressPercentage" onclick='Select("divInprogressPercentage","INPROGRESS");' style ="display:none">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countInprogressCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                IN-PROGRESS
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divCompletedPercentage" onclick='Select("divCompletedPercentage","COMPLETED");' style ="display:none">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countCompletedCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                COMPLETED
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divPendingOnHoldPercentage" onclick='Select("divPendingOnHoldPercentage","ONHOLD");' style ="display:none">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countPendingOnHoldCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                ON-HOLD
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divPrebookeddPercentage" onclick='Select("divPrebookeddPercentage","PREBOOKED");' style ="display:none">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countPreBookedCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                PRE-BOOKED 
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divCancelledPercentage" onclick='Select("divCancelledPercentage","CANCELLED");' style ="display:none">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countCancelledCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                CANCELLED
                                            </p>
                                        </div>

                                    <div class="InnerIndexIcon col-md-1" id="divTatExceededPercentage" onclick='Select("divTatExceededPercentage","TATEXCEED");' style="display: none;">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countTATExceedCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                TAT EXCEEDED
                                            </p>
                                        </div>
                                        --%>
                                    </div>


                                    <div class="row" id="divUserHeaders" style="display: none;">

                                        <div class="InnerIndexIcon col-md-1" id="divOnDuty" onclick="getPorterStatus('0','divOnDuty');">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countOnDutyCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                ON-DUTY
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divBusy" onclick="getPorterStatus('1','divBusy');">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countBusyCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                BUSY
                                            </p>
                                        </div>

                                        <div class="InnerIndexIcon col-md-1" id="divIdle" onclick="getPorterStatus('2','divIdle');">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countIdleCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                IDLE
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divOnBreak" onclick="getPorterStatus('3','divOnBreak');">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countOnBreakCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                ON BREAK
                                            </p>
                                        </div>

                                        <div class="InnerIndexIcon col-md-1" id="divMaxTask" onclick="getPorterStatus('4','divMaxTask');">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="MaxTasks">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                MAX TASKS
                                            </p>
                                        </div>

                                        <div class="InnerIndexIcon col-md-1" id="divMinTask" onclick="getPorterStatus('5','divMinTask');">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="MinTasks">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                MIN TASKS
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divAvgCount" onclick="getPorterStatus('6','divAvgCount');" style="display: none;">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="AvgTasks">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                AVERAGE
                                            </p>
                                        </div>
                                    </div>

                                </div>

                                <div class="search-wrap" style="width: 100%; display: none">
                                    <div class="search-box">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="row" id="taskfileters">
<%--                                                    <div class="col-md-4">
                                                        <fieldset style="display: none">
                                                            <legend>Task Filters</legend>


                                                            <div class="row" style="display: none">

                                                                <div class="col-md-6">
                                                                    <select name="selectFloor" id="search_TaskFields" tabindex="1" class="form-control search_test" onchange="OnchangeFilter('search_TaskFields','txtSearchTask');return false;">

                                                                        <option value="R.REQUESTID" selected>REQ #</option>
                                                                        <option value="REQUESTORNAME">Requested By</option>
                                                                        <option value="CATEGORYNAME_LONG#CategoryName">Task Type</option>
                                                                        <option value="L.ZONENAME">From Location</option>
                                                                        <option value="D.ZONENAME">To Location</option>
                                                                        <option value="CONTACTNO">Contact No</option>
                                                                        <option value="KPI_Reference">Task Code</option>
                                                                        <option value="PM.USERNAME">Porter Name</option>
                                                                        <option value="L.TAG#D.TAG">TAG #</option>

                                                                    </select>


                                                                </div>
                                                                <div class="col-md-6">
                                                                    <div class="search-wrap w-100" style="margin: 0px;">
                                                                        <div class="search-box">
                                                                            <form>
                                                                                <input type="search" maxlength="30" autocomplete="off webauthn" id="txtSearchTask" class="form-control" placeholder="Search">

                                                                                <input type="submit" value="" class="search-submit" onclick="setIndexscreen(); return false;">
                                                                            </form>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </fieldset>


                                                    </div>--%>
<%--                                                    <div class="col-md-5">

                                                        <fieldset style="display: none">
                                                            <legend>Patient/Notes Filters</legend>
                                                            <div class="row">

                                                                <div class="col-md-6">
                                                                    <select name="selectFloor" id="search_PatientRemarks" class="form-control search_test" onchange="OnchangeFilter('search_PatientRemarks','txtSearchPatient');return false;">
                                                                        <option value="PATIENTNAME" selected>Name/DOB/Bed No.</option>
                                                                        <option value="[dbo].[FN_GETCOMPLTEREMARK] (R.REQUESTID)">Task Notes</option>
                                                                        <option value="PORTERREMARKS">Porter Remarks</option>
                                                                        <option value="REMARKS">Cancel Remarks</option>
                                                                        <option value="REQUESTDESKREMARKS">Request Desk Remarks</option>
                                                                    </select>


                                                                </div>
                                                                <div class="col-md-6">
                                                                    <div class="search-wrap w-100" style="margin: 0px;">
                                                                        <div class="search-box">
                                                                            <form>
                                                                                <input type="search" maxlength="30" autocomplete="off webauthn" id="txtSearchPatient" class="form-control" placeholder="Search">
                                                                                <input type="submit" value="" class="search-submit" onclick="setIndexscreen(); return false;">
                                                                            </form>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </fieldset>
                                                    </div>--%>

<%--                                                    <div class="col-md-3" id="DivKitchenFilters">

                                                        <fieldset>
                                                            <legend>KITCHEN</legend>
                                                            <div class="row">

                                                                <div class="col-md-12">
                                                                    <select name="selectFloor" id="search_Kitchen" class="form-control search_test" onchange="setIndexscreen(); return false;">
                                                                        <option value="" selected>ALL</option>
                                                                        <option value="Haywood">HAYWOOD</option>
                                                                        <option value="Lyme Zone">LYME</option>
                                                                        <option value="O Zone">M&O</option>
                                                                        <option value="Main">MAIN & RETAIL</option>
                                                                        <option value="PFI 2 Zone">PFI 2</option>
                                                                        <option value="PFI 3 Zone">PFI 3</option>
                                                                        <option value="SUPERVISOR">SUPERVISOR</option>
                                                                    </select>

                                                                </div>
                                                            </div>
                                                        </fieldset>
                                                    </div>--%>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                                <!-- /Search -->
                            </div>
                        </div>


                        <%--</div>--%>
                        <!-- Tabs -->
                        <div class="tabs mt-3">
                            <ul class="nav nav-tabs" id="myTab" role="tablist" style="display: none;">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="tasks-tab" data-bs-toggle="tab"
                                        data-bs-target="#tasks" type="button" role="tab" aria-controls="tasks"
                                        aria-selected="true">
                                        Tasks</button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="users-tab" data-bs-toggle="tab" data-bs-target="#users"
                                        type="button" role="tab" aria-controls="users" aria-selected="false" onclick="getPorterStatus('0');">
                                        Users</button>
                                </li>
                            </ul>
                            <div class="tab-content" id="myTabContent" align="center">
                                <div class="tab-pane fade show active" id="tasks" role="tabpanel"
                                    aria-labelledby="tasks-tab">
                                    <div class="table-wrap" style="min-height: 800px; max-width: 100%">
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="page-container" style="display: none;">
                                                    <button class="first-page" style="padding: 0px;" onclick="handleButton(this); return false;" disabled>
                                                        <i class="fas fa-angle-double-left"></i>
                                                    </button>
                                                    <button class="prev-page" style="padding: 0px;" onclick="handleButton(this); return false;" disabled>
                                                        <i class="fas fa-angle-left"></i>
                                                    </button>
                                                    <div id="pagination"></div>
                                                    <button class="next-page" style="padding: 0px;" onclick="handleButton(this); return false;" disabled>
                                                        <i class="fas fa-angle-right"></i>
                                                    </button>
                                                    <button class="last-page" style="padding: 0px;" onclick="handleButton(this); return false;" disabled>
                                                        <i class="fas fa-angle-double-right"></i>
                                                    </button>
                                                    <label style="margin: 5px 15px 5px 25px;" class="pgSize">page size</label>
                                                    <input type="number" id="pageSize" name="pageSize" min="10" max="50" value="20" class="form-control pgSize" style="width: 80px; text-align: center;" onchange="changeGridSize(this); return false;">
                                                </div>
                                            </div>
                                        </div>
                                        <%--                                        <div class="table-responsive" id="tblRequests" style="max-width: 98%;">
                                        </div>--%>

                                        <div class="container-fluid">
                                            <div class="d-flex justify-content-between align-items-center py-3">
                                                <h2 class="mb-0">Control Desk</h2>

                                                <div class="d-flex gap-2 ms-auto">
                                                    <a href="javascript:void(0);" class="btn btn-primary d-flex align-items-center" onclick="setNewTask();" style="height: 45px; width: 110px;">
                                                        <img src="../images/memo.png" alt="Add Task" style="height: 20px; margin-right: 8px; display: inline; display: none">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 32 32" fill="white">
                                                            <rect x="4" y="6" width="16" height="3" rx="1.5" fill="white" />
                                                            <rect x="4" y="14" width="16" height="3" rx="1.5" fill="white" />
                                                            <rect x="4" y="22" width="16" height="3" rx="1.5" fill="white" />
                                                            <rect x="23" y="13" width="2" height="8" rx="1" fill="white" />
                                                            <rect x="20" y="16" width="8" height="2" rx="1" fill="white" />
                                                        </svg>New Task
                                                    </a>

                                                    <a href="javascript:void(0);" class="btn btn-primary d-flex align-items-center justify-content-center" onclick="RefreshTasks();" style="height: 45px; width: 135px;">
                                                        <img src="../images/refresh.png" alt="Refresh" style="height: 20px; margin-right: 8px;">
                                                        Refresh
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="scroll-wrapper">
                                            <div class="row gx-2">
                                                <!-- Pending Column -->
                                                <div class="col-md-4">
                                                    <div class="column-container">
                                                        <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap">
                                                          <h6 class="mb-0" data-heading="pending" style="margin-top: -20px;">Pending</h6>

                                                            <div class="d-flex align-items-center gap-2 filter-wrapper" 
                                                                 style="position: relative; margin-top: -15px;">
                         
                                                                <div class="prebooked-toggle">
                                                                    <input type="checkbox" id="showPrebookedCheckbox" />
                                                                    <label for="showPrebookedCheckbox">Pre-Booked Tasks</label>
                                                                </div>                                                           
                                                                <i class="bi bi-funnel filter-icon" id="openFilterModal" style="cursor: pointer;"></i>
                                                                <div class="filter-panel border bg-white p-3 shadow-sm"
                                                                    style="display: none; position: absolute; top: 25px; right: 0; width: 360px; z-index: 100;">
                                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                                        <h5 class="mb-0">Filters</h5>
                                                                        <button  type="button" class="btn btn-sm btn-outline-primary clear-filters">Clear</button>
                                                                    </div>
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">Task ID</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="taskIdSelect" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">Task type</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="taskTypeSelect" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">Equipment type</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="equipmentSelect" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">Task Status</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="requestStatusSelect" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">From Location</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="fromLocationSelect" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">To Location</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="toLocationSelect" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">From Zone</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="fromZoneSelect" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>

                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">To Zone</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="toZoneSelect" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">Employee</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="employeeSelect" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="d-flex justify-content-end">
                                                                        <button class="btn btn-sm btn-grey me-2" type="button">Cancel</button>
                                                                        <button class="btn btn-sm btn-primary apply-filters pending" type="button">Apply</button>
                                                                    </div>
                                                                </div>
                                                                <div class="dropdown">
                                                                    <a class="d-flex align-items-center text-decoration-none text-muted small dropdown-toggle" href="#" role="button" id="sortDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                                                        <i class="bi bi-filter me-1"></i>Sort Time
                                                                    </a>
                                                                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="sortDropdown">
                                                                        <li><a class="dropdown-item sort-option" href="#" data-order="asc">Lowest to Highest</a></li>
                                                                        <li><a class="dropdown-item sort-option" href="#" data-order="desc">Highest to Lowest</a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <input class="form-control form-control-sm" 
                                                               id="pendingFilter" 
                                                               placeholder="Filter..." 
                                                               style="margin-top: -3px; margin-bottom: 8px; width: 100%;" />
                                                            <div class="scrollable-list" id="pendingList">
                                                            <!-- Dynamically loaded tasks will go here -->
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Started Column -->
                                                <div class="col-md-4">
                                                    <div class="column-container">
                                                        <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap">
                                                            <h6 class="mb-0">Started</h6>
                                                            <div class="d-flex align-items-center gap-2 filter-wrapper" style="position: relative;">
                                                                <i class="bi bi-funnel filter-icon" id="openStartedFilterModal" style="cursor: pointer;"></i>
                                                                <div class="filter-panel border bg-white p-3 shadow-sm"
                                                                    style="display: none; position: absolute; top: 25px; right: 0; width: 360px; z-index: 100;">
                                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                                        <h5 class="mb-0">Filters</h5>
                                                                        <button type="button" class="btn btn-sm btn-outline-primary clear-filters">Clear</button>
                                                                    </div>
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">Task ID</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="taskIdSelectStarted" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">Task type</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="taskTypeSelectStarted" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">Equipment type</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="equipmentSelectStarted" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">From Location</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="fromLocationSelectStarted" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">To Location</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="toLocationSelectStarted" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">Employee</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="employeeSelectStarted" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="d-flex justify-content-end">
                                                                        <button class="btn btn-sm btn-grey me-2" type="button">Cancel</button>
                                                                        <button class="btn btn-sm btn-primary apply-filters started" type="button">Apply</button>
                                                                    </div>
                                                                </div>
                                                                <div class="dropdown">
                                                                    <a class="d-flex align-items-center text-decoration-none text-muted small dropdown-toggle" href="#" role="button" id="sortDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                                                        <i class="bi bi-filter me-1"></i>Sort Time
                                                                    </a>
                                                                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="startedSortDropdown">
                                                                        <li><a class="dropdown-item started-sort-option" href="#" data-order="asc">Lowest to Highest</a></li>
                                                                        <li><a class="dropdown-item started-sort-option" href="#" data-order="desc">Highest to Lowest</a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <input class="form-control form-control-sm mb-2" id="startedFilter" placeholder="Filter..." style="margin-top: 2px; margin-bottom: 8px; width: 100%;" />
                                                        <div class="scrollable-list" id="startedList">
                                                            <!-- Dynamically loaded tasks will go here -->
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Column: Employees -->
                                                <div class="col-md-4">
                                                    <div class="column-container">
                                                        <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap">
                                                            <h6 class="mb-0">Employees</h6>
                                                            <div class="d-flex align-items-center gap-2 filter-wrapper" style="position: relative;">
                                                                <i class="bi bi-funnel filter-icon" id="openEmployeeFilterModal" style="cursor: pointer;"></i>

                                                                <!-- Inside filter-panel -->
                                                                <div class="filter-panel border bg-white p-3 shadow-sm"
                                                                    style="display: none; position: absolute; top: 25px; right: 0; width: 360px; z-index: 100;">
                                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                                        <h5 class="mb-0">Filters</h5>
                                                                        <button type="button" class="btn btn-sm btn-outline-primary clear-filters">Clear</button>
                                                                    </div>

                                                                    <!-- Generic filter row template -->
                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">User Name</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="employeeUserName" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>

                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">Division</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="employeeHospital" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>

                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">Shift</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="employeeShift" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>

                                                                    <div class="mb-2 row g-2 align-items-center">
                                                                        <div class="col-5">
                                                                            <label class="form-label text-start w-100 mb-0">Status</label>
                                                                        </div>
                                                                        <div class="col-7">
                                                                            <select id="employeeStatus" class="form-select form-select-sm">
                                                                                <option>Select items...</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>

                                                                    <div class="d-flex justify-content-end">
                                                                        <button class="btn btn-sm btn-grey me-2" type="button">Cancel</button>
                                                                        <button class="btn btn-sm btn-primary apply-filters" type="button">Apply</button>
                                                                    </div>
                                                                </div>

                                                                <div class="dropdown">
                                                                    <a class="d-flex align-items-center text-decoration-none text-muted small dropdown-toggle" href="#" role="button" id="sortDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                                                        <i class="bi bi-filter me-1"></i>Sort Time
                                                                    </a>
                                                                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="sortDropdown">
                                                                        <li><a class="dropdown-item" href="#" onclick="sortTasks('asc')">Lowest to Highest</a></li>
                                                                        <li><a class="dropdown-item" href="#" onclick="sortTasks('desc')">Highest to Lowest</a></li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <input class="form-control form-control-sm mb-2" id="employeeFilter" placeholder="Filter..." />
                                                        <div class="scrollable-list" id="employeeList">
                                                            <!-- Dynamically loaded tasks will go here -->
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="tab-pane fade" id="users" role="tabpanel" aria-labelledby="users-tab">
                                            <div class="table-wrap">
                                                <div class="table-responsive" id="tblUsers" style="max-width: 98%;">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
        
                                <!-- /Tabs -->
                            </div>

                        </div>
                        <!-- /Right Panel -->
                    </div>

                    <div class="loaderElement" style="display: none">
                        <div class="loader-spinner"></div>
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
                                                                <div class="export-link">
                                                                    <a href="#" class="btn btn-secondary" onclick="ValidatePassword(); return false;">
                                                                        <img src="../images/memo.png" alt="Change" />
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

                <!-- EDIT TASK MODAL -->
                <div class="modal fade" id="editTaskModal" tabindex="-1" aria-labelledby="editTaskLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content shadow-lg rounded-5 border-0">
                            <div class="modal-header" style="background: linear-gradient(135deg, #1e3c72, #2a5298); border-bottom: 2px solid #ffffff;">
                                <h5 class="modal-title fw-bold text-white" id="editTaskLabel">
                                    <i class="bi bi-pencil-square me-2 text-white"></i>Edit Task
                                    <span id="taskIdDisplay" class="ms-2 text-light fw-normal"></span>
                                </h5>

                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" id="btnCloseEditTaskModal" aria-label="Close" aria-hidden="true">
                                    <img src="../images/close-white.svg" alt="Close" />
                                </button>
                            </div>

                            <div class="modal-body px-4 py-4">
                              <form id="formEditTask">
                                <input type="hidden" id="editRequestId" />

                                    <div class="row g-3 mb-2">
                                        <div class="col-md-6" id="containerDates" style="display: none">
                                            <div class="mb-3">
                                                <label for="txtReqdates" class="fw-bold">Date</label>
                                                <input type="date" id="txtReqdates" class="form-control form-control-sm shadow-sm">
                                            </div>
                                        </div>
                                        <div class="col-md-6" id="containerTimes" style="display: none">
                                            <div class="mb-3">
                                                <label for="txtReqTimes" class="fw-bold">Time</label>
                                                <input type="time" id="txtReqTimes" class="form-control form-control-sm shadow-sm">
                                            </div>
                                        </div>
                                    </div>

                                <div class="row g-3 mb-2">
                                  <div class="col-md-6 col-12">
                                    <label class="fw-bold">CATEGORY NAME</label>
                                    <select id="editCategoryName" class="form-control form-control-sm shadow-sm">
                                      <option value="" disabled selected hidden></option>
                                    </select>
                                  </div>
                                  <div class="col-md-6 col-12">
                                    <label class="fw-bold">EQUIPMENT TYPE</label>
                                    <select id="editEquipmentType" class="form-control form-control-sm shadow-sm">
                                      <option value="" disabled selected hidden></option>
                                    </select>
                                  </div>
                                </div>

                                <div class="row g-3 mb-2">
                                  <div class="col-md-6 col-12">
                                    <label class="fw-bold">FROM LOCATION</label>
                                    <select id="editFromLocation" class="form-control form-control-sm shadow-sm">
                                      <option value="" disabled selected hidden></option>
                                    </select>
                                  </div>
                                  <div class="col-md-6 col-12">
                                    <label class="fw-bold">TO LOCATION</label>
                                    <select id="editToLocation" class="form-control form-control-sm shadow-sm">
                                      <option value="" disabled selected hidden></option>
                                    </select>
                                  </div>
                                </div>

                                <div class="row g-3">
                                  <div class="col-md-6 col-12">
                                    <label class="fw-bold">PATIENT NAME</label>
                                    <input type="text" id="editPatientName"
                                           class="form-control form-control-sm shadow-sm"
                                           placeholder="Enter Patient Name" maxlength="100" />
                                  </div>
                                  <div class="col-md-6 col-12">
                                    <label class="fw-bold">REMARKS</label>
                                    <select id="editRemarks" class="form-select form-select-sm shadow-sm remark-field mb-2">
                                      <option value="" disabled selected hidden>--select--</option>
                                    </select>
                                    <textarea maxlength="1000" name="task-description" rows="3"
                                              class="form-control form-control-sm shadow-sm"
                                              placeholder="Enter the remark" id="editRemarksText"></textarea>
                                  </div>
                                </div>
                              </form>
                            </div>

                         <div class="modal-footer border-0 d-flex justify-content-center pb-4">
                             <button class="btn btn-success px-4" id="updateTaskBtn">
                                <i class="bi bi-check-circle me-2"></i>Update Task
                            </button>
                        </div>
                      </div>
                    </div>
                </div>


                <!-- Assign Request Modal -->
                <div class="modal fade" id="assignRequestModal" tabindex="-1" aria-labelledby="assignRequestModalLabel" aria-hidden="true" data-bs-backdrop="static">
                    <div class="modal-dialog modal-dialog-scrollable modal-lg modal-dialog-centered" style="max-width: 700px;">
                        <div class="modal-content border-0" style="border-radius: 16px; overflow: hidden; box-shadow: 0 20px 40px rgba(0,0,0,0.15);">

                            <!-- Modal Header with dark text -->
                            <div class="modal-header py-3 px-4" style="background: linear-gradient(135deg, #f8faff 0%, #f0f4ff 100%); border-bottom: 2px solid #e9ecef;">
                                <div class="d-flex align-items-center">
                                    <div class="rounded-circle d-flex align-items-center justify-content-center me-3" 
                                         style="width: 44px; height: 44px; background: linear-gradient(135deg, #4361ee, #3a56d4);">
                                        <i class="bi bi-inbox text-white fs-4"></i>
                                    </div>
                                    <div>
                                        <h5 class="modal-title fw-bold mb-1" id="assignRequestModalLabel" style="color: #1e293b; font-size: 1.35rem;">
                                            Pending Requests
                                        </h5>
                                        <p class="mb-0 small" style="color: #64748b;">Select a task to assign to the porter</p>
                                    </div>
                                </div>
                                <button type="button" id="btnCloseAssignModal" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close" aria-hidden="false">
                                    <img src="../images/close-white.svg" alt="Close" style="width: 22px; height: 22px;">
                                </button>
                            </div>

                            <div class="modal-body px-4 py-4" style="background-color: #ffffff;">
                                <ul id="pendingRequestList" class="list-group list-group-flush">
                                </ul>
                            </div>

                            <div class="modal-footer border-0 px-4 py-3 d-flex justify-content-end gap-2" style="background-color: #f8fafc;">
                                <button type="button" class="btn px-4 py-2" data-bs-dismiss="modal" 
                                        style="background-color: #6c757d; border: 1px solid #5a6268; color: white; border-radius: 40px; font-weight: 500;">
                                    <i class="bi bi-x-lg me-2"></i>Close
                                </button>
                            </div>

                        </div>
                    </div>
                </div>

            <div class="modal fade" id="bulkAssignModal" tabindex="-1" aria-labelledby="bulkAssignModalLabel" aria-hidden="true" data-bs-backdrop="static">
                <div class="modal-dialog modal-dialog-scrollable modal-xl modal-dialog-centered" style="max-width: 800px;">
                    <div class="modal-content border-0" style="border-radius: 16px; overflow: hidden; box-shadow: 0 20px 40px rgba(0,0,0,0.15);">
            
                        <div class="modal-header py-3 px-4" style="background: linear-gradient(135deg, #f8faff 0%, #f0f4ff 100%); border-bottom: 2px solid #e9ecef;">
                            <div class="d-flex align-items-center">
                                <div class="rounded-circle d-flex align-items-center justify-content-center me-3" 
                                     style="width: 44px; height: 44px; background: linear-gradient(135deg, #4361ee, #3a56d4);">
                                    <i class="bi bi-person-lines-fill text-white fs-4"></i>
                                </div>
                                <div>
                                    <h5 class="modal-title fw-bold mb-1" id="bulkAssignModalLabel" style="color: #1e293b; font-size: 1.35rem;">
                                        Bulk Assign Tasks
                                    </h5>
                                    <p class="mb-0 small" style="color: #64748b;">Select multiple tasks to assign to a porter</p>
                                </div>
                            </div>
                        </div>

                        <div class="modal-body p-4" style="background-color: #ffffff;">
                
                            <!-- Search Bar -->
                            <div class="mb-3">
                                <div class="input-group" style="border: 1px solid #e2e8f0; border-radius: 12px; overflow: hidden; background: #f8fafc;">
                                    <span class="input-group-text bg-transparent border-0" style="color: #64748b;">
                                        <i class="bi bi-search"></i>
                                    </span>
                                    <input
                                        type="text"
                                        class="form-control bg-transparent border-0 ps-0"
                                        id="bulkRequestSearch"
                                        placeholder="Search by zone, location, or task ID..."
                                        style="box-shadow: none; outline: none; padding: 12px 0;"
                                        autocomplete="off"
                                    />
                                    <span class="input-group-text bg-transparent border-0" id="searchClear" style="cursor: pointer; display: none;">
                                        <i class="bi bi-x-circle-fill" style="color: #94a3b8; font-size: 0.9rem;"></i>
                                    </span>
                                </div>
                            </div>

                            <!-- Select All Controls -->
                            <div class="d-flex justify-content-between align-items-center mb-2 p-2 bg-light rounded-3">
                                <div class="d-flex align-items-center gap-3">
                                    <button type="button" class="btn btn-sm btn-outline-primary rounded-pill px-3" id="btnSelectAll">
                                        <i class="bi bi-check2-square me-1"></i> Select All
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-secondary rounded-pill px-3" id="clearAllSelections">
                                        <i class="bi bi-x-circle me-1"></i> Clear
                                    </button>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge bg-light text-dark px-3 py-2 rounded-pill">
                                        <i class="bi bi-check-circle-fill text-success me-1"></i>
                                        <span id="selectedCount">0</span> Selected
                                    </span>
                                </div>
                            </div>

                            <!-- Task List -->
                            <div id="bulkRequestList" 
                                 class="list-group border rounded-3 overflow-auto"
                                 style="max-height: 400px; background-color: #ffffff; border-color: #e9ecef !important;">
                    
                                <div class="text-center py-5 loading-state">
                                    <div class="spinner-border text-primary" role="status" style="width: 2.5rem; height: 2.5rem;">
                                        <span class="visually-hidden">Loading tasks...</span>
                                    </div>
                                    <p class="mt-2 text-muted small">Loading available tasks...</p>
                                </div>
                    
                            </div>

                            <!-- Bulk Assign Button -->
                            <div class="mt-3 d-flex justify-content-end">
                                <button type="button" class="btn btn-primary rounded-pill px-4" id="btnBulkAssign" disabled>
                                    <i class="bi bi-person-check-fill me-2"></i>
                                    Bulk Assign (<span id="bulkAssignCount">0</span>)
                                </button>
                            </div>

                        </div>

                        <div class="modal-footer border-0 px-4 py-3 d-flex justify-content-end gap-2" style="background-color: #f8fafc;">
                            <button type="button" class="btn px-4 py-2" data-bs-dismiss="modal" id="btnCloseBulkAssignModal"
                                    style="background-color: #6c757d; border: 1px solid #5a6268; color: white; border-radius: 40px; font-weight: 500;">
                                <i class="bi bi-x-lg me-2"></i>Close
                            </button>
                        </div>

                    </div>
                </div>
            </div>

                <!-- Message Modal -->
                <div class="modal fade" id="messageModal" tabindex="-1" aria-labelledby="messageModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">

                            <div class="modal-header">
                                <h5 class="modal-title" id="messageModalLabel">Send Message</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
                                    <img src="../images/close-white.svg">
                                </button>
                            </div>

                            <div class="modal-body">
                                <textarea id="messageText" class="form-control" rows="6" placeholder="Type your message here..."></textarea>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-primary" id="sendMessageBtn">Send</button>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="modal fade" id="modalGenericSuccess" tabindex="-1" aria-labelledby="genericSuccessLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-md">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="genericSuccessLabel">Success</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                    <img src="../images/close-white.svg" alt="Close">
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="text-center mb-3">
                                    <img src="../images/icon-success.gif" alt="Success Icon">
                                </div>
                                <div class="text-center">
                                    <span id="LBLGenericSuccessResult" style="font-weight: 600;">Operation completed successfully!</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade level-2" id="modalEmployeeActionSuccess" tabindex="-1" aria-labelledby="employeeActionSuccessLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-md">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="employeeActionSuccessLabel">Action Success</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                    <img src="../images/close-white.svg" alt="Close">
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="text-center mb-3">
                                    <img src="../images/icon-success.gif" alt="Success Icon">
                                </div>
                                <div class="text-center">
                                    <span id="lblEmployeeActionResult" style="font-weight: 600;">Action done successfully!</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="porterWarningModal" tabindex="-1" aria-labelledby="porterWarningLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-md">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 id="porterWarningLabel">Alert</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="closePorterWarningModal();">
                                    <img src="/images/close-white.svg" alt="Close" />
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="text-center mb-3">
                                    <img src="/images/icon-warning.png" alt="Warning Icon" style="width: 64px; height: 64px;">
                                </div>
                                <div class="text-center">
                                    <span id="porterWarningText" style="font-weight: 600;">Porter is already in a task.</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade level-1" id="reassignModal" tabindex="-1" aria-labelledby="reassignModalLabel" aria-hidden="true" data-bs-backdrop="static">
                    <div class="modal-dialog modal-dialog-scrollable modal-lg modal-dialog-centered">
                        <div class="modal-content border-0" style="border-radius: 16px; overflow: hidden; box-shadow: 0 20px 40px rgba(0,0,0,0.15);">
            
                            <div class="modal-header py-3 px-4" style="background: linear-gradient(135deg, #f8faff 0%, #f0f4ff 100%); border-bottom: 2px solid #e9ecef;">
                                <div class="d-flex align-items-center">
                                    <div class="rounded-circle d-flex align-items-center justify-content-center me-3" 
                                         style="width: 44px; height: 44px; background: linear-gradient(135deg, #4361ee, #3a56d4);">
                                        <i class="bi bi-person-check-fill text-white fs-4"></i>
                                    </div>
                                    <div>
                                        <h5 class="modal-title fw-bold mb-1" id="reassignModalLabel" style="color: #1e293b; font-size: 1.35rem;">
                                            Reassign Porter
                                        </h5>
                                        <p class="mb-0 small" style="color: #64748b;">Select a new porter for this task</p>
                                    </div>
                                </div>
                            </div>

                            <div class="modal-body px-4 py-4" style="background-color: #ffffff;">
                                <input type="hidden" id="reassignTaskRequestId" name="requestId">

                                <div class="mb-10">
                                    <div class="input-group" style="border: 1px solid #e2e8f0; border-radius: 12px; overflow: hidden; background: #f8fafc;">
                                        <span class="input-group-text bg-transparent border-0" style="color: #64748b;">
                                            <i class="bi bi-search"></i>
                                        </span>
                                        <input
                                            type="text"
                                            class="form-control bg-transparent border-0 ps-0"
                                            id="reassignEmployeeFilter"
                                            placeholder="Search by name..."
                                            style="box-shadow: none; outline: none; padding: 12px 0;"
                                            autocomplete="off"
                                        />
                                        <span class="input-group-text bg-transparent border-0" id="reassignSearchClear" style="cursor: pointer; display: none;">
                                            <i class="bi bi-x-circle-fill" style="color: #94a3b8; font-size: 0.9rem;"></i>
                                        </span>
                                    </div>
                                </div>

                                <div class="border rounded-3 overflow-auto" style="max-height: 320px; background-color: #ffffff; border-color: #e9ecef !important;">
                                    <div class="list-group list-group-flush" id="FreeEmployeeList" style="border-radius: 0;">
                                               
                                    </div>
                                </div>

                                <div class="mt-3 selected-porter-indicator" style="display: none;">
                                    <div class="alert alert-success py-2 px-3 mb-0 d-flex justify-content-between align-items-center" role="alert" style="border-radius: 40px;">
                                        <div>
                                            <i class="bi bi-check-circle-fill me-2"></i>
                                            <span>Selected: <strong id="selectedPorterName"></strong></span>
                                        </div>
                                        <button type="button" class="btn btn-link text-success p-0" id="clearPorterSelection">
                                            <i class="bi bi-x-lg"></i>
                                        </button>
                                    </div>
                                </div>

                            </div>

                            <!-- Modal Footer -->
                            <div class="modal-footer border-0 px-4 py-3 d-flex justify-content-end gap-2" style="background-color: #f8fafc;">
                                <button type="button" class="btn px-4 py-2" data-bs-dismiss="modal" 
                                        style="background-color: #6c757d; border: 1px solid #5a6268; color: white; border-radius: 40px; font-weight: 500; transition: all 0.2s ease;">
                                    <i class="bi bi-x-lg me-2"></i>Close
                                </button>
                            </div>

                        </div>
                    </div>
                </div>

                <!-- Request Template Modal -->
                <template id="taskRowTemplate">
                    <div class="d-flex justify-content-between align-items-center px-3 py-2 border rounded mb-2 shadow-sm">
                        <div class="d-flex align-items-center gap-3 flex-wrap">
                            <div class="fw-semibold task-category"></div>
                            <div class="d-flex align-items-center gap-1">
                                <i class="bi bi-geo-alt text-dark"></i>
                                <span class="task-from"></span>
                                <i class="bi bi-arrow-right text-dark mx-1"></i>
                                <span class="task-to"></span>
                            </div>
                            <div class="d-flex align-items-center gap-1">
                                <i class="fas fa-wheelchair" style="color:grey;"></i>
                                <span class="task-equipment-name">N/A</span>
                            </div>
                            <div class="d-flex align-items-center gap-1">
                                <i class="fas fa-user-md" style="color:grey;"></i>
                                <span class="task-patient-name">N/A</span>
                            </div>
                            <div class="task-contact-no"></div>
                            <div class="task-requestor-info"></div>
                            <div class="d-flex align-items-center gap-1">
                                <i class="bi bi-plus-circle text-dark"></i>
                                <span class="task-porter-name">N/A</span>
                            </div>
                            <div class="task-multiporter-info"></div>
                            <div class="task-prebook-info"></div>
                            <div style="width: 105px;"></div>
                            <div class="d-flex align-items-center gap-2 position-relative ml-auto right-corner">
                                <span class="task-status"></span>
                                <div class="dropdown">
                                    <button class="btn btn-link text-dark p-0 m-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="bi bi-three-dots fs-5"></i>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end task-dropdown-menu"></ul>
                                </div>
                                <span class="badge task-badge"></span>
                            </div>
                        </div>
                    </div>
                </template>

                <div class="modal fade" id="assignModal" tabindex="-1" aria-labelledby="assignModalLabel" aria-hidden="true" data-bs-backdrop="static">
                    <div class="modal-dialog modal-dialog-scrollable modal-lg modal-dialog-centered">
                        <div class="modal-content border-0" style="border-radius: 16px; overflow: hidden; box-shadow: 0 20px 40px rgba(0,0,0,0.15);">
            
                            <div class="modal-header py-3 px-4" style="background: linear-gradient(135deg, #f8faff 0%, #f0f4ff 100%); border-bottom: 2px solid #e9ecef;">
                                <div class="d-flex align-items-center">
                                    <div class="rounded-circle d-flex align-items-center justify-content-center me-3" 
                                         style="width: 44px; height: 44px; background: linear-gradient(135deg, #4361ee, #3a56d4);">
                                        <i class="bi bi-person-plus-fill text-white fs-4"></i>
                                    </div>
                                    <div>
                                        <h5 class="modal-title fw-bold mb-1" id="assignModalLabel" style="color: #1e293b; font-size: 1.35rem;">
                                            Assign Porter
                                        </h5>
                                        <p class="mb-0 small" style="color: #64748b;">Select a porter to assign to this task</p>
                                    </div>
                                </div>
                            </div>

                            <div class="modal-body px-4 py-4" style="background-color: #ffffff;">
                
                                <div class="mb-3">
                                    <div class="input-group" style="border: 1px solid #e2e8f0; border-radius: 12px; overflow: hidden; background: #f8fafc;">
                                        <span class="input-group-text bg-transparent border-0" style="color: #64748b;">
                                            <i class="bi bi-search"></i>
                                        </span>
                                        <input
                                            type="text"
                                            class="form-control bg-transparent border-0 ps-0"
                                            id="assignEmployeeFilter"
                                            placeholder="Search by name, location, or status..."
                                            style="box-shadow: none; outline: none; padding: 12px 0;"
                                            autocomplete="off"
                                        />
                                        <span class="input-group-text bg-transparent border-0" id="assignSearchClear" style="cursor: pointer; display: none;">
                                            <i class="bi bi-x-circle-fill" style="color: #94a3b8; font-size: 0.9rem;"></i>
                                        </span>
                                    </div>
                                </div>

                                <div class="border rounded-3 overflow-auto" style="max-height: 360px; background-color: #ffffff; border-color: #e9ecef !important;">
                                    <div class="list-group list-group-flush" id="freeEmployeeList" style="border-radius: 0;">
                                                
                                    </div>
                                </div>

                                <div class="mt-3 selected-porter-indicator" id="assignSelectedIndicator" style="display: none;">
                                    <div class="alert alert-success py-2 px-3 mb-0 d-flex justify-content-between align-items-center" role="alert" style="border-radius: 40px;">
                                        <div>
                                            <i class="bi bi-check-circle-fill me-2"></i>
                                            <span>Selected: <strong id="assignSelectedPorterName"></strong></span>
                                        </div>
                                        <button type="button" class="btn btn-link text-success p-0" id="clearAssignSelection">
                                            <i class="bi bi-x-lg"></i>
                                        </button>
                                    </div>
                                </div>

                            </div>

                            <div class="modal-footer border-0 px-4 py-3 d-flex justify-content-end gap-2" style="background-color: #f8fafc;">
                                <button type="button" class="btn px-4 py-2" data-bs-dismiss="modal" 
                                        style="background-color: #6c757d; border: 1px solid #5a6268; color: white; border-radius: 40px; font-weight: 500; transition: all 0.2s ease;">
                                    <i class="bi bi-x-lg me-2"></i>Close
                                </button>
                            </div>

                        </div>
                    </div>
                </div>
                <div class="modal fade" id="breakDurationModal" tabindex="-1" aria-labelledby="breakDurationModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered" style="max-width: 400px;">
                        <div class="modal-content shadow-lg border-0 rounded-4">
                            <div class="modal-header bg-success text-white rounded-top-4">
                                <h5 class="modal-title d-flex align-items-center" id="breakDurationModalLabel">
                                    <i class="bi bi-hourglass-split me-2"></i>Enter Break Duration
                                </h5>
                                <button
                                    type="button"
                                    class="btn p-0 border-0 bg-transparent"
                                    data-bs-dismiss="modal"
                                    aria-label="Close"
                                    style="line-height: 1; outline: none;">
                                    <img src="../images/close-white.svg" alt="Close" style="width: 1.25rem; height: 1.25rem;" />
                                </button>

                            </div>
                            <div class="modal-body text-center py-4">
                                <input type="hidden" id="breakType" value="">
                                <input type="hidden" id="breakUserId" value="">

                                <div class="mb-3">
                                    <label for="breakDurationInput" class="form-label fw-semibold">
                                        Enter duration (in minutes)
                                    </label>
                                    <input type="number" min="1" max="180" step="1"
                                        id="breakDurationInput"
                                        class="form-control form-control-sm shadow-sm border-success text-center mx-auto"
                                        placeholder=" Enter Duration "
                                        style="max-width: 180px;">
                                </div>

                                <p class="text-muted small mt-2">
                                    This will start the break timer for the selected porter.
                                </p>
                            </div>

                            <div class="modal-footer d-flex justify-content-center py-3">
                                <button id="confirmBreakBtn" type="button" class="btn btn-success px-4 py-2 rounded-pill" disabled>
                                    <i class="bi bi-check2-circle me-2"></i>Start Break
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="modalTaskCancel" tabindex="-1" aria-labelledby="taskCancelLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-md">
                        <div class="modal-content">

                            <div class="modal-header bg-danger text-white">
                                <h5 class="modal-title" id="taskCancelLabel">Cancel Task</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
                                    <img src="../images/close-white.svg" alt="Close">
                                </button>
                            </div>

                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="ddlCancelReasons" class="form-label fw-semibold">Reason for cancelling:</label>
                                    <select id="ddlCancelReasons" class="form-select">
                                        <option value="">-- Select Reason --</option>
                                    </select>
                                </div>

                                <div class="text-center mt-4">
                                    <button type="button" class="btn btn-danger px-4 py-2" id="btnConfirmCancelTask">
                                        <i class="bi bi-x-circle me-2"></i>Cancel Task
                                    </button>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="modal fade" id="kpiModal" tabindex="-1" aria-labelledby="kpiModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-md">
                        <div class="modal-content">

                            <div class="modal-header bg-danger text-white">
                                <h5 class="modal-title" id="kpiModalLabel">Negative KPI Alert</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
                                    <img src="../images/close-white.svg" alt="Close">
                                </button>
                            </div>

                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="ddlKPIReasons" class="form-label fw-semibold">Reason for negative KPI:</label>
                                    <select id="ddlKPIReasons" class="form-select">
                                        <option value="">-- Select Reason --</option>
                                    </select>
                                </div>

                                <div class="text-center mt-4">
                                    <button type="button" class="btn btn-danger px-4 py-2" id="kpiModalActionBtn">
                                        <i class="bi bi-x-circle me-2"></i>Take Action
                                    </button>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="modal fade" id="modalSuccess" tabindex="-1" aria-labelledby="successLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-md">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="successLabel">Success</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                    <img src="../images/close-white.svg" alt="Close">
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="text-center mb-3">
                                    <img src="../images/icon-success.gif" alt="Success Icon">
                                </div>
                                <div class="text-center">
                                    <span id="LBLSuccessMessage" style="font-weight: 600;">Operation successful!</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="modalTaskHold" tabindex="-1" aria-labelledby="taskHoldLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-md">
                        <div class="modal-content">

                            <div class="modal-header bg-success text-white">
                                <h5 class="modal-title" id="taskHoldLabel">Put Task on Hold</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close">
                                    <img src="../images/close-white.svg" alt="Close" />
                                </button>
                            </div>

                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="loadHoldReasons" class="form-label fw-semibold">Select Reason:</label>
                                    <select id="loadHoldReasons" class="form-control"
                                        style="background-color: white !important;">
                                        <option value="">-- Select Reason --</option>
                                    </select>
                                </div>
                            </div>

                            <div class="modal-footer justify-content-center">
                                <button type="button" class="btn btn-success px-4 py-2 fw-semibold" id="btnConfirmHold">
                                    <i class="bi bi-pause-circle me-2"></i>Confirm Hold
                                </button>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="modal fade" id="modalTaskCopied" tabindex="-1" aria-labelledby="taskCopiedLabel" aria-hidden="false">
                    <div class="modal-dialog modal-dialog-centered modal-md">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="taskCopiedLabel">Success</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                    <img src="../images/close-white.svg" alt="Close">
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="text-center mb-3">
                                    <img src="../images/icon-success.gif" alt="Success Icon">
                                </div>
                                <div class="text-center">
                                    <span id="LBLTaskCopiedResult" style="font-weight: 600;">Task copied successfully!</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="modalTaskResumed" tabindex="-1" aria-labelledby="taskResumedLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-md">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="taskResumedLabel">Success</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                    <img src="../images/close-white.svg" alt="Close">
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="text-center mb-3">
                                    <img src="../images/icon-success.gif" alt="Success Icon">
                                </div>
                                <div class="text-center">
                                    <span id="LBLTaskResumedResult" style="font-weight: 600;">Task resumed successfully!</span>
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

                <!-- Porter Assigned Success Modal -->
                <div class="modal fade" id="modalPorterAssigned" tabindex="-1" aria-labelledby="porterAssignedLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-md">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="porterAssignedLabel">Success</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                    <img src="../images/close-white.svg" alt="Close">
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
                                                <span id="LBLPorterAssignedResult" style="font-weight: 600;"></span>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Task Ended Success Modal -->
                <div class="modal fade" id="modalTaskEnded" tabindex="-1" aria-labelledby="taskEndedLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-md">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="taskEndedLabel">Success</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                    <img src="../images/close-white.svg" alt="Close" />
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="text-center">
                                    <img src="../images/icon-success.gif" alt="Icon Success" style="width: 80px; height: 80px; margin-bottom: 15px;" />
                                    <p id="LBLTaskEndedMessage" style="font-weight: 600; font-size: 1.1rem;">Task ended successfully</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Task Details Modal -->
                <div class="modal fade" id="taskDetailsModal" tabindex="-1" aria-labelledby="taskDetailsModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-scrollable">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="taskDetailsModalLabel">Task Details</h5>
                            </div>
                            <div class="modal-body" id="taskDetailsContent">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Employee Detail Modal -->
                <div class="modal fade" id="employeeDetailModal" tabindex="-1" aria-labelledby="employeeDetailModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-scrollable modal-md">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="employeeDetailModalLabel">Employee Details</h5>
                            </div>
                            <div class="modal-body" id="employeeDetailBody">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </div>

                        <div class="modal fade" id="requestorModal" tabindex="-1" aria-labelledby="requestorModalLabel" aria-hidden="true">
                          <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered custom-dialog" style="max-width: 400px;">
                            <div class="modal-content border-0 rounded-4 shadow">

                              <div class="modal-header" style="background: #1F3A5F; color: #ffffff; border-radius: 16px 16px 0 0;">
                                <h5 class="modal-title w-100 text-center fw-semibold" id="requestorModalLabel">
                                  Remark Notes
                                </h5>
                              </div>

                              <div class="modal-body px-5 py-4"
                                   id="requestorModalContent" style="background: #F4F6F9; color: #1F2933; font-family: 'Segoe UI', sans-serif; line-height: 1.6; font-weight: 500; max-height: 60vh; overflow-y: auto; border-top: 1px solid #E1E6EF;">
                              </div>

                              <div class="modal-footer border-0 justify-content-center"
                                   style="background: #F4F6F9; border-radius: 0 0 16px 16px;">
                                <button type="button" class="btn px-4 py-2 rounded-pill"
                                        style="background-color: #4A6FA5; color: #ffffff;"
                                        data-bs-dismiss="modal">
                                  Close
                                </button>
                              </div>

                            </div>
                          </div>
                        </div>

<%--                <div class="modal-footer">
                    <button class="btn btn-sm btn-grey" type="button" data-bs-dismiss="modal">Close</button>
                </div>

            </div>
        </div>--%>


<%--        <!-- Reports -->
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
                                            <option selected>Select Format</option>
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
        </div>--%>

        <!-- /Reports -->
        <!-- Add Task -->
        <!-- Modal -->


        <div class="modal fade" id="ModalImage" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-md custom-dialog" style="min-width: 600px;">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <img id="imgAckHead" src="../images/Photo.png" alt="Logs" style="width: 35px;" />&nbsp;
                            <span style="font-size: 16px;"><span id="spanReqID"></span><span id="spanAckHead"></span></span>
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="width: 20px; height: 20px;">
                            <img src="../images/close-white.svg">
                        </button>
                    </div>
                    <div class="modal-body" style="height: 450px;">
                        <form>
                            <div class="row">

                                <div class="col-md-12" align="center">
                                    <div class="polaroid">
                                        <img id="ImgACK" alt="ACK" style="width: 100%; height: 380px" />
                                        <div class="container">
                                            <p id="ACK_ON"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade addTask" id="addTask" data-backdrop="static" tabindex="-1" aria-labelledby="addTaskLabel" aria-hidden="true">
            <button type="button" class="floating btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="window.RefreshAll();">
                <img src="../images/close-white.svg">
            </button>
            <div class="modal-dialog modal-xxl">
                <div class="modal-content">
                    <div class="search-header" style="display: none;">
                        <div class="search-wrap shadow">
                            <div class="search-box">
                                <form>
                                    <input type="search" maxlength="30" autocomplete="off webauthn" class="form-control">
                                    <input type="submit" value="" class="search-submit">
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="modal-body">
                        <div class="d-flex justify-content-between">
                            <div class="form-wrap me-4" style="flex: 1;">
                                <div class=" align-items-center justify-content-between mb-5">
                                    <%--d-flex--%>

                                    <div class="addtask-header row">
                                        <div class="col-md-6">
                                            <h5><span id="TaskHeader"></span></h5>
                                        </div>
                                        <div class="col-md-6 text-with-btn">
                                            <h5><span id="ReqUserLogin" <%-- style="margin-left: 20px; font-size: 19px;"--%>></span></h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="window.RefreshAll();">
                                                <img src="../images/close-white.svg">
                                            </button>
                                        </div>
                                    </div>
                                    <%--<h5 style="font-family: monospace; width: 700px;"><span id="TaskHeader"></span>&nbsp;&nbsp;&nbsp;<span id="ReqUserLogin" style="margin-left: 20px; font-size: 19px;"></span></h5>--%>
                                </div>


                                <div class="container-fluid p-4">

                                    <div class="navigation-tabs-wrapper-modal mb-0 p-0">
                                        <div class="services-button-modal">
                                            <label>Division</label>
                                        </div>
                                        <div class="services-tabs-wrapper-modal">
                                            <div class="services-btn-icon-modal" data-color="rgb(255, 116, 0)" id="divRService1">
                                                <img src="../images/porter-icon.svg" />
                                                <span>Portering</span>
                                            </div>
                                            <div class="services-btn-icon-modal" data-color="rgb(12, 188, 139)" id="divRService2">
                                                <img src="../images/cater-icon.png" />
                                                <span>Receipt and Distribution</span>
                                            </div>
                                            <div class="services-btn-icon-modal" data-color="rgb(110, 48, 243)" id="divRService3" style="display: none">
                                                <img src="../images/clean-icon.svg" />
                                                <span>Clean</span>
                                            </div>
                                            <div class="services-btn-icon-modal" data-color="rgb(255, 87, 51)" id="divRService4" style="display: none">
                                                <img src="../images/pest-icon.svg" />
                                                <span>Feedback</span>
                                            </div>
                                            <div class="services-btn-icon-modal" data-color="rgb(255, 87, 51)" id="divRService5" style="display: none">
                                                <img src="../images/security-icon.svg" />
                                                <span>Security</span>
                                            </div>
                                            <%--<div class="services-btn-icon-modal" data-color="rgb(255, 87, 51)">
                                            <span>Show All</span>
                                        </div>--%>
                                        </div>

                                    </div>
                                    <form id="formRequest">

                                        <div class="row">
                                            <div class="col-md-12" id="divReqDate">
                                                <div class="mb-3">
                                                    <h5 style="font-family: monospace; width: 700px; font-size: 20px;"><span id="spanRequestDate"></span></h5>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">

                                            <div class="col-md-12 d-flex justify-content-end align-items-center gap-2" id="DivPrebookSlider">

                                                <label class="mb-0" style="vertical-align: middle; padding-left: 10px; font-size: 19px; font-weight: bold;">PRE-BOOK</label>
                                                <label class="switch">
                                                    <input type="checkbox" id="chkPreBook">
                                                    <span class="slider round"></span>
                                                </label>

                                            </div>
                                            <div class="col-md-6" id="containerDate" style="display: none">
                                                <div class="mb-3">
                                                    <label for="txtReqdate">Date</label>
                                                    <input type="date" id="txtReqdate" class="form-control">
                                                </div>

                                            </div>
                                            <div class="col-md-6" id="containerTime" style="display: none">
                                                <div class="mb-3">
                                                    <label for="txtReqTime">Time</label>
                                                    <input type="time" id="txtReqTime" class="form-control">
                                                </div>
                                            </div>

                                            <div class="col-md-6" id="containerFrom">
                                                <div class="mb-3">
                                                    <label>From</label>
                                                    <textarea maxlength="50" name="txtFromLoc" rows="1" class="form-control" placeholder="-- Select --" id="txtFromLoc" style="padding: 15px;"></textarea>
                                                    <div id="suggesstionFrom" class="col-md-6"></div>
                                                </div>
                                            </div>

                                            <div class="col-md-6" id="containerTo">
                                                <div class="mb-3">
                                                    <label>To</label>
                                                    <textarea maxlength="50" name="txtToLoc" rows="1" class="form-control" placeholder="-- Select --" id="txtToLoc" style="padding: 15px;"></textarea>
                                                    <div id="suggesstionTo" class="col-md-6"></div>
                                                </div>
                                            </div>

                                         <div style="height: 400px;"> 
                                             <div class="mb-4 p-3 rounded" style="background: linear-gradient(135deg, #cce7ff, #f9fbff); color: #003366; height: 300px;">
                                                <div class="row mb-2 align-items-center justify-content-between" style="padding: 5px 10px; min-height: 60px;">
                                                    <div class="col-md-2">
                                                        <label>Task Type</label>
                                                    </div>
                                                    <div class="col-md-6 d-flex align-items-center position-relative" style="gap: 10px;">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="21" viewBox="0 0 20 21" fill="none" style="flex-shrink: 0;">
                                                            <path d="M9.58342 18.625C4.87508 18.625 1.04175 14.7917 1.04175 10.0833C1.04175 5.37501 4.87508 1.54167 9.58342 1.54167C14.2917 1.54167 18.1251 5.37501 18.1251 10.0833C18.1251 14.7917 14.2917 18.625 9.58342 18.625ZM9.58342 2.79167C5.55841 2.79167 2.29175 6.06667 2.29175 10.0833C2.29175 14.1 5.55841 17.375 9.58342 17.375C13.6084 17.375 16.8751 14.1 16.8751 10.0833C16.8751 6.06667 13.6084 2.79167 9.58342 2.79167Z" fill="var(--active-color-modal)" />
                                                            <path d="M18.3333 19.4583C18.175 19.4583 18.0166 19.4 17.8916 19.275L16.225 17.6083C15.9833 17.3667 15.9833 16.9667 16.225 16.725C16.4666 16.4833 16.8666 16.4833 17.1083 16.725L18.775 18.3917C19.0166 18.6333 19.0166 19.0333 18.775 19.275C18.65 19.4 18.4916 19.4583 18.3333 19.4583Z" fill="var(--active-color-modal)" />
                                                        </svg>
                                                        <textarea maxlength="50" name="task-description" rows="1" class="form-control search-bar" placeholder="Search..." id="txtSearchCat" onkeyup="searchCategory(this);" style="flex-grow: 1; box-shadow: none; background-color: white !important; resize: none; padding-left: 0.5rem;"></textarea>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <div class="d-flex gap-2 align-items-center" id="divQuantity">
                                                            <label class="mb-0">Quantity <span style="font-size: 11px">(optional)</span></label>
                                                            <input type="number" max="5" min="0" name="txtQty" class="form-control" placeholder="" id="txtQty" value="1" />
                                                        </div>
                                                    </div>
                                                </div>
        
                                                <div style="height: 60px;">
                                                    <div class="icon-section" id="ReqCategories" style="min-height: 30px;"></div>
                                                </div>

                                                <hr style="margin: 15px 0; border-color: rgba(255,255,255,0.4);" />

                                                <div class="row mb-2 align-items-center justify-content-between" style="padding: 5px 10px; min-height: 60px;">
                                                    <div class="col-md-2">
                                                        <label>Equipment Type</label>
                                                    </div>
                                                    <div class="col-md-6 d-flex align-items-center" style="gap: 10px;">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="21" viewBox="0 0 20 21" fill="none" style="flex-shrink: 0;">
                                                            <path d="M9.58342 18.625C4.87508 18.625 1.04175 14.7917 1.04175 10.0833C1.04175 5.37501 4.87508 1.54167 9.58342 1.54167C14.2917 1.54167 18.1251 5.37501 18.1251 10.0833C18.1251 14.7917 14.2917 18.625 9.58342 18.625ZM9.58342 2.79167C5.55841 2.79167 2.29175 6.06667 2.29175 10.0833C2.29175 14.1 5.55841 17.375 9.58342 17.375C13.6084 17.375 16.8751 14.1 16.8751 10.0833C16.8751 6.06667 13.6084 2.79167 9.58342 2.79167Z" fill="var(--active-color-modal)" />
                                                            <path d="M18.3333 19.4583C18.175 19.4583 18.0166 19.4 17.8916 19.275L16.225 17.6083C15.9833 17.3667 15.9833 16.9667 16.225 16.725C16.4666 16.4833 16.8666 16.4833 17.1083 16.725L18.775 18.3917C19.0166 18.6333 19.0166 19.0333 18.775 19.275C18.65 19.4 18.4916 19.4583 18.3333 19.4583Z" fill="var(--active-color-modal)" />
                                                        </svg>
                                                        <textarea maxlength="50" name="equipment-description" rows="1" class="form-control search-bar" placeholder="Search..." id="txtSearchEquipment" onkeyup="searchEquipment(this);" style="flex-grow: 1; box-shadow: none; background-color: white !important; resize: none; padding-left: 0.5rem;"></textarea>
                                                    </div>
                                                </div>
        
                                                <div style="height: 60px;">
                                                    <div class="icon-section" id="EquipmentCategories" style="min-height: 15px;"></div>
                                                </div>
                                            </div>
                                          </div>
                                            
                                            <div class="col-md-8" id="containerKPI" style="background-color: #84abf9; padding-bottom: 10px;">
                                                <%--<div class="kpi-container">
                                                <label class="label-title">
                                                    KPI Response
                                                </label>
                                                <label id="lblKPITS" class="form-control">- </label>
                                            </div>
                                            <div class="kpi-container">
                                                <label class="label-title">
                                                    KPI Completion
                                                </label>
                                                <label id="lblKPITE" class="form-control">- </label>
                                            </div>--%>
                                                <table style="height: 74px; /*position: absolute; */ background: white; width: 470px; margin-bottom: -10px;" cellpadding="8px">

                                                    <tr style="border: 3px solid white;">
                                                        <td style="text-align: center; width: 130px; background-color: #7eafff;" id="tdKPIResponse">
                                                            <label style="font-size: 14px;">
                                                                KPI
                                                            <br />
                                                                Response</label></td>
                                                        <td style="text-align: center; width: 105px;">
                                                            <label id="lblKPITS" style="font-size: 13px;">- </label>
                                                        </td>
                                                        <td style="text-align: center; width: 130px; background-color: #7eafff;" id="tdKPICompletion">
                                                            <label style="font-size: 14px;">
                                                                KPI
                                                            <br />
                                                                Completion</label></td>

                                                        <td style="text-align: center; width: 105px;">
                                                            <label id="lblKPITE" style="font-size: 13px;">- </label>
                                                        </td>
                                                    </tr>

                                                </table>
                                            </div>

                                            <div class="col-md-4" style="background-color: #84abf9;" id="parentcontainerMP">
                                                <%--<div class="switch-cointainer" onclick="setMultiPorter();">
                                                <label class="mb-0">Two Porters</label>
                                                <label class="switch">
                                                    <input type="checkbox" id="chkMultiPorter">
                                                    <span class="slider round"></span>
                                                </label>
                                            </div>
                                            <div class="switch-cointainer" onclick="setReturnCalls();" style="display: none">
                                                <label class="mb-0">Return call</label>
                                                <label class="switch">
                                                    <input type="checkbox" id="chkReturnCalls">
                                                    <span class="slider round"></span>
                                                </label>
                                            </div>--%>
                                                <table style="width: 100%; margin-top: 35px; display: none;" id="containerMP">
                                                    <tr>
                                                        <td onclick="setMultiPorter();">
                                                            <div align="right">
                                                                <table style="background-color: white; margin-bottom: -1px; border-radius: 5px 5px 0px 0px;">
                                                                    <tr>
                                                                        <td style="padding-left: 10px; padding-top: 10px;">
                                                                            <label>Assistant Required</label></td>
                                                                        <td style="padding-left: 20px; padding-right: 10px;">
                                                                            <label class="switch" for="chkMultiPorter">
                                                                                <input type="checkbox" id="chkMultiPorter" name="AssistantRequired">
                                                                                <span class="slider round" title="Assistant Required"></span>
                                                                            </label>
                                                                        </td>

                                                                    </tr>

                                                                </table>

                                                            </div>
                                                        </td>
                                                        <td onclick="setReturnCalls();" style="display: none">
                                                            <div class="mb-3" align="center">
                                                                <table>
                                                                    <tr>
                                                                        <td>
                                                                            <label>Return call</label></td>
                                                                        <td style="padding-left: 20px;">
                                                                            <label class="switch">
                                                                                <input type="checkbox" id="chkReturnCalls">
                                                                                <span class="slider round"></span>
                                                                            </label>
                                                                        </td>
                                                                    </tr>
                                                                </table>


                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>

                                            <%-- <div class="col-md-4">
                                              <div class="mb-3" style="margin-top: 5px; display: none;" id="divQuantity">
                                                <label>Quantity <span style="font-size: 11px">(optional)</span></label>
                                                <textarea maxlength="5" name="txtQty" rows="3" class="form-control" placeholder="Quantity" id="txtQty"></textarea>
                                            </div>
                                        </div>--%>
                                        </div>
                                        <div class="col"></div>
                                    </form>
                                </div>

                                <div class="modal-dialog custom-dialog">

                                    <div class="custom-calendar-wrap" style="display: block">

                                        <div class="RequestIcons" style="padding: 10px">
                                            <%--                                <div id="verifyDeliverySection" style="margin-bottom: 10px;">
                                  <table style="background-color: white; margin-bottom: -1px; border-radius: 5px 5px 0 0; width: 100%;">
                                    <tr>
                                      <td style="padding-left: 10px; padding-top: 10px;">
                                        <label>Verify Delivery</label>
                                      </td>
                                      <td style="padding-left: 20px; padding-right: 10px; text-align: right;">
                                        <label class="switch">
                                          <input type="checkbox" id="chkVerifyDelivery" onchange="toggleVerifyUpload(this)">
                                          <span class="slider round"></span>
                                        </label>
                                      </td>
                                    </tr>
                                  </table>
                                </div>

                                <div id="verifyUploadContainer" style="display:none; margin-top: 10px; padding-left: 10px;">
                                  <input type="file" id="fileVerifyImage" accept="image/*" />
                                </div>--%>

                                            <div class="col-md-12 mt-4" id="containerPatient">
                                                <div class="row mb-3">
                                                    <label>Patient Details <span style="font-size: 11px">(Name/ DOB / Hospital No)</span></label>
                                                    <div class="col-md-12">
                                                        <textarea maxlength="75" name="txtPatientName" rows="3" class="form-control" placeholder="Name" id="txtPatientName"></textarea>

                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <%-- <label>Name </label>
                                                                                                   <textarea name="txtPatientName" rows="2" class="form-control" placeholder="Name" id="txtPatientName"></textarea>--%>
                                                            </div>

                                                            <div class="col-md-3" style="display: none;">
                                                                <label>DOB </label>
                                                                <input type="date" id="txtPatientDOB" class="form-control" style="padding: 20px 12px;">
                                                            </div>
                                                            <div class="col-md-3" style="display: none;">
                                                                <label>Hospital No. </label>
                                                                <textarea name="txtPatientHNO" rows="2" class="form-control" placeholder="Hospital No." id="txtPatientHNO"></textarea>

                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>



                                            <div class="col-md-12" id="containerRequestor" style="padding: 15px 10px;">
                                                <div class="mb-3">
                                                    <label>Requestor Name</label>
                                                    <textarea maxlength="50" name="txtRequestorName" rows="2" class="form-control" placeholder="Requestor Name" id="txtRequestorName"></textarea>
                                                </div>
                                            </div>

                                            <div class="col-md-12" id="containerContact">
                                                <div class="mb-3">
                                                    <label>Contact No. <span style="font-size: 11px">(optional)</span></label>
                                                    <textarea maxlength="50" name="txtContactNumber" rows="2" class="form-control" placeholder="Contact No." id="txtContactNumber"></textarea>
                                                </div>
                                            </div>

                                            <div class="col-md-12">
                                                <div class="mb-3">
                                                    <label>Remarks</label>
                                                    <div id="divSelRemarks">
                                                        <select name="selectFloor" id="search_Remarks" tabindex="10" multiple="multiple" class="form-control search_test" onchange="OnChangeRemarks(this,'txtRemarks');return false;" style="margin-bottom: 10px; background-color: white !important;"></select>
                                                    </div>
                                                    <textarea maxlength="100" name="task-description" rows="4" class="form-control" placeholder="Remarks" id="txtRemarks" style="display: inline-block;"></textarea>
                                                </div>
                                            </div>
                                            <div id="divEditRemarks" class="col-md-12">
                                                <%-- <div class="col-md-12" id="divCompleteRemarks">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <label>Notes</label>
                                                </div>
                                                <div class="col-md-5" align="right">
                                                    <label style="font-size: 13px;">&lt;&lt;Prev </label>
                                                    <label style="font-size: 12px; text-decoration: underline; color: blue; cursor: pointer;" id="lblPreNotes" onclick="showPrevNotes();">
                                                        show
                                                    </label>
                                                </div>
                                            </div>
                                            <div id="divPrevNotes" class="completeRemarks" style="display: none; max-height: 310px; overflow-y: auto; padding: 5px;">
                                            </div>

                                            <div class="row">
                                                <div class="col-md-8">
                                                    <textarea name="task-description" rows="3" class="form-control" placeholder=" Notes " id="txtCompleteRemarks" style="display: inline-block;"></textarea>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="row">
                                                        <div class="col-md-12 mb-3" align="center" style="margin-top: 10px; margin-bottom: 6px !important;">
                                                            <label style="text-decoration: underline; color: white; margin-bottom: 6px; background-color: #0a57c7; padding: 5px;" onclick="setCheckbyID('chkMitigation');">Mitigation </label>
                                                        </div>
                                                        <div class="col-md-12" align="center">
                                                            <img src="../images/NoMCheck.jpg" id="chkMitigation" style="width: 20px; cursor: pointer;" onclick="setCheck(this);">
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>

                                        </div>--%>
                                                <br />
                                                <br />
                                                <div class="col-md-12" id="divPorterRemarks">
                                                    <div class="mb-3">
                                                        <label>Porter Remarks</label>
                                                        <textarea maxlength="100" name="task-description" rows="4" class="form-control" placeholder="Porter Remarks" id="txtPorterRemarks" style="display: inline-block;"></textarea>
                                                    </div>
                                                </div>
                                                <br />
                                                <div class="col-md-12" id="divCancelRemarks">
                                                    <label>Cancel Remarks</label>
                                                    <div id="divSelCRemarks">
                                                        <select name="selectFloor" id="search_CancelRemarks" tabindex="12" multiple="multiple" class="form-control search_test" onchange="OnChangeRemarks(this,'txtCanceRemarks');return false;" style="margin-bottom: 10px; background-color: white !important;"></select>
                                                    </div>
                                                    <textarea maxlength="300" name="task-description" rows="10" class="form-control" placeholder="Cancel Remarks" id="txtCanceRemarks" style="display: inline-block; height: 150px;"></textarea>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="RequestIcons" style="padding: 10px; padding-top: 15px;">
                                            <div class="mb-3 row">
                                                <div class="col-sm-4" style="display: none">
                                                    <button type="reset" class="btn btn-tertiary w-100">Clear</button>
                                                </div>
                                                <div class="col-sm-6">
                                                    <button type="button" class="btn btn-outline w-100"
                                                        data-bs-dismiss="modal" onclick="window.RefreshAll();">
                                                        <img src="../images/multiply.svg">
                                                        Close</button>
                                                </div>
                                                <div class="col-sm-6">
                                                    <button type="button" class="btn btn-secondary w-100" onclick="submitRequest();" id="btnReqSubmit">
                                                        <img
                                                            src="../images/envelope.png">
                                                        Submit</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- /Add Task -->

            <div class="modal fade" id="ModalStart" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-fullscreen-md-down">
                    <div class="modal-content">

                        <div class="modal-header">
                            <h6 class="modal-title">#<span id="StartReqID"></span>
                                &nbsp;&nbsp;-&nbsp;REASON  <span style="font-size: 11px">(optional)</span> </h6>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="width: 20px; height: 20px;">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="headFoot" style="height: 0px; margin-top: -2px;">
                        </div>
                        <div id="DivStart" align="center" style="overflow-y: auto;">
                            <div id="StartdReasonContent" class="Content" style="margin-bottom: 10px;">
                                <table width="95%">
                                    <tr>
                                        <td align="center">
                                            <table style="width: 190px;">
                                                <tr>
                                                    <td valign="middle" align="center" style="vertical-align: middle">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <textarea maxlength="100" name="txtStartReason" id="txtStartReason" cols="25" rows="10" maxlength="120" class="txtRemarksInfo"
                                                                        style="height: 100px; width: 300px; word-break: break-word !important; font-size: 14px; font-weight: bold !important; text-align: left !important; resize: none !important; padding: 5px; border-radius: 5px; color: #142d52;" tabindex="4"></textarea>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="25%" style="vertical-align: middle;">
                                            <span id="ImgStartReq" style="cursor: pointer; background-color: #0d6efd; padding: 22px 12px; border-radius: 39px; font-weight: bold; font-size: 15px; color: white;" onclick="StartRequest();return false;">START </span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div class="modal fade" id="ModalComplete" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-fullscreen-md-down">
                    <div class="modal-content">

                        <div class="modal-header">
                            <h6 class="modal-title">#<span id="CompleteReqID"></span>
                                &nbsp;&nbsp;-&nbsp;REASON <span style="font-size: 11px">(optional)</span></h6>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="width: 20px; height: 20px;">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="headFoot" style="height: 0px; margin-top: -2px;">
                        </div>
                        <div id="DivComplete" align="center" style="overflow-y: auto;">
                            <div id="CompletedReasonContent" class="Content" style="margin-bottom: 10px;">
                                <table width="95%">
                                    <tr>
                                        <td align="center">
                                            <table style="width: 190px;">
                                                <tr>
                                                    <td valign="middle" align="center" style="vertical-align: middle">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <textarea maxlength="100" name="txtCompleteReason" id="txtCompleteReason" cols="25" rows="10" maxlength="120" class="txtRemarksInfo"
                                                                        style="height: 100px; width: 300px; word-break: break-word !important; font-size: 14px; font-weight: bold !important; text-align: left !important; resize: none !important; padding: 5px; border-radius: 5px; color: #142d52;" tabindex="4"></textarea>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="25%" style="vertical-align: middle;">
                                            <span id="ImgCompleteReq" style="cursor: pointer; background-color: #FF725E; padding: 22px 12px; border-radius: 39px; font-weight: bold; font-size: 15px; color: white;" onclick="CompleteRequest();return false;">Finish </span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>



            <div class="modal fade" id="ModalOnHold" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-fullscreen-md-down">
                    <div class="modal-content">
                        <%-- <div class="header" align="center">
                        <table width="95%" style="margin-top: -6px;">
                            <tr>
                                <td style="color: white; font-weight: bold; font-family: monospace; font-size: 18px; position: relative; top: -4px; padding-right: 5px;">#<span id="canReqID"></span> </td>
                                <td colspan="2" align="center" valign="middle">
                                    <span style="color: white; font-family: monospace; font-size: 18px; position: relative; top: -4px; padding-right: 5px;">REASON FOR CANCEL</span>
                                </td>
                                <td width="10%">
                                    <input type="image" name="BtnRequestCatClose" id="ImgReqCancelClose" src="../images/close.png"
                                        style="border-width: 0px; cursor: pointer; float: right; margin-right: 8px;"
                                        data-bs-dismiss="modal" />
                                </td>
                            </tr>
                        </table>
                    </div>--%>
                        <div class="modal-header">
                            <h6 class="modal-title">#<span id="OnHoldReqID"></span>
                                &nbsp;&nbsp;REASON FOR ONHOLD</h6>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="width: 20px; height: 20px;">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="headFoot" style="height: 0px; margin-top: -2px;">
                        </div>
                        <div id="DivOhHold" align="center" style="overflow-y: auto;">
                            <div id="OnHoldReasonContent" class="Content" style="margin-bottom: 10px;">
                                <table width="95%">
                                    <tr>
                                        <td align="center">
                                            <table style="width: 190px;">
                                                <tr>
                                                    <td valign="middle" align="center" style="vertical-align: middle">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <textarea maxlength="100" name="txtOnHoldReason" id="txtOnHoldReason" cols="25" rows="10" maxlength="120" class="txtRemarksInfo"
                                                                        style="height: 100px; width: 300px; word-break: break-word !important; font-size: 14px; font-weight: bold !important; text-align: left !important; resize: none !important; padding: 5px; border-radius: 5px; color: #142d52;" tabindex="4"></textarea>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="25%" style="vertical-align: middle;">
                                            <span id="ImgOnHoldReq" style="cursor: pointer; background-color: #FF725E; padding: 22px 12px; border-radius: 39px; font-weight: bold; font-size: 15px; color: white;" onclick="OnHoldRequest();return false;">HOLD </span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>




            <div class="modal fade" id="ModalOnHoldRelease" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-fullscreen-md-down">
                    <div class="modal-content">
                        <%-- <div class="header" align="center">
                        <table width="95%" style="margin-top: -6px;">
                            <tr>
                                <td style="color: white; font-weight: bold; font-family: monospace; font-size: 18px; position: relative; top: -4px; padding-right: 5px;">#<span id="canReqID"></span> </td>
                                <td colspan="2" align="center" valign="middle">
                                    <span style="color: white; font-family: monospace; font-size: 18px; position: relative; top: -4px; padding-right: 5px;">REASON FOR CANCEL</span>
                                </td>
                                <td width="10%">
                                    <input type="image" name="BtnRequestCatClose" id="ImgReqCancelClose" src="../images/close.png"
                                        style="border-width: 0px; cursor: pointer; float: right; margin-right: 8px;"
                                        data-bs-dismiss="modal" />
                                </td>
                            </tr>
                        </table>
                    </div>--%>
                        <div class="modal-header">
                            <h6 class="modal-title">Click 'Confirm' If You Are Ok To Release The Task No. &nbsp;&nbsp;#<span id="OnHoldReleaseReqID"></span></h6>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="width: 20px; height: 20px;">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="headFoot" style="height: 0px; margin-top: -2px;">
                        </div>
                        <div id="DivOhHoldRelease" align="center" style="overflow-y: auto;">
                            <div id="OnHoldReleaseContent" class="Content" style="margin-bottom: 10px;">
                                <table width="95%">
                                    <tr>
                                        <td align="center" style="padding: 20px; vertical-align: middle;">
                                            <span id="ImgOnHoldRelease" style="cursor: pointer; background-color: #FF725E; padding: 14px 10px; border-radius: 10px; margin: 5px; font-weight: bold; font-size: 15px; color: white;" onclick="ReleaseOnHoldRequest();return false;">Confirm </span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div class="modal fade" id="ModalCancel" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-fullscreen-md-down">
                    <div class="modal-content">
                        <%-- <div class="header" align="center">
                        <table width="95%" style="margin-top: -6px;">
                            <tr>
                                <td style="color: white; font-weight: bold; font-family: monospace; font-size: 18px; position: relative; top: -4px; padding-right: 5px;">#<span id="canReqID"></span> </td>
                                <td colspan="2" align="center" valign="middle">
                                    <span style="color: white; font-family: monospace; font-size: 18px; position: relative; top: -4px; padding-right: 5px;">REASON FOR CANCEL</span>
                                </td>
                                <td width="10%">
                                    <input type="image" name="BtnRequestCatClose" id="ImgReqCancelClose" src="../images/close.png"
                                        style="border-width: 0px; cursor: pointer; float: right; margin-right: 8px;"
                                        data-bs-dismiss="modal" />
                                </td>
                            </tr>
                        </table>
                    </div>--%>
                        <div class="modal-header">
                            <h6 class="modal-title">#<span id="canReqID"></span>
                                &nbsp;&nbsp;REASON FOR CANCEL</h6>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="width: 20px; height: 20px;">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="headFoot" style="height: 0px; margin-top: -2px;">
                        </div>
                        <div id="Div2" align="center" style="overflow-y: auto;">
                            <div id="CancelReasonContent" class="Content" style="min-height: 320px">
                                <table width="95%" style="min-height: 250px;">
                                    <tr>

                                        <td colspan="2" align="center">
                                            <div class="col-md-11">
                                                <select name="selectFloor" id="searchCR_CancelRemarks" multiple="multiple" class="form-control search_test" onchange="OnChangeRemarks(this,'txtCanceRemarks');return false;" style="margin-bottom: 10px; text-align: left;"></select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center">
                                            <table style="width: 190px;">
                                                <tr>
                                                    <td valign="middle" align="center" style="vertical-align: middle">
                                                        <table>

                                                            <tr>
                                                                <td>
                                                                    <textarea maxlength="300" name="txtCancelReason" id="txtCancelReason" cols="25" rows="10" class="txtRemarksInfo"
                                                                        style="height: 150px; width: 300px; word-break: break-word !important; font-size: 14px; font-weight: bold !important; text-align: left !important; resize: none !important; padding: 5px; border-radius: 5px; color: #142d52;" tabindex="4"></textarea>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="25%" style="vertical-align: middle;">
                                            <img src="../images/Delete.png" id="ImgDeleteReq" style="cursor: pointer" onclick="CancelRequest();return false;" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div id="ModalDone" class="modal fade" role="dialog">
                <div class="modal-dialog modal-dialog-centered modal-fullscreen-md-down">
                    <div class="modal-dialogLoc" align="center">
                        <table style="margin-top: 100px;">
                            <tr>
                                <td>
                                    <img id="ImgDone" src="../images/Tick.png" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="modalAlert" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
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
                                            <span id="spanErrorMessage"></span>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>


            <div id="ModalAddTask" class="modal fade" role="dialog">
                <div class="modal-dialog modal-dialog-centered modal-fullscreen-xxl-down modal-AddTask">
                    <div class="modal-content">
                        <div class="headerAddTask" align="center">
                            <table width="100%" style="margin-top: -6px;">
                                <tr>
                                    <td colspan="2" align="center" valign="middle">
                                        <span style="color: white; font-family: Monospace; font-size: 21px; position: relative; top: -4px; padding-right: 5px;">REASSIGN</span><img src="../Images/PorterModal.PNG" width="30px"
                                            height="30px" />
                                    </td>
                                    <td width="50px">
                                        <input type="image" name="BtnRequestAddtaskClose" id="ImgAddTask" src="../images/close.png"
                                            style="border-width: 0px; cursor: pointer; float: right; margin-right: 8px;"
                                            data-bs-dismiss="modal" />

                                    </td>

                                </tr>
                            </table>
                        </div>
                        <div class="headFoot" style="height: 0px; margin-top: -2px;">
                        </div>
                        <div id="mpAddTasks" align="center" style="height: 700px;">
                            <table width="100%" cellpadding="2">
                                <tr style="height: 120px;">
                                    <td style="width: 60%; vertical-align: middle;">
                                        <table>
                                            <tr>
                                                <td style="font-size: 11pt; color: rgb(30, 70, 129); font-weight: bold; line-height: 25px; text-align: center; vertical-align: middle; padding-left: 30px;">PORTER :</td>
                                                <td style="line-height: 25px; text-align: center; vertical-align: middle; padding: 20px; width: 300px">
                                                    <%--<asp:Label ID="LBLPorterNam" ClientIDMode="Static" runat="server" Font-Size="11pt"
                                                    Style="font-size: 11pt; color: rgb(30, 70, 129); font-weight: bold;" Text=""> </asp:Label>--%>

                                                    <select name="selectFloor" id="search_PorterMT" tabindex="3" class="form-control search_test" style="width: 280px" onchange="OnChangeMTPorters(this);">
                                                        <option value="0">--Select--</option>
                                                    </select>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>

                                    <td style="vertical-align: middle;">
                                        <div id="btnAddTasks" class="btnAssignAdhoc" onclick="AbortAllActiveRuquests();AssignTasks();return false;">
                                            ASSIGN
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <td align="center" colspan="2">
                                        <table width="95%" style="font-size: 11pt; color: rgb(30, 70, 129); font-weight: bold; text-align: center;">
                                            <tr style="height: 30px">
                                                <td style="background-color: rgb(30, 70, 129); color: white; text-align: center; vertical-align: middle;">REQUESTS</td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="gridPenTask" class="Content" style="margin-top: 10px; height: 500px; overflow-y: scroll;">
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>

                                    </td>
                                </tr>

                                <tr>
                                    <td align="right" style="padding: 10px; font-size: 11px; font-weight: bold; font-family: monospace;" colspan="2">Manual assign window closes in <span id="MTCount">60</span> sec.
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <%--         <div id="ModalMTDone" class="modal fade" role="dialog">
            <div class="modal-dialogLoc" align="center">
                <table style="margin-top: 100px; background: white; height: 100px; border-radius: 20px;">
                    <tr>
                        <td style="line-height: 25px; text-align: center; vertical-align: middle; padding: 20px;">
                            <span id="spanMT" style="font-size: 11pt; color: #c10000; font-weight: bold;">Tasks <span id="spanMTTasks"></span>been assigned to  <span id="spanMTPorter" style="color: rgb(30, 70, 129); font-size: 12pt; text-shadow: 1px 1px 1px #c5cae9;"></span>Successfully </span>
                        </td>
                    </tr>
                </table>
            </div>
        </div>--%>

            <!-- Success Modal -->
            <div class="modal fade" id="ModalMTDone" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-md">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="MTNSuccess">Success</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                <img src="../images/close-white.svg" alt="Close">
                            </button>
                        </div>
                        <div class="modal-body text-center">
                            <div class="mb-3">
                                <img src="../images/icon-success.gif" alt="Icon Success">
                            </div>
                            <div class="mb-3" style="font-size: 11pt;">
                                <span id="spanMT">Task(s) <span id="spanMTTasks"></span>have been assigned to <span id="spanMTPorter"></span>Successfully</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="ModalDoneAddRemarks" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-md">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Success</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                <img src="../images/close-white.svg" alt="Close">
                            </button>
                        </div>
                        <div class="modal-body">
                            <form id="remarksForm">
                                <div class="row">
                                    <div class="col-md-12 text-center">
                                        <div class="mb-3">
                                            <img src="../images/icon-success.gif" alt="Icon Success">
                                        </div>
                                        <div class="mb-3" style="font-size: 11pt;">
                                            <span>Notes submitted successfully</span>
                                        </div>
                                        <button type="submit" class="btn btn-primary">Submit</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <%--        <div class="modal fade" id="ModalMTDone" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-md">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="MTNSuccess">Success</h5>
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
                                        <span id="spanMT" style="font-size: 11pt;">Task(s) <span id="spanMTTasks"></span>been assigned to  <span id="spanMTPorter"></span>Successfully </span>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="ModalDoneAddRemarks" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
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
                                    </div>
                                    <div class="mb-3 text-center">
                                        <span style="font-size: 11pt;">Notes subimtted Successfully </span>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>--%>



            <!-- Success Modal -->
            <div class="modal fade" id="ModalCompleteNotes" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-md">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Notes
                            <img src="../images/memo.png" alt="Notes" />
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="modal-body" style="height: 650px;">
                            <form>
                                <div class="row">

                                    <div id="divCompleteselect" class="col-md-12">
                                        <select name="selectFloor" id="search_CompleteRemarks" tabindex="11" multiple="multiple" class="form-control search_test" onchange="OnChangeRemarks(this,'txtCompleteRemarks');return false;" style="margin-bottom: 10px; background-color: white !important;"></select>
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-md-8">
                                        <textarea maxlength="100" name="txtComRemarks" rows="4" class="form-control" placeholder=" Notes " id="txtComRemarks" style="display: inline-block;"></textarea>
                                    </div>

                                    <div class="col-md-4">

                                        <div class="row">
                                            <div class="col-md-3" align="center" style="padding-top: 17px;">
                                                <img src="../images/NoMCheck.jpg" id="chkMitigationCom" style="height: 20px; width: 20px; cursor: pointer;" onclick="setCheck(this);">
                                            </div>
                                            <div class="col-md-9 mb-3" align="center" style="margin-top: 10px; margin-bottom: 3px !important;">
                                                <label style="font-weight: 600; color: white; margin-bottom: 6px; background-color: #0a57c7; padding: 5px; margin-left: -10px; text-decoration: underline; cursor: pointer;"
                                                    onclick="setCheckbyID('chkMitigationCom');">
                                                    Mitigation
                                                </label>
                                            </div>
                                            <div class="col-md-12">
                                                <button type="button" class="btn btn-secondary " onclick="submitNotes();" style="margin-top: 10px; padding: 10px 20px;">
                                                    <img
                                                        src="../images/envelope.png">
                                                    Submit</button>

                                            </div>
                                        </div>


                                    </div>

                                    <div class="col-md-12">
                                        <div id="divComNotes" class="completeRemarks" style="display: none; max-height: 400px; overflow-y: auto; padding: 5px;">
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="ModalReqLogs" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-md" style="min-width: 800px;">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">
                                <img src="../images/Logr.png" alt="Logs" style="width: 35px;" />&nbsp;
                            <span id="spanLogReq" style="font-size: 18px;"></span>
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="width: 20px; height: 20px;">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="modal-body" style="height: 650px;">
                            <form>
                                <div class="row">

                                    <div class="col-md-12">
                                        <div id="divReqLogs" class="completeRemarks" style="display: none; max-height: 600px; overflow-y: auto; padding: 5px;">
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="ModalSuccessCancel" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
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
                                        </div>
                                        <div class="mb-3 text-center">
                                            <span style="font-size: 11pt;">Task #<span id="spanTaskCnl"></span> cancelled Successfully </span>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>


            <div class="modal fade" id="ModalSuccessOnHold" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
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
                                        </div>
                                        <div class="mb-3 text-center">
                                            <span style="font-size: 11pt;">Task #<span id="spanTaskOnHold"></span> has been put on HOLD Successfully. </span>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>


            <div class="modal fade" id="ModalSuccessStart" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
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
                                        </div>
                                        <div class="mb-3 text-center">
                                            <span style="font-size: 11pt;">Task #<span id="spanTaskStart"></span> has been Started Successfully. </span>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>



            <div class="modal fade" id="ModalSuccessComplete" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
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
                                        </div>
                                        <div class="mb-3 text-center">
                                            <span style="font-size: 11pt;">Task #<span id="spanTaskComplete"></span> has been Completed Successfully. </span>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>



            <div class="modal fade" id="ModalReleaseSuccessOnHold" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
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
                                        </div>
                                        <div class="mb-3 text-center">
                                            <span style="font-size: 11pt;">Task #<span id="spanReleaseTaskOnHold"></span> has been moved to pending list successfully. </span>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="successMTNoTask" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
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
                                        </div>
                                        <div class="mb-3 text-center">
                                            <span style="font-size: 11pt;"><span id="spanMTPorterNTasks"></span>task(s) have been moved to pending list successfully. </span>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Success Modal -->
            <div class="modal fade" id="successMTNoporter" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-md">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="MTSuccess">Success</h5>
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
                                            <span id="spanMTN" style="font-size: 11pt;">Tasks <span id="spanMTNTasks"></span>been merged for multi-tasking Successfully </span>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Floor Map Modal -->
            <div class="modal fade" id="floor-map-popup" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-xl">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Tracking</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="modal-body">
                            <form>
                                <div class="row">
                                    <div class="col-md-12">

                                        <div class="mb-3 text-center">
                                            <table width="90%" align="center">
                                                <tr>
                                                    <td>
                                                        <img src="../images/avtar.png" alt="Porter" id="ImgMapPorter">
                                                        <h5 id="MapPorterNmae"></h5>
                                                    </td>
                                                    <td align="center">
                                                        <img src="../images/Locate.png" alt="Locate">
                                                        <h5 id="MapCurLocation">Main Corridor</h5>
                                                    </td>
                                                </tr>
                                            </table>

                                        </div>
                                        <div class="mb-3">
                                            <img src="../images/hospital-map.png" id="PorterMap" alt="Map">
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
            <script src="../js/Pager.js"></script>
            <script src="../js/Index8.js"></script>


    </form>
</body>

</html>
                