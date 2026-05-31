import { Controller } from "@hotwired/stimulus"

// パターンA: Stimulus アクションパラメータを使った「いいね」トグル
//
// ボタンに付与した data-favorite-id-param / data-favorite-url-param が
// event.params.id / event.params.url として渡ってくる。
// サーバはアクションパーシャル(HTML)を返すので、ボタンをまるごと差し替える。
export default class extends Controller {
  toggle(event) {
    const { id, url } = event.params
    console.log(`コンテンツ#${id} のいいねを切り替えます`)

    fetch(url, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": this.csrfToken,
        "Accept": "text/html"
      }
    })
      .then((response) => {
        if (!response.ok) throw new Error(`HTTP ${response.status}`)
        return response.text()
      })
      .then((html) => { this.element.outerHTML = html })
      .catch((error) => console.error("いいねの更新に失敗しました", error))
  }

  get csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content
  }
}
