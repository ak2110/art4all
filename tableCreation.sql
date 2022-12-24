-- ***********************************
-- Database Creation
-- ***********************************

DROP DATABASE IF EXISTS cookie_user;
CREATE DATABASE IF NOT EXISTS cookie_user;
DROP DATABASE IF EXISTS ART;
CREATE DATABASE IF NOT EXISTS ART;
USE ART;

-- ***********************************
-- Table Creation for Art database
-- ***********************************
-- location table
-- ***********************************

CREATE TABLE LOCATION
(
	locationID int PRIMARY KEY auto_increment,
    nationality varchar(200) unique
);

-- ***********************************
-- medium table
-- ***********************************

CREATE TABLE MATERIAL
(
	materialID int PRIMARY KEY auto_increment,
    materialUsed varchar(5000)
);

-- ***********************************
-- image table
-- ***********************************

CREATE TABLE IMAGE
(
	imageID int PRIMARY KEY auto_increment,
    imageURL varchar(5000)
);

-- ***********************************
-- style table
-- ***********************************

CREATE TABLE STYLE
(
	centuryID int PRIMARY KEY auto_increment,
    century varchar(200) unique
);

-- ***********************************
-- creditLine table
-- ***********************************

CREATE TABLE CREDLINE
(
	credID int PRIMARY KEY auto_increment,
    description varchar(5000)
);

-- ***********************************
-- artist and admin login table
-- ***********************************

