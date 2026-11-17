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
public partial class Track_LocateGPS : System.Web.UI.Page
{
    public static string process { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        FromWebMobile();
    }
    public void FromWebMobile()
    {
        DataSet data = new DataSet();
        process = ((!string.IsNullOrEmpty((Request.QueryString["Process"]))) ? AESEncrytDecry.DecryptStringAES( Request.QueryString["Process"].ToString()) : "");
        switch (process)
        {
            case "GETGPSDETAILS":
                data = GetGPSDetails();
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


    private DataSet GetGPSDetails()
    {
        string DeviceID = ((!string.IsNullOrEmpty(Request.QueryString["DEVICEID"])) ? Request.QueryString["DEVICEID"].ToString().ToUpper() : ""),
            CurTime = ((!string.IsNullOrEmpty(Request.QueryString["CurrentTime"])) ? Request.QueryString["CurrentTime"].ToString().ToUpper() : "");
        DataTable dt = DataAccess.GetRecords("SP_GETGPSDETAILS", "@DEVICEID", DeviceID);
        DataTable table = generate();
        DataRow row = table.NewRow();
        row["RESULT"] = dt.Rows[0]["RESULT"].ToString().ToUpper();
        table.Rows.Add(row);
        DataSet DS = new DataSet(); DS.Tables.Add(table);
        return DS;

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