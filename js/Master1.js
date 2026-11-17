//const { clearInterval } = require("timers");

var cssFilepaths = ["../css/bootstrap.min.css", "../css/sumoselect.min.css", "../css/style.css"], jsFilePaths = ["../js/style.js"];
var arrPBMW = ["chkPharmacy", "chkBProduct", "chkMedicalGases", "chkWaste"];


function getCurdateTime() {

    var d = new Date();

    var month = d.getMonth() + 1;
    var day = d.getDate(), Hour = d.getHours(), Minute = d.getMinutes();
    var time = (Hour < 10 ? '0' : '') + Hour + ':' + (Minute < 10 ? '0' : '') + Minute; // d.getHours() + ":" + d.getMinutes();// + ":" + dt.getSeconds();

    var date = d.getFullYear() + '-' + (month < 10 ? '0' : '') + month + '-' + (day < 10 ? '0' : '') + day;

    return date + '_' + time;
}

//function submitRequest() {
//    var IsEdit = ((document.getElementById('HFERID').value).length > 0);
//    if (RFromID == '0') {
//        $('#search_from').focus();
//        $('#containerFrom').css('background-color', '#ff7171'); setTimeout(function () { $('#containerFrom').css('background-color', 'white'); }, 2500);
//    }
//    else if (RToID == '0') {
//        $('#search_to').focus();
//        $('#containerTo').css('background-color', '#ff7171'); setTimeout(function () { $('#containerTo').css('background-color', 'white'); }, 2500);
//    }
//    //else if (ReqCat == '0') {
//    //    $('#containerCat').css('background-color', '#ff7171'); setTimeout(function () { $('#containerCat').css('background-color', 'white'); }, 2500);
//    //}
//    else {
//        if (IsEdit)
//            UpdateRequest();
//        else
//            InsertRequest();
//    }



//}


function LoadCSSJS() {
    $('.loaderElement').css("display", "inline-block");
    setTimeout(function () {
        $('.loaderElement').css("display", "none");
    }, 1500);
    $.each(jsFilePaths, function (index, value) {
        var queryString = value + '?reload=' + new Date().getTime();
        LoadScript(queryString);
    });

    //$.each(cssFilepaths, function (index, value) {
    //    var queryString = value + '?reload=' + new Date().getTime();
    //    LoadCSS(queryString);
    //});

}
function LoadCSS(cssURL) {
    $('head').append('<link rel="stylesheet" type="text/css" href="' + cssURL + '">');
}

function LoadScript(Path) {
    ReloadScript();
    // $.getScript(Path);
    var form = document.getElementById('formCategory');
    var script = document.createElement('script'); script.src = Path;

    setTimeout(function () { form.appendChild(script); }, 250);
}
function ReloadScript() {

    $('script').each(function () {
        if ($(this).attr('src') !== 'assets/js/jquery.min.js') {
            var old_src = $(this).attr('src');
            $(this).attr('src', '');
            setTimeout(function () { $(this).attr('src', old_src + '?' + new Date()); }, 250);
        }
    });
}
function validate(evt, ele) {
    var theEvent = evt || window.event;

    // Handle paste
    if (theEvent.type === 'paste') {
        theEvent.preventDefault();
        //key = event.clipboardData.getData('text/plain');
    } else {
        // Handle key press
        var key = theEvent.keyCode || theEvent.which;
        key = String.fromCharCode(key);
    }
    var regex = /[0-9]|\./;
    if (!regex.test(key) || $(ele).val().length > 3) {
        theEvent.returnValue = false;
        if (theEvent.preventDefault) theEvent.preventDefault();
    }
}

function changeCheck(ele) {
    var src = $(ele).attr('src'); //alert(src);
    $(ele).attr("src", (src == "../images/CNoCheck.png") ? "../images/CCheck.png" : "../images/CNoCheck.png");

}

function changeCheckPBMW(ele, process) {
    var EleID = $(ele).attr('id');
    var src = $(ele).attr('src'); //alert(src);
    //$(ele).attr("src", (src == "../images/CNoCheck.png") ? "../images/CCheck.png" : "../images/CNoCheck.png");


    $.each(arrPBMW, function (index, value) {
        var val = value.toString() + process;
        if (val == EleID)
            $('#' + val).attr("src", (src == "../images/CNoCheck.png") ? "../images/CCheck.png" : "../images/CNoCheck.png");
        else
            $('#' + val).attr("src", "../images/CNoCheck.png");

    });

}


