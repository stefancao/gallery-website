<%--------------------------------------------------------------
Copyright Stefan Cao 2016 - All Rights Reserved          
												          
	Name: Stefan Cao								          
	ID#: 79267250									          
	Assignment: Mini-Project 2						          
												          
	File: index.jsp 										 
												          
	Description:	
		index/home page for gallery website				

	History:
		Date 	Update Description 	   		   Developer  
     --------  ---------------------          ------------	     
     10/8/2016 		Created 					SC
--------------------------------------------------------------%>
<% String pageTitle = "Gallery"; %>

<%@include file="includes/header.jsp" %>
<%@include file="utils/DB_utils.jsp" %>
<%@include file="utils/form_utils.jsp" %>

	<%

		if (request.getParameter("r") != null && request.getParameter("r").equals("s")) {
			out.println("<div class='alert alert-success'><strong>Success!</strong> Gallery '" + request.getParameter("returnValue") + "' was added</div>");
		}
	%>

	<button style="margin: 20px" type="button" class="btn btn-primary" href="#addGallery" data-toggle="modal">Add a new Gallery</button>

	<h3>Here are all the galleries:</h3>
	
	<%
		try {
			Connection con = DriverManager.getConnection(getURL(),getUser(),getPwd());
			Statement stmt = con.createStatement();
			String sql = "SELECT * FROM (SELECT *, (SELECT count(*) FROM image I WHERE I.gallery_id=G.gallery_id) AS NumOfImage FROM gallery G) tmp LEFT JOIN image I ON tmp.gallery_id = I.gallery_id ORDER BY tmp.gallery_id";
			ResultSet rs = stmt.executeQuery(sql);
			String tmpGalleryId = "";
			while (rs.next()) {
				if (!tmpGalleryId.equals(rs.getString("gallery_id"))) {
					tmpGalleryId = rs.getString("gallery_id");
					out.println("<h4><a href='image_gallery.jsp?gid=" + rs.getString("gallery_id") + "'>" + rs.getString("name") + "</a></h4>");
					out.println("<div style='margin-bottom: 75px'><div style='float: left; margin-right: 20px'>");

					if (rs.getInt("NumOfImage") == 0) {
						out.println("<img width='100px' height='100px' src='img/empty_gallery.png'></img>");
					}
					else {
						out.println("<img width='100px' height='100px' src='" + rs.getString("link") + "'></img>");
					}

					out.println("</div><div><h5>Number of Images: " + rs.getString("NumOfImage") + "</h5><h5>Description: </h5><p>" + rs.getString("description") + "</p></div></div><div style='clear:both'></div>");
				}
			}
			con.close();
			stmt.close();
			rs.close();
		}
		catch(Exception e)
		{
			out.println(e.toString());
		} 

	%>

	<div class="modal fade" id="addGallery" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">	
				<form class="form-horizontal" name="galleryForm" method="post" action="insert.jsp?t=g" onsubmit="return checkValidation()">

					<input type="hidden" name="location" value=
					<%
						out.println("'" + request.getRequestURI() + "'");
					%>
					>
				
					<div class="modal-header">
						<h4>Add a new Gallery</h4>
					</div>
					<div class="modal-body">
						
						<%
							out.println(generateInputBox("galleryNameDiv", "addGallery-name", "Gallery Name:", "galleryNameId", "galleryName", "Gallery Name", "galleryNameLabel", "Please enter the gallery name"));

							out.println(generateInputTextBox("galleryDescriptionDiv", "addGallery-description", "Decription:", "galleryDescriptionId", "galleryDescription", "(optional)", "galleryDescriptionLabel", "Please enter the gallery description"));
						%>

					</div>
					<div class="modal-footer">
						<a class="btn btn-default" data-dismiss="modal">Cancel</a>
						<button class="btn btn-primary" type="submit">Add</button>
					</div>
				</form>
			</div>
		</div>
	</div>	

	<script>
		function checkValidation () {
			var gName = document.forms["galleryForm"]["galleryName"].value;
			if (gName == null || gName == "") {
				$('#galleryNameDiv').addClass('has-error');
				document.getElementById("galleryNameLabel").style.display = "block";
				alert ("Please fill fix the indicated input");
				return false;
			} 
			else {
				$('#galleryNameDiv').removeClass('has-error');
				document.getElementById("galleryNameLabel").style.display = "none";
			}
		}
	</script>
	
<%@include file="includes/footer.jsp" %>