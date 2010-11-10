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
		private var appDataProxy:AppDataProxy = Facade.getInstance("myRanch").retrieveProxy(AppDataProxy.NAME) as AppDataProxy;// 不知道还有没有简单的方法
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
        	/* var result:Boolean;
        	if(target && target is Plant){
				if(Plant(target).can_be_fertilized() && appDataProxy.enabledFriendFertilizer){
					result = true;
				}
			} */
			return false;
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
			/* var data:Object = new Object();
			var friendHelpedFertilizeData:Object = appDataProxy.friendHelpedFertilizeData;
			if(friendHelpedFertilizeData){
				data.fertilizer = {id:friendHelpedFertilizeData.id,percent:friendHelpedFertilizeData.percent};
			}
            data.plant = Plant(this.target);
            return data; */
            return null;
		}
    }
}
