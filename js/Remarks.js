function LoadPresetValues() {

    var encProcess = Encrypt('PRESET');

    $.ajax({
        url: hurl + "Service/Service.aspx?Process=" + encProcess +
            "&ACTION=" + encodeURIComponent(Encrypt("GET")) +
            "&MSG=" + encodeURIComponent(Encrypt("")) +
            "&GROUP=" + encodeURIComponent(Encrypt("")) +
            "=&ID=" + encodeURIComponent(Encrypt("")) +
            "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var Msg = $.grep(data, function (element, index) {
                return element.GROUPNAME == "MSG";
            });
            var Remarks = $.grep(data, function (element, index) {
                return element.GROUPNAME == "REMARKS";
            });

            var CReason = $.grep(data, function (element, index) {
                return element.GROUPNAME == "CREASON";
            });

            var FReason = $.grep(data, function (element, index) {
                return element.GROUPNAME == "FREASON";
            });


            var PReason = $.grep(data, function (element, index) {
                return element.GROUPNAME == "PREASON";
            });




            //clearSumoselect('drpRemarks');

            $('#drpRemarks').html(''); $('#drpRemarks')[0].sumo.add('0', '-SELECT-'); $('#drpRemarks')[0].sumo.reload();

            $('#drpCancelRemarks').html(''); $('#drpCancelRemarks')[0].sumo.add('0', '-SELECT-'); $('#drpCancelRemarks')[0].sumo.reload();

            $('#drpCompletedRemarks').html(''); $('#drpCompletedRemarks')[0].sumo.add('0', '-SELECT-'); $('#drpCompletedRemarks')[0].sumo.reload();

            $('#drpMsgTrack').html(''); $('#drpMsgTrack')[0].sumo.add('0', '-SELECT-'); $('#drpMsgTrack')[0].sumo.reload();

            $('#drpPorterRemarks').html(''); $('#drpPorterRemarks')[0].sumo.add('0', '-SELECT-'); $('#drpPorterRemarks')[0].sumo.reload();


            $.each(Msg, function (key, value) {

                $('#drpMsgTrack')[0].sumo.add(value.ID, value.MESSAGE);
            });
            $.each(Remarks, function (key, value) {
                $('#drpRemarks')[0].sumo.add(value.ID, value.MESSAGE);
            });

            $.each(CReason, function (key, value) {
                $('#drpCancelRemarks')[0].sumo.add(value.ID, value.MESSAGE);
            });
            $.each(FReason, function (key, value) {
                $('#drpCompletedRemarks')[0].sumo.add(value.ID, value.MESSAGE);
            });


            $.each(PReason, function (key, value) {
                $('#drpPorterRemarks')[0].sumo.add(value.ID, value.MESSAGE);
            });


            $('#drpRemarks')[0].sumo.selectItem(0); $('#drpCancelRemarks')[0].sumo.selectItem(0); $('#drpCompletedRemarks')[0].sumo.selectItem(0); $('#drpMsgTrack')[0].sumo.selectItem(0); $('#drpPorterRemarks')[0].sumo.selectItem(0);
        },
        error: function (data) {

        }

    });
}

function OnChangeDropdown(EleId, txtID, BtnId, DeleteID) {
    var drpValue = $('#' + EleId).val(), drpText = $("#" + EleId + " option:selected").text();
    $('#' + txtID).val((drpValue != '0') ? drpText : '');
    $('#' + BtnId).text((drpValue != '0') ? "Update" : 'Add');
    $('#' + DeleteID).css("visibility", (drpValue != '0') ? "visible" : 'hidden');

}

function clearSumoselect(eleID) {
    var num = $('#' + eleID + ' option').length;

    for (var i = num; i >= 1; i--)
        $('#' + eleID)[0].sumo.remove(i - 1);

}


function ADD(Btn, EleID, Group, DrpID, ImgID) {
    var Ele = document.getElementById(EleID), ID = $('#' + DrpID).val(), SpanID = '#txt' + $(Btn).attr('id');
    var Process = $.trim($(SpanID).text());
    var Action = (Process == 'Add') ? 'INSERT' : 'UPDATE';
    if (Ele.value.length <= 0) {
        Ele.focus();
        return false;
    }
    else {
        var encProcess = Encrypt('PRESET');

        $.ajax({
            url: hurl + "Service/Service.aspx?Process=" + encProcess +
                "&ACTION=" + encodeURIComponent(Encrypt(Action)) +
                "&MSG=" + encodeURIComponent(Encrypt(Ele.value)) +
                "&GROUP=" + encodeURIComponent(Encrypt(Group)) +
                "&ID=" + encodeURIComponent(Encrypt(ID)) +
                "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)),
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {

                $("#" + DrpID).html(''); $("#" + DrpID)[0].sumo.add('0', '-SELECT-'); $("#" + DrpID)[0].sumo.reload();
                $.each(data, function (key, value) {
                    $("#" + DrpID)[0].sumo.add(value.ID, value.MESSAGE);
                });
                $(Ele).val(''); $(SpanID).html('Add'); $('#' + ImgID).css('visibility', 'hidden');
            },
            error: function (data) {

            }

        });

    }
}


function DELETE(ImgID, Group, DrpID, txtID) {
    var ID = $('#' + DrpID).val(), Action = 'DELETE', SpanID = '#' + DrpID.replace("drp", "txtBtn");
    var textbox = document.getElementById(txtID);

    if (ID.length <= 0) {
        $('#' + DrpID).focus();
        return false;
    }
    else {
        var encProcess = Encrypt('PRESET');

        $.ajax({
            url: hurl + "Service/Service.aspx?Process=" + encProcess +
                "&ACTION=" + encodeURIComponent(Encrypt(Action)) +
                "&MSG=" + encodeURIComponent(Encrypt("")) +
                "&GROUP=" + encodeURIComponent(Encrypt(Group)) +
                "&ID=" + encodeURIComponent(Encrypt(ID)) +
                "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)),
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {

                $("#" + DrpID).html(''); $("#" + DrpID)[0].sumo.add('0', '-SELECT-'); $("#" + DrpID)[0].sumo.reload();
                $.each(data, function (key, value) {
                    $("#" + DrpID)[0].sumo.add(value.ID, value.MESSAGE);
                });
                $(textbox).val(''); $(SpanID).html('Add'); $('#' + ImgID).css('visibility', 'hidden');
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