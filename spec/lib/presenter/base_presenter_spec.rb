require 'spec_helper'

# rubocop:disable RSpec/AnyInstance, RSpec/VerifiedDoubles
describe PowerTypes::BasePresenter do
  let(:view) { double(view_method: 2) }
  let(:decorated_object) { double }
  let(:decorable_instance) { double(decorate: decorated_object) }
  let(:params) do
    {
      simple_param: 1,
      decorated_param: decorable_instance
    }
  end

  let(:presenter) do
    described_class.new(view, params)
  end

  it { expect(presenter).to be_a(PowerTypes::BasePresenter) }
  it { expect(presenter.simple_param).to eq(1) }
  it { expect(presenter.decorated_param).to eq(decorated_object) }
  it { expect(presenter.send(:h).view_method).to eq(2) }

  context "with already defined presenter method" do
    let(:error) { "attribute simple_param already defined in presenter" }

    before do
      allow_any_instance_of(PowerTypes::BasePresenter).to receive(:respond_to?)
        .and_return(true)
    end

    it { expect { presenter }.to raise_error(PowerTypes::PresenterError, error) }
  end
end
# rubocop:enable RSpec/AnyInstance, RSpec/VerifiedDoubles
