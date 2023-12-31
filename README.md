# lib
Library created to make my scripts faster.

This library is a better way for me to make scripts.
It's not just 'another JustGod lib' it's an updated and reworked system regrouping all my previous utility projects.

You can use it if you want but no support will be provided.

# Getting started

Before starting your server, make sure you have the webpack and yarn resources. (UP TO DATE !)

In your fxmanifest.lua:
```shared_script '@lib/imports.lua'```

Moove or copy the convars.cfg file to the root of your server where resources folder is located.

In your server.cfg:
```
exec convars.cfg
ensure lib
```

# Utilities example

## Callbacks

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

## Commands

``` lua

local command = lib.discord.slash_command('testcommand', 'This is my first lua command!', function(notify, userId, arguments)
  notify('This is my first lua command!');
  console.log(arguments);
end, 'SOME_ROLE_ID OR NOTHING')
  :AddBooleanOption('test_boolean', 'This is my first boolean option', true)
  :AddStringOption('test_string', 'This is my first string option', true, {
    {
      name = "Hello",
      value = "Hello you !"
    },
    {
      name = "Hi",
      value = "Hi!"
    }
  })
  :AddNumberOption('test_number', 'This is my first number option', true);

```

Feel free to send pull request or issues to help me in my work :)


Documentation can be found here: [Visit the documentation](https://github.com/JustGodWork/lib/wiki)
