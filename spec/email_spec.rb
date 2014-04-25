require 'spec_helper'
require 'email'

describe Email do

  before do
    Mail.defaults do
      delivery_method :test
    end
  end

  it 'can send an email' do

    email = Email.new

    email.send({:to => 'mikel@me.com', :from => 'nathanael.burt@gmail.com', :subject => 'testing', :body => 'hello'})

    expect(Mail::TestMailer.deliveries.length).to eq 1
  end

end