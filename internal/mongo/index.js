const mongodb = require("mongodb");
const mongoutils = require("./utils");

const mongodb_url = GetConvar("justgod_lib_database_url", "N/A");
const dbName = GetConvar("justgod_lib_database_name", "N/A");

let db;

/**
 * Send error to server console
 * @param {string} err
 */
function send_error(err) {
    console.log(`^7(^1ERROR^7) =>^0 ${err}^0`);
};

if (mongodb_url != "N/A" && dbName != "N/A") {
    mongodb.MongoClient.connect(mongodb_url, { useNewUrlParser: true, useUnifiedTopology: true }, function (err, client) {
        if (err) return send_error(`^7(^6Database^7)^0 => Failed to connect: ${err.message}^0`);
        db = client.db(dbName);

        console.log(`^7(^2SUCCESS^7) =>^0 ^7(^6Database^7)^0 => Database is ready.^0`);
        emit("lib.database.connected");
    });
};

function checkDatabaseReady() {
    if (!db) {
        send_error(`^7(^6Database^7)^0 => Database is not connected.^0`);
        return false;
    }
    return true;
};

function checkParams(params) {
    return params !== null && typeof params === 'object';
};

function getParamsCollection(params) {
    if (!params.collection) return;
    return db.collection(params.collection)
};

/* MongoDB methods wrappers */

/**
 * MongoDB insert method
 * @param {Object} params - Params object
 * @param {Array}  params.documents - An array of documents to insert.
 * @param {Object} params.options - Options passed to insert.
 */
function dbInsert(params, callback) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return send_error(`^7(^6Database^7)^0 => Mongo.insert: Invalid params object.^0`);

    let collection = getParamsCollection(params);
    if (!collection) return send_error(`^7(^6Database^7)^0 => Mongo.insert: Invalid collection "${params.collection}"^0`);

    let documents = params.documents;
    if (!documents || !Array.isArray(documents))
        return send_error(`^7(^6Database^7)^0 => Mongo.insert: Invalid 'params.documents' value. Expected object or array of objects.^0`);

    const options = mongoutils.safeObjectArgument(params.options);

    collection.insertMany(documents, options, (err, result) => {
        if (err) {
            send_error(`^7(^6Database^7)^0 => Mongo.insert: Error "${err.message}".^0`);
            mongoutils.safeCallback(callback, false, err.message);
            return;
        }
        let arrayOfIds = [];
        // Convert object to an array
        for (let key in result.insertedIds) {
            if (result.insertedIds.hasOwnProperty(key)) {
                arrayOfIds[parseInt(key)] = result.insertedIds[key].toString();
            }
        }
        mongoutils.safeCallback(callback, true, result.insertedCount, arrayOfIds);
    });
    process._tickCallback();
};

/**
 * MongoDB find method
 * @param {Object} params - Params object
 * @param {Object} params.query - Query object.
 * @param {Object} params.options - Options passed to insert.
 * @param {number} params.limit - Limit documents count.
 */
function dbFind(params, callback) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return send_error(`^7(^6Database^7)^0 => Mongo.find: Invalid params object.^0`);

    let collection = getParamsCollection(params);
    if (!collection) return send_error(`^7(^6Database^7)^0 => Mongo.insert: Invalid collection "${params.collection}"^0`);

    const query = mongoutils.safeObjectArgument(params.query);
    const options = mongoutils.safeObjectArgument(params.options);

    let cursor = collection.find(query, options);
    if (params.limit) cursor = cursor.limit(params.limit);
    cursor.toArray((err, documents) => {
        if (err) {
            send_error(`^7(^6Database^7)^0 => Mongo.find: Error "${err.message}".^0`);
            mongoutils.safeCallback(callback, false, err.message);
            return;
        };
        mongoutils.safeCallback(callback, true, mongoutils.exportDocuments(documents));
    });
    process._tickCallback();
};

/**
 * MongoDB update method
 * @param {Object} params - Params object
 * @param {Object} params.query - Filter query object.
 * @param {Object} params.update - Update query object.
 * @param {Object} params.options - Options passed to insert.
 */
function dbUpdate(params, callback, isUpdateOne) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return send_error(`^7(^6Database^7)^0 => Mongo.update: Invalid params object.^0`);

    let collection = getParamsCollection(params);
    if (!collection) return send_error(`^7(^6Database^7)^0 => Mongo.insert: Invalid collection "${params.collection}"^0`);

    query = mongoutils.safeObjectArgument(params.query);
    update = mongoutils.safeObjectArgument(params.update);
    options = mongoutils.safeObjectArgument(params.options);

    const cb = (err, res) => {
        if (err) {
            send_error(`^7(^6Database^7)^0 => Mongo.update: Error "${err.message}".^0`);
            mongoutils.safeCallback(callback, false, err.message);
            return;
        }
        mongoutils.safeCallback(callback, true, res.result.nModified);
    };
    isUpdateOne ? collection.updateOne(query, update, options, cb) : collection.updateMany(query, update, options, cb);
    process._tickCallback();
};

/**
 * MongoDB count method
 * @param {Object} params - Params object
 * @param {Object} params.query - Query object.
 * @param {Object} params.options - Options passed to insert.
 */
function dbCount(params, callback) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return send_error(`^7(^6Database^7)^0 => Mongo.count: Invalid params object.^0`);

    let collection = getParamsCollection(params);
    if (!collection) return send_error(`^7(^6Database^7)^0 => Mongo.insert: Invalid collection "${params.collection}"^0`);

    const query = mongoutils.safeObjectArgument(params.query);
    const options = mongoutils.safeObjectArgument(params.options);

    collection.countDocuments(query, options, (err, count) => {
        if (err) {
            send_error(`^7(^6Database^7)^0 => Mongo.count: Error "${err.message}".^0`);
            mongoutils.safeCallback(callback, false, err.message);
            return;
        }
        mongoutils.safeCallback(callback, true, count);
    });
    process._tickCallback();
};

/**
 * MongoDB delete method
 * @param {Object} params - Params object
 * @param {Object} params.query - Query object.
 * @param {Object} params.options - Options passed to insert.
 */
function dbDelete(params, callback, isDeleteOne) {
    if (!checkDatabaseReady()) return;
    if (!checkParams(params)) return send_error(`^7(^6Database^7)^0 => Mongo.delete: Invalid params object.^0`);

    let collection = getParamsCollection(params);
    if (!collection) return send_error(`^7(^6Database^7)^0 => Mongo.insert: Invalid collection "${params.collection}"^0`);

    const query = mongoutils.safeObjectArgument(params.query);
    const options = mongoutils.safeObjectArgument(params.options);

    const cb = (err, res) => {
        if (err) {
            send_error(`^7(^6Database^7)^0 => Mongo.delete: Error "${err.message}".^0`);
            mongoutils.safeCallback(callback, false, err.message);
            return;
        }
        mongoutils.safeCallback(callback, true, res.result.n);
    };
    isDeleteOne ? collection.deleteOne(query, options, cb) : collection.deleteMany(query, options, cb);
    process._tickCallback();
};

function isConnected() {
    return !!db;
};

module.exports = {
    insert: dbInsert,
    isConnected: isConnected,
    checkParams: checkParams,
    find: dbFind,
    update: dbUpdate,
    count: dbCount,
    delete: dbDelete
};
