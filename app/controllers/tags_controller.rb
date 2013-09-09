class TagsController < ApplicationController

  before_filter :search_by_ancestors_name, only: :index

  # GET /tags
  # GET /tags.json
  def index
    @search = Tag.search(params[:q])
    @tags = filtered_tags 

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = Tag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tag }
    end
  end

  # GET /tags/new
  # GET /tags/new.json
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tag }
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = TagBuilder.new(params[:tag][:name]).create!

    respond_to do |format|
      if @tag.valid?
        format.html { redirect_to tags_path, notice: 'Tag was successfully created.' }
        format.json { render json: @tag, status: :created, location: @tag }
      else
        format.html { render action: "new" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.json
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        format.html { redirect_to tags_path, notice: 'Tag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to tags_url }
      format.json { head :no_content }
    end
  end

  def unique_names
    render json: Tag.all.map(&:unique_name).as_json
  end

  private

    def search_by_ancestors_name
      if params[:q] && params[:q][:ancestors_name_cont].present?
        ancestors_name = params[:q].delete(:ancestors_name_cont)
        @search_by_ancestors_name_results = Tag.find_descendants_by_ancestor_name(ancestors_name)
        @search_by_ancestors_name_field_value = ancestors_name
      else
        @search_by_ancestors_name_field_value = ""
      end
    end

    def filtered_tags
      if @search_by_ancestors_name_results.present?
        @search.result & @search_by_ancestors_name_results
      else
        @search.result
      end
    end

end
