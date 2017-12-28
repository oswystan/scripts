/*
 *********************************************************************************
 *                     Copyright (C) 2017 wystan
 *
 *       filename: log.js
 *    description:
 *        created: 2017-12-28 10:46:42
 *         author: wystan
 *
 *********************************************************************************
 */

let ts = function() {
    let parts = new Date().toISOString().split("T");
    return parts[0] + " " + parts[1].split("Z")[0];
};

const LOG_VERBOSE = 5;
const LOG_DEBUG   = 4;
const LOG_INFO    = 3;
const LOG_WARN    = 2;
const LOG_ERROR   = 1;
const LOG_NO_LOG  = 0;
let LOG_CUR_LEVEL = LOG_VERBOSE;

const logv = (...args) => LOG_CUR_LEVEL >= LOG_VERBOSE && console.log.apply  (null, [ts() + "[V]", ...args]);
const logd = (...args) => LOG_CUR_LEVEL >= LOG_DEBUG   && console.log.apply  (null, [ts() + "[D]", ...args]);
const logi = (...args) => LOG_CUR_LEVEL >= LOG_INFO    && console.info.apply (null, [ts() + "[I]", ...args]);
const logw = (...args) => LOG_CUR_LEVEL >= LOG_WARN    && console.warn.apply (null, [ts() + "[W]", ...args]);
const loge = (...args) => LOG_CUR_LEVEL >= LOG_ERROR   && console.error.apply(null, [ts() + "[E]", ...args]);

/************************************* END **************************************/
