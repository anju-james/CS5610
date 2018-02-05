defmodule StackTest do
  use ExUnit.Case
  doctest Stack

  test "empty stack" do
    assert Stack.is_empty([]) == true
    assert Stack.is_empty(["1"]) == false
  end

  test "stack top" do
    assert Stack.top([1, 2, 3]) == 1
    assert Stack.top([1]) == 1
  end

  test "stack push" do
    new_stack = Stack.push([], 1)
    assert [1] == new_stack
    new_stack = Stack.push(new_stack, 2)
    assert [2, 1] == new_stack
  end

  test "stack pop" do
    {head, new_stack} = Stack.pop([1, 2])
    assert head == 1
    assert new_stack == [2]
    {head, new_stack} = Stack.pop(new_stack)
    assert head == 2
    assert new_stack == []
  end

  test "stack size" do
    assert Stack.size([]) == 0
    assert Stack.size([1]) == 1
  end



end
