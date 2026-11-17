var HomeReqIcon = ["tdReqNew", "tdReqPending", "tdReqAssigned", "tdReqInProc", "tdReqCompleted", "tdReqCancelled", "tdReqMap"];
$(document).ready(function () {
    SetParent();
})
function ClearSession() {
    sessionStorage.setItem('ID', null);
    sessionStorage.setItem('NAME', null);
    sessionStorage.setItem('PASSWORD', null);
    sessionStorage.setItem('ROLE', null);
    sessionStorage.setItem('EXPIRY', null);
}

function SetParent() {
    var Role = sessionStorage.getItem('ROLE'), Page = document.location.href.match(/[^\/]+$/)[0]; //, ImgDisabled = '<img src="../Images/ParentIcon/Disabled.PNG" style="position: absolute; margin-top: -30px;margin-left: 40px;" />';
    if (Role == null || Role.length == 0)
        Logout();
    else {
        if (ParentMenuService != null) {
            $.ajax({
                async: false,
                url: ParentMenuService + "Process=" + ((Page == "Home.aspx") ? "GETPARENTMENU" : "GETPARENTENABLED") + "&ROLE=" + Role,
                type: 'POST',
                data: 'pData',
                dataType: 'json',
                success: function (msg) {
                    if (Page == "Home.aspx") {
                        if (~msg[0].RESULT.indexOf("RequestParentIcon")) {
                            $.each(HomeReqIcon, function (index, value) {
                                $('#' + value).attr('onclick', '').css("cursor", "not-allowed");
                            });
                        }
                    }
                    else {
                        // $.each(msg[0].RESULT.split(','), function (key, value) {
                        //   $('#' + value).attr('onclick', '').css("cursor", "not-allowed");
                        // });
                        var Path = window.location.pathname.split('/');
                        var FolderName = Path[Path.length - 2],
                           CurrentParent = (FolderName == "Track") ? "TRACK" :
                                           (FolderName == "RequestNew") ? "REQUEST" :
                                           (FolderName == "Mapping") ? "ASSIGN TAG" :
                                           (FolderName == "Reports") ? "REPORTS" :
                                           (FolderName == "Master") ? "ADMIN" : "";

                        var Content = '', tr = '', IsOneandLast = false;

                        msg = $.grep(msg, function (element, index) {
                            return element.NAME != CurrentParent;
                        });
                        if (msg.length > 0) {

                            $.each(msg, function (key, value) {

                                tr = ((key > 0) && (key % 2 == 0)) ? "</tr><tr>" : ((key == 0) ? "<tr>" : "");
                                IsOneandLast = (msg.length == (key + 1));
                                Content += tr + "<td class='tdParentMenu' style='" + 'background-image: url("../Images/ParentIcon/' + value.IMAGE + '");' +
                                                 "' onclick='Redirect(" + '"' + value.REDIRECTTO + '"' + ");' id='" + value.ID + "' > <span class='ParentIconText'>" +
                                                   value.NAME + "</span> </td>" + ((IsOneandLast && (key % 2 == 0)) ? "<td class='DefaultParentIcon' onclick='return false;' id='Defalut" +
                                                    key + "' > </td>" : "") + ((IsOneandLast) ? "</tr>" : "");






                                /* Centralized */

                                //Content += tr + ((IsOneandLast && (key % 2 == 0)) ? "<td colspan='2' align='center'>  <table> <tbody> <tr>" : "") + "<td class='tdParentMenu' style='" + 'background-image: url("../Images/ParentIcon/' + value.IMAGE + '");' +
                                //                    "' onclick='Redirect(" + '"' + value.REDIRECTTO + '"' + ");' id='" + value.ID + "' > <span class='ParentIconText'>" +
                                //                    value.NAME + "</span> </td>" + ((IsOneandLast && (key % 2 == 0)) ? "</tr></tbody></table></td>" : "") + ((IsOneandLast) ? "</tr>" : "");


                            });
                        }
                        $('#TblOtherParent').html(Content);
                        //                        alert(Content);
                    }

                },
                error: function (msg) {
                    alert(msg.length);
                }

            });
        }
    }
}