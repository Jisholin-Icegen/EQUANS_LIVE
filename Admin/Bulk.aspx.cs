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
                            DataRow UserRecords = (!string.IsNullOrEmpty(primaryId)) ? DataAccess.ExecuteQuery(primaryId, "UserDetails") : null; valid = (HasMandColumns(MandCols, primaryId, ExcelRow, MaxCols) && (string.IsNullOrEmpty(primaryId) || (UserRecords != null)));

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
                                    if ((!subvalEachrow) && string.IsNullOrEmpty(ErrorColumn))
                                        ErrorColumn = " - " + GetColumnName(ExcelRow, ColumnName, c) + " ";
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
                                fnlSts = false;
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

            string ServiceID = HFServiceCode.Value.ToString(), fName = ((ServiceID == "1") ? "Tasks_Portering" : "Tasks_Catering");
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
        string rowsNum = string.Empty, strlog = string.Empty;

        string ServiceID = HFServiceCode.Value.ToString();
        bool fnlSts = true;
        if (RadUploadTask.UploadedFiles.Count == 1)
        {
            try
            {
                string filename = DateTime.Now.Year + "" + DateTime.Now.Month + "" + DateTime.Now.Day;
                foreach (UploadedFile f in RadUploadTask.UploadedFiles)
                {
                    filename = f.GetName();
                    f.SaveAs(Server.MapPath("~/S3/") + filename, true);
                }
                string filePath = Server.MapPath("~/S3/" + filename);
                DataSet ds = new DataSet();
                //string constr = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source='" + filePath + " '; " + "Extended Properties=\"Excel 12.0;HDR=YES;\"";
                string constr = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source='" + filePath + " ';Extended Properties=\"Excel 12.0;HDR=YES;\"";
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
                    MaxCols = {"REQUESTDATE(DD/MM/YYYYHH:MM(24HOURS))","ASSIGNEDTIME(DD/MM/YYYYHH:MM(24HOURS))","STARTTIME(DD/MM/YYYYHH:MM(24HOURS))","ENDTIME(DD/MM/YYYYHH:MM(24HOURS))"
, "PORTER", "SUBPORTER", "FROM", "TO", "CATEGORY", "REMARKS", "REQUESTORNAME", "ISACTIVE","PORTERREMARKS","QUANTITY","PATIENT NAME" },
                    MandCols = { "REQUESTDATE(DD/MM/YYYYHH:MM(24HOURS))", "ASSIGNEDTIME(DD/MM/YYYYHH:MM(24HOURS))", "STARTTIME(DD/MM/YYYYHH:MM(24HOURS))", "ENDTIME(DD/MM/YYYYHH:MM(24HOURS))", "FROM", "TO", "CATEGORY", "REQUESTORNAME" },
                    MandColsCater = { "REQUESTDATE(DD/MM/YYYYHH:MM(24HOURS))", "ASSIGNEDTIME(DD/MM/YYYYHH:MM(24HOURS))", "STARTTIME(DD/MM/YYYYHH:MM(24HOURS))", "ENDTIME(DD/MM/YYYYHH:MM(24HOURS))", "TO", "CATEGORY", "REQUESTORNAME" };

                Hashtable htCols = new Hashtable();//get value using key
                htCols.Add("REQUESTDATE(DD/MM/YYYYHH:MM(24HOURS))", "REQUESTDATE");
                htCols.Add("ASSIGNEDTIME(DD/MM/YYYYHH:MM(24HOURS))", "ASSIGNEDTIME");
                htCols.Add("STARTTIME(DD/MM/YYYYHH:MM(24HOURS))", "STARTTIME");
                htCols.Add("ENDTIME(DD/MM/YYYYHH:MM(24HOURS))", "ENDTIME");
                htCols.Add("STATUS", "STATUSID");
                htCols.Add("CATEGORY", "CATEGORYID");
                htCols.Add("FROM", "RequestLocationId");
                htCols.Add("TO", "DestinationLocationId");
                htCols.Add("PORTER", "PORTERID");
                htCols.Add("SUBPORTER", "SUBPORTERID");
                //  htCols.Add("REQUESTEDBY", "USERID");

                htCols.Add("REMARKS", "REQUESTDESKREMARKS");
                htCols.Add("QUANTITY", "QUANTITY");
                htCols.Add("PATIENT NAME", "PATIENTNAME");

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
                    DataSet dsSts = DataAccess.GetGlobalAllRecords("GetGlobalDefaultValues", "REQUEST", "REQUEST"); rows = new List<Dictionary<string, string>>(); List<string> TmpValue = new List<string>();
                    DataRow[] dtls = null;

                    for (int i = 0; i <= ds.Tables[0].Rows.Count - 1; i++)
                    {
                        try
                        {
                            result = false; val = ""; valEachrow = true; subvalEachrow = true; checkExistVar1 = string.Empty; valid = false; ErrorColumn = string.Empty; Process = string.Empty; checkExistVar2 = string.Empty; ColumnName = string.Empty; ExcelRow = ds.Tables[0].Rows[i]; row = new Dictionary<string, string>();
                            primaryId = GetReqColumnValue(ExcelRow, "REQUESTID"); primaryId = (string.IsNullOrEmpty(primaryId) || primaryId == "FALSE") ? string.Empty : primaryId; Process = (string.IsNullOrEmpty(primaryId) ? "INSERT" : "UPDATE");
                            DataRow UserRecords = (!string.IsNullOrEmpty(primaryId)) ? DataAccess.ExecuteQuery(primaryId, "UserDetails") : null; valid = (HasMandColumns(((ServiceID == "2") ? MandColsCater : MandCols), primaryId, ExcelRow, MaxCols) && (string.IsNullOrEmpty(primaryId) || (UserRecords != null)));
                            string DestLocID = string.Empty, DestLoc = string.Empty, FromID = string.Empty, KitchenName = string.Empty;

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
                                            case "SUBPORTERID":
                                                //   case  "USERID":
                                                strVal = GetStatusValue(dsSts, "USER", strVal);
                                                //  strVal = strVal == "PORTER" ? "PORTERId" : strVal == "SUBPORTER" ? "subPORTERId" : "UserId" ;
                                                if (!string.IsNullOrEmpty(strVal))
                                                    val += ((Process == "INSERT") ? ("'" + strVal + "',") : ("" + ColumnName + "=" + "'" + strVal + "',"));
                                                else
                                                    subvalEachrow = false;
                                                break;
                                            case "REQUESTLOCATIONID":
                                            case "DESTINATIONLOCATIONID":
                                                if (ColumnName == "DESTINATIONLOCATIONID" && ServiceID == "2")
                                                    DestLoc = strVal;
                                                strVal = GetStatusValue(dsSts, "LOCATION", strVal);
                                                if (!string.IsNullOrEmpty(strVal))
                                                {
                                                    //  strVal = strVal == "FROM" ? "RequestLocationId" : "DestinationLocationId";
                                                    val += ((Process == "INSERT") ? ("'" + strVal + "',") : ("" + ColumnName + "=" + "'" + strVal + "',"));

                                                }
                                                else
                                                    subvalEachrow = false;
                                                break;
                                            case "CATEGORYID":
                                                strVal = GetStatusValue(dsSts, "CATEGORY", strVal);

                                                if (!string.IsNullOrEmpty(strVal))
                                                {
                                                    val += ((Process == "INSERT") ? ("'" + strVal + "',") : ("" + ColumnName + "=" + "'" + strVal + "',"));
                                                    if (ServiceID == "2")
                                                    {
                                                        string LocKitValues = GetStatusValue(dsSts, "LOCATIONKIT", DestLoc), CatKitValues = GetStatusValue(dsSts, "CATEGORYKIT", strVal);
                                                        string LBKitID = (LocKitValues.Contains("_") ? LocKitValues.Split('_')[0].ToString() : ""), LBKitName = (LocKitValues.Contains("_") ? LocKitValues.Split('_')[1].ToString() : "");

                                                        string CatKitID = (CatKitValues.Contains("_") ? CatKitValues.Split('_')[0].ToString() : ""), CatKitName = (CatKitValues.Contains("_") ? CatKitValues.Split('_')[1].ToString() : "");

                                                        FromID = LBKitName.Contains("Haywood") ? LBKitID : ((CatKitName.Contains("Main") && LBKitName.Contains("Main")) ? LBKitID : ((CatKitName.Contains("Main")) ? CatKitID : LBKitID));
                                                        KitchenName = LBKitName.Contains("Haywood") ? LBKitName : ((CatKitName.Contains("Main") && LBKitName.Contains("Main")) ? LBKitName : ((CatKitName.Contains("Main")) ? CatKitName : LBKitName));

                                                        //LBKitName.includes('Haywood')) ? LBKitID: ((CatKitName.includes("Main") && LBKitName.includes("Main")) ? LBKitID : ((CatKitName.includes("Main")) ? CatKitID : LBKitID
                                                    }
                                                }
                                                else
                                                    subvalEachrow = false;
                                                break;


                                            case "QUANTITY":
                                                if (IsNumber(strVal))
                                                {
                                                    val += ((Process == "INSERT") ? ("'" + strVal + "',") : ("" + ColumnName + "='" + strVal + "',"));
                                                    subvalEachrow = true;
                                                }
                                                else
                                                    subvalEachrow = false;
                                                break;

                                            case "PATIENTNAME":
                                                if (!string.IsNullOrEmpty(strVal))
                                                {
                                                    val += ((Process == "INSERT") ? ("'" + strVal + "',") : ("" + ColumnName + "='" + strVal + "',"));
                                                    subvalEachrow = true;
                                                }
                                                else
                                                    subvalEachrow = false;
                                                break;
                                            case "REQUESTORNAME":
                                                if (!string.IsNullOrEmpty(strVal))
                                                {
                                                    val += ((Process == "INSERT") ? ("'" + strVal + "',") : ("" + ColumnName + "='" + strVal + "',"));
                                                    subvalEachrow = true;
                                                }
                                                else
                                                    subvalEachrow = false;
                                                break;
                                            case "REQUESTDATE":
                                            case "ASSIGNEDTIME":
                                            case "STARTTIME":
                                            case "ENDTIME":

                                                string Date = GetDate(strVal); valEachrow = ((!string.IsNullOrEmpty(Date)) && IsValidDate(Date));
                                                //valEachrow = ColumnName == "ASSIGNEDTIME" ? datevalidate(ExcelRow["REQUEST DATE (DD/MM/YYYY HH:MM (24 HOURS))"].ToString(), strVal, string.Empty, string.Empty, ColumnName) :
                                                //    ColumnName == "STARTTIME" ? datevalidate(ExcelRow["REQUEST DATE (DD/MM/YYYY HH:MM (24 HOURS))"].ToString(), ExcelRow["ASSIGNED TIME (DD/MM/YYYY HH:MM (24 HOURS))"].ToString(), strVal, string.Empty, ColumnName) :
                                                //    ColumnName == "ENDTIME" ? datevalidate(ExcelRow["REQUEST DATE (DD/MM/YYYY HH:MM (24 HOURS))"].ToString(), ExcelRow["ASSIGNED TIME (DD/MM/YYYY HH:MM (24 HOURS))"].ToString(), ExcelRow["START TIME (DD/MM/YYYY HH:MM (24 HOURS))"].ToString(), strVal, ColumnName) :
                                                //   ColumnName == "REQUESTDATE" ? true : false;
                                                if (valEachrow)
                                                {
                                                    val += ((Process == "INSERT") ? ("'" + (ColumnName == "REQUESTDATE" ? ChangeDateFormat(strVal) + ":00" : ChangeDateFormat(strVal)) + "',") : ("" + ColumnName + "='" + strVal + "',"));
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
                                    if ((!subvalEachrow) && string.IsNullOrEmpty(ErrorColumn))
                                        ErrorColumn = " - " + GetColumnName(ExcelRow, ColumnName, c) + " ";
                                }
                                val = val.TrimEnd(',');
                                subvalEachrow = (ServiceID != "2") ? subvalEachrow : (FromID != string.Empty && KitchenName != string.Empty);
                                if (subvalEachrow)
                                {
                                    if (rowsNum.Length > 0)
                                        rows = new List<Dictionary<string, string>>();
                                    else
                                    {
                                        string Query = (Process == "INSERT") ? "DECLARE @REQUESTID BIGINT, @REQNO INT  SELECT @REQUESTID = REQUESTID,@REQNO = REQNB FROM NEXTREQUEST;insert into Requestmaster (" + colNames + ",Userid,CreatedDate,RequestId,REQNB,RequestStatusId,IsDelay,Priority,ISTODAY,AssignedBy,UpdatedBy,ISBULK,SERVICE_ID" + ((ServiceID == "2") ? ",REQUESTLOCATIONID,KITCHEN_ZONE" : "") + ") values (" + val + ", '" + HFUserID.Value.Trim() + "',GETDATE(),@REQUESTID,@REQNO,6,0,0,1,8,8,1,'" + ServiceID + "'" + ((ServiceID == "2") ? ", '" + FromID + "','" + KitchenName + "'" : "") + ");   UPDATE NEXTREQUEST SET REQUESTID = (CONVERT(BIGINT,REQUESTID) + 1), REQNB = (CONVERT(BIGINT,REQNB) + 1) ; " : "update Requestmasterr set " + val + ",CreatedBy='" + updatedBankId + "' where RequestId= '" + GetReqColumnValue(ExcelRow, "REQUESTID") + "'", Parameter = string.Empty;
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
                                fnlSts = false;
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


        /*
       OleDbConnection con = null;
       OleDbDataAdapter da = new OleDbDataAdapter();
       OleDbCommand cmd = new OleDbCommand();
       string rowsNum = string.Empty, strlog = string.Empty; string filename = string.Empty;
       string Line = string.Empty, CloseWindow = string.Empty;
       Errorlb.Text = string.Empty;
       bool fnlSts = true;
       if (RadUploadTask.UploadedFiles.Count == 1)
       {
           try
           {
                 filename = DateTime.Now.Year + "" + DateTime.Now.Month + "" + DateTime.Now.Day;
               foreach (UploadedFile f in RadUploadTask.UploadedFiles)
               {
                   filename = f.GetName();
                   f.SaveAs(Server.MapPath("~/UploadFiles/") + filename, true);
               }
               string filePath = Server.MapPath("~/UploadFiles/" + filename);
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
                           Errorlb.Text = Line;
                           CloseWindow = "alert('No records available in the Excel File !');";
                           ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", CloseWindow, true);
                           return;
                       }

                       System.Text.StringBuilder sb = new System.Text.StringBuilder();
                       Int64 rowcount = ds.Tables[0].Rows.Count;
                       for (int j = 0; j < rowcount; j++)
                       {
                           string EId = (ds.Tables[0].Rows[j]["LOGIN NAME"].ToString().Trim().Length > 0) ? ds.Tables[0].Rows[j]["LOGIN NAME"].ToString().ToUpper().Trim() : string.Empty,
                                  EName = (ds.Tables[0].Rows[j]["NAME"].ToString().Trim().Length > 0) ? ds.Tables[0].Rows[j]["NAME"].ToString().ToUpper().Trim() : string.Empty,
                                  RlName = (ds.Tables[0].Rows[j]["ROLE NAME"].ToString().Trim().Length > 0) ? ds.Tables[0].Rows[j]["ROLE NAME"].ToString().ToUpper().Trim() : string.Empty,
                                   DName = (ds.Tables[0].Rows[j]["DEPARTMENT NAME"].ToString().Trim().Length > 0) ? ds.Tables[0].Rows[j]["DEPARTMENT NAME"].ToString().ToUpper().Trim() : string.Empty;
                           try
                           {
                               bool Result = false;
                               if (EId != string.Empty && EName != string.Empty && DName != string.Empty && RlName != string.Empty)
                                   Result = ((DataAccess.UserMaster(string.Empty, EName, EId, "12345", RlName, true, "BULKINSERT", DName, Session["EMPID"].ToString(), string.Empty).Rows[0]["RESULT"].ToString()) == "TRUE");
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
                     CloseWindow = "alert('Please Select a Excel File !');";
                   ScriptManager.RegisterStartupScript(this, this.GetType(), "PopUP", CloseWindow, true);
               } */
    }



    private string SetLine(string Line, int j)
    {
        if (string.IsNullOrEmpty(Line))
            Line += " '" + (j + 2) + "' ";
        else
            Line += " , '" + (j + 2) + "' ";
        return Line;
    }
    private string GetReqColumnValue(DataRow ExcelRow, string ReqColumn)
    {
        ReqColumn = (ReqColumn == "REQUESTID") ? ReqColumn : ReqColumn.ToUpper().Replace("ID", "");
        List<DataColumn> List = ExcelRow.Table.Columns.Cast<DataColumn>().Where(val => val.ColumnName.ToUpper().Replace(" ", "") == ReqColumn).ToList();
        return ((List.Count > 0) ? (string.IsNullOrEmpty(ExcelRow[List.First().ColumnName].ToString()) ? "FALSE" : ExcelRow[List.First().ColumnName].ToString()) : string.Empty);
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
    private string DoMasterProcess(List<Dictionary<string, string>> QueryList)
    {
        int i = 1; string rtnRslt = string.Empty; bool rtnVal = true;
        foreach (Dictionary<string, string> Query in QueryList)
        {
            try
            {
                string Querytext = Query.ElementAt(0).Key;
                i++;
                rtnVal = DataAccess.BulkInsertUpdate("BulkInsertUpdate", Querytext, "INSERT", "", string.Empty, string.Empty, "REQUEST");
                if (!rtnVal)
                    rtnRslt = rtnRslt != "" ? rtnRslt + "," + i.ToString() : i.ToString();

            }
            catch (Exception Ex)
            {
            }
        }
        return rtnRslt;
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

    private string GetStatusValue(System.Data.DataSet Source, string Column, string Value)
    {

        DataRow[] dtls, dtls1; bool valEachrow;
        var Value1 = (Column == "LOCATION" || Column == "LOCATIONKIT") ? Value.Replace("*", "") : Value;
        string Query = "GlobalStatusHeader='" + (Column.Replace("ID", "")) + "' and RequestStatus ='" + Value + "'",
               subQuery = "GROUPNAME = '" + (Column.Replace("ID", "")) + "' and  ( NAME = '" + Value + "' OR  NAME1 = '" + Value + "' OR  NAME2 = '" + Value + "' OR  NAME3 = '" + Value + "' OR NAME = '" + Value1 + "' OR  NAME1 = '" + Value1 + "' OR  NAME2 = '" + Value1 + "' OR  NAME3 = '" + Value1 + "' )";
        dtls = Source.Tables[0].Select(Query); dtls1 = Source.Tables[1].Select(subQuery);
        valEachrow = (dtls.Length > 0 || dtls1.Length > 0);
        if (valEachrow)
        {
            if (Column == "LOCATIONKIT")
                return (dtls.Length > 0) ? dtls[0]["id"].ToString() : dtls1[0]["ID"].ToString();
            else
                return Convert.ToInt32((dtls.Length > 0) ? dtls[0]["id"].ToString() : dtls1[0]["ID"].ToString()).ToString();
        }
        else
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