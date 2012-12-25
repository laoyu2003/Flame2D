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
package Flame2D.core.system
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.events.RenderQueueEventArgs;
    import Flame2D.renderer.FlameGeometryBuffer;
    import Flame2D.renderer.FlameRenderTarget;
    import Flame2D.renderer.FlameTextureTarget;
    
    import flash.utils.Dictionary;

    /*!
    \brief
    Class that represents a surface that can have geometry based imagery drawn
    to it.
    
    A RenderingSurface has a number of queues that can be used for rendering;
    normal window rendering will typically be done on RQ_BASE queue, things that
    are overlaid everything else are rendered to RQ_OVERLAY.
    \par
    The event EventRenderQueueStarted is fired before each queue is rendered and
    the event EventRenderQueueEnded is fired after each queue is rendered.
    \note
    For performance reasons, events are only fired for queues that are in use;
    these are queues that have had some interaction - such as clearing or adding
    geometry.
    */
    
    

    public class FlameRenderingSurface extends FlameEventSet
    {
        //! Namespace for global events from RenderingSurface objects.
        public static var EventNamespace:String = "RenderingSurface";
        /** Event fired when rendering of a RenderQueue begins for the
         * RenderingSurface.
         * Handlers are passed a const RenderQueueEventArgs reference with
         * RenderQueueEventArgs::queueID set to one of the ::RenderQueueID
         * enumerated values indicating the queue that is about to start
         * rendering.
         */
        public static var EventRenderQueueStarted:String = "RenderQueueStarted";
        /** Event fired when rendering of a RenderQueue completes for the
         * RenderingSurface.
         * Handlers are passed a const RenderQueueEventArgs reference with
         * RenderQueueEventArgs::queueID set to one of the ::RenderQueueID
         * enumerated values indicating the queue that has completed rendering.
         */
        public static var EventRenderQueueEnded:String = "RenderQueueEnded";
        
        
        //! collection type for the queues
        //typedef std::map<RenderQueueID, RenderQueue> RenderQueueList;
        //! collection type for created RenderingWindow objects
        //typedef std::vector<RenderingWindow*> RenderingWindowList;
        //! the collection of RenderQueue objects.
        //RenderQueueList d_queues;
        //! collection of RenderingWindow object we own
        //RenderingWindowList d_windows;
        //! RenderTarget that this surface actually draws to.
        //RenderTarget& d_target;
        //! holds invalidated state of target (as far as we are concerned)
        protected var d_queues:Vector.<FlameRenderQueue> = new Vector.<FlameRenderQueue>(11);
        
        protected var d_windows:Vector.<FlameRenderingWindow> = new Vector.<FlameRenderingWindow>();
        
        protected var d_target:FlameRenderTarget;
        
        protected var d_invalidated:Boolean = true;

        /*!
        \brief
        Constructor for RenderingSurface objects.
        
        \param target
        RenderTarget object that will receive rendered output from the
        RenderingSurface being created.
        
        \note
        The RenderingSurface does not take ownership of \a target.  When the
        RenderingSurface is finally destroyed, the RenderTarget will not have
        been destroyed, and it should be destoyed by whover created it, if that
        is desired.  One reason for this is that there is not an exclusive one
        to one mapping from RenderingSurface to RenderTarget objects; it's
        entirely feasable that multiple RenderingSurface objects could be
        targetting a shared RenderTarget).
        */
        public function FlameRenderingSurface(target:FlameRenderTarget)
        {
            d_target = target;
            
            //init render queue
            for(var i:uint = 0; i< d_queues.length; i++)
            {
                d_queues[i] = new FlameRenderQueue();
            }
        }
        
        /*!
        \brief
        Add the specified GeometryBuffer to the specified queue for rendering
        when the RenderingSurface is drawn.
        
        \param queue
        One of the RenderQueueID enumerated values indicating which prioritised
        queue the GeometryBuffer should be added to.
        
        \param buffer
        GeometryBuffer object to be added to the specified rendering queue.
        
        \note
        The RenderingSurface does not take ownership of the GeometryBuffer, and
        does not destroy it when the RenderingSurface geometry is cleared.
        Rather, the RenderingSurface is just maintaining a list of thigs to be
        drawn; the actual GeometryBuffers can be re-used by whichever object
        \e does own them, and even changed or updated while still "attached" to
        a RenderingSurface.
        */
        public function addGeometryBuffer(queue:uint, buffer:FlameGeometryBuffer):void
        {
            d_queues[queue].addGeometryBuffer(buffer);
        }
        
        /*!
        \brief
        Remove the specified GeometryBuffer from the specified queue.
        
        \param queue
        One of the RenderQueueID enumerated values indicating which prioritised
        queue the GeometryBuffer should be removed from.
        
        \param buffer
        GeometryBuffer object to be removed from the specified rendering queue.
        */
        public function removeGeometryBuffer(queue:uint, buffer:FlameGeometryBuffer):void
        {
            d_queues[queue].removeGeometryBuffer(buffer);
        }
        
        /*!
        \brief
        Clears all GeometryBuffers from the specified rendering queue.
        
        \param queue
        One of the RenderQueueID enumerated values indicating which prioritised
        queue is to to be cleared.
        
        \note
        Clearing a rendering queue does destory the attached GeometryBuffers,
        which remain under thier original ownership.
        */
        public function clearGeometry(queue:uint):void
        {
            d_queues[queue].reset();
        }
        
        /*!
        \brief
        Clears all GeometryBuffers from all rendering queues.
        
        \note
        Clearing the rendering queues does destory the attached GeometryBuffers,
        which remain under thier original ownership.
        */
        public function clearAllGeometry():void
        {
            for(var i:uint=0; i<d_queues.length; i++)
            {
                d_queues[i].reset();
            }
        }
        
        /*!
        \brief
        Draw the GeometryBuffers for all rendering queues to the RenderTarget
        that this RenderingSurface is targetting.
        
        The GeometryBuffers remain in the rendering queues after the draw
        operation is complete.  This allows the next draw operation to occur
        without needing to requeue all the GeometryBuffers (if for instance the
        sequence of buffers to be drawn remains unchanged).
        */
        public function drawAll():void
        {
            
            //trace("active target:" + d_target.getArea().toString());
            d_target.activate();
            
            for(var i:uint=0; i<d_queues.length; i++)
            {
                var evt_args:RenderQueueEventArgs = new RenderQueueEventArgs(Consts.RenderQueueID_RQ_USER_0);
                evt_args.handled = 0;
                evt_args.queueID = i;
                draw(d_queues[i], evt_args);
            }
            
            d_target.deactivate();
            //trace("deactive target:" + d_target.getArea().toString());
        }
        

        
        /*!
        \brief
        Marks the RenderingSurface as invalid, causing the geometry to be
        rerendered to the RenderTarget next time draw is called.
        
        \brief
        Note that some surface types can never be in a 'valid' state and so
        rerendering occurs whenever draw is called.  This function mainly exists
        as a means to hint to other surface types - those that physically cache
        the rendered output - that geometry content has changed and the cached
        imagery should be cleared and redrawn.
        */
        public function invalidate():void
        {
            d_invalidated = true;
        }
        
        /*!
        \brief
        Return whether this RenderingSurface is invalidated.
        
        \return
        - true to indicate the RenderingSurface is invalidated and will be
        rerendered the next time the draw member function is called.
        - false to indicate the RenderingSurface is valid, and will not be
        rerendered the next time the draw member function is called, since it's
        cached imagery is up-to-date.
        
        \brief
        Note that some surface types can never be in a 'valid' state and so
        will always return true.
        */
        public function isInvalidated():Boolean
        {
            return d_invalidated || !d_target.isImageryCache();
        }
        
        /*!
        \brief
        Return whether this RenderingSurface is actually an instance of the
        RenderingWindow subclass.
        
        \return
        - true to indicate the RenderingSurface is a RenderingWindow instance.
        - false to indicate the RenderingSurface is not a RenderingWindow.
        */
        public function isRenderingWindow():Boolean
        {
            return false;
        }
        
        /*!
        \brief
        Create and return a reference to a child RenderingWindow object that
        will render back onto this RenderingSurface when it's draw member
        function is called.
        
        The RenderingWindow returned is initially owned by the RenderingSurface
        that created it.
        
        \param target
        TextureTarget object that will receive rendered output from the
        RenderingWindow being creatd.
        
        \return
        Reference to a RenderingWindow object.
        
        \note
        Since RenderingWindow is a RenderingSurface, the same note from the
        constructor applies here, and that is the passed in TextureTarget
        remains under the ownership of whichever part of the system created
        it.
        */
        public function createRenderingWindow(target:FlameTextureTarget):FlameRenderingWindow
        {
            var w:FlameRenderingWindow = new FlameRenderingWindow(target, this);
            
            attachWindow(w);
            
            return w;
        }
        
        /*!
        \brief
        Destroy a RenderingWindow we own.  If we are not the present owner of
        the given RenderingWindow, nothing happens.
        
        \param window
        RenderingWindow object that is to be destroyed.
        
        \note
        Destroying a RenderingWindow will not also destroy the TextureTarget
        that was given when the RenderingWindow was created.  The TextureTarget
        should be destoyed elsewhere.
        */
        public function destroyRenderingWindow(window:FlameRenderingWindow):void
        {
            if (window.getOwner() == this)
            {
                detatchWindow(window);
                
                window = null;
            }
        }
        
        //! transfer ownership of the RenderingWindow to this RenderingSurface.
        /*!
        \brief
        Transfer ownership of the given RenderingWindow to this
        RenderingSurface.  The result is \e generally the same as if this
        RenderingSurface had created the RenderingWindow in the first place.
        
        \param window
        RenderingWindow object that this RenderingSurface is to take ownership
        of.
        */
        public function transferRenderingWindow(window:FlameRenderingWindow):void
        {
            if (window.getOwner() != this)
            {
                // detach window from it's current owner
                window.getOwner().detatchWindow(window);
                // add window to this surface.
                attachWindow(window);
                
                window.setOwner(this);
            }
        }
        
        /*!
        \brief
        Return the RenderTarget object that this RenderingSurface is drawing
        to.
        
        \return
        RenderTarget object that the RenderingSurface is using to draw it's
        output.
        */
        public function getRenderTarget():FlameRenderTarget
        {
            //return (this as FlameRenderingSurface).getRenderTarget();
            return d_target;
        }
        
        //! draw a rendering queue, firing events before and after.
        //----------------------------------------------------------------------------//
        public function draw(queue:FlameRenderQueue, args:RenderQueueEventArgs):void
        {
            fireEvent(EventRenderQueueStarted, args, EventNamespace);
            
            d_target.drawQueue(queue);
            
            args.handled = 0;
            //fireEvent(EventRenderQueueEnded, args, EventNamespace);
        }
        
        //! detatch ReneringWindow from this RenderingSurface
        protected function detatchWindow(w:FlameRenderingWindow):void
        {
            var idx:int = d_windows.indexOf(w);
            if(idx != -1)
            {
                d_windows.splice(idx, 1);
                invalidate();
            }
        }
        
        //! attach ReneringWindow from this RenderingSurface
        protected function attachWindow(w:FlameRenderingWindow):void
        {
            d_windows.push(w);
            invalidate();
        }
        
    }
}