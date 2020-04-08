<%@page import="com.works.getConnection"%>
<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String userName = null,userPsno=null, showMonth=null;
    Cookie[] cookies = request.getCookies();
    if(cookies !=null){
    for(Cookie cookie : cookies){
	if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
        if(cookie.getName().equals("timesheet_psno")) userPsno = cookie.getValue();
        if(cookie.getName().equals("show_month")) showMonth = cookie.getValue();        
    }
    }
    if(userName == null) response.sendRedirect("home.jsp");

Connection connection = null;
Statement statement = null;
ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Time Sheet</title>
<style >

html, body {
  height: 100%;
}

body {
    padding-top: 30px;
}

div.k{
	margin-right:30px;
	position:relative;
}
</style>
<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>

<script>
$(document).ready(function(){
	  $("#search").on("keyup", function() {
	    var value = $(this).val().toLowerCase();
	    $("#table tr").filter(function() {
	      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
	    });
	  });
	});

//JavaScript popup window function
	function basicPopup(url) {
popupWindow = window.open(url,'popUpWindow','height=600,width=600,left=50,top=50,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no, status=yes');
	}

</script>
</head>
<body>
<div class="container" > 
<div> Filter by Name or PS no.&nbsp;&nbsp;<input id="search" type="text" placeholder="Search.."><br><br></div>
<div>
<table class="table table-hover table-bordered" id="table">
<thead>
<tr>
<th scope="col">Name</th>
<th scope="col">PSno</th>
<th scope="col">Details</th>
</tr>
</thead>
<%
try{
connection = new getConnection().getConnection();
statement=connection.createStatement();
int show_month;
String mx=showMonth;
if(mx==null)
show_month=Calendar.getInstance().get(Calendar.MONTH)+1;
else    
show_month=Integer.parseInt(mx);

String sql ="select distinct userstatus.name, details.psno from userstatus, details  where userstatus.psno = details.psno and userstatus.month="+show_month+" and userstatus.status like 'Submitted';";
rs = statement.executeQuery(sql);
while(rs.next()){
%>
<tbody>
<tr>
<td><%=rs.getString("name") %></td>
<td><%=rs.getString("psno") %></td>
<td>
<a onclick="basicPopup(this.href);return false" href="reports.jsp?psno=<%=rs.getString("psno")%>&name=<%=rs.getString("name")%>">Detailed Report</a>&nbsp;&nbsp;
<a onclick="basicPopup(this.href);return false" href="reports1.jsp?psno=<%=rs.getString("psno")%>&name=<%=rs.getString("name")%>">Summary</a>&nbsp;&nbsp;
<a onclick="basicPopup(this.href);return false" href="reports2.jsp?psno=<%=rs.getString("psno")%>&name=<%=rs.getString("name")%>">Project Report</a>
</td>
</tr>
</tbody>
<%
	}
	connection.close();
	statement.close();
	rs.close();
} 
catch (Exception e) {
	//System.out.println("In supervisor");
	e.printStackTrace();
}
%>
</table>
</div>
</div>
</body>

</html>