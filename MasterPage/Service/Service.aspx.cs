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
        process = ((!string.IsNullOrEmpty((Request.QueryString["Process"]))) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Process"].ToString()) : "");
        switch (process)
        {
            case "GETMENU":
                data = GetMenu();
                break;
            case "GETPENDINGREQUESTS":
                data = GetPendingRequest();
                break;
            case "CHANGEPASSWORD":
                data = UpdatePassword();
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
    private DataSet GetMenu()
    {
        string RoleID = ((!string.IsNullOrEmpty(Request.QueryString["ROLEID"])) ? Request.QueryString["ROLEID"].ToString() : "");

        string RoID = AESEncrytDecry.DecryptStringAES(RoleID.Trim()); DataTable table = new DataTable();

        if (RoID != "Invalid Input")
            table = DataAccess.GetRecord("SP_GETPAGES_BYROLE", "@ROLEID", RoID).Tables[0].Copy();
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
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
    private DataSet GetPendingRequest()
    {
        string User = ((!string.IsNullOrEmpty(Request.QueryString["USERID"])) ? Request.QueryString["USERID"].ToString().ToUpper() : "");
        DataTable dt = DataAccess.GetPopDetails(string.Empty, User.Trim(), string.Empty);
        DataSet DS = new DataSet(); DS.Tables.Add(dt);
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
}