// ** Celeste Movement Lab - Player Core **
// Educational GML Port Of The Celeste Player Mechanics
// Based On The Educational Core From The Movement Lab
// Original Celeste Player Code: Noel Berry (MIT License)
// All Velocities Use Pixels Per Second; Accelerations Use Pixels Per Second Squared
// The Collision World Uses Arrays Of Solid And One-Way Rectangle Structures
// The Player Position Is Measured At The Center Of The Feet
// The Update Function Must Be Called With A Fixed 1/60 Second Time Step

// ** 1. Configuration And Initialization **

// Returns Every Movement Constant Used By The Laboratory
function cl_constants()
{
    return {
        // * Horizontal Movement *
        MaxRun: 90,
        RunAccel: 1000,
        RunReduce: 400,
        AirMult: 0.65,
        // * Gravity And Falling *
        Gravity: 900,
        MaxFall: 160,
        FastMaxFall: 240,
        FastMaxAccel: 300,
        HalfGravThreshold: 40,
        JumpSpeed: -105,
        JumpHBoost: 40,
        // * Jump Assistance *
        VarJumpTime: 0.2,
        JumpGraceTime: 0.1,
        CeilingVarJumpGrace: 0.05,
        // * Collision Corrections *
        UpwardCornerCorrection: 4,
        WallSpeedRetentionTime: 0.06,
        // * Wall Movement *
        WallJumpCheckDist: 3,
        WallJumpForceTime: 0.16,
        WallJumpHSpeed: 130,
        WallSlideStartMax: 20,
        WallSlideTime: 1.2,
        // * Dash Movement *
        DashSpeed: 240,
        EndDashSpeed: 160,
        EndDashUpMult: 0.75,
        DashTime: 0.15,
        DashCooldown: 0.2,
        DashRefillCooldown: 0.1,
        DashAttackTime: 0.3,
        DashCornerCorrection: 4,
        DashHJumpThruNudge: 6,
        // * Ducking And Special Jumps *
        DuckFriction: 500,
        DodgeSlideSpeedMult: 1.2,
        DuckSuperJumpXMult: 1.25,
        DuckSuperJumpYMult: 0.5,
        SuperJumpH: 260,
        SuperWallJumpSpeed: -160,
        SuperWallJumpVarTime: 0.25,
        SuperWallJumpForceTime: 0.2,
        SuperWallJumpH: 170,
        // * Climb And Stamina *
        ClimbMaxStamina: 110,
        ClimbTiredThreshold: 20,
        ClimbUpCost: 100 / 2.2,
        ClimbStillCost: 10,
        ClimbJumpCost: 110 / 4,
        ClimbCheckDist: 2,
        ClimbUpCheckDist: 2,
        ClimbNoMoveTime: 0.1,
        ClimbUpSpeed: -45,
        ClimbDownSpeed: 80,
        ClimbSlipSpeed: 30,
        ClimbAccel: 900,
        ClimbGrabYMult: 0.2,
        ClimbHopY: -120,
        ClimbHopX: 100,
        ClimbHopForceTime: 0.2,
        ClimbJumpBoostTime: 0.2,
        // * Input Buffers And Freeze *
        JumpBufferTime: 0.1,
        DashBufferTime: 0.1,
        DashFreezeTime: 0.05
    };
}

// Creates A Neutral Input Structure
function cl_input_empty()
{
    return {
        mx: 0,
        my: 0,
        jump: false,
        jump_pressed: false,
        dash_pressed: false,
        grab: false
    };
}

