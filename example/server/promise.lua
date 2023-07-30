RegisterCommand('promise', function()
    lib.promise:Try(function()
        unknownFunction();
        return (5)
    end):Then(function(result)
        console.success(('<unknownFunction> is defined and I receive as a result %d !'):format(result));
    end):Catch(function(error)
        console.err(('Unable to execute because : %s'):format(error));
    end)
end)