# Art4All
README for CS 5200 project for Anagha Kadoo and Srinidhi Sunkara.
##### Anagha Kadoo
##### Srinidhi Sunkara
##### Group Name : SunkaraSKadooA

### Tech Stack to be installed
* #### Backend Software: NodeJS and MySQL

  * Follow steps to download Node.js - 
  https://nodejs.org/en/download/

  * Once the node version manager is installed
  execute the command "nvm use 19.2.0"

  * node version : 19.2.0
  * npm version : 8.19.1

  * Check the node.js and npm versions by executing the following commands in the terminal
    * `npm --version`
    * `node --version`


* #### To install the node dependencies
  * Download the project SunkaraSKadooA_project.zip
  * Open the terminal change your directory to `../art4all/src`.
  * Run `npm install`.


* #### To view the code
  * Open the code in visual studio code or your choice of IDE.

* #### To connect to the database
  * Open terminal
  * Change the directory to `../art4all/src`
  * Open `server.js`
  * Change the password to your mysql workbench password in the `lines 21 and 43 in the server.js` file in the src folder.

* #### To create cookie_user database
  * Changes in the mysql side run these lines to
    * `DROP DATABASE IF EXISTS cookie_user;`
    * `CREATE DATABASE IF NOT EXISTS cookie_user;`

* #### To run the server code
  * Open terminal
  * Change the directory to `../art4all/src`.
  * Follow steps in `To install the node dependencies`.
  * Either run `nodemon server.js` or `npm start`.
  * Open any browser of your choice.
  * Go to the url - http://localhost:3000/
  
* #### To fetch data from the MET public API
    * Open terminal
    * Change the pwd to ../art4all/src
    * Navigate to ../art4all/package.json and change line number 8 as `"start" : "nodemon fetchData.js"`and then run `npm start`.
    * Let the script run to fetch data from MET API.
    * In the file a fetch of 250 objects is performed but the user can increase the number by changing line 41 of `../art4all/src/fetchData.js` - `while(i < # Number of your choice)`
    * Once completed change line number 8 in `../art4all/package.json` as `"start" : "nodemon server.js"`.
  
* #### Steps to run the application - 
  * Create `cookie_user` database as mentioned above in `To create cookie_user database`.
  * Create `art` database using the `tableCreationDataDump.sql` file.
  * Populate the database by running all sql scripts in the  `../art4all/Data folder` in the following order - 
   * `art_location.sql`
   * `art_artistlogin.sql`
   * `art_museum.sql`
   * `art_material.sql`
   * `art_credline.sql`
   * `art_style.sql`
   * `art_image.sql`
   * `art_artobject.sql`
  * Optional - Populate the `art` database with the data from MET public API by running `fetchData.js` in the src folder as mentioned above in `To fetch data from the MET public API`.
  * Follow the steps mentioned under `To run the server code` to run the application on your browser. 
  
* #### Please note - 
  * No registration option is available for the admin.
  * There are three existing admin handles which can used for testing the admin flow - 
  
   * ##### Admin 1 -
    * Username - admin1
    * Password - 123
   * ##### Admin 2 -
    * Username - admin2
    * Password - 123
   * ##### Admin 3 -
    * Username - admin3
    * Password - 123
  
  * Database Administrator will give admin access for which a new admin can request. 
  * For the existing artists in the data dump the password is 123.
  * For testing the artist flow with an existing artist from the data dump provided try the artist - 
  
   *  ##### David Vinton - 
    * Username - David Vinton
    * Password - 123  

  * A new artist can create his own account by giving his or her credentials. 
  * Credentials are hashed in the database so even the database administrator can not read the passwords directly.
