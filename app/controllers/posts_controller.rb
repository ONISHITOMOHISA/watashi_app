class PostsController < ApplicationController
   protect_from_forgery except: :destroy
   before_action :authenticate_user
   before_action :ensure_correct_user,{only:[:edit, :update, :destroy]}

   
  def index
    @posts = Post.all.order(created_at: :desc)
    @all_ranks = Post.find(Like.group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
    @post = Post.find_by(id: params[:id])
    # @likes_count = Like.where(post_id: @post.id).count
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = @post.user
    @likes_count = Like.where(post_id: @post.id).count
  end

  def new
    @post = Post.new
  end

  def create
  	@post = Post.new(post_params)
    @post.user = @current_user
  	if @post.save
      flash[:notice]="投稿を作成しました"
  	  redirect_to("/posts/index")
    else
      render("posts/new")  
  end	
  end

  def edit
  	@post = Post.find_by(id:params[:id])
  end

  def update
  	@post = Post.find_by(id: params[:id])
  	@post.content = params[:content]
    @post.object = params[:object]
  	if @post.save
    flash[:notice]="投稿を編集しました"
  	redirect_to("/posts/index")
    else
    render("posts/edit")
   end
  end

  def destroy
  	@post = Post.find_by(id:params[:id])
  	@post.destroy
    flash[:notice]="投稿を削除しました"
  	redirect_to("/posts/index")
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice]="権限がありません"
      redirect_to("/posts/index")
    end  
   end 

   private
  def post_params
    params.require(:post).permit(:content, :image, :object)
  end

end
