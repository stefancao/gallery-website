<%--------------------------------------------------------------
Copyright Stefan Cao 2016 - All Rights Reserved          
												          
	Name: Stefan Cao								          
	ID#: 79267250									          
	Assignment: Mini-Project 2						          
												          
	File: javaLib.jsp 										 
												          
	Description:	
		importing java libraries	

	History:
		Date 	Update Description 	   		   Developer  
     --------  ---------------------          ------------	     
     10/8/2016 		Created 					SC
--------------------------------------------------------------%>

<%@ page import = "java.util.*"%>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>

<%
	// include the mysql jdbc driver
	try {
		Class.forName("com.mysql.jdbc.Driver").newInstance();
	} catch(Exception e) {
		out.println("can't load mysql driver");
		out.println(e.toString());
	}
%>


