<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage/ChangePassword.master" AutoEventWireup="true" CodeFile="FloorTracking.aspx.cs" Inherits="Track_FloorTracking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" runat="Server">
    <title>FloorWiseTrack</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- Favicon -->
    <link rel="icon" href="../favicon.png" />
    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="../css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../css/sumoselect.min.css" />
    <link rel="stylesheet" type="text/css" href="../css/style.css" />
    <link rel="stylesheet" type="text/css" href="../css/track.css" />

    <script src="../js/jquery-3.6.4.min.js" type="text/javascript"></script>

    <script src="../js/Track.js" type="text/javascript"></script>
    <script src="../js/ChangePassword.js" type="text/javascript"></script>
    <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">
        <script type="text/javascript">
            var TrackUrl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Track/Service/Service.aspx?",
                Turl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Track/FloorLocate.aspx?",
                Rurl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Service/ServiceRequest.aspx?",
                grid, gridMasterTable, //Reload = window.setInterval(LoadGrid, 10000),
                ParentMenuService =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Service/ParentMenu.aspx?",
                BPorterID = '', BTagID = '', BTime = '30';
            function LoadGrid() {
                grid = $find('<%= GridTrack.ClientID %>');
                gridMasterTable = $find('<%= GridTrack.ClientID %>').get_masterTableView();
                LoadGridFloor();
            }
        </script>
    </telerik:RadCodeBlock>
    <script language="javascript" type="text/javascript">
        var hurl = 'http://' + '<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + '/Track/',
            TID = getParameterByName('TagId');//, Reload = window.setInterval(LoadGridImageTest, 2000), Name = getParameterByName('Name');

        function LoadGridImageTest() {

            alert('reload');
        }

        $(document).ready(function () {
            getPageAccess();
            LoadFloor();
            setTimeout(LoadGrid, 5000);
            //  LoadGrid();

            /*   TID = getParameterByName('TagId');
               $(document).prop('title', 'TRACKING ' + Name);
               GetImage(TID);  */
            //$(ele).val()
        });
        function ReloadPage() {
            //location.reload();
        }
        function GetImage(flrid) {
            var n = new Date(), daten = n.getDate() + '' + (n.getMonth() + 1) + '' + n.getFullYear() + '' + n.getTime() + '' + (n.getTime() + "" + n.getHours() + '' + n.getMinutes() + '' + n.getSeconds() + '' + n.getMilliseconds());
            $.ajax({
                async: true,
                url: hurl + "FloorLocate.aspx?PROCESS=FLOORWISE&TagId=" + TID + "&CurrentTime=" + daten + "&FLOORID=" + flrid + "&USERID=" + sessionStorage.getItem('ID'),
                type: 'POST',
                data: 'pData',
                dataType: 'xml',
                success: function (data) {
                    var Img = data[0].FLOORIMAGE //$(data).find("IMAGE").text();
                    $("#spnPort").text(Name);
                    $("#spnLoc").text($(data).find("LOCATION").text());
                    if (Img.length > 0)
                        $('#imgPorter').attr("src", "" + Img + "");

                    //  $('#tdPorter').css("background-image", "URL('" + Img + "')");
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


        .RadGrid_Metro .rgHeader, .RadGrid_Metro .rgHeader a {
            color: #ffffff !important;
            font-family: monospace !important;
            color: #ffffff !important;
            font-family: monospace !important;
            background-color: rgb(30, 70, 129) !important;
            font-family: Poppins, sans-serif;
            font-size: 15px;
            font-weight: bold;
            height: 22px;
            /* width: 100%; */
            z-index: 1111111;
            moz-box-shadow: inset 0px 0px 35px 1px #0e7add;
            /* box-shadow: inset 0px 0px 20px 1px #2196f3; */
            /* box-shadow: inset 0px 0px 20px 1px #b5adad; */
            box-shadow: 0px 0px 0px 2px #ffffff;
            /* border-radius: 10px 10px 0 0; */
            background-position: 0% 0%;
            background-color: #0e7add;
            background-image: linear-gradient(to bottom, #1fc4f0, #0e7add) !important;
            background-repeat: repeat-x;
            color: #ffffff !important;
            text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25) !important;
            background-attachment: scroll !important;
            box-shadow: 0px 0px 0px 0px #ffffff;
        }

        .table-wrap table tr img, .table-wrap table td img {
            /* max-width: 30px; */
            width: 100% !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentMaster" runat="Server">
    <body>
        <center>
            <telerik:RadScriptManager ID="RadScriptManager" runat="server">
            </telerik:RadScriptManager>


            <div class="lang-menu">
                <a class="select-language" href="track-thai.html">Thai</a>
            </div>
            <div id="loader" class="loader-wrapper">
                <img src="../images/Traczo.svg" alt="Traczo">
            </div>
            <div class="main-wrapper">
                <div class="main-screen-wrap">
                    <div class="main-screen-inner">

                        <!-- Left Panel -->
                        <div class="screen-left-panel">
                            <div class="screen-left-sticky">
                                <div>
                                    <div class="traczo-logo">
                                        <a href="index.html">
                                            <img src="../images/Traczo.svg" alt="Traczo">
                                        </a>
                                    </div>
                                    <div class="hospital-img">
                                        <img src="../images/hospital.jpg" alt="Hospital">
                                    </div>
                                    <div class="hospital-title">
                                        <h5>Welcome</h5>
                                        <h6>QAH University Hospital,</h6>
                                        <p>Newcastle Rd, Stoke-on-Trent ST4 6QG, United Kingdom</p>
                                    </div>
                                    <div class="left-panel-menu">
                                        <ul>
                                              <li>
                                            <a href="../Index/Index.aspx">
                                                <span>
                                                    <img src="../images/home.png" alt="Home"></span> Home
                                            </a>
                                        </li>
                                        <li style="display: none">
                                            <a href="dashboard.html">
                                                <span>
                                                    <img src="../images/dashboard.png" alt="Dashboard"></span> Dashboard
                                            </a>
                                        </li>
                                        <li class="current-menu-item">
                                            <a href="#" onclick="redirectFloorwiseTrac()">
                                                <span>
                                                    <img src="../images/world-map.png" alt="Map"></span> Map
                                            </a>
                                        </li>
                                        <li>
                                            <a href="../Track/TrackNew.aspx">
                                                <span>
                                                    <img src="../images/doc.png" alt="Track"></span> Track
                                            </a>
                                        </li>
                                        <li>
                                            <a href="../Reports/Report.aspx">
                                                <span>
                                                    <img src="../images/clipboard.png" alt="Reports"></span> Reports
                                            </a>
                                        </li>
                                        <li>
                                            <a href="../Planner/Planner.aspx">
                                                <span>
                                                    <img src="../images/spiral-calendar.png" alt="Planner"></span> Planner
                                            </a>
                                        </li>

                                        <li>
                                            <a href="../Master/Category.aspx">
                                                <span>
                                                    <img src="../images/category-master.png" alt="Task Types"></span> Task Types
                                            </a>
                                        </li>
                                        <li>
                                            <a href="../Master/Porter.aspx">
                                                <span>
                                                    <img src="../images/porter-master.png" alt="Porter Master"></span> Porter Master
                                            </a>
                                        </li>

                                        <li >
                                            <a href="../Master/Users.aspx">
                                                <span>
                                                    <img src="../images/porter-master.png" alt="Location Master"></span> User Master
                                            </a>
                                        </li>
                                        <li>
                                            <a href="../Master/Locations.aspx">
                                                <span>
                                                    <img src="../images/location.png" alt="Location Master"></span> Location Master
                                            </a>
                                        </li>

                                        <li>
                                            <a onclick="javascript:Bulk();" href="#">
                                                <span>
                                                    <img src="../images/upload-task.png" alt="Upload Tasks"></span> Upload Tasks
                                            </a>
                                        </li>
                                        <li>
                                            <a href="../Master/Group.aspx">
                                                <span>
                                                    <img src="../images/group-master.png" alt="Group Master"></span> Group Master
                                            </a>
                                        </li>
                                        <li>
                                            <a href="../Master/Remarks.aspx">
                                                <span>
                                                    <img src="../images/memo.png" alt="Group Master"></span> Remarks Master
                                            </a>
                                        </li>
                                        </ul>
                                    </div>
                                </div>
                                <div>
                                    <div class="profile-link">
                                        <div class="profile-img">
                                            <img src="../images/profile.jpg" alt="Profile">
                                        </div>
                                        <div class="profile-designation">
                                            <h6>Account Profile</h6>
                                        </div>
                                        <a href="login.html" class="stretched-link"></a>
                                    </div>
                                    <div class="add-task-link">
                                        <a href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#addTask"
                                            class="btn btn-primary">
                                            <img src="../images/memo.png" alt="Add Task">
                                            Add task
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- /Left Panel -->

                        <!-- Right Panel -->
                        <div class="screen-right-panel">

                            <!-- Section heading -->
                            <div class="section-head">
                                <div class="section-head-left">
                                    <h5>Track</h5>
                                </div>
                                <div class="section-head-right d-flex align-items-center">
                                    <div class="search-wrap shadow w-100">
                                        <div class="search-box">
                                            <form>
                                                <input type="search" maxlength="30"  autocomplete="off webauthn"  id="PName" class="form-control">
                                                <input type="submit" value="" class="search-submit">
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /Section heading

                    <div class="track mb-4">
                        <div class="d-flex">
                            <a href="#" class="btn btn-primary me-3"><img src="../images/message-icon.png"> Message</a>
                            <a href="#" class="btn btn-yellow"><img src="../images/buzzer.png"> Buzzer</a>
                        </div>
                    </div> -->

                            <!-- Track Table -->
                            <div class="table-wrap">
                                <div class="table-responsive">


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
                                                    <td colspan="2" valign="middle" style="text-align: center; moz-box-shadow: inset 0px 0px 35px 1px #0e7add; /* box-shadow: inset 0px 0px 20px 1px #ff7400; *//* box-shadow: inset 0px 0px 20px 1px #b5adad; *//* border-radius: 6px 25px 1px 1px; *//* background-color: #2196f3; */">
                                                        <table style="font-family: Poppins, sans-serif; font-size: 15px; font-weight: bold; height: 30px; width: 100%; z-index: 1111111; moz-box-shadow: inset 0px 0px 35px 1px #0e7add; /* box-shadow: inset 0px 0px 20px 1px #2196f3; *//* box-shadow: inset 0px 0px 20px 1px #b5adad; */box-shadow: 0px 0px 0px 2px #ffffff; border-radius: 10px 10px 0 0; background-position: 0% 0%; background-color: #0e7add; background-image: linear-gradient(to bottom, #1fc4f0, #0e7add) !important; background-repeat: repeat-x; color: #ffffff !important; text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25) !important; background-attachment: scroll !important;">
                                                            <tbody>
                                                                <tr style="">
                                                                    <td style="text-align: right
    /* box-shadow: inset 0px 0px 15px 1px #2196f3; */">FLOOR : </td>
                                                                    <td style="text-align: left; /* box-shadow: inset 0px 0px 15px 1px #fb8e67; */"><span id="spnPort" style="text-align: left;">
                                                                        <select name="drpFloor" id="drpFloor" style="width: 200px" onchange="OnchangeFloor(this);" class="form-control search_test"></select>
                                                                    </span></td>
                                                                    <td style="text-align: right;"></td>
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
                                                    <td valign="middle" class="loadimg" style="width: 65%; background-color: white; background-repeat: no-repeat; vertical-align: middle; background-position: center !important;">
                                                        <div>
                                                            <div id="tdPorter" style="height: 654px; vertical-align: middle; width: 900px; overflow: auto; text-align: center; margin: 0 auto; display: flex; vertical-align: middle; text-align: center;">

                                                                <img id="imgPorter" style="height: 100%; margin: auto; background: #ffffff; text-align: center; vertical-align: middle; vertical-align: middle; margin-left: auto; margin-right: auto; margin-left: auto; margin-right: auto; display: block;" />
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td style="width: 35%; vertical-align: top">
                                                        <telerik:RadGrid ID="GridTrack" runat="server" AllowSorting="false" AutoGenerateColumns="false"
                                                            Width="100%" Style="height: 655px; background-color: white;" Skin="Metro">
                                                            <HeaderStyle />
                                                            <PagerStyle AlwaysVisible="true" />
                                                            <ItemStyle HorizontalAlign="Center" />
                                                            <AlternatingItemStyle HorizontalAlign="Center" />
                                                            <ClientSettings EnableRowHoverStyle="true">
                                                                <Scrolling AllowScroll="True" SaveScrollPosition="true" ScrollHeight="400px" UseStaticHeaders="true"></Scrolling>

                                                                <Selecting AllowRowSelect="false" CellSelectionMode="None" />
                                                            </ClientSettings>
                                                            <MasterTableView
                                                                NoMasterRecordsText="NO REQUEST FOUND." TableLayout="Fixed">
                                                                <NoRecordsTemplate>
                                                                    <div class="LinkFont" style="padding-left: 10%">
                                                                        NO DATA FOUND.
                                                                    </div>
                                                                </NoRecordsTemplate>
                                                                <Columns>
                                                                    <telerik:GridBoundColumn HeaderText="SNO" DataField="SNO" UniqueName="SNO">
                                                                        <HeaderStyle Width="10%" />
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn HeaderText="PORTER NAME" DataField="USERNAME" UniqueName="USERNAME">
                                                                        <HeaderStyle Width="30%" />
                                                                    </telerik:GridBoundColumn>
                                                                    <telerik:GridBoundColumn HeaderText="LOCATION" DataField="ZONENAME" UniqueName="ZONENAME">
                                                                        <HeaderStyle Width="70%" />
                                                                    </telerik:GridBoundColumn>


                                                                </Columns>
                                                            </MasterTableView>
                                                        </telerik:RadGrid></td>
                                                </tr>
                                        </table>
                                    </div>




                                </div>
                            </div>
                            <!-- /Track Table -->

                        </div>
                        <!-- /Right Panel -->
                    </div>
                </div>
            </div>

            <!-- porter app -->
            <div id="ModalBreak" class="modal fade" role="dialog">
                <div class="modal-dialogLoc">
                    <div class="modal-content">
                        <div class="header" align="center">
                            <table width="95%" style="margin-top: -6px;">
                                <tr>
                                    <td colspan="2" align="center" valign="middle">
                                        <span style="color: white; font-family: monospace; font-size: 18px; position: relative; top: -4px; padding-right: 5px;">BREAK</span>
                                    </td>
                                    <td width="10%">
                                        <input type="image" name="BtnRequestCatClose" id="ImgReqBreakClose" src="images/Close.png"
                                            style="border-width: 0px; cursor: pointer; float: right; margin-right: 8px; width: 20px; height: 20px;"
                                            data-dismiss="modal" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="headFoot" style="height: 0px; margin-top: -2px;">
                        </div>
                        <div id="Div2" align="center" style="overflow-y: auto;">
                            <div id="BreakReasonContent" class="Content" style="margin-bottom: 10px;">
                                <table width="95%">
                                    <tr>
                                        <td align="center">
                                            <table style="width: 90%;">

                                                <tr style="height: 45px;">
                                                    <td colspan='2' align="center" style="text-align: center; vertical-align: middle;">
                                                        <span style="font-weight: bold; font-family: arial; color: rgb(30, 70, 129); font-size: 13px; margin-top: 10px;">Name : <span id='BreakPorterName'></span></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle" align="center" style="vertical-align: middle">
                                                        <table width="90%">
                                                            <tr style="color: WHITE; font-family: monospace; font-size: 14px; font-weight: bold; height: 30px; background: #254782;">
                                                                <td style="padding-left: 10px; padding-top: 5px;">REASON </td>
                                                                <td style="padding-left: 10px; padding-top: 5px;">MINUTES </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <select id="drpBreakReason" style="width: 190px; text-transform: uppercase; font-family: monospace; font-size: 12px; font-weight: bold; height: 40px;"
                                                                        onchange="OnBreakReason(this);" tabindex="3">
                                                                    </select>
                                                                </td>
                                                                <td>
                                                                    <input type="number" id="BreakTime" name="quantity" min="0" max="200" style="height: 33px; width: 80px;" />

                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <textarea name="txtBreakReason" id="txtBreakReason" cols="25" rows="5" maxlength="120"
                                                                        class="txtRemarksInfo" style="height: 50px; width: 190px; font-size: 14px; padding: 5px; border-radius: 5px; color: rgb(20, 45, 82); margin-top: 20px; word-break: break-word !important; font-weight: bold !important; text-align: left !important; resize: none !important; display: inline-block;"
                                                                        tabindex="4"></textarea>
                                                                </td>
                                                                <td width="25%" style="vertical-align: middle;">
                                                                    <img src="Images/Break.png" id="ImgDeleteReq" style="cursor: pointer; margin: 10px;" onclick="PorterBreak();return false;" />
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
                        </div>
                    </div>
                </div>
            </div>

            <!-- Reports -->
            <!-- Modal -->
            <div class="modal fade" id="reportsModal" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="reportsModalLabel">Generate New Report</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="modal-body">
                            <form>
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="mb-3">
                                            <label for="select-format">Choose Format</label>
                                            <select name="select-format" id="select-format" class="form-control selectFormat sumoSelect">
                                                <option value="PDF">PDF</option>
                                                <option value="Excel">Excel</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="since-date">Since</label>
                                            <input type="date" id="since-date" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="to-date">To</label>
                                            <input type="date" id="to-date" class="form-control">
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <div class="d-flex justify-content-end">
                                            <button type="button" class="btn btn-outline me-3" data-bs-dismiss="modal">
                                                <img src="../images/multiply.svg">
                                                Cancel</button>
                                            <input type="submit" value="Generate" class="btn btn-secondary">
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /Reports -->

            <!-- Add Task -->
            <!-- Modal -->
            <div class="modal fade addTask" id="addTask" tabindex="-1" aria-labelledby="addTaskLabel" aria-hidden="true">
                <div class="modal-dialog modal-xl">
                    <div class="modal-content">
                        <div class="search-header">
                            <div class="search-wrap shadow">
                                <div class="search-box">
                                    <form>
                                        <input type="search" maxlength="30"  autocomplete="off webauthn"  class="form-control">
                                        <input type="submit" value="" class="search-submit">
                                    </form>
                                </div>
                            </div>
                        </div>
                        <div class="modal-body">
                            <div class="d-flex justify-content-between">
                                <div class="form-wrap me-4">
                                    <div class="d-flex align-items-center justify-content-between mb-4">
                                        <h5>Add Task</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                            <img src="../images/close-white.svg">
                                        </button>
                                    </div>
                                    <form>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="task-date">Date</label>
                                                    <input type="date" id="task-date" class="form-control">
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label for="task-time">Time</label>
                                                    <input type="time" id="task-time" class="form-control">
                                                </div>
                                            </div>
                                            <div class="col-md-12">
                                                <div class="mb-3">
                                                    <label for="from">From</label>
                                                    <select name="selectFloor" id="search_test" class="form-control search_test">
                                                        <option value="Location 1">Location 1</option>
                                                        <option value="Location 2">Location 2</option>
                                                        <option value="Location 3">Location 3</option>
                                                        <option value="Location 4">Location 4</option>
                                                        <option value="Location 4">Location 5</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-12">
                                                <div class="mb-3">
                                                    <label for="from">To</label>
                                                    <select name="selectFloor" id="search_test" class="form-control search_test">
                                                        <option value="Location 6">Location 6</option>
                                                        <option value="Location 7">Location 7</option>
                                                        <option value="Location 8">Location 8</option>
                                                        <option value="Location 9">Location 9</option>
                                                        <option value="Location 10">Location 10</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-md-12">
                                                <div class="mb-3">
                                                    <label for="from">Task Type</label>
                                                    <!-- <select name="selectTaskType" id="selectLocation" class="sumoSelect">
                                                <option selected>Select Task Type</option>
                                                <option value="Bed">Bed</option>
                                                <option value="Documents">Documents</option>
                                                <option value="Pharmacy">Pharmacy</option>
                                                <option value="Cylinder">Cylinder</option>
                                                <option value="Samples">Samples</option>
                                                <option value="Stretcher">Stretcher</option>
                                                <option value="Wheel-Chair">Wheel-Chair</option>
                                                <option value="X Ray">X Ray</option>
                                            </select> -->
                                                    <div class="icon-section">
                                                        <ul>
                                                            <li>
                                                                <input type="checkbox">
                                                                <span>
                                                                    <img src="../images/check.png"></span>
                                                                <img src="../images/icon-bed.png" alt="Bed">
                                                                <p>Bed</p>
                                                            </li>
                                                            <li>
                                                                <input type="checkbox">
                                                                <span>
                                                                    <img src="../images/check.png"></span>
                                                                <img src="../images/icon-documents.png" alt="Documents">
                                                                <p>Documents</p>
                                                            </li>
                                                            <li>
                                                                <input type="checkbox">
                                                                <span>
                                                                    <img src="../images/check.png"></span>
                                                                <img src="../images/icon-pharmacy.png" alt="Pharmacy">
                                                                <p>Pharmacy</p>
                                                            </li>
                                                            <li>
                                                                <input type="checkbox">
                                                                <span>
                                                                    <img src="../images/check.png"></span>
                                                                <img src="../images/icon-cylinder.png" alt="Cylinder">
                                                                <p>Cylinder</p>
                                                            </li>
                                                            <li>
                                                                <input type="checkbox">
                                                                <span>
                                                                    <img src="../images/check.png"></span>
                                                                <img src="../images/icon-samples.png" alt="Samples">
                                                                <p>Samples</p>
                                                            </li>
                                                            <li>
                                                                <input type="checkbox">
                                                                <span>
                                                                    <img src="../images/check.png"></span>
                                                                <img src="../images/icon-stretcher.png" alt="Stretcher">
                                                                <p>Stretcher</p>
                                                            </li>
                                                            <li>
                                                                <input type="checkbox">
                                                                <span>
                                                                    <img src="../images/check.png"></span>
                                                                <img src="../images/icon-wheelchair.png" alt="Wheel-Chair">
                                                                <p>Wheel-Chair</p>
                                                            </li>
                                                            <li>
                                                                <input type="checkbox">
                                                                <span>
                                                                    <img src="../images/check.png"></span>
                                                                <img src="../images/icon-xray.png" alt="X-ray">
                                                                <p>X Ray</p>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-12">
                                                <div class="mb-3">
                                                    <label for="from">Remarks</label>
                                                    <textarea name="task-description" rows="6" class="form-control" placeholder="Remarks"></textarea>
                                                </div>
                                            </div>
                                            <div class="col-md-12">
                                                <div class="mb-3 row">
                                                    <div class="col-sm-4">
                                                        <button type="reset" class="btn btn-tertiary w-100">Clear</button>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <button type="button" class="btn btn-outline w-100"
                                                            data-bs-dismiss="modal">
                                                            <img src="../images/multiply.svg">
                                                            Cancel</button>
                                                    </div>
                                                    <div class="col-sm-4">
                                                        <button type="button" class="btn btn-secondary w-100">
                                                            <img
                                                                src="../images/envelope.png">
                                                            Submit</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                <div class="custom-calendar-wrap">
                                    <div class="custom-calendar">
                                        <header>
                                            <div class="icons">
                                                <span id="prev">
                                                    <img src="../images/left.svg"></span>
                                                <p class="current-date"></p>
                                                <span id="next">
                                                    <img src="../images/right.svg"></span>
                                            </div>
                                        </header>
                                        <div class="calendar">
                                            <ul class="weeks">
                                                <li>Sun</li>
                                                <li>Mon</li>
                                                <li>Tue</li>
                                                <li>Wed</li>
                                                <li>Thu</li>
                                                <li>Fri</li>
                                                <li>Sat</li>
                                            </ul>
                                            <ul class="days"></ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="ModalCancel" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-fullscreen-md-down">
                    <div class="modal-content">
                        <div class="header" align="center">
                            <table width="95%" style="margin-top: -6px;">
                                <tr>
                                    <td style="color: white; font-weight: bold; font-family: monospace; font-size: 18px; position: relative; top: -4px; padding-right: 5px;">#<span id="canReqID"></span> </td>
                                    <td colspan="2" align="center" valign="middle">
                                        <span id="PorName" style="color: white; font-family: monospace; font-size: 18px; position: relative; top: -4px; padding-right: 5px;">BREAK</span>
                                    </td>
                                    <td width="10%">
                                        <input type="image" name="BtnRequestCatClose" id="ImgReqCancelClose" src="../images/close.png"
                                            style="border-width: 0px; cursor: pointer; float: right; margin-right: 8px;"
                                            data-bs-dismiss="modal" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="headFoot" style="height: 0px; margin-top: -2px;">
                        </div>
                        <div id="Div2" align="center" style="overflow-y: auto;">
                            <div id="CancelReasonContent" class="Content" style="margin-bottom: 10px;">
                                <table width="95%">
                                    <tr>
                                        <td align="center">
                                            <table style="width: 190px;">
                                                <tr>
                                                    <td valign="middle" align="center" style="vertical-align: middle">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <div class="mb-3">
                                                                        <label for="txtReqTime">Time</label>
                                                                        <input type="time" id="txtReqTime" class="form-control">
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="25%" style="vertical-align: middle;">


                                            <input type="image" name="BtnRequestCatClose" id="ImgReqCancelCloseaa" src="../images/envelope.png" class="btn btn-tertiary bg-orange" onclick="SaveEndTime()"
                                                style="border-width: 0px; cursor: pointer; float: right; margin-right: 8px;"
                                                data-bs-dismiss="modal" />

                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="modalReqAlert" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-md">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="NRSuccess">Success</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="modal-body">
                            <form>
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="mb-3 text-center">
                                            <img src="../images/icon-success.gif" alt="Icon Success">
                                        </div>
                                        <div class="mb-3 text-center">
                                            <span id="LBLRequestResult"></span>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="ModalMessage" tabindex="-1" aria-labelledby="reportsModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-fullscreen-md-down">
                    <div class="modal-content">

                        <div class="modal-header">
                            <h6 class="modal-title">MESSAGE TO  &nbsp;<span id="MessageTo"></span></h6>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="width: 20px; height: 20px;">
                                <img src="../images/close-white.svg">
                            </button>
                        </div>
                        <div class="headFoot" style="height: 0px; margin-top: -2px;">
                        </div>
                        <div id="Div3" align="center" style="overflow-y: auto;">
                            <div id="CancelReasonContentM" class="Content" style="margin-bottom: 10px;">
                                <table width="95%">
                                    <tr>
                                        <td align="center">
                                            <table style="width: 190px;">
                                                <tr>
                                                    <td valign="middle" align="center" style="vertical-align: middle">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <textarea name="TextMessage" id="TextMessage" cols="25" rows="10" maxlength="120" class="txtRemarksInfo"
                                                                        style="height: 100px; width: 300px; word-break: break-word !important; font-size: 14px; font-weight: bold !important; text-align: left !important; resize: none !important; padding: 5px; border-radius: 5px; color: #142d52;" tabindex="4"></textarea>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="25%" style="vertical-align: middle;">
                                            <img src="../images/Send.png" id="ImgDeleteReqM" style="cursor: pointer" onclick="SendMessage();return false;" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /Add Task -->

            <!-- JS CSS -->
            <script src="../js/jquery-3.6.4.min.js"></script>
            <script src="../js/bootstrap.bundle.min.js"></script>
            <script src="../js/jquery.sumoselect.min.js"></script>
            <script src="../js/style.js"></script>
            <!-----//end-main---->
        </center>
    </body>
</asp:Content>

