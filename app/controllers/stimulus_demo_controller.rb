class StimulusDemoController < ApplicationController
  def index
    @contents = Content.order(:id)
  end

  # Stimulus から fetch(PATCH) で呼ばれる。識別子(:id)を受け取り、いいね状態をトグルして
  # ボタン部分のパーシャル(HTML)を返す。@content を ivar として渡す。
  def toggle
    @content = Content.find(params[:id])
    @content.toggle_favorite!
    render partial: "favorite_button"
  end
end
