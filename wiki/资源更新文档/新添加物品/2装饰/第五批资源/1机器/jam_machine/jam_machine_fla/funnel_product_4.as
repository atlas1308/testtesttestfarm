package jam_machine_fla
{
    import flash.display.*;

    dynamic public class funnel_product_4 extends MovieClip
    {
        public var products:MovieClip;

        public function funnel_product_4()
        {
            addFrameScript(0, this.frame1);
            return;
        }// end function

        function frame1()
        {
            this.products.gotoAndStop(MovieClip(parent.parent).raw_material);
            return;
        }// end function

    }
}
