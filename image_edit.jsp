<%--------------------------------------------------------------
Copyright Stefan Cao 2016 - All Rights Reserved          
												          
	Name: Stefan Cao								          
	ID#: 79267250									          
	Assignment: Mini-Project 2						          
												          
	File: image_edit.jsp 										 
												          
	Description:	
		edit the image

	History:
		Date 	Update Description 	   		   Developer  
     --------  ---------------------          ------------	     
     10/19/2016 		Created 					SC
--------------------------------------------------------------%>
<% String pageTitle = "Image Edit"; %>

<%@include file="includes/header.jsp" %>
<%@include file="utils/DB_utils.jsp" %>

<%!

	// function to generate edit input box
	private String generateEditInputBox (String divId, String labelFor, String labelTitle, String inputID, String inputName, String inputValue, String labelId, String erMessage) {

		return "<div class='form-group' id='" + divId + "'><label for='" + labelFor + "' class='col-lg-2 control-label'>" + labelTitle + "</label><div class='col-lg-10'><input type='text' class='form-control' id='" + inputID + "' name='" + inputName + "' value='" + inputValue + "'></div><label id='" + labelId + "' style='display: none' class='col-lg-6 control-label' for='inputError'>" + erMessage + "</label></div>";
	}
%>
<%

	String imageId = request.getParameter("id");

	try {

		// establish a connection
		Connection con = DriverManager.getConnection(getURL(),getUser(),getPwd());
		Statement stmt = con.createStatement();

		// get image info
		String sql = "SELECT I.title, I.link, G.gallery_id, G.name, A.artist_id, A.name, D.year, D.type, D.width, D.height, D.location, D.description FROM image I, gallery G, artist A, detail D WHERE G.gallery_id = I.gallery_id AND I.artist_id = A.artist_id AND I.image_id = D.image_id AND I.image_id = " + imageId;
		ResultSet rs = stmt.executeQuery(sql);

		rs.next();

		// set to local vars otherwise they will get lost
		String tmpTitle = rs.getString("title");
		String tmpLink = rs.getString("link");
		String tmpArtist = rs.getString("A.name");
		String tmpYear = rs.getString("year");
		String tmpType = rs.getString("type");
		String tmpWidth = rs.getString("width");
		String tmpHeight = rs.getString("height");
		String tmpLocation = rs.getString("location");
		String tmpDescription = rs.getString("description");

		int galleryId = rs.getInt("G.gallery_id");
		int artistId = rs.getInt("A.artist_id");

		// generate form
		out.println("<center><form class='form-horizontal' name='imageEditForm' method='post' action='update.jsp?t=i' onsubmit='return checkValidation()'>");

		out.println("<input type='hidden' name='image_id' value='" + imageId + "'>");

		// generate the edit input boxes with the values of previous values
		out.println(generateEditInputBox ("titleDiv", "editImage-Title", "Title:", "titleId", "title", tmpTitle, "titleLabel", "Please fill in title"));

		out.println("<img style='margin-bottom: 20px;'id='imgId' src='#' width='500px' height='300px'>");

		out.println(generateEditInputBox("imgLinkDiv", "editImage-Link", "Image Link:", "imageLinkId", "imageLink", tmpLink, "imgLinkLabel", "Please enter the image link"));

		out.println("<div class='form-group'><label for='editImage-gallery' class='col-lg-9 control-label'></label><div class='col-lg-3'><button type='button' class='btn btn-primary' onclick='PreviewImg();'>Preview</button></div></div>");

		out.println("<div class='form-group'><label for='editImage-gallery' class='col-lg-2 control-label'>Gallery:</label><div class='col-lg-1'><select name='galleryId' class='selectpicker'>");

		// dropdown to select the gallery
		String gallerySQL = "SELECT gallery_id, name FROM gallery";
		ResultSet availGallery = stmt.executeQuery(gallerySQL);

		while (availGallery.next()) {
			out.println("<option value=" + availGallery.getInt("gallery_id"));

			if (availGallery.getInt("gallery_id") == galleryId) {
				out.println(" selected='selected'");
			}

			out.println(">" + availGallery.getString("name") + "</option>");
		}
			
		out.println("</select></div></div>");						
									
		out.println("<div class='form-group'><label for='editImage-artist' class='col-lg-2 control-label'>Artist:</label><div class='col-lg-1'><select name='artistId' class='selectpicker'>");

		// dropdown to select artist
		String artistSQL = "SELECT artist_id, name FROM artist";
		ResultSet availArtist = stmt.executeQuery(artistSQL);

		while (availArtist.next()) {
			out.println("<option value=" + availArtist.getInt("artist_id"));

			if (availArtist.getInt("artist_id") == artistId) {
				out.println(" selected='selected'");
			}

			out.println(">" + availArtist.getString("name") + "</option>");
		}

		out.println("</select></div></div>");	

		out.println(generateEditInputBox ("yearDiv", "editImage-Year", "Year:", "yearId", "year", tmpYear, "yearLabel", "Please fill in year"));

		out.println(generateEditInputBox ("typeDiv", "editImage-Type", "Type:", "typeId", "type", tmpType, "typeLabel", "Please fill in type"));

		out.println(generateEditInputBox ("widthDiv", "editImage-Width", "Width:", "widthId", "width", tmpWidth, "widthLabel", "Please fill in width"));

		out.println(generateEditInputBox ("heightDiv", "editImage-Height", "Height:", "heightId", "height", tmpHeight, "heightLabel", "Please fill in height"));

		out.println(generateEditInputBox ("locationDiv", "editImage-Location", "Location:", "locationId", "location", tmpLocation, "locationLabel", "Please fill in location"));

		out.println(generateEditInputBox("descriptionDiv", "editImage-Description", "Decription:", "descriptionId", "description", tmpDescription, "descriptionLabel", "Please enter the description"));

		out.println("<button class='btn btn-primary' type='submit'>Update</button></form></center>");
		con.close();
		stmt.close();
		rs.close();
		availGallery.close();
		availArtist.close();
	}
	catch(Exception e)
	{
		out.println(e.toString());
	} 
