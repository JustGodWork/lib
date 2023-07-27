class Logger {

    constructor() {
        this._debug = GetConvar('justgod_lib_debug', 'false') === 'true' ? true : false;
    };

    info(...args) {
        console.log(`^7(^5INFO^7) =>^0 ^7(^6DISCORD^7)^0 =>  ${args}^0`);
    };

    success(...args) {
        console.log(`^7(^2SUCCESS^7) =>^0 ^7(^6DISCORD^7)^0 => ${args}^0`);
    };

    error(...args) {
        console.log(`^7(^1ERROR^7) =>^0 ^7(^6DISCORD^7)^0 => ${args}^0`);
    };

    warn(...args) {
        console.log(`^7(^3WARN^7) =>^0 ^7(^6DISCORD^7)^0 => ${args}^0`);
    };

    debug(...args) {
        if (this._debug) console.log(`^7(^4DEBUG^7) =>^0 ^7(^6DISCORD^7)^0 => ${args}^0`);
    };

};

module.exports = new Logger();