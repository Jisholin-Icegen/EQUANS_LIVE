function RGADDD(Btn, EleID, DrpID, ImgID, BURL) {
    var Ele = document.getElementById(EleID), ID = $('#' + DrpID).val().split('_')[0], Action = ($.trim($(Btn).text()) == 'ADD') ? 'INSERT' : 'UPDATE';
    var Is24Hrs = $('#chk24HRs').is(":checked");
    if (Ele.value.length <= 0) {
        Ele.focus();
        return false;
    }
    else {
        $.ajax({
            url: BURL + "/Master/Service/Service.aspx?Process=REQUESTGROUP&ACTION=" + Action + "&GROUP=" + Ele.value + "&ISACTIVE=" + ((Is24Hrs) ? "1" : "0") + "&ID=" + ID,
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {
                $("#" + DrpID).empty(); $("#" + DrpID).append($("<option     />").val('0').text('-SELECT-'));
                $.each(data, function (key, value) {
                    $("#" + DrpID).append($("<option     />").val(value.ID + "_" + value.ISACTIVE).text(value.GROUPNAME));
                });
                $(Ele).val(''); $(Btn).text('ADD'); $('#' + ImgID).css('visibility', 'hidden');
                $('#chk24HRs').attr('checked', false); RFclearDeptValues(); sessionStorage.setItem("DEPTID", "0");
            },
            error: function (data) {

            }

        });

    }
}
function RGDELETE(ImgID, DrpID, txtID, Btn, BURL) {

    var ID = $('#' + DrpID).val().split('_')[0], Action = 'DELETE';
    var textbox = document.getElementById(txtID);
    var Is24Hrs = $('#chk24HRs').is(":checked");

    if (ID.length <= 0) {
        $('#' + DrpID).focus();
        return false;
    }
    else {
        $.ajax({
            url: BURL + "/Master/Service/Service.aspx?Process=REQUESTGROUP&ACTION=" + Action + "&GROUP=&ISACTIVE=" + ((Is24Hrs) ? "1" : "0") + "&ID=" + ID,
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {
                $("#" + DrpID).empty(); $("#" + DrpID).append($("<option     />").val('0').text('-SELECT-'));
                $.each(data, function (key, value) {
                    $("#" + DrpID).append($("<option     />").val(value.ID + "_" + value.ISACTIVE).text(value.GROUPNAME));
                });
                sessionStorage.setItem("DEPTID", "0");
                $("#" + Btn).text('ADD'); $('#' + ImgID).css('visibility', 'hidden'); $(textbox).val('');
                $('#chk24HRs').attr('checked', false); sessionStorage.setItem("DEPTID", "0"); clearDeptValues();
            },
            error: function (data) {

            }

        });

    }
}


function ShowModalPopUp(ModalId) {
    $('#' + ModalId).modal('show');
}
function HideModalPopUp(ModalId) {
    $('#' + ModalId).modal('hide');
}


function Delete(id) {
    var confi = confirm('Press ok if your are sure.')
    if (confi == true)
        return true;
    else
        return false;
}

function LoadPresetValues(BURL) {
    $.ajax({
        url: BURL + "/Master/Service/Service.aspx?Process=REQUESTGROUP&ACTION=GET&GROUP=&ISACTIVE=&ID=",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            $("#drpDept").empty(); $("#drpDept").append($("<option     />").val('0').text('-SELECT-'));
            $.each(data, function (key, value) {
                $("#drpDept").append($("<option     />").val(value.ID + "_" + value.ISACTIVE + "_" + value.CANDELETE).text(value.GROUPNAME));
            });
        },
        error: function (data) {

        }

    });
}

function OnChangeDropdownRG(EleId, txtID, BtnId, DeleteID) {
    var valueDept = $('#' + EleId).val().split('_');
    var camDelete = (valueDept.length > 1) ? valueDept[2] : '0';
    var drpValue = valueDept[0], drpText = $("#" + EleId + " option:selected").text();
    $('#' + txtID).val((drpValue != '0') ? drpText : '');
    $('#' + BtnId).text((drpValue != '0') ? "UPDATE" : 'ADD');
    $('#' + DeleteID).css("visibility", (drpValue != '0' && camDelete == '1') ? "visible" : 'hidden');
    $('#chk24HRs').prop('checked', (valueDept[1] == '1'));
    sessionStorage.setItem("DEPTID", drpValue);
    if (drpValue == '0')
        RFclearDeptValues();
    else if (drpValue == '2') {
        GETRGroup(drpValue, "LOCATION");
        setReturnCalls();
    }
    else if (drpValue == '4') {
        GETRGroup(drpValue, "CATEGORY");
        setMRDCalls();
    }
    else {
        GETRGroup(drpValue, "LOCATION"); GETRGroup(drpValue, "USER"); GETRGroup(drpValue, "CATEGORY");
        RFenableDeptValues();
    }
}


