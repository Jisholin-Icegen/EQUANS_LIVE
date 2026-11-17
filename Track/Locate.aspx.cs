using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

using System.Xml;
using System.Text;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using System.Data.SqlClient;

public partial class Track_Locate : System.Web.UI.Page
{
    string ErrMsg;
    protected void Page_Load(object sender, EventArgs e)
    {
        string messages = Convert.ToString(Masters.Messages.ERROR);
        int status = Convert.ToInt32(Masters.Messages.ERROR);
        floorMapFunction();
    }

    public string fetchMapCommand(string mpath, string lpath, string TagID, string Curtim, string x, string y, string flr)
    {
        try
        {
            System.Drawing.Image img = System.Drawing.Image.FromFile(mpath + flr);
            using (Graphics g = Graphics.FromImage(img))
            {

                // Place a.jpg
                //  g.DrawImage(Image.FromFile(mpath + "porter.png"), new Point(Convert.ToInt32( x), Convert.ToInt32( y)));

                /*  Image i = Image.FromFile(mpath + "porter1.png"); //porter1.png This is 300x300
                Bitmap bitMAP1 = new Bitmap(i,60,60);
                //bitmap.SetResolution(100, 100,bitmap.PixelFormat.For
                bitMAP1.PixelFormat. = CompositingQuality.HighQuality;
                bitMAP1.SmoothingMode = SmoothingMode.HighQuality;
                bitMAP1.InterpolationMode = InterpolationMode.HighQualityBicubic;
                */


                /*  var thumbGraph = Graphics.FromImage(bitmap);
                  thumbGraph.CompositingQuality = CompositingQuality.HighQuality;
                  thumbGraph.SmoothingMode = SmoothingMode.HighQuality;
                  thumbGraph.InterpolationMode = InterpolationMode.HighQualityBicubic;*/
                /*  byte[] b = File.ReadAllBytes(mpath + "porter1.png");
                  using (var stream = new System.IO.MemoryStream(b))
                  {
                      var img1 = Image.FromStream(stream);

                      g.DrawImage(img1, Convert.ToInt32(x) - 26, Convert.ToInt32(y) - 27, 60, 60);
                  }  */

                g.DrawImage(System.Drawing.Image.FromFile(mpath + "porter1.png"), Convert.ToInt32(x) - 26, Convert.ToInt32(y) - 27, 150, 180);//90 100



                //  g.DrawImage(Image.FromFile(mpath + "porter1.png",true), Convert.ToInt32(x), Convert.ToInt32(y));


                /* g.DrawImage(Image.FromFile("map.png"), new Point(395 - 60, 1221 - 70));     
     */

                g.Dispose();

                // Save changes as output.jpg
                img.Save(lpath + Curtim + ".jpg", ImageFormat.Jpeg);



                img.Dispose();

            }


            System.Drawing.Bitmap image = new System.Drawing.Bitmap(lpath + Curtim + ".jpg");
            ImageConverter imgCon = new ImageConverter();
            byte[] rPicture = (byte[])imgCon.ConvertTo(image, typeof(byte[]));
            string base64String = Convert.ToBase64String(rPicture, 0, rPicture.Length);
            string imgpath = "data:image/png;base64," + base64String;

            this.ErrMsg = "<IMAGE>" + imgpath + "</IMAGE>";//"Success";
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            DataAccess.InsertError(Excep.Message, "fetchMapCommand");
            throw;
        }

        return this.ErrMsg;
    }
    public   void InsertError(string ErrMsg, string SpName)
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
    public  DataSet getPorterLocation(string tagid)
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
        }
        finally
        {
            if (Con.State == ConnectionState.Open)
                Con.Close();
        }
        return dt;

    }
    public void floorMapFunction()
    {
        //string outtype = Request.Params["outtype"];
        XmlDocument xmlformat = new XmlDocument();
        bool result;
        string status = string.Empty, loc = string.Empty;

        string img_path = string.Empty;
        try
        {
            string curtime = Request.Params["CurrentTime"];
            string TagId = Request.Params["TAGID"];
          //  EkahauClass LocatePorter = new EkahauClass();

            DataSet ds = new DataSet();
            ds = DataAccess.getPorterLocation(TagId);
            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                img_path = fetchMapCommand(Server.MapPath("~/Track/Images/Map/"), Server.MapPath("~/Track/Images/Location/"), TagId, curtime, ds.Tables[0].Rows[0]["Xaxis"].ToString(), ds.Tables[0].Rows[0]["Yaxis"].ToString(), ds.Tables[0].Rows[0]["FloorName"].ToString());
                result = true;
                status = "SUCCESS";
                loc = ds.Tables[0].Rows[0]["Location"].ToString();
            }
            else
            {
                result = false;
                status = "FAILURE";
            }
        }
        catch (Exception ex)
        {
            result = false;
            status = "FAILURE";
        }
        finally
        {
            ClearMap();
        }
        xmlformat = XmlbuilderfromString(img_path, status, result,loc);
        Response.Write(xmlformat.InnerXml);
    } private void ClearMap()
            {

                string[] files = Directory.GetFiles(Server.MapPath("~/Track/Images/Location/"));

                foreach (string tfile in files)
                {
                    try
                    {
                        FileInfo fi = new FileInfo(tfile);
                        if (fi.CreationTime < DateTime.Now.AddSeconds(-15))
                            fi.Delete();
                    }
                    catch (Exception ex)
                    {

                    }
                }
            }
    public static XmlDocument XmlbuilderfromString(string _doc, string status, bool _result,string loc)
    {

        XmlDocument doc = new XmlDocument();
        StringBuilder strings = new StringBuilder();


        strings.Append("<DATA>");
        strings.Append("<HEADER>");
        strings.Append("<STATUS>" + status + "</STATUS>");
        strings.Append("<LOCATION>" + loc.ToUpper() + "</LOCATION>");
        strings.Append("</HEADER>");

        if (_doc.Length > 0)
        {
            strings.Append("<CONTENT>");
            strings.Append(_doc.ToString());
            strings.Append("</CONTENT>");
            strings.Append("</DATA>");
        }
        else
        {
            strings.Append("</DATA>");
        }

        doc.LoadXml(strings.ToString());
        return doc;
    }
}
