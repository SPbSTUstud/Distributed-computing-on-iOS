<%-- 
    Document   : Pi
    Created on : May 30, 2012, 1:11:12 AM
    Author     : igofed
--%>

<%@page import="ru.spbstu.apicore.computing.ComputingCenterHolder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Pi number</title>
    </head>
    <body>
        <h1>Current computed Pi number:</h1>
        <h1><%=ComputingCenterHolder.getComputingCenter().getCurrentResult().toString()%></h1>
    </body>
</html>
