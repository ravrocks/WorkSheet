
<%@page import="com.works.getConnection"%>
<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%
    String userName = null;
    String showMonth=null,showYear=null;
    Cookie[] cookies = request.getCookies();
    if(cookies !=null){
    for(Cookie cookie : cookies){
	if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
        if(cookie.getName().equals("show_month")) showMonth = cookie.getValue();
        if(cookie.getName().equals("show_year")) showYear = cookie.getValue();
     }
    }
    if(userName == null) response.sendRedirect("home.jsp");
    
    String total="4",filled="2",pending = "2";
    //code for populating numbers
    if(showMonth!=null)
    {
   
    try{
    Connection connectionn = new getConnection().getConnection();
    Statement statementt=connectionn.createStatement();
    String fquery="select count(*) from userdata where moncreate<="+Integer.parseInt(showMonth)+" and usertype='user'";
    String squery="select count(distinct userstatus.name) from userstatus where userstatus.month="+Integer.parseInt(showMonth)+" and status='Submitted' and year='"+showYear+"'";
    String tquery="select count(distinct userdata.name) from userdata where moncreate<="+Integer.parseInt(showMonth)+" and usertype='user'"+" and userdata.psno not in (select distinct userstatus.psno from userstatus,userdata where userdata.psno=userstatus.psno and userstatus.month="+Integer.parseInt(showMonth)+" and status like 'Submitted' and year='"+showYear+"')";
    ResultSet ress=statementt.executeQuery(fquery);
    ress.next();
    total=ress.getString(1);
    ress=statementt.executeQuery(squery);
    ress.next();
    filled=ress.getString(1);
    ress=statementt.executeQuery(tquery);
    ress.next();
    pending=ress.getString(1);
    ress.close();
    statementt.close();
    connectionn.close();
    	}
        catch(Exception e)
        {
         System.out.println("here only");
         e.printStackTrace();
        }
    }
%>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TimeSheet</title>
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/js/Animated-numbers-section.js"></script>
    <script src="assets/js/Grid-and-List-view-V10.js"></script>
    
    <!-- Css files  -->
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/fonts/simple-line-icons.min.css">
    <link rel="stylesheet" href="assets/css/Animated-numbers-section.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="assets/css/Team-Grid.css">
    <link rel="stylesheet" href="assets/css/text-box.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Cookie">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
    <link rel="stylesheet" href="assets/css/dh-navbar-inverse.css">
    
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
</head>

