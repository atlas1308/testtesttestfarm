package classes.view.components.map
{
    import classes.utils.*;
    
    import flash.display.*;
    import flash.geom.*;
	
	/**
	 * 整个的背景层
	 */ 
    public class Grass extends Sprite
    {
        private var container:Sprite;
        private var view_h:Number;
        private var angle:Number = 1.09083078249646;
        private var grid_size:Number;
        private var view_w:Number;
        private var grass_padd:Number = 0;
        private var border_cont:Sprite;
        private var top_size:Number;
        private var delta_x:Number;
        private var delta_y:Number;
        private var grass:BitmapData;
        private var size_x:Number = 0;
        private var size_y:Number = 0;

        public function Grass()
        {
            init();
        }

        public function draw(view_w:Number, view_h:Number, delta_x:Number = 0, delta_y:Number = 0) : void
        {
        	this.view_w = view_w;
            this.view_h = view_h;
            this.delta_x = delta_x;
            this.delta_y = delta_y;
            var ratio:Number = parseFloat(Number(15 / grid_size).toFixed(4));
            var matrix:Matrix = new Matrix();
            matrix.scale(1 / ratio, 1 / ratio);
            matrix.translate(view_w % grass.width - grass.width, view_h % grass.height - grass.height);
            container.graphics.beginBitmapFill(grass, matrix);
            container.graphics.drawRect(0, 0, view_w, view_h);
            container.graphics.endFill();
            border_cont.graphics.clear();
            draw_bounds(4, 10942037);//10942037
            var size:Number = 6 / this.grid_size;
            draw_polygon(border_cont.graphics,
            				[[-top_size - size, -top_size - size], // 这个的问题,是应该返回0,但是具体要搞清楚这个意义,不过我看来应该就是0
				            [size_x + size, -top_size - size], 
				            [size_x + size, size_y + size], 
				            [-top_size - size, size_y + size]], 
				            551206);
			
			//var temp:int = 8;
			// xx 下  yy 右 求:rt   top
		    /* var testLines:Array = [[-top_size - size + 1, -top_size - size], // 这个的问题,是应该返回0,但是具体要搞清楚这个意义,不过我看来应该就是0
				            [size + temp, -top_size - size], 
				            [size + temp, size_y + size], 
				            [-top_size - size + 1, size_y + size]]; */
			//this.draw_polygon2(leftTop.graphics,testLines,0xFF99AA); 
            border_cont.x = this.delta_x + this.view_w / 2;
            border_cont.y = this.delta_y + this.view_h / 2 - Algo.get_y(size_x + top_size, size_y + top_size, angle, grid_size) / 2;
            /* leftTop.x = border_cont.x;
            leftTop.y = border_cont.y; */
        }
        
        /* private function draw_polygon2(g:Graphics,lines:Array, color:Number) : void
        {
            var lineX:Number = 0;
            var lineY:Number = 0;
            var moveX:Number = 0;
            var moveY:Number = 0;
            g.lineStyle(0, color, 1, true);
            var index:Number = 0;
            while (index < lines.length)
            {
                moveX = Algo.get_x(size_x + lines[index][0], lines[index][1], angle, grid_size);
                moveY = Algo.get_y(size_x + lines[index][0], lines[index][1], angle, grid_size);
                if (index == 0)
                {
                    g.moveTo(moveX, moveY);
                    lineX = moveX;
                    lineY = moveY;
                    index++;
                    continue;
                }
                g.lineTo(moveX, moveY);
                var endIndex:int = lines.length - 1;
                if (index == endIndex)
                {
                    g.lineTo(lineX, lineY);
                }
                index++;
            }
        } */
        
        private function init() : void
        {
            container = new Sprite();
            addChild(container);
            container.cacheAsBitmap = true;
            border_cont = new Sprite();
            addChild(border_cont);
            grass = new grass_bmp(100, 100);
        }

        public function set_grid_size(value:Number) : void
        {
            grid_size = value;
            if (view_h)
            {
                draw(view_w, view_h, delta_x, delta_y);
            }
        }
		
		/**
		 * 这是内部的一个border
		 */ 
        private function draw_bounds(size:Number, color:Number) : void
        {
            var ratio:Number = size / this.grid_size;
            if(isNaN(ratio))return;
            var lines:Array = [[-ratio, -ratio],
				            [size_x + ratio, -ratio], 
				            [size_x + ratio, size_y + ratio], 
				            [-ratio, size_y + ratio]];
			this.draw_polygon(border_cont.graphics,lines,color);
        }

        public function set_bounds(size_x:Number, size_y:Number, top_size:Number) : void
        {
            this.size_x = size_x;
            this.size_y = size_y;
            this.top_size = top_size;
            if (view_h)
            {
                draw(view_w, view_h, delta_x, delta_y);
            }
        }

        private function draw_polygon(g:Graphics,lines:Array, color:Number) : void
        {
            var lineX:Number = 0;
            var lineY:Number = 0;
            var moveX:Number = 0;
            var moveY:Number = 0;
            g.lineStyle(0, color, 1, true);
            var index:Number = 0;
            while (index < lines.length)
            {
                moveX = Algo.get_x(lines[index][0], lines[index][1], angle, grid_size);
                moveY = Algo.get_y(lines[index][0], lines[index][1], angle, grid_size);
                if (index == 0)
                {
                    g.moveTo(moveX, moveY);
                    lineX = moveX;
                    lineY = moveY;
                    index++;
                    continue;
                }
                g.lineTo(moveX, moveY);
                var endIndex:int = lines.length - 1;
                if (index == endIndex)
                {
                    g.lineTo(lineX, lineY);
                }
                index++;
            }
        }

    }
}
