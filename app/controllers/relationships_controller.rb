# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def participation
    @relationship = Relationship.find(params[:id])
    if @relationship.user_id == 0
      @relationship.user_id = current_user.id
      @relationship.permission = true
      if @relationship.save
        participated_notification
        flash[:notice] = '参加しました'
        redirect_back(fallback_location: bands_path)
      else
        flash[:alert] = '参加に失敗しました'
        redirect_back(fallback_location: bands_path)
      end
    else
      flash[:alert] = 'そのパートは空いていません'
      redirect_back(fallback_location: bands_path)
    end
  end

  def update
    @relationship = Relationship.find(params[:id])
    @relationship.permission = true
    if @relationship.save
      participated_notification
      flash[:notice] = '参加しました'
      redirect_back(fallback_location: bands_path)
    else
      flash[:alert] = '参加に失敗しました'
      redirect_back(fallback_location: bands_path)
    end
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    if @relationship.destroy
      decline_notification
      flash[:notice] = '拒否しました'
      redirect_back(fallback_location: bands_path)
    else
      flash[:alert] = '拒否に失敗しました'
      redirect_back(fallback_location: bands_path)
   end
  end

  def participated_notification
    @band = Band.find_by(id: @relationship.band_id)
    user_ids = Relationship.where(band_id: @band.id, permission: true).where.not(user_id: current_user.id).select(:user_id)
    members = User.where(id: user_ids) # 既存のメンバー
    members.each do |member|
      participated_notification = current_user.active_notifications.new(
        band_id: @band.id,
        visited_id: member.id,
        relationship_id: @relationship.id,
        action: 'participated'
      )
      participated_notification.save if participated_notification.valid?
    end
  end

  def decline_notification
    @band = Band.find_by(id: @relationship.band_id)
    user_ids = Relationship.where(band_id: @band.id, permission: true).where.not(user_id: current_user.id).select(:user_id)
    members = User.where(id: user_ids) # 既存のメンバー
    members.each do |member|
      decline_notification = current_user.active_notifications.new(
        band_id: @band.id,
        visited_id: member.id,
        action: 'decline'
      )
      decline_notification.save if decline_notification.valid?
    end
  end
end
