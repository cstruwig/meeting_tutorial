'use strict';

var ns = require('../tools/ns');
var mysql = require('mysql');
var connectionInfo = require('../../dbconfig.json');
var connection = mysql.createConnection(connectionInfo);

var postProcess = function(data, cb) {
	//advanced data filtering/manipulation "before returning data"...
	ns.logger.info('SQL>' + JSON.stringify(data));	
	cb(null, data);
};

var parseOptions = function(options) {
	//options : paging, order, selection, advancedFilter
	options.page = options.page || -1;
	options.size = options.size || -1;
	
	return options;
};

exports.getByName = function(options, cb) {
	var options = parseOptions(options);

	var sql = 'CALL api_get_list_by_name("' + options.name + '", ' + options.page + ', ' + options.size + ');';
	ns.logger.info('SQL:' + sql);
	connection.query(sql, function(err, rows, fields) {
		if (err || (rows && rows.length === 0)) {
			return cb(err || new Error('failed to get list'));
		}
		postProcess(rows[0], cb);
	});
};

