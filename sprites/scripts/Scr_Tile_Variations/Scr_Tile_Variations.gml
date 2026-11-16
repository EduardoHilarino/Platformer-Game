
	// ** Random Tile Variations **

	// Replaces Specific Base Tiles With Equivalent Variations
	function Scr_Tile_Variations(_layer_name, _rules)
	{
	    // * Get Tile Layer *
	    var _layer = layer_get_id(_layer_name);

	    if (_layer == -1)
	    {
	        show_debug_message("Layer not found: " + _layer_name);
	        return;
	    }

	    var _map = layer_tilemap_get_id(_layer);

	    if (_map == -1)
	    {
	        show_debug_message("Invalid Tilemap!");
	        return;
	    }

	    // * Get Tilemap Size *
	    var _width = tilemap_get_width(_map);
	    var _height = tilemap_get_height(_map);

	    // * Check Every Tile *
	    for (var _y = 0; _y < _height; _y++)
	    {
	        for (var _x = 0; _x < _width; _x++)
	        {
	            var _data = tilemap_get(_map, _x, _y);

	            if (_data == -1) continue;

	            var _index = tile_get_index(_data);

	            if (_index <= 0) continue;

	            // * Find Matching Base Tile *
	            for (var _i = 0; _i < array_length(_rules); _i++)
	            {
	                var _rule = _rules[_i];

	                if (_index != _rule.base)
	                {
	                    continue;
	                }

	                // * Apply Random Chance *
	                if (random(1) < _rule.chance)
	                {
	                    var _variations = _rule.variants;

	                    if (array_length(_variations) > 0)
	                    {
	                        var _new_index = _variations[irandom(array_length(_variations) - 1)];

	                        // * Preserve Rotation And Flip *
	                        var _new_data = tile_set_index(_data, _new_index);

	                        tilemap_set(_map, _new_data, _x, _y);
	                    }
	                }

	                break;
	            }
	        }
	    }
	}