// Creates And Initializes The Complete Player State
function cl_player_create(_x, _y)
{
    return {
        c: cl_constants(),
        px: _x,
        py: _y,
        vx: 0,
        vy: 0,
        rx: 0,
        ry: 0,
        state: "normal",
        facing: 1,
        duck: false,
        grounded: false,
        move_x: 0,
        move_y: 0,
        dashes: 1,
        stamina: 110,
        jump_buffer: 0,
        dash_buffer: 0,
        grace: 0,
        var_timer: 0,
        var_speed: 0,
        auto_jump: false,
        max_fall: 160,
        force_timer: 0,
        force_x: 0,
        slide_timer: 1.2,
        slide_dir: 0,
        wall_boost_timer: 0,
        wall_boost_dir: 0,
        retention_timer: 0,
        retained_vx: 0,
        hop_wait: 0,
        climb_wait: 0,
        climb_move: 0,
        dash_cooldown: 0,
        refill_cooldown: 0,
        dash_attack: 0,
        freeze: 0,
        dash_timer: 0,
        dash_pending: false,
        dash_x: 0,
        dash_y: 0,
        before_dash_vx: 0,
        last_event: "pronto",
        simulated_time: 0,
        last_input: cl_input_empty(),
        use_var_jump: true,
        use_apex: true,
        use_air_mult: true,
        use_jump_boost: true,
        use_corrections: true,
        use_freeze: true
    };
}

// ** 2. Math Utilities **

// Moves A Value Toward A Target Without Overshooting
function cl_approach(_v, _target, _amount)
{
    if (_v < _target)
    {
        return min(_v + _amount, _target);
    }
    return max(_v - _amount, _target);
}

// Rounds To The Nearest Integer With Even Tie Breaking
function cl_round(_v)
{
    var _lo = floor(_v);
    var _f = _v - _lo;
    if (_f < 0.5)
    {
        return _lo;
    }
    if (_f > 0.5)
    {
        return _lo + 1;
    }
    return (_lo % 2 == 0) ? _lo : _lo + 1;
}

// ** 3. Collision Queries **

// Returns The Standing Or Ducking Collision Height
function cl_height(_p)
{
    return _p.duck ? 6 : 11;
}

// Tests Two Axis-Aligned Rectangles For Overlap
function cl_overlap(_x, _y, _w, _h, _r)
{
    return _x < _r.x + _r.w && _x + _w > _r.x && _y < _r.y + _r.h && _y + _h > _r.y;
}

// Checks The Player Bounding Box Against Solid Rectangles
function cl_solid_at(_p, _world, _x, _y, _height)
{
    for (var _i = 0; _i < array_length(_world.solids); _i++)
    {
        if (cl_overlap(_x - 4, _y - _height, 8, _height, _world.solids[_i]))
        {
            return true;
        }
    }
    return false;
}

// Checks Whether A Point Is Inside Any Solid
function cl_point_solid(_world, _x, _y)
{
    for (var _i = 0; _i < array_length(_world.solids); _i++)
    {
        var _r = _world.solids[_i];
        if (_x >= _r.x && _x < _r.x + _r.w && _y >= _r.y && _y < _r.y + _r.h)
        {
            return true;
        }
    }
    return false;
}

// Detects Downward Crossing Of One-Way Platforms
function cl_oneway_cross(_p, _world, _x, _old_y, _new_y)
{
    if (_new_y <= _old_y)
    {
        return false;
    }
    for (var _i = 0; _i < array_length(_world.platforms); _i++)
    {
        var _r = _world.platforms[_i];
        if (_x - 4 < _r.x + _r.w && _x + 4 > _r.x && _old_y <= _r.y && _new_y > _r.y)
        {
            return true;
        }
    }
    return false;
}

// Checks Ground Contact While Respecting Rising Velocity
function cl_on_ground(_p, _world)
{
    if (_p.vy < 0)
    {
        return false;
    }
    return cl_solid_at(_p, _world, _p.px, _p.py + 1, cl_height(_p)) || cl_oneway_cross(_p, _world, _p.px, _p.py, _p.py + 1);
}

// Checks Whether There Is Enough Room To Stand
function cl_can_stand(_p, _world)
{
    return !cl_solid_at(_p, _world, _p.px, _p.py, 11);
}

// Checks For A Wall At The Requested Side And Distance
function cl_wall_check(_p, _world, _dir, _distance)
{
    return cl_solid_at(_p, _world, _p.px + _dir * _distance, _p.py, 11);
}

// ** 4. Normal State And Jump Mechanics **

