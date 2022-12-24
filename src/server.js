const express = require("express");
const bodyParser = require("body-parser");
const mysql = require("mysql2");
const crypto = require("crypto");
const passport = require("passport");
const LocalStrategy   = require('passport-local').Strategy;
const app = express();
var session = require("express-session");
var MySQLStore = require("express-mysql-session")(session)
var alert = require('alert');
const { promiseImpl } = require("ejs");

//connect to the cookie - session database
app.use(session({
    key:'session_cookie_name',
    secret: 'session_cookie_secret',
    store: new MySQLStore({
        host:'localhost',
        port: 3306,
        user:'root',
        password:'Password123$',
        database:'cookie_user'
    }),
    resave : false,
    saveUninitialized: false,
    cookie : {
        maxAge : 1000*60*60*24,
    }
}));

app.use(passport.initialize());
app.use(passport.session());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public'));
app.set("view engine", "ejs");

//connect to the art database for data access
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
      console.log("Conection Failed ArtDB - " + err);
    }
  });

const customFields={
    usernameField:'uname',
    passwordField:'pw',
};

//Passport Session for user authentication
const verifyCallback=(username,password,done)=>{
   
    connection.query('SELECT * FROM artistlogin WHERE artistUserName = ?', 
    [username], function(error, results, fields) {
       if (error) {
           return done(error);
       }
       if(results.length==0)
       {
           return done(null,false);
       }
       const isValid=validPassword(password,results[0].hash,results[0].salt);
       user={id:results[0].artistID,username:results[0].artistUserName,hash:results[0].hash,salt:results[0].salt};
       if(isValid)
       {
           return done(null,user);
       }
       else{
           return done(null,false);
       }
   });
};

passport.serializeUser((user,done)=>{
   done(null,user.id)
});

passport.deserializeUser(function(userId,done){
   connection.query('SELECT * FROM artistlogin where artistid = ?',[userId], function(error, results) {
           done(null, results[0]);    
   });
});

const strategy = new LocalStrategy(customFields,verifyCallback);
passport.use(strategy);

// Middleware for user authentication 
function validPassword(password,hash,salt)
{
    var hashVerify=crypto.pbkdf2Sync(password,salt,10000,60,'sha512').toString('hex');
    return hash === hashVerify;
}

function genPassword(password)
{
    var salt=crypto.randomBytes(32).toString('hex');
    var genhash=crypto.pbkdf2Sync(password,salt,10000,60,'sha512').toString('hex');
    return {salt:salt,hash:genhash};
}


 function isAuth(req,res,next)
{
    if(req.isAuthenticated())
    {
        next();
    }
    else
    {
        res.redirect('/notAuthorized');
    }
}


function isAdmin(req,res,next)
{
    if(req.isAuthenticated() && req.user.isAdmin==1)
    {
        next();
    }
    else
    {
        res.redirect('/notAuthorizedAdmin');
    }   
}

function userExists(req,res,next)
{
    connection.query('SELECT * FROM artistlogin WHERE artistUserName = ?', [req.body.uname], function(error, results, fields) {
        if (error) 
            {
                console.log("Error");
            }
       else if(results.length>0)
         {
            res.redirect('/userAlreadyExists')
        }
        else
        {
            next();
        }
       
    });
}

app.use((req,res,next)=>{
    next();
});

//Routes for pages
app.get('/', (req, res, next) => {

    data = [];

    connection.query('call selectAllArt()', [req.body.uname], function(error, results, fields) {
        if (error) 
            {
                console.log("Error");
            }
       else if(results.length>0)
         {
            for (i = 0; i < results[0].length; i++) {
                data.push(results[0][i]);
              }
            res.render('home', data);
        }
        else
        {
            next();
        }
    });
});

app.get('/adminlogin', (req, res, next) => {
    res.render('adminlogin');
});

app.get('/admin-login-success', (req, res, next) => {
    res.redirect('/adminmain');
});

app.get('/admin-login-failure', (req, res, next) => {
    alert("Incorrect username or password! Please try again.");
    res.redirect('/adminlogin');
});

app.get('/login', (req, res, next) => {
    res.render('login');
});

app.get('/login-success', (req, res, next) => {
    res.redirect('/usermain');
});

app.get('/login-failure', (req, res, next) => {
    alert("Incorrect username or password! Please try again.");
    res.redirect('/login');
});

app.get('/logout', (req, res, next) => {
    req.logout(function(err) {
        if (err) { return next(err); }
        res.redirect('/login');
      });
});

app.get('/register', (req, res, next) => {
    res.render('register');
});

app.get('/usermain',isAuth,(req, res, next) => {
 
    data = [];

    connection.query('call selectAllArt()', function(error, results, fields) {
        if (error) 
            {
                console.log("Error" + error);
            }
       else if(results.length>0)
         {
            for (i = 0; i < results[0].length; i++) {
                data.push(results[0][i]);
              }
              res.render('usermain', data);
        }
        else
        {
            next();
        }
    });
});

