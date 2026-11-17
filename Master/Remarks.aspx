<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Remarks.aspx.cs" Inherits="Master_Remarks" %>
 
<html lang="en">

<head>
    <title>Remarks | TRACZO</title>
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
    <script src="../js/Remarks.js" type="text/javascript"></script>
    <script src="../js/bulk.js" type="text/javascript"></script>
    <script src="../js/ChangePassword.js" type="text/javascript"></script>
    <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">

        <script type="text/javascript">
            var dataSet = [], hurl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Master/", olddatetime = '', prebook = '', TimerHome, ToUpdate = false,
                urlPageValidation =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/MasterPage/Service/Service.aspx?",
                CryptoKey = '<%=ConfigurationManager.AppSettings["CryptoKey"].ToString() %>',
                CryptoPwd = '<%=ConfigurationManager.AppSettings["CryptoIV"].ToString() %>',
                ConProtocol = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>',
                FPatientName = '', TPatientName = '', MRDPatientName = '', GCancelReason, GFinishReason, GTagID, CurrentDStatus, GReqID, GPorterID, IsEdit, GMIndex = '0', GExtn = '', ReqDate = '', ReqTime = '', ReqCat = '0', RFromID = '0', RToID = '0', RPreBook = '0',
                Efrom, ETo, ECategory, EDate, EPatient, Remarks, AReqID, APorter1, APorter2, ADept, Isclear = false, PorterID1 = ''; PorterName1 = ''; PorterID = ''; PorterName = '', PORTERGROUP = '', ISMULTIPORTER = 'NO', IsReturn = 'NO',
                    MAReqID = '', MADept = '', MACount = 60, MANReqID = '', MANCount = 60, MANPorterID = '', MANPorterName = '', GPatientName = '', GFrom = '', GStatus = '2', GOMI = '0', GUser = '', ATReqNB = '',
                    IsMRD = 'NO', ServiceCode = '1', EServiceCode = '', callFrom = 'Parent';

            var PorterCurTasks = '', PendingTasks = '', ATPorterID = '', ATPorterName = '', ATStatus = '', ATReqNB = '';;


            function ClearSelection() {

            }

            $(document).ready(function () {
                ServiceCode = sessionStorage.getItem('ServiceCode');
                InitChangePassword();
                LoadPresetValues();


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

                $('.services-btn-icon').click(function () {
                    // Remove 'active' class from all buttons

                    ServiceCode = $(this).attr('id').replace("divService", ""); callFrom = 'Parent'
                    setRootServices(this);
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
                if (callFrom == "Parent")
                    LoadPresetValues();
            }

        </script>
    </telerik:RadCodeBlock>
    <style type="text/css">
        .RadComboBox .rcbInput {
            background: #f8f7f7 !important;
            height: 2.428571em !important;
        }

        .RadComboBox .rcbActionButton {
            height: 2.428571em !important;
        }

        .RadComboBox .rcbEmptyMessage {
            color: #666;
            font-style: normal !important;
        }

        h6 {
            font-size: 16px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>


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
                                        <li>
                                            <a href="../html/dashboard.html" style="display: none">
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
                                        <li class="current-menu-item">
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
                            <div class="services-button">
                                <label>Services</label>
                            </div>
                            <div class="services-tabs-wrapper">
                                <div class="services-btn-icon active" data-color="rgb(255, 116, 0)" id="divService1">
                                    <img src="../images/porter-icon.svg">
                                    <span>Porter</span>
                                </div> <div class="services-btn-icon" data-color="rgb(110, 48, 243)" id="divService3">
                                    <img src="../images/clean-icon.svg">
                                    <span>Receipt and Distribution</span>
                                </div>
                                <div class="services-btn-icon" data-color="rgb(12, 188, 139)" id="divService2" style="
    visibility: hidden;
">
                                    <img src="../images/cater-icon.svg">
                                    <span>Cater</span>
                                </div>
                               
                                <div class="services-btn-icon" data-color="rgb(255, 87, 51)" id="divService4" style="
    visibility: hidden;
">
                                    <img src="../images/pest-icon.svg">
                                    <span>Feedback</span>
                                </div>
                                <div class="services-btn-icon" data-color="rgb(255, 87, 51)" id="divService5" style="
    visibility: hidden;
">
                                    <img src="../images/security-icon.svg">
                                    <span>Security</span>
                                </div>
                            </div>

                            <div class="action-btn-wrapper"></div>
                        </div>

                        <div class="section-head">
                            <div class="section-head-left">
                                <table>
                                    <tr>
                                        <td>
                                            <h5>Remark Master</h5>
                                        </td>

                                    </tr>
                                </table>

                            </div>
                            <%-- <div class="section-head-right d-flex align-items-center">

                                <div class="search-wrap shadow w-100">
                                    <div class="search-box">
                                        <form>
                                            <input type="search" maxlength="30"  autocomplete="off webauthn"  class="form-control">
                                            <input type="submit" value="" class="search-submit">
                                        </form>
                                    </div>
                                </div>
                            </div>--%>
                        </div>

                        <div class="category-master">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-wrap me-4" style="min-height: 750px; margin-top: 0px; padding-bottom: 250px;">
                                        <div class="row">

                                            <div class="col-md-6">

                                                <h6>Remarks  </h6>
                                            </div>
                                            <div class="col-md-6">
                                                <h6>Notes  </h6>
                                            </div>

                                            <hr />

                                            <div class="col-md-3 mb-4">
                                                <textarea maxlength="50" name="task-description" rows="3" class="form-control" placeholder="Remarks" id="txtRequestRemarks"></textarea>
                                            </div>
                                            <div class="col-md-1 section-head-right d-flex align-items-center">

                                                <button type="button" class="btn btn-primary w-100" id="BtnRemarks" onclick="ADD(this,'txtRequestRemarks','REMARKS','drpRemarks','imgDeleteRemarks');return false;">
                                                    <img
                                                        src="../images/memo.png">
                                                    <span id="txtBtnRemarks">Add</span></button>
                                            </div>
                                            <div class="col-md-2 section-head-right d-flex align-items-center">
                                                <button type="button" class="btn btn-danger w-60" id="imgDeleteRemarks" style="visibility: hidden" onclick="DELETE('imgDeleteRemarks','REMARKS','drpRemarks','txtRequestRemarks');return false;"
                                                    data-bs-dismiss="modal">
                                                    <img src="../images/multiply.svg">
                                                    Delete</button>

                                            </div>

                                            <div class="col-md-3">
                                                <textarea maxlength="50" name="task-description" rows="3" class="form-control" placeholder="Notes" id="txtCompleteRemarks"></textarea>
                                            </div>
                                            <div class="col-md-1 section-head-right d-flex align-items-center">
                                                <button type="button" class="btn btn-primary w-100" id="BtnCompleteRemarks" onclick="ADD(this,'txtCompleteRemarks','FREASON','drpCompletedRemarks','imgDeleteCompleteRemarks');return false;">
                                                    <img
                                                        src="../images/memo.png">
                                                    <span id="txtBtnCompleteRemarks">Add</span></button>
                                            </div>
                                            <div class="col-md-2 section-head-right d-flex align-items-center">
                                                <button type="button" class="btn btn-danger w-60" style="visibility: hidden" onclick="DELETE('imgDeleteCompleteRemarks','FREASON','drpCompletedRemarks','txtCompleteRemarks');return false;"
                                                    data-bs-dismiss="modal" id="imgDeleteCompleteRemarks">
                                                    <img src="../images/multiply.svg">
                                                    Delete</button>

                                            </div>
                                            <br />
                                            <div class="col-md-4">
                                                <select name="selectFloor" id="drpRemarks" tabindex="1" class="form-control search_test" onchange="OnChangeDropdown('drpRemarks','txtRequestRemarks','txtBtnRemarks','imgDeleteRemarks');">
                                                    <option value="0">-SELECT-</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                            </div>
                                            <div class="col-md-4">
                                                <select name="selectFloor" id="drpCompletedRemarks" tabindex="2" class="form-control search_test" onchange="OnChangeDropdown('drpCompletedRemarks','txtCompleteRemarks','txtBtnCompleteRemarks','imgDeleteCompleteRemarks');">
                                                    <option value="0">-SELECT-</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                            </div>

                                            <hr style="margin-top: 40px;" />
                                            <div class="col-md-6">

                                                <h6>Cancelled Remarks  </h6>
                                            </div>
                                            <div class="col-md-6">
                                                <h6>Message Track  </h6>
                                            </div>

                                            <hr />

                                            <div class="col-md-3 mb-4">
                                                <textarea maxlength="50" name="task-description" rows="3" class="form-control" placeholder="Remarks" id="txtCancelledRemarks"></textarea>
                                            </div>
                                            <div class="col-md-1 section-head-right d-flex align-items-center">

                                                <button type="button" class="btn btn-primary w-100" id="BtnCancelRemarks" onclick="ADD(this,'txtCancelledRemarks','CREASON','drpCancelRemarks','imgDeleteCancelRemarks');return false;">
                                                    <img
                                                        src="../images/memo.png">
                                                    <span id="txtBtnCancelRemarks">Add</span>
                                                </button>
                                            </div>
                                            <div class="col-md-2 section-head-right d-flex align-items-center">
                                                <button type="button" class="btn btn-danger w-60" id="imgDeleteCancelRemarks" onclick="DELETE('imgDeleteCancelRemarks','CREASON','drpCancelRemarks','txtCancelledRemarks');return false;"
                                                    data-bs-dismiss="modal" style="visibility: hidden">
                                                    <img src="../images/multiply.svg">
                                                    Delete</button>

                                            </div>

                                            <div class="col-md-3">
                                                <textarea maxlength="50" name="task-description" rows="3" class="form-control" placeholder="Reason" id="txtMsgTrack"></textarea>
                                            </div>
                                            <div class="col-md-1 section-head-right d-flex align-items-center">
                                                <button type="button" class="btn btn-primary w-100" id="BtnMsgTrack" onclick="ADD(this,'txtMsgTrack','MSG','drpMsgTrack','imgDeleteMsgTrack');return false;">
                                                    <img
                                                        src="../images/memo.png">
                                                    <span id="txtBtnMsgTrack">Add</span></button>
                                            </div>
                                            <div class="col-md-2 section-head-right d-flex align-items-center">
                                                <button type="button" class="btn btn-danger w-60" onclick="DELETE('imgDeleteMsgTrack','MSG','drpMsgTrack','txtMsgTrack');return false;"
                                                    data-bs-dismiss="modal" id="imgDeleteMsgTrack" style="visibility: hidden">
                                                    <img src="../images/multiply.svg">
                                                    Delete</button>

                                            </div>


                                            <br />
                                            <div class="col-md-4">
                                                <select name="selectFloor" id="drpCancelRemarks" tabindex="3" class="form-control search_test" onchange="OnChangeDropdown('drpCancelRemarks','txtCancelledRemarks','txtBtnCancelRemarks','imgDeleteCancelRemarks');">
                                                    <option value="0">-SELECT-</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                            </div>
                                            <div class="col-md-4">
                                                <select name="selectFloor" id="drpMsgTrack" tabindex="4 " class="form-control search_test" onchange="OnChangeDropdown('drpMsgTrack','txtMsgTrack','txtBtnMsgTrack','imgDeleteMsgTrack');">
                                                    <option value="0">-SELECT-</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                            </div>
                                        </div>

                                        <hr style="margin-top: 20px;" />
                                        <div class="col-md-6">
                                            <h6>Porter Messages  </h6>
                                        </div>
                                        <div class="col-md-6"></div>

                                        <hr />

                                        <div class="row">
                                            <div class="col-md-3 mb-4">
                                                <textarea maxlength="50" name="task-description" rows="3" class="form-control" placeholder="Remarks" id="txtPorterRemarks"></textarea>
                                            </div>
                                            <div class="col-md-1 section-head-right d-flex align-items-center">

                                                <button type="button" class="btn btn-primary w-100" id="BtnPorterRemarks" onclick="ADD(this,'txtPorterRemarks','PREMARKS','drpPorterRemarks','imgDeletePorterRemarks');return false;">
                                                    <img
                                                        src="../images/memo.png">
                                                    <span id="txtBtnPorterRemarks">Add</span>
                                                </button>
                                            </div>
                                            <div class="col-md-2 section-head-right d-flex align-items-center">
                                                <button type="button" class="btn btn-danger w-60" id="imgDeletePorterRemarks" onclick="DELETE('imgDeletePorterRemarks','PREMARKS','drpPorterRemarks','txtPorterRemarks');return false;"
                                                    data-bs-dismiss="modal" style="visibility: hidden">
                                                    <img src="../images/multiply.svg">
                                                    Delete</button>

                                            </div>


                                            <div class="col-md-6"></div>
                                            <br />

                                            <div class="col-md-4">
                                                <select name="selectFloor" id="drpPorterRemarks" tabindex="3" class="form-control search_test" onchange="OnChangeDropdown('drpPorterRemarks','txtPorterRemarks','txtBtnPorterRemarks','imgDeletePorterRemarks');">
                                                    <option value="0">-SELECT-</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
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
