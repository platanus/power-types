require 'spec_helper'

describe PowerTypes::Observer do
  let(:observable) { double(:observable) }

  before(:context) do
    @t1 = described_class.before_save(:some_method)
    @t2 = described_class.after_create { some_method }
    @t3 = described_class.after_create { another_method }
  end

  PowerTypes::Util::OBSERVABLE_EVENTS.each do |event|
    PowerTypes::Util::OBSERVABLE_TYPES.each do |type|
      it { expect(described_class).to respond_to("#{type}_#{event}") }
    end
  end

  it { expect(described_class.triggers.count).to eq(3) }

  it "calls valid trigger" do
    expect(@t1).to receive(:call).with(instance_of(PowerTypes::Observer)).and_return(true)
    expect(described_class).to receive(:new).with(observable).and_call_original
    described_class.trigger(:before, :save, observable)
  end

  it "calls valid trigger" do
    expect(@t2).to receive(:call).with(instance_of(PowerTypes::Observer)).and_return(true)
    expect(@t3).to receive(:call).with(instance_of(PowerTypes::Observer)).and_return(true)
    expect(described_class).to receive(:new).with(observable).twice.and_call_original

    described_class.trigger(:after, :create, observable)
  end
end
