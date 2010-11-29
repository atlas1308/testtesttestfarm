package classes.model.transactions
{
    import classes.model.*;

    public class AddPlantCall extends TransactionBody
    {

        public function AddPlantCall(value:Object)
        {
            var params:Object = new Object();
            params.unique_id = value.map_unique_id;
            params.plant_id = value.plant.id;
            params.soil_x = value.soil.grid_x;
            params.soil_y = value.soil.grid_y;
            if (value.soil.greenhouse)
            {
                params.greenhouse_id = value.soil.greenhouse.id;
                params.greenhouse_x = value.soil.greenhouse.grid_x;
                params.greenhouse_y = value.soil.greenhouse.grid_y;
            }
            super("add_plant", "save_data", params);
        }

    }
}
