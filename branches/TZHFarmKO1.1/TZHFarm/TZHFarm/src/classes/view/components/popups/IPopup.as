package classes.view.components.popups
{
	import flash.events.IEventDispatcher;
	

    public interface IPopup extends IEventDispatcher
    {

        function refresh() : void;

        function remove() : void;

    }
}
