package com.works;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DataFeed extends HttpServlet{
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		  response.setContentType("text/html");
		  PrintWriter out = response.getWriter();  
		  String datez = request.getParameter("sanding");
		  String userPsno = null,viewing_month=null,userName=null;
            Cookie[] cookies = request.getCookies();
            if(cookies !=null){
                for(Cookie cookie : cookies){
                	if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
                    if(cookie.getName().equals("timesheet_psno")) userPsno = cookie.getValue();
                    if(cookie.getName().equals("timesheet_load_month")) viewing_month = cookie.getValue();
                }
            }
            try{
          	  Connection conn=new getConnection().getConnection();
          	  Statement updateSS=conn.createStatement();
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
          	  updateSS.executeUpdate("update userstatus set status='Working' where name='"+userName+"' and psno="+userPsno+" and month="+viewing_month_int);          	  
          	  updateSS.close();
          	  conn.close();
            }
            catch(Exception e)
            {
          	  e.printStackTrace();
            }
            JsonElement joshObj=null;
		   try {
                   boolean status=false;
                   getConnection conoff=new getConnection();
			       Connection con = conoff.getConnection();
                   PreparedStatement valid_check=con.prepareStatement("select userdata.moncreate,userdata.domain from userdata where psno="+Integer.parseInt(userPsno));
                   ResultSet vrs=valid_check.executeQuery();
                   vrs.next();
                   int vmonth=Integer.parseInt(vrs.getString(1));
                   String domainz=vrs.getString(2);
                   vrs.close();
                   valid_check.close();
                  
                   PreparedStatement prepS = con.prepareStatement("insert into details(psno,domain,subfunction,project,activitygroup,activity,date,fromtime,totime,hrs,remarks,month,year) values(?,?,?,?,?,?,?,?,?,?,?,?,?) ");
                   con.setAutoCommit(false);
                   
                   //Parsing loogic
                   JsonParser jp = new JsonParser();
                   JsonElement je = jp.parse(datez);
                   JsonArray jaaray=je.getAsJsonArray();
                   
                   for(int i=0;i<jaaray.size();i++)
                   {
                    joshObj= jaaray.get(i);
                   org.json.JSONObject off=new org.json.JSONObject (joshObj.toString());
                   
                   String agroup=off.get("agroup").toString().trim();
                   String alist=off.get("alist").toString().trim();
                   String starttime=off.get("starttime").toString().trim();
                   String endtime=off.get("endtime").toString().trim();
                   String date=off.get("date").toString().trim();
                   //System.out.println(date);
                   String ptype=off.get("ptype").toString().trim();
                   String plist=off.get("plist").toString().trim();
                   String remarks=off.getString("remarks").toString().trim();
                   if(vmonth>Integer.parseInt(getMonth(date)))
                         status=true;
                   
                   PreparedStatement prepS_del=con.prepareStatement("delete from details where psno="+Integer.parseInt(userPsno)+" and domain like '"+domainz+"' and date like '"+modif_date(date)+"'");
                   prepS_del.executeUpdate();
                   if(agroup.length()>1&&alist.length()>1&&starttime.length()>1&&endtime.length()>1&&date!=null&&ptype.length()>1&&plist.length()>1&&userPsno!=null&&status!=true)
                       {
                       	   prepS.setInt(1, Integer.parseInt(userPsno));
                           prepS.setString(2, domainz);
                           prepS.setString(3, plist);
                           prepS.setString(4, ptype);
                           prepS.setString(5, agroup);
                           prepS.setString(6, alist);
                           prepS.setString(7, modif_date(date));
                           prepS.setString(8, starttime);
                           prepS.setString(9, endtime);
                           prepS.setFloat(10, Float.parseFloat(getHours(starttime, endtime)));
                           prepS.setString(11, remarks);
                           prepS.setInt(12, Integer.parseInt(getMonth(date)));
                           prepS.setInt(13, Integer.parseInt(getYear(date)));
                           
                           prepS.addBatch();
                           //System.out.println("Good");
                       }
                   //System.out.println(agroup+alist+starttime+endtime);
                   }
                   prepS.executeBatch();
                   con.commit();
                   prepS.close();
                   con.close();
                   if(status)
                   {
                       System.out.print("hmm");
                       //request.setAttribute("ffailure", "Not authorized to fill for selected month");
                       response.getWriter().print("Not authorized to fill for selected month");
                   }
                 }
             catch (Exception e) 
              {
            	 System.out.println(joshObj.toString());
                 e.printStackTrace();
              } 
		  }
     
     private String getHours(String f1,String f2)
     {
         double hxx=0.0;
         try{
         SimpleDateFormat format = new SimpleDateFormat("HH:mm");
         Date date1 = format.parse(f1);
         Date date2 = format.parse(f2);
         long difference = date2.getTime() - date1.getTime();
         hxx=(difference*0.001)/3600;
         }
         catch(Exception e)
         {
             
         }
         return hxx+"";   
     }
     
     private String getMonth(String zxc)
     {
         String pattern = "MM";
         SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
         String month_created=simpleDateFormat.format(Date.parse(zxc));
         if(month_created!=null)
            return month_created;
         else
             return "";
     }
     
     private String getYear(String zxcv)
     {
         String pattern = "yyyy";
         SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
         String year_created=simpleDateFormat.format(Date.parse(zxcv));
         if(year_created!=null)
            return year_created;
         else
             return "";
     }
     
     private String modif_date(String x)
     {
         String pattern = "yyyy-MM-dd";
         SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
         String datez=simpleDateFormat.format(Date.parse(x));
         if(datez!=null)
            return datez;
         else
             return "";
     }
}
