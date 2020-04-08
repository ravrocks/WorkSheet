<%-- 
    Document   : table_content
    Created on : Aug 19, 2019, 4:16:05 AM
    Author     : ravi
--%>

<%@page import="com.works.getConnection"%>
<%@page import="com.sun.org.apache.bcel.internal.generic.AALOAD"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <link href="assets/js/jquery-clockpicker.css" rel="stylesheet"/>
<!-- Javascripts -->

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<!--
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
-->
<script src="assets/js/jquery-clockpicker.js"></script>
<script src="assets/js/jquery.bootpag.min.js"></script>
<%
    String userName = null,userPsno=null,viewing_month=null,viewing_year=null;
    Cookie[] cookies = request.getCookies();
    if(cookies !=null){
    for(Cookie cookie : cookies){
	if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
	if(cookie.getName().equals("timesheet_psno")) userPsno = cookie.getValue();
	if(cookie.getName().equals("timesheet_load_month")) viewing_month = cookie.getValue();
	if(cookie.getName().equals("timesheet_load_year")) viewing_year = cookie.getValue();
    	}
    }
    if((userName == null)) 
        response.sendRedirect("home.jsp");
%>
<script>
    var late_id=1;
    $( document ).ready(function() {
            paging_display(1);
            $("#detailz1").css("visibility","visible");
             $("#detailz2").css("visibility","visible");
             $("#footing").css("visibility","visible");
             $("#detailz2").css("margin-top","-10px");
             $('#pagination-here').bootpag({
                    total: 2,          
                    page: 1,            
                    maxVisible: 2,     
                    leaps: true,
                    href: "#result-page-{{number}}"
                });
                //page click action
              $('#pagination-here').on("page", function(event, num){
                $("#detailz1").html("Page " + num); 
                paging_display(num)
               });
              
              $('textarea').keyup(function() {
              	  var textlen = 250 - $(this).val().length;
              	  if(textlen>0)
              		  $(this).next().css("visibility","hidden");
              	  else
              		{
              		$(this).next().css("visibility","visible");
              		$(this).val(($(this).val()).substring(0, 250+textlen));
              		}
              	}); 
              var arr = [];

              $("#tablez_body tr").each(function() {
               arr.push(this.id);
                });
              for(let fgh=0;fgh<arr.length;fgh++)
              {
                  var zxc_ind=arr[fgh];
                  if(zxc_ind.indexOf("Sun")!=-1)
                    {
                      //console.log("yes");
                      document.getElementById(zxc_ind).style.backgroundColor='#fff1e3';
                     }
              }


        });

        function paging_display(numb)
        {
            var complete_table=document.getElementById("show_table");
                for(var k=0, row;row=complete_table.rows[k];k++)
                    {
                        if(k==0)
                            continue;
                        switch(numb)
                        {
                            case 1: if(k<16)
                                        row.style.display= 'table-row'; 
                                    else
                                        row.style.display= 'none';
                                    break;
                            case 2: if(k>15)
                                        row.style.display= 'table-row';
                                    else
                                        row.style.display= 'none';
                                    break;
                        }         
                        
                    }
        }
        
        function getWeekDate(date)
        {
            var din=moment(date).format("dddd");
            var rest=moment(date).format("MMM Do");
            return din+" "+rest;
        }
        
        function addMoreRow(ix)
        {
            var row = document.getElementById(ix+"_row");   
            clone = row.cloneNode(true);    
            clone.id = ix+"_row"+"_row";
            var x = document.createElement("TD");
            var t = document.createTextNode("");
            x.appendChild(t);
            clone.replaceChild(x,clone.childNodes[1]);
            //alert(clone.childNodes.length);
            z=clone.childNodes[15];
            zz=z.childNodes[3];
            zz.style.display="block";
            z.replaceChild(zz,z.childNodes[3]);
            clone.replaceChild(z,clone.childNodes[15]);
            row.insertAdjacentElement("afterend", clone);   
        }
        
        function removeRow(ix)
        {
            var row = document.getElementById(ix+"_row");
            row.parentNode.removeChild(row);
        }
</script>
<!-- Stylesheets -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">    
<style>
  #detailz1
  {
    color:#337ab7;
  }
