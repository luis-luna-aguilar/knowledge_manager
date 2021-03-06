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

ActiveRecord::Schema.define(:version => 20131007055706) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "brief"
  end

  add_index "articles", ["title"], :name => "index_articles_on_title"

  create_table "articles_tags", :id => false, :force => true do |t|
    t.integer "article_id"
    t.integer "tag_id"
  end

  add_index "articles_tags", ["article_id", "tag_id"], :name => "index_articles_tags_on_article_id_and_tag_id"

  create_table "knowledge_pieces", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "article_id"
  end

  add_index "knowledge_pieces", ["article_id"], :name => "index_knowledge_pieces_on_article_id"
  add_index "knowledge_pieces", ["title"], :name => "index_knowledge_pieces_on_title"

  create_table "knowledge_pieces_tags", :id => false, :force => true do |t|
    t.integer "knowledge_piece_id"
    t.integer "tag_id"
  end

  add_index "knowledge_pieces_tags", ["knowledge_piece_id", "tag_id"], :name => "index_knowledge_pieces_tags_on_knowledge_piece_id_and_tag_id"

  create_table "references", :force => true do |t|
    t.string   "url"
    t.integer  "referenceable_id"
    t.string   "referenceable_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "ancestry"
  end

  add_index "tags", ["ancestry"], :name => "index_tags_on_ancestry"
  add_index "tags", ["name"], :name => "index_tags_on_name"

end
