// ** Tile Variation Initialization **

// * Initialize Random Seed *
randomize();

// * Define Equivalent Tile Groups *
// ** Tile Variation Rules **

// * Define Random Tile Variations *
var _rules = [
    {
        base: 22,
        variants: [23, 24, 25],
        chance: 0.75
    }, // Right Wall

    {
        base: 15,
        variants: [16, 17, 18],
        chance: 0.75
    }, // Left Wall

    {
        base: 1,
        variants: [2, 3, 4],
        chance: 0.75
    }, // Floor

    {
        base: 8,
        variants: [9, 10, 11],
        chance: 0.75
    }, // Ceiling

    {
        base: 78,
        variants: [79, 80, 81],
        chance: 0.75
    }, // Corner Up Left

    {
        base: 85,
        variants: [86, 87, 88],
        chance: 0.75
    }, // Corner Up Right

    {
        base: 92,
        variants: [93, 94, 95],
        chance: 0.75
    }, // Corner Down Left
	
	
    {
        base: 99,
        variants: [100, 101, 102],
        chance: 0.75
    } // Corner Down Left
];

// * Randomize Visual Tile Layer *
Scr_Tile_Variations("Tilesets", _rules);

// * Randomize Visual Tile Layer *
Scr_Tile_Variations("Tilesets", _rules);