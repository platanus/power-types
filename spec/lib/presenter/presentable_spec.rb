require 'spec_helper'

describe PowerTypes::Presentable do
  let(:presenter_class) do
    Class.new(PowerTypes::BasePresenter) do
      def presenter_method
        h.view_method + external_param + another_presenter_method
      end

      private

      def another_presenter_method
        "C"
      end
    end
  end

  let(:presentable_host) do
    Class.new do
      include PowerTypes::Presentable

      def view_context
        view = OpenStruct.new
        view.view_method = "A"
        view
      end
    end.new
  end

  let(:presenter_name) { :users_show_presenter }
  let(:params) do
    {
      external_param: "B"
    }
  end

  before do
    stub_const("UsersShowPresenter", presenter_class)
  end

  def presenter
    presentable_host.present_with(presenter_name, params)
  end

  it { expect(presenter).to be_a(UsersShowPresenter) }
  it { expect(presenter.presenter_method).to eq("ABC") }

  context "with invalid presenter name" do
    let(:presenter_name) { :ivalid_presenter }
    let(:error) { "missing IvalidPresenter presenter class" }

    it { expect { presenter }.to raise_error(PowerTypes::PresenterError, error) }
  end

  context "with params trying to define attributes already exist in presenter" do
    let(:params) do
      {
        another_presenter_method: "D"
      }
    end

    let(:error) { "attribute another_presenter_method already defined in presenter" }

    it { expect { presenter }.to raise_error(PowerTypes::PresenterError, error) }
  end
end
