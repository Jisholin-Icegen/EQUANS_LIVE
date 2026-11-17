using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;


public partial class Track_FloorTracking : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            LoadGrid();
    }

    private void LoadGrid()
    {
        GridTrack.DataSource = new DataTable();
        GridTrack.DataBind();
    }
}