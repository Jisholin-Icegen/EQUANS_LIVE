<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PopupGPS.aspx.cs" Inherits="Track_PopupGPS" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>TRACKING</title>
    <script type="text/javascript" src="../Scripts/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="../js/gpss.js"></script>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyC6M843tL7jQWMm3zSjXNF_piWnVu8Lp98&sensor=false"> </script>

    <script language="javascript" type="text/javascript">
        var hurl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + '/Track/',
            TID = getParameterByName('TagId'),// Reload = window.setInterval(GetImage, 2000),
            Name = getParameterByName('Name'),
            mapAPIKey = 'AIzaSyC6M843tL7jQWMm3zSjXNF_piWnVu8Lp98';

        $(document).ready(function () {
            //    $("#tdPorter").css('background-image', "url('../Images/Traczo.svg')");
            //    $("#tdPorter").css('background-size', "140px 140px !important;");  $('#imgPorter').attr("src", "" + Img + "");
            TID = getParameterByName('TagId');
            $(document).prop('title', 'TRACKING ' + Name + ' - GPS');
            GetImage(TID);
        });
        function ReloadPage() {
            //location.reload();
        }
        function GetImage() {
            var n = new Date(), daten = n.getDate() + '' + (n.getMonth() + 1) + '' + n.getFullYear() + '' + n.getTime() + '' + (n.getTime() + "" + n.getHours() + '' + n.getMinutes() + '' + n.getSeconds() + '' + n.getMilliseconds());
            $.ajax({
                async: true,
                url: hurl + "LocateGPS.aspx?Process=GETGPSDETAILS&DEVICEID=" + TID + "&CurrentTime=" + daten,
                type: 'POST',
                data: 'pData',
                dataType: 'json',
                success: function (data) {
                    if (data.length > 0) {
                        var GPS = data[0].RESULT.split("|$|");
                        var lat = GPS[0], long = GPS[1];
                        if (lat.length > 0 && long.length > 0)
                            ShowMap(lat, long);
                    }

                },
                error: function (data) {
                }

            });
        }


        var hval = 100;
        function zoomoutMap() {
            // alert(hval++ );

            //   $("#imgPorter").css('height', hval++ + '%');

        }
        function zoominMap() {
            // alert(hval++ );

            //  $("#imgPorter").css('height', hval-- + '%');

        }

        function changeValue(hval) {
            $("#imgPorter").css('height', hval++ + '%');

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
        .loadimg {
            background-image: url("../Images/Traczo.svg");
            background-size: 140px 140px !important;
        }

        .LocatePorter {
            margin-top: 15px;
            border-spacing: 0px;
            padding: 11px 0px;
            border-radius: 25px;
            moz-box-shadow: inset 0px 0px 35px 1px #0e7add;
            -moz-border-radius: 6px;
            -moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
            cursor: pointer background: rgba(238,222,210,1);
            font-weight: normal;
            -moz-border-radius: 6px;
            -moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
            -moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
            -webkit-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
            border-bottom: 1px solid rgba(0,0,0,0.25);
            position: relative;
            cursor: pointer background: rgba(238,222,210,1);
            background-color: #ffffff;
            /* background: rgba(28, 27, 43, 0.88);*/
        }

        #tdPorter {
            margin-bottom: 8px;
            background-repeat: no-repeat !important;
            background-position: center !important;
            background-size: contain !important;
            z-index: 10000;
            /*  background-size: 100% !important;*/
        }
    </style>
