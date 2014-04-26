require 'spec_helper'
require 'keen_publisher'

describe KeenPublisher do

  before do
    @keen_publisher = KeenPublisher.new(:testing, {:test => 'testing', :another_test => 'test'})
  end

  after do
    @keen_publisher.delete(:testing)
  end

  it 'can publish events to Keen' do
    expect(@keen_publisher.publish).to eq({"created" => true})
  end

end

