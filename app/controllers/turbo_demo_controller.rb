class TurboDemoController < ApplicationController
  def index
    @contents = Content.order(:id)
  end

  # いいね状態をトグルして turbo_stream でボタンを差し替える
  # button_to からの PATCH で呼ばれる
  # 明示 render なし → 暗黙で toggle.turbo_stream.erb を描画する
  def toggle
    @content = Content.find(params[:id])
    @content.toggle_favorite!
  end
end
