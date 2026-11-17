using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
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
using System.IO;
using Telerik.Web.UI;
//using Microsoft.Office.Interop.Excel;
//using Excel = Microsoft.Office.Interop.Excel;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Collections.Generic;
public partial class Admin_Bulk : System.Web.UI.Page
{
    private static string constr = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source='filePath'; " + "Extended Properties=\"Excel 12.0;;HDR=YES;\"";
    List<Dictionary<string, string>> rows;
    Dictionary<string, string> row;
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnBreakTmp_Click(object sender, EventArgs e)
    {
        try
        {
            string filename = "..\\Templates\\Break.xls";
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Break.xls");
            Response.Charset = "";
            Response.ContentType = "application/vnd.xls";
            Response.WriteFile(filename);
            Response.End();
        }
        catch (Exception ex1) { Session["Errors"] = ex1.Message.Replace("'", "") + "900001"; }
    }
    protected void btnBreakSubmit_Click(object sender, EventArgs e)
    {

        OleDbConnection con = null;
        OleDbDataAdapter da = new OleDbDataAdapter();
        OleDbCommand cmd = new OleDbCommand();
        string rowsNum = string.Empty, strlog = string.Empty;
        bool fnlSts = true;
        string ServiceID = HFServiceCode.Value.ToString();
        if (RadUploadBreak.UploadedFiles.Count == 1)
        {
            try
            {
                string filename = DateTime.Now.Year + "" + DateTime.Now.Month + "" + DateTime.Now.Day;
                foreach (UploadedFile f in RadUploadBreak.UploadedFiles)
                {
                    filename = f.GetName();
                    f.SaveAs(Server.MapPath("~/S3/") + filename, true);
                }
                string filePath = Server.MapPath("~/S3/" + filename);
                DataSet ds = new DataSet();
                string constr = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source='" + filePath + " '; " + "Extended Properties=\"Excel 12.0;HDR=YES;\"";
                con = new OleDbConnection(constr);
                con.Open();
                cmd = new OleDbCommand("select * from [Sheet1$]", con);
                da.SelectCommand = cmd;
                da.Fill(ds);
                con.Close();
                if (ds.Tables[0].Rows.Count < 1)
                {
                    string CloseWindow = "alert('No records available in the Excel File !');";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", CloseWindow, true);
                    return;
                }
                string errors = "";
                string colNames = string.Empty;
                string[] IDColumns = { "STATUSID" },
                    MaxCols = { "STARTTIME(HH:MM(24HOURS))", "PORTERID", "DURATION(MINUTES)" },
                    MandCols = { "STARTTIME(HH:MM(24HOURS))", "PORTERID", "DURATION(MINUTES)" };

                Hashtable htCols = new Hashtable();//get value using key

                htCols.Add("STARTTIME(HH:MM(24HOURS))", "STARTTIME");
                htCols.Add("PORTERID", "PORTERID");
                htCols.Add("DURATION(MINUTES)", "DURATION");

                for (int k = 0; k < ds.Tables[0].Columns.Count; k++)
                {
                    string colName = ds.Tables[0].Columns[k].ColumnName.ToUpper().Replace(" ", "");
                    if (!htCols.ContainsKey(colName))
                        colNames += colName + ",";
                    else
                        colNames += htCols[colName].ToString().ToUpper() + ",";
                }
                colNames = colNames.TrimEnd(',');
                {

                    int colCnt = ds.Tables[0].Columns.Count; string val = string.Empty, strVal = string.Empty, primaryId = string.Empty, updatedBankId = "1"// Session["LoginUser"].ToString()          
                        , filQry = string.Empty;
                    string checkExistVar1 = string.Empty, checkExistVar2 = string.Empty, ColumnName = string.Empty, Process = string.Empty, ErrorColumn = string.Empty;
                    bool result = false, valEachrow = true, subvalEachrow = true, valid = false; DataRow ExcelRow;
                    DataSet dsSts = DataAccess.GetGlobalAllRecords("GetGlobalDefaultValues", "BREAK", "BREAK"); rows = new List<Dictionary<string, string>>(); List<string> TmpValue = new List<string>();
                    DataRow[] dtls = null;

                    for (int i = 0; i <= ds.Tables[0].Rows.Count - 1; i++)
                    {
                        try
                        {
                            result = false; val = ""; valEachrow = true; subvalEachrow = true; checkExistVar1 = string.Empty; valid = false; ErrorColumn = string.Empty; Process = string.Empty; checkExistVar2 = string.Empty; ColumnName = string.Empty; ExcelRow = ds.Tables[0].Rows[i]; row = new Dictionary<string, string>();
                            primaryId = GetReqColumnValue(ExcelRow, "REQUESTID"); primaryId = (string.IsNullOrEmpty(primaryId) || primaryId == "FALSE") ? string.Empty : primaryId; Process = (string.IsNullOrEmpty(primaryId) ? "INSERT" : "UPDATE");
                            DataRow UserRecords = (!string.IsNullOrEmpty(primaryId)) ? DataAccess.ExecuteQuery(primaryId, "UserDetails") : null; valid = true;

                            if (valid)
                            {
                                for (int c = 0; c < colCnt; c++)
                                {
                                    strVal = ExcelRow[c].ToString().Replace("'", "").Trim().ToUpper(); ColumnName = colNames.Split(',')[c].ToUpper();
                                    if (((Process != "INSERT") && (!UserRecords.Table.Columns.Contains(ColumnName))) || (!subvalEachrow))
                                        continue;
                                    else if (string.IsNullOrEmpty(strVal.Trim()) || (strVal.Trim().ToUpper() == "<CLEAR>")) //(((Process == "INSERT") && (string.IsNullOrEmpty(strVal.Trim()) && (!MandCols.Contains(ColumnName)))) || ((Process == "UPDATE") && ((strVal.Trim().ToUpper() == "<CLEAR>") || ((UserRecords[ColumnName] == DBNull.Value || string.IsNullOrEmpty(UserRecords[ColumnName].ToString())) && string.IsNullOrEmpty(strVal.Trim())))))
                                    {
                                        val += (Process == "INSERT") ? ("null,") : "" + ColumnName + "=" + "null,";
                                        subvalEachrow = true;
                                    }
                                    else if ((Process != "INSERT") && (string.IsNullOrEmpty(strVal.Trim()) && (UserRecords[ColumnName] != DBNull.Value && !string.IsNullOrEmpty(UserRecords[ColumnName].ToString()))))
                                        subvalEachrow = (subvalEachrow) ? !subvalEachrow : subvalEachrow;
                                    else
                                    {
                                        switch (ColumnName)
                                        {
                                            case "PORTERID":

                                                strVal = GetStatusValue(dsSts, "USER", strVal);

                                                if (!string.IsNullOrEmpty(strVal))
                                                    val += ((Process == "INSERT") ? ("'" + strVal + "',") : ("" + ColumnName + "=" + "'" + strVal + "',"));
                                                else
                                                    subvalEachrow = false;
                                                break;


                                            case "DURATION":
                                                if (IsNumber(strVal))
                                                {
                                                    val += ((Process == "INSERT") ? ("'" + strVal + "',") : ("" + ColumnName + "='" + strVal + "',"));
                                                    subvalEachrow = true;
                                                }
                                                else
                                                    subvalEachrow = false;
                                                break;
                                            case "STARTTIME":


                                                string Date = GetDate("01/01/2024 " + strVal); valEachrow = ((!string.IsNullOrEmpty(Date)) && IsValidDate(Date));

                                                if (valEachrow)
                                                {
                                                    val += ((Process == "INSERT") ? ("CONVERT(NVARCHAR(MAX),(CONVERT(NVARCHAR(15),GETDATE(),101)+' '+CONVERT(NVARCHAR(5),'" + strVal + "')  )),") : ("" + ColumnName + "='" + strVal + "',"));
                                                    subvalEachrow = true;
                                                }
                                                else
                                                    subvalEachrow = false;
                                                break;
                                            default:
                                                val += ((Process == "INSERT") ? ("'" + strVal + "',") : ("" + ColumnName + "='" + strVal + "',"));
                                                break;
                                        }
                                    }
                                    if (!subvalEachrow)
                                    {
                                        ErrorColumn += " " + GetColumnName(ExcelRow, ColumnName, c) + " ";
                                    }
                                }
                                val = val.TrimEnd(',');
                                if (subvalEachrow)
                                {
                                    if (rowsNum.Length > 0)
                                        rows = new List<Dictionary<string, string>>();
                                    else
                                    {
                                        string Query = (Process == "INSERT") ? " insert into BREAKSCHEDULE (" + colNames + ",CreatedBy) values (" + val + ", '" + HFUserID.Value.Trim() + "')" : "update Requestmasterr set " + val + ",CreatedBy='" + updatedBankId + "' where RequestId= '" + GetReqColumnValue(ExcelRow, "REQUESTID") + "'", Parameter = string.Empty;
                                        row.Add(Query, Parameter); rows.Add(row);
                                    }
                                    result = subvalEachrow;
                                }
                                else
                                    result = false;

                            }
                            else
                                ErrorColumn = " - " + GetErrorColumn(MandCols, primaryId, ExcelRow, MaxCols) + " ";

                            if (!result)
                            {
                                rowsNum += " LINE : " + (i + 2).ToString() + ErrorColumn + ",";
                                continue;
                            }


                        }
                        catch (Exception ex)
                        {
                            string CloseWindow = "alert('" + ex.Message.Replace("'", "") + "');";
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", CloseWindow, true);
                        }
                        finally
                        {
                            if (File.Exists(Server.MapPath("~/S3/" + filename)))
                                File.Delete(Server.MapPath("~/S3/" + filename));
                        }
                    }
                    if (fnlSts == false)
                    {
                        rowsNum = "KINDLY CHECK THE DATA IN " + rowsNum.TrimEnd(',');
                        string CloseWindow = "alert('" + rowsNum + "');";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", CloseWindow, true);
                    }
                    else
                    {
                        string dbRtn = DoMasterProcess(rows);
                        string CloseWindow = string.Empty;

                        if (dbRtn == "")
                            CloseWindow = "alert('Record uploaded successfully. ');";
                        else
                            CloseWindow = "alert('KINDLY CHECK THE DATA IN(" + dbRtn + ")');";

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", CloseWindow, true);
                    }
                }


            }
            catch (Exception ex1)
            {
                DataAccess.InsertError(ex1.Message.Replace("'", ""), "logerror");

                string CloseWindow = "alert('KINDLY CHECK THE DATA ENTERED');";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", CloseWindow, true);
            }


        }


    }

