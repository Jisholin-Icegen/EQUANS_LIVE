using System;
using System.Data;
using System.Configuration;
//using System.Linq;
using System.Web;
//using System.Web.Security;
//using System.Web.UI;
//using System.Web.UI.HtmlControls;
//using System.Web.UI.WebControls;
//using System.Web.UI.WebControls.WebParts;
//using System.Xml.Linq;

using System.Net;
using System.Xml;
using System.IO;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;


//AUTHOR    : NANDA KUMAR THANIGAIVELAN
//DATE      : January 31st, 2011
//E_MAIL    : nandakumar(at)icegen.net (or) nanda.sivam(at)gmail.com

/// <summary>
/// To provide single class interface for different Ekahau API's implementation.
/// <para>
/// Use constructors to initializes the variables according to the required methods.
/// </para>
/// </summary>
public class EkahauClass : bulkCopy
{
    string Server;
    string Port;
    string URL;

    string EPEId;
    string EPEPwd;

    String TmpTagId;
    string TmpName;
    string ErrMsg;

    int TmpBuzzerCount;
    int TmpMapId;

    Stream streamResponse;
    StreamReader streamReader;
    XmlTextReader xmlTxtReader;

    DataSet xmlDataSet;

    /// <summary>
    /// Default Constructor
    /// </summary>
    public EkahauClass()
    {
        this.Server = ConfigurationSettings.AppSettings["EPEserver"].ToString();
        this.Port = ConfigurationSettings.AppSettings["EPEPort"].ToString();
        this.EPEId = ConfigurationManager.AppSettings["EPEName"].ToString();
        this.EPEPwd = ConfigurationManager.AppSettings["EPEValue"].ToString();
        this.URL = "";

        this.ErrMsg = "";
        this.TmpTagId = "";
        this.TmpName = "";

        this.TmpBuzzerCount = 0;
        this.TmpMapId = 0;
    }

    /// <summary>
    /// Constructor for fetchMapCluster() and fetchFloorMapCommand() method
    /// </summary>
    /// <param name="PmapId"></param>
    public EkahauClass(int PmapId)
    {
        this.Server = ConfigurationSettings.AppSettings["EPEserver"].ToString();
        this.Port = ConfigurationSettings.AppSettings["EPEPort"].ToString();
        this.EPEId = ConfigurationManager.AppSettings["EPEName"].ToString();
        this.EPEPwd = ConfigurationManager.AppSettings["EPEValue"].ToString();
        this.TmpMapId = PmapId;

        this.ErrMsg = "Initialized";
    }

    /// <summary>
    /// Constructor for fetchMapCommand method, fetchMapwithZoomCommand method, fetchPositionMethod method 
    /// </summary>
    /// <param name="PtagId"></param>
    public EkahauClass(String PtagId)
    {
        this.Server = ConfigurationSettings.AppSettings["EPEserver"].ToString();
        this.Port = ConfigurationSettings.AppSettings["EPEPort"].ToString();
        this.EPEId = ConfigurationManager.AppSettings["EPEName"].ToString();
        this.EPEPwd = ConfigurationManager.AppSettings["EPEValue"].ToString();
        this.TmpTagId = PtagId;

        this.ErrMsg = "Initalized";
    }

    /// <summary>
    /// Constructor for buzzerCommand method 
    /// </summary>
    /// <param name="PTagId"></param>
    /// <param name="PbuzzerCount"></param>
    public EkahauClass(string PTagId, int PbuzzerCount)
    {
        this.Server = ConfigurationSettings.AppSettings["EPEserver"].ToString();
        this.Port = ConfigurationSettings.AppSettings["EPEPort"].ToString();
        this.EPEId = ConfigurationManager.AppSettings["EPEName"].ToString();
        this.EPEPwd = ConfigurationManager.AppSettings["EPEValue"].ToString();
        this.TmpTagId = PTagId;
        this.TmpBuzzerCount = PbuzzerCount;

        this.ErrMsg = "Initalized";
    }

