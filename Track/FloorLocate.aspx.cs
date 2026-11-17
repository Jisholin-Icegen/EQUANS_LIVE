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
using System.Web.Script.Serialization;
using System.Xml;
using System.Text;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using System.Data.SqlClient;
using ClientsideEncryption;
using System.Collections.Generic;

public partial class Track_FloorLocate : System.Web.UI.Page
{
    string ErrMsg;
    public static string process { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        FromWebMobile();

       
    }
    public void FromWebMobile()
    {
        DataSet data = new DataSet();
        process = ((!string.IsNullOrEmpty(Request.QueryString["Process"])) ? AESEncrytDecry.DecryptStringAES(Request.QueryString["Process"].ToString()) : "");
        switch (process)
        {
            case "FLOORWISE":
                string messages = Convert.ToString(Masters.Messages.ERROR);
                int status = Convert.ToInt32(Masters.Messages.ERROR);
               
                data = floorMapFunction();
                break;
          
        }
        //data = getRecords();
        JavaScriptSerializer serializer = new JavaScriptSerializer() { MaxJsonLength = int.MaxValue };
        List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
        Dictionary<string, object> row;

        foreach (DataTable table in data.Tables)
        {
            if (table.Rows.Count > 0)
            {
                foreach (DataRow dr in table.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in table.Columns)
                    {
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
            }
        }
        Response.Write(serializer.Serialize(rows));
    }

  
    public DataSet floorMapFunction()
    {
        //string outtype = Request.Params["outtype"];
      //  XmlDocument xmlformat = new XmlDocument();
        bool result;
        string status = string.Empty, loc = string.Empty;
        DataSet ds = new DataSet();

        string img_path = string.Empty;
        try
        {
             
            string curtime = string.IsNullOrEmpty(Request.QueryString["CurrentTime"]) ? "" : Request.QueryString["CurrentTime"].ToString(),
              floorid=  string.IsNullOrEmpty(Request.QueryString["FLOORID"]) ? "" : Request.QueryString["FLOORID"].ToString(),
            userid = string.IsNullOrEmpty(Request.QueryString["USERID"]) ? "" : Request.QueryString["USERID"].ToString(),
             Process = string.IsNullOrEmpty((Request.QueryString["Process"])) ? "" : AESEncrytDecry.DecryptStringAES( Request.QueryString["PROCESS"].ToString());

             


            ds = DataLayer.FloowPorterLocation(floorid, "FLOORWISE");//ROW_NUMBER() OVER (ORDER BY ID) AS SNO,USERNAME,ZONENAME,XAXIS,YAXIS,MAPNAME,'' as FLOORIMAGE
            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                img_path = fetchMapCommand(ds.Tables[0],Server.MapPath("~/Track/Images/Map/"), Server.MapPath("~/Track/Images/Location/"), curtime,  ds.Tables[0].Rows[0]["FloorName"].ToString(),userid);
                result = true;
                status = "SUCCESS";
                ds.Tables[0].Rows[0]["FLOORIMAGE"] = img_path;
                ds.AcceptChanges();
              //  loc = ds.Tables[0].Rows[0]["Location"].ToString();
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
      //  xmlformat = XmlbuilderfromString(img_path, status, result, loc);
        return ds;
    }
    private void ClearMap()
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
    public static XmlDocument XmlbuilderfromString(string _doc, string status, bool _result, string loc)
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
    public string fetchMapCommand(DataTable dt,string mpath, string lpath, string Curtim, string flr,string userid)
    {
        try
        {
            string filename = string.Empty;
            System.Drawing.Image img = System.Drawing.Image.FromFile(mpath + flr);
            Random random = new Random();
            filename = Curtim + userid + random.Next(100, 500).ToString() + ".jpg";
            using (Graphics g = Graphics.FromImage(img))
            {

                 
                foreach (DataRow dr in dt.Rows)
                {
                    g.DrawImage(System.Drawing.Image.FromFile(mpath + dr["SNO"].ToString()+".PNG"), Convert.ToInt32(dr["XAXIS"].ToString()) - 26, Convert.ToInt32(dr["YAXIS"].ToString()) - 27, 150, 180);//90 100
                }


              

                g.Dispose();

                // Save changes as output.jpg

                img.Save(lpath + filename, ImageFormat.Jpeg);



                img.Dispose();

            }

           // this.ErrMsg = filename;
       System.Drawing.Bitmap image = new System.Drawing.Bitmap(lpath + filename);
            ImageConverter imgCon = new ImageConverter();
            byte[] rPicture = (byte[])imgCon.ConvertTo(image, typeof(byte[]));
            string base64String = Convert.ToBase64String(rPicture, 0, rPicture.Length);
            string imgpath = "data:image/png;base64," + base64String;
            this.ErrMsg = imgpath;
              /*   this.ErrMsg = "<IMAGE>" + imgpath + "</IMAGE>";//"Success";  */
        }
        catch (Exception Excep)
        {
            this.ErrMsg = "";
            DataAccess.InsertError(Excep.Message, "FloorwiseLoction :fetchMapCommand");
            throw;
        }

        return this.ErrMsg;
    }

}