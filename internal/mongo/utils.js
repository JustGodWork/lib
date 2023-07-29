const mongodb = require("mongodb");

class MongoUtils {

    exportDocument(document) {
        if (!document) return;
        if (document._id && typeof document._id !== "string") {
            document._id = document._id.toString();
        }
        return document;
    };

    exportDocuments(documents) {
        if (!Array.isArray(documents)) return;
        return documents.map((document => this.exportDocument(document)));
    };

    safeObjectArgument(object) {
        if (!object) return {};
        if (Array.isArray(object)) {
            return object.reduce((acc, value, index) => {
                acc[index] = value;
                return acc;
            }, {});
        }
        if (typeof object !== "object") return {};
        if (object._id) object._id = mongodb.ObjectID(object._id);
        return object;
    };

    safeCallback(cb, ...args) {
        if (typeof cb === "function") return setImmediate(() => cb(...args));
        else return false;
    };

};

module.exports = new MongoUtils();