//light reading ... http://stackoverflow.com/questions/10023636/http-spec-proxy-authorization-and-authorization-headers
'use strict';

var ns = require('../tools/ns');
var Contact = require('../models/contact');
var Dictionary = require('../models/dictionary');

var routePrefix = '';
//intended for stuff like restructuring, versioning, whitelabeling, etc.
//should be configurable (runtime and designtime)

var serveResult = function(data, response, options) {
	//options : transformation logic
	//potential integration point for serving a "final version" dataset to consumers
	var transformedData = ns.transform
								.properties(data,
									Dictionary,
									{ fixCase: 'snake' }	//or camel
								);

	response.setHeader('Access-Control-Allow-Origin', '*');
	response.setHeader('Content-Type', 'application/json');
	response.end(JSON.stringify(data));
};

exports.setupRoutes = function(server) {

	server.get(routePrefix + '/contact', function(request, response) {
		var options = {
			page: request.headers.page || request.query.page || 0,
			size: request.headers.size || request.query.size || 0,
			name: request.params.name
		};

		Contact.getAll(options, function(err, data) {
			var result = { error: request.route.path + ' : ' + err };
			if (err) {
				ns.logger.error('error : %s, %s', request.route.path, err);
			} else {
				result = ns.collections.collection('contact');
				result.name = options.name;
				result.add(data);
			}

			serveResult(result, response);
		});
	});
};