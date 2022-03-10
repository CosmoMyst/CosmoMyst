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

    private Sprite[] loadedSprites;
    private Font[] loadedFonts;

    public this(Renderer renderer)
    {
        this.renderer = renderer;
    }

    /// Cleans up any internal asset resources. To be called when the game ends.
    public void cleanup()
    {
        foreach (f; loadedFonts) f.cleanup();
        foreach (s; loadedSprites) s.cleanup();
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
            Sprite res = new SDLSprite(IMG_LoadTexture((cast(SDLRenderer) renderer).getInternalRenderer(),
                chainPath(basePath, path).array().ptr));

            loadedSprites ~= res;

            return res;
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
            Font res = new SDLFont(font);

            loadedFonts ~= res;

            return res;
        }
    }
}
