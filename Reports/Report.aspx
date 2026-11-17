<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Report.aspx.cs" Inherits="Planner_Planner" %>
 
<html lang="en">

<head>
    <title>Reports | TRACZO</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- Favicon -->
    <link rel="icon" href="../favicon.png" />
    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="../css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../css/sumoselect.min.css">
    <link rel="stylesheet" type="text/css" href="../css/style.css" />
    <link href="../css/changepwd.css" rel="stylesheet" />

    <script type="text/javascript" src="../FUSIONCHARTS/fusioncharts.js"></script>
    <script type="text/javascript" src="../FUSIONCHARTS/themes/fusioncharts.theme.fint.js"></script>
    <script src="../js/jquery-3.6.4.min.js" type="text/javascript"></script>
    <script src="../js/aes.js" type="text/javascript"></script>
    <script src="../js/Report6.js"></script>
    <script src="../js/bulk.js" type="text/javascript"></script>
    <script src="../js/ChangePassword.js" type="text/javascript"></script>
    <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">

        <script type="text/javascript">
            var dataSet = [], ReportUrl = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' + '<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Reports/Service/Service.aspx?",
                EReportUrl = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' + '<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Reports/Service/ServiceFinance.aspx?",
                CryptoKey = '<%=ConfigurationManager.AppSettings["CryptoKey"].ToString() %>',
                CryptoPwd = '<%=ConfigurationManager.AppSettings["CryptoIV"].ToString() %>',
                ConProtocol = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>',
                urlPageValidation = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' + '<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/MasterPage/Service/Service.aspx?",
                RenderAt = 'ChartRenderAt', InnerReport = '1', InnerOption = '1', selDeptIDs = '', PFrom = '', PTo = '', pageSize = 15, pageIndex = 0, OldCatID = 0, ServiceCode = '1', EServiceCode = '', callFrom = 'Parent';
            var ackImgPath1 = "", ackImgPath2 = "", ackImgPath3 = "", ackLoc1 = "", ackLoc2 = "", ackLoc3 = "";




            var width = ($(window).width() * 70) / 100, ChartHeight = '420';

            $(document).ready(function () {
 
                ServiceCode = sessionStorage.getItem('ServiceCode');
                document.getElementById("<%= HFServiceCode.ClientID %>").value = ServiceCode;
                InitChangePassword();
                LoadCategory();
                selectReport('Report7', 'Cat');
                Sfrom = document.getElementById("<%= HFFrom.ClientID %>").value;
                Sto = document.getElementById("<%= HFTo.ClientID %>").value;
                document.getElementById("txtfromdate").value = Sfrom;
                document.getElementById("txttodate").value = Sto;
                //GetReport();


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
                    document.getElementById("<%= HFServiceCode.ClientID %>").value = ServiceCode;
                    $('#divService' + ServiceCode).trigger('click');
                }

                $('.services-btn-icon-modal').click(function () {
                    var Process = (($("#TaskHeader").html() == 'New Task') ? "New" : "Edit");


                    var selServiceCode = $(this).attr('id').replace("divRService", "");

                    if (EServiceCode == selServiceCode) { // Process == 'New' ||
                        var eleParent = $('#divService' + selServiceCode);
                        // Remove 'active' class from all buttons

                        // Add 'active' class to the clicked button
                        ServiceCode = selServiceCode;

                        callFrom = "innerElement";
                        setRequestChanges(selServiceCode, Process);
                        //setRootServices(eleParent);
                        setInnerServices(this);

                        /*$('#divRService' + selServiceCode).addClass('active');
                        // Get the rgb color of the clicked button
                        var rgbColor = $('#divRService' + selServiceCode).data('color');

                        // Convert rgb to rgba by appending the opacity
                        var rgbaColor = rgbColor.replace('rgb', 'rgba').replace(')', ', 0.1)');

                        // Set the new rgba color to the CSS variable
                        $(':root').css('--active-color-modal', rgbColor);
                        $(':root').css('--active-bg-color-modal', rgbaColor);*/
                    }

                });

                $('.services-btn-icon-modal').first().trigger('click');
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
                return false;

            });
            function setRequestChanges(ServiceCode, Process) {

                switch (ServiceCode) {
                    case "1":

                        $('#containerMP').css("display", "inline-block");
                        $('#containerPatient').css("display", "inline-block");
                        $('#divQuantity').css("visibility", "hidden");
                        $('#txtFromLoc').prop("readonly", false);
                        setTimeout(function () { $('#txtFromLoc').focus(); }, 500)

                        $("#suggesstionTo").hide();
                        $('#lblKPITS').html('-');
                        $('#lblKPITE').html('-');
                        $('#containerCat').css('background-color', '#6dadff'); $('#containerKPI').css('background-color', '#6dadff');
                        $('#tdKPICompletion').css('background-color', '#6dadff'); $('#tdKPIResponse').css('background-color', '#6dadff'); $('#parentcontainerMP').css('background-color', '#6dadff');
                        break;
                    case "2":
                        var bgcolor = "#6dadff";
                        $('#containerMP').css("display", "none");
                        $('#containerPatient').css("display", "none");
                        $('#divQuantity').css("visibility", "visible");

                        $("#suggesstionFrom").hide();
                        setTimeout(function () { $('#txtFromLoc').prop("readonly", true); $('#txtToLoc').focus(); }, 500)
                        $('#lblKPITS').html('-');
                        $('#lblKPITE').html('-');
                        $('#containerCat').css('background-color', bgcolor); $('#containerKPI').css('background-color', bgcolor);
                        $('#tdKPICompletion').css('background-color', bgcolor); $('#tdKPIResponse').css('background-color', bgcolor); $('#parentcontainerMP').css('background-color', bgcolor);
                        break;
                }
                if (Process == 'New')
                    LoadCategories('');

            }
            function setRootServices(ele) {
                $('.services-btn-icon').removeClass('active');
                $(ele).addClass('active');
                // Get the rgb color of the clicked button
                var rgbColor = $(ele).data('color'); sessionStorage.setItem('ServiceCode', ServiceCode);

                document.getElementById("<%= HFServiceCode.ClientID %>").value = ServiceCode;
                // Convert rgb to rgba by appending the opacity
                var rgbaColor = rgbColor.replace('rgb', 'rgba').replace(')', ', 0.1)');
                setServiceUpdates(ServiceCode);
             //sen   $(".caterEles").css("visibility", ((ServiceCode == "2") ? "visible" : "hidden"));
                $(".caterEles").css("display", ((ServiceCode == "2") ? "flex" : "none"));
                // Set the new rgba color to the CSS variable
                $(':root').css('--active-color', rgbColor);
                $(':root').css('--active-bg-color', rgbaColor);
            }
            function setInnerServices(ele) {

                $('.services-btn-icon-modal').removeClass('active');
                $(ele).addClass('active');
                // Get the rgb color of the clicked button
                var rgbColor = $(ele).data('color');

                // Convert rgb to rgba by appending the opacity
                var rgbaColor = rgbColor.replace('rgb', 'rgba').replace(')', ', 0.1)');

                // Set the new rgba color to the CSS variable
                $(':root').css('--active-color-modal', rgbColor);
                $(':root').css('--active-bg-color-modal', rgbaColor);
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
                    GetReport();
            }
            function GetReport(sender, args) {
                width = ($(window).width() * 70) / 100, ChartHeight = '420';
                ChartType = $('#ChartType').val();
                Sfrom = document.getElementById("txtfromdate");
                Sto = document.getElementById("txttodate");
                $('#trDatewiseFilters').css("display", "none");
                if (InnerReport == 'Report1')
                    SValidate(false, Sfrom, Sto);
                else if (InnerReport == 'Report2')
                    CValidate(false, Sfrom, Sto);
                else if (InnerReport == 'Report3') {
                    TValidate(false, Sfrom, Sto);
                    return false;
                }
                else if (InnerReport == 'Report4') {
                    width = ($(window).width() * 50) / 100, ChartHeight = '390';
                    PValidate(false, Sfrom, Sto);
                    return false;
                }
                else if (InnerReport == 'Report5') {
                    var fileName = ((InnerOption == "OROption1") ? "General_Response_Overruns" : "General_Duration_Overruns");
                    CSValidate(false, Sfrom, Sto, fileName);
                    return false;
                } else if (InnerReport == 'Report6') {
                    var fileName = "General_Resource_Usage";
                    ResouceUsage(false, Sfrom, Sto, fileName);
                    return false;
                } else if (InnerReport == 'Report7') {
                    $('#trDatewiseFilters').css("display", "table-row");
                    LoadPresetRemarks();
                    Datewise(false, Sfrom, Sto);
                    return false;
                }
                else if (InnerReport == 'Report0') {
                    $('#trDatewiseFilters').css("display", "none");                    
                    LoadPresetRemarks();
                    Datewises(false, Sfrom, Sto);
                    return false;
                }
                return false;
            }

            function BindGrid() {
                $('.loaderElement').css("display", "inline-block");
                PFrom = document.getElementById("txtfromdate").value + "T00:00";
                PTo = document.getElementById("txttodate").value + "T23:59";
                grid = $find('<%= GridPorter.ClientID %>');
                BindGridPorter();
            }

            function BindDateGrid() {
                $('.loaderElement').css("display", "inline-block");
                PFrom = document.getElementById("txtfromdate").value + "T00:00";
                PTo = document.getElementById("txttodate").value + "T23:59";
                grid = $find('<%= GridReport.ClientID %>');
                BindGridDateWise();

            }
            function BindDateGrids() {
                $('.loaderElement').css("display", "inline-block");
                PFrom = document.getElementById("txtfromdate").value + "T00:00";
                PTo = document.getElementById("txttodate").value + "T23:59";
                grid = $find('<%= GridReports.ClientID %>');
                BindGridDateWises();

             }


            function FinaceReport() {
                var Sfrom = document.getElementById("txtfromdate"),
                    Sto = document.getElementById("txttodate");
                ExportFinancialReport(Sfrom, Sto);
            }


            function DetailReport() {
                var Sfrom = document.getElementById("txtfromdate"),
                    Sto = document.getElementById("txttodate");
                ExportDetailReport(Sfrom, Sto);
            }
            function DatValidate() {
                var DStatus = $('#selRequestStatus').val();
                Sfrom = document.getElementById("txtfromdate");
                Sto = document.getElementById("txttodate");
                document.getElementById("<%= HFFrom.ClientID %>").value = Sfrom.value;
                document.getElementById("<%= HFTo.ClientID %>").value = Sto.value;
                document.getElementById("<%= RStatus.ClientID %>").value = DStatus;

                var returnValue = DatewiseValidate();
                if (returnValue) {
                    document.getElementById("<%= HFDWExportHeader.ClientID %>").value = BuildHeader();
                    document.getElementById("<%= HFDWSearchQuery.ClientID %>").value = DWQueryBuilder();
                    ShowModalPopUp("modalAlert");
                    setTimeout('HideModalPopUp("modalAlert");', 3000);
                }
                return returnValue;
            }


            window.addEventListener('DOMContentLoaded', () => {

                document.querySelectorAll('.services-btn-icon').forEach((btn) => {
                    btn.addEventListener('click', function () {
                        document.querySelectorAll('.services-btn-icon.active')
                            .forEach((activeBtn) => activeBtn.classList.remove('active'));

                        this.classList.add('active');

                        ServiceCode = this.id.replace("divService", "");
                        sessionStorage.setItem('ServiceCode', ServiceCode);

                            console.log("Selected service:", ServiceCode);
                    });
                });

                const defaultBtn = document.getElementById('divService1');
                if (defaultBtn) {
                    defaultBtn.click();
                } else {
                    //console.warn("divService1 not found.");
                }
            });


        </script>
    </telerik:RadCodeBlock>
    <style type="text/css">
        .Export {
            position: relative;
            height: 70px;
            width: 140px;
            cursor: pointer
        }


        .ExportOverlay {
            position: absolute;
            bottom: 100%;
            left: 0;
            right: 0;
            background-color: rgb(30, 70, 129);
            overflow: hidden;
            width: 100%;
            height: 0;
            transition: .3s ease !important;
            border-radius: 5px;
        }

        .Export:hover .ExportOverlay {
            bottom: 0;
            height: 100%;
        }
        .valignmid
        {

            vertical-align:middle;
        }

        .ExportText {
            line-height: 1.35;
            color: white;
            font-family: Lucida Console;
            font-size: 12px;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            -ms-transform: translate(-50%, -50%);
        }

        div.polaroid {
            width: 90%;
            background-color: white;
            box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
            margin-bottom: 25px;
        }

        div.container {
            text-align: center;
            padding: 10px 20px;
        }

        .MultiPorter {
            display: block;
            margin-top: 15px;
            margin-left: 15px;
            cursor: pointer;
        }

        legend {
            font-size: 1rem !important;
            color: red !important;
            background: white;
            width: 140px;
            padding: 0px 15px;
            font-weight: bold;
        }

        fieldset {
            border: 1px solid gray;
            padding: 15px;
            width: 100%;
        }

        .form-control {
            background-color: white;
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

        .btnOk {
            color: white !important;
            background-color: #2870ff !important;
        }

        .btnCancel {
            color: black !important;
            background-color: #f5f5f5 !important;
        }

        .RadGrid_Metro .rgHeader, .RadGrid_Metro th.rgResizeCol, .RadGrid_Metro .rgMultiHeaderRow th.rgHeader, .RadGrid_Metro .rgMultiHeaderRow th.rgResizeCol {
            border: 0 !important;
            border-bottom: 0px solid #e5e5e5 !important;
            border-left: 0px solid #e5e5e5 !important;
        }

        table#ctl00_ContentMaster_GridReport_ctl00_Header thead tr th:last-child {
            border-radius: 0 10px 10px 0;
            border: none !important;
        }

        .RadGrid_Metro .rgHeader, .RadGrid_Metro .rgHeader a {
            color: white !important;
            background-color: #0d6efd !important;
            font-family: monospace !important;
            font-size: 14px !important;
            height: 25px !important;
            vertical-align: middle !important;
            border-right: 1px solid #0d6efd !important;
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
            color: white !important;
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

        table#ctl00_ContentMaster_GridReport_ctl00 {
            font-weight: bold;
        }

        .RadGrid_Metro {
            border-color: #ffffff !important;
            border-color: #ffffff !important;
            padding: 15px;
            border-radius: 10px;
        }

        table.ctl00_ContentMaster_GridReport_ctl00_Header thead tr th {
            background: #0d6efd !important;
            text-align: center;
            padding: 15px 20px;
            border-right: 1px solid #2784F4 !important;
            font-size: 12px;
            font-weight: 500;
        }

        .table-wrap table {
            border-radius: 0px;
        }

        .TatExceed {
            background-color: #fce4ec !important;
        }


        .msgContainer {
            border-bottom: 2px dotted gray;
            background-color: #f1f1f1;
            border-radius: 5px 0px;
            padding: 10px;
            margin: 10px 0;
            font-family: monospace;
        }

            .msgContainer::after {
                content: "";
                clear: both;
                display: table;
            }


        .mitigation-right {
            float: right;
            color: gray;
            font-size: 11px;
            margin-right: 10px;
            font-weight: 600;
            color: white;
            background-color: #0a57c7;
            padding: 5px;
            text-decoration: underline;
        }

        .time-right {
            float: right;
            color: gray;
            font-weight: 12px;
            margin-right: 10px;
        }

        .msgUser {
            font-size: 15pt;
            font-weight: bold;
        }

        .table-wrap table th, .table-wrap table td {
            padding: 5px;
        }

        .RadGrid_Metro .rgMasterTable .rgSelectedCell, .RadGrid_Metro .rgSelectedRow {
            color: #fff !important;
            background: #9E9E9E !important;
        }


    </style>
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="scriptMangager" runat="server"></telerik:RadScriptManager>
        <asp:HiddenField ID="HFCancelReqID" runat="server" ClientIDMode="Static" />
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
                                    <img src="../images/hospital.jpg" alt="Hospital">
                                </div>
                                <div class="hospital-title">
                                    <h5>Welcome</h5>
                                   <h6>Queen Alexandra Hospital,</h6>