// Restores The Normal Physics State
function cl_normal_begin(_p)
{
    _p.state = "normal";
    _p.max_fall = _p.c.MaxFall;
    _p.retention_timer = 0;
}

// Executes A Ground Jump And Starts Variable Jump Sustain
function cl_jump(_p)
{
    _p.jump_buffer = 0;
    _p.grace = 0;
    _p.var_timer = _p.c.VarJumpTime;
    _p.auto_jump = false;
    _p.dash_attack = 0;
    _p.slide_timer = _p.c.WallSlideTime;
    _p.wall_boost_timer = 0;
    if (_p.use_jump_boost)
    {
        _p.vx += _p.c.JumpHBoost * _p.move_x;
    }
    _p.vy = _p.c.JumpSpeed;
    _p.var_speed = _p.vy;
    _p.grounded = false;
    _p.last_event = "pulo";
}

// Executes A Normal Or Super Wall Jump
function cl_wall_jump(_p, _dir, _super)
{
    _p.duck = false;
    _p.jump_buffer = 0;
    _p.grace = 0;
    _p.auto_jump = false;
    _p.dash_attack = 0;
    _p.slide_timer = _p.c.WallSlideTime;
    _p.wall_boost_timer = 0;
    _p.hop_wait = 0;
    _p.var_timer = _super ? _p.c.SuperWallJumpVarTime : _p.c.VarJumpTime;
    if (_super || _p.move_x != 0)
    {
        _p.force_x = _dir;
        _p.force_timer = _super ? _p.c.SuperWallJumpForceTime : _p.c.WallJumpForceTime;
    }
    _p.vx = (_super ? _p.c.SuperWallJumpH : _p.c.WallJumpHSpeed) * _dir;
    _p.vy = _super ? _p.c.SuperWallJumpSpeed : _p.c.JumpSpeed;
    _p.var_speed = _p.vy;
    cl_normal_begin(_p);
    _p.last_event = _super ? "super wall jump" : "wall jump";
}

// Executes Super And Hyper Jump Variants
function cl_super_jump(_p)
{
    var _duck = _p.duck;
    cl_jump(_p);
    _p.vx = _p.c.SuperJumpH * _p.facing;
    if (_duck)
    {
        _p.duck = false;
        _p.vx *= _p.c.DuckSuperJumpXMult;
        _p.vy *= _p.c.DuckSuperJumpYMult;
    }
    _p.var_speed = _p.vy;
    cl_normal_begin(_p);
    _p.last_event = _duck ? "hyper jump" : "super jump";
}

// Executes A Jump While Grabbing A Wall
function cl_climb_jump(_p)
{
    if (!_p.grounded)
    {
        _p.stamina -= _p.c.ClimbJumpCost;
    }
    cl_jump(_p);
    cl_normal_begin(_p);
    if (_p.move_x == 0)
    {
        _p.wall_boost_dir = -_p.facing;
        _p.wall_boost_timer = _p.c.ClimbJumpBoostTime;
    }
    _p.last_event = "climb jump";
}

// ** 5. Climbing And Ledge Movement **

// Starts Wall Climbing And Initializes Stamina Controls
function cl_climb_begin(_p, _world)
{
    _p.state = "climb";
    _p.auto_jump = false;
    _p.duck = false;
    _p.vx = 0;
    _p.vy *= _p.c.ClimbGrabYMult;
    _p.slide_timer = _p.c.WallSlideTime;
    _p.climb_wait = _p.c.ClimbNoMoveTime;
    _p.wall_boost_timer = 0;
    _p.climb_move = 0;
    for (var _i = 0; _i < _p.c.ClimbCheckDist; _i++)
    {
        if (!cl_wall_check(_p, _world, _p.facing, 1))
        {
            _p.px += _p.facing;
        }
        else
        {
            break;
        }
    }
    _p.last_event = "agarrou parede";
}

