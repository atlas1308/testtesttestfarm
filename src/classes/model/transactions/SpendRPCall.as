package classes.model.transactions
{
    import classes.model.*;

    public class SpendRPCall extends TransactionBody
    {

        public function SpendRPCall(id:Number, value:Object = null)
        {
            var params:Object = new Object();
            params.id = id;
            if (value)
            {
                params.target_id = value.id;
                params.target_x = value.x;
                params.target_y = value.y;
            }
            super("spend_rp", "save_data", params);
        }

    }
}
