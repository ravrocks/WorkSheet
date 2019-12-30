<%-- 
    Document   : table_content
    Created on : Aug 19, 2019, 4:16:05 AM
    Author     : ravi
--%>

<%@page import="java.util.HashSet"%>
<%@page import="com.works.getConnection"%>
<%@page import="com.sun.org.apache.bcel.internal.generic.AALOAD"%>
<%@page import="java.sql.*" %>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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
    String userName = null,userPsno=null,userTIC=null,viewing_month=null;
    Cookie[] cookies = request.getCookies();
    if(cookies !=null){
    for(Cookie cookie : cookies)
    {
	if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
	if(cookie.getName().equals("timesheet_psno")) userPsno = cookie.getValue();
	if(cookie.getName().equals("timesheet_load_month")) viewing_month = cookie.getValue();
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
                
              //$('.clockpicker').clockpicker();
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
            //alert(clone.childNodes[13].innerHTML);
            //setting remarks as blank
            clone.childNodes[13].getElementsByTagName("textarea")[0].innerHTML="";
            //setting activity as blank
            clone.childNodes[11].getElementsByTagName("input")[0].value="";
          	//setting activity group as blank
            clone.childNodes[9].getElementsByTagName("input")[0].value="";
            //setting subfunction as blank
            clone.childNodes[7].getElementsByTagName("input")[0].value="";
          	//setting project as blank
            clone.childNodes[5].getElementsByTagName("input")[0].value="";
          	
            //console.log(clone.childNodes[5].getElementsByTagName("input")[0].value);
            z=clone.childNodes[15];
            zz=z.childNodes[3];
            zz.style.display="block";
            z.replaceChild(zz,z.childNodes[3]);
            clone.replaceChild(z,clone.childNodes[15]);
            row.insertAdjacentElement("afterend", clone);   
        }
        
        function removeRow(ix)
        {
        	var td = event.target.parentNode; 
            var tr = td.parentNode; // the row to be removed
            tr.parentNode.removeChild(tr);
        }
        function removedRow()
        {
        	var td = event.target.parentNode; 
            var tr = td.parentNode; // the row to be removed
            tr.parentNode.removeChild(tr);
        }
</script>
<!-- Stylesheets -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">    
                                
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
                      String dayz=request.getParameter("dayz");
                      StringTokenizer stz=new StringTokenizer(dayz,",");
                      int length=stz.countTokens();
                      String array_for_days[]=new String[length];
                      int i=0;
                      while(stz.hasMoreTokens())
                        {
                          array_for_days[i++]=stz.nextToken();
                      }
                      getConnection zxc=new getConnection();
                      Connection conn=zxc.getConnection();
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
                      PreparedStatement ssstate=conn.prepareStatement("select * from details where psno="+Integer.parseInt(userPsno)+" and month="+viewing_month_int+" ORDER by date");
                      ResultSet rsss=ssstate.executeQuery();
                      HashSet<String> zzset=new HashSet<String>();
                      int fcount=0;
                      String exdate="";
                      while(rsss.next())
                      {
                    	  String sDate1=rsss.getString("date");
                          Date date1=new SimpleDateFormat("yyyy-MM-dd").parse(sDate1); 
                  		  String pattern = "EEE MMM dd yyyy";
                          SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
                          String printdate=simpleDateFormat.format(date1);
                    	  %>
                    	  <tr id="<%=printdate+"_row"%>">
                    	  <td align="center" class="col-md-1" style="color: #BF8238;font-family: Georgia, serif;font-size:15px">
                              <%
                              if(exdate.equalsIgnoreCase(printdate))
                                out.print("<span style='color:#fff;opacity:.1'>"+printdate+"</span>");
                              else
                            	out.print(printdate);
                              String stertingz=rsss.getString("fromtime");
                              String endingz=rsss.getString("totime");
                              %>
                            </td>
                            <td>
                            <div id="<%=sDate1+"_startc"%>"  style="width:100px" class="input-group" data-placement="right" data-align="top" data-autoclose="true">
                                <input style="width:100%;" type="text" class="form-control" value="<%=stertingz%>">
                                <span class="input-group-addon">
                                <span class="glyphicon glyphicon-time" style="color:#197724">
                                </span>
                                </span>
                                </div>
                                <!-- End Time details -->
                                <div id="<%=sDate1+"_endc"%>" style="width:100px;margin-top:15px" class="input-group" data-placement="right" data-align="top" data-autoclose="true">
                                <input style="width:100%;" type="text" class="form-control" value="<%=endingz%>">
                                <span class="input-group-addon">
                                <span class="glyphicon glyphicon-time" style="color:#970002">
                                </span>
                                </span>
                             </div>
                            </td>
                            <td>
                            <input type="text" list="browsers2" autocomplete="off" class="custom-select" style="height: 100%;width: 150px;padding: 10px;font-size: 13px;margin-bottom: 1px;-webkit-appearance: none;-moz-appearance: none;" value="<%=rsss.getString("project")%>">
                            <datalist id="browsers2">
                            		<%
                            		out.print(project_list);
                            		%>
                        	</datalist>
                            </td>
                            <td>
                            <input type="text" list="proj_type" autocomplete="off" class="custom-select" style="height: 100%;width: 150px;padding: 10px;font-size: 13px;margin-bottom: 1px;-webkit-appearance: none;-moz-appearance: none;" value="<%=rsss.getString("subfunction")%>">
                            <datalist id="proj_type" >
                            		<%
                            		out.print(subfunction);
                            		%>
                        	</datalist>
                            </td>
                            <td>
                            <input type="text" list="browsers3" autocomplete="off" class="custom-select" style="height: 100%;width: 150px;padding: 10px;font-size: 13px;margin-bottom: 1px;-webkit-appearance: none;-moz-appearance: none;" value="<%=rsss.getString("activitygroup")%>">
                            <datalist id="browsers3">
                           			<%
                            		out.print(activity_group);
                            		%>
                            </datalist>
                            </td>
                            <td>
                            <input type="text" list="browsers" autocomplete="off" class="custom-select" style="height: 100%;width: 150px;padding: 10px;font-size: 13px;margin-bottom: 1px;-webkit-appearance: none;-moz-appearance: none;" value="<%=rsss.getString("activity")%>">
                            <datalist id="browsers">
                            		<%
                            		out.print(activity_list);
                            		%>
                        	</datalist>
                            </td>
                            <td>
                            	<textarea class="form-control" id="remarking" rows=4><%=rsss.getString("remarks")%>
                            	</textarea>
                            	<span id="rchars" style="visibility: hidden;color: red">Maximum 250 characters</span>
                            </td>
                            <td class="col-md-1"> 
                                <button id="<%=printdate%>" onclick="addMoreRow(this.id)" type="button" class="btn btn-success"><span class="glyphicon glyphicon-plus"></span> Add</button>
                                <%
                                if(exdate.equalsIgnoreCase(printdate))
                                {
                                %>
                                <button id="<%=printdate+"_row"%>" onclick="removedRow()" type="button" class="btn btn-danger" style="margin-top: 5px"><span class="glyphicon glyphicon-remove"></span> Delete</button>
                                <%
                                }
                                else
                                {
                                	 %>
                                <button id="<%=printdate+"_row"%>" onclick="removedRow(this.id)" type="button" class="btn btn-danger" style="display:none;margin-top: 5px"><span class="glyphicon glyphicon-remove"></span> Delete</button>
                                     <%	
                                }
                                %>
                            </td>
                            </tr>
                           
                    	  <%
                    	  zzset.add(printdate);
                    	  fcount++;
                    	  exdate=printdate;
                      }
					  rsss.close();
                 	  conn.close();
                      //out.print("got----------"+array_for_days[--i]);
                     
                      for(int j=0;j<i;j++)
                         {
                          String formated_date=array_for_days[j].substring(0, 15);
                          if(zzset.contains(formated_date))
                        	  continue;
                          String formated_date_row=formated_date+"_row";
                      		%>
                          <tr id="<%=formated_date_row%>">
                            <td align="center" class="col-md-1">
                              <%
                              out.print(formated_date);
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
                                <div id="<%=formated_date+"_endc"%>" style="width:100px;margin-top:15px" class="input-group" data-placement="right" data-align="top" data-autoclose="true" >
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
                            <td class="col-md-1">
                            	<input type="text" list="browsers" autocomplete="off" class="custom-select" style="height: 100%;width: 150px;padding: 10px;font-size: 13px;margin-right: 0px">
                           		<datalist id="browsers">
                            		<%
                            		out.print(activity_list);
                            		%>
                        		</datalist>
                            </td>
                            <td class="col-md-4" style="width:150px">
                            	<textarea class="form-control" id="remarking" rows=4>
                            	</textarea>
                            	<span id="rchars" style="visibility: hidden;color: red">Maximum 250 characters</span>
                            </td>
                            <td class="col-md-1"> 
                                <button id="<%=formated_date%>" onclick="addMoreRow(this.id)" type="button" class="btn btn-success"><span class="glyphicon glyphicon-plus"></span> Add</button>
                                <button id="<%=formated_date+"_row"%>" onclick="removedRow()" type="button" class="btn btn-danger" style="display: none;margin-top: 5px"><span class="glyphicon glyphicon-remove"></span> Delete</button>
                            </td>
                          </tr>
                          <%
                          }
                      %>
                 </tbody>
       </table>
</html>
