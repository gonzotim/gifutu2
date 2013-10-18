class GifsController < ApplicationController
  before_action :set_gif, only: [:show, :edit, :update, :destroy]
  before_action :check_gifdex, only: [:show]

  # GET /gifs
  # GET /gifs.json
  def index

    if params[:tag]
      #puts "TAG IS " + params[:tag]
      #puts "PARMAS ARE " + params[:sort].to_s
      if params[:sort] == "most_recent"
        @gifs = Gif.tagged_with(params[:tag]).where("approved = ? AND deleted = ?", true, false).order("created_at DESC")
      else
        @gifs = Gif.tagged_with(params[:tag]).where("approved = ? AND deleted = ?", true, false).order("ratio DESC")
      end
    else
      @gifs = Gif.tagged_with("main").where("approved = ? AND deleted = ?", true, false).order("ratio DESC")
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

    if params[:tag]
      @gifs = Gif.tagged_with(params[:tag]).where("approved = ? AND deleted = ?", true, false).order("ratio DESC")
    else
      @gifs = Gif.where("approved = ? AND deleted = ?", true, false)
    end

    @taglist = ActsAsTaggableOn::Tag.all
    @tags = Gif.tag_counts_on(:tags)

    puts @taglist.count
    render "index"
  end

  def unapproved
    @gifs = Gif.where("approved = ? AND deleted = ?", false, false)
    if @gifs.count != 0
      @gifdex = @gifs.map{|gif| gif.id}
      session[:gifdex] = @gifdex
      session[:position] = 0

      @gif = Gif.fetch_gif_and_next(session[:gifdex], session[:position])[0]
      @next_gif = Gif.fetch_gif_and_next(session[:gifdex], session[:position])[1]
      
      render "show"
    else
      render "layouts/missing_page"
    end

    
  end

  def approve
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @gif = Gif.find(params[:id])
    @gif.approved = true
    @gif.save
    redirect_to @gif
  end

  def reject
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @gif = Gif.find(params[:id])
    @gif.approved = false
    @gif.save
    redirect_to @gif
  end

  def delete
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    @gif = Gif.find(params[:id])
    @gif.deleted = true
    @gif.save
    redirect_to @gif
  end

  def undelete
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
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
    if params[:gif_id]
      @last_gif = Gif.find(params[:gif_id])
      puts "last_gif "+@last_gif.id.to_s
      if params[:v] == "true"
        puts "up vote"
        @last_gif.upvotes += 1
      elsif params[:v] == "false"
        puts "down vote"
        @last_gif.downvotes += 1
      end
      @last_gif.views += 1
      @last_gif.save
    end
    @next_gif = Gif.fetch_gif_and_next(session[:gifdex], session[:position])[1]
  end

  # GET /gifs/new
  def new
    @gif = Gif.new
  end

  # GET /gifs/1/edit
  def edit
    authorize! :edit, @user, :message => 'Not authorized as an administrator.'
  end

  # POST /gifs
  # POST /gifs.json
  def create
    @gif = Gif.new(gif_params)
    @gif.avatar_remote_url(@gif.url)
    @gif.approved = false
    @gif.deleted = false
    @gif.upvotes = 0
    @gif.downvotes = 0
    @gif.ratio = 0
    @gif.views = 0

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
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
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
    authorize! :index, @user, :message => 'Not authorized as an administrator.'
    #ToDo This (v) should use destroy but the the life of me I cannot understand why it doesn't work with rolify
    @gif.delete
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

    def check_gifdex
      if session[:position] == nil
        session[:position] = 0
      end
      if session[:gifdex] == nil
        @gifs = Gif.where("approved = ? AND deleted = ?", true, false)
        @gifdex = @gifs.map{|gif| gif.id}
        session[:gifdex] = @gifdex
      end
      if !session[:gifdex].include?(@gif.id)
        session[:gifdex].unshift(@gif.id)
      end
    end

end
