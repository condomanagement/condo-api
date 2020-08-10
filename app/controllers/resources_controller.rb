# frozen_string_literal: true

class ResourcesController < ActionController::API
  before_action :set_resource, only: [:show, :edit, :update, :destroy]

  # GET /resources
  # GET /resources.json
  def index
    @resources = Resource.all
  end

  # POST /resources
  # POST /resources.json
  def create
    @resource = Resource.new(resource_params)

    if @resource.save
      render json: @resource, status: :created
    else
      render json: @resource.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /resources/1
  # PATCH/PUT /resources/1.json
  def update
    if @resource.update(resource_params)
      render json: @resource, status: :ok
    else
      render json: @resource.errors, status: :unprocessable_entity
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.json
  def destroy
    @resource.destroy
    head :no_content
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_resource
    @resource = Resource.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def resource_params
    params.require(:resource).permit(:name)
  end
end
