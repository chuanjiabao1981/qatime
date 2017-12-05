module Exam
  # 中考试卷
  class JuniorPaper < Paper
    has_one :listen_selection # 听后选择
    has_one :listen_answer # 听后回答
    has_one :listen_write_report # 听后记录&转述
    has_one :listen_speak # 听后朗读

    has_many :groups

    after_create :init_topics
    def init_topics
      JuniorPaper.transaction do
        init_listen_selection
        init_listen_answer
        init_listen_write_report
        init_listen_speak
      end
    end

    private

    # 初始化听后选择
    def init_listen_selection
      create_listen_selection(name: 'Ⅰ听后选择', description: 'xxxxxxxx', total_time: 9 * 60, topics_count: 8, total_score: 12)
      8.times do |i|
        group = listen_selection.group_topics.create if i.even?
        group.topics.create(type: 'Exam::SingleChoiceTopic')
      end
    end

    # 初始化听后回答
    def init_listen_answer
      create_listen_answer(name: 'Ⅰ听后回答', description: 'xxxxxxxx', total_time: 9 * 60, topics_count: 8, total_score: 12)
      5.times do
        listen_selection.topics.create(type: 'Exam::ListenAnswerTopic')
      end
    end

    # 初始化听后记录&转述
    def init_listen_write_report
      create_listen_write_report
      package_topic = listen_write_report.package_topics.create
      group = package_topic.group_topics.create
      5.times do
        group.topics.create(type: 'Exam::ListenWriteTopic')
      end
      package_topic.topics.create(type: 'Exam::ListenReportTopic')
    end

    # 初始化朗读短文
    def init_listen_speak
      create_listen_answer
      listen_answer.topics.create(type: 'Exam::ListenSpeakTopic')
    end
  end
end
