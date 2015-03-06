class TeachingProgramCell < Cell::Rails
  def nav
    @all_teaching_programs = TeachingProgram.all
    render
  end
end
