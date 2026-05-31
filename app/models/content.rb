class Content < ApplicationRecord
  # いいね状態をトグルする
  def toggle_favorite!
    update!(is_favorite: !is_favorite)
  end
end
