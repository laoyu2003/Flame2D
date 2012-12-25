
package Flame2D.core.text
{
    import Flame2D.core.data.LineInfo;
    import Flame2D.core.utils.ColourRect;
    import Flame2D.core.utils.Rect;
    import Flame2D.core.utils.Size;
    import Flame2D.core.utils.Vector2;
    import Flame2D.renderer.FlameGeometryBuffer;

    /*!
    \brief
    Class representing a rendered string of entities.
    
    Here 'string' does not refer solely to a text string, rather a string of
    any renderable items.
    */
    public class FlameRenderedString
    {
        
        //! Collection type used to hold the string components.
        //typedef std::vector<RenderedStringComponent*> ComponentList;
        //! RenderedStringComponent objects that comprise this RenderedString.
        //ComponentList d_components;
        protected var d_components:Vector.<FlameRenderedStringComponent> = new Vector.<FlameRenderedStringComponent>();
        //! track info for a line.  first is componetn idx, second is component count.
        //typedef std::pair<size_t, size_t> LineInfo;
        //! Collection type used to hold details about the lines.
        //typedef std::vector<LineInfo> LineList;
        //! lines that make up this string.
        protected var d_lines:Vector.<LineInfo> = new Vector.<LineInfo>();

        
        public function FlameRenderedString()
        {
            // set up initial line info
            appendLineBreak();
        }
        
        //! Make this object's component list a clone of \a list.
//        public function cloneComponentList(list:Vector.<FlameRenderedStringComponent>):void
//        {
//            clearComponentList(d_components);
//            
//            for (var i:uint = 0; i < list.length; ++i)
//                d_components.push(list[i].clone());    
//        }
        
        //! Free components in the given ComponentList and clear the list.
        public static function clearComponentList(list:Vector.<FlameRenderedStringComponent>):void
        {
//            for (var i:uint = 0; i < list.length; ++i)
//                delete list[i];
//            
//            list.clear();
            list.length = 0;
        }
        
        /*!
        \brief
        Draw the string to a GeometryBuffer.
        
        \param line
        The line of the RenderedString to draw.
        
        \param buffer
        GeometryBuffer object that is to receive the geometry resulting from the
        draw operations.
        
        \param position
        Vector2 describing the position where the RenderedString is to be drawn.
        Note that this is not the final onscreen position, but the position as
        offset from the top-left corner of the entity represented by the
        GeometryBuffer.
        
        \param mod_colours
        Pointer to a ColourRect describing colour values that are to be
        modulated with the any stored colour values to calculate the final
        colour values to be used.  This may be 0 if no modulated colours are
        required.  NB: Each specific component will decide if and how it will
        apply the modulated colours.
        
        \param clip_rect
        Pointer to a Rect object that describes a clipping rectangle that should
        be used when drawing the RenderedString.  This may be 0 if no clipping
        is required.
        
        \param space_extra
        float value indicating additional padding value to be applied to space
        characters in the string.
        
        \exception InvalidRequestException
        thrown if \a line is out of range.
        */
        public function draw(line:uint, buffer:FlameGeometryBuffer, position:Vector2,
            mod_colours:ColourRect, clip_rect:Rect, space_extra:Number):void
        {
            if (line >= getLineCount())
                throw new Error("RenderedString::draw: line number specified is invalid.");
            
            const render_height:Number = getPixelSize(line).d_height;
            
            var comp_pos:Vector2 = position.clone();
            
            const end_component:uint = d_lines[line].id + d_lines[line].count;
            for (var i:uint = d_lines[line].id; i < end_component; ++i)
            {
                d_components[i].draw(buffer, comp_pos, mod_colours, clip_rect,
                    render_height, space_extra);
                comp_pos.d_x += d_components[i].getPixelSize().d_width;
            }
        }
        
        //! return the pixel size of the specified line.
        /*!
        \brief
        Return the pixel size of a specified line for the RenderedString.
        
        \param line
        The line number whose size is to be returned.
        
        \return
        Size object describing the size of the rendered output of the specified
        line of this RenderedString, in pixels.
        
        \exception InvalidRequestException
        thrown if \a line is out of range.
        */
        public function getPixelSize(line:uint):Size
        {
            if (line >= getLineCount())
                throw new Error("RenderedString::getPixelSize: line number specified is invalid.");
            
            var sz:Size = new Size(0, 0);
            
            const end_component:uint = d_lines[line].id + d_lines[line].count;
            for (var i:uint = d_lines[line].id; i < end_component; ++i)
            {
                const comp_sz:Size = d_components[i].getPixelSize();
                sz.d_width += comp_sz.d_width;
                
                if (comp_sz.d_height > sz.d_height)
                    sz.d_height = comp_sz.d_height;
            }
            
            return sz;
        }
        
        //! append \a component to the list of components drawn for this string.
        public function appendComponent(component:FlameRenderedStringComponent):void
        {
            d_components.push(component.clone());
            ++d_lines[d_lines.length-1].count;
        }
        
        //! clear the list of components drawn for this string.
        public function clearComponents():void
        {
            clearComponentList(d_components);
            d_lines.length = 0;
        }
        
        //! return the number of components that make up this string.
        public function getComponentCount():uint
        {
            return d_components.length;
        }
        
        /*!
        \brief
        split the string in line \a line as close to \a split_point as possible.
        
        The RenderedString \a left will receive the left portion of the split,
        while the right portion of the split will remain in this RenderedString.
        
        \param line
        The line number on which the split is to occur.
        
        \param split_point
        float value specifying the pixel location where the split should occur.
        The actual split will occur as close to this point as possible, though
        preferring a shorter 'left' portion when the split can not be made
        exactly at the requested point.
        
        \param left
        RenderedString object that will receieve the left portion of the split.
        Any existing content in the RenderedString is replaced.
        
        \exception InvalidRequestException
        thrown if \a line is out of range.
        */
        public function split(line:uint, split_point:Number, left:FlameRenderedString):void
        {
            // FIXME: This function is big and nasty; it breaks all the rules for a
            // 'good' function and desperately needs some refactoring work done to it.
            // On the plus side, it does seem to work though ;)
            
            if (line >= getLineCount())
                throw new Error("RenderedString::split: line number specified is invalid.");
            
            left.clearComponents();
            
            if (d_components.length == 0)
                return;
            
            // move all components in lines prior to the line being split to the left
            if (line > 0)
            {
                // calculate size of range
                var sz:uint = d_lines[line - 1].id + d_lines[line - 1].count;
//                // range start
//                ComponentList::iterator cb = d_components.begin();
//                // range end (exclusive)
//                ComponentList::iterator ce = cb + sz;
//                // copy components to left side
//                left.d_components.assign(cb, ce);

                //to be checked
                left.d_components = d_components.slice(0, sz);
                // erase components from this side.
                //d_components.erase(cb, ce);
                d_components.splice(0, sz);
                
//                LineList::iterator lb = d_lines.begin();
//                LineList::iterator le = lb + line;
//                // copy lines to left side
//                left.d_lines.assign(lb, le);
                left.d_lines = d_lines.slice(0, line);
                // erase lines from this side
//                d_lines.erase(lb, le);
                d_lines.splice(0, line);
            }
            
            // find the component where the requested split point lies.
            var partial_extent:Number = 0;
            
            var idx:uint = 0;
            const last_component:uint = d_lines[0].count;
            for (; idx < last_component; ++idx)
            {
                partial_extent += d_components[idx].getPixelSize().d_width;
                
                if (split_point <= partial_extent)
                    break;
            }
            
            // case where split point is past the end
            if (idx >= last_component)
            {
                // transfer this line's components to the 'left' string.
                //
                // calculate size of range
                sz = d_lines[0].count;
//                // range start
//                ComponentList::iterator cb = d_components.begin();
//                // range end (exclusive)
//                ComponentList::iterator ce = cb + sz;
//                // copy components to left side
//                left.d_components.insert(left.d_components.end(), cb, ce);
                left.d_components.push(d_components.slice(0, sz));
                // erase components from this side.
//                d_components.erase(cb, ce);
                d_components.splice(0, sz);
                
                // copy line info to left side
                left.d_lines.push(d_lines[0]);
                // erase line from this side
                //d_lines.erase(d_lines.begin());
                d_lines.splice(0, 1);
                // fix up lines in this object
                for (var comp:uint = 0, i:uint=0; i < d_lines.length; ++i)
                {
                    d_lines[i].id = comp;
                    comp += d_lines[i].count;
                }
                
                return;
            }
            
            left.appendLineBreak();
            const left_line:uint = left.getLineCount() - 1;
            // Everything up to 'idx' is xfered to 'left'
            for (i = 0; i < idx; ++i)
            {
                left.d_components.push(d_components[0]);
                //d_components.erase(d_components.begin());
                d_components.splice(0, 1);
                ++left.d_lines[left_line].count;
                --d_lines[0].count;
            }
            
            // now to split item 'idx' putting half in left and leaving half in this.
            var c:FlameRenderedStringComponent = d_components[0];
            if (c.canSplit())
            {
                var lc:FlameRenderedStringComponent = 
                    c.split(split_point - (partial_extent - c.getPixelSize().d_width),
                        idx == 0);
                
                if (lc)
                {
                    left.d_components.push(lc);
                    ++left.d_lines[left_line].count;
                }
            }
            // can't split, if component width is >= split_point xfer the whole
            // component to it's own line in the left part (FIX #306)
            else if (c.getPixelSize().d_width >= split_point)
            {
                left.appendLineBreak();
                left.d_components.push(d_components[0]);
                //d_components.erase(d_components.begin());
                d_components.splice(0, 1);
                ++left.d_lines[left_line + 1].count;
                --d_lines[0].count;
            }
            
            // fix up lines in this object
            for (comp = 0, i = 0; i < d_lines.length; ++i)
            {
                d_lines[i].id = comp;
                comp += d_lines[i].count;
            }
        }
        
        //! return the total number of spacing characters in the specified line.
        public function getSpaceCount(line:uint):uint
        {
            if (line >= getLineCount())
                throw new Error("RenderedString::getSpaceCount: " +
                    "line number specified is invalid.");
            
            var space_count:uint = 0;
            
            const end_component:uint = d_lines[line].id + d_lines[line].count;
            for (var i:uint = d_lines[line].id; i < end_component; ++i)
                space_count += d_components[i].getSpaceCount();
            
            return space_count;
        }
        
        //! linebreak the rendered string at the present position.
        public function appendLineBreak():void
        {
            const first_component:uint = d_lines.length==0 ? 0 :
                d_lines[d_lines.length-1].id + d_lines[d_lines.length-1].count;
            
            d_lines.push(new LineInfo(first_component, 0));
        }
        
        //! return number of lines in this string.
        public function getLineCount():uint
        {
            return d_lines.length;
        }
        
 //       RenderedString& operator=(const RenderedString& rhs);

    }
}