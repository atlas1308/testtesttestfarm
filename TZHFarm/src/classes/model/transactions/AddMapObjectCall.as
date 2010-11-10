package classes.model.transactions
{
    import classes.model.*;
    import classes.view.components.map.*;

    public class AddMapObjectCall extends TransactionBody
    {

        public function AddMapObjectCall(mapObject:MapObject, is_gift:Boolean)
        {
            var params:Object = new Object();
            params.id = mapObject.id;
            params.x = mapObject.grid_x;
            params.y = mapObject.grid_y;
            params.is_gift = is_gift ? 1 : 0;
            params.flip = mapObject.is_flipped_from_store() ? 1 : 0;
            super("add_object", "save_data", params);
        }

    }
}
