<%--------------------------------------------------------------
Copyright Stefan Cao 2016 - All Rights Reserved          
												          
	Name: Stefan Cao								          
	ID#: 79267250									          
	Assignment: Mini-Project 2						          
												          
	File: image_gallery.jsp 										 
												          
	Description:	
		show all images or images in a given gallery 			

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

		Connection con = DriverManager.getConnection(getURL(),getUser(),getPwd());
		Statement stmt = con.createStatement();

		if (request.getParameter("r") != null && request.getParameter("r").equals("s")) {
			out.println("<div class='alert alert-success'><strong>Success!</strong> Gallery '" + request.getParameter("returnValue") + "' was added</div>");
		}
		else if (request.getParameter("d") != null && request.getParameter("d").equals("s")) {
			out.println("<div class='alert alert-success'><strong>Deletion was successful!</strong></div>");
		}

		if (request.getParameter("u") != null && request.getParameter("u").equals("s")) {
			out.println("<div class='alert alert-success'><strong>Update was successful!</strong></div>");
		}
	%>
	<button style="margin: 20px; float: left" type="button" class="btn btn-primary" href="#addImage" data-toggle="modal">Add a new Image</button>

	<a style="margin: 20px" role="button" class="btn btn-default" onclick="ShowHideSearch();">Search for images</a>

	<%
		if (request.getParameter("gid") != null && request.getParameter("gid") != "" 
			|| request.getParameter("aid") != null && request.getParameter("aid") != "") {
			out.println("<a style='margin: 20px' role='button' class='btn btn-info' ");
			if (request.getParameter("gid") != null && request.getParameter("gid") != "") {
				out.println("href='gallery_edit.jsp?id=" + request.getParameter("gid") + "'>Edit Gallery</a>");
			}
			else {
				out.println("href='artist_edit.jsp?id=" + request.getParameter("aid") + "'>Edit Artist</a>");
			}
			
		}
	%>

	<div style='clear:both'></div>

	<br>

	<div id="searchShowHideDiv" style="display: none">
		<h3>Search for an image by:</h3>

		<form class="form-horizontal" name="searchForm" method="post" action="image_gallery.jsp?m=s">

		<div class='form-group' id='selectDiv'>
			<label for='creation_year' class='col-lg-2 control-label'>
				Search Criteria:
			</label>
			<div class='col-lg-10'>
				<select class="selectpicker" id="searchSelectID" name="searchSelect" onchange="ShowRangeOrSearchInput();">
					<option value='type'>Type</option>
					<option value='creation_year'>Creation Year</option>
					<option value='artist_name'>Artist Name</option>
					<option value='location'>Location</option>	
				</select>
			</div>
		</div>

		<div class='form-group' id='creation_yearDiv' style="display: none">	
			<label for='creation_year' class='col-lg-2 control-label'>
				From:
			</label>
			<div class='col-lg-2'>
				<input type='text' class='form-control' id='creation_yearFrom' name='creation_year_from'>
			</div>
			<label for='creation_year' class='col-lg-1 control-label'>
				To:
			</label>
			<div class='col-lg-2'>
				<input type='text' class='form-control' id='creation_yearTo' name='creation_year_to'>
			</div>
		</div>

		<div class="form-group" id='searchArtistDiv' style="display: none">
			<label for="searchArtist" class="col-lg-2 control-label">Artist:</label>
			<div class="col-lg-10">
				<select name="searchArtist" id="searchArtistSelectID" class="selectpicker">
					<%
						String searchArtistSQL = "SELECT artist_id, name FROM artist";
						ResultSet searchAvailArtist = stmt.executeQuery(searchArtistSQL);

						while (searchAvailArtist.next()) {
							out.println("<option value=" + searchAvailArtist.getInt("artist_id") + ">" + searchAvailArtist.getString("name") + "</option>");
						}
					%>
				</select>
			</div>
		</div>

		<%
			out.println(generateInputBox("searchDiv", "searchImage-input", "Search:", "searchId", "searchName", "", "searchLabel", "Please enter your search criteria"));
		%>

		<div class='form-group' style="margin-left: 115px">
			<button class="btn btn-primary" type="submit">Go</button>
		</div>
		</form>
	</div>

	
	<%
		if ((request.getParameter("gid") == null && request.getParameter("gid") == "") || (request.getParameter("aid") == null && request.getParameter("aid") == "")) {
			out.println("<h3>Here are all the images:</h3>");
		}
		
	%>
	
	<%
		
		String sql = "";
		ResultSet rs = null;
		if (request.getParameter("m") != null && request.getParameter("m").equals("s")) {
			String searchSelect = request.getParameter("searchSelect");
			if (searchSelect.equals("type")) {
				sql = "SELECT G.gallery_id, G.name, I.image_id, I.title, I.link FROM gallery G, image I, detail D WHERE G.gallery_id = I.gallery_id AND D.image_id = I.image_id AND D.type='" + request.getParameter("searchName") + "'ORDER BY I.gallery_id";
			}
			else if (searchSelect.equals("creation_year")) {
				sql = "SELECT G.gallery_id, G.name, I.image_id, I.title, I.link FROM gallery G, image I, detail D WHERE G.gallery_id = I.gallery_id AND D.image_id = I.image_id AND D.year >= " + request.getParameter("creation_year_from") + " AND D.year <= " + request.getParameter("creation_year_to") + " ORDER BY I.gallery_id";
			}
			else if (searchSelect.equals("artist_name")) {
				sql = "SELECT G.gallery_id, G.name, I.image_id, I.title, I.link FROM gallery G, image I WHERE G.gallery_id = I.gallery_id AND I.artist_id=" + request.getParameter("searchArtist") + " ORDER BY I.gallery_id";
			}
			else if (searchSelect.equals("location")) {
				sql = "SELECT G.gallery_id, G.name, I.image_id, I.title, I.link FROM gallery G, image I, detail D WHERE G.gallery_id = I.gallery_id AND D.image_id = I.image_id AND D.location='" + request.getParameter("searchName") + "' ORDER BY I.gallery_id";
			}
			
		}
		else if (request.getParameter("gid") != null && request.getParameter("gid") != "") {
			sql = "SELECT G.description, G.gallery_id, G.name, I.image_id, I.title, I.link FROM gallery G, image I WHERE G.gallery_id = I.gallery_id AND G.gallery_id = " + request.getParameter("gid") + " ORDER BY I.gallery_id";
		}
		else if (request.getParameter("aid") != null && request.getParameter("aid") != "") {
			sql = "SELECT A.name, A.birth_year, A.country, A.description, G.gallery_id, G.name, I.image_id, I.title, I.link FROM gallery G, image I, artist A WHERE G.gallery_id = I.gallery_id AND A.artist_id = I.artist_id AND I.artist_id = " +  request.getParameter("aid") + " ORDER BY I.gallery_id";
		}
		else {
			sql = "SELECT G.gallery_id, G.name, I.image_id, I.title, I.link FROM gallery G, image I WHERE G.gallery_id = I.gallery_id ORDER BY I.gallery_id";
			
		}

		rs = stmt.executeQuery(sql);

		String tmpId = "";
		boolean isSkip = false;
		while (rs.next()) {
			if (!rs.getString("gallery_id").equals(tmpId)) {
				if (request.getParameter("gid") != null && request.getParameter("gid") != "") {
					out.println("<h4>Description:</h4><div>" + rs.getString("G.description") + "</div>");
				}
				else if (request.getParameter("aid") != null && request.getParameter("aid") != "" && !isSkip) {
					out.println("<h4>Name:</h4><div>" + rs.getString("A.name") + "</div>");
					out.println("<h4>Birth Year:</h4><div>" + rs.getString("A.birth_year") + "</div>");
					out.println("<h4>Country:</h4><div>" + rs.getString("A.country") + "</div>");
					out.println("<h4>Description:</h4><div>" + rs.getString("A.description") + "</div>");
					isSkip = true;
				}

				tmpId = rs.getString("gallery_id");
				out.println("<div style='clear:both'></div><br><br><h4>Gallery: " + rs.getString("G.name") + "</h4>");
				
			}

			out.println("<div style='float: left; margin: 5px 10px 5px 10px;'><center><div><h6>" + rs.getString("title") + "</h6></div><div><a href='image_detail.jsp?id=" + rs.getString("image_id") + "'><img src='" + rs.getString("link") + "' width='100px' height='100px'></img></a></div></center></div>");

		}
	%>

	<div class="modal fade" id="addImage" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">	
				<form class="form-horizontal" name="imageForm" method="post" action="insert.jsp?t=i" onsubmit="return checkValidation()">

					<input type="hidden" name="location" value=
					<%
						out.println("'" + request.getRequestURI() + "'");
					%>
					>
				
					<div class="modal-header">
						<h4>Add a new Image</h4>
					</div>
					<div class="modal-body">
						
						<div id="imgPreviewDiv" style="display:none">
							<center>
							<img style="margin-bottom: 20px;"id="imgId" src="#" width="500px" height="300px">
							</center>
						</div>
						<%
							out.println(generateInputBox("imgTitleDiv", "addImage-name", "Image Title:", "imageTitleId", "imageTitle", "Image Title", "imgTitleLabel", "Please enter the image title"));

							out.println(generateInputBox("imgLinkDiv", "addImage-link", "Image Link:", "imageLinkId", "imageLink", "Image Link", "imgLinkLabel", "Please enter the image link"));
						%>

						<div class="form-group">
							<label for="addImage-gallery" class="col-lg-9 control-label"></label>
							<div class="col-lg-3">
								<button type="button" class="btn btn-primary" onclick="PreviewImg();">Preview</button>
							</div>
						</div>

						<div class="form-group">
							<label for="addImage-gallery" class="col-lg-2 control-label">Gallery:</label>
							<div class="col-lg-10">
								<select name="galleryId" class="selectpicker">

								<%
									String gallerySQL = "";
									if (request.getParameter("gid") != null && request.getParameter("gid") != "") {
										gallerySQL = "SELECT gallery_id, name FROM gallery WHERE gallery_id = " + request.getParameter("gid");
									}
									else {
										gallerySQL = "SELECT gallery_id, name FROM gallery";
									}
									
									ResultSet availGallery = stmt.executeQuery(gallerySQL);

									while (availGallery.next()) {
										out.println("<option value=" + availGallery.getInt("gallery_id") + ">" + availGallery.getString("name") + "</option>");
									}
								%>
								</select>
							</div>
						</div>	

						<%
							out.println(generateInputBox("imgYearDiv", "addImage-year", "Image Year:", "imageYearId", "imageYear", "Image Year", "imgYearLabel", "Please enter the image year (must be a valid year)"));

							out.println(generateInputBox("imgTypeDiv", "addImage-type", "Image Type:", "imageTypeId", "imageType", "Image Type", "imgTypeLabel", "Please enter the image type"));

							out.println(generateInputBox("imgWidthDiv", "addImage-width", "Image Width:", "imageWidthId", "imageWidth", "Image Width", "imgWidthLabel", "Please enter the image width (must be a number)"));

							out.println(generateInputBox("imgHeightDiv", "addImage-height", "Image Height:", "imageHeightId", "imageHeight", "Image Height", "imgHeightLabel", "Please enter the image height (must be a number)"));				

							out.println(generateInputBox("imgLocationDiv", "addImage-location", "Image Location:", "imageLocationId", "imageLocation", "Image Location", "imgLocationLabel", "Please enter the image location"));		

							out.println(generateInputTextBox("imgDescriptionDiv", "addImage-Description", "Image Decription:", "imageDescriptionId", "imageDescription", "(optional)", "imgDescriptionLabel", "Please enter the image description"));		

						%>

						<div class="form-group">
							<label for="addImage-artist" class="col-lg-2 control-label">Artist:</label>
							<div class="col-lg-10">
									<%
										String artistSQL = "";

										out.println("<select name='artistId' id='artistSelectID' class='selectpicker'");

										if (request.getParameter("aid") != null && request.getParameter("aid") != "") {
											out.println(">");
											artistSQL = "SELECT artist_id, name FROM artist WHERE artist_id = " + request.getParameter("aid");
										}
										else {
											out.println(" onchange='ShowHideArtistInput()'>");
											out.println("<option value='0'>Create a new Artist</option>");
											artistSQL = "SELECT artist_id, name FROM artist";
										}
										
										ResultSet availArtist = stmt.executeQuery(artistSQL);

										while (availArtist.next()) {
											out.println("<option value=" + availArtist.getInt("artist_id") + ">" + availArtist.getString("name") + "</option>");
										}
									%>
								</select>
							</div>
						</div>
							
						<div id="artistInfo" style="display:block">

							<%
								if (request.getParameter("aid") == null || request.getParameter("aid") == "") {
									out.println(generateInputBox("artistNameDiv", "addImage-artistName", "New Artist Name:", "artistNameId", "artistName", "New Artist Name", "artistNameLabel", "Please enter the new artist name"));

									out.println(generateInputBox("artistBirthDiv", "addImage-artistBirth", "New Artist Birth:", "artistBirthId", "artistBirth", "New Artist Birth Year", "artistBirthLabel", "PLease enter the new artist birth year (must be a number)"));

									out.println(generateInputBox("artistCountryDiv", "addImage-artistCountry", "New Artist Country:", "artistCountryId", "artistCountry", "New Artist Country", "artistCountryLabel", "Please enter the country of the artist"));

									out.println(generateInputTextBox("artistDescriptionDiv", "addImage-artistDescription", "New Artist Decription:", "artistDescriptionId", "artistDescription", "(optional)", "artistDescriptionLabel", "Please enter the artist description"));
								}
							%>
					
						</div>
					</div>

					<div class="modal-footer">
						<a class="btn btn-default" data-dismiss="modal">Cancel</a>
						<button class="btn btn-primary" type="submit">Add</button>
					</div>
				</form>
			</div>
		</div>
	</div>	

	<%
		if(request.getParameter("aid") == null || request.getParameter("aid") == "") {
			out.println("<script>function ShowHideArtistInput () { if (document.getElementById('artistSelectID').value == '0') { document.getElementById('artistInfo').style.display = 'block'; } else { document.getElementById('artistInfo').style.display = 'none'; } }</script>");
		}
	%>

	<script>
		
		function ShowRangeOrSearchInput () {
			if (document.getElementById("searchSelectID").value == "creation_year") {
				document.getElementById("creation_yearDiv").style.display = "block";
				document.getElementById("searchDiv").style.display = "none";
				document.getElementById("searchArtistDiv").style.display = "none";
				
			}
			else if (document.getElementById("searchSelectID").value == "artist_name") {
				document.getElementById("creation_yearDiv").style.display = "none";
				document.getElementById("searchDiv").style.display = "none";
				document.getElementById("searchArtistDiv").style.display = "block";

			}
			else {
				document.getElementById("creation_yearDiv").style.display = "none";
				document.getElementById("searchDiv").style.display = "block";
				document.getElementById("searchArtistDiv").style.display = "none";
			}
		}

		function ShowHideSearch () {
			document.getElementById("searchShowHideDiv").style.display = "block";
		}

		function PreviewImg () {
			var imgLinkValue = document.getElementById("imageLinkId").value;
			if (imgLinkValue == null || imgLinkValue == "") {
				alert ("Please enter a link before previewing");
				document.getElementById("imgPreviewDiv").style.display = "none";
			}
			else {
				$('#imgId').attr('src', imgLinkValue);
				document.getElementById("imgPreviewDiv").style.display = "block";
			}
		}

		function checkValidation () {
			var iTitle = document.forms["imageForm"]["imageTitle"].value;
			var iLink = document.forms["imageForm"]["imageLink"].value;
			var iYear = document.forms["imageForm"]["imageYear"].value;
			var iType = document.forms["imageForm"]["imageType"].value;
			var iWidth = document.forms["imageForm"]["imageWidth"].value;
			var iHeight = document.forms["imageForm"]["imageHeight"].value;
			var iLocation = document.forms["imageForm"]["imageLocation"].value;

			var aId = document.forms["imageForm"]["artistSelectID"].value;
			var aName = document.forms["imageForm"]["artistName"].value;
			var aBirth = document.forms["imageForm"]["artistBirth"].value;
			var aCountry = document.forms["imageForm"]["artistCountry"].value;
		

			if (iTitle == null || iTitle == "" 
				|| iLink == null || iLink == ""
				|| iYear == null || iYear == "" || !isNumeric(iYear)
				|| iType == null || iType == ""
				|| iWidth == null || iWidth == "" || !isNumeric(iWidth)
				|| iHeight == null || iHeight == "" || !isNumeric(iHeight)
				|| iLocation == null || iLocation == ""
				|| ((aId == "0") && (aName == null || aName == "" || aBirth == null || aBirth == "" || !isNumeric(aBirth)
					 || aCountry == null || aCountry == ""))) {
				
				alert ("Please fill fix the indicated inputs");

				if (iTitle == null || iTitle == "") {
					$('#imgTitleDiv').addClass('has-error');
					document.getElementById("imgTitleLabel").style.display = "block";
				}
				else {
					$('#imgTitleDiv').removeClass('has-error');
					document.getElementById("imgTitleLabel").style.display = "none";
				}

				if (iLink == null || iLink == "") {
					$('#imgLinkDiv').addClass('has-error');
					document.getElementById("imgLinkLabel").style.display = "block";
				}
				else {
					$('#imgLinkDiv').removeClass('has-error');
					document.getElementById("imgLinkLabel").style.display = "none";
				}
				
				if (iYear == null || iYear == "" || !isNumeric(iYear)) {
					$('#imgYearDiv').addClass('has-error');
					document.getElementById("imgYearLabel").style.display = "block";
				}
				else {
					$('#imgYearDiv').removeClass('has-error');
					document.getElementById("imgYearLabel").style.display = "none";
				}
				
				if (iType == null || iType == "") {
					$('#imgTypeDiv').addClass('has-error');
					document.getElementById("imgTypeLabel").style.display = "block";
				}
				else {
					$('#imgTypeDiv').removeClass('has-error');
					document.getElementById("imgTypeLabel").style.display = "none";
				}
				
				if (iWidth == null || iWidth == "" || !isNumeric(iWidth)) {
					$('#imgWidthDiv').addClass('has-error');
					document.getElementById("imgWidthLabel").style.display = "block";
				}
				else {
					$('#imgWidthDiv').removeClass('has-error');
					document.getElementById("imgWidthLabel").style.display = "none";
				}

				if (iHeight == null || iHeight == "" || !isNumeric(iHeight)) {
					$('#imgHeightDiv').addClass('has-error');
					document.getElementById("imgHeightLabel").style.display = "block";
				}
				else {
					$('#imgHeightDiv').removeClass('has-error');
					document.getElementById("imgHeightLabel").style.display = "none";
				}

				if (iLocation == null || iLocation == "") {
					$('#imgLocationDiv').addClass('has-error');
					document.getElementById("imgLocationLabel").style.display = "block";
				}
				else {
					$('#imgLocationDiv').removeClass('has-error');
					document.getElementById("imgLocationLabel").style.display = "none";
				}

				if (aId == "0") {
					if (aName == null || aName == "") {
						$('#artistNameDiv').addClass('has-error');
						document.getElementById("artistNameLabel").style.display = "block";
					} 
					else {
						$('#artistNameDiv').removeClass('has-error');
						document.getElementById("artistNameLabel").style.display = "none";
					}

					if (aBirth == null || aBirth == "" || !isNumeric(aBirth)) {
						$('#artistBirthDiv').addClass('has-error');
						document.getElementById("artistBirthLabel").style.display = "block";
					} 
					else {
						$('#artistBirthDiv').removeClass('has-error');
						document.getElementById("artistBirthLabel").style.display = "none";
					}

					if (aCountry == null || aCountry == "") {
						$('#artistCountryDiv').addClass('has-error');
						document.getElementById("artistCountryLabel").style.display = "block";
					} 
					else {
						$('#artistCountryDiv').removeClass('has-error');
						document.getElementById("artistCountryLabel").style.display = "none";
					}
				}

				return false;
			} 
		}

		function isNumeric(n) {
			return !isNaN(parseFloat(n)) && isFinite(n);
		}
	</script>

<%@include file="includes/footer.jsp" %>