function GetRG(DeptID, Process, BURL) {
    var ContainerID = (Process == 'LOCATION') ? "divLocation" : ((Process == 'USER') ? "divUsers" : (Process == 'CATEGORY') ? "divPorters" : '');


    $.ajax({
        async: true,
        url: BURL + "/Master/Service/Service.aspx?Process=GETRGDETAILS&DEPTID=" + DeptID + "&TABLE=" + Process,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var Table = "<table width='95%' cellpadding='5' cellspacing='5' style='border-collapse: collapse;border: 1px solid gray;margin-top: 10px;'> <tr style='border: 1px solid gray;height:25px;'> " +
                ((Process == 'LOCATION') ? "<td align='center'style='width:130px;border: 1px solid gray;vertical-align: middle;'> LOCATION NAME  </td> <td align='center'style='width:100px;border: 1px solid gray;vertical-align: middle;'> FLOOR </td> <td align='center'style='width:50px;border: 1px solid gray;vertical-align: middle;'> DELETE </td> " :
                    ((Process == 'USER') ? "<td align='center'style='width:130px;vertical-align: middle;border: 1px solid gray'> USER NAME  </td> <td align='center'style='width:100px;border: 1px solid gray;vertical-align: middle;'> USERID </td> <td align='center'style='width:50px;vertical-align: middle;border: 1px solid gray'> DELETE </td> " :
                        (Process == 'CATEGORY') ? "<td align='center'style='width:130px;vertical-align: middle;border: 1px solid gray'> CATEGORY  </td>  <td align='center'style='width:50px;vertical-align: middle;border: 1px solid gray'> DELETE </td> " : "")) + "</tr>";

            $.each(data, function (key, value) {

                var Col1 = (Process == 'LOCATION') ? value.LOCATION : ((Process == 'USER') ? value.USERNAME : (Process == 'CATEGORY') ? value.CATEGORYNAME : '');

                var Col2 = (Process == 'LOCATION') ? value.FLOOR : ((Process == 'USER') ? value['USER ID'] : '');


                Table += "<tr style='border: 1px solid gray;' > <td align='left' style='width:130px;border: 1px solid gray;vertical-align: middle;' > " + Col1 + "</td> " + ((Col2.length > 0) ? " <td align='center' style='width:130px;border: 1px solid gray;vertical-align: middle;' > " + Col2 + "</td> " : "") +
                    "<td align='center' style='border: 1px solid gray;vertical-align: middle;'> <img src='Images/Delete.png' style='cursor: pointer;outline: none;width: 30px;padding: 3px;vertical-align: middle;' onclick='DELETERG(" + '"' + value.ID + '"' + ', "' + Process + '"' + ");return false;' /> </td> </tr>";

            });
            Table += "</tr></table>";
            $('#' + ContainerID + '').html(Table);

            if (typeof (txtID) != 'undefined')
                $("#" + txtID).val('');
            //$('#' + ContainerID).css('display', ((data.length > 0) ? 'block' : 'none'));


        },
        error: function (data) {

        }

    });

}


