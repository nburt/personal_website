require 'spec_helper'
require 'users_repository'

describe UsersRepository do

  let(:users_repository) { UsersRepository.new(DB) }

  it 'can create a new user and return a keen id' do
    id = users_repository.create_user
    expect(users_repository.get_keen_id(id)).to_not eq nil
  end
end