    protected void btnTaskTmp_Click(object sender, EventArgs e)
    {
        try
        {

            string ServiceID = HFServiceCode.Value.ToString(), fName = ((ServiceID == "1") ? "Tasks_Portering" : "Tasks_Receipt and Distribution");
            string filename = "..\\Templates\\" + fName + ".xlsx";
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=" + fName + ".xlsx");
            Response.Charset = "";
            Response.ContentType = "application/vnd.xls";
            Response.WriteFile(filename);
            Response.End();
        }
        catch (Exception ex1) { Session["Errors"] = ex1.Message.Replace("'", "") + "900001"; }
    }
    private bool datevalidate(string req, string assigned, string start, string end, string colname)
    {
        bool result = false; int dd, mm, yy, hh, m;
        string time = string.Empty, date = string.Empty;

        try
        {

            time = req.Split(' ')[1]; date = req.Split(' ')[0];

            yy = Convert.ToInt32(date.Split('/')[2]);
            mm = Convert.ToInt32(date.Split('/')[1]);
            dd = Convert.ToInt32(date.Split('/')[0]);
            hh = Convert.ToInt32(time.Split(':')[0]);
            m = Convert.ToInt32(time.Split(':')[1]);


            DateTime reqt = new DateTime(yy, mm, dd, hh, m, 0);
            DateTime asst = DateTime.Now;
            if (colname == "ASSIGNEDTIME" || colname == "STARTTIME" || colname == "ENDTIME")
            {
                time = assigned.Split(' ')[1]; date = assigned.Split(' ')[0];

                yy = Convert.ToInt32(date.Split('/')[2]);
                mm = Convert.ToInt32(date.Split('/')[1]);
                dd = Convert.ToInt32(date.Split('/')[0]);
                hh = Convert.ToInt32(time.Split(':')[0]);
                m = Convert.ToInt32(time.Split(':')[1]);
                asst = new DateTime(yy, mm, dd, hh, m, 0);
            }

            DateTime startt = DateTime.Now;
            if (colname == "STARTTIME" || colname == "ENDTIME")
            {
                time = start.Split(' ')[1]; date = start.Split(' ')[0];

                yy = Convert.ToInt32(date.Split('/')[2]);
                mm = Convert.ToInt32(date.Split('/')[1]);
                dd = Convert.ToInt32(date.Split('/')[0]);
                hh = Convert.ToInt32(time.Split(':')[0]);
                m = Convert.ToInt32(time.Split(':')[1]);
                startt = new DateTime(yy, mm, dd, hh, m, 0);
            }

            DateTime comt = DateTime.Now;
            if (colname == "ENDTIME")
            {
                time = end.Split(' ')[1]; date = end.Split(' ')[0];
                yy = Convert.ToInt32(date.Split('/')[2]);
                mm = Convert.ToInt32(date.Split('/')[1]);
                dd = Convert.ToInt32(date.Split('/')[0]);
                hh = Convert.ToInt32(time.Split(':')[0]);
                m = Convert.ToInt32(time.Split(':')[1]);
                comt = new DateTime(yy, mm, dd, hh, m, 0);
            }
            if (colname == "ASSIGNEDTIME")
                result = reqt <= asst ? true : false;
            else if (colname == "STARTTIME")
                result = reqt <= asst && asst <= startt ? true : false;
            else if (colname == "ENDTIME")
                result = reqt <= asst && asst <= startt && startt <= comt ? true : false;



            return result;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    protected void btnTaskSubmit_Click(object sender, EventArgs e)
    {
        OleDbConnection con = null;
        OleDbDataAdapter da = new OleDbDataAdapter();
        OleDbCommand cmd = new OleDbCommand();
        string rowsNum = string.Empty;
        string strlog = string.Empty;

        string ServiceID = HFServiceCode.Value.ToString();
        bool fnlSts = true;

        if (RadUploadTask.UploadedFiles.Count == 1)
        {
            string filename = string.Empty;

            try
            {
                foreach (UploadedFile f in RadUploadTask.UploadedFiles)
                {
                    filename = f.GetName();
                    string savePath = Server.MapPath("~/S3/") + filename;
                    f.SaveAs(savePath, true);
                }

                string filePath = Server.MapPath("~/S3/" + filename);

                DataSet ds = new DataSet();
                string constr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties=\"Excel 12.0;HDR=YES;\"";
                con = new OleDbConnection(constr);
                con.Open();

                cmd = new OleDbCommand("SELECT * FROM [Sheet1$]", con);
                da.SelectCommand = cmd;
                da.Fill(ds);

                con.Close();

                if (ds.Tables[0].Rows.Count < 1)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", "alert('No records available in the Excel File!');", true);
                    return;
                }

                string[] IDColumns = { "STATUSID" };
                string[] MaxCols = { "REQUESTDATE(DD/MM/YYYYHH:MM(24HOURS))", "ASSIGNEDTIME(DD/MM/YYYYHH:MM(24HOURS))", "STARTTIME(DD/MM/YYYYHH:MM(24HOURS))", "ENDTIME(DD/MM/YYYYHH:MM(24HOURS))", "PORTER", "ASSISTANT", "FROM", "TO", "TASK TYPE", "EQUIPMENT TYPE", "REMARKS", "REQUESTOR", "REQUESTOR NAME", "PATIENT NAME" };
                string[] MandCols = { "REQUESTDATE(DD/MM/YYYYHH:MM(24HOURS))", "ASSIGNEDTIME(DD/MM/YYYYHH:MM(24HOURS))", "STARTTIME(DD/MM/YYYYHH:MM(24HOURS))", "ENDTIME(DD/MM/YYYYHH:MM(24HOURS))", "FROM", "TO", "TASK TYPE", "REQUESTORNAME" };
                string[] MandColsCater = { "REQUESTDATE(DD/MM/YYYYHH:MM(24HOURS))", "ASSIGNEDTIME(DD/MM/YYYYHH:MM(24HOURS))", "STARTTIME(DD/MM/YYYYHH:MM(24HOURS))", "ENDTIME(DD/MM/YYYYHH:MM(24HOURS))", "TO", "TASK TYPE", "REQUESTORNAME" };

                Hashtable htCols = new Hashtable
            {
                { "REQUESTDATE(DD/MM/YYYYHH:MM(24HOURS))", "REQUESTDATE" },
                { "ASSIGNEDTIME(DD/MM/YYYYHH:MM(24HOURS))", "ASSIGNEDTIME" },
                { "STARTTIME(DD/MM/YYYYHH:MM(24HOURS))", "STARTTIME" },
                { "ENDTIME(DD/MM/YYYYHH:MM(24HOURS))", "ENDTIME" },
                { "STATUS", "STATUSID" },
                { "TASKTYPE", "CATEGORYID" },
                { "EQUIPMENTTYPE", "EQUIPMENTTYPE" },
                { "FROM", "RequestLocationId" },
                { "TO", "DestinationLocationId" },
                { "PORTER", "PORTERID" },
                { "ASSISTANT", "SUBPORTERID" },
                { "REQUESTOR NAME", "REQUESTORNAME" },
                { "REMARKS", "REQUESTDESKREMARKS" },
                { "QUANTITY", "QUANTITY" },
                { "PATIENT NAME", "PATIENTNAME" }
            };

                string colNames = string.Empty;
                for (int k = 0; k < ds.Tables[0].Columns.Count; k++)
                {
                    string colName = ds.Tables[0].Columns[k].ColumnName.ToUpper().Replace(" ", "");
                    if (!htCols.ContainsKey(colName))
                        colNames += colName + ",";
                    else
                        colNames += htCols[colName].ToString().ToUpper() + ",";
                }
                colNames = colNames.TrimEnd(',');

                int colCnt = ds.Tables[0].Columns.Count;
                List<Dictionary<string, string>> rows = new List<Dictionary<string, string>>();
                string updatedBankId = "1"; 

                DataSet dsSts = DataAccess.GetGlobalAllRecords("GetGlobalDefaultValues", "REQUEST", "REQUEST");

                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    bool subvalEachrow = true;
                    bool result = false;
                    string val = string.Empty;
                    string primaryId = string.Empty;
                    Dictionary<string, string> row = new Dictionary<string, string>();

                    try
                    {
                        DataRow ExcelRow = ds.Tables[0].Rows[i];
                        primaryId = GetReqColumnValue(ExcelRow, "REQUESTID");
                        primaryId = (string.IsNullOrEmpty(primaryId) || primaryId.ToUpper() == "FALSE") ? string.Empty : primaryId;
                        string Process = string.IsNullOrEmpty(primaryId) ? "INSERT" : "UPDATE";

                        DataRow UserRecords = !string.IsNullOrEmpty(primaryId) ? DataAccess.ExecuteQuery(primaryId, "UserDetails") : null;

                        for (int c = 0; c < colCnt; c++)
                        {
                            string rawValue = ExcelRow[c].ToString().Replace("'", "").Trim();
                            string strVal = rawValue.ToUpper();
                            string ColumnName = colNames.Split(',')[c].ToUpper();

                            if ((Process != "INSERT" && (UserRecords == null || !UserRecords.Table.Columns.Contains(ColumnName))) || !subvalEachrow)
                            {
                                continue;
                            }
                            else if (string.IsNullOrEmpty(strVal) || strVal == "<CLEAR>")
                            {
                                if (Process == "INSERT")
                                {
                                    val += "null,";
                                }
                                else
                                {
                                    val += ColumnName + "=null,";
                                }
                                subvalEachrow = true;
                            }
                            else if (Process != "INSERT" && string.IsNullOrEmpty(strVal) && UserRecords != null && UserRecords[ColumnName] != DBNull.Value && !string.IsNullOrEmpty(UserRecords[ColumnName].ToString()))
                            {
                                subvalEachrow = false;
                            }
                            else
                            {
                                switch (ColumnName)
                                {
                                    case "PORTERID":
                                        strVal = GetStatusValue(dsSts, "USER", strVal);
                                        break;
                                    case "SUBPORTERID":
                                        strVal = GetStatusValue(dsSts, "USER", strVal);
                                        break;
                                    case "REQUESTLOCATIONID":
                                        strVal = GetStatusValue(dsSts, "LOCATION", strVal);
                                        break;
                                    case "DESTINATIONLOCATIONID":
                                        strVal = GetStatusValue(dsSts, "LOCATION", strVal);
                                        break;
                                    case "CATEGORYID":
                                        strVal = GetStatusValue(dsSts, "CATEGORY", strVal);
                                        break;
                                    case "QUANTITY":
                                    case "PATIENTNAME":
                                    case "REQUESTORNAME":
                                    case "EQUIPMENTTYPE":
                                        strVal = GetStatusValue(dsSts, "EQUIPMENTTYPE", strVal);
                                        break;
                                    case "REQUESTDATE":
                                    case "ASSIGNEDTIME":
                                    case "STARTTIME":
                                    case "ENDTIME":
                                        DateTime parsedDate;
                                        string[] formats = {
                                            "dd/MM/yyyyHH:mm",
                                            "dd/MM/yyyy HH:mm",
                                            "dd/MM/yyyy HH:mm:ss",
                                            "dd-MM-yyyy HH:mm",
                                            "M/d/yyyy h:mm:ss tt",
                                            "M/d/yyyy h:mm tt",
                                            "MM/dd/yyyy HH:mm:ss",
                                            "yyyy-MM-dd HH:mm:ss",
                                            "yyyy/MM/dd HH:mm"
                                        };
                                        bool isParsed = DateTime.TryParseExact(rawValue, formats,
                                            System.Globalization.CultureInfo.InvariantCulture,
                                            System.Globalization.DateTimeStyles.None,
                                            out parsedDate);

                                        if (!isParsed)
                                        {
                                            throw new Exception(string.Format("Invalid date format for column '{0}' at row {1}: '{2}'", ColumnName, i + 2, rawValue));
                                        }

                                        strVal = parsedDate.ToString("yyyy-MM-dd HH:mm:ss");
                                        break;
                                }

                                if (Process == "INSERT")
                                {
                                    val += "'" + strVal + "',";
                                }
                                else
                                {
                                    val += ColumnName + "='" + strVal + "',";
                                }
                            }
                        }

                        val = val.TrimEnd(',');

                        if (subvalEachrow)
                        {
                            string Query = string.Empty;
                            if (Process == "INSERT")
                            {
                                Query = string.Format(@"
                                DECLARE @REQUESTID BIGINT, @REQNO INT;

                                SELECT @REQUESTID = ISNULL(MAX(RequestId), 0) + 1,
                                       @REQNO = ISNULL(MAX(REQNB), 0) + 1
                                FROM RequestMaster;

                                INSERT INTO Requestmaster ({0}, Userid, CreatedDate, RequestId, REQNB, RequestStatusId, IsDelay, Priority, ISTODAY, AssignedBy, UpdatedBy, ISBULK, SERVICE_ID) 
                                VALUES ({1}, '{2}', GETDATE(), @REQUESTID, @REQNO, 6, 0, 0, 1, 8, 8, 1, 
                                    CASE 
                                        WHEN '{3}' = '2' THEN 3 
                                        ELSE '{3}' 
                                    END
                                ); 

                                UPDATE NEXTREQUEST SET REQUESTID = (CONVERT(BIGINT, REQUESTID) + 1), REQNB = (CONVERT(BIGINT, REQNB) + 1);",
                                    colNames, val, HFUserID.Value.Trim(), ServiceID);

                            }
                            else
                            {
                                Query = "UPDATE Requestmaster SET " + val + ", CreatedBy='" + updatedBankId + "' WHERE RequestId= '" + primaryId + "'";
                            }

                            row.Add("Query", Query);
                            rows.Add(row);
                            result = true;
                        }
                        else
                        {
                            result = false;
                        }

                        if (!result)
                        {
                            rowsNum += " LINE : " + (i + 2).ToString() + ",";
                            fnlSts = false;
                        }
                    }
                    catch (Exception ex)
                    {
                        string errorScript = string.Format("alert('Error at line {0}: {1}');", i + 2, ex.Message.Replace("'", ""));
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", errorScript, true);
                    }
                }

                string fullFilePath = Server.MapPath("~/S3/" + filename);
                if (File.Exists(fullFilePath))
                {
                    File.Delete(fullFilePath);
                }

                if (!fnlSts)
                {
                    rowsNum = "UPLOAD FAILED. PLEASE CHECK THE DATA IN " + rowsNum.TrimEnd(',');
                    string alertFailed = "alert('" + rowsNum + "');";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", alertFailed, true);
                }
                else
                {
                    string dbRtn = DoMasterProcess(rows);
                    string CloseWindow = string.Empty;

                    if (string.IsNullOrEmpty(dbRtn))
                        CloseWindow = "alert('Record uploaded successfully.');";
                    else
                        CloseWindow = string.Format("alert('KINDLY CHECK THE DATA IN({0})');", dbRtn);

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", CloseWindow, true);
                }
            }
            catch (Exception ex1)
            {
                DataAccess.InsertError("EXCEPTION: " + ex1.Message.Replace("'", ""), "logerror");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", "alert('KINDLY CHECK THE DATA ENTERED');", true);
            }
            finally
            {
                if (con != null && con.State == ConnectionState.Open)
                    con.Close();
            }
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
    private string GetReqColumnValue(DataRow row, string colName)
    {
        if (row.Table.Columns.Contains(colName) && row[colName] != DBNull.Value)
        {
            return row[colName].ToString().Trim();
        }
        return string.Empty;
    }
    private bool IsNumber(string val)
    {
        int n;
        return int.TryParse(val.Trim(), out n);
    }

    private bool IsValidDate(string Date)
    {
        DateTime dtime;
        return DateTime.TryParse(Date, out dtime);
    }

    private string DoMasterProcess(List<Dictionary<string, string>> rows)
    {
        SqlConnection con = null;
        try
        {
            string constr = System.Configuration.ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
            con = new SqlConnection(constr);
            con.Open(); 

            foreach (Dictionary<string, string> row in rows)
            {
                if (row.ContainsKey("Query"))
                {
                    SqlCommand cmd = new SqlCommand(row["Query"], con);
                    cmd.ExecuteNonQuery(); 
                }
            }

            return string.Empty; 
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
        finally
        {
            if (con != null && con.State == ConnectionState.Open)
            {
                con.Close();
            }
        }
    }

    private string ChangeDateFormat(string strVal)
    {
        string Result = string.Empty, time = strVal.Split(' ')[1], date = strVal.Split(' ')[0];
        try
        {

            Result = date.Split('/')[1] + "/" + date.Split('/')[0] + "/" + date.Split('/')[2] + " " + time.Split(':')[0] + ":" + time.Split(':')[1];
        }
        catch (Exception ex)
        {
            Result = string.Empty;
        }
        return Result;
    }
    private string GetDate(string strVal)
    {
        string Result = string.Empty, time = strVal.Split(' ')[1], date = strVal.Split(' ')[0];
        try
        {
            //old frmt  Result = date.Split('/')[1] + "/" + date.Split('/')[0] + "/" + date.Split('/')[2] + " " + time.Split(':')[0] + ":" + time.Split(':')[1];

            Result = date.Split('/')[0] + "/" + date.Split('/')[1] + "/" + date.Split('/')[2] + " " + time.Split(':')[0] + ":" + time.Split(':')[1];
        }
        catch (Exception ex)
        {
            Result = string.Empty;
        }
        return Result;
    }
    private bool HasMandColumns(string[] MandColumns, string primaryId, DataRow ExcelRow, string[] MaxRow)
    {
        bool Result = true; List<DataColumn> List; string ColumnValue = string.Empty; string Process = string.IsNullOrEmpty(primaryId) ? "INSERT" : "UPDATE";
        string[] XMandColumns = MaxRow.Select(s => s.ToUpperInvariant().Replace(" ", "")).ToArray();
        if (Process == "INSERT")
        {
            foreach (string col in MandColumns)
            {
                List = ExcelRow.Table.Columns.Cast<DataColumn>().Where(val => val.ColumnName.ToUpper().Replace(" ", "")
                == col.ToUpper()).ToList();
                ColumnValue = (List.Count > 0) ? ExcelRow[List.First().ColumnName].ToString().Trim() : string.Empty;
                Result = (Result) ? (!string.IsNullOrEmpty(ColumnValue) && (ColumnValue.ToUpper() != "<CLEAR>")) : Result;
            }
        }
        if (Result)
        {
            Result = (ExcelRow.Table.Columns.Count >= 2);
            foreach (DataColumn Column in ExcelRow.Table.Columns)
            {
                if (new[] { "REQUESTID" }.Contains(Column.ColumnName.ToUpper())) continue;
                Result = (Result) ? XMandColumns.Contains(Column.ColumnName.ToUpper().Replace(" ", "")) : Result;
            }
        }
        return Result;
    }
    private string GetStatusValue(DataSet Source, string Column, string Value)
    {
        if (Source == null || Source.Tables.Count < 2 || string.IsNullOrWhiteSpace(Value))
            return string.Empty;

        string cleanValue = Value.Replace("*", "").Trim();

        DataTable dtPrimary = Source.Tables[0];
        DataTable dtAlias = Source.Tables[1];

        string lookupVal = cleanValue.ToUpper();

        int numericId;
        if (int.TryParse(lookupVal, out numericId))
        {
            string filter = "ID = " + numericId.ToString();
            DataRow[] rowsById = dtPrimary.Select(filter);
            if (rowsById.Length > 0)
                return rowsById[0]["ID"].ToString(); 
        }

        if (dtPrimary.Columns.Contains("RequestStatus"))
        {
            string escapedValue = Value.Replace("'", "''");
            string filter = "RequestStatus = '" + escapedValue + "'";
            DataRow[] rowsByRequestStatus = dtPrimary.Select(filter);
            if (rowsByRequestStatus.Length > 0)
                return rowsByRequestStatus[0]["ID"].ToString();
        }

        string groupName = Column.ToUpper().Replace("ID", "").TrimEnd();

        foreach (DataRow row in dtAlias.Rows)
        {
            if (row["GROUPNAME"] == DBNull.Value)
                continue;

            string rowGroupName = row["GROUPNAME"].ToString().ToUpper().Trim();
            if (rowGroupName != groupName)
                continue;

            string[] nameColumns = { "NAME", "NAME1", "NAME2", "NAME3" };
            foreach (string nameCol in nameColumns)
            {
                if (!dtAlias.Columns.Contains(nameCol))
                    continue;

                if (row[nameCol] == DBNull.Value)
                    continue;

                string nameVal = row[nameCol].ToString().ToUpper().Trim();

                if (nameVal == lookupVal)
                {
                    return row["ID"].ToString();
                }
            }
        }

        return string.Empty;
    }

    private string GetErrorColumn(string[] MandColumns, string primaryId, DataRow ExcelRow, string[] MaxRow)
    {
        bool Result = true; List<DataColumn> List; string ColumnValue = string.Empty; string Process = string.IsNullOrEmpty(primaryId) ? "INSERT" : "UPDATE";
        string[] XMandColumns = MaxRow.Select(s => s.ToUpperInvariant().Replace(" ", "")).ToArray(); string ColumnName = string.Empty;
        if (Process == "INSERT")
        {
            foreach (string col in MandColumns)
            {
                List = ExcelRow.Table.Columns.Cast<DataColumn>().Where(val => val.ColumnName.ToUpper().Replace(" ", "") == col.ToUpper()).ToList();
                ColumnValue = (List.Count > 0) ? ExcelRow[List.First().ColumnName].ToString().Trim() : string.Empty;
                Result = (Result) ? (!string.IsNullOrEmpty(ColumnValue) && (ColumnValue.ToUpper() != "<CLEAR>")) : Result;
                if (!Result)
                    return (List.Count > 0) ? List.First().ColumnName.ToString().Trim() : string.Empty;
            }
        }
        if (Result)
        {
            Result = (ExcelRow.Table.Columns.Count >= 2);
            foreach (DataColumn Column in ExcelRow.Table.Columns)
            {
                if (new[] { "REQUESTID" }.Contains(Column.ColumnName.ToUpper())) continue;
                Result = (Result) ? XMandColumns.Contains(Column.ColumnName.ToUpper().Replace(" ", "")) : Result;
                if (!Result)
                    return Column.ColumnName.ToString().Trim();
            }
        }
        return string.Empty;
    }

    private string GetColumnName(DataRow ExcelRow, string ReqColumn, int colid)
    {
        string Result = string.Empty;
        List<DataColumn> List = ExcelRow.Table.Columns.Cast<DataColumn>().Where(val => val.ColumnName.ToUpper().Replace(" ", "") == ReqColumn.ToUpper().Replace("ID", "")).ToList(),
                        List1 = ExcelRow.Table.Columns.Cast<DataColumn>().Where(val => val.ColumnName.ToUpper().Replace(" ", "") == ReqColumn.ToUpper()).ToList();


        Result = ((List.Count > 0) ? List.First().ColumnName.ToString() : (List1.Count > 0) ? List1.First().ColumnName.ToString() : ExcelRow.Table.Columns[colid].ColumnName.ToString());
        return Result;
    }

}