
<%@page import="com.works.getConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Summary on Sub-function</title>
        <script type="text/javascript" src="assets/js/jquery.min.js"></script>
        <script type="text/javascript" src="assets/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" type="text/css" href="assets/css/datatables.min.css"/>
        <script type="text/javascript" src="assets/js/datatables.min.js"></script>
    </head>
    <%
    String userName = null;
    String showMonth=null;
    Cookie[] cookies = request.getCookies();
    if(cookies !=null){
    for(Cookie cookie : cookies){
	if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
        if(cookie.getName().equals("show_month")) showMonth = cookie.getValue();
    }
    }
    if(userName == null) response.sendRedirect("home.jsp");
    
    String name = request.getParameter("name"); 
    String psno=request.getParameter("psno");
    getConnection oye=new getConnection();
    ResultSet rs=null;
    ResultSet rs1=null;
    try{
    Connection connection=oye.getConnection();
    Statement statementt=connection.createStatement();
    String sql ="select subfunction,sum(hrs) from details where month="+Integer.parseInt(showMonth)+" and psno=? and subfunction NOT LIKE 'Leave/Holiday' group by subfunction";
    String total="select sum(hrs) from details where month="+showMonth+" and psno=?";
	//rs = statement.executeQuery(sql);
	PreparedStatement ps = connection.prepareStatement(sql); 
	PreparedStatement ps1 = connection.prepareStatement(total); 
	ps.setInt(1, Integer.parseInt(psno));
	ps1.setInt(1, Integer.parseInt(psno));
	rs=ps.executeQuery();
	rs1=ps1.executeQuery();
        %>
    <body>
     
	<div align="center" style="color:#1c87c9; font-size:20px;font-weight: 500;font-family: 'Raleway';margin-bottom: -20px"><% out.println(name+"&nbsp&nbsp("+psno+")"); %></div><br><br>
    <table id="example" class="display table-bordered" style="width:99%">
    <thead>
        <tr>
				<th scope="col">Subfunction</th>
				<th scope="col">Total hrs</th>
        </tr>
    </thead>    
    <tbody>
    <%
        while(rs.next()){
            %>
    <tr>
		<td><%=rs.getString("subfunction") %></td>
		<% String hrs=rs.getString(2); %>
		<td><%out.print(hrs); %></td>
    </tr>
    <%
        }
    %>
    <% rs1.next();
    String totalhrs=rs1.getString(1); %>
    <tr>
    <td>Total</td>
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
        System.out.println("inside list error");
       e.printStackTrace(); 
    }
    %>
</table>
<script>
    $(document).ready( function () {
    $('#example').DataTable({
        "info": false, 
        "bSort" : false
    });
} );
</script>
</body>
</html>
