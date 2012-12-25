

package Flame2D.core.utils
{
    import Flame2D.core.properties.FlamePropertyHelper;

    /*!
    \brief
    Class that holds details of colours for the four corners of a rectangle.
    */
    public class ColourRect
    {
        public var d_top_left:Colour;
        public var d_top_right:Colour;
        public var d_bottom_left:Colour;
        public var d_bottom_right:Colour;
        
        public function ColourRect(top_left:Colour = null, top_right:Colour = null, 
                                   bottom_left:Colour = null, bottom_right:Colour = null)
        {
            d_top_left = top_left ? top_left : new Colour();
            d_top_right = top_right ? top_right : new Colour();
            d_bottom_left = bottom_left ? bottom_left : new Colour();
            d_bottom_right = bottom_right ? bottom_right : new Colour();
        }
        
        public function clone():ColourRect
        {
            return new ColourRect(d_top_left.clone(), d_top_right.clone(),
                d_bottom_left.clone(), d_bottom_right.clone());
        }
        /*!
        \brief
        Set the alpha value to use for all four corners of the ColourRect.
        
        \param alpha
        Alpha value to use.
        
        \return
        Nothing.
        */
        public function setAlpha(alpha:Number):void
        {
            d_top_left.setAlpha(alpha);
            d_top_right.setAlpha(alpha);
            d_bottom_left.setAlpha(alpha);
            d_bottom_right.setAlpha(alpha);
        }
        
        
        /*!
        \brief
        Set the alpha value to use for the top edge of the ColourRect.
        
        \param alpha
        Alpha value to use.
        
        \return
        Nothing.
        */
        public function setTopAlpha(alpha:Number):void
        {
            d_top_left.setAlpha(alpha);
            d_top_right.setAlpha(alpha);
        }
        
        
        /*!
        \brief
        Set the alpha value to use for the bottom edge of the ColourRect.
        
        \param alpha
        Alpha value to use.
        
        \return
        Nothing.
        */
        public function setBottomAlpha(alpha:Number):void
        {
            d_bottom_left.setAlpha(alpha);
            d_bottom_right.setAlpha(alpha);
        }
        
        /*!
        \brief
        Set the alpha value to use for the left edge of the ColourRect.
        
        \param alpha
        Alpha value to use.
        
        \return
        Nothing.
        */
        public function setLeftAlpha(alpha:Number):void
        {
            d_top_left.setAlpha(alpha);
            d_bottom_left.setAlpha(alpha);
        }
        
        
        /*!
        \brief
        Set the alpha value to use for the right edge of the ColourRect.
        
        \param alpha
        Alpha value to use.
        
        \return
        Nothing.
        */
        public function setRightAlpha(alpha:Number):void
        {
            d_top_right.setAlpha(alpha);
            d_bottom_right.setAlpha(alpha);
        }
        
        
        /*!
        \brief
        Determinate the ColourRect is monochromatic or variegated.
        
        \return
        True if all four corners of the ColourRect has same colour, false otherwise.
        */
        public function isMonochromatic():Boolean
        {
            return d_top_left.isEqual(d_top_right) &&
                d_top_left.isEqual(d_bottom_left) &&
                d_top_left.isEqual(d_bottom_right);

        }
        
        /*!
        \brief
        Gets a portion of this ColourRect as a subset ColourRect
        
        \param left
        The left side of this subrectangle (in the range of 0-1 float)
        \param right
        The right side of this subrectangle (in the range of 0-1 float)
        \param top
        The top side of this subrectangle (in the range of 0-1 float)
        \param bottom
        The bottom side of this subrectangle (in the range of 0-1 float)
        
        \return
        A ColourRect from the specified range
        */
        public function getSubRectangle(left:Number, right:Number, top:Number, bottom:Number ):ColourRect
        {
            return new ColourRect(
                getColourAtPoint(left, top),
                getColourAtPoint(right, top),
                getColourAtPoint(left, bottom),
                getColourAtPoint(right, bottom)
            );
        }
        
        /*!
        \brief
        Get the colour at a point in the rectangle
        
        \param x
        The x coordinate of the point
        \param y
        The y coordinate of the point
        
        \return
        The colour at the specified point.
        */
        public function getColourAtPoint(x:Number, y:Number):Colour
        {
            var h1:Colour = d_top_right.substract(d_top_left).multiply(x).add(d_top_left);
            var h2:Colour = d_bottom_right.substract(d_bottom_left).multiply(x).add(d_bottom_left);
            return h2.substract(h1).multiply(y).add(h1);
        }
        
        /*!
        \brief
        Set the colour of all four corners simultaneously.
        
        \param col
        colour that is to be set for all four corners of the ColourRect;
        */
        public function setColours(col:Colour):void
        {
            d_top_left = col.clone();
            d_top_right = col.clone();
            d_bottom_left = col.clone();
            d_bottom_right = col.clone();
        }
        
        
        /*!
        \brief
        Module the alpha components of each corner's colour by a constant.
        
        \param alpha
        The constant factor to modulate all alpha colour components by.
        */
        public function modulateAlpha(alpha:Number):void
        {
            d_top_left.setAlpha(d_top_left.getAlpha()*alpha);
            d_top_right.setAlpha(d_top_right.getAlpha()*alpha);
            d_bottom_left.setAlpha(d_bottom_left.getAlpha()*alpha);
            d_bottom_right.setAlpha(d_bottom_right.getAlpha()*alpha);
        }
        
        /*!
        \brief
        Modulate all components of this colour rect with corresponding components from another colour rect.
        */
        
        public function multiply(val:Number):ColourRect
        {       
            return new ColourRect(
                d_top_left.multiply(val), 
                d_top_right.multiply(val), 
                d_bottom_left.multiply(val),
                d_bottom_right.multiply(val) 
            );  
        }
        
        public function multiplyColourRect(other:ColourRect):ColourRect
        {
            return new ColourRect(
                d_top_left.multiplyColor(other.d_top_left),
                d_top_right.multiplyColor(other.d_top_right),
                d_bottom_left.multiplyColor(other.d_bottom_left),
                d_bottom_right.multiplyColor(other.d_bottom_right)
            );
        }

        public function multiplyColourRect2(other:ColourRect):void
        {
            d_top_left = d_top_left.multiplyColor(other.d_top_left),
            d_top_right = d_top_right.multiplyColor(other.d_top_right),
            d_bottom_left = d_bottom_left.multiplyColor(other.d_bottom_left),
            d_bottom_right = d_bottom_right.multiplyColor(other.d_bottom_right)
        }

        public function add(val:ColourRect):ColourRect
        {       
            return new ColourRect(
                d_top_left.add(val.d_top_left), 
                d_top_right.add(val.d_top_right), 
                d_bottom_left.add(val.d_bottom_left),
                d_bottom_right.add(val.d_bottom_right) 
            );  
        }

        public function toString():String
        {
            return FlamePropertyHelper.colourRectToString(this);
        }
    }
}