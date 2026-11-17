using System;
using System.Data;
using System.Configuration;
//using System.Linq;
//using System.Web;
//using System.Web.Security;
//using System.Web.UI;
//using System.Web.UI.HtmlControls;
//using System.Web.UI.WebControls;
//using System.Web.UI.WebControls.WebParts;
//using System.Xml.Linq;

using System.Data.SqlClient;

/// <summary>
/// ConnectionClass, separate class for establishing connection between SQL Server and the application
/// Nanda Kumar Thanigaivelan
/// February 24th, 2011
/// nandakumar(at)icegen.net
/// </summary>
public class ConnectionClass
{
    SqlConnection dbConn;
    /// <summary>
    /// Default Constructor
    /// <para>Initalize the connection string</para>
    /// </summary>
	public ConnectionClass()
	{
        this.dbConn = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString);
	}

    /// <summary>
    /// Establish the connection between the application and the SQL Server
    /// </summary>
    /// <returns></returns>
    public SqlConnection connectionOpen()
    {
        try
        {
            this.dbConn.Open();
            return dbConn;
        }
        catch (Exception)
        {
            throw;
        }
    }

    /// <summary>
    /// Terminate the established connection between the application and the SQL Server
    /// </summary>
    public void connectionClose()
    {
        try
        {
            this.dbConn.Close();
            this.dbConn.Dispose();
        }
        catch (Exception)
        {
            throw;
        }
    }
    public void connectionDispose()
    {
        try
        {
            this.dbConn.Dispose();
        }
        catch (Exception)
        {
            throw;
        }
    }
}
