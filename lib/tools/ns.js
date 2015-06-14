module.exports = {
	get authorization() {
		return require('./authorization');
	},
	get collections() {
		return require('./collections');
	},
	get convert() {
		return require('./convert');
	},
	get logger() {
		return require('./logger');
	},
	get transform() {
		return require('./transform');
	}
};