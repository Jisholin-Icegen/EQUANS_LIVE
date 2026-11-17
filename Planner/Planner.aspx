<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Planner.aspx.cs" Inherits="Planner_Planner" %>

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
    <script src="../js/Planner.js" type="text/javascript"></script>
    <script src="../js/bulk.js" type="text/javascript"></script>
    <script src="../js/ChangePassword.js" type="text/javascript"></script>
    <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">

        <script type="text/javascript">
            var dataSet = [], hurl = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' + '<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Planner/",
                ihurl = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' + '<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Index/",olddatetime = '', prebook = '', TimerHome, ToUpdate = false,
                urlPageValidation =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/MasterPage/Service/Service.aspx?",
                CryptoKey = '<%=ConfigurationManager.AppSettings["CryptoKey"].ToString() %>',
                CryptoPwd = '<%=ConfigurationManager.AppSettings["CryptoIV"].ToString() %>',
                ConProtocol = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>',
                FPatientName = '', TPatientName = '', MRDPatientName = '', GCancelReason, GFinishReason, GTagID, CurrentDStatus, GReqID, GPorterID, IsEdit, GMIndex = '0', GExtn = '', ReqDate = '', ReqTime = '', ReqCat = '0', RFromID = '0', RToID = '0', RPreBook = '0',
                Efrom, ETo, ECategory, EDate, EPatient, Remarks, AReqID, APorter1, APorter2, ADept, Isclear = false, PorterID1 = ''; PorterName1 = ''; PorterID = ''; PorterName = '', PORTERGROUP = '', ISMULTIPORTER = 'NO', IsReturn = 'NO',
                    MAReqID = '', MADept = '', MACount = 60, MANReqID = '', MANCount = 60, MANPorterID = '', MANPorterName = '', GPatientName = '', GFrom = '', GStatus = '2', GOMI = '0', GUser = '', ATReqNB = '',
                    IsMRD = 'NO';

            var PorterCurTasks = '', PendingTasks = '', ATPorterID = '', ATPorterName = '', ATStatus = '', ATReqNB = '';
            var RFromID = '', RToID = '', ReqCat = '', EqpId = '0', EqpName = '';

            var ServiceCode=3, OldFromID = '', OldFrom = '', OldToID = '', OldTo = '', OldCatID = '', OldCategory = '', OldPatientName = '', OldQuantity = '', OldRequestorName = '', OldIsMultiPorter = '0', OKitchen = '',
                LBKitName = '', CatKitName = '', LBKitID = '0', CatKitID = '0',
                NewFrom = '', NewTo = '', NewCategory = '', IsHaywood = false, FHaywood = 'NO', ToHaywood = 'NO';
            const valuePage = {
                truncate: true,
                curPage: 0,
                numLinksTwoSide: 1,
                totalPages: 0
            };

            $(document).ready(function () {
                ServiceCode = sessionStorage.getItem('ServiceCode');

                $('.services-btn-icon').click(function () {
                    // Remove 'active' class from all buttons
                    $('.services-btn-icon').removeClass('active');

                    // Add 'active' class to the clicked button
                    $(this).addClass('active');

                    ServiceCode = $(this).attr('id').replace("divService", "");                    
                    sessionStorage.setItem('ServiceCode', ServiceCode);
                    LoadTasks();
                   // setServiceUpdates(ServiceCode);

                    // Get the rgb color of the clicked button
                    var rgbColor = $(this).data('color'); sessionStorage.setItem('ServiceCode', ServiceCode);

                    // Convert rgb to rgba by appending the opacity
                    var rgbaColor = rgbColor.replace('rgb', 'rgba').replace(')', ', 0.1)');
                    // Set the new rgba color to the CSS variable
                    $(':root').css('--active-color', rgbColor);
                    $(':root').css('--active-bg-color', rgbaColor);
                });
                
                $('#divService' + ServiceCode).trigger('click');

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
                    var arrValid = ["*", ",","."];
                    var key = String.fromCharCode(!event.charCode ? event.which : event.charCode);

                    //alert(key);
                    if (!regex.test(key) && (event.which !== 32) && (event.which !== 13) && (!(arrValid.indexOf(key) > -1))) {
                        event.preventDefault();
                        return false;
                    }

                });



                $('input[type=search]').keypress(function (event) {

                    var regex = new RegExp("^[a-zA-Z0-9]+$");
                    var arrValid = ["*", ",","."];
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
                                   <h6>Queen Alexandra Hospital,</h6><p>Cosham, Portsmouth, PO6 3LY</p>
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
                                            <h5>Routine Tasks</h5>
                                        </td>
                                        <td>

                                            <div class="services-tabs-wrapper">                               
                                <div class="services-btn-icon" data-color="rgb(255, 116, 0)" id="divService1">
                                    <img src="../images/porter-icon.svg">
                                    <span>Portering</span>
                                </div>
                                <div class="services-btn-icon" data-color="rgb(12, 188, 139)" id="divService3">
                                    <img src="../images/cater-icon.png">
                                    <span>Receipt and Distribution</span>
                                </div>
                                
                            </div>

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
                                            <input type="search" maxlength="30" autocomplete="off webauthn" id="TextSearch" class="form-control">
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
                                                <h5 id="TaskHeader"></h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                                    <img src="../images/close-white.svg">
                                                </button>
                                            </div>
                                            <form id="formRequest">
                                                <div class="row">

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


                                                    <div class="col-md-12" id="containerCat" style="background-color: #6dadff; padding: 5px;">
                                                        <div class="row align-items-center" style="padding: 10px;">
                                                            <div class="col-md-1"></div>
                                                            <div class="col-md-2">
                                                                <label>Task Type</label>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <textarea maxlength="50" name="task-description" rows="1" class="form-control" placeholder="search..." id="txtSearchCat" onkeyup="searchCategory(this);"></textarea>
                                                            </div>
                                                        </div>
                                                        <div class="icon-section" id="ReqCategories">
                                                        </div>
                                                        <hr style="margin: 15px 0; border-color: rgba(255,255,255,0.4);" />

                                          <!-- Equipment Type Section -->
                                          <div class="row mb-2 align-items-center justify-content-between" style="padding: 5px 10px;">
                                            <div class="col-md-2">
                                              <label>Equipment Type</label>
                                            </div>
                                            <div class="col-md-6 d-flex align-items-center" style="gap: 10px;">
                                              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="21" viewBox="0 0 20 21" fill="none" style="flex-shrink: 0;">
                                                <path d="M9.58342 18.625C4.87508 18.625 1.04175 14.7917 1.04175 10.0833C1.04175 5.37501 4.87508 1.54167 9.58342 1.54167C14.2917 1.54167 18.1251 5.37501 18.1251 10.0833C18.1251 14.7917 14.2917 18.625 9.58342 18.625ZM9.58342 2.79167C5.55841 2.79167 2.29175 6.06667 2.29175 10.0833C2.29175 14.1 5.55841 17.375 9.58342 17.375C13.6084 17.375 16.8751 14.1 16.8751 10.0833C16.8751 6.06667 13.6084 2.79167 9.58342 2.79167Z" fill="var(--active-color-modal)" />
                                                <path d="M18.3333 19.4583C18.175 19.4583 18.0166 19.4 17.8916 19.275L16.225 17.6083C15.9833 17.3667 15.9833 16.9667 16.225 16.725C16.4666 16.4833 16.8666 16.4833 17.1083 16.725L18.775 18.3917C19.0166 18.6333 19.0166 19.0333 18.775 19.275C18.65 19.4 18.4916 19.4583 18.3333 19.4583Z" fill="var(--active-color-modal)" />
                                              </svg>
                                              <textarea maxlength="50" name="equipment-description" rows="1" class="form-control search-bar" placeholder="Search..." id="txtSearchEquipment" onkeyup="searchEquipment(this);" style="flex-grow: 1; box-shadow: none; background-color: white !important; resize:none; padding-left: 0.5rem;"></textarea>
                                            </div>
                                          </div>
                                          <div class="icon-section" id="EquipmentCategories" style="min-height: 15px;"></div>
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
                                                    <div class="col-md-8">
                                                        <div class="mb-3">
                                                            <label>Remarks</label>
                                                            <textarea maxlength="100" name="task-description" rows="3" class="form-control" placeholder="Remarks" id="txtRemarks"></textarea>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3" id="containerMP" style="cursor: pointer; padding-top: 10px;">
                                                        <table style="width: 80%;">
                                                            <tr>
                                                                <td onclick="setMultiPorter();">
                                                                    <div class="mb-3" align="center">
                                                                        <label>Assistant Required</label>
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
                                                </div>
                                           
                                            <%--<div class="col-md-12">
                                                <div class="mb-3">
                                                    <label style="font-weight: 600;">Division</label> 
                                                    <div id="containerDivision" style="padding-top: 10px;" align="center">
                                                        <table>
                                                            <tbody><tr>
                                                                <td style="padding-left: 10px; padding-top: 15px;">
                                                                    <label>QAH</label>
                                                                </td>
                                                                <td style="padding-left: 10px; padding-right: 10px;">
                                                                      <img src="../images/CNoCheck.png" id="chkQAH" onclick="changeCheck(this);" data-value="Queen Alexandra Hospital" class="MultiPorter MultiPorterDivision">
                                                                </td>
                                                             
                                                                <td style="padding-left: 10px; padding-top: 15px;">
                                                                    <label>R&amp;D</label>
                                                                </td>
                                                                <td style="padding-left: 10px; padding-right: 10px;">
                                                                    <img src="../images/CNoCheck.png" id="chkRAD" onclick="changeCheck(this);" data-value="Receive and Distribution" class="MultiPorter MultiPorterDivision">
                                                                </td>
                                                            </tr>
                                                        </tbody></table>
                                                    </div>
                                                </div>
                                            </div>    --%>
                                            
                                            
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
