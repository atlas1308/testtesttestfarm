package classes.model.transactions
{
    import classes.model.*;

    public class PostPublishedCall extends TransactionBody
    {

        public function PostPublishedCall(type:String, tag:String, subtype:String, story_id:String = "", target:Number = 0)
        {
            var params:Object = new Object();
            params.type = type;
            params.tag = tag;
            params.subtype = subtype;
            params.story_id = story_id;
            params.target = target;
            Log.add("post published " + target);
            super("post_published", "post_published", params);
        }

    }
}
