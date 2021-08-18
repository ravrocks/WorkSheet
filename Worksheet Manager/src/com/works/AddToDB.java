package com.works;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AddToDB
 */
@WebServlet("/AddToDB")
public class AddToDB extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddToDB() {
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
		  String firsttab =null, con_add=null;
		  firsttab= request.getParameter("tab");
		  con_add= request.getParameter("valz"); 
		  String userPsno = null,userName=null;
		  //System.out.println("i'm in addtodb");
		  
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
          
          String query_for_insert="";
          switch(firsttab)
          {
          case "subfunction":	query_for_insert+="subfunction("+(char)34+"desc"+(char)34+")";
        	  break;
          case "activity_group": query_for_insert+="activity_group("+(char)34+"desc"+(char)34+")";
          		break;
          case "activity_list": query_for_insert+="activity_list(listing)";
    		break;
          case "project_list": query_for_insert+="project_list(listing)";
    		break;
        	  default: return;
          }
          //System.out.println(firsttab+" "+con_add);
          try{
          	  Connection conn=new getConnection().getConnection();
          	  PreparedStatement pst=conn.prepareStatement("insert into "+query_for_insert.trim()+" values(?)");
          	  pst.setString(1, con_add);
          	  pst.executeUpdate();
          	  pst.close();
          	  conn.close();
          	  out.write("Successfully Added");
          }
          catch(Exception e)
          {
        	  out.write(e.toString().substring(0, 50));
        	  System.out.println("AddTodb-- "+e.toString());
          }
          
          
	}

}
