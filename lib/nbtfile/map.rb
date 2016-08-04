module NBTFile
  module Map
    def self.base_map_colors
      @base_map_colors ||= [
        nil,
        [127,178,56],
        [247,233,163],
        [199,199,199],
        [255,0,0],
        [160,160,255],
        [167,167,167],
        [0,124,0],
        [255,255,255],
        [164,168,184],
        [151,109,77],
        [112,112,112],
        [64,64,255],
        [143,119,72],
        [255,252,245],
        [216,127,51],
        [178,76,216],
        [102,153,216],
        [229,229,51],
        [127,204,25],
        [242,127,165],
        [76,76,76],
        [153,153,153],
        [76,127,153],
        [127,63,178],
        [51,76,178],
        [102,76,51],
        [102,127,51],
        [153,51,51],
        [25,25,25],
        [250,238,77],
        [92,219,213],
        [74,128,255],
        [0,217,58],
        [129,86,49],
        [112,2,0]
      ]
    end

    def self.map_color_for_id(id)
      offset = id % 4
      base_id = (id - offset) / 4
      color = base_map_colors[base_id]
      if color
        multiplier = case offset
        when 0 then 180/255.0
        when 1 then 220/255.0
        when 2 then 1
        when 3 then 135/255.0
        end

        color = color.map do |c|
          (c * multiplier).to_i
        end
      end
      color
    end
  end
end
