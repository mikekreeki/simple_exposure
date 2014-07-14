require 'spec_helper'

describe ApplicationController, type: :controller do
  let(:view) { controller.view_context }

  it 'loads the modules' do
    expect(described_class.ancestors).to include(SimpleExposure::Core)
  end

  it 'responds to #expose' do
    expect(described_class).to respond_to(:expose)
  end

  before do
    get :index
  end

  describe 'Default values' do
    it 'assigns default value' do
      expect(view.message).to eq 'Hello!'
    end

    it 'does not override provided values with default one' do
      expect(view.other_message).to eq 'Other message'
    end
  end

  describe 'Exposing controllers instance variables' do
    it 'exposes the value in ivar' do
      expect(view.ivar_message).to eq 'Hello!'
    end
  end

  describe 'Exposing private methods' do
    it 'exposes controllers private methods' do
      expect(view.current_user).to eq 'mikekreeki'
    end
  end

  describe 'Extensions' do
    it 'applies extension when value provided' do
      expect(view.decoratable_message).to eq 'Hello!'
    end

    it 'does not apply extension when value not provided' do
      expect(view.nil_value).to be_nil
    end
  end

  describe 'Extension shortcuts' do
    it 'quacks like a shortcut' do
      expect(described_class).to respond_to :decorate
    end

    it 'applies the extension when specified using a shortcut' do
      expect(view.other_user).to eq 'Andrew Bennett'
    end

    it 'takes additional extensions' do
      expect(view.combined_extension).to eq 'HELLO'
    end
  end
end
