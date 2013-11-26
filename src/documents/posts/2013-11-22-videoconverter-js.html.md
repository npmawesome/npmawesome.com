---
date: 2013-11-22T15:20:01.275735-08:00
layout: post
slug: videoconverter-js
tags: amazeballs, javascript, ffmpeg, emscripten, clientside
title: videoconverter.js
---
<img src="/logos/ffmpeg.png" style="width: 200px; float: right"/>
[videoconverter.js](https://github.com/bgrins/videoconverter.js)
is not really an NPM module, but is a library that allows you to convert
and manipulate videos inside of your web browser. This is achieved by
converting the popular [FFmpeg](http://ffmpeg.org/) library into
JavaScript, using [Emscripten](https://github.com/kripken/emscripten).
In other words, it’s damn impressive! Just [check out the
demo](http://bgrins.github.io/videoconverter.js/demo).

Here’s the fun fact,
[ffmpeg.js](https://github.com/bgrins/videoconverter.js/blob/master/build/ffmpeg.js)
is a whoping 29MB in size. GZipped it comes down to 6MB. I have tried
using [UglifyJS](https://github.com/mishoo/UglifyJS2) to minify the
source and gave up after 1 hour.

There are plenty of examples and information on the [github
page](https://github.com/bgrins/videoconverter.js).

