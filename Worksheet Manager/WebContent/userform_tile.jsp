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
    <title>WorkSheet</title>
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

<div class="container-fluid" style="padding: 0px">
    <div class="col-md-12 col-sm-12 sticky-top align-self-center align-top">
        <nav class="navbar navbar-expand-md navigation-clean" style="margin-bottom: 5px">
        
		<img class="img-fluid" style="height:auto" src="assets/images/swclogo.png">
		<button class="navbar-toggler" data-toggle="collapse" data-target="#navcol-1">
		<span class="sr-only">Toggle navigation</span>
          <span class="navbar-toggler-icon"><i class="fa fa-navicon" style="float: right"></i></span>
		</button>
            <div class="collapse navbar-collapse" id="navcol-1" >
                <ul class="nav navbar-nav ml-auto" style="float:right;">
                    <li class="nav-item" role="presentation" style="font-size:18px"><a uk-scroll="offset:100">Welcome&nbsp;<%out.println(userName);%></a></li>
                    <li class="nav-item" role="presentation" style="font-size:18px"><a href="logout.jsp" uk-scroll="offset:50">Logout</a></li>
                </ul>
            </div>
        
        </nav>
    </div>
    <div class="col-md-12 d-flex justify-content-center" style="display: inline-block;vertical-align: middle;margin-top: 5%"> 
    <script src="assets/js/jquery.min.js"></script>
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <script src="assets/js/bootstrap.min.js"></script>
    <link href="assets/fonts/font-awesome.min.css" rel="stylesheet">
    <link href="assets/css/boottile.css" rel="stylesheet">

	<div class="col-sm-6 col-xs-6 col-md-3">
	<div id="tile7" class="tile">
        <div class="carousel slide" data-ride="carousel">
          <!-- Wrapper for slides -->
          <div class="carousel-inner">
              <div class="item active" onclick="loadNewTimesheet()">
                <figure>
                <img src="assets/images/iconfinder_Asset_85_3298601.svg" class="img-responsive" style="height: 150px"/>
                <figcaption style="font-size: 18px;font-family: Verdana, Geneva, sans-serif;">Create New Timesheet</figcaption>
                </figure>
            </div>
          </div>
        </div>
    </div>
	</div>
	<div class="col-sm-6 col-xs-6 col-md-3">
	  <div id="tile8" class="tile">
         <div class="carousel slide" data-ride="carousel">
          <!-- Wrapper for slides -->
          <div class="carousel-inner">
            <div class="item active" onclick="viewTimesheet()">
                <figure>
                <img src="assets/images/iconfinder_Asset_93_3298612.svg" class="img-responsive" style="height: 150px"/>
                <figcaption style="font-size: 18px;font-family: Verdana, Geneva, sans-serif">View/Edit Timesheet</figcaption>
                </figure>
            </div>
            </div>
         </div>
		</div>
	</div>
    </div>
</div>  

      
<script async defer type="text/javascript">	
$(document).ready(function() {
    $(".tile").height($("#tile1").width());
    $(".carousel").height($("#tile1").width());
     $(".item").height($("#tile1").width());
     
    $(window).resize(function() {
    if(this.resizeTO) clearTimeout(this.resizeTO);
	this.resizeTO = setTimeout(function() {
		$(this).trigger('resizeEnd');
	}, 5);
    });
    
    $(window).bind('resizeEnd', function() {
    	$(".tile").height($("#tile1").width());
        $(".carousel").height($("#tile1").width());
        $(".item").height($("#tile1").width());
    });
});
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
function showError()
    {
        Swal.fire({
        title: 'Error!',
        text: 'Timesheet already exists for the selected month. You can only edit the timesheet if not submitted.',
        type: 'error',
        confirmButtonText: 'Ok'
        });
    }
function showMError(ftt)
{
    Swal.fire({
    title: 'Invalid Input',
    text: ftt,
    type: 'info',
    confirmButtonText: 'Ok'
    });
}
function showInfo()
    {
        Swal.fire({
        title: 'Record Submit',
        text: "Successfully added.",
        type: 'info',
        confirmButtonText: 'Ok'
        });
    }

function loadNewTimesheet()
{
    (async() => {
  const { value: fruit } = await Swal.fire({
  title: 'Month selector',
  input: 'select',
  inputOptions: {
    january: 'January',
    february: 'February',
    march: 'March',
    april: 'April',
    may: 'May',
    june: 'June',
    july: 'July',
    august: 'August',
    september: 'September',
    october:'October',
    november:'November',
    december:'December'
  },
  inputPlaceholder: 'Select a Month',
  showCancelButton: true,
  inputValidator: (value) => {
    return new Promise((resolve) => {
      $.ajax({
                type: "POST",
                url: "LoadTimesheet",
                data: {timing_month:JSON.stringify(value)},
                success : function(responseText) {
                    if(responseText==="newly")
                      window.location="userform_nobutton.jsp";
                    else if(responseText==="existing")
                    	showMError("Timesheet already exits for the selected month.");
                    else
                      showMError("Timesheet can be filled for current month only.");
                    }
                });
    	})
  	}
})
    })();
}


function viewTimesheet()
{
	window.location="viewRecords.jsp";
}
    </script>
</body>
</html>
