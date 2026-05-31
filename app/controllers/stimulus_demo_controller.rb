class StimulusDemoController < ApplicationController
  def index
    @contents = Content.order(:id)
  end

  # Stimulus から fetch(PATCH) で呼ばれる。識別子(:id)を受け取り、いいね状態をトグルして JSON を返す。
  def toggle
    content = Content.find(params[:id])
    content.toggle_favorite!
    render json: { id: content.id, is_favorite: content.is_favorite }
  end
end
