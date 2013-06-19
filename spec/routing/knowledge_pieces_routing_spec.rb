require "spec_helper"

describe KnowledgePiecesController do
  describe "routing" do

    it "routes to #index" do
      get("/knowledge_pieces").should route_to("knowledge_pieces#index")
    end

    it "routes to #new" do
      get("/knowledge_pieces/new").should route_to("knowledge_pieces#new")
    end

    it "routes to #show" do
      get("/knowledge_pieces/1").should route_to("knowledge_pieces#show", :id => "1")
    end

    it "routes to #edit" do
      get("/knowledge_pieces/1/edit").should route_to("knowledge_pieces#edit", :id => "1")
    end

    it "routes to #create" do
      post("/knowledge_pieces").should route_to("knowledge_pieces#create")
    end

    it "routes to #update" do
      put("/knowledge_pieces/1").should route_to("knowledge_pieces#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/knowledge_pieces/1").should route_to("knowledge_pieces#destroy", :id => "1")
    end

  end
end
