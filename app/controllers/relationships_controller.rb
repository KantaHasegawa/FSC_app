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
    if @relationship.delete
      flash[:notice] = '拒否しました'
      redirect_back(fallback_location: bands_path)
    else
      flash[:alert] = '拒否に失敗しました'
      redirect_back(fallback_location: bands_path)
   end
  end

  def participated_notification
    @band = Band.find_by(id: @relationship.band_id)
    @members = @band.users
    @members.each do |member|
      # すでに通知されているか検索
      temp = Notification.where(['visitor_id = ? and visited_id = ? and band_id = ? and action = ? ',
                                 current_user.id, member.id,
                                 @band.id, 'participated'])
      # 通知されていない場合のみ、通知レコードを作成
      next unless temp.blank?

      notification = current_user.active_notifications.new(
        band_id: @band.id,
        visited_id: member.id,
        action: 'participated'
      )
      # 自分の投稿に対する場合は、通知済みとする
      notification.checked = true if notification.visitor_id == notification.visited_id
      notification.save if notification.valid?
    end
    end
  end
