require 'rails_helper'

RSpec.describe CreditEngineJob, type: :job do
  let(:loan) { create :loan }

  it 'updates loan' do
    expect(loan.status).to be_nil
    CreditEngineJob.perform_now(loan)
    expect(loan.status).to eq('completed')
  end
end
