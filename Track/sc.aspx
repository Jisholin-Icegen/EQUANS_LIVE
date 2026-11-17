<%@ Page Language="C#" AutoEventWireup="true" CodeFile="sc.aspx.cs" Inherits="Track_sc" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script runat="server">

        void Button1_Click (object sender, EventArgs e)
        {
            Response.Write("hai1");

        }

</script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="Button1" runat="server" Text="Button"  />
            <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
            <asp:Button ID="btn" runat="server" 
        Text="GET" onclick="btnresGet_Click" />      <br />  <br />
          <asp:FileUpload ID="ImageUpload" runat="server" CssClass="ButtonOut" TabIndex="2" Width="200px" />
    
    <asp:GridView ID="GridView2" runat="server">
    </asp:GridView>
        </div>
    </form>
</body>
</html>
