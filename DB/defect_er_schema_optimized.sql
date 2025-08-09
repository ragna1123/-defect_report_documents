
-- ==============================================
-- 不具合管理システム 最適化スキーマ（SQLite）
-- 方針:
--  - 外部キーに単独INDEXを付与
--  - 代表的な検索パターンに複合INDEXを追加
--  - 長文検索はFTS5（任意）を用意
--  - BOOLEANはSQLiteではINTEGER(0/1)で表現
-- ==============================================

PRAGMA foreign_keys = ON;

-- ========== マスタ系 ==========
CREATE TABLE user_table (
    id          INTEGER PRIMARY KEY,
    username    TEXT    NOT NULL UNIQUE,
    password    TEXT    NOT NULL,
    created_at  DATE    NOT NULL,
    updated_at  DATE    NOT NULL
);

CREATE TABLE area_table (
    id          INTEGER PRIMARY KEY,
    area_name   TEXT
);
CREATE INDEX idx_area_name ON area_table(area_name);

CREATE TABLE equipment_category_table (
    id                          INTEGER PRIMARY KEY,
    equipment_category_name     TEXT NOT NULL
);
CREATE INDEX idx_equipment_category_name ON equipment_category_table(equipment_category_name);

CREATE TABLE equipment_table (
    id                      INTEGER PRIMARY KEY,
    equipment_name          TEXT    NOT NULL,
    equipment_category_id   INTEGER NOT NULL,
    created_at              DATE    NOT NULL,
    updated_at              DATE    NOT NULL,
    FOREIGN KEY(equipment_category_id) REFERENCES equipment_category_table(id)
);
CREATE INDEX idx_equipment_name ON equipment_table(equipment_name);
CREATE INDEX idx_equipment_category_id ON equipment_table(equipment_category_id);

CREATE TABLE vender_table (
    id           INTEGER PRIMARY KEY,
    vender_name  TEXT NOT NULL,
    created_at   DATE NOT NULL DEFAULT (DATE('now')),
    updated_at   DATE NOT NULL DEFAULT (DATE('now'))
);
CREATE INDEX idx_vender_name ON vender_table(vender_name);

-- ========== コア（不具合・処置） ==========
CREATE TABLE defect_report_table (
    id                       INTEGER PRIMARY KEY,
    occurred_at              DATE    NOT NULL,   -- 発生日
    area_id                  INTEGER NOT NULL,
    equipment_id             INTEGER NOT NULL,
    defect_title             TEXT    NOT NULL,
    defect_detail            TEXT,
    is_close                 INTEGER NOT NULL DEFAULT 0, -- 0/1
    severity                 INTEGER,                    -- 0:軽微,1:中,2:重大（運用次第）
    impact_on_production     INTEGER NOT NULL DEFAULT 0, -- 0/1/2
    impact_on_environment    INTEGER NOT NULL DEFAULT 0, -- 0/1/2
    impact_on_quality        INTEGER NOT NULL DEFAULT 0, -- 0/1/2
    created_at               DATE    NOT NULL,
    updated_at               DATE    NOT NULL,
    FOREIGN KEY(area_id)     REFERENCES area_table(id),
    FOREIGN KEY(equipment_id)REFERENCES equipment_table(id)
);
-- 単独INDEX
CREATE INDEX idx_defect_area_id           ON defect_report_table(area_id);
CREATE INDEX idx_defect_equipment_id      ON defect_report_table(equipment_id);
CREATE INDEX idx_defect_occurred_at       ON defect_report_table(occurred_at);
CREATE INDEX idx_defect_is_close          ON defect_report_table(is_close);
CREATE INDEX idx_defect_severity          ON defect_report_table(severity);
CREATE INDEX idx_defect_impact_prod       ON defect_report_table(impact_on_production);
CREATE INDEX idx_defect_impact_env        ON defect_report_table(impact_on_environment);
CREATE INDEX idx_defect_impact_quality    ON defect_report_table(impact_on_quality);
-- 代表的な検索パターン向け複合INDEX
CREATE INDEX idx_defect_area_date         ON defect_report_table(area_id, occurred_at);
CREATE INDEX idx_defect_equipment_date    ON defect_report_table(equipment_id, occurred_at);
CREATE INDEX idx_defect_close_date        ON defect_report_table(is_close, occurred_at);

