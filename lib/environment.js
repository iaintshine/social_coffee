// Generated by CoffeeScript 1.4.0
(function() {
  var Environment;

  Environment = (function() {
    var environment, _i, _len, _ref;

    function Environment() {}

    Environment.env = process.env.NODE_ENV || 'development';

    Environment.current = Environment.env;

    _ref = ['development', 'test', 'production', 'staging'];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      environment = _ref[_i];
      Environment[environment] = Environment.env === environment;
    }

    return Environment;

  })();

  module.exports = Environment;

}).call(this);
