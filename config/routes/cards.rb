Mintoffice::Application.routes.draw do
  resources :creditcards do
    collection do
      get 'total'
      get 'excel'
      post 'preview'
      post 'excel', :action => 'upload'
    end
  end

  resources :card_histories do
    collection do
      get 'raw'
      post 'generate', as: :generate

      post 'export'
      get 'cardbills/generate', action: :generate_form, as: :generate_form
      post 'cardbills/generate', action: :generate, as: :generate
      get 'cardbills/empty', action: :find_empty_cardbill, as: :find_empty_cardbill
    end
  end

  resources :shinhan_card_used_histories do
    collection do
      get 'excel'
      post 'preview'
      post 'upload'
    end
  end

  resources :hyundai_card_used_histories do
    collection do
      get 'excel'
      post 'preview'
      post 'upload'
    end
  end

  resources :shinhan_card_approved_histories do
    collection do
      get 'excel'
      post 'preview'
      post 'upload'
    end
  end

  resources :hyundai_card_approved_histories do
    collection do
      get 'excel'
      post 'preview'
      post 'upload'
    end
  end

  resources :oversea_card_approved_histories do
    collection do
      get 'excel'
      post 'preview'
      post 'upload'
    end
  end


  resources :card_used_sources do
    collection do
      post 'export'
    end
  end

  resources :card_approved_sources do
    collection do
      post 'export'
      get 'cardbills/generate', action: :generate, as: :generate_cardbills
      post 'cardbills/generate', action: :generate_cardbills, as: :generate_cardbills
      get 'cardbills/empty', controller: :card_approved_sources, action: :find_empty_cardbills, as: :find_empty_cardbills
    end
  end

  resources :cardbills
end