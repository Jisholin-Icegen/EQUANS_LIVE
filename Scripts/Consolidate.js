
var Render_Type = ["line_ChartStatus_1000", "doughnut3d_ChartStatus1_2000", "pie3d_ChartStatus2_4000", "bar3d_ChartStatus3_6000"];

var width = ($(window).width() * 100) / 250;
function GetDate(date) {
    return date.split('/')[1] + '/' + date.split('/')[0] + '/' + date.split('/')[2];
}
function GetDateWiseReport(URL) {
    $.ajax({
        async: true,
        url: URL,
        type: 'POST',
        data: 'pData',
        dataType: 'json',
        success: function (msg) {
            BindChart(msg);
        },
        error: function (msg) {
            return [];
        }

    });
}
function BindChart(msg) {
    $.each(Render_Type, function (index, value) {
        var ChartType = value.split('_')[0], RenderAt = value.split('_')[1], TimeoutInterval = value.split('_')[2];
        if (msg.length == 0)
            $('#' + RenderAt).css("display", "none");
        else {
            $('#' + RenderAt).css("display", "table-row");
            //FusionRender(ChartType, RenderAt, width, 'REQUEST STATUS', 'NO. OF REQUESTS', msg);
            setTimeout(FusionRender(ChartType, RenderAt, width,'REQUEST STATUS', 'NO. OF REQUESTS', msg), (index * 500));
        }
    });
}
function FusionRender(Type, RenderAt, width, xAxis, yAxis, msg) {
    FusionCharts.ready(function () {
        var revenueChart = new FusionCharts({
            type: Type,
            renderAt: RenderAt,
            width: width,
            height: "220",
            dataFormat: "json",
            dataSource: {
                "chart": {
                    "caption": "",
                    "subCaption": "",
                    "xAxisName": xAxis,
                    "yAxisName": yAxis,
                    "theme": "fint",
                    "bgColor": "#D7D7D7"

                },
                "data": msg  //$(json).filter(function (i, n) { return msg.website === 'yahoo' })
            }
        });
        revenueChart.render(RenderAt);
    });
}
function Rvalidate(FromDocReady, Sfrom, Sto, ChartType, RenderAt) {
    var from = GetDate((FromDocReady) ? Sfrom : Sfrom.value), to = GetDate((FromDocReady) ? Sto : Sto.value), FromDate = new Date(from), ToDate = new Date(to);
    if (FromDocReady)
        GetDateWiseReport(ReportUrl + 'PROCESS=REPORT&From=' + from + '&To=' + to + '&Type=DATEWISE');
    else if (Sfrom.value.length == 0)
        Sfrom.focus();
    else if (Sto.value.length == 0)
        Sto.focus();
    else if (FromDate > ToDate)
        Sto.focus();
    else {
        GetDateWiseReport(ReportUrl + 'PROCESS=REPORT&From=' + from + '&To=' + to + '&Type=DATEWISE');
        return false;
    }
}