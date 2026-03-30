class DigestsController < ApplicationController
  before_action :authenticate_user!

  def show
    @new_items = Item.where("created_at >= ?", 24.hours.ago).order(created_at: :desc)
  end
end
