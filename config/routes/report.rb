Mintoffice::Application.routes.draw do
  match 'report' => 'reports#report', as: :report
end