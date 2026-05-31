Rails.application.routes.draw do

  # トップページ: 2つのデモへのリンク
  root "home#index"

  # パターンA: Stimulus アクションパラメータ
  get "stimulus", to: "stimulus_demo#index"
  patch "stimulus/contents/:id/toggle", to: "stimulus_demo#toggle", as: :stimulus_toggle

  # パターンB: Turbo (turbo_stream)
  get "turbo", to: "turbo_demo#index"
  patch "turbo/contents/:id/toggle", to: "turbo_demo#toggle", as: :turbo_toggle
end
