var ReportOption = ["Report1", "Report2", "Report3", "Report4", "Report5", "Report6", "Report7"], CatInnerOption = ["Option1", "Option2", "Option3", "Option4", "Option5"], TimeInnerOption = ["TOption1", "TOption2", "TOption3"],
    PorterInnerOption = ["POption1", "POption2", "POption3", "POption4"], ORInnerOption = ["OROption1", "OROption2"];
function selectReport(Opt, PageFrom) {
    var InnerArray = ReportOption;

    $('#tblOROptions').css('display', 'none');
    $('#tblCatOptions').css('display', 'none');
    $('#tblTimeOptions').css('display', 'none');
    $('#tblPorterOptions').css('display', 'none');
    $('#tdGridPorter').css('display', 'none');
    $('#tdDatewise').css('display', 'none');
    $('#tdExport').css('display', 'none');
    $('#ChartDept').css('display', 'table-row');
    $('#divselRequestStatus').css('display', 'none');
    $('#divChartType').css('display', 'inline-block');
    $('#DateFilter').css('display', 'flex');
    $('#divDWDateFilter').css('display', 'none');
    $('#tdRefresh').css('display', 'none');
    $('#ChartType').val('bar2d');
    $.each(InnerArray, function (index, value) {
        if (value == Opt) {
            $('#' + value).addClass('SelectReqIcon');
            InnerReport = Opt;
            if (Opt == "Report2") {

                $('#ChartType').val('doughnut3d');
                $('#tblCatOptions').css('display', 'table');
                $('#Option1').addClass('ChartOptionSelected');
                InnerOption = 'Option1';
            }
            else if (Opt == "Report3") {
                $('#ChartType').val('line');
                $('#tblTimeOptions').css('display', 'table');
                $('#TOption1').addClass('ChartOptionSelected');
                InnerOption = 'TOption1';
            }
            else if (Opt == "Report4") {
                $('#ChartType').val('line');
                $('#tblPorterOptions').css('display', 'table');
                $('#tdGridPorter').css('display', 'table');
                $('#POption1').addClass('ChartOptionSelected');
                InnerOption = 'POption1';
            }
            else if (Opt == "Report5") {
                $('#ChartType').val('line');
                $('#tblOROptions').css('display', 'table');
                $('#OROption1').addClass('ChartOptionSelected');
                InnerOption = 'OROption1';
            }
            else if (Opt == "Report7") {
                $('#ChartDept').css('display', 'none');
                $('#divChartType').css('display', 'none');
                $('#DateFilter').css('display', 'flex');
                $('#divselRequestStatus').css('display', 'flex');
                $('#divDWDateFilter').css('display', 'flex');
                $('#tdDatewise').css('display', 'table-row');
                $('#tdExport').css('display', 'inline-block');
                $('#tdRefresh').css('display', 'inline-block');
            }
        }
        else
            $('#' + value).removeClass('SelectReqIcon');
    });
    GetReport();
}

function changeCheck(ele) {
    var src = $(ele).attr('src'); //alert(src);
    $(ele).attr("src", (src == "../images/CNoCheck.png") ? "../images/CCheck.png" : "../images/CNoCheck.png");

}
function selectOption(Opt, PageFrom) {
    var InnerArray = (PageFrom == 'Time') ? TimeInnerOption : (PageFrom == 'Cat') ? CatInnerOption : (PageFrom == 'Porter') ? PorterInnerOption : (PageFrom == 'OR') ? ORInnerOption : [];
    $.each(InnerArray, function (index, value) {
        if (value == Opt) {
            $('#' + value).addClass('ChartOptionSelected');
            InnerOption = Opt;
            if (Opt == "POption3" || Opt == "POption4") {
                $('#ChartType').val('bar2d');
            }
            else if (Opt == "POption1" || Opt == "POption2") {
                $('#ChartType').val('line');
            }
        }
        else
            $('#' + value).removeClass('ChartOptionSelected');
    });
    GetReport();
}


function GetDate(date) {
    return date.split('/')[1] + '/' + date.split('/')[0] + '/' + date.split('/')[2];
}
function GetChartData(URL, xAxis, yAxis) {
    $.ajax({
        async: true,
        url: URL,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (msg) {
            BindChart(msg, xAxis, yAxis);
            setTimeout(function () {
                $('.loaderElement').css("display", "none");
                HideModalPopUp('ModalLoading');
            }, 1000);
        },
        error: function (msg) {
            return [];
        }

    });
}
function BindChart(msg, xAxis, yAxis) {
    if (msg.length == 0)
        $('#' + RenderAt).css("display", "none");
    else {
        $('#' + RenderAt).css("display", "table-row");
        FusionRender(ChartType, RenderAt, width, xAxis, yAxis, msg);
    }
}
function FusionRender(Type, RenderAt, width, xAxis, yAxis, msg) {
    FusionCharts.ready(function () {
        var revenueChart = new FusionCharts({
            type: Type,
            renderAt: RenderAt,
            width: ((Type == 'doughnut3d' || Type == 'pie3d') && (RenderAt != 'ChartPorter')) ? (width * .8) : width,
            height: ChartHeight,
            dataFormat: "json",
            dataSource: {
                "chart": {
                    "caption": "",
                    "subCaption": "",
                    "xAxisName": xAxis,
                    "yAxisName": yAxis,
                    "theme": "fint",
                    "enableSmartLabels": "1",
                    "showvalues": "1",
                    "showlegend": "1",
                    "bgColor": "#ffffff",
                    "formatNumberScale": "0"
                    //"bgImage": "../Images/ReportBg.png",
                    //"bgImageAlpha": "25",
                    //"bgImageDisplayMode": "stretch"

                },
                "data": msg  //$(json).filter(function (i, n) { return msg.website === 'yahoo' })
            }
        });
        revenueChart.render(RenderAt);
    });
}
function SValidate(FromDocReady, Sfrom, Sto) {

    var from = (FromDocReady) ? Sfrom + "T00:00" : convertDate(Sfrom.value + "T00:00"), to = (FromDocReady) ? Sto + "T23:59" : convertDate(Sto.value + "T23:59");
    var FromDate = new Date(from), ToDate = new Date(to);

    //alert(FromDate); alert(ToDate); alert(FromDate > ToDate);
    if (FromDocReady) {
        ShowModalPopUp('ModalLoading');
        GetChartData(ReportUrl + 'PROCESS=REPORT&From=' + from + '&To=' + to + '&Type=DATEWISE');
    }
    else if (Sfrom.value.length == 0)
        Sfrom.focus();
    else if (Sto.value.length == 0)
        Sto.focus();
    else if (FromDate > ToDate)
        Sto.focus();
    else {
        $('.loaderElement').css("display", "inline-block");
        SGetChartData(ReportUrl + 'PROCESS=REPORT&From=' + from + '&To=' + to + '&Type=DATEWISE', 'REQUEST STATUS', 'NO. OF REQUESTS');
        return false;
    }
}


function convertDate(inputFormat) {
    function pad(s) { return (s < 10) ? '0' + s : s; }
    var d = new Date(inputFormat); var hour = (d.getHours() < 10) ? ('0' + d.getHours().toString()) : d.getHours().toString();
    var Minute = (d.getMinutes() < 10) ? ('0' + d.getMinutes().toString()) : d.getMinutes().toString();
    return [pad(d.getMonth() + 1), pad(d.getDate()), d.getFullYear()].join('/') + " " + hour + ":" + Minute;
}


function HeaderDate(inputFormat) {
    function pad(s) { return (s < 10) ? '0' + s : s; }
    var d = new Date(inputFormat); var hour = (d.getHours() < 10) ? ('0' + d.getHours().toString()) : d.getHours().toString();
    var Minute = (d.getMinutes() < 10) ? ('0' + d.getMinutes().toString()) : d.getMinutes().toString();
    return [pad(d.getDate()), pad(d.getMonth() + 1), d.getFullYear()].join('-') + " " + hour + ":" + Minute;
}


function SGetChartData(URL, xAxis, yAxis) {
    $.ajax({
        async: true,
        url: URL,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (msg) {
            SBindChart(msg, xAxis, yAxis);
            setTimeout(function () {
                HideModalPopUp('ModalLoading');
                $('.loaderElement').css("display", "none");
            }, 1000);
        },
        error: function (msg) {
            return [];
        }

    });
}
function SBindChart(msg, xAxis, yAxis) {
    if (msg.length == 0)
        $('#' + RenderAt).css("display", "none");
    else {
        $('#' + RenderAt).css("display", "table-row");
        SFusionRender(ChartType, RenderAt, width, xAxis, yAxis, msg);
    }
}
function SFusionRender(Type, RenderAt, width, xAxis, yAxis, msg) {
    FusionCharts.ready(function () {
        var revenueChart = new FusionCharts({
            type: Type,
            renderAt: RenderAt,
            width: ((Type == 'doughnut3d' || Type == 'pie3d') && (RenderAt != 'ChartPorter')) ? (width * .8) : width,
            height: ChartHeight,
            dataFormat: "json",
            dataSource: {
                "chart": {
                    "caption": "",
                    "subCaption": "",
                    "xAxisName": xAxis,
                    "yAxisName": yAxis,
                    "theme": "fint",
                    "enableSmartLabels": "1",
                    "showvalues": "1",
                    "showlegend": "1",
                    "bgColor": "#ffffff",
                    "formatNumberScale": "0"
                    //"palettecolors": ((Type == 'bar2d') ? "#0d6efd" : ("#e6003d,#3bacff,#51e782,#e4d100,#8e13f4,#f79800,#d706ab,#a8ceff,#3eb595"))
                    //"bgImage": "../Images/ReportBg.png",
                    //"bgImageAlpha": "25",
                    //"bgImageDisplayMode": "stretch"

                },
                "data": msg  //$(json).filter(function (i, n) { return msg.website === 'yahoo' })
            }
        });
        revenueChart.render(RenderAt);
    });
}



