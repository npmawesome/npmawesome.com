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

var fs = require('fs');
var exec = require('child_process').exec;

/**
 * Clones a given repository.
 *
 * Note that the repo object should come straight
 * from the GitHub API
 *
 * @param  {object} repo
 * @param  {string} wdir The working directory in which the repos should be cloned.
 * @param  {Function} callback error-first style.
 *
 */
exports.clone = function clone (repo, wdir, callback) {
    function clone () {
        exec('git clone ' + repo.clone_url, {
            cwd: wdir
        }, function onEnd (err, stdout, stderr) {
            if (err) {
                return callback(new Error('Cloning ' + repo.clone_url + ' failed!'));
            }

            callback();
        });
    }

    function onCreated (err) {
        if (err && 'EEXIST' !== err.code) {
            return callback(err);
        }

        clone();
    }

    fs.mkdir(wdir, onCreated);
};

/**
 * Pulls a given repository.
 *
 * @param  {string} wdir The git repository directory in which the repos should be cloned.
 * @param  {Function} callback error-first style.
 *
 */
exports.pull = function pull (wdir, callback) {
    exec('git pull', {
        cwd: wdir
    }, function onEnd (err, stdout, stderr) {
        if (err) {
            return callback(new Error('Pulling ' + wdir + ' failed!'));
        }

        callback();
    });
};
