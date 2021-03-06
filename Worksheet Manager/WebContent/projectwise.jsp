<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Driver" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ListIterator"%>

<%
String userName = null,userPsno=null;
    Cookie[] cookies = request.getCookies();
    if(cookies !=null){
    for(Cookie cookie : cookies){
	if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
        if(cookie.getName().equals("timesheet_psno")) userPsno = cookie.getValue();
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
ResultSet rs1=null;
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
popupWindow = window.open(url,'popUpWindow','height=300,width=700,left=50,top=50,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no, status=yes')
	}

</script>
</head>
<body>
<div class="container" >
  <% 
    String name = userName; 
    String psno = userPsno; 
	request.getSession(false);
	 
 %>  

<div> Filter &nbsp;&nbsp;<input id="search" type="text" placeholder="Search.."><br><br></div>
<div>
<table class="table table-hover table-bordered" id="table">
<thead>
<tr>
<th scope="col">Project Type</th>
<th scope="col">Project</th>
</tr>
</thead>
<%
try{
connection = DriverManager.getConnection(connectionUrl+database, userid, password);
statement=connection.createStatement();
String sql ="select * from project_type";
String sql1 = "select distinct project from details1 where projecttype=?";
PreparedStatement ps1 = connection.prepareStatement(sql1);
rs = statement.executeQuery(sql);

while(rs.next()){
    String pprint=rs.getString("desc");
%>
<tbody>
       <tr>
             <td><%out.print(pprint);%></td>
             <%
				ps1.setString(1, pprint);
				rs1=ps1.executeQuery();
				List<String> list = new ArrayList<String>();
				while(rs1.next()){
				list.add(rs1.getString(1));
				}
				%>
				<td><%
				ListIterator<String> li=list.listIterator();
				while(li.hasNext())
				{
				    String temp=li.next();%>
				    <a onclick="basicPopup(this.href);return false" href="summary_projectwise.jsp?projecttype=<%out.print(pprint);%>&project=<% out.print(temp);%>"><% out.print(temp);%></a>
				    <% if(li.hasNext())
				        out.print(",");
				}%>
             </td>

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
</div>
</body>

</html>