'use strict';

var ns = require('../tools/ns');

var postProcess = function(data, cb) {
	//advanced data filtering/manipulation "before returning data"...
	cb(null, data);
};

exports.addToken = function(credentials, cb) {
	var sql = 'CALL api_add_token("' + credentials.client_id + '", "' + credentials.client_secret + '", "' + credentials.host + '");';
	ns.logger.info('SQL:' + sql);
	ns.db.query(sql, function(err, rows, fields) {
		if (err || (rows && rows.length === 0)) {
			return cb(err || new Error('failed to generate token'));
		}

		var token = rows[0][0] || {};		
		ns.logger.info('SQL>' + JSON.stringify(token));
		postProcess(token, cb);
	});
};

exports.getToken = function(credentials, cb) {
	var sql = 'CALL api_get_token("' + credentials.token + '", "' + credentials.hostName + '");';
	ns.logger.info('SQL:' + sql);
	ns.db.query(sql, function(err, rows, fields) {
		if (err || (rows && rows.length === 0)) {
			return cb(err || new Error('failed to validate token'));
		}

		var token = rows[0][0] || {};		
		ns.logger.info('SQL>' + JSON.stringify(token));
		postProcess(token, cb);
	});
};

