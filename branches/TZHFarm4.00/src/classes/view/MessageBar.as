package classes.view
{
	import classes.IChildren;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import tzh.UIEvent;
	import tzh.core.GlowTween;

	public class MessageBar extends Sprite implements IChildren
	{
		private var msg_count:TextField;
		private var messageTip:MovieClip;
		public function MessageBar()
		{
			super();
			this.createChildren();
		}
		
		private function showNewsPanel(event:MouseEvent):void {
			this.disabled();
			this.dispatchEvent(new UIEvent(UIEvent.SHOW_NEWS_PANEL));
		}
		
		public function disabled():void {
			if(glow){
				glow.remove();
				glow = null;
			}
			msg_count.text = "";
			messageTip.visible = false;
		}
		
		private var skin:MessageBarSkin;
		public function createChildren():void {
			this.skin = new MessageBarSkin();
			messageTip = this.skin.messageTip;
			msg_count = this.skin.messageTip.msg_count;
			this.addChild(this.skin);
			this.disabled();
			this.addEventListener(MouseEvent.CLICK,showNewsPanel);
		}
		
		public function update(value:Object):void {
			msg_count.text = value.toString();
			messageTip.visible = true;
			this.showGlowEffect();
		}
		
		private var glow:GlowTween;
		public function showGlowEffect():void {
			glow = new GlowTween(this,0xFEFE5F);
			glow.start();
		}
		
		public function destory():void {
			this.disabled();
		}
	}
}