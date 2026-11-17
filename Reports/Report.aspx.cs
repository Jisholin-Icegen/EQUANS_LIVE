using ClientsideEncryption;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Telerik.Web.UI;

public partial class Planner_Planner : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            SetDefault();
    }

    private void SetDefault()
    {
        DateTime date = DateTime.Now; DateTime stDate = new DateTime(date.Year, date.Month, 1);
        string CurDate = date.ToString("yyyy-MM-dd").ToString();//stDate.ToString("yyyy-MM-dd").ToString(); // + "T00:00"
        string endDate = date.ToString("yyyy-MM-dd").ToString();// stDate.AddMonths(1).AddSeconds(-1).ToString("yyyy-MM-dd").ToString();
        HFFrom.Value = CurDate;//DateTime.Today.ToString("dd/MM/yyyy");
        HFTo.Value = endDate;// DateTime.Today.ToString("dd/MM/yyyy");

        GridPorter.DataSource = new DataTable();
        GridReport.DataSource = new DataTable();
        GridReports.DataSource = new DataTable();

    }


    protected void Export_Datewise(object sender, EventArgs e)
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
             ServiceCode = HFServiceCode.Value.ToString();

            DataSet DataSet = new DataSet();
            DataTable ds = DataAccess.DateWiseExport(Status, From, To, SearchQuery, ServiceCode);
            if (ds.Rows.Count > 0)
            {
                GridView TmpGrid = new GridView();
                TmpGrid.DataSource = ds;
                TmpGrid.DataBind();
                string style = "<style> .text { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold;font-size: 0.7em;color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;}      .Header  { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold !important;font-size: 1em !important;background-color: #174982 !important;color: white !important;font-family: Arial !important, sans-serif;text-transform: uppercase;text-decoration: none;min-width:100px !important;max-width:200px !important;} </script> ";
                TmpGrid.GridLines = GridLines.Both;
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename=" + ((Status == "0") ? "RAISED" : (Status == "6") ? "COMPLETED" : "CANCELLED") + "REQUESTS" + ((ServiceCode == "1") ? "_PORTERING" : ((ServiceCode == "2") ? "_CATERING" : "_PORTERING")) + "(" + HFFrom.Value + "_TO_" + HFTo.Value + ").xls");
                Response.Charset = "";
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);

                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;width:700px !important;'> " + Header + " </h3> <br/>");

                for (int i = 0; i <= TmpGrid.HeaderRow.Cells.Count - 1; i++)
                    TmpGrid.HeaderRow.Cells[i].CssClass = "Header";
                foreach (GridViewRow r in TmpGrid.Rows)
                {
                    for (int i = 0; i <= r.Cells.Count - 1; i++)
                    {
                        // r.Cells[i].CssClass = "text";
                        if (Status != "7")
                        {
                            int index = (Status == "6") ? (r.Cells.Count - 1) : (r.Cells.Count - 2), Tindex = 19, Tindex1 = 20;
                            //if (r.Cells[index].Text.Replace("&nbsp;", "").Trim().Length > 0)
                            //    r.Cells[i].Attributes.Add("style", "background:#ffcccc !important;");
                            if (((r.Cells[Tindex].Text.Replace("&nbsp;", "").Trim().Length > 0) && (r.Cells[Tindex].Text.Replace("&nbsp;", "").Trim() == "NO")) || ((r.Cells[Tindex1].Text.Replace("&nbsp;", "").Trim().Length > 0) && (r.Cells[Tindex1].Text.Replace("&nbsp;", "").Trim() == "NO")))
                                r.Cells[i].Attributes.Add("style", "background:rgb(217,151,149) !important;color:white;");
                        }
                    }
                }
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
    protected void ExportTrack_Datewise(object sender, EventArgs e)
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
             ServiceCode = HFServiceCode.Value.ToString();

            DataSet DataSet = new DataSet();
            DataTable ds = DataAccess.ExportTrac(Status, From, To, SearchQuery, ServiceCode);
            if (ds.Rows.Count > 0)
            {
                GridView TmpGrid = new GridView();
                TmpGrid.DataSource = ds;
                TmpGrid.DataBind();
                string style = "<style> .text { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold;font-size: 0.7em;color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;}      .Header  { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold !important;font-size: 1em !important;background-color: #174982 !important;color: white !important;font-family: Arial !important, sans-serif;text-transform: uppercase;text-decoration: none;min-width:100px !important;max-width:200px !important;} </script> ";
                TmpGrid.GridLines = GridLines.Both;
                Response.Clear();
                Response.AddHeader("content-disposition", "attachment;filename="  + "PORTERTRAC" + ((ServiceCode == "1") ? "_PORTERING" : ((ServiceCode == "3") ? "_RandD" : "_PORTERING")) + "(" + HFFrom.Value + "_TO_" + HFTo.Value + ").xls");
                Response.Charset = "";
                Response.ContentType = "application/vnd.xls";
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);

             //   stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;width:700px !important;'> " + Header + " </h3> <br/>");

                for (int i = 0; i <= TmpGrid.HeaderRow.Cells.Count - 1; i++)
                    TmpGrid.HeaderRow.Cells[i].CssClass = "Header";
                foreach (GridViewRow r in TmpGrid.Rows)
                {
                    for (int i = 0; i <= r.Cells.Count - 1; i++)
                    {
                        // r.Cells[i].CssClass = "text";
                        if (Status != "7")
                        {
                            int index = (Status == "6") ? (r.Cells.Count - 1) : (r.Cells.Count - 2), Tindex = 19, Tindex1 = 20;
                            //if (r.Cells[index].Text.Replace("&nbsp;", "").Trim().Length > 0)
                            //    r.Cells[i].Attributes.Add("style", "background:#ffcccc !important;");
                            if (((r.Cells[Tindex].Text.Replace("&nbsp;", "").Trim().Length > 0) && (r.Cells[Tindex].Text.Replace("&nbsp;", "").Trim() == "NO")) || ((r.Cells[Tindex1].Text.Replace("&nbsp;", "").Trim().Length > 0) && (r.Cells[Tindex1].Text.Replace("&nbsp;", "").Trim() == "NO")))
                                r.Cells[i].Attributes.Add("style", "background:rgb(217,151,149) !important;color:white;");
                        }
                    }
                }
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