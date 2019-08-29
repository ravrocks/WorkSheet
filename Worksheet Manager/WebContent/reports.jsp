<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Driver" %>

<%

String userName = null, userPsno=null ,showMonth=null ;
Cookie[] cookies = request.getCookies();
if(cookies !=null){
for(Cookie cookie : cookies){
    if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
    if(cookie.getName().equals("timesheet_psno")) userPsno = cookie.getValue();
    if(cookie.getName().equals("show_month")) showMonth = cookie.getValue();
}
}
if(userName == null) response.sendRedirect("home.jsp");


String driver = "com.mysql.jdbc.Driver";
String connectionUrl = "jdbc:mysql://localhost:3306/";
String database = "lnttic";
String userid = "root";
String password = "root";
try {
Class.forName(driver);
} catch (ClassNotFoundException e) {
e.printStackTrace();
}
Connection connection = null;
Statement statement = null;
ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
<style>
html, body {
  height: 100%;
  padding-top: 15px;
}

</style>
<meta charset="ISO-8859-1">
<title>Reports</title>
<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.4/jspdf.min.js"></script>

</head>
<body>
<% String name = request.getParameter("name"); %>
<% String psno = request.getParameter("psno"); %>

<!-- <div id="editor"></div>
<button id="cmd">Save</button>-->
<div class="container" id="content">
 <div align="center" style="color:#1c87c9; font-size:20px;font-weight: 500;font-family: 'Raleway';margin-bottom: -20px"><% out.println(name+"&nbsp&nbsp("+psno+")"); %></div><br><br>
<table class="table table-hover table-bordered">
<thead>
<tr>
<th scope="col">Project type</th>
<th scope="col">Project</th>
<th scope="col">Activity group</th>
<th scope="col">Activity</th>
<th scope="col">Hrs</th>
<th scope="col">Details</th>
<th scope="col">Date</th>
</tr>
</thead>
<%
try{

connection = DriverManager.getConnection(connectionUrl+database, userid, password);
statement=connection.createStatement();
String sql ="select projecttype,project,activitygroup,activity,hrs,details,date from details1 where month="+showMonth+" and psno=? order by projecttype,date asc;";
//rs = statement.executeQuery(sql);
PreparedStatement ps = connection.prepareStatement(sql); 
ps.setString(1, psno);
rs=ps.executeQuery();
while(rs.next()){
%>
<tbody>
<tr>
<td><%=rs.getString("projecttype") %></td>
<td><%=rs.getString("project") %></td>
<td><%=rs.getString("activitygroup") %></td>
<td><%=rs.getString("activity") %></td>
<td><%=rs.getString("hrs") %></td>
<td><%=rs.getString("details") %></td>
<td><%=rs.getString("date") %></td>
</tr>
</tbody>
<%
}
connection.close();
} catch (Exception e) {
e.printStackTrace();
}
%>
</table>
</div>
</body>
<script>
var doc = new jsPDF({
	  orientation: 'landscape'
	});
var specialElementHandlers = {
    '#editor': function (element, renderer) {
        return true;
    }
};

$('#cmd').click(function () {
    doc.fromHTML($('#content').html(), 2, 2, {
        'width': 500,
            'elementHandlers': specialElementHandlers
    });
    doc.save('report.pdf');
});

</script>
</html>