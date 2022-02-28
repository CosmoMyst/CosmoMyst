module cosmomyst.graphics.window;

/// Base interface for an operating system window. Different platforms and rendering implementations should inherit this.
public interface Window
{
    /// Is the window open?
    bool isOpen() @nogc nothrow const;

    /// Sets whether the cursor is visible or not.
    void setCursorVisibility(bool) @nogc nothrow const;

    /// Polls the window events, this makes sure that input, resizing and other events get registered.
    void pollEvents() @nogc nothrow;

    /// Sets the window size.
    void setSize(uint w, uint h) @nogc nothrow;

    /// Returns the amount of milliseconds passed since the start.
    ulong getElapsedMilliseconds() @nogc nothrow const;

    /// Returns the high resolution counter, usually in micro or nano seconds, depends on the system.
    /// This information is only useful with `getHighResFrequency`.
    ulong getHighResCounter() @nogc nothrow const;

    /// Returns the system-specific frequency of the high resolution counter.
    ulong getHighResFrequency() @nogc nothrow const;
}
