package classes.model.transactions
{
    import classes.model.*;
    import classes.view.components.map.*;

    public class ToggleAutomationCall extends TransactionBody
    {

        public function ToggleAutomationCall(value:MapObject)
        {
            var params:Object = new Object();
            params.id = value.id;
            params.x = value.grid_x;
            params.y = value.grid_y;
            super("toggle_automation", "save_data", params);
        }

    }
}
