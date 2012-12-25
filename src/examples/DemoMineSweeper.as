

package examples {
    import Flame2D.core.data.Consts;
    import Flame2D.core.data.Subscriber;
    import Flame2D.core.events.EventArgs;
    import Flame2D.core.events.MouseEventArgs;
    import Flame2D.core.events.WindowEventArgs;
    import Flame2D.core.properties.FlamePropertyHelper;
    import Flame2D.core.system.FlameEvent;
    import Flame2D.core.system.FlameImageSetManager;
    import Flame2D.core.system.FlameMouseCursor;
    import Flame2D.core.system.FlameSystem;
    import Flame2D.core.system.FlameWindow;
    import Flame2D.core.system.FlameWindowFactory;
    import Flame2D.core.system.FlameWindowFactoryManager;
    import Flame2D.core.system.FlameWindowManager;
    import Flame2D.core.utils.Misc;
    import Flame2D.core.utils.UDim;
    import Flame2D.core.utils.URect;
    import Flame2D.core.utils.UVector2;
    import Flame2D.elements.button.FlamePushButton;
    import Flame2D.elements.editbox.FlameEditbox;
    import Flame2D.elements.timer.FlameTimer;
    import Flame2D.elements.window.FlameFrameWindow;
    import Flame2D.elements.window.FlameGUISheet;
    
    import flash.events.KeyboardEvent;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    import examples.base.BaseApplication;
    
    
    [SWF(width="800", height="600", frameRate="60")]
    public class DemoMineSweeper extends BaseApplication
    {
        
        private const MinesweeperSize:uint = 10;
        private const MineCount:uint = 15;

        //CEGUI::PushButton* d_buttons[MinesweeperSize][MinesweeperSize];
        protected var d_buttons:Array = new Array(MinesweeperSize);
        // Store button location
        //Location d_buttonsMapping[MinesweeperSize][MinesweeperSize];
        protected var d_buttonsMapping:Array = new Array(MinesweeperSize);
        // Store the value of the board itself
        //size_t d_board[MinesweeperSize][MinesweeperSize];
        protected var d_board:Array = new Array(MinesweeperSize);
        // Store the number of case the user discovered
        protected var d_boardCellDiscovered:uint;
        // Store the number of mine to find
        protected var d_counter:FlameEditbox;
        // Store the number of second elapsed
        protected var d_timer:FlameEditbox;
        // Used to display the result text
        protected var d_result:FlameWindow;
        
        // True if the game is started false otherwise
        protected var d_gameStarted:Boolean;
        // time at the start of the game
        protected var d_timerStartTime:int;
        // current value of the timer
        protected var d_timerValue:int;
        // Custom window type to force refresh of the timer
        protected var d_alarm:FlameTimer;
        
        
        override protected function initApp():void
        {
            FlameWindowFactoryManager.getSingleton().addFactory(new FlameWindowFactory(FlameTimer));
            
            d_gameStarted = false;

            
            // Now the system is initialised, we can actually create some UI elements, for
            // this first example, a full-screen 'root' window is set as the active GUI
            // sheet, and then a simple frame window will be created and attached to it.
            
            // All windows and widgets are created via the WindowManager singleton.
            var winMgr:FlameWindowManager = FlameWindowManager.getSingleton();
            
            FlameMouseCursor.getSingleton().initialize();
            //FlameMouseCursor.getSingleton().setImageByImageSet("TaharezLook", "MouseMoveCursor");
            FlameSystem.getSingleton().setDefaultMouseCursor(
                FlameImageSetManager.getSingleton().getImageSet("TaharezLook").getImage("MouseArrow"));
            
            // here we will use a StaticImage as the root, then we can use it to place a background image
            var background:FlameWindow = winMgr.createWindow("TaharezLook/StaticImage", "root_wnd");
            
            // set position and size
            background.setPosition(new UVector2(Misc.cegui_reldim(0), Misc.cegui_reldim( 0)));
            background.setSize(new UVector2(Misc.cegui_reldim(1), Misc.cegui_reldim( 1)));
            
            // disable frame and standard background
            background.setProperty("FrameEnabled", "false");
            background.setProperty("BackgroundEnabled", "false");
            
            // set the background image
            background.setProperty("Image", "set:BackgroundImage image:full_image");
            
            
            // install this as the root GUI sheet
            FlameSystem.getSingleton().setGUISheet(background);
            
            d_alarm = winMgr.createWindow("Timer") as FlameTimer;
            background.addChildWindow(d_alarm);
            d_alarm.setDelay(0.5); // Tick each 0.5 seconds
            
            // create the game frame
            var frame:FlameFrameWindow = winMgr.createWindow("Vanilla/FrameWindow") as FlameFrameWindow;
            d_alarm.addChildWindow(frame);
            frame.setXPosition(new UDim(0.3, 0.0));
            frame.setYPosition(new UDim(0.15, 0.0));
            frame.setWidth(new UDim(0.4, 0.0)); 
            frame.setHeight(new UDim(0.7, 0.0)); 
            //the next line should be removed when autorenderingsurface supported.
            frame.setProperty("AutoRenderingSurface", "False");
            frame.setText("CEGUI Minesweeper");
            
            // create the action panel
            var action:FlameWindow = winMgr.createWindow("DefaultWindow");
            frame.addChildWindow(action);
            action.setXPosition(new UDim(0.03, 0.0));
            action.setYPosition(new UDim(0.10, 0.0));
            action.setWidth(new UDim(0.94, 0.0));
            action.setHeight(new UDim(0.1, 0.0));
            d_counter = winMgr.createWindow("Vanilla/Editbox", "mine_counter") as FlameEditbox;
            action.addChildWindow(d_counter);
            d_counter.setText("0");
            d_counter.setTooltipText("Number of mine");
            d_counter.setReadOnly(true);
            d_counter.setXPosition(new UDim(0.0, 0.0));
            d_counter.setYPosition(new UDim(0.0, 0.0));
            d_counter.setWidth(new UDim(0.3, 0.0));
            d_counter.setHeight(new UDim(1.0, 0.0));
            
            var newGame:FlameWindow = winMgr.createWindow("Vanilla/Button", "new_game");
            action.addChildWindow(newGame);
            newGame.setText("Start");
            newGame.setTooltipText("Start a new game");
            newGame.setXPosition(new UDim(0.35, 0.0));
            newGame.setYPosition(new UDim(0.0, 0.0));
            newGame.setWidth(new UDim(0.3, 0.0));
            newGame.setHeight(new UDim(1.0, 0.0));
            newGame.subscribeEvent(FlamePushButton.EventClicked,  new Subscriber(handleGameStartClicked, this), FlamePushButton.EventNamespace);
            
            d_timer = winMgr.createWindow("Vanilla/Editbox", "timer") as FlameEditbox;
            action.addChildWindow(d_timer);
            d_timer.setText("0");
            d_timer.setTooltipText("Time elapsed");
            d_timer.setReadOnly(true);
            d_timer.setXPosition(new UDim(0.7, 0.0));
            d_timer.setYPosition(new UDim(0.0, 0.0));
            d_timer.setWidth(new UDim(0.3, 0.0));
            d_timer.setHeight(new UDim(1.0, 0.0));
            d_alarm.subscribeEvent(FlameTimer.EventTimerAlarm, new Subscriber(handleUpdateTimer, this), FlameTimer.EventNamespace);
            
            // Board button grid
            var grid:FlameWindow = winMgr.createWindow("DefaultWindow");
            grid.setXPosition(new UDim(0.03, 0.0));
            grid.setYPosition(new UDim(0.23, 0.0));
            grid.setWidth(new UDim(0.94, 0.0));
            grid.setHeight(new UDim(0.74, 0.0));
            const d_inc:Number = 1.0 / MinesweeperSize; 
            for(var i:uint = 0 ; i < MinesweeperSize ; ++i)
            {
                // create a container for each row
                var row:FlameWindow = winMgr.createWindow("DefaultWindow");
                row.setAreaByURect(new URect( new UVector2(new UDim(0,0), new UDim(d_inc * i, 0)),
                    new UVector2(new UDim(1,0), new UDim(d_inc * (i + 1), 0))));
                grid.addChildWindow(row);
                
                d_buttonsMapping[i] = new Array(MinesweeperSize);
                d_buttons[i] = new Array(MinesweeperSize);
                
                for(var j:uint = 0 ; j < MinesweeperSize ; ++j)
                {
                    d_buttonsMapping[i][j] = new Location();
                    // Initialize buttons coordinate
                    d_buttonsMapping[i][j].d_col = j;
                    d_buttonsMapping[i][j].d_row = i;
                    
                    d_buttons[i][j] = winMgr.createWindow("Vanilla/Button") as FlamePushButton;
                    row.addChildWindow(d_buttons[i][j]);
                    d_buttons[i][j].setAreaByURect(new URect(new UVector2(new UDim(d_inc * j, 0), new UDim(0,0)),
                        new UVector2(new UDim(d_inc * (j + 1), 0), new UDim(1,0))));
                    d_buttons[i][j].setEnabled(false);
                    // Associate user data
                    d_buttons[i][j].setUserData(d_buttonsMapping[i][j]);
                    d_buttons[i][j].setID(0);
                    // Connect event handlers
                    d_buttons[i][j].subscribeEvent(FlamePushButton.EventClicked, new Subscriber(handleMineButtonClicked, this), FlamePushButton.EventNamespace);
                    d_buttons[i][j].subscribeEvent(FlameWindow.EventMouseButtonDown, new Subscriber(handleMineButtonDown, this), FlameWindow.EventNamespace);
                }
            }
            d_result = winMgr.createWindow("Vanilla/StaticText");
            grid.addChildWindow(d_result);
            d_result.setXPosition(new UDim(0.0, 0.0));
            d_result.setYPosition(new UDim(0.0, 0.0));
            d_result.setWidth(new UDim(1.0, 0.0));
            d_result.setHeight(new UDim(1.0, 0.0));
            d_result.setAlwaysOnTop(true);
            d_result.setProperty("HorzFormatting", "HorzCentred");
            d_result.setVisible(false);
            d_result.setAlpha(0.67);
            
            frame.addChildWindow(grid);

            // activate the background window
            background.activate();
            
            FlameSystem.getSingleton().signalRedraw();
        }
        
        /*************************************************************************
         Handle new game started event
         *************************************************************************/
        private function handleGameStartClicked(e:EventArgs):Boolean
        {
            d_result.setVisible(false);
            boardReset();
            boardPositionMines();
            for (var i:uint = 0 ; i < MinesweeperSize ; ++i)
            {
                for(var j:uint = 0 ; j < MinesweeperSize ; ++j)
                {
                    d_buttons[i][j].setProperty("DisabledTextColour", "FF000000");
                    d_buttons[i][j].setText("");
                    d_buttons[i][j].setEnabled(true);
                }
            }
            d_counter.setText(FlamePropertyHelper.uintToString(MineCount));
            // Handle timer
            d_timerStartTime = getTimer();
            d_timerValue = 0;
            d_timer.setText("0");
            d_gameStarted = true;
            d_alarm.start();
            return true;
        }

        /************************************************************************
         Handle click on a mine button
         ************************************************************************/
        private function handleMineButtonClicked(event:EventArgs):Boolean
        {
            const evt:WindowEventArgs = WindowEventArgs(event);
            var button:FlamePushButton = FlamePushButton(evt.window);
            var buttonLoc:Location = Location(button.getUserData());
            if (button.getID() > 0)
            {
                // dont touch flagged buttons
                return true;
            }
            if (boardDiscover(buttonLoc))
            {
                // We did not find a mine
                button.setText(FlamePropertyHelper.uintToString(d_board[buttonLoc.d_row][buttonLoc.d_col]));
                if (isGameWin())
                    gameEnd(true);
            }
            else
            {
                for(var i:uint = 0 ; i < MinesweeperSize ; ++i)
                {
                    for (var j:uint = 0 ;  j < MinesweeperSize ; ++j)
                    {
                        if (! d_buttons[i][j].isDisabled())
                        {
                            if (d_board[i][j] > 8)
                            {
                                d_buttons[i][j].setText("B");
                                d_buttons[i][j].setProperty("DisabledTextColour", "FFFF1010");
                            }
                            else
                            {
                                d_buttons[i][j].setText(FlamePropertyHelper.uintToString(d_board[i][j]));
                            }
                        }
                        d_buttons[i][j].setEnabled(false);
                    }
                }
                gameEnd(false);
            }
            return true;
        }
        /************************************************************************
         Handle click on a mine button (any mouse button)
         ************************************************************************/
        private function handleMineButtonDown(event:EventArgs):Boolean
        {
            const me:MouseEventArgs = MouseEventArgs(event);
            if (me.button == Consts.MouseButton_RightButton)
            {
                var button:FlameWindow = me.window;
                if (!button.isDisabled())
                {
                    if (button.getID() == 0)
                    {
                        button.setID(1);
                        button.setText("F");
                    }
                    else
                    {
                        button.setID(0);
                        button.setText("");
                    }
                    return true;
                }
            }
            return false;
        }
        
        /***********************************************************************
         Handle timer refresh
         ***********************************************************************/
        private function handleUpdateTimer(e:EventArgs):Boolean
        {
            if (d_gameStarted)
            {
                var time:int = getTimer();
                time -= d_timerStartTime;
                if (time != d_timerValue)
                {
                    d_timer.setText(FlamePropertyHelper.uintToString(time /  1000));
                    d_timerValue = time;
                }
            }
            return true;
        }
        
        /************************************************************************
         Create the board
         ************************************************************************/
        private function boardReset():void
        {
            d_boardCellDiscovered = 0;
            for(var i:uint = 0 ; i < MinesweeperSize ; ++i)
            {
                d_board[i] = new Array(MinesweeperSize);
                
                for(var j:uint = 0 ; j < MinesweeperSize ; ++j)
                {
                    d_board[i][j] = null;
                }
            }
        }
        
        /************************************************************************
         Position mine on the board
         ************************************************************************/
        private function boardPositionMines():void
        {
            var x:uint = 0 ;
            var y:uint = 0 ;
//            ::srand(::clock());
            for(var i:uint = 0 ; i < MineCount ; ++i)
            {
                do
                {
                    x = MinesweeperSize * Math.random();
                    y = MinesweeperSize * Math.random();
                }
                while(d_board[x][y] > 8);
                
                d_board[x][y] += 10;
                if (x > 0)
                {
                    if (y > 0)
                        ++ d_board[x - 1][y - 1];
                    
                    ++ d_board[x - 1][y    ];
                    
                    if (y < MinesweeperSize - 1)
                        ++ d_board[x - 1][y + 1];
                }
                
                if (y > 0)
                    ++ d_board[x    ][y - 1];
                
                if (y < MinesweeperSize - 1)
                    ++ d_board[x    ][y + 1];
                
                if (x < MinesweeperSize - 1)
                {
                    if (y > 0)
                        ++ d_board[x + 1][y - 1];
                    
                    ++ d_board[x + 1][y    ];
                    
                    if (y < MinesweeperSize - 1)
                        ++ d_board[x + 1][y + 1];
                }
            }
        }        
        /************************************************************************
         Check wether the game is won or not
         ************************************************************************/
        
        private function isGameWin():Boolean
        {
            return d_boardCellDiscovered + MineCount == MinesweeperSize * MinesweeperSize;
        }
        
        
        private function gameEnd(victory:Boolean):void
        {
            d_gameStarted = false;
            d_alarm.stop();
            var message:String;
            if (victory)
            {
                message = "You win";
            }
            else
            {
                message = "You lose";
            }
            // Display a message to the user
            d_result.setText(message);
            d_result.setVisible(true);
        }
        
        private function boardDiscover(loc:Location):Boolean
        {
            var btn:FlamePushButton = d_buttons[loc.d_row][loc.d_col];
            if (btn.isDisabled() || btn.getID() > 0)
                return true;
            
            if (d_board[loc.d_row][loc.d_col] > 8)
                return false;
            d_buttons[loc.d_row][loc.d_col].setText(FlamePropertyHelper.uintToString(d_board[loc.d_row][loc.d_col]));
            d_buttons[loc.d_row][loc.d_col].setEnabled(false);
            ++d_boardCellDiscovered;
            // Discover surrounding case
            if (d_board[loc.d_row][loc.d_col] == 0)
            {
                var l:Location = new Location();
                if (loc.d_row > 0)
                {
                    l.d_row = loc.d_row - 1;
                    if ( loc.d_col > 0)
                    {
                        l.d_col = loc.d_col - 1;
                        boardDiscover(l);
                    }
                    l.d_col = loc.d_col;
                    boardDiscover(l);
                    if ( loc.d_col < MinesweeperSize - 1)
                    {
                        l.d_col = loc.d_col + 1;
                        boardDiscover(l);
                    }
                }
                l.d_row = loc.d_row;
                if ( loc.d_col > 0)
                {
                    l.d_col = loc.d_col - 1;
                    boardDiscover(l);
                }
                if ( loc.d_col < MinesweeperSize  - 1)
                {
                    l.d_col = loc.d_col + 1;
                    boardDiscover(l);
                }
                if (loc.d_row < MinesweeperSize - 1)
                {
                    l.d_row = loc.d_row + 1;
                    if ( loc.d_col > 0)
                    {
                        l.d_col = loc.d_col - 1;
                        boardDiscover(l);
                    }
                    l.d_col = loc.d_col;
                    boardDiscover(l);
                    if ( loc.d_col < MinesweeperSize - 1)
                    {
                        l.d_col = loc.d_col + 1;
                        boardDiscover(l);
                    }
                }
            }
            return true;
        }
    }
}


class Location
{
    public var d_row:uint;
    public var d_col:uint;
}

