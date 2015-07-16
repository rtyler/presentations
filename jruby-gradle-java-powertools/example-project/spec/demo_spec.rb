require 'java'
require 'spec_helper'

java_import 'com.github.rtyler.presentations.Demo'

describe Demo do
  it { should respond_to :echo }

  describe '.echo' do
    it 'should give me my string back' do
      expect(subject.echo('hi')).to eql('echoing "hi"')
    end
  end
end
