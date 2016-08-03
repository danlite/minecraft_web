class Map < ActiveRecord::Base
  mount_uploader :image, MapUploader
end
