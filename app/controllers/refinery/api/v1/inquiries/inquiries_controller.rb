if defined?(Refinery::Inquiries)
  module Refinery
    module Api
      module V1
        module Inquiries
          class InquiriesController < Refinery::Api::BaseController

            def index
              if params[:ids]
                @inquiries = Refinery::Inquiries::Inquiry.
                          where(id: params[:ids].split(','))
              else
                @inquiries = Refinery::Inquiries::Inquiry.
                          # ransack(params[:q]).result
                          order("created_at DESC")
              end

              respond_with(@inquiries)
            end

            def show
              @inquiry = inquiry
              respond_with(@inquiry)
            end

            private

            def inquiry
              @inquiry ||= Refinery::Inquiries::Inquiry.
                          find(params[:id])
            end

            def inquiry_params
              if params[:inquiry] && !params[:inquiry].empty?
                params.require(:inquiry).permit(permitted_inquiries_inquiry_attributes)
              else
                {}
              end
            end

          end
        end
      end
    end
  end
end