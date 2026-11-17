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
public partial class Planner_Service_ServicePlanner : System.Web.UI.Page
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

    public DataSet GetPendingTasks()
    {
        string PorterID = string.IsNullOrEmpty(Request.QueryString["PORTERID"]) ? "" : Request.QueryString["PORTERID"].ToString();

        DataSet dt = new DataSet();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_PENDINGTASK_ADDTASKS", Con);
        cmd.CommandTimeout = 1000;
        cmd.Parameters.AddWithValue("@PORTERID", PorterID);
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
    public DataSet AddTasks()
    {
        string PorterID = string.IsNullOrEmpty(Request.QueryString["PORTERID"]) ? "" : Request.QueryString["PORTERID"].ToString(),
               RequestIDs = string.IsNullOrEmpty(Request.QueryString["REQUESTIDS"]) ? "" : Request.QueryString["REQUESTIDS"].ToString(),
               UserID = string.IsNullOrEmpty(Request.QueryString["USERID"]) ? "" : Request.QueryString["USERID"].ToString();

        DataSet dt = new DataSet();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_ADDTASKS", Con);
        cmd.CommandTimeout = 1000;
        cmd.Parameters.AddWithValue("@PORTERID", PorterID);
        cmd.Parameters.AddWithValue("@REQUESTIDS", RequestIDs);
        cmd.Parameters.AddWithValue("@USERID", UserID);
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

    public void FromWebMobile()
    {
        DataSet data = new DataSet();
        process = ((!string.IsNullOrEmpty(Request.QueryString["Process"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Process"].ToString()) : "");
        switch (process)
        {
            case "PENDINGTASKS":
                data = GetPendingTasks();
                break;

            case "ASSIGNTASKS":
                data = AddTasks();
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

}