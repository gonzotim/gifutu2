class GifsController < ApplicationController
  before_action :set_gif, only: [:show, :edit, :update, :destroy]

  # GET /gifs
  # GET /gifs.json
  def index

    if params[:tag]
      puts "TAG IS " + params[:tag]
      puts "PARMAS ARE " + params[:sort].to_s
      if params[:sort] == "most_recent"
        @gifs = Gif.tagged_with(params[:tag]).order("created_at DESC")
      else
        @gifs = Gif.tagged_with(params[:tag]).order("ratio DESC")
      end
    else
      @gifs = Gif.all
    end

    @gifdex = @gifs.map{|gif| gif.id}
    session[:gifdex] = @gifdex
    session[:position] = 0
    if params[:tag]
    
    else
      session[:tag] = params[:tag]
    end

    @gif = Gif.fetch_gif_and_next(session[:gifdex], session[:position])[0]
    @next_gif = Gif.fetch_gif_and_next(session[:gifdex], session[:position])[1]

    render "show"
  end

  def list
    @gifs = Gif.all

    render "index"
  end

  def unapproved
    @gifs = Gif.where("approved = ? AND deleted = ?", false, false)

    puts "ZZzzzzzZZZZZZZZ"
    puts @gifs.count.to_s

    @gifdex = @gifs.map{|gif| gif.id}
    session[:gifdex] = @gifdex
    session[:position] = 0

    @gif = Gif.fetch_gif_and_next(session[:gifdex], session[:position])[0]
    @next_gif = Gif.fetch_gif_and_next(session[:gifdex], session[:position])[1]


    render "show"
  end

  def approve
    @gif = Gif.find(params[:id])
    @gif.approved = true
    @gif.save
    redirect_to @gif
  end

  def reject
    @gif = Gif.find(params[:id])
    @gif.approved = false
    @gif.save
    redirect_to @gif
  end

  def delete
    @gif = Gif.find(params[:id])
    @gif.deleted = true
    @gif.save
    redirect_to @gif
  end

  def undelete
    @gif = Gif.find(params[:id])
    @gif.deleted = false
    @gif.save
    redirect_to @gif
  end

  # GET /gifs/1
  # GET /gifs/1.json
  def show
    @gifdex = session[:gifdex]
    session[:position] = session[:gifdex].index(@gif.id)

    @next_gif = Gif.fetch_gif_and_next(session[:gifdex], session[:position])[1]

  end

  # GET /gifs/new
  def new
    @gif = Gif.new
  end

  # GET /gifs/1/edit
  def edit
  end

  # POST /gifs
  # POST /gifs.json
  def create
    @gif = Gif.new(gif_params)
    @gif.avatar_remote_url(@gif.url)

    respond_to do |format|
      if @gif.save
        format.html { redirect_to @gif, notice: 'Gif was successfully created.' }
        format.json { render action: 'show', status: :created, location: @gif }
      else
        format.html { render action: 'new' }
        format.json { render json: @gif.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gifs/1
  # PATCH/PUT /gifs/1.json
  def update
    respond_to do |format|
      if @gif.update(gif_params)
        format.html { redirect_to @gif, notice: 'Gif was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @gif.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gifs/1
  # DELETE /gifs/1.json
  def destroy
    @gif.destroy
    respond_to do |format|
      format.html { redirect_to gifs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gif
      @gif = Gif.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gif_params
      params.require(:gif).permit(:caption, :upvotes, :downvotes, :views, :ratio, :avatar, :url, :tag_list)
    end

end
