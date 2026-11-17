<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PopupRequest.aspx.cs" Inherits="Track_PopupRequest" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>TRACKING</title>
    <script type="text/javascript" src="../Scripts/jquery-1.10.2.js"></script>
    <script language="javascript" type="text/javascript">
        var hurl = 'http://' + '<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + '/Track/',
            TID = getParameterByName('TagId'), Reload = window.setInterval(GetImage, 2000), Name = getParameterByName('Name'), Porter = getParameterByName('Porter'),
            Porter1 = '', Porter2 = '', Tag1 = '', Tag2 = '', PorterName1 = '', PorterName2 = '', TTID;

        $(document).ready(function () {
            $("#tdPorter").css('background-image', "url('../Images/Loading.gif')"); TID = getParameterByName('TagId'); Porter = getParameterByName('Porter');
            var TagArray = TID.split(","), NameArray = Name.split(","), PorterArray = Porter.split(",");
            Tag1 = TagArray[0];
            if (TagArray.length > 1)
                Tag2 = TagArray[1];
            PorterName1 = NameArray[0];
            if (NameArray.length > 1)
                PorterName2 = NameArray[1];
            Porter1 = "../Images/PORTER/" + PorterArray[0] + ".png";
            if (PorterArray.length > 1) {
                Porter2 = "../Images/PORTER/" + PorterArray[1] + ".png";
                $('#imgPorter2').css("visibility", "visible");
            }
            sessionStorage.setItem("CurrentPorter", "1");
            $(document).prop('title', 'TRACKING ' + PorterName1);
            $('#PName').text(PorterName1);
            $('#imgPorter1').attr("src", Porter1); $('#imgPorter2').attr("src", Porter2); $('#imgPorter1').css("border", "2px solid red");
            TTID = Tag1;
            GetImage(TTID);
        });
        function ReloadPage() {
            //location.reload();
        }
        function changePorter(Case) {
            var currentPorter = sessionStorage.getItem("CurrentPorter");

            switch (Case) {
                case "1":
                    sessionStorage.setItem("CurrentPorter", "1");
                    $('#imgPorter2').css("border", "none");
                    $('#imgPorter1').css("border", "2px solid red");
                    $(document).prop('title', 'TRACKING ' + PorterName1);
                    $('#PName').text(PorterName1); TTID = Tag1;
                    break;
                case "2":
                    sessionStorage.setItem("CurrentPorter", "2");
                    $('#imgPorter1').css("border", "none");
                    $('#imgPorter2').css("border", "2px solid red");
                    $(document).prop('title', 'TRACKING ' + PorterName2);
                    $('#PName').text(PorterName2); TTID = Tag2;
                    break;
            }
            GetImage(TTID);
        }
        function GetImage() {
            var n = new Date(), daten = n.getDate() + '' + (n.getMonth() + 1) + '' + n.getFullYear() + '' + n.getTime() + '' + (n.getTime() + "" + n.getHours() + '' + n.getMinutes() + '' + n.getSeconds() + '' + n.getMilliseconds());
            SetPorterDetails();
            $.ajax({
                async: true,
                url: hurl + "Locate.aspx?TagId=" + TTID + "&CurrentTime=" + daten,
                type: 'POST',
                data: 'pData',
                dataType: 'xml',
                success: function (data) {
                    var Img = $(data).find("IMAGE").text();
                    if (Img.length > 0)
                        $('#tdPorter').css("background-image", "URL('" + Img + "')");
                },
                error: function (data) {
                }

            });
        }


        function SetPorterDetails() {

            $.ajax({
                async: true,
                url: hurl + "Service/PopupInfo.aspx?Process=PORTERINFO&TAGID=" + TTID,
                type: 'POST',
                data: 'pData',
                dataType: 'json',
                success: function (data) {
                    $('#CLocation').text(data[0].LOCATION);
                },
                error: function (data) {

                }

            });
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
    </script>
    <style>
        .LocatePorter
        {
            margin-top: 15px;
            background: rgba(28, 27, 43, 0.88);
        }
        #tdPorter
        {
            margin: 8px;
            background-repeat: no-repeat !important;
            background-position: center !important;
            z-index: 100;
            background-size: 100% 98% !important;
        }
    </style>
</head>
<body ondragstart="return false;" ondrop="return false;" ondragstart="return false;"
    ondrop="return false;">
    <div id="LocatePorter" align="center" class="LocatePorter">
        <table style="height: 700; width: 95%;">
            <tr style="height: 170px">
                <td valign="middle" align="center">
                    <table width="90%" style="font-family: Monospace; font-weight: bold; font-size: 18px;
                        height: 125px; color: White;">
                        <tr>
                            <td align="left" valign="middle" style="width: 50%">
                                <table style="width: 90%; margin-left: 20px;">
                                    <tr>
                                        <td style="width: 140px;">
                                            PORTER NAME
                                        </td>
                                        <td style="width: 15px;" align="center">
                                            -
                                        </td>
                                        <td>
                                            <span id="PName" style="position: absolute; margin-top: -12px;"></span>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td align="left" valign="middle" style="width: 50%; vertical-align: middle;" rowspan="2"
                                align="center">
                                <table style="width: 60%; margin-left: 20px;">
                                    <tr>
                                        <td style="width: 190px;">
                                            <img id="imgPorter1" style="width: 50px; border-radius: 5px; cursor: pointer;" onclick="changePorter('1'); return false;" />
                                        </td>
                                        <td style="width: 190px;">
                                            <img id="imgPorter2" style="width: 50px; border-radius: 5px; cursor: pointer; visibility: hidden;"
                                                onclick="changePorter('2'); return false;" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="middle" style="width: 50%">
                                <table style="width: 90%; margin-left: 20px;">
                                    <tr>
                                        <td style="width: 190px;">
                                            CURRENT LOCATION -
                                        </td>
                                        <td>
                                            <span id="CLocation" style="position: absolute; margin-top: -12px;"></span>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="height: 500px">
                <td valign="middle" id="tdPorter">
                </td>
            </tr>
        </table>
    </div>
</body>
</html>