</head>
<body ondragstart="return false;" ondrop="return false;" ondragstart="return false;"
    ondrop="return false;">
    <div id="LocatePorter" align="center" class="LocatePorter" style="border-spacing: 0px; padding: 11px 0px; /* background-color: #f5f5f5 ! important; */
    border-radius: 25px; /* margin: 50px 0px; */
    /* box-shadow: inset 0px 0px 1px 0px rgb(52 61 84); */
    moz-box-shadow: inset 0px 0px 35px 1px #0e7add; /* box-shadow: 0px 0px 20px 1px #494f63; */
    /* box-shadow: inset 0px 0px 20px 1px #ff7400; */
    /* background-position: 0% 0%; */
    /* background-color: #0e7add; */
    /* background-image: linear-gradient(to bottom, #1fc4f0, #0e7add) !important; */
    /* background-repeat: repeat-x; */
    /* color: #ffffff !important; */
    /* text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25) !important; */
    /* background-attachment: scroll !important; */
    -moz-border-radius: 6px; /* -webkit-border-radius: 6px; */
    -moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6); /* -webkit-box-shadow: 0 1px 3px rgba(0,0,0,0.6); */
    /* border-bottom: 1px solid rgba(0,0,0,0.25); */
    /* position: relative; */
    cursor: pointer background: rgba(238,222,210,1); /* background-color: lightgray; */
    /* background-color: blue; */ /*#ffcc99; */
    /* padding: 5px 10px 6px; */
    /* color: Snow; */
    /* font-family: Courier New; */
    /* font-size: 16px; */
    font-weight: normal; /* text-decoration: none; */
    -moz-border-radius: 6px; /* -webkit-border-radius: 6px; */
    -moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6); /* -webkit-box-shadow: 0 1px 3px rgba(0,0,0,0.6); */
    /* border-bottom: 1px solid rgba(0,0,0,0.25); */
    -moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6); -webkit-box-shadow: 0 1px 3px rgba(0,0,0,0.6); border-bottom: 1px solid rgba(0,0,0,0.25); position: relative; cursor: pointer background: rgba(238,222,210,1); background-color: #ffffff;">
        <table style="/* height: 470px; */width: 98%; padding: 6px; moz-box-shadow: inset 0px 0px 35px 1px #0e7add; /* box-shadow: 0px 0px 10px 5px #ff7400; *//* box-shadow: inset 0px 0px 20px 1px #b5adad; */border-radius: -6px -6px 1px 1px; /* margin-top: -3px; */background: or; /* border-radius: 5px 5px 0 0; */border-radius: 10px 10px 10px 10px; background-position: 0% 0%; background-color: #0e7add; /* background-image: linear-gradient(to bottom, #1fc4f0, #0e7add) !important; */background-repeat: repeat-x; color: #ffffff !important; text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25) !important; background-attachment: scroll !important; /* background-image: linear-gradient(to bottom, #1fc4f0, #0e7add) !important; */">
            <tbody>
                <tr style="/* box-shadow: 0px 0px 20px 1px #494f63; */
    moz-box-shadow: inset 0px 0px 35px 1px #0e7add; /* box-shadow: 0px 0px 20px 1px #494f63; */
    /* box-shadow: inset 0px 0px 20px 1px #FF7400; */
    /* background-color: #FF7400; */
    /* border-radius: 25px 25px 1px 1px; */
    /* background-color: red; */">
                    <td valign="middle" style="text-align: center; moz-box-shadow: inset 0px 0px 35px 1px #0e7add; /* box-shadow: inset 0px 0px 20px 1px #ff7400; *//* box-shadow: inset 0px 0px 20px 1px #b5adad; *//* border-radius: 6px 25px 1px 1px; *//* background-color: #2196f3; */">
                        <table style="font-family: Poppins, sans-serif; font-size: 15px; font-weight: bold; height: 30px; width: 100%; z-index: 1111111; moz-box-shadow: inset 0px 0px 35px 1px #0e7add; /* box-shadow: inset 0px 0px 20px 1px #2196f3; *//* box-shadow: inset 0px 0px 20px 1px #b5adad; */box-shadow: 0px 0px 0px 2px #ffffff; border-radius: 10px 10px 0 0; background-position: 0% 0%; background-color: #0e7add; background-image: linear-gradient(to bottom, #1fc4f0, #0e7add) !important; background-repeat: repeat-x; color: #ffffff !important; text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25) !important; background-attachment: scroll !important;">
                            <tbody>
                                <tr style="">
                                    <td style="text-align: right
    /* box-shadow: inset 0px 0px 15px 1px #2196f3; */">PORTER NAME : </td>
                                    <td style="text-align: left; /* box-shadow: inset 0px 0px 15px 1px #fb8e67; */"><span id="spnPort" style="text-align: left;"></span></td>
                                    <td style="text-align: right;">LOCATION :</td>
                                    <td style="">
                                        <table style="width: 88%">
                                            <tr>
                                                <td style="text-align: left"><span id="spnLoc"></span></td>
                                                <td style="text-align: right"><span style="margin-left: 30px" onclick="zoomoutMap()">-</span>
                                                    <input type="range" min="101" max="200" value="100" onchange="changeValue(this.value);" />
                                                    <span style="margin-left: 5px" onclick="zoominMap()">+</span></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign="middle" class="loadimg" style="background-color: white; background-repeat: no-repeat; vertical-align: middle; background-position: center !important;">
                        <div>
                            <div id="tdPorter" style="height: 654px; vertical-align: middle; width: 900px; overflow: auto; text-align: center; margin: 0 auto; display: flex; vertical-align: middle; text-align: center;">
                            </div>
                        </div>
                    </td>
                </tr>
        </table>
    </div>
</body>
</html>
