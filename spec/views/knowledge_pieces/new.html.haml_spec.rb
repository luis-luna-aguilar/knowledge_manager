require 'spec_helper'

describe "knowledge_pieces/new" do
  before(:each) do
    assign(:knowledge_piece, stub_model(KnowledgePiece,
      :title => "MyString",
      :body => "MyText"
    ).as_new_record)
  end

  it "renders new knowledge_piece form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", knowledge_pieces_path, "post" do
      assert_select "input#knowledge_piece_title[name=?]", "knowledge_piece[title]"
      assert_select "textarea#knowledge_piece_body[name=?]", "knowledge_piece[body]"
    end
  end
end