// Moves The Player Across A Climbable Ledge
function cl_climb_hop(_p, _world)
{
    if (cl_wall_check(_p, _world, _p.facing, 1))
    {
        _p.hop_wait = _p.facing;
    }
    else
    {
        _p.hop_wait = 0;
        _p.vx = _p.facing * _p.c.ClimbHopX;
    }
    _p.vy = min(_p.vy, _p.c.ClimbHopY);
    _p.force_x = 0;
    _p.force_timer = _p.c.ClimbHopForceTime;
    cl_normal_begin(_p);
    _p.last_event = "subiu borda";
}

// Checks Whether The Player Should Slip At A Ledge
function cl_slip_check(_p, _world, _add_y)
{
    var _x = _p.px + (_p.facing == 1 ? 4 : -5);
    var _y = _p.py - 11 + 4 + _add_y;
    return !cl_point_solid(_world, _x, _y) && !cl_point_solid(_world, _x, _y - 4 + _add_y);
}

// ** 6. Dash Mechanics **

// Checks Buffered Dash Input And Dash Availability
function cl_can_dash(_p)
{
    return _p.dash_buffer > 0 && _p.dashes > 0 && _p.dash_cooldown <= 0;
}

// Starts Dash Timers And Clears Previous Movement
function cl_dash_begin(_p, _world)
{
    _p.dashes -= 1;
    _p.dash_buffer = 0;
    _p.state = "dash";
    _p.before_dash_vx = _p.vx;
    _p.vx = 0;
    _p.vy = 0;
    _p.var_timer = 0;
    _p.dash_x = 0;
    _p.dash_y = 0;
    _p.dash_pending = true;
    _p.dash_timer = _p.c.DashTime;
    _p.freeze = _p.use_freeze ? _p.c.DashFreezeTime : 0;
    _p.dash_cooldown = _p.c.DashCooldown;
    _p.refill_cooldown = _p.c.DashRefillCooldown;
    _p.dash_attack = _p.c.DashAttackTime;
    _p.slide_timer = _p.c.WallSlideTime;
    _p.wall_boost_timer = 0;
    _p.retention_timer = 0;
    _p.hop_wait = 0;
    if (!_p.grounded && cl_can_stand(_p, _world))
    {
        _p.duck = false;
    }
    _p.last_event = "inicio do dash";
}

// Calculates Dash Direction And Initial Velocity
function cl_dash_launch(_p, _input)
{
    var _dx = _input.mx;
    var _dy = _input.my;
    if (_dx == 0 && _dy == 0)
    {
        _dx = _p.facing;
    }
    var _len = sqrt(_dx * _dx + _dy * _dy);
    _p.dash_x = _dx / _len;
    _p.dash_y = _dy / _len;
    _p.vx = _p.dash_x * _p.c.DashSpeed;
    _p.vy = _p.dash_y * _p.c.DashSpeed;
    if (sign(_p.before_dash_vx) == sign(_p.vx) && abs(_p.before_dash_vx) > abs(_p.vx))
    {
        _p.vx = _p.before_dash_vx;
    }
    if (_p.dash_x != 0)
    {
        _p.facing = sign(_p.dash_x);
    }
    if (_p.grounded && _p.dash_x != 0 && _p.dash_y > 0)
    {
        _p.dash_x = sign(_p.dash_x);
        _p.dash_y = 0;
        _p.vy = 0;
        _p.vx *= _p.c.DodgeSlideSpeedMult;
        _p.duck = true;
    }
    _p.dash_pending = false;
    _p.last_event = "dash";
}

// Restores Normal Movement With Dash Exit Velocity
function cl_dash_end(_p)
{
    _p.auto_jump = true;
    if (_p.dash_y <= 0)
    {
        _p.vx = _p.dash_x * _p.c.EndDashSpeed;
        _p.vy = _p.dash_y * _p.c.EndDashSpeed;
    }
    if (_p.vy < 0)
    {
        _p.vy *= _p.c.EndDashUpMult;
    }
    cl_normal_begin(_p);
    _p.last_event = "fim do dash";
}

// ** 7. Normal Physics Update **

