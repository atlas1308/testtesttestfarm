package classes.view.components.popups {
    import flash.events.*;

    public class UnderConstructionPopup extends ComplexPopup {
    	
        public static const LINK_CLICKED:String = "linkClicked";

        public function UnderConstructionPopup(data:Object){
            /* var w:Number = ((data.list.length)>6) ? 650 : 550;
            var w2:Number = ((data.list.length)>6) ? 540 : 440; */
            var w:Number = 560;
            var w2:Number = 440;
            super(data.title, data.list, w, 460, w2, 360);
			//super(380, 210, 300, 110, param1);
        }
        override protected function init():void{
            if (raw_list.length > 6){
                items_x = 4;
            }
            items_x = 2;
            super.init();
        }
        
        override protected function itemClicked(e:Event):void{
            var index:Number;
            var obj:UnderConstructionPopupItem;
            super.itemClicked(e);
            /* if (item is UnderConstructionPopupItem){
                index = 0;
                while (index < list.length) {
                    obj = (list[index] as UnderConstructionPopupItem);
                    if (((obj) && ((obj.type == item.type)))){
                    }
                    index++;
                }
            } */
        }
        
        protected function onLinkClicked(e:Event):void{
            item = (e.target as PopupItem);
            dispatchEvent(new Event(LINK_CLICKED));
        }
        
        override protected function create_item(data:Object):PopupItem{
            var item:PopupItem;
            switch (data.type){
                case "send_gifts":
                    item = new SendGiftsPopupItem(data);
                    break;
                default:
                    item = new UnderConstructionPopupItem(data);
            }
            item.addEventListener(UnderConstructionPopupItem.LINK_CLICKED, onLinkClicked);
            return item;
        }
    }
}
