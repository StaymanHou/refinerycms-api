if defined?(Refinery::Blog)
  module Refinery
    module Api
      module V1
        module Blog
          class PostsController < Refinery::Api::BaseController

            def index
              byebug
              if params[:ids]
                @posts = Refinery::Blog::Post.
                          where(id: params[:ids].split(','))
              else
                @posts = Refinery::Blog::Post.
                          # ransack(params[:q]).result
                          newest_first
              end

              respond_with(@posts)
            end

            def show
              @post = post
              respond_with(@post)
            end

            private

            def post
              @post ||= Refinery::Blog::Post.
                          find(params[:id])
            end

            def post_params
              if params[:post] && !params[:post].empty?
                params.require(:post).permit(permitted_blog_post_attributes)
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