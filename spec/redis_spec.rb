require File.dirname(__FILE__) + '/spec_helper'

describe "redis" do
  before(:all) do
    REDIS = MockRedis.new

    @jenny  = 8675309
    @jackie = 42
    @jean   = 24601
    @andy   = 37927
    @nelson = 46664
  end

  before(:each) do
    REDIS.flushdb
  end

  after(:each) do
    REDIS.flushdb
  end

  after(:all) do
    REDIS.quit
  end

  it "should namespace keys" do
    Redis::Socialgraph.sync_friend_ids(@jenny, @jean)
    REDIS.exists("redis_friends:#{ @jenny }").should be_true
    REDIS.exists("redis_friends:#{ @nelson }").should be_false
  end

  it "should create a link between a user and another user" do
    response = Redis::Socialgraph.sync_friend_ids(@jenny, @jean)
    response.length.should == 2
    response.all?.should be_true
  end

  it "should create a link between a user and multiple other users" do
    response = Redis::Socialgraph.sync_friend_ids(@jenny, [@jean, @andy])
    response.length.should == 3
    response.all?.should be_true
  end

  it "should allow links for a user to be retrieved" do
    Redis::Socialgraph.sync_friend_ids(@jenny, [@nelson, @andy])

    response = Redis::Socialgraph.friend_ids(@jenny)
    response.length.should == 2
    response.should include(@nelson, @andy)
  end

  it "should allow common links between a user and another user to be retrieved" do
    Redis::Socialgraph.sync_friend_ids(@jenny, @andy)
    Redis::Socialgraph.sync_friend_ids(@nelson, [@jean, @andy])

    response = Redis::Socialgraph.mutual_friends(@jenny, @nelson)
    response.length.should == 1
    response.should include(@andy)
  end

  it "should allow common links between a user and multiple users to be retrieved" do
    Redis::Socialgraph.sync_friend_ids(@jenny, @andy)
    Redis::Socialgraph.sync_friend_ids(@jackie, [@jean, @andy])
    Redis::Socialgraph.sync_friend_ids(@nelson, [@jenny, @jean, @jackie])

    # therefore friends with redundancies are:
    #    andy:   jackie, jenny
    #    jackie: andy, jean, nelson
    #    jean:   jackie, nelson
    #    jenny:  andy, nelson
    #    nelson: jackie, jean, jenny

    # and from jackie's pov, mutual friends are:
    #    w/ andy:   nil
    #    w/ jean:   nelson
    #    w/ jenny:  andy, nelson
    #    w/ nelson: jean

    response = Redis::Socialgraph.multiple_mutual_friends(@jackie, [@andy, @jean, @jenny, @nelson])
    response.length.should == 4

    response.should include(@andy   => [])
    response.should include(@jean   => [@nelson])
    response.should include(@jenny  => [@andy, @nelson])
    response.should include(@nelson => [@jean])
  end

end