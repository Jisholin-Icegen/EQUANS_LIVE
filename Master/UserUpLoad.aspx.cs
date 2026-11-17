using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.IO;
using System.Xml;
using System.Xml.Xsl;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;

public partial class Master_PorterUpload : System.Web.UI.Page
{
    private static string constr = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source='filePath'; " + "Extended Properties=\"Excel 12.0;;HDR=YES;\"";
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void TmplBtn_Click(object sender, EventArgs e)
    {
        try
        {
            string filename = "..\\TEMPLATES\\UserList.xls";
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=UserList.xls");
            Response.Charset = "";
            Response.ContentType = "application/vnd.xls";
            Response.WriteFile(filename);
            Response.End();
        }
        catch (Exception ex1)
        {
            Errorlb.Text = ex1.Message;
        }
    }

    protected void UpldBtn_Click(object sender, EventArgs e)
    {
        string filename = null;
        if (FileUpload1.HasFile)
        {
            OleDbConnection con = null;
            OleDbDataAdapter da;

            filename = Path.GetFileName(FileUpload1.FileName);
            try
            {
                string Line = string.Empty, CloseWindow = string.Empty;
                Errorlb.Text = string.Empty;
                filename = DateTime.Now.Year + "" + DateTime.Now.Month + "" + DateTime.Now.Day + filename;
                FileUpload1.SaveAs(Server.MapPath("~/UploadFiles/") + filename);
                string filePath = Server.MapPath("~/UploadFiles/" + filename);

                DataSet ds = new DataSet();
                con = new OleDbConnection(constr.Replace("filePath", filePath));
                da = new OleDbDataAdapter("select * from [Sheet1$]", con);
                da.Fill(ds);

                if (ds.Tables[0].Rows.Count < 1)
                {
                    Errorlb.Text = Line;
                    CloseWindow = "alert('No records available in the Excel File !');";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", CloseWindow, true);
                    return;
                }

                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                Int64 rowcount = ds.Tables[0].Rows.Count;
                for (int j = 0; j < rowcount; j++)
                {
                    string EId = (ds.Tables[0].Rows[j]["EMP ID"].ToString().Trim().Length > 0) ? ds.Tables[0].Rows[j]["EMP ID"].ToString().ToUpper().Trim() : string.Empty,
                           EName = (ds.Tables[0].Rows[j]["EMP NAME"].ToString().Trim().Length > 0) ? ds.Tables[0].Rows[j]["EMP NAME"].ToString().ToUpper().Trim() : string.Empty;
                    try
                    {
                        bool Result = false;
                        if (EId != string.Empty && EName != string.Empty)
                            Result = ((DataAccess.UserMaster(string.Empty, EName, EId, string.Empty, "4", true, "INSERT").Rows[0]["RESULT"].ToString()) == "TRUE");
                        if (!Result || EName == string.Empty || EId == string.Empty)
                            Line = SetLine(Line, j);
                    }
                    catch (Exception EX)
                    {
                    }
                }
                if (Line.Length > 0)
                {
                    Errorlb.Text = "Please check the line no : " + Line.ToString() + "";
                    CloseWindow = "window.opener.location = window.opener.location;";
                }
                else
                    CloseWindow = "alert('Record Saved Successfully.');window.opener.location = window.opener.location;";//window.opener.location.reload(true);";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", CloseWindow, true);
            }


            catch (Exception ex1) { Errorlb.Text = ex1.Message; }
            try
            {
                File.Delete(Server.MapPath("~/UPLOADFILES/" + filename));
            }
            catch (Exception)
            { }

        }

        else
        {
            string CloseWindow = "alert('Please Select a Excel File !');";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", CloseWindow, true);
        }
    }

    private string SetLine(string Line, int j)
    {
        if (string.IsNullOrEmpty(Line))
            Line += " '" + (j + 2) + "' ";
        else
            Line += " , '" + (j + 2) + "' ";
        return Line;
    }
}