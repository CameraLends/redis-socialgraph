module RedisFriends
  def self.key user_id
    "redis_friends:#{ user_id }"
  end

  def self.sync_friend_ids user_id, friend_ids
    REDIS.multi do
      REDIS.sadd key(user_id), friend_ids
      friend_ids.each { |friend_id| REDIS.sadd key(friend_id), user_id }
    end
  end

  def self.friend_ids user_id
    REDIS.smembers(key(user_id)).map(&:to_i)
  end

  def self.mutual_friends a, b
    REDIS.sinter(key(a), key(b)).map(&:to_i)
  end

  def self.multiple_mutual_friends user_id, friend_ids
    friend_ids.inject({}) do |acc, friend_id|
      acc.merge friend_id => mutual_friends(user_id, friend_id)
    end
  end
end
