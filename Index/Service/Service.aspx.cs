using ClientsideEncryption;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Http;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.Services.Description;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Telerik.Web;
using Telerik.Web.UI.Chat;
using Telerik.Web.UI.ExportInfrastructure;

public partial class Index_Service_Service : System.Web.UI.Page
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

        string process = Request.QueryString["Process"] ?? "";

        if (!string.IsNullOrEmpty(process) && IsEncryptedString(process))
            process = AESEncrytDecry.DecryptStringAES(process);


        switch (process)
        {

            case "GetHoldReasons":
                data = GetHoldReasonsDataSet();
                break;
            case "SETONHOLDTASKS":
                HandleOnHoldTasks();
                break;
            case "RELEASEONHOLD":
                HandleReleaseOnHold();
                break;
            case "COPYTASK":
                HandleCopyTask();
                break;
            case "UpdatePorterAssignment":
                HandleUpdatePorterAssignment();
                break;
            case "CANCELREQUEST":
                HandleCancelTask();
                break;
            case "GetCancelReasons":
                data = GetCancelReasonsDataSet();
                break;
            case "ASSIGNPORTER":
                AssignPorterHandler();
                break;
            case "ChangePassword":
                HandleChangePassword();
                return;
            case "getPendingRequests":
                HandleGetPendingRequests();
                break;
            case "GETFILTEROPTIONS":
                HandleGetFilterOptions();
                break;
            case "GETSTARTFILTEROPTIONS":
                HandleGetStartFilterOptions();
                break;
            case "GETEMPLOYEEFILTEROPTIONS":
                HandleGetEmployeeFilterOptions();
                break;
            case "GETFILTEREDEMPLOYEES":
                HandleGetFilteredEmployees();
                break;
            case "TriggerCheckIn":
                HandleTriggerCheckIn();
                break;
            case "TriggerCheckOut":
                HandleTriggerCheckOut();
                break;
            case "TriggerPorterBreak":
                HandleTriggerPorterBreak();
                break;
            case "TriggerPorterMealBreak":
                HandleTriggerPorterMealBreak();
                break;
            case "EndRestBreak":
                HandleEndRestBreak();
                break;
            case "EndMealBreak":
                HandleEndMealBreak();
                break;
            case "SENDMESSAGE":
                {
                    string jsonString;
                    using (var reader = new StreamReader(HttpContext.Current.Request.InputStream))
                    {
                        jsonString = reader.ReadToEnd();
                    }

                    var requestData = new JavaScriptSerializer().Deserialize<Dictionary<string, string>>(jsonString);

                    int porterId = int.Parse(AESEncrytDecry.DecryptStringAES(requestData["porterId"]));
                    int userId = int.Parse(AESEncrytDecry.DecryptStringAES(requestData["userId"]));
                    string message = AESEncrytDecry.DecryptStringAES(requestData["message"]);
                    int porterServiceId = int.Parse(AESEncrytDecry.DecryptStringAES(requestData["serviceId"]));

                    string result = SendMessageToPorterHandler(porterId, userId, message, porterServiceId);

                    HttpContext.Current.Response.Clear();
                    HttpContext.Current.Response.ContentType = "application/json";
                    HttpContext.Current.Response.Write(new JavaScriptSerializer().Serialize(new { d = result }));
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                }
                break;
            case "TriggerPorterBreakFilter":
                HandleTriggerPorterBreakFilter();
                break;
            case "TriggerPorterMealBreakFilter":
                HandleTriggerPorterMealBreakFilter();
                break;
            case "GetPendingTasks":
                HandleGetPendingTasks();
                return;
            case "GetAssistantRequests":
                HandleGetAssistantRequests();
                return;
            case "GetUserRequests":
                DataSet ds = GetUserRequestsDataSet(Request.InputStream);
                string jsonArray = JsonConvert.SerializeObject(ds.Tables[0]);
                Context.Response.ContentType = "application/json";
                Context.Response.Write("{ \"d\": " + jsonArray + " }");
                Context.Response.End();
                break;
            case "GetSingleRequestDetails":
                {
                    Response.ContentType = "application/json";
                    string encryptedProcess = Request.QueryString["Process"] ?? "";
                    string requestId1 = Request.QueryString["requestId"] ?? "";
                    string decryptedProcess = DecryptString(encryptedProcess) ?? "";
                    if (!string.Equals(decryptedProcess, "GetSingleRequestDetails", StringComparison.Ordinal) ||
                        string.IsNullOrEmpty(requestId1))
                    {
                        Response.Write("{\"error\":\"Invalid process or requestId missing\"}");
                        Response.End();
                        return;
                    }
                    string jsonResult = GetSingleRequestDetails(requestId1);
                    Response.Write(jsonResult);
                    Response.End();
                    return;
                }
            case "GetResponseFailuresReasons":
                data = GetResponseFailuresReasonsDataSet();
                break;
            case "SetResponseFailure":
                string encRequestId = HttpContext.Current.Request["requestId"] ?? "";
                string encReason = HttpContext.Current.Request["reason"] ?? "";
                string requestId = DecryptString(encRequestId);
                string reason = encReason;
                data = SetResponseFailureDataSet(requestId, reason);
                break;
            case "PRESET":
                data = PresetOperations();
                break;
            case "MULTITASK":
                data = MultiAssign();
                break;
            case "GETPATIENTNAME":
                data = GetPatientName();
                break;

            case "GETDEPTIDLEPORTERS":
                data = GetDeptIdlePorters();
                break;
            case "GETSEARCHEDLOCATIOND":
                data = GetSearchedLocationD();
                break;
            case "GETREQUESTLOCCATRECORDS":
                data = GetRequestLocCatRecords();
                break;
            case "GETCATEGORIES":
                data = GetCategories();
                break;
            case "GETCATEGORIESSCHD":
                data = GetCategoriesBF();
                break;
            case "GETMASTERRECORD":
                data = GetMasterRecords();
                break;
            case "CLEARMANUALASSIGN":
                data = ClearManualAssign();
                break;
            case "GETSEARCHEDLOCATION":
                data = GetSearchedLocation();
                break;
            case "ALERTPROCESS":
                data = AlertProcess();
                break;
            case "BUZZERALERT":
                data = BuzzerTags();
                break;
            case "STATUSUPDATE":
                data = UpdateRecords();
                break;
            case "ONHOLDTASK":
                data = OnHoldTask();
                break;
            case "GETCATEGORY":
                data = GetCategory();
                break;
            case "GETEQUIPMENT":
                data = GetEquipment();
                break;
            case "RESUMEONHOLDTASK":
                data = ResumeTask();
                break;
            case "COMPLETETASK":
                HandleCompleteTask();
                break;
            case "UPDATELOCATION":
                data = upldateLocation();
                break;
            case "ADDCOMPLETEREMARKS":
                data = AddcompleteRemarks();
                break;
            case "STARTTASK":
                data = startTask();
                break;
            case "GETPOPUPDETAILS":
                data = GetPopupDetails();
                break;
            case "GETPORTERDETAILS":
                data = GetPorterDetails();
                break;
            case "GETETA":
                data = GetETA();
                break;
            case "GETPENDINGREQUESTS":
                data = GetPendingRequest();
                break;
                ;
            case "INSERT":
                data = InsertRequest();
                break;
            case "GETFLOOR":
                data.Tables.Add(DataAccess.FloorMaster(string.Empty, string.Empty, false, "GET"));
                break;
            case "GETLOCATION":
                data = GetLocationRecords();
                break;
            case "CHECKUSER":
                data = CheckUser();
                break;
            case "GET":
                data = GetRecords();
                break;
            case "GETPORTERID":
                data = GetPorterID();
                break;
            case "ASSIGN":
            case "MULTIASSIGN":
                data = AssignTask();
                break;

            case "PRIORITY":
                data = SetPriority();
                break;
            case "INSERTREQUEST":
                data = NewRequest();
                break;

            case "DUPLICATEREQUEST":
                data = DuplicateRquest();
                break;
            case "GETPORTERSTATUS":
                data = GetPorterStatus();
                break;

            case "GETMTPORTERS":
                data = MTPorters();
                break;

            case "fetchEquipment":
                GetEquipmentData();
                break;
            case "fetchEmployees":
                {
                    string encryptedFilter = HttpContext.Current.Request["filter"] ?? "";
                    string encryptedServiceId = HttpContext.Current.Request["serviceId"] ?? "";
                    string encryptedSortOrder = HttpContext.Current.Request["sortOrder"] ?? "asc";

                    string filter = AESEncrytDecry.DecryptStringAES(encryptedFilter);
                    int serviceId = 0;
                    if (!string.IsNullOrEmpty(encryptedServiceId))
                    {
                        int.TryParse(AESEncrytDecry.DecryptStringAES(encryptedServiceId), out serviceId);
                    }
                    string sortOrder = AESEncrytDecry.DecryptStringAES(encryptedSortOrder);

                    if (string.IsNullOrEmpty(filter)) filter = "";
                    if (string.IsNullOrEmpty(sortOrder)) sortOrder = "asc";

                    GetEmployeeData(filter, serviceId.ToString(), sortOrder, HttpContext.Current);
                    break;
                }

            case "GetEmployeeDataAssign":
                string encFilter = HttpContext.Current.Request["filter"] ?? "";
                string encServiceId = HttpContext.Current.Request["serviceId"] ?? "";
                encFilter = HttpUtility.UrlDecode(encFilter);
                encServiceId = HttpUtility.UrlDecode(encServiceId);
                string filter1 = "";
                string serviceId1 = "";
                try
                {
                    if (!string.IsNullOrEmpty(encFilter))
                    {
                        filter1 = AESEncrytDecry.DecryptStringAES(encFilter);
                    }
                }
                catch
                {
                    filter1 = "";
                }
                try
                {
                    if (!string.IsNullOrEmpty(encServiceId))
                    {
                        serviceId1 = AESEncrytDecry.DecryptStringAES(encServiceId);
                    }
                }
                catch
                {
                    serviceId1 = "";
                }

                GetEmployeeDataAssign(filter1, serviceId1);
                break;        
        }

                ResponseWrite(data);
    }

    private void WriteJson(object obj)
{
    string json = JsonConvert.SerializeObject(obj);
    Response.ContentType = "application/json";
    Response.Write(json);
    Response.End();
}

    public static string DecryptString(string cipherText)
    {
        if (string.IsNullOrEmpty(cipherText))
            return string.Empty;

        try
        {
            if (!IsValidBase64(cipherText))
            {
                return string.Empty;
            }

            string key = "9090909090909090";
            string iv = "9090909090909090";

            string decoded = HttpUtility.UrlDecode(cipherText);

            decoded = decoded.PadRight(decoded.Length + (4 - decoded.Length % 4) % 4, '=');

            byte[] cipherBytes;
            try
            {
                cipherBytes = Convert.FromBase64String(decoded);
            }
            catch
            {
                return string.Empty; 
            }

            if (cipherBytes.Length < 16)
            {
                return string.Empty; 
            }

            using (Aes aes = Aes.Create())
            {
                aes.Key = Encoding.UTF8.GetBytes(key);
                aes.IV = Encoding.UTF8.GetBytes(iv);
                aes.Mode = CipherMode.CBC;
                aes.Padding = PaddingMode.PKCS7;

                using (var decryptor = aes.CreateDecryptor())
                using (var ms = new MemoryStream(cipherBytes))
                using (var cs = new CryptoStream(ms, decryptor, CryptoStreamMode.Read))
                using (var sr = new StreamReader(cs))
                {
                    return sr.ReadToEnd();
                }
            }
        }
        catch
        {
            return string.Empty;
        }
    }

    private static bool IsValidBase64(string base64String)
    {
        if (string.IsNullOrEmpty(base64String))
            return false;

        if (base64String.Length % 4 != 0)
            return false;

        string base64Pattern = @"^[a-zA-Z0-9\+/]*={0,3}$";
        return System.Text.RegularExpressions.Regex.IsMatch(base64String, base64Pattern);
    }

    public static int DecryptInt(string cipherText)
    {
        string decrypted = DecryptString(cipherText).Trim();
        int result;
        if (!int.TryParse(decrypted, out result))
            throw new FormatException("Invalid integer value after decryption: " + decrypted);
        return result;
    }
    private bool IsEncryptedString(string str)
    {
        if (string.IsNullOrWhiteSpace(str)) return false;

        if (str.Length < 16) return false;

        return true;
    }
    public DataSet GetHoldReasonsDataSet()
    {
        List<string> holdReasons = new List<string>();
        string connStr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

        using (SqlConnection con = new SqlConnection(connStr))
        {
            using (SqlCommand cmd = new SqlCommand("dbo.SP_GETTASKREASONS", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Category", "Hold reasons");

                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        holdReasons.Add(reader["Name"].ToString());
                    }
                }
            }
        }

        DataTable table = new DataTable();
        table.Columns.Add("HoldReason", typeof(string));

        foreach (string reason in holdReasons)
        {
            DataRow row = table.NewRow();
            row["HoldReason"] = reason;
            table.Rows.Add(row);
        }

        DataSet ds = new DataSet();
        ds.Tables.Add(table);
        return ds;
    }

    private string SendMessageToPorterHandler(int porterId, int userId, string message, int serviceId)
    {
        string result = "Success";
        try
        {
            string connStr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("INSERTMESSAGE", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@PORTERID", porterId);
                cmd.Parameters.AddWithValue("@USERID", userId);
                cmd.Parameters.AddWithValue("@MESSAGE", message);
                cmd.Parameters.AddWithValue("@SERVICEID", serviceId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
        catch (Exception ex)
        {
            result = "Error: " + ex.Message;
        }
        return result;
    }

    public DataSet GetCancelReasonsDataSet()
    {
        List<string> holdReasons = new List<string>();
        string connStr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

        using (SqlConnection con = new SqlConnection(connStr))
        {
            using (SqlCommand cmd = new SqlCommand("dbo.SP_GETTASKREASONS", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Category", "Cancellation reasons");

                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        holdReasons.Add(reader["Name"].ToString());
                    }
                }
            }
        }

        DataTable table = new DataTable();
        table.Columns.Add("CancelReason", typeof(string));

        foreach (string reason in holdReasons)
        {
            DataRow row = table.NewRow();
            row["CancelReason"] = reason;
            table.Rows.Add(row);
        }

        DataSet ds = new DataSet();
        ds.Tables.Add(table);
        return ds;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetEmployeeDetailsById(string id)
    {
        if (string.IsNullOrEmpty(id))
        {
            throw new ArgumentException("Missing employee ID.");
        }

        string query = @"
        SELECT TOP 1 * 
        FROM EMPLOYEE_DATA
        WHERE ID = @id
    ";

        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString))
        using (SqlCommand cmd = new SqlCommand(query, conn))
        {
            cmd.Parameters.AddWithValue("@id", id);

            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);

            if (dt.Rows.Count == 0)
            {
                return null;
            }

            Dictionary<string, object> row = new Dictionary<string, object>();
            foreach (DataColumn col in dt.Columns)
            {
                row[col.ColumnName] = dt.Rows[0][col] == DBNull.Value ? null : dt.Rows[0][col];
            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            string jsonData = js.Serialize(row);

            return jsonData;
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getAssistantRequests(string serviceId)
    {
        List<PendingRequestss> requests = new List<PendingRequestss>();

        string connStr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            using (SqlCommand cmd = new SqlCommand("SP_GETASSISTANTREQUESTS", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@SERVICEID", string.IsNullOrEmpty(serviceId) ? "1" : serviceId);

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        requests.Add(new PendingRequestss
                        {
                            TASKID = reader["TASKID"].ToString(),
                            CategoryName = reader["CategoryName"] == DBNull.Value ? "No Category" : reader["CategoryName"].ToString()
                        });
                    }
                }
            }
        }

        return new JavaScriptSerializer().Serialize(requests);
    }

    public class PendingRequestss
    {
        public string TASKID { get; set; }
        public string CategoryName { get; set; }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static object TriggerPorterBreakFilter(int id)
    {
        try
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
            string message = "";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("SP_PORTERMASTER", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ID", id);
                cmd.Parameters.AddWithValue("@PROCESS", "BREAK");

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        message = reader[0] != null ? reader[0].ToString() : "Action completed.";
                    }
                }
                conn.Close();
            }

            return new { success = true, message };
        }
        catch (Exception ex)
        {
            return new { success = false, message = ex.Message };
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static object TriggerPorterMealBreakFilter(int id)
    {
        try
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
            string message = "";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("SP_PORTERMASTER", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ID", id);
                cmd.Parameters.AddWithValue("@PROCESS", "UNAVAILABLE");

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        message = reader[0] != null ? reader[0].ToString() : "Action completed.";
                    }
                }
                conn.Close();
            }

            return new { success = true, message };
        }
        catch (Exception ex)
        {
            return new { success = false, message = ex.Message };
        }
    }

    public DataSet GetResponseFailuresReasonsDataSet()
    {
        List<string> responseFailureReasons = new List<string>();
        string connStr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

        using (SqlConnection con = new SqlConnection(connStr))
        {
            using (SqlCommand cmd = new SqlCommand("dbo.SP_GETTASKREASONS", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Category", "Response failures");

                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        responseFailureReasons.Add(reader["Name"].ToString());
                    }
                }
            }
        }

        DataTable reasonsTable = new DataTable();
        reasonsTable.Columns.Add("ResponseFailureReason", typeof(string));

        foreach (string reason in responseFailureReasons)
        {
            DataRow reasonsRow = reasonsTable.NewRow();
            reasonsRow["ResponseFailureReason"] = reason;
            reasonsTable.Rows.Add(reasonsRow);
        }

        DataSet reasonsDs = new DataSet();
        reasonsDs.Tables.Add(reasonsTable);
        return reasonsDs;
    }

    public DataSet SetResponseFailureDataSet(string requestIdStr, string reason)
    {
        bool success = false;
        string connStr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

        int requestIdValue = 0;
        if (!int.TryParse(requestIdStr, out requestIdValue))
        {
            DataTable errorTbl = new DataTable();
            errorTbl.Columns.Add("success");
            errorTbl.Columns.Add("message");
            DataRow errorR = errorTbl.NewRow();
            errorR["success"] = false;
            errorR["message"] = "Invalid requestId";
            errorTbl.Rows.Add(errorR);

            DataSet errorSet = new DataSet();
            errorSet.Tables.Add(errorTbl);
            return errorSet;
        }

        using (SqlConnection con = new SqlConnection(connStr))
        {
            using (SqlCommand cmd = new SqlCommand("UPDATE requestmaster SET RESPONSEFAILURE = @Reason WHERE REQUESTID = @RequestId", con))
            {
                cmd.Parameters.AddWithValue("@Reason", reason != null ? reason : "");
                cmd.Parameters.AddWithValue("@RequestId", requestIdValue);

                con.Open();
                int rowsAffected = cmd.ExecuteNonQuery();
                success = rowsAffected > 0;
            }
        }

        DataTable resultTbl = new DataTable();
        resultTbl.Columns.Add("success");
        resultTbl.Columns.Add("message");

        DataRow resultR = resultTbl.NewRow();
        resultR["success"] = success;
        resultTbl.Rows.Add(resultR);

        DataSet resultSet = new DataSet();
        resultSet.Tables.Add(resultTbl);
        return resultSet;
    }

    private void HandleGetEmployeeFilterOptions()
    {
        string serviceId = AESEncrytDecry.DecryptStringAES(Request["serviceId"] ?? "");
        if (serviceId == "Invalid Input") serviceId = "";

        var result = GetEmployeeFilterOptionsCore(serviceId);

        Response.Clear();
        Response.ContentType = "application/json";
        var json = new System.Web.Script.Serialization.JavaScriptSerializer()
                       .Serialize(result);
        Response.Write(json);
        Response.End();
    }
    private object GetEmployeeFilterOptionsCore(string serviceId)
    {
        var result = new
        {
            userNames = new List<string>(),
            hospitals = new List<string>(),
            shifts = new List<string>(),
            statuses = new List<string>()
        };

        using (SqlConnection conn = new SqlConnection(
               ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString))
        {
            conn.Open();

            string likeParam = "%," + serviceId + ",%";
            bool isServiceId4 = serviceId == "4";
            string whereClause = "WHERE ',' + ISNULL(EQ_SERVICEID, '') + ',' LIKE @ServiceId";
            if (isServiceId4)
            {
                whereClause += " AND IsLogined = 1";
            }

            using (SqlCommand cmd = new SqlCommand(
                   "SELECT DISTINCT USERNAME FROM dbo.EMPLOYEE_DATA " + whereClause + " ORDER BY USERNAME", conn))
            {
                cmd.Parameters.AddWithValue("@ServiceId", likeParam);
                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                        result.userNames.Add(rdr.GetString(0));
                }
            }

            using (SqlCommand cmd = new SqlCommand(
                   "SELECT DISTINCT HOSPITALNAME1 FROM dbo.EMPLOYEE_DATA " + whereClause + " ORDER BY HOSPITALNAME1", conn))
            {
                cmd.Parameters.AddWithValue("@ServiceId", likeParam);
                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                        result.hospitals.Add(rdr.GetString(0));
                }
            }

            using (SqlCommand cmd = new SqlCommand(
                   "SELECT DISTINCT ALL_DAY FROM dbo.EMPLOYEE_DATA " + whereClause + " ORDER BY ALL_DAY", conn))
            {
                cmd.Parameters.AddWithValue("@ServiceId", likeParam);
                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                        result.shifts.Add(rdr.IsDBNull(0) ? "" : rdr.GetString(0));
                }
            }

            using (SqlCommand cmd = new SqlCommand(
                   "SELECT DISTINCT STATUS FROM dbo.EMPLOYEE_DATA " + whereClause + " ORDER BY STATUS", conn))
            {
                cmd.Parameters.AddWithValue("@ServiceId", likeParam);
                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                        result.statuses.Add(rdr.IsDBNull(0) ? "" : rdr.GetString(0));
                }
            }
        }

        return result;
    }

    //[System.Web.Services.WebMethod]
    //public static object GetEmployeeFilterOptions(string serviceId)
    //{
    //    var result = new
    //    {
    //        userNames = new List<string>(),
    //        hospitals = new List<string>(),
    //        shifts = new List<string>(),
    //        statuses = new List<string>()
    //    };

    //    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString))
    //    {
    //        conn.Open();

    //        string likeParam = "%," + serviceId + ",%";
    //        bool isServiceId4 = serviceId == "4";

    //        string whereClause = "WHERE ',' + ISNULL(EQ_SERVICEID, '') + ',' LIKE @ServiceId";
    //        if (isServiceId4)
    //        {
    //            whereClause += " AND IsLogined = 1";
    //        }

    //        using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT USERNAME FROM dbo.EMPLOYEE_DATA " + whereClause + " ORDER BY USERNAME", conn))
    //        {
    //            cmd.Parameters.AddWithValue("@ServiceId", likeParam);
    //            using (SqlDataReader rdr = cmd.ExecuteReader())
    //            {
    //                while (rdr.Read())
    //                    result.userNames.Add(rdr.GetString(0));
    //            }
    //        }

    //        using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT HOSPITALNAME1 FROM dbo.EMPLOYEE_DATA " + whereClause + " ORDER BY HOSPITALNAME1", conn))
    //        {
    //            cmd.Parameters.AddWithValue("@ServiceId", likeParam);
    //            using (SqlDataReader rdr = cmd.ExecuteReader())
    //            {
    //                while (rdr.Read())
    //                    result.hospitals.Add(rdr.GetString(0));
    //            }
    //        }

    //        using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT ALL_DAY FROM dbo.EMPLOYEE_DATA " + whereClause + " ORDER BY ALL_DAY", conn))
    //        {
    //            cmd.Parameters.AddWithValue("@ServiceId", likeParam);
    //            using (SqlDataReader rdr = cmd.ExecuteReader())
    //            {
    //                while (rdr.Read())
    //                    result.shifts.Add(rdr.IsDBNull(0) ? "" : rdr.GetString(0));
    //            }
    //        }

    //        using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT STATUS FROM dbo.EMPLOYEE_DATA " + whereClause + " ORDER BY STATUS", conn))
    //        {
    //            cmd.Parameters.AddWithValue("@ServiceId", likeParam);
    //            using (SqlDataReader rdr = cmd.ExecuteReader())
    //            {
    //                while (rdr.Read())
    //                    result.statuses.Add(rdr.IsDBNull(0) ? "" : rdr.GetString(0));
    //            }
    //        }
    //    }

    //    return result;
    //}

    private void HandleGetFilteredEmployees()
    {
        string serviceId = AESEncrytDecry.DecryptStringAES(Request["serviceId"] ?? "");
        string userName = AESEncrytDecry.DecryptStringAES(Request["userName"] ?? "");
        string hospital = AESEncrytDecry.DecryptStringAES(Request["hospital"] ?? "");
        string shift = AESEncrytDecry.DecryptStringAES(Request["shift"] ?? "");
        string status = AESEncrytDecry.DecryptStringAES(Request["status"] ?? "");

        if (serviceId == "Invalid Input") serviceId = "";
        if (userName == "Invalid Input") userName = "";
        if (hospital == "Invalid Input") hospital = "";
        if (shift == "Invalid Input") shift = "";
        if (status == "Invalid Input") status = "";

        var result = GetFilteredEmployeesCore(serviceId, userName, hospital, shift, status);

        Response.Clear();
        Response.ContentType = "application/json";
        var json = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(result);
        Response.Write(json);
        Response.End();
    }

    private object GetFilteredEmployeesCore(string serviceId, string userName, string hospital, string shift, string status)
    {
        var employees = new List<object>();

        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString))
        {
            conn.Open();

            string query = @"
            SELECT ID, USERNAME, EMAIL, SLA, HOSPITALNAME1, ALL_DAY,
                   ROLE, DEVICE, LOCATION, WORKTIME, STATUS, ACTION, EQ_SERVICEID
            FROM dbo.EMPLOYEE_DATA
            WHERE (',' + ISNULL(EQ_SERVICEID, '') + ',' LIKE @ServiceId)
              AND (@UserName = '' OR USERNAME = @UserName)
              AND (@Hospital = '' OR HOSPITALNAME1 = @Hospital)
              AND (@Shift = '' OR ALL_DAY = @Shift)
              AND (@Status = '' OR STATUS = @Status)
            ORDER BY 
            CASE 
                WHEN STATUS = 'Free' THEN 1
                WHEN STATUS LIKE 'On task%' THEN 2
                WHEN STATUS = 'On Break' THEN 3
                WHEN STATUS = 'On Meal' THEN 4
                WHEN STATUS = 'Checked out' THEN 5
                ELSE 6
            END,
            ISNULL(
                TRY_CAST(
                    CASE 
                        WHEN CHARINDEX(':', WORKTIME, 1) > 0 
                        THEN LEFT(WORKTIME, CHARINDEX(':', WORKTIME, 1) - 1)
                        ELSE '0'
                    END AS INT
                ), 0
            )";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@ServiceId", "%," + serviceId + ",%"); 
                cmd.Parameters.AddWithValue("@UserName", userName ?? string.Empty);
                cmd.Parameters.AddWithValue("@Hospital", hospital ?? string.Empty);
                cmd.Parameters.AddWithValue("@Shift", shift ?? string.Empty);
                cmd.Parameters.AddWithValue("@Status", status ?? string.Empty);

                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        employees.Add(new
                        {
                            id = rdr["ID"],
                            username = rdr["USERNAME"].ToString(),
                            email = rdr["EMAIL"].ToString(),
                            sla = rdr["SLA"].ToString(),
                            hospital = rdr["HOSPITALNAME1"].ToString(),
                            allDay = rdr["ALL_DAY"].ToString(),
                            role = rdr["ROLE"].ToString(),
                            device = rdr["DEVICE"].ToString(),
                            location = rdr["LOCATION"].ToString(),
                            worktime = rdr["WORKTIME"].ToString(),
                            status = rdr["STATUS"].ToString(),
                            action = rdr["ACTION"].ToString(),
                            eq_serviceid = rdr["EQ_SERVICEID"].ToString()
                        });
                    }
                }
            }
        }

        return employees;
    }

    //[System.Web.Services.WebMethod]
    //public static object GetFilteredEmployees(
    //    string serviceId,
    //    string userName,
    //    string hospital,
    //    string shift,
    //    string status)
    //{
    //    var employees = new List<dynamic>();

    //    using (SqlConnection conn = new SqlConnection(
    //               ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString))
    //    {
    //        conn.Open();

    //        string query = @"
    //    SELECT ID, USERNAME, EMAIL, SLA, HOSPITALNAME1, ALL_DAY,
    //           ROLE, DEVICE, LOCATION, WORKTIME, STATUS, ACTION, EQ_SERVICEID
    //    FROM dbo.EMPLOYEE_DATA
    //    WHERE EXISTS (
    //        SELECT 1 
    //        FROM string_split(EQ_SERVICEID, ',') 
    //        WHERE value = @ServiceId
    //    )
    //    AND (@UserName = '' OR USERNAME = @UserName)
    //    AND (@Hospital = '' OR HOSPITALNAME1 = @Hospital)
    //    AND (@Shift = '' OR ALL_DAY = @Shift)
    //    AND (@Status = '' OR STATUS = @Status)
    //    ORDER BY 
    //    CASE 
    //        WHEN STATUS = 'Free' THEN 1
    //        WHEN STATUS LIKE 'On task%' THEN 2
    //        WHEN STATUS = 'On Break' THEN 3
    //        WHEN STATUS = 'On Meal' THEN 4
    //        WHEN STATUS = 'Checked out' THEN 5
    //        ELSE 6
    //    END,
    //    CAST(LEFT(WORKTIME, CHARINDEX(' ', WORKTIME) - 1) AS INT)";

    //        using (SqlCommand cmd = new SqlCommand(query, conn))
    //        {
    //            cmd.Parameters.AddWithValue("@ServiceId", serviceId);
    //            cmd.Parameters.AddWithValue("@UserName", userName ?? string.Empty);
    //            cmd.Parameters.AddWithValue("@Hospital", hospital ?? string.Empty);
    //            cmd.Parameters.AddWithValue("@Shift", shift ?? string.Empty);
    //            cmd.Parameters.AddWithValue("@Status", status ?? string.Empty);

    //            using (SqlDataReader rdr = cmd.ExecuteReader())
    //            {
    //                while (rdr.Read())
    //                {
    //                    employees.Add(new
    //                    {
    //                        id = rdr["ID"],
    //                        username = rdr["USERNAME"].ToString(),
    //                        email = rdr["EMAIL"].ToString(),
    //                        sla = rdr["SLA"].ToString(),
    //                        hospital = rdr["HOSPITALNAME1"].ToString(),
    //                        allDay = rdr["ALL_DAY"].ToString(),
    //                        role = rdr["ROLE"].ToString(),
    //                        device = rdr["DEVICE"].ToString(),
    //                        location = rdr["LOCATION"].ToString(),
    //                        worktime = rdr["WORKTIME"].ToString(),
    //                        status = rdr["STATUS"].ToString(),
    //                        action = rdr["ACTION"].ToString(),
    //                        eq_serviceid = rdr["EQ_SERVICEID"].ToString()
    //                    });
    //                }
    //            }
    //        }
    //    }

    //    return employees;
    //}

    //    [WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public static object GetFilterOptions(string serviceId)
    //{
    //    string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

    //    List<string> taskIds = new List<string>();
    //    List<string> toLocations = new List<string>();
    //    List<string> fromLocations = new List<string>();
    //    List<string> requestStatuses = new List<string>();
    //    List<string> fromZones = new List<string>();    
    //    List<string> toZones = new List<string>();      
    //    List<string> equipmentTypes = new List<string>();
    //    List<string> taskTypes = new List<string>();
    //    List<string> employees = new List<string>();

    //    using (SqlConnection conn = new SqlConnection(connStr))
    //    using (SqlCommand cmd = new SqlCommand("SP_GETFILTEROPTIONS", conn))
    //    {
    //        cmd.CommandType = CommandType.StoredProcedure;
    //        cmd.Parameters.AddWithValue("@SERVICEID", serviceId ?? (object)DBNull.Value);

    //        conn.Open();
    //        using (SqlDataReader reader = cmd.ExecuteReader())
    //        {
    //            while (reader.Read())
    //            {
    //                taskIds.Add(reader["TASKID"].ToString());
    //            }

    //            reader.NextResult();
    //            while (reader.Read())
    //            {
    //                toLocations.Add(reader["TO_LOCATION"].ToString());
    //            }

    //            reader.NextResult();
    //            while (reader.Read())
    //            {
    //                fromLocations.Add(reader["FROM_LOCATION"].ToString());
    //            }

    //            reader.NextResult();
    //            while (reader.Read())
    //            {
    //                fromZones.Add(reader["FROM_ZONE"].ToString());
    //            }

    //            reader.NextResult();
    //            while (reader.Read())
    //            {
    //                toZones.Add(reader["TO_ZONE"].ToString());
    //            }

    //            reader.NextResult();
    //            while (reader.Read())
    //            {
    //                equipmentTypes.Add(reader["EquipmentName"].ToString());
    //            }

    //            reader.NextResult();
    //            while (reader.Read())
    //            {
    //                taskTypes.Add(reader["CATEGORYNAME"].ToString());
    //            }

    //                reader.NextResult();
    //                while (reader.Read())
    //                {
    //                    requestStatuses.Add(reader["RequestStatus"].ToString());
    //                }

    //                reader.NextResult();
    //            while (reader.Read())
    //            {
    //                employees.Add(reader["PORTERNAME"].ToString());
    //            }
    //        }
    //    }

    //    var result = new
    //    {
    //        taskIds = taskIds.Distinct().ToList(),
    //        taskTypes = taskTypes.Distinct().ToList(),
    //        equipmentTypes = equipmentTypes.Distinct().ToList(),
    //        fromLocations = fromLocations.Distinct().ToList(),
    //        toLocations = toLocations.Distinct().ToList(),
    //        requestStatuses = requestStatuses.Distinct().ToList(),
    //        fromZones = fromZones.Distinct().ToList(),   
    //        toZones = toZones.Distinct().ToList(),        
    //        employees = employees.Distinct().ToList()
    //    };

    //    return result;
    //}

    private void HandleGetFilterOptions()
    {
        string encServiceId = Request["serviceId"];
        string encIsPrebooked = Request["isPrebooked"] ?? ("0"); 

        string serviceId = AESEncrytDecry.DecryptStringAES(encServiceId);
        string isPrebookedStr = AESEncrytDecry.DecryptStringAES(encIsPrebooked);
        bool isPrebooked = isPrebookedStr == "1";

        var result = GetFilterOptions(serviceId, isPrebooked);

        Response.Clear();
        Response.ContentType = "application/json";
        var json = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(result);
        Response.Write(json);
        Response.End();
    }

    public object GetFilterOptions(string serviceId, bool isPrebooked = false)
    {
        string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

        var taskIds = new List<string>();
        var toLocations = new List<string>();
        var fromLocations = new List<string>();
        var requestStatuses = new List<string>();
        var fromZones = new List<string>();
        var toZones = new List<string>();
        var equipmentTypes = new List<string>();
        var taskTypes = new List<string>();
        var employees = new List<string>();

        using (SqlConnection conn = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand("SP_GETFILTEROPTIONS", conn))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@SERVICEID", string.IsNullOrEmpty(serviceId) ? (object)DBNull.Value : serviceId);
            cmd.Parameters.AddWithValue("@ISPREBOOKED", isPrebooked); 

            conn.Open();
            using (SqlDataReader reader = cmd.ExecuteReader())
            {

                while (reader.Read())
                    taskIds.Add(reader["TASKID"].ToString());


                reader.NextResult();
                while (reader.Read())
                    toLocations.Add(reader["TO_LOCATION"].ToString());

 
                reader.NextResult();
                while (reader.Read())
                    fromLocations.Add(reader["FROM_LOCATION"].ToString());

                reader.NextResult();
                while (reader.Read())
                    fromZones.Add(reader["FROM_ZONE"].ToString());

                reader.NextResult();
                while (reader.Read())
                    toZones.Add(reader["TO_ZONE"].ToString());

                reader.NextResult();
                while (reader.Read())
                    equipmentTypes.Add(reader["EquipmentName"].ToString());

                reader.NextResult();
                while (reader.Read())
                    taskTypes.Add(reader["CATEGORYNAME"].ToString());

                reader.NextResult();
                while (reader.Read())
                    requestStatuses.Add(reader["RequestStatus"].ToString());

                reader.NextResult();
                while (reader.Read())
                {
                    string porterName = reader["PORTERNAME"].ToString();
                    if (!string.IsNullOrEmpty(porterName))
                        employees.Add(porterName);
                }
            }
        }

        var result = new
        {
            taskIds = taskIds.Distinct().ToList(),
            taskTypes = taskTypes.Distinct().ToList(),
            equipmentTypes = equipmentTypes.Distinct().ToList(),
            fromLocations = fromLocations.Distinct().ToList(),
            toLocations = toLocations.Distinct().ToList(),
            requestStatuses = requestStatuses.Distinct().ToList(),
            fromZones = fromZones.Distinct().ToList(),
            toZones = toZones.Distinct().ToList(),
            employees = employees.Distinct().ToList()
        };

        return result;
    }
 
    private void HandleGetStartFilterOptions()
    {
        string encServiceId = Request["serviceId"];  
        string serviceId = AESEncrytDecry.DecryptStringAES(encServiceId); 

        var result = GetStartFilterOptions(serviceId);  

        Response.Clear();
        Response.ContentType = "application/json";
        var json = new System.Web.Script.Serialization.JavaScriptSerializer().Serialize(result);
        Response.Write(json);
        Response.End();
    }

    public object GetStartFilterOptions(string serviceId) 
    {
        string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

        var taskIds = new List<string>();
        var toLocations = new List<string>();
        var fromLocations = new List<string>();
        var equipmentTypes = new List<string>();
        var taskTypes = new List<string>();
        var employees = new List<string>();

        using (SqlConnection conn = new SqlConnection(connStr))
        using (SqlCommand cmd = new SqlCommand("SP_GETSTARTFILTEROPTIONS", conn))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@SERVICEID", string.IsNullOrEmpty(serviceId) ? (object)DBNull.Value : serviceId);

            conn.Open();
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                    taskIds.Add(reader["TASKID"].ToString());

                reader.NextResult();
                while (reader.Read())
                    toLocations.Add(reader["TO_LOCATION"].ToString());

                reader.NextResult();
                while (reader.Read())
                    fromLocations.Add(reader["FROM_LOCATION"].ToString());

                reader.NextResult();
                while (reader.Read())
                    equipmentTypes.Add(reader["EquipmentName"].ToString());

                reader.NextResult();
                while (reader.Read())
                    taskTypes.Add(reader["CATEGORYNAME"].ToString());

                reader.NextResult();
                while (reader.Read())
                    employees.Add(reader["PORTERNAME"].ToString());
            }
        }

        var result = new
        {
            taskIds = taskIds.Distinct().ToList(),
            taskTypes = taskTypes.Distinct().ToList(),
            equipmentTypes = equipmentTypes.Distinct().ToList(),
            fromLocations = fromLocations.Distinct().ToList(),
            toLocations = toLocations.Distinct().ToList(),
            employees = employees.Distinct().ToList()
        };

        return result;
    }

    private static List<string> GetUnique(List<Dictionary<string, string>> records, string key)
    {
        return records
            .Select(r => r.ContainsKey(key) ? r[key] : "")
            .Where(val => !string.IsNullOrEmpty(val))
            .Distinct()
            .ToList();
    }

    private void HandleCopyTask()
    {
        try
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string encRequestId = data.ContainsKey("requestId") ? data["requestId"] : null;
            string decryptedRequestId = !string.IsNullOrEmpty(encRequestId) ? AESEncrytDecry.DecryptStringAES(encRequestId) : null;

            if (string.IsNullOrEmpty(decryptedRequestId))
                RespondWithJson(new { success = false, message = "Invalid requestId after decryption" });

            long reqId;
            if (!long.TryParse(decryptedRequestId, out reqId))
                RespondWithJson(new { success = false, message = "RequestId is not a valid number: " + decryptedRequestId });

            string connectionString = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SP_COPYTASK_EQUANS", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RequestID", SqlDbType.BigInt).Value = reqId;
                    cmd.ExecuteNonQuery();
                }
            }

            RespondWithJson(new { success = true });
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, message = ex.Message });
        }
    }
    private void HandleCompleteTask()
    {
        SqlConnection conn = null;
        try
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string RequestID = data.ContainsKey("requestId") ? AESEncrytDecry.DecryptStringAES(data["requestId"]) : null;
            string UserID = data.ContainsKey("userId") ? AESEncrytDecry.DecryptStringAES(data["userId"]) : null;
            string RequestStatus = data.ContainsKey("requestStatus") ? AESEncrytDecry.DecryptStringAES(data["requestStatus"]) : "COMPLETETASK";
            string PorterRemarks = data.ContainsKey("porterRemarks") ? AESEncrytDecry.DecryptStringAES(data["porterRemarks"]) : "";
            string StartTime = data.ContainsKey("startTime") ? AESEncrytDecry.DecryptStringAES(data["startTime"]) : null;
            string EndTime = data.ContainsKey("endTime") ? AESEncrytDecry.DecryptStringAES(data["endTime"]) : null;
            string RemarksId = data.ContainsKey("remarksId") ? AESEncrytDecry.DecryptStringAES(data["remarksId"]) : null;
            string Name = data.ContainsKey("name") ? AESEncrytDecry.DecryptStringAES(data["name"]) : null;
            string PhoneNo = data.ContainsKey("phoneNo") ? AESEncrytDecry.DecryptStringAES(data["phoneNo"]) : null;
            string CatSignFName = data.ContainsKey("catSignFName") ? AESEncrytDecry.DecryptStringAES(data["catSignFName"]) : null;
            string CatPhotoFName = data.ContainsKey("catPhotoFName") ? AESEncrytDecry.DecryptStringAES(data["catPhotoFName"]) : null;
            string AckPhotoTimeStamp = data.ContainsKey("ackPhotoTimeStamp") ? AESEncrytDecry.DecryptStringAES(data["ackPhotoTimeStamp"]) : null;
            string AckLocStamp = data.ContainsKey("ackLocStamp") ? AESEncrytDecry.DecryptStringAES(data["ackLocStamp"]) : null;
            string PROCESS = data.ContainsKey("process") ? AESEncrytDecry.DecryptStringAES(data["process"]) : "COMPLETETASK";

            if (string.IsNullOrEmpty(RequestID) || string.IsNullOrEmpty(UserID))
            {
                RespondWithJson(new { success = false, message = "Invalid required parameters" });
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
            conn = new SqlConnection(connectionString);
            conn.Open();

            SqlCommand cmd = new SqlCommand("SP_StartCompleteTask_EQUANS", conn);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@RequestID", RequestID);
            cmd.Parameters.AddWithValue("@UserID", UserID);
            cmd.Parameters.AddWithValue("@RequestStatus", RequestStatus);
            cmd.Parameters.AddWithValue("@PorterRemarks", string.IsNullOrEmpty(PorterRemarks) ? (object)DBNull.Value : PorterRemarks);
            cmd.Parameters.AddWithValue("@StartTime", string.IsNullOrEmpty(StartTime) ? (object)DBNull.Value : StartTime);
            cmd.Parameters.AddWithValue("@EndTime", string.IsNullOrEmpty(EndTime) ? (object)DBNull.Value : EndTime);
            cmd.Parameters.AddWithValue("@RemarksId", string.IsNullOrEmpty(RemarksId) ? (object)DBNull.Value : RemarksId);
            cmd.Parameters.AddWithValue("@Name", string.IsNullOrEmpty(Name) ? (object)DBNull.Value : Name);
            cmd.Parameters.AddWithValue("@PhoneNo", string.IsNullOrEmpty(PhoneNo) ? (object)DBNull.Value : PhoneNo);
            cmd.Parameters.AddWithValue("@CatSignFName", string.IsNullOrEmpty(CatSignFName) ? (object)DBNull.Value : CatSignFName);
            cmd.Parameters.AddWithValue("@CatPhotoFName", string.IsNullOrEmpty(CatPhotoFName) ? (object)DBNull.Value : CatPhotoFName);
            cmd.Parameters.AddWithValue("@AckPhotoTimeStamp", string.IsNullOrEmpty(AckPhotoTimeStamp) ? (object)DBNull.Value : AckPhotoTimeStamp);
            cmd.Parameters.AddWithValue("@AckLocStamp", string.IsNullOrEmpty(AckLocStamp) ? (object)DBNull.Value : AckLocStamp);
            cmd.Parameters.AddWithValue("@PROCESS", PROCESS);

            int rowsAffected = cmd.ExecuteNonQuery();

            RespondWithJson(new { success = true, message = "Task completed successfully.", rowsAffected = rowsAffected });
        }
        catch (SqlException sqlEx)
        {
            System.Diagnostics.Debug.WriteLine("SQL Error: " + sqlEx.Message);
            System.Diagnostics.Debug.WriteLine("SQL Error Number: " + sqlEx.Number);
            RespondWithJson(new { success = false, message = "SQL Error: " + sqlEx.Message });
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("General Error: " + ex.Message);
            RespondWithJson(new { success = false, message = "General Error: " + ex.Message });
        }
        finally
        {
            if (conn != null && conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }
    }
    private string GetSingleRequestDetails(string encryptedRequestId)
    {
        string requestId = AESEncrytDecry.DecryptStringAES(encryptedRequestId) ?? "";

        long tempId;  
        if (string.IsNullOrEmpty(requestId) || !long.TryParse(requestId, out tempId))
        {
            return "[]"; 
        }

        DataSet ds = new DataSet();

        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString))
        {
            string query = "SELECT * FROM TASK_DATA WHERE REQUESTID = @RequestId";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@RequestId", requestId);
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(ds);
                }
            }
        }
        List<Dictionary<string, object>> result = new List<Dictionary<string, object>>();
        if (ds.Tables.Count > 0)
        {
            DataTable dt = ds.Tables[0];
            foreach (DataRow dr in dt.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row[col.ColumnName] = dr[col] == DBNull.Value ? null : dr[col];
                }
                result.Add(row);
            }
        }

        JavaScriptSerializer serializer = new JavaScriptSerializer();
        return serializer.Serialize(result);
    }

    private void HandleUpdatePorterAssignment()
    {
        try
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string encRequestId = data.ContainsKey("requestId") ? data["requestId"] : null;
            string encPorterId = data.ContainsKey("porterId") ? data["porterId"] : null;
            string encIsChecked = data.ContainsKey("isChecked") ? data["isChecked"] : null;
            string encUserId = data.ContainsKey("userId") ? data["userId"] : null;

            string decryptedRequestId = !string.IsNullOrEmpty(encRequestId) ? AESEncrytDecry.DecryptStringAES(encRequestId) : null;
            string decryptedPorterId = !string.IsNullOrEmpty(encPorterId) ? AESEncrytDecry.DecryptStringAES(encPorterId) : null;
            string decryptedIsChecked = !string.IsNullOrEmpty(encIsChecked) ? AESEncrytDecry.DecryptStringAES(encIsChecked) : null;
            string decryptedUserId = !string.IsNullOrEmpty(encUserId) ? AESEncrytDecry.DecryptStringAES(encUserId) : null;

            if (string.IsNullOrEmpty(decryptedRequestId) || string.IsNullOrEmpty(decryptedPorterId) || string.IsNullOrEmpty(decryptedUserId))
            {
                RespondWithJson(new { success = false, message = "Invalid parameters after decryption" });
                return;
            }

            int reqId = 0, porterId = 0, userId = 0;
            bool isChecked = false;

            if (!int.TryParse(decryptedRequestId, out reqId) ||
                !int.TryParse(decryptedPorterId, out porterId) ||
                !int.TryParse(decryptedUserId, out userId) ||
                !bool.TryParse(decryptedIsChecked, out isChecked))
            {
                RespondWithJson(new { success = false, message = "Invalid parameter format" });
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("sp_UpdatePorterAssignment", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@RequestID", reqId);
                cmd.Parameters.AddWithValue("@PorterID", porterId);
                cmd.Parameters.AddWithValue("@IsChecked", isChecked ? 1 : 0);
                cmd.Parameters.AddWithValue("@USERID", userId);

                SqlParameter rowsAffectedParam = new SqlParameter("@RowsAffected", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };
                cmd.Parameters.Add(rowsAffectedParam);

                conn.Open();

                string porterName = string.Empty;
                int success = 0;
                int rowsAffected = 0;

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        success = Convert.ToInt32(reader["Success"]);

                        porterName = reader.IsDBNull(reader.GetOrdinal("PorterName")) ? "" : reader["PorterName"].ToString();
                        rowsAffected = Convert.ToInt32(reader["RowsAffected"]);
                    }
                }

                RespondWithJson(new
                {
                    success = (success == 1),
                    porterName = porterName,
                    rowsAffected = rowsAffected
                });
            }
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, porterName = "", message = ex.Message });
        }
    }


    [WebMethod]
    public static string GetSingleEmployeeDetails(string employeeId)
    {
        List<Dictionary<string, object>> result = new List<Dictionary<string, object>>();

        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString))
        {
            string query = @"
            SELECT *
            FROM [dbo].[EMPLOYEE_DATA]
            WHERE ID = @EmployeeId
        ";

            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@EmployeeId", employeeId);
            conn.Open();

            SqlDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    row[reader.GetName(i)] = reader.IsDBNull(i) ? null : reader.GetValue(i);
                }
                result.Add(row);
            }
        }

        JavaScriptSerializer serializer = new JavaScriptSerializer();
        return serializer.Serialize(result);
    }

    [WebMethod]
    public void AssignPorterHandler() 
    {
        try
        {
            HttpContext.Current.Request.InputStream.Position = 0;
            string body = new StreamReader(HttpContext.Current.Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string encRequestId = data.ContainsKey("requestId") ? data["requestId"] : null;
            string encPorterId = data.ContainsKey("porterId") ? data["porterId"] : null;
            string encRequestorId = data.ContainsKey("requestorId") ? data["requestorId"] : null;

            string requestId = !string.IsNullOrEmpty(encRequestId) ? AESEncrytDecry.DecryptStringAES(encRequestId) : null;
            string assignTo = !string.IsNullOrEmpty(encPorterId) ? AESEncrytDecry.DecryptStringAES(encPorterId) : null; 
            string requestorId = !string.IsNullOrEmpty(encRequestorId) ? AESEncrytDecry.DecryptStringAES(encRequestorId) : null;

            System.Diagnostics.Debug.WriteLine("DECRYPTED: req='" + requestId + "', porter='" + assignTo + "', reqor='" + requestorId + "'");

            if (string.IsNullOrWhiteSpace(requestId) || string.IsNullOrWhiteSpace(assignTo) || string.IsNullOrWhiteSpace(requestorId))
            {
                RespondWithJson(new { success = false, message = "Decryption failed or missing IDs." });
                return;
            }

            long reqIdLong, requestorIdLong;
            if (!long.TryParse(requestId, out reqIdLong) || !long.TryParse(requestorId, out requestorIdLong))
            {
                RespondWithJson(new
                {
                    success = false,
                    message = "Invalid numeric IDs: req='" + requestId + "', reqor='" + requestorId + "'"
                });
                return;
            }

            DataTable result = DataAccess.AssignTask(
                "SP_ASSIGNPORTER_EQUANS",
                requestId,     
                assignTo,      
                requestorId    
            );

            string spResult = "";
            bool isSuccess = false;
            if (result != null && result.Rows.Count > 0 && result.Rows[0]["RESULT"] != null)
            {
                spResult = result.Rows[0]["RESULT"].ToString().Trim();
                isSuccess = string.Equals(spResult, "TRUE", StringComparison.OrdinalIgnoreCase);
            }

            RespondWithJson(new
            {
                success = isSuccess,
                message = spResult.Length > 0 ? spResult : (isSuccess ? "Success" : "No result from SP")
            });
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, message = "Error: " + ex.Message });
        }
    }

    private void RespondWithJson(object responseObject)
    {
        var response = HttpContext.Current.Response;
        response.Clear();
        response.ContentType = "application/json";
        response.Write(JsonConvert.SerializeObject(responseObject));
        // NO Response.End()
    }
    private void WriteJsonResponse(object responseObj)
    {
        var serializer = new JavaScriptSerializer();
        string jsonResponse = serializer.Serialize(responseObj);

        Response.Clear();
        Response.ContentType = "application/json";
        Response.Write(jsonResponse);
        Response.End();
    }

    private void HandleGetPendingTasks()
    {
        try
        {
            string body;
            using (StreamReader reader = new StreamReader(Request.InputStream))
            {
                body = reader.ReadToEnd();
            }

            Dictionary<string, string> data =
                JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string serviceId;
            if (!data.TryGetValue("serviceId", out serviceId))
            {
                serviceId = null;
            }

            string effectiveServiceId =
                string.IsNullOrEmpty(serviceId) ? "1" : serviceId;

            List<PendingRequest> requests = new List<PendingRequest>();

            string connStr =
                ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("SP_GETPENDINGREQUESTS", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@SERVICEID", SqlDbType.VarChar).Value = effectiveServiceId;

                conn.Open();

                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        PendingRequest pending = new PendingRequest
                        {
                            TASKID = rdr["TASKID"].ToString(),
                            CategoryName = (rdr["CategoryName"] == DBNull.Value)
                                ? "No Category"
                                : rdr["CategoryName"].ToString()
                        };

                        requests.Add(pending);
                    }
                }
            }

            RespondWithJson(new
            {
                success = true,
                data = requests
            });
        }
        catch (Exception ex)
        {
            RespondWithJson(new
            {
                success = false,
                message = ex.Message
            });
        }
    }

    private void HandleGetAssistantRequests()
    {
        try
        {
            // Read JSON body: { "serviceId": "..." }
            string body;
            using (StreamReader reader = new StreamReader(Request.InputStream))
            {
                body = reader.ReadToEnd();
            }

            Dictionary<string, string> data =
                JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string serviceId;
            if (!data.TryGetValue("serviceId", out serviceId))
            {
                serviceId = null;
            }

            string effectiveServiceId =
                string.IsNullOrEmpty(serviceId) ? "1" : serviceId;

            List<PendingRequestss> requests = new List<PendingRequestss>();

            string connStr =
                ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("SP_GETASSISTANTREQUESTS", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@SERVICEID", SqlDbType.VarChar).Value = effectiveServiceId;

                conn.Open();

                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        PendingRequestss pending = new PendingRequestss
                        {
                            TASKID = rdr["TASKID"].ToString(),
                            CategoryName = (rdr["CategoryName"] == DBNull.Value)
                                ? "No Category"
                                : rdr["CategoryName"].ToString()
                        };

                        requests.Add(pending);
                    }
                }
            }

            RespondWithJson(new
            {
                success = true,
                data = requests
            });
        }
        catch (Exception ex)
        {
            RespondWithJson(new
            {
                success = false,
                message = ex.Message
            });
        }
    }

    public class PendingRequest
    {
        public string TASKID { get; set; }
        public string CategoryName { get; set; }
    }

    private void HandleGetPendingRequests()
    {
        try
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string encServiceId = data.ContainsKey("serviceId") ? data["serviceId"] : null;
            string encToZoneFilter = data.ContainsKey("toZoneFilter") ? data["toZoneFilter"] : null;

            string serviceId = !string.IsNullOrEmpty(encServiceId) ? AESEncrytDecry.DecryptStringAES(encServiceId) : null;
            string toZoneFilter = !string.IsNullOrEmpty(encToZoneFilter) ? AESEncrytDecry.DecryptStringAES(encToZoneFilter) : "";

            System.Diagnostics.Debug.WriteLine("getPendingRequests - serviceId: '" + serviceId + "', toZoneFilter: '" + toZoneFilter + "'");

            List<PendingRequests> requests = new List<PendingRequests>();
            string connStr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("SP_GETPENDINGREQUESTS", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@SERVICEID", string.IsNullOrEmpty(serviceId) ? "1" : serviceId);
                    cmd.Parameters.AddWithValue("@TOZONE", string.IsNullOrEmpty(toZoneFilter) ? (object)DBNull.Value : toZoneFilter);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            requests.Add(new PendingRequests
                            {
                                TASKID = reader["TASKID"].ToString(),
                                CategoryName = reader["CategoryName"] == DBNull.Value ? "No Category" : reader["CategoryName"].ToString(),
                                FromLocation = reader["FROM_LOCATION"] == DBNull.Value ? "" : reader["FROM_LOCATION"].ToString(),
                                ToLocation = reader["TO_LOCATION"] == DBNull.Value ? "" : reader["TO_LOCATION"].ToString(),
                                FromZone = reader["FROM_ZONE"] == DBNull.Value ? "" : reader["FROM_ZONE"].ToString(),
                                ToZone = reader["TO_ZONE"] == DBNull.Value ? "" : reader["TO_ZONE"].ToString(),
                                PorterId = reader["PorterId"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["PorterId"]),
                                SubPorterId = reader["SubPorterId"] == DBNull.Value ? (int?)null : Convert.ToInt32(reader["SubPorterId"])
                            });
                        }
                    }
                }
            }

            RespondWithJson(requests); 
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, message = ex.Message });
        }
    }

    public class PendingRequests
    {
        public string TASKID { get; set; }
        public string CategoryName { get; set; }
        public string FromLocation { get; set; }
        public string ToLocation { get; set; }
        public string FromZone { get; set; }
        public string ToZone { get; set; }
        public int? PorterId { get; set; }    
        public int? SubPorterId { get; set; }  
    }

    private void HandleChangePassword()
    {
        bool result = false;
        string error = null;

        try
        {
            string body;
            using (StreamReader reader = new StreamReader(Request.InputStream))
            {
                body = reader.ReadToEnd();
            }

            Dictionary<string, string> data =
                JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string userId;
            string pwd;

            if (!data.TryGetValue("USERID", out userId) || string.IsNullOrEmpty(userId) ||
                !data.TryGetValue("PWD", out pwd) || string.IsNullOrEmpty(pwd))
            {
                error = "Missing USERID or PWD";
            }
            else
            {
                string connString =
                    ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connString))
                using (SqlCommand cmd = new SqlCommand("dbo.SP_CHANGEPWD", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@USERID", userId);
                    cmd.Parameters.AddWithValue("@PASSWORD", pwd);
                    cmd.Parameters.AddWithValue("@PROCESS", "CHANGE");

                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string spResult = reader["RESULT"].ToString();
                            result = string.Equals(spResult, "TRUE",
                                                   StringComparison.OrdinalIgnoreCase);
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            error = ex.Message;
            result = false;
        }

        RespondWithJson(new
        {
            success = result,
            data = new
            {
                RESULT = result ? "TRUE" : "FALSE",
                ERROR = error
            }
        });
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateRequest(Dictionary<string, object> payload)
    {
        try
        {
            int requestId = Convert.ToInt32(payload["requestId"]);
            int categoryId = Convert.ToInt32(payload["categoryId"]);
            int equipmentType = Convert.ToInt32(payload["equipmentTypeId"]);
            int fromLocation = Convert.ToInt32(payload["requestLocationId"]);
            int toLocation = Convert.ToInt32(payload["destinationLocationId"]);
            int updatedBy = Convert.ToInt32(payload["updatedBy"]);
            string patientName = payload["patientName"].ToString();
            string remarks = payload["requestDeskRemarks"].ToString();

            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connString))
            using (SqlCommand cmd = new SqlCommand("SP_UPDATE_REQUEST", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@RequestId", requestId);
                cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                cmd.Parameters.AddWithValue("@EquipmentType", equipmentType);
                cmd.Parameters.AddWithValue("@RequestLocationId", fromLocation);
                cmd.Parameters.AddWithValue("@DestinationLocationId", toLocation);
                cmd.Parameters.AddWithValue("@UpdatedBy", updatedBy);
                cmd.Parameters.AddWithValue("@PatientName", patientName);
                cmd.Parameters.AddWithValue("@RequestDeskRemarks", remarks);

                try
                {
                    con.Open();
                    object result = cmd.ExecuteScalar();

                    if (result != null && result.ToString() == "TRUE")
                    {
                        return new JavaScriptSerializer().Serialize(new { success = true, message = "Task updated successfully" });
                    }
                    else
                    {
                        return new JavaScriptSerializer().Serialize(new { success = false, message = "Update failed. No result returned." });
                    }
                }
                catch (Exception ex)
                {
                    return new JavaScriptSerializer().Serialize(new { success = false, message = "Error: " + ex.Message });
                }
                finally
                {
                    con.Close();
                }
            }
        }
        catch (Exception ex)
        {
            return new JavaScriptSerializer().Serialize(new { success = false, message = "Error: " + ex.Message });
        }
    }

    private static string DecryptParam(Dictionary<string, object> data, string key)
    {
        if (!data.ContainsKey(key) || data[key] == null)
            return "";

        string base64Value = data[key].ToString();
        if (string.IsNullOrEmpty(base64Value))
            return "";

        try
        {
            byte[] bytes = Convert.FromBase64String(base64Value);
            return System.Text.Encoding.UTF8.GetString(bytes);
        }
        catch
        {
            return ""; 
        }
    }

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public static string GetUserRequests(Dictionary<string, object> payload)
    //{
    //    try
    //    {
    //        string userId = DecryptParam(payload, "userId");
    //        string roleId = DecryptParam(payload, "roleId");
    //        string status = DecryptParam(payload, "status");
    //        string pageIndex = DecryptParam(payload, "pageIndex");
    //        string pageSize = DecryptParam(payload, "pageSize");
    //        string search = DecryptParam(payload, "search");
    //        string serviceId = DecryptParam(payload, "serviceId");
    //        string sortOrder = DecryptParam(payload, "SortOrder");

    //        string filterTaskId = DecryptParam(payload, "filterTaskId");
    //        string filterTaskType = DecryptParam(payload, "filterTaskType");
    //        string filterRequestStatus = DecryptParam(payload, "filterRequestStatus");
    //        string filterEquipmentType = DecryptParam(payload, "filterEquipmentType");
    //        string filterFromLocation = DecryptParam(payload, "filterFromLocation");
    //        string filterToLocation = DecryptParam(payload, "filterToLocation");
    //        string filterFromZone = DecryptParam(payload, "filterFromZone");
    //        string filterToZone = DecryptParam(payload, "filterToZone");
    //        string filterEmployee = DecryptParam(payload, "filterEmployee");

    //        DataTable dt = DataAccess.GetRequests(userId, roleId, status, pageIndex, pageSize, search, serviceId, sortOrder,
    //                                              filterTaskId, filterTaskType, filterRequestStatus, filterEquipmentType,
    //                                              filterFromLocation, filterToLocation,
    //                                              filterFromZone, filterToZone,
    //                                              filterEmployee);

    //        var rows = new List<Dictionary<string, object>>();

    //        if (dt != null && dt.Rows.Count > 0)
    //        {
    //            foreach (DataRow dr in dt.Rows)
    //            {
    //                var row = new Dictionary<string, object>();
    //                row["REQUESTID"] = dr["REQUESTID"].ToString();
    //                row["REQUESTTIME"] = dr["REQUESTTIME"].ToString();
    //                row["CATEGORYNAME"] = dr["CATEGORYNAME"].ToString();
    //                row["EquipmentName"] = dr["EquipmentName"].ToString();
    //                row["FROM"] = dr["FROM"].ToString();
    //                row["TO"] = dr["TO"].ToString();
    //                row["REQUESTORNAME"] = dr["REQUESTORNAME"].ToString();
    //                row["REQUESTOR"] = dr["REQUESTOR"].ToString();
    //                row["PORTERNAME"] = dr["PORTERNAME"].ToString();
    //                row["PATIENTNAME"] = dr["PATIENTNAME"].ToString();
    //                row["REQUESTSTATUS"] = dr["REQUESTSTATUS"].ToString();
    //                row["TimeDifference"] = dr["TimeDifference"].ToString();
    //                row["RESPONSEKPICAL"] = dr["RESPONSEKPICAL"].ToString();
    //                row["COMPLETIONKPICAL"] = dr["COMPLETIONKPICAL"].ToString();
    //                row["ISMULTIPORTER"] = dr["ISMULTIPORTER"].ToString();
    //                row["ISPREBOOK"] = dr["ISPREBOOK"].ToString();
    //                row["CONTACTNO"] = dr["CONTACTNO"].ToString();
    //                row["REQUESTDESKREMARKS"] = dr["REQUESTDESKREMARKS"].ToString();
    //                row["FROM_LOCATION"] = dr["FROM_LOCATION"].ToString();
    //                row["TO_LOCATION"] = dr["TO_LOCATION"].ToString();
    //                row["REQUESTDATE"] = dr["REQUESTDATE"].ToString();
    //                rows.Add(row);
    //            }
    //        }

    //        JavaScriptSerializer js = new JavaScriptSerializer();
    //        return js.Serialize(rows);
    //    }
    //    catch (Exception ex)
    //    {
    //        return new JavaScriptSerializer().Serialize(new { error = ex.Message });
    //    }
    //}

    private DataSet GetUserRequestsDataSet(Stream inputStream)
    {
        try
        {
            inputStream.Position = 0;
            string body = new StreamReader(inputStream).ReadToEnd();

            var wrapper = JsonConvert.DeserializeObject<Dictionary<string, object>>(body);

            Dictionary<string, object> payload = JsonConvert.DeserializeObject<Dictionary<string, object>>(
                wrapper["payload"].ToString());

            string userId = DecryptParam(payload, "userId");
            string roleId = DecryptParam(payload, "roleId");
            string status = DecryptParam(payload, "status");
            string pageIndex = DecryptParam(payload, "pageIndex");
            string pageSize = DecryptParam(payload, "pageSize");
            string search = DecryptParam(payload, "search");
            string serviceId = DecryptParam(payload, "serviceId");
            string sortOrder = DecryptParam(payload, "SortOrder");

            string filterTaskId = DecryptParam(payload, "filterTaskId");
            string filterTaskType = DecryptParam(payload, "filterTaskType");
            string filterRequestStatus = DecryptParam(payload, "filterRequestStatus");
            string filterEquipmentType = DecryptParam(payload, "filterEquipmentType");
            string filterFromLocation = DecryptParam(payload, "filterFromLocation");
            string filterToLocation = DecryptParam(payload, "filterToLocation");
            string filterFromZone = DecryptParam(payload, "filterFromZone");
            string filterToZone = DecryptParam(payload, "filterToZone");
            string filterEmployee = DecryptParam(payload, "filterEmployee");

            DataTable dt = DataAccess.GetRequests(
                userId,
                roleId,
                status,
                pageIndex,
                pageSize,
                search,
                serviceId,
                sortOrder,
                filterTaskId,
                filterTaskType,
                filterRequestStatus,
                filterEquipmentType,
                filterFromLocation,
                filterToLocation,
                filterFromZone,
                filterToZone,
                filterEmployee
            );

            DataTable responseTable = new DataTable();
            responseTable.Columns.Add("REQUESTID", typeof(string));
            responseTable.Columns.Add("REQUESTTIME", typeof(string));
            responseTable.Columns.Add("CATEGORYNAME", typeof(string));
            responseTable.Columns.Add("EquipmentName", typeof(string));
            responseTable.Columns.Add("FROM", typeof(string));
            responseTable.Columns.Add("TO", typeof(string));
            responseTable.Columns.Add("REQUESTORNAME", typeof(string));
            responseTable.Columns.Add("REQUESTOR", typeof(string));
            responseTable.Columns.Add("PORTERNAME", typeof(string));
            responseTable.Columns.Add("PATIENTNAME", typeof(string));
            responseTable.Columns.Add("REQUESTSTATUS", typeof(string));
            responseTable.Columns.Add("TimeDifference", typeof(string));
            responseTable.Columns.Add("RESPONSEKPICAL", typeof(string));
            responseTable.Columns.Add("COMPLETIONKPICAL", typeof(string));
            responseTable.Columns.Add("ISMULTIPORTER", typeof(string));
            responseTable.Columns.Add("ISPREBOOK", typeof(string));
            responseTable.Columns.Add("CONTACTNO", typeof(string));
            responseTable.Columns.Add("REQUESTDESKREMARKS", typeof(string));
            responseTable.Columns.Add("FROM_LOCATION", typeof(string));
            responseTable.Columns.Add("TO_LOCATION", typeof(string));
            responseTable.Columns.Add("REQUESTDATE", typeof(string));

            if (dt != null && dt.Rows.Count > 0)
            {
                foreach (DataRow dr in dt.Rows)
                {
                    DataRow newRow = responseTable.NewRow();
                    newRow["REQUESTID"] = dr["REQUESTID"] != null ? dr["REQUESTID"].ToString() : null;
                    newRow["REQUESTTIME"] = dr["REQUESTTIME"] != null ? dr["REQUESTTIME"].ToString() : null;
                    newRow["CATEGORYNAME"] = dr["CATEGORYNAME"] != null ? dr["CATEGORYNAME"].ToString() : null;
                    newRow["EquipmentName"] = dr["EquipmentName"] != null ? dr["EquipmentName"].ToString() : null;
                    newRow["FROM"] = dr["FROM"] != null ? dr["FROM"].ToString() : null;
                    newRow["TO"] = dr["TO"] != null ? dr["TO"].ToString() : null;
                    newRow["REQUESTORNAME"] = dr["REQUESTORNAME"] != null ? dr["REQUESTORNAME"].ToString() : null;
                    newRow["REQUESTOR"] = dr["REQUESTOR"] != null ? dr["REQUESTOR"].ToString() : null;
                    newRow["PORTERNAME"] = dr["PORTERNAME"] != null ? dr["PORTERNAME"].ToString() : null;
                    newRow["PATIENTNAME"] = dr["PATIENTNAME"] != null ? dr["PATIENTNAME"].ToString() : null;
                    newRow["REQUESTSTATUS"] = dr["REQUESTSTATUS"] != null ? dr["REQUESTSTATUS"].ToString() : null;
                    newRow["TimeDifference"] = dr["TimeDifference"] != null ? dr["TimeDifference"].ToString() : null;
                    newRow["RESPONSEKPICAL"] = dr["RESPONSEKPICAL"] != null ? dr["RESPONSEKPICAL"].ToString() : null;
                    newRow["COMPLETIONKPICAL"] = dr["COMPLETIONKPICAL"] != null ? dr["COMPLETIONKPICAL"].ToString() : null;
                    newRow["ISMULTIPORTER"] = dr["ISMULTIPORTER"] != null ? dr["ISMULTIPORTER"].ToString() : null;
                    newRow["ISPREBOOK"] = dr["ISPREBOOK"] != null ? dr["ISPREBOOK"].ToString() : null;
                    newRow["CONTACTNO"] = dr["CONTACTNO"] != null ? dr["CONTACTNO"].ToString() : null;
                    newRow["REQUESTDESKREMARKS"] = dr["REQUESTDESKREMARKS"] != null ? dr["REQUESTDESKREMARKS"].ToString() : null;
                    newRow["FROM_LOCATION"] = dr["FROM_LOCATION"] != null ? dr["FROM_LOCATION"].ToString() : null;
                    newRow["TO_LOCATION"] = dr["TO_LOCATION"] != null ? dr["TO_LOCATION"].ToString() : null;
                    newRow["REQUESTDATE"] = dr["REQUESTDATE"] != null ? dr["REQUESTDATE"].ToString() : null;

                    responseTable.Rows.Add(newRow);
                }
            }

            DataSet ds = new DataSet();
            ds.Tables.Add(responseTable);
            return ds;
        }
        catch (Exception ex)
        {
            DataTable errorTable = new DataTable();
            errorTable.Columns.Add("error", typeof(string));
            DataRow errorRow = errorTable.NewRow();
            errorRow["error"] = ex.Message;
            errorTable.Rows.Add(errorRow);

            DataSet errorDs = new DataSet();
            errorDs.Tables.Add(errorTable);
            return errorDs;
        }
    }

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public static string UpdateUserRequest(Dictionary<string, object> payload)
    //{
    //    try
    //    {
    //        var requestId = Convert.ToInt32(payload["requestId"]);  
    //        var categoryId = Convert.ToInt32(payload["categoryId"]);
    //        var equipmentTypeId = Convert.ToInt32(payload["equipmentTypeId"]); 
    //        var requestLocationId = Convert.ToInt32(payload["requestLocationId"]); 
    //        var destinationLocationId = Convert.ToInt32(payload["destinationLocationId"]);  
    //        var requestDeskRemarks = payload["requestDeskRemarks"].ToString(); 
    //        var updatedBy = Convert.ToInt32(payload["updatedBy"]);  
    //        var patientName = payload["patientName"].ToString();  

    //        bool success = DataAccess.UpdateRequest(requestId, categoryId, equipmentTypeId, requestLocationId,
    //                                                 destinationLocationId, requestDeskRemarks, updatedBy, patientName);

    //        return new JavaScriptSerializer().Serialize(new { success });
    //    }
    //    catch (Exception ex)
    //    {
    //        return new JavaScriptSerializer().Serialize(new { error = ex.Message });
    //    }
    //}

    [WebMethod]
    public static object UpdateRequestMaster(Dictionary<string, object> payload)
    {
        string connectionString = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

        try
        {

            RequestPayload data = new RequestPayload();
            data.requestId = DecryptInt(payload, "requestId");
            data.categoryId = DecryptInt(payload, "categoryId");
            data.equipmentTypeId = DecryptInt(payload, "equipmentTypeId");
            data.requestLocationId = DecryptInt(payload, "requestLocationId");
            data.destinationLocationId = DecryptInt(payload, "destinationLocationId");
            data.updatedBy = DecryptInt(payload, "updatedBy");
            data.requestDeskRemarks = DecryptString(payload, "requestDeskRemarks");
            data.patientName = DecryptString(payload, "patientName");
            string requestDateTimeStr = DecryptString(payload, "requestDate");

            DateTime requestDateTimeValue;
            DateTime? requestDateTime = null;

            if (!string.IsNullOrEmpty(requestDateTimeStr))
            {
                if (DateTime.TryParse(requestDateTimeStr, out requestDateTimeValue))
                {
                    requestDateTime = requestDateTimeValue;
                }
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(@"
            UPDATE RequestMaster
            SET 
                CategoryId = @CategoryId,
                EquipmentType = @EquipmentType,
                RequestLocationId = @RequestLocationId,
                DestinationLocationId = @DestinationLocationId,
                RequestDeskRemarks = @RequestDeskRemarks,
                UpdatedBy = @UpdatedBy,
                PatientName = @PatientName,
                RequestDate = ISNULL(@RequestDate, RequestDate)
            WHERE RequestId = @RequestId", conn))
            {
                cmd.Parameters.Add("@RequestId", SqlDbType.Int).Value = data.requestId;
                cmd.Parameters.Add("@CategoryId", SqlDbType.Int).Value = data.categoryId;
                cmd.Parameters.Add("@EquipmentType", SqlDbType.Int).Value = data.equipmentTypeId;
                cmd.Parameters.Add("@RequestLocationId", SqlDbType.Int).Value = data.requestLocationId;
                cmd.Parameters.Add("@DestinationLocationId", SqlDbType.Int).Value = data.destinationLocationId;
                cmd.Parameters.Add("@RequestDeskRemarks", SqlDbType.NVarChar, 500).Value = data.requestDeskRemarks;
                cmd.Parameters.Add("@UpdatedBy", SqlDbType.Int).Value = data.updatedBy;
                cmd.Parameters.Add("@PatientName", SqlDbType.NVarChar, 255).Value = data.patientName;
                cmd.Parameters.Add("@RequestDate", SqlDbType.DateTime).Value = requestDateTime ?? (object)DBNull.Value;

                conn.Open();
                int rowsAffected = cmd.ExecuteNonQuery();

                if (rowsAffected == 0)
                    return new { success = false, message = "No record found with the provided RequestId." };

                return new { success = true, message = "Request updated successfully!" };
            }
        }
        catch (Exception ex)
        {
            return new { success = false, message = "Error: " + ex.Message };
        }
    }
    private static string DecryptString(Dictionary<string, object> payload, string key)
    {
        if (!payload.ContainsKey(key) || payload[key] == null)
            return "";

        try
        {
            string base64 = payload[key].ToString();
            byte[] bytes = Convert.FromBase64String(base64);
            return Encoding.UTF8.GetString(bytes);
        }
        catch
        {
            return "";
        }
    }
    private static int DecryptInt(Dictionary<string, object> payload, string key)
    {
        string str = DecryptString(payload, key);
        int val = 0;
        int.TryParse(str, out val);
        return val;
    }
    public class RequestPayload
    {
        public int requestId { get; set; }
        public int categoryId { get; set; }
        public int equipmentTypeId { get; set; }
        public int requestLocationId { get; set; }
        public int destinationLocationId { get; set; }
        public string requestDeskRemarks { get; set; }
        public int updatedBy { get; set; }
        public string patientName { get; set; }
    }

    private DataSet AlertProcess()
    {
        string ReqId = string.IsNullOrEmpty(Request.QueryString["ReqId"]) ? "0" : Request.QueryString["ReqId"].ToString(),
              Process = string.IsNullOrEmpty(Request.QueryString["AlertProcess"]) ? "0" : Request.QueryString["AlertProcess"].ToString();
        DataTable dt = DataAccess.GetPopDetails(ReqId.Trim(), string.Empty, Process);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }

    private DataSet GetPopupDetails()
    {
        string ReqNo = ((!string.IsNullOrEmpty(Request.QueryString["REQID"])) ? Request.QueryString["REQID"].ToString() : "");
        DataTable dt = Modify(DataAccess.GetPopDetails(ReqNo.Trim(), string.Empty, string.Empty));
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }
    private DataSet GetPorterDetails()
    {
        string ReqNo = ((!string.IsNullOrEmpty(Request.QueryString["REQID"])) ? Request.QueryString["REQID"].ToString() : "");
        DataTable dt = Modify(DataAccess.PorterDetails(ReqNo.Trim(), string.Empty, string.Empty));
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }
    private DataSet GetPendingRequest()
    {
        string User = ((!string.IsNullOrEmpty(Request.QueryString["USERID"])) ? Request.QueryString["USERID"].ToString() : "");
        DataTable dt = DataAccess.GetPopDetails(string.Empty, User.Trim(), string.Empty);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }
    private DataSet GetETA()
    {
        string ReqNo = ((!string.IsNullOrEmpty(Request.QueryString["REQID"])) ? Request.QueryString["REQID"].ToString() : "");
        DataTable dt = DataAccess.GetPopDetails(ReqNo.Trim(), string.Empty, "GETETA");
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }

    private string GetPath(object ImageByte)
    {
        byte[] rPicture = (byte[])ImageByte;
        string base64String = Convert.ToBase64String(rPicture, 0, rPicture.Length);
        string path = "data:image/png;base64," + base64String;
        return path;
    }
    private DataTable Modify(DataTable dataTable)
    {
        if (dataTable.Rows.Count > 0)
        {
            foreach (DataRow dr in dataTable.Rows)
            {
                dr["STRPIMAGE"] = (string.IsNullOrEmpty(dr["PORTER"].ToString().Trim()) ? string.Empty : GetPath(dr["PORTERIMAGE"]));
                dr["STRSPIMAGE"] = (string.IsNullOrEmpty(dr["SUPPORTER"].ToString().Trim()) ? string.Empty : GetPath(dr["SUPPORTERIMAGE"]));
            }
        }
        return dataTable;
    }

    private DataSet GetCategory()
    {
        DataTable table = new DataTable();
        table = DataAccess.getRecords("SP_GETCATEGORY").Tables[0].Copy();
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet GetEquipment()
    {
        DataTable table = new DataTable();
        table = DataAccess.getRecords("SP_GETEQUIPMENT").Tables[0].Copy();
        DataSet DS = new DataSet();
        DS.Tables.Add(table);
        return DS;
    }

    private DataSet BuzzerTags()
    {
        string TagIds = ((!string.IsNullOrEmpty(Request.QueryString["TagIds"])) ? Request.QueryString["TagIds"].ToString() : "");
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

    private void GetEmployeeData(string filter, string serviceId, string sortOrder, HttpContext context)
    {
        if (serviceId == "2")
        {
            serviceId = "3";
        }

        if (string.IsNullOrEmpty(sortOrder)) sortOrder = "asc";
        string orderDirection = (sortOrder.ToLower() == "desc") ? "DESC" : "ASC";

        string query = @"
        SELECT * FROM EMPLOYEE_DATA
        WHERE 1=1";

        List<SqlParameter> parameters = new List<SqlParameter>();

        if (!string.IsNullOrEmpty(filter))
        {
            query += " AND USERNAME LIKE @filter";
            query += " AND ',' + ISNULL(EQ_SERVICEID, '') + ',' LIKE @serviceId";
            parameters.Add(new SqlParameter("@filter", "%" + filter + "%"));
            parameters.Add(new SqlParameter("@serviceId", "%," + serviceId + ",%"));
        }
        else
        {
            query += " AND (EQ_SERVICEID = @serviceIdExact)";
            parameters.Add(new SqlParameter("@serviceIdExact", serviceId));
        }

        query += @"
        ORDER BY 
            CASE 
                WHEN STATUS = 'Free' THEN 1
                WHEN STATUS LIKE 'On task%' THEN 2
                WHEN STATUS = 'On Break' THEN 3
                WHEN STATUS = 'On Meal' THEN 4
                WHEN STATUS = 'Checked out' THEN 5
                ELSE 6
            END,
            CASE 
                WHEN CHARINDEX(' hour', WORKTIME) > 0 
                THEN TRY_CAST(LEFT(WORKTIME, CHARINDEX(' hour', WORKTIME) - 1) AS INT)
                ELSE 0
            END " + orderDirection + @",
            CASE 
                WHEN CHARINDEX('hour', WORKTIME) > 0 
                THEN TRY_CAST(SUBSTRING(WORKTIME, CHARINDEX('hour', WORKTIME) + 5, LEN(WORKTIME)) AS INT)
                ELSE 0
            END " + orderDirection + @",
            USERNAME ASC";

        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString))
        using (SqlCommand cmd = new SqlCommand(query, conn))
        {
            foreach (var param in parameters)
            {
                cmd.Parameters.Add(param);
            }

            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);

            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
            foreach (DataRow dr in dt.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row[col.ColumnName] = dr[col] == DBNull.Value ? null : dr[col];
                }
                rows.Add(row);
            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            string jsonData = js.Serialize(rows);

            context.Response.Clear();
            context.Response.ContentType = "application/json";
            context.Response.Write(jsonData);
            context.Response.End();
        }
    }

    private void GetEmployeeDataAssign(string filter, string serviceId)
    {

        if (serviceId == "2")
        {
            serviceId = "3";
        }

        string query = @"
        SELECT DISTINCT USERNAME, status, EQ_SERVICEID, HOSPITALNAME1, ID
        FROM EMPLOYEE_DATA
        WHERE STATUS NOT IN ('On Break','Checked out','On Meal')";

        if (!string.IsNullOrEmpty(filter))
        {
            query += " AND USERNAME LIKE @filter";
        }

        if (!string.IsNullOrEmpty(serviceId))
        {
            query += " AND ',' + EQ_SERVICEID + ',' LIKE @serviceId";
        }

        query += " ORDER BY USERNAME ASC";

        using (SqlConnection conn = new SqlConnection(
                   ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString))
        using (SqlCommand cmd = new SqlCommand(query, conn))
        {
            if (!string.IsNullOrEmpty(filter))
            {
                cmd.Parameters.AddWithValue("@filter", "%" + filter + "%");
            }

            if (!string.IsNullOrEmpty(serviceId))
            {
                cmd.Parameters.AddWithValue("@serviceId", "%," + serviceId + ",%");
            }

            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            adapter.Fill(dt);

            JavaScriptSerializer js = new JavaScriptSerializer();
            List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

            foreach (DataRow dr in dt.Rows)
            {
                Dictionary<string, object> row = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    row[col.ColumnName] = dr[col] == DBNull.Value ? null : dr[col];
                }
                rows.Add(row);
            }

            string jsonData = js.Serialize(rows);

            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ContentType = "application/json";
            HttpContext.Current.Response.Write(jsonData);
            HttpContext.Current.Response.End();
        }
    }

    private void GetFilterOption()
    {
        string query = @"
        SELECT DISTINCT UserName FROM EMPLOYEE_DATA WHERE UserName IS NOT NULL;
        SELECT DISTINCT Location FROM EMPLOYEE_DATA WHERE ZoneName IS NOT NULL;
        SELECT DISTINCT HospitalName FROM EMPLOYEE_DATA WHERE HospitalName1 IS NOT NULL;
        SELECT DISTINCT Shift FROM EMPLOYEE_DATA WHERE ALL_DAY IS NOT NULL;
        SELECT DISTINCT Status FROM EMPLOYEE_DATA WHERE STATUS IS NOT NULL;
    ";

        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString))
        using (SqlCommand cmd = new SqlCommand(query, conn))
        {
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            adapter.Fill(ds);

            var result = new
            {
                UserNames = ds.Tables[0].AsEnumerable().Select(r => r[0].ToString()).ToList(),
                Locations = ds.Tables[1].AsEnumerable().Select(r => r[0].ToString()).ToList(),
                HospitalNames = ds.Tables[2].AsEnumerable().Select(r => r[0].ToString()).ToList(),
                Shifts = ds.Tables[3].AsEnumerable().Select(r => r[0].ToString()).ToList(),
                Statuses = ds.Tables[4].AsEnumerable().Select(r => r[0].ToString()).ToList()
            };

            JavaScriptSerializer js = new JavaScriptSerializer();
            string jsonData = js.Serialize(result);

            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ContentType = "application/json";
            HttpContext.Current.Response.Write(jsonData);
            HttpContext.Current.Response.End();
        }
    }

    private DataSet completeTask()
    {
        string TAGID = ((!string.IsNullOrEmpty(Request.QueryString["TAGID"])) ? Request.QueryString["TAGID"].ToString() : ""),
            REASON = ((!string.IsNullOrEmpty(Request.QueryString["REASON"])) ? Request.QueryString["REASON"].ToString() : ""),
            REQUESTID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString().Trim().ToUpper(),
            PorterID = (string.IsNullOrEmpty(Request.QueryString["PORTERIDS"])) ? "" : Request.QueryString["PORTERIDS"].ToString().Trim().ToUpper(),
            MIndex = (string.IsNullOrEmpty(Request.QueryString["MIINDEX"])) ? "" : Request.QueryString["MIINDEX"].ToString().Trim().ToUpper(),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString();
        DataTable table;
        if (User == string.Empty)
        {
            table = generate();
            DataRow row = table.NewRow();
            row["RESULT"] = "FALSE";
            table.Rows.Add(row);
        }
        else
            table = DataAccess.CompleteTask(REQUESTID, PorterID, TAGID, REASON, User, MIndex);

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }


    private DataSet AddcompleteRemarks()
    {
        string REASON = ((!string.IsNullOrEmpty(Request.QueryString["REMARKS"])) ? Request.QueryString["REMARKS"].ToString() : ""),
            REQUESTID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString().Trim().ToUpper(),
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
            table = DataAccess.AddCompleteRemarks(REQUESTID, REASON, User, IsMitigation);

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet startTask()
    {
        string TAGID = ((!string.IsNullOrEmpty(Request.QueryString["TAGID"])) ? Request.QueryString["TAGID"].ToString() : ""),
            LOCATION = ((!string.IsNullOrEmpty(Request.QueryString["LOCATION"])) ? Request.QueryString["LOCATION"].ToString() : ""),
            MIndex = (string.IsNullOrEmpty(Request.QueryString["MIINDEX"])) ? "" : Request.QueryString["MIINDEX"].ToString().Trim().ToUpper(),
            REQUESTID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString().Trim().ToUpper();
        DataTable table;
        table = DataAccess.StartTask(REQUESTID, TAGID, LOCATION, MIndex);

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private void HandleCancelTask()
    {
        try
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            // Decrypt all parameters
            string requestId = AESEncrytDecry.DecryptStringAES(data.ContainsKey("requestId") ? data["requestId"] : "");
            string prebook = AESEncrytDecry.DecryptStringAES(data.ContainsKey("prebook") ? data["prebook"] : "NO");
            string reason = AESEncrytDecry.DecryptStringAES(data.ContainsKey("reason") ? data["reason"] : "");
            string porterIds = AESEncrytDecry.DecryptStringAES(data.ContainsKey("porterIds") ? data["porterIds"] : "");
            string userId = AESEncrytDecry.DecryptStringAES(data.ContainsKey("userId") ? data["userId"] : "");
            string miIndex = AESEncrytDecry.DecryptStringAES(data.ContainsKey("miIndex") ? data["miIndex"] : "0");

            if (string.IsNullOrEmpty(requestId) || string.IsNullOrEmpty(reason))
            {
                RespondWithJson(new { success = false, message = "Missing requestId or reason" });
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("SP_CANCELREQUEST_EQUANS", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@REQUESTID", requestId);
                cmd.Parameters.AddWithValue("@PREBOOK", prebook);
                cmd.Parameters.AddWithValue("@REASON", reason);
                cmd.Parameters.AddWithValue("@PORTERIDS", porterIds);
                cmd.Parameters.AddWithValue("@USERID", userId);
                cmd.Parameters.AddWithValue("@MIINDEX", miIndex);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            RespondWithJson(new { success = true });
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, message = ex.Message });
        }
    }


    //[WebMethod]
    //private DataSet cancelTask()
    //{
    //    string requestBody;
    //    using (var reader = new StreamReader(Request.InputStream))
    //    {
    //        requestBody = reader.ReadToEnd();
    //    }

    //    var serializer = new JavaScriptSerializer();
    //    var data = serializer.Deserialize<Dictionary<string, string>>(requestBody);

    //    string RequestId = data.ContainsKey("requestId") ? data["requestId"] : "";
    //    string User = data.ContainsKey("userId") ? data["userId"] : "";
    //    string PreBook = data.ContainsKey("prebook") ? data["prebook"] : "";
    //    string Reason = data.ContainsKey("reason") ? data["reason"] : "";
    //    string PorterID = data.ContainsKey("porterIds") ? data["porterIds"] : "";
    //    string MIndex = data.ContainsKey("miIndex") ? data["miIndex"] : "";

    //    DataTable table;
    //    if (string.IsNullOrEmpty(User))
    //    {
    //        table = generate();
    //        DataRow row = table.NewRow();
    //        row["RESULT"] = "FALSE";
    //        table.Rows.Add(row);
    //    }
    //    else
    //    {
    //        table = DataAccess.CancelTask(RequestId, PorterID, PreBook, Reason, User, MIndex);
    //    }

    //    DataSet DS = new DataSet();
    //    DS.Tables.Add(table);
    //    return DS;
    //}

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public static object CancelTask(CancelTaskPayload payload)
    //{
    //    try
    //    {
    //        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

    //        using (SqlConnection conn = new SqlConnection(connectionString))
    //        using (SqlCommand cmd = new SqlCommand("SP_CANCELREQUEST_EQUANS", conn))
    //        {
    //            cmd.CommandType = CommandType.StoredProcedure;

    //            cmd.Parameters.AddWithValue("@REQUESTID", payload.REQUESTID);
    //            cmd.Parameters.AddWithValue("@PREBOOK", payload.PREBOOK ?? "NO");
    //            cmd.Parameters.AddWithValue("@REASON", payload.REASON ?? string.Empty);
    //            cmd.Parameters.AddWithValue("@PORTERIDS", payload.PORTERIDS ?? string.Empty);
    //            cmd.Parameters.AddWithValue("@USERID", payload.USERID ?? string.Empty);
    //            cmd.Parameters.AddWithValue("@MIINDEX", payload.MIINDEX ?? "0");

    //            conn.Open();
    //            cmd.ExecuteNonQuery();
    //        }

    //        return new { success = true };
    //    }
    //    catch (Exception ex)
    //    {
    //        return new { success = false, message = ex.Message };
    //    }
    //}

    public class CancelTaskPayload
{
    public string REQUESTID { get; set; }
    public string PREBOOK { get; set; }
    public string REASON { get; set; }
    public string PORTERIDS { get; set; }
    public string USERID { get; set; }
    public string MIINDEX { get; set; }
}

[WebMethod]
    private DataSet OnHoldTask()
    {
        //Process=ONHOLDTASK&REASON=" + Reason + "&USERID=" + UID + "&REQUESTID=" + ReqID + "&PORTERIDS=" + PoreterID + "&MIINDEX=" + GMIndex,
        string Reason = ((!string.IsNullOrEmpty(Request.QueryString["REASON"])) ? Request.QueryString["REASON"].ToString() : ""),
            RequestID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString().Trim().ToUpper(),
            PorterID = (string.IsNullOrEmpty(Request.QueryString["PORTERIDS"])) ? "" : Request.QueryString["PORTERIDS"].ToString().Trim().ToUpper(),
            MIndex = (string.IsNullOrEmpty(Request.QueryString["MIINDEX"])) ? "" : Request.QueryString["MIINDEX"].ToString().Trim().ToUpper(),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString();
        DataTable table;
        if (User == string.Empty)
        {
            table = generate();
            DataRow row = table.NewRow();
            row["RESULT"] = "FALSE";
            table.Rows.Add(row);
        }
        else
            table = DataAccess.SetHoldTask(RequestID, PorterID, Reason, User, MIndex);

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private void HandleOnHoldTasks()
    {
        try
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string encRequestId = data.ContainsKey("requestId") ? data["requestId"] : null;
            string encReason = data.ContainsKey("reason") ? data["reason"] : null;
            string encUserId = data.ContainsKey("userId") ? data["userId"] : null;
            string encPorterIds = data.ContainsKey("porterIds") ? data["porterIds"] : null;
            string encMiIndex = data.ContainsKey("miIndex") ? data["miIndex"] : null;

            string requestId = !string.IsNullOrEmpty(encRequestId) ? AESEncrytDecry.DecryptStringAES(encRequestId) : null;
            string reason = !string.IsNullOrEmpty(encReason) ? AESEncrytDecry.DecryptStringAES(encReason) : null;
            string userId = !string.IsNullOrEmpty(encUserId) ? AESEncrytDecry.DecryptStringAES(encUserId) : null;
            string porterIds = !string.IsNullOrEmpty(encPorterIds) ? AESEncrytDecry.DecryptStringAES(encPorterIds) : null;
            string miIndex = !string.IsNullOrEmpty(encMiIndex) ? AESEncrytDecry.DecryptStringAES(encMiIndex) : "0";

            if (string.IsNullOrWhiteSpace(requestId) || string.IsNullOrWhiteSpace(reason))
            {
                RespondWithJson(new { success = false, message = "Missing required parameters" });
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SP_SETONHOLD_EQUANS", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@REQUESTID", requestId);
                    cmd.Parameters.AddWithValue("@ONHOLDREMARKS", reason);
                    cmd.Parameters.AddWithValue("@USERID", userId ?? string.Empty);
                    cmd.Parameters.AddWithValue("@PORTERIDS", porterIds ?? string.Empty);
                    cmd.Parameters.AddWithValue("@MIINDEX", miIndex ?? "0");

                    cmd.ExecuteNonQuery();
                }
            }

            RespondWithJson(new { success = true });
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, message = ex.Message });
        }
    }

    //[WebMethod]
    //[ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    //public static object OnHoldTasks(HoldTaskPayload payload)
    //{
    //    try
    //    {
    //        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

    //        using (SqlConnection conn = new SqlConnection(connectionString))
    //        {
    //            conn.Open();
    //            using (SqlCommand cmd = new SqlCommand("SP_SETONHOLD_EQUANS", conn))
    //            {
    //                cmd.CommandType = CommandType.StoredProcedure;

    //                cmd.Parameters.AddWithValue("@REQUESTID", payload.REQUESTID);
    //                cmd.Parameters.AddWithValue("@ONHOLDREMARKS", payload.REASON);
    //                cmd.Parameters.AddWithValue("@USERID", payload.USERID ?? string.Empty);
    //                cmd.Parameters.AddWithValue("@PORTERIDS", payload.PORTERIDS ?? string.Empty);
    //                cmd.Parameters.AddWithValue("@MIINDEX", payload.MIINDEX ?? "0");

    //                cmd.ExecuteNonQuery();
    //            }
    //        }

    //        return new { success = true };
    //    }
    //    catch (Exception ex)
    //    {
    //        return new { success = false, message = ex.Message };
    //    }
    //}


    private void HandleReleaseOnHold()
    {
        try
        {
            HttpContext.Current.Request.InputStream.Position = 0;
            string body = new StreamReader(HttpContext.Current.Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string encRequestId = data.ContainsKey("requestId") ? data["requestId"] : null;
            string encUserId = data.ContainsKey("userId") ? data["userId"] : null;

            string requestId = !string.IsNullOrEmpty(encRequestId) ? AESEncrytDecry.DecryptStringAES(encRequestId) : null;
            string userId = !string.IsNullOrEmpty(encUserId) ? AESEncrytDecry.DecryptStringAES(encUserId) : null;

            if (string.IsNullOrWhiteSpace(requestId))
            {
                RespondWithJson(new { success = false, message = "Missing requestId" });
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("SP_RELEASEONHOLD_EQUANS", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@REQUESTID", requestId);
                cmd.Parameters.AddWithValue("@USERID", userId ?? string.Empty);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            RespondWithJson(new { success = true });
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, message = ex.Message });
        }
    }
    public class HoldTaskPayload
    {
        public string REQUESTID { get; set; }
        public string REASON { get; set; }
        public string USERID { get; set; }
        public string PORTERIDS { get; set; }
        public string MIINDEX { get; set; }
    }

    [WebMethod]
    public static string GetDropdownData(string serviceId)
    {
        if (string.IsNullOrEmpty(serviceId)) serviceId = "1";

        DataSet ds = new DataSet();
        string connString = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

        using (SqlConnection con = new SqlConnection(connString))
        using (SqlCommand cmd = new SqlCommand("SP_EDITFILTEROPTIONS", con))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@SERVICEID", serviceId);

            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                da.Fill(ds);
            }
        }

        var result = new
        {
            categories = ds.Tables.Count > 0 ? DataTableToList(ds.Tables[0]) : new List<Dictionary<string, object>>(),
            locations = ds.Tables.Count > 1 ? DataTableToList(ds.Tables[1]) : new List<Dictionary<string, object>>(),
            equipment = ds.Tables.Count > 2 ? DataTableToList(ds.Tables[2]) : new List<Dictionary<string, object>>(),
            remarks = ds.Tables.Count > 3 ? DataTableToList(ds.Tables[3]) : new List<Dictionary<string, object>>()
        };

        return new JavaScriptSerializer().Serialize(result);
    }

    private static List<Dictionary<string, object>> DataTableToList(DataTable dt)
    {
        var list = new List<Dictionary<string, object>>();
        foreach (DataRow row in dt.Rows)
        {
            var dict = new Dictionary<string, object>();
            foreach (DataColumn col in dt.Columns)
            {
                dict[col.ColumnName] = row[col];
            }
            list.Add(dict);
        }
        return list;
    }


    private DataSet ResumeTask()
    {
        //Process=ONHOLDTASK&REASON=" + Reason + "&USERID=" + UID + "&REQUESTID=" + ReqID + "&PORTERIDS=" + PoreterID + "&MIINDEX=" + GMIndex,
        string RequestID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString().Trim().ToUpper(),
              User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString();
        DataTable table;
        if (User == string.Empty)
        {
            table = generate();
            DataRow row = table.NewRow();
            row["RESULT"] = "FALSE";
            table.Rows.Add(row);
        }
        else
            table = DataAccess.ResumeHoldTask(RequestID, User);

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet upldateLocation()
    {
        string ReqId = ((!string.IsNullOrEmpty(Request.QueryString["REQUEST"])) ? Request.QueryString["REQUEST"].ToString() : ""),
            DestID = ((!string.IsNullOrEmpty(Request.QueryString["DID"])) ? Request.QueryString["DID"].ToString() : ""),
        UserID = ((!string.IsNullOrEmpty(Request.QueryString["USERID"])) ? Request.QueryString["USERID"].ToString() : ""),
        TagID = ((!string.IsNullOrEmpty(Request.QueryString["TAGID"])) ? Request.QueryString["TAGID"].ToString() : ""),
        Dloc = ((!string.IsNullOrEmpty(Request.QueryString["DLOC"])) ? Request.QueryString["DLOC"].ToString() : ""),
        CID = ((!string.IsNullOrEmpty(Request.QueryString["CID"])) ? Request.QueryString["CID"].ToString() : ""),
        CName = ((!string.IsNullOrEmpty(Request.QueryString["CNAME"])) ? Request.QueryString["CNAME"].ToString() : ""),
        CCName = ((!string.IsNullOrEmpty(Request.QueryString["CCAT"])) ? Request.QueryString["CCAT"].ToString() : ""),
        IsMultiPorter = ((!string.IsNullOrEmpty(Request.QueryString["MT"])) ? Request.QueryString["MT"].ToString() : "");
        string RQuery = "UPDATE REQUESTMASTER SET DESTINATIONLOCATIONID = '" + DestID + "' " + ((CID.Length > 0) ? (", CATEGORYID= '" + CID + "' ") : string.Empty) + ((CID == "6") ? ", ISMULTIPORTER = 0 " : ", ISMULTIPORTER = '" + IsMultiPorter + "' ") + "  WHERE REQUESTID = '" + ReqId + "'";
        DataTable table;
        table = DataAccess.updateLocation(ReqId, DestID, Dloc, TagID, UserID, RQuery, CName, CCName);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet UpdateRecords()
    {
        string Status = ((!string.IsNullOrEmpty(Request.QueryString["Status"])) ? (Convert.ToInt32(Request.QueryString["Status"].ToString()) + 1).ToString() : ""),
            ReqId = ((!string.IsNullOrEmpty(Request.QueryString["REQUEST"])) ? Request.QueryString["REQUEST"].ToString() : "").Replace("_", "'").Replace("-", ","),
            Source = ((!string.IsNullOrEmpty(Request.QueryString["SOURCE"])) ? Request.QueryString["SOURCE"].ToString() : ""),
            Halt1 = (string.IsNullOrEmpty(Request.QueryString["HALT1"])) ? "" : Request.QueryString["HALT1"].ToString().Trim().ToUpper(),
            Halt2 = (string.IsNullOrEmpty(Request.QueryString["HALT2"])) ? "" : Request.QueryString["HALT2"].ToString().Trim().ToUpper(),
            Destination = ((!string.IsNullOrEmpty(Request.QueryString["DESTINATION"])) ? Request.QueryString["DESTINATION"].ToString() : ""),
            Category = ((!string.IsNullOrEmpty(Request.QueryString["CATEGORY"])) ? Request.QueryString["CATEGORY"].ToString() : ""),
            Remarks = ((!string.IsNullOrEmpty(Request.QueryString["REMARKS"])) ? Request.QueryString["REMARKS"].ToString() : ""),
            MultiPorter = (string.IsNullOrEmpty(Request.QueryString["ISMULTIPORTER"])) ? "" : Request.QueryString["ISMULTIPORTER"].ToString(),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString();
        DataTable table;
        if (User == string.Empty)
        {
            table = generate();
            DataRow row = table.NewRow();
            row["RESULT"] = "FALSE";
            table.Rows.Add(row);
        }
        else
            table = (Status != "101") ? DataAccess.RequestMaster(string.Empty, ReqId, Source, Halt1, Halt2, Destination, User, Category, Remarks, Status, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, process, string.Empty, MultiPorter, string.Empty, string.Empty)
                                         : DataAccess.PreBookingMaster(User, string.Empty, "CANCEL", string.Empty, string.Empty, ReqId, Remarks);

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet InsertRequest()
    {
        bool res = false;
        string remarks = (string.IsNullOrEmpty(Request.QueryString["REMARK"])) ? "" : Request.QueryString["REMARK"].ToString(),
            patientName = (string.IsNullOrEmpty(Request.QueryString["PATIENTNAME"])) ? "" : Request.QueryString["PATIENTNAME"].ToString(),
            Source = (string.IsNullOrEmpty(Request.QueryString["SOURCE"])) ? "" : Request.QueryString["SOURCE"].ToString(),
            Destination = (string.IsNullOrEmpty(Request.QueryString["DESTINATION"])) ? "" : Request.QueryString["DESTINATION"].ToString(),
            Halt1 = (string.IsNullOrEmpty(Request.QueryString["HALT1"])) ? "" : Request.QueryString["HALT1"].ToString().Trim().ToUpper(),
            Halt2 = (string.IsNullOrEmpty(Request.QueryString["HALT2"])) ? "" : Request.QueryString["HALT2"].ToString().Trim().ToUpper(),
            Category = (string.IsNullOrEmpty(Request.QueryString["CATEGORY"])) ? "" : Request.QueryString["CATEGORY"].ToString(),
            Date = DateTime.Now.Date.ToString("MM/dd/yyyy") + " " + ((string.IsNullOrEmpty(Request.QueryString["TIME"])) ? "" : Request.QueryString["TIME"].ToString()),
            Priority = (string.IsNullOrEmpty(Request.QueryString["PRIORITY"])) ? "" : Request.QueryString["PRIORITY"].ToString(),
            MultiPorter = (string.IsNullOrEmpty(Request.QueryString["ISMULTIPORTER"])) ? "" : Request.QueryString["ISMULTIPORTER"].ToString(),
            user = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString(),
            prebooking = (string.IsNullOrEmpty(Request.QueryString["PREBOOKING"])) ? "," : Request.QueryString["PREBOOKING"].ToString(),
            MRD = (string.IsNullOrEmpty(Request.QueryString["MRD"])) ? "" : Request.QueryString["MRD"].ToString(),
            ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : "");
        DataTable table = generate();
        DataRow row = table.NewRow();
        if (user == string.Empty)
            row["RESULT"] = "FALSE";
        else
        {
            DataTable Dt = DataAccess.RequestMaster(Date, string.Empty, Source, Halt1, Halt2, Destination, user, Category, remarks, "", string.Empty, string.Empty, patientName, MRD, string.Empty, Priority, "INSERT", prebooking, MultiPorter, string.Empty, string.Empty);
            // res = (Dt.Rows[0]["RESULT"].ToString() == "TRUE");
            row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
        }
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    public DataSet MTPorters()
    {
        string ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : "");

        DataSet dt = new DataSet();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_GETPORTERS_MT", Con);
        cmd.Parameters.AddWithValue("@SERVICEID", AESEncrytDecry.DecryptStringAES(ServiceID.Trim()));
        cmd.CommandTimeout = 1000;
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {


        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;

    }
    public DataSet GetPorterLocationInfo()
    {

        DataSet dt = new DataSet();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_GETPORTERS_MT", Con);
        cmd.CommandTimeout = 1000;
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {


        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;

    }
    private DataSet NewRequest()
    {
        string PBDate = Request.QueryString["PBDATE"] ?? "",
               Category = Request.QueryString["CATEGORY"] ?? "",
               From = Request.QueryString["FROM"] ?? "",
               To = Request.QueryString["TO"] ?? "",
               Halt1 = Request.QueryString["HALT1"] ?? "",
               Halt2 = Request.QueryString["HALT2"] ?? "",
               MultiPorter = Request.QueryString["MULTIPORTER"] ?? "",
               patientName = Request.QueryString["PATIENTNAME"] ?? "",
               remarks = Request.QueryString["REMARKS"] ?? "",
               user = Request.QueryString["USERID"] ?? "",
               Priority = Request.QueryString["PRIORITY"] ?? "",
               Extra = Request.QueryString["EXTRAFIELDS"] ?? "",
               qty = Request.QueryString["Qty"] ?? "",
               Requestor = Request.QueryString["REQUESTOR"] ?? "",
               ServiceID = Request.QueryString["SERVICEID"] ?? "",
               Kitchen = Request.QueryString["KITCHEN"] ?? "0",
               Equipment = Request.QueryString["EQUIPMENT"] ?? "";

        PBDate = AESEncrytDecry.DecryptStringAES(PBDate);
        if (PBDate == "Invalid Input") PBDate = "";
        Category = AESEncrytDecry.DecryptStringAES(Category);
        From = AESEncrytDecry.DecryptStringAES(From);
        To = AESEncrytDecry.DecryptStringAES(To);
        Halt1 = AESEncrytDecry.DecryptStringAES(Halt1);
        Halt2 = AESEncrytDecry.DecryptStringAES(Halt2);
        MultiPorter = AESEncrytDecry.DecryptStringAES(MultiPorter);
        patientName = AESEncrytDecry.DecryptStringAES(patientName);
        remarks = AESEncrytDecry.DecryptStringAES(remarks);
        user = AESEncrytDecry.DecryptStringAES(user);
        Priority = AESEncrytDecry.DecryptStringAES(Priority);
        Extra = AESEncrytDecry.DecryptStringAES(Extra);
        qty = AESEncrytDecry.DecryptStringAES(qty);
        Requestor = AESEncrytDecry.DecryptStringAES(Requestor);
        ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);
        Kitchen = AESEncrytDecry.DecryptStringAES(Kitchen);
        Equipment = AESEncrytDecry.DecryptStringAES(Equipment);

        DataTable table = generate();
        DataRow row = table.NewRow();

        DataTable Dt = DataAccess.InsertRequest(
            PBDate, Category, From, To, MultiPorter, patientName, remarks, user,
            Priority, Halt1, Halt2, Extra, qty, Requestor, ServiceID,
            Kitchen, Equipment
        );

        if (Dt != null && Dt.Rows.Count > 0)
        {
            row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
        }
        else
        {
            row["RESULT"] = "FALSE";
        }

        table.Rows.Add(row);

        DataSet DS = new DataSet();
        DS.Tables.Add(table);
        return DS;
    }



    //private DataSet NewRequest()
    //{
    //    string PBDate = Request.QueryString["PBDATE"] ?? "",
    //           Category = Request.QueryString["CATEGORY"] ?? "",
    //           From = Request.QueryString["FROM"] ?? "",
    //           To = Request.QueryString["TO"] ?? "",
    //           Halt1 = Request.QueryString["HALT1"] ?? "",
    //           Halt2 = Request.QueryString["HALT2"] ?? "",
    //           MultiPorter = Request.QueryString["MULTIPORTER"] ?? "",
    //           patientName = Request.QueryString["PATIENTNAME"] ?? "",
    //           remarks = Request.QueryString["REMARKS"] ?? "",
    //           user = Request.QueryString["USERID"] ?? "",
    //           Priority = Request.QueryString["PRIORITY"] ?? "",
    //           Extra = Request.QueryString["EXTRAFIELDS"] ?? "",
    //           qty = Request.QueryString["Qty"] ?? "",
    //           Requestor = Request.QueryString["REQUESTOR"] ?? "",
    //           ServiceID = Request.QueryString["SERVICEID"] ?? "",
    //           Kitchen = Request.QueryString["KITCHEN"] ?? "",
    //           Equipment = Request.QueryString["EQUIPMENT"] ?? "",
    //           VerifyDelivery = Request.QueryString["VERIFYDELIVERY"] ?? "0";

    //    byte[] fileBytes = null;
    //    if (Request.Files.Count > 0 && Request.Files["fileVerifyImage"] != null)
    //    {
    //        HttpPostedFile uploadedFile = Request.Files["fileVerifyImage"];
    //        using (BinaryReader reader = new BinaryReader(uploadedFile.InputStream))
    //        {
    //            fileBytes = reader.ReadBytes(uploadedFile.ContentLength);
    //        }
    //    }

    //    DataTable table = generate();
    //    DataRow row = table.NewRow();

    //    DataTable Dt = DataAccess.InsertRequest(
    //        PBDate, Category, From, To, MultiPorter, patientName, remarks, user,
    //        Priority, Halt1, Halt2, Extra, qty, Requestor, ServiceID,
    //        Kitchen, Equipment, VerifyDelivery, fileBytes 
    //    );

    //    row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
    //    table.Rows.Add(row);

    //    DataSet DS = new DataSet();
    //    DS.Tables.Add(table);
    //    return DS;
    //}


    //    private DataSet NewRequest()
    //    {
    //        //Process=INSERTREQUEST&PBDATE=" + PBDTime + "&CATEGORY=" + ReqCat + "&FROM=" + RFromID + "&TO=" + RToID + "&MULTIPORTER=" + IsMultiPorter + "&PATIENTNAME=" + PatientName + "&REMARKS=" + Remarks+ "&USERID=" + UID + "&PRIORITY=0&EXTRAFIELDS="
    //        bool res = false;
    //        string PBDate = (string.IsNullOrEmpty(Request.QueryString["PBDATE"])) ? "" : Request.QueryString["PBDATE"].ToString(),
    //Category = (string.IsNullOrEmpty(Request.QueryString["CATEGORY"]) || 
    //            Request.QueryString["CATEGORY"] == "0") ? "447" : Request.QueryString["CATEGORY"].ToString(),
    //                From = (string.IsNullOrEmpty(Request.QueryString["FROM"])) ? "" : Request.QueryString["FROM"].ToString(),
    //                To = (string.IsNullOrEmpty(Request.QueryString["TO"])) ? "" : Request.QueryString["TO"].ToString(),
    //                Halt1 = (string.IsNullOrEmpty(Request.QueryString["HALT1"])) ? "" : Request.QueryString["HALT1"].ToString(),
    //                Halt2 = (string.IsNullOrEmpty(Request.QueryString["HALT2"])) ? "" : Request.QueryString["HALT2"].ToString(),
    //                MultiPorter = (string.IsNullOrEmpty(Request.QueryString["MULTIPORTER"])) ? "" : Request.QueryString["MULTIPORTER"].ToString(),
    //                patientName = (string.IsNullOrEmpty(Request.QueryString["PATIENTNAME"])) ? "" : Request.QueryString["PATIENTNAME"].ToString(),
    //                remarks = (string.IsNullOrEmpty(Request.QueryString["REMARKS"])) ? "" : Request.QueryString["REMARKS"].ToString(),
    //                Date = DateTime.Now.Date.ToString("MM/dd/yyyy") + " " + ((string.IsNullOrEmpty(Request.QueryString["TIME"])) ? "" : Request.QueryString["TIME"].ToString()),
    //                user = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString(),
    //                Priority = (string.IsNullOrEmpty(Request.QueryString["PRIORITY"])) ? "" : Request.QueryString["PRIORITY"].ToString(),
    //                Extra = (string.IsNullOrEmpty(Request.QueryString["EXTRAFIELDS"])) ? "" : Request.QueryString["EXTRAFIELDS"].ToString(),
    //                qty = (string.IsNullOrEmpty(Request.QueryString["Qty"])) ? "" : Request.QueryString["Qty"].ToString(),
    //                Requestor = (string.IsNullOrEmpty(Request.QueryString["REQUESTOR"])) ? "" : Request.QueryString["REQUESTOR"].ToString(),
    //                ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : ""),
    //                Kitchen = ((!string.IsNullOrEmpty(Request.QueryString["KITCHEN"])) ? Request.QueryString["KITCHEN"].ToString() : ""),
    //                Equipment = ((!string.IsNullOrEmpty(Request.QueryString["EQUIPMENT"])) ? Request.QueryString["EQUIPMENT"].ToString() : ""),
    //                VerifyDelivery = (!string.IsNullOrEmpty(Request.QueryString["VERIFYDELIVERY"])) ? Request.QueryString["VERIFYDELIVERY"].ToString() : "";

    //        DataTable table = generate(); DataRow row = table.NewRow();
    //        PBDate = AESEncrytDecry.DecryptStringAES(PBDate); Category = AESEncrytDecry.DecryptStringAES(Category); From = AESEncrytDecry.DecryptStringAES(From); To = AESEncrytDecry.DecryptStringAES(To); MultiPorter = AESEncrytDecry.DecryptStringAES(MultiPorter);
    //        patientName = AESEncrytDecry.DecryptStringAES(patientName); remarks = AESEncrytDecry.DecryptStringAES(remarks); user = AESEncrytDecry.DecryptStringAES(user); Priority = AESEncrytDecry.DecryptStringAES(Priority); Halt1 = AESEncrytDecry.DecryptStringAES(Halt1);
    //        Halt2 = AESEncrytDecry.DecryptStringAES(Halt2); Extra = AESEncrytDecry.DecryptStringAES(Extra); qty = AESEncrytDecry.DecryptStringAES(qty); ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);
    //        Requestor = AESEncrytDecry.DecryptStringAES(Requestor); Kitchen = AESEncrytDecry.DecryptStringAES(Kitchen); Equipment = AESEncrytDecry.DecryptStringAES(Equipment); VerifyDelivery = AESEncrytDecry.DecryptStringAES(VerifyDelivery);


    //        if (PBDate != "Invalid Input" && Category != "Invalid Input" && From != "Invalid Input" && To != "Invalid Input" && MultiPorter != "Invalid Input" && patientName != "Invalid Input" && remarks != "Invalid Input" &&
    //            user != "Invalid Input" && Priority != "Invalid Input" && Halt1 != "Invalid Input" && Halt2 != "Invalid Input" && Extra != "Invalid Input" && qty != "Invalid Input" && Requestor != "Invalid Input"
    //            && ServiceID != "Invalid Input" && Kitchen != "Invalid Input") 
    //        {
    //            DataTable Dt = DataAccess.InsertRequest(PBDate, Category, From, To, MultiPorter, patientName, remarks, user, Priority, Halt1, Halt2, Extra, qty, Requestor, ServiceID, Kitchen, Equipment, VerifyDelivery);
    //            row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
    //        }
    //        else
    //            row["RESULT"] = "FALSE";
    //        table.Rows.Add(row);
    //        DataSet DS = new DataSet(); DS.Tables.Add(table);
    //        return DS;
    //    }

    public static string DecryptStringAES(string cipherText)
    {
        try
        {
            byte[] buffer = Convert.FromBase64String(cipherText); 

            byte[] key = Encoding.UTF8.GetBytes("9090909090909090"); 
            byte[] iv = Encoding.UTF8.GetBytes("9090909090909090");  

            using (Aes aes = Aes.Create())
            {
                aes.Key = key;
                aes.IV = iv;
                aes.Mode = CipherMode.CBC;      
                aes.Padding = PaddingMode.PKCS7;

                ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, aes.IV);
                using (MemoryStream ms = new MemoryStream(buffer))
                using (CryptoStream cs = new CryptoStream(ms, decryptor, CryptoStreamMode.Read))
                using (StreamReader sr = new StreamReader(cs))
                {
                    return sr.ReadToEnd();
                }
            }
        }
        catch
        {
            return null;
        }
    }

    private DataSet DuplicateRquest()
    {
        //Process=INSERTREQUEST&PBDATE=" + PBDTime + "&CATEGORY=" + ReqCat + "&FROM=" + RFromID + "&TO=" + RToID + "&MULTIPORTER=" + IsMultiPorter + "&PATIENTNAME=" + PatientName + "&REMARKS=" + Remarks+ "&USERID=" + UID + "&PRIORITY=0&EXTRAFIELDS="
        bool res = false;
        string ReqID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString(),
                user = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString();

        DataTable table = generate(); DataRow row = table.NewRow();
        ReqID = AESEncrytDecry.DecryptStringAES(ReqID); user = AESEncrytDecry.DecryptStringAES(user);

        if (user != "Invalid Input" && ReqID != "Invalid Input")
        {
            DataTable Dt = DataAccess.DuplicateRequest(user, ReqID);
            row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
        }
        else
            row["RESULT"] = "FALSE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }


    //private DataSet UpdateRequest()
    //{
    //    //Process=INSERTREQUEST&PBDATE=" + PBDTime + "&CATEGORY=" + ReqCat + "&FROM=" + RFromID + "&TO=" + RToID + "&MULTIPORTER=" + IsMultiPorter + "&PATIENTNAME=" + PatientName + "&REMARKS=" + Remarks+ "&USERID=" + UID + "&PRIORITY=0&EXTRAFIELDS="
    //    bool res = false;
    //    string PBDate = (string.IsNullOrEmpty(Request.QueryString["PBDATE"])) ? "" : Request.QueryString["PBDATE"].ToString(),
    //            Category = (string.IsNullOrEmpty(Request.QueryString["CATEGORY"])) ? "" : Request.QueryString["CATEGORY"].ToString(),
    //            From = (string.IsNullOrEmpty(Request.QueryString["FROM"])) ? "" : Request.QueryString["FROM"].ToString(),
    //            To = (string.IsNullOrEmpty(Request.QueryString["TO"])) ? "" : Request.QueryString["TO"].ToString(),
    //            MultiPorter = (string.IsNullOrEmpty(Request.QueryString["MULTIPORTER"])) ? "" : Request.QueryString["MULTIPORTER"].ToString(),
    //            patientName = (string.IsNullOrEmpty(Request.QueryString["PATIENTNAME"])) ? "" : Request.QueryString["PATIENTNAME"].ToString(),
    //            remarks = (string.IsNullOrEmpty(Request.QueryString["REMARKS"])) ? "" : Request.QueryString["REMARKS"].ToString(),
    //            Date = DateTime.Now.Date.ToString("MM/dd/yyyy") + " " + ((string.IsNullOrEmpty(Request.QueryString["TIME"])) ? "" : Request.QueryString["TIME"].ToString()),
    //            user = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString(),
    //            Priority = (string.IsNullOrEmpty(Request.QueryString["PRIORITY"])) ? "" : Request.QueryString["PRIORITY"].ToString(),
    //            Extra = (string.IsNullOrEmpty(Request.QueryString["EXTRAFIELDS"])) ? "" : Request.QueryString["EXTRAFIELDS"].ToString(),
    //            RequestID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString(),
    //            StatusID = (string.IsNullOrEmpty(Request.QueryString["STATUS"])) ? "" : Request.QueryString["STATUS"].ToString(),
    //            CompletedRemarks = (string.IsNullOrEmpty(Request.QueryString["COMPLETEREMARKS"])) ? "" : Request.QueryString["COMPLETEREMARKS"].ToString(),
    //            CancelledRemarks = (string.IsNullOrEmpty(Request.QueryString["CANCELREMARKS"])) ? "" : Request.QueryString["CANCELREMARKS"].ToString(),
    //            qty = (string.IsNullOrEmpty(Request.QueryString["QTY"])) ? "" : Request.QueryString["QTY"].ToString(),
    //            Requestor = (string.IsNullOrEmpty(Request.QueryString["REQUESTOR"])) ? "" : Request.QueryString["REQUESTOR"].ToString(),
    //            modifiedvalus = (string.IsNullOrEmpty(Request.QueryString["MODIFIEDVALUS"])) ? "" : Request.QueryString["MODIFIEDVALUS"].ToString(),
    //            ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : ""),
    //            Kitchen = ((!string.IsNullOrEmpty(Request.QueryString["KITCHEN"])) ? Request.QueryString["KITCHEN"].ToString() : ""),
    //            Equipment = ((!string.IsNullOrEmpty(Request.QueryString["EQUIPMENT"])) ? Request.QueryString["EQUIPMENT"].ToString() : ""),
    //            VerifyDelivery = (!string.IsNullOrEmpty(Request.QueryString["VERIFYDELIVERY"])) ? Request.QueryString["VERIFYDELIVERY"].ToString() : "";




    //    DataTable table = generate(); DataRow row = table.NewRow();
    //    PBDate = AESEncrytDecry.DecryptStringAES(PBDate); Category = AESEncrytDecry.DecryptStringAES(Category); From = AESEncrytDecry.DecryptStringAES(From); To = AESEncrytDecry.DecryptStringAES(To); MultiPorter = AESEncrytDecry.DecryptStringAES(MultiPorter);
    //    patientName = AESEncrytDecry.DecryptStringAES(patientName); remarks = AESEncrytDecry.DecryptStringAES(remarks); user = AESEncrytDecry.DecryptStringAES(user); Priority = AESEncrytDecry.DecryptStringAES(Priority);
    //    Extra = AESEncrytDecry.DecryptStringAES(Extra); qty = AESEncrytDecry.DecryptStringAES(qty); Requestor = AESEncrytDecry.DecryptStringAES(Requestor); modifiedvalus = AESEncrytDecry.DecryptStringAES(modifiedvalus); CancelledRemarks = AESEncrytDecry.DecryptStringAES(CancelledRemarks);
    //    CompletedRemarks = AESEncrytDecry.DecryptStringAES(CompletedRemarks); RequestID = AESEncrytDecry.DecryptStringAES(RequestID); StatusID = AESEncrytDecry.DecryptStringAES(StatusID);
    //    ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID); Kitchen = AESEncrytDecry.DecryptStringAES(Kitchen); Equipment = AESEncrytDecry.DecryptStringAES(Equipment); VerifyDelivery = AESEncrytDecry.DecryptStringAES(VerifyDelivery);


    //    if (PBDate != "Invalid Input" && Category != "Invalid Input" && From != "Invalid Input" && To != "Invalid Input" && MultiPorter != "Invalid Input" && patientName != "Invalid Input" && remarks != "Invalid Input" && user != "Invalid Input" && Priority != "Invalid Input"
    //         && Extra != "Invalid Input" && qty != "Invalid Input" && Requestor != "Invalid Input" && modifiedvalus != "Invalid Input" && CancelledRemarks != "Invalid Input" && CompletedRemarks != "Invalid Input" && RequestID != "Invalid Input" && StatusID != "Invalid Input"
    //         && Kitchen != "Invalid Input" && ServiceID != "Invalid Input")
    //    {
    //        DataTable Dt;
    //        if (PBDate == "")
    //            Dt = DataAccess.UpdateRequest(PBDate, Category, From, To, MultiPorter, patientName, remarks, user, Priority, Extra, RequestID, StatusID, CompletedRemarks, CancelledRemarks, qty, Requestor, ServiceID, Kitchen);
    //        else
    //            Dt = DataAccess.UpdateRequestPreBook(PBDate, Category, From, To, MultiPorter, patientName, remarks, user, Priority, Extra, RequestID, StatusID, CompletedRemarks, CancelledRemarks, qty, Requestor, ServiceID, Kitchen);
    //        row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
    //    }
    //    else
    //        row["RESULT"] = "FALSE";
    //    if (modifiedvalus.Length > 0)
    //        DataAccess.AddRequestLog(RequestID, modifiedvalus, user, "0");
    //    table.Rows.Add(row);
    //    DataSet DS = new DataSet(); DS.Tables.Add(table);
    //    return DS;
    //}


    private DataSet GetDeptIdlePorters()
    {
        string PName = ((!string.IsNullOrEmpty(Request.QueryString["PORTERNAME"])) ? Request.QueryString["PORTERNAME"].ToString() : ""),
             PorterID1 = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID1"])) ? Request.QueryString["PORTERID1"].ToString() : ""),
             PorterID2 = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID2"])) ? Request.QueryString["PORTERID2"].ToString() : ""),
            IsInitiate = ((!string.IsNullOrEmpty(Request.QueryString["ISINITIATE"])) ? Request.QueryString["ISINITIATE"].ToString() : ""),
            Dept = ((!string.IsNullOrEmpty(Request.QueryString["DEPT"])) ? Request.QueryString["DEPT"].ToString() : "");
        DataTable table = new DataTable();
        table = DataAccess.GetDeptIdlePorters(PName, Dept, IsInitiate, PorterID1, PorterID2).Copy();
        DataSet DS = new DataSet(); DS.Tables.Add(ModifyPorter(table));
        return DS;
    }
    private DataTable ModifyPorter(DataTable dataTable)
    {
        if (dataTable.Rows.Count > 0)
        {
            foreach (DataRow dr in dataTable.Rows)
            {
                dr["PHOTO"] = (string.IsNullOrEmpty(dr["IMAGE"].ToString().Trim()) ? string.Empty : GetPath(dr["IMAGE"]));
            }
        }
        return dataTable;
    }


    private DataSet GetLocationRecords()
    {
        var sb = new StringBuilder();
        string FloorId = ((!string.IsNullOrEmpty(Request.QueryString["FLOORID"])) ? Request.QueryString["FLOORID"].ToString() : "");
        HtmlTable Tmptable = new HtmlTable() { Width = "90%" }; Tmptable.Attributes.Add("style", "margin-left:10%;"); Tmptable.Attributes.Add("class", "ZoneLocation");
        foreach (DataRow dr in DataAccess.LocationMaster(string.Empty, string.Empty, FloorId, false, "GETBYFLOOR").Rows)
        {
            HtmlTableRow tr = new HtmlTableRow(); HtmlTableCell tc = new HtmlTableCell() { Align = "left" }; RadioButton RBtn = new RadioButton() { ID = "Loc-" + dr["Id"].ToString(), Text = dr["Location"].ToString().Trim().ToUpper(), ClientIDMode = ClientIDMode.Static, GroupName = dr["Location"].ToString() };
            RBtn.Attributes.Add("onclick", "CloseandBind('" + dr["Id"] + "','" + dr["Location"].ToString().Trim().ToUpper() + "')");
            RBtn.Attributes.Add("style", "font-family: Arial; font-weight: bold; color: rgb(30, 70, 129);padding:8px;");
            tr.Controls.Add(tc); tc.Controls.Add(RBtn); Tmptable.Controls.Add(tr);
        }
        Tmptable.RenderControl(new HtmlTextWriter(new StringWriter(sb)));
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = sb.ToString();
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }


    private DataSet GetMasterRecords()
    {
        StringBuilder sb = new StringBuilder(), sb1 = new StringBuilder(), sb2 = new StringBuilder(); string EPEServer = ConfigurationManager.AppSettings["EPEServer"].ToString(), AppPort = ConfigurationManager.AppSettings["AppPort"].ToString();
        string FloorId = ((!string.IsNullOrEmpty(Request.QueryString["FLOORID"])) ? Request.QueryString["FLOORID"].ToString() : "");
        HtmlTable Tmptable = new HtmlTable() { Width = "90%", CellPadding = 10, CellSpacing = 10 }, tmpCatTble = new HtmlTable() { Width = "100%" }; Tmptable.Attributes.Add("style", "margin-left:10%;");
        HtmlTableRow tmpCatRow = new HtmlTableRow() { Height = "100px" }; HtmlTableCell tmpCatCell = new HtmlTableCell();
        DataSet DS = DataAccess.getRecords("SP_GETLOCCATRECORDS"); int InnerCnt = 0;
        for (int i = 0; i < DS.Tables.Count; i++)
        {

            Tmptable = new HtmlTable() { Width = "90%" };
            foreach (DataRow dr in DS.Tables[i].Rows)
            {
                HtmlTableRow tr = new HtmlTableRow(), tr1 = new HtmlTableRow(); HtmlTableCell tc = new HtmlTableCell() { Align = "left" }, tc1 = new HtmlTableCell() { Align = "center" }, tc2 = new HtmlTableCell() { Width = "45%" }; RadioButton RBtn = new RadioButton() { ID = ((i == 1) ? "Cat-" : (i == 2) ? "CatD-" : "Loc-") + dr["Id"].ToString(), Text = dr[((i > 0) ? "CategoryName" : "Location")].ToString().Trim().ToUpper(), ClientIDMode = ClientIDMode.Static, GroupName = dr[((i > 0) ? "CategoryName" : "Location")].ToString() };
                if (i > 0)
                {   //Category
                    if (InnerCnt == 3) { tmpCatTble.Rows.Add(tmpCatRow); tc.Controls.Add(tmpCatTble); InnerCnt = 0; }
                    if (InnerCnt == 0) { tmpCatTble = new HtmlTable(); tmpCatRow = new HtmlTableRow() { Height = "100px" }; tmpCatTble.Attributes.Add("style", "width:100%"); }
                    tmpCatCell = new HtmlTableCell() { Width = "32%", Align = "center" };
                    HtmlGenericControl Div = new HtmlGenericControl("div") { ID = "Cat-" + dr["Id"].ToString(), ClientIDMode = ClientIDMode.Static };
                    HtmlGenericControl DivOverlay = new HtmlGenericControl("div"); HtmlGenericControl DivText = new HtmlGenericControl("div");
                    DivOverlay.Attributes.Add("class", "categoryOverlay"); DivText.Attributes.Add("class", "categoryText"); DivText.InnerText = dr["CATEGORYNAME"].ToString().Trim();
                    Div.Attributes.Add("onclick", (i == 2) ? ("CloseandEBind('" + dr["Id"] + "','" + dr["CATEGORYNAME"].ToString().Trim() + "','" + dr["SCATEGORYNAME"].ToString().Trim() + "')") : ("CloseandBind('" + dr["ID"] + "','" + dr["MIMAGE"].ToString().Trim() + "','" + dr["MRD"].ToString().Trim() + "')")); Div.Attributes.Add("align", "center"); Div.Attributes.Add("class", "Category");
                    HtmlImage Img = new HtmlImage() { Src = ConfigurationManager.AppSettings["HTTP"].ToString() + "://" + EPEServer + ":" + AppPort + "/RequestNew/images/Category/" + dr["MIMAGE"].ToString() };
                    Img.Attributes.Add("class", "CatImages"); Div.Controls.Add(Img); DivOverlay.Controls.Add(DivText); Div.Controls.Add(DivOverlay);
                    tmpCatCell.Controls.Add(Div); tmpCatRow.Cells.Insert(InnerCnt, tmpCatCell); InnerCnt++;

                    if (DS.Tables[i].Rows.IndexOf(dr) == (DS.Tables[i].Rows.Count - 1)) { for (int j = 0; j < (3 - InnerCnt); j++) { HtmlTableCell EmptyCell = new HtmlTableCell() { Width = "32%" }; tmpCatRow.Cells.Add(EmptyCell); } tmpCatTble.Rows.Add(tmpCatRow); tmpCatTble.Attributes.Add("style", "width:100%"); tc.Controls.Add(tmpCatTble); InnerCnt = 0; }
                }
                else
                {
                    Tmptable.Attributes.Add("style", "margin-left:10%;"); Tmptable.Attributes.Add("class", "ZoneLocation");
                    RBtn.Attributes.Add("onclick", "CloseandBind('" + dr["Id"] + "','" + dr["Location"].ToString().Trim().ToUpper() + "','" + dr["BEDID"].ToString().Trim().ToUpper() + "')");
                    RBtn.Attributes.Add("style", "font-family: Arial; font-weight: bold; color: rgb(30, 70, 129);padding:8px;");
                    tc.Controls.Add(RBtn);
                }
                tr.Controls.Add(tc);
                if (tc.HasControls())
                    Tmptable.Controls.Add(tr);
            }

            if (sb.Length == 0)
                Tmptable.RenderControl(new HtmlTextWriter(new StringWriter(sb)));
            else if (sb1.Length == 0)
                Tmptable.RenderControl(new HtmlTextWriter(new StringWriter(sb1)));
            else
                Tmptable.RenderControl(new HtmlTextWriter(new StringWriter(sb2)));
        }
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = sb.ToString() + "$$$" + sb1.ToString() + "$$$" + sb2.ToString();
        table.Rows.Add(row);
        DataSet DS1 = new DataSet(); DS1.Tables.Add(table);
        return DS1;
    }
    private DataSet GetRequestLocCatRecords()
    {
        StringBuilder sb = new StringBuilder(), sb1 = new StringBuilder(), sb2 = new StringBuilder(); string EPEServer = ConfigurationManager.AppSettings["EPEServer"].ToString(), AppPort = ConfigurationManager.AppSettings["AppPort"].ToString();
        string FloorId = ((!string.IsNullOrEmpty(Request.QueryString["FLOORID"])) ? Request.QueryString["FLOORID"].ToString() : "");
        HtmlTable Tmptable = new HtmlTable() { Width = "90%", CellPadding = 10, CellSpacing = 10 }, tmpCatTble = new HtmlTable() { Width = "100%" }; Tmptable.Attributes.Add("style", "margin-left:10%;");
        HtmlTableRow tmpCatRow = new HtmlTableRow() { Height = "100px" }; HtmlTableCell tmpCatCell = new HtmlTableCell();
        DataSet DS = DataAccess.getRecords("SP_GETREQUESTCATLOCRECORDS").Copy(); ;
        return DS;
    }

    //private DataSet GetCategories()
    //{
    //    string Value = ((!string.IsNullOrEmpty(Request.QueryString["VAL"])) ? Request.QueryString["VAL"].ToString() : ""),
    //        Value1 = ((!string.IsNullOrEmpty(Request.QueryString["VAL1"])) ? Request.QueryString["VAL1"].ToString() : ""),
    //         ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : "");
    //    DataSet DS = new DataSet();
    //    try
    //    {
    //        DS = DataAccess.GetRecordss("SP_GETREQUESTCATETORIES_EQUANS", "@VAL", AESEncrytDecry.DecryptStringAES(Value), "@VAL1", AESEncrytDecry.DecryptStringAES(Value1), "@SERVICEID", AESEncrytDecry.DecryptStringAES(ServiceID)).Copy();
    //    }
    //    catch (Exception ex)
    //    {
    //        DS = new DataSet();
    //    }
    //    return DS;
    //}

    private DataSet GetCategories()
    {
        string encValue = Request.QueryString["VAL"] ?? "";
        string encValue1 = Request.QueryString["VAL1"] ?? "";
        string encServiceID = Request.QueryString["SERVICEID"] ?? "";

        string Value = AESEncrytDecry.DecryptStringAES(encValue);
        string Value1 = AESEncrytDecry.DecryptStringAES(encValue1);
        string ServiceID = AESEncrytDecry.DecryptStringAES(encServiceID);

        DataSet DS = new DataSet();
        try
        {
            DS = DataAccess.GetRecordss("SP_GETREQUESTCATETORIES_EQUANS",
                "@VAL", Value,
                "@VAL1", Value1,
                "@SERVICEID", ServiceID).Copy();

            // Ensure at least one table exists
            if (DS.Tables.Count == 0)
            {
                DataTable emptyTable = new DataTable("Result");
                emptyTable.Columns.Add("RESULT", typeof(string));
                DataRow row = emptyTable.NewRow();
                row["RESULT"] = "FALSE";
                emptyTable.Rows.Add(row);
                DS.Tables.Add(emptyTable);
            }
        }
        catch (Exception ex)
        {
            // Create empty dataset with error structure
            DataTable errorTable = new DataTable("Result");
            errorTable.Columns.Add("RESULT", typeof(string));
            DataRow row = errorTable.NewRow();
            row["RESULT"] = "ERROR";
            errorTable.Rows.Add(row);
            DS.Tables.Add(errorTable);
        }
        return DS;
    }

    private void GetEquipmentData()
    {
        try
        {
            string val = Request.QueryString["VAL"] ?? "";
            string val1 = Request.QueryString["VAL1"] ?? "";
            string serviceId = Request.QueryString["SERVICEID"] ?? "1";

            string decryptedVal = string.IsNullOrEmpty(val) ? "" : AESEncrytDecry.DecryptStringAES(val);
            string decryptedVal1 = string.IsNullOrEmpty(val1) ? "" : AESEncrytDecry.DecryptStringAES(val1);
            string decryptedServiceId = string.IsNullOrEmpty(serviceId) ? "" : AESEncrytDecry.DecryptStringAES(serviceId);

            DataSet ds = DataAccess.GetRecordss(
                "SP_GETREQUESTEQUIPMENT",
                "@VAL", decryptedVal,
                "@VAL1", decryptedVal1,
                "@SERVICEID", decryptedServiceId
            );

            Response.ContentType = "application/json";

            if (ds != null && ds.Tables != null && ds.Tables.Count > 0 && ds.Tables[0] != null)
            {
                string json = JsonConvert.SerializeObject(ds.Tables[0]);
                Response.Write(json);
            }
            else
            {
                Response.Write("[]");
            }
        }
        catch (Exception ex)
        {
            Response.ContentType = "application/json";
            Response.Write("{\"error\":\"" + ex.Message.Replace("\"", "'") + "\"}");
        }
        finally
        {
            Response.End();
        }
    }

    private DataSet GetSearchedLocationD()
    {
        var sb = new StringBuilder();
        string Location = ((!string.IsNullOrEmpty(Request.QueryString["LOCATION"])) ? Request.QueryString["LOCATION"].ToString() : "");
        HtmlTable Tmptable = new HtmlTable() { Width = "90%" }; Tmptable.Attributes.Add("style", "margin-left:10%;line-height:1.2"); Tmptable.Attributes.Add("class", "ZoneLocation");
        DataTable DtSearchedLocations = new DataTable();
        DtSearchedLocations = DataAccess.GetRecords("SP_SEARCHLOCATION", "@LOCATION", Location);
        foreach (DataRow dr in DtSearchedLocations.Rows)
        {
            HtmlTableRow tr = new HtmlTableRow(); HtmlTableCell tc = new HtmlTableCell() { Align = "left" }; RadioButton RBtn = new RadioButton() { ID = "LocD-" + dr["Id"].ToString(), Text = dr["Location"].ToString().Trim().ToUpper(), ClientIDMode = ClientIDMode.Static, GroupName = dr["Location"].ToString() };
            RBtn.Attributes.Add("onclick", "BindDLocation('" + dr["Id"] + "','" + dr["Location"].ToString().Trim().ToUpper() + "')");
            RBtn.Attributes.Add("style", "font-family: monospace; font-weight: bold; color: rgb(30, 70, 129);padding:8px;");
            tr.Controls.Add(tc); tc.Controls.Add(RBtn); Tmptable.Controls.Add(tr);
        }

        Tmptable.RenderControl(new HtmlTextWriter(new StringWriter(sb)));
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = sb.ToString();
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet GetSearchedLocation()
    {
        var sb = new StringBuilder();
        string Location = ((!string.IsNullOrEmpty(Request.QueryString["LOCATION"])) ? Request.QueryString["LOCATION"].ToString() : ""),
            ServiceID = ((string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? string.Empty : Request.QueryString["SERVICEID"].ToString()),
            sType = ((!string.IsNullOrEmpty(Request.QueryString["STYPE"])) ? Request.QueryString["STYPE"].ToString() : "");

        HtmlTable Tmptable = new HtmlTable() { Width = "90%" }; Tmptable.Attributes.Add("style", "margin-left:10%;"); Tmptable.Attributes.Add("class", "ZoneLocation");


        HtmlGenericControl ul = new HtmlGenericControl("ul"); ul.Attributes.Add("class", "LocationList");


        if (!string.IsNullOrEmpty(Location))
        {
            Location = AESEncrytDecry.DecryptStringAES(Location); sType = AESEncrytDecry.DecryptStringAES(sType); ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);
            DataTable DtSearchedLocations = DataAccess.GetRecords("SP_SEARCHLOCATION", "@LOCATION", Location, "@SERVICEID", ServiceID);
            foreach (DataRow dr in DtSearchedLocations.Rows)
            {
                HtmlGenericControl li = new HtmlGenericControl("li") { ID = sType + "Loc-" + dr["Id"].ToString(), ClientIDMode = ClientIDMode.Static };
                HtmlImage img = new HtmlImage() { Src = "../images/location.png", Width = 30 }; img.Attributes.Add("style", "padding-right:15px;");
                HtmlGenericControl span = new HtmlGenericControl("span") { InnerHtml = dr["ZONENAME"].ToString().Trim().ToUpper() };
                li.Controls.Add(img); li.Controls.Add(span);
                li.Attributes.Add("onclick", "BindLocation('" + dr["Id"] + "','" + dr["ZONENAME"].ToString().Trim().ToUpper() + "','" + sType + "','" + dr["HAYWOOD"].ToString().Trim().ToUpper() + "','" + dr["CATERINGGROUPNAME"] + "','" + dr["LID"].ToString().Trim().ToUpper() + "')");
                ul.Controls.Add(li);
            }

        }
        ul.RenderControl(new HtmlTextWriter(new StringWriter(sb)));
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = sb.ToString();
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    // OLA Module

    private DataSet GetPatientName()
    {
        string BedID = string.IsNullOrEmpty(Request.QueryString["BEDID"]) ? "0" : Request.QueryString["BEDID"].ToString();
        DataTable dt = DataAccess.getPatientName(BedID);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
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
    public DataSet GetRecords()
    {
        string Status = ((!string.IsNullOrEmpty(Request.QueryString["Status"])) ? Request.QueryString["Status"].ToString() : ""),
              From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? Request.QueryString["From"].ToString() : ""),
             To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? Request.QueryString["To"].ToString() : ""),
             Search = ((!string.IsNullOrEmpty(Request.QueryString["Search"])) ? Request.QueryString["Search"].ToString() : ""),
             user = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString(),
             PageSize = ((!string.IsNullOrEmpty(Request.QueryString["PageSize"])) ? Request.QueryString["PageSize"].ToString() : "15"),
             PageIndex = ((!string.IsNullOrEmpty(Request.QueryString["PageIndex"])) ? Request.QueryString["PageIndex"].ToString() : "1"),
             ServiceID = ((string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? string.Empty : Request.QueryString["SERVICEID"].ToString()),
             Role = (string.IsNullOrEmpty(Request.QueryString["ROLE"])) ? string.Empty : Request.QueryString["ROLE"].ToString();


        DataTable dt = new DataTable();
        try
        {
            Search = AESEncrytDecry.DecryptStringAES(Search); user = AESEncrytDecry.DecryptStringAES(user); Role = AESEncrytDecry.DecryptStringAES(Role); Status = AESEncrytDecry.DecryptStringAES(Status);
            PageIndex = AESEncrytDecry.DecryptStringAES(PageIndex); PageSize = AESEncrytDecry.DecryptStringAES(PageSize); ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);

            //if (Status == "100")
            //    dt = DataAccess.PreBookingMaster(user, Role, "GETPENDINGREQUESTS", PageIndex, PageSize, string.Empty, string.Empty);
            //else
            string SortOrder = Request.QueryString["SortOrder"] ?? "asc";
            string FilterTaskId = Request.QueryString["Filter_TaskID"] ?? "";
            string FilterTaskType = Request.QueryString["Filter_TaskType"] ?? "";
            string FilterRequestStatus = Request.QueryString["Filter_RequestStatus"] ?? "";
            string FilterEquipmentType = Request.QueryString["Filter_EquipmentType"] ?? "";
            string FilterFromLocation = Request.QueryString["Filter_FromLocation"] ?? "";
            string FilterToLocation = Request.QueryString["Filter_ToLocation"] ?? "";
            string FilterFromZone = Request.QueryString["Filter_FromZone"] ?? "";
            string FilterToZone = Request.QueryString["Filter_ToZone"] ?? "";
            string FilterEmployee = Request.QueryString["Filter_Employee"] ?? "";

            dt = DataAccess.GetRequests(
                user, Role, Status, PageIndex, PageSize, Search, ServiceID,
                SortOrder,
                FilterTaskId, FilterTaskType, FilterRequestStatus, FilterEquipmentType,
                FilterFromLocation, FilterToLocation,
                FilterFromZone, FilterToZone,
                FilterEmployee
            );



        }
        catch (Exception ex)
        {
            dt = new DataTable();
        }
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;

    }
    public DataSet GetPorterStatus()
    {
        string Status = ((!string.IsNullOrEmpty(Request.QueryString["Status"])) ? Request.QueryString["Status"].ToString() : ""),
        ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : "");

        DataTable dt = new DataTable();
        //if (Status == "100")
        //    dt = DataAccess.PreBookingMaster(user, Role, "GETPENDINGREQUESTS", PageIndex, PageSize, string.Empty, string.Empty);
        //else
        dt = DataAccess.GetPorterStatus(Status, AESEncrytDecry.DecryptStringAES(ServiceID));
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;

    }

    private DataSet MultiAssign()
    {
        string ReqID = ((!string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? Request.QueryString["REQUESTID"].ToString() : "").Replace("_", "'").Replace("-", ","),
                 PorterID = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID"])) ? Request.QueryString["PORTERID"].ToString() : ""),
                 Dept = ((!string.IsNullOrEmpty(Request.QueryString["DEPT"])) ? Request.QueryString["DEPT"].ToString() : "");
        DataTable table = new DataTable();
        table = DataAccess.MultiTasking(ReqID, PorterID, Dept).Copy();
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet ClearManualAssign()
    {
        string Dept = string.IsNullOrEmpty(Request.QueryString["DEPT"]) ? string.Empty : Request.QueryString["DEPT"].ToString();
        DataTable dt = DataAccess.GetRecords("SP_CLEARMANUALPROCESS", "@DEPT", Dept);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }
    private DataSet GetPorterID()
    {
        string RId = ((!string.IsNullOrEmpty(Request.QueryString["RID"])) ? Request.QueryString["RID"].ToString() : "").Replace("_", "'").Replace("-", ",");
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = DataAccess.GetPorter(RId);//(dt.Rows.Count > 0) ? (dt.Rows[0]["MULTIPORTER"].ToString() == "YES") ? (dt.Rows.Count > 1) ? dt.Rows[0]["Id"].ToString() + "_" + dt.Rows[1]["Id"].ToString() : "1001" : dt.Rows[0]["Id"].ToString() : "0";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet CheckUser()
    {

        string UserName = (string.IsNullOrEmpty(Request.QueryString["USERNAME"])) ? "" : Request.QueryString["USERNAME"].ToString(),
            pWord = (string.IsNullOrEmpty(Request.QueryString["PWD"])) ? "" : Request.QueryString["PWD"].ToString(),
            Result = DataAccess.CheckUser(UserName.Trim(), pWord.Trim());
        DataTable table = generate();
        DataRow row = table.NewRow();
        if (Result == "FALSE")
            row["RESULT"] = "FALSE";
        else
            row["RESULT"] = Result; //row["RESULT"] = ((Session["ROLE"].ToString() == "ADMIN") ? "Master/CategoryMaster.aspx" : "Request/Request.aspx");
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet AssignTask()
    {
        string Status = ((!string.IsNullOrEmpty(Request.QueryString["Status"])) ? (Convert.ToInt32(Request.QueryString["Status"].ToString()) + 1).ToString() : ""),
            StartTime = string.Empty, // Auto
            EndTime = string.Empty,   // Not Required
            PortId = ((!string.IsNullOrEmpty(Request.QueryString["PORTID"])) ? Request.QueryString["PORTID"].ToString() : ""),
            ReqId = ((!string.IsNullOrEmpty(Request.QueryString["Request"])) ? Request.QueryString["Request"].ToString() : "").Replace("_", "'").Replace("-", ","),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString();//((!string.IsNullOrEmpty(Request.QueryString["USER"])) ? Request.QueryString["USER"].ToString() : "");
        DataTable table;
        if (User == string.Empty)
        {
            table = generate();
            DataRow row = table.NewRow();
            row["RESULT"] = "FALSE";
            table.Rows.Add(row);
        }
        else
            table = DataAccess.RequestMaster(string.Empty, ReqId, string.Empty, string.Empty, string.Empty, string.Empty, User, string.Empty, string.Empty, Status, StartTime, EndTime, PortId, string.Empty, string.Empty, string.Empty, process, string.Empty, string.Empty, string.Empty, string.Empty);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private void HandleEndRestBreak()
    {
        try
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string encId = data.ContainsKey("id") ? data["id"] : null;
            string idStr = !string.IsNullOrEmpty(encId) ? AESEncrytDecry.DecryptStringAES(encId) : null;

            int id = 0;
            if (string.IsNullOrEmpty(idStr) || !int.TryParse(idStr, out id))
            {
                RespondWithJson(new { success = false, message = "Invalid porter ID" });
                return;
            }

            RespondWithJson(TriggerPorterBreak(id, 0, true));
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, message = ex.Message });
        }
    }

    private void HandleEndMealBreak()
    {
        try
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string encId = data.ContainsKey("id") ? data["id"] : null;
            string idStr = !string.IsNullOrEmpty(encId) ? AESEncrytDecry.DecryptStringAES(encId) : null;

            int id = 0;
            if (string.IsNullOrEmpty(idStr) || !int.TryParse(idStr, out id))
            {
                RespondWithJson(new { success = false, message = "Invalid porter ID" });
                return;
            }

            RespondWithJson(TriggerPorterMealBreak(id, 0, true));
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, message = ex.Message });
        }
    }

    private object TriggerPorterBreak(int id, int duration, bool end)
    {
        try
        {
            string resultMessage = "";
            string process = end ? "ENDBREAK" : "STARTBREAK";
            string connectionString = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("SP_PORTERMASTER_EQUANS", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ID", id);
                cmd.Parameters.AddWithValue("@PROCESS", process);
                cmd.Parameters.AddWithValue("@DURATION", duration);

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        resultMessage = reader["Message"] == DBNull.Value
                            ? ""
                            : reader["Message"].ToString();
                    }
                }
            }

            return new { success = true, message = resultMessage };
        }
        catch (Exception ex)
        {
            return new { success = false, message = ex.Message };
        }
    }

    private object TriggerPorterMealBreak(int id, int duration, bool end)
    {
        try
        {
            string resultMessage = "";
            string process = end ? "ENDUNAVAILABLE" : "STARTUNAVAILABLE";
            string connectionString = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("SP_PORTERMASTER_EQUANS", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ID", id);
                cmd.Parameters.AddWithValue("@PROCESS", process);
                cmd.Parameters.AddWithValue("@DURATION", duration);

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        resultMessage = reader["Message"] == DBNull.Value
                            ? ""
                            : reader["Message"].ToString();
                    }
                }
            }

            return new { success = true, message = resultMessage };
        }
        catch (Exception ex)
        {
            return new { success = false, message = ex.Message };
        }
    }

    private void HandleTriggerPorterBreak()
    {
        try
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, object>>(body);

            Dictionary<string, string> requestData = null;
            if (data != null && data.ContainsKey("request") && data["request"] != null)
            {
                requestData = JsonConvert.DeserializeObject<Dictionary<string, string>>(data["request"].ToString());
            }

            string encId = null;
            string encDuration = "0";
            string encEnd = "false";

            if (requestData != null)
            {
                if (requestData.ContainsKey("id")) encId = requestData["id"];
                if (requestData.ContainsKey("duration")) encDuration = requestData["duration"];
                if (requestData.ContainsKey("end")) encEnd = requestData["end"];
            }

            string idStr = !string.IsNullOrEmpty(encId) ? AESEncrytDecry.DecryptStringAES(encId) : null;
            string durationStr = !string.IsNullOrEmpty(encDuration) ? AESEncrytDecry.DecryptStringAES(encDuration) : "0";
            string endStr = !string.IsNullOrEmpty(encEnd) ? AESEncrytDecry.DecryptStringAES(encEnd) : "false";

            int id = 0;
            int duration = 0;
            bool end = false;
            bool.TryParse(endStr, out end);

            if (string.IsNullOrEmpty(idStr) || !int.TryParse(idStr, out id) || !int.TryParse(durationStr, out duration))
            {
                RespondWithJson(new { success = false, message = "Invalid request data" });
                return;
            }

            RespondWithJson(TriggerPorterBreak(id, duration, end));
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, message = ex.Message });
        }
    }

    private void HandleTriggerPorterMealBreak()
    {
        try
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, object>>(body);

            Dictionary<string, string> requestData = null;
            if (data != null && data.ContainsKey("request") && data["request"] != null)
            {
                requestData = JsonConvert.DeserializeObject<Dictionary<string, string>>(data["request"].ToString());
            }

            string encId = null;
            string encDuration = "0";
            string encEnd = "false";

            if (requestData != null)
            {
                if (requestData.ContainsKey("id")) encId = requestData["id"];
                if (requestData.ContainsKey("duration")) encDuration = requestData["duration"];
                if (requestData.ContainsKey("end")) encEnd = requestData["end"];
            }

            string idStr = !string.IsNullOrEmpty(encId) ? AESEncrytDecry.DecryptStringAES(encId) : null;
            string durationStr = !string.IsNullOrEmpty(encDuration) ? AESEncrytDecry.DecryptStringAES(encDuration) : "0";
            string endStr = !string.IsNullOrEmpty(encEnd) ? AESEncrytDecry.DecryptStringAES(encEnd) : "false";

            int id = 0;
            int duration = 0;
            bool end = false;
            bool.TryParse(endStr, out end);

            if (string.IsNullOrEmpty(idStr) || !int.TryParse(idStr, out id) || !int.TryParse(durationStr, out duration))
            {
                RespondWithJson(new { success = false, message = "Invalid request data" });
                return;
            }

            RespondWithJson(TriggerPorterMealBreak(id, duration, end));
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, message = ex.Message });
        }
    }

    private void HandleTriggerCheckIn()
    {
        try
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string encPorterId = data.ContainsKey("id") ? data["id"] : null;
            string porterId = !string.IsNullOrEmpty(encPorterId) ? AESEncrytDecry.DecryptStringAES(encPorterId) : null;

            int id = 0;
            if (string.IsNullOrEmpty(porterId) || !int.TryParse(porterId, out id))
            {
                RespondWithJson(new { success = false, message = "Invalid porter ID" });
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("SP_CLEARONHOLD_EQUANS", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@PORTERID", id);
                cmd.Parameters.AddWithValue("@PROCESS", "STARTSHIFT");

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            RespondWithJson(new { success = true, message = "Check in completed successfully." });
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, message = ex.Message });
        }
    }

    private void HandleTriggerCheckOut()
    {
        try
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string encPorterId = data.ContainsKey("id") ? data["id"] : null;
            string porterId = !string.IsNullOrEmpty(encPorterId) ? AESEncrytDecry.DecryptStringAES(encPorterId) : null;

            int id = 0;
            if (string.IsNullOrEmpty(porterId) || !int.TryParse(porterId, out id))
            {
                RespondWithJson(new { success = false, message = "Invalid porter ID" });
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
            string message = "Check out completed successfully.";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("SP_CLEARONHOLD_EQUANS", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@PORTERID", id);
                cmd.Parameters.AddWithValue("@PROCESS", "ENDSHIFT");

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        message = reader["Message"] == DBNull.Value ? "Check out completed successfully." : reader["Message"].ToString();
                    }
                }
            }

            RespondWithJson(new { success = true, message = message });
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, message = ex.Message });
        }
    }

    private void HandleTriggerPorterBreakFilter()
    {
        try
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string encPorterId = data.ContainsKey("id") ? data["id"] : null;
            string porterIdStr = !string.IsNullOrEmpty(encPorterId) ? AESEncrytDecry.DecryptStringAES(encPorterId) : null;

            int id = 0;
            if (string.IsNullOrEmpty(porterIdStr) || !int.TryParse(porterIdStr, out id))
            {
                RespondWithJson(new { success = false, message = "Invalid porter ID" });
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
            string message = "Action completed.";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("SP_PORTERMASTER", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ID", id);
                cmd.Parameters.AddWithValue("@PROCESS", "BREAK");

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        message = reader[0] != DBNull.Value ? reader[0].ToString() : "Action completed.";
                    }
                }
            }

            RespondWithJson(new { success = true, message = message });
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, message = ex.Message });
        }
    }

    private void HandleTriggerPorterMealBreakFilter()
    {
        try
        {
            string body = new StreamReader(Request.InputStream).ReadToEnd();
            var data = JsonConvert.DeserializeObject<Dictionary<string, string>>(body);

            string encPorterId = data.ContainsKey("id") ? data["id"] : null;
            string porterIdStr = !string.IsNullOrEmpty(encPorterId) ? AESEncrytDecry.DecryptStringAES(encPorterId) : null;

            int id = 0;
            if (string.IsNullOrEmpty(porterIdStr) || !int.TryParse(porterIdStr, out id))
            {
                RespondWithJson(new { success = false, message = "Invalid porter ID" });
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
            string message = "Action completed.";

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand("SP_PORTERMASTER", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ID", id);
                cmd.Parameters.AddWithValue("@PROCESS", "UNAVAILABLE");

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        message = reader[0] != DBNull.Value ? reader[0].ToString() : "Action completed.";
                    }
                }
            }

            RespondWithJson(new { success = true, message = message });
        }
        catch (Exception ex)
        {
            RespondWithJson(new { success = false, message = ex.Message });
        }
    }


    private DataSet GetCategoriesBF()
    {
        string Value = ((!string.IsNullOrEmpty(Request.QueryString["VAL"])) ? Request.QueryString["VAL"].ToString() : ""),
            Value1 = ((!string.IsNullOrEmpty(Request.QueryString["VAL1"])) ? Request.QueryString["VAL1"].ToString() : "");

        Value = AESEncrytDecry.DecryptStringAES(Value); Value1 = AESEncrytDecry.DecryptStringAES(Value1);

        DataSet DS = DataAccess.GetRecordss("SP_GETREQUESTCATETORIES_SCHEDBF", "@VAL", Value, "@VAL1", Value1).Copy(); ;
        return DS;
    }

    //public DataSet PresetOperations()
    //{
    //    string encAction = Request.QueryString["ACTION"] ?? "";
    //    string encServiceID = Request.QueryString["SERVICEID"] ?? "";

    //    string Process = AESEncrytDecry.DecryptStringAES(encAction);
    //    string ServiceID = AESEncrytDecry.DecryptStringAES(encServiceID);

    //    DataTable dt = DataAccess.PersetMaster("SP_PRESETMASTER", string.Empty, string.Empty, string.Empty, Process, ServiceID).Tables[0];
    //    DataSet DS = new DataSet(); DS.Tables.Add(dt.Copy());
    //    return DS;
    //}

    private static bool ConstantTimeEquals(string a, string b)
    {
        if (a == null || b == null || a.Length != b.Length)
            return false;

        int result = 0;
        for (int i = 0; i < a.Length; i++)
        {
            result |= a[i] ^ b[i];
        }
        return result == 0;
    }
    public DataSet PresetOperations()
    {
        try
        {
            string encAction = Request.QueryString["ACTION"] ?? "";
            string encServiceID = Request.QueryString["SERVICEID"] ?? "";

            string Process = AESEncrytDecry.DecryptStringAES(encAction);
            string ServiceID = AESEncrytDecry.DecryptStringAES(encServiceID);

            DataSet tempDS = DataAccess.PersetMaster("SP_PRESETMASTER", string.Empty,
                string.Empty, string.Empty, Process, ServiceID);

            if (tempDS != null && tempDS.Tables != null && tempDS.Tables.Count > 0)
            {
                DataSet resultDS = new DataSet();
                resultDS.Tables.Add(tempDS.Tables[0].Copy());
                return resultDS;
            }
            else
            {
                return CreateEmptyDataSet();
            }
        }
        catch (Exception ex)
        {
            return CreateEmptyDataSet();
        }
    }

    private DataSet CreateEmptyDataSet()
    {
        DataSet ds = new DataSet();
        DataTable table = new DataTable("Result");
        table.Columns.Add("RESULT", typeof(string));
        ds.Tables.Add(table);

        DataRow row = table.NewRow();
        row["RESULT"] = "FALSE";
        table.Rows.Add(row);

        return ds;
    }

    private DataSet SetPriority()
    {
        bool res = false;
        string Requestid = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString(),
            Process = (string.IsNullOrEmpty(Request.QueryString["Priority"])) ? "" : Request.QueryString["Priority"].ToString(),
            CategoryID = (string.IsNullOrEmpty(Request.QueryString["CategoryID"])) ? "" : Request.QueryString["CategoryID"].ToString();

        DataTable dt = DataAccess.GetRecords("SP_REQUESTPRIORITY", "@REQUESTID", Requestid, "@PROCESS", Process, "@CATEGORYID", CategoryID);
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = (dt.Rows.Count > 0) ? dt.Rows[0]["RESULT"].ToString() : "FALSE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
}