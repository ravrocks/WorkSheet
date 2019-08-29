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
		  String userPsno = null;
            Cookie[] cookies = request.getCookies();
            if(cookies !=null){
                for(Cookie cookie : cookies){
                    if(cookie.getName().equals("timesheet_psno")) userPsno = cookie.getValue();
                }
            }
            
		   try {
                   boolean status=false;
                   getConnection conoff=new getConnection();
			    Connection con = conoff.getConnection();
                   PreparedStatement valid_check=con.prepareStatement("select userdata.moncreate from userdata where psno like '"+userPsno+"'");
                   ResultSet vrs=valid_check.executeQuery();
                   vrs.next();
                   int vmonth=Integer.parseInt(vrs.getString(1));
                   vrs.close();
                   valid_check.close();
                   PreparedStatement prepS = con.prepareStatement("insert into details1(psno,projecttype,project,activitygroup,activity,date,fromtime,totime,hrs,month,year) values(?,?,?,?,?,?,?,?,?,?,?) ");
                   con.setAutoCommit(false);
                   
                   //Parsing loogic
                   JsonParser jp = new JsonParser();
                   JsonElement je = jp.parse(datez);
                   JsonArray jaaray=je.getAsJsonArray();
                   for(int i=0;i<jaaray.size();i++)
                   {
                   JsonElement joshObj = jaaray.get(i);
                   org.json.JSONObject off=new org.json.JSONObject (joshObj.toString());
                   String agroup=off.get("agroup").toString();
                   String alist=off.get("alist").toString();
                   String starttime=off.get("starttime").toString();
                   String endtime=off.get("endtime").toString();
                   String date=off.get("date").toString();
                   String ptype=off.get("ptype").toString();
                   String plist=off.get("plist").toString();
                   if(vmonth>=Integer.parseInt(getMonth(date)))
                         status=true;
                   
                   if(agroup.length()>1&&alist.length()>1&&starttime.length()>1&&endtime.length()>1&&date!=null&&ptype.length()>1&&plist.length()>1&&userPsno!=null&&status!=true)
                       {
                           prepS.setString(1, userPsno);
                           prepS.setString(2, ptype);
                           prepS.setString(3, plist);
                           prepS.setString(4, agroup);
                           prepS.setString(5, alist);
                           prepS.setString(6, modif_date(date));
                           prepS.setString(7, starttime);
                           prepS.setString(8, endtime);
                           prepS.setString(9, getHours(starttime, endtime));
                           prepS.setString(10, getMonth(date));
                           prepS.setString(11, getYear(date));
                           prepS.addBatch();
                           System.out.println("Good");
                       }
                   //System.out.println(agroup+alist+starttime+endtime);
                   }
                   prepS.executeBatch();
                   con.commit();
                   prepS.close();
                   con.close();
                   if(status)
                   {
                       System.out.print("fck");
                       //request.setAttribute("ffailure", "Not authorized to fill for selected month");
                       response.getWriter().print("Not authorized to fill for selected month");
                   }
                 }
             catch (Exception e) 
              {
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
         String pattern = "YYYY";
         SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
         String year_created=simpleDateFormat.format(Date.parse(zxcv));
         if(year_created!=null)
            return year_created;
         else
             return "";
     }
     
     private String modif_date(String x)
     {
         String pattern = "YYYY-MM-dd";
         SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
         String datez=simpleDateFormat.format(Date.parse(x));
         if(datez!=null)
            return datez;
         else
             return "";
     }
}
