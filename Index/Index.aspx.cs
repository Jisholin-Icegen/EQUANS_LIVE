using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Net;
using System.IO;

public partial class Index_Index : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        BindData();
    }
    private void BindData()
    {
        //HFCryptoKey.Value = "9090909090909090";
        //HFCryptoIv.Value = "9090909090909090";
        //GridRequest.DataSource = new DataTable();
        //GridRequest.DataBind();
    }
}