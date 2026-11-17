<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="Index_Index" ValidateRequest="false" %>
 
<html lang="en">

<head>
    <title>Home | TRACZO</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- Favicon -->
    <link rel="icon" href="../favicon.png" />
    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="../css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../css/sumoselect.min.css">
    <link rel="stylesheet" type="text/css" href="../css/style.css" />
    <link href="../css/pager.css" rel="stylesheet" />
    <link href="../css/changepwd.css" rel="stylesheet" />
    <link href="../css/ajax.min.css" rel="stylesheet" />

    <script src="../js/jquery-3.6.4.min.js" type="text/javascript"></script>

    <script src="../js/aes.js" type="text/javascript"></script>
    <script src="../js/Index13.js" type="text/javascript"></script>
    <script src="../js/bulk.js" type="text/javascript"></script>
    <script src="../js/ChangePassword.js" type="text/javascript"></script>
    <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">

        <script type="text/javascript">
            var dataSet = [], hurl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Index/",
                divServiceArray = ['divPorteringService', 'divCateringService', 'divCleaningService', 'divFeedbackService', 'divSecurityService'],
                urlPageValidation =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' + '://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/MasterPage/Service/Service.aspx?",
                CryptoKey = '<%=ConfigurationManager.AppSettings["CryptoKey"].ToString() %>',
                CryptoPwd = '<%=ConfigurationManager.AppSettings["CryptoIV"].ToString() %>',
                ConProtocol = '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>',
                CProcess = 10, grid, gridMasterTable, pageSize = 20, pageIndex = 0, Reload = window.setInterval(ReloadLinks, 60000), olddatetime = '', prebook = '', TimerHome, ToUpdate = false,
                FPatientName = '', TPatientName = '', MRDPatientName = '', GCancelReason, GFinishReason, GTagID, CurrentDStatus, GReqID, GPorterID, IsEdit, GMIndex = '0', GExtn = '', ReqDate = '', ReqTime = '', ReqCat = '0', RFromID = '0', RToID = '0', RHalt1 = '0', RHalt2 = '0', RPreBook = '0',
                Efrom, ETo, ECategory, EDate, EPatient, Remarks, AReqID, APorter1, APorter2, ADept, Isclear = false, PorterID1 = '', PorterName1 = '', PorterID = '', PorterName = '', PORTERGROUP = '', ISMULTIPORTER = 'NO', IsReturn = 'NO',
                MAReqID = '', MADept = '', MACount = 60, MANReqID = '', MANCount = 60, MANPorterID = '', MANPorterName = '', GPatientName = '', GFrom = '', GStatus = '2', GOMI = '0', GUser = '', ATReqNB = '', //MANInterval = window.setInterval(function () { processMAN(MANCount); }, 1000),
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

            var MTCount = 60, MTInterval = window.setInterval(function () { processMT(MTCount); }, 1000);


            var Base64 = { _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=", encode: function (e) { var t = ""; var n, r, i, s, o, u, a; var f = 0; e = Base64._utf8_encode(e); while (f < e.length) { n = e.charCodeAt(f++); r = e.charCodeAt(f++); i = e.charCodeAt(f++); s = n >> 2; o = (n & 3) << 4 | r >> 4; u = (r & 15) << 2 | i >> 6; a = i & 63; if (isNaN(r)) { u = a = 64 } else if (isNaN(i)) { a = 64 } t = t + this._keyStr.charAt(s) + this._keyStr.charAt(o) + this._keyStr.charAt(u) + this._keyStr.charAt(a) } return t }, decode: function (e) { var t = ""; var n, r, i; var s, o, u, a; var f = 0; e = e.replace(/[^A-Za-z0-9+/=]/g, ""); while (f < e.length) { s = this._keyStr.indexOf(e.charAt(f++)); o = this._keyStr.indexOf(e.charAt(f++)); u = this._keyStr.indexOf(e.charAt(f++)); a = this._keyStr.indexOf(e.charAt(f++)); n = s << 2 | o >> 4; r = (o & 15) << 4 | u >> 2; i = (u & 3) << 6 | a; t = t + String.fromCharCode(n); if (u != 64) { t = t + String.fromCharCode(r) } if (a != 64) { t = t + String.fromCharCode(i) } } t = Base64._utf8_decode(t); return t }, _utf8_encode: function (e) { e = e.replace(/rn/g, "n"); var t = ""; for (var n = 0; n < e.length; n++) { var r = e.charCodeAt(n); if (r < 128) { t += String.fromCharCode(r) } else if (r > 127 && r < 2048) { t += String.fromCharCode(r >> 6 | 192); t += String.fromCharCode(r & 63 | 128) } else { t += String.fromCharCode(r >> 12 | 224); t += String.fromCharCode(r >> 6 & 63 | 128); t += String.fromCharCode(r & 63 | 128) } } return t }, _utf8_decode: function (e) { var t = ""; var n = 0; var r = c1 = c2 = 0; while (n < e.length) { r = e.charCodeAt(n); if (r < 128) { t += String.fromCharCode(r); n++ } else if (r > 191 && r < 224) { c2 = e.charCodeAt(n + 1); t += String.fromCharCode((r & 31) << 6 | c2 & 63); n += 2 } else { c2 = e.charCodeAt(n + 1); c3 = e.charCodeAt(n + 2); t += String.fromCharCode((r & 15) << 12 | (c2 & 63) << 6 | c3 & 63); n += 3 } } return t } };

            var ArCtrl = ["TxtCurPassword", "TxtPassword", "TxtConfirmPassword"], UsrPassword = ((sessionStorage.getItem('PASSWORD') == null) ? "" : Base64.decode(sessionStorage.getItem('PASSWORD'))),
                arrError = ["ErCurrent", "ErPassword", "ErCPassword"], PageName = document.location.pathname.match(/[^\/]+$/)[0];


            $(document).ready(function () {
                
                ServiceCode = sessionStorage.getItem('ServiceCode');
                //ReloadLinks();

                InitChangePassword();
                // Preload New Request values.
                LoadNewRequest();
                //setPagerEmpty();

                // Load Pending List
                //ReloadLinksButton();
                //Select("divPendingPercentage", "PENDING");

                $('#chkPreBook').change(function () {
                    var IsPreBook = $('#chkPreBook').prop('checked');

                    $('#containerDate').css("display", (IsPreBook) ? "inline-block" : "none");
                    $('#containerTime').css("display", (IsPreBook) ? "inline-block" : "none");

                    RPreBook = (IsPreBook) ? "1" : "0";

                    setPreBookCat();
                });
                $('#chkUserRequest').change(function () {
                    setIndexscreen(true);

                });
                $('#chkHaywoodRequests').change(function () {
                    IsHaywood = $('#chkHaywoodRequests').prop('checked');
                    setIndexscreen(false);
                });

                $("#ModalAddTask").on("hidden.bs.modal", function () {
                    clearMT();
                });
                $("#floor-map-popup").on("hidden.bs.modal", function () {
                    clearInterval(ReloadMap);
                    Reload = window.setInterval(ReloadLinks, 60000);
                });

                $("#txtFromLoc").keyup(function () {
                    if (ServiceCode != '2')
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


                $.xhrPool = [];
                $.ajaxSetup({
                    beforeSend: function (jqXHR) { $.xhrPool.push(jqXHR); }, //  annd connection to list  -- alert($.xhrPool.length);
                    complete: function (jqXHR) {
                        var i = $.xhrPool.indexOf(jqXHR);   //  get index for current connection completed
                        if (i > -1) $.xhrPool.splice(i, 1); //  removes from list by index  -- alert($.xhrPool.length);
                    }
                });
                $('.services-btn-icon').click(function () {
                    // Remove 'active' class from all buttons

                    ServiceCode = $(this).attr('id').replace("divService", ""); callFrom = 'Parent'
                    sessionStorage.setItem('ServiceCode', ServiceCode);
                   // alert(sessionStorage.getItem('ServiceCode'));

                    setRootServices(this);
                    // Add 'active' class to the clicked button

                });
                if (ServiceCode == null)
                    $('.services-btn-icon').first().trigger('click');
                else {
                    ServiceCode = (ServiceCode == '0') ? "1" : ServiceCode;
                    sessionStorage.setItem('ServiceCode', ServiceCode);
                    //alert(sessionStorage.getItem('ServiceCode'));
                    $('#divService' + ServiceCode).trigger('click');
                }

                $('.services-btn-icon-modal').click(function () {
                    var Process = (($("#TaskHeader").html() == 'New Task') ? "New" : "Edit");


                    var selServiceCode = $(this).attr('id').replace("divRService", "");

                    if (Process == 'New' || EServiceCode == selServiceCode) {
                        var eleParent = $('#divService' + selServiceCode);
                        // Remove 'active' class from all buttons

                        // Add 'active' class to the clicked button
                        ServiceCode = selServiceCode;
                        
                        callFrom = "innerElement";
                        setRequestChanges(selServiceCode, Process);
                        setRootServices(eleParent); setInnerServices(this);

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
            });
            function setRootServices(ele) {

                $('.services-btn-icon').removeClass('active');
                $(ele).addClass('active');
                // Get the rgb color of the clicked button
                var rgbColor = $(ele).data('color'); sessionStorage.setItem('ServiceCode', ServiceCode);
                // Convert rgb to rgba by appending the opacity
                var rgbaColor = rgbColor.replace('rgb', 'rgba').replace(')', ', 0.1)');


                $('#DivKitchenFilters').css("display", (ServiceCode == "2") ? "inline-block" : "none");

                $('#DivCleaningFilters').css("display", (ServiceCode == "3") ? "inline-block" : "none");
                setServiceUpdates(ServiceCode);
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
            function setRequestChanges(ServiceCode, Process) {

                switch (ServiceCode) {
                    case "1":

                        $('#containerMP').css("display", "inline-block");
                        $('#containerPatient').css("display", "inline-block");
                        $('#divQuantity').css("visibility", "hidden");
                        $('#txtFromLoc').prop("readonly", false);
                        $('#containerTo').css("visibility", "visible");
                        $('#lblFrom').html('From'); $('#lblTo').html('To');
                        $('#lblPatientDetails').html('Patient Details <span style="font-size: 11px">(Name/ DOB / Hospital No)</span>');
                        $('#divEndDate').css("display", "none"); $('#divBarrierPercentage').css("display", "none");
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
                        $('#containerTo').css("visibility", "visible");
                        $('#lblFrom').html('From'); $('#lblTo').html('To');

                        $('#divBarrierPercentage').css("display", "none");
                        $("#suggesstionFrom").hide();
                        setTimeout(function () { $('#txtFromLoc').prop("readonly", true); $('#txtToLoc').focus(); }, 500)
                        $('#lblKPITS').html('-');
                        $('#lblKPITE').html('-');
                        $('#containerCat').css('background-color', bgcolor); $('#containerKPI').css('background-color', bgcolor);
                        $('#tdKPICompletion').css('background-color', bgcolor); $('#tdKPIResponse').css('background-color', bgcolor); $('#parentcontainerMP').css('background-color', bgcolor);
                        $('#divEndDate').css("display", "none");
                        break;

                    case "3":

                        $('#containerMP').css("display", "none");
                        $('#containerPatient').css("display", "none");
                        $('#divQuantity').css("visibility", "hidden");
                        $('#containerTo').css("visibility", "visible"); $('#txtToLoc').prop("readonly", true); $('#lblTo').html('Zone Name');
                        $('#lblPatientDetails').html('Authorizer');
                        $('#txtFromLoc').prop("readonly", false);
                        setTimeout(function () { $('#txtFromLoc').focus(); }, 500)

                        $('#lblFrom').html('Request Location');

                        $('#divBarrierPercentage').css("display", "none");
                        $("#suggesstionTo").hide();
                        $('#lblKPITS').html('-');
                        $('#lblKPITE').html('-');
                        $('#containerCat').css('background-color', '#6dadff'); $('#containerKPI').css('background-color', '#6dadff');
                        $('#tdKPICompletion').css('background-color', '#6dadff'); $('#tdKPIResponse').css('background-color', '#6dadff'); $('#parentcontainerMP').css('background-color', '#6dadff');

                        if (ReqCat == '73') {
                            $('#containerPatient').css("display", "inline-block");
                            $('#divEndDate').css("display", "inline-block");
                        }
                        break;
                }
                if (Process == 'New') {
                    LoadCategories('');
                    LoadPresetRemarks();
                }

            }
            function setPagerEmpty() {
                valuePage.curPage = 0;
                valuePage.totalPages = 0;
                btnNextPg.disabled = true;
                btnLastPg.disabled = true;
                btnPrevPg.disabled = true;
                btnFirstPg.disabled = true;
                $('.page-container').css('display', 'none');
            }

            function setIndexscreen(fromPorterIcon) {
                var IsUser = $('#chkUserRequest').prop('checked');

                $('#divUserHeaders').css("display", ((IsUser) ? "inline-flex" : "none"));
                $('#divRequestHeaders').css("display", ((IsUser) ? "none" : "inline-flex"));
                $('#taskfileters').css("display", ((IsUser) ? "none" : ""));

                $('#DivCleaningFilters').css("display", (!IsHaywood) ? "inline-block" : "none");

                if (IsUser) {
                    getPorterStatus('0');
                }
                else {
                    var divTask = (CProcess == "0") ? "divTotalPercentage" : (CProcess == "2") ? "divPendingPercentage" : (CProcess == "3") ? "divAssignedPercentage" : (CProcess == "4") ? "divInprogressPercentage" : (CProcess == "6") ? "divCompletedPercentage" : (CProcess == "7") ? "divCancelledPercentage" : (CProcess == "8") ? "divPendingOnHoldPercentage" : (CProcess == "9") ? "divBarrierPercentage" : (CProcess == "100") ? "divPrebookeddPercentage" : (CProcess == "100") ? "tdPreBook" : "divPendingPercentage";

                    divTask = (ServiceCode == '3') ? ((CProcess == "9") ? "divBarrierPercentage" : divTask) : ((fromPorterIcon || (CProcess == "9")) ? "divPendingPercentage" : divTask);

                    //if (fromPorterIcon)
                    //    Select("divPendingPercentage", "PENDING");
                    //else
                    Select(divTask, "");
                    setRequestUsers('Tasks');

                }
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
                    setIndexscreen();
            }


            function setPreBookCat() {
                clearAllCheckBox('ReqCategories');
                ReqCat = ''; LoadCategories('');
            }
            function LoadProcess(RequestStatusID) {



                var divReq = $("#tblRequests");
                LoadTableRequest(RequestStatusID, divReq);

            //sessionStorage.getItem('ROLE', 'CONTROL ROOM');
               <%-- grid = $find('<%= GridRequest.ClientID %>');
                gridMasterTable = $find('<%= GridRequest.ClientID %>').get_masterTableView();--%>
                //  alert(gridMasterTable.get_virtualItemCount());
            }

            function ReloadLinks() {

                if (sessionStorage.getItem('ROLE') == null)
                    window.location = "../Login.aspx";
                ReloadLinksButton();
            }


        </script>
    </telerik:RadCodeBlock>
    <style type="text/css">
        .switch-button_Occurrence {
            background: #0d6efd;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-radius: var(--border-radius);
            padding: 0 0.5rem;
            gap: .5rem;
            min-height: 2.5rem;
            font-size: 12px;
        }

        .switchOccurrence {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 20px;
            margin-bottom: 0px;
        }

            .switchOccurrence input {
                opacity: 0;
                width: 0;
                height: 0;
            }

        .slideroccurrence {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            -webkit-transition: .4s;
            transition: .4s;
        }

            .slideroccurrence:before {
                position: absolute;
                content: "";
                height: 13px;
                width: 13px;
                left: 4px;
                bottom: 4px;
                background-color: white;
                -webkit-transition: .4s;
                transition: .4s;
            }

        input:checked + .slideroccurrence {
            background-color: #e94234;
        }

        input:focus + .slider {
            box-shadow: 0 0 1px #e94234;
        }

        input:checked + .slideroccurrence:before {
            -webkit-transform: translateX(20px);
            -ms-transform: translateX(20px);
            transform: translateX(20px);
        }

        /* Rounded sliders */
        .slideroccurrence.round {
            border-radius: 15px;
        }

            .slideroccurrence.round:before {
                border-radius: 50%;
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

        .form-control {
            background-color: white !important;
        }

        .table-wrap {
            padding: 21px;
        }

        .imgIconsb {
            cursor: pointer !important;
            width: 28px !important;
        }

            .imgIconsb:hover {
                cursor: pointer !important;
                width: 30px !important;
            }

        .modal-AddTask {
            padding-top: 5%;
            min-height: 500px;
            max-width: 1200px;
            position: absolute;
            width: 92%;
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
            margin: auto;
        }

        .LocationList::-webkit-scrollbar {
            width: 13px;
            background-color: white;
        }

        .btnOk {
            color: white !important;
            background-color: #2870ff !important;
        }

        .btnCancel {
            color: gray !important;
        }

        legend {
            font-size: 1rem !important;
            color: var(--text-color);
            /* padding: 0px 15px; */
            font-weight: 600;
            margin-bottom: 1rem;
        }

        fieldset {
            /* border: 1px solid gray;
        padding: 15px; */
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

        /* width */
        /*#tblRequests::-webkit-scrollbar {
        width: 6px;
    }*/

        /* Track */
        /*#tblRequests::-webkit-scrollbar-track {
        box-shadow: inset 0 0 2px grey;
        border-radius: 3px;
    }*/

        /* Handle */
        /*#tblRequests::-webkit-scrollbar-thumb {
        background: #42bc8a;
        border-radius: 3px;
    }*/

        /* Handle on hover */
        /*#tblRequests::-webkit-scrollbar-thumb:hover {
            background: #00796b;
        }*/
        .table-wrap table th, .table-wrap table td {
            padding: 4px;
            font-size: 14px;
            vertical-align: middle;
        }

        .col-md-1 {
            min-width: 135px;
        }

        .progress:hover {
            border: 2px solid #334c5c;
            padding: 2px;
            height: 20px;
        }

        .titleActive {
            border: 2px solid #334c5c;
            padding: 2px;
            height: 20px;
        }

        /*.counter-info-item:hover {
        border: 2px solid #334c5c;
        padding: 2px;
        border-radius: 5px;
    }*/

        .divtitleActive {
            border: 2px solid #334c5c;
            padding: 2px;
            border-radius: 5px;
        }

        .SumoSelect > .optWrapper > .options {
            text-align: left !important;
            max-height: 200px;
        }

        .RadGrid_Metro .rgHeader, .RadGrid_Metro th.rgResizeCol, .RadGrid_Metro .rgMultiHeaderRow th.rgHeader, .RadGrid_Metro .rgMultiHeaderRow th.rgResizeCol {
            /*border: 0 !important;
        border-bottom: 0px solid #e5e5e5 !important;
        border-left: 0px solid #e5e5e5 !important;*/
            border: 1px solid #CFE4FF !important;
        }

            .RadGrid_Metro .rgHeader, .RadGrid_Metro .rgHeader a {
                color: #303537 !important;
                /*background-color: rgb(30, 70, 129) !important;*/
                font-family: monospace !important;
                font-size: 16px !important;
                font-weight: bold !important;
                height: 25px !important;
                vertical-align: middle !important;
            }

        .RadGrid_Metro .rgRow td, .RadGrid_Metro .rgAltRow td, .RadGrid_Metro .rgEditRow td, .RadGrid_Metro .rgFooter td {
            border-style: none !important;
            border-width: 0 0 0px 0px !important;
        }

        .RadGrid_Metro .rgMasterTable .rgSelectedCell, .RadGrid_Metro .rgSelectedRow {
            color: #fff !important;
            background: #9E9E9E !important;
            font-family: monospace !important;
            font-size: 15px !important;
        }

        .RadGrid .rgClipCells .rgHeader, .RadGrid .rgClipCells .rgFilterRow > td, .RadGrid .rgClipCells .rgRow > td, .RadGrid .rgClipCells .rgAltRow > td, .RadGrid .rgClipCells .rgEditRow > td, .RadGrid .rgClipCells .rgFooter > td {
            overflow: hidden !important;
            vertical-align: middle !important;
            text-align: center !important;
            font-family: monospace !important;
            font-size: 15px !important;
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

        .form-control {
            background-color: white !important;
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


        .time-right {
            float: right;
            color: gray;
            font-size: 12px;
            margin-right: 10px;
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


        .CounterItems {
            color: gray;
            font-size: 13px;
            font-weight: bold;
            color: white;
            background-color: #0a57c7;
            padding: 5px;
            text-decoration: underline;
        }

        .msgUser {
            font-size: 15pt;
            font-weight: bold;
        }

        .table-wrap table th, .table-wrap table td {
            padding: 2px;
        }

        .modal-body .form-control {
            background: /*#F8F7F7*/ white !important;
        }

        #ReqCategories img {
            /*display: none;*/
        }
    </style>
</head>

<body class="">
    <form runat="server">
        <asp:HiddenField ID="HFCancelReqID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFCancelReqNB" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFCancelCatID" runat="server" ClientIDMode="Static" />

        <asp:HiddenField ID="HFCancelMUIndex" runat="server" ClientIDMode="Static" />


        <asp:HiddenField ID="HFOnHoldReqID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFOnHoldReqNB" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFOnHoldPorterID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFOnHoldMUIndex" runat="server" ClientIDMode="Static" />


        <asp:HiddenField ID="HFSCReqID" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFSCReqNB" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFSCMUIndex" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFCatID" runat="server" ClientIDMode="Static" />


        <asp:HiddenField ID="HFERID" runat="server" ClientIDMode="Static" />


        <asp:HiddenField ID="HFERNO" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="HFStatusID" runat="server" ClientIDMode="Static" />


        <asp:HiddenField ID="HFCryptoKey" runat="server" ClientIDMode="Static" />

        <asp:HiddenField ID="HFCryptoIv" runat="server" ClientIDMode="Static" />
        <telerik:RadScriptManager ID="RadScriptManager" runat="server">
        </telerik:RadScriptManager>
        <div class="lang-menu" style="visibility: hidden">
            <a class="select-language" href="index-thai.html">Thai</a>
        </div>
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
                                <br />
                                <div style="display:none" class="add-task-link" onclick="setNewTask();">
                                    <a href="https://admin-qah.traczo.app/login.aspx"
                                        class="btn btn-primary">
                                        <img src="../images/memo.png" alt="Add Task">
                                        Add task
                                    </a>
                                </div>
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
                                            <a href="../html/dashboard.html" style="display: none">
                                                <span>
                                                    <img src="../images/dashboard.png" alt="Dashboard"></span> Dashboard
                                            </a>
                                        </li>
 
                                        <li>
                                            <a href="../Reports/Report.aspx">
                                                <span>
                                                    <img src="../images/clipboard.png" alt="Reports"></span> Reports
                                            </a>
                                        </li>
                                        <%--<li>
                                            <a href="../Planner/Planner.aspx">
                                                <span>
                                                    <img src="../images/spiral-calendar.png" alt="Planner"></span> Planner
                                            </a>
                                        </li>--%>

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
                        <div class="row" style="display: none">
                            <div class="col-md-9">

                                <!-- Section heading -->
                                <div class="section-head">
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
<div class="navigation-tabs-wrapper" style="/* visibility:hidden; */">
                            <div class="services-button">
                                <label>Services</label>
                            </div>
                            <div class="services-tabs-wrapper">
                                <div class="services-btn-icon active" data-color="rgb(255, 116, 0)" id="divService1">
                                    <img src="../images/porter-icon.svg">
                                    <span>Porter</span>
                                </div>
  <div class="services-btn-icon" data-color="rgb(12, 188, 139)" id="divService3">
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
                            <div class="action-btn-wrapper" style="
    visibility: hidden;
">
                                
                                <div class="switch-button">
                                    <label>
                                        Haywood
                                    </label>
                                    <label class="switch">
                                        <input type="checkbox" id="chkHaywoodRequests">
                                        <span class="slider1 round"></span>
                                    </label>
                                </div>
                                <div class="switch-button">
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

                        <div class="search-tabs-wrap">
                            <div class="search-tab-container">
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
                                    <div class="row" id="divRequestHeaders" style="margin-left: 0px !important;">

                                        <div class="InnerIndexIcon col-md-1" id="divTotalPercentage" onclick='Select("divTotalPercentage","TOTAL");'>
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countTotalCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                TOTAL
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divPendingPercentage" onclick='Select("divPendingPercentage","PENDING");'>
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countPendingCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                PENDING
                                            </p>
                                        </div>

                                        <div class="InnerIndexIcon col-md-1" id="divAssignedPercentage" onclick='Select("divAssignedPercentage","ASSIGNED");'>
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countAssignedCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                ASSIGNED
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divInprogressPercentage" onclick='Select("divInprogressPercentage","INPROGRESS");'>
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countInprogressCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                IN-PROGRESS
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divCompletedPercentage" onclick='Select("divCompletedPercentage","COMPLETED");'>
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countCompletedCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                COMPLETED
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divPendingOnHoldPercentage" style="" onclick='Select("divPendingOnHoldPercentage","ONHOLD");'>
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countPendingOnHoldCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                ON-HOLD
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divPrebookeddPercentage" onclick='Select("divPrebookeddPercentage","PREBOOKED");'>
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countPreBookedCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                PRE-BOOKED 
                                            </p>
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divCancelledPercentage" onclick='Select("divCancelledPercentage","CANCELLED");'>
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countCancelledCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                CANCELLED
                                            </p>
                                        </div>

                                        <div class="InnerIndexIcon col-md-1" id="divBarrierPercentage1" onclick='Select("divBarrierPercentage","Barrier");' style="min-width: 150px !important; display: none !important;">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countBarrierCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                BARRIER CLEAN
                                            </p>
                                            <img src="../images/barrier.png" />
                                        </div>


                                        <div class="InnerIndexIcon col-md-1" id="divTatExceededPercentage" onclick='Select("divTatExceededPercentage","TATEXCEED");' style="display: none;">
                                            <div class="InnerReqCountContainer">
                                                <span class="InnerReqCount" id="countTATExceedCount">00</span>
                                            </div>
                                            <p class="InnerReqText">
                                                TAT EXCEEDED
                                            </p>
                                        </div>

                                        <div class="col-md-1">
                                            <a href="#" class="btn btn-primary w-100" onclick='RefreshTasks();' style="width: 135px !important; height: 45px;">
                                                <img src="../images/refresh.png" alt="Refresh">
                                                Refresh
                                            </a>

                                        </div>
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

                                <div class="search-wrap" style="width: 100%;">
                                    <div class="search-box">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="row" id="taskfileters">
                                                    <div class="col-md-4">
                                                        <fieldset>
                                                            <legend>Task Filters</legend>


                                                            <div class="row">

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


                                                    </div>
                                                    <div class="col-md-5">

                                                        <fieldset>
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
                                                    </div>

                                                    <div class="col-md-3">
                                                        <div class="row">

                                                            <div class="col-md-11" id="DivKitchenFilters">
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
                                                            </div>
                                                        </div>
                                                        <div class="row">

                                                            <div class="col-md-11" id="DivCleaningFiltersT" style="visibility:hidden">
                                                                <fieldset>
                                                                    <legend>CLEANING ZONES</legend>
                                                                    <div class="row">

                                                                        <div class="col-md-12">
                                                                            <select name="selectFloor" id="search_CleaningZone" class="form-control search_test" onchange="setIndexscreen(); return false;">
                                                                                <option value="" selected>ALL</option>
                                                                                <option value="Zone 1">Zone 1</option>
                                                                                <option value="Zone 2">Zone 2</option>
                                                                                <option value="Zone 3">Zone 3</option>
                                                                                <option value="Zone 4">Zone 4</option>
                                                                                <option value="Zone 5">Zone 5</option>
                                                                            </select>

                                                                        </div>
                                                                    </div>
                                                                </fieldset>
                                                            </div>
                                                        </div>
                                                    </div>

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
                                            <div class="col-sm-12">
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
                                        <div class="table-responsive" id="tblRequests" style="max-width: 98%;">
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
        </div>

        <!-- /Reports -->
        <!-- Add Task -->
        <!-- Modal -->


        <div class="modal fade" id="ModalImage" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-md" style="min-width: 600px;">
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
            <button type="button" class="floating btn-close" data-bs-dismiss="modal" aria-label="Close">
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
                            <div class="form-wrap me-4">
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
                                    <%--<h5 style="font-family: monospace; width: 700px;"><span id="TaskHeader"></span>&nbsp;&nbsp;&nbsp;<span id="ReqUserLogin" style="margin-left: 20px; font-size: 19px;"></span></h5>--%>
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
                                        <%--  <div class="col-md-12" align="center">
                                            <div class="d-flex align-items-center col-md-11">
                                                <div class="from-title">
                                                    <h5>From</h5>
                                                </div>
                                                <div class="task-type">
                                                    <span class="left"></span>
                                                    <div class="btn btn-primary">Task type</div>
                                                    <span class="right"></span>
                                                </div>
                                                <div class="to-title text-end">
                                                    <h5>To</h5>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="locations">
                                            <div class="from-location-wrap">
                                                <div class="from-location mb-4" id="containerFrom">
                                                    <div class="sumo-container">
                                                        <select name="selectFloor" id="search_from" tabindex="1" class="select sumoSelect sumo-select" onchange="setLocation(this,'From');">
                                                            <option value="0">--Select--</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <hr>
                                                <div class="from-location mb-4" id="containerHalt1">
                                                    <div class="sumo-container">
                                                        <select name="selectFloor" id="search_Halt1" tabindex="1" class="select sumoSelect sumo-select" onchange="setLocation(this,'Halt1');">
                                                            <option value="0">--Select--</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>--%>


                                        <div class="col-md-6" id="containerFrom">
                                            <div class="mb-3">
                                                <label id="lblFrom">From</label>
                                                <textarea maxlength="50" name="txtFromLoc" rows="1" class="form-control" placeholder="-- Select --" id="txtFromLoc" style="padding: 15px;"></textarea>
                                                <div id="suggesstionFrom" class="col-md-6"></div>
                                            </div>
                                        </div>

                                        <div class="col-md-6" id="containerTo">
                                            <div class="mb-3">
                                                <label id="lblTo">To</label>
                                                <textarea maxlength="50" name="txtToLoc" rows="1" class="form-control" placeholder="-- Select --" id="txtToLoc" style="padding: 15px;"></textarea>
                                                <div id="suggesstionTo" class="col-md-6"></div>
                                            </div>
                                        </div>


                                        <%-- <div class="col-md-6" id="containerFrom">
                                            <div class="mb-3">
                                                <label>From</label>
                                                <select name="selectFloor" id="search_from" tabindex="1" class="form-control search_test" onchange="setLocation(this,'From');">
                                                    <option value="0">--Select--</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6" id="containerTo">
                                            <div class="mb-3">
                                                <label>To</label>
                                                <select name="selectFloor" id="search_to" tabindex="2" class="form-control search_test" onchange="setLocation(this,'To');">
                                                    <option value="0">--Select--</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div style="display: none">
                                            <div class="col-md-6" id="containerHalt1">
                                                <div class="mb-3">
                                                    <label>Halt1 <span style="font-size: 9pt">(optional)</span></label>
                                                    <select name="selectFloor" id="search_Halt1" tabindex="1" class="form-control search_test" onchange="setLocation(this,'Halt1');">
                                                        <option value="0">--Select--</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-6" id="containerHalt2">
                                                <div class="mb-3">
                                                    <label>Halt2<span style="font-size: 9pt">(optional)</span></label>
                                                    <select name="selectFloor" id="search_Halt2" tabindex="1" class="form-control search_test" onchange="setLocation(this,'Halt2');">
                                                        <option value="0">--Select--</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>--%>
                                        <div class="col-md-12" id="containerCat" style="background-color: #6dadff; padding: 25px 25px 10px 25px; margin-top: 30px; min-height: 325px;">
                                            <div class="row mb-2 align-items-center search-bar-modal justify-content-between" style="padding: 10px;">
                                                <div class="col-md-2">
                                                    <label>Task Type</label>
                                                </div>
                                                <div class="col-md-6">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="21" viewBox="0 0 20 21" fill="none">
                                                        <path d="M9.58342 18.625C4.87508 18.625 1.04175 14.7917 1.04175 10.0833C1.04175 5.37501 4.87508 1.54167 9.58342 1.54167C14.2917 1.54167 18.1251 5.37501 18.1251 10.0833C18.1251 14.7917 14.2917 18.625 9.58342 18.625ZM9.58342 2.79167C5.55841 2.79167 2.29175 6.06667 2.29175 10.0833C2.29175 14.1 5.55841 17.375 9.58342 17.375C13.6084 17.375 16.8751 14.1 16.8751 10.0833C16.8751 6.06667 13.6084 2.79167 9.58342 2.79167Z" fill="var(--active-color-modal)" />
                                                        <path d="M18.3333 19.4583C18.175 19.4583 18.0166 19.4 17.8916 19.275L16.225 17.6083C15.9833 17.3667 15.9833 16.9667 16.225 16.725C16.4666 16.4833 16.8666 16.4833 17.1083 16.725L18.775 18.3917C19.0166 18.6333 19.0166 19.0333 18.775 19.275C18.65 19.4 18.4916 19.4583 18.3333 19.4583Z" fill="var(--active-color-modal)" />
                                                    </svg>
                                                    <%--<textarea maxlength="50" name="task-description" rows="2" class="form-control" placeholder="search..." id="txtSearchCat" onkeyup="searchCategory(this);"></textarea>--%>
                                                    <textarea maxlength="50" name="task-description" rows="2" class="form-control search-bar" placeholder="Search..." id="txtSearchCat" onkeyup="searchCategory(this);" style="box-shadow: none; padding-left: 5rem; background-color: white !important;"></textarea>
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
                                            <table style="width: 100%; margin-top: 35px;" id="containerMP">
                                                <tr>
                                                    <td onclick="setMultiPorter();">
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
                                                <label id="lblPatientDetails">Patient Details <span style="font-size: 11px">(Name/ DOB / Hospital No)</span></label>
                                                <div class="col-md-8">
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
                                                <div class="col-md-4" id="divEndDate" style="display: inline-block; padding-top: 30px;">

                                                    <fieldset style="height: 50px;">
                                                        <label>End Date :- &nbsp <span style="font-size: 12px" id="lblEndDate"></span></label>
                                                    </fieldset>

                                                </div>
                                            </div>
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

                            <div class="custom-calendar-wrap">

                                <div class="RequestIcons" style="padding: 20px">


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
                                                data-bs-dismiss="modal">
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

                                        <div class="col-md-11" id="divOccurrence">
                                            <div class="switch-button_Occurrence">
                                                <label style="color: white">
                                                    Occurrence
                                                </label>
                                                <label class="switchOccurrence">
                                                    <input type="checkbox" id="chkCancelOccurrence">
                                                    <span class="slideroccurrence round"></span>
                                                </label>
                                            </div>
                                        </div>
                                        <div class="col-md-11" align="center">

                                            <img src="../images/Delete.png" id="ImgDeleteReq" style="cursor: pointer; margin-top: 20px;" onclick="CancelRequest();return false;" />
                                        </div>
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

        <%-- <div id="ModalMTDone" class="modal fade" role="dialog">
            <div class="modal-dialogLoc" align="center">
                <table style="margin-top: 100px; background: white; height: 100px; border-radius: 20px;">
                    <tr>
                        <td style="line-height: 25px; text-align: center; vertical-align: middle; padding: 20px;">
                            <span id="spanMT" style="font-size: 11pt; color: #c10000; font-weight: bold;">Tasks <span id="spanMTTasks"></span>been assigned to  <span id="spanMTPorter" style="color: rgb(30, 70, 129); font-size: 12pt; text-shadow: 1px 1px 1px #c5cae9;"></span>Successfully </span>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        --%>
        <!-- Success Modal -->
        <div class="modal fade" id="ModalMTDone" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
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
    </form>
</body>

</html>

