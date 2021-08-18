package com.works;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class ChangeMonth
 */
@WebServlet(name = "AlterMonth", urlPatterns = { "/AlterMonth" })
public class ChangeMonth extends HttpServlet {
	private static final long serialVersionUID = 1L;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ChangeMonth() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		 response.setContentType("text/html");
		  PrintWriter out = response.getWriter();  
		  String to_change_month =null, to_change_year=null;
		  to_change_month= request.getParameter("mmnth");
		  to_change_year= request.getParameter("yyrth"); 
		  String userPsno = null,userName=null;
		  
		  Cookie[] cookies = request.getCookies();
          if(cookies !=null){
              for(Cookie cookie : cookies){
              	if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
                  if(cookie.getName().equals("timesheet_psno")) userPsno = cookie.getValue();
              }
          }
          else
            	return;
            
            if(userName==null || userPsno==null) return;
            if(!(userName.equals("admin"))||!(userPsno.equals("91827364"))) return;
            
            try{
            	  Connection conn=new getConnection().getConnection();
            	  PreparedStatement pst=conn.prepareStatement("update allowmonth set monn='"+to_change_month.trim()+"',yrrr='"+to_change_year+"' where id=1;");
            	  pst.executeUpdate();
            	  pst.close();
            	  
            	  PreparedStatement pst2=conn.prepareStatement("UPDATE userdata SET fp_counter=0 WHERE fp_counter!=0;");
            	  pst2.executeUpdate();
            	  pst2.close();
            	  
            	  conn.close();
            	  out.write("Success!");
            }
            catch(Exception e)
            {
          	  out.write("Problem while Changing Month"+e.toString().substring(0, 50));
          	  System.out.println("ChangeMonth-- "+e.toString());
            }
	}

}
