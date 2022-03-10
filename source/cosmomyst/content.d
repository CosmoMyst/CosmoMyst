module cosmomyst.content;

import std.path;
import std.array;
import dath;
import cosmomyst.graphics;

/// Content manager for loading sprites, audio, etc.
public class ContentManager
{
    private Renderer renderer;

    private string basePath = "";

    public this(Renderer renderer)
    {
        this.renderer = renderer;
    }

    /// sets the base content path
    public void setBasePath(string path)
    {
        basePath = path;
    }

    /// Loads a sprite from disk. Doesn't cache.
    public Sprite loadSprite(string path)
    {
        version(SDL)
        {
            import bindbc.sdl;
            import cosmomyst.graphics.impl.sdl;

            // TODO: error checking
            return new SDLSprite(IMG_LoadTexture((cast(SDLRenderer) renderer).getInternalRenderer(),
                chainPath(basePath, path).array().ptr));
        }
    }

    /// Loads a font form disk. Doesn't cache.
    public Font loadFont(string path, uint psize)
    {
        version(SDL)
        {
            import bindbc.sdl;
            import cosmomyst.graphics.impl.sdl;

            // TODO: error checking
            TTF_Font* font = TTF_OpenFont(chainPath(basePath, path).array().ptr, psize);

            return new SDLFont(font);
        }
    }
}
