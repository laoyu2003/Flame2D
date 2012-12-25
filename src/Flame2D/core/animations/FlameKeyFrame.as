package Flame2D.core.animations
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.utils.Misc;

    /*!
    \brief
    Defines a 'key frame' class
    
    Key frames are defined inside Affectors. The values they hold are used
    when animation is precisely at the key frame's position. If it's between
    two key frames, the value is interpolated.
    
    \see
    Affector
    */
    public class FlameKeyFrame
    {
        
        //! parent affector
        private var d_parent:FlameAffector;
        //! position of this key frame in the animation's timeline (in seconds)
        private var d_position:Number;
        
        //! value of this key frame - key value
        private var d_value:String;
        //! source property
        private var d_sourceProperty:String;
        //! progression method used towards this key frame
        private var d_progression:uint = Consts.Progression_P_Linear;
        
        
        //! internal constructor, please use Affector::createKeyFrame
        public function FlameKeyFrame(parent:FlameAffector, position:Number)
        {
            d_parent = parent;
            d_position = position;
        }
        
        /*!
        \brief
        Retrieves parent Affector of this Key Frame
        */
        public function getParent():FlameAffector
        {
            return d_parent;
        }
        
        /*!
        \brief
        Moves this keyframe to a new given position
        */
//        public function moveToPosition(newPosition:Number):void
//        {
//            Misc.assert(d_parent != null);
//            
//            d_parent.moveKeyFrameToPosition(d_position, newPosition);
//        }
        
        /*!
        \brief
        Retrieves position of this key frame in the animation (in seconds)
        */
        public function getPosition():Number
        {
            return d_position;
        }
        
        /*!
        \brief
        Sets the value of this key frame
        
        \par
        This is only used if source property is empty!
        
        \see
        KeyFrame::setSourceProperty
        */
        public function setValue(value:String):void
        {
            d_value = value;
        }
        
        /*!
        \brief
        Retrieves value of this key frame
        */
        public function getValue():String
        {
            return d_value;
        }
        
        /*!
        \brief
        Sets the source property of this key frame
        
        \par
        Key frame can get it's value from 2 places, it's either stored inside
        it (setValue, getValue methods) or it's linked to a property
        (setSourcePropery, getSourceProperty).
        
        The decision about what value is used is simple, if there is a source
        property (sourceProperty is not empty, it's used)
        */
        public function setSourceProperty(sourceProperty:String):void
        {
            d_sourceProperty = sourceProperty;
        }
        
        /*!
        \brief
        Gets the source property of this key frame
        */
        public function getSourceProperty():String
        {
            return d_sourceProperty;
        }
        
        /*!
        \brief
        Retrieves value of this for use when animating
        
        \par
        This is an internal method! Only use if you know what you're doing!
        
        \par
        This returns the base property value if source property is set on this
        keyframe, it works the same as getValue() if source property is empty
        */
        public function getValueForAnimation(instance:FlameAnimationInstance):String
        {
            if (d_sourceProperty.length != 0)
            {
                return instance.getSavedPropertyValue(d_sourceProperty);
            }
            else
            {
                return d_value;
            }
        }
        
        /*!
        \brief
        Sets the progression method of this key frame
        
        \par
        This controls how the animation will progress TOWARDS this key frame,
        whether it will be a linear motion, accelerated, decelerated, etc...
        
        That means that the progression of the first key frame is never used!
        
        Please see KeyFrame::Progression
        */
        public function setProgression(p:uint):void
        {
            d_progression = p;
        }
        
        /*!
        \brief
        Retrieves progression method of this key frame
        */
        public function getProgression():uint
        {
            return d_progression;
        }
        
        /*!
        \brief
        Internal method, alters interpolation position based on progression
        method. Don't use unless you know what you're doing!
        */
        public function alterInterpolationPosition(position:Number):Number
        {
            switch (d_progression)
            {
                case Consts.Progression_P_Linear:
                    return position;
                    
                case Consts.Progression_P_QuadraticAccelerating:
                    return position * position;
                    
                case Consts.Progression_P_QuadraticDecelerating:
                    return Math.sqrt(position);
                    
                case Consts.Progression_P_Discrete:
                    return position < 1.0 ? 0.0 : 1.0;
            }
            
            // todo: more progression methods?
            Misc.assert(false);
            return position;
        }
        
        /*!
        \brief
        Internal method, if this keyframe is using source property, this
        saves it's value to given instance before it's affected
        */
        public function savePropertyValue(instance:FlameAnimationInstance):void
        {
            if (d_sourceProperty.length != 0)
            {
                instance.savePropertyValue(d_sourceProperty);
            }
        }
        
        /*!
        \brief
        internal method, notifies this keyframe that it has been moved
        
        \par
        DO NOT CALL DIRECTLY, should only be used by Affector class
        
        \see
        KeyFrame::moveToPosition
        */
        public function notifyPositionChanged(newPosition:Number):void
        {
            d_position = newPosition;
        }

    }
    
}