module Refinery
  module Api
    module V1
      class ResourcesController < Refinery::Api::BaseController
        def index
          if params[:ids]
            @resources = Refinery::Resource.
                          includes(:translations).
                          where(id: params[:ids].split(','))
          else
            @resources = Refinery::Resource.
                          includes(:translations).
                          # load.ransack(params[:q]).result
                          all
          end
          respond_with(@resources)
        end

        def show
          @resource = Refinery::Resource.
                        includes(:translations).
                        find(params[:id])
          respond_with(@resource)
        end

        private

        def resource_params
          params.require(:resource).permit(permitted_resource_attributes)
        end
      end
    end
  end
end