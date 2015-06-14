//light reading ... http://stackoverflow.com/questions/10023636/http-spec-proxy-authorization-and-authorization-headers
'use strict';

var ns = require('../tools/ns');
var Token = require('../models/token');

var routePrefix = '';
//intended for stuff like restructuring, versioning, whitelabeling, etc.
//should be configurable (runtime and designtime)

var serveResult = function(data, response, options) {
	//FIX! cors!!!

	//options : transformation logic
	//potential integration point for serving a "final version" dataset to consumers
	response.setHeader('Access-Control-Allow-Origin', '*');
	response.setHeader('Content-Type', 'application/json');
	response.end(JSON.stringify(data));
};

exports.setupRoutes = function(server) {

	server.get(routePrefix + '/token/', function(request, response) {

		var credentials = {
			client_id: request.headers.client_id || request.params.client_id,
			client_secret: request.headers.client_secret || request.params.client_secret,
			host: request.headers.host
		};

		//basic auth
		var basicAuthorization = request.authorization;
		if (basicAuthorization && basicAuthorization.basic) {
			credentials.client_id = basicAuthorization.basic.username;
			credentials.client_secret = basicAuthorization.basic.password;
		}

		if (!credentials || !credentials.client_id || !credentials.client_secret) {
			serveResult({ message: 'insufficient credentials specified' }, response);
		} else {
			Token.addToken(credentials, function(err, data) {
				if (err) {
					//failed to generate
					serveResult({ message: 'invalid credentials specified' }, response);
				} else {
					serveResult(data, response);
				}
			});
		}
	});
};