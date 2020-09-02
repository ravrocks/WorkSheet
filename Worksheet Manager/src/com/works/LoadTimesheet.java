package com.works;
import com.google.common.primitives.Ints;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import org.json.JSONObject;
import java.sql.*;
import org.apache.commons.lang.WordUtils;

public class LoadTimesheet extends HttpServlet{

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		String setting_time_month = request.getParameter("timing_month");
		String userPsno = null;
	    Cookie[] cookies = request.getCookies();
	    if(cookies !=null)
	    {
	    for(Cookie cookie : cookies){
		if(cookie.getName().equals("timesheet_psno")) userPsno = cookie.getValue();
	    	}
	    }
         try{
         JsonParser jp = new JsonParser();
         JsonElement je = jp.parse(setting_time_month);
         String selection=WordUtils.capitalizeFully(je.getAsString());
         //System.out.println(selection);
         
         Connection conn=new getConnection().getConnection();
         PreparedStatement stmnt_for_month=conn.prepareStatement("select * from allowmonth");
         ResultSet rss_for_month=stmnt_for_month.executeQuery();
         rss_for_month.next();
         String got_month=rss_for_month.getString(2);
         //for setting year
         Integer yrrr=Ints.tryParse(rss_for_month.getString(3));
         Cookie yrrSet= new Cookie("timesheet_load_year",yrrr.toString());
    	 response.addCookie(yrrSet);
         
    	 rss_for_month.close();
         stmnt_for_month.close();
         
         int got_monthz=returnMonnum(got_month);
         int selected_monthz=returnMonnum(selection);
         //System.out.println(got_monthz+"  "+selected_monthz);
         
         if((selected_monthz==got_monthz)||((selected_monthz==(got_monthz-1))&&got_monthz!=1))
 			{     	 
        	 PreparedStatement ssttmm=conn.prepareStatement("select count(psno) from userstatus where psno="+Integer.parseInt(userPsno)+" and month="+returnMonnum(selection)+" and year='"+yrrr+"'");
        	 ResultSet rrss=ssttmm.executeQuery();
        	 rrss.next();
        	 int size=(rrss.getInt(1));
        	 ssttmm.close();
        	 conn.close();
        	 if(size==0)
        	 {
        	 Cookie monSet= new Cookie("timesheet_load_month",selection);
        	 response.addCookie(monSet);
        	 response.getWriter().print("newly");
        	 }
        	 else
        	 {
        		 Cookie monSet= new Cookie("timesheet_load_month",selection);
            	 response.addCookie(monSet);
        		 response.getWriter().print("existing");
        	 }
 			}
         else
 			{
 			   conn.close();
 			}
         }
         catch(Exception e)
         {
             e.printStackTrace();
         }
	}
	private int returnMonnum(String hh)
	{
		String opp[]= {"January","February","March","April","May","June","July","August","September","October","November","December"};
		for(int k=0;k<opp.length;k++)
		{
			if(opp[k].equalsIgnoreCase(hh))
				return k+1;
		}
		return 0;
	}
}
