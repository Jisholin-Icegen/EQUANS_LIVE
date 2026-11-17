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

public partial class Service : System.Web.UI.Page
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

    public void FromWebMobile()
    {
        string[] stringMultiSeriesOutput = { "GETRESOURCEUSAGE", "GENEMPOPPORTUNITY" };
        DataSet data = new DataSet();
        process = ((!string.IsNullOrEmpty((Request.QueryString["Process"]))) ? AESEncrytDecry.DecryptStringAES( Request.QueryString["Process"].ToString()) : "");
        switch (process)
        {

            case "GETREQDETAILS":
                data = getReqdetails();
                break;

            case "GETLOGS":
                data = getLogs();
                break;

            case "GETCOMPLETELOGS":
                data = getCompleteLogs();
                break;

            case "ADDCOMPLETEREMARKS":
                data = AddcompleteRemarks();
                break;
            case "GET":
                data = GetRecords();
                break;
            case "REPORT":
                data = GetReport();
                break;
            case "DATEWISE":
                data = GetDateWise();
                break;
            case "PORTERTRAC":
                data = GetPorterTrack();
                break;
            case "GETCATEGORY":
                data = GetCategory();
                break;
            case "EXPORTCATEGORY":
                data = ExportCategory();
                break;
            case "EXPORTTIMEWISE":
                data = ExportPorterwise();
                break;
            case "EXPORTPORTERWISE":
                data = ExportPorterwise();
                break;
            case "EXPORTDATEWISE":
                data = ExportDateWise();
                break;
            case "EXPORTDAILYWISE":
                data = ExportDaily();
                break;
            case "GETESCALATION":
                data = GetEscalationRecords();
                break;

            case "SEARCHDEPT":
                data = SearchRG();
                break;

            case "GENDURATIONOVERRUN":
                data = getDurationOverruns();
                break;
            case "GENRESPONSEOVERRUN":
                data = getResponseOverruns();
                break;

            case "GETRESOURCEUSAGE":
                GetResourceUsage();
                break;
            case "GENEMPOPPORTUNITY":
                GetEmployeeOpportunity();
                break;
            case "LOGOUT":
                data = LogOut();
                break;

            case "GETCATEGORIES":
                data = GetCategories();
                break;

            case "PRESET":
                data = PresetOperations();
                break;

        }
        //data = getRecords();
        if (!stringMultiSeriesOutput.Contains(process))
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
    }

    public DataSet PresetOperations()
    {
        string Process = ((!string.IsNullOrEmpty(Request.QueryString["ACTION"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["ACTION"].ToString()) : "");
        DataTable dt = null;
        if (Process != DataAccess.InvalidStr )
        dt =DataAccess.PersetMaster("SP_PRESETMASTER", string.Empty, string.Empty, string.Empty, Process, "1").Tables[0];
        DataSet DS = new DataSet(); DS.Tables.Add(dt.Copy());
        return DS;
    }
    /* Report Start */
    private void GetResourceUsage()
    {
        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["From"].ToString()) : ""),
             To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["To"].ToString()) : ""),
             Type = ((!string.IsNullOrEmpty(Request.QueryString["Type"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Type"].ToString()) : ""),
             PorterId = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTERID"].ToString()) : ""),
             GroupBy = ((!string.IsNullOrEmpty(Request.QueryString["GROUPBY"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["GROUPBY"].ToString()) : "");

        string HospitalLoc = ((!string.IsNullOrEmpty(Request.QueryString["HospitalLoc"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["HospitalLoc"].ToString()) : ""),
        ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : "");
        ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);
        if (HospitalLoc != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr && From != DataAccess.InvalidStr && To != DataAccess.InvalidStr && Type != DataAccess.InvalidStr && PorterId != DataAccess.InvalidStr && GroupBy != DataAccess.InvalidStr)
        SetMultiChart(DataAccess.getResorceUsage(From, To, PorterId, GroupBy, ServiceID, HospitalLoc), string.Empty);
    }
    private void GetEmployeeOpportunity()
    {
        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["From"].ToString()) : ""),
             To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["To"].ToString()) : ""),
             Type = ((!string.IsNullOrEmpty(Request.QueryString["Type"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Type"].ToString()) : ""),
             GroupBy = ((!string.IsNullOrEmpty(Request.QueryString["GROUPBY"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["GROUPBY"].ToString()) : "");
        if (From != DataAccess.InvalidStr && To != DataAccess.InvalidStr && Type != DataAccess.InvalidStr && GroupBy != DataAccess.InvalidStr)
          SetMultiChart(DataAccess.getEmpOpportunity(From, To, GroupBy), string.Empty);
    }
    private DataTable getLabel()
    {
        DataColumn column;
        DataRow row;
        var table = new DataTable();
        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "LABEL";
        table.Columns.Add(column);

        return table;
    }
    private DataTable getValue()
    {
        DataColumn column;
        DataRow row;
        var table = new DataTable();
        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "VALUE";
        table.Columns.Add(column);

        return table;
    }


    public DataSet getReqdetails()
    {
        string RequestIDs = string.IsNullOrEmpty(Request.QueryString["REQUESTID"]) ? "" : Request.QueryString["REQUESTID"].ToString();
        RequestIDs = AESEncrytDecry.DecryptStringAES(RequestIDs.Trim());
        DataSet dt = new DataSet();
        if (RequestIDs != DataAccess.InvalidStr)
        {
            SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
            SqlCommand cmd = new SqlCommand("SP_GETRPTREDETAILS", Con);
            cmd.CommandTimeout = 1000;
            cmd.Parameters.AddWithValue("@REQUESTID", RequestIDs);
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                Con.Open();
                adpt.Fill(dt);
            }
            catch (Exception ex)
            {
                DataAccess.InsertError(ex.Message.ToString(), "SP_GETRPTREDETAILS");

            }
            finally
            {
                if (Con.State == ConnectionState.Open)
                    Con.Close();
            }
        }
        return dt;

    }

    public DataSet getLogs()
    {
        string RequestIDs = string.IsNullOrEmpty(Request.QueryString["REQUESTID"]) ? "" : Request.QueryString["REQUESTID"].ToString();
        RequestIDs = AESEncrytDecry.DecryptStringAES(RequestIDs.Trim());
        DataSet dt = new DataSet();
        if (RequestIDs != DataAccess.InvalidStr)
        {
            SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
            SqlCommand cmd = new SqlCommand("SP_GETREQUESTLOG", Con);
            cmd.CommandTimeout = 1000;
            cmd.Parameters.AddWithValue("@REQUESTID", RequestIDs);
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                Con.Open();
                adpt.Fill(dt);
            }
            catch (Exception ex)
            {
                DataAccess.InsertError(ex.Message.ToString(), "SP_GETREQUESTLOG");

            }
            finally
            {
                if (Con.State == ConnectionState.Open)
                    Con.Close();
            }
        }
        return dt;

    }


    public DataSet getCompleteLogs()
    {
        string RequestIDs = string.IsNullOrEmpty(Request.QueryString["REQUESTID"]) ? "" : Request.QueryString["REQUESTID"].ToString();
        RequestIDs = AESEncrytDecry.DecryptStringAES(RequestIDs.Trim());
        DataSet dt = new DataSet();
        if (RequestIDs != DataAccess.InvalidStr)
        {
            SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
            SqlCommand cmd = new SqlCommand("SP_GETCOMPLETEREMARKS", Con);
            cmd.CommandTimeout = 1000;
            cmd.Parameters.AddWithValue("@REQUESTID", RequestIDs);
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                Con.Open();
                adpt.Fill(dt);
            }
            catch (Exception ex)
            {
                DataAccess.InsertError(ex.Message.ToString(), "SP_GETCOMPLETEREMARKS");

            }
            finally
            {
                if (Con.State == ConnectionState.Open)
                    Con.Close();
            }
        }
        return dt;

    }

    private DataSet AddcompleteRemarks()
    {
        string REASON = ((!string.IsNullOrEmpty(Request.QueryString["REMARKS"])) ? Request.QueryString["REMARKS"].ToString() : ""),
            REQUESTID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString(),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString(),
            IsMitigation = (string.IsNullOrEmpty(Request.QueryString["ISMITIGATION"])) ? string.Empty : Request.QueryString["ISMITIGATION"].ToString();
        DataTable table;
        if (User == string.Empty)
        {
            table = generate();
            DataRow row = table.NewRow();
            row["RESULT"] = "FALSE";
            table.Rows.Add(row);
        }
        else
        {
            REASON = AESEncrytDecry.DecryptStringAES(REASON); REQUESTID = AESEncrytDecry.DecryptStringAES(REQUESTID);
            User = AESEncrytDecry.DecryptStringAES(User); IsMitigation = AESEncrytDecry.DecryptStringAES(IsMitigation);

            if (REASON != DataAccess.InvalidStr && REQUESTID != DataAccess.InvalidStr && User != DataAccess.InvalidStr && IsMitigation != DataAccess.InvalidStr)
                table = DataAccess.AddCompleteRemarks(REQUESTID, REASON, User, IsMitigation);
            else
            {

                table = generate();
                DataRow row = table.NewRow();
                row["RESULT"] = "FALSE";
                table.Rows.Add(row);
            }
        }

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private void SetMultiChart(DataTable dataTable, string Type)
    {
        DataSet DS = new DataSet();
        DataTable tblValue1 = getValue(), tblValue2 = getValue(), tblLabel = getLabel();
        DataRow rowlbl, rowval1, rowval2; decimal value = 0, count = 0, value1 = 0, count1 = 0;
        for (int i = 0; i < dataTable.Rows.Count; i++)
        {
            DataRow drow = dataTable.Rows[i];
            if (i == 0)
            {
                foreach (DataColumn dcol in dataTable.Columns)
                {
                    rowlbl = tblLabel.NewRow(); rowval1 = tblValue1.NewRow();
                    rowlbl["LABEL"] = dcol.ColumnName.ToUpper().ToString();

                    rowval1["VALUE"] = drow[dcol.ColumnName];

                    //value += Convert.ToDecimal(drow[dcol.ColumnName]);
                    //count += (Convert.ToDecimal(drow[dcol.ColumnName]) > 0) ? 1 : 0;

                    tblLabel.Rows.Add(rowlbl); tblValue1.Rows.Add(rowval1);
                }
                /*rowlbl = tblLabel.NewRow(); rowval1 = tblValue1.NewRow();
                rowval1["VALUE"] = ((count > 0) ? value / count : 0).ToString("#.##");
                rowlbl["LABEL"] = "AVERAGE ( OVERALL )";
                tblLabel.Rows.Add(rowlbl); tblValue1.Rows.Add(rowval1);*/
            }
            else
            {
                foreach (DataColumn dcol in dataTable.Columns)
                {
                    rowval2 = tblValue2.NewRow();
                    rowval2["VALUE"] = drow[dcol.ColumnName].ToString();

                    //value1 += Convert.ToDecimal(drow[dcol.ColumnName]);
                    //count1 += (Convert.ToDecimal(drow[dcol.ColumnName]) > 0) ? 1 : 0;

                    tblValue2.Rows.Add(rowval2);
                }
                /*rowval2 = tblValue2.NewRow();
                rowval2["VALUE"] = ((count1 > 0) ? value1 / count1 : 0).ToString("#.##");
                tblValue2.Rows.Add(rowval2);*/
            }
        }
        DS.Tables.Add(tblLabel.Copy()); DS.Tables.Add(tblValue1.Copy()); DS.Tables.Add(tblValue2.Copy());
        serializeMultichart(DS);

    }
    public void serializeMultichart(DataSet ds)
    {

        JavaScriptSerializer serializer = new JavaScriptSerializer() { MaxJsonLength = int.MaxValue };
        List<Dictionary<string, object>> rows; Dictionary<string, object> row;
        List<List<Dictionary<string, object>>> list = new List<List<Dictionary<string, object>>>();

        foreach (DataTable table in ds.Tables)
        {
            if (table.Rows.Count > 0)
            {
                rows = new List<Dictionary<string, object>>();
                foreach (DataRow dr in table.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in table.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
                list.Add(rows);
            }

        }
        Response.Write(serializer.Serialize(list));

    }
    private DataSet getDurationOverruns()
    {
        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["From"].ToString()) : ""),
             To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["To"].ToString()) : ""),
              Type = ((!string.IsNullOrEmpty(Request.QueryString["Type"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Type"].ToString()) : ""),
              PorterId = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTERID"].ToString()) : ""),
             GroupBy = ((!string.IsNullOrEmpty(Request.QueryString["GROUPBY"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["GROUPBY"].ToString()) : "");
        //senthil
        string HospitalLoc = ((!string.IsNullOrEmpty(Request.QueryString["HospitalLoc"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["HospitalLoc"].ToString()) : ""),
        ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : "");
        ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);
        DataTable table = new DataTable();
        if (From != DataAccess.InvalidStr && To != DataAccess.InvalidStr && Type != DataAccess.InvalidStr && PorterId != DataAccess.InvalidStr && HospitalLoc != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr)
            table = SetPeekHour1(DataAccess.getDurationOverruns(From, To, PorterId, GroupBy, ServiceID, HospitalLoc), string.Empty);

        DataSet ds = new DataSet(); ds.Tables.Add(table.Copy());
        return ds;
    }


    private DataSet getResponseOverruns()
    {
        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["From"].ToString()) : ""),
             To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["To"].ToString()) : ""),
             Type = ((!string.IsNullOrEmpty(Request.QueryString["Type"])) ? Request.QueryString["Type"].ToString() : ""),
              PorterId = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTERID"].ToString()) : ""),
             GroupBy = ((!string.IsNullOrEmpty(Request.QueryString["GROUPBY"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["GROUPBY"].ToString()) : "");
        //senthil
        string HospitalLoc = ((!string.IsNullOrEmpty(Request.QueryString["HospitalLoc"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["HospitalLoc"].ToString()) : ""),
        ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? AESEncrytDecry.DecryptStringAES( Request.QueryString["SERVICEID"].ToString()) : "");
        DataTable table = new DataTable();
        if (ServiceID != DataAccess.InvalidStr && From != DataAccess.InvalidStr && To != DataAccess.InvalidStr && PorterId != DataAccess.InvalidStr && GroupBy != DataAccess.InvalidStr && HospitalLoc != DataAccess.InvalidStr)
            table = SetPeekHour1(DataAccess.getResponseOverruns(From, To, PorterId, GroupBy, ServiceID, HospitalLoc), string.Empty);

        DataSet ds = new DataSet(); ds.Tables.Add(table.Copy());
        return ds;
    }

    private DataTable SetPeekHour1(DataTable dataTable, string Type)
    {
        DataTable table = generateChartTable();
        DataRow row; bool start = true; decimal value = 0, count = 0;
        foreach (DataRow drow in dataTable.Rows)
        {
            foreach (DataColumn dcol in dataTable.Columns)
            {
                row = table.NewRow();
                row["VALUE"] = drow[dcol.ColumnName];
                row["LABEL"] = dcol.ColumnName.ToUpper();

                value += Convert.ToDecimal(drow[dcol.ColumnName]);
                count += (Convert.ToDecimal(drow[dcol.ColumnName]) > 0) ? 1 : 0;
                table.Rows.Add(row);
            }
            /*row = table.NewRow();
            row["VALUE"] = ((count > 0) ? value / count : 0).ToString("#.##");
            row["LABEL"] = "AVERAGE ( OVERALL )";
            table.Rows.Add(row);*/
        }
        return table;

    }
    public DataSet GetRecords()
    {
        string Status = ((!string.IsNullOrEmpty(Request.QueryString["Status"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Status"].ToString()) : ""), From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["From"].ToString()) : ""),
             To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["To"].ToString()) : ""), Search = ((!string.IsNullOrEmpty(Request.QueryString["Search"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Search"].ToString()) : ""),
             user = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["USERID"].ToString()),
             DeptIDs = (string.IsNullOrEmpty(Request.QueryString["DEPTIDS"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["DEPTIDS"].ToString()),
             PageSize = ((!string.IsNullOrEmpty(Request.QueryString["PageSize"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PageSize"].ToString()) : "15"),
             PageIndex = ((!string.IsNullOrEmpty(Request.QueryString["PageIndex"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PageIndex"].ToString()) : "0");

        DataTable dt = null;
        if (Status != DataAccess.InvalidStr && To != DataAccess.InvalidStr && user != DataAccess.InvalidStr && DeptIDs != DataAccess.InvalidStr && PageSize != DataAccess.InvalidStr && PageIndex != DataAccess.InvalidStr )
        dt = DataAccess.RequestMaster(string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, user, string.Empty, string.Empty, Status, string.Empty, string.Empty, DeptIDs, From, To, string.Empty, "GET", Search, string.Empty, PageIndex, PageSize);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;

    }

    public DataSet GetEscalationRecords()
    {
        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["From"].ToString()) : ""),
             To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["To"].ToString()) : ""),
             Search = ((!string.IsNullOrEmpty(Request.QueryString["Search"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Search"].ToString()) : "");
                DataTable dt = null, dt1=null;
        if (From != DataAccess.InvalidStr && To != DataAccess.InvalidStr && Search != DataAccess.InvalidStr)
        dt = DataAccess.GetEscalationRecords(From, To, Search);
        dt1 = generateChartTable(); DataRow dr, dr1;
        switch (dt.Rows.Count)
        {
            case 0:
                dr = dt1.NewRow(); dr["LABEL"] = "ASSIGN-START"; dr["VALUE"] = "0"; dt1.Rows.Add(dr);
                dr1 = dt1.NewRow(); dr1["LABEL"] = "START-END"; dr1["VALUE"] = "0"; dt1.Rows.Add(dr1);
                break;
            case 1:
                string curColumn = dt.Rows[0]["ESCALATION TYPE"].ToString(), curVal = dt.Rows[0]["ESCALATIONCOUNT"].ToString();
                dr = dt1.NewRow(); dr["LABEL"] = curColumn; dr["VALUE"] = curVal; dt1.Rows.Add(dr);
                if (curColumn == "ASSIGN-START")
                {
                    dr1 = dt1.NewRow(); dr1["LABEL"] = "START-END"; dr1["VALUE"] = "0"; dt1.Rows.Add(dr1);
                }
                else
                {
                    dr1 = dt1.NewRow(); dr1["LABEL"] = "ASSIGN-START"; dr1["VALUE"] = "0"; dt1.Rows.Add(dr1);
                }

                break;
            case 2:
                foreach (DataRow dRow in dt.Rows)
                {
                    dr = dt1.NewRow(); dr["LABEL"] = dRow["ESCALATION TYPE"].ToString(); dr["VALUE"] = dRow["ESCALATIONCOUNT"].ToString(); dt1.Rows.Add(dr);
                }

                break;
        }

        DataSet DS = new DataSet(); DS.Tables.Add(dt1);
        return DS;

    }

    private DataSet GetReport()
    {
        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["From"].ToString()) : ""),
             To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["To"].ToString()) : ""),
             Type = ((!string.IsNullOrEmpty(Request.QueryString["Type"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Type"].ToString()) : ""),
             PorterId = ((!string.IsNullOrEmpty(Request.QueryString["PorterId"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PorterId"].ToString()) : ""),
             Search = ((!string.IsNullOrEmpty(Request.QueryString["Search"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Search"].ToString()) : ""),
             PageSize = ((!string.IsNullOrEmpty(Request.QueryString["PageSize"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PageSize"].ToString() ): "15"),
             PageIndex = ((!string.IsNullOrEmpty(Request.QueryString["PageIndex"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PageIndex"].ToString()) : "0"),
             //senthil
             HospitalLoc = ((!string.IsNullOrEmpty(Request.QueryString["HospitalLoc"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["HospitalLoc"].ToString()) : ""),
             ServiceID = ((!string.IsNullOrEmpty((Request.QueryString["SERVICEID"]))) ? AESEncrytDecry.DecryptStringAES( Request.QueryString["SERVICEID"].ToString()) : "");
        


        DataTable table = new DataTable();

        if (HospitalLoc != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr && Type != DataAccess.InvalidStr && From != DataAccess.InvalidStr && To != DataAccess.InvalidStr && PorterId != DataAccess.InvalidStr && Search != DataAccess.InvalidStr && PageSize != DataAccess.InvalidStr && PageIndex != DataAccess.InvalidStr )
        switch (Type)
        {
            case "PEEKHOUR":
            case "PORTERPEEKHOUR":
                table = SetPeekHour(DataAccess.ReportMaster(Type, From, To, PorterId, string.Empty, string.Empty, string.Empty, ServiceID, HospitalLoc), Type);
                break;
            case "PEEKHOURTIME":
            case "PORTERPERFORMANCE":
            case "HOURLYASSIGNWAIT":
            case "HOURLYPROGRESSWAIT":
                table = SetPeekHour(DataAccess.ReportMaster(Type, From, To, PorterId, Search, string.Empty, string.Empty, ServiceID, HospitalLoc), Type);
                break;
            case "DATEWISE":
            case "CATEGORYWISE":
            case "PERFORMANCECATEGORYWISE":
            case "PORTERCATEGORYWISE":
            case "PORTERWISECATEGORYPERFORMANCE":
            case "CATEGORYWISEASSIGNWAITTIME":
            case "CATEGORYWISEPROGRESSWAITTIME":
            case "PERFORMANCETOTALCATEGORYWISE":
                table = SetDateWise(Type, DataAccess.ReportMaster(Type, From, To, PorterId, Search, string.Empty, string.Empty, ServiceID, HospitalLoc), ServiceID);
                break;
            case "GETPORTER":
            case "GETASSIGNEDPORTER":
            case "ALERT":
                table = DataAccess.ReportMaster(Type, From, To, PorterId, Search, PageSize, PageIndex, ServiceID, HospitalLoc);
                break;

        }
        DataSet ds = new DataSet(); ds.Tables.Add(table.Copy());
        return ds;
    }

    private DataSet GetCategories()
    {
        string Value = ((!string.IsNullOrEmpty(Request.QueryString["VAL"])) ? Request.QueryString["VAL"].ToString() : ""),
            Value1 = ((!string.IsNullOrEmpty(Request.QueryString["VAL1"])) ? Request.QueryString["VAL1"].ToString() : ""),
            ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : "");
        Value = AESEncrytDecry.DecryptStringAES(Value); Value1 = AESEncrytDecry.DecryptStringAES(Value1); ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);
        DataSet DS = null;
        if (Value != DataAccess.InvalidStr && Value1 != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr)
        DS =DataAccess.GetRecordss("SP_GETREQUESTCATETORIES", "@VAL", Value, "@VAL1", Value1, "@SERVICEID", ServiceID).Copy();
        return DS;
    }

    private DataSet GetDateWise()
    {
        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? Request.QueryString["From"].ToString() : ""),
             To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? Request.QueryString["To"].ToString() : ""),
             Status = ((!string.IsNullOrEmpty(Request.QueryString["Status"])) ? Request.QueryString["Status"].ToString() : ""),
             Search = ((!string.IsNullOrEmpty(Request.QueryString["Search"])) ? Request.QueryString["Search"].ToString() : ""),
             ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : ""),
             PageSize = ((!string.IsNullOrEmpty(Request.QueryString["PageSize"])) ? Request.QueryString["PageSize"].ToString() : "15"),
             PageIndex = ((!string.IsNullOrEmpty(Request.QueryString["PageIndex"])) ? Request.QueryString["PageIndex"].ToString() : "0");

        Search = AESEncrytDecry.DecryptStringAES(Search); ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);
        From = AESEncrytDecry.DecryptStringAES(From);
        To = AESEncrytDecry.DecryptStringAES(To);
        Status = AESEncrytDecry.DecryptStringAES(Status);
        PageSize = AESEncrytDecry.DecryptStringAES(PageSize);
        PageIndex = AESEncrytDecry.DecryptStringAES(PageIndex);
        DataTable table = null;
        if (Search != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr && From != DataAccess.InvalidStr && To != DataAccess.InvalidStr && Status != DataAccess.InvalidStr && PageSize != DataAccess.InvalidStr && PageIndex != DataAccess.InvalidStr)
          table = DataAccess.DateWise(Status, From, To, Search, PageSize, PageIndex, ServiceID);

        DataSet ds = new DataSet(); ds.Tables.Add(table.Copy());
        return ds;
    }
    private DataSet GetPorterTrack()
    {
        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["From"].ToString()) : ""),
             To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["To"].ToString()) : ""),
             Status = ((!string.IsNullOrEmpty(Request.QueryString["Status"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Status"].ToString()) : ""),
             Search = ((!string.IsNullOrEmpty(Request.QueryString["Search"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Search"].ToString()) : ""),
             ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["SERVICEID"].ToString()) : ""),
             PageSize = ((!string.IsNullOrEmpty(Request.QueryString["PageSize"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PageSize"].ToString()) : "15"),
             PageIndex = ((!string.IsNullOrEmpty(Request.QueryString["PageIndex"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PageIndex"].ToString()) : "0");

        //Search = AESEncrytDecry.DecryptStringAES(Search);
        //ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);
        DataTable table = null;
        if (From != DataAccess.InvalidStr && To != DataAccess.InvalidStr && Status != DataAccess.InvalidStr && Search != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr && PageSize != DataAccess.InvalidStr && PageIndex != DataAccess.InvalidStr)
        table = DataAccess.PorterTrackr(Status, From, To, Search, PageSize, PageIndex, ServiceID);

        DataSet ds = new DataSet(); ds.Tables.Add(table.Copy());
        return ds;
    }

    private DataTable SetPeekHour(DataTable dataTable, string Type)
    {
        DataTable table = generateChartTable();
        DataRow row; bool start = true; decimal value = 0, count = 0;
        foreach (DataRow drow in dataTable.Rows)
        {
            foreach (DataColumn dcol in dataTable.Columns)
            {
                row = table.NewRow();
                row["VALUE"] = drow[dcol.ColumnName];
                row["LABEL"] = dcol.ColumnName.ToUpper();
                switch (Type)
                {
                    case "HOURLYASSIGNWAIT":
                    case "HOURLYPROGRESSWAIT":
                        value += Convert.ToDecimal(drow[dcol.ColumnName]);
                        count += (Convert.ToDecimal(drow[dcol.ColumnName]) > 0) ? 1 : 0;
                        break;
                }
                table.Rows.Add(row);
            }
            switch (Type)
            {
                case "HOURLYASSIGNWAIT":
                case "HOURLYPROGRESSWAIT":
                    row = table.NewRow();
                    row["VALUE"] = ((count > 0) ? value / count : 0).ToString("#.##");
                    row["LABEL"] = "AVERAGE ( OVERALL )";
                    table.Rows.Add(row);
                    break;
            }
        }
        return table;

    }

    private DataTable SetDateWise(string Type, DataTable dataTable, string ServiceID)
    {
        DataTable table = generateChartTable();
        DataRow row; bool start = true;
        if (dataTable.Rows.Count == 0)
        {
            switch (Type)
            {
                case "CATEGORYWISE":
                case "PORTERCATEGORYWISE":
                case "PERFORMANCECATEGORYWISE":
                case "PORTERWISECATEGORYPERFORMANCE":
                case "CATEGORYWISEASSIGNWAITTIME":
                case "CATEGORYWISEPROGRESSWAITTIME":
                    SetCatEmpty(table);
                    break;
                case "DATEWISE":
                    SetStatEmpty(table, ServiceID);
                    break;
            }
        }
        else
        {
            foreach (DataRow drow in dataTable.Rows)
            {
                if (start && Type == "DATEWISE") { SetRaised(drow, table); start = false; }
                row = table.NewRow();
                row["VALUE"] = drow["CNT"];
                row["LABEL"] = drow["STATUS"].ToString();
                table.Rows.Add(row);
            }
        }
        return table;
    }

    private DataTable SetCatEmpty(DataTable tbl)
    {
        DataTable dtCat = DataAccess.CategoryMaster(string.Empty, string.Empty, string.Empty, false, "GET"); DataRow row;

        foreach (DataRow drow in dtCat.Rows)
        {
            row = tbl.NewRow();
            row["VALUE"] = "0";
            row["LABEL"] = drow["CATEGORYNAME"].ToString();
            tbl.Rows.Add(row);
        }
        return tbl;
    }

    private DataTable SetStatEmpty(DataTable tbl,string ServiceID)
    {
        bool start = true;
        DataTable dtSat = DataAccess.StatusMasterNew(string.Empty, string.Empty, false, "GET", ServiceID); DataRow row;
        foreach (DataRow drow in dtSat.Rows)
        {
            if (start) { SetRaisedEmpty(tbl); start = false; }
            row = tbl.NewRow();
            row["VALUE"] = "0";
            row["LABEL"] = drow["REQUESTSTATUS"].ToString();
            tbl.Rows.Add(row);
        }
        return tbl;
    }

    private void SetRaised(DataRow drow, DataTable table)
    {
        DataRow row = table.NewRow();
        row["VALUE"] = drow["TOTAL"];
        row["LABEL"] = "RAISED";
        table.Rows.Add(row);
    }

    private void SetRaisedEmpty(DataTable table)
    {
        DataRow row = table.NewRow();
        row["VALUE"] = "0";
        row["LABEL"] = "RAISED";
        table.Rows.Add(row);
    }

    private DataSet GetCategory()
    {
        DataTable table = new DataTable();
        table = DataAccess.getRecords("SP_GETCATEGORY").Tables[0].Copy();
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet LogOut()
    {
        ClearSession();
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = "../Default.aspx";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private void ClearSession()
    {
        Session["ID"] = null;
        Session["NAME"] = null;
        Session["PASSWORD"] = null;
        Session["ROLE"] = null;
    }

    private DataSet ModifyIsEmpty(DataSet ds)
    {
        DataTable table, table2 = ds.Tables[1].Copy(); ; DataRow row;
        table = GenerateDynamic(ds.Tables[0]); row = table.NewRow();
        foreach (DataColumn col in table.Columns)
            row[col.ColumnName] = "0";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table); DS.Tables.Add(table2);
        return DS;
    }

    private DataTable GenerateDynamic(DataTable dt)
    {
        DataColumn column;
        var table = new DataTable() { TableName = "TBDYN" };
        foreach (DataColumn col in dt.Columns)
        {
            column = new DataColumn();
            column.DataType = System.Type.GetType("System.String");
            column.ColumnName = col.ColumnName;
            table.Columns.Add(column);
        }
        return table;
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

    private DataTable generateChartTable()
    {
        DataColumn column;
        DataRow row;
        var table = new DataTable() { TableName = "OptionAdd" };
        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "VALUE";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "LABEL";
        table.Columns.Add(column);

        return table;
    }

    public DataSet ExportCategory()
    {
        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["From"].ToString()) : ""),
               To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["To"].ToString()) : ""),
               ExcelTitle = ((!string.IsNullOrEmpty(Request.QueryString["Header"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Header"].ToString()) : "CATEGORYWISE_REPORT"),
               HospitalLoc = ((!string.IsNullOrEmpty(Request.QueryString["HospitalLoc"])) ?  (Request.QueryString["HospitalLoc"].ToString()) : ""), //senthil
                  ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : ""); //senthil
        ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);
        HospitalLoc = AESEncrytDecry.DecryptStringAES(HospitalLoc);
        DataTable TblMax = GetTableMax(); DataRow row; DataSet DS = new DataSet();

        if (From != DataAccess.InvalidStr && To != DataAccess.InvalidStr && ExcelTitle != DataAccess.InvalidStr && HospitalLoc != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr)
        {
            DataTable CategoryCount = Optimize("CATEGORYWISE", DataAccess.ReportMaster("CATEGORYWISE", From, To, string.Empty, string.Empty, string.Empty, string.Empty, ServiceID, HospitalLoc)),
                      ReqtoAssign = Optimize("CATEGORYWISEASSIGNWAITTIME", DataAccess.ReportMaster("CATEGORYWISEASSIGNWAITTIME", From, To, string.Empty, string.Empty, string.Empty, string.Empty, ServiceID, HospitalLoc)),
                      AssignToStart = Optimize("CATEGORYWISEPROGRESSWAITTIME", DataAccess.ReportMaster("CATEGORYWISEPROGRESSWAITTIME", From, To, string.Empty, string.Empty, string.Empty, string.Empty, ServiceID, HospitalLoc)),
                      StartToEnd = Optimize("PERFORMANCECATEGORYWISE", DataAccess.ReportMaster("PERFORMANCECATEGORYWISE", From, To, string.Empty, string.Empty, string.Empty, string.Empty, ServiceID, HospitalLoc)),
                      RequestToEnd = Optimize("PERFORMANCETOTALCATEGORYWISE", DataAccess.ReportMaster("PERFORMANCETOTALCATEGORYWISE", From, To, string.Empty, string.Empty, string.Empty, string.Empty, ServiceID, HospitalLoc));
            if (CategoryCount.Rows.Count > 0)
            {
                GridView TmpGrid1, TmpGrid2, TmpGrid3, TmpGrid4, TmpGrid5;

                TmpGrid1 = new GridView(); TmpGrid2 = new GridView(); TmpGrid3 = new GridView(); TmpGrid4 = new GridView(); TmpGrid5 = new GridView();
                TmpGrid1.DataSource = CategoryCount; TmpGrid1.DataBind();
                TmpGrid2.DataSource = ReqtoAssign; TmpGrid2.DataBind();
                TmpGrid3.DataSource = AssignToStart; TmpGrid3.DataBind();
                TmpGrid4.DataSource = StartToEnd; TmpGrid4.DataBind();
                TmpGrid5.DataSource = RequestToEnd; TmpGrid5.DataBind();
                string style = "<style> .text { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold;font-size: 0.7em;color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;}      .Header  { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold !important;font-size: 1em !important;background-color: #174982 !important;color: white !important;font-family: Arial !important, sans-serif;text-transform: uppercase;text-decoration: none;} </script> ";

                TmpGrid1.GridLines = GridLines.Both;

                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new System.Web.UI.HtmlTextWriter(stringWrite);
                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;width:700px !important;'> TOTAL NO. OF REQUESTS RAISED UNDER EACH CATEGORY </h3> <br/>");
                if (CategoryCount.Rows.Count > 0)
                {
                    for (int i = 0; i <= TmpGrid1.HeaderRow.Cells.Count - 1; i++)
                        TmpGrid1.HeaderRow.Cells[i].CssClass = "Header";
                    foreach (GridViewRow r in TmpGrid1.Rows)
                    {
                        for (int i = 0; i <= r.Cells.Count - 1; i++)
                        {
                            r.Cells[i].HorizontalAlign = HorizontalAlign.Center;
                            r.Cells[i].CssClass = "text";
                        }
                    }
                    TmpGrid1.RenderControl(htmlWrite);
                }
                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'> AVERAGE TIME TAKEN FROM RAISING A REQUEST TO ASSIGNING </h3> <br/>");
                if (ReqtoAssign.Rows.Count > 0)
                {
                    for (int i = 0; i <= TmpGrid2.HeaderRow.Cells.Count - 1; i++)
                        TmpGrid2.HeaderRow.Cells[i].CssClass = "Header";
                    foreach (GridViewRow r in TmpGrid2.Rows)
                    {
                        for (int i = 0; i <= r.Cells.Count - 1; i++)
                        {
                            r.Cells[i].HorizontalAlign = HorizontalAlign.Center;
                            r.Cells[i].CssClass = "text";
                        }
                    }
                    TmpGrid2.RenderControl(htmlWrite);
                }
                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'> AVERAGE TIME TAKEN FROM ASSIGNING TO STARTING  </h3> <br/>");
                if (AssignToStart.Rows.Count > 0)
                {
                    for (int i = 0; i <= TmpGrid3.HeaderRow.Cells.Count - 1; i++)
                        TmpGrid3.HeaderRow.Cells[i].CssClass = "Header";
                    foreach (GridViewRow r in TmpGrid3.Rows)
                    {
                        for (int i = 0; i <= r.Cells.Count - 1; i++)
                        {
                            r.Cells[i].HorizontalAlign = HorizontalAlign.Center;
                            r.Cells[i].CssClass = "text";
                        }
                    }
                    TmpGrid3.RenderControl(htmlWrite);
                }
                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'> AVERAGE TIME TAKEN FROM STARTING TO ENDING  </h3> <br/>");
                if (StartToEnd.Rows.Count > 0)
                {
                    for (int i = 0; i <= TmpGrid4.HeaderRow.Cells.Count - 1; i++)
                        TmpGrid4.HeaderRow.Cells[i].CssClass = "Header";
                    foreach (GridViewRow r in TmpGrid4.Rows)
                    {
                        for (int i = 0; i <= r.Cells.Count - 1; i++)
                        {
                            r.Cells[i].HorizontalAlign = HorizontalAlign.Center;
                            r.Cells[i].CssClass = "text";
                        }
                    }
                    TmpGrid4.RenderControl(htmlWrite);
                }
                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'> AVERAGE TIME TAKEN FROM RAISING A REQUEST TO ENDING  </h3> <br/>");
                if (RequestToEnd.Rows.Count > 0)
                {
                    for (int i = 0; i <= TmpGrid5.HeaderRow.Cells.Count - 1; i++)
                        TmpGrid5.HeaderRow.Cells[i].CssClass = "Header";
                    foreach (GridViewRow r in TmpGrid5.Rows)
                    {
                        for (int i = 0; i <= r.Cells.Count - 1; i++)
                        {
                            r.Cells[i].HorizontalAlign = HorizontalAlign.Center;
                            r.Cells[i].CssClass = "text";
                        }
                    }
                    TmpGrid5.RenderControl(htmlWrite);
                }
                stringWrite.Write(" <br/><br/>");
                String FinalContent = style + stringWrite.ToString();
                row = TblMax.NewRow(); row["Result"] = FinalContent.ToString(); TblMax.Rows.Add(row);
                //Response.Write(style);
                //Response.Write(stringWrite.ToString());
                //Response.End();
            }
            DS.Tables.Add(TblMax);
        }
        return DS;
    }


    public DataSet Export_Timewise()
    {
        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["From"].ToString()): ""),
              To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["To"].ToString()) : ""),
              ExcelTitle = ((!string.IsNullOrEmpty(Request.QueryString["Header"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Header"].ToString()) : "TIMEWISE_REPORT"),
              CategoryValue = ((!string.IsNullOrEmpty(Request.QueryString["Category"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Category"].ToString()) : ""),
               CategoryId = CategoryValue.Split('_')[1].ToString(),
               Category = CategoryValue.Split('_')[0].ToString();
        string ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? AESEncrytDecry.DecryptStringAES( Request.QueryString["SERVICEID"].ToString()) : ""),
        HospitalLoc = ((!string.IsNullOrEmpty(Request.QueryString["HospitalLoc"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["HospitalLoc"].ToString()) : "");
        
        DataTable TblMax = GetTableMax(); DataRow row; DataSet DataSet = new DataSet();

        if (CategoryValue != DataAccess.InvalidStr && From != DataAccess.InvalidStr && To != DataAccess.InvalidStr && ExcelTitle != DataAccess.InvalidStr && HospitalLoc != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr)
        {

            DataTable PEEKHOUR = DataAccess.ReportMaster("PEEKHOUR", From, To, CategoryId, string.Empty, string.Empty, string.Empty, ServiceID, HospitalLoc),
                  HOURLYASSIGNWAIT = DataAccess.ReportMaster("HOURLYASSIGNWAIT", From, To, CategoryId, string.Empty, string.Empty, string.Empty, ServiceID, HospitalLoc),
                  HOURLYPROGRESSWAIT = DataAccess.ReportMaster("HOURLYPROGRESSWAIT", From, To, CategoryId, string.Empty, string.Empty, string.Empty, ServiceID, HospitalLoc);
            DataSet DS = new DataSet(); DS.Tables.Add(PEEKHOUR.Copy()); DS.Tables.Add(HOURLYASSIGNWAIT.Copy()); DS.Tables.Add(HOURLYPROGRESSWAIT.Copy());
            DataTable Final = Optimize(DS);
            if (PEEKHOUR.Rows.Count > 0)
            {
                GridView TmpGrid1;

                TmpGrid1 = new GridView();
                TmpGrid1.DataSource = Final; TmpGrid1.DataBind();
                string style = "<style> .text { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold;font-size: 0.7em;color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;}      .Header  { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold !important;font-size: 1em !important;background-color: #174982 !important;color: white !important;font-family: Arial !important, sans-serif;text-transform: uppercase;text-decoration: none;} </script> ";

                TmpGrid1.GridLines = GridLines.Both;

                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new System.Web.UI.HtmlTextWriter(stringWrite);
                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;width:700px !important;'> COUNT AND AVERAGE TIME TAKEN FOR " + Category + " AT EACH HOUR </h3> <br/>");
                if (PEEKHOUR.Rows.Count > 0)
                {
                    for (int i = 0; i <= TmpGrid1.HeaderRow.Cells.Count - 1; i++)
                        TmpGrid1.HeaderRow.Cells[i].CssClass = "Header";
                    foreach (GridViewRow r in TmpGrid1.Rows)
                    {
                        for (int i = 0; i <= r.Cells.Count - 1; i++)
                        {
                            r.Cells[i].HorizontalAlign = HorizontalAlign.Center;
                            r.Cells[i].CssClass = "text";
                        }
                    }
                    TmpGrid1.RenderControl(htmlWrite);
                }
                String FinalContent = style + stringWrite.ToString();
                row = TblMax.NewRow(); row["Result"] = FinalContent.ToString(); TblMax.Rows.Add(row);
                
            }
            DataSet.Tables.Add(TblMax);
        }
        return DataSet;
    }
    private DataSet ExportPorterwise()
    {
        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["From"].ToString()) : ""),
              To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["To"].ToString()) : ""),
              ExcelTitle = ((!string.IsNullOrEmpty(Request.QueryString["Header"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Header"].ToString()) : "PORTERWISE_REPORT");
        string ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["SERVICEID"].ToString()) : ""),
        HospitalLoc = ((!string.IsNullOrEmpty(Request.QueryString["HospitalLoc"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["HospitalLoc"].ToString()) : "");
         
        DataTable TblMax = GetTableMax(); DataRow row; DataSet DataSet = new DataSet();

        if (From != DataAccess.InvalidStr && To != DataAccess.InvalidStr && ExcelTitle != DataAccess.InvalidStr && HospitalLoc != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr)
        {

            DataTable PeekHourDs = DataAccess.ReportExport("PORTERPEEKHOUR", From, To),
                  PeakPerformanceDs = DataAccess.ReportExport("PORTERPERFORMANCE", From, To),
                  CategorywiseDs = DataAccess.ReportExport("PORTERCATEGORYWISE", From, To),
                  TimeWiseDs = ModifyTable(DataAccess.ReportMaster("PEEKHOUR", From, To, string.Empty, string.Empty, string.Empty, string.Empty, ServiceID, HospitalLoc)),
                  TimeWisetcpDs = DataAccess.ReportMaster("TCPEEKHOUR", From, To, string.Empty, string.Empty, string.Empty, string.Empty, ServiceID, HospitalLoc),
                  CategorywiseDsTot = ModifyCagetoryWise(DataAccess.ReportMaster("CATEGORYWISE", From, To, string.Empty, string.Empty, string.Empty, string.Empty, ServiceID, HospitalLoc));
            if (PeakPerformanceDs.Rows.Count > 0)
            {
                GridView TmpGrid, TmpGrid1, TmpGrid2, TmpGrid3, TmpGrid4, TmpGrid5;
                TmpGrid = new GridView();
                TmpGrid.DataSource = PeakPerformanceDs; TmpGrid.DataBind();

                TmpGrid1 = new GridView(); TmpGrid2 = new GridView(); TmpGrid3 = new GridView(); TmpGrid4 = new GridView(); TmpGrid5 = new GridView();
                TmpGrid1.DataSource = PeekHourDs;
                TmpGrid1.DataBind();
                TmpGrid2.DataSource = CategorywiseDs; TmpGrid2.DataBind();
                TmpGrid3.DataSource = TimeWiseDs; TmpGrid3.DataBind();
                TmpGrid4.DataSource = CategorywiseDsTot; TmpGrid4.DataBind();
                TmpGrid5.DataSource = TimeWisetcpDs; TmpGrid5.DataBind();
                string style = "<style> .text { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold;font-size: 0.7em;color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;}      .Header  { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold !important;font-size: 1em !important;background-color: #174982 !important;color: white !important;font-family: Arial !important, sans-serif;text-transform: uppercase;text-decoration: none;min-width:100px !important;max-width:200px !important;} </script> ";
                TmpGrid.GridLines = GridLines.Both;
                TmpGrid1.GridLines = GridLines.Both;


                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new System.Web.UI.HtmlTextWriter(stringWrite);
                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'> PORTER PERFORMANCE - Avge. time taken to complete a task by a porter (in minutes) at every 2 hours interval. </h3> <br/>");
                if (PeakPerformanceDs.Rows.Count > 0)
                {
                    for (int i = 0; i <= TmpGrid.HeaderRow.Cells.Count - 1; i++)
                        TmpGrid.HeaderRow.Cells[i].CssClass = "Header";
                    foreach (GridViewRow r in TmpGrid.Rows)
                    {
                        for (int i = 0; i <= r.Cells.Count - 1; i++)
                        {

                            r.Cells[i].CssClass = "text";
                        }
                    }
                    TmpGrid.RenderControl(htmlWrite);
                }
                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'>PORTER PEEK HOUR - Number of requests handled by porter at every 2 hours interval. </h3> <br/>");
                if (PeekHourDs.Rows.Count > 0)
                {
                    for (int i = 0; i <= TmpGrid1.HeaderRow.Cells.Count - 1; i++)
                        TmpGrid1.HeaderRow.Cells[i].CssClass = "Header";
                    foreach (GridViewRow r in TmpGrid1.Rows)
                    {
                        for (int i = 0; i <= r.Cells.Count - 1; i++)
                        {

                            r.Cells[i].CssClass = "text";
                        }
                    }
                    TmpGrid1.RenderControl(htmlWrite);
                }
                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'> PORTER vs CATEGORIES - Different types of movements handled by a porter </h3> <br/>");
                if (CategorywiseDs.Rows.Count > 0)
                {
                    for (int i = 0; i <= TmpGrid2.HeaderRow.Cells.Count - 1; i++)
                        TmpGrid2.HeaderRow.Cells[i].CssClass = "Header";
                    foreach (GridViewRow r in TmpGrid2.Rows)
                    {
                        for (int i = 0; i <= r.Cells.Count - 1; i++)
                        {

                            r.Cells[i].CssClass = "text";
                        }
                    }
                    TmpGrid2.RenderControl(htmlWrite);
                }
                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'> Number of requests raised at each hour interval. </h3> <br/>");
                if (TimeWiseDs.Rows.Count > 0)
                {
                    for (int i = 0; i <= TmpGrid3.HeaderRow.Cells.Count - 1; i++)
                        TmpGrid3.HeaderRow.Cells[i].CssClass = "Header";
                    foreach (GridViewRow r in TmpGrid3.Rows)
                    {
                        for (int i = 0; i <= r.Cells.Count - 1; i++)
                            r.Cells[i].CssClass = "text";
                    }
                    TmpGrid3.RenderControl(htmlWrite);
                }

                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'> Categorywise Hourly Count. </h3> <br/>");
                if (TimeWisetcpDs.Rows.Count > 0)
                {
                    for (int i = 0; i <= TmpGrid5.HeaderRow.Cells.Count - 1; i++)
                        TmpGrid5.HeaderRow.Cells[i].CssClass = "Header";
                    foreach (GridViewRow r in TmpGrid5.Rows)
                    {
                        for (int i = 0; i <= r.Cells.Count - 1; i++)
                            r.Cells[i].CssClass = "text";
                    }
                    TmpGrid5.RenderControl(htmlWrite);
                }
                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;'> Number of each type of requests raised. </h3> <br/>");
                if (CategorywiseDsTot.Rows.Count > 0)
                {
                    for (int i = 0; i <= TmpGrid4.HeaderRow.Cells.Count - 1; i++)
                        TmpGrid4.HeaderRow.Cells[i].CssClass = "Header";
                    foreach (GridViewRow r in TmpGrid4.Rows)
                    {
                        for (int i = 0; i <= r.Cells.Count - 1; i++)
                            r.Cells[i].CssClass = "text";
                    }
                    TmpGrid4.RenderControl(htmlWrite);
                }
                stringWrite.Write(" <br/><br/>");
                String FinalContent = style + stringWrite.ToString();
                row = TblMax.NewRow(); row["Result"] = FinalContent.ToString(); TblMax.Rows.Add(row);
                //Response.Write(style);
                //Response.Write(stringWrite.ToString());
                //Response.End();
            }
            DataSet.Tables.Add(TblMax);
        }
        return DataSet;
    }
    private DataSet ExportDateWise()
    {

        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["From"].ToString()) : ""),
              To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["To"].ToString()) : ""),
              Status = ((!string.IsNullOrEmpty(Request.QueryString["Status"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Status"].ToString()) : ""),
              Porter = ((!string.IsNullOrEmpty(Request.QueryString["Porter"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Porter"].ToString()): "");

        DataTable TblMax = GetTableMax(); DataRow row; DataSet DataSet = new DataSet();


        DataTable ds = null;
        if (From != DataAccess.InvalidStr && To != DataAccess.InvalidStr && Status != DataAccess.InvalidStr && Porter != DataAccess.InvalidStr)
        {
            ds = DataAccess.RequestMaster(string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, Status, string.Empty, string.Empty, string.Empty, From, To, string.Empty, "EXPORT", Porter, string.Empty, string.Empty, string.Empty);
            if (ds.Rows.Count > 0)
            {
                GridView TmpGrid = new GridView();
                TmpGrid.DataSource = ds;
                TmpGrid.DataBind();
                string style = "<style> .text { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold;font-size: 0.7em;color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;}      .Header  { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold !important;font-size: 1em !important;background-color: #174982 !important;color: white !important;font-family: Arial !important, sans-serif;text-transform: uppercase;text-decoration: none;min-width:100px !important;max-width:200px !important;} </script> ";
                TmpGrid.GridLines = GridLines.Both;
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                for (int i = 0; i <= TmpGrid.HeaderRow.Cells.Count - 1; i++)
                    TmpGrid.HeaderRow.Cells[i].CssClass = "Header";
                foreach (GridViewRow r in TmpGrid.Rows)
                {
                    for (int i = 0; i <= r.Cells.Count - 1; i++)
                    {
                        r.Cells[i].CssClass = "text";
                        if (Status != "7")
                        {
                            int index = (Status == "6") ? (r.Cells.Count - 1) : (r.Cells.Count - 2), Tindex = 8;
                            //if (r.Cells[index].Text.Replace("&nbsp;", "").Trim().Length > 0)
                            //    r.Cells[i].Attributes.Add("style", "background:#ffcccc !important;");
                            if ((r.Cells[Tindex].Text.Replace("&nbsp;", "").Trim().Length > 0) && (r.Cells[Tindex].Text.Replace("&nbsp;", "").Trim() == "YES"))
                                r.Cells[i].Attributes.Add("style", "background:rgb(217,151,149) !important;color:white;");
                        }
                    }
                }
                int cont = TmpGrid.Columns.Count;

                TmpGrid.RenderControl(htmlWrite);
                String FinalContent = style + stringWrite.ToString();
                row = TblMax.NewRow(); row["Result"] = FinalContent.ToString(); TblMax.Rows.Add(row);
            }
            else
            {
                row = TblMax.NewRow(); row["Result"] = "No Data"; TblMax.Rows.Add(row);
            }

            DataSet.Tables.Add(TblMax);
        }
        return DataSet;

    }

    private DataSet ExportDaily()
    {

        string From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["From"].ToString()) : ""),
              To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["To"].ToString()) : "");

        string ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["SERVICEID"].ToString()) : ""),
             HospitalLoc = ((!string.IsNullOrEmpty(Request.QueryString["HospitalLoc"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["HospitalLoc"].ToString()) : "");
         
        DataTable TblMax = GetTableMax(); DataRow row; DataSet DataSet = new DataSet();
        DataTable ds = null, DtIdleAvtive=null, DtPorterPerformance=null;

        if (From != DataAccess.InvalidStr && To != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr && HospitalLoc != DataAccess.InvalidStr)
        {

            ds = DataAccess.ReportMaster("GETDAILYREPORT", From, To, string.Empty, string.Empty, string.Empty, string.Empty, ServiceID, HospitalLoc);
            DtIdleAvtive = DataAccess.ReportMaster("IDLEACTIVEREPORT", From, To, string.Empty, string.Empty, string.Empty, string.Empty, ServiceID, HospitalLoc);
                      DtPorterPerformance = DataAccess.GetCategorywisePerformance(From, To);

            if (ds.Rows[0][0].ToString().ToUpper() != "FALSE")
            {
                GridView TmpGrid = new GridView(), TmpGrid1 = new GridView(), TmpGrid2 = new GridView();
                TmpGrid.DataSource = ds; TmpGrid1.DataSource = DtIdleAvtive; TmpGrid2.DataSource = DtPorterPerformance;
                TmpGrid.DataBind(); TmpGrid1.DataBind(); TmpGrid2.DataBind();
                string style = "<style> .text { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold;font-size: 0.7em;color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;}      .Header  { mso-number-format:\"" + @"\@" + "\"" + ";font-weight:bold !important;font-size: 1em !important;background-color: #174982 !important;color: white !important;font-family: Arial !important, sans-serif;text-transform: uppercase;text-decoration: none;min-width:100px !important;max-width:200px !important;} </script> ";
                TmpGrid.GridLines = GridLines.Both;
                System.IO.StringWriter stringWrite = new System.IO.StringWriter();
                System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;width:700px !important;'> NUMBER OF REQUESTS AND PORTERS AVAILABLE AT EACH HOUR  </h3> <br/>");
                for (int i = 0; i <= TmpGrid.HeaderRow.Cells.Count - 1; i++)
                    TmpGrid.HeaderRow.Cells[i].CssClass = "Header";
                foreach (GridViewRow r in TmpGrid.Rows)
                {
                    for (int i = 0; i <= r.Cells.Count - 1; i++)
                    {
                        r.Cells[i].CssClass = "text";
                        if (r.Cells[0].Text.Replace("&nbsp;", "").Trim() == "TOTAL NO OF CALLS")
                            r.Cells[i].Attributes.Add("style", "background:#d7d7d7 !important;");
                        if (r.Cells[0].Text.Replace("&nbsp;", "").Trim() == "TOTAL NO OF PORTERS")
                            r.Cells[i].Attributes.Add("style", "background:#d7d7d7 !important;");
                    }
                }

                int cont = TmpGrid.Columns.Count;

                TmpGrid.RenderControl(htmlWrite);

                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;width:700px !important;'> WORKING EFFICIENCY OF PORTERS  </h3> <br/>");
                for (int i = 0; i <= TmpGrid1.HeaderRow.Cells.Count - 1; i++)
                    TmpGrid1.HeaderRow.Cells[i].CssClass = "Header";
                foreach (GridViewRow r in TmpGrid1.Rows)
                {
                    for (int i = 0; i <= r.Cells.Count - 1; i++)
                        r.Cells[i].CssClass = "text";
                }
                TmpGrid1.RenderControl(htmlWrite);
                stringWrite.Write(" <br/><br/> <h3 style='color: #1C589D;font-family: Arial, sans-serif;text-transform: uppercase;text-decoration: none;width:700px !important;'> PORTER vs CATEGORIES - Avge. time taken to complete a task by a porter (in minutes).  </h3> <br/>");
                for (int i = 0; i <= TmpGrid2.HeaderRow.Cells.Count - 1; i++)
                    TmpGrid2.HeaderRow.Cells[i].CssClass = "Header";
                foreach (GridViewRow r in TmpGrid2.Rows)
                {
                    for (int i = 0; i <= r.Cells.Count - 1; i++)
                        r.Cells[i].CssClass = "text";
                }
                TmpGrid2.RenderControl(htmlWrite);

                String FinalContent = style + stringWrite.ToString();
                row = TblMax.NewRow(); row["Result"] = FinalContent.ToString(); TblMax.Rows.Add(row);
            }
            DataSet.Tables.Add(TblMax);
        }
        return DataSet;

    }

    private DataTable ModifyCagetoryWise(DataTable ds)
    {
        DataTable nds = ds.Copy(), FDS; DataRow row; int TOTAL = ((ds.Rows.Count > 0) ? Convert.ToInt32(ds.Rows[0]["TOTAL"].ToString()) : 0);
        nds.Columns["STATUS"].ColumnName = "REQUEST CATEGORY";
        nds.Columns["CNT"].ColumnName = "NO. OF REQUESTS";
        nds.Columns.Remove("TOTAL");
        FDS = nds.Copy();
        row = FDS.NewRow();
        row["REQUEST CATEGORY"] = "TOTAL";
        row["NO. OF REQUESTS"] = TOTAL;
        FDS.Rows.Add(row);
        return FDS;
    }
    private DataTable ModifyTable(DataTable ds)
    {
        DataTable nds = ds.Copy();
        DataTable table = GenarateTable();
        DataRow row; bool start = true; int TotalRequest = 0;
        foreach (DataRow drow in nds.Rows)
        {
            foreach (DataColumn dcol in nds.Columns)
            {
                row = table.NewRow();
                row["REQUEST TIME"] = dcol.ColumnName.ToUpper();
                row["NO. OF REQUESTS"] = drow[dcol.ColumnName];
                if (dcol.ColumnName != "CATEGORYNAME")
                    TotalRequest += Convert.ToInt32(row["NO. OF REQUESTS"].ToString());
                table.Rows.Add(row);

            }
            row = table.NewRow();
            row["REQUEST TIME"] = "TOTAL ";
            row["NO. OF REQUESTS"] = TotalRequest;
            table.Rows.Add(row);
        }
        return table;

    }


    private DataTable GenarateTable()
    {
        DataColumn column;
        DataRow row;
        var table = new DataTable() { TableName = "OptionAdd" };
        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "REQUEST TIME";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "NO. OF REQUESTS";
        table.Columns.Add(column);

        return table;
    }
    private DataTable generateTimeTable()
    {
        DataColumn column;
        DataRow row;
        var table = new DataTable() { TableName = "OptionAdd" };
        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "PROCESS";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(6 AM - 7 AM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(7 AM - 8 AM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(8 AM - 9 AM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(9 AM - 10 AM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(10 AM - 11 AM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(11 AM - 12 PM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(12 PM - 1 PM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(1 PM - 2 PM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(2 PM - 3 PM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(3 PM - 4 PM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(4 PM - 5 PM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(5 PM - 6 PM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(6 PM - 7 PM)";
        table.Columns.Add(column);
        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(7 PM - 8 PM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(8 PM - 9 PM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "(9 PM - 10 PM)";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "AVERAGE ( OVERALL )";
        table.Columns.Add(column);

        return table;
    }

    private DataTable Optimize(DataSet DataSet)
    {
        DataTable table = generateTimeTable(); DataRow row;
        foreach (DataTable dataTable in DataSet.Tables)
        {
            decimal value = 0, count = 0; string Type = dataTable.TableName;
            foreach (DataRow drow in dataTable.Rows)
            {
                if (Type != "PEEKHOUR")
                {
                    foreach (DataColumn dcol in dataTable.Columns)
                    {
                        value += Convert.ToDecimal(drow[dcol.ColumnName]);
                        count += (Convert.ToDecimal(drow[dcol.ColumnName]) > 0) ? 1 : 0;
                    }

                }
                row = table.NewRow();
                row["PROCESS"] = (Type == "PEEKHOUR") ? " NO. OF REQUESTS " : (Type == "HOURLYASSIGNWAIT") ? "REQ - ASSIGN ( AVG MINUTES)" : "ASSIGN - START ( AVG MINUTES)";
                row["(6 AM - 7 AM)"] = drow["(6 AM - 7 AM)"].ToString();
                row["(7 AM - 8 AM)"] = drow["(7 AM - 8 AM)"].ToString();
                row["(8 AM - 9 AM)"] = drow["(8 AM - 9 AM)"].ToString();
                row["(9 AM - 10 AM)"] = drow["(9 AM - 10 AM)"].ToString();
                row["(10 AM - 11 AM)"] = drow["(10 AM - 11 AM)"].ToString();
                row["(11 AM - 12 PM)"] = drow["(11 AM - 12 PM)"].ToString();
                row["(12 PM - 1 PM)"] = drow["(12 PM - 1 PM)"].ToString();
                row["(1 PM - 2 PM)"] = drow["(1 PM - 2 PM)"].ToString();
                row["(2 PM - 3 PM)"] = drow["(2 PM - 3 PM)"].ToString();
                row["(3 PM - 4 PM)"] = drow["(3 PM - 4 PM)"].ToString();
                row["(4 PM - 5 PM)"] = drow["(4 PM - 5 PM)"].ToString();
                row["(5 PM - 6 PM)"] = drow["(5 PM - 6 PM)"].ToString();
                row["(6 PM - 7 PM)"] = drow["(6 PM - 7 PM)"].ToString();
                row["(7 PM - 8 PM)"] = drow["(7 PM - 8 PM)"].ToString();
                row["(8 PM - 9 PM)"] = drow["(8 PM - 9 PM)"].ToString();
                row["(9 PM - 10 PM)"] = drow["(9 PM - 10 PM)"].ToString();
                row["(9 PM - 10 PM)"] = drow["(9 PM - 10 PM)"].ToString();
                row["AVERAGE ( OVERALL )"] = (Type == "PEEKHOUR") ? "-" : ((count > 0) ? value / count : 0).ToString("#.##");
                table.Rows.Add(row);
            }
        }
        return table;
    }
    private DataTable generateChartTable(string Type)
    {
        DataColumn column;
        DataRow row;
        var table = new DataTable() { TableName = "OptionAdd" };
        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = "CATEGORY OF MOVEMENTS";
        table.Columns.Add(column);

        column = new DataColumn();
        column.DataType = System.Type.GetType("System.String");
        column.ColumnName = (Type == "CATEGORYWISE") ? "NO. OF REQUESTS" : "AVERAGE TIME TAKEN IN MINUTES";
        table.Columns.Add(column);

        return table;
    }

    private DataTable Optimize(string Type, DataTable dataTable)
    {
        DataTable table = generateChartTable(Type); DataRow row;
        if (dataTable.Rows.Count == 0)
            SetCatEmpty(table, Type);
        else
        {
            foreach (DataRow drow in dataTable.Rows)
            {
                row = table.NewRow();
                row[(Type == "CATEGORYWISE") ? "NO. OF REQUESTS" : "AVERAGE TIME TAKEN IN MINUTES"] = drow["CNT"];
                row["CATEGORY OF MOVEMENTS"] = drow["STATUS"].ToString();
                table.Rows.Add(row);
            }
        }
        return table;
    }
    private DataTable SetCatEmpty(DataTable tbl, string Type)
    {
        DataTable dtCat = DataAccess.CategoryMaster(string.Empty, string.Empty, string.Empty, false, "GET"); DataRow row;

        foreach (DataRow drow in dtCat.Rows)
        {
            row = tbl.NewRow();
            row[(Type == "CATEGORYWISE") ? "NO. OF REQUESTS" : "AVERAGE TIME TAKEN IN MINUTES"] = "0";
            row["CATEGORY OF MOVEMENTS"] = drow["STATUS"].ToString();
            tbl.Rows.Add(row);
        }
        return tbl;
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

    private DataSet SearchRG()
    {
        DataSet DS = new DataSet();
        var sb = new StringBuilder();
        string Value = ((!string.IsNullOrEmpty(Request.QueryString["VALUE"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["VALUE"].ToString()) : ""),
               SelectedDepts = ((!string.IsNullOrEmpty(Request.QueryString["SELECTEDIDS"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["SELECTEDIDS"].ToString()) : "");

        if (Value != DataAccess.InvalidStr && SelectedDepts != DataAccess.InvalidStr)
        {
            HtmlTable Tmptable = new HtmlTable() { Width = "90%" }; Tmptable.Attributes.Add("style", "margin-left:10%;"); Tmptable.Attributes.Add("class", "ZoneLocation");
            DataTable DtSearchedLocations = new DataTable();
            if (!string.IsNullOrEmpty(Value))
            {
                DtSearchedLocations = DataAccess.GetRecords("SP_SEARCH_DEPT", "@VALUE", Value, "@SELECTEDVAL", SelectedDepts); //DataAccess.GetRecords("SP_SEARCHUSER_DEPT", "@USERNAME", User, "@DEPTID", DeptID);
                foreach (DataRow dr in DtSearchedLocations.Rows)
                {

                    string BindFunction = "BindDept('" + dr["Id"] + "','" + dr["LOCATION"].ToString().Trim().ToUpper() + "')";
                    HtmlTableRow tr = new HtmlTableRow(); HtmlTableCell tc = new HtmlTableCell() { Align = "left" }; RadioButton RBtn = new RadioButton() { ID = "LocDept_" + dr["Id"].ToString(), Text = dr["LOCATION"].ToString().Trim().ToUpper(), ClientIDMode = ClientIDMode.Static, GroupName = dr["LOCATION"].ToString() };
                    RBtn.Attributes.Add("onclick", BindFunction);
                    RBtn.Attributes.Add("style", "font-family: monospace;font-weight: bold;color: rgb(30, 70, 129);padding:8px;font-size: 14px;");
                    tr.Controls.Add(tc); tc.Controls.Add(RBtn); Tmptable.Controls.Add(tr);
                }
            }
            Tmptable.RenderControl(new HtmlTextWriter(new StringWriter(sb)));
            DataTable table = generate();
            DataRow row = table.NewRow();
            row["RESULT"] = sb.ToString();
            table.Rows.Add(row);
            DS.Tables.Add(table);
        }
        return DS;
    }
        
    
    /* Report End */
}