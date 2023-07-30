class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  def new
    @book = Book.new
  end
  
  def show
    @book = Book.find(params[:id])  
    @user = @book.user
    @newbook = Book.new
  end
  
  def create
    # １. データを受け取り新規登録するためのインスタンス作成
    @books = Book.all
    @user =current_user
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    # 2. データをデータベースに保存するためのsaveメソッド実行
    if @book.save
      # 3. フラッシュメッセージを定義し、詳細画面へリダイレクト
      flash[:notice] = "Book was successfully created."
      redirect_to book_path(@book.id)
    else
      # @user =current_user
      # @books = Book.all
      render :index
    end
  end
  
  def index
    @user =current_user
    @books = Book.all
    @book = Book.new
  end
  
  def edit
    @book = Book.new
    @book = Book.find(params[:id])
  end
  
  def update
    @book = Book.new
    @book = Book.find(params[:id])
    if @book.update(book_params)
    flash[:notice] = "You have updated book successfully."
    redirect_to book_path(@book.id)
    else
      render :edit
    end
  end
  
  def destroy
    book = Book.find(params[:id])  # データ（レコード）を1件取得
    book.destroy  # データ（レコード）を削除
    redirect_to '/books'  # 投稿一覧画面へリダイレクト  
  end
  
  private
  # ストロングパラメータ
  def book_params
    params.require(:book).permit(:title, :body, :user_id)
  end
  
  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user.id == current_user.id
    redirect_to books_path
    end
  end
end
