class Map < ActiveRecord::Base
  require 'nbtfile'
  require 'nbtfile/map'
  require 'RMagick'

  mount_uploader :image, MapUploader

  def self.create_or_update_from_data_file(io, map_id)
    data = NBTFile.load(io).last['data']

    map = Map.find_or_initialize_by(
      :map_id => map_id,
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

    begin
      gc.draw canvas
    rescue => e
      puts e
    end

    NamedTempfile.open_tempfile('map.png', 'wb+') do |file|
      canvas.write file.path
      map.image = file
    end

    map.save

    map
  end

  def self.max_edge(axis)
    dimension = axis.to_s == 'x' ? 'width' : 'height'
    maximum("#{table_name}.center_#{axis} + #{table_name}.#{dimension} / 2 * power(2, #{table_name}.scale)")
  end

  def self.min_edge(axis)
    dimension = axis.to_s == 'x' ? 'width' : 'height'
    minimum("#{table_name}.center_#{axis} - #{table_name}.#{dimension} / 2 * power(2, #{table_name}.scale)")
  end
end
