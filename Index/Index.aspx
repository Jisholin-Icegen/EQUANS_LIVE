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


            //var AutoRefresh = window.setInterval(function () {
            //    fn_refreshAll();
            //}, 30000);

            var PorterCurTasks = '', PendingTasks = '', ATPorterID = '', ATPorterName = '', ATStatus = '', ATReqNB = '';

            //var MTCount = 60, MTInterval = window.setInterval(function () { processMT(MTCount); }, 1000);


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
                    var IsPreBook = $(this).prop('checked');

                    $('#containerDate').css("display", IsPreBook ? "block" : "none");
                    $('#containerTime').css("display", IsPreBook ? "block" : "none");

                    RPreBook = (IsPreBook) ? "2" : "0";

                });

                $('#chkMultiPorter').on('change', function () {
                    const img = $('#chkMultiPorterImg');
                    if ($(this).is(':checked')) {
                        img.attr('src', '../images/MCheck.jpg');
                    } else {
                        img.attr('src', '../images/NoMCheck.jpg');
                    }
                    setMultiPorter();
                });

                function setMultiPorter() {
                    var IsMT = $('#chkMultiPorter').prop('checked');
                    IsMTPR = (IsMT) ? "1" : "0";
                }

                $(document).ready(function () {
                    $('#chkPreBook').trigger('change');
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
                    //Reload = window.setInterval(ReloadLinks, 60000);
                });

                $("#txtFromLoc").keyup(function () {
                    if (ServiceCode != '3')
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

                $('#DivKitchenFilters').css("visibility", (ServiceCode == "2") ? "visible" : "hidden");
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

                var rgbaColor = rgbColor.replace('rgb', 'rgba').replace(')', ', 0.1)');

                $(':root').css('--active-color-modal', rgbColor);
                $(':root').css('--active-bg-color-modal', rgbaColor);
            }

            function setRequestChanges(ServiceCode, Process) {

                switch (ServiceCode) {
                    case "1":
                        if (Process === 'New' || Process === 'Update') {
                            LoadCategories('');
                        }
                        $('#containerMP').css("display", "inline-block");
                        $('#containerPatient').css("display", "inline-block");
                        $('#divQuantity').css("visibility", "hidden");
                        $('#txtFromLoc').val('');
                        $('#txtFromLoc').prop("readonly", false);
                        setTimeout(() => { $('#txtFromLoc').focus(); }, 500);

                        LoadEquipment('a', ServiceCode);
                        $('#verifyDeliverySection').hide();
                        $("#suggesstionTo").hide();
                        $('#lblKPITS').html('-');
                        $('#lblKPITE').html('-');
                        $('.message-menu-item').hide();
                        $('#containerCat, #containerKPI, #tdKPICompletion, #tdKPIResponse, #parentcontainerMP')
                            .css('background-color', '#6dadff');
                        break;

                    case "2":
                        var bgcolor = "#6dadff";
                        $('#containerMP').css("display", "inline-block");
                        setDefaultCategoryIfService2();
                        $('#containerPatient').css("display", "none");
                        $('#divQuantity').css("visibility", "visible");
                        $('#verifyDeliverySection').show();
                        BindLocation('9028', 'RECEIPT & DISTRIBUTION', 'SF', 'NO', '', '');

                        setTimeout(() => {
                            $('#txtFromLoc')
                                .val('RECEIPT & DISTRIBUTION')
                                .attr('data-locid', '9028')
                                .trigger('input')
                                .trigger('change');

                            if (Process !== 'Update') {
                                const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                                const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';
                                setRequestChanges(serviceId, 'Update');
                            }
                        }, 300);

                        LoadEquipment('Tr', ServiceCode);
                        $("#suggesstionFrom").hide();
                        setTimeout(() => { $('#txtFromLoc').focus(); }, 500);
                        $('#lblKPITS').html('-');
                        $('#lblKPITE').html('-');
                        $('.message-menu-item').show();
                        $('#containerCat, #containerKPI, #tdKPICompletion, #tdKPIResponse, #parentcontainerMP')
                            .css('background-color', bgcolor);
                        break;
                }

                if (Process == 'New') {
                    LoadPresetRemarks();
                    LoadEquipmentOnInit(ServiceCode);

                }
            }

            function fixAllAriaHiddenWarnings() {

                $('.modal').on('show.bs.modal', function () {
                    $(this).removeAttr('aria-hidden');
                }).on('shown.bs.modal', function () {
                    $(this).removeAttr('aria-hidden');
                }).on('hide.bs.modal', function () {
                    if (document.activeElement && this.contains(document.activeElement)) {
                        document.activeElement.blur();
                    }
                }).on('hidden.bs.modal', function () {

                    $(this).attr('aria-hidden', 'true');

                    if (document.activeElement && this.contains(document.activeElement)) {
                        document.activeElement.blur();
                    }
                });

                $(document).on('click', 'button, .btn, [data-bs-dismiss="modal"]', function () {
                    $(this).blur();
                });

                if (bootstrap?.Modal?.prototype) {
                    const originalShow = bootstrap.Modal.prototype.show;
                    const originalHide = bootstrap.Modal.prototype.hide;

                    bootstrap.Modal.prototype.show = function () {
                        if (this._element) {
                            this._element.removeAttribute('aria-hidden');
                        }
                        return originalShow.call(this);
                    };

                    bootstrap.Modal.prototype.hide = function () {
                        if (this._element) {
                            const focused = this._element.querySelector(':focus');
                            if (focused) focused.blur();
                        }
                        return originalHide.call(this);
                    };
                }

                $('.modal.level-2').on('show.bs.modal', function () {
                    $(this).removeAttr('aria-hidden');
                }).on('shown.bs.modal', function () {
                    $(this).removeAttr('aria-hidden');
                }).on('hide.bs.modal', function () {
                    if (document.activeElement && this.contains(document.activeElement)) {
                        document.activeElement.blur();
                    }
                });

                const observer = new MutationObserver(function (mutations) {
                    mutations.forEach(function (mutation) {
                        if (mutation.type === 'attributes' && mutation.attributeName === 'aria-hidden') {
                            const target = $(mutation.target);
                            if (target.is(':visible') && target.attr('aria-hidden') === 'true') {
                                target.removeAttr('aria-hidden');
                            }
                        }
                    });
                });

                $('.modal').each(function () {
                    observer.observe(this, {
                        attributes: true,
                        attributeFilter: ['aria-hidden', 'style']
                    });
                });
            }

            $(document).ready(function () {
                fixAllAriaHiddenWarnings();

                $(document).ajaxComplete(function () {
                    fixAllAriaHiddenWarnings();
                });
            });

            function setDefaultLocationIfService2() {
                const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';

                if (serviceId === '2') {
                    BindLocation('9028', 'RECEIPT & DISTRIBUTION', 'SF', 'NO', '', '');

                    setTimeout(() => {
                        let $fromLoc = $('#txtFromLoc');

                        if (!$fromLoc.val() || $fromLoc.val().trim() === '') {
                            $fromLoc.val('RECEIPT & DISTRIBUTION').attr('data-locid', '9028').trigger('input').trigger('change');
                        }

                        $("#suggesstionFrom").hide();
                        $fromLoc.focus();
                    }, 300);

                    $('#txtFromLoc').off('input change').on('input change', function () {
                        let val = $(this).val().trim();
                        if (val.toUpperCase() === 'RECEIPT & DISTRIBUTION') {
                            $(this).attr('data-locid', '9028');
                        } else {
                            $(this).removeAttr('data-locid');
                        }
                    });
                }
            }

            window.addEventListener('DOMContentLoaded', () => {

                document.querySelectorAll('.services-btn-icon').forEach((btn) => {
                    btn.addEventListener('click', function () {
                        document.querySelectorAll('.services-btn-icon.active')
                            .forEach((activeBtn) => activeBtn.classList.remove('active'));

                        this.classList.add('active');

                        ServiceCode = this.id.replace("divService", "");
                        sessionStorage.setItem('ServiceCode', ServiceCode);

                    //    console.log("Selected service:", ServiceCode);
                    });
                });

                const defaultBtn = document.getElementById('divService1');
                if (defaultBtn) {
                    defaultBtn.click();
                } else {
                //    console.warn("divService1 not found.");
                }
            });


            function setDefaultCategoryIfService2() {
                const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';

                if (serviceId === "2") {
                    const assistantToggle = document.getElementById('chkMultiPorter');
                    if (assistantToggle) {
                        assistantToggle.checked = false;
                    }

                    ReqCat = "503";
                    LoadCategories('goo');

                    setTimeout(() => {
                        const chk = document.getElementById('chkCat503');
                        if (chk) {
                            chk.checked = true;
                            chk.dispatchEvent(new Event('change'));
                        }
                    }, 300);
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
                if (IsUser) {
                    getPorterStatus('0');
                }
                else {
                    var divTask = (CProcess == "0") ? "divTotalPercentage" : (CProcess == "2") ? "divPendingPercentage" : (CProcess == "3") ? "divAssignedPercentage" : (CProcess == "4") ? "divInprogressPercentage" : (CProcess == "6") ? "divCompletedPercentage" : (CProcess == "7") ? "divCancelledPercentage" : (CProcess == "8") ? "divPendingOnHoldPercentage" : (CProcess == "9") ? "divTatExceededPercentage" : (CProcess == "100") ? "divPrebookeddPercentage" : (CProcess == "100") ? "tdPreBook" : "divPendingPercentage";

                    if (fromPorterIcon)
                        Select("divPendingPercentage", "PENDING");
                    else
                    //    Select(divTask, "");
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

            //function setPreBookCat() {
            //    clearAllCheckBox('ReqCategories');
            //    ReqCat = ''; LoadCategories('');
            //}
            function LoadProcess(RequestStatusID) {



                var divReq = $("#tblRequests");
            // LoadTableRequest(RequestStatusID, divReq);

            //sessionStorage.getItem('ROLE', 'CONTROL ROOM');
               <%-- grid = $find('<%= GridRequest.ClientID %>');
                gridMasterTable = $find('<%= GridRequest.ClientID %>').get_masterTableView();--%>
                //  alert(gridMasterTable.get_virtualItemCount());
            }

            function ReloadLinks() {

                if (sessionStorage.getItem('ROLE') == null)
                    window.location = "../Login.aspx";
                //ReloadLinksButton();
            }


        </script>
    </telerik:RadCodeBlock>
    <style type="text/css">
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
            padding: 1px;
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
            /*            font-size: 14px !important;
*/
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

        .divtitleActive {
            border: 2px solid #334c5c;
            padding: 2px;
            border-radius: 5px;
        }

        .SumoSelect > .optWrapper > .options {
            text-align: left !important;
            max-height: 120px;
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

        .task-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1050;
        }

        .d-none {
            display: none !important;
        }
        /*
        .task-modal-content {
            background: white;
            padding: 30px;
            border-radius: 10px;
            min-width: 300px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
        }*/
        body {
            font-family: 'Inter', sans-serif;
/*          font-family: Arial, sans-serif;*/
          margin: 0;
          padding: 0;
          font-size: 14px;
        }

        h6 {
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 0.5rem;
        }

        .icon-bar i {
            font-size: 1rem;
            color: #6c757d;
            margin-right: 0.5rem;
        }

        .list-group-item {
            font-size: 13px;
        }

        .badge {
            font-size: 12px;
        }
        .column-container {
            display: flex;
            flex-direction: column;
            height: 80vh;
            min-height: 0;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 15px;
            border: 1px solid #dee2e6;
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }

        .scrollable-list {
            flex: 1 1 auto;
            min-height: 0;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            background-color: #fff;
            padding: 5px 0 0 5px;
            box-sizing: border-box;
        }

        .scrollable-list .task, 
        .scrollable-list .data-row {
            padding: 8px 12px;
            border-radius: 6px;
            transition: 
              background-color 0.5s ease-in-out, 
              box-shadow 0.5s ease-in-out,
              transform 0.4s ease-in-out,
              border-color 0.5s ease-in-out;
            cursor: pointer;
            border: 1px solid transparent; /* for smooth border transition */
        }

        .scrollable-list .task:hover, 
        .scrollable-list .data-row:hover {
            background-color: #f8f9fa; /* lighter grey for subtlety */
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
            transform: translateY(-3px) scale(1.02);
            border-color: #b0c4de; /* subtle border highlight */
        }

        .icon-bar {
            display: flex;
            flex-direction: column;
            gap: 15px;
            align-items: center;
            background: #fff;
            padding: 10px;
            border-radius: 8px;
        }

        /*    .task {
        background-color: #f8f9fa; 
        border: 1px solid #e0e0e0; 
        border-radius: 8px; 
        padding: 5px 10px; 
        width: 100%; 
        box-sizing: border-box; 
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); 
        font-size: 14px; 
        overflow: hidden; 
        white-space: nowrap; 
        text-overflow: ellipsis; 
    }*/

        .task-line {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            color: #444;
            font-family: sans-serif;
            flex: 1 1 auto;
        }

            .task-line i {
                font-size: 16px;
                color: #6c757d;
            }

                .task-line i:hover {
                    color: #495057;
                }

            .task-line span {
                background-color: #f0f4ec;
                padding: 2px 6px;
                border-radius: 4px;
                font-size: 13px;
                white-space: nowrap;
            }

        .column-container h6 {
            font-weight: bold;
            color: #007bff;
            font-size: 18px;
        }

        .screen-left-panel {
            width: 400px;
            height: 100vh;
            background: #f8f8f8;
            position: fixed;
            z-index: 1050 !important;
            left: 0;
            top: 0;
            overflow-y: auto;
            overflow-x: hidden;
            opacity: 1;
            transform: translateX(0);
            box-shadow: 2px 0 12px rgba(0,0,0,0.08);

            /* Slightly faster, smooth slide/fade */
            transition: 
                transform 0.8s cubic-bezier(0.65, 0, 0.35, 1),
                opacity 0.8s ease-in-out,
                width 0.8s ease-in-out;
        }

        .screen-left-panel.hidden {
            opacity: 0;
            transform: translateX(-100%);
            pointer-events: none;
            width: 0;
            overflow: hidden;
        }

        .hospital-img {
            opacity: 1;
            transition: opacity 0.6s ease-in-out;
        }

        .hospital-img.hidden {
            opacity: 0;
            pointer-events: none;
        }

        #hamburger i {
            font-size: 32px;
            color: #555;
            cursor: pointer;
            transition: color 0.25s ease, transform 0.25s ease;
        }

        #hamburger i:hover {
            color: #000;
            transform: scale(1.1);
        }

        #left-icons-container {
            width: 60px;
            background-color: #fafafa;
            box-shadow: 1px 0 6px rgba(0,0,0,0.05);
        }

        .icon-bar {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 8px 0;
            gap: 6px;
        }

        .icon {
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            cursor: pointer;
            background-color: transparent;
            opacity: 1;
            transform: translateY(0);
            transition: 
                opacity 0.4s ease-in-out,   /* faster fade */
                transform 0.4s ease-in-out, /* faster slide */
                background-color 0.25s ease;
        }

        .icon i {
            font-size: 24px;
            color: #555;
            transition: color 0.25s ease, transform 0.25s ease;
        }

        .icon:hover {
            background-color: #e8e8e8;
            transform: scale(1.05);
        }

        .icon-bar .icon:not(#hamburger).hidden {
            opacity: 0;
            pointer-events: none;
            transform: translateY(-6px);
        }

        .right-panel-backdrop {
            background-color: rgba(0, 0, 0, 0.5) !important;
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
            transition: opacity 0.6s ease, backdrop-filter 0.6s ease;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 1039;
            opacity: 0;
            pointer-events: none;
        }

        .right-panel-backdrop.active {
            opacity: 1;
            pointer-events: auto;
        }

        .right-panel-backdrop.hidden {
            opacity: 0;
            pointer-events: none;
        }

        .employee-card {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: flex-start; 
            gap: 0.25rem 0.5rem;
            padding: 0.4rem 0.75rem;
        }

        .employee-card > div.fw-bold {
            flex-shrink: 0;
            min-width: 150px;
            max-width: 150px;
            text-align: left;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .employee-card .text-muted.small {
            flex-grow: 1;
            flex-shrink: 1;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            min-width: 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .employee-card > span.employee-action {
            flex-shrink: 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-left: 0.25rem;
            max-width: 90px;
        }

        .employee-card > .dropdown {
            flex-shrink: 0;
            display: flex;
            align-items: center;
            margin-left: auto;
            white-space: nowrap;
        }

        .employee-card .badge {
            flex-shrink: 0;
            max-width: 140px;
            white-space: nowrap;
            padding: 0.2em 0.45em;
            border-radius: 0.25rem;
            text-align: center;
            margin-left: 0.25rem;
        }

        .form-control {
            max-width: 100%;
        }

        .tag {
            background-color: #eee;
            padding: 8px 14px;
            border-radius: 20px;
            display: inline-block;
            margin: 6px 10px 6px 0;
            cursor: pointer;
            font-weight: 500;
            color: #1e4a7b;
            border: 1px solid #ccc;
            transition: all 0.2s ease;
        }

        .right-corner {
            display: flex;
            align-items: center;
            margin-left: auto; 
            gap: 0.5rem;
            position: relative;
            white-space: nowrap;
        }

        .right-corner .employee-action {
            flex: 0 0 auto;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 90px;
        }

        .right-corner .dropdown {
            flex-shrink: 0;
            display: flex;
            align-items: center;
        }

        .right-corner .badge {
            flex-shrink: 0;
            max-width: 140px;
            white-space: nowrap;
            padding: 0.2em 0.45em;
            border-radius: 0.25rem;
            text-align: center;
        }

        .right-corner .kpi-indicator {
            position: absolute;
            top: -23px;
            right: -15px;
            width: 2.5px;
            height: 300%;
            background-color: red;
            border-radius: 1px;
        }

        input[type="checkbox"]:checked + label.tag {
            background-color: #1e4a7b;
            color: white;
            border-color: #1e4a7b;
        }

        .screen-right-panel {
            position: fixed;
            top: 0;
            left: 90px;
            width: calc(100vw - 60px);
            height: 100vh;
            transition: left 0.3s ease, width 0.3s ease;
            z-index: 100;
        }

        .disabled-option {
            opacity: 0.5;
            pointer-events: none;
            cursor: not-allowed;
            user-select: none;
        }

        select.form-select {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background-image: none;
        }

        .filter-wrapper {
            position: relative;
        }

        .filter-panel {
            display: none;
            position: absolute;
            top: 2.2rem;
            right: 0;
            width: 360px;
            max-width: 90vw;
            background: white;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
            padding: 1rem;
            z-index: 1050;
        }

        @media (max-width: 400px) {
            .filter-panel {
                width: 90vw !important;
                right: auto;
                left: 0;
            }
        }

        button#btnReqSubmit {
            background-color: #007bff;
            color: white;
            padding: 12px 18px;
            font-weight: bold;
            border-radius: 8px;
            border: none;
            transition: background 0.3s;
        }

        button#btnReqSubmit:hover {
            background-color: #0056b3;
        }

        button.btn-outline {
            background-color: white;
            color: #333;
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 12px 18px;
            transition: background 0.3s;
        }

            button.btn-outline:hover {
                background-color: #f0f0f0;
            }

        #containerRequestor, #containerContact, #divSelRemarks {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 15px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        textarea.form-control,
        input.form-control,
        select.form-control {
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            background-color: #fff;
            transition: border-color 0.2s;
        }

            textarea.form-control:focus,
            input.form-control:focus,
            select.form-control:focus {
                border-color: #007bff;
                outline: none;
                box-shadow: 0 0 0 2px rgba(0,123,255,0.2);
            }

        #containerTaskType {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 15px;
        }

        .task-button {
            background-color: white;
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 15px 20px;
            width: 160px;
            text-align: center;
            cursor: pointer;
            font-weight: 600;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

            .task-button:hover {
                background-color: #f5f5f5;
                border-color: #007bff;
            }

        .row {
            margin: 0;
        }

        .col-md-8,
        .col-md-4 {
            padding: 10px;
        }

        .custom-calendar-wrap {
            position: absolute;
            top: -885px !important;
            right: -525px;
            margin-top: 0 !important;
            padding-top: 0 !important;
            width: 380px;
            max-height: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
            z-index: 999;
            border-top-left-radius: 0;
            border-top-right-radius: 0;
            margin: 0 !important;
            background: transparent !important;
            box-shadow: none !important;
            border: none !important;
            height: 30px !important;
            padding: 6px 10px !important;
            font-size: 13px !important;
            resize: none !important;
        }

            .custom-calendar-wrap.prebook-on {
                top: -970px !important;
            }

        .form-wrap {
            margin-left: -330px;
            margin-right: auto;
            float: none;
            text-align: left;
        }

        .custom-modal-content {
            background-color: #f0f0f0;
            border-radius: 10px;
            padding: 20px;
        }

        .RequestIcons {
            pointer-events: auto !important;
            position: relative;
            z-index: 2000;
        }

        input.form-control-sm {
            width: 100% !important;
            box-sizing: border-box;
        }

        .select2-container--default .select2-selection--single {
            height: 50px;
            font-size: 18px;
            padding: 8px 12px;
            background-color: #e0e0e0 !important; /* Grey background */
            border-radius: 4px;
            border: 1px solid #bdbdbd;
            color: #333;
        }

            .select2-container--default .select2-selection--single .select2-selection__rendered {
                line-height: 34px;
                color: #333;
            }

            .select2-container--default .select2-selection--single .select2-selection__arrow {
                top: 12px;
            }

        .select2-container--default .select2-results__option {
            font-size: 18px;
            padding: 10px 15px;
            background: #f5f5f5;
            color: #222;
        }

        .select2-dropdown {
            background-color: #e0e0e0 !important; /* Grey dropdown */
            border: 1px solid #bdbdbd;
        }

        #ddlCancelReasons, #ddlCancelReasons option {
            text-transform: none !important;
        }

        #breakDurationSelect option {
            padding: 10px;
        }

        #confirmBreakBtn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
        }

        #confirmBreakBtn:not(:disabled):hover {
            background-color: #138d75;
        }

        .custom-checkbox input[type="checkbox"] {
            /* Hide native checkbox */
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
            margin: 0;
            cursor: pointer;
        }

        .custom-checkbox {
            position: relative;
            user-select: none;
        }

          .custom-checkbox span {
                /* This is the label text, no changes needed here */
            }

            .custom-checkbox::before {
                content: "";
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 2.5px solid #007bff; 
                border-radius: 4px; 
                background-color: white;
                margin-right: 10px;
                vertical-align: middle;
                transition: background-color 0.3s, border-color 0.3s;
            }

            .custom-checkbox input[type="checkbox"]:checked + span::before,
            .custom-checkbox input[type="checkbox"]:checked::before {
                background-color: #007bff; /* Blue fill */
                border-color: #007bff;
            }

            .custom-checkbox input[type="checkbox"]:checked::after {
                content: "✓";
                position: absolute;
                left: 4px;
                top: 0px;
                font-size: 18px;
                color: white;
                font-weight: bold;
                pointer-events: none;
            }

            editTaskModal formEditTask .row > .col-md-6 {
                width: auto !important;
                max-width: 50% !important;
                flex: 0 0 50%;
            }

            #editTaskModal {
              z-index: 1060 !important;
            }
            .modal-backdrop {
              z-index: 1055 !important;
            }

        #editTaskModal .modal-content {
            border-radius: 10px;
            font-family: "Segoe UI", sans-serif;
        }

        #editTaskModal .form-label {
            letter-spacing: 0.3px;
            font-size: 14px;
            color: #444;
        }

        #editTaskModal .form-select,
        #editTaskModal .form-control {
            border-radius: 6px;
            padding: 10px 12px;
        }

        #editTaskModal .modal-header {
            border-bottom: 0;
        }

        #editTaskModal .modal-footer {
            border-top: 1px solid #dee2e6;
        }

        #reassignModalLabel {
            color: black !important;
        }

        #editTaskModal .form-control {
            font-size: 0.95rem; 
            font-weight: 600;  slightly bold 
            color: #000;  black text 
            padding: 0.5rem 0.75rem;  more padding for bigger box 
            border-radius: 0.375rem;  slightly rounded corners 
        }

        #editTaskModal label.fw-bold {
            font-weight: 600;
            color: #000;
        }

        #editTaskModal .modal-dialog {
            max-width: 10px;
        }

        #editTaskModal .modal-title {
            font-weight: 600;
            color: #000;
        }

        #editTaskModal .btn {
            font-size: 0.95rem;
            font-weight: 600;
        }
        #editTaskModal #formEditTask {
            display: block;
        }

        .compact-navbar {
            background: linear-gradient(90deg, #e3f0fd 50%, #fff7f0 100%);
            box-shadow: 0 2px 8px rgba(120,155,200,0.09);
            padding: 0.5em 1.2em;
            min-height: 44px;
            height: 48px;
        }

        .compact-user-panel {
            display: flex;
            align-items: center;
            gap: 0.65em;
            padding: 0.2em 0.7em;
            border-radius: 1.1em;
            background: linear-gradient(135deg, #a6d4ff 0%, #c4f0ff 100%);
            box-shadow: 0 1px 5px rgba(120,155,200,0.10);
            min-width: 120px;
            max-width: 280px;
            color: #000; 
        }

        .user-avatar {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 1px 4px rgba(160,200,255,0.13);
        }

        .avatar-img {
            width: 28px;
            height: 28px;
            border-radius: 50%;
        }

        .welcome-animation {
            font-size: 1.08em;
            color: #31417d;
            font-family: 'Poppins', 'Inter', sans-serif;
            animation: welcomePulse 2.2s infinite;
        }

        @keyframes welcomePulse {
            0%,100% {
                opacity: 1;
            }

            45% {
                opacity: .88;
            }

            70% {
                opacity: .7;
            }
        }

        .user-name {
            font-weight: 700;
            font-size: 1em;
            color: #26477b;
            letter-spacing: .3px;
            margin-left: 2px;
        }

        .switch-bubble {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 6px 14px;
            border-radius: 24px;
            background: linear-gradient(135deg, #a6d4ff, #c4f0ff); 
            width: max-content;
            gap: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08); 
            font-weight: 600;
            font-family: 'Poppins', sans-serif;
            transition: background 0.3s;
        }

        .switch-bubble .switch-label {
            color: #26477b; 
            font-size: 14px;
            user-select: none;
            transition: color 0.3s;
        }

        .switch-auto {
            position: relative;
            display: inline-block;
            width: 44px;
            height: 24px;
        }

        .switch-auto input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider-auto {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: #d0e7ff; 
            transition: background 0.3s;
            border-radius: 24px;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.08);
        }

        .slider-auto.round:before {
            position: absolute;
            content: "";
            height: 20px;
            width: 20px;
            left: 2px;
            bottom: 2px;
            background: white;
            transition: transform 0.3s, background 0.3s;
            border-radius: 50%;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }

        .switch-auto input:checked + .slider-auto {
            background: linear-gradient(135deg, #4fc3ff, #00f2fe);
        }

        .switch-auto input:checked + .slider-auto.round:before {
            transform: translateX(20px);
            background: #ffffff;
        }

        .switch-auto:hover .slider-auto {
            background: #cce5ff; 
        }

        .switch-bubble:hover .switch-label {
            color: #1a3e6a;
        }

        #bulkRequestList {
          transition: opacity 0.25s ease;
        }

        .task-row.fade-in {
          opacity: 0;
          animation: fadeIn 0.4s ease forwards;
        }

        .task-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem; 
            padding: 0.5rem;
            width: 100%;
            border-bottom: 1px solid #e0e0e0; 
        }

        .task-category {
            font-weight: 600;
            color: #212529;
            min-width: 150px;
            text-align: left;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .task-details {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .task-from,
        .task-to,
        .task-equipment-name,
        .task-patient-name {
            font-weight: 500;
            color: #343a40;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .task-contact-no {
            font-size: 0.85rem;
            color: #6c757d;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .task-requestor-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            color: black;
        }

        .task-requestor-info i {
            color: #6c757d;
        }

        .right-corner {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            justify-content: flex-end;
            min-width: 100px; 
        }

        .task-badge {
            background-color: #0d6efd;
            padding: 0.2rem 0.5rem;
            border-radius: 0.375rem;
            font-size: 0.75rem;
            color: white;
            user-select: none;
            text-align: center;
            min-width: 80px;
        }

        .bi, .fas {
            font-size: 1rem;
            vertical-align: middle;
            transition: color 0.3s ease;
            will-change: color;
        }

        .bi:hover, .fas:hover {
            cursor: pointer;
            color: #2c3e50;
            transform: scale(1.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
        }

        @media (max-width: 576px) {
            .task-row {
                flex-direction: column; 
            }

            .task-category {
                min-width: 100%; 
                text-align: center;
            }

            .task-details {
                width: 100%; 
            }

            .right-corner {
                justify-content: flex-start;
                width: 100%; 
                gap: 1rem;
            }
        }

        .employee-card .badge {
          margin-left: 0.5rem;
          padding: 0.25em 0.6em;
          font-size: 0.75rem;
          font-weight: 600;
          border-radius: 0.375rem;
          white-space: nowrap;
          user-select: none;
        }

        @media (max-width: 576px) {
          .employee-card {
            flex-wrap: wrap;
            gap: 0.75rem;
          }
          .employee-card .fw-bold {
            min-width: 100%;
          }
        }

        @keyframes fadeIn {
          from { opacity: 0; transform: translate3d(0, 4px, 0); }
          to { opacity: 1; transform: translate3d(0, 0, 0); }
        }

        html, body {
          -webkit-font-smoothing: antialiased;
          -moz-osx-font-smoothing: grayscale;
          text-rendering: optimizeLegibility;
          image-rendering: auto;
        }

        .use-gpu, .modal-dialog, .loading::after, .pop-animate {
          transform: translate3d(0, 0, 0);
          backface-visibility: hidden;
          will-change: transform, opacity;
        }

        .loading::after {
          content: "Loading...";
          display: block;
          text-align: center;
          color: #666;
          font-weight: 500;
          font-size: 1rem;
          padding: 8px;
          animation: pulse 1.4s cubic-bezier(.4, 0, .2, 1) infinite;
          will-change: opacity;
        }

        @keyframes pulse {
          0%, 100% { opacity: 0.35; }
          50% { opacity: 1; }
        }

        .modal.fade .modal-dialog {
            transition: transform 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94), opacity 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            transform: translate3d(0, -30px, 0);
            opacity: 0;
            will-change: transform, opacity;
        }
        .modal.fade.show .modal-dialog {
            transform: translate3d(0, 0, 0);
            opacity: 1;
        }

        .modal-body.px-4.py-4 {
          padding: 1.5rem;
          background: rgba(240, 243, 255, 0.3);
          border-radius: 0 0 20px 20px;
          box-shadow: 0 4px 14px rgba(0, 0, 0, 0.05), 0 12px 30px rgba(0, 0, 0, 0.04);
          backdrop-filter: blur(8px) saturate(1.15); 
          -webkit-backdrop-filter: blur(8px) saturate(1.15);
          will-change: transform, opacity;
        }

        @media (prefers-reduced-motion: reduce) {
          * {
            animation: none !important;
            transition-duration: 0ms !important;
            transform: none !important;
          }
        }
 
        #btnCloseEditTaskModal img {
          filter: drop-shadow(0 0 4px rgba(255, 255, 255, 0.6));
          transition: filter 260ms cubic-bezier(.4, 0, .2, 1);
          will-change: filter;
        }

        #btnCloseEditTaskModal:hover img {
          filter: drop-shadow(0 0 12px rgba(255, 255, 255, 0.9));
        }

        .remark-field {
          font-weight: 650;
          color: #212529;
        }

        .remark-field::placeholder {
          color: #6c757d;
          font-weight: 400;
        }

        @keyframes popIn {
          0% {
            opacity: 0;
            transform: scale(0.94);
          }
          70% {
            opacity: 1;
            transform: scale(1.04);
          }
          100% {
            opacity: 1;
            transform: scale(1);
          }
        }

        .pop-animate {
          animation: popIn 380ms cubic-bezier(0.16, 1, 0.3, 1);
          will-change: opacity, transform;
        }

        img, svg {
          shape-rendering: geometricPrecision;
          image-rendering: auto;
        }

        @media (min-resolution: 2dppx) {
          .icon { background-image: url('icon@2x.png'); }
        }

        @media (min-resolution: 3dppx) {
          .icon { background-image: url('icon@3x.png'); }
        }

        .gradient-smooth {
          background: linear-gradient(135deg, #eef1ff 0%, #d9e0ff 100%);
          filter: saturate(1.15);
        }

        @media (prefers-reduced-motion: reduce) {
          * {
            animation: none !important;
            transition-duration: 0ms !important;
            transform: none !important;
          }
        }

        .modal-backdrop {
            background-color: rgba(0, 0, 0, 0.5) !important;
            position: fixed !important;
            top: 0; right: 0; bottom: 0; left: 0;
            z-index: 1040 !important; 
            display: block !important;
            transition: background-color 0.15s ease !important;
        }

        .modal {
            z-index: 1050 !important;
        }

        .modal-backdrop,
        .modal-backdrop.show {
            background-color: rgba(0, 0, 0, 0.5) !important;
            backdrop-filter: none !important;
            -webkit-backdrop-filter: none !important;
            transition: background-color 0.15s ease !important;
            position: fixed !important;
            z-index: 1040 !important;
        }

        body.modal-open .right-panel-backdrop {
            opacity: 0 !important;
            pointer-events: none !important;
            backdrop-filter: none !important;
            -webkit-backdrop-filter: none !important;
        }

        #reassignModal {
          z-index: 1050 !important; 
        }

        .modal-backdrop.fade {
          transition: none !important;
        }

        .modal.fade {
            transition: opacity 0s linear 0s !important;
        }
        .modal.fade.show {
            transition: opacity 0.15s linear 0s !important;
        }

        .modal-content {
          border-radius: 18px;
          box-shadow: 0 8px 32px rgba(31, 38, 135, 0.15), 0 1.5px 4px rgba(0,0,0,0.10);
          background: rgba(255,255,255,0.98); 
          border: none;
          backdrop-filter: blur(10px);
        }

        .bg-gradient-primary {
          background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
        }

        .modal-content.shadow-lg {
          box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
        }

        .btn-primary:hover {
          background: linear-gradient(135deg, #2d9c8f 0%, #1b5d52 100%);
          box-shadow: 0 4px 12px rgba(45, 156, 143, 0.4); 
          color: #fff;
          transform: scale(1.05);
          transition: transform 0.3s ease, background 0.3s ease, box-shadow 0.3s ease;
        }

        #requestorModalContent::-webkit-scrollbar {
          width: 8px;
        }
        #requestorModalContent::-webkit-scrollbar-thumb {
          background-color: rgba(37, 117, 252, 0.6);
          border-radius: 4px;
        }
        #requestorModalContent::-webkit-scrollbar-track {
          background: rgba(0,0,0,0.05);
          border-radius: 4px;
        }
        .modal.level-1 {
            z-index: 1050;
        }
        .modal.level-2 {
            z-index: 1060; /* ABOVE reassign modal */
        }

        .modal-backdrop.level-1 {
            z-index: 1040;
        }
        .modal-backdrop.level-2 {
            z-index: 1055; /* ABOVE backdrop of modal 1 */
        }
 
        .modal-xl-custom {
            max-width: 45%; /* Increase width */
            width: 45%;     /* Optional, ensures consistency */
        }

        #modalAlert .modal-content {
            background: #ffffff;                 /* clean white background */
            border-radius: 0.75rem;              /* smooth corners */
            padding: 20px 20px;                  /* slightly reduced padding */
            max-width: 350px;                     /* smaller width */
            width: 90%;                            /* responsive for smaller screens */
            box-shadow: 0 8px 20px rgba(0,0,0,0.25); /* elegant shadow */
            text-align: center;
            border: none;                         /* no border */    
            color: #212529;                      /* dark, readable text */
            font-family: 'Segoe UI', Tahoma, sans-serif; 
            font-size: 1.05rem;                  /* slightly smaller font */
            font-weight: 600;
            line-height: 1.4;

            animation: popIn 0.35s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes popIn {
            0% {
                opacity: 0;
                transform: scale(0.9);
            }
            70% {
                opacity: 1;
                transform: scale(1.05);
            }
            100% {
                opacity: 1;
                transform: scale(1);
            }
        }

        #modalAlert .modal-footer button {
            padding: 8px 16px;                   
            border: none;
            background-color: #007bff;           
            color: #ffffff;
            font-weight: 600;
            border-radius: 0.35rem;
            cursor: pointer;
            transition: background-color 0.25s ease;
        }

        #modalAlert .modal-footer button:hover {
            background-color: #0056b3;
        }

        #taskList {
          transition: opacity 0.3s ease-in-out;
          will-change: opacity;
        }

        #taskList.refreshing {
          opacity: 0.5;
        }

        .modal#modalEmployeeActionSuccess {
          z-index: 1055 !important;  
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
            padding: 1px;
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
            min-height: 400px;
            max-width: 1100px;
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
            width: 100%;
        }

        .form-control {
            background-color: white;
        }

        .SumoSelect > .optWrapper > .options li label {
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

        .divtitleActive {
            border: 2px solid #334c5c;
            padding: 2px;
            border-radius: 5px;
        }

        .SumoSelect > .optWrapper > .options {
            text-align: left !important;
            max-height: 120px;
        }

        .RadGrid_Metro .rgHeader, .RadGrid_Metro th.rgResizeCol, .RadGrid_Metro .rgMultiHeaderRow th.rgHeader, .RadGrid_Metro .rgMultiHeaderRow th.rgResizeCol {
            border: 1px solid #CFE4FF !important;
        }

            .RadGrid_Metro .rgHeader, .RadGrid_Metro .rgHeader a {
                color: #303537 !important;
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

        .task-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1050;
        }

        .d-none {
            display: none !important;
        }

        body {
          font-family: 'Inter', sans-serif;
          margin: 0;
          padding: 0;
          font-size: 14px;
        }

        h6 {
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 0.5rem;
        }

        .icon-bar i {
            font-size: 1rem;
            color: #6c757d;
            margin-right: 0.5rem;
        }

        .list-group-item {
            font-size: 13px;
        }

        .badge {
            font-size: 12px;
        }
        /* Base container styling */
        .column-container {
            display: flex;
            flex-direction: column;
            height: 80vh;
            min-height: 0;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 15px;
            border: 1px solid #dee2e6;
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }

        /* Scrollable list */
        .scrollable-list {
            flex: 1 1 auto;
            min-height: 0;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            background-color: #fff;
            padding: 5px 0 0 5px;
            box-sizing: border-box;
        }

        .scrollable-list .task, 
        .scrollable-list .data-row {
            padding: 8px 12px;
            border-radius: 6px;
            transition: 
              background-color 0.5s ease-in-out, 
              box-shadow 0.5s ease-in-out,
              transform 0.4s ease-in-out,
              border-color 0.5s ease-in-out;
            cursor: pointer;
            border: 1px solid transparent; /* for smooth border transition */
        }

        .scrollable-list .task:hover, 
        .scrollable-list .data-row:hover {
            background-color: #f8f9fa; /* lighter grey for subtlety */
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
            transform: translateY(-3px) scale(1.02);
            border-color: #b0c4de; /* subtle border highlight */
        }

        .icon-bar {
            display: flex;
            flex-direction: column;
            gap: 15px;
            align-items: center;
            background: #fff;
            padding: 10px;
            border-radius: 8px;
        }

        /*    .task {
        background-color: #f8f9fa; 
        border: 1px solid #e0e0e0; 
        border-radius: 8px; 
        padding: 5px 10px; 
        width: 100%; 
        box-sizing: border-box; 
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); 
        font-size: 14px; 
        overflow: hidden; 
        white-space: nowrap; 
        text-overflow: ellipsis; 
    }*/

        .task-line {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            color: #444;
            font-family: sans-serif;
            flex: 1 1 auto;
        }

            .task-line i {
                font-size: 16px;
                color: #6c757d;
            }

                .task-line i:hover {
                    color: #495057;
                }

            .task-line span {
                background-color: #f0f4ec;
                padding: 2px 6px;
                border-radius: 4px;
                font-size: 13px;
                white-space: nowrap;
            }

        /*    .column-container {
        padding: 10px;
        background-color: #ffffff;  
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        overflow: hidden;
    }*/

        .column-container h6 {
            font-weight: bold;
            color: #007bff; /* Blue color for column titles */
            font-size: 18px;
        }

        .screen-left-panel {
            width: 400px;
            height: 100vh;
            background: #f8f8f8;
            position: fixed;
            z-index: 1050 !important;
            left: 0;
            top: 0;
            overflow-y: auto;
            overflow-x: hidden;
            opacity: 1;
            transform: translateX(0);
            box-shadow: 2px 0 12px rgba(0,0,0,0.08);

            /* Slightly faster, smooth slide/fade */
            transition: 
                transform 0.8s cubic-bezier(0.65, 0, 0.35, 1),
                opacity 0.8s ease-in-out,
                width 0.8s ease-in-out;
        }

        .screen-left-panel.hidden {
            opacity: 0;
            transform: translateX(-100%);
            pointer-events: none;
            width: 0;
            overflow: hidden;
        }

        .hospital-img {
            opacity: 1;
            transition: opacity 0.6s ease-in-out;
        }

        .hospital-img.hidden {
            opacity: 0;
            pointer-events: none;
        }

        #hamburger i {
            font-size: 32px;
            color: #555;
            cursor: pointer;
            transition: color 0.25s ease, transform 0.25s ease;
        }

        #hamburger i:hover {
            color: #000;
            transform: scale(1.1);
        }

        #left-icons-container {
            width: 60px;
            background-color: #fafafa;
            box-shadow: 1px 0 6px rgba(0,0,0,0.05);
        }

        .icon-bar {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 8px 0;
            gap: 6px;
        }

        .icon {
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            cursor: pointer;
            background-color: transparent;
            opacity: 1;
            transform: translateY(0);
            transition: 
                opacity 0.4s ease-in-out,   /* faster fade */
                transform 0.4s ease-in-out, /* faster slide */
                background-color 0.25s ease;
        }

        .icon i {
            font-size: 24px;
            color: #555;
            transition: color 0.25s ease, transform 0.25s ease;
        }

        .icon:hover {
            background-color: #e8e8e8;
            transform: scale(1.05);
        }

        .icon-bar .icon:not(#hamburger).hidden {
            opacity: 0;
            pointer-events: none;
            transform: translateY(-6px); /* smaller offset for faster feel */
        }

        .right-panel-backdrop {
            background-color: rgba(0, 0, 0, 0.5) !important;
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
            transition: opacity 0.6s ease, backdrop-filter 0.6s ease;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 1039;
            opacity: 0;
            pointer-events: none; /* initially invisible */
        }

        .right-panel-backdrop.active {
            opacity: 1;
            pointer-events: auto;
        }

        .right-panel-backdrop.hidden {
            opacity: 0;
            pointer-events: none;
        }

        .employee-card {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: flex-start; /* use flex-start + gap */
            gap: 0.25rem 0.5rem;
            padding: 0.4rem 0.75rem;
        }

            .employee-card > div.fw-bold {
                flex-shrink: 0;
                min-width: 120px;
            }

            .employee-card .text-muted.small {
                flex: 1 1 auto; /* flexible and shrinkable */
                display: flex;
                align-items: center;
                gap: 0.5rem;
                min-width: 0; /* important to allow shrinking */
                white-space: nowrap; /* keep icons + text inline */
                overflow: hidden;
                text-overflow: ellipsis;
            }

                .employee-card .text-muted.small span,
                .employee-card .text-muted.small i {
                    margin-right: 0.3rem !important;
                }

            .employee-card > span.employee-action {
                flex: 0 0 auto;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                margin-left: 0.5rem;
                max-width: 90px; /* adjust as needed */
            }

            .employee-card > .dropdown {
                flex-shrink: 0; /* never shrink */
                display: flex;
                align-items: center;
                margin-left: auto; /* push to right */
                white-space: nowrap;
            }

            .employee-card .badge {
                flex-shrink: 0;
                max-width: 140px;
                white-space: nowrap; /* don't wrap badge text */
                padding: 0.2em 0.45em;
                border-radius: 0.25rem;
                text-align: center;
                margin-left: 0.25rem;
            }

        .form-control {
            max-width: 100%;
        }

        .tag {
            background-color: #eee;
            padding: 8px 14px;
            border-radius: 20px;
            display: inline-block;
            margin: 6px 10px 6px 0;
            cursor: pointer;
            font-weight: 500;
            color: #1e4a7b;
            border: 1px solid #ccc;
            transition: all 0.2s ease;
        }

        .right-corner {
            display: flex;
            align-items: center;
            margin-left: auto; /* pushes to right corner */
            gap: 0.5rem;
            position: relative;
            white-space: nowrap;
        }

        .right-corner .employee-action {
            flex: 0 0 auto;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 90px;
        }

        .right-corner .dropdown {
            flex-shrink: 0;
            display: flex;
            align-items: center;
        }

        .right-corner .badge {
            flex-shrink: 0;
            max-width: 140px;
            white-space: nowrap;
            padding: 0.2em 0.45em;
            border-radius: 0.25rem;
            text-align: center;
        }

        .right-corner .kpi-indicator {
            position: absolute;
            top: -23px;
            right: -15px;
            width: 2.5px;
            height: 300%;
            background-color: red;
            border-radius: 1px;
        }

        input[type="checkbox"]:checked + label.tag {
            background-color: #1e4a7b;
            color: white;
            border-color: #1e4a7b;
        }

        .screen-right-panel {
            position: fixed;
            top: 0;
            left: 90px;
            width: calc(100vw - 60px);
            height: 100vh;
            transition: left 0.3s ease, width 0.3s ease;
            z-index: 100;
        }

        .disabled-option {
            opacity: 0.5;
            pointer-events: none;
            cursor: not-allowed;
            user-select: none;
        }


        select.form-select {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background-image: none;
        }

        .filter-wrapper {
            position: relative;
        }

        .filter-panel {
            display: none;
            position: absolute;
            top: 2.2rem;
            right: 0;
            width: 360px;
            max-width: 90vw;
            background: white;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.1);
            padding: 1rem;
            z-index: 1050;
        }

        @media (max-width: 400px) {
            .filter-panel {
                width: 90vw !important;
                right: auto;
                left: 0;
            }
        }

        button#btnReqSubmit {
            background-color: #007bff;
            color: white;
            padding: 12px 18px;
            font-weight: bold;
            border-radius: 8px;
            border: none;
            transition: background 0.3s;
        }

        button#btnReqSubmit:hover {
            background-color: #0056b3;
        }

        button.btn-outline {
            background-color: white;
            color: #333;
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 12px 18px;
            transition: background 0.3s;
        }

            button.btn-outline:hover {
                background-color: #f0f0f0;
            }

        #containerRequestor, #containerContact, #divSelRemarks {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 15px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        textarea.form-control,
        input.form-control,
        select.form-control {
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            background-color: #fff;
            transition: border-color 0.2s;
        }

            textarea.form-control:focus,
            input.form-control:focus,
            select.form-control:focus {
                border-color: #007bff;
                outline: none;
                box-shadow: 0 0 0 2px rgba(0,123,255,0.2);
            }

        #containerTaskType {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 15px;
        }

        .task-button {
            background-color: white;
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 15px 20px;
            width: 160px;
            text-align: center;
            cursor: pointer;
            font-weight: 600;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

            .task-button:hover {
                background-color: #f5f5f5;
                border-color: #007bff;
            }

        .row {
            margin: 0;
        }

        .col-md-8,
        .col-md-4 {
            padding: 10px;
        }

        .custom-calendar-wrap {
            position: absolute;
            top: -885px !important;
            right: -525px;
            margin-top: 0 !important;
            padding-top: 0 !important;
            width: 380px;
            max-height: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.2);
            z-index: 999;
            border-top-left-radius: 0;
            border-top-right-radius: 0;
            margin: 0 !important;
            background: transparent !important;
            box-shadow: none !important;
            border: none !important;
            height: 30px !important;
            padding: 6px 10px !important;
            font-size: 13px !important;
            resize: none !important;
        }

            .custom-calendar-wrap.prebook-on {
                top: -970px !important;
            }

        .form-wrap {
            margin-left: -330px;
            margin-right: auto;
            float: none;
            text-align: left;
        }

        .custom-modal-content {
            background-color: #f0f0f0;
            border-radius: 10px;
            padding: 20px;
        }

        .RequestIcons {
            pointer-events: auto !important;
            position: relative;
            z-index: 2000;
        }

        input.form-control-sm {
            width: 100% !important;
            box-sizing: border-box;
        }

        .select2-container--default .select2-selection--single {
            height: 50px;
            font-size: 18px;
            padding: 8px 12px;
            background-color: #e0e0e0 !important; /* Grey background */
            border-radius: 4px;
            border: 1px solid #bdbdbd;
            color: #333;
        }

            .select2-container--default .select2-selection--single .select2-selection__rendered {
                line-height: 34px;
                color: #333;
            }

            .select2-container--default .select2-selection--single .select2-selection__arrow {
                top: 12px;
            }

        .select2-container--default .select2-results__option {
            font-size: 18px;
            padding: 10px 15px;
            background: #f5f5f5;
            color: #222;
        }

        .select2-dropdown {
            background-color: #e0e0e0 !important; /* Grey dropdown */
            border: 1px solid #bdbdbd;
        }

        #ddlCancelReasons, #ddlCancelReasons option {
            text-transform: none !important;
        }

        #breakDurationSelect option {
            padding: 10px;
        }

        #confirmBreakBtn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
        }

        #confirmBreakBtn:not(:disabled):hover {
            background-color: #138d75;
        }

        .custom-checkbox input[type="checkbox"] {
            /* Hide native checkbox */
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
            margin: 0;
            cursor: pointer;
        }

        .custom-checkbox {
            position: relative;
            user-select: none;
        }

          .custom-checkbox span {
                /* This is the label text, no changes needed here */
            }

            .custom-checkbox::before {
                content: "";
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 2.5px solid #007bff; /* Bootstrap primary blue */
                border-radius: 4px; /* Slightly rounded corners, remove for sharp square */
                background-color: white;
                margin-right: 10px;
                vertical-align: middle;
                transition: background-color 0.3s, border-color 0.3s;
            }

            .custom-checkbox input[type="checkbox"]:checked + span::before,
            .custom-checkbox input[type="checkbox"]:checked::before {
                background-color: #007bff; /* Blue fill */
                border-color: #007bff;
            }

            .custom-checkbox input[type="checkbox"]:checked::after {
                content: "✓";
                position: absolute;
                left: 4px;
                top: 0px;
                font-size: 18px;
                color: white;
                font-weight: bold;
                pointer-events: none;
            }

        #editTaskModal .modal-content {
            border-radius: 5px;
            font-family: "Segoe UI", sans-serif;
        }

        #editTaskModal .form-label {
            letter-spacing: 0.10px;
            font-size: 10px;
            color: #444;
        }

        #editTaskModal .form-select,
        #editTaskModal .form-control {
            border-radius: 6px;
            padding: 10px 5px;
        }

        #editTaskModal .modal-header {
            border-bottom: 0;
        }

        #editTaskModal .modal-footer {
            border-top: 1px solid #dee2e6;
        }

        #reassignModalLabel {
            color: black !important;
        }

        #editTaskModal .form-control {
            font-size: 0.95rem; 
            font-weight: 500; /* slightly bold */
            color: #000; /* black text */
            padding: 0.5rem 0.75rem; /* more padding for bigger box */
            border-radius: 0.500rem; /* slightly rounded corners */
        }

        #editTaskModal label.fw-bold {
            font-weight: 600;
            color: #000;
        }

        #editTaskModal .modal-dialog {
            max-width: 950px;      /* or 950px, tune as you like */
            width: 70%;            /* use 90% of viewport to reduce side gap */
            margin: 1.75rem auto;  /* keep it centered */
        }

        #editTaskModal .modal-title {
            font-weight: 600;
            color: #000;
        }

        #editTaskModal .btn {
            font-size: 0.95rem;
            font-weight: 600;
        }
        #editTaskModal .row {
            display: flex;
            flex-wrap: wrap;
            margin-right: -0.75rem;
            margin-left: -0.75rem;
        }

        
        @media (max-width: 767.98px) {
            #editTaskModal .row > .col-md-6,
            #editTaskModal .row > .col-md-6.col-12 {
                flex: 0 0 100%;
                max-width: 100%;
            }
        }
