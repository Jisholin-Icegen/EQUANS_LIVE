<%@ page language="C#" autoeventwireup="true" inherits="Track_FloorWiseTrack"  CodeFile="FloorWiseTrack.aspx.cs" masterpagefile="~/MasterPage/ChangePassword.master" %>
 
<asp:Content ID="Content1" ContentPlaceHolderID="MasterHead" runat="Server">

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>TRACKING</title>
    <script type="text/javascript" src="../Scripts/jquery-1.10.2.js"></script>
      <script src="../js/Track.js" type="text/javascript"></script>
    <script src="../js/ChangePassword.js" type="text/javascript"></script>
     <telerik:RadCodeBlock ID="RadCodeBlock" runat="server">
        <script type="text/javascript">
            var TrackUrl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Track/Service/Service.aspx?",
                Turl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Track/FloorLocate.aspx?",
                Rurl =  '<%=ConfigurationManager.AppSettings["HTTP"].ToString() %>' +'://' +'<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + "/Service/ServiceRequest.aspx?",
                grid, gridMasterTable, Reload = window.setInterval(LoadGrid, 10000),
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
        var hurl = 'https://' + '<%=ConfigurationManager.AppSettings["EPEServer"].ToString() %>' + ':' + '<%=ConfigurationManager.AppSettings["AppPort"].ToString() %>' + '/Track/',
            TID = getParameterByName('TagId');//, Reload = window.setInterval(LoadGridImageTest, 2000), Name = getParameterByName('Name');

        function LoadGridImageTest() {

            alert('reload');
        }

        $(document).ready(function () {

            getAccess();
            LoadFloor();
      // setTimeout(LoadGrid, 5000);
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
 $("#imgPorter").css('width', hval++ + '%');
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
           margin-bottom:8px;
            background-repeat: no-repeat !important;
            background-position: center !important;
            background-size: contain !important;
            z-index: 10000;
            /*  background-size: 100% !important;*/
        }


        .RadGrid_Metro .rgHeader, .RadGrid_Metro .rgHeader a
{
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
    </style>
</head>
    </asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentMaster" runat="Server">
    
        <center>
            <telerik:RadScriptManager ID="RadScriptManager" runat="server">
            </telerik:RadScriptManager>
<body ondragstart="return false;" ondrop="return false;" ondragstart="return false;"
    ondrop="return false;">
    <div id="LocatePorter" align="center" class="LocatePorter" style="
    border-spacing: 0px;
    padding: 11px 0px;
    /* background-color: #f5f5f5 ! important; */
    border-radius: 25px;
    /* margin: 50px 0px; */
    /* box-shadow: inset 0px 0px 1px 0px rgb(52 61 84); */
    moz-box-shadow: inset 0px 0px 35px 1px #0e7add;
    /* box-shadow: 0px 0px 20px 1px #494f63; */
    /* box-shadow: inset 0px 0px 20px 1px #ff7400; */
    /* background-position: 0% 0%; */
    /* background-color: #0e7add; */
    /* background-image: linear-gradient(to bottom, #1fc4f0, #0e7add) !important; */
    /* background-repeat: repeat-x; */
    /* color: #ffffff !important; */
    /* text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25) !important; */
    /* background-attachment: scroll !important; */
    -moz-border-radius: 6px;
    /* -webkit-border-radius: 6px; */
    -moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
    /* -webkit-box-shadow: 0 1px 3px rgba(0,0,0,0.6); */
    /* border-bottom: 1px solid rgba(0,0,0,0.25); */
    /* position: relative; */
    cursor: pointer background: rgba(238,222,210,1);
    /* background-color: lightgray; */
    /* background-color: blue; */ /*#FFCC99;*/
    /* padding: 5px 10px 6px; */
    /* color: Snow; */
    /* font-family: Courier New; */
    /* font-size: 16px; */
    font-weight: normal;
    /* text-decoration: none; */
    -moz-border-radius: 6px;
    /* -webkit-border-radius: 6px; */
    -moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
    /* -webkit-box-shadow: 0 1px 3px rgba(0,0,0,0.6); */
    /* border-bottom: 1px solid rgba(0,0,0,0.25); */
    -moz-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
    -webkit-box-shadow: 0 1px 3px rgba(0,0,0,0.6);
    border-bottom: 1px solid rgba(0,0,0,0.25);
    position: relative;
    cursor: pointer background: rgba(238,222,210,1);
    background-color: #ffffff;
">
        <table style="/* height: 470px; */width: 98%;padding:6px;moz-box-shadow: inset 0px 0px 35px 1px #0e7add;/* box-shadow: 0px 0px 10px 5px #ff7400; *//* box-shadow: inset 0px 0px 20px 1px #b5adad; */border-radius: -6px -6px 1px 1px;/* margin-top: -3px; */background: or; /* border-radius: 5px 5px 0 0; */border-radius: 10px 10px 10px 10px;background-position: 0% 0%;background-color: #0e7add;/* background-image: linear-gradient(to bottom, #1fc4f0, #0e7add) !important; */background-repeat: repeat-x;color: #ffffff !important;text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25) !important;background-attachment: scroll !important;/* background-image: linear-gradient(to bottom, #1fc4f0, #0e7add) !important; */">
            <tbody><tr style="
    /* box-shadow: 0px 0px 20px 1px #494f63; */
    moz-box-shadow: inset 0px 0px 35px 1px #0e7add;
    /* box-shadow: 0px 0px 20px 1px #494f63; */
    /* box-shadow: inset 0px 0px 20px 1px #FF7400; */
    /* background-color: #FF7400; */
    /* border-radius: 25px 25px 1px 1px; */
    /* background-color: #ffffff; */
"> <td colspan="2" valign="middle" style="text-align:center;moz-box-shadow: inset 0px 0px 35px 1px #0e7add;/* box-shadow: inset 0px 0px 20px 1px #ff7400; *//* box-shadow: inset 0px 0px 20px 1px #b5adad; *//* border-radius: 6px 25px 1px 1px; *//* background-color: #2196f3; */">  <table style="font-family:Poppins, sans-serif;font-size:15px;font-weight:bold;height:30px;width:100%;z-index: 1111111;moz-box-shadow: inset 0px 0px 35px 1px #0e7add;/* box-shadow: inset 0px 0px 20px 1px #2196f3; *//* box-shadow: inset 0px 0px 20px 1px #b5adad; */box-shadow: 0px 0px 0px 2px #ffffff;border-radius: 10px 10px 0 0;background-position: 0% 0%;background-color: #0e7add;background-image: linear-gradient(to bottom, #1fc4f0, #0e7add) !important;background-repeat: repeat-x;color: #ffffff !important;text-shadow: 0 -1px 0 rgba(0, 0, 0, 0.25) !important;background-attachment: scroll !important;"> <tbody><tr style="
"><td style="text-align:right
    /* box-shadow: inset 0px 0px 15px 1px #2196f3; */
">FLOOR : </td> <td style=" text-align:left;
    /* box-shadow: inset 0px 0px 15px 1px #fb8e67; */
">   <span id="spnPort" style="text-align:left;">   <select name="drpFloor" id="drpFloor" style="width:200px" onchange="OnchangeFloor(this);" class="form-control search_test"></select> </span></td> <td style="text-align:right;"> </td> <td style=""> <table style="width:88%"><tr> <td style="text-align:left">      <span id="spnLoc"></span> </td>  <td style="text-align:right"><span style="margin-left:30px" onclick="zoomoutMap()">-</span>   <input type="range" min="101" max="200" value="100" onchange="changeValue(this.value);" /> <span style="margin-left:5px" onclick="zoominMap()">+</span></td>  </tr></table> </td></tr></tbody></table>    </td></tr>
            <tr>
                <td valign="middle" class="loadimg" style="width:65% ;background-color:white;background-repeat: no-repeat;vertical-align:middle;background-position: center !important;">
                 <div>  <div id="tdPorter" style="height: 654px; vertical-align: middle;    width: 900px;
    overflow: auto;
    text-align: center;
    margin: 0 auto;
    display: flex;
    vertical-align: middle;
    text-align: center;">

                     <img  id="imgPorter" style="height: 100%;width: 100%;
    
    margin: auto;
    background: #ffffff;
    text-align: center;
    vertical-align: middle;
    
    vertical-align: middle;
    
    margin-left: auto;
    margin-right: auto;
    margin-left: auto;
    margin-right: auto;
    display: block;" />
                        </div>  </div> 
                </td><td style="width:35%;vertical-align:top"> <telerik:RadGrid ID="GridTrack" runat="server" AllowSorting="false" AutoGenerateColumns="false"
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
                                                                <telerik:GridBoundColumn  ItemStyle-VerticalAlign="Middle" ItemStyle-HorizontalAlign="Center"  HeaderText="SNO" DataField="SNO" UniqueName="SNO">
                                                               <HeaderStyle Width="10%" />
                                                                    </telerik:GridBoundColumn>
                                                                <telerik:GridBoundColumn HeaderText="PORTER NAME" DataField="USERNAME" UniqueName="USERNAME">
                                                                         <HeaderStyle Width="40%" />
                                                                </telerik:GridBoundColumn>
                                                                <telerik:GridBoundColumn HeaderText="LOCATION" DataField="ZONENAME" UniqueName="ZONENAME">
                                                                          <HeaderStyle Width="50%" />
                                                                </telerik:GridBoundColumn>
                                                                
                                                                 
                                                            </Columns>
                                                        </MasterTableView>
                                                    </telerik:RadGrid></td>
            </tr>
        </table>
    </div>
</body>
</center>
    </asp:Content>