function CValidate(FromDocReady, Sfrom, Sto) {
    var from = (FromDocReady) ? Sfrom + "T00:00" : convertDate(Sfrom.value + "T00:00"), to = (FromDocReady) ? Sto + "T23:59" : convertDate(Sto.value + "T23:59");
    var FromDate = new Date(from), ToDate = new Date(to);

    //var from = GetDate((FromDocReady) ? Sfrom : Sfrom.value), to = GetDate((FromDocReady) ? Sto : Sto.value), FromDate = new Date(from), ToDate = new Date(to);
    if (FromDocReady) {

        $('.loaderElement').css("display", "inline-block");
        GetChartData(ReportUrl + 'PROCESS=REPORT&From=' + from + '&To=' + to + '&Type=' + ((InnerOption == 'Option2') ? "CATEGORYWISEASSIGNWAITTIME" : (InnerOption == 'Option3') ? "CATEGORYWISEPROGRESSWAITTIME" : (InnerOption == 'Option4') ? "PERFORMANCECATEGORYWISE" : (InnerOption == 'Option5') ? "PERFORMANCETOTALCATEGORYWISE" : "CATEGORYWISE"), 'REQUEST CATEGORY', ((InnerOption == 'Option1') ? 'NO. OF REQUESTS' : 'AVG TIME TAKEN ( IN MINUTES)'));
    }
    else if (Sfrom.value.length == 0)
        Sfrom.focus();
    else if (Sto.value.length == 0)
        Sto.focus();
    else if (FromDate > ToDate)
        Sto.focus();
    else {

        $('.loaderElement').css("display", "inline-block");
        GetChartData(ReportUrl + 'PROCESS=REPORT&From=' + from + '&To=' + to + '&Type=' + ((InnerOption == 'Option2') ? "CATEGORYWISEASSIGNWAITTIME" : (InnerOption == 'Option3') ? "CATEGORYWISEPROGRESSWAITTIME" : (InnerOption == 'Option4') ? "PERFORMANCECATEGORYWISE" : (InnerOption == 'Option5') ? "PERFORMANCETOTALCATEGORYWISE" : "CATEGORYWISE"), 'REQUEST CATEGORY', ((InnerOption == 'Option1') ? 'NO. OF REQUESTS' : 'AVG TIME TAKEN ( IN MINUTES)'));
        return false;
    }
}


function Datewise(FromDocReady, Sfrom, Sto, fileName) {

    var from = (FromDocReady) ? Sfrom + "T00:00" : convertDate(Sfrom.value + "T00:00"), to = (FromDocReady) ? Sto + "T23:59" : convertDate(Sto.value + "T23:59");

    var FromDate = new Date(from), ToDate = new Date(to);

    var PorterID = '';

    if (Sfrom.value.length == 0)
        Sfrom.focus();
    else if (Sto.value.length == 0)
        Sto.focus();
    else if (FromDate > ToDate)
        Sto.focus();
    else {
        $('.loaderElement').css("display", "inline-block");
        pageIndex = 0;
        BindDateGrid();
        return false;
    }
}
function ExportFinancialReport(Sfrom, Sto) {
    var from = convertDate(Sfrom.value + "T00:00"), to = convertDate(Sto.value + "T23:59");

    var FromDate = new Date(from), ToDate = new Date(to);

    var PorterID = '';

    if (Sfrom.value.length == 0)
        Sfrom.focus();
    else if (Sto.value.length == 0)
        Sto.focus();
    else if (FromDate > ToDate)
        Sto.focus();
    else {
        ShowModalPopUp("modalAlert");
        setTimeout('HideModalPopUp("modalAlert");', 1000);
        FinanceReportU();

        return false;
    }
}

function ExportDetailReport(Sfrom, Sto) {
    var from = convertDate(Sfrom.value + "T00:00"), to = convertDate(Sto.value + "T23:59");

    var FromDate = new Date(from), ToDate = new Date(to);

    var PorterID = '';

    if (Sfrom.value.length == 0)
        Sfrom.focus();
    else if (Sto.value.length == 0)
        Sto.focus();
    else if (FromDate > ToDate)
        Sto.focus();
    else {
        ShowModalPopUp("modalAlert");
        setTimeout('HideModalPopUp("modalAlert");', 1000);
        DetailReportU();

        return false;
    }
}


function DetailReportU() {


    var PFrom = document.getElementById("txtfromdate").value + "T00:00",
        PTo = document.getElementById("txttodate").value + "T23:59",
        Header = "Detailed_Report(" + PFrom + "_TO_" + PTo + ").xls",

        InnerHeader = 'Selection criteria: From date :-' + PFrom + ', To date :- ' + PTo;
    var FinalURL = EReportUrl + "PROCESS=DETAILEDREPORT&From=" + encodeURIComponent(Encrypt(convertDate(PFrom))) + "&To=" + encodeURIComponent(Encrypt(convertDate(PTo))) + "&InnerHeader=" + encodeURIComponent(Encrypt(InnerHeader));
    $.ajax({
        url: FinalURL,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data.length > 0) {

                var downloadLink = document.createElement("a");
                downloadLink.href = 'data:application/vnd.ms-excel,' + encodeURIComponent(data[0].Result);
                downloadLink.download = Header;

                document.body.appendChild(downloadLink);
                downloadLink.click();
                document.body.removeChild(downloadLink);
            } else {
                alert('No Records Found.')
            }
        },
        error: function (data) {

        }

    });
}
function FinanceReportU() {


    var PFrom = document.getElementById("txtfromdate").value + "T00:00",
        PTo = document.getElementById("txttodate").value + "T23:59",
        Header = "Finance_Report_Summary(" + PFrom + "_TO_" + PTo + ").xls",

        InnerHeader = 'Selection criteria: From date :-' + PFrom + ', To date :- ' + PTo;
    var FinalURL = EReportUrl + "PROCESS=FINANCEREPORT&From=" + encodeURIComponent(Encrypt(convertDate(PFrom))) + "&To=" + encodeURIComponent(Encrypt(convertDate(PTo))) + "&InnerHeader=" + encodeURIComponent(Encrypt(InnerHeader));
    $.ajax({
        url: FinalURL,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data.length > 0) {

                var downloadLink = document.createElement("a");
                downloadLink.href = 'data:application/vnd.ms-excel,' + encodeURIComponent(data[0].Result);
                downloadLink.download = Header;

                document.body.appendChild(downloadLink);
                downloadLink.click();
                document.body.removeChild(downloadLink);
            } else {
                alert('No Records Found.')
            }
        },
        error: function (data) {

        }

    });
}

function CSValidate(FromDocReady, Sfrom, Sto, fileName) {

    var from = (FromDocReady) ? Sfrom + "T00:00" : convertDate(Sfrom.value + "T00:00"), to = (FromDocReady) ? Sto + "T23:59" : convertDate(Sto.value + "T23:59");
    var FromDate = new Date(from), ToDate = new Date(to);
    var CSProcess = ((InnerOption == "OROption1") ? "GENRESPONSEOVERRUN" : "GENDURATIONOVERRUN");

    var PorterID = '';


    var xAxis = 'TIME OF DAY';
    var yAxis = 'NUMBER OF TASKS', CGroupBy = '';


    if (FromDocReady) {
        $('.loaderElement').css("display", "inline-block");
        CGetChartData(ReportUrl + 'PROCESS=' + CSProcess + '&From=' + from + '&To=' + to + '&PORTERID=' + PorterID + '&GROUPBY=' + CGroupBy, xAxis, yAxis, fileName);
    }
    else if (Sfrom.value.length == 0)
        Sfrom.focus();
    else if (Sto.value.length == 0)
        Sto.focus();
    else if (FromDate > ToDate)
        Sto.focus();
    else {
        $('.loaderElement').css("display", "inline-block");
        CGetChartData(ReportUrl + 'PROCESS=' + CSProcess + '&From=' + from + '&To=' + to + '&PORTERID=' + PorterID + '&GROUPBY=' + CGroupBy, xAxis, yAxis, fileName);
        return false;
    }
}



function ResouceUsage(FromDocReady, Sfrom, Sto, fileName) {

    var from = (FromDocReady) ? Sfrom + "T00:00" : convertDate(Sfrom.value + "T00:00"), to = (FromDocReady) ? Sto + "T23:59" : convertDate(Sto.value + "T23:59");
    var FromDate = new Date(from), ToDate = new Date(to);
    var CSProcess = "GETRESOURCEUSAGE";

    var PorterID = '';


    var xAxis = 'TIME OF DAY';
    var yAxis = 'TIME(in MINUTES)', CGroupBy = '';


    if (FromDocReady) {
        $('.loaderElement').css("display", "inline-block");
        RUGetChartData(ReportUrl + 'PROCESS=' + CSProcess + '&From=' + from + '&To=' + to + '&PORTERID=' + PorterID + '&GROUPBY=' + CGroupBy, xAxis, yAxis, fileName);
    }
    else if (Sfrom.value.length == 0)
        Sfrom.focus();
    else if (Sto.value.length == 0)
        Sto.focus();
    else if (FromDate > ToDate)
        Sto.focus();
    else {
        $('.loaderElement').css("display", "inline-block");
        RUGetChartData(ReportUrl + 'PROCESS=' + CSProcess + '&From=' + from + '&To=' + to + '&PORTERID=' + PorterID + '&GROUPBY=' + CGroupBy, xAxis, yAxis, fileName);
        return false;
    }
}

function RUGetChartData(URL, xAxis, yAxis, fileName) {
    $.ajax({
        async: true,
        url: URL,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (msg) {

            RUBindChart(msg, xAxis, yAxis, fileName);
            setTimeout(function () {
                $('.loaderElement').css("display", "none");
                HideModalPopUp('ModalLoading');
            }, 1000);
        },
        error: function (msg) {
            return [];
        }

    });
}

function RUBindChart(msg, xAxis, yAxis, fileName) {
    var TypeChart = "overlappedColumn2d";
    if (msg.length == 0)
        $('#' + RenderAt).css("display", "none");
    else {
        $('#' + RenderAt).css("display", "table-row");
        CFusionRender(TypeChart, RenderAt, width, xAxis, yAxis, msg, fileName);
    }
}


function CGetChartData(URL, xAxis, yAxis, fileName) {
    $.ajax({
        async: true,
        url: URL,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (msg) {
            CBindChart(msg, xAxis, yAxis, fileName);
            setTimeout(function () {
                $('.loaderElement').css("display", "none");
                HideModalPopUp('ModalLoading');
            }, 1000);
        },
        error: function (msg) {
            return [];
        }

    });
}



function CBindChart(msg, xAxis, yAxis, fileName) {
    var TypeChart = "column2d";
    if (msg.length == 0)
        $('#' + RenderAt).css("display", "none");
    else {
        $('#' + RenderAt).css("display", "table-row");
        if (TypeChart == "overlappedColumn2d")
            CFusionRender(TypeChart, RenderAt, width, xAxis, yAxis, msg, fileName);
        else
            CAFusionRender(TypeChart, RenderAt, width, xAxis, yAxis, msg, fileName);
    }
}

function CAFusionRender(Type, RenderAt, width, xAxis, yAxis, msg, fileName) {
    FusionCharts.ready(function () {
        var revenueChart = new FusionCharts({
            type: Type,
            renderAt: RenderAt,
            width: 1200,
            height: 650,
            dataFormat: "json",
            dataSource: {
                "chart": {
                    "caption": fileName.replace("_", " "),
                    "subCaption": "",
                    "xAxisName": xAxis,
                    "yAxisName": yAxis,
                    "theme": "fusion",
                    "enableSmartLabels": "1",
                    "showvalues": "1",
                    "showlegend": "1",
                    "bgColor": "#ffffff",
                    "labelDisplay": "rotate",
                    "baseFont": "Verdana",
                    "baseFontSize": "11",
                    "baseFontColor": "#000000",
                    //"palettecolors": "1e4681",
                    "slantLabel": "1",
                    "exportEnabled": "1",
                    "exportformats": "PNG=Export as High Quality Image|PDF=Export as PDF|CSV=Export Chart Data as csv", //|XLS=Export Chart Data
                    "exportFileName": fileName
                    //"palettecolors": "1e4681"
                    //"bgImage": "../Images/ReportBg.png",
                    //"bgImageAlpha": "25",
                    //"bgImageDisplayMode": "stretch"

                },
                "data": msg  //$(json).filter(function (i, n) { return msg.website === 'yahoo' })
            }
        });
        revenueChart.render(RenderAt);
    });
}

