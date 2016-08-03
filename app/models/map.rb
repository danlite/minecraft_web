class Map < ActiveRecord::Base
  require 'NBTFile'
  require 'NBTFile/map'

  mount_uploader :image, MapUploader

  def self.create_from_data_file(io)
    data = NBTFile.load(io).last['data']

    map = Map.new(
      :width => data['width'],
      :height => data['height'],
      :center_x => data['xCenter'],
      :center_z => data['zCenter'],
      :scale => data['scale'],
      :dimension_id => data['dimension']
    )

    colors = data['colors'].each_byte.map(&:to_i).map do |id|
      NBTFile::Map.map_color_for_id(id)
    end

    canvas = Magick::Image.new(map.width, map.height) do
      self.background_color = 'transparent'
      self.format = 'png'
    end
    gc = Magick::Draw.new

    map.height.times do |row|
      map.width.times do |column|
        rgb = colors[row*map.width + column]
        next unless rgb

        gc.fill "rgb(#{rgb.join(',')})"
        gc.point column, row
      end
    end

    gc.draw canvas

    NamedTempfile.open_tempfile('map.png', 'wb+') do |file|
      canvas.write file.path
      map.image = file
    end

    map.save

    map
  end
end
