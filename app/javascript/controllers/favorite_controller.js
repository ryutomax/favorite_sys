import { Controller } from "@hotwired/stimulus"

// パターンA: Stimulus アクションパラメータを使った「いいね」トグル
//
// ボタンに付与した data-favorite-id-param / data-favorite-url-param が
// event.params.id / event.params.url として渡ってくる。
export default class extends Controller {
  static targets = ["filled", "outline", "label"]

  toggle(event) {
    const { id, url } = event.params
    console.log(`コンテンツ#${id} のいいねを切り替えます`)

    fetch(url, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": this.csrfToken,
        "Accept": "application/json"
      }
    })
      .then((response) => {
        if (!response.ok) throw new Error(`HTTP ${response.status}`)
        return response.json()
      })
      .then((data) => this.render(data.is_favorite))
      .catch((error) => console.error("いいねの更新に失敗しました", error))
  }

  // サーバから返ってきた状態に合わせて見た目を更新する
  render(favorited) {
    this.filledTarget.classList.toggle("hidden", !favorited)
    this.outlineTarget.classList.toggle("hidden", favorited)
    this.labelTarget.textContent = favorited ? "いいね済み" : "いいね"

    this.element.classList.toggle("border-rose-300", favorited)
    this.element.classList.toggle("bg-rose-50", favorited)
    this.element.classList.toggle("border-gray-300", !favorited)
    this.element.classList.toggle("bg-white", !favorited)
  }

  get csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content
  }
}
