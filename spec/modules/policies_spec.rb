require 'rails_helper'

RSpec.describe Policies do
  class DummyClass
    include Policies

    attr_accessor :cpf
    attr_accessor :monthly_installment
    attr_accessor :refused_policy
    attr_accessor :birthdate
    attr_accessor :terms
    attr_accessor :approved_terms
    attr_accessor :amount
    attr_accessor :income
  end

  let(:dummy_class) { DummyClass.new }

  describe 'Age policy' do
    it "doesn't update refused_policy on valid age" do
      dummy_class.birthdate = Date.today - 18.years
      dummy_class.age_policy
      expect(dummy_class.refused_policy).to be_nil
    end

    it "update refused_policy to 'age' on invalid age" do\
      dummy_class.birthdate = Date.today - 17.years
      dummy_class.age_policy
      expect(dummy_class.refused_policy).to eq('age')
    end
  end

  describe 'Score policy' do
    it "doesn't update refused_policy on valid score" do
      allow(dummy_class).to receive(:score).and_return(600)

      dummy_class.score_policy
      expect(dummy_class.refused_policy).to be_nil
    end

    it "update refused_policy to 'score' on invalid score" do\
      allow(dummy_class).to receive(:score).and_return(599)

      dummy_class.score_policy
      expect(dummy_class.refused_policy).to eq('score')
    end
  end

  describe 'Commitment policy' do
    context 'valid policy' do
      it "doesn't update refused_policy on valid commitment" do
        allow(dummy_class).to receive(:score).and_return(600)
        allow(dummy_class).to receive(:commitment).and_return(0.8)

        expect(dummy_class.refused_policy).to be_nil
        # with this income we have 300,00 available
        dummy_class.income = 1500.to_d
        dummy_class.amount = 2395.50.to_d
        dummy_class.terms = 6
        dummy_class.commitment_policy
        expect(dummy_class.refused_policy).to be_nil
      end

      it 'gives right number of approved_terms' do
        allow(dummy_class).to receive(:score).and_return(600)
        allow(dummy_class).to receive(:commitment).and_return(0.8)

        # with this income we have 300,00 available
        dummy_class.income = 1500.to_d
        dummy_class.amount = 2395.50.to_d
        dummy_class.terms = 6
        dummy_class.commitment_policy
        expect(dummy_class.approved_terms).to eq(12)
      end

      it 'gives the right amount for monthly_installment' do
        allow(dummy_class).to receive(:score).and_return(600)
        allow(dummy_class).to receive(:commitment).and_return(0.8)

        # with this income we have 300,00 available
        dummy_class.income = 1500.to_d
        dummy_class.amount = 2395.50.to_d
        dummy_class.terms = 6
        dummy_class.commitment_policy
        expect(dummy_class.monthly_installment).to eq(299.99.to_d)
      end

      it "update refused_policy to 'commitment' on invalid commitment" do\
        allow(dummy_class).to receive(:score).and_return(600)
        allow(dummy_class).to receive(:commitment).and_return(0.8)

        # with this income we have 300,00 available
        dummy_class.income = 1500.to_d
        dummy_class.amount = 2500.to_d
        dummy_class.terms = 6
        dummy_class.commitment_policy
        expect(dummy_class.refused_policy).to eq('commitment')
        expect(dummy_class.approved_terms).to eq(nil)
        expect(dummy_class.monthly_installment).to eq(313.08.to_d)
      end
    end
  end
end
