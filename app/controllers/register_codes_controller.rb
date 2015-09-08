class RegisterCodesController < ApplicationController
  respond_to :html
  #layout "manager_home"

  def index
    @school = School.find(params[:school_id])
    @register_codes = RegisterCode.where(:school_id=> @school.id).paginate(page: params[:page],:per_page => 10)

    respond_to do |format|
      format.html
    end
  end
  def new
    @register_code = RegisterCode.new
  end

  def create
    ##这块遗留了问题，需要保证执行的一致性
    @school = School.find(params[:school_id])
    @number = params[:register_code][:number].to_i

    for value in 1..@number
      @register_code = RegisterCode.new
      @register_code.make_value
      @register_code.school = @school
      @register_code.save
    end
    redirect_to school_register_codes_path
  end

  def downloads
    ##这块遗留了问题，需要保证执行的一致性
    @school = School.find(params[:school_id])
    @register_codes = RegisterCode.where(:school_id=> @school.id, :state=>"available")
    current_time = Time.new()

    RegisterCode.where(:state => 'available').update_all(:batch_id => current_time)
    #这块不知道为啥，居然不能直接用excel打开，后续分析
    respond_to do |format|
      format.xls { send_data @register_codes.to_csv(col_sep: "\t") }
    end
  end

  def batch_make

  end
end