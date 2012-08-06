Dummy::Application.routes.draw do
  focused_controller_routes do
    resources :foo
    resources :bar
    resources :jump
    resources :step_positions
  end
end