function CFusionRender(Type, RenderAt, width, xAxis, yAxis, msg, fileName) {
    FusionCharts.ready(function () {
        var revenueChart = new FusionCharts({
            type: Type,
            renderAt: RenderAt,
            width: 1300,
            height: 600,
            dataFormat: "json",
            dataSource: {
                "chart": {
                    "caption": fileName.replace("_", " "),
                    "subCaption": "",
                    "xAxisName": xAxis,
                    "yAxisName": yAxis,
                    "theme": "fusion",
                    "enableSmartLabels": "1",
                    "showvalues": "1",
                    "showlegend": "1",
                    "bgColor": "#ffffff",
                    "labelDisplay": "rotate",
                    "slantLabel": "1",
                    "formatNumberScale": "1",
                    "numberScaleValue": "60",
                    "numberScaleUnit": "h",
                    "defaultNumberScale": "m",
                    "scaleRecursively": "1",
                    "baseFont": "Verdana",
                    "baseFontSize": "11",
                    "baseFontColor": "#000000",
                    //Recurse for all provided units/values
                    "maxScaleRecursion": "-1",
                    //Character used to separate scale
                    "scaleSeparator": " ",
                    //"palettecolors": "1e4681,30d5c8",
                    //"palettecolors": "00008B,30d5c8",
                    "valueBgColor": "ffffff",
                    "valueBgAlpha": "30",
                    "exportEnabled": "1",
                    "exportformats": "PNG=Export as High Quality Image|PDF=Export as PDF|CSV=Export Chart Data as csv", //|XLS=Export Chart Data
                    "exportFileName": fileName

                    //"bgImage": "../Images/ReportBg.png",
                    //"bgImageAlpha": "25",
                    //"bgImageDisplayMode": "stretch"

                },
                "categories": [
                    {
                        "category": msg[0]
                    }
                ],
                "dataset": [
                    {
                        "seriesname": "RESOURCE",
                        "data": msg[1]
                    },
                    {
                        "seriesname": "USAGE",
                        "data": msg[2]
                    }
                ]
            }
        });
        revenueChart.render(RenderAt);

        //setTimeout(function () { hideTrail() }, 1000);
    });
}


function TValidate(FromDocReady, Sfrom, Sto) {

    var from = (FromDocReady) ? Sfrom + "T00:00" : convertDate(Sfrom.value + "T00:00"), to = (FromDocReady) ? Sto + "T23:59" : convertDate(Sto.value + "T23:59");
    var FromDate = new Date(from), ToDate = new Date(to);

    //var from = GetDate((FromDocReady) ? Sfrom : Sfrom.value), to = GetDate((FromDocReady) ? Sto : Sto.value), FromDate = new Date(from), ToDate = new Date(to);
    if (FromDocReady) {
        $('.loaderElement').css("display", "inline-block");
        GetChartData(ReportUrl + 'PROCESS=REPORT&From=' + from + '&To=' + to + '&Type=' + ((InnerOption == 'TOption1') ? "PEEKHOURTIME" : (InnerOption == 'TOption2') ? "HOURLYASSIGNWAIT" : "HOURLYPROGRESSWAIT") + '&PorterId=' + selDeptIDs + '&Search=' + ($('#DrpCategory').val() != '0' ? $('#DrpCategory').val() : ''), 'REQUEST TIME', ((InnerOption == 'TOption1') ? 'NO. OF REQUESTS' : 'AVG TIME TAKEN ( IN MINUTES)'));
    }
    else if (Sfrom.value.length == 0)
        Sfrom.focus();
    else if (Sto.value.length == 0)
        Sto.focus();
    else if (FromDate > ToDate)
        Sto.focus();
    else {
        $('.loaderElement').css("display", "inline-block");
        GetChartData(ReportUrl + 'PROCESS=REPORT&From=' + from + '&To=' + to + '&Type=' + ((InnerOption == 'TOption1') ? "PEEKHOURTIME" : (InnerOption == 'TOption2') ? "HOURLYASSIGNWAIT" : "HOURLYPROGRESSWAIT") + '&PorterId=' + selDeptIDs + '&Search=' + ($('#DrpCategory').val() != '0' ? $('#DrpCategory').val() : ''), 'REQUEST TIME', ((InnerOption == 'TOption1') ? 'NO. OF REQUESTS' : 'AVG TIME TAKEN ( IN MINUTES)'));
        return false;
    }
}

function LoadCategory() {
    $.ajax({
        async: false,
        url: ReportUrl + 'PROCESS=GETCATEGORY',
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (msg) {
            $('#DrpCategory').empty(); //find('option').remove();

            $("#DrpCategory").append($("<option ></option>").val('0').html('ALL'));
            $.each(msg, function (key, value) {
                $("#DrpCategory").append($("<option ></option>").val(value.ID).html(value.NAME));
                $("#DrpCategory").trigger("chosen:updated");
            });
            setCategory();
        },
        error: function (msg) {
            alert(msg.length);
        }

    });

}
function setCategory() {
    $('#HFCategory').val(($("#DrpCategory").val() == '0') ? "ALL MOVEMENTS_" : ($("#DrpCategory option:selected").text() + "_" + $("#DrpCategory").val()));
}

function SetDefault() {
    $('#Option1').addClass('ChartOptionSelected');
    InnerOption = 'Option1'
}



function BindGridPorter() {

    $.ajax({
        url: ReportUrl + "PROCESS=REPORT&From=" + convertDate(PFrom) + "&To=" + convertDate(PTo) + "&Type=" + ((InnerOption == 'Option1') ? "GETPORTER" : (InnerOption == 'Option2') ? "GETASSIGNEDPORTER" : (InnerOption == 'Option3') ? "GETPORTER" : "GETASSIGNEDPORTER"),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (typeof (grid) != 'undefined' && grid != null) {
                //grid.clearSelectedItems();
                tableView = grid.get_masterTableView();
                tableView.set_dataSource(data);
                tableView.dataBind();

                // Set Default
                var SelectRows = tableView.get_selectedItems(),
                    Rows = tableView.get_dataItems(),
                    Row = ((SelectRows.length == 0) ? Rows[0] : SelectRows[0]);
                Row.set_selected(true);
                var PId = Row.getDataKeyValue("ID"), PType = Row.getDataKeyValue("PORTERNAME"), Date = Row.getDataKeyValue("COUNT");
                GetChartData(ReportUrl + 'PROCESS=REPORT&From=' + convertDate(PFrom) + '&To=' + convertDate(PTo) + '&Type=' + ((InnerOption == 'POption1') ? "PORTERPEEKHOUR" : (InnerOption == 'POption2') ? "PORTERPERFORMANCE" : (InnerOption == 'POption3') ? "PORTERCATEGORYWISE" : "PORTERWISECATEGORYPERFORMANCE") + '&PorterId=' + PId, ((InnerOption == 'POption1') ? "REQUEST TIME" : (InnerOption == 'POption2') ? "REQUEST TIME" : (InnerOption == 'POption3') ? "REQUEST CATEGORY" : "REQUEST CATEGORY"), ((InnerOption == 'POption1') ? "NO. OF REQUESTS" : (InnerOption == 'POption2') ? "AVG TIME TAKEN ( IN MINUTES)" : (InnerOption == 'POption3') ? "NO. OF REQUESTS" : "AVG TIME TAKEN ( IN MINUTES)"));

            }
        },
        error: function (data) {

        }

    });
}


function setCheckbyID(eleId) {

    var src = $('#' + eleId).attr('src'); //alert(src);
    $('#' + eleId).attr("src", (src == "../images/NoMCheck.jpg") ? "../images/MCheck.jpg" : "../images/NoMCheck.jpg");

}

