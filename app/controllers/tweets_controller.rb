class TweetsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create]

  def index
    @tweets = Tweet.all

    if params[:tag_ids]
      params[:tag_ids].each do |key, value|
        if value == "1"
          tag = Tag.find_by(name: key)
          @tweets = @tweets & tag.tweets if tag
        end
      end
    end

    if params[:tag].present?
      Tag.find_or_create_by(name: params[:tag])
    end

    if params[:search].present?
      @tweets = @tweets.where(
        "title LIKE ? OR about LIKE ? OR genre LIKE ?",
        "%#{params[:search]}%",
        "%#{params[:search]}%",
        "%#{params[:search]}%"
      )
    end

    if params[:genre].present?
      if params[:genre] == "その他"
        @tweets = @tweets.where.not(
          genre: ["野球", "サッカー", "バスケットボール"]
        )
      else
        @tweets = @tweets.where(genre: params[:genre])
      end
    end
  end

  def new
    @tweet = Tweet.new
  end

  def create
    tweet = Tweet.new(tweet_params)
    tweet.user = current_user

    if tweet.save!
      redirect_to :action => "index"
    else
      redirect_to :action => "new"
    end
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def edit
    @tweet = Tweet.find(params[:id])
  end

  def update
    tweet = Tweet.find(params[:id])

    if tweet.update(tweet_params)
      redirect_to :action => "show", :id => tweet.id
    else
      redirect_to :action => "new"
    end
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to action: :index
  end

  private

  def tweet_params
    params.require(:tweet).permit(
      :title,
      :genre,
      :gamedate,
      :about,
      :image,
      tag_ids: []
    )
  end

end