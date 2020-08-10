# frozen_string_literal: true

class QuestionsController < ActionController::API
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)

    if @question.save
      render json: @question, status: :created
    else
      format.json { render json: @question.errors, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    if @question.update(question_params)
      render json: @question, status: :ok, location: @question
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    head :no_content
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_question
    @question = Question.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def question_params
    params.require(:question).permit(:question, :required_answer)
  end
end