function LoadPorters() {

    var FinalUrl = hurl + "Service/Service.aspx?Process=GETPORTERS&Search=" + encodeURIComponent(Encrypt($('#TextSearchPorter').val())) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode));
    $.ajax({
        url: FinalUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var tblContent = '', tblContent1 = '', tblContentAdd = '';

            ServiceCode = (ServiceCode == '0') ? "1" : ServiceCode;


            tblContentAdd = ' <div class="category-master-item mb-4"><div class="card card-top" > <div class="category-master-item-title"><img src="../images/Traczo.svg"><h5>PORTER </h5></div><div><div class="edit-link"><a href="javascript:void(0)" class="edit-category btn btn-tertiary d-flex justify-content-center"> ' +
                '<img src="../images/CAdd.png">Add</a></div></div></div><div class="card card-bottom"><form id="formNew" runat="server" enctype="multipart/form-data"> <div class="row align-items-center mb-4"> <div class="col-md-12" style="margin-top: 20px;">  <div class="navigation-tabs-wrapper-modal mb-0 p-0" rstyle="margin-top: 20px;"> <div class="services-button-modal"><label>Services</label></div><div class="services-tabs-wrapper-modal"  id="divServiceContainerNew"><div class="services-btn-icon-modal' + ((ServiceCode == 0 || ServiceCode == 1) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'New'" + ');" data-color="rgb(255, 116, 0)" id="divPService1New"><img src="../images/porter-icon.svg" /><span>Porter</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 3) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'New'" + ');" data-color="rgb(12, 188, 139)" id="divPService2New"><img src="../images/cater-icon.svg" /><span>Cater</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 3) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'New'" + ');" data-color="rgb(110, 48, 243)" id="divPService3New"><img src="../images/clean-icon.svg" /><span>Clean</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 4) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'New'" + ');" data-color="rgb(255, 87, 51)" id="divPService4New"><img src="../images/pest-icon.svg" /><span>Feedback</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 5) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'New'" + ');" data-color="rgb(255, 87, 51)" id="divPService5New"><img src="../images/security-icon.svg" /><span>Security</span></div></div></div></div></div><div class="row align-items-center mb-4"> <div class="col-md-4"><label>Porter Name</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtPorterNew" rows="1" class="form-control" placeholder="Category" id="txtPorterNew">  </textarea>' +
                '</div></div><div class="row align-items-center mb-4"><div class="col-md-4"><label>Image</label></div><div class="col-md-8"><input type="file" class="form-control" id="filePorterNew" ></div></div>'

                + ' <div class="row align-items-center mb-4"> <div class="col-md-4"><label>User ID</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtUserIDNew" rows="1" class="form-control" placeholder="User ID" id="txtUserIDNew"></textarea></div></div>'
                + '  <div class="row align-items-center mb-4">  <div class="col-md-4"><label>Password</label></div><div class="col-md-8"><input name="txtPasswordNew" type="password" class="form-control" placeholder="Password" id="txtPasswordNew"  placeholder="Password" value=""> </div></div>'

                + ' <div class="row align-items-center mb-4 classPorter" style="margin-top: 1.5rem !important;visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3"><label>PHARMACY</label><img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkPharmacyNew" class="MultiPorter" ></div><div class="col-md-3"><label>BLOOD PRODUCTS</label><img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkBProductNew" class="MultiPorter" ></div><div class="col-md-3"><label>MEDICAL GASES</label><img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkMedicalGasesNew" class="MultiPorter" ></div><div class="col-md-3"><label>WASTE</label><img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkWasteNew" class="MultiPorter" ></div> '

                + ' <div class="row align-items-center mb-4 " style="margin-top: 1.5rem !important;">'
                + '<div class="col-md-3 classPorter" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '" > <div class="row"><div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkSupervisorNew" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">SUPERVISOR</label> </div></div></div>'

                + '<div class="col-md-3 classPorter" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '" > <div class="row"><div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkIsheavyNew" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">HEAVY TASK</label> </div></div></div>'
                + '<div class="col-md-3 classAll" style="visibility:visible"> <div class="row"><div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkRoyalStokeNew" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">ROYAL STOKE</label> </div></div></div>'
                + '<div class="col-md-3 classAll" style="visibility:visible" > <div class="row"><div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkHaywoodNew" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">HAYWOOD</label> </div></div></div>'
                + '</div><div class="row align-items-center mb-4 classPorter" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"> <div class="col-md-3"> <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkLightTaskNew" class="MultiPorter" ></div>  <div class="col-md-8"><label style="margin-top: 22px;margin-left: 0px;"> LIGHT TASK </label> </div></div> </div>  <div class="col-md-3"> <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkSpecimenNew" class="MultiPorter" ></div>  <div class="col-md-8"><label style="margin-top: 22px;margin-left: 0px;"> SPECIMEN </label> </div></div> </div> <div class="col-md-4"> <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkDeseasedPatientNew" class="MultiPorter" ></div> <div class="col-md-8"><label style="margin-top: 22px;margin-left: 0px;"> DECEASED PATIENT </label> </div> </div> </div> </div>'

                + '<div class="row align-items-center mb-4 classCater" style="visibility:' + ((ServiceCode == 3) ? "visible" : "hidden") + '" > <div class="col-md-12">  <div class="navigation-tabs-wrapper-modal mb-0 p-0" style="margin-top: 20px;"> <div class="services-button-modal"><label>Cater Role</label></div><div class="services-tabs-wrapper-modal"  id="divKPRoleContainerNew"><div class="services-KPRole-icon-modal" onclick="KPRoleOnselect(this);" data-color="rgb(255, 116, 0)" id="divKPSUPERVISORNew"><span>KP SUPERVISOR</span></div><div class="services-KPRole-icon-modal  active" onclick="KPRoleOnselect(this);" data-color="rgb(12, 188, 139)" id="divKPNew"><span>KP</span></div><div class="services-KPRole-icon-modal" onclick="KPRoleOnselect(this);" data-color="rgb(110, 48, 243)" id="divKPMAINKITCHENNew"><span>KP MAINKITCHEN</span></div><div class="services-KPRole-icon-modal" onclick="KPRoleOnselect(this);" data-color="rgb(255, 87, 51)" id="divKPSAFFRONADMINNew"><span>KP SAFFRONADMIN</span></div><div class="services-KPRole-icon-modal" onclick="KPRoleOnselect(this);" data-color="rgb(255, 87, 51)" id="divKPRETAILNew"><span>KP RETAIL</span></div></div></div></div></div> '




                + '<div class="mb-4 d-flex justify-content-end classAll"  style="visibility:visible" ><div class="col-md-3" > <div class="row"><div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkActiveNew" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">IS ACTIVE</label> </div></div></div> <button type="button" class="btn btn-outline cancel-edit me-3"><img src="../images/multiply.svg">Cancel</button><button type="button" class="btn btn-secondary" onclick="UpdatePorterValues(' + "'New'" + ')"><img src="../images/envelope.png">Submit</button></div></form> </div></div> ';

            if (data.length > 0) {

                var Count = 0, avg = (data.length / 2);
                $.each(data, function (key, value) {

                    var USERNAME = ((!value.USERNAME) ? "" : value.USERNAME.toString()),
                        PorterID = ((!value.ID) ? "" : value.ID.toString()),
                        USERID = ((!value.USERID) ? "" : value.USERID.toString()),
                        PASSWORD = ((!value.PASSWORD) ? "" : value.PASSWORD.toString()),
                        IMAGE = ((!value.IMAGE) ? "" : value.IMAGE.toString()),
                        ISHEAVY = ((!value.HEAVYTASK) ? "" : value.HEAVYTASK.toString()),
                        IsChecked = ((!value.ISACTIVE) ? "" : value.ISACTIVE.toString()),

                        ISHAYWOOD = ((!value.ISHAYWOOD) ? "" : value.ISHAYWOOD.toString()),
                        ISROYALSTOKE = ((!value.ISROYALSTOKE) ? "" : value.ISROYALSTOKE.toString()),

                        ISPHARMACY = ((!value.ISPHARMACY) ? "" : value.ISPHARMACY.toString()),
                        ISBLOODPRODUCT = ((!value.ISBLOODPRODUCT) ? "" : value.ISBLOODPRODUCT.toString()),
                        ISMEDICALGASES = ((!value.ISMEDICALGASES) ? "" : value.ISMEDICALGASES.toString()),
                        ISWASTE = ((!value.ISWASTE) ? "" : value.ISWASTE.toString()),

                        ISLIGHTTASK = ((!value.ISLIGHTTASK) ? "" : value.ISLIGHTTASK.toString()),
                        ISSPECIMEN = ((!value.ISSPECIMEN) ? "" : value.ISSPECIMEN.toString()),
                        ISDESEASEDPATIENT = ((!value.ISDESEASEDPATIENT) ? "" : value.ISDESEASEDPATIENT.toString()),

                        KP_SUPERVISOR = ((!value.KP_SUPERVISOR) ? "0" : value.KP_SUPERVISOR.toString()),
                        KP = ((!value.KP) ? "0" : value.KP.toString()),
                        KP_MAINKITCHEN = ((!value.KP_MAINKITCHEN) ? "0" : value.KP_MAINKITCHEN.toString()),
                        KP_SAFFRONADMIN = ((!value.KP_SAFFRONADMIN) ? "0" : value.KP_SAFFRONADMIN.toString()),
                        KP_RETAIL = ((!value.KP_RETAIL) ? "0" : value.KP_RETAIL.toString()),


                        ISSUPERVISOR = ((!value.ISSUPERVISOR) ? "" : value.ISSUPERVISOR.toString());


                    if (Count > avg) {
                        tblContent1 += '  <div class="category-master-item mb-4"><div class="card card-top" > <div class="category-master-item-title"><img src="' + IMAGE + '"><h5>' + USERNAME + ' </h5></div><div><div class="edit-link"><a href="javascript:void(0)" class="edit-category btn btn-tertiary d-flex justify-content-center"> ' +
                            '<img src="../images/pencil.png">Edit</a></div></div></div><div class="card card-bottom"><form><div class="row align-items-center mb-4"> <div class="col-md-12">  <div class="navigation-tabs-wrapper-modal mb-0 p-0" style="margin-top: 20px;"> <div class="services-button-modal"><label>Services</label></div><div class="services-tabs-wrapper-modal"   id="divServiceContainer' + PorterID + '"><div class="services-btn-icon-modal' + ((ServiceCode == 0 || ServiceCode == 1) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + PorterID + "'" + ');" data-color="rgb(255, 116, 0)" id="divPService1' + PorterID + '"><img src="../images/porter-icon.svg" /><span>Porter</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 3) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + PorterID + "'" + ');" data-color="rgb(12, 188, 139)" id="divPService2' + PorterID + '"><img src="../images/cater-icon.svg" /><span>Cater</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 3) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + PorterID + "'" + ');" data-color="rgb(110, 48, 243)" id="divPService3' + PorterID + '"><img src="../images/clean-icon.svg" /><span>Clean</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 4) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + PorterID + "'" + ');" data-color="rgb(255, 87, 51)" id="divPService4' + PorterID + '"><img src="../images/pest-icon.svg" /><span>Feedback</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 5) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + PorterID + "'" + ');" data-color="rgb(255, 87, 51)" id="divPService5' + PorterID + '"><img src="../images/security-icon.svg" /><span>Security</span></div></div></div></div></div><div class="row align-items-center mb-4"><div class="col-md-4"><label>Porter Name</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtPorter' + PorterID + '" rows="1" class="form-control" placeholder="Category" id="txtPorter' + PorterID + '"> ' + USERNAME + ' </textarea>' +
                            '</div></div><div class="row align-items-center mb-4"><div class="col-md-4"><label>Image</label></div><div class="col-md-8"><img src="' + IMAGE + '"><input type="file" class="form-control" id="filePorter' + PorterID + '" ></div></div>'
                            + '<div class="row align-items-center mb-4"><div class="col-md-4"><label>User ID</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtUserID' + PorterID + '" rows="1" class="form-control" placeholder="User ID" id="txtUserID' + PorterID + '"> ' + USERID + ' </textarea></div></div>'
                            + '<div class="row align-items-center mb-4"><div class="col-md-4"><label>Password</label></div><div class="col-md-8"><input name="txtPassword' + PorterID + '" type="password" class="form-control" placeholder="Password" id="txtPassword' + PorterID + '" value="' + PASSWORD + '"> </div></div>'

                            + ' <div class="row align-items-center mb-4"  style="margin-top: 1.5rem !important;visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3"><label>PHARMACY</label><img src="../images/' + ((ISPHARMACY == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkPharmacy' + PorterID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" ></div><div class="col-md-3"><label>BLOOD PRODUCTS</label><img src="../images/' + ((ISBLOODPRODUCT == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkBProduct' + PorterID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" >'
                            + '</div><div class="col-md-3" ><label>MEDICAL GASES</label><img src="../images/' + ((ISMEDICALGASES == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkMedicalGases' + PorterID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" ></div><div class="col-md-3"><label>WASTE</label><img src="../images/' + ((ISWASTE == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkWaste' + PorterID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" ></div></div> '



                            + ' <div class="row align-items-center mb-4" style="margin-top: 1.5rem !important;">'
                            + '<div class="col-md-3" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '" > <div class="row"><div class="col-md-4"> <img src="../images/' + ((ISSUPERVISOR == "1") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkSupervisor' + PorterID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">SUPERVISOR</label> </div></div></div>'

                            + '<div class="col-md-3" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '" > <div class="row"><div class="col-md-4"> <img src="../images/' + ((ISHEAVY == "YES") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkIsheavy' + PorterID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">HEAVY TASK</label> </div></div></div>'
                            + '<div class="col-md-3" > <div class="row"><div class="col-md-4"> <img src="../images/' + ((ISROYALSTOKE == "1") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkRoyalStoke' + PorterID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">ROYAL STOKE</label> </div></div></div>'
                            + '<div class="col-md-3" > <div class="row"><div class="col-md-4"> <img src="../images/' + ((ISHAYWOOD == "1") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkHaywood' + PorterID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">HAYWOOD</label> </div></div></div>'

                            + '</div><div class="row align-items-center mb-4" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISLIGHTTASK == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkLightTask' + PorterID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;"> LIGHT TASK </label> </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISSPECIMEN == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkSpecimen' + PorterID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;">SPECIMEN</label>  </div></div> </div>  <div class="col-md-4">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISDESEASEDPATIENT == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkDeseasedPatient' + PorterID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;">DECEASED PATIENT</label>  </div></div> </div> </div>'


                            + '<div class="row align-items-center mb-4 classCater" style="visibility:' + ((ServiceCode == 3) ? "visible" : "hidden") + '" > <div class="col-md-12">  <div class="navigation-tabs-wrapper-modal mb-0 p-0" style="margin-top: 20px;"> <div class="services-button-modal"><label>Cater Role</label></div><div class="services-tabs-wrapper-modal"  id="divKPRoleContainer' + PorterID + '"><div class="services-KPRole-icon-modal' + ((KP_SUPERVISOR == 1) ? " active" : "") + '" onclick="KPRoleOnselect(this);" data-color="rgb(255, 116, 0)" id="divKPSUPERVISOR' + PorterID + '"><span>KP SUPERVISOR</span></div><div class="services-KPRole-icon-modal' + ((KP == 1) ? " active" : "") + '" onclick="KPRoleOnselect(this);" data-color="rgb(12, 188, 139)" id="divKP' + PorterID + '"><span>KP</span></div><div class="services-KPRole-icon-modal' + ((KP_MAINKITCHEN == 1) ? " active" : "") + '" onclick="KPRoleOnselect(this);" data-color="rgb(110, 48, 243)" id="divKPMAINKITCHEN' + PorterID + '"><span>KP MAINKITCHEN</span></div><div class="services-KPRole-icon-modal' + ((KP_SAFFRONADMIN == 1) ? " active" : "") + '" onclick="KPRoleOnselect(this);" data-color="rgb(255, 87, 51)" id="divKPSAFFRONADMIN' + PorterID + '"><span>KP SAFFRONADMIN</span></div><div class="services-KPRole-icon-modal' + ((KP_RETAIL == 1) ? " active" : "") + '" onclick="KPRoleOnselect(this);" data-color="rgb(255, 87, 51)" id="divKPRETAIL' + PorterID + '"><span>KP RETAIL</span></div></div></div></div></div> '
                            + '<div class="mb-4 d-flex justify-content-end"  style="visibility:visible"><div class="col-md-3" > <div class="row"><div class="col-md-4"> <img src="../images/' + ((IsChecked == "1") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkActive' + PorterID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">IS ACTIVE</label> </div></div></div><button type="button" class="btn btn-outline cancel-edit me-3"><img src="../images/multiply.svg">Cancel</button><button type="button" class="btn btn-secondary" onclick="UpdatePorterValues(' + "'" + PorterID + "'" + ')"><img src="../images/envelope.png">Submit</button></div></form> </div></div> ';
                    }
                    else {
                        tblContent += '  <div class="category-master-item mb-4"><div class="card card-top" > <div class="category-master-item-title"><img src="' + IMAGE + '"><h5>' + USERNAME + ' </h5></div><div><div class="edit-link"><a href="javascript:void(0)" class="edit-category btn btn-tertiary d-flex justify-content-center"> ' +
                            '<img src="../images/pencil.png">Edit</a></div></div></div><div class="card card-bottom"><form><div class="row align-items-center mb-4"> <div class="col-md-12">  <div class="navigation-tabs-wrapper-modal mb-0 p-0" style="margin-top: 20px;"> <div class="services-button-modal"><label>Services</label></div><div class="services-tabs-wrapper-modal"   id="divServiceContainer' + PorterID + '"><div class="services-btn-icon-modal' + ((ServiceCode == 0 || ServiceCode == 1) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + PorterID + "'" + ');" data-color="rgb(255, 116, 0)" id="divPService1' + PorterID + '"><img src="../images/porter-icon.svg" /><span>Porter</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 3) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + PorterID + "'" + ');" data-color="rgb(12, 188, 139)" id="divPService2' + PorterID + '"><img src="../images/cater-icon.svg" /><span>Cater</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 3) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + PorterID + "'" + ');" data-color="rgb(110, 48, 243)" id="divPService3' + PorterID + '"><img src="../images/clean-icon.svg" /><span>Clean</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 4) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + PorterID + "'" + ');" data-color="rgb(255, 87, 51)" id="divPService4' + PorterID + '"><img src="../images/pest-icon.svg" /><span>Feedback</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 5) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + PorterID + "'" + ');" data-color="rgb(255, 87, 51)" id="divPService5' + PorterID + '"><img src="../images/security-icon.svg" /><span>Security</span></div></div></div></div></div><div class="row align-items-center mb-4"><div class="col-md-4"><label>Porter Name</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtPorter' + PorterID + '" rows="1" class="form-control" placeholder="Category" id="txtPorter' + PorterID + '"> ' + USERNAME + ' </textarea>' +
                            '</div></div><div class="row align-items-center mb-4"><div class="col-md-4"><label>Image</label></div><div class="col-md-8"><img src="' + IMAGE + '"><input type="file" class="form-control" id="filePorter' + PorterID + '" ></div></div>'
                            + '<div class="row align-items-center mb-4"><div class="col-md-4"><label>User ID</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtUserID' + PorterID + '" rows="1" class="form-control" placeholder="User ID" id="txtUserID' + PorterID + '"> ' + USERID + ' </textarea></div></div>'
                            + '<div class="row align-items-center mb-4"><div class="col-md-4"><label>Password</label></div><div class="col-md-8"><input name="txtPassword' + PorterID + '" type="password" class="form-control" placeholder="Password" id="txtPassword' + PorterID + '" value="' + PASSWORD + '"> </div></div>'

                            + ' <div class="row align-items-center mb-4"  style="margin-top: 1.5rem !important;visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3"><label>PHARMACY</label><img src="../images/' + ((ISPHARMACY == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkPharmacy' + PorterID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" ></div><div class="col-md-3"><label>BLOOD PRODUCTS</label><img src="../images/' + ((ISBLOODPRODUCT == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkBProduct' + PorterID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" >'
                            + '</div><div class="col-md-3"><label>MEDICAL GASES</label><img src="../images/' + ((ISMEDICALGASES == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkMedicalGases' + PorterID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" ></div><div class="col-md-3"><label>WASTE</label><img src="../images/' + ((ISWASTE == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkWaste' + PorterID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" ></div></div> '



                            + ' <div class="row align-items-center mb-4" style="margin-top: 1.5rem !important;">'
                            + '<div class="col-md-3"  style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"> <div class="row"><div class="col-md-4"> <img src="../images/' + ((ISSUPERVISOR == "1") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkSupervisor' + PorterID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">SUPERVISOR</label> </div></div></div>'

                            + '<div class="col-md-3" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '" > <div class="row"><div class="col-md-4"> <img src="../images/' + ((ISHEAVY == "YES") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkIsheavy' + PorterID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">HEAVY TASK</label> </div></div></div>'
                            + '<div class="col-md-3" style="visibility:visible"> <div class="row"><div class="col-md-4"> <img src="../images/' + ((ISROYALSTOKE == "1") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkRoyalStoke' + PorterID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">ROYAL STOKE</label> </div></div></div>'
                            + '<div class="col-md-3" style="visibility:visible" > <div class="row"><div class="col-md-4"> <img src="../images/' + ((ISHAYWOOD == "1") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkHaywood' + PorterID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">HAYWOOD</label> </div></div></div>'

                            + '</div><div class="row align-items-center mb-4"  style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISLIGHTTASK == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkLightTask' + PorterID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;"> LIGHT TASK </label> </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISSPECIMEN == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkSpecimen' + PorterID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;">SPECIMEN</label>  </div></div> </div>  <div class="col-md-4">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISDESEASEDPATIENT == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkDeseasedPatient' + PorterID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;">DECEASED PATIENT</label>  </div></div> </div> </div>'

                            + '<div class="row align-items-center mb-4 classCater" style="visibility:' + ((ServiceCode == 3) ? "visible" : "hidden") + '" > <div class="col-md-12">  <div class="navigation-tabs-wrapper-modal mb-0 p-0" style="margin-top: 20px;"> <div class="services-button-modal"><label>Cater Role</label></div><div class="services-tabs-wrapper-modal"  id="divKPRoleContainer' + PorterID + '"><div class="services-KPRole-icon-modal' + ((KP_SUPERVISOR == 1) ? " active" : "") + '" onclick="KPRoleOnselect(this);" data-color="rgb(255, 116, 0)" id="divKPSUPERVISOR' + PorterID + '"><span>KP SUPERVISOR</span></div><div class="services-KPRole-icon-modal' + ((KP == 1) ? " active" : "") + '" onclick="KPRoleOnselect(this);" data-color="rgb(12, 188, 139)" id="divKP' + PorterID + '"><span>KP</span></div><div class="services-KPRole-icon-modal' + ((KP_MAINKITCHEN == 1) ? " active" : "") + '" onclick="KPRoleOnselect(this);" data-color="rgb(110, 48, 243)" id="divKPMAINKITCHEN' + PorterID + '"><span>KP MAINKITCHEN</span></div><div class="services-KPRole-icon-modal' + ((KP_SAFFRONADMIN == 1) ? " active" : "") + '" onclick="KPRoleOnselect(this);" data-color="rgb(255, 87, 51)" id="divKPSAFFRONADMIN' + PorterID + '"><span>KP SAFFRONADMIN</span></div><div class="services-KPRole-icon-modal' + ((KP_RETAIL == 1) ? " active" : "") + '" onclick="KPRoleOnselect(this);" data-color="rgb(255, 87, 51)" id="divKPRETAIL' + PorterID + '"><span>KP RETAIL</span></div></div></div></div></div> '
                            + '<div class="mb-4 d-flex justify-content-end"  style="visibility:visible"><div class="col-md-3" > <div class="row"><div class="col-md-4"> <img src="../images/' + ((IsChecked == "1") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkActive' + PorterID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">IS ACTIVE</label> </div></div></div><button type="button" class="btn btn-outline cancel-edit me-3"><img src="../images/multiply.svg">Cancel</button><button type="button" class="btn btn-secondary" onclick="UpdatePorterValues(' + "'" + PorterID + "'" + ')"><img src="../images/envelope.png">Submit</button></div></form> </div></div> ';
                    }
                    Count += 1;

                });


            }
            $('#catItems_left').html(tblContent); $('#catItems_right').html(tblContent1); $('#DivAddCategory').html(tblContentAdd);
        },
        error: function (data) {

        }

    });
    LoadCSSJS();
}



function loadLocations() {
    var FinalUrl = hurl + "Service/Service.aspx?Process=GETPORTERS";
    $.ajax({
        url: FinalUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var tblContent = '', tblContent1 = '', tblContentAdd = '';

            tblContentAdd = ' <div class="category-master-item mb-4"><div class="card card-top" > <div class="category-master-item-title"><img src="../images/Traczo.svg"><h5>LOCATION </h5></div><div><div class="edit-link"><a href="javascript:void(0)" class="edit-category btn btn-tertiary d-flex justify-content-center"> ' +
                '<img src="../images/CAdd.png">Add</a></div></div></div><div class="card card-bottom"><form id="formNew" runat="server" enctype="multipart/form-data"><div class="row align-items-center mb-4"> <div class="col-md-4"><label>Porter Name</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtPorterNew" rows="1" class="form-control" placeholder="Category" id="txtPorterNew">  </textarea>' +
                '</div></div><div class="row align-items-center mb-4"><div class="col-md-4"><label>Image</label></div><div class="col-md-8"><input type="file" class="form-control" id="filePorterNew" ></div></div>'

                + ' <div class="row align-items-center mb-4"> <div class="col-md-4"><label>User ID</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtUserIDNew" rows="1" class="form-control" placeholder="User ID" id="txtUserIDNew"></textarea></div></div>'
                + '  <div class="row align-items-center mb-4">  <div class="col-md-4"><label>Password</label></div><div class="col-md-8"><input name="txtPasswordNew" type="password" class="form-control" placeholder="Password" id="txtPasswordNew"  placeholder="Password" value=""> </div></div>'

                + ' <div class="row align-items-center mb-4"><div class="col-md-6"  style="padding-left: 100px;margin-top: 20px;"><label>IS HEAVY</label><img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkIsheavyNew" class="MultiPorter" ></div> '


                + '<div class="col-md-6"  style="padding-left: 100px;margin-top: 20px;"><label>IS ACTIVE</label><img src="../images/CCheck.png" onclick="changeCheck(this);" width="30px" id="chkActiveNew" class="MultiPorter" ></div></div>'

                + '<div class="mb-4 d-flex justify-content-end"><button type="button" class="btn btn-outline cancel-edit me-3"><img src="../images/multiply.svg">Cancel</button><button type="button" class="btn btn-secondary" onclick="UpdatePorterValues(' + "'New'" + ')"><img src="../images/envelope.png">Submit</button></div></form> </div></div> ';

            if (data.length > 0) {

                var Count = 0, avg = (data.length / 2);
                $.each(data, function (key, value) {

                    var USERNAME = ((!value.USERNAME) ? "" : value.USERNAME.toString()),
                        PorterID = ((!value.ID) ? "" : value.ID.toString()),
                        USERID = ((!value.USERID) ? "" : value.USERID.toString()),
                        PASSWORD = ((!value.PASSWORD) ? "" : value.PASSWORD.toString()),
                        IMAGE = ((!value.IMAGE) ? "" : value.IMAGE.toString()),
                        ISHEAVY = ((!value.HEAVYTASK) ? "" : value.HEAVYTASK.toString()),
                        IsChecked = ((!value.ISACTIVE) ? "" : value.ISACTIVE.toString());

                    if (Count > avg) {
                        tblContent1 += '  <div class="category-master-item mb-4"><div class="card card-top" > <div class="category-master-item-title"><img src="' + IMAGE + '"><h5>' + USERNAME + ' </h5></div><div><div class="edit-link"><a href="javascript:void(0)" class="edit-category btn btn-tertiary d-flex justify-content-center"> ' +
                            '<img src="../images/pencil.png">Edit</a></div></div></div><div class="card card-bottom"><form><div class="row align-items-center mb-4"><div class="col-md-4"><label>Porter Name</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtPorter' + PorterID + '" rows="1" class="form-control" placeholder="Category" id="txtPorter' + PorterID + '"> ' + USERNAME + ' </textarea>' +
                            '</div></div><div class="row align-items-center mb-4"><div class="col-md-4"><label>Image</label></div><div class="col-md-8"><img src="' + IMAGE + '"><input type="file" class="form-control" id="filePorter' + PorterID + '" ></div></div>'
                            + '<div class="row align-items-center mb-4"><div class="col-md-4"><label>User ID</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtUserID' + PorterID + '" rows="1" class="form-control" placeholder="User ID" id="txtUserID' + PorterID + '"> ' + USERID + ' </textarea></div></div>'
                            + '<div class="row align-items-center mb-4"><div class="col-md-4"><label>Password</label></div><div class="col-md-8"><input name="txtPassword' + PorterID + '" type="password" class="form-control" placeholder="Password" id="txtPassword' + PorterID + '" value="' + PASSWORD + '"> </div></div>'

                            + ' <div class="row align-items-center mb-4"><div class="col-md-6"  style="padding-left: 100px;margin-top: 20px;"><label>IS HEAVY</label><img src="../images/' + ((ISHEAVY == "YES") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkIsheavy' + PorterID + '" class="MultiPorter" ></div> '
                            + '<div class="col-md-6"  style="padding-left: 100px;margin-top: 20px;"><label>IS ACTIVE</label><img src="../images/' + (IsChecked == "true" ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkActive' + PorterID + '" class="MultiPorter" ></div></div>'

                            + '<div class="mb-4 d-flex justify-content-end"><button type="button" class="btn btn-outline cancel-edit me-3"><img src="../images/multiply.svg">Cancel</button><button type="button" class="btn btn-secondary" onclick="UpdatePorterValues(' + "'" + PorterID + "'" + ')"><img src="../images/envelope.png">Submit</button></div></form> </div></div> ';
                    }
                    else {
                        tblContent += '  <div class="category-master-item mb-4"><div class="card card-top" > <div class="category-master-item-title"><img src="' + IMAGE + '"><h5>' + USERNAME + ' </h5></div><div><div class="edit-link"><a href="javascript:void(0)" class="edit-category btn btn-tertiary d-flex justify-content-center"> ' +
                            '<img src="../images/pencil.png">Edit</a></div></div></div><div class="card card-bottom"><form><div class="row align-items-center mb-4"><div class="col-md-4"><label>Porter Name</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtPorter' + PorterID + '" rows="1" class="form-control" placeholder="Category" id="txtPorter' + PorterID + '"> ' + USERNAME + ' </textarea>' +
                            '</div></div><div class="row align-items-center mb-4"><div class="col-md-4"><label>Image</label></div><div class="col-md-8"><img src="' + IMAGE + '"><input type="file" class="form-control" id="filePorter' + PorterID + '" ></div></div>'
                            + '<div class="row align-items-center mb-4"><div class="col-md-4"><label>User ID</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtUserID' + PorterID + '" rows="1" class="form-control" placeholder="User ID" id="txtUserID' + PorterID + '"> ' + USERID + ' </textarea></div></div>'
                            + '<div class="row align-items-center mb-4"><div class="col-md-4"><label>Password</label></div><div class="col-md-8"><input name="txtPassword' + PorterID + '" type="password" class="form-control" placeholder="Password" id="txtPassword' + PorterID + '" value="' + PASSWORD + '"> </div></div>'

                            + ' <div class="row align-items-center mb-4"><div class="col-md-6"  style="padding-left: 100px;margin-top: 20px;"><label>IS HEAVY</label><img src="../images/' + ((ISHEAVY == "YES") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkIsheavy' + PorterID + '" class="MultiPorter" ></div> '
                            + '<div class="col-md-6"  style="padding-left: 100px;margin-top: 20px;"><label>IS ACTIVE</label><img src="../images/' + (IsChecked == "true" ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkActive' + PorterID + '" class="MultiPorter" ></div></div>'

                            + '<div class="mb-4 d-flex justify-content-end"><button type="button" class="btn btn-outline cancel-edit me-3"><img src="../images/multiply.svg">Cancel</button><button type="button" class="btn btn-secondary" onclick="UpdatePorterValues(' + "'" + PorterID + "'" + ')"><img src="../images/envelope.png">Submit</button></div></form> </div></div> ';
                    }
                    Count += 1;

                });


            }
            $('#catItems_left').html(tblContent); $('#catItems_right').html(tblContent1); $('#DivAddCategory').html(tblContentAdd);
        },
        error: function (data) {

        }

    });
    LoadCSSJS();
}



function LoadCategory() {

    var searchVal = $('#TextSearchCatogory').val();
    var FinalUrl = hurl + "Service/Service.aspx?Process=GETCATEGORY&SEARCH=" + encodeURIComponent(Encrypt(searchVal)) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode));;
    $.ajax({
        url: FinalUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {


            ServiceCode = (ServiceCode == '0') ? "1" : ServiceCode;

            var tblContent = '', tblContent1 = '', tblContentAdd = '';

            tblContentAdd = ' <div class="category-master-item mb-4"><div class="card card-top" > <div class="category-master-item-title"><img src="../images/Traczo.svg"><h5>TYPE</h5></div><div><div class="edit-link"><a href="javascript:void(0)" class="edit-category btn btn-tertiary d-flex justify-content-center"> ' +
                '<img src="../images/CAdd.png">Add</a></div></div></div><div class="card card-bottom"><form id="formNew" runat="server" enctype="multipart/form-data"><div class="row align-items-center mb-4"> <div class="col-md-12" style="margin-top: 20px;">  <div class="navigation-tabs-wrapper-modal mb-0 p-0" rstyle="margin-top: 20px;"> <div class="services-button-modal"><label>Services</label></div><div class="services-tabs-wrapper-modal"  id="divServiceContainerNew"><div class="services-btn-icon-modal' + ((ServiceCode == 0 || ServiceCode == 1) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'New'" + ');" data-color="rgb(255, 116, 0)" id="divPService1New"><img src="../images/porter-icon.svg" /><span>Porter</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 3) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'New'" + ');" data-color="rgb(12, 188, 139)" id="divPService2New"><img src="../images/cater-icon.svg" /><span>Cater</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 3) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'New'" + ');" data-color="rgb(110, 48, 243)" id="divPService3New"><img src="../images/clean-icon.svg" /><span>Clean</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 4) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'New'" + ');" data-color="rgb(255, 87, 51)" id="divPService4New"><img src="../images/pest-icon.svg" /><span>Feedback</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 5) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'New'" + ');" data-color="rgb(255, 87, 51)" id="divPService5New"><img src="../images/security-icon.svg" /><span>Security</span></div></div></div></div></div><div class="row align-items-center mb-4"> <div class="col-md-4"><label>Type Name</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtCategoryNew" rows="1" class="form-control" placeholder="Category" id="txtCategoryNew">  </textarea>' +
                '</div></div><div class="row align-items-center mb-4"><div class="col-md-4"><label>Image</label></div><div class="col-md-8"><input type="file" class="form-control" id="fileCategoryNew" ></div></div> <div class="row align-items-center mb-4 classCater" style="visibility:' + ((ServiceCode != '3') ? "hidden" : "visible") + '"><div class="col-md-4"><label>Charge Group</label></div><div class="col-md-8"><select name="selectFloor" id="search_CatChargeGroupAdd" tabindex="1" class="form-control search_test search_CatChargeGroup"><option value="Non-chargable" selected>Non-chargable</option><option value="Cooked BreakFast">Cooked BreakFast</option><option value="Cultural Requisitions">Cultural Requisitions</option><option value="Gluten Free Requisitions">Gluten Free Requisitions</option><option value="Kosher Requisitions">Kosher Requisitions</option><option value="Renal/Low Potassium Requisitions">Renal/Low Potassium Requisitions</option><option value="Snack Boxes">Snack Boxes</option><option value="Requisitions-Normal via Patient Services">Requisitions-Normal via Patient Services</option></select></div></div><div class="row align-items-center mb-4"><div class="col-md-4"><label>ALLOCATION(KPI)</label><textarea  maxlength="50" name="txtTATNew" rows="1" class="form-control" placeholder="Category" id="txtTATNew" onkeypress="validate(event,this)">10 </textarea>' +
                '</div><div class="col-md-4"><label>Response (KPI)</label><textarea  maxlength="50" name="txtTSNew" rows="1" class="form-control" id="txtTSNew" onkeypress="validate(event,this)">5 </textarea> </div><div class="col-md-4"><label>Completion (KPI)</label><textarea  maxlength="50" name="txtTENew" rows="1" class="form-control" placeholder="Category" id="txtTENew" onkeypress="validate(event,this)">5 </textarea></div></div>'
                + ' <div class="row align-items-center mb-4 classPorter" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3"><label>QUANTITY</label><img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkPriorityNew" class="MultiPorter" ></div><div class="col-md-3"><label>ROUTINE</label><img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkRoutineNew" class="MultiPorter" >' + '</div><div class="col-md-3"><label>PORTERING</label><img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkNormalTaskNew" class="MultiPorter" ></div><div class="col-md-3"><label>IS HEAVY</label><img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkIsheavyNew" class="MultiPorter" ></div> ' +

                ' <div class="row align-items-center mb-4 classPorter" style="margin-top: 1.5rem !important;visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3"><label>PHARMACY</label><img src="../images/CNoCheck.png" onclick="changeCheckPBMW(this,' + "'New'" + ');" width="30px" id="chkPharmacyNew" class="MultiPorter" ></div><div class="col-md-3"><label>BLOOD PRODUCTS</label><img src="../images/CNoCheck.png"  onclick="changeCheckPBMW(this,' + "'New'" + ');" width="30px" id="chkBProductNew" class="MultiPorter" ></div><div class="col-md-3"><label>MEDICAL GASES</label><img src="../images/CNoCheck.png" onclick="changeCheckPBMW(this,' + "'New'" + ');" width="30px" id="chkMedicalGasesNew" class="MultiPorter" ></div><div class="col-md-3"><label>WASTE</label><img src="../images/CNoCheck.png"  onclick="changeCheckPBMW(this,' + "'New'" + ');" width="30px" id="chkWasteNew" class="MultiPorter" ></div> ' +
                '</div><div class="row align-items-center mb-4 classPorter" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"> <div class="col-md-3"> <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkRoyalStokeNew" class="MultiPorter" ></div>  <div class="col-md-8"><label style="margin-top: 22px;margin-left: 0px;"> ROYAL STOKE </label> </div></div> </div>  <div class="col-md-3"> <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkHaywoodNew" class="MultiPorter" ></div>  <div class="col-md-8"><label style="margin-top: 22px;margin-left: 0px;"> HAYWOOD </label> </div></div> </div> <div class="col-md-3"> <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkTwoPorterNew" class="MultiPorter" ></div> <div class="col-md-8"><label style="margin-top: 22px;margin-left: 0px;"> 2 PORTERS </label> </div> </div> </div> <div class="col-md-3"> <div class="row"><div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkNoPINew" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;"> NO PI</label> </div></div></div></div>' +
                '</div><div class="row align-items-center mb-4 classPorter" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"> <div class="col-md-3"> <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkLightTaskNew" class="MultiPorter" ></div>  <div class="col-md-8"><label style="margin-top: 22px;margin-left: 0px;"> LIGHT TASK </label> </div></div> </div>  <div class="col-md-3"> <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkSpecimenNew" class="MultiPorter" ></div>  <div class="col-md-8"><label style="margin-top: 22px;margin-left: 0px;"> SPECIMEN </label> </div></div> </div> <div class="col-md-4"> <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkDeseasedPatientNew" class="MultiPorter" ></div> <div class="col-md-8"><label style="margin-top: 22px;margin-left: 0px;"> DECEASED PATIENT </label> </div> </div> </div> </div>' +

                '<div class="row align-items-center mb-4 classCater" style="visibility:' + ((ServiceCode == 3) ? "visible" : "hidden") + ';margin-top:-250px;"><div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" id="chkISPHOTOREQUIREDNew" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">IS PHOTO REQUIRED</label> </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" id="chkISSIGNREQUIREDNew" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">IS SIGN. REQUIRED</label>  </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" id="chkISROUTINETASKNew" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">ROUTINE TASK</label>  </div></div> </div> <div class="col-md-3"> <div class="row"> <div class="col-md-4">  <img src="../images/CNoCheck.png" id="chkKPNoPINew" onclick="changeCheck(this);" width="30px"  class="MultiPorter"  ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 33px;">NO PI</label> </div></div></div></div>' +
                '<div class="row align-items-center mb-4 classCater" style="visibility:' + ((ServiceCode == 3) ? "visible" : "hidden") + ';"><div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" id="chkKPNew" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">KP </label> </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" id="chkKP_MAINKITCHENNew" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">KP MAIN KITCHEN</label>  </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/CNoCheck.png" id="chkKP_SUPERVISORNew" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">KP SUPERVISOR</label>  </div></div> </div> <div class="col-md-3"> <div class="row"> <div class="col-md-4">  <img src="../images/CNoCheck.png" id="chkKP_SAFFRONADMINNew" onclick="changeCheck(this);" width="30px"  class="MultiPorter"  ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 33px;">KP SAFFRON ADMIN</label> </div></div></div></div>' +

                '<div class="mb-4 d-flex justify-content-end" style="margin-top: 100px;"> <div class="col-md-3 classCater" style="visibility:' + ((ServiceCode == 3) ? "visible" : "hidden") + '"> <div class="row"><div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkKP_RETAILNew" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">KP RETAIL</label> </div></div></div> <div class="col-md-3 classPorter"  style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"> <div class="row"><div class="col-md-4"> <img src="../images/CNoCheck.png" onclick="changeCheck(this);" width="30px" id="chkSupervisorNew" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">SUPERVISOR</label> </div></div></div> <div class="col-md-3 classAll"> <div class="row"><div class="col-md-4"> <img src="../images/CCheck.png" onclick="changeCheck(this);" width="30px" id="chkActiveNew" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">IS ACTIVE</label> </div></div></div> <button type="button" class="btn btn-outline cancel-edit me-3"><img src="../images/multiply.svg">Cancel</button><button type="button" class="btn btn-secondary" onclick="updateCatValues(' + "'New'" + ')"><img src="../images/envelope.png">Submit</button></div></form> </div></div> ';

            if (data.length > 0) {

                var Count = 0, splitlimit = (data.length / 2);
                $.each(data, function (key, value) {

                    var CATEGORYNAME = ((!value.CATEGORYNAME) ? "" : value.CATEGORYNAME.toString()),
                        CategoryID = ((!value.ID) ? "" : value.ID.toString()),
                        CategoryImage = ((!value.IMAGE) ? "" : value.IMAGE.toString()),
                        CATTAT = ((!value.CATTAT) ? "" : value.CATTAT.toString()),
                        THRESHOLDFORSTARTTIME = ((!value.THRESHOLDFORSTARTTIME) ? "" : value.THRESHOLDFORSTARTTIME.toString()),
                        THRESHOLDFORENDTIME = ((!value.THRESHOLDFORENDTIME) ? "" : value.THRESHOLDFORENDTIME.toString()),
                        CATPRIORITY = ((!value.CATPRIORITY) ? "" : value.CATPRIORITY.toString()),
                        ISROUTINETASK = ((!value.ISROUTINETASK) ? "" : value.ISROUTINETASK.toString()),
                        ISNORMALTASK = ((!value.ISNORMALTASK) ? "" : value.ISNORMALTASK.toString()),
                        ISHEAVY = ((!value.ISHEAVY) ? "" : value.ISHEAVY.toString()),
                        ISTWOPORTERTASK = ((!value.ISTWOPORTERTASK) ? "" : value.ISTWOPORTERTASK.toString()),
                        ISHAYWOOD = ((!value.ISHAYWOOD) ? "" : value.ISHAYWOOD.toString()),
                        ISROYALSTOKE = ((!value.ISROYALSTOKE) ? "" : value.ISROYALSTOKE.toString()),
                        ISNOPL = ((!value.ISNOPL) ? "" : value.ISNOPL.toString()),

                        ISPHARMACY = ((!value.ISPHARMACY) ? "" : value.ISPHARMACY.toString()),
                        ISBLOODPRODUCT = ((!value.ISBLOODPRODUCT) ? "" : value.ISBLOODPRODUCT.toString()),
                        ISMEDICALGASES = ((!value.ISMEDICALGASES) ? "" : value.ISMEDICALGASES.toString()),
                        ISWASTE = ((!value.ISWASTE) ? "" : value.ISWASTE.toString()),
                        ISSUPERVISOR = ((!value.ISSUPERVISOR) ? "" : value.ISSUPERVISOR.toString()),


                        KP_SUPERVISOR = ((!value.KP_SUPERVISOR) ? "0" : value.KP_SUPERVISOR.toString()),
                        KP = ((!value.KP) ? "0" : value.KP.toString()),
                        KP_MAINKITCHEN = ((!value.KP_MAINKITCHEN) ? "0" : value.KP_MAINKITCHEN.toString()),
                        KP_SAFFRONADMIN = ((!value.KP_SAFFRONADMIN) ? "0" : value.KP_SAFFRONADMIN.toString()),
                        KP_RETAIL = ((!value.KP_RETAIL) ? "0" : value.KP_RETAIL.toString()),

                        ISPHOTOREQUIRED = ((!value.ISPHOTOREQUIRED) ? "0" : value.ISPHOTOREQUIRED.toString()),
                        ISSIGNREQUIRED = ((!value.ISSIGNREQUIRED) ? "0" : value.ISSIGNREQUIRED.toString()),

                        CHARGEGROUP = ((!value.CHARGEGROUP) ? "" : value.CHARGEGROUP.toString()),
                        ISLIGHTTASK = ((!value.ISLIGHTTASK) ? "" : value.ISLIGHTTASK.toString()),
                        ISSPECIMEN = ((!value.ISSPECIMEN) ? "" : value.ISSPECIMEN.toString()),
                        ISDESEASEDPATIENT = ((!value.ISDESEASEDPATIENT) ? "" : value.ISDESEASEDPATIENT.toString()),

                        IsChecked = ((!value.ISACTIVE) ? "" : value.ISACTIVE.toString());

                    if (Count > splitlimit) {
                        tblContent1 += '  <div class="category-master-item mb-4"><div class="card card-top" > <div class="category-master-item-title"><img src="' + CategoryImage + '"><h5>' + CATEGORYNAME + ' </h5></div><div><div class="edit-link"><a href="javascript:void(0)" class="edit-category btn btn-tertiary d-flex justify-content-center"> ' +
                            '<img src="../images/pencil.png">Edit</a></div></div></div><div class="card card-bottom"><form><div class="row align-items-center mb-4"> <div class="col-md-12">  <div class="navigation-tabs-wrapper-modal mb-0 p-0" style="margin-top: 20px;"> <div class="services-button-modal"><label>Services</label></div><div class="services-tabs-wrapper-modal"   id="divServiceContainer' + CategoryID + '"><div class="services-btn-icon-modal' + ((ServiceCode == 0 || ServiceCode == 1) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + CategoryID + "'" + ');" data-color="rgb(255, 116, 0)" id="divPService1' + CategoryID + '"><img src="../images/porter-icon.svg" /><span>Porter</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 3) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + CategoryID + "'" + ');" data-color="rgb(12, 188, 139)" id="divPService2' + CategoryID + '"><img src="../images/cater-icon.svg" /><span>Cater</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 3) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + CategoryID + "'" + ');" data-color="rgb(110, 48, 243)" id="divPService3' + CategoryID + '"><img src="../images/clean-icon.svg" /><span>Clean</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 4) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + CategoryID + "'" + ');" data-color="rgb(255, 87, 51)" id="divPService4' + CategoryID + '"><img src="../images/pest-icon.svg" /><span>Feedback</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 5) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + CategoryID + "'" + ');" data-color="rgb(255, 87, 51)" id="divPService5' + CategoryID + '"><img src="../images/security-icon.svg" /><span>Security</span></div></div></div></div></div><div class="row align-items-center mb-4"><div class="col-md-4"><label>Type Name</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtCategory' + CategoryID + '" rows="1" class="form-control" placeholder="Category" id="txtCategory' + CategoryID + '"> ' + CATEGORYNAME + ' </textarea>' +
                            '</div></div><div class="row align-items-center mb-4"><div class="col-md-4"><label>Image</label></div><div class="col-md-8"><img src="' + CategoryImage + '"><input type="file" class="form-control" id="fileCategory' + CategoryID + '" ></div></div><div class="row align-items-center mb-4 classCater" style="visibility:' + ((ServiceCode != '3') ? "hidden" : "visible") + '"><div class="col-md-4"><label>Charge Group</label></div><div class="col-md-8"><select name="selectFloor" id="search_CatChargeGroup' + CategoryID + '" tabindex="1" class="form-control search_test search_CatChargeGroup"><option value="Non-chargable" ' + ((CHARGEGROUP == 'Non-chargable') ? "selected" : "") + '>Non-chargable</option><option value="Cooked BreakFast" ' + ((CHARGEGROUP == 'Cooked BreakFast') ? "selected" : "") + '>Cooked BreakFast</option><option value="Cultural Requisitions" ' + ((CHARGEGROUP == 'Cultural Requisitions') ? "selected" : "") + '>Cultural Requisitions</option><option value="Gluten Free Requisitions" ' + ((CHARGEGROUP == 'Gluten Free Requisitions') ? "selected" : "") + '>Gluten Free Requisitions</option><option value="Kosher Requisitions" ' + ((CHARGEGROUP == 'Kosher Requisitions') ? "selected" : "") + '>Kosher Requisitions</option><option value="Renal/Low Potassium Requisitions" ' + ((CHARGEGROUP == 'Renal/Low Potassium Requisitions') ? "selected" : "") + '>Renal/Low Potassium Requisitions</option><option value="Snack Boxes" ' + ((CHARGEGROUP == 'Snack Boxes') ? "selected" : "") + '>Snack Boxes</option><option value="Requisitions-Normal via Patient Services" ' + ((CHARGEGROUP == 'Requisitions-Normal via Patient Services') ? "selected" : "") + '>Requisitions-Normal via Patient Services</option></select></div></div> <div class="row align-items-center mb-4"><div class="col-md-4"><label>ALLOCATION(KPI)</label><textarea  maxlength="50" name="txtTAT' + CategoryID + '" rows="1" class="form-control" placeholder="Category" id="txtTAT' + CategoryID + '"> ' + CATTAT + '</textarea>' +
                            '</div><div class="col-md-4"><label>Response (KPI)</label><textarea  maxlength="50" name="txtTS' + CategoryID + '" rows="1" class="form-control" placeholder="Category" id="txtTS' + CategoryID + '"> ' + THRESHOLDFORSTARTTIME + '</textarea> </div><div class="col-md-4"><label>Completion (KPI)</label><textarea  maxlength="50" name="txtTE' + CategoryID + '" rows="1" class="form-control" placeholder="Category" id="txtTE' + CategoryID + '">' + THRESHOLDFORENDTIME + ' </textarea></div></div>'
                            + ' <div class="row align-items-center mb-4" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3"><label>QUANTITY</label><img src="../images/' + ((CATPRIORITY == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkPriority' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" ></div><div class="col-md-3"><label>ROUTINE</label><img src="../images/' + ((ISROUTINETASK == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkRoutine' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" >' +
                            '</div><div class="col-md-3"><label>PORTERING</label><img src="../images/' + ((ISNORMALTASK == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkNormalTask' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" ></div><div class="col-md-3"><label>IS HEAVY</label><img src="../images/' + ((ISHEAVY == "YES") ? "CCheck" : "CNoCheck") + '.png" id="chkIsheavy' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" ></div> ' +

                            ' <div class="row align-items-center mb-4"  style="margin-top: 1.5rem !important;visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3"><label>PHARMACY</label><img src="../images/' + ((ISPHARMACY == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkPharmacy' + CategoryID + '" onclick="changeCheckPBMW(this,' + "'" + CategoryID + "'" + ');" width="30px"  class="MultiPorter" ></div><div class="col-md-3"><label>BLOOD PRODUCTS</label><img src="../images/' + ((ISBLOODPRODUCT == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkBProduct' + CategoryID + '" onclick="changeCheckPBMW(this,' + "'" + CategoryID + "'" + ');" width="30px"  class="MultiPorter" >' +
                            '</div><div class="col-md-3"><label>MEDICAL GASES</label><img src="../images/' + ((ISMEDICALGASES == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkMedicalGases' + CategoryID + '" onclick="changeCheckPBMW(this,' + "'" + CategoryID + "'" + ');" width="30px"  class="MultiPorter" ></div><div class="col-md-3"><label>WASTE</label><img src="../images/' + ((ISWASTE == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkWaste' + CategoryID + '" onclick="changeCheckPBMW(this,' + "'" + CategoryID + "'" + ');" width="30px"  class="MultiPorter" ></div> ' +

                            '</div><div class="row align-items-center mb-4" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISROYALSTOKE == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkRoyalStoke' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;">ROYAL STOKE</label> </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISHAYWOOD == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkHaywood' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;">HAYWOOD</label>  </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISTWOPORTERTASK == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkTwoPorter' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;">2 PORTERS</label>  </div></div> </div> <div class="col-md-3"> <div class="row"> <div class="col-md-4">  <img src="../images/' + ((ISNOPL == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkNoPI' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter"  ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 33px;">NO PI</label> </div></div></div></div>' +
                            '</div><div class="row align-items-center mb-4" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISLIGHTTASK == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkLightTask' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;"> LIGHT TASK </label> </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISSPECIMEN == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkSpecimen' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;">SPECIMEN</label>  </div></div> </div>  <div class="col-md-4">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISDESEASEDPATIENT == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkDeseasedPatient' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;">DECEASED PATIENT</label>  </div></div> </div> </div>' +

                            '<div class="row align-items-center mb-4" style="visibility:' + ((ServiceCode == 3) ? "visible" : "hidden") + ';margin-top: -250px;"><div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISPHOTOREQUIRED == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkISPHOTOREQUIRED' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">IS PHOTO REQUIRED</label> </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISSIGNREQUIRED == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkISSIGNREQUIRED' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">IS SIGN. REQUIRED</label>  </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISROUTINETASK == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkISROUTINETASK' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">ROUTINE TASK</label>  </div></div> </div> <div class="col-md-3"> <div class="row"> <div class="col-md-4">  <img src="../images/' + ((ISNOPL == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkKPNoPI' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter"  ></div> <div class="col-md-8"> <label style="margin-top: 11px;margin-left: 20px;">NO PI</label> </div></div></div></div>' +
                            '<div class="row align-items-center mb-4" style="visibility:' + ((ServiceCode == 3) ? "visible" : "hidden") + ';"><div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((KP == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkKP' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">KP </label> </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((KP_MAINKITCHEN == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkKP_MAINKITCHEN' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">KP MAIN KITCHEN</label>  </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((KP_SUPERVISOR == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkKP_SUPERVISOR' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">KP SUPERVISOR</label>  </div></div> </div> <div class="col-md-3"> <div class="row"> <div class="col-md-4">  <img src="../images/' + ((KP_SAFFRONADMIN == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkKP_SAFFRONADMIN' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter"  ></div> <div class="col-md-8"> <label style="margin-top: 11px;margin-left: 20px;">KP SAFFRON ADMIN</label> </div></div></div></div>' +

                            '<div class="mb-4 d-flex justify-content-end" style="margin-top: 100px;"> <div class="col-md-3" style="visibility:' + ((ServiceCode == 3) ? "visible" : "hidden") + '"> <div class="row"><div class="col-md-4"> <img src="../images/' + ((KP_RETAIL == "1") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkKP_RETAIL' + CategoryID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">KP RETAIL</label> </div></div></div> <div class="col-md-3" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '" > <div class="row"><div class="col-md-4"> <img src="../images/' + ((ISSUPERVISOR == "1") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkSupervisor' + CategoryID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">SUPERVISOR</label> </div></div></div> <div class="col-md-3"> <div class="row"><div class="col-md-4"> <img src="../images/' + ((IsChecked == "true") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkActive' + CategoryID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">IS ACTIVE</label> </div></div></div> <button type="button" class="btn btn-outline cancel-edit me-3"><img src="../images/multiply.svg">Cancel</button><button type="button" class="btn btn-secondary" onclick="updateCatValues(' + "'" + CategoryID + "'" + ')"><img src="../images/envelope.png">Submit</button></form> </div></div></div></div> ';
                    }
                    else {
                        tblContent += '  <div class="category-master-item mb-4"><div class="card card-top" > <div class="category-master-item-title"><img src="' + CategoryImage + '"><h5>' + CATEGORYNAME + ' </h5></div><div><div class="edit-link"><a href="javascript:void(0)" class="edit-category btn btn-tertiary d-flex justify-content-center"> ' +
                            '<img src="../images/pencil.png">Edit</a></div></div></div><div class="card card-bottom"><form><div class="row align-items-center mb-4"> <div class="col-md-12">  <div class="navigation-tabs-wrapper-modal mb-0 p-0" style="margin-top: 20px;"> <div class="services-button-modal"><label>Services</label></div><div class="services-tabs-wrapper-modal"   id="divServiceContainer' + CategoryID + '"><div class="services-btn-icon-modal' + ((ServiceCode == 0 || ServiceCode == 1) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + CategoryID + "'" + ');" data-color="rgb(255, 116, 0)" id="divPService1' + CategoryID + '"><img src="../images/porter-icon.svg" /><span>Porter</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 3) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + CategoryID + "'" + ');" data-color="rgb(12, 188, 139)" id="divPService2' + CategoryID + '"><img src="../images/cater-icon.svg" /><span>Cater</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 3) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + CategoryID + "'" + ');" data-color="rgb(110, 48, 243)" id="divPService3' + CategoryID + '"><img src="../images/clean-icon.svg" /><span>Clean</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 4) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + CategoryID + "'" + ');" data-color="rgb(255, 87, 51)" id="divPService4' + CategoryID + '"><img src="../images/pest-icon.svg" /><span>Feedback</span></div><div class="services-btn-icon-modal' + ((ServiceCode == 5) ? " active" : "") + '" onclick="serviceOnselect(this,' + "'" + CategoryID + "'" + ');" data-color="rgb(255, 87, 51)" id="divPService5' + CategoryID + '"><img src="../images/security-icon.svg" /><span>Security</span></div></div></div></div></div><div class="row align-items-center mb-4"><div class="col-md-4"><label>Type Name</label></div><div class="col-md-8"><textarea  maxlength="50" name="txtCategory' + CategoryID + '" rows="1" class="form-control" placeholder="Category" id="txtCategory' + CategoryID + '"> ' + CATEGORYNAME + ' </textarea>' +
                            '</div></div><div class="row align-items-center mb-4"><div class="col-md-4"><label>Image</label></div><div class="col-md-8"><img src="' + CategoryImage + '"><input type="file" class="form-control" id="fileCategory' + CategoryID + '" ></div></div><div class="row align-items-center mb-4 classCater" style="visibility:' + ((ServiceCode != '3') ? "hidden" : "visible") + '"><div class="col-md-4"><label>Charge Group</label></div><div class="col-md-8"><select name="selectFloor" id="search_CatChargeGroup' + CategoryID + '" tabindex="1" class="form-control search_test search_CatChargeGroup"><option value="Non-chargable" ' + ((CHARGEGROUP == 'Non-chargable') ? "selected" : "") + '>Non-chargable</option><option value="Cooked BreakFast" ' + ((CHARGEGROUP == 'Cooked BreakFast') ? "selected" : "") + '>Cooked BreakFast</option><option value="Cultural Requisitions" ' + ((CHARGEGROUP == 'Cultural Requisitions') ? "selected" : "") + '>Cultural Requisitions</option><option value="Gluten Free Requisitions" ' + ((CHARGEGROUP == 'Gluten Free Requisitions') ? "selected" : "") + '>Gluten Free Requisitions</option><option value="Kosher Requisitions" ' + ((CHARGEGROUP == 'Kosher Requisitions') ? "selected" : "") + '>Kosher Requisitions</option><option value="Renal/Low Potassium Requisitions" ' + ((CHARGEGROUP == 'Renal/Low Potassium Requisitions') ? "selected" : "") + '>Renal/Low Potassium Requisitions</option><option value="Snack Boxes" ' + ((CHARGEGROUP == 'Snack Boxes') ? "selected" : "") + '>Snack Boxes</option><option value="Requisitions-Normal via Patient Services" ' + ((CHARGEGROUP == 'Requisitions-Normal via Patient Services') ? "selected" : "") + '>Requisitions-Normal via Patient Services</option></select></div></div> <div class="row align-items-center mb-4"><div class="col-md-4"><label>ALLOCATION(KPI)</label><textarea  maxlength="50" name="txtTAT' + CategoryID + '" rows="1" class="form-control" placeholder="Category" id="txtTAT' + CategoryID + '"> ' + CATTAT + '</textarea>' +
                            '</div><div class="col-md-4"><label>Response (KPI)</label><textarea  maxlength="50" name="txtTS' + CategoryID + '" rows="1" class="form-control" placeholder="Category" id="txtTS' + CategoryID + '"> ' + THRESHOLDFORSTARTTIME + '</textarea> </div><div class="col-md-4"><label>Completion (KPI)</label><textarea  maxlength="50" name="txtTE' + CategoryID + '" rows="1" class="form-control" placeholder="Category" id="txtTE' + CategoryID + '">' + THRESHOLDFORENDTIME + ' </textarea></div></div>'
                            + ' <div class="row align-items-center mb-4" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3"><label>QUANTITY</label><img src="../images/' + ((CATPRIORITY == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkPriority' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" ></div><div class="col-md-3"><label>ROUTINE</label><img src="../images/' + ((ISROUTINETASK == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkRoutine' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" >' +
                            '</div><div class="col-md-3"><label>PORTERING</label><img src="../images/' + ((ISNORMALTASK == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkNormalTask' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" ></div><div class="col-md-3"><label>IS HEAVY</label><img src="../images/' + ((ISHEAVY == "YES") ? "CCheck" : "CNoCheck") + '.png" id="chkIsheavy' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" ></div> ' +

                            ' <div class="row align-items-center mb-4"  style="margin-top: 1.5rem !important;visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3"><label>PHARMACY</label><img src="../images/' + ((ISPHARMACY == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkPharmacy' + CategoryID + '" onclick="changeCheckPBMW(this,' + "'" + CategoryID + "'" + ');" width="30px"  class="MultiPorter" ></div><div class="col-md-3"><label>BLOOD PRODUCTS</label><img src="../images/' + ((ISBLOODPRODUCT == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkBProduct' + CategoryID + '" onclick="changeCheckPBMW(this,' + "'" + CategoryID + "'" + ');" width="30px"  class="MultiPorter" >' +
                            '</div><div class="col-md-3"><label>MEDICAL GASES</label><img src="../images/' + ((ISMEDICALGASES == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkMedicalGases' + CategoryID + '" onclick="changeCheckPBMW(this,' + "'" + CategoryID + "'" + ');" width="30px"  class="MultiPorter" ></div><div class="col-md-3"><label>WASTE</label><img src="../images/' + ((ISWASTE == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkWaste' + CategoryID + '" onclick="changeCheckPBMW(this,' + "'" + CategoryID + "'" + ');" width="30px"  class="MultiPorter" ></div> ' +

                            '</div><div class="row align-items-center mb-4" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISROYALSTOKE == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkRoyalStoke' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;">ROYAL STOKE</label> </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISHAYWOOD == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkHaywood' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;">HAYWOOD</label>  </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISTWOPORTERTASK == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkTwoPorter' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;">2 PORTERS</label>  </div></div> </div> <div class="col-md-3"> <div class="row"> <div class="col-md-4">  <img src="../images/' + ((ISNOPL == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkNoPI' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter"  ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 33px;">NO PI</label> </div></div></div></div>' +
                            '</div><div class="row align-items-center mb-4" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"><div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISLIGHTTASK == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkLightTask' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;"> LIGHT TASK </label> </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISSPECIMEN == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkSpecimen' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;">SPECIMEN</label>  </div></div> </div>  <div class="col-md-4">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISDESEASEDPATIENT == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkDeseasedPatient' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 22px;margin-left: 0px;">DECEASED PATIENT</label>  </div></div> </div> </div>' +

                            '<div class="row align-items-center mb-4" style="visibility:' + ((ServiceCode == 3) ? "visible" : "hidden") + ';margin-top: -250px;"><div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISPHOTOREQUIRED == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkISPHOTOREQUIRED' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">IS PHOTO REQUIRED</label> </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISSIGNREQUIRED == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkISSIGNREQUIRED' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">IS SIGN. REQUIRED</label>  </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((ISROUTINETASK == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkISROUTINETASK' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">ROUTINE TASK</label>  </div></div> </div> <div class="col-md-3"> <div class="row"> <div class="col-md-4">  <img src="../images/' + ((ISNOPL == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkKPNoPI' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter"  ></div> <div class="col-md-8"> <label style="margin-top: 11px;margin-left: 20px;">NO PI</label> </div></div></div></div>' +
                            '<div class="row align-items-center mb-4" style="visibility:' + ((ServiceCode == 3) ? "visible" : "hidden") + ';"><div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((KP == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkKP' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">KP </label> </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((KP_MAINKITCHEN == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkKP_MAINKITCHEN' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">KP MAIN KITCHEN</label>  </div></div> </div>  <div class="col-md-3">  <div class="row"> <div class="col-md-4"> <img src="../images/' + ((KP_SUPERVISOR == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkKP_SUPERVISOR' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter" > </div>  <div class="col-md-8">  <label style="margin-top: 11px;margin-left: 0px;">KP SUPERVISOR</label>  </div></div> </div> <div class="col-md-3"> <div class="row"> <div class="col-md-4">  <img src="../images/' + ((KP_SAFFRONADMIN == "1") ? "CCheck" : "CNoCheck") + '.png" id="chkKP_SAFFRONADMIN' + CategoryID + '" onclick="changeCheck(this);" width="30px"  class="MultiPorter"  ></div> <div class="col-md-8"> <label style="margin-top: 11px;margin-left: 20px;">KP SAFFRON ADMIN</label> </div></div></div></div>' +

                            '<div class="mb-4 d-flex justify-content-end" style="margin-top: 100px;">  <div class="col-md-3" style="visibility:' + ((ServiceCode == 3) ? "visible" : "hidden") + '"> <div class="row"><div class="col-md-4"> <img src="../images/' + ((KP_RETAIL == "1") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkKP_RETAIL' + CategoryID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">KP RETAIL</label> </div></div></div><div class="col-md-3" style="visibility:' + ((ServiceCode == 3) ? "hidden" : "visible") + '"> <div class="row"><div class="col-md-4"> <img src="../images/' + ((ISSUPERVISOR == "1") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkSupervisor' + CategoryID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">SUPERVISOR</label> </div></div></div> <div class="col-md-3"> <div class="row"><div class="col-md-4"> <img src="../images/' + ((IsChecked == "true") ? "CCheck" : "CNoCheck") + '.png" onclick="changeCheck(this);" width="30px" id="chkActive' + CategoryID + '" class="MultiPorter" ></div> <div class="col-md-8"> <label style="margin-top: 22px;margin-left: 0px;">IS ACTIVE</label> </div></div></div> <button type="button" class="btn btn-outline cancel-edit me-3"><img src="../images/multiply.svg">Cancel</button><button type="button" class="btn btn-secondary" onclick="updateCatValues(' + "'" + CategoryID + "'" + ')"><img src="../images/envelope.png">Submit</button></form> </div></div></div></div> ';
                    }
                    Count += 1;

                });


            }
            $('#catItems_left').html(tblContent); $('#catItems_right').html(tblContent1); $('#DivAddCategory').html(tblContentAdd);
        },
        error: function (data) {

        }

    });
    LoadCSSJS();
}

function getActiveRoleEleID(DivID, ClassName, PorterID) {
    var ele = $('#' + DivID).find('.' + ClassName + '.active');
    return $(ele).attr('id').replace(PorterID, "");
}
function UpdatePorterValues(process) {
    var IsHeavySrc = $('#chkIsheavy' + process).attr('src'),
        IsActiveSrc = $('#chkActive' + process).attr('src'), IsPharmacySrc = $('#chkPharmacy' + process).attr('src'),
        IsBProductSrc = $('#chkBProduct' + process).attr('src'), IsMedicalGasesSrc = $('#chkMedicalGases' + process).attr('src'),
        IsHaywoodSrc = $('#chkHaywood' + process).attr('src'), IsRoyalSrc = $('#chkRoyalStoke' + process).attr('src'),
        IsWasteSrc = $('#chkWaste' + process).attr('src'), IsSupervisorSrc = $('#chkSupervisor' + process).attr('src'),
        ServiceCode = getActiveRoleEleID("divServiceContainer" + process, "services-btn-icon-modal", process);
    var ServiceID = ServiceCode.replace("divPService", "");
    var KPRole = (ServiceID == '2') ? getActiveRoleEleID("divKPRoleContainer" + process, "services-KPRole-icon-modal", process) : "";
    var KPMK = (KPRole == 'divKPMAINKITCHEN') ? '1' : '0',
        KP = (KPRole == 'divKP') ? '1' : '0',
        KPS = (KPRole == 'divKPSUPERVISOR') ? '1' : '0',
        KPR = (KPRole == 'divKPRETAIL') ? '1' : '0',
        KPSA = (KPRole == 'divKPSAFFRONADMIN') ? '1' : '0';

    IsLightTaskSrc = $('#chkLightTask' + process).attr('src'), IsSpecimenSrc = $('#chkSpecimen' + process).attr('src'),
        IsDeseasedPatientSrc = $('#chkDeseasedPatient' + process).attr('src');

    var PorterName = $('#txtPorter' + process).val(),
        UserID = $('#txtUserID' + process).val(),
        Password = $('#txtPassword' + process).val(),
        IsHeavy = ((IsHeavySrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsActive = ((IsActiveSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsPharmacy = ((IsPharmacySrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsBloodProduct = ((IsBProductSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsMedicalgas = ((IsMedicalGasesSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsWaste = ((IsWasteSrc == '../images/CNoCheck.png') ? '0' : '1'),

        IsHaywood = ((IsHaywoodSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsRoyalStoke = ((IsRoyalSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsSupervisor = ((IsSupervisorSrc == '../images/CNoCheck.png') ? '0' : '1'),

        IsLightTask = ((IsLightTaskSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsSpecimen = ((IsSpecimenSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsDeseasedPatient = ((IsDeseasedPatientSrc == '../images/CNoCheck.png') ? '0' : '1');

    if (PorterName.trim().length > 0 && UserID.trim().length > 0 && Password.trim().length > 0) {
        $('.loaderElement').css("display", "inline-block");

        $.ajax({
            async: true,
            url: hurl + 'Service/Service.aspx?Process=UPDATEPORTER&PORTERNAME=' + encodeURIComponent(Encrypt(PorterName)) + '&ID=' + encodeURIComponent(Encrypt(process)) + '&USERID=' + encodeURIComponent(Encrypt(UserID)) + '&PASSWORD=' + encodeURIComponent(Encrypt(Password))
                + '&HEAVY=' + encodeURIComponent(Encrypt(IsHeavy)) + '&ISACTIVE=' + encodeURIComponent(Encrypt(IsActive)) + '&PHARMACY=' + encodeURIComponent(Encrypt(IsPharmacy)) + '&BLOODPRODUCT=' + encodeURIComponent(Encrypt(IsBloodProduct)) + '&MEDICALGAS=' + encodeURIComponent(Encrypt(IsMedicalgas))
                + '&WASTE=' + encodeURIComponent(Encrypt(IsWaste)) + '&SUPERVISOR=' + encodeURIComponent(Encrypt(IsSupervisor)) + '&HAYWOOD=' + encodeURIComponent(Encrypt(IsHaywood)) + '&ROYALSTOKE=' + encodeURIComponent(Encrypt(IsRoyalStoke)) + '&SPECIMEN=' + encodeURIComponent(Encrypt(IsSpecimen)) + '&LIGHTTASK=' + encodeURIComponent(Encrypt(IsLightTask))
                + '&DESEASEDPATIENT=' + encodeURIComponent(Encrypt(IsDeseasedPatient)) + '&KPMK=' + encodeURIComponent(Encrypt(KPMK)) + '&KP=' + encodeURIComponent(Encrypt(KP))
                + '&KPS=' + encodeURIComponent(Encrypt(KPS)) + '&KPR=' + encodeURIComponent(Encrypt(KPR)) + '&KPSA=' + encodeURIComponent(Encrypt(KPSA)) + '&ServiceID=' + encodeURIComponent(Encrypt(ServiceID)),
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {

                if (data[0].RESULT.split("_")[0] === 'TRUE') {
                    LoadPorters(); $('.loaderElement').css("display", "none");
                    ShowModalPopUp('modalSuccess');

                } else {
                    ShowModalPopUp('modalAlert');
                }
                setTimeout(function () { $('.loaderElement').css("display", "none"); HideModalPopUp('modalSuccess'); HideModalPopUp('modalAlert'); }, 1000);

            },
            error: function (data) {

            }

        });
    } else {
        if (PorterName.trim().length == 0)
            $('#txtPorter' + process).focus();
        else if (UserID.trim().length == 0)
            $('#txtUserID' + process).focus();
        else if (Password.trim().length > 0)
            $('#txtPassword' + process).focus();
    }


}


function updateCatValues(process) {
    var srcPriority = $('#chkPriority' + process).attr('src'), IsRoutinesrc = $('#chkRoutine' + process).attr('src'),
        PorterSrc = $('#chkNormalTask' + process).attr('src'), IsHeavySrc = $('#chkIsheavy' + process).attr('src'),
        IsActiveSrc = $('#chkActive' + process).attr('src'), IsTwoPorter = $('#chkTwoPorter' + process).attr('src'),
        IsHaywoodSrc = $('#chkHaywood' + process).attr('src'), IsRoyalSrc = $('#chkRoyalStoke' + process).attr('src'),
        NoPISrc = $('#chkNoPI' + process).attr('src'), IsPharmacySrc = $('#chkPharmacy' + process).attr('src'),
        IsBProductSrc = $('#chkBProduct' + process).attr('src'), IsMedicalGasesSrc = $('#chkMedicalGases' + process).attr('src'),
        IsWasteSrc = $('#chkWaste' + process).attr('src'), IsSupervisorSrc = $('#chkSupervisor' + process).attr('src'),

        IsLightTaskSrc = $('#chkLightTask' + process).attr('src'), IsSpecimenSrc = $('#chkSpecimen' + process).attr('src'),

        IsSignSrc = $('#chkISSIGNREQUIRED' + process).attr('src'), IsPhotoSrc = $('#chkISPHOTOREQUIRED' + process).attr('src'),
        IsKPSrc = $('#chkKP' + process).attr('src'), IsKPMainSrc = $('#chkKP_MAINKITCHEN' + process).attr('src'),
        IsKPSupervisorSrc = $('#chkKP_SUPERVISOR' + process).attr('src'), IsKPSASrc = $('#chkKP_SAFFRONADMIN' + process).attr('src'),
        IsKPRetailSrc = $('#chkKP_RETAIL' + process).attr('src'), IsKPRoutineSrc = $('#chkISROUTINETASK' + process).attr('src'),
        IsKPNoPISrc = $('#chkKPNoPI' + process).attr('src'),
        ServiceCode = getActiveRoleEleID("divServiceContainer" + process, "services-btn-icon-modal", process),
        searchChargeGroup = $('#search_CatChargeGroup' + process).val(),
        IsDeseasedPatientSrc = $('#chkDeseasedPatient' + process).attr('src');

    var ServiceID = ServiceCode.replace("divPService", "");

    var CatName = $('#txtCategory' + process).val().trim(),
        TAT = $('#txtTAT' + process).val().trim(),
        ThresStart = $('#txtTS' + process).val().trim(),
        ThresEnd = $('#txtTE' + process).val().trim(),
        IsPriority = ((srcPriority == '../images/CNoCheck.png') ? '0' : '1'),
        IsRoutine = ((((ServiceID == '2') ? IsKPRoutineSrc : IsRoutinesrc) == '../images/CNoCheck.png') ? '0' : '1'),
        IsPorterTask = ((PorterSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsHeavy = ((IsHeavySrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsHaywood = ((IsHaywoodSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsActive = ((IsActiveSrc == '../images/CNoCheck.png') ? '0' : '1'),
        TwoPorter = ((IsTwoPorter == '../images/CNoCheck.png') ? '0' : '1'),
        IsRoyalStoke = ((IsRoyalSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsNoPI = ((((ServiceID == '2') ? IsKPNoPISrc : NoPISrc) == '../images/CNoCheck.png') ? '0' : '1'),

        IsPharmacy = ((IsPharmacySrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsBloodProduct = ((IsBProductSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsMedicalgas = ((IsMedicalGasesSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsWaste = ((IsWasteSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsSupervisor = ((IsSupervisorSrc == '../images/CNoCheck.png') ? '0' : '1'),


        IsSign = ((IsSignSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsPhoto = ((IsPhotoSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsKP = ((IsKPSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsKPMain = ((IsKPMainSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsKPSupervisor = ((IsKPSupervisorSrc == '../images/CNoCheck.png') ? '0' : '1'),

        IsKPSA = ((IsKPSASrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsKPRetail = ((IsKPRetailSrc == '../images/CNoCheck.png') ? '0' : '1'),

        IsLightTask = ((IsLightTaskSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsSpecimen = ((IsSpecimenSrc == '../images/CNoCheck.png') ? '0' : '1'),
        IsDeseasedPatient = ((IsDeseasedPatientSrc == '../images/CNoCheck.png') ? '0' : '1');

    if (CatName.trim().length > 0) {
        $('.loaderElement').css("display", "inline-block");

        $.ajax({
            async: true,
            url: hurl + 'Service/Service.aspx?Process=UPDATECATEGORY&CATEGORY=' + encodeURIComponent(Encrypt(CatName)) + '&ID=' + encodeURIComponent(Encrypt(process)) + '&TAT=' + encodeURIComponent(Encrypt(TAT)) + '&THSTART=' + encodeURIComponent(Encrypt(ThresStart))
                + '&THEND=' + encodeURIComponent(Encrypt(ThresEnd)) + '&PRIORITY=' + encodeURIComponent(Encrypt(IsPriority)) + '&ROUTINE=' + encodeURIComponent(Encrypt(IsRoutine)) + '&PORTERTASK=' + encodeURIComponent(Encrypt(IsPorterTask)) +
                '&HEAVY=' + encodeURIComponent(Encrypt(IsHeavy)) + '&ISACTIVE=' + encodeURIComponent(Encrypt(IsActive)) + '&TWOPORTER=' + encodeURIComponent(Encrypt(TwoPorter)) + '&HAYWOOD=' + encodeURIComponent(Encrypt(IsHaywood)) + '&ROYALSTOKE='
                + encodeURIComponent(Encrypt(IsRoyalStoke)) + '&NOPI=' + encodeURIComponent(Encrypt(IsNoPI)) + '&PHARMACY=' + encodeURIComponent(Encrypt(IsPharmacy)) + '&BLOODPRODUCT=' + encodeURIComponent(Encrypt(IsBloodProduct)) + '&MEDICALGAS='
                + encodeURIComponent(Encrypt(IsMedicalgas)) + '&WASTE=' + encodeURIComponent(Encrypt(IsWaste)) + '&SUPERVISOR=' + encodeURIComponent(Encrypt(IsSupervisor)) + '&SPECIMEN=' + encodeURIComponent(Encrypt(IsSpecimen)) + '&LIGHTTASK=' + encodeURIComponent(Encrypt(IsLightTask))
                + '&DESEASEDPATIENT=' + encodeURIComponent(Encrypt(IsDeseasedPatient)) + '&KPMK=' + encodeURIComponent(Encrypt(IsKPMain)) + '&KP=' + encodeURIComponent(Encrypt(IsKP)) + '&CHARGEGROUP=' + encodeURIComponent(Encrypt(searchChargeGroup))
                + '&KPS=' + encodeURIComponent(Encrypt(IsKPSupervisor)) + '&KPR=' + encodeURIComponent(Encrypt(IsKPRetail)) + '&KPSA=' + encodeURIComponent(Encrypt(IsKPSA)) + '&ServiceID=' + encodeURIComponent(Encrypt(ServiceID))
                + '&ISSIGN=' + encodeURIComponent(Encrypt(IsSign)) + '&ISPHOTO=' + encodeURIComponent(Encrypt(IsPhoto)),
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {

                if (data[0].RESULT.split("_")[0] === 'TRUE') {
                    LoadCategory(); $('.loaderElement').css("display", "none");
                    ShowModalPopUp('modalSuccess');

                } else {
                    ShowModalPopUp('modalAlert');
                }
                setTimeout(function () { $('.loaderElement').css("display", "none"); HideModalPopUp('modalSuccess'); HideModalPopUp('modalAlert'); }, 1000);

            },
            error: function (data) {

            }

        });
    } else {
        $('#txtCategory' + process).focus();
        $('#txtCategory').css('background-color', '#ff7171'); setTimeout(function () { $('#txtCategory').css('background-color', 'white'); }, 2500);
    }


}



function updateRoutine(Id, Column) {

    $('.loaderElement').css("display", "inline-block");

    $.ajax({
        async: true,
        url: hurl + "Service/Service.aspx?Process=UPDATEROUTINE&ID=" + Id + '&COLUMN=' + Column,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            if (data[0].RESULT.split("_")[0] === 'TRUE') {
                LoadTasks();

                setTimeout(function () { $('.loaderElement').css("display", "none"); }, 1000);
            }

        },
        error: function (data) {

        }

    });

}

//function InsertRequest() {
//    AbortAllActiveRuquests();
//    var UID = sessionStorage.getItem('ID');
//    var PBDTime = (RPreBook == '1') ? formatDate('txtReqdate', 'txtReqTime') : '';
//    var dlRemarkval = $('#search_Remarks').val(), dlRemarkTxt = selectedText('search_Remarks');
//    var PatientName = $('#txtPatientName').val(), PatientHN = $('#txtPatientHNO').val(), PatientDOB = $('#txtPatientDOB').val(), ContactNo = $('#txtContactNumber').val(),
//        Remarks = dlRemarkTxt + '_' + $('#txtRemarks').val();
//    var ReqtrName = $('#txtRequestorName').val().trim();
//    var qty = $('#txtQty').val();

//    $.ajax({
//        async: true,
//        url: hurl + "SERVICE/Service.aspx?Process=INSERTREQUEST&PBDATE=" + encodeURIComponent(Encrypt(PBDTime)) + "&CATEGORY=" + encodeURIComponent(Encrypt(ReqCat)) + "&FROM=" + encodeURIComponent(Encrypt(RFromID)) + "&TO=" + encodeURIComponent(Encrypt(RToID))
//            + "&MULTIPORTER=" + encodeURIComponent(Encrypt(IsMTPR)) + "&PATIENTNAME=" + encodeURIComponent(Encrypt(PatientName + "_" + PatientHN + "_" + PatientDOB)) + "&REMARKS=" + encodeURIComponent(Encrypt(Remarks)) + "&USERID=" + encodeURIComponent(Encrypt(UID))
//            + "&HALT1=" + encodeURIComponent(Encrypt(RHalt1)) + "&HALT2=" + encodeURIComponent(Encrypt(RHalt2)) + "&PRIORITY=" + encodeURIComponent(Encrypt("0")) + "&EXTRAFIELDS=" + encodeURIComponent(Encrypt(IsRTC + "_" + ContactNo)) + "&Qty=" + encodeURIComponent(Encrypt(qty))
//            + "&REQUESTOR=" + encodeURIComponent(Encrypt(ReqtrName)),
//        type: 'POST',
//        data: 'pData',
//        dataType: 'json',
//        success: function (data) {
//            if (data && data.length > 0) {
//                var resultParts = data[0].RESULT.split("_");
//                var status = resultParts[0];
//                var ReqNB = resultParts[1] || '';

//                if (status === 'FALSE') {
//                    $('#spanErrorMessage').html('A similar/same request has already been raised.');
//                    ShowModalPopUp('modalAlert');
//                    setTimeout(function () { HideModalPopUp('modalAlert'); }, 3500);
//                } else if (PBDTime.length > 0) {
//                    $('#LBLRequestResult').html('Request pre-booked Successfully...');
//                    HideModalPopUp('addTask');
//                    ShowModalPopUp('modalReqAlert');
//                    setTimeout(function () { HideModalPopUp('modalReqAlert'); }, 3500);
//                } else {
//                    $('#LBLRequestResult').html('Request Raised Successfully.. Req No. #' + ReqNB);
//                    HideModalPopUp('addTask');
//                    ShowModalPopUp('modalReqAlert');
//                    setTimeout(function () { HideModalPopUp('modalReqAlert'); }, 3500);
//                }
//            }
//        },
//        error: function (xhr, status, error) {
//            console.error("InsertRequest error:", error);
//        }
//    });
//}

//function InsertRequest() {
//    var UID = sessionStorage.getItem('ID');
//    var PBDTime = $('#txtReqTime').val();
//    var Remarks = $('#txtRemarks').val(), srcMulti = $('#chkMultiPorter').attr('src');
//    var IsMultiPorter = (srcMulti == "../images/NoMCheck.jpg") ? "0" : "1";

//    var srcSon = $('#chkSunday').attr('src'), srcMon = $('#chkMonday').attr('src'), srcTue = $('#chkTuesday').attr('src'), srcWed = $('#chkWednesday').attr('src'), srcThur = $('#chkThursday').attr('src'),
//        srcFri = $('#chkFriday').attr('src'), srcSat = $('#chkSaturday').attr('src'), defalutSrc = "../images/NoMCheck.jpg";

//    var daysVlaue = ((srcSon == defalutSrc) ? "0" : "1") + "_" + ((srcMon == defalutSrc) ? "0" : "1") + "_" + ((srcTue == defalutSrc) ? "0" : "1") + "_" + ((srcWed == defalutSrc) ? "0" : "1") + "_" + ((srcThur == defalutSrc) ? "0" : "1") + "_" + ((srcFri == defalutSrc) ? "0" : "1") + "_" + ((srcSat == defalutSrc) ? "0" : "1");

//    $.ajax({
//        async: true,
//        url: hurl + "SERVICE/Service.aspx?Process=INSERTROUTINEREQUEST&PBDATE=" + PBDTime + "&CATEGORY=" + ReqCat + "&FROM=" + RFromID + "&TO=" + RToID + "&MULTIPORTER=" + IsMultiPorter + "&PATIENTNAME=&REMARKS=" + Remarks + "&USERID=" + UID + "&PRIORITY=0&EXTRAFIELDS=" + daysVlaue,
//        type: 'POST',
//        data: 'pData',
//        dataType: 'json',
//        success: function (data) {
//            if (data[0].RESULT.split("_")[0] === 'TRUE') {
//                $('#LBLRequestResult').html('Task scheduled Successfully..');
//                LoadTasks();
//                HideModalPopUp('addTask'); ShowModalPopUp('modalReqAlert');
//                setTimeout("HideModalPopUp('modalReqAlert');", 3500);
//                HideModalPopUp('modalReqAlert');
//            } else if (data[0].RESULT.split("_")[0] === 'FALSE') {
//                $('#LBLRequestResult').html('A similar/same request has already been raised.');
//                ShowModalPopUp('modalReqAlert'); //setTimeout("HideModalPopUp('modalReqAlert');", 3500);

//            }

//        },
//        error: function (data) {
//            $('#').html(data[0].RESULT);
//        }
//    });
//}

function UpdateRequest() {
    var ReqID = document.getElementById('HFERID').value, ReqNB = document.getElementById('HFERNO').value;


    var UID = sessionStorage.getItem('ID');
    var PBDTime = $('#txtReqTime').val();
    var Remarks = $('#txtRemarks').val(), srcMulti = $('#chkMultiPorter').attr('src');
    var IsMultiPorter = (srcMulti == "../images/NoMCheck.jpg") ? "0" : "1";

    var srcSon = $('#chkSunday').attr('src'), srcMon = $('#chkMonday').attr('src'), srcTue = $('#chkTuesday').attr('src'), srcWed = $('#chkWednesday').attr('src'), srcThur = $('#chkThursday').attr('src'),
        srcFri = $('#chkFriday').attr('src'), srcSat = $('#chkSaturday').attr('src'), defalutSrc = "../images/NoMCheck.jpg";

    var daysVlaue = ((srcSon == defalutSrc) ? "0" : "1") + "_" + ((srcMon == defalutSrc) ? "0" : "1") + "_" + ((srcTue == defalutSrc) ? "0" : "1") + "_" + ((srcWed == defalutSrc) ? "0" : "1") + "_" + ((srcThur == defalutSrc) ? "0" : "1") + "_" + ((srcFri == defalutSrc) ? "0" : "1") + "_" + ((srcSat == defalutSrc) ? "0" : "1");

    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=UPDATEROUTINEREQUEST&PBDATE=" + PBDTime + "&CATEGORY=" + ReqCat + "&FROM=" + RFromID + "&TO=" + RToID + "&MULTIPORTER=" + IsMultiPorter + "&PATIENTNAME=" + ReqID + "&REMARKS=" + Remarks + "&USERID=" + UID + "&PRIORITY=0&EXTRAFIELDS=" + daysVlaue,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT.split("_")[0] === 'TRUE') {

                $('#LBLRequestResult').html('Request Updated Successfully.. Req No. #' + ReqNB);

                HideModalPopUp('addTask'); ShowModalPopUp('modalReqAlert');
                setTimeout("HideModalPopUp('modalReqAlert');", 3500);
                HideModalPopUp('modalReqAlert'); LoadTasks();
            }
        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}

function formatDate(eleID_Date, eleID_TIme) {

    var date = $('#' + eleID_Date).val(), time = $('#' + eleID_TIme).val(); // 2023-07-06 12:53

    var datetime = date.split('-')[1] + '/' + date.split('-')[2] + '/' + date.split('-')[0] + ' ' + time;

    return datetime;


}

function setMultiPorter() {

    var IsMT = $('#chkMultiPorter').prop('checked');

    IsMTPR = (IsMT) ? "1" : "0";

    //var src = $('#chkMultiPorter').attr('src'); //alert(src);
    //$('#chkMultiPorter').attr("src", (src == "../images/NoMCheck.jpg") ? "../images/MCheck.jpg" : "../images/NoMCheck.jpg");

}
function setReturnCalls() {

    var src = $('#chkReturnCalls').attr('src'); //alert(src);
    $('#chkReturnCalls').attr("src", (src == "../images/Return.png") ? "../images/SReturn.png" : "../images/Return.png");

}

function selRoutineRepeat(eleID) {

    var src = $('#' + eleID).attr('src'); //alert(src);
    $('#' + eleID).attr("src", (src == "../images/NoMCheck.jpg") ? "../images/MCheck.jpg" : "../images/NoMCheck.jpg");

}
function LoadNewRequest() {
    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=GETREQUESTLOCCATRECORDS&TYPE=ROUTINE",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            var catUL = '';
            var dataLocation = $.grep(data, function (element, index) {
                return element.FILTER == "FLOOR";
            });
            var dataCategory = $.grep(data, function (element, index) {
                return element.FILTER == "CATEGORY";
            });

            $.each(dataCategory, function (key, value) {
                catUL += '<li> <input type="checkbox" id="chkCat' + value.ID + '" onchange="CatSelection(this,' + "'" + value.ID + "'" + ');" ><span> <img src="../images/check.png"></span> <img src="' + value.IMAGEPATH + '" alt="' + value.VALUE + '"> <label>' + value.VALUE + '</label> </li>';
            });

            $("#ReqCategories").html('<ul>' + catUL + '</ul>');

            $.each(dataLocation, function (key, value) {

                $('#search_to')[0].sumo.add(value.ID, value.VALUE);
                $('#search_from')[0].sumo.add(value.ID, value.VALUE);
                $('#search_Halt1')[0].sumo.add(value.ID, value.VALUE);
                $('#search_Halt2')[0].sumo.add(value.ID, value.VALUE);
            });


        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}

function clearSumo(ele) {

    var len = $('#' + ele + ' option').length;

    for (var i = len; i > 1; i--) {
        $('#' + ele)[0].sumo.remove(i - 1);
    }
}

function setNewTask() {
    var btn = document.getElementById('btnReqSubmit');
    if (btn) {
        btn.disabled = false;
    }
    $("#TaskHeader").html('Routine Task'); $("#divEditRemarks").css("display", 'none');
    document.getElementById('HFERID').value = ""; document.getElementById('HFERNO').value = ""; document.getElementById('HFStatusID').value = "";
    setDefaultLocationIfService2();
    setDefaultCategoryIfService2();

    const activeServiceBtn = document.querySelector('.services-btn-icon.active');
    const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';

    if (serviceId) {
        setRequestChanges(serviceId, 'New');
    }

    var DateTime = getCurdateTime();
    //alert(curDate);
    document.getElementById("txtReqTime").value = DateTime.split('_')[1];

    $('#search_from')[0].sumo.selectItem('0');

    $('#search_to')[0].sumo.selectItem('0');
    $('#chkPreBook').trigger('change');

    //ReqTime = DateTime.split('_')[1];
    ReqCat = '0'; RFromID = '0'; RToID = '0'; RPreBook = "0";

    $('#chkMultiPorter').attr("src", "../images/NoMCheck.jpg"); $('#chkReturnCalls').attr("src", "../images/Return.png");
    $('#chkPreBook').prop('checked', false);
    $('#txtPatientName').val(''); $('#txtRemarks').val('');

    clearAllCheckBox('ReqCategories');

    $('#chkSunday').attr('src', '../images/NoMCheck.jpg'); $('#chkMonday').attr('src', '../images/NoMCheck.jpg'); $('#chkTuesday').attr('src', '../images/NoMCheck.jpg');
    $('#chkWednesday').attr('src', '../images/NoMCheck.jpg'); $('#chkThursday').attr('src', '../images/NoMCheck.jpg'); $('#chkFriday').attr('src', '../images/NoMCheck.jpg');
    $('#chkSaturday').attr('src', '../images/NoMCheck.jpg');

}


function setEditTask(ReqID, from, to, CategoryID, Time, Remarks, MultiPorter, sunday, monday, tuesday, wednesday, thursday, friday, saturday, flocation, tlocation, Category) {

    $("#TaskHeader").html('Task -' + Remarks); $("#divEditRemarks").css("display", 'block');

    //var DateTime = getCurdateTime();
    var CatEle = $('#chkCat' + CategoryID);
    document.getElementById('HFERID').value = ReqID; document.getElementById('HFERNO').value = ReqID; document.getElementById('HFStatusID').value = '';
    //alert(curDate);
    document.getElementById("txtReqTime").value = Time;

    $('#search_from')[0].sumo.selectItem('0'); $('#search_from')[0].sumo.selectItem(from);
    $('#search_to')[0].sumo.selectItem('0'); $('#search_to')[0].sumo.selectItem(to);

    //ReqDate = DateTime.split('_')[0];
    ReqTime = Time;
    ReqCat = CategoryID; RFromID = from; RToID = to; RPreBook = "0";

    $('#chkMultiPorter').attr("src", (MultiPorter != '0') ? "../images/MCheck.jpg" : "../images/NoMCheck.jpg");
    $('#txtRemarks').val(Remarks); clearAllCheckBox('ReqCategories'); $(CatEle).prop('checked', true);

    $('#chkSunday').attr('src', (sunday !== '1') ? '../images/NoMCheck.jpg' : '../images/MCheck.jpg'); $('#chkMonday').attr('src', (monday !== '1') ? '../images/NoMCheck.jpg' : '../images/MCheck.jpg'); $('#chkTuesday').attr('src', ((tuesday !== '1') ? '../images/NoMCheck.jpg' : '../images/MCheck.jpg'));
    $('#chkWednesday').attr('src', ((wednesday !== '1') ? '../images/NoMCheck.jpg' : '../images/MCheck.jpg')); $('#chkThursday').attr('src', ((thursday !== '1') ? '../images/NoMCheck.jpg' : '../images/MCheck.jpg')); $('#chkFriday').attr('src', ((friday !== '1') ? '../images/NoMCheck.jpg' : '../images/MCheck.jpg'));
    $('#chkSaturday').attr('src', ((saturday !== '1') ? '../images/NoMCheck.jpg' : '../images/MCheck.jpg'));


}



function CatSelection(ele, ID) {
    var count = getCatCount();
    if (count > 1) {
        $(ele).prop('checked', false);
        ReqCat = "0";
    } else
        ReqCat = ID;


}

function getCatCount() {

    var selCount = 0;
    $('#ReqCategories input:checked').each(function () {
        selCount += 1;
    });

    return selCount;
}

function clearAllCheckBox(eleID) {

    $('#' + eleID + ' input:checkbox').prop('checked', false);
}


function setLocation(ele, Type) {
    var value = $(ele).val();

    if (Type == 'From')
        RFromID = value;
    else if (Type == 'To')
        RToID = value;
}


function LoadTableRequest(Process, tblRequset) {
    var UID = sessionStorage.getItem('ID'), PRID = sessionStorage.getItem('ROLE');
    var FinalUrl = hurl + "Service/Service.aspx?Process=GET&Status=" + Process + "&Search=" + (((Process == 3) || (Process == 4) || (Process == 5) || (Process == 6)) ? $('#txtSearch').val() : "") + "&USERID=" + UID + "&PageIndex=" + pageIndex + "&PageSize=" + pageSize + "&ROLE=" + PRID;
    $.ajax({
        url: FinalUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            //(EleID == "divPendingOnHoldPercentage") ? "8" : (EleID == "divTatExceededPercentage") ? "9" :

            var tblRequest = (CProcess !== '100') ? (' <table class="table scroll table-bordered"> <thead> <tr> <th scope="col" >Req. #</th> <th scope="col">Req.<br /> Time</th> ' +
                ((CProcess == "2" || CProcess == "7" || CProcess == "8") ? "" : ((CProcess == "3") ? '<th scope="col">Porter(s)</th> <th scope="col">Assigned <br />  Time</th>' : (CProcess == "4") ? '<th scope="col">Porter(s)</th> <th scope="col">Assigned <br />  Time</th><th scope="col">Started<br /> At</th>' :
                    (CProcess == "6" || CProcess == "9") ? '<th scope="col">Porter(s)</th> <th scope="col">Assigned <br />  Time</th><th scope="col">Started<br /> At</th><th scope="col">Completed<br /> At</th><th scope="col">TAT<br /> (Start to End)</th><th scope="col">TAT<br /> (Request to End)</th>' : ''))
                + '<th scope="col">From</th><th scope="col">To</th><th scope="col">Category</th><th scope="col">Status</th><th scope="col">Requested By</th><th scope="col">Remarks</th>' +
                ((CProcess == "2" || CProcess == "3" || CProcess == "4" || CProcess == "8") ? ('<th scope="col">Add Task</th>') : '') +
                ((CProcess !== "2" && CProcess !== "7" && CProcess !== "6") ? ('<th scope="col">Locate</th>') : '') + ((CProcess == "2") ? '<th scope="col">Priority</th>' : '') + ((CProcess !== "7" && CProcess !== "6") ? '<th scope="col">Cancel</th>' : '') +
                ((CProcess == "7") ? ('<th scope="col">Cancel <br /> Remarks </th><th scope="col">Cancelled <br /> At </th>') : "") + '<th scope="col">Has <br/> Return  Call</th></tr ></thead > <tbody>') //<th scope="col">Reassign</th> <th scope="col">Buzzer</th><<th scope="col">Start</th><th scope="col">Finish</th>
                : (' <table class="table scroll table-bordered"> <thead> <tr> <th scope="col" >Req. #</th> <th scope="col">Req. Time</th><th scope="col">From</th><th scope="col">To</th><th scope="col">Category</th><th scope="col">Status</th><th scope="col">Requested By</th><th scope="col">Remarks</th><th scope="col">Cancel</th></tr ></thead > <tbody>');

            tblContent = '';

            //setEditTask(ReqID, From, To, CategoryID, RequestStatus, StatusID, PatientName, Remarks, CompletedRemarks, CancelledRemarks)

            if (data.length > 0) {

                $.each(data, function (key, value) {

                    var PName = ((!value.PORTERNAME) ? "" : value.PORTERNAME.replace("<br/>", ",").toString()), PorterID = ((!value.PORTERID) ? "" : value.PORTERID.toString()), RequestID = ((!value.REQUESTID) ? "" : value.REQUESTID.toString()),
                        PorterID1 = ((!value.SUBPORTERID) ? "" : value.SUBPORTERID.toString()), Priority = ((!value.PRIORITY) ? "" : value.PRIORITY.toString()), CatID = ((!value.CATEGORYID) ? "" : value.CATEGORYID.toString()),
                        FromID = ((!value.REQUESTLOCATIONID) ? "" : value.REQUESTLOCATIONID.toString()), ToID = ((!value.DESTINATIONLOCATIONID) ? "" : value.DESTINATIONLOCATIONID.toString()), ComRemarks = ((!value.COMPLETEDREMARKS) ? "" : value.COMPLETEDREMARKS.toString()), CanRemarks = ((!value.REMARKS) ? "" : value.REMARKS.toString()),
                        RStatus = ((!value.REQUESTSTATUSID) ? "" : value.REQUESTSTATUSID.toString()), RequestID = ((!value.REQUESTID) ? "" : value.REQUESTID.toString()), ReqNB = ((!value.REQUESTNO) ? "" : value.REQUESTNO.toString()),
                        MultiPorter = ((!value.ISMULTIPORTER) ? "" : value.ISMULTIPORTER.toString()), IsReturnRequired = ((!value.ISRETURNREQUIRED) ? "" : value.ISRETURNREQUIRED.toString()), IsReturn = ((!value.RETURNREQUESTOF) ? "" : value.RETURNREQUESTOF.toString());


                    tblContent +=
                        (CProcess !== '100') ? (' <tr><td>  <div class="add-task-link" onclick="setEditTask(' + "'" + ReqNB + "','" + RequestID + "','" + FromID + "','" + ToID + "','" + CatID + "','" + value.REQUESTSTATUS + "','" + RStatus + "','" + PName + "','" + value.REQUESTDESKREMARKS + "','" + ComRemarks + "','" + CanRemarks + "','" + MultiPorter + "','" + IsReturnRequired + "','" + IsReturn + "'" + ');"> <a href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#addTask" class="btn btn-primary"><img src="../images/memo.png" alt="Add Task">' + value.REQUESTNO + ' </a> </div> </td><td>' + value.REQUESTTIME + '</td>' +
                            ((CProcess == "2" || CProcess == "7" || CProcess == "8") ? "" : ((CProcess == "3") ? '<td>' + value.PORTERNAME + '</td><td>' + value.ASSIGNEDTIME + '</td>' : (CProcess == "4") ? '<td>' + value.PORTERNAME + '</td><td>' + value.ASSIGNEDTIME + '</td><td>' + value.STARTTIME + '</td>' : (CProcess == "6" || CProcess == "9") ? '<td>' + value.PORTERNAME + '</td><td>' + value.ASSIGNEDTIME + '</td><td>' + value.STARTTIME + '</td><td>' + value.ENDTIME + '</td><td>' + value.TAT + '</td><td>' + value.TTAT + '</td>' : ''))
                            + '<td>' + value.FROM + '</td><td>' + value.TO + ' </td><td>' + value.CATEGORYNAME + '</td><td>' + value.REQUESTSTATUS + '</td><td>' + value.REQUESTORNAME + '</td><td>' + value.REQUESTDESKREMARKS + '</td>' +
                            ((CProcess == "2" || CProcess == "3" || CProcess == "4" || CProcess == "8") ? '<td align="center"> <img src="../images/Add.png" onclick="AddTask(' + "'" + PName + "','" + PorterID + "','" + RStatus + "'" + ');" class="imgIcons" /> </td>' : '') +
                            ((CProcess !== "7" && CProcess !== "6") ? (((CProcess !== "2") ? '<td> ' + ((PorterID !== "") ? ((RStatus == '3' || RStatus == '4') ? '<img src="../images/Locate.png" onclick="LocatePorter(' + "'" + PorterID + "','" + PorterID1 + "','" + PName + "'" + ');" class="imgIcons" />' : '-') : '-') + '</td>' : '')

                                + ((RStatus == "2") ? ('<td align="center"> <img src="../images/' + ((Priority == "Yes") ? "Emg" : "NoEmg") + '.png"  onclick = "setPriority(' + "'" + ((Priority == "Yes") ? "RELEASE" : "SET") + "', '" + CatID + "','" + RequestID + "'" + ');" class="imgIcons" /></td>') : "") +
                                "<td>" + ((RStatus != "6" && RStatus != "7") ? ('<img src="../images/close.png" class="ReturnCalls" onclick = "InitCancel(' + "'" + RequestID + "','" + ReqNB + "', 'ModalCancel');" + '" />') : "") + '</td>') : ((CProcess == "7") ? '<td>' + value.REMARKS + '</td><td>' + value.CANCELLEDAT + '</td> ' : ""))
                            + '<td>' + ((IsReturnRequired == "1") ? "YES" : ((IsReturn.length > 0) ? '<img src="../images/SReturn.png" class="ReturnCalls" />' : "No")) + '</td>' + '</tr> ')//<td>-</td><td>-</td><td>-</td><td>-</td>
                            : (' <tr><td>' + value.REQUESTNO + '</td><td>' + value.REQUESTDATE + '</td><td>' + value.FROM + '</td><td>' + value.TO + ' </td><td>' + value.CATEGORYNAME + '</td><td>' + value.REQUESTSTATUS + '</td><td>' + value.REQUESTORNAME + '</td><td>' + value.REQUESTDESKREMARKS + '</td><td> ' +
                                ((RStatus != "2" && RStatus != "3") ? ('<img src="../images/close.png" class="imgIcons" onclick = "InitCancel(' + "'" + RequestID + "','" + ReqNB + "', 'ModalCancel');" + '" />') : "") + '</td> </tr> ');





                });
            }


            tblRequest += tblContent + '</tbody > </table > '; $(tblRequset).html(tblRequest);
        },
        error: function (data) {

        }

    });
}


function GetPorterTasks(PorterID) {
    var ContainerID1 = "gridPenTask"; PorterCurTasks = "", ATPorterID = PorterID;


    $.ajax({
        async: true,
        url: hurl + "Service/ServiceAddTask.aspx?Process=PENDINGTASKS&PORTERID=" + PorterID,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {


            var TablePending = "<table width='95%' class='table scroll table-bordered'' cellpadding='5' cellspacing='5' style='border-collapse: collapse;border: 1px solid gray;margin-top: 10px;'> <tr style='border: 1px solid gray;height:30px;'> " +
                "<td align='center'style='width:50px;vertical-align: middle;border: 1px solid gray;font-family: monospace;font-size: 16px;'> REQ NO.  </td> " +
                " <td align='left'style='width:100px;vertical-align: middle;border: 1px solid gray;font-family: monospace;font-size: 16px;padding-left: 10px;'> FROM </td>" +
                " <td align='left'style='width:100px;vertical-align: middle;border: 1px solid gray;font-family: monospace;font-size: 16px;padding-left: 10px;'> CATEGORY </td> " +
                " <td align='left' style='width:30px;border: 1px solid white;border-bottom: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;' > </td> </tr > ";

            $.each(data, function (key, value) {

                var ReqNB = value.REQNB, from = value.FROM, category = value.CATEGORY, statusID = value.STATUSID, ReqstID = value.REQUESTID;

                switch (statusID) {
                    case 3:
                    case 4:
                        PorterCurTasks += ReqstID + "_";
                        ATReqNB += ReqNB + ",";
                        var checkedIcon = "<img id='CurTask" + ReqstID + "' src='../images/Check.png' alt='Add'  height='20px' class='IconAddTask' onclick='setCurTasks(" + '"' + ReqstID + '"' + ',"' + ReqNB + '"' + ");' style='cursor:pointer' />";
                        TablePending += "<tr style='border: 1px solid gray;height:25px;' > <td align='center'style='width:50px;vertical-align: middle;border: 1px solid gray;font-family: monospace;font-size: 14px;'> #" + ReqNB +
                            " </td>   <td align='left' style='width:130px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;' > " + from +
                            " </td>   <td align='left' style='width:130px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;' > " + category + "</td>" +
                            " <td align='left' style='width:30px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;' >" + checkedIcon + " </td> </tr > ";

                        break;
                    case 2:
                        PendingTasks += ReqstID + "_";
                        var UncheckedIcon = "<img id='CurTask" + ReqstID + "' src='../images/UnCheck.png' alt='Add'  height='20px' class='IconAddTask' onclick='setCurTasks(" + '"' + ReqstID + '"' + ',"' + ReqNB + '"' + ");' style='cursor:pointer' />";
                        TablePending += "<tr style='border: 1px solid gray;height:25px;' > <td align='center'style='width:50px;vertical-align: middle;border: 1px solid gray;font-family: monospace;font-size: 14px;'> #" + ReqNB +
                            " </td>   <td align='left' style='width:130px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;' > " + from +
                            " </td>   <td align='left' style='width:130px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;' > " + category + "</td>" +
                            " <td align='left' style='width:30px;border: 1px solid gray;vertical-align: middle;font-family: monospace;font-size: 14px;padding-left: 10px;' >" + UncheckedIcon + " </td> </tr > ";
                        break;
                }

            });
            TablePending += "</table>";
            $('#' + ContainerID1 + '').html(TablePending);

            //$('#' + ContainerID).css('display', ((data.length > 0) ? 'block' : 'none'));


        },
        error: function (data) {

        }

    });

}


function ShowModalPopUp(ModalId) {
    $('#' + ModalId).modal('show');
}
function HideModalPopUp(ModalId) {
    $('#' + ModalId).modal('hide');
}