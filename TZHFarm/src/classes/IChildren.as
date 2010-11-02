package classes
{
	/**
	 * 通过2个游戏的学习,我们发现大部游戏还是用flashIDE开发的
	 * 这样子的话美术基本就画在flash里
	 * 所以我们用FlexBulider开发或其它工具开发时会遇到一种问题
	 * 这样子的话，在每次遇到UI时我们,我们要继承IChildren这个方法
	 * 我们定义一个private var skin:(具体的类型);
	 * 在createChild里addChild即可
	 * 
	 * destory方法是要实现删除事件等操作的
	 * 
	 * UI里必须实现以下2个方法
	 * 
	 * 我们在flash里修改的方式如下
	 * 
	 * 找到相对应的类名,然后如果类前面有包的话,把包名也删除掉在类名后加skin
	 * 
	 * 举个例子Toolbar这个UI类
	 * 
	 * 我们先在flash里找到Toolbar
	 * 
	 * 在flash里找到一个classes.view.components.Toolbar这个类名
	 * 那么我们在flash修改这个类名,修改为ToolbarSkin
	 * 
	 * 然后我们在Toolbar的代码里implements IChildren
	 * 
	 * 实下如下代码
	 * 
	 * private var skin:ToolbarSkin;
	 * 
	 * public fucntion createChild():void {
	 * 		this.skin = this.addChild(new ToolbarSkin()) as ToolbarSkin;
	 * }
	 * 
	 * public function destory():void {
	 * 		while(this.numChildren > 0){
	 * 			var child:DisplayObject = this.getChildAt(0);
	 * 			if(child is IChildren){
	 * 				IChildren(child).destory();
	 * 			}
	 * 			this.removeChild(child);
	 * 		}
	 * 		// 如果这里有事件的话，我们就remove具体的事件就可以了
	 * }
	 * }
	 */ 
	public interface IChildren
	{
		function createChildren():void;
		
		function destory():void;
	}
}