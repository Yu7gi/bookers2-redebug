class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :hide_search, only: [:followings, :followers]

  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    redirect_to request.referer
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_to request.referer
  end

  def followings
    user = User.find(params[:user_id])
    @users = user.relation_followings
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.relation_followers
  end

  private

  def hide_search
    @show_search = false
  end
end
