require 'spec_helper'

describe SimpleExposure::Core do
  let(:controller) { ApplicationController.new }

  it 'responds to #expose' do
    expect(controller.class).to respond_to(:expose)
  end
end
