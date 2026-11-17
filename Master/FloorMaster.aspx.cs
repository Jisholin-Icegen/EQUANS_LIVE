using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Web.UI.HtmlControls;

public partial class Master_FloorMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
            BindData();
    }
    private void BindData()
    {
        try
        {
            //   ((HtmlGenericControl)Master.FindControl("HeaderText")).InnerHtml = "ADMIN :: FLOOR MASTER";
            RadGrid1.DataSource = DataAccess.FloorMaster(string.Empty, string.Empty, false, "GET");
            RadGrid1.DataBind();

        }
        catch (Exception ex1) { Session["Errors"] = ex1.Message + "900001"; }
    }
    protected void RadGrid1_ItemCommand(object source, Telerik.Web.UI.GridCommandEventArgs e)
    {
        try
        {
            if (e.CommandName == RadGrid.InitInsertCommandName) //"Add new" button clicked
            {
                RadGrid1.MasterTableView.ClearEditItems();
                BindData();
                ((GridEditCommandColumn)RadGrid1.MasterTableView.GetColumn("EditCommandColumn")).Visible = false;
            }
            else if (e.CommandName == RadGrid.RebindGridCommandName && e.Item.OwnerTableView.IsItemInserted)
                e.Canceled = true;
            else if (e.CommandName == "Edit" && e.Item.OwnerTableView.Name == "MasterGrid")
            {
                RadGrid1.MasterTableView.IsItemInserted = false;
                BindData();
            }

            else if (e.CommandName == "Edit" || e.CommandName == "Cancel" || e.CommandName == "Page" || e.CommandName == "Sort")
            {
                BindData();
                ((GridEditCommandColumn)RadGrid1.MasterTableView.GetColumn("EditCommandColumn")).Visible = true;
            }
            else if (e.CommandName == "ChangePageSize")
                BindData();
        }
        catch (Exception ex1) { Session["Errors"] = ex1.Message + "900001"; }
    }

    protected void RadGrid1_InsertCommand(object source, Telerik.Web.UI.GridCommandEventArgs e)
    {
        try
        {
            GridEditFormInsertItem insertItem = (GridEditFormInsertItem)e.Item;
            bool result = false, IsActive = ((System.Web.UI.WebControls.CheckBox)insertItem.FindControl("ChkActive")).Checked;
            string Floorname = ((System.Web.UI.WebControls.TextBox)insertItem.FindControl("txtFloorName")).Text.ToUpper();
            result = (DataAccess.FloorMaster(string.Empty, Floorname, IsActive, "INSERT").Rows[0]["RESULT"].ToString() == "TRUE");
            if (result == false)
                LBLResult.Text = "FLOOR ALREADY EXISTS.";
            else
                LBLResult.Text = "FLOOR DETAILS ADDED SUCCESSFULLY.";
            BindData();
            ((GridEditCommandColumn)RadGrid1.MasterTableView.GetColumn("EditCommandColumn")).Visible = true;
            mpDone.Show();


        }
        catch (Exception ex1) { Session["Errors"] = ex1.Message + "900001"; };
    }

    protected void RadGrid1_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
    {
        try
        {
            if (e.Item.ItemIndex == -1)//important
            {
                if (e.Item.ItemType == Telerik.Web.UI.GridItemType.EditFormItem)
                {
                    ((RadButton)e.Item.FindControl("Btndelete")).Visible = false;
                    ((System.Web.UI.WebControls.CheckBox)e.Item.FindControl("ChkActive")).Checked = true;
                    ((System.Web.UI.WebControls.CheckBox)e.Item.FindControl("ChkActive")).Enabled = false;
                    ((RadButton)e.Item.FindControl("btnUpdate")).Text = "SAVE";
                }
            }
            if (e.Item is GridEditableItem && e.Item.IsInEditMode && (!e.Item.OwnerTableView.IsItemInserted) && (e.Item.OwnerTableView.Name == "MasterGrid"))
            {
                GridEditableItem item = (GridEditableItem)e.Item;
                string FloorID = (item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FLOORID"]).ToString().ToUpper(),
                       FloorName = (item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FLOORNAME"]).ToString().ToUpper(),
                       FloorOrder = (item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FLOORORDER"]).ToString().ToUpper(); ;
                DropDownList drpFloorOrder = (DropDownList)item.FindControl("DrpFloorOrder"); BindFloorOrder(drpFloorOrder, FloorID);
                ((RadButton)item.FindControl("Btndelete")).Visible = false;
                string IsActive = (e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ISACTIVE"]).ToString().ToUpper();
                if (IsActive == "TRUE")
                    ((System.Web.UI.WebControls.CheckBox)item.FindControl("ChkActive")).Checked = true;
                else
                    ((System.Web.UI.WebControls.CheckBox)item.FindControl("ChkActive")).Checked = false;
                ((TextBox)item.FindControl("txtFloorName")).Text = FloorName; drpFloorOrder.SelectedValue = (FloorOrder == "NOT-SET") ? "0" : FloorOrder;
            }
            if (e.Item is GridDataItem)
            {
                GridDataItem dataItem = (GridDataItem)e.Item;
                (dataItem["ISACTIVE"].FindControl("ChkActive") as CheckBox).Checked = (bool)(e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["ISACTIVE"]);
            }
        }
        catch (Exception ex1) { Session["Errors"] = ex1.Message + "900001"; }

    }


    private void BindFloorOrder(DropDownList drpFloor, string FloorID)
    {
        drpFloor.DataSource = DataAccess.GetRecords("SP_GETFLOORMASTER", "@FLOORID", FloorID);
        drpFloor.DataTextField = "TEXT";
        drpFloor.DataValueField = "VALUE";
        drpFloor.DataBind();
    }
    protected void RadGrid1_UpdateCommand(object source, Telerik.Web.UI.GridCommandEventArgs e)
    {
        if (e.CommandName == "Update" && e.Item.OwnerTableView.Name == "MasterGrid")
        {
            try
            {
                string Floorname = ((System.Web.UI.WebControls.TextBox)e.Item.FindControl("txtFloorName")).Text.ToUpper(),
                    id = (e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FLOORID"]).ToString(),
                    FloorOrder = ((System.Web.UI.WebControls.DropDownList)e.Item.FindControl("DrpFloorOrder")).SelectedValue.ToString(); bool result = false,
                       IsActive = ((System.Web.UI.WebControls.CheckBox)e.Item.FindControl("ChkActive")).Checked;
                result = (DataAccess.FloorMasterUpdate(id, Floorname, ((FloorOrder == "0") ? "" : FloorOrder), IsActive, "UPDATE").Rows[0]["RESULT"].ToString() == "TRUE");
                if (result == false)
                    LBLResult.Text = "FLOOR  ALREADY EXISTS.";
                else
                    LBLResult.Text = "FLOOR DETAILS UPDATED SUCCESSFULLY.";
                BindData();
                mpDone.Show();
            }
            catch (Exception ex1) { Session["Errors"] = ex1.Message + "900001"; }
        }
    }


    protected void RadGrid1_DeleteCommand(object source, Telerik.Web.UI.GridCommandEventArgs e)
    {
        try
        {
            string id = (e.Item.OwnerTableView.DataKeyValues[e.Item.ItemIndex]["FLOORID"]).ToString(); bool result = false;
            result = (DataAccess.FloorMaster(id, string.Empty, false, "DELETE").Rows[0]["RESULT"].ToString() == "TRUE");
            if (result == false)
                LBLResult.Text = "FLOOR CAN NOT BE DELETED.";
            else
                LBLResult.Text = "FLOOR REMOVED SUCCESSFULLY.";
            BindData();
            RadGrid1.MasterTableView.ClearEditItems();
            mpDone.Show();
        }
        catch (Exception ex1) { Session["Errors"] = ex1.Message + "900001"; }
    }
}