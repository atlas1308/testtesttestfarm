package classes.model.transactions
{
    import classes.model.*;

    public class WaterPlantsCall extends TransactionBody
    {

        public function WaterPlantsCall(value:Number)
        {
            var params:Object = new Object();
            params.id = value;
            super("water_plants", "save_data", params);
        }

    }
}
