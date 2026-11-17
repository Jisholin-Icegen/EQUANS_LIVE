
function RowClick(sender, eventArgs) {

    var MasterTable = sender.get_masterTableView();
    var row = MasterTable.get_dataItems()[eventArgs.get_itemIndexHierarchical()];
    var Name = row.getDataKeyValue("ROLENAME");
    var ID = row.getDataKeyValue("ID");
    var leftVal = ((screen.width - 1000) / 2) + 350;
    var topVal = (screen.height - 450) / 2;
    window.open('RoleDetailsMaster.aspx?mode=Edit&Id=' + ID + "&Name=" + Name, 'old9', 'width=680, height=640, left=' + leftVal + ',top=5,toolbar=no,location=no,directories=no,status=no,resizable=no');
    return false;

}
function EditLink(Name, ID) {
    var leftVal = ((screen.width - 1000) / 2) + 350;
    var topVal = (screen.height - 450) / 2;
    window.open('RoleDetailsMaster.aspx?mode=Edit&Id=' + ID + "&Name=" + Name, 'old9', 'width=680, height=640, left=' + leftVal + ',top=5,toolbar=no,location=no,directories=no,status=no,resizable=no');
    return false;

}
function New() {
    var leftVal = ((screen.width - 1000) / 2) + 350;
    var topVal = (screen.height - 450) / 2;
    window.open('RoleDetailsMaster.aspx?mode=New', 'old10', 'width=680, height=640, left=' + leftVal + ',top=5,toolbar=no,location=no,directories=no,status=no,resizable=no');
    return false;
}


function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function GetDetails() {
    $.ajax({
        async: true,
        url: AdminServiceUrl + "PROCESS=GETPAGESBYROLE&ROLEID=" + getParameterByName("Id"),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (msg) {
            $.each(msg, function (key, value) {
                TreeID += (TreeID.length > 0) ? "_" + value.TREEID : value.TREEID;
                $("#" + value.CONTROL + "Select").css("visibility", "visible");
            });
        },
        error: function (msg) {
            alert(msg.length);
        }

    });

}

function OnLoadUpdation() {
    var Mode = getParameterByName("mode"), Name = getParameterByName("Name"), Id = getParameterByName("Id");

    if ((Mode != "New") && (Name != "") && (Id != "")) {
        $("#TxtRoleName").val(Name);
        $("#Delete").css("display", ((Id !== "1") ? "inline-block" : "none"));
        GetDetails();
    }
    else {
        $("#Delete").css("display", "none");
        $("#TxtRoleName").focus();
    }
}

function SaveRole(sender, args) {
    sender.set_autoPostBack(false);
    var RoleName = $("#TxtRoleName");
    if ($.trim(RoleName.val()).length == 0) {
        RoleName.val('');
        RoleName.focus();
    }
    else {
        var RoleID = getParameterByName("Id");
        $.ajax({
            async: true,
            url: AdminServiceUrl + "PROCESS=SAVEROLE&ROLEID=" + ((RoleID == null) ? '' : RoleID) + "&ROLENAME=" + RoleName.val() + "&TREEID=" + TreeID,
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (msg) {
                if (msg[0].RESULT === 'TRUE') {
                    closeWindow();
                } else {
                    RoleName.val('');
                    RoleName.focus();
                }
            },
            error: function (msg) {
                alert(msg.length);
            }

        });
    }
}

function SelectPrivilage(Id, CurTreeId) {
    var Visible = $('#' + Id).css("visibility");
    $('#' + Id).css("visibility", ((Visible == "visible") ? "hidden" : "visible"));
    if (Visible == "hidden")
        TreeID += (TreeID.length > 0) ? "_" + CurTreeId : CurTreeId;
    else {
        TreeID = (TreeID.indexOf(CurTreeId + '_') >= 0) ? TreeID.replace(CurTreeId + '_', '') :
            (TreeID.indexOf('_' + CurTreeId) >= 0) ? TreeID.replace('_' + CurTreeId, '') : TreeID.replace(CurTreeId, '');
    }


}

