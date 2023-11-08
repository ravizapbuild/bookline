# This code is a test case written using the RSpec testing framework for a Books API in a Ruby on Rails application.
require 'rails_helper'

describe 'Books API', type: :request do

  describe 'GET /books' do
    let(:author_first) { FactoryBot.create(:author, name: "Andy Weir", age: 48)}
    let(:author_second) { FactoryBot.create(:author, name: "Frank Schätzing", age: 63)}

    it 'returns all books' do
      FactoryBot.create(:book, title: 'The Martian', author: author_first)
      FactoryBot.create(:book, title: 'Living Hell', author: author_second)
      get '/api/v1/books'
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(2)
      expect(JSON.parse(response.body)[0]['title']).to eq('The Martian')
    end

    it 'returns a subset of books based on limit' do
      FactoryBot.create(:book, title: 'The Martian', author: author_first)
      FactoryBot.create(:book, title: 'Living Hell', author: author_second)
      get '/api/v1/books', params: { limit: 1 }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(1)
    end

    it 'returns a subset of books based on limit and the offset' do
      FactoryBot.create(:book, title: 'The Martian', author: author_first)
      FactoryBot.create(:book, title: 'Living Hell', author: author_second)
      get '/api/v1/books', params: {limit: 2, offset: 1}
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(1)
    end

    it 'return a max limit of 100' do
      expect(Book).to receive(:limit).with(100).and_call_original

      get '/api/v1/books', params: {limit: 200}
    end

  end

  describe 'POST /books' do
    it 'create a new book' do
      expect {
        post '/api/v1/books/', params:{book: {
          title: 'The Martian'}, author: {name: 'Andy Weir', age: 48}}
    }.to change { Book.count }.from(0).to(1)
      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
    end
  end

  describe 'DELETE /books/:id' do
    let(:author) { FactoryBot.create(:author, name: "Andy Weir", age: 48)}

    # 1.
    # let(:book) { FactoryBot.create(:book, title: "The Martian", author: "Andy Weir") }
    # it "deletes a book" do
    #   delete "/api/v1/books/#{book.id}"
    #   expect(response).to have_http_status(:no_content)
    # end

    # 2.
    let!(:book) { FactoryBot.create(:book, title: "The Martian", author: author) }
    it 'deletes a book' do
      expect {
        delete "/api/v1/books/#{book.id}"
    }.to change { Book.count }.from(1).to(0)
      expect(response).to have_http_status(:no_content)
    end
  end
end
