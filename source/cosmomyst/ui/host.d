module cosmomyst.ui.host;

import cosmomyst.graphics;
import cosmomyst.input;
import cosmomyst.ui;

public class UIHost
{
    private Canvas[] canvases;

    public void addCanvas(Canvas canvas)
    {
        this.canvases ~= canvas;
        canvas.initialize();
    }

    public void update(Input input, double dt) @nogc nothrow
    {
        foreach (c; canvases) c.update(dt);

        foreach (c; canvases) checkMouseEvents(input, c);
    }

    private void checkMouseEvents(Input input, Widget root) @nogc nothrow
    {
        if (input.mousePos().x > root.position.x && input.mousePos().x < root.position.x + root.actualSize.x &&
            input.mousePos().y > root.position.y && input.mousePos().y < root.position.y + root.actualSize.y)
        {
            root.isHovered = true;

            if (input.isMouseButtonPressed(MouseButton.left))
            {
                if (root.onClick !is null) root.onClick();
            }
        }
        else
        {
            root.isHovered = false;
        }

        if (root.isHovered && !root.isHoveredLastFrame)
        {
            if (root.onMouseEnter !is null) root.onMouseEnter();
        }

        if (root.isHoveredLastFrame && !root.isHovered)
        {
            if (root.onMouseLeave !is null) root.onMouseLeave();
        }

        foreach (child; root.children) checkMouseEvents(input, child);

        root.isHoveredLastFrame = root.isHovered;
    }

    public void draw(Renderer renderer) @nogc nothrow
    {
        foreach (c; canvases) c.draw(renderer);
    }
}
