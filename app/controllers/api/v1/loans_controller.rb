class Api::V1::LoansController < ApplicationController
  before_action :set_loan, only: :show

  # GET /loans
  def index
    @loans = Loan.all

    render json: @loans
  end

  # GET /loans/1
  def show
    render json: @loan
  end

  # POST /loans
  def create
    @loan = Loan.new(loan_params)

    if @loan.save
      render json: @loan, status: :created, location: @loan
    else
      render json: @loan.errors, status: :unprocessable_entity
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
