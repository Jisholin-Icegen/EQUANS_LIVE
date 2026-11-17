using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Text;
using System.Net;
using System.Configuration;
using System.Data.SqlClient;
using ClientsideEncryption;
using System.Web.Services.Description;
using System.Activities.Expressions;

public partial class ServiceFinance : System.Web.UI.Page
{
    public static string process { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsValidProtocol())
            FromWebMobile();
        else
            WriteInvalid();
    }

    public bool IsValidProtocol()
    {
        string ProtocolAllowed = ConfigurationManager.AppSettings["HTTP"].ToString(), RequestProtocol = (HttpContext.Current.Request.IsSecureConnection) ? "https" : "http";
        return true;// (ProtocolAllowed == RequestProtocol);
    }
    public void WriteInvalid()
    {

        DataTable table = generate(); DataRow row = table.NewRow(); row["RESULT"] = "Request Protocal is InValid"; table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);

        ResponseWrite(DS);
    }

    public void ResponseWrite(DataSet data)
    {
        JavaScriptSerializer serializer = new JavaScriptSerializer() { MaxJsonLength = int.MaxValue };
        List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
        Dictionary<string, object> row;

        foreach (DataTable table in data.Tables)
        {
            if (table.Rows.Count > 0)
            {
                foreach (DataRow dr in table.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in table.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
        }
        Response.Write(serializer.Serialize(rows));
    }

    private DataTable generate()
    {
        DataColumn column;
        DataRow row;
        var table = new DataTable() { TableName = "OptionAdd" };
        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "RESULT";
        table.Columns.Add(column);
        return table;
    }
    public void FromWebMobile()
    {
        DataSet data = new DataSet();
        process = ((!string.IsNullOrEmpty(Request.QueryString["Process"])) ? Request.QueryString["Process"].ToString().ToUpper() : "");
        switch (process)
        {

            case "FINANCEREPORT":
                data = FinanceReport();
                break;


            case "DETAILEDREPORT":
                data = DetailedReport();
                break;
        }
        //data = getRecords();
        JavaScriptSerializer serializer = new JavaScriptSerializer() { MaxJsonLength = int.MaxValue };
        List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
        Dictionary<string, object> row;

        foreach (DataTable table in data.Tables)
        {
            if (table.Rows.Count > 0)
            {
                foreach (DataRow dr in table.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in table.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
        }
        Response.Write(serializer.Serialize(rows));
    }

    // OLA Module

    private DataSet DetailedReport()
    {

        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? Request.QueryString["From"].ToString() : ""),
              To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? Request.QueryString["To"].ToString() : ""),
              InnerHeader = ((!string.IsNullOrEmpty(Request.QueryString["InnerHeader"])) ? Request.QueryString["InnerHeader"].ToString() : "");
        From = AESEncrytDecry.DecryptStringAES(From);
        To = AESEncrytDecry.DecryptStringAES(To);

        InnerHeader = AESEncrytDecry.DecryptStringAES(InnerHeader);

        DataTable TblMax = GetTableMax(); DataRow row; DataSet DataSet = new DataSet();
        DataTable ds = DataAccess.GetRecords("SP_DETAILREPORT_CATERING", "@FROM", From, "@TO", To);

        if (ds.Rows.Count > 0)
        {
            GridView TmpGrid = new GridView(); TmpGrid.DataSource = ds; TmpGrid.DataBind();
            string style = "<style>  .Ntext { mso-number-format:\\\"\" + @\"\\@\" + \"\\\"\" + \";font-weight:bold;font-size: 0.7em;color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;vertical-align:middle !important;text-align:left;}  .text { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold;font-size: 0.9em;color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;}      .Header  { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold !important;font-size: 1.1em !important;vertical-align:middle !important;background-color: #174982 !important;color: white !important;font-family: Arial !important, sans-serif;text-transform: uppercase;text-decoration: none;min-width:100px !important;max-width:200px !important;} </script> ";
            TmpGrid.GridLines = GridLines.Both;
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            //stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;width:700px !important;'> CTS REPORT (DEPT. OF HOUSEKEEPING)  </h3> <br/>");
            stringWrite.Write(" <br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'> " + InnerHeader + "  </h3> <br/>");

            for (int i = 0; i <= TmpGrid.HeaderRow.Cells.Count - 1; i++)
            {
                //31535   04 - 11 - 2024  Non - chargable   Food Trolley Check - No PI  5   Trent.W120.Rec.121 - 009      04 / 11 / 2024 10:33    04 / 11 / 2024 11:01    04 / 11 / 2024 11:02    04 / 11 / 2024 11:05.. / Catering / 9151_31535_sign11_4_202411_05_09AM.png NO
                int width = (i == 0) ? 100 : ((i == 1) ? 150 : (i == 2) ? 300 : (i == 3) ? 300 : (i == 4) ? 100 : (i == 5) ? 250 : (i == 6) ? 400 : (i == 7) ? 150 : (i == 8) ? 150 : (i == 9) ? 150 : (i == 10) ? 150 : (i == 11) ? 300 : (i == 12) ? 0 : (i == 13) ? 0 : 100);
                //TmpGrid.HeaderRow.Cells[i].BorderColor = System.Drawing.Color.White; TmpGrid.HeaderRow.Cells[i].Text = "";
                TmpGrid.HeaderRow.Cells[i].Width = width; TmpGrid.HeaderRow.Cells[i].CssClass = "Header"; //TmpGrid.HeaderRow.Cells[i].Height = 0;
                TmpGrid.HeaderRow.Cells[i].Height = 50; TmpGrid.HeaderRow.Cells[i].VerticalAlign = VerticalAlign.Middle;
            }
            foreach (GridViewRow r in TmpGrid.Rows)
            {
                //string[] colEmpty = { "&nbsp;", "Task Response Time", "Note: All Tasks registered as Daily Admin tasks counted as portering task", "Security tasks have not been included" }, colHeader = { "Task Response Time" }, colHeaderRow = { "Task Completion Time" };


                for (int i = 0; i <= r.Cells.Count - 1; i++)
                {
                    string IsHeader = r.Cells[12].Text.Trim();

                    if (IsHeader == "YES")
                    {
                        r.Cells[i].Height = 50; r.Cells[i].VerticalAlign = VerticalAlign.Middle;
                        r.Cells[i].CssClass = "Header";
                    }
                    else
                    {
                        if (i != 0)
                            r.Cells[i].CssClass = "Ntext";
                        else
                            r.Cells[i].CssClass = "text";
                    }


                    if (IsHeader == "EMPTY")
                    {
                        r.Cells[i].BorderColor = System.Drawing.Color.White;
                        r.Cells[i].Text = "";
                    }

                }
            }
            //TmpGrid.Columns.RemoveAt(3);
            TmpGrid.RenderControl(htmlWrite);


            stringWrite.Write(" <br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'>  </h3> <br/>");
            stringWrite.Write(" <br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'>  </h3> <br/>");

            String FinalContent = style + stringWrite.ToString();
            row = TblMax.NewRow(); row["Result"] = FinalContent.ToString(); TblMax.Rows.Add(row);
        }
        DataSet.Tables.Add(TblMax);
        return DataSet;

    }
    private DataSet FinanceReport()
    {

        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? Request.QueryString["From"].ToString() : ""),
              To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? Request.QueryString["To"].ToString() : ""),
              InnerHeader = ((!string.IsNullOrEmpty(Request.QueryString["InnerHeader"])) ? Request.QueryString["InnerHeader"].ToString() : "");
        From = AESEncrytDecry.DecryptStringAES(From);
        To = AESEncrytDecry.DecryptStringAES(To);

        InnerHeader = AESEncrytDecry.DecryptStringAES(InnerHeader);

        DataTable TblMax = GetTableMax(); DataRow row; DataSet DataSet = new DataSet();
        DataTable ds = DataAccess.GetRecords("SP_FINANCEREPORT_CATERING", "@FROM", From, "@TO", To);

        if (ds.Rows.Count > 0)
        {
            GridView TmpGrid = new GridView(); TmpGrid.DataSource = ds; TmpGrid.DataBind();
            string style = "<style>  .Ntext { mso-number-format:\\\"\" + @\"\\@\" + \"\\\"\" + \";font-weight:bold;font-size: 0.7em;color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;vertical-align:middle !important;text-align:left;}  .text { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold;font-size: 0.9em;color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;}      .Header  { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold !important;font-size: 1.1em !important;vertical-align:middle !important;background-color: #174982 !important;color: white !important;font-family: Arial !important, sans-serif;text-transform: uppercase;text-decoration: none;min-width:100px !important;max-width:200px !important;} </script> ";
            TmpGrid.GridLines = GridLines.Both;
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            //stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;width:700px !important;'> CTS REPORT (DEPT. OF HOUSEKEEPING)  </h3> <br/>");
            stringWrite.Write(" <br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'> " + InnerHeader + "  </h3> <br/>");

            for (int i = 0; i <= TmpGrid.HeaderRow.Cells.Count - 1; i++)
            {
                int width = (i == 0) ? 400 : ((i == 1) ? 230 : (i == 2) ? 200 : (i == 3) ? 0 : 100);
                TmpGrid.HeaderRow.Cells[i].BorderColor = System.Drawing.Color.White; TmpGrid.HeaderRow.Cells[i].Text = "";
                TmpGrid.HeaderRow.Cells[i].Width = width; TmpGrid.HeaderRow.Cells[i].Height = 0;
                //TmpGrid.HeaderRow.Cells[i].Height = 50; TmpGrid.HeaderRow.Cells[i].VerticalAlign = VerticalAlign.Middle;
            }
            foreach (GridViewRow r in TmpGrid.Rows)
            {
                //string[] colEmpty = { "&nbsp;", "Task Response Time", "Note: All Tasks registered as Daily Admin tasks counted as portering task", "Security tasks have not been included" }, colHeader = { "Task Response Time" }, colHeaderRow = { "Task Completion Time" };


                for (int i = 0; i <= r.Cells.Count - 1; i++)
                {
                    string IsHeader = r.Cells[3].Text.Trim();

                    if (IsHeader == "YES")
                    {
                        r.Cells[i].Height = 50; r.Cells[i].VerticalAlign = VerticalAlign.Middle;
                        r.Cells[i].CssClass = "Header";
                    }
                    else
                    {
                        if (i != 0)
                            r.Cells[i].CssClass = "Ntext";
                        else
                            r.Cells[i].CssClass = "text";
                    }


                    if (IsHeader == "EMPTY" || i == 3)
                    {
                        r.Cells[i].BorderColor = System.Drawing.Color.White;
                        r.Cells[i].Text = "";
                    }

                }
            }
            //TmpGrid.Columns.RemoveAt(3);
            TmpGrid.RenderControl(htmlWrite);


            stringWrite.Write(" <br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'>  </h3> <br/>");
            stringWrite.Write(" <br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'>  </h3> <br/>");

            String FinalContent = style + stringWrite.ToString();
            row = TblMax.NewRow(); row["Result"] = FinalContent.ToString(); TblMax.Rows.Add(row);
        }
        DataSet.Tables.Add(TblMax);
        return DataSet;

    }

    private DataTable GetTableMax()
    {
        DataColumn column;
        DataRow row;
        var table = new DataTable() { TableName = "TBLMax" };
        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "Result";
        table.Columns.Add(column);



        return table;
    }
    /* Report End */
}