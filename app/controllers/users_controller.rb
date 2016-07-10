class UsersController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  NUM_TO_TWEETS = 10

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
    session[:user_id] = @user
  end

  def show
    @user = User.find(session[:user_id])
  end

  def authenticate
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = params[:consumer_key]
      config.consumer_secret     = params[:consumer_secret]
      config.access_token        = params[:access_token]
      config.access_token_secret = params[:access_token_secret]
    end

    begin
      client.status(27558893223)

      session[:consumer_key] = params[:consumer_key]
      session[:consumer_secret] = params[:consumer_secret]
      session[:access_token] = params[:access_token]
      session[:access_token_secret] = params[:access_token_secret]

      @user = User.find(session[:user_id] )
      render 'twitter_bot'
    rescue
      flash[:warning] = "We are not able to authenticate your twitter account"
      @user = User.find(params[:id])
      session[:consumer_key] = nil
      session[:consumer_secret] = nil
      session[:access_token] = nil
      session[:access_token_secret] = nil
      render 'show'
    end
  end

  def twitter_actions
    twitter_client = get_client
    @user = User.find(session[:user_id])
    begin
      case params[:act]
      when "by"
          handle = "#{params[:q]}"
          @t_objects = twitter_client.user_timeline(handle).take(NUM_TO_TWEETS)
        when "to"
          handle = "to:#{params[:q]}"
          @t_objects = twitter_client.search(handle, result_type: "recent").take(NUM_TO_TWEETS)
        when "post_tweet"
          handle = "My"
          @t_objects = twitter_client.update(params[:q])
        when "hashtag"
          handle = params[:q].start_with?('#') ? params[:q] : "##{params[:q]}"
          @t_objects = twitter_client.search(handle, result_type: "recent").take(NUM_TO_TWEETS)
      end
    rescue
      @t_objects = "#{handle} is not recognized by twitter, please enter valid keyword"
    end
    @query = handle
    render 'twitter_bot' 
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def get_client
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = session[:consumer_key]
        config.consumer_secret     = session[:consumer_secret]
        config.access_token        = session[:access_token]
        config.access_token_secret = session[:access_token_secret]
      end
    end

end
