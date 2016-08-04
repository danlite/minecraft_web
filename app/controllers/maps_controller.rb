class MapsController < ApplicationController
  def index
    @maps = Map.where(dimension: 0)
  end
end
