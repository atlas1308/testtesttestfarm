package classes.view.components.popups
{
	import flash.events.MouseEvent;
	
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	import tzh.core.JSDataManager;
	
	
	/**
	 * 部分popup的事件都在自身处理,没必要广播到PopupMediator里去执行,有的时候不知道为什么,响应不了事件
	 */ 
    public class ConfirmPopup extends DynamicPopup
    {
        public var obj:Object;

        public function ConfirmPopup(message:String, obj:Object)
        {
            this.obj = obj;
            super(400, 190, 300, 110, message);
        }

        override protected function init() : void
        {
            ok_label = ResourceManager.getInstance().getString("message","game_button_ok_message");
            super.init();
            this.addListener();
        }
        
        public function addListener():void {
        	ok_btn.addEventListener(MouseEvent.CLICK,accpetHandler);
        	close_btn.addEventListener(MouseEvent.CLICK,closeHandler);
        }
        
        private function accpetHandler(event:MouseEvent):void {
        	if(this.notif_body == "offers"){
        		JSDataManager.showPayPage();// 加载充值页面
        		this.remove();
        	}else {
            	Facade.getInstance(TZHFarm.MAIN_STAGE).sendNotification(this.notif_name,this.notif_body);
            }
        }
        
        private function closeHandler(event:MouseEvent):void {
        	this.remove();
        }
        
        private function removeListener():void {
        	ok_btn.removeEventListener(MouseEvent.CLICK,accpetHandler);
        	close_btn.removeEventListener(MouseEvent.CLICK,closeHandler);
        }
        
        override public function remove():void {
        	super.remove();
        	this.removeListener();
        }
        

        public function get notif_body() : Object
        {
            return obj.data;
        }

        public function get notif_name() : String
        {
            return obj.notif;
        }
    }
}