<body>
    
    <section class="wrapper-numbers">
        <div class="container-fluid">
            <div class="row countup">
               <div class="col-md-12 col-sm-6 sticky-top align-self-center align-top" style="margin-top: -60px;padding:0px">
                    <nav class="navbar navbar-expand-md navigation-clean " style="-webkit-border-radius: 0;-moz-border-radius: 0;border-radius: 0;">
                    <img class="img-fluid" style="height:auto" src="assets/images/swclogo.png">
                    <button class="navbar-toggler" data-toggle="collapse" data-target="#navcol-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navcol-1" >
                    <ul class="nav navbar-nav ml-auto" style="float:right;">
                        <li class="nav-item" role="presentation" style="font-size:18px">
                            <a href="#" class="btn btn-light btn-lg">
                                <span class="glyphicon glyphicon-user"></span> <%out.println(userName);%>
                            </a>
                        </li>
                        <li class="nav-item" role="presentation">
                            <a href="logout.jsp" class="btn btn-md">
                                <span class="glyphicon glyphicon-log-out"></span> Log out
                            </a>
                        </li>
                    </ul>
                    </div>
                    </nav>
                </div>
                    
                <div class="col-sm-6 col-md-3 column"> 
                    <div class="dropdown">
                    <button id="monthButton" class="btn-lg btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" >Month</button>
                    	<div id="monthMenu" class="dropdown-menu " role="menu" >
							<a class="dropdown-item" role="presentation" >January</a>
		            		<a class="dropdown-item" role="presentation" >February</a>
							<a class="dropdown-item" role="presentation" >March</a>
							<a class="dropdown-item" role="presentation" >April</a>
		                	<a class="dropdown-item" role="presentation" >May</a>
							<a class="dropdown-item" role="presentation" >June</a>
							<a class="dropdown-item" role="presentation" >July</a>
							<a class="dropdown-item" role="presentation" >August</a>
							<a class="dropdown-item" role="presentation" >September</a>
							<a class="dropdown-item" role="presentation" >October</a>
							<a class="dropdown-item" role="presentation" >November</a>
							<a class="dropdown-item" role="presentation" >December</a>
						</div>
					</div>
					<div class="dropdown" style="margin-top:5px">
					 <button id="yearButton" class="btn-lg btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" >Year</button>
					 	<div id="yearMenu" class="dropdown-menu " role="menu" >
					 		<a class="dropdown-item" role="presentation" >2019</a>
					 		<a class="dropdown-item" role="presentation" >2020</a>
					 	</div>
                    </div>       
                    <h2 style="margin-top:10px">Select Duration</h2>
                </div>
                <div class="col-sm-6 col-md-3 column">
                    
                    <p><span class="count"><%out.print(total);%></span></p>
                    <h2><a style="color:black" onclick="basicPopup(this.href);return false" href="list.jsp?&type=total"> Total Users</a></h2>
                </div>
                <div class="col-sm-6 col-md-3 column">
                    
                    <p> <span class="count"><%out.print(filled);%></span></p>
                    <h2><a style="color:black" onclick="basicPopup(this.href);return false" href="list.jsp?&type=filled">TimeSheets Filled</a></h2>
                </div>
                <div class="col-sm-6 col-md-3 column">
                    
                    <p> <span class="count"><%out.print(pending);%></span></p>
                    <h2><a style="color:black" onclick="basicPopup(this.href);return false" href="list.jsp?&type=pending">Pending Timesheets</a></h2>
                </div>
            </div>
        </div>
    </section>
    <section>
    <div class="card" style="margin-top: -40px">
                <div class="card-header">
                    <ul class="nav nav-tabs card-header-tabs" role="tablist">
                        <li class="nav-item"><a class="nav-link active" href="#item-1-1" id="item-1-1-tab" data-toggle="tab" role="tab" aria-controls="item-1-1" aria-selected="true">Individual Reports</a></li>
                        <li class="nav-item"><a class="nav-link" href="#item-1-2" id="item-1-2-tab" data-toggle="tab" role="tab" aria-controls="item-1-2" aria-selected="false">Project Wise Reports</a></li>
                        <li class="nav-item"><a class="nav-link" href="#item-1-3" id="item-1-3-tab" data-toggle="tab" role="tab" aria-controls="item-1-3" aria-selected="false">Consolidated Report</a></li>
                    </ul>
                </div>
         
            <div class="card-body" >
                <div id="nav-tabContent" class="tab-content">
	                <div style="color: #000;text-align: left" id="item-1-1" class="tab-pane active" role="tabpanel" aria-labelledby="item-1-1-tab">
	                    <jsp:include page="supervisor.jsp" />
	                </div>
	                <div id="item-1-2" class="tab-pane fade" role="tabpanel" aria-labelledby="item-1-2-tab">
	                	<jsp:include page="projectwise.jsp" />
	                </div>
	                <div id="item-1-3" class="tab-pane fade" role="tabpanel" aria-labelledby="item-1-3-tab">
	                	<jsp:include page="allreport.jsp" />
	                </div>
                </div>
            </div>
     </div>
    </section>
    <script type="text/javascript">
        
    var month = new Array("January","February","March","April","May","June","July","August","September","October","November","December");
    var setyear=null,setmonth=null;
            
         function getCookie(cname) {
                var name = cname + "=";
                var decodedCookie = decodeURIComponent(document.cookie);
                var ca = decodedCookie.split(';');
                for(var i = 0; i <ca.length; i++) {
                    var c = ca[i];
                while (c.charAt(0) == ' ') {
                    c = c.substring(1);
                    }
                if (c.indexOf(name) == 0) {
                return c.substring(name.length, c.length);
                }
              }
               return "";
            }
        //Month initializing script
        $( document ).ready(function() {
        setmonth = getCookie("show_month");
        if (setmonth != "") {
            $("#monthButton").text(month[setmonth-1]);
        }
        setyear= getCookie("show_year");
        if(setyear!="")
        	$("#yearButton").text(setyear);
        });
        
        $("#monthMenu a").click(function(e){
            e.preventDefault(); // cancel the link behaviour
            var txt = $(this).text();
            $("#monthButton").text(txt);
            
            let monint = 0;
            month.forEach(function(element,i){
                if(txt==element)
                    monint=i;
            });
            monint+=1;
            $.ajax({
                type: "POST",
                url: "MonthSet",
                data: "&set_month="+monint+"&set_year="+setyear,
                success : function(responseText) {
                    location.reload(false);
                }
            });
        });
        
        $("#yearMenu a").click(function(e){
            e.preventDefault(); // cancel the link behaviour
            var txt = $(this).text();
            $("#yearButton").text(txt);
            let monint = 0;
            var txt2=document.getElementById("monthButton").innerHTML;
            month.forEach(function(element,i){
                if(txt2==element)
                    monint=i;
            });
            monint+=1;
            $.ajax({
                type: "POST",
                url: "MonthSet",
                data: "&set_month="+monint+"&set_year="+ txt,
                success : function(responseText) {
                    location.reload(false);
                }
            });
        });
        
      function basicPopup(url) {
popupWindow = window.open(url,'popUpWindow','height=600,width=600,left=50,top=50,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no, status=yes');
	}
     </script>
</body>

</html>