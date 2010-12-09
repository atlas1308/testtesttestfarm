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
    
    import tzh.core.AlignSprite;

    public class Storage extends AlignSprite implements IChildren
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
        private var sell_all_btn:GameButton;
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
            if (Algo.time() - last_sale < 0.5)// 增加了一个判断
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
            var temp:Boolean = false;
            var j:Number = NaN;
            var item:Object = null;
            var list:Array = [];
            if (storageItems.list.length > 0)
            {
                index = 0;
                while (index < items.length)
                {
                    obj = items[index];
                    temp = false;
                    j = 0;
                    while (j < storageItems.list.length)
                    {
                        item = storageItems.list[j];
                        if (item.id == obj.id)
                        {
                            list.push(item);
                            storageItems.list.splice(j, 1);
                            temp = true;
                            break;
                        }
                        j++;
                    }
                    if (!temp && !reset)
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
                sell_all_btn.visible = false;
            }
            else
            {
                no_items.visible = false;
                sell_all_btn.visible = true;
                sell_all_btn.set_label(ResourceManager.getInstance().getString("message","sell_all_for_storage_coins_messgae",[storageItems.total_value]));
                sell_all_btn.x = (bounds.width - sell_all_btn.width) / 2;
                sell_all_btn.y = bounds.height + sell_all_btn.height;
            }
            /* if (storageItems)// 现在修改成不清空了
            {
                current_page = 0;
            } */
            view_page(current_page);
        }

        private function sellAllClicked(event:MouseEvent) : void
        {
            dispatchEvent(new Event(SELL_ALL));
        }
        
        public function removeAllChildren():void {
        	var storageItem:StorageItem = null;
            while (container.numChildren > 0)
            {
                storageItem = container.getChildAt(0) as StorageItem;
                storageItem.kill();
                storageItem.removeEventListener(storageItem.ON_SELL, sellItem);
                storageItem = null;
            }
        }

        private function view_page(value:Number):void
        {
            var ww:Number = NaN;
            var boundsWidth:Number = NaN;
            this.removeAllChildren();
            var storageItemRender:StorageItem = null;
            this.current_page = value;
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
            boundsWidth = ww * 3 + 30;
            container.y = inner_cont.y + (inner_cont.width - boundsWidth) / 2;
            container.x = inner_cont.x + (inner_cont.width - boundsWidth) / 2;
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
            sell_all_btn = new GameButton(ResourceManager.getInstance().getString("message","sell_all_for_storage_message"));
            sell_all_btn.addEventListener(MouseEvent.CLICK, sellAllClicked);
            this.prev_btn.addEventListener(MouseEvent.CLICK, prevClicked);
            this.next_btn.addEventListener(MouseEvent.CLICK, nextClicked);
            addChild(sell_all_btn);
            this.close_btn.addEventListener(MouseEvent.CLICK, closeClicked);
            this.no_items.visible = false;
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
