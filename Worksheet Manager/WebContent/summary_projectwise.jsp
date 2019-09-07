<%@page import="com.works.getConnection"%>
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


Connection connection = null;
Statement statement = null;
ResultSet rs = null;
ResultSet rs1 = null;
ResultSet rs2 = null; 
%>

<!DOCTYPE html>
<html>
<head> 
<meta charset="ISO-8859-1">
<title>Reports</title>
<script type="text/javascript" src="assets/js/jquery.min.js"></script>
<script type="text/javascript" src="assets/js/jquery.dataTables.min.js"></script>
<link rel="stylesheet" type="text/css" href="assets/css/datatables.min.css"/>
<script type="text/javascript" src="assets/js/datatables.min.js"></script>
</head>
<body>
<% String city = request.getParameter("projectname"); %>
<div class="container" id="content">
<div align="center" style="color:#1c87c9; font-size:20px;">Project Name: <% out.println(city); %></div><br>
<table class="display table-bordered" id="example">
<thead>
<tr>
<th scope="col">Sub Function</th>
<th scope="col">Team Members</th> 
<th scope="col">Total Time(hrs)</th>
</tr>
</thead>

<%
try{
connection = new getConnection().getConnection();
statement=connection.createStatement();
String sql="Select * from subfunction where extra=?";
String sql1="Select distinct userstatus.name from details,userstatus where details.subfunction=? and details.project=? and userstatus.psno = details.psno and details.month="+showMonth+" and userstatus.status like 'Submitted'";
String sql2="Select sum(hrs) from details,userstatus where subfunction=? and project=? and details.month="+showMonth+" and userstatus.psno=details.psno and userstatus.status like 'Submitted'";
//String sql ="select activitygroup,sum(hrs) from details1 where month="+showMonth+" and projecttype=? and project=? group by activitygroup ";
//String sql1 ="select distinct userdata.name from details1,userdata where details1.activitygroup=? and details1.projecttype=? and details1.project=? and userdata.psno = details1.psno and month="+showMonth+" ";
PreparedStatement ps = connection.prepareStatement(sql); 
PreparedStatement ps1 = connection.prepareStatement(sql1); 
PreparedStatement ps2 = connection.prepareStatement(sql2); 
ps.setString(1,"ntic");
rs=ps.executeQuery();
while(rs.next()){
	String subfun = rs.getString(2);
	String str=null;
	List<String> list = new ArrayList<String>();
%>
<tr>
	<td><%out.print(subfun);%></td>
	<%
	ps1.setString(1, subfun);
	ps1.setString(2, city);
	rs1=ps1.executeQuery();
	while(rs1.next()){
		list.add(rs1.getString(1));
		//str=rs1.getString(2); 
	}
	%>
	<td><%
		ListIterator<String> li=list.listIterator();
		while(li.hasNext())
		{
		    //System.out.println(li.next());
			out.print(li.next());
		    if(li.hasNext())
		        out.print(",");
		}
		
	%></td>
	<%list.clear(); 
		ps2.setString(1, subfun);
		ps2.setString(2, city);
		rs2=ps2.executeQuery();
		while(rs2.next()){
			str=rs2.getString(1); 
			if(str==null)
       		  str="0";
		}
	
	%>
	<td><%out.print(str); str=null;%></td>
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
<script>
    $(document).ready( function () {
    $('#example').DataTable({
        "info": false 
    });
} );
</script>
</body>
</html>