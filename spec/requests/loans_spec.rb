require 'rails_helper'

RSpec.describe '/loans', type: :request do
  # This should return the minimal set of attributes required to create a valid
  let(:valid_attributes) do
    {
      name: 'John Doe',
      cpf: '82220194736',
      birthdate: '1994-11-03',
      amount: '3100.00',
      terms: 6,
      income: '1100.00'
    }
  end

  let(:invalid_attributes) do
    {
      name: '',
      cpf: '8222019473',
      birthdate: '1994-111-03',
      amount: '',
      terms: 8,
      income: ''
    }
  end

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # LoansController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) do
    {}
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Loan.create! valid_attributes
      get api_v1_loans_url, as: :json
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      loan = Loan.create! valid_attributes
      get api_v1_loan_url(loan), as: :json
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Loan' do
        expect do
          post api_v1_loans_url,
               params: { loan: valid_attributes }, as: :json
        end.to change(Loan, :count).by(1)
      end

      it 'renders a JSON response with created status' do
        post api_v1_loans_url,
             params: { loan: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including('application/json'))
      end

      it 'renders a JSON response with only the loan id' do
        post api_v1_loans_url,
             params: { loan: valid_attributes }, as: :json
        created_loan = Loan.last
        expect(response.body).to eq({ id: created_loan.id }.to_json)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Loan' do
        expect do
          post api_v1_loans_url,
               params: { loan: invalid_attributes }, as: :json
        end.to change(Loan, :count).by(0)
      end

      it 'renders a JSON response with unprocessable_entity status' do
        post api_v1_loans_url,
             params: { loan: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'renders a JSON response with unprocessable_entity status' do
        post api_v1_loans_url,
             params: { loan: invalid_attributes }, as: :json

        expected_errors = {
          name: ["can't be blank"],
          cpf: ['is the wrong length (should be 11 characters)'],
          birthdate: ["invalid, please follow this pattern: 'yyyy-mm-dd'"],
          terms: ['can only be 6, 9 or 12'],
          income: ['is not a number'],
          amount: ["Must be a number between '1000.00' and '4000.00'"]
        }
        expect(response.body).to eq({ errors: expected_errors }.to_json)
      end
    end
  end
end