function ADDRG(txtID, Process, BURL) {
    var txtValue = $("#" + txtID).val();
    var ContainerID = (Process == 'LOCATION') ? "divLocation" : ((Process == 'USER') ? "divUsers" : (Process == 'CATEGORY') ? "divPorters" : '');

    if (txtValue.length == 0) {
        $("#" + txtID).focus(); return;
    } else {
        var DeptID = sessionStorage.getItem('DEPTID'), LocID = sessionStorage.getItem((Process == 'LOCATION') ? "DLOCID" : ((Process == 'USER') ? "DUSERID" : (Process == 'CATEGORY') ? "DPORTERID" : ''));
        $.ajax({
            async: true,
            url: BURL + "/Master/Service/Service.aspx?Process=UPDATERG&DEPTID=" + DeptID + "&LOCID=" + LocID + "&TABLE=" + Process,
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {

                var Table = "<table width='95%' cellpadding='5' cellspacing='5' style='border-collapse: collapse;border: 1px solid gray;margin-top: 10px;'> <tr style='border: 1px solid gray;height:25px;'> " +
                    ((Process == 'LOCATION') ? "<td align='center'style='width:130px;border: 1px solid gray;vertical-align: middle;'> LOCATION NAME  </td> <td align='center'style='width:100px;border: 1px solid gray;vertical-align: middle;'> FLOOR </td> <td align='center'style='width:50px;border: 1px solid gray;vertical-align: middle;'> DELETE </td> " :
                        ((Process == 'USER') ? "<td align='center'style='width:130px;vertical-align: middle;'> USER NAME  </td> <td align='center'style='width:100px;'> USERID </td> <td align='center'style='width:50px;vertical-align: middle;'> DELETE </td> " :
                            (Process == 'CATEGORY') ? "<td align='center'style='width:130px;vertical-align: middle;'> CATEGORYNAME  </td>  <td align='center'style='width:50px;vertical-align: middle;'> DELETE </td> " : "")) + "</tr>";

                $.each(data, function (key, value) {

                    var Col1 = (Process == 'LOCATION') ? value.LOCATION : ((Process == 'USER') ? value.USERNAME : (Process == 'CATEGORY') ? value.CATEGORYNAME : '');

                    var Col2 = (Process == 'LOCATION') ? value.FLOOR : ((Process == 'USER') ? value['USER ID'] : '');


                    Table += "<tr style='border: 1px solid gray;' > <td align='left' style='width:130px;border: 1px solid gray;vertical-align: middle;' > " + Col1 + "</td> " + ((Col2.length > 0) ? " <td align='center' style='width:130px;border: 1px solid gray;vertical-align: middle;' > " + Col2 + "</td> " : "") +
                        "<td align='center' style='border: 1px solid gray;vertical-align: middle;'> <img src='Images/Delete.png' style='cursor: pointer;outline: none;width: 30px;padding: 3px;vertical-align: middle;' onclick='DELETERG(" + '"' + value.ID + '"' + ', "' + Process + '"' + ");return false;' /> </td> </tr>";

                });
                Table += "</tr></table>";
                $('#' + ContainerID + '').html(Table);

                $("#" + txtID).val('');
                //$('#' + ContainerID).css('display', ((data.length > 0) ? 'block' : 'none'));


            },
            error: function (data) {

            }

        });
    }
}


function DELETERG(Id, Process) {
    var ContainerID = (Process == 'LOCATION') ? "divLocation" : ((Process == 'USER') ? "divUsers" : (Process == 'CATEGORY') ? "divPorters" : '');
    var DeptID = sessionStorage.getItem('DEPTID');
    $.ajax({
        async: true,
        url: MAUrl + "Process=DELETERG&DEPTID=" + DeptID + "&LOCID=" + Id + "&TABLE=" + Process,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var Table = "<table width='95%' cellpadding='5' cellspacing='5' style='border-collapse: collapse;border: 1px solid gray;margin-top: 10px;'> <tr style='border: 1px solid gray;height:25px;'> " +
                ((Process == 'LOCATION') ? "<td align='center'style='width:130px;border: 1px solid gray;vertical-align: middle;'> LOCATION NAME  </td> <td align='center'style='width:100px;border: 1px solid gray;vertical-align: middle;'> FLOOR </td> <td align='center'style='width:50px;border: 1px solid gray;vertical-align: middle;'> DELETE </td> " :
                    ((Process == 'USER') ? "<td align='center'style='width:130px;vertical-align: middle;'> USER NAME  </td> <td align='center'style='width:100px;'> USERID </td> <td align='center'style='width:50px;vertical-align: middle;'> DELETE </td> " :
                        (Process == 'CATEGORY') ? "<td align='center'style='width:130px;vertical-align: middle;'> CATEGORY NAME  </td>  <td align='center'style='width:50px;vertical-align: middle;'> DELETE </td> " : "")) + "</tr>";

            $.each(data, function (key, value) {

                var Col1 = (Process == 'LOCATION') ? value.LOCATION : ((Process == 'USER') ? value.USERNAME : (Process == 'CATEGORY') ? value.CATEGORYNAME : '');

                var Col2 = (Process == 'LOCATION') ? value.FLOOR : ((Process == 'USER') ? value['USER ID'] : '');


                Table += "<tr style='border: 1px solid gray;' > <td align='left' style='width:130px;border: 1px solid gray;vertical-align: middle;' > " + Col1 + "</td> " + ((Col2.length > 0) ? " <td align='center' style='width:130px;border: 1px solid gray;vertical-align: middle;' > " + Col2 + "</td> " : "") +
                    "<td align='center' style='border: 1px solid gray;vertical-align: middle;'> <img src='Images/Delete.png' style='cursor: pointer;outline: none;width: 30px;padding: 3px;vertical-align: middle;' onclick='DELETERG(" + '"' + value.ID + '"' + ', "' + Process + '"' + ");return false;' /> </td> </tr>";

            });
            Table += "</tr></table>";
            $('#' + ContainerID + '').html(Table);

            //$('#' + ContainerID).css('display', ((data.length > 0) ? 'block' : 'none'));


        },
        error: function (data) {

        }

    });

}


