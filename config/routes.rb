Rails.application.routes.draw do
  resources :images

  get 'validation_jobs/getjob/:id', to: 'validation_jobs#getjob'

  resources :validation_jobs, except: [:edit]

  get 'deploys/getinput/:id', to: 'deploys#getinput'

  resources :deploys, except: [:edit]

  resources :groups

  resources :accounts

  resources :permissions

  resources :roles

  resources :users

  get 'home/login'

  post 'home/login'

  get 'home/logout'

  get 'home/dashboard'

  get 'home/messages'

  get 'home/alerts'

  get 'home/tasks'

  delete 'home/account/deleteuser/:id', to: 'home#deleteuser' 

  post 'home/account/adduser', to: 'home#adduser'

  get 'home/account/:id', to: 'home#changeaccount'
  
  get 'home/account'
  
  get 'home/user'

  resources :environments, except: [:edit]

  get 'tasks/taskform'

  resources :tasks, except: [:edit]

  post 'workflows/addtask', to: 'workflows#addtask'
  
  delete 'workflows/deltask', to: 'workflows#deltask'

  post 'workflows/step/completed', to: 'workflows#addoncompleted'

  delete 'workflows/step/completed', to: 'workflows#removeoncompleted'

  post 'workflows/step/success', to: 'workflows#addonsuccess'

  delete 'workflows/step/success', to: 'workflows#removeonsuccess'

  post 'workflows/step/failure', to: 'workflows#addonfailure'

  delete 'workflows/step/failure', to: 'workflows#removeonfailure'

  put 'workflows/:id/reload', to: 'workflows#reload'

  get 'workflows/:id/diagram', to: 'workflows#diagram'

  resources :workflows, except: [:edit]

  resources :scripts, except: [:edit]

  resources :checks, except: [:edit]

  resources :dashboards, except: [:edit]

  resources :replicas, except: [:edit]

get 'projects/tablelist', to: 'projects#tablelist'

  resources :projects, except: [:edit]

  resources :repositories, except: [:edit]

get 'ciworkers/tablelist', to: 'ciworkers#tablelist'

  resources :ciworkers, except: [:edit]

get 'cistacks/tablelist', to: 'cistacks#tablelist'

get 'cistacks/:id/manage', to: 'cistacks#manage'

post 'cistacks/:id/manage', to: 'cistacks#manage'

  resources :cistacks, except: [:edit]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #root "home#intro" 

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
