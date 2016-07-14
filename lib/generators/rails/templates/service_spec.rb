require 'rails_helper'

describe <%= class_name %> do
  def build(*_args)
    described_class.new(*_args)
  end

  pending "describe what your service does here"
end