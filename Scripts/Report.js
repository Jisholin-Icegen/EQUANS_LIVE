var CatInnerOption = ["Option1", "Option2", "Option3", "Option4", "Option5"], TimeInnerOption = ["Option1", "Option2", "Option3"], PorterInnerOption = ["Option1", "Option2", "Option3", "Option4"];
function selectOption(Opt, PageFrom) {
    var InnerArray = (PageFrom == 'Time') ? TimeInnerOption : (PageFrom == 'Cat') ? CatInnerOption : (PageFrom == 'Porter') ? PorterInnerOption : [];
    $.each(InnerArray, function (index, value) {
        if (value == Opt) {
            $('#' + value).addClass('ChartOptionSelected');
            InnerOption = Opt;
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
            HideModalPopUp('ModalLoading');
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

    var from = (FromDocReady) ? Sfrom : convertDate(Sfrom.value), to = (FromDocReady) ? Sto : convertDate(Sto.value);
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
        ShowModalPopUp('ModalLoading');
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
            HideModalPopUp('ModalLoading');
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
    var from = (FromDocReady) ? Sfrom : convertDate(Sfrom.value), to = (FromDocReady) ? Sto : convertDate(Sto.value);
    var FromDate = new Date(from), ToDate = new Date(to);

    //var from = GetDate((FromDocReady) ? Sfrom : Sfrom.value), to = GetDate((FromDocReady) ? Sto : Sto.value), FromDate = new Date(from), ToDate = new Date(to);
    if (FromDocReady) {
        ShowModalPopUp('ModalLoading');
        GetChartData(ReportUrl + 'PROCESS=REPORT&From=' + from + '&To=' + to + '&Type=' + ((InnerOption == 'Option2') ? "CATEGORYWISEASSIGNWAITTIME" : (InnerOption == 'Option3') ? "CATEGORYWISEPROGRESSWAITTIME" : (InnerOption == 'Option4') ? "PERFORMANCECATEGORYWISE" : (InnerOption == 'Option5') ? "PERFORMANCETOTALCATEGORYWISE" : "CATEGORYWISE"), 'REQUEST CATEGORY', ((InnerOption == 'Option1') ? 'NO. OF REQUESTS' : 'AVG TIME TAKEN ( IN MINUTES)'));
    }
    else if (Sfrom.value.length == 0)
        Sfrom.focus();
    else if (Sto.value.length == 0)
        Sto.focus();
    else if (FromDate > ToDate)
        Sto.focus();
    else {
        ShowModalPopUp('ModalLoading');
        GetChartData(ReportUrl + 'PROCESS=REPORT&From=' + from + '&To=' + to + '&Type=' + ((InnerOption == 'Option2') ? "CATEGORYWISEASSIGNWAITTIME" : (InnerOption == 'Option3') ? "CATEGORYWISEPROGRESSWAITTIME" : (InnerOption == 'Option4') ? "PERFORMANCECATEGORYWISE" : (InnerOption == 'Option5') ? "PERFORMANCETOTALCATEGORYWISE" : "CATEGORYWISE"), 'REQUEST CATEGORY', ((InnerOption == 'Option1') ? 'NO. OF REQUESTS' : 'AVG TIME TAKEN ( IN MINUTES)'));
        return false;
    }
}

function TValidate(FromDocReady, Sfrom, Sto) {

    var from = (FromDocReady) ? Sfrom : convertDate(Sfrom.value), to = (FromDocReady) ? Sto : convertDate(Sto.value);
    var FromDate = new Date(from), ToDate = new Date(to);

    //var from = GetDate((FromDocReady) ? Sfrom : Sfrom.value), to = GetDate((FromDocReady) ? Sto : Sto.value), FromDate = new Date(from), ToDate = new Date(to);
    if (FromDocReady) {
        ShowModalPopUp('ModalLoading');
        GetChartData(ReportUrl + 'PROCESS=REPORT&From=' + from + '&To=' + to + '&Type=' + ((InnerOption == 'Option1') ? "PEEKHOURTIME" : (InnerOption == 'Option2') ? "HOURLYASSIGNWAIT" : "HOURLYPROGRESSWAIT") + '&PorterId=' + selDeptIDs + '&Search=' + ($('#DrpCategory').val() != '0' ? $('#DrpCategory').val() : ''), 'REQUEST TIME', ((InnerOption == 'Option1') ? 'NO. OF REQUESTS' : 'AVG TIME TAKEN ( IN MINUTES)'));
    }
    else if (Sfrom.value.length == 0)
        Sfrom.focus();
    else if (Sto.value.length == 0)
        Sto.focus();
    else if (FromDate > ToDate)
        Sto.focus();
    else {
        ShowModalPopUp('ModalLoading');
        GetChartData(ReportUrl + 'PROCESS=REPORT&From=' + from + '&To=' + to + '&Type=' + ((InnerOption == 'Option1') ? "PEEKHOURTIME" : (InnerOption == 'Option2') ? "HOURLYASSIGNWAIT" : "HOURLYPROGRESSWAIT") + '&PorterId=' + selDeptIDs + '&Search=' + ($('#DrpCategory').val() != '0' ? $('#DrpCategory').val() : ''), 'REQUEST TIME', ((InnerOption == 'Option1') ? 'NO. OF REQUESTS' : 'AVG TIME TAKEN ( IN MINUTES)'));
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
                GetChartData(ReportUrl + 'PROCESS=REPORT&From=' + convertDate(PFrom) + '&To=' + convertDate(PTo) + '&Type=' + ((InnerOption == 'Option1') ? "PORTERPEEKHOUR" : (InnerOption == 'Option2') ? "PORTERPERFORMANCE" : (InnerOption == 'Option3') ? "PORTERCATEGORYWISE" : "PORTERWISECATEGORYPERFORMANCE") + '&PorterId=' + PId, ((InnerOption == 'Option1') ? "REQUEST TIME" : (InnerOption == 'Option2') ? "REQUEST TIME" : (InnerOption == 'Option3') ? "REQUEST CATEGORY" : "REQUEST CATEGORY"), ((InnerOption == 'Option1') ? "NO. OF REQUESTS" : (InnerOption == 'Option2') ? "AVG TIME TAKEN ( IN MINUTES)" : (InnerOption == 'Option3') ? "NO. OF REQUESTS" : "AVG TIME TAKEN ( IN MINUTES)"));

            }
        },
        error: function (data) {

        }

    });
}

