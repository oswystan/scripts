(function(){
    const logd = (...args)=>console.log(  "D|"+new Date().toISOString(), ...args);
    const logi = (...args)=>console.info( "I|"+new Date().toISOString(), ...args);
    const logw = (...args)=>console.warn( "W|"+new Date().toISOString(), ...args);
    const loge = (...args)=>console.error("E|"+new Date().toISOString(), ...args);

    class RetryTimer {
        constructor() {
            this.reset();
        }

        connectMS() {
            return this.connectTimeoutMS;
        }
        retryMS() {
            let ret = this.retryTimeoutMS;
            this.retryTimeoutMS += this.randomMS();
            if (this.retryTimeoutMS >= this.maxRetryTimeoutMS) {
                this.retryTimeoutMS = this.maxRetryTimeoutMS;
            }
            return ret;
        }
        randomMS() {
            return Math.ceil(Math.random()*1000) + this.incrementMS;
        }
        reset() {
            this.connectTimeoutMS  = 5000;
            this.retryTimeoutMS    = this.randomMS();
            this.maxRetryTimeoutMS = 10000;
            this.incrementMS       = 1000;
        }
    };

    class StableWebSocket {
        constructor() {
            this.url            = null;
            this.onmessage      = null;
            this.onopen         = null;
            this.onclose        = null;
            this.ws             = null;
            this.connectTimerID = 0;
            this.retryTimerID   = 0;
            this.timer          = new RetryTimer();
            this.lastConnectTS  = 0;
        }
        send(data) {
            if (this.ws) {
                this.ws.send(data);
            }
        }
        close() {
            logi("closing socket");
            if (this.ws) {
                this.ws.onclose = null;
                this.ws.close();
            }
            if (this.connectTimerID > 0) {
                clearTimeout(this.connectTimerID);
                this.connectTimerID = 0;
            }
            if (this.retryTimerID > 0) {
                clearTimeout(this.retryTimerID);
                this.retryTimerID = 0;
            }
        }
        connect(url) {
            logi('connecting:', url);
            this.url = url;
            this.timer.reset();

            // incase of connect the wrong url: connect will be success, but server will
            // disconnect socket immediately after that.
            if (Date.now() - this.lastConnectTS > this.timer.retryTimeoutMS) {
                logd('direct connect');
                this._connectWebSocket();
            } else {
                logd('random connect');
                this.connectTimerID = setTimeout(this._connectWebSocket.bind(this), this.timer.randomMS());
            }
        }

        _connectWebSocket() {
            try {
                this.lastConnectTS = Date.now();
                let ws     = new WebSocket(url);
                ws.onopen  = this._onopen.bind(this);
                ws.onclose = this._onclose.bind(this);
                ws.onerror = this._onerror.bind(this);
                this.ws    = ws;
                this.connectTimerID = setTimeout(()=>{
                    loge("connect", url, "timeout!");
                    ws.close();
                }, this.timer.connectMS());
            } catch (e) {
                loge("ERROR:", e);
                this.ws = null;
                this._retry();
            }
        }

        _retry() {
            let con = this;
            let ms = con.timer.retryMS();
            logd("retry after", ms, "ms");
            con.retryTimerID = setTimeout(()=>{
                con._connectWebSocket();
            }, ms);
        }
        _onopen() {
            this.timer.reset();
            clearTimeout(this.connectTimerID);
            let ws       = this.ws;
            ws.onclose   = this.onclose;
            ws.onmessage = this.onmessage;
            if (this.onopen) {
                this.onopen();
            }
        }
        _onclose(e) {
            logw("socket closed", e.code);
            this.ws = null;
            clearTimeout(this.connectTimerID);
            this._retry();
        }
        _onerror(e) {
            loge("socket error:", e.type);
            this.ws.close();
        }
    };

    class PingService {
        constructor(intervalMS, timeoutHits) {
            this.pingTimer     = 0;
            this.interval      = intervalMS;
            this.timeoutHits   = timeoutHits;
            this.pingHits      = 0;
            this.con           = null;
        }

        start(con, callback) {
            this.con = con;
            this.timeoutCallback = callback;
            this.pingHits = 0;
            this._ping();
        }
        stop() {
            logi("=> stop ping");
            if (this.pingTimer > 0) {
                clearTimeout(this.pingTimer);
            }
            this.pingTimer = 0;
            this.con = null;
        }
        pong() {
            this.pingHits = 0;
        }
        _ping() {
            if (!this.con) {
                return;
            }

            if (this.pingHits >= this.timeoutHits) {
                if (this.timeoutCallback) {
                    logw("ping time out");
                    this.timeoutCallback();
                }
                this.pingTimer = 0;
            } else {
                this.con.send("PING");
                this.pingTimer = setTimeout(this._ping.bind(this), this.interval);
                this.pingHits++;
            }
        }
    };

    class App {
        constructor(url) {
            this.con  = null;
            this.ping = null;
            this.url  = url;
            this.id   = 0;
            this.conf = 0;
            this.lstream = [];
            this.rstream = [];
            this.startCallback = null;
        }
        start(callback) {
            logi("===> app start");
            this.con = new StableWebSocket();
            this.ping = new PingService(2000, 3);
            this.con.onopen = this._onopen.bind(this);
            this.con.onclose = this._onclose.bind(this);
            this.con.onmessage = this._onmessage.bind(this);
            this.con.connect(this.url);
            this.startCallback = callback;
        }
        stop() {
            logi("===> app stop");
            this.ping.stop();
            this.con.close();
            this.ping = null;
            this.con = null;
        }

        init() {
            logi("===> app init");
            this.id = Math.ceil(Math.random()*1000);
        }
        join() {
            logi("===> app join");
            this.conf = Math.ceil(Math.random()*1000);
        }
        publish(sid) {
            logi("===> app publish");
            this.lstream.push(sid);
        }
        subscribe(sid) {
            logi("===> app subscribe");
            this.rstream.push(sid);
        }
        unpublish(sid) {
            logi("===> app unpublish");
            let idx = this.lstream.indexOf(sid);
            if (idx >= 0) {
                this.lstream.splice(idx, 1);
            }
        }
        unsubscribe(sid) {
            logi("===> app unsubscribe");
            let idx = this.lstream.indexOf(sid);
            if (idx >= 0) {
                this.rstream.splice(idx, 1);
            }
        }
        leave() {
            logi("===> app leave");
            this.conf = 0;
        }
        close() {
            logi("===> app close");
            this.id = 0;
        }

        _onopen() {
            logi("===> server connected");
            this.ping.start(this.con, this._pingTimeout.bind(this));
            if (this.id != 0) {
                logd("need to init");
            }
            if (this.conf != 0) {
                logd("need to join");
            }
            if (this.lstream.length != 0) {
                logd("need to publish:", ...this.lstream);
            }
            if(this.rstream.length != 0) {
                logd("need to subscribe:", ...this.rstream);
            }
            if (this.startCallback) {
                this.startCallback();
                this.startCallback = null;
            }
        }
        _onclose(e) {
            logw("===> server disconnected");
            this.ping.stop();
            this.con.connect(this.url);
        }
        _onmessage(msg) {
            logd("got", msg.data);
            this.ping.pong();
        }
        _pingTimeout() {
            this.ping.stop();
            this.con.close();
            this.con.connect(this.url);
        }
    };

    // let url = "ws://10.2.20.98:8090/app/v1.0.0";
    let url = "ws://10.2.20.98:8090/app/v1.0.0";
    let app = new App(url);
    app.start(function(){
        app.init();
        app.join();
        app.publish(1);
        app.subscribe(20);
    });

    setTimeout(app.stop.bind(app), 60000);
})();
