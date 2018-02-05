defmodule StackTest do
  use ExUnit.Case
  doctest Stack

  test "empty stack" do
    assert Stack.is_empty([]) == true
    assert Stack.is_empty(["1"]) == false
  end

  test "stack top" do
    assert Stack.top([1,2,3]) == 1
    assert Stack.top([1]) == 1
  end

  test "stack push" do
    newStack = Stack.push([], 1)
    assert [1] == newStack
    newStack = Stack.push(newStack, 2)
    assert [2, 1] == newStack
  end

  test "stack pop" do
    {head, newStack} = Stack.pop([1,2])
    assert head == 1
    assert newStack == [2]
    {head, newStack} = Stack.pop(newStack)
    assert head == 2
    assert newStack == []
  end

  test "stack size" do
    assert Stack.size([]) == 0
    assert Stack.size([1]) == 1
  end



end
