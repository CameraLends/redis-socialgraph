class Redis
  class Socialgraph

    def self.key(user_id)
      "redis_friends:#{ user_id }"
    end

    # Transactionally and reciprocally adds 1 or more friends to a user
    def self.sync_friend_ids(user_id, friend_ids)
      REDIS.multi do
        REDIS.sadd key(user_id), friend_ids
        [*friend_ids].each { |friend_id| REDIS.sadd key(friend_id), user_id }
      end
    end

    # For the given user id returns an Array of friend ids
    def self.friend_ids(user_id)
      REDIS.smembers(key(user_id)).map(&:to_i)
    end

    def self.friends_of_friends_ids(user_id)
      keys = ([user_id] + friend_ids(user_id)).map do |id|
        key(id)
       end
      REDIS.sunion(keys).map(&:to_i) - [user_id]
    end

    # Returns an Array representing the mutual friends between two users
    def self.mutual_friends(a, b)
      REDIS.sinter(key(a), key(b)).map(&:to_i)
    end

    # For the given user id returns a Hash where keys are the provided friend 
    # ids and values are the mutual friends between the key and user.
    def self.multiple_mutual_friends(user_id, friend_ids)
      friend_ids.inject({}) do |acc, friend_id|
        acc.merge friend_id => mutual_friends(user_id, friend_id)
      end
    end

  end
end
