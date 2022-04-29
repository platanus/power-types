require 'spec_helper'

describe PowerTypes::Observable do
  before(:context) do
    class KlassObserver < PowerTypes::Observer
    end

    class BaseKlass
      def _run_save_callbacks
        "save"
      end

      def _run_create_callbacks
        "create"
      end

      def _run_update_callbacks
        "update"
      end

      def _run_destroy_callbacks
        "destroy"
      end

      def _run_commit_callbacks
        "commit"
      end
    end

    class Klass < BaseKlass
      include PowerTypes::Observable
    end

    @object = Klass.new
  end

  it { expect(Klass.observers.count).to eq(1) }

  PowerTypes::Util::OBSERVABLE_EVENTS.each do |event|
    it "calls #{event} related callbacks" do
      expect(KlassObserver).to(receive(:trigger).with(:before, event, @object).and_return(:true))
      expect(KlassObserver).to(receive(:trigger).with(:after, event, @object).and_return(:true))

      expect(@object.send("_run_#{event}_callbacks")).to eq(event.to_s)
    end
  end
end
