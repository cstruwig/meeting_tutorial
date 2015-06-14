'use strict';

var changeCase = require('change-case');

exports.properties = function(data, mapping, options) {
	//there doesn't seem to be a standard JSON transform library yet :)
	//eg. mapping = { property_name: 'new_property_name', another_property_name: 'to_be_replaced_with_this' }

	var options = options || {};
	var result = {};

	function fixCase(property) {

		var result = property;
		if (options && options.fixCase) {
			switch (options.fixCase) {
				case 'camel' :
					result = changeCase.camelCase(property);
					break;
				case 'snake' :
					result = changeCase.snakeCase(property).toLowerCase();
					break;
				//FIX! add others (https://www.npmjs.com/package/change-case)		
				default:
					break;
			}
		}
		return result;
	}

	//FIX! if a mapping[key] "violates" the camelCase "rule" it wont be affected as the function replaces the changedCase keys...
	//one solution is to also change the mapping! but that's dangerous... or is it?
	for (var key in mapping) {
		var newKey = fixCase(key) || key;
		if (key !== newKey) {
			mapping[newKey] = mapping[key];
			delete mapping[key];
			key = newKey;
		}
	}

    for (var key in data) {
		if (data.hasOwnProperty(key)) {

			//change the original property case
			var newKey = fixCase(key) || key;
			if (key !== newKey) {
				data[newKey] = data[key];
				delete data[key];
				key = newKey;
			}

			if (data[key] instanceof Array) {
                if (mapping[key]) {
                    var newName = mapping[key];
                    result[newName] = exports.properties(data[key], mapping, options);
                } else if (!mapping[key]) {
                	result[key] = exports.properties(data[key], mapping, options);
                }
            } else if (typeof data[key] === 'object') {
                if (mapping[key]) {
                	var newName = mapping[key];
                    result[newName] = exports.properties(data[key], mapping, options);
                } else if (!mapping[key]) {
                    result[key] = exports.properties(data[key], mapping, options);
                }
            } else {
                if (mapping[key]) {
                	var newName = mapping[key];
                	result[newName] = data[key];
                } else if (!mapping[key]) {
					result[key] = data[key];
                }
            }
        }
    };

    return result;
};