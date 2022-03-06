module cosmomyst.ui.widget;

import dath;
import cosmomyst.graphics;
import cosmomyst.ui.overflow;
import cosmomyst.ui.alignment;
import cosmomyst.ui.thickness;

/// Base class for UI widgets.
public abstract class Widget
{
    public Vec2 position = Vec2(0);

    /// Original size, might change, use `actualSize` for the actual current size
    public Vec2 size = Vec2(0);

    public Vec2 actualSize = Vec2(0);

    public Overflow overflow = Overflow.hidden;

    /// Origin between `Vec2.zero` and `Vec2.one`
    public Vec2 origin = Vec2(0);

    public Color color = Colors.white;

    public HorizontalAlignment horizontalAlignment = HorizontalAlignment.left;
    public VerticalAlignment verticalAlignment = VerticalAlignment.top;

    public Thickness margin = Thickness(0);
    public Thickness padding = Thickness(0);

    package Widget parent;
    package Widget[] children;

    public const(Widget) getParent() @nogc nothrow const
    {
        return parent;
    }

    package void setParent(Widget parent) @nogc nothrow
    {
        this.parent = parent;
    }

    public const(Widget[]) getChildren() @nogc nothrow const
    {
        return children;
    }

    public void addChild(Widget child)
    {
        if (child == this) throw new Exception("Cannot add widget as a child of itself.");

        children ~= child;
        child.setParent(this);
        child.initialize();
    }

    public void initialize() { }

    public void update(double dt) @nogc nothrow
    {
        foreach (child; children)
        {
            child.update(dt);
        }
    }

    public void draw(Renderer renderer) @nogc nothrow
    {
        foreach (child; children)
        {
            child.draw(renderer);
        }

        actualSize = size;
        origin = origin.clamp(Vec2.zero, Vec2.one);

        final switch (horizontalAlignment)
        {
            case HorizontalAlignment.stretch:
            {
                origin.x = 0;
                position.x = parent.position.x + parent.padding.left + margin.left;
                actualSize.x = parent.actualSize.x - (parent.padding.left + parent.padding.right) -
                              (margin.left + margin.right);
            } break;

            case HorizontalAlignment.left:
            {
                origin.x = 0;
                position.x = parent.position.x - (actualSize.x * origin.x) + parent.padding.left + margin.left;
                if ( position.x + actualSize.x > parent.position.x + parent.actualSize.x -
                                                 margin.right - parent.padding.right)
                {
                    actualSize.x -= (position.x + actualSize.x) -
                                    (parent.position.x + parent.actualSize.x - margin.right - parent.padding.right);
                }
            } break;

            case HorizontalAlignment.center:
            {
                origin.x = 0.5;
                position.x = parent.position.x + (parent.actualSize.x / 2) - (actualSize.x * origin.x);
                if (position.x < parent.position.x + parent.padding.left + margin.left)
                {
                    position.x = parent.position.x + parent.padding.left + margin.left;
                }
                if (position.x + actualSize.x > parent.position.x + parent.actualSize.x -
                                                margin.right - parent.padding.right)
                {
                    actualSize.x -= (position.x + actualSize.x) -
                                    (parent.position.x + parent.actualSize.x - margin.right - parent.padding.right);
                }
            } break;

            case HorizontalAlignment.right:
            {
                origin.x = 1;
                position.x = parent.position.x + parent.actualSize.x - (actualSize.x * origin.x) -
                            (parent.padding.right) - margin.right;
                if (position.x < parent.position.x + parent.padding.left + margin.left)
                {
                    position.x = parent.position.x + parent.padding.left + margin.left;
                    actualSize.x -= (position.x + actualSize.x) -
                                    (parent.position.x + parent.actualSize.x - parent.padding.right - margin.right);
                }
            } break;

            case HorizontalAlignment.none: break;
        }

        final switch (verticalAlignment)
        {
            case VerticalAlignment.stretch:
            {
                origin.y = 0;
                position.y = parent.position.y + parent.padding.top + margin.top;
                actualSize.y = parent.actualSize.y - (parent.padding.top + parent.padding.bottom) -
                              (margin.top + margin.bottom);
            } break;

            case VerticalAlignment.top:
            {
                origin.y = 0;
                position.y = parent.position.y - (actualSize.y * origin.y) + parent.padding.top + margin.top;
                if (position.y + actualSize.y > parent.position.y + parent.actualSize.y -
                                                parent.padding.bottom - margin.right)
                {
                    actualSize.y -= (position.y + actualSize.y) -
                                    (parent.position.y + parent.actualSize.y - parent.padding.bottom - margin.bottom);
                }
            } break;

            case VerticalAlignment.center:
            {
                origin.y = 0.5;
                position.y = parent.position.y + (parent.actualSize.y / 2) - (actualSize.y * origin.y);
                if (position.y < parent.position.y + parent.padding.top + margin.top)
                {
                    position.y = parent.position.y + parent.padding.top + margin.top;
                }
                if (position.y + actualSize.y > parent.position.y + parent.actualSize.y -
                                                parent.padding.bottom - margin.bottom)
                {
                    actualSize.y -= (position.y + actualSize.y) -
                                    (parent.position.y + parent.actualSize.y - parent.padding.bottom - margin.bottom);
                }
            } break;

            case VerticalAlignment.bottom:
            {
                origin.y = 1;
                position.y = parent.position.y + parent.actualSize.y - (actualSize.y * origin.y) -
                             parent.padding.bottom - margin.bottom;
                if (position.y < parent.position.y + parent.padding.top + margin.top)
                {
                    position.y = parent.position.y + parent.padding.top + margin.top;
                    actualSize.y -= (position.y + actualSize.y) -
                                    (parent.position.y + parent.actualSize.y - parent.padding.bottom - margin.bottom);
                }
            } break;

            case VerticalAlignment.none: break;
        }
    }
}

