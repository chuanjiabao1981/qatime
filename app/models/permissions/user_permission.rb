module Permissions
  class UserPermission < BasePermission
    def initialize(user)

      allow :customized_course_message_boards,[:show] do |customized_course_message_board|
        customized_course_message_board and
            customized_course_message_board.customized_course.all_participants.include?(user.id)
      end
      allow :customized_course_messages,[:new,:create] do |customized_course_message_board|
        customized_course_message_board and customized_course_message_board.all_participants.include?(user.id)
      end
      allow :customized_course_messages,[:edit,:update] do |customized_course_message|
        customized_course_message and customized_course_message.author.id == user.id
      end
      allow :customized_course_messages,[:show] do |customized_course_message|
        customized_course_message and
            customized_course_message.customized_course_message_board.all_participants.include?(user.id)
      end

      allow :customized_course_message_replies,[:create] do |customized_course_message|
        customized_course_message and
            customized_course_message.customized_course_message_board.all_participants.include?(user.id)
      end

      allow :customized_course_message_replies,[:show] do |customized_course_message_reply|
        customized_course_message_reply and
            customized_course_message_reply.customized_course_message.customized_course_message_board.all_participants.include?(user.id)
      end
      allow :customized_course_message_replies,[:edit,:update] do |customized_course_message_reply|
        customized_course_message_reply and
            customized_course_message_reply.author.id == user.id
      end

      allow :notifications,[:show] do |notification|
        notification and notification.receiver_id == user.id
      end

      allow 'live_studio/courses', [:index, :taste, :play, :show]
    end
  end
end
