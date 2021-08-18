<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.DateFormatSymbols" %>
<%@ page import="com.google.common.primitives.Ints" %>
<%@page import="com.works.getConnection" %>

<%
    String userName = null,userPsno=null;
    Cookie[] cookies = request.getCookies();
    if(cookies !=null){
    for(Cookie cookie : cookies){
	if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
        if(cookie.getName().equals("timesheet_psno")) userPsno = cookie.getValue();        
    }
    }
    if(userName == null || userPsno==null) 
    	{
    	response.sendRedirect("home.jsp");
    	return;
    	}
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
<div> Filter by Month&nbsp;&nbsp;<input id="search" type="text" placeholder="Search.."><br><br></div>

<table class="table table-hover table-bordered" id="table">
<thead>
<tr>
<th scope="col">Name</th>
<th scope="col">Month</th>
<th scope="col">Year</th>
<th scope="col">Status</th>
<th scope="col"></th>
</tr>
</thead>
<%
try{
connection = new getConnection().getConnection();
statement=connection.createStatement();
String sql ="select name,psno,month,status,year from userstatus where psno='"+Integer.parseInt(userPsno)+"' and name like '"+userName+"' order by userstatus.year DESC,userstatus.status DESC,userstatus.month;";
rs = statement.executeQuery(sql);
while(rs.next()){
%>
<tbody>
<tr>
<td><%=userName %></td>
<td>
	<%
	Integer mn=Ints.tryParse(rs.getString("month"));
	if(mn!=null)
		{
		String monthString = new DateFormatSymbols().getMonths()[mn-1];
		out.println(monthString);
		}
	else
	   out.println(rs.getString("month"));
	%>		
</td>
<td><%=rs.getString("year") %></td>
<td><%=rs.getString("status") %></td>
<td>
<%
if(rs.getString("status").equals("Submitted"))
{
	%>
	<a onclick="basicPopup(this.href);return false" href="print.jsp?for_month=<%=rs.getString("month")%>&for_year=<%=rs.getString("year")%>"><span class="glyphicon">&#xe105;</span> View</a>&nbsp;&nbsp;	
	<%
}
else
{
	%>
	<a onclick="sendEdit(<%=rs.getString("month")%>,<%=rs.getString("year")%>)" href="#"><span class="glyphicon">&#xe065;</span> Edit</a>
	<%
}
%>
</td>
</tr>
</tbody>
<%
}
rs.close();
statement.close();
connection.close();
} 
catch (Exception e) {
e.printStackTrace();
}
%>
</table>
</div>

<script>
var monthAA = new Array("January","February","March","April","May","June","July","August","September","October","November","December");

function sendEdit(month,yearx)
{
	document.cookie = "timesheet_load_month="+monthAA[month-1];
	document.cookie = "timesheet_load_year="+yearx;
	window.location="userform_personal.jsp";
}
</script>
</body>

</html>