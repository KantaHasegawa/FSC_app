class RelationshipsController < ApplicationController
  def create
  end

  def edit
  end

  def destroy
    @relationship=Relationship.find(params[:id])
    if @relationship.delete
      redirect_back(fallback_location: bands_path)
      flash[:notice] = '除名に成功しました'
    end

  end
end
