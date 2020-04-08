<%@page import="com.works.getConnection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Driver" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ListIterator"%>

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
	  $("#searchh").on("keyup", function() {
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
<div> Filter&nbsp;&nbsp;<input id="searchh" type="text" placeholder="Search.."><br><br></div>
<table class="table table-hover table-bordered" id="table">
<thead>
<tr>
<th scope="col">Project Name</th>
<th scope="col">Total time(hrs)</th>
<th scope="col">Details</th>
</tr>
</thead>
<%
try{
connection = new getConnection().getConnection();
statement=connection.createStatement();
String sql ="select * from project_list where listing NOT LIKE 'Leave/Holiday' order by listing";
String sql1 = "select sum(derivedtablez.hrs) from (select DISTINCT details.date,details.remarks,details.hrs,details.subfunction from userstatus,details where userstatus.psno=details.psno and userstatus.status like 'Submitted' and project=? and details.month="+showMonth+") as derivedtablez";
PreparedStatement ps1 = connection.prepareStatement(sql1);
rs = statement.executeQuery(sql);

while(rs.next()){
    String city=rs.getString("listing");
    ps1.setString(1, city);
    rs1 = ps1.executeQuery();
%>
<tbody>
       <tr>
             <td><%out.print(city);%></td>
             <td><% while(rs1.next()){
            	 String temp=rs1.getString(1);
            	 if(temp==null)
            		 out.print("0");
            	 else 
            		 out.print(temp); 
             }  
             %></td>
             <%if(city.equals("TIC")){%>
                 	<td><a onclick="basicPopup(this.href);return false" href="summary_projectwise_TIC.jsp?projectname=<%out.print(city);%>">view</a></td>
                <%}else{%>
                	<td><a onclick="basicPopup(this.href);return false" href="summary_projectwise.jsp?projectname=<%out.print(city);%>">view</a></td>
       			<%} %>
       </tr>
</tbody>
<%
	}
	connection.close();
} catch (Exception e) {
	//System.out.println("In projectwise");
	e.printStackTrace();
}
%>
</table>
</div>

</body>
</html>