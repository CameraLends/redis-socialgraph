# Redis::Socialgraph

Implements a simple social graph storage and retrieval using Redis. Every key
corresponds to a user ID (internal user ID, Facebook user ID, etc),
and the value is a list of their friends. Redis::Socialgraph exposes a simple
interface to loading this information into redis and common queries, like
mutual friends and friends-of-friends.

## Installation

Add this line to your application's Gemfile:

    gem 'redis-socialgraph'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis-socialgraph

## Usage

    require 'redis/socialgraph'

    friend_ids = Redis::Socialgraph.friend_ids(current_user.fbuid)
    > [150100454, 1588785989, 5517425, 15500300, ... ]

    friend_of_friend_fbuids = Redis::Socialgraph.friends_of_friends_ids(current_user.fbuid)
    > [1036350018, 15508452, 1016054663, ... ]

    # two users don't know each other, but could have friends in common
    mutual_friends = RedisSocialgraph.mutual_friends current_user.fbuid,
                                                     author.fbuid
    puts "You're connected to the author through: #{ mutual_friends.join(',') }"

    # for a list of user IDs (authors, renters, photographers, etc), return
    # a hash where the key is the user ID, and the value is a list of mutual
    # friends
    mutual_friends =
      Redis::Socialgraph.multiple_mutual_friends(current_user.fbuid, authors)
    mutual_friends.each do |user_id, mutual_friend_ids|
      puts "Connected to #{ user_id } through #{ mutual_friend_ids }"
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
