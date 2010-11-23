package classes.view.components
{
    import classes.IChildren;
    
    import flash.display.*;
    import flash.events.*;

    public class SaveButton extends Sprite implements IChildren
    {
        public var gray:MovieClip;
        public const SAVE_CLICKED:String = "saveClicked";
        public var spinner:*;
        public var blue:SimpleButton;

        public function SaveButton()
        {
        	this.createChildren();
            this.hide();
            this.skin.blue.addEventListener(MouseEvent.CLICK, blueClicked);
        }
        
        private var skin:SaveButtonSkin;
        public function createChildren():void {
        	this.skin = this.addChild(new SaveButtonSkin()) as SaveButtonSkin;
        	this.blue = this.skin.blue;
        	this.spinner = this.skin.spinner;
        	this.gray = this.skin.gray;
        }
		
		public function destory():void {
			
		}
		
		public function get enabled():Boolean {
			return this.spinner.visible;
		}

        public function show(e:Boolean = false) : void
        {
            this.spinner.play();
            this.spinner.visible = e;
            this.blue.enabled = e;
            this.blue.visible = true;
            this.gray.visible = false;
        }

        private function blueClicked(event:Event) : void
        {
            if (this.enabled)
            {
                return;
            }
            dispatchEvent(new Event(SAVE_CLICKED));
        }

        public function hide() : void
        {
            this.spinner.stop();
            this.spinner.visible = false;
            this.blue.visible = false;
            this.gray.visible = true;
        }

    }
}
