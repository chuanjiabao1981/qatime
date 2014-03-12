#code:utf-8
class Cpanel::TutorialsController <  Cpanel::ApplicationController
  respond_to :html
  def index
    @tutorials = Tutorial.all
  end

  def new
    @tutorial     = Tutorial.new_with_find_media
  end
  def create
    @tutorial           = Tutorial.new_with_find_media(params[:tutorial].permit!)
    @tutorial.author    = current_user
    @tutorial.save
    respond_with :cpanel,@tutorial
  end
  def show
    @tutorial = Tutorial.find(params[:id])
  end

  def edit
    @tutorial = Tutorial.find(params[:id])
  end

  def update
    @tutorial = Tutorial.find(params[:id])
    #这里没有考虑更新cover 原因是
    #tutorial和cover是一对一的，在创建tutorial的时候cover已经在数据库中且外键已经指向tutorial
    #video的原因是类似的。但是对于一对多的情况就不适用了。
    @tutorial.update_attributes(params[:tutorial].permit!)
    respond_with :cpanel,@tutorial
  end
end
