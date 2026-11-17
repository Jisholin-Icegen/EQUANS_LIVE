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
/// <summary>
/// Summary description for DataLayer
/// </summary>
public class DataLayer
{
    public DataLayer()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static DataTable GetGroupLocation(string loc, string grp,string process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("[SP_GETGROUPLOCATION]", Con);
            cmd.Parameters.AddWithValue("@LOCATION", loc);
            cmd.Parameters.AddWithValue("@GROUPID", grp);
            cmd.Parameters.AddWithValue("@PROCESS", process);

            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_RELEASEPORTER"); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    public static DataTable ReleasePorter(string PorterId, string Requestid)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_RELEASEPORTER", Con);
            cmd.Parameters.AddWithValue("@REQUESTID", Requestid);

            cmd.Parameters.AddWithValue("@PORTERID", PorterId);
             

            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_RELEASEPORTER"); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }
    /*
    public static DataTable ChangePwd(string Id,  string Password, string Process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SP_CHANGEPWD", Con);
            cmd.Parameters.AddWithValue("@USERID", Id);
             
            cmd.Parameters.AddWithValue("@PASSWORD", Password);
            
            cmd.Parameters.AddWithValue("@PROCESS", Process);
            
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex) { InsertError(ex.Message, "SP_CHANGEPWD"); }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }*/
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
    public static DataSet FloowPorterLocation(string floorid,string process)
    {
        DataSet dt = new DataSet();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        SqlCommand cmd = new SqlCommand("SP_FLOORPORTERLOCATION", Con);
        cmd.CommandTimeout = 1000;
        cmd.Parameters.AddWithValue("@FLOORID", floorid);
        cmd.Parameters.AddWithValue("@PROCESS", process);

        SqlDataAdapter adpt = new SqlDataAdapter(cmd);
        cmd.CommandType = CommandType.StoredProcedure;
        try
        {
            Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {

            InsertError(ex.Message, "FloowPorterLocation");
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;

    }
    public static DataTable SGetBranches(string HostingUrl, string process)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            SqlCommand cmd = new SqlCommand("SGetBranches", Con);
            cmd.Parameters.AddWithValue("@HostingUrl", HostingUrl);
            cmd.Parameters.AddWithValue("@PROCESS", process);


            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adpt = new SqlDataAdapter(cmd);
            if (Con.State == ConnectionState.Closed)
                Con.Open();
            adpt.Fill(dt);
        }
        catch (Exception ex)
        {
            InsertError(ex.Message, "floor");
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;
    }

    public static void InsertError(string ErrMsg, string SpName)
    {
        SqlConnection TmpCon = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
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
}