module cosmomyst.input.input;

import dath;

/// Base input interface. This should be implemented for every platform/system.
public interface Input
{
    /// Begin the input. 
    void begin() @nogc nothrow;

    /// End the input.
    void end() @nogc nothrow;

    /// Get the mouse position.
    Vec2 mousePos() @nogc nothrow const;

    /// Has the keyboard key just been pressed?
    bool isKeyPressed(Key) @nogc nothrow const;

    /// Has the keyboard key just been released?
    bool isKeyReleased(Key) @nogc nothrow const;

    /// Is the keyboard key being held?
    bool isKeyHeld(Key) @nogc nothrow const;

    /// Has the mouse button just been pressed?
    bool isMouseButtonPressed(MouseButton) @nogc nothrow const;

    /// Has the mouse button just been released?
    bool isMouseButtonReleased(MouseButton) @nogc nothrow const;

    /// Is the mouse button being held?
    bool isMouseButtonHeld(MouseButton) @nogc nothrow const;
}

/// Mouse buttons
public enum MouseButton
{
    left,
    middle,
    right
}

/// Keyboard keys
public enum Key
{
    w,
    s,
    a,
    d,
    p,
    x,
    c,
    escape,
    space,
    lctrl
}
