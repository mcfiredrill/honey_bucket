defmodule HoneyBucketTest do
  use ExUnit.Case
  doctest HoneyBucket

  test "greets the world" do
    assert HoneyBucket.hello() == :world
  end
end
