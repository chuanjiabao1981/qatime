class TeachingProgramCell < Cell::ViewModel
  def nav
    @all_teaching_programs = TeachingProgram.all
    render
  end
end
