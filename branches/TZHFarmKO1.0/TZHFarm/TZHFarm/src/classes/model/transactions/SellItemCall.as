package classes.model.transactions
{
    import classes.model.*;

    public class SellItemCall extends TransactionBody
    {

        public function SellItemCall(id:Number, xx:Number = -1, yy:Number = -1)
        {
            var obj:Object = new Object();
            obj.id = id;
            if (xx > -1)
            {
                obj.x = xx;
            }
            if (yy > -1)
            {
                obj.y = yy;
            }
            super("sell_item", "save_data", obj);
        }

    }
}
