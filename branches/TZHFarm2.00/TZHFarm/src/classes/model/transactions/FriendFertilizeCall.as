package classes.model.transactions
{
	import classes.model.TransactionBody;
	
	/**
	 * FriendFertilizeCall 帮助好友施肥的功能
	 * @param value:Object 
	 * 
	 */ 
	public class FriendFertilizeCall extends TransactionBody
	{
		public function FriendFertilizeCall(value:Object)
		{
			var params:Object = new Object();
			params.friend_id = value.friend_id;
            //params.id = value.fertilizer.id;// 这个数据是后台传递过来的
            //params.percent = value.fertilizer.percent;// 这个数据也是后台传递过来的
            params.friendName = value.friendName;
            params.plant_x = value.plant.grid_x;
            params.plant_y = value.plant.grid_y;
            params.plant_id = value.plant.id;
            super("friend_fertilize", "save_data", params);
		}
		
	}
}