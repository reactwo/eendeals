Rails.application.routes.draw do

  namespace :admin do
    get 'categories/index'
  end

  devise_for :users

  root 'pages#index'
  get 'privacy' => 'pages#privacy'
  get 'terms' => 'pages#terms'

  namespace 'api', defaults: { format: :json }  do
    namespace 'v1' do

      #   UsersController
      delete 'users' => 'users#destroy'
      post 'users' => 'users#create'
      post 'users/authorize' => 'users#authorize'
      post 'users/sponsor' => 'users#sponsor'
      get 'users' => 'users#show'
      get 'users/sponsor-ids' => 'users#sponsor_ids'
      patch 'users' => 'users#update'

      #   WalletsController
      get 'wallets' => 'wallets#index'


      #   SettingsController
      get 'settings' => 'settings#index'
      get 'settings/game' => 'settings#game'

      #   LimitsController
      get 'limits' => 'limits#index'

      #   TransactionsController
      patch 'transactions/video1' => 'transactions#video1'
      patch 'transactions/video2' => 'transactions#video2'
      get 'transactions/active' => 'transactions#active'
      get 'transactions/passive' => 'transactions#passive'
      get 'transactions/screen-lock' => 'transactions#screen_lock'

      #   QuizAttemptsController
      post 'quiz-attempts' => 'quiz_attempts#create'

      #   QuizQuestionAttemptsController
      get 'quiz-question-attempts/:id' => 'quiz_question_attempts#show'
      patch 'quiz-question-attempts/:id' => 'quiz_question_attempts#update'

      #   OffersController
      get 'offers' => 'offers#index'

      #   TasksController
      get 'tasks' => 'tasks#index'
      post 'tasks/:id/submit' => 'tasks#submit'

      #   ProductsController
      get 'products' => 'products#index'

      #   TrackingController
      get 'tracking/phono' => 'tracking#phono'
      get 'tracking/icubeswire' => 'tracking#icubeswire'
      get 'tracking/conversionx' => 'tracking#conversionx'
      get 'tracking/vcommission' => 'tracking#vcommission'
      get 'tracking/rubicko' => 'tracking#rubicko'
      post 'tracking/instamojo' => 'tracking#instamojo'
      get 'tracking/tapjoy' => 'tracking#tapjoy'
      get 'tracking/vnative' => 'tracking#vnative'
      post 'tracking/game' => 'tracking#game'
      post 'tracking/task' => 'tracking#task_firebase'
      post 'tracking/wallpaper' => 'tracking#task_wallpaper'
      get 'tracking/payu' => 'tracking#payu'
      post 'tracking/outside' => 'tracking#outside'

      #   UserLevelsController
      get 'user-levels' => 'user_levels#index'
      get 'user-levels/upline' => 'user_levels#upline'
      get 'user-levels/:id' => 'user_levels#show'
      post 'user-levels/search' => 'user_levels#search'

      #   DealsController
      get 'deals' => 'deals#index'

      #   DealUploadsController
      post 'deal-uploads/:id' => 'deal_uploads#create'

      #   QuizWinnersController
      get 'quiz-winners' => 'quiz_winners#index'

      #   RedeemsController
      scope 'redeems' do
        get '/' => 'redeems#check_time'
        post 'paypal' => 'redeems#paypal'
        post 'paytm' => 'redeems#paytm'
        post 'bank' => 'redeems#bank'
        post 'payza' => 'redeems#payza'
        post 'bkash' => 'redeems#bkash'
        post 'ed_ads' => 'redeems#ed_ads'
      end

      get 'you-tubes' => 'you_tubes#index'

      #   NotificationsController
      get 'notifications' => 'notifications#index'
    end

    namespace 'app' do
      scope 'categories' do
        get '/' => 'categories#index'
        get 'homepage' => 'categories#homepage'
        get ':id' => 'categories#show'
      end

      get 'wallpapers/:id' => 'wallpapers#show'
    end
  end

  namespace 'admin' do

    #   DashboardsController
    get '/' => 'dashboard#index'
    post '/closing' => 'dashboard#closing', as: :closing
    get 'choose-quiz-winner' => 'dashboard#quiz_winner', as: :choose_quiz_winner
    post 'choose-quiz-winner' => 'dashboard#choose_quiz_winners'

    #   UsersController
    get 'users' => 'users#index', as: :users
    post 'users' => 'users#create'
    get 'users/new' => 'users#new', as: :new_user
    get 'users/:id' => 'users#show', as: :user
    patch 'users/:id' => 'users#update'
    get 'users/:id/levels/:level' => 'users#level', as: :user_level
    post 'users/:id/approve' => 'users#approve', as: :approve_user
    get 'users/chart-data/:days' => 'users#chart_data', as: :user_chart_data

    #   QuizQuestionsController
    get 'quiz-questions' => 'quiz_questions#index', as: :quiz_questions
    post 'quiz-questions' => 'quiz_questions#create'
    get 'quiz-questions/:id/edit' => 'quiz_questions#edit', as: :edit_quiz_question
    patch 'quiz-questions/:id' => 'quiz_questions#update', as: :quiz_question

    #   QuizAttemptsController
    get 'quiz-attempts' => 'quiz_attempts#index', as: :quiz_attempts
    get 'quiz-attempts/:id' => 'quiz_attempts#show', as: :quiz_attempt
    delete 'quiz-attempts/:id' => 'quiz_attempts#destroy'

    #   OffersController
    get 'offers' => 'offers#index', as: :offers
    post 'offers' => 'offers#create'
    get 'offers/new' => 'offers#new', as: :new_offer
    get 'offers/:id' => 'offers#show', as: :offer
    patch 'offers/:id' => 'offers#update'
    get 'offers/:id/edit' => 'offers#edit', as: :edit_offer
    delete 'offers/:id' => 'offers#destroy'

    #   DealsController
    get 'deals' => 'deals#index', as: :deals
    post 'deals' => 'deals#create'
    get 'deals/new' => 'deals#new', as: :new_deal
    get 'deals/:id' => 'deals#show', as: :deal
    patch 'deals/:id' => 'deals#update'
    get 'deals/:id/edit' => 'deals#edit', as: :edit_deal
    delete 'deals/:id' => 'deals#destroy'

    #   ProductsController
    get 'products' => 'products#index', as: :products
    post 'products' => 'products#create'
    get 'products/new' => 'products#new', as: :new_product
    get 'products/:id' => 'products#show', as: :product
    patch 'products/:id' => 'products#update'
    get 'products/:id/edit' => 'products#edit', as: :edit_product
    delete 'products/:id' => 'products#destroy'

    #   TasksController
    get 'tasks' => 'tasks#index', as: :tasks
    get 'tasks/upload-csv' => 'tasks#new_csv', as: :upload_csv_task
    post 'tasks/upload-csv' => 'tasks#create_csv'
    post 'tasks' => 'tasks#create'
    get 'tasks/new' => 'tasks#new', as: :new_task
    get 'tasks/:id/edit' => 'tasks#edit', as: :edit_task
    get 'tasks/:id' => 'tasks#show', as: :task
    patch 'tasks/:id' => 'tasks#update'
    delete 'tasks/:id' => 'tasks#destroy'

    #   SettingsController
    get 'settings' => 'settings#index', as: :settings
    patch 'settings' => 'settings#update'

    #   TaskSubmitsController
    get 'task-submits' => 'task_submits#index', as: :task_submits
    get 'task-submits/:id' => 'task_submits#show', as: :task_submit
    post 'task-submits/:id' => 'task_submits#approve', as: :approve_task_submit
    patch 'task-submits/:id' => 'task_submits#unapprove', as: :unapprove_task_submit
    delete 'task-submits/:id' => 'task_submits#destroy'

    #   DealUploadsController
    get 'deal-uploads' => 'deal_uploads#index', as: :deal_uploads
    get 'deal-uploads/:id' => 'deal_uploads#show', as: :deal_upload
    post 'deal-uploads/:id/approve' => 'deal_uploads#approve', as: :approve_deal_upload
    post 'deal-uploads/:id/decline' => 'deal_uploads#decline', as: :decline_deal_upload
    delete 'deal-uploads/:id' => 'deal_uploads#destroy'

    #   ConversionsController
    get 'conversions' => 'conversions#index', as: :conversions
    post 'conversions/:id/approve' => 'conversions#approve', as: :approve_conversion

    #   TransactionsController
    scope 'transactions' do
      get 'credit/:id' => 'transactions#credit', as: :credit_transaction
      post 'credit/:id' => 'transactions#credit_save'
      get 'debit/:id' => 'transactions#debit', as: :debit_transaction
      post 'debit/:id' => 'transactions#debit_save'
      get '/' => 'transactions#all', as: :all_transactions
      get '/:id/:type' => 'transactions#index', as: :transactions
    end

    #   RedeemsController
    scope 'redeems' do
      get '/' => 'redeems#index', as: :redeems
      get 'export' => 'redeems#export', as: :export_redeems
      post 'export' => 'redeems#download_export'
      get '/user/:id' => 'redeems#user', as: :user_redeems
      get '/:id/decline' => 'redeems#decline_form', as: :decline_reason_redeem
      post '/:id' => 'redeems#approve', as: :approve_redeem
      delete '/:id' => 'redeems#decline', as: :decline_redeem
      get '/:id' => 'redeems#show', as: :redeem
    end

    # QuizWinnersController
    scope 'quiz-winners' do
      get '/' => 'quiz_winners#index', as: :quiz_winners
      get '/:id' => 'quiz_winners#show', as: :quiz_winner
    end

    #   RewardTasksController
    scope 'reward-tasks' do
      get '/' => 'reward_tasks#index', as: :reward_tasks
      get '/:id' => 'reward_tasks#show', as: :reward_task
    end

    scope 'categories' do
      get '/' => 'categories#index', as: :categories
      post '/' => 'categories#create'
      get 'new' => 'categories#new', as: :new_category
      get ':id/edit' => 'categories#edit', as: :edit_category
      patch ':id' => 'categories#update', as: :category
      delete ':id' => 'categories#destroy'
    end

    scope 'wallpapers' do
      get '/' => 'wallpapers#index', as: :wallpapers
      get 'new' => 'wallpapers#new', as: :new_wallpaper
      post '/' => 'wallpapers#create'
      get ':id/edit' => 'wallpapers#edit', as: :edit_wallpaper
      patch ':id' => 'wallpapers#update', as: :wallpaper
      delete ':id' => 'wallpapers#destroy'
    end

    resources :you_tubes

    scope 'notifications' do
      get '/' => 'notifications#index', as: :notifications
      post '/' => 'notifications#create'
      delete '/:id' => 'notifications#destroy'
      get '/new' => 'notifications#new', as: :new_notification
    end

    scope 'custom-files' do
      get '/' => 'custom_files#index', as: :custom_files
      post '/' => 'custom_files#create'
      get '/new' => 'custom_files#new', as: :new_custom_file
      delete '/:id' => 'custom_files#destroy', as: :custom_file
    end

    scope 'wallets' do
      get 'wallets/upload-csv' => 'wallets#new_csv', as: :upload_csv_wallet
      post 'wallets/upload-csv' => 'wallets#create_csv'
      get 'wallets/daily-csv' => 'wallets#daily_csv', as: :upload_daily_csv_wallet
      post 'wallets/daily-csv' => 'wallets#create_daily_csv'
      get 'wallets/khabri-csv' => 'wallets#khabri_csv', as: :upload_khabri_wallet
      post 'wallets/khabri-csv' => 'wallets#create_khabri_csv'
    end

    scope 'hollow-users' do
      get '/' => 'hollow_users#index', as: :hollow_users
    end
  end

end
