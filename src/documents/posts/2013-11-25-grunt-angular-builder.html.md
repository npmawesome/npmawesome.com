---
layout: post
date: 2013-11-25T15:19:48.436362-08:00
tags: npm, grunt, plugin, javascript, angularjs, deployment, development
npm:
  repo: &repo claudio-silva/grunt-angular-builder
  name: &name grunt-angular-builder
slug: *name
title: *name
---
[angular-builder](https://github.com/claudio-silva/grunt-angular-builder)
is a specialized Grunt plugin to handle all of AngularJS related assets
issues in a truly practical, automated, simple and easy way.

    npm install angular-builder

<div class="hide-on-mobile" style="position: relative; float: right; height: 200px;">
    <div style="position: relative; width: 200px; height: 200px; background: url('<%- @image '/angularjs.png' %>') 50% 50% no-repeat; background-size: contain"></div>
    <div style="position: absolute; top: 0px; left: 0px; width: 200px; height: 190px; overflow: hidden; background: url('<%- @image '/grunt.png' %>'); background-size: cover"></div>
</div>

Features
--------

1.  Analyzes your AngularJS source code and “understands” module
    dependencies and the relationships between your files. No need for
    AMD or CommonJS loaders.

2.  Accepts source code split into as many files as you want and spread
    over any directory structure you prefer.

3.  Assembles one javascript file (or just a few) for production with
    all code assembled in the correct loading order required by your
    module’s dependencies.

4.  Builds fast in debug mode by generating a single script that loads
    the original source files in the correct order (no minified or
    concatenated files in debug builds).

5.  Allows you to debug the source code in the browser itself and see
    readable source code for any debug breakpoint or error location,
    with the correct original line numbers.

6.  Includes in the build *only* the modules that your app actually
    needs and discards dead code.

7.  Includes in the build the stylesheets and assets each module
    requires and excludes those that are not used by your app.

8.  Can also include in the build scripts that are not based on
    AngularJS.

9.  Recognizes modules and libraries that are loaded independently and,
    therefore, are not part of the build.

10. Not only builds complete applications but also builds library
    projects, generating *readable* redistributable source code files
    for them.

11. Allows each module to have its own build configuration file. Just
    drag-and-drop a module to your project and it’s ready to build!

12. Integrates easily with other Grunt plugins to expand your build
    process with minification, optimization, preprocessing and/or
    compilation st

There are plenty of examples and information on the [github
page](https://github.com/claudio-silva/grunt-angular-builder). Check it
out!

