class SectionCell < Cell::Rails

  def topics_head_nav(args)
    @selected_section_id         = args[:selected_section_id]
    @sections                     = Section.all.order(:id)
    @selected_section_id       ||= @sections[0].id unless @sections.empty?
    render
  end

  def topics_bottom_nav
    @sections                 = Section.all.order(:id)
    render
  end

end
