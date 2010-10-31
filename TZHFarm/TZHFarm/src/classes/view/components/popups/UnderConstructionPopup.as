package classes.view.components.popups {
    import classes.view.components.buttons.GameButton;
    import classes.view.components.map.MapObject;
    
    import flash.events.*;
    
    import mx.resources.ResourceManager;
    
    import tzh.core.FeedData;
    import tzh.core.JSDataManager;

    public class UnderConstructionPopup extends ComplexPopup {
    	
        public static const LINK_CLICKED:String = "linkClicked";
		
		private var requestButton:GameButton;
		private var offsetY:Number = 3;
		
		public var target:MapObject;// 当前使用到的target
		
        public function UnderConstructionPopup(data:Object,target:MapObject = null){
            var w:Number = 560;
            var w2:Number = 440;
            this.target = target;
            super(data.title, data.list, w, 460, w2, 360);
            requestButton = new GameButton(ResourceManager.getInstance().getString("message","invite_friend_to_helped_message"),24);
            requestButton.x = (this._w - requestButton.width) / 2;
            requestButton.addEventListener(MouseEvent.CLICK,showJSFeedHandler);
            requestButton.y = msg_h + (this._h - msg_h - requestButton.height) / 2 + requestButton.height - offsetY;
            content.addChild(requestButton);
        }
        
        override protected function init():void{
            if (raw_list.length > 6){
                items_x = 4;
            }
            items_x = 2;
            super.init();
        }
        
         /**
         * 不知具体用途 
         */ 
        override protected function itemClicked(e:Event):void{
            super.itemClicked(e);
        } 
        
        protected function onLinkClicked(e:Event):void{
            item = (e.target as PopupItem);
            dispatchEvent(new Event(LINK_CLICKED));
        }
        
        override protected function create_item(data:Object):PopupItem{
            var item:PopupItem;
            /* switch (data.type){
                case "send_gifts":
                    item = new SendGiftsPopupItem(data);
                    break;
                default: 
                    
            } */
            item = new UnderConstructionPopupItem(data);
            item.affectMapObject = target;
            //item.addEventListener(UnderConstructionPopupItem.LINK_CLICKED, onLinkClicked);
            return item;
        }
        
        /**
         * 更新数据的方法,现在还是有一些复杂 
         */ 
        public function refreshData(data:Object):void {
        	this.raw_list = data.list;
        	var index:int = 0;
        	while(index < items_cont.numChildren){
        		var item:PopupItem = items_cont.getChildAt(index) as PopupItem;
        		var temp:Object = item.getData();
        		for each(var obj:Object in this.raw_list){
        			if(temp.id == obj.id){
        				item.refresh(obj);
        				break;
        			}
        		}
        		index++;
        	}
        }
        
        /**
         * 发送向好友要礼物的请求 
         */ 
        private function showJSFeedHandler(event:MouseEvent):void {
        	var manager:JSDataManager = JSDataManager.getInstance();
        	var username:String = "";
        	if(manager.userInfo && manager.userInfo.name){
				username = manager.userInfo.name;
        	}
        	manager.postFeed(FeedData.getRequestGiftsMessage(username));
        }
    }
}
