<%--------------------------------------------------------------
Copyright Stefan Cao 2016 - All Rights Reserved          
												          
	Name: Stefan Cao								          
	ID#: 79267250									          
	Assignment: Mini-Project 2						          
												          
	File: artist_gallery.jsp 										 
												          
	Description:	
		show all artists

	History:
		Date 	Update Description 	   		   Developer  
     --------  ---------------------          ------------	     
     10/15/2016 		Created 					SC
--------------------------------------------------------------%>
<% String pageTitle = "Artist Gallery"; %>

<%@include file="includes/header.jsp" %>
<%@include file="utils/DB_utils.jsp" %>
<%@include file="utils/form_utils.jsp" %>

	<%
		if (request.getParameter("r") != null && request.getParameter("r").equals("s")) {
			out.println("<div class='alert alert-success'><strong>Success!</strong> Gallery '" + request.getParameter("returnValue") + "' was added</div>");
		}
	%>

	<button style="margin: 20px; float: left" type="button" class="btn btn-primary" href="#addArtist" data-toggle="modal">Add a new Artist</button>

	<a style="margin: 20px" role="button" class="btn btn-default" onclick="ShowHideSearch();">Search for artist</a>

	<div style='clear:both'></div>

	<!-- hidden div to show the search only when clicked -->
	<div id="searchShowHideDiv" style="display: none">
		<h3>Search for an artist by:</h3>

		<form class="form-horizontal" name="searchForm" method="post" action="artist_gallery.jsp?m=s">

			<!-- search criteria -->
			<div class='form-group' id='selectDiv'>
				<label for='searchArtist' class='col-lg-2 control-label'>
					Search Criteria:
				</label>
				<div class='col-lg-10'>

					<!-- by country or birth year -->
					<select class="selectpicker" id="searchSelectID" name="searchSelect" onchange="ShowRangeOrSearchInput();">
						<option value='country'>Country</option>
						<option value='birth_year'>Birth Year</option>
					</select>
				</div>
			</div>

			<%
				// input for search
				out.println(generateInputBox("searchDiv", "searchImage-input", "Search:", "searchId", "searchName", "", "searchLabel", "Please enter your search criteria"));
			%>

			<div class='form-group' style="margin-left: 115px">
				<button class="btn btn-primary" type="submit">Go</button>
			</div>
		</form>
	</div>

	<h3>Here are all the artist:</h3>

	<!-- list all the artist info -->
	<table class="table">
		<thead>
			<tr>
				<th>Artist</th>
				<th>Birth Year</th>
				<th>Country</th>
				<th>Description</th>
			</tr>
		</thead>
		<tbody>
	
	<%
		try {
			Connection con = DriverManager.getConnection(getURL(),getUser(),getPwd());
			Statement stmt = con.createStatement();
			String sql = "SELECT * FROM artist";
		
			if (request.getParameter("m") != null && request.getParameter("m").equals("s")) {
				if (request.getParameter("searchSelect").equals("country")) {
					sql += " WHERE country='" + request.getParameter("searchName") + "'";
				}
				else {
					sql += " WHERE birth_year=" + request.getParameter("searchName");
				}

			}
			
			ResultSet rs = stmt.executeQuery(sql);

			while (rs.next()) {
				out.println("<tr><td><a href='image_gallery.jsp?aid=" + rs.getString("artist_id") + "'>" + rs.getString("name") + "</a></td><td>" + rs.getString("birth_year") + "</td><td>" + rs.getString("country") + "</td><td>" + rs.getString("description") + "</td></tr>");
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
	</tbody>
	</table>
	
	<div class="modal fade" id="addArtist" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">	
				<form class="form-horizontal" name="artistForm" method="post" action="insert.jsp?t=a" onsubmit="return checkValidation()">

					<input type="hidden" name="location" value=
					<%
						out.println("'" + request.getRequestURI() + "'");
					%>
					>
				
					<div class="modal-header">
						<h4>Add a new Artist</h4>
					</div>
					<div class="modal-body">
						
						<%
							// output the input boxes
							out.println(generateInputBox("artistNameDiv", "addArtist-name", "Artist Name:", "artistNameId", "artistName", "Artist Name", "artistNameLabel", "Please enter the artist name"));

							out.println(generateInputBox("artistBirthDiv", "addArtist-birth", "Artist Birth Year:", "artistBirthId", "artistBirth", "Artist Birth Year", "artistBirthLabel", "Please enter the birth year of the artist (must be a valid year)"));

							out.println(generateInputBox("artistCountryDiv", "addArtist-country", "Artist Country:", "artistCountryId", "artistCountry", "Artist Country", "artistCountryLabel", "Please enter the artist country"));

							out.println(generateInputTextBox("artistDescriptionDiv", "addArtist-Description", "Artist Decription:", "artistDescriptionId", "artistDescription", "(optional)", "artistDescriptionLabel", "Please enter the artist description"));
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
		function ShowHideSearch () {
			document.getElementById("searchShowHideDiv").style.display = "block";
		}

		function checkValidation () {
			var aName = document.forms["artistForm"]["artistName"].value;
			var aBirth = document.forms["artistForm"]["artistBirth"].value;
			var aCountry = document.forms["artistForm"]["artistCountry"].value;
			
			if (aName == null || aName == "" 
				|| aBirth == null || aBirth == "" || !isNumeric(aBirth)
				|| aCountry == null || aCountry == "") {

				alert ("Please fill fix the indicated inputs");
			
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
				
				return false;
			} 
		}

		function isNumeric(n) {
			return !isNaN(parseFloat(n)) && isFinite(n);
		}
	</script>

	
<%@include file="includes/footer.jsp" %>