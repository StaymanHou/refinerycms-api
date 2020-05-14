Refinery::Core::Engine.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :images, only: [:index, :show]

      resources :pages, only: [:index, :show] do
        resources :page_parts, only: [:index, :show]
      end

      resources :resources, only: [:index, :show]

      namespace :blog do
        resources :posts, only: [:index, :show]
      end

      namespace :inquiries, only: [:index, :show] do
        resources :inquiries, only: [:index, :show]
      end
    end

    # match 'v:api/*path', to: redirect("/api/v1/%{path}"), via: [:get]
    # match '*path', to: redirect("/api/v1/%{path}"), via: [:get]
  end
end
