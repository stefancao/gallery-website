<%--------------------------------------------------------------
Copyright Stefan Cao 2016 - All Rights Reserved          
												          
	Name: Stefan Cao								          
	ID#: 79267250									          
	Assignment: Mini-Project 2						          
												          
	File: artist_edit.jsp 										 
												          
	Description:	
		edit artist

	History:
		Date 	Update Description 	   		   Developer  
     --------  ---------------------          ------------	     
     10/26/2016 		Created 					SC
--------------------------------------------------------------%>
<% String pageTitle = "Artist Edit"; %>

<%@include file="includes/header.jsp" %>
<%@include file="utils/DB_utils.jsp" %>

<%!
	// function to generate the edit input box
	private String generateEditInputBox (String divId, String labelFor, String labelTitle, String inputID, String inputName, String inputValue, String labelId, String erMessage) {

		return "<div class='form-group' id='" + divId + "'><label for='" + labelFor + "' class='col-lg-2 control-label'>" + labelTitle + "</label><div class='col-lg-10'><input type='text' class='form-control' id='" + inputID + "' name='" + inputName + "' value='" + inputValue + "'></div><label id='" + labelId + "' style='display: none' class='col-lg-6 control-label' for='inputError'>" + erMessage + "</label></div>";
	}
%>

<%
	String artistId = request.getParameter("id");
	try {

		// establish a connection
		Connection con = DriverManager.getConnection(getURL(),getUser(),getPwd());
		Statement stmt = con.createStatement();

		// get the artist given the artist id
		String sql = "SELECT * FROM artist WHERE artist_id = " + artistId;
		ResultSet rs = stmt.executeQuery(sql);

		rs.next();

		// generate a form
		out.println("<center><form class='form-horizontal' name='artistEditForm' method='post' action='update.jsp?t=a' onsubmit='return checkValidation()'>");

		// send the artist_id
		out.println("<input type='hidden' name='artist_id' value='" + artistId + "'>");

		// generate the input boxes with the values of the previous values
		out.println(generateEditInputBox ("nameDiv", "editArtist-Div", "Name:", "nameId", "name", rs.getString("name"), "nameLabel", "Please fill in artist name"));

		out.println(generateEditInputBox ("birthYearDiv", "editArtist-Div", "Birth Year:", "birthYearId", "birthYear", rs.getString("birth_year"), "birthYearLabel", "Please fill in artist birth year"));

		out.println(generateEditInputBox ("countryDiv", "editArtist-Div", "Country:", "countryId", "country", rs.getString("country"), "countryLabel", "Please fill in artist country"));

		out.println(generateEditInputBox ("descriptionDiv", "editArtist-Div", "Description:", "descriptionId", "description", rs.getString("description"), "descriptionLabel", "Please fill in artist description"));

		out.println("<button class='btn btn-primary' type='submit'>Update</button></form></center>");

		// close connection
		con.close();
		stmt.close();
		rs.close();
	}
	catch(Exception e)
	{
		out.println(e.toString());
	} 	

%>

<script>
	// check the inputs before updating
	function checkValidation() {

		// get the values and store in vars
		var name = document.forms["artistEditForm"]["name"].value;
		var birthYear = document.forms["artistEditForm"]["birthYear"].value;
		var country = document.forms["artistEditForm"]["country"].value;
		var description = document.forms["artistEditForm"]["description"].value;
		
		// if if any inputs are empty
		if (name == null || name == "" 
			|| birthYear == null || birthYear == ""
			|| country == null || country == ""
			|| description == null || description == "") {
			
			// alert that there are errors
			alert ("Please fill fix the indicated inputs");

			if (name == null || name == "") {
				$('#nameDiv').addClass('has-error');
				document.getElementById("nameLabel").style.display = "block";
			}
			else {
				$('#nameDiv').removeClass('has-error');
				document.getElementById("nameLabel").style.display = "none";
			}

			if (birthYear == null || birthYear == "") {
				$('#birthYearDiv').addClass('has-error');
				document.getElementById("birthYearLabel").style.display = "block";
			}
			else {
				$('#birthYearDiv').removeClass('has-error');
				document.getElementById("birthYearLabel").style.display = "none";
			}
			
			if (country == null || country == "") {
				$('#countryDiv').addClass('has-error');
				document.getElementById("countryLabel").style.display = "block";
			}
			else {
				$('#countryDiv').removeClass('has-error');
				document.getElementById("countryLabel").style.display = "none";
			}

			if (description == null || description == "") {
				$('#descriptionDiv').addClass('has-error');
				document.getElementById("descriptionLabel").style.display = "block";
			}
			else {
				$('#descriptionDiv').removeClass('has-error');
				document.getElementById("descriptionLabel").style.display = "none";
			}

			// return false so that user has to fix errors
			return false;
		} 
	}

</script>
	
<%@include file="includes/footer.jsp" %>