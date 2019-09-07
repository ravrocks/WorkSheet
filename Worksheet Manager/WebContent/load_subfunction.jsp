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
           <input id="project_type_buttonz"  aria-expanded="false" list="proj_type" type="text" class="custom-select" style="height: 100%;width: 150px;padding: 10px;font-size: 13px;margin-right: 0px">
                        <datalist id="proj_type" >
                            <%
                            Class.forName("com.mysql.jdbc.Driver").newInstance();
                            getConnection zz=new getConnection();
                            Connection connection = zz.getConnection();
                            Statement statement = connection.createStatement() ;
                            try{
                            ResultSet resultset =statement.executeQuery("select * from subfunction") ;
                            while(resultset.next())
                                {
                                String descp=resultset.getString("desc");
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