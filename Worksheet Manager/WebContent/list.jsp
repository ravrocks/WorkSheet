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
    Cookie[] cookies = request.getCookies();
    if(cookies !=null){
    for(Cookie cookie : cookies){
	if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
        if(cookie.getName().equals("show_month")) showMonth = cookie.getValue();
    }
    }
    if(userName == null) response.sendRedirect("home.jsp");
    
    String calling=request.getParameter("type");
    System.out.println(calling);
    getConnection oye=new getConnection();
    try{
    Connection connection=oye.getConnection();
    Statement statementt=connection.createStatement();
    String fquery="select * from userdata where `moncreate`<="+showMonth+" and `usertype`='user'";
    String squery="select distinct userdata.name,userdata.psno,userdata.email,details1.psno from userdata, details1 where userdata.psno = details1.psno and details1.month="+showMonth;
    String tquery="select distinct userdata.psno,userdata.name,userdata.email from userdata WHERE NOT EXISTS (select distinct details1.psno from details1 where details1.psno=userdata.psno and month="+showMonth+") and userdata.usertype='user' and userdata.moncreate<="+showMonth;
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
