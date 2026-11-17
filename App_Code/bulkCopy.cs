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

//AUTHOR    : NANDA KUMAR THANIGAIVELAN
//DATE      : February 25th, 2011
//E_MAIL    : nandakumar(at)icegen.net (or) nanda.sivam(at)gmail.com

/// <summary>
/// bulkCopy Class, to provide single class implementation of all the bulk insertion operations in the application
/// </summary>
public class bulkCopy
{
    //DataSet dataSet = new DataSet();
    //string dsTableName;
    //string dbTableName;
    string connectionString;

    string statusMsg;

    SqlBulkCopy sqlbcp;

	public bulkCopy()
	{
        //this.dsTableName = "";
        //this.dbTableName = "";
        this.connectionString = ConfigurationManager.ConnectionStrings["cineConn"].ToString();
        this.sqlbcp = new SqlBulkCopy(this.connectionString);

        this.statusMsg = "Initialized";
	}

    //public bulkCopy() //DataSet PdataSet, string PdsTableName, string PdbTableName
    //{
    //    this.dataSet = PdataSet;
    //    this.dsTableName = PdsTableName;
    //    this.dbTableName = PdbTableName;
    //    this.connectionString = ConfigurationManager.ConnectionStrings["patientmantraConnection"].ToString(); 

    //    this.statusMsg = "Initialized";
    //}

    /// <summary>
    /// To perform bulk insert to "TMP_XML_POSITION" and "TMP_XML_PAR" table
    /// </summary>
    /// <param name="dSet"></param>
    /// <param name="dsTableName"></param>
    /// <param name="dbTableName"></param>
    /// <returns></returns>
    public string dsBulkCopy_fetchPosition(DataSet dSet, string dsTableName, string dbTableName)
    {
        try
        {
            if (dSet.Tables.Contains(dsTableName))
            {
                if (dSet.Tables[dsTableName].Rows.Count > 0)
                {
                    //SqlBulkCopy sqlbcp = new SqlBulkCopy(this.connectionString);//,
                    //SqlBulkCopyOptions.FireTriggers);
                    if (dSet.Tables[dsTableName].Columns.Contains("tagid"))
                        sqlbcp.ColumnMappings.Add("tagid", "TAGID");
                    if (dSet.Tables[dsTableName].Columns.Contains("poszoneid"))
                        sqlbcp.ColumnMappings.Add("poszoneid", "ZONEID");
                    if (dSet.Tables[dsTableName].Columns.Contains("postimestamp"))
                        sqlbcp.ColumnMappings.Add("postimestamp", "POSTIME");
                    if (dSet.Tables[dsTableName].Columns.Contains("posx"))
                        sqlbcp.ColumnMappings.Add("posx", "POSX");
                    if (dSet.Tables[dsTableName].Columns.Contains("posy"))
                        sqlbcp.ColumnMappings.Add("posy", "POSY");
                    if (dSet.Tables[dsTableName].Columns.Contains("posmapid"))
                        sqlbcp.ColumnMappings.Add("posmapid", "MAPID");

                    //sqlbcp.DestinationTableName = dbTableName;
                    //sqlbcp.WriteToServer(dSet.Tables[dsTableName]);

                    this.sqlbcp.DestinationTableName = dbTableName;
                    this.sqlbcp.WriteToServer(dSet.Tables[dsTableName]);

                    this.statusMsg = "Success";
                }
            }
        }
        catch (Exception Excep)
        {
            this.statusMsg = Excep.Message;
            throw;
        }
        return this.statusMsg;
    }

    /// <summary>
    /// To perform bulk insert into the "TMP_XML_BATTERY" table
    /// </summary>
    /// <param name="dSet"></param>
    /// <param name="dsTableName"></param>
    /// <param name="dbTableName"></param>
    /// <returns></returns>
    public string dsBulkCopy_fetchBatterylevel(DataSet dSet, string dsTableName, string dbTableName)
    {
        try
        {
            if (dSet.Tables.Contains(dsTableName))
            {
                if (dSet.Tables[dsTableName].Rows.Count > 0)
                {
                    //SqlBulkCopy sqlbcp = new SqlBulkCopy(this.connectionString);
                    if (dSet.Tables[dsTableName].Columns.Contains("tagid"))
                        sqlbcp.ColumnMappings.Add("tagid", "TAGID");
                    if (dSet.Tables[dsTableName].Columns.Contains("battery"))
                        sqlbcp.ColumnMappings.Add("battery", "BATTERY");
                    if (dSet.Tables[dsTableName].Columns.Contains("postimestamp"))
                        sqlbcp.ColumnMappings.Add("postimestamp", "POSTIME");

                    //sqlbcp.DestinationTableName = dbTableName;
                    //sqlbcp.WriteToServer(dSet.Tables[dsTableName]);

                    this.sqlbcp.DestinationTableName = dbTableName;
                    this.sqlbcp.WriteToServer(dSet.Tables[dsTableName]);

                    this.statusMsg = "Success";
                }
            }
        }
        catch (Exception Excep)
        {
            this.statusMsg = Excep.Message;
            throw;
        }
        return this.statusMsg;
    }

