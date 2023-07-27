# lib
Library created to make my scripts faster.

This library is a better way for me to make scripts.
It's not just 'another JustGod lib' it's an updated and reworked system regrouping all my previous utility projects.

You can use it if you want but no support will be provided.

# Getting started

Before starting your server
```cd resource/lib```
```npm i```

In your fxmanifest.lua:
```shared_script '@lib/imports.lua'```
In your server.cfg:
```
exec convars.cfg
ensure lib
```

# Utilities example
``` lua

--SERVER
lib.events.on.callback('my_event_name', function(source, response, ...)
  console.log( source .. ' is sending event callback with args', ...);
  response('Server succefully received event callback');
end);

--CLIENT
lib.events.emit.callback('my_event_name', function(server_message)
  print('Server response is ' .. server_message);
end, 'arg', 'arg1', 'arg2', 1, 2, 3, 4, { "array?", "table?", "lua is good" });

```

Documentation can be found here: [Visit the documentation](https://github.com/JustGodWork/lib/wiki)
