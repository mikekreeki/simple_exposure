require 'spec_helper'

describe SimpleExposure, type: :integration do
  it 'loads the modules' do
    expect(ActionController::Base.ancestors).to include(SimpleExposure::Core)
  end
end
