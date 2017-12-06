module Exam
  # 中考试卷
  class JuniorPaper < Paper
    PAPER_TEMPLATE = YAML.load(File.read(Rails.root.join('config', 'paper_templates', 'junior_paper.yml')))

    has_one :listen_selection # 听后选择
    has_one :listen_answer # 听后回答
    has_one :listen_write_report # 听后记录&转述
    has_one :listen_speak # 听后朗读

    has_many :groups

    private

    after_create :init_topics
    def init_topics
      update(PAPER_TEMPLATE)
    end
  end
end
