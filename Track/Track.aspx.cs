using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data;

public partial class Track_Track : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            SetDefault();
    }

    private void SetDefault()
    {
        ((HtmlGenericControl)Master.FindControl("HeaderText")).InnerHtml = " :: TRACK :: ";
        GridRequest.DataSource = new DataTable();
        GridRequest.DataBind();
    }

}