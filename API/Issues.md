# Issues

## 不具合関連の API

---

### 不具合一覧取得

- **GET** /issues
  - 不具合の一覧を取得します。キーワードやエリア、発生日などでフィルタ可能です。
- ステータスコード: `200 OK`
- レスポンスボディ:

```json
{
  "status":"success",
  "data": [
    {
        "id":
    },
    {...}// 他の不具合内容...
  ]
}
```

---

### 不具合登録

- **POST** /issues
  - 新しい不具合を登録します。
- ステータスコード: `201 Created`
- リクエストボディ :

```json
{
  "status":"success",
  "data": [
    {
        "id":
    }
  ]
}
```

- レスポンスボディ:

```json
{
  "status":"success",
  "data": [
    {
        "id":
    }
  ]
}
```

---

### 不具合詳細取得

- **GET** /issues/{issue_id}
  - 特定の不具合の詳細情報を取得します。
- ステータスコード: `200 OK`
- レスポンスボディ:

```json
{
  "status":"success",
  "data": [
    {
        "id":
    }
  ]
}
```

---

### 不具合更新

- **PATCH** /issues/{issue_id}
  - 特定の不具合情報を更新します。
- ステータスコード: `200 OK`
- レスポンスボディ:

```json
{
  "status": "success",
  "message": "不具合内容が更新されました"
}
```

---

### 不具合削除

- **DELETE** /issues/{issue_id}
  - 特定の不具合を削除します（論理削除推奨）。
- ステータスコード: `200 OK`
- レスポンスボディ:

```json
{
  "status": "success",
  "message": "不具合投稿が削除されました"
}
```
