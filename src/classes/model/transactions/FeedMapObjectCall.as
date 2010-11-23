package classes.model.transactions
{
    import classes.model.*;
    import classes.view.components.map.*;

    public class FeedMapObjectCall extends TransactionBody
    {

        public function FeedMapObjectCall(value:MapObject)
        {
            var params:Object = new Object();
            params.unique_id = value.map_unique_id;
            params.id = value.id;
            params.x = value.grid_x;
            params.y = value.grid_y;
            super("feed_object", "save_data", params);
        }

    }
}
