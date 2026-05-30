class TurboDemoController < ApplicationController
  def index
    @contents = Content.order(:id)
  end

  # button_to からの PATCH で呼ばれる。いいね状態をトグルして turbo_stream でボタンを差し替える。
  def toggle
    @content = Content.find(params[:id])
    @content.toggle_favorite!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to turbo_path }
    end
  end
end
