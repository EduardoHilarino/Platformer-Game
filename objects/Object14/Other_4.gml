// ** Tile Variation Initialization **

// * Initialize Random Seed *
randomize();

// * Define Equivalent Tile Groups *
var _groups = [
    [22, 23, 24, 25], // Right Wall
    [15, 16, 17, 18], // Left Wall
    [1, 2, 3, 4],     // Floor
    [8, 9, 10, 11],   // Ceiling
	[78, 79, 80, 81], // Corner up left
	[85, 86, 87, 88], // Corner up right
	[92, 93, 94, 95]  // Corner down left
];

// * Randomize Visual Tile Layer *
Scr_Tile_Variations("Tilesets", _groups);