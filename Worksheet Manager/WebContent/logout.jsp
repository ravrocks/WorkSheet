<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<%
         session.invalidate();
    Cookie[] cookies = request.getCookies();
    if(cookies !=null)
    {
    for(Cookie cookie : cookies){
	cookie.setMaxAge(0);
        cookie.setValue(null);
        response.addCookie(cookie);
        }
    }
    response.setHeader("Cache-Control","no-cache");
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader ("Expires", 0);
    response.sendRedirect("home.jsp");
%>

</body>
</html>

