class Api::V1::LoansController < ApplicationController
  before_action :set_loan, only: :show

  # GET /loans
  def index
    @loans = Loan.all

    render json: @loans
  end

  # GET /loans/1
  def show
    loan_info = @loan.as_json(only: %i[id status result refused_policy amount approved_terms])
    render json: loan_info
  end

  # POST /loans
  def create
    @loan = Loan.new(loan_params)

    if @loan.save
      render json: { id: @loan.id }, status: :created, location: api_v1_loans_url
    else
      render json: { errors: @loan.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_loan
    @loan = Loan.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def loan_params
    params.require(:loan).permit(:name, :cpf, :birthdate, :amount, :terms, :income)
  end
end