</style>                                
    <table id="show_table" class="table table-hover table-bordered table-list">
                  <thead>
                    <tr>
                        <th  class="col-md-2" scope="col"><em class="fa fa-cog"></em></th>
                        <th  class="col-md-1" scope="col">Time</th>
                        <th  class="col-md-1" scope="col">Project Name</th>
                        <th  class="col-md-1" scope="col">Subfunction</th>         
                        <th  class="col-md-1" scope="col">Activity Group</th>
                        <th  class="col-md-1" scope="col">Activity</th>
                        <th  class="col-md-4" scope="col">Remarks</th>
                        <th  class="col-md-1"  scope="col"></th>
                    </tr> 
                  </thead>
                  <tbody id="tablez_body">
                      <%
                      String project_list="",subfunction="",activity_group="",activity_list="";
                      try{
                      		getConnection zz=new getConnection();
                      		Connection connection = zz.getConnection();
                      		Statement statement = connection.createStatement() ;
                      		ResultSet resultset =statement.executeQuery("select * from project_list") ;
                      		while(resultset.next())
                       			{
                         			String descp=resultset.getString("listing");
                         			project_list+="<option value='"+descp+"' />";
                        			}
                      		resultset.close();
                      		resultset =statement.executeQuery("select * from subfunction") ;
                             while(resultset.next())
                                 {
                                 String descp=resultset.getString("desc");
                                 subfunction+="<option value='"+descp+"' />";
                                 }
                             resultset =statement.executeQuery("select * from activity_group") ;
                             while(resultset.next())
                             {
                                 String descp=resultset.getString("desc");
                                 activity_group+="<option value='"+descp+"' />";
                             }
                             resultset =statement.executeQuery("select * from activity_list") ;
                             while(resultset.next())
                             {
                                 String descp=resultset.getString("listing");
                                 activity_list+="<option value='"+descp+"' />";
                             }
                             resultset.close();
                      	    statement.close();                      		
                      		connection.close();
                         	}
                         catch(Exception e)
                         	{
                         	e.printStackTrace();    
                         	}
                      try{
                    	  Connection conn=new getConnection().getConnection();
                    	  Statement updateSS=conn.createStatement();
                    	  String monint[]={"January","February","March","April","May","JUNE","July","August","september","october","november","december"};
                          int viewing_month_int=0;
                          for(int lp=0;lp<monint.length;lp++)
                          {
                        	  if(monint[lp].equalsIgnoreCase(viewing_month))
                        	  {
                        		  viewing_month_int=lp+1;
                        		  break;
                        	  }
                          }
                    	  updateSS.executeUpdate("insert into userstatus(name,psno,month,status,year) values('"+userName+"',"+userPsno+","+viewing_month_int+",'Pending',"+viewing_year+")");
                    	  
                    	  updateSS.close();
                    	  conn.close();
                      }
                      catch(Exception e)
                      {
                    	  e.printStackTrace();
                      }
                      String dayz=request.getParameter("dayz");
                      StringTokenizer stz=new StringTokenizer(dayz,",");
                      int length=stz.countTokens();
                      String array_for_days[]=new String[length];
                      int i=0;
                      while(stz.hasMoreTokens())
                        {
                          array_for_days[i++]=stz.nextToken();
                      }
                      //out.print("got----------"+array_for_days[--i]);
                      for(int j=0;j<i;j++)
                         {
                          String formated_date=array_for_days[j].substring(0, 15);
                          String formated_date_row=formated_date+"_row";
                      %>
                          <tr id="<%=formated_date_row%>">
                            <td align="center" class="col-md-1">
                              <%
                              int yr_vall=formated_date.indexOf(viewing_year);
                              String formal_formated_date=formated_date.substring(0,yr_vall-1).trim();
                              out.print(formal_formated_date);
                              %>
                            </td>
                            <td class="col-md-2">
                                <div id="<%=formated_date+"_startc"%>"  style="width:100px" class="input-group" data-placement="right" data-align="top" data-autoclose="true">
                                    <input style="width:100%;" type="text" class="form-control" value="09:00" onchange="validateHhMm(this)">
                                <span class="input-group-addon">
                                <span class="glyphicon glyphicon-time" style="color:#197724">
                                </span>
                                </span>
                                </div>
                                <!-- End Time details -->
                                <div id="<%=formated_date+"_endc"%>" style="width:100px;margin-top:15px" class="input-group" data-placement="right" data-align="top" data-autoclose="true">
                                <input style="width:100%;" type="text" class="form-control" value="18:00" onchange="validateHhMm(this)">
                                <span class="input-group-addon">
                                <span class="glyphicon glyphicon-time" style="color:#970002">
                                </span>
                                </span>
                                </div>
                            </td>
                            <td id="<%=formated_date+"_project_list"%>" class="col-md-1">
                        		<input type="text" id="browsers22" list="browsers2" autocomplete="off" class="custom-select" style="height: 100%;width: 150px;padding: 10px;font-size: 13px;margin-bottom: 1px;-webkit-appearance: none;-moz-appearance: none;">
                           		<datalist id="browsers2">
                            		<%
                            		out.print(project_list);
                            		%>
                        		</datalist>
							</td>                           
                            <td id="<%=formated_date+"_subfunction"%>" class="col-md-1">
           						<input id="project_type_buttonz"  aria-expanded="false" list="proj_type" type="text" class="custom-select" style="height: 100%;width: 150px;padding: 10px;font-size: 13px;margin-right: 0px">
                        		<datalist id="proj_type" >
                            		<%
                            		out.print(subfunction);
                            		%>
                        		</datalist>
                            </td>

                            <td class="col-md-1">
                            	<input type="text" list="browsers3" autocomplete="off" class="custom-select" style="height: 100%;width: 150px;padding: 10px;font-size: 13px;margin-right: 0px">
                           		<datalist id="browsers3">
                           			<%
                            		out.print(activity_group);
                            		%>
                           		</datalist>
                            </td>

                            <td class="col-md-2">
                            	<input type="text" list="browsers" autocomplete="off" class="custom-select" style="height: 100%;width: 180px;padding: 10px;font-size: 13px;margin-right: 0px">
                           		<datalist id="browsers">
                            		<%
                            		out.print(activity_list);
                            		%>
                        		</datalist>
                            </td>

                            <td class="col-md-3" style="width:150px">
                            <textarea class="form-control" id="remarking" rows=4></textarea>
                            <span id="rchars" style="visibility: hidden;color: red">Maximum 250 characters</span>
                            </td>

                            <td class="col-md-1"> 
                                <button id="<%=formated_date%>" onclick="addMoreRow(this.id)" type="button" class="btn btn-success"><span class="glyphicon glyphicon-plus"></span> Add</button>
                                <button id="<%=formated_date+"_row"%>" onclick="removeRow(this.id)" type="button" class="btn btn-danger" style="display: none;margin-top: 5px"><span class="glyphicon glyphicon-remove"></span> Delete</button>
                            </td>
                          </tr>
                          <%
                          }
                      %>
                 </tbody>
       </table>
     <script>
     	
     </script>
</html>
