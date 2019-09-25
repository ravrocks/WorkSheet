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
		      <li><a id="project_list" href="#">Project list</a></li>
		      <li><a id="subfunction" href="#">Sub Function</a></li>
		      <li><a id="activity_group" href="#">Activity Group</a></li>
		      <li><a id="activity_list" href="#">Activity List</a></li>
		    </ul>
		  </div>
		  <br>
  		<div id="txt" style="width:90%"></div>
  		</div>
		 <div class="col-3" style="margin-top:70px;" >
		      <label >Input:</label>
		      <input type="text" class="form-control" id="inp"><br>
		      <button style="margin-left:30%; type="button" id="sub_btn" class="btn btn-primary" onclick="addtolist()">Submit</button>
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
   });
});

$(function(){
    $("#sub_btn").click(function(){
      var inputVal = document.getElementById("inp").value;
      addtolist(txt1,inputVal);
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

function addtolist(str1,str2){
	var xhttp;
	  if (str1 == "" || str2=="") {
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
	  xhttp.open("GET","addtodb.jsp?p1="+str1+"&p2="+str2 , true);
	  xhttp.send();
	  location.reload();
}

</script>
</body>
<!--  <div> Filter by Name or PS no.&nbsp;&nbsp;<input id="search" type="text" placeholder="Search.."><br><br></div>-->	
</html>