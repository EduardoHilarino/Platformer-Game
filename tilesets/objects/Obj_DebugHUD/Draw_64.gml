// ** Movement Debug HUD **

if (debug_visible)
{
    var _player = instance_find(Obj_Player, 0);

    if (instance_exists(_player))
    {
        var _p = _player.core_player;

        // * Panel Position And Size *
        var _x = 8;
        var _y = 8;

        var _w = 220;
        var _h = 176;

        // * Color Palette *
        var _bg = make_color_rgb(28, 42, 53);
        var _header = make_color_rgb(38, 54, 68);
        var _border = make_color_rgb(70, 98, 113);
        var _accent = make_color_rgb(124, 227, 205);
        var _text = make_color_rgb(232, 243, 242);
        var _muted = make_color_rgb(150, 174, 187);
        var _blue = make_color_rgb(118, 169, 234);

        // * Save Draw Settings *
        var _old_color = draw_get_color();
        var _old_alpha = draw_get_alpha();
        var _old_halign = draw_get_halign();
        var _old_valign = draw_get_valign();

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);

        // ** Panel Background **

        // * Shadow *
        draw_set_alpha(0.35);
        draw_set_color(c_black);

        draw_rectangle(
            _x + 3, _y + 3,
            _x + _w + 3, _y + _h + 3,
            false
        );

        // * Main Panel *
        draw_set_alpha(0.95);
        draw_set_color(_bg);

        draw_rectangle(
            _x, _y,
            _x + _w, _y + _h,
            false
        );

        // * Border *
        draw_set_alpha(1);
        draw_set_color(_border);

        draw_rectangle(
            _x, _y,
            _x + _w, _y + _h,
            true
        );

        // ** Panel Header **

        draw_set_color(_header);

        draw_rectangle(
            _x + 1, _y + 1,
            _x + _w - 1, _y + 27,
            false
        );

        // * Accent Line *
        draw_set_color(_accent);

        draw_rectangle(
            _x + 1, _y + 27,
            _x + _w - 1, _y + 28,
            false
        );

        // * Title *
        draw_set_color(_text);
        draw_text(_x + 10, _y + 8, "MOVEMENT DEBUG");

        // * Shortcut *
        draw_set_color(_accent);
        draw_text(_x + _w - 28, _y + 8, "F3");

        // ** Physics Information **

        // * Physics State *
        draw_set_color(_muted);
        draw_text(_x + 10, _y + 37, "STATE");

        draw_set_color(_accent);
        draw_text(_x + 78, _y + 37, string(_p.state));

        // * Horizontal Velocity *
        draw_set_color(_muted);
        draw_text(_x + 10, _y + 56, "VX");

        draw_set_color(_text);
        draw_text(
            _x + 35, _y + 56,
            string_format(_p.vx, 1, 1)
        );

        // * Vertical Velocity *
        draw_set_color(_muted);
        draw_text(_x + 113, _y + 56, "VY");

        draw_set_color(_text);
        draw_text(
            _x + 138, _y + 56,
            string_format(_p.vy, 1, 1)
        );

        // * Grounded Status *
        draw_set_color(_muted);
        draw_text(_x + 10, _y + 76, "GROUND");

        draw_set_color(
            _p.grounded ? _accent : c_red
        );

        draw_text(
            _x + 78, _y + 76,
            _p.grounded ? "YES" : "NO"
        );

        // * Dash Count *
        draw_set_color(_muted);
        draw_text(_x + 137, _y + 76, "DASH");

        draw_set_color(_text);
        draw_text(
            _x + 181, _y + 76,
            string(_p.dashes)
        );

        // * Jump Buffer *
        draw_set_color(_muted);
        draw_text(_x + 10, _y + 96, "BUFFER");

        draw_set_color(_text);
        draw_text(
            _x + 78, _y + 96,
            string_format(_p.jump_buffer, 1, 2)
        );

        // ** Resource Bars **

        // * Stamina Bar *
        var _stamina_ratio = clamp(
            _p.stamina / max(1, _p.c.ClimbMaxStamina),
            0, 1
        );

        draw_set_color(_muted);
        draw_text(_x + 10, _y + 116, "STAMINA");

        draw_set_color(_accent);
        draw_text(
            _x + 143, _y + 116,
            string(round(_p.stamina))
        );

        draw_set_color(_header);
        draw_rectangle(
            _x + 10, _y + 133,
            _x + _w - 10, _y + 138,
            false
        );

        draw_set_color(_accent);
        draw_rectangle(
            _x + 10, _y + 133,
            _x + 10 + (_w - 20) * _stamina_ratio,
            _y + 138,
            false
        );

        // * Jump Grace Bar *
        var _grace_ratio = clamp(
            _p.grace / max(0.001, _p.c.JumpGraceTime),
            0, 1
        );

        draw_set_color(_muted);
        draw_text(_x + 10, _y + 145, "JUMP GRACE");

        draw_set_color(_text);
        draw_text(
            _x + 143, _y + 145,
            string_format(_p.grace, 1, 2)
        );

        draw_set_color(_header);
        draw_rectangle(
            _x + 10, _y + 162,
            _x + _w - 10, _y + 167,
            false
        );

        draw_set_color(_blue);
        draw_rectangle(
            _x + 10, _y + 162,
            _x + 10 + (_w - 20) * _grace_ratio,
            _y + 167,
            false
        );

        // ** Restore Draw Settings **
        draw_set_alpha(_old_alpha);
        draw_set_color(_old_color);
        draw_set_halign(_old_halign);
        draw_set_valign(_old_valign);
    }
}