<p>Cosham, Portsmouth, PO6 3LY</p>
                                </div>
                                <br />
                                <div class="add-task-link" onclick="setNewTask();" style="display: none;">
                                    <a href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#addTask"
                                        class="btn btn-primary">
                                        <img src="../images/memo.png" alt="Add Task">
                                        Add task
                                    </a>
                                </div>
                                <br />
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
                                        <li class="current-menu-item">
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
                    </div>


                    <!-- /Left Panel -->

                    <!-- Right Panel -->
                    <div class="screen-right-panel">
                        <div class="navigation-tabs-wrapper" style="margin-bottom: 1em;">
                            <div class="services-button">
                                <label>Services</label>
                            </div>
                            <div class="services-tabs-wrapper">
                                <div class="services-btn-icon" data-color="rgb(255, 116, 0)" id="divService1">
                                    <img src="../images/porter-icon.svg">
                                    <span>Porter</span>
                                </div> <div class="services-btn-icon active" data-color="rgb(12, 188, 139)" id="divService3">
                                    <img src="../images/cater-icon.png">
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
                                            <h5 style="color: #757575;">Reports</h5>
                                        </td>
                                        <td style="padding: 20px;">
                                            <table style="position: absolute; min-width: 1000px; margin-top: 5px;">
                                                <tr>
                                                     
                                                    <td style="background-repeat: no-repeat; background-position: center;"
                                                        class="InnerReqIcon" valign="middle" align="center" id="Report7" onclick="selectReport('Report7','Cat'); return false;">
                                                        <p class="InnerReqText">
                                                            DATE-WISE
                                                        </p>
                                                    </td>
                                                    <td style="background-repeat: no-repeat; background-position: center;"
                                                        class="InnerReqIcon" valign="middle" align="center" id="Report0" onclick="selectReport('Report0','Cat'); return false;">
                                                        <p class="InnerReqText">
                                                            Porter-Trac
                                                        </p>
                                                    </td>
                                                    <td align="center" valign="middle" style="background-repeat: no-repeat; background-position: center; background-size: 65% 95%;"
                                                        class="InnerReqIcon  SelectReqIcon" id="Report1" onclick="selectReport('Report1','Cat'); return false;">
                                                        <p class="InnerReqText">
                                                            STATUS-WISE
                                                        </p>
                                                    </td>
                                                    <td style="background-repeat: no-repeat; background-position: center; background-size: 85% 100%; display: none"
                                                        class="InnerReqIcon" valign="middle" align="center" id="Report2" onclick="selectReport('Report2','Cat'); return false;">
                                                        <p class="InnerReqText">
                                                            CATEGORY-WISE
                                                        </p>
                                                    </td>
                                                    <td style="background-repeat: no-repeat; background-position: center;"
                                                        class="InnerReqIcon" valign="middle" align="center" id="Report3" onclick="selectReport('Report3','Cat'); return false;">
                                                        <p class="InnerReqText">
                                                            TIME-WISE
                                                        </p>
                                                    </td>
                                                    <td style="background-repeat: no-repeat; background-position: center;"
                                                        class="InnerReqIcon" valign="middle" align="center" id="Report4" onclick="selectReport('Report4','Cat'); return false;">
                                                        <p class="InnerReqText">
                                                            PORTER-WISE
                                                        </p>
                                                    </td>
                                                    <td style="border-radius: 0px 0px 0px 5px; background-repeat: no-repeat; background-position: center;"
                                                        class="InnerReqIcon" valign="middle" align="center" id="Report5" onclick="selectReport('Report5','Cat'); return false;">
                                                        <p class="InnerReqText">
                                                            OVERRUNS
                                                        </p>
                                                    </td>
                                                    <td style="background-repeat: no-repeat; background-position: center;"
                                                        class="InnerReqIcon" valign="middle" align="center" id="Report6" onclick="selectReport('Report6','Cat'); return false;">
                                                        <p class="InnerReqText">
                                                            RESOURCE
                                                            <br />
                                                            USAGE
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>

                                        </td>
                                    </tr>
                                </table>

                            </div>
                            <div class="section-head-right d-flex align-items-center" style="visibility: hidden">

                                <div class="search-wrap shadow w-100">
                                    <div class="search-box">
                                        <form>
                                            <input type="search" maxlength="30" autocomplete="off webauthn" class="form-control">
                                            <input type="submit" value="" class="search-submit">
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <div class="Report-master">
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="table-wrap" style="min-height: 800px;">

                                        <div class="table-responsive" id="tblReports" style="overflow-y: hidden">
                                            <table style='width: 100%;'>
                                                <tr>
                                                    <td align="center">
                                                        <div>
                                                            <table style="margin-left: 100px; width: 95vw;">
                                                                <tr>
                                                                    <td>
                                                                        <asp:HiddenField ID="HFFrom" ClientIDMode="Static" runat="server" />
                                                                        <asp:HiddenField ID="HFTo" ClientIDMode="Static" runat="server" />
                                                                        <asp:HiddenField ID="RStatus" ClientIDMode="Static" runat="server" />
                                                                        <asp:HiddenField ID="HFServiceCode" ClientIDMode="Static" runat="server" />
                                                                        <table cellpadding="10px" cellspacing="10px" style="width: 95%; color: white;">
                                                                            <tbody>

                                                                                <tr style="background-color: white; height: 50px;">
                                                                                    <td colspan="4">
                                                                                        <div class="row" style="margin: 10px 0px;">

                                                                                            <div class="col-md-5">
                                                                                                <div class="row" id="DateFilter">
                                                                                                    <div class="col-md-5">
                                                                                                        <input type="date" id="txtfromdate" style="text-align: center; background: none; outline: none; color: #757575; padding: 4px; border: 1px solid #ddd6d6; font-weight: bold;"
                                                                                                            clientidmode="Static" required />
                                                                                                    </div>
                                                                                                    <div class="col-md-2" align="center">

                                                                                                        <label style="color: #757575; font-weight: bold">-to-</label>
                                                                                                    </div>
                                                                                                    <div class="col-md-5">

                                                                                                        <input type="date" id="txttodate" style="text-align: center; background: none; outline: none; color: #757575; padding: 4px; border: 1px solid #ddd6d6; font-weight: bold;"
                                                                                                            clientidmode="Static" required />
                                                                                                    </div>

                                                                                                </div>
                                                                                                <div class="row" id="divDWDateFilter">

                                                                                                    <div class="col-md-4">
                                                                                                        <div class="row">
                                                                                                            <div class="col-md-2">
                                                                                                                <img src="../images/CNoCheck.png" onclick="setRCheckbyIDDW('chkThisMonth','chkLastMonth','chkThisYear');GetReport(); return false;" width="20px" id="chkThisMonth" class="MultiPorter">
                                                                                                            </div>
                                                                                                            <div class="col-md-10">
                                                                                                                <label style="font-size: 14px; margin: 15px; cursor: pointer" onclick="setRCheckbyIDDW('chkThisMonth','chkLastMonth','chkThisYear');GetReport(); return false;">
                                                                                                                    THIS MONTH
                                                                                                                </label>
                                                                                                            </div>

                                                                                                        </div>
                                                                                                    </div>

                                                                                                    <div class="col-md-4">
                                                                                                        <div class="row">
                                                                                                            <div class="col-md-2">
                                                                                                                <img src="../images/CNoCheck.png" onclick="setRCheckbyIDDW('chkLastMonth','chkThisMonth','chkThisYear');GetReport(); return false;" width="20px" id="chkLastMonth" class="MultiPorter">
                                                                                                            </div>
                                                                                                            <div class="col-md-10">
                                                                                                                <label style="font-size: 14px; margin: 15px; cursor: pointer" onclick="setRCheckbyIDDW('chkLastMonth','chkThisMonth','chkThisYear');GetReport(); return false;">
                                                                                                                    LAST MONTH
                                                                                                                </label>
                                                                                                            </div>

                                                                                                        </div>
                                                                                                    </div>

                                                                                                    <div class="col-md-4">
                                                                                                        <div class="row">
                                                                                                            <div class="col-md-2">
                                                                                                                <img src="../images/CNoCheck.png" onclick="setRCheckbyIDDW('chkThisYear','chkThisMonth','chkLastMonth');GetReport(); return false;" width="20px" id="chkThisYear" class="MultiPorter">
                                                                                                            </div>
                                                                                                            <div class="col-md-10">
                                                                                                                <label style="font-size: 14px; margin: 15px; cursor: pointer" onclick="setRCheckbyIDDW('chkThisYear','chkThisMonth','chkLastMonth');GetReport(); return false;">
                                                                                                                    THIS YEAR
                                                                                                                </label>
                                                                                                            </div>

                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>
                                                                                                <%-- <div class="row">
                                                                                                        <div class="col-md-2">
                                                                                                            <img src="../images/CNoCheck.png" onclick="setRCheckbyID('chkLastMonth','chkThisMonth');GetReport(); return false;" width="20px" id="chkLastMonth" class="MultiPorter">
                                                                                                        </div>
                                                                                                        <div class="col-md-10">
                                                                                                            <label style="font-size: 14px; margin-left: 10px; cursor: pointer" onclick="setRCheckbyID('chkLastMonth','chkThisMonth');GetReport(); return false;">
                                                                                                                LAST MONTH
                                                                                                            </label>
                                                                                                        </div>

                                                                                                    </div>

                                                                                                    <div class="row">
                                                                                                        <div class="col-md-2">
                                                                                                            <img src="../images/CNoCheck.png" onclick="setRCheckbyID('chkThisMonth','chkLastMonth');GetReport(); return false;" width="20px" id="chkThisMonth" class="MultiPorter">
                                                                                                        </div>
                                                                                                        <div class="col-md-10">
                                                                                                            <label style="font-size: 14px; margin-left: 10px; cursor: pointer" onclick="setRCheckbyID('chkThisMonth','chkLastMonth');GetReport(); return false;">
                                                                                                                THIS MONTH
                                                                                                            </label>
                                                                                                        </div>

                                                                                                    </div>--%>
                                                                                            </div>



                                                                                            <div class="col-md-2" id="divChartType">

                                                                                                <select id='ChartType' name="selectFloor" class="form-control search_test"
                                                                                                    onchange='GetReport();return false;'>
                                                                                                    <option value='bar2d'>bar</option>
                                                                                                    <option value='line'>line</option>
                                                                                                    <option value='doughnut3d'>doughnut</option>
                                                                                                    <option value='pie3d'>pie</option>
                                                                                                </select>

                                                                                            </div>

                                                                                            <div class="col-md-2">
                                                                                                <div class="row">

                                                                                                    <div class="col-md-12" id="divselRequestStatus" style="display: none">
                                                                                                        <select id='selRequestStatus' name="selectFloor" class="form-control search_test"
                                                                                                            onchange='BindDateGrid();return false;'>
                                                                                                            <option value='0'>All</option>
                                                                                                            <option value='6'>Completed</option>
                                                                                                            <option value='7'>Cancelled</option>
                                                                                                        </select>
                                                                                                    </div>
                                                                                                </div>
                                                                                                <div class="row" style="visibility:hidden">
                                                                                                    <div class="col-md-4">
                                                                                                        <div class="row">
                                                                                                            <div class="col-md-2">
                                                                                                                <img src="../images/CNoCheck.png" onclick="setHaywoodRSUH('chkRSUH','chkHaywood');GetReport(); return false;" width="20px" id="chkRSUH" class="MultiPorter" style="cursor: pointer; margin-left: -5px;">
                                                                                                            </div>
                                                                                                            <div class="col-md-8">
                                                                                                                <%--<img src="images/Hospital.png" alt="RSUH">--%>
                                                                                                                <label style="font-size: 14px; margin: 15px; cursor: pointer; margin-left: 5px;" onclick="setHaywoodRSUH('chkRSUH','chkHaywood');GetReport(); return false;">
                                                                                                                    RSUH
                                                                                                                </label>
                                                                                                            </div>

                                                                                                        </div>
                                                                                                    </div>
                                                                                                    <div class="col-md-8">
                                                                                                        <div class="row">
                                                                                                            <div class="col-md-2">
                                                                                                                <img src="../images/CNoCheck.png" onclick="setHaywoodRSUH('chkHaywood','chkRSUH');GetReport(); return false;" width="20px" id="chkHaywood" class="MultiPorter" style="cursor: pointer; margin-left: 0px;">
                                                                                                            </div>
                                                                                                            <div class="col-md-10">
                                                                                                                <label style="font-size: 14px; margin: 15px; cursor: pointer; margin-left: 5px;" onclick="setHaywoodRSUH('chkHaywood','chkRSUH');GetReport(); return false;">
                                                                                                                    Haywood
                                                                                                                </label>
                                                                                                            </div>

                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>

                                                                                            </div>
                                                                                            <div class="col-md-3">
                                                                                                <div class="row">
                                                                                                    <div class="col-md-3">
                                                                                                        <asp:ImageButton ID="BBtnSearch" runat="server" ImageUrl="~/Reports/Images/search.PNG"
                                                                                                            OnClientClick="GetReport(); return false;" />

                                                                                                    </div>
                                                                                                    <div class="col-md-4" id="tdRefresh" style="display: none">
                                                                                                        <a href="#" class="btn btn-primary w-100" onclick='RefreshDW(); return false;' style="height: 55px;">
                                                                                                            <img src="../images/refresh.png" alt="Refresh">
                                                                                                            Refresh
                                                                                                        </a>
                                                                                                    </div>
                                                                                                    <div class="col-md-2" id="tdExport" style="display: none; text-align: right;">

                                                                                                        <asp:LinkButton ID="ExportDatewise" runat="server" class="GridHeader" OnClientClick="return DatValidate();"
                                                                                                            OnClick="Export_Datewise">
                                                                                                                    <img src="../images/Exports.PNG" style="max-width:40px">
                                                                                                            <span style="color: #314780 !important;font-weight: bold;font-size: 14px"> Export</span>
                                                                                                        </asp:LinkButton>

                                                                                                    </div>
                                                                                                    
                                                                                                    <div class="col-md-2" id="tdExports" style="display: none; text-align: right;">

                                                                                                        <asp:LinkButton ID="LinkButton12" runat="server" class="GridHeader" OnClientClick="return DatValidate();"
                                                                                                            OnClick="ExportTrack_Datewise">
                                                                                                                    <img src="../images/Exports.PNG" style="max-width:40px">
                                                                                                            <span style="color: #314780 !important;font-weight: bold;font-size: 14px"> Export</span>
                                                                                                        </asp:LinkButton>

                                                                                                    </div>
                                                                                                    <div class="col-md-2 caterEles">
                                                                                                        <div id="Div1" onclick="FinaceReport();return false;" align="center" class="Export"
                                                                                                            style="width: 60px; height: 80px;">
                                                                                                            <img src="../images/Exports.PNG" style="max-width: 40px">
                                                                                                            <span style="color: #314780 !important; font-weight: bold; font-size: 14px">Finace Report</span>
                                                                                                            <div class="ExportOverlay">
                                                                                                                <div class="ExportText">
                                                                                                                    FINANCE REPORT
                                                                                                                </div>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>

                                                                                                    <div class="col-md-2 caterEles">
                                                                                                        <div id="Div2" onclick="DetailReport();return false;" align="center" class="Export"
                                                                                                            style="width: 60px; height: 80px;">
                                                                                                            <img src="../images/Exports.PNG" style="max-width: 40px">
                                                                                                            <span style="color: #314780 !important; font-weight: bold; font-size: 14px">Detailed Report</span>
                                                                                                            <div class="ExportOverlay">
                                                                                                                <div class="ExportText">
                                                                                                                    DETAILED REPORT
                                                                                                                </div>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>

                                                                                                <div class="row caterEles" style="margin-top: 20px;">
                                                                                                    <div class="col-md-4">
                                                                                                        <label style="font-size: 14px; margin: 10px 5px; font-weight: bold;">CHARGE GROUP</label>
                                                                                                    </div>
                                                                                                    <div class="col-md-8">
                                                                                                        <select name="selectFloor" id="search_CatChargeGroup" tabindex="1" class="form-control search_test search_CatChargeGroup" onchange="GetReport();return false;">
                                                                                                            <option value="All" selected>All</option>
                                                                                                            <option value="Non-chargable">Non-chargable</option>
                                                                                                            <option value="Cooked BreakFast">Cooked BreakFast</option>
                                                                                                            <option value="Cultural Requisitions">Cultural Requisitions</option>
                                                                                                            <option value="Gluten Free Requisitions">Gluten Free Requisitions</option>
                                                                                                            <option value="Kosher Requisitions">Kosher Requisitions</option>
                                                                                                            <option value="Renal/Low Potassium Requisitions">Renal/Low Potassium Requisitions</option>
                                                                                                            <option value="Snack Boxes">Snack Boxes</option>
                                                                                                            <option value="Requisitions-Normal via Patient Services">Requisitions-Normal via Patient Services</option>
                                                                                                        </select>

                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>

                                                                                            <%--<div class="col-md-4">
                                                                                                <label>Charge Group</label>
                                                                                            </div>
                                                                                            <div class="col-md-8">
                                                                                                <select name="selectFloor" id="search_CatChargeGroup" tabindex="1" class="form-control search_test search_CatChargeGroup">
                                                                                                    <option value="Non-chargable" selected>Non-chargable</option>
                                                                                                    <option value="Cooked BreakFast">Cooked BreakFast</option>
                                                                                                    <option value="Cultural Requisitions">Cultural Requisitions</option>
                                                                                                    <option value="Gluten Free Requisitions">Gluten Free Requisitions</option>
                                                                                                    <option value="Kosher Requisitions">Kosher Requisitions</option>
                                                                                                    <option value="Renal/Low Potassium Requisitions">Renal/Low Potassium Requisitions</option>
                                                                                                    <option value="Snack Boxes">Snack Boxes</option>
                                                                                                    <option value="Requisitions-Normal via Patient Services">Requisitions-Normal via Patient Services</option>
                                                                                                </select>

                                                                                            </div>--%>
                                                                                        </div>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr id="trDatewiseFilters" style="display: none;">
                                                                                    <td colspan="4">
                                                                                        <div class="row" style="margin-left: -127px;">

                                                                                            <div class="col-md-2">
                                                                                                <fieldset style="height: 195px;">
                                                                                                    <legend style="margin: -25px 0px 25px 15px">Task Filters</legend>


                                                                                                    <div class="row">

                                                                                                        <div class="col-md-12">
                                                                                                            <select name="selectFloor" id="search_TaskFields" tabindex="1" class="form-control search_test" onchange="OnchangeFilter('search_TaskFields','txtSearchTask');return false;">
                                                                                                                <option value="R.REQUESTID" selected>REQ #</option>
                                                                                                                <option value="REQUESTORNAME">Requested By</option>
                                                                                                                <option value="CATEGORYNAME_LONG#CategoryName">Task Type</option>
                                                                                                               
                                                                                                                <option value="[FROM]">From Location</option>
                                                                                                                <option value="[TO]">To Location</option>
                                                                                                                <option value="ZONE_FROM">Zone Name</option>
                                                                                                                <option value="CONTACTNO">Contact No</option>
                                                                                                               
                                                                                                                <option value="PORTERNAME">Porter Name</option>
                                                                                                                 
                                                                                                            </select>
                                                                                                            <div class="search-wrap w-100">
                                                                                                                <div class="search-box">
                                                                                                                    <form>
                                                                                                                        <input type="search" maxlength="30" autocomplete="off webauthn" id="txtSearchTask" class="form-control" style="height: 60px !important;" placeholder="Enter Here">
                                                                                                                        <%--<textarea name="txtSearchTask" rows="1" class="form-control" placeholder="Enter Here" id="txtSearchTask" style="margin-top: 15px;"></textarea>--%>
                                                                                                                        <input type="submit" value="" class="search-submit" onclick="GetReport(); return false;">
                                                                                                                    </form>
                                                                                                                </div>
                                                                                                            </div>

                                                                                                        </div>
                                                                                                        <div class="col-md-12">
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </fieldset>

                                                                                            </div>
                                                                                            <div class="col-md-3">

                                                                                                <fieldset style="height: 195px;">
                                                                                                    <legend style="margin: -25px 0px 25px 15px; width: 200px;">Patient/Notes Filters</legend>
                                                                                                    <div class="row">

                                                                                                        <div class="col-md-12">
                                                                                                            <select name="selectFloor" id="search_PatientRemarks" class="form-control search_test" onchange="OnchangeFilter('search_PatientRemarks','txtSearchPatient');return false;">
                                                                                                                <option value="PATIENTNAME" selected>Name</option>
                                                                                                                <option value="COMPLETEDREMARKS">Task Notes</option>
                                                                                                                <option value="PORTERREMARKS">Porter Remarks</option>
                                                                                                                <option value="REMARKS">Cancel Remarks</option>
                                                                                                                <option value="REQUESTDESKREMARKS">Request Desk Remarks</option>
                                                                                                            </select>
                                                                                                            <div class="search-wrap w-100">
                                                                                                                <div class="search-box">
                                                                                                                    <form>
                                                                                                                        <input type="search" maxlength="30" autocomplete="off webauthn" id="txtSearchPatient" class="form-control" style="height: 60px !important;" placeholder="Enter Here">
                                                                                                                        <input type="submit" value="" class="search-submit" onclick="GetReport(); return false;">
                                                                                                                    </form>
                                                                                                                </div>
                                                                                                            </div>


                                                                                                        </div>
                                                                                                        <div class="col-md-12">
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </fieldset>
                                                                                            </div>

                                                                                            <div class="col-md-5">

                                                                                                <fieldset>
                                                                                                    <legend style="margin: -25px 0px 25px 15px; width: 230px;">Task Actioning Fields</legend>
                                                                                                    <div class="row">
                                                                                                        <div class="col-md-4"  style="display:none">
                                                                                                            <div class="row">
                                                                                                                <div class="col-md-2">
                                                                                                                    <img src="../images/CNoCheck.png" onclick="setRCheckbyID('chkADF','chkADP');GetReport(); return false;" width="20px" id="chkADF" class="MultiPorter">
                                                                                                                </div>
                                                                                                                <div class="col-md-10">
                                                                                                                    <label style="font-size: 14px; margin-left: 10px; cursor: pointer" onclick="setRCheckbyID('chkADF','chkADP');GetReport(); return false;">
                                                                                                                        Allocation  Duration
                                                                                                                        <br />
                                                                                                                        Failed</label>
                                                                                                                </div>
                                                                                                            </div>

                                                                                                        </div>
                                                                                                        <div class="col-md-4">
                                                                                                            <div class="row">
                                                                                                                <div class="col-md-2">
                                                                                                                    <img src="../images/CNoCheck.png" onclick="setRCheckbyID('chkRDF','chkRDP');GetReport(); return false;" width="20px" id="chkRDF" class="MultiPorter">
                                                                                                                </div>
                                                                                                                <div class="col-md-10">
                                                                                                                    <label style="font-size: 14px; margin-left: 10px; cursor: pointer" onclick="setRCheckbyID('chkRDF','chkRDP');GetReport(); return false;">
                                                                                                                        Response Duration<br />
                                                                                                                        Failed</label>
                                                                                                                </div>
                                                                                                            </div>


                                                                                                        </div>
                                                                                                        <div class="col-md-4">
                                                                                                            <div class="row">
                                                                                                                <div class="col-md-2">
                                                                                                                    <img src="../images/CNoCheck.png" onclick="setRCheckbyID('chkCDF','chkCDP');GetReport(); return false;" width="20px" id="chkCDF" class="MultiPorter">
                                                                                                                </div>
                                                                                                                <div class="col-md-10">
                                                                                                                    <label style="font-size: 14px; margin-left: 10px; cursor: pointer" onclick="setRCheckbyID('chkCDF','chkCDP');GetReport(); return false;">
                                                                                                                        Completion Duration
                                                                                                                        <br />
                                                                                                                        Failed</label>
                                                                                                                </div>
                                                                                                            </div>


                                                                                                        </div>
                                                                                                    </div>
                                                                                                    <div class="row">
                                                                                                        <div class="col-md-4"  style="display:none">
                                                                                                            <div class="row">
                                                                                                                <div class="col-md-2">
                                                                                                                    <img src="../images/CNoCheck.png" onclick="setRCheckbyID('chkADP','chkADF');GetReport(); return false;" width="20px" id="chkADP" class="MultiPorter">
                                                                                                                </div>
                                                                                                                <div class="col-md-10">
                                                                                                                    <label style="font-size: 14px; margin-left: 10px; cursor: pointer" onclick="setRCheckbyID('chkADP','chkADF');GetReport(); return false;">
                                                                                                                        Allocation Duration
                                                                                                                        <br />
                                                                                                                        Passed</label>
                                                                                                                </div>
                                                                                                            </div>


                                                                                                        </div>
                                                                                                        <div class="col-md-4">
                                                                                                            <div class="row">
                                                                                                                <div class="col-md-2">
                                                                                                                    <img src="../images/CNoCheck.png" onclick="setRCheckbyID('chkRDP','chkRDF');GetReport(); return false;" width="20px" id="chkRDP" class="MultiPorter">
                                                                                                                </div>
                                                                                                                <div class="col-md-10">
                                                                                                                    <label style="font-size: 14px; margin-left: 10px; cursor: pointer" onclick="setRCheckbyID('chkRDP','chkRDF');GetReport(); return false;">
                                                                                                                        Response Duration
                                                                                                                        <br />
                                                                                                                        Passed</label>
                                                                                                                </div>

                                                                                                            </div>
                                                                                                        </div>
                                                                                                        <div class="col-md-4">
                                                                                                            <div class="row">
                                                                                                                <div class="col-md-2">
                                                                                                                    <img src="../images/CNoCheck.png" onclick="setRCheckbyID('chkCDP','chkCDF');GetReport(); return false;" width="20px" id="chkCDP" class="MultiPorter">
                                                                                                                </div>
                                                                                                                <div class="col-md-10">
                                                                                                                    <label style="font-size: 14px; margin-left: 10px; cursor: pointer" onclick="setRCheckbyID('chkCDP','chkCDF');GetReport(); return false;">
                                                                                                                        Completion Duration
                                                                                                                            <br />
                                                                                                                        Passed</label>
                                                                                                                </div>
                                                                                                            </div>

                                                                                                        </div>
                                                                                                    </div>
                                                                                                    <div class="row">
                                                                                                        <div class="col-md-4">
                                                                                                            <div class="row">
                                                                                                                <div class="col-md-2">
                                                                                                                    <img src="../images/CNoCheck.png" onclick="setRCheckbyID('chkMitigated','chkNotMitigated');GetReport(); return false;" width="20px" id="chkMitigated" class="MultiPorter">
                                                                                                                </div>
                                                                                                                <div class="col-md-10">
                                                                                                                    <label style="font-size: 14px; margin-left: 10px; padding-top: 15px; cursor: pointer;" onclick="setRCheckbyID('chkMitigated','chkNotMitigated');GetReport(); return false;">Mitigated</label>
                                                                                                                </div>
                                                                                                            </div>

                                                                                                        </div>
                                                                                                        <div class="col-md-4">
                                                                                                            <div class="row">
                                                                                                                <div class="col-md-2">
                                                                                                                    <img src="../images/CNoCheck.png" onclick="setRCheckbyID('chkNotMitigated','chkMitigated');GetReport(); return false;" width="20px" id="chkNotMitigated" class="MultiPorter">
                                                                                                                </div>
                                                                                                                <div class="col-md-10">
                                                                                                                    <label style="font-size: 14px; margin-left: 10px; padding-top: 15px; cursor: pointer;" onclick="setRCheckbyID('chkNotMitigated','chkMitigated');GetReport(); return false;">Not Mitigated</label>
                                                                                                                </div>
                                                                                                            </div>

                                                                                                        </div>

                                                                                                        <div class="col-md-4">
                                                                                                            <div class="row">
                                                                                                                <div class="col-md-2">
                                                                                                                    <img src="../images/CNoCheck.png" onclick="setRCheckbyID('chkCRDF','chkCDF','chkRDF');GetReport(); return false;" width="20px" id="chkCRDF" class="MultiPorter">
                                                                                                                </div>
                                                                                                                <div class="col-md-10">
                                                                                                                    <label style="font-size: 14px; margin-left: 10px; cursor: pointer" onclick="setRCheckbyID('chkCRDF','chkCDF','chkRDF');GetReport(); return false;">
                                                                                                                        Completion/Response Duration
                                                                                                                        <br />
                                                                                                                        Failed</label>
                                                                                                                </div>
                                                                                                            </div>


                                                                                                        </div>
                                                                                                    </div>
                                                                                                </fieldset>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="row" style="display: none">
                                                                                            <div class="col-md-5">
                                                                                                <div class="row">
                                                                                                    <div class="col-md-3" align="center" style="padding-top: 17px;">
                                                                                                        <img src="../images/NoMCheck.jpg" id="chkMitigationIcon" style="width: 20px; cursor: pointer;" onclick="setCheckbyID('chkMitigationIcon');GetReport(); return false;">
                                                                                                    </div>
                                                                                                    <div class="col-md-9 mb-3" align="center" style="margin-top: 10px; margin-bottom: 3px !important;">
                                                                                                        <label style="font-weight: 600; text-decoration: underline; cursor: pointer; padding: 5px;"
                                                                                                            onclick="setCheckbyID('chkMitigationIcon');GetReport(); return false;">
                                                                                                            With Mitigation notes
                                                                                                        </label>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                            <div class="col-md-1"></div>
                                                                                            <div class="col-md-3">
                                                                                                <div class="row">
                                                                                                    <div class="col-md-3" align="center" style="padding-top: 17px;">
                                                                                                        <img src="../images/NoMCheck.jpg" id="chkKPIFailed" style="width: 20px; cursor: pointer;" onclick="setCheck(this);GetReport(); return false;">
                                                                                                    </div>
                                                                                                    <div class="col-md-9 mb-3" align="center" style="margin-top: 10px; margin-bottom: 3px !important;">
                                                                                                        <label style="font-weight: 600; text-decoration: underline; cursor: pointer; padding: 5px;"
                                                                                                            onclick="setCheckbyID('chkKPIFailed');GetReport(); return false;">
                                                                                                            KPI Failed
                                                                                                        </label>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                            <div class="col-md-2"></div>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td colspan="2"></td>
                                                                                </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr style="padding-top: 30px; vertical-align: top;">
                                                    <td align="center" style="padding-top: 10px;">
                                                        <div align="center">
                                                            <table cellpadding="5" cellspacing="5" width="100%">
                                                                <tr id="trCatOptions" style="position: absolute; margin-top: -56px;">

                                                                    <td colspan='2' align="center" style="z-index: 1000; padding: 5px 0px 5px 0px; border-top: none; border-radius: 5px;">
                                                                        <table width='700px' style="border-collapse: separate; display: none; margin-top: 20px;" id="tblCatOptions">
                                                                            <tr>
                                                                                <td class="ChartOption" id="Option1" onclick="selectOption('Option1','Cat'); return false;">
                                                                                    <span>COUNT</span>
                                                                                </td>
                                                                                <td class="ChartOption" id="Option2" onclick="selectOption('Option2','Cat'); return false;">
                                                                                    <span>REQ - ASSIGN
                                                                                    <br />
                                                                                        (AVG-TIME)</span>
                                                                                </td>
                                                                                <td class="ChartOption" id="Option3" onclick="selectOption('Option3','Cat'); return false;">
                                                                                    <span>ASSIGN - START<br />
                                                                                        (AVG-TIME) </span>
                                                                                </td>
                                                                                <td class="ChartOption" id="Option4" onclick="selectOption('Option4','Cat'); return false;">
                                                                                    <span>START- END
                                                                                    <br />
                                                                                        AVG-TIME)</span>
                                                                                </td>
                                                                                <td class="ChartOption" id="Option5" onclick="selectOption('Option5','Cat'); return false;">
                                                                                    <span>REQUEST - END<br />
                                                                                        (AVG-TIME)</span>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <table width='700px' style="border-collapse: separate; margin-top: 20px; margin-left: -20px; display: none;" id="tblTimeOptions">
                                                                            <tr>
                                                                                <td class="ChartOption" id="TOption1" onclick="selectOption('TOption1','Time'); return false;">
                                                                                    <span>PEAK HOUR</span>
                                                                                </td>
                                                                                <td class="ChartOption" id="TOption2" onclick="selectOption('TOption2','Time'); return false;">
                                                                                    <span>REQ - ASSIGN
                                                                                    <br />
                                                                                        (AVG-TIME)</span>
                                                                                </td>
                                                                                <td class="ChartOption" id="TOption3" onclick="selectOption('TOption3','Time'); return false;">
                                                                                    <span>ASSIGN - START<br />
                                                                                        (AVG-TIME) </span>
                                                                                </td>
                                                                                <td style="vertical-align: middle; width: 160px">
                                                                                    <table cellspacing='5' cellpadding='5' style="color: #757575; width: 150px; font-family: monospace; font-weight: bold; position: absolute; margin-top: -20px">
                                                                                        <tr>
                                                                                            <td>
                                                                                                <span>CATEGORY </span>
                                                                                            </td>
                                                                                            <td valign="middle" style="vertical-align: middle">
                                                                                                <select id='DrpCategory' style="width: 120px; height: 30px; font-family: monospace; background-color: #ffffff; color: #757575; border: 1px solid #ded6d6; border-radius: 5px; padding: 5px; font-weight: bold;"
                                                                                                    onchange='GetReport();return false;'>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <table width='700px' style="border-collapse: separate; margin-top: 20px; margin-left: -20px; display: none;" id="tblPorterOptions">
                                                                            <tr>
                                                                                <td class="ChartOption" id="POption1" onclick="selectOption('POption1','Porter'); return false;">
                                                                                    <span>PEAK HOUR</span>
                                                                                </td>
                                                                                <td class="ChartOption" id="POption2" onclick="selectOption('POption2','Porter'); return false;">
                                                                                    <span>PERFORMANCE
                                                                                    <br />
                                                                                        (SLOT-WISE)</span>
                                                                                </td>
                                                                                <td class="ChartOption" id="POption3" onclick="selectOption('POption3','Porter'); return false;">
                                                                                    <span>CATEGORY-WISE</span>
                                                                                </td>
                                                                                <td class="ChartOption" id="POption4" onclick="selectOption('POption4','Porter'); return false;">
                                                                                    <span>PERFORMANCE<br />
                                                                                        (CATEGORY-WISE) </span>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                        <table width='300px' style="border-collapse: separate; margin-left: -20px; display: none;" id="tblOROptions">
                                                                            <tr>
                                                                                <td class="ChartOption" id="OROption1" onclick="selectOption('OROption1','OR'); return false;">
                                                                                    <span>RESPONSE
                                                                                        <br />
                                                                                        OVERRUN</span>
                                                                                </td>
                                                                                <td class="ChartOption" id="OROption2" onclick="selectOption('OROption2','OR'); return false;">
                                                                                    <span>DURATION
                                                                                    <br />
                                                                                        OVERRUN</span>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr id="ChartDept">
                                                                    <td valign="top" id="tdGridPorter" style="display: none">
                                                                        <div id="DivPorter" style="min-width: 440px; display: inline-block; margin-top: 20px;">
                                                                            <telerik:RadGrid ID="GridPorter" runat="server" AllowSorting="false" AutoGenerateColumns="false"
                                                                                Style="height: 390px; width: 440px; background-color: #ffffff;" Skin="Metro">
                                                                                <HeaderStyle HorizontalAlign="Center" />
                                                                                <ItemStyle CssClass="ReportFont" HorizontalAlign="Center" />
                                                                                <AlternatingItemStyle CssClass="ReportFont" HorizontalAlign="Center" />
                                                                                <ClientSettings EnableRowHoverStyle="true">
                                                                                    <Selecting AllowRowSelect="true" />
                                                                                    <ClientEvents OnRowClick="RowSelecting" />
                                                                                    <Scrolling AllowScroll="true" UseStaticHeaders="true" ScrollHeight="380"></Scrolling>
                                                                                </ClientSettings>
                                                                                <MasterTableView ClientDataKeyNames="ID,PORTERNAME,COUNT,EMPLOYEEID" NoMasterRecordsText="Please wait..">
                                                                                    <Columns>
                                                                                        <telerik:GridBoundColumn UniqueName="PORTERNAME" HeaderText="PORTER NAME" DataField="PORTERNAME">
                                                                                            <HeaderStyle HorizontalAlign="Center" Width="200px" Font-Bold="true" />
                                                                                        </telerik:GridBoundColumn>

                                                                                        <telerik:GridBoundColumn UniqueName="COUNT" HeaderText="REQUEST COUNT" DataField="COUNT">
                                                                                            <HeaderStyle HorizontalAlign="Center" Font-Bold="true" />
                                                                                        </telerik:GridBoundColumn>
                                                                                    </Columns>
                                                                                </MasterTableView>
                                                                            </telerik:RadGrid>
                                                                        </div>
                                                                    </td>

                                                                    <td align="center" width="100%" style="padding-top: 30px;">
                                                                        <div id="ChartRenderAt">
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr id="tdDatewises" style="display: none">
                                                                    <td colspan="2">
                                                                        <div class="row" style="height: 1px">
                                                                            <div class="col-md-1" align="right">
                                                                            </div>
                                                                            <div class="col-md-2">
                                                                                <span style="position: absolute; margin-top: -6px;">Total Count : <span id="spanRequestCounts" style="font-weight: bold">0</span></span>
                                                                            </div>
                                                                        </div>
                                                                        <telerik:RadGrid ID="GridReports" runat="server" AllowPaging="true" AutoGenerateColumns="false"
                                                                            Style="min-height: 800px; background-color: White; margin-top: -30px;" Skin="Metro">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <PagerStyle AlwaysVisible="true" Position="Top"></PagerStyle>
                                                                            <ItemStyle CssClass="ReportFont" HorizontalAlign="Center" />
                                                                            <AlternatingItemStyle CssClass="ReportFont" HorizontalAlign="Center" />
                                                                            <ClientSettings>
                                                                                <Scrolling AllowScroll="true" UseStaticHeaders="true" ScrollHeight="780px"></Scrolling>
                                                                             <ClientEvents  OnCommand="GridEquans_Command" />     
                                                                            </ClientSettings>
                                                                            <MasterTableView  
                                                                                NoMasterRecordsText="NO REQUEST FOUND." TableLayout="Fixed" PageSize="15">
                                                                                <Columns>

                                                                                    <telerik:GridBoundColumn HeaderText="DIVISION" DataField="DIVISION" UniqueName="DIVISION">
                                                                                        <HeaderStyle Width="200px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="STATUS" DataField="REQUESTSTATUS" UniqueName="REQUESTSTATUS">
                                                                                        <HeaderStyle Width="160px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="REF NO." DataField="REQUESTID" UniqueName="REQUESTID">
                                                                                        <HeaderStyle Width="150px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="TASK TYPE" DataField="CATEGORYNAME" UniqueName="CATEGORYNAME">
                                                                                        <HeaderStyle Width="160px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="URGENT" DataField="URGENT" UniqueName="URGENT">
                                                                                        <HeaderStyle Width="150px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="CATEGORY" DataField="CATEGORY" UniqueName="CATEGORY">
                                                                                        <HeaderStyle Width="160px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="ZONE FROM" DataField="ZONE_FROM" UniqueName="ZONE_FROM">
                                                                                        <HeaderStyle Width="150px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="LOCATION FROM" DataField="FROM" UniqueName="FROM">
                                                                                        <HeaderStyle Width="160px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="ZONE TO" DataField="ZONE_TO" UniqueName="ZONE_TO">
                                                                                        <HeaderStyle Width="150px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="LOCATION TO" DataField="TO" UniqueName="TO">
                                                                                        <HeaderStyle Width="160px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="PORTER REMARKS" DataField="PORTERREMARKS" UniqueName="PORTERREMARKS">
                                                                                        <HeaderStyle Width="160px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="DESPATCHER" DataField="ENTEREDBY" UniqueName="ENTEREDBY">
                                                                                        <HeaderStyle Width="150px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="PORTER" DataField="PORTERNAME" UniqueName="PORTERNAME">
                                                                                        <HeaderStyle Width="160px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="ASSISTANT" DataField="ASSISTANT" UniqueName="ASSISTANT">
                                                                                        <HeaderStyle Width="150px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="BOOKED TIME" DataField="BOOKEDAT" UniqueName="BOOKEDAT">
                                                                                        <HeaderStyle Width="160px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="CREATED TIME" DataField="REQUESTTIME" UniqueName="REQUESTTIME">
                                                                                        <HeaderStyle Width="150px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="RESPONDED TIME" DataField="ASSIGNEDTIME" UniqueName="ASSIGNEDTIME">
                                                                                        <HeaderStyle Width="160px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="STARTED TIME" DataField="STARTTIME" UniqueName="STARTTIME">
                                                                                        <HeaderStyle Width="150px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="COMPLETED TIME" DataField="ENDTIME" UniqueName="ENDTIME">
                                                                                        <HeaderStyle Width="160px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="TOTAL HOLD" DataField="TOTAL_HOLD" UniqueName="TOTAL_HOLD">
                                                                                        <HeaderStyle Width="150px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="RESPONSE HOLD" DataField="RESPONSE_HOLD" UniqueName="RESPONSE_HOLD">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="START HOLD" DataField="START_HOLD" UniqueName="START_HOLD">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="DURATION HOLD" DataField="DURATION_HOLD" UniqueName="DURATION_HOLD">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="RESPONSE DURATION" DataField="RESPONSE_DURATION" UniqueName="RESPONSE_DURATION">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="START DURATION" DataField="START_DURATION" UniqueName="START_DURATION">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="START TARGET" DataField="START_TARGET" UniqueName="START_TARGET">
                                                                                        <HeaderStyle Width="150px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="START OUTCOME" DataField="START_OUTCOME" UniqueName="START_OUTCOME">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="RESPONSESTART DURATION" DataField="RESPONSESTART_DURATION" UniqueName="RESPONSESTART_DURATION">
                                                                                        <HeaderStyle Width="150px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="RESPONSESTART TARGET" DataField="RESPONSESTART_TARGET" UniqueName="RESPONSESTART_TARGET">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="RESPONSESTART OUTCOME" DataField="RESPONSESTART_OUTCOME" UniqueName="RESPONSESTART_OUTCOME">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                     <telerik:GridBoundColumn HeaderText="ONTASK DURATION" DataField="ONTASK_DURATION" UniqueName="ONTASK_DURATION">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                     <telerik:GridBoundColumn HeaderText="ONTASK TARGET" DataField="ONTASK_TARGET" UniqueName="ONTASK_TARGET">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                     <telerik:GridBoundColumn HeaderText="ONTASK OUTCOME" DataField="ONTASK_OUTCOME" UniqueName="ONTASK_OUTCOME">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                     <telerik:GridBoundColumn HeaderText="RESPONSE FAILURE" DataField="RESPONSEFAILURE" UniqueName="RESPONSEFAILURE">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                     <telerik:GridBoundColumn HeaderText="STARTFAILURE" DataField="STARTFAILURE" UniqueName="STARTFAILURE">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                     <telerik:GridBoundColumn HeaderText="DURATION FAILURE" DataField="DURATIONFAILURE" UniqueName="DURATIONFAILURE">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                     <telerik:GridBoundColumn HeaderText="Hold Reason(s)" DataField="HoldReasons" UniqueName="HoldReasons">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                      <telerik:GridBoundColumn HeaderText="CANCEL REMARK" DataField="CANCELREMARK" UniqueName="CANCELREMARK">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                </Columns>
                                                                            </MasterTableView>
                                                                        </telerik:RadGrid>
                                                                    </td>
                                                                </tr>
                                                                <tr id="tdDatewise" style="display: none">
                                                                    <td colspan="2">
                                                                        <div class="row" style="height: 1px">
                                                                            <div class="col-md-3" align="right">
                                                                            </div>
                                                                            <div class="col-md-2">
                                                                                <span style="position: absolute; margin-top: -6px;">Total Count : <span id="spanRequestCount" style="font-weight: bold">0</span></span>
                                                                            </div>
                                                                        </div>
                                                                        <telerik:RadGrid ID="GridReport" runat="server" AllowPaging="true" AutoGenerateColumns="false"
                                                                            Style="min-height: 800px; background-color: White; margin-top: -30px;" Skin="Metro">
                                                                            <HeaderStyle HorizontalAlign="Center" />
                                                                            <PagerStyle AlwaysVisible="true" Position="Top"></PagerStyle>
                                                                            <ItemStyle CssClass="ReportFont" HorizontalAlign="Center" />
                                                                            <AlternatingItemStyle CssClass="ReportFont" HorizontalAlign="Center" />
                                                                            <ClientSettings>
                                                                                <Scrolling AllowScroll="true" UseStaticHeaders="true" ScrollHeight="780px"></Scrolling>
                                                                                <ClientEvents OnRowDataBound="GridDateWise_RowDataBound" OnCommand="GridDateWise_Command" />
                                                                            </ClientSettings>
                                                                            <MasterTableView ClientDataKeyNames="ROW_NO,REQUESTNO,REQUESTID,REQUESTSTATUSID,REQUESTLOCATIONID,DESTINATIONLOCATIONID,CATEGORYID,USERID,PORTERID,SUBPORTERID,CATEGORYNAME,FROM,TO,REQUESTDATE,REQUESTTIME,ASSIGNEDTIME,
                                                                                                                STARTTIME,ENDTIME,TAT,TTAT,MULTITASKFLAG,PRIORITY,PORTERREMARKS,REQUESTSTATUS,REQUESTORNAME,PORTERNAME,ISMULTIPORTER,REMARKS,ISADHOC,PATIENTID,REQUESTDESKREMARKS,PATIENTNAME,CANCELLEDAT,
                                                                                                                COMPLETEDREMARKS,ISRETURNREQUIRED,RETURNREQUESTOF,TATEXCEEDED,VIC, CONTACTNO,MULTITASKINDEX, QUANTITY,USER,LOGS,BOOKEDAT,ENTEREDBY,
                                                                                                                ACKSIGN,ACKPHOTO,ACKPHOTOTIMESTAMP,SERVICEID, KITCHEN,ACKNAME,ACKCONTACT,ACKLOCATION,CLEANINGZONENAME,CLEANINGNOTES,STARTDATE,ENDDATE,
                                                                                                                AUTHORISER,ACKPHOTO2,ACKPHOTOTIMESTAMP2,ACKLOCSTAMP2,ACKPHOTO3,ACKPHOTOTIMESTAMP3,ACKLOCSTAMP3,CLEAN_FEEDBACKMAIL,CLEAN_DAILYMAIL,BC_REQID"
                                                                                NoMasterRecordsText="NO REQUEST FOUND." TableLayout="Fixed" PageSize="15">
                                                                                <Columns>

                                                                                    <telerik:GridBoundColumn HeaderText="DATE" DataField="REQUESTDATE" UniqueName="REQUESTDATE">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="REQ #" DataField="REQUESTNO" UniqueName="REQUESTNO">
                                                                                        <HeaderStyle Width="60px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridTemplateColumn UniqueName="COMPLETEREMARKS" HeaderText="NOTES">
                                                                                        <HeaderStyle Width="130px" />
                                                                                        <ClientItemTemplate>
                                                                  
                                                                                        </ClientItemTemplate>
                                                                                    </telerik:GridTemplateColumn>
                                                                                    <telerik:GridTemplateColumn UniqueName="LOGS" HeaderText="LOGS">
                                                                                        <HeaderStyle Width="130px" />
                                                                                        <ClientItemTemplate>
                                                                  
                                                                                        </ClientItemTemplate>
                                                                                    </telerik:GridTemplateColumn>

                                                                                    <telerik:GridTemplateColumn HeaderText="ACK.<BR/> SIGN" UniqueName="ACKSIGN">
                                                                                        <HeaderStyle Width="100px" />
                                                                                        <ClientItemTemplate>
                                                                                        </ClientItemTemplate>
                                                                                    </telerik:GridTemplateColumn>

                                                                                    <telerik:GridTemplateColumn HeaderText="ACK.<BR/>PHOTO" UniqueName="ACKPHOTO">
                                                                                        <HeaderStyle Width="100px" />
                                                                                        <ClientItemTemplate>
                                                                                        </ClientItemTemplate>
                                                                                    </telerik:GridTemplateColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="BOOKED ON" DataField="BOOKEDAT" UniqueName="BOOKEDAT">
                                                                                        <HeaderStyle Width="80px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="REQ <br/> TIME" DataField="REQUESTTIME" UniqueName="REQUESTTIME">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                      <telerik:GridBoundColumn HeaderText="REQUEST STATUS" DataField="REQUESTSTATUS" UniqueName="REQUESTSTATUS">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="PORTER(S)" DataField="PORTERNAME" UniqueName="PORTERNAME">
                                                                                        <HeaderStyle Width="120px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="ASSIGNED <br/> TIME" DataField="ASSIGNEDTIME" UniqueName="ASSIGNEDTIME">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="RE-ASSIGNED <br/> TIME" DataField="ASSIGNEDTIME1" UniqueName="ASSIGNEDTIME1">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="ASSIGNED <br/> LOCATION" DataField="ASSIGNEDLOCATION" UniqueName="ASSIGNEDLOCATION" Display="false">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="ASSIGN. LOC <br/> TIMESTAMP" DataField="ASSIGNEDLOCATIONTIMESTAMP" UniqueName="ASSIGNEDLOCATIONTIMESTAMP" Display="false">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="START <br/> TIME" DataField="STARTTIME" UniqueName="STARTTIME">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="RE-STARTED <br/> TIME" DataField="STARTTIME1" UniqueName="STARTTIME1">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="STARTED <br/> AT" DataField="STARTLOCATION" UniqueName="STARTLOCATION" Display="false">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="STARTED. LOC <br/> TIMESTAMP" DataField="STARTLOCATIONTIMESTAMP" UniqueName="STARTLOCATIONTIMESTAMP" Display="false">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>


                                                                                    <telerik:GridBoundColumn HeaderText="END <br/> TIME" DataField="ENDTIME" UniqueName="ENDTIME">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="COMPLETED <br/> AT" DataField="ENDLOCATION" UniqueName="ENDLOCATION" Display="false">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="COMPLETED. LOC <br/> TIMESTAMP" DataField="ENDLOCATIONTIMESTAMP" UniqueName="ENDLOCATIONTIMESTAMP" Display="false">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>



                                                                                    <telerik:GridBoundColumn HeaderText="RESPONSE TIME<br/>(Request to Start)" DataField="RSTIME" UniqueName="RSTIME">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="TAT(Start to End)<br/>  (MIN)" DataField="TAT" UniqueName="TAT">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="TAT(Request to End)<br/>  (MIN)" DataField="TTAT" UniqueName="TTAT">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="SITE" DataField="Site" UniqueName="Site">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="FROM" DataField="FROM" UniqueName="FROM">
                                                                                        <HeaderStyle Width="200px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="TO" DataField="TO" UniqueName="TO">
                                                                                        <HeaderStyle Width="200px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="FROM ZONE" DataField="ZONE_FROM" UniqueName="ZONE_FROM"><HeaderStyle Width="150px" />
