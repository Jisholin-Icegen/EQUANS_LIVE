function Bulk() {
    var leftVal = (screen.width - ((screen.width * 40) / 100)) / 2;
    var topVal = (screen.height - ((screen.height * 70) / 100)) / 2;
    window.onload =
        function () {

            window.opener.document.body.disabled = true;
        }


    window.open("../admin/bulk.aspx", 'old', 'width=800, height=600, left=' + leftVal + ',top=' + topVal + ',toolbar=no,location=no,directories=no,status=no,resizable=no');
}