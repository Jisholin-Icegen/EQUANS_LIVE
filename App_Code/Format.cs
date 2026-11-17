using System;
using System.Data;
//using System.Configuration;
//using System.Linq;
//using System.Web;
//using System.Web.Security;
//using System.Web.UI;
//using System.Web.UI.HtmlControls;
//using System.Web.UI.WebControls;
//using System.Web.UI.WebControls.WebParts;
//using System.Xml.Linq;

using System.Xml;

/// <summary>
/// Format class, to format the xml returned by SQL Server and sent to the UI.
/// Nanda Kumar Thanigaivelan
/// April 15th, 2011
/// nandakumar(at)icegen.net
/// </summary>
public class Format
{
    bool result;
    int status;
    string message;

    XmlDocument xmlDoc;
    XmlDocument xmlformat;

    /// <summary>
    /// Default Constructor
    /// </summary>
	public Format()
	{
        result = false;
        status = 0;
        message = "";

        xmlDoc = new XmlDocument();
        xmlformat = new XmlDocument();
	}

    // GENERAL XML FORMATTING METHODS



    //TYPE I
    //FUNCTIONS FOR SINGLE CHILD NODE CONTENT

    /// <summary>
    /// Format the XML by adding header, status then return the formatted xml
    /// <para>Return XmlDocument, on success else throws exception</para>
    /// </summary>
    /// <param name="PxmlDoc"></param>
    /// <returns></returns>
    public XmlDocument AppSuccess(XmlDocument PxmlDoc)
    {
        try
        {
            result = true;
            if (PxmlDoc.DocumentElement == null)
            {
                status = Convert.ToInt32(Masters.Messages.NODATA);
                message = Convert.ToString(Masters.Messages.NODATA);
            }
            else
            {
                message = Convert.ToString(Masters.Messages.SUCESS);
                status = Convert.ToInt32(Masters.Messages.SUCESS);
            }
            xmlformat = Masters.Xmlbuilder(PxmlDoc, status, message, result);
            //Response.Write(xmlformat.InnerXml);
        }
        catch (Exception)
        {
            throw;
        }
        return xmlformat;
    }

    /// <summary>
    /// Construct the XML, if given querystring is invalid
    /// <para>Return XmlDocument, on success else throws exception</para>
    /// </summary>
    /// <returns></returns>
    public XmlDocument invalidQueryString()
    {
        try
        {
            result = false;
            status = Convert.ToInt32(Masters.Messages.INVALIDQUERYSTRING);
            message = Convert.ToString(Masters.Messages.INVALIDQUERYSTRING);
            xmlformat = Masters.Xmlbuilder(xmlDoc, status, message, result);
            //Response.Write(xmlformat.InnerXml);
            return xmlformat;
        }
        catch (Exception)
        {
            throw;
        }
    }

    /// <summary>
    /// Construct the XML, if given login details are invalid
    /// <para>Return XmlDocument, on success else throws exception</para>
    /// </summary>
    /// <returns></returns>
    public XmlDocument invalidLogIn()
    {
        try
        {
            result = false;
            status = Convert.ToInt32(Masters.Messages.INVALIDUSER);
            message = Convert.ToString(Masters.Messages.INVALIDUSER);
            xmlformat = Masters.Xmlbuilder(xmlDoc, status, message, result);
            //Response.Write(xmlformat.InnerXml);
            return xmlformat;
        }
        catch (Exception)
        {
            throw;
        }
    }

    /// <summary>
    /// Construct the XML, if exception arises while execution
    /// </summary>
    /// <param name="PerrMessage"></param>
    /// <returns></returns>
    public XmlDocument AppError(string PerrMessage)
    {
        //LogApplicationError errLog = new LogApplicationError(moduleId, status.ToString(), PerrMessage);
        //errLog.logApplicationErrorInsert();

        result = false;
        status = Convert.ToInt32(Masters.Messages.ERROR);
        message = PerrMessage;
        xmlformat = Masters.Xmlbuilder(xmlDoc, status, message, result);
        //Response.Write(xmlformat.InnerXml);
        return xmlformat;
    }

    /// <summary>
    /// Construct the XML, if desired tasks failed due to vaildation
    /// </summary>
    /// <param name="PFailMessage"></param>
    /// <returns></returns>
    public XmlDocument AppFailure(string PFailMessage)
    {
        //LogApplicationError errLog = new LogApplicationError(moduleId, status.ToString(), PerrMessage);
        //errLog.logApplicationErrorInsert();

        result = false;
        status = Convert.ToInt32(Masters.Messages.FAILURE);
        message = PFailMessage;
        xmlformat = Masters.Xmlbuilder(xmlDoc, status, message, result);
        //Response.Write(xmlformat.InnerXml);
        return xmlformat;
    }


    //TYPE II
    //METHODS FOR MULTIPLE CHILD NODES FOR CONTENT

    /// <summary>
    /// To construct the response xml header 
    /// </summary>
    /// <param name="status"></param>
    /// <param name="message"></param>
    /// <returns></returns>
    public string xmlHeader(int status, string message)
    {
        System.Text.StringBuilder strings = new System.Text.StringBuilder();

        strings.Append("<DATA>");
        strings.Append("<HEADER>");
        strings.Append("<STATUS>" + status + "</STATUS>");
        strings.Append("<MESSAGE>" + message + "</MESSAGE>");
        strings.Append("</HEADER>");

        return strings.ToString();
    }

    /// <summary>
    /// Opens the xml content node
    /// </summary>
    /// <returns></returns>
    public string xmlContentHead()
    {
        return "<CONTENT>";
    }

    /// <summary>
    /// Closes the xml content node
    /// </summary>
    /// <returns></returns>
    public string xmlContentFooter()
    {
        return "</CONTENT>";
    }

    /// <summary>
    /// Closes the entire xml
    /// </summary>
    /// <returns></returns>
    public string xmlFooter()
    {
        return "</DATA>";
    }

    /// <summary>
    /// Test and return the xml content
    /// </summary>
    /// <param name="_doc"></param>
    /// <returns></returns>
    public string xmlContent(XmlDocument _doc)
    {
        string strings = "";

        if (_doc.DocumentElement != null)
        {
            strings = _doc.InnerXml;
        }
        return strings;
    }
}
