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
			obj.fb_sig_api_key = "fd3a81e84ce7b97f5e050f3dd9a0bb49";
			obj.appId = "26947445683";// 这个参数有用
			obj.fb_sig_country = "us";
			obj.fb_sig_expires = "1277542800";
			obj.fb_sig_iframe_key = "4e732ced3463d06de0ca9a15b6153677";
			obj.fb_sig_session_key = "2.SNB9BZ63xoJnJEBtCWCRhw__.3600.1277542800-1560424778";
			obj.fb_sig_ss = "_YlZd6mag4eExSQA5ETxMQ__";
			obj.fb_sig_time = "1277557804.1269dfa";
			obj.fb_sig_user = "www.vz.net:yy-n1GwaMLYH9VyakQHlWw";
			//www.vz.net:tg7TI3uiAO9irLhue0kHYA
			//www.vz.net:tg7TI3uiAO9irLhue0kHYA
			//www.vz.net:WtP271mWJW19eIdrhNCNBw
			//obj.fb_sig_user = "fdafdasfadaaadsa1fadfadaaaaaaa3" + Math.floor(Math.random() * 1000000);
			//sandbox.developer.studivz.net:u-mcxK71YUt6QrOx2yIsFQ
			//Math.floor(Math.random() * 100000000);//"99999";//Math.floor(Math.random() * 100000000);//"123456222w222a2s";//(Math.floor(Math.random() * 10000)).toString();//"12502022212222222";
			//123456 99999 KYPhPymkM8kfR8Pi1a3mSg
			obj.version = 77; 
			obj.fb_sig = "2bda135cc007b9a839b60e02089a9a07";
			obj.lang = Config.getConfig("lang");
			return obj;

		}  
    }
}
