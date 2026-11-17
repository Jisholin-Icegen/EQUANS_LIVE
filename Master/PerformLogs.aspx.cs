using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using ClientsideEncryption;

using Telerik.Web.UI;

public partial class Master_PerformLogs : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
            BindData();
    }

    private void BindData()
    {
        DateTime date = DateTime.Now; DateTime stDate = new DateTime(date.Year, date.Month, 1);
        string CurDate = date.ToString("yyyy-MM-dd").ToString();//stDate.ToString("yyyy-MM-dd").ToString(); // + "T00:00"
        string endDate = date.ToString("yyyy-MM-dd").ToString();// stDate.AddMonths(1).AddSeconds(-1).ToString("yyyy-MM-dd").ToString();
        HFFrom.Value = CurDate;//DateTime.Today.ToString("dd/MM/yyyy");
        HFTo.Value = endDate;

        GridPerformLogs.DataSource = new DataTable();
        GridPerformLogs.DataBind();
    }

    protected void Export_Logs(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(HFFrom.Value) || string.IsNullOrEmpty(HFTo.Value)) return;
        else
        {
            string frmValue = HFFrom.Value.ToString() + "T00:00", toValue = HFTo.Value.ToString() + "T23:59";
            string[] from = frmValue.Split('T'), to = toValue.Split('T');
            string[] sf = from[0].Split('-'), st = to[0].Split('-');
            string Status = RStatus.Value,
                 From = (sf[1] + "/" + sf[2] + "/" + sf[0] + " " + from[1]).ToString(),
                 To = (st[1] + "/" + st[2] + "/" + st[0] + " " + to[1]).ToString();

            string Header = AESEncrytDecry.DecryptStringAES(HFDWExportHeader.Value.ToString()),
                SearchQuery = AESEncrytDecry.DecryptStringAES(HFDWSearchQuery.Value.ToString()),
                ReqID = AESEncrytDecry.DecryptStringAES(HFReqID.Value.ToString());

            DataTable ds = DataAccess.PerformLogs_Export("SP_GETPERFORMRESPONSES_EXPORT", SearchQuery, ReqID, Status, From, To);
            if (ds.Rows.Count > 0)
            {
                GridView TmpGrid = new GridView();
                TmpGrid.DataSource = ds;
                TmpGrid.DataBind();
                string style = "<style> .text { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold;font-size: 0.7em;color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;}      .Header  { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold !important;font-size: 1em !important;background-color: #174982 !important;color: white !important;font-family: Arial !important, sans-serif;text-transform: uppercase;text-decoration: none;min-width:100px !important;max-width:200px !important;} </script> ";
                TmpGrid.GridLines = GridLines.Both;
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=P3RFORM_LOGS(" + HFFrom.Value + "_TO_" + HFTo.Value + ").xls");
                Response.Charset = "";
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);

                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;width:700px !important;'> " + Header + " </h3> <br/>");

                for (int i = 0; i <= TmpGrid.HeaderRow.Cells.Count - 1; i++)
                    TmpGrid.HeaderRow.Cells[i].CssClass = "Header";

                int cont = TmpGrid.Columns.Count;

                TmpGrid.RenderControl(htmlWrite);

                Response.Write(style);
                Response.Write(stringWrite.ToString());
                Response.End();
                TmpGrid.GridLines = GridLines.None;
            }
            else
            {
                //Bind(Status, From, To);
                string CloseWindow = "alert('No Records Found !');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", CloseWindow, true);
            }
        }
    }

}