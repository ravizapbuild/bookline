require 'csv'

module Api
  module V1
    class BooksController < ApplicationController
      before_action :authenticate_request!, only: [:show, :create, :update, :destroy]

      def index
        # The `index` function returns all books in JSON format.
        # UpdateskuJob.perform_later("Hello World")
        books = Book.limit(limit).offset(params[:offset])

        render json: BooksRepresenter.new(books).to_json
        # render json.extract! books, :id, :title, :description, :picture, :created_at, :updated_at
      end

      def show
        # The function retrieves a book object with a specific ID and renders it as JSON.
        begin
          book = Book.find(params[:id])
        rescue => exception
          # If the book is not found, the function returns a 404 error.
          puts exception
          render json: { error: "Book not found" }, status: :not_found
        else
          # If the book is found, the function returns the book as JSON.
          render json: book
        end
      end

      def create

        # 1.
        # book = Book.new(title: params[:title], author: params[:author])

        # if book.save
        #   render json: book, status: :created
        # else
        #   render json: { error: book.errors }, status: :unprocessable_entity
        # end

        # 2.
        # Book.create!(book_params)
        # head :created

        # 3.
        author = Author.create!(author_params)

        if author.save
          book = Book.new(book_params.merge(author_id: author.id))
          if book.save
            # Opening a file
            file_path = Rails.root.to_s+ "/public" + book.picture.url
            csv_text = File.read(file_path)
            csv = CSV.parse(csv_text, headers: true)
            csv.each do |row|
              book = Book.new
              book.title = row["title"]
              book.author = Author.find(row["author"])
              book.save
            end
            render json: book, status: :created
          else
            render json: { error: book.errors }, status: :unprocessable_entity
          end
        else
          render json: { error: author.errors }, status: :unprocessable_entity
        end
      end

      def update
        Book.find(params[:id]).update!(book_params)
        head :no_content
      end

      def destroy
        # 1.
        # Book.find(params[:id]).destroy!
        # head :no_content

        # 2.
        # begin
        #   book = Book.find(params[:id])
        # rescue => exception
        #   # If the book is not found, the function returns a 404 error.
        #   render json: { error: exception }, status: :not_found
        # else
        #   # If the book is found, the function returns the book as JSON.
        #   book.destroy!
        #   head :no_content
        # end

        # 3.
        Book.find(params[:id]).destroy!
        head :no_content
      end

      def book_params
        params.require(:book).permit(:title, :picture, :author_id)
      end

      def author_params
        params.require(:author).permit(:name, :age)
      end

      private
      def limit
        [params.fetch(:limit, 100).to_i, 100].min
      end

    end
  end
end
