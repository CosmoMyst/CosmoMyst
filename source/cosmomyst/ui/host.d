module cosmomyst.ui.host;

import cosmomyst.graphics;
import cosmomyst.ui.canvas;

public class UIHost
{
    private Canvas[] canvases;

    public void addCanvas(Canvas canvas)
    {
        this.canvases ~= canvas;
        canvas.initialize();
    }

    public void update(double dt) @nogc nothrow
    {
        foreach (c; canvases) c.update(dt);
    }

    public void draw(Renderer renderer) @nogc nothrow
    {
        foreach (c; canvases) c.draw(renderer);
    }
}
