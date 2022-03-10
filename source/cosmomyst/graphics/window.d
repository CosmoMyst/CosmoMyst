module cosmomyst.graphics.window;

import dath;
import cosmomyst.events;

/// Base interface for an operating system window. Different platforms and rendering implementations should inherit this.
public abstract class Window
{
    /// Event that's fired when the window is resized
    public GameLoopEvent!Vec2u onResize;

    /// Event that's fired when the mouse focus on the window changes
    public GameLoopEvent!bool onMouseFocusChange;

    /// Event that's fired when the keyboard focus on the window changes
    public GameLoopEvent!bool onKeyboardFocusChange;

    /// Event that's fired when the minimized state of the window changes
    public GameLoopEvent!bool onMinimizedChange;

    /// Event that's fired when the maximized state of the window changes
    public GameLoopEvent!bool onMaximizedChange;

    /// Is the window open?
    abstract bool isOpen() @nogc nothrow const;

    /// Tells the window it should close, won't be done immediately in most cases.
    abstract void close() @nogc nothrow;

    /// Get the window title.
    abstract string getTitle() @nogc nothrow const;

    /// Sets the window title.
    abstract void setTitle(string) @nogc nothrow;

    /// Sets whether the cursor is visible or not.
    abstract void setCursorVisibility(bool) @nogc nothrow const;

    /// Polls the window events, this makes sure that input, resizing and other events get registered.
    abstract void pollEvents() @nogc nothrow;

    /// Returns the window size. Only if in windowed mode. Use getFullscreenSize() in fullscren mode.
    abstract Vec2u getWindowedSize() @nogc nothrow;

    /// Sets the window size. Only if in windowed mode. Use setFullscreenSize() in fullscreen mode.
    abstract void setWindowedSize(uint w, uint h) @nogc nothrow;

    /// Returns the amount of milliseconds passed since the start.
    abstract ulong getElapsedMilliseconds() @nogc nothrow const;

    /// Returns the high resolution counter, usually in micro or nano seconds, depends on the system.
    /// This information is only useful with `getHighResFrequency`.
    abstract ulong getHighResCounter() @nogc nothrow const;

    /// Returns the system-specific frequency of the high resolution counter.
    abstract ulong getHighResFrequency() @nogc nothrow const;

    /// Sets the resizable state of the window. You can't change the resizable state of a fullscreen window.
    abstract void setResizable(bool) @nogc nothrow;

    /// Does the window have mouse focus?
    abstract bool hasMouseFocus() @nogc nothrow const;

    /// Does the window have keyboard focus?
    abstract bool hasKeyboardFocus() @nogc nothrow const;

    /// Is the window minimized?
    abstract bool isMinimized() @nogc nothrow const;

    /// Is the window maximized?
    abstract bool isMaximized() @nogc nothrow const;

    /// Set the window mode. Returns true on success.
    abstract bool setMode(WindowMode) @nogc nothrow;

    /// Get the window mode.
    abstract WindowMode getMode() @nogc nothrow const;

    /// Cleans up any internal resources. To be called when the game ends.
    abstract void cleanup();
}

public enum WindowMode
{
    fullscreen,
    fullscreenBorderless,
    windowed
}
