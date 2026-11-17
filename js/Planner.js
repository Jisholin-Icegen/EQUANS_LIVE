//const { clearInterval } = require("timers");


function getCurdateTime() {

    var d = new Date();

    var month = d.getMonth() + 1;
    var day = d.getDate(), Hour = d.getHours(), Minute = d.getMinutes();
    var time = (Hour < 10 ? '0' : '') + Hour + ':' + (Minute < 10 ? '0' : '') + Minute; // d.getHours() + ":" + d.getMinutes();// + ":" + dt.getSeconds();

    var date = d.getFullYear() + '-' + (month < 10 ? '0' : '') + month + '-' + (day < 10 ? '0' : '') + day;

    return date + '_' + time;
}

function submitRequest() {
  //  EqpId = '0';
    var IsEdit = ((document.getElementById('HFERID').value).length > 0);
    if (RFromID == '0') {
        $('#txtFromLoc').focus();
        $('#txtFromLoc').css('border', '2px solid red'); setTimeout(function () { $('#txtFromLoc').css('border', '1px solid rgb(248, 247, 247)'); }, 2500);
    }
    else if (RToID == '0') {
        $('#txtToLoc').focus();
        $('#txtToLoc').css('border', '2px solid red'); setTimeout(function () { $('#txtToLoc').css('border', '1px solid rgb(248, 247, 247)'); }, 2500);
    }
    else if (ReqCat == '0') {
        $('#txtSearchCat').focus();
        $('#containerCat').css('border', '2px solid red'); setTimeout(function () { $('#containerCat').css('border', '2px solid white'); }, 2500);
    }
    /*else if (EqpId == '0') {
        $('#txtSearchEquipment').focus();
        $('#EquipmentCategories').css('border', '2px solid red'); setTimeout(function () { $('#EquipmentCategories').css('border', '2px solid white'); }, 2500);
    } */
    else {
        if (IsEdit)
            UpdateRequest();
        else
            InsertRequest();
    }



}


function deleteTask() {
    var delID = document.getElementById('HFERID').value, ZoneDetails = document.getElementById('HFERNO').value;
    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=" + encodeURIComponent(Encrypt("DELETEROUTINE")) + "&ID=" + encodeURIComponent(Encrypt(delID)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT.split("_")[0] === 'TRUE') {
                $('#LBLRequestResult').html('Task Details Removed Successfully.. Task Details :-' + ZoneDetails);

                HideModalPopUp('addTask'); ShowModalPopUp('modalReqAlert');
                setTimeout("HideModalPopUp('modalReqAlert');", 3500); LoadTasks();
            }
        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}

