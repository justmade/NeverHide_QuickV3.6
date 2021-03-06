return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.14.2",
  orientation = "orthogonal",
  renderorder = "left-down",
  width = 22,
  height = 12,
  tilewidth = 50,
  tileheight = 50,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "ground",
      firstgid = 1,
      tilewidth = 50,
      tileheight = 50,
      spacing = 0,
      margin = 0,
      image = "../ground.png",
      imagewidth = 250,
      imageheight = 150,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tilecount = 15,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "up",
      x = 0,
      y = 0,
      width = 22,
      height = 12,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        11, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
        11, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
        11, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
        11, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 7, 13, 13, 13, 14,
        11, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 7, 13, 13, 13, 2, 0, 0, 0, 1,
        11, 4, 4, 4, 4, 4, 4, 4, 4, 4, 7, 13, 13, 2, 0, 0, 0, 0, 0, 0, 0, 0,
        11, 4, 4, 4, 4, 4, 4, 7, 13, 13, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        11, 4, 4, 4, 7, 13, 13, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        11, 7, 13, 13, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "down",
      x = 0,
      y = 0,
      width = 22,
      height = 12,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 8, 9, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 8, 8, 8, 12, 4, 5, 8,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 8, 8, 12, 4, 4, 4, 4, 4, 4, 5,
        0, 0, 0, 0, 0, 0, 0, 0, 10, 8, 8, 12, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5,
        0, 0, 0, 0, 0, 0, 0, 0, 12, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5,
        0, 0, 0, 0, 0, 10, 8, 8, 12, 4, 4, 4, 4, 4, 4, 4, 7, 14, 4, 6, 14, 5,
        8, 8, 8, 8, 8, 12, 4, 4, 4, 4, 4, 13, 13, 4, 4, 4, 4, 4, 4, 4, 4, 5,
        12, 4, 4, 4, 6, 13, 13, 13, 13, 14, 4, 1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 5
      }
    }
  }
}
