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

using ClientsideEncryption;

public partial class Service_ServiceRequest : System.Web.UI.Page
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
            case "RELEASEPORTER":
                data = ReleasePorter();
                break;
            case "COMPLETETASK":
                data = completeTask();
                break;
            case "ADHOCASSIGN":
                data = ManualAssign();
                break;
            case "GETDEPTPORTERS":
                data = GetDeptPorters();
                break;
            case "CLEARMANUALASSIGN":
                data = ClearManualAssign();
                break;
            case "STARTTASK":
                data = startTask();
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

    private DataSet startTask()
    {
        string REASON = ((!string.IsNullOrEmpty(Request.QueryString["REASON"])) ? Request.QueryString["REASON"].ToString() : ""),
            MIndex = (string.IsNullOrEmpty(Request.QueryString["MIINDEX"])) ? "" : Request.QueryString["MIINDEX"].ToString().Trim(),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString(),
            REQUESTID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString().Trim();

        DataTable table = generate(); DataRow row = table.NewRow();

        REASON = AESEncrytDecry.DecryptStringAES(REASON); MIndex = AESEncrytDecry.DecryptStringAES(MIndex); User = AESEncrytDecry.DecryptStringAES(User); REQUESTID = AESEncrytDecry.DecryptStringAES(REQUESTID);
        if (REASON != "Invalid Input" && MIndex != "Invalid Input" && User != "Invalid Input" && REQUESTID != "Invalid Input")
        {
            DataTable Dt = DataAccess.StartTask(REQUESTID, REASON, MIndex, User);
            row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
        }
        else
            row["RESULT"] = "FALSE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet completeTask()
    {
        string REASON = ((!string.IsNullOrEmpty(Request.QueryString["REASON"])) ? Request.QueryString["REASON"].ToString() : ""),
            REQUESTID = (string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? "" : Request.QueryString["REQUESTID"].ToString().Trim(),
            MIndex = (string.IsNullOrEmpty(Request.QueryString["MIINDEX"])) ? "" : Request.QueryString["MIINDEX"].ToString().Trim(),
            User = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? string.Empty : Request.QueryString["USERID"].ToString();
        DataTable table = generate(); DataRow row = table.NewRow();

        REASON = AESEncrytDecry.DecryptStringAES(REASON); MIndex = AESEncrytDecry.DecryptStringAES(MIndex); User = AESEncrytDecry.DecryptStringAES(User); REQUESTID = AESEncrytDecry.DecryptStringAES(REQUESTID);
        if (REASON != "Invalid Input" && MIndex != "Invalid Input" && User != "Invalid Input" && REQUESTID != "Invalid Input")
        {
            DataTable Dt = DataAccess.CompleteTask(REQUESTID, REASON, User, MIndex);
            row["RESULT"] = Dt.Rows[0]["RESULT"].ToString();
        }
        else
            row["RESULT"] = "FALSE";
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    private DataSet GetDeptPorters()
    {
        string PName = ((!string.IsNullOrEmpty(Request.QueryString["PORTERNAME"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTERNAME"].ToString()) : ""),
             PorterID1 = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID1"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTERID1"].ToString()) : ""),
             PorterID2 = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID2"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTERID2"].ToString()) : ""),
            IsInitiate = ((!string.IsNullOrEmpty(Request.QueryString["ISINITIATE"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["ISINITIATE"].ToString()) : "");
        DataTable table = new DataTable();

        if (PName != DataAccess.InvalidStr && PorterID1 != DataAccess.InvalidStr && PorterID2 != DataAccess.InvalidStr && IsInitiate != DataAccess.InvalidStr )
        table = DataAccess.GetDeptPorters(PName, IsInitiate, PorterID1, PorterID2).Copy();
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

    private string GetPath(object ImageByte)
    {
        byte[] rPicture = (byte[])ImageByte;
        string base64String = Convert.ToBase64String(rPicture, 0, rPicture.Length);
        string path = "data:image/png;base64," + base64String;
        return path;
    }
    private DataSet ManualAssign()
    {
        string ReqID = ((!string.IsNullOrEmpty(Request.QueryString["REQUESTID"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["REQUESTID"].ToString()) : ""),
             PorterID1 = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID1"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTERID1"].ToString()) : ""),
             PorterID2 = ((!string.IsNullOrEmpty(Request.QueryString["PORTERID2"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["PORTERID2"].ToString()) : "");
        DataTable table = new DataTable();
        if (ReqID != DataAccess.InvalidStr && PorterID1 != DataAccess.InvalidStr && PorterID2 != DataAccess.InvalidStr )
        table = DataAccess.ManualAssign(ReqID, PorterID1, PorterID2).Copy();
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }


    private DataSet ClearManualAssign()
    {
        string Dept = string.IsNullOrEmpty(Request.QueryString["DEPT"]) ? string.Empty : Request.QueryString["DEPT"].ToString();
        DataTable dt = null;
         
        dt = DataAccess.GetRecords("SP_CLEARMANUALPROCESS");
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
        return DS;
    }
    private DataSet ReleasePorter()
    {
        string ReqID = (string.IsNullOrEmpty(Request.QueryString["REQID"])) ? "" : AESEncrytDecry.DecryptStringAES(Request.QueryString["REQID"].ToString());

        DataTable table = null;
        if (ReqID != DataAccess.InvalidStr)
        table =DataAccess.GetRecords("SP_RELEASEPORTER", "@REQID", ReqID);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }

    //private DataSet completeTask()
    //{
    //    string PorterIDs = (string.IsNullOrEmpty(Request.QueryString["PORTERIDSS"])) ? "" : Request.QueryString["PORTERIDSS"].ToString(),
    //        UserID = (string.IsNullOrEmpty(Request.QueryString["USERID"])) ? "" : Request.QueryString["USERID"].ToString(),
    //        Remarks = (string.IsNullOrEmpty(Request.QueryString["REMARKS"])) ? "" : Request.QueryString["REMARKS"].ToString();

    //    DataTable table = DataAccess.GetRecords("SP_COMPLETECURRENTTASK", "@TAGID", PorterIDs, "@USERID", UserID, "@REMARKS", Remarks);
    //    DataSet DS = new DataSet(); DS.Tables.Add(table);
    //    return DS;
    //}

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


}