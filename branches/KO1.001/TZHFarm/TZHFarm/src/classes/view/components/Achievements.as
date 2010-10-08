
package classes.view.components {
    import classes.IChildren;
    import classes.view.components.achievements.*;
    
    import flash.display.*;
    import flash.events.*;
 
    public class Achievements extends MovieClip implements IChildren {

        public const ON_CLOSE:String = "onClose";

        private var container:Sprite;
        private var max_items:Number = 4;
        private var total_pages:Number;
        public var prev_btn:SimpleButton;//instance name
        public var close_btn:SimpleButton;//instance name
        public var inner_cont:MovieClip;//instance name
        private var current_page:Number = 0;
        private var list:Array;
        public var next_btn:SimpleButton;//instance name

        public function Achievements(){
            super();
            this.createChildren();
            this.init();
        }
        
        private var skin:AchievementsSkin;
        public function createChildren():void {
        	this.skin = this.addChild(new AchievementsSkin()) as AchievementsSkin;
        	this.inner_cont = this.skin.inner_cont;
        	this.close_btn = this.skin.close_btn;
        }
        
        public function destory():void {
        	
        }
        
        private function init():void{
            container = new Sprite();
            addChild(container);
            container.x = inner_cont.x;
            container.y = inner_cont.y;
            close_btn.addEventListener(MouseEvent.MOUSE_UP, closeClicked);
        }
        public function update(data:Array):void{
            list = data;
            total_pages = Math.ceil((list.length / max_items));
            view_page(current_page);
        }
        private function closeClicked(e:MouseEvent):void{
            dispatchEvent(new Event(ON_CLOSE));
        }
        private function view_page(page:Number):void{
            var item_w:Number;
            var _item:Achievement;
            var item:Achievement;
            var padd:Number;
            current_page = page;
            while (container.numChildren) {
                _item = (container.getChildAt(0) as Achievement);
                _item.kill();
            };
            var start:Number = (page * max_items);
            var max:Number = Math.min(list.length, (start + max_items));
            var i:Number = start;
            while (i < max) {
                item = new Achievement(list[i]);
                padd = ((inner_cont.height - (max_items * item.height)) / (max_items + 1));
                container.addChild(item);
                item.x = ((inner_cont.width - item.width) / 2);
                item.y = ((i * (item.height + padd)) + padd);
                i++;
            };
            next_btn.visible = (prev_btn.visible = true);
            if (total_pages == 0){
                next_btn.visible = false;
            };
            if (page == (total_pages - 1)){
                next_btn.visible = false;
            };
            if (page == 0){
                prev_btn.visible = false;
            };
        }

    }
}//package classes.view.components 
