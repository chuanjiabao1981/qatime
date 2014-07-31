class FaqsController < ApplicationController

  def show
    @faq = Faq.find(params[:id])
  end

  def destroy
    @faq = Faq.find(params[:id])
    @faq.destroy
    redirect_to root_path
  end

  def edit
    @faq = Faq.find(params[:id])
  end

  def update
    @faq = Faq.find(params[:id])
    if @faq.update_attributes(params[:faq].permit!)
      redirect_to faq_path(@faq)
    else
      render 'edit'
    end
  end
end