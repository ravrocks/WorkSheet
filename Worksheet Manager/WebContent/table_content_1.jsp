<%-- 
    Document   : table_content
    Created on : Aug 19, 2019, 4:16:05 AM
    Author     : ravi
--%>

<%@page import="com.sun.org.apache.bcel.internal.generic.AALOAD"%>
<%@page import="java.util.StringTokenizer"%>
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
        bindClockPicker();
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
            //var day = date.getUTCDate();
            //var month = date.getUTCMonth() + 1;
            
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
            z=clone.childNodes[13];
            zz=z.childNodes[3];
            zz.style.display="block";
            z.replaceChild(zz,z.childNodes[3]);
            clone.replaceChild(z,clone.childNodes[13]);
            //alert("id is "+row.rowIndex);
            var startingc=clone.childNodes[3].getElementsByClassName("clockpicker")[0];
                startingc.id=startingc.id+"1";
            var endingc=clone.childNodes[3].getElementsByClassName("clockpicker")[1];
                endingc.id=endingc.id+"1";
            clone.childNodes[3].replaceChild(startingc, clone.childNodes[3].getElementsByClassName("clockpicker")[0]);
            clone.childNodes[3].replaceChild(endingc, clone.childNodes[3].getElementsByClassName("clockpicker")[1]);
            //clone.childNodes[3].getElementsByClassName("clockpicker")[1].id=clone.childNodes[3].getElementsByClassName("clockpicker")[1].id+"1";
            alert(clone.childNodes[3].getElementsByClassName("clockpicker")[0].id+"");
            //clone.find(':text').val('').removeClass('hasDatepicker');
            clone.replaceChild(z,clone.childNodes[13]);
            row.insertAdjacentElement("afterend", clone);
            var latest_row=document.getElementById(clone.id);
             
            //assignClockPicker();
        }
        function removeRow(ix)
        {
            var row = document.getElementById(ix+"_row");
            row.parentNode.removeChild(row);
        }
    </script>
<!-- Stylesheets -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">    
                                
    <table id="show_table" class="table table-hover table-bordered table-list">
                  <thead>
                    <tr>
                        <th  class="col-md-1" scope="col"><em class="fa fa-cog"></em></th>
                        <th  class="col-md-1" scope="col">Working Hours</th>
                        <th  class="col-md-2" scope="col">Project Type</th>
                        <th  class="col-md-2" scope="col">Project List</th>
                        <th  class="col-md-2" scope="col">Activity Group</th>
                        <th  class="col-md-2" scope="col">Activity</th>
                        <th  class="col-md-1"  scope="col"></th>
                    </tr> 
                  </thead>
                  <tbody id="tablez_body">
                      <%
                      
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
                              <!--<a class="btn btn-default"><em class="fa fa-pencil"></em></a>
                              <a class="btn btn-danger"><em class="fa fa-trash"></em></a>-->
                              <%
                              out.print(formated_date);
                              %>
                            </td>
                            <td class="col-md-1">
                                <div id="<%=formated_date+"_startc"%>"  style="width:100px" class="input-group clockpicker" data-placement="right" data-align="top" data-autoclose="true">
                                <input style="width:100%;" type="text" class="form-control" value="09:00">
                                <span class="input-group-addon">
                                <span class="glyphicon glyphicon-time">
                                </span>
                                </span>
                                </div>
                                <!-- End Time details -->
                                <div id="<%=formated_date+"_endc"%>" style="width:100px" class="input-group clockpicker" data-placement="right" data-align="top" data-autoclose="true">
                                <input style="width:100%;" type="text" class="form-control" value="18:00">
                                <span class="input-group-addon">
                                <span class="glyphicon glyphicon-time">
                                </span>
                                </span>
                                </div>
                            </td>
                            <td class="col-md-2"><jsp:include page="load_project_type.jsp" /></td>
                            <td class="col-md-2"><jsp:include page="load_project_list.jsp" /></td>
                            <td class="col-md-2"> <jsp:include page="load_activity_list.jsp" /></td>
                            <td class="col-md-2"><jsp:include page="load_activity.jsp" /></td>
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
     function bindClockPicker() {
        $('.clockpicker').clockpicker({
            placement: 'right',
            align: 'top',
            autoclose: 'true'
        });
        }   
     </script>
</html>
