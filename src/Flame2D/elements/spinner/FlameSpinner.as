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
package Flame2D.elements.spinner
{
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.ActivationEventArgs;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.system.FlameEventManager;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.editbox.FlameEditbox;

    /*!
    \brief
    Base class for the Spinner widget.
    
    The spinner widget has a text area where numbers may be entered
    and two buttons which may be used to increase or decrease the
    value in the text area by a user specified amount.
    */
    public class FlameSpinner extends FlameWindow
    {
        public static const WidgetTypeName:String = "CEGUI/Spinner";
        public static const EventNamespace:String = "Spinner";

        /*************************************************************************
         Events system constants
         *************************************************************************/
        /** Event fired when the spinner current value changes.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Spinner whose current value has
         * changed.
         */
        public static const EventValueChanged:String = "ValueChanged";
        /** Event fired when the spinner step value is changed.
         * Handlers area passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Spinner whose step value has
         * changed.
         */
        public static const EventStepChanged:String = "StepChanged";
        /** Event fired when the maximum spinner value is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Spinner whose maximum value has
         * been changed.
         */
        public static const EventMaximumValueChanged:String = "MaximumValueChanged";
        /** Event fired when the minimum spinner value is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::windows set to the Spinner whose minimum value has
         * been changed.
         */
        public static const EventMinimumValueChanged:String = "MinimumValueChanged";
        /** Event fired when the spinner text input & display mode is changed.
         * Handlers are passed a const WindowEventArgs reference with
         * WindowEventArgs::window set to the Spinner whose text mode has been
         * changed.
         */
        public static const EventTextInputModeChanged:String = "TextInputModeChanged";
        
        // component widget name suffix strings
        public const EditboxNameSuffix:String = "__auto_editbox__";
        public const IncreaseButtonNameSuffix:String = "__auto_incbtn__";
        public const DecreaseButtonNameSuffix:String = "__auto_decbtn__";

        // Validator strings
        protected const FloatValidator:String = "^-?\\d*\\.?\\d*$";//"-?\\d*\\.?\\d*";
        protected const IntegerValidator:String = "^-?\\d*$";//"-?\\d*";
        protected const HexValidator:String = "^[0-9a-fA-F]*$";//"[0-9a-fA-F]*";
        protected const OctalValidator:String = "^[0-7]*$";//"[0-7]*";

        /*************************************************************************
         Static properties for the Spinner widget
         *************************************************************************/
        private static var d_currentValueProperty:SpinnerPropertyCurrentValue = new SpinnerPropertyCurrentValue();
        private static var d_stepSizeProperty:SpinnerPropertyStepSize = new SpinnerPropertyStepSize();
        private static var d_maxValueProperty:SpinnerPropertyMaximumValue = new SpinnerPropertyMaximumValue();
        private static var d_minValueProperty:SpinnerPropertyMinimumValue = new SpinnerPropertyMinimumValue();
        private static var d_textInputModeProperty:SpinnerPropertyTextInputMode = new SpinnerPropertyTextInputMode();
        
        
        /*************************************************************************
         Data Fields
         *************************************************************************/
        protected var d_stepSize:Number = 1.0;     //!< Step size value used y the increase & decrease buttons.
        protected var d_currentValue:Number = 1.0; //!< Numerical copy of the text in d_editbox.
        protected var d_maxValue:Number = 32767.0;     //!< Maximum value for spinner.
        protected var d_minValue:Number = -32768.0;     //!< Minimum value for spinner.
        protected var d_inputMode:int = -1;    //!< Current text display/input mode.
        
        protected var d_fixed:uint = 0;
        
        
        
        public function FlameSpinner(type:String, name:String)
        {
            super(type, name);
            
            addSpinnerProperties();
        }
        
        
        
        /*!
        \brief
        Initialises the Window based object ready for use.
        
        \note
        This must be called for every window created.  Normally this is handled automatically by the WindowFactory for each Window type.
        
        \return
        Nothing
        */
        override public function initialiseComponents():void
        {
            // get all the component widgets
            var increaseButton:FlamePushButton = getIncreaseButton();
            var decreaseButton:FlamePushButton = getDecreaseButton();
            var editbox:FlameEditbox = getEditbox();
            
            // setup component controls
            increaseButton.setWantsMultiClickEvents(false);
            increaseButton.setMouseAutoRepeatEnabled(true);
            decreaseButton.setWantsMultiClickEvents(false);
            decreaseButton.setMouseAutoRepeatEnabled(true);
            
            // perform event subscriptions.
            increaseButton.subscribeEvent(FlameWindow.EventMouseButtonDown, new Subscriber(handleIncreaseButton, this), FlameWindow.EventNamespace);
            decreaseButton.subscribeEvent(FlameWindow.EventMouseButtonDown, new Subscriber(handleDecreaseButton, this), FlameWindow.EventNamespace);
            editbox.subscribeEvent(FlameWindow.EventTextChanged, new Subscriber(handleEditTextChange, this), FlameWindow.EventNamespace);
            
            // final initialisation
            setTextInputMode(Consts.TextInputMode_Integer);
            setCurrentValue(0.0);
            performChildWindowLayout();
        }
        
        
        /*************************************************************************
         Accessors
         *************************************************************************/
        /*!
        \brief
        Return the current spinner value.
        
        \return
        current value of the Spinner.
        */
        public function getCurrentValue():Number
        {
            return d_currentValue;
        }
        
        /*!
        \brief
        Return the current step value.
        
        \return
        Step value.  This is the value added to the spinner vaue when the
        up / down buttons are clicked.
        */
        public function getStepSize():Number
        {
            return d_stepSize;
        }
        
        /*!
        \brief
        Return the current maximum limit value for the Spinner.
        
        \return
        Maximum value that is allowed for the spinner.
        */
        public function getMaximumValue():Number
        {
            return d_maxValue;
        }
        
        /*!
        \brief
        Return the current minimum limit value for the Spinner.
        
        \return
        Minimum value that is allowed for the spinner.
        */
        public function getMinimumValue():Number
        {
            return d_minValue;
        }
        
        /*!
        \brief
        Return the current text input / display mode setting.
        
        \return
        One of the TextInputMode enumerated values indicating the current
        text input and display mode.
        */
        public function getTextInputMode():int
        {
            return d_inputMode;
        }
        
        /*************************************************************************
         Manipulators
         *************************************************************************/
        /*!
        \brief
        Set the current spinner value.
        
        \param value
        value to be assigned to the Spinner.
        
        \return
        Nothing.
        */
        public function setCurrentValue(value:Number):void
        {
            if (value != d_currentValue)
            {
                // limit input value to within valid range for spinner
                value = Math.max(Math.min(value, d_maxValue), d_minValue);
                
                d_currentValue = value;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onValueChanged(args);
            }
        }
        
        /*!
        \brief
        Set the current step value.
        
        \param step
        The value added to be the spinner value when the
        up / down buttons are clicked.
        
        \return
        Nothing.
        */
        public function setStepSize(step:Number):void
        {
            if (step != d_stepSize)
            {
                d_stepSize = step;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onStepChanged(args);
            }
        }
        
        public function setFixed(fixed:uint):void
        {
            d_fixed = fixed;
        }
        
        /*!
        \brief
        Set the spinner maximum value.
        
        \param maxValue
        The maximum value to be allowed by the spinner.
        
        \return
        Nothing.
        */
        public function setMaximumValue(maxValue:Number):void
        {
            if (maxValue != d_maxValue)
            {
                d_maxValue = maxValue;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onMaximumValueChanged(args);
            }
        }
        
        /*!
        \brief
        Set the spinner minimum value.
        
        \param minVaue
        The minimum value to be allowed by the spinner.
        
        \return
        Nothing.
        */
        public function setMinimumValue(minVaue:Number):void
        {
            if (minVaue != d_minValue)
            {
                d_minValue = minVaue;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onMinimumValueChanged(args);
            }
        }
        
        /*!
        \brief
        Set the spinner input / display mode.
        
        \param mode
        One of the TextInputMode enumerated values indicating the text
        input / display mode to be used by the spinner.
        
        \return
        Nothing.
        */
        public function setTextInputMode(mode:int):void
        {
            if (mode != d_inputMode)
            {
                switch (mode)
                {
                    case Consts.TextInputMode_FloatingPoint:
                        getEditbox().setValidationString(FloatValidator);
                        break;
                    case Consts.TextInputMode_Integer:
                        getEditbox().setValidationString(IntegerValidator);
                        break;
                    case Consts.TextInputMode_Hexadecimal:
                        getEditbox().setValidationString(HexValidator);
                        break;
                    case Consts.TextInputMode_Octal:
                        getEditbox().setValidationString(OctalValidator);
                        break;
                    default:
                        throw new Error("Spinner::setTextInputMode - An unknown TextInputMode was specified.");
                }
                
                d_inputMode = mode;
                
                var args:WindowEventArgs = new WindowEventArgs(this);
                onTextInputModeChanged(args);
            }
        }
        
        /*************************************************************************
         Protected Implementation Methods
         *************************************************************************/
        /*!
        \brief
        Returns the numerical representation of the current editbox text.
        
        \return
        double value that is the numerical equivalent of the editbox text.
        
        \exception InvalidRequestException  thrown if the text can not be converted.
        */
        protected function getValueFromText():Number
        {
            var tmpTxt:String = getEditbox().getText();
            
            // handle empty and lone '-' or '.' cases
            if (tmpTxt.length == 0 || (tmpTxt == "-") || (tmpTxt == "."))
            {
                return 0.0;
            }
            
            var res:int, tmp:int;
            var utmp:uint;
            var val:Number;
            
            switch (d_inputMode)
            {
                case Consts.TextInputMode_FloatingPoint:
                    val = Number(tmpTxt);
                    break;
                case Consts.TextInputMode_Integer:
                    tmp = int(tmpTxt);
                    val = Number(tmpTxt);
                    break;
                case Consts.TextInputMode_Hexadecimal:
                    utmp = parseInt("0x" + tmpTxt, 16);
                    val = Number(utmp);
                    break;
                case Consts.TextInputMode_Octal:
                    utmp = parseInt("0" + tmpTxt, 8);
                    val = Number(utmp);
                    break;
                default:
                    throw new Error("Spinner::getValueFromText - An unknown TextInputMode was encountered.");
            }
            

            return val;
            
//            throw new Error("Spinner::getValueFromText - The string '" + getEditbox().getText() + 
//                "' can not be converted to numerical representation.");

        }
        
        /*!
        \brief
        Returns the textual representation of the current spinner value.
        
        \return
        String object that is equivalent to the the numerical value of the spinner.
        */
        protected function getTextFromValue():String
        {
            var tmp:String;
            
            switch (d_inputMode)
            {
                case Consts.TextInputMode_FloatingPoint:
                    tmp = d_currentValue.toFixed(d_fixed);
                    break;
                case Consts.TextInputMode_Integer:
                    tmp = d_currentValue.toString();
                    break;
                case Consts.TextInputMode_Hexadecimal:
                    tmp = d_currentValue.toString(16);
                    break;
                case Consts.TextInputMode_Octal:
                    tmp = d_currentValue.toString(8);
                    break;
                default:
                    throw new Error("Spinner::getValueFromText - An unknown TextInputMode was encountered.");
            }
            
            return tmp;
        }
        
        
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
            if (class_name=="Spinner")	return true;
            return super.testClassName_impl(class_name);
        }
        
        /*!
        \brief
        Return a pointer to the 'increase' PushButtoncomponent widget for
        this Spinner.
        
        \return
        Pointer to a PushButton object.
        
        \exception UnknownObjectException
        Thrown if the increase PushButton component does not exist.
        */
        protected function getIncreaseButton():FlamePushButton
        {
            return FlameWindowManager.getSingleton().getWindow(
                getName() + IncreaseButtonNameSuffix) as FlamePushButton;
        }
        
        /*!
        \brief
        Return a pointer to the 'decrease' PushButton component widget for
        this Spinner.
        
        \return
        Pointer to a PushButton object.
        
        \exception UnknownObjectException
        Thrown if the 'decrease' PushButton component does not exist.
        */
        protected function getDecreaseButton():FlamePushButton
        {
            return FlameWindowManager.getSingleton().getWindow(
                getName() + DecreaseButtonNameSuffix) as FlamePushButton;
        }
        
        /*!
        \brief
        Return a pointer to the Editbox component widget for this Spinner.
        
        \return
        Pointer to a Editbox object.
        
        \exception UnknownObjectException
        Thrown if the Editbox component does not exist.
        */
        protected function getEditbox():FlameEditbox
        {
            return FlameWindowManager.getSingleton().getWindow(
                getName() + EditboxNameSuffix) as FlameEditbox;
        }
        
        /*************************************************************************
         Overrides for Event handler methods
         *************************************************************************/
        override protected function onFontChanged(e:WindowEventArgs):void
        {
            // Propagate to children
            getEditbox().setFont(getFont());
            // Call base class handler
            super.onFontChanged(e);
        }
        
        override protected function onTextChanged(e:WindowEventArgs):void
        {
            var editbox:FlameEditbox = getEditbox();
            
            // update only if needed
            if (editbox.getText() != getText())
            {
                // done before doing base class processing so event subscribers see
                // 'updated' version.
                editbox.setText(getText());
                ++e.handled;
                
                super.onTextChanged(e);
            }
        }
        
        override protected function onActivated(e:ActivationEventArgs):void
        {
            if (!isActive())
            {
                super.onActivated(e);
                
                var editbox:FlameEditbox = getEditbox();
                
                if (!editbox.isActive())
                {
                    editbox.activate();
                }
            }
        }
        
        /*************************************************************************
         New Event handler methods
         *************************************************************************/
        /*!
        \brief
        Method called when the spinner value changes.
        
        \param e
        WindowEventArgs object containing any relevant data.
        
        \return
        Nothing.
        */
        protected function onValueChanged(e:WindowEventArgs):void
        {
            var editbox:FlameEditbox = getEditbox();
            
            // mute to save doing unnecessary events work.
            var wasMuted:Boolean = editbox.isMuted();
            editbox.setMutedState(true);
            
            // Update text with new value.
            // (allow empty and '-' cases to equal 0 with no text change required)
            if (!(d_currentValue == 0 &&
                (editbox.getText().length == 0 || editbox.getText() == "-")))
            {
                editbox.setText(getTextFromValue());
            }
            // restore previous mute state.
            editbox.setMutedState(wasMuted);
            
            fireEvent(EventValueChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Method called when the step value changes.
        
        \param e
        WindowEventArgs object containing any relevant data.
        
        \return
        Nothing.
        */
        protected function onStepChanged(e:WindowEventArgs):void
        {
            fireEvent(EventStepChanged, e, EventNamespace);
        }
        
        /*!
        \brief
        Method called when the maximum value setting changes.
        
        \param e
        WindowEventArgs object containing any relevant data.
        
        \return
        Nothing.
        */
        protected function onMaximumValueChanged(e:WindowEventArgs):void
        {
            fireEvent(EventMaximumValueChanged, e, EventNamespace);
            
            if (d_currentValue > d_maxValue)
            {
                setCurrentValue(d_maxValue);
            }
        }
            
        
        /*!
        \brief
        Method called when the minimum value setting changes.
        
        \param e
        WindowEventArgs object containing any relevant data.
        
        \return
        Nothing.
        */
        protected function onMinimumValueChanged(e:WindowEventArgs):void
        {
            fireEvent(EventMinimumValueChanged, e, EventNamespace);
            
            if (d_currentValue < d_minValue)
            {
                setCurrentValue(d_minValue);
            }
        }
        
        /*!
        \brief
        Method called when the text input/display mode is changed.
        
        \param e
        WindowEventArgs object containing any relevant data.
        
        \return
        Nothing.
        */
        protected function onTextInputModeChanged(e:WindowEventArgs):void
        {
            var editbox:FlameEditbox = getEditbox();
            // update edit box text to reflect new mode.
            // mute to save doing unnecessary events work.
            var wasMuted:Boolean = editbox.isMuted();
            editbox.setMutedState(true);
            // Update text with new value.
            editbox.setText(getTextFromValue());
            // restore previous mute state.
            editbox.setMutedState(wasMuted);
            
            fireEvent(EventTextInputModeChanged, e, EventNamespace);
        }
        
        /*************************************************************************
         Internal event listener methods
         *************************************************************************/
        protected function handleIncreaseButton(e:EventArgs):Boolean
        {
            if ((e as MouseEventArgs).button == Consts.MouseButton_LeftButton)
            {
                setCurrentValue(d_currentValue + d_stepSize);
                return true;
            }
            
            return false;
        }
        
        protected function handleDecreaseButton(e:EventArgs):Boolean
        {
            if ((e as MouseEventArgs).button == Consts.MouseButton_LeftButton)
            {
                setCurrentValue(d_currentValue - d_stepSize);
                return true;
            }
            
            return false;
        }
        
        protected function handleEditTextChange(e:EventArgs):Boolean
        {
            // set this windows text to match
            setText(getEditbox().getText());
            // update value
            setCurrentValue(getValueFromText());
            return true;
        }
        
        
        /*************************************************************************
         Private Implementation Methods
         *************************************************************************/
        /*!
        \brief
        Adds properties supported by the Spinner class.
        
        \return
        Nothing.
        */
        private function addSpinnerProperties():void
        {
            addProperty(d_currentValueProperty);
            addProperty(d_stepSizeProperty);
            addProperty(d_maxValueProperty);
            addProperty(d_minValueProperty);
            addProperty(d_textInputModeProperty);
        }
    }
}