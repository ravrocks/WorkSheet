<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>TimeSheet</title>

<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="assets/js/sweetalert2.all.min.js"></script>
<link rel="stylesheet" href="assets/css/login.css">
</head>

<body>
    <img src="assets/images/4.jpg" class="bg"/>
    <div class="container" style="overflow:visible;" >
        <div class="row">
                <div class="col-md-6 col-md-offset-3 " id="login-box">
                    <div class="panel panel-login">
                        <div class="panel-heading">
                        <div class="logo">
                            <img src="assets/images/logo2.png">   
                        </div>
                        <div class="form-group">
                            <div class="row tab-head">
                                <div class="col-xs-6 ">
                                    <a href="#" class="active" id="login-form-link">Login</a>
                                </div>
                                <div class="col-xs-6">
                                    <a href="#" id="register-form-link">Register</a>
                                </div>
                            </div>
                        </div>
						<hr>
					</div>
                    <div class="panel-body">
						<div class="row">
							<div class="col-lg-12 login_signup_container">
								<form id="login-form" action="Login" method="post" role="form" style="display: block;">
									<div class="form-group">
										<input type="text" name="psno" id="username" tabindex="1" class="form-control" placeholder="PS no." required>
									</div>
									<div class="form-group">
										<input type="password" name="password" id="password" tabindex="2" class="form-control" placeholder="Password" required>
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6 col-sm-offset-3">
												<input type="submit" name="login-submit" id="login-submit" tabindex="4" class="form-control btn btn-login" value="Log In">
											</div>
										</div>
									</div>
									
								</form>
                                
								<form id="register-form" action="Registration" method="post" role="form" style="display: none;">
									<div class="form-group">
										<input type="text" name="name" id="name" tabindex="1" class="form-control" placeholder="Employee Name" required>
									</div>
									<div class="form-group">
										<input type="text" name="psno" id="psno" tabindex="1" class="form-control" placeholder="PS no." required>
									</div>
									<div class="form-group">
										<input type="email" name="email" id="email" tabindex="1" class="form-control" placeholder="Email Address" required>
									</div>
									<div class="form-group">
										<input type="text" name="designation" id="designation" tabindex="1" class="form-control" placeholder="Designation" required>
									</div>
									<div class="form-group">
										<input type="password" name="password" id="pass" tabindex="2" class="form-control" placeholder="Password" >
									</div>
									<div class="form-group">
										<input type="password" name="confirmpass" id="confpass" tabindex="2" class="form-control" placeholder="Confirm Password" >
									</div>
									<div class="form-group">
										<span class="error" style="color:red"></span><br />
									</div>
									
									<div class="form-group">
										<div class="row">
											<div class="col-sm-6 col-sm-offset-3">
												<input type="submit" name="register-submit" id="register-submit" tabindex="4" class="form-control btn btn-login" value="Register Now">
											</div>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
                    </div>
                </div> 
        </div>
    </div>
</body>
<script>
$(function() {

    $('#login-form-link').click(function(e) {
		$("#login-form").delay(100).fadeIn(100);
 		$("#register-form").fadeOut(100);
		$('#register-form-link').removeClass('active');
		$(this).addClass('active');
		e.preventDefault();
	});
	$('#register-form-link').click(function(e) {
		$("#register-form").delay(100).fadeIn(100);
 		$("#login-form").fadeOut(100);
		$('#login-form-link').removeClass('active');
		$(this).addClass('active');
		e.preventDefault();
	});
});

var allowsubmit = false;
$(function(){
    
    /*$('#login-submit').on("click",function() {
    // your stuff
    showError();
    }); */
    
	$('#confpass').keyup(function(e){
		//get values 
		var pass = $('#pass').val();
		var confpass = $(this).val();
		
		//check the strings
		if(pass == confpass){
			$('.error').text('');
			allowsubmit = true;
		}else{
			$('.error').text('Password not matching');
			allowsubmit = false;
		}
	});
	
	
	$('#register-form').submit(function(){
	
		var pass = $('#pass').val();
		var confpass = $('#confpass').val();

		if(pass == confpass){
			allowsubmit = true;
		}
		if(allowsubmit){
			return true;
		}else{
			return false;
		}
	});
});

    function showError(txxt)
    {
        Swal.fire({
        title: 'Login Error!',
        text: txxt,
        type: 'error',
        confirmButtonText: 'Retry'
        });
    }
    function showRError(txxt)
    {
        Swal.fire({
        title: 'Registration Error!',
        text: txxt,
        type: 'error',
        confirmButtonText: 'Retry'
        });
    }
    function showSuccess()
    {
        Swal.fire({
        title: 'Success!',
        text: 'Registration is successful.',
        type: 'success',
        confirmButtonText: 'OK'
        });
    }
</script>
<%
String failz=null;
failz=(String)request.getAttribute("failure");
if(failz!=null)
    {
    %>
        <script>
        showError("Incorrect Password or Username entered.") 
        </script>
     <%
    }
failz=(String)request.getAttribute("rfailure");
if(failz!=null)
    {
    %>
        <script>
        showRError("User already registered.") 
        </script>
     <%
    }
String successz=null;
successz=(String)request.getAttribute("success");
if(successz!=null)
    {
    %>
        <script>
            showSuccess();
        </script>
     <%
    }
%>
</html>