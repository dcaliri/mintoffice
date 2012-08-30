Mintoffice::Application.routes.draw do
  scope nil, :module => 'section_enrollment' do
    resources :enrollments do
      collection do
        get :dashboard
      end

      member do
        get :attach_item
        post :attach
        delete :delete_attachment
      end
    end

    resources :enroll_reports

    match ':company_name/recruit' => 'enrollments#index'
  end
end