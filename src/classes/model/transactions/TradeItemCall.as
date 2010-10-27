package classes.model.transactions
{
    import classes.model.*;

    public class TradeItemCall extends TransactionBody
    {

        public function TradeItemCall(id:Number, xx:Number = -1, yy:Number = -1)
        {
            var obj:Object = new Object();
            obj.id = id;
            /* if (xx > -1)
            {
                obj.x = xx;
            }
            if (yy > -1)
            {
                obj.y = yy;
            } */
            super("trade_item", "save_data", obj);
        }

    }
}
