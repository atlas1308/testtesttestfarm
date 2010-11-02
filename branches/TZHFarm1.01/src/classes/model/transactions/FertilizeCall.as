package classes.model.transactions
{
    import classes.model.*;

    public class FertilizeCall extends TransactionBody
    {

        public function FertilizeCall(value:Object)
        {
            var params:Object = new Object();
            params.id = value.fertilizer.id;
            params.x = value.fertilizer.grid_x;
            params.y = value.fertilizer.grid_y;
            params.plant_x = value.plant.grid_x;
            params.plant_y = value.plant.grid_y;
            params.plant_id = value.plant.id;
            super("fertilize", "save_data", params);
        }

    }
}
