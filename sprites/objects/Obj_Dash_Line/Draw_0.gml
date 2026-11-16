// ** Pixel Perfect Dash Line **

// * Sprite Dimensions *
var _sw = sprite_get_width(sprite_index);
var _sh = sprite_get_height(sprite_index);

// * Current Animation Frame *
var _frame = floor(image_index);

// * Select Center Row *
var _py = floor(_sh / 2);

// * Dash Direction *
var _dx = sign(dash_dir_x);
var _dy = sign(dash_dir_y);

// * Pixel Perfect Position *
var _center_x = round(x);
var _center_y = round(y);

// * Center Sprite Horizontally *
var _half_width = floor(_sw / 2);

// * Draw Each Pixel *
for (var _px = 0; _px < _sw; _px++)
{
    // * Position Relative To Center *
    var _offset = _px - _half_width;

    // * Position On Pixel Grid *
    var _draw_x = _center_x + _offset * _dx;
    var _draw_y = _center_y + _offset * _dy;

    // * Draw Original Sprite Pixel *
    draw_sprite_part(sprite_index, _frame, _px, _py, 1, 1, _draw_x, _draw_y);
}