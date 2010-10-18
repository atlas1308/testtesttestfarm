package classes.view.components.map.tools
{
    import classes.utils.Cursor;
    import classes.view.components.map.*;
    
    import tzh.core.Config;
    import tzh.core.Constant;

    public class ShowInfoTool extends Tool
    {

        public function ShowInfoTool()
        {
        }

        override protected function mouseOut() : void
        {
            hide_tip();
            if(target &&target is MapObject){
            	target.state = "clear";
            }
        }

        override protected function mouseOver() : void
        {
            if (target as MapObject)
            {
            	
            	if(target is Plant){
            		if(Plant(target).can_be_fertilized()){
            			Plant(target).state = "fertilize";
            			Cursor.show(Config.getConfig("host") + Constant.FERTILIZER_CURSOR_PATH,true, 5, 5);
            		}
            	}
                tip(target.get_name());
            }
            
        }

        override public function remove() : void
        {
            hide_tip();
        }
        
        override protected function mouseDown():void {
        	super.mouseDown();
        }
		
		override protected function mouseUp():void {
			
		}
    }
}
