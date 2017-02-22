<%--------------------------------------------------------------
Copyright Stefan Cao 2016 - All Rights Reserved          
												          
	Name: Stefan Cao								          
	ID#: 79267250									          
	Assignment: Mini-Project 2						          
												          
	File: update.jsp 										 
												          
	Description:	
		update to database			

	History:
		Date 	Update Description 	   		   Developer  
     --------  ---------------------          ------------	     
     10/19/2016 		Created 					SC
--------------------------------------------------------------%>

<%@include file="includes/javaLib.jsp" %>
<%@include file="utils/DB_utils.jsp" %>

<%

	// get the type
	String type = request.getParameter("t");

	String returnLocation = "";
	
	// if type is gallery
	if (type.equals("g")) {
		String galleryId = request.getParameter("gallery_id");
		String name = request.getParameter("name");
		String description = request.getParameter("description");

		String updateSQL = "UPDATE gallery SET name=?,description=? WHERE gallery_id=?";

		try {
			Connection con = DriverManager.getConnection(getURL(),getUser(),getPwd());

			// create a prepared statement
			PreparedStatement pstmt = con.prepareStatement(updateSQL);
			pstmt.clearParameters();
		
			pstmt.setString(1, name);
			pstmt.setString(2, description);
			pstmt.setString(3, galleryId);
			
			pstmt.executeUpdate();

			returnLocation = "image_gallery.jsp?gid=" + galleryId + "&u=s";
		
			con.close();
			pstmt.close();
		}
		catch(Exception e)
		{
			out.println(e.toString());
		} 

	}	

	// if type is image
	else if (type.equals("i")) {
		String imageId = request.getParameter("image_id");
		String title = request.getParameter("title");
		String imageLink = request.getParameter("imageLink");
		String galleryId = request.getParameter("galleryId");
		String artistId = request.getParameter("artistId");
		String year = request.getParameter("year");
		String imageType = request.getParameter("type");
		String width = request.getParameter("width");
		String height = request.getParameter("height");
		String location = request.getParameter("location");
		String description = request.getParameter("description");

		String updateSQL = "UPDATE image SET title=?,link=?,gallery_id=?,artist_id=? WHERE image_id=?";

		try {
			Connection con = DriverManager.getConnection(getURL(),getUser(),getPwd());

			// create a prepared statement
			PreparedStatement pstmt = con.prepareStatement(updateSQL);
			pstmt.clearParameters();
		
			pstmt.setString(1, title);
			pstmt.setString(2, imageLink);
			pstmt.setString(3, galleryId);
			pstmt.setString(4, artistId);
			pstmt.setString(5, imageId);
			
			pstmt.executeUpdate();
			
			updateSQL = "UPDATE detail SET year=?,type=?,width=?,height=?,location=?,description=? WHERE image_id=?";

			pstmt = con.prepareStatement(updateSQL);
			pstmt.clearParameters();
		
			pstmt.setString(1, year);
			pstmt.setString(2, imageType);
			pstmt.setString(3, width);
			pstmt.setString(4, height);
			pstmt.setString(5, location);
			pstmt.setString(6, description);
			pstmt.setString(7, imageId);
			pstmt.executeUpdate();

			returnLocation = "image_detail.jsp?id=" + imageId + "&u=s";

			con.close();
			pstmt.close();
		}
		catch(Exception e)
		{
			out.println(e.toString());
		} 	
	}

	// update artist
	else if (type.equals("a")) {
		String artistId = request.getParameter("artist_id");
		String name = request.getParameter("name");
		String birthYear = request.getParameter("birthYear");
		String country = request.getParameter("country");
		String description = request.getParameter("description");

		String updateSQL = "UPDATE artist SET name=?,birth_year=?,country=?,description=? WHERE artist_id=?";

		try{
			Connection con = DriverManager.getConnection(getURL(),getUser(),getPwd());

			// create a prepared statement
			PreparedStatement pstmt = con.prepareStatement(updateSQL);
			pstmt.clearParameters();
		
			pstmt.setString(1, name);
			pstmt.setString(2, birthYear);
			pstmt.setString(3, country);
			pstmt.setString(4, description);
			pstmt.setString(5, artistId);
			
			pstmt.executeUpdate();
			
			returnLocation = "image_gallery.jsp?aid=" + artistId + "&u=s";

			con.close();
			pstmt.close();
		}
		catch(Exception e)
		{
			out.println(e.toString());
		} 	
		
	}
	response.sendRedirect(returnLocation);
%>