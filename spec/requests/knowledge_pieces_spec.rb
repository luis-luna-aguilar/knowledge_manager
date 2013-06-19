require 'spec_helper'

describe "KnowledgePieces" do
  describe "GET /knowledge_pieces" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get knowledge_pieces_path
      response.status.should be(200)
    end
  end
end