function RowSelecting(sender, eventArgs) {
    ShowModalPopUp('ModalLoading');
    var PId = eventArgs.getDataKeyValue("ID"), PType = eventArgs.getDataKeyValue("PORTERNAME"), Date = eventArgs.getDataKeyValue("COUNT");
    GetChartData(ReportUrl + 'PROCESS=REPORT&From=' + convertDate(PFrom) + '&To=' + convertDate(PTo) + '&Type=' + ((InnerOption == 'Option1') ? "PORTERPEEKHOUR" : (InnerOption == 'Option2') ? "PORTERPERFORMANCE" : (InnerOption == 'Option3') ? "PORTERCATEGORYWISE" : "PORTERWISECATEGORYPERFORMANCE") + '&PorterId=' + PId, ((InnerOption == 'Option1') ? "REQUEST TIME" : (InnerOption == 'Option2') ? "REQUEST TIME" : (InnerOption == 'Option3') ? "REQUEST CATEGORY" : "REQUEST CATEGORY"), ((InnerOption == 'Option1') ? "NO. OF REQUESTS" : (InnerOption == 'Option2') ? "AVG TIME TAKEN ( IN MINUTES)" : (InnerOption == 'Option3') ? "NO. OF REQUESTS" : "AVG TIME TAKEN ( IN MINUTES)"));
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


function DValidate() {
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
                HideModalPopUp('ModalLoading');
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
function GridReport_RowDataBound(sender, args) {
    var IsDelay = args.get_item().getDataKeyValue("ISDELAY"), Tat = args.get_item().getDataKeyValue("ATAT");
    args.get_item().removeCssClass("IsDelayed");
    args.get_item().removeCssClass("TimeExeed");
    args.get_item().addCssClass("rgAltRow");
    if (IsDelay == 1) {
        args.get_item().addCssClass("IsDelayed");
    }
    else if (parseInt(Tat) > 10) {
        args.get_item().addCssClass("TimeExeed");
    }
}

function GridReport_Command(sender, args) {
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