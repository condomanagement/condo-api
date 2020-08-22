# frozen_string_literal: true

class ResourceQuestionsController < ActionController::API
  before_action :set_resource_question, only: [:show, :edit, :update, :destroy]

  # POST /resource_questions
  # POST /resource_questions.json
  def create
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end
    @resource_question = ResourceQuestion.new(resource_question_params)

    if @resource_question.save
      render json: @resource_question, status: :created
    else
      render json: @resource_question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /resource_questions/1
  # DELETE /resource_questions/1.json
  def destroy
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end
    @resource_question.destroy
    head :no_content
  end

  def remove
    unless User.admin_by_token?(request.cookies["token"])
      render json: { error: "invalid_token" }, status: :unauthorized
      return
    end
    @resource_question = ResourceQuestion.find_by(
      resource_id: params[:resource_question][:resource_id],
      question_id: params[:resource_question][:question_id]
    )
    @resource_question.destroy
    head :no_content
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_resource_question
    @resource_question = ResourceQuestion.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def resource_question_params
    params.require(:resource_question).permit(:question_id, :resource_id)
  end
end
