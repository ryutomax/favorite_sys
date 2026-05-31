class TurboDemoController < ApplicationController
  def index
    @contents = Content.order(:id)
  end

  # いいね状態をトグルして turbo_stream でボタンを差し替える
  # button_to からの PATCH で呼ばれる
  def toggle
    @content = Content.find(params[:id])
    @content.toggle_favorite!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to turbo_path }
    end
  end
end
