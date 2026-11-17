using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Text;
using System.Xml;


/// <summary>
/// Summary description for Master
/// </summary>
public class Masters
{
    public Masters()
    {
        //
        // TODO: Add constructor logic here
        //
    }
   
    public int PfID { get; set; }
    public string PName { get; set; }
    public string PCode { get; set; }
    public int PFWaitTime { get; set; }
    public int PFProcessTime { get; set; }
    public int PDispstatus { get; set; }
    public DateTime PPDate { get; set; }
    public int PUserID { get; set; }
    public int PFacilityID { get; set; }
    public string MHCID { get; set; }
    public long PPackageID { get; set; }
    public long PBatchID { get; set; }
    public string PAllocation { get; set; }
    public int PID { get; set; }
    public MasterTable type { get; set; }
    public string MacID { get; set; }
    public Procedure ProcedureName { get; set; }
    public int BatchID { get; set; }
    public SelectType Selecttype { get; set; }
    public Outputtype OutputType { get; set; }
    public int PConfigtype { get; set; }
    public int ZoneID { get; set; }
    public int Astatus { get; set; }
    public int AScount { get; set; }
    public string PRulename { get; set; }
    public DateTime PAllocationTime { get; set; }
    public int PAllocID { get; set; }
    public int PBuildid { get; set; }
    public int PFloorid{ get; set; }


    public enum MasterTable
    {
        FACILITYMASTER,
        PACKAGEMASTER,
        PACKAGEDETAIL,
        MAPMASTER,
        FACILITYPREREQUISITEMASTER,
        PATIENTMASTER,
        ROOMMASTER,
        USERMASTER,
        BATCHRULECONFIGURATIONMASTER,
        TAGALLOCATIONMASTER,
        ZONEMASTER,
        ZONEDETAIL,
        PROCESSRULECONFIGURATIONMASTER,
        BUILDINGMASTER,
        FLOORMASTER

    }
    public enum ProcedureForMasterSelect
    {
        SP_FACILITYDETAIL_SLCT,
        SP_PACKAGEDETAIL_SLCT,
        SP_PACKAGEWISE_FACILITY_SLCT,
        SP_BUILDINGMASTER_SLCT, 
        SP_FACILITYTYPEMASTER_SLCT,
        SP_ROOMDETAIL_SLCT,
        SP_FLOORMASTER_SLCT,
        SP_ZONEMASTER_SLCT,
        SP_ROOMMASTER_SLCT

    }

