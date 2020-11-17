# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def participation # 募集中のバンドに参加する
    @relationship = Relationship.find(params[:id])
    @band = Band.find(@relationship.band_id)
    @relationship.user_id = current_user.id
    @relationship.permission = true
    if @relationship.save
      @band.participated_notification(@relationship, current_user)
      flash[:notice] = '参加しました'
      redirect_back(fallback_location: bands_path)
    else
      flash[:alert] = '参加に失敗しました'
      redirect_back(fallback_location: bands_path)
    end
  end

  def update # 招待を承認する
    @relationship = Relationship.find(params[:id])
    @band = Band.find(@relationship.band_id)
    @relationship.permission = true
    if @relationship.save
      @band.participated_notification(@relationship, current_user)
      flash[:notice] = '参加しました'
      redirect_back(fallback_location: bands_path)
    else
      flash[:alert] = '参加に失敗しました'
      redirect_back(fallback_location: bands_path)
    end
  end

  def destroy # 招待を拒否する
    @relationship = Relationship.find(params[:id])
    if @relationship.destroy
      flash[:notice] = '拒否しました'
      redirect_back(fallback_location: bands_path)
    else
      flash[:alert] = '拒否に失敗しました'
      redirect_back(fallback_location: bands_path)
    end
  end
end
