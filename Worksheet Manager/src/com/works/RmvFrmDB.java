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
 * Servlet implementation class RmvFrmDB
 */
@WebServlet("/RmvFrmDB")
public class RmvFrmDB extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RmvFrmDB() {
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
		// TODO Auto-generated method stub
				response.setContentType("text/html");
				  PrintWriter out = response.getWriter();  
				  String firsttab =null, con_add=null;
				  firsttab= request.getParameter("tab");
				  con_add= request.getParameter("valz"); 
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
		          
		          String query_for_delete="";
		          switch(firsttab)
		          {
		          case "subfunction":	query_for_delete+="subfunction where ("+(char)34+"desc"+(char)34+")";
		        	  break;
		          case "activity_group": query_for_delete+="activity_group where ("+(char)34+"desc"+(char)34+")";
	          		break;
		          case "activity_list": query_for_delete+="activity_list where (listing)";
		          	break;
		          case "project_list": query_for_delete+="project_list where (listing)";
		          	break;
		        	  default: return;
		          }
		          //System.out.println(firsttab+" "+con_add);
		          try{
		          	  Connection conn=new getConnection().getConnection();
		          	  PreparedStatement pst=conn.prepareStatement("delete from "+query_for_delete.trim()+" like '"+con_add.trim()+"'");
		          	  pst.executeUpdate();
		          	  pst.close();
		          	  conn.close();
		          	  out.write("Deleted Record");
		          }
		          catch(Exception e)
		          {
		        	  out.write(e.toString());
		        	  System.out.println("AddTodb-- "+e.toString());
		          }
	}

}
