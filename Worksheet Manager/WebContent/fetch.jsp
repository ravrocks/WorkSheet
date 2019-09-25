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
ResultSet rs1 = null;
String val = request.getParameter("q");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Time Sheet</title>
<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
</head>
<body>
<table class="table table-bordered">
<tbody>
<%
//System.out.print("here");
try{
connection = new getConnection().getConnection();
statement=connection.createStatement();
String sql ="select * from "+val+" ";
PreparedStatement ps = connection.prepareStatement(sql);
rs=ps.executeQuery();
while(rs.next()){
%>
<tr>
<td><%=rs.getString(2) %></td>
</tr>
<%
   }
connection.close();
}
catch (Exception e) {
e.printStackTrace();
}
%>
</tbody>
</table>
</body>
</html>