// Updates Running, Gravity, Wall Sliding, Jumping And Dash Entry
function cl_normal_update(_p, _world, _input, _dt)
{
    // * Climb Entry *
    var _c = _p.c;
    var _stamina = _p.stamina + (_p.wall_boost_timer > 0 ? _c.ClimbJumpCost : 0);
    if (_input.grab && _stamina >= _c.ClimbTiredThreshold && !_p.duck && _p.vy >= 0 && sign(_p.vx) != -_p.facing)
    {
        if (cl_wall_check(_p, _world, _p.facing, _c.ClimbCheckDist))
        {
            cl_climb_begin(_p, _world);
            return;
        }
        if (_input.my < 1)
        {
            for (var _offset = 1; _offset <= _c.ClimbUpCheckDist; _offset++)
            {
                if (!cl_solid_at(_p, _world, _p.px, _p.py - _offset, 11) &&
                    cl_solid_at(_p, _world, _p.px + _p.facing * _c.ClimbCheckDist, _p.py - _offset, 11))
                {
                    _p.py -= _offset;
                    cl_climb_begin(_p, _world);
                    return;
                }
            }
        }
    }
    // * Dash Entry *
    if (cl_can_dash(_p))
    {
        cl_dash_begin(_p, _world);
        return;
    }
    if (_p.duck)
    {
        if (_p.grounded && _input.my != 1 && cl_can_stand(_p, _world))
        {
            _p.duck = false;
        }
    }
    else if (_p.grounded && _input.my == 1 && _p.vy >= 0)
    {
        _p.duck = true;
    }
    if (_p.duck && _p.grounded)
    {
        _p.vx = cl_approach(_p.vx, 0, _c.DuckFriction * _dt);
    }
    else
    {
        var _mult = (_p.grounded || !_p.use_air_mult) ? 1 : _c.AirMult;
        var _rate = (abs(_p.vx) > _c.MaxRun && sign(_p.vx) == _p.move_x) ? _c.RunReduce : _c.RunAccel;
        _p.vx = cl_approach(_p.vx, _c.MaxRun * _p.move_x, _rate * _mult * _dt);
    }
    // * Falling And Gravity *
    var _fall_target = (_input.my == 1 && _p.vy >= _c.MaxFall) ? _c.FastMaxFall : _c.MaxFall;
    _p.max_fall = cl_approach(_p.max_fall, _fall_target, _c.FastMaxAccel * _dt);
    if (!_p.grounded)
    {
        var _max = _p.max_fall;
        if ((_p.move_x == _p.facing ||
            (_p.move_x == 0 &&
            _input.grab)) &&
            _input.my != 1 &&
            _p.vy >= 0 &&
            _p.slide_timer > 0 &&
            cl_can_stand(_p, _world) &&
            cl_wall_check(_p, _world, _p.facing, 1))
        {
            _p.duck = false;
            _p.slide_dir = _p.facing;
            _max = lerp(_c.MaxFall, _c.WallSlideStartMax, _p.slide_timer / _c.WallSlideTime);
        }
        var _gm = (_p.use_apex && abs(_p.vy) < _c.HalfGravThreshold && (_input.jump || _p.auto_jump)) ? 0.5 : 1;
        _p.vy = cl_approach(_p.vy, _max, _c.Gravity * _gm * _dt);
    }
    if (_p.var_timer > 0)
    {
        if (_p.use_var_jump && (_input.jump || _p.auto_jump))
        {
            _p.vy = min(_p.vy, _p.var_speed);
        }
        else
        {
            _p.var_timer = 0;
        }
    }
    // * Buffered Jump Execution *
    if (_p.jump_buffer > 0)
    {
        if (_p.grace > 0)
        {
            cl_jump(_p);
        }
        else if (cl_can_stand(_p, _world))
        {
            for (var _side = 1; _side >= -1; _side -= 2)
            {
                if (cl_wall_check(_p, _world, _side, _c.WallJumpCheckDist))
                {
                    if (_p.facing == _side && _input.grab && _p.stamina > 0)
                    {
                        cl_climb_jump(_p);
                    }
                    else
                    {
                        cl_wall_jump(_p, -_side, _p.dash_attack > 0 && _p.dash_x == 0 && _p.dash_y == -1);
                    }
                    break;
                }
            }
        }
    }
}

