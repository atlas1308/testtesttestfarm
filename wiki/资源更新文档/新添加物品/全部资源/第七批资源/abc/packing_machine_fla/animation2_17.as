package packing_machine_fla
{
    import flash.display.*;

    dynamic public class animation2_17 extends MovieClip
    {
        public var snow_potatoes:MovieClip;
        public var snow:MovieClip;

        public function animation2_17()
        {
            addFrameScript(0, this.frame1, 133, this.frame134);
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame134()
        {
            if (MovieClip(parent).raw_material == 4)
            {
                this.snow.visible = false;
                this.snow_potatoes.visible = true;
            }
            else
            {
                this.snow.visible = true;
                this.snow_potatoes.visible = false;
            }
            return;
        }// end function

    }
}
