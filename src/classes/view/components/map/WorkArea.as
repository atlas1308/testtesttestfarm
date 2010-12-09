package classes.view.components.map {
    import flash.display.*;

    public class WorkArea extends MapObject {

        private var _hide_lines:Boolean = true;
        private var color:Number;
        private var work_area_size:Number;

        public function WorkArea(size:Number, color:Number=0xFFCC00){
            var data:Object = new Object();
            data.id = 0;
            data.size_x = (size * 4);
            data.size_y = (size * 4);
            data.type = "graphic";
            data.name = "work_area";
            super(data);
            work_area_size = size;
            this.color = color;
        }
        private function draw_area():void{
            var i:Number;
            var j:Number;
            var padd:Number;
            var n:Number;
            var gr:Graphics = asset.graphics;
            gr.clear();
            if (!_hide_lines){
                gr.beginFill(color, 0);
                gr.lineStyle(2, color, 0.7);
                gr.moveTo(get_x(0, 0), get_y(0, 0));
                gr.lineTo(get_x((work_area_size * 4), 0), get_y((work_area_size * 4), 0));
                gr.lineTo(get_x((work_area_size * 4), (work_area_size * 4)), get_y((work_area_size * 4), (work_area_size * 4)));
                gr.lineTo(get_x(0, (work_area_size * 4)), get_y(0, (work_area_size * 4)));
                gr.lineTo(get_x(0, 0), get_y(0, 0));
                gr.endFill();
                gr.lineStyle(2, color, 0.7);
                i = 1;
                while (i < work_area_size) {
                    gr.moveTo(get_x((i * 4), 0), get_y((i * 4), 0));
                    gr.lineTo(get_x((i * 4), (work_area_size * 4)), get_y((i * 4), (work_area_size * 4)));
                    i++;
                };
                i = 1;
                while (i < work_area_size) {
                    gr.moveTo(get_x(0, (i * 4)), get_y(0, (i * 4)));
                    gr.lineTo(get_x((work_area_size * 4), (i * 4)), get_y((work_area_size * 4), (i * 4)));
                    i++;
                };
            } else {
                padd = 1;
                n = (work_area_size * 4);
                gr.lineStyle(2, color, 1);
                gr.moveTo(get_x(padd, 0), get_y(padd, 0));
                gr.lineTo(get_x(0, 0), get_y(0, 0));
                gr.lineTo(get_x(0, padd), get_y(0, padd));
                gr.moveTo(get_x(0, (n - padd)), get_y(0, (n - padd)));
                gr.lineTo(get_x(0, n), get_y(0, n));
                gr.lineTo(get_x(padd, n), get_y(padd, n));
                gr.moveTo(get_x((n - padd), 0), get_y((n - padd), 0));
                gr.lineTo(get_x(n, 0), get_y(n, 0));
                gr.lineTo(get_x(n, padd), get_y(n, padd));
                gr.moveTo(get_x(n, (n - padd)), get_y(n, (n - padd)));
                gr.lineTo(get_x(n, n), get_y(n, n));
                gr.lineTo(get_x((n - padd), n), get_y((n - padd), n));
                i = 1;
                while (i < work_area_size) {
                    gr.moveTo(get_x(((i * 4) - padd), 0), get_y(((i * 4) - padd), 0));
                    gr.lineTo(get_x(((i * 4) + padd), 0), get_y(((i * 4) + padd), 0));
                    gr.moveTo(get_x((i * 4), 0), get_y((i * 4), 0));
                    gr.lineTo(get_x((i * 4), padd), get_y((i * 4), padd));
                    gr.moveTo(get_x(((i * 4) - padd), n), get_y(((i * 4) - padd), n));
                    gr.lineTo(get_x(((i * 4) + padd), n), get_y(((i * 4) + padd), n));
                    gr.moveTo(get_x((i * 4), n), get_y((i * 4), n));
                    gr.lineTo(get_x((i * 4), (n - padd)), get_y((i * 4), (n - padd)));
                    i++;
                };
                i = 1;
                while (i < work_area_size) {
                    gr.moveTo(get_x(0, ((i * 4) - padd)), get_y(0, ((i * 4) - padd)));
                    gr.lineTo(get_x(0, ((i * 4) + padd)), get_y(0, ((i * 4) + padd)));
                    gr.moveTo(get_x(0, (i * 4)), get_y(0, (i * 4)));
                    gr.lineTo(get_x(padd, (i * 4)), get_y(padd, (i * 4)));
                    gr.moveTo(get_x(n, ((i * 4) - padd)), get_y(n, ((i * 4) - padd)));
                    gr.lineTo(get_x(n, ((i * 4) + padd)), get_y(n, ((i * 4) + padd)));
                    gr.moveTo(get_x(n, (i * 4)), get_y(n, (i * 4)));
                    gr.lineTo(get_x((n - padd), (i * 4)), get_y((n - padd), (i * 4)));
                    i++;
                };
                gr.lineStyle(2, color, 0.7);
                i = 1;
                while (i < work_area_size) {
                    j = 1;
                    while (j < work_area_size) {
                        gr.moveTo(get_x((i * 4), ((j * 4) - padd)), get_y((i * 4), ((j * 4) - padd)));
                        gr.lineTo(get_x((i * 4), ((j * 4) + padd)), get_y((i * 4), ((j * 4) + padd)));
                        gr.moveTo(get_x(((i * 4) - padd), (j * 4)), get_y(((i * 4) - padd), (j * 4)));
                        gr.lineTo(get_x(((i * 4) + padd), (j * 4)), get_y(((i * 4) + padd), (j * 4)));
                        j++;
                    };
                    i++;
                };
            };
        }
        public function hide_lines():void{
            _hide_lines = true;
            draw_area();
        }
        override protected function refresh_asset():void{
            draw_area();
        }
        public function set_color(c:Number):void{
            color = c;
            draw_area();
        }
        public function contains_obj(obj:MapObject, fixed_pos:Boolean=true):Boolean{
            if (obj.grid_x < grid_x){
                return (false);
            };
            if (obj.grid_y < grid_y){
                return (false);
            };
            if ((obj.grid_x + obj.x_size) > (grid_x + x_size)){
                return (false);
            };
            if ((obj.grid_y + obj.y_size) > (grid_y + y_size)){
                return (false);
            };
            if (fixed_pos){
                if (((obj.grid_x - grid_x) % 4) != 0){
                    return (false);
                };
                if (((obj.grid_y - grid_y) % 4) != 0){
                    return (false);
                };
            };
            return (true);
        }
        public function show_lines():void{
            _hide_lines = false;
            draw_area();
        }
        public function set_size(s:Number):void{
            work_area_size = s;
            size_x = (s * 4);
            size_y = (s * 4);
            draw_area();
        }

    }
}