CREATE TABLE defect_action_table (
    id                INTEGER PRIMARY KEY,
    defect_report_id  INTEGER NOT NULL,
    status            TEXT    NOT NULL,         -- 'temporary','additional','permanent' 等を想定
    action_datetime   DATE,
    action_title      TEXT,
    action_detail     TEXT,
    responder         TEXT,                     -- まずは文字列。将来中間テーブル化可
    vender_id         INTEGER,                  -- NULL=内製
    create_user       INTEGER NOT NULL,         -- 登録ユーザー
    created_at        DATE    NOT NULL,
    updated_at        DATE    NOT NULL,
    FOREIGN KEY(defect_report_id) REFERENCES defect_report_table(id),
    FOREIGN KEY(vender_id)        REFERENCES vender_table(id),
    FOREIGN KEY(create_user)      REFERENCES user_table(id)
);
-- 単独INDEX
CREATE INDEX idx_action_defect_report_id  ON defect_action_table(defect_report_id);
CREATE INDEX idx_action_status            ON defect_action_table(status);
CREATE INDEX idx_action_create_user       ON defect_action_table(create_user);
CREATE INDEX idx_action_vender_id         ON defect_action_table(vender_id);
CREATE INDEX idx_action_datetime          ON defect_action_table(action_datetime);
-- 代表的な検索パターン向け複合INDEX
CREATE INDEX idx_action_report_status     ON defect_action_table(defect_report_id, status);
CREATE INDEX idx_action_report_datetime   ON defect_action_table(defect_report_id, action_datetime);

-- ========== ファイル/コメント と中間 ==========
CREATE TABLE file_table (
    id          INTEGER PRIMARY KEY,
    file_type   TEXT,
    path        TEXT NOT NULL UNIQUE,
    created_at  DATE NOT NULL
);
CREATE INDEX idx_file_created_at ON file_table(created_at);

CREATE TABLE file_link_table (
    id                 INTEGER PRIMARY KEY,
    file_id            INTEGER NOT NULL,
    defect_report_id   INTEGER,  -- どちらか一方がNOT NULL（アプリ側で担保）
    defect_action_id   INTEGER,
    created_at         DATE NOT NULL DEFAULT (DATE('now')),
    FOREIGN KEY(file_id)          REFERENCES file_table(id),
    FOREIGN KEY(defect_report_id) REFERENCES defect_report_table(id),
    FOREIGN KEY(defect_action_id) REFERENCES defect_action_table(id)
);
-- 単独INDEX
CREATE INDEX idx_file_link_file_id         ON file_link_table(file_id);
CREATE INDEX idx_file_link_defect_report   ON file_link_table(defect_report_id);
CREATE INDEX idx_file_link_defect_action   ON file_link_table(defect_action_id);
-- 複合INDEX（逆参照・重複防止/検索最適化）
CREATE INDEX idx_file_link_report_file     ON file_link_table(defect_report_id, file_id);
CREATE INDEX idx_file_link_action_file     ON file_link_table(defect_action_id, file_id);

CREATE TABLE comment_table (
    id          INTEGER PRIMARY KEY,
    user_id     INTEGER NOT NULL,
    comment     TEXT    NOT NULL,
    created_at  DATE    NOT NULL,
    updated_at  DATE    NOT NULL,
    FOREIGN KEY(user_id) REFERENCES user_table(id)
);
CREATE INDEX idx_comment_user_id    ON comment_table(user_id);
CREATE INDEX idx_comment_created_at ON comment_table(created_at);

CREATE TABLE comment_link_table (
    id                 INTEGER PRIMARY KEY,
    comment_id         INTEGER NOT NULL,
    defect_report_id   INTEGER,  -- どちらか一方がNOT NULL（アプリ側で担保）
    defect_action_id   INTEGER,
    created_at         DATE NOT NULL DEFAULT (DATE('now')),
    FOREIGN KEY(comment_id)       REFERENCES comment_table(id),
    FOREIGN KEY(defect_report_id) REFERENCES defect_report_table(id),
    FOREIGN KEY(defect_action_id) REFERENCES defect_action_table(id)
);
-- 単独INDEX
CREATE INDEX idx_comment_link_comment_id   ON comment_link_table(comment_id);
CREATE INDEX idx_comment_link_defect_report ON comment_link_table(defect_report_id);
CREATE INDEX idx_comment_link_defect_action ON comment_link_table(defect_action_id);
-- 複合INDEX
CREATE INDEX idx_comment_link_report_comment ON comment_link_table(defect_report_id, comment_id);
CREATE INDEX idx_comment_link_action_comment ON comment_link_table(defect_action_id, comment_id);

-- ========== （任意）全文検索用 FTS5 ==========
-- アプリ側で同期挿入する想定。検索高速化に活用可。
-- 有効化する場合は SQLite ビルドが FTS5 対応であることを確認してください。
CREATE VIRTUAL TABLE IF NOT EXISTS defect_report_fts
USING fts5(defect_id UNINDEXED, defect_title, defect_detail);

CREATE VIRTUAL TABLE IF NOT EXISTS defect_action_fts
USING fts5(action_id UNINDEXED, action_title, action_detail);

-- 参考: 挿入例（アプリ側で実行）
-- INSERT INTO defect_report_fts(defect_id, defect_title, defect_detail)
--   SELECT id, defect_title, defect_detail FROM defect_report_table;
-- INSERT INTO defect_action_fts(action_id, action_title, action_detail)
--   SELECT id, action_title, action_detail FROM defect_action_table;