function LoadTasks() {
    var searchVal = $('#TextSearch').val().trim();
    var FinalUrl = hurl + "Service/Service.aspx?Process=" + encodeURIComponent(Encrypt("GETROUTINETASK")) +"&SEARCH=" + encodeURIComponent(Encrypt(searchVal)) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode));
    $.ajax({
        url: FinalUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var tblRequest = ' <table class="table scroll table-bordered"> <thead> <tr style="height:25px"><th scope="col" style="width:120px;">REQ. <br/> TIME</th> <th scope="col" style="width:250px;"> TASK TYPE </th> <th scope="col"  style="width:150px;">FROM</th><th scope="col"  style="width:150px;">TO</th><th scope="col"  style="width:150px;">EQUIPMENT</th><th scope="col"  style="width:150px;">REMARKS</th><th scope="col"  style="width:100px;">MultiPorter</th>' +
                '<th scope="col" style="width:100px;">Sunday</th><th scope="col" style="width:100px;">Monday</th><th scope="col" style="width:100px;">Tuesday</th><th scope="col" style="width:100px;">Wednesday</th><th scope="col" style="width:100px;">Thursday</th><th scope="col" style="width:100px;">Friday</th><th scope="col" style="width:100px;">Saturday</th></tr></thead > <tbody>';

            tblContent = '';

            if (data.length > 0) {

                $.each(data, function (key, value) {

                    var RTId = ((!value.ID) ? "" : value.ID.toString()),

                        FromID = ((!value.FROM) ? "" : value.FROM.toString()),
                        ToID = ((!value.TO) ? "" : value.TO.toString()),
                        CatID = ((!value.CATEGORY) ? "" : value.CATEGORY.toString()),
                        Time = ((!value.TIME) ? "" : value.TIME.toString()),
                        Remarks = ((!value.REMARKS) ? "" : value.REMARKS.toString()),
                        MultiPorter = ((!value.NOOFPORTER) ? "" : value.NOOFPORTER.toString()),
                        sunday = ((!value.SUNDAY) ? "" : value.SUNDAY.toString()),
                        monday = ((!value.MONDAY) ? "" : value.MONDAY.toString()),
                        tuesday = ((!value.TUESDAY) ? "" : value.TUESDAY.toString()),
                        wednesday = ((!value.WEDNESDAY) ? "" : value.WEDNESDAY.toString()),
                        thursday = ((!value.THURSDAY) ? "" : value.THURSDAY.toString()),
                        friday = ((!value.FRIDAY) ? "" : value.FRIDAY.toString()),
                        saturday = ((!value.SATURDAY) ? "" : value.SATURDAY.toString()),
                        from = ((!value.FLOCATION) ? "" : value.FLOCATION.toString()),
                        To = ((!value.TLOCATION) ? "" : value.TLOCATION.toString()),
                        Category = ((!value.CATEGORYNAME) ? "" : value.CATEGORYNAME.toString()),
                        EQTyp = ((!value.EQUIPMENTTYPE) ? "" : value.EQUIPMENTTYPE.toString()),
                        EQTypId = ((!value.EQUIPMENTID) ? "" : value.EQUIPMENTID.toString());



                    tblContent += ' <tr><td>  <div class="add-task-link" onclick="setEditTask(' + "'" + RTId + "','" + FromID + "','" + ToID + "','" + CatID + "','" + Time + "','" + Remarks + "','" + MultiPorter + "','" + sunday + "','" + monday + "','" + tuesday + "','" + wednesday + "','" + thursday + "','" + friday + "','" + saturday + "','" + from + "','" + To + "','" + Category + "','" + EQTypId + "','" + EQTyp + "'" + ');"> <a href="javascript:void(0)"  class="btn btn-indexblue"><img src="../images/memo.png" alt="Add Task">' + Time + ' </a> </div> </td>' +
                        '<td>' + Category + '</td>' + '<td>' + from + '</td>' + '<td>' + To + '</td>' + '<td>' + EQTyp + '</td>' + '<td>' + Remarks + '</td>' + '<td>' + ((MultiPorter == '1') ? "YES" : "NO") + '</td>' +
                        '<td align="center"> <img src="../images/' + ((sunday == '1') ? 'MCheck.jpg' : 'NoMCheck.jpg') + '" class="ingRoutineicon" onclick="updateRoutine(' + "'" + RTId + "','SUNDAY'" + ');"/> </td>' +
                        '<td align="center"> <img src="../images/' + ((monday == '1') ? 'MCheck.jpg' : 'NoMCheck.jpg') + '" class="ingRoutineicon" onclick="updateRoutine(' + "'" + RTId + "','MONDAY'" + ');"/> </td>' +
                        '<td align="center"> <img src="../images/' + ((tuesday == '1') ? 'MCheck.jpg' : 'NoMCheck.jpg') + '" class="ingRoutineicon" onclick="updateRoutine(' + "'" + RTId + "','TUESDAY'" + ');"/> </td>' +
                        '<td align="center"> <img src="../images/' + ((wednesday == '1') ? 'MCheck.jpg' : 'NoMCheck.jpg') + '" class="ingRoutineicon" onclick="updateRoutine(' + "'" + RTId + "','WEDNESDAY'" + ');"/> </td>' +
                        '<td align="center"> <img src="../images/' + ((thursday == '1') ? 'MCheck.jpg' : 'NoMCheck.jpg') + '" class="ingRoutineicon" onclick="updateRoutine(' + "'" + RTId + "','THURSDAY'" + ');"/> </td>' +
                        '<td align="center"> <img src="../images/' + ((friday == '1') ? 'MCheck.jpg' : 'NoMCheck.jpg') + '" class="ingRoutineicon" onclick="updateRoutine(' + "'" + RTId + "','FRIDAY'" + ');"/> </td>' +
                        '<td align="center"> <img src="../images/' + ((saturday == '1') ? 'MCheck.jpg' : 'NoMCheck.jpg') + '" class="ingRoutineicon" onclick="updateRoutine(' + "'" + RTId + "','SATURDAY'" + ');"/> </td> </tr> ';


                });


            }
            tblRequest += tblContent + '</tbody > </table > '; $('#tblRoutineTasks').html(tblRequest);
        },
        error: function (data) {

        }

    });
}

