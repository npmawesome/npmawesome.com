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

var https = require('https');
var url = require('url');

/**
 * Returns a list of all repositories in the npmawesome.org
 * organization by a given prefix.
 *
 * @param  {string} prefix e.g. 'example-'
 * @param  {function} callback error-first style
 *
 */
exports.listRepositories = function listRepositories (prefix, callback) {
    var options = url.parse('https://api.github.com/orgs/npmawesome/repos');
    var repos = '';

    options.headers = {
        'User-Agent': 'npmawesome.com'
    };

    function onData (chunk) {
        repos = repos + chunk;
    }

    function onEnd () {
        try {
            repos = JSON.parse(repos);
        } catch (e) {
            return callback(new Error('Error while parsing response from GitHub API.'));
        }

        repos = repos.filter(function hasPrefix (repo) {
            return (repo.name.substring(0, prefix.length) === prefix);
        });

        return callback(null, repos);
    }

    function onResponse (res) {
        res.setEncoding('utf8');
        res.on('data', onData);
        res.on('end', onEnd);
    }

    https.request(options, onResponse).end();
};