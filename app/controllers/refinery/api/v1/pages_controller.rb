module Refinery
  module Api
    module V1
      class PagesController < Refinery::Api::BaseController

        def index
          if params[:ids]
            @pages = Refinery::Page.
                      includes(:translations, :children).
                      where(id: params[:ids].split(','))
          else
            @pages = Refinery::Page.
                      includes(:translations, :children).
                      # ransack(params[:q]).result
                      order(:lft)
          end

          respond_with(@pages)
        end

        def show
          @page = page
          respond_with(@page)
        end

        private

        def page
          @page ||= Refinery::Page.
                      includes(:translations, :parts).
                      find(params[:id])
        end

        def page_params
          if params[:page] && !params[:page].empty?
            params.require(:page).permit(permitted_page_attributes)
          else
            {}
          end
        end

      end
    end
  end
end