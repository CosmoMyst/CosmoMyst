module cosmomyst.graphics.sprite;

import dath;

/// Sprite object for rendering. Different platforms should implement their own sprite.
public abstract class Sprite
{
    /// Gets the sprite size.
    abstract Vec2 getSize() @nogc nothrow;

    /// Cleans up any internal resources. To be called when the game ends.
    abstract void cleanup();
}
