require_dependency 'refinery/api/controller_setup'

module Refinery
  module Api
    class BaseController < ActionController::Base
      include Refinery::Api::ControllerSetup
      include Refinery::Api::ControllerHelpers::StrongParameters

      before_action :set_content_type
      before_action :authenticate_token

      rescue_from ActionController::ParameterMissing, with: :error_during_processing
      rescue_from ActiveRecord::RecordInvalid, with: :error_during_processing
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from Refinery::Api::GatewayError, with: :gateway_error

      helper Refinery::Api::ApiHelpers

      def map_nested_attributes_keys(klass, attributes)
        nested_keys = klass.nested_attributes_options.keys
        attributes.inject({}) do |h, (k,v)|
          key = nested_keys.include?(k.to_sym) ? "#{k}_attributes" : k
          h[key] = v
          h
        end.with_indifferent_access
      end

      def content_type
        case params[:format]
        when "json"
          "application/json; charset=utf-8"
        when "xml"
          "text/xml; charset=utf-8"
        end
      end

      private

      def set_content_type
        headers["Content-Type"] = content_type
      end

      def authenticate_token
        return unless requires_authentication?
        return if api_key.present? && api_key == auth_token

        if api_key.blank?
          render "refinery/api/errors/must_specify_api_key", status: 401 and return
        end

        render "refinery/api/errors/invalid_api_key", status: 401 and return
      end

      def unauthorized
        render "refinery/api/errors/unauthorized", status: 401 and return
      end

      def error_during_processing(exception)
        Rails.logger.error exception.message
        Rails.logger.error exception.backtrace.join("\n")

        unprocessable_entity(exception.message)
      end

      def unprocessable_entity(message)
        render text: { exception: message }.to_json, status: 422
      end

      def gateway_error(exception)
        @order.errors.add(:base, exception.message)
        invalid_resource!(@order)
      end

      def requires_authentication?
        Refinery::Api.requires_authentication
      end

      def auth_token
        Refinery::Api.auth_token
      end

      def not_found
        render "refinery/api/errors/not_found", status: 404 and return
      end

      def invalid_resource!(resource)
        @resource = resource
        render "refinery/api/errors/invalid_resource", status: 422
      end

      def api_key
        request.headers["X-Refinery-Token"] || params[:token]
      end
      helper_method :api_key
    end
  end
end
