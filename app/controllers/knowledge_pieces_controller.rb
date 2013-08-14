class KnowledgePiecesController < ApplicationController
  
  # GET /knowledge_pieces
  # GET /knowledge_pieces.json
  def index
    @search = KnowledgePiece.search(params[:q])
    @knowledge_pieces = @search.result

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @knowledge_pieces }
    end
  end

  # GET /knowledge_pieces/1
  # GET /knowledge_pieces/1.json
  def show
    @knowledge_piece = KnowledgePiece.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @knowledge_piece }
    end
  end

  # GET /knowledge_pieces/new
  # GET /knowledge_pieces/new.json
  def new
    @knowledge_piece = KnowledgePiece.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @knowledge_piece }
    end
  end

  # GET /knowledge_pieces/1/edit
  def edit
    @knowledge_piece = KnowledgePiece.find(params[:id])
  end

  # POST /knowledge_pieces
  # POST /knowledge_pieces.json
  def create
    @knowledge_piece = KnowledgePiece.new(params[:knowledge_piece])
    
    respond_to do |format|
      if @knowledge_piece.save
        format.html { redirect_to @knowledge_piece, notice: 'Knowledge piece was successfully created.' }
        format.json { render json: @knowledge_piece, status: :created, location: @knowledge_piece }
      else
        format.html { render action: "new" }
        format.json { render json: @knowledge_piece.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /knowledge_pieces/1
  # PUT /knowledge_pieces/1.json
  def update
    @knowledge_piece = KnowledgePiece.find(params[:id])
    
    respond_to do |format|
      if @knowledge_piece.update_attributes(params[:knowledge_piece])
        format.html { redirect_to @knowledge_piece, notice: 'Knowledge piece was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @knowledge_piece.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /knowledge_pieces/1
  # DELETE /knowledge_pieces/1.json
  def destroy
    @knowledge_piece = KnowledgePiece.find(params[:id])
    @knowledge_piece.destroy

    respond_to do |format|
      format.html { redirect_to knowledge_pieces_url }
      format.json { head :no_content }
    end
  end
end
