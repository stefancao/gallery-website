<%--------------------------------------------------------------
Copyright Stefan Cao 2016 - All Rights Reserved          
												          
	Name: Stefan Cao								          
	ID#: 79267250									          
	Assignment: Mini-Project 2						          
												          
	File: image_detail.jsp 										 
												          
	Description:	
		show the details of an image

	History:
		Date 	Update Description 	   		   Developer  
     --------  ---------------------          ------------	     
     10/8/2016 		Created 					SC
--------------------------------------------------------------%>
<% String pageTitle = "Image Gallery"; %>

<%@include file="includes/header.jsp" %>
<%@include file="utils/DB_utils.jsp" %>
<%@include file="utils/form_utils.jsp" %>

<%
	String imageId = request.getParameter("id");

	if (request.getParameter("u") != null && request.getParameter("u").equals("s")) {
			out.println("<div class='alert alert-success'><strong>Update was successful!</strong></div>");
	}

	try {

		// establish a connection
		Connection con = DriverManager.getConnection(getURL(),getUser(),getPwd());
		Statement stmt = con.createStatement();

		// get image detail
		String sql = "SELECT I.title, I.link, G.name, A.name, D.year, D.type, D.width, D.height, D.location, D.description FROM image I, gallery G, artist A, detail D WHERE G.gallery_id = I.gallery_id AND I.artist_id = A.artist_id AND I.image_id = D.image_id AND I.image_id = " + imageId;
		ResultSet rs = stmt.executeQuery(sql);

		rs.next();

		// generate the info
		out.println("<a style='margin: 10px; float: right' role='button' class='btn btn-danger' href='delete.jsp?t=i&id=" + imageId + "'>Delete</a>");
		out.println("<a style='margin: 10px; float: right' role='button' class='btn btn-primary' href='image_edit.jsp?id=" + imageId + "'>Edit</a><br><br>");

		out.println("<center><h3>" + rs.getString("title") + "</h3><div><img src='" + rs.getString("link") + "' width='" + rs.getString("width") + "' height='" + rs.getString("height") + "'></img></div><div><h5>Gallery: " + rs.getString("G.name") + "<br><br>Artist: " + rs.getString("A.name") + "<br><br>Year: " + rs.getString("Year") + "<br><br>Type: " + rs.getString("type") + "<br><br>Width: " + rs.getString("width") + "<br><br>Height: " + rs.getString("height") + "<br><br>Location: " + rs.getString("Location") + "<br><br>Description: " + rs.getString("description") + "</h5></div></center>");

		con.close();
		stmt.close();
		rs.close();
	}
	catch(Exception e)
	{
		out.println(e.toString());
	} 
%>

<%@include file="includes/footer.jsp" %>