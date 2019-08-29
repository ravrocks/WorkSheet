<%-- 
    Document   : load_table
    Created on : Aug 19, 2019, 2:58:30 AM
    Author     : ravi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    
    <%
    String userName = null;
    Cookie[] cookies = request.getCookies();
    if(cookies !=null){
    for(Cookie cookie : cookies){
	if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
    }
    }
    if(userName == null) response.sendRedirect("home.jsp");
    
    %>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TimeSheet</title>
    <!-- Javascripts -->
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/js/jquery-clockpicker.js"></script>
    <script src="assets/bootstrap/js/bootstrap.min.js"></script>
    <script src="assets/js/moment.js"></script>
    <script src="assets/js/sweetalert2.all.min.js"></script>
    
    <!-- Stylesheets -->
    <link href="assets/js/jquery-clockpicker.css" rel="stylesheet"/>
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/fonts/font-awesome.min.css">
    <link rel="stylesheet" href="assets/css/MUSA_panel-table.css">
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="assets/css/sticky-dark-top-nav-with-dropdown.css">
    <link rel="stylesheet" href="assets/css/Team-Grid.css">
    <link rel="stylesheet" href="assets/css/text-box.css">
    <link rel="stylesheet" href="assets/css/dh-navbar-inverse.css">
    
</head>
<body>

<div class="container-fluid">
    <div class="col-md-12 col-sm-12 sticky-top align-self-center align-top">
        <nav class="navbar navbar-expand-md navigation-clean" style="margin-bottom: 5px">
        
		<img class="img-fluid" style="height:auto" src="assets/images/swclogo.png">
		<button class="navbar-toggler" data-toggle="collapse" data-target="#navcol-1">
		<span class="sr-only">Toggle navigation</span>
		<span class="navbar-toggler-icon"></span>
		</button>
            <div class="collapse navbar-collapse" id="navcol-1" >
                <ul class="nav navbar-nav ml-auto" style="float:right;">
                    <li class="nav-item" role="presentation" style="font-size:18px"><a uk-scroll="offset:100">Welcome&nbsp;<%out.println(userName);%></a></li>
                    <li class="nav-item" role="presentation" style="font-size:18px"><a href="logout.jsp" uk-scroll="offset:50">Logout</a></li>
                </ul>
            </div>
        
        </nav>
    </div>
    <div class="col-md-12">
        <span id="infoo" style="font-size: 18px;font-family: Verdana, Geneva, sans-serif">Select month from the drop-down menu below and enter your work details.</span>
    </div>
        <div class="col-md-12">
            <div class="panel panel-default panel-table" >
                <div class="panel-heading col-md-12" style="padding: 0px;height: 60px" >
                  <div class="d-flex flex-row bd-highlight col-md-6 col-sm-6" >  
                        <div class="p-2 bd-highlight" style="margin-top: 2px;margin-left:-15px">
                            <div class="dropdown">
                            <button id="monthButton" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" aria-expanded="false" type="button">
                                Select month
                            </button>
                            <div id="monthMenu" class="dropdown-menu" role="menu">
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
                        </div>
                  </div>
                <div class=" d-flex flex-row-reverse bd-highlight col-md-6 col-sm-6" >
                  <div id="detailz1" class="order-2" style="visibility: hidden;margin-right: 15px;margin-top:20px;font-size: 16px" >Page 1</div>
                  <div id="detailz2" class="order-1" style="visibility: hidden;">
                            <ul id="pagination-here" class="pagination" style="margin-top:5px" >
                            </ul>
                  </div>
                </div>
              </div>
                
              <div id="panel_bodyy" class="panel-body table-responsive">
                
              </div>
                
              <div id="footing" class="panel-footer" style="visibility: hidden;text-align: center">
                  <button onclick="sendtoBhai()" id="finalsubmit" class="btn btn-danger" type="button" style="border:none;width:100px;height:40px;margin-left:14px;background-color:#464881;color:rgb(255,255,255);">
                      Submit
                  </button>
              </div>

        </div>
    </div>
</div>  
    <script async defer type="text/javascript">
        //Month initializing script
        
        $("#monthMenu a").click(function(e){
            e.preventDefault(); // cancel the link behaviour
            var txt = $(this).text();
            $("#monthButton").text(txt);
            $("#infoo").css("display","none");
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
            let monint = 0;
            month.forEach(function(element,i){
                if(txt==element)
                    monint=i;
            });
            var date = new Date(Date.UTC(2019, monint, 1));
            var days = [];
            while (month[date.getMonth()] === txt) {
            days.push(new Date(date));
            date.setDate(date.getDate() + 1);
            }
            //initialize_navbar(days);
            initialize_tablecontent(days);
        });
        
        function initialize_tablecontent(limit)
        {
            $("#panel_bodyy").load("table_content.jsp","dayz="+limit+"");
            
        }
        
        function sendtoBhai()
        {
            let mn=0;
            var last_dated;
            var joshObj=[];
            var start_time,end_time,project_type,project_list,act_group,act_list;
            $("#show_table tr").each(function(){
                if(mn==0)
                    {
                        mn++;
                        return true;
                    }
                var current_row=$(this);
                var datte=current_row.find("td:eq(0)").text();
                if(datte.length<2)
                    datte=last_dated;
                else
                    last_dated=datte;
                start_time=current_row.find("td:eq(1)").find("input:eq(0)").val();
                end_time=current_row.find("td:eq(1)").find("input:eq(1)").val();
                project_type=current_row.find("td:eq(2)").find("input:eq(0)").val();
                project_list=current_row.find("td:eq(3)").find("input:eq(0)").val();
                act_group=current_row.find("td:eq(4)").find("input:eq(0)").val();
                act_list=current_row.find("td:eq(5)").find("input:eq(0)").val();
                //var col3=current_row.find("td:eq(2)").text();
                itemx = {}
                itemx ["starttime"] = start_time;
                itemx ["endtime"] = end_time;
                itemx ["date"]=datte;
                itemx ["ptype"]=project_type;
                itemx ["plist"]=project_list;
                itemx ["agroup"]=act_group;
                itemx ["alist"]=act_list;
                joshObj.push(itemx);
                });
            $.ajax({
                type: "POST",
                url: "DataFeed",
                data: {sanding:JSON.stringify(joshObj)},
                success : function(responseText) {
                    if(responseText!="")
                    showError(responseText);
                    else
                    showInfo();
                    }
                });
         }
        function validateHhMm(inputField) {
            var areValid = /^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/.test(inputField.value);
            if (areValid)
            {
                inputField.style.backgroundColor = '#bfa';
                document.getElementById("finalsubmit").disabled=false;
            }
            else
            {
                inputField.style.backgroundColor = '#fba';
                document.getElementById("finalsubmit").disabled=true;
            }
        
            return areValid;
        }
function showError(txxt)
    {
        Swal.fire({
        title: 'Data Submission Error',
        text: txxt,
        type: 'error',
        confirmButtonText: 'Ok'
        });
    }
function showInfo()
    {
        Swal.fire({
        title: 'Successfully added.',
        type: 'info',
        confirmButtonText: 'Ok'
        });
    }    
    </script>
</body>
</html>
