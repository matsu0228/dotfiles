---
name: pm-workload-summary
description: freee工数管理（PM）から指定月・指定メンバーの工数サマリをプロジェクト別比率とともに取得・表示する。Use when user wants freee PM workload summary, 工数サマリ, 工数実績, project time breakdown for team members. Requires freee-mcp MCP server.
---

# freee PM 工数サマリ

## Quick start

引数ありならそのまま実行。引数なしはデフォルト引数を使用。

```
/pm-workload-summary 2026-06
junpay 7233
kashita 21888
yamamoto 22333
sato 25108
```

### デフォルト引数

- **対象月**: 本日の月（YYYY-MM 形式）
- **メンバーリスト**:

```
junpay 7233
kashita 21888
yamamoto 22333
sato 25108
```

## ワークフロー

### 1. 入力確認

不足している場合のみユーザーに確認：

- **対象月**: YYYY-MM 形式
- **メンバーリスト**: `ニックネーム person_id` の形式で1行ずつ

### 2. company_id 取得

```
freee-mcp:freee_get_current_company
```

### 3. 各メンバーのデータ取得（全員並列）

```
freee-mcp:freee_api_get {
  "service": "pm",
  "path": "/workloads",
  "query": {
    "company_id": <company_id>,
    "year_month": "<YYYY-MM>",
    "employees_scope": "employee",
    "person_ids[]": [<person_id>],
    "limit": 100
  }
}
```

### 4. 集計・表示

メンバーごとにプロジェクト別 minutes を合計し、比率降順で出力：

```
### mattsun（2026年6月）
合計: 8,459分（141時間）

| プロジェクト | コード | 時間 | 比率 |
|---|---|---|---|
| ◎小規模開発 | X-00008 | 102時間13分 | 72.5% |
| ◎保守運用 | X-00001 | 30時間46分 | 21.8% |
```

- 0件の場合は「未登録」と表示
- 時間表示: `X時間Y分`

## 注意事項

- **person_id**: `/people` は権限エラーになる場合がある。person_id は事前にユーザーから受け取る
- **認証エラー時**: `freee-mcp:freee_authenticate` で再認証 → 再実行
- **`employees_scope`**: `employee` + `person_ids[]` をセットで指定（省略するとログインユーザーのみ）