    public string dsBulkCopy_fetchZone(DataSet dSet, string dsTableName, string dbTableName)
    {
        try
        {
            if (dSet.Tables.Contains(dsTableName))
            {
                if (dSet.Tables[dsTableName].Rows.Count > 0)
                {
                    //SqlBulkCopy sqlbcp = new SqlBulkCopy(this.connectionString);
                    if (dSet.Tables[dsTableName].Columns.Contains("zoneid"))
                        sqlbcp.ColumnMappings.Add("zoneid", "ZONEID");
                    if (dSet.Tables[dsTableName].Columns.Contains("zonename"))
                    {
                        sqlbcp.ColumnMappings.Add("zonename", "ZONENAME");
                        sqlbcp.ColumnMappings.Add("zonename", "ZONECODE");  
                    }
                    if (dSet.Tables[dsTableName].Columns.Contains("polygon"))
                        sqlbcp.ColumnMappings.Add("polygon", "ZONERANGE");
                    if (dSet.Tables[dsTableName].Columns.Contains("mapid"))
                        sqlbcp.ColumnMappings.Add("mapid", "FLOORID");

                    //sqlbcp.DestinationTableName = dbTableName;
                    //sqlbcp.WriteToServer(dSet.Tables[dsTableName]);

                    this.sqlbcp.DestinationTableName = dbTableName;
                    this.sqlbcp.WriteToServer(dSet.Tables[dsTableName]);

                    this.statusMsg = "Success";
                }
            }
        }
        catch (Exception Excep)
        {
            this.statusMsg = Excep.Message;
            throw;
        }
        return this.statusMsg;
    }

    public string dsBulkCopy_fetchFloor(DataSet dSet, string dsTableName, string dbTableName)
    {
        try
        {
            if (dSet.Tables.Contains(dsTableName))
            {
                if (dSet.Tables[dsTableName].Rows.Count > 0)
                {
                    //SqlBulkCopy sqlbcp = new SqlBulkCopy(this.connectionString);
                    if (dSet.Tables[dsTableName].Columns.Contains("mapid"))
                        sqlbcp.ColumnMappings.Add("mapid", "FLOORID");
                    if (dSet.Tables[dsTableName].Columns.Contains("mapname"))
                    {
                        sqlbcp.ColumnMappings.Add("mapname", "FLOORNAME");
                        sqlbcp.ColumnMappings.Add("mapname", "FLOORCODE");
                    }

                    //sqlbcp.DestinationTableName = dbTableName;
                    //sqlbcp.WriteToServer(dSet.Tables[dsTableName]);

                    this.sqlbcp.DestinationTableName = dbTableName;
                    this.sqlbcp.WriteToServer(dSet.Tables[dsTableName]);

                    this.statusMsg = "Success";
                }
            }
        }
        catch (Exception Excep)
        {
            this.statusMsg = Excep.Message;
            throw;
        }
        return this.statusMsg;
    }

    /// <summary>
    /// To perform bulk insert into the "TMP_XML_EMERGENCY" table
    /// </summary>
    /// <param name="dSet"></param>
    /// <param name="dsTableName"></param>
    /// <param name="dbTableName"></param>
    /// <returns></returns>
    public string dsBulkCopy_fetchEmergency(DataSet dSet, string dsTableName, string dbTableName)
    {
        try
        {
            if (dSet.Tables.Contains(dsTableName))
            {
                if (dSet.Tables[dsTableName].Rows.Count > 0)
                {
                    //SqlBulkCopy sqlbcp = new SqlBulkCopy(this.connectionString);
                    if (dSet.Tables[dsTableName].Columns.Contains("tagid"))
                        sqlbcp.ColumnMappings.Add("tagid", "TAGID");
                    if (dSet.Tables[dsTableName].Columns.Contains("zoneid"))
                        sqlbcp.ColumnMappings.Add("zoneid", "ZONEID");
                    if (dSet.Tables[dsTableName].Columns.Contains("postimestamp"))
                        sqlbcp.ColumnMappings.Add("postimestamp", "POSTIME");
                    if (dSet.Tables[dsTableName].Columns.Contains("posreason"))
                        sqlbcp.ColumnMappings.Add("posreason", "EVENTTYPE");

                    //sqlbcp.DestinationTableName = dbTableName;
                    //sqlbcp.WriteToServer(dSet.Tables[dsTableName]);

                    this.sqlbcp.DestinationTableName = dbTableName;
                    this.sqlbcp.WriteToServer(dSet.Tables[dsTableName]);

                    this.statusMsg = "Success";
                }
            }
        }
        catch (Exception Excep)
        {
            this.statusMsg = Excep.Message;
            throw;
        }
        return this.statusMsg;

    }
}
