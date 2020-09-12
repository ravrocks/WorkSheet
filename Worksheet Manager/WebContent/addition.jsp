<%@page import="com.works.getConnection"%>
<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String userName = null,userPsno=null, showMonth=null;
    Cookie[] cookies = request.getCookies();
    if(cookies !=null){
    for(Cookie cookie : cookies){
	if(cookie.getName().equals("timesheet_name")) userName = cookie.getValue();
        if(cookie.getName().equals("timesheet_psno")) userPsno = cookie.getValue();
        if(cookie.getName().equals("show_month")) showMonth = cookie.getValue();        
    }
    }
    if(userName == null) response.sendRedirect("home.jsp");

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>TimeSheet</title>
<style >

html, body {
  height: 100%;
}

body {
    padding-top: 30px;
}

div.k{
	margin-right:30px;
	position:relative;
}
</style>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

<script>
$(document).ready(function(){
	  $("#search").on("keyup", function() {
	    var value = $(this).val().toLowerCase();
	    $("#table tr").filter(function() {
	      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
	    });
	  });
	});

//JavaScript popup window function
	function basicPopup(url) {
popupWindow = window.open(url,'popUpWindow','height=600,width=600,left=50,top=50,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no, status=yes');
	}

</script>
</head>
<body>
<div class="container" > 
<div><h3>Select the field which you want to update</h1></div><br>
<div class="row">
		<div class="col-6">
		 <div class="dropdown">
		    <button class="btn btn-primary " type="button" data-toggle="dropdown" ">Select
		    <span class="caret"></span></button>
		    <ul id="add_activity" class="dropdown-menu">
		      <li data-value="project_list"><a id="project_list" href="#">Project list</a></li>
		      <li data-value="subfunction"><a id="subfunction" href="#">Sub Function</a></li>
		      <li data-value="activity_group"><a id="activity_group" href="#">Activity Group</a></li>
		      <li data-value="activity_list"><a id="activity_list" href="#">Activity List</a></li>
		    </ul>
		  </div>
		  <br>
  		<div id="txt" style="width:90%"></div>
  		</div>
		 <div class="col-3" style="margin-top:-20px;" >
		      <label>New Input:</label>
		      <input type="text" style="margin-left:20%" class="form-control" id="inp"><br>
		      <button style="margin-left:20%; name="sub_btn" id="sub_btn" class="btn btn-primary" onclick="addtolist()">Submit</button>
		      <button style="margin-left:1%; name="del_btn" id="del_btn" class="btn btn-danger" onclick="rmvfrmlist()">Delete</button>
		 </div>
</div>
</div>
<script>
var txt1;

$(function(){
    $(".dropdown-menu li a").click(function(){
      $(".btn:first-child").text($(this).text());
      $(".btn:first-child").val($(this).text());
      txt1 =$(this).attr('id');
      fetch(txt1);
      $('.selectedLi').removeClass('selectedLi');
      $(this).addClass('selectedLi');
   });
});

function fetch(str){
	var xhttp;
	  if (str == "") {
	    document.getElementById("txt").innerHTML = "";
	    return;
	  }
	  xhttp = new XMLHttpRequest();
	  xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {
	    document.getElementById("txt").innerHTML = this.responseText;
	    }
	  };
	  var xhttp;  
	  xhttp.open("GET","fetch.jsp?q="+str, true);
	  xhttp.send();
}

function addtolist(){
	 var xhttp;
	 var str1 = document.getElementById("inp").value;
	 var TextfrmList = $('.dropdown-menu li a.selectedLi').attr('id');
	 
	  if (str1 == "" || TextfrmList=="") {
	    document.getElementById("txt").innerHTML = "";
	    return;
	  }
	  xhttp = new XMLHttpRequest();
	  xhttp.open("POST", "AddToDB?tab="+TextfrmList+"&valz="+str1, true);
	  xhttp.send();
	  xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {
	    document.getElementById("txt").innerHTML = this.responseText;
	    }
	  };	  
}
function rmvfrmlist()
{
	 var xhttp;
	 var str1 = document.getElementById("inp").value;
	 var TextfrmList = $('.dropdown-menu li a.selectedLi').attr('id');
	 
	  if (str1 == "" || TextfrmList=="") {
	    document.getElementById("txt").innerHTML = "";
	    return;
	  }
	  xhttp = new XMLHttpRequest();
	  xhttp.open("POST", "RmvFrmDB?tab="+TextfrmList+"&valz="+str1, true);
	  xhttp.send();
	  xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {
	    document.getElementById("txt").innerHTML = this.responseText;
	    }
	  };
}

</script>
</body>
</html>