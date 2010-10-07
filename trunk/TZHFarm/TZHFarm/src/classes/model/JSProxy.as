package classes.model {
    import classes.*;
    
    import flash.external.*;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.proxy.*;
    
    import tzh.core.JSDataManager;

    public class JSProxy extends Proxy implements IProxy {

        public static const NAME:String = "JS";
        private var params:Object;
        private var fb_data:Object;

        public function JSProxy(value:Object){
            this.params = value;
            super(NAME);
        }
        
        private function init():void{
        	var manager:JSDataManager = JSDataManager.getInstance();
        	var friends:Object = manager.friends;
        	sendNotification(ApplicationFacade.FB_DATA_LOADED, friends);
        }
        
        override public function onRegister():void{
            init();
        }

    }
}
