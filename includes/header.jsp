<%--------------------------------------------------------------
Copyright Stefan Cao 2016 - All Rights Reserved          
												          
	Name: Stefan Cao								          
	ID#: 79267250									          
	Assignment: Mini-Project 2						          
												          
	File: header.jsp 										 
												          
	Description:	
		header file

	History:
		Date 	Update Description 	   		   Developer  
     --------  ---------------------          ------------	     
     10/14/2016 		Created 					SC
--------------------------------------------------------------%>
<%@ page contentType = "text/html;charset=UTF-8" pageEncoding = "UTF-8" %>

<%@include file="/includes/javaLib.jsp" %>

<!DOCTYPE html>
<html>
	<head>
		<title>
		<%
			if (pageTitle != null) {
				out.println(pageTitle);
			}
		%>
		</title>

		<!-- for mobile support -->
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<!-- load bootstrap library -->
		<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
	</head>
	<body>

		<!-- navbar -->
		<div class = "navbar navbar-inverse navbar-static-top">
			<div class = "container">

			<!-- 3 bar for mobile version -->
				<button class = "navbar-toggle" data-toggle = "collapse" data-target = ".navHeaderCollapse">
					<span class = "icon-bar"></span>
					<span class = "icon-bar"></span>
					<span class = "icon-bar"></span>
				</button>

				<div class = "collapse navbar-collapse navHeaderCollapse">

					<ul class = "nav navbar-nav  navbar-right">

						<li><a href = "index.jsp">Gallery</a></li>
						<li><a href = "image_gallery.jsp">Image Gallery</a></li>
						<li><a href = "artist_gallery.jsp">Artist Gallery</a></li>
					</ul>
				
				</div>
			</div> <!-- end container-->
		</div> <!-- end navbar -->

		<!-- start of main container -->
		<div class="container" style="margin: 20px">