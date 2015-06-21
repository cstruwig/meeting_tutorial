'use strict';

var ns = require('../tools/ns');

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
	var sql = 'CALL api_get_meeting_by_id ("' + options.id + '");';
	ns.logger.info('SQL:' + sql);
	ns.db.query(sql, function(err, rows, fields) {
		if (err) return cb(err, null)
		postProcess(rows[0], cb);
	});
};

exports.findByUserId = function(options, cb) {
	var options = parseOptions(options);

	var sql = 'CALL api_find_meeting_by_user_id ("' + options.user_id + '", ' + options.page + ', ' + options.size + ');';
	ns.logger.info('SQL:' + sql);

	ns.db.query(sql, function(err, rows, fields) {
		if (err) return cb(err, null);
		postProcess(rows[0], cb);
	});
};

exports.findByDescription = function(options, cb) {
	var options = parseOptions(options);

	var sql = 'CALL api_find_meeting_by_description ("' + options.description + '", ' + options.page + ', ' + options.size + ');';
	ns.logger.info('SQL:' + sql);

	ns.db.query(sql, function(err, rows, fields) {
		if (err) return cb(err, null);
		postProcess(rows[0], cb);
	});
};

exports.getAll = function(options, cb) {
	var options = parseOptions(options);
	var sql = 'CALL api_get_meeting(' + options.page + ', ' + options.size + ');';
	ns.logger.info('SQL:' + sql);

	ns.db.query(sql, function(err, rows, fields) {
		if (err) return cb(err, null);
		postProcess(rows[0], cb);			//i think the LIMIT option cause an extra row to be returned...
	});
};

exports.addMeeting = function(meeting, cb) {

	if (!meeting.group_id || !meeting.description || !meeting.location || !meeting.start_date)
		return cb(new Error('empty or insufficient model specified'));

//' + meeting.user_id + '
	var sql = 'CALL api_add_meeting(1, ' + meeting.group_id + ', "' + meeting.description + '", "' + meeting.location + '", "' + meeting.start_date + '");';
	ns.logger.info('SQL:' + sql);

	ns.db.query(sql, function(err, rows, fields) {
		if (err) return cb(err, null);
		postProcess(rows[0], cb);			//i think the LIMIT option cause an extra row to be returned...
	});
};

// exports.updateMeeting = function(group, cb) {

// 	console.log('group = ', group);

// 	if (!group.id || (!group.group_name && !group.address_line_1 && !group.address_city && !group.address_province_code && !group.facilitator_id) )
// 		return cb(new Error('empty or insufficient model specified'));

// 	var sql = 'CALL api_update_group("' + group.id + '", "' + (group.group_name || null) + '", "' + (group.address_line_1 || null) + '", "' + (group.address_line_2 || null) + '", "' + (group.address_city || null) + '", "' + (group.address_province_code || null) + '", ' + (group.facilitator_id || null) + ');';
// 	ns.logger.info('SQL:' + sql);

// 	connection.query(sql, function(err, rows, fields) {
// 		if (err) return cb(err, null);

// 		postProcess(rows[0], cb);			//i think the LIMIT option cause an extra row to be returned...
// 	});
// };

exports.deleteMeeting = function(meetingId, cb) {

	if (!meetingId)
		return cb(new Error('empty or insufficient model specified'));

	var sql = 'CALL api_delete_meeting("' + meetingId + '");';
	ns.logger.info('SQL:' + sql);

	ns.db.query(sql, function(err, rows, fields) {
		if (err) return cb(err, null);

		postProcess(rows[0], cb);			//i think the LIMIT option cause an extra row to be returned...
	});
};

exports.hack = function(options, cb) {
	//options : unsafeStatement, skipPostProcessing
	ns.db.query(unsafeStatement, function(err, rows, fields) {
		if (err) return cb(err, null);
		postProcess(rows[0], cb);
	});
};