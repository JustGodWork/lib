lib.game = {};
lib.game.classes = {};

lib.game.hash = require 'lib.game.hash';
lib.game.input = require 'lib.game.input';
lib.game.notification = require 'lib.game.notification';
lib.game.crash = require 'lib.game.crash';
lib.game.loaded = require 'lib.game.loaded';
lib.game.classes.zone = require 'lib.game.classes.Zone';
lib.game.classes.marker = require 'lib.game.classes.Marker';
lib.game.classes.marker_circle = require 'lib.game.classes.MarkerCircle';

return lib.game;