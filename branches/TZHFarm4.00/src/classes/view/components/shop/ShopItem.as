package classes.view.components.shop
{
    import classes.utils.*;
    import classes.view.components.ISkinProperties;
    import classes.view.components.buttons.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    import mx.resources.ResourceManager;
    
    import tzh.DisplayUtil;
    import tzh.core.Constant;

    public class ShopItem extends Sprite implements ISkinProperties
    {
        private var cache:Cache;
        public var bg:MovieClip;
        public static const CLICKED:String = "clicked";
        public var cost:TextField;
        public const SEND_GIFT:String = "sendGift";
        public var level_needed:TextField;
        public var desc:TextField;
        private var send_gift:GameButton;
        public var locked:MovieClip;
        public var sell_for:TextField;
        public const ADD_NEIGHBORS:String = "addNeighbors";
        public var collect:TextField;
        public var item_title:TextField;
        private var data:Object;
        private var add_neighbors:GameButton;
        public var image:MovieClip;
        private var buy_rp_btn:GameButton;
        private var flip_btn:RotateBtn;
        private var buy_btn:GameButton;
        private var requestButton:GameButton;
		
		public static const HARVEST_ACTION:String = "Harvest";
		
		public static const BUY_METHOD_COIN:String = "coins";// 用coins来购买的常量
		public static const BUY_METHOD_RP:String = "rp";// 用rp来购买的常量
		
		private var sell_off_mc:MovieClip;
		
        public function ShopItem(value:Object)
        {
            this.data = value;
            this.createChildren();
            this.init();
        }
        
        private var skin:ShopItemSkin;
        public function createChildren():void {
        	this.skin = this.addChild(new ShopItemSkin()) as ShopItemSkin;
        	this.bg = this.skin.bg;
        	this.cost = this.skin.cost;
        	this.level_needed = this.skin.level_needed;
        	this.sell_for = this.skin.sell_for;
        	this.collect = this.skin.collect;
        	this.item_title = this.skin.item_title;
        	this.image = this.skin.image;
        	this.locked = this.skin.locked;
        	this.desc = this.skin.desc;
        }

        private function imageLoaded(event:Event) : void
        {
            var bitmap:Bitmap = Bitmap(event.target.asset);
            bitmap.x = (-bitmap.width) / 2;
            image.addChild(bitmap);
            image.x = width / 2 - 15;
            flip_btn.x = image.x + bitmap.width / 2 - flip_btn.width / 2 + flip_btn.width / 3;
            flip_btn.y = image.y + bitmap.height - flip_btn.height / 2;
        }

        public function get id() : Number
        {
            return data.id;
        }
		public function get explicitWidth():Number
		{
			return this.skin.width;
		}
		public function get explicitHeight():Number
		{
			return this.skin.height;
		}
        private function onMouseOver(event:MouseEvent) : void
        {
            if (!data.locked && data.flipable)
            {
                flip_btn.visible = true;
            }else {
            	flip_btn.visible = false;
            }
        }

        private function flipClicked(event:MouseEvent) : void
        {
            image.scaleX = image.scaleX * -1;
            flip_btn.scaleX = flip_btn.scaleX * -1;
        }

        private function init():void
        {
            flip_btn = new RotateBtn();
            flip_btn.scaleX = flip_btn.scaleY = 0.8;
            buy_rp_btn = new GameButton(ResourceManager.getInstance().getString("message","buy_message"), 13, 15 / 13);
            buy_rp_btn.set_style("mauve");
            buy_rp_btn.name = "buy_rp_btn";
            buy_rp_btn.set_fixed_width(50);
            add_neighbors = new GameButton(ResourceManager.getInstance().getString("message","add_neighbors_message"), 13, 15 / 13);
            add_neighbors.set_style("green");
            buy_btn = new GameButton(ResourceManager.getInstance().getString("message","buy_message"), 13, 15 / 13);
            buy_btn.name = "buyButton";
            buy_btn.set_fixed_width(50);
            var yy:int = int(bg.height - buy_btn.height / 2);
            add_neighbors.y = yy;
            buy_rp_btn.y = yy;
            buy_btn.y = yy;
            buy_btn.x = int((bg.width - buy_btn.width) / 2);
            buy_rp_btn.x = int((bg.width - buy_rp_btn.width) / 2);
            add_neighbors.x = int((bg.width - add_neighbors.width) / 2);
            addChild(buy_rp_btn);
            addChild(buy_btn);
            addChild(add_neighbors);
            addChild(flip_btn);
            flip_btn.visible = false;
            if (data.show_name !== false)
            {
                item_title.text = data.name ? data.name : "";
            }
            if (data.price)
            {
                cost.text = Algo.number_format(data.price) + " " + ResourceManager.getInstance().getString("message","coins_message");
            }
            else
            {
                cost.text = String(data.rp_price) + " " +  ResourceManager.getInstance().getString("message","ranch_cash_message");
                if(data.request){
                	requestButton = new GameButton(ResourceManager.getInstance().getString("message","request_gifts_shop_message"),13,15 / 13);
                	requestButton.addEventListener(MouseEvent.CLICK,askGiftsToFriends);
                	requestButton.set_style("green");
                	requestButton.set_fixed_width(60);
            		this.addChild(requestButton);
            		DisplayUtil.algin(this,buy_rp_btn,requestButton);
                }
            }
            if (data.locked)
            {
                sell_for.visible = false;
                collect.visible = false;
                buy_rp_btn.visible = false;
                desc.visible = false;
                if (data.locked_button == ResourceManager.getInstance().getString("message","neighbors_message"))
                {
                    cost.visible = false;
                    level_needed.y = level_needed.y + 11;
                    locked.y = locked.y + 8;
                    buy_btn.visible = false;
                }
                else
                {
                    add_neighbors.visible = false;
                    buy_btn.disable();
                    if(requestButton){
                    	requestButton.visible = false;
	            	}
                }
                level_needed.text = data.locked_message;
            }
            else
            {
                if (data.buy_method == BUY_METHOD_RP)
                {
                    buy_btn.visible = false;
                }
                else
                {
                    buy_rp_btn.visible = false;
                }
                if(data.sell_off_able){
                	if(!sell_off_mc){
                		sell_off_mc = new SellOffSkin();
                		this.addChild(sell_off_mc);
                	}
                }
                locked.visible = false;
                level_needed.visible = false;
                add_neighbors.visible = false;
            }
            
            if (data.sell_for)
            {
                sell_for.text = ResourceManager.getInstance().getString("message","sell_for_coins_message",[String(data.sell_for)]);
            }
            else
            {
                sell_for.visible = false;
            }
            if (data.collect_in)
            {
            	if(data.action == HARVEST_ACTION){
					collect.text = ResourceManager.getInstance().getString("message","harvest_in_message",[Algo.prep_time(data.collect_in, false)]);
	            }else {
	            	collect.text = ResourceManager.getInstance().getString("message","action_collect_in_message",[data.action, Algo.prep_time(data.collect_in, false)]);
	            }
            }
            else
            {
                collect.visible = false;
            }
            if (data.desc)
            {
                desc.text = data.desc;
            }
            else
            {
                desc.visible = false;
            }
            cache = new Cache();
            cache.addEventListener(Cache.LOAD_COMPLETE, imageLoaded);
            if (data.constructible)
            {
                cache.load(data.image_uc);
            }
            else
            {
                cache.load(data.image);
            }
            if (!buy_btn.is_disabled())
            {
                buy_btn.addEventListener(MouseEvent.CLICK, buyClicked);
            }
            buy_rp_btn.addEventListener(MouseEvent.CLICK, buyClicked);
            add_neighbors.addEventListener(MouseEvent.CLICK, addNeighborsClicked);
            if (send_gift)
            {
                send_gift.addEventListener(MouseEvent.CLICK, sendGiftClicked);
            }
            if (data.flipable)
            {
                flip_btn.addEventListener(MouseEvent.CLICK, flipClicked);
            }
            addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        }

        private function onMouseOut(event:MouseEvent) : void
        {
            if (data.flipable)
            {
                flip_btn.visible = false;
            }
        }

        private function addNeighborsClicked(event:MouseEvent) : void
        {
            dispatchEvent(new Event(ADD_NEIGHBORS));
        }

        public function get is_flipped() : Boolean
        {
            return image.scaleX < 0;
        }

        private function buyClicked(event:MouseEvent) : void
        {
            dispatchEvent(new Event(CLICKED));
        }

        private function sendGiftClicked(event:MouseEvent) : void
        {
            dispatchEvent(new Event(SEND_GIFT));
        }
		
		private function askGiftsToFriends(event:MouseEvent):void {
			Constant.showAskForGiftsHandler();
		}
    }
}
