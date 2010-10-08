package classes.view.components
{
    import classes.IChildren;
    import classes.view.components.buttons.*;
    import classes.view.components.shop.*;
    
    import flash.display.*;
    import flash.events.*;

    public class Shop extends Sprite implements IChildren 
    {
        public const SEND_GIFT:String = "sendGift";
        public var prev_btn:SimpleButton;
        private var items_cont:Sprite;
        private var tabs_cont:Sprite;
        public var close_btn:SimpleButton;
        public var next_btn:SimpleButton;
        private var tab_pages:Number;// 总的页数
        public var cont_bounds:MovieClip;
        public const ADD_NEIGHBORS:String = "addNeighbors";
        private var max_items:Number = 6;
        public static const USE_ITEM:String = "useItem";
        private var last_tab:ShopTab;
        public const ON_CLOSE:String = "onClose";
        private var tab_page:Number = 0;
        public var item_clicked:Object;
        private var tabs:Array;
        private var _w:Number = 508;
		
		
		public function get itemContainer():Sprite {
			return this.items_cont;
		}
		
		public function get tabContainer():Sprite {
			return this.tabs_cont;
		}
		
        public function Shop()
        {
        	this.createChildren();
            this.init();
        }
        
        private var skin:ShopSkin;
        public function createChildren():void {
        	this.skin = this.addChild(new ShopSkin()) as ShopSkin;
        	this.prev_btn = this.skin.prev_btn;
        	this.next_btn = this.skin.next_btn;
        	this.cont_bounds = this.skin.cont_bounds;
        	this.close_btn = this.skin.close_btn;
        }
		
		public function destory():void {
			
		}

        public function goTo(value:Number) : void
        {
            var tabString:String = null;
            var index:Number = NaN;
            for (tabString in tabs)
            {
                index = 0;
                while (index < tabs[tabString].length)
                {
                    if (tabs[tabString][index].id == value)
                    {
                        select_tab(tabString);
                        show_tab(last_tab, Math.floor(index / 6));
                    }
                    index++;
                }
            }
        }

        public function update(value:Array) : void
        {
            var obj:Object = null;
            var shopTab:ShopTab = null;
            clear_container(tabs_cont);
            tabs = new Array();
            var index:int = 0;
            while (index < value.length)
            {
                obj = value[index];
                tabs[index] = obj.list;
                tabs[obj.name] = obj.list;
                shopTab = new ShopTab(obj.name, obj.is_new);
                shopTab.name = "shopTab" + index;
                tabs_cont.addChild(shopTab);
                shopTab.addEventListener(shopTab.CLICKED, shopTabClick);
                index++;
            }
            align_tabs();
            if (tabs_cont.numChildren)
            {
                show_tab(tabs_cont.getChildAt(0) as ShopTab);
            }
        }

        private function align_items() : void
        {
            var ww:Number = NaN;
            var hh:Number = NaN;
            var shopItem:ShopItem = null;
            var index:Number = 0;
            var hGap:Number= 20;// 水平间距
            var vGap:Number = 3;// 垂直间距
            while (index < items_cont.numChildren)
            {
                shopItem = ShopItem(items_cont.getChildAt(index));
                shopItem.x = int(index % 3 * (shopItem.explicitWidth + 10));
                shopItem.y = int(Math.floor(index / 3) * (shopItem.explicitHeight + hGap));
                hh = shopItem.explicitHeight + 10;
                ww = shopItem.explicitWidth + 12;
                index++;
            }
            items_cont.y = int(cont_bounds.y + (cont_bounds.height - 2 * hh + 3) / 2);
            items_cont.x = int(cont_bounds.x + (cont_bounds.width - 3 * ww + 3) / 2);
        }

        private function clear_container(value:Sprite) : void
        {
            while (value.numChildren)
            {
                value.removeChildAt(0);
            }
        }

        public function select_tab(value:String) : void
        {
            var shopTab:ShopTab = null;
            var index:Number = 0;
            while (index < tabs_cont.numChildren)
            {
                shopTab = ShopTab(tabs_cont.getChildAt(index));
                if (shopTab.title == value)
                {
                    show_tab(shopTab);
                    return;
                }
                index++;
            }
        }

        private function itemClicked(event:Event) : void
        {
            item_clicked = event.target;
            dispatchEvent(new Event(USE_ITEM));
        }

        private function prev_page(event:MouseEvent) : void
        {
        	var startIndex:int = tab_page - 1;
            if (tab_page == 0)
            {
                return;
            }
            show_tab(last_tab, startIndex);
        }

        private function closeShop(event:MouseEvent) : void
        {
            dispatchEvent(new Event(ON_CLOSE));
        }
        
        /**
         * 这里面会自动带了一个mouse_shake,大家可能感觉不是很好,这里只是做调试
         */ 
        override public function set visible(value:Boolean):void {
        	super.visible = value;
        }

        private function init() : void
        {
            items_cont = new Sprite();
            tabs_cont = new Sprite();
            addChild(items_cont);
            addChild(tabs_cont);
            this.skin.close_btn.addEventListener(MouseEvent.MOUSE_UP, closeShop);
            this.skin.prev_btn.addEventListener(MouseEvent.MOUSE_UP, prev_page);
            this.skin.next_btn.addEventListener(MouseEvent.MOUSE_UP, next_page);
        }

        private function shopTabClick(event:Event) : void
        {
            show_tab(event.target as ShopTab);
        }

        private function addNeighborsClicked(event:Event) : void
        {
            dispatchEvent(new Event(ADD_NEIGHBORS));
        }

        private function sendGiftClicked(event:Event) : void
        {
            item_clicked = event.target;
            dispatchEvent(new Event(SEND_GIFT));
        }

        private function align_tabs() : void
        {
            var container:Object = null;
            var shopTab:ShopTab = null;
            var _loc_5:Number = NaN;
            var list:Array = [];
            var index:int = 0;
            while (index < tabs_cont.numChildren)
            {
                if (!list.length)
                {
                    list.push(new Object());
                }
                var len:int = list.length - 1;
                container = list[len];
                if (!(container.row as Array))
                {
                    container.row = new Array();
                }
                if (!container.width)
                {
                    container.width = 0;
                }
                if (container.row.length == 5 && index < tabs_cont.numChildren)
                {
                    list.push(new Object());
                }
                shopTab = tabs_cont.getChildAt(index) as ShopTab;
                container.row.push(shopTab);
                container.width = container.width + (shopTab.width + 20);
                index++;
            }
            index = 0;
            while (index < list.length)
            {
                _loc_5 = 0;
                while (_loc_5 < list[index].row.length)
                {
                    shopTab = list[index].row[_loc_5] as ShopTab;
                    if (_loc_5 == 0)
                    {
                        shopTab.x = (_w - list[index].width + 20) / 2;
                    }
                    else
                    {
                    	var c:int = _loc_5 - 1;
                        shopTab.x = list[index].row[c].x + list[index].row[c].width + 20;
                    }
                    shopTab.y = index * (shopTab.height + 10);
                    _loc_5++;
                }
                index++;
            }
            tabs_cont.x = 82;
            tabs_cont.y = 60;
        }

        private function show_tab(value:ShopTab, index:Number = 0) : void
        {
            var count:Number = NaN;
            var shopItem:ShopItem = null;
            if (last_tab)
            {
                last_tab.unselect();
            }
            value.select();
            last_tab = value;
            tab_page = index;
            this.clear_container(items_cont);
            var i:Number = 0;
            for each (var obj:Object in tabs[value.title])
            {
                if (items_cont.numChildren == max_items)
                {
                    break;
                }
                count = Math.floor(i / max_items);
                if (count == index)
                {
                    shopItem = new ShopItem(obj);
                    shopItem.name = "shopItem" + i;
                    shopItem.addEventListener(ShopItem.CLICKED, itemClicked);
                    shopItem.addEventListener(shopItem.ADD_NEIGHBORS, addNeighborsClicked);
                    shopItem.addEventListener(shopItem.SEND_GIFT, sendGiftClicked);
                    items_cont.addChild(shopItem);
                } 
                i++;
            }
            tab_pages = Math.ceil(tabs[value.title].length / 6);
            prev_btn.visible = true;
            next_btn.visible = true;
            var nextIndex:int = tab_pages - 1;
            if (index == nextIndex)
            {
                next_btn.visible = false;
            }
            if (index == 0)
            {
                prev_btn.visible = false;
            }
            align_items();
        }

        private function next_page(event:MouseEvent) : void
        {
        	var nextIndex:int = tab_pages - 1;
            if (tab_page == nextIndex)
            {
                return;// 最后一页了
            }
            show_tab(last_tab, tab_page + 1);
        }

    }
}
