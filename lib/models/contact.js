'use strict';

var ns = require('../tools/ns');

var parseOptions = function(options) {
	//options : paging, order, selection, advancedFilter
	options.page = options.page || -1;
	options.size = options.size || -1;
	
	return options;
};

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

exports.getAll = function(options, cb) {
	var options = parseOptions(options);
	var sql = 'CALL api_get_contact(' + options.page + ', ' + options.size + ');';
	ns.logger.info('SQL:' + sql);

	ns.db.query(sql, function(err, rows, fields) {
		if (err) return cb(err, null);
		postProcess(rows[0], cb);			//i think the LIMIT option cause an extra row to be returned...
	});
};

