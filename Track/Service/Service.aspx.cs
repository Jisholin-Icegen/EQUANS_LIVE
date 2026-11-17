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
using System.Web.Services.Description;
using ClientsideEncryption;

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
        DataSet data = new DataSet();
        process = ((!string.IsNullOrEmpty(AESEncrytDecry.DecryptStringAES(Request.QueryString["Process"]))) ? Request.QueryString["Process"].ToString().ToUpper() : "");
        switch (process)
        {
            case "PORTERWITHLOCAITON":
                data = GetPorterLocation();
                break;
            case "GETFLOOR":
                data.Tables.Add(DataLayer.SGetBranches(string.Empty, "FLOOR"));
                break;
            case "BREAK":
                data = SetBreak();
                break;
            case "UNAVAILABLE":
                data = SetUnAvailable();
                break;
            case "RELEASEPORTER":
                data = ReleasePorter();
                break;
            case "SHIFTEND":
                data = DaLogout();
                break;
            case "BUZZER":
                data = Buzzer();
                break;
            case "BUZZERALL":
            case "SENDMESSAGEALL":
                data = BroadCasting();
                break;
            case "SENDMESSAGE":
                data = SendMessage();
                break;
            case "SETENDTIME":
                data = SetEndTime();
                break;

            case "PRESET":
                data = PresetOperations();
                break;
            case "LOGOUT":
                data = LogOut();
                break;

        }
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


    private DataSet GetPorterLocation()
    {
        string Name = ((!string.IsNullOrEmpty(Request.QueryString["NAME"])) ? Request.QueryString["NAME"].ToString().ToUpper() : ""),
            ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : "");
        ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);


        DataTable table = new DataTable();
        table = DataAccess.PorterMasterGL(null, string.Empty, Name, string.Empty, string.Empty, false, "GETWITHLOCAITON", ServiceID).Copy();
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet SetUnAvailable()
    {
        string PId = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID"])) ? Request.QueryString["PORTERID"].ToString().ToUpper() : "");
        DataTable dt = DataAccess.PorterMaster(null, PId, string.Empty, string.Empty, string.Empty, false, "UNAVAILABLE");
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = dt.Rows[0]["RESULT"].ToString().ToUpper();
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;

    }

    private DataSet ReleasePorter()
    {
        string PId = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID"])) ? Request.QueryString["PORTERID"].ToString().ToUpper() : "");
        string ReqId = ((!string.IsNullOrEmpty(Request.QueryString["REQID"])) ? Request.QueryString["REQID"].ToString().ToUpper() : "0");
        DataTable dt = DataLayer.ReleasePorter(PId, ReqId);
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = dt.Rows[0]["RESULT"].ToString().ToUpper();
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;

    }


    private DataSet SetBreak()
    {
        string PId = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID"])) ? Request.QueryString["PORTERID"].ToString().ToUpper() : "");
        DataTable dt = DataAccess.PorterMaster(null, PId, string.Empty, string.Empty, string.Empty, false, "BREAK");
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = dt.Rows[0]["RESULT"].ToString().ToUpper();
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;

        /*  string PId = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID"])) ? Request.QueryString["PORTERID"].ToString().ToUpper() : ""),
             TagId = ((!string.IsNullOrEmpty(Request.QueryString["TAGID"])) ? Request.QueryString["TAGID"].ToString().ToUpper() : ""),
             process = ((!string.IsNullOrEmpty(Request.QueryString["Process"])) ? Request.QueryString["Process"].ToString().ToUpper() : "");
          //DataTable dt = DataAccess.PorterMaster(null, PId, string.Empty, string.Empty, string.Empty, false, "BREAK");

          DataTable dt = DataAccess.GetRecords("SP_SETBREAK", "@PORTERID", PId, "@TAGID", TagId, "@PROCESS", process);
          DataTable table = generate();
          DataRow row = table.NewRow();
          row["RESULT"] = dt.Rows[0]["RESULT"].ToString().ToUpper();
          table.Rows.Add(row);
          DataSet DS = new DataSet(); DS.Tables.Add(table);
          return DS; */
    }

    public void InsertError(string ErrMsg, string SpName)
    {
        SqlConnection TmpCon = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_ERRORLOG", TmpCon);
        cmd.Parameters.AddWithValue("@PROC", SpName);
        cmd.Parameters.AddWithValue("@ERRORMSG", ErrMsg);
        cmd.CommandType = CommandType.StoredProcedure;
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        if (TmpCon.State == ConnectionState.Closed)
            TmpCon.Open();
        cmd.ExecuteNonQuery();
        TmpCon.Close();
    }
    private DataSet DaLogout()
    {
        string PId = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID"])) ? Request.QueryString["PORTERID"].ToString().ToUpper() : "");

        DataSet dt = new DataSet();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_Logout", Con);
            cmd.Parameters.AddWithValue("@UserId", PId);
            cmd.Parameters.AddWithValue("@Process", "ENDSHIFT");
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            cmd.CommandType = CommandType.StoredProcedure;
            Con.Open();
            adpt.Fill(dt);

            DataTable table = generate();
            DataRow row = table.NewRow();

            row["RESULT"] = dt.Tables[0].Rows[0]["RESULT"].ToString();

            table.Rows.Add(row);
            DataSet DS = new DataSet(); DS.Tables.Add(table);
            return DS;
        }
        catch (Exception ex) { DataAccess.InsertError(ex.Message, "DaLogout"); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    private DataSet ShiftEnd()
    {
        string TagId = ((!string.IsNullOrEmpty(Request.QueryString["TAGID"])) ? Request.QueryString["TAGID"].ToString().ToUpper() : "");
        bool Result = (DataAccess.TagMaster(process, TagId, string.Empty, false).Rows[0]["RESULT"].ToString() == "TRUE");
        DataTable table = generate();
        DataRow row = table.NewRow();
        if (Result)
            row["RESULT"] = "TRUE";
        else
            row["RESULT"] = "FALSE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet BroadCasting()
    {
        string Process = ((!string.IsNullOrEmpty(AESEncrytDecry.DecryptStringAES(Request.QueryString["Process"]))) ? Request.QueryString["Process"].ToString().ToUpper() : ""),
            Message = ((!string.IsNullOrEmpty(Request.QueryString["MESSAGE"])) ? Request.QueryString["MESSAGE"].ToString().ToUpper() : "").Replace("~", "and").Replace("^", "?"); ;
        EkahauClass buz = new EkahauClass();
        DataTable dt = DataAccess.PorterMaster(null, string.Empty, string.Empty, string.Empty, string.Empty, false, "GETWITHLOCAITON");
        foreach (DataRow dr in dt.Rows)
        {
            if (dr["TAGID"].ToString().Length == 0) continue;
            if (Process == "BUZZERALL")
                buz.buzzerCommand(dr["TAGID"].ToString());
            /* else
                 DataAccess.SendMessage(dr["TAGID"].ToString(), Message); */
        }

        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = "TRUE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet BuzzerTags()
    {
        string TagIds = ((!string.IsNullOrEmpty(Request.QueryString["TagIds"])) ? Request.QueryString["TagIds"].ToString().ToUpper() : "");
        EkahauClass buz = new EkahauClass();
        foreach (string TagId in TagIds.Split('_'))
        {
            if (TagId.Trim().Length == 0) continue;
            buz.buzzerCommand(TagId.Trim());
        }
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = "TRUE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    public DataSet Buzzer()
    {
        string TagId = ((!string.IsNullOrEmpty(Request.QueryString["TAGID"])) ? Request.QueryString["TAGID"].ToString().ToUpper() : "");
                  //ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString().ToUpper() : "");

        //ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);
        /* EkahauClass buz = new EkahauClass();
         buz.buzzerCommand(TagId);*/
        DataAccess.GetUpdateBuzzer("0", TagId, "4");
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = "TRUE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet SendMessage()
    {
        //if (dt1.Rows.Count > 0) // Message 

        string DeviceId = ((!string.IsNullOrEmpty(Request.QueryString["DeviceId"])) ? Request.QueryString["DeviceId"].ToString().ToUpper() : ""),
            Message = ((!string.IsNullOrEmpty(Request.QueryString["MESSAGE"])) ? Request.QueryString["MESSAGE"].ToString().ToUpper() : "").Replace("~", "and").Replace("^", "?"),
        userid = ((!string.IsNullOrEmpty(Request.QueryString["UserId"])) ? Request.QueryString["UserId"].ToString().ToUpper() : ""),
                 porterId = ((!string.IsNullOrEmpty(Request.QueryString["PorterId"])) ? Request.QueryString["PorterId"].ToString().ToUpper() : ""),
                 prevReqId = ((!string.IsNullOrEmpty(Request.QueryString["PREREQID"])) ? Request.QueryString["PREREQID"].ToString().ToUpper() : ""),
                 prevReqNo = ((!string.IsNullOrEmpty(Request.QueryString["PREREQNO"])) ? Request.QueryString["PREREQNO"].ToString().ToUpper() : ""),
                  mode = ((!string.IsNullOrEmpty(Request.QueryString["Mode"])) ? Request.QueryString["Mode"].ToString().ToUpper() : ""),
                  ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : "");

            ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);


        DataAccess.SendMessageNew(DeviceId, Message, userid, porterId, prevReqId, prevReqNo, mode,ServiceID);

        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = "TRUE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet SetEndTime()
    {
        //if (dt1.Rows.Count > 0) // Message 

        string PId = ((!string.IsNullOrEmpty(Request.QueryString["PID"])) ? Request.QueryString["PID"].ToString().ToUpper() : ""),
            EndTime = ((!string.IsNullOrEmpty(Request.QueryString["ENDTIME"])) ? Request.QueryString["ENDTIME"].ToString().ToUpper() : ""),
            Result = string.Empty;
        Result = (DataAccess.GetRecords("SP_UPDATEBREAKENDTIME", "@PORTERID", PId, "@ENDTIME", EndTime)).Rows[0]["RESULT"].ToString();

        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = Result;
        table.Rows.Add(row);
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
    public DataSet PresetOperations()
    {
        string Process = ((!string.IsNullOrEmpty(Request.QueryString["ACTION"])) ? Request.QueryString["ACTION"].ToString().ToUpper() : "");
        DataTable dt = DataAccess.PersetMaster("SP_PRESETMASTER", string.Empty, string.Empty, string.Empty, Process, "1").Tables[0];

        DataSet DS = new DataSet(); DS.Tables.Add(dt.Copy());
        return DS;
    }
    private void setSession(string Role)
    {
        Session["ID"] = Role.Split('_')[0].ToString();
        Session["NAME"] = Role.Split('_')[1].ToString();
        Session["PASSWORD"] = Role.Split('_')[2].ToString();
        Session["ROLE"] = Role.Split('_')[3].ToString();
    }
    private DataSet UpdatePassword()
    {
        string password = ((!string.IsNullOrEmpty(Request.QueryString["PWD"])) ? Request.QueryString["PWD"].ToString() : ""),
               id = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString().ToUpper();
        bool result = (DataAccess.UserMaster(id, string.Empty, string.Empty, password, string.Empty, true, "UPDATE").Rows[0]["RESULT"].ToString() == "TRUE");
        DataTable table = generate();
        DataRow row = table.NewRow();
        if (result)
            row["RESULT"] = "TRUE";
        else
            row["RESULT"] = "FALSE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

}