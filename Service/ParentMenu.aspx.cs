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
public partial class ParentMenu : System.Web.UI.Page
{
    public static string process { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsValidProtocol())
            Functions();
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
    public void Functions()
    {
        DataSet data = new DataSet();
        process = ((!string.IsNullOrEmpty(Request.QueryString["Process"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Process"].ToString()) : "");
        switch (process)
        {
            case "GETPARENTMENU":
                data = GetParentMenu();
                break;
            case "GETPARENTENABLED":
                data = GetParentEnabled();
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
    private DataSet GetParentMenu()
    {
        string Role = ((!string.IsNullOrEmpty(Request.QueryString["ROLE"])) ? Request.QueryString["ROLE"].ToString().ToUpper() : "");
        DataTable table = new DataTable();
        table = DataAccess.GetRecords("SP_GETPARENTID_DISABLED", "@ROLENAME", Role).Copy();
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    private DataSet GetParentEnabled()
    {
        string Role = ((!string.IsNullOrEmpty(Request.QueryString["ROLE"])) ? Request.QueryString["ROLE"].ToString().ToUpper() : "");
        DataTable table = new DataTable();
        table = DataAccess.GetRecords("SP_GETPARENT_ENABLED", "@ROLENAME", Role).Copy();
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
}