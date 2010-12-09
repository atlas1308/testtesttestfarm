package classes.controller
{
    import classes.ApplicationFacade;
    import classes.model.AppDataProxy;
    import classes.model.MapProxy;
    import classes.model.PopupProxy;
    import classes.model.SnapshotProxy;
    import classes.model.TransactionProxy;
    import classes.view.StageMediator;
    
    import flash.display.Stage;
    
    import org.puremvc.as3.multicore.interfaces.ICommand;
    import org.puremvc.as3.multicore.interfaces.INotification;
    import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
    
    import tzh.core.Config;
    import tzh.core.JSDataManager;

    public class StartupCommand extends SimpleCommand implements ICommand
    {

        public function StartupCommand()
        {
            return;
        }

        override public function execute(value:INotification) : void
        {
            var stage:Stage = value.getBody() as Stage;
            CONFIG::release {
	           	var manager:JSDataManager = JSDataManager.getInstance();
	        	manager.loadSocailData();
	            var params:Object = stage.loaderInfo.parameters;
	            if(params == null){
	            	params = new Object();
	            }
	            params.fb_sig_user = manager.userInfo.uid;
	            params.lang = Config.getConfig("lang");
            }
            facade.registerMediator(new StageMediator(stage));
            facade.registerProxy(new TransactionProxy(params));
            facade.registerProxy(new AppDataProxy(params));
            facade.registerProxy(new MapProxy());
            facade.registerProxy(new SnapshotProxy());
            facade.registerProxy(new PopupProxy());
            sendNotification(ApplicationFacade.CREATE_OBJECTS);
            sendNotification(ApplicationFacade.LOAD_DATA);
        }
		
		CONFIG::debug
		private function get params():Object {
			var obj:Object = new Object();
			obj.fb_sig_user = "mytest";
			// bug www.vz.net:yy-n1GwaMLYH9VyakQHlWw
			obj.version = 77; 
			obj.lang = Config.getConfig("lang");
			return obj;

		}  
    }
}
