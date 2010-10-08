package classes.model.transactions
{
    import classes.model.*;
    import classes.view.components.map.*;
    
    import tzh.core.FeedData;
    import tzh.core.JSDataManager;

    public class CollectProductCall extends TransactionBody
    {

        public function CollectProductCall(value:MapObject)
        {
            var params:Object = new Object();
            params.unique_id = value.map_unique_id;
            params.id = value.id;
            params.x = value.grid_x;
            params.y = value.grid_y;
            super("collect_product", "save_data", params);
        }
    }
}
