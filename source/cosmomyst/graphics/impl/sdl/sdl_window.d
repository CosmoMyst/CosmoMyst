module cosmomyst.graphics.impl.sdl.sdl_window;

version(SDL):

import bindbc.sdl;
import dath;
import cosmomyst.events;
import cosmomyst.graphics.window;
import cosmomyst.graphics.impl.sdl.sdl_util;

public class SDLWindow : Window
{
    private SDL_Window* window;
    private SDL_Event event;

    private uint width;
    private uint height;

    private bool open;
    private string title;

    private bool mouseFocus;
    private bool keyboardFocus;
    private bool minimized;
    private bool maximized;
    private bool fullscreen;

    private WindowMode mode = WindowMode.windowed;

    public this(string title, uint width, uint height)
    {
        import core.stdc.stdlib : exit;
        import std.stdio : writeln;

        this.width = width;
        this.height = height;

        loadSDLInternal();
        loadSDLImageInternal();
        loadSDLTTFInternal();

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
        this.title = title;
    }

    public ~this()
    {
        TTF_Quit();
        IMG_Quit();
        SDL_DestroyWindow(window);
        SDL_Quit();
    }

    public override bool isOpen() @nogc nothrow const
    {
        return open;
    }

    public override void close() @nogc nothrow
    {
        open = false;
    }

    public override string getTitle() @nogc nothrow const
    {
        return title;
    }

    public override void setTitle(string t) @nogc nothrow
    {
        title = t;
        SDL_SetWindowTitle(window, t.ptr);
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
                onResize.emit(Vec2u(event.window.data1, event.window.data2));
            } break;

            case SDL_WINDOWEVENT_ENTER:
            {
                mouseFocus = true;
                onMouseFocusChange.emit(mouseFocus);
            } break;

            case SDL_WINDOWEVENT_LEAVE:
            {
                mouseFocus = false;
                onMouseFocusChange.emit(mouseFocus);
            } break;

            case SDL_WINDOWEVENT_FOCUS_GAINED:
            {
                keyboardFocus = true;
                onKeyboardFocusChange.emit(keyboardFocus);
            } break;

            case SDL_WINDOWEVENT_FOCUS_LOST:
            {
                keyboardFocus = false;
                onKeyboardFocusChange.emit(keyboardFocus);
            } break;

            case SDL_WINDOWEVENT_MINIMIZED:
            {
                minimized = true;
                maximized = false;
                onMinimizedChange.emit(minimized);
                onMaximizedChange.emit(maximized);
            } break;

            case SDL_WINDOWEVENT_MAXIMIZED:
            {
                minimized = false;
                maximized = true;
                onMinimizedChange.emit(minimized);
                onMaximizedChange.emit(maximized);
            } break;

            case SDL_WINDOWEVENT_RESTORED:
            {
                minimized = false;
                maximized = false;
                onMinimizedChange.emit(minimized);
                onMaximizedChange.emit(maximized);
            } break;

            default: break;
        }
    }

    public override Vec2u getWindowedSize() @nogc nothrow
    {
        int w, h;
        SDL_GetWindowSize(window, &w, &h);
        return Vec2u(w, h);
    }

    public override void setWindowedSize(uint w, uint h) @nogc nothrow
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

    public override void setResizable(bool v) @nogc nothrow
    {
        SDL_SetWindowResizable(window, toSDLBool(v));
    }

    public override bool hasMouseFocus() @nogc nothrow const
    {
        return mouseFocus;
    }

    public override bool hasKeyboardFocus() @nogc nothrow const
    {
        return keyboardFocus;
    }

    public override bool isMinimized() @nogc nothrow const
    {
        return minimized;
    }

    public override bool isMaximized() @nogc nothrow const
    {
        return maximized;
    }

    public override bool setMode(WindowMode mode) @nogc nothrow
    {
        int res = 0;

        final switch (mode)
        {
            case WindowMode.fullscreen:
            {
                res = SDL_SetWindowFullscreen(window, SDL_WINDOW_FULLSCREEN);
            } break;

            case WindowMode.fullscreenBorderless:
            {
                res = SDL_SetWindowFullscreen(window, SDL_WINDOW_FULLSCREEN_DESKTOP);
            } break;

            case WindowMode.windowed:
            {
                res = SDL_SetWindowFullscreen(window, 0);
            } break;
        }

        if (res == 0)
        {
            this.mode = mode;
            return true;
        }

        return false;
    }

    public override WindowMode getMode() @nogc nothrow const
    {
        return mode;
    }

    package SDL_Window* getInternalWindow() @nogc nothrow
    {
        return window;
    }

    private void loadSDLInternal()
    {
        import core.stdc.stdlib : exit;
        import std.stdio : writeln;

        if (isSDLLoaded()) return;

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

        if (loadedSDLVersion() < SDLSupport.sdl2010)
        {
            writeln("Wrong version of SDL");
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

        if (isSDLImageLoaded()) return;

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

    private void loadSDLTTFInternal()
    {
        import core.stdc.stdlib : exit;
        import std.stdio : writeln;

        if (isSDLTTFLoaded()) return;

        version (Windows) setCustomLoaderSearchPath("redist/win64");

        SDLTTFSupport support = loadSDLTTF();

        if (support != bindbc.sdl.sdlTTFSupport)
        {
            if (support == SDLTTFSupport.noLibrary)
            {
                writeln("Failed to load SDL_ttf.");
            }
            else if (support == SDLTTFSupport.badLibrary)
            {
                writeln("Wrong version of SDL_ttf.");
            }

            exit(1);
        }

        if (TTF_Init() < 0)
        {
            writeln("Failed to initialize SDL_ttf. Error: ", TTF_GetError());
            exit(1);
        }

        version (Windows) setCustomLoaderSearchPath(null);
    }
}
