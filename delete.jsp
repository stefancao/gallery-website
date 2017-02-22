<%--------------------------------------------------------------
Copyright Stefan Cao 2016 - All Rights Reserved          
												          
	Name: Stefan Cao								          
	ID#: 79267250									          
	Assignment: Mini-Project 2						          
												          
	File: delete.jsp 										 
												          
	Description:	
		make a deletion

	History:
		Date 	Update Description 	   		   Developer  
     --------  ---------------------          ------------	     
     10/20/2016 		Created 					SC
--------------------------------------------------------------%>

<%@include file="includes/javaLib.jsp" %>
<%@include file="utils/DB_utils.jsp" %>

<%

	// get the type
	String type = request.getParameter("t");

	String returnLocation = "";
	
	// if type is gallery
	if (type.equals("g")) {
		// not required to didn't implement
	}	

	// if type is image
	else if (type.equals("i")) {
		String imageId = request.getParameter("id");		

		String deleteSQL = "DELETE FROM image WHERE image_id=?";

		try {
			Connection con = DriverManager.getConnection(getURL(),getUser(),getPwd());

			// create a prepared statement
			PreparedStatement pstmt = con.prepareStatement(deleteSQL);
			pstmt.clearParameters();
		
			pstmt.setString(1, imageId);
			
			pstmt.executeUpdate();

			deleteSQL = "DELETE FROM detail WHERE image_id=?";

			pstmt = con.prepareStatement(deleteSQL);
			pstmt.clearParameters();
		
			pstmt.setString(1, imageId);
			
			pstmt.executeUpdate();

			con.close();
			pstmt.close();
		}
		catch(Exception e)
		{
			out.println(e.toString());
		} 
		
		returnLocation = "image_gallery.jsp?d=s";
	}
	// if type is artist
	else if (type.equals("a")) {
		// not required so didn't implement
	}
	response.sendRedirect(returnLocation);
%>

