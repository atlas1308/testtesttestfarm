package classes.model.transactions
{
    import classes.model.*;

    public class RefillMapObjectCall extends TransactionBody
    {

        public function RefillMapObjectCall(value:Object)
        {
            var params:Object = new Object();
            params.unique_id = value.obj.map_unique_id;
            params.id = value.obj.id;
            params.x = value.obj.grid_x;
            params.y = value.obj.grid_y;
            params.raw_material = value.raw_material;
            
            super("refill_object", "save_data", params);
        }

    }
}
