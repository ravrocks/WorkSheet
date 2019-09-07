<%-- 
    Document   : load_project_type
    Created on : Aug 19, 2019, 3:34:48 AM
    Author     : ravi
--%>
<%@page import="com.works.getConnection"%>
<%@page import="java.io.Console"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<div class="col-md-6">
                    <div class="dropdown">
                        <input type="text" id="browsers22" list="browsers2" autocomplete="off" class="custom-select" style="height: 100%;width: 150px;padding: 10px;font-size: 13px;margin-bottom: 1px;-webkit-appearance: none;-moz-appearance: none;">
                           <datalist id="browsers2">
                            <%
                            try{
                            Class.forName("com.mysql.jdbc.Driver").newInstance();
                            getConnection zz=new getConnection();
                            Connection connection = zz.getConnection();
                            Statement statement = connection.createStatement() ;
                            ResultSet resultset =statement.executeQuery("select * from project_list") ;
                            while(resultset.next())
                            {
                                String descp=resultset.getString("listing");
                                out.println("<option value='"+descp+"' />");
                            }
                            statement.close();
                            resultset.close();
                            connection.close();
                            }
                            catch(Exception e)
                            {
                            out.println(e.toString());    
                            }
                            %>
                               
                        </datalist>
                    </div>
                </div>
                
</html>