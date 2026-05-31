# favorite_sys — いいね機能デモ

同じ「いいね（ハート）」機能を **2 つの実装パターン** で実装した最小デモです。

| パターン | URL | 仕組み |
| --- | --- | --- |
| A. Stimulus アクションパラメータ | `/stimulus` | ボタンの `data-favorite-*-param` を `event.params` として受け取り、`fetch` で PATCH → サーバが返すボタンのパーシャル(HTML)で差し替え |
| B. Turbo | `/turbo` | `button_to` で PATCH 送信 → サーバが `turbo_stream` でボタン部分を差し替え（カスタム JS ゼロ） |

どちらのパターンも同じ `contents` テーブルを共有し、いいね状態は `is_favorite` カラムに保存されます。

## 技術構成

- Ruby on Rails 8.1（importmap + Hotwire）
- PostgreSQL 16
- Tailwind CSS v4（`tailwindcss-rails`）
- Docker / Docker Compose

## 起動方法

```bash
cd favorite_sys
docker compose up --build
```

- アプリ: http://localhost:3987
- PostgreSQL: ホスト側 `localhost:55433`（コンテナ内は 5432）

初回起動時に DB 作成・マイグレーション・サンプルデータ3件の投入・Tailwind ビルドが自動実行されます。

停止:

```bash
docker compose down          # コンテナ停止
docker compose down -v       # DB データも削除
```

## 主要ファイル

```
app/
  controllers/
    stimulus_demo_controller.rb   # パターンA: @content を渡してボタンのパーシャルを返す toggle
    turbo_demo_controller.rb      # パターンB: turbo_stream を返す toggle
  javascript/controllers/
    favorite_controller.js        # パターンA: Stimulus コントローラ（event.params 使用）
  views/
    stimulus_demo/index.html.erb  # パターンA 画面
    turbo_demo/
      index.html.erb              # パターンB 画面
      _favorite_button.html.erb   # 差し替え対象のボタン部分
      toggle.turbo_stream.erb     # turbo_stream レスポンス
  models/content.rb               # toggle_favorite!
db/
  migrate/*_create_contents.rb    # contents(title, body, is_favorite)
  seeds.rb                        # サンプル3件
config/routes.rb
```

## ポイント

### パターンA（Stimulus アクションパラメータ）

ビュー側でボタンに識別子と送信先 URL を埋め込みます。

```erb
<button data-controller="favorite"
        data-action="favorite#toggle"
        data-favorite-id-param="<%= content.id %>"
        data-favorite-url-param="<%= stimulus_toggle_path(content) %>">
```

コントローラ側は `event.params` で受け取り、サーバが返すパーシャル(HTML)でボタンを差し替えます。

```js
toggle(event) {
  const { id, url } = event.params   // ← アクションパラメータ
  fetch(url, { method: "PATCH", headers: { Accept: "text/html", ... } })
    .then((res) => res.text())
    .then((html) => { this.element.outerHTML = html })
}
```

アクション側は `@content`（ivar）を渡してパーシャルを描画します。

```ruby
def toggle
  @content = Content.find(params[:id])
  @content.toggle_favorite!
  render partial: "favorite_button"   # パーシャルは @content を参照
end
```

### パターンB（Turbo）

`button_to` の送信に対し、サーバが該当ボタンの DOM だけを差し替えます。

```erb
<%= turbo_stream.replace dom_id(@content, :favorite) do %>
  <%= render "favorite_button", content: @content %>
<% end %>
```
