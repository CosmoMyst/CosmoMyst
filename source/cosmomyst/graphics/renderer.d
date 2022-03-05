module cosmomyst.graphics.renderer;

import dath;
import cosmomyst.graphics.color;

/// Base interface for a graphics renderer. Different platforms and rendering implementations should inherit this.
public interface Renderer
{
    /// Begins the renderer. Usually involves clearing the screen and setting up the rendering process.
    void begin() @nogc nothrow;

    /// Ends the renderer. Usually involves rendering to the screen.
    void end() @nogc nothrow;

    /// Returns the current clear color.
    Color getClearColor() @nogc nothrow const;

    /// Set the clear color. Color with which the screen is cleared every frame.
    void setClearColor(Color) @nogc nothrow;

    /// Draws a filled rectangle to the screen.
    void drawFillRect(Rectf, Color color) @nogc nothrow;
}
