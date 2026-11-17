using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

using Telerik.Web.UI;

public partial class Master_Roles : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {


        BindData();
    }

    private void BindData()
    {

        GridRoles.DataSource = new DataTable();
        GridRoles.DataBind();
    }
}