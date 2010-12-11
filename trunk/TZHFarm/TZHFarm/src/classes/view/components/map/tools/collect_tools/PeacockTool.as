package classes.view.components.map.tools.collect_tools
{
	import classes.view.components.map.Peacock;
	import classes.view.components.map.Processor;
	
	public class PeacockTool extends ProcessorTool
	{
		public function PeacockTool()
		{
			super();
			TYPE = Peacock.NAME;
		}
		
		override protected function get eater():Processor{
            if (target as Peacock){
                return target as Peacock;
            }
            return null;
        }
	}
}