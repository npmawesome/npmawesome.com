/*
 * npmawesome.com
 *
 * Copyright(c) 2014 Alex Gorbatchev  <alex.gorbatchev@gmail.com> and André König <andre.koenig@posteo.de>
 * MIT Licensed
 *
 */

/**
 * @author André König <andre.koenig@posteo.de>
 *
 */

'use strict';

var path = require('path');
var rimraf = require('rimraf');

var api = require('./api');
var git = require('./git');

module.exports = function (BasePlugin) {

    return BasePlugin.extend({
        name: 'examples',

        generateBefore : function generateBefore (opts, done) {
            var docpad = this.docpad;
            var wdir = path.join(process.cwd(), '.examples');
            var steps = [];


            function next (err, data) {
                var fn;

                if (err) {
                    // TODO: How to handle the error within the plugin.
                    // done();
                    return;
                }

                fn = steps.shift();

                if (!fn) {
                    return done();
                }

                (data)?
                    fn(data, next):
                    fn(next);
            }

            steps.push(function clean (callback) {
                docpad.log('info', 'Cleaning cloned example directory "' + wdir + '"...');
                rimraf(wdir, callback);
            });

            steps.push(function fetch (callback) {
                docpad.log('info', 'Fetching repository list from the GitHub API ...');

                api.listRepositories('example-', function (err, repos) {
                    if (err) {
                        return callback(err);
                    }

                    repos.forEach(function (repo) {
                        steps.push(function clone (callback) {
                            docpad.log('info', 'Cloning from "' + repo.clone_url + '" ...');

                            git.clone(repo, wdir, callback);
                        });
                    });

                    callback();
                });
            });

            next();
        }
    });
};