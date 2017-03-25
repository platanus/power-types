require 'spec_helper'

describe PowerTypes::Trigger do
  describe "#initialize" do
    it 'raises error with invalid type' do
      expect { described_class.new('invalid_type', :create, :handler) }.to(
        raise_error(RuntimeError, 'Invalid type invalid_type')
      )
    end

    it 'raises error with invalid event' do
      expect { described_class.new(:before, 'invalid_event', :handler) }.to(
        raise_error(RuntimeError, 'Invalid event invalid_event')
      )
    end

    it 'raises error with invalid handler' do
      expect { described_class.new(:before, :create, 1) }.to(
        raise_error(RuntimeError, 'Invalid handler')
      )
    end

    it 'raises error with no handler' do
      expect { described_class.new(:before, :create) }.to(
        raise_error(RuntimeError, 'Missing block or handler name')
      )
    end

    context "with valid params" do
      before { @trigger = described_class.new(:before, :create, :handler) }

      it { expect(@trigger.type).to eq(:before) }
      it { expect(@trigger.event).to eq(:create) }
      it { expect(@trigger.instance_variable_get(:@options)).to eq({}) }
      it { expect(@trigger.instance_variable_get(:@handler)).to eq(:handler) }
    end
  end

  describe "#call" do
    let(:observer) do
      Class.new do
        def some_method
          "executed"
        end
      end.new
    end

    context "with param handler" do
      before { @trigger = described_class.new(:before, :create, :some_method) }

      it { expect(@trigger.call(observer)).to eq("executed") }
    end

    context "with block handler" do
      before { @trigger = described_class.new(:before, :create) { some_method } }

      it { expect(@trigger.call(observer)).to eq("executed") }
    end
  end
end
