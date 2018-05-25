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


/************************************* END **************************************/
