package classes.view.components
{
    import classes.IChildren;
    import classes.utils.*;
    import classes.view.components.buttons.*;
    import classes.view.components.storage.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    import mx.resources.ResourceManager;

    public class Storage extends Sprite implements IChildren
    {
        private var container:Sprite;
        public var no_items:TextField;
        private var items:Array;
        private var total_pages:Number;
        public var prev_btn:SimpleButton;
        public var close_btn:SimpleButton;
        public var next_btn:SimpleButton;
        public const SELL_ALL:String = "sellAll";
        private var current_page:Number = 0;
        private var last_sale:Number = 0;
        private var max_items:Number = 12;// 每页显示的最大的数量
        private var _sell_all_btn:GameButton;
        public var bounds:MovieClip;
        public const SELL_ITEM:String = "sellItem";
        public var data:Object;
        public var inner_cont:MovieClip;
        public const ON_CLOSE:String = "onClose";

        public function Storage()
        {
            this.items = [];
            this.createChildren();
            this.init();
        }
        
        private var skin:StorageSkin;
        public function createChildren():void {
        	this.skin = this.addChild(new StorageSkin()) as StorageSkin;
        	this.no_items = this.skin.no_items;
        	this.bounds = this.skin.bounds;
        	this.close_btn = this.skin.close_btn;
        	this.inner_cont = this.skin.inner_cont;
        	this.prev_btn = this.skin.prev_btn;
        	this.next_btn = this.skin.next_btn;
        }
		
		public function destory():void {
			
		}

        private function nextClicked(event:MouseEvent) : void
        {
        	var nextPage:int = total_pages - 1;
            if (current_page == nextPage)
            {
                return;
            }
            view_page(current_page + 1);
        }

        private function sellItem(event:Event) : void
        {
            if (Algo.time() - last_sale < 0.5)
            {
                return;
            }
            last_sale = Algo.time();
            data = event.target.event_data;
            dispatchEvent(new Event(SELL_ITEM));
        }

        private function closeClicked(event:MouseEvent) : void
        {
            dispatchEvent(new Event(ON_CLOSE));
        }
		
		/**
		 * 基本上每个显示对象都有这个更新的方法吧
		 * 总体上这样写还是不错的
		 */ 
        public function update(storageItems:Object, reset:Boolean = true) : void
        {
            var index:Number = NaN;
            var obj:Object = null;
            var _loc_6:Boolean = false;
            var j:Number = NaN;
            var _loc_8:Object = null;
            var list:Array = [];
            if (storageItems.list.length > 0)
            {
                index = 0;
                while (index < items.length)
                {
                    obj = items[index];
                    _loc_6 = false;
                    j = 0;
                    while (j < storageItems.list.length)
                    {
                        _loc_8 = storageItems.list[j];
                        if (_loc_8.id == obj.id)
                        {
                            list.push(_loc_8);
                            storageItems.list.splice(j, 1);
                            _loc_6 = true;
                            break;
                        }
                        j++;
                    }
                    if (!_loc_6 && !reset)
                    {
                        obj.qty = 0;
                        list.push(obj);
                    }
                    index++;
                }
                index = 0;
                while (index < storageItems.list.length)
                {
                    list.push(storageItems.list[index]);
                    index++;
                }
            }
            items = list;
            total_pages = Math.ceil(items.length / max_items);
            if (items.length == 0)
            {
                no_items.visible = true;
                _sell_all_btn.visible = false;
            }
            else
            {
                no_items.visible = false;
                _sell_all_btn.visible = true;
                _sell_all_btn.set_label(ResourceManager.getInstance().getString("message","sell_all_for_storage_coins_messgae",[storageItems.total_value]));
                _sell_all_btn.x = (bounds.width - _sell_all_btn.width) / 2;
                _sell_all_btn.y = bounds.height - 30 - _sell_all_btn.height;
            }
            if (storageItems)
            {
                current_page = 0;
            }
            view_page(current_page);
        }

        private function sellAllClicked(event:MouseEvent) : void
        {
            dispatchEvent(new Event(SELL_ALL));
        }

        private function view_page(value:Number):void
        {
            var ww:Number = NaN;
            var _loc_6:Number = NaN;
            var storageItem:StorageItem = null;
            var storageItemRender:StorageItem = null;
            current_page = value;
            while (container.numChildren)
            {
                storageItem = container.getChildAt(0) as StorageItem;
                storageItem.kill();
                storageItem.removeEventListener(storageItem.ON_SELL, sellItem);
            }
            var total:int = value * max_items;
            var next:int = Math.min(items.length, total + max_items);// 下一页显示的数量
            var index:int = total;
            while (index < next)
            {
                storageItemRender = new StorageItem(items[index]);
                container.addChild(storageItemRender);
                storageItemRender.x = (index - total) % 3 * (storageItemRender.width + 15);
                storageItemRender.y = int((index - total) / 3) * (storageItemRender.height + 10);
                storageItemRender.addEventListener(storageItemRender.ON_SELL, sellItem);
                ww = storageItemRender.width;
                index++;
            }
            _loc_6 = ww * 3 + 30;
            container.y = inner_cont.y + (inner_cont.width - _loc_6) / 2;
            container.x = inner_cont.x + (inner_cont.width - _loc_6) / 2;
            prev_btn.visible = true;
            next_btn.visible = true;
            if (total_pages == 0)
            {
                next_btn.visible = false;
            }
            var nextPage:int = total_pages - 1;
            if (value == nextPage)
            {
                next_btn.visible = false;
            }
            if (value == 0)
            {
                prev_btn.visible = false;
            }
        }

        private function init() : void
        {
            container = new Sprite();
            addChild(container);
            _sell_all_btn = new GameButton(ResourceManager.getInstance().getString("message","sell_all_for_storage_message"));
            _sell_all_btn.addEventListener(MouseEvent.CLICK, sellAllClicked);
            this.skin.prev_btn.addEventListener(MouseEvent.CLICK, prevClicked);
            this.skin.next_btn.addEventListener(MouseEvent.CLICK, nextClicked);
            addChild(_sell_all_btn);
            this.skin.close_btn.addEventListener(MouseEvent.CLICK, closeClicked);
            this.skin.no_items.visible = false;
        }

        private function prevClicked(event:MouseEvent) : void
        {
        	var prevPage:int = current_page - 1;
            if (current_page == 0)
            {
                return;
            }
            view_page(prevPage);
        }

    }
}
