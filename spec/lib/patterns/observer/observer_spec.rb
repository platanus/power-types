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

  it 'calls valid trigger' do
    expect(@t1).to receive(:call).with(instance_of(PowerTypes::Observer)).and_return(true)
    expect(described_class).to receive(:new).with(observable).and_call_original
    described_class.trigger(:before, :save, observable)
  end

  it 'calls valid trigger' do
    expect(@t2).to receive(:call).with(instance_of(PowerTypes::Observer)).and_return(true)
    expect(@t3).to receive(:call).with(instance_of(PowerTypes::Observer)).and_return(true)
    expect(described_class).to receive(:new).with(observable).twice.and_call_original

    described_class.trigger(:after, :create, observable)
  end

  describe '#after commit callbacks' do
    let(:observer) { described_class.new(observable) }
    let(:method) { :method }

    describe '#execute_method_after_commit' do
      let(:send) { observer.send(method) }
      let(:after_commit) { -> { send } }

      before do
        allow(observer).to receive(:after_commit).and_invoke(after_commit)
        allow(observer).to receive(:send).with(method)
        observer.execute_method_after_commit(method)
      end

      it { expect(observer).to have_received(:after_commit) }
      it { expect(observer).to have_received(:send).with(method) }
    end

    shared_examples 'after_commit_callback' do
      let(:after_callback) { -> { described_class.execute_method_after_commit(method) } }

      before do
        allow(described_class).to receive(callback).and_invoke(after_callback)
        allow(described_class).to receive(:execute_method_after_commit).with(method)
        execute_callback
      end

      it { expect(described_class).to have_received(callback) }
      it { expect(described_class).to have_received(:execute_method_after_commit).with(method) }
    end

    describe '#after_create_commit' do
      let(:execute_callback) { described_class.after_create_commit(method) }
      let(:callback) { :after_create }

      it_behaves_like 'after_commit_callback'
    end

    describe '#after_update_commit' do
      let(:execute_callback) { described_class.after_update_commit(method) }
      let(:callback) { :after_update }

      it_behaves_like 'after_commit_callback'
    end

    describe '#after_save_commit' do
      let(:execute_callback) { described_class.after_save_commit(method) }
      let(:callback) { :after_save }

      it_behaves_like 'after_commit_callback'
    end
  end
end
