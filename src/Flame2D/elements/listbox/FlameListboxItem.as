/***************************************************************************
 *   Copyright (C) 2004 - 2010 Paul D Turner & The CEGUI Development Team
 *
 *   Porting to Flash Stage3D
 *   Copyright (C) 2012 Mingjian Yu(laoyu20032003@hotmail.com)
 *
 *   Permission is hereby granted, free of charge, to any person obtaining
 *   a copy of this software and associated documentation files (the
 *   "Software"), to deal in the Software without restriction, including
 *   without limitation the rights to use, copy, modify, merge, publish,
 *   distribute, sublicense, and/or sell copies of the Software, and to
 *   permit persons to whom the Software is furnished to do so, subject to
 *   the following conditions:
 *
 *   The above copyright notice and this permission notice shall be
 *   included in all copies or substantial portions of the Software.
 *
 *   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 *   IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 *   OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 *   ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 *   OTHER DEALINGS IN THE SOFTWARE.
 ***************************************************************************/
package Flame2D.elements.listbox
{
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.renderer.FlameGeometryBuffer;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;

    /*!
    \brief
    Base class for list box items
    */
    public class FlameListboxItem
    {
        /*************************************************************************
         Constants
         *************************************************************************/
        public static const DefaultSelectionColour:Colour = new Colour(0xFF / 255, 0x44 / 255, 0x44/255, 0xAA/255);//0xFF4444AA     //!< Default selection brush colour.
        
        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        protected var d_textLogical:String = "";
        //! pointer to bidirection support object
        //BiDiVisualMapping* d_bidiVisualMapping;
        //! whether bidi visual mapping has been updated since last text change.
        //protected var d_bidiDataValid:Boolean;
        protected var d_tooltipText:String = "";  //!< Text for the individual tooltip of this item
        protected var d_itemID:uint;       //!< ID code assigned by client code.  This has no meaning within the GUI system.
        protected var d_itemData:*;     //!< Pointer to some client code data.  This has no meaning within the GUI system.
        protected var d_selected:Boolean = false;     //!< true if this item is selected.  false if the item is not selected.
        protected var d_disabled:Boolean;     //!< true if this item is disabled.  false if the item is not disabled.
        protected var d_autoDelete:Boolean;   //!< true if the system should destroy this item, false if client code will destroy the item.
        protected var d_owner:FlameWindow = null;    //!< Pointer to the window that owns this item.
        protected var d_selectCols:ColourRect = new ColourRect(
            DefaultSelectionColour,
            DefaultSelectionColour,
            DefaultSelectionColour,
            DefaultSelectionColour);  //!< Colours used for selection highlighting.
        protected var d_selectBrush:FlameImage = null;      //!< Image used for rendering selection.
        
        
        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        base class constructor
        */
        public function FlameListboxItem(text:String, item_id:uint = 0, item_data:Object = null, 
                                    disabled:Boolean = false, auto_delete:Boolean = true)
        {
            d_itemID = item_id;
            d_itemData = item_data;
            d_disabled = disabled;
            d_autoDelete = auto_delete;
            
            setText(text);
        }
        
        /*************************************************************************
         Accessors
         *************************************************************************/
        /*!
        \brief
        return the text string set for this list box item.
        
        Note that even if the item does not render text, the text string can still be useful, since it
        is used for sorting list box items.
        
        \return
        String object containing the current text for the list box item.
        */
        public function getTooltipText():String
        {
            return d_tooltipText;
        }
        
        public function getText():String
        {
            return d_textLogical;
        }
        
        //! return text string with \e visual ordering of glyphs.
        public function getTextVisual():String
        {
            // no bidi support
//            if (!d_bidiVisualMapping)
//                return d_textLogical;
//            
//            if (!d_bidiDataValid)
//            {
//                d_bidiVisualMapping->updateVisual(d_textLogical);
//                d_bidiDataValid = true;
//            }
//            
//            return d_bidiVisualMapping->getTextVisual();
            
            return d_textLogical;
        }
        
        /*!
        \brief
        Return the current ID assigned to this list box item.
        
        Note that the system does not make use of this value, client code can assign any meaning it
        wishes to the ID.
        
        \return
        ID code currently assigned to this list box item
        */
        public function getID():uint
        {
            return d_itemID;
        }
        
        
        /*!
        \brief
        Return the pointer to any client assigned user data attached to this lis box item.
        
        Note that the system does not make use of this data, client code can assign any meaning it
        wishes to the attached data.
        
        \return
        Pointer to the currently assigned user data.
        */
        public function getUserData():*
        {
            return d_itemData;
        }
        
        
        /*!
        \brief
        return whether this item is selected.
        
        \return
        true if the item is selected, false if the item is not selected.
        */
        public function isSelected():Boolean
        {
            return d_selected;
        }
        
        
        /*!
        \brief
        return whether this item is disabled.
        
        \return
        true if the item is disabled, false if the item is enabled.
        */
        public function isDisabled():Boolean
        {
            return d_disabled;
        }
        
        
        /*!
        \brief
        return whether this item will be automatically deleted when the list box it is attached to
        is destroyed, or when the item is removed from the list box.
        
        \return
        true if the item object will be deleted by the system when the list box it is attached to is
        destroyed, or when the item is removed from the list.  false if client code must destroy the
        item after it is removed from the list.
        */
        public function isAutoDeleted():Boolean
        {
            return d_autoDelete;
        }
        
        
        /*!
        \brief
        Get the owner window for this ListboxItem.
        
        The owner of a ListboxItem is typically set by the list box widgets when an item is added or inserted.
        
        \return
        Ponter to the window that is considered the owner of this ListboxItem.
        */
        public function getOwnerWindow():FlameWindow
        {
            return d_owner;
        }
        
        
        /*!
        \brief
        Return the current colours used for selection highlighting.
        
        \return
        ColourRect object describing the currently set colours
        */
        public function getSelectionColours():ColourRect
        {
            return d_selectCols;
        }
        
        
        /*!
        \brief
        Return the current selection highlighting brush.
        
        \return
        Pointer to the Image object currently used for selection highlighting.
        */
        public function getSelectionBrushImage():FlameImage
        {
            return d_selectBrush;
        }
        
        
        /*************************************************************************
         Manipulators
         *************************************************************************/
        /*!
        \brief
        set the text string for this list box item.
        
        Note that even if the item does not render text, the text string can still be useful, since it
        is used for sorting list box items.
        
        \param text
        String object containing the text to set for the list box item.
        
        \return
        Nothing.
        */
        public function setText(text:String):void
        {
            d_textLogical = text;
            //d_bidiDataValid = false
        }
        
        public function setTooltipText(text:String):void
        {
            d_tooltipText = text;
        }
        
        /*!
        \brief
        Set the ID assigned to this list box item.
        
        Note that the system does not make use of this value, client code can assign any meaning it
        wishes to the ID.
        
        \param item_id
        ID code to be assigned to this list box item
        
        \return
        Nothing.
        */
        public function setID(item_id:uint):void
        {
            d_itemID = item_id;
        }
        
        
        /*!
        \brief
        Set the client assigned user data attached to this lis box item.
        
        Note that the system does not make use of this data, client code can assign any meaning it
        wishes to the attached data.
        
        \param item_data
        Pointer to the user data to attach to this list item.
        
        \return
        Nothing.
        */
        public function setUserData(item_data:*):void
        {
            d_itemData = item_data;
        }
        
        
        /*!
        \brief
        set whether this item is selected.
        
        \param setting
        true if the item is selected, false if the item is not selected.
        
        \return
        Nothing.
        */
        public function setSelected(setting:Boolean):void
        {
            d_selected = setting;
        }
        
        
        /*!
        \brief
        set whether this item is disabled.
        
        \param setting
        true if the item is disabled, false if the item is enabled.
        
        \return
        Nothing.
        */
        public function setDisabled(setting:Boolean):void
        {
            d_disabled = setting;
        }
        
        /*!
        \brief
        Set whether this item will be automatically deleted when the list box it is attached to
        is destroyed, or when the item is removed from the list box.
        
        \param setting
        true if the item object should be deleted by the system when the list box it is attached to is
        destroyed, or when the item is removed from the list.  false if client code will destroy the
        item after it is removed from the list.
        
        \return
        Nothing.
        */
        public function setAutoDeleted(setting:Boolean):void
        {
            d_autoDelete = setting;
        }
        
        
        /*!
        \brief
        Set the owner window for this ListboxItem.  This is called by all the list box widgets when
        an item is added or inserted.
        
        \param owner
        Ponter to the window that should be considered the owner of this ListboxItem.
        
        \return
        Nothing
        */
        public function setOwnerWindow(owner:FlameWindow):void
        {
            d_owner = owner;
        }
        
        
        /*!
        \brief
        Set the colours used for selection highlighting.
        
        \param cols
        ColourRect object describing the colours to be used.
        
        \return
        Nothing.
        */
        public function setSelectionColours(cols:ColourRect):void
        {
            d_selectCols = cols;
        }
        
        
        /*!
        \brief
        Set the colours used for selection highlighting.
        
        \param top_left_colour
        Colour (as ARGB value) to be applied to the top-left corner of the selection area.
        
        \param top_right_colour
        Colour (as ARGB value) to be applied to the top-right corner of the selection area.
        
        \param bottom_left_colour
        Colour (as ARGB value) to be applied to the bottom-left corner of the selection area.
        
        \param bottom_right_colour
        Colour (as ARGB value) to be applied to the bottom-right corner of the selection area.
        
        \return
        Nothing.
        */
        public function setSelectionColours4(top_left_colour:Colour, top_right_colour:Colour, 
                                             bottom_left_colour:Colour, bottom_right_colour:Colour):void
        {
            d_selectCols.d_top_left		= top_left_colour;
            d_selectCols.d_top_right	= top_right_colour;
            d_selectCols.d_bottom_left	= bottom_left_colour;
            d_selectCols.d_bottom_right	= bottom_right_colour;
        }
        
        
        /*!
        \brief
        Set the colours used for selection highlighting.
        
        \param col
        colour value to be used when rendering.
        
        \return
        Nothing.
        */
        public function setSelectionColours1(col:Colour):void
        {
            setSelectionColours4(col, col, col, col);
        }
        
        
        /*!
        \brief
        Set the selection highlighting brush image.
        
        \param image
        Pointer to the Image object to be used for selection highlighting.
        
        \return
        Nothing.
        */
        public function setSelectionBrushImage(image:FlameImage):void
        {
            d_selectBrush = image;
        }
        
        
        /*!
        \brief
        Set the selection highlighting brush image.
        
        \param imageset
        Name of the imagest containing the image to be used.
        
        \param image
        Name of the image to be used
        
        \return
        Nothing.
        */
        public function setSelectionBrushImageFromImageSet(imageset:String, image:String):void
        {
            setSelectionBrushImage(FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image));
        }
        
        
        /*************************************************************************
         Abstract portion of interface
         *************************************************************************/
        /*!
        \brief
        Return the rendered pixel size of this list box item.
        
        \return
        Size object describing the size of the list box item in pixels.
        */
        public function getPixelSize():Size
        {
            return new Size();   
        }
        
        
        /*!
        \brief
        Draw the list box item in its current state
        
        \param position
        Vecor2 object describing the upper-left corner of area that should be rendered in to for the draw operation.
        
        \param alpha
        Alpha value to be used when rendering the item (between 0.0f and 1.0f).
        
        \param clipper
        Rect object describing the clipping rectangle for the draw operation.
        
        \return
        Nothing.
        */
        
        //virtual
        public function draw(buffer:FlameGeometryBuffer, targetRect:Rect, alpha:Number, clipper:Rect):void
        {
        }
        
        /*************************************************************************
         Operators
         *************************************************************************/
        /*!
        \brief
        Less-than operator, compares item texts.
        */
        //virtual bool    operator<(const ListboxItem& rhs) const     {return getText() < rhs.getText();}
        
        public function lessThan(rhs:FlameListboxItem):Boolean
        {
            return getText() < rhs.getText();
        }
        
        /*!
        \brief
        Greater-than operator, compares item texts.
        */
        //virtual bool    operator>(const ListboxItem& rhs) const     {return getText() > rhs.getText();}
        public function greaterThan(rhs:FlameListboxItem):Boolean
        {
            return getText() > rhs.getText();
        }

        
        
        /*************************************************************************
         Implementation methods
         *************************************************************************/
        /*!
        \brief
        Return a ColourRect object describing the colours in \a cols after having their alpha
        component modulated by the value \a alpha.
        */
        protected function getModulateAlphaColourRect(cols:ColourRect, alpha:Number):ColourRect
        {
            return new ColourRect
            (
                calculateModulatedAlphaColour(cols.d_top_left, alpha),
                calculateModulatedAlphaColour(cols.d_top_right, alpha),
                calculateModulatedAlphaColour(cols.d_bottom_left, alpha),
                calculateModulatedAlphaColour(cols.d_bottom_right, alpha)
            );
        }
        
        
        /*!
        \brief
        Return a colour value describing the colour specified by \a col after having its alpha
        component modulated by the value \a alpha.
        */
        protected function  calculateModulatedAlphaColour(col:Colour, alpha:Number):Colour
        {
            var temp:Colour = col.clone();
            temp.setAlpha(temp.getAlpha() * alpha);
            return temp;
        }
        
    }
}