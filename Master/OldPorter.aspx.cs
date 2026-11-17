using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Telerik.Web.UI;
using System.Data;
using ClientsideEncryption;

public partial class Master_OldPorter : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void Export_Porter(object sender, EventArgs e)
    {
        string Header = AESEncrytDecry.DecryptStringAES(HFDWExportHeader.Value.ToString()),
             SearchQuery = AESEncrytDecry.DecryptStringAES(HFDWSearchQuery.Value.ToString());

        DataSet DataSet = new DataSet();
        DataTable ds = DataAccess.GetRecords("SP_GETPORTERS_EXPORT", "@SEARCH", SearchQuery);
        if (ds.Rows.Count > 0)
        {
            GridView TmpGrid = new GridView();
            TmpGrid.DataSource = ds;
            TmpGrid.DataBind();
            string style = "<style> .text { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold;font-size: 0.7em;color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;}      .Header  { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold !important;font-size: 1em !important;background-color: #174982 !important;color: white !important;font-family: Arial !important, sans-serif;text-transform: uppercase;text-decoration: none;min-width:100px !important;max-width:200px !important;} </script> ";
            TmpGrid.GridLines = GridLines.Both;
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Porters.xls");
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