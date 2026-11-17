<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RequestAlert.aspx.cs" Inherits="Track_Popup" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>REQUEST NO : #</title>
    <script type="text/javascript" src="../Scripts/jquery-1.10.2.js"></script>
    <link href="../Styles/style-tab.css" rel="stylesheet" />
    <script language="javascript" type="text/javascript">
        var Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=Base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9+/=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=Base64._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/rn/g,"n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}};                
        var hurl = 'http://' + '<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + '/Track/',
            Surl = 'http://' + '<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + '/Service/',
            RID = Base64.decode(getParameterByName('ReqId')), Reload = window.setInterval(ReloadPage, 2000), TAGID, USERID = sessionStorage.getItem('ID'), RequestNo, RequestStatusId, RequestStatus, Source, Destination, Halt1, Halt2, Category, Porter, Supporter, PImage, SImage, ReqPorter, StartTime, PETA, SETA, PCurLocation, SCurLocation, CImage, PortDetails;
        $(document).ready(function () {
            RID = Base64.decode(getParameterByName('ReqId')), USERID = getParameterByName('USERID');
            sessionStorage.setItem('CurReqIndex', 0); sessionStorage.setItem('NoOfRequest', RID.split("-").length);
            BindRequest('First'); $(document).prop('title', 'REQUEST NO : #' + RequestNo);
            GetImage(TAGID);
        });
        function SendAlert() {
            $.ajax({
                url: Surl + "Service.aspx?Process=ALERTPROCESS&AlertProcess=UPDATEALERT&ReqId=" + RID,
                type: 'POST',
                data: 'pData',
                dataType: 'json',
                success: function (data) {

                },
                error: function (data) {

                }

            });
            showDone();
        }
        function SendBuzzer() {
            var TagIDs = (STAGID && TAGID) ? (STAGID + "_" + TAGID) : (TAGID);
            $.ajax({
                url: Surl + "Service.aspx?Process=BUZZERALERT&TagIds=" + TagIDs,
                type: 'POST',
                data: 'pData',
                dataType: 'json',
                success: function (data) {
                },
                error: function (data) {

                }

            });
            showDone();
        }
        function showDone() {
            $find('mpDone').show();
            setTimeout("$find('mpDone').hide();", 1000);
        }
        function ShowWait() {
            var pnlWait = $find('MPWait');
            if (pnlWait != null) {
                $find('MPWait').show();
                setTimeout("$find('MPWait').hide();", 2000);
            }
        }
        function CancelRequest() {
            var CurId = GetRequest(''); USERID = sessionStorage.getItem('ID');
            $.ajax({
                url: Surl + "Service.aspx?Process=STATUSUPDATE" + "&Status=6&REQUEST=" + CurId + "&REMARKS=" + $('#TextCancelReason').val() + "&USERID=" + USERID + "",
                type: 'POST',
                data: 'pData',
                dataType: 'json',
                success: function (data) {
                    if (data[0].RESULT === 'TRUE') {
                        $find('mpCancel').hide(); $find('mpDone').show(); var Params = Base64.decode(getParameterByName('ReqId')); Params = Params.replace(((~Params.indexOf(CurId + "-")) ? (CurId + "-") : CurId), ""),
                         urlval = hurl + "RequestAlert.aspx?ReqId=" + Base64.encode(Params);
                        setTimeout("cancelDone('" + Params + "','" + urlval + "');", 1000);
                    }
                    else
                        alert('Failed');
                },

                error: function (data) {

                }

            });
        }
        function cancelDone(Request, location) {
            if (!Request.trim())
                window.open('', '_self').close();
            else
                window.location = location;
        }
        function GetRequest(Process) {
            var NoOfRequest = parseInt(sessionStorage.getItem('NoOfRequest')), CurReqIndex = parseInt(sessionStorage.getItem('CurReqIndex')), CurrentReq = '';
            switch (Process) {
                case "Next":
                    sessionStorage.setItem('CurReqIndex', ((CurReqIndex + 1) < NoOfRequest) ? (CurReqIndex + 1) : CurReqIndex);
                    break;
                case "Prev":
                    sessionStorage.setItem('CurReqIndex', (CurReqIndex > 0) ? CurReqIndex - 1 : CurReqIndex);
                    break;
                case "First":
                    sessionStorage.setItem('CurReqIndex', 0);
                    break;
            }
            CurrentReq = sessionStorage.getItem('CurReqIndex');
            RID = Base64.decode(getParameterByName('ReqId')).split("-")[CurrentReq]; $('#SpanCurReq').html((parseInt(CurrentReq) + 1) + '/' + NoOfRequest);
            return RID;
        }
        function SetNextPrevVisible() {
            var NoOfRequest = parseInt(sessionStorage.getItem('NoOfRequest')), CurReqIndex = parseInt(sessionStorage.getItem('CurReqIndex')), PrevImg = $('#ImgPrev'), NextImg = $('#ImgNext');
            if (NoOfRequest == 1) {
                NextImg.css("visibility", "hidden");
                PrevImg.css("visibility", "hidden");
            } else {
                NextImg.css("visibility", (((CurReqIndex + 1) < (NoOfRequest)) ? "visible" : "hidden"));
                PrevImg.css("visibility", (((CurReqIndex) > 0) ? "visible" : "hidden"));
            }
        }
        function BindRequest(Process) {
            var CId = GetRequest(Process); RID = CId; 
            GetRequestData(CId);
        }
        function GetRequestData(RequestID) {
            $.ajax({
                async: false,
                url: Surl + "Service.aspx?Process=GETPOPUPDETAILS&REQID=" + RequestID,
                type: 'POST',
                data: 'pData',
                dataType: 'json',
                success: function (data) {
                    if (data.length == 0) {
                        window.close();
                    }
                    else {
                        TAGID = data[0].TAGID, STAGID = data[0].STAGID, RequestNo = data[0].REQEUSTNO; RequestStatusId = data[0].REQUESTSTATUSID; RequestStatus = data[0].STATUS; StartTime = data[0].STARTTIME; ReqPorter = data[0].REQPORTER; Source = data[0].SOURCE; Destination = data[0].DEST; PCurLocation = data[0].PCURRENTLOCATION; SCurLocation = data[0].SPCURRENTLOCATION; CImage = data[0].CATEGORYIMG;
                        Halt1 = data[0].HALT1; Halt2 = data[0].HALT2; Category = data[0].CATEGORY; Porter = data[0].PORTER; Supporter = data[0].SUPPORTER; PImage = data[0].STRPIMAGE; SImage = data[0].STRSPIMAGE; // PortDetails =(Porter)?( (Supporter)? ( Porter+ " & " +Supporter): Porter ):'';
                        $('#tdStatus').html(RequestStatus); $('#tdSource').html(Source); $('#tdDest').html(Destination); $('#tdCategory').html(Category); $('#SPLOC').html(SCurLocation); $('#PLOC').html(PCurLocation);
                        $('#ImgPorter1').attr("src", ((!PImage) ? "../Images/PORTER/PorterUnassigned.png" : PImage)); $('#ImgPort1').attr("src", ((!PImage) ? "../Images/PORTER/PorterUnassigned.png" : PImage)); $('#ImgPorter2').attr("src", ((!SImage) ? "../Images/PORTER/PorterUnassigned.png" : SImage)); $('#ImgPort2').attr("src", ((!SImage) ? "../Images/PORTER/PorterUnassigned.png" : SImage)); // $('#tablePorter').css("display",(!PImage)?"none":"table");
                        $('#tableSupporter').css("display", ((!SImage) && (ReqPorter != '2')) ? "none" : "table"); $('#ImgPort2').css("display", ((!SImage) && (ReqPorter != '2')) ? "none" : "block");$('#ImgPort1').css("display", (!PImage) ? "none" : "block"); $('#imgCategory').attr("src", "../CatImages/" + CImage);
                        $('#tdReqPorter').html(ReqPorter); $('#tdPName').html(Porter); $('#tdSPName').html(Supporter); $('#tdReqNo').html('#' + RequestNo); $('#tdPorter').css("background-image",((parseInt(RequestStatusId) < 3)) ?"url('../Images/PORTER/Unassigned.gif')": "url('../Images/LOCATE/105464230630_500x1000.png')"); SetETA();
                        $('#TdAlertProcess').css("display", ((RequestStatusId != '3')) ? "none" : "table-cell");SetNextPrevVisible();  $('#tablePorter').css("visibility", ((parseInt(RequestStatusId) >= 3)) ? "visible" : "hidden"); $('#tableSupporter').css("visibility", ((parseInt(RequestStatusId) >= 3)) ? "visible" : "hidden"); $('#DivImgPort1').css("visibility", ((parseInt(RequestStatusId) >= 3)) ? "visible" : "hidden"); $('#DivImgPort2').css("visibility", ((parseInt(RequestStatusId) >= 3)) ? "visible" : "hidden"); 
                    }
                },
                error: function (data) {

                }

            });
            $('#tableHome').css("visibility", "visible");

        }
        function SetETA() {
            $.ajax({
                async: false,
                url: Surl + "Service.aspx?Process=GETETA&REQID=" + RID.split("-")[0],
                type: 'POST',
                data: 'pData',
                dataType: 'json',
                success: function (data) {
                    PETA = data[0].PETA; $('#PETA').html(PETA);
                    SETA = data[0].SETA; $('#SPETA').html(SETA);
                },
                error: function (data) {

                }

            });
        }
        function ReloadPage() {
            //            location.reload();
        }
        function GetImage() {
            var d = new Date();
            $.ajax({
                async: false,
                url: hurl + "Locate.aspx?TagId=" + TAGID,
                type: 'POST',
                data: 'pData',
                dataType: 'xml',
                success: function (data) {
                    if ($(data).find("IMAGE").text().length > 0)
                        $('#ImgPorter').attr("src", $(data).find("IMAGE").text());
                },
                error: function (data) {

                }

            });
        }
        function getParameterByName(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, "/$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, " "));
        }
        function PopupCancel() {
            $find('mpCancel').show();
            $('#TextCancelReason').focus();
        }
    </script>
    <style type="text/css">
        
        .Title
        {
            width: 150px;
            font-family: Calibri;
            font-size: 15px;
            font-weight: bold;
            text-transform: uppercase;
            color: #000000;
        }
        .style2
        {
            width: 7px;
        }
       
        .Value
        {
            font-family:"segoe ui",arial,sans-serif; /*Calibri; */
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
            color: #000000;
        }
        .Background
        {
            background-color: rgba(49, 26, 53, 0.61);/*background-color: rgba(125, 63, 91, 0.61);*/
        }
        .BtnAlert, .BtnCancel
        {
            background: #ffffff;
            background-image: -webkit-linear-gradient(top, #ffffff, #ffffff);
            background-image: -moz-linear-gradient(top, #ffffff, #ffffff);
            background-image: -ms-linear-gradient(top, #ffffff, #ffffff);
            background-image: -o-linear-gradient(top, #ffffff, #ffffff);
            background-image: linear-gradient(to bottom, #ffffff, #ffffff);
            -webkit-border-radius: 23;
            -moz-border-radius: 23;
            border-radius: 23px;
            text-shadow: 1px 1px 4px #baabb2;
            -webkit-box-shadow: 0px 1px 3px #666666;
            -moz-box-shadow: 0px 1px 3px #666666;
            box-shadow: 0px 1px 3px #666666;
            font-family: Courier New;
            color: #7d3f5b;
            font-size: 16px;
            font-weight: bold;
            padding: 8px 15px 8px 15px;
            border: solid #ffffff 2px;
            text-decoration: none;
            outline: none;
        }
        
        .BtnAlert:hover
        {
            background: #7d3f5b;
            background-image: -webkit-linear-gradient(top, #7d3f5b, #7d3f5b);
            background-image: -moz-linear-gradient(top, #7d3f5b, #7d3f5b);
            background-image: -ms-linear-gradient(top, #7d3f5b, #7d3f5b);
            background-image: -o-linear-gradient(top, #7d3f5b, #7d3f5b);
            background-image: linear-gradient(to bottom, #7d3f5b, #7d3f5b);
            text-decoration: none;
            color: #FFFFFF;
            cursor: pointer;
        }
        .BtnCancel:hover
        {
            background: red;
            background-image: -webkit-linear-gradient(top, #7d3f5b, #7d3f5b);
            background-image: -moz-linear-gradient(top, #7d3f5b, #7d3f5b);
            background-image: -ms-linear-gradient(top, #7d3f5b, #7d3f5b);
            background-image: -o-linear-gradient(top, #7d3f5b, #7d3f5b);
            background-image: linear-gradient(to bottom, #7d3f5b, #7d3f5b);
            text-decoration: none;
            color: #FFFFFF;
            cursor: pointer;
        }
              @-webkit-keyframes blackWhite {  
              100% { background-color: rgba(250, 250, 250, 0.61);color: #423843; }
              }
              
              @-webkit-keyframes VioletFn {  
              100% { background-color:rgba(49, 26, 53, 0.61);color: #7d3f5b; }
              }
              
        #tdStatus
        {
            height: 100px;
            padding:8px 13px 8px 13px;
            background-color: rgba(49, 26, 53, 0.61); /* rgba(125, 63, 91, 0.61);*/
            -webkit-animation-name: blackWhite;
            -webkit-animation-iteration-count: infinite;
            -webkit-animation-duration: 1s;
        }
        #ImgPrev:hover,#ImgNext:hover
        {
            background-color:#FFFFFF;
            cursor:pointer;
        }
             #DivImgPort1 {
            position: relative;
            display: inline-block;
            padding:8px;
            margin:8px;
            border-radius:75px;
            z-index: 1;
            -webkit-animation-name: VioletFn;
            -webkit-animation-iteration-count: infinite;
            -webkit-animation-duration: 1s;
        }
        #ImgETA,#ImgETA1 {
            position: relative;
            display: inline-block;
            padding:6px 5px;
            border-radius:75px;
            z-index: 1;
            background-color: rgba(250, 250, 250, 0.61);
           /* -webkit-animation-name: blackWhite;
            -webkit-animation-iteration-count: infinite;
            -webkit-animation-duration: .1s;*/
        }
        
        #ImgCurMap,#ImgCurMap1 {
            background-color: rgba(250, 250, 250, 0.61);
            position: relative;
            display: inline-block;
            padding:6px 6px;
            margin:8px;
            border-radius:75px;
            z-index: 1;
            /*-webkit-animation-name: blackWhite;
            -webkit-animation-iteration-count: infinite;
            -webkit-animation-duration: .1s;*/
        }
         
    </style>
</head>
<body ondragstart="return false;" ondrop="return false;" ondragstart="return false;" ondrop="return false;">
    <form id="form1" runat="server" autocomplete="off webauthn">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div id="LocatePorter" align="center" class="Background">
        <table width="970" id="tableHome" style="visibility: hidden">
            
            <tr>
                <td valign="middle" align="center" style="padding: 5px; width: 5%">
                    <img id="ImgPrev" style="width: 35px; border-radius: 75px; -ms-transform: rotate(180deg);
                        box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.75); -webkit-transform: rotate(180deg);
                        transform: rotate(180deg);" onclick="ShowWait();BindRequest('Prev');" src="../Images/PORTER/Arrow.png" />
                </td>
                <td align="center" style="padding: 5px; width: 90%;">
                    <table style="height: 400px; width: 100%; min-width: 830px; box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.75);
                        padding: 5px; border-radius: 8px;">
                        <tr>
                            <td id="tdPorter" valign="top" style="background-color: White; cursor: pointer; border-radius: 25px;
                                background-image: url('../Images/Loading.png'); background-repeat: no-repeat;
                                background-position: center; background-size: 100% 100%;" class="Value">
                                <div id="DivImgPort1">
                                    <img id="ImgPort1" style="width: 35px; height: 35px; border-radius: 75px; border: 5px solid white;
                                        float: left" />
                                </div>
                                <div id="DivImgPort2">
                                    <img id="ImgPort2" style="width: 35px; height: 35px; border-radius: 75px; border: 5px solid white;
                                        float: right; position: relative; top: -60px; right: 20px;" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
                <td valign="middle" align="center" style="padding: 5px; width: 5%;">
                    <img id="ImgNext" style="width: 35px; border-radius: 75px; box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.75)"
                        src="../Images/PORTER/Arrow.png" onclick="ShowWait();BindRequest('Next');" />
                </td>
            </tr>
            <tr style="height: 200px;">
                <td colspan="3">
                    <table width="100%">
                        <tr>
                            <td>
                                <table id="tablePorter" style="width: 100%; min-width: 220px; max-width: 220px; height: 235px;
                                    color: White; font-weight: bold; font-size: 15px;" cellpadding="2px" cellspacing="2px"
                                    class="Value">
                                    <tr style="display: table-row; color: white; height: 30px;">
                                        <td id="tdPName" style="padding-left: 53px;" colspan="3">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" style="padding-left: 53px;">
                                            <img id="ImgPorter1" style="width: 60px; height: 60px; border-radius: 75px; position: relative;
                                                top: 10px; border: 5px solid white;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="3">
                                            <table cellpadding="3px;" width="100%" style="margin-top: -20px;">
                                                <tr>
                                                    <td align="center">
                                                        <table style="display: table; width: 100%">
                                                            <tr>
                                                                <td align="center">
                                                                    <span class="value" style="font-size: 8pt; font-weight: bold; color: White;">E T A</span>
                                                                </td>
                                                            </tr>
                                                            <tr style="height: 40px;">
                                                                <td>
                                                                    <img id="ImgETA" style="width: 30px; border-radius: 75px;" src="../Images/PORTER/ETA.png" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td align="center">
                                                        <table style="display: table;">
                                                            <tr>
                                                                <td align="center">
                                                                    <span class="value" style="font-size: 8pt; font-weight: bold; color: White; position: relative;
                                                                        top: 5px;">C L</span>
                                                                </td>
                                                            </tr>
                                                            <tr style="height: 40px;">
                                                                <td>
                                                                    <img id="ImgCurMap" style="width: 25px; height: 25px; border-radius: 75px;" src="../Images/PORTER/map.png" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td id="PETA" align="center" valign="middle" style="position: relative; top: -15px;">
                                                    </td>
                                                    <td id="PLOC" align="center" style="min-width: 130px; width: 75%; position: relative;
                                                        top: -15px;" valign="middle">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <table class="Value" style="width: 100%; max-width: 565px; height: 180px; margin-left: -30px;">
                                    <tr>
                                        <td colspan="4" align="left">
                                            <table cellpadding="5" cellspacing="5" style="width: 100%; max-width: 580px; box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.75);
                                                border-radius: 8px; border-collapse: seperate;">
                                                <tr style="height: 40px; font-size: 16px; border-radius: 8px 8px 0px 0px;">
                                                    <th colspan="2" align="center">
                                                        <div style="width: 103.5%; border-collapse: collapse; border-bottom: 5px solid rgba(255, 255, 255, 0.59);
                                                            margin-left: -10px; padding-bottom: 8px;">
                                                            <table style="width: 100%;">
                                                                <tr>
                                                                    <td>
                                                                        <table style="margin-left: 30px;">
                                                                            <tr>
                                                                                <td id="tdReqNo" style="width: 30px; height: 30px; background-color: rgba(255, 255, 255, 0.59);
                                                                                    border-radius: 75px; box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.75); padding: 5px;
                                                                                    border-collapse: collapse; font-size: 18px; color: #2a212b;" align="center">
                                                                                </td>
                                                                                <td align="left">
                                                                                    <span style="padding-left: 12px; padding-right: 12px; font-size: 25px; color: White;">
                                                                                        -</span> <span id="tdStatus" style="font-size: 17px; box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.75);
                                                                                            border-collapse: collapse; color: White;"></span>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                    <td id="TdAlertProcess" style="background-color: rgba(233, 231, 234, 0.94); border-radius: 8px;
                                                                        display: none; width: 25%;" align="center">
                                                                        <table align="center" style="height: 45px;">
                                                                            <tr>
                                                                                <td align="center" valign="middle" style="min-width: 40px">
                                                                                    <asp:ImageButton ID="ImgAlert" class="Category" Style="cursor: pointer; height: 25px;
                                                                                        width: 25px;" ImageUrl="../Images/PORTER/Alert.png" OnClientClick="SendAlert();return false;"
                                                                                        runat="server" ToolTip="ALERT" ClientIDMode="Static" />
                                                                                </td>
                                                                                <td align="center" valign="middle" style="min-width: 40px">
                                                                                    <asp:ImageButton ID="ImgBuzzer" class="Category" Style="cursor: pointer; height: 25px;
                                                                                        width: 25px;" ImageUrl="../Images/PORTER/Buzzer.png" OnClientClick="SendBuzzer();return false;"
                                                                                        runat="server" ToolTip="BUZZER" ClientIDMode="Static" />
                                                                                </td>
                                                                                <td align="center" valign="middle" style="min-width: 40px">
                                                                                    <asp:ImageButton ID="ImgClose" class="Category" runat="server" Style="cursor: pointer;
                                                                                        height: 25px; width: 25px;" ImageUrl="../Images/close.png" OnClientClick="PopupCancel();return false;"
                                                                                        ToolTip="CANCEL" ClientIDMode="Static" />
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </th>
                                                </tr>
                                                <tr>
                                                    <td style="width: 45%; min-width: 550px;" align="center">
                                                        <table style="width: 98%">
                                                            <tr>
                                                                <td id="tdSource" class="Value" align="right" style="width: 40%; font-size: 15px;
                                                                    min-width: 150px; color: White; padding-right: 43px;">
                                                                </td>
                                                                <td align="center">
                                                                    <table width="100%">
                                                                        <tr>
                                                                            <td align="left" style="width: 30px; background-image: url('../Images/PORTER/To.png');
                                                                                background-repeat: no-repeat; background-position: center; background-size: 80% 60%;">
                                                                                <img id="imgCategory" style="height: 25px; width: 25px; padding: 8px; border-radius: 75px;
                                                                                    background-color: White; border: 5px solid #817283; -webkit-box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.75);
                                                                                    -moz-box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.75); box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.75);
                                                                                    position: relative; left: -30px;" />
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td id="tdDest" class="Value" align="left" style="width: 40%; min-width: 150px; font-size: 15px;
                                                                    color: White; padding-left: 10px;">
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <table id="tableSupporter" style="width: 100%; min-width: 220px; max-width: 220px;
                                    height: 235px; margin-top: -20px; color: White; font-weight: bold; font-size: 15px;"
                                    cellpadding="2px" cellspacing="2px" class="Value">
                                    <tr style="display: table-row; color: white; height: 30px;">
                                        <td id="tdSPName" style="padding-left: 50px;" colspan="3">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" style="padding-left: 53px;">
                                            <img id="ImgPorter2" style="width: 60px; height: 60px; border-radius: 75px; position: relative;
                                                top: 10px; border: 5px solid white;" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center" colspan="3">
                                            <table cellpadding="3px;" width="100%" style="margin-top: -20px;">
                                                <tr>
                                                    <td align="center">
                                                        <table style="display: table; width: 100%">
                                                            <tr>
                                                                <td align="center">
                                                                    <span class="value" style="font-size: 8pt; font-weight: bold; color: White;">E T A</span>
                                                                </td>
                                                            </tr>
                                                            <tr style="height: 40px;">
                                                                <td>
                                                                    <img id="ImgETA1" style="width: 30px; border-radius: 75px;" src="../Images/PORTER/ETA.png" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <td align="center">
                                                        <table style="display: table;">
                                                            <tr>
                                                                <td align="center">
                                                                    <span class="value" style="font-size: 8pt; font-weight: bold; color: White; position: relative;
                                                                        top: 5px;">C L</span>
                                                                </td>
                                                            </tr>
                                                            <tr style="height: 40px;">
                                                                <td>
                                                                    <img id="ImgCurMap1" style="width: 25px; height: 25px; border-radius: 75px;" src="../Images/PORTER/map.png" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td id="SPETA" align="center" valign="middle" style="position: relative; top: -15px;">
                                                    </td>
                                                    <td id="SPLOC" align="center" style="min-width: 130px; width: 75%; position: relative;
                                                        top: -15px;" valign="middle">
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
    <asp:Panel ID="PanelCancel" runat="server" align="center" Style="display: none; width: 20%;
        min-width: 280px;">
        <div id="DivCancel" clientidmode="Static" align="center" runat="server" class="Shadow">
            <div class="header" align="center" style="height: 15px;">
                <table width="100%" style="margin-top: -6px;">
                    <tr>
                        <td width="20%">
                        </td>
                        <td align="center">
                            <asp:Label ID="LblCancelHeadaer" runat="server" Font-Size="14px" ClientIDMode="Static"
                                CssClass="Configheader"> REASON FOR CANCEL </asp:Label>
                        </td>
                        <td width="20%">
                            <asp:ImageButton ID="BtnCloseCancel" runat="server" ImageUrl="~/Images/close.png"
                                Style="cursor: pointer; float: right; margin-right: 8px; width: 15px; height: 15px;">
                            </asp:ImageButton>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="headFoot" style="height: 0px; margin-top: -2px;">
            </div>
            <div id="DivCancelContent" runat="server" class="Content" align="center">
                <table width="90%" align="center">
                    <tr>
                        <td colspan="2" align="center">
                            <br />
                            <asp:TextBox ID="TextCancelReason" runat="server" Width="80%" class="Custfont" Style="padding: 5px;
                                border-radius: 5px;" TextMode="MultiLine" Height="50px" ClientIDMode="Static"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%">
                        </td>
                        <td align="left">
                            <asp:Button ID="BtnCancelRequest" runat="server" Text="SUBMIT" Style="margin-top: 5px;
                                background: #E73225; background-image: none; border: 0 none;" CssClass="ButtonOut"
                                OnClientClick="CancelRequest();return false;" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <ajaxToolkit:ModalPopupExtender ID="mpCancel" runat="server" BehaviorID="mpCancel"
            PopupControlID="PanelCancel" TargetControlID="TargetCancel" CancelControlID="BtnCloseCancel"
            BackgroundCssClass="modalBackground">
        </ajaxToolkit:ModalPopupExtender>
        <asp:Label ID="TargetCancel" runat="server"></asp:Label>
    </asp:Panel>
    <asp:Panel ID="PanelDone" runat="server" align="center" Style="display: none; width: 20%;
        min-width: 150px;">
        <table style="width: 120px; height: 111px; background-size: 42% 42%; background-repeat: no-repeat;
            background-image: url('../Images/PORTER/NTick.gif'); background-position: 48% 40%;
            border-radius: 8px; border: 3px solid white; box-shadow: 0px 0px 10px 0px rgba(0,0,0,0.75);">
            <tr>
                <td align="center" valign="bottom" class="Value" style="font-size: 16px; color: White;
                    padding-bottom: 5px;">
                    DONE
                </td>
            </tr>
        </table>
        <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BehaviorID="mpDone"
            PopupControlID="PanelDone" TargetControlID="TargetDone" BackgroundCssClass="modalBackground">
        </ajaxToolkit:ModalPopupExtender>
        <asp:Label ID="TargetDone" runat="server"></asp:Label>
    </asp:Panel>
    <asp:Panel ID="PnlWait" runat="server" align="center" Style="display: none; width: 30%;
        max-width: 250px;">
        <div id="Div3" clientidmode="Static" align="center" runat="server" class="Shadow">
            <div class="header" align="center" style="height: 15px;">
                <table width="100%" style="margin-top: -6px;">
                    <tr>
                        <td align="center">
                            <span id="LBLResultHead" class="Configheader" style="font-size: 14px;">Loading..
                            </span>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="headFoot" style="height: 0px; margin-top: -2px;">
            </div>
            <div id="Wait" align="center" class="Shadow" style="border-radius: 0px 0px 10px 10px;
                font-family: Arial; font-weight: bold; color: #014454; background: url('MImages/BG.png');
                min-height: 70px;">
                <div style="background: url('MImages/BG.png'); border-radius: 0px 0px 10px 10px;
                    font-family: Arial; font-weight: bold; color: #014454;">
                    <table cellpadding="7" cellspacing="3" width="80%" align="center">
                        <tr>
                            <td>
                                <br />
                                <div align="center">
                                    <img id="LoadingGif" style="width: 80px; border-radius: 5px;"
                                        src="../MImages/LoadingN.gif" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <ajaxToolkit:ModalPopupExtender ID="MPWait" runat="server" BehaviorID="MPWait" PopupControlID="PnlWait"
            TargetControlID="Label6" CancelControlID="Label6" BackgroundCssClass="modalBackground">
        </ajaxToolkit:ModalPopupExtender>
        <asp:Label ID="Label6" runat="server"></asp:Label>
    </asp:Panel>
    </form>
</body>
</html>