function updateRoutine(Id, Column) {
    var UID = sessionStorage.getItem('ID');
    $('.loaderElement').css("display", "inline-block");

    $.ajax({
        async: true,
        url: hurl + "Service/Service.aspx?Process=" + encodeURIComponent(Encrypt("UPDATEROUTINE")) +"&ID=" + encodeURIComponent(Encrypt(Id)) + '&COLUMN=' + encodeURIComponent(Encrypt(Column)) + "&USERID=" + encodeURIComponent(Encrypt(UID)),
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

function Encrypt(Value) {
    var key = CryptoJS.enc.Utf8.parse(CryptoKey);
    var iv = CryptoJS.enc.Utf8.parse(CryptoPwd);

    var encryptedVal = CryptoJS.AES.encrypt(CryptoJS.enc.Utf8.parse(Value), key,
        {
            keySize: 128 / 8,
            iv: iv,
            mode: CryptoJS.mode.CBC,
            padding: CryptoJS.pad.Pkcs7
        });
    return encryptedVal;
}
function InsertRequest() {
    var UID = sessionStorage.getItem('ID');
    var PBDTime = $('#txtReqTime').val();
    var Remarks = $('#txtRemarks').val(), srcMulti = $('#chkMultiPorter').attr('src');
    var IsMultiPorter = (srcMulti == "../images/NoMCheck.jpg") ? "0" : "1";

    var srcSon = $('#chkSunday').attr('src'), srcMon = $('#chkMonday').attr('src'), srcTue = $('#chkTuesday').attr('src'), srcWed = $('#chkWednesday').attr('src'), srcThur = $('#chkThursday').attr('src'),
        srcFri = $('#chkFriday').attr('src'), srcSat = $('#chkSaturday').attr('src'), defalutSrc = "../images/NoMCheck.jpg";

    var daysVlaue = ((srcSon == defalutSrc) ? "0" : "1") + "_" + ((srcMon == defalutSrc) ? "0" : "1") + "_" + ((srcTue == defalutSrc) ? "0" : "1") + "_" + ((srcWed == defalutSrc) ? "0" : "1") + "_" + ((srcThur == defalutSrc) ? "0" : "1") + "_" + ((srcFri == defalutSrc) ? "0" : "1") + "_" + ((srcSat == defalutSrc) ? "0" : "1");

    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=" + encodeURIComponent(Encrypt("INSERTROUTINEREQUEST")) +"&PBDATE=" + encodeURIComponent(Encrypt(PBDTime)) + "&CATEGORY=" + encodeURIComponent(Encrypt(ReqCat)) + "&FROM=" + encodeURIComponent(Encrypt(RFromID)) + "&TO=" + encodeURIComponent(Encrypt(RToID))
            + "&MULTIPORTER=" + encodeURIComponent(Encrypt(IsMultiPorter)) + "&EQUIPMENTID=" + encodeURIComponent(Encrypt(EqpId)) + "&PATIENTNAME=" + encodeURIComponent(Encrypt("")) + "&REMARKS=" + encodeURIComponent(Encrypt(Remarks)) + "&USERID=" + encodeURIComponent(Encrypt(UID)) + "&PRIORITY=" + encodeURIComponent(Encrypt("0")) + "&EXTRAFIELDS=" + encodeURIComponent(Encrypt(daysVlaue)) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)) ,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT.split("_")[0] === 'TRUE') {
                $('#LBLRequestResult').html('Task scheduled Successfully..');
                LoadTasks();
                HideModalPopUp('addTask'); ShowModalPopUp('modalReqAlert');
                setTimeout("HideModalPopUp('modalReqAlert');", 3500);
                HideModalPopUp('modalReqAlert');
            } else if (data[0].RESULT.split("_")[0] === 'FALSE') {
                $('#LBLRequestResult').html('A similar/same request has already been raised.');
                ShowModalPopUp('modalReqAlert'); //setTimeout("HideModalPopUp('modalReqAlert');", 3500);

            }

        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}

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
        url: hurl + "SERVICE/Service.aspx?Process=" + encodeURIComponent(Encrypt("UPDATEROUTINEREQUEST")) +"&PBDATE=" + encodeURIComponent(Encrypt(PBDTime)) + "&CATEGORY=" + encodeURIComponent(Encrypt(ReqCat)) + "&FROM=" + encodeURIComponent(Encrypt(RFromID)) + "&TO=" + encodeURIComponent(Encrypt(RToID)) +
            "&MULTIPORTER=" + encodeURIComponent(Encrypt(IsMultiPorter)) + "&EQUIPMENTID=" + encodeURIComponent(Encrypt(EqpId)) + "&PATIENTNAME=" + encodeURIComponent(Encrypt(ReqID)) + "&REMARKS=" + encodeURIComponent(Encrypt(Remarks)) + "&USERID=" + encodeURIComponent(Encrypt(UID)) + "&PRIORITY=" + encodeURIComponent(Encrypt("0")) + "&EXTRAFIELDS=" + encodeURIComponent(Encrypt(daysVlaue)) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)) ,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data[0].RESULT.split("_")[0] === 'TRUE') {
                EqpId = '0';
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

    var src = $('#chkMultiPorter').attr('src'); //alert(src);
    $('#chkMultiPorter').attr("src", (src == "../images/NoMCheck.jpg") ? "../images/MCheck.jpg" : "../images/NoMCheck.jpg");

}
function setReturnCalls() {

    var src = $('#chkReturnCalls').attr('src'); //alert(src);
    $('#chkReturnCalls').attr("src", (src == "../images/Return.png") ? "../images/SReturn.png" : "../images/Return.png");

}