function GridDateWise_RowDataBound(sender, args) {
    var tatExceeded = args.get_item().getDataKeyValue("TATEXCEEDED"), CompleteRemarks = args.get_item().getDataKeyValue("COMPLETEDREMARKS"), Logs = args.get_item().getDataKeyValue("LOGS"), RequestID = args.get_item().getDataKeyValue("REQUESTID"), RequestStatus = args.get_item().getDataKeyValue("REQUESTSTATUSID");
    var ReqID = args.get_item().getDataKeyValue("REQUESTID"), CategoryID = args.get_item().getDataKeyValue("CATEGORYID"), RequestStatus = args.get_item().getDataKeyValue("REQUESTSTATUSID"), PatientName = args.get_item().getDataKeyValue("PATIENTNAME"),
        Remarks = args.get_item().getDataKeyValue("REQUESTDESKREMARKS"), CancelledRemarks = args.get_item().getDataKeyValue("REMARKS"), MultiPorter = args.get_item().getDataKeyValue("ISMULTIPORTER"), MUIndex = args.get_item().getDataKeyValue("MULTITASKINDEX"),
        RQuantity = args.get_item().getDataKeyValue("QUANTITY"), RequestorName = args.get_item().getDataKeyValue("REQUESTORNAME"), From = args.get_item().getDataKeyValue("FROM"), To = args.get_item().getDataKeyValue("TO"),
        PorterRemarks = args.get_item().getDataKeyValue("PORTERREMARKS"), ContactNo = args.get_item().getDataKeyValue("CONTACTNO"), VIC = args.get_item().getDataKeyValue("VIC"), ReqDate = args.get_item().getDataKeyValue("REQUESTDATE"),
        ReqTime = args.get_item().getDataKeyValue("REQUESTTIME"), LoginName = args.get_item().getDataKeyValue("ENTEREDBY"), ServiceID = args.get_item().getDataKeyValue("SERVICEID"),
        AckSign = args.get_item().getDataKeyValue("ACKSIGN"), AckPhoto = args.get_item().getDataKeyValue("ACKPHOTO"), AckPhotoStamp = args.get_item().getDataKeyValue("ACKPHOTOTIMESTAMP"),
        ACKNAME = args.get_item().getDataKeyValue("ACKNAME"), ACKCONTACT = args.get_item().getDataKeyValue("ACKCONTACT"), ACKLOCATION = args.get_item().getDataKeyValue("ACKLOCATION"),
        AckPhoto1 = args.get_item().getDataKeyValue("ACKPHOTO2"), AckPhotoStamp1 = args.get_item().getDataKeyValue("ACKPHOTOTIMESTAMP2"), AckPhoto2 = args.get_item().getDataKeyValue("ACKPHOTO3"), AckPhotoStamp2 = args.get_item().getDataKeyValue("ACKPHOTOTIMESTAMP3"),
        ACKLOCATION1 = args.get_item().getDataKeyValue("ACKLOCSTAMP2"), ACKLOCATION2 = args.get_item().getDataKeyValue("ACKLOCSTAMP3") ;
    //, ACKNAME, ACKCONTACT, ACKLOCATION
    //ACKSIGN, ACKPHOTO, ACKPHOTOTIMESTAMP

    //viewTask(ReqNB, ReqID, CategoryID, StatusID, PatientName, Remarks, CancelledRemarks, MultiPorter, MUIndex, RQuantity, RequestorName, From, To, PorterRemarks, ContactNo)

    var cellCRemarks = args.get_item().get_cell("COMPLETEREMARKS"),
        NotesIcon = $('<a onclick="openCompleteNotes(' + "'" + CompleteRemarks + "','" + RequestID + "','" + RequestStatus + "'" + ');" > </a>').html(' <img src="../images/memo.png" alt="Notes"  /> <br/>').css("cursor", "pointer").append("<span style='text-decoration: underline;word-wrap: break-word;font-weight: bold;overflow: hidden;text-overflow: ellipsis;max-width: 100px;display: inline-block;height: 35px !important;color: " + ((CompleteRemarks.length > 0) ? " red" : "#2e70f5") + ";'>Notes</span>"),
        cellLOGS = args.get_item().get_cell("LOGS"), cellSign = args.get_item().get_cell("ACKSIGN"), cellPhoto = args.get_item().get_cell("ACKPHOTO"),
        LOGSIcon = $('<a onclick="openReqLogs(' + "'" + RequestID + "'" + ');" > </a>').html(' <img src="../images/Log.png" alt="Notes" style="width: 35px;" /> <br/>').css("cursor", "pointer"),
        PhotoIcon = $('<a onclick="OpenPhoto(' + "'" + RequestID + "','- Ack. Photo','" + AckPhoto + "','../images/Photo.png','" + AckPhotoStamp + "','width: 1080px; height: 900px;','" + ACKNAME + "','" + ACKCONTACT + "','" + ACKLOCATION + "','" + AckPhoto1 + "','" + ACKLOCATION1 + "','" + AckPhoto2 + "','" + ACKLOCATION2 + "'" + ');" > </a>').html(' <img src="../images/Photo.png" alt="Notes"  style="width: 35px;" /> <br/>').css("cursor", "pointer"),
        signIcon = $('<a onclick="OpenPhoto(' + "'" + RequestID + "','- Ack. Signature','" + AckSign + "','../images/Sign.png','" + AckPhotoStamp + "','width: 1080px; height: 840px;','" + ACKNAME + "','" + ACKCONTACT + "','" + ACKLOCATION + "','','','',''" + ');" > </a>').html(' <img src="../images/Sign.png" alt="Notes"  style="width: 35px;" /> <br/>').css("cursor", "pointer");
    //$(cellCRemarks).html(((RequestStatus == "6") ? NotesIcon : '-'));

    var cellCReqNo = args.get_item().get_cell("REQUESTNO"),
        ReqNo = $('<a href="javascript:void(0)" class="btn btn-indexblue" > </a>').html('' + RequestID + '').css("cursor", "pointer");

    $(cellCReqNo).html(ReqNo);
    $(ReqNo).click(function () {

        $('#divIconLog').html(LOGSIcon);
	if ((RequestStatus == "6" || RequestStatus == "7") && (ServiceID == '2' || ServiceID == '3')) {
            $('#divIconAckPhoto').html(PhotoIcon); $('#divIconAckSign').html(signIcon);
        } else { $('#divIconAckPhoto').html(''); $('#divIconAckSign').html('') }
        viewTask(ReqID, ReqID, CategoryID, RequestStatus, PatientName, Remarks, CancelledRemarks, MultiPorter, MUIndex, RQuantity, RequestorName, From, To, PorterRemarks, ContactNo, ReqDate, LoginName, ReqTime, ServiceID);
    });


    $(cellCRemarks).html((RequestStatus == "6" || RequestStatus == "7") ? NotesIcon : '-'); $(cellLOGS).html(LOGSIcon);

    //$(cellPhoto).html(((RequestStatus == "6" || RequestStatus == "7") && (ServiceID == '2')) ? PhotoIcon : '-'); //$(cellPhoto).html(PhotoIcon);
    //$(cellSign).html(((RequestStatus == "6" || RequestStatus == "7") && (ServiceID == '2')) ? signIcon : '-'); //$(cellSign).html(signIcon);

    args.get_item().removeCssClass("TatExceed");
    args.get_item().removeCssClass("rgAltRow");
    args.get_item().removeCssClass("rgRow");
    if (tatExceeded !== 'YES' && tatExceeded !== '-') {
        args.get_item().addCssClass("TatExceed");
    }
}


function openReqLogs(ReqID) {

    $.ajax({
        url: ReportUrl + "Process=GETLOGS&REQUESTID=" + encodeURIComponent(Encrypt(ReqID)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var reqLog = data[0].RESULT;
            LoadReqLogs(reqLog, ReqID);
        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });

}

function LoadReqLogs(ReqLogs, ReqID) {

    var arrRemarks = ReqLogs.split('|#|'); $('#spanLogReq').html('Request #' + ReqID);
    //document.getElementById('spanLogReq').value = ReqID;

    var htmlCompleteNotes = '';
    $.each(arrRemarks, function (index, value) {
        if (value.trim()) {
            var valueArray = value.split('|$|'), IsMitigation = valueArray[3].toString();
            htmlCompleteNotes += '<div class="msgContainer"><p class="msgUser">' + valueArray[0].toString() + ((IsMitigation == "YES") ? ('<span class="mitigation-right"> </span>') : '') + '</p> <p>' + valueArray[1].toString().replace('_', ' ') + '<span class="time-right">' + valueArray[2].toString() + '</span></div>'

        }
    });
    $('#divReqLogs').html(htmlCompleteNotes); ShowModalPopUp('ModalReqLogs');
    setTimeout(function () { $('#divReqLogs').show(500); }, 1000);
}

function OpenPhoto(ReqID, Header, Path, HeadPhoto, AckOn, style, AckName, AckContact, AckLocation, Path1, AckLocation1, Path2, AckLocation2) {



    ackImgPath1 = Path; ackImgPath2 = Path1; ackImgPath3 = Path2; ackLoc1 = AckLocation; ackLoc2 = AckLocation1; ackLoc3 = AckLocation2;

    var imgAck1 = $("#imgAck1"), imgAck2 = $("#imgAck2"), imgAck3 = $("#imgAck3");
    $("#imgAckHolder1").css("visibility", ((Path.length > 0) ? "visible" : "hidden")); $("#imgAckHolder2").css("visibility", ((Path1.length > 0) ? "visible" : "hidden")); $("#imgAckHolder3").css("visibility", ((Path2.length > 0) ? "visible" : "hidden"));
   
        $(imgAck1).click(function () { $('#ImgACK').attr("src", ackImgPath1); $('#ACK_CONTACT').html('<strong>Location : </strong>' + ackLoc1); }); $(imgAck2).click(function () { $('#ImgACK').attr("src", ackImgPath2); $('#ACK_CONTACT').html('<strong>Location : </strong>' + ackLoc2); });
        $(imgAck3).click(function () { $('#ImgACK').attr("src", ackImgPath3); $('#ACK_CONTACT').html('<strong>Location : </strong>' + ackLoc3); });

    $('#imgAckHead').attr("src", HeadPhoto); $('#ACK_ON').html('<strong> Date : </strong>' + AckOn);
    $('#ImgACK').attr("src", Path); $('#ImgACK').attr("style", style); $('#spanAckHead').html(Header);
    ShowModalPopUp('ModalImage'); $('#spanReqID').html('#' + ReqID);
    $('#ACK_BY').html('<strong> Ack. By : </strong>' + AckName); $('#ACK_LOC').html('<strong> Contact : </strong>' + AckContact); $('#ACK_CONTACT').html('<strong>Location : </strong>' + AckLocation);
}
function viewTask(ReqNB, ReqID, CategoryID, RequestStatus, PatientName, Remarks, CancelledRemarks, MultiPorter, MUIndex, RQuantity, RequestorName, From, To, PorterRemarks, ContactNo, ReqDate, LoginName, ReqTime, ServiceID) {

    $("#containerMP").css("display", ((MUIndex == '0' || MUIndex == '' || MUIndex == 'null') ? "inline-block" : "none")); $("#ReqUserLogin").html('Entered By :' + LoginName); $("#spanRequestDate").html('Request Date :-' + ReqTime);
    $("#TaskHeader").html('Task #' + ReqNB + '-' + ((RequestStatus == '2') ? 'Pending' : ((RequestStatus == '3') ? 'Assigned' : ((RequestStatus == '4') ? 'In-Progress' : ((RequestStatus == '6') ? 'Completed' : ((RequestStatus == '7') ? 'Cancelled' : '')))))); $("#divEditRemarks").css("display", 'block');
    $('#txtQty').val(RQuantity); $('#txtQty').attr("disabled", true); EServiceCode = ServiceID;
    document.getElementById('HFERID').value = ReqID; document.getElementById('HFERNO').value = ReqNB; document.getElementById('HFStatusID').value = RequestStatus;

    $('#txtFromLoc').val(''); $('#txtFromLoc').val(From); $('#txtFromLoc').attr("disabled", true);
    $('#txtToLoc').val(''); $('#txtToLoc').val(To); $('#txtToLoc').attr("disabled", true);
    OldCatID = CategoryID;
    $('#txtPorterRemarks').val(''); $('#txtPorterRemarks').val(PorterRemarks); $('#txtPorterRemarks').attr("disabled", true);
    $('#txtContactNumber').val(''); $('#txtContactNumber').val(ContactNo); $('#txtContactNumber').attr("disabled", true);

    $('#divCancelRemarks').css("display", ((RequestStatus !== '7') ? "none" : "inline-block"));
    $('#chkMultiPorter').prop('checked', ((MultiPorter != 'No') ? true : false)); $('#chkMultiPorter').prop('disabled', true);

    $('#txtPatientName').val(PatientName); $('#txtPatientName').prop('disabled', true);
    $('#txtRequestorName').val(RequestorName); $('#txtRequestorName').prop('disabled', true);

    $('#txtCanceRemarks').css("display", ((RequestStatus !== '7') ? "none" : "inline-block")); $('#txtCanceRemarks').prop('disabled', true);
    $('#divSelCRemarks').css("display", (((RequestStatus == '6') || (RequestStatus == '7')) ? "none" : "flex"));

    if (RequestStatus == '2')
        $('#divPorterRemarks').css("display", 'none');
    else
        $('#divPorterRemarks').css("display", 'inline-block');


    //setRemarks('search_CancelRemarks', 'txtCanceRemarks', CancelledRemarks);
    var FirstCharClR = CancelledRemarks.slice(0, 1), FirstCharR = Remarks.slice(0, 1);
    CancelledRemarks = ((FirstCharClR == ',') ? CancelledRemarks.substring(1) : CancelledRemarks); Remarks = ((FirstCharR == ',') ? Remarks.substring(1) : Remarks);
    $('#txtCanceRemarks').val(CancelledRemarks); $('#search_CancelRemarks').prop('disabled', true); $('#txtCanceRemarks').prop('disabled', true);
    //setRemarks('search_Remarks', 'txtRemarks', Remarks);
    $('#txtRemarks').val(Remarks); $('#search_Remarks').prop('disabled', true); $('#txtRemarks').prop('disabled', true); $('#divSelRemarks').css("display", "none");

    clearAllCheckBox('ReqCategories');

    LoadCategories('', CategoryID); ShowModalAddtask();

    setService(ServiceID);

}

function setService(ServiceCode) {

    if (ServiceCode == null)
        $('.services-btn-icon-modal').first().trigger('click');
    else {
        ServiceCode = (ServiceCode == '0') ? "1" : ServiceCode;
        sessionStorage.setItem('ServiceCode', ServiceCode);
        $('#divRService' + ServiceCode).trigger('click');
    }
}
function LoadPresetRemarks() {
    $.ajax({
        url: ReportUrl + "Process=PRESET&ACTION=GET&MSG=&GROUP=&ID=",
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var Remarks = $.grep(data, function (element, index) {
                return element.GROUPNAME == "REMARKS";
            });

            var CReason = $.grep(data, function (element, index) {
                return element.GROUPNAME == "CREASON";
            });

            var FReason = $.grep(data, function (element, index) {
                return element.GROUPNAME == "FREASON";
            });




            //clearSumoselect('drpRemarks');

            $('#search_Remarks').html(''); $('#search_Remarks')[0].sumo.add('0', '-- Select --'); $('#search_Remarks')[0].sumo.reload();

            $('#search_CancelRemarks').html(''); $('#search_CancelRemarks')[0].sumo.add('0', '-- Select --'); $('#search_CancelRemarks')[0].sumo.reload();

            $('#search_CompleteRemarks').html(''); $('#search_CompleteRemarks')[0].sumo.add('0', '-- Select --'); $('#search_CompleteRemarks')[0].sumo.reload();

            $.each(Remarks, function (key, value) {
                $('#search_Remarks')[0].sumo.add(value.ID, value.MESSAGE);
            });

            $.each(CReason, function (key, value) {
                $('#search_CancelRemarks')[0].sumo.add(value.ID, value.MESSAGE);
            });


            $.each(FReason, function (key, value) {
                $('#search_CompleteRemarks')[0].sumo.add(value.ID, value.MESSAGE);
            });

            // $('#search_Remarks')[0].sumo.add('Others', 'Others'); $('#search_CancelRemarks')[0].sumo.add('Others', 'Others'); $('#search_CompleteRemarks')[0].sumo.add('Others', 'Others');


            $('#search_Remarks')[0].sumo.selectItem(0); $('#search_CancelRemarks')[0].sumo.selectItem(0);

        },
        error: function (data) {

        }

    });
}


