# 不具合管理 API 一覧

URL = `http://localhost:8000/api/v1`

## リソース

- **User**（社内用・簡易）
- **Issue**（不具合）
- **Action**（処置：暫定/恒久、提案 → 実行 → 完了）
- **Comment**（コメント）
- **Attachment**（添付）
- **Equipment / Area / Category**（設備・場所・カテゴリ）

---

## ユーザー関連の API

### ユーザー一覧取得

- **GET** /users
  - ユーザーの一覧を取得します（検索や絞り込み可）。
  - 例: `/users?q=山田` で氏名検索。

### ユーザー登録

- **POST** /users
  - 新しいユーザーを登録します（氏名・部署など）。

### ユーザー詳細取得

- **GET** /users/{user_id}
  - 特定のユーザー情報を取得します。

### ユーザー更新

- **PATCH** /users/{user_id}
  - 特定のユーザー情報を更新します（氏名変更・部署異動など）。

### ユーザー削除

- **DELETE** /users/{user_id}
  - ユーザーを削除します（退職者など）。

---

## 不具合関連の API

### 不具合一覧取得

- **GET** /issues
  - 不具合の一覧を取得します。キーワードやエリア、発生日などでフィルタ可能です。

### 不具合登録

- **POST** /issues
  - 新しい不具合を登録します。

### 不具合詳細取得

- **GET** /issues/{issue_id}
  - 特定の不具合の詳細情報を取得します。

### 不具合更新

- **PATCH** /issues/{issue_id}
  - 特定の不具合情報を更新します。

### 不具合削除

- **DELETE** /issues/{issue_id}
  - 特定の不具合を削除します（論理削除推奨）。

---

## 処置関連の API

### 不具合に紐づく処置一覧取得

- **GET** /issues/{issue_id}/actions
  - 特定の不具合に紐づく処置の一覧を取得します。

### 処置追加

- **POST** /issues/{issue_id}/actions
  - 特定の不具合に処置を追加します。

### 処置詳細取得

- **GET** /actions/{action_id}
  - 特定の処置の詳細情報を取得します。

### 処置更新

- **PATCH** /actions/{action_id}
  - 特定の処置情報を更新します。

### 処置削除

- **DELETE** /actions/{action_id}
  - 特定の処置を削除します。

---

## コメント関連の API

### 不具合に紐づくコメント一覧取得

- **GET** /issues/{issue_id}/comments
  - 特定の不具合に紐づくコメント一覧を取得します。

### コメント追加

- **POST** /issues/{issue_id}/comments
  - 特定の不具合にコメントを追加します。

### コメント更新

- **PATCH** /comments/{comment_id}
  - 特定のコメントを更新します。

### コメント削除

- **DELETE** /comments/{comment_id}
  - 特定のコメントを削除します。

---

## 添付ファイル関連の API

### 添付ファイル追加

- **POST** /issues/{issue_id}/attachments
  - 特定の不具合に添付ファイルを追加します（`multipart/form-data`）。

### 添付ファイル取得

- **GET** /attachments/{attachment_id}
  - 特定の添付ファイルを取得します。

### 添付ファイル削除

- **DELETE** /attachments/{attachment_id}
  - 特定の添付ファイルを削除します。

---

## マスタ関連の API

### 設備一覧取得

- **GET** /equipments
  - 設備の一覧を取得します（エリア ID やキーワードでフィルタ可能）。

### エリア一覧取得

- **GET** /areas
  - エリアの一覧を取得します。

### カテゴリ一覧取得

- **GET** /categories
  - カテゴリの一覧を取得します。

---

## 検索関連の API

### 高度検索

- **POST** /issues/search
  - 複雑な条件で不具合を検索します。

---

## エクスポート関連の API

### 不具合一覧の Excel 出力

- **GET** /issues/export.xlsx
  - 検索結果を Excel 形式で出力します。

### 不具合詳細レポート出力

- **GET** /issues/{issue_id}/report.xlsx
  - 特定の不具合詳細をレポート形式（Excel）で出力します。
