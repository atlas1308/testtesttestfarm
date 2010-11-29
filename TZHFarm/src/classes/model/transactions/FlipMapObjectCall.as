package classes.model.transactions
{
    import classes.model.*;
    import classes.view.components.map.*;

    public class FlipMapObjectCall extends TransactionBody
    {

        public function FlipMapObjectCall(mapObject:MapObject)
        {
            var params:Object = new Object();
            params.id = mapObject.id;
            params.x = mapObject.grid_x;
            params.y = mapObject.grid_y;
            super("flip_object", "save_data", params);
        }

    }
}