function RFenableDeptValues() {
    $("#txtUser").prop("readonly", false); $("#DivUSERContent").html(''); $("#txtUser").css("cursor", "text");
    $("#txtLocation").prop("readonly", false); $("#DivLocContent").html(''); $("#txtLocation").css("cursor", "text");
    $("#txtPorter").prop("readonly", false); $("#DivPortContent").html(''); $("#txtPorter").css("cursor", "text");
}


function RFclearDeptValues() {
    $("#txtUser").val(''); $("#txtUser").prop("readonly", true); $("#divLocation").html(''); $("#txtUser").css("cursor", "not-allowed"); $("#divLocation").html('');
    $("#txtLocation").val(''); $("#txtLocation").prop("readonly", true); $("#DivLocContent").html(''); $("#txtLocation").css("cursor", "not-allowed"); $("#divUsers").html('');
    $("#txtPorter").val(''); $("#txtPorter").prop("readonly", true); $("#DivPortContent").html(''); $("#txtPorter").css("cursor", "not-allowed"); $("#divPorters").html('');
}

function setReturnCalls() {
    $("#txtLocation").prop("readonly", false); $("#DivLocContent").html(''); $("#txtLocation").css("cursor", "text");
    $("#txtUser").prop("readonly", true); $("#DivUSERContent").html(''); $("#txtUser").css("cursor", "not-allowed"); $("#divUsers").html('');
    $("#txtPorter").prop("readonly", true); $("#DivPortContent").html(''); $("#txtPorter").css("cursor", "not-allowed"); $("#divPorters").html('');
}
function setMRDCalls() {
    $("#txtLocation").prop("readonly", true); $("#DivLocContent").html(''); $("#divLocation").html(''); $("#txtLocation").css("cursor", "not-allowed");
    $("#txtUser").prop("readonly", true); $("#DivUSERContent").html(''); $("#txtUser").css("cursor", "not-allowed"); $("#divUsers").html('');
    $("#txtPorter").prop("readonly", false); $("#DivPortContent").html(''); $("#txtPorter").css("cursor", "text"); $("#divPorters").html('');
}


function OnchangeRG(InputID, ContainerID, BURL, Table) {
    var SearchVal = $('#' + InputID).val();

    var deptID = sessionStorage.getItem("DEPTID");
    if (SearchVal.length > 0) {
        $.ajax({
            async: true,
            url: BURL + "/Master/Service/Service.aspx?Process=SEARCHRG&VALUE=" + SearchVal + "&RGID=" + deptID + "&TABLE=" + Table,
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {

                if (data.length > 0)
                    $('#' + ContainerID + '').html(data[0].RESULT);

                $('#' + ContainerID).css('display', ((data.length > 0) ? 'block' : 'none'));


            },
            error: function (data) {

            }

        });
    } else
        $('#' + ContainerID).css('display', 'none');
}




function BindRGLocation(Id, Location, Bed) {
    sessionStorage.setItem('DLOCID', Id);
    $('#txtLocation').val(Location);
    $('#DivLocContent').css('display', 'none');
}


function BindRGUser(Id, UserName) {
    sessionStorage.setItem('DUSERID', Id);
    $('#txtUser').val(UserName);
    $('#DivUSERContent').css('display', 'none');
}

function BindRGPorter(Id, PorterName) {
    sessionStorage.setItem('DPORTERID', Id);
    $('#txtPorter').val(PorterName);
    $('#DivPortContent').css('display', 'none');
}
