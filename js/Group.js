//const { clearInterval } = require("timers");
var selLocTxt = '', selPorTxt = '', checkeditems = '';

function getArraydata(itms) {
    checkeditems = '';
    for (i = 0; i < itms.length; i++) {           
            checkeditems =   ( checkeditems + ((checkeditems == '') ? '' : ',') + ((itms[i]._properties._data.value)).toString()) ;
            }
    return checkeditems;
}
function getListdata(itms) {
    checkeditems = '';

    
    itms.forEach(function (item) {
      //  alert(item.get_value());
        checkeditems = (checkeditems + ((checkeditems == '') ? '' : ',') + ((item.get_value())).toString());
    });

    
    return checkeditems;
}

 
function DeleteClear(data,prs) {

    if (prs == 'DELETE') {
        if (data[0].RESULT.split("_")[0] === 'TRUE') {
            $('#LBLRequestResult').html('Group Deleted Successfully.'); CancelGroups();
            HideModalPopUp('addTask'); ShowModalPopUp('modalReqAlert');
            setTimeout("HideModalPopUp('modalReqAlert');", 3500);
            HideModalPopUp('modalReqAlert'); LoadTasks();
        }

    }
    else if (prs == 'LOAD') {
       /*   var  srval = data[0].RESULT.split(',');
      for (var i = 0; i < srval.length; i++) {                        
            ddlLocation.findItemByValue(srval[i]).set_enabled(false);
        } */
        srval = data[0].OUSERIDS.split(',');
         if(srval !='')
        for (var i = 0; i < srval.length; i++) {
            ddlPorter.findItemByValue(srval[i]).set_enabled(false);
        }
      
    }

}

function submitRequest() {
    var IsEdit = ((document.getElementById('HFERID').value).length > 0);
     
    if (txtGroup.val()=='') {
        txtGroup.focus();
        txtGroup.css('background-color', '#ff7171'); setTimeout(function () { txtGroup.css('background-color', 'white'); }, 2500);
    }
    else if (RadLstAddedLoc.get_items().get_count() < 1) {
        alert('loc');
        RadLstAddedLoc.focus();
        RadLstAddedLoc.css('background-color', '#ff7171'); setTimeout(function () { RadLstAddedLoc.css('background-color', 'white'); }, 2500);
    }
    else if (ddlPorter.get_checkedItems().length < 1) {
        RadComboPorter.focus();
        RadComboPorter.css('background-color', '#ff7171'); setTimeout(function () { RadComboPorter.css('background-color', 'white'); }, 2500);
    }

    else {
       
        if (IsEdit)
            UpdateGroup(getListdata(RadLstAddedLoc.get_items()), getArraydata(ddlPorter.get_checkedItems()), document.getElementById('HFERID').value);
        else
            InsertGroup(getListdata(RadLstAddedLoc.get_items()), getArraydata(ddlPorter.get_checkedItems()));
    }



}

 

