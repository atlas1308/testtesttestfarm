package classes.model.transactions
{
    import classes.model.*;
    import classes.view.components.map.*;

    public class RemoveMapObjectCall extends TransactionBody
    {

        public function RemoveMapObjectCall(value:MapObject)
        {
            var params:Object = new Object();
            params.id = value.id;
            params.x = value.map_x;
            params.y = value.map_y;
            params.flip = value.map_flip_state ? (1) : (0);
            super("remove_object", "save_data", params);
        }

    }
}
