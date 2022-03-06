module cosmomyst.graphics.impl.sdl.sdl_renderer;

version(SDL):

import bindbc.sdl;
import dath;
import cosmomyst.graphics.sprite;
import cosmomyst.graphics.renderer;
import cosmomyst.graphics.color;
import cosmomyst.graphics.impl.sdl;

public class SDLRenderer : Renderer
{
    private SDL_Renderer* renderer;
    private Color clearColor = Colors.black;

    public this(SDLWindow window)
    {
        import core.stdc.stdlib : exit;
        import std.stdio : writeln;

        renderer = SDL_CreateRenderer(window.getInternalWindow(), -1, SDL_RENDERER_ACCELERATED);

        if (renderer is null)
        {
            writeln("Failed to create the SDL renderer. Error: ", SDL_GetError());
            exit(1);
        }

        SDL_SetRenderDrawBlendMode(renderer, SDL_BLENDMODE_BLEND);
    }

    public ~this()
    {
        SDL_DestroyRenderer(renderer);
    }

    public void begin() @nogc nothrow
    {
        SDL_RenderClear(renderer);

        setSDLDrawColor(clearColor);
    }

    public void end() @nogc nothrow
    {
        SDL_RenderPresent(renderer);
    }

    public Color getClearColor() @nogc nothrow const
    {
        return clearColor;
    }

    public void setClearColor(Color c) @nogc nothrow
    {
        clearColor = c;
    }

    public Rectf getViewport() @nogc nothrow
    {
        SDL_Rect rect;
        SDL_RenderGetViewport(renderer, &rect);

        return Rectf(rect.x, rect.y, rect.w, rect.h);
    }
    
    public void drawFillRect(Rectf rect, Color color) @nogc nothrow
    {
        setSDLDrawColor(color);       

        const sdlRect = toSDLRect(rect);
        SDL_RenderFillRect(renderer, &sdlRect);

        setSDLDrawColor(clearColor);
    }

    public SDL_Renderer* getInternalRenderer() @nogc nothrow
    {
        return renderer;
    }

    public void drawSprite(Sprite sprite, Rectf source, Rectf dest) @nogc nothrow
    {
        SDL_Texture* tex = (cast(SDLSprite) sprite).getInternalTexture();

        SDL_Rect sdlSource = { cast(int) source.x, cast(int) source.y, cast(int) source.w, cast(int) source.h };
        SDL_Rect sdlDest = { cast(int) dest.x, cast(int) dest.y, cast(int) dest.w, cast(int) dest.h };

        SDL_RenderCopy(renderer, tex, &sdlSource, &sdlDest);
    }

    private void setSDLDrawColor(Color c) @nogc nothrow
    {
        SDL_SetRenderDrawColor(renderer, c.r, c.g, c.b, c.a);
    }
}
