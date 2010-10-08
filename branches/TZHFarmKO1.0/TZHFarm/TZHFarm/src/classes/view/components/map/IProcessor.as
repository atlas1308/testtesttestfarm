package classes.view.components.map
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 这是一种加工器
	 */ 
    public interface IProcessor extends IEventDispatcher
    {

        function highlight_automation_areas(value:Number) : void;

        function collect() : void;

        function check_automation(value:String) : void;

    }
}
