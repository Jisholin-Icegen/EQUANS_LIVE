using System;
using System.Data;
//using System.Configuration;
//using System.Linq;
//using System.Web;
//using System.Web.Security;
//using System.Web.UI;
//using System.Web.UI.HtmlControls;
//using System.Web.UI.WebControls;
//using System.Web.UI.WebControls.WebParts;
//using System.Xml.Linq;
using System.Xml;

using System.Data.SqlClient;

/// <summary>
/// Summary description for dbClass
/// </summary>
public class dbClass:ConnectionClass
{
    SqlCommand dbCommand;

    string tableName;
    string columnName;
    string columnStr;
    string columnValueStr;
    string condtnStr;

    string SQLStr;

    string rtn_msg;



    /// <summary>
    /// Default Constructor
    /// </summary>
	public dbClass()
	{
        this.SQLStr = "";
        this.tableName = "";
        this.columnName = "";
        this.columnStr = "";
        this.columnValueStr = "";
        this.condtnStr = "";
        this.rtn_msg = "";
    }

    /// <summary>
    /// Method to initialize variables required for recordCount() method
    /// </summary>
    /// <param name="PtableName">Name of the Table</param>
    /// <param name="PcolumnName">Column name to use Count</param>
    /// <param name="PcondtnStr">Filter based on the conditions</param>
    public void recordCountInit(string PtableName, string PcolumnName, string PcondtnStr)
    {
        this.tableName = PtableName;
        this.columnName = PcolumnName;
        this.condtnStr = PcondtnStr;
        this.rtn_msg = "recordCount";

        this.SQLStr = "SELECT COUNT(" + this.columnName + ") AS IDCOUNT FROM " + this.tableName;
        if (this.condtnStr.Length > 0)
            this.SQLStr += " WHERE " + this.condtnStr;
    }

    /// <summary>
    /// To return the count values based on the parameters, call recordCountInit() method before caling this method.
    /// </summary>
    /// <returns></returns>
    public int recordCount()
    {
        try
        {
            this.dbCommand = new SqlCommand();
            this.dbCommand.Connection = this.connectionOpen();
            this.dbCommand.CommandType = CommandType.Text;
            this.dbCommand.CommandText = this.SQLStr;
            return (int)this.dbCommand.ExecuteScalar();
        }
        catch (Exception Excep)
        {
            this.rtn_msg = Excep.Message;
            throw;
        }
    }


    /// <summary>
    /// Method to initialize variables required for recordInsert() method
    /// </summary>
    /// <param name="PtableName">Name of the Table</param>
    /// <param name="PcolumnStr">Name of the columns to insert</param>
    /// <param name="PcolumnValueStr">Values of the columns to insert</param>
    public void recordInsertInit(string PtableName, string PcolumnStr, string PcolumnValueStr)
    {
        this.tableName = PtableName;
        this.columnStr = PcolumnStr;
        this.columnValueStr = PcolumnValueStr;
        this.rtn_msg = "recordInsert";

        this.SQLStr = "INSERT INTO " + this.tableName + " (" + this.columnValueStr + ") VALUES (" + this.columnValueStr + ")";
    }

    /// <summary>
    /// To insert values to the table, call recordInsertInit() method before calling this method
    /// </summary>
    /// <returns>status of the operation in string</returns>
    public string recordInsert()
    {
        try
        {
            this.dbCommand = new SqlCommand();
            this.dbCommand.Connection = this.connectionOpen();
            this.dbCommand.CommandType = CommandType.Text;
            this.dbCommand.CommandText = this.SQLStr;
            this.dbCommand.ExecuteNonQuery();
            this.rtn_msg = "Success";
        }
        catch (Exception Excep)
        {
            this.rtn_msg = Excep.Message;
            throw;
        }
        return this.rtn_msg;
    }

    /// <summary>
    /// Method to initialize variables required for recordUpdate() method
    /// </summary>
    /// <param name="PtableName">Name of the Table</param>
    /// <param name="PcolumnValueStr">Column Value Pairs</param>
    /// <param name="PcondtnStr">Filter condition</param>
    public void recordUpdateInit(string PtableName, string PcolumnValueStr, string PcondtnStr)
    {
        this.tableName = PtableName;
        this.columnValueStr = PcolumnValueStr;
        this.condtnStr = PcondtnStr;
        this.rtn_msg = "recordUpdate";

        this.SQLStr = "UPDATE " + this.tableName + " SET " + this.columnValueStr;
        if (this.condtnStr.Length > 0)
            this.SQLStr += " WHERE " + this.condtnStr;
    }

    /// <summary>
    /// To update a row or a column, call recordUpdateInit() method before calling this method
    /// </summary>
    /// <returns>status of the operation in string</returns>
    public string recordUpdate()
    {
        try
        {
            this.dbCommand = new SqlCommand();
            this.dbCommand.Connection = this.connectionOpen();
            this.dbCommand.CommandType = CommandType.Text;
            this.dbCommand.CommandText = this.SQLStr;
            this.dbCommand.ExecuteNonQuery();
            this.rtn_msg = "Success";
        }
        catch (Exception Excep)
        {
            this.rtn_msg = Excep.Message;
            throw;
        }
        return this.rtn_msg;
    }

