using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

using Telerik.Web.UI;

public partial class Master_Break : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {


        BindData();
    }

    private void BindData()
    {

        GridBreak.DataSource = new DataTable();
        GridBreak.DataBind();
    }
}