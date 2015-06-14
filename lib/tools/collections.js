'use strict';

/*
used for creating standard JSON structures which facilitates XML conversion
*/

var inflection = require('inflection');
var _ = require('underscore');

exports.collection = function(name) {

	var plural = inflection.pluralize(name);
	var singular = inflection.singularize(name);
	var index = -1;
	
	var result = {
		add: function(obj) {
			if (_.isArray(obj)) {
				obj.forEach(function(item) {
					result[plural][singular].push(item);
				});
			} else {
				this[plural][singular].push(obj);
			}
		},
		get length() {
			var count = this[plural][singular].length;
			if (count === 1) {
				var checkEmpty = 0;
				for (var key in this[plural][singular][0]) {
					checkEmpty++;
				}
				count = (checkEmpty === 0 ? 0 : count);
			}
			return count;
		},
		each: function(callback, args) {
		    var value;
		    var i = 0;
		    var obj = this[plural][singular];
		    var length = obj.length;
		    var isArray = _.isArray(obj);

		    if (args) {
		        if (isArray) {
		            for (; i < length; i++) {
		                value = callback.apply(obj[i], args);

		                if (value === false) {
		                    break;
		                }
		            }
		        } else {
		            for (i in obj) {
		                value = callback.apply(obj[i], args);

		                if (value === false) {
		                    break;
		                }
		            }
		        }
		    } else {
		        if (isArray) {
		            for (; i < length; i++) {
		                value = callback.call(obj[i], i, obj[i]);

		                if (value === false) {
		                    break;
		                }
		            }
		        } else {
		            for (i in obj) {
		                value = callback.call(obj[i], i, obj[i]);

		                if (value === false) {
		                    break;
		                }
		            }
		        }
		    }

		    return obj;
		},
		data: function() {
			//return this (but without top-level elements eg. length and functions)
			//this is for some parsers
			var data = {};
			data[plural] = result[plural];
			return data;
		}
	};
	
	result[plural] = {};
	result[plural][singular] = [];
	
	return result;
}