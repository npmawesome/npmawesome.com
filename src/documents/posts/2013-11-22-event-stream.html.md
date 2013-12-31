---
layout: post
date: 2013-11-22T15:20:01.275735-08:00
tags: npm, javascript, streams, events
npm:
  repo: &repo dominictarr/event-stream
  name: &name event-stream
slug: *name
title: *name
---
<img class="hide-on-mobile" src="/images/posts/event-stream.gif" style="width: 200px; float: right"/>

[event-stream](https://github.com/dominictarr/event-stream) is a toolkit to make creating and working with streams easy..

    npm install event-stream

The usage is pretty straight forward:

    var es = require('event-stream');

    es.pipeline(                         // connect streams together with `pipe`
      process.openStdin(),               // open stdin
      es.split(),                        // split stream to break on newlines
      es.map(function (data, callback) { // turn this async function into a stream
        callback(null
          , inspect(JSON.parse(data)))   // render it nicely
      }),
      process.stdout                     // pipe it to stdout!
    );

I found the `map` function to be especially exciting because it takes a callback and lets you asynchronously process stream data where as regular stream `data` event does not.

There are plenty of examples and information on the [github page](https://github.com/dominictarr/event-stream).

