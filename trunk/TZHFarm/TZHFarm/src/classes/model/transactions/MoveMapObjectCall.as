package classes.model.transactions
{
    import classes.model.*;
    import classes.view.components.map.*;
    
    import com.adobe.serialization.json.JSON;

    public class MoveMapObjectCall extends TransactionBody
    {

        public function MoveMapObjectCall(mapObject:MapObject)
        {
            var params:Object = new Object();
            params.id = mapObject.id;
            params.new_x = mapObject.grid_x;
            params.new_y = mapObject.grid_y;
            params.x = mapObject.map_x;
            params.y = mapObject.map_y;
            params.flip = mapObject.map_flip_state ? (1) : (0);// 当前的方向,这个是需要验证的,用户初始化进来的状态
            params.flipped = mapObject.is_flipped() ? (1) : (0);
            if(mapObject is Greenhouse){
            	//if(Greenhouse(mapObject).allMapsSaveObject && Greenhouse(mapObject).allMapsSaveObject.length > 0){
            		params.plants = JSON.encode(Greenhouse(mapObject).allMapsSaveObject);// 把原来的数据清掉,更新start_time
            	//}
            }
            if (mapObject.greenhouse)
            {
                params.greenhouse_id = mapObject.greenhouse.id;
                params.greenhouse_x = mapObject.greenhouse.grid_x;
                params.greenhouse_y = mapObject.greenhouse.grid_y;
            }
            super("move_object", "save_data", params);
        }

    }
}
