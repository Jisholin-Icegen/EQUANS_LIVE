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
        bool ValidateHTTP = (ConfigurationManager.AppSettings["ValidateHTTP"].ToString() == "1");
        return true;// (ValidateHTTP) ? (ProtocolAllowed == RequestProtocol) : true;// (ProtocolAllowed == RequestProtocol);
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
        process = ((!string.IsNullOrEmpty((Request.QueryString["Process"]))) ? Request.QueryString["Process"].ToString().ToUpper() : "");
        switch (process)
        {

            case "CHECKUSER":
                data = CheckUser();
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

    private DataSet CheckUser()
    {

        string UserName = (string.IsNullOrEmpty(Request.QueryString["USERNAME"])) ? "" : Request.QueryString["USERNAME"].ToString(),
            pWord = (string.IsNullOrEmpty(Request.QueryString["PWD"])) ? "" : Request.QueryString["PWD"].ToString(),
            pHIS = (string.IsNullOrEmpty(Request.QueryString["PWD"])) ? "" : Request.QueryString["PWD"].ToString(),
            Result = DataAccess.CheckUser(AESEncrytDecry.DecryptStringAES(UserName.Trim()), AESEncrytDecry.DecryptStringAES(pWord.Trim())),
            //Url = ConfigurationManager.AppSettings["HISLogin"].ToString() + UserName + "&password=" + pHIS,
            HISName = string.Empty;
        DataTable table = generate();
        DataRow row = table.NewRow();
        if (new string[] { "FALSE", "INVALID" }.Contains(Result))
            row["RESULT"] = "FALSE";
        else
        {
            setSession(Result);
            row["RESULT"] = Result; //row["RESULT"] = ((Session["ROLE"].ToString() == "ADMIN") ? "Master/CategoryMaster.aspx" : "Request/Request.aspx");
        }
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;
    }
    public string CheckHIS(string url)
    {
        WebClient client = new WebClient();
        string json = client.DownloadString(url);
        var jss = new JavaScriptSerializer();
        Dictionary<string, string> sData = jss.Deserialize<Dictionary<string, string>>(json);

        return ((sData["auth"].ToString() == "Yes") ? sData["userName"].ToString() : "FALSE");
        //string _Name = sData["Name"].ToString();
        //string _Subject = sData["Subject"].ToString();
        //string _Email = sData["Email"].ToString();
        //string _Details = sData["Details"].ToString();
        //HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
        //request.Method = "POST";
        //HttpWebResponse response = (HttpWebResponse)request.GetResponse();

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


    private void setSession(string Role)
    {
        Session["ID"] = Role.Split('_')[0].ToString();
        Session["NAME"] = Role.Split('_')[1].ToString();
        Session["PASSWORD"] = Role.Split('_')[2].ToString();
        Session["ROLE"] = Role.Split('_')[3].ToString();
    }
}