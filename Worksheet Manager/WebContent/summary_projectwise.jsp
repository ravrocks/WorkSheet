<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Driver" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ListIterator"%>
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
List<String> list = new ArrayList<String>();
try {
Class.forName(driver);
} catch (ClassNotFoundException e) {
e.printStackTrace();
}
Connection connection = null;
Statement statement = null;
ResultSet rs = null;
ResultSet rs1 = null; 
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
</head>
<body>
<% String projecttype = request.getParameter("projecttype"); %>
<% String project = request.getParameter("project"); %>
<div class="container" id="content">
<div align="center" style="color:#1c87c9; font-size:20px;">Project Type:<% out.println(projecttype); %></div><br>
<div align="center" style="color:#1c87c9; font-size:17px; font-style:normal; font-family: sans-serif;"><% out.println(project); %></div><br><br>
<table class="table table-hover table-bordered" id="tab">
<thead>
<tr>
<th scope="col">Activity group</th>
<th scope="col">Team Members</th>
<th scope="col">Total Time(hrs)</th>
</tr>
</thead>

<%
try{
String projectType = request.getParameter("projecttype"); 
String pro = request.getParameter("project"); 
connection = DriverManager.getConnection(connectionUrl+database, userid, password);
statement=connection.createStatement();
String sql ="select activitygroup,sum(hrs) from details1 where month="+showMonth+" and projecttype=? and project=? group by activitygroup ";
String sql1 ="select distinct userdata.name from details1,userdata where details1.activitygroup=? and details1.projecttype=? and details1.project=? and userdata.psno = details1.psno and month="+showMonth+" ";
PreparedStatement ps = connection.prepareStatement(sql); 
PreparedStatement ps1 = connection.prepareStatement(sql1); 
ps.setString(1, projectType);
ps.setString(2, pro);
rs=ps.executeQuery();
while(rs.next()){
%>
<tr>
<td><%=rs.getString(1) %></td>
<%
ps1.setString(1, rs.getString(1));
ps1.setString(2, projectType);
ps1.setString(3, pro);
rs1=ps1.executeQuery();
while(rs1.next()){
list.add(rs1.getString(1));
}
%>
<td><%
ListIterator<String> li=list.listIterator();
while(li.hasNext())
{
    out.print(li.next());
    if(li.hasNext())
        out.print(",");
}
%></td>
<% list.clear(); %>
<td><%=rs.getString(2) %></td>
</tr>
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
</html>