    /// <summary>
    /// Method to initialize variables required for recordDelete() method
    /// </summary>
    /// <param name="PtableName">Name of the Table</param>
    /// <param name="PcondtnStr">delete based on the conditions</param>
    public void recordDeleteInit(string PtableName, string PcondtnStr)
    {
        this.tableName = PtableName;
        this.condtnStr = PcondtnStr;
        this.rtn_msg = "recordDelete";

        this.SQLStr = "DELETE FROM " + this.tableName;
        if (this.condtnStr.Length > 0)
            this.SQLStr += " WHERE " + this.condtnStr;
    }

    /// <summary>
    /// To delete a row(s) from table, call recordDeleteInit() method before calling this method
    /// </summary>
    /// <returns>status of the operation in string</returns>
    public string recordDelete()
    {
        try
        {
            this.dbCommand = new SqlCommand();
            this.dbCommand.Connection = this.connectionOpen();
            this.dbCommand.CommandType = CommandType.Text;
            this.dbCommand.CommandText = this.SQLStr;
            this.dbCommand.ExecuteNonQuery();
            this.rtn_msg = "Success";
        }
        catch (Exception Excep)
        {
            this.rtn_msg = Excep.Message;
            throw;
        }
        return this.rtn_msg;
    }

    /// <summary>
    /// Method to initialize variables required for recordSelect() method
    /// </summary>
    /// <param name="PtableName">Name of the Table</param>
    /// <param name="PcolumnName">Column name to Select</param>
    /// <param name="PcondtnStr">Filter based on the conditions</param>
    public void recordSelectInit(string PtableName, string PcolumnName, string PcondtnStr)
    {
        this.tableName = PtableName;
        this.columnName = PcolumnName;
        this.condtnStr = PcondtnStr;
        this.rtn_msg = "recordSelect";

        this.SQLStr = "SELECT " + this.columnName + " FROM " + this.tableName;
        if (this.condtnStr.Length > 0)
            this.SQLStr += " WHERE " + this.condtnStr;
    }

    /// <summary>
    /// To select <b>a particular field or column value </b> from table, call recordSelectInit
    /// </summary>
    /// <returns>status of the operation in string</returns>
    public string recordSelect()
    {
        try
        {
            this.dbCommand = new SqlCommand();
            this.dbCommand.Connection = this.connectionOpen();
            this.dbCommand.CommandType = CommandType.Text;
            this.dbCommand.CommandText = this.SQLStr;
            return this.dbCommand.ExecuteScalar().ToString();
        }
        catch (Exception Excep)
        {
            this.rtn_msg = Excep.Message;
            throw;
        }
    }
    public void recordforxml(string PtableName, string PcolumnName, string PcondtnStr)
    {
        this.tableName = PtableName;
        this.columnName = PcolumnName;
        this.condtnStr = PcondtnStr;
        this.rtn_msg = "recordCount";

        this.SQLStr = "SELECT " + this.columnName + "  FROM " + this.tableName+" for xml raw,elements,root('POSITION')";
        if (this.condtnStr.Length > 0)
            this.SQLStr += " WHERE " + this.condtnStr;
    }

    /// <summary>
    /// To return the count values based on the parameters, call recordCountInit() method before caling this method.
    /// </summary>
    /// <returns></returns>
    public XmlDocument  recordSelectForXml()
    {
        XmlReader reader = null;
        XmlDocument docs = new XmlDocument();
        try
        {
            
            this.dbCommand = new SqlCommand();
            this.dbCommand.Connection = this.connectionOpen();
            this.dbCommand.CommandType = CommandType.Text;
            this.dbCommand.CommandText = this.SQLStr;
            reader = dbCommand.ExecuteXmlReader();
             docs.Load(reader);
             return (docs);
        }
        catch (Exception Excep)
        {
            this.rtn_msg = Excep.Message;
            throw;
        }
    }
    public void recordSelectInitforDataset(string PtableName, string PcolumnName, string PcondtnStr)
    {
        this.tableName = PtableName;
        this.columnName = PcolumnName;
        this.condtnStr = PcondtnStr;
        this.rtn_msg = "recordSelect";

        this.SQLStr = "SELECT " + this.columnName + " FROM " + this.tableName;
        if (this.condtnStr.Length > 0)
            this.SQLStr += " WHERE " + this.condtnStr;
    }

    /// <summary>
    /// To select <b>a particular field or column value </b> from table, call recordSelectInit
    /// </summary>
    /// <returns>status of the operation in string</returns>
    public DataSet  recordSelectforDataset()
    {
        DataSet ds = new DataSet();
        try
        {
            this.dbCommand = new SqlCommand();
            this.dbCommand.Connection = this.connectionOpen();
            this.dbCommand.CommandType = CommandType.Text;
            this.dbCommand.CommandText = this.SQLStr;
            SqlDataAdapter adap = new SqlDataAdapter(this.dbCommand);
            adap.Fill(ds);
        }
        catch (Exception Excep)
        {
            this.rtn_msg = Excep.Message;
            throw;
        }
        return ds;
    }
}
