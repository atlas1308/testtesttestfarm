package classes.model.transactions
{
    import classes.model.*;

    public class SellAllStorageCall extends TransactionBody
    {

        public function SellAllStorageCall()
        {
            var params:Object = new Object();
            super("sell_all_storage", "save_data", params);
        }

    }
}
