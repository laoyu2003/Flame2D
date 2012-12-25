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
package Flame2D.elements.tree
{
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.imagesets.FlameImage;
    import Flame2D.core.system.FlameFont;
    import Flame2D.core.system.FlameFontManager;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.text.FlameBasicRenderedStringParser;
    import Flame2D.core.text.FlameRenderedString;
    import Flame2D.core.utils.Colour;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.renderer.FlameGeometryBuffer;

    /*!
    \brief
    Base class for tree items
    
    \deprecated
    The CEGUI::Tree, CEGUI::TreeItem and any other associated classes are
    deprecated and thier use should be minimised - preferably eliminated -
    where possible.  It is extremely unfortunate that this widget was ever added
    to CEGUI since its design and implementation are poor and do not meet
    established standards for the CEGUI project.
    \par
    While no alternative currently exists, a superior, replacement tree widget
    will be provided prior to the final removal of the current implementation.
    */
    public class FlameTreeItem
    {
        
        //typedef std::vector<TreeItem*>  LBItemList;
        
        /*************************************************************************
         Constants
         *************************************************************************/
        //! Default text colour.
        public static const DefaultTextColour:uint = 0xFF4444AA;
        //! Default selection brush colour.
        public static const DefaultSelectionColour:uint = 0xFFFFFFFF;


        protected static var d_stringParser:FlameBasicRenderedStringParser = new FlameBasicRenderedStringParser();

        /*************************************************************************
         Implementation Data
         *************************************************************************/
        //! Text for this tree item.  If not rendered, still used for sorting.
        protected var d_textLogical:String;            //!< text rendered by this component.
        //! pointer to bidirection support object
        //BiDiVisualMapping* d_bidiVisualMapping;
        //! whether bidi visual mapping has been updated since last text change.
        //mutable bool d_bidiDataValid;
        //! Text for the individual tooltip of this item.
        protected var d_tooltipText:String;
        //! ID code assigned by client code.
        protected var d_itemID:uint;
        //! Pointer to some client code data.
        protected var d_itemData:*;
        //! true if item is selected.  false if item is not selected.
        protected var d_selected:Boolean = false;
        //! true if item is disabled.  false if item is not disabled.
        protected var d_disabled:Boolean;
        //! true if the system will destroy this item, false if client code will.
        protected var d_autoDelete:Boolean;
        //! Location of the 'expand' button for the item.
        protected var d_buttonLocation:Rect = new Rect(0,0,0,0);
        //! Pointer to the window that owns this item.
        protected var d_owner:FlameWindow = null;
        //! Colours used for selection highlighting.
        protected var d_selectCols:ColourRect;
        //! Image used for rendering selection.
        protected var d_selectBrush:FlameImage = null;
        //! Colours used for rendering the text.
        protected var d_textCols:ColourRect;
        //! Font used for rendering text.
        protected var d_font:FlameFont = null;
        //! Image for the icon to be displayed with this TreeItem.
        protected var d_iconImage:FlameImage = null;
        //! list of items in this item's tree branch.
        protected var d_listItems:Vector.<FlameTreeItem> = new Vector.<FlameTreeItem>();
        //! true if the this item's tree branch is opened.
        protected var d_isOpen:Boolean = false;
        //! Parser used to produce a final RenderedString from the standard String.
        //! RenderedString drawn by this item.
        protected var d_renderedString:FlameRenderedString;
        //! boolean used to track when item state changes (and needs re-parse)
        protected var d_renderedStringValid:Boolean = false;
        
        
        /*************************************************************************
         Construction and Destruction
         *************************************************************************/
        /*!
        \brief
        base class constructor
        */
        public function FlameTreeItem(text:String, item_id:uint = 0, item_data:* = null,
                    disabled:Boolean = false, auto_delete:Boolean = true)
        {
            d_itemID = item_id;
            d_itemData = item_data;
            d_disabled = disabled;
            d_autoDelete = auto_delete;
            
            var col:Colour = new Colour(1, 1, 1, 1);
            d_selectCols = new ColourRect(col, col, col, col);
            //0xFF4444AA
            col = new Colour(0xFF/255, 0x44/255, 0x44/255, 0xAA/255);
            d_textCols = new ColourRect(col, col, col, col);
            
            
            setText(text);
        }
        

        
        /*************************************************************************
         Accessors
         *************************************************************************/
        /*!
        \brief
        Return a pointer to the font being used by this TreeItem
        
        This method will try a number of places to find a font to be used.  If
        no font can be found, NULL is returned.
        
        \return
        Font to be used for rendering this item
        */
        public function getFont():FlameFont
        {
            // prefer out own font
            if (d_font != null)
                return d_font;
                // try our owner window's font setting
                // (may be null if owner uses non existant default font)
            else if (d_owner != null)
                return d_owner.getFont();
                // no owner, just use the default (which may be NULL anyway)
            else
                return FlameSystem.getSingleton().getDefaultFont();   
        }
        
        /*!
        \brief
        Return the current colours used for text rendering.
        
        \return
        ColourRect object describing the currently set colours
        */
        public function getTextColours():ColourRect
        {
            return d_textCols;
        }
        
        /*************************************************************************
         Manipulator methods
         *************************************************************************/
        /*!
        \brief
        Set the font to be used by this TreeItem
        
        \param font
        Font to be used for rendering this item
        
        \return
        Nothing
        */
        public function setFont(font:FlameFont):void
        {
            d_font = font;
            
            d_renderedStringValid = false;
        }
            
        
        /*!
        \brief
        Set the font to be used by this TreeItem
        
        \param font_name
        String object containing the name of the Font to be used for rendering
        this item
        
        \return
        Nothing
        */
        public function setFontByName(font_name:String):void
        {
            setFont(FlameFontManager.getSingleton().getFont(font_name));
        }
        
        /*!
        \brief
        Set the colours used for text rendering.
        
        \param cols
        ColourRect object describing the colours to be used.
        
        \return
        Nothing.
        */
        public function setTextColours(cols:ColourRect):void
        {
            d_textCols = cols;
            d_renderedStringValid = false;
        }
        
        /*!
        \brief
        Set the colours used for text rendering.
        
        \param top_left_colour
        Colour (as ARGB value) to be applied to the top-left corner of each text
        glyph rendered.
        
        \param top_right_colour
        Colour (as ARGB value) to be applied to the top-right corner of each
        text glyph rendered.
        
        \param bottom_left_colour
        Colour (as ARGB value) to be applied to the bottom-left corner of each
        text glyph rendered.
        
        \param bottom_right_colour
        Colour (as ARGB value) to be applied to the bottom-right corner of each
        text glyph rendered.
        
        \return
        Nothing.
        */
        public function setTextColours4(top_left_colour:Colour, top_right_colour:Colour,
            bottom_left_colour:Colour, bottom_right_colour:Colour):void
        {
            d_textCols.d_top_left		= top_left_colour;
            d_textCols.d_top_right		= top_right_colour;
            d_textCols.d_bottom_left	= bottom_left_colour;
            d_textCols.d_bottom_right	= bottom_right_colour;
            
            d_renderedStringValid = false;
        }
        
        /*!
        \brief
        Set the colours used for text rendering.
        
        \param col
        colour value to be used when rendering.
        
        \return
        Nothing.
        */
        public function setTextColours1(col:Colour):void
        {
            setTextColours4(col, col, col, col);
        }
        
        /*!
        \brief
        return the text string set for this tree item.
        
        Note that even if the item does not render text, the text string can
        still be useful, since it is used for sorting tree items.
        
        \return
        String object containing the current text for the tree item.
        */
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
        Return the text string currently set to be used as the tooltip text for
        this item.
        
        \return
        String object containing the current tooltip text as sued by this item.
        */
        public function getTooltipText():String
        {
            return d_tooltipText;
        }
        
        /*!
        \brief
        Return the current ID assigned to this tree item.
        
        Note that the system does not make use of this value, client code can
        assign any meaning it wishes to the ID.
        
        \return
        ID code currently assigned to this tree item
        */
        public function getID():uint
        {
            return d_itemID;
        }
        
        /*!
        \brief
        Return the pointer to any client assigned user data attached to this
        tree item.
        
        Note that the system does not make use of this data, client code can
        assign any meaning it wishes to the attached data.
        
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
        - true if the item is selected.
        - false if the item is not selected.
        */
        public function isSelected():Boolean
        {
            return d_selected;
        }
        
        /*!
        \brief
        return whether this item is disabled.
        
        \return
        - true if the item is disabled.
        - false if the item is enabled.
        */
        public function isDisabled():Boolean
        {
            return d_disabled;
        }
        
        /*!
        \brief
        return whether this item will be automatically deleted when it is
        removed from the tree or when the the tree it is attached to is
        destroyed.
        
        \return
        - true if the item object will be deleted by the system when it is
        removed from the tree, or when the tree it is attached to is
        destroyed.
        - false if client code must destroy the item after it is removed from
        the tree.
        */
        public function isAutoDeleted():Boolean
        {
            return d_autoDelete;
        }
        
        /*!
        \brief
        Get the owner window for this TreeItem.
        
        The owner of a TreeItem is typically set by the tree widget when an
        item is added or inserted.
        
        \return
        Ponter to the window that is considered the owner of this TreeItem.
        */
        public function getOwnerWindow():FlameWindow
        {
            return d_owner;
        }
            
        /*!
        \brief
        Return the current colours used for selection highlighting.
        
        \return
        ColourRect object describing the currently set colours.
        */
        public function  getSelectionColours():ColourRect
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
        set the text string for this tree item.
        
        Note that even if the item does not render text, the text string can
        still be useful, since it is used for sorting tree items.
        
        \param text
        String object containing the text to set for the tree item.
        
        \return
        Nothing.
        */
        public function setText(text:String):void
        {
            d_textLogical = text;
            //d_bidiDataValid = false;
            d_renderedStringValid = false;
        }
        
        /*!
        \brief
        Set the tooltip text to be used for this item.
        
        \param text
        String object holding the text to be used in the tooltip displayed for
        this item.
        
        \return
        Nothing.
        */
        public function setTooltipText(text:String):void
        {
            d_tooltipText = text;
        }
        
        /*!
        \brief
        Set the ID assigned to this tree item.
        
        Note that the system does not make use of this value, client code can
        assign any meaning it wishes to the ID.
        
        \param item_id
        ID code to be assigned to this tree item
        
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
        
        Note that the system does not make use of this data, client code can
        assign any meaning it wishes to the attached data.
        
        \param item_data
        Pointer to the user data to attach to this tree item.
        
        \return
        Nothing.
        */
        public function setUserData(item_data:*):void
        {
            d_itemData = item_data;
        }
        
        /*!
        \brief
        Set the selected state for the item.
        
        \param setting
        - true if the item is selected.
        - false if the item is not selected.
        
        \return
        Nothing.
        */
        public function setSelected(setting:Boolean):void
        {
            d_selected = setting;
        }
        
        /*!
        \brief
        Set the disabled state for the item.
        
        \param setting
        - true if the item should be disabled.
        - false if the item should be enabled.
        
        \return
        Nothing.
        */
        public function setDisabled(setting:Boolean):void
        {
            d_disabled = setting;
        }
        
        /*!
        \brief
        Set whether this item will be automatically deleted when it is removed
        from the tree, or when the tree it is attached to is destroyed.
        
        \param setting
        - true if the item object should be deleted by the system when the it
        is removed from the tree, or when the tree it is attached to is
        destroyed.
        - false if client code will destroy the item after it is removed from
        the tree.
        
        \return
        Nothing.
        */
        public function setAutoDeleted(setting:Boolean):void
        {
            d_autoDelete = setting;
        }
        
        /*!
        \brief
        Set the owner window for this TreeItem.  This is called by the tree
        widget when an item is added or inserted.
        
        \param owner
        Ponter to the window that should be considered the owner of this
        TreeItem.
        
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
        Colour (as ARGB value) to be applied to the top-left corner of the
        selection area.
        
        \param top_right_colour
        Colour (as ARGB value) to be applied to the top-right corner of the
        selection area.
        
        \param bottom_left_colour
        Colour (as ARGB value) to be applied to the bottom-left corner of the
        selection area.
        
        \param bottom_right_colour
        Colour (as ARGB value) to be applied to the bottom-right corner of the
        selection area.
        
        \return
        Nothing.
        */
        public function setSelectionColours4(top_left_colour:Colour,
             top_right_colour:Colour,
             bottom_left_colour:Colour,
             bottom_right_colour:Colour):void
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
        Name of the image to be used.
        
        \return
        Nothing.
        */
        public function setSelectionBrushImageFromImageSet(imageset:String, image:String):void
        {
            setSelectionBrushImage(
                FlameImageSetManager.getSingleton().getImageSet(imageset).getImage(image));
        }
        
        /*!
        \brief
        Tell the treeItem where its button is located.
        Calculated and set in Tree.cpp.
        
        \param buttonOffset
        Location of the button in screenspace.
        */
        public function setButtonLocation(buttonOffset:Rect):void
        {
            d_buttonLocation = buttonOffset;
        }
        
        public function getButtonLocation():Rect
        {
            return d_buttonLocation;
        }
            
        public function getIsOpen():Boolean
        {
             return d_isOpen;
        }
        
        public function toggleIsOpen():void
        {
            d_isOpen = !d_isOpen;
        }
        
        public function getTreeItemFromIndex(itemIndex:uint):FlameTreeItem
        {
            if (itemIndex > d_listItems.length)
                return null;
            
            return d_listItems[itemIndex];
        }
        
        public function getItemCount():uint
        {
            return d_listItems.length;
        }
        
        public function getItemList():Vector.<FlameTreeItem>
        {
            return d_listItems;
        }
            
        public function addItem(item:FlameTreeItem):void
        {
            if (item != null)
            {
                var parentWindow:FlameTree = getOwnerWindow() as FlameTree;
                
                // establish ownership
                item.setOwnerWindow(parentWindow);
                
                // if sorting is enabled, re-sort the tree
                if (parentWindow.isSortEnabled())
                {
                    d_listItems.push(item);
                    d_listItems.sort(lbi_less);
                }
                // not sorted, just stick it on the end.
                else
                {
                    d_listItems.push(item);
                }
                
                var args:WindowEventArgs = new WindowEventArgs(parentWindow);
                parentWindow.onListContentsChanged(args);
            }
        }
        
        public function removeItem(item:FlameTreeItem):void
        {
            if (item)
            {
                var parentWindow:FlameTree = getOwnerWindow() as FlameTree;
                
                var pos:int = d_listItems.indexOf(item);
                if (pos != -1)
                {
                    item.setOwnerWindow(null);
                    d_listItems.splice(pos, 1);
                    
                    if (item == parentWindow.d_lastSelected)
                        parentWindow.d_lastSelected = null;
                    
                    if (item.isAutoDeleted())
                        item = null;
                    
                    var args:WindowEventArgs = new WindowEventArgs(parentWindow);
                    parentWindow.onListContentsChanged(args);
                }
            }
        }
        
        public function setIcon(theIcon:FlameImage):void
        {
            d_iconImage = theIcon;
        }
        
        /*************************************************************************
         Abstract portion of interface
         *************************************************************************/
        /*!
        \brief
        Return the rendered pixel size of this tree item.
        
        \return
        Size object describing the size of the tree item in pixels.
        */
        public function getPixelSize():Size
        {
            var fnt:FlameFont = getFont();
            
            if (!fnt)
                return new Size(0, 0);

            //todo
            if (!d_renderedStringValid)
                parseTextString();
            
            var sz:Size = new Size(0.0, 0.0);
            
            for (var i:uint = 0; i < d_renderedString.getLineCount(); ++i)
            {
                const line_sz:Size = d_renderedString.getPixelSize(i);
                sz.d_height += line_sz.d_height;
                
                if (line_sz.d_width > sz.d_width)
                    sz.d_width = line_sz.d_width;
            }
            
            return sz;
        }
        
        /*!
        \brief
        Draw the tree item in its current state
        
        \param position
        Vector2 object describing the upper-left corner of area that should be
        rendered in to for the draw operation.
        
        \param alpha
        Alpha value to be used when rendering the item (between 0.0f and 1.0f).
        
        \param clipper
        Rect object describing the clipping rectangle for the draw operation.
        
        \return
        Nothing.
        */
        public function draw(buffer:FlameGeometryBuffer, targetRect:Rect,
                alpha:Number, clipper:Rect):void
        {
            var finalRect:Rect = targetRect;
            
            if (d_iconImage != null)
            {
                var finalPos:Rect = finalRect;
                finalPos.setWidth(targetRect.getHeight());
                finalPos.setHeight(targetRect.getHeight());
                var col:Colour = new Colour(1,1,1,alpha);
                d_iconImage.draw2(buffer, finalPos, clipper,
                    new ColourRect(col, col, col, col));
                finalRect.d_left += targetRect.getHeight();
            }
            
            if (d_selected && d_selectBrush != null)
                d_selectBrush.draw2(buffer, finalRect, clipper,
                    getModulateAlphaColourRect(d_selectCols, alpha));
            
            var font:FlameFont = getFont();
            
            if (!font)
                return;
            
            var draw_pos:Vector2 = finalRect.getPosition();
            //draw_pos.d_y -= (font.getLineSpacing() - font.getBaseline()) * 0.5;
            
            if (!d_renderedStringValid)
                parseTextString();
            
            const final_colours:ColourRect =
                getModulateAlphaColourRect(new ColourRect(), alpha);
            
            for (var i:uint = 0; i < d_renderedString.getLineCount(); ++i)
            {
                d_renderedString.draw(i, buffer, draw_pos, final_colours, clipper, 0.0);
                draw_pos.d_y += d_renderedString.getPixelSize(i).d_height;
            }
        }
        
        /*************************************************************************
         Operators
         *************************************************************************/
        /*!
        \brief
        Less-than operator, compares item texts.
        */
//        virtual bool operator<(const TreeItem& rhs) const
//        { return getText() < rhs.getText(); }
        
        /*!
        \brief
        Greater-than operator, compares item texts.
        */
//        virtual bool operator>(const TreeItem& rhs) const
//        { return getText() > rhs.getText(); }
        
        
        /*************************************************************************
         Implementation methods
         *************************************************************************/
        /*!
        \brief
        Return a ColourRect object describing the colours in \a cols after
        having their alpha component modulated by the value \a alpha.
        */
        protected function getModulateAlphaColourRect(cols:ColourRect, alpha:Number) : ColourRect
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
        Return a colour value describing the colour specified by \a col after
        having its alpha component modulated by the value \a alpha.
        */
        protected function calculateModulatedAlphaColour(col:Colour, alpha:Number):Colour
        {
            return new Colour(col.d_red, col.d_green, col.d_blue, alpha);
        }
        
        //! parse the text visual string into a RenderString representation.
        protected function parseTextString():void
        {
            d_renderedString =
                d_stringParser.parse(getTextVisual(), getFont(), d_textCols);
            d_renderedStringValid = true;
        }
        
        /*!
        \brief
        Helper function used in sorting to compare two tree item text strings
        via the TreeItem pointers and return if \a a is less than \a b.
        */
        private function lbi_less(a:FlameTreeItem, b:FlameTreeItem):int
        {
            return (a.getText() < b.getText()) ? 1 : -1;
        }
        
        
        /*!
        \brief
        Helper function used in sorting to compare two tree item text strings
        via the TreeItem pointers and return if \a a is greater than \a b.
        */
        private function lbi_greater(a:FlameTreeItem, b:FlameTreeItem):int
        {
            return (a.getText() > b.getText()) ? 1 : -1;
        }

    }
    
}