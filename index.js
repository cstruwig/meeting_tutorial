'use strict';

require('restify');

var server = require('./lib/server').create();
var port = process.env.PORT || 3001;

server.listen(port, function() {
  console.log('%s#%s listening at %s', server.name, server.versions, server.url);
});