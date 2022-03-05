/// Events system. Inspired by https://github.com/WebFreak001/EventSystem
module cosmomyst.events;

/// Event storing @nogc nothrow delegates that can be called inside the game loop
public alias GameLoopEvent(Args...) = void delegate(Args) @nogc nothrow [];

/// Calls all delegates listening on an event
public void emit(T : void delegate(Args) @nogc nothrow, Args...)(T[] events, Args args)
{
    foreach (fn; events) fn(args);
}