// ** 8. Climb And Dash State Updates **

// Updates Wall Grabbing, Climbing And Stamina Consumption
function cl_climb_update(_p, _world, _input, _dt)
{
    var _c = _p.c;
    _p.climb_wait -= _dt;
    if (_p.jump_buffer > 0 && cl_can_stand(_p, _world))
    {
        if (_p.move_x == -_p.facing)
        {
            cl_wall_jump(_p, -_p.facing, false);
        }
        else
        {
            cl_climb_jump(_p);
        }
        return;
    }
    if (cl_can_dash(_p))
    {
        cl_dash_begin(_p, _world);
        return;
    }
    if (!_input.grab)
    {
        cl_normal_begin(_p);
        _p.last_event = "soltou parede";
        return;
    }
    if (!cl_wall_check(_p, _world, _p.facing, 1))
    {
        if (_p.vy < 0)
        {
            cl_climb_hop(_p, _world);
        }
        else
        {
            cl_normal_begin(_p);
        }
        return;
    }
    var _target = 0;
    var _try_slip = false;
    // * Climb Input And Stamina *
    if (_p.climb_wait <= 0)
    {
        if (_input.my == -1)
        {
            _target = _c.ClimbUpSpeed;
            if (cl_solid_at(_p, _world, _p.px, _p.py - 1, 11))
            {
                if (_p.vy < 0)
                {
                    _p.vy = 0;
                }
                _target = 0;
                _try_slip = true;
            }
            else if (cl_slip_check(_p, _world, 0))
            {
                cl_climb_hop(_p, _world);
                return;
            }
        }
        else if (_input.my == 1)
        {
            _target = _c.ClimbDownSpeed;
            if (_p.grounded)
            {
                if (_p.vy > 0)
                {
                    _p.vy = 0;
                }
                _target = 0;
            }
        }
        else
        {
            _try_slip = true;
        }
    }
    else
    {
        _try_slip = true;
    }
    _p.climb_move = sign(_target);
    if (_try_slip && cl_slip_check(_p, _world, 0))
    {
        _target = _c.ClimbSlipSpeed;
    }
    _p.vy = cl_approach(_p.vy, _target, _c.ClimbAccel * _dt);
    if (_input.my != 1 && _p.vy > 0 && !cl_solid_at(_p, _world, _p.px + _p.facing, _p.py + 1, 11))
    {
        _p.vy = 0;
    }
    if (_p.climb_wait <= 0)
    {
        if (_p.climb_move == -1)
        {
            _p.stamina -= _c.ClimbUpCost * _dt;
        }
        else if (_p.climb_move == 0)
        {
            _p.stamina -= _c.ClimbStillCost * _dt;
        }
    }
    if (_p.stamina <= 0)
    {
        _p.stamina = 0;
        cl_normal_begin(_p);
        _p.last_event = "sem stamina";
    }
}

// Handles Dash Continuation And Jump Interruptions
function cl_dash_update(_p, _world, _input)
{
    if (_p.dash_pending)
    {
        cl_dash_launch(_p, _input);
    }
    if (_p.dash_x != 0 && _p.dash_y == 0 && _p.use_corrections)
    {
        for (var _i = 0; _i < array_length(_world.platforms); _i++)
        {
            var _r = _world.platforms[_i];
            if (cl_overlap(_p.px - 4, _p.py - cl_height(_p), 8, cl_height(_p), _r) &&
                _p.py - _r.y <= _p.c.DashHJumpThruNudge &&
                !cl_solid_at(_p, _world, _p.px, _r.y, cl_height(_p)))
            {
                _p.py = _r.y;
            }
        }
    }
    if (_p.jump_buffer > 0 && cl_can_stand(_p, _world))
    {
        if (_p.dash_y == 0 && _p.grace > 0)
        {
            cl_super_jump(_p);
            return;
        }
        for (var _side = 1; _side >= -1; _side -= 2)
        {
            if (cl_wall_check(_p, _world, _side, _p.c.WallJumpCheckDist))
            {
                cl_wall_jump(_p, -_side, _p.dash_x == 0 && _p.dash_y == -1);
                return;
            }
        }
    }
}

