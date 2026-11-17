<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Header.ascx.cs" Inherits="Controls_Header" %>
<head>
    <title>:: HEADER :: </title>
    <link href="../Styles/Header.css" rel="stylesheet" type="text/css" />
    <telerik:radcodeblock runat="server" id="HeaderScript">
        <script type="text/javascript">
            var Admin = ["Master", "Reports", "Track"], ControlRoom = ["Request", "Reports", "Mapping", "Track"], Nurse = ["Request", "Reports"];
            $(document).ready(function () {
                var path = window.location.pathname.split('/'), Folder = path[path.length - 2];
                if ((sessionStorage.getItem('ROLE') == null) || (sessionStorage.getItem('ROLE').toUpperCase() == 'NULL') || (sessionStorage.getItem('ROLE').toUpperCase().length === 0))
                    window.location = LoginUrl;
                else {
                    switch (sessionStorage.getItem('ROLE').toUpperCase()) {
                        case "ADMIN":
                            if ($.inArray(Folder, Admin) == -1)
                                Unauthorized();
                            break;
                        case "CONTROL ROOM":
                        case "MANAGER":
                            if ($.inArray(Folder, ControlRoom) == -1)
                                Unauthorized();
                            break;
                        case "NURSE":
                        case "PCC":
                            if ($.inArray(Folder, Nurse) == -1)
                                Unauthorized();
                            break;

                    }
                    ShowTime();
                }
            });

            function Unauthorized() {
                ClearSession();
                window.location = "../Default.aspx";
            }
            function ClearSession() {
                sessionStorage.setItem('ID', null);
                sessionStorage.setItem('NAME', null);
                sessionStorage.setItem('PASSWORD', null);
                sessionStorage.setItem('ROLE', null);
                sessionStorage.setItem('EXPIRY', null);
            }
            function ShowTime() {
                var d = new Date();
                var weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
                var weekday = weekdays[d.getDay()];
                var Monthname = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
                var month = Monthname[d.getMonth()];
                var year = d.getFullYear();
                var hour = d.getHours();
                var ampm = hour >= 12 ? "PM" : "AM";
                hour = hour % 12;
                hour = hour ? hour : 12;
                hour = hour > 9 ? hour : "0" + hour;

                var minute = d.getMinutes();
                minute = minute > 9 ? minute : "0" + minute;
                var seconds = d.getSeconds();
                seconds = seconds > 9 ? seconds : "0" + seconds;
                var format = weekday + ", " + month + " " + d.getDate() + ", " + year + ", " + hour + ":" + minute + ":" + seconds + " " + ampm;

                document.getElementById("lblTime").innerHTML = format;   //  dt.toLocaleTimeString();
                window.setTimeout("ShowTime()", 1000); // Here 1000(milliseconds) means one 1 Sec  
            }
        </script>
    </telerik:radcodeblock>
</head>
<div id="banner-bg">
    <table width="100%" style="min-width: 1250px;">
        <tr>
            <td width="33%">
                <div id="logo-left-container">
                    <img src="../Images/HLogo.png" alt="logo" style="height: 40px; width: 237px; margin-left: 2%;
                        margin-top: 20px;" />
                </div>
            </td>
            <td align="center" width="33%">
            </td>
            <td width="33%">
                <div style="float: right;">
                    <asp:Label CssClass="Title1" ID="Label1" runat="server" Text="PORTER MANAGEMENT SOLUTION"></asp:Label>
                    <label id="lblTime" style="font-weight: bold" class="Sub-Title">
                    </label>
                </div>
            </td>
        </tr>
    </table>
</div>