function DeleteRole(sender, args) {
    sender.set_autoPostBack(false);
    var RoleID = getParameterByName("Id");
    if (confirm('Press ok if your are sure.')) {
        $.ajax({
            async: true,
            url: AdminServiceUrl + "PROCESS=DELETEROLE&ROLEID=" + ((RoleID == null) ? '' : RoleID),
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (msg) {
                if (msg[0].RESULT === 'TRUE')
                    closeWindow();
                else {
                    ShowModalPopUp('ModalErrorMsg'); setTimeout("HideModalPopUp('ModalErrorMsg');", 2000);
                }
            },
            error: function (msg) {
                alert(msg.length);
            }

        });
    }
} OnchangeUser

function OnchangeLocation(InputID, ContainerID) {
    var SearchVal = $('#' + InputID).val();

    var deptID = sessionStorage.getItem("DEPTID");

    $.ajax({
        async: true,
        url: MAUrl + "Process=GETDEPTLOCATION&LOCATION=" + SearchVal + "&DEPTID=" + deptID,
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
}

function OnchangeUser(InputID, ContainerID) {
    var SearchVal = $('#' + InputID).val();

    var deptID = sessionStorage.getItem("DEPTID");

    $.ajax({
        async: true,
        url: MAUrl + "Process=GETDEPTUSER&USER=" + SearchVal + "&DEPTID=" + deptID,
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
}

function OnchangePorter(InputID, ContainerID) {
    var SearchVal = $('#' + InputID).val();

    var deptID = sessionStorage.getItem("DEPTID");

    $.ajax({
        async: true,
        url: MAUrl + "Process=GETDEPTPORTER&PORTER=" + SearchVal + "&DEPTID=" + deptID,
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
}

function BindDeptLocation(Id, Location, Bed) {
    sessionStorage.setItem('DLOCID', Id);
    $('#txtLocation').val(Location);
    $('#DivLocContent').css('display', 'none');
}


function BindUserLocation(Id, UserName) {
    sessionStorage.setItem('DUSERID', Id);
    $('#txtUser').val(UserName);
    $('#DivUSERContent').css('display', 'none');
}

function BindPorterLocation(Id, PorterName) {
    sessionStorage.setItem('DPORTERID', Id);
    $('#txtPorter').val(PorterName);
    $('#DivPortContent').css('display', 'none');
}

function GET(DeptID, Process) {
    var ContainerID = (Process == 'LOCATION') ? "divLocation" : ((Process == 'USER') ? "divUsers" : (Process == 'PORTER') ? "divPorters" : '');


    $.ajax({
        async: true,
        url: MAUrl + "Process=GETDEPTDETAILS&DEPTID=" + DeptID + "&TABLE=" + Process,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var Table = "<table width='95%' cellpadding='5' cellspacing='5' style='border-collapse: collapse;border: 1px solid gray;margin-top: 10px;'> <tr style='border: 1px solid gray;height:25px;'> " +
                ((Process == 'LOCATION') ? "<td align='center'style='width:130px;border: 1px solid gray;vertical-align: middle;'> LOCATION NAME  </td> <td align='center'style='width:100px;border: 1px solid gray;vertical-align: middle;'> FLOOR </td> <td align='center'style='width:50px;border: 1px solid gray;vertical-align: middle;'> DELETE </td> " :
                ((Process == 'USER') ? "<td align='center'style='width:130px;vertical-align: middle;border: 1px solid gray'> USER NAME  </td> <td align='center'style='width:100px;border: 1px solid gray;vertical-align: middle;'> USERID </td> <td align='center'style='width:50px;vertical-align: middle;border: 1px solid gray'> DELETE </td> " :
                        (Process == 'PORTER') ? "<td align='center'style='width:130px;vertical-align: middle;border: 1px solid gray'> PORTERNAME  </td>  <td align='center'style='width:50px;vertical-align: middle;border: 1px solid gray'> DELETE </td> " : "")) + "</tr>";

            $.each(data, function (key, value) {

                var Col1 = (Process == 'LOCATION') ? value.LOCATION : ((Process == 'USER') ? value.USERNAME : (Process == 'PORTER') ? value.PORTERNAME : '');

                var Col2 = (Process == 'LOCATION') ? value.FLOOR : ((Process == 'USER') ? value['USER ID'] : '');


                Table += "<tr style='border: 1px solid gray;' > <td align='left' style='width:130px;border: 1px solid gray;vertical-align: middle;' > " + Col1 + "</td> " + ((Col2.length > 0) ? " <td align='center' style='width:130px;border: 1px solid gray;vertical-align: middle;' > " + Col2 + "</td> " : "") +
                    "<td align='center' style='border: 1px solid gray;vertical-align: middle;'> <img src='Images/Delete.png' style='cursor: pointer;outline: none;width: 30px;padding: 3px;vertical-align: middle;' onclick='DELETESDEPT(" + '"' + value.ID + '"' + ', "' + Process + '"' + ");return false;' /> </td> </tr>";

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


function ADD(txtID, Process) {
    var txtValue = $("#" + txtID).val();
    var ContainerID = (Process == 'LOCATION') ? "divLocation" : ((Process == 'USER') ? "divUsers" : (Process == 'PORTER') ? "divPorters" : '');

    if (txtValue.length == 0) {
        $("#" + txtID).focus(); return;
    } else {
        var DeptID = sessionStorage.getItem('DEPTID'), LocID = sessionStorage.getItem((Process == 'LOCATION') ? "DLOCID" : ((Process == 'USER') ? "DUSERID" : (Process == 'PORTER') ? "DPORTERID" : ''));
        $.ajax({
            async: true,
            url: MAUrl + "Process=UPDATEDEPT&DEPTID=" + DeptID + "&LOCID=" + LocID + "&TABLE=" + Process,
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {

                var Table = "<table width='95%' cellpadding='5' cellspacing='5' style='border-collapse: collapse;border: 1px solid gray;margin-top: 10px;'> <tr style='border: 1px solid gray;height:25px;'> " +
                    ((Process == 'LOCATION') ? "<td align='center'style='width:130px;border: 1px solid gray;vertical-align: middle;'> LOCATION NAME  </td> <td align='center'style='width:100px;border: 1px solid gray;vertical-align: middle;'> FLOOR </td> <td align='center'style='width:50px;border: 1px solid gray;vertical-align: middle;'> DELETE </td> " :
                        ((Process == 'USER') ? "<td align='center'style='width:130px;vertical-align: middle;'> USER NAME  </td> <td align='center'style='width:100px;'> USERID </td> <td align='center'style='width:50px;vertical-align: middle;'> DELETE </td> " :
                            (Process == 'PORTER') ? "<td align='center'style='width:130px;vertical-align: middle;'> PORTERNAME  </td>  <td align='center'style='width:50px;vertical-align: middle;'> DELETE </td> " : "")) + "</tr>";

                $.each(data, function (key, value) {

                    var Col1 = (Process == 'LOCATION') ? value.LOCATION : ((Process == 'USER') ? value.USERNAME : (Process == 'PORTER') ? value.PORTERNAME : '');

                    var Col2 = (Process == 'LOCATION') ? value.FLOOR : ((Process == 'USER') ? value['USER ID'] : '');


                    Table += "<tr style='border: 1px solid gray;' > <td align='left' style='width:130px;border: 1px solid gray;vertical-align: middle;' > " + Col1 + "</td> " + ((Col2.length > 0) ? " <td align='center' style='width:130px;border: 1px solid gray;vertical-align: middle;' > " + Col2 + "</td> " : "") +
                        "<td align='center' style='border: 1px solid gray;vertical-align: middle;'> <img src='Images/Delete.png' style='cursor: pointer;outline: none;width: 30px;padding: 3px;vertical-align: middle;' onclick='DELETESDEPT(" + '"' + value.ID + '"' + ', "' + Process + '"' + ");return false;' /> </td> </tr>";

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

function DELETESDEPT(Id, Process) {
    var ContainerID = (Process == 'LOCATION') ? "divLocation" : ((Process == 'USER') ? "divUsers" : (Process == 'PORTER') ? "divPorters" : '');
    var DeptID = sessionStorage.getItem('DEPTID');
    $.ajax({
        async: true,
        url: MAUrl + "Process=REMOVELOCATION&DEPTID=" + DeptID + "&LOCID=" + Id + "&TABLE=" + Process,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var Table = "<table width='95%' cellpadding='5' cellspacing='5' style='border-collapse: collapse;border: 1px solid gray;margin-top: 10px;'> <tr style='border: 1px solid gray;height:25px;'> " +
                ((Process == 'LOCATION') ? "<td align='center'style='width:130px;border: 1px solid gray;vertical-align: middle;'> LOCATION NAME  </td> <td align='center'style='width:100px;border: 1px solid gray;vertical-align: middle;'> FLOOR </td> <td align='center'style='width:50px;border: 1px solid gray;vertical-align: middle;'> DELETE </td> " :
                    ((Process == 'USER') ? "<td align='center'style='width:130px;vertical-align: middle;'> USER NAME  </td> <td align='center'style='width:100px;'> USERID </td> <td align='center'style='width:50px;vertical-align: middle;'> DELETE </td> " :
                        (Process == 'PORTER') ? "<td align='center'style='width:130px;vertical-align: middle;'> PORTERNAME  </td>  <td align='center'style='width:50px;vertical-align: middle;'> DELETE </td> " : "")) + "</tr>";

            $.each(data, function (key, value) {

                var Col1 = (Process == 'LOCATION') ? value.LOCATION : ((Process == 'USER') ? value.USERNAME : (Process == 'PORTER') ? value.PORTERNAME : '');

                var Col2 = (Process == 'LOCATION') ? value.FLOOR : ((Process == 'USER') ? value['USER ID'] : '');


                Table += "<tr style='border: 1px solid gray;' > <td align='left' style='width:130px;border: 1px solid gray;vertical-align: middle;' > " + Col1 + "</td> " + ((Col2.length > 0) ? " <td align='center' style='width:130px;border: 1px solid gray;vertical-align: middle;' > " + Col2 + "</td> " : "") +
                    "<td align='center' style='border: 1px solid gray;vertical-align: middle;'> <img src='Images/Delete.png' style='cursor: pointer;outline: none;width: 30px;padding: 3px;vertical-align: middle;' onclick='DELETESDEPT(" + '"' + value.ID + '"' + ', "' + Process + '"' + ");return false;' /> </td> </tr>";

            });
            Table += "</tr></table>";
            $('#' + ContainerID + '').html(Table);

            //$('#' + ContainerID).css('display', ((data.length > 0) ? 'block' : 'none'));


        },
        error: function (data) {

        }

    });

}



function closeWindow() {
    window.close();
    window.opener.location.reload();
}

function cancelWindow() {
    window.close();
}
function Redirect(RedirectTo) {
    window.location = RedirectTo;
}

function ShowModalPopUp(ModalId) {
    $('#' + ModalId).modal('show');
}
function HideModalPopUp(ModalId) {
    $('#' + ModalId).modal('hide');
}


function enableDeptValues() {
    $("#txtUser").prop("readonly", false); $("#DivUSERContent").html(''); $("#txtUser").css("cursor", "text");
    $("#txtLocation").prop("readonly", false); $("#DivLocContent").html(''); $("#txtLocation").css("cursor", "text");
    $("#txtPorter").prop("readonly", false); $("#DivPortContent").html(''); $("#txtPorter").css("cursor", "text");
}


function clearDeptValues() {
    $("#txtUser").val(''); $("#txtUser").prop("readonly", true); $("#divLocation").html(''); $("#txtUser").css("cursor", "not-allowed"); $("#divLocation").html('');
    $("#txtLocation").val(''); $("#txtLocation").prop("readonly", true); $("#DivLocContent").html(''); $("#txtLocation").css("cursor", "not-allowed"); $("#divUsers").html('');
    $("#txtPorter").val(''); $("#txtPorter").prop("readonly", true); $("#DivPortContent").html(''); $("#txtPorter").css("cursor", "not-allowed"); $("#divPorters").html('');
}