// ** 9. Pixel-Perfect Movement And Collisions **

// Moves Horizontally With Fractional Remainders And Corner Correction
function cl_move_h(_p, _world, _amount)
{
    // * Horizontal Fractional Movement *
    _p.rx += _amount;
    var _move = cl_round(_p.rx);
    _p.rx -= _move;
    var _dir = sign(_move);
    for (var _step = 0; _step < abs(_move); _step++)
    {
        if (!cl_solid_at(_p, _world, _p.px + _dir, _p.py, cl_height(_p)))
        {
            _p.px += _dir;
            continue;
        }
        var _fixed = false;
        if (_p.use_corrections && _p.state == "dash" && _p.dash_y == 0 && !_p.duck)
        {
            for (var _offset = 1; _offset <= _p.c.DashCornerCorrection && !_fixed; _offset++)
            {
                for (var _side = -1; _side <= 1; _side += 2)
                {
                    if (_p.grounded && _side == 1)
                    {
                        continue;
                    }
                    if (!cl_solid_at(_p, _world, _p.px, _p.py + _offset * _side, cl_height(_p)) &&
                        !cl_solid_at(_p, _world, _p.px + _dir, _p.py + _offset * _side, cl_height(_p)))
                    {
                        _p.py += _offset * _side;
                        _p.px += _dir;
                        _fixed = true;
                        break;
                    }
                }
            }
        }
        if (_fixed)
        {
            continue;
        }
        if (_p.retention_timer <= 0)
        {
            _p.retained_vx = _p.vx;
            _p.retention_timer = _p.c.WallSpeedRetentionTime;
        }
        _p.vx = 0;
        _p.rx = 0;
        break;
    }
}

// Moves Vertically With Fractional Remainders And Ceiling Correction
function cl_move_v(_p, _world, _amount)
{
    // * Vertical Fractional Movement *
    _p.ry += _amount;
    var _move = cl_round(_p.ry);
    _p.ry -= _move;
    var _dir = sign(_move);
    for (var _step = 0; _step < abs(_move); _step++)
    {
        var _solid = cl_solid_at(_p, _world, _p.px, _p.py + _dir, cl_height(_p));
        var _oneway = cl_oneway_cross(_p, _world, _p.px, _p.py, _p.py + _dir);
        if (!_solid && !_oneway)
        {
            _p.py += _dir;
            continue;
        }
        var _fixed = false;
        if (_dir < 0 && _p.use_corrections)
        {
            for (var _offset = 1; _offset <= _p.c.UpwardCornerCorrection && !_fixed; _offset++)
            {
                for (var _side = -1; _side <= 1; _side += 2)
                {
                    if ((_side < 0 && _p.vx > 0) || (_side > 0 && _p.vx < 0))
                    {
                        continue;
                    }
                    if (!cl_solid_at(_p, _world, _p.px + _offset * _side, _p.py, cl_height(_p)) &&
                        !cl_solid_at(_p, _world, _p.px + _offset * _side, _p.py - 1, cl_height(_p)))
                    {
                        _p.px += _offset * _side;
                        _p.py -= 1;
                        _fixed = true;
                        break;
                    }
                }
            }
        }
        if (_fixed)
        {
            continue;
        }
        if (_dir < 0 && _p.var_timer < _p.c.VarJumpTime - _p.c.CeilingVarJumpGrace)
        {
            _p.var_timer = 0;
        }
        if (_dir > 0 && _p.state == "dash" && _p.dash_x != 0 && _p.dash_y > 0)
        {
            _p.dash_x = sign(_p.dash_x);
            _p.dash_y = 0;
            _p.vx *= _p.c.DodgeSlideSpeedMult;
            _p.duck = true;
        }
        _p.vy = 0;
        _p.ry = 0;
        break;
    }
}

// ** 10. Main Physics Update **

