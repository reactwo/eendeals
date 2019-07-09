class Api::App::CategoriesController < Api::AppController

  def index
    render json: Category.all, each_serializer: CategorySerializer, scope: {
        refer_id: params[:refer_id]
    }
  end

  def show
    category = Category.find_by_id params[:id]
    if category
      render json: category.wallpapers.paginate(per_page: 12, page: params[:page])
    else
      render json: { status: false }
    end
  end

  def homepage
    recent = ActiveModelSerializers::SerializableResource.new(Wallpaper.order(id: :desc).limit(4))
    hot = ActiveModelSerializers::SerializableResource.new(Wallpaper.order('RAND(id)').limit(4))
    liked = hot
    downloaded = ActiveModelSerializers::SerializableResource.new(Wallpaper.order(downloaded: :desc).limit(4))

    render json: { recent: recent, hot: hot, downloaded: downloaded, liked: liked }
  end

end
