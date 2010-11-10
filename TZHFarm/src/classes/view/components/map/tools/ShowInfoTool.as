package classes.view.components.map.tools
{
    import classes.model.AppDataProxy;
    import classes.utils.Cursor;
    import classes.view.components.map.*;
    
    import flash.events.Event;
    
    import org.puremvc.as3.multicore.patterns.facade.Facade;
    
    import tzh.core.Config;
    import tzh.core.Constant;

    public class ShowInfoTool extends Tool
    {
		private var appDataProxy:AppDataProxy = Facade.getInstance(TZHFarm.MAIN_STAGE).retrieveProxy(AppDataProxy.NAME) as AppDataProxy;// 不知道还有没有简单的方法
        public function ShowInfoTool()
        {
        }

        override protected function mouseOut() : void
        {
            hide_tip();
            if(target && target is MapObject){
            	target.state = "clear";
            }
        }

        override protected function mouseOver() : void
        {
            if (target as MapObject)
            {
        		if(enabledHelped){
        			Plant(target).state = "fertilize";
        			Cursor.show(Config.getConfig("host") + Constant.FERTILIZER_CURSOR_PATH,true, 5, 5);
        		}else {
        			Cursor.hide();
        		}
                tip(target.get_name());
            }else {
            	Cursor.hide();
            }
        }
        
        public function get enabledHelped():Boolean {
        	return false;
        	var result:Boolean;
        	if(target && target is Plant){
				if(Plant(target).can_be_fertilized() && appDataProxy.enabledFriendFertilizer && Plant(target).friend_can_be_fertilized){
					result = true;
				}
			} 
			return result;
        }

        override public function remove() : void
        {
            hide_tip();
        }
        
        override protected function mouseDown():void {
        	super.mouseDown();
        }
		
		override protected function mouseUp():void {
			if(enabledHelped){
				target.dispatchEvent(new Event(Plant.FRIEND_HELPED_FERTILIZE));
			}
		}
		
		override public function get_event_data():Object {
			var data:Object = new Object();
            data.plant = Plant(this.target);
            data.friendName = appDataProxy.friend_name;
            data.friend_id = appDataProxy.friend_farm_id;
            return data; 
		}
    }
}
