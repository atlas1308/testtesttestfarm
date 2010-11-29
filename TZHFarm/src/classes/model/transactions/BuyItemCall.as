package classes.model.transactions
{
    import classes.model.*;

    public class BuyItemCall extends TransactionBody
    {

        public function BuyItemCall(value:Number)
        {
            var params:Object = new Object();
            params.id = value;
            super("buy_item", "save_data", params);
        }

    }
}
