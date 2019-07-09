# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180625092805) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "banner_id"
    t.string "interstitial_id"
    t.string "rewarded_id"
    t.bigint "task_id"
    t.index ["task_id"], name: "index_categories_on_task_id"
  end

  create_table "conversions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "transaction_id"
    t.string "company"
    t.string "company_id"
    t.bigint "offer_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "deal_id"
    t.integer "status"
    t.bigint "product_id"
    t.datetime "deleted_at"
    t.bigint "old_user_id"
    t.index ["deal_id"], name: "index_conversions_on_deal_id"
    t.index ["offer_id"], name: "index_conversions_on_offer_id"
    t.index ["old_user_id"], name: "index_conversions_on_old_user_id"
    t.index ["product_id"], name: "index_conversions_on_product_id"
    t.index ["transaction_id"], name: "index_conversions_on_transaction_id", unique: true
    t.index ["user_id"], name: "index_conversions_on_user_id"
  end

  create_table "custom_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "deal_uploads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "image"
    t.bigint "deal_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status", default: false
    t.datetime "deleted_at"
    t.bigint "old_user_id"
    t.index ["deal_id"], name: "index_deal_uploads_on_deal_id"
    t.index ["old_user_id"], name: "index_deal_uploads_on_old_user_id"
    t.index ["user_id"], name: "index_deal_uploads_on_user_id"
  end

  create_table "deals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "company_id"
    t.integer "downloaded", default: 0
    t.string "link"
    t.string "logo"
    t.string "name"
    t.text "instructions"
    t.boolean "active", default: false
    t.decimal "amount", precision: 10, scale: 4, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cap", default: 0
    t.boolean "reward_later", default: false
  end

  create_table "delayed_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "limits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "video1"
    t.integer "video2"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "old_user_id"
    t.index ["old_user_id"], name: "index_limits_on_old_user_id"
    t.index ["user_id"], name: "index_limits_on_user_id"
  end

  create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "company_id"
    t.integer "downloaded", default: 0
    t.string "link"
    t.string "logo"
    t.string "name"
    t.text "instructions"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount", precision: 10, scale: 4
    t.integer "cap", default: 0
    t.boolean "reward_later", default: false
  end

  create_table "old_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email"
    t.string "mobile"
    t.string "name"
    t.string "refer_id"
    t.string "sponsor_id"
    t.string "real_sponsor_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "image"
    t.decimal "price", precision: 10
    t.text "description"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: false
    t.string "slug"
    t.decimal "amount", precision: 10, scale: 4
  end

  create_table "quiz_attempts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "quiz_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1
    t.decimal "points", precision: 10, scale: 4
    t.datetime "deleted_at"
    t.bigint "old_user_id"
    t.index ["old_user_id"], name: "index_quiz_attempts_on_old_user_id"
    t.index ["quiz_id"], name: "index_quiz_attempts_on_quiz_id"
    t.index ["user_id"], name: "index_quiz_attempts_on_user_id"
  end

  create_table "quiz_question_attempts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "quiz_attempt_id"
    t.bigint "quiz_question_id"
    t.integer "selected_choice", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "time_taken", precision: 8, scale: 2, default: "0.0"
    t.index ["quiz_attempt_id"], name: "index_quiz_question_attempts_on_quiz_attempt_id"
    t.index ["quiz_question_id"], name: "index_quiz_question_attempts_on_quiz_question_id"
  end

  create_table "quiz_questions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "question"
    t.string "choice_1"
    t.string "choice_2"
    t.string "choice_3"
    t.string "choice_4"
    t.string "correct_choice"
    t.bigint "quiz_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_quiz_questions_on_quiz_id"
  end

  create_table "quiz_winners", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "quiz_id"
    t.bigint "user_id"
    t.decimal "points", precision: 10, scale: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.datetime "deleted_at"
    t.bigint "old_user_id"
    t.index ["old_user_id"], name: "index_quiz_winners_on_old_user_id"
    t.index ["quiz_id"], name: "index_quiz_winners_on_quiz_id"
    t.index ["user_id"], name: "index_quiz_winners_on_user_id"
  end

  create_table "quizzes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "redeems", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "mobile"
    t.string "account_no"
    t.string "ifsc"
    t.string "bank_name"
    t.string "name"
    t.string "email"
    t.decimal "coins", precision: 10, scale: 4
    t.bigint "user_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind"
    t.string "swift_code"
    t.datetime "deleted_at"
    t.bigint "old_user_id"
    t.string "reason"
    t.index ["old_user_id"], name: "index_redeems_on_old_user_id"
    t.index ["user_id"], name: "index_redeems_on_user_id"
  end

  create_table "reward_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "task_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "old_user_id"
    t.index ["old_user_id"], name: "index_reward_tasks_on_old_user_id"
    t.index ["task_id"], name: "index_reward_tasks_on_task_id"
    t.index ["user_id", "task_id"], name: "index_reward_tasks_on_user_id_and_task_id", unique: true
    t.index ["user_id"], name: "index_reward_tasks_on_user_id"
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "rpush_apps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "environment"
    t.text "certificate"
    t.string "password"
    t.integer "connections", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "auth_key"
    t.string "client_id"
    t.string "client_secret"
    t.string "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "device_token", limit: 64, null: false
    t.timestamp "failed_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token"
  end

  create_table "rpush_notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "badge"
    t.string "device_token", limit: 64
    t.string "sound"
    t.text "alert"
    t.text "data"
    t.integer "expiry", default: 86400
    t.boolean "delivered", default: false, null: false
    t.timestamp "delivered_at"
    t.boolean "failed", default: false, null: false
    t.timestamp "failed_at"
    t.integer "error_code"
    t.text "error_description"
    t.timestamp "deliver_after"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "alert_is_json", default: false, null: false
    t.string "type", null: false
    t.string "collapse_key"
    t.boolean "delay_while_idle", default: false, null: false
    t.text "registration_ids", limit: 16777215
    t.integer "app_id", null: false
    t.integer "retries", default: 0
    t.string "uri"
    t.timestamp "fail_after"
    t.boolean "processing", default: false, null: false
    t.integer "priority"
    t.text "url_args"
    t.string "category"
    t.boolean "content_available", default: false, null: false
    t.text "notification"
    t.boolean "mutable_content", default: false, null: false
    t.string "external_device_id"
    t.index ["delivered", "failed", "processing", "deliver_after", "created_at"], name: "index_rpush_notifications_multi"
  end

  create_table "settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "kind"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_submits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "task_id"
    t.bigint "user_id"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1
    t.datetime "deleted_at"
    t.bigint "old_user_id"
    t.index ["old_user_id"], name: "index_task_submits_on_old_user_id"
    t.index ["task_id"], name: "index_task_submits_on_task_id"
    t.index ["user_id"], name: "index_task_submits_on_user_id"
  end

  create_table "tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "instructions"
    t.decimal "amount", precision: 10
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: false
    t.integer "cap", default: 0
    t.integer "downloaded", default: 0
    t.boolean "picture_upload", default: true
    t.integer "run_days", default: 1
    t.integer "parent_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "slug"
  end

  create_table "transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "amount", precision: 10, scale: 4
    t.integer "category"
    t.integer "direction"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "from_user_id"
    t.text "data"
    t.integer "from_user_status"
    t.datetime "deleted_at"
    t.bigint "old_user_id"
    t.index ["old_user_id"], name: "index_transactions_on_old_user_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "user_refers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.integer "down_user_id"
    t.integer "level", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_refers_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mobile"
    t.integer "gender"
    t.string "name"
    t.string "refer_id"
    t.string "sponsor_id"
    t.string "real_sponsor_id"
    t.string "authentication_token", limit: 30
    t.integer "status", default: 0
    t.string "token"
    t.boolean "hollow", default: false
    t.boolean "lock", default: false
    t.date "lock_last"
    t.boolean "game", default: false
    t.date "game_last"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["refer_id"], name: "index_users_on_refer_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "wallets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "active", precision: 10, scale: 4
    t.decimal "passive", precision: 10, scale: 4
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "activation", precision: 10, scale: 4, default: "0.0"
    t.datetime "deleted_at"
    t.bigint "old_user_id"
    t.decimal "redeem", precision: 10, scale: 4, default: "0.0"
    t.decimal "screen_lock", precision: 10, scale: 4, default: "0.0"
    t.decimal "total_earning", precision: 10, scale: 4, default: "0.0"
    t.decimal "total_redeem", precision: 10, scale: 4, default: "0.0"
    t.index ["old_user_id"], name: "index_wallets_on_old_user_id"
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  create_table "wallpapers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "image"
    t.integer "downloaded", default: 0
    t.boolean "premium", default: false
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_wallpapers_on_category_id"
  end

  create_table "you_tubes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  add_foreign_key "categories", "tasks"
  add_foreign_key "conversions", "deals"
  add_foreign_key "conversions", "offers"
  add_foreign_key "conversions", "old_users"
  add_foreign_key "conversions", "products"
  add_foreign_key "conversions", "users"
  add_foreign_key "deal_uploads", "deals"
  add_foreign_key "deal_uploads", "old_users"
  add_foreign_key "deal_uploads", "users"
  add_foreign_key "limits", "old_users"
  add_foreign_key "limits", "users"
  add_foreign_key "quiz_attempts", "old_users"
  add_foreign_key "quiz_attempts", "quizzes"
  add_foreign_key "quiz_attempts", "users"
  add_foreign_key "quiz_question_attempts", "quiz_attempts"
  add_foreign_key "quiz_question_attempts", "quiz_questions"
  add_foreign_key "quiz_questions", "quizzes"
  add_foreign_key "quiz_winners", "old_users"
  add_foreign_key "quiz_winners", "quizzes"
  add_foreign_key "quiz_winners", "users"
  add_foreign_key "redeems", "old_users"
  add_foreign_key "redeems", "users"
  add_foreign_key "reward_tasks", "old_users"
  add_foreign_key "reward_tasks", "tasks"
  add_foreign_key "reward_tasks", "users"
  add_foreign_key "task_submits", "old_users"
  add_foreign_key "task_submits", "tasks"
  add_foreign_key "task_submits", "users"
  add_foreign_key "transactions", "old_users"
  add_foreign_key "transactions", "users"
  add_foreign_key "user_refers", "users"
  add_foreign_key "wallets", "old_users"
  add_foreign_key "wallets", "users"
  add_foreign_key "wallpapers", "categories"
end
