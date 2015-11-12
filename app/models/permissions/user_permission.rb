module Permissions
  class UserPermission < BasePermission
    def initialize(user)

      allow :customized_course_message_boards,[:show] do |customized_course_message_board|
        customized_course_message_board and
            customized_course_message_board.customized_course.all_participants.include?(user.id)
      end
      allow :customized_course_messages,[:new] do |customized_course_message_board|
        customized_course_message_board and customized_course_message_board.all_participants.include?(user.id)
      end

    end

  end
end