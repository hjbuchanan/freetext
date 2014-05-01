require 'httparty'
require 'excon'
require 'vacuum'
require 'amazon/ecs'
require 'a2z'


class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new



  end




  # GET /books/1/edit
  def edit
  end



  # POST /books
  # POST /books.json
  def create
    # @book = Book.new(book_params)

    # respond_to do |format|
    #   if @book.save
    #     format.html { redirect_to @book, notice: 'Book was successfully created.' }
    #     format.json { render action: 'show', status: :created, location: @book }
    #   else
    #     format.html { render action: 'new' }
    #     format.json { render json: @book.errors, status: :unprocessable_entity }
    #   end
    # end



      @isbn = params[:book][:ISBN]
      search_term = params[:search] || "#{@isbn}"
      @res  = Amazon::Ecs.item_lookup(search_term,  { :search_index => 'Books', :id_type => "ISBN", :response_group => "ItemAttributes"})
      @imgs = Amazon::Ecs.item_lookup(search_term,  { :search_index => 'Books', :id_type => "ISBN", :response_group => 'Images',
                                                      :search_index => 'Books',
                                                      :sort => 'relevancerank' })
       puts @imgs.items.first.get_element('MediumImage').get('URL')
      # need to save author, title, publisher of first returned item
      @new_book = @res.items.first
      @book = Book.new
        @book.title = @res.items.first.get_element('ItemAttributes').get('Title')
        @book.author = @res.items.first.get_element('ItemAttributes').get('Author')
        @book.publisher = @res.items.first.get_element('ItemAttributes').get('Publisher')
        @book.url = @imgs.items.first.get_element('MediumImage').get('URL')
        @book.save


  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:author, :title, :publisher)
    end
end
