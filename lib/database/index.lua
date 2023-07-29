lib.database = {};
lib.database.schema = require 'lib.database.classes.Schema';
lib.database.schema_field = require 'lib.database.classes.SchemaField';

lib.database.validate_object = require 'lib.database.validate_object';
lib.database.is_ready = require 'lib.database.is_ready';
lib.database.ready = require 'lib.database.ready';

lib.database.insert = require 'lib.database.insert';
lib.database.insert_one = require 'lib.database.insert_one';
lib.database.find = require 'lib.database.find';
lib.database.find_one = require 'lib.database.find_one';
lib.database.delete = require 'lib.database.delete';
lib.database.delete_one = require 'lib.database.delete_one';
lib.database.update = require 'lib.database.update';
lib.database.update_one = require 'lib.database.update_one';
lib.database.count = require 'lib.database.count';

return lib.database;