function CatSelection(ele, ID, IsTwoPorter, CatName) {

    $(ele).prop('checked', false);
    setCategories(OldCatID);


}
function setCategories(Id) {
    var eleID = "#chkCat" + Id;
    clearAllCheckBox('ReqCategories'); $(eleID).prop('checked', true);

    ReqCat = Id;
}
function ShowModalAddtask() {
    $('#addTask').modal({
        backdrop: 'static',
        keyboard: false
    })
    $('#addTask').modal('show');
}


function clearAllCheckBox(eleID) {

    $('#' + eleID + ' input:checkbox').prop('checked', false);
}


function LoadCategories(val, val1) {
    var selTS = '', selTE = '';
    $.ajax({
        async: true,
        url: ReportUrl + "Process=GETCATEGORIES&VAL=" + encodeURIComponent(Encrypt(val)) + "&VAL1=" + encodeURIComponent(Encrypt(val1)) + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode)),
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            var catUL = '';
            var dataCategory = $.grep(data, function (element, index) {
                return element.FILTER == "CATEGORY";
            });

            $.each(dataCategory, function (key, value) {

                selTS = (((val1 == value.ID) && (selTS === '')) ? value.TS : selTS); selTE = (((val1 == value.ID) && (selTE === '')) ? value.TE : selTE);

                catUL += '<li> <input type="checkbox" id="chkCat' + value.ID + '" onchange="CatSelection(this,' + "'" + value.ID + "','" + value.ISTWOPORTERTASK + "','" + value.VALUE + "'" + ');" ><span> <img src="../images/check.png"></span> <img src="' + value.IMAGEPATH + '" alt="' + value.VALUE + '"> <p>' + value.VALUE + '</p> </li>';
            });

            $("#ReqCategories").html('<ul>' + catUL + '</ul>');

            if (selTS != '' || selTE != '') {
                $('#lblKPITS').html(((selTS != '-' && selTS != '0') ? (selTS + '<br/> <span style="font-size:13px;"> (min) </span> ') : '-'));
                $('#lblKPITE').html(((selTE != '-' && selTE != '0') ? (selTE + '<br/> <span style="font-size:13px;"> (min) </span> ') : '-'));
            }
            //setTimeout(function () { setCategories(ReqCat);}, 400);

            $("#chkCat" + val1).prop('checked', true);

        },
        error: function (data) {
            $('#').html(data[0].RESULT);
        }
    });
}
function OnChangeRemarks(ele, txtRemark) {

    var val = $(ele).val(), eleID = $(ele).attr('id');

    if (val.length > 1)
        $(ele)[0].sumo.unSelectItem(0);
    else if (val == '')
        $(ele)[0].sumo.selectItem(0);



    //$('#' + txtRemark).css('display', ((val !== 'Others') ? "none" : "inline-block"));
    //if (val == 'Others')
    //    setTimeout(function () { $('#' + txtRemark).focus(); }, 200);
}

function setRemarks(sumosel, textbox, Remarks) {

    var remarkArr = Remarks.split(','), Options = getOptions(sumosel), textVal = '', OppArray = Options.split(',');

    $('#' + sumosel)[0].sumo.unSelectAll();

    if (Remarks.trim().length > 0) {

        $.each(remarkArr, function (index, value) {
            if (value.trim().length > 0) {
                var valueIndex = OppArray.indexOf(value);
                if (Options.includes(value))
                    $('#' + sumosel)[0].sumo.selectItem(valueIndex);
                else {
                    if (valueIndex != '-1')
                        $('#' + sumosel)[0].sumo.unSelectItem(valueIndex);
                    textVal += value + ',';
                }
            } else {
                $('#' + sumosel)[0].sumo.unSelectAll(); $('#' + sumosel)[0].sumo.reload(); $('#' + sumosel)[0].sumo.selectItem(0);
            }
        });
    } else {

        $('#' + sumosel)[0].sumo.unSelectAll(); $('#' + sumosel)[0].sumo.reload(); $('#' + sumosel)[0].sumo.selectItem(0);
    }

    textVal = textVal.slice(0, -1);

    $('#' + textbox).val(textVal);

}


function getOptions(drpSumo) {
    var valSel = '';
    $('#' + drpSumo + ' option').each(function (i) {
        valSel += $(this).text() + ',';
    });

    return valSel;
}

function openCompleteNotes(ComRemarks, ReqID, RequestStatus) {
    var arrRemarks = ComRemarks.split('|#|');
    document.getElementById('HFERID').value = ReqID;
    var htmlCompleteNotes = '';
    $('#chkMitigationCom').attr("src", "../images/MCheck.jpg");
    $.each(arrRemarks, function (index, value) {
        if (value.trim()) {
            var valueArray = value.split('|$|'), IsMitigation = valueArray[3].toString();
            htmlCompleteNotes += '<div class="msgContainer"><p class="msgUser">' + valueArray[0].toString() + ((IsMitigation == "YES") ? ('<span class="mitigation-right"> </span>') : '') + '</p> <p>' + valueArray[1].toString().replace('_', ' ') + '<span class="time-right">' + valueArray[2].toString() + '</span></div>';

        }
    });

    //$("#txtComRemarks").attr("disabled", "disabled");
    //if (RequestStatus == "6" || RequestStatus == "7" )
    $("#txtComRemarks").removeAttr("disabled"); $("#txtComRemarks").val('');
    $('#divComNotes').html(htmlCompleteNotes); $('#txtComRemarks').val(''); ShowModalPopUp('ModalCompleteNotes');

    $('#search_CompleteRemarks')[0].sumo.unSelectAll(); $('#search_CompleteRemarks')[0].sumo.reload(); $('#search_CompleteRemarks')[0].sumo.selectItem(0);

    setTimeout(function () { $('#txtComRemarks').focus(); $('#divComNotes').show(500); }, 1000);;
}



function submitNotes() {
    var drpCompleteRemark = selectedText('search_CompleteRemarks');
    var UID = sessionStorage.getItem('ID'), Remark = drpCompleteRemark + '_' + $('#txtComRemarks').val().trim();
    var ReqID = document.getElementById('HFERID').value;
    var srcMitigation = $('#chkMitigationCom').attr('src');
    var IsMitigation = (srcMitigation == "../images/NoMCheck.jpg") ? "0" : "1";
    if (Remark.length == 0) {
        $('#txtComRemarks').focus();
    } else {
        HideModalPopUp('ModalCompleteNotes'); ShowModalPopUp('ModalDoneAddRemarks');
        $.ajax({
            url: ReportUrl + "Process=ADDCOMPLETEREMARKS&REQUESTID=" + ReqID + "&USERID=" + UID + "&REMARKS=" + Remark + "&ISMITIGATION=" + IsMitigation,
            type: 'POST',
            data: 'pData',
            dataType: 'json',
            success: function (data) {
                if (data[0].RESULT.split("_")[0] === 'TRUE') {

                    setTimeout(function () { BindDateGrid(); HideModalPopUp('ModalDoneAddRemarks'); }, 1000);
                }
            },
            error: function (data) {
                $('#').html(data[0].RESULT);
            }
        });

    }
}
function GridDateWise_Command(sender, args) {
    args.set_cancel(true);
    pageIndex = parseInt(sender.get_masterTableView().get_currentPageIndex());
    pageSize = sender.get_masterTableView().get_pageSize();
    switch (args.get_commandName()) {
        case "Page":
        case "PageSize":
            BindDateGrid();
            break;
    }
}

function setRCheckbyID(eleId, eleIDUncheck) {

    var src = $('#' + eleId).attr('src'); //alert(src);
    $('#' + eleId).attr("src", (src == "../images/CNoCheck.png") ? "../images/CCheck.png" : "../images/CNoCheck.png");

    if (eleIDUncheck.length > 0)
        $('#' + eleIDUncheck).attr("src", "../images/CNoCheck.png");

}


function setRCheckbyIDDW(eleId, eleIDUncheck, eleIDUncheck1) {

    var src = $('#' + eleId).attr('src'); //alert(src);
    $('#' + eleId).attr("src", (src == "../images/CNoCheck.png") ? "../images/CCheck.png" : "../images/CNoCheck.png");

    if (eleIDUncheck.length > 0)
        $('#' + eleIDUncheck).attr("src", "../images/CNoCheck.png");


    if (eleIDUncheck1.length > 0)
        $('#' + eleIDUncheck1).attr("src", "../images/CNoCheck.png");

    setDateDW(((eleId == 'chkLastMonth') ? "PREV" : (eleId == 'chkThisYear') ? "YEAR" : "CURRENT"));

}

