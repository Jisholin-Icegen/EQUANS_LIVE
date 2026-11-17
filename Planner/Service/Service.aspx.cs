using System;
using System.Collections.Generic;
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

public partial class Planner_Service_Service : System.Web.UI.Page
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
        process = ((!string.IsNullOrEmpty((Request.QueryString["Process"]))) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Process"].ToString()) : "");
        switch (process)
        {
            case "GETCATEGORIES":
                data = GetCategories();
                break;
             

            case "GETEQUIPMENT":
                data = GetEquipment();
                break;

            case "GETCATEGORIESBF":
                data = GetCategoriesBF();
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
            case "GETMASTERRECORD":
                data = GetMasterRecords();
                break;
            case "CLEARMANUALASSIGN":
                data = ClearManualAssign();
                break;
            case "GETSEARCHEDLOCATION":
                data = GetSearchedLocation();
                break;

            case "GETSEARCHEDLOCATIONBF":
                data = GetSearchedLocationBF();
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
            case "CANCELTASK":
                data = cancelTask();
                break;
            case "COMPLETETASK":
                data = completeTask();
                break;
            case "UPDATELOCATION":
                data = upldateLocation();
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
            case "GETCOUNT":

                data = GetCount();
                //data = (DataAccess.getRequestCount("SP_GETREQUESTCOUNT", User, RoleId).Tables[0].Rows.Count == 0) ? ModifyIsEmpty(DataAccess.getRequestCount("SP_GETREQUESTCOUNT", User)) : (DataAccess.getRequestCount("SP_GETREQUESTCOUNT", User));
                break;
            case "PRIORITY":
                data = SetPriority();
                break;
            case "INSERTROUTINEREQUEST":
                data = NewRequest();
                break;

            case "INSERTROUTINEREQUESTBF":
                data = NewRequestBF();
                break;
            case "GETROUTINETASK":
                data = getRoutineTask();
                break;

            case "GETROUTINETASKBF":
                data = getRoutineBFTask();
                break;

            case "GETMTPORTERS":
                data = MTPorters();
                break;

            case "UPDATEROUTINE":
                data = UpdateRoutine();
                break;

            case "UPDATEROUTINEBF":
                data = UpdateRoutineBF();
                break;

            case "UPDATEROUTINEREQUEST":
                data = UpdateRequest();
                break;

            case "UPDATEROUTINEREQUESTBF":
                data = UpdateRequestBF();
                break;
            case "DELETEROUTINE":
                data = deleteRoutine();
                break;

            case "DELETEROUTINEBF":
                data = deleteRoutineBF();
                break;


        }
        //data = getRecords();
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



    private DataSet UpdateRoutine()
    {
        string Id = string.IsNullOrEmpty(Request.QueryString["ID"]) ? string.Empty : Request.QueryString["ID"].ToString(),
             UserId = string.IsNullOrEmpty(Request.QueryString["USERID"]) ? string.Empty : Request.QueryString["USERID"].ToString(),
             Column = string.IsNullOrEmpty(Request.QueryString["COLUMN"]) ? string.Empty : Request.QueryString["COLUMN"].ToString();
        Id = AESEncrytDecry.DecryptStringAES(Id); UserId = AESEncrytDecry.DecryptStringAES(UserId); Column = AESEncrytDecry.DecryptStringAES(Column);
        DataTable dt = null;
        if (Id != DataAccess.InvalidStr && Column != DataAccess.InvalidStr && UserId != DataAccess.InvalidStr )
        dt=DataAccess.GetRecords("SP_ROUTINETASK_UPDATE_DAY", "@ID", Id, "@COULUMN", Column, "@USERID", UserId);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }

    private DataSet UpdateRoutineBF()
    {
        string Id = string.IsNullOrEmpty(Request.QueryString["ID"]) ? string.Empty : Request.QueryString["ID"].ToString(),
             UserId = string.IsNullOrEmpty(Request.QueryString["USERID"]) ? string.Empty : Request.QueryString["USERID"].ToString(),
             Column = string.IsNullOrEmpty(Request.QueryString["COLUMN"]) ? string.Empty : Request.QueryString["COLUMN"].ToString();
        Id = AESEncrytDecry.DecryptStringAES(Id); UserId = AESEncrytDecry.DecryptStringAES(UserId); Column = AESEncrytDecry.DecryptStringAES(Column);


        DataTable dt = null;
        if (Id != DataAccess.InvalidStr && Column != DataAccess.InvalidStr && UserId != DataAccess.InvalidStr)
            dt =DataAccess.GetRecords("SP_ROUTINETASK_UPDATE_DAY_BF", "@ID", Id, "@COULUMN", Column, "@USERID", UserId);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }

    private DataSet deleteRoutine()
    {
        string Id = string.IsNullOrEmpty(Request.QueryString["ID"]) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["ID"].ToString());
        DataTable dt = null;
        if (Id != DataAccess.InvalidStr )
        dt = DataAccess.GetRecords("SP_ROUTINETASK_DELETE", "@ID", Id);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }


    private DataSet deleteRoutineBF()
    {
        string Id = string.IsNullOrEmpty(Request.QueryString["ID"]) ? string.Empty : Request.QueryString["ID"].ToString();
        DataTable dt = DataAccess.GetRecords("SP_ROUTINETASK_DELETE_BF", "@ID", Id);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }
    private DataSet GetCount()
    {
        string User = ((string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString().ToUpper()),
            RoleId = ((string.IsNullOrEmpty(Request.QueryString["ROLE"])) ? string.Empty : Request.QueryString["ROLE"].ToString().ToUpper());
        DataSet data = new DataSet();//DataAccess.getReqCount("@USERID", User, "@ROLEID", RoleId);
        data = (data.Tables[0].Rows.Count == 0) ? ModifyIsEmpty(data) : data;

        return data;
    }

    // OLA Module

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
        string ReqNo = ((!string.IsNullOrEmpty(Request.QueryString["REQID"])) ? Request.QueryString["REQID"].ToString().ToUpper() : "");
        DataTable dt = Modify(DataAccess.GetPopDetails(ReqNo.Trim(), string.Empty, string.Empty));
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }
    private DataSet GetPorterDetails()
    {
        string ReqNo = ((!string.IsNullOrEmpty(Request.QueryString["REQID"])) ? Request.QueryString["REQID"].ToString().ToUpper() : "");
        DataTable dt = Modify(DataAccess.PorterDetails(ReqNo.Trim(), string.Empty, string.Empty));
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }
    private DataSet GetPendingRequest()
    {
        string User = ((!string.IsNullOrEmpty(Request.QueryString["USERID"])) ? Request.QueryString["USERID"].ToString().ToUpper() : "");
        DataTable dt = DataAccess.GetPopDetails(string.Empty, User.Trim(), string.Empty);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }
    private DataSet GetETA()
    {
        string ReqNo = ((!string.IsNullOrEmpty(Request.QueryString["REQID"])) ? Request.QueryString["REQID"].ToString().ToUpper() : "");
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

    private DataSet completeTask()
    {
        string TAGID = ((!string.IsNullOrEmpty(Request.QueryString["TAGID"])) ? Request.QueryString["TAGID"].ToString().ToUpper() : ""),
            REASON = ((!string.IsNullOrEmpty(Request.QueryString["REASON"])) ? Request.QueryString["REASON"].ToString().ToUpper() : ""),
            REQUESTID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString().Trim().ToUpper(),
            PorterID = (string.IsNullOrEmpty(Request.QueryString["PORTERIDS"])) ? "" : Request.QueryString["PORTERIDS"].ToString().Trim().ToUpper(),
            MIndex = (string.IsNullOrEmpty(Request.QueryString["MIINDEX"])) ? "" : Request.QueryString["MIINDEX"].ToString().Trim().ToUpper(),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString().ToUpper();
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
    private DataSet startTask()
    {
        string TAGID = ((!string.IsNullOrEmpty(Request.QueryString["TAGID"])) ? Request.QueryString["TAGID"].ToString().ToUpper() : ""),
            LOCATION = ((!string.IsNullOrEmpty(Request.QueryString["LOCATION"])) ? Request.QueryString["LOCATION"].ToString().ToUpper() : ""),
            MIndex = (string.IsNullOrEmpty(Request.QueryString["MIINDEX"])) ? "" : Request.QueryString["MIINDEX"].ToString().Trim().ToUpper(),
            REQUESTID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString().Trim().ToUpper();
        DataTable table;
        table = DataAccess.StartTask(REQUESTID, TAGID, LOCATION, MIndex);

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet cancelTask()
    {
        string PreBook = ((!string.IsNullOrEmpty(Request.QueryString["PREBOOK"])) ? Request.QueryString["PREBOOK"].ToString().ToUpper() : ""),
            REASON = ((!string.IsNullOrEmpty(Request.QueryString["REASON"])) ? Request.QueryString["REASON"].ToString().ToUpper() : ""),
            REQUESTID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString().Trim().ToUpper(),
            PorterID = (string.IsNullOrEmpty(Request.QueryString["PORTERIDS"])) ? "" : Request.QueryString["PORTERIDS"].ToString().Trim().ToUpper(),
            MIndex = (string.IsNullOrEmpty(Request.QueryString["MIINDEX"])) ? "" : Request.QueryString["MIINDEX"].ToString().Trim().ToUpper(),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString().ToUpper();
        DataTable table;
        if (User == string.Empty)
        {
            table = generate();
            DataRow row = table.NewRow();
            row["RESULT"] = "FALSE";
            table.Rows.Add(row);
        }
        else
            table = DataAccess.CancelTask(REQUESTID, PorterID, PreBook, REASON, User, MIndex);

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet upldateLocation()
    {
        string ReqId = ((!string.IsNullOrEmpty(Request.QueryString["REQUEST"])) ? Request.QueryString["REQUEST"].ToString().ToUpper() : ""),
            DestID = ((!string.IsNullOrEmpty(Request.QueryString["DID"])) ? Request.QueryString["DID"].ToString().ToUpper() : ""),
        UserID = ((!string.IsNullOrEmpty(Request.QueryString["USERID"])) ? Request.QueryString["USERID"].ToString().ToUpper() : ""),
        TagID = ((!string.IsNullOrEmpty(Request.QueryString["TAGID"])) ? Request.QueryString["TAGID"].ToString().ToUpper() : ""),
        Dloc = ((!string.IsNullOrEmpty(Request.QueryString["DLOC"])) ? Request.QueryString["DLOC"].ToString().ToUpper() : ""),
        CID = ((!string.IsNullOrEmpty(Request.QueryString["CID"])) ? Request.QueryString["CID"].ToString().ToUpper() : ""),
        CName = ((!string.IsNullOrEmpty(Request.QueryString["CNAME"])) ? Request.QueryString["CNAME"].ToString().ToUpper() : ""),
        CCName = ((!string.IsNullOrEmpty(Request.QueryString["CCAT"])) ? Request.QueryString["CCAT"].ToString().ToUpper() : ""),
        IsMultiPorter = ((!string.IsNullOrEmpty(Request.QueryString["MT"])) ? Request.QueryString["MT"].ToString().ToUpper() : "");
        string RQuery = "UPDATE REQUESTMASTER SET DESTINATIONLOCATIONID = '" + DestID + "' " + ((CID.Length > 0) ? (", CATEGORYID= '" + CID + "' ") : string.Empty) + ((CID == "6") ? ", ISMULTIPORTER = 0 " : ", ISMULTIPORTER = '" + IsMultiPorter + "' ") + "  WHERE REQUESTID = '" + ReqId + "'";
        DataTable table;
        table = DataAccess.updateLocation(ReqId, DestID, Dloc, TagID, UserID, RQuery, CName, CCName);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet UpdateRecords()
    {
        string Status = ((!string.IsNullOrEmpty(Request.QueryString["Status"])) ? (Convert.ToInt32(Request.QueryString["Status"].ToString()) + 1).ToString() : ""),
            ReqId = ((!string.IsNullOrEmpty(Request.QueryString["REQUEST"])) ? Request.QueryString["REQUEST"].ToString().ToUpper() : "").Replace("_", "'").Replace("-", ","),
            Source = ((!string.IsNullOrEmpty(Request.QueryString["SOURCE"])) ? Request.QueryString["SOURCE"].ToString().ToUpper() : ""),
            Halt1 = (string.IsNullOrEmpty(Request.QueryString["HALT1"])) ? "" : Request.QueryString["HALT1"].ToString().Trim().ToUpper(),
            Halt2 = (string.IsNullOrEmpty(Request.QueryString["HALT2"])) ? "" : Request.QueryString["HALT2"].ToString().Trim().ToUpper(),
            Destination = ((!string.IsNullOrEmpty(Request.QueryString["DESTINATION"])) ? Request.QueryString["DESTINATION"].ToString().ToUpper() : ""),
            Category = ((!string.IsNullOrEmpty(Request.QueryString["CATEGORY"])) ? Request.QueryString["CATEGORY"].ToString().ToUpper() : ""),
            Remarks = ((!string.IsNullOrEmpty(Request.QueryString["REMARKS"])) ? Request.QueryString["REMARKS"].ToString().ToUpper() : ""),
            MultiPorter = (string.IsNullOrEmpty(Request.QueryString["ISMULTIPORTER"])) ? "" : Request.QueryString["ISMULTIPORTER"].ToString().ToUpper(),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString().ToUpper();
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
        string remarks = (string.IsNullOrEmpty(Request.QueryString["REMARK"])) ? "" : Request.QueryString["REMARK"].ToString().ToUpper(),
            patientName = (string.IsNullOrEmpty(Request.QueryString["PATIENTNAME"])) ? "" : Request.QueryString["PATIENTNAME"].ToString().ToUpper(),
            Source = (string.IsNullOrEmpty(Request.QueryString["SOURCE"])) ? "" : Request.QueryString["SOURCE"].ToString().ToUpper(),
            Destination = (string.IsNullOrEmpty(Request.QueryString["DESTINATION"])) ? "" : Request.QueryString["DESTINATION"].ToString().ToUpper(),
            Halt1 = (string.IsNullOrEmpty(Request.QueryString["HALT1"])) ? "" : Request.QueryString["HALT1"].ToString().Trim().ToUpper(),
            Halt2 = (string.IsNullOrEmpty(Request.QueryString["HALT2"])) ? "" : Request.QueryString["HALT2"].ToString().Trim().ToUpper(),
            Category = (string.IsNullOrEmpty(Request.QueryString["CATEGORY"])) ? "" : Request.QueryString["CATEGORY"].ToString().ToUpper(),
            Date = DateTime.Now.Date.ToString("MM/dd/yyyy") + " " + ((string.IsNullOrEmpty(Request.QueryString["TIME"])) ? "" : Request.QueryString["TIME"].ToString().ToUpper()),
            Priority = (string.IsNullOrEmpty(Request.QueryString["PRIORITY"])) ? "" : Request.QueryString["PRIORITY"].ToString().ToUpper(),
            MultiPorter = (string.IsNullOrEmpty(Request.QueryString["ISMULTIPORTER"])) ? "" : Request.QueryString["ISMULTIPORTER"].ToString().ToUpper(),
            user = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString().ToUpper(),
            prebooking = (string.IsNullOrEmpty(Request.QueryString["PREBOOKING"])) ? "," : Request.QueryString["PREBOOKING"].ToString().ToUpper(),
            MRD = (string.IsNullOrEmpty(Request.QueryString["MRD"])) ? "" : Request.QueryString["MRD"].ToString().ToUpper();
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
        //Process=INSERTREQUEST&PBDATE=" + PBDTime + "&CATEGORY=" + ReqCat + "&FROM=" + RFromID + "&TO=" + RToID + "&MULTIPORTER=" + IsMultiPorter + "&PATIENTNAME=" + PatientName + "&REMARKS=" + Remarks+ "&USERID=" + UID + "&PRIORITY=0&EXTRAFIELDS="
        bool res = false;
        string PBDate = (string.IsNullOrEmpty(Request.QueryString["PBDATE"])) ? "" : Request.QueryString["PBDATE"].ToString(),
                Category = (string.IsNullOrEmpty(Request.QueryString["CATEGORY"])) ? "" : Request.QueryString["CATEGORY"].ToString(),
                From = (string.IsNullOrEmpty(Request.QueryString["FROM"])) ? "" : Request.QueryString["FROM"].ToString(),
                To = (string.IsNullOrEmpty(Request.QueryString["TO"])) ? "" : Request.QueryString["TO"].ToString(),
                MultiPorter = (string.IsNullOrEmpty(Request.QueryString["MULTIPORTER"])) ? "" : Request.QueryString["MULTIPORTER"].ToString(),
                patientName = (string.IsNullOrEmpty(Request.QueryString["PATIENTNAME"])) ? "" : Request.QueryString["PATIENTNAME"].ToString(),
                remarks = (string.IsNullOrEmpty(Request.QueryString["REMARKS"])) ? "" : Request.QueryString["REMARKS"].ToString(),
                Date = DateTime.Now.Date.ToString("MM/dd/yyyy") + " " + ((string.IsNullOrEmpty(Request.QueryString["TIME"])) ? "" : Request.QueryString["TIME"].ToString()),
                user = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString(),
                Priority = (string.IsNullOrEmpty(Request.QueryString["PRIORITY"])) ? "" : Request.QueryString["PRIORITY"].ToString(),
                eqid = (string.IsNullOrEmpty(Request.QueryString["EQUIPMENTID"])) ? "" : Request.QueryString["EQUIPMENTID"].ToString(),
                 svcid = (string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? "" : Request.QueryString["SERVICEID"].ToString(),
                Extra = (string.IsNullOrEmpty(Request.QueryString["EXTRAFIELDS"])) ? "" : Request.QueryString["EXTRAFIELDS"].ToString();
        eqid = AESEncrytDecry.DecryptStringAES(eqid);
        svcid = AESEncrytDecry.DecryptStringAES(svcid);
        DataTable table = generate(); DataRow row = table.NewRow();
        PBDate = AESEncrytDecry.DecryptStringAES(PBDate); Category = AESEncrytDecry.DecryptStringAES(Category); From = AESEncrytDecry.DecryptStringAES(From); To = AESEncrytDecry.DecryptStringAES(To); MultiPorter = AESEncrytDecry.DecryptStringAES(MultiPorter);
        patientName = AESEncrytDecry.DecryptStringAES(patientName); remarks = AESEncrytDecry.DecryptStringAES(remarks); user = AESEncrytDecry.DecryptStringAES(user); Priority = AESEncrytDecry.DecryptStringAES(Priority); Extra = AESEncrytDecry.DecryptStringAES(Extra);


        if (svcid != "Invalid Input" && eqid != "Invalid Input" && PBDate != "Invalid Input" && Category != "Invalid Input" && From != "Invalid Input" && To != "Invalid Input" && MultiPorter != "Invalid Input" && patientName != "Invalid Input" && remarks != "Invalid Input" && user != "Invalid Input" && Priority != "Invalid Input" && Extra != "Invalid Input")
        {
            DataTable Dt = DataAccess.InsertRoutineRequest(svcid,eqid, PBDate, Category, From, To, MultiPorter, patientName, remarks, user, Priority, Extra);
            row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
        }
        else
            row["RESULT"] = "FALSE";

        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }


    private DataSet NewRequestBF()
    {
        //Process=INSERTREQUEST&PBDATE=" + PBDTime + "&CATEGORY=" + ReqCat + "&FROM=" + RFromID + "&TO=" + RToID + "&MULTIPORTER=" + IsMultiPorter + "&PATIENTNAME=" + PatientName + "&REMARKS=" + Remarks+ "&USERID=" + UID + "&PRIORITY=0&EXTRAFIELDS="
        bool res = false;
        string PBDate = (string.IsNullOrEmpty(Request.QueryString["PBDATE"])) ? "" : Request.QueryString["PBDATE"].ToString(),
                Category = (string.IsNullOrEmpty(Request.QueryString["CATEGORY"])) ? "" : Request.QueryString["CATEGORY"].ToString(),
                From = (string.IsNullOrEmpty(Request.QueryString["FROM"])) ? "" : Request.QueryString["FROM"].ToString(),
                To = (string.IsNullOrEmpty(Request.QueryString["TO"])) ? "" : Request.QueryString["TO"].ToString(),
                MultiPorter = (string.IsNullOrEmpty(Request.QueryString["MULTIPORTER"])) ? "" : Request.QueryString["MULTIPORTER"].ToString(),
                patientName = (string.IsNullOrEmpty(Request.QueryString["PATIENTNAME"])) ? "" : Request.QueryString["PATIENTNAME"].ToString(),
                remarks = (string.IsNullOrEmpty(Request.QueryString["REMARKS"])) ? "" : Request.QueryString["REMARKS"].ToString(),
                Date = DateTime.Now.Date.ToString("MM/dd/yyyy") + " " + ((string.IsNullOrEmpty(Request.QueryString["TIME"])) ? "" : Request.QueryString["TIME"].ToString()),
                user = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString(),
                Priority = (string.IsNullOrEmpty(Request.QueryString["PRIORITY"])) ? "" : Request.QueryString["PRIORITY"].ToString(),
                Extra = (string.IsNullOrEmpty(Request.QueryString["EXTRAFIELDS"])) ? "" : Request.QueryString["EXTRAFIELDS"].ToString(),
                EndDate = (string.IsNullOrEmpty(Request.QueryString["ENDDATE"])) ? "" : Request.QueryString["ENDDATE"].ToString(),
                Kitchen = (string.IsNullOrEmpty(Request.QueryString["KITCHEN"])) ? "" : Request.QueryString["KITCHEN"].ToString();

        DataTable table = generate(); DataRow row = table.NewRow();
        PBDate = AESEncrytDecry.DecryptStringAES(PBDate); Category = AESEncrytDecry.DecryptStringAES(Category); From = AESEncrytDecry.DecryptStringAES(From); To = AESEncrytDecry.DecryptStringAES(To); MultiPorter = AESEncrytDecry.DecryptStringAES(MultiPorter);
        patientName = AESEncrytDecry.DecryptStringAES(patientName); remarks = AESEncrytDecry.DecryptStringAES(remarks); user = AESEncrytDecry.DecryptStringAES(user); Priority = AESEncrytDecry.DecryptStringAES(Priority);
        Extra = AESEncrytDecry.DecryptStringAES(Extra); EndDate = AESEncrytDecry.DecryptStringAES(EndDate); Kitchen = AESEncrytDecry.DecryptStringAES(Kitchen);


        if (PBDate != "Invalid Input" && Category != "Invalid Input" && From != "Invalid Input" && To != "Invalid Input" && MultiPorter != "Invalid Input" && patientName != "Invalid Input" && remarks != "Invalid Input" &&
            user != "Invalid Input" && Priority != "Invalid Input" && Extra != "Invalid Input" && EndDate != "Invalid Input" && Kitchen != "Invalid Input")
        {
            DataTable Dt = DataAccess.InsertRoutineRequestBF(PBDate, Category, From, To, MultiPorter, patientName, remarks, user, Priority, Extra, EndDate, Kitchen);
            row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
        }
        else
            row["RESULT"] = "FALSE";

        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet UpdateRequest()
    {
        //Process=INSERTREQUEST&PBDATE=" + PBDTime + "&CATEGORY=" + ReqCat + "&FROM=" + RFromID + "&TO=" + RToID + "&MULTIPORTER=" + IsMultiPorter + "&PATIENTNAME=" + PatientName + "&REMARKS=" + Remarks+ "&USERID=" + UID + "&PRIORITY=0&EXTRAFIELDS="
        bool res = false;
        string PBDate = (string.IsNullOrEmpty(Request.QueryString["PBDATE"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["PBDATE"].ToString()),
                Category = (string.IsNullOrEmpty(Request.QueryString["CATEGORY"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["CATEGORY"].ToString()),
                From = (string.IsNullOrEmpty(Request.QueryString["FROM"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["FROM"].ToString()),
                To = (string.IsNullOrEmpty(Request.QueryString["TO"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["TO"].ToString()),
                MultiPorter = (string.IsNullOrEmpty(Request.QueryString["MULTIPORTER"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["MULTIPORTER"].ToString()),
                patientName = (string.IsNullOrEmpty(Request.QueryString["PATIENTNAME"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["PATIENTNAME"].ToString()),
                remarks = (string.IsNullOrEmpty(Request.QueryString["REMARKS"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["REMARKS"].ToString()),
                Date = DateTime.Now.Date.ToString("MM/dd/yyyy") + " " + ((string.IsNullOrEmpty(Request.QueryString["TIME"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["TIME"].ToString())),
                user = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["USERID"].ToString()),
                Priority = (string.IsNullOrEmpty(Request.QueryString["PRIORITY"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["PRIORITY"].ToString()),
                Extra = (string.IsNullOrEmpty(Request.QueryString["EXTRAFIELDS"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["EXTRAFIELDS"].ToString()),
                 eqid = (string.IsNullOrEmpty(Request.QueryString["EQUIPMENTID"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["EQUIPMENTID"].ToString()),
                 svcid = (string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["SERVICEID"].ToString());


        DataTable table = generate(); DataRow row = table.NewRow();
        //eqid = AESEncrytDecry.DecryptStringAES(eqid); PBDate = AESEncrytDecry.DecryptStringAES(PBDate); Category = AESEncrytDecry.DecryptStringAES(Category); From = AESEncrytDecry.DecryptStringAES(From); To = AESEncrytDecry.DecryptStringAES(To); MultiPorter = AESEncrytDecry.DecryptStringAES(MultiPorter);
        //patientName = AESEncrytDecry.DecryptStringAES(patientName); remarks = AESEncrytDecry.DecryptStringAES(remarks); user = AESEncrytDecry.DecryptStringAES(user); Priority = AESEncrytDecry.DecryptStringAES(Priority); Extra = AESEncrytDecry.DecryptStringAES(Extra);

        //svcid= AESEncrytDecry.DecryptStringAES(svcid);
        string DayQuery = string.Empty; string[] daysArr = Extra.Split('_');
        if (daysArr.Length == 7)
            DayQuery = "[SUNDAY] = '" + daysArr[0] + "' ,[MONDAY] = '" + daysArr[1] + "' ,[TUESDAY] = '" + daysArr[2] + "' ,[WEDNESDAY] = '" + daysArr[3] + "' ,[THURSDAY] = '" + daysArr[4] + "' ,[FRIDAY] = '" + daysArr[5] + "' ,[SATURDAY] = '" + daysArr[6] + "' ";


        if (svcid != "Invalid Input" && eqid != "Invalid Input" && PBDate != "Invalid Input" && Category != "Invalid Input" && From != "Invalid Input" && To != "Invalid Input" && MultiPorter != "Invalid Input" && patientName != "Invalid Input" && remarks != "Invalid Input" && user != "Invalid Input" && Priority != "Invalid Input" && Extra != "Invalid Input")
        {
            DataTable Dt = DataAccess.updateRoutineRequest(svcid,eqid, PBDate, Category, From, To, MultiPorter, patientName, remarks, user, Priority, DayQuery);
            row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
        }
        else
            row["RESULT"] = "FALSE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet UpdateRequestBF()
    {
        //Process=INSERTREQUEST&PBDATE=" + PBDTime + "&CATEGORY=" + ReqCat + "&FROM=" + RFromID + "&TO=" + RToID + "&MULTIPORTER=" + IsMultiPorter + "&PATIENTNAME=" + PatientName + "&REMARKS=" + Remarks+ "&USERID=" + UID + "&PRIORITY=0&EXTRAFIELDS="
        bool res = false;
        string PBDate = (string.IsNullOrEmpty(Request.QueryString["PBDATE"])) ? "" : Request.QueryString["PBDATE"].ToString(),
                Category = (string.IsNullOrEmpty(Request.QueryString["CATEGORY"])) ? "" : Request.QueryString["CATEGORY"].ToString(),
                From = (string.IsNullOrEmpty(Request.QueryString["FROM"])) ? "" : Request.QueryString["FROM"].ToString(),
                To = (string.IsNullOrEmpty(Request.QueryString["TO"])) ? "" : Request.QueryString["TO"].ToString(),
                MultiPorter = (string.IsNullOrEmpty(Request.QueryString["MULTIPORTER"])) ? "" : Request.QueryString["MULTIPORTER"].ToString(),
                patientName = (string.IsNullOrEmpty(Request.QueryString["PATIENTNAME"])) ? "" : Request.QueryString["PATIENTNAME"].ToString(),
                remarks = (string.IsNullOrEmpty(Request.QueryString["REMARKS"])) ? "" : Request.QueryString["REMARKS"].ToString(),
                Date = DateTime.Now.Date.ToString("MM/dd/yyyy") + " " + ((string.IsNullOrEmpty(Request.QueryString["TIME"])) ? "" : Request.QueryString["TIME"].ToString()),
                user = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString(),
                Priority = (string.IsNullOrEmpty(Request.QueryString["PRIORITY"])) ? "" : Request.QueryString["PRIORITY"].ToString(),
                Extra = (string.IsNullOrEmpty(Request.QueryString["EXTRAFIELDS"])) ? "" : Request.QueryString["EXTRAFIELDS"].ToString(),
                EndDate = (string.IsNullOrEmpty(Request.QueryString["ENDDATE"])) ? "" : Request.QueryString["ENDDATE"].ToString(),
                Kitchen = (string.IsNullOrEmpty(Request.QueryString["KITCHEN"])) ? "" : Request.QueryString["KITCHEN"].ToString();


        DataTable table = generate(); DataRow row = table.NewRow();
        PBDate = AESEncrytDecry.DecryptStringAES(PBDate); Category = AESEncrytDecry.DecryptStringAES(Category); From = AESEncrytDecry.DecryptStringAES(From); To = AESEncrytDecry.DecryptStringAES(To); MultiPorter = AESEncrytDecry.DecryptStringAES(MultiPorter);
        patientName = AESEncrytDecry.DecryptStringAES(patientName); remarks = AESEncrytDecry.DecryptStringAES(remarks); user = AESEncrytDecry.DecryptStringAES(user);
        Priority = AESEncrytDecry.DecryptStringAES(Priority); Extra = AESEncrytDecry.DecryptStringAES(Extra); EndDate = AESEncrytDecry.DecryptStringAES(EndDate); Kitchen = AESEncrytDecry.DecryptStringAES(Kitchen);


        string DayQuery = string.Empty; string[] daysArr = Extra.Split('_');
        if (daysArr.Length == 7)
            DayQuery = "[SUNDAY] = '" + daysArr[0] + "' ,[MONDAY] = '" + daysArr[1] + "' ,[TUESDAY] = '" + daysArr[2] + "' ,[WEDNESDAY] = '" + daysArr[3] + "' ,[THURSDAY] = '" + daysArr[4] + "' ,[FRIDAY] = '" + daysArr[5] + "' ,[SATURDAY] = '" + daysArr[6] + "' ";


        if (PBDate != "Invalid Input" && Category != "Invalid Input" && From != "Invalid Input" && To != "Invalid Input" && MultiPorter != "Invalid Input" && patientName != "Invalid Input"
            && remarks != "Invalid Input" && user != "Invalid Input" && Priority != "Invalid Input" && Extra != "Invalid Input" && EndDate != "Invalid Input" && Kitchen != "Invalid Input")
        {
            DataTable Dt = DataAccess.updateRoutineRequestBF(PBDate, Category, From, To, MultiPorter, patientName, remarks, user, Priority, EndDate, DayQuery, Kitchen);
            row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
        }
        else
            row["RESULT"] = "FALSE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }


    private DataSet GetDeptIdlePorters()
    {
        string PName = ((!string.IsNullOrEmpty(Request.QueryString["PORTERNAME"])) ? Request.QueryString["PORTERNAME"].ToString().ToUpper() : ""),
             PorterID1 = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID1"])) ? Request.QueryString["PORTERID1"].ToString().ToUpper() : ""),
             PorterID2 = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID2"])) ? Request.QueryString["PORTERID2"].ToString().ToUpper() : ""),
            IsInitiate = ((!string.IsNullOrEmpty(Request.QueryString["ISINITIATE"])) ? Request.QueryString["ISINITIATE"].ToString().ToUpper() : ""),
            Dept = ((!string.IsNullOrEmpty(Request.QueryString["DEPT"])) ? Request.QueryString["DEPT"].ToString().ToUpper() : "");
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
        string FloorId = ((!string.IsNullOrEmpty(Request.QueryString["FLOORID"])) ? Request.QueryString["FLOORID"].ToString().ToUpper() : "");
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
        string FloorId = ((!string.IsNullOrEmpty(Request.QueryString["FLOORID"])) ? Request.QueryString["FLOORID"].ToString().ToUpper() : "");
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
                    DivOverlay.Attributes.Add("class", "categoryOverlay"); DivText.Attributes.Add("class", "categoryText"); DivText.InnerText = dr["CATEGORYNAME"].ToString().ToUpper().Trim();
                    Div.Attributes.Add("onclick", (i == 2) ? ("CloseandEBind('" + dr["Id"] + "','" + dr["CATEGORYNAME"].ToString().Trim() + "','" + dr["SCATEGORYNAME"].ToString().Trim() + "')") : ("CloseandBind('" + dr["ID"] + "','" + dr["MIMAGE"].ToString().Trim() + "','" + dr["MRD"].ToString().Trim() + "')")); Div.Attributes.Add("align", "center"); Div.Attributes.Add("class", "Category");
                    HtmlImage Img = new HtmlImage() { Src =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +EPEServer + ":" + AppPort + "/RequestNew/images/Category/" + dr["MIMAGE"].ToString() };
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
        string Type = ((!string.IsNullOrEmpty(Request.QueryString["TYPE"])) ? Request.QueryString["TYPE"].ToString().ToUpper() : "");
        HtmlTable Tmptable = new HtmlTable() { Width = "90%", CellPadding = 10, CellSpacing = 10 }, tmpCatTble = new HtmlTable() { Width = "100%" }; Tmptable.Attributes.Add("style", "margin-left:10%;");
        HtmlTableRow tmpCatRow = new HtmlTableRow() { Height = "100px" }; HtmlTableCell tmpCatCell = new HtmlTableCell();
        DataSet DS = DataAccess.GetRecord("SP_GETREQUESTCATLOCRECORDS", "@TYPE", Type).Copy();


        return DS;
    }
    private DataSet GetSearchedLocationD()
    {
        var sb = new StringBuilder();
        string Location = ((!string.IsNullOrEmpty(Request.QueryString["LOCATION"])) ? Request.QueryString["LOCATION"].ToString().ToUpper() : "");
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
    //private DataSet GetSearchedLocation()
    //{
    //    var sb = new StringBuilder();
    //    string Location = ((!string.IsNullOrEmpty(Request.QueryString["LOCATION"])) ? Request.QueryString["LOCATION"].ToString().ToUpper() : "");
    //    HtmlTable Tmptable = new HtmlTable() { Width = "90%" }; Tmptable.Attributes.Add("style", "margin-left:10%;"); Tmptable.Attributes.Add("class", "ZoneLocation");
    //    DataTable DtSearchedLocations = new DataTable();
    //    if (!string.IsNullOrEmpty(Location))
    //    {
    //        DtSearchedLocations = DataAccess.GetRecords("SP_SEARCHLOCATION", "@LOCATION", Location);
    //        foreach (DataRow dr in DtSearchedLocations.Rows)
    //        {
    //            HtmlTableRow tr = new HtmlTableRow(); HtmlTableCell tc = new HtmlTableCell() { Align = "left" }; RadioButton RBtn = new RadioButton() { ID = "Loc-" + dr["Id"].ToString(), Text = dr["Location"].ToString().Trim().ToUpper(), ClientIDMode = ClientIDMode.Static, GroupName = dr["Location"].ToString() };
    //            RBtn.Attributes.Add("onclick", "CloseandBind('" + dr["Id"] + "','" + dr["Location"].ToString().Trim().ToUpper() + "','" + dr["BEDID"].ToString().Trim().ToUpper() + "')");
    //            RBtn.Attributes.Add("style", "font-family: Arial; font-weight: bold; color: rgb(30, 70, 129);padding:8px;");
    //            tr.Controls.Add(tc); tc.Controls.Add(RBtn); Tmptable.Controls.Add(tr);
    //        }
    //    }
    //    Tmptable.RenderControl(new HtmlTextWriter(new StringWriter(sb)));
    //    DataTable table = generate();
    //    DataRow row = table.NewRow();
    //    row["RESULT"] = sb.ToString();
    //    table.Rows.Add(row);
    //    DataSet DS = new DataSet(); DS.Tables.Add(table);
    //    return DS;
    //}
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
        string Status = ((!string.IsNullOrEmpty(Request.QueryString["Status"])) ? Request.QueryString["Status"].ToString().ToUpper() : ""),
              From = ((!string.IsNullOrEmpty(Request.QueryString["From"])) ? Request.QueryString["From"].ToString().ToUpper() : ""),
             To = ((!string.IsNullOrEmpty(Request.QueryString["To"])) ? Request.QueryString["To"].ToString().ToUpper() : ""),
             Search = ((!string.IsNullOrEmpty(Request.QueryString["Search"])) ? Request.QueryString["Search"].ToString().ToUpper() : ""),
             user = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString().ToUpper(),
             PageSize = ((!string.IsNullOrEmpty(Request.QueryString["PageSize"])) ? Request.QueryString["PageSize"].ToString().ToUpper() : "15"),
             PageIndex = ((!string.IsNullOrEmpty(Request.QueryString["PageIndex"])) ? Request.QueryString["PageIndex"].ToString().ToUpper() : "1"),
             ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString().ToUpper() : ""),
             Role = (string.IsNullOrEmpty(Request.QueryString["ROLE"])) ? string.Empty : Request.QueryString["ROLE"].ToString().ToUpper();

        DataTable dt = new DataTable();
        //if (Status == "100")
        //    dt = DataAccess.PreBookingMaster(user, Role, "GETPENDINGREQUESTS", PageIndex, PageSize, string.Empty, string.Empty);
        //else
        dt = DataAccess.GetRequests(user, Role, Status, PageIndex, PageSize, Search, ServiceID);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;

    }
    public DataSet GetPorterStatus()
    {
        string Status = ((!string.IsNullOrEmpty(Request.QueryString["Status"])) ? Request.QueryString["Status"].ToString().ToUpper() : "");

        DataTable dt = new DataTable();
        //if (Status == "100")
        //    dt = DataAccess.PreBookingMaster(user, Role, "GETPENDINGREQUESTS", PageIndex, PageSize, string.Empty, string.Empty);
        //else
        dt = DataAccess.GetPorterStatus(Status, "1");
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;

    }

    public DataSet getRoutineTask()
    {
        string searchValue = ((!string.IsNullOrEmpty(Request.QueryString["SEARCH"])) ? Request.QueryString["SEARCH"].ToString() : "");
        string svcid = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["SERVICEID"].ToString()) : "");
        searchValue = AESEncrytDecry.DecryptStringAES(searchValue);
        DataTable dt = new DataTable();
        if (searchValue != DataAccess.InvalidStr && svcid != DataAccess.InvalidStr)
        dt = DataAccess.GetRecords("SP_DAILYTASK", "@PROCESS", "GET", "@SEARCH", searchValue, "@SERVICEID", svcid);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;

    }


    public DataSet getRoutineBFTask()
    {
        string searchValue = ((!string.IsNullOrEmpty(Request.QueryString["SEARCH"])) ? Request.QueryString["SEARCH"].ToString() : "");
        searchValue = AESEncrytDecry.DecryptStringAES(searchValue);
        DataTable dt = new DataTable();
        dt = DataAccess.GetRecords("SP_DAILYTASK_BF", "@PROCESS", "GET", "@SEARCH", searchValue);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;

    }
    private DataSet MultiAssign()
    {
        string ReqID = ((!string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? Request.QueryString["REQUESTID"].ToString().ToUpper() : "").Replace("_", "'").Replace("-", ","),
                 PorterID = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID"])) ? Request.QueryString["PORTERID"].ToString().ToUpper() : ""),
                 Dept = ((!string.IsNullOrEmpty(Request.QueryString["DEPT"])) ? Request.QueryString["DEPT"].ToString().ToUpper() : "");
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
        string RId = ((!string.IsNullOrEmpty(Request.QueryString["RID"])) ? Request.QueryString["RID"].ToString().ToUpper() : "").Replace("_", "'").Replace("-", ",");
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = DataAccess.GetPorter(RId);//(dt.Rows.Count > 0) ? (dt.Rows[0]["MULTIPORTER"].ToString() == "YES") ? (dt.Rows.Count > 1) ? dt.Rows[0]["Id"].ToString() + "_" + dt.Rows[1]["Id"].ToString() : "1001" : dt.Rows[0]["Id"].ToString() : "0";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet CheckUser()
    {

        string UserName = (string.IsNullOrEmpty(Request.QueryString["USERNAME"])) ? "" : Request.QueryString["USERNAME"].ToString().ToUpper(),
            pWord = (string.IsNullOrEmpty(Request.QueryString["PWD"])) ? "" : Request.QueryString["PWD"].ToString().ToUpper(),
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
            PortId = ((!string.IsNullOrEmpty(Request.QueryString["PORTID"])) ? Request.QueryString["PORTID"].ToString().ToUpper() : ""),
            ReqId = ((!string.IsNullOrEmpty(Request.QueryString["Request"])) ? Request.QueryString["Request"].ToString().ToUpper() : "").Replace("_", "'").Replace("-", ","),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString().ToUpper();//((!string.IsNullOrEmpty(Request.QueryString["USER"])) ? Request.QueryString["USER"].ToString().ToUpper() : "");
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

    public DataSet PresetOperations()
    {
        string Process = ((!string.IsNullOrEmpty(Request.QueryString["ACTION"])) ? Request.QueryString["ACTION"].ToString().ToUpper() : "");
        DataTable dt = DataAccess.PersetMaster("SP_PRESETMASTER", string.Empty, string.Empty, string.Empty, Process, "1").Tables[0];

        DataSet DS = new DataSet(); DS.Tables.Add(dt.Copy());
        return DS;
    }
    private DataSet GetCategories()
    {
      /*  string Value = ((!string.IsNullOrEmpty(Request.QueryString["VAL"])) ? Request.QueryString["VAL"].ToString() : ""),
            Value1 = ((!string.IsNullOrEmpty(Request.QueryString["VAL1"])) ? Request.QueryString["VAL1"].ToString() : "");

        Value = AESEncrytDecry.DecryptStringAES(Value); Value1 = AESEncrytDecry.DecryptStringAES(Value1);

        DataSet DS = DataAccess.GetRecordss("SP_GETREQUESTCATETORIES_SCHED", "@VAL", Value, "@VAL1", Value1).Copy(); ;
        return DS; */

         string Value = ((!string.IsNullOrEmpty(Request.QueryString["VAL"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["VAL"].ToString()) : ""),
               Value1 = ((!string.IsNullOrEmpty(Request.QueryString["VAL1"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["VAL1"].ToString()) : ""),
                ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["SERVICEID"].ToString()) : "");
         
         DataSet DS = new DataSet();
          try
          {
            if (Value != DataAccess.InvalidStr && Value1 != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr )
              DS = DataAccess.GetRecordss("[SP_GETCATETORIES_ROUTINE_EQUANS]", "@VAL",  (Value), "@VAL1", (Value1), "@SERVICEID",  (ServiceID)).Copy();
          }
          catch (Exception ex)
          {
              DS = new DataSet();
          }return DS;

    }
    private DataSet GetEquipment()
    {
        
        string val = Request.QueryString["VAL"];
        string val1 = Request.QueryString["VAL1"];
        string serviceId = Request.QueryString["SERVICEID"] ?? "1";
        DataSet DS = null;
        string decryptedVal = string.IsNullOrEmpty(val) ? "" : AESEncrytDecry.DecryptStringAES(val);
        string decryptedVal1 = string.IsNullOrEmpty(val1) ? "" : AESEncrytDecry.DecryptStringAES(val1);
        serviceId = string.IsNullOrEmpty(serviceId) ? "" : AESEncrytDecry.DecryptStringAES(serviceId);
        if (serviceId != DataAccess.InvalidStr && decryptedVal != DataAccess.InvalidStr && decryptedVal1 != DataAccess.InvalidStr)
          DS = DataAccess.GetRecordss(
            "SP_GETPLANNEREQUIPMENT",
            "@VAL", decryptedVal,
            "@VAL1", decryptedVal1,
            "@SERVICEID", serviceId
        );
        return DS;
    }


    private DataSet GetCategoriesBF()
    {
        string Value = ((!string.IsNullOrEmpty(Request.QueryString["VAL"])) ? Request.QueryString["VAL"].ToString() : ""),
            Value1 = ((!string.IsNullOrEmpty(Request.QueryString["VAL1"])) ? Request.QueryString["VAL1"].ToString() : "");

        Value = AESEncrytDecry.DecryptStringAES(Value); Value1 = AESEncrytDecry.DecryptStringAES(Value1);

        DataSet DS = DataAccess.GetRecordss("SP_GETREQUESTCATETORIES_SCHEDBF", "@VAL", Value, "@VAL1", Value1).Copy(); ;
        return DS;
    }
    private DataSet GetSearchedLocation()
    {
        var sb = new StringBuilder();
        string Location = ((!string.IsNullOrEmpty(Request.QueryString["LOCATION"])) ? Request.QueryString["LOCATION"].ToString().ToUpper() : ""),
            sType = ((!string.IsNullOrEmpty(Request.QueryString["STYPE"])) ? Request.QueryString["STYPE"].ToString().ToUpper() : ""); ;
        HtmlTable Tmptable = new HtmlTable() { Width = "90%" }; Tmptable.Attributes.Add("style", "margin-left:10%;"); Tmptable.Attributes.Add("class", "ZoneLocation");


        HtmlGenericControl ul = new HtmlGenericControl("ul"); ul.Attributes.Add("class", "LocationList");


        if (!string.IsNullOrEmpty(Location))
        {
            DataTable DtSearchedLocations = DataAccess.GetRecords("SP_SEARCHLOCATION", "@LOCATION", Location);
            foreach (DataRow dr in DtSearchedLocations.Rows)
            {
                HtmlGenericControl li = new HtmlGenericControl("li") { ID = sType + "Loc-" + dr["Id"].ToString(), ClientIDMode = ClientIDMode.Static };
                HtmlImage img = new HtmlImage() { Src = "../images/location.png", Width = 30 }; img.Attributes.Add("style", "padding-right:15px;");
                HtmlGenericControl span = new HtmlGenericControl("span") { InnerHtml = dr["ZONENAME"].ToString().Trim().ToUpper() };
                li.Controls.Add(img); li.Controls.Add(span);
                li.Attributes.Add("onclick", "BindLocation('" + dr["Id"] + "','" + dr["ZONENAME"].ToString().Trim().ToUpper() + "','" + sType + "')");
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

    private DataSet GetSearchedLocationBF()
    {
        var sb = new StringBuilder();
        string Location = ((!string.IsNullOrEmpty(Request.QueryString["LOCATION"])) ? Request.QueryString["LOCATION"].ToString().ToUpper() : ""),
            sType = ((!string.IsNullOrEmpty(Request.QueryString["STYPE"])) ? Request.QueryString["STYPE"].ToString().ToUpper() : ""); ;
        HtmlTable Tmptable = new HtmlTable() { Width = "90%" }; Tmptable.Attributes.Add("style", "margin-left:10%;"); Tmptable.Attributes.Add("class", "ZoneLocation");


        HtmlGenericControl ul = new HtmlGenericControl("ul"); ul.Attributes.Add("class", "LocationList");


        if (!string.IsNullOrEmpty(Location))
        {
            DataTable DtSearchedLocations = DataAccess.GetRecords("SP_SEARCHLOCATION_BF", "@LOCATION", Location);
            foreach (DataRow dr in DtSearchedLocations.Rows)
            {
                HtmlGenericControl li = new HtmlGenericControl("li") { ID = sType + "Loc-" + dr["Id"].ToString(), ClientIDMode = ClientIDMode.Static };
                HtmlImage img = new HtmlImage() { Src = "../images/location.png", Width = 30 }; img.Attributes.Add("style", "padding-right:15px;");
                HtmlGenericControl span = new HtmlGenericControl("span") { InnerHtml = dr["ZONENAME"].ToString().Trim().ToUpper() };
                li.Controls.Add(img); li.Controls.Add(span);
                li.Attributes.Add("onclick", "BindLocation('" + dr["Id"] + "','" + dr["ZONENAME"].ToString().Trim().ToUpper() + "','" + dr["CATERINGGROUPNAME"] + "','" + dr["LID"].ToString().Trim().ToUpper() + "','" + sType + "')");
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
    private DataSet SetPriority()
    {
        bool res = false;
        string Requestid = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString().ToUpper(),
            Process = (string.IsNullOrEmpty(Request.QueryString["Priority"])) ? "" : Request.QueryString["Priority"].ToString().ToUpper(),
            CategoryID = (string.IsNullOrEmpty(Request.QueryString["CategoryID"])) ? "" : Request.QueryString["CategoryID"].ToString().ToUpper();

        DataTable dt = DataAccess.GetRecords("SP_REQUESTPRIORITY", "@REQUESTID", Requestid, "@PROCESS", Process, "@CATEGORYID", CategoryID);
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = (dt.Rows.Count > 0) ? dt.Rows[0]["RESULT"].ToString() : "FALSE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
}