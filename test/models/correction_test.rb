require 'test_helper'

class CorrectionTest < ActiveSupport::TestCase
  test 'create' do
    @solution = solutions(:homework_solution_one)
    assert @solution.valid?
    assert @solution.first_correction_created_at.nil?
    assert @solution.first_correction_author.nil?
    assert @solution.last_correction_created_at.nil?
    assert @solution.last_correction_author.nil?
    @correction = @solution.corrections.build(content: "13412341")
    @correction.teacher = @solution.solutionable.teacher
    @correction.save
    @solution.reload

    puts @solution.first_correction_created_at
    puts @correction.created_at
    puts @solution.first_correction_created_at == @correction.created_at
    assert @solution.first_correction_author_id     == @correction.author.id
    assert @solution.last_correction_created_at     == @correction.created_at
    assert @solution.last_correction_author_id      == @correction.author.id

  end
end
