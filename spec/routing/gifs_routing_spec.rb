require "spec_helper"

describe GifsController do
  describe "routing" do

    it "routes to #index" do
      get("/gifs").should route_to("gifs#index")
    end

    it "routes to #new" do
      get("/gifs/new").should route_to("gifs#new")
    end

    it "routes to #show" do
      get("/gifs/1").should route_to("gifs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/gifs/1/edit").should route_to("gifs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/gifs").should route_to("gifs#create")
    end

    it "routes to #update" do
      put("/gifs/1").should route_to("gifs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/gifs/1").should route_to("gifs#destroy", :id => "1")
    end

  end
end
