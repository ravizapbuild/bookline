class BooksRepresenter
  def initialize(books)
    @books = books
  end

  def as_json
    books.map do |book|
      {
        id: book.id,
        title: book.title,
        picture: book.picture,
        author_name: author_name(book),
        author_age: author_age(book)
      }
    end
  end

  private
  attr_reader :books

  def author_name(book)
    "#{book.author.name}"
  end

  def author_age(book)
    book.author.age
  end
end
