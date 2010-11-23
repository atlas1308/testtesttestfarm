package classes.model.transactions
{
    import classes.model.*;

    public class LoadFarmCall extends TransactionBody
    {

        public function LoadFarmCall(value:String)
        {
            var params:Object = new Object();
            params.id = value;
            super("load_farm", "load_farm", params);
        }

    }
}
