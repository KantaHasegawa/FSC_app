# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @relationships=Relationship.where(band_id: params[:band_id])
    @count=0
  end

  def participation # バンドに参加する
    @relationship = Relationship.find(params[:id])
    if @relationship.user_id == 0 # 更新するrelationshipのuser_idが0(募集中)ならcurrent_userのidを代入しpermissionもtrueにする
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

  def update # 招待を承認する
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

  def destroy # 招待を拒否する
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

  def destroy_all
    checked_data = params[:deletes].keys # ここでcheckされたデータを受け取っています。
    if Relationship.destroy(checked_data)
      redirect_to relationships_path
    else
      render action: 'index'
    end
  end


  def participated_notification # 参加通知
    @band = Band.find_by(id: @relationship.band_id)
    user_ids = Relationship.where(band_id: @band.id, permission: true).where.not(user_id: current_user.id).select(:user_id)
    members = User.where(id: user_ids) # 招待を承認済みかつ自分を覗いたバンドメンバーに通知を送る
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

  def decline_notification # 招待拒否通知
    @band = Band.find_by(id: @relationship.band_id)
    user_ids = Relationship.where(band_id: @band.id, permission: true).where.not(user_id: current_user.id).select(:user_id)
    members = User.where(id: user_ids) # 招待を承認済みかつ自分を覗いたバンドメンバーに通知を送る
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
