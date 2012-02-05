# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120205111319) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "addresses", :force => true do |t|
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.string   "address_type"
    t.string   "title"
    t.text     "street"
    t.string   "phone"
    t.string   "mobile_phone"
    t.string   "fax"
    t.string   "email"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
    t.integer  "locality_id"
    t.integer  "administrative_area_id"
    t.integer  "subadministrative_area_id"
    t.integer  "country_id"
  end

  add_index "addresses", ["addressable_id"], :name => "index_addresses_on_addressable_id"
  add_index "addresses", ["addressable_type"], :name => "index_addresses_on_addressable_type"
  add_index "addresses", ["administrative_area_id"], :name => "index_addresses_on_administrative_area_id"
  add_index "addresses", ["country_id"], :name => "index_addresses_on_country_id"
  add_index "addresses", ["locality_id"], :name => "index_addresses_on_locality_id"
  add_index "addresses", ["subadministrative_area_id"], :name => "index_addresses_on_subadministrative_area_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "balance_sheets", :force => true do |t|
    t.integer  "company_id"
    t.integer  "year"
    t.integer  "sales"
    t.integer  "number_of_people"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "balance_sheets", ["company_id"], :name => "index_balance_sheets_on_company_id"

  create_table "companies", :force => true do |t|
    t.string   "legal_name"
    t.string   "name"
    t.string   "role"
    t.string   "code"
    t.float    "capital"
    t.date     "creation_date"
    t.string   "company_type"
    t.string   "siret"
    t.string   "linkedin"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "website"
    t.string   "phone"
    t.string   "fax"
    t.string   "logo"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "global_rate"
    t.float    "price_rate"
    t.float    "reactivity_rate"
    t.float    "relational_rate"
    t.float    "approach_rate"
    t.float    "expertise_rate"
    t.integer  "testimonials_count"
    t.integer  "balance_sheet_year"
    t.integer  "balance_sheet_sales"
    t.integer  "balance_sheet_number_of_people"
    t.integer  "logo_mini_width"
    t.integer  "logo_mini_height"
    t.integer  "logo_medium_width"
    t.integer  "logo_medium_height"
    t.integer  "ratings_count",                  :default => 0
    t.string   "rcs"
    t.string   "tva_id"
    t.integer  "logo_macro_width"
    t.integer  "logo_macro_height"
    t.text     "description_html"
    t.text     "cached_data"
  end

  create_table "companies_categories", :force => true do |t|
    t.integer "company_id"
    t.integer "company_category_id"
  end

  add_index "companies_categories", ["company_category_id"], :name => "index_companies_categories_on_company_category_id"
  add_index "companies_categories", ["company_id"], :name => "index_companies_categories_on_company_id"

  create_table "companies_tracked_proposals", :id => false, :force => true do |t|
    t.integer "company_id"
    t.integer "proposal_id"
  end

  add_index "companies_tracked_proposals", ["company_id"], :name => "index_companies_tracked_proposals_on_company_id"
  add_index "companies_tracked_proposals", ["proposal_id"], :name => "index_companies_tracked_proposals_on_proposal_id"

  create_table "company_categories", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geographic_areas", :force => true do |t|
    t.string   "title"
    t.string   "code"
    t.string   "area_type"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
  end

  add_index "geographic_areas", ["area_type"], :name => "index_geographic_areas_on_area_type"

  create_table "list_companies", :id => false, :force => true do |t|
    t.integer "list_id"
    t.integer "company_id"
  end

  add_index "list_companies", ["company_id"], :name => "index_list_companies_on_company_id"
  add_index "list_companies", ["list_id"], :name => "index_list_companies_on_list_id"

  create_table "lists", :force => true do |t|
    t.string   "title"
    t.string   "list_type",         :default => "standard"
    t.integer  "company_id"
    t.integer  "companies_counter", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["company_id"], :name => "index_lists_on_company_id"

  create_table "pictures", :force => true do |t|
    t.string   "pictureable_type"
    t.integer  "pictureable_id"
    t.string   "title"
    t.string   "file"
    t.integer  "file_mini_width"
    t.integer  "file_mini_height"
    t.integer  "file_medium_width"
    t.integer  "file_medium_height"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pictures", ["pictureable_id"], :name => "index_pictures_on_pictureable_id"
  add_index "pictures", ["pictureable_type"], :name => "index_pictures_on_pictureable_type"

  create_table "proposal_company_addresses", :force => true do |t|
    t.integer "proposal_id"
    t.integer "address_id"
  end

  add_index "proposal_company_addresses", ["address_id"], :name => "index_proposal_company_addresses_on_address_id"
  add_index "proposal_company_addresses", ["proposal_id"], :name => "index_proposal_company_addresses_on_proposal_id"

  create_table "proposal_company_categories", :force => true do |t|
    t.integer "proposal_id"
    t.integer "company_category_id"
  end

  add_index "proposal_company_categories", ["company_category_id"], :name => "index_proposal_company_categories_on_company_category_id"
  add_index "proposal_company_categories", ["proposal_id"], :name => "index_proposal_company_categories_on_proposal_id"

  create_table "proposal_documents", :force => true do |t|
    t.integer  "proposal_id"
    t.string   "document"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "proposal_documents", ["proposal_id"], :name => "index_proposal_documents_on_proposal_id"

  create_table "proposal_trackings", :force => true do |t|
    t.integer  "proposal_id"
    t.integer  "company_id"
    t.string   "state"
    t.datetime "read_at"
    t.boolean  "accepted"
    t.datetime "accepted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proposal_trackings", ["company_id"], :name => "index_proposal_trackings_on_company_id"
  add_index "proposal_trackings", ["proposal_id"], :name => "index_proposal_trackings_on_proposal_id"

  create_table "proposals", :force => true do |t|
    t.integer  "user_company_id"
    t.text     "summary"
    t.text     "description"
    t.datetime "start_at"
    t.datetime "end_at"
    t.float    "approximative_budget"
    t.string   "work_mode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description_html"
    t.date     "work_start_at"
    t.date     "work_end_at"
    t.boolean  "public",               :default => true
    t.text     "cached_data"
  end

  add_index "proposals", ["user_company_id"], :name => "index_proposals_on_user_company_id"

  create_table "tag_target_tags", :force => true do |t|
    t.integer "tag_id"
    t.integer "target_tag_id"
    t.string  "context"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "target_tags", :force => true do |t|
    t.string "name"
    t.string "context"
  end

  create_table "testimonials", :force => true do |t|
    t.integer  "company_id"
    t.integer  "user_company_id"
    t.text     "body"
    t.integer  "global_rate"
    t.integer  "price_rate"
    t.integer  "reactivity_rate"
    t.integer  "relational_rate"
    t.integer  "approach_rate"
    t.integer  "expertise_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "body_html"
  end

  add_index "testimonials", ["company_id"], :name => "index_testimonials_on_company_id"
  add_index "testimonials", ["user_company_id"], :name => "index_testimonials_on_user_company_id"

  create_table "user_companies", :force => true do |t|
    t.integer "user_id"
    t.integer "company_id"
    t.string  "role",       :default => "user"
    t.string  "job_title"
    t.integer "position"
  end

  add_index "user_companies", ["company_id"], :name => "index_user_companies_on_company_id"
  add_index "user_companies", ["user_id"], :name => "index_user_companies_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "linkedin"
    t.text     "description"
    t.string   "website"
    t.text     "description_html"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
