class CreditEngineJob < ApplicationJob
  queue_as :default

  def perform(loan)
    sleep 10

    loan.result = loan.age_policy ? 'approved' : 'refused'
    loan.save
  end
end
