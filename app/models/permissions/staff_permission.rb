module Permissions
  class StaffPermission < BasePermission
    def initialize(user)
      allow :customized_course_message_boards, [:show] do |customized_course_message_board|
        customized_course_message_board
      end

      allow :customized_course_messages, [:show] do |customized_course_message|
        customized_course_message
      end

      allow :customized_course_message_replies, [:show] do |customized_course_message_reply|
        customized_course_message_reply
      end

      allow :notifications, [:show] do |notification|
        notification
      end
    end
  end
end
