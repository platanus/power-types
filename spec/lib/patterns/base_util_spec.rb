require 'spec_helper'

describe PowerTypes::BaseUtil do
  context 'when it is initialized' do
    let(:error) { 'a util cannot be instantiated' }

    it { expect { described_class.new }.to raise_error(PowerTypes::UtilError, error) }
  end
end
