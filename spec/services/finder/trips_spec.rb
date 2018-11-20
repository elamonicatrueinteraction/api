require 'rails_helper'

RSpec.describe Finder::Trips do
  subject(:service) { described_class.call(institution: institution, filter_params: filter_params) }

  let!(:trips) { create_list(:trip, 5) }
  let(:institution) { nil }
  let(:filter_params) { {} }

  describe ".call" do
    context 'with an institution' do
      let(:delivery) { trips.sample.deliveries.sample }
      let(:institution) { delivery.receiver }

      it 'succeeds' do
        expect(service).to be_success
      end

      describe 'valid result' do
        it { expect(service.result).to have(5).item }
      end
    end

    context 'without an institution' do
      it 'succeeds' do
        expect(service).to be_success
      end

      describe 'valid result' do
        it { expect(service.result).to have(5).item }
        it { expect(service.result).to contain_exactly(*trips) }
      end
    end

    context 'with date filters' do
      let!(:one_weeks_trips) { create_list(:trip, 1, :created_some_weeks_ago, number_of_weeks: 1) }
      let!(:three_weeks_trips) { create_list(:trip, 2, :created_some_weeks_ago, number_of_weeks: 3) }

      let(:created_since) { 3.week.ago.to_date.to_s }
      let(:created_until) { 1.week.ago.to_date.to_s }

      context 'since date' do
        let(:filter_params) { HashWithIndifferentAccess.new({ created_since: created_since }) }

        it 'succeeds' do
          expect(service).to be_success
        end

        describe 'valid result' do
          it { expect(service.result).to have(8).item }
          it { expect(service.result).to contain_exactly(*trips, *one_weeks_trips, *three_weeks_trips) }
        end
      end

      context 'until date' do
        let(:filter_params) { HashWithIndifferentAccess.new({ created_until: 2.weeks.ago.to_date.to_s }) }

        it 'succeeds' do
          expect(service).to be_success
        end

        describe 'valid result' do
          it { expect(service.result).to have(2).item }
          it { expect(service.result).to contain_exactly(*three_weeks_trips) }
        end
      end

      context 'between dates' do
        let(:filter_params) { HashWithIndifferentAccess.new({ created_since: created_since, created_until: created_until }) }

        it 'succeeds' do
          expect(service).to be_success
        end

        describe 'valid result' do
          it { expect(service.result).to have(3).item }
          it { expect(service.result).to contain_exactly(*one_weeks_trips, *three_weeks_trips) }
        end
      end
    end
  end
end
