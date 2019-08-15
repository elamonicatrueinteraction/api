require 'rails_helper'

describe 'Obsolesce Payment' do

  describe 'with mercadopago payment created' do
    context 'when payment is paid' do
      it 'returns error' do
        pending 'Not implemented'
      end
    end

    context "when payment's remote correspondence has been paid" do
      it 'returns error and updates the payment' do
        pending 'Not implemented'
      end
    end

    it "marks payment as obsolete and updates the institutions debt" do
      pending 'Not implemented'
    end
  end
end