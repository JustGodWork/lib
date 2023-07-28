require('./internal/discord/modules/client');
require('./internal/discord/events');
require('./internal/discord/modules/message_handler');

// const test = require('./internal/discord/modules/command/command_handler');

// test.register('test1', 'Replies with pong!', async (notify) => {
//     notify({
//         content: 'Pong!',
//         ephemeral: true
//     });
// });

// test.addBooleanOption('test1', 'test', 'test', true);

// test.update('1097877016222646403', 'test1');

// test.register('test2', 'Replies with pong2!', async (notify, userId, data) => {
//     notify({
//         content: 'Pong!',
//         ephemeral: true
//     });
//     console.log(data, userId)
// }, '1115714785581990059');

// test.addStringOption('test2', 'test_', 'test_', null, true);
// test.addNumberOption('test2', 'test', 'test', null, true);

// test.update('1097877016222646403', 'test2');
