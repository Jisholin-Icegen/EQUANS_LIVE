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
using System.Web.Services.Description;
using Telerik.Web;

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
        process = ((!string.IsNullOrEmpty((Request.QueryString["Process"]))) ? AESEncrytDecry.DecryptStringAES( Request.QueryString["Process"].ToString()) : "");
        switch (process)
        {
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
            case "GETCATEGORIESSCHDCL":
                data = GetCategoriesCL();
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
            case "CANCELTASK":
                data = cancelTask();
                break;
            case "ONHOLDTASK":
                data = OnHoldTask();
                break;

            case "RESUMEONHOLDTASK":
                data = ResumeTask();
                break;
            case "COMPLETETASK":
                data = completeTask();
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

            case "UPDATEREQUEST":
                data = UpdateRequest();
                break;
        }
        //data = getRecords();
        ResponseWrite(data);
    }
    private DataSet GetCount()
    {
        string User = ((string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["USERID"].ToString())),
            RoleId = ((string.IsNullOrEmpty(Request.QueryString["ROLE"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["ROLE"].ToString())),
            ServiceID = ((string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["SERVICEID"].ToString())),
            IsHaywood = ((string.IsNullOrEmpty(Request.QueryString["ISHAYWOOD"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["ISHAYWOOD"].ToString()));
        DataSet data=null;
        try
        {
            string usr =  (User.Trim()),
                   RoID =  (RoleId.Trim()),
                   SCode =  (ServiceID.Trim()),
                   Hywd =  (IsHaywood.Trim());

            if (usr != DataAccess.InvalidStr && RoID != DataAccess.InvalidStr && SCode != DataAccess.InvalidStr && Hywd != DataAccess.InvalidStr  )
            data = DataAccess.getReqCount("@USERID", usr, "@ROLEID", RoID, "@ISHAYWOOD", Hywd, "@SERVICEID", SCode);
            data = (data.Tables[0].Rows.Count == 0) ? ModifyIsEmpty(data) : data;
        }
        catch (Exception ex)
        {
            data = new DataSet();
        }

        return data;
    }

    // OLA Module

    private DataSet AlertProcess()
    {
        string ReqId = string.IsNullOrEmpty((Request.QueryString["ReqId"])) ? "0" : AESEncrytDecry.DecryptStringAES(Request.QueryString["ReqId"].ToString()),
              Process = string.IsNullOrEmpty((Request.QueryString["AlertProcess"])) ? "0" : AESEncrytDecry.DecryptStringAES(Request.QueryString["AlertProcess"].ToString());
        DataTable dt = null;
        if (ReqId != DataAccess.InvalidStr && Process != DataAccess.InvalidStr)
        dt =DataAccess.GetPopDetails(ReqId.Trim(), string.Empty, Process);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }

    private DataSet GetPopupDetails()
    {
        string ReqNo = ((!string.IsNullOrEmpty((Request.QueryString["REQID"]))) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["REQID"].ToString()) : "");
        DataTable dt = null;
        if (ReqNo != DataAccess.InvalidStr)
        dt =Modify(DataAccess.GetPopDetails(ReqNo.Trim(), string.Empty, string.Empty));
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }
    private DataSet GetPorterDetails()
    {
        string ReqNo = ((!string.IsNullOrEmpty((Request.QueryString["REQID"]))) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["REQID"].ToString()) : "");
        DataTable dt = null;
        if (ReqNo != DataAccess.InvalidStr)
            dt = Modify(DataAccess.PorterDetails(ReqNo.Trim(), string.Empty, string.Empty));
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }
    private DataSet GetPendingRequest()
    {
        string User = ((!string.IsNullOrEmpty((Request.QueryString["USERID"]))) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["USERID"].ToString()) : "");
        DataTable dt = null;
        if (User != DataAccess.InvalidStr)
            dt = DataAccess.GetPopDetails(string.Empty, User.Trim(), string.Empty);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }
    private DataSet GetETA()
    {
        string ReqNo = ((!string.IsNullOrEmpty(((Request.QueryString["REQID"])))) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["REQID"].ToString()) : "");
        DataTable dt = null;
        if (ReqNo != DataAccess.InvalidStr)
            dt = DataAccess.GetPopDetails(ReqNo.Trim(), string.Empty, "GETETA");
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
                dr["STRPIMAGE"] = (string.IsNullOrEmpty(dr["PORTER"].ToString().Trim()) ? string.Empty : AESEncrytDecry.DecryptStringAES(GetPath(dr["PORTERIMAGE"])));
                dr["STRSPIMAGE"] = (string.IsNullOrEmpty(dr["SUPPORTER"].ToString().Trim()) ? string.Empty : AESEncrytDecry.DecryptStringAES(GetPath(dr["SUPPORTERIMAGE"])));
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
        string TagIds = ((!string.IsNullOrEmpty((Request.QueryString["TagIds"]))) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["TagIds"].ToString()) : "");
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
        string TAGID = ((!string.IsNullOrEmpty((Request.QueryString["TAGID"]))) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["TAGID"].ToString()) : ""),
            REASON = ((!string.IsNullOrEmpty((Request.QueryString["REASON"]))) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["REASON"].ToString()) : ""),
            REQUESTID = (string.IsNullOrEmpty((Request.QueryString["REQUESTID"]))) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["REQUESTID"].ToString().Trim()),
            PorterID = (string.IsNullOrEmpty((Request.QueryString["PORTERIDS"]))) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTERIDS"].ToString().Trim()),
            MIndex = (string.IsNullOrEmpty((Request.QueryString["MIINDEX"]))) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["MIINDEX"].ToString().Trim()),
            User = (string.IsNullOrEmpty((Request.QueryString["USERID"]))) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["USERID"].ToString());
        DataTable table=null;
        if (User == string.Empty)
        {
            table = generate();
            DataRow row = table.NewRow();
            row["RESULT"] = "FALSE";
            table.Rows.Add(row);
        }
        else  if (TAGID != DataAccess.InvalidStr && REASON != DataAccess.InvalidStr && REQUESTID != DataAccess.InvalidStr && PorterID != DataAccess.InvalidStr && MIndex != DataAccess.InvalidStr && User != DataAccess.InvalidStr )
                       table = DataAccess.CompleteTask(REQUESTID, PorterID, TAGID, REASON, User, MIndex);

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }


    private DataSet AddcompleteRemarks()
    {
        string REASON = ((!string.IsNullOrEmpty(Request.QueryString["REMARKS"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["REMARKS"].ToString()) : ""),
            REQUESTID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["REQUESTID"].ToString().Trim()),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["USERID"].ToString()),
            IsMitigation = (string.IsNullOrEmpty(Request.QueryString["ISMITIGATION"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["ISMITIGATION"].ToString());
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
           // REASON = AESEncrytDecry.DecryptStringAES(REASON);REQUESTID = AESEncrytDecry.DecryptStringAES(REQUESTID);
           // User = AESEncrytDecry.DecryptStringAES(User);  IsMitigation = AESEncrytDecry.DecryptStringAES(IsMitigation);

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

    private DataSet startTask()
    {
        string TAGID = ((!string.IsNullOrEmpty(Request.QueryString["TAGID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["TAGID"].ToString()) : ""),
            LOCATION = ((!string.IsNullOrEmpty(Request.QueryString["LOCATION"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["LOCATION"].ToString()) : ""),
            MIndex = (string.IsNullOrEmpty(Request.QueryString["MIINDEX"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["MIINDEX"].ToString().Trim()),
            REQUESTID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["REQUESTID"].ToString().Trim());
        DataTable table=null;
        if (TAGID != DataAccess.InvalidStr && LOCATION != DataAccess.InvalidStr && MIndex != DataAccess.InvalidStr && REQUESTID != DataAccess.InvalidStr)
            table = DataAccess.StartTask(REQUESTID, TAGID, LOCATION, MIndex);

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet cancelTask()
    {
        string PreBook = ((!string.IsNullOrEmpty(Request.QueryString["PREBOOK"])) ? AESEncrytDecry.DecryptStringAES( Request.QueryString["PREBOOK"].ToString()) : ""),
            Reason = ((!string.IsNullOrEmpty(Request.QueryString["REASON"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["REASON"].ToString()) : ""),
            RequestId = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["REQUESTID"].ToString().Trim()),
            PorterID = (string.IsNullOrEmpty(Request.QueryString["PORTERIDS"])) ? "" : AESEncrytDecry.DecryptStringAES( Request.QueryString["PORTERIDS"].ToString().Trim()),
            MIndex = (string.IsNullOrEmpty(Request.QueryString["MIINDEX"])) ? "" : AESEncrytDecry.DecryptStringAES( Request.QueryString["MIINDEX"].ToString().Trim()),
            Occurrence = (string.IsNullOrEmpty(Request.QueryString["OCCURRENCE"])) ? "" : AESEncrytDecry.DecryptStringAES( Request.QueryString["OCCURRENCE"].ToString().Trim()),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["USERID"].ToString());
        DataTable table=null;
        if (User == string.Empty)
        {
            table = generate();
            DataRow row = table.NewRow();
            row["RESULT"] = "FALSE";
            table.Rows.Add(row);
        }
        else  if (PreBook != DataAccess.InvalidStr && Reason != DataAccess.InvalidStr && RequestId != DataAccess.InvalidStr && PorterID != DataAccess.InvalidStr && MIndex != DataAccess.InvalidStr && Occurrence != DataAccess.InvalidStr && User != DataAccess.InvalidStr)
            table = DataAccess.CancelTaskN(RequestId, PorterID, PreBook, Reason, User, MIndex, Occurrence);

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }


    private DataSet OnHoldTask()
    {
        //Process=ONHOLDTASK&REASON=" + Reason + "&USERID=" + UID + "&REQUESTID=" + ReqID + "&PORTERIDS=" + PoreterID + "&MIINDEX=" + GMIndex,
        string Reason = ((!string.IsNullOrEmpty(Request.QueryString["REASON"])) ? AESEncrytDecry.DecryptStringAES( Request.QueryString["REASON"].ToString()) : ""),
            RequestID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["REQUESTID"].ToString().Trim()),
            PorterID = (string.IsNullOrEmpty(Request.QueryString["PORTERIDS"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTERIDS"].ToString().Trim()),
            MIndex = (string.IsNullOrEmpty(Request.QueryString["MIINDEX"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["MIINDEX"].ToString().Trim()),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["USERID"].ToString());
        DataTable table=null;
        if (User == string.Empty)
        {
            table = generate();
            DataRow row = table.NewRow();
            row["RESULT"] = "FALSE";
            table.Rows.Add(row);
        }
        else if (Reason != DataAccess.InvalidStr && RequestID != DataAccess.InvalidStr && PorterID != DataAccess.InvalidStr && MIndex != DataAccess.InvalidStr && User != DataAccess.InvalidStr )
            table = DataAccess.SetHoldTask(RequestID, PorterID, Reason, User, MIndex);

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }


    private DataSet ResumeTask()
    {
        //Process=ONHOLDTASK&REASON=" + Reason + "&USERID=" + UID + "&REQUESTID=" + ReqID + "&PORTERIDS=" + PoreterID + "&MIINDEX=" + GMIndex,
        string RequestID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["REQUESTID"].ToString().Trim()),
              User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["USERID"].ToString());
        DataTable table=null;
        if (User == string.Empty)
        {
            table = generate();
            DataRow row = table.NewRow();
            row["RESULT"] = "FALSE";
            table.Rows.Add(row);
        }
        else if (RequestID != DataAccess.InvalidStr && User != DataAccess.InvalidStr)
            table = DataAccess.ResumeHoldTask(RequestID, User);

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet upldateLocation()
    {
        string ReqId = ((!string.IsNullOrEmpty(Request.QueryString["REQUEST"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["REQUEST"].ToString()) : ""),
            DestID = ((!string.IsNullOrEmpty(Request.QueryString["DID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["DID"].ToString()) : ""),
        UserID = ((!string.IsNullOrEmpty(Request.QueryString["USERID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["USERID"].ToString()) : ""),
        TagID = ((!string.IsNullOrEmpty(Request.QueryString["TAGID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["TAGID"].ToString()) : ""),
        Dloc = ((!string.IsNullOrEmpty(Request.QueryString["DLOC"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["DLOC"].ToString()) : ""),
        CID = ((!string.IsNullOrEmpty(Request.QueryString["CID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["CID"].ToString()) : ""),
        CName = ((!string.IsNullOrEmpty(Request.QueryString["CNAME"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["CNAME"].ToString()) : ""),
        CCName = ((!string.IsNullOrEmpty(Request.QueryString["CCAT"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["CCAT"].ToString()) : ""),
        IsMultiPorter = ((!string.IsNullOrEmpty(Request.QueryString["MT"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["MT"].ToString()) : "");
        string RQuery = "UPDATE REQUESTMASTER SET DESTINATIONLOCATIONID = '" + DestID + "' " + ((CID.Length > 0) ? (", CATEGORYID= '" + CID + "' ") : string.Empty) + ((CID == "6") ? ", ISMULTIPORTER = 0 " : ", ISMULTIPORTER = '" + IsMultiPorter + "' ") + "  WHERE REQUESTID = '" + ReqId + "'";
        DataTable table=null;

        if (ReqId != DataAccess.InvalidStr && DestID != DataAccess.InvalidStr && UserID != DataAccess.InvalidStr && TagID != DataAccess.InvalidStr && CID != DataAccess.InvalidStr && CName != DataAccess.InvalidStr && CCName != DataAccess.InvalidStr && IsMultiPorter != DataAccess.InvalidStr )
        table = DataAccess.updateLocation(ReqId, DestID, Dloc, TagID, UserID, RQuery, CName, CCName);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet UpdateRecords()
    {
        string Status = ((!string.IsNullOrEmpty(Request.QueryString["Status"])) ? AESEncrytDecry.DecryptStringAES((Convert.ToInt32(Request.QueryString["Status"].ToString()) + 1).ToString()) : ""),
            ReqId = ((!string.IsNullOrEmpty(Request.QueryString["REQUEST"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["REQUEST"].ToString()) : "").Replace("_", "'").Replace("-", ","),
            Source = ((!string.IsNullOrEmpty(Request.QueryString["SOURCE"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["SOURCE"].ToString()) : ""),
            Halt1 = (string.IsNullOrEmpty(Request.QueryString["HALT1"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["HALT1"].ToString().Trim()),
            Halt2 = (string.IsNullOrEmpty(Request.QueryString["HALT2"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["HALT2"].ToString().Trim()),
            Destination = ((!string.IsNullOrEmpty(Request.QueryString["DESTINATION"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["DESTINATION"].ToString()) : ""),
            Category = ((!string.IsNullOrEmpty(Request.QueryString["CATEGORY"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["CATEGORY"].ToString()) : ""),
            Remarks = ((!string.IsNullOrEmpty(Request.QueryString["REMARKS"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["REMARKS"].ToString()) : ""),
            MultiPorter = (string.IsNullOrEmpty(Request.QueryString["ISMULTIPORTER"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["ISMULTIPORTER"].ToString()),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["USERID"].ToString());
        DataTable table=null;
        if (User == string.Empty)
        {
            table = generate();
            DataRow row = table.NewRow();
            row["RESULT"] = "FALSE";
            table.Rows.Add(row);
        }
        else if (Status != DataAccess.InvalidStr && ReqId != DataAccess.InvalidStr && Source != DataAccess.InvalidStr && Halt1 != DataAccess.InvalidStr && Halt2 != DataAccess.InvalidStr && Destination != DataAccess.InvalidStr && Category != DataAccess.InvalidStr && Remarks != DataAccess.InvalidStr && MultiPorter != DataAccess.InvalidStr && User != DataAccess.InvalidStr )
            table = (Status != "101") ? DataAccess.RequestMaster(string.Empty, ReqId, Source, Halt1, Halt2, Destination, User, Category, Remarks, Status, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, process, string.Empty, MultiPorter, string.Empty, string.Empty)
                                         : DataAccess.PreBookingMaster(User, string.Empty, "CANCEL", string.Empty, string.Empty, ReqId, Remarks);

        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet InsertRequest()
    {
        bool res = false;
        string remarks = (string.IsNullOrEmpty(Request.QueryString["REMARK"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["REMARK"].ToString()),
            patientName = (string.IsNullOrEmpty(Request.QueryString["PATIENTNAME"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["PATIENTNAME"].ToString()),
            Source = (string.IsNullOrEmpty(Request.QueryString["SOURCE"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["SOURCE"].ToString()),
            Destination = (string.IsNullOrEmpty(Request.QueryString["DESTINATION"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["DESTINATION"].ToString()),
            Halt1 = (string.IsNullOrEmpty(Request.QueryString["HALT1"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["HALT1"].ToString().Trim()),
            Halt2 = (string.IsNullOrEmpty(Request.QueryString["HALT2"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["HALT2"].ToString().Trim()),
            Category = (string.IsNullOrEmpty(Request.QueryString["CATEGORY"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["CATEGORY"].ToString()),
            Date = DateTime.Now.Date.ToString("MM/dd/yyyy") + " " + ((string.IsNullOrEmpty(Request.QueryString["TIME"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["TIME"].ToString())),
            Priority = (string.IsNullOrEmpty(Request.QueryString["PRIORITY"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["PRIORITY"].ToString()),
            MultiPorter = (string.IsNullOrEmpty(Request.QueryString["ISMULTIPORTER"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["ISMULTIPORTER"].ToString()),
            user = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["USERID"].ToString()),
            prebooking = (string.IsNullOrEmpty(Request.QueryString["PREBOOKING"])) ? "," : AESEncrytDecry.DecryptStringAES(Request.QueryString["PREBOOKING"].ToString()),
            MRD = (string.IsNullOrEmpty(Request.QueryString["MRD"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["MRD"].ToString()),
            ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["SERVICEID"].ToString()) : "");
        DataTable table = generate();
        DataRow row = table.NewRow();
        if (user == string.Empty)
            row["RESULT"] = "FALSE";
        else
        {
            DataTable Dt = null;
            if (remarks != DataAccess.InvalidStr && patientName != DataAccess.InvalidStr && Source != DataAccess.InvalidStr && Destination != DataAccess.InvalidStr && Halt1 != DataAccess.InvalidStr && Halt2 != DataAccess.InvalidStr && Category != DataAccess.InvalidStr && Date!= DataAccess.InvalidStr && Priority!= DataAccess.InvalidStr && MultiPorter != DataAccess.InvalidStr &&  user!= DataAccess.InvalidStr && prebooking!= DataAccess.InvalidStr && MRD != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr )
            Dt = DataAccess.RequestMaster(Date, string.Empty, Source, Halt1, Halt2, Destination, user, Category, remarks, "", string.Empty, string.Empty, patientName, MRD, string.Empty, Priority, "INSERT", prebooking, MultiPorter, string.Empty, string.Empty);
            // res = (Dt.Rows[0]["RESULT"].ToString() == "TRUE");
            row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
        }
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    public DataSet MTPorters()
    {
        string ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["SERVICEID"].ToString()) : "");

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
        //Process=INSERTREQUEST&PBDATE=" + PBDTime + "&CATEGORY=" + ReqCat + "&FROM=" + RFromID + "&TO=" + RToID + "&MULTIPORTER=" + IsMultiPorter + "&PATIENTNAME=" + PatientName + "&REMARKS=" + Remarks+ "&USERID=" + UID + "&PRIORITY=0&EXTRAFIELDS="
        bool res = false;
        string PBDate = (string.IsNullOrEmpty(Request.QueryString["PBDATE"])) ? "" : Request.QueryString["PBDATE"].ToString(),
                Category = (string.IsNullOrEmpty(Request.QueryString["CATEGORY"])) ? "" : Request.QueryString["CATEGORY"].ToString(),
                From = (string.IsNullOrEmpty(Request.QueryString["FROM"])) ? "" : Request.QueryString["FROM"].ToString(),
                To = (string.IsNullOrEmpty(Request.QueryString["TO"])) ? "" : Request.QueryString["TO"].ToString(),
                Halt1 = (string.IsNullOrEmpty(Request.QueryString["HALT1"])) ? "" : Request.QueryString["HALT1"].ToString(),
                Halt2 = (string.IsNullOrEmpty(Request.QueryString["HALT2"])) ? "" : Request.QueryString["HALT2"].ToString(),
                MultiPorter = (string.IsNullOrEmpty(Request.QueryString["MULTIPORTER"])) ? "" : Request.QueryString["MULTIPORTER"].ToString(),
                patientName = (string.IsNullOrEmpty(Request.QueryString["PATIENTNAME"])) ? "" : Request.QueryString["PATIENTNAME"].ToString(),
                remarks = (string.IsNullOrEmpty(Request.QueryString["REMARKS"])) ? "" : Request.QueryString["REMARKS"].ToString(),
                Date = DateTime.Now.Date.ToString("MM/dd/yyyy") + " " + ((string.IsNullOrEmpty(Request.QueryString["TIME"])) ? "" : Request.QueryString["TIME"].ToString()),
                user = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString(),
                Priority = (string.IsNullOrEmpty(Request.QueryString["PRIORITY"])) ? "" : Request.QueryString["PRIORITY"].ToString(),
                Extra = (string.IsNullOrEmpty(Request.QueryString["EXTRAFIELDS"])) ? "" : Request.QueryString["EXTRAFIELDS"].ToString(),
                qty = (string.IsNullOrEmpty(Request.QueryString["Qty"])) ? "" : Request.QueryString["Qty"].ToString(),
                Requestor = (string.IsNullOrEmpty(Request.QueryString["REQUESTOR"])) ? "" : Request.QueryString["REQUESTOR"].ToString(),
             ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : ""),
             Kitchen = ((!string.IsNullOrEmpty(Request.QueryString["KITCHEN"])) ? Request.QueryString["KITCHEN"].ToString() : "");

        DataTable table = generate(); DataRow row = table.NewRow();
        PBDate = AESEncrytDecry.DecryptStringAES(PBDate); Category = AESEncrytDecry.DecryptStringAES(Category); From = AESEncrytDecry.DecryptStringAES(From); To = AESEncrytDecry.DecryptStringAES(To); MultiPorter = AESEncrytDecry.DecryptStringAES(MultiPorter);
        patientName = AESEncrytDecry.DecryptStringAES(patientName); remarks = AESEncrytDecry.DecryptStringAES(remarks); user = AESEncrytDecry.DecryptStringAES(user); Priority = AESEncrytDecry.DecryptStringAES(Priority); Halt1 = AESEncrytDecry.DecryptStringAES(Halt1);
        Halt2 = AESEncrytDecry.DecryptStringAES(Halt2); Extra = AESEncrytDecry.DecryptStringAES(Extra); qty = AESEncrytDecry.DecryptStringAES(qty); ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);
        Requestor = AESEncrytDecry.DecryptStringAES(Requestor); Kitchen = AESEncrytDecry.DecryptStringAES(Kitchen);

        if (PBDate != "Invalid Input" && Category != "Invalid Input" && From != "Invalid Input" && To != "Invalid Input" && MultiPorter != "Invalid Input" && patientName != "Invalid Input" && remarks != "Invalid Input" &&
            user != "Invalid Input" && Priority != "Invalid Input" && Halt1 != "Invalid Input" && Halt2 != "Invalid Input" && Extra != "Invalid Input" && qty != "Invalid Input" && Requestor != "Invalid Input"
            && ServiceID != "Invalid Input" && Kitchen != "Invalid Input")
        {
            DataTable Dt = DataAccess.InsertRequest(PBDate, Category, From, To, MultiPorter, patientName, remarks, user, Priority, Halt1, Halt2, Extra, qty, Requestor, ServiceID, Kitchen);
            row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
        }
        else
            row["RESULT"] = "FALSE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
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


    private DataSet UpdateRequest()
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
                RequestID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString(),
                StatusID = (string.IsNullOrEmpty(Request.QueryString["STATUS"])) ? "" : Request.QueryString["STATUS"].ToString(),
                CompletedRemarks = (string.IsNullOrEmpty(Request.QueryString["COMPLETEREMARKS"])) ? "" : Request.QueryString["COMPLETEREMARKS"].ToString(),
                CancelledRemarks = (string.IsNullOrEmpty(Request.QueryString["CANCELREMARKS"])) ? "" : Request.QueryString["CANCELREMARKS"].ToString(),
                qty = (string.IsNullOrEmpty(Request.QueryString["QTY"])) ? "" : Request.QueryString["QTY"].ToString(),
                Requestor = (string.IsNullOrEmpty(Request.QueryString["REQUESTOR"])) ? "" : Request.QueryString["REQUESTOR"].ToString(),
                modifiedvalus = (string.IsNullOrEmpty(Request.QueryString["MODIFIEDVALUS"])) ? "" : Request.QueryString["MODIFIEDVALUS"].ToString(),
             ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : ""),
             Kitchen = ((!string.IsNullOrEmpty(Request.QueryString["KITCHEN"])) ? Request.QueryString["KITCHEN"].ToString() : "");


        DataTable table = generate(); DataRow row = table.NewRow();
        PBDate = AESEncrytDecry.DecryptStringAES(PBDate); Category = AESEncrytDecry.DecryptStringAES(Category); From = AESEncrytDecry.DecryptStringAES(From); To = AESEncrytDecry.DecryptStringAES(To); MultiPorter = AESEncrytDecry.DecryptStringAES(MultiPorter);
        patientName = AESEncrytDecry.DecryptStringAES(patientName); remarks = AESEncrytDecry.DecryptStringAES(remarks); user = AESEncrytDecry.DecryptStringAES(user); Priority = AESEncrytDecry.DecryptStringAES(Priority);
        Extra = AESEncrytDecry.DecryptStringAES(Extra); qty = AESEncrytDecry.DecryptStringAES(qty); Requestor = AESEncrytDecry.DecryptStringAES(Requestor); modifiedvalus = AESEncrytDecry.DecryptStringAES(modifiedvalus); CancelledRemarks = AESEncrytDecry.DecryptStringAES(CancelledRemarks);
        CompletedRemarks = AESEncrytDecry.DecryptStringAES(CompletedRemarks); RequestID = AESEncrytDecry.DecryptStringAES(RequestID); StatusID = AESEncrytDecry.DecryptStringAES(StatusID);
        ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID); Kitchen = AESEncrytDecry.DecryptStringAES(Kitchen);

        if (PBDate != "Invalid Input" && Category != "Invalid Input" && From != "Invalid Input" && To != "Invalid Input" && MultiPorter != "Invalid Input" && patientName != "Invalid Input" && remarks != "Invalid Input" && user != "Invalid Input" && Priority != "Invalid Input"
             && Extra != "Invalid Input" && qty != "Invalid Input" && Requestor != "Invalid Input" && modifiedvalus != "Invalid Input" && CancelledRemarks != "Invalid Input" && CompletedRemarks != "Invalid Input" && RequestID != "Invalid Input" && StatusID != "Invalid Input"
             && Kitchen != "Invalid Input" && ServiceID != "Invalid Input")
        {
            DataTable Dt;
            if (PBDate == "")
                Dt = DataAccess.UpdateRequest(PBDate, Category, From, To, MultiPorter, patientName, remarks, user, Priority, Extra, RequestID, StatusID, CompletedRemarks, CancelledRemarks, qty, Requestor, ServiceID, Kitchen);
            else
                Dt = DataAccess.UpdateRequestPreBook(PBDate, Category, From, To, MultiPorter, patientName, remarks, user, Priority, Extra, RequestID, StatusID, CompletedRemarks, CancelledRemarks, qty, Requestor, ServiceID, Kitchen);
            row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
        }
        else
            row["RESULT"] = "FALSE";
        if (modifiedvalus.Length > 0)
            DataAccess.AddRequestLog(RequestID, modifiedvalus, user, "0");
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }


    private DataSet GetDeptIdlePorters()
    {
        string PName = ((!string.IsNullOrEmpty(Request.QueryString["PORTERNAME"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTERNAME"].ToString()) : ""),
             PorterID1 = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID1"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTERID1"].ToString()) : ""),
             PorterID2 = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID2"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTERID2"].ToString()) : ""),
            IsInitiate = ((!string.IsNullOrEmpty(Request.QueryString["ISINITIATE"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["ISINITIATE"].ToString()) : ""),
            Dept = ((!string.IsNullOrEmpty(Request.QueryString["DEPT"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["DEPT"].ToString() ): "");
        DataTable table = new DataTable();
        if (PName != DataAccess.InvalidStr && PorterID1 != DataAccess.InvalidStr && PorterID2 != DataAccess.InvalidStr && IsInitiate != DataAccess.InvalidStr && Dept != DataAccess.InvalidStr)
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
        string FloorId = ((!string.IsNullOrEmpty(Request.QueryString["FLOORID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["FLOORID"].ToString()) : "");
        HtmlTable Tmptable = new HtmlTable() { Width = "90%" }; Tmptable.Attributes.Add("style", "margin-left:10%;"); Tmptable.Attributes.Add("class", "ZoneLocation");
        DataTable dt = null;

        if (FloorId != DataAccess.InvalidStr )
        dt = DataAccess.LocationMaster(string.Empty, string.Empty, FloorId, false, "GETBYFLOOR");
        foreach (DataRow dr in dt.Rows)
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
        string FloorId = ((!string.IsNullOrEmpty(Request.QueryString["FLOORID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["FLOORID"].ToString()) : "");
        HtmlTable Tmptable = new HtmlTable() { Width = "90%", CellPadding = 10, CellSpacing = 10 }, tmpCatTble = new HtmlTable() { Width = "100%" }; Tmptable.Attributes.Add("style", "margin-left:10%;");
        HtmlTableRow tmpCatRow = new HtmlTableRow() { Height = "100px" }; HtmlTableCell tmpCatCell = new HtmlTableCell();
        DataSet DS = null;
            
          DS=  DataAccess.getRecords("SP_GETLOCCATRECORDS"); int InnerCnt = 0;
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
        string FloorId = ((!string.IsNullOrEmpty(Request.QueryString["FLOORID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["FLOORID"].ToString()) : "");
        HtmlTable Tmptable = new HtmlTable() { Width = "90%", CellPadding = 10, CellSpacing = 10 }, tmpCatTble = new HtmlTable() { Width = "100%" }; Tmptable.Attributes.Add("style", "margin-left:10%;");
        HtmlTableRow tmpCatRow = new HtmlTableRow() { Height = "100px" }; HtmlTableCell tmpCatCell = new HtmlTableCell();
        DataSet DS = DataAccess.getRecords("SP_GETREQUESTCATLOCRECORDS").Copy(); ;
        return DS;
    }

    private DataSet GetCategories()
    {
        string Value = ((!string.IsNullOrEmpty(Request.QueryString["VAL"])) ? Request.QueryString["VAL"].ToString() : ""),
            Value1 = ((!string.IsNullOrEmpty(Request.QueryString["VAL1"])) ? Request.QueryString["VAL1"].ToString() : ""),
             ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? Request.QueryString["SERVICEID"].ToString() : "");
        DataSet DS = new DataSet();
        try
        {
            Value = AESEncrytDecry.DecryptStringAES(Value); Value1 = AESEncrytDecry.DecryptStringAES(Value1); ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);
            if (Value != DataAccess.InvalidStr && Value1 != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr )
                DS = DataAccess.GetRecordss("SP_GETREQUESTCATETORIES", "@VAL", Value, "@VAL1", Value1, "@SERVICEID", ServiceID).Copy();
        }
        catch (Exception ex)
        {
            DS = new DataSet();
        }
        return DS;
    }

    private DataSet GetSearchedLocationD()
    {
        var sb = new StringBuilder();
        string Location = ((!string.IsNullOrEmpty(Request.QueryString["LOCATION"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["LOCATION"].ToString()) : "");
        HtmlTable Tmptable = new HtmlTable() { Width = "90%" }; Tmptable.Attributes.Add("style", "margin-left:10%;line-height:1.2"); Tmptable.Attributes.Add("class", "ZoneLocation");
        DataTable DtSearchedLocations = new DataTable();
        if (Location != DataAccess.InvalidStr)
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
        string Location = ((!string.IsNullOrEmpty(Request.QueryString["LOCATION"])) ? (Request.QueryString["LOCATION"].ToString()) : ""),
            ServiceID = ((string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? string.Empty : Request.QueryString["SERVICEID"].ToString()),
            sType = ((!string.IsNullOrEmpty(Request.QueryString["STYPE"])) ?  (Request.QueryString["STYPE"].ToString()) : "");

        HtmlTable Tmptable = new HtmlTable() { Width = "90%" }; Tmptable.Attributes.Add("style", "margin-left:10%;"); Tmptable.Attributes.Add("class", "ZoneLocation");


        HtmlGenericControl ul = new HtmlGenericControl("ul"); ul.Attributes.Add("class", "LocationList");


        if (!string.IsNullOrEmpty(Location))
        {
            Location = AESEncrytDecry.DecryptStringAES(Location); sType = AESEncrytDecry.DecryptStringAES(sType); ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);
            DataTable DtSearchedLocations = null;
            if (Location != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr  && sType != DataAccess.InvalidStr)
           DtSearchedLocations =DataAccess.GetRecords("SP_SEARCHLOCATION", "@LOCATION", Location, "@SERVICEID", ServiceID);
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
        string BedID = string.IsNullOrEmpty(Request.QueryString["BEDID"]) ? "0" : AESEncrytDecry.DecryptStringAES(Request.QueryString["BEDID"].ToString());
        DataTable dt = null;
        if (BedID != DataAccess.InvalidStr )
       dt = DataAccess.getPatientName(BedID);
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


            if (Search != DataAccess.InvalidStr && user != DataAccess.InvalidStr && Role != DataAccess.InvalidStr && Status != DataAccess.InvalidStr && PageIndex != DataAccess.InvalidStr && PageSize != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr)
            {
                dt = DataAccess.GetRequests(user, Role, Status, PageIndex, PageSize, Search, ServiceID);

              }
        

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
        string Status = ((!string.IsNullOrEmpty(Request.QueryString["Status"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Status"].ToString()) : ""),
        ServiceID = ((!string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["SERVICEID"].ToString()) : "");

        DataTable dt = new DataTable();
        //if (Status == "100")
        //    dt = DataAccess.PreBookingMaster(user, Role, "GETPENDINGREQUESTS", PageIndex, PageSize, string.Empty, string.Empty);
        //else
        if (Status != DataAccess.InvalidStr && ServiceID != DataAccess.InvalidStr )
       dt = DataAccess.GetPorterStatus(Status, (ServiceID));
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;

    }

    private DataSet MultiAssign()
    {
        string ReqID = ((!string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["REQUESTID"].ToString()) : "").Replace("_", "'").Replace("-", ","),
                 PorterID = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTERID"].ToString()) : ""),
                 Dept = ((!string.IsNullOrEmpty(Request.QueryString["DEPT"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["DEPT"].ToString() ): "");
        DataTable table = new DataTable();
        if (ReqID != DataAccess.InvalidStr && PorterID != DataAccess.InvalidStr && Dept != DataAccess.InvalidStr )
       table = DataAccess.MultiTasking(ReqID, PorterID, Dept).Copy();
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet ClearManualAssign()
    {
        string Dept = string.IsNullOrEmpty(Request.QueryString["DEPT"]) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["DEPT"].ToString());
        DataTable dt = null;
        if (Dept != DataAccess.InvalidStr )
       dt =DataAccess.GetRecords("SP_CLEARMANUALPROCESS", "@DEPT", Dept);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }
    private DataSet GetPorterID()
    {
        string RId = ((!string.IsNullOrEmpty(Request.QueryString["RID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["RID"].ToString()) : "").Replace("_", "'").Replace("-", ",");
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] =  (RId != DataAccess.InvalidStr? DataAccess.GetPorter(RId):"0");//(dt.Rows.Count > 0) ? (dt.Rows[0]["MULTIPORTER"].ToString() == "YES") ? (dt.Rows.Count > 1) ? dt.Rows[0]["Id"].ToString() + "_" + dt.Rows[1]["Id"].ToString() : "1001" : dt.Rows[0]["Id"].ToString() : "0";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet CheckUser()
    {

        string Result = string.Empty, UserName = (string.IsNullOrEmpty(Request.QueryString["USERNAME"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["USERNAME"].ToString()),
            pWord = (string.IsNullOrEmpty(Request.QueryString["PWD"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["PWD"].ToString());
         if (UserName != DataAccess.InvalidStr && pWord != DataAccess.InvalidStr )
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
        string Status = ((!string.IsNullOrEmpty(Request.QueryString["Status"])) ? AESEncrytDecry.DecryptStringAES((Convert.ToInt32(Request.QueryString["Status"].ToString()) + 1).ToString()) : ""),
            StartTime = string.Empty, // Auto
            EndTime = string.Empty,   // Not Required
            PortId = ((!string.IsNullOrEmpty(Request.QueryString["PORTID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTID"].ToString()) : ""),
            ReqId = ((!string.IsNullOrEmpty(Request.QueryString["Request"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Request"].ToString()) : "").Replace("_", "'").Replace("-", ","),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : AESEncrytDecry.DecryptStringAES(Request.QueryString["USERID"].ToString());//((!string.IsNullOrEmpty(Request.QueryString["USER"])) ? Request.QueryString["USER"].ToString() : "");
        DataTable table=null;
        if (User == string.Empty)
        {
            table = generate();
            DataRow row = table.NewRow();
            row["RESULT"] = "FALSE";
            table.Rows.Add(row);
        }
        else
              if (Status != DataAccess.InvalidStr && StartTime != DataAccess.InvalidStr && EndTime != DataAccess.InvalidStr && PortId != DataAccess.InvalidStr && ReqId != DataAccess.InvalidStr && User != DataAccess.InvalidStr )
            table = DataAccess.RequestMaster(string.Empty, ReqId, string.Empty, string.Empty, string.Empty, string.Empty, User, string.Empty, string.Empty, Status, StartTime, EndTime, PortId, string.Empty, string.Empty, string.Empty, process, string.Empty, string.Empty, string.Empty, string.Empty);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet GetCategoriesCL()
    {
        string Value = ((!string.IsNullOrEmpty(Request.QueryString["VAL"])) ? Request.QueryString["VAL"].ToString() : ""),
            Value1 = ((!string.IsNullOrEmpty(Request.QueryString["VAL1"])) ? Request.QueryString["VAL1"].ToString() : "");
        Value = AESEncrytDecry.DecryptStringAES(Value); Value1 = AESEncrytDecry.DecryptStringAES(Value1);
        DataSet DS = null;
        if (Value != DataAccess.InvalidStr && Value1 != DataAccess.InvalidStr)
       DS = DataAccess.GetRecordss("SP_GETREQUESTCATETORIES_SCHEDCL", "@VAL", Value, "@VAL1", Value1).Copy(); ;
        return DS;
    }
    private DataSet GetCategoriesBF()
    {
        string Value = ((!string.IsNullOrEmpty(Request.QueryString["VAL"])) ? Request.QueryString["VAL"].ToString() : ""),
            Value1 = ((!string.IsNullOrEmpty(Request.QueryString["VAL1"])) ? Request.QueryString["VAL1"].ToString() : "");
        Value = AESEncrytDecry.DecryptStringAES(Value); Value1 = AESEncrytDecry.DecryptStringAES(Value1);
        DataSet DS = null;
        if (Value != DataAccess.InvalidStr && Value1 != DataAccess.InvalidStr)
            DS = DataAccess.GetRecordss("SP_GETREQUESTCATETORIES_SCHEDBF", "@VAL", Value, "@VAL1", Value1).Copy(); ;
        return DS;
    }
    public DataSet PresetOperations()
    {
        string Process = ((!string.IsNullOrEmpty((Request.QueryString["ACTION"]))) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["ACTION"].ToString()) : ""),
             ServiceID = ((string.IsNullOrEmpty(Request.QueryString["SERVICEID"])) ? string.Empty : Request.QueryString["SERVICEID"].ToString());
        ServiceID = AESEncrytDecry.DecryptStringAES(ServiceID);
        DataTable dt = DataAccess.PersetMaster("SP_PRESETMASTER", string.Empty, string.Empty, string.Empty, Process, ServiceID).Tables[0];
        DataSet DS = new DataSet(); DS.Tables.Add(dt.Copy());
        return DS;
    }
    private DataSet SetPriority()
    {
        bool res = false;
        string Requestid = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["REQUESTID"].ToString()),
            Process = (string.IsNullOrEmpty(Request.QueryString["Priority"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["Priority"].ToString()),
            CategoryID = (string.IsNullOrEmpty(Request.QueryString["CategoryID"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["CategoryID"].ToString());
        DataTable dt = null;
        if (Requestid != DataAccess.InvalidStr && Process != DataAccess.InvalidStr && CategoryID != DataAccess.InvalidStr )
       dt =DataAccess.GetRecords("SP_REQUESTPRIORITY", "@REQUESTID", Requestid, "@PROCESS", Process, "@CATEGORYID", CategoryID);
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = (dt.Rows.Count > 0) ? dt.Rows[0]["RESULT"].ToString() : "FALSE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
}