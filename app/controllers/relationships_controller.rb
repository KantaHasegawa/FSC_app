class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def participation
    @relationship = Relationship.find(params[:id])
    if @relationship.user_id == 0
      @relationship.user_id = current_user.id
         if @relationship.save
           flash[:notice] = "参加しました"
           redirect_back(fallback_location: bands_path)
         else
            flash[:alert] = "参加に失敗しました"
            redirect_back(fallback_location: bands_path)
         end
    else
      flash[:alert] = "そのパートは空いていません"
      redirect_back(fallback_location: bands_path)
    end
  end

  def update
    @relationship = Relationship.find(params[:id])
    @relationship.permission = true
    if @relationship.save
      flash[:notice] = "参加しました"
      redirect_back(fallback_location: bands_path)
    else
      flash[:alert] = "参加に失敗しました"
      redirect_back(fallback_location: bands_path)
    end
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    if @relationship.delete
     flash[:notice] = "拒否しました"
     redirect_back(fallback_location: bands_path)
   else
     flash[:alert] = "拒否に失敗しました"
     redirect_back(fallback_location: bands_path)
   end
  end
end