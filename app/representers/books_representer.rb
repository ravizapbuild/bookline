class BooksRepresenter
  def initialize(books)
    @books = books
  end

  def book_count
    books.count
  end

  def single_book
    {
      id: books.id,
      title: books.title,
      picture: books.picture,
      author_name: author_name(books),
      author_age: author_age(books)
    }
  end

  def as_json
    b = books.map do |book|
      {
        id: book.id,
        title: book.title,
        picture: book.picture,
        author_name: author_name(book),
        author_age: author_age(book)
      }
    end
    return b
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
