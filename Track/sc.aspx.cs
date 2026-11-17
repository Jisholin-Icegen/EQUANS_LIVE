using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

using System.Web.UI.WebControls;
using System.Reflection;

public partial class Track_sc : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        Button1_Click(Button1, EventArgs.Empty);

      

        //  Button1.Click += Button1_Click;
        /*   // invoke method
          Type t = typeof(System.Web.UI.WebControls.Button);
          object[] p = new object[1];
          p[0] = EventArgs.Empty;
          MethodInfo m = t.GetMethod("OnClick", BindingFlags.NonPublic | BindingFlags.Instance);
          m.Invoke(Button1, p); */
    }
    
    protected void btnresGet_Click(object sender, EventArgs e)
    {
        DataTable dt = new DataTable();
        SqlConnection Con = new SqlConnection(ConfigurationManager.ConnectionStrings["cineConn"].ToString());
        try
        {
            
            SqlDataAdapter adpt = new SqlDataAdapter("select top 50 * from GlobalUpdate order by CurrentDatetime desc ", Con);
            Con.Open();
            adpt.Fill(dt);
            GridView2.DataSource = dt;
            GridView2.DataBind();
        }
        catch (Exception ex) {  }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        Response.Write("hais");
       
    }
}