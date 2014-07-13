require 'spec_helper'

describe SimpleExposure, type: :integration do
  it 'loads the modules' do
    expect(ActionController::Base.ancestors).to include(SimpleExposure::Core)
  end

  let(:controller) { ApplicationController.new }

  it 'can see the content' do
    visit '/'

    controller.index

    expect(page).to have_content controller.send(:message)
    expect(page).to have_content controller.send(:current_user)
    expect(page).to have_content controller.send(:posts_count)
  end


end