</telerik:GridBoundColumn>

<telerik:GridBoundColumn HeaderText="TO ZONE" DataField="ZONE_TO" UniqueName="ZONE_TO"><HeaderStyle Width="150px" />
</telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="TASK TYPE" DataField="CATEGORYNAME" UniqueName="CATEGORYNAME">
                                                                                        <HeaderStyle Width="120px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="CHARGE GROUP" DataField="CHARGEGROUP" UniqueName="CHARGEGROUP">
                                                                                        <HeaderStyle Width="120px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="KPI REFERENCE" DataField="KPI_Reference" UniqueName="KPI_Reference">
                                                                                        <HeaderStyle Width="120px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="QUANTITY" DataField="QUANTITY" UniqueName="QUANTITY">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="REQUESTED BY" DataField="REQUESTORNAME" UniqueName="REQUESTORNAME">
                                                                                        <HeaderStyle Width="130px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="ENTERED BY" DataField="ENTEREDBY" UniqueName="ENTEREDBY">
                                                                                        <HeaderStyle Width="130px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="REMARKS" DataField="REQUESTDESKREMARKS" UniqueName="REMARKS">
                                                                                        <HeaderStyle Width="160px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="PORTER REMARKS" DataField="PORTERREMARKS" UniqueName="PORTERREMARKS">
                                                                                        <HeaderStyle Width="160px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    
                                                                                    <telerik:GridBoundColumn HeaderText="KPI met" DataField="KPIMET" UniqueName="KPIMET">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText=" KPI RESPONSE<br/> met" DataField="KPIRESPONSEMET" UniqueName="KPIRESPONSEMET">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText=" KPI COMPLETION <br/>met" DataField="KPICOMPLETIONMET" UniqueName="KPICOMPLETIONMET">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="PATIENT<br/> NAME" DataField="PATIENTNAME" UniqueName="PATIENTNAME">
                                                                                        <HeaderStyle Width="130px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="CONTACT<br/>  NO." DataField="CONTACTNO" UniqueName="CONTACTNO">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="CANCEL <BR\> REASON" DataField="REMARKS" UniqueName="CANCELREMARKS">
                                                                                        <HeaderStyle Width="200px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="CANCELLED<br/>  TIME" DataField="CANCELLEDAT" UniqueName="CANCELLEDAT">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="ACK.<br/> TIME STAMP" DataField="ACKPHOTOTIMESTAMP" UniqueName="ACKPHOTOTIMESTAMP">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="ACK.<br/> BY" DataField="ACKNAME" UniqueName="ACKNAME">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="ACK.<br/> CONTACT" DataField="ACKCONTACT" UniqueName="ACKCONTACT">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="ACK.<br/> LOCATION" DataField="ACKLOCATION" UniqueName="ACKLOCATION">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>

                                                                                    <telerik:GridBoundColumn HeaderText="CANCELLED<br/>  BY" DataField="UPDATEDBY" UniqueName="UPDATEDBY">
                                                                                        <HeaderStyle Width="100px" />
                                                                                    </telerik:GridBoundColumn>
                                                                                    <telerik:GridBoundColumn HeaderText="REMARKS" DataField="REQUESTDESKREMARKS" UniqueName="REQUESTDESKREMARKS"><HeaderStyle Width="100px" />
