package classes.model.transactions
{
    import classes.model.*;

    public class SellStorageItemCall extends TransactionBody
    {
		
		/**
		 * 需要对qty的这个值进行验证
		 */ 
        public function SellStorageItemCall(value:Object)
        {
            var params:Object = new Object();
            params.id = value.id;
            params.qty = value.qty;
            super("sell_storage_item", "save_data", params);
        }

    }
}
