<%-- 
    Document   : load_table
    Created on : Aug 19, 2019, 2:58:30 AM
    Author     : ravi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    
    <%
    String userName = null,userYear=null;
    Cookie[] cookies = request.getCookies();
    if(cookies !=null){
    for(Cookie cookie : cookies){
		if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
		if(cookie.getName().equals("timesheet_load_year")) userYear = cookie.getValue();
    	}
    }
    if((userName == null)) 
        response.sendRedirect("home.jsp");
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
    <script src="https://cdn.jsdelivr.net/npm/promise-polyfill@8/dist/polyfill.js"></script>
    
    
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

<div class="container-fluid" style="padding: 0px;">
    <div class="col-md-12 col-sm-12 col-lg-12 sticky-top align-self-center align-top">
        <nav class="navbar navbar-expand-md navigation-clean" style="margin-bottom: 5px">       
		<img class="img-fluid" onclick="sendmeBack()"  style="height:auto" src="assets/images/swclogo.png">
		<button class="navbar-toggler" data-toggle="collapse" data-target="#navcol-1">
		<span class="sr-only">Toggle navigation</span>
		<span class="navbar-toggler-icon"></span>
		</button>
            <div class="collapse navbar-collapse" id="navcol-1" >
                <ul class="nav navbar-nav ml-auto" style="float:right;">
                    <li class="nav-item" role="presentation">
                        <a href="userform_tile.jsp">
                        <span class="glyphicon glyphicon-home"></span>
                        </a>
                    </li>
                    <li class="nav-item" role="presentation" style="font-size:18px">
                        <a href="#" class="btn btn-light btn-lg">
                            <span class="glyphicon glyphicon-user"></span> <%out.println(userName);%>
                        </a>
                    </li>
                    <li class="nav-item" role="presentation" style="font-size:18px">
                        <a href="logout.jsp" class="btn btn-md">
                            <span class="glyphicon glyphicon-log-out"></span> Log out
                        </a>
                    </li>
                </ul>
            </div>
        
        </nav>
    </div>
        <div class="col-md-12 col-lg-12">
            <div class="panel panel-default panel-table" >
                <div class="panel-heading col-md-12" style="padding: 0px;height: 60px" >
                  <div class="d-flex flex-row bd-highlight col-md-6 col-sm-6" >  
                       
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
                        <button onclick="sendtoWorking()" id="save" class="btn btn-danger" type="button" style="border:none;width:80px;height:35px;margin-left:14px;margin-top:7px;background-color:#464881;color:rgb(255,255,255);">
                        Save
                        </button>
                      <button onclick="sendtoDB()" id="finalsubmit" class="btn btn-danger" type="button" style="border:none;width:80px;height:35px;margin-left:14px;margin-top:7px;background-color:#464881;color:rgb(255,255,255);">
                      Submit
                     </button>
              </div>

        </div>
    </div>
</div>  
<script async defer type="text/javascript">
var nmop;
function sendmeBack()
    {
    	window.history.back();
    }
    
$(document).ready(function() {
			var nmnm=getCookie("timesheet_load_month");
    		nmop=getCookie("timesheet_load_year");
    		tasting(nmnm,nmop); 
        });
function tasting(txt,txt2){
            $("#infoo").css("display","none");
            var month = new Array("January","February","March","April","May","June","July","August","September","October","November","December");
            let monint = 0;
            month.forEach(function(element,i){
                if(txt==element)
                    monint=i;
            });
            let current_year=parseInt(txt2);
            var date = new Date(Date.UTC(current_year, monint, 1));
            var days = [];
            while (month[date.getMonth()] === txt) {
            days.push(new Date(date));
            date.setDate(date.getDate() + 1);
            }
            initialize_tablecontent(days);
        }
        
        function initialize_tablecontent(limit)
        {
            $("#panel_bodyy").load("table_content_personal.jsp","dayz="+limit+"");
            
        }
        function sendtoDB()
        {
        	showInfo2();
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
                console.log(datte+"is the current row");
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
                remarks=current_row.find("td:eq(6)").find("textarea:eq(0)").val();
                //alert(remarks);
                //var col3=current_row.find("td:eq(2)").text();
                itemx = {}
                itemx ["starttime"] = start_time;
                itemx ["endtime"] = end_time;
                itemx ["date"]=datte+" "+nmop;
                itemx ["ptype"]=project_type;
                itemx ["plist"]=project_list;
                itemx ["agroup"]=act_group;
                itemx ["alist"]=act_list;
                itemx ["remarks"]=remarks;
                joshObj.push(itemx);
                });
            $.ajax({
                type: "POST",
                url: "DataFeed2",
                data: {sanding:JSON.stringify(joshObj)},
                success : function(responseText) {
                    if(responseText!="")
                    showError(responseText);
                    }
                });
         }
function sendtoWorking()
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
                remarks=current_row.find("td:eq(6)").find("textarea:eq(0)").val();
                //alert(remarks);
                //var col3=current_row.find("td:eq(2)").text();
                itemx = {}
                itemx ["starttime"] = start_time;
                itemx ["endtime"] = end_time;
                itemx ["date"]=datte+" "+nmop;
                itemx ["ptype"]=project_type;
                itemx ["plist"]=project_list;
                itemx ["agroup"]=act_group;
                itemx ["alist"]=act_list;
                itemx ["remarks"]=remarks;
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
                document.getElementById("save").disabled=false;
            }
            else
            {
                inputField.style.backgroundColor = '#fba';
                document.getElementById("finalsubmit").disabled=true;
                document.getElementById("save").disabled=true;
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
        title: 'Success',
        text: "Record saved.",
        type: 'info',
        confirmButtonText: 'Ok'
        });
    }
function showInfo2()
{
	const swalWithBootstrapButtons = Swal.mixin({
		  customClass: {
		    confirmButton: 'btn btn-success',
		    cancelButton: 'btn btn-danger'
		  },
		  buttonsStyling: false
		})

		swalWithBootstrapButtons.fire({
		  title: 'Are you sure?',
		  text: "Once submitted, the records will be non-editable and can be viewed only.",
		  type: 'warning',
		  showCancelButton: true,
		  cancelButtonClass: 'mr-3',
		  confirmButtonText: 'Yes, submit!',
		  cancelButtonText: 'Cancel!',
		  reverseButtons: true
		}).then((result) => {
		  if (result.value) {
			  sendtoBhai();
		    swalWithBootstrapButtons.fire(
		      'Success!',
		      'Your timesheet has been submitted.',
		      'success'
		    )
		    window.setTimeout(function(){ window.location="userform_tile.jsp"; } ,3000);
		  }
		})
    
} 
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
