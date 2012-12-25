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
package Flame2D.elements.progressbar
{
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.events.WindowEventArgs;
    

    /*!
    \brief
    Base class for progress bars.
    */
    public class FlameProgressBar extends FlameWindow
    {
        public static const EventNamespace:String = "ProgressBar";
        public static const WidgetTypeName:String = "CEGUI/ProgressBar";
        
        
        /*************************************************************************
         Event name constants
         *************************************************************************/
        /** Event fired whenever the progress value is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ProgressBar whose value has been
         * changed.
         */
        public static const EventProgressChanged:String = "ProgressChanged";
        /** Event fired when the progress bar's value reaches 100%.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the ProgressBar whose progress value
         * has reached 100%.
         */
        public static const EventProgressDone:String = "ProgressDone";
        
        
        /*************************************************************************
         Static Properties for this class
         *************************************************************************/
        private static var d_currentProgressProperty:ProgressBarPropertyCurrentProgress = new ProgressBarPropertyCurrentProgress();
        private static var d_stepSizeProperty:ProgressBarPropertyStepSize = new ProgressBarPropertyStepSize();

        
        /*************************************************************************
         Implementation Data
         *************************************************************************/
        protected var d_progress:Number = 0.0;		//!< current progress (from 0.0f to 1.0f)
        protected var d_step:Number = 0.01;			//!< amount to 'step' progress by on a call to step()

        
        public function FlameProgressBar(type:String, name:String)
        {
            super(type, name);
            
            addProgressBarProperties();
        }
        
        
        /************************************************************************
         Accessor Functions
         ************************************************************************/
        /*!
        \brief
        return the current progress value
        */
        public function getProgress():Number
        {
            return d_progress;
        }
        
        /*!
        \brief
        return the current step size
        */
        public function getStep():Number
        {
            return d_step;
        }
        
        
        /*************************************************************************
         Manipulator Functions
         *************************************************************************/
        /*!
        \brief
        set the current progress.
        
        \param progress
        The level of progress to set.  If this value is >1.0f (100%) progress will be limited to 1.0f.
        
        \return
        Nothing.
        */
        public function setProgress(progress:Number):void
        {
            // legal progress rangeis : 0.0f <= progress <= 1.0f
            progress = (progress < 0.0) ? 0.0 : (progress > 1.0) ? 1.0 : progress;
            
            if (progress != d_progress)
            {
                // update progress and fire off event.
                d_progress = progress;
                var args:WindowEventArgs = new WindowEventArgs(this);
                onProgressChanged(args);
                
                // if new progress is 100%, fire off the 'done' event as well.
                if (d_progress == 1.0)
                {
                    onProgressDone(args);
                }
                
            }
        }
        
        
        /*!
        \brief
        set the size of the 'step' in percentage points (default is 0.01f or 1%).
        
        \param step
        Amount to increase the progress by each time the step method is called.
        
        \return
        Nothing.
        */
        public function setStepSize(step_val:Number):void
        {
            d_step = step_val;
        }
        
        
        /*!
        \brief
        cause the progress to step
        
        The amount the progress bar will step can be changed by calling the setStepSize method.  The
        default step size is 0.01f which is equal to 1%.
        
        \return
        Nothing.
        */
        public function step():void
        {
            setProgress(d_progress + d_step);
        }
        
        
        /*!
        \brief
        Modify the progress level by a specified delta.
        
        \param delta
        amount to adjust the progress by.  Whatever this value is, the progress of the bar will be kept
        within the range: 0.0f <= progress <= 1.0f.
        
        \return
        Nothing.
        */
        public function adjustProgress(delta:Number):void
        {
            setProgress(d_progress + delta);
        }
        
        

        /*************************************************************************
         Implementation methods
         *************************************************************************/
        /*!
        \brief
        Return whether this window was inherited from the given class name at some point in the inheritance hierarchy.
        
        \param class_name
        The class name that is to be checked.
        
        \return
        true if this window was inherited from \a class_name. false if not.
        */
        override protected function testClassName_impl(class_name:String):Boolean
        {
            if (class_name=="ProgressBar")	return true;
            return super.testClassName_impl(class_name);
        }
        
        
        /*************************************************************************
         Event handlers for progress bar specific events
         *************************************************************************/
        /*!
        \brief
        event triggered when progress changes
        */
        protected function onProgressChanged(e:WindowEventArgs):void
        {
            invalidate();
            
            fireEvent(EventProgressChanged, e, EventNamespace);
        }
        
        
        /*!
        \brief
        event triggered when progress reaches 100%
        */
        protected function onProgressDone(e:WindowEventArgs):void
        {
            fireEvent(EventProgressDone, e, EventNamespace);
        }
        
        
        /*************************************************************************
         add properties defined for this class
         *************************************************************************/
        protected function addProgressBarProperties():void
        {
            addProperty(d_stepSizeProperty);
            addProperty(d_currentProgressProperty);
        }

    }
}