function setHaywoodRSUH(eleId, eleIDUncheck) {

    var src = $('#' + eleId).attr('src'); //alert(src);
    $('#' + eleId).attr("src", (src == "../images/CNoCheck.png") ? "../images/CCheck.png" : "../images/CNoCheck.png");

    //if (eleIDUncheck.length > 0)
    //    $('#' + eleIDUncheck).attr("src", "../images/CNoCheck.png");


}


function setDateDW(Duration) {

    var date = new Date(), y = date.getFullYear(), m = date.getMonth();
    var firstDay = new Date(y, m, 1);
    var lastDay = new Date(y, m + 1, 0);

    var LastDayLM = new Date(y, m, 0);
    var firstDayLM = new Date(LastDayLM.getFullYear(), LastDayLM.getMonth(), 1);

    var firstDayTY = new Date(y, 0, 1);
    var LastDayTY = new Date(y, 11, 31);

    var FormattedFirstDate = formatDateDW((Duration == 'PREV') ? firstDayLM : ((Duration == 'YEAR') ? firstDayTY : firstDay));
    var FormattedEndDate = formatDateDW((Duration == 'PREV') ? LastDayLM : ((Duration == 'YEAR') ? date : date));

    document.getElementById("txtfromdate").value = FormattedFirstDate;// + "T00:00";
    document.getElementById("txttodate").value = FormattedEndDate;//+ "T23:59";
    //document.getElementById("HFFrom").value = (Duration == 'PREV') ? firstDayLM : ((Duration == 'YEAR') ? firstDayTY : firstDay);
    //document.getElementById("HFTo").value = (Duration == 'PREV') ? LastDayLM : ((Duration == 'YEAR') ? LastDayTY : lastDay);

}




function formatDateDW(date) {

    //(date.getFullYear() + '-' + ('0' + (date.getMonth() + 1)).slice(-2) + '-' + ('0' + date.getDate()).slice(-2) + ' ' + date.getHours() + ':' + ('0' + (date.getMinutes())).slice(-2) + ':' + date.getSeconds());

    return date.getFullYear() + '-' + formatDateComponent(date.getMonth() + 1) + '-' + formatDateComponent(date.getDate());
}

function formatDateComponent(dateComponent) {
    return (dateComponent < 10 ? '0' : '') + dateComponent;
}
function BuildHeader() {

    var Header = "Patient/Notes Fields :- " + selectedText('search_PatientRemarks') + " & filter value:- " + $('#txtSearchPatient').val() + " <br/>" +
        "Task Fields :- " + selectedText('search_TaskFields') + " & filter value:- " + $('#txtSearchTask').val() + " <br/>" + GetActioningFilters() + " <br/><br/>" + getHaywoodHeader() + " <br/>";

    return Encrypt(Header);

}


function selectedText(drpSumo) {
    var valSel = '';
    $('#' + drpSumo + ' option:selected').each(function (i) {
        valSel += $(this).text() + ',';
    });


    return valSel.replace('-- Select --,', '').replace(/.$/, "");
}


function GetActioningFilters() {

    var srcMitigation = $('#chkMitigated').attr('src'), srcNotMitigated = $('#chkNotMitigated').attr('src'),
        srcADF = $('#chkADF').attr('src'), srcRDF = $('#chkRDF').attr('src'), srcCDF = $('#chkCDF').attr('src'),
        srcADP = $('#chkADP').attr('src'), srcRDP = $('#chkRDP').attr('src'), srcCDP = $('#chkCDP').attr('src');

    var IsMitigation = ((srcMitigation == "../images/CNoCheck.png") ? "0" : "1"), IsNotMitigated = ((srcNotMitigated == "../images/CNoCheck.png") ? "0" : "1"),
        IsADF = ((srcADF == "../images/CNoCheck.png") ? "0" : "1"), IsRDF = ((srcRDF == "../images/CNoCheck.png") ? "0" : "1"), IsCDF = ((srcCDF == "../images/CNoCheck.png") ? "0" : "1"),
        IsADP = ((srcADP == "../images/CNoCheck.png") ? "0" : "1"), IsRDP = ((srcRDP == "../images/CNoCheck.png") ? "0" : "1"), IsCDP = ((srcCDP == "../images/CNoCheck.png") ? "0" : "1");


    var Query = ((IsADF == '1') ? ' Allocation Duration Failed ,' : '') + ((IsRDF == '1') ? " Response Duration Failed ," : '') + ((IsCDF == '1') ? " Completion Duration Failed ," : '') +
        ((IsADP == '1') ? " Allocation Duration Passed , " : "") + ((IsRDP == '1') ? " Response Duration Passed , " : "") + ((IsCDP == '1') ? " Completion Duration Passed , " : "") +
        ((IsMitigation == '1') ? " Mitigated , " : "") + ((IsNotMitigated == '1') ? " Not Mitigated , " : "");

    return Query;
}


function getHeader(drpSumo, txtbox) {
    var valSel = '', valTxt = $('#' + txtbox).val();
    if (valTxt.length > 0) {
        $('#' + drpSumo + '  option:selected').each(function (i) {
            valSel += ((valSel.length > 0) ? " OR " : "") + setValue($(this).text(), valTxt);
        });

    }
    return valSel;
}
function setHeader(columns, colvalue) {

    var columnArr = columns.split('#'), query = '';


    $.each(columnArr, function (index, value) {
        if (value.trim().length > 0)
            query += ((query.length > 0) ? " OR " : "") + " ( " + value + " like '%" + colvalue + "%' ) ";
    });
    return query;
}
function DWQueryBuilder() {
    var PateintQuery = getValues('search_PatientRemarks', 'txtSearchPatient'), TaskQuery = getValues('search_TaskFields', 'txtSearchTask'),
        ActionQuery = GetCheckBoxValues(), HayWoodQuery = getHaywoodQuery(), CGQuery = (ServiceCode == '2') ? (($('#search_CatChargeGroup').val() == "All") ? "" : (($('#search_CatChargeGroup').val() == "Non-chargable") ? " AND ( ISNULL(CHARGEGROUP,'Non-chargable') LIKE '%" + $('#search_CatChargeGroup').val() + "%' ) " : " AND ( CM.CHARGEGROUP LIKE '%" + $('#search_CatChargeGroup').val() + "%' ) ")) : '';
    var finalQuery = ((PateintQuery.length > 0) ? ((TaskQuery.length > 0) ? ' AND ( ( ' + PateintQuery + ' ) OR ( ' + TaskQuery + ' ) ) ' : ' AND  ( ' + PateintQuery + ' ) ') : ((TaskQuery.length > 0) ? ' AND  ( ' + TaskQuery + ' ) ' : '')) + ActionQuery + HayWoodQuery + CGQuery;



    return Encrypt(finalQuery);
}

function getHaywoodQuery() {

    var src = $('#chkRSUH').attr('src'), src1 = $('#chkHaywood').attr('src'); //alert(src)

    var QueryHaywood = (((src == "../images/CNoCheck.png") && (src1 == "../images/CNoCheck.png")) || ((src == "../images/CCheck.png") && (src1 == "../images/CCheck.png"))) ? ''
        : ((src == "../images/CCheck.png") ? " AND ( Site LIKE '%RSUH%' ) " : ((src1 == "../images/CCheck.png") ? " AND ( Site LIKE '%Haywood%' ) " : ''));

    return QueryHaywood;
}


function getHaywoodHeader() {

    var srcRSUH = $('#chkRSUH').attr('src'), srcHaywood = $('#chkHaywood').attr('src');

    var IsRSUH = ((srcRSUH == "../images/CNoCheck.png") ? "0" : "1"), IsHaywood = ((srcHaywood == "../images/CNoCheck.png") ? "0" : "1");


    var Query = "Site :- " + ((IsRSUH == '1') ? ' RSUH ,' : '') + ((IsHaywood == '1') ? " Haywood " : '');

    return Query;
}

function GetCheckBoxValues() {

    var srcMitigation = $('#chkMitigated').attr('src'), srcNotMitigated = $('#chkNotMitigated').attr('src'),
        srcADF = $('#chkADF').attr('src'), srcRDF = $('#chkRDF').attr('src'), srcCDF = $('#chkCDF').attr('src'),
        srcADP = $('#chkADP').attr('src'), srcRDP = $('#chkRDP').attr('src'), srcCDP = $('#chkCDP').attr('src');

    var IsMitigation = ((srcMitigation == "../images/CNoCheck.png") ? "0" : "1"), IsNotMitigated = ((srcNotMitigated == "../images/CNoCheck.png") ? "0" : "1"),
        IsADF = ((srcADF == "../images/CNoCheck.png") ? "0" : "1"), IsRDF = ((srcRDF == "../images/CNoCheck.png") ? "0" : "1"), IsCDF = ((srcCDF == "../images/CNoCheck.png") ? "0" : "1"),
        IsADP = ((srcADP == "../images/CNoCheck.png") ? "0" : "1"), IsRDP = ((srcRDP == "../images/CNoCheck.png") ? "0" : "1"), IsCDP = ((srcCDP == "../images/CNoCheck.png") ? "0" : "1");


    var Query = ((IsADF == '1') ? ' AND ([RTAT] > KPIRESPONSE ) ' : '') + ((IsRDF == '1') ? " AND ( ISNULL(KPIRESPONSEMET,'NO') = 'NO' ) " : '') + ((IsCDF == '1') ? " AND ( ISNULL(KPIMET,'NO') = 'NO' ) " : '') +
        ((IsADP == '1') ? " AND ([RTAT] < KPIRESPONSE ) " : "") + ((IsRDP == '1') ? " AND ( ISNULL(KPIRESPONSEMET,'NO') = 'YES' ) " : "") + ((IsCDP == '1') ? " AND ( ISNULL(KPIMET,'NO') = 'YES' ) " : "") +
        ((IsMitigation == '1') ? " AND ( [HASMITIGATIONNOTES] = '1' ) " : "") + ((IsNotMitigated == '1') ? "  AND ( [HASMITIGATIONNOTES] = '0' ) " : "");

    return Query;
}
function RefreshDW() {

    $('#chkMitigated').attr('src', "../images/CNoCheck.png"); $('#chkNotMitigated').attr('src', "../images/CNoCheck.png");
    $('#chkADF').attr('src', "../images/CNoCheck.png"); $('#chkRDF').attr('src', "../images/CNoCheck.png");
    $('#chkCDF').attr('src', "../images/CNoCheck.png"); $('#chkADP').attr('src', "../images/CNoCheck.png");
    $('#chkRDP').attr('src', "../images/CNoCheck.png"); $('#chkCDP').attr('src', "../images/CNoCheck.png");
    $('#txtSearchPatient').val(''); $('#txtSearchTask').val('');
    $('#search_PatientRemarks')[0].sumo.unSelectAll(); $('#search_PatientRemarks')[0].sumo.reload(); $('#search_PatientRemarks')[0].sumo.selectItem(0);
    $('#search_TaskFields')[0].sumo.unSelectAll(); $('#search_TaskFields')[0].sumo.reload(); $('#search_TaskFields')[0].sumo.selectItem(0);

    Sfrom = document.getElementById("HFFrom").value;
    Sto = document.getElementById("HFTo").value;
    document.getElementById("txtfromdate").value = Sfrom;
    document.getElementById("txttodate").value = Sto;
    GetReport();
}


