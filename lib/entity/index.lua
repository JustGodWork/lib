lib.entity = {};
lib.entity.classes = {};
lib.entity.players = {};

lib.entity.request_model = require 'lib.entity.request_model';
lib.entity.release_model = require 'lib.entity.release_model';
lib.entity.is_model_loaded = require 'lib.entity.is_model_loaded';
lib.entity.freeze_position = require 'lib.entity.freeze_position';
lib.entity.get_coords = require 'lib.entity.get_coords';
lib.entity.set_coords = require 'lib.entity.set_coords';
lib.entity.does_exist = require 'lib.entity.does_exist';

lib.entity.classes.entity = require 'lib.entity.classes.entity';
lib.entity.classes.ped = require 'lib.entity.classes.ped.ped';
lib.entity.classes.player_ped = require 'lib.entity.classes.ped.player_ped';
lib.entity.classes.net_player = require 'lib.entity.classes.player.net';
lib.entity.classes.local_player = require 'lib.entity.classes.player.local';

return lib.entity;