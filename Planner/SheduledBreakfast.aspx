<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SheduledBreakfast.aspx.cs" Inherits="Planner_Planner" %>

<html lang="en">

<head>
    <title>Planner | TRACZO</title>
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
    <script src="../js/Planner_breakfast.js" type="text/javascript"></script>
    <script src="../js/bulk.js" type="text/javascript"></script>
    <script src="../js/ChangePassword.js" type="text/javascript"></script>
    <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">

        <script type="text/javascript">
            var dataSet = [], hurl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Planner/", olddatetime = '', prebook = '', TimerHome, ToUpdate = false,
                urlPageValidation =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/MasterPage/Service/Service.aspx?",
                CryptoKey = '<%=ConfigurationManager.AppSettings["CryptoKey"].ToString() %>',
                CryptoPwd = '<%=ConfigurationManager.AppSettings["CryptoIV"].ToString() %>',
                ConProtocol = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>',
                FPatientName = '', TPatientName = '', MRDPatientName = '', GCancelReason, GFinishReason, GTagID, CurrentDStatus, GReqID, GPorterID, IsEdit, GMIndex = '0', GExtn = '', ReqDate = '', ReqTime = '', ReqCat = '0', RFromID = '0', RToID = '0', RPreBook = '0',
                Efrom, ETo, ECategory, EDate, EPatient, Remarks, AReqID, APorter1, APorter2, ADept, Isclear = false, PorterID1 = ''; PorterName1 = ''; PorterID = ''; PorterName = '', PORTERGROUP = '', ISMULTIPORTER = 'NO', IsReturn = 'NO',
                    MAReqID = '', MADept = '', MACount = 60, MANReqID = '', MANCount = 60, MANPorterID = '', MANPorterName = '', GPatientName = '', GFrom = '', GStatus = '2', GOMI = '0', GUser = '', ATReqNB = '',
                    IsMRD = 'NO', LBKitName = '', CatKitName = '', LBKitID = '0', CatKitID = '0';

            var PorterCurTasks = '', PendingTasks = '', ATPorterID = '', ATPorterName = '', ATStatus = '', ATReqNB = '';
            var RFromID = '', RToID = '', ReqCat = '';


            $(document).ready(function () {
                InitChangePassword();
                LoadNewRequest();
                LoadTasks();



                $("#txtFromLoc").keyup(function () {

                    loadsuggesstion('from', $(this).val());
                });


                $("#txtToLoc").keyup(function () {

                    loadsuggesstion('to', $(this).val());
                });

                $('textarea').keypress(function (event) {

                    var regex = new RegExp("^[a-zA-Z0-9]+$");
                    var arrValid = ["*", ",", ".", "-", "_"];
                    var key = String.fromCharCode(!event.charCode ? event.which : event.charCode);

                    //alert(key);
                    if (!regex.test(key) && (event.which !== 32) && (event.which !== 13) && (!(arrValid.indexOf(key) > -1))) {
                        event.preventDefault();
                        return false;
                    }

                });



                $('input[type=search]').keypress(function (event) {

                    var regex = new RegExp("^[a-zA-Z0-9]+$");
                    var arrValid = ["*", ",", ".", "-", "_"];
                    var key = String.fromCharCode(!event.charCode ? event.which : event.charCode);

                    //alert(key);
                    if (!regex.test(key) && (event.which !== 32) && (event.which !== 13) && (!(arrValid.indexOf(key) > -1))) {
                        event.preventDefault();
                        return false;
                    }

                });
            });

        </script>
    </telerik:RadCodeBlock>
    <style type="text/css">
        .btn-indexblue {
            background-color: #0a57c7;
            color: white;
            font-weight: bold;
            max-height: 55px;
            text-decoration: none;
            padding: 8px 10px;
            font-size: 15px;
        }

            .btn-indexblue:hover {
                background-color: white;
                color: #0a57c7;
                text-decoration: underline;
                border: 1px solid #0a57c7;
            }

        .table-wrap table th, .table-wrap table td {
            padding: 4px;
            font-size: 14px;
            vertical-align: middle;
        }

        .LocationList {
            z-index: 100;
            max-height: 455px;
            float: left;
            list-style: none;
            margin-top: -3px;
            padding: 0;
            position: absolute;
            overflow-y: scroll;
            min-width: 435px;
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="HFCancelReqID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFERID" runat="server" ClientIDMode="Static" />

        <asp:HiddenField ID="HFERNO" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFStatusID" runat="server" ClientIDMode="Static" />
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
                                    <img src="../images/hospital.jpg" alt="Hospital">
                                </div>
                                <div class="hospital-title">
                                    <h5>Welcome</h5>
                                    <h6>QAH University Hospital,</h6>
                                    <p>Newcastle Rd, Stoke-on-Trent ST4 6QG, United Kingdom</p>
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
                                        <li class="current-menu-item">
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
                        <div class="section-head">
                            <div class="section-head-left">
                                <table>
                                    <tr>
                                        <td>
                                            <h5>SCHEDULED BREAKFAST</h5>
                                        </td>
                                        <td style="padding: 20px;">

                                            <div class="add-task-link" onclick="setNewTask();">
                                                <a href="javascript:void(0)" class="btn btn-secondary">
                                                    <img src="../images/memo.png" alt="Add Task">
                                                    Add 
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </table>

                            </div>
                            <div class="section-head-right d-flex align-items-center">

                                <div class="search-wrap shadow w-100">
                                    <div class="search-box">
                                        <form>
                                            <input type="search" maxlength="30" autocomplete="off webauthn" id="TextSearch" class="form-control" placeholder="Search">
                                            <input type="submit" value="" class="search-submit" onclick="LoadTasks(); return false;">
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="category-master">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="table-wrap" style="min-height: 800px;">

                                        <div class="table-responsive" id="tblRoutineTasks">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="loaderElement" style="display: none">
                            <div class="loader-spinner"></div>
                        </div>
                    </div>
                    <!-- /Right Panel -->

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

                    <div class="modal fade addTask" id="addTask" tabindex="-1" aria-labelledby="addTaskLabel" aria-hidden="true">
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
                                        <div class="form-wrap me-4">
                                            <div class="d-flex align-items-center justify-content-between mb-4">
                                                <h5 id="TaskHeader">Schedule BreakFast</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                                    <img src="../images/close-white.svg">
                                                </button>
                                            </div>
                                            <form id="formRequest">
                                                <div class="row">

                                                    <div class="col-md-6" id="containerFrom">
                                                        <div class="mb-3">
                                                            <label>From <span style="font-size: 11px">(KITCHEN)</span></label>
                                                            <textarea maxlength="50" name="txtFromLoc" rows="1" class="form-control" placeholder="-- Select --" id="txtFromLoc" style="padding: 15px;" readonly></textarea>
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



                                                    <div class="col-md-12" id="containerCat" style="background-color: #6dadff; padding: 5px; margin-top: 50px;">
                                                        <div class="row align-items-center" style="padding: 10px;">
                                                            <div class="col-md-1"></div>
                                                            <div class="col-md-2">
                                                                <label>Task Type</label>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <textarea maxlength="50" name="task-description" rows="2" class="form-control" placeholder="search..." id="txtSearchCat" onkeyup="searchCategory(this);"></textarea>
                                                            </div>
                                                        </div>
                                                        <div class="icon-section" id="ReqCategories" style="padding: 20px 60px 20px 60px;">
                                                        </div>
                                                    </div>

                                                    <div class="col-md-10" style="margin-top: 50px;">
                                                        <div class="mb-3">
                                                            <label>Requester Remarks</label>
                                                            <textarea maxlength="100" name="task-description" rows="4" class="form-control" placeholder="Requester Remarks" id="txtRemarks"></textarea>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-3" id="containerMP" style="cursor: pointer; padding-top: 10px; display: none">
                                                        <table style="width: 80%;">
                                                            <tr>
                                                                <td onclick="setMultiPorter();">
                                                                    <div class="mb-3" align="center">
                                                                        <label>Two Porters</label>
                                                                        <img src="../images/NoMCheck.jpg" id="chkMultiPorter" class="MultiPorter">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>


                                                    </div>

                                                </div>
                                                <div class="col"></div>
                                            </form>
                                        </div>
                                        <div class="custom-calendar-wrap">

                                            <div class="RoutineTaskTop" style="padding: 30px" id="divDateTIme">
                                                <div class="col-md-12" id="containerTime">
                                                    <div class="mb-3">
                                                        <label for="txtReqTime">Time</label>
                                                        <br />
                                                        <br />
                                                        <input type="time" id="txtReqTime" class="form-control">

                                                        <br />
                                                        <label>Repeat</label>
                                                        <br />
                                                        <br />
                                                        <table style="width: 80%;" align="center">
                                                            <tr class="trRoutineDays" onclick="selRoutineRepeat('chkSunday');">
                                                                <td>
                                                                    <img src="../images/NoMCheck.jpg" id="chkSunday" class="RoutineDays">
                                                                </td>
                                                                <td style="vertical-align: middle;">
                                                                    <span>Sunday</span>
                                                                </td>
                                                            </tr>
                                                            <tr class="trRoutineDays" onclick="selRoutineRepeat('chkMonday');">
                                                                <td>
                                                                    <img src="../images/NoMCheck.jpg" id="chkMonday" class="RoutineDays">
                                                                </td>
                                                                <td style="vertical-align: middle;">
                                                                    <span>Monday</span>
                                                                </td>
                                                            </tr>
                                                            <tr class="trRoutineDays" onclick="selRoutineRepeat('chkTuesday');">
                                                                <td>
                                                                    <img src="../images/NoMCheck.jpg" id="chkTuesday" class="RoutineDays">
                                                                </td>
                                                                <td style="vertical-align: middle;">
                                                                    <span>Tuesday</span>
                                                                </td>
                                                            </tr>
                                                            <tr class="trRoutineDays" onclick="selRoutineRepeat('chkWednesday');">
                                                                <td>
                                                                    <img src="../images/NoMCheck.jpg" id="chkWednesday" class="RoutineDays">
                                                                </td>
                                                                <td style="vertical-align: middle;">
                                                                    <span>Wednesday</span>
                                                                </td>
                                                            </tr>
                                                            <tr class="trRoutineDays" onclick="selRoutineRepeat('chkThursday');">
                                                                <td>
                                                                    <img src="../images/NoMCheck.jpg" id="chkThursday" class="RoutineDays">
                                                                </td>
                                                                <td style="vertical-align: middle;">
                                                                    <span>Thursday</span>
                                                                </td>
                                                            </tr>
                                                            <tr class="trRoutineDays" onclick="selRoutineRepeat('chkFriday');">
                                                                <td>
                                                                    <img src="../images/NoMCheck.jpg" id="chkFriday" class="RoutineDays">
                                                                </td>
                                                                <td style="vertical-align: middle;">
                                                                    <span>Friday</span>
                                                                </td>
                                                            </tr>
                                                            <tr class="trRoutineDays" onclick="selRoutineRepeat('chkSaturday');">
                                                                <td>
                                                                    <img src="../images/NoMCheck.jpg" id="chkSaturday" class="RoutineDays">
                                                                </td>
                                                                <td style="vertical-align: middle;">
                                                                    <span>Saturday</span>
                                                                </td>
                                                            </tr>

                                                        </table>
                                                    </div>

                                                    <div class="col-md-12" id="containerDate">
                                                        <div class="mb-3">
                                                            <label for="txtEnddate">End Date</label>
                                                            <input type="date" id="txtEnddate" class="form-control">
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>
                                            <div class="RequestIcons" style="padding: 10px">
                                                <div class="mb-3 row">

                                                    <div class="col-sm-4">
                                                        <button type="button" class="btn btn-outline w-100"
                                                            data-bs-dismiss="modal">
                                                            <img src="../images/multiply.svg">
                                                            Cancel</button>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <button type="button" class="btn btn-secondary w-100" onclick="submitRequest();">
                                                            <img
                                                                src="../images/envelope.png">
                                                            Submit</button>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <button type="button" class="btn btn-outline w-100" onclick="deleteTask();return false;" id="btnDeleteTask" style="background-color: #a4a4a4;">
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
                                    </div>
                                </div>
                            </div>
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
