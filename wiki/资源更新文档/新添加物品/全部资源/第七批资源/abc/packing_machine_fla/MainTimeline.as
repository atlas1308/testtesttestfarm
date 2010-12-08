package packing_machine_fla
{
    import flash.display.*;

    dynamic public class MainTimeline extends MovieClip
    {
        public var anim2:MovieClip;
        public var anim4:MovieClip;
        public var anim1:MovieClip;
        public var anim3:MovieClip;
        public var raw_material1:MovieClip;
        public var extra_hit_area:MovieClip;
        public var raw_material:Number;
        public var red_button:MovieClip;
        public var switch_hit_area:MovieClip;
        public var collect_hit_area:MovieClip;
        public var product:MovieClip;
        public var switch_area:MovieClip;

        public function MainTimeline()
        {
            addFrameScript(0, this.frame1);
            return;
        }// end function

        function frame1()
        {
            this.raw_material = 1;
            return;
        }// end function

    }
}
