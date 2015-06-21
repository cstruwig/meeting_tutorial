'use strict';

var mysql = require('mysql');
var connectionInfo = require('../../dbconfig.json');

module.exports = mysql.createPool(connectionInfo);