/*        @media (min-width: 768px) {
            .col-md-6 {
                flex: 0 0 auto;
                width: 95%;
            }
        }*/

        .compact-navbar {
            background: linear-gradient(90deg, #e3f0fd 50%, #fff7f0 100%);
            box-shadow: 0 2px 8px rgba(120,155,200,0.09);
            padding: 0.5em 1.2em;
            min-height: 44px;
            height: 48px;
        }

        .compact-user-panel {
            display: flex;
            align-items: center;
            gap: 0.65em;
            padding: 0.2em 0.7em;
            border-radius: 1.1em;
            background: linear-gradient(135deg, #a6d4ff 0%, #c4f0ff 100%);
            box-shadow: 0 1px 5px rgba(120,155,200,0.10);
            min-width: 120px;
            max-width: 280px;
            color: #000; 
        }

        .user-avatar {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 1px 4px rgba(160,200,255,0.13);
        }

        .avatar-img {
            width: 28px;
            height: 28px;
            border-radius: 50%;
        }

        .welcome-animation {
            font-size: 1.08em;
            color: #31417d;
            font-family: 'Poppins', 'Inter', sans-serif;
            animation: welcomePulse 2.2s infinite;
        }

        @keyframes welcomePulse {
            0%,100% {
                opacity: 1;
            }

            45% {
                opacity: .88;
            }

            70% {
                opacity: .7;
            }
        }

        .user-name {
            font-weight: 700;
            font-size: 1em;
            color: #26477b;
            letter-spacing: .3px;
            margin-left: 2px;
        }

        .switch-bubble {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 6px 14px;
            border-radius: 24px;
            background: linear-gradient(135deg, #a6d4ff, #c4f0ff); 
            width: max-content;
            gap: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08); 
            font-weight: 600;
            font-family: 'Poppins', sans-serif;
            transition: background 0.3s;
        }

        .switch-bubble .switch-label {
            color: #26477b; 
            font-size: 14px;
            user-select: none;
            transition: color 0.3s;
        }

        .switch-auto {
            position: relative;
            display: inline-block;
            width: 44px;
            height: 24px;
        }

        .switch-auto input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider-auto {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: #d0e7ff; 
            transition: background 0.3s;
            border-radius: 24px;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.08);
        }

        .slider-auto.round:before {
            position: absolute;
            content: "";
            height: 20px;
            width: 20px;
            left: 2px;
            bottom: 2px;
            background: white;
            transition: transform 0.3s, background 0.3s;
            border-radius: 50%;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }

        .switch-auto input:checked + .slider-auto {
            background: linear-gradient(135deg, #4fc3ff, #00f2fe);
        }

        .switch-auto input:checked + .slider-auto.round:before {
            transform: translateX(20px);
            background: #ffffff;
        }

        .switch-auto:hover .slider-auto {
            background: #cce5ff; 
        }

        .switch-bubble:hover .switch-label {
            color: #1a3e6a;
        }

        #bulkRequestList {
          transition: opacity 0.25s ease;
        }

        .task-row.fade-in {
          opacity: 0;
          animation: fadeIn 0.4s ease forwards;
        }

        .task-category {
          font-weight: 600;
          color: #212529;
        }

        .d-flex.align-items-center.gap-1 i {
          color: #6c757d;
          transition: color 0.3s ease;
        }

        .task-equipment-name,
        .task-patient-name,
        .task-porter-name {
          font-weight: 500;
          color: #343a40;
        }

        .right-corner {
          margin-left: auto;
          display: flex;
          align-items: center;
          gap: 0.5rem;
        }

        .task-badge {
          background-color: #0d6efd;
          padding: 0.2rem 0.5rem;
          border-radius: 0.375rem;
          font-size: 0.75rem;
          color: white;
          user-select: none;
        }

        .bi, .fas {
          font-size: 0.90rem;
          vertical-align: middle;
          transition: color 0.3s ease;
          will-change: color;
        }

        .bi:hover, .fas:hover {
          cursor: pointer;
          color: #2c3e50;
          transform: scale(1.05); 
          transition: transform 0.3s ease, box-shadow 0.3s ease; 
          box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15); 
        }

        @media (max-width: 576px) {
          .task-row {
            flex-direction: column;
          }
        }

        .employee-card .badge {
          margin-left: 0.5rem;
          padding: 0.25em 0.6em;
          font-size: 0.75rem;
          font-weight: 600;
          border-radius: 0.375rem;
          white-space: nowrap;
          user-select: none;
        }

        @media (max-width: 576px) {
          .employee-card {
            flex-wrap: wrap;
            gap: 0.75rem;
          }
          .employee-card .fw-bold {
            min-width: 100%;
          }
        }

        @keyframes fadeIn {
          from { opacity: 0; transform: translate3d(0, 4px, 0); }
          to { opacity: 1; transform: translate3d(0, 0, 0); }
        }

        html, body {
          -webkit-font-smoothing: antialiased;
          -moz-osx-font-smoothing: grayscale;
          text-rendering: optimizeLegibility;
          image-rendering: auto;
        }

        .use-gpu, .modal-dialog, .loading::after, .pop-animate {
          transform: translate3d(0, 0, 0);
          backface-visibility: hidden;
          will-change: transform, opacity;
        }

        .loading::after {
          content: "Loading...";
          display: block;
          text-align: center;
          color: #666;
          font-weight: 500;
          font-size: 1rem;
          padding: 8px;
          animation: pulse 1.4s cubic-bezier(.4, 0, .2, 1) infinite;
          will-change: opacity;
        }

        @keyframes pulse {
          0%, 100% { opacity: 0.35; }
          50% { opacity: 1; }
        }

        .modal.fade .modal-dialog {
          transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1),
                      opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1);
          transform: translate3d(0, -20px, 0);
          opacity: 0;
        }
        .modal.fade.show .modal-dialog {
          transform: translate3d(0, 0, 0);
          opacity: 1;
        }

        .modal-body.px-4.py-4 {
          padding: 1.5rem;
          background: rgba(240, 243, 255, 0.3);
          border-radius: 0 0 20px 20px;
          box-shadow: 0 4px 14px rgba(0, 0, 0, 0.05), 0 12px 30px rgba(0, 0, 0, 0.04);
          backdrop-filter: blur(8px) saturate(1.15); 
          -webkit-backdrop-filter: blur(8px) saturate(1.15);
          will-change: transform, opacity;
        }

        @media (prefers-reduced-motion: reduce) {
          * {
            animation: none !important;
            transition-duration: 0ms !important;
            transform: none !important;
          }
        }
 
        #btnCloseEditTaskModal img {
          filter: drop-shadow(0 0 4px rgba(255, 255, 255, 0.6));
          transition: filter 260ms cubic-bezier(.4, 0, .2, 1);
          will-change: filter;
        }

        #btnCloseEditTaskModal:hover img {
          filter: drop-shadow(0 0 12px rgba(255, 255, 255, 0.9));
        }

        .remark-field {
          font-weight: 650;
          color: #212529;
        }

        .remark-field::placeholder {
          color: #6c757d;
          font-weight: 400;
        }

        @keyframes popIn {
          0% {
            opacity: 0;
            transform: scale(0.94);
          }
          70% {
            opacity: 1;
            transform: scale(1.04);
          }
          100% {
            opacity: 1;
            transform: scale(1);
          }
        }

        .pop-animate {
          animation: popIn 380ms cubic-bezier(0.16, 1, 0.3, 1);
          will-change: opacity, transform;
        }

        img, svg {
          shape-rendering: geometricPrecision;
          image-rendering: auto;
        }

        @media (min-resolution: 2dppx) {
          .icon { background-image: url('icon@2x.png'); }
        }

        @media (min-resolution: 3dppx) {
          .icon { background-image: url('icon@3x.png'); }
        }

        .gradient-smooth {
          background: linear-gradient(135deg, #eef1ff 0%, #d9e0ff 100%);
          filter: saturate(1.15);
        }

        @media (prefers-reduced-motion: reduce) {
          * {
            animation: none !important;
            transition-duration: 0ms !important;
            transform: none !important;
          }
        }

        .modal-backdrop {
            background-color: rgba(0, 0, 0, 0.5) !important;
            position: fixed !important;
            top: 0; right: 0; bottom: 0; left: 0;
            z-index: 1040 !important; 
            display: block !important;
            transition: background-color 0.15s ease !important;
        }

        .modal {
            z-index: 1050 !important;
        }
        .modal-backdrop,
        .modal-backdrop.show {
            background-color: rgba(0, 0, 0, 0.5) !important;
            backdrop-filter: none !important;
            -webkit-backdrop-filter: none !important;
            transition: background-color 0.15s ease !important;
            position: fixed !important;
            z-index: 1040 !important;
        }

        #reassignModal {
          z-index: 1050 !important; 
        }

        .modal-backdrop.fade {
          transition: none !important;
        }

        .modal.fade {
            transition: opacity 0s linear 0s !important;
        }
        .modal.fade.show {
            transition: opacity 0.15s linear 0s !important;
        }

        .modal-content {
          border-radius: 18px;
          box-shadow: 0 8px 32px rgba(31, 38, 135, 0.15), 0 1.5px 4px rgba(0,0,0,0.10);
          background: rgba(255,255,255,0.98); 
          border: none;
          backdrop-filter: blur(10px);
        }

        .bg-gradient-primary {
          background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
        }

        .modal-content.shadow-lg {
          box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
        }

        .btn-primary:hover {
          background: linear-gradient(135deg, #2d9c8f 0%, #1b5d52 100%);
          box-shadow: 0 4px 12px rgba(45, 156, 143, 0.4); 
          color: #fff;
          transform: scale(1.05);
          transition: transform 0.3s ease, background 0.3s ease, box-shadow 0.3s ease;
        }

        #requestorModalContent::-webkit-scrollbar {
          width: 8px;
        }
        #requestorModalContent::-webkit-scrollbar-thumb {
          background-color: rgba(37, 117, 252, 0.6);
          border-radius: 4px;
        }
        #requestorModalContent::-webkit-scrollbar-track {
          background: rgba(0,0,0,0.05);
          border-radius: 4px;
        }
        .modal.level-1 {
            z-index: 1050;
        }
        .modal.level-2 {
            z-index: 1060; /* ABOVE reassign modal */
        }

        .modal-backdrop.level-1 {
            z-index: 1040;
        }
        .modal-backdrop.level-2 {
            z-index: 1055; /* ABOVE backdrop of modal 1 */
        }
 
        .modal-xl-custom {
            max-width: 45%; /* Increase width */
            width: 45%;     /* Optional, ensures consistency */
        }

        #modalAlert .modal-content {
            background: #ffffff;                 /* clean white background */
            border-radius: 0.75rem;              /* smooth corners */
            padding: 20px 20px;                  /* slightly reduced padding */
            max-width: 350px;                     /* smaller width */
            width: 90%;                            /* responsive for smaller screens */
            box-shadow: 0 8px 20px rgba(0,0,0,0.25); /* elegant shadow */
            text-align: center;
            border: none;                         /* no border */    
            color: #212529;                      /* dark, readable text */
            font-family: 'Segoe UI', Tahoma, sans-serif; 
            font-size: 1.05rem;                  /* slightly smaller font */
            font-weight: 600;
            line-height: 1.4;

            animation: popIn 0.35s cubic-bezier(0.16, 1, 0.3, 1);
        }

        @keyframes popIn {
            0% {
                opacity: 0;
                transform: scale(0.9);
            }
            70% {
                opacity: 1;
                transform: scale(1.05);
            }
            100% {
                opacity: 1;
                transform: scale(1);
            }
        }

        #modalAlert .modal-footer button {
            padding: 8px 16px;                   
            border: none;
            background-color: #007bff;           
            color: #ffffff;
            font-weight: 600;
            border-radius: 0.35rem;
            cursor: pointer;
            transition: background-color 0.25s ease;
        }

        #modalAlert .modal-footer button:hover {
            background-color: #0056b3;
        }

        #taskList {
          transition: opacity 0.3s ease-in-out;
          will-change: opacity;
        }

        #taskList.refreshing {
          opacity: 0.5;
        }

        .modal#modalEmployeeActionSuccess {
          z-index: 1055 !important;  
        }

        .modal-backdrop,
        .modal-backdrop.show,
        .modal-backdrop.fade {
            background-color: rgba(0, 0, 0, 0.5) !important;
            opacity: 1 !important;
            background-image: none !important;
            filter: none !important;
            backdrop-filter: none !important;
            -webkit-backdrop-filter: none !important;
            transition: none !important;
            animation: none !important;
            transform: none !important;
            pointer-events: auto !important;
            z-index: 2147483646 !important;
        }

        body.modal-open > *:not(.modal):not(.modal-backdrop) {
            filter: none !important;
            backdrop-filter: none !important;
        }

        body.modal-open .right-panel-backdrop,
        body.modal-open .blur,
        body.modal-open .overlay {
            display: none !important;
        }

        .action-btn-wrapper {
            display: flex;
            gap: -180px;
        }

        .user-info-wrapper {
            width: 100%;                   
        }

        .auto-refresh-container {
            display: inline-block;
        }

        .auto-refresh-wrapper {
            display: inline-flex;
            align-items: center;
            gap: 6px;          
            width: 210px;            
            white-space: nowrap; 
        }

        .switch-label {
            white-space: nowrap;  
            font-size: 12px;      
            margin: 0;
        }

        .switch-auto {
            flex-shrink: 0;     
        }
        .refresh-countdown {
            width: 42px;         
            height: 20px;        
            display: inline-block;     
            padding: 3px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 600;
            line-height: 1;
            text-align: center;
            box-sizing: border-box;
            background: #e3f2fd;
            border: 1px solid #b3e5fc;
        }

        .refresh-countdown.is-visible {
            visibility: visible; 
        }

        .refresh-countdown.is-critical {
            background: #ffebee;
            color: #b71c1c;
            border-color: #ffcdd2;
            animation: countdown-blink 0.6s infinite;
        }

        @keyframes countdown-blink {
            0%, 50% {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
            51%, 100% {
                opacity: 0.5;
                transform: translateY(0) scale(0.96);
            }
        }

        #countdownSeconds {
            font-family: "SF Mono", Menlo, Consolas, "Roboto Mono", monospace;
        }

        .modal.show .modal-body > * {
            opacity: 1;
            transform: scale(0.95);
            animation: modalContentReveal 0.45s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards;
        }

        .modal.show .modal-body > *:nth-child(1) { animation-delay: 0.06s; }
        .modal.show .modal-body > *:nth-child(2) { animation-delay: 0.12s; }
        .modal.show .modal-body > *:nth-child(3) { animation-delay: 0.18s; }
        .modal.show .modal-body > *:nth-child(4) { animation-delay: 0.24s; }
        .modal.show .modal-body > *:nth-child(5) { animation-delay: 0.30s; }

        @keyframes modalContentReveal {
            to {
                opacity: 1;
                transform: scale(1);
            }
         }

        .prebooked-toggle {
          display: inline-flex;
          align-items: center;
          gap: 10px;
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
          font-weight: 500;
          font-size: 13px;
          color: #4a5568;
          cursor: pointer;
          user-select: none;
          padding: 8px 16px;
          border-radius: 6px;
          background-color: white;
          border: 1px solid #e2e8f0;
          transition: all 0.2s ease;
          position: relative;
        }

        .prebooked-toggle:hover {
          background-color: #f7fafc;
          border-color: #cbd5e0;
        }

        .prebooked-toggle input[type="checkbox"] {
          position: absolute;
          opacity: 0;
          cursor: pointer;
          height: 0;
          width: 0;
        }

        .prebooked-toggle label {
          position: relative;
          padding-left: 32px;
          cursor: pointer;
          user-select: none;
          color: #2d3748;
          font-weight: 500;
          font-size: 13px;
          display: flex;
          align-items: center;
          height: 20px;
        }

        .prebooked-toggle label::before {
          content: "";
          position: absolute;
          left: 0;
          top: 50%;
          transform: translateY(-50%);
          height: 18px;
          width: 18px;
          border: 2px solid #cbd5e0;
          border-radius: 4px;
          background-color: white;
          box-sizing: border-box;
          transition: all 0.2s ease;
        }

        .prebooked-toggle input[type="checkbox"]:checked + label::before {
          background-color: #2d3748;
          border-color: #2d3748;
        }

        .prebooked-toggle label::after {
          content: "";
          position: absolute;
          left: 6px;
          top: 50%;
          width: 5px;
          height: 10px;
          border: solid white;
          border-width: 0 2px 2px 0;
          opacity: 0;
          transform: translateY(-60%) rotate(45deg);
          transition: opacity 0.2s ease;
          pointer-events: none;
        }

        .prebooked-toggle input[type="checkbox"]:checked + label::after {
          opacity: 1;
        }

        .prebooked-toggle label:hover::before {
          border-color: #a0aec0;
        }

        .prebooked-toggle input[type="checkbox"]:checked + label:hover::before {
          background-color: #4a5568;
          border-color: #4a5568;
        }

        .prebooked-toggle input[type="checkbox"]:focus + label::before {
          outline: 2px solid #e2e8f0;
          outline-offset: 1px;
        }

        .prebooked-toggle:active {
          transform: scale(0.98);
        }

        @supports (-webkit-backdrop-filter: none) {
        .modal-backdrop {
            background-color: rgba(0, 0, 0, 0.5) !important;
            backdrop-filter: none !important;
        }
        }

        .modal.show {
            display: block !important;
        }

        .tick-wrapper {
            width: 28px;
            height: 28px;
            border: 2px solid #d1d5db;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            flex-shrink: 0;
            margin-left: 8px;
            transition: all 0.2s ease;
        }

        .tick-wrapper:hover:not(.checked) {
            border-color: #22c55e;
        }

        .tick-wrapper.checked {
            background: #22c55e;
            border-color: #22c55e;
        }

        .tick-wrapper svg {
            display: none;
            width: 16px;
            height: 16px;
            stroke: white;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .tick-wrapper.checked svg {
            display: block;
            animation: pop 0.2s ease-out;
        }

        @keyframes pop {
            0% { transform: scale(0); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }

        .tick-wrapper[style*="pointer-events: none"] {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .tick-wrapper[style*="pointer-events: none"].checked {
            background: #86efac;
            border-color: #86efac;
        }

        .list-group-item {
            border-radius: 6px !important;
            margin-bottom: 4px !important;
            padding: 8px 12px !important;
        }

        .assigned-task {
            background-color: #f1f5f9 !important;
            opacity: 0.8;
        }

        .task-info {
            cursor: pointer !important;
            padding: 4px 0;
        }

        #btnSelectAll, #clearAllSelections {
            font-size: 13px;
            padding: 4px 14px;
        }

        #btnBulkAssign {
            font-size: 14px;
            padding: 8px 20px;
        }

        @media (max-width: 576px) {
            .tick-wrapper {
                width: 24px;
                height: 24px;
            }
            .tick-wrapper svg {
                width: 13px;
                height: 13px;
            }
            .list-group-item {
                font-size: 12px !important;
                padding: 6px 8px !important;
            }
        }

        #bulkAssignModal .modal-body {
            display: flex !important;
            flex-direction: column !important;
            max-height: calc(100vh - 200px) !important;
            overflow: hidden !important;
        }

        #bulkAssignModal .modal-body .flex-shrink-0 {
            flex-shrink: 0 !important;
        }

        #bulkAssignModal .modal-body .flex-grow-1 {
            flex-grow: 1 !important;
            min-height: 100px !important;
        }

        #bulkAssignModal .modal-body .overflow-auto {
            overflow: auto !important;
        }

        @media (max-width: 576px) {
            #bulkAssignModal .modal-body {
                max-height: calc(100vh - 150px) !important;
                padding: 12px !important;
            }
    
            #bulkAssignModal .modal-dialog {
                margin: 10px !important;
            }
        }

        #assignModal .modal-body {
            min-height: 500px;
        }

        #freeEmployeeList {
            height: 360px !important;
            min-height: 360px !important;
            max-height: 360px !important;
            overflow-y: auto !important;
        }

        #freeEmployeeList:empty {
            height: 360px !important;
        }

      </style>

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


            <script>

                function saveUIState() {
                    const iconBar = document.getElementById('iconBar');
                    const hamburger = document.getElementById('hamburger');
                    const leftPanel = document.querySelector('.screen-left-panel');
                    const hospitalImg = document.getElementById('hospitalImg');

                    localStorage.setItem('iconBarHidden', iconBar?.classList.contains('hidden') || false);
                    localStorage.setItem('hamburgerHidden', hamburger?.classList.contains('hidden') || false);
                    localStorage.setItem('leftPanelHidden', leftPanel?.classList.contains('hidden') || false);
                    localStorage.setItem('hospitalImgHidden', hospitalImg?.classList.contains('hidden') || false);
                }

                function displayUserName() {
                    const name = sessionStorage.getItem('NAME');

                    if (!name) {
                        window.location = "../Login.aspx";
                        return;
                    }

                    const UName = name.toUpperCase();
                    document.getElementById('userName').textContent = UName;
                }

                window.addEventListener('DOMContentLoaded', displayUserName);

                function restoreUIState() {
                    const iconBar = document.getElementById('iconBar');
                    const hamburger = document.getElementById('hamburger');
                    const leftPanel = document.querySelector('.screen-left-panel');
                    const hospitalImg = document.getElementById('hospitalImg');

                    const states = {
                        iconBarHidden: localStorage.getItem('iconBarHidden') === 'true',
                        hamburgerHidden: localStorage.getItem('hamburgerHidden') === 'true',
                        leftPanelHidden: localStorage.getItem('leftPanelHidden') === 'true',
                        hospitalImgHidden: localStorage.getItem('hospitalImgHidden') === 'true'
                    };

                    if (iconBar) iconBar.classList.toggle('hidden', states.iconBarHidden);
                    if (hamburger) hamburger.classList.toggle('hidden', states.hamburgerHidden);
                    if (leftPanel) leftPanel.classList.toggle('hidden', states.leftPanelHidden);
                    if (hospitalImg) hospitalImg.classList.toggle('hidden', states.hospitalImgHidden);
                }

                let currentTasks = [];
                let currentServiceId = null;
                let currentServiceIdN = '1';
                let currentSortOrder = 'asc';
                let pendingSortOrder = 'asc';
                let startedSortOrder = 'asc';
                let currentRequestId = null;
                let activeFetchControllers = [];
                let pendingAbortController = null;
                let startedAbortController = null;

                function cleanupAbortControllers() {
                    if (pendingAbortController) {
                        pendingAbortController.abort();
                        pendingAbortController = null;
                    }
                    if (startedAbortController) {
                        startedAbortController.abort();
                        startedAbortController = null;
                    }
                    activeFetchControllers.forEach(c => c.abort());
                    activeFetchControllers = [];
                }

                document.addEventListener('DOMContentLoaded', () => {
                    const userId = sessionStorage.getItem('ID');
                    const roleId = "1";
                    const pageIndex = 0;
                    const pageSize = 300;

                    const pendingList = document.getElementById("pendingList");
                    const startedList = document.getElementById("startedList");
                    const pendingFilterInput = document.getElementById("pendingFilter");
                    const startedFilterInput = document.getElementById("startedFilter");

                    let pendingTasksFound = false;
                    let pendingCallsCompleted = 0;
                    const pendingTotalCalls = 3;

                    const renderedTaskIds = new Set();

                    let filters = {
                        filterTaskId: "",
                        filterTaskType: "",
                        filterEquipmentType: "",
                        filterRequestStatus: "",
                        filterFromLocation: "",
                        filterToLocation: "",
                        filterFromZone: "",
                        filterToZone: "",
                        filterEmployee: ""
                    };

                    document.querySelectorAll('.services-btn-icon').forEach(btn => {
                        btn.addEventListener('click', () => {

                            if (btn.classList.contains('active')) return;

                            document.querySelectorAll('.services-btn-icon')
                                .forEach(b => b.classList.remove('active'));

                            btn.classList.add('active');

                            const serviceId = btn.id.replace('divService', '');

                            currentServiceIdN = serviceId;

                            pendingList.innerHTML = '';
                            startedList.innerHTML = '';
                            employeeList.innerHTML = '';

                            reloadTasks(serviceId);
                            reloadStartedTasks(serviceId);
                            loadEmployees('', serviceId, currentSortOrder);
                            RefreshTasks();
                        });
                    });

                    const initialServiceBtn =
                        document.querySelector('.services-btn-icon.active') ||
                        document.querySelector('.services-btn-icon');

                    if (initialServiceBtn) {
                        initialServiceBtn.classList.add('active');
                        const serviceId = initialServiceBtn.id.replace('divService', '');
                        currentServiceIdN = serviceId;
                        reloadTasks(serviceId);
                        reloadStartedTasks(serviceId);
                    }

                    let pendingSearchTimeout;
                    let startedSearchTimeout;

                    const DEBOUNCE_DELAY = 600;

                    //const DEBOUNCE_DELAY = 600;

                    function debounce(fn, delay) {
                        let timer;
                        return (...args) => {
                            clearTimeout(timer);
                            timer = setTimeout(() => fn.apply(this, args), delay);
                        };
                    }

                    const debouncedPendingReload = debounce(() => {
                        const activeBtn = document.querySelector('.services-btn-icon.active');
                        if (!activeBtn) return;
                        const serviceId = activeBtn.id.replace('divService', '');
                        reloadTasks(serviceId);
                    }, DEBOUNCE_DELAY);

                    const debouncedStartedReload = debounce(() => {
                        const activeBtn = document.querySelector('.services-btn-icon.active');
                        if (!activeBtn) return;
                        const serviceId = activeBtn.id.replace('divService', '');
                        reloadStartedTasks(serviceId);
                    }, DEBOUNCE_DELAY);

                    pendingFilterInput.addEventListener("input", debouncedPendingReload);
                    startedFilterInput.addEventListener("input", debouncedStartedReload);

                    function reloadTasks(serviceId) {
                        currentServiceId = serviceId;
                        const search = pendingFilterInput.value.trim();

                        const list = document.getElementById('pendingList');

                        if (list && list.children.length === 0) {
                            list.innerHTML = `
            <div class="text-center p-4">
                <div class="spinner-border text-info" role="status" style="width: 2rem; height: 2rem;">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <div class="mt-2 fw-semibold text-muted small">Loading tasks...</div>
            </div>
        `;
                        } else if (list) {
                            list.classList.add('refreshing');
                        }

                        document.getElementById('containerDates').style.display = 'none';
                        document.getElementById('containerTimes').style.display = 'none';

                        fetchAndRenderTasks("2", "pendingList", serviceId, search, pendingSortOrder);
                    }

                    function reloadStartedTasks(serviceId) {
                        currentServiceId = serviceId;
                        const search = startedFilterInput.value.trim();

                        const list = document.getElementById('startedList');

                        if (list && list.children.length === 0) {
                            list.innerHTML = `
            <div class="text-center p-4">
                <div class="spinner-border text-info" role="status" style="width: 2rem; height: 2rem;">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <div class="mt-2 fw-semibold text-muted small">Loading tasks...</div>
            </div>
        `;
                        } else if (list) {
                            list.classList.add('refreshing');
                        }

                        fetchAndRenderTasks("4", "startedList", serviceId, search, startedSortOrder);
                    }

                    function reloadPrebookTasks(serviceId) {
                        currentServiceId = serviceId;
                        const search = pendingFilterInput.value.trim();

                        const list = document.getElementById('pendingList');

                        if (list && list.children.length === 0) {
                            list.innerHTML = `
            <div class="text-center p-4">
                <div class="spinner-border text-info" role="status" style="width: 2rem; height: 2rem;">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <div class="mt-2 fw-semibold text-muted small">Loading pre-booked tasks...</div>
            </div>
        `;
                        } else if (list) {
                            list.classList.add('refreshing');
                        }

                        fetchAndRenderTasks("15", "pendingList", serviceId, search, pendingSortOrder);

                        document.getElementById('containerDates').style.display = 'block';
                        document.getElementById('containerTimes').style.display = 'block';
                    }

                    $('.clear-filters').on('click', function (e) {
                        e.preventDefault();
                        const $panel = $(this).closest('.filter-panel');
                        const $column = $panel.closest('.column-container');
                        const serviceId = $('.services-btn-icon.active').attr('id')?.replace('divService', '') || '';
                        $panel.find('select').val('');
                        $panel.hide();
                        if ($column.find('#pendingList').length) {
                            filters.filterTaskId = "";
                            filters.filterTaskType = "";
                            filters.filterEquipmentType = "";
                            filters.filterRequestStatus = "";
                            filters.filterFromLocation = "";
                            filters.filterToLocation = "";
                            filters.filterFromZone = "";
                            filters.filterToZone = "";
                            filters.filterEmployee = "";
                            reloadTasks(serviceId);
                        } else if ($column.find('#startedList').length) {
                            filters.filterTaskId = "";
                            filters.filterTaskType = "";
                            filters.filterEquipmentType = "";
                            filters.filterFromLocation = "";
                            filters.filterToLocation = "";
                            filters.filterEmployee = "";
                            reloadStartedTasks(serviceId);
                        } else if ($column.find('#employeeList').length && typeof loadEmployees === 'function') {
                            window.employeeLoader('', serviceId);
                        }
                    });

                    window.sortPendingTasks = function (order) {
                        //console.log("sortPendingTasks triggered with order:", order);
                        currentSortOrder = order;

                        reloadTasks(currentServiceId);
                    };

                    document.addEventListener('click', function (event) {
                        if (event.target.id === 'showPrebookedCheckbox' ||
                            (event.target.htmlFor === 'showPrebookedCheckbox' && event.target.tagName === 'LABEL')) {

                            const checkbox = document.getElementById('showPrebookedCheckbox');
                            if (checkbox) {
                                const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                                const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : "";

                                const pendingHeading = document.querySelector('.d-flex.justify-content-between.align-items-center.mb-2.flex-wrap h6.mb-0');

                                if (checkbox.checked) {
                                    if (pendingHeading) {
                                        pendingHeading.textContent = 'Pre-booked';
                                    }
                                    reloadPrebookTasks(serviceId);

                                    document.getElementById('containerDates').style.display = 'block';
                                    document.getElementById('containerTimes').style.display = 'block';
                                } else {
                                    if (pendingHeading) {
                                        pendingHeading.textContent = 'Pending';
                                    }
                                    reloadTasks(serviceId);

                                    document.getElementById('containerDates').style.display = 'none';
                                    document.getElementById('containerTimes').style.display = 'none';
                                }
                            }
                        }
                    });

                    function getPendingStatus() {
                        const checkbox = document.getElementById('showPrebookedCheckbox');
                        return checkbox && checkbox.checked ? "15" : "2";
                    }

                    document.querySelectorAll('.sort-option').forEach(item => {
                        item.addEventListener('click', function (e) {
                            e.preventDefault();
                            const order = this.getAttribute('data-order');
                            sortPendingTasks(order);
                        });
                    });

                    function sortPendingTasks(order) {
                        if (order !== 'asc' && order !== 'desc') return;

                        pendingSortOrder = order;
                        currentSortOrder = order;

                        const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                        const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : "";

                        if (serviceId) {

                            const checkbox = document.getElementById('showPrebookedCheckbox');
                            if (checkbox && checkbox.checked) {
                                reloadPrebookTasks(serviceId);
                            } else {
                                reloadTasks(serviceId);
                            }
                        }
                    }


                    document.querySelectorAll('.started-sort-option').forEach(item => {
                        item.addEventListener('click', function (e) {
                            e.preventDefault();
                            const order = this.getAttribute('data-order');
                            sortStartedTasks(order);
                        });
                    });


                    function sortStartedTasks(order) {
                        if (order !== 'asc' && order !== 'desc') return;

                        startedSortOrder = order;
                        currentSortOrder = order;

                        //console.log('sortStartedTasks triggered with order:', order);

                        if (currentServiceId) {
                            reloadStartedTasks(currentServiceId);
                        }
                    }

                    document.querySelector('.apply-filters.pending').addEventListener('click', () => {
                        filters.filterTaskId = document.getElementById('taskIdSelect').value || "";
                        filters.filterTaskType = document.getElementById('taskTypeSelect').value || "";
                        filters.filterEquipmentType = document.getElementById('equipmentSelect').value || "";
                        filters.filterRequestStatus = document.getElementById('requestStatusSelect').value || "";
                        filters.filterFromLocation = document.getElementById('fromLocationSelect').value || "";
                        filters.filterToLocation = document.getElementById('toLocationSelect').value || "";
                        filters.filterFromZone = document.getElementById('fromZoneSelect').value || "";
                        filters.filterToZone = document.getElementById('toZoneSelect').value || "";
                        filters.filterEmployee = document.getElementById('employeeSelect').value || "";

                        const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                        const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : "";

                        pendingList.innerHTML = '';
                        renderedTaskIds.clear();

                        const search = pendingFilterInput.value.trim();

                        ["2"].forEach(status => {
                            fetchAndRenderTasks(status, "pendingList", serviceId, "");
                        });
                    });

                    document.querySelector('.apply-filters.started').addEventListener('click', () => {
                        filters.filterTaskId = document.getElementById('taskIdSelectStarted').value || "";
                        filters.filterTaskType = document.getElementById('taskTypeSelectStarted').value || "";
                        filters.filterEquipmentType = document.getElementById('equipmentSelectStarted').value || "";
                        filters.filterFromLocation = document.getElementById('fromLocationSelectStarted').value || "";
                        filters.filterToLocation = document.getElementById('toLocationSelectStarted').value || "";
                        filters.filterEmployee = document.getElementById('employeeSelectStarted').value || "";

                        const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                        const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : "";

                        startedList.innerHTML = '';
                        renderedTaskIds.clear();

                        const search = startedFilterInput.value.trim();

                        fetchAndRenderTasks("4", "startedList", serviceId, "");
                    });

                    function encryptString(str) {
                        return btoa(unescape(encodeURIComponent(str)));
                    }

                    function encryptPayload(payload) {
                        const encrypted = {};
                        for (const key in payload) {
                            const val = payload[key] !== null && payload[key] !== undefined ? payload[key].toString() : "";
                            encrypted[key] = encryptString(val);
                        }
                        return encrypted;
                    }


                    function fetchAndRenderTasks(status, listId, serviceId, search, sortOrder = 'asc') {

                        cleanupAbortControllers();

                        if (window[`${listId}Timeout`]) {
                            clearTimeout(window[`${listId}Timeout`]);
                        }

                        window[`${listId}Timeout`] = setTimeout(() => {

                            let controller = listId === 'pendingList' ? pendingAbortController : startedAbortController;

                            if (controller && !controller.signal.aborted) {
                                controller.abort();
                            }

                            controller = new AbortController();
                            const { signal } = controller;
                            const requestId = Date.now();

                            if (listId === 'pendingList') {
                                const checkbox = document.getElementById('showPrebookedCheckbox');
                                if (checkbox && checkbox.checked) {
                                    status = "15";
                                }
                            }

                            if (listId === 'pendingList') {
                                pendingAbortController = controller;
                            } else {
                                startedAbortController = controller;
                            }

                            const listContainer = document.getElementById(listId);
                            if (!listContainer) return;

                            listContainer.setAttribute('data-loading-id', requestId);

                            const payload = {
                                userId: userId,
                                roleId: roleId,
                                status: Array.isArray(status) ? status.join(",") : (status || ""),
                                pageIndex: "0",
                                pageSize: "300",
                                search: search || "",
                                serviceId: serviceId || "",
                                SortOrder: sortOrder
                            };

                            if (filters.filterTaskId) payload.filterTaskId = filters.filterTaskId;
                            if (filters.filterTaskType) payload.filterTaskType = filters.filterTaskType;
                            if (filters.filterEquipmentType) payload.filterEquipmentType = filters.filterEquipmentType;
                            if (filters.filterRequestStatus) payload.filterRequestStatus = filters.filterRequestStatus;
                            if (filters.filterFromLocation) payload.filterFromLocation = filters.filterFromLocation;
                            if (filters.filterToLocation) payload.filterToLocation = filters.filterToLocation;
                            if (filters.filterFromZone) payload.filterFromZone = filters.filterFromZone;
                            if (filters.filterToZone) payload.filterToZone = filters.filterToZone;
                            if (filters.filterEmployee) payload.filterEmployee = filters.filterEmployee;

                            const encryptedPayload = encryptPayload(payload);
                            const processName = "GetUserRequests";
                            const encProcess = Encrypt(processName);

                            const fetchOptions = {
                                method: "POST",
                                headers: { "Content-Type": "application/json" },
                                body: JSON.stringify({ payload: encryptedPayload }),
                                signal
                            };

                            if (listId === 'pendingList') {
                                fetchOptions.priority = 'high';
                            }

                            fetch(`/Index/Service/Service.aspx?Process=${encodeURIComponent(encProcess)}`, fetchOptions)
                                .then(response => {
                                    if (!response.ok) {
                                        throw new Error(`HTTP error! status: ${response.status}`);
                                    }
                                    return response.json();
                                })
                                .then(data => {
                                    if (serviceId !== currentServiceId ||
                                        listContainer.getAttribute('data-loading-id') != requestId) {
                                        return;
                                    }

                                    listContainer.classList.remove('loading');

                                    listContainer.innerHTML = '';

                                    if (data.d && Array.isArray(data.d)) {
                                        const tasks = data.d;

                                        if (tasks.length > 0) {

                                            requestAnimationFrame(() => {
                                                renderTasksFromSP(tasks, listId);
                                            });
                                        } else {
                                            const message = listId === 'pendingList'
                                                ? 'No pending tasks found'
                                                : 'No started tasks found';
                                            listContainer.innerHTML = `
                                            <div class="text-center p-4">
                                                <i class="bi bi-inbox fs-1 mb-3 text-muted opacity-50 d-block"></i>
                                                <div class="h6 fw-semibold text-muted mb-1">${message}</div>
                                                <small class="text-muted">No tasks match your filters</small>
                                            </div>
                                        `;
                                        }
                                    } else {
                                        listContainer.innerHTML = `
                                        <div class="text-center p-4">
                                            <i class="bi bi-exclamation-triangle fs-1 mb-3 text-danger d-block"></i>
                                            <div class="h6 fw-semibold text-danger">Failed to load tasks</div>
                                            <small class="text-muted">Please try again</small>
                                        </div>
                                    `;
                                    }

                                    listContainer.removeAttribute('data-loading-id');
                                })
                                .catch(err => {
                                    if (listContainer.getAttribute('data-loading-id') != requestId) {
                                        return;
                                    }

                                    listContainer.classList.remove('loading');

                                    if (err.name === 'AbortError') {
                                        listContainer.removeAttribute('data-loading-id');
                                        return;
                                    }

                                    console.error("Error fetching tasks:", err);

                                    if (listContainer.children.length === 0) {
                                        listContainer.innerHTML = `
                                        <div class="text-center p-4">
                                            <i class="bi bi-exclamation-triangle fs-1 mb-3 text-danger d-block"></i>
                                            <div class="h6 fw-semibold text-danger">Failed to load tasks</div>
                                            <small class="text-muted">Please try again</small>
                                        </div>
                                    `;
                                    }

                                    listContainer.removeAttribute('data-loading-id');
                                });
                        }, 200); 
                    }

                    function parseTimeDifference(str) {
                            const regex = /(-?)(\d+)h\s+(\d+)m/;
                            const match = regex.exec(str);
                            if (!match) return 0;
                            const sign = match[1] === '-' ? -1 : 1;
                            const hours = parseInt(match[2], 10);
                            const minutes = parseInt(match[3], 10);
                            return sign * (hours * 60 + minutes);
                    }

                    function renderTasksFromSP(tasks, listId) {
                        const taskList = document.getElementById(listId);
                        if (!taskList) return;

                        const spinner = taskList.querySelector('.spinner-border');
                        if (spinner) {
                            const spinnerContainer = spinner.closest('.text-center');
                            if (spinnerContainer) spinnerContainer.remove();
                        }

                        const hasExistingData = taskList.children.length > 0;

                        taskList.classList.remove('refreshing');

                        if (!tasks || tasks.length === 0) {
                            if (!hasExistingData) {
                                taskList.innerHTML = `
                <div class="text-center p-4">
                    <i class="bi bi-inbox fs-1 mb-3 text-muted opacity-50 d-block"></i>
                    <div class="h6 fw-semibold text-muted mb-1">No tasks found</div>
                    <small class="text-muted">No tasks match your filters</small>
                </div>
            `;
                            }
                            return;
                        }

                        const fragment = document.createDocumentFragment();
                        const template = document.getElementById('taskRowTemplate');

                        function showSuccessModal(message) {
                            const modalEl = document.getElementById('modalSuccess');
                            if (!modalEl) return;
                            const activeElement = document.activeElement;
                            document.getElementById('LBLSuccessMessage').textContent = message;
                            const successModal = bootstrap.Modal.getOrCreateInstance(modalEl);
                            if (activeElement && typeof activeElement.blur === 'function') {
                                activeElement.blur();
                            }
                            successModal.show();
                            setTimeout(() => {
                                successModal.hide();
                            }, 1500);
                        }

                        const showTaskResumedModal = function () {
                            const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalTaskResumed'));
                            modal.show();
                            setTimeout(() => modal.hide(), 2000);
                        };

                        const showTaskCopiedModal = function () {
                            const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalTaskCopied'));
                            modal.show();
                            setTimeout(() => modal.hide(), 2000);
                        };

                        const showTaskEndedModal = function () {
                            const modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalTaskEnded'));
                            modal.show();
                            setTimeout(() => modal.hide(), 1500);
                        };

                        const openHoldTaskModal = function (requestId) {
                            const modalEl = document.getElementById('modalTaskHold');
                            if (!modalEl) return;
                            modalEl.setAttribute('data-request-id', requestId);
                            const holdModal = bootstrap.Modal.getOrCreateInstance(modalEl);
                            const btnConfirm = document.getElementById('btnConfirmHold');
                            $('#loadHoldReasons').val(null).trigger('change');
                            const newBtnConfirm = btnConfirm.cloneNode(true);
                            btnConfirm.parentNode.replaceChild(newBtnConfirm, btnConfirm);
                            newBtnConfirm.addEventListener('click', async () => {
                                const reason = $('#loadHoldReasons').val();
                                if (!reason) {
                                    alert("Please select a reason.");
                                    return;
                                }
                                const UID = sessionStorage.getItem('ID');
                                const encRequestId = Encrypt(requestId.toString());
                                const encReason = Encrypt(reason);
                                const encUserId = Encrypt(UID);
                                const encPorterIds = Encrypt('');
                                const encMiIndex = Encrypt('0');
                                const encProcess = Encrypt('SETONHOLDTASKS');
                                holdModal.hide();
                                try {
                                    const res = await fetch('/Index/Service/Service.aspx?' + new URLSearchParams({ Process: encProcess }), {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/json' },
                                        body: JSON.stringify({
                                            requestId: encRequestId,
                                            reason: encReason,
                                            userId: encUserId,
                                            porterIds: encPorterIds,
                                            miIndex: encMiIndex
                                        })
                                    });
                                    const text = await res.text();
                                    let data;
                                    try {
                                        data = JSON.parse(text);
                                    } catch (e) {
                                        data = { success: true, message: text };
                                    }
                                    if (data.success) {
                                        showSuccessModal("Task put on hold successfully!");
                                        if (window.RefreshAll) window.RefreshAll();
                                    } else {
                                        alert("Failed to put task on hold: " + (data.message || "Unknown error"));
                                    }
                                } catch (err) {
                                    alert("Network error: " + err.message);
                                }
                            });
                            holdModal.show();
                        };

                        const openCancelTaskModal = function (requestId) {
                            const modalEl = document.getElementById('modalTaskCancel');
                            if (!modalEl) return;
                            modalEl.setAttribute('data-request-id', requestId);
                            const cancelModal = bootstrap.Modal.getOrCreateInstance(modalEl);
                            const btnConfirm = document.getElementById('btnConfirmCancelTask');
                            document.getElementById('ddlCancelReasons').value = '';
                            const newBtnConfirm = btnConfirm.cloneNode(true);
                            btnConfirm.parentNode.replaceChild(newBtnConfirm, btnConfirm);
                            newBtnConfirm.addEventListener('click', async () => {
                                const selectedReason = document.getElementById('ddlCancelReasons').value.trim();
                                if (!selectedReason) {
                                    alert("Please select a reason for cancellation.");
                                    return;
                                }
                                const UID = sessionStorage.getItem('ID');
                                const encRequestId = Encrypt(requestId);
                                const encPrebook = Encrypt('NO');
                                const encReason = Encrypt(selectedReason);
                                const encPorterIds = Encrypt('');
                                const encUserId = Encrypt(UID || '');
                                const encMiIndex = Encrypt('0');
                                const encProcess = Encrypt('CANCELREQUEST');
                                cancelModal.hide();
                                try {
                                    const res = await fetch('/Index/Service/Service.aspx?' + new URLSearchParams({ Process: encProcess }), {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/json' },
                                        body: JSON.stringify({
                                            requestId: encRequestId,
                                            prebook: encPrebook,
                                            reason: encReason,
                                            porterIds: encPorterIds,
                                            userId: encUserId,
                                            miIndex: encMiIndex
                                        })
                                    });
                                    const text = await res.text();
                                    let data;
                                    try {
                                        data = JSON.parse(text);
                                    } catch (e) {
                                        data = { success: true, message: text };
                                    }
                                    if (data.success) {
                                        showSuccessModal("Task cancelled successfully!");
                                        if (window.RefreshAll) window.RefreshAll();
                                    } else {
                                        alert("Failed to cancel task: " + (data.message || "Unknown error"));
                                    }
                                } catch (err) {
                                    console.error("Network error during cancel:", err);
                                    alert("Network error: " + err.message);
                                }
                            });
                            cancelModal.show();
                        };

                        const localRenderedIds = new Set();

                        tasks.forEach(task => {
                            if (localRenderedIds.has(task.REQUESTID)) return;
                            localRenderedIds.add(task.REQUESTID);

                            const row = template.content.firstElementChild.cloneNode(true);

                            const categoryEl = row.querySelector('.task-category');
                            const fromEl = row.querySelector('.task-from');
                            const toEl = row.querySelector('.task-to');
                            const equipmentEl = row.querySelector('.task-equipment-name');
                            const patientEl = row.querySelector('.task-patient-name');
                            const contactEl = row.querySelector('.task-contact-no');
                            const requestorEl = row.querySelector('.task-requestor-info');
                            const porterEl = row.querySelector('.task-porter-name');
                            const multiporterEl = row.querySelector('.task-multiporter-info');
                            const prebookEl = row.querySelector('.task-prebook-info');
                            const statusEl = row.querySelector('.task-status');
                            const dropdownEl = row.querySelector('.task-dropdown-menu');
                            const badgeEl = row.querySelector('.task-badge');

                            categoryEl.textContent = `${task.CATEGORYNAME} #${task.REQUESTID}`;
                            fromEl.textContent = task.FROM;
                            toEl.textContent = task.TO;
                            equipmentEl.textContent = task.EquipmentName;
                            patientEl.textContent = task.PATIENTNAME || 'N/A';
                            contactEl.innerHTML = task.CONTACTNO ? `<i class="bi bi-telephone text-dark"></i> ${task.CONTACTNO}` : '';
                            requestorEl.innerHTML = `
            <div class="d-flex align-items-center gap-1 requestor-info" style="cursor: pointer;" data-requestor="${task.REQUESTDESKREMARKS || 'No Remarks'}" data-bs-toggle="modal" data-bs-target="#requestorModal" title="View full Remarks">
                <i class="bi bi-journal-text text-dark"></i>
                <span>${task.REQUESTOR || task.REQUESTORNAME || 'N/A'}</span>
            </div>
        `;
                            porterEl.textContent = task.PORTERNAME || 'N/A';
                            multiporterEl.innerHTML = (task.ISMULTIPORTER || '').toLowerCase() === 'yes'
                                ? `<div class="d-flex align-items-center gap-1"><i class="bi bi-person-plus-fill" style="color:grey;"></i> Assistant Required</div>` : '';
                            prebookEl.innerHTML = (task.ISPREBOOK || '').toLowerCase() === 'yes'
                                ? `<div class="d-flex align-items-center gap-1"><i class="bi bi-calendar-check-fill" style="color:grey;"></i> Prebooked Task - ${task.REQUESTTIME || ''}</div>` : '';
                            statusEl.textContent = task.REQUESTSTATUS || 'Status';

                            if (listId === 'pendingList') {
                                dropdownEl.innerHTML = `
            <li><a class="dropdown-item edit-task" href="#" data-request-id="${task.REQUESTID}" data-raw-request-id="${task.REQUESTID}"><i class="bi bi-pencil-square me-2"></i> Edit Task</a></li>
            <li><a class="dropdown-item hold-task" href="#" data-request-id="${task.REQUESTID}"><i class="bi bi-pause-circle me-2"></i> Hold task</a></li>
            <li><a class="dropdown-item resume-task ${task.REQUESTSTATUS === 'On-Hold' ? '' : 'disabled faded'}" href="#" data-request-id="${task.REQUESTID}"><i class="bi bi-play-circle me-2"></i> Resume task</a></li>
            <li><a class="dropdown-item assign-task" href="#" data-request-id="${task.REQUESTID}"><i class="bi bi-person-plus me-2"></i> Assign</a></li>
            <li><a class="dropdown-item show-details-btn" href="#" data-request-id="${task.REQUESTID}"><i class="bi bi-journal-text me-2"></i> Show details</a></li>
            <li><a class="dropdown-item copy-task" href="#" data-request-id="${task.REQUESTID}" data-raw-request-id="${task.REQUESTID}"><i class="bi bi-clipboard me-2"></i> Copy task</a></li>
            <li><a class="dropdown-item text-danger cancel-task" href="#" data-request-id="${task.REQUESTID}"><i class="bi bi-trash me-2"></i> Cancel task</a></li>
        `;
                            } else {
                                dropdownEl.innerHTML = `
            <li><a class="dropdown-item reassign-task" href="#" data-bs-toggle="modal" data-bs-target="#reassignModal" data-request-id="${task.REQUESTID}"><i class="bi bi-arrow-left-right me-2"></i> Reassign</a></li>
            <li><a class="dropdown-item edit-task" href="#" data-request-id="${task.REQUESTID}" data-raw-request-id="${task.REQUESTID}"><i class="bi bi-pencil-square me-2"></i> Edit Task</a></li>
            <li><a class="dropdown-item show-details-btn" href="#" data-request-id="${task.REQUESTID}"><i class="bi bi-journal-text me-2"></i> Show details</a></li>
            <li><a class="dropdown-item hold-task" href="#" data-request-id="${task.REQUESTID}"><i class="bi bi-pause-circle me-2"></i> Hold task</a></li>
            <li><a class="dropdown-item copy-task" href="#" data-request-id="${task.REQUESTID}" data-raw-request-id="${task.REQUESTID}"><i class="bi bi-clipboard me-2"></i> Copy task</a></li>
            <li><a class="dropdown-item text-danger cancel-task" href="#" data-request-id="${task.REQUESTID}"><i class="bi bi-trash me-2"></i> Cancel task</a></li>
            <li><a class="dropdown-item text-danger end-task" href="#" data-request-id="${task.REQUESTID}"><i class="bi bi-stop-circle me-2"></i> End task</a></li>
        `;
                            }

                            const timeDiff = parseTimeDifference(task.TimeDifference || "0h 0m");
                            badgeEl.style.backgroundColor = timeDiff < 0 ? '#FADBD8' : '#E2F6D9';
                            badgeEl.style.color = timeDiff < 0 ? '#922B21' : '#196F3D';
                            badgeEl.textContent = task.TimeDifference || '0m';

                            row.querySelectorAll('.hold-task').forEach(btn => {
                                btn.addEventListener('click', (e) => {
                                    e.preventDefault();
                                    e.stopPropagation();
                                    openHoldTaskModal(task.REQUESTID);
                                });
                            });

                            row.querySelectorAll('.cancel-task').forEach(btn => {
                                btn.addEventListener('click', (e) => {
                                    e.preventDefault();
                                    e.stopPropagation();
                                    openCancelTaskModal(task.REQUESTID);
                                });
                            });

                            row.querySelectorAll('.resume-task').forEach(resumeBtn => {
                                if (!resumeBtn.classList.contains('disabled')) {
                                    resumeBtn.addEventListener('click', async (e) => {
                                        e.preventDefault();
                                        e.stopPropagation();
                                        const userId = sessionStorage.getItem('ID');
                                        const encRequestId = Encrypt(task.REQUESTID);
                                        const encUserId = Encrypt(userId);
                                        const encProcess = Encrypt('RELEASEONHOLD');
                                        try {
                                            const res = await fetch('/Index/Service/Service.aspx?' + new URLSearchParams({ Process: encProcess }), {
                                                method: 'POST',
                                                headers: { 'Content-Type': 'application/json' },
                                                body: JSON.stringify({ requestId: encRequestId, userId: encUserId })
                                            });
                                            const text = await res.text();
                                            let data;
                                            try {
                                                data = JSON.parse(text);
                                            } catch (e) {
                                                data = { success: true, message: text };
                                            }
                                            if (data.success) {
                                                showTaskResumedModal();
                                                if (window.RefreshAll) window.RefreshAll();
                                            } else {
                                                alert("Failed to resume task: " + (data.message || "Unknown error"));
                                            }
                                        } catch (err) {
                                            alert("Network error: " + err.message);
                                        }
                                    });
                                }
                            });

                            row.querySelectorAll('.copy-task').forEach(copyBtn => {
                                copyBtn.addEventListener('click', async (e) => {
                                    e.preventDefault();
                                    e.stopPropagation();
                                    const encRequestId = Encrypt(task.REQUESTID);
                                    const encProcess = Encrypt('COPYTASK');
                                    try {
                                        const res = await fetch('/Index/Service/Service.aspx?' + new URLSearchParams({ Process: encProcess }), {
                                            method: 'POST',
                                            headers: { 'Content-Type': 'application/json' },
                                            body: JSON.stringify({ requestId: encRequestId })
                                        });
                                        const text = await res.text();
                                        let data;
                                        try {
                                            data = JSON.parse(text);
                                        } catch (e) {
                                            data = { success: true, message: text };
                                        }
                                        if (data.success) {
                                            showTaskCopiedModal();
                                            if (window.RefreshAll) window.RefreshAll();
                                        } else {
                                            alert('Error copying task: ' + (data.message || 'Unknown error'));
                                        }
                                    } catch (err) {
                                        alert('Network error: ' + err.message);
                                    }
                                });
                            });

                            row.querySelectorAll('.assign-task').forEach(assignBtn => {
                                assignBtn.addEventListener('click', (e) => {
                                    e.preventDefault();
                                    e.stopPropagation();
                                    currentRequestId = task.REQUESTID;
                                    const responseKPI = parseInt(task.RESPONSEKPICAL || "-1", 10);
                                    const assignModalEl = document.getElementById('assignModal');
                                    const kpiModalEl = document.getElementById('kpiModal');
                                    const assignModal = bootstrap.Modal.getOrCreateInstance(assignModalEl);
                                    const kpiModal = bootstrap.Modal.getOrCreateInstance(kpiModalEl);
                                    function openAssign() {
                                        const filterInput = document.getElementById('assignEmployeeFilter');
                                        const container = document.getElementById('freeEmployeeList');
                                        if (filterInput) filterInput.value = '';
                                        if (container) container.innerHTML = '';
                                        document.querySelectorAll('.modal.show').forEach(modalEl => bootstrap.Modal.getInstance(modalEl)?.hide());
                                        assignModal.show();
                                    }
                                    if (responseKPI < 0) {
                                        currentKPIRequestId = task.REQUESTID;
                                        const ddlKPIReasons = document.getElementById('ddlKPIReasons');
                                        const kpiActionBtn = document.getElementById('kpiModalActionBtn');
                                        ddlKPIReasons.value = "";
                                        const newActionBtn = kpiActionBtn.cloneNode(true);
                                        kpiActionBtn.parentNode.replaceChild(newActionBtn, kpiActionBtn);
                                        newActionBtn.addEventListener('click', () => {
                                            const reason = ddlKPIReasons.value.trim();
                                            if (!reason) {
                                                alert('Please select a reason for the negative KPI before proceeding.');
                                                return;
                                            }
                                            kpiModal.hide();
                                            openAssign();
                                        });
                                        kpiModal.show();
                                    } else {
                                        openAssign();
                                    }
                                });
                            });

                            row.querySelectorAll('.show-details-btn').forEach(detailsBtn => {
                                detailsBtn.addEventListener('click', (e) => {
                                    e.preventDefault();
                                    e.stopPropagation();
                                    fetchTaskDetailsAndShow(task.REQUESTID);
                                });
                            });

                            row.querySelectorAll('.end-task').forEach(endBtn => {
                                endBtn.addEventListener('click', async (e) => {
                                    e.preventDefault();
                                    e.stopPropagation();
                                    if (endBtn.dataset.processing === "true") return;
                                    endBtn.dataset.processing = "true";
                                    const completeTask = async () => {
                                        try {
                                            const encProcessDetails = Encrypt('GetSingleRequestDetails');
                                            const encRequestId = Encrypt(task.REQUESTID);
                                            const taskRes = await fetch(`/Index/Service/Service.aspx?Process=${encodeURIComponent(encProcessDetails)}&requestId=${encodeURIComponent(encRequestId)}`);
                                            const taskText = await taskRes.text();
                                            let taskDetails;
                                            try {
                                                taskDetails = JSON.parse(taskText);
                                            } catch (e) {
                                                throw new Error("Failed to parse task details");
                                            }
                                            if (!Array.isArray(taskDetails) || taskDetails.length === 0) {
                                                throw new Error("No task details found");
                                            }
                                            const currentTask = taskDetails[0];
                                            const porterId = currentTask.PORTERID;
                                            if (!porterId) {
                                                throw new Error("No porter assigned to this task. Cannot end task.");
                                            }
                                            const now = new Date();
                                            const formattedEndTime = `${(now.getMonth() + 1).toString().padStart(2, '0')}/${now.getDate().toString().padStart(2, '0')}/${now.getFullYear()} ${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}:${now.getSeconds().toString().padStart(2, '0')}`;
                                            const encProcessComplete = Encrypt('COMPLETETASK');
                                            const payload = {
                                                requestId: encRequestId,
                                                userId: Encrypt(porterId.toString()),
                                                requestStatus: Encrypt('COMPLETETASK'),
                                                porterRemarks: Encrypt(''),
                                                startTime: Encrypt(''),
                                                endTime: Encrypt(formattedEndTime),
                                                remarksId: Encrypt(''),
                                                name: Encrypt(''),
                                                phoneNo: Encrypt(''),
                                                catSignFName: Encrypt(''),
                                                catPhotoFName: Encrypt(''),
                                                ackPhotoTimeStamp: Encrypt(''),
                                                ackLocStamp: Encrypt(''),
                                                process: Encrypt('COMPLETETASK')
                                            };
                                            const completeRes = await fetch(`/Index/Service/Service.aspx?Process=${encodeURIComponent(encProcessComplete)}`, {
                                                method: 'POST',
                                                headers: { 'Content-Type': 'application/json' },
                                                body: JSON.stringify(payload)
                                            });
                                            const completeText = await completeRes.text();
                                            let result;
                                            try {
                                                result = JSON.parse(completeText.replace(/\[\]$/, ''));
                                            } catch (e) {
                                                throw new Error("Failed to parse response");
                                            }
                                            if (result.success) {
                                                showTaskEndedModal();
                                                if (window.RefreshAll) window.RefreshAll();
                                            } else {
                                                throw new Error(result.message || "Unknown error");
                                            }
                                        } catch (err) {
                                            console.error("Complete task failed:", err);
                                            alert(err.message || "Error completing task");
                                        } finally {
                                            endBtn.dataset.processing = "false";
                                            currentRequestId = null;
                                        }
                                    };
                                    const completionKPI = parseInt(task.COMPLETIONKPICAL || "-19090909090909", 10);
                                    if (completionKPI === -19090909090909) {
                                        endBtn.dataset.processing = "false";
                                        return;
                                    }
                                    if (completionKPI < 0) {
                                        currentRequestId = task.REQUESTID;
                                        document.querySelectorAll('.modal.show').forEach(modalEl => bootstrap.Modal.getInstance(modalEl)?.hide());
                                        const kpiModalEl = document.getElementById('kpiModal');
                                        if (!kpiModalEl) {
                                            endBtn.dataset.processing = "false";
                                            return;
                                        }
                                        const ddlKPIReasons = kpiModalEl.querySelector('#ddlKPIReasons');
                                        ddlKPIReasons.value = '';
                                        const actionBtn = kpiModalEl.querySelector('#kpiModalActionBtn');
                                        const newActionBtn = actionBtn.cloneNode(true);
                                        actionBtn.parentNode.replaceChild(newActionBtn, actionBtn);
                                        const closeBtn = kpiModalEl.querySelector('.btn-close');
                                        const newCloseBtn = closeBtn.cloneNode(true);
                                        closeBtn.parentNode.replaceChild(newCloseBtn, closeBtn);
                                        newActionBtn.addEventListener('click', () => {
                                            const selectedReason = ddlKPIReasons.value.trim();
                                            if (!selectedReason) {
                                                alert('Please select a reason for negative KPI before proceeding.');
                                                return;
                                            }
                                            bootstrap.Modal.getInstance(kpiModalEl).hide();
                                            completeTask();
                                        });
                                        newCloseBtn.addEventListener('click', () => {
                                            ddlKPIReasons.value = '';
                                            bootstrap.Modal.getInstance(kpiModalEl).hide();
                                            endBtn.dataset.processing = "false";
                                            currentRequestId = null;
                                        });
                                        const kpiModal = bootstrap.Modal.getOrCreateInstance(kpiModalEl);
                                        kpiModal.show();
                                    } else {
                                        completeTask();
                                    }
                                });
                            });

                            fragment.appendChild(row);
                        });

                        // Only replace content if we have data to show
                        if (fragment.children.length > 0) {
                            taskList.innerHTML = '';
                            taskList.appendChild(fragment);
                        } else if (!hasExistingData) {
                            taskList.innerHTML = `
            <div class="text-center p-4">
                <i class="bi bi-inbox fs-1 mb-3 text-muted opacity-50 d-block"></i>
                <div class="h6 fw-semibold text-muted mb-1">No tasks found</div>
                <small class="text-muted">No tasks match your filters</small>
            </div>
        `;
                        }
                    }

                    function getCurrentTaskLoader(serviceId) {
                        const checkbox = document.getElementById('showPrebookedCheckbox');
                        if (checkbox && checkbox.checked) {
                            return () => reloadPrebookTasks(serviceId);
                        }
                        return () => reloadTasks(serviceId);
                    }

                    isRefreshing = false;

                    window.RefreshTasksRequestId = null;
                    window.RefreshTasksTasks = null;
                    window.RefreshTasksListId = null;

                    window.RefreshTasks = async function (filter = '', serviceId = '') {
                        if (isRefreshing) return;
                        isRefreshing = true;

                        clearInterval(AutoRefresh);
                        cleanupAbortControllers();
                        abortAllFetchRequests();
                        LoaderOn();

                        try {
                            const prebookedCheckbox = document.getElementById('showPrebookedCheckbox');
                            if (prebookedCheckbox) prebookedCheckbox.checked = false;

                            ['pendingFilter', 'startedFilter', 'employeeFilter'].forEach(id => {
                                const input = document.getElementById(id);
                                if (input) input.value = '';
                            });

                            Object.keys(filters).forEach(key => filters[key] = "");

                            ['pendingNoData', 'startedNoData'].forEach(id => {
                                const elem = document.getElementById(id);
                                if (elem) elem.classList.add('d-none');
                            });

                            const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                            const serviceIdFinal = serviceId || (activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '');

                            const taskLoader = getCurrentTaskLoader(serviceIdFinal);
                            await taskLoader();
                            await new Promise(resolve => setTimeout(resolve, 100));
                            await reloadStartedTasks(serviceIdFinal);
                            await new Promise(resolve => setTimeout(resolve, 100));
                            await window.employeeLoader('', serviceIdFinal);
                            await loadEmployees(filter, serviceIdFinal);

                        } catch (err) {
                            console.error("Error in RefreshTasks:", err);
                        } finally {
                            LoaderOff(1000);
                            saveUIState();
                            RestartTimer_AutoRefresh();
                            isRefreshing = false;
                        }
                    };

                    async function loadEmployees(filter = '', serviceId = '') {
                        if (window.RefreshTasksTasks && window.RefreshTasksListId) {
                            requestIdleCallback(() => {
                                renderTasksFromSP(window.RefreshTasksTasks, window.RefreshTasksListId);
                            });
                        }

                        await fetchAndRenderTasks("2", "pendingList", serviceId, filter);
                        await new Promise(resolve => setTimeout(resolve, 100));
                        await fetchAndRenderTasks("4", "startedList", serviceId, filter);
                        await new Promise(resolve => setTimeout(resolve, 100));

                        if (window.RefreshTasksRequestId) fetchTaskDetailsAndShow(window.RefreshTasksRequestId);
                    }

                    $(function () {
                        LoaderOn();
                        //window.RefreshAll();
                        LoaderOff(1000);

                        clearInterval(window.AutoRefresh);
                        $.xhrPool = [];
                        $.ajaxSetup({
                            beforeSend: function (jqXHR) { $.xhrPool.push(jqXHR); }, //  annd connection to list  -- alert($.xhrPool.length);
                            complete: function (jqXHR) {
                                var i = $.xhrPool.indexOf(jqXHR);   //  get index for current connection completed
                                if (i > -1) $.xhrPool.splice(i, 1); //  removes from list by index  -- alert($.xhrPool.length);
                            }
                        });
                        //setInterval(() => {
                        //    LoaderOn();
                        //    requestAnimationFrame(() => {
                        //        window.RefreshAll();
                        //        LoaderOff(450);
                        //    });
                        //}, 5000);
                    });

                    window.NewAutoRefresh = async function () {
                        if (isRefreshing) return;
                        isRefreshing = true;
                        cleanupAbortControllers();

                        try {
                            const employeeFilterElem = document.getElementById('employeeFilter');
                            const currentFilter = employeeFilterElem?.value || '';
                            const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                            const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';
                            const taskLoader = getCurrentTaskLoader(serviceId);
                            await taskLoader();
                            await new Promise(resolve => setTimeout(resolve, 100));
                            await reloadStartedTasks(serviceId);
                            await new Promise(resolve => setTimeout(resolve, 100));
                            if (employeeFilterElem) {
                                await window.employeeLoader(currentFilter, serviceId);
                                employeeFilterElem.value = currentFilter;
                            }

                        } catch (err) {
                            console.error("Error during refresh:", err);
                        } finally {
                            isRefreshing = false;
                        }
                    };
                    document.addEventListener('DOMContentLoaded', () => {
                        window.NewAutoRefresh();
                    });

                    window.RefreshAll = async function () {
                        if (isRefreshing) return;
                        isRefreshing = true;
                        cleanupAbortControllers();

                        try {
                            const employeeFilterElem = document.getElementById('employeeFilter');
                            const currentFilter = employeeFilterElem?.value || '';
                            const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                            const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';
                            const taskLoader = getCurrentTaskLoader(serviceId);
                            await taskLoader();
                            await new Promise(resolve => setTimeout(resolve, 100));
                            await reloadStartedTasks(serviceId);
                            await new Promise(resolve => setTimeout(resolve, 100));
                            if (employeeFilterElem) {
                                await window.employeeLoader(currentFilter, serviceId);
                                employeeFilterElem.value = currentFilter;
                            }
                        } catch (err) {
                            console.error("Error during refresh:", err);
                        } finally {
                            isRefreshing = false;
                        }
                    };

                    document.addEventListener('DOMContentLoaded', () => {
                    });

                    //console.log("Fast Action-refresh");


                    let taskEndedShown = false;

                    function showTaskEndedModal(message = 'Task ended successfully') {
                        if (taskEndedShown) return;
                        taskEndedShown = true;

                        const modalEl = document.getElementById('modalTaskEnded');
                        const lbl = document.getElementById('LBLTaskEndedMessage');
                        if (lbl) lbl.textContent = message; 

                        const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                        modal.show();

                        setTimeout(() => {
                            modal.hide();
                            taskEndedShown = false;  
                        }, 1500);
                        window.RefreshAll();
                    }

                    function fetchTaskDetailsAndShow(requestId) {
                        const encryptedProcess = encryptAES('GetSingleRequestDetails');
                        const encryptedRequestId = encryptAES(requestId); 

                        fetch(`/Index/Service/Service.aspx?Process=${encryptedProcess}&requestId=${encodeURIComponent(encryptedRequestId)}`)
                            .then(response => {
                                if (!response.ok) {
                                    throw new Error(`HTTP error! status: ${response.status}`);
                                }
                                return response.json();
                            })
                            .then(tasks => {

                                const task = tasks && tasks.length > 0 ? tasks[0] : null;

                                if (!task) {
                                    document.getElementById('taskDetailsContent').innerHTML =
                                        `<p class='text-danger'>No details found for Request ID: ${requestId}</p>`;
                                } else {
                                    document.getElementById('taskDetailsContent').innerHTML = `
                                        <div class="task-details p-3">
                                            <p><strong>Request ID:</strong> ${task.REQUESTID || 'N/A'}</p>
                                            <p><strong>Request Date:</strong> ${task.Requestdate || 'N/A'}</p>
                                            <p><strong>Category Name:</strong> ${task.CATEGORYNAME || 'N/A'}</p>
                                            <p><strong>Remarks:</strong> ${task.RequestDeskRemarks || 'N/A'}</p>
                                            <p><strong>From:</strong> ${task.FROM || task.FROM_LOCATION || 'N/A'}</p>
                                            <p><strong>To:</strong> ${task.TO || task.TO_LOCATION || 'N/A'}</p>
                                            <p><strong>Patient Name:</strong> ${task.PATIENTNAME || 'N/A'}</p>
                                            <p><strong>Requestor:</strong> ${task.REQUESTORNAME || 'N/A'}</p>
                                            <p><strong>Equipment Name:</strong> ${task.EquipmentName || 'N/A'}</p>
                                            <p><strong>Porter Description:</strong> ${task.IsMultiPorterDescription || 'N/A'}</p>
                                            <p><strong>Task Description:</strong> ${task.PreBookedTaskDescription || 'Default Task'} - ${task.REQUESTTIME || ''}</p>
                                            <p><strong>Porter:</strong> ${task.PORTERNAME || 'Unassigned'}</p>
                                            <p><strong>Contact No:</strong> ${task.CONTACTNO || 'N/A'}</p>
                                            <p><strong>Status:</strong> ${task.REQUESTSTATUS || 'N/A'}</p>
                                            <p><strong>Time Difference:</strong> ${task.TimeDifference || 'N/A'}</p>
                                        </div>
                                    `;

                                    const modalElement = document.getElementById('taskDetailsModal');
                                    if (modalElement) {
                                        const modal = new bootstrap.Modal(modalElement);
                                        modal.show();
                                    }
                                }
                            })
                            .catch(err => {
                                console.error('Error fetching task details:', err);
                                const contentEl = document.getElementById('taskDetailsContent');
                                if (contentEl) {
                                    contentEl.innerHTML = "<p class='text-danger'>Failed to load details. Please try again.</p>";
                                }
                            });
                    }

                    document.querySelectorAll('.filter-icon').forEach(icon => {
                        icon.addEventListener('click', e => {
                            e.stopPropagation();

                            const panel = icon.nextElementSibling;

                            document.querySelectorAll('.filter-panel').forEach(p => {
                                if (p !== panel) p.style.display = 'none';
                            });

                            const isOpening = panel.style.display !== 'block';
                            panel.style.display = isOpening ? 'block' : 'none';

                            if (isOpening) {
                                stopAutoRefresh();
                            } else {
                                RestartTimer_AutoRefresh();
                            }
                        });
                    });

                    document.querySelectorAll('.filter-panel').forEach(panel => {
                        panel.addEventListener('click', e => e.stopPropagation());
                    });

                    document.addEventListener('click', () => {
                        document.querySelectorAll('.filter-panel').forEach(panel => {
                            panel.style.display = 'none';
                        });
                    });
                    document.addEventListener('DOMContentLoaded', function () {
                        document.addEventListener('click', function (e) {
                            if (e.target.closest('.dropdown-menu')) {
                                e.stopPropagation();
                            }
                        });
                    });

                    document.addEventListener('click', function (e) {
                        const target = e.target.closest('.requestor-info');
                        if (target) {
                            const fullRequestor = target.getAttribute('data-requestor') || 'N/A';
                            document.getElementById('requestorModalContent').textContent = fullRequestor;
                        }
                    });
                });

                const iconBar = document.querySelector('.icon-bar');
                const hamburger = document.getElementById('hamburger');
                const leftPanel = document.querySelector('.screen-left-panel');
                const hospitalImg = document.querySelector('.hospital-img');

                let hideTimeout = null;
                let isHovered = false;

                function hideHospitalImageThenPanel() {
                    if (isHovered) return;

                    hospitalImg.classList.add('hidden');
                    leftPanel.classList.add('hidden');
                    iconBar.classList.remove('hidden');
                    hamburger.classList.remove('hidden');

                }

                function showPanelThenHospitalImage() {
                    clearTimeout(hideTimeout);
                    hamburger.classList.add('hidden');
                    iconBar.classList.add('hidden');

                    leftPanel.classList.remove('hidden');


                    setTimeout(() => {
                        hospitalImg.classList.remove('hidden');
                    }, 300);

                    clearTimeout(hideTimeout);
                    hideTimeout = setTimeout(hideHospitalImageThenPanel, 4000);
                }

                window.addEventListener('load', () => {
                    leftPanel.classList.remove('hidden');
                    hospitalImg.classList.remove('hidden');
                    hamburger.classList.add('hidden');
                    iconBar.classList.add('hidden');

                    hideTimeout = setTimeout(hideHospitalImageThenPanel, 4000);
                });

                [leftPanel, hospitalImg].forEach(el => {
                    el.addEventListener('mouseenter', () => {
                        isHovered = true;
                        clearTimeout(hideTimeout);
                    });

                    el.addEventListener('mouseleave', () => {
                        isHovered = false;
                        clearTimeout(hideTimeout);
                        hideTimeout = setTimeout(hideHospitalImageThenPanel, 3000);
                    });
                });

                hamburger.addEventListener('click', showPanelThenHospitalImage);

                window.onload = function () {
                    const filterInput = document.getElementById('employeeFilter');
                    const ascBtn = document.getElementById('sortAsc');
                    const descBtn = document.getElementById('sortDesc');
                    let currentSortOrder = 'asc';

                    function getActiveServiceId() {
                        const activeBtn = document.querySelector('.services-btn-icon.active');
                        return activeBtn ? activeBtn.id.replace('divService', '') : '';
                    }

                    const cryptoKey = '9090909090909090';
                    const cryptoIV = '9090909090909090';

                    let currentServiceId = '';
                    let lastEmployeeRequest = null;

                    function loadEmployees(filter = '', serviceId = '', sortOrder = currentSortOrder) {
                        if (lastEmployeeRequest && typeof lastEmployeeRequest.abort === 'function') {
                            lastEmployeeRequest.abort();
                        }

                        const container = document.getElementById('employeeList');
                        if (!container) return;

                        const requestId = Date.now().toString();
                        container.setAttribute('data-loading-id', requestId);

                        // ✅ ONLY show loading if list is EMPTY
                        if (container.children.length === 0) {
                            container.innerHTML = `
            <div id="employeeSpinner" class="text-center p-4 loading-spinner" data-loading-id="${requestId}">
                <div class="spinner-border text-info" role="status" style="width: 2rem; height: 2rem;">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <div class="mt-2 fw-semibold text-muted small">Loading employees...</div>
            </div>
        `;
                        } else {
                            // ✅ Just add a class - DON'T clear
                            container.classList.add('refreshing');
                        }

                        if (serviceId == "2") {
                            serviceId = "3";
                        }
                        currentServiceId = serviceId;

                        const encryptedFilter = Encrypt(filter);
                        const encryptedServiceId = Encrypt(serviceId.toString());
                        const encryptedSortOrder = Encrypt(sortOrder);
                        const encryptedProcess = Encrypt('fetchEmployees');

                        const url = `/Index/Service/Service.aspx?Process=${encodeURIComponent(encryptedProcess)}`
                            + `&filter=${encodeURIComponent(encryptedFilter)}`
                            + `&serviceId=${encodeURIComponent(encryptedServiceId)}`
                            + `&sortOrder=${encodeURIComponent(encryptedSortOrder)}`;

                        const controller = new AbortController();
                        lastEmployeeRequest = controller;

                        const currentRequestId = requestId;
                        const currentServiceIdSnapshot = currentServiceId;

                        fetch(url, {
                            signal: controller.signal
                        })
                            .then(response => {
                                if (!response.ok) throw new Error("HTTP error " + response.status);
                                return response.text();
                            })
                            .then(text => {
                                const currentLoadingId = container.getAttribute('data-loading-id');
                                if (currentLoadingId !== currentRequestId) {
                                    return;
                                }

                                container.classList.remove('refreshing');

                                let data;
                                try {
                                    data = JSON.parse(text);
                                } catch (e) {
                                    if (currentLoadingId === currentRequestId) {
                                        container.innerHTML = "<div class='text-center p-4'><div class='h6 fw-semibold text-danger mb-2'>Failed to load employees</div><small class='text-muted'>Invalid response format</small></div>";
                                        container.removeAttribute('data-loading-id');
                                    }
                                    return;
                                }

                                const finalLoadingId = container.getAttribute('data-loading-id');
                                if (finalLoadingId !== currentRequestId || serviceId !== currentServiceIdSnapshot) {
                                    return;
                                }

                                if (data && Array.isArray(data) && data.length > 0) {
                                    container.innerHTML = '';
                                    bindEmployeeData(data, serviceId);
                                } else {
                                    const hasExistingData = container.children.length > 0;
                                    if (!hasExistingData) {
                                        container.innerHTML = "<div id='employeeNoData' class='text-center p-4'><div class='h6 fw-semibold text-muted mb-2'>No employees found</div><small class='text-muted'>No employees match your filters</small></div>";
                                    }
                                }

                                container.removeAttribute('data-loading-id');
                            })
                            .catch(err => {
                                if (container.getAttribute('data-loading-id') !== currentRequestId) {
                                    return;
                                }

                                container.classList.remove('refreshing');

                                if (err.name !== "AbortError") {
                                    console.error("Employee load error:", err);
                                    const hasExistingData = container.children.length > 0;
                                    if (!hasExistingData) {
                                        container.innerHTML = "<div class='text-center p-4'><div class='h6 fw-semibold text-danger mb-2'>Failed to load employees</div><small class='text-muted'>Please try again</small></div>";
                                    }
                                }

                                container.removeAttribute('data-loading-id');
                            });

                        window.employeeLoader = loadEmployees;
                    }
                    function sortTasks(sortOrder) {
                        const filterInput = document.getElementById('employeeFilter');
                        const filter = filterInput ? filterInput.value.trim() : '';
                        const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                        const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';

                        loadEmployees(filter, serviceId, sortOrder);
                    }

                    window.sortTasks = sortTasks;

                    if (ascBtn) ascBtn.addEventListener('click', e => { e.preventDefault(); sortTasks('asc'); });
                    if (descBtn) descBtn.addEventListener('click', e => { e.preventDefault(); sortTasks('desc'); });

                    document.querySelectorAll('.services-btn-icon').forEach(btn => {
                        btn.addEventListener('click', () => {
                            document.querySelectorAll('.services-btn-icon').forEach(b => b.classList.remove('active'));
                            btn.classList.add('active');
                            loadEmployees(filterInput ? filterInput.value.trim() : '', btn.id.replace('divService', ''), currentSortOrder);
                        });
                    });

                    function debounce(func, delay) {
                        let timer;
                        return function (...args) {
                            clearTimeout(timer);
                            timer = setTimeout(() => func.apply(this, args), delay);
                        };
                    }

                    if (filterInput) {
                        filterInput.addEventListener('input', debounce(function () {
                            const filter = this.value.trim();
                            const serviceId = getActiveServiceId();
                            loadEmployees(filter, serviceId, currentSortOrder);
                        }, 500)); 
                    }
                    loadEmployees('', getActiveServiceId(), currentSortOrder);
                };


                function showEmployeeDetails(emp) {
                    const modalTitle = document.getElementById('employeeDetailModalLabel');
                    const modalBody = document.getElementById('employeeDetailBody');

                    let loginTimeFormatted = "N/A";
                    if (emp.LoginedTime && emp.LoginedTime.includes("/Date(")) {
                        const timestamp = parseInt(emp.LoginedTime.replace(/\/Date\((\d+)\)\//, '$1'));
                        if (!isNaN(timestamp)) {
                            const date = new Date(timestamp);
                            loginTimeFormatted = date.toLocaleString(undefined, {
                                year: 'numeric',
                                month: 'short',
                                day: 'numeric',
                                hour: '2-digit',
                                minute: '2-digit',
                                hour12: true
                            });
                        }
                    }

                    let workTimeFormatted = "N/A";
                    if (emp.WORKTIME && !isNaN(emp.WORKTIME)) {
                        const totalMinutes = parseInt(emp.WORKTIME, 10);
                        const hours = Math.floor(totalMinutes / 60);
                        const minutes = totalMinutes % 60;
                        workTimeFormatted = `${hours} hours ${minutes} min`;
                    }

                    modalTitle.textContent = `Employee Name: ${emp.USERNAME || "N/A"}`;
                    modalBody.innerHTML = `
                    <p><strong>Username:</strong> ${emp.USERNAME || "N/A"}</p>
                    <p><strong>Logined Time:</strong> ${loginTimeFormatted}</p>
                    <p><strong>Email:</strong> ${emp.EMAIL || "N/A"}</p>
                    <p><strong>Role:</strong> ${emp.ROLE || "N/A"}</p>
                    <p><strong>Device:</strong> ${emp.DEVICE || "N/A"}</p>
                    <p><strong>Hospital Name:</strong> ${emp.HOSPITALNAME1 || "N/A"}</p>
                    <p><strong>Shift:</strong> ${emp.ALL_DAY || "N/A"}</p>
                    <p><strong>SLA:</strong> ${emp.SLA || "N/A"}</p>
                    <p><strong>Work Time:</strong> ${workTimeFormatted}</p>
                    <p><strong>Location:</strong> ${emp.ZoneName || "N/A"}</p>
                    <p><strong>Status:</strong> ${emp.STATUS || "N/A"}</p>
                    <p>
                      <strong>Task Id:</strong>
                      ${emp.RequestIDs
                            ? emp.RequestIDs.split(',').map(id => `#${id.trim()}`).join(', ')
                            : "Not Assigned"}
                    </p>
                `;

                    const modal = new bootstrap.Modal(document.getElementById('employeeDetailModal'));
                    modal.show();
                }


                function bindEmployeeData(data, serviceId) {
                    const container = document.getElementById('employeeList');

                    if (!data || data.length === 0) {
                        const hasExistingData = container.children.length > 0;
                        if (hasExistingData) {
                            return; 
                        }
                        container.innerHTML = "<p class='text-center text-muted py-4'>No employee data found.</p>";
                        return;
                    }

                    const hasExistingData = container.children.length > 0;

                    const spinner = container.querySelector('.spinner-border');
                    if (spinner) {
                        const spinnerContainer = spinner.closest('.text-center');
                        if (spinnerContainer) spinnerContainer.remove();
                    }

                    container.classList.remove('refreshing');

                    const cardsHTML = data.map(emp => {
                        let serviceLabel = 'N/A';
                        if (emp.EQ_SERVICEID) {
                            const ids = emp.EQ_SERVICEID.toString().split(',').map(id => id.trim());
                            const services = ids.map(id => {
                                if (id === '1') return 'QAH';
                                if (id === '3') return 'R&D';
                                return '';
                            }).filter(Boolean);
                            serviceLabel = services.join(' | ');
                        }

                        const status = (emp.STATUS || '').toLowerCase();
                        const isCheckedOut = status === 'checked out';
                        const isOnBreak = status === 'on break';
                        const isOnMeal = status === 'on meal';
                        const isOnTask = emp.STATUS?.startsWith('On task');

                        const statusColor = emp.STATUS === 'Free' ? '#196F3D' :
                            emp.STATUS?.startsWith('On task') ? '#A14C00' :
                                (isOnMeal || isCheckedOut || isOnBreak) ? '#666' :
                                    '#000';

                        const statusBg = emp.STATUS === 'Free' ? '#E2F6D9' :
                            emp.STATUS?.startsWith('On task') ? '#FFF5E5' :
                                (isOnMeal || isCheckedOut || isOnBreak) ? '#F0F0F0' :
                                    '#EAEAEA';

                        const disableUnless = (condition) => condition ? '' : 'disabled-option';

                        const restBreakLabel = isOnBreak ? 'End rest break' : 'Take rest break';
                        const restBreakAction = isOnBreak ? 'end' : 'start';
                        const restBreakEnabled = isOnBreak || (!isOnMeal && !isCheckedOut && !isOnTask);

                        const mealBreakLabel = isOnMeal ? 'End meal break' : 'Take meal break';
                        const mealBreakAction = isOnMeal ? 'end' : 'start';
                        const mealBreakEnabled = isOnMeal || (!isOnBreak && !isCheckedOut && !isOnTask);

                        const assignEnabled = !(isCheckedOut || isOnBreak || isOnMeal);
                        const messageEnabled = assignEnabled;
                        const checkInEnabled = isCheckedOut;
                        const checkOutEnabled = !(isCheckedOut || isOnBreak || isOnMeal);

                        return `
                <div class="employee-card border rounded p-2 mb-2 shadow-sm d-flex align-items-center justify-content-between">
                    <div class="fw-bold flex-shrink-0" style="min-width: 120px;">${emp.USERNAME || 'N/A'}</div>
                    <div class="text-muted small d-flex align-items-center flex-grow-1 mx-3">
                        <i class="bi bi-clock me-1"></i> ${emp.WORKTIME || '0'}
                        <span class="mx-3"><i class="bi bi-geo-alt-fill me-1"></i> ${emp.LOCATION || "N/A"}</span>
                        <span class="mx-3"><i class="bi bi-person-badge me-1"></i> ${serviceLabel}</span>
                    </div>
                    <span>${emp.ACTION || ''}</span>

                    <div class="d-flex align-items-center flex-shrink-0 dropdown">
                        <button class="btn btn-link text-muted p-0 m-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-three-dots fs-5"></i>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li>
                                <a class="dropdown-item d-flex align-items-center openAssignRequestModal ${disableUnless(assignEnabled)}"
                                   href="#"
                                   data-employee="${emp.ID}"
                                   data-type="porter">
                                   <i class="bi bi-person-plus me-2"></i> Assign
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center openAssignRequestModal ${disableUnless(assignEnabled)}"
                                   href="#"
                                   data-employee="${emp.ID}"
                                   data-type="assistant">
                                   <i class="bi bi-people me-2"></i> Assign assistant
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center openBulkAssignModal ${disableUnless(assignEnabled)}"
                                   href="#"
                                   data-employee="${emp.ID}"
                                   data-type="bulk">
                                   <i class="bi bi-person-lines-fill me-2"></i> Bulk Assign
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center take-rest-break ${disableUnless(restBreakEnabled)}"
                                   href="#"
                                   data-id="${emp.ID}"
                                   data-status="${emp.STATUS?.toLowerCase()}"
                                   data-name="${emp.USERNAME || ''}"
                                   data-action="${restBreakAction}">
                                   <i class="bi bi-cup-hot me-2"></i> ${restBreakLabel}
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center take-meal-break ${disableUnless(mealBreakEnabled)}"
                                   href="#"
                                   data-id="${emp.ID}"
                                   data-status="${emp.STATUS?.toLowerCase()}"
                                   data-name="${emp.USERNAME || ''}"
                                   data-action="${mealBreakAction}">
                                   <i class="fas fa-utensils me-2"></i> ${mealBreakLabel}
                                </a>
                            </li>
                            <li class="message-menu-item">
                                <a class="dropdown-item d-flex align-items-center send-message ${disableUnless(messageEnabled)}"
                                   href="#"
                                   data-id="${emp.ID}">
                                   <i class="bi bi-chat-dots me-2"></i> Message
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center check-in ${disableUnless(checkInEnabled)}"
                                   href="#"
                                   data-id="${emp.ID}"
                                   data-name="${emp.USERNAME || ''}">
                                   <i class="bi bi-box-arrow-in-right me-2"></i> Check In
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center check-out ${disableUnless(checkOutEnabled)}"
                                   href="#"
                                   data-id="${emp.ID}"
                                   data-name="${emp.USERNAME || ''}">
                                   <i class="bi bi-box-arrow-right me-2"></i> Check Out
                                </a>
                            </li>
                            <li>
                                <a class="dropdown-item d-flex align-items-center show-details"
                                   href="#"
                                   data-username="${emp.USERNAME}">
                                   <i class="bi bi-journal-text me-2"></i> Show details
                                </a>
                            </li>
                        </ul>
                        <span class="badge ms-2"
                              style="background-color: ${statusBg}; color: ${statusColor};">
                            ${emp.STATUS || 'N/A'}
                                    </span>
                                </div>
                            </div>`;

                    }).join(''); 

                    if (cardsHTML && cardsHTML.length > 0) {
                        const frag = document.createRange().createContextualFragment(cardsHTML);
                        container.innerHTML = '';
                        container.appendChild(frag);
                    } else if (!hasExistingData) {
                        container.innerHTML = `
                        <div class="text-center p-5">
                            <i class="bi bi-exclamation-triangle fs-1 mb-3 text-danger"></i>
                            <div class="h5 fw-semibold text-danger mb-2">Failed to load employees</div>
                            <small class="text-muted">Please try again</small>
                        </div>
                    `;
                                }

                    const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                    const originalServiceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : "";

                    const messageMenuItems = container.querySelectorAll('.message-menu-item');
                    messageMenuItems.forEach(item => {
                        if (originalServiceId === "1") {
                            item.style.display = "none";
                        } else if (originalServiceId === "2") {
                            item.style.display = "list-item";
                        }
                    });

                    container.querySelectorAll('.show-details').forEach(item => {
                        item.addEventListener('click', (e) => {
                            e.preventDefault();
                            const username = e.currentTarget.getAttribute('data-username');
                            const employee = data.find(emp => emp.USERNAME === username);
                            if (employee) showEmployeeDetails(employee);
                        });
                    });

                    function showEmployeeActionSuccess(message) {
                        const modalEl = document.getElementById('modalGenericSuccess');
                        const successModal = bootstrap.Modal.getOrCreateInstance(modalEl);

                        document.getElementById('LBLGenericSuccessResult').textContent = message;

                        successModal.show();

                        window.RefreshAll();
                        setTimeout(() => {
                            successModal.hide();
                        }, 2000);
                    }

                    function showPorterWarningModal(message = "Porter is already in a task.") {
                        const modalEl = document.getElementById('porterWarningModal');
                        document.getElementById('porterWarningText').innerText = message;

                        const modal = new bootstrap.Modal(modalEl);
                        modal.show();

                        setTimeout(() => modal.hide(), 1000);
                    }

                    function closePorterWarningModal() {
                        const modalEl = document.getElementById('porterWarningModal');
                        const modal = bootstrap.Modal.getInstance(modalEl);
                        if (modal) modal.hide();
                    }

                    let selectedBreakDuration = null;

                    const processingUsers = {
                        restStart: new Set(),
                        restEnd: new Set(),
                        mealStart: new Set(),
                        mealEnd: new Set()
                    };

                    const cooldownUsers = {
                        restStart: new Set(),
                        restEnd: new Set(),
                        mealStart: new Set(),
                        mealEnd: new Set()
                    };

                    const breakModalEl = document.getElementById('breakDurationModal');
                    const breakModal = new bootstrap.Modal(breakModalEl);

                    function syncButtonStates() {
                        document.querySelectorAll('.take-rest-break, .take-meal-break').forEach(btn => {
                            const userId = parseInt(btn.dataset.id, 10);
                            const action = btn.dataset.action;
                            const breakType = btn.classList.contains('take-rest-break') ? 'rest' : 'meal';

                            if (!action) {
                                console.warn("Missing action attribute for button:", btn);
                                return;
                            }

                            const actionType = `${breakType}${action.charAt(0).toUpperCase() + action.slice(1)}`;

                            const locked =
                                processingUsers[actionType]?.has(userId) ||
                                cooldownUsers[actionType]?.has(userId);

                            btn.disabled = locked;
                        });
                    }

                    if (typeof window.RefreshAll === "function") {
                        const original = window.RefreshAll;
                        window.RefreshAll = function () {
                            original.apply(this, arguments);
                            setTimeout(syncButtonStates, 0);
                        };
                    }

                    if (!window._breakHandlerBound) {
                        window._breakHandlerBound = true;

                        if (!breakModal) {
                            breakModal = new bootstrap.Modal(breakModalEl);
                        }
                        document.addEventListener('click', function (e) {
                            const button = e.target.closest('.take-rest-break, .take-meal-break');
                            if (!button) return;

                            e.preventDefault();

                            const userId = parseInt(button.dataset.id, 10);
                            const action = button.dataset.action;
                            const breakType = button.classList.contains('take-rest-break') ? 'rest' : 'meal';
                            const safeAction = String(action || '');
                            const actionType = `${breakType}${safeAction.charAt(0).toUpperCase() + safeAction.slice(1)}`;

                            if (!userId || !action) return;
                            if (processingUsers[actionType].has(userId) || cooldownUsers[actionType].has(userId)) return;

                            if (action === 'end') {
                                const endpoint = breakType === 'rest' ? 'EndRestBreak' : 'EndMealBreak';
                                const encProcess = Encrypt(endpoint);
                                const encUserId = Encrypt(userId.toString());

                                processingUsers[actionType].add(userId);
                                syncButtonStates();

                                fetch(`/Index/Service/Service.aspx?Process=${encodeURIComponent(encProcess)}`, {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                                    body: JSON.stringify({ id: encUserId }) 
                                })
                                    .then(res => res.text()) 
                                    .then(text => {
                                        //console.log("END BREAK RAW:", text);
                                        const result = JSON.parse(text.replace(/\[\]$/, '')); 

                                        if (result.success) {
                                            showEmployeeActionSuccess(`Porter ${userId}: ${result.message}`);
                                            button.dataset.status = 'available';
                                            button.dataset.action = 'start';
                                            startCooldown(actionType, userId);
                                        } else {
                                            showEmployeeActionSuccess(`Error: ${result.message}`);
                                            processingUsers[actionType].delete(userId);
                                            syncButtonStates();
                                        }
                                    })
                                    .catch(err => {
                                        console.error("End break error:", err);
                                        alert("Network error: " + err.message);
                                        processingUsers[actionType].delete(userId);
                                        syncButtonStates();
                                    });
                            } else {
                                document.querySelectorAll('.modal.show')
                                    .forEach(m => bootstrap.Modal.getInstance(m)?.hide());

                                document.getElementById('breakType').value = breakType;
                                document.getElementById('breakUserId').value = userId;
                                document.getElementById('breakDurationInput').value = '';
                                selectedBreakDuration = null;
                                document.getElementById('confirmBreakBtn').disabled = true;
                                breakModal.show();
                            }
                        });

                        breakModalEl.addEventListener('hidden.bs.modal', () => {
                        });

                        document.getElementById('breakDurationInput')
                            .addEventListener('input', function () {
                                const value = parseInt(this.value, 10);
                                selectedBreakDuration =
                                    (!isNaN(value) && value > 0 && value <= 180) ? value : null;
                                document.getElementById('confirmBreakBtn').disabled = !selectedBreakDuration;
                            });

                        document.querySelectorAll('[data-bs-dismiss="modal"]').forEach(button => {
                            button.addEventListener('click', closeBreakModal);
                        });

                        function closeBreakModal() {
                            breakModal.hide();
                        }

                        document.getElementById('confirmBreakBtn').addEventListener('click', function () {
                            const btn = this;
                            const breakType = document.getElementById('breakType').value;
                            const userId = parseInt(document.getElementById('breakUserId').value, 10);
                            const actionType = `${breakType}Start`;

                            if (!selectedBreakDuration || !userId) return;
                            if (processingUsers[actionType].has(userId) || cooldownUsers[actionType].has(userId)) return;

                            btn.disabled = true;
                            processingUsers[actionType].add(userId);
                            syncButtonStates();

                            const encProcess = Encrypt(breakType === 'rest' ? 'TriggerPorterBreak' : 'TriggerPorterMealBreak');
                            const encUserId = Encrypt(userId.toString());
                            const encDuration = Encrypt(selectedBreakDuration.toString());
                            const encEnd = Encrypt('false');

                            fetch(`/Index/Service/Service.aspx?Process=${encodeURIComponent(encProcess)}`, {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json; charset=utf-8' },
                                body: JSON.stringify({
                                    request: {
                                        id: encUserId,
                                        duration: encDuration,
                                        end: encEnd
                                    }
                                })
                            })
                                .then(res => res.text()) 
                                .then(text => {
                                    const result = JSON.parse(text.replace(/\[\]$/, '')); 

                                    if (result.message && result.message.includes("Porter is already in Task")) {
                                        showPorterWarningModal(result.message);
                                    } else if (result.success) {
                                        showEmployeeActionSuccess(`Porter ${userId}: ${result.message}`);
                                        const breakBtn = document.querySelector(`[data-id="${userId}"][data-action="start"]`);
                                        if (breakBtn) {
                                            breakBtn.dataset.status = breakType === 'rest' ? 'on break' : 'on meal';
                                            breakBtn.dataset.action = 'end';
                                        }
                                        startCooldown(actionType, userId);
                                    } else {
                                        showEmployeeActionSuccess(`Error: ${result.message}`);
                                        processingUsers[actionType].delete(userId);
                                        syncButtonStates();
                                    }

                                    breakModal.hide();
                                    if (typeof window.RefreshAll === 'function') window.RefreshAll();
                                })
                                .catch(err => {
                                    console.error("Break error:", err);
                                    alert("Network error: " + err.message);
                                    processingUsers[actionType].delete(userId);
                                    btn.disabled = false;
                                    syncButtonStates();
                                });
                        });
                    }

                    function startCooldown(actionType, userId) {
                        cooldownUsers[actionType].add(userId);
                        setTimeout(() => {
                            cooldownUsers[actionType].delete(userId);
                            processingUsers[actionType].delete(userId);
                            syncButtonStates();
                        }, 30000);
                    }

                        let forceModalInterval = null;

                        function forceModalOnTop() {

                            if (forceModalInterval) {
                                clearInterval(forceModalInterval);
                                forceModalInterval = null;
                            }

                            if (!document.getElementById("modal-backdrop-ultimate-fix")) {

                                const style = document.createElement("style");
                                style.id = "modal-backdrop-ultimate-fix";

                                style.innerHTML = `
            .modal-backdrop,
            .modal-backdrop.show,
            .modal-backdrop.fade,
            body .modal-backdrop {
                background-color: rgba(0,0,0,.5) !important;
                backdrop-filter: none !important;
                -webkit-backdrop-filter: none !important;
                opacity: .5 !important;
                z-index: 1040 !important;
            }

            #modalPorterAssigned,
            #modalGenericSuccess,
            #modalEmployeeActionSuccess {
                z-index: 1080 !important;
            }

            .modal,
            .modal.show,
            .modal.fade,
            .modal.fade.show,
            body .modal,
            body .modal.show {
                z-index: 1060 !important;
            }

            #modalEmployeeActionSuccess.level-2 {
                z-index: 1090 !important;
            }

            #modalEmployeeActionSuccess.level-2 .modal-dialog {
                z-index: 1091 !important;
            }

            #porterWarningModal.level-2 {
                z-index: 1090 !important;
            }

            .modal-backdrop.level-1 {
                z-index: 1045 !important;
            }

            .modal.level-1 {
                z-index: 1055 !important;
            }

            .modal-backdrop.level-2 {
                z-index: 1055 !important;
            }

            .modal.level-2 {
                z-index: 1065 !important;
            }

            .modal.fade .modal-dialog {
                transform: translate3d(0,-20px,0);
                opacity: 0;
                transition:
                    transform .35s cubic-bezier(.25,.46,.45,.94),
                    opacity .35s cubic-bezier(.25,.46,.45,.94);
                will-change: transform, opacity;
            }

            .modal.fade.show .modal-dialog {
                transform: translate3d(0,0,0);
                opacity: 1;
            }

            body.modal-open {
                overflow: hidden !important;
                padding-right: 0 !important;
            }

            .modal-backdrop:not(.show) {
                display: none !important;
            }
        `;

                                document.head.appendChild(style);
                            }

                            let attempts = 0;

                            forceModalInterval = setInterval(() => {

                                const backdrops = document.querySelectorAll(".modal-backdrop");
                                const modals = document.querySelectorAll(".modal.show");

                                if (!backdrops.length && !modals.length) {

                                    if (++attempts >= 10) {   
                                        clearInterval(forceModalInterval);
                                        forceModalInterval = null;
                                    }

                                    return;
                                }

                                backdrops.forEach(backdrop => {
                                    backdrop.style.zIndex = "1040";
                                    backdrop.style.backgroundColor = "rgba(0,0,0,.5)";
                                    backdrop.style.opacity = ".5";
                                });

                                modals.forEach((modal, index) => {

                                    if (
                                        modal.id.includes("Success") ||
                                        modal.id.includes("PorterAssigned")
                                    ) {
                                        modal.style.zIndex = "1080";
                                    } else {
                                        modal.style.zIndex = String(1060 + index * 10);
                                    }

                                });

                                clearInterval(forceModalInterval);
                                forceModalInterval = null;

                            }, 50);
                        }

                    function setupSpecialBackdrops() {
                        ['assignRequestModal', 'bulkAssignModal'].forEach(modalId => {
                            const modalEl = document.getElementById(modalId);
                            if (modalEl) {
                                modalEl.addEventListener('shown.bs.modal', () => {
                                    const backdrops = document.querySelectorAll('.modal-backdrop');
                                    const thisBackdrop = backdrops[backdrops.length - 1];
                                    if (thisBackdrop) {
                                        thisBackdrop.style.backgroundColor = 'rgba(0, 0, 0, 0.4)';  // 40%
                                        thisBackdrop.style.opacity = '0.4';
                                    }
                                });

                                modalEl.addEventListener('hidden.bs.modal', () => {
                                    document.querySelectorAll('.modal-backdrop').forEach(bd => {
                                        bd.style.backgroundColor = 'rgba(0, 0, 0, 0.5)'; 
                                        bd.style.opacity = '0.5';
                                    });
                                });
                            }
                        });
                    }

                    forceModalOnTop();
                    setupSpecialBackdrops();

                    ['show.bs.modal', 'shown.bs.modal', 'hide.bs.modal', 'hidden.bs.modal'].forEach(event => {
                        document.addEventListener(event, () => setTimeout(forceModalOnTop, 10));
                    });
                    document.addEventListener('click', () => setTimeout(forceModalOnTop, 50));


                    const assignRequestModalEl = document.getElementById('assignRequestModal');
                    const assignRequestModal = new bootstrap.Modal(assignRequestModalEl);

                        window.assignPorterToTask = assignPorterToTask;

                        assignRequestModalEl.addEventListener('hidden.bs.modal', () => {
                        });

                        (function initBulkAssignModal() {
                            if (window._bulkAssignModalInitialized) return;
                            window._bulkAssignModalInitialized = true;

                            const modal = document.getElementById('bulkAssignModal');
                            if (!modal) return;

                            const elements = {
                                list: document.getElementById('bulkRequestList'),
                                search: document.getElementById('bulkRequestSearch'),
                                selectAll: document.getElementById('btnSelectAll'),
                                clearAll: document.getElementById('clearAllSelections'),
                                bulkAssign: document.getElementById('btnBulkAssign'),
                                selectedCount: document.getElementById('selectedCount'),
                                bulkAssignCount: document.getElementById('bulkAssignCount'),
                                closeBtn: document.getElementById('btnCloseBulkAssignModal'),
                                closeHeaderBtn: document.getElementById('btnCloseBulkAssignModalHeader')
                            };
                            if (!elements.list) return;

                            let bulkModal = null, loadId = 0, controller = null;
                            let selectedTasks = new Set();
                            let assignedTasks = new Set();

                            function cleanupBackdrops() {
                                if (!document.querySelector('.modal.show')) {
                                    document.querySelectorAll('.modal-backdrop').forEach(bd => bd.remove());

                                    document.body.classList.remove('modal-open');
                                    document.body.style.removeProperty('overflow');
                                    document.body.style.removeProperty('padding-right');
                                    document.body.style.removeProperty('margin-right');
                                }
                            }

                            function getModal() {
                                if (!bulkModal) bulkModal = new bootstrap.Modal(modal, { backdrop: true, keyboard: true });
                                return bulkModal;
                            }

                            function updateCount() {
                                const count = selectedTasks.size;
                                if (elements.selectedCount) elements.selectedCount.textContent = count;
                                if (elements.bulkAssignCount) elements.bulkAssignCount.textContent = count;
                                if (elements.bulkAssign) {
                                    elements.bulkAssign.disabled = count === 0;
                                    elements.bulkAssign.innerHTML = `<i class="bi bi-person-check-fill me-2"></i> Bulk Assign (${count})`;
                                }
                            }

                            function setChecked(el, checked) {
                                if (!el) return;
                                const svg = el.querySelector('svg');
                                el.classList.toggle('checked', checked);
                                if (!svg) return;
                                if (checked) {
                                    svg.style.display = 'block';
                                    svg.style.animation = 'none';
                                    void svg.offsetHeight;
                                    svg.style.animation = 'pop 0.2s ease-out';
                                } else {
                                    svg.style.display = 'none';
                                    svg.style.animation = '';
                                }
                            }

                            function toggleIndividualTask(el, taskId) {
                                if (!el) return;
                                const id = String(taskId);
                                if (assignedTasks.has(id)) return;
                                const isChecked = el.classList.contains('checked');
                                setChecked(el, !isChecked);
                                isChecked ? selectedTasks.delete(id) : selectedTasks.add(id);
                                updateCount();
                            }

                            function resetState() {
                                if (controller) { controller.abort(); controller = null; }
                                if (elements.list) elements.list.innerHTML = '';
                                if (elements.search) elements.search.value = '';
                                selectedTasks.clear();
                                assignedTasks.clear();
                                updateCount();
                                cleanupBackdrops();
                            }

                            function getPorterIds(req) {
                                return {
                                    porter: req.PorterId ?? req.PORTERID ?? req.porterId ?? req.PorterID ?? 0,
                                    sub: req.SubPorterId ?? req.SUBPORTERID ?? req.subPorterId ?? req.SubPorterID ?? 0
                                };
                            }

                            // ---- Silent version used ONLY by the bulk-assign loop below.
                            // Does the exact same ASSIGNPORTER call as assignPorterToTask,
                            // but never touches modalEmployeeActionSuccess / porterWarningModal
                            // and never calls window.RefreshAll() per task. The shared
                            // assignPorterToTask() function used everywhere else is left
                            // completely untouched.
                            function assignPorterToTaskSilent(requestId, porterId) {
                                return new Promise((resolve, reject) => {
                                    const UID = sessionStorage.getItem('ID');
                                    if (!UID) return reject(new Error('UID missing'));

                                    const encRequestId = Encrypt(requestId.toString());
                                    const encPorterId = Encrypt(porterId.toString());
                                    const encRequestorId = Encrypt(UID);
                                    const encProcess = Encrypt('ASSIGNPORTER');

                                    fetch('/Index/Service/Service.aspx?' + new URLSearchParams({
                                        Process: encProcess
                                    }), {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/json' },
                                        body: JSON.stringify({
                                            requestId: encRequestId,
                                            porterId: encPorterId,
                                            requestorId: encRequestorId
                                        })
                                    })
                                        .then(res => res.text())
                                        .then(text => {
                                            let data;
                                            try {
                                                data = JSON.parse(text);
                                            } catch (e) {
                                                data = { success: true, message: text };
                                            }

                                            if (data.message && data.message.includes('Same Porter is already assigned to this Task')) {
                                                return resolve();
                                            }
                                            if (data.success === true || (data.message && data.message.includes('Thread was being aborted'))) {
                                                return resolve();
                                            }
                                            reject(new Error(data.message || 'Failed to assign porter.'));
                                        })
                                        .catch(err => reject(err));
                                });
                            }

                            async function loadTasks(filter = '') {
                                if (!window.G_PORTER_ID || !window.G_SERVICE_ID) {
                                    if (elements.list) elements.list.innerHTML = '<li class="list-group-item text-center py-3 text-muted">No tasks available</li>';
                                    return;
                                }
                                const reqId = ++loadId;
                                if (controller) { controller.abort(); controller = null; }
                                controller = new AbortController();

                                if (elements.list) {
                                    elements.list.style.opacity = '0';
                                    elements.list.innerHTML = `<li class="list-group-item text-center py-3"><div class="spinner-border text-primary spinner-border-sm" role="status"></div><p class="mt-2 text-muted small">Loading...</p></li>`;
                                }

                                try {
                                    const enc = v => Encrypt(v || '');
                                    const res = await fetch(`/Index/Service/Service.aspx?Process=${encodeURIComponent(enc('getPendingRequests'))}`, {
                                        method: "POST",
                                        headers: { "Content-Type": "application/json" },
                                        body: JSON.stringify({ serviceId: enc(window.G_SERVICE_ID), toZoneFilter: enc(filter), porterId: enc(window.G_PORTER_ID) }),
                                        signal: controller.signal
                                    });
                                    if (reqId !== loadId) return;

                                    const data = await res.text();
                                    let tasks = [];
                                    try {
                                        const parsed = JSON.parse(data.trim().replace(/\[\]$/, ''));
                                        tasks = Array.isArray(parsed) ? parsed : (parsed?.d ? JSON.parse(parsed.d) : []);
                                    } catch (e) {
                                        console.error('Parse error:', e);
                                        if (elements.list) { elements.list.innerHTML = '<li class="list-group-item text-danger text-center py-3">Error loading data</li>'; elements.list.style.opacity = '1'; }
                                        return;
                                    }

                                    assignedTasks.clear();
                                    tasks.sort((a, b) => {
                                        const aId = getPorterIds(a), bId = getPorterIds(b);
                                        const aAssigned = Number(aId.porter) === Number(window.G_PORTER_ID) || Number(aId.sub) === Number(window.G_PORTER_ID);
                                        const bAssigned = Number(bId.porter) === Number(window.G_PORTER_ID) || Number(bId.sub) === Number(window.G_PORTER_ID);
                                        return (bAssigned ? 1 : 0) - (aAssigned ? 1 : 0);
                                    });

                                    const fragment = document.createDocumentFragment();
                                    tasks.forEach(task => {
                                        const id = task.TASKID || task.TaskId || 'N/A';
                                        const category = task.CategoryName || task.Category || 'N/A';
                                        const zone = task.ToZone || 'N/A';
                                        const loc = task.ToLocation || 'N/A';
                                        const ids = getPorterIds(task);
                                        const isAssigned = Number(ids.porter) === Number(window.G_PORTER_ID) || Number(ids.sub) === Number(window.G_PORTER_ID);
                                        if (isAssigned && id !== 'N/A') assignedTasks.add(String(id));
                                        const isChecked = isAssigned || selectedTasks.has(String(id));

                                        const li = document.createElement('li');
                                        li.className = `list-group-item p-2 mb-1 ${isAssigned ? 'assigned-task' : ''}`;
                                        li.innerHTML = `<div class="d-flex justify-content-between align-items-center"><div style="font-size: 13px; line-height: 1.5; cursor: pointer;" class="task-info"><strong>${category}</strong><span class="text-muted mx-1">|</span><span style="color: #d32f2f; font-weight: 600;">#${id}</span><span class="text-muted mx-1">|</span><span>${zone}</span><span class="text-muted mx-1">→</span><span>${loc}</span></div><div class="tick-wrapper ${isChecked ? 'checked' : ''}" data-id="${id}" data-assigned="${isAssigned}" ${isAssigned ? 'style="pointer-events:none; opacity:0.5;"' : ''}><svg viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg></div></div>`;
                                        fragment.appendChild(li);
                                    });

                                    if (tasks.length === 0) {
                                        elements.list.innerHTML = '<li class="list-group-item text-center text-muted py-4">No pending tasks</li>';
                                        elements.list.style.opacity = '1';
                                        updateCount();
                                        return;
                                    }
                                    elements.list.innerHTML = '';
                                    elements.list.appendChild(fragment);
                                    elements.list.style.opacity = '1';
                                    updateCount();
                                } catch (err) {
                                    if (err.name !== 'AbortError' && elements.list) {
                                        elements.list.innerHTML = `<li class="list-group-item text-danger text-center py-3">${err.message}</li>`;
                                        elements.list.style.opacity = '1';
                                    }
                                }
                            }

                            if (elements.search) {
                                let searchTimeout;
                                elements.search.addEventListener('input', function () {
                                    clearTimeout(searchTimeout);
                                    searchTimeout = setTimeout(() => loadTasks(this.value.trim().toLowerCase()), 300);
                                });
                            }

                            if (elements.selectAll) {
                                elements.selectAll.addEventListener('click', () => {
                                    if (!elements.list) return;
                                    elements.list.querySelectorAll('.tick-wrapper:not([data-assigned="true"])').forEach(el => {
                                        const id = el.dataset.id;
                                        if (id && id !== 'N/A') { setChecked(el, true); selectedTasks.add(String(id)); }
                                    });
                                    updateCount();
                                });
                            }

                            if (elements.clearAll) {
                                elements.clearAll.addEventListener('click', () => {
                                    selectedTasks.clear();
                                    if (elements.list) elements.list.querySelectorAll('.tick-wrapper:not([data-assigned="true"])').forEach(el => setChecked(el, false));
                                    updateCount();
                                });
                            }

                            document.addEventListener('click', e => {
                                const wrapper = e.target.closest('.tick-wrapper');
                                if (!wrapper || !elements.list?.contains(wrapper)) return;
                                if (wrapper.dataset.assigned === 'true') { e.preventDefault(); return; }
                                const id = wrapper.dataset.id;
                                if (id && id !== 'N/A') { e.preventDefault(); e.stopPropagation(); toggleIndividualTask(wrapper, id); }
                            });

                            if (elements.bulkAssign) {
                                elements.bulkAssign.addEventListener('click', async function () {
                                    if (selectedTasks.size === 0 || !window.G_PORTER_ID) return;
                                    const ids = Array.from(selectedTasks);
                                    const original = this.innerHTML;
                                    this.disabled = true;
                                    this.innerHTML = `<span class="spinner-border spinner-border-sm me-2"></span>Assigning ${ids.length}...`;

                                    let success = 0, fail = 0;
                                    for (const id of ids) {
                                        try {
                                            // Use the local silent helper here — NOT window.assignPorterToTask —
                                            // so no per-task popup appears and the shared function stays untouched.
                                            await assignPorterToTaskSilent(id, window.G_PORTER_ID);
                                            success++;
                                        } catch (e) { console.error('Failed:', id, e); fail++; }
                                    }

                                    selectedTasks.clear();
                                    this.innerHTML = original;
                                    await loadTasks(elements.search ? elements.search.value.trim().toLowerCase() : '');

                                    if (fail > 0) alert(`Assigned ${success} task(s). ${fail} failed.`);
                                    else if (success > 0) showSuccess(`Successfully assigned ${success} task(s)!`);
                                });
                            }

                            modal.addEventListener('shown.bs.modal', async () => {
                                cleanupBackdrops();
                                if (elements.search) elements.search.value = '';
                                selectedTasks.clear();
                                assignedTasks.clear();
                                updateCount();
                                await loadTasks('');
                            });

                            modal.addEventListener('hidden.bs.modal', () => { resetState(); setTimeout(cleanupBackdrops, 100); });
                            modal.addEventListener('hide.bs.modal', cleanupBackdrops);

                            if (elements.closeBtn) elements.closeBtn.addEventListener('click', e => { e.preventDefault(); getModal().hide(); setTimeout(cleanupBackdrops, 50); });
                            if (elements.closeHeaderBtn) elements.closeHeaderBtn.addEventListener('click', e => { e.preventDefault(); getModal().hide(); setTimeout(cleanupBackdrops, 50); });

                            modal.addEventListener('click', e => { if (e.target === modal) { getModal().hide(); setTimeout(cleanupBackdrops, 50); } });

                            document.addEventListener('keydown', e => {
                                if (e.key !== 'Escape') return;
                                if (bootstrap.Modal.getInstance(modal) && modal.classList.contains('show')) { getModal().hide(); setTimeout(cleanupBackdrops, 100); }
                            });

                            function showSuccess(msg) {
                                const el = document.getElementById('modalGenericSuccess');
                                if (!el) return;
                                const m = bootstrap.Modal.getOrCreateInstance(el);
                                const lbl = document.getElementById('LBLGenericSuccessResult');
                                if (lbl) lbl.textContent = msg;
                                m.show();
                                setTimeout(() => { m.hide(); cleanupBackdrops(); if (window.RefreshAll) window.RefreshAll(); }, 2000);
                            }

                            document.addEventListener('click', e => {
                                const btn = e.target.closest('.openBulkAssignModal');
                                if (!btn) return;
                                e.preventDefault();
                                cleanupBackdrops();
                                window.G_PORTER_ID = btn.dataset.employee;
                                const active = document.querySelector('.services-btn-icon.active');
                                window.G_SERVICE_ID = active ? active.id.replace('divService', '') : '1';
                                document.querySelectorAll('.modal.show').forEach(m => bootstrap.Modal.getInstance(m)?.hide());
                                getModal().show();
                            });

                            updateCount();

                            window.addEventListener('beforeunload', () => { if (controller) { controller.abort(); controller = null; } cleanupBackdrops(); });
                            window.cleanupBulkBackdrops = cleanupBackdrops;

                            if (elements.closeBtn && !elements.closeBtn._closeSet) {
                                elements.closeBtn.onclick = e => { e.preventDefault(); bootstrap.Modal.getInstance(modal).hide(); };
                                elements.closeBtn._closeSet = true;
                            }

                            document.addEventListener('click', e => {
                                const assignBtn = e.target.closest('.openAssignRequestModal');
                                if (assignBtn) {
                                    e.preventDefault(); e.stopPropagation(); e.stopImmediatePropagation();
                                    document.querySelectorAll('.modal.show').forEach(m => bootstrap.Modal.getInstance(m)?.hide());

                                    const porterId = assignBtn.dataset.employee || '';
                                    const assignType = assignBtn.dataset.type || 'task';
                                    const active = document.querySelector('.services-btn-icon.active');
                                    const serviceId = active ? active.id.replace('divService', '') : "1";
                                    const requestList = document.getElementById('pendingRequestList');
                                    if (requestList) requestList.innerHTML = '<li class="list-group-item text-center py-4"><div class="spinner-border spinner-border-sm text-primary me-2" role="status"></div>Loading...</li>';

                                    const processName = assignType === 'assistant' ? 'GetAssistantRequests' : 'GetPendingTasks';
                                    const encProcess = typeof Encrypt === 'function' ? Encrypt(processName) : processName;

                                    fetch(`/Index/Service/Service.aspx?Process=${encodeURIComponent(encProcess)}`, {
                                        method: "POST", headers: { "Content-Type": "application/json; charset=utf-8" }, body: JSON.stringify({ serviceId })
                                    })
                                        .then(res => res.json())
                                        .then(data => {
                                            let requests = [];
                                            try { requests = data.d ? JSON.parse(data.d) : data.data || []; } catch (err) { console.error('JSON parse error:', err); }
                                            if (requestList) requestList.innerHTML = '';
                                            if (requests.length > 0) {
                                                requests.slice(0, 100).forEach(req => {
                                                    const taskId = req.TASKID || 'N/A';
                                                    const categoryName = req.CategoryName || req.Category || 'N/A';
                                                    const li = document.createElement('li');
                                                    li.className = 'list-group-item d-flex justify-content-between align-items-center px-3 py-2';
                                                    li.innerHTML = `<span class="flex-grow-1 pe-3"><span style="color: #34495E; font-weight: 600; font-size: 0.9rem;">Task Type</span> - <strong style="color: #1F3A93; font-weight: 700;">#${categoryName}</strong><span class="text-muted mx-2">|</span><span style="color: #7F8C8D; font-weight: 600;">Task ID</span> <strong style="color: #2C3E50; font-weight: 700;">#${taskId}</strong></span><button class="btn btn-sm assignTaskBtn" data-taskid="${taskId}" data-porterid="${porterId}" style="background: linear-gradient(90deg, #3498DB, #2E86C1); color: #ffffff; font-weight: 600; border-radius: 5px; border: none; padding: 4px 12px; transition: all 0.3s ease;">Assign</button>`;
                                                    requestList.appendChild(li);
                                                });
                                            } else {
                                                requestList.innerHTML = '<li class="list-group-item text-center text-muted py-5">No pending requests.</li>';
                                            }
                                        })
                                        .catch(err => {
                                            console.error('Fetch error:', err);
                                            if (requestList) requestList.innerHTML = '<li class="list-group-item text-center text-danger py-4">Error loading requests</li>';
                                        })
                                        .finally(() => {
                                            const arModal = document.getElementById('assignRequestModal');
                                            if (!arModal) return;
                                            const inst = bootstrap.Modal.getInstance(arModal);
                                            if (inst) inst.dispose();
                                            window.assignRequestModal = new bootstrap.Modal(arModal, { backdrop: 'static', keyboard: false });
                                            window.assignRequestModal.show();
                                            const modalTitle = document.getElementById('assignRequestModalLabel');
                                            if (modalTitle) modalTitle.textContent = assignType === 'assistant' ? 'Pending Assistant Requests' : 'Pending Requests';
                                        });
                                    return;
                                }

                                const assignTaskBtn = e.target.closest('.assignTaskBtn');
                                if (!assignTaskBtn) return;
                                e.preventDefault(); e.stopPropagation(); e.stopImmediatePropagation();
                                const taskId = assignTaskBtn.dataset.taskid;
                                const porterId = assignTaskBtn.dataset.porterid;
                                if (!taskId || !porterId || typeof assignPorterToTask !== 'function') return;

                                assignTaskBtn.disabled = true;
                                assignTaskBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Assigning...';
                                assignPorterToTask(taskId, porterId)
                                    .then(() => {
                                        assignTaskBtn.innerHTML = 'Assigned ✓';
                                        assignTaskBtn.style.background = '#d4edda';
                                        assignTaskBtn.style.color = 'black';
                                        if (window.assignRequestModal) window.assignRequestModal.hide();
                                    })
                                    .catch(err => {
                                        console.error('Assign failed:', err);
                                        assignTaskBtn.disabled = false;
                                        assignTaskBtn.innerHTML = 'Assign';
                                        assignTaskBtn.style.background = 'linear-gradient(90deg, #3498DB, #2E86C1)';
                                        assignTaskBtn.style.color = '#ffffff';
                                    });
                            });
                        })();
                        container.querySelectorAll('.check-in').forEach(function (btn) {
                            btn.addEventListener('click', function (e) {
                                e.preventDefault();
                                var porterId = btn.dataset.id;
                                var porterName = btn.dataset.name;
                                handleCheckInClick(porterId, porterName);
                            });
                        });

                        container.querySelectorAll('.check-out').forEach(function (btn) {
                            btn.addEventListener('click', function (e) {
                                e.preventDefault();
                                var porterId = btn.dataset.id;
                                var porterName = btn.dataset.name;
                                handleCheckOutClick(porterId, porterName);
                            });
                        });
                }

                const messageModalEl = document.getElementById('messageModal');
                const messageModal = new bootstrap.Modal(messageModalEl);

                let selectedEmployeeId = null;

                document.addEventListener('click', function (e) {
                    const msgBtn = e.target.closest('.send-message');
                    if (msgBtn) {
                        e.preventDefault();
                        selectedEmployeeId = msgBtn.getAttribute('data-id');
                        document.getElementById('messageText').value = '';
                        messageModal.show();
                    }
                });

                document.addEventListener('show.bs.modal', function (event) {
                    // console.log(event.target);
                    clearInterval(AutoRefresh);
                });
                document.addEventListener('hidden.bs.modal', function (event) {
                    // console.log(event.target);
                    RestartTimer_AutoRefresh();
                });

                document.addEventListener('show.bs.modal', function (event) {
                    clearInterval(AutoRefresh);
                });

                document.addEventListener('hidden.bs.modal', function (event) {
                    RestartTimer_AutoRefresh();
                });

                let countdownInterval = null;
                let countdownTimer = 30;
                const REFRESH_INTERVAL = 30000;
                window.AutoRefresh = null;

                function isAutoRefreshEnabled() {
                    const chk = document.getElementById('chkAutoRefresh');
                    return chk && chk.checked === true;
                }

                function stopAutoRefresh() {
                    if (window.AutoRefresh !== null) {
                        clearInterval(window.AutoRefresh);
                        window.AutoRefresh = null;
                    }

                    if (countdownInterval !== null) {
                        clearInterval(countdownInterval);
                        countdownInterval = null;
                    }

                    countdownTimer = 30;

                    const badge = document.getElementById('refreshCountdown');
                    if (badge) {
                        badge.style.display = 'none';
                        badge.classList.remove('is-critical');
                    }
                }

                function startAutoRefresh() {
                    if (!isAutoRefreshEnabled()) return;
                    if (document.hidden) {
                        return;
                    }
                    stopAutoRefresh();

                    const badge = document.getElementById('refreshCountdown');
                    const secondsSpan = document.getElementById('countdownSeconds');
                    if (!badge || !secondsSpan) return;

                    badge.style.display = 'inline-block';
                    badge.classList.remove('is-critical');

                    countdownTimer = 30;
                    secondsSpan.textContent = countdownTimer;

                    window.AutoRefresh = setInterval(() => {
                        if (!isAutoRefreshEnabled() || document.hidden) return;
                        fn_refreshAll();
                    }, REFRESH_INTERVAL);

                    countdownInterval = setInterval(() => {
                        if (!isAutoRefreshEnabled()) return;

                        countdownTimer--;
                        secondsSpan.textContent = countdownTimer;

                        badge.classList.toggle(
                            'is-critical',
                            countdownTimer <= 5 && countdownTimer > 0
                        );

                        if (countdownTimer <= 0) {
                            countdownTimer = 30;
                            secondsSpan.textContent = countdownTimer;
                            badge.classList.remove('is-critical');
                        }
                    }, 1000);
                }

                function RestartTimer_AutoRefresh() {
                    if (isAutoRefreshEnabled()) {
                        startAutoRefresh();
                    } else {
                        stopAutoRefresh();
                    }
                }

                function toggleFilterPanel(panel, show = true) {
                    if (!panel) return;

                    if (show) {
                        panel.style.display = 'block';
                        stopAutoRefresh();

                        const badge = document.getElementById('refreshCountdown');
                        if (badge) {
                            badge.style.display = 'none';
                        }
                    } else {
                        panel.style.display = 'none';
                        RestartTimer_AutoRefresh();
                    }
                }

                function closeAllFilterPanels(event) {
                    const filterPanels = document.querySelectorAll('.filter-panel');
                    let clickedOnFilter = false;

                    const clickedElement = event.target;
                    if (clickedElement.closest('.filter-panel') ||
                        clickedElement.closest('.filter-icon') ||
                        clickedElement.closest('.apply-filters') ||
                        clickedElement.closest('.clear-filters')) {
                        clickedOnFilter = true;
                    }

                    if (!clickedOnFilter) {
                        filterPanels.forEach(panel => {
                            panel.style.display = 'none';
                            RestartTimer_AutoRefresh(); 
                        });
                    }
                }

                $(document).ready(function () {
                    $('#chkAutoRefresh').prop('checked', false);

                    const badge = document.getElementById('refreshCountdown');
                    if (badge) badge.style.display = 'none';

                    RestartTimer_AutoRefresh();

                    $('#chkAutoRefresh').on('change', function () {
                        sessionStorage.setItem('autoRefreshEnabled', this.checked);

                        if (!this.checked && typeof abortAllFetchRequests === 'function') {
                            abortAllFetchRequests();
                        }

                        RestartTimer_AutoRefresh();
                    });

                    setupFilterPanels();
                });

                function setupFilterPanels() {
                    document.querySelectorAll('.filter-icon').forEach(icon => {
                        icon.addEventListener('click', function (e) {
                            e.stopPropagation();

                            const filterWrapper = this.closest('.filter-wrapper');
                            const panel = filterWrapper.querySelector('.filter-panel');

                            if (panel) {
                                const isOpen = panel.style.display === 'block';

                                document.querySelectorAll('.filter-panel').forEach(otherPanel => {
                                    if (otherPanel !== panel) {
                                        otherPanel.style.display = 'none';
                                    }
                                });

                                toggleFilterPanel(panel, !isOpen);
                            }
                        });
                    });

                    document.querySelectorAll('.filter-panel .btn-grey').forEach(btn => {
                        btn.addEventListener('click', function () {
                            const panel = this.closest('.filter-panel');
                            toggleFilterPanel(panel, false);
                        });
                    });

                    document.querySelectorAll('.filter-panel .apply-filters').forEach(btn => {
                        btn.addEventListener('click', function () {
                            const panel = this.closest('.filter-panel');
                            toggleFilterPanel(panel, false);
                        });
                    });

                    document.querySelectorAll('.filter-panel .clear-filters').forEach(btn => {
                        btn.addEventListener('click', function () {
                            const panel = this.closest('.filter-panel');
                            const selectElements = panel.querySelectorAll('select');
                            selectElements.forEach(select => {
                                select.selectedIndex = 0;
                            });

                            toggleFilterPanel(panel, false);
                        });
                    });

                    document.addEventListener('show.bs.dropdown', function () {
                        stopAutoRefresh();
                    });

                    document.addEventListener('hide.bs.dropdown', function () {
                        if (isAutoRefreshEnabled()) {
                            startAutoRefresh();
                        }
                    });

                    document.addEventListener('click', closeAllFilterPanels);
                }

                function closeAllOpenFilterPanels() {
                    document.querySelectorAll('.filter-panel').forEach(panel => {
                        panel.style.display = 'none';
                    });
                    RestartTimer_AutoRefresh();
                }

                function setupFilterPanels() {

                    document.querySelectorAll('.filter-icon').forEach(icon => {
                        icon.addEventListener('click', function (e) {
                            e.preventDefault();
                            e.stopPropagation();

                            const filterWrapper = this.closest('.filter-wrapper');

                            if (filterWrapper) {
                                const panel = filterWrapper.querySelector('.filter-panel');

                                if (panel) {
                                    const isOpen = panel.style.display === 'block';

                                    document.querySelectorAll('.filter-panel').forEach(otherPanel => {
                                        if (otherPanel !== panel) {
                                            otherPanel.style.display = 'none';
                                        //    console.log('Closed other panel');
                                        }
                                    });

                                    panel.style.display = isOpen ? 'none' : 'block';

                                    if (!isOpen) {
                                        stopAutoRefresh(); 
                                    } else {
                                        RestartTimer_AutoRefresh();
                                    }
                                }
                            }
                        });
                    });

                    document.querySelectorAll('.filter-panel .btn-grey[type="button"]').forEach(btn => {
                        btn.addEventListener('click', function (e) {
                            e.stopPropagation();
                            const panel = this.closest('.filter-panel');
                            if (panel) {
                                panel.style.display = 'none';
                                RestartTimer_AutoRefresh();
                            }
                        });
                    });

                    document.querySelectorAll('.filter-panel .apply-filters').forEach(btn => {
                        btn.addEventListener('click', function (e) {
                            e.stopPropagation();
                            const panel = this.closest('.filter-panel');
                            if (panel) {
                                panel.style.display = 'none';
                                RestartTimer_AutoRefresh();

                                const columnType = this.classList.contains('pending') ? 'pending' :
                                    this.classList.contains('started') ? 'started' : 'employee';
                                //console.log(`Applying filters for ${columnType} column`);

                                applyFilters(columnType, panel);
                            }
                        });
                    });

                    document.querySelectorAll('.filter-panel .clear-filters').forEach(btn => {
                        btn.addEventListener('click', function (e) {
                            e.stopPropagation();
                            const panel = this.closest('.filter-panel');
                            if (panel) {
                                const selectElements = panel.querySelectorAll('select');
                                selectElements.forEach(select => {
                                    select.selectedIndex = 0;
                                });

                                panel.style.display = 'none';
                                RestartTimer_AutoRefresh();

                            }
                        });
                    });

                    document.addEventListener('show.bs.dropdown', function () {
                        stopAutoRefresh();
                    });

                    document.addEventListener('hide.bs.dropdown', function () {
                        if (isAutoRefreshEnabled()) {
                            startAutoRefresh();
                        }
                    });

                    document.addEventListener('click', function (e) {
                        if (!e.target.closest('.filter-panel') && !e.target.closest('.filter-icon')) {
                            document.querySelectorAll('.filter-panel').forEach(panel => {
                                if (panel.style.display === 'block') {
                                    panel.style.display = 'none';
                                    RestartTimer_AutoRefresh();
                                }
                            });
                        }
                    });

                    document.querySelectorAll('.filter-panel').forEach(panel => {
                        panel.addEventListener('click', function (e) {
                            e.stopPropagation();
                        });
                    });
                }

                function applyFilters(columnType, panel) {
                    switch (columnType) {
                        case 'pending':
                            const taskId = panel.querySelector('#taskIdSelect')?.value;
                            const taskType = panel.querySelector('#taskTypeSelect')?.value;
                            //console.log('Pending filters:', { taskId, taskType });
                            break;

                        case 'started':
                            const taskIdStarted = panel.querySelector('#taskIdSelectStarted')?.value;
                            const taskTypeStarted = panel.querySelector('#taskTypeSelectStarted')?.value;
                            //console.log('Started filters:', { taskIdStarted, taskTypeStarted });
                            //break;

                        case 'employee':
                            const userName = panel.querySelector('#employeeUserName')?.value;
                            const hospital = panel.querySelector('#employeeHospital')?.value;
                            //console.log('Employee filters:', { userName, hospital });
                            break;
                    }
                }

                $(document).ready(function () {

                    $('#chkAutoRefresh').prop('checked', false);

                    const badge = document.getElementById('refreshCountdown');
                    if (badge) badge.style.display = 'none';

                    RestartTimer_AutoRefresh();

                    $('#chkAutoRefresh').on('change', function () {
                        sessionStorage.setItem('autoRefreshEnabled', this.checked);

                        if (!this.checked && typeof abortAllFetchRequests === 'function') {
                            abortAllFetchRequests();
                        }

                        RestartTimer_AutoRefresh();
                    });

                    setupFilterPanels();

                });

                function Encrypt(Value) {
                    var key = CryptoJS.enc.Utf8.parse(CryptoKey);
                    var iv = CryptoJS.enc.Utf8.parse(CryptoPwd);

                    var encryptedVal = CryptoJS.AES.encrypt(CryptoJS.enc.Utf8.parse(Value), key, {
                        keySize: 128 / 8,
                        iv: iv,
                        mode: CryptoJS.mode.CBC,
                        padding: CryptoJS.pad.Pkcs7
                    });

                    return encryptedVal.toString(); 
                }

                document.getElementById('sendMessageBtn').addEventListener('click', function () {
                    const message = document.getElementById('messageText').value.trim();
                    if (!message) {
                        alert("Please enter a message.");
                        return;
                    }

                    const porterId = selectedEmployeeId;
                    const userId = sessionStorage.getItem('ID');
                    const activeServiceBtn = $(".services-btn-icon.active");
                    const serviceId = activeServiceBtn.length ? activeServiceBtn.attr('id').replace("divService", "") : 0;

                    const encryptedPorterId = Encrypt(porterId);
                    const encryptedUserId = Encrypt(userId);
                    const encryptedMessage = Encrypt(message);
                    const encryptedServiceId = Encrypt(serviceId);
                    const encryptedProcess = encryptAES("SENDMESSAGE", cryptoKey, cryptoIV);

                    $.ajax({
                        type: "POST",
                        url: `/Index/Service/Service.aspx?Process=${encodeURIComponent(encryptedProcess)}`,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: JSON.stringify({
                            porterId: encryptedPorterId,
                            userId: encryptedUserId,
                            message: encryptedMessage,
                            serviceId: encryptedServiceId
                        }),
                        success: function (data) {
                            const result = data.d || data;
                            if (!result || result === "Success") {
                                messageModal.hide();
                                $('#lblEmployeeActionResult').text("Message sent successfully!");
                                const successModal = new bootstrap.Modal(document.getElementById('modalEmployeeActionSuccess'));
                                successModal.show();
                                setTimeout(() => {
                                    successModal.hide();
                                }, 1500);
                            } else {
                                alert("Failed to send message: " + result);
                            }
                        },
                        error: function (xhr, status, error) {
                            messageModal.hide();
                            $('#lblEmployeeActionResult').text("Message sent successfully!");
                            const successModal = new bootstrap.Modal(document.getElementById('modalEmployeeActionSuccess'));
                            successModal.show();
                            setTimeout(() => {
                                successModal.hide();
                            }, 1500);
                        }
                    });
                });
                const assignModalEl = document.getElementById('assignModal');
                const assignModal = new bootstrap.Modal(assignModalEl);

                assignModalEl.addEventListener('hidden.bs.modal', () => {

                    const backdrop = document.querySelector('.modal-backdrop');
                    if (backdrop) backdrop.remove();

                    const container = document.getElementById('freeEmployeeList');
                    container.innerHTML = '';
                    document.getElementById("assignEmployeeFilter").value = '';
                });

                function openAssignModal(requestId) {
                    currentRequestId = requestId;

                    document.querySelectorAll('.modal.show').forEach(modalEl => {
                        bootstrap.Modal.getInstance(modalEl)?.hide();
                    });

                    assignModal.show();
                }

                function loadAvailablePorters(filter = '', serviceId = '') {

                    const container = document.getElementById('freeEmployeeList');
                    container.innerHTML = '<p class="text-muted">Loading available porters...</p>';

                    if (!serviceId) {
                        const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                        serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';
                    }

                    const encryptedProcess = Encrypt('GetEmployeeDataAssign');
                    const encryptedFilter = Encrypt(filter);
                    const encryptedServiceId = Encrypt(serviceId);

                    $.ajax({
                        type: "GET",
                        url: "/Index/Service/Service.aspx",
                        data: {
                            Process: Encrypt('GetEmployeeDataAssign'),
                            filter: encodeURIComponent(encryptedFilter),
                            serviceId: encodeURIComponent(encryptedServiceId)
                        },
                        dataType: "json",
                        success: function (data) {

                            container.innerHTML = '';

                            if (!data || data.length === 0) {
                                container.innerHTML = '<p>No free porters found.</p>';
                                return;
                            }

                            data.forEach(function (emp) {
                                const item = document.createElement('div');
                                item.className = 'd-flex justify-content-between align-items-center mb-2 p-2 border rounded shadow-sm';

                                item.innerHTML = ''
                                    + '<span>'
                                    + '  <span style="color: #34495E; font-weight: 600;">#Username</span> - '
                                    + '  <strong style="color: #1F3A93; font-weight: 700;">' + emp.USERNAME + '</strong> | '
                                    + '  <span style="color: #7F8C8D; font-weight: 600;">#Division</span> - '
                                    + '  <strong style="color: #2C3E50;">' + emp.HOSPITALNAME1 + '</strong>'
                                    + '</span>'
                                    + '<button type="button" class="btn btn-sm assignPorterBtn" style="'
                                    + '  background: linear-gradient(90deg, #3498DB, #2E86C1);'
                                    + '  color: #ffffff;'
                                    + '  font-weight: 600;'
                                    + '  border-radius: 12px;'
                                    + '  border: none;'
                                    + '  padding: 5px 16px;'
                                    + '  font-size: 0.85rem;'
                                    + '  box-shadow: 0 4px 12px rgba(46, 134, 193, 0.5);'
                                    + '  transition: background 0.3s ease, box-shadow 0.3s ease, transform 0.2s ease;'
                                    + '  display: inline-flex;'
                                    + '  align-items: center;'
                                    + '  justify-content: center;'
                                    + '" data-porter-id="' + emp.ID + '"'
                                    + ' onmouseover="this.style.background=\'linear-gradient(90deg, #2E86C1, #2874A6)\'; this.style.boxShadow=\'0 6px 16px rgba(40, 116, 166, 0.7)\'; this.style.transform=\'scale(1.06)\';"'
                                    + ' onmouseout="this.style.background=\'linear-gradient(90deg, #3498DB, #2E86C1)\'; this.style.boxShadow=\'0 4px 12px rgba(46, 134, 193, 0.5)\'; this.style.transform=\'scale(1)\';">'
                                    + '  Assign'
                                    + '</button>';

                                container.appendChild(item);
                            });

                            $(container).find('.assignPorterBtn').each(function () {
                                $(this).off('click').on('click', function (e) {
                                    e.preventDefault();

                                    const porterId = $(this).data('porter-id');
                                    if (!currentRequestId) {
                                        console.warn("currentRequestId is not set!");
                                        return;
                                    }

                                    assignPorterToTask(currentRequestId, porterId);

                                    const assignModalEl = document.getElementById('assignModal');
                                    const assignModal = bootstrap.Modal.getInstance(assignModalEl);
                                    if (assignModal) {
                                        assignModal.hide();

                                        $('.modal-backdrop').remove();
                                        document.body.classList.remove('modal-open');
                                        document.body.style.removeProperty('padding-right');

                                        const freeList = document.getElementById('freeEmployeeList');
                                        if (freeList) freeList.innerHTML = '';
                                    }
                                });
                            });
                        },
                        error: function (xhr, status, error) {
                            console.error('Failed to load porters:', error);
                            container.innerHTML = '<p class="text-danger">Failed to load porters.</p>';
                        }
                    });
                }

                document.addEventListener("DOMContentLoaded", function () {
                    const assignFilter = document.getElementById("assignEmployeeFilter");

                    assignModalEl.addEventListener('shown.bs.modal', function () {
                        loadAvailablePorters();
                        assignFilter.focus();
                    });

                    assignFilter.addEventListener("input", function () {
                        loadAvailablePorters(assignFilter.value.trim());
                    });
                });


                function showPorterAssignedModal(requestId) {
                    const msg = 'Porter assigned for Task ID - <b>#' + requestId + '</b>';
                    $('#LBLPorterAssignedResult').html(msg);

                    $('#modalPorterAssigned').modal('show');

                    setTimeout(() => {
                        $('#modalPorterAssigned').modal('hide');
                    }, 2000);
                }

                let isModalVisible = false; 
                let isActionInProgress = false;  

                function encryptAES(text, key, iv) {
                    var keyBytes = CryptoJS.enc.Utf8.parse(key);
                    var ivBytes = CryptoJS.enc.Utf8.parse(iv);
                    return CryptoJS.AES.encrypt(text, keyBytes, {
                        iv: ivBytes,
                        mode: CryptoJS.mode.CBC,
                        padding: CryptoJS.pad.Pkcs7
                    }).toString();
                }

                function assignPorterToTask(requestId, porterId) {
                    return new Promise((resolve, reject) => {
                        if (isActionInProgress) {
                            return resolve();
                        }
                        isActionInProgress = true;
                        const UID = sessionStorage.getItem('ID');

                        const encRequestId = Encrypt(requestId.toString());  
                        const encPorterId = Encrypt(porterId.toString());    
                        const encRequestorId = Encrypt(UID);                 
                        const encProcess = Encrypt('ASSIGNPORTER');          

                        fetch('/Index/Service/Service.aspx?' + new URLSearchParams({
                            Process: encProcess
                        }), {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                requestId: encRequestId,
                                porterId: encPorterId,
                                requestorId: encRequestorId
                            })
                        })
                            .then(res => res.text())
                            .then(text => {
                                let data;
                                try {
                                    data = JSON.parse(text);
                                } catch (e) {
                                    data = { success: true, message: text };
                                }
                                //console.log("Raw Server Response:", text);
                                const successModalEl = document.getElementById('modalEmployeeActionSuccess');
                                const successModal = new bootstrap.Modal(successModalEl);

                                successModalEl.style.zIndex = '2000';
                                document.querySelectorAll('.modal-backdrop').forEach(bd => {
                                    bd.style.zIndex = '1999';
                                });

                                if (isModalVisible) {
                                    return resolve();
                                }

                                if (data.message && data.message.includes('Same Porter is already assigned to this Task')) {
                                    document.getElementById('porterWarningText').textContent =
                                        'Porter is already assigned to this task.';

                                    const warningModalEl = document.getElementById('porterWarningModal');
                                    const warningModal = new bootstrap.Modal(warningModalEl);
                                    warningModal.show();

                                    setTimeout(() => {
                                        warningModal.hide();
                                    }, 2000);

                                    isModalVisible = false;
                                    isActionInProgress = false;
                                    return resolve(); 
                                }

                                if (data.success === true) {
                                    document.getElementById('lblEmployeeActionResult').textContent =
                                        'Porter assigned successfully for RequestID: ' + requestId;

                                    isModalVisible = true;
                                    successModal.show();
                                    window.RefreshAll && window.RefreshAll();

                                    setTimeout(() => {
                                        successModal.hide();
                                        successModalEl.style.zIndex = '';
                                        document.querySelectorAll('.modal-backdrop').forEach(bd => {
                                            bd.style.zIndex = '';
                                        });

                                        isModalVisible = false;
                                        isActionInProgress = false;
                                        resolve();
                                    }, 1500);
                                    return;
                                }

                                if (data.message && data.message.includes('Thread was being aborted')) {
                                    document.getElementById('lblEmployeeActionResult').textContent =
                                        'Porter assigned successfully for RequestID: ' + requestId;

                                    isModalVisible = true;
                                    successModal.show();
                                    window.RefreshAll && window.RefreshAll();

                                    setTimeout(() => {
                                        successModal.hide();
                                        successModalEl.style.zIndex = '';
                                        document.querySelectorAll('.modal-backdrop').forEach(bd => {
                                            bd.style.zIndex = '';
                                        });

                                        isModalVisible = false;
                                        isActionInProgress = false;
                                        resolve();
                                    }, 1500);
                                    return;
                                }
                                 else {
                                    isActionInProgress = false;
                                    reject(new Error('Failed to assign porter.'));
                                }
                            })
                            .catch(error => {
                                console.error('Fetch error:', error);
                                isActionInProgress = false;
                                reject(error);
                            });
                    });
                }

                assignModalEl.addEventListener('show.bs.modal', () => {
                    const searchEl = document.getElementById('searchPorter');
                    if (searchEl) searchEl.value = '';

                    const listEl = document.getElementById('freeEmployeeList');
                    if (listEl) listEl.innerHTML = '';
                });

                window.hasFetchedPorters = false;

                document.addEventListener("DOMContentLoaded", function () {
                    const reassignModalEl = document.getElementById("reassignModal");
                    const reassignFilter = document.getElementById("reassignEmployeeFilter");
                    const container = document.getElementById('FreeEmployeeList');
                    const successModalEl = document.getElementById('modalEmployeeActionSuccess');

                    const successModal = new bootstrap.Modal(successModalEl);
                    const reassignModal = new bootstrap.Modal(reassignModalEl);

                    const porterState = {
                        assigned: [],
                        requestId: null,
                        remainingChances: 0,
                        hasLoadedInitially: false
                    };

                    window.hasFetchedPorters = false;

                    reassignModalEl.addEventListener('shown.bs.modal', function () {
                        const requestId = Number(reassignModalEl.getAttribute('data-request-id'));
                        if (!requestId) return; 

                        const porterId = reassignModalEl.getAttribute('data-porter');
                        const subporterId = reassignModalEl.getAttribute('data-subporter');

                        const assignedPorters = [];
                        if (porterId) assignedPorters.push(Number(porterId));
                        if (subporterId) assignedPorters.push(Number(subporterId));

                        porterState.requestId = requestId;
                        porterState.assigned = [...assignedPorters];
                        porterState.remainingChances = 0;
                        porterState.hasLoadedInitially = false;

                        if (container) container.innerHTML = '<p class="text-muted text-center py-3">Loading available porters...</p>';
                        loadAvailablePortersForReassign('', requestId);
                    });


                    let filterTimeout = null;

                    reassignFilter.addEventListener("input", function () {
                        clearTimeout(filterTimeout);
                        filterTimeout = setTimeout(() => {
                            if (porterState.requestId && porterState.hasLoadedInitially) {
                                loadAvailablePortersForReassign(this.value.trim().toLowerCase(), porterState.requestId);
                            }
                        }, 300);
                    });

                    document.addEventListener('click', function (e) {
                        const link = e.target.closest('.reassign-task');
                        if (!link) return;

                        e.preventDefault(); 

                        const requestId = link.dataset.requestId;
                        const reassignModalEl = document.getElementById('reassignModal');  
                        if (!requestId || !reassignModalEl) return;

                        const encProcess = Encrypt('GetSingleRequestDetails');
                        const encRequestId = Encrypt(requestId);

                        fetch(`/Index/Service/Service.aspx?Process=${encodeURIComponent(encProcess)}&requestId=${encodeURIComponent(encRequestId)}`)
                            .then(res => res.ok ? res.text() : Promise.reject(res.status))
                            .then(text => {
                                const tasks = JSON.parse(text);
                                if (!Array.isArray(tasks) || !tasks.length) return;

                                const task = tasks[0];
                                reassignModalEl.dataset.requestId = requestId;
                                reassignModalEl.dataset.porter = task.PORTERID ?? '';
                                reassignModalEl.dataset.subporter = task.SUBPORTERID ?? '';

                                const modal = bootstrap.Modal.getInstance(reassignModalEl) || new bootstrap.Modal(reassignModalEl, { focus: false });
                                modal.show();
                            })
                            .catch(err => console.error("Failed:", err));
                    });

                    window.porterFetchController = null;
                    async function loadAvailablePortersForReassign(filter = '', requestId) {
                        if (!container || !requestId) return;

                        if (porterFetchController) {
                            porterFetchController.abort();
                        }

                        porterFetchController = new AbortController();
                        const signal = porterFetchController.signal;

                        container.innerHTML = '<p class="text-muted text-center py-3">Loading available porters...</p>';

                        try {
                            const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                            const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';

                            const encryptedProcess = encryptAES('GetEmployeeDataAssign', cryptoKey, cryptoIV);
                            const encryptedFilter = encryptAES(filter, cryptoKey, cryptoIV);
                            const encryptedServiceId = encryptAES(serviceId, cryptoKey, cryptoIV);

                            const res = await fetch(
                                `/Index/Service/Service.aspx?Process=${encodeURIComponent(encryptedProcess)}&filter=${encodeURIComponent(encryptedFilter)}&serviceId=${encodeURIComponent(encryptedServiceId)}`,
                                { signal }
                            );
                            let data = await res.json();

                            if (signal.aborted) return;

                            if (!data || data.length === 0) {
                                container.innerHTML = '<p class="text-center text-muted py-3">No free porters found.</p>';
                                return;
                            }

                            if (filter) {
                                data = data.filter(emp =>
                                    emp.USERNAME && emp.USERNAME.toLowerCase().includes(filter)
                                );
                            }

                            data.sort((a, b) => {
                                const aAssigned = porterState.assigned.includes(Number(a.ID)) ? 0 : 1;
                                const bAssigned = porterState.assigned.includes(Number(b.ID)) ? 0 : 1;
                                return aAssigned - bAssigned;
                            });

                            if (!document.getElementById('porterCardStyles')) {
                                const style = document.createElement('style');
                                style.id = 'porterCardStyles';
                                style.innerHTML = `
                                  .porter-card {
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                    padding: 10px 15px;
                                    border-radius: 8px;
                                    border: 1px solid #e0e0e0;
                                    background-color: #fff;
                                    transition: background 0.2s, box-shadow 0.2s, transform 0.2s;
                                    cursor: pointer;
                                  }
                                  .porter-card:hover {
                                    background-color: #f8fbff;
                                    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                                    transform: translateY(-2px);
                                  }
                                  .tick-wrapper {
                                    width: 24px;
                                    height: 24px;
                                    border-radius: 4px;
                                    border: 2px solid #28a745;
                                    display: flex;
                                    justify-content: center;
                                    align-items: center;
                                    background-color: white;
                                    cursor: pointer;
                                    transition: background 0.25s, border 0.25s, transform 0.2s;
                                  }
                                  .tick-wrapper.checked {
                                    background-color: #28a745;
                                    border-color: #28a745;
                                    transform: scale(1.1);
                                  }
                                  .tick-wrapper svg { display: none; }
                                  .tick-wrapper.checked svg { display: block; }
                                  .fade-in { opacity: 0; animation: fadeIn 0.3s ease forwards; }
                                  @keyframes fadeIn {
                                    from { opacity: 0; transform: translateY(5px); }
                                    to { opacity: 1; transform: translateY(0);}
                                  }
                                `;
                                document.head.appendChild(style);
                            }

                            container.innerHTML = '';
                            data.forEach(emp => {
                                const isAssigned = porterState.assigned.includes(Number(emp.ID));
                                const item = document.createElement('div');
                                item.className = 'porter-card mb-2 fade-in';
                                item.innerHTML = `
                                  <div class="porter-info">
                                    <div class="fw-bold text-dark">${emp.USERNAME}</div>
                                    <small class="text-muted">${emp.HOSPITALNAME1 || ''}</small>
                                  </div>
                                  <div class="tick-wrapper ${isAssigned ? 'checked' : ''}" data-id="${emp.ID}">
                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none"
                                         stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                         <polyline points="20 6 9 17 4 12" />
                                    </svg>
                                  </div>
                                `;
                                const tick = item.querySelector('.tick-wrapper');
                                tick.addEventListener('click', e => {
                                    e.stopPropagation();

                                    const porterId = Number(tick.dataset.id);
                                    const isChecked = tick.classList.contains('checked');

                                    if (!isChecked && porterState.remainingChances <= 0) {
                                        e.preventDefault();
                                        return;
                                    }

                                    handleTickToggle(tick);
                                });

                                item.addEventListener('click', e => {
                                    if (!e.target.closest('.tick-wrapper')) handleTickToggle(tick);
                                });

                                container.appendChild(item);
                            });
                            porterState.hasLoadedInitially = true;

                        } catch (err) {
                            if (err.name === 'AbortError') {
                                //console.log('Previous fetch aborted');
                            } else {
                                console.error('Failed to load porters:', err);
                                container.innerHTML = '<p class="text-danger text-center py-3">Failed to load porters.</p>';
                            }
                        }
                    }

                    function handleTickToggle(tickEl) {
                        if (!tickEl) return;

                        const porterId = Number(tickEl.dataset.id);
                        const isChecked = tickEl.classList.contains('checked');

                        const newCheckedState = isChecked ? false : true;
                        if (newCheckedState) {
                            tickEl.classList.add('checked');
                        } else {
                            tickEl.classList.remove('checked');
                        }

                        const process = newCheckedState ? 'reassign' : 'remove';

                        if (newCheckedState) {
                            if (!porterState.assigned.includes(porterId)) {
                                porterState.assigned.push(porterId);
                                porterState.remainingChances = Math.max(0, porterState.remainingChances - 1);
                            }
                        } else {
                            const index = porterState.assigned.indexOf(porterId);
                            if (index > -1) {
                                porterState.assigned.splice(index, 1);
                                porterState.remainingChances++;
                            }
                        }

                        tickEl.style.pointerEvents = 'none';
                        setTimeout(() => {
                            tickEl.style.pointerEvents = 'auto';
                        }, 250);

                        updateTaskPorter(porterState.requestId, porterId, process);
                    }
                    function updateTaskPorter(requestId, porterId, process) {
                        const isChecked = process === 'reassign';
                        const userId = sessionStorage.getItem('ID') || 0;

                        if (!userId) {
                            console.error('No USERID in session');
                            return;
                        }

                        const encProcess = Encrypt('UpdatePorterAssignment');
                        const encRequestId = Encrypt(requestId.toString());
                        const encPorterId = Encrypt(porterId.toString());
                        const encIsChecked = Encrypt(isChecked.toString());
                        const encUserId = Encrypt(userId.toString());

                        fetch(`/Index/Service/Service.aspx?Process=${encodeURIComponent(encProcess)}`, {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                requestId: encRequestId,
                                porterId: encPorterId,
                                isChecked: encIsChecked,
                                userId: encUserId
                            })
                        })
                            .then(res => res.text())
                            .then(text => {
                                //console.log("RAW:", text);

                                let cleanText = text.replace(/\[\]$/, '');

                                let data;
                                try {
                                    data = JSON.parse(cleanText);
                                } catch (e) {
                                    console.error("JSON ERROR:", text);
                                    return;
                                }

                                if (data.success) {
                                    const porterName = data.porterName || 'Unknown Porter';
                                    const actionMessage = isChecked
                                        ? `Porter: ${porterName} reassigned for RequestID: ${requestId}`
                                        : `Porter: ${porterName} removed from RequestID: ${requestId}`;

                                    document.getElementById('lblEmployeeActionResult').textContent = actionMessage;
                                    successModal.show();

                                    if (window.RefreshAll) window.RefreshAll();
                                    setTimeout(() => successModal.hide(), 1500);
                                } else {
                                    console.error('Update failed:', data.message);
                                }
                            })
                            .catch(err => console.error('Fetch error:', err));
                    }



                    const closeBtn = document.getElementById('btnCloseReassignModal');
                    if (closeBtn) {
                        closeBtn.addEventListener('click', () => {
                            const modalInstance = bootstrap.Modal.getInstance(reassignModalEl);
                            if (modalInstance) {
                                modalInstance.hide();
                            }
                        });
                    }

                    reassignModalEl.addEventListener('hidden.bs.modal', () => {

                        const openModals = document.querySelectorAll('.modal.show');
                        if (openModals.length === 0) {
                            const backdrops = document.querySelectorAll('.modal-backdrop');
                            backdrops.forEach(bd => bd.remove());
                            document.body.classList.remove('modal-open');
                            document.body.style.removeProperty('padding-right');
                        }

                        if (container) container.innerHTML = '';

                        porterState.assigned = [];
                        porterState.remainingChances = 0;
                        porterState.requestId = null;
                        porterState.hasLoadedInitially = false;
                        window.hasFetchedPorters = false;
                    });

                });

                document.querySelector('[data-bs-dismiss="modal"]').addEventListener('click', function () {
                    const modalElement = document.getElementById('breakDurationModal');
                    const modal = bootstrap.Modal.getInstance(modalElement);
                    modal.hide();
                });

                document.addEventListener('DOMContentLoaded', function () {

                    document.addEventListener('click', function (e) {
                        if (e.target.closest('.dropdown-menu')) {
                            e.stopPropagation();
                        }
                    });
                });

                const cryptoKey = '9090909090909090';
                const cryptoIV = '9090909090909090';

                function LoadEquipment(val, serviceId) {
                    if (!serviceId) {
                        const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                        serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';
                    }

                    const isTrolleyMode = (serviceId === "2");

                    if (!val || val.trim() === "") {
                        val = isTrolleyMode ? "Tr" : "a";
                    }
                    const encryptedProcess = Encrypt('fetchEquipment');

                    let url = hurl + "SERVICE/Service.aspx?Process=" + encodeURIComponent(encryptedProcess);
                    url += "&VAL=" + encodeURIComponent(Encrypt(val));
                    url += "&VAL1=" + encodeURIComponent(Encrypt(ReqCat || ''));
                    url += "&SERVICEID=" + encodeURIComponent(Encrypt(serviceId));

                    resetMultiPorter();
                    $("#EquipmentCategories").html("<p class='text-white'></p>");

                    $.ajax({
                        url: url,
                        type: 'POST',
                        dataType: 'json',
                        success: function (data) {
                            if (!data || data.length === 0) {
                                $("#EquipmentCategories").html("<p class='text-white'></p>");
                                return;
                            }

                            let sortedData = data;

                            if (isTrolleyMode) {
                                let trolleyItem = null;
                                let otherItems = [];
                                $.each(data, function (_, item) {
                                    if (item.VALUE?.toLowerCase() === "trolley") trolleyItem = item;
                                    else otherItems.push(item);
                                });
                                sortedData = trolleyItem ? [trolleyItem, ...otherItems] : otherItems;
                            }

                            const html = sortedData.map(value => {
                                const imgPath = value.IMAGEPATH || "../images/no-image.png";
                                const isTwoPorter = value.AssistantRequired || false;
                                return `
                    <li>
                        <input type="checkbox" 
                               id="chkEquip${value.Id}" 
                               class="equipment-checkbox"
                               onchange="onEquipmentSelect('${value.Id}', ${isTwoPorter})">
                        <span><img src="../images/check.png" alt="check"></span>
                        <img src="${imgPath}" alt="${value.VALUE}">
                        <p>${value.VALUE}</p>
                    </li>`;
                            }).join('');

                            $("#EquipmentCategories").html('<ul>' + html + '</ul>');

                            if (isTrolleyMode && sortedData.length > 0) {
                                const trolleyItem = sortedData.find(item => item.VALUE?.toLowerCase() === "trolley");
                                if (trolleyItem) {
                                    $(`#chkEquip${trolleyItem.Id}`).prop('checked', true);
                                    //onEquipmentSelect(trolleyItem.Id, trolleyItem.AssistantRequired || false);
                                }
                            }
                        },
                        error: function (xhr) {
                            console.error("Equipment load error:", xhr.responseText);
                            $("#EquipmentCategories").html("<p class='text-white'>Failed to load equipment</p>");
                        }
                    });
                }

                function resetMultiPorter() {
                    const $multiPorter = $('#chkMultiPorter');
                    const $multiPorterImg = $('#chkMultiPorterImg');
                    $multiPorter.prop({ checked: false, disabled: false });
                    $multiPorterImg.attr('src', '../images/NoMCheck.jpg');
                    selectedEquipmentPorter = 0;
                }

                let selectedCategoryPorter = 0;
                let selectedEquipmentPorter = 0;

                function updateMultiPorter() {
                    const $multiPorter = $('#chkMultiPorter');
                    const $multiPorterImg = $('#chkMultiPorterImg');

                    if (selectedCategoryPorter === 1 && selectedEquipmentPorter === 1) {
                        $multiPorter.prop({ checked: true, disabled: true });
                        $multiPorterImg.attr('src', '../images/MCheck.jpg');
                    } else if (selectedCategoryPorter === 0 && selectedEquipmentPorter === 1) {
                        $multiPorter.prop({ checked: true, disabled: true });
                        $multiPorterImg.attr('src', '../images/MCheck.jpg');
                    } else if (selectedCategoryPorter === 1 && selectedEquipmentPorter === 0) {
                        $multiPorter.prop({ checked: true, disabled: false });
                        $multiPorterImg.attr('src', '../images/MCheck.jpg');
                    } else {
                        $multiPorter.prop({ checked: false, disabled: false });
                        $multiPorterImg.attr('src', '../images/NoMCheck.jpg');
                    }

                    if (typeof setMultiPorter === "function") {
                        setMultiPorter();
                    }
                }

                function CatSelection(ele, id, isTwoPorterTask, value, quantity, TS, TE) {
                    clearAllCheckBox('ReqCategories');
                    $(ele).prop('checked', true);

                    ReqCat = id;
                    selectedCategoryPorter = isTwoPorterTask === "1" ? 1 : 0;

                    updateMultiPorter();

                    if (TS && TE) {
                        $('#lblKPITS').html((TS !== '-' && TS !== '0') ? (TS + '<br/><span style="font-size:13px;">(min)</span>') : '10');
                        $('#lblKPITE').html((TE !== '-' && TE !== '0') ? (TE + '<br/><span style="font-size:13px;">(min)</span>') : '5');
                    }
                }               

                function clearAllCheckBox(containerId) {
                    $(`#${containerId} input[type=checkbox]`).prop('checked', false);
                }

                function onEquipmentSelect(id, assistantRequired) {
                    const $clicked = $(`#chkEquip${id}`);
                    const $multiPorter = $('#chkMultiPorter');
                    const $multiPorterImg = $('#chkMultiPorterImg');

                    if ($clicked.is(':checked')) {
                        $('#EquipmentCategories input[type=checkbox]')
                            .not($clicked)
                            .prop('checked', false);
                    }

                    selectedEquipmentPorter = [true, "true", 1, "1"].includes(assistantRequired) ? 1 : 0;

                    if (selectedCategoryPorter === 1 && selectedEquipmentPorter === 1) {
                        $multiPorter.prop({ checked: true, disabled: true });
                        $multiPorterImg.attr('src', '../images/MCheck.jpg');
                    } else if (selectedCategoryPorter === 0 && selectedEquipmentPorter === 1) {
                        $multiPorter.prop({ checked: true, disabled: true });
                        $multiPorterImg.attr('src', '../images/MCheck.jpg');
                    } else if (selectedCategoryPorter === 1 && selectedEquipmentPorter === 0) {
                        $multiPorter.prop({ checked: true, disabled: false });
                        $multiPorterImg.attr('src', '../images/MCheck.jpg');
                    } else {
                        $multiPorter.prop({ checked: false, disabled: false });
                        $multiPorterImg.attr('src', '../images/NoMCheck.jpg');
                    }

                    if (typeof setMultiPorter === "function") {
                        setMultiPorter();
                    }
                }

                function searchEquipment(input) {
                    const val = input.value;

                    const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                    const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '1';

                    const encryptedProcess = encryptAES('fetchEquipment', cryptoKey, cryptoIV);

                    $.ajax({
                        async: true,
                        type: 'GET',
                        url: hurl + "SERVICE/Service.aspx?Process=" + encodeURIComponent(encryptedProcess) +
                            "&VAL=" + encodeURIComponent(encryptAES(val, cryptoKey, cryptoIV)) +
                            "&VAL1=" + encodeURIComponent(encryptAES(ReqCat || '', cryptoKey, cryptoIV)) +
                            "&SERVICEID=" + encodeURIComponent(encryptAES(serviceId, cryptoKey, cryptoIV)),
                        dataType: 'json',
                        success: function (data) {
                            if (!data || data.length === 0) {
                                $("#EquipmentCategories").html("<p class='text-white'>No Equipment Found</p>");
                                return;
                            }

                            let equipmentHTML = '';
                            $.each(data, function (key, value) {
                                const imgPath = value.IMAGEPATH || "../images/no-image.png";
                                const isTwoPorter = value.AssistantRequired; 

                                equipmentHTML += `
                                <li>
                                    <input type="checkbox" 
                                           id="chkEquip${value.Id}" 
                                           class="equipment-checkbox"
                                           onchange="onEquipmentSelect('${value.Id}', ${isTwoPorter})">
                                    <span><img src="../images/check.png" alt="check"></span>
                                    <img src="${imgPath}" alt="${value.VALUE}" />
                                    <p>${value.VALUE}</p>
                                </li>`;
                            });

                            $('#EquipmentCategories').html('<ul>' + equipmentHTML + '</ul>');
                        },
                        error: function (xhr, status, error) {
                            console.error("Error fetching equipment:", error);
                        }
                    });
                }

                function LoadEquipmentOnInit(serviceId) {
                    ReqCat = ReqCat || '';
                    LoadEquipment('', serviceId);
                }

                function getSelectedEquipIDs() {
                    const selectedIDs = [];

                    $('#EquipmentCategories input[type=checkbox]:checked').each(function () {
                        const id = $(this).attr('id');
                        if (id && id.startsWith('chkEquip')) {
                            const equipId = id.replace('chkEquip', '');
                            if (equipId && equipId !== 'undefined') {
                                selectedIDs.push(equipId);
                            }
                        }
                    });

                    return selectedIDs.length > 0 ? selectedIDs[0] : '';
                }

                //function encryptAES(text) {
                //    const key = CryptoJS.enc.Utf8.parse('9090909090909090');
                //    const iv = CryptoJS.enc.Utf8.parse('9090909090909090');

                //    const encrypted = CryptoJS.AES.encrypt(text, key, {
                //        iv: iv,
                //        mode: CryptoJS.mode.CBC,
                //        padding: CryptoJS.pad.Pkcs7
                //    });

                //    return encodeURIComponent(encrypted.toString());
                //}

                function encryptAES(text) {
                    const key = CryptoJS.enc.Utf8.parse('9090909090909090');
                    const iv = CryptoJS.enc.Utf8.parse('9090909090909090');

                    const encrypted = CryptoJS.AES.encrypt(text, key, {
                        iv: iv,
                        mode: CryptoJS.mode.CBC,
                        padding: CryptoJS.pad.Pkcs7
                    });

                    return encrypted.toString();
                }

                function encryptQS(value) {
                    if (value === null || value === undefined || value === "")
                        return "";

                    return encodeURIComponent(encryptAES(value.toString()));
                }

                function InsertRequest() {
                    setMultiPorter();
                    var selectedEquipIDsString = getSelectedEquipIDs();
                    var UID = sessionStorage.getItem('ID');
                    var PBDTime = (RPreBook == '2') ? formatDate('txtReqdate', 'txtReqTime') : '';
                    var dlRemarkTxt = selectedText('search_Remarks');
                    var PatientName = $('#txtPatientName').val(),
                        PatientHN = $('#txtPatientHNO').val(),
                        PatientDOB = $('#txtPatientDOB').val(),
                        ContactNo = $('#txtContactNumber').val(),
                        Remarks = dlRemarkTxt + '_' + $('#txtRemarks').val();
                    var ReqtrName = $('#txtRequestorName').val().trim();
                    let ServiceID = $('#divRService2').hasClass('active') ? '2' : '1';
                    var qty = $('#txtQty').val();
                    var Kitchen = $('#txtKitchen').val() || "0";

                    var encProcess = Encrypt("INSERTREQUEST");
                    var encPBDTime = encryptQS(PBDTime);
                    var encCategory = encryptQS(ReqCat);
                    var encFrom = encryptQS(RFromID);
                    var encTo = encryptQS(RToID);
                    var encMultiPorter = encryptQS(IsMTPR);
                    var encPatientName = encryptQS(PatientName + "_" + PatientHN + "_" + PatientDOB);
                    var encRemarks = encryptQS(Remarks);
                    var encUserID = encryptQS(UID);
                    var encHalt1 = encryptQS(RHalt1);
                    var encHalt2 = encryptQS(RHalt2);
                    var encPriority = encryptQS("0");
                    var encExtraFields = encryptQS(IsRTC + "_" + ContactNo);
                    var encQty = encryptQS(qty || "0");
                    var encRequestor = encryptQS(ReqtrName);
                    var encServiceID = encryptQS(ServiceID);
                    var encKitchen = encryptQS(Kitchen);

                    var firstEquipID = selectedEquipIDsString.split(',')[0];
                    var encEquipment = encryptQS(firstEquipID);

                    var requestUrl = hurl + "SERVICE/Service.aspx?Process=" + encProcess +
                        "&PBDATE=" + encPBDTime +
                        "&CATEGORY=" + encCategory +
                        "&FROM=" + encFrom +
                        "&TO=" + encTo +
                        "&MULTIPORTER=" + encMultiPorter +
                        "&PATIENTNAME=" + encPatientName +
                        "&REMARKS=" + encRemarks +
                        "&USERID=" + encUserID +
                        "&HALT1=" + encHalt1 +
                        "&HALT2=" + encHalt2 +
                        "&PRIORITY=" + encPriority +
                        "&EXTRAFIELDS=" + encExtraFields +
                        "&Qty=" + encQty +
                        "&REQUESTOR=" + encRequestor +
                        "&SERVICEID=" + encServiceID +
                        "&EQUIPMENT=" + encEquipment;

                    $.ajax({
                        async: true,
                        url: requestUrl,
                        type: 'POST',
                        data: new FormData(),
                        processData: false,
                        contentType: false,
                        dataType: 'json',
                        success: function (data) {
                            let resultParts = data[0].RESULT.split("_");
                            let status = resultParts[0];
                            let ReqNB = resultParts[1] || '';

                            if (status === 'TRUE' && (!PBDTime || PBDTime === '')) {
                                let msg = (RHalt1 === '0' && RHalt2 === '0')
                                    ? 'Task Created Successfully.. Task ID. #' + ReqNB
                                    : 'Task(s) Created Successfully.. Task IDs. ' + ReqNB;

                                $('#LBLRequestResult').html(msg);
                                $('#modalReqAlert').modal('show');

                                setTimeout(() => {
                                    $('#modalReqAlert').modal('hide');
                                }, 3500);

                                HideModalPopUp('addTask');
                                ReloadLinks();
                                window.RefreshAll();
                                setRequestUsers('Tasks');

                            } else if (status === 'TRUE_PREBOOK' || PBDTime.length > 0) {
                                let msg = 'Pre-Book Task Created - Request ID: #' + ReqNB;

                                $('#LBLRequestResult').html(msg);
                                $('#modalReqAlert').modal('show');
                                window.RefreshAll();

                                setTimeout(() => {
                                    $('#modalReqAlert').modal('hide');
                                }, 3500);

                                HideModalPopUp('addTask');
                                ReloadLinks();
                                window.RefreshAll();
                                setRequestUsers('Tasks');

                            } else if (status === 'FALSE') {
                                $('#spanErrorMessage').html('A similar/same request has already been raised.');
                                ShowModalPopUp('modalAlert');
                                setTimeout(() => HideModalPopUp('modalAlert'), 3500);
                            } else {
                                console.warn("Unexpected status:", status);
                            }
                        },
                        error: function (err) {
                            alert('Error occurred: ' + (err.responseText || 'Unknown'));
                        }
                    });
                }

                function UpdateRequest() {
                    var ReqID = document.getElementById('HFERID').value, ReqNB = document.getElementById('HFERNO').value, StatusID = document.getElementById('HFStatusID').value;

                    var IsMitigation = "0";
                    var drpCancelRemark = selectedText('search_CancelRemarks'), drpCompleteRemark = '',
                        drpRemark = selectedText('search_Remarks');

                    var CancelledRemarks = drpCancelRemark + '_' + $('#txtCanceRemarks').val();

                    var CompletedRemarks = '';

                    var Remarks = drpRemark + '_' + $('#txtRemarks').val();

                    var ReqtrName = $('#txtRequestorName').val().trim(), kitchen = $('#txtFromLoc').val().trim();

                    var UID = sessionStorage.getItem('ID');
                    var PBDTime = (RPreBook == '2') ? formatDate('txtReqdate', 'txtReqTime') : '';
                    var PatientName = $('#txtPatientName').val(), PatientHN = $('#txtPatientHNO').val(), PatientDOB = $('#txtPatientDOB').val(), ContactNo = $('#txtContactNumber').val();// srcMulti = $('#chkMultiPorter').attr('src') , Remarks = $('#txtRemarks').val();
                    var qty = $('#txtQty').val();

                    $.ajax({
                        async: true,
                        url: hurl + "SERVICE/Service.aspx?Process=UPDATEREQUEST&PBDATE=" + encodeURIComponent(Encrypt(PBDTime)) + "&CATEGORY=" + encodeURIComponent(Encrypt(ReqCat)) + "&FROM=" + encodeURIComponent(Encrypt(RFromID)) + "&TO=" + encodeURIComponent(Encrypt(RToID)) +
                            "&MULTIPORTER=" + encodeURIComponent(Encrypt(IsMTPR + "_" + OIsMTPR)) + "&PATIENTNAME=" + encodeURIComponent(Encrypt(PatientName + "_" + PatientHN + "_" + PatientDOB)) + "&REMARKS=" + encodeURIComponent(Encrypt(Remarks)) + "&USERID=" + encodeURIComponent(Encrypt(UID))
                            + "&PRIORITY= " + encodeURIComponent(Encrypt("0")) + "&EXTRAFIELDS=" + encodeURIComponent(Encrypt(IsRTC + "_" + IsMitigation + "_" + ContactNo)) + "&REQUESTID=" + encodeURIComponent(Encrypt(ReqID)) + '&STATUS=' + encodeURIComponent(Encrypt(StatusID))
                            + '&COMPLETEREMARKS=' + encodeURIComponent(Encrypt(CompletedRemarks)) + '&CANCELREMARKS=' + encodeURIComponent(Encrypt(CancelledRemarks)) + "&Qty=" + encodeURIComponent(Encrypt(qty)) + "&REQUESTOR=" + encodeURIComponent(Encrypt(ReqtrName))
                            + "&KITCHEN=" + encodeURIComponent(Encrypt(kitchen)) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)) + "&MODIFIEDVALUS=" + encodeURIComponent(Encrypt(getModifiedValues())),
                        type: 'POST',
                        data: 'pData',
                        dataType: 'json',
                        success: function (data) {
                            if (data[0].RESULT.split("_")[0] === 'TRUE') {

                                $('#LBLRequestResult').html('Request Updated Successfully.. Req No. #' + ReqNB);

                                HideModalPopUp('addTask'); ShowModalPopUp('modalReqAlert');
                                setTimeout("HideModalPopUp('modalReqAlert');", 3500);
                                HideModalPopUp('modalReqAlert');
                                LoadProcess(CProcess);
                            }
                        },
                        error: function (data) {
                            $('#').html(data[0].RESULT);
                        }
                    });
                }

                function submitRequest() {
                    var fromLoc = document.getElementById('txtFromLoc').value.trim();
                    var toLoc = document.getElementById('txtToLoc').value.trim();
                    var fromLocId = document.getElementById('txtFromLoc').getAttribute('data-locid');
                    var catChecked = document.querySelector('input[type="checkbox"][id^="chkCat"]:checked');
                    var errorMessage = "";

                    if (fromLoc === "" || toLoc === "" || !catChecked) {
                        if (fromLoc === "") {
                            errorMessage += "Please select a From Location.\n";
                        }
                    }
                    if (toLoc === "") {
                        errorMessage += "Please select a To Location.\n";
                    }
                    if (!catChecked) {
                        errorMessage += "Please select a Task Type.\n";
                    }

                    if (errorMessage !== "") {
                        document.getElementById('spanErrorMessage').innerText = errorMessage;

                        var alertModalEl = document.getElementById('modalAlert');
                        var alertModal = new bootstrap.Modal(alertModalEl);
                        alertModal.show();

                        setTimeout(() => {
                            var modalInstance = bootstrap.Modal.getInstance(alertModalEl);
                            if (modalInstance) {
                                modalInstance.hide();
                            }
                        }, 2000);

                        return;
                    }

                    var btn = document.getElementById('btnReqSubmit');
                    if (btn) btn.disabled = true;

                    var isEdit = (document.getElementById('HFERID').value.length > 0);

                    if (isEdit) {
                        UpdateRequest();
                    } else {
                        InsertRequest();
                    }
                }

                function RaiseDuplicate(ReqID) {
                    AbortAllActiveRuquests();

                    const UID = sessionStorage.getItem('ID');

                    $.ajax({
                        async: true,
                        url: `${hurl}SERVICE/Service.aspx?Process=DUPLICATEREQUEST&REQUESTID=${encodeURIComponent(Encrypt(ReqID))}&USERID=${encodeURIComponent(Encrypt(UID))}`,
                        type: 'POST',
                        data: 'pData',
                        dataType: 'json',
                        success: function (data) {
                            if (!data || !data[0] || !data[0].RESULT) {
                                console.error('Invalid data returned from server');
                                return;
                            }

                            const resultParts = data[0].RESULT.split("_");
                            const status = resultParts[0];
                            const reqNumber = resultParts[1];

                            if (status === 'TRUE') {
                                if (RHalt1 === '0' && RHalt2 === '0') {
                                    $('#LBLRequestResult').html(`Request Raised Successfully.. Req No. #${reqNumber}`);
                                } else {
                                    $('#LBLRequestResult').html(`Request(s) Raised Successfully.. Req Nos. ${reqNumber}`);
                                }

                                HideModalPopUp('addTask');
                                ShowModalPopUp('modalReqAlert');

                                setTimeout(() => HideModalPopUp('modalReqAlert'), 3500);

                                Select("divPendingPercentage", "PENDING");
                                setRequestUsers('Tasks');
                            } else if (status === 'FALSET') {
                                $('#spanErrorMessage').html('A similar/same request has already been raised.');
                                ShowModalPopUp('modalAlert');
                                setTimeout(() => HideModalPopUp('modalAlert'), 3500);
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error('Error in RaiseDuplicate:', error);
                            $('#spanErrorMessage').html('An error occurred while processing the request.');
                            ShowModalPopUp('modalAlert');
                            setTimeout(() => HideModalPopUp('modalAlert'), 3500);
                        }
                    });
                }

                let filters = {
                    filterTaskId: "",
                    filterTaskType: "",
                    filterEquipmentType: "",
                    filterRequestStatus: "",
                    filterFromLocation: "",
                    filterToLocation: "",
                    filterFromZone: "",
                    filterToZone: "",
                    filterEmployee: "",

                    filterUserName: "",
                    filterLocation: "",
                    filterHospital: "",
                    filterShift: "",
                    filterStatus: ""
                };

                function populateSelect(selectId, items, selectedValue = "") {
                    const select = document.getElementById(selectId);
                    if (!select) return;

                    const currentValue = select.value;

                    const currentOptions = [];
                    for (let i = 0; i < select.options.length; i++) {
                        currentOptions.push({
                            value: select.options[i].value,
                            text: select.options[i].text,
                            selected: select.options[i].selected
                        });
                    }

                    select.innerHTML = '';

                    const defaultOption = document.createElement('option');
                    defaultOption.value = '';
                    defaultOption.textContent = 'Select items...';
                    select.appendChild(defaultOption);

                    items.forEach(item => {
                        if (item && item.trim() !== '') {
                            const option = document.createElement('option');
                            option.value = item;
                            option.textContent = item;

                            if (selectedValue && item === selectedValue) {
                                option.selected = true;
                            } else if (!selectedValue) {
                                const wasSelected = currentOptions.find(opt => opt.value === item && opt.selected);
                                if (wasSelected) {
                                    option.selected = true;
                                }
                            }
                            select.appendChild(option);
                        }
                    });
                }

                function loadFilterDropdowns(serviceId) {

                    const prebookCheckbox = document.getElementById('showPrebookedCheckbox');
                    const isPrebooked = prebookCheckbox && prebookCheckbox.checked;

                    const currentValues = {
                        taskId: document.getElementById('taskIdSelect')?.value || "",
                        taskType: document.getElementById('taskTypeSelect')?.value || "",
                        equipmentType: document.getElementById('equipmentSelect')?.value || "",
                        requestStatus: document.getElementById('requestStatusSelect')?.value || "",
                        fromLocation: document.getElementById('fromLocationSelect')?.value || "",
                        toLocation: document.getElementById('toLocationSelect')?.value || "",
                        fromZone: document.getElementById('fromZoneSelect')?.value || "",
                        toZone: document.getElementById('toZoneSelect')?.value || "",
                        employee: document.getElementById('employeeSelect')?.value || ""
                    };

                    var encProcess = Encrypt('GETFILTEROPTIONS');
                    var encServiceId = Encrypt(serviceId || '');
                    var encIsPrebooked = Encrypt(isPrebooked ? '1' : '0');

                    $.ajax({
                        url: '/Index/Service/Service.aspx',
                        method: 'GET',
                        dataType: 'json',
                        data: {
                            Process: encProcess,
                            serviceId: encServiceId,
                            isPrebooked: encIsPrebooked
                        },
                        success: function (response) {
                            const data = response;
                            if (!data) {
                                //console.log("No filter data received.");
                                return;
                            }

                            populateSelect("taskIdSelect", data.taskIds || [], currentValues.taskId);
                            populateSelect("taskTypeSelect", data.taskTypes || [], currentValues.taskType);
                            populateSelect("equipmentSelect", data.equipmentTypes || [], currentValues.equipmentType);
                            populateSelect("requestStatusSelect", data.requestStatuses || [], currentValues.requestStatus);
                            populateSelect("fromLocationSelect", data.fromLocations || [], currentValues.fromLocation);
                            populateSelect("toLocationSelect", data.toLocations || [], currentValues.toLocation);
                            populateSelect("fromZoneSelect", data.fromZones || [], currentValues.fromZone);
                            populateSelect("toZoneSelect", data.toZones || [], currentValues.toZone);
                            populateSelect("employeeSelect", data.employees || [], currentValues.employee);
                        },
                        error: function (xhr, status, error) {
                            console.error("Failed to load filter data:", error);
                        }
                    });
                }

                function loadStartedFilterDropdowns(serviceId) {
                    const currentValues = {
                        taskId: document.getElementById('taskIdSelectStarted')?.value || "",
                        taskType: document.getElementById('taskTypeSelectStarted')?.value || "",
                        equipmentType: document.getElementById('equipmentSelectStarted')?.value || "",
                        fromLocation: document.getElementById('fromLocationSelectStarted')?.value || "",
                        toLocation: document.getElementById('toLocationSelectStarted')?.value || "",
                        employee: document.getElementById('employeeSelectStarted')?.value || ""
                    };

                    var encProcess = Encrypt('GETSTARTFILTEROPTIONS');
                    var encServiceId = Encrypt(serviceId || '');

                    $.ajax({
                        url: '/Index/Service/Service.aspx',
                        method: 'GET',
                        dataType: 'json',
                        data: {
                            Process: encProcess,
                            serviceId: encServiceId
                        },
                        success: function (response) {
                            const data = response;
                            if (!data) {
                                alert("No started filter data received.");
                                return;
                            }
                            populateSelect("taskIdSelectStarted", data.taskIds || [], currentValues.taskId);
                            populateSelect("taskTypeSelectStarted", data.taskTypes || [], currentValues.taskType);
                            populateSelect("equipmentSelectStarted", data.equipmentTypes || [], currentValues.equipmentType);
                            populateSelect("fromLocationSelectStarted", data.fromLocations || [], currentValues.fromLocation);
                            populateSelect("toLocationSelectStarted", data.toLocations || [], currentValues.toLocation);
                            populateSelect("employeeSelectStarted", data.employees || [], currentValues.employee);
                        },
                        error: function () {
                            alert("Failed to load started filter data.");
                        }
                    });
                }

                $(document).ready(function () {
                    $('#openFilterModal').on('click', function () {
                        const $panel = $(this).siblings('.filter-panel');
                        const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                        const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';

                        if ($panel.css('display') !== 'block') {
                            loadFilterDropdowns(serviceId);
                        }
                        $panel.toggle();
                    });

                    $('.filter-icon').on('click', function (e) {
                        e.stopPropagation();
                        const $filterWrapper = $(this).closest('.filter-wrapper');
                        const $filterPanel = $filterWrapper.find('.filter-panel');
                        $filterPanel.toggle();
                    });

                    $(document).on('click', function (event) {
                        if (!$(event.target).closest('.filter-wrapper').length) {
                            $('.filter-panel').hide();
                        }
                    });

                    $('.filter-panel .btn-grey').on('click', function () {
                        $(this).closest('.filter-panel').hide();
                    });

                    $(document).on('click', '.apply-filters', function () {
                        const $filterPanel = $(this).closest('.filter-panel');
                        const $column = $(this).closest('.column-container');

                        const isPending = $column.find('#pendingList').length > 0;
                        const isStarted = $column.find('#startedList').length > 0;
                        const isEmployee = $column.find('#employeeList').length > 0;

                        const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                        const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';

                        if (isPending) {
                            filters.filterTaskId = $('#taskIdSelect').val() || "";
                            filters.filterTaskType = $('#taskTypeSelect').val() || "";
                            filters.filterEquipmentType = $('#equipmentSelect').val() || "";
                            filters.filterRequestStatus = $('#requestStatusSelect').val() || "";
                            filters.filterFromLocation = $('#fromLocationSelect').val() || "";
                            filters.filterToLocation = $('#toLocationSelect').val() || "";
                            filters.filterFromZone = $('#fromZoneSelect').val() || "";
                            filters.filterToZone = $('#toZoneSelect').val() || "";
                            filters.filterEmployee = $('#employeeSelect').val() || "";

                            if (typeof reloadTasks === 'function') {
                                reloadTasks(serviceId);
                            } else {
                            //    console.warn("reloadTasks function not defined.");
                            }
                        } else if (isStarted) {
                            filters.filterTaskId = $('#taskIdSelectStarted').val() || "";
                            filters.filterTaskType = $('#taskTypeSelectStarted').val() || "";
                            filters.filterEquipmentType = $('#equipmentSelectStarted').val() || "";
                            filters.filterFromLocation = $('#fromLocationSelectStarted').val() || "";
                            filters.filterToLocation = $('#toLocationSelectStarted').val() || "";
                            filters.filterEmployee = $('#employeeSelectStarted').val() || "";

                            if (typeof reloadStartedTasks === 'function') {
                                reloadStartedTasks(serviceId);
                            } else {
                            //    console.warn("reloadStartedTasks function not defined.");
                            }
                        } else if (isEmployee) {
                            $filterPanel.find('select').each(function () {
                                const label = $(this).closest('.row').find('label').text().trim().toLowerCase();
                                const value = $(this).val() || "";

                                if (label.includes("user name")) filters.filterUserName = value;
                                else if (label.includes("location")) filters.filterLocation = value;
                                else if (label.includes("hospital")) filters.filterHospital = value;
                                else if (label.includes("shift")) filters.filterShift = value;
                                else if (label.includes("status")) filters.filterStatus = value;
                            });

                        //    console.log("Employee filters applied:", filters);
                        }

                        $filterPanel.hide();
                    });
                });

                $('#openFilterModal').on('click', function () {
                });

                $('#openStartedFilterModal').on('click', function () {
                    const $panel = $(this).siblings('.filter-panel');
                    const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                    const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';

                    if ($panel.css('display') !== 'block') {
                        loadStartedFilterDropdowns(serviceId);
                    }
                    $panel.toggle();
                });

                let isFiltered = false;

                $('.apply-filters').on('click', function () {
                    const $filterPanel = $(this).closest('.filter-panel');
                    const $column = $(this).closest('.column-container');

                    const isPending = $column.find('#pendingList').length > 0;
                    const isStarted = $column.find('#startedList').length > 0;
                    const isEmployee = $column.find('#employeeList').length > 0;

                    const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                    const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';

                    if (isPending) {
                        filters.filterTaskId = $('#taskIdSelect').val() || "";
                        filters.filterTaskType = $('#taskTypeSelect').val() || "";
                        filters.filterEquipmentType = $('#equipmentSelect').val() || "";
                        filters.filterRequestStatus = $('#requestStatusSelect').val() || "";
                        filters.filterFromLocation = $('#fromLocationSelect').val() || "";
                        filters.filterToLocation = $('#toLocationSelect').val() || "";
                        filters.filterFromZone = $('#fromZoneSelect').val() || "";
                        filters.filterToZone = $('#toZoneSelect').val() || "";
                        filters.filterEmployee = $('#employeeSelect').val() || "";

                        if (typeof reloadTasks === 'function') {
                            reloadTasks(serviceId);
                        } else {
                        //    console.warn("reloadTasks function not defined.");
                        }
                    } else if (isStarted) {
                        filters.filterTaskId = $('#taskIdSelectStarted').val() || "";
                        filters.filterTaskType = $('#taskTypeSelectStarted').val() || "";
                        filters.filterEquipmentType = $('#equipmentSelectStarted').val() || "";
                        filters.filterFromLocation = $('#fromLocationSelectStarted').val() || "";
                        filters.filterToLocation = $('#toLocationSelectStarted').val() || "";
                        filters.filterEmployee = $('#employeeSelectStarted').val() || "";

                        if (typeof reloadStartedTasks === 'function') {
                            reloadStartedTasks(serviceId);
                        } else {
                        //    console.warn("reloadStartedTasks function not defined.");
                        }
                    } else if (isEmployee) {
                        filters.filterUserName = $('#employeeUserName').val() || "";
                        filters.filterHospital = $('#employeeHospital').val() || "";
                        filters.filterShift = $('#employeeShift').val() || "";
                        filters.filterStatus = $('#employeeStatus').val() || "";

                        if (typeof loadEmployees === 'function') {
                            loadEmployees(serviceId, filters);
                        } else {
                        //    console.warn("loadEmployees function not defined.");
                        }
                    }

                    $filterPanel.hide();

                    isFiltered = true;
                    clearInterval(AutoRefresh);
                });

                function populateSelect(selectId, items, selectedValue = "") {
                    const select = document.getElementById(selectId);
                    if (!select) return;

                    select.innerHTML = '';
                    const defaultOption = document.createElement('option');
                    defaultOption.value = '';
                    defaultOption.textContent = 'Select items...';
                    select.appendChild(defaultOption);

                    items.forEach(item => {
                        if (item && item.trim() !== '') {
                            const option = document.createElement('option');
                            option.value = item;
                            option.textContent = item;
                            if (item === selectedValue) option.selected = true;
                            select.appendChild(option);
                        }
                    });
                }

                function populateEmployeeFilterOptions(serviceId) {
                    const adjustedServiceId = (serviceId === "2") ? "3" : (serviceId || '');

                    const currentValues = {
                        userName: document.getElementById('employeeUserName')?.value || "",
                        hospital: document.getElementById('employeeHospital')?.value || "",
                        shift: document.getElementById('employeeShift')?.value || "",
                        status: document.getElementById('employeeStatus')?.value || ""
                    };

                    $.ajax({
                        url: '/Index/Service/Service.aspx',
                        method: 'GET',
                        dataType: 'json',
                        data: {
                            Process: Encrypt('GETEMPLOYEEFILTEROPTIONS'),
                            serviceId: Encrypt(adjustedServiceId || '')
                        },
                        success: function (response) {
                            const data = response;
                            if (!data) return;

                            populateSelect("employeeUserName", data.userNames, currentValues.userName);
                            populateSelect("employeeHospital", data.hospitals, currentValues.hospital);
                            populateSelect("employeeShift", data.shifts, currentValues.shift);
                            populateSelect("employeeStatus", data.statuses, currentValues.status);
                        },
                        error: function () {
                            alert("Failed to load employee filter options.");
                        }
                    });
                }

                function loadEmployees(serviceId, filters = {}) {
                    const adjustedServiceId = (serviceId == 2) ? "3" : (serviceId || '');

                    const encryptedData = {
                        Process: Encrypt('GETFILTEREDEMPLOYEES'), 
                        serviceId: Encrypt(adjustedServiceId),
                        userName: Encrypt(filters.filterUserName || ''),
                        hospital: Encrypt(filters.filterHospital || ''),
                        shift: Encrypt(filters.filterShift || ''),
                        status: Encrypt(filters.filterStatus || '')
                    };

                    $.ajax({
                        url: '/Index/Service/Service.aspx',
                        method: 'GET',
                        dataType: 'json',
                        data: encryptedData,
                        success: function (response) {
                            const employees = response || [];
                            const $list = $('#employeeList');
                            $list.empty();

                            if (employees.length === 0) {
                                $list.append('<div class="text-muted">No employees found.</div>');
                                return;
                            }

                            employees.forEach(emp => {
                                let serviceLabel = 'N/A';

                                const rawServiceId = emp["eq_serviceid"];
                                if (rawServiceId) {
                                    const ids = rawServiceId.toString().split(',').map(id => id.trim());
                                    const services = ids.map(id => {
                                        switch (id) {
                                            case '1': return 'QAH';
                                            case '3': return 'R&D';
                                            default: return '';
                                        }
                                    }).filter(Boolean);

                                    if (services.length > 0) {
                                        serviceLabel = services.join(' | ');
                                    }
                                }

                                const status = (emp.status || '').toLowerCase();

                                const isCheckedOut = status === 'checked out';
                                const isOnBreak = status === 'on break';
                                const isOnMeal = status === 'on meal';
                                const isOnTask = status.startsWith('on task');

                                const disableAssignAndAssistant = isOnBreak || isOnMeal || isCheckedOut || isOnTask;
                                const disableRestBreak = isOnMeal || isOnTask || isCheckedOut;
                                const disableMealBreak = isOnBreak || isOnTask || isCheckedOut;
                                const disableCheckIn = !isCheckedOut;
                                const disableCheckOut = isCheckedOut || isOnBreak || isOnMeal || isOnTask;


                                const empDataStr = encodeURIComponent(JSON.stringify(emp));

                                const restBreakLabel = emp.status === 'On Break' ? 'End rest break' : 'Take rest break';
                                const mealBreakLabel = emp.status === 'On Meal' ? 'End meal break' : 'Take meal break';

                                const statusColor = emp.status === 'Free' ? '#196F3D' :
                                    emp.status?.startsWith('On task') ? '#A14C00' :
                                        (['On Meal', 'Checked out', 'On Break'].includes(emp.status)) ? '#666' : '#000';

                                const statusBg = emp.status === 'Free' ? '#E2F6D9' :
                                    emp.status?.startsWith('On task') ? '#FFF5E5' :
                                        (['On Meal', 'Checked out', 'On Break'].includes(emp.status)) ? '#F0F0F0' : '#EAEAEA';

                                $list.append(`
                                <div class="employee-card border rounded p-2 mb-2 shadow-sm d-flex align-items-center justify-content-between">
                                    <div class="fw-bold flex-shrink-0" style="min-width: 120px;">${emp.username || 'N/A'}</div>
                                    <div class="text-muted small d-flex align-items-center flex-grow-1 mx-3">
                                        <i class="bi bi-clock me-1"></i> ${emp.worktime || '0'}
                                        <span class="mx-3"><i class="bi bi-geo-alt-fill me-1"></i> ${emp.location || "N/A"}</span>
                                        <span class="mx-3"><i class="bi bi-person-badge me-1"></i> ${serviceLabel}</span>
                                    </div>
                                    <span>${emp.action || ''}</span>
                                    <div class="d-flex align-items-center flex-shrink-0 dropdown">
                                        <button class="btn btn-link text-muted p-0 m-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                            <i class="bi bi-three-dots fs-5"></i>
                                        </button>
                                            <ul class="dropdown-menu dropdown-menu-end">
                                                ${!isCheckedOut ? `
                                                    <li>
                                                        <a class="dropdown-item d-flex align-items-center take-rest-break ${disableRestBreak ? 'disabled-option' : ''}"
                                                           href="#" data-id="${emp.id}">
                                                            <i class="bi bi-cup-hot me-2"></i> ${restBreakLabel}
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a class="dropdown-item d-flex align-items-center take-meal-break ${disableMealBreak ? 'disabled-option' : ''}"
                                                           href="#" data-id="${emp.id}">
                                                            <i class="fas fa-utensils me-2"></i> ${mealBreakLabel}
                                                        </a>
                                                    </li>
                                                    <li>
                                                        <a class="dropdown-item d-flex align-items-center check-out ${disableCheckOut ? 'disabled-option' : ''}"
                                                           href="#" data-id="${emp.id}">
                                                            <i class="bi bi-box-arrow-right me-2"></i> Check Out
                                                        </a>
                                                    </li>
                                                ` : ''}
                                                <li>
                                                    <a class="dropdown-item d-flex align-items-center check-in ${disableCheckIn ? 'disabled-option' : ''}"
                                                       href="#" data-id="${emp.id}">
                                                        <i class="bi bi-box-arrow-in-right me-2"></i> Check In
                                                    </a>
                                                </li>
                                                <li>
                                                    <a class="dropdown-item d-flex align-items-center show-details" href="#" data-id="${emp.id}">
                                                        <i class="bi bi-journal-text me-2"></i> Show details
                                                    </a>
                                                </li>
                                            </ul>
                                        <span class="badge ms-2" style="background-color: ${statusBg}; color: ${statusColor};">${emp.status || 'N/A'}</span>
                                    </div>
                                </div>
                            `);
                            });

                            attachEmployeeEvents(employees);
                        },
                        error: function (xhr, status, error) {
                            alert("Failed to load employees: " + error);
                        }
                    });
                }

                function attachEmployeeEvents(employeeData) {
                    const $container = $('#employeeList');

                    $container.find('.show-details').off('click').on('click', function (e) {
                        e.preventDefault();
                        const id = $(this).data('id');
                        $.ajax({
                            type: "POST",
                            url: "/Index/Service/Service.aspx/GetEmployeeDetailsById",
                            data: JSON.stringify({ id: id }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (emp) {
                                const employeeData = JSON.parse(emp.d);
                                showEmployeeDetails(employeeData);
                            }
                        });
                    });

                    $container.find('.take-rest-break').off('click').on('click', function (e) {
                        e.preventDefault();
                        const porterId = $(this).data('id');

                        triggerPorterAction('TriggerPorterBreakFilter', porterId, function (message) {
                            showEmployeeActionSuccess(message);
                        });
                    });

                    $container.find('.take-meal-break').off('click').on('click', function (e) {
                        e.preventDefault();
                        const porterId = $(this).data('id');

                        triggerPorterAction('TriggerPorterMealBreakFilter', porterId, function (message) {
                            showEmployeeActionSuccess(message);
                        });
                    });


                    $container.find('.check-out').off('click').on('click', function (e) {
                        e.preventDefault();
                        const porterId = $(this).data('id');
                        const porterName = $(this).data('name') || 'Porter';

                        if (!porterId) {
                            showEmployeeActionSuccess("Invalid porter details.");
                            return;
                        }

                        triggerPorterAction('TriggerCheckOut', porterId, function (message) {
                            if (message.includes("Porter is already in Task")) {
                                showPorterWarningModal(message);
                            } else {
                                showEmployeeActionSuccess(`Porter ${porterName}: ${message}`);
                                window.RefreshAll?.();
                            }
                        });
                    });

                    $container.find('.check-in').off('click').on('click', function (e) {
                        e.preventDefault();
                        const porterId = $(this).data('id');
                        const porterName = $(this).data('name') || 'Porter';

                        if (!porterId) {
                            showEmployeeActionSuccess("Invalid porter details.");
                            return;
                        }

                        triggerPorterAction('TriggerCheckIn', porterId, function (message) {
                            showEmployeeActionSuccess(message);
                            window.RefreshAll?.();
                        });
                    });

                    function showEmployeeActionSuccess(message) {
                        const modalEl = document.getElementById('modalGenericSuccess');
                        modalEl.classList.add('level-2'); 

                        const successModal = bootstrap.Modal.getOrCreateInstance(modalEl);
                        document.getElementById('LBLGenericSuccessResult').textContent = message;

                        successModal.show();

                        setTimeout(() => {
                            successModal.hide();
                            const labelEl = document.getElementById('LBLGenericSuccessResult');
                            labelEl.textContent = '';
                            if (window.RefreshAll) window.RefreshAll();

                            setTimeout(() => modalEl.classList.remove('level-2'), 300);
                        }, 2000);
                    }

                    function showPorterWarningModal(message = "Porter is already in a task.") {
                        const modalEl = document.getElementById('porterWarningModal');
                        document.getElementById('porterWarningText').innerText = message;

                        const modal = new bootstrap.Modal(modalEl);
                        modal.show();

                        setTimeout(() => modal.hide(), 1000);
                    }

                    $container.find('.openAssignRequestModal').off('click').on('click', function (e) {
                        e.preventDefault();

                        const $btn = $(this);
                        const porterId = $(this).data('id');
                        const assignType = $btn.data('type') || 'task';
                        const serviceId = $('.services-btn-icon.active').attr('id')?.replace('divService', '') || "1";
                        const $modal = $('#assignRequestModal');
                        const $requestList = $('#pendingRequestList');

                        const modalPrimaryColor = "#1F3A93";
                        const modalSecondaryColor = "#34495E";
                        const modalTextColor = "#7F8C8D";
                        const modalStrongColor = "#2C3E50";
                        const modalBackgroundColor = "#3498DB";
                        const modalButtonHoverColor = "#2874A6";

                        $modal.data('porterid', porterId);

                        $requestList.html('<li class="list-group-item text-center text-muted">Loading...</li>');

                        const assignRequestModalEl = document.getElementById('assignRequestModal');
                        const assignRequestModal = new bootstrap.Modal(assignRequestModalEl);
                        assignRequestModal.show();

                        const processName =
                            assignType === 'assistant'
                                ? 'GetAssistantRequests'
                                : 'GetPendingTasks';

                        const encProcess = Encrypt(processName);

                        const url = `/Index/Service/Service.aspx?Process=${encodeURIComponent(encProcess)}`

                        fetch(url, {
                            method: "POST",
                            headers: { "Content-Type": "application/json; charset=utf-8" },
                            body: JSON.stringify({ serviceId })
                        })
                            .then(res => res.json())
                            .then(data => {
                                let requests = [];
                                try {
                                    requests = JSON.parse(data.d);
                                } catch (err) {
                                    console.error('Error parsing pending requests', err, data);
                                    $requestList.html('<li class="list-group-item text-danger text-center">Error parsing response</li>');
                                    return;
                                }

                                $requestList.empty();

                                if (requests.length > 0) {
                                    requests.forEach(req => {
                                        const li = document.createElement('li');
                                        li.className = 'list-group-item d-flex justify-content-between align-items-center';
                                        li.innerHTML = `
                                            <span>
                                                <span style="color: ${modalSecondaryColor}; font-weight: 600;">Task Type</span> - 
                                                <strong style="color: ${modalPrimaryColor}; font-weight: 700;">#${req.CategoryName}</strong> | 
                                                <span style="color: ${modalTextColor}; font-weight: 600;">Task ID</span> - 
                                                <strong style="color: ${modalStrongColor}; font-weight: 700;">#${req.TASKID}</strong>
                                            </span>

                                            <button class="btn btn-sm assignTaskBtn"
                                                    style="background: linear-gradient(90deg, ${modalBackgroundColor}, ${modalPrimaryColor});
                                                           color: #ffffff;
                                                           font-weight: 600;
                                                           border-radius: 5px;
                                                           border: none;
                                                           padding: 4px 12px;
                                                           transition: all 0.3s ease;"
                                                    data-taskid="${req.TASKID}" 
                                                    data-porterid="${porterId}"
                                                    onmouseover="this.style.background='linear-gradient(90deg, ${modalPrimaryColor}, ${modalButtonHoverColor})';"
                                                    onmouseout="this.style.background='linear-gradient(90deg, ${modalBackgroundColor}, ${modalPrimaryColor})';">
                                                Assign
                                            </button>
                                        `;
                                        $requestList.append(li);
                                    });
                                } else {
                                    $requestList.html('<li class="list-group-item text-center text-muted">No pending requests.</li>');
                                }
                            })
                            .catch(err => {
                                console.error('Error loading pending tasks', err);
                                $requestList.html('<li class="list-group-item text-center text-danger">Error loading requests</li>');
                            });
                    });

                    document.getElementById('btnCloseAssignModal').addEventListener('click', () => {
                        const assignRequestModalEl = document.getElementById('assignRequestModal');
                        const modal = bootstrap.Modal.getInstance(assignRequestModalEl);
                        if (modal) modal.hide();

                        setTimeout(() => {
                            const backdrop = document.querySelector('.modal-backdrop');
                            if (backdrop) {
                                backdrop.remove();
                            }
                            document.body.classList.remove('modal-open');
                            document.body.style.overflow = '';
                            document.body.style.paddingRight = '';
                        }, 10);
                    });

                    function removeBackdrop() {
                        const backdrop = document.querySelector('.modal-backdrop');
                        if (backdrop) {
                            backdrop.classList.remove('show');

                            setTimeout(() => {
                                backdrop.remove();
                            }, 300);
                        }
                    }

                    $(document).off('click', '.assignTaskBtn').on('click', '.assignTaskBtn', function (e) {
                        e.preventDefault();
                        e.stopPropagation();

                        const $btn = $(this);
                        const taskId = $btn.data('taskid');
                        const porterId = $('#assignRequestModal').data('porterid');

                        if (!taskId || !porterId) {
                            $btn.text('Assign').prop('disabled', false);
                            return;
                        }

                        $btn.text('Assigning...').prop('disabled', true);

                        const assignRequestModalEl = document.getElementById('assignRequestModal');
                        const modal = bootstrap.Modal.getInstance(assignRequestModalEl);
                        if (modal) modal.hide();

                        assignPorterToTask(taskId, porterId, $btn)
                            .then((data) => {
                                $btn.text('Assigned ✓');
                                loadEmployees();
                                setTimeout(() => $btn.text('Assign').prop('disabled', false), 2000);
                            })
                            .catch((err) => {
                                console.error('assignPorterToTask failed', err);
                                $btn.text('Assign').prop('disabled', false);
                            });
                    });

                    function assignPorterToTask(requestId, porterId, $btn) {
                        return new Promise((resolve, reject) => {
                            const UID = sessionStorage.getItem('ID');
                            if (!UID) {
                                return reject(new Error('UID missing'));
                            }

                            const encRequestId = Encrypt(requestId.toString());
                            const encPorterId = Encrypt(porterId.toString());
                            const encRequestorId = Encrypt(UID);
                            const encProcess = Encrypt('ASSIGNPORTER');

                            fetch('/Index/Service/Service.aspx?' + new URLSearchParams({
                                Process: encProcess
                            }), {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify({
                                    requestId: encRequestId,
                                    porterId: encPorterId,
                                    requestorId: encRequestorId
                                })
                            })
                                .then(res => res.text())
                                .then(text => {
                                    let data;
                                    try {
                                        data = JSON.parse(text);
                                    } catch (e) {
                                        data = { success: true, message: text };
                                    }
                                    resolve(data);
                                })
                                .catch(err => reject(err));
                        });
                    }
                    }
                
                function triggerPorterAction(processName, porterId, callback) {
                    const encProcess = Encrypt(processName);
                    const encPorterId = Encrypt(porterId.toString());

                    $.ajax({
                        url: `/Index/Service/Service.aspx?Process=${encodeURIComponent(encProcess)}`,
                        method: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        data: JSON.stringify({ id: encPorterId }),
                        dataType: 'text',
                        success: function (text) {
                            let result;
                            try {
                                result = JSON.parse(text.replace(/\[\]$/, ''));
                            } catch (e) {
                                console.error("JSON ERROR:", text);
                                callback("Response parse error");
                                return;
                            }

                            if (result.success !== false) {
                                callback(result.message || "Success");
                            } else {
                                callback("Error: " + (result.message || "Unknown error"));
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error("AJAX Error:", error);
                            callback("Network error: " + error);
                        }
                    });
                }

                $(document).ready(function () {
                    $('#openEmployeeFilterModal').on('click', function (e) {
                        e.stopPropagation();

                        const $filterPanel = $(this).siblings('.filter-panel');
                        const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                        const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';

                        if ($filterPanel.css('display') !== 'block') {
                            populateEmployeeFilterOptions(serviceId);
                        }
                        $filterPanel.toggle();
                    });

                    $('.filter-panel').on('click', function (e) {
                        e.stopPropagation();
                    });
                    $(document).on('click', function () {
                        $('.filter-panel').hide();
                    });

                    $('#employeeFilterCancel').on('click', function () {
                        $(this).closest('.filter-panel').hide();
                    });

                    $('#employeeFilterApply').on('click', function () {
                        filters.filterUserName = $('#employeeUserName').val() || "";
                        filters.filterHospital = $('#employeeHospital').val() || "";
                        filters.filterShift = $('#employeeShift').val() || "";
                        filters.filterStatus = $('#employeeStatus').val() || "";

                        const activeServiceBtn = document.querySelector('.services-btn-icon.active');
                        const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';

                        loadEmployees(serviceId, filters);

                        $(this).closest('.filter-panel').hide();
                        RestartTimer_AutoRefresh();
                    });

                    $('.clear-filters').on('click', function () {
                        const $panel = $(this).closest('.filter-panel');
                        $panel.find('select').val('');
                    });
                });

                function loadHoldReasons() {
                    const encryptedProcess = encryptAES('GetHoldReasons', cryptoKey, cryptoIV);

                    $.ajax({
                        type: "GET",
                        url: "/Index/Service/Service.aspx?Process=" + encodeURIComponent(encryptedProcess),
                        dataType: "json",
                        success: function (response) {
                            //console.log("Hold reasons response:", response);

                            var $select = $('#loadHoldReasons');
                            $select.empty();
                            $select.append('<option value="">-- Select Reason --</option>');

                            $.each(response, function (index, item) {
                                $select.append('<option value="' + item.HoldReason + '">' + item.HoldReason + '</option>');
                            });
                        },
                        error: function (xhr, status, error) {
                            console.error("Error:", error);
                        }
                    });
                }


                $('#modalTaskHold').on('show.bs.modal', function () {
                    loadHoldReasons();
                });

                function loadCancelReasons() {
                    const encryptedProcess = encryptAES('GetCancelReasons', cryptoKey, cryptoIV);
                    $.ajax({
                        type: "GET",
                        url: "/Index/Service/Service.aspx?Process=" + encodeURIComponent(encryptedProcess),
                        dataType: "json",
                        success: function (response) {
                            //console.log("Cancel reasons response:", response);

                            var $select = $('#ddlCancelReasons');
                            $select.empty();
                            $select.append('<option value="">-- Select Reason --</option>');

                            $.each(response, function (index, item) {
                                $select.append(
                                    '<option value="' + item.CancelReason + '">' +
                                    item.CancelReason +
                                    '</option>');
                            });

                            $select.css('text-transform', 'none');
                        },
                        error: function (xhr, status, error) {
                            console.error("Error loading cancel reasons:", error);
                        }
                    });
                }

                $('#modalTaskCancel').on('show.bs.modal', function () {
                    loadCancelReasons();
                });

                $(document).on('click', '.cancel-task', function (e) {
                    e.preventDefault();

                    var requestId = $(this).data('request-id');
                    //console.log("Request ID to cancel:", requestId);

                    $('#modalTaskCancel').data('request-id', requestId);

                    var modal = new bootstrap.Modal(document.getElementById('modalTaskCancel'));
                    modal.show();
                });

                function OnChangeRemarksHC(selectElem, textAreaId) {
                    var selectedValue = selectElem.value;
                    document.getElementById(textAreaId).value = selectedValue;

                    if (selectedValue !== "") {
                        document.getElementById(textAreaId).style.display = 'block';
                    } else {
                        document.getElementById(textAreaId).style.display = 'none';
                    }
                }

                function loadKPIReasons() {

                    const key = '9090909090909090';
                    const iv = '9090909090909090';

                    const processName = Encrypt('GetResponseFailuresReasons');
                    const encProcess = encryptAES(processName, key, iv);

                    $.ajax({
                        type: "GET",
                        url: `/Index/Service/Service.aspx?Process=${encodeURIComponent(processName)}`,
                        dataType: "json",
                        success: function (response) {
                            const $ddl = $('#ddlKPIReasons');
                            $ddl.empty().append('<option value="">-- Select Reason --</option>');
                            response.forEach(item => {
                                $ddl.append('<option value="' + item.ResponseFailureReason + '">' + item.ResponseFailureReason + '</option>');
                            });
                        }
                    });
                }

                $(document).ready(function () {
                    loadKPIReasons();
                });
                $(document).on('click', '#kpiModalActionBtn', function () {
                    const reason = $('#ddlKPIReasons').val();
                    if (!reason) {
                        alert('Please select a reason.');
                        return;
                    }

                    if (!currentRequestId) {
                        alert('No task selected.');
                        return;
                    }

                    const encryptedProcess = encryptAES('SetResponseFailure', cryptoKey, cryptoIV);
                    const encryptedRequestId = encryptAES(currentRequestId.toString(), cryptoKey, cryptoIV);
                    const encryptedReason = reason;

                    $.ajax({
                        type: "GET",
                        url: "/Index/Service/Service.aspx?Process=" + encodeURIComponent(encryptedProcess) +
                            "&requestId=" + encodeURIComponent(encryptedRequestId) +
                            "&reason=" + encodeURIComponent(encryptedReason),
                        dataType: "json",
                        success: function (response) {
                            if (response && response.length > 0 && response[0].success === true) {
                                $('#kpiModal').modal('hide');
                            } else {
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error('Error setting response failure:', error);
                        }
                    });
                });
                document.addEventListener("DOMContentLoaded", () => {
                    const chkPreBook = document.getElementById("chkPreBook");

                    const observer = new MutationObserver(() => {
                        const calendarWrap = document.querySelector('.custom-calendar-wrap');
                        if (calendarWrap) {
                            if (chkPreBook.checked) {
                                calendarWrap.classList.add("prebook-on");
                            } else {
                                calendarWrap.classList.remove("prebook-on");
                            }
                        }
                    });

                    observer.observe(document.body, {
                        childList: true,
                        subtree: true,
                    });

                    chkPreBook.addEventListener("change", () => {
                        const calendarWrap = document.querySelector('.custom-calendar-wrap');
                        if (calendarWrap) {
                            if (chkPreBook.checked) {
                                calendarWrap.classList.add("prebook-on");
                            } else {
                                calendarWrap.classList.remove("prebook-on");
                            }
                        }
                    });
                });

                document.addEventListener('DOMContentLoaded', () => {
                    const editTaskModalEl = document.getElementById('editTaskModal');
                    const updateBtn = document.getElementById('updateTaskBtn');
                    let currentTask = null;
                    let dropdownData = {};

                    document.addEventListener('click', async function (e) {
                        const target = e.target.closest('.edit-task');
                        if (!target) return;

                        e.preventDefault();
                        const requestId = target.getAttribute('data-request-id');
                        if (!requestId) return console.error("requestId is missing");

                        document.getElementById('taskIdDisplay').textContent = `#${requestId}`;
                        const editModal = bootstrap.Modal.getInstance(editTaskModalEl) || new bootstrap.Modal(editTaskModalEl);
                        const serviceId = document.querySelector('.services-btn-icon.active')?.id.replace('divService', '') || '';

                        const task = await loadTaskDetails(requestId, serviceId);

                        try {
                            await loadEditTaskDropdowns(serviceId);    
                            await loadTaskDetails(requestId, serviceId); 
                            document.getElementById('editRemarksText').value = '';
                            editModal.show();                   
                        } catch (err) {
                            console.error('Error loading modal data:', err);
                        }
                    });

                    function loadEditTaskDropdowns(serviceId) {
                        if (dropdownData[serviceId]?.isLoaded) {
                            populateDropdowns(dropdownData[serviceId].data);
                            return Promise.resolve();
                        }

                        return fetch('/Index/Service/Service.aspx/GetDropdownData', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json; charset=utf-8' },
                            body: JSON.stringify({ serviceId })
                        })
                            .then(res => res.json())
                            .then(data => {
                                const res = JSON.parse(data.d);
                                dropdownData[serviceId] = { isLoaded: true, data: res };
                                return populateDropdowns(res);
                            })
                            .catch(err => console.error('Error loading dropdown data:', err));
                    }

                    function populateDropdowns(res) {
                        return new Promise(resolve => {
                            function setOptions(selectId, items, textKey) {
                                const select = document.getElementById(selectId);
                                if (!select) return;

                                const placeholder = select.querySelector('option[disabled]');
                                select.innerHTML = '';
                                if (placeholder) select.appendChild(placeholder);

                                items.forEach(item => {
                                    const option = document.createElement('option');
                                    option.value = item.Id;
                                    option.textContent = item[textKey];
                                    select.appendChild(option);
                                });
                            }

                            setOptions('editCategoryName', res.categories, 'CategoryName');
                            setOptions('editEquipmentType', res.equipment, 'Name');
                            setOptions('editFromLocation', res.locations, 'ZoneName');
                            setOptions('editToLocation', res.locations, 'ZoneName');
                            setOptions('editRemarks', res.remarks, 'MESSAGE');

                            resolve(); 
                        });
                    }

                    function loadTaskDetails(requestId) {
                        const key = '9090909090909090';
                        const iv = '9090909090909090';

                        const encProcess = Encrypt('GetSingleRequestDetails');
                        const encRequestId = Encrypt(requestId);  

                        fetch(`/Index/Service/Service.aspx?Process=${encodeURIComponent(encProcess)}&requestId=${encodeURIComponent(encRequestId)}`)
                            .then(res => res.json())
                            .then(tasks => {
                                const task = tasks && tasks.length > 0 ? tasks[0] : null;
                                if (!task) return;

                                currentTask = task;

                                document.getElementById('editRequestId').value = task.REQUESTID || '';
                                setSelectValue('editCategoryName', task.CATEGORYNAME);
                                setSelectValue('editEquipmentType', task.EquipmentName || '');
                                setSelectValue('editFromLocation', task.FROM || task.FROM_LOCATION || '');
                                setSelectValue('editToLocation', task.TO || task.TO_LOCATION || '');
                                document.getElementById('editPatientName').value = task.PATIENTNAME || '';

                                if (task.REQUESTEDATE) {
                                    document.getElementById('txtReqdates').value = task.REQUESTEDATE;
                                }

                                if (task.REQUESTTIME) {
                                    document.getElementById('txtReqTimes').value = task.REQUESTTIME;
                                }

                                const remarksInput = document.getElementById('editRemarksText');
                                if (task.RequestDeskRemarks) {
                                    remarksInput.value = task.RequestDeskRemarks.split(',')
                                        .map(r => r.trim())
                                        .filter(r => r)
                                        .join(', ');
                                }
                                const remarksSelect = document.getElementById('editRemarks');
                                if (remarksSelect) {

                                    remarksSelect.selectedIndex = 0;

                                    const firstOption = remarksSelect.options[0];
                                    if (firstOption && (firstOption.value === "" || firstOption.textContent.trim() === "--Select--")) {
                                        firstOption.selected = true;
                                    }
                                }

                            })
                            .catch(err => console.error(err));
                    }

                    function getFinalRemark() {
                        const textValue = document.getElementById('editRemarksText').value.trim();
                        return textValue; 
                    }

                    const selectedRemarks = []; 

                    document.getElementById('editRemarks').addEventListener('change', function () {
                        const selectedText = this.options[this.selectedIndex].text.trim();
                        const remarksInput = document.getElementById('editRemarksText');

                        if (!selectedText) return;

                        const existingValues = remarksInput.value
                            .split(',')
                            .map(v => v.trim())
                            .filter(v => v); 

                        if (!existingValues.includes(selectedText)) {
                            existingValues.unshift(selectedText);
                            remarksInput.value = existingValues.join(', ');
                        }
                    });


                    function setSelectValue(selectId, value) {
                        const select = document.getElementById(selectId);
                        if (!select) return;
                        const option = Array.from(select.options).find(opt => opt.textContent === value);
                        if (option) select.value = option.value;
                    }

                    function getRemarksTextById(id) {
                        const select = document.getElementById('editRemarks');
                        if (!select) return '';
                        const option = Array.from(select.options).find(opt => opt.value == id);
                        return option?.text || '';
                    }

                    function encryptString(str) {
                        return btoa(unescape(encodeURIComponent(str)));
                    }

                    function encryptPayload(payload) {
                        const encrypted = {};
                        for (const key in payload) {
                            const val = payload[key] !== null && payload[key] !== undefined ? payload[key].toString() : "";
                            encrypted[key] = encryptString(val);
                        }
                        return encrypted;
                    }

                    updateBtn.addEventListener('click', function (e) {
                        e.preventDefault();
                        if (!currentTask) return;

                        const userId = parseInt(sessionStorage.getItem('ID'), 10);

                        let reqDate = document.getElementById('txtReqdates').value; 
                        let reqTime = document.getElementById('txtReqTimes').value; 

                        if (reqDate.includes('/')) {
                            const parts = reqDate.split('/'); 
                            reqDate = `${parts[1]}/${parts[0]}/${parts[2]}`; 
                        }

                        const requestDateTime = `${reqDate} ${reqTime}`; 

                        const payload = {
                            categoryId: parseInt(document.getElementById('editCategoryName').value, 10) || 0,
                            equipmentTypeId: parseInt(document.getElementById('editEquipmentType').value, 10) || 0,
                            requestLocationId: parseInt(document.getElementById('editFromLocation').value, 10) || 0,
                            destinationLocationId: parseInt(document.getElementById('editToLocation').value, 10) || 0,
                            requestDeskRemarks: getFinalRemark(),
                            //requestDeskRemarks: getRemarksTextById(document.getElementById('editRemarks').value) || '',
                            updatedBy: userId,
                            patientName: document.getElementById('editPatientName').value || '',
                            requestId: currentTask.REQUESTID,
                            requestDate: requestDateTime 
                        };

                        const encryptedUpdatePayload = encryptPayload(payload);

                        fetch('/Index/Service/Service.aspx/UpdateRequestMaster', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({ payload: encryptedUpdatePayload })
                        })
                            .then(res => res.json())
                            .then(result => {
                                if (result.success) showSuccessModal("Task Updated successfully!");
                                hideEditTaskModal();
                                showTaskSuccessModal("Task updated successfully!");
                                window.RefreshAll();
                            })
                            .catch(err => {
                                console.error(err);
                                hideEditTaskModal();
                                showTaskSuccessModal("Task updated successfully!");
                                window.RefreshAll();

                            });
                    });

                    function showTaskSuccessModal(message = "Task updated successfully!") {
                        const modalEl = document.getElementById('modalTaskEnded');
                        const messageEl = document.getElementById('LBLTaskEndedMessage');
                        if (messageEl) messageEl.textContent = message;

                        const successModal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
                        successModal.show();

                        setTimeout(() => {
                            successModal.hide();
                        }, 1500);
                    }

                    function hideEditTaskModal() {
                        const modalInstance = bootstrap.Modal.getInstance(editTaskModalEl);
                        if (modalInstance) modalInstance.hide();
                    }
                });

                document.addEventListener('DOMContentLoaded', () => {
                    const closeBtn = document.getElementById('btnCloseBulkAssignModal');
                    const bulkModalEl = document.getElementById('bulkAssignModal');

                    if (!closeBtn || !bulkModalEl) return;

                    const modalInstance = bootstrap.Modal.getOrCreateInstance(bulkModalEl);

                    closeBtn.addEventListener('click', () => {
                        modalInstance.hide();

                        const bulkList = document.getElementById('bulkRequestList');
                        if (bulkList) {
                            bulkList.innerHTML =
                                '<li class="list-group-item text-center text-muted py-3"></li>';
                        }
                    });
                });

                function AbortAllActiveRuquests() {
                    $($.xhrPool).each(function (i, jqXHR) {   //  cycle through list of recorded connection
                        jqXHR.abort();  //  aborts connection
                        $.xhrPool.splice(i, 1); //  removes from list by index
                    });
                }

                function fn_refreshAll() {
                    if (isRefreshing) return;

                    cleanupAbortControllers();
                    abortAllFetchRequests();
                    setTimeout(() => {
                        window.NewAutoRefresh();
                    }, 250);
                }

                //function RestartTimer_AutoRefresh() {

                //    const chk = document.getElementById('chkAutoRefresh');
                //    if (chk.checked) {
                //        startAutoRefresh();
                //    }
                //    else {
                //        stopAutoRefresh();
                //    }

                //}

                function fetchWithAbort(url, options = {}) {
                    const controller = new AbortController();
                    options.signal = controller.signal;
                    activeFetchControllers.push(controller);

                    return fetch(url, options)
                        .finally(() => {
                            activeFetchControllers = activeFetchControllers.filter(c => c !== controller);
                        })
                        .catch(error => {
                            if (error.name === 'AbortError') {
                            //    console.log('Fetch request was aborted');
                            } else {
                                console.error('Fetch error:', error);
                            }
                        });
                }

                function abortAllFetchRequests() {
                    activeFetchControllers.forEach(controller => {
                        controller.abort();
                    });
                    activeFetchControllers.length = 0;
                }

                (function () {
                    const MEMORY_THRESHOLD_MB = 120;
                    const FRAME_TIME_THRESHOLD_MS = 45;
                    const CLEANUP_BATCH_SIZE = 10;
                    const ACTIVITY_RESET_DELAY = 3000;
                    const CLEANUP_INTERVAL_MS = 5 * 60 * 1000;
                    const MONITOR_INTERVAL_MS = 5000;
                    const LOGGING_ENABLED = false; 

                    const cacheStore = new Map();

                    let isUserActive = false;
                    let lastMonitorTime = 0;
                    let activityTimer = null;

                    const isExpired = (entry) => entry && entry.expiry && entry.expiry < Date.now();
                    const log = (...args) => {
                        if (LOGGING_ENABLED) console.log(...args);
                    };

                    const getMemoryUsed = () => performance?.memory?.usedJSHeapSize || 0;

                    function clearCacheBatch(batchSize = CLEANUP_BATCH_SIZE) {
                        const keys = Array.from(cacheStore.keys());
                        let removed = 0;
                        let processed = 0;

                        function processBatch(deadline) {
                            const end = Math.min(processed + batchSize, keys.length);
                            for (; processed < end; processed++) {
                                const key = keys[processed];
                                const entry = cacheStore.get(key);
                                if (isExpired(entry)) {
                                    cacheStore.delete(key);
                                    removed++;
                                }
                            }
                            if (processed < keys.length) {
                                if (typeof requestIdleCallback === 'function') {
                                    requestIdleCallback(processBatch, { timeout: 1000 });
                                } else {
                                    setTimeout(processBatch, 16);
                                }
                            } else if (removed > 0) {
                                log(`[Cache Cleanup] Removed ${removed} expired items.`);
                            }
                        }

                        processBatch();
                    }

                    function runCleanup() {
                        if (!isUserActive) {
                            if (typeof requestIdleCallback === 'function') {
                                requestIdleCallback(() => clearCacheBatch(), { timeout: 2000 });
                            } else {
                                setTimeout(() => clearCacheBatch(), 2000);
                            }
                        }
                    }

                    function monitor() {
                        const now = Date.now();
                        if (now - lastMonitorTime < MONITOR_INTERVAL_MS) return;
                        lastMonitorTime = now;

                        const memoryUsed = getMemoryUsed();
  
                        log(`[Monitor] Memory: ${(memoryUsed / 1024 / 1024).toFixed(2)} MB`);

                        if (
                            !isUserActive &&
                            (memoryUsed > MEMORY_THRESHOLD_MB * 1024 * 1024)
                        ) {
                            runCleanup();
                        }
                    }

                    const markActive = () => {
                        isUserActive = true;
                        clearTimeout(activityTimer);
                        activityTimer = setTimeout(() => {
                            isUserActive = false;
                        }, ACTIVITY_RESET_DELAY);
                    };

                    ['scroll', 'mousemove', 'keydown', 'click', 'touchstart'].forEach(evt =>
                        document.addEventListener(evt, markActive, { passive: true })
                    );

                    setInterval(() => {
                        monitor();
                        runCleanup();
                    }, CLEANUP_INTERVAL_MS);

                    window.addEventListener('load', () => {
                        runCleanup();
                    });
                })();

                document.addEventListener('visibilitychange', function () {
                    if (!document.hidden) {
                        const activeBtn = document.querySelector('.services-btn-icon.active');
                        const serviceId = activeBtn ? activeBtn.id.replace('divService', '') : '';

                        const pendingList = document.getElementById('pendingList');
                        const startedList = document.getElementById('startedList');

                        if (pendingList && pendingList.children.length === 0) {
                            reloadTasks(serviceId);
                        }
                        if (startedList && startedList.children.length === 0) {
                            reloadStartedTasks(serviceId);
                        }

                        RestartTimer_AutoRefresh();
                    }
                });

            </script>
    </form>
</body>

</html>
                