CREATE TABLE ARTISTLOGIN
(
	artistID int PRIMARY KEY auto_increment,
    artistUserName varchar(200) unique,
    artistName varchar(200) unique,
    locationID int,
    artistDOB date,
    artistGender varchar(7),
    hash varchar(200),
    salt varchar(100),
    isAdmin tinyint(4),
    FOREIGN KEY (`locationID`) REFERENCES LOCATION(`locationID`) ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- ***********************************
-- museum table
-- ***********************************

CREATE TABLE MUSEUM
(
	museumID int PRIMARY KEY auto_increment,
    museumName varchar(200) unique
);

-- ***********************************
-- artobject table
-- ***********************************

CREATE TABLE ARTOBJECT
(
	objectID int primary key auto_increment,
    museumID int,
    materialID int ,
    centuryID int,
    credID int ,
    artistID int,
    imageID int,
    objectdate VARCHAR(200),
    title varchar(5000),
    obj_dimension varchar(10000),
    FOREIGN KEY (`museumID`) REFERENCES MUSEUM(`museumID`) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (`materialID`) REFERENCES MATERIAL(`materialID`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY (`centuryID`) REFERENCES STYLE(`centuryID`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY (`credID`) REFERENCES CREDLINE(`credID`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY (`artistID`) REFERENCES ARTISTLOGIN(`artistID`) ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY (`imageID`) REFERENCES IMAGE(`imageID`) ON UPDATE RESTRICT ON DELETE RESTRICT 
);

-- ****************************************
-- Procedure for deserialization of Artist.
-- ****************************************

drop procedure if exists deserializeUser;
delimiter //
create procedure deserializeUser(in artist_id int)
begin
SELECT * FROM artistlogin where artistid = artist_id;
end //
delimiter ;

-- ****************************************
-- Procedure for authentication of Artist.
-- ****************************************

drop procedure if exists authenticateUser;
delimiter //
create procedure authenticateUser(in user_name varchar(200))
begin
SELECT * FROM artistlogin WHERE artistUserName = user_name;
end //
delimiter ;

-- ***********************************
-- Procedure for creation of Artist.
-- ***********************************

drop procedure if exists createArtist;
delimiter //
create procedure createArtist(in userName varchar(200),
	in aname varchar(200),
    in country varchar(200),
    in dob date,
    in gender varchar(7),
    in ahash varchar(200),
    in asalt varchar(100),
    in isArtistAdmin tinyint(4))
begin
DECLARE location_id INT;
	select locationID into location_id from location where nationality = country;
if location_id is null then
	insert into location(nationality) values (country);
end if;
	select locationID into location_id from location where nationality = country;
	insert into artistlogin(artistUserName,artistName,locationID,artistDOB,artistGender,hash,salt,isAdmin) 
		   values(userName,aname,location_id,dob,gender,ahash,asalt,isArtistAdmin);
end //
delimiter ;

-- ***********************************
-- Procedure for selection of all Art.
-- ***********************************

drop procedure if exists selectAllArt;
delimiter //
create procedure selectAllArt()
begin
	    
	select objectID,title,artistName,objectdate,artistGender,obj_dimension,museumName,
    materialUsed,century,description,imageURL from artobject natural join museum 
    natural join material natural join style natural join credline natural join artistlogin natural join image;
	 
end //
delimiter ;

-- ***********************************
-- Procedure for deleting art object.
-- ***********************************

drop procedure if exists deleteArtObject;
delimiter //
create procedure deleteArtObject(
in obj_title varchar(200),
in artist_name varchar(200),
in museum_name varchar(200),
in creationDate varchar(20))
begin
DECLARE object_id INT;

select objectID into object_id from artobject 
    natural join artistlogin 
    natural join museum where artistlogin.artistName = artist_name and museum.museumName = museum_name 
    and objectdate = creationDate and title = obj_title;
if object_id is null then 
signal sqlstate 'ERR0R' set message_text = 'Art object does not exist.';
end if;
delete from artobject where objectID = object_id;
end //
delimiter ;

-- ***********************************
-- Procedure for updating art object.
-- ***********************************

drop procedure if exists updateArt;
delimiter //
create procedure updateArt
(
in obj_title varchar(200),
in artist_name varchar(200),
in old_museum_name varchar(200),
in new_museum_name varchar(200),
in creationDate varchar(20)
)
begin
DECLARE museum_id INT;
DECLARE object_id INT;

select museumID into museum_id from museum where museumName = new_museum_name;

if museum_id is null then

INSERT INTO museum(museumName) VALUES (new_museum_name);
SELECT museumid
into museum_id
FROM museum 
WHERE museumName = new_museum_name;
end if;

select objectID into object_id from artobject 
    natural join artistlogin 
    natural join museum where artistlogin.artistName = artist_name and museum.museumName = old_museum_name 
    and objectdate = creationDate and title = obj_title;

if object_id is null then 
signal sqlstate 'ERR0R' set message_text = 'Art object does not exist.';
end if;

update artobject set museumID = museum_id where objectID = object_id;
end //
delimiter ;

-- **************************************
-- Procedure for creation of art object.
-- **************************************

DROP PROCEDURE IF EXISTS createArtObj;
delimiter //
CREATE PROCEDURE createArtObj(
in museum_name varchar(200),
in countryName varchar(200),
in material_Used varchar(5000),
in style_period varchar(200),
in cred_info varchar(5000),
in obj_title varchar(200),
in objDimensions varchar(200),
in image_URL varchar(5000),
in creationDate varchar(20),
in artist_name varchar(200),
in country varchar(200),
in dob date,
in gender varchar(7))

BEGIN
DECLARE artist_id INT;
DECLARE location_id INT;
DECLARE museum_id INT;
DECLARE material_id INT;
DECLARE century_id INT;
DECLARE cred_id INT;
DECLARE object_id INT;
DECLARE image_id INT;

#check for artist country
SELECT locationID
into location_id
FROM location
WHERE nationality = countryName;

IF location_id IS NULL THEN
INSERT INTO location(nationality) VALUES (countryName);
SELECT locationID
into location_id
FROM location
WHERE nationality = countryName;
end if;

#check for artist 
SELECT artistID
into artist_id
from artistlogin
where artistName = artist_name;

#Password fixed to '123'
IF artist_id IS NULL THEN
insert into artistlogin(artistUserName,artistName,locationID,artistDOB,artistGender,hash,salt,isAdmin) 
		   values( artist_name, artist_name, location_id, dob, gender,
"305b875c52fff6b89dbb99c94c7102d997e4b3e1c02b07800711b840739da3c38e05461f8ba047b1d2740c7a33ba3bf2772883079c090aafac8005b6",
"a793ca92531579db9516f0d198ebe3247d6846ae95083e26f92c522d7aa6eda7", 0);
SELECT artistID
into artist_id
from artistlogin
where artistName = artist_name;
end if;

#check for museum
SELECT museumid
into museum_id
FROM museum 
WHERE museumName = museum_name;

IF museum_id IS NULL THEN
INSERT INTO museum(museumName) VALUES (museum_name);
SELECT museumid
into museum_id
FROM museum 
WHERE museumName = museum_name;
end if;

#check for style
SELECT centuryID into century_id FROM style WHERE century = style_period;

IF century_id IS NULL THEN
INSERT INTO style(century) VALUES (style_period);
SELECT centuryID into century_id FROM style WHERE century = style_period;
end if;

#check for material used
SELECT materialID into material_id FROM material WHERE materialUsed = material_used;

IF material_id IS NULL THEN
INSERT INTO material(materialUsed) VALUES (material_used);
SELECT materialID into material_id FROM material WHERE materialUsed = material_used;
end if;

#check for image
Select imageID into image_id from image where imageURL = image_URL;

if image_id is null then
INSERT INTO image(imageURL) VALUES (image_url);
Select imageID into image_id from image where imageURL = image_URL;
end if;

#check credline
SELECT credID into cred_id FROM credline WHERE description = cred_info;

if cred_id is null then
INSERT INTO credline(description) VALUES (cred_info);
SELECT credID into cred_id FROM credline WHERE description = cred_info;
end if;

#add art object
select objectID into object_id from artobject where title = obj_title and artist_id = artistID and museumID = museum_id and 
cred_id = credID and objDimensions = obj_dimension;

if object_id is null then
INSERT INTO artobject(museumID,materialID,centuryID,credID,artistID,imageID,objectdate,title,obj_dimension) 
values (museum_id, material_id, century_id, cred_id, artist_id, image_id, creationDate, obj_title, objDimensions);
end if;

END //
delimiter ;

-- ***********************************
-- Procedure to select art works 
-- for a particular artist.
-- ***********************************

drop procedure if exists selectArtForArtist;
delimiter //
create procedure selectArtForArtist(in artist_id int)
begin
	    
	select objectID,title,artistName,artistDOB,artistGender,obj_dimension,museumName,materialUsed,century,description,imageURL from artobject natural join museum natural join material natural join style natural join credline
		natural join artistlogin natural join image where artobject.artistID = artist_id;
	 
end //
delimiter ;

-- *************************************************************
-- Procedure for creation of art object for an existing artist.
-- *************************************************************

drop procedure if exists createArtObjectForArtist;
delimiter //
create procedure createArtObjectForArtist(
in obj_title varchar(200),
in museum_name varchar(200),
in material_Used varchar(5000),
in style_period varchar(200),
in cred_info varchar(5000),
in image_URL varchar(5000),
in objDimensions varchar(200),
in creationDate varchar(20),
in artist_id int)
begin
DECLARE museum_id INT;
DECLARE material_id INT;
DECLARE century_id INT;
DECLARE cred_id INT;
DECLARE object_id INT;
DECLARE image_id INT;

#check for museum
SELECT museumid
into museum_id
FROM museum 
WHERE museumName = museum_name;

IF museum_id IS NULL THEN
INSERT INTO museum(museumName) VALUES (museum_name);
SELECT museumid
into museum_id
FROM museum 
WHERE museumName = museum_name;
end if;

#check for style
SELECT centuryID into century_id FROM style WHERE century = style_period;

IF century_id IS NULL THEN
INSERT INTO style(century) VALUES (style_period);
SELECT centuryID into century_id FROM style WHERE century = style_period;
end if;

#check for material used
SELECT materialID into material_id FROM material WHERE materialUsed = material_used;

IF material_id IS NULL THEN
INSERT INTO material(materialUsed) VALUES (material_used);
SELECT materialID into material_id FROM material WHERE materialUsed = material_used;
end if;

#check for image
Select imageID into image_id from image where imageURL = image_URL;

if image_id is null then
INSERT INTO image(imageURL) VALUES (image_url);
Select imageID into image_id from image where imageURL = image_URL;
end if;


#check credline
SELECT credID into cred_id FROM credline WHERE description = cred_info;

if cred_id is null then
INSERT INTO credline(description) VALUES (cred_info);
SELECT credID into cred_id FROM credline WHERE description = cred_info;
end if;

#add art object
select objectID into object_id from artobject where title = obj_title and artist_id = artistID and museumID = museum_id and 
cred_id = credID and objDimensions = obj_dimension;

if object_id is null then
INSERT INTO artobject(museumID,materialID,centuryID,credID,artistID,imageID,objectdate,title,obj_dimension) 
values (museum_id, material_id, century_id, cred_id, artist_id, image_id, creationDate, obj_title, objDimensions);
end if;

end //
delimiter ;

-- ***********************************
-- Procedures for statistics on 
-- artist contribution.
-- ***********************************

drop procedure if exists statsOnArtistContribution;
delimiter //
create procedure statsOnArtistContribution()
begin
select artistlogin.artistName as Artist, count(artobject.artistID) as TotalArt from artobject 
right join artistlogin on artobject.artistID = artistlogin.artistID where isAdmin = 0 group by artistlogin.artistId;
end //
delimiter ;

-- ***********************************
-- Procedures for statistics on 
-- all art.
-- ***********************************

drop procedure if exists statsOnTotalArt;
delimiter //
create procedure statsOnTotalArt()
begin
select count(objectID) as TotalArt from artobject;
end //
delimiter ;

-- ***********************************
-- Procedures for statistics on 
-- all artists.
-- ***********************************

drop procedure if exists statsOnTotalArtist;
delimiter //
create procedure statsOnTotalArtist()
begin
select count(artistID) as TotalArtist from artistlogin where isAdmin = 0;
end //
delimiter ;

-- ***********************************
-- Procedures for statistics on 
-- all museums.
-- ***********************************

drop procedure if exists statsOnTotalMusuem;
delimiter //
create procedure statsOnTotalMusuem()
begin
select count(museumID) as TotalMuseum from museum;
end //
delimiter ;

-- ***********************************
-- Procedures for statistics on 
-- all mediums.
-- ***********************************

drop procedure if exists statsOnTotalMedium;
delimiter //
create procedure statsOnTotalMedium()
begin
select count(materialID) as TotalMedium from material;
end //
delimiter ;

-- ***********************************
-- Procedures for statistics on 
-- all museums.
-- ***********************************

drop procedure if exists statsOnMuseum;
delimiter //
create procedure statsOnMuseum()
begin
select museum.museumName as Museum, ifnull(count(artobject.objectID),0) as TotalArtWorks from artobject 
right join MUSEUM on museum.museumID = artobject.museumID group by museum.museumID;
end //
delimiter ;

-- ***********************************
-- Procedures for statistics on 
-- all mediums used.
-- ***********************************

drop procedure if exists statsOnMedium;
delimiter //
create procedure statsOnMedium()
begin
select material.materialUsed as Medium, ifnull(count(artobject.materialID),0) as TotalArtWorks from artobject 
right join material on material.materialID = artobject.materialID group by material.materialUsed;
end //
delimiter ;

-- ***********************************
-- Procedures for statistics on 
-- style period of art works.
-- ***********************************

drop procedure if exists statsOnStyle;
delimiter //
create procedure statsOnStyle()
begin
select style.century as Century, ifnull(count(artobject.centuryID),0) as TotalArtWorks from artobject 
right join style on ARTOBJECT.centuryID = style.centuryID group by style.centuryID;
end //
delimiter ;

-- ***********************************
-- Procedures for statistics on 
-- all statistics for display 
-- to the admin.
-- ***********************************

drop procedure if exists allStats;
delimiter //
create procedure allStats()
begin
call statsOnTotalArt();
call statsOnTotalArtist();
call statsOnTotalMusuem();
call statsOnTotalMedium();
call statsOnArtistContribution();
call statsOnStyle();
call statsOnMedium();
call statsOnMuseum();
end //
delimiter ;