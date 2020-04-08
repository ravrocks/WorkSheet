package com.works;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class MonthChange extends HttpServlet{

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		String chngmnth=request.getParameter("set_month"); 
		String chngyear=request.getParameter("set_year");
                //HttpSession sess=request.getSession();
                //sess.setAttribute("show_month",chngmnth);
                Cookie monSet= new Cookie("show_month",chngmnth);
                Cookie yrrSet= new Cookie("show_year",chngyear);
                //monSet.setMaxAge(30*60);
                response.addCookie(monSet);
                response.addCookie(yrrSet);
	}

}
