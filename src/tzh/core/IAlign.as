package tzh.core
{
	public interface IAlign
	{
		/**
		 * 固定物体居中的位置
		 * @param offsetX:Number 注册点有的时候不是0,0可能要动态调整一下
		 * @param offsetX:Number 注册点有的时候不是0,0可能要动态调整一下
		 */ 
		function center(offsetX:Number = 0,offsetY:Number = 0):void;
	}
}