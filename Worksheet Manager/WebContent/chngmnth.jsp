<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <script src="assets/js/jquery.min.js"></script>
    
    <!-- Css files  -->
    <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/fonts/simple-line-icons.min.css">

</head>
<body>
<div class="col-sm-9 col-md-12" style="margin-top:4vh"> 
					<h2 class="dropdown col-sm-2 col-md-5">Select Year and Month-</h2>
                    <div class="dropdown col-sm-3 col-md-2">
                    <button id="monthButton" class="btn-lg btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" >Month</button>
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
					<div class="dropdown dropdown col-sm-3 col-md-1">
					 <button id="yearButton" class="btn-lg btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" >Year</button>
					 	<div id="yearMenu" class="dropdown-menu " role="menu" >
					 		<a class="dropdown-item" role="presentation" >2020</a>
					 		<a class="dropdown-item" role="presentation" >2021</a>
					 	</div>
                    </div>
                    <div class="col-sm-1 col-md-3">
                    	<div id="txt-info" style="width:90%"></div>
		      			<button name="sub_btn" id="sub_btn" class="btn-lg btn-success" onclick="performUpdate()">Submit</button>
		 			</div>                   
</div>
</body>
<script type="text/javascript">

var month = new Array("January","February","March","April","May","June","July","August","September","October","November","December");
var setyear=null,setmonth=null;
 
$("#monthMenu a").click(function(e){
    e.preventDefault(); // cancel the link behaviour
    var txt = $(this).text();
    $("#monthButton").text(txt);
    
});

$("#yearMenu a").click(function(e){
    e.preventDefault(); // cancel the link behaviour
    var txt = $(this).text();
    $("#yearButton").text(txt);
    
});

function performUpdate(){
	 var xhttp;
	 var str1 = $("#monthButton").text();
	 var TextfrmList =$("#yearButton").text();
	 
	 let monint = -1;
     month.forEach(function(element,i){
         if(str1==element)
             monint=i;
     });
     if ((monint==-1)||(TextfrmList=='Year')) {
 	    //document.getElementById("txt-info").innerHTML = "Both fields required!";
 	   	var capError = $("#txt-info");
	   	capError.before("<div id='validtags' style='color:red;margin-bottom: 0px;'>Both fields required!</div>");
	    setTimeout(
	        function() { 
	        	//capElem.parent().css({"color": "", "border": "0px"});
	        	$('#validtags').remove(); 
	        	},
	        3000);
 	    console.log('Invalid selection.');
 	    return;
 	  }
	  console.log(str1);
	  
	  xhttp = new XMLHttpRequest();
	  xhttp.open("POST", "AlterMonth?mmnth="+str1+"&yyrth="+TextfrmList, true);
	  xhttp.send();
	  xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {
	    	if(this.responseText=='Success!')
	    		{
	    		var capError = $("#txt-info");
	    	   	capError.before("<div id='validtags' style='color:green;margin-bottom: 0px;'>"+this.responseText+"</div>");
	    	    setTimeout(
	    	        function() { 
	    	        	//capElem.parent().css({"color": "", "border": "0px"});
	    	        	$('#validtags').remove(); 
	    	        	},
	    	        3000);
	    		}
	    	else
	    		{
	    		var capError = $("#txt-info");
	    	   	capError.before("<div id='validtags' style='color:red;margin-bottom: 0px;'>"+this.responseText+"</div>");
	    	    setTimeout(
	    	        function() { 
	    	        	//capElem.parent().css({"color": "", "border": "0px"});
	    	        	$('#validtags').remove(); 
	    	        	},
	    	        3000);
	    		}
	    }
	  };	  
}
</script>
</html>