function getValues(drpSumo, txtbox) {
    var valSel = '', valTxt = $('#' + txtbox).val();
    if (valTxt.length > 0) {
        $('#' + drpSumo + '  option:selected').each(function (i) {
            valSel += ((valSel.length > 0) ? " OR " : "") + setValue($(this).val(), valTxt);
        });

    }
    return valSel;
}
function setValue(columns, colvalue) {

    var columnArr = columns.split('#'), query = '';


    $.each(columnArr, function (index, value) {
        if (value.trim().length > 0)
            query += ((query.length > 0) ? " OR " : "") + ((value == 'R.REQUESTID') ? " ( " + value + " = '" + colvalue + "' ) " : " ( " + value + " like '%" + colvalue + "%' ) ");
    });
    return query;
}

function OnchangeFilter(drpID, txtID) {
    var drpLength = $('#' + drpID).find('option:selected').length, txtValue = $('#' + txtID).val();
    if (drpLength > 0) {
        if (txtValue.length == 0)
            $('#' + txtID).focus();
        else
            GetReport();
    }
}


function Encrypt(Value) {
    var key = CryptoJS.enc.Utf8.parse(CryptoKey);
    var iv = CryptoJS.enc.Utf8.parse(CryptoPwd);

    var encryptedVal = CryptoJS.AES.encrypt(CryptoJS.enc.Utf8.parse(Value), key,
        {
            keySize: 128 / 8,
            iv: iv,
            mode: CryptoJS.mode.CBC,
            padding: CryptoJS.pad.Pkcs7
        });
    return encryptedVal;
}
function BindGridDateWise() {

    var selVal = $('#search_TaskFields').val(), txtVal = $('#txtSearchTask').val();
    if (selVal == 'R.REQUESTID' && txtVal.trim().length > 0) {
        PFrom = '2024-01-01T00:00'
        PTo = formatDateDW(new Date()) + 'T23:59';
    }

    var FilterQuery = DWQueryBuilder();
    var status = $('#selRequestStatus').val(), FinalUrl = ReportUrl + "PROCESS=DATEWISE&Search=" + encodeURIComponent(FilterQuery) + "&Status=" + status + "&From=" + convertDate(PFrom) + "&To=" + convertDate(PTo) + "&PageIndex=" + pageIndex + "&PageSize=" + pageSize + "&SERVICEID=" + encodeURIComponent(Encrypt(ServiceCode));
    $.ajax({
        url: FinalUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (typeof (grid) != 'undefined' && grid != null) {
                grid.clearSelectedItems();
                tableView = grid.get_masterTableView();
                if (data.length > 0) {
                    updateVirtualItemCount(data[0].VIC, tableView);
                    $('#spanRequestCount').html(data[0].VIC);
                } else {
                    $('#spanRequestCount').html('0');
                }

                if (pageIndex == '0')
                    tableView.set_currentPageIndex(pageIndex);
                tableView.set_dataSource(data);
                tableView.dataBind();
                ModifyGridDatewise(grid, status, ServiceCode);

                setTimeout(function () {
                    $('.loaderElement').css("display", "none");
                    HideModalPopUp('ModalLoading');
                }, 1000);
            }
        },
        error: function (data) {

        }

    });

    //SetEscalation(ReportUrl);

}


function ModifyGridDatewise(gridReport, Process, ServiceCode) {
    var grid = gridReport.get_masterTableView();

    switch (ServiceCode) {
        case "1":

            grid.hideColumn(grid.getColumnByUniqueName("ACKPHOTOTIMESTAMP").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ACKNAME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ACKCONTACT").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ACKLOCATION").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("CHARGEGROUP").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ACKSIGN").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ACKPHOTO").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("QUANTITY").get_element().cellIndex);

            grid.hideColumn(grid.getColumnByUniqueName("LOGS").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("PATIENTNAME").get_element().cellIndex);
            break;
        case "2":


            grid.showColumn(grid.getColumnByUniqueName("CHARGEGROUP").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("ACKPHOTOTIMESTAMP").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("ACKNAME").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("ACKCONTACT").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("ACKLOCATION").get_element().cellIndex);

            grid.showColumn(grid.getColumnByUniqueName("QUANTITY").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ACKSIGN").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ACKPHOTO").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("PATIENTNAME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("LOGS").get_element().cellIndex);

            break;


        case "3":

            grid.showColumn(grid.getColumnByUniqueName("ACKPHOTOTIMESTAMP").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("ACKNAME").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("ACKCONTACT").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("ACKLOCATION").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("CHARGEGROUP").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ACKSIGN").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("ACKPHOTO").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("QUANTITY").get_element().cellIndex);

            grid.hideColumn(grid.getColumnByUniqueName("LOGS").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("PATIENTNAME").get_element().cellIndex);
            break;
    }

    switch (Process) {
        case "7":
            grid.hideColumn(grid.getColumnByUniqueName("ENDTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("TAT").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("STARTTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("TTAT").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("REMARKS").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("UPDATEDBY").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("CANCELLEDAT").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("CANCELREMARKS").get_element().cellIndex);
            break;
        case "6":
        case "0":
            grid.showColumn(grid.getColumnByUniqueName("STARTTIME").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("ENDTIME").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("TAT").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("TTAT").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("REMARKS").get_element().cellIndex);
            if (Process == '0') {
                grid.showColumn(grid.getColumnByUniqueName("UPDATEDBY").get_element().cellIndex);
                grid.showColumn(grid.getColumnByUniqueName("CANCELLEDAT").get_element().cellIndex);
                grid.showColumn(grid.getColumnByUniqueName("CANCELREMARKS").get_element().cellIndex);
            } else {
                grid.hideColumn(grid.getColumnByUniqueName("UPDATEDBY").get_element().cellIndex);
                grid.hideColumn(grid.getColumnByUniqueName("CANCELREMARKS").get_element().cellIndex);
                grid.hideColumn(grid.getColumnByUniqueName("CANCELLEDAT").get_element().cellIndex);
            }
            break;
    }
}



function RowSelecting(sender, eventArgs) {
    ShowModalPopUp('ModalLoading');
    var PId = eventArgs.getDataKeyValue("ID"), PType = eventArgs.getDataKeyValue("PORTERNAME"), Date = eventArgs.getDataKeyValue("COUNT");
    GetChartData(ReportUrl + 'PROCESS=REPORT&From=' + convertDate(PFrom) + '&To=' + convertDate(PTo) + '&Type=' + ((InnerOption == 'POption1') ? "PORTERPEEKHOUR" : (InnerOption == 'POption2') ? "PORTERPERFORMANCE" : (InnerOption == 'POption3') ? "PORTERCATEGORYWISE" : "PORTERWISECATEGORYPERFORMANCE") + '&PorterId=' + PId, ((InnerOption == 'POption1') ? "REQUEST TIME" : (InnerOption == 'POption2') ? "REQUEST TIME" : (InnerOption == 'POption3') ? "REQUEST CATEGORY" : "REQUEST CATEGORY"), ((InnerOption == 'POption1') ? "NO. OF REQUESTS" : (InnerOption == 'POption2') ? "AVG TIME TAKEN ( IN MINUTES)" : (InnerOption == 'POption3') ? "NO. OF REQUESTS" : "AVG TIME TAKEN ( IN MINUTES)"));
}


function PValidate() {
    var from = GetDate(Sfrom.value), to = GetDate(Sto.value), FromDate = new Date(from), ToDate = new Date(to);
    if (Sfrom.value.length == 0)
        Sfrom.focus();
    else if (Sto.value.length == 0)
        Sto.focus();
    else if (FromDate > ToDate)
        Sto.focus();
    else {
        BindGrid();
        return false;
    }
}


function BindGridReport() {
    var status = $('#RequestStatus').val(), FinalUrl = ReportUrl + "PROCESS=GET&Status=" + status + "&From=" + convertDate(Sfrom.value) + "&To=" + convertDate(Sto.value) + "&Search=" + $('#txtAssignTo').val() + "&DEPTIDS=" + selDeptIDs + "&PageIndex=" + pageIndex + "&PageSize=" + pageSize;
    $.ajax({
        url: FinalUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (typeof (grid) != 'undefined' && grid != null) {
                grid.clearSelectedItems();
                tableView = grid.get_masterTableView();
                if (data.length > 0)
                    updateVirtualItemCount(data[0].VIC, tableView)
                if (pageIndex == '0')
                    tableView.set_currentPageIndex(pageIndex);
                tableView.set_dataSource(data);
                tableView.dataBind();
                ModifyGridReport(grid, status);
                setTimeout(function () {
                    $('.loaderElement').css("display", "none");
                    HideModalPopUp('ModalLoading');
                }, 1000);
            }
        },
        error: function (data) {

        }

    });

    SetEscalation(ReportUrl);

}

