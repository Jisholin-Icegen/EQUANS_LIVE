<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Group.aspx.cs" Inherits="Master_Group" EnableEventValidation="false" %>
 
<html lang="en">

<head>
    <title>Group | TRACZO</title>
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
    <script src="../js/Group.js" type="text/javascript"></script>
    <script src="../js/bulk.js" type="text/javascript"></script>
    <script src="../js/ChangePassword.js" type="text/javascript"></script>
    <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">

        <script type="text/javascript">
            var dataSet = [], hurl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Master/",
                olddatetime = '', prebook = '', TimerHome, ToUpdate = false,
                CryptoKey = '<%=ConfigurationManager.AppSettings["CryptoKey"].ToString() %>',
                CryptoPwd = '<%=ConfigurationManager.AppSettings["CryptoIV"].ToString() %>',
                ConProtocol = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>',
                urlPageValidation =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/MasterPage/Service/Service.aspx?",
                FPatientName = '', TPatientName = '', MRDPatientName = '', GCancelReason, GFinishReason, GTagID, CurrentDStatus, GReqID, GPorterID, IsEdit, GMIndex = '0', GExtn = '', ReqDate = '', ReqTime = '', ReqCat = '0', RFromID = '0', RToID = '0', RPreBook = '0',
                Efrom, ETo, ECategory, EDate, EPatient, Remarks, AReqID, APorter1, APorter2, ADept, Isclear = false, PorterID1 = ''; PorterName1 = ''; PorterID = ''; PorterName = '', PORTERGROUP = '', ISMULTIPORTER = 'NO', IsReturn = 'NO',
                    MAReqID = '', MADept = '', MACount = 60, MANReqID = '', MANCount = 60, MANPorterID = '', MANPorterName = '', GPatientName = '', GFrom = '', GStatus = '2', GOMI = '0', GUser = '', ATReqNB = '',
                    IsMRD = 'NO';

            var PorterCurTasks = '', PendingTasks = '', ATPorterID = '', ATPorterName = '', ATStatus = '', ATReqNB = '';;


            function encryptAES(text) {
                if (text === undefined || text === null) return '';

                const key = CryptoJS.enc.Utf8.parse('9090909090909090');
                const iv = CryptoJS.enc.Utf8.parse('9090909090909090');

                const encrypted = CryptoJS.AES.encrypt(text.toString(), key, {
                    iv: iv,
                    mode: CryptoJS.mode.CBC,
                    padding: CryptoJS.pad.Pkcs7
                });

                return encodeURIComponent(encrypted.toString());
            }

            function ClearSelection() {

            }

            $(document).ready(function () {
                InitChangePassword();
                txtGroup = $('#txtGroupName');

                RadComboPorter = $('#RadComboPorter');
                RadLstAddedLocations = $('#LstAddedLocations');

                RadLstAddedLoc = $find("<%=LstAddedLocations.ClientID%>");

                ddlPorter = $find("<%=RadComboPorter.ClientID%>");
                LoadNewRequest();
                LoadTasks();



                $('textarea').keypress(function (event) {

                    var regex = new RegExp("^[a-zA-Z0-9]+$");
                    var arrValid = ["*", ",", "."];
                    var key = String.fromCharCode(!event.charCode ? event.which : event.charCode);

                    //alert(key);
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

                $("#txtFromLoc").keyup(function () {

                    loadsuggesstion('from', $(this).val());
                });
            });

            function BindLocation(id, name, flag) {
                console.log("BindLocation called with:", id, name, flag);

                document.getElementById("txtFromLoc").value = name;
                AddLocation(id, name, flag);

                var suggestionDiv = document.getElementById("suggesstionFrom");
                if (suggestionDiv) {
                    suggestionDiv.style.display = "none";
                }
            }


            function AddLocation(ID, Value, Modal) {
                for (i = 0; i < RadLstAddedLoc.get_items().get_count(); i++) {
                    if (RadLstAddedLoc.getItem(i).get_value() == ID) {
                        alert("This location already exists in the list");
                        return false;
                    }
                }

                var item = new Telerik.Web.UI.RadListBoxItem();
                item.set_imageUrl("../images/location.png");
                item.set_text(Value);
                item.set_value(ID);

                RadLstAddedLoc.trackChanges();
                RadLstAddedLoc.get_items().add(item);
                RadLstAddedLoc.commitChanges();

                $('#spnTex').html(Value + ' <b>Added</b>');
            }
            function CloseDllList() {
                $('#txtFromLoc').val('');
                $("#suggesstionFrom").hide();
            }
            function loadsuggesstion(searchType, Val) {
                var sType = (searchType == 'from') ? "SF" : "ST";
                var encProcess = encryptAES('GETSEARCHEDLOCATION');
                var encLocation = encryptAES(Val);
                var encGroupID = encryptAES(document.getElementById('HFERID').value);

                $.ajax({
                    async: true,
                    url: hurl + "Service/Service.aspx?Process=" + encProcess +
                        "&LOCATION=" + encLocation +
                        "&GROUPID=" + encGroupID,
                    type: 'POST',
                    data: 'pData',
                    dataType: 'json',
                    beforeSend: function () {
                        $("#" + ((searchType == 'from') ? "txtFromLoc" : "txtToLoc"))
                            .css("background", "#FFF url(../images/LoadingN.gif) no-repeat 95%")
                            .css("background-size", "35px");
                    },
                    success: function (data) {
                        var suggestionId = (searchType == 'from') ? "suggesstionFrom" : "suggesstionTo";
                        var textboxId = (searchType == 'from') ? "txtFromLoc" : "txtToLoc";

                        $("#" + suggestionId).show();
                        $("#" + suggestionId).html(
                            (data[0].RESULT.length > 30
                                ? "<div style='text-align:right'><img onclick='CloseDllList()' style='height:30px;padding-right:70px;' src='../images/closelst.png'> </div>"
                                : "<div></div>")
                            + data[0].RESULT
                        );

                        $("#" + textboxId).css("background", "#FFF");
                    }
                });
            }
        </script>
    </telerik:RadCodeBlock>
    <style type="text/css">
        .LocationList {
            z-index: 100;
            max-height: 350px;
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

        .form-control {
            background-color: white !important;
        }


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

        .modal-x1 {
            max-width: 1140px !important;
        }

        .addTask .form-wrap {
            max-width: 580px !important;
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
                                        <li><a href="../Index/Index.aspx"><span>
                                            <img src="../images/home.png" alt="Home"></span> Home </a></li>
                                        <li><a href="#" onclick="redirectFloorwiseTrac()"><span>
                                            <img src="../images/world-map.png" alt="Map"></span> Map </a></li>
                                        <li><a href="../Track/TrackNew.aspx"><span>
                                            <img src="../images/doc.png" alt="Track"></span> Track </a></li>
                                        <li><a href="../Reports/Report.aspx"><span>
                                            <img src="../images/clipboard.png" alt="Reports"></span> Reports </a></li>
                                        <li><a href="../Planner/Planner.aspx"><span>
                                            <img src="../images/spiral-calendar.png" alt="Planner"></span> Planner </a></li>
                                        <li><a href="../Master/Porter.aspx"><span>
                                            <img src="../images/porter-master.png" alt="Porter Master"></span> Porter Master </a></li>
                                        <li><a href="../Master/Category.aspx"><span>
                                            <img src="../images/category-master.png" alt="Task Types"></span> Task Types </a></li>
                                        <li><a href="../Master/Locations.aspx"><span>
                                            <img src="../images/location.png" alt="Location Master"></span> Location Master </a></li>
                                        <li><a onclick="javascript:Bulk();" href="#"><span>
                                            <img src="../images/upload-task.png" alt="Upload Tasks"></span> Upload Tasks </a></li>
                                        <li><a href="../Master/PerformLogs.aspx"><span>
                                            <img src="../images/priority.png" alt="P3rform Logs"></span> P3rform Logs </a></li>
                                        <li class="current-menu-item"><a href="../Master/Group.aspx"><span>
                                            <img src="../images/group-master.png" alt="Group Master"></span> Group Master </a></li>
                                        <li><a href="../Master/Remarks.aspx"><span>
                                            <img src="../images/memo.png" alt="Remarks Master"></span> Remarks Master </a></li>
                                        <li><a href="../Master/Users.aspx"><span>
                                            <img src="../images/porter-master.png" alt="User Master"></span> User Master </a></li>
                                        <li><a href="../Master/Roles.aspx"><span>
                                            <img src="../images/UserRole.png" alt="Role Master"></span> Role Master </a></li>
                                    </ul>
                                </div>
                            </div>
                            <br>
                            <br>
                            <br>
                            <div>
                                <div class="profile-link" onmouseover="HoverOpenSideBar()" onmouseout="OutOpenSideBar()">
                                    <div class="profile-img">
                                    </div>
                                    <div class="profile-designation">
                                        <h6><span id="spanUserName"></span>
                                            <br />
                                            <br />
                                            <span style="text-decoration: underline; font-size: 12px;">Log out</span></h6>
                                    </div>
                                    <a href="../login.aspx" class="stretched-link"></a>
                                    <img src="../images/User.png" class="ImgUser" onmouseover="HoverOpenSideBar()" alt="Profile">


                                    <div class="DivPassword" id="DivPassword" style="display: none" align="left">
                                        <ul class="Pmenu">
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
                                            <h5>Location Group</h5>
                                        </td>
                                        <td style="padding: 20px;">

                                            <div class="add-task-link" onclick="setNewTask();">
                                                <a href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#addTask"
                                                    class="btn btn-primary">
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
                                            <input type="search" class="form-control">
                                            <input type="submit" value="" class="search-submit">
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="category-master">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="table-wrap" style="min-height: 500px;">

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


                    <div class="modal fade addTask" id="addTask" tabindex="-1" aria-labelledby="addTaskLabel" aria-hidden="true">
                        <div class="modal-dialog modal-x1">
                            <div class="modal-content">
                                <div class="search-header" style="display: none;">
                                    <div class="search-wrap shadow">
                                        <div class="search-box">
                                            <form>
                                                <input type="search" class="form-control">
                                                <input type="submit" value="" class="search-submit">
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-body">
                                    <div class="d-flex justify-content-between">
                                        <div class="form-wrap me-2" style="height: 547px !important">
                                            <div class="d-flex align-items-center justify-content-between mb-4">
                                                <h5 id="TaskHeader"></h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                                    <img src="../images/close-white.svg">
                                                </button>
                                            </div>
                                            <form id="formRequest">
                                                <div class="row">

                                                    <div class="col-md-12">
                                                        <div class="mb-3">
                                                            <label>Group Name</label>
                                                            <textarea name="txtGroupName" rows="1" class="form-control" placeholder="Group Name" id="txtGroupName"></textarea>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-12" id="containerFrom">
                                                        <div class="mb-3">
                                                            <label>Location</label>

                                                            <div id="divgp">

                                                                <textarea name="txtFromLoc" rows="1" class="form-control" placeholder="-- Select --" id="txtFromLoc" style="padding: 15px;"></textarea>
                                                                <div id="suggesstionFrom" class=""></div>



                                                            </div>

                                                        </div>
                                                    </div>
                                                    <div class="col-md-12" id="containerTo">
                                                        <div class="mb-3">
                                                            <label>Porter</label>
                                                            <telerik:RadComboBox TextSearchMode="Contains" IsFilteringEnabled="True" Filter="Contains" Font-Bold="true"
                                                                InputCssClass="uppercase CaptionCont SelectBox form-control search_test search" CssClass="uppercase CaptionCont SelectBox form-control search_test search" Visible="true" EnableCheckAllItemsCheckBox="true"
                                                                RenderMode="Lightweight" ID="RadComboPorter" runat="server" EmptyMessage="SELECT PORTER" DataTextField="VALUE" DataValueField="ID"
                                                                CheckBoxes="true" Height="300px" Width="100%" OnClientItemChecking="OnClientItemChecking" OnClientItemChecked="OnClientDropDown">
                                                                <Localization AllItemsCheckedString="All location checked" ItemsCheckedString="Porter selected" CheckAllString="Check All Location" />
                                                            </telerik:RadComboBox>


                                                        </div>
                                                    </div>



                                                </div>

                                                <div class="col"></div>
                                            </form>
                                        </div>
                                        <div class="custom-calendar-wrap">

                                            <div class="RequestIcons" style="padding: 20px; width: 500px !important">


                                                <div class="col-md-12" id="containerPatient">
                                                    <div class="mb-3">
                                                        <label>Location</label>
                                                        <span style="margin-left: 20px" id="spnTex"></span>
                                                        <telerik:RadListBox ID="LstAddedLocations" CssClass="multiColumn" runat="server" DataKeyField="LocationID" Height="400px"
                                                            DataTextField="VALUE" AllowDelete="true" SelectionMode="Multiple"
                                                            DataValueField="ID" Style="top: 0px; left: 0px" Width="100%">
                                                        </telerik:RadListBox>
                                                    </div>
                                                </div>


                                            </div>

                                            <div class="RequestIcons" style="padding: 10px; width: 500px !important;">
                                                <div class="mb-3 row justify-content-end">


                                                    <div class="col-sm-4">
                                                        <button type="button" class="btn btn-secondary w-100" onclick="submitRequest();" fdprocessedid="zbn9o7">
                                                            <img src="../images/envelope.png">
                                                            Submit</button>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <button type="button" class="btn btn-outline w-100" onclick="CancelGroups();" data-bs-dismiss="modal" fdprocessedid="u4zpiq">
                                                            <img src="../images/multiply.svg">
                                                            Cancel</button>
                                                    </div>

                                                    <div class="col-sm-4" style="">
                                                        <button type="reset" class="btn btn-tertiary w-100" onclick="deleteRequest('DELETE');">Delete</button>
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


        <!-- JS CSS -->
        <script src="../js/bootstrap.bundle.min.js"></script>
        <script src="../js/jquery.sumoselect.min.js"></script>
        <script src="../js/style.js"></script>
    </form>
</body>
</html>
