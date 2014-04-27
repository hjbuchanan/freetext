require 'httparty'
require 'excon'
require 'vacuum'
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
    # @book = Book.new
    client = A2z::Client.new(key: 'AKIAI6MPLS2WWOQTVEIQ', secret: 'FWoxytU5eFfP2vJwidj8s0gLJz5oF4IQCppAPfG', tag: '286193100284')

    response = client.item_lookup do
      category 'Books'
      id '9780590353403'
      id_type 'ISBN'
    end
    return response
    # req = Vacuum.new

    # req.configure (
    # {aws_access_key_id:'AKIAI6MPLS2WWOQTVEIQ',
    # aws_secret_access_key:'FWoxytU5eFfP2vJwidj8s0gLJz5oF4IQCppAPfG',
    # associate_tag:'286193100284' }
    # )


    # params = {
    #   'SearchIndex' => 'Books',
    #   'Keywords'    => 'Architecture',
    # }

    # res = req.item_search(query: params)

    # req.build operation:    'ItemSearch',
    #   search_index: 'Books',
    #   keywords:     'Deleuze'

    # res = req.get

    # params = {
    #   'SearchIndex' => 'Books',
    #   'Keywords'    => 'Architecture'
    # }

    # res = req.item_lookup(query: params)
    # params = {
    #   'SearchIndex' => 'Books',
    #   'IdType'    => 'ISBN',
    #   'ItemID'    => '9780590353403'
    # }
    # #403 error, request forbidden. something about my params?
    # res = req.item_lookup(query: params)
    # puts res
    # want to query the api with the given isbn, take that the first set of information from the query and create a new country

      # response = HTTParty.get('http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&Operation=ItemLookup&SubscriptionId=AKIAI6MPLS2WWOQTVEIQ&AssociateTag=286193100284&Version=2011-08-01&ItemId=9788478888566&IdType=ISBN&SearchIndex=Books&Condition=All&ResponseGroup=Images,ItemAttributes,Offers')
      # @data_returned = response.parsed_response



  end

  # GET /books/1/edit
  def edit
  end

  # def get_book_info
  #   @response = HTTPpart.get('http://webservices.amazon.com/onca/xml?Service=AWSECommerceService&Operation=ItemLookup&SubscriptionId=AKIAI6MPLS2WWOQTVEIQ&AssociateTag=286193100284&Version=2011-08-01&ItemId=9788478888566&IdType=ISBN&SearchIndex=Books&Condition=All&ResponseGroup=Images,ItemAttributes,Offers')
  #   data = @response.parsed_response
  #   puts data['title']
  # end


  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render action: 'show', status: :created, location: @book }
      else
        format.html { render action: 'new' }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
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