function SetEscalation(BaseUrl) {
    var FinalUrl = ReportUrl + "PROCESS=GETESCALATION&From=" + convertDate(Sfrom.value) + "&To=" + convertDate(Sto.value) + "&Search=" + $('#txtAssignTo').val();
    $.ajax({
        url: FinalUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            var ASCount = data[0].VALUE, SECount = data[1].VALUE;
            $('#tdASCount').html(ASCount + '%'); $('#tdSECount').html(SECount + '%');
        },
        error: function (data) {

        }

    });
}
function ModifyGridReport(gridReport, Process) {
    var grid = gridReport.get_masterTableView();
    switch (Process) {
        case "7":
            grid.hideColumn(grid.getColumnByUniqueName("ENDTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("TAT").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("STARTTIME").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("TTAT").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("REMARKS").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("UPDATEDBY").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("CANCELLEDAT").get_element().cellIndex);
            break;
        case "6":
        case "0":

            grid.showColumn(grid.getColumnByUniqueName("STARTTIME").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("ENDTIME").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("TAT").get_element().cellIndex);
            grid.showColumn(grid.getColumnByUniqueName("TTAT").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("REMARKS").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("UPDATEDBY").get_element().cellIndex);
            grid.hideColumn(grid.getColumnByUniqueName("CANCELLEDAT").get_element().cellIndex);
            break;
    }
}

function BindAlertGrid() {
    var FinalUrl = ReportUrl + "PROCESS=REPORT&From=" + convertDate(Sfrom.value) + "&To=" + convertDate(Sto.value) + "&Type=ALERT&Search=" + $('#txtPorter').val() + "&PageIndex=" + pageIndex + "&PageSize=" + pageSize;
    $.ajax({
        url: FinalUrl,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (typeof (grid) != 'undefined' && grid != null) {
                tableView = grid.get_masterTableView();
                tableView.clearSelectedItems();
                if (data.length > 0)
                    updateVirtualItemCount(data[0].VIC, tableView)
                if (pageIndex == '0')
                    tableView.set_currentPageIndex(pageIndex);
                tableView.set_dataSource(data);
                tableView.dataBind();
            }
            HideModalPopUp('ModalLoading');
        },
        error: function (data) {

        }

    });
}
function GridAlert_OnDataBound(sender, args) {
    var MasterTable = sender.get_masterTableView();
    MasterTable.set_virtualItemCount(5);
    alert("Virtual item count: " + MasterTable.get_virtualItemCount());

}

function GridAlert_Command(sender, args) {
    args.set_cancel(true);
    pageIndex = parseInt(sender.get_masterTableView().get_currentPageIndex());
    pageSize = sender.get_masterTableView().get_pageSize();
    switch (args.get_commandName()) {
        case "Page":
        case "PageSize":
            BindGrid();
            break;
    }
}
function updateVirtualItemCount(result, tableView) {
    tableView.set_virtualItemCount(result);
}
function AValidate() {
    var from = convertDate(Sfrom.value), to = convertDate(Sto.value), FromDate = new Date(from), ToDate = new Date(to);
    if (Sfrom.value.length == 0)
        Sfrom.focus();
    else if (Sto.value.length == 0)
        Sto.focus();
    else if (FromDate > ToDate)
        Sto.focus();
    else {
        pageIndex = 0;
        BindGrid();
        return false;
    }
}

function ExportExcel(From, To, Header) {
    var Url = ReportUrl + "PROCESS=EXPORTCATEGORY&From=" + convertDate(From) + "&To=" + convertDate(To) + "&Header=" + Header;
    $.ajax({
        url: Url,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var downloadLink = document.createElement("a");
            downloadLink.href = 'data:application/vnd.ms-excel,' + encodeURIComponent(data[0].Result);
            downloadLink.download = Header;

            document.body.appendChild(downloadLink);
            downloadLink.click();
            document.body.removeChild(downloadLink);
            HideModalPopUp('ModalTimeTaken');
        },
        error: function (data) {

        }

    });
}
function ExportExcelTimewise(From, To, Category, Header) {
    var Url = ReportUrl + "PROCESS=EXPORTTIMEWISE&From=" + convertDate(From) + "&To=" + convertDate(To) + "&Header=" + Header + "&Category=" + Category;
    $.ajax({
        url: Url,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var downloadLink = document.createElement("a");
            downloadLink.href = 'data:application/vnd.ms-excel,' + encodeURIComponent(data[0].Result);
            downloadLink.download = Header;

            document.body.appendChild(downloadLink);
            downloadLink.click();
            document.body.removeChild(downloadLink);
            HideModalPopUp('ModalTimeTaken');
        },
        error: function (data) {

        }

    });
}

function TCategoryCount(RPurl, From, To, PROC, Header, titleD, DeptIDs) {
    var Url = RPurl + "PROCESS=DYNEXPORTSINGLEPARAM&From=" + convertDate(From) + "&To=" + convertDate(To) + "&Header=" + titleD + "&PROC=" + PROC + "&PARAM1=DEPTIDS&VALUE1=" + DeptIDs;
    $.ajax({
        url: Url,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var downloadLink = document.createElement("a");
            downloadLink.href = 'data:application/vnd.ms-excel,' + encodeURIComponent(data[0].Result);
            downloadLink.download = Header;

            document.body.appendChild(downloadLink);
            downloadLink.click();
            document.body.removeChild(downloadLink);
            HideModalPopUp('ModalTimeTaken');
        },
        error: function (data) {

        }

    });
}

function TCategoryCancelCount(RPurl, From, To, PROC, Header, titleD, DeptIDs) {
    var Url = RPurl + "PROCESS=DYNEXPORTSINGLEPARAMTWOTABLE&From=" + convertDate(From) + "&To=" + convertDate(To) + "&Header=" + titleD + "&PROC=" + PROC + "&PARAM1=DEPTIDS&VALUE1=" + DeptIDs + "&SubHeader=NO.OF CALLS VS CANCELLED CALLS&SubHeader1=CAREGORYWISE REQUEST COUNT";
    $.ajax({
        url: Url,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var downloadLink = document.createElement("a");
            downloadLink.href = 'data:application/vnd.ms-excel,' + encodeURIComponent(data[0].Result);
            downloadLink.download = Header;

            document.body.appendChild(downloadLink);
            downloadLink.click();
            document.body.removeChild(downloadLink);
            HideModalPopUp('ModalTimeTaken');
        },
        error: function (data) {

        }

    });
}


function ExportPorterWise(From, To, Header) {
    var Url = ReportUrl + "PROCESS=EXPORTPORTERWISE&From=" + GetDate(From) + "&To=" + GetDate(To) + "&Header=" + Header;
    $.ajax({
        url: Url,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var downloadLink = document.createElement("a");
            downloadLink.href = 'data:application/vnd.ms-excel,' + encodeURIComponent(data[0].Result);
            downloadLink.download = Header;

            document.body.appendChild(downloadLink);
            downloadLink.click();
            document.body.removeChild(downloadLink);
            HideModalPopUp('ModalTimeTaken');
        },
        error: function (data) {

        }

    });
}
function ExportDateReport(From, To, Header, Status, Porter) {
    var Url = ReportUrl + "PROCESS=EXPORTDATEWISE&From=" + GetDate(From) + "&To=" + GetDate(To) + "&Header=" + Header + "&Status=" + Status + "&Porter=" + Porter;
    $.ajax({
        url: Url,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            if (data[0].Result !== 'No Data') {
                var downloadLink = document.createElement("a");
                downloadLink.href = 'data:application/vnd.ms-excel,' + encodeURIComponent(data[0].Result);
                downloadLink.download = Header;

                document.body.appendChild(downloadLink);
                downloadLink.click();
                document.body.removeChild(downloadLink);
            }
            else
                alert('No Records to Export.')

            HideModalPopUp('ModalTimeTaken');
        },
        error: function (data) {

        }

    });
}

function ExportDailyReport(From, To, Header) {
    var Url = ReportUrl + "PROCESS=EXPORTDAILYWISE&From=" + GetDate(From) + "&To=" + GetDate(To) + "&Header=" + Header;
    $.ajax({
        url: Url,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {

            var downloadLink = document.createElement("a");
            downloadLink.href = 'data:application/vnd.ms-excel,' + encodeURIComponent(data[0].Result);
            downloadLink.download = Header;

            document.body.appendChild(downloadLink);
            downloadLink.click();
            document.body.removeChild(downloadLink);
            HideModalPopUp('ModalTimeTaken');
        },
        error: function (data) {

        }

    });
}
function DatewiseValidate() {
    var from = convertDate(Sfrom.value), to = convertDate(Sto.value), FromDate = new Date(from), ToDate = new Date(to), retVal = false;
    if (Sfrom.value.length == 0)
        Sfrom.focus();
    else if (Sto.value.length == 0)
        Sto.focus();
    else if (FromDate > ToDate)
        Sto.focus();
    else {
        retVal = true;
    }
    return retVal;
}
function ShowModalPopUp(ModalId) {
    $('#' + ModalId).modal('show');
}
function HideModalPopUp(ModalId) {
    $('#' + ModalId).modal('hide');
}
function Redirect(RedirectTo) {
    window.location = RedirectTo;
}

function DynExport(From, To, Header, PROC, title) {
    var Url = RPurl + "PROCESS=DYNEXPORT&From=" + convertDate(From) + "&To=" + convertDate(To) + "&Header=" + Header + "&PROC=" + PROC;
    $.ajax({
        url: Url,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (data) {
            if (data.length > 0) {
                var downloadLink = document.createElement("a");
                downloadLink.href = 'data:application/vnd.ms-excel,' + encodeURIComponent(data[0].Result);
                downloadLink.download = title;

                document.body.appendChild(downloadLink);
                downloadLink.click();
                document.body.removeChild(downloadLink);
            } else {
                alert('No Records Found.')
            }
            HideModalPopUp('ModalTimeTaken');
        },
        error: function (data) {

        }

    });
}



function OnchangeDept(InputID, ContainerID, BURL) {
    var SearchVal = $('#' + InputID).val();

    if (SearchVal.length > 0) {
        $.ajax({
            async: true,
            url: BURL + "Process=SEARCHDEPT&VALUE=" + SearchVal + "&SELECTEDIDS=" + selDeptIDs,
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


function BindDept(Id, Location) {
    sessionStorage.setItem('DeptLOCID', Id); sessionStorage.setItem('DeptLOC', Location);
    $('#txtDeptLocation').val(Location);
    $('#DivLocContent').css('display', 'none');
}


function ADDDeptLocation(InputID, ContainerID) {
    var value = $("#" + InputID).val();
    var DId = sessionStorage.getItem('DeptLOCID'), Location = sessionStorage.getItem('DeptLOC');
    if (value.length > 0 && (DId !== '0') && (Location !== '0')) {
        searchLocation.push({ "ID": DId, "LOCATION": Location });
        LoadDept(searchLocation, ContainerID, InputID);
    }
    else {
        $("#" + InputID).val(''); $("#" + InputID).focus();
    }

}

function DELDept(ID, ContainerID, InputID) {

    searchLocation = searchLocation.filter(function (loc) {
        return loc.ID !== ID;
    });

    LoadDept(searchLocation, ContainerID, InputID);
}

function LoadDept(Array, ContainerID, InputID) {
    var LocIDs = '', selDeptss = '';

    var Table = "<table width='95%' cellpadding='5' cellspacing='5' style='border-collapse: collapse;border: 1px solid gray;margin-top: 10px;'> <tr style='border: 1px solid gray;height:25px;'> <td align='center'style='width:90px;border: 1px solid gray;vertical-align: middle;'> DEPARTMENT  </td> <td align='center'style='width:50px;border: 1px solid gray;vertical-align: middle;'> DELETE </td> </tr>";

    Array.forEach((Loc) => {
        LocIDs += (LocIDs.length > 0) ? "," + Loc.ID : Loc.ID;

        selDeptss += (selDeptss.length > 0) ? "," + Loc.LOCATION : Loc.LOCATION;

        Table += "<tr style='border: 1px solid gray;' > <td align='left' style='width:90px;border: 1px solid gray;vertical-align: middle;' > " + Loc.LOCATION + "</td> " +
            "<td align='center' style='border: 1px solid gray;vertical-align: middle;'> <img src='Images/Delete.png' style='cursor: pointer;outline: none;width: 30px;padding: 3px;vertical-align: middle;' onclick='DELDept(" + '"' + Loc.ID + '"' + ', "' + ContainerID + '"' + ', "' + InputID + '"' + ");return false;' /> </td> </tr>";

    });
    Table += "</tr></table>";

    selDeptIDs = LocIDs;
    selDepts = selDeptss;
    $('#' + ContainerID + '').html(Table);

    $("#" + InputID).val(''); sessionStorage.setItem('DeptLOCID', '0'); sessionStorage.setItem('DeptLOC', '0');

}