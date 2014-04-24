require 'spec_helper'
require './lib/comments_repository'

describe CommentsRepository do

  before do
    DB[:posts].delete
    DB[:comments].delete
  end

  let(:post_id) { DB[:posts].insert :title => 'Test Post', :original_text => 'I am a blog post', :time => Time.now }
  let(:comments_repository) { CommentsRepository.new(DB, post_id) }

  describe 'creating a comment' do
    it 'inserts a record with the appropriate attributes scoped to the current post' do
      comments_repository.create :name => 'Test User', :comment => 'I am a comment'
      record = DB[:comments].first
      expect(record[:post_id]).to eq(post_id)
      expect(record[:name]).to eq('Test User')
      expect(record[:comment]).to eq('I am a comment')
    end
  end

  describe 'retrieving a list of comments' do
    it 'returns comments that belong to the current post' do
      comments_repository.create :name => 'Test User', :comment => 'I am a comment'
      expect(comments_repository.display_all.size).to eq(1)
    end

    describe 'when multiple posts exist' do
      let(:other_post_id) { DB[:posts].insert :title => 'Other Test Post', :original_text => 'I am also a blog post', :time => Time.now }
      let(:other_comments_repository) { CommentsRepository.new(DB, other_post_id) }

      before do
        other_comments_repository.create :name => 'Test User', :comment => 'I am a comment'
      end

      it 'does not return comments that belong to other posts' do
        expect(DB[:comments].count).to eq(1)
        expect(comments_repository.display_all.size).to eq(0)
      end
    end
  end

  describe 'editing a comment' do
    it 'edits a comment in the database' do
      id = comments_repository.create({:name => 'Test User', :comment => 'I am a comment'})
      comments_repository.update_by_id(id, {:name => 'Nate', :comment => 'New comment'})
      expect(comments_repository.get_comment_by_id(id).attributes).to include({:id => id, :name => 'Nate', :comment => 'New comment'})
      expect(comments_repository.get_comment_by_id(id).attributes[:time]).to be_within(1).of(Time.now)
    end
  end

  describe 'deleting a comment' do
    it 'deletes a comment from the database' do
      id = comments_repository.create :name => 'Test User', :comment => 'I am a comment'
      id2 = comments_repository.create :name => 'Test User', :comment => 'I am another comment'
      comments_repository.delete(id)
      expect(comments_repository.get_comment_by_id(id)).to eq nil
      expect(comments_repository.get_comment_by_id(id2).attributes).to include({:id => id2, :name => 'Test User', :comment => 'I am another comment'})
      expect(comments_repository.get_comment_by_id(id2).attributes[:time]).to be_within(1).of(Time.now)
    end
  end
end