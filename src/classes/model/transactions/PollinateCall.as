package classes.model.transactions
{
    import classes.model.*;

    public class PollinateCall extends TransactionBody
    {

        public function PollinateCall(value:Object)
        {
            var params:Object = new Object();
            params.id = value.hive.id;
            params.x = value.hive.grid_x;
            params.y = value.hive.grid_y;
            params.plant_x = value.target.grid_x;
            params.plant_y = value.target.grid_y;
            params.plant_id = value.target.id;
            super("pollinate", "save_data", params);
        }

    }
}
