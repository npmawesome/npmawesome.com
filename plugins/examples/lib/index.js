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
var fs = require('fs');
var async = require('async');

var api = require('./api');
var git = require('./git');

var EXAMPLES_DIR = path.join(process.cwd(), '.examples');

module.exports = function (BasePlugin) {
    return BasePlugin.extend({
        name: 'examples',

        generateBefore : function generateBefore (opts, done) {
            var docpad = this.docpad;

            function cloneOrPull (repo) {
                return function (done) {
                    var repoDir = path.join(EXAMPLES_DIR, repo.name);

                    fs.exists(repoDir, function repoExists (exists) {
                        if (exists) {
                            docpad.log('info', 'Pulling "' + repoDir + '"...');
                            git.pull(repoDir, done);
                        }
                        else {
                            docpad.log('info', 'Cloning "' + repo.clone_url + '"...');
                            git.clone(repo, EXAMPLES_DIR, done);
                        }
                    });
                };
            }

            docpad.log('info', 'Fetching repository list from the GitHub API...');

            api.listRepositories('example-', function listRepositories(err, repos) {
                if (err) {
                    return done(err);
                }

                async.parallel(repos.map(cloneOrPull), done);
            });
        }
    });
};