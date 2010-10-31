package classes.model.transactions
{
    import classes.model.*;

    public class SendGiftCall extends TransactionBody
    {

        public function SendGiftCall(value:Object)
        {
            var params:Object = new Object();
            params.neighbor = value.neighbor;
            params.gift = value.gift;
            params.type = value.type;
            super("purchase_gift", "purchase_gift", params);
        }

    }
}
