package com.works;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class Login extends HttpServlet{
	
	public Login() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		
		response.setContentType("text/html");
		//PrintWriter out = response.getWriter();
		
		String psno=request.getParameter("psno");
		String pass=request.getParameter("password");
		
		boolean status=false;
		 try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lnttic", "root", "root"); 
		    String query = "select name,psno,password,usertype from userdata where psno=? and password=? ";
		    
		    PreparedStatement ps = con.prepareStatement(query); 
		    ps.setString(1,psno);
			ps.setString(2,pass);
			ResultSet rs=ps.executeQuery();
		    
			status=rs.next();
			
                        
			if(status) {
                                String usertype=rs.getString(4);
				if(usertype.equals("user")) {
                                        Cookie loginCook= new Cookie("timesheet_psno",psno);
                                        Cookie loginCook2= new Cookie("timesheet_name",rs.getString(1));
                                        //loginCook.setMaxAge(30*60);
                                        //loginCook2.setMaxAge(30*60);
                                        response.addCookie(loginCook);
                                        response.addCookie(loginCook2);
								response.sendRedirect("userform.jsp");
				}
				else {
                                        String pattern = "MM";
                                        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
                                        String month_created=simpleDateFormat.format(new Date());
                                        Cookie loginCook= new Cookie("timesheet_psno",psno);
                                        Cookie loginCook2= new Cookie("timesheet_name",rs.getString(1));
                                        Cookie monSet= new Cookie("show_month",month_created);
                                        
                                        //monSet.setMaxAge(30*60);
                                        //loginCook.setMaxAge(30*60);
                                        //loginCook2.setMaxAge(30*60);
                                        
                                        
                                        response.addCookie(monSet);
                                        response.addCookie(loginCook);
                                        response.addCookie(loginCook2);
                                        response.sendRedirect("dashboard.jsp");
				}
			}
			else { 
			   RequestDispatcher rd = request.getRequestDispatcher("home.jsp");
                  request.setAttribute("failure", "Login Failed");
			   rd.forward(request, response);
			}
		    con.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
               System.out.println(e.toString());
			e.printStackTrace();
		}
		 
	}

}
