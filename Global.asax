<%@ Application Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Web.UI.HtmlControls" %>
<script RunAt="server">

    System.Timers.Timer mTimer = new System.Timers.Timer();
    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup
        try
        {
            mTimer.Enabled = true;
            mTimer.Interval = 1000;
            mTimer.Elapsed += new System.Timers.ElapsedEventHandler(mTimer_Elapsed);

        }
        catch (Exception ex)
        {
        }

    }

    public void mTimer_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
    {
        try
        {
            mTimer.Enabled = false; bool result = false, result1 = false;
            //DataTable dt = DataAccess.RequestMaster(string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, "GETMAIL"),
            //    dt1 = DataAccess.RequestMaster(string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, "GETMESSAGE");
            //if (dt.Rows.Count > 0) // Complaint
            //    result = DataAccess.SendMail("n.anand@icegen.net", "REQUEST DELAYED", DataAccess.GetBody(dt), "manipalporter@gmail.com", "adminicegen");
            //if (result)
            //    DataAccess.RequestMaster(string.Empty, dt.Rows[0]["REQUEST"].ToString(), string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, "UPDATEMAIL");
            ////if (dt1.Rows.Count > 0) // Message 
            //    result = DataAccess.SendMessage(dt.Rows[0]["TAGID"].ToString(), dt.Rows[0]["MESSAGE"].ToString());
            //if (result)
            //    DataAccess.RequestMaster(string.Empty, dt.Rows[0]["ID"].ToString(), string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, "UPDATEMESSAGE");
                
            mTimer.Enabled = true;
        }
        catch (Exception ex)
        {

        }



    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    void Application_Error(object sender, EventArgs e)
    {
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e)
    {
        // Code that runs when a new session is started

    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.

    }
       
</script>