app.get('/userworks',isAuth,(req, res, next) => {
 
    data = [];
    var artistID = req.user.artistID;

    connection.query('call selectArtForArtist(?)', [artistID], function(error, results, fields) {
        if (error) 
            {
                console.log("Error" + error);
            }
       else if(results.length>0)
         {
            for (i = 0; i < results[0].length; i++) {
                data.push(results[0][i]);
              }
              res.render('userworks', data);
        }
        else
        {
            next();
        }
    });
});

app.get('/addart', (req, res, next) => {
    res.render('addartwork'); 
});

app.get('/adminmain',isAdmin,(req, res, next) => {
 
    data = [];

    connection.query('call selectAllArt()', function(error, results, fields) {
        if (error) 
            {
                console.log("Error" + error);
            }
       else if(results.length>0)
         {
            for (i = 0; i < results[0].length; i++) {
                data.push(results[0][i]);
              }
              res.render('adminmain', data);
        }
        else
        {
            next();
        }
    });
});

app.get('/admindeleteartwork', (req, res, next) => {
    res.render('admindeleteartwork');
});

app.get('/adminupdatemuseum', (req, res, next) => {
    res.render('adminupdatemuseum');
});

app.get('/adminstats', (req, res, next) => {

    data = {"isData" : true, "TotalArt" : 0, 
            "TotalArtist" : 0, "TotalMuseum" : 0, 
            "TotalMedium" : 0, "styledata" : {}, 
            "mediumData" : {}, "museumData" : {}, 
            "artistData" : []};

    connection.query('call allStats()', function(error, results, fields) {
        if (error) 
            {
                console.log("Error" + error);
            }
       else if(results.length>0)
         {

            data.TotalArt = results[0][0].TotalArt;
            data.TotalArtist = results[1][0].TotalArtist;
            data.TotalMuseum = results[2][0].TotalMuseum;
            data.TotalMedium = results[3][0].TotalMedium;
            data.artistData = results[4];
            data.styledata = results[5];
            data.mediumData = results[6];
            data.museumData = results[7];

            res.render('adminstats', {data: data}); 
        }
        else
        {
            next();
        }
    });

});

app.get('/notAuthorized', (req, res, next) => {
    alert("You are not authorized to login. Retry login.");
    res.redirect('/login');
});

app.get('/notAuthorizedAdmin', (req, res, next) => {
    alert("You are not authorized to login. Retry login.");
    res.redirect('/adminlogin');
});

app.get('/userAlreadyExists', (req, res, next) => {
    alert("Sorry This username is taken. Register with different username");
    res.redirect('/register');
});

app.post('/register',userExists,(req,res,next)=>{
    const saltHash=genPassword(req.body.pw);
    const salt=saltHash.salt;
    const hash=saltHash.hash;

    connection.query('call createArtist(?,?,?,?,?,?,?,0) ', [req.body.uname,req.body.name, req.body.country, 
        req.body.dob, req.body.gender, hash,salt], function(error, results, fields) {
        if (error) 
            {
                console.log("Error" + error);
            }
        else
        {
            console.log("Successfully Entered");
        }
    });

    res.redirect('/login');
});

app.post('/login',passport.authenticate('local',{failureRedirect:'/login-failure',successRedirect:'/login-success'}));

app.post('/adminlogin', passport.authenticate('local',{failureRedirect:'/admin-login-failure',successRedirect:'/admin-login-success'}));

app.post('/addart',(req,res,next)=>{

    var artistID = req.user.artistID;

    connection.query('call createArtObjectForArtist(?,?,?,?,?,?,?,?,?) ', [req.body.title, 
        req.body.museum, req.body.material, req.body.style, 
        req.body.cred, req.body.imageurl, req.body.dim, req.body.datecreation, artistID], 
        function(error, results, fields) {
        if (error) 
            {
                console.log("Error - " + error);
            }
        else
        {
            console.log("Successfully created");
        }
    });
    res.redirect('/usermain');
});

app.post('/deleteart', (req, res, next) => {

    connection.query('call deleteArtObject(?,?,?,?) ', [req.body.title, 
        req.body.aname, req.body.museum, req.body.datecreation], 
        function(error, results, fields) {
        if (error) 
            {
                alert("Incorrect artwork information entered. Please try again.");
                console.log("Error - " + error);
            }
        else
        {
            console.log("Successfully deleted");
        }
    });
    res.redirect('/admindeleteartwork');
});

app.post('/updatemuseum', (req, res, next) => {

    connection.query('call updateArt(?,?,?,?,?) ', [req.body.title, 
        req.body.aname, req.body.museum, req.body.nmuseum, req.body.datecreation], 
        function(error, results, fields) {
        if (error) 
            {
                alert("Incorrect artwork information entered. Please try again.");
                console.log("Error - " + error);
            }
        else
        {
            console.log("Successfully updated");
        }
    });
    res.redirect('/adminupdatemuseum');
});

app.listen(3000, function() {
    console.log('App listening on port 3000!')
});