%>

<script>
	window.onload = function() {
		PreviewImg();
	};

	function PreviewImg () {
		var imgLinkValue = document.getElementById("imageLinkId").value;
		if (imgLinkValue == null || imgLinkValue == "") {
			alert ("Please enter a link before previewing");
		}
		else {
			$('#imgId').attr('src', imgLinkValue);
		}
	}

	function checkValidation() {
		var title = document.forms["imageEditForm"]["title"].value;
		var link = document.forms["imageEditForm"]["imageLink"].value;
		var year = document.forms["imageEditForm"]["year"].value;
		var type = document.forms["imageEditForm"]["type"].value;
		var width = document.forms["imageEditForm"]["width"].value;
		var height = document.forms["imageEditForm"]["height"].value;
		var location = document.forms["imageEditForm"]["location"].value;

		if (title == null || title == "" 
			|| link == null || link == ""
			|| year == null || year == "" || !isNumeric(year)
			|| type == null || type == ""
			|| width == null || width == "" || !isNumeric(width)
			|| height == null || height == "" || !isNumeric(height)
			|| location == null || location == "") {
			
			alert ("Please fill fix the indicated inputs");

			if (title == null || title == "") {
				$('#titleDiv').addClass('has-error');
				document.getElementById("titleLabel").style.display = "block";
			}
			else {
				$('#titleDiv').removeClass('has-error');
				document.getElementById("titleLabel").style.display = "none";
			}

			if (link == null || link == "") {
				$('#imgLinkDiv').addClass('has-error');
				document.getElementById("imgLinkLabel").style.display = "block";
			}
			else {
				$('#imgLinkDiv').removeClass('has-error');
				document.getElementById("imgLinkLabel").style.display = "none";
			}
					
			if (year == null || year == "" || !isNumeric(year)) {
				$('#yearDiv').addClass('has-error');
				document.getElementById("yearLabel").style.display = "block";
			}
			else {
				$('#yearDiv').removeClass('has-error');
				document.getElementById("yearLabel").style.display = "none";
			}

			if (type == null || type == "") {
				$('#typeDiv').addClass('has-error');
				document.getElementById("typeLabel").style.display = "block";
			}
			else {
				$('#typeDiv').removeClass('has-error');
				document.getElementById("typeLabel").style.display = "none";
			}

			if (width == null || width == "" || !isNumeric(width)) {
				$('#widthDiv').addClass('has-error');
				document.getElementById("widthLabel").style.display = "block";
			}
			else {
				$('#widthDiv').removeClass('has-error');
				document.getElementById("widthLabel").style.display = "none";
			}

			if (height == null || height == "" || !isNumeric(height)) {
				$('#heightDiv').addClass('has-error');
				document.getElementById("heightLabel").style.display = "block";
			}
			else {
				$('#heightDiv').removeClass('has-error');
				document.getElementById("heightLabel").style.display = "none";
			}
			
			if (location == null || location == "") {
				$('#locationDiv').addClass('has-error');
				document.getElementById("locationLabel").style.display = "block";
			}
			else {
				$('#locationDiv').removeClass('has-error');
				document.getElementById("locationLabel").style.display = "none";
			}

			return false;
		} 
	}
 
	function isNumeric(n) {
		return !isNaN(parseFloat(n)) && isFinite(n);
	}

</script>
	
<%@include file="includes/footer.jsp" %>