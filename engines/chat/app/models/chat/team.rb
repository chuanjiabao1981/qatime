module Chat
  class Team < ActiveRecord::Base

    belongs_to :live_studio_course, class_name: '::LiveStudio::Course'
    has_many :join_records
    has_many :accounts, through: :join_records

    validates :name, presence: true


    class << self
      # redis cache methods
      # 群组在线成员列表
      def online_members(team_id,md5_token)
        if md5_token && @redis.hget(team_id, :md5_token) == md5_token
        else
          @members =
              redis.hgetall("#{team_id}_visits").try(:map) do |acc_id, visit_time|
                if (Time.now - visit_time.to_time) < 30
                  acc_id
                end
              end
          @members.compact!
          unless @members.blank?
            md5_token = Digest::MD5.hexdigest(@members.join)
            redis.hset(team_id, :md5_token, md5_token)
            redis.hset(team_id, :members, @members.join(','))
          end
        end
        @members ||= redis.hget(team_id, :members)
        @members.to_a
      end

      def token(team_id)
        redis.hget(team_id, :md5_token)
      end

      # 更新访问群组时间
      def cache_member_visit(team_id,acc_id)
        redis.hset("#{team_id}_visits",acc_id,Time.now)
      end

      private
      def redis
        @redis ||= DataCache.redis
      end
    end
  end
end
