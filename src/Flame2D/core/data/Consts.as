
package Flame2D.core.data
{
    import flash.events.KeyboardEvent;
    
    public class Consts
    {
        

        /*!
        \brief
        Enumerated type used for specifying Window::update mode to be used.  Note
        that the setting specified will also have an effect on child window
        content; for WUM_NEVER and WUM_VISIBLE, if the parent's update function is
        not called, then no child window will have it's update function called
        either - even if it specifies WUM_ALWAYS as it's WindowUpdateMode.
        */
        /*
        enum WindowUpdateMode
        {
            //! Always call the Window::update function for this window.
            WUM_ALWAYS,
            //! Never call the Window::update function for this window.
            WUM_NEVER,
            //! Only call the Window::update function for this window if it is visible.
            WUM_VISIBLE
        };
        */
        
        public static const WindowUpdateMode_ALWAYS:uint        = 0;
        public static const WindowUpdateMode_NEVER:uint         = 1;
        public static const WindowUpdateMode_VISIBLE:uint       = 2;
        
        /*
        enum MetricsMode
        {
        Relative,		//!< Metrics are specified as a decimal fraction of parent Window size.
        Absolute,		//!< Metrics are specified as whole pixels.
        Inherited		//!< Metrics are inherited from parent.
        };
        */
        public static const MetricsMode_Relative:uint           = 0;
        public static const MetricsMode_Absolute:uint           = 1;
        public static const MetricsMode_Inherited:uint          = 2;
        
        /*
        enum HookMode
        {
        Hook_None = 0,
        Hook_Left,
        Hook_Right,
        Hook_Top,
        Hook_Bottom,
        Hook_LeftTop,
        Hook_LeftBottom,
        Hook_RightTop,
        Hook_RightBottom,
        Hook_Center,
        };*/
        
        public static const HookMode_HookNone:uint                  = 0;
        public static const HookMode_Left:uint                      = 1;
        public static const HookMode_Right:uint                     = 2;
        public static const HookMode_Top:uint                       = 3;
        public static const HookMode_Bottom:uint                    = 4;
        public static const HookMode_LeftTop:uint                   = 5;
        public static const HookMode_LeftBottom:uint                = 6;
        public static const HookMode_RightTop:uint                  = 7;
        public static const HookMode_RightBottom:uint               = 8;
        public static const HookMode_Center:uint                    = 9;

        
        /*
        enum VerticalAlignment
        {
        VA_TOP,        //!< Elements position specifies an offset of it's top edge from the top edge of it's parent.
        VA_CENTRE,     //!< Elements position specifies an offset of it's vertical centre from the vertical centre of it's parent.
        VA_BOTTOM      //!< Elements position specifies an offset of it's bottom edge from the bottom edge of it's parent.
        };
        */
        
        public static const VerticalAlignment_VA_TOP:uint              = 0;
        public static const VerticalAlignment_VA_CENTRE:uint           = 1;
        public static const VerticalAlignment_VA_BOTTOM:uint           = 2;
        
        
        /*
        enum HorizontalAlignment
        {
        HA_LEFT,        //!< Elements position specifies an offset of it's left edge from the left edge of it's parent.
        HA_CENTRE,      //!< Elements position specifies an offset of it's horizontal centre from the horizontal centre of it's parent.
        HA_RIGHT        //!< Elements position specifies an offset of it's right edge from the right edge of it's parent.
        };
        */
        public static const HorizontalAlignment_HA_LEFT:uint           = 0;
        public static const HorizontalAlignment_HA_CENTRE:uint         = 1;
        public static const HorizontalAlignment_HA_RIGHT:uint          = 2;
        
        
        /*!
        /brief
        Enumeration of mouse buttons
        */
        /*
        enum MouseButton
        {
            LeftButton,
            RightButton,
            MiddleButton,
            X1Button,
            X2Button,
            MouseButtonCount,		//<! Dummy value that is == to the maximum number of mouse buttons supported.
            NoButton				//!< Value set for no mouse button.  NB: This is not 0, do not assume! 
        };
        */
        public static const MouseButton_LeftButton:uint             = 0;
        public static const MouseButton_RightButton:uint            = 1;
        public static const MouseButton_MiddleButton:uint           = 2;
        public static const MouseButton_X1Button:uint               = 3;
        public static const MouseButton_X2Button:uint               = 4;
        public static const MouseButton_MouseButtonCount:uint       = 5;
        public static const MouseButton_NoButton:uint               = 6;
        
        /*!
        \brief
        System key flag values
        */
        /*
        enum SystemKey
        {
            LeftMouse		= 0x0001,			//!< The left mouse button.
                RightMouse		= 0x0002,			//!< The right mouse button.
                Shift			= 0x0004,			//!< Either shift key.
                Control			= 0x0008,			//!< Either control key.
                MiddleMouse		= 0x0010,			//!< The middle mouse button.
                X1Mouse			= 0x0020,			//!< The first 'extra' mouse button
                X2Mouse			= 0x0040,			//!< The second 'extra' mouse button.
                Alt				= 0x0080			//!< Either alt key.
        };
        */
        public static const SystemKey_LeftMouse:uint                = 0x0001;
        public static const SystemKey_RightMouse:uint               = 0x0002;
        public static const SystemKey_Shift:uint                    = 0x0004;
        public static const SystemKey_Control:uint                  = 0x0008;
        public static const SystemKey_MiddleMouse:uint              = 0x0010;
        public static const SystemKey_X1Mouse:uint                  = 0x0020;
        public static const SystemKey_X2Mouse:uint                  = 0x0040;
        public static const SystemKey_Alt:uint                      = 0x0080;
        
        
        /*!
        \brief
        Enumeration of possible values to indicate what a given dimension represents.
        */
        /*
        enum DimensionType
        {
            DT_LEFT_EDGE,       //!< Dimension represents the left edge of some entity (same as DT_X_POSITION).
            DT_X_POSITION,      //!< Dimension represents the x position of some entity (same as DT_LEFT_EDGE).
            DT_TOP_EDGE,        //!< Dimension represents the top edge of some entity (same as DT_Y_POSITION).
            DT_Y_POSITION,      //!< Dimension represents the y position of some entity (same as DT_TOP_EDGE).
            DT_RIGHT_EDGE,      //!< Dimension represents the right edge of some entity.
            DT_BOTTOM_EDGE,     //!< Dimension represents the bottom edge of some entity.
            DT_WIDTH,           //!< Dimension represents the width of some entity.
            DT_HEIGHT,          //!< Dimension represents the height of some entity.
            DT_X_OFFSET,        //!< Dimension represents the x offset of some entity (usually only applies to an Image entity).
            DT_Y_OFFSET,        //!< Dimension represents the y offset of some entity (usually only applies to an Image entity).
            DT_INVALID          //!< Invalid / uninitialised DimensionType.
        };
        */
        public static const DimensionType_DT_LEFT_EDGE:uint         = 0;
        public static const DimensionType_DT_X_POSITION:uint        = 1;
        public static const DimensionType_DT_TOP_EDGE:uint          = 2;
        public static const DimensionType_DT_Y_POSITION:uint        = 3;
        public static const DimensionType_DT_RIGHT_EDGE:uint        = 4;
        public static const DimensionType_DT_BOTTOM_EDGE:uint       = 5;
        public static const DimensionType_DT_WIDTH:uint             = 6;
        public static const DimensionType_DT_HEIGHT:uint            = 7;
        public static const DimensionType_DT_X_OFFSET:uint          = 8;
        public static const DimensionType_DT_Y_OFFSET:uint          = 9;
        public static const DimensionType_DT_INVALID:uint           = 10;
        
        /*!
        \brief
        Enumeration of possible values to indicate the vertical formatting to be used for an image component.
        */
        /*
        enum VerticalFormatting
        {
            VF_TOP_ALIGNED,         //!< Top of Image should be aligned with the top of the destination area.
            VF_CENTRE_ALIGNED,      //!< Image should be vertically centred within the destination area.
            VF_BOTTOM_ALIGNED,      //!< Bottom of Image should be aligned with the bottom of the destination area.
            VF_STRETCHED,           //!< Image should be stretched vertically to fill the destination area.
            VF_TILED                //!< Image should be tiled vertically to fill the destination area (bottom-most tile may be clipped).
        };
        */
        public static const VerticalFormatting_VF_TOP_ALIGNED:uint      = 0;
        public static const VerticalFormatting_VF_CENTRE_ALIGNED:uint   = 1;
        public static const VerticalFormatting_VF_BOTTOM_ALIGNED:uint   = 2;
        public static const VerticalFormatting_VF_STRETCHED:uint        = 3;
        public static const VerticalFormatting_VF_TILED:uint            = 4;
        
        /*!
        \brief
        Enumeration of possible values to indicate the horizontal formatting to be used for an image component.
        */
        /*
        enum HorizontalFormatting
        {
            HF_LEFT_ALIGNED,        //!< Left of Image should be aligned with the left of the destination area.
            HF_CENTRE_ALIGNED,      //!< Image should be horizontally centred within the destination area.
            HF_RIGHT_ALIGNED,       //!< Right of Image should be aligned with the right of the destination area.
            HF_STRETCHED,           //!< Image should be stretched horizontally to fill the destination area.
            HF_TILED                //!< Image should be tiled horizontally to fill the destination area (right-most tile may be clipped).
        };
        */
        public static const HorizontalFormatting_HF_LEFT_ALIGNED:uint       = 0;
        public static const HorizontalFormatting_HF_CENTRE_ALIGNED:uint     = 1;
        public static const HorizontalFormatting_HF_RIGHT_ALIGNED:uint      = 2;
        public static const HorizontalFormatting_HF_STRETCHED:uint          = 3;
        public static const HorizontalFormatting_HF_TILED:uint              = 4;
        
        /*!
        \brief
        Enumeration of possible values to indicate the vertical formatting to be used for a text component.
        */
        /*
        enum VerticalTextFormatting
        {
            VTF_TOP_ALIGNED,         //!< Top of text should be aligned with the top of the destination area.
            VTF_CENTRE_ALIGNED,      //!< text should be vertically centred within the destination area.
            VTF_BOTTOM_ALIGNED       //!< Bottom of text should be aligned with the bottom of the destination area.
        };
        */
        public static const VerticalTextFormatting_VTF_TOP_ALIGNED:uint     = 0;
        public static const VerticalTextFormatting_VTF_CENTRE_ALIGNED:uint  = 1;
        public static const VerticalTextFormatting_VTF_BOTTOM_ALIGNED:uint  = 2;
        
        /*!
        \brief
        Enumeration of possible values to indicate the horizontal formatting to be used for a text component.
        */
        /*
        enum HorizontalTextFormatting
        {
            HTF_LEFT_ALIGNED,        //!< Left of text should be aligned with the left of the destination area (single line of text only).
            HTF_RIGHT_ALIGNED,       //!< Right of text should be aligned with the right of the destination area  (single line of text only).
            HTF_CENTRE_ALIGNED,      //!< text should be horizontally centred within the destination area  (single line of text only).
            HTF_JUSTIFIED,           //!< text should be spaced so that it takes the full width of the destination area (single line of text only).
            HTF_WORDWRAP_LEFT_ALIGNED,    //!< Left of text should be aligned with the left of the destination area (word wrapped to multiple lines as needed).
            HTF_WORDWRAP_RIGHT_ALIGNED,   //!< Right of text should be aligned with the right of the destination area  (word wrapped to multiple lines as needed).
            HTF_WORDWRAP_CENTRE_ALIGNED,  //!< text should be horizontally centred within the destination area  (word wrapped to multiple lines as needed).
            HTF_WORDWRAP_JUSTIFIED        //!< text should be spaced so that it takes the full width of the destination area (word wrapped to multiple lines as needed).
        };
        */
        public static const HorizontalTextFormatting_HTF_LEFT_ALIGNED:uint              = 0;
        public static const HorizontalTextFormatting_HTF_RIGHT_ALIGNED:uint             = 1;
        public static const HorizontalTextFormatting_HTF_CENTRE_ALIGNED:uint            = 2;
        public static const HorizontalTextFormatting_HTF_JUSTIFIED:uint                 = 3;
        public static const HorizontalTextFormatting_HTF_WORDWRAP_LEFT_ALIGNED:uint     = 4;
        public static const HorizontalTextFormatting_HTF_WORDWRAP_RIGHT_ALIGNED:uint    = 5;
        public static const HorizontalTextFormatting_HTF_WORDWRAP_CENTRE_ALIGNED:uint   = 6;
        public static const HorizontalTextFormatting_HTF_WORDWRAP_JUSTIFIED:uint        = 7;
        
        /*!
        \brief
        Enumeration of possible values to indicate a particular font metric.
        */
        /*
        enum FontMetricType
        {
            FMT_LINE_SPACING,       //!< Vertical line spacing value for font.
            FMT_BASELINE,           //!< Vertical baseline value for font.
            FMT_HORZ_EXTENT         //!< Horizontal extent of a string.
        };
        */
        public static const FontMetricType_FMT_LINE_SPACING:uint                        = 0;
        public static const FontMetricType_FMT_BASELINE:uint                            = 1;
        public static const FontMetricType_FMT_HORZ_EXTENT:uint                         = 2;
        /*!
        \brief
        Enumeration of values representing mathematical operations on dimensions.
        */
        /*
        enum DimensionOperator
        {
            DOP_NOOP,       //!< Do nothing operator.
            DOP_ADD,        //!< Dims should be added.
            DOP_SUBTRACT,   //!< Dims should be subtracted.
            DOP_MULTIPLY,   //!< Dims should be multiplied.
            DOP_DIVIDE      //!< Dims should be divided.
        };
        */
        public static const DimensionOperator_DOP_NOOP:uint                             = 0;
        public static const DimensionOperator_DOP_ADD:uint                              = 1;
        public static const DimensionOperator_DOP_SUBTRACT:uint                         = 2;
        public static const DimensionOperator_DOP_MULTIPLY:uint                         = 3;
        public static const DimensionOperator_DOP_DIVIDE:uint                           = 4;
        /*!
        \brief
        Enumeration of values referencing available images forming a frame component.
        */
        /*
        enum FrameImageComponent
        {
            FIC_BACKGROUND,             //!< References image used for the background.
            FIC_TOP_LEFT_CORNER,        //!< References image used for the top-left corner.
            FIC_TOP_RIGHT_CORNER,       //!< References image used for the top-right corner.
            FIC_BOTTOM_LEFT_CORNER,     //!< References image used for the bottom-left corner.
            FIC_BOTTOM_RIGHT_CORNER,    //!< References image used for the bottom-right corner.
            FIC_LEFT_EDGE,              //!< References image used for the left edge.
            FIC_RIGHT_EDGE,             //!< References image used for the right edge.
            FIC_TOP_EDGE,               //!< References image used for the top edge.
            FIC_BOTTOM_EDGE,            //!< References image used for the bottom edge.
            FIC_FRAME_IMAGE_COUNT       //!< Max number of images for a frame.
        };
        */
        public static const FrameImageComponent_FIC_BACKGROUND:uint                     = 0;
        public static const FrameImageComponent_FIC_TOP_LEFT_CORNER:uint                = 1;
        public static const FrameImageComponent_FIC_TOP_RIGHT_CORNER:uint               = 2;
        public static const FrameImageComponent_FIC_BOTTOM_LEFT_CORNER:uint             = 3;
        public static const FrameImageComponent_FIC_BOTTOM_RIGHT_CORNER:uint            = 4;
        public static const FrameImageComponent_FIC_LEFT_EDGE:uint                      = 5;
        public static const FrameImageComponent_FIC_RIGHT_EDGE:uint                     = 6;
        public static const FrameImageComponent_FIC_TOP_EDGE:uint                       = 7;
        public static const FrameImageComponent_FIC_BOTTOM_EDGE:uint                    = 8;
        public static const FrameImageComponent_FIC_FRAME_IMAGE_COUNT:uint              = 9;
        
        /*
        //! Enumerated type for valid render queue IDs.
        enum RenderQueueID
        {
            RQ_USER_0,
            //! Queue for rendering that appears beneath base imagery.
            RQ_UNDERLAY,
            RQ_USER_1,
            //! Queue for base level rendering by the surface owner.
            RQ_BASE,
            RQ_USER_2,
            //! Queue for first level of 'content' rendering.
            RQ_CONTENT_1,
            RQ_USER_3,
            //! Queue for second level of 'content' rendering.
            RQ_CONTENT_2,
            RQ_USER_4,
            //! Queue for overlay rendering that appears above other regular rendering.
            RQ_OVERLAY,
            RQ_USER_5
        };
        */
        
        public static const RenderQueueID_RQ_USER_0:uint                        = 0;
        public static const RenderQueueID_RQ_UNDERLAY:uint                      = 1;
        public static const RenderQueueID_RQ_USER_1:uint                        = 2;
        public static const RenderQueueID_RQ_BASE:uint                          = 3;
        public static const RenderQueueID_RQ_USER_2:uint                        = 4;
        public static const RenderQueueID_RQ_CONTENT_1:uint                     = 5;
        public static const RenderQueueID_RQ_USER_3:uint                        = 6;
        public static const RenderQueueID_RQ_CONTENT_2:uint                     = 7;
        public static const RenderQueueID_RQ_USER_4:uint                        = 8;
        public static const RenderQueueID_RQ_OVERLAY:uint                       = 9;
        public static const RenderQueueID_RQ_USER_5:uint                        = 10;
        
        /*!
        \brief
        Enumerated type containing the supported pixel formats that can be
        passed to loadFromMemory
        */
        /*
        enum PixelFormat
        {
            //! Each pixel is 3 bytes. RGB in that order.
            PF_RGB,
            //! Each pixel is 4 bytes. RGBA in that order.
            PF_RGBA
        };
        */
        
        public static const PixelFormat_PF_RGB:uint                             = 0;
        public static const PixelFormat_PF_RGBA:uint                            = 1;
        
        
        /*!
        \brief
        Enumeration of special values used for mouse cursor settings in Window objects.
        */
        /*
        enum MouseCursorImage
        {		
            BlankMouseCursor	= 0,		//!< No image should be displayed for the mouse cursor.
                DefaultMouseCursor	= -1		//!< The default mouse cursor image should be displayed.
        };
        */
        
        public static const MouseCursorImage_BlankMouseCursor:int              = 0;
        public static const MouseCursorImage_DefaultMouseCursor:int            = -1;


//        public static const Key_Escape          :uint	=0x01;
//        public static const Key_One             :uint	=0x02;
//        public static const Key_Two             :uint	=0x03;
//        public static const Key_Three           :uint	=0x04;
//        public static const Key_Four            :uint	=0x05;
//        public static const Key_Five            :uint	=0x06;
//        public static const Key_Six             :uint	=0x07;
//        public static const Key_Seven           :uint	=0x08;
//        public static const Key_Eight           :uint	=0x09;
//        public static const Key_Nine            :uint	=0x0A;
//        public static const Key_Zero            :uint	=0x0B;
//        public static const Key_Minus           :uint	=0x0C;    /* - on main keyboard */
//        public static const Key_Equals		    :uint	=0x0D;
//        public static const Key_Backspace	    :uint	=0x0E;    /* backspace */
//        public static const Key_Tab		        :uint	=0x0F;
//        public static const Key_Q               :uint	=0x10;
//        public static const Key_W               :uint	=0x11;
//        public static const Key_E               :uint	=0x12;
//        public static const Key_R               :uint	=0x13;
//        public static const Key_T               :uint	=0x14;
//        public static const Key_Y               :uint	=0x15;
//        public static const Key_U               :uint	=0x16;
//        public static const Key_I               :uint	=0x17;
//        public static const Key_O               :uint	=0x18;
//        public static const Key_P               :uint	=0x19;
//        public static const Key_LeftBracket     :uint	=0x1A;
//        public static const Key_RightBracket    :uint	=0x1B;
//        public static const Key_Return		    :uint	=0x1C;    /* Enter on main keyboard */
//        public static const Key_LeftControl	    :uint	=0x1D;
//        public static const Key_A               :uint	=0x1E;
//        public static const Key_S               :uint	=0x1F;
//        public static const Key_D               :uint	=0x20;
//        public static const Key_F               :uint	=0x21;
//        public static const Key_G               :uint	=0x22;
//        public static const Key_H               :uint	=0x23;
//        public static const Key_J               :uint	=0x24;
//        public static const Key_K               :uint	=0x25;
//        public static const Key_L               :uint	=0x26;
//        public static const Key_Semicolon       :uint	=0x27;
//        public static const Key_Apostrophe	    :uint	=0x28;
//        public static const Key_Grave           :uint	=0x29;    /* accent grave */
//        public static const Key_LeftShift       :uint	=0x2A;
//        public static const Key_Backslash       :uint	=0x2B;
//        public static const Key_Z               :uint	=0x2C;
//        public static const Key_X               :uint	=0x2D;
//        public static const Key_C               :uint	=0x2E;
//        public static const Key_V               :uint	=0x2F;
//        public static const Key_B               :uint	=0x30;
//        public static const Key_N               :uint	=0x31;
//        public static const Key_M               :uint	=0x32;
//        public static const Key_Comma           :uint	=0x33;
//        public static const Key_Period          :uint	=0x34;    /* . on main keyboard */
//        public static const Key_Slash           :uint	=0x35;    /* '/' on main keyboard */
//        public static const Key_RightShift      :uint	=0x36;
//        public static const Key_Multiply        :uint	=0x37;    /* * on numeric keypad */
//        public static const Key_LeftAlt         :uint	=0x38;    /* left Alt */
//        public static const Key_Space           :uint	=0x39;
//        public static const Key_Capital         :uint	=0x3A;
//        public static const Key_F1              :uint	=0x3B;
//        public static const Key_F2              :uint	=0x3C;
//        public static const Key_F3              :uint	=0x3D;
//        public static const Key_F4              :uint	=0x3E;
//        public static const Key_F5              :uint	=0x3F;
//        public static const Key_F6              :uint	=0x40;
//        public static const Key_F7              :uint	=0x41;
//        public static const Key_F8              :uint	=0x42;
//        public static const Key_F9              :uint	=0x43;
//        public static const Key_F10             :uint	=0x44;
//        public static const Key_NumLock         :uint	=0x45;
//        public static const Key_ScrollLock      :uint	=0x46;    /* Scroll Lock */
//        public static const Key_Numpad7         :uint	=0x47;
//        public static const Key_Numpad8         :uint	=0x48;
//        public static const Key_Numpad9         :uint	=0x49;
//        public static const Key_Subtract        :uint	=0x4A;    /* - on numeric keypad */
//        public static const Key_Numpad4         :uint	=0x4B;
//        public static const Key_Numpad5         :uint	=0x4C;
//        public static const Key_Numpad6         :uint	=0x4D;
//        public static const Key_Add		        :uint	=0x4E;    /* + on numeric keypad */
//        public static const Key_Numpad1         :uint	=0x4F;
//        public static const Key_Numpad2         :uint	=0x50;
//        public static const Key_Numpad3         :uint	=0x51;
//        public static const Key_Numpad0         :uint	=0x52;
//        public static const Key_Decimal		    :uint	=0x53;    /* . on numeric keypad */
//        public static const Key_OEM_102         :uint	=0x56;    /* < > | on UK/Germany keyboards */
//        public static const Key_F11             :uint	=0x57;
//        public static const Key_F12             :uint	=0x58;
//        public static const Key_F13             :uint	=0x64;    /*                     (NEC PC98) */
//        public static const Key_F14             :uint	=0x65;    /*                     (NEC PC98) */
//        public static const Key_F15             :uint	=0x66;    /*                     (NEC PC98) */
//        public static const Key_Kana            :uint	=0x70;    /* (Japanese keyboard)            */
//        public static const Key_ABNT_C1         :uint	=0x73;    /* / ? on Portugese (Brazilian) keyboards */
//        public static const Key_Convert         :uint	=0x79;    /* (Japanese keyboard)            */
//        public static const Key_NoConvert       :uint	=0x7B;    /* (Japanese keyboard)            */
//        public static const Key_Yen             :uint	=0x7D;    /* (Japanese keyboard)            */
//        public static const Key_ABNT_C2         :uint	=0x7E;    /* Numpad . on Portugese (Brazilian) keyboards */
//        public static const Key_NumpadEquals    :uint	=0x8D;    /* :uint	= on numeric keypad (NEC PC98) */
//        public static const Key_PrevTrack       :uint	=0x90;    /* Previous Track (KC_CIRCUMFLEX on Japanese keyboard) */
//        public static const Key_At              :uint	=0x91;    /*                     (NEC PC98) */
//        public static const Key_Colon           :uint	=0x92;    /*                     (NEC PC98) */
//        public static const Key_Underline       :uint	=0x93;    /*                     (NEC PC98) */
//        public static const Key_Kanji           :uint	=0x94;    /* (Japanese keyboard)            */
//        public static const Key_Stop            :uint	=0x95;    /*                     (NEC PC98) */
//        public static const Key_AX              :uint	=0x96;    /*                     (Japan AX) */
//        public static const Key_Unlabeled       :uint	=0x97;    /*                        (J3100) */
//        public static const Key_NextTrack       :uint	=0x99;    /* Next Track */
//        public static const Key_NumpadEnter     :uint	=0x9C;    /* Enter on numeric keypad */
//        public static const Key_RightControl    :uint	=0x9D;
//        public static const Key_Mute            :uint	=0xA0;    /* Mute */
//        public static const Key_Calculator      :uint	=0xA1;    /* Calculator */
//        public static const Key_PlayPause       :uint	=0xA2;    /* Play / Pause */
//        public static const Key_MediaStop       :uint	=0xA4;    /* Media Stop */
//        public static const Key_VolumeDown      :uint	=0xAE;    /* Volume - */
//        public static const Key_VolumeUp        :uint	=0xB0;    /* Volume + */
//        public static const Key_WebHome         :uint	=0xB2;    /* Web home */
//        public static const Key_NumpadComma     :uint	=0xB3;    /* ; on numeric keypad (NEC PC98) */
//        public static const Key_Divide          :uint	=0xB5;    /* / on numeric keypad */
//        public static const Key_SysRq           :uint	=0xB7;
//        public static const Key_RightAlt        :uint	=0xB8;    /* right Alt */
//        public static const Key_Pause           :uint	=0xC5;    /* Pause */
//        public static const Key_Home            :uint	=0xC7;    /* Home on arrow keypad */
//        public static const Key_ArrowUp         :uint	=0xC8;    /* UpArrow on arrow keypad */
//        public static const Key_PageUp          :uint	=0xC9;    /* PgUp on arrow keypad */
//        public static const Key_ArrowLeft       :uint	=0xCB;    /* LeftArrow on arrow keypad */
//        public static const Key_ArrowRight      :uint	=0xCD;    /* RightArrow on arrow keypad */
//        public static const Key_End             :uint	=0xCF;    /* End on arrow keypad */
//        public static const Key_ArrowDown       :uint	=0xD0;    /* DownArrow on arrow keypad */
//        public static const Key_PageDown	    :uint	=0xD1;    /* PgDn on arrow keypad */
//        public static const Key_Insert          :uint	=0xD2;    /* Insert on arrow keypad */
//        public static const Key_Delete          :uint	=0xD3;    /* Delete on arrow keypad */
//        public static const Key_LeftWindows     :uint	=0xDB;    /* Left Windows key */
//        public static const Key_RightWindows    :uint	=0xDC;    /* Right Windows key - Correct spelling :) */
//        public static const Key_AppMenu         :uint	=0xDD;    /* AppMenu key */
//        public static const Key_Power           :uint	=0xDE;    /* System Power */
//        public static const Key_Sleep           :uint	=0xDF;    /* System Sleep */
//        public static const Key_Wake		    :uint	=0xE3;    /* System Wake */
//        public static const Key_WebSearch	    :uint	=0xE5;    /* Web Search */
//        public static const Key_WebFavorites	:uint	=0xE6;    /* Web Favorites */
//        public static const Key_WebRefresh	    :uint	=0xE7;    /* Web Refresh */
//        public static const Key_WebStop		    :uint	=0xE8;    /* Web Stop */
//        public static const Key_WebForward	    :uint	=0xE9;    /* Web Forward */
//        public static const Key_WebBack		    :uint	=0xEA;    /* Web Back */
//        public static const Key_MyComputer	    :uint	=0xEB;    /* My Computer */
//        public static const Key_Mail		    :uint	=0xEC;    /* Mail */
//        public static const Key_MediaSelect	    :uint	=0xED;     /* Media Select */

        
        public static const Key_Backspace       :uint   = 8;
        public static const Key_Tab             :uint   = 9;
        public static const Key_Return          :uint   = 13;
        public static const Key_LeftShift       :uint   = 16;
        public static const Key_RightShift      :uint   = 16;
        public static const Key_LeftControl     :uint   = 17;
        public static const Key_RightControl    :uint   = 17;
        public static const Key_CapsLock        :uint	= 20;   //Capital?
        public static const Key_Escape          :uint	= 27;
        public static const Key_Space           :uint	= 32;
        public static const Key_PageUp          :uint	= 33;
        public static const Key_PageDown        :uint	= 34;
        public static const Key_End             :uint	= 35;
        public static const Key_Home            :uint	= 36;
        public static const Key_ArrowLeft       :uint	= 37;
        public static const Key_ArrowUp         :uint	= 38;
        public static const Key_ArrowRight      :uint	= 39;
        public static const Key_ArrowDown       :uint	= 40;
        public static const Key_Insert          :uint	= 45;
        public static const Key_Delete          :uint	= 46;
        public static const Key_NumLock         :uint	= 144;
        public static const Key_ScrLk           :uint	= 145;
        public static const Key_Pause           :uint   = 19;
        public static const Key_Break           :uint				= 19;
        public static const Key_A               :uint				= 65;
        public static const Key_B               :uint				= 66;
        public static const Key_C               :uint				= 67;
        public static const Key_D               :uint				= 68;
        public static const Key_E               :uint				= 69;
        public static const Key_F               :uint				= 70;
        public static const Key_G               :uint				= 71;
        public static const Key_H               :uint				= 72;
        public static const Key_I               :uint				= 73;
        public static const Key_J               :uint				= 74;
        public static const Key_K               :uint				= 75;
        public static const Key_L               :uint				= 76;
        public static const Key_M               :uint				= 77;
        public static const Key_N               :uint				= 78;
        public static const Key_O               :uint				= 79;
        public static const Key_P               :uint				= 80;
        public static const Key_Q               :uint				= 81;
        public static const Key_R               :uint				= 82;
        public static const Key_S               :uint				= 83;
        public static const Key_T               :uint				= 84;
        public static const Key_U               :uint				= 85;
        public static const Key_V               :uint				= 86;
        public static const Key_W               :uint				= 87;
        public static const Key_X               :uint				= 88;
        public static const Key_Y               :uint				= 89;
        public static const Key_Z               :uint				= 90;
        public static const Key_0               :uint				= 48;
        public static const Key_1               :uint				= 49;
        public static const Key_2               :uint				= 50;
        public static const Key_3               :uint				= 51;
        public static const Key_4               :uint				= 52;
        public static const Key_5               :uint				= 53;
        public static const Key_6               :uint				= 54;
        public static const Key_7               :uint				= 55;
        public static const Key_8               :uint				= 56;
        public static const Key_9               :uint				= 57;
        public static const Key_Semicolon       :uint				= 186;
        public static const Key_Equals:uint				= 187;
        public static const Key_Minus:uint				= 189;
        public static const Key_Slash:uint				= 191;
        //public static const Key_`~:uint				= 192;
        public static const Key_LeftBracket:uint				= 219;
        public static const Key_BackSlash:uint				= 220;
        public static const Key_RightBracket:uint				= 221;
        //public static const Key_"':uint				= 222;
        public static const Key_Comma:uint				= 188;
        public static const Key_Period          :uint				= 190;
        public static const Key_Numpad0:uint				= 96;
        public static const Key_Numpad1:uint				= 97;
        public static const Key_Numpad2:uint				= 98;
        public static const Key_Numpad3:uint				= 99;
        public static const Key_Numpad4:uint				= 100;
        public static const Key_Numpad5:uint				= 101;
        public static const Key_Numpad6:uint				= 102;
        public static const Key_Numpad7:uint				= 103;
        public static const Key_Numpad8:uint				= 104;
        public static const Key_Numpad9:uint				= 105;
        public static const Key_NumpadMultiply:uint				= 106;
        public static const Key_NumpadAdd:uint				= 107;
        public static const Key_NumpadEnter:uint				= 13;
        public static const Key_NumpadSubtract:uint				= 109;
        public static const Key_NumpadDecimal:uint				= 110;
        public static const Key_NumpadDivide:uint				= 111;
        public static const Key_F1:uint				= 112;
        public static const Key_F2:uint				= 113;
        public static const Key_F3:uint				= 114;
        public static const Key_F4:uint				= 115;
        public static const Key_F5:uint				= 116;
        public static const Key_F6:uint				= 117;
        public static const Key_F7:uint				= 118;
        public static const Key_F8:uint				= 119;
        public static const Key_F9:uint				= 120;
        //public static const Key_F10:uint				= 121;
        public static const Key_F11:uint				= 122;
        public static const Key_F12:uint				= 123;
        public static const Key_F13:uint				= 124;
        public static const Key_F14:uint				= 125;
        public static const Key_F15:uint				= 126;
        
        /*!
        \brief
        states for tooltip
        */
        /*
        enum TipState
        {
            Inactive,   //!< Tooltip is currently inactive.
            Active,     //!< Tooltip is currently displayed and active.
            FadeIn,     //!< Tooltip is currently transitioning from Inactive to Active state.
            FadeOut     //!< Tooltip is currently transitioning from Active to Inactive state.
        };
        */
        
        public static const TipState_Inactive:uint                  = 0;
        public static const TipState_Active:uint                    = 1;
        public static const TipState_FadeIn:uint                    = 2;
        public static const TipState_FadeOut:uint                   = 3;

        
        /*!
        \brief
        Enumeration that defines the set of possible locations for the mouse on a frame windows sizing border.
        */
        /*
        enum SizingLocation {
            SizingNone,			//!< Position is not a sizing location.
            SizingTopLeft,		//!< Position will size from the top-left.
            SizingTopRight,		//!< Position will size from the top-right.
            SizingBottomLeft,	//!< Position will size from the bottom left.
            SizingBottomRight,	//!< Position will size from the bottom right.
            SizingTop,			//!< Position will size from the top.
            SizingLeft,			//!< Position will size from the left.
            SizingBottom,		//!< Position will size from the bottom.
            SizingRight         //!< Position will size from the right.
        };
        */
        
        public static const SizingLocation_SizingNone:uint              = 0;
        public static const SizingLocation_SizingTopLeft:uint           = 1;
        public static const SizingLocation_SizingTopRight:uint          = 2;
        public static const SizingLocation_SizingBottomLeft:uint        = 3;
        public static const SizingLocation_SizingBottomRight:uint       = 4;
        public static const SizingLocation_SizingTop:uint               = 5;
        public static const SizingLocation_SizingLeft:uint              = 6;
        public static const SizingLocation_SizingBottom:uint            = 7;
        public static const SizingLocation_SizingRight:uint             = 8;
        
        /*!
        \brief
        Enumerated type specifying possible input and/or display modes for the spinner.
        */
        /*
        enum TextInputMode
        {
            FloatingPoint,  //!< Floating point decimal.
            Integer,        //!< Integer decimal.
            Hexadecimal,    //!< Hexadecimal.
            Octal           //!< Octal
        };
        */
        public static const TextInputMode_FloatingPoint:int            = 0;
        public static const TextInputMode_Integer:int                  = 1;
        public static const TextInputMode_Hexadecimal:int              = 2;
        public static const TextInputMode_Octal:int                    = 3;
        
        /*!
        \brief
        Enumeration of possible values for sorting direction used with ListHeaderSegment classes
        */
        /*
        enum SortDirection
        {
            None,		//!< Items under this segment should not be sorted.
            Ascending,	//!< Items under this segment should be sorted in ascending order.
            Descending	//!< Items under this segment should be sorted in descending order.
        };
        */
        public static const SortDirection_None:uint                     = 0;
        public static const SortDirection_Ascending:uint                = 1;
        public static const SortDirection_Descending:uint               = 2;
        
        /**
         * enumerates auto positioning methods for the grid - these allow you to
         * fill the grid without specifying gridX and gridY positions for each
         * addChildWindow.
         */
        
//        enum AutoPositioning
//        {
//            //! no auto positioning!
//            AP_Disabled,
//            /**
//             * Left to right positioning:
//             * - 1 2 3
//             * - 4 5 6
//             */
//            AP_LeftToRight,
//            /**
//             * Top to bottom positioning
//             * - 1 3 5
//             * - 2 4 6
//             */
//            AP_TopToBottom
//        };
        public static const AutoPositioning_AP_Disabled:uint            = 0;
        public static const AutoPositioning_AP_LeftToRight:uint         = 1;
        public static const AutoPositioning_AP_TopToBottom:uint         = 2;
        
        
        /*!
        \brief
        Sort modes for ItemListBase
        */
        /*
        enum SortMode
        {
            Ascending,
            Descending,
            UserSort
        };
        */
        public static const SortMode_Ascending:uint                     = 0;
        public static const SortMode_Descending:uint                    = 1;
        public static const SortMode_UserSort:uint                      = 2;
        
        
        /*!
        \brief
        Enumerated values for the selection modes possible with a Multi-column list
        */
        /*
        enum SelectionMode
        {
            RowSingle,					// Any single row may be selected.  All items in the row are selected.
            RowMultiple,				// Multiple rows may be selected.  All items in the row are selected.
            CellSingle,					// Any single cell may be selected.
            CellMultiple,				// Multiple cells bay be selected.
            NominatedColumnSingle,		// Any single item in a nominated column may be selected.
            NominatedColumnMultiple,	// Multiple items in a nominated column may be selected.
            ColumnSingle,				// Any single column may be selected.  All items in the column are selected.
            ColumnMultiple,				// Multiple columns may be selected.  All items in the column are selected.
            NominatedRowSingle,			// Any single item in a nominated row may be selected.
            NominatedRowMultiple		// Multiple items in a nominated row may be selected.
        };
        */
        public static const SelectionMode_RowSingle:uint                = 0;
        public static const SelectionMode_RowMultiple:uint              = 1;
        public static const SelectionMode_CellSingle:uint               = 2;
        public static const SelectionMode_CellMultiple:uint             = 3;
        public static const SelectionMode_NominatedColumnSingle:uint    = 4;
        public static const SelectionMode_NominatedColumnMultiple:uint  = 5;
        public static const SelectionMode_ColumnSingle:uint             = 6;
        public static const SelectionMode_ColumnMultiple:uint           = 7;
        public static const SelectionMode_NominatedRowSingle:uint       = 8;
        public static const SelectionMode_NominatedRowMultiple:uint     = 9;
        
        /*
        enum TabPanePosition
        {
            Top,
            Bottom
        };
        */
        public static const TabPanePosition_Top:uint                    = 0;
        public static const TabPanePosition_Bottom:uint                 = 1;
        
        
        //! enumerates possible replay modes
        /*
        enum ReplayMode
        {
            //! plays the animation just once, then stops
            RM_Once,
            //! loops the animation infinitely
            RM_Loop,
//             infinitely plays the animation forward, when it reaches the end, it
//             * plays it backwards, etc...
//             
            RM_Bounce
        };*/
        
        public static const ReplayMode_RM_Once:uint                     = 0;
        public static const ReplayMode_RM_Loop:uint                     = 1;
        public static const ReplayMode_RM_Bounce:uint                   = 2;
        
        /*
        //! enumerates the possible methods of application
        enum ApplicationMethod
        {
            //! applies values as absolutes
            AM_Absolute,
            
            * saves a base value after the animation is started and applies
             * relatively to that
             
            AM_Relative,
            
            * saves a base value after the animation is started and applies
             * by multiplying this base value with key frame floats
             
            AM_RelativeMultiply
        };
        */
        
        public static const ApplicationMethod_AM_Absolute:uint              = 0;
        public static const ApplicationMethod_AM_Relative:uint              = 1;
        public static const ApplicationMethod_AM_RelativeMultiply:uint      = 2;
        
        
        //! enumerates possible progression methods, IE how the value progresses
        //! TOWARS this key frames, this means that progression method of the first
        //! key frame won't be used for anything!
        /*
        enum Progression
        {
            //! linear progression
            P_Linear,
            //! progress is accelerated, starts slow and speeds up
            P_QuadraticAccelerating,
            //! progress is decelerated, starts fast and slows down
            P_QuadraticDecelerating,
            ** left neighbour's value is picked if interpolation position is lower
             * than 1.0, right is only picked when interpolation position is exactly
             * 1.0
             *
            P_Discrete
        };
        */
        public static const Progression_P_Linear:uint                           = 0;
        public static const Progression_P_QuadraticAccelerating:uint            = 1;
        public static const Progression_P_QuadraticDecelerating:uint            = 2;
        public static const Progression_P_Discrete:uint                         = 3;

    }
}