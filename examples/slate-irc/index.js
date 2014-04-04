var irc = require('slate-irc');
var net = require('net');

var stream = net.connect({
  port: 6667,
  host: 'irc.freenode.org'
});

var client = irc(stream);

client.on('notice', function(notice) {
  console.log(notice.message);
});

client.nick('npmawesome-test');
client.user('npmawesome-test', 'Alex Gorbatchev');
client.join('#flood');

client.names('#flood', function(err, names) {
  if (err) throw err;

  names.sort();
  console.log(names.join('\n'));

  client.quit();
});

