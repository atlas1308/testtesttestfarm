package classes.model.transactions
{
    import classes.model.*;
    import classes.view.components.map.*;

    public class AddAnimalCall extends TransactionBody
    {

        public function AddAnimalCall(mapObject:MapObject, is_gift:Boolean)
        {
            var params:Object = new Object();
            params.id = mapObject.id;
            params.x = mapObject.grid_x;
            params.y = mapObject.grid_y;
            params.is_gift = is_gift ? 1 : 0;
            super("add_animal", "save_data", params);
        }

    }
}
