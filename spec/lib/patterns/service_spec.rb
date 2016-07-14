require 'spec_helper'

describe PowerTypes::Service do
  let(:service) do
    Class.new(described_class.new(:foo, bar: nil)) do
    end
  end

  describe "new" do
    it "fails if argument it not declared in argument list" do
      expect { service.new(teapot: 'bar') }.to raise_error(ArgumentError)
    end

    it "fails if required argument is not provided" do
      expect { service.new(bar: 'bar') }.to raise_error(ArgumentError)
    end

    it { expect(service.new(foo: 'bar').instance_variable_defined?(:@foo)).to be true }
    it { expect(service.new(foo: 'bar').instance_variable_defined?(:@bar)).to be true }
    it { expect(service.new(foo: 'bar').instance_variable_defined?(:@fur)).to be false }
    it { expect(service.new(foo: 'bar').instance_variable_get(:@foo)).to eq 'bar' }
  end
end
