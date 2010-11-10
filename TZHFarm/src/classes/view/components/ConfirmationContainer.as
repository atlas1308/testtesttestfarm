package classes.view.components
{
	import flash.display.Sprite;
	
    public class ConfirmationContainer extends Sprite
    {

        public function ConfirmationContainer()
        {
            return;
        }

        public function show(value:Object) : void
        {
        	var index:int = Math.max(0,this.parent.numChildren - 1);
            this.parent.setChildIndex(this, index);
            var confirmation:Confirmation = new Confirmation(value);
            addChild(confirmation);
            confirmation.start();
        }

    }
}
