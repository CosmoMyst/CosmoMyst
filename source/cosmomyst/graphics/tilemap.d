module cosmomyst.graphics.tilemap;

import dath;
import cosmomyst.graphics.sprite;

/// Holds information about a tilemap, and convenience functions.
public class Tilemap
{
    private const Sprite sprite;
    private uint cellSize;
    private uint cols;
    private uint rows;

    public this(Sprite sprite, uint cellSize)
    {
        this.sprite = sprite;
        this.cellSize = cellSize;

        cols = cast(uint) sprite.getSize().x / cellSize;
        rows = cast(uint) sprite.getSize().y / cellSize;
    }

    public const(Sprite) getSprite() @nogc nothrow const
    {
        return sprite;
    }

    /// Returns the number of tiles the tilemap contains
    public uint getNumberOfTiles() @nogc nothrow const
    {
        return cols * rows;
    }

    /// Returns a rect from the source sprite
    /// The rect represents the position and size of the tile with the specified id
    public Rectf getTileRect(uint index) @nogc nothrow const
    {
        import std.math : floor;

        return Rectf(cellSize * (index % cols), cellSize * floor(cast(float) index / cols), cellSize, cellSize);
    }
}
