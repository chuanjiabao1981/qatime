class RegisterCodesController < ApplicationController
  respond_to :html
  #layout "manager_home"

  def index
    @school = School.find(params[:school_id])
    @register_codes = RegisterCode.where(:school_id=> @school.id).order(:created_at => "DESC").paginate(page: params[:page],:per_page => 10)

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

    begin
      @number = params[:register_code][:number]
      check_message = RegisterCode.batch_make(@number, @school)

      if "OK" != check_message
        @register_code ||= RegisterCode.new
        flash.now[:warning] = check_message
        render 'new'
      else
        redirect_to school_register_codes_path
      end
    rescue => err
      @err_message = err.to_s
      @register_code ||= RegisterCode.new
      flash.now[:warning] = @err_message
      render 'new'
    end
  end

  def downloads
    ##这块遗留了问题，需要保证执行的一致性
    @school = School.find(params[:school_id])

    @batch_id = params[:batch_id]
    @register_codes = RegisterCode.get_available_register_codes(@school, @batch_id)
    respond_to do |format|
      format.xls { send_data @register_codes.to_csv(col_sep: "\t") }
    end
  end
end