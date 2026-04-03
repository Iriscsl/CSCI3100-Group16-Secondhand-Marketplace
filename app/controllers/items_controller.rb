class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy update_status ]

  # GET /items or /items.json
  def index
    query = params[:query].presence
    min = params[:min_price].presence
    max = params[:max_price].presence
    statuses = params[:status].presence
    community = params[:community].presence

    @items = Item.all
    @items = @items.search_items(query) if query.present?
    @items = @items.with_statuses(statuses) if statuses.present?
    @items = @items.with_community(community) if community.present?
    @items = @items.min_price(min) if min.present?
    @items = @items.max_price(max) if max.present?
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: "Item was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy!

    respond_to do |format|
      format.html { redirect_to items_path, notice: "Item was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def update_status
    @item = Item.find(params[:id])
    new_status = params[:status]
    if @item.update(status: new_status)
      redirect_to @item, notice: "Status updated to #{new_status}."
    else
      redirect_to @item, alert: "Could not update status."
    end
  end

 private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params.expect(:id))
    end

    def item_params
      permitted = params.require(:item).permit(:title, :description, :price, :status, :community)
      permitted[:community] = permitted[:community].to_i if permitted[:community]
      permitted
    end
end
