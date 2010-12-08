package packing_machine_fla
{
    import flash.display.*;

    dynamic public class Tween16_4 extends MovieClip
    {
        public var packs:MovieClip;
        public var frame:Number;

        public function Tween16_4()
        {
            addFrameScript(0, this.frame1);
            return;
        }// end function

        function frame1()
        {
            this.frame = MovieClip(parent).raw_material > 0 ? (MovieClip(parent).raw_material) : (MovieClip(parent.parent).raw_material);
            trace("frame", this.frame);
            this.packs.gotoAndStop(this.frame);
            return;
        }// end function

    }
}
