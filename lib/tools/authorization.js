var logger = require('./logger');
var Token = require('../models/token');

var serveAccessDenied = function(req, res) {
	logger.error('ACCESS DENIED!');
	res.status(401);
	//FIX! figure out how to redirect to the /token route with WWW-Authenticate...
	//res.setHeader('WWW-Authenticate', 'Basic realm="Placement Partner API"');
	res.send('Unauthorized request');
};

exports.validateRequest = function(req, res, next) {
	var token = req.headers.token || req.query.token;

	//token?
	if (!token) {
		serveAccessDenied(req, res);
		return next();
	}

	//1) check token
	req.authorization.authorized = false;
	req.authorization.token = token;

	var credentials = {
		token: token,
		hostName: req.headers.host
	};

	Token.getToken(credentials, function(err, data) {
		if (err) return next(err, false);
		if (data && data.status === 'active') {
			
			req.authorization.authorized = true;
			req.authorization.company = data.company;

			// res.setHeader('Access-Control-Allow-Origin', '*');

// 			//forEach doesn't have a break!!! but some() does, return true to break;
// 			//this logic checks the request against configured list and ONLY if matched, setup CORS
// 			data.hosts.split(',').some(function(configuredHost) {
// 				if (req.headers.host.toLowerCase() === configuredHost.toLowerCase()) {
// console.log('HTTP:' + req.headers.host, '===', configuredHost);
// 					res.header('Access-Control-Allow-Origin', req.headers.host);
// 					return true;
// 				}
// 			});
			return next(null, true);
		}

		//2) access to resource?
		//var resource = req.getPath().substring(1);
		//FIX! ACL goes here...
		//Token.getPermission(token, resource, eg.)
		
		serveAccessDenied(req, res);
		next();
	});
};