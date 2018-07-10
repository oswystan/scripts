/*
 *********************************************************************************
 *                     Copyright (C) 2018 wystan
 *
 *       filename: util.js
 *    description:
 *        created: 2018-05-25 16:53:42
 *         author: wystan
 *
 *********************************************************************************
 */

function make_rand_id(len = 10) {
    let text = "";
    let candidates = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_";

    for (var i = 0; i < len; i++)
        text += candidates.charAt(Math.floor(Math.random() * candidates.length));

    return text;
}

function random_u32() {
	return Math.floor(Math.random()*4294967296);
}

function random_u16() {
	return Math.floor(Math.random()*65536);
}

function clone_object(src) {
    if (typeof src !== "object") {
        return src;
    } else if (Array.isArray(src)) {
        return Array.from(src);
    }
    let ret = Object.create(null);

    for (let attr in src) {
        ret[attr] = clone_object(src[attr]);
    }
    return ret;
}


/************************************* END **************************************/
