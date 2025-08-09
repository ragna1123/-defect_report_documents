
# 不具合管理システム ER設計（最新版）

---

## 📄 ユーザーテーブル（user_table）

| カラム名 | 型 | 説明 |
|----------|----|------|
| id | INT PK | 主キー |
| username | TEXT UNIQUE INDEX | ユーザー名 |
| password | TEXT | パスワード |
| created_at | DATE | 作成日時 |
| updated_at | DATE | 更新日時 |

---

## 🛠 不具合テーブル（defect_report_table）

| カラム名 | 型 | 説明 |
|----------|----|------|
| id | INT PK | 主キー |
| occurred_at | DATE INDEX | 発生日 |
| area_id | INT FK | エリアID |
| equipment_id | INT FK | 設備ID |
| defect_title | TEXT INDEX | 不具合タイトル |
| defect_detail | TEXT INDEX | 不具合内容 |
| is_close | BOOL DEFAULT false INDEX | クローズフラグ |
| severity | INT | 重要度 |
| impact_on_production | INT [0,1,2] DEFAULT 0 INDEX | 生産影響 |
| impact_on_environment | INT [0,1,2] DEFAULT 0 INDEX | 環境影響 |
| impact_on_quality | INT [0,1,2] DEFAULT 0 INDEX | 品質影響 |
| created_at | DATE | 作成日 |
| updated_at | DATE | 更新日 |

---

## 🏭 エリアテーブル（area_table）

| カラム名 | 型 | 説明 |
|----------|----|------|
| id | INT PK | 主キー |
| area_name | TEXT NULL_OK INDEX | エリア名（例：Y1,Y2,A棟など） |

---

## ⚙ 設備テーブル（equipment_table）

| カラム名 | 型 | 説明 |
|----------|----|------|
| id | INT PK | 主キー |
| equipment_name | TEXT INDEX | 設備名 |
| equipment_category_id | INT FK | 設備カテゴリID |

---

## 🧩 設備カテゴリテーブル（equipment_category_table）

| カラム名 | 型 | 説明 |
|----------|----|------|
| id | INT PK | 主キー |
| equipment_category_name | TEXT INDEX | 空調、排水、電気などカテゴリ名 |

---

## 🔧 処置テーブル（defect_action_table）

| カラム名 | 型 | 説明 |
|----------|----|------|
| id | INT PK | 主キー |
| defect_report_id | INT FK | 対象不具合ID |
| status | TEXT INDEX | 暫定・追加対応・恒久など |
| action_datetime | DATE | 実施日時 |
| action_title | TEXT INDEX | タイトル |
| action_detail | TEXT INDEX | 詳細内容 |
| responder | TEXT INDEX | 対応者名（将来的には中間テーブルで対応） |
| vender_id | INT FK NULL_OK INDEX | 外注業者ID |
| create_user | INT FK | 登録ユーザー |
| created_at | DATE | 作成日時 |
| updated_at | DATE | 更新日時 |

---

## 🤝 対応メーカー（vender_table）

| カラム名 | 型 | 説明 |
|----------|----|------|
| id | INT PK | 主キー |
| vender_name | TEXT INDEX | メーカー名 |

---

## 📎 ファイルテーブル（file_table）

| カラム名 | 型 | 説明 |
|----------|----|------|
| id | INT PK | 主キー |
| file_type | TEXT | 種別 |
| path | TEXT UNIQUE INDEX | ファイルパス |
| created_at | DATE | 作成日時 |

### 📎 ファイル中間テーブル（file_link_table）

| カラム名 | 型 | 説明 |
|----------|----|------|
| id | INT PK | 主キー |
| file_id | INT FK | 添付ファイルID |
| defect_report_id | INT FK NULL | 対象不具合 |
| defect_action_id | INT FK NULL | 対象処置 |

---

## 💬 コメントテーブル（comment_table）

| カラム名 | 型 | 説明 |
|----------|----|------|
| id | INT PK | 主キー |
| user_id | INT FK | 投稿ユーザーID |
| comment | TEXT | コメント内容 |
| created_at | DATE | 作成日時 |
| updated_at | DATE | 更新日時 |

### 💬 コメント中間テーブル（comment_link_table）

| カラム名 | 型 | 説明 |
|----------|----|------|
| id | INT PK | 主キー |
| comment_id | INT FK | コメントID |
| defect_report_id | INT FK NULL | 対象不具合 |
| defect_action_id | INT FK NULL | 対象処置 |
