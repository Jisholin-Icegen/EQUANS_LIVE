using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;

public partial class Master_MailSettings : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            SetSettings();
    }
    private void SetSettings()
    {
        DataTable ds = DataAccess.MailMaster(string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, "GET");
        TextDailyMailTo.Text = ds.Rows[0]["DAILYMAILTO"].ToString(); TextDailyMailCC.Text = ds.Rows[0]["DAILYMAILTOCC"].ToString();
        TATTextTo.Text = ds.Rows[0]["TATMAILTO"].ToString(); TATTextCC.Text = ds.Rows[0]["TATMAILCC"].ToString();
        TextTo.Text = ds.Rows[0]["MAILTO"].ToString(); TextCC.Text = ds.Rows[0]["MAILTOCC"].ToString();
        TextServer.Text = ds.Rows[0]["SMTPSERVER"].ToString(); TextPort.Text = ds.Rows[0]["PORT"].ToString();
       // ((HtmlGenericControl)Master.FindControl("HeaderText")).InnerHtml = "ADMIN ::  E-MAIL SETTINGS";
        TextDailyMailTo.Focus();
    }
}