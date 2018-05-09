require 'rails_helper'

RSpec.describe Exporters::Trips do
  subject(:exporter) { described_class.new(options) }

  let(:trips) { create_list(:trip, 5) }
  let(:options) { { trips: trips } }

  describe "instance call .filename" do
    it 'returns a valid name' do
      expect(exporter.filename).to be_a String
      expect(exporter.filename).not_to be_empty
    end
  end

  describe "instance call .sheetname" do
    it 'returns a valid name' do
      expect(exporter.sheetname).to be_a String
      expect(exporter.sheetname).not_to be_empty
    end
  end

  describe "instance call .data_stream" do
    it do
      header_length = exporter.data_stream.to_a.first.size
      expect(exporter.data_stream.to_a).to all( have_exactly(header_length).items )
    end
  end

  context "trip with 1 delivery" do
    describe "instance call .csv_stream" do
      it { expect(exporter.csv_stream).to be_a Enumerator }
      it { expect(exporter.csv_stream).to have_exactly(6).items }
    end

    describe "instance call .data_stream" do
      it { expect(exporter.data_stream).to be_a Enumerator }
      it { expect(exporter.data_stream).to have_exactly(6).items }
    end
  end

  context "trip with N deliveries" do
    let(:trips) { create_list(:trip, 5, deliveries: create_list(:delivery_with_packages, 2)) }

    describe "instance call .csv_stream" do
      it { expect(exporter.csv_stream).to be_a Enumerator }
      it { expect(exporter.csv_stream).to have_exactly(11).items }
      it { expect(exporter.csv_stream.to_a).to all(be_a String) }
    end

    describe "instance call .data_stream" do
      it { expect(exporter.data_stream).to be_a Enumerator }
      it { expect(exporter.data_stream).to have_exactly(11).items }
      it { expect(exporter.data_stream.to_a).to all(be_a Array) }
    end
  end
end
