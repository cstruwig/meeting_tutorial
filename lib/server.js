'use strict';

var npmPackage = require('../package.json');
var restify = require('restify');
var fs = require('fs');

module.exports = {

  create: function() {

    var options = {
      name: npmPackage.name,
      version: npmPackage.version
    };

    var server = restify.createServer(options);
    
    //dear nerds... please read up on these middlewares so you can explain it to me
    server.use(restify.acceptParser(server.acceptable));
    server.use(restify.queryParser());
    server.use(restify.bodyParser());
    server.use(restify.dateParser());
    server.use(restify.authorizationParser());
    server.use(restify.gzipResponse());
    server.pre(restify.pre.sanitizePath());
    server.pre(restify.pre.userAgentConnection());

    server.get('/', function(req, res, cb) {
      //maybe redirect to PP page rather?
      res.send(200, 'server running');
      cb();
    });

    //load and apply all routes
    fs.readdir('./lib/routes/', function(err, files) {
      if (err || !files || files.length === 0) {
        console.log('no routes exist!!!!'); //FIX! create and call serveError()?
        return server;
      }

      files
        .filter(function(file) { return file.substr(-3).toLowerCase() === '.js' })
        .forEach(function(routeModule) {
          require('./routes/' + routeModule).setupRoutes(server);
        });
    });

    return server;
  }
};