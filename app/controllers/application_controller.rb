class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def index
    @maps = Map.where(dimension_id: 0)
  end

  def upload_map
    map = Map.create_or_update_from_data_file(params[:map][:file], params[:map][:map_id])

    if map.valid? && map.persisted?
      head :created
    else
      head :unprocessable_entity
    end
  end
end
