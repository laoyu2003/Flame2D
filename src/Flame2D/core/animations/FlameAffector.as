

package Flame2D.core.animations
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.properties.FlamePropertySet;
    import Flame2D.core.system.FlameAnimationManager;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.utils.Misc;
    
    import flash.utils.Dictionary;

    /*!
    \brief
    Defines an 'affector' class
    
    Affector is part of Animation definition. It is set to affect
    one Property using one Interpolator.
    
    \todo
    moveKeyFrame, this will be vital for any animation editing tools
    */
    public class FlameAffector
    {
        // Internal strings for the XML enumeration for progression types.
        private static const ProgressionLinear:String = "linear";
        private static const ProgressionDiscrete:String = "discrete";
        private static const ProgressionQuadraticAccelerating:String = "quadratic accelerating";
        private static const ProgressionQuadraticDecelerating:String = "quadratic decelerating";
        
        //! parent animation definition
        private var d_parent:FlameAnimation;
        //! application method
        private var d_applicationMethod:uint = Consts.ApplicationMethod_AM_Absolute;
        //! property that gets affected by this affector
        private var d_targetProperty:String = "";
        //! curently used interpolator (has to be set for the Affector to work!)
        private var d_interpolator:Interpolator = null;
        
        //typedef std::map<float, KeyFrame*> KeyFrameMap;
        /** keyframes of this affector (if there are no keyframes, this affector
         * won't do anything!)
         */
        //KeyFrameMap d_keyFrames;
        private var d_keyFrames:Vector.<FlameKeyFrame> = new Vector.<FlameKeyFrame>();
        
        /** internal constructor, please construct Affectors via
         * Animation::createAffector only
         */
        public function FlameAffector(parent:FlameAnimation)
        {
            d_parent = parent;
        }
        
        public function parseXML(xml:XML):void
        {
            var nodes:XMLList = xml.KeyFrame;
            var node:XML;
            
            for each(node in nodes)
            {
                var progressionStr:String = node.@progression.toString();
                var position:Number = Number(node.@position.toString());
                var value:String = node.@value.toString();
                var sourceProperty:String = node.@sourceProperty.toString();

                if (progressionStr.length != 0)
                    trace("  Progression: " + progressionStr);
            
                var progression:uint;
                if (progressionStr == ProgressionDiscrete)
                    progression = Consts.Progression_P_Discrete;
                else if (progressionStr == ProgressionQuadraticAccelerating)
                    progression = Consts.Progression_P_QuadraticAccelerating;
                else if (progressionStr == ProgressionQuadraticDecelerating)
                    progression = Consts.Progression_P_QuadraticDecelerating;
                else
                    progression = Consts.Progression_P_Linear;
                
                var keyframe:FlameKeyFrame = createKeyFrame2(position, value, progression, sourceProperty);
                
                if (getNumKeyFrames() == 1 && progressionStr.length != 0)
                    trace(
                        "WARNING: progression type specified for first keyframe in " +
                        "animation will be ignored.");
                
                d_keyFrames.push(keyframe);
            }
        }
                                 
        /*!
        \brief
        Sets the application method
        
        \par
        Values can be applied in 2 ways - as absolute values or relative to base
        value that is retrieved and saved after animation is started
        */
        public function setApplicationMethod(method:uint):void
        {
            d_applicationMethod = method;
        }
        
        /*!
        \brief
        Retrieves current application method
        
        \see
        Affector::setApplicationMethod
        */
        public function getApplicationMethod():uint
        {
            return d_applicationMethod;
        }
        
        /*!
        \brief
        Sets the property that will be affected
        */
        public function setTargetProperty(target:String):void
        {
            d_targetProperty = target;
        }
        
        /*!
        \brief
        Gets the property that will be affected
        */
        public function getTargetProperty():String
        {
            return d_targetProperty;
        }
        
        /*!
        \brief
        Sets interpolator of this Affector
        
        \par
        Interpolator has to be set for the Affector to work!
        */
        public function setInterpolator(interpolator:Interpolator):void
        {
            d_interpolator = interpolator;
        }
        
        /*!
        \brief
        Sets interpolator of this Affector
        
        \par
        Interpolator has to be set for the Affector to work!
        */
        public function setInterpolatorByName(name:String):void
        {
            d_interpolator = FlameAnimationManager.getSingleton().getInterpolator(name);
        }
        
        /*!
        \brief
        Retrieves currently used interpolator of this Affector
        */
        public function getInterpolator():Interpolator
        {
            return d_interpolator;
        }
        
        /*!
        \brief
        Creates a KeyFrame at given position
        */
        
        private function positionExist(position:Number):Boolean
        {
            for(var i:uint=0; i<d_keyFrames.length; i++)
            {
                if(d_keyFrames[i].getPosition() == position)
                    return true;
            }
            
            return false;
        }
        
        public function createKeyFrame(position:Number):FlameKeyFrame
        {
            if(positionExist(position))
            {
                throw new Error(
                    "Affector::createKeyFrame: Unable to create KeyFrame " +
                    "at given position, there already is a KeyFrame " +
                    "on that position.");
            }
            
            var ret:FlameKeyFrame = new FlameKeyFrame(this, position);
            d_keyFrames.push(ret);
            d_keyFrames.sort(onSort);
            
            return ret;
        }
        
        private function onSort(a:FlameKeyFrame, b:FlameKeyFrame):int
        {
            return a.getPosition() < b.getPosition() ? -1 : 1;
        }
        
        /*!
        \brief
        Creates a KeyFrame at given position
        
        \par
        This is a helper method, you can set all these values after you create
        the KeyFrame
        */
        public function createKeyFrame2(position:Number, value:String,
            progression:uint = Consts.Progression_P_Linear,
            sourceProperty:String = ""):FlameKeyFrame
        {
            var ret:FlameKeyFrame = createKeyFrame(position);
            ret.setValue(value);
            ret.setProgression(progression);
            ret.setSourceProperty(sourceProperty);
            
            return ret;
        }
        
        /*!
        \brief
        Destroys given keyframe
        */
        public function destroyKeyFrame(keyframe:FlameKeyFrame):void
        {
            var pos:int = d_keyFrames.indexOf(keyframe);
            if(pos == -1)
            {
                throw new Error(
                    "Affector::destroyKeyFrame: Unable to destroy given KeyFrame! " +
                    "No such KeyFrame was found.");
            }
            
            d_keyFrames.splice(pos, 1);
        }
            
        
        /*!
        \brief
        Retrieves a KeyFrame at given position
        */
        public function getKeyFrameAtPosition(position:Number):FlameKeyFrame
        {
            for(var i:uint=0; i< d_keyFrames.length; i++)
            {
                if(d_keyFrames[i].getPosition() == position)
                {
                    return d_keyFrames[i];
                }
            }
            
            throw new Error(
                "Affector::getKeyFrameAtPosition: Can't find a KeyFrame with given " +
                "position.");
        }
        
        private function getIndexAtPosition(position:Number):uint
        {
            for(var i:uint=0; i< d_keyFrames.length; i++)
            {
                if(d_keyFrames[i].getPosition() == position)
                {
                    return i;
                }
            }
            
            throw new Error(
                "Affector::getKeyFrameAtPosition: Can't find a KeyFrame with given " +
                "position.");

        }
        /*!
        \brief
        Retrieves a KeyFrame with given index
        */
        public function getKeyFrameAtIdx(index:uint):FlameKeyFrame
        {
            if (index >= d_keyFrames.length)
            {
                throw new Error(
                    "Affector::getKeyFrameAtIdx: Out of bounds!");
            }
            
            return d_keyFrames[index];
        }
        
        /*!
        \brief
        Returns number of key frames defined in this affector
        */
        public function getNumKeyFrames():uint
        {
            return d_keyFrames.length;
        }
        
        /*!
        \brief
        Moves given key frame to given new position
        */
//        public function moveKeyFrameToPosition(KeyFrame* keyframe, float newPosition):void
//        {
//            moveKeyFrameToPosition(keyframe.getPosition(), newPosition);
//        }
        
        /*!
        \brief
        Moves key frame at given old position to given new position
        */
//        public function moveKeyFrameToPosition2(oldPosition:Number, newPosition:Number):void
//        {
//        }
        
        /*!
        \brief
        Internal method, causes all properties that are used by this affector
        and it's keyframes to be saved
        
        \par
        So their values are still known after
        they've been affected.
        */
        public function savePropertyValues(instance:FlameAnimationInstance):void
        {
            switch (d_applicationMethod)
            {
                case Consts.ApplicationMethod_AM_Relative:
                case Consts.ApplicationMethod_AM_RelativeMultiply:
                    instance.savePropertyValue(d_targetProperty);
                    break;
                
                default:
                    break;
            }
            
            // now let all keyframes save their desired property values too
            for(var i:uint=0; i<d_keyFrames.length; i++)
            {
                d_keyFrames[i].savePropertyValue(instance);
            }
        }
        
        /*!
        \brief
        Applies this Affector's definition with parameters from given
        Animation Instance
        
        \par
        This function is internal so unless you know what you're doing, don't
        touch!
        
        \see
        AnimationInstance
        */
        public function apply(instance:FlameAnimationInstance):void
        {
            var target:FlameWindow = instance.getTarget();
            const position:Number = instance.getPosition();
            
            // special case
            if (d_keyFrames.length == 0)
            {
                return;
            }
            
            if (d_targetProperty.length == 0)
            {
                trace(
                    "Affector can't be applied when target property is set!");
                return;
            }
            
            if (!d_interpolator)
            {
                trace(
                    "Affector can't be applied when no interpolator is set!");
                return;
            }
            
            var left:FlameKeyFrame = null;
            var right:FlameKeyFrame = null;
            
            // find 2 neighbouring keyframes
            for(var i:uint = 0; i<d_keyFrames.length; i++)
            {
                var current:FlameKeyFrame = d_keyFrames[i];
                
                if (current.getPosition() <= position)
                {
                    left = current;
                }
                
                if (current.getPosition() >= position && !right)
                {
                    right = current;
                }
            }
            
            var leftDistance:Number, rightDistance:Number;
            
            if (left)
            {
                leftDistance = position - left.getPosition();
            }
            else
                // if no keyframe is suitable for left neighbour, pick the first one
            {
                left = d_keyFrames[0];
                leftDistance = 0;
            }
            
            if (right)
            {
                rightDistance = right.getPosition() - position;
            }
            else
                // if no keyframe is suitable for the right neighbour, pick the last one
            {
                right = d_keyFrames[d_keyFrames.length-1];
                rightDistance = 0;
            }
            
            // if there is just one keyframe and we are right on it
            if (leftDistance + rightDistance == 0)
            {
                leftDistance = rightDistance = 0.5;
            }
            
            // alter interpolation position using the right neighbours progression
            // method
            const interpolationPosition:Number =
                right.alterInterpolationPosition(
                    leftDistance / (leftDistance + rightDistance));
            
            var base:String;
            var result:String;
            
            // absolute application method
            if (d_applicationMethod == Consts.ApplicationMethod_AM_Absolute)
            {
                result = d_interpolator.interpolateAbsolute(
                    left.getValueForAnimation(instance),
                    right.getValueForAnimation(instance),
                    interpolationPosition);
                
                target.setProperty(d_targetProperty, result);
            }
                // relative application method
            else if (d_applicationMethod == Consts.ApplicationMethod_AM_Relative)
            {
                base = instance.getSavedPropertyValue(getTargetProperty());
                
                result = d_interpolator.interpolateRelative(
                    base,
                    left.getValueForAnimation(instance),
                    right.getValueForAnimation(instance),
                    interpolationPosition);
                
                target.setProperty(d_targetProperty, result);
            }
                // relative multiply application method
            else if (d_applicationMethod == Consts.ApplicationMethod_AM_RelativeMultiply)
            {
                base = instance.getSavedPropertyValue(getTargetProperty());
                
                result = d_interpolator.interpolateRelativeMultiply(
                    base,
                    left.getValueForAnimation(instance),
                    right.getValueForAnimation(instance),
                    interpolationPosition);
                
                target.setProperty(d_targetProperty, result);
            }
                // todo: more application methods?
            else
            {
                Misc.assert(false);
            }
        }
        

    }
}