module cosmomyst.ui.thickness;

/// Used for margins and paddings.
public struct Thickness
{
    public float left;
    public float top;
    public float right;
    public float bottom;

    public this(float left, float top, float right, float bottom)
    {
        this.left = left;
        this.top = top;
        this.right = right;
        this.bottom = bottom;
    }

    public this(float thickness)
    {
        this(thickness, thickness, thickness, thickness);
    }
}