    /// <summary>
    /// Constructor for writeCommand method
    /// </summary>
    /// <param name="PTagId"></param>
    /// <param name="PName"></param>
    public EkahauClass(string PTagId, string PName)
    {
        this.Server = ConfigurationSettings.AppSettings["EPEserver"].ToString();
        this.Port = ConfigurationSettings.AppSettings["EPEPort"].ToString();
        this.EPEId = ConfigurationManager.AppSettings["EPEName"].ToString();
        this.EPEPwd = ConfigurationManager.AppSettings["EPEValue"].ToString();
        this.TmpTagId = PTagId;
        this.TmpName = PName;

        this.ErrMsg = "Initalized";
    }

    /// <summary>
    /// To send information to Ekahau to map the tag with the patient
    /// <para>
    /// Create the class object by passing the corresponding arguments then call the function
    /// </para>
    /// </summary>
    /// <returns>String, If command successfully sent then, "Success" will return,  else "Cause of the Exception" will return.</returns>
    public string writeCommand()
    {
        try
        {
            //Stream streamResponse;
            //string Url =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +Server + ":8080/epe/cfg/tagsetname?tagid=" + this.TmpTagId + "&name=" + this.TmpName + "&profile = slow";
            XmlDocument xmldoc = new XmlDocument();
            XmlTextReader xmltxtReader;
            StreamReader streamRead;
            Stream streamRespon;
            DataSet xmlDataSet = new DataSet("XmlData");

            string url = "http://192.168.10.6:8550/epe/pos/taglist?zoneid=10&fields=all";
            HttpWebRequest myRequest = (HttpWebRequest)WebRequest.Create(url);
            myRequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse myHttpWebRespon = (HttpWebResponse)myRequest.GetResponse();
            streamRespon = myHttpWebRespon.GetResponseStream();
            streamRead = new StreamReader(streamRespon);
            xmltxtReader = new XmlTextReader(streamRead);
            xmlDataSet.ReadXml(xmltxtReader);




            this.URL = ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + " /epe/cfg/tagsetname?tagid=" + this.TmpTagId + "&name=" + this.TmpName + "&profile = slow";
            HttpWebRequest httpRequest = (HttpWebRequest)WebRequest.Create(this.URL);
            httpRequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse myHttpWebResponse = (HttpWebResponse)httpRequest.GetResponse();
            this.streamResponse = myHttpWebResponse.GetResponseStream();
            //write response, if need

            this.ErrMsg = "Success";
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }

    /// <summary>
    /// To send the buzzer command to Ekahau, inturn Ekahau will send to the tags respectively
    /// <para>
    /// <returns>String, If command successfully sent then, "Success" will return,  else "Cause of the Exception" will return.</returns>
    /// </para>
    /// </summary>
    public string buzzerCommand(string TagID)
    {
        try
        {
            XmlDocument xmldoc = new XmlDocument();
            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":8550/epe/cfg/tagcommandadd?tagid=" + TagID + "&&cmd=mmm 0&cmd=mmt 1";
            DigestHttpWebRequest req = new DigestHttpWebRequest("admin", "admin");
            HttpWebResponse webResponse = req.GetResponse(new Uri(string.Format(URL)));
            Stream stream = webResponse.GetResponseStream();

            this.ErrMsg = "Success";
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
        }
        return this.ErrMsg;
    }

    /// <summary>
    /// To fetch map from the Ekahau server & store in the temporary location
    /// <para>Return "Success", if completed else throws error</para>
    /// </summary>
    /// <returns>String, If command successfully sent then, "Success" will return,  else "Cause of the Exception" will return.</returns>
    public string fetchMapCommand(string TagID)
    {
        try
        {
            //Stream streamResponse;
            string path = HttpContext.Current.Request.MapPath(HttpContext.Current.Request.ApplicationPath) + @"\Images\LOCATE\" + TagID + "_500x1000.png",
                 MURL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":8550/epe/map/render?tagid=" + TagID + "&format=png&height=500&width=1000",
                 return_p = string.Empty, fpath = string.Empty,Dpath = string.Empty;
            DigestHttpWebRequest req = new DigestHttpWebRequest("admin", "admin");
            HttpWebResponse webResponse = req.GetResponse(new Uri(string.Format(MURL)));
            this.streamResponse = webResponse.GetResponseStream();
        
            System.Drawing.Bitmap image = new System.Drawing.Bitmap(this.streamResponse);
            ImageConverter imgCon = new ImageConverter();
            byte[] rPicture = (byte[])imgCon.ConvertTo(image, typeof(byte[]));
            string base64String = Convert.ToBase64String(rPicture, 0, rPicture.Length);
            string imgpath = "data:image/png;base64," + base64String;

            this.ErrMsg = "<IMAGE>" + imgpath + "</IMAGE>";//"Success";
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }

        return this.ErrMsg;
    }

    /// <summary>
    /// To fetch images in 10 different sizes for zoom
    /// <para>Return "multiple image path", if completed else throws error</para>
    /// </summary>
    /// <returns></returns>
    public string fetchMapwithZoomCommand()
    {
        try
        {
            string[] return_path = new string[10];
            int j = 150;
            for (int i = 0; i < 10; i++)
            {
                return_path[i] = mapSize("png", j, j);
                j += 20;
            }

            System.Text.StringBuilder path_as_strings = new System.Text.StringBuilder();

            path_as_strings.Append("<IMAGE>");
            for (int i = 0; i < return_path.Length; i++)
            {
                path_as_strings.Append("<LEVEL_" + i.ToString() + ">");
                path_as_strings.Append(return_path[i].ToString());
                path_as_strings.Append("</LEVEL_" + i.ToString() + ">");
            }
            path_as_strings.Append("</IMAGE>");

            this.ErrMsg = path_as_strings.ToString();
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }

        return this.ErrMsg;
    }

    /// <summary>
    /// To create a new image (map) for the specified width, height and format
    /// <para>Return "Image path", if completed else throws error</para>
    /// </summary>
    /// <param name="PmapFormat"></param>
    /// <param name="PmapHeight"></param>
    /// <param name="PmapWidth"></param>
    /// <returns></returns>
    protected string mapSize(string PmapFormat, int PmapHeight, int PmapWidth)
    {
        try
        {
            //Stream streamResponse;
            string path = HttpContext.Current.Request.MapPath(HttpContext.Current.Request.ApplicationPath) + @"\Modules\Common\Map\" + this.TmpTagId + "_" + PmapHeight.ToString() + "x" + PmapWidth + ".png";
            //string path = HttpContext.Current.Request.MapPath(HttpContext.Current.Request.ApplicationPath) + @"\Map\" + this.TmpTagId + "_" + PmapHeight.ToString() + "x" + PmapWidth + ".png";

            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/map/render?tagid=" + this.TmpTagId + "&format=" + PmapFormat + "&height=" + PmapHeight + "&width=" + PmapWidth;
            HttpWebRequest myRequest = (HttpWebRequest)WebRequest.Create(this.URL);
            myRequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse myHttpWebResponse = (HttpWebResponse)myRequest.GetResponse();
            this.streamResponse = myHttpWebResponse.GetResponseStream();
            System.Drawing.Bitmap image = new System.Drawing.Bitmap(this.streamResponse);// (memoryStream);
            if (File.Exists(path))
                File.Delete(path);
            image.Save(path, System.Drawing.Imaging.ImageFormat.Png);
            image.Dispose();

            this.ErrMsg =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + HttpContext.Current.Request.ApplicationPath + "/Modules/Common/Map/" + this.TmpTagId + "_" + PmapHeight.ToString() + "x" + PmapWidth + ".png"; this.ErrMsg =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + HttpContext.Current.Request.ApplicationPath + "/Modules/Common/Map/" + this.TmpTagId + "_" + PmapHeight.ToString() + "x" + PmapWidth + ".png";
            //this.ErrMsg =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + HttpContext.Current.Request.ApplicationPath + "/Map/" + this.TmpTagId + "_" + PmapHeight.ToString() + "x" + PmapWidth + ".png";
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }

    /// <summary>
    /// To fetch and store the tag position
    /// <para>Return "Success", if completed else throws error</para>
    /// </summary>
    /// <param name="PsecondsInterval"></param>
    /// <returns></returns>
    public string fetchPositionCommand()
    {
        try
        {
            this.xmlDataSet = new DataSet("TAGPOSITION");

            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/pos/taglist?tagid=" + this.TmpTagId + "&fields=all";
            //String url =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":8550/epe/pos/tagstream?tagid=" + this.TmpTagId;
            HttpWebRequest myRequest = (HttpWebRequest)WebRequest.Create(this.URL);
            myRequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse myHttpWebResponse = (HttpWebResponse)myRequest.GetResponse();
            this.streamResponse = myHttpWebResponse.GetResponseStream();
            this.streamReader = new StreamReader(this.streamResponse);
            this.xmlTxtReader = new XmlTextReader(this.streamReader);

            this.xmlDataSet.ReadXml(this.xmlTxtReader);

            //bulkCopy bcp;
            //bcp = new bulkCopy(xmlDataSet, "ZONEENTERED", "TMP_XML_POSITION");
            //this.ErrMsg = bcp.dsBulkCopy_fetchPosition();

            //bcp = new bulkCopy(xmlDataSet, "ZONEEXITED", "TMP_XML_POSITION");
            //this.ErrMsg = bcp.dsBulkCopy_fetchPosition();

            //bcp = new bulkCopy(xmlDataSet, "SCAN", "TMP_XML_POSITION");
            //this.ErrMsg = bcp.dsBulkCopy_fetchPosition();

            //this.ErrMsg = dsBulkCopy_fetchPosition(xmlDataSet, "ZONEENTERED", "TMP_XML_POSITION");
            //this.ErrMsg += dsBulkCopy_fetchPosition(xmlDataSet, "ZONEEXITED", "TMP_XML_POSITION");
            //this.ErrMsg += dsBulkCopy_fetchPosition(xmlDataSet, "SCAN", "TMP_XML_POSITION");

            this.ErrMsg = this.dsBulkCopy_fetchPosition(this.xmlDataSet, "TAG", "TMP_XML_POSITION");
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }

    /// <summary>
    /// To fetch details of all tags which are in the specified map
    /// <para>Return "Success", if completed else throws error</para>
    /// </summary>
    /// <returns></returns>
    public string fetchMapCluster()
    {
        try
        {
            this.xmlDataSet = new DataSet("CLUSTER");

            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/pos/taglist?mapid=" + this.TmpMapId + "&fields=all";
            //String url =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":8550/epe/pos/tagstream?mapid=" + this.TmpMapId;
            HttpWebRequest myRequest = (HttpWebRequest)WebRequest.Create(this.URL);
            myRequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse myHttpWebResponse = (HttpWebResponse)myRequest.GetResponse();
            this.streamResponse = myHttpWebResponse.GetResponseStream();
            this.streamReader = new StreamReader(this.streamResponse);
            this.xmlTxtReader = new XmlTextReader(this.streamReader);
            this.xmlDataSet.ReadXml(this.xmlTxtReader);

            this.ErrMsg = this.dsBulkCopy_fetchPosition(xmlDataSet, "TAG", "TMP_XML_POSITION");
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }


    /// <summary>
    /// To fetch the tags current battery level from the server
    /// <para>Return "Success", if completed else throws error</para>
    /// </summary>
    /// <returns></returns>
    public string fetchBatterylevelCommand()
    {
        try
        {
            this.xmlDataSet = new DataSet("BATTERY");

            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/pos/taglist?battery=0-100&fields=all";
            //this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":8550/epe/pos/tagstream/";
            HttpWebRequest httpBattery = (HttpWebRequest)WebRequest.Create(this.URL);
            httpBattery.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse httpBatteryResponse = (HttpWebResponse)httpBattery.GetResponse();
            this.streamResponse = httpBatteryResponse.GetResponseStream();
            this.streamReader = new StreamReader(this.streamResponse);
            this.xmlTxtReader = new XmlTextReader(this.streamReader);

            this.xmlDataSet.ReadXml(this.xmlTxtReader);

            this.ErrMsg = this.dsBulkCopy_fetchBatterylevel(this.xmlDataSet, "TAG", "TMP_XML_BATTERY");
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }

    /// <summary>
    /// To fetch the tag positions (similar to fetchPositionCommand() method) from the server
    /// <para>Return "Success", if completed else throws error</para>
    /// </summary>
    /// <returns></returns>
    public string fetchAllTagPosition()
    {
        try
        {
            dbClass dbDelete = new dbClass();
            dbDelete.recordDeleteInit("TMP_XML_PAR", "");
            //dbDelete.recordDelete();

            this.xmlDataSet = new DataSet("ALLTAG");
            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/pos/taglist?fields=all";
            HttpWebRequest httpRequest = (HttpWebRequest)WebRequest.Create(this.URL);
            httpRequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse httResponse = (HttpWebResponse)httpRequest.GetResponse();
            this.streamResponse = httResponse.GetResponseStream();
            this.streamReader = new StreamReader(this.streamResponse);
            this.xmlTxtReader = new XmlTextReader(this.streamReader);

            this.xmlDataSet.ReadXml(this.xmlTxtReader);

            this.ErrMsg = this.dsBulkCopy_fetchPosition(this.xmlDataSet, "TAG", "TMP_XML_PAR");
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }


    /// <summary>
    /// To fetch the floor map from the server
    /// <para>Return "Success", if completed else throws error</para>
    /// </summary>
    /// <returns></returns>
    public string fetchFloorMapCommand()
    {
        try
        {
            String floorName = "";

            dbClass dbSelect = new dbClass();
            dbSelect.recordSelectInit("FLOORMASTER", "FLOORNAME", "FLOORID = " + ((this.TmpMapId == 0) ? 1 : this.TmpMapId));
            floorName = dbSelect.recordSelect();

            string path = HttpContext.Current.Request.MapPath(HttpContext.Current.Request.ApplicationPath) + @"\Request\Modules\Common\Floor\" + floorName + ".png";
            if (!File.Exists(path))
            {
                int FloorId = Convert.ToInt32(DataAccess.FloorMaster(this.TmpMapId.ToString(), "", false, "GETMAPID").Rows[0]["MAPID"].ToString());
                this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/mod/mapview?mapid=" + FloorId + "&format=png";
                DigestHttpWebRequest req = new DigestHttpWebRequest("admin", "admin");
                HttpWebResponse webResponse = req.GetResponse(new Uri(string.Format(URL)));
                this.streamResponse = webResponse.GetResponseStream();
                System.Drawing.Bitmap image = new System.Drawing.Bitmap(this.streamResponse);// (memoryStream);
                if (File.Exists(path))
                    File.Delete(path);
                image.Save(path, System.Drawing.Imaging.ImageFormat.Png);
                image.Dispose();
            }
            this.ErrMsg =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + ConfigurationManager.AppSettings["AppPort"].ToString() + "/Request/Modules/Common/Floor/" + floorName + ".png";

        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }

    /// <summary>
    /// To fetch the floor and zone details from the server
    /// <para>Return "Success", if completed else throws error</para>
    /// </summary>
    /// <returns></returns>
    public string fetchFloorZoneCommand(XmlDocument xmlDocument)
    {
        try
        {
            this.xmlDataSet = new DataSet("ZONE");
            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/mod/modelbrowse";
            HttpWebRequest httpRequest = (HttpWebRequest)WebRequest.Create(this.URL);
            httpRequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse myResponse = (HttpWebResponse)httpRequest.GetResponse();
            this.streamResponse = myResponse.GetResponseStream();
            this.streamReader = new StreamReader(this.streamResponse);
            //this.xmlTxtReader = new XmlTextReader(this.streamReader);
            //this.xmlDataSet.ReadXml(this.xmlTxtReader);

            //this.ErrMsg = dsBulkCopy_fetchFloor(this.xmlDataSet, "MAP", "FLOORMASTER");
            //this.ErrMsg = dsBulkCopy_fetchZone(this.xmlDataSet, "ZONE", "ZONEMASTER");

            xmlDocument.Load(this.streamReader);

            this.ErrMsg = "Success";
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }

    /// <summary>
    /// To fetch all tag along with its details from the server, to store in TAGMASTER table
    /// <para>Return "Success", if completed else throws error</para>
    /// </summary>
    /// <param name="xmlDocument"></param>
    /// <returns></returns>
    public string fetchTagDetailCommand(XmlDocument xmlDocument)
    {
        try
        {
            this.xmlDataSet = new DataSet("TAG");
            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/pos/taglist?field=all";
            HttpWebRequest httpRequest = (HttpWebRequest)WebRequest.Create(this.URL);
            httpRequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse httpResponse = (HttpWebResponse)httpRequest.GetResponse();
            this.streamResponse = httpResponse.GetResponseStream();
            this.streamReader = new StreamReader(this.streamResponse);
            //this.xmlTxtReader = new XmlTextReader(this.streamReader);
            //this.xmlDataSet.ReadXml(this.xmlTxtReader);

            //PdataSet.ReadXml(this.xmlTxtReader);

            xmlDocument.Load(this.streamReader);

            this.ErrMsg = "Success";
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }

    /// <summary>
    /// To fetch all tag along with its details from the server [emergency events]
    /// <para>Return "Success", if completed else throws error</para>
    /// </summary>
    /// <returns></returns>
    //public string fetchEmergencyCommand(String PTimeDiff)
    public string fetchEmergencyCommand()
    {
        try
        {
            string path = HttpContext.Current.Request.MapPath(HttpContext.Current.Request.ApplicationPath) + @"\Modules\Common\Map\" + this.TmpTagId + "_210x210.png";
            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/map/render?tagid=" + this.TmpTagId + "&format=png&height=210&width=210";
            HttpWebRequest httprequest = (HttpWebRequest)WebRequest.Create(this.URL);
            httprequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse httpwebresponse = (HttpWebResponse)httprequest.GetResponse();
            this.streamResponse = httpwebresponse.GetResponseStream();
            System.Drawing.Bitmap image = new System.Drawing.Bitmap(this.streamResponse);
            if (File.Exists(path))
                File.Delete(path);
            image.Save(path, System.Drawing.Imaging.ImageFormat.Png);
            image.Dispose();

            string return_p = "<IMAGE>" +  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":8090/Modules/Common/Map/" + this.TmpTagId + "_210x210.png</IMAGE>";
            this.ErrMsg = return_p;
            //this.xmlDataSet = new DataSet("EMERGENCY");
            //this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/eve/historylist?since=" + PTimeDiff;
            //HttpWebRequest httpRequest = (HttpWebRequest)WebRequest.Create(this.URL);
            //httpRequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            //HttpWebResponse httResponse = (HttpWebResponse)httpRequest.GetResponse();
            //this.streamResponse = httResponse.GetResponseStream();
            //this.streamReader = new StreamReader(this.streamResponse);
            //this.xmlTxtReader = new XmlTextReader(this.streamReader);

            //this.xmlDataSet.ReadXml(this.xmlTxtReader);

            //this.ErrMsg = this.dsBulkCopy_fetchEmergency(this.xmlDataSet, "SCAN", "TMP_XML_EMERGENCY");
            //this.ErrMsg = "Success";
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }

    /// <summary>
    /// To send message to the DISPLAY TAGS
    /// </summary>
    /// <param name="PMessage"></param>
    /// <returns></returns>
    public string MessageCommand(String PMessage)
    {
        try
        {
            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/msg/tagsendmsg?tagid=" + this.TmpTagId + "&message=" + PMessage + "&messagetype=instant";
            HttpWebRequest httpRequest = (HttpWebRequest)WebRequest.Create(this.URL);
            httpRequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse httpResponse = (HttpWebResponse)httpRequest.GetResponse();
            this.streamResponse = httpResponse.GetResponseStream();
            //this.streamReader = new StreamReader(this.streamResponse);
            //this.xmlTxtReader = new XmlTextReader(this.streamReader);
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }

    /// <summary>
    /// To create rule in EPE
    /// <para>Return "Success", if completed else throws error</para>
    /// </summary>
    /// <param name="pRuleSettings">String of Input Parameteres</param>
    /// <param name="pReturnXml">EPE's Rule ID</param>
    /// <returns></returns>
    public string createRuleCommand(string pRuleSettings, XmlDocument pReturnXml)
    {
        XmlDocument tempDoc = new XmlDocument();
        try
        {
            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/eve/rulecreate?" + pRuleSettings;
            HttpWebRequest httpRequest = (HttpWebRequest)WebRequest.Create(this.URL);
            httpRequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse httpResponse = (HttpWebResponse)httpRequest.GetResponse();
            this.streamResponse = httpResponse.GetResponseStream();
            this.streamReader = new StreamReader(this.streamResponse);
            this.xmlTxtReader = new XmlTextReader(this.streamReader);

            tempDoc.Load(xmlTxtReader);

            pReturnXml = tempDoc;
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }

    /// <summary>
    /// To activate the de-activated rule.
    /// <para>Return "Success", if completed else throws error</para>
    /// </summary>
    /// <param name="pRuleId">EPE's Rule ID</param>
    /// <returns></returns>
    public string activateRuleCommand(int pRuleId)
    {
        try
        {
            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/eve/ruleenable?ruleid=" + pRuleId;
            HttpWebRequest httpRequest = (HttpWebRequest)WebRequest.Create(this.URL);
            httpRequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse httpResponse = (HttpWebResponse)httpRequest.GetResponse();
            this.streamResponse = httpResponse.GetResponseStream();
            //this.streamReader = new StreamReader(this.streamResponse);

            this.ErrMsg = "Sucess";
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }

    /// <summary>
    /// To de-activate the active rule
    /// <para>Return "Success", if completed else throws error</para>
    /// </summary>
    /// <param name="pRuleId">EPE's Rule ID</param>
    /// <returns></returns>
    public string deactivateRuleCommand(int pRuleId)
    {
        try
        {
            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/eve/ruledisable?ruleid=" + pRuleId;
            HttpWebRequest httpRequest = (HttpWebRequest)WebRequest.Create(this.URL);
            httpRequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse httpResponse = (HttpWebResponse)httpRequest.GetResponse();
            this.streamResponse = httpResponse.GetResponseStream();
            //this.streamReader = new StreamReader(this.streamResponse);

            this.ErrMsg = "Success";
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }

    /// <summary>
    /// To delete rule permanently from Server(s)
    /// <para>Return "Success", if completed else throws error</para>
    /// </summary>
    /// <param name="pRuleId">EPE's Rule ID</param>
    /// <returns></returns>
    /// 
    public string fetchMapCommand(string mpath, string lpath, string TagID, string Curtim, string x, string y, string flr)
    {
        try
        {
            Image img = Image.FromFile(mpath + flr);
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

                g.DrawImage(Image.FromFile(mpath + "porter1.png"), Convert.ToInt32(x) - 26, Convert.ToInt32(y) - 27, 60, 60);


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
    public string deleteRuleCommand(int pRuleId)
    {
        try
        {
            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/eve/ruledelete=" + pRuleId;
            HttpWebRequest httpRequest = (HttpWebRequest)WebRequest.Create(this.URL);
            httpRequest.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse httpResponse = (HttpWebResponse)httpRequest.GetResponse();
            this.streamResponse = httpResponse.GetResponseStream();
            //this.streamReader = new StreamReader(this.streamResponse);

            this.URL =  ConfigurationManager.AppSettings["HTTP"].ToString() +"://" +this.Server + ":" + this.Port + "/epe/eve/rulepurge=" + pRuleId;
            HttpWebRequest httpRequest1 = (HttpWebRequest)WebRequest.Create(this.URL);
            httpRequest1.Credentials = new NetworkCredential(this.EPEId, this.EPEPwd);
            HttpWebResponse httpResponse1 = (HttpWebResponse)httpRequest1.GetResponse();
            this.streamResponse = httpResponse1.GetResponseStream();
            //this.streamReader = new StreamReader(this.streamResponse);

            this.ErrMsg = "Success";
        }
        catch (Exception Excep)
        {
            this.ErrMsg = Excep.Message;
            throw;
        }
        return this.ErrMsg;
    }
}