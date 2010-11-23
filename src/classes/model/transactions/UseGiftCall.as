package classes.model.transactions
{
    import classes.model.*;

    public class UseGiftCall extends TransactionBody
    {

        public function UseGiftCall(id:Number, value:Object = null)
        {
            var params:Object = new Object();
            params.id = id;
            if (value)
            {
                params.target_id = value.id;
                params.target_x = value.x;
                params.target_y = value.y;
            }
            super("use_gift", "save_data", params);
        }

    }
}
