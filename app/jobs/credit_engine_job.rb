class CreditEngineJob < ApplicationJob
  queue_as :default

  def perform(loan)
    loan.run_policies
    loan.save
  end
end
