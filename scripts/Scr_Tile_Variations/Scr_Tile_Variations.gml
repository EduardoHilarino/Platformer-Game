	// ** Random Tile Variations **

	// Randomizes Visual Tiles Using Groups Of Equivalent Tiles
	function Scr_Tile_Variations(_layer_name, _groups)
	{
	    // * Find Tile Layer *
	    var _layer = layer_get_id(_layer_name);

	    if (_layer == -1)
	    {
	        show_debug_message("Tile Layer not found: " + _layer_name);
	        return 0;
	    }

	    // * Get Tilemap *
	    var _map = layer_tilemap_get_id(_layer);

	    if (_map == -1)
	    {
	        show_debug_message("Invalid Tilemap: " + _layer_name);
	        return 0;
	    }

	    // * Get Tilemap Size *
	    var _width = tilemap_get_width(_map);
	    var _height = tilemap_get_height(_map);

	    var _changes = 0;

	    // * Read Every Tile Cell *
	    for (var _y = 0; _y < _height; _y++)
	    {
	        for (var _x = 0; _x < _width; _x++)
	        {
	            var _data = tilemap_get(_map, _x, _y);

	            // * Ignore Invalid Tiles *
	            if (_data == -1)
	            {
	                continue;
	            }

	            var _index = tile_get_index(_data);

	            // * Ignore Empty Tiles *
	            if (_index <= 0)
	            {
	                continue;
	            }

	            // * Search Matching Variation Group *
	            for (var _g = 0; _g < array_length(_groups); _g++)
	            {
	                var _variations = _groups[_g];

	                if (array_length(_variations) == 0)
	                {
	                    continue;
	                }

	                var _found = false;

	                for (var _i = 0; _i < array_length(_variations); _i++)
	                {
	                    if (_index == _variations[_i])
	                    {
	                        _found = true;
	                        break;
	                    }
	                }

	                // * Apply Random Variation *
	                if (_found)
	                {
	                    var _new_index = _variations[
	                        irandom(array_length(_variations) - 1)
	                    ];

	                    // * Preserve Tile Rotation And Flip *
	                    if (_new_index != _index)
	                    {
	                        _data = tile_set_index(_data, _new_index);

	                        if (tilemap_set(_map, _data, _x, _y))
	                        {
	                            _changes++;
	                        }
	                    }

	                    break;
	                }
	            }
	        }
	    }

	    // * Debug Information *
	    show_debug_message("Tile Variations Updated: " + string(_changes));

	    return _changes;
	}