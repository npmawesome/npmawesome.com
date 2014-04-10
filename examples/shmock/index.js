var
  shmock = require('shmock'),
  request = require('request'),
  assert = require('assert')
  ;

var mock = shmock(9000);

mock
  .get('/foo')
  .query('a=1&b=2')
  .reply(200, 'Hello npmawesome.com')
  ;

request("http://localhost:9000/foo?b=2&a=1", function(err, response) {
  assert.equal(response.statusCode, 200);
  assert.equal(response.body, 'Hello npmawesome.com');
  mock.close();

  console.log('It worked!');
});
