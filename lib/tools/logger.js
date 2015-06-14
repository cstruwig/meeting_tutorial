'use strict';

var bunyan = require('bunyan');

var logger = bunyan.createLogger({
  name: 'data-api',
  streams: [
    { stream: process.stdout }
  ],
  serializers: bunyan.stdSerializers
});

module.exports = logger;