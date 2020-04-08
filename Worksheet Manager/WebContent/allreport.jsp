<%@page import="com.works.getConnection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.sql.Driver" %>
<%@ page import="java.util.*" %>
<%@ page import="com.google.gson.*"%>
<%@ page import="com.google.gson.JsonObject"%>
<%@ page import="java.util.concurrent.*" %>

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
String dataPoints = null;
%>

<!DOCTYPE html>
<html>
<head>
<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<meta charset="ISO-8859-1">
<title>Time Sheet</title>
<style >
html, body {
  height: 100%;
}

body {
    padding-top: 30px;
}
</style>

<script>
$(document).ready(function(){
	  $("#search2").on("keyup", function() {
	    var value = $(this).val().toLowerCase();
	    $("#table tr").filter(function() {
	      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
	    });
	  });
	});
</script>
<script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>
</head>


<body>
<div class="container" >
<div> Filter&nbsp;&nbsp;<input id="search2" type="text" placeholder="Search.."><br><br></div>
<div>
<table class="table table-hover table-bordered" id="table">
<thead>
<tr>
<th scope="col">Project Name</th>
<th scope="col">Subfunction</th>
<th scope="col">Total Time(hrs)</th>
</tr>
</thead>
<%
try
{
Gson gsonObj = new Gson();
Map<Object,Object> map = null;
CopyOnWriteArrayList<Map<Object,Object>> list = new CopyOnWriteArrayList<Map<Object,Object>>();
connection = new getConnection().getConnection();
statement=connection.createStatement();
String sql1 = "select details.project,details.subfunction,details.hrs from details where exists (select userstatus.psno from userstatus where userstatus.psno=details.psno and userstatus.status like 'Submitted') and month="+showMonth+" and details.project not like 'Leave/Holiday' ORDER by details.project";
rs = statement.executeQuery(sql1);
TreeMap<String,String> save_sets=new TreeMap<String,String>();
if(rs.next())
	{
	save_sets.put(rs.getString(1)+"$"+rs.getString(2),rs.getString(3));

	while(rs.next())
    {
        Set zz_set=save_sets.keySet();
        if(zz_set.contains(rs.getString(1)+"$"+rs.getString(2)))
           {
            
            int updateval=Integer.parseInt(save_sets.get(rs.getString(1)+"$"+rs.getString(2)));
            updateval+=Integer.parseInt(rs.getString(3));
            save_sets.put(rs.getString(1)+"$"+rs.getString(2),updateval+"");
            //System.out.println(rs.getString(1)+"$"+rs.getString(2)+"update");
           
           }
        else
            {
        	//System.out.println(rs.getString(1)+"$"+rs.getString(2)+"naya hain");
            save_sets.put(rs.getString(1)+"$"+rs.getString(2),rs.getString(3));
           
        	}
     
    	}
		statement.close();
 		connection.close();
 		rs.close();
	}
	else
	{
		statement.close();
 		connection.close();
 		rs.close();
	}
    %>
    <tbody>
    <%
    boolean inserted=false;
    Set<String> set_array = new HashSet<String>();
    Iterator<String> itr=save_sets.keySet().iterator();
        while(itr.hasNext())
          {
            %>
            <tr>
                <%
                String x= itr.next();
                String mappedValue = save_sets.get(x);
                StringTokenizer xx=new StringTokenizer(x, "$");
                String td_content=xx.nextToken();
                String valx=xx.nextToken();
                //System.out.println(td_content+" "+valx);
                
                if(set_array.contains(td_content))
                     {
                	  
                      out.print("<td style='border-right:none;border-left:none;border-bottom:none;border-top:none;color:transparent'>"+td_content+"</td>");
                     }
                else
                     {
                	  
                      set_array.add(td_content);
                      out.print("<td style='border-bottom:none'>"+td_content+"</td>");
                     }
                          
                Iterator g_li=list.listIterator();
                 while(g_li.hasNext())
                      {
                       HashMap<Object,Object> mmin=(HashMap) g_li.next();
                       String label_content=mmin.get("label").toString();
                       if(label_content.equalsIgnoreCase(td_content))
                         {
                           int vv=Integer.parseInt(mmin.get("y").toString());
                           vv+=Integer.parseInt(mappedValue);
                           list.remove(mmin);
                           HashMap<Object,Object> mmin_nx=new HashMap<Object,Object>();
                           mmin_nx.put("label",td_content);
                           mmin_nx.put("y", vv);
                           list.add(mmin_nx);
                           inserted=true;
                           break;
                          }
                       else
                           inserted=false;
                      }
                    if(!inserted)
                    {
                    map = new HashMap<Object,Object>(); 
                    map.put("label", td_content); 
                    map.put("y", mappedValue);
                    list.add(map);                    
                    }
                    out.print("<td>"+valx+"</td>");
                    out.print("<td>"+mappedValue+"</td>");
                %>
             </tr>
                <%
          }  
        dataPoints = gsonObj.toJson(list);
    %>
</tbody>
<%
} catch (Exception e) {
	System.out.println("In All report");
	System.out.println(e.toString());
}
%>
</table>
<!--  <div id="chartContainer"></div> -->
</div>
</div>
<script type="text/javascript">
window.onload = function() { 
var chart = new CanvasJS.Chart("chartContainer", {
	theme: "light2", // "light1", "dark1", "dark2"
	exportEnabled: true,
	animationEnabled: true,
	title: {
		text: ""
	},
	data: [{
		type: "pie",
		toolTipContent: "<b>{label}</b>: {y} hrs",
		indexLabelFontSize: 16,
		indexLabel: "{label} - {y} hrs",
		dataPoints: <%out.print(dataPoints);%>
	}]
});
chart.render();
}
</script>
</body>
</html>