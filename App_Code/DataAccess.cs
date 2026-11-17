using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Net.Mail;
using System.Net;
using System.IO;
using System.Xml;
using System.Web.Services.Description;
using System.Drawing;

public class DataAccess
{
    public const string InvalidStr = "Invalid Input";

    public DataAccess()
    {

    }
    public static DataTable UpdateEquipment(string name, string shortName, string division, string isActive, string assistantRequired, string id)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("RESULT", typeof(string));

        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString))
        {
            try
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SP_EQUIPMENT_INSERTUPDATE", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@NAME", name ?? "");
                    cmd.Parameters.AddWithValue("@SHORT", shortName ?? "");
                    cmd.Parameters.AddWithValue("@DIVISION", division ?? "");

                    int activeBit = (!string.IsNullOrWhiteSpace(isActive) &&
                                    (isActive.ToLower() == "true" || isActive == "1")) ? 1 : 0;
                    int assistantBit = (!string.IsNullOrWhiteSpace(assistantRequired) &&
                                       (assistantRequired.ToLower() == "yes" || assistantRequired == "1")) ? 1 : 0;

                    cmd.Parameters.AddWithValue("@ISACTIVE", activeBit);
                    cmd.Parameters.AddWithValue("@ASSISTANTREQUIRED", assistantBit);
                    cmd.Parameters.AddWithValue("@ID", string.IsNullOrWhiteSpace(id) ? (object)0 : Convert.ToInt32(id));

                    object result = cmd.ExecuteScalar();

                    if (result != null)
                    {
                        DataRow row = dt.NewRow();
                        row[0] = result.ToString();
                        dt.Rows.Add(row);
                    }

                    System.Diagnostics.Debug.WriteLine("DataTable Rows: " + dt.Rows.Count.ToString());
                    if (dt.Rows.Count > 0)
                        System.Diagnostics.Debug.WriteLine("RESULT: '" + dt.Rows[0][0].ToString() + "'");
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("ERROR: " + ex.Message);
                InsertError(ex.Message, "SP_EQUIPMENT_INSERTUPDATE");
            }
        }
        return dt;
    }

    public static DataTable ChangePwd(string userId, string password, string process)
    {
        using (SqlConnection conn = new SqlConnection("cineConn"))
        {
            using (SqlCommand cmd = new SqlCommand("SP_CHANGEPWD", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@USERID", userId);
                cmd.Parameters.AddWithValue("@PASSWORD", password);
                cmd.Parameters.AddWithValue("@PROCESS", process);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                return dt;
            }
        }
    }
    public static DataSet GetUpdateBuzzer(string alertid, string ime, string type)
    {
        DataSet ds = new DataSet();
        try
        {

            SqlDataAdapter dbAdap = new SqlDataAdapter();
            SqlConnection sqlCON = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
            dbAdap.SelectCommand = new SqlCommand();
            dbAdap.SelectCommand.CommandText = "SP_ALERTRAISEDLIST";
            dbAdap.SelectCommand.CommandType = CommandType.StoredProcedure;
            dbAdap.SelectCommand.Connection = sqlCON;
            dbAdap.SelectCommand.Parameters.AddWithValue("@ptype", type);
            dbAdap.SelectCommand.Parameters.AddWithValue("@ALERTID", alertid);
            dbAdap.SelectCommand.Parameters.AddWithValue("@IMEINO", ime);
            dbAdap.Fill(ds);
            dbAdap.Dispose();
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_ALERTRAISEDLIST");
            ds = new DataSet();
        }

        return ds;
    }


    public static DataSet getPorterLocation(string tagid)
    {
        DataSet dt = new DataSet();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("GetPorterLocation", Con);
        cmd.CommandTimeout = 1000;
        cmd.Parameters.AddWithValue("@TagId", tagid);

        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_GETPATIENTNAMEBYBEDID");
            dt = new DataSet();

        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;

    }
    public static DataTable SendMessage(string DeviceId, string msg, string userid, string porterid, string preqid, string preno, string process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_MESSAGEMASTER_INSRT", Con);
            cmd.Parameters.AddWithValue("@DEVICEID", DeviceId);
            cmd.Parameters.AddWithValue("@MESSAGE", msg);
            cmd.Parameters.AddWithValue("@USERID", userid);
            cmd.Parameters.AddWithValue("@PORTERID", porterid);
            cmd.Parameters.AddWithValue("@PREVIOUSREQUESTID", preqid);
            cmd.Parameters.AddWithValue("@PREVIOUSREQUESTNO", preno);
            cmd.Parameters.AddWithValue("@PROCESS", process);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_MESSAGEMASTER_INSRT");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable SendMessageNew(string DeviceId, string msg, string userid, string porterid, string preqid, string preno, string process, string ServiceID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_MESSAGEMASTER_INSRT", Con);
            cmd.Parameters.AddWithValue("@DEVICEID", DeviceId);
            cmd.Parameters.AddWithValue("@MESSAGE", msg);
            cmd.Parameters.AddWithValue("@USERID", userid);
            cmd.Parameters.AddWithValue("@PORTERID", porterid);
            cmd.Parameters.AddWithValue("@PREVIOUSREQUESTID", preqid);
            cmd.Parameters.AddWithValue("@PREVIOUSREQUESTNO", preno);
            cmd.Parameters.AddWithValue("@PROCESS", process);
            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_MESSAGEMASTER_INSRT");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }


    //public static DataTable SendMessage(string DeviceId, string msg, string userid, string porterid, string preqid, string preno, string process)
    //{
    //    DataTable dt = new DataTable();
    //    SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
    //    try
    //    {
    //        SqlCommand cmd = new SqlCommand("SP_MESSAGEMASTER_INSRT", Con);
    //        cmd.Parameters.AddWithValue("@DEVICEID", DeviceId);
    //        cmd.Parameters.AddWithValue("@MESSAGE", msg);
    //        cmd.Parameters.AddWithValue("@USERID", userid);
    //        cmd.Parameters.AddWithValue("@PORTERID", porterid);
    //        cmd.Parameters.AddWithValue("@PREVIOUSREQUESTID", preqid);
    //        cmd.Parameters.AddWithValue("@PREVIOUSREQUESTNO", preno);
    //        cmd.Parameters.AddWithValue("@PROCESS", process);
    //        cmd.CommandType = CommandType.StoredProcedure;
    //        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
    //        if (Con.State == ConnectionState.Closed)
    //            Con.Open();
    //        adpt.Fill(dt);
    //    }
    //    catch (Exception ex)
    //    {
    //        InsertError(ex.Message, "SP_TAGMESSAGEMASTER_INSRT");
    //    }
    //    finally
    //    {
    //        if (Con.State == ConnectionState.Open)
    //            Con.Close();
    //    }
    //    return dt;
    //}
    public static DataSet getRecords(string SpName)
    {
        DataSet ds = new DataSet();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand(SpName, Con);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            SqlDataAdapter adpt = new SqlDataAdapter(cmd); Con.Open();
            adpt.Fill(ds);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, SpName);
            ds = new DataSet();
        }
        finally
        {
            while (ds.Tables.Count == 0)
            {
                SqlDataAdapter adpt = new SqlDataAdapter(cmd);
                if (Con.State == ConnectionState.Closed)
                    Con.Open();
                adpt.Fill(ds);
            }
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return ds;
    }

    public static DataTable getPatientName(string bedID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_GETPATIENTNAMEBYBEDID", Con);
        cmd.CommandTimeout = 1000;
        cmd.Parameters.AddWithValue("@BEDID", bedID);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_GETPATIENTNAMEBYBEDID");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;

    }
    public static DataSet getReqCount(string Param1, string Value1, string Param2, string Value2, string Param3, string Value3, string Param4, string Value4)
    {
        DataSet dt = new DataSet();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_REQUESTCOUNT", Con);
        cmd.CommandTimeout = 1000;
        cmd.Parameters.AddWithValue(Param1, Value1);
        cmd.Parameters.AddWithValue(Param2, Value2);
        cmd.Parameters.AddWithValue(Param3, Value3);
        cmd.Parameters.AddWithValue(Param4, Value4);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_REQUESTCOUNT");
            dt = new DataSet();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;

    }

    public static DataSet getRequestCount(string SpName, string userID, string RoleId)
    {
        string Id = ((string.IsNullOrEmpty(userID) || userID.ToString().ToUpper() == "NULL") ? "0" : userID),
            RId = ((string.IsNullOrEmpty(RoleId) || RoleId.ToString().ToUpper() == "NULL") ? "0" : RoleId);
        DataSet ds = new DataSet();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand(SpName, Con);
        cmd.Parameters.AddWithValue("@REQUESTORID", Id);
        cmd.Parameters.AddWithValue("@RROLEID", RId);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            SqlDataAdapter adpt = new SqlDataAdapter(cmd); Con.Open();
            adpt.Fill(ds);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, SpName);
            ds = new DataSet();
        }
        finally
        {
            while (ds.Tables.Count == 0)
            {
                SqlDataAdapter adpt = new SqlDataAdapter(cmd);
                if (Con.State == ConnectionState.Closed)
                    Con.Open();
                adpt.Fill(ds);
            }
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return ds;
    }

    public static void InsertError(string ErrMsg, string SpName)
    {
        SqlConnection TmpCon = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_ERRORLOG", TmpCon);
            cmd.Parameters.AddWithValue("@PROC", SpName);
            cmd.Parameters.AddWithValue("@ERRORMSG", ErrMsg);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (TmpCon.State == ConnectionState.Closed)
                TmpCon.Open();
            cmd.ExecuteNonQuery();
            TmpCon.Close();
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_ERRORLOG");
        }
        finally
        {
            if (TmpCon.State == ConnectionState.Open)
                TmpCon.Close();
        }
    }

    public static DataTable RequestMaster(string ReqDate, string ReqID, string Source, string Halt1, string Halt2, string Dest, string UserId, string CatId, string Remarks, string Status,
                      string STime, string ETime, string Assignto, string From, string To, string Priority, string Process, string Search, string MultiPorter, string PageIndex, string PageSize)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_REQUESTMASTER", Con);
            cmd.Parameters.AddWithValue("@REQUESTDATE", ReqDate);
            cmd.Parameters.AddWithValue("@REQID", ReqID);
            cmd.Parameters.AddWithValue("@REQLOCID", Source);
            cmd.Parameters.AddWithValue("@DESTLOCID", Dest);
            cmd.Parameters.AddWithValue("@HALT1", Halt1);
            cmd.Parameters.AddWithValue("@HALT2", Halt2);
            cmd.Parameters.AddWithValue("@REQUESTORID", UserId);
            cmd.Parameters.AddWithValue("@CATEGORYID", CatId);
            cmd.Parameters.AddWithValue("@REMARKS", Remarks);
            cmd.Parameters.AddWithValue("@STATUS", Status);
            cmd.Parameters.AddWithValue("@ASSIGNTIME", STime);
            cmd.Parameters.AddWithValue("@ENDTIME", ETime);
            cmd.Parameters.AddWithValue("@ASSIGNTO", Assignto);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@FROM", From);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@SEARCH", Search);
            cmd.Parameters.AddWithValue("@MULTIPORTER", MultiPorter);
            cmd.Parameters.AddWithValue("@PRIORITY", Priority);
            cmd.Parameters.AddWithValue("@PAGEINDEX", PageIndex);
            cmd.Parameters.AddWithValue("@PAGESIZE", PageSize);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_REQUESTMASTER");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataSet PerformLogs(string ProcedureName, string search, string reqID, string status, string from, string to, string pageIndex, string pageSize)
    {
        DataSet ds = new DataSet();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand(ProcedureName, con);
                cmd.Parameters.AddWithValue("@STATUS", status);
                cmd.Parameters.AddWithValue("@REQUESTID", reqID);
                cmd.Parameters.AddWithValue("@SEARCH", search);
                cmd.Parameters.AddWithValue("@FROM", from);
                cmd.Parameters.AddWithValue("@TO", to);
                cmd.Parameters.AddWithValue("@PAGEINDEX", pageIndex);
                cmd.Parameters.AddWithValue("@PAGESIZE", pageSize);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                return ds;
            }
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, ProcedureName);
            ds = new DataSet();
        }
        return ds;
    }

    public static DataTable PerformLogs_Export(string ProcedureName, string search, string reqID, string status, string from, string to)
    {
        DataTable ds = new DataTable();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand(ProcedureName, con);
                cmd.Parameters.AddWithValue("@STATUS", status);
                cmd.Parameters.AddWithValue("@REQUESTID", reqID);
                cmd.Parameters.AddWithValue("@SEARCH", search);
                cmd.Parameters.AddWithValue("@FROM", from);
                cmd.Parameters.AddWithValue("@TO", to);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
                return ds;
            }
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, ProcedureName);
            ds = new DataTable();
        }
        return ds;
    }


    public static DataTable UpdateLocationsNew(string zonename, string macid, string apname, string floorid, string isactive, string ismultiporter, string action, string nearby, string Id, string Tag,
                                            string IsPorterLocation, string IsCateringLocation, string IsCleaningLocation, string IsSecurityLocaiton, string IsFeedbackLocation, string CATERGROUPID, string CleaningZoneID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_LOCATIONINSERTUPDATE", Con);
            cmd.Parameters.AddWithValue("@ZONENAME", zonename);
            cmd.Parameters.AddWithValue("@MACID", macid);
            cmd.Parameters.AddWithValue("@APNAME", apname);
            cmd.Parameters.AddWithValue("@FLOORID", floorid);
            cmd.Parameters.AddWithValue("@ISMULTIPORTER", ismultiporter);
            cmd.Parameters.AddWithValue("@ISACTIVE", isactive);
            cmd.Parameters.AddWithValue("@NEARBY", nearby);
            cmd.Parameters.AddWithValue("@ACTION", action);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@TAG", Tag);

            cmd.Parameters.AddWithValue("@ISPORTERINGLOCATION", IsPorterLocation);
            cmd.Parameters.AddWithValue("@ISCATERINGLOCATION", IsCateringLocation);
            cmd.Parameters.AddWithValue("@ISCLEANINGLOCATION", IsCleaningLocation);
            cmd.Parameters.AddWithValue("@ISSECURITYLOCATION", IsSecurityLocaiton);
            cmd.Parameters.AddWithValue("@ISFEEDBACKLOCATION", IsFeedbackLocation);
            cmd.Parameters.AddWithValue("@CATERGROUPID", CATERGROUPID);
            cmd.Parameters.AddWithValue("@CLEAINGGROUPID", CleaningZoneID);


            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_LOCATIONINSERTUPDATE");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable UpdateLocations(string zonename, string macid, string apname, string floorid, string isactive, string ismultiporter, string action, string nearby, string Id, string Tag,
                                            string IsPorterLocation, string IsCateringLocation, string IsCleaningLocation, string IsSecurityLocaiton, string IsFeedbackLocation, string CATERGROUPID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_LOCATIONINSERTUPDATE", Con);
            cmd.Parameters.AddWithValue("@ZONENAME", zonename);
            cmd.Parameters.AddWithValue("@MACID", macid);
            cmd.Parameters.AddWithValue("@APNAME", apname);
            cmd.Parameters.AddWithValue("@FLOORID", floorid);
            cmd.Parameters.AddWithValue("@ISMULTIPORTER", ismultiporter);
            cmd.Parameters.AddWithValue("@ISACTIVE", isactive);
            cmd.Parameters.AddWithValue("@NEARBY", nearby);
            cmd.Parameters.AddWithValue("@ACTION", action);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@TAG", Tag);

            cmd.Parameters.AddWithValue("@ISPORTERINGLOCATION", IsPorterLocation);
            cmd.Parameters.AddWithValue("@ISCATERINGLOCATION", IsCateringLocation);
            cmd.Parameters.AddWithValue("@ISCLEANINGLOCATION", IsCleaningLocation);
            cmd.Parameters.AddWithValue("@ISSECURITYLOCATION", IsSecurityLocaiton);
            cmd.Parameters.AddWithValue("@ISFEEDBACKLOCATION", IsFeedbackLocation);
            cmd.Parameters.AddWithValue("@CATERGROUPID", CATERGROUPID);


            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_LOCATIONINSERTUPDATE");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable UpdateUser(string UserName, string MId, string RoleName, string isactive, string Email, string Id, string division, string shift, string device, string shortName)
    {
        DataTable dt = new DataTable();
        using (SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString()))
        {
            try
            {
                using (SqlCommand cmd = new SqlCommand("SP_USRESINSERTUPDATE_EQUANS", Con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@USERNAME", UserName);
                    cmd.Parameters.AddWithValue("@MID", MId);
                    cmd.Parameters.AddWithValue("@ROLENAME", RoleName);
                    cmd.Parameters.AddWithValue("@ISACTIVE", isactive);
                    cmd.Parameters.AddWithValue("@EMAIL", Email);
                    cmd.Parameters.AddWithValue("@ID", Id);
                    cmd.Parameters.AddWithValue("@DIVISION", division);
                    cmd.Parameters.AddWithValue("@SHIFT", string.IsNullOrWhiteSpace(shift) ? "ALL DAY" : shift);
                    cmd.Parameters.AddWithValue("@DEVICE", device);
                    cmd.Parameters.AddWithValue("@SHORT", shortName);

                    SqlDataAdapter adpt = new SqlDataAdapter(cmd);

                    if (Con.State == ConnectionState.Closed)
                        Con.Open();

                    adpt.Fill(dt);
                }
            }
            catch (Exception ex)
            {
                InsertError(ex.Message, "SP_USRESINSERTUPDATE");
            }
            finally
            {
                if (Con.State == ConnectionState.Open)
                    Con.Close();
            }
        }
        return dt;
    }



    public static DataTable UpdateUsers(string UserName, string MId, string RoleId, string isactive, string action, string nearby, string Id)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_USRESINSERTUPDATE", Con);
            cmd.Parameters.AddWithValue("@USERNAME", UserName);
            cmd.Parameters.AddWithValue("@MID", MId);
            cmd.Parameters.AddWithValue("@ROLEID", RoleId);
            cmd.Parameters.AddWithValue("@ISACTIVE", isactive);
            cmd.Parameters.AddWithValue("@NEARBY", nearby);
            cmd.Parameters.AddWithValue("@ACTION", action);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_USRESINSERTUPDATE");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable InsertRoutineRequest(string svcid,string eqid, string PBDate, string Category, string From, string To, string MultiPorter, string PatientName, string Remarks, string UserID, string Priority, string ExtraFields)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_ROUTINETASK_INSERT", Con);
            cmd.Parameters.AddWithValue("@EQUIPMENTID", eqid);
            cmd.Parameters.AddWithValue("@PBDATE", PBDate);
            cmd.Parameters.AddWithValue("@CATEGORY", Category);
            cmd.Parameters.AddWithValue("@FROM", From);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@MULTIPORTER", MultiPorter);
            cmd.Parameters.AddWithValue("@PATIENTNAME", PatientName);
            cmd.Parameters.AddWithValue("@REMARKS", Remarks);
            cmd.Parameters.AddWithValue("@USERID", UserID);
            cmd.Parameters.AddWithValue("@PRIORITY", Priority);
            cmd.Parameters.AddWithValue("@EXTRAFIELDS", ExtraFields);
            cmd.Parameters.AddWithValue("@SERVICEID", svcid);
            
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_ROUTINETASK_INSERT");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }


    public static DataTable InsertRoutineRequestBF(string PBDate, string Category, string From, string To, string MultiPorter, string PatientName, string Remarks, string UserID, string Priority, string ExtraFields, string EndDate, string Kitchen)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_ROUTINETASK_INSERT_BF", Con);
            cmd.Parameters.AddWithValue("@PBDATE", PBDate);
            cmd.Parameters.AddWithValue("@CATEGORY", Category);
            cmd.Parameters.AddWithValue("@FROM", From);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@MULTIPORTER", MultiPorter);
            cmd.Parameters.AddWithValue("@PATIENTNAME", PatientName);
            cmd.Parameters.AddWithValue("@REMARKS", Remarks);
            cmd.Parameters.AddWithValue("@USERID", UserID);
            cmd.Parameters.AddWithValue("@PRIORITY", Priority);
            cmd.Parameters.AddWithValue("@ENDDATE", EndDate);
            cmd.Parameters.AddWithValue("@EXTRAFIELDS", ExtraFields);
            cmd.Parameters.AddWithValue("@KITCHEN", Kitchen);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_ROUTINETASK_INSERT_BF");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable updateRoutineRequest(string svcid,string eqid,string PBDate, string Category, string From, string To, string MultiPorter, string PatientName, string Remarks, string UserID, string Priority, string ExtraFields)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_ROUTINETASK_UPDATE", Con);
            cmd.Parameters.AddWithValue("@EQUIPMENTID", eqid);
            cmd.Parameters.AddWithValue("@PBDATE", PBDate);
            cmd.Parameters.AddWithValue("@CATEGORY", Category);
            cmd.Parameters.AddWithValue("@FROM", From);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@MULTIPORTER", MultiPorter);
            cmd.Parameters.AddWithValue("@PATIENTNAME", PatientName);
            cmd.Parameters.AddWithValue("@REMARKS", Remarks);
            cmd.Parameters.AddWithValue("@USERID", UserID);
            cmd.Parameters.AddWithValue("@PRIORITY", Priority);
            cmd.Parameters.AddWithValue("@EXTRAFIELDS", ExtraFields);
            cmd.Parameters.AddWithValue("@SERVICEID", svcid);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_ROUTINETASK_UPDATE");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable updateRoutineRequestBF(string PBDate, string Category, string From, string To, string MultiPorter, string PatientName, string Remarks, string UserID, string Priority, string EndDate, string ExtraFields, string Kitchen)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_ROUTINETASK_UPDATE_BF", Con);
            cmd.Parameters.AddWithValue("@PBDATE", PBDate);
            cmd.Parameters.AddWithValue("@CATEGORY", Category);
            cmd.Parameters.AddWithValue("@FROM", From);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@MULTIPORTER", MultiPorter);
            cmd.Parameters.AddWithValue("@PATIENTNAME", PatientName);
            cmd.Parameters.AddWithValue("@REMARKS", Remarks);
            cmd.Parameters.AddWithValue("@ENDDATE", EndDate);
            cmd.Parameters.AddWithValue("@USERID", UserID);
            cmd.Parameters.AddWithValue("@PRIORITY", Priority);
            cmd.Parameters.AddWithValue("@EXTRAFIELDS", ExtraFields);
            cmd.Parameters.AddWithValue("@KITCHEN", Kitchen);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_ROUTINETASK_UPDATE_BF");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable InsertRequest(string PBDate, string Category, string From, string To, string MultiPorter, string PatientName, string Remarks, string UserID, string Priority, string Halt1, string Halt2,
                                          string ExtraFields, string qty, string Requestor, string ServiceID, string Kitchen)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_NEWREQUEST_WEB", Con);
            cmd.Parameters.AddWithValue("@PBDATE", PBDate);
            cmd.Parameters.AddWithValue("@CATEGORY", Category);
            cmd.Parameters.AddWithValue("@FROM", From);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@MULTIPORTER", MultiPorter);
            cmd.Parameters.AddWithValue("@PATIENTNAME", PatientName);
            cmd.Parameters.AddWithValue("@REMARKS", Remarks);
            cmd.Parameters.AddWithValue("@USERID", UserID);
            cmd.Parameters.AddWithValue("@PRIORITY", Priority);
            cmd.Parameters.AddWithValue("@HALT1", Halt1);
            cmd.Parameters.AddWithValue("@HALT2", Halt2);
            cmd.Parameters.AddWithValue("@EXTRAFIELDS", ExtraFields);
            cmd.Parameters.AddWithValue("@Qty", qty);
            cmd.Parameters.AddWithValue("@REQUESTOR", Requestor);
            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
            cmd.Parameters.AddWithValue("@KITCHEN", Kitchen);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_NEWREQUEST_WEB");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable DuplicateRequest(string User, string ReqID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_RAISEDUPLICATE_REQUEST", Con);
            cmd.Parameters.AddWithValue("@REQID", ReqID);
            cmd.Parameters.AddWithValue("@USERID", User);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_RAISEDUPLICATE_REQUEST");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable setRoleValues(string RoleID, string TreeID, string Value, string IsActive)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_UPDATEROLEVALUES", Con);
            cmd.Parameters.AddWithValue("@ROLEID", RoleID);
            cmd.Parameters.AddWithValue("@TREEID", TreeID);
            cmd.Parameters.AddWithValue("@VALUE", Value);
            cmd.Parameters.AddWithValue("@ISACTIVE", IsActive);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_UPDATEROLEVALUES");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable UpdateRoleValues(string RoleName, string TreeID, string Action, string Isactive, string ID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_CRAETEROLES_WEBUSERS", Con);
            cmd.Parameters.AddWithValue("@ROLENAME", RoleName);
            cmd.Parameters.AddWithValue("@TREEIDS", TreeID);
            cmd.Parameters.AddWithValue("@ID", ID);
            cmd.Parameters.AddWithValue("@ACTION", Action);
            cmd.Parameters.AddWithValue("@ISACTIVE", Isactive);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_CRAETEROLES_WEBUSERS");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable UpdateRequestPreBook(string PBDate, string Category, string From, string To, string MultiPorter, string PatientName, string Remarks, string UserID, string Priority, string ExtraFields, string RequestID, string StatusID, string CompletedRemarks, string CancelledRemarks,
          string Quantity, string Requestor, string ServiceID, string Kitchen)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_NEWREQUEST_WEB_UPDATE_PREBOOK", Con);
            cmd.Parameters.AddWithValue("@PBDATE", PBDate);
            cmd.Parameters.AddWithValue("@CATEGORY", Category);
            cmd.Parameters.AddWithValue("@FROM", From);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@MULTIPORTER", MultiPorter);
            cmd.Parameters.AddWithValue("@PATIENTNAME", PatientName);
            cmd.Parameters.AddWithValue("@REMARKS", Remarks);
            cmd.Parameters.AddWithValue("@USERID", UserID);
            cmd.Parameters.AddWithValue("@PRIORITY", Priority);
            cmd.Parameters.AddWithValue("@EXTRAFIELDS", ExtraFields);
            cmd.Parameters.AddWithValue("@REQUESTID", RequestID);
            cmd.Parameters.AddWithValue("@STATUS", StatusID);
            cmd.Parameters.AddWithValue("@COMPLETEDREMARKS", CompletedRemarks);
            cmd.Parameters.AddWithValue("@CANCELLEDREMARKS", CancelledRemarks);
            cmd.Parameters.AddWithValue("@Qty", Quantity);
            cmd.Parameters.AddWithValue("@REQUESTOR", Requestor);
            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
            cmd.Parameters.AddWithValue("@KITCHEN", Kitchen);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_NEWREQUEST_WEB_UPDATE_PREBOOK");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable UpdateRequest(string PBDate, string Category, string From, string To, string MultiPorter, string PatientName, string Remarks, string UserID, string Priority, string ExtraFields, string RequestID, string StatusID, string CompletedRemarks, string CancelledRemarks,
          string Quantity, string Requestor, string ServiceID, string Kitchen)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_NEWREQUEST_WEB_UPDATE", Con);
            cmd.Parameters.AddWithValue("@PBDATE", PBDate);
            cmd.Parameters.AddWithValue("@CATEGORY", Category);
            cmd.Parameters.AddWithValue("@FROM", From);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@MULTIPORTER", MultiPorter);
            cmd.Parameters.AddWithValue("@PATIENTNAME", PatientName);
            cmd.Parameters.AddWithValue("@REMARKS", Remarks);
            cmd.Parameters.AddWithValue("@USERID", UserID);
            cmd.Parameters.AddWithValue("@PRIORITY", Priority);
            cmd.Parameters.AddWithValue("@EXTRAFIELDS", ExtraFields);
            cmd.Parameters.AddWithValue("@REQUESTID", RequestID);
            cmd.Parameters.AddWithValue("@STATUS", StatusID);
            cmd.Parameters.AddWithValue("@COMPLETEDREMARKS", CompletedRemarks);
            cmd.Parameters.AddWithValue("@CANCELLEDREMARKS", CancelledRemarks);
            cmd.Parameters.AddWithValue("@Qty", Quantity);
            cmd.Parameters.AddWithValue("@REQUESTOR", Requestor);
            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
            cmd.Parameters.AddWithValue("@KITCHEN", Kitchen);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_NEWREQUEST_WEB_UPDATE");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }


    public static DataTable GetRequests(string UserId, string RoleId, string Status, string PageIndex, string PageSize, string Search, string ServiceID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_GETUSERREQUESTS", Con);
            cmd.Parameters.AddWithValue("@USERID", UserId);
            cmd.Parameters.AddWithValue("@ROLEID", RoleId);
            cmd.Parameters.AddWithValue("@STATUS", Status);
            cmd.Parameters.AddWithValue("@SEARCH", Search);
            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
            cmd.Parameters.AddWithValue("@PAGEINDEX", PageIndex);
            cmd.Parameters.AddWithValue("@PAGESIZE", PageSize);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_GETUSERREQUESTS");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable GetPorterStatus(string Status, string ServiceID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_GETPORTERSTATUS", Con);
            cmd.Parameters.AddWithValue("@STATUS", Status);
            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_GETPORTERSTATUS");
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable PreBookingMaster(string UserId, string RoleId, string Process, string PageIndex, string PageSize, string RequestId, string Remarks)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_PREBOOKINGMASTER", Con);
            cmd.Parameters.AddWithValue("@USERID", UserId);
            cmd.Parameters.AddWithValue("@ROLEID", RoleId);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@PAGEINDEX", PageIndex);
            cmd.Parameters.AddWithValue("@PAGESIZE", PageSize);
            cmd.Parameters.AddWithValue("@REQUESTID", RequestId);
            cmd.Parameters.AddWithValue("@REMARKS", Remarks);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_PREBOOKINGMASTER");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static bool SendMessage(string TagId, string Message)
    {

        string ErrMsg = string.Empty;
        try
        {
            string server = ConfigurationManager.AppSettings["EPEserver"].ToString(), port = ConfigurationManager.AppSettings["EPEPort"].ToString(),
                EPEId = ConfigurationManager.AppSettings["EPEName"].ToString(), EPEPwd = ConfigurationManager.AppSettings["EPEValue"].ToString(),
                URL = ConfigurationManager.AppSettings["HTTP"].ToString() + "://" + server + ":" + port + "/epe/msg/tagsendmsg?tagid=" + TagId + "&message=" + Message + "&messagetype=instant";
            DigestHttpWebRequest req = new DigestHttpWebRequest("admin", "admin");
            HttpWebResponse webResponse = req.GetResponse(new Uri(string.Format(URL)));
            Stream stream = webResponse.GetResponseStream();

            //this.streamReader = new StreamReader(this.streamResponse);
            //this.xmlTxtReader = new XmlTextReader(this.streamReader);
        }
        catch (Exception Excep)
        {
            ErrMsg = Excep.Message;
        }
        return (ErrMsg.Trim() == string.Empty);
    }

    public static string GetBody(DataTable Table)
    {
        string body = string.Empty, BodyHeader = string.Empty;
        body = "</html> <head></head><body><br/><table cellpadding='6' style='border:none;width:90%;display:table;border: none;color: Black !important;font-weight:bold;font-size: 12px;'> <tr>";
        body += "<td align='left'>The porter request - #" + Table.Rows[0]["REQUEST"].ToString() + " for moving the (PATIENT/DOC) from ' " + Table.Rows[0]["SOURCE"].ToString().ToUpper() + " '  to  ' " + Table.Rows[0]["DESTINATION"].ToString().ToUpper() + " ' raised by " + Table.Rows[0]["REQUESTOR"].ToString().ToUpper() + " on " + Table.Rows[0]["DATE"].ToString().ToUpper() + " at " + Table.Rows[0]["TIME"].ToString().ToUpper() + " was assigned to " + Table.Rows[0]["PORTER"].ToString().ToUpper() + ", but was delayed due to the following reason:</td></tr><tr><td align='left'> REASON : " + Table.Rows[0]["REASON"].ToString().ToUpper() + "</td></tr>";

        return body;

    }

    public static bool SendMail(string To, string Sub, string mBody, string From, string Password)
    {
        try
        {

            SmtpClient smtp = new SmtpClient();
            MailMessage msg = new MailMessage();
            char[] separator = new char[] { ';' };
            msg.From = new MailAddress(From);
            string[] strSplitArr = To.Split(separator);
            msg.To.Add(new System.Net.Mail.MailAddress(To)); msg.CC.Add(new System.Net.Mail.MailAddress("thomas@icegen.net")); msg.CC.Add(new System.Net.Mail.MailAddress("senthil@icegen.net"));
            msg.Subject = Sub;
            msg.IsBodyHtml = true;
            msg.Body = mBody;
            smtp.Port = 587;
            smtp.Host = "smtp.gmail.com";

            try
            {
                NetworkCredential cred = new NetworkCredential(From, Password);
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = cred;
                smtp.EnableSsl = true;
                smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
            }
            catch (Exception ex2) { InsertError(ex2.Message, "MAIL"); }
            smtp.Send(msg);
            return true;
        }
        catch (Exception ex1)
        {
            InsertError(ex1.Message, "MAIL");
            return false;
        }
    }

    public static DataTable CategoryMaster(string Id, string Category, string Image, bool Active, string Process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_CATEGORYMASTER", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@CATEGORY", Category);
            cmd.Parameters.AddWithValue("@IMAGE", Image);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@ACTIVE", Active);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_CATEGORYMASTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable LocationMaster(string Id, string Location, string Floor, bool Active, string Process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_LOCATIONMASTER", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@LOCATION", Location);
            cmd.Parameters.AddWithValue("@FLOOR", Floor);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@ACTIVE", Active);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_LOCATIONMASTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable NLocationMaster(string Id, string Location, string Floor, bool Active, string Lgroup, string Process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_LOCATIONMASTER", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@LOCATION", Location);
            cmd.Parameters.AddWithValue("@FLOOR", Floor);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@LOCATIONGROUP", Lgroup);
            cmd.Parameters.AddWithValue("@ACTIVE", Active);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_LOCATIONMASTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable StatusMaster(string Id, string Status, bool Active, string Process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_STATUSMASTER", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@STATUS", Status);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@ACTIVE", Active);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_STATUSMASTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable StatusMasterNew(string Id, string Status, bool Active, string Process, string ServiceID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_STATUSMASTER", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@STATUS", Status);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
            cmd.Parameters.AddWithValue("@ACTIVE", Active);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_STATUSMASTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable UpdatePorter(string Id, string PorterName, string UserID, string Password, string Heavy, string IsActive, string IsPharmacy, string IsBP, string IsMGas, string IsWaste, string IsSupervisor,
                                         string IsHaywood, string IsRoyalStoke, string IsSpeciman, string LightTask, string DeseasedPatient, string KPS, string KP, string KPMK, string KPR, string KPSA, string ServiceID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_UPDATEPORTER", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@PORTERNAME", PorterName);
            cmd.Parameters.AddWithValue("@USERID", UserID);
            cmd.Parameters.AddWithValue("@PASSWORD", Password);
            cmd.Parameters.AddWithValue("@HEAVY", Heavy);
            cmd.Parameters.AddWithValue("@ISACTIVE", IsActive);


            cmd.Parameters.AddWithValue("@ISPHARMACY", IsPharmacy);
            cmd.Parameters.AddWithValue("@ISBLOODPRODUCT", IsBP);
            cmd.Parameters.AddWithValue("@ISMEDICALGASES", IsMGas);
            cmd.Parameters.AddWithValue("@ISWASTE", IsWaste);
            cmd.Parameters.AddWithValue("@ISSUPERVISOR", IsSupervisor);
            cmd.Parameters.AddWithValue("@ISHAYWOOD", IsHaywood);
            cmd.Parameters.AddWithValue("@ISROYALSTOKE", IsRoyalStoke);



            cmd.Parameters.AddWithValue("@ISLIGHTTASK", LightTask);
            cmd.Parameters.AddWithValue("@ISSPECIMEN", IsSpeciman);
            cmd.Parameters.AddWithValue("@ISDESEASEDPATIENT", DeseasedPatient);


            cmd.Parameters.AddWithValue("@KP_SUPERVISOR", KPS);
            cmd.Parameters.AddWithValue("@KP", KP);
            cmd.Parameters.AddWithValue("@KP_MAINKITCHEN", KPMK);
            cmd.Parameters.AddWithValue("@KP_RETAIL", KPR);
            cmd.Parameters.AddWithValue("@KP_SAFFRONADMIN", KPSA);


            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);


            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_UPDATEPORTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable UpdateCategoryNew(string AECategoryName, string AEResponsetime, string AEDuration, string AERoutine, string AELock_Category, string AERequester_Required_From_Control_Desk, string AERequester_Required_From_Quick_Entry, string AEEquipment_Type_Requirement, string AEMultiple_Equipment_Types, string AEAssistant_Required, string AEIdentifier_Based, string AEIdentifier_Label, string AESla_Location, string AEVerify_Delivery, string AEVerification_Type, string AEAdditional_Equipment, string AESkills_Required_By_Some_Employees, string AESkills_Required_By_All_Employees, string AESingle_Location, string AELock_Single_Location, string AEMultiple_Start, string AEShould_Group, string AECustom_Fields, string AEMultiple_Assignment, string AEStarttime, string ServiceID, string hosname,string id,string IsActive)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("[SP_UPDATETASKTYPE_EQUANS]", Con);

            cmd.Parameters.AddWithValue("@CATEGORYNAME", AECategoryName);
            cmd.Parameters.AddWithValue("@RESPONSETIME", AEResponsetime);
            cmd.Parameters.AddWithValue("@DURATION", AEDuration);
            cmd.Parameters.AddWithValue("@ROUTINE", AERoutine);
            cmd.Parameters.AddWithValue("@LOCK_CATEGORY", AELock_Category);
            cmd.Parameters.AddWithValue("@REQUESTER_REQUIRED_FROM_CONTROL_DESK", AERequester_Required_From_Control_Desk);
            cmd.Parameters.AddWithValue("@REQUESTER_REQUIRED_FROM_QUICK_ENTRY", AERequester_Required_From_Quick_Entry);
            cmd.Parameters.AddWithValue("@EQUIPMENT_TYPE_REQUIREMENT", AEEquipment_Type_Requirement);
            cmd.Parameters.AddWithValue("@MULTIPLE_EQUIPMENT_TYPES", AEMultiple_Equipment_Types);
            cmd.Parameters.AddWithValue("@ASSISTANT_REQUIRED", AEAssistant_Required);
            cmd.Parameters.AddWithValue("@IDENTIFIER_BASED", AEIdentifier_Based);
            cmd.Parameters.AddWithValue("@IDENTIFIER_LABEL", AEIdentifier_Label);
            cmd.Parameters.AddWithValue("@SLA_LOCATION", AESla_Location);
            cmd.Parameters.AddWithValue("@VERIFY_DELIVERY", AEVerify_Delivery);
            cmd.Parameters.AddWithValue("@VERIFICATION_TYPE", AEVerification_Type);
            cmd.Parameters.AddWithValue("@ADDITIONAL_EQUIPMENT", AEAdditional_Equipment);
            cmd.Parameters.AddWithValue("@SKILLS_REQUIRED_BY_SOME_EMPLOYEES", AESkills_Required_By_Some_Employees);
            cmd.Parameters.AddWithValue("@SKILLS_REQUIRED_BY_ALL_EMPLOYEES", AESkills_Required_By_All_Employees);
            cmd.Parameters.AddWithValue("@SINGLE_LOCATION", AESingle_Location);
            cmd.Parameters.AddWithValue("@LOCK_SINGLE_LOCATION", AELock_Single_Location);
            cmd.Parameters.AddWithValue("@MULTIPLE_START", AEMultiple_Start);
            cmd.Parameters.AddWithValue("@SHOULD_GROUP", AEShould_Group);
            cmd.Parameters.AddWithValue("@CUSTOM_FIELDS", AECustom_Fields);
            cmd.Parameters.AddWithValue("@MULTIPLE_ASSIGNMENT", AEMultiple_Assignment);
            cmd.Parameters.AddWithValue("@STARTTIME", AEStarttime);
            cmd.Parameters.AddWithValue("@ServiceID", ServiceID);
            cmd.Parameters.AddWithValue("@hosname", hosname);
            cmd.Parameters.AddWithValue("@ID", id);
            cmd.Parameters.AddWithValue("@ISACTIVE", IsActive);
           
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_UPDATEPORTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable UpdatePorterNew(string PorterName, string UserID, string MID, string Password,   string IsActive, string gpshort, string gpdevice,  string ServiceID,string hospitalname,string allday)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_UPDATEPORTERS", Con);
            cmd.Parameters.AddWithValue("@ID", UserID);
            cmd.Parameters.AddWithValue("@PORTERNAME", PorterName);
            cmd.Parameters.AddWithValue("@USERID", MID);
            cmd.Parameters.AddWithValue("@PASSWORD", Password); 

            
            cmd.Parameters.AddWithValue("@ISACTIVE", IsActive);
            cmd.Parameters.AddWithValue("@gpshort", gpshort);
            cmd.Parameters.AddWithValue("@gpdevice", gpdevice);
            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
            cmd.Parameters.AddWithValue("@hospitalname", hospitalname);
            cmd.Parameters.AddWithValue("@ALLDAY", allday);



            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_UPDATEPORTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }


    public static DataTable UpdateCategory(string Id, string Category, string TAT, string TStart, string TEnd, string Priority, string Routine, string PorterTask, string Heavy, string IsActive, string TwoPorter, string IsHaywood, string IsRoyalStoke, string IsNoPI,
                                           string IsPharmacy, string IsBP, string IsMGas, string IsWaste, string IsSupervisor, string IsSpeciman, string LightTask, string DeseasedPatient,
                                           string KPMK, string KP, string KPS, string KPR, string KPSA, string ISSIGN, string ISPHOTO, string ServiceID, string CHARGEGROUP)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_UPDATECATEGORY", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@CATEGORY", Category);
            cmd.Parameters.AddWithValue("@TAT", TAT);
            cmd.Parameters.AddWithValue("@TSTART", TStart);
            cmd.Parameters.AddWithValue("@TEND", TEnd);
            cmd.Parameters.AddWithValue("@PRIORITY", Priority);
            cmd.Parameters.AddWithValue("@PORTERTASK", PorterTask);
            cmd.Parameters.AddWithValue("@ROUTINE", Routine);
            cmd.Parameters.AddWithValue("@HEAVY", Heavy);
            cmd.Parameters.AddWithValue("@TWOPORTER", TwoPorter);
            cmd.Parameters.AddWithValue("@ISHAYWOOD", IsHaywood);
            cmd.Parameters.AddWithValue("@ISROYALSTOKE", IsRoyalStoke);
            cmd.Parameters.AddWithValue("@ISNOPL", IsNoPI);


            cmd.Parameters.AddWithValue("@ISPHARMACY", IsPharmacy);
            cmd.Parameters.AddWithValue("@ISBLOODPRODUCT", IsBP);
            cmd.Parameters.AddWithValue("@ISMEDICALGASES", IsMGas);
            cmd.Parameters.AddWithValue("@ISWASTE", IsWaste);
            cmd.Parameters.AddWithValue("@ISSUPERVISOR", IsSupervisor);


            cmd.Parameters.AddWithValue("@KP_SUPERVISOR", KPS);
            cmd.Parameters.AddWithValue("@KP", KP);
            cmd.Parameters.AddWithValue("@KP_MAINKITCHEN", KPMK);
            cmd.Parameters.AddWithValue("@KP_RETAIL", KPR);
            cmd.Parameters.AddWithValue("@KP_SAFFRONADMIN", KPSA);

            cmd.Parameters.AddWithValue("@CHARGEGROUP", CHARGEGROUP);

            cmd.Parameters.AddWithValue("@KP_ISSIGN", ISSIGN);
            cmd.Parameters.AddWithValue("@KP_ISPHOTO", ISPHOTO);

            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);

            cmd.Parameters.AddWithValue("@ISLIGHTTASK", LightTask);
            cmd.Parameters.AddWithValue("@ISSPECIMEN", IsSpeciman);
            cmd.Parameters.AddWithValue("@ISDESEASEDPATIENT", DeseasedPatient);

            cmd.Parameters.AddWithValue("@ISACTIVE", IsActive);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_UPDATECATEGORY"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable UpdateCategoryNew(string Id, string Category, string TAT, string TStart, string TEnd, string Priority, string Routine, string PorterTask, string Heavy, string IsActive, string TwoPorter, string IsHaywood, string IsRoyalStoke, string IsNoPI,
                                           string IsPharmacy, string IsBP, string IsMGas, string IsWaste, string IsSupervisor, string IsSpeciman, string LightTask, string DeseasedPatient,
                                           string KPMK, string KP, string KPS, string KPR, string KPSA, string ISSIGN, string ISPHOTO, string ServiceID, string CHARGEGROUP, string CLS, string CLRR)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_UPDATECATEGORY", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@CATEGORY", Category);
            cmd.Parameters.AddWithValue("@TAT", TAT);
            cmd.Parameters.AddWithValue("@TSTART", TStart);
            cmd.Parameters.AddWithValue("@TEND", TEnd);
            cmd.Parameters.AddWithValue("@PRIORITY", Priority);
            cmd.Parameters.AddWithValue("@PORTERTASK", PorterTask);
            cmd.Parameters.AddWithValue("@ROUTINE", Routine);
            cmd.Parameters.AddWithValue("@HEAVY", Heavy);
            cmd.Parameters.AddWithValue("@TWOPORTER", TwoPorter);
            cmd.Parameters.AddWithValue("@ISHAYWOOD", IsHaywood);
            cmd.Parameters.AddWithValue("@ISROYALSTOKE", IsRoyalStoke);
            cmd.Parameters.AddWithValue("@ISNOPL", IsNoPI);


            cmd.Parameters.AddWithValue("@ISPHARMACY", IsPharmacy);
            cmd.Parameters.AddWithValue("@ISBLOODPRODUCT", IsBP);
            cmd.Parameters.AddWithValue("@ISMEDICALGASES", IsMGas);
            cmd.Parameters.AddWithValue("@ISWASTE", IsWaste);
            cmd.Parameters.AddWithValue("@ISSUPERVISOR", IsSupervisor);


            cmd.Parameters.AddWithValue("@KP_SUPERVISOR", KPS);
            cmd.Parameters.AddWithValue("@KP", KP);
            cmd.Parameters.AddWithValue("@KP_MAINKITCHEN", KPMK);
            cmd.Parameters.AddWithValue("@KP_RETAIL", KPR);
            cmd.Parameters.AddWithValue("@KP_SAFFRONADMIN", KPSA);

            cmd.Parameters.AddWithValue("@CHARGEGROUP", CHARGEGROUP);

            cmd.Parameters.AddWithValue("@KP_ISSIGN", ISSIGN);
            cmd.Parameters.AddWithValue("@KP_ISPHOTO", ISPHOTO);


            cmd.Parameters.AddWithValue("@CLS", CLS);
            cmd.Parameters.AddWithValue("@CLRR", CLRR);

            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);

            cmd.Parameters.AddWithValue("@ISLIGHTTASK", LightTask);
            cmd.Parameters.AddWithValue("@ISSPECIMEN", IsSpeciman);
            cmd.Parameters.AddWithValue("@ISDESEASEDPATIENT", DeseasedPatient);

            cmd.Parameters.AddWithValue("@ISACTIVE", IsActive);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_UPDATECATEGORY"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable RoleMaster(string Id, string Role, bool Active, string Process, string TreeId)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_ROLEMASTER", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@ROLE", Role);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@TREEID", TreeId);
            cmd.Parameters.AddWithValue("@ACTIVE", Active);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_ROLEMASTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable FloorMaster(string Id, string Floor, bool Active, string Process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_FLOORMASTER", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@FLOOR", Floor);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@ACTIVE", Active);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_FLOORMASTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable FloorMasterUpdate(string Id, string Floor, string FloorOrder, bool Active, string Process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_FLOORMASTER", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@FLOOR", Floor);
            cmd.Parameters.AddWithValue("@FLOORORDER", FloorOrder);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@ACTIVE", Active);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_FLOORMASTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable UserMaster(string Id, string user, string EId, string Password, string Role, bool Active, string Process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_USERMASTER", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@USERNAME", user);
            cmd.Parameters.AddWithValue("@PASSWORD", Password);
            cmd.Parameters.AddWithValue("@EMPID", EId);
            cmd.Parameters.AddWithValue("@ROLE", Role);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@ACTIVE", Active);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_USERMASTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable MailMaster(string frommail, string tomail, string ccmail, string TATTo, string TATCC, string Dailytomail, string Dailyccmail, string server, string Port, string Process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_MAILMASTER", Con);
            cmd.Parameters.AddWithValue("@MAILFROM", frommail);
            cmd.Parameters.AddWithValue("@MAILTO", tomail);
            cmd.Parameters.AddWithValue("@MAILTOCC", ccmail);
            cmd.Parameters.AddWithValue("@TATMAILTO", TATTo);
            cmd.Parameters.AddWithValue("@TATMAILCC", TATCC);
            cmd.Parameters.AddWithValue("@DAILYMAILTO", Dailytomail);
            cmd.Parameters.AddWithValue("@DAILYMAILTOCC", Dailyccmail);
            cmd.Parameters.AddWithValue("@SERVER", server);
            cmd.Parameters.AddWithValue("@PORT", Port);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_MAILMASTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    //public static DataTable PorterMaster(byte[] Image, string Id, string Name, string EmpId, string Shift, bool Active, string Process)
    //{
    //    DataTable dt = new DataTable();
    //    SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
    //    try
    //    {
    //        SqlCommand cmd = new SqlCommand("SP_PORTERMASTER", Con);
    //        cmd.Parameters.AddWithValue("@ID", Id);
    //        cmd.Parameters.AddWithValue("@NAME", Name);
    //        cmd.Parameters.AddWithValue("@EMPLOYEEID", EmpId);
    //        cmd.Parameters.AddWithValue("@SHIFT", Shift);
    //        cmd.Parameters.AddWithValue("@PROCESS", Process);
    //        cmd.Parameters.AddWithValue("@ACTIVE", Active);
    //        if (Image != null)
    //            cmd.Parameters.AddWithValue("@PHOTO", Image);
    //        cmd.CommandType = CommandType.StoredProcedure;
    //        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
    //        Con.Open();
    //        adpt.Fill(dt);
    //    }
    //    catch (Exception ex) { InsertError(ex.Message, "SP_PORTERMASTER"); }
    //    finally
    //    {
    //        if (Con.State == ConnectionState.Open)
    //            Con.Close();
    //    }
    //    return dt;
    //}
    public static DataTable PorterMaster(byte[] Image, string Id, string Name, string EmpId, string Shift, bool Active, string Process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_PORTERMASTER", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@NAME", Name);
            cmd.Parameters.AddWithValue("@EMPLOYEEID", EmpId);
            cmd.Parameters.AddWithValue("@SHIFT", Shift);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@ACTIVE", Active);
            if (Image != null)
                cmd.Parameters.AddWithValue("@PHOTO", Image);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_PORTERMASTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable PorterMasterGL(byte[] Image, string Id, string Name, string EmpId, string Shift, bool Active, string Process, string ServiceID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_PORTERMASTER", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@NAME", Name);
            cmd.Parameters.AddWithValue("@EMPLOYEEID", EmpId);
            cmd.Parameters.AddWithValue("@SHIFT", Shift);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
            cmd.Parameters.AddWithValue("@ACTIVE", Active);
            if (Image != null)
                cmd.Parameters.AddWithValue("@PHOTO", Image);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_PORTERMASTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }


    public static DataTable ShiftMaster(string Id, string Name, string Stime, string ETime, bool Active, string Process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_SHIFTMASTER", Con);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.Parameters.AddWithValue("@NAME", Name);
            cmd.Parameters.AddWithValue("@STARTTIME", Stime);
            cmd.Parameters.AddWithValue("@ENDTIME", ETime);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@ACTIVE", Active);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_SHIFTMASTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable ReportMaster(string Process, string From, string To, string PorterId, string Search, string Pagesize, string PageIndex, string ServiceId, string HospitalLoc)
    {
        DataTable ds = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_GETREPORT", Con);
            cmd.CommandTimeout = 1000;
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@FROM", From);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@PORTERID", PorterId);
            cmd.Parameters.AddWithValue("@SEARCH", Search);
            cmd.Parameters.AddWithValue("@PAGEINDEX", PageIndex);
            cmd.Parameters.AddWithValue("@PAGESIZE", Pagesize);
            cmd.Parameters.AddWithValue("@SERVICEID", ServiceId);
            cmd.Parameters.AddWithValue("@HOSPITALLOC", HospitalLoc);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(ds);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_GETREPORT"); ds = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return ds;
    }
    public static DataTable ReportMaster(string Process, string From, string To, string PorterId, string Search, string Pagesize, string PageIndex)
    {
        DataTable ds = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_GETREPORT", Con);
            cmd.CommandTimeout = 1000;
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@FROM", From);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@PORTERID", PorterId);
            cmd.Parameters.AddWithValue("@SEARCH", Search);
            cmd.Parameters.AddWithValue("@PAGEINDEX", PageIndex);
            cmd.Parameters.AddWithValue("@PAGESIZE", Pagesize);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(ds);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_GETREPORT"); ds = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return ds;
    }
    public static DataTable DateWiseExport(string Status, string From, string To, string Search, string ServiceID)
    {
        DataSet ds = new DataSet();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_GETREQUESTS_EXPORT", Con);
            cmd.CommandTimeout = 1000;
            cmd.Parameters.AddWithValue("@STATUS", Status);
            cmd.Parameters.AddWithValue("@FROM", From);
            cmd.Parameters.AddWithValue("@TO", To);

            cmd.Parameters.AddWithValue("@SEARCH", Search);

            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(ds, Status);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_GETREQUESTS_EXPORT"); ds = new DataSet(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return ds.Tables[0];
    }

    public static DataTable ExportTrac(string Status, string From, string To, string Search, string ServiceID)
    {
        DataSet ds = new DataSet();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_ExportTrac_EXPORT", Con);
            cmd.CommandTimeout = 1000;
            cmd.Parameters.AddWithValue("@STATUS", Status);
            cmd.Parameters.AddWithValue("@FROM", From);
            cmd.Parameters.AddWithValue("@TO", To);

            cmd.Parameters.AddWithValue("@SEARCH", Search);

            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(ds, Status);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_ExportTrac_EXPORT"); ds = new DataSet(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return ds.Tables[0];
    }

    public static DataTable PorterTrackr(string Status, string From, string To, string Search, string Pagesize, string PageIndex, string ServiceID)
    {
        DataSet ds = new DataSet();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_GETPORTERTRAC_REPORT", Con);
            cmd.CommandTimeout = 1000;
            cmd.Parameters.AddWithValue("@STATUS", Status);
            cmd.Parameters.AddWithValue("@FROM", From);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@SEARCH", Search);
            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
            cmd.Parameters.AddWithValue("@PAGEINDEX", PageIndex);
            cmd.Parameters.AddWithValue("@PAGESIZE", Pagesize);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(ds);
        }
        catch (SqlException ex) { InsertError(ex.Message, "SP_GETREQUESTS_REPORT"); ds = new DataSet(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return ds.Tables[0];
    }

    public static DataTable DateWise(string Status, string From, string To, string Search, string Pagesize, string PageIndex, string ServiceID)
    {
        DataSet ds = new DataSet();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_GETREQUESTS_REPORT", Con);
            cmd.CommandTimeout = 1000;
            cmd.Parameters.AddWithValue("@STATUS", Status);
            cmd.Parameters.AddWithValue("@FROM", From);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@SEARCH", Search);
            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
            cmd.Parameters.AddWithValue("@PAGEINDEX", PageIndex);
            cmd.Parameters.AddWithValue("@PAGESIZE", Pagesize);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(ds);
        }
        catch (SqlException ex) { InsertError(ex.Message, "SP_GETREQUESTS_REPORT"); ds = new DataSet(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return ds.Tables[0];
    }
    public static string CheckUser(string User, string Password)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_CHECKUSER_WEB", Con);
            cmd.Parameters.AddWithValue("@USERNAME", User);
            cmd.Parameters.AddWithValue("@PASSWORD", Password);
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            cmd.CommandType = CommandType.StoredProcedure;
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_CHECKUSER_WEB"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt.Rows[0]["RESULT"].ToString();
    }
    public static string CheckHISUser(string User, string Password, string MID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_HISGETUSER", Con);
            cmd.Parameters.AddWithValue("@USERNAME", User);
            cmd.Parameters.AddWithValue("@PASSWORD", Password);
            cmd.Parameters.AddWithValue("@EMPID", MID);
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            cmd.CommandType = CommandType.StoredProcedure;
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_HISGETUSER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt.Rows[0]["RESULT"].ToString().ToUpper();
    }
    public static DataTable TagMaster(string Process, string TagId, string MacId, bool Active)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_TAGMASTER", Con);
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            cmd.Parameters.AddWithValue("@MACID", MacId);
            cmd.Parameters.AddWithValue("@ID", TagId);
            cmd.Parameters.AddWithValue("@ACTIVE", Active);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_TAGMASTER"); dt = new DataTable(); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static XmlDocument xmlPopulate(string SQLStr)
    {
        XmlDocument tempDoc = new XmlDocument();
        try
        {
            SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
            XmlReader xmlreader;
            SqlCommand dbCommand = new SqlCommand(SQLStr, Con);
            dbCommand.CommandType = CommandType.Text;
            Con.Open();
            xmlreader = dbCommand.ExecuteXmlReader();
            tempDoc.Load(xmlreader);

            dbCommand.Dispose();
            Con.Close();
            Con.Dispose();
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "XMLPOPULATE"); tempDoc = new XmlDocument();
        }
        return tempDoc;
    }

    public static DataTable ReportExport(string Process, string From, string To)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_GETREPORTEXPORT", Con);
        cmd.CommandTimeout = 1000;
        cmd.Parameters.AddWithValue("@PROCESS", Process);
        cmd.Parameters.AddWithValue("@FROM", From);
        cmd.Parameters.AddWithValue("@TO", To);
        cmd.CommandType = CommandType.StoredProcedure;
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            if (Con.State != ConnectionState.Closed)
                Con.Close();
            try
            {
                Con.Open();
                adpt.Fill(dt);
            }
            catch (Exception ex1)
            {
                InsertError(ex1.Message, "SP_GETREPORT");
                dt = new DataTable();
            }
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable GetAssignRecords(string Proc, string Param)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand(Proc, Con);
        if (!string.IsNullOrEmpty(Param))
            cmd.Parameters.AddWithValue("@REQID", Param);
        cmd.CommandType = CommandType.StoredProcedure;
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_GETASSIGNRECORDS");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable AssignTask(string Proc, string RequestID, string PorterId)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand(Proc, Con);
        cmd.Parameters.AddWithValue("@REQID", RequestID);
        cmd.Parameters.AddWithValue("@ASSIGNTO", PorterId);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, Proc);
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable updateLocation(string RequestId, string DLocID, string Dloc, string TagID, string User, string RQuery, string Category, string CCategory)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_UPDATELOCATION", Con);
            cmd.Parameters.AddWithValue("@REQID", RequestId);
            cmd.Parameters.AddWithValue("@DESTID", DLocID);
            cmd.Parameters.AddWithValue("@TAGID", TagID);
            cmd.Parameters.AddWithValue("@DLOC", Dloc);
            cmd.Parameters.AddWithValue("@USERID", User);
            cmd.Parameters.AddWithValue("@RQUERY", RQuery);
            cmd.Parameters.AddWithValue("@CATEGORY", Category);
            cmd.Parameters.AddWithValue("@CCATEGORY", CCategory);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_UPDATELOCATION");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable ResumeHoldTask(string RequestID, string UserID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_RELEASEONHOLD", Con);
        cmd.Parameters.AddWithValue("@REQUESTID", RequestID);
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

            InsertError(ex.Message, "SP_RELEASEONHOLD");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable SetHoldTask(string RequestID, string PorterId, string Reason, string UserID, string MIndex)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_SETONHOLD", Con);
        cmd.Parameters.AddWithValue("@REQUESTID", RequestID);
        cmd.Parameters.AddWithValue("@ONHOLDREMARKS", Reason);
        cmd.Parameters.AddWithValue("@USERID", UserID);
        cmd.Parameters.AddWithValue("@PORTERIDS", PorterId);
        cmd.Parameters.AddWithValue("@MIINDEX", MIndex);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_SETONHOLD");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable CancelTaskN(string RequestID, string PorterId, string PreBook, string Reason, string UserID, string MIndex, string Occurrence)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_CANCELREQUEST", Con);
        cmd.Parameters.AddWithValue("@REQUESTID", RequestID);
        cmd.Parameters.AddWithValue("@PREBOOK", PreBook);
        cmd.Parameters.AddWithValue("@REASON", Reason);
        cmd.Parameters.AddWithValue("@PORTERIDS", PorterId);
        cmd.Parameters.AddWithValue("@USERID", UserID);
        cmd.Parameters.AddWithValue("@MIINDEX", MIndex);
        cmd.Parameters.AddWithValue("@OCCURRENCE", Occurrence);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_CANCELREQUEST");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable CancelTask(string RequestID, string PorterId, string PreBook, string Reason, string UserID, string MIndex)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_CANCELREQUEST", Con);
        cmd.Parameters.AddWithValue("@REQUESTID", RequestID);
        cmd.Parameters.AddWithValue("@PREBOOK", PreBook);
        cmd.Parameters.AddWithValue("@REASON", Reason);
        cmd.Parameters.AddWithValue("@PORTERIDS", PorterId);
        cmd.Parameters.AddWithValue("@USERID", UserID);
        cmd.Parameters.AddWithValue("@MIINDEX", MIndex);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_CANCELREQUEST");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable AddCompleteRemarks(string RequestID, string Remarks, string UserID, string IsMitigation)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_COMPLETETASK_REMARKS", Con);
        cmd.Parameters.AddWithValue("@REQUESTID", RequestID);
        cmd.Parameters.AddWithValue("@REMARKS", Remarks);
        cmd.Parameters.AddWithValue("@USERID", UserID);
        cmd.Parameters.AddWithValue("@ISMITIGATION", IsMitigation);

        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_COMPLETETASK_REMARKS");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable AddRequestLog(string RequestID, string Remarks, string UserID, string IsMitigation)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_REQUEST_LOGS", Con);
        cmd.Parameters.AddWithValue("@REQUESTID", RequestID);
        cmd.Parameters.AddWithValue("@REMARKS", Remarks);
        cmd.Parameters.AddWithValue("@USERID", UserID);
        cmd.Parameters.AddWithValue("@ISMITIGATION", IsMitigation);

        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_COMPLETETASK_REMARKS");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable CompleteTask(string RequestID, string PorterId, string TagID, string Reason, string UserID, string MIndex)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_COMPLETECURRENTTASK_START", Con);
        cmd.Parameters.AddWithValue("@REQUESTID", RequestID);
        cmd.Parameters.AddWithValue("@TAGID", TagID);
        cmd.Parameters.AddWithValue("@REASON", Reason);
        cmd.Parameters.AddWithValue("@PORTERIDS", PorterId);
        cmd.Parameters.AddWithValue("@MIINDEX", MIndex);
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

            InsertError(ex.Message, "SP_COMPLETECURRENTTASK_START");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable CompleteTask(string RequestID, string Reason, string UserID, string MIndex)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_COMPLETECURRENTTASK_START", Con);
        cmd.Parameters.AddWithValue("@REQUESTID", RequestID);
        cmd.Parameters.AddWithValue("@REASON", Reason);
        cmd.Parameters.AddWithValue("@USER", UserID);
        cmd.Parameters.AddWithValue("@MIINDEX", MIndex);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_COMPLETECURRENTTASK_START");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static DataTable StartTask(string RequestID, string Reason, string MIndex, string UserID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_STARTCURRENTTASK", Con);
        cmd.Parameters.AddWithValue("@REQUESTID", RequestID);
        cmd.Parameters.AddWithValue("@REASON", Reason);
        cmd.Parameters.AddWithValue("@USER", UserID);
        cmd.Parameters.AddWithValue("@MIINDEX", MIndex);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_STARTCURRENTTASK");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }


    public static DataTable AssignPorter(string RequestID)
    {
        DataTable dt = new DataTable();
        try
        {
            string PorterId = DataAccess.GetPorter(RequestID);
            if (PorterId != "0" && PorterId != "1001")
                dt = DataAccess.AssignTask("SP_ASSIGNPORTER", RequestID, PorterId);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_ASSIGNPORTER");
            dt = new DataTable();
        }
        return dt;
    }
    public static string GetPorter(string RequestID)
    {
        DataTable dt = new DataTable();
        try
        {
            dt = DataAccess.GetAssignRecords("SP_GETPORTERID", RequestID);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_GETPORTERID");
            dt = new DataTable();
        }
        return (dt.Rows.Count > 0) ? (dt.Rows[0]["MULTIPORTER"].ToString() == "YES") ? (dt.Rows.Count > 1) ? dt.Rows[0]["Id"].ToString() + "_" + dt.Rows[1]["Id"].ToString() : "1001" : dt.Rows[0]["Id"].ToString() : "0";
    }

    public static DataTable GetCategorywisePerformance(string From, string To)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_PORTERPERFORMANCECATEGORYWISE", Con);
        cmd.CommandTimeout = 1000;
        cmd.Parameters.AddWithValue("@FROM", From);
        cmd.Parameters.AddWithValue("@TO", To);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_PORTERPERFORMANCECATEGORYWISE");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable PorterDetails(string ReqNo, string User, string Process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_GETPOPUPPORTDETAILS", Con);
        cmd.CommandTimeout = 1000;
        cmd.Parameters.AddWithValue("@REQUESTID", ReqNo);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_GETPOPUPPORTDETAILS");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;

    }

    public static DataTable GetPopDetails(string ReqNo, string User, string Process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_GETPOPUPDETAILS", Con);
        cmd.CommandTimeout = 1000;
        cmd.Parameters.AddWithValue("@REQNO", ReqNo);
        cmd.Parameters.AddWithValue("@USER", User);
        cmd.Parameters.AddWithValue("@PROCESS", Process);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_GETPOPUPDETAILS");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;

    }
    public static DataTable GetDeptPorters(string PorterName, string IsInitiate, string Porter1, string Porter2)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_GETPORTERSBYNAME_ADHOC", Con);
        cmd.CommandTimeout = 1000;
        cmd.Parameters.AddWithValue("@PORTERNAME", PorterName);
        cmd.Parameters.AddWithValue("@ISINITIATE", IsInitiate);
        cmd.Parameters.AddWithValue("@PORTERID1", Porter1);
        cmd.Parameters.AddWithValue("@PORTERID2", Porter2);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "SP_GETPORTERSBYNAME_ADHOC");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;

    }
    public static DataTable ManualAssign(string ReqID, string Porter1, string Porter2)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_MANUALASSIGN", Con);
        cmd.CommandTimeout = 1000;
        cmd.Parameters.AddWithValue("@REQUESTID", ReqID);
        cmd.Parameters.AddWithValue("@PORTERID1", Porter1);
        cmd.Parameters.AddWithValue("@PORTERID2", Porter2);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_MANUALASSIGN");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;

    }



    public static DataSet GetRecord(string ProcedureName, string ParamName, string ParamValue)
    {
        DataSet ds = new DataSet();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand(ProcedureName, con);
                cmd.Parameters.AddWithValue(ParamName, ParamValue);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }

        }
        catch (Exception ex)
        {
            InsertError(ex.Message, ProcedureName);
            ds = new DataSet();
        }
        return ds;
    }


    public static DataTable GetRecords(string ProcedureName, string ParamName, string ParamValue)
    {
        DataTable ds = new DataTable();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

        try
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand(ProcedureName, con);
                cmd.Parameters.AddWithValue(ParamName, ParamValue);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }

        }
        catch (Exception ex)
        {
            InsertError(ex.Message, ProcedureName);
            ds = new DataTable();
        }
        return ds;
    }

    public static DataSet GetRecordss(string ProcedureName, string ParamName, string ParamValue, string ParamName1, string ParamValue1)
    {
        DataSet ds = new DataSet();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand(ProcedureName, con);
                cmd.Parameters.AddWithValue(ParamName, ParamValue);
                cmd.Parameters.AddWithValue(ParamName1, ParamValue1);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }

        }
        catch (Exception ex)
        {
            InsertError(ex.Message, ProcedureName);
            ds = new DataSet();
        }
        return ds;
    }

    public static DataSet GetRecordss(string ProcedureName, string ParamName, string ParamValue, string ParamName1, string ParamValue1, string ParamName2, string ParamValue2)
    {
        DataSet ds = new DataSet();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand(ProcedureName, con);
                cmd.Parameters.AddWithValue(ParamName, ParamValue);
                cmd.Parameters.AddWithValue(ParamName1, ParamValue1);
                cmd.Parameters.AddWithValue(ParamName2, ParamValue2);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }

        }
        catch (Exception ex)
        {
            InsertError(ex.Message, ProcedureName);
            ds = new DataSet();
        }
        return ds;
    }

    public static DataSet GetRecordss(string ProcedureName, string ParamName, string ParamValue, string ParamName1, string ParamValue1, string ParamName2, string ParamValue2, string ParamName3, string ParamValue3)
    {
        DataSet ds = new DataSet();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;

        try
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand(ProcedureName, con);
                cmd.Parameters.AddWithValue(ParamName, ParamValue);
                cmd.Parameters.AddWithValue(ParamName1, ParamValue1);
                cmd.Parameters.AddWithValue(ParamName2, ParamValue2);
                cmd.Parameters.AddWithValue(ParamName3, ParamValue3);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }

        }
        catch (Exception ex)
        {
            InsertError(ex.Message, ProcedureName);
            ds = new DataSet();
        }
        return ds;
    }

    public static DataTable UpdateSchBreak(string porterid, string dur, string starttim, string action, string Id, string updatedby, string PorterName, string ServiceID)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_BREAKINSERTUPDATE", Con);
            cmd.Parameters.AddWithValue("@PORTERID", porterid);
            cmd.Parameters.AddWithValue("@DURATION", dur);
            cmd.Parameters.AddWithValue("@STARTTIME", starttim);
            cmd.Parameters.AddWithValue("@PORTERNAME", PorterName);
            cmd.Parameters.AddWithValue("@UPDATEDBY", updatedby);
            cmd.Parameters.AddWithValue("@ACTION", action);
            cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
            cmd.Parameters.AddWithValue("@ID", Id);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_BREAKINSERTUPDATE");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static void Execute(string TableName, string Column1, string Value1, string Column2, string Value2, string whereColumn1, string whereValue1)
    {
        try
        {
            SqlConnection TmpCon = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
            SqlCommand cmd = new SqlCommand("SP_EXECUTEUPDATE", TmpCon);
            cmd.Parameters.AddWithValue("@TABLENAME", TableName);

            cmd.Parameters.AddWithValue("@COLUMN1", Column1);
            cmd.Parameters.AddWithValue("@VALUE1", Value1);
            if (Column2.Length > 0)
            {
                cmd.Parameters.AddWithValue("@COLUMN2", Column2);
                cmd.Parameters.AddWithValue("@VALUE2", Value2);
            }
            cmd.Parameters.AddWithValue("@WHERECOLUMN1", whereColumn1);
            cmd.Parameters.AddWithValue("@WHEREVALUE1", whereValue1);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (TmpCon.State == ConnectionState.Closed)
                TmpCon.Open();
            cmd.ExecuteNonQuery();
            TmpCon.Close();
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_EXECUTEUPDATE");
        }
    }
    public static DataTable MultiTasking(string ReqID, string Porter, string Dept)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_MULTITASKING", Con);
        cmd.CommandTimeout = 1000;
        cmd.Parameters.AddWithValue("@REQUESTID", ReqID);
        cmd.Parameters.AddWithValue("@PORTERID", Porter);
        cmd.Parameters.AddWithValue("@DEPT", Dept);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_MULTITASKING");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;

    }

    public static DataTable GetRecords(string ProcedureName)
    {
        DataTable ds = new DataTable();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand(ProcedureName, con);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, ProcedureName);
            ds = new DataTable();
        }
        return ds;

    }

    public static DataTable GetRecords(string ProcedureName, string ParamName, string ParamValue, string ParamName1, string ParamValue1, string ParamName2, string ParamValue2)
    {
        DataTable ds = new DataTable();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand(ProcedureName, con);
                cmd.Parameters.AddWithValue(ParamName, ParamValue);
                cmd.Parameters.AddWithValue(ParamName1, ParamValue1);
                cmd.Parameters.AddWithValue(ParamName2, ParamValue2);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, ProcedureName);
            ds = new DataTable();
        }
        return ds;

    }


    public static DataTable RGSearch(string ProcedureName, string ParamName, string ParamValue, string ParamName1, string ParamValue1, string ParamName2, string ParamValue2, string ParamName3, string ParamValue3)
    {
        DataTable ds = new DataTable();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand(ProcedureName, con);
                cmd.Parameters.AddWithValue(ParamName, ParamValue);
                cmd.Parameters.AddWithValue(ParamName1, ParamValue1);
                cmd.Parameters.AddWithValue(ParamName2, ParamValue2);
                cmd.Parameters.AddWithValue(ParamName3, ParamValue3);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, ProcedureName);
            ds = new DataTable();
        }
        return ds;
    }
    public static DataTable GetRecords(string ProcedureName, string ParamName, string ParamValue, string ParamName1, string ParamValue1)
    {
        DataTable ds = new DataTable();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        try
        {

            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand(ProcedureName, con);
                cmd.Parameters.AddWithValue(ParamName, ParamValue);
                cmd.Parameters.AddWithValue(ParamName1, ParamValue1);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, ProcedureName);
            ds = new DataTable();
        }
        return ds;
    }
    public static DataTable GetEscalationRecords(string from, string To, string Porter)
    {
        DataTable ds = new DataTable();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        try
        {

            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand("SP_GETESCALATIONPERCENTAGE", con);
                cmd.Parameters.AddWithValue("@FROM", from);
                cmd.Parameters.AddWithValue("@TO", To);
                cmd.Parameters.AddWithValue("@ASSIGNTO", Porter);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_GETESCALATIONPERCENTAGE");
            ds = new DataTable();
        }
        return ds;
    }
    public static string GetResult(string Proc, string Param, string Value)
    {
        DataTable ds = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand(Proc, Con);
        cmd.Parameters.AddWithValue(Param, Value);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            SqlDataAdapter adpt = new SqlDataAdapter(cmd); Con.Open();
            adpt.Fill(ds);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, Proc);
            ds = new DataTable();
        }
        finally
        {
            while (ds.Rows.Count == 0)
            {
                SqlDataAdapter adpt = new SqlDataAdapter(cmd);
                if (Con.State == ConnectionState.Closed)
                    Con.Open();
                adpt.Fill(ds);
            }
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return (ds.Rows.Count > 0) ? ds.Rows[0]["RESULT"].ToString() : "";
    }

    public static DataSet PersetMaster(string ProcedureName, string Msg, string GroupName, string ID, string process, string ServiceID)
    {
        DataSet ds = new DataSet();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand(ProcedureName, con);
                cmd.Parameters.AddWithValue("@MSG", Msg);
                cmd.Parameters.AddWithValue("@ID", ID);
                cmd.Parameters.AddWithValue("@GROUPNAME", GroupName);
                cmd.Parameters.AddWithValue("@PROCESS", process);
                cmd.Parameters.AddWithValue("@SERVICEID", ServiceID);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, ProcedureName);
            ds = new DataSet();
        }
        return ds;
    }

    public static DataSet Departmentmaster(string ProcedureName, string Dept, string Is24Hrs, string ID, string process)
    {
        DataSet ds = new DataSet();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand(ProcedureName, con);
                cmd.Parameters.AddWithValue("@DEPARTMENT", Dept);
                cmd.Parameters.AddWithValue("@ID", ID);
                cmd.Parameters.AddWithValue("@IS24HRS", Is24Hrs);
                cmd.Parameters.AddWithValue("@PROCESS", process);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, ProcedureName);
            ds = new DataSet();
        }
        return ds;
    }
    public static DataSet RequestGroup(string Group, string IsActive, string ID, string process)
    {
        DataSet ds = new DataSet();
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        try
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                SqlCommand cmd = new SqlCommand("SP_REQUESTGROUP", con);
                cmd.Parameters.AddWithValue("@GROUPNAME", Group);
                cmd.Parameters.AddWithValue("@ID", ID);
                cmd.Parameters.AddWithValue("@ISACTIVE", IsActive);
                cmd.Parameters.AddWithValue("@PROCESS", process);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);

            }
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_REQUESTGROUP");
            ds = new DataSet();
        }
        return ds;
    }
    public static DataTable GetDeptIdlePorters(string PorterName, string Dept, string IsInitiate, string Porter1, string Porter2)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_GETIDLEPORTERSBYNAME_ADHOC", Con);
        cmd.CommandTimeout = 1000;
        cmd.Parameters.AddWithValue("@PORTERNAME", PorterName);
        cmd.Parameters.AddWithValue("@DEPT", Dept);
        cmd.Parameters.AddWithValue("@ISINITIATE", IsInitiate);
        cmd.Parameters.AddWithValue("@PORTERID1", Porter1);
        cmd.Parameters.AddWithValue("@PORTERID2", Porter2);
        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "[SP_GETIDLEPORTERSBYNAME_ADHOC]");
            dt = new DataTable();
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;

    }
    //public static DataSet getPorterLocation(string tagid)
    //{
    //    DataSet dt = new DataSet();
    //    SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
    //    SqlCommand cmd = new SqlCommand("GetPorterLocation", Con);
    //    cmd.CommandTimeout = 1000;
    //    cmd.Parameters.AddWithValue("@TagId", tagid);

    //    SqlDataAdapter adpt = new SqlDataAdapter(cmd);
    //    cmd.CommandType = CommandType.StoredProcedure;
    //    try
    //    {
    //        Con.Open();
    //        adpt.Fill(dt);
    //    }
    //    catch (Exception ex)
    //    {

    //        InsertError(ex.Message, "SP_GETPATIENTNAMEBYBEDID");
    //    }
    //    finally
    //    {
    //        if (Con.State == ConnectionState.Open)
    //            Con.Close();
    //    }
    //    return dt;

    //}


    public static DataTable getResorceUsage(string from, string To, string Porter, string GroupBy, string Serviceid, string Hospitalloc)
    {
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        DataTable ds = new DataTable();
        using (SqlConnection con = new SqlConnection(constr))
        {
            SqlCommand cmd = new SqlCommand("SP_REPORT_RESOURCEUSEAGE", con);
            cmd.Parameters.AddWithValue("@FROM", from);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@PORTERID", Porter);
            cmd.Parameters.AddWithValue("@GROUPBY", GroupBy);
            cmd.Parameters.AddWithValue("@SERVICEID", Serviceid);
            cmd.Parameters.AddWithValue("@HOSPITALLOC", Hospitalloc);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }
            catch (Exception ex)
            {
                InsertError(ex.Message, "SP_REPORT_RESOURCEUSEAGE");
                ds = new DataTable();

            }
        }
        return ds;

    }
    public static DataTable getEmpOpportunity(string from, string To, string GroupBy)
    {
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        DataTable ds = new DataTable();
        using (SqlConnection con = new SqlConnection(constr))
        {
            SqlCommand cmd = new SqlCommand("SP_REPORT_EMPOPPORTUNITY", con);
            cmd.Parameters.AddWithValue("@FROM", from);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@GROUPBY", GroupBy);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }
            catch (Exception ex)
            {
                InsertError(ex.Message, "SP_REPORT_EMPOPPORTUNITY");
            }
        }
        return ds;

    }
    public static DataTable getDurationOverruns(string from, string To, string Porter, string GroupBy, string Serviceid, string Hospitalloc)
    {
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        DataTable ds = new DataTable();
        using (SqlConnection con = new SqlConnection(constr))
        {
            SqlCommand cmd = new SqlCommand("SP_REPORT_DURATIONOVERRUNSCOUNT", con);
            cmd.Parameters.AddWithValue("@FROM", from);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@PORTERID", Porter);
            cmd.Parameters.AddWithValue("@GROUPBY", GroupBy);
            cmd.Parameters.AddWithValue("@SERVICEID", Serviceid);
            cmd.Parameters.AddWithValue("@HOSPITALLOC", Hospitalloc);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }
            catch (Exception ex)
            {
                InsertError(ex.Message, "SP_REPORT_DURATIONOVERRUNSCOUNT");
                ds = new DataTable();
            }
        }
        return ds;

    }
    public static DataTable getResponseOverruns(string from, string To, string Porter, string GroupBy, string Serviceid, string Hospitalloc)
    {
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        DataTable ds = new DataTable();
        using (SqlConnection con = new SqlConnection(constr))
        {
            SqlCommand cmd = new SqlCommand("SP_REPORT_RESPONSEOVERRUNSCOUNT", con);
            cmd.Parameters.AddWithValue("@FROM", from);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@PORTERID", Porter);
            cmd.Parameters.AddWithValue("@GROUPBY", GroupBy);
            cmd.Parameters.AddWithValue("@SERVICEID", Serviceid);
            cmd.Parameters.AddWithValue("@HOSPITALLOC", Hospitalloc);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }
            catch (Exception ex)
            {
                InsertError(ex.Message, "SP_REPORT_RESPONSEOVERRUNSCOUNT");
                ds = new DataTable();
            }
        }
        return ds;

    }
    public static DataTable getDurationOverruns(string from, string To, string Porter, string GroupBy)
    {
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        DataTable ds = new DataTable();
        using (SqlConnection con = new SqlConnection(constr))
        {
            SqlCommand cmd = new SqlCommand("SP_REPORT_DURATIONOVERRUNSCOUNT", con);
            cmd.Parameters.AddWithValue("@FROM", from);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@PORTERID", Porter);
            cmd.Parameters.AddWithValue("@GROUPBY", GroupBy);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }
            catch (Exception ex)
            {
                InsertError(ex.Message, "SP_REPORT_DURATIONOVERRUNSCOUNT");
                ds = new DataTable();
            }
        }
        return ds;

    }
    public static DataTable getResponseOverruns(string from, string To, string Porter, string GroupBy)
    {
        string constr = ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString;
        DataTable ds = new DataTable();
        using (SqlConnection con = new SqlConnection(constr))
        {
            SqlCommand cmd = new SqlCommand("SP_REPORT_RESPONSEOVERRUNSCOUNT", con);
            cmd.Parameters.AddWithValue("@FROM", from);
            cmd.Parameters.AddWithValue("@TO", To);
            cmd.Parameters.AddWithValue("@PORTERID", Porter);
            cmd.Parameters.AddWithValue("@GROUPBY", GroupBy);
            cmd.CommandType = CommandType.StoredProcedure;
            try
            {
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(ds);
            }
            catch (Exception ex)
            {
                InsertError(ex.Message, "SP_REPORT_RESPONSEOVERRUNSCOUNT");
                ds = new DataTable();
            }
        }
        return ds;

    }

    public static DataSet GroupDetails(string groupid, string groupname, string userids, string locationids, string process)
    {
        DataSet ds = new DataSet();
        try
        {
            SqlDataAdapter dbAdap = new SqlDataAdapter();
            dbAdap.SelectCommand = new SqlCommand();
            dbAdap.SelectCommand.CommandText = "SP_GETGROUPUPDATE";
            dbAdap.SelectCommand.CommandType = CommandType.StoredProcedure;
            dbAdap.SelectCommand.Parameters.AddWithValue("@GROUPID", groupid);
            dbAdap.SelectCommand.Parameters.AddWithValue("@GROUPNAME", groupname);
            dbAdap.SelectCommand.Parameters.AddWithValue("@USERIDS", userids);
            dbAdap.SelectCommand.Parameters.AddWithValue("@LOCATIONIDS", locationids);
            dbAdap.SelectCommand.Parameters.AddWithValue("@PROCESS", process);
            dbAdap.SelectCommand.Connection = AcquireConnection();
            dbAdap.SelectCommand.Connection.Close();
            dbAdap.Fill(ds, "data");
            dbAdap.Dispose();
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "SP_REPORT_RESPONSEOVERRUNSCOUNT");
            ds = new DataSet();
        }

        return ds;
    }

    public static SqlConnection AcquireConnection()
    {
        SqlConnection dbCon = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ConnectionString.ToString());
        dbCon.Open();

        return dbCon;

    }

    public static DataSet GetGlobalAllRecords(string spName, string tabName, string tmptbl)
    {
        DataSet ds = new DataSet();
        try
        {
            SqlDataAdapter dbAdap = new SqlDataAdapter();
            dbAdap.SelectCommand = new SqlCommand();
            dbAdap.SelectCommand.CommandText = spName;
            dbAdap.SelectCommand.CommandType = CommandType.StoredProcedure;
            dbAdap.SelectCommand.Parameters.AddWithValue("@BulkUploadTableName", tabName);
            dbAdap.SelectCommand.Connection = AcquireConnection();
            dbAdap.SelectCommand.Connection.Close();
            dbAdap.Fill(ds, tmptbl);
            dbAdap.Dispose();
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, spName);
            ds = new DataSet();
        }
        return ds;
    }


    public static DataRow ExecuteQuery(string Id, string Process)
    {
        DataTable dt = new DataTable(); string Query = string.Empty;
        SqlDataAdapter dbAdap = new SqlDataAdapter();
        switch (Process)
        {
            case "LOCATIONMASTER":
                Query = "SELECT * FROM " + Process + " WHERE LOCATIONCODE = '" + Id + "'";
                break;

        }
        dbAdap.SelectCommand = new SqlCommand(Query);
        dbAdap.SelectCommand.CommandType = CommandType.Text;
        dbAdap.SelectCommand.Connection = DataAccess.AcquireConnection();
        dbAdap.SelectCommand.Connection.Close();
        try
        {
            dbAdap.Fill(dt);
        }
        catch (SqlException sqex)
        {
            DataAccess.InsertError(sqex.Message, "logerror");
            return (dt.Rows.Count > 0) ? dt.Rows[0] : null;
        }
        finally
        {
            dbAdap.Dispose();
        }
        return (dt.Rows.Count > 0) ? dt.Rows[0] : null;
    }
    public static bool BulkInsertUpdate(string spName, string qry, string mode, string ourprimarykey, string checkExistVar1, string @checkExistVar2, string tblname)
    {
        SqlCommand dbCmd = new SqlCommand();
        SqlConnection con = AcquireConnection();
        SqlTransaction Trans;
        Trans = con.BeginTransaction();

        dbCmd.Connection = con;
        dbCmd.Transaction = Trans;
        dbCmd.CommandType = CommandType.StoredProcedure;
        dbCmd.CommandText = spName;
        dbCmd.Parameters.AddWithValue("@qry", qry);
        //  dbCmd.Parameters.AddWithValue("@UpdatedBankId", logData);
        dbCmd.Parameters.AddWithValue("@mode", mode);
        dbCmd.Parameters.AddWithValue("@cliPrimaryKey", ourprimarykey);
        dbCmd.Parameters.AddWithValue("@checkExistVar1", checkExistVar1);
        dbCmd.Parameters.AddWithValue("@checkExistVar2", checkExistVar2);
        dbCmd.Parameters.AddWithValue("@tableName", tblname);

        try
        {
            bool retBoolVal = ((string)dbCmd.ExecuteScalar()).ToUpper() == "TRUE" ? true : false;
            Trans.Commit();
            return retBoolVal;
        }
        catch (Exception ex1)
        {
            DataAccess.InsertError(ex1.Message, "logerror");
            return false;
        }
        finally
        {
            con.Close();
        }
    }


    public static DataTable ReportMaster(string Type, string From, string To, string PorterId, string p)
    {
        return new DataTable();
    }




}