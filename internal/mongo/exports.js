const mongo = require('./internal/mongo/index');
const utils = require('./internal/mongo/utils');

exports("mongo_is_connected", mongo.isConnected);

exports("mongo_insert", mongo.insert);
exports("mongo_insert_one", (params, callback) => {
    if (mongo.checkParams(params)) {
        params.documents = [params.document];
        params.document = null;
    };
    return mongo.insert(params, callback);
});

exports("mongo_find", mongo.find);
exports("mongo_find_one", (params, callback) => {
    if (mongo.checkParams(params)) params.limit = 1;
    return mongo.find(params, (success, arguments) => {
        utils.safeCallback(callback, success, typeof arguments === 'object' ? arguments[0] : arguments);
    });
});

exports("mongo_update", mongo.update);
exports("mongo_update_one", (params, callback) => {
    return mongo.update(params, callback, true);
});

exports("mongo_count", mongo.count);

exports("mongo_delete", mongo.delete);
exports("mongo_delete_one", (params, callback) => {
    return mongo.delete(params, callback, true);
});