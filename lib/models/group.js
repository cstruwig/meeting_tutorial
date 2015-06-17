'use strict';

var ns = require('../tools/ns');
var mysql = require('mysql');
var connectionInfo = require('../../dbconfig.json');
var connection = mysql.createConnection(connectionInfo);

var postProcess = function(data, cb) {
	//advanced data filtering/manipulation "before returning data"...
	ns.logger.info('SQL>' + JSON.stringify(data));	
	cb(null, data);
}

var parseOptions = function(options) {
	//options : paging, order, selection, advancedFilter
	options.page = options.page || -1;
	options.size = options.size || -1;
	
	return options;
};

exports.getById = function(options, cb) {
	var options = parseOptions(options);
	var sql = 'CALL api_get_group_by_id ("' + options.id + '");';
	ns.logger.info('SQL:' + sql);
	connection.query(sql, function(err, rows, fields) {
		if (err) return cb(err, null)
		postProcess(rows[0], cb);
	});
};

exports.findByName = function(options, cb) {
	var options = parseOptions(options);

	var sql = 'CALL api_find_group ("' + options.name + '", ' + options.page + ', ' + options.size + ');';
	ns.logger.info('SQL:' + sql);

	connection.query(sql, function(err, rows, fields) {
		if (err) return cb(err, null);
		postProcess(rows[0], cb);
	});
};

exports.getAll = function(options, cb) {
	var options = parseOptions(options);
	var sql = 'CALL api_get_group(' + options.page + ', ' + options.size + ');';
	ns.logger.info('SQL:' + sql);

	connection.query(sql, function(err, rows, fields) {
		if (err) return cb(err, null);
		postProcess(rows[0], cb);			//i think the LIMIT option cause an extra row to be returned...
	});
};

exports.addGroup = function(group, cb) {

	if (!group.group_name || !group.address_line_1 || !group.address_city || !group.address_province_code || !group.facilitator_id)
		return cb(new Error('empty or insufficient model specified'));

console.log('----------------------------');
console.log(group);

	var sql = 'CALL api_add_group("' + group.group_name + '", "' + group.address_line_1 + '", "' + group.address_line_2 + '", "' + group.address_city + '", "' + group.address_province_code + '", ' + group.facilitator_id + ');';
	ns.logger.info('SQL:' + sql);

	connection.query(sql, function(err, rows, fields) {
console.log(err, rows, fields);		
		if (err) return cb(err, null);

		postProcess(rows[0], cb);			//i think the LIMIT option cause an extra row to be returned...
	});

	// Group.find({ id: vacancy.id }, function(err, result) {
	// 	if (err) return cb(err, null);
	// 	if (result && result.length > 0) {
	// 		var existingResult = (result[0] || result);
	// 		existingResult.attributes = { existing: true };
	// 		return cb(null, existingResult);
	// 	}

	// 	var newVacancy = new Vacancy(vacancy);
	// 	newVacancy.save(cb);
	// });
};

exports.updateGroup = function(group, cb) {

	console.log('group = ', group);

	if (!group.id && (!group.group_name && !group.address_line_1 && !group.address_city && !group.address_province_code && !group.facilitator_id) )
		return cb(new Error('empty or insufficient model specified'));

	var sql = 'CALL api_update_group("' + group.id + '", "' + (group.group_name || null) + '", "' + (group.address_line_1 || null) + '", "' + (group.address_line_2 || null) + '", "' + (group.address_city || null) + '", "' + (group.address_province_code || null) + '", ' + (group.facilitator_id || null) + ');';
	ns.logger.info('SQL:' + sql);

	connection.query(sql, function(err, rows, fields) {
		if (err) return cb(err, null);

		postProcess(rows[0], cb);			//i think the LIMIT option cause an extra row to be returned...
	});
};

exports.deleteGroup = function(groupId, cb) {

	if (!groupId)
		return cb(new Error('empty or insufficient model specified'));

	var sql = 'CALL api_delete_group("' + groupId + '");';
	ns.logger.info('SQL:' + sql);

	connection.query(sql, function(err, rows, fields) {
		if (err) return cb(err, null);

		postProcess(rows[0], cb);			//i think the LIMIT option cause an extra row to be returned...
	});
};

exports.hack = function(options, cb) {
	//options : unsafeStatement, skipPostProcessing
	connection.query(unsafeStatement, function(err, rows, fields) {
		if (err) return cb(err, null);
		postProcess(rows[0], cb);
	});
};