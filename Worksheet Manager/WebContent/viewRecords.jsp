
<%@ page import="java.sql.*" %>
<%@ page import="com.works.getConnection" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%
    String userName = null;
    String showMonth=null;
    Cookie[] cookies = request.getCookies();
    if(cookies !=null){
    for(Cookie cookie : cookies){
	if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
        if(cookie.getName().equals("show_month")) showMonth = cookie.getValue();
    }
    }
    if(userName == null) response.sendRedirect("home.jsp");
    
%>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Records</title>
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/js/Grid-and-List-view-V10.js"></script>
    
    <!-- Css files  -->
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/fonts/simple-line-icons.min.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="assets/css/Team-Grid.css">
    <link rel="stylesheet" href="assets/css/text-box.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Cookie">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
    <link rel="stylesheet" href="assets/css/dh-navbar-inverse.css">
    
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
</head>

<body>
    <section>
    <div class="col-md-12 col-sm-6 sticky-top align-self-center align-top" style="margin-top:-20px;padding:0px">
                    <nav class="navbar navbar-expand-md navigation-clean " style="-webkit-border-radius: 0;-moz-border-radius: 0;border-radius: 0;">
                    <img class="img-fluid" style="height:auto" src="assets/images/swclogo.png">
                    <button class="navbar-toggler" data-toggle="collapse" data-target="#navcol-1">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navcol-1" >
                    <ul class="nav navbar-nav ml-auto" style="float:right;">
                        <li class="nav-item" role="presentation"><a uk-scroll="offset:100">Welcome&nbsp;<%out.println(userName);%></a></li>
                        <li class="nav-item" role="presentation"><a href="logout.jsp" uk-scroll="offset:50">Logout</a></li>
                    </ul>
                    </div>
                    </nav>
    </div>
                
    <div class="card">
                <div class="card-header">
                    <ul class="nav nav-tabs card-header-tabs" role="tablist">
                        <li class="nav-item"><a class="nav-link active" href="#item-1-1" id="item-1-1-tab" data-toggle="tab" role="tab" aria-controls="item-1-1" aria-selected="true">Reports</a></li>                                      
                    </ul>
                </div>
         <style>a:hover{font-weight:normal;}</style>
            <div class="card-body" >
                <div id="nav-tabContent" class="tab-content">
                <div style="color: #000;text-align: left" id="item-1-1" class="tab-pane active" role="tabpanel" aria-labelledby="item-1-1-tab">
                    <jsp:include page="userHistory.jsp" />
                </div>
                </div>
            </div>
     </div>
    </section>
    <script type="text/javascript">
        
        var month = new Array();
            month[0] = "January";
            month[1] = "February";
            month[2] = "March";
            month[3] = "April";
            month[4] = "May";
            month[5] = "June";
            month[6] = "July";
            month[7] = "August";
            month[8] = "September";
            month[9] = "October";
            month[10] = "November";
            month[11] = "December";
            
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
     </script>
</body>

</html>