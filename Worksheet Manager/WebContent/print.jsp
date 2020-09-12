
<%@page import="com.works.getConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View List</title>
        <script type="text/javascript" src="assets/js/jquery.min.js"></script>
        <script type="text/javascript" src="assets/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" type="text/css" href="assets/css/datatables.min.css"/>
        <script type="text/javascript" src="assets/js/datatables.min.js"></script>
    </head>
    <%
    String userName = null,userPsno=null;
    Cookie[] cookies = request.getCookies();
    if(cookies !=null)
    {
    for(Cookie cookie : cookies)
    	{
		if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
		if(cookie.getName().equals("timesheet_psno")) userPsno = cookie.getValue();
    	}
    }
    if(userName == null||userPsno==null)
    	{
    	response.sendRedirect("home.jsp");
    	return;
    	}
    String name = userName; 
    String psno = userPsno;
    int monthx= Integer.parseInt(request.getParameter("for_month"));
    String yearx=request.getParameter("for_year");
    getConnection oye=new getConnection();
    ResultSet rs=null;
    ResultSet rs1=null;
    try{
    Connection connection=oye.getConnection();
    Statement statementt=connection.createStatement();
    String sql ="select subfunction,project,activitygroup,activity,date,hrs,remarks,fromtime from details where month="+monthx+" and psno=? and date like '"+yearx+"%' order by date asc";
    String total="select sum(hrs) from details where month="+monthx+" and psno=?";
	//rs = statement.executeQuery(sql);
	PreparedStatement ps = connection.prepareStatement(sql); 
	PreparedStatement ps1 = connection.prepareStatement(total);
	ps.setInt(1, Integer.parseInt(psno));
	rs=ps.executeQuery();
	ps1.setInt(1, Integer.parseInt(psno));
	rs1=ps1.executeQuery();
        %>
    <body>
     
	<div align="center" style="color:#1c87c9; font-size:20px;font-weight: 500;font-family: 'Raleway';margin-bottom: -20px"><% out.println(name+"&nbsp&nbsp("+psno+")"); %></div><br><br>
    <table id="example" class="display table-bordered" style="width:99%">
    <thead>
        <tr>
           <th scope="col">Date</th>
				<th scope="col">Subfunction</th>
				<th scope="col">Project</th>
				<th scope="col">Activity Group</th>
				<th scope="col">Activity</th>
				<th scope="col">Remarks</th>
				<th scope="col">From Time</th>
				<th scope="col">Hrs</th>
        </tr>
    </thead>    
    <tbody>
    <%
        while(rs.next()){
            %>
    <tr>
    	<td><%=rs.getString("date") %></td>
		<td><%=rs.getString("subfunction") %></td>
		<td><%=rs.getString("project") %></td>
		<td><%=rs.getString("activitygroup") %></td>
		<%
		String act=rs.getString("activity");
		%>
		<td><%out.print(act);%></td>
		<td><%=rs.getString("remarks") %></td>
		<td><%=rs.getString("fromtime") %></td>
		<% String hrs=rs.getString("hrs"); 
		//if(act.equals("Holiday"))
			   // hrs="0";
		%>
		<td><%out.print(hrs); %></td>
    </tr>
    <%
        }
    %>
    <% rs1.next();
    String totalhrs=rs1.getString(1); %>
    <tr>
    <td>Total</td>
    <td></td><td></td><td></td><td></td><td></td><td></td>
    <td><%out.print(totalhrs); %></td>
    </tr>
    </tbody>
    
    <%
    connection.close();
    statementt.close();
    rs.close();
    } 
    catch(Exception e)
        {
        System.out.println("inside print jsp error");
       e.printStackTrace(); 
    }
    %>
</table>
<script>
    $(document).ready( function () {
    $('#example').DataTable({
        "info": false 
    });
} );
</script>
</body>
</html>