// Advances Timers, States And Collisions By One Fixed Physics Step
function cl_tick(_p, _world, _input, _dt)
{
    // * Input Buffers *
    _p.last_input = _input;
    _p.jump_buffer = _input.jump_pressed ? _p.c.JumpBufferTime : max(0, _p.jump_buffer - _dt);
    _p.dash_buffer = _input.dash_pressed ? _p.c.DashBufferTime : max(0, _p.dash_buffer - _dt);
    if (_p.freeze > 0)
    {
        _p.freeze = max(0, _p.freeze - _dt);
        return;
    }
    // * Ground And State Timers *
    _p.simulated_time += _dt;
    _p.grounded = cl_on_ground(_p, _world);
    _p.move_x = _input.mx;
    _p.move_y = _input.my;
    if (_p.slide_dir != 0)
    {
        _p.slide_timer = max(0, _p.slide_timer - _dt);
    }
    _p.slide_dir = 0;
    if (_p.wall_boost_timer > 0)
    {
        _p.wall_boost_timer -= _dt;
        if (_p.move_x == _p.wall_boost_dir)
        {
            _p.vx = _p.c.WallJumpHSpeed * _p.move_x;
            _p.stamina = min(_p.c.ClimbMaxStamina, _p.stamina + _p.c.ClimbJumpCost);
            _p.wall_boost_timer = 0;
        }
    }
    if (_p.grounded)
    {
        _p.grace = _p.c.JumpGraceTime;
        _p.stamina = _p.c.ClimbMaxStamina;
        if (_p.state != "climb")
        {
            _p.auto_jump = false;
            _p.slide_timer = _p.c.WallSlideTime;
        }
    }
    else
    {
        _p.grace = max(0, _p.grace - _dt);
    }
    _p.dash_cooldown = max(0, _p.dash_cooldown - _dt);
    if (_p.refill_cooldown > 0)
    {
        _p.refill_cooldown = max(0, _p.refill_cooldown - _dt);
    }
    else if (_p.grounded)
    {
        _p.dashes = 1;
    }
    _p.dash_attack = max(0, _p.dash_attack - _dt);
    _p.var_timer = max(0, _p.var_timer - _dt);
    if (_p.force_timer > 0)
    {
        _p.force_timer = max(0, _p.force_timer - _dt);
        _p.move_x = _p.force_x;
    }
    if (_p.move_x != 0 && _p.state != "climb")
    {
        _p.facing = _p.move_x;
    }
    if (_p.retention_timer > 0)
    {
        if (sign(_p.vx) == -sign(_p.retained_vx))
        {
            _p.retention_timer = 0;
        }
        else if (!cl_wall_check(_p, _world, sign(_p.retained_vx), 1))
        {
            _p.vx = _p.retained_vx;
            _p.retention_timer = 0;
        }
        else
        {
            _p.retention_timer = max(0, _p.retention_timer - _dt);
        }
    }
    if (_p.hop_wait != 0)
    {
        if (sign(_p.vx) == -_p.hop_wait || _p.vy > 0)
        {
            _p.hop_wait = 0;
        }
        else if (!cl_wall_check(_p, _world, _p.hop_wait, 1))
        {
            _p.vx = _p.c.ClimbHopX * _p.hop_wait;
            _p.hop_wait = 0;
        }
    }
    // * State Execution *
    if (_p.state == "normal")
    {
        cl_normal_update(_p, _world, _input, _dt);
    }
    else if (_p.state == "climb")
    {
        cl_climb_update(_p, _world, _input, _dt);
    }
    else if (_p.state == "dash")
    {
        cl_dash_update(_p, _world, _input);
    }
    if (_p.freeze > 0 || _p.dash_pending)
    {
        return;
    }
    // * Apply Movement And Collisions *
    cl_move_h(_p, _world, _p.vx * _dt);
    cl_move_v(_p, _world, _p.vy * _dt);
    if (_p.state == "dash")
    {
        _p.dash_timer -= _dt;
        if (_p.dash_timer <= 0.000001)
        {
            cl_dash_end(_p);
        }
    }
    _p.grounded = cl_on_ground(_p, _world);
}
