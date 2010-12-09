package classes.model.transactions
{
    import classes.model.*;

    public class LoadNeighborsCall extends TransactionBody
    {

        public function LoadNeighborsCall(value:Array)
        {
            var params:Object = new Object();
            params.list = value;
            super("load_neighbors", "load_neighbors", params);
        }

    }
}
