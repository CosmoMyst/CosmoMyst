module cosmomyst.graphics.impl.sdl.sdl_window;

version(SDL):

import bindbc.sdl;
import dath;
import cosmomyst.graphics.window;
import cosmomyst.graphics.impl.sdl.sdl_util;

public class SDLWindow : Window
{
    private SDL_Window* window;
    private SDL_Event event;

    private uint width;
    private uint height;

    private bool open;

    private void function(Vec2u size) @nogc nothrow onResizeEvent;

    public this(string title, uint width, uint height)
    {
        import core.stdc.stdlib : exit;
        import std.stdio : writeln;

        this.width = width;
        this.height = height;

        loadSDLInternal();
        loadSDLImageInternal();

        window = SDL_CreateWindow(
            title.ptr,
            SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
            width, height,
            0);

        if (window is null)
        {
            writeln("Failed to create the SDL window. Error: ", SDL_GetError());
            exit(1);
        }

        open = true;
    }

    public ~this()
    {
        SDL_DestroyWindow(window);
        SDL_Quit();
    }

    public override bool isOpen() @nogc nothrow const
    {
        return open;
    }

    public override void setCursorVisibility(bool v) @nogc nothrow const
    {
        SDL_ShowCursor(v);
    }

    public override void pollEvents() @nogc nothrow
    {
        if (SDL_PollEvent(&event) == 0) return;

        switch (event.type)
        {
            case SDL_QUIT:
            {
                open = false;
            }
            break;

            case SDL_WINDOWEVENT:
            {
                handleWindowEvents();
            } break;

            default: break;
        }
    }

    private void handleWindowEvents() @nogc nothrow
    {
        switch (event.window.event)
        {
            case SDL_WINDOWEVENT_SIZE_CHANGED:
            {
                if (onResizeEvent !is null)
                {
                    onResizeEvent(Vec2u(event.window.data1, event.window.data2));
                }
            } break;

            default: break;
        }
    }

    public override void setSize(uint w, uint h) @nogc nothrow
    {
        SDL_SetWindowSize(window, w, h);
    }

    public override ulong getElapsedMilliseconds() @nogc nothrow const
    {
        return SDL_GetTicks();
    }

    public override ulong getHighResCounter() @nogc nothrow const
    {
        return SDL_GetPerformanceCounter();
    }

    public override ulong getHighResFrequency() @nogc nothrow const
    {
        return SDL_GetPerformanceFrequency();
    }
    
    public Vec2u getSize() @nogc nothrow
    {
        int w, h;
        SDL_GetWindowSize(window, &w, &h);
        return Vec2u(w, h);
    }

    public void setResizable(bool v) @nogc nothrow
    {
        SDL_SetWindowResizable(window, toSDLBool(v));
    }

    public void setOnResizeEvent(void function(Vec2u size) @nogc nothrow event) @nogc nothrow
    {
        onResizeEvent = event;
    }

    package SDL_Window* getInternalWindow() @nogc nothrow
    {
        return window;
    }

    private void loadSDLInternal()
    {
        import core.stdc.stdlib : exit;
        import std.stdio : writeln;

        version (Windows) setCustomLoaderSearchPath("redist/win64");

        SDLSupport support = loadSDL();

        if (support != sdlSupport)
        {
            if (support == SDLSupport.noLibrary)
            {
                writeln("Failed to load SDL.");
            }
            else if (support == SDLSupport.badLibrary)
            {
                writeln("Wrong version of SDL.");
            }

            exit(1);
        }

        if (SDL_Init(SDL_INIT_VIDEO) < 0)
        {
            writeln("Failed to initialize SDL. Error: ", SDL_GetError());
            exit(1);
        }

        version (Windows) setCustomLoaderSearchPath(null);
    }

    private void loadSDLImageInternal()
    {
        import core.stdc.stdlib : exit;
        import std.stdio : writeln;

        version (Windows) setCustomLoaderSearchPath("redist/win64");

        SDLImageSupport support = loadSDLImage();

        if (support != bindbc.sdl.sdlImageSupport)
        {
            if (support == SDLImageSupport.noLibrary)
            {
                writeln("Failed to load SDL_Image.");
            }
            else if (support == SDLImageSupport.badLibrary)
            {
                writeln("Wrong version of SDL_Image.");
            }

            exit(1);
        }

        if (IMG_Init(IMG_INIT_PNG) < 0)
        {
            writeln("Failed to initialize SDL_Image. Error: ", IMG_GetError());
            exit(1);
        }

        version (Windows) setCustomLoaderSearchPath(null);
    }
}