    public enum Procedure
    {
        FACILITYMASTERINSERT,
        FACILITYMASTERUPDATE,
        PACKAGEMASTERINSERT,
        PACKAGEMASTERUPDATE,
        PACKAGEDETAILINSERT,
        PACKAGEDETAILUPDATE,
        MAPMASTERINSERT,
        MAPMASTERUPDATE,
        FACILITYPREREQUISITEMASTERINSERT,
        FACILITYPREREQUISITEMASTERUPDATE,
        PATIENTMASTERINSERT,
        PATIENTMASTERUPDATE,
        ROOMMASTERINSERT,
        ROOMMASTERUPDATE,
        USERMASTERINSERT,
        USERMASTERUPDATE,
        BATCHRULECONFIGURATIONMASTERINSERT,
        BATCHRULECONFIGURATIONMASTERUPDATE,
        TAGALLOCATIONMASTERINSERT,
        TAGALLOCATIONMASTERUPDATE,
        ZONEMASTERINSERT,
        ZONEMASTERUPDATE,
        ZONEDETAILINSERT,
        ZONEDETAILUPDATE,
        TABLEMASTERINSERT,
        TABLEMASTERUPDATE,
        PROCEDUREMASTERINSERT,
        PROCEDUREMASTERUPDATE,
        PROCESSRULECONFIGURATIONMASTERINSERT,
        PROCESSRULECONFIGURATIONMASTERUPDATE,
        TAGLIVEstatus,
        SP_FACILITYMASTER_INSRT,
SP_FACILITYMASTER_UPDT,
SP_PACKAGEMASTER_INSRT,
SP_PACKAGEMASTER_UPDT,
SP_PACKAGEDETAIL_INSRT,
SP_PACKAGEDETAIL_UPDT,
SP_MAPMASTER_INSRT,
SP_MAPMASTER_UPDT,
SP_FACILITYPREREQUISITEMASTER_INSRT,
SP_FACILITYPREREQUISITEMASTER_UPDT,
SP_PATIENTMASTER_INSRT,
SP_PATIENTMASTER_UPDT,
SP_ROOMMASTER_INSRT,
SP_ROOMMASTER_UPDT,
SP_USERMASTER_INSRT,
SP_USERMASTER_UPDT,
SP_BATCHRULECONFIGURATIONMASTER_INSRT,
SP_BATCHRULECONFIGURATIONMASTER_UPDT,
SP_TAGALLOCATIONMASTER_INSRT,
SP_TAGALLOCATIONMASTER_UPDT,
SP_ZONEMASTER_INSRT,
SP_ZONEMASTER_UPDT,
SP_ZONEDETAIL_INSRT,
SP_ZONEDETAIL_UPDT,
SP_TABLEMASTER_INSRT,
SP_TABLEMASTER_UPDT,
SP_PROCEDUREMASTER_INSRT,
SP_PROCEDUREMASTER_UPDT,
SP_PROCESSRULECONFIGURATIONMASTER_INSRT,
SP_PROCESSRULECONFIGURATIONMASTER_UPDT,
SP_PACKAGEDETAIL_BULK_INSRT, 
  SP_BUILDINGMASTER_INSRT,
  SP_FLOORMASTER_INSRT,
  SP_BUILDMASTER_UPDT,
  SP_FLOORMASTER_UPDT


    }

    public enum SelectType
    {
        FACILITY,
        FACILITYNAME,
        PACKAGE,
        PACKAGENAME,
        ROOM,
        MAP,
        BATCH,
        BATCHNAME,
        PFID


    }
    public enum Outputtype
    {
        XML,
        JSON
    }
    public enum Messages
    {
        SUCESS,
        NODATA,
        FAILURE,
        INVALIDQUERYSTRING,
        ERROR,
        INVALIDREPORTREQUEST,
        INVALIDUSER
    }

    public static XmlDocument Xmlbuilder(XmlDocument _doc, int status, string message,bool _result)
    {
     
        XmlDocument doc = new XmlDocument();
        StringBuilder strings = new StringBuilder();
    
        
        strings.Append("<DATA>");
        strings.Append("<HEADER>");
        strings.Append("<STATUS>" + status + "</STATUS>");
        strings.Append("<MESSAGE>" + message + "</MESSAGE>");
        strings.Append("</HEADER>");

        if (status == 0 && _doc.DocumentElement != null)
        {
            strings.Append("<CONTENT>");
            strings.Append(_doc.InnerXml);
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
    public static XmlDocument JsonFormat(XmlDocument _doc, int status, string message)
    {
        XmlDocument doc = new XmlDocument();
        StringBuilder strings = new StringBuilder();
        strings.Append("<DATA>");
        strings.Append("<HEADER>");
        strings.Append("<STATUS>" + status + "</STATUS>");
        strings.Append("<MESSAGE>" + message + "</MESSAGE>");
        strings.Append("</HEADER>");

        if (status == 0)
        {
            strings.Append("<CONTENT>");
            strings.Append(_doc.InnerXml);
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

    public static XmlDocument XmlbuilderfromString(string _doc, int status, string message, bool _result)
    {

        XmlDocument doc = new XmlDocument();
        StringBuilder strings = new StringBuilder();


        strings.Append("<DATA>");
        strings.Append("<HEADER>");
        strings.Append("<STATUS>" + status + "</STATUS>");
        strings.Append("<MESSAGE>" + message + "</MESSAGE>");
        strings.Append("</HEADER>");

        if (status == 0 && _doc.Length > 0)
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