function OnClientItemChecking(sender, eventArgs) {
  //  selPorTxt = sender.get_text();    
}
function OnClientDropDown(sender, eventArgs) {   
 //   ddlPorter.set_text(selPorTxt);
     
}
function LocationOnClientItemChecking(sender, eventArgs) {
 //   selLocTxt = sender.get_text();
    
}
function LocationOnClientDropDown(sender, eventArgs) {
 //   ddlLocation.set_text(selLocTxt);   
  
}
function LoadNewRequest() {
    var encProcess = encryptAES('LOCATIONGROUP');
    var encMode = encryptAES('USERGROUP');

    $.ajax({
        async: true,
        url: hurl + "Service/Service.aspx?Process=" + encProcess +
            "&Mode=" + encMode,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            se1 = data;
          //  ddlLocation.clearItems();
             
            ddlPorter._dataTextField = "VALUE";
            ddlPorter._dataValueField = "ID";
 

            for (var i = 0; i < data.length; i++) {
                var item = data[i];
                if (data[i].PROCESS == "USER") {                    

                    var comboItem1 = new Telerik.Web.UI.RadComboBoxItem();
                    comboItem1.set_text(data[i].VALUE);
                    comboItem1.set_value(data[i].ID);
                    comboItem1.set_imageUrl("https" + "://royalstokeapp.portzo.net/images/user.png");
                    comboItem1.allowcustomtext = "true"
                    ddlPorter.get_items().add(comboItem1);

 
                }
            }
           

          //  alert(ddlLocation.get_items().length);

        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}

function ClearEdit() {

   // ddlLocation.clearSelection();
    var   porItems = ddlPorter.get_checkedItems();
    checkeditems = '';
     
     

    for (j = 0; j < porItems.length; j++)
        porItems[j].set_checked(false);

}

function ClearDefGroup() {
    RadLstAddedLoc.trackChanges();
    RadLstAddedLoc.get_items().clear();
    RadLstAddedLoc.commitChanges();
    $('#txtFromLoc').val('');
    $("#suggesstionFrom").hide();
    $('#spnTex').html('');
}

function setNewTask() {
    $("#TaskHeader").html('Location Group'); $("#divEditRemarks").css("display", 'none');
    document.getElementById('HFERID').value = ""; document.getElementById('HFERNO').value = ""; document.getElementById('HFStatusID').value = "";
   // ddlLocation.get_items().getItem(0).set_checked(false);
   // ddlLocation.get_selectedItem().uncheck();
    ClearDefGroup();   
    ClearEdit();
    txtGroup.val('');
    clearLoctionPorter();
   

    /*if (items.length >0)
    ddlLocation.get_checkedItems().each(function () {
        var $item = $(this);
        // add the container class to the items
        $item.set_checked(false);
    });
    for (i = 0; i <= items.length; i++) {

   
        var comboItem = new Telerik.Web.UI.RadComboBoxItem();
        ddlLocation.trackChanges();
        ddlLocation.get_items().getItem(i).select();
        ddlLocation.commitChanges();

    } */  /*   ddlLocation.trackChanges();
        ddlLocation.get_items().getItem(i).set_checked(false);
        ddlLocation.commitChanges();
        alert(i);*/

}






 



function LoadTasks() {
    var encProcess = encryptAES('LOCATIONGROUP');
    var encMode = encryptAES('GET');

    var FinalUrl = hurl + "Service/Service.aspx?Process=" + encProcess + "&Mode=" + encMode;

    $.ajax({
        url: FinalUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var tblRequest = ' <table class="table scroll table-bordered"> <thead> <tr><th scope="col" style="width:120px;">Edit</th> <th scope="col" style="width:250px;"> Group Name </th>  </tr></thead > <tbody>';

            tblContent = '';

            if (data.length > 0) {

                $.each(data, function (key, value) {

                    var GPId = ((!value.GROUPID) ? "" : value.GROUPID.toString()),

                        GPName = ((!value.GROUPNAME) ? "" : value.GROUPNAME.toString()) 
                    tblContent += ' <tr><td>  <div class="add-task-link" onclick="setEditTask(' + "'" + GPId + "','" + GPName + "'" + ');"> <a href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#addTask" class="btn btn-primary"><img src="../images/memo.png" alt="Add Task">  </a> </div> </td>' +
                        '<td>' + GPName + '</td>' + ' </tr> ';


                });


            }
            tblRequest += tblContent + '</tbody > </table > '; $('#tblRoutineTasks').html(tblRequest);
        },
        error: function (data) {

        }

    });
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
var se1;

function clearSumo(ele) {

    var len = $('#' + ele + ' option').length;

    for (var i = len; i > 1; i--) {
        $('#' + ele)[0].sumo.remove(i - 1);
    }
}

function clearLoctionPorter() {    

     
    deleteRequest('LOAD');
}
 
function CancelGroups() {
    document.getElementById('HFERID').value = '';
}
 

function test() {
    // ddlLocation.clearSelection();
    ddlLocation.clearCache();
    ddlLocation._text = 'ff';
    ddlLocation._cachedText = "ll";
    ddlLocation._addEmptyMessageToClientState = true;
    ddlLocation._addEmptyMessageToClientState = false;
    ddlLocation._emptyMessage  ("SELECT LOCATION GROUP");
    //ddlLocation._emptyMessage   ("SELECT LOCATION GROUP");
    alert('l');
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

function deleteRequest(prs) {
    var encProcess = encryptAES('LOCATIONGROUP');
    var encGroupId = encryptAES(document.getElementById('HFERID').value);
    var encMode;

    if (prs === 'DELETE') {
        encMode = encryptAES('DELETE');
        var strqry = "Service/Service.aspx?Process=" + encProcess + "&Mode=" + encMode + "&GROUPID=" + encodeURIComponent(encGroupId);
    } else {
        encMode = encryptAES('CLEARLOCATIONGROUP');
        var strqry = "Service/Service.aspx?Process=" + encProcess + "&Mode=" + encMode;
    }

    $.ajax({
        async: true,
        url: hurl + strqry,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            DeleteClear(data, prs);


        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });

}

function InsertGroup(loc, por) {
    var UID = sessionStorage.getItem('ID');
    var encProcess = encryptAES('LOCATIONGROUP');
    var encMode = encryptAES('ADD');

    $.ajax({
        async: true,
        url: hurl + "Service/Service.aspx?Process=" + encProcess +
            "&Mode=" + encMode +
            "&GROUPNAME=" + encryptAES(txtGroup.val()) +
            "&LOCATIONIDS=" + encryptAES(loc) +
            "&USERIDS=" + encryptAES(por),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            if (data[0].RESULT.split("_")[0] === 'TRUE') {
                $('#LBLRequestResult').html('Group added successfully..');
                LoadTasks();
                HideModalPopUp('addTask');
                ShowModalPopUp('modalReqAlert');
                setTimeout(function () {
                    HideModalPopUp('modalReqAlert');
                }, 3500);
            } else if (data[0].RESULT.split("_")[0] === 'FALSE') {
                $('#LBLRequestResult').html('Group name already exists.');
                ShowModalPopUp('modalReqAlert');
            }
        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}


function encryptAES(plainText) {
    var key = CryptoJS.enc.Utf8.parse("9090909090909090");
    var iv = CryptoJS.enc.Utf8.parse("9090909090909090");

    var encrypted = CryptoJS.AES.encrypt(plainText, key, {
        iv: iv,
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7
    });

    return encodeURIComponent(encrypted.toString());
}


function UpdateGroup(locs, por, gid) {
    var UID = sessionStorage.getItem('ID');

    var encProcess = encryptAES('LOCATIONGROUP');
    var encMode = encryptAES('UPDATE');
    var encGroupName = encryptAES(txtGroup.val());
    var encLocs = encryptAES(locs);
    var encPor = encryptAES(por);
    var encGroupId = encryptAES(gid);

    var url = hurl + "Service/Service.aspx?Process=" + encProcess +
        "&Mode=" + encMode +
        "&GROUPNAME=" + encGroupName +
        "&LOCATIONIDS=" + encLocs +
        "&USERIDS=" + encPor +
        "&GROUPID=" + encGroupId;

    $.ajax({
        async: true,
        url: url,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            if (data[0].RESULT.split("_")[0] === 'TRUE') {
                $('#LBLRequestResult').html('Group Updated Successfully.');
                CancelGroups();
                HideModalPopUp('addTask');
                ShowModalPopUp('modalReqAlert');
                setTimeout(function () {
                    HideModalPopUp('modalReqAlert');
                }, 3500);
                LoadTasks();
            }
        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}


function SelectedLocated(gid) {
    var encProcess = encryptAES('LOCATIONGROUP');
    var encMode = encryptAES('SELECTEDLOCATIONGROUP');
    var encGroupId = encryptAES(gid);  

    RadLstAddedLoc.trackChanges();
    RadLstAddedLoc.get_items().clear();
    RadLstAddedLoc.commitChanges();

    $.ajax({
        async: true,
        url: hurl + "Service/Service.aspx?Process=" + encProcess +
            "&Mode=" + encMode +
            "&GROUPID=" + encGroupId,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            $.each(data, function (key, value) {
                var item = new Telerik.Web.UI.RadListBoxItem();
                item.set_imageUrl("../images/location.png");
                item.set_text(value.VALUE);
                item.set_value(value.ID);
                RadLstAddedLoc.get_items().add(item);
            });
        }
    });
}


function setEditTask(gid, gpn) {
    ClearDefGroup();
    ClearEdit();
    document.getElementById('HFERID').value = gid;
    txtGroup.val(gpn);
    var strVl = '', arOus = '';
    var encProcess = encryptAES('LOCATIONGROUP');
    var encMode = encryptAES('LOCATIONGROUP');
    var encGid = encryptAES(gid);

    $.ajax({
        async: true,
        url: hurl + "Service/Service.aspx?Process=" + encProcess +
            "&Mode=" + encMode +
            "&GROUPID=" + encGid,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var comboItem, srval = '';// data[0].RESULT.split(',');
           /* for (var i = 0; i < srval.length; i++) { 
                strVl = srval[i].split('_');
            //    ddlLocation.findItemByValue(strVl[0]).set_enabled(strVl[1] == 'true' ? true : false);
              //  ddlLocation.findItemByValue(strVl[0]).set_checked(strVl[1] == 'true' ? true : false);




             //   ddlLocation.findItemByValue(strVl).check();
              
            } */ SelectedLocated(gid);

            //  ddlLocation.set_cancel(true);
            srval = data[0].USERIDS.split(',');
            arOus = data[0].OUSERIDS.split(',');
            for (var i = 0; i < srval.length; i++) {
                ddlPorter.findItemByValue(srval[i]).set_enabled(true);
                ddlPorter.findItemByValue(srval[i]).set_checked(true);
            }
            if (data[0].OUSERIDS != '')
                for (var i = 0; i < arOus.length; i++) {

                    ddlPorter.findItemByValue(arOus[i]).set_enabled(false);

                }

        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });



    // ddlLocation.set_text("kljlk");
    // $('#RadComboLoc_ClientState').text('');
    // ddlLocation.set_emptyMessage("SELECT LOCATION GROUP");
    $("#TaskHeader").html('Group -' + gpn); $("#divEditRemarks").css("display", 'block');

}




function ShowModalPopUp(ModalId) {
    $('#' + ModalId).modal('show');
}
function HideModalPopUp(ModalId) {
    $('#' + ModalId).modal('hide');
}