</telerik:GridBoundColumn>

                                                                                </Columns>
                                                                            </MasterTableView>
                                                                        </telerik:RadGrid>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /Right Panel -->

                    <div class="loaderElement" style="display: none">
                        <div class="loader-spinner"></div>
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


        <div class="modal fade addTask" id="addTask" data-backdrop="static" tabindex="-1" aria-labelledby="addTaskLabel" aria-hidden="true">
            <div class="modal-dialog modal-xx2">
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
                            <div class="form-wrap me-4" style="display:none">
                                <div class=" align-items-center justify-content-between mb-5">
                                    <%--d-flex--%>
                                    <div class="addtask-header row">
                                        <div class="col-md-6">
                                            <h5><span id="TaskHeader"></span></h5>
                                        </div>
                                        <div class="col-md-6 text-with-btn">
                                            <h5><span id="ReqUserLogin" <%-- style="margin-left: 20px; font-size: 19px;"--%>></span></h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                                <img src="../images/close-white.svg">
                                            </button>
                                        </div>
                                    </div>

                                    <%--<div style="font-family: monospace;" class="row">
                                        <div class="col-md-4">
                                            <h5><span id="TaskHeader"></span></h5>
                                        </div>
                                        <div class="col-md-6" style="text-align: right;">
                                            <h5><span id="ReqUserLogin" style="margin-left: 20px; font-size: 19px;"></span></h5>
                                        </div>
                                        <div class="col-md-2" style="text-align: center;">
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                                <img src="../images/close-white.svg">
                                            </button>
                                        </div>
                                    </div>--%>
                                    <%--<h5 style="font-family: monospace; width: 700px;"><span id="TaskHeader"></span><span id="ReqUserLogin" style="margin-left: 200px; font-size: 19px;"></span></h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                        <img src="../images/close-white.svg">
                                    </button>--%>
                                </div>

                                <div class="navigation-tabs-wrapper-modal mb-0 p-0">
                                    <div class="services-button-modal">
                                        <label>Services</label>
                                    </div>
                                    <div class="services-tabs-wrapper-modal">
                                        <div class="services-btn-icon-modal" data-color="rgb(255, 116, 0)" id="divRService1">
                                            <img src="../images/porter-icon.svg" />
                                            <span>Porter</span>
                                        </div>
                                        <div class="services-btn-icon-modal" data-color="rgb(12, 188, 139)" id="divRService2">
                                            <img src="../images/cater-icon.svg" />
                                            <span>Cater</span>
                                        </div>
                                        <div class="services-btn-icon-modal" data-color="rgb(110, 48, 243)" id="divRService3">
                                            <img src="../images/clean-icon.svg" />
                                            <span>Clean</span>
                                        </div>
                                        <div class="services-btn-icon-modal" data-color="rgb(255, 87, 51)" id="divRService4">
                                            <img src="../images/pest-icon.svg" />
                                            <span>Feedback</span>
                                        </div>
                                        <div class="services-btn-icon-modal" data-color="rgb(255, 87, 51)" id="divRService5">
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

                                        <div class="col-md-12" id="containerCat" style="background-color: #6dadff; padding: 25px 25px 10px 25px; margin-top: 30px; min-height: 325px;">
                                            <div class="row mb-2 align-items-center search-bar-modal justify-content-between" style="padding: 10px;">
                                                <div class="col-md-2">
                                                    <label>Task Type</label>
                                                </div>
                                                <div class="col-md-6">
                                                </div>

                                                <div class="col-md-3">
                                                    <div class="d-flex gap-2 align-items-center" id="divQuantity">
                                                        <label class="mb-0">Quantity <span style="font-size: 11px">(optional)</span></label>
                                                        <input type="number" max="5" min="0" name="txtQty" class="form-control" placeholder="" id="txtQty" value="1" />
                                                    </div>
                                                </div>

                                            </div>
                                            <div class="icon-section" id="ReqCategories">
                                            </div>
                                        </div>


                                        <div class="col-md-8" id="containerKPI" style="background-color: #84abf9; padding-bottom: 10px;">
                                            <table style="height: 74px; /*position: absolute; */ background: white; width: 470px; margin-bottom: -15px;" cellpadding="8px">

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
                                            <table style="width: 100%; margin-top: 35px;" id="containerMP">
                                                <tr>
                                                    <td>
                                                        <div align="right">
                                                            <table style="background-color: white; margin-bottom: -1px; border-radius: 5px 5px 0px 0px;">
                                                                <tr>
                                                                    <td style="padding-left: 10px; padding-top: 10px;">
                                                                        <label>Two Porters</label></td>
                                                                    <td style="padding-left: 20px; padding-right: 10px;">
                                                                        <label class="switch">
                                                                            <input type="checkbox" id="chkMultiPorter">
                                                                            <span class="slider round"></span>
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

                                    </div>
                                    <div class="col"></div>
                                </form>
                            </div>

                            <div class="custom-calendar-wrap">

                                <div class="RequestIcons" style="padding: 20px">


                                    <div class="col-md-12" id="containerRequestor" style="">
                                        <div class="mb-3">
                                             <div class="modal-body" id="taskDetailsContent">
              </div>
                        <p><strong>Request Id:</strong> <span id="spanEReqId"></span></p>
                           <p><strong>Request Date:</strong> <span id="spanRequestdate"></span></p>
                         <p><strong>Category Name:</strong> <span id="CATEGORYNAME"></span></p>
                        <p><strong>Remarks:</strong> <span id="RequestDeskRemarks"></span></p>
                        <p><strong>From:</strong> <span id="FROM"></span></p>
                        <p><strong>To:</strong> <span id="TO"></span></p>
                        <p><strong>Requestor:</strong> <span id="REQUESTORNAME"></span></p>
                        <p><strong>Equipment Name:</strong> <span id="EquipmentName"></span></p>
                        <p><strong>Porter Description:</strong> <span id="IsMultiPorterDescription"></span></p>
                        <p><strong>Porter:</strong> <span id="PORTERNAME"></span></p>
                        <p><strong>Status:</strong> <span id="REQUESTSTATUS"></span></p>
                        <p><strong>Time Difference:</strong> <span id="TimeDifference"></span></p>

                                            <label></label>
											<div> </div>
                                            <textarea maxlength="50" style="display:none" name="txtRequestorName" rows="2" class="form-control" placeholder="Requestor Name" id="txtRequestorName"></textarea>
                                        </div>
                                    </div>
                                    <div style="display:none">
                                     <div class="col-md-12" id="containerContact">
                                        <div class="mb-3">
                                            <label>Request date. <span style="font-size: 11px"></span></label>
											<div><span id="spanERequestDate"></span></div>
                                            <textarea maxlength="50"  style="display:none" name="txtContactNumber" rows="2" class="form-control" placeholder="Contact No." id="txtContactNumber"></textarea>
                                        </div>
                                    </div>

                                    <div class="col-md-12">
                                        <div class="mb-3">
                                            <label>From</label>
											<div><span id="spanEFrom"></span></div>
                                            <div id="divSelRemarks">
                                                <select name="search_Remarks"  style="display:none" id="search_Remarks" tabindex="10" multiple="multiple" class="form-control search_test" style="margin-bottom: 10px; background-color: white !important;"></select>
                                            </div>
                                            <textarea maxlength="100" style="display:none" name="task-description" rows="4" class="form-control" placeholder="Remarks" id="txtRemarks" style="display: inline-block;"></textarea>
                                        </div>
                                    </div>
									
									 <div class="col-md-12">
                                        <div class="mb-3">
                                            <label>To</label>
											<div><span id="spanETo"></span></div>
                                            
                                               </div>
                                    </div>
									<div class="col-md-12">
                                        <div class="mb-3">
                                            <label>Task Type</label>
											<div><span id="spanECat"></span></div>
                                            
                                               </div>
                                    </div>
									
                                    <div id="divEditRemarks" class="col-md-12">

                                        <div class="col-md-12" id="divPorterRemarks">
                                            <div class="mb-3">
                                                <label>Remarks</label>
												<div><span id="spanERema"></span></div>
                                                <textarea maxlength="100" style="display:none" name="task-description" rows="4" class="form-control" placeholder="Porter Remarks" id="txtPorterRemarks" style="display: inline-block;"></textarea>
                                            </div>
                                        </div>
                                        <br />
                                        <div class="col-md-12" id="divCancelRemarks" style="display:none">
                                            <label>Cancel Remarks</label>
                                            <div id="divSelCRemarks">
                                                <select name="selectFloor" id="search_CancelRemarks" tabindex="12" multiple="multiple" class="form-control search_test" style="margin-bottom: 10px; background-color: white !important;"></select>
                                            </div>
                                            <textarea maxlength="100" name="task-description" rows="3" class="form-control" placeholder="Cancel Remarks" id="txtCanceRemarks" style="display: inline-block;"></textarea>
                                        </div>
                                    </div>
                                    </div>
                                </div>

                                <div class="RequestIcons" style="padding: 10px">
                                    <div class="mb-3 row">

                                        <div class="col-sm-3" id="divIconAckPhoto" style="text-align: center; padding: 15px 10px;"></div>
                                        <div class="col-sm-2" id="divIconAckSign" style="text-align: center; padding: 15px 10px;">></div>
                                        <div class="col-sm-3" id="divIconLog" style="text-align: center; padding: 15px 10px;"></div>
                                        <div class="col-sm-4">
                                            <button type="button" class="btn btn-outline w-100"
                                                data-bs-dismiss="modal">
                                                <img src="../images/multiply.svg">
                                                Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="modal fade" id="ModalImage" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-md" style="min-width: 1050px;">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <img id="imgAckHead" src="../images/Photo.png" alt="Logs" style="width: 35px;" />&nbsp;
                            <span style="font-size: 16px;"><span id="spanReqID"></span><span id="spanAckHead"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <span style="font-size: 16px; visibility: hidden;cursor:pointer" id="imgAckHolder1">1.
                                <img id="imgAck1" src="../images/Photo.png" alt="Logs" style="width: 35px;" />&nbsp; </span>
                                <span style="font-size: 16px; visibility: hidden;cursor:pointer" id="imgAckHolder2">2.
                                    <img id="imgAck2" src="../images/Photo.png" alt="Logs" style="width: 35px;" />&nbsp;</span>
                                <span style="font-size: 16px; visibility: hidden;cursor:pointer" id="imgAckHolder3">3.
                                    <img id="imgAck3" src="../images/Photo.png" alt="Logs" style="width: 35px;" />&nbsp;</span></span>


                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="width: 20px; height: 20px;">
                            <img src="../images/close-white.svg">
                        </button>
                    </div>
                    <div class="modal-body" style="height: 1000px;">
                        <form>
                            <div class="row">

                                <div class="col-md-12" align="center">
                                    <div class="polaroid">
                                        <img id="ImgACK" alt="ACK" />
                                        <div class="container">
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <p id="ACK_ON"></p>
                                                </div>
                                                <div class="col-md-3">
                                                    <p id="ACK_BY"></p>
                                                </div>
                                                <div class="col-md-3">
                                                    <p id="ACK_LOC"></p>
                                                </div>
                                                <div class="col-md-3">
                                                    <p id="ACK_CONTACT"></p>
                                                </div>
                                            </div>

                                        </div>
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
                                        <span>Generating report. This may take few seconds, please wait..</span>
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
        </div>

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
                    <div class="modal-body" style="height: 630px;">
                        <form>

                            <div class="row">

                                <div id="divCompleteselect" class="col-md-12">
                                    <select name="selectFloor" id="search_CompleteRemarks" tabindex="11" multiple="multiple" class="form-control search_test" onchange="OnChangeRemarks(this,'txtCompleteRemarks');return false;" style="margin-bottom: 10px; background-color: white !important;"></select>
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-md-8">
                                    <textarea maxlength="100" name="txtComRemarks" rows="3" class="form-control" placeholder=" Notes " id="txtComRemarks" style="display: inline-block;"></textarea>
                                </div>
                                <div class="col-md-4">
                                    <div class="row">

                                        <div class="col-md-3" align="center" style="padding-top: 17px;">
                                            <img src="../images/NoMCheck.jpg" id="chkMitigationCom" style="width: 20px; cursor: pointer;" onclick="setCheck(this);">
                                        </div>
                                        <div class="col-md-9 mb-3" align="center" style="margin-top: 10px; margin-bottom: 3px !important;">
                                            <label style="font-weight: 600; color: white; margin-bottom: 6px; background-color: #0a57c7; padding: 5px; margin-left: -10px; text-decoration: underline;"
                                                onclick="setCheckbyID('chkMitigationCom');">
                                                Mitigation
                                            </label>
                                        </div>
                                        <div class="col-md-8" align="right">
                                            <div class="col-sm-6">
                                                <button type="button" class="btn btn-secondary " onclick="submitNotes();" style="padding: 7px 13px;">
                                                    <img
                                                        src="../images/envelope.png">
                                                    Submit</button>
                                            </div>
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

        <div id="ModalLoading" class="modal fade" role="dialog" style="display: none; padding-right: 17px; background-color: whiteb3;">
            <div class="modal-dialog modal-dialog-centered modal-md">
                <div class="modal-dialogLoc" align="center">
                    <table style="margin-top: 100px;">
                        <tr>
                            <td>
                                <img id="LoadingGif" style="width: 80px; border-radius: 5px;"
                                    src="../Images/LoadingN.gif" />
                            </td>
                        </tr>
                    </table>
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