function selRoutineRepeat(eleID) {

    var src = $('#' + eleID).attr('src'); //alert(src);
    $('#' + eleID).attr("src", (src == "../images/NoMCheck.jpg") ? "../images/MCheck.jpg" : "../images/NoMCheck.jpg");

}


function searchCategory(ele) {
    var val = $(ele).val();
    //if (val.trim().length > 0)
    LoadCategories(val);


}
function searchEquipment(input) {
    const val = input.value;

    const activeServiceBtn = document.querySelector('.services-btn-icon.active');
    const serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '1';

    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=" + encodeURIComponent(Encrypt("GETEQUIPMENT")) +"" +
            "&VAL=" + encodeURIComponent(Encrypt(val)) +
            "&VAL1=" + encodeURIComponent(Encrypt(ReqCat || '')) +
            "&SERVICEID=" + encodeURIComponent(Encrypt(serviceId)),
        type: 'POST',
        dataType: 'json',
        success: function (data) {
            if (!data || data.length === 0) {
                $("#EquipmentCategories").html("<p class='text-white'>No Equipment Found</p>");
                return;
            }

            let equipmentHTML = '';
            $.each(data, function (key, value) {
                const imgPath = value.IMAGEPATH || "../images/no-image.png";
                equipmentHTML += `
                <li>
                    <input type="checkbox" onchange="EqpSelection(this, ${value.Id});" id="chkEquip${value.Id}">
                    <span><img src="../images/check.png"></span>
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
    LoadEquipment('', serviceId,'','');
} function LoadEquipment(val, serviceId,edi,eqid) {
    if (!serviceId) {
        const activeServiceBtn = document.querySelector('.services-btn-icon.active');
        serviceId = activeServiceBtn ? activeServiceBtn.id.replace('divService', '') : '';
    }

    const isTrolleyMode = (serviceId === "2");

    if (!val || val.trim() === "") {
        val = isTrolleyMode ? "Tr" : "a";
    }

    let url = hurl + "SERVICE/Service.aspx?Process=" + encodeURIComponent(Encrypt("GETEQUIPMENT")) +"";
    url += "&VAL=" + encodeURIComponent(Encrypt(val));
    url += "&VAL1=" + encodeURIComponent(Encrypt(ReqCat || ''));
    url += "&SERVICEID=" + encodeURIComponent(Encrypt(serviceId));

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
                    if (item.VALUE?.toLowerCase() === "trolley") {
                        trolleyItem = item;
                    } else {
                        otherItems.push(item);
                    }
                });

                sortedData = trolleyItem ? [trolleyItem, ...otherItems] : otherItems;
            }

            const html = sortedData.map(value => {
                const imgPath = value.IMAGEPATH || "../images/no-image.png";
                const isTrolley = value.VALUE?.toLowerCase() === "trolley";
                const checkedAttr = (isTrolley && isTrolleyMode) ? "checked" : "";

                return `
                    <li>
                        <input type="checkbox" onchange="EqpSelection(this, ${value.Id});"  id="chkEquip${value.Id}" ${checkedAttr}>
                        <span><img src="../images/check.png" alt="check"></span>
                        <img src="${imgPath}" alt="${value.VALUE}">
                        <p>${value.VALUE}</p>
                    </li>`;
            }).join('');

            $("#EquipmentCategories").html('<ul>' + html + '</ul>');

            if (edi == 'E') {
                $("#chkEquip" + eqid).prop('checked', true);
                EqpId = eqid;
            }

        },
        error: function (xhr) {
            console.error("Equipment load error:", xhr.responseText);
            $("#EquipmentCategories").html("<p class='text-white'>Failed to load equipment</p>");
        }
    });
}
function changeCheck(ele) {
    var src = $(ele).attr('src'); //alert(src);
    $(ele).attr("src", (src == "../images/CNoCheck.png") ? "../images/CCheck.png" : "../images/CNoCheck.png");

}
function LoadCategories(val) {
    var selTS = '', selTE = '';
   // LoadEquipmentOnInit(sessionStorage.getItem('ServiceCode'));

    $.ajax({
        async: true,
        url: hurl + "SERVICE/Service.aspx?Process=" + encodeURIComponent(Encrypt("GETCATEGORIES")) +"&VAL=" + encodeURIComponent(Encrypt(val)) + "&VAL1=" + encodeURIComponent(Encrypt(ReqCat)) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)) ,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            var catUL = '';
            var dataCategory = $.grep(data, function (element, index) {
                return element.FILTER == "CATEGORY";
            });

            $.each(dataCategory, function (key, value) {
                selTS = (((ReqCat == value.ID) && (selTS === '')) ? value.TS : selTS); selTE = (((ReqCat == value.ID) && (selTE === '')) ? value.TE : selTE);

                catUL += '<li> <input type="checkbox" id="chkCat' + value.ID + '" onchange="CatSelection(this,' + "'" + value.ID + "','" + value.ISTWOPORTERTASK + "','" + value.VALUE + "','" + value.QUANTITY + "','" + value.TS + "','" + value.TE + "','" + value.FLOCID + "','" + value.KITCHEN + "'" + ');" ><span> <img src="../images/check.png"></span> <img src="' + value.IMAGEPATH + '" alt="' + value.VALUE + '"> <p>' + value.VALUE + '</p> </li>';

               // catUL += '<li> <input type="checkbox" id="chkCat' + value.ID + '" onchange="CatSelection(this,' + "'" + value.ID + "'" + ');" ><span> <img src="../images/check.png"></span> <img src="' + value.IMAGEPATH + '" alt="' + value.VALUE + '"> <p>' + value.VALUE + '</p> </li>';
            });

            $("#ReqCategories").html('<ul>' + catUL + '</ul>');


            //setTimeout(function () { setCategories(ReqCat);}, 400);

            $("#chkCat" + ReqCat).prop('checked', true);
            ReqCat = ReqCat;
            if (selTS != '' || selTE != '') {
                $('#lblKPITS').html(((selTS != '-' && selTS != '0') ? (selTS + '<br/> <span style="font-size:13px;"> (min) </span> ') : '-'));
                $('#lblKPITE').html(((selTE != '-' && selTE != '0') ? (selTE + '<br/> <span style="font-size:13px;"> (min) </span> ') : '-'));
            } 

        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });

}

function LoadNewRequest() {

    LoadCategories('');

}

function clearSumo(ele) {

    var len = $('#' + ele + ' option').length;

    for (var i = len; i > 1; i--) {
        $('#' + ele)[0].sumo.remove(i - 1);
    }
}


function loadsuggesstion(searchType, Val) {
    var sType = ((searchType == 'from') ? "SF" : "ST")
    $.ajax({
        async: true,
        url: hurl + "Service/Service.aspx?Process=" + encodeURIComponent(Encrypt("GETSEARCHEDLOCATION")) +"&LOCATION=" + Val + "&STYPE=" + sType,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        beforeSend: function () {
            $("#" + ((searchType == 'from') ? "txtFromLoc" : "txtToLoc")).css("background", "#FFF url(../images/LoadingN.gif) no-repeat 95%").css("background-size", "35px");
        },
        success: function (data) {
            $("#" + ((searchType == 'from') ? "suggesstionFrom" : "suggesstionTo")).show();
            $("#" + ((searchType == 'from') ? "suggesstionFrom" : "suggesstionTo")).html(data[0].RESULT);
            $("#" + ((searchType == 'from') ? "txtFromLoc" : "txtToLoc")).css("background", "#FFF");
        }
    });
}


function BindLocation(Id, Value, type) {

    if (type == "SF") {
        RFromID = Id;
        $("#txtFromLoc").val(Value);
        $("#suggesstionFrom").hide();
    }
    else if (type == "ST") {
        RToID = Id;
        $("#txtToLoc").val(Value);
        $("#suggesstionTo").hide();
    }

}


function setNewTask() {


    $("#TaskHeader").html('Routine Task'); $("#divEditRemarks").css("display", 'none');
    document.getElementById('HFERID').value = ""; document.getElementById('HFERNO').value = ""; document.getElementById('HFStatusID').value = "";

    var DateTime = getCurdateTime();
    //alert(curDate);
    document.getElementById("txtReqTime").value = DateTime.split('_')[1];


    $('#txtFromLoc').val(''); $('#txtToLoc').val(''); $('#txtSearchCat').val('');

    ReqCat = '0'; RFromID = '0'; RToID = '0'; RPreBook = "0"; EqpId = '0'; EqpName = '';

    $('#chkMultiPorter').attr("src", "../images/NoMCheck.jpg"); $('#chkReturnCalls').attr("src", "../images/Return.png");
    $('#chkPreBook').prop('checked', false);
    $('#txtPatientName').val(''); $('#txtRemarks').val('');
     LoadEquipmentOnInit(sessionStorage.getItem('ServiceCode'));
    LoadCategories('');

    clearAllCheckBox('ReqCategories');

    $('#chkSunday').attr('src', '../images/NoMCheck.jpg'); $('#chkMonday').attr('src', '../images/NoMCheck.jpg'); $('#chkTuesday').attr('src', '../images/NoMCheck.jpg');
    $('#chkWednesday').attr('src', '../images/NoMCheck.jpg'); $('#chkThursday').attr('src', '../images/NoMCheck.jpg'); $('#chkFriday').attr('src', '../images/NoMCheck.jpg');
    $('#chkSaturday').attr('src', '../images/NoMCheck.jpg');
    ShowModalAddtask();
}


function setEditTask(ReqID, from, to, CategoryID, Time, Remarks, MultiPorter, sunday, monday, tuesday, wednesday, thursday, friday, saturday, flocation, tlocation, Category,tEqid,tEqtype) {

    $("#TaskHeader").html('Task -' + Category + ' @' + Time); $("#divEditRemarks").css("display", 'block');
    $("#txtSearchEquipment").val('');
    
    //var DateTime = getCurdateTime();
    var CatEle = $('#chkCat' + CategoryID);
    document.getElementById('HFERID').value = ReqID; document.getElementById('HFERNO').value = Category + ' @' + Time; document.getElementById('HFStatusID').value = '';
    //alert(curDate);
    document.getElementById("txtReqTime").value = Time;
    ReqCat = CategoryID; RFromID = from; RToID = to;

    $('#txtFromLoc').val(flocation); $('#txtToLoc').val(tlocation);
    ReqTime = Time;

    ((MultiPorter == '1') ? "YES" : "NO")

    $('#txtSearchCat').val('');
    $('#chkMultiPorter').attr("src", (MultiPorter == '1') ? "../images/MCheck.jpg" : "../images/NoMCheck.jpg");
    $('#txtRemarks').val(Remarks); clearAllCheckBox('ReqCategories');

  //  LoadCategories('');//SEN EQ
    LoadCategories(Category);
    LoadEquipment(tEqtype, ServiceCode, 'E', tEqid)
    

    $('#chkSunday').attr('src', (sunday !== '1') ? '../images/NoMCheck.jpg' : '../images/MCheck.jpg'); $('#chkMonday').attr('src', (monday !== '1') ? '../images/NoMCheck.jpg' : '../images/MCheck.jpg'); $('#chkTuesday').attr('src', ((tuesday !== '1') ? '../images/NoMCheck.jpg' : '../images/MCheck.jpg'));
    $('#chkWednesday').attr('src', ((wednesday !== '1') ? '../images/NoMCheck.jpg' : '../images/MCheck.jpg')); $('#chkThursday').attr('src', ((thursday !== '1') ? '../images/NoMCheck.jpg' : '../images/MCheck.jpg')); $('#chkFriday').attr('src', ((friday !== '1') ? '../images/NoMCheck.jpg' : '../images/MCheck.jpg'));
    $('#chkSaturday').attr('src', ((saturday !== '1') ? '../images/NoMCheck.jpg' : '../images/MCheck.jpg'));

    ShowModalAddtask();
}
function EqpSelection(ele ,ID) {

    var count = getEqpCount();

    if (count > 1) {
        $(ele).prop('checked', false);
    } else {
        if (count == 0) {

            EqpId = '0';
            // EqpName = '';
        } else {
            EqpId = ID;
        }
    }

}
function CatSelection(ele, ID, IsTwoPorter, CatName, IsQuantity, TS, TE, FLOCID, KITCHEN) {
    var EStatusID = document.getElementById('HFStatusID').value;
    var NCName = '', NCID = '0';

    if (EStatusID == '' || EStatusID == '100') {
        var count = getCatCount();

        if (count > 1) {
            $(ele).prop('checked', false);
        } else {
            if (count == 0) {
                CatKitName = '';
                CatKitID = '0';
                NCName = (LBKitID != '0') ? LBKitName : '';
                NCID = (LBKitID != '0') ? LBKitID : '0';

                ReqCat = '0';
                NewCategory = '';
            } else {
                CatKitName = KITCHEN;
                CatKitID = FLOCID;
                NCName = (LBKitName.includes('Haywood')) ? LBKitName : ((CatKitName.includes("Main") && LBKitName.includes("Main")) ? LBKitName : ((CatKitName.includes("Main")) ? CatKitName : LBKitName));
                NCID = (LBKitName.includes('Haywood')) ? LBKitID : ((CatKitName.includes("Main") && LBKitName.includes("Main")) ? LBKitID : ((CatKitName.includes("Main")) ? CatKitID : LBKitID));

                ReqCat = ID;
                NewCategory = CatName;
            }

            //if (ServiceCode == '3') {
            //    $("#txtFromLoc").val(NCName);
            //    RFromID = NCID;
            //}
        }

        $('#divQuantity').css("display", (IsQuantity == '1' ? "inline-block" : "none"));

        if (count == 1) {
            $('#lblKPITS').html((TS !== '-' && TS !== '0') ? (TS + '<br/><span style="font-size:13px;"> (min) </span>') : '-');
            $('#lblKPITE').html((TE !== '-' && TE !== '0') ? (TE + '<br/><span style="font-size:13px;"> (min) </span>') : '-');
        } else if (count == 0) {
            $('#lblKPITS').html('-');
            $('#lblKPITE').html('-');
        }

        const isAssistantRequired = (IsTwoPorter === '1' && count === 1);
        
        $('#chkMultiPorter').attr("src", isAssistantRequired == "1" ? "../images/CCheck.png" : "../images/CNoCheck.png").trigger('change');;
       // $('#chkMultiPorter').prop('checked', isAssistantRequired).trigger('change');

    } else {
        ReqCat = OldCatID;
        setCategories(OldCatID);
    }
}
function setCategories(Id) {
    var eleID = "#chkCat" + Id;
    clearAllCheckBox('ReqCategories'); $(eleID).prop('checked', true);

    ReqCat = Id;
}
/*
function CatSelection(ele, ID) {

    var count = getCatCount();
    if (count > 1)
        $(ele).prop('checked', false);
    else {
        if (count == 0)
            ReqCat = '0';
        else
            ReqCat = ID;

    }

}
*/
/*
function CatSelection(ele, ID) {
    var count = getCatCount();
    if (count > 1) {
        $(ele).prop('checked', false);
        ReqCat = "0";
    } else
        ReqCat = ID;


}*/

function getEqpCount() {

    var selCount = 0;
    $('#EquipmentCategories input:checked').each(function () {
        selCount += 1;
    });

    return selCount;
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
    var FinalUrl = hurl + "Service/Service.aspx?Process=" + encodeURIComponent(Encrypt("GET")) + "&Status=" + encodeURIComponent(Encrypt(Process)) + "&Search=" + encodeURIComponent(Encrypt((((Process == 3) || (Process == 4) || (Process == 5) || (Process == 6)) ? $('#txtSearch').val() : ""))) + "&USERID=" + encodeURIComponent(Encrypt(UID)) + "&PageIndex=" + encodeURIComponent(Encrypt(pageIndex)) + "&PageSize=" + encodeURIComponent(Encrypt(pageSize)) + "&ROLE=" + encodeURIComponent(Encrypt(PRID));
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
        url: hurl + "Service/ServiceAddTask.aspx?Process=" + encodeURIComponent(Encrypt("PENDINGTASKS")) +"&PORTERID=" + encodeURIComponent(Encrypt(PorterID)),
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


function ShowModalAddtask() {
    $('#addTask').modal({
        backdrop: 'static',
        keyboard: false
    })
    $('#addTask').modal('show');
}