package classes.controller
{
    import classes.*;
    import classes.model.*;
    import classes.view.*;
    
    import flash.display.*;
    
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.command.*;
    
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
           	/* var manager:JSDataManager = JSDataManager.getInstance();
        	manager.loadSocailData();
            var params:Object = stage.loaderInfo.parameters;
            params.fb_sig_user = manager.userInfo.uid; */
            facade.registerMediator(new StageMediator(stage));
            facade.registerProxy(new TransactionProxy(params));
            facade.registerProxy(new AppDataProxy(params));
            facade.registerProxy(new JSProxy(params));
            facade.registerProxy(new MapProxy());
            facade.registerProxy(new SnapshotProxy());
            facade.registerProxy(new PopupProxy());
            sendNotification(ApplicationFacade.CREATE_OBJECTS);
            sendNotification(ApplicationFacade.LOAD_DATA);
        }
		
		 private function get params():Object {
			var obj:Object = new Object();
			//obj.call_id = "1246021814812";
			obj.fb_sig = "1a45b33c65eb4328b6a32ae72c5754eb";
			obj.fb_sig_added = "1";// 这个参数也有用
			obj.fb_sig_api_key = "fd3a81e84ce7b97f5e050f3dd9a0bb49";
			obj.fb_sig_cookie_sig = "68f0c4dd53e7d3030426d3150ae15c27";
			obj.appId = "26947445683";// 这个参数有用
			obj.fb_sig_country = "us";
			obj.fb_sig_expires = "1277542800";
			obj.fb_sig_iframe_key = "4e732ced3463d06de0ca9a15b6153677";
			//obj.fb_sig_ext_perms = "status_update,photo_upload,video_upload,create_note,share_item,auto_publish_short_feed,publish_stream,auto_publish_recent_activity";
			obj.fb_sig_in_new_facebook = "1";
			obj.fb_sig_locale = "us";
			obj.fb_sig_profile_update_time = "1269103464";
			obj.fb_sig_session_key = "2.SNB9BZ63xoJnJEBtCWCRhw__.3600.1277542800-1560424778";
			obj.fb_sig_ss = "_YlZd6mag4eExSQA5ETxMQ__";
			obj.fb_sig_time = "1277557804.1269";
			obj.fb_sig_user = "1000202022";
			obj.id = 1560424778;
			obj.version = 77; 
			obj.fb_sig = "2bda135cc007b9a839b60e02089a9a07";
			return obj;

		} 
    }
}
