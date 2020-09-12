<%-- 
    Document   : list
    Created on : Aug 29, 2019, 4:26:56 AM
    Author     : ravi
--%>

<%@page import="com.works.getConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>List of users</title>
        <script type="text/javascript" src="assets/js/jquery.min.js"></script>
        <script type="text/javascript" src="assets/js/jquery.dataTables.min.js"></script>
        <link rel="stylesheet" type="text/css" href="assets/css/datatables.min.css"/>
        <script type="text/javascript" src="assets/js/datatables.min.js"></script>
        
    </head>
    <%
    String userName = null;
    String showMonth=null;
    String showYear=null;
    Cookie[] cookies = request.getCookies();
    if(cookies !=null){
    for(Cookie cookie : cookies){
	if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
        if(cookie.getName().equals("show_month")) showMonth = cookie.getValue();
        if(cookie.getName().equals("show_year")) showYear = cookie.getValue();
    }
    }
    if(userName == null) response.sendRedirect("home.jsp");
    
    String calling=request.getParameter("type");
    System.out.println(calling);
    getConnection oye=new getConnection();
    try{
    Connection connection=oye.getConnection();
    Statement statementt=connection.createStatement();
    String fquery="select * from userdata where moncreate<="+showMonth+" and usertype='user' and validity=1";
    String squery="select distinct userstatus.name, userstatus.psno, userdata.email from userstatus,userdata where userdata.psno=userstatus.psno and userstatus.month="+showMonth+" and status='Submitted' and year='"+showYear+"'";
    String tquery="select distinct userdata.name, userdata.psno, userdata.email from userdata where moncreate<="+Integer.parseInt(showMonth)+" and usertype='user'"+" and validity=1 and userdata.psno not in (select distinct userstatus.psno from userstatus,userdata where userdata.psno=userstatus.psno and userstatus.month="+Integer.parseInt(showMonth)+" and status like 'Submitted' and year='"+showYear.trim()+"')";
	ResultSet res=null;
    if(calling.equals("total"))
    res=statementt.executeQuery(fquery);
       else if(calling.equals("filled"))
           res=statementt.executeQuery(squery);
              else if(calling.equals("pending"))
                  res=statementt.executeQuery(tquery);
        %>
    <body>
    <table id="example" class="display table-bordered" style="width:99%">
    <thead>
        <tr>
            <th scope="col">Name of Employee</th>
            <th scope="col">PSno</th>
            <th scope="col">Email Address</th>
        </tr>
    </thead>    
    <tbody>
    <%
        while(res.next()){
            %>
    <tr>
    <td><%=res.getString("name") %></td>
    <td><%=res.getString("psno") %></td>
    <td><%=res.getString("email") %></td>
    </tr>
    <%
        }
    %>
    </tbody>
    
    <%
    connection.close();
    statementt.close();
    res.close();
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
        "info": false 
    });
} );
</script>
</body>
</html>
