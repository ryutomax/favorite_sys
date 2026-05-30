class Content < ApplicationRecord
  # いいね状態をトグルする
  def toggle_favorite!
    update!(is_favarite: !is_favarite)
  end
end
