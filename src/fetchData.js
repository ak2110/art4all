const express = require("express");
const bodyParser = require("body-parser");
const mysql = require("mysql2");
const app = express();

// MET public api url to get all available objects 
const all_obj_url = "http://collectionapi.metmuseum.org/public/collection/v1/objects"
const obj_url = "http://collectionapi.metmuseum.org/public/collection/v1/objects/"

var connection = mysql.createConnection({
    host: "localhost",
    port: 3306,
    user: "root",
    password: "Password123$",
    database: "art",
    multipleStatements: true
  });
  connection.connect((err) => {
    if (!err) {
      console.log("Connected");
    } else {
      console.log("Conection Failed - " + err);
    }
  });

// GET available art objects from the public api
async function getdata() {
	
	let i = 0;
	var j;
	// Storing response
	const response = await fetch(all_obj_url);
	
	// Storing data in form of JSON
	var data = await response.json();
	console.log(data.objectIDs);
    
    objectIDs = data.objectIDs;

	// To fetch the artwork data for art database
	while(i < 250) {

		j = Math.floor(Math.random() * 482989);
		const response = await fetch(obj_url + objectIDs[j]);
		var data = await response.json();

		if(validObjectData(data)) {
			putobjdata(data);
			i = i + 1;
		}
	}
	console.log("Your data is ready to use!");
}

// Checks the validity of extracted data
function validObjectData(data) {

	if(data.repository == "") {
		return false;
	}
	if(data.country == "") {
		return false;
	}
	if(data.medium == ""){
		return false;
	}
	if(data.objectBeginDate == ""){
		return false;
	}
	if(data.creditLine == "") {
		return false;
	}
	if(data.primaryImageSmall == ""){
		return false;
	}
	if(data.title == "") {
		return false;
	}
	if(data.dimensions == "") {
		return false;
	}
	if(data.artistDisplayName == "") {
		return false;
	}
	if(data.artistNationality == "") {
		return false;
	}
	return true;
}

function dateGenerator() {
	return new Date(+(new Date()) - Math.floor(Math.random() * 10000000000));
}

// Inserts artwork data with the specified object ID into database
function putobjdata(data) {

	// Extracting data from api response

	// Museum name
	var museumName = data.repository;

	// Country name
	var countryName = data.country;

	// Material name
	var materialUsed = data.medium;

	// Style 
	var style = data.objectBeginDate;
	var stylePeriod = style.toString().slice(0,2);
	var century = parseInt(stylePeriod, 10) + 1;
	stylePeriod = century.toString();

	// Credit Line
	var credLine = data.creditLine;

	// Image URL 
	var imageURL = data.primaryImageSmall;

	// Title
	var title = data.title;

	// Dimensions
	var dimensions = data.dimensions;

	// Object date
	var objectDate = data.objectBeginDate;
	
	// Artist ID
	// Fetch calling artist name using procedure
	var artistName = data.artistDisplayName;
	var artistCountry = data.artistNationality;
	var artistGender = (parseInt(data.objectID, 10) %2 == 0) ? 'Female' : 'Male' ;
	var artistDOB = (new dateGenerator()).toISOString().split('T').join(' ').split('Z').join('');

	connection.query('call createArtObj(?,?,?,?,?,?,?,?,?,?,?,?,?) ', [
		museumName,countryName,materialUsed,stylePeriod,credLine,
		title, dimensions, imageURL, objectDate, artistName, 
		artistCountry, artistDOB, artistGender], function(error, results, fields) {
        if (error) 
            {
                console.log("Error - " + error);
				return false;
            }
        else
        {
            console.log("Successfully created - " + title);
			return true;
        }
    });
}

// Calling that async function
getdata();