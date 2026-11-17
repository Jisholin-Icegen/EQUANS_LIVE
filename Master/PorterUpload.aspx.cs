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
//using Excel = Microsoft.Office.Interop.Excel;
//using Microsoft.Office.Interop.Excel;
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
        //if (Session["NAME"] == null)
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", "window.close();window.opener.location.reload(true);", true);
        //    return;
        //}
        try
        {
            DataSet ds = new DataSet(), ds1 = new DataSet(); int cnt = 0;
            ds = DataAccess.getRecords("SP_GETPORTERRECORDS");
            string path = Server.MapPath("~/TEMPLATES/PorterList.xls"), NewPath = Server.MapPath("~/UploadFiles/PorterList.xls"), fileName = "..\\UploadFiles\\PorterList.xls";
            if (File.Exists(NewPath))
                File.Delete(NewPath);
            File.Copy(path, NewPath);
            OleDbConnection MyConnection = new OleDbConnection(constr.Replace("filePath", NewPath));
            string ICommand = string.Empty;
            OleDbDataAdapter oadpt;
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                ICommand = "INSERT INTO [Sheet1$]([PORTER ID],[PORTER NAME],[SHIFT]) VALUES('" + dr["ID"] + "','" + dr["PORTERNAME"] + "','" + dr["SHIFTNAME"] + "')";
                oadpt = new OleDbDataAdapter(ICommand, MyConnection);
                oadpt.Fill(ds1);
            }
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=PorterList.xls");
            Response.Charset = "";
            Response.ContentType = "application/vnd.xls";
            Response.WriteFile(fileName);
            Response.End();
        }
        catch (Exception ex1)
        {
            Errorlb.Text = ex1.Message;
        }
    }

    /* private void DeleteExistRows(string path, int Limit)
     {
         string Start = "A2", End = "A" + Limit;
         Excel.Application excelApp = new Excel.Application();
         Excel.Workbook excelWorkbook = excelApp.Workbooks.Open(path, 1, false, 5, "", "", false, Excel.XlPlatform.xlWindows, "", true, false, null, false);
         try
         {
             Excel.Sheets excelWorkSheet = excelWorkbook.Sheets;
             Worksheet work = (Worksheet)excelApp.Worksheets[1];
             Excel.Range range = work.get_Range(Start, End);
             Excel.Range entireRow = range.EntireRow;
             entireRow.Delete(Excel.XlDirection.xlUp);
         }
         catch (Exception ex)
         {
         }
         finally
         {
             excelApp.DisplayAlerts = false;
             excelWorkbook.Save();
             excelWorkbook.Close();
             excelApp.DisplayAlerts = true;
             excelApp.Quit();
         }
     }*/

    private GridView LoadGrid(System.Data.DataTable dataTable, GridView Grid)
    {
        DataColumn column = new DataColumn();
        BoundField ID = new BoundField() { DataField = "ID", HeaderText = "PORTER ID" },
                   NAME = new BoundField() { DataField = "PORTERNAME", HeaderText = "PORTER NAME" },
                   SHIFTNAME = new BoundField() { DataField = "SHIFTNAME", HeaderText = "SHIFT" };
        ID.HeaderStyle.Width = Unit.Pixel(150); ID.ItemStyle.HorizontalAlign = HorizontalAlign.Center; NAME.HeaderStyle.Width = Unit.Pixel(300); NAME.ItemStyle.HorizontalAlign = HorizontalAlign.Center; SHIFTNAME.HeaderStyle.Width = Unit.Pixel(300); SHIFTNAME.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
        Grid.Columns.Add(ID); Grid.Columns.Add(NAME); Grid.Columns.Add(SHIFTNAME);
        Grid.DataSource = dataTable;
        Grid.DataBind();
        return Grid;
    }
    protected void UpldBtn_Click(object sender, EventArgs e)
    {
        //NEW
        //if (Session["NAME"] == null)
        //{
        //    ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", "window.close();window.opener.location.reload(false);", true);
        //    return;
        //}
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

                if (ds.Tables[0].Rows.Count <= 1)
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
                    string PId = (ds.Tables[0].Rows[j]["PORTER ID"].ToString().Trim().Length > 0) ? ds.Tables[0].Rows[j]["PORTER ID"].ToString().ToUpper().Trim() : string.Empty,
                        Name = (ds.Tables[0].Rows[j]["PORTER NAME"].ToString().Trim().Length > 0) ? ds.Tables[0].Rows[j]["PORTER NAME"].ToString().ToUpper().Trim() : string.Empty,
                        Shift = ds.Tables[0].Rows[j]["SHIFT"].ToString().ToUpper().Trim();
                    try
                    {
                        bool Result = false;
                        if (Shift != string.Empty)
                            Result = ((DataAccess.PorterMaster(null,PId, Name, string.Empty, Shift, true, "SHIFTUPDATE").Rows[0]["RESULT"].ToString()) == "TRUE");
                        if (!Result || Shift == string.Empty)
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