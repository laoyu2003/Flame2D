
/*!
\brief
Property to access the selection mode setting of the list.

\par Usage:
- Name: SelectionMode
- Format: "[text]"

\par Where [Text] is one of:
- "RowSingle"
- "RowMultiple"
- "CellSingle"
- "CellMultiple"
- "NominatedColumnSingle"
- "NominatedColumnMultiple"
- "ColumnSingle"
- "ColumnMultiple"
- "NominatedRowSingle"
- "NominatedRowMultiple"
*/
package Flame2D.elements.list
{
    import Flame2D.core.properties.FlameProperty;
    import Flame2D.core.data.Consts;
    
    public class MultiColumnListPropertySelectionMode extends FlameProperty
    {
        public function MultiColumnListPropertySelectionMode()
        {
            super(
                "SelectionMode",
                "Property to get/set the selection mode setting of the list.  Value is the text of one of the SelectionMode enumerated value names.",
                "RowSingle");
        }
        
        override public function getValue(receiver:*):String
        {
            switch((receiver as FlameMultiColumnList).getSelectionMode())
            {
                case Consts.SelectionMode_RowMultiple:
                    return String("RowMultiple");
                    break;
                
                case Consts.SelectionMode_ColumnSingle:
                    return String("ColumnSingle");
                    break;
                
                case Consts.SelectionMode_ColumnMultiple:
                    return String("ColumnMultiple");
                    break;
                
                case Consts.SelectionMode_CellSingle:
                    return String("CellSingle");
                    break;
                
                case Consts.SelectionMode_CellMultiple:
                    return String("CellMultiple");
                    break;
                
                case Consts.SelectionMode_NominatedColumnSingle:
                    return String("NominatedColumnSingle");
                    break;
                
                case Consts.SelectionMode_NominatedColumnMultiple:
                    return String("NominatedColumnMultiple");
                    break;
                
                case Consts.SelectionMode_NominatedRowSingle:
                    return String("NominatedRowSingle");
                    break;
                
                case Consts.SelectionMode_NominatedRowMultiple:
                    return String("NominatedRowMultiple");
                    break;
                
                default:
                    return String("RowSingle");
                    break;
            }
        }
        
        
        override public function setValue(receiver:*, value:String):void
        {
            var mode:uint;
            
            if (value == "RowMultiple")
            {
                mode = Consts.SelectionMode_RowMultiple;
            }
            else if (value == "ColumnSingle")
            {
                mode = Consts.SelectionMode_ColumnSingle;
            }
            else if (value == "ColumnMultiple")
            {
                mode = Consts.SelectionMode_ColumnMultiple;
            }
            else if (value == "CellSingle")
            {
                mode = Consts.SelectionMode_CellSingle;
            }
            else if (value == "CellMultiple")
            {
                mode = Consts.SelectionMode_CellMultiple;
            }
            else if (value == "NominatedColumnSingle")
            {
                mode = Consts.SelectionMode_NominatedColumnSingle;
            }
            else if (value == "NominatedColumnMultiple")
            {
                mode = Consts.SelectionMode_NominatedColumnMultiple;
            }
            else if (value == "NominatedRowSingle")
            {
                mode = Consts.SelectionMode_NominatedRowSingle;
            }
            else if (value == "NominatedRowMultiple")
            {
                mode = Consts.SelectionMode_NominatedRowMultiple;
            }
            else
            {
                mode = Consts.SelectionMode_RowSingle;
            }
            
            (receiver as FlameMultiColumnList).setSelectionMode(mode);
        }

    }
}