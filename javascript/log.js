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

const LOG_VERBOSE = 5;
const LOG_DEBUG   = 4;
const LOG_INFO    = 3;
const LOG_WARN    = 2;
const LOG_ERROR   = 1;
const LOG_NO_LOG  = 0;
let LOG_CUR_LEVEL = LOG_VERBOSE;

const logv = (...args) => LOG_CUR_LEVEL >= LOG_VERBOSE && console.log.apply  (null, ["V|" + new Date().toISOString(), ...args]);
const logd = (...args) => LOG_CUR_LEVEL >= LOG_DEBUG   && console.log.apply  (null, ["D|" + new Date().toISOString(), ...args]);
const logi = (...args) => LOG_CUR_LEVEL >= LOG_INFO    && console.info.apply (null, ["I|" + new Date().toISOString(), ...args]);
const logw = (...args) => LOG_CUR_LEVEL >= LOG_WARN    && console.warn.apply (null, ["W|" + new Date().toISOString(), ...args]);
const loge = (...args) => LOG_CUR_LEVEL >= LOG_ERROR   && console.error.apply(null, ["E|" + new Date().toISOString(), ...args]);

/************************************* END **************************************/
