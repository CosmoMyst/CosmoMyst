module cosmomyst.graphics.impl.sdl.sdl_renderer;

version(SDL):

import bindbc.sdl;
import dath;
import cosmomyst.graphics.sprite;
import cosmomyst.graphics.renderer;
import cosmomyst.graphics.color;
import cosmomyst.graphics.impl.sdl;

private struct DrawCall
{
    public uint sortOrder;
}

public class SDLRenderer : Renderer
{
    private SDL_Renderer* renderer;
    private Color clearColor = Colors.black;

    private DrawCall[] drawCalls;

    private SDL_Texture* rectTex;

    /++
     + Params:
     +   maxDrawCalls = Specifies the max amount of draw calls that can be executed per frame.
     +/
    public this(SDLWindow window, uint maxDrawCalls = 2000)
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

        drawCalls.length = maxDrawCalls;

        // create a texture used for drawing rectangles
        rectTex = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_TARGET, 1, 1);

        SDL_SetRenderTarget(renderer, rectTex);
        setSDLDrawColor(Colors.white);
        SDL_RenderClear(renderer);
        SDL_SetRenderTarget(renderer, null);
        setSDLDrawColor(clearColor);

        SDL_SetTextureBlendMode(rectTex, SDL_BLENDMODE_BLEND);
    }

    public ~this()
    {
        SDL_DestroyTexture(rectTex);
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

    public SDL_Renderer* getInternalRenderer() @nogc nothrow
    {
        return renderer;
    }

    public void drawFillRect(Rectf rect, Color color) @nogc nothrow
    {
        SDL_Rect source = { 0, 0, 1, 1 };
        SDL_Rect dest = { cast(int) rect.x, cast(int) rect.y, cast(int) rect.w, cast(int) rect.h };

        SDL_SetTextureColorMod(rectTex, color.r, color.g, color.b);
        SDL_SetTextureAlphaMod(rectTex, color.a);

        SDL_RenderCopy(renderer, rectTex, &source, &dest);

        SDL_SetTextureColorMod(rectTex, Colors.white.r, Colors.white.g, Colors.white.b);
        SDL_SetTextureAlphaMod(rectTex, 255);
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
