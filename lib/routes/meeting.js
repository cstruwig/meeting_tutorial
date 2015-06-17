'use strict';

var ns = require('../tools/ns');
var Meeting = require('../models/meeting');
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

	server.get(routePrefix + '/meeting/:id', ns.authorization.validateRequest, function(request, response) {
		ns.logger.info('GET request=' + request.route.path);

		var options = {
			page: request.headers.page || request.query.page || 0,
			size: request.headers.size || request.query.size || 0,
			id: request.params.id
		};

		Meeting.getById(options, function(err, data) {
			var result = { error: request.route.path + ' : ' + err };
			if (err) {
				ns.logger.error('error : %s, %s', request.route.path, err);
			} else {
				result = ns.collections.collection('meeting');
				result.add(data);
			}

			serveResult(result, response);
		});
	});

	server.get(routePrefix + '/meeting', ns.authorization.validateRequest, function(request, response) {
		ns.logger.info('GET:' + request.path());

		var options = {
			page: request.headers.page || request.query.page || 0,
			size: request.headers.size || request.query.size || 0,
			user_id: request.headers.user_id || request.query.user_id,
			description: request.headers.description || request.query.description
		};

		if (!request.authorization.authorized) {
console.log('should exit here!');
			return serveResult(request.authorization, response);
		}

		//DISCUSSION TOPIC: wtf is ref and how does it differ from id?!
		if (options.description) {
			Meeting.findByDescription(options, function(err, data) {
				var result = { error: request.route.path + ' : ' + err };
				if (err) {
					ns.logger.error('error : %s, %s', request.route.path, err);
				} else {
					result = ns.collections.collection('meeting');
					result.add(data);
				}

				serveResult(result, response);
			});
		} else if (options.user_id) {
			Meeting.findByUserId(options, function(err, data) {
				var result = { error: request.route.path + ' : ' + err };
				if (err) {
					ns.logger.error('error : %s, %s', request.route.path, err);
				} else {
					result = ns.collections.collection('meeting');
					result.add(data);
				}

				serveResult(result, response);
			});
		} else {
			Meeting.getAll(options, function(err, data) {
				var result = { error: request.route.path + ' : ' + err };
				if (err) {
					ns.logger.error('error : %s, %s', request.route.path, err);
				} else {
					result = ns.collections.collection('meeting');
					result.add(data);
				}

				serveResult(result, response);
			});
		}
	});

	server.post(routePrefix + '/meeting', ns.authorization.validateRequest, function(request, response) {
		ns.logger.info('POST request=' + request.route.path);
		var meetingData = request.body;

		Meeting.addMeeting(meetingData, function(err, data) {
			var result = { error: request.route.path + ' : ' + err };
			if (err) {
				ns.logger.error('error : %s, %s', request.route.path, err);
			} else {
				result = data;
			}
console.log('data', data);
			serveResult(result, response);
		});
	});

// 	server.put(routePrefix + '/group', ns.authorization.validateRequest, function(request, response) {
// 		ns.logger.info('PUT request=' + request.route.path);
// 		var groupData = request.body;

// 		Group.updateGroup(groupData, function(err, data) {
// 			var result = { error: request.route.path + ' : ' + err };
// 			if (err) {
// 				ns.logger.error('error : %s, %s', request.route.path, err);
// 			} else {
// 				result = data;
// 			}
// console.log('update data', data);
// 			serveResult(result, response);
// 		});
// 	});

};