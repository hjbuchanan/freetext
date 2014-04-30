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
    # Amazon::Ecs.options = {
    #     :associate_tag => '427806390514',
    #     :AWS_access_key_id => 'AKIAI4CA4E7EODE7CRWA',
    #     :AWS_secret_key => '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'
    #   }
    #   # res = Amazon::Ecs.item_lookup('9780521153348', :response_group => 'ItemAttributes', :id_type => 'ISBN', :search_index => 'Books')
    #   #   res.each do |item|
    #   #     item_attributes = item.get_element('ItemAttributes')
    #   #     item_attributes.get('Title')
    #   #   end
    #   # @isbn = params[:book][:isbn]
    #   @book[:ISBN]
    #   @isbnn = @book[:ISBN]
    #   search_term = params[:search] || "#{@isbn}"
    #   @res  = Amazon::Ecs.item_lookup(search_term,  { :search_index => 'Books', :id_type => "ISBN", :response_group => "ItemAttributes"})
    #   @imgs = Amazon::Ecs.item_lookup(search_term,  { :search_index => 'Books', :id_type => "ISBN", :response_group => 'Images',
    #                                                   :search_index => 'Books',
    #                                                   :sort => 'relevancerank' })

    #   # need to save author, title, publisher of first returned item
    #   @new_book = @res.items.first
    #     @book.title = @res.items.first.get_element('ItemAttributes').get('Title')
    #     @book.author = @res.items.first.get_element('ItemAttributes').get('Author')
    #     @book.publisher = @res.items.first.get_element('ItemAttributes').get('Publisher')
    #     @book.save


  end

  # def lookup
  #    Amazon::Ecs.options = {
  #       :associate_tag => '427806390514',
  #       :AWS_access_key_id => 'AKIAI4CA4E7EODE7CRWA',
  #       :AWS_secret_key => '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'
  #     }
  #     # res = Amazon::Ecs.item_lookup('9780521153348', :response_group => 'ItemAttributes', :id_type => 'ISBN', :search_index => 'Books')
  #     #   res.each do |item|
  #     #     item_attributes = item.get_element('ItemAttributes')
  #     #     item_attributes.get('Title')
  #     #   end
  #     # @isbn = params[:book][:isbn]
  #     @book[:ISBN]
  #     @isbn = @book[:ISBN]
  #     search_term = params[:search] || "#{@isbn}"
  #     @res  = Amazon::Ecs.item_lookup(search_term,  { :search_index => 'Books', :id_type => "ISBN", :response_group => "ItemAttributes"})
  #     @imgs = Amazon::Ecs.item_lookup(search_term,  { :search_index => 'Books', :id_type => "ISBN", :response_group => 'Images',
  #                                                     :search_index => 'Books',
  #                                                     :sort => 'relevancerank' })

  #     # need to save author, title, publisher of first returned item
  #     @new_book = @res.items.first
  #       @book.title = @res.items.first.get_element('ItemAttributes').get('Title')
  #       @book.author = @res.items.first.get_element('ItemAttributes').get('Author')
  #       @book.publisher = @res.items.first.get_element('ItemAttributes').get('Publisher')
  #       @book.save
  # end


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
    Amazon::Ecs.options = {
        :associate_tag => '427806390514',
        :AWS_access_key_id => 'AKIAI4CA4E7EODE7CRWA',
        :AWS_secret_key => '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'
      }


      @isbn = params[:book][:ISBN]
      search_term = params[:search] || "#{@isbn}"
      @res  = Amazon::Ecs.item_lookup(search_term,  { :search_index => 'Books', :id_type => "ISBN", :response_group => "ItemAttributes"})
      @imgs = Amazon::Ecs.item_lookup(search_term,  { :search_index => 'Books', :id_type => "ISBN", :response_group => 'Images',
                                                      :search_index => 'Books',
                                                      :sort => 'relevancerank' })
      # puts @res.items
      # need to save author, title, publisher of first returned item
      @new_book = @res.items.first
      @book = Book.new
        @book.title = @res.items.first.get_element('ItemAttributes').get('Title')
        @book.author = @res.items.first.get_element('ItemAttributes').get('Author')
        @book.publisher = @res.items.first.get_element('ItemAttributes').get('Publisher')
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
