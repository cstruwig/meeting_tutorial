'use strict';

var ns = require('../tools/ns');
var User = require('../models/user');
var Dictionary = require('../models/dictionary');

var routePrefix = '';
//intended for stuff like restructuring, versioning, whitelabeling, etc.
//should be configurable (runtime and designtime)

var serveResult = function(data, response, options) {
	//options : transformation logic
	//potential integration point for serving a "final version" dataset to consumers

	//standardize/fix property names
	var transformedData = ns.transform
								.properties(data,
									Dictionary,
									{ fixCase: 'snake' }	//or camel
								);

	response.setHeader('Access-Control-Allow-Origin', '*');
	response.setHeader('Content-Type', 'application/json');
	response.end(JSON.stringify(transformedData));
};

exports.setupRoutes = function(server) {

	server.get(routePrefix + '/user/:id', ns.authorization.validateRequest, function(request, response) {
		ns.logger.info('GET request=' + request.route.path);

		var options = {
			page: request.headers.page || request.query.page || 0,
			size: request.headers.size || request.query.size || 0,
			id: request.params.id
		};

		User.getById(options, function(err, data) {
			var result = { error: request.route.path + ' : ' + err };
			if (err) {
				ns.logger.error('error : %s, %s', request.route.path, err);
			} else {
				result = ns.collections.collection('group');
				result.add(data);
			}

			serveResult(result, response);
		});
	});

	server.get(routePrefix + '/user', ns.authorization.validateRequest, function(request, response) {
		ns.logger.info('GET:' + request.path());

		var options = {
			page: request.headers.page || request.query.page || 0,
			size: request.headers.size || request.query.size || 0,
			role: request.headers.role || request.query.role || ''
		};

		if (!request.authorization.authorized) {
console.log('should exit here!');
			return serveResult(request.authorization, response);
		}

		if (options.role) {
			User.getByRole(options, function(err, data) {
				var result = { error: request.route.path + ' : ' + err };
				if (err) {
					ns.logger.error('error : %s, %s', request.route.path, err);
				} else {
					result = ns.collections.collection('user');
					result.add(data);
				}

				serveResult(result, response);
			});
		} else {
			Group.getAll(options, function(err, data) {
				var result = { error: request.route.path + ' : ' + err };
				if (err) {
					ns.logger.error('error : %s, %s', request.route.path, err);
				} else {
					result = ns.collections.collection('group');
					result.add(data);
				}

				serveResult(result, response);
			});
		}
	});

	server.post(routePrefix + '/group', ns.authorization.validateRequest, function(request, response) {
		ns.logger.info('POST request=' + request.route.path);
		var vacancyData = request.body;

		Vacancy.post(vacancyData, function(err, data) {
			var result = { error: request.route.path + ' : ' + err };
			if (err) {
				ns.logger.error('error : %s, %s', request.route.path, err);
			} else {
				result = data;
			}

			serveResult(result, response);
		});
	});

	server.put(routePrefix + '/group', ns.authorization.validateRequest, function(request, response) {
		ns.logger.info('PUT request=' + request.route.path);		
		var vacancyData = request.body;
		Vacancy.put(vacancyData, function(err, data) {
			var result = { error: request.route.path + ' : ' + err };
			if (err) {
				logger.error('error : %s, %s', request.route.path, err);
			} else {
				result = data;
			}

			serveResult(result, response);
		});
	});
};