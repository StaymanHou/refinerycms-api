module Refinery
  module Api
    module V1
      class ImagesController < Refinery::Api::BaseController
        def index
          @images = Refinery::Image.
                      includes(:translations)
          respond_with(@images)
        end

        def show
          @image = Refinery::Image.
                    includes(:translations).
                    find(params[:id])
          respond_with(@image)
        end

        protected

        def auto_title(filename)
          CGI::unescape(filename.to_s).gsub(/\.\w+$/, '').titleize
        end

        private

        def image_params
          params.require(:image).permit(permitted_image_attributes)
        end
      end
    end
  end
end